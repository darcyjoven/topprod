# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Program name   : cpmq011.4gl
# Program ver.   : 5.23
# Description    : 采购单价波动情况
# Date & Author  : darcy:2025/05/13 add
import libuuid

database ds
 
globals "../../../tiptop/config/top.global" 

define g_uuid   varchar(40)
 
main
    options                                #改變一些系統預設值
        input no wrap
    defer interrupt                        #擷取中斷鍵, 由程式處理
 
    if (not cl_user()) then
        exit program
    end if
    
    whenever error call cl_err_msg_log
    
    if (not cl_setup("CPM")) then
        exit program
    end if
    
    call  cl_used(g_prog,g_time,1) returning g_time  

    -- begin work
    call cpmq011()
    call cpmq011_sale()
    call cpmq011_exp()
    call cpmq011_out()
    -- commit work
    
    call  cl_used(g_prog,g_time,2) returning g_time
end main

function cpmq011()
    define l_yy,l_mm    integer
    define l_sql,l_col  string
    define l_tmp        varchar(100)

    let l_yy = 2025
    let l_mm = 4

    call genuuidc() returning g_uuid

    -- 1. 取出要查询的料号
    let l_sql = " insert into cpmq011_p (uuid, ima01, pmi03, pmc03, pmc081, ima02, ima021)
                select unique '",g_uuid,"',pmj03, pmi03,pmc03,pmc081,ima02,ima021
                   from pmi_file, pmj_file, pmc_file, ima_file
                  where pmi01 = pmj01 and pmiconf = 'Y' and pmi10 = '1'
                    and pmc01 = pmi03 and ima01 = pmj03
                    and pmj09 between to_date('250401', 'yymmdd') and to_date('250430', 'yymmdd')
                    and (pmj03, pmi03) in
                        (select unique pmj03, pmi03
                           from pmi_file, pmj_file
                          where pmi01 = pmj01
                            and pmiconf = 'Y'
                            and pmi10 = '1'
                            and pmj09 < to_date('250401', 'yymmdd'))"
    prepare cpmq011_ima01_p from l_sql
    execute cpmq011_ima01_p
    if sqlca.sqlcode then
        call cl_err('cpmq011_ima01_p',sqlca.sqlcode,1)
        return
    end if
    -- 2. 算出初始单价
    let l_sql = "insert into cpmq011_pd (uuid, ima01, pmi03, dat, change, price, amt)
                select '",g_uuid,"',a.pmj03,b.pmi03,a.pmj09,0,a.pmj07,0 from  pmj_file a,
                    (select a.pmi03,b.pmj03,max(b.pmj01) keep(dense_rank LAST order by b.pmj09) pmj01 ,max(b.pmj09) pmj09
                       from pmi_file a ,pmj_file b,cpmq011_p c
                      where a.pmi01 = b.pmj01 and a.pmiconf = 'Y'
                        and a.pmi10 = '1' and b.pmj09 < to_date('250401', 'yymmdd')
                        and b.pmj03 = c.ima01 and a.pmi03=c.pmi03
                      group by a.pmi03,b.pmj03)b
                 where a.pmj01= b.pmj01 and a.pmj03 = b.pmj03 and a.pmj09=b.pmj09"
    prepare cpmq011_get_price from l_sql
    execute cpmq011_get_price
    if sqlca.sqlcode then
        call cl_err('cpmq011_get_price',sqlca.sqlcode,1)
        return
    end if
    -- 3. 更新本月波动单价
    let l_sql = "insert into cpmq011_pd (uuid, ima01, pmi03, dat, change, price, amt)
                 select '",g_uuid,"',b.pmj03,a.pmi03,b.pmj09,0,b.pmj07,0
                  from pmi_file a, pmj_file b, cpmq011_p c
                 where a.pmi01 = b.pmj01 and a.pmiconf = 'Y' and a.pmi10 = '1'
                   and b.pmj09 between to_date('250401', 'yymmdd') and to_date('250430', 'yymmdd')
                   and b.pmj03 = c.ima01 and a.pmi03 = c.pmi03"
    prepare cpmq011_ins_prices from l_sql
    execute cpmq011_ins_prices
    if sqlca.sqlcode then
        call cl_err('cpmq011_ins_prices',sqlca.sqlcode,1)
        return
    end if 
    -- 4.价格涨跌值更新
    let l_sql = "merge into cpmq011_pd a
                 using ( select uuid, ima01, pmi03, dat, price, 
                         LAG(price, 1, null) OVER (partition by uuid, ima01, pmi03 order by dat ) lastprice
                           from cpmq011_pd where uuid = '",g_uuid,"' ) b
                on (a.uuid =b.uuid and a.ima01 = b.ima01 and a.dat=b.dat)
                when matched then update set a.change = a.price - b.lastprice"
    prepare cpmq011_upd_change from l_sql
    execute cpmq011_upd_change
    if sqlca.sqlcode then
        call cl_err('cpmq011_upd_change',sqlca.sqlcode,1)
        return
    end if 
    -- 5. 期间采购量
    let l_sql = "merge into cpmq011_pd a using (
                    select uuid,ima01,pmi03,dat,nvl(sum(pmn20),0) pmn20 from (
                        select uuid, ima01, pmi03, dat, 
                               LAG(dat, 1, null) OVER (partition by uuid, ima01, pmi03 order by dat desc) nextdat 
                         from cpmq011_pd where uuid = '",g_uuid,"' ) left join (
                            select pmm09,pmm04,pmn04,pmn20  from pmn_file,pmm_file 
                             where pmn01 = pmm01 and pmm18='Y')
                          on pmm09 = pmi03 and pmn04 = ima01 and pmm04 >= dat and (nextdat is null or pmm04 <= nextdat)
                    group by uuid,ima01,pmi03,dat) b
                on (a.uuid=b.uuid and a.ima01=b.ima01 and a.pmi03=b.pmi03 and a.dat=b.dat)
                when matched then update set a.amt = b.pmn20"
    prepare cpmq011_upd_amt from l_sql
    execute cpmq011_upd_amt
    if sqlca.sqlcode then
        call cl_err('cpmq011_upd_amt',sqlca.sqlcode,1)
        return
    end if 
