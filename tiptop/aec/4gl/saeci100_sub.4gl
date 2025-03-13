# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saeci100_sub.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..:darcy:2023/04/13 s---

database ds

GLOBALS "../../config/top.global"

#  更新abmi600 中的作业编号
function i100sub_upd_bmb09(p_ecu01,p_ecu02)
    define p_ecu01      like ecu_file.ecu01
    define p_ecu02      like ecu_file.ecu02

    define sr record
        ecb06       like ecb_file.ecb06,
        ecbud04     like ecb_file.ecbud04
        end record
    define l_bmbud02 like bmb_file.bmbud02

    define l_cnt        integer
    define l_sql        string
    define l_token      base.StringTokenizer

    let g_success = 'Y'

    if p_ecu01 is null then
        call cl_err('',-400,0)
        let g_success ='N'
        return
    end if

    update bmb_file 
       set bmb09 = ' '
     where bmb01 = p_ecu01
       and bmb04 <= g_today and (bmb05 is null or bmb05 > g_today)

    if sqlca.sqlcode then
        CALL cl_err3("upd","bmb_file",p_ecu01,'',SQLCA.sqlcode,"","",0) 
        let g_success ='N'
        return
    end if

    if sqlca.sqlerrd[3] = 0 then
        # 无资料需要处理
        return
    end if

    SELECT COUNT(*) INTO l_cnt FROM ecb_file
     WHERE ecb01 = p_ecu01 and ecb02 = p_ecu02
       AND ecbud04 IS NOT NULL
    
    if l_cnt = 0 then
        # 无资料需要处理
        return
    end if

    let l_sql = "select ecb06,ecbud04 from ecb_file",
                " where ecb01 =? and ecb02 =? ",
                " and ecbud04 is not null ",
                " order by ecb03"
    prepare i100sub_pb from l_sql
    declare i100sub_cr cursor for i100sub_pb

    initialize sr.* to null
    foreach i100sub_cr using p_ecu01,p_ecu02
       into sr.*
        if sqlca.sqlcode then
            call cl_err('i100sub_cr',sqlca.sqlcode,0)
            exit foreach
            let g_success = 'N'
        end if

        let l_token = base.StringTokenizer.create(sr.ecbud04, "|")
        # 遍历物料代号
        while l_token.hasMoreTokens()
            let l_bmbud02 = l_token.nextToken()
            select count(1) into l_cnt from bmb_file 
             where bmbud02= l_bmbud02 and bmb01 = p_ecu01
            if l_cnt = 0 then
                continue while
            end if
            # 更新bmb中的作业编号
            let l_sql ="merge into bmb_file a",
                       " using (",
                       " select bmb01,bmb02,bmb03,? ecb06 from bmb_file",
                       " where bmb01 = ? and bmbud02 = ? ",
                       " and bmb04 <=? and (bmb05 is null or bmb05 > ?)",
                       " )b on(a.bmb01 = b.bmb01 and a.bmb02= b.bmb02 and a.bmb03=b.bmb03)",
                       " when matched then update set a.bmb09 = ecb06"
            prepare i100sub_bmb_upd from l_sql
            execute i100sub_bmb_upd using sr.ecb06,p_ecu01,l_bmbud02,g_today,g_today
            if sqlca.sqlcode then
                call cl_err3("upd","bmb_file",p_ecu01,"",SQLCA.sqlcode,"","",1) 
                let g_success = 'N'
                exit foreach
            end if
        end while
        #darcy:2023/06/15 add s---
        # 根据csmi103设置更新损耗率
        let l_sql = "MERGE INTO bmb_file USING (",
                    " SELECT tc_sma02,tc_sma06 FROM tc_sma_file WHERE tc_sma01='csmi103' AND tc_sma20='Y' AND tc_sma06>0",
                    " ) ON (bmb09 = tc_sma02 and bmb01 = ? and bmb19 = '1')", #darcy:2024/03/05 add bmb19 ='1' 只有原材料才需要设置损耗率
                    " WHEN MATCHED THEN UPDATE SET bmb08 = tc_sma06"
        prepare i100sub_bmb_upd2 from l_sql
        execute i100sub_bmb_upd2 using p_ecu01
        if sqlca.sqlcode then
            call cl_err3("i100sub_bmb_upd2","bmb_file",p_ecu01,"",SQLCA.sqlcode,"","",1) 
            let g_success = 'N'
            exit foreach
        end if
        #darcy:2023/06/15 add e---
    end foreach
