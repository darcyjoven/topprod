# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: scimq500.4gl
# Descriptions...: 每日进销存产值、达交查询
# Date & Author..: darcy 2026-07-26

database ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/cimq500.global"

define g_date       date
define g_version    varchar(20)
define g_only_today varchar(1)
define g_tc_ila     record like tc_ila_file.*
define g_day        dynamic array of daily
define g_sql        string

function scimq500(p_date,p_version,p_only_today)
    define  p_date          date,
            p_version       varchar(1000),
            p_only_today    varchar(1)

    whenever error continue

    let g_success = 'Y'

    let g_date = p_date
    let g_version = p_version
    let g_only_today = p_only_today

    select * into g_tc_ila.* from tc_ila_file
     where tc_ila01 = g_date and tc_ila02 = g_version
    if sqlca.sqlcode then
        call cl_err('无此笔资料',sqlca.sqlcode,0)
        goto _err
    end if

    if not scimq500_del() then
        goto _err
    end if

    if not scimq500_total() then
        goto _err
    end if

    if not scimq500_day() then
        goto _err
    end if

    if not scimq500_subtotal() then
        goto _err
    end if

    if not scimq500_product() then
        goto _err
    end if

    if not scimq500_rework() then
        goto _err
    end if

    if not scimq500_sale() then
        goto _err
    end if

    return

    label _err:
    let g_success = 'N'
    return
end function

-- 删除临时表中的资料
-- 这些表是会话级别的临时表，断开数据库连接后资料会被清空，所有不同程序不会共享资料
function scimq500_del()
    delete from cimq500_total
    if sqlca.sqlcode then
        call cl_err('delete from cimq500_total',sqlca.sqlcode,0)
        return false
    end if
    delete from cimq500_day
    if sqlca.sqlcode then
        call cl_err('delete from cimq500_day',sqlca.sqlcode,0)
        return false
    end if
    delete from cimq500_subtotal
    if sqlca.sqlcode then
        call cl_err('delete from cimq500_subtotal',sqlca.sqlcode,0)
        return false
    end if
    delete from cimq500_product
    if sqlca.sqlcode then
        call cl_err('delete from cimq500_product',sqlca.sqlcode,0)
        return false
    end if
    delete from cimq500_rework
    if sqlca.sqlcode then
        call cl_err('delete from cimq500_rework',sqlca.sqlcode,0)
        return false
    end if
    delete from cimq500_sale
    if sqlca.sqlcode then
        call cl_err('delete from cimq500_sale',sqlca.sqlcode,0)
        return false
    end if
    return true
end function

