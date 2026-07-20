# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: scecq200.4gl
# Descriptions...: 通用的在制产生逻辑
# Date & Author..: darcy 26-07-20 add

function scecq200_crt_tmp()

    whenever error continue

    drop table scecq200_temp
    create temp table scecq200_temp (
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

function scecq200_generate(p_wc)
    define l_amt            decimal(20,3)
    define p_wc,l_sql       string

    call scecq200_crt_tmp()
    --delete from scecq200_temp

    let l_sql = "
    insert into scecq200_temp
        (sgm01, sgm02, sgm03, sgm03_p, sgm03_n, sgm04, sgm06, sgm301, sgm311, sgm313)
        select *
          from (select sgm01, sgm02, sgm03,
                       NVl(LAG(sgm03) OVER(partition by sgm01 order by sgm03), 0) sgm03_p,
                       NVL(LEAD(sgm03) OVER(partition by sgm01 order by sgm03),0) sgm03_n,
                       sgm04, sgm06, sgm301, sgm311, sgm313
                  from sgm_file, sfb_file
                 where sfb01 = sgm02
                   and sfb04 <> '8'
                   and sfb87 = 'Y' and ",p_wc clipped,")
         where sgm301 + sgm311 + sgm313 > 0
           and (sgm301 > sgm311 + sgm313 or sgm03_n = 0)"
    prepare scecq200_gen01 from l_sql
    execute scecq200_gen01
    if sqlca.sqlcode then
        call cl_err('cecq200_gen01',sqlca.sqlcode,1)
        return
    end if

    -- 入库筛选
    let l_sql = "
    merge into scecq200_temp
    using (select sfv20, sum(sfv09) sfv09
             from sfu_file, sfv_file
            where sfu01 = sfv01
              and sfupost = 'Y'
            group by sfv20)
    on (sgm01 = sfv20 and sgm03_n = 0)
    when matched then
      update set stock = sfv09"
    prepare scecq200_gen02 from l_sql
    execute scecq200_gen02
    if sqlca.sqlcode then
        call cl_err('cecq200_gen02',sqlca.sqlcode,1)
        return
    end if

    let l_sql = "
    delete from scecq200_temp
     where sgm03_n = 0
       and sgm301 <= sgm311 + sgm313
       and sgm311 = stock"
    prepare scecq200_gen03 from l_sql
    execute scecq200_gen03
    if sqlca.sqlcode then
        call cl_err('cecq200_gen03',sqlca.sqlcode,1)
        return
    end if


  -- 下线筛选
    let l_sql = "
    insert into scecq200_temp
      (sgm01, sgm03, sgm314, flag)
      select shb16, shb06, sum(tsc05) tsc05, 'T'
        from tsc_file, shb_file, (select unique sgm01 from scecq200_temp)
       where shb01 = tscud02
         and tscpost = 'Y'
         and shb16 = sgm01
       group by shb16, shb06"
    prepare scecq200_gen04 from l_sql
    execute scecq200_gen04
    if sqlca.sqlcode then
        call cl_err('cecq200_gen04',sqlca.sqlcode,1)
        return
    end if

    -- 情况1 > 步数 , 且中间无报工站
    -- 情况2 > 步数 , 中间有报工站 -> 异常
    let l_sql = "
    merge into scecq200_temp a
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
                     from scecq200_temp) a
            where flag = 'T') b
    on (a.sgm01 = b.sgm01 and a.sgm03 = b.wip_step and a.flag is null)
    when matched then
      update set a.sgm314 = b.sgm314, a.off_sgm03 = b.sgm03"
    prepare scecq200_gen05 from l_sql
    execute scecq200_gen05
    if sqlca.sqlcode then
        call cl_err('cecq200_gen05',sqlca.sqlcode,1)
        return
    end if

    -- 异常写入
    let l_sql = "
    insert into scecq200_temp
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
                from scecq200_temp) a
       where flag = 'T'
         and wip_step > 0
         and exists (select 1
                from sgm_file b
               where a.sgm01 = b.sgm01
                 and b.sgm03 > a.sgm03
                 and b.sgm03 < a.wip_step
                 and b.ta_sgm06 = 'Y')"
    prepare scecq200_gen06 from l_sql
    execute scecq200_gen06
    if sqlca.sqlcode then
        call cl_err('cecq200_gen06',sqlca.sqlcode,1)
        return
    end if

  -- 删除已处理的下线记录
    let l_sql = "
    delete from scecq200_temp
     where flag = 'T'
       and (sgm01, sgm03) in (select sgm01, off_sgm03
                                from scecq200_temp
                               where flag is null
                                 and off_sgm03 is not null)    "
    prepare scecq200_gen07 from l_sql
    execute scecq200_gen07
    if sqlca.sqlcode then
        call cl_err('cecq200_gen07',sqlca.sqlcode,1)
        return
    end if

  -- 情况3 = 步数 , -> 异常
    let l_sql = "
    merge into scecq200_temp a
    using scecq200_temp b
    on (a.sgm01 = b.sgm01 and a.sgm03 = b.sgm03 and a.flag is null and b.flag = 'T')
    when matched then
      update set a.sgm314 = b.sgm314, a.off_sgm03 = b.sgm03"
    prepare scecq200_gen08 from l_sql
    execute scecq200_gen08
    if sqlca.sqlcode then
        call cl_err('cecq200_gen08',sqlca.sqlcode,1)
        return
    end if

    let l_sql = "
    insert into scecq200_temp
      (sgm01, sgm03, sgm314, sgm03_n, flag)
      select a.sgm01, a.sgm03, a.sgm314, a.sgm03, 'F'
        from (select * from scecq200_temp where flag = 'T') a,
             (select * from scecq200_temp where flag is null) b
       where a.sgm01 = b.sgm01
         and a.sgm03 = b.sgm03"
    prepare scecq200_gen09 from l_sql
    execute scecq200_gen09
    if sqlca.sqlcode then
        call cl_err('cecq200_gen09',sqlca.sqlcode,1)
        return
    end if


    let l_sql = "
    delete from scecq200_temp
     where flag = 'T'
       and (sgm01, sgm03) in (select sgm01, off_sgm03
                                from scecq200_temp
                               where flag is null
                                 and off_sgm03 is not null)"
    prepare scecq200_gen10 from l_sql
    execute scecq200_gen10
    if sqlca.sqlcode then
        call cl_err('cecq200_gen10',sqlca.sqlcode,1)
        return
    end if

  -- 情况4 其它异常
    let l_sql = "
    insert into scecq200_temp
      (sgm01, sgm03, sgm314, sgm03_n, flag)
      select sgm01, sgm03, sgm314, sgm03, 'G'
        from scecq200_temp
       where flag = 'T'"
    prepare scecq200_gen11 from l_sql
    execute scecq200_gen11
    if sqlca.sqlcode then
        call cl_err('cecq200_gen11',sqlca.sqlcode,1)
        return
    end if

    delete from scecq200_temp where flag = 'T'
    if sqlca.sqlcode then
        call cl_err('del01',sqlca.sqlcode,1)
        return
    end if

    update scecq200_temp set sgm314 = 0 where sgm314 is null
    if sqlca.sqlcode then
        call cl_err('upd01',sqlca.sqlcode,1)
        return
    end if
    update scecq200_temp set stock = 0 where stock is null
    if sqlca.sqlcode then
        call cl_err('upd02',sqlca.sqlcode,1)
        return
    end if

    -- 全部下线
    update scecq200_temp
        set flag = 'O'
    where sgm301 - sgm311 - sgm313 = sgm314
        and (sgm03_n <> 0 or (sgm03_n = 0 and sgm314 > 0))
        and flag is null
    if sqlca.sqlcode then
        call cl_err('upd03',sqlca.sqlcode,1)
        return
    end if

    -- 再排除一次完工入库
    delete from scecq200_temp
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
    update scecq200_temp
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
    let l_sql = "
    update scecq200_temp set flag = 'U'
       where (sgm01, sgm03) in
             (select sgm01, sgm03
                from scecq200_temp
                left join (select tc_shb03, tc_shb06, sum(tc_shb12) tc_shb12
                            from tc_shb_file
                           where tc_shb01 = '1'
                           group by tc_shb03, tc_shb06)
                  on tc_shb03 = sgm01
                 and tc_shb06 = sgm03
               where tc_shb12 < sgm301
                 and sgm03_p = 0)"
    prepare scecq200_upd05 from l_sql
    execute scecq200_upd05
    if sqlca.sqlcode then
        call cl_err('upd05',sqlca.sqlcode,1)
        return
    end if

    delete from scecq200_temp
     where sgm03_n = 0 and flag is null
       and sgm301 - sgm313 - sgm314 - stock <= 0

    delete from scecq200_temp
     where sgm03_n != 0 and flag is null
       and sgm301 - sgm311 - sgm313 - sgm314 <= 0

end function
