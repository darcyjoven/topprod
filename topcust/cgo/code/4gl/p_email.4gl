# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_email.4gl
# Descriptions...: email 发送程序

database ds

globals "../../config/top.global"

type tc_maa record
    tc_maa01        like tc_maa_file.tc_maa01,
    tc_maa02        like tc_maa_file.tc_maa02,
    tc_maa03        like tc_maa_file.tc_maa03,
    tc_maa03_mail   like tc_maa_file.tc_maa03_mail,
    tc_maa03_tel    like tc_maa_file.tc_maa03_tel,
    tc_maa04        like tc_maa_file.tc_maa04,
    tc_maa04_mail   like tc_maa_file.tc_maa04_mail,
    tc_maa04_tel    like tc_maa_file.tc_maa04_tel,
    tc_maa05        like tc_maa_file.tc_maa05,
    tc_maa06        like tc_maa_file.tc_maa06,
    tc_maa07        like tc_maa_file.tc_maa07,
    tc_maa08        like tc_maa_file.tc_maa08,
    tc_maa09        like tc_maa_file.tc_maa09,
    tc_maa10        like tc_maa_file.tc_maa10,
    tc_maa11        like tc_maa_file.tc_maa11,
    tc_maa12        like tc_maa_file.tc_maa12,
    tc_maa13        like tc_maa_file.tc_maa13,
    tc_maa14        like tc_maa_file.tc_maa14,
    tc_maa15        like tc_maa_file.tc_maa15,
    tc_maa16        like tc_maa_file.tc_maa16,
    tc_maa17        like tc_maa_file.tc_maa17,
    tc_maa18        like tc_maa_file.tc_maa18,
    tc_maa19        like tc_maa_file.tc_maa19,
    tc_maa20        like tc_maa_file.tc_maa20,
    tc_maa21        like tc_maa_file.tc_maa21,
    tc_maa22        like tc_maa_file.tc_maa22,
    tc_maa23        like tc_maa_file.tc_maa23,
    tc_maauser      like tc_maa_file.tc_maauser,
    tc_maacrtt      like tc_maa_file.tc_maacrtt,
    tc_maamod       like tc_maa_file.tc_maamod,
    tc_maamodt      like tc_maa_file.tc_maamodt,
    tc_maaacti      like tc_maa_file.tc_maaacti,
    tc_maa24        like tc_maa_file.tc_maa24,
    tc_maa25        like tc_maa_file.tc_maa25
end record

type tc_maa_d record
    tc_maa01_d      like tc_maa_file.tc_maa01,
    tc_maa02_d      like tc_maa_file.tc_maa02,
    tc_maa03_d      like tc_maa_file.tc_maa03,
    tc_maa04_d      like tc_maa_file.tc_maa04,
    tc_maa08_d      like tc_maa_file.tc_maa08,
    tc_maa12_d      like tc_maa_file.tc_maa12,
    tc_maa13_d      like tc_maa_file.tc_maa13,
    tc_maa16_d      like tc_maa_file.tc_maa16,
    tc_maa22_d      like tc_maa_file.tc_maa22,
    tc_maa23_d      like tc_maa_file.tc_maa23,
    tc_maamod_d     like tc_maa_file.tc_maamod,
    tc_maamodt_d    like tc_maa_file.tc_maamodt
end record

define g_tc_maa,g_tc_maa_t,g_tc_maa_o tc_maa
define g_tc_maa_d dynamic array of tc_maa_d
define g_tc_maa01_t   like tc_maa_file.tc_maa01
define g_bp_flag,g_argv1,g_wc,g_forupd_sql,g_sql,g_msg   string
define g_curs_index,g_row_count,g_rec_b1,l_ac1,g_jump integer
define mi_no_ask,g_before_input_done boolean
define g_mailwarn,g_cronwarn,g_attachwarn,g_peparewarn string

MAIN
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

    let g_forupd_sql = "select * from tc_maa_file where tc_maa01 = ? for update"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare p_email_cl cursor from g_forupd_sql

    open window p_email_w with form "azz/42f/p_email"
     attribute (style = g_win_style clipped)
    
    call cl_ui_init()
    call p_email_init()

    let g_argv1 = arg_val(1)

    if cl_null(g_argv1) then
        let g_argv1 = " 1=1"
    end if
    call p_email_q()

    call p_email_menu()

    close window p_email_w

    call cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

# 查询
function p_email_curs()
    clear form
    if cl_null(g_argv1) then
        initialize g_tc_maa.* to null
        construct by name g_wc 
            on tc_maa01,tc_maa02,tc_maa03,tc_maa03_mail,tc_maa03_tel,tc_maa04,tc_maa04_mail,tc_maa04_tel,
               tc_maa06,tc_maa07.tc_maa08,tc_maa09,tc_maa10,tc_maa11,tc_maauser,tc_maamod,tc_maacrtt,tc_maamodt,tc_maaacti,
               tc_maa13,tc_maa14,tc_maa15,tc_maa16,tc_maa17,tc_maa18,tc_maa19,tc_maa20,tc_maa21,tc_maa22,tc_maa23,tc_maa24

            before construct
                call cl_qbe_init()

            on action controlp
                case
                    when infield(tc_maa01)
                    when infield(tc_maa03)
                    when infield(tc_maa04)
                    when infield(tc_maa06)
                    when infield(tc_maa09)
                    when infield(tc_maa16)
                    when infield(tc_maa17)
                    when infield(tc_maa18)
                end case
            on idle g_idle_seconds
                call cl_on_idle()
                continue construct
 
            on action about
                call cl_about()
 
            on action help
                call cl_show_help()
 
            on action controlg
                call cl_cmdask()
 
            on action qbe_select
                call cl_qbe_select()
                on action qbe_save
                call cl_qbe_save()
        end construct
    else
        let g_wc = g_argv1
    end if
    if int_flag then
        return
    end if
    call p_email_declare_curs()
