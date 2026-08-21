# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: scimp500.4gl
# Descriptions...: 每日进销存产值、达交计算的公用函数
# Date & Author..: darcy 2026-07-20

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

define  g_date          date            -- 日期
define  g_version       varchar(10)     -- 版本
define  g_start,g_end   date
define  g_tot_success   varchar(1)

-- 入口函数
function scimp500(p_date,p_version,p_tran)
    define  p_date      date,
            p_version   varchar(10),
            p_tran      boolean
    define  l_curr      varchar(10)
    define  l_str       string
    define  l_channel   base.Channel

    if not p_tran then
        begin work
    end if

    let g_success = 'Y'
    let g_tot_success = 'Y'
    let g_date = p_date
    if cl_null(p_version)then
        let p_version = 'normal'
    end if
    let g_version = p_version


    if g_version = 'month' then
        let g_start = mdy(month(g_date),1,year(g_date))
        if month(g_date) = 12 then
            let g_end = mdy(1,1,year(g_date)+1) -1
        else
            let g_end = mdy(month(g_date)+1,1,year(g_date)) -1
        end if
    else
        let g_start = g_date - 1
        let g_end = g_date
    end if

    call cl_record_init(sfmt("date:%1,version:%2",g_date,g_version))

    call cl_record_card("运行人员：",g_user)
    call cl_record_card("开始时间：",current year to second)
    call cl_record_card("参数：",sfmt("日期：%1 版本：%2 作业编号：%3",g_date,g_version,g_prog))

    call cl_record_header("前置资料确认")
    call scimp500_prepare()
    if g_tot_success = 'N' then
        goto _err
    end if

    -- 资料删除
    call cl_record_header("1. 删除历史资料")

    call scimp500_del()
    if g_tot_success = 'N' then
        goto _err
    end if

    -- 异动单据收集
    call cl_record_header("2. 异动单据收集")
    call scimp500_doc()
    if g_tot_success = 'N' then
        goto _err
    end if

    -- 库存数据
    call cl_record_header("3. 库存数据收集")
    call scimp500_stock()
    if g_tot_success = 'N' then
        goto _err
    end if

    -- 预测 收集
    call cl_record_header("4. 预测数据")
    call scimp500_forcast()
    if g_tot_success = 'N' then
        goto _err
    end if

    -- 出勤人数
    call cl_record_header("5. 出勤人数")
    call scimp500_attend()
    if g_tot_success = 'N' then
        goto _err
    end if

    -- 汇总本期资料
    call cl_record_header("6. 取价、汇总")
    call scimp500_sum()

    call cl_record_card("结束时间：",current year to second)

    call cl_record_html('error,warn,info') returning l_str
    run 'rm /u1/out/darcy.html'
    LET l_channel = base.Channel.create()
    CALL l_channel.openFile('/u1/out/darcy.html',"a" )
    CALL l_channel.writeLine(l_str)
    CALL l_channel.close()
    call cl_download_by_explorer("darcy.html")

    label _err:
    if not p_tran then
        if g_tot_success then
            commit work
        else
            rollback work
        end if
    end if
end function

-- 删除历史资料
-- 库存提示是否删除，默认不删除
private function scimp500_del()
    define  l_curr      varchar(100)
    define  l_cnt       integer

    let l_curr = current hour to second

    select count(*) into l_cnt from tc_ila_file where tc_ila01 = g_date and tc_ila02 = g_version
    if l_cnt > 0 then
        update tc_ila_file
           set  tc_ila03 = l_curr,
                tc_ila04 = '', tc_ila05 = '', tc_ila06 = '', tc_ila07 = '', tc_ila08 = '', tc_ila09 = '', tc_ila10 = '',
                tc_ila11 = '', tc_ila12 = '', tc_ila13 = '', tc_ila14 = '', tc_ila15 = '',
                tc_ila16 = '', tc_ila17 = '', tc_ila18 = '', tc_ila19 = '', tc_ila20 = '',
                tc_ila21 = '', tc_ila22 = '', tc_ila23 = '', tc_ila24 = '', tc_ila25 = '',
                tc_ila26 = '', tc_ila27 = '', tc_ila28 = '', tc_ila29 = '', tc_ila30 = '',
                tc_ila31 = '', tc_ila32 = '', tc_ila33 = '', tc_ila34 = '', tc_ila35 = '',
                tc_ila36 = '', tc_ila37 = '', tc_ila38 = '', tc_ila39 = '', tc_ila40 = '',
                tc_ila41 = '', tc_ila42 = '', tc_ila43 = '', tc_ila44 = '', tc_ila45 = '',
                tc_ila46 = '', tc_ila47 = '', tc_ila48 = '', tc_ila49 = '', tc_ila50 = '',
                tc_ila51 = '', tc_ila52 = '', tc_ila53 = '', tc_ila54 = '', tc_ila55 = '',
                tc_ila56 = '', tc_ila57 = '', tc_ila58 = ''
                -- tc_ila59 = '', tc_ila60 = ''
        where tc_ila01 = g_date and tc_ila02 = g_version
    else
        insert into tc_ila_file (tc_ila01,tc_ila02,tc_ila03)
        values (g_date,g_version,l_curr)
    end if

    if sqlca.sqlcode then
        --call scimp500_error(sfmt("upd tc_ila_file tc_ila01 : %1 ,error : %2",g_date,sqlca.sqlcode),"联系管理员")
        call cl_record('error',sfmt("upd/ins tc_ila_file tc_ila01 : %1 ,error : %2",g_date,sqlca.sqlcode))
        let g_success = 'N'
        return
    end if

    delete from tc_ilb_file where tc_ilb01 = g_date and tc_ilb02 = g_version
    if sqlca.sqlcode then
        --call scimp500_error(sfmt("del tc_ilb_file tc_ilb01 : %1 ,error : %2",g_date,sqlca.sqlcode),g_date,sqlca.sqlcode),"联系管理员")
        call cl_record('error',sfmt("del tc_ilb_file tc_ilb01 : %1 ,error : %2",g_date,sqlca.sqlcode))
        let g_success = 'N'
        return
    end if
    -- 出勤人数也不更新
    --delete from tc_ilc_file where tc_ilc01 = g_date and tc_ilc02 = g_version
    delete from tc_ild_file where tc_ild01 = g_date and tc_ild02 = g_version
    if sqlca.sqlcode then
        --call scimp500_error(sfmt("upd tc_ilc_file tc_ilc01 : %1 ,error : %2",g_date,sqlca.sqlcode),g_date,sqlca.sqlcode),"联系管理员")
        call cl_record('error',sfmt("upd tc_ilc_file tc_ilc01 : %1 ,error : %2",g_date,sqlca.sqlcode))
        let g_success = 'N'
        return
    end if
    delete from tc_ile_file where tc_ile01 = g_date and tc_ile02 = g_version
    if sqlca.sqlcode then
        --call scimp500_error(sfmt("upd tc_ile_file tc_ile01 : %1 ,error : %2",g_date,sqlca.sqlcode),g_date,sqlca.sqlcode),"联系管理员")
        call cl_record('error',sfmt("upd tc_ile_file tc_ile01 : %1 ,error : %2",g_date,sqlca.sqlcode))
        let g_success = 'N'
        return
    end if
    delete from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
    if sqlca.sqlcode then
        --call scimp500_error(sfmt("upd tc_ilf_file tc_ilf01 : %1 ,error : %2",g_date,sqlca.sqlcode),g_date,sqlca.sqlcode),"联系管理员")
        call cl_record('error',sfmt("upd tc_ilf_file tc_ilf01 : %1 ,error : %2",g_date,sqlca.sqlcode))
        let g_success = 'N'
        return
    end if
    -- 库存不更新
    -- delete from tc_ilg_file where tc_ilg01 = g_date and tc_ilg02 = g_version
    delete from tc_ilh_file where tc_ilh01 = g_date and tc_ilh02 = g_version
    if sqlca.sqlcode then
        --call scimp500_error(sfmt("upd tc_ilf_file tc_ilf01 : %1 ,error : %2",g_date,sqlca.sqlcode),g_date,sqlca.sqlcode),"联系管理员")
        call cl_record('error',sfmt("upd tc_ilf_file tc_ilf01 : %1 ,error : %2",g_date,sqlca.sqlcode))
        let g_success = 'N'
        return
    end if
    call cl_record('info',sfmt("删除 %1 资料完成",g_date))
end function

-- 异动单据收集
private function scimp500_doc()
    call scimp500_asft623()
    call scimp500_axmt620()
    call scimp500_axmt700()
end function

-- sql prepare
private function scimp500_prepare()
    define  l_sql       string



end function

