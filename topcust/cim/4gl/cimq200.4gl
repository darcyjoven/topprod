# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cimq200
# Descriptions...: 料件预计需求情况查询
# Date & Author..:darcy:2023/04/21 add


database ds

globals "../../../tiptop/config/top.global"

# 单身数据类型 s---
    type imk record
        bmb01       like bmb_file.bmb01,
        bmb03       like bmb_file.bmb03,
        bmb03sub    varchar(500),
        bmb06       like bmb_file.bmb06,
        imk09       like imk_file.imk09,
        imk09_1     like imk_file.imk09,
        avnum       like type_file.num15_3,
        avset       like type_file.num15_3,
        wip         like type_file.num15_3,
        stock       like type_file.num15_3,
        out01       like type_file.num15_3,
        in01        like type_file.num15_3,
        plan01      like type_file.num15_3,
        fin01       like type_file.num15_3,
        out02       like type_file.num15_3,
        in02        like type_file.num15_3,
        plan02      like type_file.num15_3,
        fin02       like type_file.num15_3,
        out03       like type_file.num15_3,
        in03        like type_file.num15_3,
        plan03      like type_file.num15_3,
        fin03       like type_file.num15_3,
        out04       like type_file.num15_3,
        in04        like type_file.num15_3,
        plan04      like type_file.num15_3,
        fin04       like type_file.num15_3,
        out05       like type_file.num15_3,
        in05        like type_file.num15_3,
        plan05      like type_file.num15_3,
        fin05       like type_file.num15_3,
        out06       like type_file.num15_3,
        in06        like type_file.num15_3,
        plan06      like type_file.num15_3,
        fin06       like type_file.num15_3,
        out07       like type_file.num15_3,
        in07        like type_file.num15_3,
        plan07      like type_file.num15_3,
        fin07       like type_file.num15_3,
        out08       like type_file.num15_3,
        in08        like type_file.num15_3,
        plan08      like type_file.num15_3,
        fin08       like type_file.num15_3,
        out09       like type_file.num15_3,
        in09        like type_file.num15_3,
        plan09      like type_file.num15_3,
        fin09       like type_file.num15_3,
        out10       like type_file.num15_3,
        in10        like type_file.num15_3,
        plan10      like type_file.num15_3,
        fin10       like type_file.num15_3,
        out11       like type_file.num15_3,
        in11        like type_file.num15_3,
        plan11      like type_file.num15_3,
        fin11       like type_file.num15_3,
        out12       like type_file.num15_3,
        in12        like type_file.num15_3,
        plan12      like type_file.num15_3,
        fin12       like type_file.num15_3,
        out13       like type_file.num15_3,
        in13        like type_file.num15_3,
        plan13      like type_file.num15_3,
        fin13       like type_file.num15_3,
        out14       like type_file.num15_3,
        in14        like type_file.num15_3,
        plan14      like type_file.num15_3,
        fin14       like type_file.num15_3,
        out15       like type_file.num15_3,
        in15        like type_file.num15_3,
        plan15      like type_file.num15_3,
        fin15       like type_file.num15_3,
        out16       like type_file.num15_3,
        in16        like type_file.num15_3,
        plan16      like type_file.num15_3,
        fin16       like type_file.num15_3,
        out17       like type_file.num15_3,
        in17        like type_file.num15_3,
        plan17      like type_file.num15_3,
        fin17       like type_file.num15_3,
        out18       like type_file.num15_3,
        in18        like type_file.num15_3,
        plan18      like type_file.num15_3,
        fin18       like type_file.num15_3,
        out19       like type_file.num15_3,
        in19        like type_file.num15_3,
        plan19      like type_file.num15_3,
        fin19       like type_file.num15_3,
        out20       like type_file.num15_3,
        in20        like type_file.num15_3,
        plan20      like type_file.num15_3,
        fin20       like type_file.num15_3,
        out21       like type_file.num15_3,
        in21        like type_file.num15_3,
        plan21      like type_file.num15_3,
        fin21       like type_file.num15_3,
        out22       like type_file.num15_3,
        in22        like type_file.num15_3,
        plan22      like type_file.num15_3,
        fin22       like type_file.num15_3,
        out23       like type_file.num15_3,
        in23        like type_file.num15_3,
        plan23      like type_file.num15_3,
        fin23       like type_file.num15_3,
        out24       like type_file.num15_3,
        in24        like type_file.num15_3,
        plan24      like type_file.num15_3,
        fin24       like type_file.num15_3,
        out25       like type_file.num15_3,
        in25        like type_file.num15_3,
        plan25      like type_file.num15_3,
        fin25       like type_file.num15_3,
        out26       like type_file.num15_3,
        in26        like type_file.num15_3,
        plan26      like type_file.num15_3,
        fin26       like type_file.num15_3,
        out27       like type_file.num15_3,
        in27        like type_file.num15_3,
        plan27      like type_file.num15_3,
        fin27       like type_file.num15_3,
        out28       like type_file.num15_3,
        in28        like type_file.num15_3,
        plan28      like type_file.num15_3,
        fin28       like type_file.num15_3,
        out29       like type_file.num15_3,
        in29        like type_file.num15_3,
        plan29      like type_file.num15_3,
        fin29       like type_file.num15_3,
        out30       like type_file.num15_3,
        in30        like type_file.num15_3,
        plan30      like type_file.num15_3,
        fin30       like type_file.num15_3,
        out31       like type_file.num15_3,
        in31        like type_file.num15_3,
        plan31      like type_file.num15_3,
        fin31       like type_file.num15_3
    end record
# 单身数据类型 e---

# 单身颜色设置 s---
    type imk_color record
        bmb01       string,
        bmb03       string,
        bmb03sub    string,
        bmb06       string,
        imk09       string,
        imk09_1     string,
        avnum       string,
        avset       string,
        wip         string,
        stock       string,
        out01       string,
        in01        string,
        plan01      string,
        fin01       string,
        out02       string,
        in02        string,
        plan02      string,
        fin02       string,
        out03       string,
        in03        string,
        plan03      string,
        fin03       string,
        out04       string,
        in04        string,
        plan04      string,
        fin04       string,
        out05       string,
        in05        string,
        plan05      string,
        fin05       string,
        out06       string,
        in06        string,
        plan06      string,
        fin06       string,
        out07       string,
        in07        string,
        plan07      string,
        fin07       string,
        out08       string,
        in08        string,
        plan08      string,
        fin08       string,
        out09       string,
        in09        string,
        plan09      string,
        fin09       string,
        out10       string,
        in10        string,
        plan10      string,
        fin10       string,
        out11       string,
        in11        string,
        plan11      string,
        fin11       string,
        out12       string,
        in12        string,
        plan12      string,
        fin12       string,
        out13       string,
        in13        string,
        plan13      string,
        fin13       string,
        out14       string,
        in14        string,
        plan14      string,
        fin14       string,
        out15       string,
        in15        string,
        plan15      string,
        fin15       string,
        out16       string,
        in16        string,
        plan16      string,
        fin16       string,
        out17       string,
        in17        string,
        plan17      string,
        fin17       string,
        out18       string,
        in18        string,
        plan18      string,
        fin18       string,
        out19       string,
        in19        string,
        plan19      string,
        fin19       string,
        out20       string,
        in20        string,
        plan20      string,
        fin20       string,
        out21       string,
        in21        string,
        plan21      string,
        fin21       string,
        out22       string,
        in22        string,
        plan22      string,
        fin22       string,
        out23       string,
        in23        string,
        plan23      string,
        fin23       string,
        out24       string,
        in24        string,
        plan24      string,
        fin24       string,
        out25       string,
        in25        string,
        plan25      string,
        fin25       string,
        out26       string,
        in26        string,
        plan26      string,
        fin26       string,
        out27       string,
        in27        string,
        plan27      string,
        fin27       string,
        out28       string,
        in28        string,
        plan28      string,
        fin28       string,
        out29       string,
        in29        string,
        plan29      string,
        fin29       string,
        out30       string,
        in30        string,
        plan30      string,
        fin30       string,
        out31       string,
        in31        string,
        plan31      string,
        fin31       string
    end record