end function

# 定义cursor
# 1. 查询当前行 2.总笔数
function p_email_declare_curs()
    let g_sql = "select tc_maa01 from tc_maa_file ",
                " where ",g_wc CLIPPED,
                " order by tc_maa01"
    prepare p_email_prepare from g_sql
    declare p_email_curs scroll cursor with hold for p_email_prepare

    let g_sql = "select count(*) from (",g_sql,")"
    prepare p_email_precount from g_sql
    declare p_email_count cursor for p_email_precount
end function
# 作业初始化函数
function p_email_init()
    let g_mailwarn = "recipient,cc,bcc should like darcy@darcy.com;darcy@go.com;"
    let g_cronwarn = "use the linux crontab format type,like minute hour day month week"
    let g_attachwarn = "you can add a attach by p_mail or related document "
    let g_peparewarn = "the following procedures will execute at first,multiple procedures should like pr1;pr2;"
    call cl_set_combo_items("tc_maa24","xlsx","xlsx.excel文档")
end function

# 菜单入口
function p_email_menu()

    menu ""
        before menu
        # 切换page
        on action item_list
            let g_action_choice = ""
            call p_email_b_menu()
            if g_action_choice = "exit" then
                exit menu
            end if
            let g_action_choice = ""
        # 新增
        on action insert
            let g_action_choice = "insert"
            if cl_chk_act_auth() then
                call p_email_a()
            end if
        # 查询
        on action query
            let g_action_choice = "query"
            let g_wc = null
            let g_argv1 = null
            if cl_chk_act_auth() then
                call p_email_q()
            end if
        # 删除
        on action delete
            let g_action_choice = "delete"
            if cl_chk_act_auth() then
                call p_email_r()
            end if
        # 修改
        on action modify
            let g_action_choice = "modify"
            if cl_chk_act_auth() then
                call p_email_u()
            end if
        # 第一笔
        on action first
            call p_email_fetch('F')
            call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            if g_rec_b1 != 0 then                   #no.fun-7c0010
                call fgl_set_arr_curr(g_curs_index)  #no.fun-7c0010
            end if
        # 上一笔
        on action previous
            call p_email_fetch('P')
            call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            if g_rec_b1 != 0 then                   #no.fun-7c0010
                call fgl_set_arr_curr(g_curs_index)  #no.fun-7c0010
            end if
        # 调转到第n笔
        on action jump
            call p_email_fetch('/')
            call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            if g_rec_b1 != 0 then                   #no.fun-7c0010
                call fgl_set_arr_curr(g_curs_index)  #no.fun-7c0010
            end if
        # 下一笔
        on action next
            call p_email_fetch('N')
            call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            if g_rec_b1 != 0 then                   #no.fun-7c0010
                call fgl_set_arr_curr(g_curs_index)  #no.fun-7c0010
            end if
        # 最后一笔
        on action last
            call p_email_fetch('L')
            call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            if g_rec_b1 != 0 then                   #no.fun-7c0010
                call fgl_set_arr_curr(g_curs_index)  #no.fun-7c0010
            end if
        # 语言切换
        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
        # 无效
        on action invalid
            let g_action_choice = "invalid"
            if cl_chk_act_auth() then
                call p_email_x(g_tc_maa.tc_maa01)
                call p_email_show()
            end if
        # 复制
        on action reproduce
            let g_action_choice = "reproduce"
            if cl_chk_act_auth() then
                call p_email_copy()
                call p_email_show()
            end if
        # 汇出excel
        on action exporttoexcel
            let g_action_choice="exporttoexcel"
            if cl_chk_act_auth() then
                # call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_ima_l),'','')
            end if
        # 打印
        on action output
            let g_action_choice = "output"
            if cl_chk_act_auth() then
            end if
        # 帮助文档
        on action help
            call cl_show_help()
        # 退出
        on action exit
            let g_action_choice='exit'
            exit menu
        # 打开其它作业
        on action controlg
            call cl_cmdask()
        # 相关文件
        on action related_document
            let g_action_choice="related_document"
            if cl_chk_act_auth() then
                if g_tc_maa.tc_maa01 is not null then
                    let g_doc.column1 = "tc_maa01"
                    let g_doc.value1 = g_tc_maa.tc_maa01
                call cl_doc()
                end if
            end if
        # 关于
        on action about
            call cl_about()
            let g_action_choice='exit'
            continue menu
        # 关闭
        on action close
            let int_flag=false
            let g_action_choice = "exit"
            exit menu
        # p_email action s---
        # 测试发送
        on action emailtest
            let g_action_choice = "emailtest"
            if cl_chk_act_auth() then
                call p_email_emailtest()
            end if
        # 产生背景执行
        on action crontab
            let g_action_choice = "crontab"
            if cl_chk_act_auth() then
                if p_email_crontab() then end if
            end if
        # 取消背景执行
        on action undo_crontab
            let g_action_choice = "undo_crontab"
            if cl_chk_act_auth() then
                if p_email_undo_crontab() then
                end if
            end if
        # 依据模板设置邮件正文
        on action template
            let g_action_choice = "template"
            if cl_chk_act_auth() then
                call p_email_template()
            end if
        # 打开配置文件
        on action config
            let g_action_choice = "config"
            if cl_chk_act_auth() then
                call cl_cmdrun_wait("p_email_config")
            end if
        # p_email action e---
        &include "qry_string.4gl"

    end menu
    close p_email_curs
