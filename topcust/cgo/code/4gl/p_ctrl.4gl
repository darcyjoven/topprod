# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_ctrl.4gl
# Descriptions...: 版本控制作业
# Date & Author..: darcy:2024/08/14



import os
import libctrlc

database ds
GLOBALS "../../config/top.global"

# 类型定义 s---
type ctr record
    ctr01   like ctr_file.ctr01,
    ctr02   like ctr_file.ctr02,
    ctr03   like ctr_file.ctr03,
    ctr04   like ctr_file.ctr04,
    ctr05   like ctr_file.ctr05,
    ctr06   like ctr_file.ctr06,
    gen02   like gen_file.gen02,
    ctr07   like ctr_file.ctr07,
    gem02   like gem_file.gem02,
    ctr08   like ctr_file.ctr08,
    ctr09   like ctr_file.ctr09,
    ctr10   like ctr_file.ctr10,
    ctr21   like ctr_file.ctr21,
    ctr22   like ctr_file.ctr22,
    ctr23   like ctr_file.ctr23,
    ctr24   like ctr_file.ctr24,
    ctr25   like ctr_file.ctr25,
    ctr26   like ctr_file.ctr26
    end record
type cts record
    cts02   like cts_file.cts02,
    cts03   like cts_file.cts03,
    cts04   like cts_file.cts04,
    cts05   like cts_file.cts05,
    cts06   like cts_file.cts06,
    cts07   like cts_file.cts07,
    cts08   like cts_file.cts08,
    cts09   like cts_file.cts09,
    cts10   like cts_file.cts10,
    cts11   like cts_file.cts11,
    cts12   like cts_file.cts12,
    cts13   like cts_file.cts13,
    cts14   like cts_file.cts14,
    cts15   like cts_file.cts15
    end record
type ctt record
    ctt02   like ctt_file.ctt02,
    ctt03   like ctt_file.ctt03,
    ctt04   like ctt_file.ctt04,
    gen02_2 like gen_file.gen02,
    ctt05   like ctt_file.ctt05,
    ctt06   like ctt_file.ctt06,
    ctt07   like ctt_file.ctt07,
    ctt08   like ctt_file.ctt08,
    ctt09   like ctt_file.ctt09,
    ctt10   like ctt_file.ctt10,
    ctt11   like ctt_file.ctt11,
    ctt12   like ctt_file.ctt12,
    ctt13   like ctt_file.ctt13,
    ctt14   like ctt_file.ctt14,
    ctt15   like ctt_file.ctt15
    end record
# 类型定义 ---

define g_ctr,g_ctr_t,g_ctr_o ctr
define g_ctr_list dynamic array of record
    ctr01_1   like ctr_file.ctr01,
    ctr02_1   like ctr_file.ctr02,
    ctr03_1   like ctr_file.ctr03,
    ctr04_1   like ctr_file.ctr04,
    ctr05_1   like ctr_file.ctr05,
    ctr06_1   like ctr_file.ctr06,
    gen02_1   like gen_file.gen02,
    ctr07_1   like ctr_file.ctr07,
    gem02_1   like gem_file.gem02,
    ctr08_1   like ctr_file.ctr08,
    ctr09_1   like ctr_file.ctr09,
    ctr10_1   like ctr_file.ctr10
    end record
define g_cts dynamic array of cts
define g_cts_t,g_cts_o cts
define g_ctt dynamic array of ctt
define g_ctr01_t,g_ctr01    like ctr_file.ctr01

define g_rec_b,g_cnt,l_ac,l_ac_t,g_rec_list,g_curs_index,g_row_count,g_jump integer
define g_sql,g_wc,g_wc2,g_wc3,g_action_flag,g_msg string
define mi_no_ask,l_lock_sw        like type_file.chr1

MAIN
    define   p_row,p_col   like type_file.num5
    options
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("AZZ")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time

    open window p_ctrl_w at p_row,p_col with form "azz/42f/p_ctrl"
            attribute (style = g_win_style clipped)
        
    call cl_ui_init()
    call p_ctrl_ui_init()

    let g_sql = "select * from ctr_file for update "
    declare p_ctrl_ctr_cl cursor from g_sql

    let g_sql = "select ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,'' gen02,ctr07,'' gem02,ctr08,ctr09,ctr10,ctr21,ctr22,ctr23,ctr24,ctr25,ctr26 from ctr_file where ctr01 = ? for update"
    declare p_ctrl_cl cursor from g_sql

    declare p_ctrl_upd_cts_cur cursor for
        select * from cts_file where cts01 = ?

    call p_ctrl_ctr_temp()

    call p_ctrl_menu()

    close window p_ctrl_w
    call  cl_used(g_prog,g_time,2) returning g_time 
END MAIN

function p_ctrl_bp()
    let g_action_choice = ""
    call cl_set_act_visible("accept,cancel", false)

    dialog attributes(unbuffered)
        display array g_cts to s_cts.* attribute(count=g_rec_b)

            before display
                call cl_navigator_setting(g_curs_index, g_row_count)

            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()

            after display
                continue dialog
        end display

        display array g_ctt to s_ctt.* attribute(count=g_rec_b)
            
            before display
                call cl_navigator_setting(g_curs_index,g_row_count)
            
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
            
            after display
                continue dialog

        end display

        on action page2
            let g_action_flag = "page2"
            exit dialog
        
        on action insert
            let g_action_choice = "insert"
            exit dialog

        on action query
            let g_action_choice = "query"
            exit dialog

        on action delete
            let g_action_choice = "delete"
            exit dialog
        on action modify
            let g_action_choice = "modify"
            exit dialog
        on action first
            call p_ctrl_fetch("F")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog
        on action previous
            call p_ctrl_fetch("P")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog
        on action jump
            call p_ctrl_fetch("/")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog
        on action next
            call p_ctrl_fetch("N")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog
        on action last
            call p_ctrl_fetch("L")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog
        on action detail
            let g_action_choice = "detail"
            exit dialog
        on action output
            let g_action_choice = "outpur"
            exit dialog
        on action exit
            let g_action_choice = "exit"
            exit dialog
        on action controlg
            let g_action_choice = "controlg"
            exit dialog
        on action accept
            let g_action_choice = "detail"
            exit dialog
        on action cancel
            let int_flag = false
            let g_action_choice = "exit"
            exit dialog
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        on action about
            call cl_about()
        on action exporttoexcel
            let g_action_choice = "exporttoexcel"
            exit dialog
        &include "qry_string.4gl"
    end dialog

    call cl_set_act_visible("accept,cancel", true)
end function

