# Prog. Version..: '5.25.01-12.12.26(00001)'
#
# Pattern name...: s_log.4gl
# Descriptions...: (cka_file)作業執行日誌記錄
# Date & Author..: 12/09/05 By fengrui NO.FUN-C80092

DATABASE ds

GLOBALS "../../config/top.global"

#cka11-版本號傳入
FUNCTION s_log_cka11(p_cka11,p_ggb03,p_cka02,p_cka03,p_cmd) 
   DEFINE p_cka11 LIKE cka_file.cka11
   DEFINE p_ggb03 LIKE ggb_file.ggb03
   DEFINE p_cka02 LIKE cka_file.cka02
   DEFINE p_cka03 LIKE cka_file.cka03
   DEFINE p_cmd   LIKE type_file.chr1
   DEFINE l_time  LIKE type_file.chr50
   DEFINE l_cka   RECORD LIKE cka_file.*

   IF p_cmd = '1' THEN 
      LET l_time =CURRENT YEAR TO FRACTION(4)
      LET l_time = l_time[3,4],l_time[6,7],l_time[9,10],l_time[12,13],l_time[15,16],l_time[18,19],l_time[21,22]
      LET l_cka.cka00 = l_time
      LET l_cka.cka02 = p_cka02
      LET l_cka.cka03 = p_cka03
      LET l_cka.cka11 = p_cka11
      LET l_cka.cka01 = p_ggb03 
      LET l_cka.cka10 = 'Z'
      INSERT INTO cka_file VALUES (l_cka.*)
   ELSE 
      DELETE FROM cka_file WHERE cka10 = 'Z'
   END IF 
   
END FUNCTION


FUNCTION s_log_ins(p_cka01,p_cka02,p_cka03,p_cka08,p_cka09)
   DEFINE p_cka01   LIKE cka_file.cka01
   DEFINE p_cka02   LIKE cka_file.cka02
   DEFINE p_cka03   LIKE cka_file.cka03
   DEFINE p_cka08   LIKE cka_file.cka08
   DEFINE p_cka09   LIKE cka_file.cka09
   DEFINE l_cka     RECORD LIKE cka_file.*
   DEFINE l_time    LIKE type_file.chr50

   LET l_cka.cka11 = ''  #版本號
   LET l_cka.cka00 = '' 
   LET l_cka.cka01 = p_cka01 
   LET l_cka.cka02 = p_cka02 
   LET l_cka.cka03 = p_cka03 
   LET l_cka.cka04 = g_today   
   LET l_cka.cka05 = TIME  
   LET l_cka.cka06 = ''
   LET l_cka.cka07 = '' 
   LET l_cka.cka08 = p_cka08 
   LET l_cka.cka09 = p_cka09 
   LET l_cka.cka10 = 'N'
   LET l_cka.ckauser = g_user
   LET l_cka.ckaud01 = ''
   LET l_cka.ckaud02 = ''
   LET l_cka.ckaud03 = ''
   LET l_cka.ckaud04 = ''
   LET l_cka.ckaud05 = ''
   LET l_cka.ckaud06 = ''
   LET l_cka.ckaud07 = ''
   LET l_cka.ckaud08 = ''
   LET l_cka.ckaud09 = ''
   LET l_cka.ckaud10 = ''
   LET l_cka.ckaud11 = ''
   LET l_cka.ckaud12 = ''
   LET l_cka.ckaud13 = ''
   LET l_cka.ckaud14 = ''
   LET l_cka.ckaud15 = ''
   
   LET l_time =CURRENT YEAR TO FRACTION(4)
   LET l_time = l_time[3,4],l_time[6,7],l_time[9,10],l_time[12,13],l_time[15,16],l_time[18,19],l_time[21,22]
   LET l_cka.cka00 = l_time
   IF cl_null(l_cka.cka10) THEN LET l_cka.cka10 = 'N' END IF
   IF cl_null(l_cka.cka11) THEN 
      SELECT MAX(cka11) INTO l_cka.cka11 FROM cka_file 
       WHERE cka10='Z' AND cka01=l_cka.cka01
      SELECT cka02,cka03 INTO l_cka.cka02,l_cka.cka03 FROM cka_file
       WHERE cka10='Z' AND cka00 IN (SELECT MAX(cka00) FROM cka_file
                                      WHERE cka01=l_cka.cka01 AND cka11=l_cka.cka11)
      DELETE FROM cka_file WHERE cka10 = 'Z'
   END IF 

   INSERT INTO cka_file VALUES (l_cka.*)
   IF SQLCA.sqlcode THEN RETURN '' END IF 
   RETURN l_cka.cka00
END FUNCTION 

FUNCTION s_log_upd(p_cka00,p_cka10)
   DEFINE p_cka00   LIKE cka_file.cka00
   DEFINE p_cka10   LIKE cka_file.cka10
   DEFINE l_time    LIKE cka_file.cka07

   IF cl_null(p_cka00) THEN 
      RETURN 
   END IF 
   IF cl_null(p_cka10) THEN 
      LET p_cka10 = 'N'
   END IF 
   LET l_time = TIME
   IF NOT cl_null(p_cka00) THEN
      UPDATE cka_file SET cka06 = g_today , cka07 = l_time , 
                          cka10 = p_cka10 
                    WHERE cka00 = p_cka00
      IF SQLCA.sqlcode THEN
         RETURN
      END IF
   END IF 
END FUNCTION 

#FUN-C80092