-- 总览page
function scimq500_total()
    define  l_total     dynamic array of total
    define  i,j         integer

    let l_total[01].seq01 = 01 let l_total[01].col01 = '入库'          let l_total[01].col02 = null
    let l_total[02].seq01 = 02 let l_total[02].col01 = '    光板'       let l_total[02].col02 = g_tc_ila.tc_ila08
    let l_total[03].seq01 = 03 let l_total[03].col01 = '    组装'       let l_total[03].col02 = g_tc_ila.tc_ila07
    let l_total[04].seq01 = 04 let l_total[04].col01 = '    器件'       let l_total[04].col02 = g_tc_ila.tc_ila09
    let l_total[05].seq01 = 05 let l_total[05].col01 = '成品入库小计'     let l_total[05].col02 = g_tc_ila.tc_ila07+g_tc_ila.tc_ila08+g_tc_ila.tc_ila09
    let l_total[06].seq01 = 06 let l_total[06].col01 = '    光板'       let l_total[06].col02 = g_tc_ila.tc_ila11
    let l_total[07].seq01 = 07 let l_total[07].col01 = '    组装'       let l_total[07].col02 = g_tc_ila.tc_ila10
    let l_total[08].seq01 = 08 let l_total[08].col01 = '    器件'       let l_total[08].col02 = g_tc_ila.tc_ila12
    let l_total[09].seq01 = 09 let l_total[09].col01 = '返工入库小计'     let l_total[09].col02 = g_tc_ila.tc_ila10+g_tc_ila.tc_ila11+g_tc_ila.tc_ila12
    let l_total[10].seq01 = 10 let l_total[10].col01 = '    光板'       let l_total[10].col02 = -g_tc_ila.tc_ila14
    let l_total[11].seq01 = 11 let l_total[11].col01 = '    组装'       let l_total[11].col02 = -g_tc_ila.tc_ila13
    let l_total[12].seq01 = 12 let l_total[12].col01 = '    器件'       let l_total[12].col02 = -g_tc_ila.tc_ila15
    let l_total[13].seq01 = 13 let l_total[13].col01 = '返工领出小计'     let l_total[13].col02 = -(g_tc_ila.tc_ila13+g_tc_ila.tc_ila14+g_tc_ila.tc_ila15)
    let l_total[14].seq01 = 14 let l_total[14].col01 = '入库小计'        let l_total[14].col02 = l_total[05].col02+l_total[09].col02+l_total[13].col02
    let l_total[15].seq01 = 15 let l_total[15].col01 = '入库计划'        let l_total[15].col02 = g_tc_ila.tc_ila25
    let l_total[16].seq01 = 16 let l_total[16].col01 = '超额/缺口'       let l_total[16].col02 = l_total[14].col02 - l_total[15].col02
    let l_total[17].seq01 = 17 let l_total[17].col01 = '（库存）'        let l_total[17].col02 = null
    let l_total[18].seq01 = 18 let l_total[18].col01 = '（成品）'        let l_total[18].col02 = g_tc_ila.tc_ila49
    let l_total[19].seq01 = 19 let l_total[19].col01 = '（样品）'        let l_total[19].col02 = g_tc_ila.tc_ila50
    let l_total[20].seq01 = 20 let l_total[20].col01 = '（呆滞）'        let l_total[20].col02 = g_tc_ila.tc_ila51
    let l_total[21].seq01 = 21 let l_total[21].col01 = '（客退）'        let l_total[21].col02 = g_tc_ila.tc_ila52
    let l_total[22].seq01 = 22 let l_total[22].col01 = '（库存合计）'     let l_total[22].col02 = g_tc_ila.tc_ila49+g_tc_ila.tc_ila50+g_tc_ila.tc_ila51+g_tc_ila.tc_ila52
    let l_total[23].seq01 = 23 let l_total[23].col01 = '    光板'       let l_total[23].col02 = g_tc_ila.tc_ila17
    let l_total[24].seq01 = 24 let l_total[24].col01 = '    组装'       let l_total[24].col02 = g_tc_ila.tc_ila16
    let l_total[25].seq01 = 25 let l_total[25].col01 = '    器件'       let l_total[25].col02 = g_tc_ila.tc_ila18
    let l_total[26].seq01 = 26 let l_total[26].col01 = '本月成品入库合计'  let l_total[26].col02 = g_tc_ila.tc_ila16+g_tc_ila.tc_ila17+g_tc_ila.tc_ila18
    let l_total[27].seq01 = 27 let l_total[27].col01 = '    光板'       let l_total[27].col02 = g_tc_ila.tc_ila20
    let l_total[28].seq01 = 28 let l_total[28].col01 = '    组装'       let l_total[28].col02 = g_tc_ila.tc_ila19
    let l_total[29].seq01 = 29 let l_total[29].col01 = '    器件'       let l_total[29].col02 = g_tc_ila.tc_ila21
    let l_total[30].seq01 = 30 let l_total[30].col01 = '本月返工入库合计' let l_total[30].col02 = g_tc_ila.tc_ila19+g_tc_ila.tc_ila20+g_tc_ila.tc_ila21
    let l_total[31].seq01 = 31 let l_total[31].col01 = '    光板'       let l_total[31].col02 = -g_tc_ila.tc_ila23
    let l_total[32].seq01 = 32 let l_total[32].col01 = '    组装'       let l_total[32].col02 = -g_tc_ila.tc_ila22
    let l_total[33].seq01 = 33 let l_total[33].col01 = '    器件'       let l_total[33].col02 = -g_tc_ila.tc_ila24
    let l_total[34].seq01 = 34 let l_total[34].col01 = '本月返工领出合计'  let l_total[34].col02 = -(g_tc_ila.tc_ila22+g_tc_ila.tc_ila23+g_tc_ila.tc_ila24)
    let l_total[35].seq01 = 35 let l_total[35].col01 = '本月入库合计'     let l_total[35].col02 = l_total[26].col02+l_total[30].col02+l_total[34].col02
    let l_total[36].seq01 = 36 let l_total[36].col01 = '本月入库计划'     let l_total[36].col02 = g_tc_ila.tc_ila26
    let l_total[37].seq01 = 37 let l_total[37].col01 = '超额/缺口'       let l_total[37].col02 = l_total[35].col02-l_total[36].col02

    let l_total[01].col03 = '出库'                let l_total[01].col04 = null
    let l_total[02].col03 = '    光板'            let l_total[02].col04 = g_tc_ila.tc_ila28
    let l_total[03].col03 = '    组装'            let l_total[03].col04 = g_tc_ila.tc_ila27
    let l_total[04].col03 = '    器件'            let l_total[04].col04 = g_tc_ila.tc_ila29
    let l_total[05].col03 = '成品出货小计'          let l_total[05].col04 = g_tc_ila.tc_ila27+g_tc_ila.tc_ila28+g_tc_ila.tc_ila29
    let l_total[06].col03 = '    光板'            let l_total[06].col04 = -g_tc_ila.tc_ila31
    let l_total[07].col03 = '    组装'            let l_total[07].col04 = -g_tc_ila.tc_ila30
    let l_total[08].col03 = '    器件'            let l_total[08].col04 = -g_tc_ila.tc_ila32
    let l_total[09].col03 = '成品销退小计'         let l_total[09].col04 = -(g_tc_ila.tc_ila30+g_tc_ila.tc_ila31+g_tc_ila.tc_ila32)
    let l_total[10].col03 = '折扣小计'             let l_total[10].col04 = -g_tc_ila.tc_ila33
    let l_total[11].col03 = '出货小计'             let l_total[11].col04 = l_total[05].col04+l_total[09].col04+l_total[10].col04
    let l_total[12].col03 = '出货计划'             let l_total[12].col04 = g_tc_ila.tc_ila47
    let l_total[13].col03 = '超额/缺口'            let l_total[13].col04 = l_total[11].col04-l_total[12].col04
    let l_total[14].col03 = '    光板'            let l_total[14].col04 = -g_tc_ila.tc_ila39
    let l_total[15].col03 = '    组装'            let l_total[15].col04 = -g_tc_ila.tc_ila38
    let l_total[16].col03 = '    器件'            let l_total[16].col04 = -g_tc_ila.tc_ila40
    let l_total[17].col03 = '本月成品销退总计'      let l_total[17].col04 = -(g_tc_ila.tc_ila38+g_tc_ila.tc_ila39+g_tc_ila.tc_ila40)
    let l_total[18].col03 = '    光板'            let l_total[18].col04 = g_tc_ila.tc_ila36-g_tc_ila.tc_ila39
    let l_total[19].col03 = '    组装'            let l_total[19].col04 = g_tc_ila.tc_ila35-g_tc_ila.tc_ila38
    let l_total[20].col03 = '    器件'            let l_total[20].col04 = g_tc_ila.tc_ila37-g_tc_ila.tc_ila40
    let l_total[21].col03 = '    折扣'            let l_total[21].col04 = -g_tc_ila.tc_ila41
    let l_total[22].col03 = '本月出货总计'          let l_total[22].col04 = l_total[18].col04+l_total[19].col04+l_total[20].col04+l_total[21].col04
    let l_total[23].col03 = '材料转卖小计'          let l_total[23].col04 = g_tc_ila.tc_ila34
    let l_total[24].col03 = '本月材料转卖总计'       let l_total[24].col04 = g_tc_ila.tc_ila42
    let l_total[25].col03 = '    光板'            let l_total[25].col04 = g_tc_ila.tc_ila44
    let l_total[26].col03 = '    组装'            let l_total[26].col04 = g_tc_ila.tc_ila43
    let l_total[27].col03 = '    器件'            let l_total[27].col04 = g_tc_ila.tc_ila45
    let l_total[28].col03 = '上月未签收总计'         let l_total[28].col04 = g_tc_ila.tc_ila43+g_tc_ila.tc_ila44+g_tc_ila.tc_ila45
    let l_total[29].col03 = '（样品未签收）'         let l_total[29].col04 = g_tc_ila.tc_ila46
    let l_total[30].col03 = '    光板'            let l_total[30].col04 = l_total[18].col04 + g_tc_ila.tc_ila44
    let l_total[31].col03 = '    组装'            let l_total[31].col04 = l_total[19].col04 + g_tc_ila.tc_ila43
    let l_total[32].col03 = '    器件'            let l_total[32].col04 = l_total[20].col04 + g_tc_ila.tc_ila45
    let l_total[33].col03 = '    （材料转卖）其它'   let l_total[33].col04 = g_tc_ila.tc_ila42
    let l_total[34].col03 = '    折扣'            let l_total[34].col04 = -g_tc_ila.tc_ila41
    let l_total[35].col03 = '本月收入合计'           let l_total[35].col04 = l_total[30].col04+l_total[31].col04+l_total[32].col04+l_total[33].col04+l_total[34].col04
    let l_total[36].col03 = '本月收入计划'           let l_total[36].col04 = g_tc_ila.tc_ila48
    let l_total[37].col03 = '超额/缺口'             let l_total[37].col04 = l_total[35].col04 - l_total[36].col04

    for i = 1 to l_total.getLength()
        insert into cimq500_total(seq01,col01,col02,col03,col04)
        values (l_total[i].*)
        if sqlca.sqlcode then
            call cl_err('ins total',sqlca.sqlcode,1)
            return false
        end if
    end for
    return true
end function

