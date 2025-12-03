# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: cimq025.4gl
# Descriptions...: 料件领用查询
# Date & Author..: darcy:2025/11/25 add


database ds
globals "../../../tiptop/config/top.global"
# type s---

define g_rec_b,g_cnt,l_ac,l_ac_t integer
define g_wc,g_cmd string
define g_argv1  varchar(40)

MAIN
    define   p_row,p_col   like type_file.num5  
    options             
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if

    let g_cmd = "echo ' cimq025' >> /u1/out/darcy.txt"
    run  g_cmd
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CIM")) then
        exit program
    end if

    call cl_used(g_prog,g_time,1) returning g_time 
    
    let g_argv1 = ARG_VAL(1)
    let g_cmd = "echo ' cimq025 ",g_argv1,"' >> /u1/out/darcy.txt"
    run  g_cmd
    call cimq020()

    call cl_used(g_prog,g_time,2) returning g_time 

END MAIN

function cimq020()
    define l_sql string
    define l_sum,l_amt like tlf_file.tlf221
    define l_yy,l_mm,l_cnt integer

    call cl_log(g_prog,"i",g_argv1,"begin")

    if cl_null(g_argv1) then
        return
    end if

    select count(*) into l_cnt from material_issue
     where uuid = g_argv1
    if l_cnt > 0 then
        return
    end if

    let g_success = 'Y'
    begin work

    #Step1. 获取年份
    select ccz01,ccz02 into l_yy,l_mm from ccz_file
    select count(*) into l_cnt from ccc_file where ccc02 = l_yy and ccc03 = l_mm
    if l_cnt = 0 or cl_null(l_cnt) then
        let l_mm = iif(l_mm==1,12,l_mm-1)
        let l_yy = iif(l_mm=01,l_yy-1,l_yy)
    end if

    #Step2. 插入基础表
    # 所有工单物料领用（asfi5*）
    let l_sql = "
    insert into material_issue(uuid,gen_dat,item_no,dat,tim,doc_no,seq,reason,doc_source,wo_no,usr,
                                part,price,price_source,qty,unit,amt,typ ) 
    select ?,?,tlf01, tlf06, tlf08 tim, tlf905, tlf906, tlf14, tlf13, tlf62, tlf09,
           tlf19, 0, '', -trunc(tlf10 * tlf60 * tlf907, 3) tlf10, ima25, 0, 'H' typ
      from tlf_file
      left join ima_file
        on ima01 = tlf01
      left join imz_file
        on imz01 = ima06
      left join azf_file
        on azf01 = tlf14
     where tlf13 != 'aimt324'
       and (tlf907 = '-1' or (tlf907 = '1' and tlf13 like 'asfi5%'))
       and tlf06 >= trunc(sysdate, 'mm')
       and tlf06 <= trunc(sysdate)
       and tlf13 in ('aimt301', 'aimt311')
       and tlf14 not in ('3002', '3003', '3013', '3014')
       and tlf01 like 'H.%' "
    prepare cimq025_ins_h from l_sql
    execute cimq025_ins_h using g_argv1,g_today
    if sqlca.sqlcode then
        let g_success = 'N'
        call cl_log(g_prog,"i","cimq025_ins_h",sqlca.sqlcode)
        goto _error
    end if
    # 杂项领用（去掉研发、模具、办公、固定资产）
    let l_sql = "
    insert into material_issue(uuid,gen_dat,item_no,dat,tim,doc_no,seq,reason,doc_source,wo_no,usr,
                                part,price,price_source,qty,unit,amt,typ ) 
    select ?,?,tlf01, tlf06, tlf08 tim, tlf905, tlf906, tlf14, tlf13, tlf62, tlf09,
           tlf19, 0, '', -trunc(tlf10 * tlf60 * tlf907, 3) tlf10, ima25, 0, 'M' typ
      from tlf_file
      left join ima_file
        on ima01 = tlf01
      left join imz_file
        on imz01 = ima06
      left join azf_file
        on azf01 = tlf14
     where tlf13 != 'aimt324'
       and (tlf907 = '-1' or (tlf907 = '1' and tlf13 like 'asfi5%'))
       and tlf06 >= trunc(sysdate, 'mm')
       and tlf06 <= trunc(sysdate)
       and tlf13 like 'asfi5%'
       and instr(tlf01 ,'.') > 0  
       and substr(tlf01,1,2) not in ('E.','K.')"
    prepare cimq025_ins_m from l_sql
    execute cimq025_ins_m using g_argv1,g_today
    if sqlca.sqlcode then
        let g_success = 'N'
        call cl_log(g_prog,"i","cimq025_ins_m",sqlca.sqlcode)
        goto _error
    end if

    # Step3. 更新人员和部门编号
    let l_sql = "
    merge into material_issue a using (
    select unique doc_no,coalesce(ina11,sfp16,rvu07,oga14) gen01, 
           coalesce(ina04,sfp07,rvu06,oga15) gem01 from material_issue
      left join ina_file on ina01 = doc_no and doc_source like 'aimt%'
      left join sfp_file on sfp01 = doc_no and doc_source like 'asfi%'
      left join rvu_file on rvu01 = doc_no and doc_source like 'apmt%'
      left join oga_file on oga01 = doc_no and doc_source like 'axmt%') b
    on (a.doc_no = b.doc_no and a.uuid = ?) 
    when matched then update set a.usr = b.gen01 , a.part = b.gem01"
    prepare cimq025_upd_usr from l_sql
    execute cimq025_upd_usr using g_argv1
    if sqlca.sqlcode then
        let g_success = 'N'
        call cl_log(g_prog,"i","cimq025_upd_usr",sqlca.sqlcode)
        goto _error
    end if

    # Step4. 更新单价
    # 采购单价
    let l_sql = "
    merge into material_issue a 
    using (select ima01, ima53 / ima44_fac ima53 from ima_file) b 
       on (a.uuid = ? and a.item_no = b.ima01 and ( a.price = 0 or a.price is null))
     when matched then update set a.price = b.ima53 ,a.price_source = '3',a.amt=b.ima53 * a.qty"
    prepare cimq025_upd_pm from l_sql
    execute cimq025_upd_pm using g_argv1
    if sqlca.sqlcode then
        let g_success = 'N'
        call cl_log(g_prog,"i","cimq025_upd_pm",sqlca.sqlcode)
        goto _error
    end if

    # 客制成本单价
    let l_sql = "
    merge into material_issue a 
    using custom_cost b on (a.uuid = ? and a.item_no = b.ta_ccc01 and ( a.price = 0 or a.price is null))
     when matched then update set a.price = b.ta_ccc23 ,a.price_source = '1',a.amt=b.ta_ccc23 * a.qty"
    prepare cimq025_upd_custom from l_sql
    execute cimq025_upd_custom using g_argv1
    if sqlca.sqlcode then
        let g_success = 'N'
        call cl_log(g_prog,"i","cimq025_upd_custom",sqlca.sqlcode)
        goto _error
    end if

    # 标准成本单价
    let l_sql = "
    merge into material_issue a  
    using std_cost b on (a.uuid = ? and a.item_no = b.ccc01 and ( a.price = 0 or a.price is null)) 
     when matched then update set a.price = b.ccc23 ,a.price_source = '2',a.amt=b.ccc23 * a.qty "
    prepare cimq025_upd_std from l_sql
    execute cimq025_upd_std using g_argv1
    if sqlca.sqlcode then
        let g_success = 'N'
        call cl_log(g_prog,"i","cimq025_upd_std",sqlca.sqlcode)
        goto _error
    end if

    #Step5. 将负数金额的更新未未取出单价
    update material_issue
       set price=0,amt=0,price_source='0'
     where uuid = g_argv1 and price <= 0


    label _error:
    if g_success = 'Y' then
        commit work
    else
        rollback work
    end if

end function
