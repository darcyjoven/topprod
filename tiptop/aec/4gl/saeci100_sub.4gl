# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saeci100_sub.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..:darcy:2023/04/13 s---

database ds

GLOBALS "../../config/top.global"

type bmb record
    bmb01       like bmb_file.bmb01,
    bmb02       like bmb_file.bmb02,
    bmb03       like bmb_file.bmb03,
    bmb04       like bmb_file.bmb04,
    bmb05       like bmb_file.bmb05,
    bmb09       like bmb_file.bmb09,
    bmbud02     like bmb_file.bmbud02,
    bma10       like bma_file.bma10,
    bma05       like bma_file.bma05
end record
type ecb record
    ecb01       like ecb_file.ecb01  ,
    ecb02       like ecb_file.ecb02  ,
    ecb03       like ecb_file.ecb03  ,
    ecb06       like ecb_file.ecb06  ,
    ecbud04     like ecb_file.ecbud04,
    ecu10       like ecu_file.ecu10  ,
    ecuud02     like ecu_file.ecuud02
end record


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

    # darcy:2025/12/03 add s---
    define l_tc_sma06   decimal(15,3)
    define l_tc_sma04   like tc_sma_file.tc_sma04
    define l_tc_sma02   like tc_sma_file.tc_sma02
    define i      integer
    # darcy:2025/12/03 add e---
    # darcy:2025/12/05 add s---
    define l_sql1,l_sql2,l_sql3        varchar(4000)
    define l_typ                       varchar(1)
    # darcy:2025/12/05 add e---
    define l_ecd02          like ecd_file.ecd02 #darcy:2025/12/11 add
    define l_ecb06          like ecb_file.ecb06 # darcy:2026/02/12 add


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
    end foreach
    #darcy:2023/06/15 add s---
    # 根据csmi103设置更新损耗率
    if not cl_csmi133('aeci100','aeci620') then
        let l_sql = "MERGE INTO bmb_file USING (",
                    " SELECT tc_sma02,tc_sma06 FROM tc_sma_file WHERE tc_sma01='csmi103' AND tc_sma20='Y' AND tc_sma06>0",
                    " ) ON (bmb09 = tc_sma02 and bmb01 = ? and bmb19 = '1')", #darcy:2024/03/05 add bmb19 ='1' 只有原材料才需要设置损耗率
                    " WHEN MATCHED THEN UPDATE SET bmb08 = tc_sma06"
        prepare i100sub_bmb_upd2 from l_sql
        execute i100sub_bmb_upd2 using p_ecu01
        if sqlca.sqlcode then
            call cl_err3("i100sub_bmb_upd2","bmb_file",p_ecu01,"",SQLCA.sqlcode,"","",1)
            let g_success = 'N'
            return
        end if
    end if

    #if g_user = 'tiptop' then
        call saeci100_get_record(p_ecu01,p_ecu02)
    #end if

    --call saeci100_csmi134(p_ecu01) # darcy:2026/03/13 add
    #darcy:2023/06/15 add e---
    # darcy:2025/12/02 add s ---
    -- if g_user <> 'tiptop' then
    --     return
    -- end if


    -- let l_typ = '1'
    -- execute scimt002_listagg using l_typ into l_sql1
    -- let l_sql1 = "( 1=2 ",l_sql1,"%' )"
    -- let l_typ = '2'
    -- execute scimt002_listagg using l_typ into l_sql2
    -- let l_sql2 = "( 1=2 ",l_sql2,"%' )"
    -- let l_typ = '3'
    -- execute scimt002_listagg using l_typ into l_sql3
    -- let l_sql3 = "( 1=2 ",l_sql3,"%' )"

    # 判断第一站是否是F0107
    select ecb06 into l_ecb06 from ecb_file
     where ecb01 = p_ecu01 and ecb02 = p_ecu02
       and rownum = 1 order by ecb03

    if l_ecb06 not matches 'F0107*' then
        return
    end if


    # 卷料损耗设置
    let l_sql = "select unique tc_sma04 from tc_sma_file where tc_sma01 = 'csmi126' "
    declare i100sub_csmi126_1 cursor from l_sql

    let l_sql = "select tc_sma06 from tc_sma_file where tc_sma01 = 'csmi126' and tc_sma04 = ? and rownum = 1"
    prepare i100sub_csmi126_2 from l_sql

    let l_sql = "select tc_sma02 from tc_sma_file where tc_sma01 = 'csmi126' and tc_sma04 = ? order by tc_sma03"
    declare i100sub_csmi126_3 cursor from l_sql

    -- if g_user <> 'tiptop' then
    --     return
    -- end if

    foreach i100sub_csmi126_1 into l_tc_sma04
        if sqlca.sqlcode then
            call cl_err("i100sub_csmi126_1",sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
        end if
        -- 遍历类型
        let l_sql = "select count(*) from (select * from ecb_file where ecb01 = '",
                    p_ecu01,"' and ecb02 = '",p_ecu02,"' and rownum <= 10 order by ecb03) a where 1=1 "

        let i = 1
        foreach i100sub_csmi126_3 using l_tc_sma04 into l_tc_sma02
            if sqlca.sqlcode then
                call cl_err("i100sub_csmi126_3",sqlca.sqlcode,1)
                let g_success = 'N'
                exit foreach
            end if

            -- 找不到作业编号的，再csmi127找多笔作业编号
            select ecd02 into l_ecd02 from ecd_file where ecd01 = l_tc_sma02
            if cl_null(l_ecd02) or sqlca.sqlcode then
                let l_sql2 = "select listagg(' or ",ascii(ord('a')+i),".ecb06 like ''' || substr(tc_sma02, 1, 5), '%'' ') within group(order by tc_sma04) ",
                            " from tc_sma_file where tc_sma01 = 'csmi127' and tc_sma06 = ? "
                prepare scimt002_listagg from l_sql2

                execute scimt002_listagg using l_tc_sma02 into l_sql1
                free scimt002_listagg
                let l_sql1 = "(  1=2 ",l_sql1,"%' )"
                let l_sql = l_sql,"  and exists /*",l_tc_sma02,"*/ (select 1 from ecb_file ",ascii(ord('a')+i),
                                  " where ",ascii(ord('a')+i),".ecb01 = a.ecb01",
                                  "  and ",ascii(ord('a')+i),".ecb02=a.ecb02 and ",l_sql1,")"
            else
                let l_sql = l_sql , " and exists/*",l_ecd02,"*/ ( select 1 from ecb_file ",ascii(ord('a')+i),
                                    " where ",ascii(ord('a')+i),".ecb01 = a.ecb01 ",
                                    "  and ",ascii(ord('a')+i),".ecb02 = a.ecb02 and ",
                                    ascii(ord('a')+i),".ecb06 like '",l_tc_sma02[1,5],"%' )"
            end if
            let i = i + 1
            -- case l_tc_sma02
            --     when '1'
            --          let l_sql = l_sql," and exists (select 1 from ecb_file fi where fi.ecb01 = a.ecb01",
            --                      "  and fi.ecb02=a.ecb02 and ",l_sql1,")"
            --     when '2'
            --          let l_sql = l_sql," and exists (select 1 from ecb_file fi where fi.ecb01 = a.ecb01",
            --                      "  and fi.ecb02=a.ecb02 and ",l_sql2,")"
            --     when '3'
            --          let l_sql = l_sql," and exists (select 1 from ecb_file fi where fi.ecb01 = a.ecb01",
            --                      "  and fi.ecb02=a.ecb02 and ",l_sql3,")"
            --     otherwise
            --         let l_sql = l_sql , " and exists ( select 1 from ecb_file ",ascii(ord('a')+i),
            --                             " where ",ascii(ord('a')+i),".ecb01 = a.ecb01 ",
            --                             "  and ",ascii(ord('a')+i),".ecb02 = a.ecb02 and ",
            --                             ascii(ord('a')+i),".ecb06 like '",l_tc_sma02[1,5],"%' )"
            --         let i = i + 1
            -- end case
        end foreach

        prepare i100sub_csmi126_4 from l_sql
        execute i100sub_csmi126_4 into l_cnt
        if l_cnt > 0 then
            -- 损耗率查询
            execute i100sub_csmi126_2 using l_tc_sma04 into l_tc_sma06
            if sqlca.sqlcode then
                call cl_err("i100sub_csmi126_2",sqlca.sqlcode,1)
                let g_success = 'N'
                exit foreach
            end if
            -- 更新首站损耗
            update bmb_file set bmb08 = l_tc_sma06 where bmb01 = p_ecu01 and bmb09 like 'F0107%'
            if sqlca.sqlcode then
                call cl_err("upd bmb",sqlca.sqlcode,1)
                let g_success = 'N'
                exit foreach
            end if
            exit foreach
        end if
    end foreach

    # darcy:2025/12/02 add e ---
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

    # darcy add s---
    # 检查备注是否输入完成，如果检查失败要弹窗备注
    if g_success = 'N' then
        return
    end if
    if cl_null(g_bgjob) or g_bgjob = 'N' then
        call cl_remark_chk(g_prog,p_ecu01||p_ecu02,0)
        while true
            let g_success = 'N'
            call cl_remark(g_prog,p_ecu01||p_ecu02,0)
            if g_success = 'Y' then
                exit while
            end if
        end while
    end if


    # darcy add e---

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
    # darcy:2025/10/28 add s---
    define l_ecuud04    like ecu_file.ecuud04
    define l_ecuud03     like ecu_file.ecuud03
    # darcy:2025/10/28 add e---

    let g_success = 'Y'

    # darcy:2025/10/28 add s---
    # 送签的资料，不允许直接审核
    # darcy:2025/10/28 add e---
    select ecuud03,ecuud04 into l_ecuud03,l_ecuud04 from ecu_file
     where ecu01 = p_ecu01 and ecu02 = p_ecu02
    if l_ecuud04 == 'Y' and g_prog = 'aeci100' then
        call cl_err(l_ecuud03,"cxm-052",1)
        let g_success = 'N'
        return
    end if
    #darcy:2023/09/27 add s---

    if not p_inTransaction then
        begin work
    end if

    # 还原为样品量产规则一致
    #darcy:2023/05/17 add s---
    # if p_ecu01[10,10] = 'S' or p_ecu01[10,10] = 'F' then
    #     update ecb_file set ecbud06 ='Y' where ecb01 = p_ecu01 and ecb02 = p_ecu02
    #        and ecb08 != 'G1018'
    # end if
    #darcy:2023/05/17 add e---
    #darcy:2023/09/27 add e---

    update ecu_file
       set ecuud02="Y",ecuud05='1',ecudate = g_today #darcy:2025/10/28 add ecuud05
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

# darcy:2025/10/15 add s---
# 表面处理的镍钯金备注修改和维护
# 输入原始备注，如果为空表示之前没备注
# 输出组合的备注，如果为空表示取消录入
function i100sub_surface_remark(p_remark)
    define p_remark,l_remark    varchar(1500)
    define sr record
            au1     decimal(20,6),
            au2     decimal(20,6),
            pa1     decimal(20,6),
            pa2     decimal(20,6),
            ni1     decimal(20,6),
            ni2     decimal(20,6),
            remark  varchar(1500)
        end record
    define backup record
            au1     decimal(20,6),
            au2     decimal(20,6),
            pa1     decimal(20,6),
            pa2     decimal(20,6),
            ni1     decimal(20,6),
            ni2     decimal(20,6),
            remark  varchar(1500)
        end record

    initialize sr.* to null
    call i100sub_parse_remark(p_remark) returning sr.*
    let backup.* = sr.*

    open window i100_a_w at 1,1 with form "aec/42f/aeci100_a"
       attribute (style = g_win_style clipped)
    call cl_ui_init()

    input by name sr.* without defaults
        before input

        on idle g_idle_seconds
          call cl_on_idle()
          continue input

        on action about
            call cl_about()

        on action help
          call cl_show_help()

        on action controlg
             call cl_cmdask()
    end input

    if int_flag then
       -- 取消
       let sr.* = backup.*
       let int_flag = false
    end if

    close window i100_a_w
    let l_remark = i100sub_join(sr.*)

    return l_remark
end function
-- 解析备注内容至 sr
function i100sub_parse_remark(p_remark)
    define p_remark varchar(1500)
    define sr record
            au1     decimal(20,6),
            au2     decimal(20,6),
            pa1     decimal(20,6),
            pa2     decimal(20,6),
            ni1     decimal(20,6),
            ni2     decimal(20,6),
            remark  varchar(1500)
        end record
    define l_tok,l_tok1         base.StringTokenizer
    define l_str   string
    define l_t1,l_t2 decimal(20,6)
    define l_type varchar(2)
    define l_tmp  string

    initialize sr.* to null

    -- 1.Au: 0.075±0.025um, pa: 0.12±0.21122um, Ni: 3.5±1.5um
    -- 2.化金面积S=2.73dm”，主检化金不良，记入表单，手指厚度切片
    -- 3.测HOTBAR手指，见手指化金管控图，量测12pcs金手指尺寸
    let l_tok = base.StringTokenizer.create(p_remark,'\n')
    if l_tok.hasMoreTokens() then
        let l_str = l_tok.nextToken()

        -- remark部分
        let sr.remark = ""
        if l_tok.hasMoreTokens() then
            while l_tok.hasMoreTokens()
                let l_tmp =  l_tok.nextToken()
                let sr.remark = sfmt("%1%2\n",sr.remark,l_tmp)
            end while
        end if

        let l_str = cl_replace_str(l_str," ","")
        -- 去掉'1.'
        -- Au:0.075±0.025um,Pa:0.12±0.21122um,Ni:3.5±1.5um
        let l_str = l_str.substring(3,l_str.getlength())
        let l_tok = base.StringTokenizer.create(l_str,',')
        while l_tok.hasMoreTokens()
                -- Au:0.075±0.025um
                -- Pa:0.12±0.21122um
                -- Ni:3.5±1.5um
                let l_str = l_tok.nextToken()
                let l_type = l_str
                -- 0.075±0.025um
                if l_str.getlength() >= 6 then
                    let l_str = l_str.substring(4,l_str.getlength()-2)
                    let l_tok1 = base.StringTokenizer.create(l_str,'±')
                    let l_t1 = 0 let l_t2 = 0
                    if l_tok1.hasMoreTokens() then
                        let l_t1 = l_tok1.nextToken()
                    end if
                    if l_tok1.hasMoreTokens() then
                        let l_t2 = l_tok1.nextToken()
                    end if

                    case
                        when l_type matches 'Au*'
                            let sr.au1 = l_t1
                            let sr.au2 = l_t2
                        when l_type matches 'Pd*'
                            let sr.pa1 = l_t1
                            let sr.pa2 = l_t2
                        when l_type matches 'Ni*'
                            let sr.ni1 = l_t1
                            let sr.ni2 = l_t2
                    end case
                end if
            end while
    end if
    return sr.*
end function
function i100sub_join(sr)
    define sr record
            au1     decimal(20,6),
            au2     decimal(20,6),
            pa1     decimal(20,6),
            pa2     decimal(20,6),
            ni1     decimal(20,6),
            ni2     decimal(20,6),
            remark  varchar(1500)
        end record
    define l_remark string

    let l_remark = "1."
    if sr.au1 <> 0 then
        let l_remark = l_remark , sfmt("Au: %1±%2um,",sr.au1 using "<<<&.<<<",sr.au2 using "<<<&.<<<")
    end if
    if sr.pa1 <> 0 then
        let l_remark = l_remark , sfmt("Pd: %1±%2um,",sr.pa1 using "<<<&.<<<",sr.pa2 using "<<<&.<<<")
    end if
    if sr.ni1 <> 0 then
        let l_remark = l_remark , sfmt("Ni: %1±%2um,",sr.ni1 using "<<<&.<<<",sr.ni2 using "<<<&.<<<")
    end if
    let l_remark = l_remark , "\n" ,sr.remark
    return l_remark
end function
# darcy:2025/10/15 add e---


# darcy.li 2026/03/09 s---
# 根据规则更新损耗率/损耗量
function saeci100_csmi134(p_ima01)
    define p_ima01 varchar(20)
    define l_sample varchar(1)
    define l_sql    string
    define l_bmb01,l_bmb03 like bmb_file.bmb01,
           l_bmb02 like bmb_file.bmb02,
           l_bmb08 like bmb_file.bmb08,
           l_bmb081 like bmb_file.bmb081
    define l_ecb record like ecb_file.*

    let l_sample = iif(p_ima01[10,10] matches '[SF]','Y','N')
    if p_ima01 matches '*-*' then
        return
    end if

    let g_success = 'Y'

    # 料件损耗
    if cl_csmi133('aeci100','aimi100') then
        let l_sql = " select bmb01,bmb02, bmb03, tc_sma06, tc_sma07",
                    " from (select CONNECT_BY_ROOT(bmb01) root,bmb01, bmb02,bmb03",
                    "         from bmb_file",
                    "         where bmb04 <= trunc(sysdate)",
                    "         and (bmb05 is null or bmb05 > trunc(sysdate))",
                    "         start with bmb01 = ? ",
                    "         connect by prior bmb03 = bmb01),",
                    "     (select tc_sma02, tc_sma06, tc_sma07",
                    "         from tc_sma_file",
                    "         where tc_sma01 = 'csmi134'",
                    "         and tc_sma20 = 'Y'",
                    "         and tc_sma05 = ?",
                    "         and tc_sma04 = 'aimi100')",
                    " where tc_sma02 = bmb03"
        prepare saeci100_csmi134_p1 from l_sql
        declare saeci100_csmi134_cur1 cursor for saeci100_csmi134_p1

        foreach saeci100_csmi134_cur1 using p_ima01,l_sample
                                      into l_bmb01,l_bmb02,l_bmb03,l_bmb08,l_bmb081
            if sqlca.sqlcode then
                call cl_err('saeci100_csmi134_cur1',sqlca.sqlcode,1)
                exit foreach
            end if
            if not cl_null(l_bmb08) and l_bmb08 > 0 then
                update bmb_file set bmb08 = l_bmb08
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            if not cl_null(l_bmb081) and l_bmb081 > 0 then
                update bmb_file set bmb081 = l_bmb081
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            initialize l_ecb.* to null
            select * into l_ecb.* from ecb_file where ecb01 = l_bmb01 and rownum = 1
            if not cl_null(l_ecb.ecb01) then
                if i100sub_mod_log(l_ecb.*,sfmt("aimi100,%1-%2/%3",l_bmb03,l_bmb08,l_bmb081)) then end if
            end if
        end foreach

    end if
    # 分群码损耗
    if cl_csmi133('aeci100','aimi110') then
        let l_sql = " select bmb01, bmb02,bmb03, tc_sma06, tc_sma07 ",
                    " from (select CONNECT_BY_ROOT(bmb01) root,bmb01, bmb02,bmb03,ima06 ",
                    "         from bmb_file,ima_file ",
                    "         where bmb03=ima01 and bmb04 <= trunc(sysdate) ",
                    "         and (bmb05 is null or bmb05 > trunc(sysdate)) ",
                    "         start with bmb01 = ? ",
                    "         connect by prior bmb03 = bmb01), ",
                    "     (select tc_sma02, tc_sma06, tc_sma07 ",
                    "         from tc_sma_file ",
                    "         where tc_sma01 = 'csmi134' ",
                    "         and tc_sma20 = 'Y' ",
                    "         and tc_sma05 = ? ",
                    "         and tc_sma04 = 'aimi110') ",
                    " where ima06 = tc_sma02 "
        prepare saeci100_csmi134_p2 from l_sql
        declare saeci100_csmi134_cur2 cursor for saeci100_csmi134_p2

        foreach saeci100_csmi134_cur2 using p_ima01,l_sample
                                      into l_bmb01,l_bmb02,l_bmb03,l_bmb08,l_bmb081
            if sqlca.sqlcode then
                call cl_err('saeci100_csmi134_cur2',sqlca.sqlcode,1)
                exit foreach
            end if
            if not cl_null(l_bmb08) and l_bmb08 > 0 then
                update bmb_file set bmb08 = l_bmb08
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            if not cl_null(l_bmb081) and l_bmb081 > 0 then
                update bmb_file set bmb081 = l_bmb081
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            initialize l_ecb.* to null
            select * into l_ecb.* from ecb_file where ecb01 = l_bmb01 and rownum = 1
            if not cl_null(l_ecb.ecb01) then
                if i100sub_mod_log(l_ecb.*,sfmt("aimi110,%1-%2/%3",l_bmb03,l_bmb08,l_bmb081)) then end if
            end if
        end foreach

    end if
    # 作业编号
    if cl_csmi133('aeci100','aeci620') then
        let l_sql = " select bmb01, bmb02,bmb03, tc_sma06, tc_sma07",
                    " from (select CONNECT_BY_ROOT(bmb01) root, bmb01,bmb02,bmb03,bmb09",
                    "         from bmb_file ",
                    "         where  bmb04 <= trunc(sysdate)",
                    "         and (bmb05 is null or bmb05 > trunc(sysdate))",
                    "         start with bmb01 = ? ",
                    "         connect by prior bmb03 = bmb01),",
                    "     (select tc_sma02, tc_sma06, tc_sma07",
                    "         from tc_sma_file",
                    "         where tc_sma01 = 'csmi134'",
                    "         and tc_sma20 = 'Y'",
                    "         and tc_sma05 = ? ",
                    "         and tc_sma04 = 'aeci620')",
                    " where bmb09 = tc_sma02"
        prepare saeci100_csmi134_p3 from l_sql
        declare saeci100_csmi134_cur3 cursor for saeci100_csmi134_p3

        foreach saeci100_csmi134_cur3 using p_ima01,l_sample
                                      into l_bmb01,l_bmb02,l_bmb03,l_bmb08,l_bmb081
            if sqlca.sqlcode then
                call cl_err('saeci100_csmi134_cur3',sqlca.sqlcode,1)
                exit foreach
            end if
            if not cl_null(l_bmb08) and l_bmb08 > 0 then
                update bmb_file set bmb08 = l_bmb08
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            if not cl_null(l_bmb081) and l_bmb081 > 0 then
                update bmb_file set bmb081 = l_bmb081
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            initialize l_ecb.* to null
            select * into l_ecb.* from ecb_file where ecb01 = l_bmb01 and rownum = 1
            if not cl_null(l_ecb.ecb01) then
                if i100sub_mod_log(l_ecb.*,sfmt("aeci620,%1-%2/%3",l_bmb03,l_bmb08,l_bmb081)) then end if
            end if
        end foreach
    end if

    if cl_csmi133('aeci100','aeci600') then
        let l_sql = " select bmb01, bmb02,bmb03, tc_sma06, tc_sma07",
                    " from (select CONNECT_BY_ROOT(bmb01) root, bmb01,bmb02,bmb03,ecd07",
                    "         from bmb_file ,ecd_file",
                    "         where bmb09 = ecd01 and bmb04 <= trunc(sysdate)",
                    "         and (bmb05 is null or bmb05 > trunc(sysdate))",
                    "         start with bmb01 = ? ",
                    "         connect by prior bmb03 = bmb01),",
                    "     (select tc_sma02, tc_sma06, tc_sma07",
                    "         from tc_sma_file",
                    "         where tc_sma01 = 'csmi134'",
                    "         and tc_sma20 = 'Y'",
                    "         and tc_sma05 = ? ",
                    "         and tc_sma04 = 'aeci600')",
                    " where ecd07 = tc_sma02"
        prepare saeci100_csmi134_p4 from l_sql
        declare saeci100_csmi134_cur4 cursor for saeci100_csmi134_p4

        foreach saeci100_csmi134_cur4 using p_ima01,l_sample
                                      into l_bmb01,l_bmb02,l_bmb03,l_bmb08,l_bmb081
            if sqlca.sqlcode then
                call cl_err('saeci100_csmi134_cur4',sqlca.sqlcode,1)
                exit foreach
            end if
            if not cl_null(l_bmb08) and l_bmb08 > 0 then
                update bmb_file set bmb08 = l_bmb08
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            if not cl_null(l_bmb081) and l_bmb081 > 0 then
                update bmb_file set bmb081 = l_bmb081
                 where bmb01 = l_bmb01 and bmb03 = l_bmb03 and bmb02 = l_bmb02
                   and bmb04 <= trunc(sysdate) and (bmb05 is null or bmb05 > trunc(sysdate))
            end if
            initialize l_ecb.* to null
            select * into l_ecb.* from ecb_file where ecb01 = l_bmb01 and rownum = 1
            if not cl_null(l_ecb.ecb01) then
                if i100sub_mod_log(l_ecb.*,sfmt("aeci600,%1-%2/%3",l_bmb03,l_bmb08,l_bmb081)) then end if
            end if
        end foreach
    end if

end function
# darcy.li 2026/03/09 e---
#

-- 记录当前bom和工艺资料
function saeci100_get_record(p_ecb01,p_ecb02)
    define p_ecb01          like ecb_file.ecb01
    define p_ecb02          like ecb_file.ecb02

    define l_sql,l_file     string
    define l_cnt,i,j        integer
    define noChildren       boolean
    define l_bmb            bmb
    define l_ecb            ecb
    define l_str            string
    DEFINE l_bmb_buf        base.StringBuffer
    define l_ecb_buf        base.StringBuffer
    define l_ch             base.Channel

    LET l_bmb_buf = base.StringBuffer.create()
    LET l_ecb_buf = base.StringBuffer.create()

    let l_sql = "select bmb01, bmb02, bmb03, bmb04, bmb05, bmb09, bmbud02 , '', '', CONNECT_BY_ISLEAF
                from bmb_file
                start with bmb01 = ?
                connect by prior bmb03 = bmb01 order by 1,2"
    declare saeci100_get_record1 cursor from l_sql

    let l_sql = " select ecb01,ecb02,ecb03,ecb06,ecbud04,ecu10,ecuud02
                    from ecb_file,ecu_file
                   where ecb01 = ecu01 and ecb02 = ecu02 and ecb01 = ? and ecb02 = ?"
    declare saeci100_get_record2 cursor from l_sql

    initialize l_bmb.* to null
    initialize l_ecb.* to null

    foreach saeci100_get_record2 using p_ecb01,p_ecb02 into l_ecb.*
        if sqlca.sqlcode then
            call cl_err('saeci100_get_record2',sqlca.sqlcode,1)
            exit foreach
        end if
        let l_str = iif(l_ecb.ecb01  matches '*,*',sfmt('"%1",',l_ecb.ecb01),sfmt('%1,',l_ecb.ecb01))
        let l_str =  l_str , iif(l_ecb.ecb02  matches '*,*',sfmt('"%1",',l_ecb.ecb02),sfmt('%1,',l_ecb.ecb02))
        let l_str =  l_str , iif(l_ecb.ecb03  matches '*,*',sfmt('"%1",',l_ecb.ecb03),sfmt('%1,',l_ecb.ecb03))
        let l_str =  l_str , iif(l_ecb.ecb06  matches '*,*',sfmt('"%1",',l_ecb.ecb06),sfmt('%1,',l_ecb.ecb06))
        let l_str =  l_str , iif(l_ecb.ecbud04 matches '*,*',sfmt('"%1",',l_ecb.ecbud04),sfmt('%1,',l_ecb.ecbud04))
        let l_str =  l_str , iif(l_ecb.ecu10  matches '*,*',sfmt('"%1",',l_ecb.ecu10),sfmt('%1,',l_ecb.ecu10))
        let l_str =  l_str , iif(l_ecb.ecuud02 matches '*,*',sfmt('"%1"\n',l_ecb.ecuud02),sfmt('%1\n',l_ecb.ecuud02))
        CALL l_ecb_buf.append(l_str)
    end foreach

    foreach saeci100_get_record1 using p_ecb01 into l_bmb.*,noChildren
        if sqlca.sqlcode then
            call cl_err('saeci100_get_record1',sqlca.sqlcode,1)
            exit foreach
        end if

        select bma10,bma05 into l_bmb.bma10,l_bmb.bma05 from bma_file
         where bma01 = p_ecb01

        let l_str = iif(l_bmb.bmb01 matches '*,*',sfmt('"%1",',l_bmb.bmb01),sfmt('%1,',l_bmb.bmb01))
        let l_str = l_str , iif(l_bmb.bmb02 matches '*,*',sfmt('"%1",',l_bmb.bmb02),sfmt('%1,',l_bmb.bmb02))
        let l_str = l_str , iif(l_bmb.bmb03 matches '*,*',sfmt('"%1",',l_bmb.bmb03),sfmt('%1,',l_bmb.bmb03))
        let l_str = l_str , iif(l_bmb.bmb04 matches '*,*',sfmt('"%1",',l_bmb.bmb04),sfmt('%1,',l_bmb.bmb04))
        let l_str = l_str , iif(l_bmb.bmb05 matches '*,*',sfmt('"%1",',l_bmb.bmb05),sfmt('%1,',l_bmb.bmb05))
        let l_str = l_str , iif(l_bmb.bmb09 matches '*,*',sfmt('"%1",',l_bmb.bmb09),sfmt('%1,',l_bmb.bmb09))
        let l_str = l_str , iif(l_bmb.bmbud02 matches '*,*',sfmt('"%1",',l_bmb.bmbud02),sfmt('%1,',l_bmb.bmbud02))
        let l_str = l_str , iif(l_bmb.bma10 matches '*,*',sfmt('"%1",',l_bmb.bma10),sfmt('%1,',l_bmb.bma10))
        let l_str = l_str , iif(l_bmb.bma05 matches '*,*',sfmt('"%1"\n',l_bmb.bma05),sfmt('%1\n',l_bmb.bma05))
        CALL l_bmb_buf.append(l_str)

        if noChildren then
            continue foreach
        end if

        foreach saeci100_get_record2 using l_bmb.bmb03,p_ecb02 into l_ecb.*
            if sqlca.sqlcode then
                call cl_err('saeci100_get_record2',sqlca.sqlcode,1)
                exit foreach
            end if
            let l_str = iif(l_ecb.ecb01  matches '*,*',sfmt('"%1",',l_ecb.ecb01),sfmt('%1,',l_ecb.ecb01))
            let l_str =  l_str , iif(l_ecb.ecb02  matches '*,*',sfmt('"%1",',l_ecb.ecb02),sfmt('%1,',l_ecb.ecb02))
            let l_str =  l_str , iif(l_ecb.ecb03  matches '*,*',sfmt('"%1",',l_ecb.ecb03),sfmt('%1,',l_ecb.ecb03))
            let l_str =  l_str , iif(l_ecb.ecb06  matches '*,*',sfmt('"%1",',l_ecb.ecb06),sfmt('%1,',l_ecb.ecb06))
            let l_str =  l_str , iif(l_ecb.ecbud04 matches '*,*',sfmt('"%1",',l_ecb.ecbud04),sfmt('%1,',l_ecb.ecbud04))
            let l_str =  l_str , iif(l_ecb.ecu10  matches '*,*',sfmt('"%1",',l_ecb.ecu10),sfmt('%1,',l_ecb.ecu10))
            let l_str =  l_str , iif(l_ecb.ecuud02 matches '*,*',sfmt('"%1"\n',l_ecb.ecuud02),sfmt('%1\n',l_ecb.ecuud02))
            CALL l_ecb_buf.append(l_str)
        end foreach
    end foreach

    let l_file = FGL_GETENV("TEMPDIR")
    let l_file = l_file , "/","csmi134_",sfmt("%1%2%3.log",year(today),month(today),day(today))

    let l_ch = base.Channel.create()
    call l_ch.openFile( l_file, "a" )

    call l_ch.WriteLine(sfmt("--- ecb01: %1 ecb02: %2 time: %3 ---",p_ecb01,p_ecb02,current year to second))

    call l_ch.WriteLine('bmb: ')
    let l_str = l_bmb_buf.toString()
    call l_ch.WriteLine(l_str)


    call l_ch.WriteLine('ecb: \n')
    let l_str = l_ecb_buf.toString()
    call l_ch.WriteLine(l_ecb_buf.toString())

    call l_ch.WriteLine('--- end ---\n\n')

    call l_ch.close()
end function

# 记录bom和工艺资料的详细资料
function saeci100_log(p_ecb01,p_ecb02,p_bmb,p_ecb)
    define p_ecb01  like ecb_file.ecb01
    define p_ecb02  like ecb_file.ecb02
    define p_bmb    om.DomNode
    define p_ecb    om.DomNode
    --base.typeinfo.create(g_sfb_excel)
    define l_file,l_str   string

    let l_file = FGL_GETENV("TEMPDIR")
    let l_file = l_file , "/","csmi134_",sfmt("%1%2%3.log",year(today),month(today),day(today))

    # prefix
    let l_str = sfmt("--- ecb01: %1 ecb02: %2 time: %3 ---",p_ecb01,p_ecb02,current year to second)
    run "echo '"||l_str||"' >> "||l_file

    # bmb
    call p_bmb.toString() returning l_str
    run "echo '"||l_str||"' >> "||l_file

    # ecb
    call p_ecb.toString() returning l_str
    run "echo '"||l_str||"' >> "||l_file

    run "echo '--- end ---\n\n' >> "||l_file

end function
