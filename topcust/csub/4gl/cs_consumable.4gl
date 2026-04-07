# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: cs_consumable.4gl
# Descriptions...: 耗材领用计算
# Date & Author..: darcy:2025/12/23 add

database ds
GLOBALS "../../../tiptop/config/top.global"


-- 判断某个工站当月领用的领用金额
function cs_consumable(p_part,p_date)
    define p_part       like eca_file.eca01
    define l_part       like gem_file.gem01
    define p_date       date
    define l_num        decimal(15,3)
    define i,j,k,l      integer
    define l_start,l_end date
    define l_sql        string

    -- 准备好临时资料表
    call cs_crt_temp()

    select eca03 into l_part from eca_file where eca01 = p_part
    if sqlca.sqlcode or cl_null(l_part) then
        select gem01 into l_part from gem_file where gem01 = p_part
    end if

    delete from consumable_tmp where part = l_part

    -- 月初和月末日期
    let l_start = mdy(month(g_today),1,year(g_today))
    let l_end = mdy(iif(month(g_today)==12,1,month(g_today)+1),1,iif(month(g_today)==12,year(g_today)+1,year(g_today))) - 1

    let l_sql =
    "insert into consumable_tmp ",
    "select tlf19, tlf905, tlf06, tlf906, tlf01, tlf902,tlf903,tlf904,ima25, -tlf10*tlf60*tlf907 qty, nvl(ima53/ima44_fac,0) price ",
    " from tlf_file, ima_file where tlf06 between ? and ? and tlf14 not in ('3013', '3014')",
    "  and tlf01 like 'H.%' and ima01 = tlf01 and tlf13 in ('aimt301','aimt302','aimt311','aimt312') and tlf19 = ? "
    -- "  and tlf902 = 'XBC' and tlf903 = ? and ima01 = tlf01 and tlf907 = 1 "

    prepare cs_consumable_p1 from l_sql
    execute cs_consumable_p1 using l_start, l_end, l_part
    if sqlca.sqlcode then
        return 0
    end if

    # 更新客制成本单价
    -- Step 4.2: 更新客制成本单价
    let l_sql = '
        MERGE INTO consumable_tmp a
        USING custom_cost b
        ON ( a.item = b.ta_ccc01 AND (a.price = 0 OR a.price IS NULL))
        WHEN MATCHED THEN
            UPDATE SET a.price = b.ta_ccc23 '

    execute immediate l_sql

    let l_sql = '
        MERGE INTO consumable_tmp a
        USING std_cost b
        ON ( a.item = b.ccc01 AND (a.price = 0 OR a.price IS NULL))
        WHEN MATCHED THEN
            UPDATE SET a.price = b.ccc23'

    execute immediate l_sql

    select sum(qty*price) into l_num from consumable_tmp where part = l_part

    return l_num
end function

-- 创建临时表
function cs_crt_temp()
    define l_cnt        integer
    whenever error continue

    select 1 into l_cnt from consumable_tmp
    if l_cnt = 1 then
        return
    end if

    drop table consumable_tmp
    create table consumable_tmp(
        part        varchar(20),
        docno       varchar(20),
        dat         date,
        seq         decimal(10),
        item        varchar(20),
        ware        varchar(10),
        storage     varchar(10),
        batch       varchar(24),
        unit        varchar(10),
        qty         decimal(15,3),
        price       decimal(20,6)
    )
end function

-- 获取本月额度（标准和临时额度）
function cs_consumable_enable(p_part,p_date)
    define p_part       like eca_file.eca01
    define p_date       date
    define l_num        decimal(15,3)
    define l_temp       decimal(15,3)
    define l_part       like gem_file.gem01

    select eca03 into l_part from eca_file where eca01 = p_part
    if sqlca.sqlcode or cl_null(l_part) then
        select gem01 into l_part from gem_file where gem01 = p_part
    end if

    -- csmi130
    select sum(tc_sma27) into l_temp from tc_sma_file
     where tc_sma01 = 'csmi130' and tc_sma02 in
     (select eca01 from eca_file where eca03 = l_part)

    if cl_null(l_temp) then let l_temp = 0 end if
    let l_num = l_temp

    -- csmi131
    let l_temp = 0
    select sum(nvl(tc_sma27,0)) into l_temp from tc_sma_file
     where tc_sma01 = 'csmi131' and tc_sma02 in
     (select eca01 from eca_file where eca03 = l_part)
       and tc_sma21 > g_today

    if cl_null(l_temp) then let l_temp = 0 end if
    -- let l_num = l_num + l_temp

    return l_num,l_temp
