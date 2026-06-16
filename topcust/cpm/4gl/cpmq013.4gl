# Prog. Version..: '5.30.10-13.11.15(00010)'     #
#
# Program name...: cpmq013.4gl
# Descriptions...: 采购核价关联成本价格异动查询
# Date & Author..: darcy 2026/06/12

database ds

globals "../../../tiptop/config/top.global"

type pmj record
    pmi01           like pmi_file.pmi01,
    pmj02           like pmj_file.pmj02,
    pmj03           like pmj_file.pmj03,
    ima02           like ima_file.ima02,
    ima021          like ima_file.ima021,
    ima44           like ima_file.ima44,
    pmj07           like pmj_file.pmj07,
    pmj09           like pmj_file.pmj09,
    pmj06           like pmj_file.pmj06,
    pmj08           like pmj_file.pmj08,
    diff1           like pmj_file.pmj07,
    ima01           like ima_file.ima01,
    ima02_1         like ima_file.ima02,
    ima021_1        like ima_file.ima021,
    tc_xmf05        like tc_xmf_file.tc_xmf05,
    tc_xmedate      like tc_xme_file.tc_xmedate,
    tc_xmf11        like tc_xmf_file.tc_xmf05,
    prev        date,
    diff2           like pmj_file.pmj07
end record

define g_pmj        dynamic array of pmj
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

    OPEN WINDOW cpmq013_w AT 2,2 WITH FORM "cpm/42f/cpmq013"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    call cpmq013_crt_tmp()

    if not cl_null(g_arg1) then
        let g_wc = g_arg1
        call cpmq013_q()
    end if

    CALL cpmq013_menu()

    close window cpmq013_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

--
function cpmq013_menu()
    while true
        call cpmq013_bp()
        case g_action_choice
            when 'query'
                if cl_chk_act_auth() then
                    call cpmq013_q()
                end if
            when 'exit'
                exit while
            when 'exporttoexcel'
                if cl_chk_act_auth() then
                    call cl_download_by_explorer(cl_expexcel1( "s_pmj",base.typeinfo.create(g_pmj)))
                end if
        end case
    end while
end function

--
function cpmq013_cs()
    construct g_wc on pmi01,pmj03,pmi03,pmi02 from pmi01q,pmj03q,pmi03q,pmi02q

        before construct
            call cl_qbe_init()

        on action controlp
            case
                when infield(pmi01q)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = 'q_pmi'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to pmi01q
                when infield(pmi03q)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = 'q_pmc1'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to pmi03q
                when infield(pmj03q)
                    call cl_init_qry_var()
                    let g_qryparam.state = "c"
                    let g_qryparam.form = 'q_ima'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to pmj03q
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
function cpmq013_q()
    if g_bgjob = 'N' or cl_null(g_bgjob) then
        call cpmq013_cs()
    end if
    if int_flag then
        let int_flag = false
        return
    end if
    if g_wc = ' 1=1' then
        call cl_err('查询条件不允许为空','?',1)
        return
    end if
    call cpmq013_b_fill()
end function

--
function cpmq013_bp()
    call cl_set_act_visible("accept,cancel", false)
    display array g_pmj to s_pmj.* attribute(count=g_rec_b)

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

