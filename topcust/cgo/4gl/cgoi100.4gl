# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cgoi100.4gl
# Descriptions...: CGo资料注册
# Date & Author..: darcy:2024/04/15

database ds

globals "../../../tiptop/config/top.global"

type cgb record
    cgb02_1     like cgb_file.cgb02,
    cgb03_1     like cgb_file.cgb03,
    cgb04_1     like cgb_file.cgb04,
    cgb05_1     like cgb_file.cgb05,
    cgb06_1     like cgb_file.cgb06,
    cgb07_1     like cgb_file.cgb07,
    cgb08_1     like cgb_file.cgb08,
    cgb09_1     like cgb_file.cgb09,
    cgb10_1     like cgb_file.cgb10
    end record
type cgc record
    cgc02     like cgc_file.cgc02,
    cgc03     like cgc_file.cgc03,
    cgc04     like cgc_file.cgc04,
    cgc05     like cgc_file.cgc05,
    cgc06     like cgc_file.cgc06,
    cgc07     like cgc_file.cgc07,
    cgc08     like cgc_file.cgc08,
    cgc09     like cgc_file.cgc09,
    cgc10     like cgc_file.cgc10,
    cgc11     like cgc_file.cgc11,
    cgc12     like cgc_file.cgc12
    end record

define g_cgb_1  dynamic array of cgb
define g_cgc dynamic array of cgc
define g_cgb record like cgb_file.*
define g_cgb_t record like cgb_file.*
define g_cgb01_t    like cgb_file.cgb01
define g_cgb02_t    like cgb_file.cgb02
define g_cnt,g_curs_index,g_row_count,g_jump,l_ac integer
define g_sql,g_msg,g_wc,g_cmd string
define g_no_ask like type_file.chr1

MAIN
    define   p_row,p_col   like type_file.num5
    options
        input no wrap
    defer interrupt
 
    if (not cl_user()) then
        exit program
    end if
 
    whenever error call cl_err_msg_log
 
    if (not cl_setup("CGO")) then
        exit program
    end if
    
    call cl_used(g_prog,g_time,1) returning g_time

    let g_sql = "select * from cgb_file where cgb01=? and cgb02=? for update"
    declare cgoi100_curl cursor from g_sql

    open window cgoi100_w at p_row,p_col with form "cgo/42f/cgoi100"
            attribute (style = g_win_style clipped)
        
    call cl_ui_init()
    select * from cgc_file where 1=2 into temp x
    call cgoi100_menu()

    close window cgoi100_w
    call  cl_used(g_prog,g_time,2) returning g_time 
END MAIN

function cgoi100_curs()
    clear form
    display "$GO为go编译命令；$GCC为gcc编译命令；$WS为代码工作目录；$OUT为输出二进制文件目录；$THIS为当前lib名称" to tips
    construct by name g_wc on cgb01,cgb02,cgb03,cgb04,cgb05,
                              cgb06,cgb07,cgb08,cgb09,cgb10
        on action controlp 
            case 
                when infield(cgb01)

                when infield(cgb05)
            end case

        on idle g_idle_seconds
            call cl_on_idle()
            continue construct
 
        on action about
            call cl_about()
 
        on action controlg
            call cl_cmdask()
 
        on action help 
            call cl_show_help()
    end construct
    let g_sql = "select unique cgb01,cgb02 from cgb_file ",
                " where ",g_wc clipped," order by cgb01,cgb02"
    prepare cgoi100_prepare from g_sql
    declare cgoi100_curs 
        scroll cursor with hold for cgoi100_prepare
    
    let g_sql = "select count(*) from (select unique cgb01,cgb02 from cgb_file",
                " where ",g_wc clipped," )"
    prepare cgoi100_precount from g_sql
    declare cgoi100_count cursor for cgoi100_precount

end function