end function
# 资料清单菜单
# 和双档菜单类似，action比较少
function p_email_b_menu()
    while true
        call p_email_bp("G")

        # 将清单资料显示到主画面
        if not cl_null(g_action_choice) and l_ac1>0 then
            let g_tc_maa.tc_maa01 = g_tc_maa01_t
            call p_email_show()
        end if

        if g_action_choice!= "" then
            let g_bp_flag = 'main'
            let l_ac1 = arr_curr()
            let g_jump = l_ac1
            let mi_no_ask = true
            if g_rec_b1 >0 then
                call p_email_fetch('/')
            end if
            call cl_set_comp_visible("page02", false)
            call ui.interface.refresh()
            call cl_set_comp_visible("page02", true)
        end if

        case g_action_choice
            when "insert"
                if cl_chk_act_auth() then
                    call p_email_a()
                end if
                exit while
            when "query"
                if cl_chk_act_auth() then
                    let g_wc = null
                    let g_argv1 = null
                    call p_email_q()
                end if
                exit while
            when "delete"
                if cl_chk_act_auth() then
                    call p_email_r()
                end if
                exit while
            when "modify"
                if cl_chk_act_auth() then
                    call p_email_u()
                end if
                exit while
            when "invalid"
                if cl_chk_act_auth() then
                    call p_email_x(g_tc_maa.tc_maa01)
                    call p_email_show()
                end if
                exit while
            when "reproduce"
                if cl_chk_act_auth() then
                    call p_email_copy()
                    call p_email_show()
                end if
                exit while
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    # call p_email_x()
                end if
            when "output"
                if cl_chk_act_auth() then
                    # call p_email_x()
                end if
            when "related_document"
                if cl_chk_act_auth() then
                    if g_tc_maa.tc_maa01 is not null then
                        let g_doc.column1 = "tc_maa01"
                        let g_doc.value1 = g_tc_maa.tc_maa01
                        call cl_doc()
                    end if
                end if
            when "help"
                call cl_show_help()
            when "controlg"
                call cl_cmdask()
            when "locale"
                call cl_dynamic_locale()
                call cl_show_fld_cont()
            when "exit"
                exit while
            when "g_idle_seconds"
                call cl_on_idle()
            when "about"      
                call cl_about()
            # p_email action s---
            # 测试发送
            when "emailtest"
                if cl_chk_act_auth() then
                    call p_email_emailtest()
                end if
            # 产生背景执行
            when "crontab"
                if cl_chk_act_auth() then
                    if p_email_crontab() then end if
                end if
            # 取消背景执行
            when "undo_crontab"
                if cl_chk_act_auth() then
                    if  p_email_undo_crontab() then
                    end if
                end if
            # 依据模板设置邮件正文
            when "template"
                if cl_chk_act_auth() then
                    call p_email_template()
                end if
            # 打开配置文件
            when "config"
                if cl_chk_act_auth() then
                    call cl_cmdrun_wait("p_email_config")
                end if
            # p_email action e---
            otherwise 
                exit while
        end case
    end while
end function
# 查询
function p_email_q()
    let g_row_count = 0
    let g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    message ""
    call cl_opmsg("q")
    display ' ' to formonly.cnt
    call p_email_curs()
    if int_flag then
        let int_flag = false
        initialize g_tc_maa.* to null
        initialize g_tc_maa_t.* to null
        initialize g_tc_maa_o.* to null
        let g_tc_maa01_t = null
        clear form
        return
    end if
    message "Searching!"
    open p_email_count
    fetch p_email_count into g_row_count
    display g_row_count to formonly.cnt
    open p_email_curs
    if sqlca.sqlcode then
        call cl_err(g_tc_maa.tc_maa01,sqlca.sqlcode,0)
        initialize g_tc_maa.* to null
    else
        call p_email_fetch('F')
        call p_email_list_fill()
        let g_bp_flag = 'list'
    end if
    message ""
end function

# 跳转到第几笔函数
function p_email_fetch(p_flima)
    define p_flima      varchar(1)

    case p_flima
        when 'N' fetch next  p_email_curs into g_tc_maa.tc_maa01
        when 'P' fetch first p_email_curs into g_tc_maa.tc_maa01
        when 'F' fetch first p_email_curs into g_tc_maa.tc_maa01
        when 'L' fetch last  p_email_curs into g_tc_maa.tc_maa01
        when '/'
            if not mi_no_ask then
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
            end if
            fetch absolute g_jump p_email_curs into g_tc_maa.tc_maa01
            let mi_no_ask = false
    end case
    if sqlca.sqlcode then
        call cl_err(g_tc_maa.tc_maa01,sqlca.sqlcode,1)
        initialize g_tc_maa.* to null
        return
    end if
    case p_flima
        when 'F' let g_curs_index = 1
        when 'P' let g_curs_index = g_curs_index - 1
        when 'N' let g_curs_index = g_curs_index + 1
        when 'L' let g_curs_index = g_row_count
        when '/' let g_curs_index = g_jump
    end case
    call cl_navigator_setting(g_curs_index, g_row_count)
    
    call p_email_show()

end function

# 明细资料查询
function p_email_list_fill()
    define l_i integer
    define l_tc_maa01       varchar(20)
    let g_sql = "select tc_maa01,tc_maa02,tc_maa03,tc_maa04,tc_maa08,tc_maa12,",
                " tc_maa13,tc_maa16,tc_maa23,tc_maa22,tc_maamod,tc_maamodt",
                " from tc_maa_file where ",g_wc clipped," order by tc_maa01"
    declare p_email_list_cur cursor from g_sql

    call g_tc_maa_d.clear()
    let l_i = 1
    foreach p_email_list_cur into g_tc_maa_d[l_i].*
        if sqlca.sqlcode then
            call cl_err("p_email_list_cur",sqlca.sqlcode,1)
            continue foreach
        end if
        let l_i = l_i + 1
        if l_i > g_max_rec then
            if g_action_choice = "query" then
                call cl_err('',9035,0)
            end if
            exit foreach
        end if
    end foreach
    call g_tc_maa_d.deleteElement(l_i)
    let g_rec_b1 = l_i - 1
    display array g_tc_maa_d to s_tc_maa_d.* attribute(COUNT=g_rec_b1,unbuffered)
        before display
            exit display
    end display
end function