end function

function i100sub_y_chk(p_ecu01,p_ecu02)
    define p_ecu01      like ecu_file.ecu01
    define p_ecu02      like ecu_file.ecu02
    define l_ecu10      like ecu_file.ecu10
    define l_ecuud02    like ecu_file.ecuud02

    define l_ecb06      like ecb_file.ecb06

    define l_sql        string
    define l_cnt        integer

    define l_imaud26    like ima_file.imaud26  #darcy:2023/10/17 add

    let g_success = 'Y'

    select ecu10,ecuud02 into l_ecu10,l_ecuud02 from ecu_file
     where ecu01 = p_ecu01 and ecu02 = p_ecu02
    
    if l_ecuud02 = 'Y' then
        call cl_err('','9023',1)
        let g_success = 'N'
        return
    end if

    if l_ecu10 = 'Y' then
        call cl_err('','9023',1)
        let g_success = 'N'
        return
    end if

    # tc_ecn_file 受镀面积维护检查跳过。表都不存在

    # 作业编号重复检查
    let l_sql = "select ecb06,count(1)  from ecb_file ",
            " where ecb01 = ? and ecb02 = ? ",
            "   group by ecb06 having count(1) > 1"
    prepare i100sub_ecb06_pb from l_sql
    declare i100sub_ecb06_dl cursor for i100sub_ecb06_pb

    foreach i100sub_ecb06_dl using p_ecu01,p_ecu02 into l_ecb06
        if sqlca.sqlcode then
            call cl_err('i100sub_ecb06_dl',sqlca.sqlcode,1)
            let g_success = 'N'
            return
        end if
        let g_success = 'N'
        call s_errmsg("ecb06",l_ecb06,'','cec-044',1)
    end foreach

    # HDI未维护报错
    # select count(1) into l_cnt from ima_file 
    #  where ima06 in ('G01','G02') and ima01 =p_ecu01 and imaud25 is null
    # if l_cnt > 0 then
    #     call s_errmsg('ima01',p_ecu01,'','cec-043',1)
    #     let g_success = 'N'
    # end if

    #darcy:2023/10/17 add s---
    # HDI判断
    # 如果料号第8位 >=3 且工序中包含镭射站，那么自动更新HDI为Y
    # 如果HDI更新为Y，但是阶数没有维护，那么不允许审核
    let l_cnt = 1
    select count(*) into l_cnt from ecb_file
     where (substr(ecb01,8,1) !="1" and substr(ecb01,8,1) !="2" )
       and ecb01 = p_ecu01  and ecb02 = p_ecu02
       and ecb06 in (
        'F04020','F04021','F04022','F04023','F04024','F04025','F04026','F04027','F04028','F04120',
        'F04121','F04122','F04130','F04131','F04132','F04133','F04134','F04135','F04123',
        'F04124','F04125','F04126','F04127','F04128','F04129','F04136','F04137',
        'F04138','F04139','F0402F','F0402G','F04029','F0402A','F0402B','F0402C','F0402D','F0402E')
    if l_cnt > 0 then
        update ima_file set imaud25 = 'Y' where ima01=p_ecu01
        select imaud26 into l_imaud26 from ima_file 
         where ima01 = p_ecu01
        if cl_null(l_imaud26) then
            call cl_err(p_ecu01,"cec-061",1)
            let g_success = 'N'
            return
        end if
    end if
    #darcy:2023/10/17 add e---
         
    #确认是否审核
    if g_prog = 'aeci100' then
        if not cl_confirm('aap-222') then 
            let g_success = 'N'
            return
        end if
    end if
