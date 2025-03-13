# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdp202.4gl
# Descriptions...: 電子發票匯出作業-汎宇
# Date & Author..: 10/11/30 By sabrina
# Modify.........: No:FUN-AC0034 10/12/12 By sabrina create program
# Modify.........: No:TQC-AC0215 10/12/15 By sabrina ama01的錯誤訊息應該after field後顯示 
# Modify.........: No:TQC-AC0278 10/12/20 By sabrina 單頭金額不顯示小數位數 
# Modify.........: No:TQC-AC0344 10/12/23 By Summer 1.日期格式須為 YYYYMMDD 
#                                                   2.廠商編號 靠右前埔空白
#                                                   3.健康捐 前補空白 
#                                                   4.發票明細參考號碼 請靠右後補空白 
#                                                   5.數值位數有誤 
#                                                   6.明細類別 = DEFAULT '0'應該是o(英文) 
# Modify.........: No:TQC-AC0359 10/12/24 By sabrina 將檔案下載到C:\\tiptop目錄下 
# Modify.........: No:MOD-B10004 11/01/03 By sabrina 將UTF8轉成BIG5
# Modify.........: No:MOD-B10038 11/01/06 By sabrina 調整分店代號抓取原則 
# Modify.........: No:MOD-B10044 11/01/06 By sabrina 轉檔名稱YYYYMMDD改為YYMMDD 
# Modify.........: No:MOD-B30721 11/03/31 By Dido 作廢資料抓取改用 omee_file 
# Modify.........: No:MOD-B40053 11/04/14 By Dido 搭增條件邏輯調整;增加排序 

IMPORT os        #MOD-B10004 add
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
   OPEN WINDOW p202_w AT p_row,p_col
        WITH FORM "amd/42f/amdp202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    CALL cl_set_comp_entry('gln,ama01',FALSE) 
 

   WHILE TRUE
      LET g_success = 'Y'
      CALL p202_tm()
      CALL p202_cre_tmp()
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p202()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW p202_w 
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p202_tm()
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
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED
   IF cl_null(g_wc) THEN
      LET g_wc = '1=1'
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
 
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
 
     #TQC-AC0215---add---start---
      AFTER FIELD ama01
         IF s3 = '2' THEN
            IF cl_null(ama01) THEN
               CALL cl_err('','9046',1)
               NEXT FIELD ama01
            END IF
         END IF
     #TQC-AC0215---add---end---

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
 
   END INPUT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
END FUNCTION

FUNCTION p202_cre_tmp()

    CREATE TEMP TABLE p202_tmp(
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
                  occ74    LIKE occ_file.occ74)    #總店號
END FUNCTION