# 显示单头资料
function p_email_show()
    select tc_maa01,tc_maa02,tc_maa03,tc_maa03_mail,tc_maa03_tel,
           tc_maa04,tc_maa04_mail,tc_maa04_tel,tc_maa05,tc_maa06,
           tc_maa07,tc_maa08,tc_maa09,tc_maa10,tc_maa11,tc_maa12,
           tc_maa13,tc_maa14,tc_maa15,tc_maa16,tc_maa17,tc_maa18,
           tc_maa19,tc_maa20,tc_maa21,tc_maa22,tc_maa23,tc_maauser,
           tc_maacrtt,tc_maamod,tc_maamodt,tc_maaacti,tc_maa24
      into g_tc_maa.tc_maa01,g_tc_maa.tc_maa02,g_tc_maa.tc_maa03,g_tc_maa.tc_maa03_mail,g_tc_maa.tc_maa03_tel,
           g_tc_maa.tc_maa04,g_tc_maa.tc_maa04_mail,g_tc_maa.tc_maa04_tel,g_tc_maa.tc_maa05,g_tc_maa.tc_maa06,
           g_tc_maa.tc_maa07,g_tc_maa.tc_maa08,g_tc_maa.tc_maa09,g_tc_maa.tc_maa10,g_tc_maa.tc_maa11,g_tc_maa.tc_maa12,
           g_tc_maa.tc_maa13,g_tc_maa.tc_maa14,g_tc_maa.tc_maa15,g_tc_maa.tc_maa16,g_tc_maa.tc_maa17,g_tc_maa.tc_maa18,
           g_tc_maa.tc_maa19,g_tc_maa.tc_maa20,g_tc_maa.tc_maa21,g_tc_maa.tc_maa22,g_tc_maa.tc_maa23,g_tc_maa.tc_maauser,
           g_tc_maa.tc_maacrtt,g_tc_maa.tc_maamod,g_tc_maa.tc_maamodt,g_tc_maa.tc_maaacti,g_tc_maa.tc_maa24
      from tc_maa_file where tc_maa01 = g_tc_maa.tc_maa01
    let g_tc_maa_t.* = g_tc_maa.*
    let g_tc_maa01_t = g_tc_maa.tc_maa01
    let g_doc.column1 = "tc_maa01"
    let g_doc.value1 = g_tc_maa.tc_maa01
    display by name g_tc_maa.*
    display g_mailwarn,g_cronwarn,g_attachwarn,g_peparewarn to mailwarn,cronwarn,attachwarn,peparewarn
end function

# 新增
function p_email_a()
    let g_wc = null
    if s_shut(0) then return end if
    message ""

    clear form
    initialize g_tc_maa.* to null
    let g_tc_maa01_t = null
    let g_tc_maa_o.* = g_tc_maa.*
    call p_email_default()
    call cl_opmsg('a')

    while true
        initialize g_tc_maa_o.* to null
        call p_email_i("a")

        if int_flag then
            initialize g_tc_maa.* to null
            let int_flag = 0
            call cl_err('',9001,0)
            clear form
            exit while
        end if

        if g_tc_maa.tc_maa01 is null then
            continue while
        end if

        begin work
        if not p_email_a_ins() then
            rollback work
            continue while
        else
            commit work
        end if
        exit while
    end while
end function

