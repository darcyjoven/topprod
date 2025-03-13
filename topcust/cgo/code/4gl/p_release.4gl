# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_release.4gl
# Descriptions...: 发布更新内容
# Date & Author..: darcy:2023/10/17

import os
database ds
# 公共变量调用
globals "../../config/top.global"
type tc_rel record
    tc_rel01    like tc_rel_file.tc_rel01,
    tc_rel02    like tc_rel_file.tc_rel02,
    tc_rel03    like tc_rel_file.tc_rel03,
    tc_rel04    like tc_rel_file.tc_rel04,
    tc_rel05    like tc_rel_file.tc_rel05,
    tc_rel06    like tc_rel_file.tc_rel06,
    tc_rel07    like tc_rel_file.tc_rel07,
    tc_rel08    like tc_rel_file.tc_rel08,
    tc_rel09    like tc_rel_file.tc_rel09,
    tc_rel10    like tc_rel_file.tc_rel10,
    tc_rel11    like tc_rel_file.tc_rel11,
    tc_rel12    like tc_rel_file.tc_rel12,
    tc_rel13    like tc_rel_file.tc_rel13,
    tc_rel14    like tc_rel_file.tc_rel14,
    tc_rel15    like tc_rel_file.tc_rel15,
    tc_rel16    like tc_rel_file.tc_rel16,
    tc_rel17    like tc_rel_file.tc_rel17,
    tc_rel18    like tc_rel_file.tc_rel18,
    tc_rel19    like tc_rel_file.tc_rel19,
    tc_rel20    like tc_rel_file.tc_rel20,
    tc_rel21    like tc_rel_file.tc_rel21,
    tc_rel22    like tc_rel_file.tc_rel22,
    tc_rel23    like tc_rel_file.tc_rel23,
    tc_rel24    like tc_rel_file.tc_rel24,
    tc_rel25    like tc_rel_file.tc_rel25
    end record

define g_tc_rel,g_tc_rel_t tc_rel
define g_tc_rel01_t like tc_rel_file.tc_rel01
define g_gen02  like gen_file.gen02
define g_forupd_sql,g_msg,g_wc,g_sql string
define g_curs_index,g_row_count,g_jump integer
define g_no_ask boolean
main
    # 
    options
        input no wrap -- input 语句离开最后一个字符后结束
    defer interrupt -- 当收到终端指令时，继续（终端）
    
    # 判断是否有权限，依据全局变量设置,切换数据库
    if (not cl_user()) then
        exit program
    end if
    
    # 有任何报错调用cl_err_msg_log函数处理，这里函数是唯一不加()的地方
    whenever error call cl_err_msg_log

    # 设置全局变量
    if (not cl_setup("AZZ")) then
        exit program
    end if

    # 记录程序开始运行时间
    call cl_used(g_prog,g_time,1) returning g_time

    # 新建游标，方便判断资料是否在修改
    let g_forupd_sql = "select * from tc_rel_file where tc_rel01 = ? for update"
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare p_release_cl cursor from g_forupd_sql

    open window p_release_w with form "azz/42f/p_release"
       attribute (style = g_win_style clipped)
    
    call cl_ui_init() # 画面档设置，语言档设置等

    call p_release_menu()

    close window p_release_w

    # 记录程序结束时间
    call cl_used(g_prog,g_time,2) returning g_time
end main

# 输入查询条件
function p_release_curs()

    clear form
    construct by name g_wc on
        tc_rel01,tc_rel02,tc_rel03,tc_rel04,tc_rel05,
        tc_rel06,tc_rel07,tc_rel08,tc_rel09,tc_rel10,
        tc_rel11,tc_rel12,tc_rel17,tc_rel18,tc_rel19,tc_rel20

        before construct
            # 初始化查询
            call cl_qbe_init()
        
        # 标准功能
        # 超时退出
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
    let g_sql = "select tc_rel01 from tc_rel_file ",
                " where ",g_wc clipped," order by tc_rel01"
    prepare p_release_prepare from g_sql
    declare p_release_cs 
        scroll cursor with hold for p_release_prepare

    let g_sql = "select count(*) from tc_rel_file where ",g_wc clipped
    prepare p_release_precount from g_sql
    declare p_release_count cursor for p_release_precount
