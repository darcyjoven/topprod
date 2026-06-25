# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_isee.4gl
# Descriptions...: ISEE 管理作业


import os
database ds
globals "../../config/top.global"


type isee record
    proj            varchar(100),
    desc            varchar(200),
    vtable          boolean,
    pdfme           boolean,
    default         boolean,
    last            integer,
    mod             varchar(100)
end record

define  g_home,g_wc,g_url         string
define  l_ac,g_rec_b,g_cnt        integer
define  g_isee              dynamic array of isee
define  g_add               record
            proj_a            varchar(100),
            desc_a            varchar(200),
            vtable_a          string,
            pdfme_a           string,
            default_a         string
        end record


main
    options input no wrap defer interrupt

    if (not cl_user()) then
       exit program
    end if

    whenever error call cl_err_msg_log

    if (not cl_setup("AZZ")) then
       exit program
    end if

    call cl_used(g_prog,g_time,1) returning g_time

    open window p_isee_w with form "azz/42f/p_isee"
       attribute(style=g_win_style clipped)
    call cl_ui_init()

    let g_home = arg_val(1)
    let g_url = fgl_getenv("FGLASIP") clipped||"/tiptop/isee"
    if cl_null(g_home) then
        display '必须指定根目录 arg_val(1) 为空'
    else
        call p_isee_q()
        call p_isee_menu()
    end if

    close window p_isee_w
    call cl_used(g_prog,g_time,2) returning g_time
end main

-- 菜单
function p_isee_menu()
    while true
        call p_isee_bp()
        case g_action_choice
            when 'query'
                call p_isee_q()
            when 'exporttoexcel'
                call cl_download_by_explorer(cl_expexcel1("s_isee",base.typeinfo.create(g_isee)))
            when 'fresh'
                call g_isee.clear()
                call p_isee_b_fill()
            when 'detail'
                call p_isee_edit()
            when 'insert'
                call p_isee_a()
            when 'help'
                # 帮助文档
                call ui.Interface.frontCall("standard", "shellexec",
                                            ["EXPLORER \"" || g_url||"/help/运维操作手册.pdf" || "\""],
                                            [g_cnt])
            when 'exit'
                exit while
            when 'vtable'
                if l_ac <= g_isee.getLength() and l_ac > 0 then
                    call ui.Interface.frontCall("standard", "shellexec",
                                                ["EXPLORER \"" || sfmt('%1/pages/vtable?prog=%2',g_url,g_isee[l_ac].proj) || "\""],
                                                [g_cnt])
                end if
            when 'pdfme'
                if l_ac <= g_isee.getLength() and l_ac > 0 then
                    call ui.Interface.frontCall("standard", "shellexec",
                                                ["EXPLORER \"" || sfmt('%1/pages/pdfme?prog=%2',g_url,g_isee[l_ac].proj) || "\""],
                                                [g_cnt])
                end if
        end case
    end while
end function

-- 显示单身
function p_isee_bp()
    message ''
    display g_rec_b to cnt
    call cl_set_act_visible("accept,cancel", false)
    display array g_isee to s_isee.* attribute(count=g_rec_b)

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
            exit display

        on action detail
            let g_action_choice = 'detail'
            exit display

        on action output
            let g_action_choice = 'output'
            exit display

        on action insert
            let g_action_choice = 'insert'
            exit display

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit display

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = 'exit'
            exit display

        on action accept
            let g_action_choice = 'detail'
            let l_ac = arr_curr()
            exit display

        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit display

        on action fresh let g_action_choice = 'fresh' exit display
        on action vtable let g_action_choice = 'vtable' exit display
        on action pdfme let g_action_choice = 'pdfme' exit display

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue display

        on action about
            call cl_about()

        on action help
            call cl_show_help()

      after display
        continue display

    end display
    call cl_set_act_visible("accept,cancel", true)
end function

-- 查询或者刷新
function p_isee_q()
    call g_isee.clear()
    -- 显示目录是否正常
    if dir_exists(g_home) then
        display g_home to url
    else
        call cl_err(g_home||'目录不存在','!',1)
        return
    end if
    call p_isee_b_fill()
end function