end function
# p_inTransaction true 在事务中
# p_inTransaction flase 不在在事务中
function i100sub_y_upd(p_ecu01,p_ecu02,p_inTransaction)
    define p_ecu01      like ecu_file.ecu01
    define p_ecu02      like ecu_file.ecu02
    define p_inTransaction like type_file.num5

    let g_success = 'Y'

    if not p_inTransaction then
        begin work
    end if

    #darcy:2023/09/27 add s---
    # 还原为样品量产规则一致
    #darcy:2023/05/17 add s---
    # if p_ecu01[10,10] = 'S' or p_ecu01[10,10] = 'F' then
    #     update ecb_file set ecbud06 ='Y' where ecb01 = p_ecu01 and ecb02 = p_ecu02
    #        and ecb08 != 'G1018'
    # end if
    #darcy:2023/05/17 add e---
    #darcy:2023/09/27 add e---

    update ecu_file
       set ecuud02="Y",ecudate = g_today
     where ecu01=p_ecu01
       and ecu02=p_ecu02
    if sqlca.sqlcode then
        call s_errmsg('ecu01,ecu02',p_ecu01||','||p_ecu02,'',sqlca.sqlcode,1)
        let g_success  = 'N'
        rollback work
        return
    end if
    call i100sub_upd_bmb09(p_ecu01,p_ecu02)
    if g_success != 'Y' then
        let g_success  = 'N'
        rollback work
        return
    end if
    if not p_inTransaction then
        commit work
    end if 
end function

function i100sub_release(p_ecu01,p_ecu02,p_inTransaction)
    define p_ecu01      like ecu_file.ecu01
    define p_ecu02      like ecu_file.ecu02
    define p_inTransaction like type_file.num5

    define l_ecu10       like ecu_file.ecu10
    define l_ecuacti     like ecu_file.ecuacti

    let g_success = 'Y'
    if cl_null(p_ecu01) then
        call cl_err('',-400,0)
        let g_success = 'N'
        return
    end if

    select ecu10,ecuacti into l_ecu10,l_ecuacti from ecu_file
     where ecu01 = p_ecu01 and ecu02 = p_ecu02
    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,1)
        let g_success = 'N'
        return
    end if

    if l_ecu10 = 'Y' then
        call cl_err('','cec-030',1)
        let g_success = 'N'
        return
    end if

    if l_ecuacti="N" then
       call cl_err("",'aim-153',1)
       let g_success = 'N'
       return
    end if

    if g_prog = 'aeci100' then
        if not cl_confirm('cec-031') then
            let g_success = 'N'
            return
        end if
    end if

    if not p_inTransaction then
        begin work
    end if

    update ima_file set ima571 = p_ecu01,
        ima94 = p_ecu02
     where ima01 = p_ecu01 and ima08 = 'M'
    if sqlca.sqlcode then
        # call cl_err3("upd","ima_file",p_ecu01,p_ecu02,sqlca.sqlcode,"","ima571",1)
        call s_errmsg('ima01',p_ecu01,'upd ima571',sqlca.sqlcode,1)
        rollback work
        let g_success = 'N'
        return
    end if

    update ecu_file 
       set ecu10 = 'Y',ecudate=  g_today
     where ecu01 = p_ecu01
       and ecu02 = p_ecu02
    if sqlca.sqlcode then
        call s_errmsg('ecu01,ecu02',p_ecu01||','||p_ecu02,'upd ecu',sqlca.sqlcode,1)
        rollback work
        let g_success = 'N'
        return
    end if

    if not p_inTransaction then
        commit work
    end if
end function

# 组装报工更新
function i100sub_upd_G01(p_ecb01,p_ecb02)
    define  p_ecb01     like ecb_file.ecb01,
            p_ecb02     like ecb_file.ecb02,
            p_inTransaction     varchar(1)
    define  l_sql       string

    let l_sql = " merge into ecb_file using ecd_file ",
                " on (ecb06 = ecd01 and ecb01 = ? and ecb02 = ?) ",
                " when matched then update set ecbud06 = ta_ecd05 "
    prepare i100_updG01_p from l_sql

    execute i100_updG01_p using p_ecb01,p_ecb02
    if sqlca.sqlcode then
        call cl_err("i100_updG01_p",sqlca.sqlcode,1)
        return false
    end if
    return true
end function

# ecb_file 修改记录
function i100sub_mod_log(p_ecb,p_type)
    define p_ecb    record like ecb_file.*
    define p_type   varchar(40)
    define l_tc_ecc01   varchar(40)
    define l_tc_ecc02   varchar(40)
    define l_tc_ecc03   varchar(40)
    
    let l_tc_ecc01 = current year to fraction(4)
    let l_tc_ecc02 = g_user
    let l_tc_ecc03 = p_type
    insert into tc_ecc_file values(p_ecb.*,l_tc_ecc01,l_tc_ecc02,l_tc_ecc03)
    if sqlca.sqlcode then
        call cl_err("ins tc_ecc_file",sqlca.sqlcode,1)
        return false
    end if
    return true
end function