-- 日汇总，人均
function scimq500_day()
    define  i,j,l_cnt       integer
    define  l_yy,l_mm       integer
    define  l_product,l_fpc,l_smt,l_all,l_sale  varchar(20)
    define  l_sql,l_pivot        string
    define  l_chr1,l_chr2        varchar(20)

    let l_product = 'product' let l_fpc = 'fpc' let l_smt = 'smt' let l_all = 'all' let l_sale = 'sale'

    let l_yy = year(g_date) let l_mm = month(g_date)

    call g_day.clear()

    # 转置查询   三个参数分别是 sql语句，金额（数字）栏位，日期（天数）栏位
    let l_pivot = 'SELECT *
                   FROM ( %1 )
                   PIVOT (
                     sum(%2)
                     FOR %3 IN (
                        1 AS day_1,  2 AS day_2,  3 AS day_3,  4 AS day_4,  5 AS day_5,
                        6 AS day_6,  7 AS day_7,  8 AS day_8,  9 AS day_9, 10 AS day_10,
                       11 AS day_11,12 AS day_12,13 AS day_13,14 AS day_14,15 AS day_15,
                       16 AS day_16,17 AS day_17,18 AS day_18,19 AS day_19,20 AS day_20,
                       21 AS day_21,22 AS day_22,23 AS day_23,24 AS day_24,25 AS day_25,
                       26 AS day_26,27 AS day_27,28 AS day_28,29 AS day_29,30 AS day_30,
                       31 AS day_31
                     )
                   )'

    -- 每日计划转置
    -- params 年度 期别 销售/入库 光板/组装
    let l_sql = "SELECT EXTRACT(DAY FROM tc_ilb03) AS day_no, tc_ilb06
                    FROM tc_ilb_file
                    where tc_ilb01 = ?
                      and tc_ilb02 = ?
                      and tc_ilb04 = ?
                      and tc_ilb05 = ? "
    let g_sql = sfmt(l_pivot,l_sql,"tc_ilb06","day_no")
    prepare scimq500_day_forecast from g_sql

    let g_sql = "select sum(tc_ilb06) from tc_ilb_file
                  where tc_ilb01 = ? and tc_ilb02 = ?
                    and tc_ilb04 = ? and tc_ilb05 = ?"
    prepare scimq500_day_forecasts from g_sql

    -- 每日入库金额
    -- params : 版本、入库类型、日期、日期、量产否 (R/S)
    let l_sql = "select EXTRACT(DAY FROM tc_ilf01) AS day_no ,tc_ilf13*tc_ilf16 amt
                   from tc_ilf_file
                  where tc_ilf02 = ?
                    and tc_ilf03 = ?
                    and to_char(tc_ilf01,'yymm') = to_char(?,'yymm')
                    and tc_ilf01 < = ?
                    and substr(tc_ilf05,10,1) = ? "
    # and substr(tc_ilf05,7,1) not in ('A','B','C','D')
    -- 光板每日入库金额
    let g_sql = sfmt(l_pivot,l_sql||" and substr(tc_ilf05,7,1) not in ('A','B','C','D')","amt","day_no")
    prepare scimq500_day_fn from g_sql
    -- 组装每日入库金额
    let g_sql = sfmt(l_pivot,l_sql||" and substr(tc_ilf05,7,1) in ('A','B','C','D')","amt","day_no")
    prepare scimq500_day_sn from g_sql

    -- 返工入库,样品入库
    let g_sql = sfmt(l_pivot,l_sql,"amt","day_no")
    prepare scimq500_day_ri_si from g_sql

    -- 返工领出
    -- (tc_ilf03 - 3.5)*2 的意思就是 3为负数，4为正数
    # params: 版本 日期 日期
    let l_sql = "select EXTRACT(DAY FROM tc_ilf01) AS day_no,tc_ilf13*tc_ilf16 * (tc_ilf03 - 3.5) *2  amt
                   from tc_ilf_file
                  where  tc_ilf02 = ?
                    and tc_ilf03 in ('3','4')
                    and to_char(tc_ilf01,'yymm') = to_char(?,'yymm')
                    and tc_ilf01 < = ?
                    and substr(tc_ilf05,10,1) = 'R' "
    let g_sql = sfmt(l_pivot,l_sql,"amt","day_no")
    prepare scimq500_day_ro from g_sql

    -- 月汇总入库金额
    # params ：版本 类型 日期 日期 量产否
    let l_sql = "select sum(tc_ilf13*tc_ilf16) amt
                   from tc_ilf_file
                  where tc_ilf02 = ?
                    and tc_ilf03 = ?
                    and to_char(tc_ilf01,'yymm') = to_char(?,'yymm')
                    and tc_ilf01 < = ?
                    and substr(tc_ilf05,10,1) = ? "
    let g_sql = l_sql," and substr(tc_ilf05,7,1) not in ('A','B','C','D')"
    prepare scimq500_day_fns from g_sql
    let g_sql = l_sql," and substr(tc_ilf05,7,1) in ('A','B','C','D')"
    prepare scimq500_day_sns from g_sql
    -- 不区分光板版本
    prepare scimq500_day_sum from l_sql

    -- 出勤人数
    let l_sql = "select EXTRACT(DAY FROM tc_ilc03) AS day_no,tc_ilc05 from tc_ilc_file
                  where tc_ilc01 = ? and tc_ilc02 = ? "
    let g_sql = sfmt(l_pivot,l_sql,"tc_ilc05","day_no")
    prepare scimq500_attend from g_sql
    -- 出勤人数平均值
    let g_sql = "select avg(tc_ilc05) from tc_ilc_file
                  where tc_ilc01 = ? and tc_ilc02 = ? "
    prepare scimq500_attend_avg from g_sql


    # FPC计划
    let g_day[1].seq02 = 1 let g_day[1].col05 = 'FPC计划'
    let l_chr1 = 'product' let l_chr2 = 'fpc'
    execute scimq500_day_forecast using g_date,g_version,l_chr1,l_chr2
       into g_day[2].col07 thru g_day[2].col37
    #    into                g_day[1].col07,g_day[1].col08,g_day[1].col09,g_day[1].col10,
    #         g_day[1].col11,g_day[1].col12,g_day[1].col13,g_day[1].col14,g_day[1].col15,
    #         g_day[1].col16,g_day[1].col17,g_day[1].col18,g_day[1].col19,g_day[1].col20,
    #         g_day[1].col21,g_day[1].col22,g_day[1].col23,g_day[1].col24,g_day[1].col25,
    #         g_day[1].col26,g_day[1].col27,g_day[1].col28,g_day[1].col29,g_day[1].col30,
    #         g_day[1].col31,g_day[1].col32,g_day[1].col33,g_day[1].col34,g_day[1].col35,
    #         g_day[1].col36,g_day[1].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_forecasts',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_day_forecasts using g_date,g_version,l_chr1,l_chr2
       into g_day[1].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_p2',sqlca.sqlcode,0)
        return false
    end if

    # FPC实际（正常入库）
    let g_day[02].seq02 = 02 let g_day[02].col05 = 'FPC实际（正常入库）'
    let l_chr1 = '1' let l_chr2 = 'R'
    execute scimq500_day_fn using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[2].col07 thru g_day[2].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_fn',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_day_fns using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[2].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_fns',sqlca.sqlcode,0)
        return false
    end if

    # FPC累计差异
    let g_day[03].seq02 = 03 let g_day[03].col05 = 'FPC累计差异'
    if not scimq500_diff(03) then
        return false
    end if

    # SMT计划
    let g_day[04].seq02 = 04 let g_day[04].col05 = 'SMT计划'
    let l_chr1 = 'product' let l_chr2 = 'smt'
    execute scimq500_day_forecast using g_date,g_version,l_chr1,l_chr2
       into g_day[04].col07 thru g_day[04].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_forecast',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_day_forecasts using g_date,g_version,l_chr1,l_chr2
       into g_day[04].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_p2',sqlca.sqlcode,0)
        return false
    end if

    # SMT实际（正常入库）
    let g_day[05].seq02 = 05 let g_day[05].col05 = 'SMT实际（正常入库）'
    let l_chr1 = '1' let l_chr2 = 'R'
    execute scimq500_day_sn using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[05].col07 thru g_day[05].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_sn',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_day_sns using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[05].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_sns',sqlca.sqlcode,0)
        return false
    end if

    # SMT累计差异
    let g_day[06].seq02 = 06 let g_day[06].col05 = 'SMT累计差异'
    if not scimq500_diff(06) then
        return false
    end if

    # FPC+SMT
    let g_day[07].seq02 = 07 let g_day[07].col05 = 'FPC+SMT计划'
    call scimq500_add(07,01,04)
    let g_day[08].seq02 = 08 let g_day[08].col05 = 'FPC+SMT实际（正常入库）'
    call scimq500_add(08,02,05)
    let g_day[09].seq02 = 09 let g_day[09].col05 = 'FPC+SMT累计差异'
    call scimq500_add(09,03,06)

    # 量产返工入库
    let g_day[10].seq02 = 10 let g_day[10].col05 = '量产返工入库'
    let l_chr1 = '2' let l_chr2 = 'R'
    execute scimq500_day_ri_si using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[10].col07 thru g_day[10].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_ri_si',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_day_sum using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[10].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_sum',sqlca.sqlcode,0)
        return false
    end if

    # 量产返工领出
    let g_day[11].seq02 = 11 let g_day[11].col05 = '量产返工领出'
    execute scimq500_day_ro using g_version,g_date,g_date
       into g_day[11].col07 thru g_day[11].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_ro',sqlca.sqlcode,0)
        return false
    end if
    let l_chr1 ='3' let l_chr2 = 'R'
    execute scimq500_day_sum using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[11].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_sum',sqlca.sqlcode,0)
        return false
    end if

    # 样品入库
    let g_day[12].seq02 = 12 let g_day[12].col05 = '样品入库'
    let l_chr1 = '1' let l_chr2 = 'S'
    execute scimq500_day_ri_si using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[12].col07 thru g_day[12].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_day_ri_si',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_day_sum using g_version,l_chr1,g_date,g_date,l_chr2
       into g_day[12].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_day_sum',sqlca.sqlcode,0)
        return false
    end if

    # 累计实际入库
    let g_day[13].seq02 = 13 let g_day[13].col05 = '累计实际入库'
    call scimq500_add(13,8,10)
    call scimq500_add(13,13,11)
    call scimq500_add(13,13,12)

    # 当日出勤总人数（人）
    let g_day[14].seq02 = 14 let g_day[14].col05 = '当日出勤总人数（人）'
    execute scimq500_attend using g_date,g_version
       into g_day[14].col07 thru g_day[14].col37
    if sqlca.sqlcode then
        call cl_err('scimq500_attend',sqlca.sqlcode,0)
        return false
    end if
    execute scimq500_attend_avg using g_date,g_version
       into g_day[14].col06
    if sqlca.sqlcode then
        call cl_err('scimq500_attend_avg',sqlca.sqlcode,0)
        return false
    end if

    # 当日人均产出（万元）
    let g_day[15].seq02 = 15 let g_day[15].col05 = '当日人均产出（万元）'
    let l_cnt = 0
    if not cl_null(g_day[13].col07) and not cl_null(g_day[14].col07) then let g_day[15].col07 = g_day[13].col07 / g_day[14].col07 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col07 end if
    if not cl_null(g_day[13].col08) and not cl_null(g_day[14].col08) then let g_day[15].col08 = g_day[13].col08 / g_day[14].col08 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col08 end if
    if not cl_null(g_day[13].col09) and not cl_null(g_day[14].col09) then let g_day[15].col09 = g_day[13].col09 / g_day[14].col09 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col09 end if
    if not cl_null(g_day[13].col10) and not cl_null(g_day[14].col10) then let g_day[15].col10 = g_day[13].col10 / g_day[14].col10 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col10 end if
    if not cl_null(g_day[13].col11) and not cl_null(g_day[14].col11) then let g_day[15].col11 = g_day[13].col11 / g_day[14].col11 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col11 end if
    if not cl_null(g_day[13].col12) and not cl_null(g_day[14].col12) then let g_day[15].col12 = g_day[13].col12 / g_day[14].col12 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col12 end if
    if not cl_null(g_day[13].col13) and not cl_null(g_day[14].col13) then let g_day[15].col13 = g_day[13].col13 / g_day[14].col13 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col13 end if
    if not cl_null(g_day[13].col14) and not cl_null(g_day[14].col14) then let g_day[15].col14 = g_day[13].col14 / g_day[14].col14 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col14 end if
    if not cl_null(g_day[13].col15) and not cl_null(g_day[14].col15) then let g_day[15].col15 = g_day[13].col15 / g_day[14].col15 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col15 end if
    if not cl_null(g_day[13].col16) and not cl_null(g_day[14].col16) then let g_day[15].col16 = g_day[13].col16 / g_day[14].col16 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col16 end if
    if not cl_null(g_day[13].col17) and not cl_null(g_day[14].col17) then let g_day[15].col17 = g_day[13].col17 / g_day[14].col17 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col17 end if
    if not cl_null(g_day[13].col18) and not cl_null(g_day[14].col18) then let g_day[15].col18 = g_day[13].col18 / g_day[14].col18 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col18 end if
    if not cl_null(g_day[13].col19) and not cl_null(g_day[14].col19) then let g_day[15].col19 = g_day[13].col19 / g_day[14].col19 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col19 end if
    if not cl_null(g_day[13].col20) and not cl_null(g_day[14].col20) then let g_day[15].col20 = g_day[13].col20 / g_day[14].col20 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col20 end if
    if not cl_null(g_day[13].col21) and not cl_null(g_day[14].col21) then let g_day[15].col21 = g_day[13].col21 / g_day[14].col21 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col21 end if
    if not cl_null(g_day[13].col22) and not cl_null(g_day[14].col22) then let g_day[15].col22 = g_day[13].col22 / g_day[14].col22 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col22 end if
    if not cl_null(g_day[13].col23) and not cl_null(g_day[14].col23) then let g_day[15].col23 = g_day[13].col23 / g_day[14].col23 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col23 end if
    if not cl_null(g_day[13].col24) and not cl_null(g_day[14].col24) then let g_day[15].col24 = g_day[13].col24 / g_day[14].col24 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col24 end if
    if not cl_null(g_day[13].col25) and not cl_null(g_day[14].col25) then let g_day[15].col25 = g_day[13].col25 / g_day[14].col25 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col25 end if
    if not cl_null(g_day[13].col26) and not cl_null(g_day[14].col26) then let g_day[15].col26 = g_day[13].col26 / g_day[14].col26 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col26 end if
    if not cl_null(g_day[13].col27) and not cl_null(g_day[14].col27) then let g_day[15].col27 = g_day[13].col27 / g_day[14].col27 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col27 end if
    if not cl_null(g_day[13].col28) and not cl_null(g_day[14].col28) then let g_day[15].col28 = g_day[13].col28 / g_day[14].col28 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col28 end if
    if not cl_null(g_day[13].col29) and not cl_null(g_day[14].col29) then let g_day[15].col29 = g_day[13].col29 / g_day[14].col29 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col29 end if
    if not cl_null(g_day[13].col30) and not cl_null(g_day[14].col30) then let g_day[15].col30 = g_day[13].col30 / g_day[14].col30 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col30 end if
    if not cl_null(g_day[13].col31) and not cl_null(g_day[14].col31) then let g_day[15].col31 = g_day[13].col31 / g_day[14].col31 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col31 end if
    if not cl_null(g_day[13].col32) and not cl_null(g_day[14].col32) then let g_day[15].col32 = g_day[13].col32 / g_day[14].col32 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col32 end if
    if not cl_null(g_day[13].col33) and not cl_null(g_day[14].col33) then let g_day[15].col33 = g_day[13].col33 / g_day[14].col33 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col33 end if
    if not cl_null(g_day[13].col34) and not cl_null(g_day[14].col34) then let g_day[15].col34 = g_day[13].col34 / g_day[14].col34 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col34 end if
    if not cl_null(g_day[13].col35) and not cl_null(g_day[14].col35) then let g_day[15].col35 = g_day[13].col35 / g_day[14].col35 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col35 end if
    if not cl_null(g_day[13].col36) and not cl_null(g_day[14].col36) then let g_day[15].col36 = g_day[13].col36 / g_day[14].col36 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col36 end if
    if not cl_null(g_day[13].col37) and not cl_null(g_day[14].col37) then let g_day[15].col37 = g_day[13].col37 / g_day[14].col37 let l_cnt = l_cnt + 1 let g_day[15].col06 = g_day[15].col06 + g_day[15].col37 end if
    if not cl_null(g_day[15].col06) and l_cnt > 0 then let g_day[15].col06 = g_day[15].col06 / l_cnt end if

    for i = 1 to g_day.getLength()
        insert into cimq500_day(
            seq02,col05,col06,col07,col08,
            col09,col10,col11,col12,col13,
            col14,col15,col16,col17,col18,
            col19,col20,col21,col22,col23,
            col24,col25,col26,col27,col28,
            col29,col30,col31,col32,col33,
            col34,col35,col36,col37 )
        values (g_day[i].*)
        if sqlca.sqlcode then
            call cl_err('ins cimq500_day',sqlca.sqlcode,0)
            return false
        end if
    end for
    return true
