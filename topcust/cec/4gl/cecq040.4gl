# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: cecq040.4gl
# Descriptions...: 管理员工单处理工具
# Date & Author..: 22/11/02 By darcy


database ds
globals "../../config/top.global"
# ---
# 依照LOT汇总
type sgm record
    sgm01       like sgm_file.sgm01,
    sgm03_par   like sgm_file.sgm03_par,
    sgm11       like sgm_file.sgm11,
    ima02       like ima_file.ima02,
    ima021      like ima_file.ima021,
    sgm03       like sgm_file.sgm03,
    sgm04       like sgm_file.sgm04,
    sgm45       like sgm_file.sgm45,
    sgm06       like sgm_file.sgm06,
    eca02       like eca_file.eca02,
    sgm65       like sgm_file.sgm301, #标准产出量
    sgm301      like sgm_file.sgm301, #上站转入量
    sgm302      like sgm_file.sgm301, #开工量
    sgm311      like sgm_file.sgm301, #完工量
    sgm313      like sgm_file.sgm301, #报废量
    sgm314      like sgm_file.sgm301, #下线数量
    sgm312      like sgm_file.sgm301, #返工量
    sgmwip      like sgm_file.sgm301, #在制量
    sgmin       like sgm_file.sgm301, #入库量
    sgmunin     like sgm_file.sgm301  #已完工未入库数量
end record
# 依工单汇总
type sfb record
    sfb01       like sfb_file.sfb01,
    sfb05       like sfb_file.sfb05,
    sfb06       like sfb_file.sfb06,
    ima02_1     like ima_file.ima02,
    ima021_1    like ima_file.ima021,
    sfa08       like sfa_file.sfa08,
    ecd02       like ecd_file.ecd02,
    ecd07       like ecd_file.ecd07,
    eca02_1     like eca_file.eca02,
    sfbwip      like sgm_file.sgm301,
    sfbunin     like sgm_file.sgm301
end record
# 依作业编号汇总
type ecd record
    ima01_2     like ima_file.ima01,
    ima02_2     like ima_file.ima02,
    ima021_2    like ima_file.ima021,
    ecd01_2     like ecd_file.ecd01,
    ecd02_2     like ecd_file.ecd02,
    ecd07_2     like ecd_file.ecd07,
    eca02_2     like eca_file.eca02,
    ecdwip      like sgm_file.sgm301,
    ecdunin     like sgm_file.sgm301
end record
# 依工作站汇总
type eca record
    ima01_3     like ima_file.ima01,
    ima02_3     like ima_file.ima02,
    ima021_3    like ima_file.ima021,
    ecd07_3     like ecd_file.ecd07,
    eca02_3     like eca_file.eca02,
    ecawip      like sgm_file.sgm301,
    ecaunin     like sgm_file.sgm301
end record
# 依照料号汇总
type ima record
    ima01_4     like ima_file.ima01,
    ima02_4     like ima_file.ima02,
    ima021_4    like ima_file.ima021,
    imawip      like sgm_file.sgm301,
    imaunin     like sgm_file.sgm301
end record
# ---


# ---
# 主资料
define g_sgm,g_sgm_excel dynamic array of sgm
define g_sfb,g_sfb_excel dynamic array of sfb
define g_ecd,g_ecd_excel dynamic array of ecd
define g_eca,g_eca_excel dynamic array of eca
define g_ima,g_ima_excel dynamic array of ima
# ---

# ---
define g_b_flag integer
define g_rec_b integer # 单身总比数
define g_cnt integer #总笔数
define l_ac,l_ac_t integer #单身当前笔数
# ---

# ---
# 工单条件和lot条件
define g_wc1,g_wc2 string
# ---

# ---
define flag_sgm     like type_file.chr1
define flag_sfb     like type_file.chr1
define flag_ecd     like type_file.chr1
define flag_eca     like type_file.chr1
define flag_ima     like type_file.chr1
# ---

main
    define   p_row,p_col   like type_file.num5          #no.fun-680121 smallint
    options                               #改變一些系統預設值
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CEC")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time #no.fun-b30211 
    open window cecq040 at p_row,p_col with form "cec/42f/cecq040"
            attribute (style = g_win_style clipped) #no.fun-580092 hcn
        
    call cl_ui_init()

    call cecq040()

    close window cecq040                 #結束畫面
    call  cl_used(g_prog,g_time,2) returning g_time 
