# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: amdp200.4gl
# Descriptions...: 電子發票匯出作業-金財通
# Date & Author..: 10/11/30 By sabrina
# Modify.........: No:FUN-AC0008 10/11/30 By sabrina create program
# Modify.........: No:TQC-AC0086 10/12/08 By sabrina 過單 
# Modify.........: No:TQC-AC0215 10/12/15 By sabrina 體系別移除家樂福及供應商GLN 
# Modify.........: No:TQC-AC0278 10/12/20 By sabrina 單身明細最後不需要逗號 
# Modify.........: No:TQC-AC0343 10/12/23 By Summer 1.日期格式須為 YYYYMMDD 
#                                                   2.利率格式為小數位數 
#                                                   3.須新增體系:新東陽 比照 捷盟 
#                                                   4.單價2、金額2  應該 DEFAULT 0 
#                                                   5.賣方廠編設定於amdi200但是取值應該判斷amdi200中是何種設定 
# Modify.........: No:TQC-AC0359 10/12/24 By sabrina 將檔案下載到C:\\tiptop目錄下 
# Modify.........: No:MOD-B10002 11/01/03 By sabrina 將UTF8轉成BIG5

IMPORT os         #MOD-B10002
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql STRING
DEFINE g_before_input_done    STRING
DEFINE g_err_cnt LIKE type_file.num10 
DEFINE s1,s2,s3,t1,t2 LIKE type_file.chr1
#DEFINE gln    LIKE type_file.chr10         #TQC-AC0215 mark
DEFINE ama01  LIKE ama_file.ama01
DEFINE g_wc  STRING
DEFINE l_flag LIKE type_file.chr1

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
   OPEN WINDOW p200_w AT p_row,p_col
        WITH FORM "amd/42f/amdp200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
   #CALL cl_set_comp_entry('gln,ama01',FALSE)       #TQC-AC0215 mark   
    CALL cl_set_comp_entry('ama01',FALSE)           #TQC-AC0215 add 
 

   WHILE TRUE
      LET g_success = 'Y'
      CALL p200_tm()
      CALL p200_cre_tmp()
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p200()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW p200_w 
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p200_tm()
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
   LET s2 = '1'     #TQC-AC0215 add

   INPUT BY NAME
     #s1,s2,gln,t1,t2,s3,ama01        #TQC-AC0215 mark
      s1,s2,t1,t2,s3,ama01            #TQC-AC0215 add
      WITHOUT DEFAULTS
 
      BEFORE INPUT
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
 

     #TQC-AC0215---mark---start---
     #AFTER FIELD s2 
     #   IF s2 = '1' THEN
     #      CALL cl_set_comp_entry('gln',TRUE)
     #   ELSE
     #      CALL cl_set_comp_entry('gln',FALSE) 
     #   END IF 
     #TQC-AC0215---mark---end---

      AFTER FIELD s3 
         IF s3 = '2' THEN
            CALL cl_set_comp_entry('ama01',TRUE)
         ELSE
            CALL cl_set_comp_entry('ama01',FALSE) 
         END IF 
 
     #TQC-AC0215---add---start---
      AFTER FIELD ama01
         IF s3='2' THEN
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