FUNCTION p202()
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
                  oma01    LIKE oma_file.oma01,    #帳款編號          #MOD-B30721 mod oga01 -> oma01 
                 #oga02    LIKE oga_file.oga02,    #出貨單日期        #MOD-B30721 mark 
                 #oga03    LIKE oga_file.oga03,    #客戶編號          #MOD-B30721 mark 
                  ome05    LIKE ome_file.ome05,    #發票別            
                  omevoid  LIKE ome_file.omevoid,  #作廢否            
                  omb04    LIKE omb_file.omb04,    #產品編號          #MOD-B30721 mod ogb04 -> omb04 
                  omb32    LIKE omb_file.omb32,    #出貨單項次        #MOD-B40053 
                 #ogb12    LIKE ogb_file.ogb12,    #數量              #MOD-B30721 mark
                 #ogb13    LIKE ogb_file.ogb13,    #單價              #MOD-B30721 mark
                 #ogb14    LIKE ogb_file.ogb14,    #未稅金額          #MOD-B30721 mark
                 #ogb05    LIKE ogb_file.ogb05,    #單位              #MOD-B30721 mark
                 #oea10    LIKE oea_file.oea10,    #買方訂單號碼      #MOD-B30721 mark
                 #ogb03    LIKE ogb_file.ogb03,    #出貨單單身項次    #MOD-B30721 mark 
                  occ74    LIKE occ_file.occ74,    #總店號
                 #oga50    LIKE oga_file.oga50,    #未稅金額          #MOD-B30721 mark 
                  oma04    LIKE oma_file.oma04,    #發票客戶          #MOD-B10038 add
                  ome043   LIKE ome_file.ome043,   #發票客戶全名      #MOD-B30721   
                  ome044   LIKE ome_file.ome044,   #發票客戶地址      #MOD-B30721
                  occ30    LIKE occ_file.occ30     #財務聯絡人        #MOD-B30721
                 END RECORD
  #-MOD-B30721-add-   
   DEFINE       l_oga01    LIKE oga_file.oga01,    #出貨單        
                l_oga02    LIKE oga_file.oga02,    #出貨單日期        
                l_oga03    LIKE oga_file.oga03,    #客戶編號          
                l_oga16    LIKE oga_file.oga16,    #訂單編號          
                l_ogb12    LIKE ogb_file.ogb12,    #數量             
                l_ogb13    LIKE ogb_file.ogb13,    #單價           
                l_ogb14    LIKE ogb_file.ogb14,    #未稅金額      
                l_ogb05    LIKE ogb_file.ogb05,    #單位            
                l_oea10    LIKE oea_file.oea10,    #買方訂單號碼   
               #l_oeb1003  LIKE oeb_file.oeb1003,  #作業方式      #MOD-B40053 mark 
                l_ogb1005  LIKE ogb_file.ogb1005,  #作業方式      #MOD-B40053
                l_ogb1012  LIKE ogb_file.ogb1012,  #搭贈          #MOD-B40053
                l_ogb32    LIKE ogb_file.ogb32,    #訂單單身項次 
                l_oga50    LIKE oga_file.oga50     #未稅金額      
  #-MOD-B30721-end-   

  #-MOD-B30721-mark-     
  #IF t2 = 'N' THEN    
  #   LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome042,ome60,ome59t,oga01,oga02,oga03,ome05,", 
  #               " omevoid,ogb04,ogb12,ogb13,ogb14,ogb05,oea10,ogb03,occ74,oga50,oma04 ",              #MOD-B10038 add oma04
  #               " FROM ome_file,ogb_file,occ_file,oga_file,oma_file,omee_file,oea_file,oeb_file ",
  #               " WHERE oga10=omee02 and oma10=ome01 and oma10=omee01 and oga10=oma01 ",
  #               "   AND oga01=ogb01 AND oga03=occ01 AND oea01=oeb01 AND oga16=oea01 ",
  #               "   AND omee01=ome01 ", 
  #               "   AND oeb04=ogb04 ",
  #               "   AND ome212='",s1,"'",
  #               "   AND ",g_wc CLIPPED
  #ELSE
  #   LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome042,ome60,ome59t,oga01,oga02,oga03,ome05,", 
  #               " omevoid,ogb04,ogb12,ogb13,ogb14,ogb05,oea10,ogb03,occ74,oga50,oma04 ",           #MOD-B10038 add oma04
  #               " ome043,ome044,occ30 ",
  #               " FROM ome_file,ogb_file,occ_file,oga_file,oma_file,omee_file,oea_file,oeb_file ",
  #               " WHERE oga10=omee02 and oma10=ome01 and oma10=omee01 and oga10=oma01 ",
  #               "   AND oga01=ogb01 AND oga03=occ01 AND oea01=oeb01 AND oga16=oea01 ",
  #               "   AND omee01=ome01 ", 
  #               "   AND oeb1003 = '2' ",
  #               "   AND oeb04=ogb04 ",
  #               "   AND ome212='",s1,"'",
  #               "   AND ",g_wc CLIPPED
  #END IF
  #-MOD-B30721-add- 
   LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome042,ome60,ome59t,oma01,ome05,", 
               " omevoid,omb04,omb32,occ74,oma04,ome043,ome044,occ30 ", #MOD-B40053 add omb32 
               " FROM omee_file,ome_file,occ_file,oma_file,omb_file ",
               " WHERE omee02 = oma01 ",
               "   AND omee01 = ome01 ",
               "   AND oma01 = omb01 ", 
               "   AND oma03 = occ01 ", 
               "   AND ome212 = '",s1,"' ",
               "   AND ",g_wc CLIPPED
  #-MOD-B30721-end-     
   IF t3 = 'N' THEN
      LET g_sql = g_sql," AND omevoid = 'N' "
   END IF
   LET g_sql = g_sql," ORDER BY ome01,omb01,omb03 "  #MOD-B40053
   PREPARE p202_pre FROM g_sql
   DECLARE p202_cs CURSOR FOR p202_pre

   DELETE FROM p202_tmp
   FOREACH p202_cs INTO sr.*
       
      SELECT zo06 INTO l_zo06 FROM zo_file WHERE zo01=g_lang
     #分店編號&廠商編號
      SELECT ima09,ima10,ima11,ima06,ima131 INTO l_ima09,l_ima10,l_ima11,l_ima06,l_ima131 
        FROM ima_file WHERE ima01 = sr.omb04       #MOD-B30721 mod ogb04 -> omb04
     #TQC-AC0344 add --start--
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
     #TQC-AC0344 add --end--
     #TQC-AC0344 mark --start--
     #If NOT cl_null(l_ima09) THEN
     #   LET l_amh02='D'
     #   LET l_amh05=l_ima09
     #ELSE
     #   IF NOT cl_null(l_ima10) THEN
     #      LET l_amh02 = 'E'
     #   LET l_amh05=l_ima10
     #   ELSE
     #      IF NOT cl_null(l_ima11) THEN
     #         LET l_amh02 = 'F'
     #         LET l_amh05=l_ima11
     #      ELSE
     #         IF NOT cl_null(l_ima06) THEN
     #            LET l_amh02 = 'M'
     #            LET l_amh05=l_ima06
     #         ELSE
     #            LET l_amh02 = 'P'
     #            LET l_amh05=l_ima131
     #         END IF
     #      END IF
     #   END IF
     #END IF
     #TQC-AC0344 mark --end--
     #SELECT amh06 INTO l_amh06,l_amh07 FROM amh_file #TQC-AC0344 mark
     #MOD-B10038---modify---start---
     #SELECT amh06,amh07 INTO l_amh06,l_amh07 FROM amh_file #TQC-AC0344
     # WHERE amh01 = sr.occ74 AND amh02 = l_amh02 AND amh04 = sr.oga03
     #   AND amh05 = l_amh05 
      SELECT amh06,amh07 INTO l_amh06,l_amh07 FROM amh_file 
       WHERE amh01 = sr.occ74 AND amh02 = l_amh02 AND amh04 = sr.oma04
         AND amh05 = l_amh05 
     #MOD-B10038---modify---end---
     #MOD-B10038---mark---start---
     #IF cl_null(l_amh06) THEN
     #   LET l_amh06 = '               '
     #END IF 
     #IF cl_null(l_amh07) THEN
     #   LET l_amh07 = '          '
     #END IF 
     #MOD-B10038---mark---end---
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

     #-MOD-B30721-add-
      LET l_cnt = 0
     #SELECT COUNT(*) INTO l_cnt #MOD-B40053 mark
     #  FROM oga_file            #MOD-B40053 mark
     # WHERE oga10 = sr.oma01    #MOD-B40053 mark
     #-MOD-B400053-add-
      LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oga_file'), 
                  "  WHERE oga10 = '",sr.oma01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE sel_oga_pre FROM g_sql
      EXECUTE sel_oga_pre INTO l_cnt 
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0 
      END IF
     #-MOD-B400053-end-
      IF l_cnt > 0 THEN
         LET g_sql = "SELECT oga01,oga02,oga03,oga16,oga50,ogb32,ogb05,ogb12,ogb13,ogb14,ogb1005,ogb1012 ",  #MOD-B40053 add ogb1005/ogb1012 
                     " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                              cl_get_target_table(g_plant_new,'ogb_file'),   
                     " WHERE oga10 = '",sr.oma01,"'",
                     "   AND oga01 = ogb01 ",
                     "   AND ogb03 = ",sr.omb32     #MOD-B40053
        #END IF                                     #MOD-B40053 mark
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE p202_oga_p FROM g_sql
         DECLARE p202_oga_c CURSOR FOR p202_oga_p
         FOREACH p202_oga_c INTO l_oga01,l_oga02,l_oga03,l_oga16,l_oga50,l_ogb32,l_ogb05,l_ogb12,l_ogb13,l_ogb14,l_ogb1005,l_ogb1012  #MOD-B40053 add ogb1005/ogb1012
           LET l_cnt = 0
          #-MOD-B40053-add-
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
          #-MOD-B40053-end-
           IF l_cnt > 0 THEN
             #-MOD-B40053-mark
             #SELECT oea10,oeb1003 INTO l_oea10,l_oeb1003 
             #  FROM oea_file,oeb_file
             # WHERE oea01 = l_oga16
             #   AND oea01 = oeb01
             #   AND oeb03 = l_ogb32 
             #IF t2 = 'N' AND l_oeb1003 = '2' THEN    
             #   CONTINUE FOREACH                 
             #END IF  
             #-MOD-B40053-add-
              LET l_oea10 = ''
              LET g_sql = " SELECT oea10 ",
                          "   FROM ",cl_get_target_table(g_plant_new,'oea_file'),
                          "  WHERE oea01 = '",l_oga16,"'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
              PREPARE sel_oea_p2 FROM g_sql
              EXECUTE sel_oea_p2 INTO l_oea10
             #-MOD-B40053-end-
           END IF
     #-MOD-B30721-end-
           #發票明細參考號碼
            SELECT ami04 INTO l_ami04 FROM ami_file,amj_file
             WHERE ami01 = l_oga03     #MOD-B30721 mod sr -> l_
               AND ami02 <= l_oga02    #MOD-B30721 mod sr -> l_ 
               AND ((l_oga02 < ami03) OR (ami03 IS NULL))             #MOD-B30721 mod sr -> l_
               AND amj05 = sr.omb04 AND amiacti = 'Y'                 #MOD-B30721 mod ogb04 -> omb04
               AND ami01 = amj01 AND ami02 = amj02 AND ami04 = amj04
            IF cl_null(l_ami04) THEN
               SELECT ami04 INTO l_ami04 FROM ami_file,amj_file
                WHERE ami01 = sr.occ74
                  AND ami02 <= l_oga02                                #MOD-B30721 mod sr -> l_
                  AND ((l_oga02 < ami03) OR (ami03 IS NULL))          #MOD-B30721 mod sr -> l_
                  AND amj05 = sr.omb04 AND amiacti = 'Y'              #MOD-B30721 mod ogb04 -> omb04
                  AND ami01 = amj01 AND ami02 = amj02 AND ami04 = amj04
            ELSE
               LET l_flag2 = 'Y'
            END IF   
            IF cl_null(l_ami04) THEN
               SELECT ima135 INTO l_ami04 FROM ima_file
                WHERE ima01 = sr.omb04                                #MOD-B30721 mod ogb04 -> omb04
            ELSE
               LET l_flag2 = 'Y'
            END IF
           #單價
            IF l_flag2 = 'Y' THEN
              #SELECT SUM(ogb16) INTO sum_ogb16 FROM ogb_file        #MOD-B40053 mark
              # WHERE ogb01 = l_oga01                                #MOD-B30721 mod sr -> l_ #MOD-B40053 mark
              #-MOD-B40053-add-
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
              #-MOD-B40053-end-
               LET l_ogb13 = l_oga50 / sum_ogb16                     #MOD-B30721 mod sr -> l_
            ELSE
               LET l_ogb13 = l_ogb13                           
            END IF
           #未稅金額
            IF l_flag2 = 'Y' THEN
               LET l_oga50 = l_oga50    #MOD-B30721 mod sr -> l_ 
            ELSE
               LET l_oga50 = l_ogb14    #MOD-B30721 mod sr -> l_
            END IF 
 
            INSERT INTO p202_tmp VALUES(sr.ome01,sr.ome172,sr.ome02,sr.ome59,sr.ome171,sr.ome59x,sr.ome042,
                                        sr.ome60,sr.ome59t,sr.ome05,l_ogb12,
                                        l_ogb13,l_oea10,l_amh06,l_amh07,l_oga50,l_ami04,sr.occ74) #MOD-B30721 mod sr -> l_
            IF SQLCA.SQLCODE THEN
               CALL cl_err3('ins','p202_tmp','','','',SQLCA.sqlcode,'',1) 
            END IF
         END FOREACH
     #-MOD-B30721-add-
      ELSE             #MOD-B40053  
         INSERT INTO p202_tmp VALUES(sr.ome01,sr.ome172,sr.ome02,sr.ome59,sr.ome171,sr.ome59x,sr.ome042,
                                     sr.ome60,sr.ome59t,sr.ome05,'',
                                     '','',l_amh06,l_amh07,'','',sr.occ74)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3('ins','p202_tmp','','','',SQLCA.sqlcode,'',1) 
         END IF
      END IF           #MOD-B40053 
     #-MOD-B30721-end-
   END FOREACH
   
   SELECT COUNT(*) INTO l_cnt FROM p202_tmp
   IF l_cnt = 0 THEN
      CALL cl_err('','axc-034',1)
      LET g_success = 'N'
   ELSE
      CALL p202_exp()
   END IF
