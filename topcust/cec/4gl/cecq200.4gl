# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cecq200.4gl
# Descriptions...: 在制LOT清单
# Date & Author..: darcy 26/06/08 add

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

type sgm record
    sgm01           like sgm_file.sgm01,
    sgm02           like sgm_file.sgm02,
    sgm03_par       like sgm_file.sgm03_par,
    ima02           like ima_file.ima02,
    ima021          like ima_file.ima021,
    sgm03           like sgm_file.sgm03,
    sgm04           like sgm_file.sgm04,
    ecd02           like ecd_file.ecd02,
    sgm06           like sgm_file.sgm06,
    eca02           like eca_file.eca02,
    sgm301          like sgm_file.sgm301,
    sgm311          like sgm_file.sgm311,
    sgm313          like sgm_file.sgm313,
    sgm314          like sgm_file.sgm314,
    stock           like sgm_file.sgm314,
    wip             like sgm_file.sgm314,
    wip_pnl         like sgm_file.sgm314
end record

type sgm06 record
    sgm062           like sgm_file.sgm06,
    eca022           like eca_file.eca02,
    sgm03_par2       like sgm_file.sgm03_par,
    ima022           like ima_file.ima02,
    ima0212          like ima_file.ima021,
    sgm3012          like sgm_file.sgm301,
    sgm3112          like sgm_file.sgm311,
    sgm3132          like sgm_file.sgm313,
    sgm3142          like sgm_file.sgm314,
    stock2           like sgm_file.sgm314,
    wip2             like sgm_file.sgm314
end record

type sfb record
    sgm023           like sgm_file.sgm02,
    sgm03_par3       like sgm_file.sgm03_par,
    ima023           like ima_file.ima02,
    ima0213          like ima_file.ima021,
    sgm3013          like sgm_file.sgm301,
    sgm3113          like sgm_file.sgm311,
    sgm3133          like sgm_file.sgm313,
    sgm3143          like sgm_file.sgm314,
    stock3           like sgm_file.sgm314,
    wip3             like sgm_file.sgm314
end record

type sfb05 record
    sgm03_par4       like sgm_file.sgm03_par,
    ima024           like ima_file.ima02,
    ima0214          like ima_file.ima021,
    sgm3014          like sgm_file.sgm301,
    sgm3114          like sgm_file.sgm311,
    sgm3134          like sgm_file.sgm313,
    sgm3144          like sgm_file.sgm314,
    stock4           like sgm_file.sgm314,
    wip4             like sgm_file.sgm314
end record

define  g_wc1,g_wc2,g_sql         string
define  g_sgm,g_sgm_excel   dynamic array of sgm
define  g_sgm06,g_sgm06_excel   dynamic array of sgm06
define  g_sfb,g_sfb_excel   dynamic array of sfb
define  g_sfb05,g_sfb05_excel   dynamic array of sfb05

define  g_rec_b,l_ac,g_cnt  integer

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

    OPEN WINDOW cecq200_w AT 2,2 WITH FORM "cec/42f/cecq200"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    call cecq200_crt_tmp()
    call cecq200_q()
    call cecq200_menu()

    CLOSE WINDOW cecq200_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

function cecq200_menu()
    while true
        call cecq200_bp()
        case g_action_choice
            when 'query'
                call cecq200_q()
            when 'exporttoexcel'
            call cl_download_by_explorer(
                cl_expexcel5(
                    "s_sgm",base.typeinfo.create(g_sgm_excel),
                    "s_sgm06",base.typeinfo.create(g_sgm06_excel),
                    "s_sfb",base.typeinfo.create(g_sfb_excel),
                    "s_sfb05",base.typeinfo.create(g_sfb05_excel),
                    "",null
                ))
            when 'exit'
                exit while
        end case
    end while
end function