end function

function cpmq011_sale()
    define l_sql    string
    -- 1. 取期间下订单料号
    let l_sql = "insert into cpmq011_s (uuid, ima01, oea03, occ02, occ18, ima02, ima021)
                 select unique '",g_uuid,"', oeb04, oea03, occ02, occ18, ima02, ima021
                   from oea_file, oeb_file, occ_file, ima_file
                  where oea01 = oeb01 and oeaconf = 'Y'
                    and oea02 between to_date('250401', 'yymmdd') and to_date('250430', 'yymmdd')
                    and oea00 = '1' and occ01 = oea03 and oeb04 = ima01 and oeb13 <> 0
                    and oeb04 not like '%.%' "
    prepare cpmq011_ins_saleitem from l_sql
    execute cpmq011_ins_saleitem
    if sqlca.sqlcode then
        call cl_err('cpmq011_ins_saleitem',sqlca.sqlcode,1)
        return
    end if
    -- 2. 取期初单价
    let l_sql = " insert into cpmq011_sd (uuid, ima01, oea03, dat, change, price, amt)
                select uuid, ima01,oea03, tc_xmedate,0, tc_xmf05,0
                   from cpmq011_s ,
                        (select tc_xme03, tc_xmf03, max(tc_xmedate) tc_xmedate,
                                max(tc_xmf05) keep(dense_rank last order by tc_xmedate) tc_xmf05
                           from tc_xme_file, tc_xmf_file 
                          where tc_xme00 = tc_xmf00 and tc_xmeconf = 'Y' and tc_xmedate < to_date('250401', 'yymmdd')
                          group by tc_xme03, tc_xmf03)
                  where oea03 = tc_xme03 and ima01 = tc_xmf03
                    and uuid = '",g_uuid,"' "
    prepare cpmq011_upd_first from l_sql
    execute cpmq011_upd_first
    if sqlca.sqlcode then
        call cl_err('cpmq011_upd_first',sqlca.sqlcode,1)
        return
    end if
    -- 3. 取期间单价
    let l_sql = "insert into cpmq011_sd (uuid, ima01, oea03, dat, change, price, amt)
                 select uuid, ima01, oea03, tc_xmedate, 0, tc_xmf05, 0
                   from cpmq011_s,tc_xme_file, tc_xmf_file 
                  where tc_xme00 = tc_xmf00 and tc_xmeconf = 'Y'
                    and tc_xmedate between to_date('250401', 'yymmdd') and to_date('250430', 'yymmdd')
                    and oea03 = tc_xme03  and tc_xmf03 = ima01 and uuid = '",g_uuid,"'"
    prepare cpmq011_upd_dur from l_sql
    execute cpmq011_upd_dur
    if sqlca.sqlcode then
        call cl_err('cpmq011_upd_dur',sqlca.sqlcode,1)
        return
    end if
    -- 4. 更新涨跌价金额 
    let l_sql = "merge into cpmq011_sd a
                 using ( select uuid, ima01, oea03, dat, price, 
                         LAG(price, 1, null) OVER (partition by uuid, ima01, oea03 order by dat ) lastprice
                           from cpmq011_sd where uuid = '",g_uuid,"' ) b
                on (a.uuid =b.uuid and a.ima01 = b.ima01 and a.dat=b.dat)
                when matched then update set a.change = a.price - b.lastprice"
    prepare cpmq011_upd_change2 from l_sql
    execute cpmq011_upd_change2
    if sqlca.sqlcode then
        call cl_err('cpmq011_upd_change2',sqlca.sqlcode,1)
        return
    end if 
    -- 5. 更新期间订单数量
    let l_sql = "merge into cpmq011_sd a
                 using (select uuid, ima01, oea03, dat, nvl(sum(oeb12), 0) oeb12
                          from (select uuid, ima01, oea03, dat,
                                    LAG(dat, 1, null) OVER (partition by uuid, ima01, oea03 order by dat desc) nextdat
                                  from cpmq011_sd where uuid = '",g_uuid,"')
                                   left join (select oea03 oea03_1, oea02, oeb04, oeb12 from oea_file, oeb_file
                                 where oea01 = oeb01 and oea00 = '1' and oeaconf = 'Y')
                                    on oea03_1 = oea03 and oeb04 = ima01 and oea02 >= dat
                                  and (nextdat is null or oea02 <= nextdat)
                                group by uuid, ima01, oea03, dat) b
                    on (a.uuid = b.uuid and a.ima01 = b.ima01 and a.oea03 = b.oea03 and a.dat = b.dat)
                  when matched then update set a.amt = b.oeb12"
    prepare cpmq011_upd_amt2 from l_sql
    execute cpmq011_upd_amt2
    if sqlca.sqlcode then
        call cl_err('cpmq011_upd_amt2',sqlca.sqlcode,1)
        return
    end if 

