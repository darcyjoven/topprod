# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_email.4gl
# Descriptions...: email 发送程序

database ds

globals "../../config/top.global"

type tc_mab record
    tc_mab01    like tc_mab_file.tc_mab01,
    tc_maa02    like tc_maa_file.tc_maa02,
    tc_maa13    like tc_maa_file.tc_maa13,
    tc_mab02    like tc_mab_file.tc_mab02,
    tc_mab03    like tc_mab_file.tc_mab03,
    tc_mabmod   like tc_mab_file.tc_mabmod,
    tc_mabmodt  like tc_mab_file.tc_mabmodt
    end record
type tc_mac record
    tc_mac02    like tc_mac_file.tc_mac02,
    tc_mac03    like tc_mac_file.tc_mac03,
    tc_mac04    like tc_mac_file.tc_mac04,
    tc_mac05    like tc_mac_file.tc_mac05
    end record
type tc_mad_left record
    tc_mad02_l  like tc_mad_file.tc_mad02,
    tc_mad03_l  like tc_mad_file.tc_mad03,
    tc_mad04_l  like tc_mad_file.tc_mad04,
    tc_mad05_l  like tc_mad_file.tc_mad05,
    tc_mad06_l  like tc_mad_file.tc_mad06,
    tc_mad07_l  like tc_mad_file.tc_mad07,
    tc_mad08_l  like tc_mad_file.tc_mad08
    end record
type tc_mad_right record
    tc_mad02_r  like tc_mad_file.tc_mad02,
    tc_mad03_r  like tc_mad_file.tc_mad03,
    tc_mad04_r  like tc_mad_file.tc_mad04,
    tc_mad05_r  like tc_mad_file.tc_mad05,
    tc_mad06_r  like tc_mad_file.tc_mad06,
    tc_mad07_r  like tc_mad_file.tc_mad07,
    tc_mad08_r  like tc_mad_file.tc_mad08
    end record

define g_tc_mab,g_tc_mab_o,g_tc_mab_t tc_mab
define g_tc_mad_left dynamic array of tc_mad_left
define g_tc_mad_left_t,g_tc_mad_left_o tc_mad_left
define g_tc_mad_right dynamic array of tc_mad_right
define g_tc_mad_right_t,g_tc_mad_right_o tc_mad_right
define g_tc_mac dynamic array of tc_mac

define g_sql,g_wc,g_wc2,g_wc_l,g_wc_r,g_argv1,g_forupd_sql,g_msg string
define l_ac,g_cnt,g_rec_b1,g_rec_b2,g_row_count,g_curs_index,g_jump integer
define g_before_input_done boolean

define g_action_flag varchar(40)

main
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

    open window p_email_template_w with form "azz/42f/p_email_template"
          attribute (style = g_win_style clipped)
    call cl_ui_init()

    let g_argv1 = arg_val(1)

    let g_forupd_sql = "select tc_mab01,'','',tc_mab02,tc_mab03 from tc_mab_file where tc_mab01 = ? for update "
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare p_email_template_cl cursor from g_forupd_sql

    call p_email_template_init()

    if not cl_null(g_argv1) then
        call p_email_template_q()
    end if

    call p_email_template_menu()

    close window p_email_template_w
    call cl_used(g_prog,g_time,2) returning g_time
end main
# init
function p_email_template_init()
end function
# 查询条件
function p_email_template_cs()
    define  lc_qbe_sn       like gbm_file.gbm01
    define  l_where         string

    if not cl_null(g_argv1) then
        let g_wc = "tc_mab01='",g_argv1,"'"
    else
        clear form
        call g_tc_mad_left.clear()
        call g_tc_mad_right.clear()
        call g_tc_mac.clear()
        initialize g_tc_mab.* to null
        call cl_set_head_visible("","YES")

        dialog attribute(unbuffered)
            construct by name g_wc on tc_mab01,tc_mab02,tc_mab03
                before construct
                    call cl_qbe_init()
            end construct
            construct g_wc2 on tc_mac02,tc_mac03,tc_mac04,tc_mac05
                from s_tc_mac[1].tc_mac02,s_tc_mac[1].tc_mac03,s_tc_mac[1].tc_mac04,s_tc_mac[1].tc_mac05
                before construct
                    call cl_qbe_display_condition(lc_qbe_sn)
            end construct

            construct g_wc_l on tc_mad02,tc_mad03,tc_mad04,tc_mad05,tc_mad06,tc_mad07,tc_mad08
                from s_tc_mad_l[1].tc_mad02_l,s_tc_mad_l[1].tc_mad03_l,s_tc_mad_l[1].tc_mad04_l,s_tc_mad_l[1].tc_mad05_l,s_tc_mad_l[1].tc_mad06_l,s_tc_mad_l[1].tc_mad07_l,s_tc_mad_l[1].tc_mad08_l
                before construct
                    call cl_qbe_display_condition(lc_qbe_sn)
            end construct

            construct g_wc_r on tc_mad02,tc_mad03,tc_mad04,tc_mad05,tc_mad06,tc_mad07,tc_mad08
                from s_tc_mad_r[1].tc_mad02_r,s_tc_mad_r[1].tc_mad03_r,s_tc_mad_r[1].tc_mad04_r,s_tc_mad_r[1].tc_mad05_r,s_tc_mad_r[1].tc_mad06_r,s_tc_mad_r[1].tc_mad07_r,s_tc_mad_r[1].tc_mad08_r
                before construct
                    call cl_qbe_display_condition(lc_qbe_sn)
            end construct

            on action controlp
                case
                    when infield(tc_mab01)
                    when infield(tc_mad03_l)
                    when infield(tc_mad03_r)
                end case
            
            on idle g_idle_seconds
                call cl_on_idle()
                continue dialog
 
            on action about
                call cl_about()
 
            on action help 
                call cl_show_help()
 
            on action controlg
                call cl_cmdask()
 
            on action qbe_select
                call cl_qbe_list() returning lc_qbe_sn
                call cl_qbe_display_condition(lc_qbe_sn)
               
            on action accept
                exit dialog

            on action exit
                let int_flag = true
                exit dialog 
                 
            on action cancel
                let int_flag = true
                exit dialog
        end dialog
    end if
    if cl_null(g_wc) then let g_wc = " 1=1" end if
    if cl_null(g_wc2) then let g_wc = " 1=1" end if
    if cl_null(g_wc_l) then let g_wc = " 1=1" end if
    if cl_null(g_wc_r) then let g_wc = " 1=1" end if

    if int_flag then
        return
    end if
    let g_sql = "select unique tc_mab01 from tc_mab_file"
    let l_where = " where ",g_wc clipped
    if not cl_null(g_wc2) and g_wc2 != " 1=1" then
        let g_sql = g_sql,",tc_mac_file"
        let l_where = l_where," and tc_mac01 = tc_mab01 "
    end if
    if not cl_null(g_wc_l) and g_wc2 != " 1=1" then
        let g_sql = g_sql,",tc_mad_file a"
        let l_where = l_where," and a.tc_mad01=tc_mab01 and a.tc_mad09='left' "
    end if
    if not cl_null(g_wc_r) and g_wc2 != " 1=1" then
        let g_sql = g_sql,",tc_mad_file b"
        let l_where = l_where," and b.tc_mad01=tc_mab01 and b.tc_mad09='right' "
    end if
    let g_sql = g_sql,l_where

    prepare p_email_template_prepare from g_sql
    declare p_email_template_curs
        scroll cursor with hold for p_email_template_prepare
    
    let g_sql = "select count(*) from (",g_sql,")"
    prepare p_email_template_precount from g_sql
    declare p_email_template_count cursor for p_email_template_precount
    