end function

# 处理累计差异逻辑
function scimq500_diff(p_ac)
    define  p_ac        integer

    if p_ac < 3 then
        call cl_err('参数传入错误','!',0)
        return false
    end if

    let g_day[p_ac].col07 = g_day[p_ac-1].col07 - g_day[p_ac-2].col07
    let g_day[p_ac].col08 = g_day[p_ac].col07 + g_day[p_ac-1].col08 - g_day[p_ac-2].col08
    let g_day[p_ac].col09 = g_day[p_ac].col08 + g_day[p_ac-1].col09 - g_day[p_ac-2].col09
    let g_day[p_ac].col10 = g_day[p_ac].col09 + g_day[p_ac-1].col10 - g_day[p_ac-2].col10
    let g_day[p_ac].col11 = g_day[p_ac].col10 + g_day[p_ac-1].col11 - g_day[p_ac-2].col11
    let g_day[p_ac].col12 = g_day[p_ac].col11 + g_day[p_ac-1].col12 - g_day[p_ac-2].col12
    let g_day[p_ac].col13 = g_day[p_ac].col12 + g_day[p_ac-1].col13 - g_day[p_ac-2].col13
    let g_day[p_ac].col14 = g_day[p_ac].col13 + g_day[p_ac-1].col14 - g_day[p_ac-2].col14
    let g_day[p_ac].col15 = g_day[p_ac].col14 + g_day[p_ac-1].col15 - g_day[p_ac-2].col15
    let g_day[p_ac].col16 = g_day[p_ac].col15 + g_day[p_ac-1].col16 - g_day[p_ac-2].col16
    let g_day[p_ac].col17 = g_day[p_ac].col16 + g_day[p_ac-1].col17 - g_day[p_ac-2].col17
    let g_day[p_ac].col18 = g_day[p_ac].col17 + g_day[p_ac-1].col18 - g_day[p_ac-2].col18
    let g_day[p_ac].col19 = g_day[p_ac].col18 + g_day[p_ac-1].col19 - g_day[p_ac-2].col19
    let g_day[p_ac].col20 = g_day[p_ac].col19 + g_day[p_ac-1].col20 - g_day[p_ac-2].col20
    let g_day[p_ac].col21 = g_day[p_ac].col20 + g_day[p_ac-1].col21 - g_day[p_ac-2].col21
    let g_day[p_ac].col22 = g_day[p_ac].col21 + g_day[p_ac-1].col22 - g_day[p_ac-2].col22
    let g_day[p_ac].col23 = g_day[p_ac].col22 + g_day[p_ac-1].col23 - g_day[p_ac-2].col23
    let g_day[p_ac].col24 = g_day[p_ac].col23 + g_day[p_ac-1].col24 - g_day[p_ac-2].col24
    let g_day[p_ac].col25 = g_day[p_ac].col24 + g_day[p_ac-1].col25 - g_day[p_ac-2].col25
    let g_day[p_ac].col26 = g_day[p_ac].col25 + g_day[p_ac-1].col26 - g_day[p_ac-2].col26
    let g_day[p_ac].col27 = g_day[p_ac].col26 + g_day[p_ac-1].col27 - g_day[p_ac-2].col27
    let g_day[p_ac].col28 = g_day[p_ac].col27 + g_day[p_ac-1].col28 - g_day[p_ac-2].col28
    let g_day[p_ac].col29 = g_day[p_ac].col28 + g_day[p_ac-1].col29 - g_day[p_ac-2].col29
    let g_day[p_ac].col30 = g_day[p_ac].col29 + g_day[p_ac-1].col30 - g_day[p_ac-2].col30
    let g_day[p_ac].col31 = g_day[p_ac].col30 + g_day[p_ac-1].col31 - g_day[p_ac-2].col31
    let g_day[p_ac].col32 = g_day[p_ac].col31 + g_day[p_ac-1].col32 - g_day[p_ac-2].col32
    let g_day[p_ac].col33 = g_day[p_ac].col32 + g_day[p_ac-1].col33 - g_day[p_ac-2].col33
    let g_day[p_ac].col34 = g_day[p_ac].col33 + g_day[p_ac-1].col34 - g_day[p_ac-2].col34
    let g_day[p_ac].col35 = g_day[p_ac].col34 + g_day[p_ac-1].col35 - g_day[p_ac-2].col35
    let g_day[p_ac].col36 = g_day[p_ac].col35 + g_day[p_ac-1].col36 - g_day[p_ac-2].col36
    let g_day[p_ac].col37 = g_day[p_ac].col36 + g_day[p_ac-1].col37 - g_day[p_ac-2].col37

    case day(g_date)
        when 1  let g_day[p_ac].col06 = g_day[p_ac].col07
        when 2  let g_day[p_ac].col06 = g_day[p_ac].col08
        when 3  let g_day[p_ac].col06 = g_day[p_ac].col09
        when 4  let g_day[p_ac].col06 = g_day[p_ac].col10
        when 5  let g_day[p_ac].col06 = g_day[p_ac].col11
        when 6  let g_day[p_ac].col06 = g_day[p_ac].col12
        when 7  let g_day[p_ac].col06 = g_day[p_ac].col13
        when 8  let g_day[p_ac].col06 = g_day[p_ac].col14
        when 9  let g_day[p_ac].col06 = g_day[p_ac].col15
        when 10 let g_day[p_ac].col06 = g_day[p_ac].col16
        when 11 let g_day[p_ac].col06 = g_day[p_ac].col17
        when 12 let g_day[p_ac].col06 = g_day[p_ac].col18
        when 13 let g_day[p_ac].col06 = g_day[p_ac].col19
        when 14 let g_day[p_ac].col06 = g_day[p_ac].col20
        when 15 let g_day[p_ac].col06 = g_day[p_ac].col21
        when 16 let g_day[p_ac].col06 = g_day[p_ac].col22
        when 17 let g_day[p_ac].col06 = g_day[p_ac].col23
        when 18 let g_day[p_ac].col06 = g_day[p_ac].col24
        when 19 let g_day[p_ac].col06 = g_day[p_ac].col25
        when 20 let g_day[p_ac].col06 = g_day[p_ac].col26
        when 21 let g_day[p_ac].col06 = g_day[p_ac].col27
        when 22 let g_day[p_ac].col06 = g_day[p_ac].col28
        when 23 let g_day[p_ac].col06 = g_day[p_ac].col29
        when 24 let g_day[p_ac].col06 = g_day[p_ac].col30
        when 25 let g_day[p_ac].col06 = g_day[p_ac].col31
        when 26 let g_day[p_ac].col06 = g_day[p_ac].col32
        when 27 let g_day[p_ac].col06 = g_day[p_ac].col33
        when 28 let g_day[p_ac].col06 = g_day[p_ac].col34
        when 29 let g_day[p_ac].col06 = g_day[p_ac].col35
        when 30 let g_day[p_ac].col06 = g_day[p_ac].col36
        when 31 let g_day[p_ac].col06 = g_day[p_ac].col37
    end case
    return true
