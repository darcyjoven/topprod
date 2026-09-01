# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cimq500.4gl
# Descriptions...: 每日进销存产值、达交查询报表
# Date & Author..: darcy 2026-07-26

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
globals "../4gl/cimq500.global"

define  g_total         dynamic array of total
define  g_day           dynamic array of daily
define  g_subtotal      dynamic array of subtotal
define  g_product       dynamic array of product
define  g_rework        dynamic array of rework
define  g_sale          dynamic array of sale
define  g_unsign        dynamic array of unsign

define  g_total_display         dynamic array of total_display
define  g_day_display           dynamic array of daily_display
define  g_subtotal_display      dynamic array of subtotal_display
define  g_product_display       dynamic array of product_display
define  g_rework_display        dynamic array of rework_display
define  g_sale_display          dynamic array of sale_display
define  g_unsign_display        dynamic array of unsign_display

define  g_sql,g_msg                                             string
define  g_no_ask        boolean
define  l_ac,g_cnt,g_rec_b,g_row_count,g_curs_index,g_jump,
        g_rec_total,g_rec_day,g_rec_subtotal,g_rec_product,
        g_rec_rework,g_rec_sale,g_rec_unsign      integer

define  tm  record
    tc_ila01    like tc_ila_file.tc_ila01,
    tc_ila02    like tc_ila_file.tc_ila02,
    only_today  varchar(1)
end record

define  g_tc_ila01      like tc_ila_file.tc_ila01,
        g_tc_ila02      like tc_ila_file.tc_ila02,
        g_only_today    varchar(1)

define  g_sum_all,g_sum_smt,g_sum_fpc,g_sum_comp,g_sum_other,g_sum_discount     decimal(15,3)

main
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

    call cl_used(g_prog,g_time,1) returning g_time

    open window cimq500_w at 1,1 with form "cim/42f/cimq500"
            attribute (style = g_win_style clipped)
    call cl_ui_init()

    initialize tm.* to null
    let tm.tc_ila01 = arg_val(1)
    let tm.tc_ila02 = arg_val(2)
    let tm.only_today = arg_val(3)

    call cimq500_q()

    call cimq500_menu()

    call cl_used(g_prog,g_time,2) returning g_time
    close window cimq500_w
end main

function cimq500_menu()

    while true
        call cimq500_bp()
        case g_action_choice
            when 'query'
                if cl_chk_act_auth() then
                    call cimq500_q()
                end if
            when 'exceltoexcel'
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel10(
                        's_total',base.typeinfo.create(g_total),
                        's_day',base.typeinfo.create(g_day),
                        's_subtotal',base.typeinfo.create(g_subtotal),
                        's_product',base.typeinfo.create(g_product),
                        's_rework',base.typeinfo.create(g_rework),
                        's_sale',base.typeinfo.create(g_sale),
                        '',null,'',null,'',null,'',null))
                end if
            when 'help'
                call cl_show_help()
            when 'exit'
                exit while
            when 'controlg'
                call cl_cmdask()
            when 'output'
                if cl_chk_act_auth() then
                    call cimq500_output()
                end if
        end case
    end while
end function

function cimq500_ask()

    let tm.tc_ila01 = g_today - 1
    let tm.tc_ila02 = 'normal'
    let tm.only_today = 'Y'

    input tm.tc_ila01,tm.tc_ila02,tm.only_today without defaults from dat,version,only_today

        before input

        on action controlr
            call cl_show_req_fields()

        on action controlf
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input

end function



