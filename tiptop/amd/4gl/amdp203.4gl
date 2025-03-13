# Prog. Version..: '5.30.06-13.03.12(00001)'     #

#
# Pattern name...: amdp203.4gl
# Descriptions...: 電子發票匯出作業(汎宇標準版)
# Date & Author..: No:FUN-C10032 12/01/13  by pauline
IMPORT os        
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql                  STRING
DEFINE g_before_input_done    STRING
DEFINE g_err_cnt              LIKE type_file.num10 
DEFINE s1,s2,s3,t1,t2,t3      LIKE type_file.chr1
DEFINE ama01                  LIKE ama_file.ama01
DEFINE g_wc                   STRING
DEFINE l_flag                 LIKE type_file.chr1
DEFINE l_ama01                LIKE ama_file.ama01

MAIN
   DEFINE   p_row,p_col  LIKE type_file.num5
 
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
     EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = 3 LET p_col = 3
   OPEN WINDOW p203_w AT p_row,p_col
        WITH FORM "amd/42f/amdp203"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    CALL cl_set_comp_entry('gln,ama01',FALSE) 
 

   WHILE TRUE
      LET g_success = 'Y'
      CALL p203_tm()
      CALL p203_cre_tmp()
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p203()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW p203_w 
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p203_tm()
   DEFINE   l_n   LIKE type_file.num5         
 
    CONSTRUCT BY NAME g_wc ON ome01,oga01,ome02,occ01,occ74 

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
    
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ome01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ome"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ome01 
               NEXT FIELD ome01 
            WHEN INFIELD(oga01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oga013"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga01 
               NEXT FIELD oga01 
            WHEN INFIELD(occ01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ01 
               NEXT FIELD occ01 
            WHEN INFIELD(occ74)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ74"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ74 
               NEXT FIELD occ74 
            OTHERWISE
         END CASE
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      
      ON ACTION controlg      
         CALL cl_cmdask()     
    
      ON ACTION qbe_select
         CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED
   IF cl_null(g_wc) THEN
      LET g_wc = '1=1'
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p203_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   LET t1 = 'N'
   LET t2 = 'N'
   LET t3 = 'N'
   LET s2 = '1'

   INPUT BY NAME
      s1,s2,t1,t2,s3,ama01,t3
      WITHOUT DEFAULTS
 
      BEFORE INPUT
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
 

      AFTER FIELD s3 
         IF s3 = '2' THEN
            CALL cl_set_comp_entry('ama01',TRUE)
         ELSE
            CALL cl_set_comp_entry('ama01',FALSE) 
         END IF 
 
      AFTER FIELD ama01
         IF s3 = '2' THEN
            IF cl_null(ama01) THEN
               CALL cl_err('','9046',1)
               NEXT FIELD ama01
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            RETURN
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ama01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ama"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING ama01 
               DISPLAY BY NAME ama01 
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

   END INPUT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
END FUNCTION

FUNCTION p203_cre_tmp()

    CREATE TEMP TABLE p203_tmp(
                  ome01    LIKE ome_file.ome01,    #發票號碼
                  ome172   LIKE ome_file.ome172,   #稅率別
                  ome02    LIKE ome_file.ome02,    #發票日期
                  ome59    LIKE ome_file.ome59,    #發票金額
                  ome171   LIKE ome_file.ome171,   #發票格式
                  ome59x   LIKE ome_file.ome59x,   #發票稅額
                  ome042   LIKE ome_file.ome042,   #買方統編
                  ome60    LIKE ome_file.ome60,    #申報統編
                  ome59t   LIKE ome_file.ome59t,   #含稅金額
                  ome05    LIKE ome_file.ome05,    #發票別
                  ogb12    LIKE ogb_file.ogb12,    #數量
                  ogb13    LIKE ogb_file.ogb13,    #單價
                  oea10    LIKE oea_file.oea10,    #買方訂單號碼
                  amh06    LIKE amh_file.amh06,    #店別編號
                  amh07    LIKE amh_file.amh07,    #供應商編號
　　　　　　　　　oga50    LIKE oga_file.oga50,    #未稅金額
                  ami04    LIKE ami_file.ami04,    #促銷條碼
                  occ74    LIKE occ_file.occ74,    #總店號
                  oga01    LIKE oga_file.oga01,    #出貨單號
                  zo06     LIKE zo_file.zo06,      #賣方統編
                  ome211   LIKE ome_file.ome211)   #稅率 
 #Vivian Start               
   CREATE TEMP TABLE p203_tmp2(
                  amh06       LIKE amh_file.amh06,    #店別編號
                  oga01       LIKE oga_file.oga01,    #出貨單號
                  ogb03       LIKE ogb_file.ogb03,    #項次(自訂明序)
                  ogb06       LIKE ogb_file.ogb06,    #簡易說明(品名)
                  ome01       LIKE ome_file.ome01,    #發票號碼
                  ogb04       LIKE ogb_file.ogb04,    #數量
                  ogb13       LIKE ogb_file.ogb13,    #未稅單價
                  ome172      LIKE ome_file.ome172,   #稅別
                  ogb14       LIKE ogb_file.ogb14)    #未稅金額  
             
    CREATE TEMP TABLE p203_tmp3(
                  amh06       LIKE amh_file.amh06,    #店別編號
                  oga01       LIKE oga_file.oga01,    #出貨單號
                  ome01       LIKE ome_file.ome01,    #發票號碼
                  oea10       LIKE oea_file.oea10,    #客戶訂單號
                  ogb04       LIKE ogb_file.ogb04,    #貨號                                
                  ogb12       LIKE ogb_file.ogb12,    #數量
                  ogb13       LIKE ogb_file.ogb13,    #未稅單價
                  ome172      LIKE ome_file.ome172,   #稅別                              
                  ogb14       LIKE ogb_file.ogb14,    #未稅金額 
                  ogb06       LIKE ogb_file.ogb06)    #簡易說明(品名)    
# End By Vivian    
END FUNCTION

FUNCTION p203()
   DEFINE l_zo06     LIKE zo_file.zo06        #賣方統編
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_oao06    LIKE oao_file.oao06      #單一備註欄
   DEFINE l_amh06    LIKE amh_file.amh06      #店別編號
   DEFINE l_amh07    LIKE amh_file.amh07      #供應商編號
   DEFINE l_ima09    LIKE ima_file.ima09
   DEFINE l_ima10    LIKE ima_file.ima10
   DEFINE l_ima11    LIKE ima_file.ima11
   DEFINE l_ima06    LIKE ima_file.ima06
   DEFINE l_ima131   LIKE ima_file.ima131
   DEFINE l_amh02    LIKE amh_file.amh02
   DEFINE l_amh05    LIKE amh_file.amh05
   DEFINE l_ami04    LIKE ami_file.ami04
   DEFINE l_flag2    LIKE type_file.chr1
   DEFINE sum_ogb16  LIKE ogb_file.ogb16
   DEFINE sr     RECORD
                  ome01    LIKE ome_file.ome01,    #發票號碼
                  ome172   LIKE ome_file.ome172,   #稅率別
                  ome02    LIKE ome_file.ome02,    #發票日期
                  ome59    LIKE ome_file.ome59,    #發票金額
                  ome171   LIKE ome_file.ome171,   #發票格式
                  ome59x   LIKE ome_file.ome59x,   #發票稅額
                  ome042   LIKE ome_file.ome042,   #買方統編
                  ome60    LIKE ome_file.ome60,    #申報統編
                  ome59t   LIKE ome_file.ome59t,   #含稅金額
                  oma01    LIKE oma_file.oma01,    #帳款編號          
                  ome05    LIKE ome_file.ome05,    #發票別            
                  omevoid  LIKE ome_file.omevoid,  #作廢否            
                  omb04    LIKE omb_file.omb04,    #產品編號          
                  omb32    LIKE omb_file.omb32,    #出貨單項次    
                  occ74    LIKE occ_file.occ74,    #總店號
                  oma04    LIKE oma_file.oma04,    #發票客戶        
                  ome043   LIKE ome_file.ome043,   #發票客戶全名     
                  ome044   LIKE ome_file.ome044,   #發票客戶地址      
                  occ30    LIKE occ_file.occ30,    #財務聯絡人     
                  ome211   LIKE ome_file.ome211   #稅率 
                 END RECORD
   DEFINE       l_oga01    LIKE oga_file.oga01,    #出貨單        
                l_oga02    LIKE oga_file.oga02,    #出貨單日期        
                l_oga03    LIKE oga_file.oga03,    #客戶編號          
                l_oga16    LIKE oga_file.oga16,    #訂單編號          
                l_ogb12    LIKE ogb_file.ogb12,    #數量             
                l_ogb13    LIKE ogb_file.ogb13,    #單價           
                l_ogb14    LIKE ogb_file.ogb14,    #未稅金額      
                l_ogb05    LIKE ogb_file.ogb05,    #單位            
                l_oea10    LIKE oea_file.oea10,    #買方訂單號碼   
                l_ogb1005  LIKE ogb_file.ogb1005,  #作業方式      
                l_ogb1012  LIKE ogb_file.ogb1012,  #搭贈         
                l_ogb32    LIKE ogb_file.ogb32,    #訂單單身項次 
                l_oga50    LIKE oga_file.oga50,    #未稅金額     
                l_ogb03    LIKE ogb_file.ogb03,    #項次
                l_ogb04    LIKE ogb_file.ogb04,    #產品編號
                l_ogb06    LIKE ogb_file.ogb06     #品名規格

   LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome042,ome60,ome59t,oma01,ome05,", 
               " omevoid,omb04,omb32,occ74,oma04,ome043,ome044,occ30,ome211 ", #Vivian Modi 
               " FROM omee_file,ome_file,occ_file,oma_file,omb_file ",
               " WHERE omee02 = oma01 ",
               "   AND omee01 = ome01 ",
               "   AND oma01 = omb01 ", 
               "   AND oma03 = occ01 ", 
               "   AND ome212 = '",s1,"' ",
               "   AND ",g_wc CLIPPED
   IF t3 = 'N' THEN
      LET g_sql = g_sql," AND omevoid = 'N' "
   END IF
   LET g_sql = g_sql," ORDER BY ome01,omb01,omb03 " 
   PREPARE p203_pre FROM g_sql
   DECLARE p203_cs CURSOR FOR p203_pre

   DELETE FROM p203_tmp
   DELETE FROM p203_tmp2  #Vivian Add
   DELETE FROM p203_tmp3  #Vivian Add

   FOREACH p203_cs INTO sr.*
       
      SELECT zo06 INTO l_zo06 FROM zo_file WHERE zo01=g_lang

      SELECT ima09,ima10,ima11,ima06,ima131 INTO l_ima09,l_ima10,l_ima11,l_ima06
        FROM ima_file WHERE ima01 = sr.omb04      
      SELECT amh02 INTO l_amh02 FROM amh_file
       WHERE amh01 = sr.occ74 
      IF l_amh02='D' THEN 
         LET l_amh05 = l_ima09
      ELSE
         IF l_amh02='E' THEN 
            LET l_amh05 = l_ima10
         ELSE 
            IF l_amh02='F' THEN 
               LET l_amh05 = l_ima11
            ELSE 
               IF l_amh02 = 'M' THEN 
                  LET l_amh05 = l_ima06
               ELSE
                  IF l_amh02 = 'P' THEN 
                     LET l_amh05 = l_ima131
                  END IF
               END IF
            END IF
         END IF
      END IF 
      SELECT amh06,amh07 INTO l_amh06,l_amh07 FROM amh_file 
       WHERE amh01 = sr.occ74 AND amh02 = l_amh02 AND amh04 = sr.oma04
         AND amh05 = l_amh05
      IF cl_null(l_amh06) THEN  #Vivian add
         LET l_amh06 = ' '      #Vivian add
      END IF                    #Vivian add
     #發票種類
      IF sr.omevoid= 'Y' THEN
         LET sr.ome05 ='2'
      ELSE
         LET sr.ome05 = '1'
      END IF  
     #賣方統編
      IF s3 = '1' THEN
         LET sr.ome60 = l_zo06
      ELSE
         LET sr.ome60 = sr.ome60
      END IF

     #Vivian Start  當為'3.免稅'時改為 '0'
      IF sr.ome172='3' THEN 
         LET sr.ome172='0'
      END IF
     #Vivian End  
      LET l_cnt = 0
      LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oga_file'), 
                  "  WHERE oga10 = '",sr.oma01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE sel_oga_pre FROM g_sql
      EXECUTE sel_oga_pre INTO l_cnt 
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0 
      END IF
      IF l_cnt > 0 THEN
         #LET g_sql = "SELECT oga01,oga02,oga03,oga16,oga50,ogb32,ogb05,ogb12,ogb13,ogb14,ogb1005,ogb1012 ",  #Vivian Mark
         LET g_sql = "SELECT oga01,oga02,oga03,oga16,oga50,ogb32,ogb05,ogb12,ogb13,ogb14,ogb1005,ogb1012, ",  #Vivian Add
                     " ogb03,ogb04,ogb06 ", #Vivian Add
                     " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                              cl_get_target_table(g_plant_new,'ogb_file'),   
                     " WHERE oga10 = '",sr.oma01,"'",
                     "   AND oga01 = ogb01 ",
                     "   AND ogb03 = ",sr.omb32    
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE p203_oga_p FROM g_sql
         DECLARE p203_oga_c CURSOR FOR p203_oga_p
         #FOREACH p203_oga_c INTO l_oga01,l_oga02,l_oga03,l_oga16,l_oga50,l_ogb32,l_ogb05,l_ogb12,l_ogb13,l_ogb14,l_ogb1005,l_ogb1012  # Vivian Mark
         FOREACH p203_oga_c INTO l_oga01,l_oga02,l_oga03,l_oga16,l_oga50,l_ogb32,l_ogb05,l_ogb12,l_ogb13,l_ogb14,l_ogb1005,l_ogb1012,l_ogb03,l_ogb04,l_ogb06  #Vivian Add
           LET l_cnt = 0
           IF t2 = 'N' AND (l_ogb1005 = '2' OR l_ogb1012 = 'Y') THEN
              CONTINUE FOREACH
           END IF
           LET g_sql = " SELECT COUNT(*) ",
                       "   FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", 
                                  cl_get_target_table(g_plant_new,'oeb_file'),   
                       "  WHERE oea01 = '",l_oga16,"'",
                       "    AND oea01 = oeb01 ",
                       "    AND oeb03 = ",l_ogb32
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
           PREPARE sel_oea_p1 FROM g_sql
           EXECUTE sel_oea_p1 INTO l_cnt 
           IF cl_null(l_cnt) THEN
              LET l_cnt = 0 
           END IF
           IF l_cnt > 0 THEN
              LET l_oea10 = ''
              LET g_sql = " SELECT oea10 ",
                          "   FROM ",cl_get_target_table(g_plant_new,'oea_file'),
                          "  WHERE oea01 = '",l_oga16,"'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
              PREPARE sel_oea_p2 FROM g_sql
              EXECUTE sel_oea_p2 INTO l_oea10
           END IF
           #發票明細參考號碼
            SELECT ami04 INTO l_ami04 FROM ami_file,amj_file
             WHERE ami01 = l_oga03     
               AND ami02 <= l_oga02   
               AND ((l_oga02 < ami03) OR (ami03 IS NULL))             
               AND amj05 = sr.omb04 AND amiacti = 'Y'                 
               AND ami01 = amj01 AND ami02 = amj02 AND ami04 = amj04
            IF cl_null(l_ami04) THEN
               SELECT ami04 INTO l_ami04 FROM ami_file,amj_file
                WHERE ami01 = sr.occ74
                  AND ami02 <= l_oga02                                
                  AND ((l_oga02 < ami03) OR (ami03 IS NULL))         
                  AND amj05 = sr.omb04 AND amiacti = 'Y'             
                  AND ami01 = amj01 AND ami02 = amj02 AND ami04 = amj04
            ELSE
               LET l_flag2 = 'Y'
            END IF   
            IF cl_null(l_ami04) THEN
               SELECT ima135 INTO l_ami04 FROM ima_file
                WHERE ima01 = sr.omb04                                
            ELSE
               LET l_flag2 = 'Y'
            END IF
           #單價
            IF l_flag2 = 'Y' THEN
               LET sum_ogb16 = 0 
               LET g_sql = " SELECT SUM(ogb16) ",
                           "   FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                           "  WHERE ogb01 = '",l_oga01,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
               PREPARE sel_ogb_p1 FROM g_sql
               EXECUTE sel_ogb_p1 INTO sum_ogb16
               IF cl_null(sum_ogb16) THEN
                  LET sum_ogb16 = 0 
               END IF
               LET l_ogb13 = l_oga50 / sum_ogb16                 
            ELSE
               LET l_ogb13 = l_ogb13                           
            END IF
           #未稅金額
            IF l_flag2 = 'Y' THEN
               LET l_oga50 = l_oga50    
            ELSE
               LET l_oga50 = l_ogb14 
            END IF 
 
	INSERT INTO p203_tmp VALUES(sr.ome01,sr.ome172,sr.ome02,sr.ome59,sr.ome171,sr.ome59x,sr.ome042,
                                        sr.ome60,sr.ome59t,sr.ome05,l_ogb12,
                                        l_ogb13,l_oea10,l_amh06,l_amh07,l_oga50,l_ami04,sr.occ74, #Vivian Modi
                                        l_oga01,l_zo06,sr.ome211)                            
            IF SQLCA.SQLCODE THEN
               CALL cl_err3('ins','p203_tmp','','','',SQLCA.sqlcode,'',1) 
            END IF

            #Vivian Start

            IF l_ogb1012='Y' THEN  #贈品否
               LET l_oea10 = l_oea10[1,7]
               LET l_ogb04 = l_ogb04[1,6]
               INSERT INTO p203_tmp2 VALUES(l_amh06,l_oga01,l_ogb03,l_ogb06,sr.ome01,l_ogb12,
                                            l_ogb13,sr.ome172,l_ogb14)
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err3('ins','p203_tmp2','','','',SQLCA.sqlcode,'',1)
               END IF
            ELSE
               INSERT INTO p203_tmp3 VALUES(l_amh06,l_oga01,sr.ome01,l_oea10,l_ogb04,l_ogb12,
                                            l_ogb13,sr.ome172,l_ogb14,l_ogb06)
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err3('ins','p203_tmp3','','','',SQLCA.sqlcode,'',1)
               END IF  
            END IF    
         #Vivian End   
         END FOREACH
             
      ELSE          
         INSERT INTO p203_tmp VALUES(sr.ome01,sr.ome172,sr.ome02,sr.ome59,sr.ome171,sr.ome59x,sr.ome042,
                                     sr.ome60,sr.ome59t,sr.ome05,'',
                                     '','',l_amh06,l_amh07,'','',sr.occ74,'','','')
         IF SQLCA.SQLCODE THEN
            CALL cl_err3('ins','p203_tmp','','','',SQLCA.sqlcode,'',1) 
         END IF
      END IF          
   END FOREACH
   
   SELECT COUNT(*) INTO l_cnt FROM p203_tmp
   IF l_cnt = 0 THEN
      CALL cl_err('','axc-034',1)
      LET g_success = 'N'
   ELSE
      CALL p203_exp()
   END IF
END FUNCTION

FUNCTION p203_exp()

DEFINE g_ome DYNAMIC ARRAY OF RECORD
             ome01    LIKE ome_file.ome01,    #發票號碼
             ome172   LIKE ome_file.ome172,   #稅率別
             ome02    LIKE ome_file.ome02,    #發票日期
             ome59    LIKE ome_file.ome59,    #發票金額
             ome171   LIKE ome_file.ome171,   #發票格式
             ome59x   LIKE ome_file.ome59x,   #發票稅額
             ome042   LIKE ome_file.ome042,   #買方統編
             ome60    LIKE ome_file.ome60,    #申報統編
             ome59t   LIKE ome_file.ome59t,   #含稅金額
             ome05    LIKE ome_file.ome05,    #發票別
             ogb12    LIKE ogb_file.ogb12,    #數量
             ogb13    LIKE ogb_file.ogb13,    #單價
             oea10    LIKE oea_file.oea10,    #買方訂單號碼
             amh06    LIKE amh_file.amh06,    #店別編號
             amh07    LIKE amh_file.amh07,    #供應商編號
　　　　　　 oga50    LIKE oga_file.oga50,    #未稅金額
             ami04    LIKE ami_file.ami04,    #促銷條碼
             occ74    LIKE occ_file.occ74,    #總店號
             oga01    LIKE oga_file.oga01,    #出貨單號
             zo06     LIKE zo_file.zo06,      #賣方統編
             ome211   LIKE ome_file.ome211    #稅率 
       END RECORD
#Vivian Add Start
DEFINE g_ome2 DYNAMIC ARRAY OF RECORD
             amh06       LIKE amh_file.amh06,    #店別編號
             oga01       LIKE oga_file.oga01,    #出貨單號
             ogb03       LIKE ogb_file.ogb03,    #項次
             ogb06       LIKE ogb_file.ogb06,    #簡易說明(品名)
             ome01       LIKE ome_file.ome01,    #發票號碼
             ogb12       LIKE ogb_file.ogb12,    #數量
             ogb13       LIKE ogb_file.ogb13,    #未稅單價
             ome172      LIKE ome_file.ome172,   #稅別
             ogb14       LIKE ogb_file.ogb14     #未稅金額                                
        END RECORD      
DEFINE g_ome3 DYNAMIC ARRAY OF RECORD
             amh06       LIKE amh_file.amh06,    #店別編號
             oga01       LIKE oga_file.oga01,    #出貨單號
             ome01       LIKE ome_file.ome01,    #發票號碼
             oea10       LIKE oea_file.oea10,    #客戶訂單號
             ogb04       LIKE ogb_file.ogb04,    #貨號                                
             ogb12       LIKE ogb_file.ogb12,    #數量
             ogb13       LIKE ogb_file.ogb13,    #未稅單價
             ome172      LIKE ome_file.ome172,   #稅別                              
             ogb14       LIKE ogb_file.ogb14,    #未稅金額    
             ogb06       LIKE ogb_file.ogb06     #簡易說明(品名) 
         END RECORD
#Vivian Add End


DEFINE l_tempdir   STRING
DEFINE l_ome       STRING
DEFINE l_txt       STRING           #MOD-B10004 add
DEFINE l_cmd       STRING
DEFINE l_det       STRING
DEFINE lc_channe1      base.Channel
DEFINE l_c         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_sql1      STRING            # Vivian Add
DEFINE l_occ74     LIKE occ_file.occ74
DEFINE l_time      LIKE type_file.chr8
DEFINE l_zo06      LIKE zo_file.zo06
DEFINE l_ome01     LIKE ome_file.ome01
DEFINE l_ome59     STRING
DEFINE l_ome59x    STRING
DEFINE l_ome59t    STRING
DEFINE l_ogb12     STRING
DEFINE l_ogb13     STRING
DEFINE l_ogb14     STRING
DEFINE l_oga50     STRING
DEFINE l_ome172    STRING
DEFINE l_ogb03     STRING
DEFINE l_n1,l_n2,l_n3  LIKE type_file.num5
DEFINE l_n4,l_n5,l_n6  LIKE type_file.num5
DEFINE l_n7,l_n8,l_n9  LIKE type_file.num5
DEFINE l_n10,l_n11,l_n12  LIKE type_file.num5
DEFINE l_n13,l_n14,l_n15  LIKE type_file.num5
DEFINE l_n16,l_n17,l_n18  LIKE type_file.num5
DEFINE l_n19,l_n20,l_n21  LIKE type_file.num5
DEFINE l_n22,l_n23,l_n24  LIKE type_file.num5
DEFINE l_n25,l_n26,l_n27  LIKE type_file.num5
DEFINE l_n30              LIKE type_file.num5
DEFINE l_length    LIKE type_file.num5
DEFINE l_n_amh07   LIKE type_file.num5 
DEFINE unix_path   STRING              
DEFINE window_path STRING             
DEFINE ms_codeset  STRING              
DEFINE l_date      STRING
DEFINE l_ome211    STRING
DEFINE l_n31       LIKE type_file.num5
DEFINE l_amh06,l_amb07,l_oga01     STRING,
       l_oea10,l_ami04,l_amh07     STRING,
       l_ogb06,l_ogb04             STRING
       

  LET l_sql = "SELECT DISTINCT occ74 FROM p203_tmp ORDER BY occ74"
  PREPARE p203_occ74_pre FROM l_sql
  DECLARE p203_occ74_cs SCROLL CURSOR FOR p203_occ74_pre
  FOREACH p203_occ74_cs INTO l_occ74
       LET l_c = 1
       LET l_tempdir = FGL_GETENV('TEMPDIR')
       LET l_time = TIME(CURRENT)
       LET l_time = cl_replace_str(l_time,":","")
       SELECT zo06 INTO l_zo06 FROM zo_file where zo01=g_lang
       LET l_ome = "summary_ver",TODAY USING 'YYMMDD'
       LET l_cmd = "cat  /dev/null > ",l_tempdir CLIPPED,"/",l_ome CLIPPED     
       DISPLAY "l_cmd:",l_cmd
       DISPLAY "l_ome:",l_ome
       RUN l_cmd
       LET lc_channe1 = base.Channel.create()
       CALL lc_channe1.openFile(l_ome,"w")
       CALL lc_channe1.setDelimiter("")      
     
       CALL g_ome.clear()
    
       LET ms_codeset = cl_get_codeset()      
     
       LET l_sql = "SELECT * FROM p203_tmp WHERE occ74 = '",l_occ74,"'"
       PREPARE p203_tm_pre FROM l_sql
       DECLARE p203_tm_cs SCROLL CURSOR FOR p203_tm_pre
     
       FOREACH p203_tm_cs INTO g_ome[l_c].*
     
         IF SQLCA.sqlcode THEN
             CALL cl_err('Foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         CALL p203_train3(2,g_ome[l_c].amh06)   RETURNING l_n1,l_amh06  
         CALL p203_train3(20,g_ome[l_c].oga01)  RETURNING l_n30,l_oga01   
         CALL p203_train(10,g_ome[l_c].ome59) RETURNING l_n2,l_ome59            
         CALL p203_train(9,g_ome[l_c].ome59x) RETURNING l_n3,l_ome59x           
         CALL p203_train(11,cl_digcut(g_ome[l_c].ome59t,0)) RETURNING l_n4,l_ome59t 
         CALL p203_train3(5,g_ome[l_c].amh07) RETURNING l_n_amh07,l_amh07 
         IF (l_ome01 IS NULL) OR l_ome01 != g_ome[l_c].ome01 THEN
            #發票主檔
           #LET l_det="HI",l_n1 SPACES,g_ome[l_c].amh06,g_ome[l_c].oga01,l_n30 SPACES,g_ome[l_c].zo06,l_n_amh07,'xx',20 SPACES,'0' #Vivian Add  #FUN-C10032 mark
            LET l_det="HI",l_n1 SPACES,l_amh06,l_oga01,l_n30 SPACES,g_ome[l_c].zo06,l_n_amh07 SPACE,"00000000",'xx',20 SPACES,'0'   #FUN-C10032 add
            CALL lc_channe1.write(l_det)
            LET l_ome01 = g_ome[l_c].ome01
         END IF

         #發票明細
         CALL p203_train3(20,g_ome[l_c].oea10) RETURNING l_n5,l_oea10   
         CALL p203_train3(20,g_ome[l_c].ami04) RETURNING l_n6,l_ami04    
         CALL p203_train2(9,3,g_ome[l_c].ogb12) RETURNING l_n7,l_ogb12        
         CALL p203_train2(15,5,g_ome[l_c].ogb13) RETURNING l_n8,l_ogb13       
         CALL p203_train2(17,5,g_ome[l_c].oga50) RETURNING l_n9,l_oga50       
         CALL p203_train(6,g_ome[l_c].ome211) RETURNING l_n31,l_ome211
         LET l_det = NULL
        #LET l_det="D",l_n5 SPACES,g_ome[l_c].oea10,"2",l_n6 SPACES,g_ome[l_c].ami04,70 SPACES,l_n7 SPACES,l_ogb12  #Vivian Mark
        #LET l_det="DI",l_n1 SPACES,g_ome[l_c].amh06,g_ome[l_c].oga01,l_n30 SPACES,'0',g_ome[l_c].ome171,g_ome[l_c].ome02 USING 'YYYYMMDD',g_ome[l_c].ome01  #Vivian Add  #FUN-C10032 mark
         LET l_det="DI",l_n1 SPACES,l_amh06,l_oga01,l_n30 SPACES,'0',g_ome[l_c].ome171,g_ome[l_c].ome02 USING 'YYYYMMDD',g_ome[l_c].ome01 
        #LET l_det=l_det,g_ome[l_c].ome172,g_ome[l_c].ome59,g_ome[l_c].ome211,g_ome[l_c].ome59x,g_ome[l_c].ome59t,g_ome[l_c].ome02,'xxxxxxxxxxxxxxxxxxxx'
         LET l_det=l_det,g_ome[l_c].ome172,l_n2 SPACE,l_ome59,l_n31 SPACE ,l_ome211,l_n3 SPACE,l_ome59x,l_n4 SPACE,l_ome59t,g_ome[l_c].ome02 USING 'YYYY','xxxxxxxxxxxxxxxxxxxx'  
         CALL lc_channe1.write(l_det)


 #Vivian Start
         LET l_sql1 = "SELECT * FROM p203_tmp3 WHERE ome01 = '",g_ome[l_c].ome01,"'"
         PREPARE p203_tm3_pre FROM l_sql1
         DECLARE p203_tm3_cs SCROLL CURSOR FOR p203_tm3_pre
     
         FOREACH p203_tm3_cs INTO g_ome3[l_c].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('Foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF    
       
           CALL p203_train3(2,g_ome3[l_c].amh06)    RETURNING l_n10,l_amh06 
           CALL p203_train3(20,g_ome3[l_c].oga01)   RETURNING l_n11,l_oga01  
           CALL p203_train3(10,g_ome3[l_c].ome01)   RETURNING l_n12,l_ome01  
           CALL p203_train3(7,g_ome3[l_c].oea10)    RETURNING l_n13,l_oea10
           CALL p203_train3(6,g_ome3[l_c].ogb04)    RETURNING l_n14,l_ogb04  
           CALL p203_train2(10,3,g_ome3[l_c].ogb12) RETURNING l_n15,l_ogb12
           CALL p203_train2(10,2,g_ome3[l_c].ogb13) RETURNING l_n16,l_ogb13
           CALL p203_train3(1,g_ome3[l_c].ome172)   RETURNING l_n17,l_ome172 
           CALL p203_train2(12,2,g_ome3[l_c].ogb14) RETURNING l_n18,l_ogb14
           CALL p203_train3(33,g_ome3[l_c].ogb06)   RETURNING l_n19,l_ogb06  
           LET l_det = NULL  
           LET l_det = "OI",l_n10 SPACES,l_amh06,l_oga01,l_n11 SPACES,g_ome3[l_c].ome01,l_n12 SPACES,l_oea10,l_n13 SPACES 
           LET l_det = l_det,l_n14 SPACES,l_ogb04,l_n15 SPACES,l_ogb12,10 SPACES,l_n16 SPACES,l_ogb13,10 SPACES,l_n17 SPACES,l_ome172  
           LET l_det = l_det,l_n18 SPACES,l_ogb14,20 SPACES,10 SPACES,l_ogb06,l_n19 SPACES,'xxxxx'  
           
           CALL lc_channe1.write(l_det)
         END FOREACH
         #Vivian End  
         
         #Vivian Start
         LET l_sql1 = "SELECT * FROM p203_tmp2 WHERE ome01 = '",g_ome[l_c].ome01,"'"
         PREPARE p203_tm2_pre FROM l_sql1
         DECLARE p203_tm2_cs SCROLL CURSOR FOR p203_tm2_pre
     
         FOREACH p203_tm2_cs INTO g_ome2[l_c].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('Foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF    
           

           CALL p203_train3(2,g_ome2[l_c].amh06)    RETURNING l_n20,l_amh06  
           CALL p203_train3(20,g_ome2[l_c].oga01)   RETURNING l_n21,l_oga01  
           CALL p203_train3(20,g_ome2[l_c].ogb06)   RETURNING l_n22,l_ogb06  
           CALL p203_train(3,g_ome2[l_c].ogb03)     RETURNING l_n27,l_ogb03
           CALL p203_train2(10,3,g_ome2[l_c].ogb12) RETURNING l_n23,l_ogb12
           CALL p203_train2(10,2,g_ome2[l_c].ogb13) RETURNING l_n24,l_ogb13
           CALL p203_train3(1,g_ome2[l_c].ome172)   RETURNING l_n25,l_ome172  
           CALL p203_train2(12,2,g_ome2[l_c].ogb14) RETURNING l_n26,l_ogb14
           LET l_det = NULL
           LET l_det = "CI",l_n20 SPACES,l_amh06,l_oga01,l_n21 SPACES,l_n27 SPACES,l_ogb03,'贈品',16 SPACES,l_ogb06,l_n22 SPACES,g_ome2[l_c].ome01   
           LET l_det = l_det,l_n23 SPACES,l_ogb12,10 SPACES,l_n24 SPACES,l_ogb13,10 SPACES,l_n25 SPACES,l_ome172,'xxxxxxxxxx',10 SPACES  
           LET l_det = l_det,l_n26 SPACES,l_ogb14   
           
           CALL lc_channe1.write(l_det)
         END FOREACH
         #Vivian End    


         LET l_c = l_c + 1

       END FOREACH
     
       CALL g_ome.deleteElement(l_c)
       LET l_date = TODAY USING 'YYYYMMDD'
       LET l_date = "<",l_date CLIPPED,">"
       CALL lc_channe1.write(l_date)  
       CALL lc_channe1.close()
   END FOREACH
   LET l_txt = l_ome,".txt"
   IF ms_codeset = "UTF-8" THEN
      IF os.Path.separator()="/" THEN
         LET l_cmd = "iconv -f UTF-8 -t big5 ",l_ome," > ",l_txt
      ELSE
         LET l_cmd = "java -cp zhcode.jar zhcode -8b ",l_ome," > ",l_txt
      END IF
      RUN l_cmd
      LET l_cmd = "cp -f " || l_txt CLIPPED || " " || l_ome CLIPPED
      RUN l_cmd
   END IF
   LET unix_path = "$TEMPDIR/",l_ome
   LET window_path = "c:\\tiptop\\",l_ome
 
   LET status = cl_download_file(unix_path, window_path) 
   IF status then
      CALL cl_err(l_ome,"amd-020",1)
      DISPLAY "Download OK!!"
   ELSE
      CALL cl_err(l_ome,"amd-021",1)
      DISPLAY "Download fail!!"
   END IF
 
   LET l_cmd = "rm ",l_ome CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
   LET l_cmd = "rm ",l_txt CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
END FUNCTION

#數字轉文字
FUNCTION p203_train(l_n,p_str)
DEFINE l_n          LIKE type_file.num5
DEFINE p_str        STRING
DEFINE l_dot        STRING
DEFINE l_integer    STRING
DEFINE l_str        STRING
DEFINE l_a          LIKE type_file.num5
DEFINE l_b          LIKE type_file.num5
DEFINE l_fillin     STRING
DEFINE l_dot_length LIKE type_file.num5
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_length     LIKE type_file.num5
DEFINE l_length2    LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
 
    LET l_fillin = p_str
    LET l_length = l_fillin.getLength()   #總長度
    LET l_a = l_fillin.getIndexOf('.',1)  #小數點所在位置 
    LET l_dot = l_fillin.subString(l_a+1,l_length)   #小數值
    LET l_integer = l_fillin.subString(1,l_a-1)      #整數
    LET l_dot_length = l_dot.getLength()
    FOR l_cnt = l_dot_length TO 1 STEP -1
        LET l_b = l_dot.getIndexOf('0',l_cnt)
        IF l_b <> l_cnt THEN EXIT FOR END IF
    END FOR
    IF l_cnt = 0 THEN    #小數位數後沒有值,直接取整數就好
        LET l_fillin = l_integer
    ELSE
        LET l_dot = l_fillin.subString((l_a+1),(l_cnt+l_a))   #小數值
        LET l_fillin = l_integer.trim(),'.',l_dot.trim()
    END IF
    LET l_length2=l_fillin.getLength()
    LET l_sp = l_n - l_length2
    IF l_sp < 0 THEN LET l_sp = 0 END IF
    RETURN l_sp,l_fillin
END FUNCTION

#單身抓取金額
FUNCTION p203_train2(l_n,l_n2,p_str)
DEFINE l_n          LIKE type_file.num5
DEFINE l_n2         LIKE type_file.num5
DEFINE p_str        STRING
DEFINE l_dot        STRING
DEFINE l_integer    STRING
DEFINE l_a          LIKE type_file.num5
DEFINE l_fillin     STRING
DEFINE l_length     LIKE type_file.num5
DEFINE l_length2    LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
 
    LET l_fillin = p_str
    LET l_length = l_fillin.getLength()   #總長度
    LET l_a = l_fillin.getIndexOf('.',1)  #小數點所在位置 
    LET l_dot = l_fillin.subString(l_a+1,l_a+l_n2)   #小數值
    LET l_integer = l_fillin.subString(1,l_a-1)      #整數
    LET l_fillin = l_integer,".",l_dot
    LET l_length2=l_fillin.getLength()
    LET l_sp = l_n - l_length2
    IF l_sp < 0 THEN LET l_sp = 0 END IF
    RETURN l_sp,l_fillin
END FUNCTION

FUNCTION p203_train3(l_n,p_str)
DEFINE l_n          LIKE type_file.num5
DEFINE p_str        STRING
DEFINE l_length     LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
DEFINE l_str1       STRING 
DEFINE l_i          LIKE type_file.num5  
DEFINE l_n2         LIKE type_file.num5  
    LET l_length = p_str.getLength()   #總長度
    IF l_length > l_n THEN
       LET p_str = p_str.subString(1,l_n)
       LET l_length = l_n 
    END IF
    LET l_n2 = 0
    FOR l_i = 1 TO l_length
       LET l_str1 = p_str.subString(l_i,l_i)  
       IF NOT cl_null(p_str) AND cl_null(l_str1) THEN
          LET l_str1 = p_str.subString(l_i,l_i+2) 
          LET l_str1 = l_str1.trim()
          IF NOT cl_null(p_str) AND NOT cl_null(l_str1) AND l_str1.getLength() > 2 THEN
             LET l_i = l_i + 2 
             LET l_n2 = l_n2 +1
          END IF
       END IF
    END FOR
    LET l_length = l_length - l_n2
    IF l_n <= l_length THEN
       LET l_sp = 0
    ELSE
       LET l_sp = l_n - l_length
    END IF
    RETURN l_sp,p_str
END FUNCTION
#FUN-C10032
