# Prog. Version..: '5.30.10-13.11.15(00010)'     #
#
# Program name...: cxmq022.4gl
# Descriptions...: 成品材料材料核价异动查询
# Date & Author..: darcy 2026/06/12

database ds

globals "../../../tiptop/config/top.global"

type xme record
    tc_xme00        like tc_xme_file.tc_xme00,
    tc_xmf01        like tc_xmf_file.tc_xmf01,
    tc_xmf03_1      like tc_xmf_file.tc_xmf03,
    ima02           like ima_file.ima02,
    ima021          like ima_file.ima021,
    tc_xmf05        like tc_xmf_file.tc_xmf05,
    tc_xmedate      date,
    tc_xmf11        like tc_xmf_file.tc_xmf11,
    latest_date     date,
    price_diff      like pmj_file.pmj06,
    bmb01           like bmb_file.bmb01,
    bmb03           like bmb_file.bmb03,
    ima02_1         like ima_file.ima02,
    ima021_1        like ima_file.ima021,
    bmb10           like bmb_file.bmb10,
    pmj07           like pmj_file.pmj07,
    pmj09           date,
    pmj06           like pmj_file.pmj06,
    pmj08           date,
    price_diff2     like pmj_file.pmj06
end record

define g_xme        dynamic array of xme
define g_wc,g_sql,g_arg1       string
define g_cnt,l_ac,g_rec_b       integer

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    LET g_arg1 = ARG_VAL(1)
    LET g_bgjob = ARG_VAL(2)

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("CMX")) THEN
        EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW cxmq022_w AT 2,2 WITH FORM "cxm/42f/cxmq022"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    if not cl_null(g_arg1) then
        let g_wc = g_arg1
        call cxmq022_q()
    end if

    CALL cxmq022_menu()

    close window cxmq022_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

--
function cxmq022_menu()
    while true
        call cxmq022_bp()
        case g_action_choice
            when 'query'
                if cl_chk_act_auth() then
                    call cxmq022_q()
                end if
            when 'exit'
                exit while
            when 'exporttoexcel'
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel1( "s_xme",base.typeinfo.create(g_xme)))
                end if
        end case
    end while
end function

--
function cxmq022_cs()
    construct by name g_wc on tc_xme00,tc_xme03,tc_xmf03

        before construct
            call cl_qbe_init()

        on action controlp
            -- 开窗
            case
                when infield(tc_xme00)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = 'q_tc_xme00'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_xme00
                when infield(tc_xme03)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = 'q_occ'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_xme03
                when infield(tc_xmf03)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = 'q_ima'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to tc_xmf03
                otherwise
            end case

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action controlg
            call cl_cmdask()

    end construct
end function

--
function cxmq022_q()
    if g_bgjob = 'N' or cl_null(g_bgjob) then
        call cxmq022_cs()
    end if
    if int_flag then
        let int_flag = false
        return
    end if
    if g_wc = ' 1=1' then
        call cl_err('请输入查询条件','！',1)
        return
    end if
    call cxmq022_b_fill()
end function

--
function cxmq022_bp()
    call cl_set_act_visible("accept,cancel", false)
    display array g_xme to s_xme.* attribute(count=g_rec_b)

        before row
            let l_ac = arr_curr()
            call cl_show_fld_cont()

        on action query
            let g_action_choice = 'query'
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

        on action cancel
            let int_flag = false
            let g_action_choice = 'exit'
            exit display

        on action controlg
            call cl_cmdask()

        on idle g_idle_seconds
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