function cecq200_cs()
    dialog
        construct g_wc1 on sfb01,sfb05,sgm01
            from sfb01q,sfb05q,sgm01q
        end construct

        construct g_wc2 on sgm04,sgm06 from sgm04q,sgm06q
        end construct

        on action controlp
            case
                when infield(sfb01q)
                    call cl_init_qry_var()
                    let g_qryparam.state    = "c"
                    let g_qryparam.form = 'cq_sfb01_1'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to sfb01q
                when infield(sfb05q)
                    call cl_init_qry_var()
                    let g_qryparam.state    = "c"
                    let g_qryparam.form = 'q_ima'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to sfb05q
                when infield(sgm01q)
                    call cl_init_qry_var()
                    let g_qryparam.state    = "c"
                    let g_qryparam.form = 'cq_sgm01'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to sgm01q
                when infield(sgm04q)
                    call cl_init_qry_var()
                    let g_qryparam.state    = "c"
                    let g_qryparam.form = 'q_ecd3'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to sgm04q
                when infield(sgm06q)
                    call cl_init_qry_var()
                    let g_qryparam.state    = "c"
                    let g_qryparam.form = 'cq_eca'
                    call cl_create_qry() returning g_qryparam.multiret
                    display g_qryparam.multiret to sgm06q
                otherwise
            end case

        on action about
            call cl_about()

        on action help
            call cl_show_help()

        on action accept
            exit dialog
        on action cancel
            let int_flag = true
            exit dialog

        on action controlg
            call cl_cmdask()
    end dialog
end function

function cecq200_q()
    call cecq200_cs()
    if int_flag then
        let int_flag = false
        return
    end if
    call cecq200_generate()
    call cecq200_b_fill()

end function

