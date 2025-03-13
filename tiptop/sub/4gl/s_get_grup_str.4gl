# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# SYNTAX.........:CALL s_get_grup_str(p_grup)
# DESCRIPTION....:取得部門群組字串
# PARAMETERS.....:p_grup        部門
# RETURNING......:l_str         "  ('A01','A02','A03')  "
# Date & Author..:05/08/09 FUN-580035 By Sarah

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_get_grup_str(p_grup)
  DEFINE
    p_grup        VARCHAR(06),
    l_str         STRING, 
    l_zyw03       LIKE zyw_file.zyw03

    WHENEVER ERROR CALL cl_err_msg_log

    LET l_str="("
    LET l_zyw03=''
    DECLARE get_zyw03_cs CURSOR FOR
       SELECT zyw03 FROM zyw_file
        WHERE zyw01 IN (SELECT zyw01 FROM zyw_file WHERE zyw03=p_grup)
        GROUP BY zyw03
    FOREACH get_zyw03_cs INTO l_zyw03
       IF NOT cl_null(l_zyw03) THEN
          LET l_str=l_str CLIPPED," '",l_zyw03,"' , "
       END IF
    END FOREACH
    LET l_str=l_str CLIPPED," 'DATANOTFOUND' ) "
    RETURN l_str
END FUNCTION