end function
# 菜单
function p_release_menu()
    menu ""
        before menu
            # 设置ToolBar工具栏
            call cl_navigator_setting(g_curs_index, g_row_count)

        # 增删改查
        on action insert
            let g_action_choice = "insert"
            if cl_chk_act_auth() then
                # 检查用户是否有insert权限
                call p_release_a()
            end if
        on action delete
            let g_action_choice = "delete"
            if cl_chk_act_auth() then
                call p_release_r()
            end if
        on action modify
            let g_action_choice = "modify"
            if cl_chk_act_auth() then
                call p_release_u()
            end if
        on action query
            let g_action_choice = "query"
            if cl_chk_act_auth() then
                call p_release_q()
            end if
        # 上下笔
        on action next
            call p_release_fetch('N')
        on action last
            call p_release_fetch('L')
        on action previous
            call p_release_fetch('P')
        on action first
            call p_release_fetch('F')
        on action jump
            call p_release_fetch('/')

        # 审核
        on action confirm
            let g_action_choice = "confirm"
            if cl_chk_act_auth() then
                let g_success = 'Y'
                call p_release_y_chk()
                if g_success = 'Y' then
                    call p_release_y_upd()
                end if
                call p_release_show()
            end if
        # 取消审核
        on action undo_confirm
            let g_action_choice = "undo_confirm"
            if cl_chk_act_auth() then
                call p_release_z()
                call p_release_show()
            end if
        
        # 上传文件
        on action upload
            let g_action_choice = "upload"
            if cl_chk_act_auth() then
                call p_release_upload()
                call p_release_show()
            end if

        # 打开更新文件页面
        on action preview
            let g_action_choice = "preview"
            if cl_chk_act_auth() then
                call s_show_help(g_tc_rel.tc_rel01)
            end if

        # 复制
        on action reproduce

        # 打印，导出excel
        on action output
        on action exporttoexcel

        # 其它固定功能
        on action help -- 帮助(ctrl+h)
            message ""
            call cl_show_help()

        on action controlg -- 打开其它作业(ctrl+g)
            message ""
            call cl_cmdask()

        on action exit -- 退出 点击离开，ESC
            message ""
            let g_action_choice = "exit"
            exit menu

        on action locale # 切换语言
            message ""
            call cl_dynamic_locale()
            call cl_show_fld_cont()
        
        on idle g_idle_seconds # 超时退出
           call cl_on_idle()
           continue menu
        
        on action about # 关于
            CALL cl_about()
        
        on action close # 关闭 点击x关闭窗口
            let int_flag=false
            let g_action_choice = "exit"
            exit program 
            exit menu
    end menu
end function

