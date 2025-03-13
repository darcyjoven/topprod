# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_mudima.4gl
# Descriptions...: 多角貿易更新ima (可指定資料庫)
# Date & Author..: No.7993 03/09/1 By Kammy 
# Usage..........: CALL s_mudima(p_part,p_plant)
# Input Parameter: p_part       料號
#                  p_plant      資料庫
# Return code....: 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-720003 07/02/05 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980094 09/09/15 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(72)
#FUN-980094 傳入的db變數應該成傳入plant 變數---------------------(S)
#FUNCTION s_mudima(p_part,p_dbs) 
FUNCTION s_mudima(p_part,p_plant) 
#FUN-980094 傳入的db變數應該成傳入plant 變數---------------------(E)
 DEFINE p_part                     LIKE ima_file.ima01
 DEFINE p_dbs                      LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
 DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
 DEFINE l_sql                      LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(600)
# DEFINE l_ima26,l_ima261,l_ima262  LIKE ima_file.ima26 #FUN-A20044
 DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
 
    IF p_part[1,4]='MISC' THEN RETURN END IF  #No.8743
 
    #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
     LET g_plant_new = p_plant CLIPPED
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
 
     CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
    #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
    MESSAGE p_dbs CLIPPED,"u_ima!"
  #  LET l_ima26 =0 
   # LET l_ima261=0 
   # LET l_ima262=0    #FUN-A20044
     LET l_avl_stk_mpsmrp = 0 #FUN-A20044  
     LET l_unavl_stk = 0 #FUN-A20044
     LET l_avl_stk = 0 #FUN-A20044
    LET l_sql = " SELECT SUM(img10*img21) ",
               #"   FROM ",p_dbs CLIPPED,"img_file ",
		#"   FROM ",g_dbs_tra CLIPPED,"img_file ",    #FUN-980094
        "   FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
		"  WHERE img01 = '",p_part,"'",
		"    AND img23 = 'Y' AND img24 = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
    PREPARE img_prepare1 FROM l_sql 
    IF SQLCA.sqlcode THEN 
       LET g_msg = p_dbs CLIPPED,'img_prepare'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('img01',p_part,g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       LET g_success = 'N'
       RETURN
    END IF
    DECLARE img_curs1 CURSOR FOR img_prepare1
    OPEN img_curs1
#    FETCH img_curs1 INTO l_ima26  #FUN-A20044
    FETCH img_curs1 INTO l_avl_stk_mpsmrp  #FUN-A20044
    IF SQLCA.sqlcode THEN
       LET g_msg = p_dbs CLIPPED,'fetch img_curs1'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       LET g_success = 'N'
       RETURN
    END IF
    CLOSE img_curs1
#    IF cl_null(l_ima26) THEN LET l_ima26 = 0 END IF #FUN-A20044
    IF cl_null(l_avl_stk_mpsmrp) THEN LET l_avl_stk_mpsmrp = 0 END IF #FUN-A20044
 
    LET l_sql = " SELECT SUM(img10*img21) ",
               #"   FROM ",p_dbs CLIPPED,"img_file ",
		#"   FROM ",g_dbs_tra CLIPPED,"img_file ",  #FUN-980094
        "   FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
		"  WHERE img01 = '",p_part,"'",
		"    AND img23 = 'N' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
    PREPARE img_prepare2 FROM l_sql 
    IF SQLCA.sqlcode THEN 
       LET g_msg = p_dbs CLIPPED,'img_prepare2'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('img01',p_part,g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       LET g_success = 'N'
       RETURN
    END IF
    DECLARE img_curs2 CURSOR FOR img_prepare2
    OPEN img_curs2
#    FETCH img_curs2 INTO l_ima261 #FUN-A20044
    FETCH img_curs2 INTO l_unavl_stk #FUN-A20044
    IF SQLCA.sqlcode THEN
       LET g_msg = p_dbs CLIPPED,'fetch img_curs2'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end  
       LET g_success = 'N'
       RETURN
    END IF
    CLOSE img_curs2
#    IF cl_null(l_ima261) THEN LET l_ima261 = 0 END IF #FUN-A20044
    IF cl_null(l_unavl_stk) THEN LET l_unavl_stk = 0 END IF #FUN-A20044
 
    LET l_sql = " SELECT SUM(img10*img21) ",
               #"   FROM ",p_dbs CLIPPED,"img_file ",
                #"   FROM ",g_dbs_tra CLIPPED,"img_file ",
                "   FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
		        "  WHERE img01 = '",p_part,"'",
		        "    AND img23 = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
    PREPARE img_prepare3 FROM l_sql 
    IF SQLCA.sqlcode THEN 
       LET g_msg = p_dbs CLIPPED,'img_prepare3'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('img01',p_part,g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       LET g_success = 'N'
       RETURN
    END IF
    DECLARE img_curs3 CURSOR FOR img_prepare3
    OPEN img_curs3
#    FETCH img_curs3 INTO l_ima262 #FUN-A20044
    FETCH img_curs3 INTO l_avl_stk #FUN-A20044
    IF SQLCA.sqlcode THEN
       LET g_msg = p_dbs CLIPPED,'img_curs3'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       LET g_success = 'N'
       RETURN
    END IF
    CLOSE img_curs3
#    IF cl_null(l_ima262) THEN LET l_ima262 = 0 END IF #FUN-A20044
    IF cl_null(l_avl_stk) THEN LET l_avl_stk = 0 END IF #FUN-A20044
   #####FUN-A20044------BEGIN 
    #LET l_sql = " UPDATE ",p_dbs CLIPPED,"ima_file ",
#		"    SET ima26=?,ima261=?,ima262=? ",
#		"  WHERE ima01 = '",p_part,"'"
 #	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  #  PREPARE updima_prepare FROM l_sql
   # IF SQLCA.sqlcode THEN 
    #   LET g_msg = p_dbs CLIPPED,'updima_prepare'
#      CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
     # IF g_bgerr THEN                                                                                                               
      #   CALL s_errmsg('ima01',p_part,g_msg,SQLCA.sqlcode,1)                                                                     
     # ELSE                                                                                                                          
      #   CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
     # END IF                                                                                                                        
#No.FUN-720003--end          
      # LET g_success = 'N'
      # RETURN
  #  END IF
  #  EXECUTE updima_prepare USING l_ima26,l_ima261,l_ima262
   # IF STATUS THEN
    #   LET g_msg = p_dbs CLIPPED,'upd ima26*'
#      CALL cl_err(g_msg,STATUS,1) 
#No.FUN-720003--begin                                                                                                               
     # IF g_bgerr THEN                                                                                                               
      #   CALL s_errmsg('','',g_msg,STATUS,1)                                                                     
     # ELSE                                                                                                                          
      #   CALL cl_err(g_msg,STATUS,1)                                                                             
     # END IF                                                                                                                        
#No.FUN-720003--end  
   # LET g_success='N' RETURN
   # END IF
   # IF SQLCA.SQLERRD[3]=0 THEN
    #   LET g_msg = p_dbs CLIPPED,'upd ima26*'
#    #  CALL cl_err(g_msg,'axm-176',1) 
#No.FUN-720003--begin                                                                                                               
     # IF g_bgerr THEN                                                                                                               
      #   CALL s_errmsg('','',g_msg,'axm-176',1)                                                                     
    #  ELSE                                                                                                                          
     #    CALL cl_err(g_msg,'axm-176',1)                                                                             
    #  END IF                                                                                                                        
#No.FUN-720003--end        
    #   LET g_success='N' RETURN
  #  END IF 
  #####FUN-A20044------END
END FUNCTION
