# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cecq034.4gl
# Descriptions...: 器件损耗套数计算
# Date & Author..: darcy 2026-07-20

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

type header record
    tc_shi02    like tc_shi_file.tc_shi02,
    tc_shi03    like tc_shi_file.tc_shi03,
    tc_shi04    like tc_shi_file.tc_shi04,
    tc_shi06    like tc_shi_file.tc_shi06,
    gen02       like gen_file.gen02,
    last_sdate  date,
    last_edate  date
end record
type tc_shi record
    tc_shi07        like tc_shi_file.tc_shi07,
    ima02           like ima_file.ima02,
    ima021          like ima_file.ima021,
    tc_shi08        like tc_shi_file.tc_shi08,
    tc_shi09        like tc_shi_file.tc_shi09,
    tc_shi10        like tc_shi_file.tc_shi10,
    tc_shi11        like tc_shi_file.tc_shi11,
    tc_shi12        like tc_shi_file.tc_shi12,
    tc_shi13        like tc_shi_file.tc_shi13,
    tc_shi14        like tc_shi_file.tc_shi14,
    tc_shi15        like tc_shi_file.tc_shi15,
    tc_shi16        like tc_shi_file.tc_shi16,
    tc_shi17        like tc_shi_file.tc_shi17,
    diff            like tc_shi_file.tc_shi17
end record

type tc_shg record
    tc_shg05        like tc_shg_file.tc_shg05,
    dima02          like ima_file.ima02,
    dima021         like ima_file.ima021,
    tc_shg06        like tc_shg_file.tc_shg06,
    tc_shg07        like tc_shg_file.tc_shg07,
    tc_shg08        like tc_shg_file.tc_shg08,
    tc_shg09        like tc_shg_file.tc_shg09
end record

type tc_shh record
    tc_shh05            like tc_shh_file.tc_shh05,
    h1ima02             like ima_file.ima02,
    h1ima021            like ima_file.ima021,
    tc_shh06            like tc_shh_file.tc_shh06,
    h2ima02             like ima_file.ima02,
    h2ima021            like ima_file.ima021,
    tc_shh07            like tc_shh_file.tc_shh07,
    tc_shh08            like tc_shh_file.tc_shh08,
    tc_shh09            like tc_shh_file.tc_shh09
end record

type tc_shh_group record
    gtc_shh06           like tc_shh_file.tc_shh06,
    gima02              like ima_file.ima02,
    gima021             like ima_file.ima021,
    gtc_shh07           like tc_shh_file.tc_shh07,
    gtc_shh09           like tc_shh_file.tc_shh09
end record


define g_header header
define g_tc_shg,g_tc_shg_excel  dynamic array of tc_shg
define g_tc_shi,g_tc_shi_excel dynamic array of tc_shi
define g_tc_shh,g_tc_shh_excel dynamic array of tc_shh
define g_tc_shh_group,g_tc_shh_group_excel dynamic array of tc_shh_group

define  g_jump,g_curs_index,l_ac,g_cnt,g_row_count,
        p_row,p_col,
        g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4
        integer
define  g_wc,g_sql,g_arg1,g_msg
        string
define  g_no_ask varchar(1)

define tm record
    tc_shi02    like tc_shi_file.tc_shi02,
    tc_shi03    like tc_shi_file.tc_shi03,
    tc_shi04    like tc_shi_file.tc_shi04,
    tc_shi06    like tc_shi_file.tc_shi06
end record

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
    EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("CEC")) THEN
    EXIT PROGRAM
    END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW cecq034_w AT 2,2 WITH FORM "cec/42f/cecq034"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    call cecq034_q()
    call cecq034_menu()

    CLOSE WINDOW cecq034_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

function cecq034_menu()
    while true
        call cecq034_bp()
        case g_action_choice
            when 'query'
                call cecq034_q()
            when 'generate'
                call cecq034_generate()
            when 'exporttoexcel'
                call cl_download_by_explorer(cl_expexcel5(
                    "s_tc_shg",base.typeinfo.create(g_tc_shg_excel),
                    "s_tc_shi",base.typeinfo.create(g_tc_shi_excel),
                    "s_tc_shh",base.typeinfo.create(g_tc_shh_excel),
                    "s_tc_shh_group",base.typeinfo.create(g_tc_shh_group_excel),
                    "",null
                    ))
            when 'exit'
                exit while
        end case
    end while
end function

