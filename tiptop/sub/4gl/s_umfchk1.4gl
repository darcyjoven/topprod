# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_umfchk1.4gl
# Descriptions...: 兩單位間之轉換率計算與檢查
# Date & Author..: 90/09/26 By  Wu
# Usage..........: CALL s_umfchk1(p_item,p_1,p_2,p_dbs) RETURNING l_flag,l_fac
# Input Parameter: p_item  料件	 
#                  p_1     來源單位
#                  p_2     目的單位
#                  p_dbs   資料庫編號
# Return code....: l_flag  是否有此單位轉換
#                    0  OK	
#                    1  FAIL
#                  l_fac   轉換率
# Modify.........: 92/11/20 By Jones 新增加 p_dbs 這個參數,並將所有對資料庫的動作都改成透過 prepare 的方式
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-960041 09/09/10 By Dido 資料庫語法轉換
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
#FUNCTION s_umfchk1(p_item,p_1,p_2,p_dbs)    #No.FUN-980059
FUNCTION s_umfchk1(p_item,p_1,p_2,p_plant)   #No.FUN-980059
    DEFINE  p_item     LIKE smd_file.smd01, #No.MOD-490217 
           p_1        LIKE smd_file.smd02, 	#No.FUN-680147 VARCHAR(04)
           p_2        LIKE smd_file.smd03,      #No.FUN-680147 VARCHAR(04)
           p_dbs      LIKE type_file.chr21,  	#No.FUN-680147 VARCHAR(21)
           p_plant    LIKE type_file.chr21,  	#No.FUN-980059 VARCHAR(21)
           l_sql      LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(1000)
           l_flag     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           l_factor   LIKE ima_file.ima31_fac, 	#No.FUN-680147 DECIMAL(16,8)
           l_su       LIKE ima_file.ima31_fac,  #來源單位兌換數量 	#No.FUN-680147 DECIMAL(16,8)
           l_tu       LIKE ima_file.ima31_fac   #目的單位兌換數量 	#No.FUN-680147 DECIMAL(16,8)
 
     #FUN-A50102--mark--str--
     ##NO.FUN-980059 GP5.2 add begin
     #IF cl_null(p_plant) THEN
     #  LET p_dbs = NULL
     #ELSE
     #  LET g_plant_new = p_plant
     #  CALL s_getdbs()
     #  LET p_dbs = g_dbs_new
     #END IF
     ##NO.FUN-980059 GP5.2 add end
     #FUN-A50102--mark--end--
     IF p_1=p_2 THEN
         RETURN 0,1.0
     END IF
     LET l_flag  = 0
     #LET p_dbs = s_dbstring(p_dbs CLIPPED)	#CHI-960041 #FUN-A50102
#-->jeans modify 1992/10/20
     IF p_item IS NOT NULL AND  p_item !=' ' THEN
        #LET l_sql=" SELECT smd04,smd06 FROM ",p_dbs CLIPPED,"smd_file",
        LET l_sql=" SELECT smd04,smd06 FROM ",cl_get_target_table(p_plant,'smd_file'), #FUN-A50102
                  " WHERE smd01 ='", p_item,"'",
                  " AND  smd02 ='", p_1,"'"," AND smd03 ='",p_2,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE smd_c1 FROM l_sql
        DECLARE smd_cur1 CURSOR FOR smd_c1      
        OPEN smd_cur1
        FETCH smd_cur1 INTO l_su,l_tu       #check 料件單位換算
        IF SQLCA.sqlcode  THEN 
           #LET l_sql=" SELECT smd04,smd06 FROM ",p_dbs CLIPPED,"smd_file",
           LET l_sql=" SELECT smd04,smd06 FROM ",cl_get_target_table(p_plant,'smd_file'), #FUN-A50102
                     " WHERE smd01 ='", p_item,"'",
                     " AND  smd02 ='", p_2,"'"," AND smd03 ='",p_1,"'"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE smd_c2 FROM l_sql
           DECLARE smd_cur2 CURSOR FOR smd_c2        
           OPEN smd_cur2
           FETCH smd_cur2 INTO l_tu,l_su       #check 料件單位換算
           IF SQLCA.sqlcode  THEN 
              #LET l_sql=" SELECT smc03,smc04 FROM ",p_dbs CLIPPED,"smc_file",
              LET l_sql=" SELECT smc03,smc04 FROM ",cl_get_target_table(p_plant,'smc_file'), #FUN-A50102
                        "  WHERE smc01 ='",p_1,"'"," AND  smc02 ='",p_2,"'",
                        "    AND smcacti='Y'"      #NO:4757
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
              PREPARE smc_c1 FROM l_sql
              DECLARE smc_cur1 CURSOR FOR smc_c1      
              OPEN smc_cur1
              FETCH smc_cur1 INTO l_su,l_tu
                 IF SQLCA.sqlcode THEN LET l_flag =  1 END IF
           END IF
         END IF
       ELSE 
          #LET l_sql=" SELECT smc03,smc04 FROM ",p_dbs CLIPPED,"smc_file",
          LET l_sql=" SELECT smc03,smc04 FROM ",cl_get_target_table(p_plant,'smc_file'), #FUN-A50102
                    " WHERE smc01 ='",p_1,"'"," AND  smc02 ='", p_2,"'",
                    "    AND smcacti='Y'"      #NO:4757
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
          PREPARE smc_c2 FROM l_sql
          DECLARE smc_cur2 CURSOR FOR smc_c2        
          OPEN smc_cur2
          FETCH smc_cur2 INTO l_su,l_tu
              IF SQLCA.sqlcode THEN LET l_flag =  1 END IF
      END IF
     IF l_flag = 0 
        THEN IF l_su = 0 OR l_su IS NULL
                THEN LET  l_factor = 0
                ELSE LET  l_factor = l_tu / l_su     #轉換率
             END IF
     END IF
   RETURN l_flag,l_factor
END FUNCTION