-- 单身
function p_isee_b_fill()
    define child    string
    define h,i      integer
    define l_isee   isee

    if not dir_exists(g_home) then
        message sfmt('%1未找到配置目录',g_home)
        return
    end if

    # 开始遍历home目录
    # 按照最后修改时间倒序排序
    call os.Path.dirSort('mtime',-1)
    let h = os.Path.dirOpen(g_home)

    while h > 0
        let child = os.Path.dirNext(h)
        if cl_null(child) then
            exit while
        end if

        if child == '.' or child = '..' then
            continue while
        end if

        call findProject(child,g_home||'/'||child) returning l_isee.*

        if cl_null(l_isee.desc) then
            continue while
        end if
        let i = g_isee.getLength() + 1
        let g_isee[i].* = l_isee.*

    end while
    call os.Path.dirClose(h)
    let g_rec_b = g_isee.getLength()

end function

-- 遍历目录检查是否是项目
function findProject(p_proj,p_dir)
    define p_proj,p_dir        string
    define child,l_time,l_ext    string
    define h,i,j    integer
    define l_isee   isee


    if not dir_exists(p_dir) then
        message sfmt('%1未找到配置目录',p_dir)
        return l_isee.*
    end if

    # 开始遍历home目录
    # 按照最后修改时间倒序排序
    call os.Path.dirSort('mtime',-1)
    let h = os.Path.dirOpen(p_dir)

    initialize l_isee.* to null
    let l_isee.vtable = false
    let l_isee.pdfme = false
    let l_isee.default = false
    let l_isee.last = 0
    let l_isee.proj = p_proj
    while h > 0
        let child = os.Path.dirNext(h)
        if cl_null(child) then
            exit while
        end if

        if child == '.' or child = '..' then
            continue while
        end if

        if child matches '.*' then
            let l_isee.desc = child.subString(2,child.getLength())
        end if

        if child matches 'vtable.js*' then
            let l_isee.vtable = true
            if child = 'vtable.js' then
                call os.Path.mtime(p_dir||'/vtable.js') returning l_time
                if l_isee.mod < l_time or cl_null(l_isee.mod) then
                    let l_isee.mod = l_time
                end if
            else
                call os.Path.extension(p_dir||'/'||child) returning l_ext
                if l_ext > l_isee.last or cl_null(l_isee.mod) then
                    let l_isee.last = l_ext
                end if
            end if
        end if
        if child = 'default.json' then
            let l_isee.default = true
            if child = 'default.json' then
                call os.Path.mtime(p_dir||'/default.json') returning l_time
                if l_isee.mod < l_time or cl_null(l_isee.mod) then
                    let l_isee.mod = l_time
                end if
            else
                call os.Path.extension(p_dir||'/'||child) returning l_ext
                if l_ext > l_isee.last then
                    let l_isee.last = l_ext
                end if
            end if
        end if
        if child = 'pdfme.json' then
            let l_isee.pdfme = true
            if child = 'pdfme.json' then
                call os.Path.mtime(p_dir||'/pdfme.json') returning l_time
                if l_isee.mod < l_time then
                    let l_isee.mod = l_time
                end if
            else
                call os.Path.extension(p_dir||'/'||child) returning l_ext
                if l_ext > l_isee.last then
                    let l_isee.last = l_ext
                end if
            end if
        end if
    end while
    call os.Path.dirClose(h)
    return l_isee.*
end function

-- 编辑
function p_isee_edit()
    define l_ok     boolean

    if l_ac > g_isee.getLength() or l_ac <= 0 then
        return
    end if

    # 首选要刷新一下
    call findProject(g_isee[l_ac].proj,g_home||'/'||g_isee[l_ac].proj)
        returning g_isee[l_ac].*

    # 确认一下
    if not cl_confirm_parm('cise-01',sfmt('%1|%2',g_isee[l_ac].proj,g_isee[l_ac].last)) then
        return
    end if

    initialize g_add.* to null
    let g_add.proj_a = g_isee[l_ac].proj
    let g_add.desc_a = g_isee[l_ac].desc

    call add_version(g_home||'/'||g_isee[l_ac].proj,g_isee[l_ac].last + 1)
        returning g_add.vtable_a,g_add.pdfme_a,g_add.default_a,l_ok

    if not l_ok then
        return
    end if

    call p_isee_i('u')
    if int_flag then
        let int_flag = false
        return
    end if

    if upd_proj(g_home||'/'||g_isee[l_ac].proj,g_isee[l_ac].last + 1) then
        let g_isee[l_ac].desc = g_add.desc_a
        let g_isee[l_ac].vtable = not cl_null(g_add.vtable_a)
        let g_isee[l_ac].pdfme = not cl_null(g_add.pdfme_a)
        let g_isee[l_ac].default = not cl_null(g_add.default_a)
        let g_isee[l_ac].mod = current year to second
        let g_isee[l_ac].last = g_isee[l_ac].last + 1
        message '修改成功'||g_isee[l_ac].proj
    else
        message '修改失败'||g_isee[l_ac].proj
    end if