end function

function scimq500_add(p_ac,p_target1,p_target2)
    define  p_ac,p_target1,p_target2        integer

    let g_day[p_ac].col06 = g_day[p_target1].col06 + g_day[p_target2].col06
    let g_day[p_ac].col07 = g_day[p_target1].col07 + g_day[p_target2].col07
    let g_day[p_ac].col08 = g_day[p_target1].col08 + g_day[p_target2].col08
    let g_day[p_ac].col09 = g_day[p_target1].col09 + g_day[p_target2].col09
    let g_day[p_ac].col10 = g_day[p_target1].col10 + g_day[p_target2].col10
    let g_day[p_ac].col11 = g_day[p_target1].col11 + g_day[p_target2].col11
    let g_day[p_ac].col12 = g_day[p_target1].col12 + g_day[p_target2].col12
    let g_day[p_ac].col13 = g_day[p_target1].col13 + g_day[p_target2].col13
    let g_day[p_ac].col14 = g_day[p_target1].col14 + g_day[p_target2].col14
    let g_day[p_ac].col15 = g_day[p_target1].col15 + g_day[p_target2].col15
    let g_day[p_ac].col16 = g_day[p_target1].col16 + g_day[p_target2].col16
    let g_day[p_ac].col17 = g_day[p_target1].col17 + g_day[p_target2].col17
    let g_day[p_ac].col18 = g_day[p_target1].col18 + g_day[p_target2].col18
    let g_day[p_ac].col19 = g_day[p_target1].col19 + g_day[p_target2].col19
    let g_day[p_ac].col20 = g_day[p_target1].col20 + g_day[p_target2].col20
    let g_day[p_ac].col21 = g_day[p_target1].col21 + g_day[p_target2].col21
    let g_day[p_ac].col22 = g_day[p_target1].col22 + g_day[p_target2].col22
    let g_day[p_ac].col23 = g_day[p_target1].col23 + g_day[p_target2].col23
    let g_day[p_ac].col24 = g_day[p_target1].col24 + g_day[p_target2].col24
    let g_day[p_ac].col25 = g_day[p_target1].col25 + g_day[p_target2].col25
    let g_day[p_ac].col26 = g_day[p_target1].col26 + g_day[p_target2].col26
    let g_day[p_ac].col27 = g_day[p_target1].col27 + g_day[p_target2].col27
    let g_day[p_ac].col28 = g_day[p_target1].col28 + g_day[p_target2].col28
    let g_day[p_ac].col29 = g_day[p_target1].col29 + g_day[p_target2].col29
    let g_day[p_ac].col30 = g_day[p_target1].col30 + g_day[p_target2].col30
    let g_day[p_ac].col31 = g_day[p_target1].col31 + g_day[p_target2].col31
    let g_day[p_ac].col32 = g_day[p_target1].col32 + g_day[p_target2].col32
    let g_day[p_ac].col33 = g_day[p_target1].col33 + g_day[p_target2].col33
    let g_day[p_ac].col34 = g_day[p_target1].col34 + g_day[p_target2].col34
    let g_day[p_ac].col35 = g_day[p_target1].col35 + g_day[p_target2].col35
    let g_day[p_ac].col36 = g_day[p_target1].col36 + g_day[p_target2].col36
    let g_day[p_ac].col37 = g_day[p_target1].col37 + g_day[p_target2].col37
