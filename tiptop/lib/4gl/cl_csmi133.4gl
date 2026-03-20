# Prog. Version..: '5.30.06-13.03.12(00002)'     #
 
# Program name...: cl_csmi133.4gl
# Descriptions...: 获取csmi133参数
# Date & Author..: darcy:2026/02/13
 

DATABASE ds
 
-- 返回true/false
function cl_csmi133(p_prog,p_param)
    define p_prog varchar(40),
           p_param varchar(200)
    define l_ok     varchar(1)

    select tc_sma05 into l_ok from tc_sma_file
     where tc_sma01 = 'csmi133' and tc_sma02 = p_prog
       and tc_sma06 = p_param and rownum = 1

    if sqlca.sqlcode then
        return false
    end if 
    return l_ok == 'Y'
end function

-- 返回说明字段
function cl_csmi133_desc(p_prog,p_param)
    define p_prog       varchar(40),
           p_param      varchar(200)
    define l_desc       varchar(200)

    select tc_sma07 into l_desc from tc_sma_file
     where tc_sma01 = 'csmi133' and tc_sma02 = p_prog
       and tc_sma06 = p_param and rownum = 1

    if sqlca.sqlcode then
        return ''
    end if 
    return l_desc
end function
