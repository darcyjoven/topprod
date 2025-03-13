# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_period.4gl
# Descriptions...: 會計期間季別
# Date & Author..: 92/04/09 By Nora
# Usage..........: CALL s_period(l_season,l_aaa04) RETURNING l_bm,l_em
# Input Parameter: l_season   會計季別
#                  l_aaa04    年度
# Return code....: l_bm       起始期別
#                  l_em       截止期別
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_period(l_season,l_aaa04)
   DEFINE l_azm  RECORD             LIKE azm_file.*,
		  l_season          LIKE type_file.num5,          #No.FUN-680147 SMALLINT  #季別
		  l_aaa04           LIKE aaa_file.aaa04, #年度
		  l_s  ARRAY[13] OF LIKE type_file.num5,          #No.FUN-680147 SMALLINT #季別
		  l_bm,l_em         LIKE type_file.num5,          #No.FUN-680147 SMALLINT #期別
		  l_n               LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   LET l_bm = ''  LET l_em = ''
   SELECT * INTO l_azm.* FROM  azm_file WHERE azm01 = l_aaa04
   IF SQLCA.sqlcode THEN 
      #CALL cl_err('',SQLCA.sqlcode,0)  #FUN-670091
       CALL cl_err3("sel","azm_file",l_aaa04,"",SQLCA.sqlcode,"","",0)  #FUN-670091
   END IF
   #取得當季起始,截止期間
   LET l_s[1] = l_azm.azm013   LET l_s[2] = l_azm.azm023
   LET l_s[3] = l_azm.azm033   LET l_s[4] = l_azm.azm043
   LET l_s[5] = l_azm.azm053   LET l_s[6] = l_azm.azm063
   LET l_s[7] = l_azm.azm073   LET l_s[8] = l_azm.azm083
   LET l_s[9] = l_azm.azm093   LET l_s[10] = l_azm.azm103
   LET l_s[11] = l_azm.azm113  LET l_s[12] = l_azm.azm123
   LET l_s[13] = l_azm.azm133 
   LET l_bm = ''  LET l_em = ''
   FOR l_n = 1 TO 13
	  IF l_s[l_n] = l_season THEN
	     IF l_bm IS NULL THEN
			LET l_bm = l_n  
	     END IF
	  ELSE
		IF l_s[l_n] != l_bm AND l_bm IS NOT NULL THEN
		   LET l_em = l_n - 1
		   EXIT FOR
		END IF
	  END IF
   END FOR
   IF l_em IS NULL THEN
	  IF g_aza.aza02 = '1' THEN 
		 LET l_em = 12
	  ELSE
		 LET l_em = 13
	  END IF
   END IF
   RETURN l_bm,l_em
END FUNCTION