end function

# 求一个料号，数量的采购金额
function cs_consumable_amt(p_item,p_cnt,p_unit)
    define p_item   varchar(10)
    define p_cnt    decimal(15,3)
    define p_unit   varchar(10)

    define l_ima44  like ima_file.ima44
    define l_ima53  like ima_file.ima53
    define l_amt    decimal(15,3)
    define l_flag   boolean
    define l_fac    like ima_file.ima31_fac


    select ima44,ima53 into l_ima44,l_ima53 from ima_file
     where ima01 = p_item

    if cl_null(l_ima53) or l_ima53 = 0 then
        return 0
    end if

    if l_ima44 = p_unit then
        let l_fac = 1
    else
        call s_umfchk(p_item,p_unit,l_ima44) returning l_flag,l_fac
        if l_flag then
            call cl_err(sfmt('单位转算错误%1/%2，请联系管理员',l_ima44,p_unit),'!',1)
            return 99999999
        end if
    end if

    return l_ima53 * l_fac * p_cnt

end function

-- 包含未作废的单据和杂收的单据
function cs_consumable_all(p_part,p_date,p_docno,p_seq)
    define p_part       like eca_file.eca01
    define l_part       like gem_file.gem01
    define p_docno      varchar(40)
    define p_seq        integer
    define p_date       date
    define l_num        decimal(15,3)
    define i,j,k,l      integer
    define l_start,l_end date
    define l_sql        string

    -- 准备好临时资料表
    call cs_crt_temp()

    select eca03 into l_part from eca_file where eca01 = p_part
    if sqlca.sqlcode or cl_null(l_part) then
        select gem01 into l_part from gem_file where gem01 = p_part
    end if

    delete from consumable_tmp where part = l_part

    -- 月初和月末日期
    let l_start = mdy(month(g_today),1,year(g_today))
    let l_end = mdy(iif(month(g_today)==12,1,month(g_today)+1),1,iif(month(g_today)==12,year(g_today)+1,year(g_today))) - 1

    let l_sql =
    "insert into consumable_tmp ",
    "select ina04,ina01,ina02,inb03,inb04,inb05,inb06,inb07,ima25 inb08, ",
    "      ( case when ina00 in ( '1', '2' ) then 1 else - 1 end ) * inb09 * inb08_fac qty, ",
    "  nvl(ima53 / ima44_fac, 0) price  ",
    "  from ina_file, inb_file, ima_file ",
    " where ina01 = inb01 ",
    "   and inaconf <> 'X' ",
    "   and ina00 in (1, 2, 3, 4) ",
    "   and inb04 = ima01 ",
    "   and inb15 not in ('3013', '3014') ",
    "   and inb04 like 'H.%' ",
    "   and ina02 between ? and ? ",
    "   and ina04 = ? ",
    "   and not (ina01 = ? and inb03 = ? )"

    prepare cs_consumable_p2 from l_sql
    execute cs_consumable_p2 using l_start, l_end, l_part,p_docno,p_seq
    if sqlca.sqlcode then
        return 0
    end if

    # 更新客制成本单价
    -- Step 4.2: 更新客制成本单价
    let l_sql = '
        MERGE INTO consumable_tmp a
        USING custom_cost b
        ON ( a.item = b.ta_ccc01 AND (a.price = 0 OR a.price IS NULL))
        WHEN MATCHED THEN
            UPDATE SET a.price = b.ta_ccc23 '

    execute immediate l_sql

    let l_sql = '
        MERGE INTO consumable_tmp a
        USING std_cost b
        ON ( a.item = b.ccc01 AND (a.price = 0 OR a.price IS NULL))
        WHEN MATCHED THEN
            UPDATE SET a.price = b.ccc23'

    execute immediate l_sql

    select sum(qty*price) into l_num from consumable_tmp where part = l_part

    return l_num
end function