FUNCTION p200_cre_tmp()

    CREATE TEMP TABLE p200_tmp(
                  ome01    LIKE ome_file.ome01,    #發票號碼
                  ome172   LIKE ome_file.ome172,   #稅率別
                  ome02    LIKE ome_file.ome02,    #發票日期
                  omechk   LIKE ome_file.ome05,    #發票檢查碼
                  ome59    LIKE ome_file.ome59,    #發票金額
                  ome171   LIKE ome_file.ome171,   #發票格式
                  ome59x   LIKE ome_file.ome59x,   #發票稅額
                  ome04    LIKE ome_file.ome04,    #發票客戶編號    
                  ome042   LIKE ome_file.ome042,   #買方統編
                  occ75    LIKE occ_file.occ75,    #買方廠編
                  ome60    LIKE ome_file.ome60,    #申報統編
                  amg03    LIKE amg_file.amg03,    #賣方廠編
                  ome211   LIKE ome_file.ome211,   #稅率
                  ome59t   LIKE ome_file.ome59t,   #含稅金額
                  oga01    LIKE oga_file.oga01,    #出貨單單號
                  aa       LIKE ome_file.ome05,    #通關方式註記
                  ome05    LIKE ome_file.ome05,    #發票別
                  ogb04    LIKE gaz_file.gaz03,    #產品編號品名規格
                  ogb12    LIKE ogb_file.ogb12,    #數量
                  ogb13    LIKE ogb_file.ogb13,    #單價
                  ogb14    LIKE ogb_file.ogb14,    #未稅金額
                  ogb05    LIKE ogb_file.ogb05,    #單位
                  oea10    LIKE oea_file.oea10,    #買方訂單號碼
                  ogb11    LIKE ogb_file.ogb11,    #買方商品編碼
                  oao06    LIKE oao_file.oao06,    #備註
                  ogb03    LIKE ogb_file.ogb03,    #出貨單單身項次
                  occ74    LIKE occ_file.occ74)    #總店號
END FUNCTION