# 新增
function p_release_a()
    define l_maxno like type_file.chr20
    define l_tc_rel01   like tc_rel_file.tc_rel01

    message ""
    clear form # 清空画面
    initialize g_tc_rel.* to null # 清空资料
    while true
        # 默认值设置
        let g_tc_rel.tc_rel02 = today
        let g_tc_rel.tc_rel03 = g_user
        select gen02 into g_gen02 from gen_file where gen01 = g_user
        display g_gen02 to gen02
        let g_tc_rel.tc_rel08 = today
        let g_tc_rel.tc_rel10 = 'N'
        let g_tc_rel.tc_rel17 = g_user
        let g_tc_rel.tc_rel19 = g_user

        call p_release_i("a")  #录入资料
        if int_flag then
            # 取消录入
            initialize g_tc_rel.* to null
            let int_flag = false
            call cl_err('',9001,0) #提示放弃录入
            clear form
            exit while
        end if
        
        # 生成单别
        let l_tc_rel01 = year(g_today) using '<<<<',month(g_today) using '<<','%'
        select max(tc_rel01) into l_maxno from tc_rel_file
         where tc_rel01 like l_tc_rel01
        if not cl_null(l_maxno) then
            let l_maxno = l_maxno + 1
        else
            let l_maxno = year(g_today) using '<<<<',month(g_today) using '<<','0001'
        end if
        let l_maxno = l_maxno using '<<<<<<<<<<'

        let g_tc_rel.tc_rel01 = l_maxno
        let g_tc_rel.tc_rel20 = current
        insert into tc_rel_file(
            tc_rel01,tc_rel02,tc_rel03,tc_rel04,tc_rel05,tc_rel06,tc_rel07,tc_rel08,tc_rel09,tc_rel10,
            tc_rel11,tc_rel12,tc_rel13,tc_rel14,tc_rel15,tc_rel16,tc_rel17,tc_rel18,tc_rel19,tc_rel20,
            tc_rel21,tc_rel22,tc_rel23,tc_rel24,tc_rel25
        )values(
            g_tc_rel.tc_rel01,g_tc_rel.tc_rel02,g_tc_rel.tc_rel03,g_tc_rel.tc_rel04,g_tc_rel.tc_rel05,g_tc_rel.tc_rel06,g_tc_rel.tc_rel07,g_tc_rel.tc_rel08,g_tc_rel.tc_rel09,g_tc_rel.tc_rel10,
            g_tc_rel.tc_rel11,g_tc_rel.tc_rel12,g_tc_rel.tc_rel13,g_tc_rel.tc_rel14,g_tc_rel.tc_rel15,g_tc_rel.tc_rel16,g_tc_rel.tc_rel17,g_tc_rel.tc_rel18,g_tc_rel.tc_rel19,g_tc_rel.tc_rel20,
            g_tc_rel.tc_rel21,g_tc_rel.tc_rel22,g_tc_rel.tc_rel23,g_tc_rel.tc_rel24,g_tc_rel.tc_rel25
        )
        if sqlca.sqlcode then
            call cl_err3("ins","tc_rel_file",g_tc_rel.tc_rel01,"",SQLCA.sqlcode,"","",0)
            continue while
        else
            display by name g_tc_rel.tc_rel01
            exit while
        end if
    end while
end function

# 删除
function p_release_r()

    # 判断单号是否存在
    if cl_null(g_tc_rel.tc_rel01) then
        call cl_err('',-400,0)
        return
    end if

    # 开启事务
    begin work

    # 判断资料是否有其他人修改
    open p_release_cl using g_tc_rel.tc_rel01
    if status then
        call cl_err('open p_release_cl:',status,0)
        close p_release_cl
        rollback work
        return
    end if
    fetch p_release_cl into g_tc_rel.*
    if sqlca.sqlcode then
        call cl_err(g_tc_rel.tc_rel01,sqlca.sqlcode,0)
        return
    end if

    # 重新显示一下
    call p_release_show()

    if cl_delete() then
        delete from tc_rel_file where tc_rel01 = g_tc_rel.tc_rel01
        clear form

        # 重新查询数量
        open p_release_count
        if status then
            close p_release_cl
            close p_release_count
            commit work
            return
        end if
        fetch p_release_count into g_row_count
        if status or (cl_null(g_row_count) or g_row_count==0) then
            close p_release_cl
            close p_release_count
            commit work
            return
        end if
        display g_row_count to cnt1
        open p_release_cs
        
        # 查询下一笔的资料
        if g_curs_index = g_row_count + 1 then
            let g_jump = g_row_count
            call p_release_fetch('L')
        else
            let g_jump = g_curs_index
            let g_no_ask = true
            call p_release_fetch('/')
        end if
    end if
    close p_release_cl
    commit work

end function

# 修改
function p_release_u()
    # 判断单号是否存在
    if cl_null(g_tc_rel.tc_rel01) then
        call cl_err('',-400,0)
        return
    end if
    # 将资料重新查询一遍
    select * into g_tc_rel.* from tc_rel_file
     where tc_rel01 = g_tc_rel.tc_rel01
    # 将单号保存下来
    let g_tc_rel01_t = g_tc_rel.tc_rel01

    begin work

    # 判断资料是否有其他人修改
    open p_release_cl using g_tc_rel.tc_rel01
    if status then
        call cl_err("OPEN p_release_cl:", status, 1)
        close p_release_cl
        rollback work
        return
    end if
    fetch p_release_cl into g_tc_rel.*
    if sqlca.sqlcode then
        call cl_err(g_tc_rel.tc_rel01,sqlca.sqlcode,1)
        return
    end if
    let g_tc_rel.tc_rel19 = g_user
    call p_release_show()

    while true
        # 修改栏位
        call p_release_i('u')
        if int_flag then
            let int_flag = false
            let g_tc_rel.* = g_tc_rel_t.*
            call p_release_show()
            call cl_err('',9001,0)
            exit while
        end if

        # 更新资料
        let g_tc_rel.tc_rel20 = current
        update tc_rel_file
           set tc_rel.* = g_tc_rel.*
         where tc_rel01 = g_tc_rel.tc_rel01
        if sqlca.sqlcode then
            call cl_err3("upd","tc_rel_file",g_tc_rel.tc_rel01,"",SQLCA.sqlcode,"","",0)
            continue while
        else
            close p_release_cl
            commit work
            exit while
        end if
    end while