end main
# declear
function cecq040_curs()
    # ---
    define l_sql   string
    # ---

    # ---
    # page1工单清单查询
    
    # ---

end function
# 查询条件
function cecq040_cs()
    clear form
    let g_action_choice=" "

    dialog
        construct g_wc1 on sfb01,sfb05,sfb06 from sfb01_q,sfb05_q,sfb06_q
            before construct
        end construct
        construct g_wc2 on sgm01,sgm03,sgm04,sgm06 from sgm01_q,sgm03_q,sgm04_q,sgm06_q
            before construct
        end construct

        on action controlp 
        
        on action accept
            let g_action_choice="accept"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog

        on action qbe_select
            call cl_qbe_select()

        on action qbe_save
            call cl_qbe_save()
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        
        on action about
            call cl_about()
        
        on action controlg
            call cl_cmdask()
        
        on action help
            call cl_show_help()

    end dialog

    if int_flag or g_action_choice = "exit" then    #mod-4b0238 add 'exit'
        return
    end if
end function
# main
function cecq040()
    call cecq040_ctr_temp()
    call cecq040_menu()
end function
# 菜单
function cecq040_menu()
    define l_file string

    while true
        call cecq040_bp("G")

        case g_action_choice
            when "help"
            call cl_show_help()
 
            when "exit"
                exit while
            when "close"
                exit while
    
            when "controlg"
                call cl_cmdask()

            when "query"
                if cl_chk_act_auth() then
                    call cecq040_q()
                end if
            
            when "exporttoexcel"
                # 导出excel
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(
                        cl_expexcel5(
                            "s_sgm",base.typeinfo.create(g_sgm_excel),
                            "s_sfb",base.typeinfo.create(g_sfb_excel),
                            "s_ecd",base.typeinfo.create(g_ecd_excel),
                            "s_eca",base.typeinfo.create(g_eca_excel),
                            "s_ima",base.typeinfo.create(g_ima_excel)
                        ))
                end if
            # TODO:功能按钮 s---

            # TODO:功能按钮 e---
        end case
    end while
end function
# 查询
function cecq040_q()
    let g_b_flag = "1"
    let g_rec_b = 0

    clear form
    let flag_sgm = 'N'
    let flag_sfb = 'N'
    let flag_ecd = 'N'
    let flag_eca = 'N'
    let flag_ima = 'N'

    display g_rec_b to cn2

    MESSAGE ""
    display '   ' to formonly.cnt

    call cecq040_cs()
    if int_flag or g_action_choice="exit" then
        let int_flag = 0
        return
    end if
    message " searching ! "

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
    else
        call cecq040_show()
    end if
    message ""
end function

# 查询
function cecq040_show()
    let g_b_flag = '1'
    call cecq040_fill(g_wc1,g_wc2)