function cecq034_cs()

    # 查询最新的一笔记录作为默认条件

    select max(tc_shi02) into tm.tc_shi02 from tc_shi_file
    select max(tc_shi03) into tm.tc_shi03 from tc_shi_file
     where tc_shi02 = tm.tc_shi02

    input by name tm.* without defaults

        before input
            let tm.tc_shi04 = null
            let tm.tc_shi06 = null
            display by name tm.*

        on action controlp
            -- 开窗
            case
                when infield(tc_shi06)
                    call cl_init_qry_var()
                    let g_qryparam.form = 'q_gen'
                    call cl_create_qry() returning g_header.tc_shi06
                    display by name g_header.tc_shi06
                otherwise
            end case

        on action controlo

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
    if int_flag then
        return
    end if
    let g_sql = "select unique tc_shi02,tc_shi03 from tc_shi_file",
                " where 1 =1 "
    if not cl_null(tm.tc_shi02) then
        let g_sql = g_sql , " and tc_shi02 = '",tm.tc_shi02,"'"
    end if
    if not cl_null(tm.tc_shi03) then
        let g_sql = g_sql , " and tc_shi03 = '",tm.tc_shi03 clipped,"'"
    end if
    if not cl_null(tm.tc_shi04) then
        let g_sql = g_sql , " and tc_shi04 = '",tm.tc_shi04 clipped,"'"
    end if
    if not cl_null(tm.tc_shi06) then
        let g_sql = g_sql , " and tc_shi06 = '",tm.tc_shi06 clipped,"'"
    end if
    let g_sql = g_sql , " order by tc_shi02,tc_shi03"
    prepare cecq034_prepare from g_sql
    declare cecq034_curs scroll cursor with hold for cecq034_prepare

    let g_sql = "select count(*) from (",g_sql,")"
    prepare cecq034_precount from g_sql
    declare cecq034_count cursor for cecq034_precount

end function

function cecq034_q()
    display g_curs_index to cnt2
    call cl_navigator_setting(g_curs_index, g_row_count)
    initialize g_header.* to null
    call g_tc_shg.clear()
    call g_tc_shi.clear()
    call g_tc_shh.clear()
    call g_tc_shh_group.clear()
    call g_tc_shg_excel.clear()
    call g_tc_shi_excel.clear()
    call g_tc_shh_excel.clear()
    call g_tc_shh_group_excel.clear()
    call cecq034_cs()
    if int_flag then
        let int_flag = false
        return
    end if

    open cecq034_count
    fetch cecq034_count into g_row_count
    display g_row_count to cnt

    open cecq034_curs
    if sqlca.sqlcode then
        call cl_err('cecq034_curs',sqlca.sqlcode,0)
        initialize g_header.* to null
    else
        call cecq034_fetch('F')
    end if
end function

--
function cecq034_fetch(p_flag)
    define  p_flag      varchar(1)

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
        when 'N'    fetch   next            cecq034_curs into g_header.tc_shi02,g_header.tc_shi03
        when 'P'    fetch   previous        cecq034_curs into g_header.tc_shi02,g_header.tc_shi03
        when 'F'    fetch   first           cecq034_curs into g_header.tc_shi02,g_header.tc_shi03
        when 'L'    fetch   last            cecq034_curs into g_header.tc_shi02,g_header.tc_shi03
        when '/'    fetch   absolute g_jump cecq034_curs into g_header.tc_shi02,g_header.tc_shi03
    end case
    if sqlca.sqlcode then
        initialize g_header.* to null
        call cl_err('cecq034_curs',sqlca.sqlcode,1)
        return
    else
        case p_flag
            when 'N'    let g_curs_index = g_curs_index + 1
            when 'P'    let g_curs_index = g_curs_index - 1
            when 'F'    let g_curs_index = 1
            when 'L'    let g_curs_index = g_row_count
            when '/'    let g_curs_index = g_jump
        end case
        display g_curs_index to cnt2
        call cl_navigator_setting(g_curs_index, g_row_count)
    end if

    let g_header.last_edate = g_header.tc_shi02 - 1
    select tc_shi01,tc_shi04,tc_shi06,gen02 into g_header.last_sdate,g_header.tc_shi04,g_header.tc_shi06,g_header.gen02
      from tc_shi_file,gen_file
     where tc_shi02 = g_header.tc_shi02
       and tc_shi03 = g_header.tc_shi03
       and gen01 = tc_shi06
       and rownum = 1
    if sqlca.sqlcode then
        call cl_err3('sel','tc_shg_file','','',sqlca.sqlcode,'','',0)
    else
        call cecq034_show()
    end if