end function

# 查询
function p_release_q()

    # 清空总笔数，和当前的笔数
    let g_row_count = 0
    let g_curs_index = 0
    call cl_navigator_setting(g_curs_index,g_row_count)
    display '  ' to cnt
    display '  ' to cnt1

    # 输入查询条件
    call p_release_curs()
    if int_flag then
        let int_flag = false
        clear form
        return
    end if

    open p_release_count
    fetch p_release_count into g_row_count
    display g_row_count to cnt1
    open p_release_cs
    if sqlca.sqlcode then
        call cl_err(g_tc_rel.tc_rel01,sqlca.sqlcode,0)
        initialize g_tc_rel.* to null
    else
        call p_release_fetch('F')
    end if
end function

# 上下笔切换
function p_release_fetch(p_flag)
    define p_flag varchar(1)

    # 切换上下笔资料
    case p_flag
        when 'N' fetch next p_release_cs into g_tc_rel.tc_rel01
        when 'P' fetch previous p_release_cs into g_tc_rel.tc_rel01
        when 'F' fetch first p_release_cs into g_tc_rel.tc_rel01
        when 'L' fetch last p_release_cs into g_tc_rel.tc_rel01
        when '/'
            # 输入要跳转的指定笔数
            if not g_no_ask then
                call cl_getmsg('fetch',g_lang) returning g_msg
                let int_flag = false
                prompt g_msg clipped ,': ' for g_jump
                    # 都是常用功能
                    # 超时退出
                    on idle g_idle_seconds
                        call cl_on_idle()
                    on action abount
                        call cl_about()
                    on action help
                        call cl_show_help()
                    on action controlp
                        call cl_cmdask()
                end prompt
                # 取消输出
                if int_flag then
                    let int_flag = false
                    exit case
                end if
            end if
            fetch absolute g_jump p_release_cs into g_tc_rel.tc_rel01
            let g_no_ask = false
    end case
    if sqlca.sqlcode then
        call cl_err(g_tc_rel.tc_rel01,sqlca.sqlcode,0)
        return
    else
        case p_flag
            when 'F' let g_curs_index = 1
            when 'P' let g_curs_index = g_curs_index -1
            when 'N' let g_curs_index = g_curs_index + 1
            when 'L' let g_curs_index = g_row_count
            when '/' let g_curs_index = g_jump
        end case
        # 刷新工具栏状态
        call cl_navigator_setting(g_curs_index, g_row_count)
    end if
    # 查询当前单据所有资料
    # 然后重新显示
    select * into g_tc_rel.tc_rel01 from tc_rel_file
     where tc_rel01 = g_tc_rel.tc_rel01
    if sqlca.sqlcode then
        call cl_err3("sel","tc_rel_file",g_tc_rel.tc_rel01,"",SQLCA.sqlcode,"","",0)
    else
        call p_release_show()
    end if
end function

# 将变量值显示到画面上
function p_release_show()

    select * into g_tc_rel.* from tc_rel_file
     where tc_rel01 = g_tc_rel.tc_rel01
    let g_tc_rel_t.* = g_tc_rel.*

    display by name g_tc_rel.*
    select gen02 into g_gen02 from gen_file
     where gen01 = g_tc_rel.tc_rel03
    display g_gen02 to gen02
    # 显示当前第几笔
    display g_curs_index to cnt

end function