function cpmq013_b_fill()
    define i        integer

    delete from cpmq013_tmp1
    delete from cpmq013_tmp2

    -- 插入基础表
    let g_sql = "
    insert into cpmq013_tmp1 (
            pmi01,pmj02,pmj03,pmj07,pmj09,pmj06,pmj08)
    select a.pmi01, a.pmj02, a.pmj03, a.pmj07, a.pmj09, b.pmj07 pmj06, b.pmj09 pmj08
    from (select pmi01, pmj02, pmj03, pmj07, pmj09
            from (select pmi01, pmj02, pmj03, pmj07, pmj09,
                        ROW_NUMBER() OVER (partition by pmj03 order by pmj09 desc, pmi01 desc) as rn
                    from pmi_file, pmj_file
                    where pmi01 = pmj01 and pmiconf = 'Y' and ",g_wc clipped,") a
            where rn = 1) a
    left join (select pmj03, pmj07, pmj09
                from (select pmi01, pmj02, pmj03, pmj07, pmj09, pmj06, pmj08,
                                ROW_NUMBER() OVER (partition by pmj03 order by pmj09 desc, pmi01 desc) as rn
                        from pmi_file, pmj_file
                        where pmi01 = pmj01 and pmiconf = 'Y') a
                where rn = 2) b
        on a.pmj03 = b.pmj03"
    prepare cpmq013_ins_tmp1 from g_sql
    execute cpmq013_ins_tmp1
    if sqlca.sqlcode then
        call cl_err('cpmq013_ins_tmp1',sqlca.sqlcode,1)
        return
    end if

    update cpmq013_tmp1 set pmj06 = null
     where pmj06 = 0

    -- 将成品数据插入表中
    -- 递归查询成品，成品最近一年有未出货订单（axmt400）

    let g_sql = "
    insert into cpmq013_tmp2 (pmj03,bmb01,tc_xmf05,tc_xmedate,tc_xmf11,prev)
    select bmb03, bmb01, xme.tc_xmf05, xme.tc_xmedate, xme2.tc_xmf05 tc_xmf11, xme2.tc_xmedate prev
    from (select bmb03, bmb01
            from bmb_file
            where bmb04 <= trunc(sysdate)
            and (bmb05 is null or bmb05 > trunc(sysdate))
            start with bmb03 in (select pmj03 from cpmq013_tmp1)
            connect by prior bmb03 = bmb01) bom,
        (select tc_xmf03, tc_xmf05, tc_xmedate
            from (select tc_xmf03,
                        tc_xmf05,
                        tc_xmedate,
                        ROW_NUMBER() OVER (partition by tc_xmf03 order by tc_xmedate desc, tc_xme00 desc) as rn
                    from tc_xme_file, tc_xmf_file
                    where tc_xme00 = tc_xmf00
                    and tc_xmeconf = 'Y')
            where rn = 1) xme
    left join (select tc_xmf03, tc_xmf05, tc_xmedate
                from (select tc_xmf03,
                                tc_xmf05,
                                tc_xmedate,
                                ROW_NUMBER() OVER (partition by tc_xmf03 order by tc_xmedate desc, tc_xme00 desc) as rn
                        from tc_xme_file, tc_xmf_file
                        where tc_xme00 = tc_xmf00
                            and tc_xmeconf = 'Y')
                where rn = 2) xme2
        on xme2.tc_xmf03 = xme.tc_xmf03
    where xme.tc_xmf03 = bom.bmb01
    and exists
    (select 1
            from (select a.oeb04
                    from (select oea01, oea02, oeb04, sum(oeb12) oeb12
                            from oea_file, oeb_file
                            where oea01 = oeb01
                            and oeaconf = 'Y'
                            and oea00 = '0'
                            group by oea01, oea02, oeb04) a
                    left join (select oebud02, oeb04, sum(oeb12) oeb12
                                from oea_file, oeb_file
                                where oea01 = oeb01
                                and oeaconf = 'Y'
                                and oea00 = '1'
                                group by oebud02, oeb04) b
                        on a.oea01 = b.oebud02
                    and a.oeb04 = b.oeb04
                    where a.oeb12 > nvl(b.oeb12, 0)
                    and a.oea02 >= trunc(sysdate) - 365)
            where oeb04 = bmb01)"
    prepare cecq013_ins_tmp2 from g_sql
    execute cecq013_ins_tmp2
    if sqlca.sqlcode then
        call cl_err('cpmq013_ins_tmp2',sqlca.sqlcode,1)
        return
    end if

    let g_sql = "
    select pmi01,pmj02,e.pmj03,a.ima02,b.ima021,a.ima44,pmj07,pmj09,pmj06,pmj08,pmj07-pmj06 diff1,
           bmb01 ima01,b.ima02 ima02_1,b.ima021 ima021_1,tc_xmf05,tc_xmedate,tc_xmf11,prev,tc_xmf05-tc_xmf11 diff2
      from cpmq013_tmp1 e
      left join ima_file a on a.ima01 = e.pmj03
      left join cpmq013_tmp2 f on e.pmj03 = f.pmj03
      left join ima_file b on b.ima01 = f.pmj03
     order by pmi01,pmj02,pmj03,bmb01 desc "
    declare cpmq013_bfill cursor from g_sql
    
    let i = 1
    call g_pmj.clear()
    foreach cpmq013_bfill into g_pmj[i].*
        if sqlca.sqlcode then
            call cl_err('cpmq013_bfill',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach
    call g_pmj.deleteElement(i)
    let g_rec_b = i - 1

end function

function cpmq013_crt_tmp()

    whenever error continue

    drop table cpmq013_tmp1
    create temp table cpmq013_tmp1(
        pmi01               varchar(20),
        pmj02               integer,
        pmj03               varchar(20),
        pmj07               decimal(20,6),
        pmj09               date,
        pmj06               decimal(20,6),
        pmj08               date
    )
    drop table cpmq013_tmp2
    create temp table cpmq013_tmp2(
        pmj03               varchar(20),
        bmb01               varchar(20),
        tc_xmf05            decimal(20,6),
        tc_xmedate          date,
        tc_xmf11            decimal(20,6),
        prev            date
    )
end function
