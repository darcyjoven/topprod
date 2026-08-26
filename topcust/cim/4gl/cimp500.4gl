# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cimp500.4gl
# Descriptions...: 每日进销存产值、达交计算
# Date & Author..: darcy 2026-07-20

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

define  g_date          date
define  g_version       varchar(20)
define  g_unsign        varchar(1)

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("CIM")) THEN
        EXIT PROGRAM
    END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time

    let g_bgjob = arg_val(1)
    let g_date = arg_val(2)
    let g_version = arg_val(3)

    call cimp500_menu()
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

function cimp500_menu()
    define l_flag   boolean
    while true
        --call cimp500()
        if g_bgjob = "Y" then
            let g_success = 'Y'
            begin work
            call cimp500_process()
            if g_success = "Y" then
                commit work
            else
                rollback work
            end if
            --call cl_batch_bg_javamail(g_success)
            exit while
        else
            call cimp500()
            if cl_sure(0,0) then
                let g_success = 'Y'
                call s_showmsg_init()
                --begin work
                call cimp500_process()
                if g_success = 'Y' then
                    --commit work
                    call cl_end2(1) returning l_flag
                else
                    --rollback work
                    call s_showmsg()
                    call cl_end2(2) returning l_flag
                end if

                if l_flag then
                    continue while
                else
                    exit while
                end if
            else
                continue while
            end if
            close window cimp500_w
        end if
    end while
end function

function cimp500()
    OPEN WINDOW cimp500_w AT 2,2 WITH FORM "cim/42f/cimp500"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

    call cl_ui_init()

    clear form

    let g_bgjob = 'N'
    let g_date = g_today
    let g_unsign = 'N'

    call cimp500_ask()

    if int_flag or g_action_choice = "exit" then
        let int_flag = false
        close window cimp500_w
        exit program
    end if
    if cl_null(g_date) then
        call cl_err('此作业必须录入条件','!',1)
        call cimp500()
    end if
end function

function cimp500_ask()
    input g_date,g_version,g_unsign without defaults from dat,version,unsign

        on action controlr
            call cl_show_req_fields()

        on action controlf
            -- 切换语言$#
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input
end function

function cimp500_process()
    call scimp500(g_date,g_version,g_unsign,true)
end function

-- 自动背景执行
-- function cimp500_report_background()
-- end function