# 菜单
function cgoi100_menu()
    while true
        display "$GO为go编译命令；$GCC为gcc编译命令；$WS为代码工作目录；$OUT为输出二进制文件目录；$THIS为当前lib名称" to tips
        call cgoi100_bp("G")
        case g_action_choice
            when "help"
            call cl_show_help()
 
            when "exit"
                exit while
            when "close"
                exit while
    
            when "controlg"
                call cl_cmdask()

            when "query"
                if cl_chk_act_auth() then
                    call cgoi100_q()
                end if
            when "insert"
                if cl_chk_act_auth() then
                    call cgoi100_a()
                end if
            when "delete"
                if cl_chk_act_auth() then
                    call cgoi100_r()
                end if
            when "modify"
                if cl_chk_act_auth() then
                    call cgoi100_u()
                end if
            when "version_add"
                if cl_chk_act_auth() then
                    call cgoi100_u()
                end if
            when "compile"
                if cl_chk_act_auth() then
                    call cgoi100_compile()
                end if
            when "test"
                if cl_chk_act_auth() then
                    call cgoi100_test()
                end if
        end case
    end while
end function

# 增加
function cgoi100_a()
    message ""
    clear form
    initialize g_cgb.* like cgb_file.*

    let g_cgb.cgb02 = 1
    let g_cgb.cgb03 = 1
    let g_cgb.cgb07 = g_user 
    let g_cgb.cgb08 = current year to second

    while true 
        call cgoi100_i('a')
        if int_flag then
            let int_flag = 0
            call cl_err('',9001,0)
            clear form
            exit while
        end if
        if g_cgb.cgb01 is null then
            continue while
        end if
        insert into cgb_file values g_cgb.*
        if sqlca.sqlcode then
            call cl_err3("ins","cgb_file",g_cgb.cgb01,"",SQLCA.sqlcode,"","",0)
            continue while
        else
            let g_cgb_t.* = g_cgb.*
            select cgb01,cgb02 into g_cgb.cgb01,g_cgb.cgb02 from cgb_file
             where cgb01 = g_cgb.cgb01 and cgb02 = g_cgb.cgb02
        end if
        exit while
    end while

end function

# 新增
function cgoi100_i(p_cmd)
    define p_cmd like type_file.chr1
    define l_cnt like type_file.num5

    if g_action_choice = "version_add" then
        let g_cgb.cgb02 = sfmt("%1",g_cgb.cgb02 + 1) using '<<<<<'
        let g_cgb.cgb05 = g_cgb02_t
    end if

    input by name g_cgb.* without defaults

        before input
            call cgoi100_set_entry(p_cmd)
            call cgoi100_set_no_entry(p_cmd)

        after field cgb01
            if not cl_null(g_cgb.cgb01) then
                if p_cmd = 'a' or (p_cmd = 'u' and g_cgb.cgb01!=g_cgb01_t) then
                    # 重复检查
                    select count(*) into l_cnt from cgb_file
                     where cgb01 = g_cgb.cgb01 and cgb02 = g_cgb.cgb02
                    if l_cnt > 0 then
                        call cl_err(g_cgb.cgb01,-239,0)
                        let g_cgb.cgb01 = g_cgb01_t
                        display by name g_cgb.cgb01
                        next field cgb01
                    end if
                end if
            end if
        
        after input
            # 空值检查
        
        on action about
            call cl_about()
 
        on action controlg
            call cl_cmdask()
 
        on action help
            call cl_show_help()
 
        on idle g_idle_seconds
            call cl_on_idle()
            continue input

    end input

end function

# 查询
function cgoi100_q()
    let g_row_count = 0
    let g_cgb.cgb01 = ""
    let g_cgb.cgb02 = ""

    call cl_navigator_setting(g_curs_index, g_row_count)
    message ""
    display ' ' to cnt

    call cgoi100_curs()
    if int_flag then
        let int_flag = 0
        clear form
        return
    end if

    open cgoi100_count
    fetch cgoi100_count into g_row_count
    display g_row_count to cnt

    open cgoi100_curs
    if sqlca.sqlcode then
        call cl_err(g_cgb.cgb01,sqlca.sqlcode,0)
        initialize g_cgb.* to null
    else
        call cgoi100_fetch('F')
    end if
