# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_uid
# Descriptions...: 实现一些，唯一值的写法
# Date & Author..: darcy 2026-08-21

import libuuid

DATABASE ds

GLOBALS "../../config/top.global"


function cl_short_id()
    define l_sql string
    define l_num bigint
    define l_str varchar(40)

    let l_sql = "select
                        EXTRACT(HOUR from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                                        '1970-01-01 00:00:00 UTC')) * 3600000 +
                        EXTRACT(MINUTE from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                                        '1970-01-01 00:00:00 UTC')) * 60000 +
                        round(EXTRACT(second
                                        from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                                            '1970-01-01 00:00:00 UTC')) * 1000) s4
                    from dual"
    prepare oracle_s_id from l_sql
    execute oracle_s_id into l_num

    return cl_2base62(l_num)
end function


function cl_uuid()
    define l_sql string
    define l_num bigint
    define l_str varchar(40)

    let l_sql = "select EXTRACT(day from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                        '1970-01-01 00:00:00 UTC')) *100000000+
           EXTRACT(HOUR from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                        '1970-01-01 00:00:00 UTC')) * 3600000 +
           EXTRACT(MINUTE from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                        '1970-01-01 00:00:00 UTC')) * 60000 +
           round(EXTRACT(second
                         from(SYSTIMESTAMP AT time zone 'UTC' - timestamp
                              '1970-01-01 00:00:00 UTC')) * 1000) s4
      from dual"
    prepare oracle_uuid from l_sql
    execute oracle_uuid into l_num

    return cl_2base62(l_num)
end function

 -- 任意字符串转为base62 base64去掉 '-','_'
function cl_2base62(p_num)
    define p_num bigint
    DEFINE BASE62 STRING
    DEFINE n bigint
    DEFINE result STRING
    DEFINE r INTEGER
    DEFINE ch STRING
    define l_sql string

    let l_sql = "select mod (?,62) from dual"
    prepare cl_2base62 from l_sql

    LET BASE62 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    IF p_num < 0 THEN
        ERROR "Base62 only supports non-negative numbers"
        RETURN ""
    END IF
    IF p_num = 0 THEN
        RETURN "0"
    END IF

    LET n = p_num
    LET result = ""
    WHILE n > 0
        --LET r =  n mod 62
        execute cl_2base62 using n into r
        LET ch = BASE62.substring(r ,r)
        LET result = ch CLIPPED, result
        LET n =  n / 62
    END WHILE
    RETURN result
end function


-- go 产生的 uid
function cl_uuid_go()
    define l_uuid   varchar(50)
    call genuuidc() returning l_uuid
    return l_uuid
end function