FUNCTION p200()
   DEFINE l_zo06     LIKE zo_file.zo06        #賣方統編
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_amg03    LIKE amg_file.amg03      #賣方廠編
   DEFINE l_ome_chk    LIKE type_file.chr1      #發票檢查碼
   DEFINE l_occ75    LIKE occ_file.occ75      #買方廠編代號
   DEFINE l_aa       LIKE type_file.chr1      #通關方式註記
   DEFINE l_ogb04    LIKE gaz_file.gaz03      #產品編號品名
   DEFINE l_ima021   LIKE ima_file.ima021     #規格
   DEFINE l_oao06    LIKE oao_file.oao06      #單一備註欄
   DEFINE l_ima09    LIKE ima_file.ima09
   DEFINE l_ima10    LIKE ima_file.ima10
   DEFINE l_ima11    LIKE ima_file.ima11
   DEFINE l_ima06    LIKE ima_file.ima06
   DEFINE l_ima131   LIKE ima_file.ima131
   DEFINE l_amg01    LIKE amg_file.amg01
   DEFINE l_amg02    LIKE amg_file.amg02
   DEFINE sr     RECORD
                  ome01    LIKE ome_file.ome01,    #發票號碼
                  ome172   LIKE ome_file.ome172,   #稅率別
                  ome02    LIKE ome_file.ome02,    #發票日期
                  ome59    LIKE ome_file.ome59,    #發票金額
                  ome171   LIKE ome_file.ome171,   #發票格式
                  ome59x   LIKE ome_file.ome59x,   #發票稅額
                  ome04    LIKE ome_file.ome04,    #發票客戶編號    
                  ome042   LIKE ome_file.ome042,   #買方統編
                  ome60    LIKE ome_file.ome60,    #申報統編
                  ome211   LIKE ome_file.ome211,   #稅率
                  ome59t   LIKE ome_file.ome59t,   #含稅金額
                  oga01    LIKE oga_file.oga01,    #出貨單單號
                  ome05    LIKE ome_file.ome05,    #發票別
                  oma36    LIKE oma_file.oma36,    #非經海關證明文件名稱 
                  oma37    LIKE oma_file.oma37,    #非經海關證明文件號碼
                  oma38    LIKE oma_file.oma38,    #出口報單類別
                  oma39    LIKE oma_file.oma39,    #出口報單號碼
                  omevoid  LIKE ome_file.omevoid,  #作廢否
                  ogb04    LIKE ogb_file.ogb04,    #產品編號
                  ogb06    LIKE ogb_file.ogb06,    #品名
                  ogb12    LIKE ogb_file.ogb12,    #數量
                  ogb13    LIKE ogb_file.ogb13,    #單價
                  ogb14    LIKE ogb_file.ogb14,    #未稅金額
                  ogb05    LIKE ogb_file.ogb05,    #單位
                  oea10    LIKE oea_file.oea10,    #買方訂單號碼
                  ogb11    LIKE ogb_file.ogb11,    #買方商品編碼
                  ogb03    LIKE ogb_file.ogb03,    #出貨單單身項次
                  occ74    LIKE occ_file.occ74     #總店號
                 END RECORD
          
      IF t2 = 'N' THEN
         LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome04,ome042,ome60,ome211,ome59t,oga01,ome05,oma36,oma37,", 
                     " oma38,oma39,omevoid,ogb04,ogb06,ogb12,ogb13,ogb14,ogb05,oea10,ogb11,ogb03,occ74 ", 
                     " FROM ome_file,ogb_file,occ_file,oga_file,oma_file,omee_file,oea_file,oeb_file ",
                     " WHERE oga10=omee02 and oma10=ome01 and oma10=omee01 and oga10=oma01 ",
                     "   AND oga01=ogb01 AND oga03=occ01 AND oea01=oeb01 AND oga16=oea01 ",
                     "   AND omee01=ome01 ", 
                     "   AND oeb04=ogb04 ",
                     "   AND ome212='",s1,"'",
                     "   AND ",g_wc CLIPPED
      ELSE
         LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome04,ome042,ome60,ome211,ome59t,oga01,ome05,oma36,oma37,", 
                     " oma38,oma39,omevoid,ogb04,ogb06,ogb12,ogb13,ogb14,ogb05,oea10,ogb11,ogb03,occ74 ", 
                     " FROM ome_file,ogb_file,occ_file,oga_file,oma_file,omee_file,oea_file,oeb_file ",
                     " WHERE oga10=omee02 and oma10=ome01 and oma10=omee01 and oga10=oma01 ",
                     "   AND oga01=ogb01 AND oga03=occ01 AND oea01=oeb01 AND oga16=oea01 ",
                     "   AND omee01=ome01 ", 
                     "   AND oeb04=ogb04 ",
                    #"   AND oeb1003 = '2' ",         #TQC-AC0278 mark   
                     "   AND ogb1005 = '2' ",         #TQC-AC0278 add 
                     "   AND ome212='",s1,"'",
                     "   AND ",g_wc CLIPPED
      END IF
      PREPARE p200_pre FROM g_sql
      DECLARE p200_cs CURSOR FOR p200_pre

      #TQC-AC0343 add --start--
      LET l_cnt = 0 
      SELECT COUNT (DISTINCT amg01) INTO l_cnt FROM amg_file
      IF l_cnt > 1 THEN CALL cl_err('','amd-033',1) END IF
      #TQC-AC0343 add --end--

      DELETE FROM p200_tmp
      FOREACH p200_cs INTO sr.*

            CALL p200_chk_inv(sr.ome01)  RETURNING l_ome_chk 
           
           #買方統一編號
            IF NOT cl_null(sr.ome042) THEN
               LET sr.ome042=sr.ome042
            ELSE
               LET sr.ome042 ='0000000000'
            END IF
        　 #買方廠編代號
           #IF s2='2' THEN      #TQC-AC0215 mark
            SELECT occ75 INTO l_occ75 FROM occ_file
             WHERE occ01 = sr.ome04
           #TQC-AC0215---mark---start---
           #ELSE
           #   LET l_occ75 = sr.ome042 
           #END IF
           #TQC-AC0215---mark---end---
           #賣方統一編號
            IF s3='1' THEN
               SELECT zo06 INTO sr.ome60 FROM zo_file
                WHERE zo01=g_lang 
            ELSE
               LET sr.ome60 = sr.ome60
            END IF
           #賣方廠編代號
           #TQC-AC0215---mark---start---
           #IF s2='1' THEN
           #   LET l_amg03 = gln
           #ELSE
           #TQC-AC0215---mark---end---
            SELECT ima09,ima10,ima11,ima06,ima131 INTO l_ima09,l_ima10,l_ima11,l_ima06,l_ima131 
              FROM ima_file WHERE ima01 = sr.ogb04 
           #TQC-AC0343 add --start--
            SELECT amg01 INTO l_amg01 FROM amg_file
            IF l_amg01='D' THEN 
               LET l_amg02 = l_ima09
            ELSE
               IF l_amg01='E' THEN 
                  LET l_amg02 = l_ima10
               ELSE 
                  IF l_amg01='F' THEN 
                     LET l_amg02 = l_ima11
                  ELSE 
                     IF l_amg01 = 'M' THEN 
                        LET l_amg02 = l_ima06
                     ELSE
                        IF l_amg01 = 'P' THEN 
                           LET l_amg02 = l_ima131
                        END IF
                     END IF
                  END IF
                END IF
             END IF 
           #TQC-AC0343 add --end--
           #TQC-AC0343 mark --start--
           #If NOT cl_null(l_ima09) THEN
           #   LET l_amg01='D'
           #   LET l_amg02=l_ima09
           #ELSE
           #   IF NOT cl_null(l_ima10) THEN
           #      LET l_amg01 = 'E'
           #   LET l_amg02=l_ima10
           #   ELSE
           #      IF NOT cl_null(l_ima11) THEN
           #         LET l_amg01 = 'F'
           #         LET l_amg02=l_ima11
           #      ELSE
           #         IF NOT cl_null(l_ima06) THEN
           #            LET l_amg01 = 'M'
           #            LET l_amg02=l_ima06
           #         ELSE
           #            LET l_amg01 = 'P'
           #            LET l_amg02=l_ima131
           #         END IF
           #      END IF
           #   END IF
           #END IF
           #TQC-AC0343 mark --end--
            SELECT amg03 INTO l_amg03 FROM amg_file
             WHERE amg01 = l_amg01 AND amg02 = l_amg02 
           #END IF      #TQC-AC0215 mark
           #TQC-AC0343 add --start--
           IF sr.ome211 != 0 THEN
              LET sr.ome211 = sr.ome211 / 100
           END IF
           #TQC-AC0343 add --end--
           #通關方式註記
            IF (NOT cl_null(sr.oma38) OR NOT cl_null(sr.oma39)) AND sr.ome172 = '2' THEN
               LET l_aa = '2'
            END IF
            IF (NOT cl_null(sr.oma36) OR NOT cl_null(sr.oma37)) AND sr.ome172 = '2' THEN
               LET l_aa = '1'
            END IF
           #發票別
            IF sr.omevoid= 'Y' THEN
               LET sr.ome05 ='C'
            ELSE
               LET sr.ome05 = 'O'
            END IF  
           #印規格否
            IF t1 = 'Y' THEN
               SELECT ima021 INTO l_ima021 FROM ima_file
                WHERE ima01 = sr.ogb04
               LET l_ogb04 = sr.ogb04 CLIPPED,sr.ogb06 CLIPPED,l_ima021 CLIPPED
            ELSE
               LET l_ogb04 = sr.ogb04 CLIPPED,sr.ogb06 CLIPPED
            END IF  
           #單一備註欄
            SELECT oao06 INTO l_oao06 FROM oao_file
            WHERE oao01 = sr.oga01 AND oao03 = sr.ogb03 AND oao04 ='1' AND oao05='2' 
            INSERT INTO p200_tmp VALUES(sr.ome01,sr.ome172,sr.ome02,l_ome_chk,sr.ome59,sr.ome171,sr.ome59x,sr.ome04,sr.ome042,
                                        l_occ75,sr.ome60,l_amg03,sr.ome211,sr.ome59t,sr.oga01,l_aa,sr.ome05,l_ogb04,sr.ogb12,
                                        sr.ogb13,sr.ogb14,sr.ogb05,sr.oea10,sr.ogb11,l_oao06,sr.ogb03,sr.occ74)
      END FOREACH
      
      SELECT COUNT(*) INTO l_cnt FROM p200_tmp
      IF l_cnt = 0 THEN
         CALL cl_err('','axc-034',1)
         LET g_success = 'N'
      ELSE
         CALL p200_exp()
      END IF