end function

# 分类汇总
function scimq500_subtotal()
    define  i           integer

    let g_sql = "insert into cimq500_subtotal (
                    seq03,dat01,
                    col39,col38,col40,col41,
                    col43,col42,col44,col45,
                    col47,col46,col48,col49,
                    col51,col50,col52,col53,
                    col55,col54,col56,col57,
                    col59,col58,col60,col61,
                    col62,col63,
                    col65,col64,col66,col67,col68,
                    col69,col70,col71,col72,
                    col73 )",
                "select rownum,tc_ila01,
                        tc_ila07, tc_ila08, tc_ila09, tc_ila07 + tc_ila08 + tc_ila09 pi,
                        tc_ila10, tc_ila11, tc_ila12, tc_ila10 + tc_ila11 + tc_ila12 pri,
                        -tc_ila13, -tc_ila14, -tc_ila15, -tc_ila13 - tc_ila14 - tc_ila15 pro,
                        tc_ila07 + tc_ila10 + tc_ila13 pis, tc_ila08 + tc_ila11 + tc_ila14 pif, tc_ila09 + tc_ila12 + tc_ila15 pic,
                        tc_ila07 + tc_ila10 - tc_ila13 + tc_ila08 + tc_ila11 - tc_ila14 + tc_ila09 + tc_ila12 - tc_ila15 pia,
                        tc_ila27, tc_ila28, tc_ila29, tc_ila27 + tc_ila28 + tc_ila29 so,
                        -tc_ila30, -tc_ila31, -tc_ila32, -tc_ila30 - tc_ila31 - tc_ila32 sr,
                        tc_ila34, -tc_ila33,
                        tc_ila27 - tc_ila30 sf, tc_ila28 - tc_ila31 ssmt, tc_ila29 - tc_ila32 sc,
                        tc_ila27 - tc_ila30 + tc_ila28 - tc_ila31 + tc_ila29 - tc_ila32 + tc_ila34 - tc_ila33 sall,
                        tc_ila49, tc_ila50, tc_ila51, tc_ila52, tc_ila49 + tc_ila50 + tc_ila51 + tc_ila52 as stockall,
                        tc_ila25
                 from tc_ila_file
                where to_char(tc_ila01,'yymm') = to_char(?,'yymm')
                  and tc_ila02 = ? and tc_ila01 <= ?
                order by tc_ila01 "
    prepare scimq500_subtotal_p from g_sql
    execute scimq500_subtotal_p using g_date,g_version,g_date
    if sqlca.sqlcode then
        call cl_err('scimq500_subtotal_p',sqlca.sqlcode,0)
        return false
    end if

    select max(seq03) into i from cimq500_subtotal
    if cl_null(i) then
        let i = 1
    else
        let i = i + 1
    end if

    insert into cimq500_subtotal (
                    seq03,dat01,
                    col38,col39,col40,col41,
                    col42,col43,col44,col45,
                    col46,col47,col48,col49,
                    col50,col51,col52,col53,
                    col54,col55,col56,col57,
                    col58,col59,col60,col61,
                    col62,col63,
                    col64,
                    col65,col66,col67,col68,
                    col69,col70,col71,col72,
                    col73 )
    select i,null,
            sum(col38),sum(col39),sum(col40),sum(col41),
            sum(col42),sum(col43),sum(col44),sum(col45),
            sum(col46),sum(col47),sum(col48),sum(col49),
            sum(col50),sum(col51),sum(col52),sum(col53),
            sum(col54),sum(col55),sum(col56),sum(col57),
            sum(col58),sum(col59),sum(col60),sum(col61),
            sum(col62),sum(col63),
            sum(col64),
            sum(col65),sum(col66),sum(col67),sum(col68),
            sum(col69),sum(col70),sum(col71),sum(col72),
            sum(col73)
        from cimq500_subtotal
    if sqlca.sqlcode then
        call cl_err('ins cimq500_subtotal',sqlca.sqlcode,0)
        return false
    end if
    return true
