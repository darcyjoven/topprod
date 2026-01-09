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
    define p_date       date
    define l_num        decimal(15,3)
    define i,j,k,l      integer
    define l_start,l_end date
    define l_sql        string

    -- 准备好临时资料表
    call cs_crt_temp()
    delete from consumable_tmp where part = p_part

    -- 月初和月末日期
    let l_start = mdy(month(g_today),1,year(g_today))
    let l_end = mdy(iif(month(g_today)==12,1,month(g_today)+1),1,iif(month(g_today)==12,year(g_today)+1,year(g_today))) - 1

    let l_sql = 
    "insert into consumable_tmp ",
    "select tlf903, tlf905, tlf06, tlf906, tlf01, tlf902,tlf903,tlf904,ima25, tlf10*tlf60 qty, nvl(ima53/ima44_fac,0) price ",
    " from tlf_file, ima_file where tlf06 between ? and ? ",
    "  and tlf902 = 'XBC' and tlf903 = ? and ima01 = tlf01 and tlf907 = 1 "

    prepare cs_consumable_p1 from l_sql
    execute cs_consumable_p1 using l_start, l_end, p_part
    if sqlca.sqlcode then
        return 0
    end if

    select sum(qty*price) into l_num from consumable_tmp where part = p_part

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

    -- csmi130
    select tc_sma27 into l_temp from tc_sma_file
     where tc_sma01 = 'csmi130' and tc_sma02 = p_part
    if cl_null(l_temp) then let l_temp = 0 end if
    let l_num = l_temp
    
    -- csmi131
    let l_temp = 0
    select sum(nvl(tc_sma27,0)) into l_temp from tc_sma_file
     where tc_sma01 = 'csmi131' and tc_sma02 = p_part
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