end function

-- 6. 展开bom关联原材料号
function cpmq011_exp()
    define l_sql    string

    let l_sql = "insert into cpmq011_bom (uuid,bmb01,bmb03)
                 select uuid,bmb01, bmb03
                   from (select CONNECT_BY_ROOT(bmb01) bmb01, bmb03
                           from bmb_file where bmb04 <= sysdate
                            and (bmb05 is null or bmb05 > sysdate)
                            and CONNECT_BY_ISLEAF = 1
                          start with bmb01 in (select ima01 from cpmq011_s where uuid = '",g_uuid,"')
                        connect by prior bmb03 = bmb01), cpmq011_p
                 where bmb03 = ima01 and uuid = '",g_uuid,"'"
    prepare cpmq011_exp from l_sql
    execute cpmq011_exp
    if sqlca.sqlcode then
        call cl_err('cpmq011_exp',sqlca.sqlcode,1)
        return
    end if
end function

function cpmq011_out()
    define l_result record
        pur dynamic array of record
            ima01   like ima_file.ima01, 
            pmi03   like pmi_file.pmi03, 
            pmc03   like pmc_file.pmc03, 
            pmc081  like pmc_file.pmc081, 
            ima02   like ima_file.ima02, 
            ima021  like ima_file.ima021,
            pur_detail dynamic array of record
                dat     date, 
                change  decimal(20,6), 
                price   decimal(20,6),  
                amt     decimal(15,3)
            end record
        end record,
        sales dynamic array of record
            ima01   like ima_file.ima01,
            oea03   like oea_file.oea03,
            occ02   like occ_file.occ02,
            occ18   like occ_file.occ18,
            ima02   like ima_file.ima02,
            ima021  like ima_file.ima021,
            sales_detail dynamic array of record
                dat     date, 
                change  decimal(20,6), 
                price   decimal(20,6),  
                amt     decimal(15,3)
            end record
        end record,
        bom dynamic array of record
            bmb01 varchar(20),
            bmb03 varchar(20)
        end record
    end record
    define i,j        integer
    define l_node     om.DomNode
    define l_file     string
    define l_sql      string


    initialize l_result.* to null
    
    -- 采购核价料号
    let l_sql = "select ima01, pmi03, pmc03, pmc081, ima02, ima021 from cpmq011_p ",
                " where uuid = ?  order by ima01, pmi03"
    prepare cpmq011_p_p from l_sql
    declare cpmq011_p_cur cursor for cpmq011_p_p
    -- 采购核价明细
    let l_sql = "select dat, change, price, amt from cpmq011_pd ",
                " where uuid = ? and ima01 = ? and pmi03 = ? ",
                " order by dat"
    prepare cpmq011_pd_p from l_sql
    declare cpmq011_pd_cur cursor for cpmq011_pd_p
    let i = 1
    foreach cpmq011_p_cur using g_uuid
       into l_result.pur[i].ima01, l_result.pur[i].pmi03, l_result.pur[i].pmc03,
            l_result.pur[i].pmc081, l_result.pur[i].ima02, l_result.pur[i].ima021
        if sqlca.sqlcode then
            call cl_err('cpmq011_p_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let j = 1
        foreach cpmq011_pd_cur using g_uuid, l_result.pur[i].ima01, l_result.pur[i].pmi03
           into l_result.pur[i].pur_detail[j].*
           if sqlca.sqlcode then
                call cl_err('cpmq011_pd_cur',sqlca.sqlcode,1)
                exit foreach
            end if
            let j = j + 1
        end foreach
        call l_result.pur[i].pur_detail.deleteElement(j)
        let i = i + 1
    end foreach
    call l_result.pur.deleteElement(i)

    -- 销售核价料号
    let l_sql = "select ima01, oea03, occ02, occ18, ima02, ima021 from cpmq011_s ",
                " where uuid = ?  order by ima01, oea03"
    prepare cpmq011_s_p from l_sql
    declare cpmq011_s_cur cursor for cpmq011_s_p
    -- 销售核价明细
    let l_sql = "select dat, change, price, amt from cpmq011_sd ",
                " where uuid = ? and ima01 = ? and oea03 = ? ",
                " order by dat"
    prepare cpmq011_sd_p from l_sql
    declare cpmq011_sd_cur cursor for cpmq011_sd_p
    let i = 1
    foreach cpmq011_s_cur using g_uuid
       into l_result.sales[i].ima01, l_result.sales[i].oea03, l_result.sales[i].occ02,
            l_result.sales[i].occ18, l_result.sales[i].ima02, l_result.sales[i].ima021
        if sqlca.sqlcode then
            call cl_err('cpmq011_s_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let j = 1
        foreach cpmq011_sd_cur using g_uuid, l_result.sales[i].ima01, l_result.sales[i].oea03
           into l_result.sales[i].sales_detail[j].*
           if sqlca.sqlcode then
                call cl_err('cpmq011_sd_cur',sqlca.sqlcode,1)
                exit foreach
            end if
            let j = j + 1
        end foreach
        call l_result.sales[i].sales_detail.deleteElement(j)
        let i = i + 1
    end foreach
    call l_result.sales.deleteElement(i)
    
    -- bom信息
    let l_sql = "select bmb01, bmb03 from cpmq011_bom ",
                " where uuid = ? order by bmb01,bmb03"
    prepare cpmq011_bom_p from l_sql
    declare cpmq011_bom_cur cursor for cpmq011_bom_p
    let i = 1
    foreach cpmq011_bom_cur using g_uuid into l_result.bom[i].*
        if sqlca.sqlcode then
            call cl_err('cpmq011_bom_cur',sqlca.sqlcode,1)
            exit foreach
        end if
        let i = i + 1
    end foreach 
    call l_result.bom.deleteElement(i)

    let l_file = sfmt('%1/%2.xml',fgl_getenv('TEMPDIR'),g_uuid)
    
    let l_node = base.typeinfo.create(l_result)
    call l_node.writeXml(l_file)

    display l_file

end function
