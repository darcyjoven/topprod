# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Program name...: s_tlff3.4gl
# Descriptions...: 
# Date & Author..: 06/03/16 By yoyo
# Usage..........: CALL s_tlff3(p_unit,p_unit2,p_dbs)
# Input Parameter: p_unit   第一單位  
#                  p_unit2  第二單位
#                  p_pdbs   數據庫
# Return Code....: None
# Modify.........: NO.FUN-670091 06/07/25 BY yiting cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.FUN-980094 09/09/15 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A60028 10/06/24 By lilingyu 平行工藝
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_chr           LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 	#No.FUN-680147 SMALLINT
DEFINE   g_db            LIKE azp_file.azp03
#FUNCTION s_tlff3(p_unit,p_unit2,p_dbs)
FUNCTION s_tlff3(p_unit,p_unit2,p_plant)    #FUN-980094
    DEFINE
        p_unit          LIKE ima_file.ima25,
        p_unit2         LIKE ima_file.ima25,
        p_dbs           LIKE azp_file.azp03,
        p_dbs_tra       LIKE azp_file.azp03,
        ll_rowid        LIKE type_file.row_id,    #chr18,   FUN-A70120
        l_rowid         LIKE type_file.row_id,    #chr18,   FUN-A70120
        l_sql           LIKE type_file.chr1000    #No.FUN-680147 VARCHAR(1000)
    DEFINE   p_plant        LIKE type_file.chr20  #FUN-980094
 
     WHENEVER ERROR CALL cl_err_msg_log
 
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( g_tlff.tlff01 ,p_plant) OR NOT s_internal_item( g_tlff.tlff01,p_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED
   CALL s_getdbs()
   LET p_dbs = g_dbs_new     #將 g_dbs_new 的值給 p_dbs,這樣後續的語法就都不用改
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET p_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
    IF p_unit IS NOT NULL THEN
      IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
         g_tlff.tlff904 IS NOT NULL THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="SELECT rowid FROM ",p_dbs_tra CLIPPED,"tlff_file", #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102
                   " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                   "   AND tlff02 =  ",g_tlff.tlff02 ,
                   "   AND tlff03 =  ",g_tlff.tlff03 ,
                   "   AND tlff902= '",g_tlff.tlff902,"'",
                   "   AND tlff903= '",g_tlff.tlff903,"'",
                   "   AND tlff904= '",g_tlff.tlff904,"'",
                   "   AND tlff905= '",g_tlff.tlff905,"'",
                   "   AND tlff906=  ",g_tlff.tlff906,
                   "   AND tlff907=  ",g_tlff.tlff907,
                   "   AND tlff219= 2", 
                   "   AND tlff220= '",p_unit,"'"   
                  ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                  ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
         PREPARE tlff_cur1 FROM l_sql
         EXECUTE tlff_cur1 INTO l_rowid
      ELSE   
         IF NOT cl_null(g_tlff.tlff021) THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="SELECT rowid FROM ",p_dbs_tra CLIPPED,"tlff_file", #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102 
                      " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                      "   AND tlff02 =  ",g_tlff.tlff02 ,
                      "   AND tlff03 =  ",g_tlff.tlff03 ,
                      "   AND tlff021= '",g_tlff.tlff021,"'",
                      "   AND tlff022= '",g_tlff.tlff022,"'",
                      "   AND tlff023= '",g_tlff.tlff023,"'",
                      "   AND tlff026= '",g_tlff.tlff026,"'",
                      "   AND tlff027=  ",g_tlff.tlff027,
                      "   AND tlff219= 2", 
                      "   AND tlff220= '",p_unit,"'"   
                     ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                     ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
            PREPARE tlff_cur2 FROM l_sql
            EXECUTE tlff_cur2 INTO l_rowid
         END IF
         IF NOT cl_null(g_tlff.tlff031) THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="SELECT rowid FROM ",p_dbs_tra CLIPPED,"tlff_file",  #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102 
                      " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                      "   AND tlff02 =  ",g_tlff.tlff02 ,
                      "   AND tlff03 =  ",g_tlff.tlff03 ,
                      "   AND tlff031= '",g_tlff.tlff031,"'",
                      "   AND tlff032= '",g_tlff.tlff032,"'",
                      "   AND tlff033= '",g_tlff.tlff033,"'",
                      "   AND tlff036= '",g_tlff.tlff036,"'",
                      "   AND tlff037=  ",g_tlff.tlff037,
                      "   AND tlff219= 2", 
                      "   AND tlff220= '",p_unit,"'"   
                     ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                     ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
            PREPARE tlff_cur3 FROM l_sql
            EXECUTE tlff_cur3 INTO l_rowid
         END IF
      END IF
      IF status THEN
         #CALL cl_err('(s_tlff:select parent rowid)',STATUS,1) #FUN-670091
#        CALL cl_err3("sel","tlff_file","","",STATUS,"","s_tlff:select parent rowid",0) #FUN-670091
#No.FUN-710027--begin
      IF g_bgerr THEN
         CALL s_errmsg('','','(s_tlff:select parent rowid)',STATUS,1)
      ELSE
         CALL cl_err('(s_tlff:select parent rowid)',STATUS,1)
      END IF
#No.FUN-710027--end 
         LET g_success='N' RETURN
      ELSE
         LET g_tlff.tlff218 = l_rowid
        #LET l_sql="UPDATE ",p_dbs CLIPPED,"tlff_file",
         #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"tlff_file",  #FUN-980094
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102  
                   "   SET tlff218='",g_tlff.tlff218,"'",
                   " WHERE rowid=","'",l_rowid,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
         PREPARE tlff_cur4 FROM l_sql
         EXECUTE tlff_cur4
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('(s_tlff:update tlff218)',STATUS,1)  #FUN-670091
#            CALL cl_err3("upd","tlff_file",g_tlff.tlff218,"",STATUS,"","",1)  #FUN-670091
#No.FUN-710027--begin
      IF g_bgerr THEN
         CALL s_errmsg('','','(s_tlff:update tlff218)',STATUS,1)
      ELSE
         CALL cl_err('(s_tlff:update tlff218)',STATUS,1)
      END IF
#No.FUN-710027--end
            LET g_success ='N' RETURN
         END IF
         LET ll_rowid = l_rowid  #No.TQC-950134
      END IF
    END IF
 
    IF p_unit2 IS NOT NULL THEN
       IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
          g_tlff.tlff904 IS NOT NULL THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="SELECT rowid FROM ",p_dbs_tra CLIPPED,"tlff_file", #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102
                   " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                   "   AND tlff02 =  ",g_tlff.tlff02 ,
                   "   AND tlff03 =  ",g_tlff.tlff03 ,
                   "   AND tlff902= '",g_tlff.tlff902,"'",
                   "   AND tlff903= '",g_tlff.tlff903,"'",
                   "   AND tlff904= '",g_tlff.tlff904,"'",
                   "   AND tlff905= '",g_tlff.tlff905,"'",
                   "   AND tlff906=  ",g_tlff.tlff906,
                   "   AND tlff907=  ",g_tlff.tlff907,
                   "   AND tlff219= 1", 
                   "   AND tlff220= '",p_unit2,"'"   
                  ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                  ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
         PREPARE tlff_cur5 FROM l_sql
         EXECUTE tlff_cur5 INTO l_rowid
       ELSE   
         IF NOT cl_null(g_tlff.tlff021) THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="SELECT rowid FROM ",p_dbs_tra CLIPPED,"tlff_file",  #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102
                      " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                      "   AND tlff02 =  ",g_tlff.tlff02 ,
                      "   AND tlff03 =  ",g_tlff.tlff03 ,
                      "   AND tlff021= '",g_tlff.tlff021,"'",
                      "   AND tlff022= '",g_tlff.tlff022,"'",
                      "   AND tlff023= '",g_tlff.tlff023,"'",
                      "   AND tlff026= '",g_tlff.tlff026,"'",
                      "   AND tlff027=  ",g_tlff.tlff027,
                      "   AND tlff219= 1", 
                      "   AND tlff220= '",p_unit2,"'"   
                     ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                     ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
            PREPARE tlff_cur6 FROM l_sql
            EXECUTE tlff_cur6 INTO l_rowid
         END IF
         IF NOT cl_null(g_tlff.tlff031) THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="SELECT rowid FROM ",p_dbs_tra CLIPPED,"tlff_file",  #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102
                      " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                      "   AND tlff02 =  ",g_tlff.tlff02 ,
                      "   AND tlff03 =  ",g_tlff.tlff03 ,
                      "   AND tlff031= '",g_tlff.tlff031,"'",
                      "   AND tlff032= '",g_tlff.tlff032,"'",
                      "   AND tlff033= '",g_tlff.tlff033,"'",
                      "   AND tlff036= '",g_tlff.tlff036,"'",
                      "   AND tlff037=  ",g_tlff.tlff037,
                      "   AND tlff219= 1", 
                      "   AND tlff220= '",p_unit2,"'"   
                     ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                     ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
            PREPARE tlff_cur7 FROM l_sql
            EXECUTE tlff_cur7 INTO l_rowid
         END IF
      END IF
      IF STATUS THEN
         #CALL cl_err('(s_tlff2:select rowid)',STATUS,1) #FUN-670091
#         CALL cl_err3("sel","tlff_file","","",STATUS,"","",1) #FUN-670091
#No.FUN-710027--begin
      IF g_bgerr THEN
         CALL s_errmsg('','','(s_tlff2:select rowid)',STATUS,1)
      ELSE
         CALL cl_err('(s_tlff2:select rowid)',STATUS,1)
      END IF
#No.FUN-710027--end        
         LET g_success='N' RETURN
      ELSE
         LET g_tlff.tlff218 = l_rowid
        #LET l_sql="UPDATE ",p_dbs CLIPPED,"tlff_file",
         #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"tlff_file",  #FUN-980094
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102 
                   "   SET tlff218='",g_tlff.tlff218,"'",
                   " WHERE rowid='",l_rowid,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
         PREPARE tlff_cur9 FROM l_sql
         EXECUTE tlff_cur9
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('(s_tlff:update tlff218)',STATUS,1)  #FUN-670091
#            CALL cl_err3("upd","tlff_file","","",STATUS,"","s_tlff:update tlff218",1) #FUN-670091
#No.FUN-710027--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','(s_tlff:update tlff218)',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('(s_tlff:update tlff218)',STATUS,1)                                                                 
      END IF                                                                                                                        
#No.FUN-710027--end 
            LET g_success ='N' RETURN
         END IF
         IF ll_rowid IS NOT NULL THEN  #No.TQC-950134
           #LET l_sql="UPDATE ",p_dbs CLIPPED,"tlff_file",
            #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"tlff_file",   #FUN-980094
            LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'tlff_file'), #FUN-A50102 
                      "   SET tlff218='",g_tlff.tlff218,"'",
                      " WHERE rowid='",ll_rowid,"'"  #No.TQC-950134
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
         PREPARE tlff_cur8 FROM l_sql
         EXECUTE tlff_cur8
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('(s_tlff:update tlff218)',STATUS,1) #FUN-670091
#            CALL cl_err3("upd","tlff_file","","",STATUS,"","s_tlff:update tlff218",1) #FUN-670091
#No.FUN-710027--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','(s_tlff:update tlff218)',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('(s_tlff:update tlff218)',STATUS,1)                                                                           
      END IF                                                                                                                        
#No.FUN-710027--end 
            LET g_success ='N' RETURN
         END IF
      END IF
    END IF
   END IF
      
END FUNCTION      