function cimq500_q()

    call g_total.clear()
    call g_day.clear()
    call g_subtotal.clear()
    call g_product.clear()
    call g_rework.clear()
    call g_sale.clear()
    call g_unsign.clear()

    call g_total_display.clear()
    call g_day_display.clear()
    call g_subtotal_display.clear()
    call g_product_display.clear()
    call g_rework_display.clear()
    call g_sale_display.clear()
    call g_unsign_display.clear()

    message '查询中……'
    if cl_null(tm.tc_ila01) and cl_null(tm.tc_ila02) then
        call cimq500_ask()
        if int_flag then
            let int_flag = true
            message '取消查询'
            return
        end if
    end if

    let g_sql = "select tc_ila01,tc_ila02 from tc_ila_file where 1=1 "
    if not cl_null(tm.tc_ila01) then
        let g_sql = g_sql," and tc_ila01 = '",tm.tc_ila01,"' "
    end if
    if not cl_null(tm.tc_ila02) then
        let g_sql = g_sql," and tc_ila02 = '",tm.tc_ila02,"' "
    end if
    let g_sql = g_sql," order by tc_ila01,tc_ila02"

    prepare cimq500_p1 from g_sql
    declare cimq500_curs scroll cursor for cimq500_p1

    let g_sql = "select count(*) from (",g_sql,")"
    prepare cimq500_precount from g_sql
    declare cimq500_count cursor for cimq500_precount

    open cimq500_count
    fetch cimq500_count into g_row_count
    display g_row_count to cn2

    let g_only_today = tm.only_today
    initialize tm.* to null

    open cimq500_curs
    if sqlca.sqlcode then
        call cl_err(tm.tc_ila01,sqlca.sqlcode,0)
        initialize tm.* to null
    else
        call cimq500_fetch('F')
    end if
end function

function cimq500_fetch(p_flag)
    define  p_flag  varchar(1)

    if p_flag = '/' and not g_no_ask then
        call cl_getmsg('fetch',g_lang) returning g_msg
        let int_flag = false

        prompt g_msg clipped,': ' for g_jump
            on idle g_idle_seconds
                call cl_on_idle()

            on action about
                call cl_about()

            on action help
                call cl_show_help()

            on action controlg
                call cl_cmdask()

        end prompt
        if int_flag then
            let int_flag = 0
            let g_jump = g_curs_index
            return
        end if
    end if

    case p_flag
        when 'N' fetch next     cimq500_curs into g_tc_ila01,g_tc_ila02
        when 'P' fetch previous cimq500_curs into g_tc_ila01,g_tc_ila02
        when 'F' fetch first    cimq500_curs into g_tc_ila01,g_tc_ila02
        when 'L' fetch last     cimq500_curs into g_tc_ila01,g_tc_ila02
        when '/' fetch absolute g_jump cimq500_curs into g_tc_ila01,g_tc_ila02
    end case
    if sqlca.sqlcode then
        call cl_err(g_tc_ila01,sqlca.sqlcode,0)
        let g_tc_ila01 = null
        let g_tc_ila02 = null
        return
    else
       case p_flag
          when 'F' let g_curs_index = 1
          when 'P' let g_curs_index = g_curs_index - 1
          when 'N' let g_curs_index = g_curs_index + 1
          when 'L' let g_curs_index = g_row_count
          when '/' let g_curs_index = g_jump
       end case
       call cl_navigator_setting(g_curs_index, g_row_count)
    end if

    call cimq500_show()

end function

function cimq500_show()
    display g_tc_ila01,g_tc_ila02,g_only_today to dat,version,only_today
    call cimq500_b_fill()
end function