# 单身颜色设置 e---
# 条件输入 s---
    define tm   record
            wc      string,
            yy      like type_file.num5,
            mm      like type_file.num5,
            only    like type_file.chr1
        end record
# 条件输入 e---


# 单身遍历 s---
    define g_imk dynamic array of imk
    define g_imk_color dynamic array of imk_color
    
# 单身遍历 e---

# 常用变量 s---
    define g_cnt        like type_file.num5
    define g_sql        string
    define g_jump       like type_file.num10
    define mi_no_ask    like type_file.num5
    define g_rec_b      like type_file.num5
# 常用变量 e---

main
    define p_row,p_col  integer
    options
        input no wrap
    defer interrupt

    if (not cl_user()) then
        exit program
    end if

    whenever error call cl_err_msg_log

    if (not cl_setup("CIM")) then
        exit program
    end if

    call  cl_used(g_prog,g_time,1)
         returning g_time

    let p_row = 4 let p_col = 3
    # 打开窗口 s---
    open window q200_w at p_row,p_col with form "cim/42f/cimq200"
     attribute (style = g_win_style clipped)
    # 打开窗口 e---
    call cl_ui_init()

    call q200_menu()

    close window i200_w 
    call cl_used(g_prog,g_time,2) returning g_time
end main

# 查询条件QBE
function q200_cs()
    define l_cnt    like type_file.num5

    clear form
    call g_imk.clear()

    call cl_opmsg('q')

    initialize tm.* to null
    # call cl_set_head_visible('','YES')
    call q200_comb_set()
    let tm.yy = YEAR(g_today)
    let tm.mm = MONTH(g_today)
    let tm.only = '1'
    dialog
        input by name tm.yy,tm.mm,tm.only attribute( without defaults)
            before input
            after field tm.mm
                message ''
        end input

        construct tm.wc on tc_pla01
            from s_imk[1].bmb01--,s_imk[1].bmb03
        end construct

        on action controlp
            # 开窗
            case
                when infield(bmb01)
                    call cl_init_qry_var()
                    let g_qryparam.state  = "c"
                    let g_qryparam.form   = "q_bma10"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to bmb01
                    next field bmb01
                when infield(bmb03)
                    call cl_init_qry_var()
                    let g_qryparam.state  = "c"
                    let g_qryparam.form   = "q_bmb203"
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to bmb03
                    next field bmb03
                otherwise
                    exit case
            end case
        
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

    if int_flag then
        return
    end if

    let g_sql = " select count(1) from tc_pla_file where tc_pla02='Y' and (tc_pla01,tc_pla04) in ( ",
                " select tc_pla01,max(tc_pla04) from tc_pla_file where tc_pla02 ='y' group by tc_pla01) "
    prepare q200_pb from g_sql
    declare q200_count cursor for q200_pb
end function

# 菜单
function q200_menu()
    while true
        call q200_bp('G')
        case g_action_choice
            when 'query'
                if cl_chk_act_auth() then
                    call q200_q()
                end if
            when 'help'
                call cl_show_help()
            when 'exit'
                exit while
            when 'controlg'
                call cl_cmdask()
            when 'exporttoexcel'
                if cl_chk_act_auth() then
                    if g_user = 'tiptop' then
                        call q200_excel_out()
                    else
                        call cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imk),'','')
                    end if
                end if
        end case
    end while
end function

# 查询
function q200_q()
    # 如果有翻页可以做fetch函数
    # 本作业不含有翻页功能,直接调用cs后，b_fill
    call q200_cs()
    if int_flag then
        return
    end if
    call q200_b_fill()
end function