function cecq200_generate()
    define l_amt    decimal(20,3)

    delete from cecq013_temp

    let g_sql = "
    insert into cecq013_temp
        (sgm01, sgm02, sgm03, sgm03_p, sgm03_n, sgm04, sgm06, sgm301, sgm311, sgm313)
        select *
          from (select sgm01, sgm02, sgm03,
                       NVl(LAG(sgm03) OVER(partition by sgm01 order by sgm03), 0) sgm03_p,
                       NVL(LEAD(sgm03) OVER(partition by sgm01 order by sgm03),0) sgm03_n,
                       sgm04, sgm06, sgm301, sgm311, sgm313
                  from sgm_file, sfb_file
                 where sfb01 = sgm02
                   and sfb04 <> '8'
                   and sfb87 = 'Y' and ",g_wc1 clipped,")
         where sgm301 + sgm311 + sgm313 > 0
           and (sgm301 > sgm311 + sgm313 or sgm03_n = 0)"
    prepare cecq200_gen01 from g_sql
    execute cecq200_gen01
    if sqlca.sqlcode then
        call cl_err('cecq200_gen01',sqlca.sqlcode,1)
        return
    end if

    -- 入库筛选
    let g_sql = "
    merge into cecq013_temp
    using (select sfv20, sum(sfv09) sfv09
             from sfu_file, sfv_file
            where sfu01 = sfv01
              and sfupost = 'Y'
            group by sfv20)
    on (sgm01 = sfv20 and sgm03_n = 0)
    when matched then
      update set stock = sfv09"
    prepare cecq200_gen02 from g_sql
    execute cecq200_gen02
    if sqlca.sqlcode then
        call cl_err('cecq200_gen02',sqlca.sqlcode,1)
        return
    end if

    let g_sql = "
    delete from cecq013_temp
     where sgm03_n = 0
       and sgm301 <= sgm311 + sgm313
       and sgm311 = stock"
    prepare cecq200_gen03 from g_sql
    execute cecq200_gen03
    if sqlca.sqlcode then
        call cl_err('cecq200_gen03',sqlca.sqlcode,1)
        return
    end if


  -- 下线筛选
    let g_sql = "
    insert into cecq013_temp
      (sgm01, sgm03, sgm314, flag)
      select shb16, shb06, sum(tsc05) tsc05, 'T'
        from tsc_file, shb_file, (select unique sgm01 from cecq013_temp)
       where shb01 = tscud02
         and tscpost = 'Y'
         and shb16 = sgm01
       group by shb16, shb06"
    prepare cecq200_gen04 from g_sql
    execute cecq200_gen04
    if sqlca.sqlcode then
        call cl_err('cecq200_gen04',sqlca.sqlcode,1)
        return
    end if

    -- 情况1 > 步数 , 且中间无报工站
    -- 情况2 > 步数 , 中间有报工站 -> 异常
    let g_sql = "
    merge into cecq013_temp a
    using (select *
             from (select sgm01,
                          sgm03,
                          flag,
                          sgm314,
                          NVL(min(sgm03)
                              OVER(partition by sgm01 order by sgm03
                                   range between 1 FOLLOWING and UNBOUNDED
                                   FOLLOWING),
                              -10) as wip_step
                     from cecq013_temp) a
            where flag = 'T') b
    on (a.sgm01 = b.sgm01 and a.sgm03 = b.wip_step and a.flag is null)
    when matched then
      update set a.sgm314 = b.sgm314, a.off_sgm03 = b.sgm03"
    prepare cecq200_gen05 from g_sql
    execute cecq200_gen05
    if sqlca.sqlcode then
        call cl_err('cecq200_gen05',sqlca.sqlcode,1)
        return
    end if

    -- 异常写入
    let g_sql = "
    insert into cecq013_temp
      (sgm01, sgm03, sgm314, sgm03_n, flag)
      select sgm01, sgm03, sgm314, wip_step, 'E'
        from (select sgm01,
                     sgm03,
                     flag,
                     sgm314,
                     NVL(min(sgm03) OVER(partition by sgm01 order by sgm03
                              range between 1
                              FOLLOWING and UNBOUNDED FOLLOWING),
                         -10) as wip_step
                from cecq013_temp) a
       where flag = 'T'
         and wip_step > 0
         and exists (select 1
                from sgm_file b
               where a.sgm01 = b.sgm01
                 and b.sgm03 > a.sgm03
                 and b.sgm03 < a.wip_step
                 and b.ta_sgm06 = 'Y')"
    prepare cecq200_gen06 from g_sql
    execute cecq200_gen06
    if sqlca.sqlcode then
        call cl_err('cecq200_gen06',sqlca.sqlcode,1)
        return
    end if

  -- 删除已处理的下线记录
    let g_sql = "
    delete from cecq013_temp
     where flag = 'T'
       and (sgm01, sgm03) in (select sgm01, off_sgm03
                                from cecq013_temp
                               where flag is null
                                 and off_sgm03 is not null)    "
    prepare cecq200_gen07 from g_sql
    execute cecq200_gen07
    if sqlca.sqlcode then
        call cl_err('cecq200_gen07',sqlca.sqlcode,1)
        return
    end if

  -- 情况3 = 步数 , -> 异常
    let g_sql = "
    merge into cecq013_temp a
    using cecq013_temp b
    on (a.sgm01 = b.sgm01 and a.sgm03 = b.sgm03 and a.flag is null and b.flag = 'T')
    when matched then
      update set a.sgm314 = b.sgm314, a.off_sgm03 = b.sgm03"
    prepare cecq200_gen08 from g_sql
    execute cecq200_gen08
    if sqlca.sqlcode then
        call cl_err('cecq200_gen08',sqlca.sqlcode,1)
        return
    end if

    let g_sql = "
    insert into cecq013_temp
      (sgm01, sgm03, sgm314, sgm03_n, flag)
      select a.sgm01, a.sgm03, a.sgm314, a.sgm03, 'F'
        from (select * from cecq013_temp where flag = 'T') a,
             (select * from cecq013_temp where flag is null) b
       where a.sgm01 = b.sgm01
         and a.sgm03 = b.sgm03"
    prepare cecq200_gen09 from g_sql
    execute cecq200_gen09
    if sqlca.sqlcode then
        call cl_err('cecq200_gen09',sqlca.sqlcode,1)
        return
    end if


    let g_sql = "
    delete from cecq013_temp
     where flag = 'T'
       and (sgm01, sgm03) in (select sgm01, off_sgm03
                                from cecq013_temp
                               where flag is null
                                 and off_sgm03 is not null)"
    prepare cecq200_gen10 from g_sql
    execute cecq200_gen10
    if sqlca.sqlcode then
        call cl_err('cecq200_gen10',sqlca.sqlcode,1)
        return
    end if

  -- 情况4 其它异常
    let g_sql = "
    insert into cecq013_temp
      (sgm01, sgm03, sgm314, sgm03_n, flag)
      select sgm01, sgm03, sgm314, sgm03, 'G'
        from cecq013_temp
       where flag = 'T'"
    prepare cecq200_gen11 from g_sql
    execute cecq200_gen11
    if sqlca.sqlcode then
        call cl_err('cecq200_gen11',sqlca.sqlcode,1)
        return
    end if

    delete from cecq013_temp where flag = 'T'
    if sqlca.sqlcode then
        call cl_err('del01',sqlca.sqlcode,1)
        return
    end if

    update cecq013_temp set sgm314 = 0 where sgm314 is null
    if sqlca.sqlcode then
        call cl_err('upd01',sqlca.sqlcode,1)
        return
    end if
    update cecq013_temp set stock = 0 where stock is null
    if sqlca.sqlcode then
        call cl_err('upd02',sqlca.sqlcode,1)
        return
    end if

    -- 全部下线
    update cecq013_temp
        set flag = 'O'
    where sgm301 - sgm311 - sgm313 = sgm314
        and (sgm03_n <> 0 or (sgm03_n = 0 and sgm314 > 0))
        and flag is null
    if sqlca.sqlcode then
        call cl_err('upd03',sqlca.sqlcode,1)
        return
    end if

    -- 再排除一次完工入库
    delete from cecq013_temp
    where sgm03_n = 0
        and sgm301 <= sgm311 + sgm313 + sgm314
        and sgm311 = stock
        and sgm311 > 0
        and flag is null
    if sqlca.sqlcode then
        call cl_err('del02',sqlca.sqlcode,1)
        return
    end if

    -- 未开工
    update cecq013_temp
        set flag = 'U'
    where sgm03_p = 0
        and sgm311 = 0
        and sgm313 = 0
        and not exists
    (select 1 from tc_shb_file where tc_shb03 = sgm01)
    if sqlca.sqlcode then
        call cl_err('upd04',sqlca.sqlcode,1)
        return
    end if

    -- 部分未开工
    let g_sql = "
    update cecq013_temp set flag = 'U'
       where (sgm01, sgm03) in
             (select sgm01, sgm03
                from cecq013_temp
                left join (select tc_shb03, tc_shb06, sum(tc_shb12) tc_shb12
                            from tc_shb_file
                           where tc_shb01 = '1'
                           group by tc_shb03, tc_shb06)
                  on tc_shb03 = sgm01
                 and tc_shb06 = sgm03
               where tc_shb12 < sgm301
                 and sgm03_p = 0)"
    prepare cecq200_upd05 from g_sql
    execute cecq200_upd05
    if sqlca.sqlcode then
        call cl_err('upd05',sqlca.sqlcode,1)
        return
    end if

    delete from cecq013_temp
     where sgm03_n = 0 and flag is null
       and sgm301 - sgm313 - sgm314 - stock <= 0

    delete from cecq013_temp
     where sgm03_n != 0 and flag is null
       and sgm301 - sgm311 - sgm313 - sgm314 <= 0