end function

--
function cecq034_show()
    display by name g_header.*
    call cecq034_b_fill()
end function

function cecq034_b_fill()
    define  i       integer
    -- g_tc_shg
    declare cecq034_fill1 cursor for
    select tc_shi07,ima02,ima021,tc_shi08,tc_shi09,tc_shi10,tc_shi11,tc_shi12,tc_shi13,tc_shi14,
           tc_shi15,tc_shi16,tc_shi17,
           tc_shi08 + tc_shi09 + tc_shi10 + tc_shi11 + tc_shi12 - tc_shi13 - tc_shi14 - tc_shi15 - tc_shi16 - tc_shi17 as diff
      from tc_shi_file,ima_file
     where tc_shi02 = g_header.tc_shi02
       and tc_shi03 = g_header.tc_shi03
       and ima01 = tc_shi07
      order by tc_shi07
    let i = 1
    call g_tc_shi.clear()
    foreach cecq034_fill1 into g_tc_shi_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq034_fill1',sqlca.sqlcode,1)
            exit foreach
        end if
        if i <= g_max_rec then
            let g_tc_shi[i].* = g_tc_shi_excel[i].*
        end if
        let i = i +1
    end foreach
    call g_tc_shi.deleteElement(i)
    let g_rec_b1 = g_tc_shi.getLength()

    declare cecq034_fill2 cursor for
    select tc_shg05,ima02,ima021,tc_shg06,tc_shg07,tc_shg08,tc_shg09 from tc_shg_file,ima_file
     where tc_shg02 = g_header.tc_shi02
       and tc_shg03 = g_header.tc_shi03
       and ima01 = tc_shg06
     order by tc_shg05,tc_shg06,tc_shg07,tc_shg08
    let i = 1
    call g_tc_shg.clear()
    foreach cecq034_fill2 into g_tc_shg_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq034_fill2',sqlca.sqlcode,1)
            exit foreach
        end if
        if i <= g_max_rec then
            let g_tc_shg[i].* = g_tc_shg_excel[i].*
        end if
        let i = i +1
    end foreach
    call g_tc_shg.deleteElement(i)
    let g_rec_b2 = g_tc_shg.getLength()

    declare cecq034_fill3 cursor for
    select tc_shh05,a.ima02,a.ima021,tc_shh06,b.ima02,b.ima021,tc_shh07,tc_shh08,tc_shh09
      from tc_shh_file,ima_file a, ima_file b
     where a.ima01 = tc_shh05 and b.ima01 = tc_shh06
       and tc_shh02 = g_header.tc_shi02
       and tc_shh03 = g_header.tc_shi03
      order by tc_shh05,tc_shh06
    let i = 1
    call g_tc_shh.clear()
    foreach cecq034_fill3 into g_tc_shh_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq034_fill3',sqlca.sqlcode,1)
            exit foreach
        end if
        if i <= g_max_rec then
            let g_tc_shh[i].* = g_tc_shh_excel[i].*
        end if
        let i = i +1
    end foreach
    call g_tc_shh.deleteElement(i)
    let g_rec_b3 = g_tc_shh.getLength()

    declare cecq034_fill4 cursor for
    select tc_shh06,ima02,ima021,tc_shh07,sum(tc_shh09) from tc_shh_file,ima_file
     where tc_shh02 = g_header.tc_shi02
       and tc_shh03 = g_header.tc_shi03
       and ima01 = tc_shh06
     group by tc_shh06,ima02,ima021,tc_shh07
     order by tc_shh06
    let i = 1
    call g_tc_shh_group.clear()
    foreach cecq034_fill4 into g_tc_shh_group_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq034_fill4',sqlca.sqlcode,1)
            exit foreach
        end if
        if i <= g_max_rec then
            let g_tc_shh_group[i].* = g_tc_shh_group_excel[i].*
        end if
        let i = i +1
    end foreach
    call g_tc_shh_group.deleteElement(i)
    let g_rec_b4 = g_tc_shh_group.getLength()

end function