end function

# 查询
function p_email_template_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    initialize g_tc_mab.* to null
    call cl_msg("")

    call cl_opmsg("q")
    display '   ' to formonly.cnt

    call p_email_template_cs()
    if int_flag then
        let int_flag = 0
        initialize g_tc_mab.* to null
        return
    end if

    open p_email_template_curs
    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,1)
        initialize g_tc_mab.* to null
    else
        open p_email_template_count
        fetch p_email_template_count into g_row_count
        display g_row_count to formonly.cnt
        call p_email_template_fetch("F")
    end if
    call cl_msg("")
end function

# 菜单
function p_email_template_menu()
    while true
        if cl_null(g_action_flag) or g_action_choice = "page02" then
            call p_email_template_bp("G")
        end if
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call p_email_template_q()
                end if
            when "modify"
                if cl_chk_act_auth() then
                    call p_email_template_u()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call p_email_template_b()
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

# 修改
function p_email_template_u()
    if s_shut(0) then
        return
    end if
    if g_tc_mab.tc_mab01 is null then
        call cl_err('',-400,0)
        return
    end if
    message ""
    call cl_opmsg("u")
    let g_tc_mab_o.* = g_tc_mab.*

    begin work

    open p_email_template_cl using g_tc_mab.tc_mab01
    if status then
        call cl_err("open p_email_template_cl:",status,1)
        close p_email_template_cl
        rollback work
        return
    end if
    fetch p_email_template_cl into g_tc_mab.*
    if sqlca.sqlcode then
        call cl_err(g_tc_mab.tc_mab01,sqlca.sqlcode,1)
        close p_email_template_cl
        rollback work
        return
    end if
    call p_email_template_show()
    while true
        let g_tc_mab.tc_mabmod = g_user
        let g_tc_mab.tc_mabmodt = current year to second
        call p_email_template_i("u")
        if int_flag then
            let int_flag = false
            rollback work
            let g_tc_mab.* = g_tc_mab_t.*
            call p_email_template_show()
            call cl_err('','9001',0)
            exit while
        end if
        #
        if not p_email_template_sql(g_tc_mab.tc_mab01,g_tc_mab.tc_mab03,true) then
            if not cl_confirm("czz-022") then
                continue while
            end if
        end if
        update tc_mab_file
           set tc_mab02 = g_tc_mab.tc_mab02,
               tc_mab03 = g_tc_mab.tc_mab03
         where tc_mab01 = g_tc_mab.tc_mab01
        if sqlca.sqlcode then
            call cl_err("upd tc_mab",sqlca.sqlcode,1)
            continue while
        else
            commit work
        end if
        exit while
    end while
    close p_email_template_cl
end function

function p_email_template_bp(p_ud)
    define p_ud     varchar(1)
    if p_ud != "G" OR g_action_choice = "detail" then
        return
    end if
    let g_action_choice = " "
    call cl_set_act_visible("accept,cancel", false)

    dialog attribute(unbuffered)
        
        display array g_tc_mad_left to s_tc_mad_l.*
            before display
                call cl_navigator_setting(g_curs_index, g_row_count)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
            after display
                continue dialog
        end display

        display array g_tc_mad_right to s_tc_mad_r.*
            before display
                call cl_navigator_setting(g_curs_index, g_row_count)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
            after display
                continue dialog
        end display

        display array g_tc_mac to s_tc_mac.*
            before display
                call cl_navigator_setting(g_curs_index, g_row_count)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
            after display
                continue dialog
        end display

        on action query
            let g_argv1 = null
            let g_action_choice = "query"
            exit dialog

        on action modify
            let g_action_choice = "modify"
            exit dialog

        on action first
            call p_email_template_fetch("F")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1!=0 or g_rec_b2 != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action previous
            call p_email_template_fetch("P")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1!=0 or g_rec_b2 != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action jump
            call p_email_template_fetch("/")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1!=0 or g_rec_b2 != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action last
            call p_email_template_fetch("L")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1!=0 or g_rec_b2 != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action next
            call p_email_template_fetch("N")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1!=0 or g_rec_b2 != 0 then
                call fgl_set_arr_curr(1)
            end if
            accept dialog

        on action detail
            let g_action_choice="detail"
            exit dialog

        on action output
            let g_action_choice="output"
            exit dialog

        on action help
            let g_action_choice="help"
            exit dialog

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice="exit"
            exit dialog

        on action controlg
            let g_action_choice="controlg"
            exit dialog

        on action accept
            let g_action_choice="detail"
            let l_ac = arr_curr()
            exit dialog

        on action cancel
            let int_flag=false
            let g_action_choice="exit"
            exit dialog

        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog

        on action about
            call cl_about()

        &include "qry_string.4gl"
    end dialog

    call cl_set_act_visible("accept,cancel", true)
