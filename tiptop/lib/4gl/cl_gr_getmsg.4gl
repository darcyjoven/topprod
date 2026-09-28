# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Library name...: cl_gr_getmsg
# Descriptions...: 從ze_file中取出對應的欄位內容
# Input parameter: p_code   錯誤訊息代號
#                  p_lang   語言別
#                  p_key    對應欄位鍵值
# Return code....: l_val    對應欄位內容  STRING
# Usage .........: LET l_val = cl_gr_getmsg(l_ze01,l_key)
# Date & Author..: 11/05/05 By jacklai
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"

#No.FUN-B40095
FUNCTION cl_gr_getmsg(p_code,p_lang,p_key)
    DEFINE p_code       LIKE ze_file.ze01   #錯誤訊息代號
    DEFINE p_lang       LIKE ze_file.ze02   #語言別
    DEFINE p_key        STRING              #對應欄位鍵值
    DEFINE l_msg        STRING              #錯誤訊息內容
    DEFINE l_key        STRING              #對應欄位鍵值(trim)
    DEFINE l_val        STRING              #對應欄位內容
    DEFINE l_strtok     base.StringTokenizer
    DEFINE l_pos        LIKE type_file.num5
    DEFINE l_tmp        STRING
    DEFINE l_tmpkey     STRING
    DEFINE l_tmpval     STRING

    LET l_msg = cl_getmsg(p_code,p_lang)
    IF NOT cl_null(p_key) AND NOT cl_null(l_msg) THEN
        LET l_key = p_key.trim()
        LET l_msg = l_msg.trim()
        LET l_strtok = base.StringTokenizer.create(l_msg,"|")
        WHILE l_strtok.hasMoreTokens()
            LET l_tmp = l_strtok.nextToken()
            LET l_pos = l_tmp.getIndexOf(":",1)
            IF l_pos >= 1 THEN
                LET l_tmpkey = l_tmp.subString(1,l_pos-1)
                LET l_tmpkey = l_tmpkey.trim()
                LET l_tmpval = l_tmp.subString(l_pos+1,l_tmp.getLength())
                LET l_tmpval = l_tmpval.trim()
                IF l_key = l_tmpkey THEN
                    LET l_val = l_tmpval
                    EXIT WHILE
                END IF
            END IF 
        END WHILE
    END IF
    RETURN l_val
END FUNCTION
