# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: cimi500.4gl
# Descriptions...: 销售、计划预测维护

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

type tc_ilb record
    tc_ilb01    like tc_ilb_file.tc_ilb01,
    tc_ilb02    like tc_ilb_file.tc_ilb02,
    desc        varchar(100),
    tc_ilb03    like tc_ilb_file.tc_ilb03
end record


define  g_yy,g_mm,l_ac,g_rec_b,
        g_curs_index, g_row_count,g_jump,
        g_ac                            integer
define  g_sql,g_msg                     string
define  g_typ                           varchar(1)

define g_tc_ilb         dynamic array of tc_ilb
define g_tc_ilb_t       tc_ilb

define g_no_ask         boolean

define g_list   dynamic array of record
    yy          integer,
    mm          integer,
    typ         varchar(1)
end record

define g_sum    decimal(20,3)

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

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW cimi500_w AT 2,2 WITH FORM "cim/42f/cimi500"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
    call cl_ui_init()
    call cimi500_init()

    let g_yy = year(g_today)
    let g_mm = month(g_today)
    call cimi500_q()
    call cimi500_menu()

    close window cimi500_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

--
function cimi500_init()
    define i    integer
    define l_str    string

    for i = year(g_today) - 5 to year(g_today) + 5
        let l_str = l_str,sfmt("%1,",i)
    end for
    let l_str = l_str.subString(1,l_str.getLength()-1)
    call cl_set_combo_items("yy",l_str,l_str)
end function

function cimi500_menu()
    while true
        call cimi500_bp()
        case g_action_choice
            when "query"
                if cl_chk_act_auth() then
                    call cimi500_q()
                end if
            when "detail"
                if cl_chk_act_auth() then
                    call cimi500_b()
                end if
            when "delete"
                if cl_chk_act_auth() then
                    --call cimi500_delete()
                end if
            when "exporttoexcel"
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel1("s_tc_ilb",base.typeinfo.create(g_tc_ilb)))
                end if
            when "exit"
                exit while
        end case
    end while
end function
function cimi500_b_ask()
    input g_yy,g_mm,g_typ without defaults from yy,mm,typ

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

        on action about
            call cl_about()

        on action help
            call cl_show_help()

    end input
end function
function cimi500_q()
    define l_m1,l_m2,l_y    integer
    define l_t1,l_t2        integer
    define i,j,l            integer

    clear form
    let g_yy = year(g_today)
    let g_mm = month(g_today)
    let g_typ = null

    call cl_navigator_setting(g_curs_index, g_row_count)
    call cimi500_b_ask()
    if int_flag then
        let g_action_choice = 'exit'
        let int_flag = false
        return
    end if

    let g_sql = "select unique year(tc_ilb01),month(tc_ilb01),tc_ilb02 from tc_ilb_file where 1=1"
    if not cl_null(g_yy) then
        let g_sql = g_sql , " and year(tc_ilb01) = ",g_yy
    end if
    if not cl_null(g_mm) then
        let g_sql = g_sql , " and month(tc_ilb01) = ",g_mm
    end if
    let g_sql = g_sql," order by 1,2,3"

    if cl_null(g_yy) then
        let l_y = year(g_today)
    else
        let l_y = g_yy
    end if

    if cl_null(g_mm) then
        let l_m1 = 1
        let l_m2 = 12
    else
        let l_m1 = g_mm
        let l_m2 = g_mm
    end if

    if cl_null(g_typ) then
        let l_t1 = 1
        let l_t2 = 2
    else
        let l_t1 = g_typ
        let l_t2 = g_typ
    end if

    call g_list.clear()
    let l = 1
    for i = l_m1 to l_m2
        for j = l_t1 to l_t2
            let g_list[l].yy = l_y
            let g_list[l].mm = i
            let g_list[l].typ = j
            let l = l + 1
        end for
    end for
    let g_row_count = l - 1

    call cimi500_fetch("F")
end function

function cimi500_show()
    display g_yy, g_mm, g_typ,g_sum to yy, mm, typ, sum
    display g_curs_index , g_row_count to cnt, cn2
    call cimi500_b_fill()
end function