end function

function cecq200_b_fill()
    define i   integer

    let g_sql = "select sgm01,sgm02,sfb05,ima02,ima021,sgm03,sgm04,ecd02,sgm06,eca02,sgm301,sgm311,sgm313,sgm314,stock,
                        case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end as wip,
                        ( case when imaud10 is null then 0 when imaud10 = 0 then 0 else
                            (case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end ) / imaud10 end
                        ) as wip_pnl
                        from cecq013_temp,sfb_file,eca_file,ecd_file,ima_file
                        where sfb01 = sgm02 and eca01 = sgm06 and ecd01 = sgm04
                          and ima01 = sfb05
                          and flag is null and ",g_wc2 clipped,
                " order by sgm06,sfb05,sgm01,sgm03,sgm04"
    declare cecq200_b_01 cursor from g_sql

    call g_sgm_excel.clear()
    call g_sgm.clear()
    let i = 1
    foreach cecq200_b_01 into g_sgm_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq200_b_01',sqlca.sqlcode,1)
            exit foreach
        end if
        if i < 10000 then
            let g_sgm[i].* = g_sgm_excel[i].*
        end if
        let i = i + 1
    end foreach
    call g_sgm_excel.deleteElement(i)
    let i = i - 1
    let g_rec_b = i

    let g_sql = "select sgm06,eca02,sfb05 sgm03_par,ima02,ima021,
                        sum(sgm301),sum(sgm311),sum(sgm313),sum(sgm314),sum(stock),
                        sum(case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end) as wip
                        from cecq013_temp,sfb_file,eca_file,ecd_file,ima_file
                        where sfb01 = sgm02 and eca01 = sgm06 and ecd01 = sgm04
                          and ima01 = sfb05
                          and flag is null and ",g_wc2 clipped,
                " group by sgm06,eca02,sfb05,ima02,ima021 order by sgm06,sfb05"
    declare cecq200_b_02 cursor from g_sql

    call g_sgm06_excel.clear()
    call g_sgm06.clear()
    let i = 1
    foreach cecq200_b_02 into g_sgm06_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq200_b_02',sqlca.sqlcode,1)
            exit foreach
        end if
        if i < 10000 then
            let g_sgm06[i].* = g_sgm06_excel[i].*
        end if
        let i = i + 1
    end foreach
    call g_sgm06_excel.deleteElement(i)


    let g_sql = "select sgm02,sfb05 sgm03_par,ima02,ima021,
                        sum(sgm301),sum(sgm311),sum(sgm313),sum(sgm314),sum(stock),
                        sum(case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end) as wip
                        from cecq013_temp,sfb_file,eca_file,ecd_file,ima_file
                        where sfb01 = sgm02 and eca01 = sgm06 and ecd01 = sgm04
                          and ima01 = sfb05
                          and flag is null and ",g_wc2 clipped,
                " group by sgm02,sfb05,ima02,ima021 order by sgm02,sfb05"
    declare cecq200_b_03 cursor from g_sql

    call g_sfb_excel.clear()
    call g_sfb.clear()
    let i = 1
    foreach cecq200_b_03 into g_sfb_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq200_b_03',sqlca.sqlcode,1)
            exit foreach
        end if
        if i < 10000 then
            let g_sfb[i].* = g_sfb_excel[i].*
        end if
        let i = i + 1
    end foreach
    call g_sfb_excel.deleteElement(i)

    let g_sql = "select sfb05 sgm03_par,ima02,ima021,
                        sum(sgm301),sum(sgm311),sum(sgm313),sum(sgm314),sum(stock),
                        sum(case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end) as wip
                        from cecq013_temp,sfb_file,eca_file,ecd_file,ima_file
                        where sfb01 = sgm02 and eca01 = sgm06 and ecd01 = sgm04
                          and ima01 = sfb05
                          and flag is null and ",g_wc2 clipped,
                " group by sfb05,ima02,ima021 order by sfb05"
    declare cecq200_b_04 cursor from g_sql

    call g_sfb05_excel.clear()
    call g_sfb05.clear()
    let i = 1
    foreach cecq200_b_04 into g_sfb05_excel[i].*
        if sqlca.sqlcode then
            call cl_err('cecq200_b_04',sqlca.sqlcode,1)
            exit foreach
        end if
        if i < 10000 then
            let g_sfb05[i].* = g_sfb05_excel[i].*
        end if
        let i = i + 1
    end foreach
    call g_sfb05_excel.deleteElement(i)

end function

function cecq200_bp()
    dialog
        display array g_sgm to s_sgm.* attribute(count=g_rec_b)
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_sgm06 to s_sgm06.*
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_sfb to s_sfb.*
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
        display array g_sfb05 to s_sfb05.*
            before row
                let l_ac = arr_curr()
                call cl_show_fld_cont()
        end display
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
    end dialog
end function

function cecq200_crt_tmp()

    whenever error continue

    drop table cecq013_temp
    create temp table cecq013_temp (
    sgm01     varchar(20),
    sgm02     varchar(20),
    sgm03     decimal(5),
    sgm03_p   decimal(5),
    sgm03_n   decimal(5),
    sgm04     varchar(10),
    sgm06     varchar(10),
    sgm301    decimal(15,3),
    sgm311    decimal(15,3),
    sgm313    decimal(15,3),
    sgm314    decimal(15,3),
    stock     decimal(15,3),
    flag      varchar(1),
    off_sgm03 decimal(5)
    )
end function
