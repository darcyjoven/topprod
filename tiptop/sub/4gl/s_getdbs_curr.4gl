# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_getdbs_curr.4gl
# Descriptions...: 
# Date & Author..: 06/03/17 By Mandy
# Input Parameter: 
# Return code....: 
#                : 依營運中心代碼(p_azp01)取得資料庫代碼(azp03)
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_getdbs_curr(p_azp01)
   DEFINE    p_azp01   LIKE azp_file.azp01
   DEFINE    l_azp03   LIKE azp_file.azp03
   DEFINE    l_dbs     STRING        #No.FUN-680147  VARCHAR(21)
 
   SELECT azp03 INTO l_azp03 
     FROM azp_file 
    WHERE azp01 = p_azp01
   IF STATUS THEN 
       LET l_dbs = NULL 
   ELSE
       LET l_dbs = NULL 
       LET l_dbs = s_dbstring(l_azp03) CLIPPED
   END IF
   RETURN l_dbs
END FUNCTION