-- 工单入库
private function scimp500_asft623()
    define  l_sql           string
    define  l_tc_ilf    record
        tc_ilf01    like tc_ilf_file.tc_ilf01,
        tc_ilf02    like tc_ilf_file.tc_ilf02,
        tc_ilf03    like tc_ilf_file.tc_ilf03,
        tc_ilf05    like tc_ilf_file.tc_ilf05,
        tc_ilf07    like tc_ilf_file.tc_ilf07,
        tc_ilf08    like tc_ilf_file.tc_ilf08,
        docno       like tc_ilf_file.tc_ilf07
    end record
    define  l_tc_ilf13_n    like tc_ilf_file.tc_ilf13
    define  l_tc_ilf13_o    like tc_ilf_file.tc_ilf13

    -- 完工入库
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13) ",
                " select '",g_date,"' ,'",g_version,"' ,'1','',tlf01,
                         tlf06,tlf905,tlf906,tlf62,tlf902,
                         tlf903,tlf904,tlf10
                   from tlf_file
                  where (( tlf06 = '",g_start,"' and tlf08 > '07:59:59') or
                         ( tlf06 = '",g_end,"' and tlf08 < '08:00:00') or
                         ( tlf06 > '",g_start,"' and tlf06 < '",g_end,"' ))
                    and tlf902 in ('P001', 'S009', 'YP003')
                    and tlf13 = 'asft6231'
                    and substr(tlf905, 1, 3) not in ('MKT', 'MSG')"
    prepare scimp500_t623_p1 from l_sql

    -- 返工入库
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13) ",
                " select '",g_date,"' ,'",g_version,"' ,'2','',tlf01,
                         tlf06,tlf905,tlf906,tlf62,tlf902,
                         tlf903,tlf904,tlf10
                   from tlf_file
                  where (( tlf06 = '",g_start,"' and tlf08 > '07:59:59') or
                         ( tlf06 = '",g_end,"' and tlf08 < '08:00:00') or
                         ( tlf06 > '",g_start,"' and tlf06 < '",g_end,"' ))
                    and tlf902 in ('P001', 'S009', 'YP003')
                    and tlf13 = 'asft6231'
                    and substr(tlf905, 1, 3) in ('MKT', 'MSG')"
    prepare scimp500_t623_p2 from l_sql

    -- 返工成套领出
    let l_sql = "insert into tc_ilf_file(
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf09,tc_ilf13) ",
                " select '",g_date,"','",g_version,"','3','',sfb05,
                    sfp03, sfp01, sfq02, sfq03
                    from (select sfp03, sfp01, sfq02, sfb05, sfq03, min(sfe04) sfe04, min(sfe05) sfe05
                            from sfq_file, sfp_file, sfb_file, sfe_file
                           where sfp01 = sfq01 and sfpconf = 'Y' and sfp04 = 'Y'
                             and sfp06 in ('1') and sfb01 = sfq02 and sfe01 = sfq02 and sfe02 = sfp01
                             and substr(sfq02, 1, 3) in ('MSG', 'MKT') and sfp03 between '",g_start,"' and '",g_end,"'
                           group by sfp03, sfp01, sfq02, sfb05, sfq03)
                   where ((sfp03 = '",g_start,"' and sfe05 > '07:59:59') or
                          (sfp03 = '",g_end,"' and sfe05 < '08:00:00') or
                          (sfp03 > '",g_start,"' and sfp03 < '",g_end,"' ))",
                " union all",
                " select '",g_date,"','",g_version,"','4','',sfb05,
                    sfp03, sfp01, sfq02, sfq03
                    from (select sfp03, sfp01, sfq02, sfb05, sfq03, min(sfe04) sfe04, min(sfe05) sfe05
                            from sfq_file, sfp_file, sfb_file, sfe_file
                           where sfp01 = sfq01 and sfpconf = 'Y' and sfp04 = 'Y'
                             and sfp06 in ('6') and sfb01 = sfq02 and sfe01 = sfq02 and sfe02 = sfp01
                             and substr(sfq02, 1, 3) in ('MSG', 'MKT') and sfp03 between '",g_start,"' and '",g_end,"'
                           group by sfp03, sfp01, sfq02, sfb05, sfq03)
                   where ((sfp03 = '",g_start,"' and sfe05 > '07:59:59') or
                          (sfp03 = '",g_end,"' and sfe05 < '08:00:00') or
                          (sfp03 > '",g_start,"' and sfp03 < '",g_end,"' ))"
    prepare scimp500_t623_p3 from l_sql

    -- 1.1 成品入库
    call cl_record('info','成品入库')
    execute scimp500_t623_p1
    if sqlca.sqlcode then
        call cl_record('error',sfmt('成品入库，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t623_p1',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('成品入库，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 1.2 返工入库
    call cl_record('info','返工入库')
    execute scimp500_t623_p2
    if sqlca.sqlcode then
        call cl_record('error',sfmt('返工入库，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t623_p2',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('返工入库，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 1.3 返工领出
    call cl_record('info','返工领出')
    execute scimp500_t623_p3
    if sqlca.sqlcode then
        call cl_record('error',sfmt('返工领出，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t623_p3',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('返工领出，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    return
    -- 暂时不核对差异
    {
    -- 2. 本期与历史核对，只核对31天内的历史数据
    let l_sql = "
    select unique b.tc_ilf01,b.tc_ilf02,b.tc_ilf03,b.tc_ilf05,b.tc_ilf07
      from tc_ilf_file a
      left join tc_ilf_file b
        on a.tc_ilf01 <> b.tc_ilf01
       and a.tc_ilf07 = b.tc_ilf07
       and a.tc_ilf08 = b.tc_ilf08
       and a.tc_ilf02 = b.tc_ilf02
     where a.tc_ilf01 = '",g_date,"'
       and a.tc_ilf02 = '",g_version,"'
       and a.tc_ilf03 in ('1', '2', '3')
       and b.tc_ilf01 between a.tc_ilf01 - 32 and a.tc_ilf01 - 1"
    prepare scimp500_t623_p4 from l_sql
    declare scimp500_t623_cur4 cursor with hold for scimp500_p4

    let l_sql = "
    select sum(tc_ilf13) from tc_ilf_file
    where tc_ilf01 = ? and tc_ilf02 = ? and tc_ilf03 = ?
      and tc_ilf05 = ? and tc_ilf07 = ? "
    prepare scimp500_t623_p5 from l_sql

    --  日期 版本 来源 料件编号 单号 项次
    foreach scimp500_t623_cur4 into l_tc_ilf.tc_ilf01 thru l_tc_ilf.tc_ilf07
        if sqlca.sqlcode then
            call cl_err('scimp500_t623_cur4',sqlca.sqlcode,0)
            exit foreach
        end if
        -- 2.1 除了日期、其它相同，忽略单据，并加入警告 -> warn
        -- 2.2 数量/料号 不同  -> error
        let l_tc_ilf13_o = 0
        let l_tc_ilf13_b = 0
        execute scimp500_t623_p5
          using l_tc_ilf.tc_ilf01,l_tc_ilf.tc_ilf02,l_tc_ilf.tc_ilf03,l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07
           into l_tc_ilf13_o
        if cl_null(l_tc_ilf13_o) then let l_tc_ilf13_o = 0 end if

        execute scimp500_t623_p5
          using g_date,g_version,l_tc_ilf.tc_ilf03,l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07
           into l_tc_ilf13_n
        if cl_null(l_tc_ilf13_n) then let l_tc_ilf13_n = 0 end if

        if l_tc_ilf13_o <> l_tc_ilf13_n then
            -- 数量不一致 -> error
            call cl_record('error',sfmt( "成品料号：%1 单据编号：%2 %3-%4：%5 %6-%7：%8 %9",
                   l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07,g_date,g_version,l_tc_ilf13_n,l_tc_ilf.tc_ilf01,l_tc_ilf.tc_ilf02,l_tc_ilf13_o,scimp500_findaway('old_new_diff')))
            let g_success = 'N'
            --call saimp500_error(
            --sfmt( "成品料号：%1 单据编号：%2 %3-%4：%5 %6-%7：%8",
            --       l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07,g_date,g_version,l_tc_ilf13_n,l_tc_ilf.tc_ilf01,l_tc_ilf.tc_ilf02,l_tc_ilf13_o ),
            --scimp500_findaway('old_new_diff')
        else
            -- 仅核对日期差异，忽略本次 -> warn
            delete from tc_ilf_file
             where tc_ilf01 = g_date and tc_ilf02 = g_version
               and tc_ilf03 = l_tc_ilf.tc_ilf03
               and tc_ilf05 = l_tc_ilf.tc_ilf05 and tc_ilf07 = l_tc_ilf.tc_ilf07
            if sqlca.sqlcode then
                --call saimp500_error( sfmt( "del from tc_ilf error ：%2 ",sqlca.sqlcode), scimp500_findaway('old_new_found'))
                call cl_record('error',sfmt( "del from tc_ilf error ：%1 %2 ",sqlca.sqlcode),scimp500_findaway('old_new_found'))
                let g_success = 'N'
            end if
            call cl_record('warn',sfmt( "成品料号：%1 单据编号：%2 %3-%4 %5",
                l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07,l_tc_ilf.tc_ilf01,l_tc_ilf.tc_ilf02 ),scimp500_findaway('old_new_found'))
            let g_success = 'N'
            --call saimp500_warn(
            --sfmt( "成品料号：%1 单据编号：%2 %3-%4 ",
            --    l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07,l_tc_ilf.tc_ilf01,l_tc_ilf.tc_ilf02 ),
            --scimp500_findaway('old_new_found'))
        end if
    end foreach
    }

    --return
    -- 下面逻辑可以放到稽核中做，目前结构不清晰，
    {
    -- 3. 本月历史单据状态检测 是31天内数据
    let l_sql = "
    select tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf05,tc_ilf07,tc_ilf08,tlf905
      from tc_ilf_file
      left join tlf_file
        on tc_ilf07 = tlf905
       and tc_ilf08 = tlf906
     where tc_ilf02 = '1'
       and month(tc_ilf01) = '",month(g_date),"'
       and tc_ilf03 in ('1', '2')
       and (tc_ilf09 <> nvl(tlf62, '') or tc_ilf13 <> nvl(tlf10, 0) or
           tc_ilf05 <> nvl(tlf01, '') or tlf905 is null)
    union all
    select tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf05,tc_ilf07,0,sfp01
      from tc_ilf_file
      left join (
      select sfp01,sfq02,sum(sfq03) sfq03
        from sfp_file,sfq_file where sfp01=sfq01 and sfpconf='Y' and sfp04='Y'
       group by sfp01,sfq02
      ) on sfp01 = tc_ilf07 and sfq02 = tc_ilf09
     where tc_ilf02 = '3'
       and month(tc_ilf01) = '",month(g_date),"'
       and tc_ilf03 in ('3')
       and (tc_ilf13 <> sfq03 or sfp01 is null)"
    prepare scimp500_t623_p6 from l_sql
    declare scimp500_t623_cur6 cursor for scimp500_t623_p5

    -- TODO 暂时进入 warn
    -- 3.1 状态不同、反审核、过账了  -> error
    -- 3.2 数据已缺失             -> error
    -- 3.3 料号 数量 不同         -> error
    foreach scimp500_t624_cur6 into l_tc_ilf.*
        if sqlca.sqlcode then
            call cl_err('scimp500_t624_cur6',sqlca.sqlcode,1)
            exit foreach
        end if

        if cl_null(l_tc_ilf.docno) then
            if l_tc_ilf.tc_ilf03 matches '[12]' then
                select count(*) into l_cnt from sfu_file where sfu01 = l_tc_ilf.tc_ilf07
            else
                select count(*) into l_cnt from sfp_file where sfp01 = l_tc_ilf.tc_ilf07
            end if
            if l_cnt > 0 then
                -- 单据反审核了
                call scimp500_warn(
                    sfmt('料号：%1 单据：%2 ',l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07),
                    scimp500_findaway('old_undo'))
            else
                -- 单据删除了
                call scimp500_warn(
                    sfmt('料号：%1 单据：%2 ',l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07),
                    scimp500_findaway('old_lost'))
            end if
            continue foreach
        end if
        -- 单据不同
        call scimp500_warn(
            sfmt('料号：%1 单据：%2',l_tc_ilf.tc_ilf05,l_tc_ilf.tc_ilf07),
            scimp500_findaway('old_new_diff'))
    end foreach
    }
end function

-- 出货（成品出货、材料转卖）
private function scimp500_axmt620()
    define  l_sql           string

    call cl_record('info','成品出货、材料转卖')

    -- 成品出货 start end
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13,tc_ilf14,tc_ilf15,
                    tc_ilf16,tc_ilf20,tc_ilf21,tc_ilf22 )",
                " select '",g_date,"','",g_version,"','5','',ogb04,
                         oga02, oga01, ogb03,'',ogb09,
                         ogb091, ogb092, ogb12,'', oga24,
                         0,'-2',oga23,ogb37
                    from oga_file, ogb_file
                   where oga01 = ogb01 and oga09 = '2' and ogaconf = 'Y' and ogapost = 'Y'
                     and instr(ogb04, '.') = 0
                     and oga02 between '",g_start,"' and '",g_end,"' "
    prepare scimp500_t620_p1 from l_sql
    execute scimp500_t620_p1
    if sqlca.sqlcode then
        call cl_record('error',sfmt('成品出货写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t620_p1',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('成品出货，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 材料转卖
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13,tc_ilf14,tc_ilf15,
                    tc_ilf16,tc_ilf20,tc_ilf21,tc_ilf22 )",
                " select '",g_date,"','",g_version,"','6','',ogb04,
                         oga02, oga01, ogb03,'',ogb09,
                         ogb091, ogb092, ogb12,'', oga24,
                         0,'-2',oga23,ogb37
                    from oga_file, ogb_file
                   where oga01 = ogb01 and oga09 = '2' and ogaconf = 'Y' and ogapost = 'Y'
                     and instr(ogb04, '.') > 0
                     and oga02 between '",g_start,"' and '",g_end,"' "
    prepare scimp500_t620_p2 from l_sql
    execute scimp500_t620_p2
    if sqlca.sqlcode then
        call cl_record('error',sfmt('材料转卖写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t620_p2',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('材料转卖，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

end function

-- 销退
private function scimp500_axmt700()
    define  l_sql           string

    call cl_record('info','成品销退、材料销退、折让')

    -- 成品销退 start end
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13,tc_ilf14,tc_ilf15,
                    tc_ilf16,tc_ilf20,tc_ilf21,tc_ilf22 )",
                " select '",g_date,"','",g_version,"','7','',ohb04,
                         oha02, oha01, ohb03,'',ohb09,
                         ohb091, ohb092, ohb12,'', oha24,
                         0,'-2',oha23,ohb37
                    from oha_file, ohb_file
                   where oha01 = ohb01 and ohaconf = 'Y' and ohapost = 'Y'
                     and oha02 between '",g_start,"' and '",g_end,"'
                     and instr(ohb04, '.') = 0 and ohb04 <> 'MISC'
                     and oha09 in ('1', '4') "
    prepare scimp500_t700_p1 from l_sql
    execute scimp500_t700_p1
    if sqlca.sqlcode then
        call cl_record('error',sfmt('成品销退，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t700_p1',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('成品销退，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 材料销退 start end
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13,tc_ilf14,tc_ilf15,
                    tc_ilf16,tc_ilf20,tc_ilf21,tc_ilf22 )",
                " select '",g_date,"','",g_version,"','8','',ohb04,
                         oha02, oha01, ohb03,'',ohb09,
                         ohb091, ohb092, ohb12,'', oha24,
                         ohb12*ohb37*oha24,'-2',oha23,ohb37
                    from oha_file, ohb_file
                   where oha01 = ohb01 and ohaconf = 'Y' and ohapost = 'Y'
                     and oha02 between '",g_start,"' and '",g_end,"'
                     and (instr(ohb04, '.') > 0 or ohb04 = 'MISC')
                     and oha09 in ('1', '4') "
    prepare scimp500_t700_p2 from l_sql
    execute scimp500_t700_p2
    if sqlca.sqlcode then
        call cl_record('error',sfmt('材料销退，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t700_p2',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('材料销退，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 折让 start end
    let l_sql = "insert into tc_ilf_file (
                    tc_ilf01,tc_ilf02,tc_ilf03,tc_ilf04,tc_ilf05,
                    tc_ilf06,tc_ilf07,tc_ilf08,tc_ilf09,tc_ilf10,
                    tc_ilf11,tc_ilf12,tc_ilf13,tc_ilf14,tc_ilf15,
                    tc_ilf16,tc_ilf20,tc_ilf21,tc_ilf22 )",
                " select '",g_date,"','",g_version,"','9','',ohb04,
                         oha02, oha01, ohb03,'',ohb09,
                         ohb091, ohb092, ohb12,'', oha24,
                         ohb14*oha24,'-2',oha23,ohb14
                    from oha_file, ohb_file
                   where oha01 = ohb01 and ohaconf = 'Y' and ohapost = 'Y'
                     and oha02 between '",g_start,"' and '",g_end,"'
                     and oha09 in ('5') "
    prepare scimp500_t700_p3 from l_sql
    execute scimp500_t700_p3
    if sqlca.sqlcode then
        call cl_record('error',sfmt('折让金额，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilf_file scimp500_t700_p3',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('折让金额，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

end function

-- 当前库存
private function scimp500_stock()
    define  l_sql           string
    define  l_cnt           integer
    define  l_curr          varchar(10)

    call cl_record('info','实时库存')

    select count(*) into l_cnt from tc_ilg_file
     where tc_ilg01 = g_date and tc_ilg02 = g_version
    if l_cnt > 0 then
        call cl_record('info','库存资料已经存在，不再重复计算')
        return
    end if

    let l_sql = "insert into tc_ilg_file (
                    tc_ilg01,tc_ilg02,tc_ilg03,tc_ilg04,tc_ilg05,
                    tc_ilg06,tc_ilg07,tc_ilg13,tc_ilg14)",
                " select '",g_date,"','",g_version,"',img01,img02,img03,
                         img04,img10,img18,img37
                    from img_file
                   where img02 in ('P001', 'P008','S006', 'S009', 'YP003') and img10 != 0 "
    prepare scimp500_stock_p1 from l_sql
    execute scimp500_stock_p1
    if sqlca.sqlcode then
        call cl_record('error',sfmt('库存，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilg_file scimp500_stock_p1',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('库存，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 更新库存计算日期
    let l_curr = current hour to second
    update tc_ila_file set tc_ila59 = g_today,tc_ila60 = l_curr
     where tc_ila01 = g_date and tc_ila02 = g_version
    if sqlca.sqlcode then
        call cl_record('error',sfmt('更新库存计算时间失败 : %1',sqlca.sqlcode))
        call cl_err('upd tc_ila_file stock modidy',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
end function

-- 出勤人数
private function scimp500_attend()
    call cl_record('info','出勤人数')

    insert into tc_ilc_file ( tc_ilc01,tc_ilc02,tc_ilc03,tc_ilc04,tc_ilc05 )
    select g_date,g_version,dat,'all',qty
      from attend_file where dat between g_start and g_end
    if sqlca.sqlcode or sqlca.sqlerrd[3] == 0 then
        call cl_record('error',sfmt('出勤人数获取失败 : %1',sqlca.sqlcode))
        call cl_err('upd tc_ilc_file attend qty',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('出勤人数获取失败，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))
end function

-- 预测金额
private function scimp500_forcast()

    call cl_record('info','预测销售、入库')

    insert into tc_ilb_file ( tc_ilb01,tc_ilb02,tc_ilb03,tc_ilb04,tc_ilb05,tc_ilb06 )
    select g_date,g_version,tc_ili03,tc_ili04,tc_ili05,tc_ili06
      from tc_ili_file where tc_ili01 = year(g_date) and tc_ili01 = month(g_date)

    if sqlca.sqlcode then
        call cl_record('error',sfmt('预测入库，销售，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilb_file ',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('预测入库，销售，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

end function

-- 汇总本期资料
private function scimp500_sum()
    define  l_sql       string
    define  l_yy,l_mm   integer
    define  l_curr      varchar(10)
    define  l_tc_ila05      like tc_ila_file.tc_ila05,
            l_tc_ila06      like tc_ila_file.tc_ila06,
            l_tc_ila07      like tc_ila_file.tc_ila07,
            l_tc_ila08      like tc_ila_file.tc_ila08,
            l_tc_ila09      like tc_ila_file.tc_ila09,
            l_tc_ila10      like tc_ila_file.tc_ila10,
            l_tc_ila11      like tc_ila_file.tc_ila11,
            l_tc_ila12      like tc_ila_file.tc_ila12,
            l_tc_ila13      like tc_ila_file.tc_ila13,
            l_tc_ila14      like tc_ila_file.tc_ila14,
            l_tc_ila15      like tc_ila_file.tc_ila15,
            l_tc_ila16      like tc_ila_file.tc_ila16,
            l_tc_ila17      like tc_ila_file.tc_ila17,
            l_tc_ila18      like tc_ila_file.tc_ila18,
            l_tc_ila19      like tc_ila_file.tc_ila19,
            l_tc_ila20      like tc_ila_file.tc_ila20,
            l_tc_ila21      like tc_ila_file.tc_ila21,
            l_tc_ila22      like tc_ila_file.tc_ila22,
            l_tc_ila23      like tc_ila_file.tc_ila23,
            l_tc_ila24      like tc_ila_file.tc_ila24,
            l_tc_ila25      like tc_ila_file.tc_ila25,
            l_tc_ila26      like tc_ila_file.tc_ila26,
            l_tc_ila27      like tc_ila_file.tc_ila27,
            l_tc_ila28      like tc_ila_file.tc_ila28,
            l_tc_ila29      like tc_ila_file.tc_ila29,
            l_tc_ila30      like tc_ila_file.tc_ila30,
            l_tc_ila31      like tc_ila_file.tc_ila31,
            l_tc_ila32      like tc_ila_file.tc_ila32,
            l_tc_ila33      like tc_ila_file.tc_ila33,
            l_tc_ila34      like tc_ila_file.tc_ila34,
            l_tc_ila35      like tc_ila_file.tc_ila35,
            l_tc_ila36      like tc_ila_file.tc_ila36,
            l_tc_ila37      like tc_ila_file.tc_ila37,
            l_tc_ila38      like tc_ila_file.tc_ila38,
            l_tc_ila39      like tc_ila_file.tc_ila39,
            l_tc_ila40      like tc_ila_file.tc_ila40,
            l_tc_ila41      like tc_ila_file.tc_ila41,
            l_tc_ila42      like tc_ila_file.tc_ila42,
            l_tc_ila43      like tc_ila_file.tc_ila43,
            l_tc_ila44      like tc_ila_file.tc_ila44,
            l_tc_ila45      like tc_ila_file.tc_ila45,
            l_tc_ila46      like tc_ila_file.tc_ila46,
            l_tc_ila47      like tc_ila_file.tc_ila47,
            l_tc_ila48      like tc_ila_file.tc_ila48,
            l_tc_ila49      like tc_ila_file.tc_ila49,
            l_tc_ila50      like tc_ila_file.tc_ila50,
            l_tc_ila51      like tc_ila_file.tc_ila51,
            l_tc_ila52      like tc_ila_file.tc_ila52,
            l_tc_ila53      like tc_ila_file.tc_ila53,
            l_tc_ila54      like tc_ila_file.tc_ila54,
            l_tc_ila55      like tc_ila_file.tc_ila55,
            l_tc_ila56      like tc_ila_file.tc_ila56,
            l_tc_ila57      like tc_ila_file.tc_ila57,
            l_tc_ila58      like tc_ila_file.tc_ila58,
            l_tc_ila16_1    like tc_ila_file.tc_ila16,
            l_tc_ila17_1    like tc_ila_file.tc_ila17,
            l_tc_ila18_1    like tc_ila_file.tc_ila18,
            l_tc_ila69      like tc_ila_file.tc_ila69,
            l_tc_ila70      like tc_ila_file.tc_ila70,
            l_tc_ila71      like tc_ila_file.tc_ila71

    if month(g_date) = 1 then
        let l_yy = year(g_date)-1
        let l_mm = 12
    else
        let l_yy = year(g_date)
        let l_mm = month(g_date)-1
    end if
    -- 未签收部分计算
    call simp500_unsign(l_yy,l_mm)
    -- 先处理单价
    call scimp500_price()

    -- 汇率 tc_ila05 、上月汇率 tc_ila06 仅美元
    select tc_ild06 into l_tc_ila05 from tc_ild_file
     where tc_ild01 = g_date and tc_ild02 = g_version
       and tc_ild03 = 'USD'
       and tc_ild04 = year(g_date) and tc_ild05 = month(g_date)

    select tc_ild06 into l_tc_ila06 from tc_ild_file
     where tc_ild01 = g_date and tc_ild02 = g_version
       and tc_ild03 = 'USD'
       and tc_ild04 = l_yy and tc_ild05 = l_mm

    -- 成品入库 tc_ila07，tc_ila08，tc_ila09
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila07,l_tc_ila08,l_tc_ila09
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('1')

    -- 返工入库 tc_ila13，tc_ila14，tc_ila15
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila13,l_tc_ila14,l_tc_ila15
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('2')

    -- 返工领出 tc_ila16，tc_ila17，tc_ila18
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila16,l_tc_ila17,l_tc_ila18
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('3')

    -- 累计返工 l_tc_ila69，l_tc_ila70，l_tc_ila71
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila69,l_tc_ila70,l_tc_ila71
      from tc_ilf_file where tc_ilf02 = g_version
       and tc_ilf03 in ('3')
       and year(tc_ilf01) = year(g_date)
       and month(tc_ilf01) = month(g_date)

    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
        into l_tc_ila16_1,l_tc_ila17_1,l_tc_ila18_1
        from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
        and tc_ilf03 in ('4')
    let l_tc_ila16 = l_tc_ila16 - l_tc_ila16_1
    let l_tc_ila17 = l_tc_ila17 - l_tc_ila17_1
    let l_tc_ila18 = l_tc_ila18 - l_tc_ila18_1

    -- 入库计划 tc_ila19 tc_ila24
    select sum(tc_ilb06) into l_tc_ila19 from tc_ilb_file
     where tc_ilb01 = g_date and tc_ilb02 = g_version
       and tc_ilb03 = g_date and tc_ilb04 = 'inbound'
    select sum(tc_ilb06) into l_tc_ila24 from tc_ilb_file
     where tc_ilb01 = g_date and tc_ilb02 = g_version
       and tc_ilb04 = 'inbound'

    -- 销售计划 tc_ila37 tc_ila54
    select sum(tc_ilb06) into l_tc_ila37 from tc_ilb_file
     where tc_ilb01 = g_date and tc_ilb02 = g_version
       and tc_ilb03 = g_date and tc_ilb04 = 'outbound'
    select sum(tc_ilb06) into l_tc_ila54 from tc_ilb_file
     where tc_ilb01 = g_date and tc_ilb02 = g_version
       and tc_ilb04 = 'outbound'

    -- 成品出货 tc_ila26，tc_ila27，tc_ila28
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila26,l_tc_ila27,l_tc_ila28
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('5')

    -- 销退 tc_ila29，tc_ila30，tc_ila31
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila29,l_tc_ila30,l_tc_ila31
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('7')

    -- 材料转卖 tc_ila43
    select sum(tc_ilf16* tc_ilf13) into l_tc_ila43
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('6')

    -- 折让 tc_ila35
    select sum(tc_ilf16) into l_tc_ila35
      from tc_ilf_file where tc_ilf01 = g_date and tc_ilf02 = g_version
       and tc_ilf03 in ('8','9')

    -- 未签收金额 tc_ila45，tc_ila46，tc_ila47
    select sum(tc_ilj15*tc_ilj11),sum(tc_ilj16*tc_ilj11),sum(tc_ilj17*tc_ilj11)
      into l_tc_ila45,l_tc_ila46,l_tc_ila47
      from tc_ilj_file
     where tc_ilj01 = l_yy and tc_ilj02 = l_mm

    -- 样品未签收 tc_ila48 料号判断
    select sum(tc_ilj15*tc_ilj11)+sum(tc_ilj16*tc_ilj11)+sum(tc_ilj17*tc_ilj11)
      into l_tc_ila48
      from tc_ilj_file
     where tc_ilj01 = l_yy and tc_ilj02 = l_mm
       and tc_ilj03 not like '%R'

    -- 成品库存 tc_ila55
    select sum(tc_ilg08* tc_ilg07) into l_tc_ila55 from tc_ilg_file
     where tc_ilg01 = g_date and tc_ilg02 = g_version
       and tc_ilg04 in ('P001','S008')

    -- 样品 tc_ila56
    select sum(tc_ilg08* tc_ilg07) into l_tc_ila56 from tc_ilg_file
     where tc_ilg01 = g_date and tc_ilg02 = g_version
       and tc_ilg04 = 'YP003'

    -- 呆滞 tc_ila57
    select sum(tc_ilg08* tc_ilg07) into l_tc_ila57 from tc_ilg_file
     where tc_ilg01 = g_date and tc_ilg02 = g_version
       and tc_ilg04 = 'S006'

    -- 销退 tc_ila58
    select sum(tc_ilg08* tc_ilg07) into l_tc_ila58 from tc_ilg_file
     where tc_ilg01 = g_date and tc_ilg02 = g_version
       and tc_ilg04 = 'S009'

    -- 累计成品入库 tc_ila10,tc_ila11,tc_ila12
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila10,l_tc_ila11,l_tc_ila12
      from tc_ilf_file where tc_ilf02 = g_version
       and tc_ilf03 in ('1')
       and year(tc_ilf01) = year(g_date)
       and month(tc_ilf01) = month(g_date)

    -- 累计入库 + 返工入库 - 返工领出  tc_ila21,tc_ila22,tc_ila23
    let l_sql = "
    select sum(tc_ilf17),sum(tc_ilf18),sum(tc_ilf19)
      from (
    select tc_ilf17* tc_ilf13 tc_ilf17,tc_ilf18* tc_ilf13 tc_ilf18,tc_ilf19* tc_ilf13 tc_ilf19
      from tc_ilf_file where tc_ilf01 = '",g_date,"'
       and tc_ilf02 = '",g_version,"'
       and tc_ilf03 in ('1','2','4')
       and year(tc_ilf01) = year(?)
       and month(tc_ilf01) = month(?)
    union all
    select -tc_ilf17* tc_ilf13,-tc_ilf18* tc_ilf13,-tc_ilf19* tc_ilf13
      from tc_ilf_file where tc_ilf01 = '",g_date,"'
       and tc_ilf02 = '",g_version,"'
       and tc_ilf03 = '3'
       and year(tc_ilf01) = year(?)
       and month(tc_ilf01) = month(?) )"
    prepare scimp500_sum_p1 from l_sql
    execute scimp500_sum_p1
      using g_date,g_date,g_date,g_date
       into l_tc_ila21,l_tc_ila22,l_tc_ila23

    -- 累计销退 tc_ila32,tc_ila33,tc_ila34
    select sum(tc_ilf17* tc_ilf13),sum(tc_ilf18* tc_ilf13),sum(tc_ilf19* tc_ilf13)
      into l_tc_ila32,l_tc_ila33,l_tc_ila34
      from tc_ilf_file where tc_ilf01 = g_date
       and tc_ilf02 = g_version
       and tc_ilf03 in ('7')
       and year(tc_ilf01) = year(g_date)
       and month(tc_ilf01) = month(g_date)

    -- 累计折让 tc_ila36
    select sum(tc_ilf16) into l_tc_ila36
      from tc_ilf_file where tc_ilf01 = g_date
       and tc_ilf02 = g_version
       and tc_ilf03 in ('8','9')
       and year(tc_ilf01) = year(g_date)
       and month(tc_ilf01) = month(g_date)

    -- 累计出货 - 销退 - 折让 tc_ila39,tc_ila40,tc_ila41,tc_ila42
    let l_sql = "
    select sum(tc_ilf17),sum(tc_ilf18),sum(tc_ilf19)
       from (
    select tc_ilf17* tc_ilf13 tc_ilf17,tc_ilf18* tc_ilf13 tc_ilf18,tc_ilf19* tc_ilf13 tc_ilf19
      from tc_ilf_file where tc_ilf01 = '",g_date,"'
       and tc_ilf02 = '",g_version,"'
       and tc_ilf03 in ('5')
       and year(tc_ilf01) = year(?)
       and month(tc_ilf01) = month(?)
    union all
    select -tc_ilf17* tc_ilf13,-tc_ilf18* tc_ilf13,-tc_ilf19* tc_ilf13
      from tc_ilf_file where tc_ilf01 = '",g_date,"'
       and tc_ilf02 = '",g_version,"'
       and tc_ilf03 in ('7')
       and year(tc_ilf01) = year(?)
       and month(tc_ilf01) = month(?) )"
    prepare scimp500_sum_p2 from l_sql
    execute scimp500_sum_p2
      using g_date,g_date,g_date,g_date
       into l_tc_ila40,l_tc_ila41,l_tc_ila42

    let l_tc_ila36 = l_tc_ila40 + l_tc_ila41 + l_tc_ila42 - l_tc_ila36

    -- 累计转卖 tc_ila44
    select sum(tc_ilf16* tc_ilf13) into l_tc_ila44
      from tc_ilf_file where tc_ilf01 = g_date
       and tc_ilf02 = g_version
       and tc_ilf03 in ('6')
       and year(tc_ilf01) = year(g_date)
       and month(tc_ilf01) = month(g_date)

    -- 累计应收 出货+上月未签收 折让 转卖
    -- tc_ila49,tc_ila50,tc_ila51,tc_ila52,tc_ila53
    let l_tc_ila49 = l_tc_ila40 + l_tc_ila45
    let l_tc_ila50 = l_tc_ila41 + l_tc_ila46
    let l_tc_ila51 = l_tc_ila42 + l_tc_ila45
    let l_tc_ila52 = l_tc_ila44
    let l_tc_ila53 = l_tc_ila36

    let l_curr = current hour to second

    update tc_ila_file
       set  tc_ila04 = l_curr,      -- 结束时间
            tc_ila05 = l_tc_ila05,  -- 本月汇率
            tc_ila06 = l_tc_ila06,  -- 上月汇率
            tc_ila07 = nvl(l_tc_ila07 / 10000 , 0 ) ,  -- 成品入库 - 组装
            tc_ila08 = nvl(l_tc_ila08 / 10000 , 0 ) ,  -- 成品入库 - 光板
            tc_ila09 = nvl(l_tc_ila09 / 10000 , 0 ) ,  -- 成品入库 - 器件
            tc_ila10 = nvl(l_tc_ila10 / 10000 , 0 ) ,  -- 成品入库 - 组装 - 累计
            tc_ila11 = nvl(l_tc_ila11 / 10000 , 0 ) ,  -- 成品入库 - 光板 - 累计
            tc_ila12 = nvl(l_tc_ila12 / 10000 , 0 ) ,  -- 成品入库 - 器件 - 累计
            tc_ila13 = nvl(l_tc_ila13 / 10000 , 0 ) ,  -- 返工入库 - 组装
            tc_ila14 = nvl(l_tc_ila14 / 10000 , 0 ) ,  -- 返工入库 - 光板
            tc_ila15 = nvl(l_tc_ila15 / 10000 , 0 ) ,  -- 返工入库 - 器件
            tc_ila16 = nvl(l_tc_ila16 / 10000 , 0 ) ,  -- 返工领出 - 组装
            tc_ila17 = nvl(l_tc_ila17 / 10000 , 0 ) ,  -- 返工领出 - 光板
            tc_ila18 = nvl(l_tc_ila18 / 10000 , 0 ) ,  -- 返工领出 - 器件
            tc_ila19 = nvl(l_tc_ila19 / 10000 , 0 ) ,  -- 预测入库
            tc_ila20 = nvl(l_tc_ila20 / 10000 , 0 ) ,  -- 实际入库
            tc_ila21 = nvl(l_tc_ila21 / 10000 , 0 ) ,  -- 成品入库 + 返工入库 - 返工领出 - 组装 - 累计
            tc_ila22 = nvl(l_tc_ila22 / 10000 , 0 ) ,  -- 成品入库 + 返工入库 - 返工领出 - 光板 - 累计
            tc_ila23 = nvl(l_tc_ila23 / 10000 , 0 ) ,  -- 成品入库 + 返工入库 - 返工领出 - 器件 - 累计
            tc_ila24 = nvl(l_tc_ila24 / 10000 , 0 ) ,  -- 预测入库 - 累计
            tc_ila25 = nvl(l_tc_ila25 / 10000 , 0 ) ,  -- tc_ila21 + tc_ila22 + tc_ila23 - tc_ila24
            tc_ila26 = nvl(l_tc_ila26 / 10000 , 0 ) ,  -- 成品出货 - 组装
            tc_ila27 = nvl(l_tc_ila27 / 10000 , 0 ) ,  -- 成品出货 - 光板
            tc_ila28 = nvl(l_tc_ila28 / 10000 , 0 ) ,  -- 成品出货 - 器件
            tc_ila29 = nvl(l_tc_ila29 / 10000 , 0 ) ,  -- 销退 - 组装
            tc_ila30 = nvl(l_tc_ila30 / 10000 , 0 ) ,  -- 销退 - 光板
            tc_ila31 = nvl(l_tc_ila31 / 10000 , 0 ) ,  -- 销退 - 器件
            tc_ila32 = nvl(l_tc_ila32 / 10000 , 0 ) ,  -- 销退 - 组装 - 累计
            tc_ila33 = nvl(l_tc_ila33 / 10000 , 0 ) ,  -- 销退 - 光板 - 累计
            tc_ila34 = nvl(l_tc_ila34 / 10000 , 0 ) ,  -- 销退 - 器件 - 累计
            tc_ila35 = nvl(l_tc_ila35 / 10000 , 0 ) ,  -- 折让
            tc_ila36 = nvl(l_tc_ila36 / 10000 , 0 ) ,  -- 折让 - 累计
            tc_ila37 = nvl(l_tc_ila37 / 10000 , 0 ) ,  -- 销售预测
            tc_ila38 = nvl(l_tc_ila38 / 10000 , 0 ) ,  -- 成品出货 - 销退 - 折让 - 销售预测
            tc_ila39 = nvl(l_tc_ila39 / 10000 , 0 ) ,  -- 成品出货 - 组装 - 累计
            tc_ila40 = nvl(l_tc_ila40 / 10000 , 0 ) ,  -- 成品出货 - 光板 - 累计
            tc_ila41 = nvl(l_tc_ila41 / 10000 , 0 ) ,  -- 成品出货 - 器件 - 累计
            tc_ila42 = nvl(l_tc_ila42 / 10000 , 0 ) ,  -- 折让 - 累计 tc_ila36
            tc_ila43 = nvl(l_tc_ila43 / 10000 , 0 ) ,  -- 材料转卖
            tc_ila44 = nvl(l_tc_ila44 / 10000 , 0 ) ,  -- 材料转卖 - 累计
            tc_ila45 = nvl(l_tc_ila45 / 10000 , 0 ) ,  -- 未签收 - 组装
            tc_ila46 = nvl(l_tc_ila46 / 10000 , 0 ) ,  -- 未签收 - 光板
            tc_ila47 = nvl(l_tc_ila47 / 10000 , 0 ) ,  -- 未签收 - 器件
            tc_ila48 = nvl(l_tc_ila48 / 10000 , 0 ) ,  -- 未签收 - 样品
            tc_ila49 = nvl(l_tc_ila49 / 10000 , 0 ) ,  -- 成品出货 + 未签收 + - 销退 - 组装 - 累计
            tc_ila50 = nvl(l_tc_ila50 / 10000 , 0 ) ,  -- 成品出货 + 未签收 + - 销退 - 光板 - 累计
            tc_ila51 = nvl(l_tc_ila51 / 10000 , 0 ) ,  -- 成品出货 + 未签收 + - 销退 - 器件 - 累计
            tc_ila52 = nvl(l_tc_ila52 / 10000 , 0 ) ,  -- 材料转卖 - 累计 tc_ila44
            tc_ila53 = nvl(l_tc_ila53 / 10000 , 0 ) ,  -- 折让 - 累计 tc_ila36
            tc_ila54 = nvl(l_tc_ila54 / 10000 , 0 ) ,  -- 销售预测 - 累计
            tc_ila55 = nvl(l_tc_ila55 / 10000 , 0 ) ,  -- 成品库存
            tc_ila56 = nvl(l_tc_ila56 / 10000 , 0 ) ,  -- 样品库存
            tc_ila57 = nvl(l_tc_ila57 / 10000 , 0 ) ,  -- 呆滞库存
            tc_ila58 = nvl(l_tc_ila58 / 10000 , 0 ) ,  -- 销退库存
            tc_ila69 = nvl(l_tc_ila69 / 10000 , 0 ) ,  -- 返工领出 - 组装 - 累计
            tc_ila70 = nvl(l_tc_ila70 / 10000 , 0 ) ,  -- 返工领出 - 光板 - 累计
            tc_ila71 = nvl(l_tc_ila71 / 10000 , 0 )    -- 返工领出 - 器件 - 累计
     where tc_ila01 = g_date and tc_ila02 = g_version

     select
     tc_ila05,tc_ila06,tc_ila07,tc_ila08,tc_ila09,tc_ila10,tc_ila11,tc_ila12,tc_ila13,tc_ila14,tc_ila15,tc_ila16,tc_ila17,tc_ila18,tc_ila19,tc_ila20,tc_ila21,tc_ila22,tc_ila23,tc_ila24,tc_ila25,tc_ila26,tc_ila27,tc_ila28,tc_ila29,tc_ila30,tc_ila31,tc_ila32,tc_ila33,tc_ila34,tc_ila35,tc_ila36,tc_ila37,tc_ila38,tc_ila39,tc_ila40,tc_ila41,tc_ila42,tc_ila43,tc_ila44,tc_ila45,tc_ila46,tc_ila47,tc_ila48,tc_ila49,tc_ila50,tc_ila51,tc_ila52,tc_ila53,tc_ila54,tc_ila55,tc_ila56,tc_ila57,tc_ila58,tc_ila69,tc_ila70,tc_ila71
     into
     l_tc_ila05,l_tc_ila06,l_tc_ila07,l_tc_ila08,l_tc_ila09,l_tc_ila10,l_tc_ila11,l_tc_ila12,l_tc_ila13,l_tc_ila14,l_tc_ila15,l_tc_ila16,l_tc_ila17,l_tc_ila18,l_tc_ila19,l_tc_ila20,l_tc_ila21,l_tc_ila22,l_tc_ila23,l_tc_ila24,l_tc_ila25,l_tc_ila26,l_tc_ila27,l_tc_ila28,l_tc_ila29,l_tc_ila30,l_tc_ila31,l_tc_ila32,l_tc_ila33,l_tc_ila34,l_tc_ila35,l_tc_ila36,l_tc_ila37,l_tc_ila38,l_tc_ila39,l_tc_ila40,l_tc_ila41,l_tc_ila42,l_tc_ila43,l_tc_ila44,l_tc_ila45,l_tc_ila46,l_tc_ila47,l_tc_ila48,l_tc_ila49,l_tc_ila50,l_tc_ila51,l_tc_ila52,l_tc_ila53,l_tc_ila54,l_tc_ila55,l_tc_ila56,l_tc_ila57,l_tc_ila58,l_tc_ila69,l_tc_ila70,l_tc_ila71
     from tc_ila_file where tc_ila01 = g_date and tc_ila02 = g_version

     call cl_record_card("结束时间：",current year to second)

     call cl_record_card("日期：", g_date using 'dd-mmm-yyyy')
     call cl_record_card("本月剩余天数：",
     iif(
        month(g_date)==12,
        mdy(1,1,year(g_date))-g_date-1,
        mdy(month(g_date)+1,1,year(g_date))-g_date-1
     ))
     call cl_record_card("税率：",
     sfmt("本月：%1 上月：%1",l_tc_ila05,l_tc_ila06))
     call cl_record_card("成品入库：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila07+l_tc_ila08+l_tc_ila09,l_tc_ila07,l_tc_ila08,l_tc_ila09))
     call cl_record_card("累计成品入库：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila10+l_tc_ila11+l_tc_ila12,l_tc_ila10,l_tc_ila11,l_tc_ila12))
     call cl_record_card("返工入库：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila13+l_tc_ila14+l_tc_ila16,l_tc_ila13,l_tc_ila14,l_tc_ila15))
     call cl_record_card("返工领出：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila16+l_tc_ila17+l_tc_ila18,l_tc_ila16,l_tc_ila17,l_tc_ila18))
     call cl_record_card("累计返工领出：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila69+l_tc_ila70+l_tc_ila71,l_tc_ila69,l_tc_ila70,l_tc_ila71))
     call cl_record_card("入库预测",sfmt("预测：%1 实际：%2 差异: %3",l_tc_ila19,l_tc_ila20,l_tc_ila20-l_tc_ila19))
     call cl_record_card("累计入库：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila21+l_tc_ila22+l_tc_ila23,l_tc_ila21,l_tc_ila22,l_tc_ila23))
     call cl_record_card("累计入库预测",sfmt("预测：%1 差异: %2",l_tc_ila24,l_tc_ila25))
     call cl_record_card("成品出货：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila26+l_tc_ila27+l_tc_ila28,l_tc_ila26,l_tc_ila27,l_tc_ila28))
     call cl_record_card("销退：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila29+l_tc_ila30+l_tc_ila31,l_tc_ila29,l_tc_ila30,l_tc_ila31))
     call cl_record_card("累计销退：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4)",l_tc_ila32+l_tc_ila33+l_tc_ila34,l_tc_ila32,l_tc_ila33,l_tc_ila34))
     call cl_record_card("折让",sfmt("日：%1 月：%2 ",l_tc_ila35,l_tc_ila36))
     call cl_record_card("日出货",sfmt("预测：%1 出货：%2 差异：%3",l_tc_ila37,l_tc_ila38,l_tc_ila38-l_tc_ila37))

     call cl_record_card("累计出货：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4 dct: %5)",l_tc_ila39+l_tc_ila40+l_tc_ila41-l_tc_ila42,l_tc_ila39,l_tc_ila40,l_tc_ila41,-l_tc_ila42))
     call cl_record_card("材料转卖",sfmt("日：%1 月：%2 ",l_tc_ila43,l_tc_ila44))
     call cl_record_card("未签收：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4 ) samples: %5",l_tc_ila45+l_tc_ila46+l_tc_ila47,l_tc_ila45,l_tc_ila46,l_tc_ila47,l_tc_ila48))
     call cl_record_card("应收账款：",
     sfmt("%1 (smt: %2 fpc: %3 comp: %4 other: %5 dct: %6 )",l_tc_ila49+l_tc_ila50+l_tc_ila51+l_tc_ila52-l_tc_ila53,l_tc_ila49,l_tc_ila50,l_tc_ila51,l_tc_ila52,l_tc_ila53))
     call cl_record_card("累计销售",sfmt("预测：%1 差异：%2",l_tc_ila54,l_tc_ila49+l_tc_ila50+l_tc_ila51+l_tc_ila52-l_tc_ila53-l_tc_ila54))
     call cl_record_card("库存",sfmt("成品：%1 样品：%2 呆滞：%3 客退：%4",l_tc_ila55,l_tc_ila56,l_tc_ila57,l_tc_ila58))
end function

-- 处理单价
private function scimp500_price()
    define  l_sql       string
    define  l_tc_ile03  integer

    -- 本月与上月汇率
    call cl_record('info','汇率归集')
    let l_sql = "
    insert into tc_ild_file (tc_ild01,tc_ild02,tc_ild03,tc_ild04,tc_ild05,tc_ild06)
    select '",g_date,"','",g_version,"',azj01, substr(azj02, 1, 4), substr(azj02, 5, 2), azj03 from azj_file
     where azj02 in (to_char(?, 'yyyymm'), to_char(trunc(?, 'mm') - 1, 'yyyymm')) "
    prepare scimp500_price_p1 from l_sql
    execute scimp500_price_p1 using g_date,g_date
    if sqlca.sqlcode then
        call cl_record('error',sfmt('汇率归集，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ile_file scimp500_price_p1 ',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('汇率归集，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 将本期用到的所有料号（入库、出货、库存）最新单价取到单价表中
    call cl_record('info','料号单价归集')
    let l_sql = "
    insert into tc_ile_file (
        tc_ile01,tc_ile02,tc_ile03,tc_ile04,tc_ile05,
        tc_ile06,tc_ile07,tc_ile08,tc_ile09,tc_ile10,
        tc_ile11,tc_ile12)
    select '",g_date,"','",g_version,"',rownum,tc_xme00,tc_xmf01,
            tc_xmf03,tc_xmedate,tc_xme02,tc_xmf05,tc_xmf08,
            tc_xmf10,tc_xmf07 from (
        select tc_xmf03, tc_xme02, tc_xmf05, tc_xmf08, tc_xmf10, tc_xmf07,
            tc_xmedate, tc_xme00, tc_xmf01,
            dense_rank() over (partition by tc_xmf03 order by tc_xmedate desc, tc_xme00 desc, tc_xmf01 desc) as rn
        from tc_xme_file, tc_xmf_file
        where tc_xme00 = tc_xmf00 and tc_xmeconf = 'Y'
        and ( exists ( select 1 from tc_ilf_file where tc_ilf01 = '",g_date,"' and tc_ilf02 = '",g_version,"' and tc_ilf05 = tc_xmf03)
            or exists ( select 1 from tc_ilg_file where tc_ilg01 = '",g_date,"' and tc_ilg02 = '",g_version,"' and tc_ilg03 = tc_xmf03)
            ) ) where rn =1"
    prepare scimp500_price_p2 from l_sql
    execute scimp500_price_p2
    if sqlca.sqlcode then
        call cl_record('error',sfmt('料号单价归集，写入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ile_file scimp500_price_p2',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('料号单价归集，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))


    -- 入库 取最新单价
    call cl_record('info','入库取最新单价')
    let l_sql = "
    merge into tc_ilf_file
    using (select tc_ile01,tc_ile02,tc_ile03,tc_ile04,tc_ile05,tc_ile06,tc_ile08,tc_ile09,tc_ile10,tc_ile11,tc_ile12,nvl(tc_ild06,1) tc_ild06
             from tc_ile_file
             left join tc_ild_file on tc_ile01 = tc_ild01 and tc_ile02 = tc_ild02
                   and tc_ile08 = tc_ild03 and tc_ild04 = year(?)
                   and tc_ild05 = month(?)
            where tc_ile01 = '",g_date,"' and tc_ile02 = '",g_version,"')
       on (tc_ilf01 = tc_ile01 and tc_ilf02 = tc_ile02 and tc_ilf05 = tc_ile06 and tc_ilf03 in ('1','2','3','4') )
     when matched then update set
            tc_ilf22 = tc_ile09,
            tc_ilf21 = tc_ile08,
            tc_ilf15 = tc_ild06,
            tc_ilf16 = tc_ile09 * tc_ild06,
            tc_ilf17 = tc_ile10 * tc_ild06,
            tc_ilf18 = tc_ile11 * tc_ild06,
            tc_ilf19 = tc_ile12 * tc_ild06,
            tc_ilf20 = tc_ile03 "
    prepare scimp500_price_p3 from l_sql
    execute scimp500_price_p3 using g_date,g_date
    if sqlca.sqlcode then
        call cl_record('error',sfmt('入库取最新单价，写入失败:%1',sqlca.sqlcode))
        call cl_err('merge tc_ilf_file scimp500_price_p3',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('入库取最新单价，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 库存取最新单价
    call cl_record('info','库存取最新单价')
    let l_sql = "
    merge into tc_ilg_file
    using (select tc_ile01,tc_ile02,tc_ile03,tc_ile04,tc_ile05,tc_ile06,tc_ile08,tc_ile09,tc_ile10,tc_ile11,tc_ile12,nvl(tc_ild06,1) tc_ild06
             from tc_ile_file
             left join tc_ild_file on tc_ile01 = tc_ild01 and tc_ile02 = tc_ild02
                   and tc_ile08 = tc_ild03 and tc_ild04 = year(?)
                   and tc_ild05 = month(?)
            where tc_ile01 = '",g_date,"' and tc_ile02 = '",g_version,"')
       on (tc_ilg01 = tc_ile01 and tc_ilg02 = tc_ile02 and tc_ilg03 = tc_ile06 )
    when matched then update set
            tc_ilg17 = tc_ile09,
            tc_ilg15 = tc_ile08,
            tc_ilg16 = tc_ild06,
            tc_ilg08 = tc_ile09 * tc_ild06,
            tc_ilg09 = tc_ile10 * tc_ild06,
            tc_ilg10 = tc_ile11 * tc_ild06,
            tc_ilg11 = tc_ile12 * tc_ild06,
            tc_ilg12 = tc_ile03 "
    prepare scimp500_price_p4 from l_sql
    execute scimp500_price_p4 using g_date,g_date
    if sqlca.sqlcode then
        call cl_record('error',sfmt('库存取最新单价，写入失败:%1',sqlca.sqlcode))
        call cl_err('merge tc_ilf_file scimp500_price_p4',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('库存取最新单价，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 出货根据原币匹配单价，匹配不到的时候，到xmf_file 中匹配，并插入到价格表中
    call cl_record('info','出货关联最新单价')
    let l_sql ="
    merge into tc_ilf_file
    using (select tc_ile01,tc_ile02,tc_ile03,tc_ile04,tc_ile05,tc_ile06,tc_ile08,tc_ile09,tc_ile10,tc_ile11,tc_ile12
             from tc_ile_file
            where tc_ile01 = '",g_date,"' and tc_ile02 = '",g_version,"')
       on (tc_ilf01 = tc_ile01 and tc_ilf02 = tc_ile02 and tc_ilf05 = tc_ile06 and tc_ilf03 in ('5','7')
           and tc_ile08 = tc_ilf21 and tc_ile09 = tc_ilf22)
     when matched then update set
            tc_ilf16 = nvl(tc_ilf16 , tc_ile09 * tc_ilf15 ),
            tc_ilf17 = nvl(tc_ilf17 , tc_ile10 * tc_ilf15 ),
            tc_ilf18 = nvl(tc_ilf18 , tc_ile11 * tc_ilf15 ),
            tc_ilf19 = nvl(tc_ilf19 , tc_ile12 * tc_ilf15 ),
            tc_ilf20 = nvl(tc_ilf20 , tc_ile03 )"
    prepare scimp500_price_p5 from l_sql
    execute scimp500_price_p5
    if sqlca.sqlcode then
        call cl_record('error',sfmt('出货关联最新单价，写入失败:%1',sqlca.sqlcode))
        call cl_err('merge tc_ilf_file scimp500_price_p5',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('出货关联最新单价，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 关联历史单价
    -- 填入历史单价
    call cl_record('info','出货填入历史单价')
    select max(tc_ile03) into l_tc_ile03 from tc_ile_file
     where tc_ile01 = g_date and tc_ile02 = g_version

    let l_sql = "
    insert into tc_ile_file (
        tc_ile01,tc_ile02,tc_ile03,tc_ile04,tc_ile05,
        tc_ile06,tc_ile07,tc_ile08,tc_ile09,tc_ile10,
        tc_ile11,tc_ile12)
    select '",g_date,"', '",g_version,"', rownum+",l_tc_ile03,", tc_xme00, tc_xmf01,
            tc_xmf03, tc_xmedate, tc_xme02, tc_xmf05, tc_xmf08,
            tc_xmf10, tc_xmf07 from (
        select tc_xme00,tc_xmf01,tc_xmf03, tc_xmedate, tc_xme02,
            tc_xmf05, tc_xmf08,tc_xmf10, tc_xmf07,
            dense_rank() over (partition by tc_xmf03 order by tc_xmedate desc, tc_xme00 desc, tc_xmf01 desc) as rn
            from tc_xme_file, tc_xmf_file
            where tc_xme00 = tc_xmf00 and tc_xmeconf = 'Y'
            and exists (
                select 1 from tc_ilf_file where tc_ilf01 = '",g_date,
             "' and tc_ilf02 = '",g_version,"' and tc_ilf03 in ('5','7')
                and tc_ilf17 is null and tc_ilf18 is null and tc_ilf19 is null
                and tc_ilf21 = tc_xme02 and tc_ilf22 = tc_xmf05 )) where rn = 1"
    prepare scimp500_price_p6 from l_sql
    execute scimp500_price_p6
    if sqlca.sqlcode then
        call cl_record('error',sfmt('出货填入历史单价，写入失败:%1',sqlca.sqlcode))
        call cl_err('merge tc_ile_file scimp500_price_p6',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('出货填入历史单价，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 再次关联一次单价
    execute scimp500_price_p5
    if sqlca.sqlcode then
        call cl_record('error',sfmt('出货关联历史单价，写入失败:%1',sqlca.sqlcode))
        call cl_err('merge tc_ilf_file scimp500_price_p5',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('出货关联历史单价，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    call cl_record('info','汇总金额')

end function


-- 背景执行部分，自动产生报表、发送邮件等
function scimp500_background()

end function

private function scimp500_getatype(p_char)
    define  p_char          varchar(10)

    case p_char
        when '1'
            return '成品入库'
        when '2'
            return '返工入库'
        when '3'
            return '返工领出'
        when '4'
            return '返工退料'
        when '5'
            return'成品出货'
        when '6'
            return'材料转卖'
        when '7'
            return'成品销退'
        when '8'
            return'材料销退'
        when '9'
            return '折让'
        otherwise
            return ''
    end case
end function

private function scimp500_findaway(p_question)
    define  p_question,l_str  varchar(1000),
            l_curr    boolean

    case p_question
        when 'old_new_found'
            let l_str = '历史单据异动日期改变，单据内容无变化，已忽略该单据，请警告相关部门禁止历史单据重新审核/过账！'
        when 'old_lost'
            let l_str = '历史单据被删除；'
            let l_curr = true
        when 'old_new_diff'
            let l_str =  '历史单据已与当前有差异；'
        when 'old_undo'
            let l_str = '历史单据被取消审核/过账；'
        otherwise
            let l_str = '未知异常'
            let l_curr = true
    end case
    if l_curr then
        let l_str = l_str , '影响本期资料，无法执行下去，请先处理异常单据！'
    else
        let l_str = l_str , '影响历史资料，请评估单据影响金额和范围！本期将继续计算。'
    end if
    return l_str
end function


-- 未签收，每月允许一次，运行重新运行
function simp500_unsign(p_yy,p_mm)
    define  l_sql               string
    define  l_cnt,p_yy,p_mm     integer
    define  l_start,l_end       date

    select count(*) into l_cnt from tc_ilj_file
     where tc_ilj01 = p_yy and tc_ilj02 = p_mm
    if l_cnt > 0 then
        if g_bgjob = 'Y' then
            call cl_record('info','背景执行作业不会重新计算上月未签收')
            return
        end if
        if not cl_confirm('cim-095') then
            return
        end if
    end if

    let l_start = mdy(p_mm, 1, p_yy)
    if p_mm = 12 then
        let l_end = mdy(1, 1, p_yy+1) - 1
    else
        let l_end = mdy(p_mm + 1, 1 , p_yy) - 1
    end if

    delete from tc_ilj_file
     where tc_ilj01 = p_yy and tc_ilj02 = p_mm

    if sqlca.sqlcode then
        call cl_record('error',sfmt('删除上月未签收，失败:%1',sqlca.sqlcode))
        call cl_err('del tc_ilj_file ',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('删除上月未签收，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    call cl_record('info','上月未签收写入')
    let l_sql = "insert into tc_ilj_file
                    (tc_ilj01, tc_ilj02, tc_ilj03, tc_ilj04, tc_ilj05,
                    tc_ilj06, tc_ilj07, tc_ilj08, tc_ilj09, tc_ilj10,
                    tc_ilj11, tc_ilj12, tc_ilj13, tc_ilj19, tc_ilj23)
                select  ",p_yy,",",p_mm,",ogb04,oga01,ogb03,
                        oga02,null,ogb09,ogb091,ogb092,
                        ogb12,oga23,oga24,ogb37*oga24,ogb37
                    from oga_file, ogb_file
                where oga01 = ogb01
                    and oga09 = '2' and ogaconf = 'Y' and ogapost = 'Y'
                    and instr(ogb04, '.') = 0
                    and oga02 between '",l_start,"' and '",l_end,"'
                    and not exists
                (select 1 from (select oga011 oga011_q, ogb03 ogb03_q
                                    from oga_file, ogb_file
                                where oga01 = ogb01 and oga09 = '8'
                                    and ogaconf = 'Y' and ogapost = 'Y'
                                    and oga02 <= '",l_end,"' )
                    where oga011_q = oga01 and ogb03_q = ogb03)"
    prepare scimp500_sign_p1 from l_sql
    execute scimp500_sign_p1
    if sqlca.sqlcode then
        call cl_record('error',sfmt('上月未签收，插入失败:%1',sqlca.sqlcode))
        call cl_err('ins tc_ilj_file scimp500_sign_p1',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('上月未签收写入，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    -- 汇率、单价
    call cl_record('info','上月未签收单价、汇率匹配')

    -- 现在 汇率 tc_ilj18
    let l_sql = "
    merge into tc_ilj_file
    using (select azj01,azj03 from azj_file where azj02 = to_char( ? ,'yyyymm'))
       on (azj01 = tc_ilj12 and tc_ilj01 = ",p_yy," and tc_ilj02 = ",p_mm,")
    when matched then update set tc_ilj18 = azj03"
    prepare scimp500_sign_p2 from l_sql
    let g_end = g_end + 1
    execute scimp500_sign_p2 using g_end
    let g_end = g_end - 1
    if sqlca.sqlcode then
        call cl_record('error',sfmt('更新最新汇率，失败:%1',sqlca.sqlcode))
        call cl_err('upd tc_ilj_file scimp500_sign_p2',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('更新最新汇率，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

    update tc_ilj_file set tc_ilj18 = 1
     where tc_ilj01 = p_yy and tc_ilj02 = p_mm
       and tc_ilj18 is null

    -- 匹配单价
    let l_sql = "
    merge into tc_ilj_file
    using (
        select  tc_xmf03,tc_xmf05,tc_xmf08,tc_xmf10,tc_xmf07,tc_xme02 from (
        select  tc_xmf03,tc_xmf05,tc_xmf08,tc_xmf10,tc_xmf07,tc_xme02,
                dense_rank() over (partition by tc_xmf03 order by tc_xmedate desc, tc_xme00) as rn
        from tc_xme_file,tc_xmf_file
        where tc_xme00 = tc_xmf00 and tc_xmeconf = 'Y'
        and exists (
                select 1 from tc_ilj_file where tc_ilj01 = ",p_yy," and tc_ilj02 = ",p_mm,"
                and tc_ilj03 = tc_xmf03 and tc_ilj12 = tc_xme02 and tc_ilj23 = tc_xmf05 ) ) where rn = 1 )
      on ( tc_ilj01 = ",p_yy," and tc_ilj02 = ",p_mm," and tc_ilj12 = tc_xme02 and tc_ilj23 = tc_xmf05 and tc_ilj03 = tc_xmf03 )
    when matched then update set
                tc_ilj14 = tc_ilj23 * tc_ilj18,
                tc_ilj15 = tc_xmf08 * tc_ilj18,
                tc_ilj16 = tc_xmf10 * tc_ilj18,
                tc_ilj17 = tc_xmf07 * tc_ilj18,
                tc_ilj20 = tc_xmf08 * tc_ilj13,
                tc_ilj21 = tc_xmf10 * tc_ilj13,
                tc_ilj22 = tc_xmf07 * tc_ilj13"
    prepare scimp500_sign_p3 from l_sql
    execute scimp500_sign_p3
    if sqlca.sqlcode then
        call cl_record('error',sfmt('更新新单价，失败:%1',sqlca.sqlcode))
        call cl_err('upd tc_ilj_file scimp500_sign_p3',sqlca.sqlcode,0)
        let g_success = 'N'
    end if
    call cl_record('info',sfmt('更新新单价，%1~%2 笔数：%3',g_start,g_end,sqlca.sqlerrd[3]))

end function
