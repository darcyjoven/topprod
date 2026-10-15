# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cgoi100.4gl
# Descriptions...: CGo资料注册
# Date & Author..: darcy:2024/04/15

database ds

globals "../../../tiptop/config/top.global"

type cgb record like cgb_file.*
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
    cgc12     like cgc_file.cgc12,
    cgc13     like cgc_file.cgc13,
    cgc14     like cgc_file.cgc14,
    cgc15     like cgc_file.cgc15
    end record

define g_cgb_1  dynamic array of cgb
define g_cgc dynamic array of cgc
define g_cgc_t cgc
define g_cgb record like cgb_file.*
define g_cgb_t record like cgb_file.*
define g_cgb01_t    like cgb_file.cgb01
define g_cgb02_t    like cgb_file.cgb02
define g_cnt,g_curs_index,g_row_count,g_jump,l_ac,g_rec_b,l_ac_t integer
define g_sql,g_msg,g_wc,g_cmd,g_forupd_sql string
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

    let g_sql = "select * from cgb_file where cgb01=? for update"
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
    -- display "$GO为go编译命令；$GCC为gcc编译命令；$WS为代码工作目录；$OUT为输出二进制文件目录；$THIS为当前lib名称" to tips
    construct by name g_wc on cgb01,cgb02,cgb03,cgb04,cgb05,cgb06
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
    let g_sql = "select unique cgb01 from cgb_file ",
                " where ",g_wc clipped," order by cgb01"
    prepare cgoi100_prepare from g_sql
    declare cgoi100_curs 
        scroll cursor with hold for cgoi100_prepare
    
    let g_sql = "select count(*) from (select unique cgb01 from cgb_file",
                " where ",g_wc clipped," )"
    prepare cgoi100_precount from g_sql
    declare cgoi100_count cursor for cgoi100_precount

end function

# 菜单
function cgoi100_menu()
    while true
        -- display "$GO为go编译命令；$GCC为gcc编译命令；$WS为代码工作目录；$OUT为输出二进制文件目录；$THIS为当前lib名称" to tips
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
            when "compile"
                if cl_chk_act_auth() then
                    call cgoi100_compile()
                end if
            when "test"
                if cl_chk_act_auth() then
                    call cgoi100_test()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call cgoi100_b()
                end if
        end case
    end while
end function

# 增加
function cgoi100_a()
    message ""
    clear form
    initialize g_cgb.* like cgb_file.*

    let g_cgb.cgb02 = g_today 
    let g_cgb.cgb04 = g_today 
    let g_cgb.cgb06 = '1'

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
            select cgb01 into g_cgb.cgb01,g_cgb.cgb02 from cgb_file
             where cgb01 = g_cgb.cgb01 
        end if
        exit while
    end while

end function

# 新增
function cgoi100_i(p_cmd)
    define p_cmd like type_file.chr1
    define l_cnt like type_file.num5

    input by name g_cgb.* without defaults

        before input
            call cgoi100_set_entry(p_cmd)
            call cgoi100_set_no_entry(p_cmd)

        after field cgb01
            if not cl_null(g_cgb.cgb01) then
                if p_cmd = 'a' or (p_cmd = 'u' and g_cgb.cgb01!=g_cgb01_t) then
                    # 重复检查
                    select count(*) into l_cnt from cgb_file
                     where cgb01 = g_cgb.cgb01
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
        when 'N' fetch next cgoi100_curs into g_cgb.cgb01
        when 'P' fetch previous cgoi100_curs into g_cgb.cgb01
        when 'F' fetch first cgoi100_curs into g_cgb.cgb01
        when 'L' fetch last cgoi100_curs into g_cgb.cgb01
        when '/'
            if not g_no_ask then
                call cl_getmsg('fetch',g_lang) returning g_msg
                let int_flag = 0
    
                prompt g_msg clipped,': ' for g_jump
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
                    let int_flag = 0
                    let g_jump = g_curs_index
                    exit case
                end if
            end if
            fetch absolute g_jump cgoi100_curs into g_cgb.cgb01
            let g_no_ask = false
    end case
    if sqlca.sqlcode then
        initialize g_cgb.* to null
        let g_cgb.cgb01 = null
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
     where cgb01 = g_cgb.cgb01

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
    call cgoi100_b_fill() 
