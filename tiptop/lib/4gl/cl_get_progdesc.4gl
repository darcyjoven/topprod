# Prog. Version..: '5.30.06-13.04.02(00002)'     #
#
# Library name...: cl_get_progdesc
# Descriptions...: 取得程式代碼說明(若有客製碼='Y'的優先回傳)
# Input parameter: p_gaz01       程式代碼
#                  p_lang       語言別
# Return code....: l_gaz03      程式代碼說明
# Usage .........: let g_msg = cl_get_progdesc(p_gaz01,p_lang)
# Date & Author..: 05/09/29 By kim (TQC-740155)
# Modify.........: No.FUN-D40008 13/04/02 By janet 增加GR報表名稱先抓gaz06再抓gaz03
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#TQC-740155
FUNCTION cl_get_progdesc(p_gaz01,p_lang)
DEFINE
   p_gaz01     LIKE gaz_file.gaz01,
   p_lang      LIKE gaz_file.gaz02,
   l_gaz03,l_result     LIKE gaz_file.gaz03,
   l_gaz05     LIKE gaz_file.gaz05,
   l_sql       STRING
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET l_gaz03=''
   LET l_result=''
   LET l_sql="SELECT gaz03,gaz05 FROM gaz_file",
                              " WHERE gaz01='",p_gaz01,"'",
                              "   AND gaz02='",p_lang,"'"
   DECLARE get_progname_c CURSOR FROM l_sql
   FOREACH get_progname_c INTO l_gaz03,l_gaz05  #可能會有多筆,所以用Foreach
      CASE 
         WHEN (l_gaz05 MATCHES '[Yy]') AND (NOT cl_null(l_gaz03))
            LET l_result=l_gaz03
            EXIT FOREACH
      END CASE
   END FOREACH
   IF cl_null(l_result) THEN  #沒有客製碼='Y'的情況,而且有設定程式名稱
      LET l_result=l_gaz03
   END IF
   RETURN l_result
END FUNCTION
 
#FUN-D40008 add -(s)
FUNCTION cl_get_reporttitle(p_gaz01,p_lang)
DEFINE    p_gaz01     LIKE gaz_file.gaz01,
          p_lang      LIKE gaz_file.gaz02,
          l_gaz03     LIKE gaz_file.gaz03,
          l_gaz06     LIKE gaz_file.gaz06

      #報表名稱抓法改為先抓gaz06,若gaz06沒值,再抓gaz03
    SELECT gaz03,gaz06 INTO l_gaz03,l_gaz06 FROM gaz_file
     WHERE gaz01=g_prog AND gaz02=g_rlang
    IF cl_null(l_gaz06) THEN
       LET l_gaz06 = l_gaz03 CLIPPED
    END IF
    RETURN l_gaz06
END FUNCTION

#FUN-D40008 add -(e)