function cecq034_bp()
    call cl_set_act_visible("accept,cancel", false)
    dialog

        display array g_tc_shi to s_tc_shi.* attribute(count=g_rec_b1)
            before display
                display array g_tc_shi to s_tc_shi.* attribute(count=g_rec_b1)
                    before display
                        exit display
                end display
            after display
                continue dialog
        end display

        display array g_tc_shh to s_tc_shh.* attribute(count=g_rec_b2)
            before display
                display array g_tc_shh to s_tc_shh.* attribute(count=g_rec_b2)
                    before display
                        exit display
                end display
            after display
                continue dialog
        end display

        display array g_tc_shh_group to s_tc_shh_group.* attribute(count=g_rec_b4)
            before display
                display array g_tc_shh_group to s_tc_shh_group.* attribute(count=g_rec_b4)
                    before display
                        exit display
                end display
            after display
                continue dialog
        end display

        display array g_tc_shg to s_tc_shg.* attribute(count=g_rec_b3)
            before display
                display array g_tc_shg to s_tc_shg.* attribute(count=g_rec_b3)
                    before display
                        exit display
                end display
            after display
                continue dialog
        end display

        before dialog
            display g_curs_index to cnt2
            call cl_navigator_setting(g_curs_index, g_row_count)

        on action query
            let g_action_choice = 'query'
            exit dialog

        on action exporttoexcel
            let g_action_choice = 'exporttoexcel'
            exit dialog

        on action locale
            call cl_dynamic_locale()
            call cl_show_fld_cont()

        on action exit
            let g_action_choice = 'exit'
            exit dialog

        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit dialog

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
            -- 超时退出
            call cl_on_idle()
            continue dialog

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action first     call cecq034_fetch('F')
        on action jump      call cecq034_fetch('/')
        on action last      call cecq034_fetch('L')
        on action next      call cecq034_fetch('N')
        on action previous  call cecq034_fetch('P')

        on action generate
            let g_action_choice = 'generate'
            exit dialog

    end dialog
    call cl_set_act_visible("accept,cancel", true)
end function

-- 产生新资料
function cecq034_generate()
    define  l_sdate,l_edate,l_last_s,l_last_e       date
    define  l_cnt       integer

    OPEN WINDOW cecq034_w_1 AT 2,2 WITH FORM "cec/42f/cecq034_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    call cl_ui_init()

    input l_sdate,l_edate,l_last_s,l_last_e without defaults from sdate,edate,last_s,last_e

        before input
            let l_last_e = g_today
            select max(tc_shi02) into l_sdate from tc_shi_file
            select min(tc_shi03) into l_edate from tc_shi_file
             where tc_shi02 = l_sdate
            let l_last_s = l_edate
            display l_sdate,l_edate,l_last_s,l_last_e
                 to sdate,edate,last_s,last_e

        on action controlr
            call cl_show_req_fields()

        on action controlf
            -- 切换语言
            call cl_set_focus_form(ui.Interface.getRootNode()) returning g_fld_name,g_frm_name
            call cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        on change sdate
            if not cl_null(l_sdate) then
                select count(unique tc_shi02||tc_shi03) into l_cnt from tc_shi_file
                 where tc_shi02 = l_sdate
                case
                    when l_cnt > 1
                        call cl_set_comp_entry('edate',true)
                        call cl_err('有多笔期初资料可以选择','!',0)
                        select min(tc_shi03) into l_edate from tc_shi_file
                         where tc_shi02 = l_sdate
                        display l_edate to edate
                    when l_cnt = 1
                        call cl_set_comp_entry('edate',false)
                        select unique tc_shi03 into l_edate from tc_shi_file
                         where tc_shi02 = l_sdate
                        display l_edate to edate
                    otherwise
                        call cl_set_comp_entry('edate',false)
                        call cl_err('没有期初资料，请重新选择','!',1)
                        next field sdate
                end case
                let l_last_s = l_edate
                display l_last_s to last_s
            end if
        on change edate
            if not cl_null(l_edate) then
                select count(unique tc_shi02||tc_shi03) into l_cnt from tc_shi_file
                 where tc_shi02 = l_sdate and tc_shi03 = l_edate
                if l_cnt <= 0 then
                    call cl_err(sfmt('没有期初资料，无法计算 %1-%2',l_sdate,l_edate),'!',1)
                    next field edate
                end if
            end if

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
    if int_flag then
        let int_flag = false
        close window cecq034_w_1
        return
    end if
    close window cecq034_w_1

    call scecq034_generate(l_sdate,l_last_s,l_last_e)

    if g_success = 'Y' then
        message '成功!'
    else
        message '失败!'
    end if

end function