end function

-- 增加版本
function add_version(p_path,p_version)
    define p_path                       string
    define p_version                    integer
    define l_vtable,l_pdfme,l_default   string
    define l_channel                    base.Channel

    if not dir_exists(p_path) then
        call cl_err(p_path||' 目录不存在','!',1)
        return l_vtable,l_pdfme,l_default,false
    end if

    -- 复制为新版本
    run sfmt('cp %1/%2 %3/%4.%5',p_path,'vtable.js',p_path,'vtable.js',p_version)
    run sfmt('cp %1/%2 %3/%4.%5',p_path,'pdfme.json',p_path,'pdfme.json',p_version)
    run sfmt('cp %1/%2 %3/%4.%5',p_path,'default.json',p_path,'default.json',p_version)

    -- 取文件内容
    let l_vtable = read_file(p_path||'/'||'vtable.js')
    let l_pdfme = read_file(p_path||'/'||'pdfme.json')
    let l_default = read_file(p_path||'/'||'default.json')

    return l_vtable,l_pdfme,l_default,true

end function

-- 读取文件内容
function read_file(p_file)
    define p_file string
    define l_file text
    define l_value  string

    if not file_exists(p_file) then
        return ''
    end if

    locate l_file in memory
    call l_file.readFile(p_file)
    let l_value = l_file

    free l_file
    return l_value
end function

-- 更新为新资料
function upd_proj(p_path,p_version)
    define p_path                       string
    define p_version                    integer

    # 名称
    if g_isee[l_ac].desc != g_add.desc_a then
        run sfmt('mv %1/.%2  %3/.%4',p_path,g_isee[l_ac].desc,p_path,g_add.desc_a)
    end if

    # 文件
    if cl_null(g_add.vtable_a) then
        run sfmt('rm %1/%2',p_path,'vtable.js')
    else
        if not upd_file(p_path||'/vtable.js',g_add.vtable_a) then
            call cl_err(p_path||'/vtable.js'||' 更新文件失败','!',1)
            let g_success = 'N'
        end if
    end if
    if cl_null(g_add.pdfme_a) then
        run sfmt('rm %1/%2',p_path,'pdfme.json')
    else
        if not upd_file(p_path||'/pdfme.json',g_add.pdfme_a) then
            call cl_err(p_path||'/pdfme.json'||' 更新文件失败','!',1)
            let g_success = 'N'
        end if
    end if
    if cl_null(g_add.default_a) then
        run sfmt('rm %1/%2',p_path,'default.json')
    else
        if not upd_file(p_path||'/default.json',g_add.default_a) then
            call cl_err(p_path||'/default.json'||' 更新文件失败','!',1)
            let g_success = 'N'
        end if
    end if

    return true
end function

-- 更新
function upd_file(p_file,p_value)
    define p_file,p_value       string
    define l_channel                    base.Channel

    let l_channel = base.Channel.create()
    call l_channel.openFile(p_file,'w')
    call l_channel.writeLine(p_value)
    call l_channel.close()

    return file_exists(p_file)
end function

