# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cimq500.4gl
# Descriptions...: 每日进销存产值、达交查询报表
# Date & Author..: darcy 2026-07-26

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
globals "../4gl/cimq500.global"

define  g_curr      integer

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
            when 'exporttoexcel'
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel10(
                        's_total',base.typeinfo.create(g_total),
                        's_day',base.typeinfo.create(g_daily),
                        's_subtotal',base.typeinfo.create(g_subtotal),
                        's_product',base.typeinfo.create(g_product),
                        's_rework',base.typeinfo.create(g_rework),
                        's_sale',base.typeinfo.create(g_sale),
                        's_unsign',base.typeinfo.create(g_unsign),
                        '',null,'',null,'',null))
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
    call g_daily.clear()
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

    let g_curs_index = 0
    let g_row_count = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

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
    call scimq500_b_fill()
   
end function

 
function cimq500_bp()
         
    call cl_set_act_visible("accept,cancel", false)
    dialog ATTRIBUTES (UNBUFFERED)
        display array g_total to s_total.* attribute(count=g_rec_total)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_daily to s_day.* attribute(count=g_rec_day)
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

        before dialog
            call cl_navigator_setting(g_curs_index, g_row_count)

        on action query
            let g_action_choice = 'query'
            exit dialog

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog
        
        on action next call cimq500_fetch("N")
        on action previous call cimq500_fetch("P")
        on action last call cimq500_fetch("L")
        on action first call cimq500_fetch("F")
        on action jump call cimq500_fetch("/")

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

        on action total
            let g_curr = 1
        on action day
            let g_curr = 2
        on action subtotal
            let g_curr = 3
        on action product
            let g_curr = 4
        on action rework
            let g_curr = 5
        on action sale
            let g_curr = 6
        on action unsign
            let g_curr = 7

        on action help
            call cl_show_help()

    end dialog

    call cl_set_act_visible("accept,cancel", true)
end function


-- 这里只进行浏览器下载部分，文件生成交给scimq500 处理
function cimq500_output()
    define l_pdf,l_excel  string
    define l_id     varchar(20)

    call scimq500_output(g_tc_ila01,g_tc_ila02) returning l_pdf

    call cl_download_by_explorer(cl_expexcel10_nogui(
                        '/u1/usr/tiptop/typst/projects/cimr500/interface.xml',
                        's_total',base.typeinfo.create(g_total),
                        's_day',base.typeinfo.create(g_daily),
                        's_subtotal',base.typeinfo.create(g_subtotal),
                        's_product',base.typeinfo.create(g_product),
                        's_rework',base.typeinfo.create(g_rework),
                        's_sale',base.typeinfo.create(g_sale),
                        's_unsign',base.typeinfo.create(g_unsign),
                        '',null,'',null,'',null))

    call cl_download_by_explorer(l_pdf)
end function