end function
# 切换上下笔
function cgoi100_fetch(p_flag)
    define p_flag like type_file.chr1
    define l_abso like type_file.num10

    case    p_flag
        when 'N' fetch next cgoi100_curs into g_cgb.cgb01,g_cgb.cgb02
        when 'P' fetch previous cgoi100_curs into g_cgb.cgb01,g_cgb.cgb02
        when 'F' fetch first cgoi100_curs into g_cgb.cgb01,g_cgb.cgb02
        when 'L' fetch last cgoi100_curs into g_cgb.cgb01,g_cgb.cgb02
        when '/'
            if not g_no_ask then
                call cl_getmsg('fetch',g_lang) returning g_msg
                let int_flag = 0  ######add for prompt bug
    
                prompt g_msg clipped,': ' for g_jump
                    on idle g_idle_seconds
                        call cl_on_idle()
    
                    on action about         #mod-4c0121
                        call cl_about()      #mod-4c0121
    
                    on action help          #mod-4c0121
                        call cl_show_help()  #mod-4c0121
    
                    on action controlg      #mod-4c0121
                        call cl_cmdask()     #mod-4c0121
    
                end prompt
                if int_flag then
                    let int_flag = 0
                    let g_jump = g_curs_index     #no.fun-5c0121
                    exit case
                end if
            end if
            fetch absolute g_jump cgoi100_curs into g_cgb.cgb01,g_cgb.cgb02
            let g_no_ask = false
    end case
    if sqlca.sqlcode then
        initialize g_cgb.* to null
        let g_cgb.cgb01 = null
        let g_cgb.cgb02 = null
        call cl_err(g_cgb.cgb01,sqlca.sqlcode,0)
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
    select * into g_cgb.* from cgb_file
     where cgb01 = g_cgb.cgb01 and cgb02 = g_cgb.cgb02

    if sqlca.sqlcode then
        call cl_err3("sel","cgb_file",g_cgb.cgb01,"",SQLCA.sqlcode,"","",0)
    else
        call cgoi100_show()
    end if  
end function

function cgoi100_show()
    define l_cnt integer
    define l_str string

    let g_cgb_t.* = g_cgb.*

    display by name g_cgb.*

    # 显示编译成功函数笔数
    # TODO
    let l_cnt = 0
    select count(*) into l_cnt from cgc_file
     where cgc01 = g_cgb.cgb01 and cgc02 = g_cgb.cgb02
       and cgc06 = '2'
    display sfmt("测试成功：%1",l_cnt) to Pass

    let l_cnt = 0
    select count(*) into l_cnt from cgc_file
     where cgc01 = g_cgb.cgb01 and cgc02 = g_cgb.cgb02
       and cgc06 = '3'
    display sfmt("测试失败：%1",l_cnt) to UnPass

    let l_cnt = 0
    select count(*) into l_cnt from cgc_file
     where cgc01 = g_cgb.cgb01 and cgc02 = g_cgb.cgb02
       and cgc06 = '1'
    display sfmt("未测试：%1",l_cnt) to UnTest

    call cgoi100_b_fill()