-- 新增项目
function p_isee_a()
    define l_channel base.Channel
    define h,i,j    integer
    define l_path,l_temp   string

    initialize g_add.* to null
    call p_isee_i('a')
    if int_flag then
        let int_flag = false
        return
    end if

    let g_success = 'Y'

    # 创建目录
    let l_path = g_home||'/'||g_add.proj_a
    if not os.Path.mkdir(l_path) then
        call cl_err(l_path||' 目录创建失败','!',1)
        return
    end if
    # 创建desc
    --if not cl_null(g_add.desc) then
    let l_channel = base.Channel.create()
    let l_temp = l_path,'/.',g_add.desc_a
    call l_channel.openFile(l_temp,'w')
    call l_channel.close()
    if not file_exists(l_temp) then
        call cl_err(l_temp||' 描述文件创建失败','!',1)
            let g_success = 'N'
        return
    end if
    --end if
    # 创建其它文件
    if not cl_null(g_add.vtable_a) then
        let l_temp = l_path , '/vtable.js'
        if not vim_file(l_temp,g_add.vtable_a) then
            call cl_err(l_temp||'创建失败','!',1)
            let g_success = 'N'
        end if
    end if
    if not cl_null(g_add.pdfme_a) then
        let l_temp = l_path , '/pdfme.json'
        if not vim_file(l_temp,g_add.pdfme_a) then
            call cl_err(l_temp||'创建失败','!',1)
            let g_success = 'N'
        end if
    end if
    if not cl_null(g_add.default_a) then
        let l_temp = l_path , '/default.json'
        if not vim_file(l_temp,g_add.default_a) then
            call cl_err(l_temp||'创建失败','!',1)
            let g_success = 'N'
        end if
    end if

    if g_success = 'Y' then
        let i = g_isee.getLength() + 1
        let g_isee[i].proj = g_add.proj_a
        let g_isee[i].desc = g_add.desc_a
        let g_isee[i].vtable = not cl_null(g_add.default_a)
        let g_isee[i].pdfme = not cl_null(g_add.default_a)
        let g_isee[i].default = not cl_null(g_add.default_a)
        let g_isee[i].mod = current year to second
        let g_isee[i].last = 0
        let g_rec_b = g_rec_b + 1
        display g_rec_b to cnt
        message '新建完成'||g_add.proj_a
    else
        message '建立失败'||g_add.proj_a
    end if
end function

--
function vim_file(p_path,p_file)
    define p_path,p_file    string
    define l_channel        base.Channel

    let l_channel = base.Channel.create()

    call l_channel.openFile(p_path,'w')
    call l_channel.writeLine(p_file)
    call l_channel.close()

    return file_exists(p_path)
end function

function p_isee_i(p_cmd)
    define p_cmd    varchar(1)

    open window p_isee_a_w with form "azz/42f/p_isee_i"
       attribute(style=g_win_style clipped)
    call cl_ui_init()

    call cl_set_act_visible("accept,cancel", true)
    input by name g_add.* without defaults

        before input
            if p_cmd = 'a' then
                call cl_set_comp_entry('proj_a,desc_a,vtable_a,pdfme_a,default_a',true)
            else
                call cl_set_comp_entry('desc_a,vtable_a,pdfme_a,default_a',true)
                call cl_set_comp_entry('proj_a',false)
            end if

        on action controlr
            call cl_show_req_fields()

        on action controlf
            -- 切换语言
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue input

        after field proj_a
            if not cl_null(g_add.proj_a) and p_cmd = 'a' then
                if os.Path.exists(g_home||'/'||g_add.proj_a) then
                    call cl_err(sfmt('%1/%2 项目名已存在',g_home,g_add.proj_a),'!',1)
                    next field proj_a
                end if
            end if

        after field desc_a

        after field vtable_a

        after field pdfme_a

        after field default_a

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action cancel
            let int_flag = true
            exit input

        on action accept
            accept input
    end input

    call cl_set_act_visible("accept,cancel", false)

    close window p_isee_a_w
end function

-- 文件是否存在
function file_exists(p_file)
    define p_file   string
    define l_ok     boolean

    call os.Path.exists(p_file) returning l_ok

    if not l_ok then
        return false
    end if
    call os.Path.isFile(p_file) returning l_ok
    return l_ok
end function
--目录是否存在
function dir_exists(p_dir)
    define p_dir    string
    define l_ok     boolean

    call os.Path.exists(p_dir) returning l_ok

    if not l_ok then
        return false
    end if
    call os.Path.isDirectory(p_dir) returning l_ok
    return l_ok
end function