end function
function cgoi100_u()
    define l_cgc10  like cgc_file.cgc10


    if g_cgb.cgb01 is null then
        call cl_err('',-400,0)
        return
    end if

    message ''
    let g_cgb01_t = g_cgb.cgb01

    begin work
    open cgoi100_curl using g_cgb.cgb01
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

    call cgoi100_show()

    while true
        call cgoi100_i('u')
        if int_flag then
            let int_flag = 0
            call cl_err('',9001,0)
            exit while
        end if

        update cgb_file set cgb_file.* = g_cgb.*
        where cgb01 = g_cgb.cgb01 
        
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

    if g_cgb.cgb01 is null then
        call cl_err('',-400,0)
        return
    end if

    begin work

    open cgoi100_curl using g_cgb.cgb01
    fetch cgoi100_curl into g_cgb.*
    if sqlca.sqlcode then
        call cl_err(g_cgb.cgb01,sqlca.sqlcode,0)
        return
    end if

    call cgoi100_show()

    if cl_delete() then
        delete from cgb_file
         where cgb01 = g_cgb.cgb01
        if sqlca.sqlcode then
            call cl_err3("del","cgb_file",g_cgb.cgb01||g_cgb.cgb02,"",sqlca.sqlcode,"","del zz",0)   #no.fun-660081
            rollback work
        end if

        delete from cgc_file where cgc01 = g_cgb.cgb01 
        
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

    declare b_fill_cur2 cursor for
        select cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,cgc11,cgc12,cgc13,cgc14,cgc15
          from cgc_file where cgc01 = g_cgb.cgb01
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
        display array g_cgc to s_cgc.* attribute(count=g_cgc.getLength())

            before display
                let l_ac = arr_curr()
            
            on action accept
                let g_action_choice="detail"
                exit dialog

            on action detail
                let g_action_choice="detail"
                let l_ac = 1
                exit dialog
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
    --display "$GO为go编译命令；$GCC为gcc编译命令；$WS为代码工作目录；$OUT为输出二进制文件目录；$THIS为当前lib名称" to tips
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
    define l_cga record like cga_file.*
    define l_ch     base.Channel
    define l_ex     varchar(2000)

    whenever error continue

    if cl_null(g_cgb.cgb01) or cl_null(g_cgb.cgb02) then
        call cl_err('',-400,0)
        return
    end if

    # 先更新为失败状态
    update cgb_file set cgb06 = '3',cgb05=g_today where cgb01 = g_cgb.cgb01
    if sqlca.sqlcode then
        call cl_err("upd cgb06",sqlca.sqlcode,1)
        return
    end if

    select * into l_cga.* from cga_file
    if sqlca.sqlcode then
        call cl_err("sel cga",sqlca.sqlcode,0)
        let g_success = 'N'
        return
    end if 

    -- 进度条
    call cl_progress_bar(5)
    -- echo "1. go 程序编译..."
    -- cd $CGO/code/parttrack && golang build -mod=vendor -buildvcs=false -buildmode=c-shared -o $CGO/out/libparttrackgo.so
    call cl_progressing("1/5 go 程序编译……")
    let l_cmd = "cd ",l_cga.cga03 clipped ,"/",g_cgb.cgb01 clipped," && "
    let l_cmd = l_cmd,l_cga.cga01 clipped ," build "
    if l_cga.cga06 = 'Y' then
        let l_cmd = l_cmd," -mod=vendor "
    end if
    let l_cmd = l_cmd,sfmt("-buildvcs=false -buildmode=c-shared -o %1/lib%2go.so 2>&1",l_cga.cga04,g_cgb.cgb01)
    display l_cmd
    let l_ch = base.Channel.create()
    call l_ch.openPipe(l_cmd,"r")
    let l_ex = l_ch.readline()
    if not cl_null(l_ex) then
        call cl_err(sfmt("命令:%1\n报错信息:%2\n",l_cmd,l_ex),"aic-060",1)
        goto _exit
    end if

    -- echo "2. link -s 链接 go.so 到 $FGLDIR/lib..."
    -- rm -f $FGLDIR/lib/libparttrackgo.so && ln -s /u1/topprod/topcust/cgo/out/libparttrackgo.so $FGLDIR/lib/libparttrackgo.so
    call cl_progressing("2/5 link -s 链接 go.so 到 $FGLDIR/lib……")
    let l_ex = ""
    let l_cmd = sfmt(
        "rm -f $FGLDIR/lib/lib%1go.so && ln -s %2/lib%3go.so $FGLDIR/lib/lib%4go.so 2>&1",
        g_cgb.cgb01,
        l_cga.cga04,
        g_cgb.cgb01,
        g_cgb.cgb01)
    display l_cmd
    let l_ch = base.Channel.create()
    call l_ch.openPipe(l_cmd,"r")
    let l_ex = l_ch.readline()
    if not cl_null(l_ex) then
        call cl_err(sfmt("命令:%1\n报错信息:%2\n",l_cmd,l_ex),"aic-060",1)
        goto _exit
    end if

    -- echo "3. gcc 编译 c 文件..."
    -- gcc -c -I$FGLDIR/include -I$CGO/out -fPIC -o $CGO/code/parttrack/bin/parttrack.o $CGO/code/parttrack/bin/export.c
    call cl_progressing("3/5 gcc 编译 c 文件……")
    let l_ex = ""
    let l_cmd = sfmt(
        "%1 -c -I$FGLDIR/include -I%2 -fPIC -o %3/%4/bin/%5.o %6/%7/bin/export.c  2>&1",
        l_cga.cga02,
        l_cga.cga04,
        l_cga.cga03,
        g_cgb.cgb01, 
        g_cgb.cgb01,
        l_cga.cga03,
        g_cgb.cgb01)
    display l_cmd
    let l_ch = base.Channel.create()
    call l_ch.openPipe(l_cmd,"r")
    let l_ex = l_ch.readline()
    if not cl_null(l_ex) then
        call cl_err(sfmt("命令:%1\n报错信息:%2\n",l_cmd,l_ex),"aic-060",1)
        goto _exit
    end if

    -- echo "4. gcc 链接o文件..."
    -- gcc -shared -o $CGO/out/libparttrack.so $CGO/code/parttrack/bin/parttrack.o  -L $FGLDIR/lib -lfgl -lparttrackgo
    call cl_progressing("4/5 gcc 链接o文件……")
    let l_ex = ""
    let l_cmd = sfmt(
        "%1 -shared -o %2/lib%3.so %4/%5/bin/%6.o  -L $FGLDIR/lib -lfgl -l%7go  2>&1",
        l_cga.cga02,
        l_cga.cga04,
        g_cgb.cgb01,
        l_cga.cga03,
        g_cgb.cgb01,
        g_cgb.cgb01,
        g_cgb.cgb01)
    display l_cmd
    let l_ch = base.Channel.create()
    call l_ch.openPipe(l_cmd,"r")
    let l_ex = l_ch.readline()
    if not cl_null(l_ex) then
        call cl_err(sfmt("命令:%1\n报错信息:%2\n",l_cmd,l_ex),"aic-060",1)
        goto _exit
    end if

    -- echo "5. link -s 链接so文件到目的目录..."
    -- rm -f $CGO/42m/libparttrack.so && ln -s /u1/topprod/topcust/cgo/out/libparttrack.so $CGO/42m/libparttrack.so
    call cl_progressing("5/5 link -s 链接so文件到目的目录……")
    let l_ex = ""
    let l_cmd = sfmt(
        "rm -f %1/lib%2.so && ln -s %3/lib%4.so %5/lib%6.so  2>&1",
        l_cga.cga05,
        g_cgb.cgb01,
        l_cga.cga04,
        g_cgb.cgb01,
        l_cga.cga05,
        g_cgb.cgb01)
    display l_cmd
    let l_ch = base.Channel.create()
    call l_ch.openPipe(l_cmd,"r")
    let l_ex = l_ch.readline()
    if not cl_null(l_ex) then
        call cl_err(sfmt("命令:%1\n报错信息:%2\n",l_cmd,l_ex),"aic-060",1)
        goto _exit
    end if 
    
    update cgb_file set cgb06 = '2'
     where cgb01 = g_cgb.cgb01 
    if sqlca.sqlcode then
        call cl_err("upd cgb03",sqlca.sqlcode,1)
        return
    end if
    let g_cgb.cgb05 = g_today
    let g_cgb.cgb06 = '2'

    message "编译成功"
    display by name g_cgb.cgb05,g_cgb.cgb06
    call cgoi100_show()
    label _exit:
    call cl_safe_close_progress_bar()

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