function cimi500_fetch(p_flag)
    define  p_flag      varchar(1)

    if g_list.getLength() == 0 then
        return
    end if

    if p_flag = '/' and not g_no_ask then
        CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
        LET INT_FLAG = false

        PROMPT g_msg CLIPPED,': ' FOR g_jump
            ON IDLE g_idle_seconds
                CALL cl_on_idle()

            ON ACTION about
                CALL cl_about()

            ON ACTION help
                CALL cl_show_help()

            ON ACTION controlg
                CALL cl_cmdask()

        END PROMPT
        IF INT_FLAG THEN
            LET INT_FLAG = false
            LET g_jump = g_curs_index
        END IF
        let g_no_ask = false
    end if

    case p_flag
        when 'N'
            let g_curs_index = g_curs_index + 1
        when 'P'
            let g_curs_index = g_curs_index - 1

        when 'F'
            let g_curs_index = 1
        when 'L'
            let g_curs_index = g_list.getLength()
        when '/'
            let g_curs_index = g_jump
    end case

    let g_yy = g_list[g_curs_index].yy
    let g_mm = g_list[g_curs_index].mm
    let g_typ = g_list[g_curs_index].typ

    call cl_navigator_setting(g_curs_index, g_row_count)

    call cimi500_show()
end function
function cimi500_b()
    define  p_cmd,l_lock_sw       varchar(1)
    define  l_ac_t,i                integer

    let g_sql = "select tc_ilb01,tc_ilb02,'',tc_ilb03 from tc_ilb_file where tc_ilb01 = ? and tc_ilb02 = ? for update"
    declare cimi500_bcl cursor from g_sql

    input array g_tc_ilb without defaults from s_tc_ilb.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)

        before input
            if g_rec_b != 0 then
                call fgl_set_arr_curr(l_ac)
            end if

        before row
            -- 刷新资料
            let p_cmd=''
            let l_ac = ARR_CURR()
            let l_lock_sw = 'N'
            if g_rec_b >= l_ac then
                begin work
                let p_cmd = 'u'
                let g_tc_ilb_t.* = g_tc_ilb[l_ac].*
                -- 设置栏位是否能够录入
                --call xxx_set_entry_b()
                --call xxx_set_no_entry_b()
                -- 刷新栏位的值
                open cimi500_bcl using g_tc_ilb_t.tc_ilb01,g_tc_ilb_t.tc_ilb02
                if status then
                    call cl_err('open cimi500_bcl',status,1)
                    let l_lock_sw = 'Y'
                else
                    fetch cimi500_bcl into g_tc_ilb[l_ac].*
                    if sqlca.sqlcode then
                        call cl_err(g_tc_ilb_t.tc_ilb01,sqlca.sqlcode,1)
                        let l_lock_sw = 'Y'
                    end if
                    let g_tc_ilb[l_ac].desc = cimi500_typ(g_tc_ilb[l_ac].tc_ilb02)
                    -- 这里可以查询一些说明栏位
                end if
                -- 刷新一些特殊栏位
                call cl_show_fld_cont()
            end if

        before insert
            -- 录入默认值
            let p_cmd = 'a'
            --call xxx_set_entry_b()
            --call xxx_set_no_entry_b()
            initialize g_tc_ilb[l_ac].* to null
            let g_tc_ilb_t.* = g_tc_ilb[l_ac].*
            call cl_show_fld_cont()
            next field tc_ilb03

        on row change
            -- 更新数据
            if int_flag then
                call cl_err('',9001,0)
                let int_flag = false
                let g_tc_ilb[l_ac].* = g_tc_ilb_t.*
                    close cimi500_bcl
                    rollback work
                exit input
            end if
            if l_lock_sw = 'Y' then
                call cl_err(g_tc_ilb[l_ac].tc_ilb01,-263,0)
                let g_tc_ilb[l_ac].* = g_tc_ilb_t.*
            else
                update tc_ilb_file set tc_ilb03 = g_tc_ilb[l_ac].tc_ilb03
                 where tc_ilb01 = g_tc_ilb_t.tc_ilb01
                if sqlca.sqlcode then
                    call cl_err3('upd','tc_ilb_file',g_tc_ilb[l_ac].tc_ilb01,'',sqlca.sqlcode,'','',1)
                    let g_tc_ilb[l_ac].* = g_tc_ilb_t.*
                else
                    commit work
                end if
            end if
            let g_sum = 0
            for i = 1 to g_tc_ilb.getLength()
                if not cl_null(g_tc_ilb[i].tc_ilb03) then
                    let g_sum = g_sum + g_tc_ilb[i].tc_ilb03
                end if
            end for
            display g_sum to sum

        after row
            let l_ac = arr_curr()
            if int_flag then
                -- 取消新增/更改
                call cl_err('',-400,0)
                let int_flag = false
                if p_cmd = 'u' then
                    -- 还原旧数据
                    let g_tc_ilb[l_ac].* = g_tc_ilb_t.*
                else
                    -- 删除旧数据
                    call g_tc_ilb.deleteElement(l_ac)
                    if g_rec_b!=0 then
                        let g_action_choice = 'detail'
                        let l_ac = l_ac_t
                    end if
                end if
                close cimi500_bcl
                rollback work
                exit input
            end if

        on action controlo
            -- 复制上一行
            if infield(tc_ilb03) and l_ac > 1 then
            let g_tc_ilb[l_ac].tc_ilb03 = g_tc_ilb[l_ac-1].tc_ilb03
                next field tc_ilb03
            end if

        on action controlr
            call cl_show_req_fields()

        on action controlf
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
function cimi500_b_fill()
    define  i,l_cnt       integer
    define  l_dat   date
    -- display 之前将当月插入空值，缺少日期的也需要插入

    let l_dat = mdy(g_mm,1,g_yy)
    for i = 1 to 30
        select count(*) into l_cnt from tc_ilb_file where tc_ilb01 = l_dat and tc_ilb02 = g_typ
        if l_cnt == 0 then
            insert into tc_ilb_file (tc_ilb01,tc_ilb02,tc_ilb03)
                values(l_dat,g_typ,0)
            if sqlca.sqlcode then
                call cl_err('ins tc_ilb',sqlca.sqlcode,1)
                return
            end if
        end if

        let l_dat = l_dat + 1
        if month(l_dat) != g_mm then
            exit for
        end if
    end for

    let g_sql = "select tc_ilb01,tc_ilb02,'',tc_ilb03 from tc_ilb_file where year(tc_ilb01) = ",g_yy," and month(tc_ilb01) = ",g_mm,
                " and tc_ilb02 = '",g_typ,"'",
                " order by tc_ilb01"
    prepare cimi500_fill_p from g_sql
    declare cimi500_fill_cur cursor for cimi500_fill_p

    call g_tc_ilb.clear()
    let i = 1
    let g_sum = 0
    foreach cimi500_fill_cur into g_tc_ilb[i].*
        if sqlca.sqlcode then
            call cl_err('cimi500_fill_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let g_tc_ilb[i].desc = cimi500_typ(g_tc_ilb[i].tc_ilb02)
        if not cl_null(g_tc_ilb[i].tc_ilb03) then
            let g_sum = g_sum + g_tc_ilb[i].tc_ilb03
        end if
        let i = i + 1
    end foreach
    call g_tc_ilb.deleteElement(i)
    let g_rec_b = i - 1
    display g_sum to sum
end function

function cimi500_bp()
    call cl_set_act_visible("accept,cancel", false)

    --call cl_navigator_setting(g_curs_index, g_row_count)
    display array g_tc_ilb to s_tc_ilb.* attribute(count=g_rec_b)

        before display
            call cl_navigator_setting(g_curs_index, g_row_count)

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
            exit display

        on action detail
            let g_action_choice = 'detail'
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

        on action controlg
            call cl_cmdask()
        on action first         call cimi500_fetch("F") accept display
        on action last          call cimi500_fetch("L") accept display
        on action next          call cimi500_fetch("N") accept display
        on action previous      call cimi500_fetch("P") accept display
        on action jump          call cimi500_fetch("/") accept display

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


--
function cimi500_typ(p_char)
    define p_char varchar(1)
    case p_char
        when '1'
            return '销售预测'
        when '2'
            return '入库预测'
        otherwise
            return ''
    end case
end function