# 进行下拉框等控件的初始化
function p_ctrl_ui_init()
    define l_descr,l_value string
    define l_gen01      like gen_file.gen01,
           l_gen02      like gen_file.gen02

    # it人员清单
    declare p_ctrl_gen cursor for
        select gen01,gen02 from gen_file
         where gen03 = 'B03' and genacti = 'Y'
    let l_descr = ""
    let l_value = ""
    foreach p_ctrl_gen into l_gen01,l_gen02
        if sqlca.sqlcode then
            call cl_err("p_ctrl_gen",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_value = l_value , sfmt("%1,",l_gen01)
        let l_descr = l_descr , sfmt("%1:%2,",l_gen01,l_gen02)
    end foreach    
    call cl_set_combo_items("ctr03",l_value,l_descr)
    call cl_set_combo_items("ctr03_1",l_value,l_descr)
    
    # 修改类型
    let l_value = "fix,feature,refactor,doc,control"
    let l_descr = "1.BUG修复,2.新功能,3.代码重构,4.修改文档,5.增加管控"
    call cl_set_combo_items("ctr05",l_value,l_descr)
    call cl_set_combo_items("ctr05_1",l_value,l_descr)

    # 需求单状态
    let l_value = "new,out,back,in,unsync,close,cancel"
    let l_descr = "new:开立,out:签出,back:签回,in:签入,unsync:未同步,close:结案,cancel:取消"
    call cl_set_combo_items("ctr10",l_value,l_descr)
    call cl_set_combo_items("ctr10_1",l_value,l_descr)

    # 文件类型
    let l_value = "link,4gl,4fd,other"
    let l_descr = "link:作业编号(p_link),4gl:4gl代码,4fd:4fd文件,other:其它文档"
    call cl_set_combo_items("cts03",l_value,l_descr)

    # 文件状态
    let l_value = "new,sync,complied,linked"
    let l_descr = "new:新增,sync:已同步测试区,complied:编译通过,linked:链接通过"
    call cl_set_combo_items("cts05",l_value,l_descr)

    # 异动类型
    let l_value = ""
    let l_descr = ""
    call cl_set_combo_items("ctt05",l_value,l_descr)

    declare p_ctrl_4gl_cur cursor for
        select ctrl02,ctrl03 from p_ctrl_temp
         where ctrl01 = ? 
    
end function

function p_ctrl_cs()
    clear form

    call g_cts.clear()
    call g_ctt.clear()

    initialize g_ctr.* to null

    dialog attributes(unbuffered)
        construct by name g_wc on 
            ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,
            ctr07,ctr08,ctr09,ctr10,ctr21,ctr22,
            ctr23,ctr24,ctr25,ctr26

            before construct
                call cl_qbe_init()
            
        end construct
        construct g_wc2 on 
            cts02,cts03,cts04,cts05,cts06,cts07
            from s_cts[1].cts02,s_cts[1].cts03,s_cts[1].cts04,s_cts[1].cts05,s_cts[1].cts06,s_cts[1].cts07
            
             before construct
                call cl_qbe_init()

        end construct

        construct g_wc3 on 
            ctt02,ctt03,ctt04,ctt05,ctt06,ctt07,ctt08
            from s_ctt[1].ctt02,s_ctt[1].ctt03,s_ctt[1].ctt04,s_ctt[1].ctt05,s_ctt[1].ctt06,s_ctt[1].ctt07,s_ctt[1].ctt08
            
             before construct
                call cl_qbe_init()

        end construct

        on action controlp

        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action controlg
            call cl_cmdask()

        on action accept
            exit dialog

        on action exit
            let int_flag = false
            exit dialog

        on action cancel
            let int_flag = false
            exit dialog

    end dialog

    if int_flag then
        return
    end if
    # CALL cl_set_head_visible("","YES") TODO
    if cl_null(g_wc) then let g_wc = " 1=1" end if
    if cl_null(g_wc2) then let g_wc = " 1=1" end if
    if cl_null(g_wc3) then let g_wc = " 1=1" end if

    case
        when g_wc2 == " 1=1" and g_wc3 == " 1=1"
            let g_sql = "select ctr01 from ctr_file ",
                        " where ",g_wc clipped,
                        " order by 1"
        when g_wc2 == " 1=1" and g_wc3 != " 1=1"
            let g_sql = "select unique ctr01 from ctr_file,cts_file",
                        " where ",g_wc2 clipped," and ",g_wc clipped,
                        "   and ctr01=cts01 ",
                        " order by 1"
        when g_wc2 != " 1=1" and g_wc3 == " 1=1"
            let g_sql = "select unique ctr01 from ctr_file,ctt_file",
                        " where ",g_wc3 clipped," and ",g_wc clipped,
                        "   and ctr01=ctt01 ",
                        " order by 1"
        when g_wc2 != " 1=1" and g_wc3 != " 1=1"
            let g_sql = "select unique ctr01 from ctr_file,cts_file,ctt_file",
                        " where ",g_wc3 clipped," and ",g_wc clipped,
                        " ",g_wc2 clipped, " and ctr01=ctt01 and ctr01 = ctt01 ",
                        " order by 1"
    end case
    prepare p_ctrl_prepare from g_sql
    declare p_ctrl_cs 
        scroll cursor with hold for p_ctrl_prepare
    declare p_ctrl_fill_cs cursor for p_ctrl_prepare

    let g_sql = "select count(*) from (",
                g_sql,")"
    prepare p_ctrl_precount from g_sql
    declare p_ctrl_count cursor for p_ctrl_precount
end function

function p_ctrl_menu()
    while true
        if cl_null(g_action_flag) or g_action_flag == "page1" then
            call p_ctrl_bp()
        else
            call p_ctrl_list_fill()
            call p_ctrl_list_bp()
        end if
        case g_action_choice
            when "insert"
                if cl_chk_act_auth() then
                    call p_ctrl_a()
                end if
            when "query"
                if cl_chk_act_auth() then
                    call p_ctrl_q()
                end if
            when "modify"
                if cl_chk_act_auth() then
                    call p_ctrl_u()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call p_ctrl_b()
                end if
            when "output"
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    # TODO
                end if
            when "help"
                call cl_show_help()
            when "exit"
                exit while
            when "controlg"
                call cl_cmdask()
        end case
    end while
end function

function p_ctrl_q()
    let g_row_count = 0
    let g_curs_index = 0
    call cl_navigator_setting(g_curs_index,g_row_count)
    initialize g_ctr.* to null

    clear form
    call g_cts.clear()
    call g_ctt.clear()
    display ' ' to cnt

    call p_ctrl_cs()
    if int_flag then
        let int_flag = 0
        initialize g_ctr.* to null
        return
    end if
 
    call cl_msg(" SEARCHING ! ")
    open p_ctrl_cs 

    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,1)
        initialize g_ctr.* to null
    else
        open p_ctrl_count
        fetch p_ctrl_count into g_row_count
        display g_row_count to cnt
        call p_ctrl_fetch("F")
    end if
end function

function p_ctrl_fetch(p_flag)
    define p_flag   like type_file.chr1
    
    case p_flag
        when 'N' fetch next p_ctrl_cs into g_ctr.ctr01
        when 'P' fetch previous p_ctrl_cs into g_ctr.ctr01
        when 'F' fetch first p_ctrl_cs into g_ctr.ctr01
        when 'L' fetch last p_ctrl_cs into g_ctr.ctr01
        when '/'
            if not mi_no_ask then
                let int_flag = false
                prompt g_msg clipped ,": " for g_jump

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
                    let int_flag = false
                    exit case
                end if
            end if
            fetch absolute g_jump p_ctrl_cs into g_ctr.ctr01
            let mi_no_ask = false
    end case
    if sqlca.sqlcode then
        call cl_err(g_ctr.ctr01,sqlca.sqlcode,1)
        initialize g_ctr.* to null
        return
    else
        case p_flag
            when 'N' let g_curs_index = g_curs_index + 1
            when 'P' let g_curs_index = g_curs_index - 1
            when 'F' let g_curs_index = 1
            when 'L' let g_curs_index = g_row_count
            when '/' let g_curs_index = g_jump
        end case
        call cl_navigator_setting(g_curs_index,g_row_count)
    end if

    call p_ctrl_ctr_fresh()

    call p_ctrl_show()
end function

function p_ctrl_show()

    let g_ctr_t.* = g_ctr.*
    display by name g_ctr.*
    call p_ctrl_b_fill(g_wc2,g_wc3)

end function