# 录入
function p_email_i(p_cmd)
    define p_cmd varchar(2)
    display by name g_tc_maa.*

    display g_mailwarn,g_cronwarn,g_attachwarn,g_peparewarn to mailwarn,cronwarn,attachwarn,peparewarn

    input by name g_tc_maa.* without defaults
        before input
            let g_before_input_done = false
            call p_email_set_entry()
            call p_email_set_no_entry()
            let g_before_input_done = true
        
        on change tc_maa07
            call p_email_set_entry()
            call p_email_set_no_entry()
        on change tc_maa10
            call p_email_set_entry()
            call p_email_set_no_entry()

        
        after input
            case p_email_input_chk()
                when "tc_maa05" next field tc_maa05
                when "tc_maa06" next field tc_maa06
                when "tc_maa08" next field tc_maa08
                when "tc_maa09" next field tc_maa09
                when "tc_maa11" next field tc_maa11
                when "tc_maa13" next field tc_maa13
                when "tc_maa16" next field tc_maa16
                when "tc_maa22" next field tc_maa22
            end case
        on action controlp
            case
                when infield(tc_maa03)
                    call cl_init_qry_var()
                    let g_qryparam.state = "i"
                    let g_qryparam.form = "q_gen08"
                    call cl_create_qry() RETURNING g_tc_maa.tc_maa03,g_tc_maa.tc_maa03_mail,g_tc_maa.tc_maa03_tel
                    display g_tc_maa.tc_maa03,g_tc_maa.tc_maa03_mail,g_tc_maa.tc_maa03_tel TO tc_maa03,tc_maa03_mail,tc_maa03_tel
                    next field tc_maa03

                when infield(tc_maa04)
                    call cl_init_qry_var()
                    let g_qryparam.state = "i"
                    let g_qryparam.form = "q_gen08"
                    call cl_create_qry() RETURNING g_tc_maa.tc_maa04,g_tc_maa.tc_maa04_mail,g_tc_maa.tc_maa04_tel
                    display g_tc_maa.tc_maa04,g_tc_maa.tc_maa04_mail,g_tc_maa.tc_maa04_tel TO tc_maa04,tc_maa04_mail,tc_maa04_tel
                    next field tc_maa04

                when infield(tc_maa06)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = "cq_proce"
                    call cl_create_qry() RETURNING g_qryparam.multiret
                    let g_tc_maa.tc_maa06 = cl_replace_str(g_qryparam.multiret,"|",";")
                    display g_tc_maa.tc_maa06 TO tc_maa06
                    next field tc_maa06

                when infield(tc_maa09)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = "p_zai01"
                    let g_qryparam.arg1 = g_lang CLIPPED
                    call cl_create_qry() RETURNING g_qryparam.multiret
                    let g_tc_maa.tc_maa09 = cl_replace_str(g_qryparam.multiret,"|",";")
                    display g_tc_maa.tc_maa09 TO tc_maa09
                    next field tc_maa09

                when infield(tc_maa16)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = "q_gen06"
                    let g_qryparam.arg1 = g_lang CLIPPED
                    call cl_create_qry() RETURNING g_qryparam.multiret
                    let g_tc_maa.tc_maa16 = cl_replace_str(g_qryparam.multiret,"|",";")
                    display g_tc_maa.tc_maa16 TO tc_maa16
                    next field tc_maa16

                when infield(tc_maa17)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = "q_gen06"
                    let g_qryparam.arg1 = g_lang CLIPPED
                    call cl_create_qry() RETURNING g_qryparam.multiret
                    let g_tc_maa.tc_maa17 = cl_replace_str(g_qryparam.multiret,"|",";")
                    display g_tc_maa.tc_maa17 TO tc_maa17
                    next field tc_maa17

                when infield(tc_maa18)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = "q_gen06"
                    let g_qryparam.arg1 = g_lang CLIPPED
                    call cl_create_qry() RETURNING g_qryparam.multiret
                    let g_tc_maa.tc_maa18 = cl_replace_str(g_qryparam.multiret,"|",";")
                    display g_tc_maa.tc_maa18 TO tc_maa18
                    next field tc_maa18
            end case

        on action controlr
            call cl_show_req_fields()

        on action controlg
            call cl_cmdask()

        on action controlf
            call cl_set_focus_form(ui.interface.getrootnode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on idle g_idle_seconds
            call cl_on_idle()
            continue input

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input
    if int_flag then
        rollback work
        return
    else
        commit work
    end if
end function

# insert
function p_email_a_ins()

    begin work

    insert into tc_maa_file (
        tc_maa01,tc_maa02,tc_maa03,tc_maa03_mail,tc_maa03_tel,
        tc_maa04,tc_maa04_mail,tc_maa04_tel,tc_maa05,tc_maa06,
        tc_maa07,tc_maa08,tc_maa09,tc_maa10,tc_maa11,tc_maa12,
        tc_maa13,tc_maa14,tc_maa15,tc_maa16,tc_maa17,tc_maa18,
        tc_maa19,tc_maa20,tc_maa21,tc_maa22,tc_maa23,tc_maauser,
        tc_maacrtt,tc_maamod,tc_maamodt,tc_maaacti,tc_maa24
    )values(
        g_tc_maa.tc_maa01,g_tc_maa.tc_maa02,g_tc_maa.tc_maa03,g_tc_maa.tc_maa03_mail,g_tc_maa.tc_maa03_tel,
        g_tc_maa.tc_maa04,g_tc_maa.tc_maa04_mail,g_tc_maa.tc_maa04_tel,g_tc_maa.tc_maa05,g_tc_maa.tc_maa06,
        g_tc_maa.tc_maa07,g_tc_maa.tc_maa08,g_tc_maa.tc_maa09,g_tc_maa.tc_maa10,g_tc_maa.tc_maa11,g_tc_maa.tc_maa12,
        g_tc_maa.tc_maa13,g_tc_maa.tc_maa14,g_tc_maa.tc_maa15,g_tc_maa.tc_maa16,g_tc_maa.tc_maa17,g_tc_maa.tc_maa18,
        g_tc_maa.tc_maa19,g_tc_maa.tc_maa20,g_tc_maa.tc_maa21,g_tc_maa.tc_maa22,g_tc_maa.tc_maa23,g_tc_maa.tc_maauser,
        g_tc_maa.tc_maacrtt,g_tc_maa.tc_maamod,g_tc_maa.tc_maamodt,g_tc_maa.tc_maaacti,g_tc_maa.tc_maa24
    )
    if sqlca.sqlcode then
        call cl_err3("ins","tc_maa_file",g_tc_maa.tc_maa01,"",sqlca.sqlcode,"","",1)
        rollback work
        return false
    else
        insert into tc_mab_file(
            tc_mab01,tc_mabmod,tc_mabmodt
        )values(
            g_tc_maa.tc_maa01,g_tc_maa.tc_maauser,g_tc_maa.tc_maacrtt
        )
        if sqlca.sqlcode then
            call cl_err("ins tc_mab_file",sqlca.sqlcode,1)
            rollback work
            return false
        else
            commit work
            let g_tc_maa_t.* = g_tc_maa.*
            let g_tc_maa01_t = g_tc_maa.tc_maa01
        end if
    end if

    return true
end function

# 修改
function p_email_u()

    if s_shut(0) then return end if
    if g_tc_maa.tc_maa01 is null then
        call cl_err("",-400,0)
    end if
    call p_email_show()
    if g_tc_maa.tc_maaacti = "N" then
        call cl_err(g_tc_maa.tc_maa01,"mfg1000",0)
        return
    end if
    message ""
    call cl_opmsg("u")
    let g_tc_maa01_t = g_tc_maa.tc_maa01
    let g_tc_maa_o.* = g_tc_maa.*
    let g_tc_maa_t.* = g_tc_maa.*
    if g_action_choice != "reproduce" then
        begin work
    end if
    while true
        call p_email_i("u")
        if int_flag then
            let int_flag = 0
            let g_tc_maa.* = g_tc_maa_t.*
            call p_email_show()
            call cl_err('',9001,0)
            rollback work
            exit while
        end if
        let g_tc_maa.tc_maamod = g_user
        let g_tc_maa.tc_maamodt = current year to second
        display by name g_tc_maa.tc_maamod,g_tc_maa.tc_maamodt
        update tc_maa_file
           set tc_maa02 = g_tc_maa.tc_maa02,
               tc_maa03 = g_tc_maa.tc_maa03,
               tc_maa03_mail = g_tc_maa.tc_maa03_mail,
               tc_maa03_tel = g_tc_maa.tc_maa03_tel,
               tc_maa04 = g_tc_maa.tc_maa04,
               tc_maa04_mail = g_tc_maa.tc_maa04_mail,
               tc_maa04_tel = g_tc_maa.tc_maa04_tel,
               tc_maa05 = g_tc_maa.tc_maa05,
               tc_maa06 = g_tc_maa.tc_maa06,
               tc_maa07 = g_tc_maa.tc_maa07,
               tc_maa08 = g_tc_maa.tc_maa08,
               tc_maa09 = g_tc_maa.tc_maa09,
               tc_maa10 = g_tc_maa.tc_maa10,
               tc_maa11 = g_tc_maa.tc_maa11,
               tc_maa12 = g_tc_maa.tc_maa12,
               tc_maa13 = g_tc_maa.tc_maa13,
               tc_maa14 = g_tc_maa.tc_maa14,
               tc_maa15 = g_tc_maa.tc_maa15,
               tc_maa16 = g_tc_maa.tc_maa16,
               tc_maa17 = g_tc_maa.tc_maa17,
               tc_maa18 = g_tc_maa.tc_maa18,
               tc_maa19 = g_tc_maa.tc_maa19,
               tc_maa20 = g_tc_maa.tc_maa20,
               tc_maa21 = g_tc_maa.tc_maa21,
               tc_maa22 = g_tc_maa.tc_maa22,
               tc_maa23 = g_tc_maa.tc_maa23,
               tc_maamod = g_tc_maa.tc_maamod,
               tc_maamodt = g_tc_maa.tc_maamodt,
               tc_maaacti = g_tc_maa.tc_maaacti,
               tc_maa24 = g_tc_maa.tc_maa24
         where tc_maa01 = g_tc_maa.tc_maa01
        if sqlca.sqlcode then
            call cl_err("upd tc_maa_file",sqlca.sqlcode,1)
            rollback work
            continue while
        else
            call p_email_list_fill()
            commit work
        end if
        exit while
    end while
    close p_email_cl
end function

# 删除
function p_email_r()
    if s_shut(0) then return false end if
    if g_tc_maa.tc_maa01 is null then
        call cl_err('',-400,0)
        return false
    end if
    call p_email_show()
    if g_tc_maa.tc_maaacti = 'N' then
        #此筆資料已無效, 不可異動
        call cl_err(g_tc_maa.tc_maa01,'aim-153',1)
        return false
    end if

    begin work

        delete from tc_maa_file where tc_maa01=g_tc_maa.tc_maa01
        if sqlca.sqlcode then
            call cl_err("del tc_maa_file",sqlca.sqlcode,1)
            goto roll
        end if
        delete from tc_mab_file where tc_mab01=g_tc_maa.tc_maa01
        if sqlca.sqlcode then
            call cl_err("del tc_maa_file",sqlca.sqlcode,1)
            goto roll
        end if
        delete from tc_mac_file where tc_mac01=g_tc_maa.tc_maa01
        if sqlca.sqlcode then
            call cl_err("del tc_mac_file",sqlca.sqlcode,1)
            goto roll
        end if
        delete from tc_mad_file where tc_mad01=g_tc_maa.tc_maa01
        if sqlca.sqlcode then
            call cl_err("del tc_mad_file",sqlca.sqlcode,1)
            goto roll
        end if

        #darcy:2023/07/13 add s---
        # 删除先drop cron
        if not p_email_undo_crontab() then
            call cl_err("drop crontab err","!",1)
            goto roll
        end if
        #darcy:2023/07/13 add e---
    commit work
    return

    label roll:
    rollback work
    return
end function

# 无效
function p_email_x(p_tc_maa01)
    define p_tc_maa01 varchar(20)

    call p_email_show()
    if g_tc_maa.tc_maaacti = 'Y' then
        if not p_email_undo_crontab() then
            return
        end if
    end if
    let g_tc_maa.tc_maaacti = iif(g_tc_maa.tc_maaacti = 'Y','N','Y')
    begin work #darcy:2023/07/13 add 
    update tc_maa_file set tc_maaacti = g_tc_maa.tc_maaacti
     where tc_maa01 = g_tc_maa.tc_maa01
    if sqlca.sqlcode then
        call cl_err("upd tc_maa_file",sqlca.sqlcode,1)
        return
    end if
    #darcy:2023/07/13 add s---
    # 作废时先drop crontab
    if g_tc_maa.tc_maaacti = 'N' then
        if not p_email_undo_crontab() then
            rollback work
            return
        end if
    end if
    commit work
    #darcy:2023/07/13 add e---
    call p_email_show()
end function

# 复制
function p_email_copy()
    define l_newno integer

    select max(tc_maa01)+1 into l_newno from tc_maa_file
    if cl_null(l_newno) then let l_newno = 1 end if

    drop table x
    select * from tc_maa_file where tc_maa01 = g_tc_maa.tc_maaacti
      into temp x
    update x set tc_maa01 = l_newno
    insert into tc_maa_file select * from x
    if sqlca.sqlcode then
        call cl_err("ins tc_maa",sqlca.sqlcode,1)
        return
    end if

    select * from tc_mab_file where tc_mab01 = g_tc_maa.tc_maaacti
      into temp x
    update x set tc_mab01 = l_newno
    insert into tc_mab_file select * from x

    if sqlca.sqlcode then
        call cl_err("ins tc_mab",sqlca.sqlcode,1)
        delete from tc_maa_file where tc_maa01 = l_newno
        return
    end if

end function

# 邮件测试
function p_email_emailtest()
    define l_cmd    string
    define result like type_file.num5

    let l_cmd = p_email_get_cmd()
    call runBatch(l_cmd,true) returning result

    if result = 0 then
        message "邮件发送成功" attribute(blink)
    else
        message "邮件发送失败，错误代码"||result attribute(blink,bold,red)
    end if

end function

# 建立背景执行
function p_email_crontab()
    define l_cmd    string

    call p_email_show()
    if g_tc_maa.tc_maaacti = 'N' then
        call cl_err(g_tc_maa.tc_maa01,'aim-153',1)
        return false
    end if
    if g_tc_maa.tc_maa10 = 'Y' then
        if not cl_confirm('czz-014') then
            return false
        end if
    end if

    begin work
    let g_success = 'Y'
    
    if not cl_null(g_tc_maa.tc_maa12)then
        call cl_err(g_tc_maa.tc_maa12,"czz-015",1)
        let g_success = 'N'
        goto err_do
    end if
    let l_cmd = p_email_get_cmd()
    if cl_null(g_tc_maa.tc_maa11) then
        call cl_err(g_tc_maa.tc_maa11,"czz-016",1)
        let g_success = 'N'
        goto err_do
    end if
    let l_cmd = g_tc_maa.tc_maa11 clipped," ",l_cmd

    let g_tc_maa.tc_maa12 = l_cmd
    update tc_maa_file set tc_maa10='Y',tc_maa12 = g_tc_maa.tc_maa12
     where tc_maa01 = g_tc_maa.tc_maa01
    if sqlca.sqlcode then
        call cl_err("upd tc_maa_file",sqlca.sqlcode,1)
        let g_success = 'N'
        goto err_do
    end if
    # 新建 cron
    if cs_darcy_cron(l_cmd,true) then
        message "建立成功" attribute(blink,bold)
    else
        message "建立失败" attribute(blink,bold,red)
        let g_success = 'N'
    end if

    label err_do:
    if g_success = 'Y' then
        commit work
    else
        rollback work
        return false
    end if
    call p_email_show()
    return true
end function

# 取消背景执行
function p_email_undo_crontab()
    define l_cmd    string

    call p_email_show()
    if g_tc_maa.tc_maaacti = 'N' then
        call cl_err(g_tc_maa.tc_maa01,'aim-153',1)
        return false
    end if
    if g_tc_maa.tc_maa10 = 'N' then
        if not cl_confirm('czz-013') then
            return true
        end if
    end if

    begin work
    update tc_maa_file set tc_maa10 = 'N',tc_maa12 = null
     where tc_maa01 = g_tc_maa.tc_maa01
    if sqlca.sqlcode then
        call cl_err("upd tc_maa_file",sqlca.sqlcode,1)
        let g_success = 'N'
        goto err_do1
    end if
    let g_success = 'Y'
    let l_cmd = p_email_get_cmd()
    # 如果CMD为空，报错
    if cl_null(l_cmd) then
        call cl_err("","czz-017",1)
        let g_success = 'N'
        goto err_do1
    end if
    let l_cmd = g_tc_maa.tc_maa11 clipped," ",l_cmd
    if l_cmd != g_tc_maa.tc_maa12 then
        if not cl_confirm("czz-018") then
            let g_success = 'N'
            goto err_do1
        end if
    end if
    # 如果cmd和tc_maa12不一致，提示是否手工处理
    # 删掉crontab
    if cs_darcy_cron(l_cmd,false) then
        message "作废成功" attribute(blink,bold)
    else
        message "作废失败" attribute(blink,bold,red)
        let g_success = 'N'
    end if
    label err_do1:
    if g_success = 'Y' then
        commit work
        # return true
    else
        rollback work
        return false
    end if
    call p_email_show()
    return true
end function

# 依据模板维护邮件正文
function p_email_template()
    if cl_null(g_tc_maa.tc_maa01) then
        return
    end if
    call cl_cmdrun_wait("p_email_template "||g_tc_maa.tc_maa01)
end function

# 默认值
function p_email_default()
    select max(tc_maa01)+1 into g_tc_maa.tc_maa01 from tc_maa_file
    if cl_null(g_tc_maa.tc_maa01) then
        let g_tc_maa.tc_maa01 = 1
    end if
    # let g_tc_maa.tc_maa04 = g_user
    select gen02,gen05,gen06 into g_tc_maa.tc_maa04,g_tc_maa.tc_maa04_tel,g_tc_maa.tc_maa04_mail
      from gen_file where gen01 = g_user
    select  to_char(SYSDATE,'mi hh24 dd mm *') into g_tc_maa.tc_maa11 from dual 

    let g_tc_maa.tc_maa07 = 'N'
    let g_tc_maa.tc_maa10 = 'Y'
    let g_tc_maa.tc_maa14 = 'Y'
    let g_tc_maa.tc_maa15 = 'Y'
    let g_tc_maa.tc_maa19 = 'Y'
    let g_tc_maa.tc_maa20 = 'Y'
    let g_tc_maa.tc_maa21 = 'Y'
    let g_tc_maa.tc_maa22 = 'N'
    let g_tc_maa.tc_maauser = g_user
    let g_tc_maa.tc_maacrtt = current year to second
    let g_tc_maa.tc_maaacti = 'Y'
end function

# 资料明细菜单
function p_email_bp(p_ud)
    define p_ud     varchar(1)

    if p_ud != "G" OR g_action_choice = "detail" then
        return
    end if

    let g_action_choice = " "
    call cl_set_act_visible("accept,cancel",false)

    display array g_tc_maa_d to s_tc_maa_d.* attribute(count = g_rec_b1,unbuffered)
        before display
            call cl_navigator_setting(g_curs_index,g_row_count)
            if g_rec_b1 != 0 then
                call fgl_set_arr_curr(g_curs_index)
            end if

        before row
            let l_ac1 = arr_curr()
            call cl_show_fld_cont()
        
        on action main
            let g_bp_flag = "main"
            let l_ac1 = arr_curr()
            let g_jump = l_ac1
            let mi_no_ask = true
            if g_rec_b1 > 0 then
                call p_email_fetch("/")
            end if
            call cl_set_comp_visible("page02", false)
            call ui.interface.refresh()
            call cl_set_comp_visible("page02", true)
            exit display
        
        on action accept
            let l_ac1 = arr_curr()
            let g_jump = l_ac1
            let mi_no_ask = true
            let g_bp_flag = null
            call p_email_fetch('/')
            call cl_set_comp_visible("page02", false)
            call ui.interface.refresh()
            call cl_set_comp_visible("page02", true)
            exit display
        on action first
            call p_email_fetch("F")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1 != 0 then
                call fgl_set_arr_curr(g_curs_index)
            end if
            continue display
        on action previous
            call p_email_fetch("P")
            call cl_navigator_setting(g_curs_index,g_row_count)
            if g_rec_b1 !=0 then
                call fgl_set_arr_curr(g_curs_index)
            end if
            continue display
        on action jump
            call p_email_fetch("/")
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1 != 0 then
                call fgl_set_arr_curr(g_curs_index)
            end if
            continue display
        on action next
            call p_email_fetch('N')
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1 != 0 then
                call fgl_set_arr_curr(g_curs_index)
            end if
            continue display
        on action last
            call p_email_fetch('l')
            call cl_navigator_setting(g_curs_index, g_row_count)
            if g_rec_b1 != 0 then
                call fgl_set_arr_curr(g_curs_index)
            end if
            continue display
        
        on action help
            let g_action_choice="help"
            exit display
 
        on action exit
            let g_action_choice="exit"
            exit display
 
        on action controlg
            let g_action_choice="controlg"
            exit display
 
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
        on action cancel
            let int_flag=false
            let g_action_choice="exit"
            exit display
 
        on idle g_idle_seconds
            call cl_on_idle()
            continue display
 
        on action about
            let g_action_choice="about"
            exit display
     
        on action insert
            let g_action_choice="insert"
            exit display
 
        on action query
            let g_action_choice="query"
            exit display
 
        on action delete
            let g_action_choice="delete"
            exit display
 
        on action modify
            let g_action_choice="modify"
            exit display
 
        on action invalid
            let g_action_choice="invalid"
            exit display
 
        on action reproduce
            let g_action_choice="reproduce"
            exit display
 
        on action exporttoexcel
            let g_action_choice="exporttoexcel"
            exit display

        on action output
            let g_action_choice="output"
            exit display

        # p_email action s---
        on action config
            let g_action_choice = "config"
            exit display

        # p_email action e---
        after display
            continue display
            
        &include "qry_string.4gl"
    end display
    call cl_set_act_visible("accept,cancel", true)
    if int_flag then
        call ui.interface.refresh()
        let int_flag = 0
    end if
end function

function p_email_set_entry()
    if g_tc_maa.tc_maa07 = 'Y' then
        call cl_set_comp_entry("tc_maa05,tc_maa08,tc_maa09,tc_maa24",true)
    end if
    if g_tc_maa.tc_maa10 = 'Y' then
        call cl_set_comp_entry("tc_maa11",true)
    end if
end function

function p_email_set_no_entry()
    if cl_null(g_tc_maa.tc_maa07) or g_tc_maa.tc_maa07 = 'N' then
        call cl_set_comp_entry("tc_maa05,tc_maa08,tc_maa09,tc_maa24",false)
    end if
    if cl_null(g_tc_maa.tc_maa10) or g_tc_maa.tc_maa10 = 'N' then
        call cl_set_comp_entry("tc_maa11",false)
    end if
end function

function p_email_input_chk()
    if g_tc_maa.tc_maa07 = 'Y' then
        if cl_null(g_tc_maa.tc_maa08) then
            call cl_err("if has attach,you need input a name","!",1)
            return "tc_maa08"
        end if
    end if
    if g_tc_maa.tc_maa05 = 'Y' then
        # 检查是否上传附件
        # TODO: 检查是否上传附件
    end if
    return ""
end function

function p_email_get_cmd()
    define sr record
        tc_mae01    like tc_mae_file.tc_mae01,
        tc_mae02    like tc_mae_file.tc_mae02,
        tc_mae03    like tc_mae_file.tc_mae03,
        tc_mae04    like tc_mae_file.tc_mae04,
        tc_mae05    like tc_mae_file.tc_mae05
        end record
    define l_cmd    string
    define l_ch     varchar(20)

    if cl_null(g_tc_maa.tc_maa01) then
        return ""
    end if

    initialize sr.* to null
    
    select tc_mae01,tc_mae02,tc_mae03,tc_mae04,tc_mae05 into sr.*
      from tc_mae_file
    if sqlca.sqlcode then
        call cl_err("",sqlca.sqlcode,1)
        return ""
    end if

    if cl_null(sr.tc_mae01) then
        call cl_err("无法找到执行命令路径","!",1)
        return ""
    end if
    let l_cmd = sr.tc_mae01

    # 指定日志文件，不指定会找配置文件，配置文件找不到日志会产生在运行目录
    if not cl_null(sr.tc_mae02) then
        let l_cmd = l_cmd," --log ",sr.tc_mae02
    end if

    # 配置文件
    if cl_null(sr.tc_mae03) then
        call cl_err("无法找到配置文件路径","!",1)
        return ""
    else
        let l_cmd = l_cmd," --config ",sr.tc_mae03
    end if

    # temp路径，为空时，会在以log目录作为temp路径
    if not cl_null(sr.tc_mae04) then
        let l_cmd = l_cmd," --temp ",sr.tc_mae04
    end if
    # excel生成路径，未指定时，找temp路径，然后再log路径
    if not cl_null(sr.tc_mae05) then
        let l_cmd = l_cmd," --release ",sr.tc_mae05
    end if
    let l_ch = cl_replace_str(g_tc_maa.tc_maa01," ","")
    let l_cmd = l_cmd," sendmail -i ",l_ch
    let l_cmd = l_cmd," #p_email:",l_ch

    return l_cmd
end function