# 单身资料准备
function q200_b_fill()
    define l_bmb01          like bmb_file.bmb01
    define bdate,edate      like type_file.dat
    define l_bdate,l_edate      like type_file.dat
    define l_cnt,l_i         like type_file.num5
    define l_yy,l_mm        integer

    call q200_comb_visiable(tm.yy,tm.mm)
    call q200_crt_temp()
    # 获取当月第一天和最后一天
    let g_sql = "select to_date('",tm.yy,tm.mm using '&&',"01'),last_day(to_date('",tm.yy,tm.mm using '&&',"01')) from dual"
    prepare q200_get_day from g_sql
    execute q200_get_day into bdate,edate

    # 1.处理要计算的成品料号和客供料号
    let g_sql = " select tc_pla01 from tc_pla_file",
                "  where (tc_pla01, tc_pla04) in (",
                "     select tc_pla01, max(tc_pla04) from tc_pla_file",
                "      where tc_pla02 = 'Y' group by tc_pla01) and ",tm.wc
    prepare q200_i200_pb from g_sql
    declare q200_i200_curs cursor for q200_i200_pb

    let g_sql = " insert into aimq200_tmp (bmb01,bmb01_1,bmb03,bmb06) select ?,bmb01,bmb03,bmb06/bmb07 from bmb_file,ima_file ",
                " where bmb04 <=? and (bmb05 is null or bmb05 > ?)  and ima01 = bmb03",
                " and (bmb03 like 'K.%' or bmb03 like 'E.%' or ima021 like 'FPC%-半成品' ) start with bmb01 = ? connect by prior bmb03 = bmb01 "
    
    prepare q200_temp_ins from g_sql

    foreach q200_i200_curs into l_bmb01
        if sqlca.sqlcode then
            call cl_err('q200_i200_curs',sqlca.sqlcode,1)
            exit foreach
        end if
        execute q200_temp_ins using l_bmb01,g_today,g_today,l_bmb01
        if sqlca.sqlcode then
            call cl_err('q200_temp_ins: '||l_bmb01,sqlca.sqlcode,1)
            continue foreach
        end if
    end foreach

    # 2. 替代料抓取
    let g_sql = "insert into aimq200_sub select bmb01,bmd08,bmd01,bmd04 from ( ",
                " select bmd08,bmd01,bmd04 from bmd_file ",
                " where bmd05 <? and (bmd06 is null or bmd06 >?)) , aimq200_tmp ",
                " where bmd08=bmb01_1 and bmd01 = bmb03 "
    prepare q200_sub_ins from g_sql
    execute q200_sub_ins using g_today,g_today

    if sqlca.sqlcode then
        call cl_err('q200_sub_ins',sqlca.sqlcode,1)
        return
    end if

    #2.1 将委外料半成品作为客供料的替代料

    let g_sql = "insert into aimq200_sub",
                " select bmb01,bmb01_1,bmb03,bmb01_1",
                " from aimq200_tmp, ima_file",
                " where ima01 = bmb01_1",
                " and ima08 = 'S'"
    prepare q200_sub_ins2 from g_sql
    execute q200_sub_ins2

    if sqlca.sqlcode then
        call cl_err('q200_sub_ins2',sqlca.sqlcode,1)
        return
    end if


    # 3.库存和可用套数
    # 3.1 如果前月还未imk结账，报错
    if tm.mm - 2 <= 0 then
        let l_yy = tm.yy - 1
        let l_mm = tm.mm - 2 + 12
    else
        let l_yy = tm.yy
        let l_mm = tm.mm - 2
    end if
    let l_cnt = 0
    select count(1) into l_cnt from imk_file where imk05 =l_yy and imk06 =l_mm and rownum <10
    if l_cnt <= 0 then
        call cl_err_msg('资料缺失','cim-027',tm.yy||'|'||tm.mm,1)
        return
    end if

    #3.2 如果上月没有，则需要计算前个月再加上本月库存异动。
    if tm.mm - 1 <= 0 then
        let l_yy = tm.yy - 1
        let l_mm = tm.mm - 1 + 12
    else
        let l_yy = tm.yy
        let l_mm = tm.mm - 1
    end if


    let l_cnt = 0
    select count(1) into l_cnt from imk_file where imk05 =l_yy and imk06 =l_mm and rownum <10
    if cl_null(l_cnt ) then let l_cnt = 0 end if
    if l_cnt <= 0 then
        let g_sql = "select to_date('",l_yy,l_mm using '&&',"01'),last_day(to_date('",l_yy,l_mm using '&&',"01')) from dual"
        prepare q200_get_day2 from g_sql
        execute q200_get_day2 into l_bdate,l_edate
        if sqlca.sqlcode then
            call cl_err('q200_get_day2',sqlca.sqlcode,1)
            return
        end if
        #无上月结存，取前个月
        if tm.mm - 2 <= 0 then
            let l_yy = tm.yy - 1
            let l_mm = tm.mm - 2 + 12
        else
            let l_yy = tm.yy
            let l_mm = tm.mm - 2
        end if
    end if

    # XBC
    let g_sql = " merge into aimq200_tmp a using (",
                " select bmb01,bmb01_1,bmb03,sum(nvl(imk09,0)) imk09 from (",
                "  select bmb01,bmb01_1,bmb03,bmb03 bmb03sub from aimq200_tmp",
                " union all",
                # " -- 替代料",
                " select bmb01,bmb01_1,bmb03,bmd04 from aimq200_sub )",
                " left join imk_file on imk01= bmb03sub and imk02 = 'XBC' and imk05= ? and imk06= ? ",
                " group by bmb01,bmb01_1,bmb03 )b ",
                " on(a.bmb01 = b.bmb01 and a.bmb01_1 = b.bmb01_1 and a.bmb03 = b.bmb03 )",
                " when matched then update set a.imk09_1 = b.imk09 "
    prepare q200_imk_xbc from g_sql
    execute q200_imk_xbc using l_yy,l_mm
    if sqlca.sqlcode then
        call cl_err('q200_imk_xbc',sqlca.sqlcode,1)
        return
    end if

    # other
    let g_sql = " merge into aimq200_tmp a using (",
                " select bmb01,bmb01_1,bmb03,sum(nvl(imk09,0)) imk09 from (",
                "  select bmb01,bmb01_1,bmb03,bmb03 bmb03sub from aimq200_tmp",
                " union all",
                # " -- 替代料",
                " select bmb01,bmb01_1,bmb03,bmd04 from aimq200_sub )",
                " left join imk_file on imk01= bmb03sub and imk02 != 'XBC' and imk05= ? and imk06= ? ",
                " group by bmb01,bmb01_1,bmb03 )b ",
                " on(a.bmb01 = b.bmb01 and a.bmb01_1 = b.bmb01_1 and a.bmb03 = b.bmb03 )",
                " when matched then update set a.imk09 = b.imk09 "
    prepare q200_imk_other from g_sql
    execute q200_imk_other using l_yy,l_mm
    if sqlca.sqlcode then
        call cl_err('q200_imk_other',sqlca.sqlcode,1)
        return
    end if

    if l_cnt <= 0 then
        #上月无结存还需要加上上月库存异动数量
        # XBC
        let g_sql = " merge into aimq200_tmp a using (",
                    " select bmb01,bmb01_1,bmb03,sum(nvl(tlf10,0)) tlf10 from (",
                    "  select bmb01,bmb01_1,bmb03,bmb03 bmb03sub from aimq200_tmp",
                    " union all",
                    # " -- 替代料",
                    " select bmb01,bmb01_1,bmb03,bmd04 from aimq200_sub )",
                    " left join (select tlf01,sum(tlf10*tlf907*tlf12) tlf10 from tlf_file ",
                    "             where tlf06 between ? and ? and tlf902 ='XBC' group by tlf01) ",
                    "   on tlf01= bmb03sub group by bmb01,bmb01_1,bmb03 )b ",
                    " on(a.bmb01 = b.bmb01 and a.bmb01_1 = b.bmb01_1 and a.bmb03 = b.bmb03 )",
                    " when matched then update set a.imk09_1 = a.imk09_1 + b.tlf10 "
        prepare q200_last_xbc from g_sql
        execute q200_last_xbc using l_bdate,l_edate
        if sqlca.sqlcode then
            call cl_err('q200_last_xbc',sqlca.sqlcode,1)
            return
        end if
        # other
        let g_sql = " merge into aimq200_tmp a using (",
                    " select bmb01,bmb01_1,bmb03,sum(nvl(tlf10,0)) tlf10 from (",
                    "  select bmb01,bmb01_1,bmb03,bmb03 bmb03sub from aimq200_tmp",
                    " union all",
                    # " -- 替代料",
                    " select bmb01,bmb01_1,bmb03,bmd04 from aimq200_sub )",
                    " left join (select tlf01,sum(tlf10*tlf907*tlf12) tlf10 from tlf_file ",
                    "             where tlf06 between ? and ? and tlf902 !='XBC' group by tlf01) ",
                    "   on tlf01= bmb03sub group by bmb01,bmb01_1,bmb03 )b ",
                    " on(a.bmb01 = b.bmb01 and a.bmb01_1 = b.bmb01_1 and a.bmb03 = b.bmb03 )",
                    " when matched then update set a.imk09 = a.imk09 + b.tlf10 "
        prepare q200_last_other from g_sql
        execute q200_last_other using l_bdate,l_edate
        if sqlca.sqlcode then
            call cl_err('q200_last_other',sqlca.sqlcode,1)
            return
        end if
    end if

    # 4 更新可用数量，可成套数量
    # 4.1 可用数量
    update aimq200_tmp set avnum = nvl(imk09,0)+nvl(imk09_1,0)
    if sqlca.sqlcode then
        call cl_err('aimq200_tmp upd',sqlca.sqlcode,1)
        return
    end if
    #4.2 成套数量
    update aimq200_tmp set avset = avnum / bmb06
    if sqlca.sqlcode then
        call cl_err('aimq200_tmp upd2',sqlca.sqlcode,1)
        return
    end if
    # 4.3 在制数量 
    let g_sql = "merge into aimq200_tmp using ( ",
                " select sgm03_par, sum (sgm301 - sgm313 - sgm311 - shb111) sgm301",
                "  from ( select a.sgm01,a.sgm03_par,a.sgm03,a.sgm04,a.sgm301,a.sgm313,a.sgm311,",
                "                sum(nvl(shb111, 0)) shb111 from sgm_file a",
                "           left join ( select shb16,shb06,sum(shb111) shb111",
                "                         from tsc_file,shb_file",
                "                        where tscud02 = shb01 and tscpost = 'Y'",
                "                        group by shb16,shb06",
                "                     ) on shb16 = a.sgm01 and shb06 <= a.sgm03,sfb_file",
                " where a.sgm02 = sfb01 and sfb04 < 8 and a.sgm301 - a.sgm313 - a.sgm311 <> 0",
                "  and a.sgm03 > (select min(b.sgm03) from sgm_file b where a.sgm01 = b.sgm01)",
                "   group by a.sgm01,a.sgm03_par,a.sgm03,a.sgm04,a.sgm301,a.sgm313,a.sgm311)",
                " group by sgm03_par) ",
                " on (bmb01 = sgm03_par) ",
                " when matched then update set wip = sgm301 * bmb06 "
    prepare q200_wip_upd from g_sql
    execute q200_wip_upd
    if sqlca.sqlcode then
        call cl_err('q200_wip_upd',sqlca.sqlcode,1)
        return
    end if
    # 4.4 库存数量
    let g_sql = "merge into aimq200_tmp using ( ",
                " select img01,sum(img10) img10 from img_file ",
                " where img02 !='ZTC' group by img01) ",
                " on (bmb01 = img01) ",
                " when matched then update set stock = img10 * bmb06 "
    prepare q200_stock_upd from g_sql
    execute q200_stock_upd
    if sqlca.sqlcode then
        call cl_err('q200_stock_upd',sqlca.sqlcode,1)
        return
    end if
    update aimq200_tmp set stock = 0 where stock is null

    # 5 计划
    let g_sql = "insert into aimq200_amt",
                " select bmb01,bmb01_1,bmb03,'plan',1,tc_pla05*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01 ",
                " union all select bmb01,bmb01_1,bmb03,'plan',2,tc_pla06*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',3,tc_pla07*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',4,tc_pla08*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',5,tc_pla09*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',6,tc_pla10*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',7,tc_pla11*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',8,tc_pla12*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',9,tc_pla13*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',10,tc_pla14*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',11,tc_pla15*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',12,tc_pla16*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',13,tc_pla17*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',14,tc_pla18*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',15,tc_pla19*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',16,tc_pla20*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',17,tc_pla21*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',18,tc_pla22*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',19,tc_pla23*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',20,tc_pla24*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',21,tc_pla25*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',22,tc_pla26*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',23,tc_pla27*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',24,tc_pla28*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',25,tc_pla29*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',26,tc_pla30*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',27,tc_pla31*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',28,tc_pla32*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',29,tc_pla33*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',30,tc_pla34*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01",
                " union all select bmb01,bmb01_1,bmb03,'plan',31,tc_pla35*bmb06  from aimq200_tmp left join tc_pla_file on tc_pla01 = bmb01"
    prepare q200_plan_ins from g_sql
    execute q200_plan_ins
    if sqlca.sqlcode then
        call cl_err('q200_plan_ins',sqlca.sqlcode,1)
        return
    end if

    #6. 每日库存出
    let g_sql = "insert into aimq200_amt select bmb01, bmb01_1, bmb03,'out', tlf06, sum(nvl(tlf10, 0)) tlf10",
                " from (  select bmb01,bmb01_1,bmb03,bmb03 bmb03sub from aimq200_tmp",
                "         union all",
                "         select bmb01,bmb01_1,bmb03,bmd04 from aimq200_sub)",
                " left join (select tlf01, to_char(tlf06, 'dd') tlf06, sum(tlf10 * tlf907 * tlf12) tlf10",
                "             from tlf_file where tlf06 between ? and ? and tlf907 = -1",
                "             group by tlf01, to_char(tlf06, 'dd'))",
                "     on tlf01 = bmb03sub",
                " where tlf06 is not null group by bmb01, bmb01_1, bmb03, tlf06 "

    prepare q200_out_ins from g_sql
    execute q200_out_ins using bdate,edate
    if sqlca.sqlcode then
        call cl_err('q200_out_ins',sqlca.sqlcode,1)
        return
    end if

    #7 每日库存入
    let g_sql = "insert into aimq200_amt select bmb01, bmb01_1, bmb03,'in', tlf06, sum(nvl(tlf10, 0)) tlf10",
                " from (  select bmb01,bmb01_1,bmb03,bmb03 bmb03sub from aimq200_tmp",
                "         union all",
                "         select bmb01,bmb01_1,bmb03,bmd04 from aimq200_sub)",
                " left join (select tlf01, to_char(tlf06, 'dd') tlf06, sum(tlf10 * tlf907 * tlf12) tlf10",
                "             from tlf_file where tlf06 between ? and ? and tlf907 = 1",
                "             group by tlf01, to_char(tlf06, 'dd'))",
                "     on tlf01 = bmb03sub",
                " where tlf06 is not null group by bmb01, bmb01_1, bmb03, tlf06 "
    prepare q200_in_ins from g_sql
    execute q200_in_ins using bdate,edate
    if sqlca.sqlcode then
        call cl_err('q200_in_ins',sqlca.sqlcode,1)
        return
    end if

    # 8 结存数量
    
    # let g_sql = " insert into aimq200_amt select a.bmb01,b.bmb01_1,b.bmb03,'fin',b.seq,",
    #             " avnum + nvl(wip,0) + nvl(stock,0) - nvl(b.amt,0) + nvl(c.amt,0) - nvl(d.amt,0) from",
    #             " aimq200_tmp a",
    #             " left join aimq200_amt b on a.bmb01 = b.bmb01 and a.bmb01_1 = b.bmb01_1 and a.bmb03 = b.bmb03 and b.type='out' ", --out
    #             " left join aimq200_amt c on a.bmb01 = c.bmb01 and c.bmb01_1 = c.bmb01_1 and a.bmb03 = c.bmb03 and b.seq = c.seq and b.type='in' ", --in
    #             " left join aimq200_amt d on a.bmb01 = d.bmb01 and d.bmb01_1 = d.bmb01_1 and a.bmb03 = d.bmb03 and d.seq = c.seq and b.type='plan' " --plan 
    # prepare q200_fin_ins from g_sql
    # execute q200_fin_ins
    # if sqlca.sqlcode then
    #     call cl_err('q200_fin_ins',sqlca.sqlcode,1)
    #     return
    # end if

    insert into aimq200_amt
    select a.bmb01,a.bmb01_1,a.bmb03,'fin',d.seq, avnum+wip+stock-nvl(d.amt,0)+nvl(b.amt,0)-nvl(c.amt,0)
     from aimq200_tmp a
     left join aimq200_amt d
       on d.bmb01 = a.bmb01 and d.bmb01_1 = a.bmb01_1 and d.bmb03=a.bmb03 and d.type='plan'
     left join aimq200_amt b
       on b.bmb01 = a.bmb01 and b.bmb01_1 = a.bmb01_1 and b.bmb03=a.bmb03 and b.seq = d.seq and b.type='in'
     left join aimq200_amt c
       on c.bmb01 = a.bmb01 and c.bmb01_1 = a.bmb01_1 and c.bmb03=a.bmb03 and c.seq = d.seq and c.type ='out'
    where d.seq = 1

    if sqlca.sqlcode then
        call cl_err('aimq200_amt ins fin',sqlca.sqlcode,1)
        return
    end if 
    let g_sql = "insert into aimq200_amt",
                " select  a.bmb01,a.bmb01_1,a.bmb03,'fin',d.seq, nvl((",
                "     select e.amt from aimq200_amt e where e.bmb01 = a.bmb01 and e.bmb01_1 = a.bmb01_1 ",
                "        and e.bmb03 =a.bmb03 and e.type='fin' and e.seq =  d.seq - 1",
                " ),0)-nvl(d.amt,0)+nvl(b.amt,0)-nvl(c.amt,0)",
                "  from aimq200_tmp a",
                "  left join aimq200_amt d ",
                "    on d.bmb01 = a.bmb01 and d.bmb01_1 = a.bmb01_1 and d.bmb03=a.bmb03 and d.type='plan'",
                "  left join aimq200_amt b ",
                "    on b.bmb01 = a.bmb01 and b.bmb01_1 = a.bmb01_1 and b.bmb03=a.bmb03 and b.seq = d.seq and b.type='in'",
                "  left join aimq200_amt c",
                "    on c.bmb01 = a.bmb01 and c.bmb01_1 = a.bmb01_1 and c.bmb03=a.bmb03 and c.seq = d.seq and c.type ='out'",
                " where d.seq = ?"
    prepare q200_fin_ins from g_sql
    for l_i = 2 to 31
        execute q200_fin_ins using l_i
        if sqlca.sqlcode then
            call cl_err('aimq200_amt ins fin',sqlca.sqlcode,1)
            return
        end if
    end for

    let g_sql = " SELECT a.bmb01,a.bmb03,b.bmb03sub,a.bmb06,a.imk09,a.imk09_1,a.avnum,a.avset,a.wip,a.stock, ",
                " nvl((SELECT amt FROM aimq200_amt c11 WHERE c11.bmb01=a.bmb01 AND c11.bmb03 =a.bmb03 AND c11.type='out'  AND c11.seq = 1 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c12 WHERE c12.bmb01=a.bmb01 AND c12.bmb03 =a.bmb03 AND c12.type='in'   AND c12.seq = 1 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c13 WHERE c13.bmb01=a.bmb01 AND c13.bmb03 =a.bmb03 AND c13.type='plan' AND c13.seq = 1 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c14 WHERE c14.bmb01=a.bmb01 AND c14.bmb03 =a.bmb03 AND c14.type='fin'  AND c14.seq = 1 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c21 WHERE c21.bmb01=a.bmb01 AND c21.bmb03 =a.bmb03 AND c21.type='out'  AND c21.seq = 2 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c22 WHERE c22.bmb01=a.bmb01 AND c22.bmb03 =a.bmb03 AND c22.type='in'   AND c22.seq = 2 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c23 WHERE c23.bmb01=a.bmb01 AND c23.bmb03 =a.bmb03 AND c23.type='plan' AND c23.seq = 2 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c24 WHERE c24.bmb01=a.bmb01 AND c24.bmb03 =a.bmb03 AND c24.type='fin'  AND c24.seq = 2 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c31 WHERE c31.bmb01=a.bmb01 AND c31.bmb03 =a.bmb03 AND c31.type='out'  AND c31.seq = 3 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c32 WHERE c32.bmb01=a.bmb01 AND c32.bmb03 =a.bmb03 AND c32.type='in'   AND c32.seq = 3 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c33 WHERE c33.bmb01=a.bmb01 AND c33.bmb03 =a.bmb03 AND c33.type='plan' AND c33.seq = 3 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c34 WHERE c34.bmb01=a.bmb01 AND c34.bmb03 =a.bmb03 AND c34.type='fin'  AND c34.seq = 3 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c41 WHERE c41.bmb01=a.bmb01 AND c41.bmb03 =a.bmb03 AND c41.type='out'  AND c41.seq = 4 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c42 WHERE c42.bmb01=a.bmb01 AND c42.bmb03 =a.bmb03 AND c42.type='in'   AND c42.seq = 4 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c43 WHERE c43.bmb01=a.bmb01 AND c43.bmb03 =a.bmb03 AND c43.type='plan' AND c43.seq = 4 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c44 WHERE c44.bmb01=a.bmb01 AND c44.bmb03 =a.bmb03 AND c44.type='fin'  AND c44.seq = 4 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c51 WHERE c51.bmb01=a.bmb01 AND c51.bmb03 =a.bmb03 AND c51.type='out'  AND c51.seq = 5 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c52 WHERE c52.bmb01=a.bmb01 AND c52.bmb03 =a.bmb03 AND c52.type='in'   AND c52.seq = 5 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c53 WHERE c53.bmb01=a.bmb01 AND c53.bmb03 =a.bmb03 AND c53.type='plan' AND c53.seq = 5 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c54 WHERE c54.bmb01=a.bmb01 AND c54.bmb03 =a.bmb03 AND c54.type='fin'  AND c54.seq = 5 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c61 WHERE c61.bmb01=a.bmb01 AND c61.bmb03 =a.bmb03 AND c61.type='out'  AND c61.seq = 6 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c62 WHERE c62.bmb01=a.bmb01 AND c62.bmb03 =a.bmb03 AND c62.type='in'   AND c62.seq = 6 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c63 WHERE c63.bmb01=a.bmb01 AND c63.bmb03 =a.bmb03 AND c63.type='plan' AND c63.seq = 6 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c64 WHERE c64.bmb01=a.bmb01 AND c64.bmb03 =a.bmb03 AND c64.type='fin'  AND c64.seq = 6 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c71 WHERE c71.bmb01=a.bmb01 AND c71.bmb03 =a.bmb03 AND c71.type='out'  AND c71.seq = 7 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c72 WHERE c72.bmb01=a.bmb01 AND c72.bmb03 =a.bmb03 AND c72.type='in'   AND c72.seq = 7 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c73 WHERE c73.bmb01=a.bmb01 AND c73.bmb03 =a.bmb03 AND c73.type='plan' AND c73.seq = 7 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c74 WHERE c74.bmb01=a.bmb01 AND c74.bmb03 =a.bmb03 AND c74.type='fin'  AND c74.seq = 7 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c81 WHERE c81.bmb01=a.bmb01 AND c81.bmb03 =a.bmb03 AND c81.type='out'  AND c81.seq = 8 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c82 WHERE c82.bmb01=a.bmb01 AND c82.bmb03 =a.bmb03 AND c82.type='in'   AND c82.seq = 8 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c83 WHERE c83.bmb01=a.bmb01 AND c83.bmb03 =a.bmb03 AND c83.type='plan' AND c83.seq = 8 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c84 WHERE c84.bmb01=a.bmb01 AND c84.bmb03 =a.bmb03 AND c84.type='fin'  AND c84.seq = 8 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c91 WHERE c91.bmb01=a.bmb01 AND c91.bmb03 =a.bmb03 AND c91.type='out'  AND c91.seq = 9 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c92 WHERE c92.bmb01=a.bmb01 AND c92.bmb03 =a.bmb03 AND c92.type='in'   AND c92.seq = 9 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c93 WHERE c93.bmb01=a.bmb01 AND c93.bmb03 =a.bmb03 AND c93.type='plan' AND c93.seq = 9 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c94 WHERE c94.bmb01=a.bmb01 AND c94.bmb03 =a.bmb03 AND c94.type='fin'  AND c94.seq = 9 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c101 WHERE c101.bmb01=a.bmb01 AND c101.bmb03 =a.bmb03 AND c101.type='out'  AND c101.seq = 10 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c102 WHERE c102.bmb01=a.bmb01 AND c102.bmb03 =a.bmb03 AND c102.type='in'   AND c102.seq = 10 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c103 WHERE c103.bmb01=a.bmb01 AND c103.bmb03 =a.bmb03 AND c103.type='plan' AND c103.seq = 10 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c104 WHERE c104.bmb01=a.bmb01 AND c104.bmb03 =a.bmb03 AND c104.type='fin'  AND c104.seq = 10 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c111 WHERE c111.bmb01=a.bmb01 AND c111.bmb03 =a.bmb03 AND c111.type='out'  AND c111.seq = 11 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c112 WHERE c112.bmb01=a.bmb01 AND c112.bmb03 =a.bmb03 AND c112.type='in'   AND c112.seq = 11 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c113 WHERE c113.bmb01=a.bmb01 AND c113.bmb03 =a.bmb03 AND c113.type='plan' AND c113.seq = 11 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c114 WHERE c114.bmb01=a.bmb01 AND c114.bmb03 =a.bmb03 AND c114.type='fin'  AND c114.seq = 11 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c121 WHERE c121.bmb01=a.bmb01 AND c121.bmb03 =a.bmb03 AND c121.type='out'  AND c121.seq = 12 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c122 WHERE c122.bmb01=a.bmb01 AND c122.bmb03 =a.bmb03 AND c122.type='in'   AND c122.seq = 12 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c123 WHERE c123.bmb01=a.bmb01 AND c123.bmb03 =a.bmb03 AND c123.type='plan' AND c123.seq = 12 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c124 WHERE c124.bmb01=a.bmb01 AND c124.bmb03 =a.bmb03 AND c124.type='fin'  AND c124.seq = 12 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c131 WHERE c131.bmb01=a.bmb01 AND c131.bmb03 =a.bmb03 AND c131.type='out'  AND c131.seq = 13 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c132 WHERE c132.bmb01=a.bmb01 AND c132.bmb03 =a.bmb03 AND c132.type='in'   AND c132.seq = 13 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c133 WHERE c133.bmb01=a.bmb01 AND c133.bmb03 =a.bmb03 AND c133.type='plan' AND c133.seq = 13 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c134 WHERE c134.bmb01=a.bmb01 AND c134.bmb03 =a.bmb03 AND c134.type='fin'  AND c134.seq = 13 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c141 WHERE c141.bmb01=a.bmb01 AND c141.bmb03 =a.bmb03 AND c141.type='out'  AND c141.seq = 14 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c142 WHERE c142.bmb01=a.bmb01 AND c142.bmb03 =a.bmb03 AND c142.type='in'   AND c142.seq = 14 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c143 WHERE c143.bmb01=a.bmb01 AND c143.bmb03 =a.bmb03 AND c143.type='plan' AND c143.seq = 14 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c144 WHERE c144.bmb01=a.bmb01 AND c144.bmb03 =a.bmb03 AND c144.type='fin'  AND c144.seq = 14 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c151 WHERE c151.bmb01=a.bmb01 AND c151.bmb03 =a.bmb03 AND c151.type='out'  AND c151.seq = 15 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c152 WHERE c152.bmb01=a.bmb01 AND c152.bmb03 =a.bmb03 AND c152.type='in'   AND c152.seq = 15 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c153 WHERE c153.bmb01=a.bmb01 AND c153.bmb03 =a.bmb03 AND c153.type='plan' AND c153.seq = 15 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c154 WHERE c154.bmb01=a.bmb01 AND c154.bmb03 =a.bmb03 AND c154.type='fin'  AND c154.seq = 15 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c161 WHERE c161.bmb01=a.bmb01 AND c161.bmb03 =a.bmb03 AND c161.type='out'  AND c161.seq = 16 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c162 WHERE c162.bmb01=a.bmb01 AND c162.bmb03 =a.bmb03 AND c162.type='in'   AND c162.seq = 16 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c163 WHERE c163.bmb01=a.bmb01 AND c163.bmb03 =a.bmb03 AND c163.type='plan' AND c163.seq = 16 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c164 WHERE c164.bmb01=a.bmb01 AND c164.bmb03 =a.bmb03 AND c164.type='fin'  AND c164.seq = 16 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c171 WHERE c171.bmb01=a.bmb01 AND c171.bmb03 =a.bmb03 AND c171.type='out'  AND c171.seq = 17 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c172 WHERE c172.bmb01=a.bmb01 AND c172.bmb03 =a.bmb03 AND c172.type='in'   AND c172.seq = 17 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c173 WHERE c173.bmb01=a.bmb01 AND c173.bmb03 =a.bmb03 AND c173.type='plan' AND c173.seq = 17 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c174 WHERE c174.bmb01=a.bmb01 AND c174.bmb03 =a.bmb03 AND c174.type='fin'  AND c174.seq = 17 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c181 WHERE c181.bmb01=a.bmb01 AND c181.bmb03 =a.bmb03 AND c181.type='out'  AND c181.seq = 18 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c182 WHERE c182.bmb01=a.bmb01 AND c182.bmb03 =a.bmb03 AND c182.type='in'   AND c182.seq = 18 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c183 WHERE c183.bmb01=a.bmb01 AND c183.bmb03 =a.bmb03 AND c183.type='plan' AND c183.seq = 18 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c184 WHERE c184.bmb01=a.bmb01 AND c184.bmb03 =a.bmb03 AND c184.type='fin'  AND c184.seq = 18 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c191 WHERE c191.bmb01=a.bmb01 AND c191.bmb03 =a.bmb03 AND c191.type='out'  AND c191.seq = 19 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c192 WHERE c192.bmb01=a.bmb01 AND c192.bmb03 =a.bmb03 AND c192.type='in'   AND c192.seq = 19 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c193 WHERE c193.bmb01=a.bmb01 AND c193.bmb03 =a.bmb03 AND c193.type='plan' AND c193.seq = 19 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c194 WHERE c194.bmb01=a.bmb01 AND c194.bmb03 =a.bmb03 AND c194.type='fin'  AND c194.seq = 19 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c201 WHERE c201.bmb01=a.bmb01 AND c201.bmb03 =a.bmb03 AND c201.type='out'  AND c201.seq = 20 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c202 WHERE c202.bmb01=a.bmb01 AND c202.bmb03 =a.bmb03 AND c202.type='in'   AND c202.seq = 20 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c203 WHERE c203.bmb01=a.bmb01 AND c203.bmb03 =a.bmb03 AND c203.type='plan' AND c203.seq = 20 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c204 WHERE c204.bmb01=a.bmb01 AND c204.bmb03 =a.bmb03 AND c204.type='fin'  AND c204.seq = 20 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c211 WHERE c211.bmb01=a.bmb01 AND c211.bmb03 =a.bmb03 AND c211.type='out'  AND c211.seq = 21 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c212 WHERE c212.bmb01=a.bmb01 AND c212.bmb03 =a.bmb03 AND c212.type='in'   AND c212.seq = 21 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c213 WHERE c213.bmb01=a.bmb01 AND c213.bmb03 =a.bmb03 AND c213.type='plan' AND c213.seq = 21 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c214 WHERE c214.bmb01=a.bmb01 AND c214.bmb03 =a.bmb03 AND c214.type='fin'  AND c214.seq = 21 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c221 WHERE c221.bmb01=a.bmb01 AND c221.bmb03 =a.bmb03 AND c221.type='out'  AND c221.seq = 22 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c222 WHERE c222.bmb01=a.bmb01 AND c222.bmb03 =a.bmb03 AND c222.type='in'   AND c222.seq = 22 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c223 WHERE c223.bmb01=a.bmb01 AND c223.bmb03 =a.bmb03 AND c223.type='plan' AND c223.seq = 22 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c224 WHERE c224.bmb01=a.bmb01 AND c224.bmb03 =a.bmb03 AND c224.type='fin'  AND c224.seq = 22 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c231 WHERE c231.bmb01=a.bmb01 AND c231.bmb03 =a.bmb03 AND c231.type='out'  AND c231.seq = 23 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c232 WHERE c232.bmb01=a.bmb01 AND c232.bmb03 =a.bmb03 AND c232.type='in'   AND c232.seq = 23 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c233 WHERE c233.bmb01=a.bmb01 AND c233.bmb03 =a.bmb03 AND c233.type='plan' AND c233.seq = 23 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c234 WHERE c234.bmb01=a.bmb01 AND c234.bmb03 =a.bmb03 AND c234.type='fin'  AND c234.seq = 23 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c241 WHERE c241.bmb01=a.bmb01 AND c241.bmb03 =a.bmb03 AND c241.type='out'  AND c241.seq = 24 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c242 WHERE c242.bmb01=a.bmb01 AND c242.bmb03 =a.bmb03 AND c242.type='in'   AND c242.seq = 24 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c243 WHERE c243.bmb01=a.bmb01 AND c243.bmb03 =a.bmb03 AND c243.type='plan' AND c243.seq = 24 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c244 WHERE c244.bmb01=a.bmb01 AND c244.bmb03 =a.bmb03 AND c244.type='fin'  AND c244.seq = 24 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c251 WHERE c251.bmb01=a.bmb01 AND c251.bmb03 =a.bmb03 AND c251.type='out'  AND c251.seq = 25 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c252 WHERE c252.bmb01=a.bmb01 AND c252.bmb03 =a.bmb03 AND c252.type='in'   AND c252.seq = 25 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c253 WHERE c253.bmb01=a.bmb01 AND c253.bmb03 =a.bmb03 AND c253.type='plan' AND c253.seq = 25 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c254 WHERE c254.bmb01=a.bmb01 AND c254.bmb03 =a.bmb03 AND c254.type='fin'  AND c254.seq = 25 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c261 WHERE c261.bmb01=a.bmb01 AND c261.bmb03 =a.bmb03 AND c261.type='out'  AND c261.seq = 26 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c262 WHERE c262.bmb01=a.bmb01 AND c262.bmb03 =a.bmb03 AND c262.type='in'   AND c262.seq = 26 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c263 WHERE c263.bmb01=a.bmb01 AND c263.bmb03 =a.bmb03 AND c263.type='plan' AND c263.seq = 26 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c264 WHERE c264.bmb01=a.bmb01 AND c264.bmb03 =a.bmb03 AND c264.type='fin'  AND c264.seq = 26 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c271 WHERE c271.bmb01=a.bmb01 AND c271.bmb03 =a.bmb03 AND c271.type='out'  AND c271.seq = 27 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c272 WHERE c272.bmb01=a.bmb01 AND c272.bmb03 =a.bmb03 AND c272.type='in'   AND c272.seq = 27 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c273 WHERE c273.bmb01=a.bmb01 AND c273.bmb03 =a.bmb03 AND c273.type='plan' AND c273.seq = 27 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c274 WHERE c274.bmb01=a.bmb01 AND c274.bmb03 =a.bmb03 AND c274.type='fin'  AND c274.seq = 27 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c281 WHERE c281.bmb01=a.bmb01 AND c281.bmb03 =a.bmb03 AND c281.type='out'  AND c281.seq = 28 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c282 WHERE c282.bmb01=a.bmb01 AND c282.bmb03 =a.bmb03 AND c282.type='in'   AND c282.seq = 28 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c283 WHERE c283.bmb01=a.bmb01 AND c283.bmb03 =a.bmb03 AND c283.type='plan' AND c283.seq = 28 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c284 WHERE c284.bmb01=a.bmb01 AND c284.bmb03 =a.bmb03 AND c284.type='fin'  AND c284.seq = 28 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c291 WHERE c291.bmb01=a.bmb01 AND c291.bmb03 =a.bmb03 AND c291.type='out'  AND c291.seq = 29 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c292 WHERE c292.bmb01=a.bmb01 AND c292.bmb03 =a.bmb03 AND c292.type='in'   AND c292.seq = 29 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c293 WHERE c293.bmb01=a.bmb01 AND c293.bmb03 =a.bmb03 AND c293.type='plan' AND c293.seq = 29 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c294 WHERE c294.bmb01=a.bmb01 AND c294.bmb03 =a.bmb03 AND c294.type='fin'  AND c294.seq = 29 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c301 WHERE c301.bmb01=a.bmb01 AND c301.bmb03 =a.bmb03 AND c301.type='out'  AND c301.seq = 30 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c302 WHERE c302.bmb01=a.bmb01 AND c302.bmb03 =a.bmb03 AND c302.type='in'   AND c302.seq = 30 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c303 WHERE c303.bmb01=a.bmb01 AND c303.bmb03 =a.bmb03 AND c303.type='plan' AND c303.seq = 30 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c304 WHERE c304.bmb01=a.bmb01 AND c304.bmb03 =a.bmb03 AND c304.type='fin'  AND c304.seq = 30 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c311 WHERE c311.bmb01=a.bmb01 AND c311.bmb03 =a.bmb03 AND c311.type='out'  AND c311.seq = 31 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c312 WHERE c312.bmb01=a.bmb01 AND c312.bmb03 =a.bmb03 AND c312.type='in'   AND c312.seq = 31 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c313 WHERE c313.bmb01=a.bmb01 AND c313.bmb03 =a.bmb03 AND c313.type='plan' AND c313.seq = 31 ),0), ",
                " nvl((SELECT amt FROM aimq200_amt c314 WHERE c314.bmb01=a.bmb01 AND c314.bmb03 =a.bmb03 AND c314.type='fin'  AND c314.seq = 31 ),0) ",
                " FROM aimq200_tmp a  ",
                " LEFT JOIN (select bmb01,bmb03,listagg(bmd04,',')within group(order by bmb01,bmb03) bmb03sub ",
                " from aimq200_sub GROUP BY bmb01,bmb03) b ON b.bmb01 = b.bmb01 AND a.bmb03 = b.bmb03 where 1=1 "
    if tm.only = '2' then
        let g_sql = g_sql,"and (a.bmb01,a.bmb03) in (select bmb01,bmb03 from aimq200_amt ",
                    "    where (bmb01,bmb01_1,seq) in(",
                    "        select bmb01,bmb01_1,min(seq) from aimq200_amt ",
                    "         where type='fin' and amt <0 group by bmb01,bmb01_1)",
                    "    and type='fin' and amt < 0)"
    end if
    if tm.only = '3' then
        let g_sql = g_sql,"and (a.bmb01,a.bmb03) in (select bmb01,bmb03 from aimq200_tmp",
                    " where (bmb01,avset) in ( select bmb01,min(avset) from aimq200_tmp",
                    "                         group by bmb01))"
    end if

    let g_sql = g_sql," order by a.bmb01,a.bmb03"

    prepare q200_b_fill_bp from g_sql
    declare q200_b_fill_curs cursor for q200_b_fill_bp
    if sqlca.sqlcode then
        call cl_err('q200_b_fill_curs',sqlca.sqlcode,1)
        return
    end if

    let g_cnt = 1
    call g_imk.clear()
    call g_imk_color.clear()
    foreach q200_b_fill_curs into g_imk[g_cnt].*
        if sqlca.sqlcode then
            call cl_err('q200_b_fill_curs',sqlca.sqlcode,1)
            exit foreach
        end if
        call q200_set_color(g_cnt)
        let g_cnt = g_cnt + 1
    end foreach
    call g_imk.deleteElement(g_cnt)
    # call g_imk_color.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1
    display g_cnt to cnt
