# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_lwyn1.4gl
# Descriptions...: 檢查儲位是否為可用
# Date & Author..: 92/05/23 By  Pin
# Usage..........: CALL s_lwyn1(p_ware,p_loc,p_dbs) RETURNING l_flag1,l_flag2
# Input Parameter: p_ware    倉庫號碼
#                  p_loc     儲位號碼
#                  p_dbs     資料庫編號
# Return code....: l_flag1   不可用倉
#                  l_flag2   MPS/MRP 不可用
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980020 09/09/23 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_lwyn1(p_ware,p_loc,p_dbs)           #FUN-980020 mark
FUNCTION s_lwyn1(p_ware,p_loc,p_plant)          #FUN-980020
DEFINE
    p_ware       LIKE ime_file.ime01,           #No.FUN-680147 VARCHAR(10)
    p_loc        LIKE ime_file.ime02,           #No.FUN-680147 VARCHAR(10)
    p_dbs        LIKE type_file.chr21,          #No.FUN-680147 VARCHAR(21)
    l_sql        LIKE type_file.chr1000,        #No.FUN-680147 VARCHAR(1000)
    flag1,flag2  LIKE type_file.num5,           #No.FUN-680147 SMALLINT
	l_ime05      LIKE ime_file.ime05,
	l_ime06      LIKE ime_file.ime06
DEFINE  p_plant      LIKE type_file.chr10       #FUN-980020
 
#FUN-A50102--mark--str--
 #FUN-980020--begin    
    #IF cl_null(p_plant) THEN
     #  LET p_dbs = NULL
    #ELSE
     #  LET g_plant_new = p_plant
    #   CALL s_getdbs()
    #   LET p_dbs = g_dbs_new
    #END IF
#FUN-980020--end 
#FUN-A50102--mark--str--   
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
 
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
   #LET l_sql=" SELECT ime05,ime06 FROM ",p_dbs CLIPPED,".ime_file",     #TQC-950050 MARK                                           
    #LET l_sql=" SELECT ime05,ime06 FROM ",s_dbstring(p_dbs),"ime_file",  #TQC-950050 ADD
   LET l_sql=" SELECT ime05,ime06 FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102 
              " WHERE ime01 = '",p_ware,"'",
			  " AND ime02 = '",p_loc,"'",
                           " AND imeacti = 'Y' "   #FUN-D40103
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ime_cur FROM l_sql
    DECLARE ime_cur1 CURSOR FOR ime_cur      
    OPEN ime_cur1
    FETCH ime_cur1 INTO l_ime05,l_ime06 
	 IF l_ime05 MATCHES '[Nn]' THEN LET flag1=1 END IF
	 IF l_ime06 MATCHES '[Nn]' THEN LET flag2=2 END IF
  #FUN-D40103 -----Begin-----
    IF cl_null(l_ime05) THEN LET flag1=1 END IF
    IF cl_null(l_ime06) THEN LET flag2=2 END IF
  #FUN-D40103 -----End---
	 RETURN flag1,flag2
END FUNCTION