END FUNCTION

FUNCTION p200_exp()

DEFINE g_ome DYNAMIC ARRAY OF RECORD
           ome01    LIKE ome_file.ome01,    #發票號碼
           ome172   LIKE ome_file.ome172,   #稅率別
           ome02    LIKE ome_file.ome02,    #發票日期
           omechk   LIKE ome_file.ome05,    #發票檢查碼
           ome59    LIKE ome_file.ome59,    #發票金額
           ome171   LIKE ome_file.ome171,   #發票格式
           ome59x   LIKE ome_file.ome59x,   #發票稅額
           ome04    LIKE ome_file.ome04,    #發票客戶編號    
           ome042   LIKE ome_file.ome042,   #買方統編
           occ75    LIKE occ_file.occ75,    #買方廠編
           ome60    LIKE ome_file.ome60,    #申報統編
           amg03    LIKE amg_file.amg03,    #賣方廠編
           ome211   LIKE ome_file.ome211,   #稅率
           ome59t   LIKE ome_file.ome59t,   #含稅金額
           oga01    LIKE oga_file.oga01,    #出貨單單號
           aa       LIKE ome_file.ome05,    #通關方式註記
           ome05    LIKE ome_file.ome05,    #發票別
           ogb04    LIKE gaz_file.gaz03,    #產品編號品名規格
           ogb12    LIKE ogb_file.ogb12,    #數量
           ogb13    LIKE ogb_file.ogb13,    #單價
           ogb14    LIKE ogb_file.ogb14,    #未稅金額
           ogb05    LIKE ogb_file.ogb05,    #單位
           oea10    LIKE oea_file.oea10,    #買方訂單號碼
           ogb11    LIKE ogb_file.ogb11,    #買方商品編碼
           oao06    LIKE oao_file.oao06,    #備註
           ogb03    LIKE ogb_file.ogb03,    #出貨單單身項次
           occ74    LIKE occ_file.occ74     #總店號
       END RECORD
