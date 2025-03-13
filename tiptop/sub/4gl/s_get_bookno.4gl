# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_get_bookno.4gl
# Descriptions...: 根據會計年度得到財務帳套、管理帳套
# Date & Author..: 07/03/19 By Carrier  No.FUN-730020 
# Usage..........: CALL s_get_bookno(p_year) RETURNING l_flag,l_bookno1,l_bookno2
# Input Parameter: p_year    會計年度
# Return code....: l_flag    成功否
#                    1	YES
#                    0	NO
#                  l_bookno1 財務帳套
#                  l_bookno2 管理帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #No.FUN-730020
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_get_bookno(p_year)
   DEFINE  
           p_year     LIKE type_file.num5,   	
           l_bookno1  LIKE aza_file.aza81,
           l_bookno2  LIKE aza_file.aza82 
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF g_aza.aza63 = 'Y' THEN  #使用多套帳
     IF cl_null(g_aza.aza81) OR cl_null(g_aza.aza82) THEN
        RETURN '1',g_aza.aza81,g_aza.aza82
     END IF
  ELSE
     IF cl_null(g_aza.aza81) THEN  #沒有設財務帳套
        RETURN '1',g_aza.aza81,g_aza.aza82 
     END IF
  END IF
 
  LET l_bookno1 = g_aza.aza81
  LET l_bookno2 = g_aza.aza82
  IF g_aza.aza63 = 'N' THEN   #不使用多帳套
     LET l_bookno2 = NULL
  END IF
  IF cl_null(p_year) OR p_year = 0 THEN
     RETURN '0',l_bookno1,l_bookno2
  ELSE
     SELECT tna02 INTO l_bookno1 FROM tna_file
      WHERE tna00='0' AND tna01=p_year
     IF cl_null(l_bookno1) THEN LET l_bookno1=g_aza.aza81 END IF
     SELECT tna02 INTO l_bookno2 FROM tna_file
      WHERE tna00='1' AND tna01=p_year
     IF cl_null(l_bookno2) THEN LET l_bookno2=g_aza.aza82 END IF
     RETURN '0',l_bookno1,l_bookno2
  END IF
 
END FUNCTION