end function

# 成品入库明细
function scimq500_product()

    let g_sql = "insert into cimq500_product(
                        dat02,dat03,typ01,item01,ima02,
                        ima021,doc01,doc02,seq04,loc01,
                        bin01,lot01,qty01,doc03,seq05,
                        cey01,price01,smt01,fpc01,comp01,
                        rate01,price02,smt02,fpc02,comp02,
                        amt01 )",
                    "select tc_ilf01,tc_ilf06,tc_ilf03,tc_ilf05,ima02,
                            ima021,tc_ilf09,tc_ilf07,tc_ilf08,tc_ilf10,
                            tc_ilf11,tc_ilf12,tc_ilf13,tc_ile04,tc_ile05,
                            tc_ile08,tc_ile09,tc_ile10,tc_ile11,tc_ile12,
                            tc_ilf15,tc_ilf16,tc_ilf17,tc_ilf18,tc_ilf19,
                            tc_ilf16 * tc_ilf13
                from tc_ilf_file
                left join ima_file on ima01 = tc_ilf05
                left join tc_ile_file on tc_ile01 = tc_ilf01 and tc_ile02 = tc_ilf02
                    and tc_ilf20 = tc_ile03
                where tc_ilf02 = ?
                  and tc_ilf03 in (1, 2, 3, 4)
                  and to_char(tc_ilf01,'yymm') = to_char(?,'yymm')
                  and tc_ilf01 <= ? "
    if g_only_today then
        let g_sql = g_sql," and tc_ilf01 = '",g_date,"' "
    end if
    prepare scimq500_product_p from g_sql
    execute scimq500_product_p using g_version,g_date,g_date
    if sqlca.sqlcode then
        call cl_err('ins scimq500_product_p',sqlca.sqlcode,0)
        return false
    end if
    return true

end function
function scimq500_rework()

    let g_sql = "
    insert into cimq500_rework(
         seq06,dat04,item02,ima0201,ima02102,
         loc02, qty02, price03, amt02, reason)
       select rownum, tc_ilf01, tc_ilf05, ima02, ima021,
          '', tc_ilf13 * (tc_ilf03-3.5)*2, tc_ilf16, tc_ilf13 * tc_ilf16 * (tc_ilf03-3.5)*2, ''
     from tc_ilf_file
     left join ima_file on ima01 = tc_ilf05
    where tc_ilf02 = ?
      and tc_ilf03 in (1, 2, 3, 4)
      and to_char(tc_ilf01,'yymm') = to_char(?,'yymm')
      and tc_ilf01 <= ? "
    if g_only_today then
        let g_sql = g_sql," and tc_ilf01 = '",g_date,"' "
    end if
    prepare scimp500_rework_p from g_sql
    execute scimp500_rework_p using g_version,g_date,g_date
    if sqlca.sqlcode then
        call cl_err('ins scimp500_rework_p',sqlca.sqlcode,0)
        return false
    end if
    return true

end function
# 出货
function scimq500_sale()

    let g_sql = "insert into cimq500_sale(
                    dat05,dat06,typ02,item03,ima0202,
                    ima02102,doc04,seq07,loc03,bin03,
                    lot03,qty03,doc05,seq08,cey02,
                    price04,smt03,fpc03,comp03,rate02,
                    price05,smt04,fpc04,comp04,amt03 )",
                "select tc_ilf01,tc_ilf06,tc_ilf03,tc_ilf05,ima02,
                        ima021,tc_ilf07,tc_ilf08,tc_ilf10,tc_ilf11,
                        tc_ilf12,tc_ilf13,tc_ile04,tc_ile05,tc_ile08,
                        tc_ile09,tc_ile10,tc_ile11,tc_ile12,tc_ilf15,
                        tc_ilf16,tc_ilf17,tc_ilf18,tc_ilf19,tc_ilf16 * tc_ilf13
                from tc_ilf_file
                left join ima_file on ima01 = tc_ilf05
                left join tc_ile_file on tc_ile01 = tc_ilf01 and tc_ile02 = tc_ilf02
                    and tc_ilf20 = tc_ile03
                where tc_ilf02 = ?
                  and tc_ilf03 in (5,6,7,8,9)
                  and to_char(tc_ilf01,'yymm') = to_char(?,'yymm')
                  and tc_ilf01 <= ? "
    if g_only_today then
        let g_sql = g_sql," and tc_ilf01 = '",g_date,"' "
    end if
    prepare scimq500_sale_p from g_sql
    execute scimq500_sale_p using g_version,g_date,g_date
    if sqlca.sqlcode then
        call cl_err('ins scimq500_sale_p',sqlca.sqlcode,0)
        return false
    end if
    return true