end function
function cgoi100_u()
    define l_cgc10  like cgc_file.cgc10


    if g_cgb.cgb01 is null or g_cgb.cgb02 is null then
        call cl_err('',-400,0)
        return
    end if

    message ''
    let g_cgb01_t = g_cgb.cgb01
    let g_cgb02_t = g_cgb.cgb02

    begin work
    open cgoi100_curl using g_cgb.cgb01,g_cgb.cgb02
    if sqlca.sqlcode then
        call cl_err('open cgb_file',sqlca.sqlcode,1)
        return
    end if

    fetch cgoi100_curl into g_cgb.*
    if sqlca.sqlcode then
        call cl_err('open cgb_file',sqlca.sqlcode,1)
        return
    end if

    let g_cgb01_t = g_cgb.cgb01
    let g_cgb02_t = g_cgb.cgb02

    call cgoi100_show()

    while true
        call cgoi100_i('u')
        if int_flag then
            let int_flag = 0
            call cl_err('',9001,0)
            exit while
        end if
    
        # 进版
        if g_action_choice = 'version_add' then
            # 压缩当前版本
            if not cgoi100_zip(g_cgb.cgb01,g_cgb02_t) then
                call cl_err('压缩文件失败','!',1)
                rollback work
                close cgoi100_curl
                return
            end if
            # 复制cgc_file 资料 
            delete from x
            insert into x select * from cgc_file where cgc01 = g_cgb01_t and cgc02 = g_cgb02_t
            let l_cgc10 = current year  to second
            update x set cgc02 = g_cgb.cgb02,cgc06 ='1',
                         cgc07 = g_user ,cgc08 = l_cgc10,
                         cgc09 = '',cgc10 = ''
            insert into cgc_file select * from x

        end if

        update cgb_file set cgb_file.* = g_cgb.*
        where cgb01 = g_cgb.cgb01 and cgb02 = g_cgb02_t
        
        if sqlca.sqlcode then
            call cl_err3("upd","cgb_file",g_cgb01_t,"",sqlca.sqlcode,"","",1)
            continue while
        end if

        exit while

    end while
    close cgoi100_curl
    commit work
    call cgoi100_show()

end function
function cgoi100_r()

    if g_cgb.cgb01 is null or g_cgb.cgb02 is null then
        call cl_err('',-400,0)
        return
    end if

    begin work

    open cgoi100_curl using g_cgb.cgb01,g_cgb.cgb02
    fetch cgoi100_curl into g_cgb.*
    if sqlca.sqlcode then
        call cl_err(g_cgb.cgb01,sqlca.sqlcode,0)
        return
    end if

    call cgoi100_show()

    if cl_delete() then
        delete from cgb_file
         where cgb01 = g_cgb.cgb01
           and cgb02 = g_cgb.cgb02
        if sqlca.sqlcode then
            call cl_err3("del","cgb_file",g_cgb.cgb01||g_cgb.cgb02,"",sqlca.sqlcode,"","del zz",0)   #no.fun-660081
            rollback work
        end if

        delete from cgc_file
         where cgc01 = g_cgb.cgb01
           and cgc02 = g_cgb.cgb02
        
        #备份文件
        if not cgoi100_zip(g_cgb.cgb01,g_cgb.cgb02) then
            if not cl_confirm("cgo-005") then
                rollback work
                return
            end if
        end if
        
        # 是否继续删除文件
        if cl_confirm('cgo-002') then
            if not cgoi100_del_code(g_cgb.cgb01) then
                if not cl_confirm('cgo-003') then
                    rollback work
                    return
                end if
            end if
            if not cgoi100_del(g_cgb.cgb01) then
                if not cl_confirm('cgo-004') then
                    rollback work
                    return
                end if
            end if
        end if
        
        clear form
        initialize g_cgb.* to null
        open cgoi100_count
        if status then
            close cgoi100_curl
            close cgoi100_count
            commit work
            return
        end if
        fetch cgoi100_count into g_row_count
        if status or (cl_null(g_row_count) or  g_row_count = 0 ) then
            close cgoi100_curl
            close cgoi100_count
            commit work
            return
        end if
        
        display g_row_count to cnt
        open cgoi100_curs

        if g_curs_index = g_row_count + 1 then
            let g_jump = g_row_count
            call cgoi100_fetch("L")
        else
            let g_jump = g_curs_index
            let g_no_ask = true
            call cgoi100_fetch("/")
        end if
    end if

    close cgoi100_curl
    commit work