# 审核前检查资料
function p_release_y_chk()
    define l_cnt integer
    define l_file string

    # 判断单号是否存在
    if cl_null(g_tc_rel.tc_rel01) then
        call cl_err('',-400,0)
        let g_success = 'N'
        return
    end if

    select * into g_tc_rel.* from tc_rel_file where tc_rel01 = g_tc_rel.tc_rel01

    # 已经审核不能再审核
    if g_tc_rel.tc_rel10 = 'Y' then
        call cl_err(g_tc_rel.tc_rel01,'czz-028',1)
        let g_success = 'N'
        return
    end if
    
    # 判断关联单号是否正确
    if not cl_null(g_tc_rel.tc_rel12) then
        # 不是空
        let l_cnt = 0
        select count(*) into l_cnt from tc_rel_file 
         where tc_rel01 = g_tc_rel.tc_rel12 and tc_rel10 = 'Y'
           and tc_rel08 <= g_tc_rel.tc_rel08
        if l_cnt = 0 then
            call cl_err(g_tc_rel.tc_rel12,'czz-025',1)
            let g_success = 'N'
            return
        end if
    end if

    # 检查文件是否存在
    # 得到文件名
    let l_file = "/u1/topprod/tiptop/doc/help/2/release/",g_tc_rel.tc_rel01,".htm"
    if not cl_null(g_tc_rel.tc_rel09) and not os.Path.exists(l_file) then
        call cl_err(g_tc_rel.tc_rel01,'czz-026',1)
        let g_success = 'N'
        return
    end if

    # 推送日期不得小于等于今天
    if g_tc_rel.tc_rel08 <= TODAY then
        call cl_err(g_tc_rel.tc_rel01,'czz-027',1)
        let g_success = 'N'
        return
    end if

end function

# 审核
function p_release_y_upd()

    update tc_rel_file set tc_rel10 ='Y'
     where tc_rel01 = g_tc_rel.tc_rel01
    if sqlca.sqlcode then
        call cl_err(g_tc_rel.tc_rel01,sqlca.sqlcode,1)
        let g_success = 'N'
        return
    else
        let g_tc_rel.tc_rel10 = 'Y'
    end if
end function

# 取消审核
function p_release_z()
    
    # 判断单号是否存在
    if cl_null(g_tc_rel.tc_rel01) then
        call cl_err('',-400,0)
        let g_success = 'N'
        return
    end if

    select * into g_tc_rel.* from tc_rel_file where tc_rel01 = g_tc_rel.tc_rel01

    # 已经审核不能再审核
    if g_tc_rel.tc_rel10 = 'N' then
        return
    end if

    # 日期只有大于今天才可以取消审核
    if g_tc_rel.tc_rel08 <= TODAY then
        call cl_err(g_tc_rel.tc_rel08,'czz-027',1)
        let g_success = 'N'
        return
    end if

    # 已经有人看到了
    # TODO

    update tc_rel_file set tc_rel10 = 'N'
     where tc_rel01 = g_tc_rel.tc_rel01
    if sqlca.sqlcode then
        call cl_err('upd tc_rel_file',sqlca.sqlcode,1)
        return
    else
        let g_tc_rel.tc_rel10 = 'N'
    end if

end function