end function

# 进入单身
function p_email_template_b()
    define p_cmd varchar(40)
    define l_lock_sw varchar(1)
    define l_tc_mad02_l_o,l_tc_mad02_r_o integer

    let g_action_choice = ""
    fetch p_email_template_cl into g_tc_mab.*
    call p_email_template_show()

    let g_forupd_sql = "select * from tc_mac_file where tc_mac01 =? and tc_mac02 =? for update"
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare p_tc_mac_cl cursor from g_forupd_sql

    let g_forupd_sql = "select * from tc_mad_file where tc_mad01 =? and tc_mad09 = ? and tc_mad02 = ? for update"
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare p_tc_mad_cl cursor from g_forupd_sql
    
    dialog attribute(unbuffered)
        input array  g_tc_mad_left from s_tc_mad_l.*
            attribute(count=g_rec_b1,maxcount=g_max_rec,without defaults=true,
                    insert row=true,delete row=true,append row=true)
            before input
                if g_rec_b1 != 0 then
                    call fgl_set_arr_curr(l_ac)
                end if
            before row
                let p_cmd = ''
                let l_ac = arr_curr()
                let l_lock_sw = 'N'
                let g_tc_mad_left_t.* = g_tc_mad_left[l_ac].*

                begin work
                
                open p_email_template_cl using g_tc_mab.tc_mab01
                if status then
                    call cl_err("open p_email_template_cl:",status,1)
                    close p_email_template_cl
                    rollback work
                    return
                else
                    fetch p_email_template_cl into g_tc_mab.*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_mab.tc_mab01,sqlca.sqlcode,1)
                        close p_email_template_cl
                        rollback WORK
                        return
                    end if
                    select tc_maa02,tc_maa13 into g_tc_mab.tc_maa02,g_tc_mab.tc_maa13
                      from tc_maa_file where tc_maa01 = g_tc_mab.tc_mab01
                    # call p_email_template_show()
                end if
                if g_rec_b1 >= l_ac then
                    let p_cmd = "u"
                    open p_tc_mad_cl using g_tc_mab.tc_mab01,"left",g_tc_mad_left_t.tc_mad02_l
                    if status then
                        call cl_err("open p_tc_mad_cl",status,1)
                        let l_lock_sw = "Y"
                    # else
                    #     fetch p_tc_mad_cl into b_tc_mad_l.*
                    #     if sqlca.sqlcode then
                    #         call cl_err("lock tc_mab",sqlca.sqlcode,1)
                    #         let l_lock_sw = "Y"
                    #     else
                    #         call p_email_template_move_to()
                    #     end if
                    end if
                    call p_email_template_set_entry()
                    call p_email_template_set_no_entry()
                    call cl_show_fld_cont()
                end if
            
            before insert
                let p_cmd = "a"
                initialize g_tc_mad_left[l_ac].* to null
                initialize g_tc_mad_left_t.* to null
                # let b_tc_mad_l.tc_mad01 = g_tc_mab.tc_mab01
                next field tc_mad02_l
            
            after insert
                if int_flag then
                    call cl_err("",9001,0)
                    let int_flag =false
                    cancel insert
                end if

                case p_email_template_left_inschk()
                    when "tc_mad03" next field tc_mad03_l
                    when "tc_mad04" next field tc_mad04_l
                    when "tc_mad05" next field tc_mad05_l
                    when "tc_mad06" next field tc_mad06_l
                    when "tc_mad07" next field tc_mad07_l
                    when "tc_mad08" next field tc_mad08_l
                    when "error" cancel insert
                end case
                call p_email_template_move_back()
                insert into tc_mad_file (
                    tc_mad01,tc_mad02,tc_mad03,tc_mad04,tc_mad05,
                    tc_mad06,tc_mad07,tc_mad08,tc_mad09
                )values(
                    g_tc_mab.tc_mab01,g_tc_mad_left[l_ac].tc_mad02_l,g_tc_mad_left[l_ac].tc_mad03_l,g_tc_mad_left[l_ac].tc_mad04_l,g_tc_mad_left[l_ac].tc_mad05_l,
                    g_tc_mad_left[l_ac].tc_mad06_l,g_tc_mad_left[l_ac].tc_mad07_l,g_tc_mad_left[l_ac].tc_mad08_l,'left'
                )
                if sqlca.sqlcode then
                    call cl_err("ins tc_mad_file",sqlca.sqlcode,1)
                    cancel insert
                else
                    message 'INSERT O.K'
                    let g_rec_b1 = g_rec_b1 + 1
                    display g_rec_b1 to formonly.cnt
                end if
            
            before field tc_mad02_l
                if g_tc_mad_left[l_ac].tc_mad02_l is null or g_tc_mad_left[l_ac].tc_mad02_l = 0 then
                    select max(tc_mad02)+1 into g_tc_mad_left[l_ac].tc_mad02_l
                      from tc_mad_file where tc_mad01 = g_tc_mab.tc_mab01
                       and tc_mad09 = 'left'
                    if cl_null(g_tc_mad_left[l_ac].tc_mad02_l) then
                        let g_tc_mad_left[l_ac].tc_mad02_l = 1
                    end if
                end if
            
            after field tc_mad02_l
                if not cl_null(g_tc_mad_left[l_ac].tc_mad02_l) then
                    if g_tc_mad_left[l_ac].tc_mad02_l != g_tc_mad_left_t.tc_mad02_l or
                        g_tc_mad_left_t.tc_mad02_l is null then
                        let g_cnt=0
                        select count(*) into g_cnt from tc_mad_file
                        where tc_mad01 = g_tc_mab.tc_mab01 and tc_mad02_l = g_tc_mad_left[l_ac].tc_mad02_l 
                        if g_cnt > 0 then
                            let g_tc_mad_left[l_ac].tc_mad02_l = g_tc_mad_left_t.tc_mad02_l
                            call cl_err('',-239,0)
                            next field tc_mad02_l
                        end if
                    end if
                end if
            
            after field tc_mad03_l
                if not cl_null(g_tc_mad_left[l_ac].tc_mad03_l) then
                    let g_cnt = 0
                    select count(*) into g_cnt from tc_mac_file
                     where tc_mac01 = g_tc_mab.tc_mab01 and tc_mac03 = g_tc_mad_left[l_ac].tc_mad03_l
                    if g_cnt = 0 then
                        call cl_err(g_tc_mad_left[l_ac].tc_mad03_l,"czz-023",1)
                        next field tc_mad03_l
                    end if
                    if cl_null(g_tc_mad_left[l_ac].tc_mad04_l) then
                        select tc_mac04 into g_tc_mad_left[l_ac].tc_mad04_l from tc_mac_file
                         where tc_mac01 = g_tc_mab.tc_mab01 and tc_mac03 = g_tc_mad_left[l_ac].tc_mad03_l
                        if cl_null(g_tc_mad_left[l_ac].tc_mad04_l) then
                            let g_tc_mad_left[l_ac].tc_mad04_l = g_tc_mad_left[l_ac].tc_mad03_l
                        end if
                    end if
                    if cl_null(g_tc_mad_left[l_ac].tc_mad05_l) then
                        let g_cnt = 0
                        select max(tc_mad05) + 1 into g_cnt from tc_mad_file
                        where tc_mad01 = g_tc_mab.tc_mab01 and tc_mad09 = "left"
                        if g_cnt = 0 or cl_null(g_cnt) then
                            let g_cnt = 1
                        end if
                        let g_tc_mad_left[l_ac].tc_mad05_l = g_cnt
                    end if
                    if cl_null(g_tc_mad_left[l_ac].tc_mad06_l) then
                        let g_tc_mad_left[l_ac].tc_mad06_l = 6
                    end if
                end if

            before delete
                if g_tc_mad_left_t.tc_mad02_l > 0 then
                    if not cl_delb(0,0) then
                        cancel delete
                    end if
                    if l_lock_sw = "Y" then
                        call cl_err("",-263,1)
                        cancel delete
                    end if

                    delete from tc_mab_file where tc_mab01 = g_tc_mab_t.tc_mab01
                       and tc_mad02 = g_tc_mad_left_t.tc_mad02_l
                       and tc_mad09 = 'left'
                    if sqlca.sqlcode then
                        call cl_err("dele tc_mab_file",sqlca.sqlcode,1)
                        rollback work
                        cancel delete
                    else
                        let g_rec_b1 = g_rec_b1 - 1
                        display g_rec_b1 to formonly.cnt
                        commit work
                    end if
                end if
            
            on row change
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = 0
                    let g_tc_mad_left[l_ac].* = g_tc_mad_left_t.*
                    close p_tc_mad_cl
                    rollback work
                    exit dialog
                end if
                case p_email_template_left_inschk()
                    when "tc_mad03" next field tc_mad03_l
                    when "tc_mad04" next field tc_mad04_l
                    when "tc_mad05" next field tc_mad05_l
                    when "tc_mad06" next field tc_mad06_l
                    when "tc_mad07" next field tc_mad07_l
                    when "tc_mad08" next field tc_mad08_l
                    # when "error" cancel insert
                end case

                update tc_mad_file 
                   set tc_mad02 = g_tc_mad_left[l_ac].tc_mad02_l,
                       tc_mad03 = g_tc_mad_left[l_ac].tc_mad03_l,
                       tc_mad04 = g_tc_mad_left[l_ac].tc_mad04_l,
                       tc_mad05 = g_tc_mad_left[l_ac].tc_mad05_l,
                       tc_mad06 = g_tc_mad_left[l_ac].tc_mad06_l,
                       tc_mad07 = g_tc_mad_left[l_ac].tc_mad07_l,
                       tc_mad08 = g_tc_mad_left[l_ac].tc_mad08_l
                 where tc_mad01 = g_tc_mab.tc_mab01
                   and tc_mad02 = g_tc_mad_left_t.tc_mad02_l
                   and tc_mad09 = 'left'
                if sqlca.sqlcode then
                    call cl_err("upd tc_mad_file left",sqlca.sqlcode,1)
                    continue dialog
                else
                    commit work
                end if

            after row
                let l_ac = arr_curr()
                if int_flag then
                    call cl_err("",9001,0)
                    let int_flag = false
                    if p_cmd = "a" and l_ac <= g_tc_mad_left.getlength() then
                        # NOTE: appedn
                    end if
                    if p_cmd = "u" then
                        let g_tc_mad_left[l_ac].* = g_tc_mad_left_t.*
                    else
                        initialize g_tc_mad_left[l_ac].* to null
                        call g_tc_mad_left.deleteElement(l_ac)
                    end if
                    close p_tc_mad_cl
                    rollback work
                    exit dialog
                else
                    close p_tc_mad_cl
                    commit work
                end if
            
            after input
                # let g_cnt = 0
            
            on action controlo
                if infield(tc_mad02_l) and l_ac > 1 then
                    let l_tc_mad02_l_o = g_tc_mad_left[l_ac].tc_mad02_l
                    let g_tc_mad_left[l_ac].* = g_tc_mad_left[l_ac-1].*
                    let g_tc_mad_left[l_ac].tc_mad02_l = l_tc_mad02_l_o
                end if

        end input

        input array g_tc_mad_right from s_tc_mad_r.*
            attribute(count=g_rec_b2,maxcount=g_max_rec,without defaults=true,
                    insert row=true,delete row=true,append row=true)
            before input
                if g_rec_b2 != 0 then
                    call fgl_set_arr_curr(l_ac)
                end if
            before row
                let p_cmd = ''
                let l_ac = arr_curr()
                let l_lock_sw = 'N'
                let g_tc_mad_right_t.* = g_tc_mad_right[l_ac].*

                begin work
                
                open p_email_template_cl using g_tc_mab.tc_mab01
                if status then
                    call cl_err("open p_email_template_cl:",status,1)
                    close p_email_template_cl
                    rollback work
                    return
                else
                    fetch p_email_template_cl into g_tc_mab.*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_mab.tc_mab01,sqlca.sqlcode,1)
                        close p_email_template_cl
                        rollback WORK
                        return
                    end if
                    select tc_maa02,tc_maa13 into g_tc_mab.tc_maa02,g_tc_mab.tc_maa13
                      from tc_maa_file where tc_maa01 = g_tc_mab.tc_mab01
                    # call p_email_template_show()
                end if
                if g_rec_b2 >= l_ac then
                    let p_cmd = "u"
                    open p_tc_mad_cl using g_tc_mab.tc_mab01,"right",g_tc_mad_right_t.tc_mad02_r
                    if status then
                        call cl_err("open p_tc_mad_cl",status,1)
                        let l_lock_sw = "Y"
                    # else
                    #     fetch p_tc_mad_cl into b_tc_mad_l.*
                    #     if sqlca.sqlcode then
                    #         call cl_err("lock tc_mab",sqlca.sqlcode,1)
                    #         let l_lock_sw = "Y"
                    #     else
                    #         call p_email_template_move_to()
                    #     end if
                    end if
                    call p_email_template_set_entry()
                    call p_email_template_set_no_entry()
                    call cl_show_fld_cont()
                end if
            
            before insert
                let p_cmd = "a"
                initialize g_tc_mad_right[l_ac].* to null
                initialize g_tc_mad_right_t.* to null
                # let b_tc_mad_l.tc_mad01 = g_tc_mab.tc_mab01
                next field tc_mad02_r
            
            after insert
                if int_flag then
                    call cl_err("",9001,0)
                    let int_flag =false
                    cancel insert
                end if

                case p_email_template_right_inschk()
                    when "tc_mad03" next field tc_mad03_r
                    when "tc_mad04" next field tc_mad04_r
                    when "tc_mad05" next field tc_mad05_r
                    when "tc_mad06" next field tc_mad06_r
                    when "tc_mad07" next field tc_mad07_r
                    when "tc_mad08" next field tc_mad08_r
                    when "error" cancel insert
                end case
                call p_email_template_move_back()
                insert into tc_mad_file (
                    tc_mad01,tc_mad02,tc_mad03,tc_mad04,tc_mad05,
                    tc_mad06,tc_mad07,tc_mad08,tc_mad09
                )values(
                    g_tc_mab.tc_mab01,g_tc_mad_right[l_ac].tc_mad02_r,g_tc_mad_right[l_ac].tc_mad03_r,g_tc_mad_right[l_ac].tc_mad04_r,g_tc_mad_right[l_ac].tc_mad05_r,
                    g_tc_mad_right[l_ac].tc_mad06_r,g_tc_mad_right[l_ac].tc_mad07_r,g_tc_mad_right[l_ac].tc_mad08_r,'right'
                )
                if sqlca.sqlcode then
                    call cl_err("ins tc_mad_file",sqlca.sqlcode,1)
                    cancel insert
                else
                    message 'INSERT O.K'
                    let g_rec_b1 = g_rec_b1 + 1
                    display g_rec_b1 to formonly.cnt
                end if
            
            before field tc_mad02_r
                if g_tc_mad_right[l_ac].tc_mad02_r is null or g_tc_mad_right[l_ac].tc_mad02_r = 0 then
                    select max(tc_mad02)+1 into g_tc_mad_right[l_ac].tc_mad02_r
                      from tc_mad_file where tc_mad01 = g_tc_mab.tc_mab01
                       and tc_mad09 = 'right'
                    if cl_null(g_tc_mad_right[l_ac].tc_mad02_r) then
                        let g_tc_mad_right[l_ac].tc_mad02_r = 1
                    end if
                end if
            
            after field tc_mad02_r
                if not cl_null(g_tc_mad_right[l_ac].tc_mad02_r) then
                    if g_tc_mad_right[l_ac].tc_mad02_r != g_tc_mad_right_t.tc_mad02_r or
                        g_tc_mad_right_t.tc_mad02_r is null then
                        let g_cnt=0
                        select count(*) into g_cnt from tc_mad_file
                        where tc_mad01 = g_tc_mab.tc_mab01 and tc_mad02_r = g_tc_mad_right[l_ac].tc_mad02_r 
                        if g_cnt > 0 then
                            let g_tc_mad_right[l_ac].tc_mad02_r = g_tc_mad_right_t.tc_mad02_r
                            call cl_err('',-239,0)
                            next field tc_mad02_r
                        end if
                    end if
                end if
            
            after field tc_mad03_r
                if not cl_null(g_tc_mad_right[l_ac].tc_mad03_r) then
                    let g_cnt = 0
                    select count(*) into g_cnt from tc_mac_file
                     where tc_mac01 = g_tc_mab.tc_mab01 and tc_mac03 = g_tc_mad_right[l_ac].tc_mad03_r
                    if g_cnt = 0 then
                        call cl_err(g_tc_mad_right[l_ac].tc_mad03_r,"czz-023",1)
                        next field tc_mad03_r
                    end if
                    if cl_null(g_tc_mad_right[l_ac].tc_mad04_r) then
                        select tc_mac04 into g_tc_mad_right[l_ac].tc_mad04_r from tc_mac_file
                         where tc_mac01 = g_tc_mab.tc_mab01 and tc_mac03 = g_tc_mad_right[l_ac].tc_mad03_r
                        if cl_null(g_tc_mad_right[l_ac].tc_mad04_r) then
                            let g_tc_mad_right[l_ac].tc_mad04_r = g_tc_mad_right[l_ac].tc_mad03_r
                        end if
                    end if
                    if cl_null(g_tc_mad_right[l_ac].tc_mad05_r) then
                        let g_cnt = 0
                        select max(tc_mad05) + 1 into g_cnt from tc_mad_file
                        where tc_mad01 = g_tc_mab.tc_mab01 and tc_mad09 = "right"
                        if g_cnt = 0 or cl_null(g_cnt) then
                            let g_cnt = 1
                        end if
                        let g_tc_mad_right[l_ac].tc_mad05_r = g_cnt
                    end if
                    if cl_null(g_tc_mad_right[l_ac].tc_mad06_r) then
                        let g_tc_mad_right[l_ac].tc_mad06_r = 6
                    end if
                end if

            before delete
                if g_tc_mad_right_t.tc_mad02_r > 0 then
                    if not cl_delb(0,0) then
                        cancel delete
                    end if
                    if l_lock_sw = "Y" then
                        call cl_err("",-263,1)
                        cancel delete
                    end if

                    delete from tc_mab_file where tc_mab01 = g_tc_mab_t.tc_mab01
                       and tc_mad02 = g_tc_mad_right_t.tc_mad02_r
                       and tc_mad09 = 'right'
                    if sqlca.sqlcode then
                        call cl_err("dele tc_mab_file",sqlca.sqlcode,1)
                        rollback work
                        cancel delete
                    else
                        let g_rec_b2 = g_rec_b2 - 1
                        display g_rec_b2 to formonly.cnt
                        commit work
                    end if
                end if
            
            on row change
                if int_flag then
                    call cl_err('',9001,0)
                    let int_flag = 0
                    let g_tc_mad_right[l_ac].* = g_tc_mad_right_t.*
                    close p_tc_mad_cl
                    rollback work
                    exit dialog
                end if
                case p_email_template_right_inschk()
                    when "tc_mad03" next field tc_mad03_r
                    when "tc_mad04" next field tc_mad04_r
                    when "tc_mad05" next field tc_mad05_r
                    when "tc_mad06" next field tc_mad06_r
                    when "tc_mad07" next field tc_mad07_r
                    when "tc_mad08" next field tc_mad08_r
                    # when "error" cancel insert
                end case

                update tc_mad_file 
                   set tc_mad02 = g_tc_mad_right[l_ac].tc_mad02_r,
                       tc_mad03 = g_tc_mad_right[l_ac].tc_mad03_r,
                       tc_mad04 = g_tc_mad_right[l_ac].tc_mad04_r,
                       tc_mad05 = g_tc_mad_right[l_ac].tc_mad05_r,
                       tc_mad06 = g_tc_mad_right[l_ac].tc_mad06_r,
                       tc_mad07 = g_tc_mad_right[l_ac].tc_mad07_r,
                       tc_mad08 = g_tc_mad_right[l_ac].tc_mad08_r
                 where tc_mad01 = g_tc_mab.tc_mab01
                   and tc_mad02 = g_tc_mad_right_t.tc_mad02_r
                   and tc_mad09 = 'right'
                if sqlca.sqlcode then
                    call cl_err("upd tc_mad_file right",sqlca.sqlcode,1)
                    continue dialog
                else
                    commit work
                end if

            after row
                let l_ac = arr_curr()
                if int_flag then
                    call cl_err("",9001,0)
                    let int_flag = false
                    if p_cmd = "a" and l_ac <= g_tc_mad_right.getlength() then
                        # NOTE: appedn
                    end if
                    if p_cmd = "u" then
                        let g_tc_mad_right[l_ac].* = g_tc_mad_right_t.*
                    else
                        initialize g_tc_mad_right[l_ac].* to null
                        call g_tc_mad_right.deleteElement(l_ac)
                    end if
                    close p_tc_mad_cl
                    rollback work
                    exit dialog
                else
                    close p_tc_mad_cl
                    commit work
                end if
            
            after input
                # let g_cnt = 0
            
            on action controlo
                if infield(tc_mad02_r) and l_ac > 1 then
                    let l_tc_mad02_r_o = g_tc_mad_right[l_ac].tc_mad02_r
                    let g_tc_mad_right[l_ac].* = g_tc_mad_right[l_ac-1].*
                    let g_tc_mad_right[l_ac].tc_mad02_r = l_tc_mad02_r_o
                end if

        end input

        on action controlp
            case
                when infield(tc_mad03_l)
                    call cl_init_qry_var()
                    let g_qryparam.form     = "cq_tc_mac03"
                    let g_qryparam.arg1     = " tc_mac01='",g_tc_mab.tc_mab01,"' "
                    call cl_create_qry() returning g_tc_mad_left[l_ac].tc_mad03_l,g_tc_mad_left[l_ac].tc_mad04_l
                    display by name g_tc_mad_left[l_ac].tc_mad03_l,g_tc_mad_left[l_ac].tc_mad04_l
                    next field tc_mad03_l

                when infield(tc_mad03_r)
                    call cl_init_qry_var()
                    let g_qryparam.form     = "cq_tc_mac03"
                    let g_qryparam.arg1     = "  tc_mac01='",g_tc_mab.tc_mab01,"' "
                    call cl_create_qry() returning g_tc_mad_right[l_ac].tc_mad03_r,g_tc_mad_right[l_ac].tc_mad04_r
                    display by name g_tc_mad_right[l_ac].tc_mad03_r,g_tc_mad_right[l_ac].tc_mad04_r
                    next field tc_mad03_r
            end case

        on action controlr
            call cl_show_req_fields()
 
        on action controlg 
            call cl_cmdask()
 
        on action controlf
            call cl_set_focus_form(ui.interface.getrootnode()) returning g_fld_name,g_frm_name #add on 040913
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang) #add on 040913
 
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
 
        on action about
            call cl_about()
 
        on action help
            call cl_show_help()
 
        on action controls
            call cl_set_head_visible("","auto")

        on action accept
            accept dialog
        
        on action cancel
            exit dialog

    end dialog
