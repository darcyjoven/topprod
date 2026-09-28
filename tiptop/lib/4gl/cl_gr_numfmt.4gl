# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Library name...: cl_gr_numfmt
# Date & Author..: 2011/05/01 jacklai
# Descriptions...: 取得數字的字串格式
# Input parameter: p_table_name     資料表名稱
#                  p_column_name    欄位名稱
#                  p_scale          小數位數
# Return code....: STRING           格式字串
# Usage..........: LET l_str = cl_numfmt("apa_file","apa14",l_azi04)
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"

#No.FUN-B40095
FUNCTION cl_gr_numfmt(p_table_name,p_column_name,p_scale)
    DEFINE p_table_name     LIKE type_file.chr20
    DEFINE p_column_name    LIKE type_file.chr20
    DEFINE p_scale          LIKE type_file.num10
    DEFINE l_i              LIKE type_file.num10
    DEFINE l_fmt            base.StringBuffer
    DEFINE l_digit          LIKE type_file.num5
    DEFINE l_prec           LIKE type_file.num10
    DEFINE l_datatype       STRING
    DEFINE l_length         STRING
    DEFINE l_strtok         base.StringTokenizer

    CALL cl_get_column_info("ds",p_table_name,p_column_name)
    RETURNING l_datatype,l_length
    LET l_strtok = base.StringTokenizer.create(l_length,",")
    IF l_strtok.hasMoreTokens() THEN
        LET l_prec = l_strtok.nextToken()
    END IF
    
    IF (l_prec <= 0 OR p_scale < 0 ) AND l_prec >= p_scale THEN
        RETURN NULL
    END IF
    LET l_digit = 3
    LET l_fmt = base.StringBuffer.create()
    FOR l_i = 1 TO l_prec - 1
        CALL l_fmt.append("-")
        IF (l_prec - l_i) MOD l_digit = 0 THEN
            CALL l_fmt.append(",")
        END IF 
    END FOR
    CALL l_fmt.append("&")
    IF p_scale > 0 THEN
        CALL l_fmt.append(".")
    END IF
    FOR l_i = 1 TO p_scale
        CALL l_fmt.append("&")
    END FOR
    RETURN l_fmt.toString()
END FUNCTION
