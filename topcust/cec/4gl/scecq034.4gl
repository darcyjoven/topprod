# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: scecq034.4gl
# Descriptions...: 损耗逻辑产生函数
# Date & Author..: darcy 26-07-21 add

database ds

globals "../../../tiptop/config/top.global"

function scecq034_generate_month(p_yy,p_mm,p_replace)
    define  p_yy,p_mm,l_cnt       integer,
            p_replace       boolean
    define  l_tc_shi03      like tc_shi_file.tc_shi03,
            l_tc_shi04      like tc_shi_file.tc_shi04,
            l_tc_shi05      like tc_shi_file.tc_shi05,
            l_tc_shi06      like tc_shi_file.tc_shi06
    define  l_ly,l_lm               integer
    define  l_edate,l_sdate date
    define  l_sql           string

    let l_tc_shi03 = g_today
    let l_tc_shi04 = current hour to second

    let l_sdate = mdy(p_mm,1,p_yy)
    if p_mm = 12 then
        let l_edate = mdy(12,31,p_yy)
    else
        let l_edate = mdy(p_mm+1,1,p_yy) -1
    end if

    if p_replace then
        let l_tc_shi05 = 'Y'
    else
        let l_tc_shi05 = 'N'
    end if
    let l_tc_shi06 = g_user

    select count(*) into l_cnt from tc_shi_file
     where tc_shi01 = p_yy and tc_shi02 = p_mm
       and tc_shi03 = l_tc_shi03 and tc_shi04 = l_tc_shi04
       and tc_shi05 = 'Y'
    if l_cnt > 0 then
        -- 重新生成一个
        sleep 1
        let l_tc_shi04 = current hour to second
    end if

    -- 事务外产生计算wip，因为这里会建立表，自动提交事务
    call scecq200_generate(" substr(sfb05,1,2)='JL' and substr(sfb05,7,1) in ('A','B','C','D') and substr(sfb05,10,1) = 'R' and sfb05 not like '%-%' ")

    let g_success = 'Y'
    begin work

    if l_tc_shi05 = 'Y' then
        select count(*) into l_cnt from tc_shi_file
         where tc_shi01 = p_yy
           and tc_shi02 = p_mm
           and tc_shi05 = 'Y'
        if l_cnt > 0 then
            if (cl_null(g_bgjob) or g_bgjob ='N' ) then
                if not cl_confirm('cec-065') then
                    rollback work
                    let g_success = 'N'
                    return
                end if
            end if
            let l_sql  = "
            delete from tc_shg_file where (tc_shg01,tc_shg02,tc_shg03,tc_shg04) in
            (select tc_shi01,tc_shi02,tc_shi03,tc_shi04 from tc_shi_file
                where tc_shi05 = 'Y' and tc_shi01 = ? and tc_shi02 = ?)"
            prepare scecq034_del4 from l_sql
            execute scecq034_del4 using p_yy,p_mm
            if sqlca.sqlcode then
                call cl_err('del scecq034_del4',sqlca.sqlcode,0)
                rollback work
                let g_success = 'N'
                return
            end if

            let l_sql  = "
            delete from tc_shh_file where (tc_shh01,tc_shh02,tc_shh03,tc_shh04) in
            (select tc_shi01,tc_shi02,tc_shi03,tc_shi04 from tc_shi_file
            where tc_shi05 = 'Y' and tc_shi01 = ? and tc_shi02 = ? )"
            prepare scecq034_del5 from l_sql
            execute scecq034_del5 using p_yy,p_mm
            if sqlca.sqlcode then
                call cl_err('del scecq034_del5',sqlca.sqlcode,0)
                rollback work
                let g_success = 'N'
                return
            end if

            let l_sql  = "
            delete from tc_shi_file where tc_shi05 = 'Y' and tc_shi01 = ? and tc_shi02 = ?"
            prepare scecq034_del6 from l_sql
            execute scecq034_del6 using p_yy,p_mm
            if sqlca.sqlcode then
                call cl_err('del scecq034_del6',sqlca.sqlcode,0)
                rollback work
                let g_success = 'N'
                return
            end if
        end if
    else
        select count(*) into l_cnt from tc_shi_file
        where tc_shi01 = p_yy
        and tc_shi02 = p_mm
        and tc_shi03 = l_tc_shi03
        and tc_shi04 = l_tc_shi04
        if l_cnt > 0 then
            if (cl_null(g_bgjob) or g_bgjob ='N' ) then
                if not cl_confirm('cec-066') then
                    rollback work
                    let g_success = 'N'
                    return
                end if
            end if
            message '删除旧资料中...'
            delete from tc_shi_file where tc_shi01 = p_yy and tc_shi02 = p_mm and tc_shi03 = l_tc_shi03 and tc_shi04 = l_tc_shi04
            if sqlca.sqlcode then
                call cl_err('del tc_shi',sqlca.sqlcode,0)
                rollback work
                let g_success = 'N'
                return
            end if
            delete from tc_shg_file where tc_shg01 = p_yy and tc_shg02 = p_mm and tc_shg03 = l_tc_shg03 and tc_shg04 = l_tc_shi04
            if sqlca.sqlcode then
                call cl_err('del tc_shg',sqlca.sqlcode,0)
                rollback work
                let g_success = 'N'
                return
            end if
            delete from tc_shh_file where tc_shh01 = p_yy and tc_shh02 = p_mm and tc_shh03 = l_tc_shi03 and tc_shh04 = l_tc_shi04
            if sqlca.sqlcode then
                call cl_err('del tc_shh',sqlca.sqlcode,0)
                rollback work
                let g_success = 'N'
                return
            end if
        end if
    end if

    message '删除60天前非正式资料...'
    let l_sql  = "
    delete from tc_shg_file where (tc_shg01,tc_shg02,tc_shg03,tc_shg04) in
    (select tc_shi01,tc_shi02,tc_shi03,tc_shi04 from tc_shi_file
        where (tc_shi05 is null or tc_shi05 = 'N' ) and tc_shi03 <= trunc(sysdate) - 60)"
    prepare scecq034_del1 from l_sql
    execute scecq034_del1

    let l_sql  = "
    delete from tc_shh_file where (tc_shh01,tc_shh02,tc_shh03,tc_shh04) in
    (select tc_shi01,tc_shi02,tc_shi03,tc_shi04 from tc_shi_file
        where (tc_shi05 is null or tc_shi05 = 'N' ) and tc_shi03 <= trunc(sysdate) - 60)"
    prepare scecq034_del2 from l_sql
    execute scecq034_del2

    let l_sql  = "
    delete from tc_shi_file
        where (tc_shi05 is null or tc_shi05 = 'N' ) and tc_shi03 <= trunc(sysdate) - 60"
    prepare scecq034_del3 from l_sql
    execute scecq034_del3

    -- 以上月期初作为基础
    if p_mm = 1 then
        let l_lm = 12
        let l_ly = p_yy - 1
    else
        let l_lm = p_mm - 1
        let l_ly = p_yy
    end if
    select count(*) into l_cnt from tc_shi_file
     where tc_shi01 = l_ly and tc_shi02 = l_lm
      and tc_shi05 = 'Y'
    if l_cnt > 0 then
        message '期初资料写入...'
        insert into tc_shi_file
            (tc_shi01,tc_shi02,tc_shi03,tc_shi04,tc_shi05,tc_shi06,tc_shi07,tc_shi08,tc_shi09,tc_shi10,
             tc_shi11,tc_shi12,tc_shi13,tc_shi14,tc_shi15,tc_shi16,tc_shi17 )
        select p_yy,p_mm,l_tc_shi03,l_tc_shi04,l_tc_shi05,l_tc_shi06,tc_shi07,tc_shi15,tc_shi16,tc_shi17,
               0, 0, 0, 0, 0, 0, 0
          from tc_shi_file
         where tc_shi01 = l_ly and tc_shi02 = l_lm and tc_shi05 = 'Y'
           and ( tc_shi15 <> 0 or tc_shi16 <> 0 or tc_shi17 <> 0)
        if sqlca.sqlcode then
            call cl_err('ins tc_shi',sqlca.sqlcode,0)
            rollback work
            let g_success = 'N'
            return
        end if
    end if

    -- 1. 明细写入
    -- 1.1 wip
    message 'WIP写入...'
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select  p_yy,p_mm,l_tc_shi03,l_tc_shi04,'wip',sfb05,sgm01,sgm06,
            case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end as wip
      from scecq200_temp,sfb_file where sgm02 = sfb01 and flag is null
    if sqlca.sqlcode then
        call cl_err('ins tc_shg wip',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if
    -- 1.2 未开工
    message '未开工写入...'
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'unwip',sfb05,sfb01,'',sfb081-nvl(sum(tc_shb12),0)
      from (select sfb01,sfb81,sfb05,sfb081, min(ecm03) ecm03_1 from sfb_file, ecm_file
             where sfb01 = ecm01 and sfb87 = 'Y' and sfb04 <> '8' and sfb081 > 0
             and substr(sfb05, 1, 2) = 'JL' and substr(sfb05, 7, 1) in ('A', 'B', 'C', 'D')
             and substr(sfb05, 10, 1) = 'R' and sfb05 not like '%-%'
             group by sfb01,sfb81,sfb05,sfb081)
       left join tc_shb_file on tc_shb04 = sfb01 and tc_shb06 = ecm03_1 and tc_shb01 = 1
       group by sfb01,sfb05,sfb081
       having sfb081> nvl(sum(tc_shb12),0)"
    prepare scecq034_ins01 from l_sql
    execute scecq034_ins01 using p_yy,p_mm,l_tc_shi03,l_tc_shi04
    if sqlca.sqlcode then
        call cl_err('ins tc_shg unwip',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if
    -- 1.3 库存
    message '库存写入...'
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'stock',img01,img02||','||img03,img04,img10
      from img_file where substr(img01,1,2)='JL' and substr(img01,7,1)in('A','B','C','D')
       and substr(img01,10,1) = 'R' and img01 not like '%-%' and img10 <> 0"
    prepare scecq034_ins02 from l_sql
    execute scecq034_ins02 using p_yy,p_mm,l_tc_shi03,l_tc_shi04
    if sqlca.sqlcode then
        call cl_err('ins tc_shg stock',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if
    -- 1.4 发料、补料
    message '发料、补料写入...'
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,case substr(sfq02,1,3) when 'MSA' then 'plus' else 'issue' end tc_shg05, sfb05,
            sfp01,sfq02,case sfp06 when '1' then sfq03 when '6' then -sfq03 else 0 end as sfq03
      from sfp_file, sfq_file, sfb_file
     where sfp01 = sfq01 and sfb01 = sfq02 and sfp04 = 'Y'
       and sfp03 between ? and ?
       and sfp06 in ('1','6') and  substr(sfq02,1,3) in ('MRA','MSA')
       and substr(sfb05,1,2)='JL' and substr(sfb05,7,1)in('A','B','C','D')
       and substr(sfb05,10,1) = 'R' and sfb05 not like '%-%'"
    prepare scecq034_ins03 from l_sql
    execute scecq034_ins03 using p_yy,p_mm,l_tc_shi03,l_tc_shi04,l_sdate,l_edate
    if sqlca.sqlcode then
        call cl_err('ins tc_shg issue plus',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if
    -- 1.5 出货
    message '出货写入...'
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'ship',tlf01,tlf905,tlf906,-tlf907*tlf10 as tlf10 from tlf_file
    where tlf06 between ? and ? and tlf13 in ('aomt800','axmt620')
      and substr(tlf01,1,2)='JL' and substr(tlf01,7,1)in('A','B','C','D')
       and substr(tlf01,10,1) = 'R' and tlf01 not like '%-%' and tlf902 <> 'ZTC' "
    prepare scecq034_ins04 from l_sql
    execute scecq034_ins04 using p_yy,p_mm,l_tc_shi03,l_tc_shi04,l_sdate,l_edate
    if sqlca.sqlcode then
        call cl_err('ins tc_shg ship',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if
    -- 1.6 报废
    message '报废写入...'
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'scrap',tc_shb05,tc_shb03,tc_shb08,tc_shb121 from tc_shb_file
    where tc_shb01='2'  and substr(tc_shb05,1,2)='JL' and substr(tc_shb05,7,1)in('A','B','C','D')
      and substr(tc_shb05,10,1) = 'R' and tc_shb05 not like '%-%' and tc_shb121 <> 0
      and tc_shb14 between ? and ? "
    prepare scecq034_ins05 from l_sql
    execute scecq034_ins05 using p_yy,p_mm,l_tc_shi03,l_tc_shi04,l_sdate,l_edate
    if sqlca.sqlcode then
        call cl_err('ins tc_shg scrap',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if

    -- 2 汇总
    message '汇总本期数量...'
    let l_sql = "
    merge into tc_shi_file
    using ( select tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg06,
                    nvl(sum(case when tc_shg05='wip' then tc_shg09 else 0 end),0) wip,
                    nvl(sum(case when tc_shg05='stock' then tc_shg09 else 0 end),0) stock,
                    nvl(sum(case when tc_shg05='unwip' then tc_shg09 else 0 end),0) unwip,
                    nvl(sum(case when tc_shg05='issue' then tc_shg09 else 0 end),0) issue,
                    nvl(sum(case when tc_shg05='plus' then tc_shg09 else 0 end),0) plus,
                    nvl(sum(case when tc_shg05='ship' then tc_shg09 else 0 end),0) ship,
                    nvl(sum(case when tc_shg05='scrap' then tc_shg09 else 0 end),0) scrap
             from tc_shg_file where tc_shg01 = ? and tc_shg02 = ? and tc_shg03 = ? and tc_shg04 = ?
            group by tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg06
    ) on (tc_shg01 = tc_shi01 and tc_shg02 = tc_shi02
      and tc_shg03=tc_shi03 and tc_shg04 = tc_shi04 and tc_shg06 = tc_shi07)
    when matched then update set tc_shi15 = wip,tc_shi16 = stock,tc_shi17 = unwip,
                                 tc_shi11 = issue,tc_shi12 = plus, tc_shi13 = ship,
                                 tc_shi14 = scrap
    when not matched then insert
    (tc_shi01,tc_shi02,tc_shi03,tc_shi04,tc_shi05,tc_shi06,tc_shi07,tc_shi08,tc_shi09,tc_shi10,tc_shi11,tc_shi12,tc_shi13,tc_shi14,tc_shi15,tc_shi16,tc_shi17)
      values (tc_shg01,tc_shg02,tc_shg03,tc_shg04,?,?,tc_shg06,0,0,0,issue,plus,ship,scrap,wip,stock,unwip)
    "
    prepare scecq034_p1 from l_sql
    execute scecq034_p1 using p_yy,p_mm,l_tc_shi03,l_tc_shi04,l_tc_shi05,l_tc_shi06
    if sqlca.sqlcode then
        call cl_err('scecq034_p1',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if

    -- 展开计算损耗客供器件‘
    message '器件明细展开...'
    let l_sql = "
    insert into tc_shh_file (tc_shh01,tc_shh02,tc_shh03,tc_shh04,tc_shh05,tc_shh06,tc_shh07,tc_shh08,tc_shh09)
    select  tc_shi01,tc_shi02,tc_shi03,tc_shi04,tc_shi07 as root,bmb03,bmb10,bmb06,
            bmb06 * (tc_shi08 + tc_shi09 + tc_shi10 + tc_shi11 + tc_shi12 - tc_shi13 - tc_shi14 - tc_shi15 - tc_shi16 - tc_shi17) qty
      from tc_shi_file
      left join (
      select root, bmb03, bmb06 , bmb10
        from (select bmb01, bmb03, bmb06,bmb10, CONNECT_BY_ROOT(bmb01) root
                from (select bmb01, bmb03, bmb06, bmb10
                        from bma_file, bmb_file
                       where bma01 = bmb01 and bmb04 <= ? and (bmb05 is null or bmb05 > ?)
                         and substr(bma01, 1, 2) = 'JL' and substr(bma01, 7, 1) in ('A', 'B', 'C', 'D')
                         and substr(bma01, 10, 1) = 'R')
               start with bmb01 like 'JL%'
              connect by prior bmb03 = bmb01)
       where bmb03 like 'K.%' ) on root = tc_shi07
     where tc_shi01 = ? and tc_shi02 = ? and tc_shi03 = ? and tc_shi04 = ?
       and tc_shi08 + tc_shi09 + tc_shi10 + tc_shi11 + tc_shi12 - tc_shi13 - tc_shi14 - tc_shi15 - tc_shi16 - tc_shi17 <> 0 "
    prepare scecq034_p2 from l_sql
    execute scecq034_p2 using l_edate,l_edate,p_yy,p_mm,l_tc_shi03,l_tc_shi04
    if sqlca.sqlcode then
        call cl_err('scecq034_p2',sqlca.sqlcode,0)
        rollback work
        let g_success = 'N'
        return
    end if

    if g_success = 'Y' then
        commit work
    else
        rollback work
    end if
end function

function scecq034_generate(p_start,p_end,p_today)
    define  p_start,p_end,p_today
            date
    define  i,k,l_cnt
            integer
    define  l_sql
            string
    define  l_tc_shi04  like tc_shi_file.tc_shi04,
            l_tc_shi05  like tc_shi_file.tc_shi05,
            l_tc_shi06  like tc_shi_file.tc_shi06

    let l_tc_shi04 = current hour to second
    let l_tc_shi05 = 'Y'
    let l_tc_shi06 = g_user

    if g_bgjob = 'Y' then
    else
        -- 本期资料检查
        select count(*) into l_cnt from tc_shi_file
         where tc_shi02 = p_end and tc_shi03 = p_today
        if l_cnt > 0 then
            if not cl_confirm('cec-065') then
                let g_success = 'N'
                return
            end if
        end if
     end if

     -- 检查上期资料
     let g_success = 'Y'
     select count(*) into l_cnt from tc_shi_file
      where tc_shi02 = p_start and tc_shi03 = p_end
     if l_cnt = 0 then
        call cl_err('上期资料不存在','!',0)
        let g_success = 'N'
        return
     end if

     -- 计算在制
     call scecq200_generate(" substr(sfb05,1,2)='JL' and substr(sfb05,7,1) in ('A','B','C','D') and substr(sfb05,10,1) = 'R' and sfb05 not like '%-%' ")

     begin work

     -- 删除历史资料
     delete from tc_shi_file where tc_shi02 = p_end and tc_shi03 = p_today
     delete from tc_shh_file where tc_shh02 = p_end and tc_shh03 = p_today
     delete from tc_shg_file where tc_shg02 = p_end and tc_shg03 = p_today

     -- 期初资料写入
     insert into tc_shi_file
         (tc_shi01,tc_shi02,tc_shi03,tc_shi04,tc_shi05,tc_shi06,tc_shi07,tc_shi08,tc_shi09,tc_shi10,
          tc_shi11,tc_shi12,tc_shi13,tc_shi14,tc_shi15,tc_shi16,tc_shi17 )
     select p_start,p_end,p_today,l_tc_shi04,l_tc_shi05,l_tc_shi06,tc_shi07,tc_shi15,tc_shi16,tc_shi17,
            0, 0, 0, 0, 0, 0, 0
       from tc_shi_file
      where tc_shi02 = p_start and tc_shi03 = p_end
        and ( tc_shi15 <> 0 or tc_shi16 <> 0 or tc_shi17 <> 0)
    if sqlca.sqlcode then
        call cl_err('期初资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --明细资料写入
    --在制
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select  p_start,p_end,p_today,l_tc_shi04,'wip',sfb05,sgm01,sgm06,
            case sgm03_n when 0 then sgm301 - sgm313 - sgm314 - stock else sgm301 - sgm311 - sgm313 - sgm314 end as wip
      from scecq200_temp,sfb_file where sgm02 = sfb01 and flag is null
    if sqlca.sqlcode then
        call cl_err('在制资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --未开工
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'unwip',sfb05,sfb01,'',sfb081-nvl(sum(tc_shb12),0)
      from (select sfb01,sfb81,sfb05,sfb081, min(ecm03) ecm03_1 from sfb_file, ecm_file
             where sfb01 = ecm01 and sfb87 = 'Y' and sfb04 <> '8' and sfb081 > 0
             and substr(sfb05, 1, 2) = 'JL' and substr(sfb05, 7, 1) in ('A', 'B', 'C', 'D')
             and substr(sfb05, 10, 1) = 'R' and sfb05 not like '%-%'
             group by sfb01,sfb81,sfb05,sfb081)
       left join tc_shb_file on tc_shb04 = sfb01 and tc_shb06 = ecm03_1 and tc_shb01 = 1
       group by sfb01,sfb05,sfb081
       having sfb081> nvl(sum(tc_shb12),0)"
    prepare scecq034_date_ins01 from l_sql
    execute scecq034_date_ins01 using p_start,p_end,p_today,l_tc_shi04
    if sqlca.sqlcode then
        call cl_err('未开工资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --库存
    let l_sql =  "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'stock',img01,img02||','||img03,img04,img10
      from img_file where substr(img01,1,2)='JL' and substr(img01,7,1)in('A','B','C','D')
       and substr(img01,10,1) = 'R' and img01 not like '%-%' and img10 <> 0"
    prepare scecq034_date_ins02 from l_sql
    execute scecq034_date_ins02 using p_start,p_end,p_today,l_tc_shi04
    if sqlca.sqlcode then
        call cl_err('库存资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --发料,补料
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,case substr(sfq02,1,3) when 'MSA' then 'plus' else 'issue' end tc_shg05, sfb05,
            sfp01,sfq02,case sfp06 when '1' then sfq03 when '6' then -sfq03 else 0 end as sfq03
      from sfp_file, sfq_file, sfb_file
     where sfp01 = sfq01 and sfb01 = sfq02 and sfp04 = 'Y'
       and sfp03 between ? and ?
       and sfp06 in ('1','6') and  substr(sfq02,1,3) in ('MRA','MSA')
       and substr(sfb05,1,2)='JL' and substr(sfb05,7,1)in('A','B','C','D')
       and substr(sfb05,10,1) = 'R' and sfb05 not like '%-%'"
    prepare scecq034_date_ins03 from l_sql
    execute scecq034_date_ins03 using p_start,p_end,p_today,l_tc_shi04,p_end,p_today
    if sqlca.sqlcode then
        call cl_err('发料,补料资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --出货
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'ship',tlf01,tlf905,tlf906,-tlf907*tlf10 as tlf10 from tlf_file
    where tlf06 between ? and ? and tlf13 in ('aomt800','axmt620')
      and substr(tlf01,1,2)='JL' and substr(tlf01,7,1)in('A','B','C','D')
       and substr(tlf01,10,1) = 'R' and tlf01 not like '%-%' and tlf902 <> 'ZTC' "
    prepare scecq034_date_ins04 from l_sql
    execute scecq034_date_ins04 using p_start,p_end,p_today,l_tc_shi04,p_end,p_today

    --报废
    let l_sql = "
    insert into tc_shg_file (tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg05,tc_shg06,tc_shg07,tc_shg08,tc_shg09)
    select ?,?,?,?,'scrap',tc_shb05,tc_shb03,tc_shb08,tc_shb121 from tc_shb_file
    where tc_shb01='2'  and substr(tc_shb05,1,2)='JL' and substr(tc_shb05,7,1)in('A','B','C','D')
      and substr(tc_shb05,10,1) = 'R' and tc_shb05 not like '%-%' and tc_shb121 <> 0
      and tc_shb14 between ? and ? "
    prepare scecq034_date_ins05 from l_sql
    execute scecq034_date_ins05 using p_start,p_end,p_today,l_tc_shi04,p_end,p_today
    if sqlca.sqlcode then
        call cl_err('报废资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --汇总
    let l_sql = "
    merge into tc_shi_file
    using ( select tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg06,
                    nvl(sum(case when tc_shg05='wip' then tc_shg09 else 0 end),0) wip,
                    nvl(sum(case when tc_shg05='stock' then tc_shg09 else 0 end),0) stock,
                    nvl(sum(case when tc_shg05='unwip' then tc_shg09 else 0 end),0) unwip,
                    nvl(sum(case when tc_shg05='issue' then tc_shg09 else 0 end),0) issue,
                    nvl(sum(case when tc_shg05='plus' then tc_shg09 else 0 end),0) plus,
                    nvl(sum(case when tc_shg05='ship' then tc_shg09 else 0 end),0) ship,
                    nvl(sum(case when tc_shg05='scrap' then tc_shg09 else 0 end),0) scrap
             from tc_shg_file where tc_shg02 = ? and tc_shg03 = ? and tc_shg04 = ?
            group by tc_shg01,tc_shg02,tc_shg03,tc_shg04,tc_shg06
    ) on (tc_shg01 = tc_shi01 and tc_shg02 = tc_shi02
      and tc_shg03=tc_shi03 and tc_shg04 = tc_shi04 and tc_shg06 = tc_shi07)
    when matched then update set tc_shi15 = wip,tc_shi16 = stock,tc_shi17 = unwip,
                                 tc_shi11 = issue,tc_shi12 = plus, tc_shi13 = ship,
                                 tc_shi14 = scrap
    when not matched then insert
    (tc_shi01,tc_shi02,tc_shi03,tc_shi04,tc_shi05,tc_shi06,tc_shi07,tc_shi08,tc_shi09,tc_shi10,tc_shi11,tc_shi12,tc_shi13,tc_shi14,tc_shi15,tc_shi16,tc_shi17)
      values (tc_shg01,tc_shg02,tc_shg03,tc_shg04,?,?,tc_shg06,0,0,0,issue,plus,ship,scrap,wip,stock,unwip)
    "
    prepare scecq034_date_p1 from l_sql
    execute scecq034_date_p1 using p_end,p_today,l_tc_shi04,l_tc_shi05,l_tc_shi06
    if sqlca.sqlcode then
        call cl_err('汇总资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    --展开BOM
    let l_sql = "
    insert into tc_shh_file (tc_shh01,tc_shh02,tc_shh03,tc_shh04,tc_shh05,tc_shh06,tc_shh07,tc_shh08,tc_shh09)
    select  tc_shi01,tc_shi02,tc_shi03,tc_shi04,tc_shi07 as root,bmb03,bmb10,bmb06,
            bmb06 * (tc_shi08 + tc_shi09 + tc_shi10 + tc_shi11 + tc_shi12 - tc_shi13 - tc_shi14 - tc_shi15 - tc_shi16 - tc_shi17) qty
      from tc_shi_file
      left join (
      select root, bmb03, bmb06 , bmb10
        from (select bmb01, bmb03, bmb06,bmb10, CONNECT_BY_ROOT(bmb01) root
                from (select bmb01, bmb03, bmb06, bmb10
                        from bma_file, bmb_file
                       where bma01 = bmb01 and bmb04 <= ? and (bmb05 is null or bmb05 > ?)
                         and substr(bma01, 1, 2) = 'JL' and substr(bma01, 7, 1) in ('A', 'B', 'C', 'D')
                         and substr(bma01, 10, 1) = 'R')
               start with bmb01 like 'JL%'
              connect by prior bmb03 = bmb01)
       where bmb03 like 'K.%' ) on root = tc_shi07
     where tc_shi02 = ? and tc_shi03 = ? and tc_shi04 = ?
       and tc_shi08 + tc_shi09 + tc_shi10 + tc_shi11 + tc_shi12 - tc_shi13 - tc_shi14 - tc_shi15 - tc_shi16 - tc_shi17 <> 0 "
    prepare scecq034_date_p2 from l_sql
    execute scecq034_date_p2 using p_today,p_today,p_end,p_today,l_tc_shi04
    if sqlca.sqlcode then
        call cl_err('器件展开资料写入失败',sqlca.sqlcode,0)
        let g_success = 'N'
        goto _err
    end if

    label _err:
    if g_success = 'Y' then
        commit work
    else
        rollback work
    end if
end function