end function
function cgoi100_b_fill()

    declare b_fill_cur1 cursor for
        select cgb02,cgb03,cgb04,cgb05,cgb06,cgb07,cgb08,cgb09,cgb10
          from cgb_file where cgb01 = g_cgb.cgb01
    let g_cnt = 1
    call g_cgb_1.clear()
    foreach b_fill_cur1 into g_cgb_1[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("b_fill_cur1",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_cgb_1.deleteElement(g_cnt)

    declare b_fill_cur2 cursor for
        select cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,cgc11,cgc12
          from cgc_file where cgc01 = g_cgb.cgb01 and cgc02 = g_cgb.cgb02
    let g_cnt = 1
    call g_cgc.clear()
    foreach b_fill_cur2 into g_cgc[g_cnt].*
        if sqlca.sqlcode then
            call cl_err("b_fill_cur2",sqlca.sqlcode,1)
            exit foreach
        end if
        let g_cnt = g_cnt + 1
    end foreach
    call g_cgc.deleteElement(g_cnt)
    let g_cnt = g_cnt - 1    

end function
function cgoi100_bp(p_ud)
    define p_ud     like type_file.chr1
    define l_index integer

    if p_ud <> 'G' then
        return
    end if
    let g_action_choice = " "

    call cl_set_act_visible("accept,cancel", false)

    dialog
        display array g_cgb_1 to s_cgb.* attribute(count=g_cgb_1.getLength())

            before display
                let l_ac = arr_curr()

            on action accept
                display 'g_cgb_1'||l_ac
        end display
        display array g_cgc to s_cgc.* attribute(count=g_cgc.getLength())

            before display
                let l_ac = arr_curr()
            
            on action accept
                display 'g_cgc'||l_ac
                let g_cmd = "cgoi120 "
                let g_cmd = g_cmd , " \" cgc01='",g_cgb.cgb01,"' and cgc02='",g_cgb.cgb02,"'\""
                call cl_cmdrun_wait(g_cmd)
        end display

        before dialog
            call cl_navigator_setting(g_curs_index, g_row_count)

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()
            let g_action_choice = 'locale'
            exit dialog

        on action insert
            let g_action_choice="insert"
            exit dialog

        on action query
            let g_action_choice="query"
            exit dialog

        on action delete
            let g_action_choice="delete"
            exit dialog

        on action modify
            let g_action_choice="modify"
            exit dialog

        on action first
            call cgoi100_fetch('F')
            call cl_navigator_setting(g_curs_index, g_row_count)
            accept dialog

        on action previous
            let g_action_choice="previous"
            call cgoi100_fetch('P')
            call cl_navigator_setting(g_curs_index, g_row_count)
            accept dialog

        on action jump
            let g_action_choice="jump"
            call cgoi100_fetch('/')
            call cl_navigator_setting(g_curs_index, g_row_count)
            accept dialog

        on action next
            let g_action_choice="next"
            call cgoi100_fetch('N')
            call cl_navigator_setting(g_curs_index, g_row_count)
            accept dialog   

        on action last
            let g_action_choice="last"
            call cgoi100_fetch('L')
            call cl_navigator_setting(g_curs_index, g_row_count)
            accept dialog
        
        on action help
            let g_action_choice="help"
            exit dialog

        on action exit
            let g_action_choice="exit"
            exit dialog

        on action cancel
            let g_action_choice="exit"
            exit dialog

        on action controlg
            let g_action_choice="controlg"
            exit dialog
        
        on idle g_idle_seconds
            call cl_on_idle()
            continue dialog
        
        # 进版本
        on action version_add
            let g_action_choice="version_add"
            exit dialog
        
        on action compile
            let g_action_choice="compile"
            exit dialog
        
        on action test
            let g_action_choice = "test"
            exit dialog

        on action about
            call cl_about()
        
        after dialog
            continue dialog

    end dialog
    call cl_set_act_visible("accept,cancel", true)

end function

function cgoi100_set_entry(p_cmd)
    define p_cmd like type_file.chr1

    if p_cmd = 'u' then
        call cl_set_comp_entry("cgb01",false)
    end if 
    display "$GO为go编译命令；$GCC为gcc编译命令；$WS为代码工作目录；$OUT为输出二进制文件目录；$THIS为当前lib名称" to tips
end function

function cgoi100_set_no_entry(p_cmd)
    define p_cmd like type_file.chr1

    if p_cmd = 'a' then
        call cl_set_comp_entry("cgb01",true)
    end if
end function

# 编译
function cgoi100_compile()
    define l_tok base.StringTokenizer 
    define l_cmd,l_str string
    define result,l_cnt,l_idx integer

    whenever error continue

    if cl_null(g_cgb.cgb01) or cl_null(g_cgb.cgb02) then
        call cl_err('',-400,0)
        return
    end if

    # 先更新为失败状态
    let g_cgb.cgb09 = g_user
    let g_cgb.cgb10 = current year to second
    update cgb_file set cgb03 = 2,
        cgb09 = g_cgb.cgb09,cgb10 = g_cgb.cgb10
     where cgb01 = g_cgb.cgb01 and cgb02 = g_cgb.cgb02
    if sqlca.sqlcode then
        call cl_err("upd cgb03",sqlca.sqlcode,1)
        return
    end if  

    # 计算命令总笔数
    let l_idx = 1
    let l_cnt = 0
    let l_cmd = g_cgb.cgb06
    while l_idx > 0
        call l_cmd.getIndexOf("\n",l_idx+1) returning l_idx
        let l_cnt = l_cnt + 1
    end while

    call cl_progress_bar(l_cnt+1)

    # 开始执行编译命令
    let l_idx = 1
    let l_tok = base.StringTokenizer.create(g_cgb.cgb06,"\n")
    while l_tok.hasMoreTokens()
        let l_cmd = l_tok.nextToken()
        let l_cmd = cgoi100_replace(l_cmd)
        call cl_progressing(sfmt("当前%1条命令：%2",l_idx,l_cmd))
        run l_cmd in line mode returning result
        let l_idx = l_idx + 1
        if result / 256 <> 0 then
            display l_cmd
            call cl_err(l_cmd,'!',1)
            return
        end if
    end while
    call cl_progressing("编译完成")

    let g_cgb.cgb09 = g_user
    let g_cgb.cgb10 = current year to second
    update cgb_file set cgb03 = 3,
        cgb09 = g_cgb.cgb09,cgb10 = g_cgb.cgb10
     where cgb01 = g_cgb.cgb01 and cgb02 = g_cgb.cgb02
    if sqlca.sqlcode then
        call cl_err("upd cgb03",sqlca.sqlcode,1)
        return
    end if
    let g_cgb.cgb03 = '3'

    message "编译成功"
    display by name g_cgb.cgb03,g_cgb.cgb09,g_cgb.cgb10
    call cgoi100_show()
end function


function cgoi100_replace(p_str)
    define p_str,l_str string
    define l_cga record like cga_file.*

    select * into l_cga.* from cga_file
    if sqlca.sqlcode then
        call cl_err("sel cga",sqlca.sqlcode,1)
        return p_str
    end if
    let l_str = cl_replace_str(p_str,"$GO",l_cga.cga01)
    let l_str = cl_replace_str(l_str,"$GCC",l_cga.cga02)
    let l_str = cl_replace_str(l_str,"$WS",l_cga.cga03)
    let l_str = cl_replace_str(l_str,"$OUT",l_cga.cga04)
    let l_str = cl_replace_str(l_str,"$THIS",g_cgb.cgb01)
    let l_str = cl_replace_str(l_str,"$BAK",l_cga.cga05)
    return l_str
end function

# 压缩当前代码未压缩包
function cgoi100_zip(p_cgb01,p_cgb02)
    define p_cgb01  like cgb_file.cgb01
    define p_cgb02  like cgb_file.cgb02
    define result   integer

    run cgoi100_replace(
        sfmt("tar -czvf $BAK/%1 $WS/$THIS",cgoi100_zip_name(p_cgb01,p_cgb02))
        ) in line mode returning result
    if result / 256 <> 0 then
        return false
    end if
    return true
end function

# 解压当前代码未压缩包
function cgoi100_unzip(p_cgb01,p_cgb02)
    define p_cgb01  like cgb_file.cgb01
    define p_cgb02  like cgb_file.cgb02
    define result   integer

    run cgoi100_replace(
        sfmt("tar -xzvf $BAK/%1 $WS/$THIS",cgoi100_zip_name(p_cgb01,p_cgb02))
        ) in line mode returning result
    if result / 256 <> 0 then
        return false
    end if
    return true

end function

# 删除当前代码
function cgoi100_del_code(p_cgb01)
    define p_cgb01  like cgb_file.cgb01
    define result   integer

    run cgoi100_replace("rm -rf $WS/$THIS") in line mode returning result

    return result/256 == 0
end function

# 删除当前编译文件及文件夹
function cgoi100_del(p_cgb01)
    define p_cgb01  like cgb_file.cgb01
    define result   integer

    run cgoi100_replace("rm -rf $OUT/$THIS") in line mode returning result
    if result/256 <> 0 then
        return false
    end if
    run cgoi100_replace("rm $CGO/42m/lib$THIS.so")  in line mode returning result
    return result/256 == 0
end function

# 压缩包名称
function cgoi100_zip_name(p_cgb01,p_cgb02)
    define p_cgb01  like cgb_file.cgb01
    define p_cgb02  like cgb_file.cgb02
    
    return sfmt("%1_v_%2.tar.gz",p_cgb01,p_cgb02)
end function


function cgoi100_test()
    define l_sql string
    define l_cgc01  like cgc_file.cgc01
    define l_cgc04  like cgc_file.cgc04

    if cl_null(g_cgb.cgb01) or cl_null(g_cgb.cgb02) then
        call cl_err('',-400,0)
        return
    end if

    let l_sql = "select cgc01,cgc04 from cgc_file where cgc01 ='",g_cgb.cgb01,"'",
                " and cgc02 = '",g_cgb.cgb02,"' "
    prepare cgoi100_test_p from l_sql
    declare cgoi100_test_cl cursor for cgoi100_test_p

    foreach cgoi100_test_cl into l_cgc01,l_cgc04
        if sqlca.sqlcode then
            call cl_err("cgoi100_test_cl",sqlca.sqlcode,1)
            exit foreach
        end if
        if not cgoi100_testing(l_cgc01,l_cgc04) then
            message l_cgc01||" "||l_cgc04||" 测试失败"
        end if
    end foreach

    call cgoi100_show()
end function

# 测试函数
function cgoi100_testing(p_prog,p_func)
    define p_prog,p_func varchar(1000)
    define l_cnt integer
    define l_cgb02  like cgb_file.cgb02
    define l_cgc10  like cgc_file.cgc10

    select cgb02 into l_cgb02 from cgb_file
     where cgb01 = p_prog
    if sqlca.sqlcode then
        call cl_err("sel cgb_file",sqlca.sqlcode,1)
        return false
    end if

    select count(*) into l_cnt from cgc_file
     where cgc01 = p_prog and cgc02 = l_cgb02
       and cgc04 = p_func
    if l_cnt = 0 then
        return false
    end if

    # 先更新为失败
    let l_cgc10 = current year to second
    update cgc_file set cgc06 = '3',
        cgc09 = g_user,cgc10 = l_cgc10
     where cgc01 = p_prog and cgc02 = l_cgb02
       and cgc04 = p_func
    if sqlca.sqlcode then
        call cl_err("upd cgc_file",sqlca.sqlcode,1)
        return false
    end if

    let g_cmd = "cgot100  ",p_prog," ",p_func
    message "Testing..."||p_func
    call cl_cmdrun_wait(g_cmd)
    message "Test OK"
    return true
    
end function
