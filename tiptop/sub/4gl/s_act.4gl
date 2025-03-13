# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_act.4gl
# Descriptions...: 取得會計科目 (依會計科目顯示方式) 
# Date & Author..: 92/05/29 By Pin
# Usage..........: CALL s_act(p_item,p_ware,p_loc) RETURNING l_act,l_status
# Input Parameter: p_item 料件編號
#                  p_ware 倉庫號碼
#                  p_loc  儲位號碼
# Return Code....: l_act    會計科目編號                               
#                  l_status 會計科目維護方式
#                     0     使用自行輸入 
#                     1     使用料件主檔會計科目
#                     2     使用倉儲會計科目
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_act(p_item,p_ware,p_loc)
DEFINE
     p_item       LIKE ima_file.ima01,     #No.MOD-490217
     p_ware       LIKE ime_file.ime01,     #No.FUN-680147 VARCHAR(10)
     p_loc        LIKE ime_file.ime02, 	   #No.FUN-680147 VARCHAR(10)
     l_act        LIKE ima_file.ima39,     #No.FUN-680147 VARCHAR(24)
     l_ime08      LIKE ime_file.ime08
 
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
    SELECT ime08,ime09 INTO l_ime08 ,l_act
      FROM ime_file 
     WHERE ime01=p_ware
	   AND ime02=p_loc
           AND imeacti = 'Y'   #FUN-D40103
	IF SQLCA.sqlcode OR l_ime08 NOT MATCHES '[012]'
		THEN LET l_ime08=' ' RETURN ' ',' '
	END IF
	 
	 CASE l_ime08
		  WHEN '0'  LET l_act=' ' RETURN l_act,'0'
		  WHEN '1'  SELECT ima39 INTO l_act
				      FROM ima_file 
					  WHERE ima01=p_item
					  IF SQLCA.sqlcode THEN LET l_act=' ' END IF
					  RETURN l_act,'1'
          WHEN '2'  RETURN l_act,'2'
		  OTHERWISE RETURN ' ',' '
	END CASE
END FUNCTION
