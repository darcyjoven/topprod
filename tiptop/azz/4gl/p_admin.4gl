# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: p_admin.4gl
# Descriptions...: 管理员工具
# Date & Author..: 22/11/03 By darcy
database ds
globals "../../config/top.global"
main
    define   p_row,p_col   like type_file.num5
    
    options                               #改變一些系統預設值
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
    open window p_admin at p_row,p_col with form "azz/42f/p_admin"
            attribute (style = g_win_style clipped)
    call cl_ui_init()

    call p_admin_menu()

    close window p_admin
    call  cl_used(g_prog,g_time,2) returning g_time

end main

function p_admin_menu()
    menu ""
        before menu
        on action admin_wo
            call cl_cmdrun_wait("p_admin_wo")
        on idle g_idle_seconds
            call cl_on_idle()
        on action about         #mod-4c0121
            call cl_about()
            let g_action_choice='exit'
            continue menu
        on action close   #command key(interrupt) #fun-9b0145  
            let int_flag=false          #mod-570244 mars
            let g_action_choice = "exit"
            exit menu
        &include "qry_string.4gl"
    end menu
end function
