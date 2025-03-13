# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name ..: s_coa03                  
# DESCRIPTION....: 根據傳進的廠內料號,查找商品編號     
# Parmeter.......: p_ima01 廠內料號(coa01)
#                  p_cna01 海關編號(coa05)                       
# Date & Autor...: 04/11/26 By Carrier
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
FUNCTION s_coa03(p_ima01,p_cna01)
   DEFINE p_ima01  LIKE ima_file.ima01
   DEFINE p_cna01  LIKE cna_file.cna01
   DEFINE l_coa03  LIKE coa_file.coa03 
   DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
   DEFINE l_wc     LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   DROP TABLE tmp_cna; 
#No.FUN-680069-begin 
   CREATE TEMP TABLE tmp_cna (
               cna01  LIKE cna_file.cna01,
               lvl    LIKE type_file.num5);
#No.FUN-680069-end
   IF cl_null(p_cna01) THEN 
      LET l_wc=" 1=1" 
   ELSE 
      LET l_wc=" cna01='",p_cna01,"'" 
   END IF
 
   LET l_sql="INSERT INTO tmp_cna SELECT cna01,99 FROM cna_file",
             " WHERE ",l_wc
   PREPARE precount_x  FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('create tmp_cna',SQLCA.sqlcode,0)
      RETURN ''
   END IF
   EXECUTE precount_x
   IF SQLCA.sqlcode THEN
      CALL cl_err('create tmp_cna',SQLCA.sqlcode,0)
      RETURN ''
   END IF
   IF cl_null(p_cna01) THEN 
      LET l_wc=" cna01='",g_coz.coz02,"'" 
   ELSE 
      LET l_wc=" cna01='",p_cna01,"'" 
   END IF
   LET l_sql="UPDATE tmp_cna SET lvl=0 WHERE ",l_wc
   PREPARE precount_y  FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('update tmp_cna',SQLCA.sqlcode,0)
   END IF
   EXECUTE precount_y
   IF SQLCA.sqlcode THEN
      CALL cl_err('update tmp_cna',SQLCA.sqlcode,0)
   END IF
 
   LET l_sql = " SELECT coa03 ", #合同基本資料檔
               "   FROM coa_file,tmp_cna",
               "  WHERE coa01 = '",p_ima01,"'",
               "    AND coa05 = cna01",
               "  ORDER BY lvl,cna01,coa03 "
 
   PREPARE tmp_precoe   FROM l_sql
   DECLARE tmp_coe_cur  CURSOR FOR tmp_precoe
 
   FOREACH tmp_coe_cur INTO l_coa03
     IF SQLCA.sqlcode THEN
        CALL cl_err('tmp_coe_cur',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
     IF NOT cl_null(l_coa03) THEN RETURN l_coa03 END IF
   END FOREACH
   RETURN ''
END FUNCTION