end function

# 建立临时表表
function q200_crt_temp()
    drop table aimq200_tmp
    drop table aimq200_amt
    drop table aimq200_sub
    create temp table aimq200_tmp(
        bmb01       varchar(20),
        bmb01_1     varchar(20),  #上阶料，方便抓取替代料
        bmb03       varchar(20),
        bmb06       decimal(16,8),
        imk09       decimal(15,3),
        imk09_1     decimal(15,3),
        avnum       decimal(15,3),
        avset       decimal(15,3),
        wip         decimal(15,3),
        stock       decimal(15,3)
    )
    create temp table aimq200_amt(
        bmb01       varchar(20),
        bmb01_1     varchar(20),
        bmb03       varchar(20),
        type        varchar(10), #out出库 in 入库 plan计划量 fin 剩余量
        seq         decimal(5),
        amt         decimal(15,3)
    )
    create temp table aimq200_sub(
        bmb01       varchar(20),
        bmb01_1     varchar(20),
        bmb03       varchar(20),
        bmd04       varchar(20)
    )
end function

# 显示单身
function q200_bp(p_up)
    define p_up     like type_file.chr1

    if p_up !='G' then
        return
    end if

    let g_action_choice = ' '

    call cl_set_act_visible('accept,cancel',false)

    display array g_imk to s_imk.* attribute(count = g_rec_b,unbuffered)

        before display
            call DIALOG.setCellAttributes(g_imk_color)
            # call cl_navigator_setting(g_curs_index,g_row_count)
            call cl_show_fld_cont()
        
        on action query
            let g_action_choice = 'query'
            exit display
        
        on action help
            let g_action_choice = 'help'
            exit display
        
        on action exit
            let g_action_choice = 'exit'
            exit display
        
        on action controlg
            let g_action_choice = 'controlg'
            exit display
        
        on action accept
            exit display
        
        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit display
        
        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display
        
        on IDLE g_idle_seconds
            call cl_on_idle()
            continue display
        
        after display
            continue display
        
        on action controls
            call cl_set_head_visible('','AUTO')

    end display
    call cl_set_act_visible('accept,cancel',true)
