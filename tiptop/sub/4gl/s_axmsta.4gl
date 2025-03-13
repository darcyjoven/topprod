# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_axmsta.4gl
# Descriptions...: 將採購單之狀況碼轉換為狀況說明
# Date & Author..: 90/09/26 By Nora
# Usage..........: CALL s_axmsta(p_file,p_code1,p_code2,p_code3) RETURNING l_sta
# Input PARAMETER: p_file   訂單
#                  p_code1  狀況碼
#                  p_code2  確認碼
#                  p_code3  簽核否
# RETURN Code....: l_sta    狀況說明
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_axmsta(p_file,p_code1,p_code2,p_code3)
   DEFINE  p_file   LIKE zta_file.zta03, 	#No.FUN-680147 VARCHAR(3)
           p_code1  LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           p_code2  LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           p_code3  LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           l_sta    LIKE apr_file.apr02 	#No.FUN-680147 VARCHAR(12)
   LET l_sta = " "
   IF cl_null(p_code1) THEN
      RETURN  l_sta
   END IF
   IF p_file NOT MATCHES 'oe[ap]' THEN
      RETURN l_sta
   END IF
 
   IF p_file='oea' OR p_file = 'oep' THEN 
#....當狀況碼為開立且確認碼='Y'and 簽核碼='Y'-> p_code1='S' -- 送簽中
      IF p_code1='0' AND p_code2='Y' AND p_code3='Y' AND g_aza.aza23='N' THEN 
         LET p_code1='S' END IF 
     CASE p_code1
          WHEN '0' CALL cl_getmsg('mfg3211',g_lang) RETURNING l_sta
          WHEN '1' CALL cl_getmsg('mfg3212',g_lang) RETURNING l_sta
          WHEN '2' CALL cl_getmsg('mfg3213',g_lang) RETURNING l_sta
          WHEN '6' CALL cl_getmsg('mfg3214',g_lang) RETURNING l_sta
          WHEN '7' CALL cl_getmsg('mfg3215',g_lang) RETURNING l_sta
          WHEN '8' CALL cl_getmsg('mfg3216',g_lang) RETURNING l_sta
          WHEN '9' CALL cl_getmsg('mfg3217',g_lang) RETURNING l_sta
          WHEN 'X' CALL cl_getmsg('mfg3218',g_lang) RETURNING l_sta
          WHEN 'S' CALL cl_getmsg('mfg3546',g_lang) RETURNING l_sta
          WHEN 'R' CALL cl_getmsg('mfg3548',g_lang) RETURNING l_sta
          WHEN 'W' CALL cl_getmsg('mfg3556',g_lang) RETURNING l_sta
     END CASE
     RETURN l_sta
   ELSE 
     RETURN l_sta
   END IF
END FUNCTION
