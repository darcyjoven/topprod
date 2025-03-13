# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cgos001.4gl
# Descriptions...: CGo模块参数设置
# Date & Author..: darcy:2024/04/15

database ds

globals "../../../tiptop/config/top.global"

define g_cga    record like cga_file.*
define g_cga_t  record like cga_file.*
define g_cga01_t like cga_file.cga01
define g_cga02_t like cga_file.cga02
define g_cga03_t like cga_file.cga03
define g_cga04_t like cga_file.cga04
define g_cga05_t like cga_file.cga05
define g_before_input_done like type_file.num5
define g_forupd_sql string

MAIN
    options
       input no wrap,
       field order form
    defer interrupt

    if (not cl_user()) then
        exit program
    end if

    whenever error call cl_err_msg_log

    if (not cl_setup("CGO")) then
        exit program
    end if

    call cl_used(g_prog,g_time,1) returning g_time

    open window cgos001_w with form "cgo/42f/cgos001"
      attribute (style = g_win_style clipped)
    call cl_ui_init()

    call cgos001_show()

    let g_action_choice=""
    call cgos001_menu()

    close window cgos001_w

    call cl_used(g_prog,g_time,2) returning g_time
END MAIN

function cgos001_menu() 

    menu ""
        on action modify
            let g_action_choice="modify"
            if cl_chk_act_auth() then
                call cgos001_u()
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

function cgos001_show()

    select * into g_cga.* from cga_file
    if sqlca.sqlcode or g_cga.cga01 is null then
        if sqlca.sqlcode=-284 then
            call cl_err3("sel","cga_file",g_cga.cga01,"",sqlca.sqlcode,"","error!",1)   #no.fun-660131
            delete from cga_file
        end if

        let g_cga.cga01 = '/usr/bin/go'
        let g_cga.cga02 = '/usr/bin/go'
        let g_cga.cga03 = '$CGO/code'
        let g_cga.cga04 = '$CGO/out'
        let g_cga.cga05 = '$CGO/backup'

        insert into cga_file values (g_cga.*)
        if sqlca.sqlcode then
           call cl_err3("ins","cga_file",g_cga.cga01,"",sqlca.sqlcode,"","i",0)   #no.fun-660131
           return
        end if
    end if

    display by name g_cga.*
    call cl_show_fld_cont()
    
end function

function cgos001_u()
    message ""
    let g_cga01_t = g_cga.cga01
    let g_cga02_t = g_cga.cga02
    let g_cga03_t = g_cga.cga03
    let g_cga04_t = g_cga.cga04
    let g_cga05_t = g_cga.cga05

    let g_forupd_sql = "SELECT * FROM cga_file FOR UPDATE"
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare cga_cl cursor from g_forupd_sql

    begin work
    open cga_cl
    if status then call cl_err('open cga_curl',status,1) return end if
    fetch cga_cl into g_cga.*
    if sqlca.sqlcode then
        call cl_err('',sqlca.sqlcode,0)
        return
    end if

    let g_cga_t.*=g_cga.*
    display by name g_cga.*

    while true
        call cgos001_i()
        if int_flag then
            call cgos001_show()
            let int_flag = 0
            call cl_err('',9001,0)
            exit while
        end if
        update cga_file
           set cga_file.*=g_cga.*
        if sqlca.sqlcode then
            call cl_err3("upd","cga_file",g_cga.cga01,"",sqlca.sqlcode,"","",0)
            continue while
        end if
        exit while
    end while
    close cga_cl
    commit work

end function
function cgos001_i()

    input by name g_cga.* without defaults
        before input
            let g_before_input_done = false
            let g_before_input_done = true
        
        on action controlf
            call cl_set_focus_form(ui.interface.getrootnode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlr
            call cl_show_req_fields()

        on action controlp
            case
                when infield(cga01)
                    call cl_server_file(g_cga.cga01) returning g_cga.cga01
                    if cl_null(g_cga.cga01) then
                        let g_cga.cga01 = g_cga01_t
                    end if
                when infield(cga02)
                    call cl_server_file(g_cga.cga02) returning g_cga.cga02
                    if cl_null(g_cga.cga02) then
                        let g_cga.cga02 = g_cga02_t
                    end if
                when infield(cga03)
                    call cl_server_file(g_cga.cga03) returning g_cga.cga03
                    if cl_null(g_cga.cga03) then
                        let g_cga.cga03 = g_cga03_t
                    end if
                when infield(cga04)
                    call cl_server_file(g_cga.cga04) returning g_cga.cga04
                    if cl_null(g_cga.cga04) then
                        let g_cga.cga04 = g_cga04_t
                    end if
                when infield(cga05)
                    call cl_server_file(g_cga.cga05) returning g_cga.cga05
                    if cl_null(g_cga.cga05) then
                        let g_cga.cga05 = g_cga05_t
                    end if
            end case
            display by name g_cga.*
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