end function

# 查询单身
function p_email_template_b_fill()
    let g_sql = "select tc_mad02,tc_mad03,tc_mad04,tc_mad05,tc_mad06,tc_mad07,tc_mad08 ",
                " from tc_mad_file where tc_mad01 = ? and tc_mad09 ='left' "
    if not cl_null(g_wc_l) then
        let g_sql = g_sql," and ",g_wc_l clipped
    end if
    let g_sql = g_sql ," order by tc_mad02"
    declare p_email_template_b_fill_l cursor from g_sql

    let g_sql = "select tc_mad02,tc_mad03,tc_mad04,tc_mad05,tc_mad06,tc_mad07,tc_mad08 ",
                " from tc_mad_file where tc_mad01 = ? and tc_mad09 ='right' "
    if not cl_null(g_wc_r) then
        let g_sql = g_sql," and ",g_wc_r clipped
    end if
    let g_sql = g_sql," order by tc_mad02"
    declare p_email_template_b_fill_r cursor from g_sql

    let g_sql = "select tc_mac02,tc_mac03,tc_mac04,tc_mac05 ",
                " from tc_mac_file where tc_mac01 = ? "
    if not cl_null(g_wc2) then
        let g_sql = g_sql , " and ",g_wc2 clipped
    end if
    let g_sql = g_sql," order by tc_mac02"
    declare p_email_template_b_fill cursor from g_sql

    let g_cnt = 1
    call g_tc_mad_left.clear()
    foreach p_email_template_b_fill_l using g_tc_mab.tc_mab01 into g_tc_mad_left[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("p_email_template_b_fill_l",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        end if
    end foreach
    call g_tc_mad_left.deleteElement(g_cnt)

    let g_cnt = 1
    call g_tc_mad_right.clear()
    foreach p_email_template_b_fill_r using g_tc_mab.tc_mab01 into g_tc_mad_right[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("p_email_template_b_fill_r",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        end if
    end foreach
    call g_tc_mad_right.deleteElement(g_cnt)
    
    let g_cnt = 1
    call g_tc_mac.clear()
    foreach p_email_template_b_fill using g_tc_mab.tc_mab01 into g_tc_mac[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("p_email_template_b_fill",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
        if g_cnt > g_max_rec then
            call cl_err( '', 9035, 0 )
            exit foreach
        end if
    end foreach
    call g_tc_mac.deleteElement(g_cnt)

end function

# 切换笔数
function p_email_template_fetch(p_flag)
    define p_flag  varchar(1)
    
    case p_flag
        when 'N' fetch next  p_email_template_curs into g_tc_mab.tc_mab01
        when 'P' fetch first p_email_template_curs into g_tc_mab.tc_mab01
        when 'F' fetch first p_email_template_curs into g_tc_mab.tc_mab01
        when 'L' fetch last  p_email_template_curs into g_tc_mab.tc_mab01
        when '/'
            call cl_getmsg('fetch',g_lang) returning g_msg
            let int_flag = false
            prompt g_msg clipped,": " for g_jump
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
            fetch absolute g_jump p_email_template_curs into g_tc_mab.tc_mab01
    end case
    if sqlca.sqlcode then
        call cl_err(g_tc_mab.tc_mab01,sqlca.sqlcode,1)
        initialize g_tc_mab.* to null
        return
    end if
    case p_flag
        when 'F' let g_curs_index = 1
        when 'P' let g_curs_index = g_curs_index - 1
        when 'N' let g_curs_index = g_curs_index + 1
        when 'L' let g_curs_index = g_row_count
        when '/' let g_curs_index = g_jump
    end case
    call cl_navigator_setting(g_curs_index, g_row_count)
    
    call p_email_template_show()
end function

# 单头显示
function p_email_template_show()
    select tc_mab01,tc_mab02,tc_mab03,tc_mabmod,tc_mabmodt 
      into g_tc_mab.tc_mab01,g_tc_mab.tc_mab02,g_tc_mab.tc_mab03,g_tc_mab.tc_mabmod,g_tc_mab.tc_mabmodt
      from tc_mab_file where tc_mab01 = g_tc_mab.tc_mab01
    select tc_maa02,tc_maa13 into g_tc_mab.tc_maa02,g_tc_mab.tc_maa13
      from tc_maa_file where tc_maa01 = g_tc_mab.tc_mab01
    display by name g_tc_mab.*
    # display g_tc_mab.tc_maa02,g_tc_mab.tc_maa13 to tc_maa02,tc_maa13
    call p_email_template_b_fill()
end function

# 修改单头
function p_email_template_i(p_cmd)
    define p_cmd    varchar(1)

    call cl_set_head_visible("","YES")
    
    input by name g_tc_mab.tc_mab02,g_tc_mab.tc_mab03 without defaults
        before input
            let g_before_input_done = true
        
        after field tc_mab03

        on change tc_mab03

        after input
            if int_flag then
                exit input
            end if
        
        on action controlf
            call cl_set_focus_form(ui.interface.getrootnode()) returning g_fld_name,g_frm_name #add on 040913
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

function p_email_template_move_to()
end function

function p_email_template_set_entry()
end function
function p_email_template_set_no_entry()
end function

function p_email_template_move_back()
end function
function p_email_template_left_inschk()
    return ""
end function
function p_email_template_right_inschk()
    return ""
end function

# 解析SQL产生tc_mac文件
function p_email_template_sql(p_tc_mab01,p_tc_mab03,p_inTran)
    define p_tc_mab01   like tc_mab_file.tc_mab01
    define p_tc_mab03   like tc_mab_file.tc_mab03
    define p_inTran     boolean
    define l_cnt,i,j    integer

    define sr   dynamic array of record
        col  varchar(255),
        name varchar(255)
        end record
    define sr1 dynamic array of record
        tc_mac02        like tc_mac_file.tc_mac02,
        tc_mac03        like tc_mac_file.tc_mac03,
        tc_mac04        like tc_mac_file.tc_mac04
        end record

    call sr.clear()
    call p_email_template_sql_parse(p_tc_mab03) returning sr

    if sr.getlength() = 0 then
        call cl_err("未解析到任何字段信息","czz-019",1)
        return false
    end if
    # 长度不同差异提示
    let l_cnt = 0
    select count(*) into l_cnt from tc_mac_file 
     where tc_mac01 = p_tc_mab01
    if l_cnt = 0 then
        # 无资料不用提示，直接写入
        goto ins_tc_mac
    end if
    if l_cnt != sr.getLength() then
        if not cl_confirm("czz-020") then
            return false
        end if
    end if
    # name或者col不同差异提示
    let i = 1
    declare p_email_template_sql_2 cursor for
        select tc_mac02,tc_mac03,tc_mac04 from tc_mac_file
         where tc_mac01 = p_tc_mab01
    call sr1.clear()
    foreach p_email_template_sql_2 into sr1[i].*
        if sqlca.sqlcode then
            call cl_err("p_email_template_sql_2",sqlca.sqlcode,1)
            exit foreach
        end if
        if sr1[i].tc_mac03 != sr[i].col or
           sr1[i].tc_mac04 != sr[i].name then
            call cl_err(sr1[i].tc_mac03||"|"||sr[i].col,"czz-021",1)
            if not cl_confirm("czz-021") then
                return false
            end if
            exit foreach
        end if
        let i = i + 1
    end foreach

    label ins_tc_mac:
    # 开始写入
    if not p_inTran then
        begin work
    end if
    
    delete from tc_mac_file where tc_mac01 = p_tc_mab01
    if sqlca.sqlcode then
        call cl_err("del tc_mac_file",sqlca.sqlcode,1)
        if not p_inTran then
            rollback work
        end if
        return false
    end if
    for i = 1 to sr.getLength()
        insert into tc_mac_file (
            tc_mac01,tc_mac02,tc_mac03,tc_mac04
        )values(
            p_tc_mab01,i,sr[i].col,sr[i].name
        )
        if sqlca.sqlcode then
            call cl_err("ins tc_mac_file",sqlca.sqlcode,1)
            if not p_inTran then
                rollback work
            end if
            return false
        end if
    end for

    if not p_inTran then
        commit work
    end if
    message "INSERT O.K."

    return true
end function

# sql解析
function p_email_template_sql_parse(p_tc_mab03)
    define p_tc_mab03   like tc_mab_file.tc_mab03
    define sr   dynamic array of record
        col  varchar(255),
        name varchar(255)
        end record
    define l_excmd,l_select,l_col,l_sql  string
    define l_cnt,i,j,k,l_left,l_right    integer
    define tok    base.StringTokenizer
    
    #SQL 要求：
    #   必须显式指定栏位名称，重复和复杂栏位应用as指定别名。
    #   不允许使用*号
    #   不允许录入条件等参数（即SQL必须能够直接执行）
    #   不允许含有注释
    #   case 等字段请务必用括号标记起来，或者用视图方式

    let g_success = 'Y'
    # SQL检查：
    # 1.可以运行，加上select count(*) 外壳，可以同时检查是否有重复字段
    let l_excmd = p_tc_mab03
    
    let l_sql = "select count(*) from (",l_excmd,") where rownum = 1 "
    prepare p_email_template_sql_1 from l_sql
    let l_cnt = 0
    execute p_email_template_sql_1 into l_cnt

    if l_cnt = 0 or sqlca.sqlcode then
        call cl_err("执行错误，或未查询到任何一笔数据","czz-019",1)
        let g_success = 'N'
        goto re_do
    end if

    # 2.检查是否含有 * 字符
    let l_excmd = l_excmd.toLowerCase()

    let i = l_excmd.getIndexOf("select",1)
    let j = l_excmd.getIndexOf("from",1)
    let l_select = l_excmd.subString(i+6,j-1)
    if l_select.getIndexOf("*",1) > 0 then
        let g_success = 'N'
        call cl_err("请避免使用 '*'' ","czz-019",1)
        goto re_do
    end if

    # 3. 检查是否含有备注
    if l_excmd.getIndexOf("--",1) >0 or
       l_excmd.getIndexOf("/*",1) >0 or
       l_excmd.getIndexOf("*/",1) >0 then
        let g_success = 'N'
        call cl_err("SQL中含有备注' ","czz-019",1)
        goto re_do
    end if

    # SQL取查询字段:
    #   以 , 为分割字符串依据，如果包含括号左括号，向后匹配一个右括号，合并起来算一个栏位。

    # 1. 分割字符串并插入到数组，因为token中不好处理，所以现在放到数组中方便后续处理
    let tok = base.stringtokenizer.create(l_select,",")
    call sr.clear()
    let i = 0
    while tok.hasmoretokens()
        # display tok.nexttoken()
        let i = i + 1
        let sr[i].col = tok.nexttoken()
    end while

    # 2. 括号处理，和别名处理
    #   别名分辨，去掉两端空格后，如果中间有空格，最后一个空格后是别名。
    let i = 1
    while i <= sr.getlength()
        let l_col = sr[i].col
        let l_col = l_col.trim()
        # 处理 带括号的情况
        let l_right = 0
        let l_left = 0
        call p_email_template_brackets(l_col) returning l_left,l_right
        
        # 左括号数量小于右括号
        if l_right > l_left then
            let g_success = 'N'
            call cl_err("右括号数量大于左括号","czz-019",1)
            goto re_do
        end if

        # 左括号数量大于右括号
        if l_right < l_left then
            # 已经是最后一笔报错
            if i+1 > sr.getlength() then
                let g_success = 'N'
                call cl_err("未找到成对括号 "||sr[i].col,"czz-019",1)
                goto re_do
            end if
            # 向后找括号
            let sr[i].col = l_col,sr[i+1].col
            call sr.deleteElement(i+1)
            continue while
        end if

        if l_right > 0 and l_left > 0 then
        end if

        # 有空格,处理别名
        if l_col.getIndexOf(" ",1) > 0 then
            let tok = base.stringtokenizer.create(l_col," ")
            while tok.hasmoretokens()
                let sr[i].col = tok.nexttoken()
            end while
        else
        # 无空格无需处理
        end if
        let i = i + 1
    end while

    # 3. 说明栏位设置
    #   取gaq03字段
    for i = 1 to sr.getLength()
        let l_col = sr[i].col
        let l_col = l_col.trim()
        let sr[i].col = l_col

        select gaq03 into sr[i].name from gaq_file
         where gaq01 = sr[i].col and gaq02 = '2'
        if cl_null(sr[i].name) then
            let sr[i].name = sr[i].col
        end if
    end for

    label re_do:
    return sr
end function


function p_email_template_brackets(p_str)
    define p_str,p_substr,p_tmp   string
    define l_cnt,i,r_left,r_right integer

    let r_left = 0
    let r_right = 0
    for i = 1 to p_str.getlength()
        if p_str.getCharAt(i) = "(" then
            let r_left = r_left + 1
        end if
        if p_str.getCharAt(i) = ")" then
            let r_right = r_right + 1
        end if
    end for
    return r_left,r_right
end function