END FUNCTION

FUNCTION p202_exp()

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
             occ74    LIKE occ_file.occ74     #總店號
       END RECORD
DEFINE l_tempdir   STRING
DEFINE l_ome       STRING
DEFINE l_txt       STRING           #MOD-B10004 add
DEFINE l_cmd       STRING
DEFINE l_det       STRING
DEFINE lc_channe1      base.Channel
DEFINE l_c         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_occ74     LIKE occ_file.occ74
DEFINE l_time      LIKE type_file.chr8
DEFINE l_zo06      LIKE zo_file.zo06
DEFINE l_ome01     LIKE ome_file.ome01
DEFINE l_ome59     STRING
DEFINE l_ome59x    STRING
DEFINE l_ome59t    STRING
DEFINE l_ogb12     STRING
DEFINE l_ogb13     STRING
DEFINE l_oga50     STRING
DEFINE l_n1,l_n2,l_n3  LIKE type_file.num5
DEFINE l_n4,l_n5,l_n6  LIKE type_file.num5
DEFINE l_n7,l_n8,l_n9  LIKE type_file.num5
DEFINE l_length    LIKE type_file.num5
DEFINE l_n_amh07   LIKE type_file.num5 #TQC-AC0344 add
DEFINE unix_path   STRING              #TQC-AC0359 add
DEFINE window_path STRING              #TQC-AC0359 add
DEFINE ms_codeset  STRING              #MOD-B10004 add

  LET l_sql = "SELECT DISTINCT occ74 FROM p202_tmp ORDER BY occ74"
  PREPARE p202_occ74_pre FROM l_sql
  DECLARE p202_occ74_cs SCROLL CURSOR FOR p202_occ74_pre
  FOREACH p202_occ74_cs INTO l_occ74
       LET l_c = 1
       LET l_tempdir = FGL_GETENV('TEMPDIR')
       LET l_time = TIME(CURRENT)
       LET l_time = cl_replace_str(l_time,":","")
       SELECT zo06 INTO l_zo06 FROM zo_file where zo01=g_lang
      #LET l_ome = "UP-INV-",l_zo06,"-",TODAY USING 'YYYYMMDD',l_time,".txt"         #TQC-AC0359 modify   #MOD-B10044 mark
       LET l_ome = "UP-INV-",l_zo06,"-",TODAY USING 'YYMMDD',l_time,".txt"                                #MOD-B10044 add 
       LET l_cmd = "cat  /dev/null > ",l_tempdir CLIPPED,"/",l_ome CLIPPED           #TQC-AC0359 modify
       DISPLAY "l_cmd:",l_cmd
       DISPLAY "l_ome:",l_ome
       RUN l_cmd
       LET lc_channe1 = base.Channel.create()
       CALL lc_channe1.openFile(l_ome,"w")
       CALL lc_channe1.setDelimiter("")        #110110
     
       CALL g_ome.clear()
    
       LET ms_codeset = cl_get_codeset()       #MOD-B10004 add
     
       LET l_sql = "SELECT * FROM p202_tmp WHERE occ74 = '",l_occ74,"'"
       PREPARE p202_tm_pre FROM l_sql
       DECLARE p202_tm_cs SCROLL CURSOR FOR p202_tm_pre
     
       FOREACH p202_tm_cs INTO g_ome[l_c].*
     
         IF SQLCA.sqlcode THEN
             CALL cl_err('Foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
        #TQC-AC0278---add---start---
         CALL p202_train3(15,g_ome[l_c].amh06) RETURNING l_n1
         CALL p202_train(10,g_ome[l_c].ome59) RETURNING l_n2,l_ome59            
         CALL p202_train(9,g_ome[l_c].ome59x) RETURNING l_n3,l_ome59x           
         CALL p202_train(11,g_ome[l_c].ome59t) RETURNING l_n4,l_ome59t          
         CALL p202_train3(10,g_ome[l_c].amh07) RETURNING l_n_amh07 #TQC-AC0344 add 
         IF (l_ome01 IS NULL) OR l_ome01 != g_ome[l_c].ome01 THEN
            #發票主檔
           #LET l_det="H",l_n1 SPACES,g_ome[l_c].amh06,g_ome[l_c].ome01,g_ome[l_c].ome02,g_ome[l_c].ome171,20 SPACES,g_ome[l_c].ome172 #TQC-AC0344 mark
            LET l_det="H",l_n1 SPACES,g_ome[l_c].amh06,g_ome[l_c].ome01,g_ome[l_c].ome02 USING 'YYYYMMDD',g_ome[l_c].ome171,20 SPACES,g_ome[l_c].ome172 #TQC-AC0344
            LET l_det=l_det,l_n2 SPACES,l_ome59,l_n3 SPACES,l_ome59x,l_n4 SPACES,l_ome59t,g_ome[l_c].ome05
           #LET l_det=l_det,g_ome[l_c].ome60,g_ome[l_c].ome042,g_ome[l_c].amh07,"0",50 SPACES #TQC-AC0344 mark
            LET l_det=l_det,g_ome[l_c].ome60,g_ome[l_c].ome042,l_n_amh07 SPACES,g_ome[l_c].amh07,9 SPACES,"0",50 SPACES #TQC-AC0344
        #TQC-AC0278---add---end---
            CALL lc_channe1.write(l_det)
            LET l_ome01 = g_ome[l_c].ome01
         END IF

         #發票明細
        #TQC-AC0278---add---start---
         CALL p202_train3(20,g_ome[l_c].oea10) RETURNING l_n5
         CALL p202_train3(20,g_ome[l_c].ami04) RETURNING l_n6
         CALL p202_train2(9,3,g_ome[l_c].ogb12) RETURNING l_n7,l_ogb12        
        #TQC-AC0344 mod --start--
        #CALL p202_train2(14,5,g_ome[l_c].ogb13) RETURNING l_n8,l_ogb13       
        #CALL p202_train2(14,5,g_ome[l_c].oga50) RETURNING l_n9,l_oga50       
         CALL p202_train2(15,5,g_ome[l_c].ogb13) RETURNING l_n8,l_ogb13       
         CALL p202_train2(17,5,g_ome[l_c].oga50) RETURNING l_n9,l_oga50       
        #TQC-AC0344 mod --end--
         LET l_det = NULL
         LET l_det="D",l_n5 SPACES,g_ome[l_c].oea10,"2",l_n6 SPACES,g_ome[l_c].ami04,70 SPACES,l_n7 SPACES,l_ogb12
        #LET l_det=l_det,4 SPACES,"0.000",l_n8 SPACES,l_ogb13,7 SPACES,"0.00000",l_n9 SPACES,l_oga50,"0" #TQC-AC0344 mark
         LET l_det=l_det,6 SPACES,"0.000",l_n8 SPACES,l_ogb13,7 SPACES,"0.00000",l_n9 SPACES,l_oga50,"O" #TQC-AC0344
         LET l_det=l_det,20 SPACES,30 SPACES
        #TQC-AC0278---add---end---
         CALL lc_channe1.write(l_det)

         LET l_c = l_c + 1
       END FOREACH
     
       CALL g_ome.deleteElement(l_c)
       CALL lc_channe1.close()
   END FOREACH
  #MOD-B10004---add---start---
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
  #MOD-B10004---add---end---
  #TQC-AC0359---add---start---
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
  #MOD-B10004---add---start---
   LET l_cmd = "rm ",l_txt CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
  #MOD-B10004---add---end---
  #TQC-AC0359---add---end---
END FUNCTION

#數字轉文字
FUNCTION p202_train(l_n,p_str)
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

#TQC-AC0278---add---start---
#單身抓取金額
FUNCTION p202_train2(l_n,l_n2,p_str)
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

FUNCTION p202_train3(l_n,p_str)
DEFINE l_n          LIKE type_file.num5
DEFINE p_str        STRING
DEFINE l_length     LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
 
    LET l_length = p_str.getLength()   #總長度
    IF l_n <= l_length THEN
       LET l_sp = 0
    ELSE
       LET l_sp = l_n - l_length
    END IF
    RETURN l_sp
END FUNCTION
#TQC-AC0278---add---start---
#FUN-AC0034
