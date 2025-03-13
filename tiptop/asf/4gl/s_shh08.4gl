# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# SYNTAX         : CALL s_shh08(p_code)  RETURNING l_sta
# DESCRIPTION	 : 將品質異常碼轉換為狀況說明
# PARAMETERS	 : p_code  代號(1.check in 2.check out 3.Check in hold 4.Check out hold)
# RETURNING	 : l_sta   狀況說明
# Date & Author..: 98/07/28 By Apple
# Modify.........: No.FUN-650114 06/06/02 By Sarah p_code增加3.Check in hold,4.Check out hold
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_shh08(p_code)
   DEFINE  p_code   LIKE type_file.chr3,        #No.FUN-680121 VARCHAR(03)
           l_sta    LIKE type_file.chr20        #No.FUN-680121 VARCHAR(20)
   LET l_sta = " "
   CASE p_code
        WHEN '1' CALL cl_getmsg('asf-727',g_lang) RETURNING l_sta
        WHEN '2' CALL cl_getmsg('asf-728',g_lang) RETURNING l_sta
       #start FUN-650114 add
        WHEN '3' CALL cl_getmsg('asf-756',g_lang) RETURNING l_sta
        WHEN '4' CALL cl_getmsg('asf-757',g_lang) RETURNING l_sta
       #end FUN-650114 add
        OTHERWISE EXIT CASE 
   END CASE
   RETURN l_sta
END FUNCTION