function cxmq022_b_fill()
    define  sr  record
        tc_xmf03        like tc_xmf_file.tc_xmf03,
        ima02           like ima_file.ima02,
        ima021          like ima_file.ima021,
        tc_xmf05        like tc_xmf_file.tc_xmf05,
        tc_xme00        like tc_xme_file.tc_xme00,
        tc_xmf01        like tc_xmf_file.tc_xmf01,
        tc_xmedate      like tc_xme_file.tc_xmedate,
        tc_xmf11        like tc_xmf_file.tc_xmf05,
        latest_date     date,
        price_diff      like tc_xmf_file.tc_xmf05
    end record


    let g_sql = "
    select tc_xmf03, ima02,ima021,tc_xmf05, tc_xme00, tc_xmf01, tc_xmedate
      from (select tc_xmf03, ima02, ima021, tc_xmf05, tc_xme00, tc_xmf01, tc_xmedate,
                   ROW_NUMBER() OVER (partition by tc_xmf03 order by tc_xmedate desc, tc_xmf01 desc) as rn
              from tc_xmf_file, tc_xme_file,ima_file
             where tc_xmf00 = tc_xme00 and ima01 = tc_xmf03 and ",g_wc clipped,") t
     where rn = 1 order by tc_xmedate,tc_xme00"
    declare cxmq022_cur02 cursor from g_sql

    let g_sql = "
    select tc_xmf05,tc_xmedate from (
    select tc_xmf05,tc_xmedate,
           ROW_NUMBER() OVER (partition by tc_xmf03 order by tc_xmedate desc, tc_xmf01 desc) as rn
      from tc_xmf_file, tc_xme_file
     where tc_xmf00 = tc_xme00 and tc_xmeconf = 'Y'
       and tc_xmf03 = ? and tc_xmf00 <> ? )
    where rn = 1"
    prepare cxmq022_p02 from g_sql

    call g_xme.clear()
    foreach cxmq022_cur02 into sr.tc_xmf03,sr.ima02,sr.ima021,sr.tc_xmf05,sr.tc_xme00,sr.tc_xmf01,sr.tc_xmedate
        if sqlca.sqlcode then
            call cl_err('cxmq022_cur02',sqlca.sqlcode,1)
            exit foreach
        end if
        execute cxmq022_p02 using sr.tc_xmf03,sr.tc_xme00 into sr.tc_xmf11,sr.latest_date
        if sqlca.sqlcode then
            let sr.latest_date = null
        end if
        call cxmq022_bom(sr.*)
    end foreach
end function

