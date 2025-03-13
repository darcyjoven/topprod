# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_season.4gl
# Descriptions...: 會計期間季別檔
# Date & Author..: 92/04/09 By Nora
# Usage..........: CALL s_season(l_aaa04,l_aaa05) RETURNING l_season
# Input Parameter: l_aaa04   會計年度
#                  l_aaa05   會計期間
# Return code....: l_season  季別
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_season(l_aaa04,l_aaa05)
   DEFINE l_azm  RECORD LIKE azm_file.*,
		  l_season LIKE type_file.num5,          #No.FUN-680147 SMALLINT  #季別
		  l_aaa04 LIKE aaa_file.aaa04, #年度
		  l_aaa05 LIKE aaa_file.aaa05  #期間
 
   SELECT * INTO l_azm.* FROM  azm_file WHERE azm01 = l_aaa04
   IF SQLCA.sqlcode THEN 
      #CALL cl_err('',SQLCA.sqlcode,0)                                #FUN-670091
      CALL cl_err3("sel","azm_file",l_aaa04,"",SQLCA.sqlcode,"","",0) #FUN-670091
   END IF
   #取得當年度之當季
   CASE l_aaa05
		WHEN 1   LET l_season = l_azm.azm013
		WHEN 2   LET l_season = l_azm.azm023
		WHEN 3   LET l_season = l_azm.azm033
		WHEN 4   LET l_season = l_azm.azm043
		WHEN 5   LET l_season = l_azm.azm053
		WHEN 6   LET l_season = l_azm.azm063
		WHEN 7   LET l_season = l_azm.azm073
		WHEN 8   LET l_season = l_azm.azm083
		WHEN 9   LET l_season = l_azm.azm093
		WHEN 10  LET l_season = l_azm.azm103
		WHEN 11  LET l_season = l_azm.azm113
		WHEN 12  LET l_season = l_azm.azm123
		WHEN 13  LET l_season = l_azm.azm133
   END CASE
   RETURN l_season
END FUNCTION
