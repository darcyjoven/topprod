# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_swyn1.4gl
# Descriptions...: 檢查是否為可用倉
# Date & Author..: 92/05/23 By  Pin
# Usage..........: CALL s_swyn1(p_ware,p_dbs) RETURNING l_flag1,l_flag2
# Input Parameter: p_ware  倉庫號碼
#                  p_dbs   資料庫編號
# Return code....: flag1   不可用倉
#                  flag2   MPS/MRP 不可用
# Modify ........: 92/07/14 By Jones
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980020 09/09/23 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_swyn1(p_ware,p_dbs)   #FUN-980020 mark
FUNCTION s_swyn1(p_ware,p_plant)  #FUN-980020
DEFINE
    p_ware       LIKE imd_file.imd01,           #No.FUN-680147 VARCHAR(10)
    p_dbs        LIKE type_file.chr21,  	#No.FUN-680147 VARCHAR(21)
    l_sql        LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(1000)
    flag1,flag2   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_imd11 LIKE imd_file.imd11,
    l_imd12 LIKE imd_file.imd12
DEFINE  p_plant  LIKE type_file.chr10           #No.FUN-980020
#FUN-A50102--mark--str-- 
#FUN-980020--begin    
    #IF cl_null(p_plant) THEN
    #   LET p_dbs = NULL
    #ELSE
    #   LET g_plant_new = p_plant
    #   CALL s_getdbs()
    #   LET p_dbs = g_dbs_new
   # END IF
#FUN-980020--end 
#FUN-A50102--mark--end--   
 
    LET flag1 = 0
    LET flag2 = 0
   #LET l_sql = "SELECT imd11,imd12 FROM ",p_dbs CLIPPED,".imd_file ",    #TQC-950050 MARK                                          
    #LET l_sql = "SELECT imd11,imd12 FROM ",s_dbstring(p_dbs),"imd_file ", #TQC-950050 ADD
  LET l_sql = "SELECT imd11,imd12 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
        " WHERE imd01 = '",p_ware,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE imd_cur FROM l_sql
    DECLARE imd_curs CURSOR FOR imd_cur     
    OPEN imd_curs
    FETCH imd_curs INTO l_imd11,l_imd12
	IF l_imd11 MATCHES '[Nn]' THEN LET flag1 = 1 END IF
	IF l_imd12 MATCHES '[Nn]' THEN LET flag2 = 2 END IF
    RETURN flag1,flag2
END FUNCTION