end function

# 查询字段设置
function q200_comb_set()
    define l_yy     integer
    define l_str    string
    call cl_set_combo_items('mm','1,2,3,4,5,6,7,8,9,10,11,12','1,2,3,4,5,6,7,8,9,10,11,12')
    
    let l_yy = YEAR(g_today)
    let l_str = (l_yy-2) using '&&&&',',',(l_yy-1) using '&&&&',',',l_yy using '&&&&',',',(l_yy+1) using '&&&&'
    call cl_set_combo_items('yy',l_str,l_str)

    call cl_set_comp_entry('mm',true)
end function

#显示字段设置
function q200_comb_visiable(l_yy,l_mm)
    define l_mm,l_yy     integer

    call cl_set_comp_visible(
        'out29,out30,out31,in29,in30,in31,plan29,plan30,plan31,fin29,fin30,fin31',
        true
    )
    if l_mm = 2 then
        if l_yy mod 4 = 0 then
            #29
            call cl_set_comp_visible(
                'out30,out31,in30,in31,plan30,plan31,in30,in31,fin30,fin31',
                false
                )
            return
        end if
        call cl_set_comp_visible(
            'out29,out30,out31,in29,in30,in31,plan29,plan30,plan31,fin29,fin30,fin31',
            false
        )
        return
    end if
    if l_mm = 4 or l_mm = 6 or l_mm = 9 or l_mm = 11 then
        call cl_set_comp_visible('out31,in31,plan31,fin31',false)
        return
    end if