function cgoi100_test() 
    define l_cmd    string

    if cl_null(g_cgb.cgb01)  then
        call cl_err('',-400,0)
        return
    end if

    if g_cgc.getLength() == 0 or g_cgc.getLength() < l_ac then
        call cl_err('',-400,0)
        return
    end if

    let l_cmd = g_cgc[l_ac].cgc07
    if cl_null(l_cmd) then
        call cl_err("测试命令为空","!",1)
        return
    end if
    call cl_cmdrun_wait(l_cmd)

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

function cgoi100_b()
    define p_cmd    varchar(1)
    define l_n      integer

    define l_allow_insert,l_allow_delete boolean

    let g_action_choice = ""
    let g_forupd_sql = "select cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,cgc11,cgc12,cgc13,cgc14,cgc15",
                       "  from cgc_file where cgc01=? for update"
    let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare cgoi100_bcl cursor from g_forupd_sql

    let l_allow_insert = cl_detail_input_auth('insert')
    let l_allow_delete = cl_detail_input_auth('delete')

    input array g_cgc without defaults from s_cgc.*
        attribute (count=g_rec_b,maxcount=g_max_rec,unbuffered,
                   insert row = l_allow_insert,delete row=l_allow_delete,append row=l_allow_insert) 
 
        before input
            if g_rec_b != 0 then
                call fgl_set_arr_curr(l_ac)
            end if
 
        before row
            let p_cmd='' 
            let l_ac = arr_curr()
            let l_n  = arr_count()
    
            if g_rec_b>=l_ac then
                begin work
                let p_cmd='u'
                let g_cgc_t.* = g_cgc[l_ac].*  #backup
                open cgoi100_bcl using g_cgb.cgb01
                if status then
                    call cl_err("open cgoi100_bcl:", status, 1)
                else 
                    fetch cgoi100_bcl into g_cgc[l_ac].* 
                    if sqlca.sqlcode then
                        call cl_err(g_cgb.cgb01,sqlca.sqlcode,1)
                    end if
                end if
            end if
 
        before insert
            let l_n = arr_count()
            let p_cmd='a'                    
            initialize g_cgc[l_ac].* to null 
            select max(cgc02) into g_cgc[l_ac].cgc02 from cgc_file
             where cgc01 = g_cgb.cgb01
            if not cl_null(g_cgc[l_ac].cgc02) then
                let g_cgc[l_ac].cgc02 = g_cgc[l_ac].cgc02 + 1
            else
                let g_cgc[l_ac].cgc02 = 1
            end if
            let g_cgc[l_ac].cgc05 = g_today
            let g_cgc_t.* = g_cgc[l_ac].*
            call cl_show_fld_cont()
            next field cgc02
 
        after insert
            display "after insert" 
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                close cgoi100_bcl
                cancel insert
            end if
            begin work                    #fun-680010
    
            insert into cgc_file(cgc01,cgc02,cgc03,cgc04,cgc05,cgc06,cgc07,cgc08,cgc09,cgc10,
                                cgc11,cgc12,cgc13,cgc14,cgc15)
                values(g_cgb.cgb01,g_cgc[l_ac].cgc02,g_cgc[l_ac].cgc03,g_cgc[l_ac].cgc04,g_cgc[l_ac].cgc05,
                        g_cgc[l_ac].cgc06,g_cgc[l_ac].cgc07,g_cgc[l_ac].cgc08,g_cgc[l_ac].cgc09,g_cgc[l_ac].cgc10,
                        g_cgc[l_ac].cgc11,g_cgc[l_ac].cgc12,g_cgc[l_ac].cgc13,g_cgc[l_ac].cgc14,g_cgc[l_ac].cgc15)
            if sqlca.sqlcode then
                call cl_err3("ins","cgc_file",g_cgb.cgb01,"",sqlca.sqlcode,"","",1)
                rollback work
                cancel insert
            else
                commit work   
            end if 
 
        before delete                            #是否取消單身
            if g_cgb.cgb01 is not null then
                if not cl_delete() then
                rollback work      #fun-680010
                cancel delete
                end if 
                delete from cgc_file where cgc01 = g_cgb.cgb01 and cgc02 = g_cgc[l_ac].cgc02
                if sqlca.sqlcode then
                    call cl_err3("del","cgc_file",g_cgb.cgb01,"",sqlca.sqlcode,"","",1)
                    rollback work
                    cancel delete
                    exit input
                end if
            end if
 
        on row change
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                let g_cgc[l_ac].* = g_cgc_t.*
                close cgoi100_bcl
                rollback work
                exit input
            end if 
            let g_cgc[l_ac].cgc06 = g_today
            update cgc_file set cgc02=g_cgc[l_ac].cgc02,
                                cgc03=g_cgc[l_ac].cgc03,
                                cgc07=g_cgc[l_ac].cgc07,
                                cgc04=g_cgc[l_ac].cgc04,
                                cgc05=g_cgc[l_ac].cgc05,
                                cgc06=g_cgc[l_ac].cgc06,
                                cgc07=g_cgc[l_ac].cgc07,
                                cgc08=g_cgc[l_ac].cgc08,
                                cgc09=g_cgc[l_ac].cgc09,
                                cgc10=g_cgc[l_ac].cgc10,
                                cgc11=g_cgc[l_ac].cgc11,
                                cgc12=g_cgc[l_ac].cgc12,
                                cgc13=g_cgc[l_ac].cgc13,
                                cgc14=g_cgc[l_ac].cgc14,
                                cgc15=g_cgc[l_ac].cgc15
            where cgc01 = g_cgb.cgb01
            if sqlca.sqlcode then
                call cl_err3("upd","cgc_file",g_cgb.cgb01,"",sqlca.sqlcode,"","",1)  #no.fun-660131
                rollback work
                let g_cgc[l_ac].* = g_cgc_t.* 
            end if
 
        after row
            let l_ac = arr_curr()
    
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = 0
                if p_cmd='u' then
                    let g_cgc[l_ac].* = g_cgc_t.* 
                else
                    call g_cgc.deleteelement(l_ac)
                    if g_rec_b != 0 then
                        let g_action_choice = "detail"
                        let l_ac = l_ac_t
                    end if 
                end if
                close cgoi100_bcl
                rollback work
                exit input
            end if
            let l_ac_t = l_ac
            close cgoi100_bcl
            commit work
 
        on action controlo
            if infield(cgc01) and l_ac > 1 then
                let g_cgc[l_ac].* = g_cgc[l_ac-1].*
                next field cgc01
            end if
 
        on action controlp
 
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
 
    close cgoi100_bcl
    commit work
end function