# 录入字段值
function p_release_i(p_cmd)
    define p_cmd like type_file.chr1
    define l_input like type_file.chr1

    display by name g_tc_rel.tc_rel01,g_tc_rel.tc_rel02,g_tc_rel.tc_rel03,g_tc_rel.tc_rel04,g_tc_rel.tc_rel05,g_tc_rel.tc_rel06,g_tc_rel.tc_rel07,g_tc_rel.tc_rel08,g_tc_rel.tc_rel09,g_tc_rel.tc_rel10,
                    g_tc_rel.tc_rel11,g_tc_rel.tc_rel12,g_tc_rel.tc_rel13,g_tc_rel.tc_rel14,g_tc_rel.tc_rel15,g_tc_rel.tc_rel16,g_tc_rel.tc_rel17,g_tc_rel.tc_rel18,g_tc_rel.tc_rel19,g_tc_rel.tc_rel20,
                    g_tc_rel.tc_rel21,g_tc_rel.tc_rel22,g_tc_rel.tc_rel23,g_tc_rel.tc_rel24,g_tc_rel.tc_rel25
    display g_gen02 to gen02

    input by name g_tc_rel.tc_rel01,g_tc_rel.tc_rel02,g_tc_rel.tc_rel03,g_tc_rel.tc_rel04,g_tc_rel.tc_rel05,g_tc_rel.tc_rel06,g_tc_rel.tc_rel07,g_tc_rel.tc_rel08,g_tc_rel.tc_rel09,g_tc_rel.tc_rel10,
                  g_tc_rel.tc_rel11,g_tc_rel.tc_rel12,g_tc_rel.tc_rel13,g_tc_rel.tc_rel14,g_tc_rel.tc_rel15,g_tc_rel.tc_rel16,g_tc_rel.tc_rel17,g_tc_rel.tc_rel18,g_tc_rel.tc_rel19,g_tc_rel.tc_rel20,
                  g_tc_rel.tc_rel21,g_tc_rel.tc_rel22,g_tc_rel.tc_rel23,g_tc_rel.tc_rel24,g_tc_rel.tc_rel25
        without defaults

        before input
            # 输入之前运行，只运行一次
            let l_input = 'N'
            # 设置字段是否可以输入
            call p_release_set_entry(p_cmd)
            call p_release_set_no_entry(p_cmd)
        
        after field tc_rel03
            if not cl_null(g_tc_rel.tc_rel03) then
                select gen02 into g_gen02 from gen_file
                 where gen01 = g_tc_rel.tc_rel03
                display g_gen02 to gen02
            end if

        # 开窗
        on action controlp
            case
                when infield(tc_rel01)
                when infield(tc_rel03)
                when infield(tc_rel09)
                when infield(tc_rel12)
            end case
        
        # 确认输入后
        after input
            if int_flag then
                exit input
            end if
            # 这里可以做一些必要字段的检查

        # 以下是常用功能
        # 显示必要字段是否录入
        on action controlr
            call cl_show_req_fields()
        
        # 打开其它作业 ctrl+g
        on action controlg
            call cl_cmdask()
        
        # 查询画面上的字段 ctrl+F
        on action controlf
            call cl_set_focus_form(ui.interface.getrootnode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        # 超时退出
        on idle g_idle_seconds
            call cl_on_idle()
            continue input

        # 关于
        on action about
            call cl_about()

        # 帮助
        on action help
            call cl_show_help()

    end input

end function


# 设置可录入字段
function p_release_set_entry(p_cmd)
    define p_cmd    like type_file.chr1
    
end function

# 设置不可录入字段
function p_release_set_no_entry(p_cmd)
    define p_cmd    like type_file.chr1
end function

# 上传文件
function p_release_upload()
    define l_dir string
    define l_file varchar(200)

    # 判断单号是否存在
    if cl_null(g_tc_rel.tc_rel01) then
        call cl_err('',-400,0)
        return
    end if
    select * into g_tc_rel.* from tc_rel_file where tc_rel01 = g_tc_rel.tc_rel01

    # 已审核
    if g_tc_rel.tc_rel10 ='Y' then
        return
    end if

    # 得到文件名
    let l_file = "/u1/topprod/tiptop/doc/help/2/release/",g_tc_rel.tc_rel01,".htm"
    
    # 选择要上传的文件
    call cl_browse_file() returning l_dir

    if cl_null(l_dir) then
        # 取消录入
        return
    end if

    # 上传文件名，如果文件已有，提示是否替代
    # /u1/topprod/tiptop/doc/help/2
    if os.Path.exists(l_file) then
        if not cl_confirm('czz-024') then
            return
        else
            if os.Path.delete(l_file) then
                call cl_err(null, "lib-207", 1)
                return
            end if
        end if
    end if

    begin work

    # 将文件上传文件到ERP服务器
    if not cl_upload_file(l_dir,l_file) then
        call cl_err(null, "lib-212", 1)
        return
    end if
    update tc_rel_file set tc_rel09 = l_file
     where tc_rel01 = g_tc_rel.tc_rel01
    if sqlca.sqlcode then
        call cl_err("upd tc_rel", sqlca.sqlcode, 1)
        rollback work
        if os.Path.delete(l_file) then
            call cl_err(null, "lib-207", 1)
            return
        end if
        return
    else
        let g_tc_rel.tc_rel09 = l_file
        commit work
    end if
end function