function p_ctrl_b_fill(p_wc2,p_wc3)
    define p_wc2,p_wc3      string

    let g_sql = "select cts02,cts03,cts04,cts05,cts06,cts07,",
                "       cts08,cts09,cts10,cts11,cts12,cts13,cts14,cts15",
                "  from cts_file ",
                " where cts01 = '",g_ctr.ctr01,"'"
    if p_wc2 != " 1=1" then
        let g_sql = g_sql ,p_wc2 clipped
    end if
    let g_sql = g_sql , " order by cts02"

    prepare p_ctrl_cts_p from g_sql
    declare p_ctrl_cts_cur cursor for p_ctrl_cts_p

    call g_cts.clear()
    let g_cnt = 1
    foreach p_ctrl_cts_cur into g_cts[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("p_ctrl_cts_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_cts.deleteElement(g_cnt)

    let g_sql = "select ctt02,ctt03,ctt04,gen02,ctt05,ctt06,ctt07,ctt08,",
                "       ctt09,ctt10,ctt11,ctt12,ctt13,ctt14,ctt15 ",
                "  from ctt_file,gen_file ",
                " where ctt01 = '",g_ctr.ctr01,"' and gen01 = ctt04 "  
    if p_wc3 != " 1=1" then
        let g_sql = g_sql ,p_wc3 clipped
    end if
    let g_sql = g_sql , " order by ctt02,ctt03"

    prepare p_ctrl_ctt_p from g_sql
    declare p_ctrl_ctt_cur cursor for p_ctrl_ctt_p

    call g_ctt.clear()
    let g_cnt = 1
    foreach p_ctrl_ctt_cur into g_ctt[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("p_ctrl_ctt_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_ctt.deleteElement(g_cnt)

end function

function p_ctrl_list_bp()
    call cl_set_act_visible("accept,cancel", false)

    let g_rec_list = g_ctr_list.getlength()
    display array g_ctr_list to s_ctr1.* attribute(count=g_rec_list,unbuffered)

        before display
            call fgl_set_arr_curr(g_curs_index)
            call cl_navigator_setting(g_curs_index,g_row_count)

        before row
            let l_ac = arr_curr()
            let g_curs_index = l_ac
            call cl_show_fld_cont()

        on action page1
            let g_action_flag = "page1"
            let l_ac = arr_curr()
            let g_jump = l_ac
            let mi_no_ask = true
            if g_rec_list > 0 then
                call p_ctrl_fetch("/")
            end if
            # TODO cl_set_comp_visible("page_list", FALSE)
            exit display
        
        on action accept
            let g_action_flag = "page1"
            let l_ac = arr_curr()
            let g_jump = l_ac
            let mi_no_ask = true
            if g_rec_list > 0 then
                call p_ctrl_fetch("/")
            end if
            # TODO cl_set_comp_visible("page_list", FALSE)
            exit display
        
        on action insert
            let g_action_choice = "insert"
            exit display

        on action query
            let g_action_choice = "query"
            exit display

        on action delete
            let g_action_choice = "delete"
            exit display

        on action modify
            let g_action_choice = "modify"
            exit display

        on action first
            call p_ctrl_fetch("F")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept display

        on action previous
            call p_ctrl_fetch("P")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept display

        on action jump
            call p_ctrl_fetch("/")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept display

        on action next
            call p_ctrl_fetch("N")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept display

        on action last
            call p_ctrl_fetch("L")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept display

        on action detail
            let g_action_choice = "detail"
            exit display

        on action output
            let g_action_choice = "outpur"
            exit display

        on action exit
            let g_action_choice = "exit"
            exit display

        on action controlg
            let g_action_choice = "controlg"
            exit display

        on action cancel
            let int_flag = false
            let g_action_choice = "exit"
            exit display

        on idle g_idle_seconds
            call cl_on_idle()
            continue display

        on action about
            call cl_about()

        on action exporttoexcel
            let g_action_choice = "exporttoexcel"
            exit display

        &include "qry_string.4gl"

    end display

    call cl_set_act_visible("accept,cancel", true)
end function
function p_ctrl_list_fill()
    define l_ctr01  like ctr_file.ctr01
    define l_i integer

    call g_ctr_list.clear()
    let l_i = 1
    foreach p_ctrl_fill_cs into l_ctr01
        if sqlca.sqlcode then
            call cl_err("p_ctrl_fill_cs",sqlca.sqlcode,1)
            exit foreach
        end if
        select ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,ctr07,ctr08,ctr09,ctr10
        into g_ctr_list[l_i].ctr01_1,g_ctr_list[l_i].ctr02_1,g_ctr_list[l_i].ctr03_1,g_ctr_list[l_i].ctr04_1,g_ctr_list[l_i].ctr05_1,
             g_ctr_list[l_i].ctr06_1,g_ctr_list[l_i].ctr07_1,g_ctr_list[l_i].ctr08_1,g_ctr_list[l_i].ctr09_1,g_ctr_list[l_i].ctr10_1
        from ctr_file where ctr01 = l_ctr01

        select gen02 into g_ctr_list[l_i].gen02_1 from gen_file
        where gen01 = g_ctr_list[l_i].ctr06_1

        select gem02 into g_ctr_list[l_i].gem02_1 from gem_file
        where gem01 = g_ctr_list[l_i].ctr07_1

        let l_i = l_i + 1
        if l_i > g_max_rec then
            if g_action_choice = "query"then
                call cl_err( '', 9035, 0 )
            end if
            exit foreach
        end if
    end foreach
    let g_rec_b = l_i
    
    display array g_ctr_list to s_ctr1.* attribute(count = g_rec_b,unbuffered)

        before display
            exit display

    end display

end function

function p_ctrl_a()
    define l_ctr01  like ctr_file.ctr01

    if s_shut(0) then
        return
    end if
    clear form
    call g_cts.clear()
    call g_ctt.clear()
    initialize g_ctr.* to null
    let g_ctr01_t = null
    initialize g_ctr_o.* to null

    while true
        # 默认值

        let g_ctr.ctr02 = g_today
        let g_ctr.ctr10 = 'new'
        let g_ctr.ctr21 = g_user
        let g_ctr.ctr22 = g_today
        let g_ctr.ctr23 = current hour to second

        call p_ctrl_i("a")
        
        if int_flag then
            let int_flag = false
            call cl_err("",9001,0)
            initialize g_ctr.* to null
            exit while
        end if

        begin work
        open p_ctrl_ctr_cl
        if sqlca.sqlcode then
            call cl_err("p_ctrl_ctr_cl",sqlca.sqlcode,1)
            close p_ctrl_ctr_cl
            rollback work
            continue while
        end if
        # ctr01
        select max(ctr01) into l_ctr01 from ctr_file
        if cl_null(l_ctr01) then let l_ctr01 = "1000" end if
        let g_ctr.ctr01 = cs_36_encode(cs_36_decode(l_ctr01) + 1)
        display by name g_ctr.ctr01

        insert into ctr_file (
            ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,ctr07,ctr08,
            ctr09,ctr10,ctr21,ctr22,ctr23,ctr24,ctr25,ctr26
        ) values(
            g_ctr.ctr01,g_ctr.ctr02,g_ctr.ctr03,g_ctr.ctr04,g_ctr.ctr05,g_ctr.ctr06,g_ctr.ctr07,g_ctr.ctr08,
            g_ctr.ctr09,g_ctr.ctr10,g_ctr.ctr21,g_ctr.ctr22,g_ctr.ctr23,g_ctr.ctr24,g_ctr.ctr25,g_ctr.ctr26
        )
        if sqlca.sqlcode then
            call cl_err("ins ctr_file",sqlca.sqlcode,1)
            rollback work
            close p_ctrl_ctr_cl
            continue while
        else
            close p_ctrl_ctr_cl
            commit work
            let g_ctr01_t = g_ctr01
        end if
        let g_ctr_t.* = g_ctr.*
        let g_rec_b = 0
        # 输入单身
        call p_ctrl_b()

    end while

end function

function p_ctrl_i(p_cmd)
    define p_cmd        like type_file.chr1
    define l_gen03      like gen_file.gen03

    input by name g_ctr.* without defaults

        before input 
            call p_ctrl_entry(p_cmd)
            call p_ctrl_no_entry(p_cmd)

        after field ctr03
            # 检查人员信息
            if not cl_null(g_ctr.ctr03) then
                select gen03,gen06 into l_gen03,g_ctr.ctr04
                  from gen_file where gen01 = g_ctr.ctr03
                if l_gen03 != "B03" then
                    call cl_err("只能维护IT部门人员","!",1)
                    next field ctr03
                end if
                if cl_null(g_ctr.ctr04) then
                    call cl_err("请先在aooi040中维护邮箱","!",1)
                    next field ctr03
                end if
                display by name g_ctr.ctr04
            end if

        after field ctr06
            # 检查来源人员部门,不允许都为空
            if cl_null(g_ctr.ctr06) and cl_null(g_ctr.ctr07) then
                next field ctr07
            end if
            if not cl_null(g_ctr.ctr06) then
                select gen02,gen03,gem02 into g_ctr.gen02,g_ctr.ctr07,g_ctr.gem02
                  from gen_file,gem_file where gem01 = gen03 and gen01 = g_ctr.ctr06
                display by name g_ctr.gen02,g_ctr.ctr07,g_ctr.gem02
            end if
        
        after field ctr07
            if cl_null(g_ctr.ctr06) and cl_null(g_ctr.ctr07) then
                call cl_err("来源人员和部门,只要要录入一个","!",1)
                next field ctr07
            end if
            if not cl_null(g_ctr.ctr07) then
                select gem02 into g_ctr.gem02 from gem_file where gem01 = g_ctr.ctr07
                display by name g_ctr.gem02
            end if

        after input
            # 检查录入资料正确否
            if cl_null(g_ctr.ctr04) then
                call cl_err("邮箱必须录入","!",1)
                next field ctr04
            end if

            if cl_null(g_ctr.ctr06) and cl_null(g_ctr.ctr07) then
                call cl_err("来源人员和部门,只要要录入一个","!",1)
                next field ctr06
            end if

            if cl_null(g_ctr.ctr05) then
                call cl_err("必须录入需求单类型","!",1)
                next field ctr05
            end if

            if cl_null(g_ctr.ctr08) then
                call cl_err("必须录入需求单主题","!",1)
                next field ctr08
            end if

        on action controlp
            # 开窗
            case
                when infield(ctr06)
                    call cl_init_qry_var()
                    let g_qryparam.form = "q_gen"
                    let g_qryparam.state = "i"
                    call cl_create_qry() returning g_ctr.ctr06
                    select gen02 into g_ctr.gen02 from gen_file where gen01 = g_ctr.ctr06
                    display by name g_ctr.ctr06,g_ctr.gen02
                    next field ctr06
                when infield(ctr07)
                    call cl_init_qry_var()
                    let g_qryparam.form = "q_gem"
                    let g_qryparam.state = "i"
                    call cl_create_qry() returning g_ctr.ctr07
                    select gem02 into g_ctr.gem02 from gem_file where gem01 = g_ctr.ctr07
                    display by name g_ctr.ctr07,g_ctr.gem02
                    next field ctr07
            end case

        on action controlf
            call cl_set_focus_form(ui.Interface.getRootNode())
                returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

        on action controlr
            call cl_show_req_fields()

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


function p_ctrl_b()
    define p_cmd        like type_file.chr1
    define l_n          integer
    define l_ext        varchar(20)

    let g_action_choice = ""
    if s_shut(0) then
        return
    end if

    if cl_null(g_ctr.ctr01) then
        return
    end if

    select ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,ctr07,ctr08,ctr09,ctr10,
           ctr21,ctr22,ctr23,ctr24,ctr25,ctr26
      into g_ctr.ctr01,g_ctr.ctr02,g_ctr.ctr03,g_ctr.ctr04,g_ctr.ctr05,
           g_ctr.ctr06,g_ctr.ctr07,g_ctr.ctr08,g_ctr.ctr09,g_ctr.ctr10,
           g_ctr.ctr21,g_ctr.ctr22,g_ctr.ctr23,g_ctr.ctr24,g_ctr.ctr25,
           g_ctr.ctr26
      from ctr_file where ctr01 = g_ctr.ctr01
    
    if g_ctr.ctr10 == "6" then
        call cl_err('',9004,0)
        return
    end if

    if g_ctr.ctr10 == "7" then
        call cl_err('',9024,0)
        return
    end if

    let g_sql = "select cts02,cts03,cts04,cts05,cts06,cts07 ",
                "       cts08,cts09,cts10,cts11,cts12,cts13,cts14,cts14 ",
                "  from cts_file where cts01 = ? and cts02 = ?",
                " for update nowait"
    declare p_ctrl_bcl cursor from g_sql

    let g_rec_b = g_cts.getlength()

    input array g_cts without defaults from s_cts.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
                insert row = true,
                delete row = true,
                append row = true)
         
        before input
            if g_rec_b != 0 then
                call fgl_set_arr_curr(l_ac)
            end if
            
        
        before row
            let p_cmd = ''
            let l_ac = arr_curr()
            let l_n = arr_curr()
            let l_lock_sw = 'N'
            let g_success = 'Y'

            begin work
            open p_ctrl_cl using g_ctr.ctr01
            if status then
                call cl_err("open p_ctrl_cl",status,1)
                close p_ctrl_cl
                rollback work
                return
            end if
            fetch p_ctrl_cl into g_ctr.*
            if sqlca.sqlcode then
                call cl_err("fetch p_ctrl_cl",sqlca.sqlcode,1)
                close p_ctrl_cl
                rollback work
                return
            end if
            select gen02 into g_ctr.gen02 from gen_file
             where gen01 = g_ctr.ctr06
            select gem02 into g_ctr.gem02 from gem_file
             where gem01 = g_ctr.ctr07
            
            if g_rec_b >= l_ac then
                # 是修改
                let p_cmd = "u"
                let g_cts_t.* = g_cts[l_ac].*
                let g_cts_o.* = g_cts[l_ac].*

                open p_ctrl_bcl using g_ctr.ctr01, g_cts_t.cts02
                if status then
                    call cl_err("open p_ctrl_bcl",status,1)
                    let l_lock_sw = "Y"
                else
                    fetch p_ctrl_bcl into g_cts[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err("fetch p_ctrl_bcl",sqlca.sqlcode,1)
                        let l_lock_sw = "Y"
                    end if
                end if
            else
                let p_cmd = "a"
            end if
            call p_ctrl_entry(p_cmd)
            call p_ctrl_no_entry(p_cmd)

        on change cts04
            

        before insert
            let g_cnt = 0
            select count(*) into g_cnt from cts_file where cts01 = g_ctr.ctr01
            let l_n = arr_curr()
            let p_cmd = "a"
            initialize g_cts[l_ac].* to null
            # 默认值
            let g_cts[l_ac].cts03 = "1"
            let g_cts[l_ac].cts05 = "1"
            let g_cts[l_ac].cts06 = g_today
            let g_cts[l_ac].cts07 = current hour to second
            call cl_show_fld_cont()
            next field cts02
        
        after insert
            if int_flag then
                call cl_err("",9001,0)
                let int_flag = false
                cancel insert
            end if
            insert into cts_file (
                cts02,cts03,cts04,cts05,cts06,cts07
            ) values(
                g_cts[l_ac].cts02,g_cts[l_ac].cts03,g_cts[l_ac].cts04,g_cts[l_ac].cts05,g_cts[l_ac].cts06,g_cts[l_ac].cts07
            )
            if sqlca.sqlcode then
                call cl_err("ins cts_file",sqlca.sqlcode,1)
                cancel insert
            else
                if g_ctr.ctr10 = "out"
                    or g_ctr.ctr10 = "back"
                    or g_ctr.ctr10 = "in"
                then
                    let g_ctr.ctr10 = "unsync"
                end if
                
                # 更新单头状态
                let g_ctr.ctr24 = g_user
                let g_ctr.ctr25 = g_today
                let g_ctr.ctr26 = current hour to second
                update ctr_file set ctr10 = g_ctr.ctr10,
                    ctr24 = g_ctr.ctr24,
                    ctr25 = g_ctr.ctr25,
                    ctr26 = g_ctr.ctr26
                    where ctr01 = g_ctr.ctr01
                if sqlca.sqlcode then
                    call cl_err("upd ctr_file",sqlca.sqlcode,1)
                    let g_success = "N"
                    rollback work
                    cancel insert
                else
                    display by name  g_ctr.ctr10,g_ctr.ctr24,g_ctr.ctr25,g_ctr.ctr26
                end if

                call cl_msg("INSERT O.K")
                let g_rec_b = g_rec_b + 1
                display g_rec_b to cn2
                if g_success == "Y" then
                    commit work
                else
                    rollback work
                end if
            end if

        before delete
            if g_cts_t.cts02 > 0 and not cl_null(g_cts_t.cts02) then
                if not cl_delb(0,0) then
                    cancel delete
                end if
                if l_lock_sw = "Y" then
                    call cl_err("", -263, 1)
                    cancel delete
                end if
                # 删除资料
                delete from cts_file
                 where cts01 = g_ctr.ctr01 and cts02 = g_cts_t.cts02
                if sqlca.sqlcode then
                    call cl_err("del cts_file",sqlca.sqlcode,1)
                    rollback work
                    cancel delete
                end if
                if g_ctr.ctr10 = "out"
                    or g_ctr.ctr10 = "back"
                    or g_ctr.ctr10 = "in"
                then
                    let g_ctr.ctr10 = "unsync"
                end if

                # 更新单头状态
                let g_ctr.ctr24 = g_user
                let g_ctr.ctr25 = g_today
                let g_ctr.ctr26 = current hour to second
                update ctr_file set ctr10 = g_ctr.ctr10,
                    ctr24 = g_ctr.ctr24,
                    ctr25 = g_ctr.ctr25,
                    ctr26 = g_ctr.ctr26
                    where ctr01 = g_ctr.ctr01
                if sqlca.sqlcode then
                    call cl_err("upd ctr_file",sqlca.sqlcode,1)
                    let g_success = "N"
                    rollback work
                    cancel delete
                else
                    display by name g_ctr.ctr10,g_ctr.ctr24,g_ctr.ctr25,g_ctr.ctr26
                end if

                let g_rec_b = g_rec_b - 1
                display g_rec_b to cn2
                if g_cts_t.cts03 = "link" then
                    call p_ctrl_cts04_change(g_cts_t.cts04,"",true)
                end if
                if g_success = "Y" then
                    commit work
                else
                    rollback work
                end if
            end if
        
        after delete
            if g_cts_t.cts03 = "link" then
                call p_ctrl_b_fill(" 1=1"," 1=1")
                let g_rec_b = g_cts.getlength()
                display array g_cts to s_cts.* attribute(count=g_rec_b)
                    before display
                        exit display
                end display
            end if

        before field cts02
            if cl_null(g_cts[l_ac].cts02) or g_cts[l_ac].cts02 = 0 then
                select max(cts02)+1 into g_cts[l_ac].cts02 from cts_file
                 where cts01 = g_ctr.ctr01
                if cl_null(g_cts[l_ac].cts02) then
                    let g_cts[l_ac].cts02 = 1
                end if
            end if
        
        after field cts02
            if g_cts[l_ac].cts02 = 0 then
                call cl_err('','apm-422',1)
                let g_cts[l_ac].cts02 = g_cts_t.cts02
                next field cts02
            end if
            if g_cts[l_ac].cts02 != g_cts_t.cts02 or cl_null(g_cts_t.cts02) then
                select count(*) into g_cnt from cts_file
                 where cts01 = g_ctr.ctr01
                   and cts02 = g_cts[l_ac].cts02
                if g_cnt > 0 then
                    call cl_err("",-239,0)
                    let g_cts[l_ac].cts02 = g_cts_t.cts02
                    next field cts02
                end if
            end if

        after field cts04
            # TODO 带出附带资料

        on row change
            if int_flag then
                call cl_err("",9001,0)
                let int_flag = false
                let g_cts[l_ac].* = g_cts_t.*
                close p_ctrl_bcl
                rollback work
                exit input
            end if

            if g_cts[l_ac].cts02 = 0 then
                call cl_err('','apm-422',1)
                let g_cts[l_ac].cts02 = g_cts_t.cts02
                next field cts02
            end if
            if g_cts[l_ac].cts02 != g_cts_t.cts02 or cl_null(g_cts_t.cts02) then
                select count(*) into g_cnt from cts_file
                 where cts01 = g_ctr.ctr01
                   and cts02 = g_cts[l_ac].cts02
                if g_cnt > 0 then
                    call cl_err("",-239,0)
                    let g_cts[l_ac].cts02 = g_cts_t.cts02
                    next field cts02
                end if
            end if

            if g_cts[l_ac].cts04 != g_cts_t.cts04 or cl_null(g_cts_t.cts04) then
                select count(*) into g_cnt from cts_file
                 where cts01 = g_ctr.ctr01 and cts03 = g_cts[l_ac].cts03
                   and cts04 = g_cts[l_ac].cts04
                if g_cnt > 0 then
                    call cl_err("",-239,0)
                    let g_cts[l_ac].cts04 = g_cts_t.cts04
                    next field cts04
                end if
            end if
            let g_cts[l_ac].cts06 = g_today
            let g_cts[l_ac].cts07 = current hour to second

            if l_lock_sw = "Y" then
                call cl_err(g_cts[l_ac].cts02,-263,1)
                let g_cts[l_ac].* = g_cts_t.*
            else
                update cts_file
                   set cts02 = g_cts[l_ac].cts02,
                       cts03 = g_cts[l_ac].cts03,
                       cts04 = g_cts[l_ac].cts04,
                       cts05 = g_cts[l_ac].cts05,
                       cts06 = g_cts[l_ac].cts06,
                       cts07 = g_cts[l_ac].cts07,
                       cts08 = g_cts[l_ac].cts08,
                       cts09 = g_cts[l_ac].cts09,
                       cts10 = g_cts[l_ac].cts10,
                       cts11 = g_cts[l_ac].cts11,
                       cts12 = g_cts[l_ac].cts12,
                       cts13 = g_cts[l_ac].cts13,
                       cts14 = g_cts[l_ac].cts14,
                       cts15 = g_cts[l_ac].cts15
                 where cts01 = g_ctr.ctr01
                   and cts02 = g_cts_t.cts02
                if sqlca.sqlcode then
                    call cl_err3("upd","cts_file",g_ctr.ctr01,g_cts_t.cts02,sqlca.sqlcode,"","upd rvb_file",1)
                    let g_cts[l_ac].* = g_cts_t.*
                else
                    if g_ctr.ctr10 = "out"
                        or g_ctr.ctr10 = "back"
                        or g_ctr.ctr10 = "in"
                    then
                        let g_ctr.ctr10 = "unsync"
                    end if
                    
                    let g_ctr.ctr24 = g_user
                    let g_ctr.ctr25 = g_today
                    let g_ctr.ctr26 = current hour to second
                    update ctr_file set ctr10 = g_ctr.ctr10,
                        ctr24 = g_ctr.ctr24,
                        ctr25 = g_ctr.ctr25,
                        ctr26 = g_ctr.ctr26
                        where ctr01 = g_ctr.ctr01
                    if sqlca.sqlcode then
                        call cl_err("upd ctr_file",sqlca.sqlcode,1)
                        let g_success = "N"
                    else
                        display by name  g_ctr.ctr10,g_ctr.ctr24,g_ctr.ctr25,g_ctr.ctr26
                    end if

                    if g_success = "Y" then
                        call cl_msg("UPDATE O.K")
                        commit work
                    else
                        rollback work
                    end if
                    if g_cts[l_ac].cts03 = "link" and g_cts[l_ac].cts04 != g_cts[l_ac].cts04 then
                        call p_ctrl_cts04_change(g_cts_t.cts04,g_cts[l_ac].cts04,false)
                    end if
                end if
            end if

        after row
            let l_ac = arr_curr()
            if int_flag then
                call cl_err("",9001,0)
                let int_flag = false
                if p_cmd = "u" then
                    let g_cts[l_ac].* = g_cts_t.*
                else
                    call g_cts.deleteElement(l_ac)
                    if g_rec_b != 0 then
                        let g_action_choice = "detail"
                        let l_ac = l_ac_t
                    end if
                end if
                close p_ctrl_bcl
                rollback work
                exit input
            end if
            let l_ac_t = l_ac
            close p_ctrl_bcl
            commit work 
            if g_cts[l_ac].cts03 = "link" and g_cts[l_ac].cts04 != g_cts[l_ac].cts04 then
                call p_ctrl_b_fill(" 1=1"," 1=1")
                let g_rec_b = g_cts.getlength()
                display array g_cts to s_cts.* attribute(count=g_rec_b)
                    before display
                        exit display
                end display
            end if

        after input

        before field cts04
            if cl_null(g_cts[l_ac].cts03) then
                call cl_err("需要先指定类型","!",0)
                next field cts03
            end if

        on action controlp
            # 开窗
            if not cl_null(g_cts[l_ac].cts03) then
                if g_cts[l_ac].cts03 = "link" then
                    call p_ctrl_crtlink()
                    exit input
                else
                    let g_cts[l_ac].cts04 = cl_server_file(fgl_getenv("TOP"))
                    let l_ext = os.Path.extension(g_cts[l_ac].cts04)
                    case g_cts[l_ac].cts03
                        when "4gl"
                            if l_ext != "4gl" then
                                call cl_err("你只能录入4gl类型文件","!",0)
                                next field cts03
                            end if
                        when "4fd"
                            if l_ext != "4fd" then
                                call cl_err("你只能录入4fd类型文件","!",0)
                                next field cts03
                            end if
                        when "other"
                    end case
                end if
            end if
        
        on action controlr
            call cl_show_req_fields()
        
        on action controlg
            call cl_cmdask()
        
        on action controlf
            call cl_set_focus_form(ui.Interface.getRootNode())
                returning g_fld_name,g_frm_name 
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on idle g_idle_seconds
            call cl_on_idle()
            continue input
        
        on action about
            call cl_about()

        on action help
            call cl_show_help()
        
        on action controls
            call cl_set_head_visible("","AUTO")
            
    end input

end function

function p_ctrl_u()

    if s_shut(0) then
        return
    end if

    if cl_null(g_ctr.ctr01) then
        call cl_err('',-400,0)
        return
    end if

    select ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,ctr07,ctr08,ctr09,ctr10,
           ctr21,ctr22,ctr23,ctr24,ctr25,ctr26
      into g_ctr.ctr01,g_ctr.ctr02,g_ctr.ctr03,g_ctr.ctr04,g_ctr.ctr05,
           g_ctr.ctr06,g_ctr.ctr07,g_ctr.ctr08,g_ctr.ctr09,g_ctr.ctr10,
           g_ctr.ctr21,g_ctr.ctr22,g_ctr.ctr23,g_ctr.ctr24,g_ctr.ctr25,
           g_ctr.ctr26
      from ctr_file where ctr01 = g_ctr.ctr01

    if sqlca.sqlcode then
        call cl_err(g_ctr.ctr01,sqlca.sqlcode,1)
        initialize g_ctr.* to null
        return
    end if

    if g_ctr.ctr10 == "6" then
        call cl_err('',9004,0)
        return
    end if

    if g_ctr.ctr10 == "7" then
        call cl_err('',9024,0)
        return
    end if

    let g_ctr01_t = g_ctr.ctr01
    let g_ctr_o.* = g_ctr.*
    let g_success = "Y"

    begin work
    open p_ctrl_cl using g_ctr.ctr01
    if status then
        call cl_err("open p_ctrl_cl",status,1)
        close p_ctrl_cl
        rollback work
        return
    end if

    fetch p_ctrl_cl into g_ctr.ctr01
    if sqlca.sqlcode then
        call cl_err("fetch p_ctrl_cl",sqlca.sqlcode,1)
        close p_ctrl_cl
        rollback work
        return
    end if
    
    select gen02 into g_ctr.gen02 from gen_file
     where gen01 = g_ctr.ctr06

    select gem02 into g_ctr.gem02 from gem_file
     where gem01 = g_ctr.ctr07
    
    call p_ctrl_show()

    while true
        let g_ctr.ctr24 = g_user
        let g_ctr.ctr25 = g_today
        let g_ctr.ctr26 = current hour to second

        call p_ctrl_i("u")

        if int_flag then
            let int_flag = false
            let g_ctr.* = g_ctr_t.*
            call p_ctrl_show()
            call cl_err("","9001",0)
            exit while
        end if

        update ctr_file
           set ctr02 = g_ctr.ctr02,
               ctr03 = g_ctr.ctr03,
               ctr04 = g_ctr.ctr04,
               ctr05 = g_ctr.ctr05,
               ctr06 = g_ctr.ctr06,
               ctr07 = g_ctr.ctr07,
               ctr08 = g_ctr.ctr08,
               ctr09 = g_ctr.ctr09,
               ctr10 = g_ctr.ctr10,
               ctr21 = g_ctr.ctr21,
               ctr22 = g_ctr.ctr22,
               ctr23 = g_ctr.ctr23,
               ctr24 = g_ctr.ctr24,
               ctr25 = g_ctr.ctr25,
               ctr26 = g_ctr.ctr26
         where ctr01 = g_ctr_t.ctr01
         if sqlca.sqlcode then
            call cl_err("upd ctr_file",sqlca.sqlcode,1)
            continue while
         end if
         
         exit while
    end while
    
    close p_ctrl_cl
    if g_success = "Y" then
        commit work
    else
        rollback work
    end if

end function

function p_ctrl_copy()
end function

# 由链接资料产生单身
function p_ctrl_crtlink()
    define tok base.StringTokenizer
    define l_zz01       like zz_file.zz01
    define l_cts02      like cts_file.cts02
    define l_cts        record like cts_file.*
    define l_i          integer
    define l_ctrl02     like type_file.chr10,
           l_ctrl03     varchar(1000)

    call cl_init_qry_var()
    let g_qryparam.form = "q_zz"
    let g_qryparam.arg1 = g_lang
    let g_qryparam.state = "c"
    call cl_create_qry() returning g_qryparam.multiret

    if cl_null(g_qryparam.multiret) then
        return
    end if
    select max(cts02) + 1 into l_cts02 from cts_file where cts01 = g_ctr.ctr01
    if cl_null(l_cts02) then
        let l_cts02 = 1
    end if

    call s_showmsg_init()
    delete from p_ctrl_temp
    let g_success = "Y"
    begin work
    
    let tok = base.StringTokenizer.create(g_qryparam.multiret,"|")
    while tok.hasMoreTokens()
        let l_zz01 = tok.nextToken()
        # call 应该由C函数获得4gl与4fd
        call p_ctrl_getfile_fromlink(l_zz01,"i")
        # 检查是否重复
        select count(*) into g_cnt from cts_file
         where cts01 = g_ctr.ctr01 and cts04 = l_zz01 and cts03 = "link"
        if g_cnt > 0 then
            call s_errmsg("cts01,cts02",sfmt("%1|%2",g_ctr.ctr01,l_zz01),"","czz-029",1)
            let g_success = "N"
            rollback work
        end if
        initialize l_cts.* to null
        let l_cts.cts01 = g_ctr.ctr01
        let l_cts.cts02 = l_cts02
        let l_cts.cts03 = "link"
        let l_cts.cts04 = l_zz01
        let l_cts.cts05 = "new"
        let l_cts.cts06 = g_today
        let l_cts.cts07 = current hour to second
        # 插入单身
        insert into cts_file values (l_cts.*)
        if sqlca.sqlcode then
            call s_errmsg("cts01,cts04",sfmt("%1|%2",g_ctr.ctr01,l_zz01),"",sqlca.sqlcode,1)
            let g_success = "N"
            rollback work
        end if
        let l_cts02 = l_cts02 + 1
    end while
    # 如果有报错直接返回
    if g_success = "N" then
        call s_showmsg()
        rollback work
        return
    end if
    # 继续提示是否产生4fd与4gl文件
    call p_ctrl_temp_unique()
    select count(*) into g_cnt from p_ctrl_temp
    if g_cnt = 0 then
        goto _fresh
    end if
    
    # 显示哪些文件将会新增
    call p_ctrl_alert_4gl()

    if not cl_confirm("czz-030") then
        goto _fresh
    end if

    call p_ctrl_handle_4gl()

    label _fresh:
    if g_success = "Y" then
        commit work
    else
        rollback work
    end if
    
    call p_ctrl_b_fill(" 1=1"," 1=1")
    let g_rec_b = g_cts.getlength()
    display array g_cts to s_cts.* attribute(count=g_rec_b)
        before display
            exit display
    end display
end function

function p_ctrl_entry(p_cmd)
    define p_cmd        like type_file.chr1
    if p_cmd = "a" then
        call cl_set_comp_entry("cts02,cts03",true)
        call cl_set_comp_entry("ctr02",true)
    end if
end function

function p_ctrl_no_entry(p_cmd)
    define p_cmd        like type_file.chr1
    if p_cmd = "u" then
        call cl_set_comp_entry("cts02,cts03",false)
        call cl_set_comp_entry("ctr02",false)
    end if
end function

# 从link作业获得4fd与4gl列表
# TODO 逻辑未实现
function p_ctrl_getfile_fromlink(p_link,p_cmd)
    define p_link   like cts_file.cts04
    define p_cmd    like type_file.chr1
    define l_ctrl03 varchar(1000)
    define tok base.StringTokenizer
    define l_4fdlist string


    let l_ctrl03 = get4gl(p_link)
    insert into p_ctrl_temp (ctrl01,ctrl02,ctrl03)
        values (p_cmd,"4gl",l_ctrl03)

    let l_4fdlist = get4fd(l_ctrl03)
    let tok = base.StringTokenizer.create(l_4fdlist,"|")
    while tok.hasMoreTokens()
        let l_ctrl03 = tok.nextToken()
        if not cl_null(l_ctrl03) then
            insert into p_ctrl_temp (ctrl01,ctrl02,ctrl03)
                values (p_cmd,"4fd",l_ctrl03)
        end if
    end while
end function

# link修改
function p_ctrl_cts04_change(p_old,p_new,p_tran)
    define p_old,p_new      like cts_file.cts04
    define p_tran           like type_file.chr1
    define l_i              integer
    
    delete from p_ctrl_temp
    if not p_tran then
        begin work
    end if
    if not cl_null(p_old) then
        # 这是要删除的
        call p_ctrl_getfile_fromlink(p_old,"d")
    end if
    if not cl_null(p_new) then
        # 这是要新增的
        call p_ctrl_getfile_fromlink(p_new,"i")
    end if 

    call p_ctrl_temp_unique()

    # 处理单身资料
    call p_ctrl_alert_4gl()

    select count(*) into g_cnt from p_ctrl_temp
    if g_cnt = 0 then
        return
    end if

    if cl_confirm("czz-030") then
        call p_ctrl_handle_4gl()
    end if
    
    if g_success = "N" then
        if not p_tran then
            rollback work
        end if
    else
        if not p_tran then
            commit work
        end if
    end if
end function


function p_ctrl_ctr_temp()
    drop table p_ctrl_temp
    create temp table p_ctrl_temp(
        ctrl01      varchar(1),
        ctrl02      varchar(10),
        ctrl03      varchar(1000)
    )
end function

# 根据临时表进行单身处理
function p_ctrl_handle_4gl()
    define l_cts02      like cts_file.cts02
    define l_cts        record like cts_file.*
    define l_i          integer
    define l_ctrl01     like type_file.chr1,
           l_ctrl02     like type_file.chr10,
           l_ctrl03     varchar(1000)

    select max(cts02) + 1 into l_cts02 from cts_file where cts01 = g_ctr.ctr01
    if cl_null(l_cts02) then
        let l_cts02 = 1
    end if

    call s_showmsg_init()

    declare p_ctrl_4gl_cur3 cursor for
        select ctrl01,ctrl02,ctrl03 from p_ctrl_temp
         order by ctrl01,ctrl02,ctrl03
         
    foreach p_ctrl_4gl_cur3 into l_ctrl01,l_ctrl02,l_ctrl03
        if sqlca.sqlcode then
            call cl_err("p_ctrl_4gl_cur3",sqlca.sqlcode,1)
            exit foreach
        end if
        
        select count(*) into g_cnt from cts_file
        where cts01 = g_ctr.ctr01 and cts04 = l_ctrl03 and cts03 = l_ctrl02
        # 已有资料
        if g_cnt > 0 then
            if l_ctrl01 = "d" then
                delete from cts_file where cts01 = g_ctr.ctr01
                   and cts03 = l_ctrl02 and cts04 = l_ctrl03
                if sqlca.sqlcode then
                    call s_errmsg("cts01,cts03,cts04",sfmt("%1|%2|%3",g_ctr.ctr01,l_ctrl02,l_ctrl03),"",sqlca.sqlcode,1)
                    let g_success = "N"
                end if
            end if
            continue foreach
        end if
        # 新增资料
        initialize l_cts.* to null
        let l_cts.cts01 = g_ctr.ctr01
        let l_cts.cts02 = l_cts02
        let l_cts.cts03 = l_ctrl02
        let l_cts.cts04 = l_ctrl03
        let l_cts.cts05 = "new"
        let l_cts.cts06 = g_today
        let l_cts.cts07 = current hour to second

        insert into cts_file values (l_cts.*)
        if sqlca.sqlcode then
            call s_errmsg("cts01,cts03,cts04",sfmt("%1|%2|%3",g_ctr.ctr01,l_ctrl02,l_ctrl03),"",sqlca.sqlcode,1)
            let g_success = "N"
        end if

        let l_cts02 = l_cts02 + 1
    end foreach

    if g_success = "N" then
        call s_showmsg()
    end if
end function

# 提示哪些资料要显示
function p_ctrl_alert_4gl()
    define l_ctrl01     like type_file.chr1,
           l_ctrl02     like type_file.chr10,
           l_ctrl03     varchar(1000)

    call s_showmsg_init()

    declare p_ctrl_4gl_cur2 cursor for
        select ctrl01,ctrl02,ctrl03 from p_ctrl_temp
         order by ctrl01,ctrl02,ctrl03

    foreach p_ctrl_4gl_cur2 into l_ctrl01,l_ctrl02,l_ctrl03
        if sqlca.sqlcode then
            call cl_err("p_ctrl_4gl_cur2",sqlca.sqlcode,1)
            exit foreach
        end if
        if l_ctrl01 = "i" then
            call s_errmsg("cts01,cts03,cts04",sfmt("%1|%2|%3",g_ctr.ctr01,l_ctrl02,l_ctrl03),"","czz-034",1)
        else
            select count(*) into g_cnt from cts_file 
             where cts01 = g_ctr.ctr01 and cts03 = l_ctrl02 and cts04 = l_ctrl03
            if g_cnt > 0 then
                call s_errmsg("cts01,cts03,cts04",sfmt("%1|%2|%3",g_ctr.ctr01,l_ctrl02,l_ctrl03),"","czz-033",1)
            else
                delete from p_ctrl_temp where ctrl01 = l_ctrl01 and ctrl02 = l_ctrl02 and ctrl03 = l_ctrl03
            end if
        end if
    end foreach

    call s_showmsg()
end function

# 去除重复数据
function p_ctrl_temp_unique()
    # 删除重复数据
    insert into p_ctrl_temp (ctrl01,ctrl02,ctrl03)
        select unique case ctrl01 when 'd' then 'e' when 'i' then 'j' else '' end ctrl01,ctrl02,ctrl03
          from p_ctrl_temp
    delete from p_ctrl_temp where ctrl01 in ('d','i')
    insert into p_ctrl_temp (ctrl01,ctrl02,ctrl03)
        select  case ctrl01 when 'e' then 'd' when 'j' then 'i' else '' end ctrl01,ctrl02,ctrl03
          from p_ctrl_temp
    delete from p_ctrl_temp where ctrl01 in ('e','j')
    # 将既删除又新增的资料去除
    let g_sql = " delete from p_ctrl_temp where (ctrl02,ctrl03) in ( ",
                "     select a.ctrl02,a.ctrl03 from p_ctrl_temp a ",
                "      where exists (select * from p_ctrl_temp b where b.ctrl02 = a.ctrl02 and b.ctrl03 = a.ctrl03 and b.ctrl01 = 'i') ",
                "        and exists (select * from p_ctrl_temp c where c.ctrl02 = a.ctrl02 and c.ctrl03 = a.ctrl03 and c.ctrl01 = 'd') ",
                " ) "
    prepare p_ctrl_del_double from g_sql
    execute p_ctrl_del_double
end function

# 重写查询单头资料
function p_ctrl_ctr_fresh()

    if cl_null(g_ctr.ctr01) then
        return
    end if
    select ctr01,ctr02,ctr03,ctr04,ctr05,ctr06,ctr07,ctr08,ctr09,ctr10,
           ctr21,ctr22,ctr23,ctr24,ctr25,ctr26
      into g_ctr.ctr01,g_ctr.ctr02,g_ctr.ctr03,g_ctr.ctr04,g_ctr.ctr05,
           g_ctr.ctr06,g_ctr.ctr07,g_ctr.ctr08,g_ctr.ctr09,g_ctr.ctr10,
           g_ctr.ctr21,g_ctr.ctr22,g_ctr.ctr23,g_ctr.ctr24,g_ctr.ctr25,
           g_ctr.ctr26
      from ctr_file where ctr01 = g_ctr.ctr01

    if sqlca.sqlcode then
        call cl_err(g_ctr.ctr01,sqlca.sqlcode,1)
        initialize g_ctr.* to null
        return
    end if

    select gen02 into g_ctr.gen02 from gen_file
     where gen01 = g_ctr.ctr06

    select gem02 into g_ctr.gem02 from gem_file
     where gem01 = g_ctr.ctr07
end function


# 异动记录
# p_type 类型:checkout,
# p_comment 说明
# p_id git 提交的id
function p_ctrl_timeline(p_type,p_comment,p_id)
    define p_type       varchar(40),
           p_comment    string,
           p_id         varchar(50)
    define l_ctt    record like ctt_file.*

    let l_ctt.ctt01 = g_ctr.ctr01
    let l_ctt.ctt02 = g_today
    let l_ctt.ctt03 = current hour to second
    let l_ctt.ctt04 = g_user
    let l_ctt.ctt05 = p_type
    let l_ctt.ctt06 = p_comment
    let l_ctt.ctt06 = p_id

    insert into ctt_file values(l_ctt.*)
    if sqlca.sqlcode then
        call cl_err("ins ctt_file",sqlca.sqlcode,1) 
        return false
    end if
    return true
end function


# 删除无效文件
# 选择自动删除,且删除成功后,返回true,否则false
# 自动刷新单身
function p_ctrl_clear(p_tran)
    define p_tran       boolean
    define l_clear      boolean
    define l_cts        record like cts_file.*
    define l_cts_list   dynamic array of integer
    define l_msg        string
    define l_i          integer

    if cl_null(g_ctr.ctr01) then
        call cl_err('',-400,0)
        return
    end if
    # 刷新单头资料
    call p_ctrl_ctr_fresh() 
    if p_ctrl.ctrl10 = "close" and p_ctrl.ctrl10 = "cancel" then
        call cl_err(g_ctr.ctr01,"czz-038",1)
        return false
    end if
    # 是否删除
    if not cl_confirm("czz-037") then
        return false
    end if

    let l_clear = false
    let g_success = "Y"
    if not p_tran then
        begin work
    end if

    call l_cts_list.clear()
    foreach p_ctrl_upd_cts_cur using g_ctr.ctr01 into l_cts.*
        if sqlca.sqlcode then
            call cl_err("p_ctrl_upd_cts_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        if l_cts.cts03 = "4fd" or l_cts.cts03 = "4gl" or l_cts.cts03 = "other" then
            if not os.Path.exists(l_cts.cts04) then
                let l_cts_list[l_cts_list.getlength()+1] = l_cts.cts02
                let l_msg = l_msg , '{"action":"clear","before":',cs_record_json(l_cts)'}\n' 
            end if
        end if
    end foreach
    for l_i = 1 to l_cts_list.getlength()
        delete from cts_file
         where cts01 = g_ctr.ctr01
           and cts02 = l_cts_list[l_i]
        if sqlca.sqlcode then
            call cl_err("del cts_file",sqlca.sqlcode,1)
            let g_success = "N"
            goto _error
        end if
    end for
    # 插入异动记录
    if not p_ctrl_timeline("clear",l_msg,"") then
        let g_success = "N"
        goto _error
    end if

    let g_ctr.ctr24 = g_user
    let g_ctr.ctr25 = g_today
    let g_ctr.ctr26 = current hour to second
    update ctr_file set ctr24 = g_ctr.ctr24,
            ctr25 = g_ctr.ctr25,
            ctr26 = g_ctr.ctr26
     where ctr01 = g_ctr.ctr01
    if sqlca.sqlcode then
        call cl_err("upd ctr",sqlca.sqlcode,1)
        let g_success = "N"
        goto _error
    end if

    label _error:
    if g_success = "Y" then
        if not p_tran then
            commit work
        end if
        call p_ctrl_b_fill(" 1=1"," 1=1")
        return true
    else
        if not p_tran then
            rollback work
        end if 
        call p_ctrl_b_fill(" 1=1"," 1=1")
        return false
    end if
end function

# 签出
function p_ctrl_checkout()
    define l_msg        string
    define l_cts        record like cts_file.*
    define l_gen02      like gen_file.gen02

    if cl_null(g_ctr.ctr01) then
        call cl_err('',-400,0)
        return
    end if
    # 刷新单头资料
    call p_ctrl_ctr_fresh()
    if g_ctr.ctr10 != "new" then
        call cl_err(g_ctr.ctr01,"czz-035",1)
        return
    end if

    # 检查单身资料
    let g_success = "Y"
    let l_msg = ""
    call s_showmsg_init()
    foreach p_ctrl_upd_cts_cur using g_ctr.ctr01 into l_cts.*
        if sqlca.sqlcode then
            call cl_err("p_ctrl_upd_cts_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        # 是否有文件不存在的情况,要求必须删除才能继续
        if l_cts.cts03 = "4fd" or l_cts.cts03 = "4gl" or l_cts.cts03 = "other" then
            if not os.Path.exists(l_cts.cts04) then
                call s_errmsg("cts03,cts04",sfmt("%1|%2",l_cts.cts03,l_cts.cts04),"","czz-036",1)
                let g_success = "N"
                continue foreach
            end if
        end if       
    end foreach
    if g_success = "N" then
        call s_showmsg()
        if not p_ctrl_clear(false) then
            return
        end if
    end if

    let g_success = "Y"
    begin work

    # 锁住此笔资料,防止其他人修改
    open p_ctrl_cl using g_ctr.ctr01
    if sqlca.sqlcode then
        call cl_err("open p_ctrl_cl",sqlca.sqlcode,1)
        let g_success = "N"
        goto _error
    end if
    # 签出,调用Go包
    {
    }
    select gen02 into l_gen02 from gen_file where gen01 = g_ctr.ctr03
    if not checkout(g_ctr.ctr01,l_gen02,g_ctr.ctr04) end if
        let g_success = "N"
        goto _error
    end if

    # 更新单身资料状态
    foreach p_ctrl_upd_cts_cur using g_ctr.ctr01 into l_cts.*
        if sqlca.sqlcode then
            call cl_err("p_ctrl_upd_cts_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        if l_cts.cts03 = "4fd" or l_cts.cts03 = "4gl" or l_cts.cts03 = "other" then
            l_msg = l_msg , '{"action":"checkout","before":',cs_record_json(l_cts)
            let l_cts.cts06 = g_today
            let l_cts.cts07 = current hour to second
            update cts_file set cts06 = l_cts.cts06,cts07 = l_cts.cts07
             where cts01 = g_ctr.ctr01 and cts02 = l_cts.ctts02
            if sqlca.sqlcode then
                call cl_err("upd cts_file",sqlca.sqlcode,1)
                let g_success = "N"
                goto _error
            end if
            let l_msg = l_msg ,',"after":',cs_record_json(l_cts),'}\n'
        end if
    end foreach

    # 更新单据状态
    let g_ctr.ctr24 = g_user
    let g_ctr.ctr25 = g_today
    let g_ctr.ctr26 = current hour to second
    update ctr_file set ctr10 = "out",
            ctr24 = g_ctr.ctr24,
            ctr25 = g_ctr.ctr25,
            ctr26 = g_ctr.ctr26
     where ctr01 = g_ctr.ctr01
    if sqlca.sqlcode then
        call cl_err("upd ctr",sqlca.sqlcode,1)
        let g_success = "N"
        goto _error
    end if

    # 异动记录
    if not p_ctrl_timeline("checkout",l_msg,"") then
        let g_success = "N"
        goto _error
    end if
    
    label _error:
    close p_ctrl_cl
    if g_success = "Y" then
        commit work
    else
        rollback work
    end if
end function
