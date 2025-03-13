# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_get_sql_limited.4gl
# Descriptions...: 取得限定版本內(amri701所做的設定),跟據限定條件和限定的(倉庫/單別/指送地址)組出SQL
# Date & Author..: 2008/10/03 By Mandy #FUN-8A0011
# Usage..........: CALL s_get_sql_msp03(p_msp01,p_feldname) RETURNING l_sql #倉庫
# Usage..........: CALL s_get_sql_msp04(p_msp01,p_feldname) RETURNING l_sql #單號
# Usage..........: CALL s_get_sql_msp05(p_msp01,p_feldname) RETURNING l_sql #指送地址
# Input Parameter: p_msp01     限定版本編號
# Input Parameter: p_feldname  欄位名稱 ex: 'oeb01'
# Return code....: l_sql       組出限定條件的SQL
# Modify.........: No.TQC-8A0019 倉庫別的設定可以輸入A*或AB*
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.FUN-9B0039 09/11/05 by liuxqa 修改substr

DATABASE ds        
 
GLOBALS "../../config/top.global"   
 
FUNCTION s_get_sql_msp04(p_msp01,p_feldname) #單別 #FUN-8A0011
DEFINE p_msp01         LIKE msp_file.msp01
DEFINE p_feldname      LIKE type_file.chr20
DEFINE l_chr20         LIKE type_file.chr20
DEFINE l_msp           RECORD LIKE msp_file.*
DEFINE l_n             LIKE type_file.num5         
DEFINE l_i             LIKE type_file.num5     
DEFINE g_sw            LIKE type_file.chr1     
DEFINE l_digits        LIKE type_file.chr1     
DEFINE #l_sql           LIKE type_file.chr1000  
       l_sql          STRING      #NO.FUN-910082
 
  LET l_n = 1
  LET l_sql = NULL
  DECLARE sel_msp_cur_msp04 CURSOR FOR
   SELECT * FROM msp_file 
    WHERE msp01 = p_msp01
      AND msp04 IS NOT NULL
  FOREACH sel_msp_cur_msp04 INTO l_msp.*
    IF STATUS THEN CALL cl_err('for msp04:',STATUS,0) EXIT FOREACH END IF
 
      #==>單據
      IF l_n=1 THEN
          CASE g_aza.aza41
               WHEN '1' #單別位數,3碼
                    LET l_digits = '3'
               WHEN '2' #單別位數,4碼
                    LET l_digits = '4'
               WHEN '3' #單別位數,5碼
                    LET l_digits = '5'
              OTHERWISE
                    LET l_digits = '3'
          END CASE
          IF l_msp.msp10 = 0 THEN
              LET l_chr20 = " IN "
          ELSE
              LET l_chr20 = " NOT IN "
          END IF
          #LET l_sql = l_sql CLIPPED,"(SUBSTR(",p_feldname CLIPPED,",1,",l_digits,")",l_chr20,"('",l_msp.msp04 CLIPPED,"'"  #NO.FUN-9B0039
          LET l_sql = l_sql CLIPPED,"(",p_feldname CLIPPED,"[1,",l_digits,"]",l_chr20,"('",l_msp.msp04 CLIPPED,"'"   #NO.FUN-9B0039 mod
      ELSE
          LET l_sql = l_sql CLIPPED,",'",l_msp.msp04 CLIPPED,"'"
      END IF
      LET l_n = l_n + 1
 
  END FOREACH
 
  IF NOT cl_null(l_sql)  THEN 
      LET l_sql  = l_sql  CLIPPED," ))"  
  ELSE
      LET l_sql  = " 1=1 "
  END IF
  RETURN l_sql
 
END FUNCTION
 
FUNCTION s_get_sql_msp03(p_msp01,p_feldname) #倉庫別
DEFINE p_msp01         LIKE msp_file.msp01
DEFINE p_feldname      LIKE type_file.chr20
DEFINE l_chr20         LIKE type_file.chr20
DEFINE l_msp           RECORD LIKE msp_file.*
DEFINE l_n             LIKE type_file.num5         
DEFINE l_i             LIKE type_file.num5     
DEFINE g_sw            LIKE type_file.chr1     
DEFINE l_digits        LIKE type_file.chr1     
DEFINE #l_sql           LIKE type_file.chr1000
       l_sql          STRING      #NO.FUN-910082  