DEFINE l_tempdir   STRING
DEFINE l_ome       STRING
DEFINE l_ome2      STRING
DEFINE l_ome3      STRING
DEFINE l_txt       STRING             #MOD-B10002 add
DEFINE l_txt2      STRING             #MOD-B10002 add
DEFINE l_cmd       STRING
DEFINE l_cmd2      STRING
DEFINE l_cmd3      STRING
DEFINE l_det       STRING
DEFINE l_det2      STRING
DEFINE l_det3      STRING
DEFINE lc_channe1      base.Channel
DEFINE lc_channe2      base.Channel
DEFINE lc_channe3      base.Channel
DEFINE l_c         LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_ome59     STRING
DEFINE l_ome59x    STRING
DEFINE l_ome59t    STRING
DEFINE l_ome211    STRING
DEFINE l_occ74     LIKE occ_file.occ74
DEFINE l_zo06      LIKE zo_file.zo06
DEFINE l_time      LIKE type_file.chr8
DEFINE l_ogb03     STRING
DEFINE l_ogb12     STRING 
DEFINE l_ogb13     STRING 
DEFINE l_ogb14     STRING 
DEFINE l_ze03      LIKE ze_file.ze03
DEFINE l_gaq03     LIKE gaq_file.gaq03
DEFINE l_oga01     LIKE oga_file.oga01
DEFINE unix_path   STRING            #TQC-AC0359 add
DEFINE window_path STRING            #TQC-AC0359 add
DEFINE ms_codeset  STRING            #MOD-B10002 add


  LET l_sql = "SELECT DISTINCT occ74 FROM p200_tmp ORDER BY occ74"
  PREPARE p200_occ74_pre FROM l_sql
  DECLARE p200_occ74_cs SCROLL CURSOR FOR p200_occ74_pre
  FOREACH p200_occ74_cs INTO l_occ74
       LET l_n = 1
       LET l_c = 1
       LET l_tempdir = FGL_GETENV('TEMPDIR')
       LET l_time = TIME(CURRENT)
       LET l_time = cl_replace_str(l_time,":","")
       IF s3 = '1' THEN
          LET l_zo06 = NULL
          SELECT zo06 INTO l_zo06 FROM zo_file where zo01=g_lang
          LET l_ome = l_zo06,"-main-",TODAY USING 'YYYYMMDD',"-",l_time,".txt"             #TQC-AC0359 modify    
          LET l_ome2 = l_zo06,"-detail-",TODAY USING 'YYYYMMDD',"-",l_time,".txt"          #TQC-AC0359 modify       
       ELSE
          LET l_ome = ama01,"-main-",TODAY USING 'YYYYMMDD',"-",l_time,".txt"              #TQC-AC0359 modify        
          LET l_ome2 = ama01,"-detail-",TODAY USING 'YYYYMMDD',"-",l_time,".txt"           #TQC-AC0359 modify            
       END IF
       LET l_cmd = "cat  /dev/null > ",l_tempdir CLIPPED,"/",l_ome CLIPPED                 #TQC-AC0359 modify        
       DISPLAY "l_cmd:",l_cmd
       DISPLAY "l_ome:",l_ome
       RUN l_cmd
       LET lc_channe1 = base.Channel.create()
       CALL lc_channe1.openFile(l_ome,"w")
       LET l_cmd2 = "cat  /dev/null > ",l_tempdir CLIPPED,"/",l_ome2 CLIPPED              #TQC-AC0359 modify
       DISPLAY "l_cmd2:",l_cmd2
       DISPLAY "l_ome2:",l_ome2
       RUN l_cmd2
       LET lc_channe2 = base.Channel.create()
       CALL lc_channe2.openFile(l_ome2,"w")
     
       CALL g_ome.clear()
     
       LET ms_codeset = cl_get_codeset()        #MOD-B10002 add

       LET l_sql = "SELECT * FROM p200_tmp WHERE occ74 = '",l_occ74,"'"
       PREPARE p200_tm_pre FROM l_sql
       DECLARE p200_tm_cs SCROLL CURSOR FOR p200_tm_pre
     
       FOREACH p200_tm_cs INTO g_ome[l_c].*
     
         IF SQLCA.sqlcode THEN
             CALL cl_err('Foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF

         #Error.txt
         IF l_n = 1 THEN
            IF cl_null(g_ome[l_c].occ75) OR cl_null(g_ome[l_c].amg03) OR cl_null(g_ome[l_c].ogb11) THEN
               IF s3 = '1' THEN
                  LET l_ome3 = l_zo06,"-error-",TODAY USING 'YYYYMMDD',"-",l_time,".txt"                 #TQC-AC0359 modify   
               ELSE 
                  LET l_ome3 = ama01,"-error-",TODAY USING 'YYYYMMDD',"-",l_time,".txt"                  #TQC-AC0359 modify     
               END IF
               LET l_cmd3 = "cat  /dev/null > ",l_tempdir CLIPPED,"/",l_ome3 CLIPPED                     #TQC-AC0359 modify       
               DISPLAY "l_cmd3:",l_cmd3
               DISPLAY "l_ome3:",l_ome3
               RUN l_cmd3
               LET lc_channe3 = base.Channel.create()
               CALL lc_channe3.openFile(l_ome3,"w")
               SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='anm-313' AND ze02=g_lang
               LET l_n = 2
            END IF 
         END IF 

         #發票主檔
         IF cl_null(l_oga01) OR l_oga01 != g_ome[l_c].oga01 THEN
            CALL p200_train(g_ome[l_c].ome59)  RETURNING l_ome59
            CALL p200_train(g_ome[l_c].ome59x)  RETURNING l_ome59x
           #CALL p200_train(g_ome[l_c].ome211)  RETURNING l_ome211 #TQC-AC0343 mark
            #TQC-AC0343 add --start--
            LET l_ome211 = g_ome[l_c].ome211 
            LET l_ome211 = l_ome211.trimLeft()
            #TQC-AC0343 add --end--
            CALL p200_train(g_ome[l_c].ome59t)  RETURNING l_ome59t
           #LET l_det=g_ome[l_c].ome01 CLIPPED,",",g_ome[l_c].ome172 CLIPPED,",",g_ome[l_c].ome02 CLIPPED,"," #TQC-AC0343 mark 
            LET l_det=g_ome[l_c].ome01 CLIPPED,",",g_ome[l_c].ome172 CLIPPED,",",g_ome[l_c].ome02 CLIPPED USING 'YYYYMMDD',"," #TQC-AC0343
            LET l_det=l_det,g_ome[l_c].omechk CLIPPED,",",l_ome59 CLIPPED,",",g_ome[l_c].ome171 CLIPPED,"," 
            LET l_det=l_det,l_ome59x CLIPPED,",0,",g_ome[l_c].ome042 CLIPPED,",",g_ome[l_c].occ75,"," 
            LET l_det=l_det,g_ome[l_c].ome60 CLIPPED,",",g_ome[l_c].amg03 CLIPPED,"," 
            LET l_det=l_det,l_ome211 CLIPPED,",",l_ome59t CLIPPED,",0,1,NTD,0,,1,"  
            LET l_det=l_det,g_ome[l_c].oga01 CLIPPED,",",g_ome[l_c].aa,",,,"
            LET l_det=l_det,g_ome[l_c].ome05 CLIPPED,",,,,,,"
            CALL lc_channe1.write(l_det)
            IF cl_null(g_ome[l_c].occ75) THEN
               SELECT gaq03 INTO l_gaq03 FROM gaq_file WHERE gaq01='occ75' AND gaq02=g_lang
               LET l_det3 = g_ome[l_c].ome01," ",g_ome[l_c].oga01," ",l_gaq03 CLIPPED,l_ze03
               CALL lc_channe3.write(l_det3)
            END IF
            IF cl_null(g_ome[l_c].amg03) THEN
               SELECT gaq03 INTO l_gaq03 FROM gaq_file WHERE gaq01='amg03' AND gaq02=g_lang
               LET l_det3 = g_ome[l_c].ome01," ",g_ome[l_c].oga01," ",l_gaq03 CLIPPED,l_ze03
               CALL lc_channe3.write(l_det3)
            END IF
            LET l_oga01 = g_ome[l_c].oga01
         END IF

         #發票明細
         LET l_ogb03 = g_ome[l_c].ogb03
         CALL p200_train(g_ome[l_c].ogb12) RETURNING l_ogb12
         CALL p200_train(g_ome[l_c].ogb13) RETURNING l_ogb13
         CALL p200_train(g_ome[l_c].ogb14) RETURNING l_ogb14
         LET l_det2=g_ome[l_c].ome01 CLIPPED,",",l_ogb03 CLIPPED,",",g_ome[l_c].ogb04 CLIPPED,",",l_ogb12 CLIPPED,",0," 
         LET l_det2=l_det2,l_ogb13 CLIPPED,",",l_ogb14 CLIPPED,",",g_ome[l_c].ogb05 CLIPPED,",0,0,," 
         LET l_det2=l_det2,g_ome[l_c].oga01 CLIPPED,",0,",g_ome[l_c].oea10 CLIPPED,",," 
        #LET l_det2=l_det2,g_ome[l_c].ogb11 CLIPPED,",,,,0,0,",g_ome[l_c].oao06 CLIPPED,",,,,,,,"             #TQC-AC0278 mark
        #LET l_det2=l_det2,g_ome[l_c].ogb11 CLIPPED,",,,,0,0,",g_ome[l_c].oao06 CLIPPED,",,,,,,"              #TQC-AC0278 add  #TQC-AC0343 mark
         LET l_det2=l_det2,g_ome[l_c].ogb11 CLIPPED,",0,0,,0,0,",g_ome[l_c].oao06 CLIPPED,",,,,,,"              #TQC-AC0343
         CALL lc_channe2.write(l_det2)
         IF cl_null(g_ome[l_c].ogb11) THEN
            SELECT gaq03 INTO l_gaq03 FROM gaq_file WHERE gaq01='ogb11' AND gaq02=g_lang
            LET l_det3 = g_ome[l_c].ome01," ",g_ome[l_c].oga01," ",l_ogb03 CLIPPED," ",l_gaq03 CLIPPED,l_ze03
            CALL lc_channe3.write(l_det3)
         END IF

         LET l_c = l_c + 1
       END FOREACH
     
       CALL g_ome.deleteElement(l_c)
       CALL lc_channe1.close()
       CALL lc_channe2.close()
       CALL lc_channe3.close()
   END FOREACH

 #MOD-B10002---add---start---
  LET l_txt = l_ome,".txt"
  LET l_txt2 = l_ome2,".txt"
  IF ms_codeset = "UTF-8" THEN
     IF os.Path.separator()="/" THEN
        LET l_cmd = "iconv -f UTF-8 -t big5 ",l_ome," > ",l_txt
        LET l_cmd = "iconv -f UTF-8 -t big5 ",l_ome2," > ",l_txt2
     ELSE
        LET l_cmd = "java -cp zhcode.jar zhcode -8b ",l_ome," > ",l_txt
        LET l_cmd = "java -cp zhcode.jar zhcode -8b ",l_ome2," > ",l_txt2
     END IF
     RUN l_cmd
     LET l_cmd = "cp -f " || l_txt CLIPPED || " " || l_ome CLIPPED
     LET l_cmd = "cp -f " || l_txt2 CLIPPED || " " || l_ome2 CLIPPED
     RUN l_cmd
  END IF
 #MOD-B10002---add---end---

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
  #MOD-B10002---add---start---
   LET l_cmd = "rm ",l_txt CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
  #MOD-B10002---add---end---

   LET unix_path = "$TEMPDIR/",l_ome2
   LET window_path = "c:\\tiptop\\",l_ome2
 
   LET status = cl_download_file(unix_path, window_path) 
   IF status then
      CALL cl_err(l_ome2,"amd-020",1)
      DISPLAY "Download OK!!"
   ELSE
      CALL cl_err(l_ome2,"amd-021",1)
      DISPLAY "Download fail!!"
   END IF
 
   LET l_cmd = "rm ",l_ome2 CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
  #MOD-B10002---add---start---
   LET l_cmd = "rm ",l_txt2 CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
  #MOD-B10002---add---end---
  #MOD-B10002---mark---start---
  #LET unix_path = "$TEMPDIR/",l_ome3
  #LET window_path = "c:\\tiptop\\",l_ome3
 
  #LET status = cl_download_file(unix_path, window_path) 
  #IF status then
  #   CALL cl_err(l_ome3,"amd-020",1)
  #   DISPLAY "Download OK!!"
  #ELSE
  #   CALL cl_err(l_ome3,"amd-021",1)
  #   DISPLAY "Download fail!!"
  #END IF
 
  #LET l_cmd = "rm ",l_ome3 CLIPPED," 2>/dev/null"
  #DISPLAY l_cmd
  #RUN l_cmd
  #MOD-B10002---mark---end---
  #TQC-AC0359---add---end---
END FUNCTION

FUNCTION p200_chk_inv(l_str)
   DEFINE l_str    STRING
   DEFINE l_str2   STRING
   DEFINE l_ni,i    LIKE type_file.num5
   DEFINE l_omechk  LIKE type_file.chr1
   DEFINE l_a       STRING 
   DEFINE l_asc     LIKE type_file.num5
   DEFINE l_ome01_a LIKE type_file.num5

   LET l_str2 = l_str
   LET l_ome01_a = 0
   FOR i = 3 TO 8
       LET l_a=l_str2.subString(i,i)
       CASE l_a
          WHEN '0'
            LET l_asc = 48
          WHEN '1'
            LET l_asc = 49
          WHEN '2'
            LET l_asc = 50
          WHEN '3'
            LET l_asc = 51
          WHEN '4'
            LET l_asc = 52
          WHEN '5'
            LET l_asc = 53
          WHEN '6'
            LET l_asc = 54
          WHEN '7'
            LET l_asc = 55
          WHEN '8'
            LET l_asc = 56
          WHEN '9'
            LET l_asc = 57
       END CASE
       LET l_ome01_a = l_ome01_a + ((l_asc MOD 10)*(i-2))
    END FOR
    LET l_ome01_a =l_ome01_a MOD 10
    LET l_omechk = l_ome01_a
    RETURN l_omechk
END FUNCTION

FUNCTION p200_train(p_str)
DEFINE p_str STRING
DEFINE l_dot STRING
DEFINE l_integer STRING
DEFINE l_str STRING
DEFINE l_a   LIKE type_file.num5
DEFINE l_b   LIKE type_file.num5
DEFINE l_fillin STRING
DEFINE l_dot_length LIKE type_file.num5
DEFINE l_cnt LIKE type_file.num5
DEFINE l_length  LIKE type_file.num5
 
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
    RETURN l_fillin
END FUNCTION
#FUN-AC0008
#TQC-AC0086