end function

function q200_set_color(p_i)
    define p_i      integer
    let g_imk_color[p_i].fin01 = ''
    if g_imk[p_i].fin01 < 0 then let g_imk_color[p_i].fin01 = 'red' end if
    if g_imk[p_i].fin02 < 0 then let g_imk_color[p_i].fin02 = 'red' end if
    if g_imk[p_i].fin03 < 0 then let g_imk_color[p_i].fin03 = 'red' end if
    if g_imk[p_i].fin04 < 0 then let g_imk_color[p_i].fin04 = 'red' end if
    if g_imk[p_i].fin05 < 0 then let g_imk_color[p_i].fin05 = 'red' end if
    if g_imk[p_i].fin06 < 0 then let g_imk_color[p_i].fin06 = 'red' end if
    if g_imk[p_i].fin07 < 0 then let g_imk_color[p_i].fin07 = 'red' end if
    if g_imk[p_i].fin08 < 0 then let g_imk_color[p_i].fin08 = 'red' end if
    if g_imk[p_i].fin09 < 0 then let g_imk_color[p_i].fin09 = 'red' end if
    if g_imk[p_i].fin10 < 0 then let g_imk_color[p_i].fin10 = 'red' end if
    if g_imk[p_i].fin11 < 0 then let g_imk_color[p_i].fin11 = 'red' end if
    if g_imk[p_i].fin12 < 0 then let g_imk_color[p_i].fin12 = 'red' end if
    if g_imk[p_i].fin13 < 0 then let g_imk_color[p_i].fin13 = 'red' end if
    if g_imk[p_i].fin14 < 0 then let g_imk_color[p_i].fin14 = 'red' end if
    if g_imk[p_i].fin15 < 0 then let g_imk_color[p_i].fin15 = 'red' end if
    if g_imk[p_i].fin16 < 0 then let g_imk_color[p_i].fin16 = 'red' end if
    if g_imk[p_i].fin17 < 0 then let g_imk_color[p_i].fin17 = 'red' end if
    if g_imk[p_i].fin18 < 0 then let g_imk_color[p_i].fin18 = 'red' end if
    if g_imk[p_i].fin19 < 0 then let g_imk_color[p_i].fin19 = 'red' end if
    if g_imk[p_i].fin20 < 0 then let g_imk_color[p_i].fin20 = 'red' end if
    if g_imk[p_i].fin21 < 0 then let g_imk_color[p_i].fin21 = 'red' end if
    if g_imk[p_i].fin22 < 0 then let g_imk_color[p_i].fin22 = 'red' end if
    if g_imk[p_i].fin23 < 0 then let g_imk_color[p_i].fin23 = 'red' end if
    if g_imk[p_i].fin24 < 0 then let g_imk_color[p_i].fin24 = 'red' end if
    if g_imk[p_i].fin25 < 0 then let g_imk_color[p_i].fin25 = 'red' end if
    if g_imk[p_i].fin26 < 0 then let g_imk_color[p_i].fin26 = 'red' end if
    if g_imk[p_i].fin27 < 0 then let g_imk_color[p_i].fin27 = 'red' end if
    if g_imk[p_i].fin28 < 0 then let g_imk_color[p_i].fin28 = 'red' end if
    if g_imk[p_i].fin29 < 0 then let g_imk_color[p_i].fin29 = 'red' end if
    if g_imk[p_i].fin30 < 0 then let g_imk_color[p_i].fin30 = 'red' end if
    if g_imk[p_i].fin31 < 0 then let g_imk_color[p_i].fin31 = 'red' end if
end function

function q200_excel_out()
    define list dynamic array of record
           node om.DomNode,
           name string
    end record

    call list.clear()
    let list[1].node = base.typeinfo.create(g_imk)
    let list[1].name = "s_imk"
    call cl_export_to_excel_by_go(list)
end function
