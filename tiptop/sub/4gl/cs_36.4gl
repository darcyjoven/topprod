# Prog. Version..: '5.30.07-13.05.20(00004)'     #
#
# Pattern name...: cs_36.4gl
# Descriptions...: 36进制相关实现
# Date & Author..: darcy:2024/06/19
 

database ds

GLOBALS "../../config/top.global"

# 将10进制转为36进制
function cs_36_encode(p_int)
    define p_int,l_re    integer
    define l_chr    string

    if p_int = 0 then 
        return '0'
    end if

    while p_int > 0
        let l_re = p_int mod 36
        let l_chr = cs_36_encodeDigit(l_re),l_chr
        let p_int = p_int / 36
    end while

    while l_chr.getLength() < 4
        let l_chr = '0',l_chr
    end while

    return l_chr clipped
end function

# 将36进制转为10进制
function cs_36_decode(p_chr)
    define p_chr    string
    define l_int    integer
    define l_chr    varchar(1)
    define l_index  integer

    if cl_null(p_chr) then
        return 0
    end if

    let l_index = 0
    while not cl_null(p_chr)

        let l_chr = p_chr.getCharAt(p_chr.getLength())
        let l_int = l_int + cs_36_decodeDigit(l_chr) *36**l_index

        let p_chr = p_chr.subString(1,p_chr.getLength()-1)
        let l_index = l_index + 1
    end while
    
    return l_int
end function


# 转换小于36的数为36进制
function cs_36_encodeDigit(p_int)
    define p_int integer
    define l_chr varchar(1)
    if p_int < 10 then
        let l_chr = p_int
    else
        let l_chr = ASCII(65+p_int-10)
    end if
    return l_chr
end function


# 转换小于36的数为10进制数
function cs_36_decodeDigit(p_chr)
    define l_int integer
    define p_chr varchar(1)
    if p_chr < 10 then
        let l_int = p_chr
    else
        let l_int = ORD(p_chr)-65+10
    end if
    return l_int
end function
