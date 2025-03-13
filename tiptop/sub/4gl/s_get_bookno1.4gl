# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_get_bookno1.4gl
# Descriptions...: 根據會計年度得到財務帳套、管理帳套
# Date & Author..: 07/03/19 By Carrier   No.FUN-730020 
# Usage..........: CALL s_get_bookno1(p_year,p_dbs) RETURNING l_flag,l_bookno1,l_bookno2
# Input Parameter: p_year     會計年度
#                  p_dbs      工廠別
# Return code....: l_flag     成功否
#                    1  YES
#                    0  NO
#                  l_bookno1  財務帳套
#                  l_bookno2  管理帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980020 09/08/31 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/28 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds        #No.FUN-730020
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_get_bookno1(p_year,p_dbs)   #FUN-980020 mark
FUNCTION s_get_bookno1(p_year,p_plant)
   DEFINE  
           p_year     LIKE type_file.num5,   	
           p_dbs      LIKE type_file.chr21,
           p_plant    LIKE type_file.chr10,   #FUN-980020
           l_aza81    LIKE aza_file.aza81,
           l_aza82    LIKE aza_file.aza81,
           l_aza63    LIKE aza_file.aza63,
           l_sql      STRING,
           l_bookno1  LIKE aza_file.aza81,
           l_bookno2  LIKE aza_file.aza82 
 
  WHENEVER ERROR CALL cl_err_msg_log
 
#FUN-A50102--mark--str--
 #FUN-980020--begin
  #IF cl_null(p_plant) THEN
  #   LET p_dbs = NULL
  #ELSE
  #   LET g_plant_new = p_plant
  #   CALL s_getdbs()
  #   LET p_dbs = g_dbs_new
  #END IF
#FUN-980020--end
#FUN-A50102--mark--end--
 
  #LET l_sql = "SELECT aza81,aza82,aza63 FROM ",p_dbs CLIPPED,"aza_file",
  LET l_sql = "SELECT aza81,aza82,aza63 FROM ",cl_get_target_table(p_plant,'aza_file'), #FUN-A50102
              " WHERE aza01 = '0'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE aza_p1 FROM l_sql
  EXECUTE aza_p1 INTO l_aza81,l_aza82,l_aza63
  IF SQLCA.sqlcode THEN
     RETURN '1',NULL,NULL
  END IF
  IF l_aza63 = 'Y' THEN  #使用多套帳
     IF cl_null(l_aza81) OR cl_null(l_aza82) THEN
        RETURN '1',l_aza81,l_aza82
     END IF
  ELSE
     IF cl_null(l_aza81) THEN  #沒有設財務帳套
        RETURN '1',l_aza81,l_aza82 
     END IF
  END IF
 
  LET l_bookno1 = l_aza81
  LET l_bookno2 = l_aza82
  IF l_aza63 = 'N' THEN   #不使用多帳套
     LET l_bookno2 = NULL
  END IF
  IF cl_null(p_year) OR p_year = 0 THEN
     RETURN '0',l_bookno1,l_bookno2
  ELSE
     #LET l_sql = "SELECT tna02 FROM ",p_dbs CLIPPED,"tna_file",
     LET l_sql = "SELECT tna02 FROM ",cl_get_target_table(p_plant,'tna_file'), #FUN-A50102
                 " WHERE tna00='0' AND tna01=",p_year
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE tna_p1 FROM l_sql
     EXECUTE tna_p1 INTO l_bookno1
     IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
        RETURN '1',NULL,NULL
     END IF
     IF cl_null(l_bookno1) THEN LET l_bookno1=l_aza81 END IF
 
     #LET l_sql = "SELECT tna02 FROM ",p_dbs CLIPPED,"tna_file",
     LET l_sql = "SELECT tna02 FROM ",cl_get_target_table(p_plant,'tna_file'), #FUN-A50102
                 " WHERE tna00='1' AND tna01=",p_year
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE tna_p2 FROM l_sql
     EXECUTE tna_p2 INTO l_bookno2
     IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
        RETURN '1',NULL,NULL
     END IF
 
     IF cl_null(l_bookno2) THEN LET l_bookno2=l_aza82 END IF
     RETURN '0',l_bookno1,l_bookno2
  END IF
 
END FUNCTION
