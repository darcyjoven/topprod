# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: p_email_config.4gl
# Descriptions...: 邮件系统参数作业
# Date & Author..: darcy:2023/07/12 add
database ds
 
globals "../../config/top.global"

type tc_mae record
    tc_mae01        like tc_mae_file.tc_mae01,
    tc_mae02        like tc_mae_file.tc_mae02,
    tc_mae03        like tc_mae_file.tc_mae03,
    tc_mae04        like tc_mae_file.tc_mae04,
    tc_mae05        like tc_mae_file.tc_mae05,
    tc_mae06        like tc_mae_file.tc_mae06,
    tc_mae07        like tc_mae_file.tc_mae07,
    tc_mae08        like tc_mae_file.tc_mae08,
    tc_mae09        like tc_mae_file.tc_mae09,
    tc_mae10        like tc_mae_file.tc_mae10,
    tc_mae11        like tc_mae_file.tc_mae11,
    tc_mae12        like tc_mae_file.tc_mae12,
    tc_mae13        like tc_mae_file.tc_mae13,
    tc_mae14        like tc_mae_file.tc_mae14,
    tc_mae15        like tc_mae_file.tc_mae15,
    tc_mae16        like tc_mae_file.tc_mae16,
    tc_mae17        like tc_mae_file.tc_mae17,
    tc_mae18        like tc_mae_file.tc_mae18,
    tc_mae19        like tc_mae_file.tc_mae19,
    tc_mae20        like tc_mae_file.tc_mae20,
    tc_maemod       like tc_mae_file.tc_maemod,
    tc_maemodt      like tc_mae_file.tc_maemodt
    end record
define g_tc_mae,g_tc_mae_t,g_tc_mae_o tc_mae
define g_forupd_sql string
main
    options 
          input no wrap
    defer interrupt
    call cl_used(g_prog,g_time,1) returning g_time
    call p_email_config()
    call cl_used(g_prog,g_time,2) returning g_time
end main
function p_email_config()

    if (not cl_user()) THEN
        call cl_used(g_prog,g_time,2) returning g_time
    end if
    whenever error call cl_err_msg_log

    if (not cl_setup("azz")) then
       call cl_used(g_prog,g_time,2) returning g_time #no.fun-b30211
       exit program
    end if

    call  cl_used(g_prog,g_time,1) returning g_time  #no.chi-960043

    open window p_email_config_w at 4,31
      with form "azz/42f/p_email_config"
       attribute (style = g_win_style clipped)
    
    call cl_ui_init()

    call p_email_config_show()

    let g_action_choice = ""
    call p_email_config_menu()

    close window p_email_config_w
end function
function p_email_config_show()
    select 
        tc_mae01,tc_mae02,tc_mae03,tc_mae04,tc_mae05,
        tc_mae06,tc_mae07,tc_mae08,tc_mae09,tc_mae10,
        tc_mae11,tc_mae12,tc_mae13,tc_mae14,tc_mae15,
        tc_mae16,tc_mae17,tc_mae18,tc_mae19,tc_mae20,
        tc_maemod,tc_maemodt
     into 
        g_tc_mae.tc_mae01,g_tc_mae.tc_mae02,g_tc_mae.tc_mae03,g_tc_mae.tc_mae04,g_tc_mae.tc_mae05,
        g_tc_mae.tc_mae06,g_tc_mae.tc_mae07,g_tc_mae.tc_mae08,g_tc_mae.tc_mae09,g_tc_mae.tc_mae10,
        g_tc_mae.tc_mae11,g_tc_mae.tc_mae12,g_tc_mae.tc_mae13,g_tc_mae.tc_mae14,g_tc_mae.tc_mae15,
        g_tc_mae.tc_mae16,g_tc_mae.tc_mae17,g_tc_mae.tc_mae18,g_tc_mae.tc_mae19,g_tc_mae.tc_mae20,
        g_tc_mae.tc_maemod,g_tc_mae.tc_maemodt
     from tc_mae_file
    if sqlca.sqlcode then
        call cl_err("select tc_mae",sqlca.sqlcode,1)
        return
    end if
    display by name g_tc_mae.*
    CALL cl_show_fld_cont()
end function
function p_email_config_menu()
    menu ""
        on action modify
            let g_action_choice = "modify"
            if cl_chk_act_auth() then
                call p_email_config_u()
            end if
        on action help
            call cl_show_help()

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = "exit"
            exit menu

       on idle g_idle_seconds
             call cl_on_idle()

        on action about
            call cl_about()

        on action controlg
            call cl_cmdask()
            let g_action_choice = "exit"
           continue menu

        on action close
            let int_flag=false
            let g_action_choice = "exit"
            exit menu

    end menu
end function
function p_email_config_u()
    message ""
    call cl_opmsg("u")
    let g_forupd_sql = "select *  from tc_mae_file for update " 
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare tc_mae_curl cursor from g_forupd_sql

    begin work
    
    open tc_mae_curl
    if sqlca.sqlcode then
        call cl_err("open cursor",sqlca.sqlcode,1)
        return
    end if
    fetch tc_mae_curl into g_tc_mae.*
    if sqlca.sqlcode then
        call cl_err("",sqlca.sqlcode,1)
        return
    end if
    let g_tc_mae_t.* = g_tc_mae.*
    let g_tc_mae_o.* = g_tc_mae.*

    display by name g_tc_mae.*

    while true
        call p_email_config_i()
        if int_flag then
            let int_flag = 0
            call cl_err('',9001,0)
            rollback work
            exit while
        end if
        let g_tc_mae.tc_maemod = g_user
        let g_tc_mae.tc_maemodt = current year to second
        display by name g_tc_mae.tc_maemod,g_tc_mae.tc_maemodt
        update tc_mae_file set tc_mae_file.* = g_tc_mae.*
         where rownum = 1
        if sqlca.sqlcode then
            call cl_err("upd tc_mae_file",sqlca.sqlcode,1)
            continue while
        end if
        unlock table tc_mae_file
        exit while
    end while
    close tc_mae_curl
    commit work

end function

function p_email_config_i()
    define l_file string

    input by name g_tc_mae.* without defaults

        on action controlp
            let l_file = cl_server_file("/u1")
            case
                when infield(tc_mae01)
                    let g_tc_mae.tc_mae01 = l_file
                    display by name g_tc_mae.tc_mae01
                when infield(tc_mae02)
                    let g_tc_mae.tc_mae02 = l_file
                    display by name g_tc_mae.tc_mae02
                when infield(tc_mae03)
                    let g_tc_mae.tc_mae03 = l_file
                    display by name g_tc_mae.tc_mae03
                when infield(tc_mae04)
                    let g_tc_mae.tc_mae04 = l_file
                    display by name g_tc_mae.tc_mae04
                when infield(tc_mae05)
                    let g_tc_mae.tc_mae05 = l_file
                    display by name g_tc_mae.tc_mae05
            end case
        on action controlf
            call cl_set_focus_form(ui.interface.getrootnode()) returning g_fld_name,g_frm_name
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