end function
function cecq040_fill(p_wc1,p_wc2)
    # ---
    define p_wc1 string
    define p_wc2 string
    define l_sql string
    # ---

    # 插入未结案工单
    delete from cecq040_sfb_tmp
    let l_sql = "insert into cecq040_sfb_tmp",
                " select sfb01,sfb08 from sfb_file",
                " where sfb04 <> '8' and sfb87 = 'Y' and ",p_wc1 clipped
    prepare cecq040_ins_p from l_sql
    execute cecq040_ins_p
    if sqlca.sqlcode then
        call cl_err("ins cecq040_sfb_tmp",sqlca.sqlcode,1)
        return
    end if

    # 将完工数量 + 报废数量 >= 生产数量工单排除 
    let l_sql = "delete from cecq040_sfb_tmp where sfb01 in (
                select c.sfb01 from cecq040_sfb_tmp c
                left join (select tc_shb04, sum(tc_shb121) tc_shb121
                            from tc_shb_file, cecq040_sfb_tmp
                            where tc_shb04 = sfb01 and tc_shb01 = '2' and tc_shb121 <> 0
                            group by tc_shb04) a
                    on a.tc_shb04 = sfb01
                left join (select sfv11, sum(sfv09) sfb09
                            from sfu_file, cecq040_sfb_tmp, sfv_file
                            where sfu01 = sfv01 and sfv11 = sfb01 and sfupost = 'Y' and sfuconf = 'Y'
                            group by sfv11) b
                    on b.sfv11 = sfb01
                where c.sfb08 <= nvl(tc_shb121,0)+ nvl(b.sfb09,0))"
    prepare cecq040_del_p from l_sql
    execute cecq040_del_p
    if sqlca.sqlcode then
        call cl_err("cecq040_del_p",sqlca.sqlcode,1)
        return
    end if


    delete from cecq040_sgm_tmp
    # sgm65       like sgm_file.sgm301, #标准产出量
    # 将所有LOT批单抓取出来
    let l_sql = " insert into cecq040_sgm_tmp select sgm01,sgm02,sgm03_par,sgm11,ima02,ima021,sgm03, ",
                " sgm04,sgm45,sgm06,eca02,sgm65,0sgm301, 0sgm302,0sgm311,0sgm313, ",
                " 0sgm314,0sgm312,0sgmwip,0sgmin,0sgmunin,0sgmprev,0sgmnext ",
                " from cecq040_sfb_tmp, sgm_file ",
                " left join ima_file on ima01 = sgm03_par ",
                " left join eca_file on eca01 = sgm06 ",
                " where sfb01 = sgm02 "
    prepare cecq040_ins_sgm from l_sql
    execute cecq040_ins_sgm
    if sqlca.sqlcode then
        call cl_err('cecq040_ins_sgm',sqlca.sqlcode,1)
        return
    end if

    # sgm302      like sgm_file.sgm301, #开工量
    # sgm311      like sgm_file.sgm301, #完工量
    # sgm313      like sgm_file.sgm301, #报废量
    let l_sql = "merge into cecq040_sgm_tmp a using ( select tc_shb03,tc_shb06, ",
                "     sum(case tc_shb01 when '1' then nvl(tc_shb12, 0) else 0 end)  sgm302, ",
                "     sum(case tc_shb01 when '2' then nvl(tc_shb12, 0) else 0 end)  sgm311, ",
                "     sum(case tc_shb01 when '2' then nvl(tc_shb121, 0) else 0 end) sgm313 ",
                " from tc_shb_file,cecq040_sgm_tmp  ",
                " where tc_shb03 = sgm01 and tc_shb06 = sgm03",
                " group by tc_shb03,tc_shb06 ) b",
                " on (a.sgm01 = b.tc_shb03 and a.sgm03 = b.tc_shb06)",
                " when matched then update set a.sgm302=b.sgm302,a.sgm311=b.sgm311,a.sgm313=b.sgm313"  
    prepare cecq040_upd_tc_shb from l_sql
    execute cecq040_upd_tc_shb
    if sqlca.sqlcode then
        call cl_err('cecq040_upd_tc_shb',sqlca.sqlcode,1)
        return
    end if

    # sgm314      like sgm_file.sgm301, #下线数量
    # 更新下线数量
    let l_sql = "merge into cecq040_sgm_tmp ",
                " using (select shb16,shb06,sum(tsc05) tsc05 from tsc_file,shb_file ",
                " where tscud02 = shb01 and tscconf='Y' and tscpost='Y') ",
                " on (shb16 = sgm01 and shb06 = sgm03) ",
                " when matched then update set sgm314 = nvl(tsc05,0)"
    prepare cecq040_upd_sgm from l_sql
    execute cecq040_upd_sgm
    if sqlca.sqlcode then
        call cl_err('cecq040_upd_sgm',sqlca.sqlcode,1)
        return
    end if

    # sgmnext
    # sgmprev
    # 更新上站与下站
    let l_sql = "merge into cecq040_sgm_tmp a using ( ",
                "  select sgm01,sgm03, ",
                "  lag(sgm03,1,-20) over (PARTITION by sgm01 order by sgm03 desc ) sgmnext, ",
                "  lag(sgm03,1,-10) over (partition by sgm01 order by sgm03) sgmprev ",
                "  from cecq040_sgm_tmp ",
                "  ) b on (a.sgm01=b.sgm01 and a.sgm03 = b.sgm03) ",
                "  when matched then update set a.sgmnext=b.sgmnext,a.sgmprev=b.sgmprev"
    prepare cecq040_upd_sgmprev from l_sql
    execute cecq040_upd_sgmprev
    if sqlca.sqlcode then
        call cl_err('cecq040_upd_sgmprev',sqlca.sqlcode,1)
        return
    end if
    
    # sgm301      like sgm_file.sgm301, #上站转入量
    let l_sql = "merge into cecq040_sgm_tmp a ",
                " using cecq040_sgm_tmp b ",
                " on (a.sgm01 =b.sgm01 and b.sgm03 = a.sgmprev ) ",
                " when matched then update set a.sgm301 = b.sgm311"
    prepare cecq040_upd_sgm301 from l_sql
    execute cecq040_upd_sgm301
    if sqlca.sqlcode then
        call cl_err('cecq040_upd_sgm301',sqlca.sqlcode,1)
        return
    end if

    # sgmin       like sgm_file.sgm301, #入库量
    # sgm312      like sgm_file.sgm301, #返工量
    let l_sql = "merge into cecq040_sgm_tmp using ( ",
                " select sfv20,sum(sfv09) sfv09 from sfu_file,sfv_file ",
                " where sfu01 =sfv01 and sfuconf='Y' and sfupost='Y' ",
                " group by sfv20) on (a.sgm01 = sfv20 and a.sgm03 =-20) ",
                " when matched then udpate set a.sgmin = sfv09"
    prepare cecq040_upd_asft623 from l_sql
    execute cecq040_upd_asft623
    if sqlca.sqlcode then
        call cl_err('cecq040_upd_asft623',sqlca.sqlcode,1)
        return
    end if

    # sgmunin     like sgm_file.sgm301  #已完工未入库数量
    let l_sql = "update cecq040_sgm_tmp set sgmunin = sgm311 - sgmin ",
                " where sgm03 =-20 "
    prepare cecq040_upd_sgmunin from l_sql
    execute cecq040_upd_sgmunin
    if sqlca.sqlcode then
        call cl_err('cecq040_upd_sgmunin',sqlca.sqlcode,1)
        return
    end if

    # sgmwip      like sgm_file.sgm301, #在制量
    update cecq040_sgm_tmp set sgmwip = sgm302 - sgm311 - sgm313 - sgm314
    if sqlca.sqlcode then
        call cl_err('upd sgm302',sqlca.sqlcode,1)
        return
    end if

    # 删除无WIP,无unin
    delete from cecq040_sgm_tmp
     where sgmwip = 0 and sgmunin = 0
    
    # sgm
    let l_sql = "select sgm01,sgm03_par,sgm11,ima02,ima021,sgm03, ",
                "       sgm04,sgm45,sgm06,eca02,sgm65,sgm301,sgm302, ",
                "       sgm311,sgm313,sgm314,sgm312,sgmwip,sgmin,sgmunin ",
                "  from cecq040_sgm_tmp order by sgm01,sgm03"
    prepare cecq040_sgm from l_sql
    declare cecq040_sgm_cur cursor for cecq040_sgm

    call g_sgm_excel.clear()
    call g_sgm.clear()
    let g_cnt = 1
    foreach cecq040_sgm_cur into g_sgm_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cecq040_sgm_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt < g_max_rec then
            let g_sgm[g_cnt].* = g_sgm_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sgm_excel.deleteElement(g_cnt)

    # sfb
    let l_sql = " select sgm02 sfb01,sgm03_par sfb05,sgm11 sfb06,ima02 ima02_1,ima021 ima021_1, ",
                "        sgm04 sfa08,sgm45 ecd02,sgm06 ecd07,eca02 eca02_1, ",
                "        sum(sgmwip) sfbwip,sum(sgmunin) sfbunin ",
                "   from cecq040_sgm_tmp ",
                "   group by sgm02,sgm03_par,sgm11,ima02,ima021,sgm04,sgm45,sgm06,eca02 ",
                "   order by sgm02,sgm04 "
    prepare cecq040_sfb from l_sql
    declare cecq040_sfb_cur cursor for cecq040_sfb

    call g_sfb_excel.clear()
    call g_sfb.clear()
    let g_cnt = 1
    foreach cecq040_sfb_cur into g_sfb_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cecq040_sfb_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt < g_max_rec then
            let g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_sfb_excel.deleteElement(g_cnt)

    # ecd
    let l_sql = "select sgm03_par ima01_2,ima02 ima02_2,ima021 ima021_2,sgm04 ecd01_2,sgm45 ecd02_2 , ",
                "       sgm06 ecd07_2,eca02 eca02_2,sum(sgmin) ecdwip,sum(sgmunin) ecdunin ",
                "  from cecq040_sgm_tmp ",
                " group by sgm03_par,ima02,ima021,sgm04,sgm45,sgm06,eca02 ",
                " order by sgm03_par,sgm04"

    prepare cecq040_ecd from l_sql
    declare cecq040_ecd_cur cursor for cecq040_ecd

    call g_ecd_excel.clear()
    call g_ecd.clear()
    let g_cnt = 1
    foreach cecq040_ecd_cur into g_ecd_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cecq040_ecd_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt < g_max_rec then
            let g_ecd[g_cnt].* = g_ecd_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_ecd_excel.deleteElement(g_cnt)

    # eca
    let l_sql = "select sgm03_par ima01_3,ima02 ima02_3,ima021 ima021_3, ",
                "       sgm06 ecd07_3,eca02 eca02_3, ",
                "       sum(sgmwip) ecawip,sum(sgmunin) ecaunin ",
                "  from cecq040_sgm_tmp",
                " group by sgm03_par,ima02,ima021,sgm06,eca02",
                " order by sgm03_par,sgm06 "
    prepare cecq040_eca from l_sql
    declare cecq040_eca_cur cursor for cecq040_eca

    call g_eca_excel.clear()
    call g_eca.clear()
    let g_cnt = 1
    foreach cecq040_eca_cur into g_eca_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cecq040_eca_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt < g_max_rec then
            let g_eca[g_cnt].* = g_eca_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_eca_excel.deleteElement(g_cnt)

    # ima
    let l_sql = "select sgm03_par ima01_4,ima02 ima02_4,ima021 ima021_4, ",
                "       sum(sgmwip) imawip,sum(sgmunin) imaunin ",
                "  from cecq040_sgm_tmp ",
                " group by sgm03_par,ima02,ima021 ",
                " order by sgm03_par"
    prepare cecq040_ima from l_sql
    declare cecq040_ima_cur cursor for cecq040_ima

    call g_ima_excel.clear()
    call g_ima.clear()
    let g_cnt = 1
    foreach cecq040_ima_cur into g_ima_excel[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('cecq040_ima_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        if g_cnt < g_max_rec then
            let g_ima[g_cnt].* = g_ima_excel[g_cnt].*
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_ima_excel.deleteElement(g_cnt)

end function

function cecq040_ctr_temp()

    drop table cecq040_sfb_tmp
    create temp table cecq040_sfb_tmp(
        sfb01  varchar(40),
        sfb08  decimal(15,3)
    )
    drop table cecq040_sgm_tmp
    create temp table cecq040_sgm_tmp(
        sgm01       varchar(40),
        sgm02       varchar(40),
        sgm03_par   varchar(40),
        sgm11       varchar(10),
        ima02       varchar(120),
        ima021      varchar(120),
        sgm03       decimal(5),
        sgm04       varchar(10),
        sgm45       varchar(120),
        sgm06       varchar(10),
        eca02       varchar(40),
        sgm65       decimal(15,3),
        sgm301      decimal(15,3),
        sgm302      decimal(15,3),
        sgm311      decimal(15,3),
        sgm313      decimal(15,3),
        sgm314      decimal(15,3),
        sgm312      decimal(15,3),
        sgmwip      decimal(15,3),
        sgmin       decimal(15,3),
        sgmunin     decimal(15,3), 
        sgmprev     decimal(5),
        sgmnext     decimal(5)
    )
    create index cecq040_sgm01 on cecq040_sgm_tmp(sgm01,sgm03)
end function

function cecq040_bp(p_ud)
    define   p_ud   like type_file.chr1
    define   l_index    integer

    if p_ud <> "G" then
        return
    end if
    let g_action_choice = " "

    # call cecq040_fill(g_wc1,g_wc2)

    call cl_set_act_visible("accept,cancel", false)

    dialog
        display array g_sgm to s_sgm.* 
            before row
                let l_ac = arr_curr()
                display l_ac to formonly.cnt
        end display
        display array g_sfb to s_sfb.*
            before row
                let l_ac = arr_curr()
                display l_ac to formonly.cnt
        end display
        display array g_ecd to s_ecd.*
            before row
                let l_ac = arr_curr()
                display l_ac to formonly.cnt
        end display
        display array g_eca to s_eca.*
            before row
                let l_ac = arr_curr()
                display l_ac to formonly.cnt
        end display
        display array g_ima to s_ima.*
            before row
                let l_ac = arr_curr()
                display l_ac to formonly.cnt
        end display

        on action help
            let g_action_choice="help"
            exit dialog
        on action exit
            let g_action_choice="exit"
            exit dialog
        on action controlg
            let g_action_choice="controlg"
            exit dialog
        on action query
            let g_action_choice="query"
            exit dialog 
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
    end dialog
    call cl_set_act_visible("accept,cancel", true)
end function