end function


-- 打印部分
function scimq500_output(p_date,p_version)
    define l_id     varchar(10)
    define l_cnt    integer
    define  p_date   date,
            p_version varchar(20)
    define l_tc_ila  record like tc_ila_file.*
    define l_pro     report
    define l_file,l_cmd,l_json,l_sql   string
    define l_chn    base.Channel 

    select * into l_tc_ila.* from tc_ila_file
    where tc_ila01 = p_date and tc_ila02 = p_version
    if sqlca.sqlcode then
        call cl_err(sfmt('无此资料,%1-%2',p_date,p_version),"!",0)
        return false
    end if 

    initialize l_pro.* to null
    

    let l_pro.date = p_date using 'DD-MMM-YYYY'
    let l_pro.time = current year to second
    # 剩余天数
    if month(p_date) = 12 then
        let l_pro.remaining = mdy(1,1,year(p_date)+1)-p_date
    else
        let l_pro.remaining = mdy(month(p_date)+1,1,year(p_date))-p_date
    end if
    # 汇率
    let l_pro.curr_rate = l_tc_ila.tc_ila05
    let l_pro.previous_rate = l_tc_ila.tc_ila06
    # 上月
    let l_pro.last_month = (mdy(month(p_date),1,year(p_date)) -1 ) using 'MMM'
    # 入库
    let l_pro.product.normal.day.smt = l_tc_ila.tc_ila07 / 10000
    let l_pro.product.normal.day.fpc = l_tc_ila.tc_ila08 / 10000
    let l_pro.product.normal.day.comp = l_tc_ila.tc_ila09 / 10000

    let l_pro.product.rework_in.day.smt = l_tc_ila.tc_ila10 / 10000
    let l_pro.product.rework_in.day.fpc = l_tc_ila.tc_ila11 / 10000
    let l_pro.product.rework_in.day.comp = l_tc_ila.tc_ila12 / 10000

    let l_pro.product.rework_out.day.smt = l_tc_ila.tc_ila13 / 10000
    let l_pro.product.rework_out.day.fpc = l_tc_ila.tc_ila14 / 10000
    let l_pro.product.rework_out.day.comp = l_tc_ila.tc_ila15 / 10000

    let l_pro.product.normal.month.smt = l_tc_ila.tc_ila16 / 10000
    let l_pro.product.normal.month.fpc = l_tc_ila.tc_ila17 / 10000
    let l_pro.product.normal.month.comp = l_tc_ila.tc_ila18 / 10000

    let l_pro.product.rework_in.month.smt = l_tc_ila.tc_ila19 / 10000
    let l_pro.product.rework_in.month.fpc = l_tc_ila.tc_ila20 / 10000
    let l_pro.product.rework_in.month.comp = l_tc_ila.tc_ila21 / 10000

    let l_pro.product.rework_out.month.smt = l_tc_ila.tc_ila22 / 10000
    let l_pro.product.rework_out.month.fpc = l_tc_ila.tc_ila23 / 10000
    let l_pro.product.rework_out.month.comp = l_tc_ila.tc_ila24 / 10000

    # 计划金额
    let l_pro.forecast.sale.day = l_tc_ila.tc_ila25 / 10000
    let l_pro.forecast.sale.month   = l_tc_ila.tc_ila26 / 10000
    let l_pro.forecast.product.day  = l_tc_ila.tc_ila47 / 10000
    let l_pro.forecast.product.month    = l_tc_ila.tc_ila48 / 10000

    # 出货
    let l_pro.sale.normal.day.smt = l_tc_ila.tc_ila27 / 10000
    let l_pro.sale.normal.day.fpc = l_tc_ila.tc_ila28 / 10000
    let l_pro.sale.normal.day.comp = l_tc_ila.tc_ila29 / 10000

    let l_pro.sale.return.day.smt = l_tc_ila.tc_ila30 / 10000
    let l_pro.sale.return.day.fpc = l_tc_ila.tc_ila31 / 10000
    let l_pro.sale.return.day.comp = l_tc_ila.tc_ila32 / 10000

    let l_pro.sale.normal.month.smt = l_tc_ila.tc_ila35 / 10000
    let l_pro.sale.normal.month.fpc = l_tc_ila.tc_ila36 / 10000
    let l_pro.sale.normal.month.comp = l_tc_ila.tc_ila37 / 10000
    
    let l_pro.sale.return.month.smt = l_tc_ila.tc_ila38 / 10000
    let l_pro.sale.return.month.fpc = l_tc_ila.tc_ila39 / 10000
    let l_pro.sale.return.month.comp = l_tc_ila.tc_ila40 / 10000

    let l_pro.sale.discount.day = l_tc_ila.tc_ila33 / 10000
    let l_pro.sale.discount.month = l_tc_ila.tc_ila41 / 10000

    let l_pro.sale.resell.day = l_tc_ila.tc_ila34 / 10000
    let l_pro.sale.resell.month = l_tc_ila.tc_ila42 / 10000

    let l_pro.sale.unsign.smt = l_tc_ila.tc_ila43 / 10000
    let l_pro.sale.unsign.fpc = l_tc_ila.tc_ila44 / 10000
    let l_pro.sale.unsign.comp = l_tc_ila.tc_ila45 / 10000
    let l_pro.sale.unsign.sample = l_tc_ila.tc_ila46 / 10000

    let l_pro.stock.normal = l_tc_ila.tc_ila49 / 10000
    let l_pro.stock.sample = l_tc_ila.tc_ila50 / 10000
    let l_pro.stock.inaction = l_tc_ila.tc_ila51 / 10000
    let l_pro.stock.return = l_tc_ila.tc_ila52 / 10000

    call cl_json(base.typeinfo.create(l_pro)) returning l_json

    let l_id = cl_short_id()
    let l_file = "/u1/usr/tiptop/typst/projects/cimr500/data.",l_id,".json"

    run "rm "||l_file

    let l_chn = base.Channel.create()
    call l_chn.openFile(l_file,"a")
    CALL l_chn.writeLine(l_json)
    call l_chn.close()

    let l_file = "/u1/usr/tiptop/typst"
    
    let l_cmd = "%1/typst compile ",
                "--root %1 ",
                "--font-path %1/fonts ",
                "--font-path %1/core/fonts ",
                "%1/projects/cimr500/main.typ ",
                "/u1/out/cimr500.%2.pdf ",
                "--input data=\"data.%2.json\""
    let l_cmd = sfmt(l_cmd,l_file,l_id)
    run l_cmd

    call cl_download_by_explorer(sfmt("/u1/out/cimr500.%1.pdf",l_id))
    return true
end function