--
function cxmq022_bom(p_param)
    define  p_param  record
        tc_xmf03        like tc_xmf_file.tc_xmf03,
        ima02           like ima_file.ima02,
        ima021          like ima_file.ima021,
        tc_xmf05        like tc_xmf_file.tc_xmf05,
        tc_xme00        like tc_xme_file.tc_xme00,
        tc_xmf01        like tc_xmf_file.tc_xmf01,
        tc_xmedate      like tc_xme_file.tc_xmedate,
        tc_xmf11        like tc_xmf_file.tc_xmf05,
        latest_date     date,
        price_diff      like tc_xmf_file.tc_xmf05
    end record
    define i,j      integer
    define sr       dynamic array of record
        bmb01       like bmb_file.bmb01,
        bmb03       like bmb_file.bmb03,
        bmb10       like bmb_file.bmb10,
        ima02       like ima_file.ima02,
        ima021      like ima_file.ima021
    end record
    define l_cnt    integer

    let g_sql = "
    select bmb01,bmb03,bmb10,ima02,ima021 from bmb_file,ima_file
     where bmb04 <= trunc(sysdate)
       and (bmb05 > trunc(sysdate) or bmb05 is null)
       and ima01 = bmb03
       and bmb01 = ? "
    prepare cxmq022_p1 from g_sql
    declare cxmq022_cur1 cursor for cxmq022_p1

    let g_sql = "
    select pmj07,pmj09,pmj06,pmj08 from (
    select pmj07,pmj09,pmj06,pmj08,
           ROW_NUMBER() OVER (partition by pmj03 order by pmj09 desc, pmi01 desc) as rn
      from pmi_file,pmj_file
     where pmi01 = pmj01 and pmiconf ='Y'
       and pmj03 = ?)
    where rn = 1 "
    prepare cxmq022_p03 from g_sql

    let g_sql = "select count(*) from bmb_file where bmb01 = ? "
    prepare cxmq022_p04 from g_sql

    let i = 1
    call sr.clear()
    foreach cxmq022_cur1 using p_param.tc_xmf03 into sr[i].*
        if sqlca.sqlcode then
            call cl_err('cxmq022_cur1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call sr.deleteElement(i)

    for i = 1 to sr.getLength()
        execute cxmq022_p04 using sr[i].bmb03 into l_cnt
        if l_cnt = 0 then
            let j = g_xme.getLength() + 1
            let g_xme[j].tc_xme00   = p_param.tc_xme00
            let g_xme[j].tc_xmf01   = p_param.tc_xmf01
            let g_xme[j].tc_xmf03_1 = p_param.tc_xmf03
            let g_xme[j].ima02      = p_param.ima02
            let g_xme[j].ima021     = p_param.ima021
            let g_xme[j].tc_xmf05   = p_param.tc_xmf05
            let g_xme[j].tc_xmedate = p_param.tc_xmedate
            let g_xme[j].tc_xmf11   = p_param.tc_xmf11
            let g_xme[j].latest_date= p_param.latest_date
            let g_xme[j].price_diff = p_param.tc_xmf05 - p_param.tc_xmf11
            let g_xme[j].bmb01      = sr[i].bmb01
            let g_xme[j].bmb03      = sr[i].bmb03
            let g_xme[j].ima02_1    = sr[i].ima02
            let g_xme[j].ima021_1   = sr[i].ima021
            let g_xme[j].bmb10      = sr[i].bmb10
            execute cxmq022_p03 using sr[i].bmb03
               into g_xme[j].pmj07,g_xme[j].pmj09,g_xme[j].pmj06,g_xme[j].pmj08
            let g_xme[j].price_diff2= g_xme[j].pmj07 - g_xme[j].pmj06
        else
            call cxmq022_exp(p_param.*,sr[i].bmb03)
        end if
    end for

end function

function cxmq022_exp(p_param,p_bma01)
    define p_bma01      like bma_file.bma01
    define  p_param  record
        tc_xmf03        like tc_xmf_file.tc_xmf03,
        ima02           like ima_file.ima02,
        ima021          like ima_file.ima021,
        tc_xmf05        like tc_xmf_file.tc_xmf05,
        tc_xme00        like tc_xme_file.tc_xme00,
        tc_xmf01        like tc_xmf_file.tc_xmf01,
        tc_xmedate      like tc_xme_file.tc_xmedate,
        tc_xmf11        like tc_xmf_file.tc_xmf05,
        latest_date     date,
        price_diff      like tc_xmf_file.tc_xmf05
    end record
    define i,j      integer
    define sr       dynamic array of record
        bmb01       like bmb_file.bmb01,
        bmb03       like bmb_file.bmb03,
        bmb10       like bmb_file.bmb10,
        ima02       like ima_file.ima02,
        ima021      like ima_file.ima021
    end record
    define l_cnt    integer

    let i = 1
    call sr.clear()
    foreach cxmq022_cur1 using p_bma01 into sr[i].*
        if sqlca.sqlcode then
            call cl_err('cxmq022_cur1',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call sr.deleteElement(i)

    for i = 1 to sr.getLength()
        execute cxmq022_p04 using sr[i].bmb03 into l_cnt
        if l_cnt = 0 then
            let j = g_xme.getLength() + 1
            let g_xme[j].tc_xme00   = p_param.tc_xme00
            let g_xme[j].tc_xmf01   = p_param.tc_xmf01
            let g_xme[j].tc_xmf03_1 = p_param.tc_xmf03
            let g_xme[j].ima02      = p_param.ima02
            let g_xme[j].ima021     = p_param.ima021
            let g_xme[j].tc_xmf05   = p_param.tc_xmf05
            let g_xme[j].tc_xmedate = p_param.tc_xmedate
            let g_xme[j].tc_xmf11   = p_param.tc_xmf11
            let g_xme[j].latest_date= p_param.latest_date
            let g_xme[j].price_diff = p_param.tc_xmf05 - p_param.tc_xmf11
            let g_xme[j].bmb01      = sr[i].bmb01
            let g_xme[j].bmb03      = sr[i].bmb03
            let g_xme[j].ima02_1    = sr[i].ima02
            let g_xme[j].ima021_1   = sr[i].ima021
            let g_xme[j].bmb10      = sr[i].bmb10
            execute cxmq022_p03 using sr[i].bmb03
               into g_xme[j].pmj07,g_xme[j].pmj09,g_xme[j].pmj06,g_xme[j].pmj08
            let g_xme[j].price_diff2= g_xme[j].pmj07 - g_xme[j].pmj06

        else
            call cxmq022_exp(p_param.*,sr[i].bmb03)
        end if
    end for
end function