DEFINE l_db_type       LIKE type_file.chr3 #TQC-8A0019
 
  LET l_db_type = cl_DB_GET_DATABASE_TYPE()
  LET l_n = 1
  LET l_sql = NULL
  DECLARE sel_msp_cur_msp03 CURSOR FOR
   SELECT * FROM msp_file 
    WHERE msp01 = p_msp01
      AND msp03 IS NOT NULL
  FOREACH sel_msp_cur_msp03 INTO l_msp.*
    IF STATUS THEN CALL cl_err('for msp03:',STATUS,0) EXIT FOREACH END IF
     #TQC-8A0019---mod---str--
     ##==>倉庫別
     #IF l_n=1 THEN
     #    IF l_msp.msp10 = 0 THEN
     #        LET l_chr20 = " IN "
     #    ELSE
     #        LET l_chr20 = " NOT IN "
     #    END IF
     #    LET l_sql = l_sql CLIPPED,p_feldname CLIPPED,l_chr20,"('",l_msp.msp03 CLIPPED,"'"
     #ELSE
     #    LET l_sql = l_sql CLIPPED,",'",l_msp.msp03 CLIPPED,"'"
     #END IF
      IF l_db_type = 'ORA' THEN
          LET l_msp.msp03 = cl_replace_str(l_msp.msp03,'*','%') #將*換成%
          IF l_n=1 THEN
              IF l_msp.msp10 = 0 THEN 
                  #正向
                  LET l_sql = "( ",p_feldname CLIPPED,"     LIKE    '",l_msp.msp03 CLIPPED,"'"
              ELSE
                  #反向
                  LET l_sql = "( ",p_feldname CLIPPED," NOT LIKE    '",l_msp.msp03 CLIPPED,"'"
              END IF
          ELSE
              IF l_msp.msp10 = 0 THEN 
                  #正向
                  LET l_sql = l_sql CLIPPED," OR  ",p_feldname CLIPPED,"     LIKE    '",l_msp.msp03 CLIPPED,"'"
              ELSE
                  #反向
                  LET l_sql = l_sql CLIPPED," AND ",p_feldname CLIPPED," NOT LIKE    '",l_msp.msp03 CLIPPED,"'"
              END IF
          END IF
      ELSE
          IF l_n=1 THEN
              IF l_msp.msp10 = 0 THEN 
                  #正向
                  LET l_sql = "( ",p_feldname CLIPPED,"     MATCHES '",l_msp.msp03 CLIPPED,"'"
              ELSE
                  #反向
                  LET l_sql = "( ",p_feldname CLIPPED," NOT MATCHES '",l_msp.msp03 CLIPPED,"'"
              END IF
          ELSE
              IF l_msp.msp10 = 0 THEN 
                  #正向
                  LET l_sql = l_sql CLIPPED," OR  ",p_feldname CLIPPED,"     MATCHES '",l_msp.msp03 CLIPPED,"'"
              ELSE
                  #反向
                  LET l_sql = l_sql CLIPPED," AND ",p_feldname CLIPPED," NOT MATCHES '",l_msp.msp03 CLIPPED,"'"
              END IF
          END IF
      END IF
     #TQC-8A0019---mod---str--
      LET l_n = l_n + 1
 
  END FOREACH
 
  IF NOT cl_null(l_sql)  THEN 
      LET l_sql  = l_sql  CLIPPED," )"  
  ELSE
      LET l_sql  = " 1=1 "
  END IF
  RETURN l_sql
 
END FUNCTION
 
FUNCTION s_get_sql_msp05(p_msp01,p_feldname) #指送地址
DEFINE p_msp01         LIKE msp_file.msp01
DEFINE p_feldname      LIKE type_file.chr20
DEFINE l_chr20         LIKE type_file.chr20
DEFINE l_msp           RECORD LIKE msp_file.*
DEFINE l_n             LIKE type_file.num5         
DEFINE l_i             LIKE type_file.num5     
DEFINE g_sw            LIKE type_file.chr1     
DEFINE l_digits        LIKE type_file.chr1     
DEFINE #l_sql           LIKE type_file.chr1000  
       l_sql          STRING      #NO.FUN-910082
 
  LET l_n = 1
  LET l_sql = NULL
  DECLARE sel_msp_cur_msp05 CURSOR FOR
   SELECT * FROM msp_file 
    WHERE msp01 = p_msp01
      AND msp05 IS NOT NULL
  FOREACH sel_msp_cur_msp05 INTO l_msp.*
    IF STATUS THEN CALL cl_err('for msp05:',STATUS,0) EXIT FOREACH END IF
 
      #==>指送地址
      IF l_n=1 THEN
          IF l_msp.msp10 = 0 THEN
              LET l_chr20 = " IN "
          ELSE
              LET l_chr20 = " NOT IN "
          END IF
          LET l_sql = l_sql CLIPPED,p_feldname CLIPPED,l_chr20,"('",l_msp.msp05 CLIPPED,"'"
      ELSE
          LET l_sql = l_sql CLIPPED,",'",l_msp.msp05 CLIPPED,"'"
      END IF
      LET l_n = l_n + 1
 
  END FOREACH
 
  IF NOT cl_null(l_sql)  THEN 
      IF l_msp.msp10 = 0 THEN
          LET l_sql  = l_sql  CLIPPED," )"  
      ELSE
          LET l_sql  = "(",l_sql  CLIPPED," ) OR ",p_feldname CLIPPED," IS NULL OR ",p_feldname CLIPPED, " = ' ') "
      END IF
  ELSE
      LET l_sql  = " 1=1 "
  END IF
  RETURN l_sql
 
END FUNCTION
