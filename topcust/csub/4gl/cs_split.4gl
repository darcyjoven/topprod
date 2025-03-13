#Prog.Version..:'5.30.06-13.03.12(00000)'#
#
#ProgramName...: cs_split.4gl
#Descriptions...: 料件拆分PNL数量设置

database ds
globals "../../../tiptop/config/top.global"
globals "../../../tiptop/config/darcy.global"


# 获得默认拆分的数量
# 如果失败，则返回默认的1000
function cs_split(p_ima01)
    define p_ima01  like ima_file.ima01
    define l_lot    decimal(10,3)
    define l_ima06  like ima_file.ima06
    define l_imaud06    like ima_file.imaud06
    define l_imaud10    like ima_file.imaud10

    select ima06,imaud06,imaud10 into l_ima06,l_imaud06,l_imaud10 from ima_file
     where ima01 = p_ima01

    case l_ima06
        when 'G01'
            return cs_spilt_G01(p_ima01)
        when 'G02'
            return cs_spilt_G02(p_ima01,l_imaud06,l_imaud10)
        when 'BCP'
            if p_ima01[7,7] matches '[ABC]' then
                return cs_spilt_G01(p_ima01)
            else
                return cs_spilt_G02(p_ima01,l_imaud06,l_imaud10)
            end if 
        otherwise
    end case
    return l_lot
end function

# 组装拆分规则
function cs_spilt_G01(p_ima01)
    define p_ima01  like ima_file.ima01
    define l_lot      decimal(10,3)

    select tc_sma06 into l_lot from tc_sma_file
     where tc_sma01 = 'csmi106' and tc_sma02 = p_ima01

    if cl_null(l_lot) then let l_lot = 100 end if

    return l_lot
end function

# 光板拆分规则
function cs_spilt_G02(p_ima01,p_imaud06,p_imaud10)
    define p_ima01      like ima_file.ima01
    define p_imaud06    like ima_file.imaud06
    define p_imaud10    like ima_file.imaud10
    define l_imaud10    decimal(20,3)
    define l_lot        decimal(10,3)
    define l_tc_sma03   like tc_sma_file.tc_sma03

    define l_tc_sma07   like tc_sma_file.tc_sma07
    define l_tc_sma09   like tc_sma_file.tc_sma09

    #darcy:2024/04/23 add s---
    define l_tc_sma06   like tc_sma_file.tc_sma06 
    define l_sql    string
    #darcy:2024/04/23 add e---

    let l_imaud10 = p_imaud10

    select tc_sma07,tc_sma09 into l_tc_sma07,l_tc_sma09
      from tc_sma_file 
     where tc_sma01 ='csmi102' and tc_sma03 = p_imaud06

    if p_imaud10 > l_tc_sma07 then
        let l_lot = l_tc_sma09
    end if

    #darcy:2024/04/23 s---
    # csmi108 的设置
    let l_sql = "
    select unique tc_sma06 
     from (select tc_sma02, tc_sma06, length(tc_sma02) l
          from tc_sma_file
         where tc_sma01 = 'csmi108'
           and tc_sma20 = 'Y'
					 and ? like tc_sma02||'%'
         order by length(tc_sma02) desc)
     where rownum = 1 "
    
    prepare cs_saplit_g01p from l_sql
    declare cs_saplit_g01c cursor for cs_saplit_g01p

    execute cs_saplit_g01c using p_ima01 into l_tc_sma06
    
    if not cl_null(l_tc_sma06) then
        let l_lot = l_tc_sma06
    end if
    #darcy:2024/04/23 e---

    if cl_null(l_lot) then let l_lot = 100 end if

    return l_lot
end function


# 判断料号是G01还是G02
function cs_get_ima06(p_ima01)
    define p_ima01      like ima_file.ima01
    define l_ima06      like ima_file.ima06

    select ima06 into l_ima06 from ima_file
     where ima01 = p_ima01
    if cl_null(l_ima06) or sqlca.sqlcode then
        return ''
    end if

    if l_ima06 = 'BCP' then
        if p_ima01[7,7] matches '[ABC]'  then
            let l_ima06 ='G01'
        else
            let l_ima06 ='G02'
        end if
    end if

    return l_ima06
end function