function cimq500_b_fill()
    define  i       integer
    define  l_yy,l_mm   integer
    call scimq500(g_tc_ila01,g_tc_ila02,g_only_today)

    -- 总览
    let g_sql = "select seq01,col01,col02,col03,col04 from cimq500_total",
                " order by seq01"
    prepare cimq500_pretotal from g_sql
    declare cimq500_total_cur cursor for cimq500_pretotal

    let i = 1
    foreach cimq500_total_cur into g_total[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_total_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_total.deleteElement(i)
    let g_rec_total = i - 1

    -- 日汇总
    let g_sql = "select seq02,col05,col06,col07,col08,
                        col09,col10,col11,col12,col13,
                        col14,col15,col16,col17,col18,
                        col19,col20,col21,col22,col23,
                        col24,col25,col26,col27,col28,
                        col29,col30,col31,col32,col33,
                        col34,col35,col36,col37",
                "  from cimq500_day order by seq02"
    prepare cimq500_preday from g_sql
    declare cimq500_day_cur cursor for cimq500_preday
    let i = 1
    foreach cimq500_day_cur into g_day[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_day_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_day.deleteElement(i)
    let g_rec_day = i - 1

    -- 分类汇总
    let g_sql = "select seq03,dat01,col38,col39,col40,
                        col41,col42,col43,col44,col45,
                        col46,col47,col48,col49,col50,
                        col51,col52,col53,col54,col55,
                        col56,col57,col58,col59,col60,
                        col61,col62,col63,col64,col65,
                        col66,col67,col68,col69,col70,
                        col71,col72,col73,col74",
                "  from cimq500_subtotal order by seq03"
    prepare cimq500_presubtotal from g_sql
    declare cimq500_subtotal_cur cursor for cimq500_presubtotal

    let i = 1
    foreach cimq500_subtotal_cur into g_subtotal[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_subtotal_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_subtotal.deleteElement(i)
    let g_rec_subtotal = i - 1

    -- 入库
    let g_sql = "select dat02,dat03,typ01,item01,ima02,
                        ima021,doc01,doc02,seq04,loc01,
                        bin01,lot01,qty01,doc03,seq05,
                        cey01,price01,fpc01,smt01,comp01,
                        rate01,price02,fpc02,smt02,comp02,
                        amt01",
                "  from cimq500_product order by dat02,doc01,doc02,seq04"
    prepare cimq500_preproduct from g_sql
    declare cimq500_product_cur cursor for cimq500_preproduct

    let i = 1
    foreach cimq500_product_cur into g_product[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_product_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_product.deleteElement(i)
    let g_rec_product = i - 1

    -- 返工领出
    let g_sql = "select seq06,dat04,item02,ima0201,ima02102,
                        loc02,qty02,price03,amt02,reason ",
                "  from cimq500_rework order by seq06"
    prepare cimq500_prerework from g_sql
    declare cimq500_rework_cur cursor for cimq500_prerework

    let i = 1
    foreach cimq500_rework_cur into g_rework[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_rework_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_rework.deleteElement(i)
    let g_rec_rework = i - 1

    -- 出货
    let g_sql = "select dat05,dat06,typ02,item03,ima0202,
                        ima02102,doc04,seq07,loc03,bin03,
                        lot03,qty03,doc05,seq08,cey02,
                        price04,fpc03,smt03,comp03,rate02,
                        price05,fpc04,smt04,comp04,amt03",
                "  from cimq500_sale order by dat05,item03,doc04,seq07"
    prepare cimq500_presale from g_sql
    declare cimq500_sale_cur cursor for cimq500_presale

    let i = 1
    foreach cimq500_sale_cur into g_sale[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_sale_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_sale.deleteElement(i)
    let g_rec_sale = i - 1

    -- 未签收
    let g_sql = "select yy,mm,dat,item,ima02,
                        ima021,doc,seq,loc,bin,
                        lot,qty,cey,price_source,rate_old,
                        price_old,rate_new,price_new,fpc,smt,
                        comp,amt
                   from cimq500_unsign
                  where yy = ? and mm = ?"
    prepare cimq500_preunsign from g_sql
    declare cimq500_unsign_cur cursor for cimq500_preunsign

    # 上月
    if month(g_tc_ila01) = 1 then
        let l_yy = year(g_tc_ila01) - 1
        let l_mm = 12
    else
        let l_yy = year(g_tc_ila01)
        let l_mm = month(g_tc_ila01) - 1
    end if
    let i = 1
    foreach cimq500_unsign_cur using l_yy,l_mm into g_unsign[i].*
        if sqlca.sqlcode then
            call cl_err('cimq500_unsign_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_unsign.deleteElement(i)
    let g_rec_unsign = i - 1
end function

function cimq500_bp()
    call cl_set_act_visible("accept,cancel", false)
    dialog
        display array g_total to s_total.* attribute(count=g_rec_total)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_day to s_day.* attribute(count=g_rec_day)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_subtotal to s_subtotal.* attribute(count=g_rec_subtotal)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_product to s_product.* attribute(count=g_rec_product)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_rework to s_rework.* attribute(count=g_rec_rework)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_sale to s_sale.* attribute(count=g_rec_sale)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_unsign to s_unsign.* attribute(count=g_rec_unsign)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display

        on action query
            let g_action_choice = 'query'
            exit dialog

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = 'exit'
            exit dialog

        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit dialog

        on action controlg
            call cl_cmdask()
        on action output
            let g_action_choice = 'output'
            exit dialog

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue dialog

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end dialog

    call cl_set_act_visible("accept,cancel", true)
end function


-- 这里只进行浏览器下载部分，文件生成交给scimq500 处理
function cimq500_output()
    if scimq500_output(g_tc_ila01,g_tc_ila02) then
        message 'OK'
    end if
end function
