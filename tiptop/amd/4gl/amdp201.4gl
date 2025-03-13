# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: amdp201.4gl
# Descriptions...: 電子發票匯出作業-關貿網
# Date & Author..: 10/11/30 By sabrina
# Modify.........: No:FUN-AC0034 10/11/30 By sabrina create program
# Modify.........: No:TQC-AC0215 10/12/15 By sabrina ama01的錯誤訊息應該after field後顯示 
# Modify.........: No:TQC-AC0278 10/12/20 By sabrina 更新單身明細資料 
# Modify.........: No:TQC-AC0342 10/12/23 By Summer 1.日期欄位轉出以YYYYMMDD 顯示
#                                                   2.發票人名稱 改抓取zo_file.zo12 
# Modify.........: No:TQC-AC0359 10/12/24 By 將檔案下載到C:\\tiptop目錄下 
# Modify.........: No:MOD-B10003 11/01/03 By sabrina 將UTF8轉成BIG5

IMPORT os      #MOD-B10003 add
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql                  STRING
DEFINE g_before_input_done    STRING
DEFINE g_err_cnt              LIKE type_file.num10 
DEFINE s1,s2,s3,t1,t2,t3,t4   LIKE type_file.chr1
DEFINE gln                    LIKE type_file.chr10
DEFINE ama01                  LIKE ama_file.ama01
DEFINE g_wc                   STRING
DEFINE l_flag                 LIKE type_file.chr1
DEFINE l_ama01                LIKE ama_file.ama01
DEFINE day1                   LIKE type_file.num5

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
   OPEN WINDOW p201_w AT p_row,p_col
        WITH FORM "amd/42f/amdp201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    CALL cl_set_comp_entry('gln,ama01',FALSE) 
 

   WHILE TRUE
      LET g_success = 'Y'
      CALL p201_tm()
      CALL p201_cre_tmp()
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p201()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW p201_w 
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p201_tm()
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
   LET t4 = 'N'
   LET day1 = '0'

   INPUT BY NAME
      s1,s2,gln,t1,t2,s3,ama01,t3,t4,day1
      WITHOUT DEFAULTS
 
      BEFORE INPUT
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
 

      AFTER FIELD s2 
         IF s2 = '1' THEN
            CALL cl_set_comp_entry('gln',TRUE)
         ELSE
            CALL cl_set_comp_entry('gln',FALSE) 
         END IF 

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

      AFTER FIELD t4
         IF t4 ='N' THEN
            CALL cl_set_comp_entry('day1',TRUE)
         ELSE
            CALL cl_set_comp_entry('day1',FALSE)
         END IF

      AFTER FIELD day1
         IF t4='N' THEN
            IF cl_null(day1) THEN
               CALL cl_err('','9046',1)
               NEXT FIELD day1
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
 
   END INPUT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
END FUNCTION

FUNCTION p201_cre_tmp()

    CREATE TEMP TABLE p201_tmp(
                  ome01    LIKE ome_file.ome01,    #發票號碼
                  ome172   LIKE ome_file.ome172,   #稅率別
                  ome02    LIKE ome_file.ome02,    #發票日期
                  omechk   LIKE ome_file.ome05,    #發票檢查碼
                  ome59    LIKE ome_file.ome59,    #發票金額
                  ome171   LIKE ome_file.ome171,   #發票格式
                  ome59x   LIKE ome_file.ome59x,   #發票稅額
                  ome042   LIKE ome_file.ome042,   #買方統編
                  ome60    LIKE ome_file.ome60,    #申報統編
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
                  occ74    LIKE occ_file.occ74,    #總店號
                  ome043   LIKE ome_file.ome043,   #受票人名稱
                  ome044   LIKE ome_file.ome044,   #受票人登記地址
                  occ30    LIKE occ_file.occ30,    #受票方聯絡人
                  amh06    LIKE amh_file.amh06,    #店別編號
                  amh07    LIKE amh_file.amh07,    #供應商編號
                  refd     LIKE amh_file.amh06,    #參考文件代碼
                  ref2     LIKE amh_file.amh07,    #參考號二
                  ama05    LIKE ama_file.ama05,    #發票人登記地址 
                  ama21_19 LIKE amh_file.amh07,    #發票人登記通訊電話
                  ama11    LIKE ama_file.ama11,    #發票方負責人
                  ama18    LIKE ama_file.ama18,    #發票方聯絡人
                  ami04    LIKE ami_file.ami04,    #促銷條碼        #TQC-AC0278 add
                  ogb042   LIKE ogb_file.ogb04)    #產品編號        #TQC-AC0278 add
END FUNCTION

FUNCTION p201()
   DEFINE l_zo12     LIKE zo_file.zo12        #賣方統編  #TQC-AC0342 mod zo06->zo12
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_ome_chk  LIKE ome_file.ome05      #發票檢查碼
   DEFINE l_omechk   STRING                   #發票檢查碼
   DEFINE l_aa       LIKE type_file.chr1      #通關方式註記
   DEFINE l_ogb04    LIKE gaz_file.gaz03      #產品編號品名
   DEFINE l_ima021   LIKE ima_file.ima021     #規格
   DEFINE l_oao06    LIKE oao_file.oao06      #單一備註欄
   DEFINE l_amh06    LIKE amh_file.amh06      #店別編號
   DEFINE l_amh07    LIKE amh_file.amh07      #供應商編號
   DEFINE l_refd     LIKE amh_file.amh06      #參考文件代碼
   DEFINE l_ref2     LIKE amh_file.amh07      #參考號二
   DEFINE l_ama05    LIKE ama_file.ama05      #發票人登記地址 
   DEFINE l_ama19    LIKE ama_file.ama19      #發票人電話
   DEFINE l_ama21    LIKE ama_file.ama21      #發票人區碼
   DEFINE l_ama21_19 LIKE amh_file.amh07      #發票人登記通訊電話
   DEFINE l_ama11    LIKE ama_file.ama11      #發票方負責人
   DEFINE l_ama18    LIKE ama_file.ama18      #發票方聯絡人
   DEFINE l_ze03     LIKE ze_file.ze03        
   DEFINE l_ima09    LIKE ima_file.ima09
   DEFINE l_ima10    LIKE ima_file.ima10
   DEFINE l_ima11    LIKE ima_file.ima11
   DEFINE l_ima06    LIKE ima_file.ima06
   DEFINE l_ima131   LIKE ima_file.ima131
   DEFINE l_amh02    LIKE amh_file.amh02
   DEFINE l_amh05    LIKE amh_file.amh05
   DEFINE l_ome02    LIKE ome_file.ome02
   DEFINE l_length   LIKE type_file.num5
   DEFINE l_ome044   STRING
   DEFINE l_ami04    LIKE ami_file.ami04      #促銷條碼       #TQC-AC0278 add
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
                  oga01    LIKE oga_file.oga01,    #出貨單單號
                  oga03    LIKE oga_file.oga03,    #客戶編號
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
                  occ74    LIKE occ_file.occ74,    #總店號
                  ome043   LIKE ome_file.ome043,   #受票人名稱
                  ome044   LIKE ome_file.ome044,   #受票人登記地址
                  occ30    LIKE occ_file.occ30,    #受票方聯絡人
                  ogb1005  LIKE ogb_file.ogb1005,  #作業方式            #TQC-AC0278 add
                  oga213   LIKE oga_file.oga213,   #含稅否              #TQC-AC0278 add
                  oga211   LIKE oga_file.oga211,   #稅率                #TQC-AC0278 add
                  oga02    LIKE oga_file.oga02     #出貨日期            #TQC-AC0278 add
                 END RECORD
          
      IF t2 = 'N' THEN
         LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome042,ome60,ome59t,oga01,oga03,ome05,oma36,oma37,", 
                     " oma38,oma39,omevoid,ogb04,ogb06,ogb12,ogb13,ogb14,ogb05,oea10,ogb11,ogb03,occ74,", 
                     " ome043,ome044,occ30,ogb1005,oga213,oga211,oga02 ",                 #TQC-AC0278 add ogb1005,oga213,oga211,oga02
                     " FROM ome_file,ogb_file,occ_file,oga_file,oma_file,omee_file,oea_file,oeb_file ",
                     " WHERE oga10=omee02 and oma10=ome01 and oma10=omee01 and oga10=oma01 ",
                     "   AND oga01=ogb01 AND oga03=occ01 AND oea01=oeb01 AND oga16=oea01 ",
                     "   AND omee01=ome01 ", 
                     "   AND oeb04=ogb04 ",
                     "   AND ome212='",s1,"'",
                     "   AND ",g_wc CLIPPED
      ELSE
         LET g_sql = "SELECT ome01,ome172,ome02,ome59,ome171,ome59x,ome042,ome60,ome59t,oga01,oga03,ome05,oma36,oma37,", 
                     " oma38,oma39,omevoid,ogb04,ogb06,ogb12,ogb13,ogb14,ogb05,oea10,ogb11,ogb03,occ74,", 
                     " ome043,ome044,occ30,ogb1005,oga213,oga211,oga02 ",               #TQC-AC0278 add ogb1005,oga213,oga211,oga02
                     " FROM ome_file,ogb_file,occ_file,oga_file,oma_file,omee_file,oea_file,oeb_file ",
                     " WHERE oga10=omee02 and oma10=ome01 and oma10=omee01 and oga10=oma01 ",
                     "   AND oga01=ogb01 AND oga03=occ01 AND oea01=oeb01 AND oga16=oea01 ",
                     "   AND omee01=ome01 ", 
                    #"   AND oeb1003 = '2' ",         #TQC-AC0278 mark   
                     "   AND ogb1005 = '2' ",         #TQC-AC0278 add 
                     "   AND oeb04=ogb04 ",
                     "   AND ome212='",s1,"'",
                     "   AND ",g_wc CLIPPED
      END IF
      IF t3 = 'N' THEN
         LET g_sql = g_sql," AND omevoid = 'N' "
      END IF
      PREPARE p201_pre FROM g_sql
      DECLARE p201_cs CURSOR FOR p201_pre

      DELETE FROM p201_tmp
      FOREACH p201_cs INTO sr.*
         
            LET l_ama01 = ama01
           
            SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01=g_lang #TQC-AC0342 mod zo06->zo12
           #發票別
            IF sr.omevoid= 'Y' THEN
               LET sr.ome05 ='C'
            ELSE
               LET sr.ome05 = 'O'
            END IF  
           #發票檢查碼
            LET l_length = 0
            CALL p201_chk_inv(sr.ome01)  RETURNING l_ome_chk 
            LET l_omechk = l_ome_chk
            LET l_length = l_omechk.getLength()   
            IF l_length > 5 THEN
                LET l_ome_chk = ' '
            END IF
           #店別
            SELECT ima09,ima10,ima11,ima06,ima131 INTO l_ima09,l_ima10,l_ima11,l_ima06,l_ima131 
              FROM ima_file WHERE ima01 = sr.ogb04 
            If NOT cl_null(l_ima09) THEN
               LET l_amh02='D'
               LET l_amh05=l_ima09
            ELSE
               IF NOT cl_null(l_ima10) THEN
                  LET l_amh02 = 'E'
               LET l_amh05=l_ima10
               ELSE
                  IF NOT cl_null(l_ima11) THEN
                     LET l_amh02 = 'F'
                     LET l_amh05=l_ima11
                  ELSE
                     IF NOT cl_null(l_ima06) THEN
                        LET l_amh02 = 'M'
                        LET l_amh05=l_ima06
                     ELSE
                        LET l_amh02 = 'P'
                        LET l_amh05=l_ima131
                     END IF
                  END IF
               END IF
            END IF
            SELECT amh06 INTO l_amh06 FROM amh_file
             WHERE amh01 = sr.occ74 AND amh02 = l_amh02 AND amh04 = sr.oga03
               AND amh05 = l_amh05 
            
           #洋煙酒註記
            IF (NOT cl_null(sr.oma38) OR NOT cl_null(sr.oma39)) AND sr.ome172 = '2' THEN
               LET l_aa = '2'
            END IF
            IF (NOT cl_null(sr.oma36) OR NOT cl_null(sr.oma37)) AND sr.ome172 = '2' THEN
               LET l_aa = '1'
            END IF
           #參考文件代碼
            IF s2='1' THEN
               IF l_length > 5 THEN
                  LET l_refd = 'CHK'
               ELSE
                  LET l_refd = '   '
               END IF
            ELSE
               IF t4='N' THEN
                  LET l_refd = 'DT '
               ELSE
                  LET l_refd = '   '
               END IF
            END IF
         
           #參考號二
            IF s2='1' THEN
               IF l_length > 5 THEN
                  SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='' AND ze02=g_lang
                  LET l_ref2 = l_ze03 
               ELSE
                  LET l_ref2 = ' '
               END IF
            ELSE
               IF t4='N' THEN
                  LET l_ome02 = sr.ome02 + day1 
                  LET l_ref2 = l_ome02
               ELSE
                  LET l_ref2 = ' '
               END IF
            END IF
           #發票人EAN Code
            IF s2='1' THEN
               LET l_amh07 = gln
            ELSE
               SELECT amh07 INTO l_amh07 FROM amh_file where amh01 = sr.occ74
            END IF
           #發票人統一編號and登記地址
            IF s3 = '1' THEN
               LET sr.ome60 = l_zo12 #TQC-AC0342 mod zo06->zo12
               SELECT ama05,ama21,ama19,ama11,ama18 
                 INTO l_ama05,l_ama21,l_ama19,l_ama11,l_ama18
                 FROM ama_file
                WHERE ama01 = l_zo12 #TQC-AC0342 mod zo06->zo12
               LET l_ama21_19 = l_ama21,"-",l_ama19
            ELSE
               LET sr.ome60 = sr.ome60
               SELECT ama05,ama21,ama19,ama11,ama18 
                 INTO l_ama05,l_ama21,l_ama19,l_ama11,l_ama18
                 FROM ama_file
                WHERE ama01 = l_ama01
               LET l_ama21_19 = l_ama21,"-",l_ama19
            END IF
            LET l_ama05 = cl_replace_str(l_ama05,"\n","")
           #TQC-AC0278---add---start---
           #商品條碼
            IF sr.ogb1005='2' THEN
               LET l_ami04='0000000000'
            ELSE
               SELECT ami04 INTO l_ami04 FROM ami_file,amj_file
                WHERE ami01 = sr.oga03
                  AND ami02 <= sr.oga02 
                  AND ((sr.oga02 < ami03) OR (ami03 IS NULL))
                  AND amj05 = sr.ogb04 AND amiacti = 'Y'
                  AND ami01 = amj01 AND ami02 = amj02 AND ami04 = amj04
               IF cl_null(l_ami04) THEN
                  SELECT ami04 INTO l_ami04 FROM ami_file,amj_file
                   WHERE ami01 = sr.occ74
                     AND ami02 <= sr.oga02 
                     AND ((sr.oga02 < ami03) OR (ami03 IS NULL))
                     AND amj05 = sr.ogb04 AND amiacti = 'Y'
                     AND ami01 = amj01 AND ami02 = amj02 AND ami04 = amj04
               END IF   
               IF cl_null(l_ami04) THEN
                  SELECT ima135 INTO l_ami04 FROM ima_file
                   WHERE ima01 = sr.ogb04 
               END IF
            END IF
           #TQC-AC0278---add---end---
           #印規格否
            IF t1 = 'Y' THEN
               SELECT ima021 INTO l_ima021 FROM ima_file
                WHERE ima01 = sr.ogb04
               LET l_ogb04 = sr.ogb04 CLIPPED,sr.ogb06 CLIPPED,l_ima021 CLIPPED
            ELSE
               LET l_ogb04 = sr.ogb04 CLIPPED,sr.ogb06 CLIPPED
            END IF  
           #TQC-AC0278---add---start---
           #單價(未稅)
            IF sr.oga213 = 'N' THEN
               LET sr.ogb13 = sr.ogb13
            ELSE
               LET sr.ogb13 = sr.ogb13 / (1 + sr.oga211)
            END IF 
            LET sr.ome044 = cl_replace_str(sr.ome044,"\n","")
           #TQC-AC0278---add---end---
            INSERT INTO p201_tmp VALUES(sr.ome01, sr.ome172,sr.ome02, l_ome_chk, sr.ome59,
                                        sr.ome171,sr.ome59x,sr.ome042,sr.ome60,  sr.ome59t,
                                        sr.oga01, l_aa,     sr.ome05, l_ogb04,   sr.ogb12,
                                        sr.ogb13, sr.ogb14, sr.ogb05, sr.oea10,  sr.ogb11,
                                        l_oao06,  sr.ogb03, sr.occ74, sr.ome043, sr.ome044,
                                        sr.occ30, l_amh06,  l_amh07,  l_refd,    l_ref2, 
                                        l_ama05,  l_ama21_19,l_ama11, l_ama18, l_ami04, sr.ogb04)       #TQC-AC0278 add l_ami04,sr.ogb04
      END FOREACH
      
      SELECT COUNT(*) INTO l_cnt FROM p201_tmp
      IF l_cnt = 0 THEN
         CALL cl_err('','axc-034',1)
         LET g_success = 'N'
      ELSE
         CALL p201_exp()
      END IF
END FUNCTION

FUNCTION p201_exp()

DEFINE g_ome DYNAMIC ARRAY OF RECORD
           ome01    LIKE ome_file.ome01,    #發票號碼
           ome172   LIKE ome_file.ome172,   #稅率別
           ome02    LIKE ome_file.ome02,    #發票日期
           omechk   LIKE ome_file.ome05,    #發票檢查碼
           ome59    LIKE ome_file.ome59,    #發票金額
           ome171   LIKE ome_file.ome171,   #發票格式
           ome59x   LIKE ome_file.ome59x,   #發票稅額
           ome042   LIKE ome_file.ome042,   #買方統編
           ome60    LIKE ome_file.ome60,    #申報統編
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
           occ74    LIKE occ_file.occ74,    #總店號
           ome043   LIKE ome_file.ome043,   #受票人名稱
           ome044   LIKE ome_file.ome044,   #受票人登記地址
           occ30    LIKE occ_file.occ30,    #受票方聯絡人
           amh06    LIKE amh_file.amh06,    #店別編號
           amh07    LIKE amh_file.amh07,    #供應商編號
           refd     LIKE amh_file.amh06,    #參考文件代碼
           ref2     LIKE amh_file.amh07,    #參考號二
           ama05    LIKE ama_file.ama05,    #發票人登記地址 
           ama21_19 LIKE amh_file.amh07,    #發票人登記通訊電話
           ama11    LIKE ama_file.ama11,    #發票方負責人
           ama18    LIKE ama_file.ama18,    #發票方聯絡人
           ami04    LIKE ami_file.ami04,    #促銷條碼            #TQC-AC0278 add
           ogb042   LIKE ogb_file.ogb04     #產品編號            #TQC-AC0278 add
       END RECORD
DEFINE l_tempdir   STRING
DEFINE l_ome       STRING
DEFINE l_txt       STRING      #MOD-B10003 add
DEFINE l_cmd       STRING
DEFINE l_det       STRING
DEFINE lc_channe1      base.Channel
DEFINE l_c         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_ome59     STRING
DEFINE l_ome59x    STRING
DEFINE l_ome59t    STRING
DEFINE l_occ74     LIKE occ_file.occ74
DEFINE l_zo06      LIKE zo_file.zo06
DEFINE l_time      LIKE type_file.chr8
DEFINE l_ogb03     STRING
DEFINE l_ogb12     STRING 
DEFINE l_ogb13     STRING 
DEFINE l_ogb14     STRING 
DEFINE l_ze03      LIKE ze_file.ze03
DEFINE l_length    LIKE type_file.num5
DEFINE l_ome01     LIKE ome_file.ome01
DEFINE l_n1,l_n2,l_n3,l_n4,l_n5        LIKE type_file.num5
DEFINE l_n6,l_n7,l_n8,l_n9,l_n10       LIKE type_file.num5
DEFINE l_n11,l_n12,l_n13,l_n14,l_n15   LIKE type_file.num5
DEFINE l_n16,l_n17,l_n18,l_n19,l_n20   LIKE type_file.num5
DEFINE l_n21,l_n22,l_n23               LIKE type_file.num5
DEFINE unix_path   STRING            #TQC-AC0359 add
DEFINE window_path STRING            #TQC-AC0359 add
DEFINE ms_codeset  STRING            #MOD-B10003 add


  LET l_sql = "SELECT DISTINCT occ74 FROM p201_tmp ORDER BY occ74"
  PREPARE p201_occ74_pre FROM l_sql
  DECLARE p201_occ74_cs SCROLL CURSOR FOR p201_occ74_pre
  FOREACH p201_occ74_cs INTO l_occ74
       LET l_c = 1
       LET l_tempdir = FGL_GETENV('TEMPDIR')
       LET l_time = TIME(CURRENT)
       LET l_time = cl_replace_str(l_time,":","")
       IF s3 = '1' THEN
          LET l_zo06 = NULL
          SELECT zo06 INTO l_zo06 FROM zo_file where zo01=g_lang
          LET l_ome = l_zo06,TODAY USING 'YYYYMMDD',l_time,".txt"            #TQC-AC0359 modify
       ELSE
          LET l_ome = ama01,TODAY USING 'YYYYMMDD',l_time,".txt"             #TQC-AC0359 modify
       END IF
       LET l_cmd = "cat  /dev/null > ",l_tempdir CLIPPED,"/",l_ome CLIPPED   #TQC-AC0359 modify
       DISPLAY "l_cmd:",l_cmd
       DISPLAY "l_ome:",l_ome
       RUN l_cmd
       LET lc_channe1 = base.Channel.create()
       CALL lc_channe1.openFile(l_ome,"w")
     
       CALL g_ome.clear()
     
       LET ms_codeset = cl_get_codeset()       #MOD-B10003 add

       LET l_sql = "SELECT * FROM p201_tmp WHERE occ74 = '",l_occ74,"'"
       PREPARE p201_tm_pre FROM l_sql
       DECLARE p201_tm_cs SCROLL CURSOR FOR p201_tm_pre
     
       FOREACH p201_tm_cs INTO g_ome[l_c].*
     
         IF SQLCA.sqlcode THEN
             CALL cl_err('Foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         #發票主檔
        #TQC-AC0278---modify---start---
         IF (l_ome01 IS NULL) OR l_ome01 != g_ome[l_c].ome01 THEN      
            CALL p201_train2(5,g_ome[l_c].omechk) RETURNING l_n1
            CALL p201_train(12,g_ome[l_c].ome59)  RETURNING l_n2,l_ome59
            CALL p201_train(10,g_ome[l_c].ome59x)  RETURNING l_n3,l_ome59x
            CALL p201_train(12,g_ome[l_c].ome59t)  RETURNING l_n4,l_ome59t
            CALL p201_train2(13,g_ome[l_c].amh06) RETURNING l_n5
            CALL p201_train2(60,g_ome[l_c].ome043) RETURNING l_n6
            CALL p201_train2(70,g_ome[l_c].ome044) RETURNING l_n7
            CALL p201_train2(20,g_ome[l_c].occ30) RETURNING l_n8
            CALL p201_train2(20,g_ome[l_c].oea10) RETURNING l_n9
            CALL p201_train2(20,g_ome[l_c].ref2) RETURNING l_n10
            CALL p201_train2(13,g_ome[l_c].amh07) RETURNING l_n11
            CALL p201_train2(70,g_ome[l_c].ama05) RETURNING l_n12
            CALL p201_train2(20,g_ome[l_c].ama21_19) RETURNING l_n13
            CALL p201_train2(10,g_ome[l_c].ama11) RETURNING l_n14
            CALL p201_train2(20,g_ome[l_c].ama18) RETURNING l_n15
            LET l_det="T1",g_ome[l_c].ome171,"11",g_ome[l_c].ome05
           #LET l_det=l_det,g_ome[l_c].ome01,g_ome[l_c].omechk,l_n1 SPACES,g_ome[l_c].ome02 #TQC-AC0342 mark
            LET l_det=l_det,g_ome[l_c].ome01,g_ome[l_c].omechk,l_n1 SPACES,g_ome[l_c].ome02 USING 'YYYYMMDD' #TQC-AC0342
            LET l_det=l_det,l_n2 SPACES,l_ome59,g_ome[l_c].ome172
            LET l_det=l_det,l_n3 SPACES,l_ome59x,l_n4 SPACES,l_ome59t,g_ome[l_c].ome042
            LET l_det=l_det,g_ome[l_c].amh06,l_n5 SPACES,g_ome[l_c].ome043,l_n6 SPACES
            LET l_det=l_det,g_ome[l_c].ome044,l_n7 SPACES,g_ome[l_c].occ30,l_n8 SPACES
            LET l_det=l_det,g_ome[l_c].aa,"PO ",g_ome[l_c].oea10,l_n9 SPACES
            LET l_det=l_det,g_ome[l_c].refd CLIPPED,g_ome[l_c].ref2,l_n10 SPACES
            LET l_det=l_det,212 SPACES,g_ome[l_c].ome60,g_ome[l_c].amh07,l_n11 SPACES
            LET l_det=l_det,g_ome[l_c].ome60
            LET l_det=l_det,g_ome[l_c].ama05,l_n12 SPACES,g_ome[l_c].ama21_19,l_n13 SPACES
            LET l_det=l_det,g_ome[l_c].ama11,l_n14 SPACES
            LET l_det=l_det,g_ome[l_c].ama18,l_n15 SPACES,38 SPACES
            CALL lc_channe1.write(l_det)
            LET l_ome01 = g_ome[l_c].ome01
         END IF
         #發票明細
         LET l_ogb03 = g_ome[l_c].ogb03                          
         CALL p201_train2(4,l_ogb03) RETURNING l_n16
         CALL p201_train2(20,g_ome[l_c].ogb11) RETURNING l_n17
         CALL p201_train2(20,g_ome[l_c].ogb042) RETURNING l_n18
         CALL p201_train2(20,g_ome[l_c].ami04) RETURNING l_n19
         CALL p201_train2(70,g_ome[l_c].ogb04) RETURNING l_n20
         CALL p201_train(11,g_ome[l_c].ogb12) RETURNING l_n21,l_ogb12
         CALL p201_train(15,g_ome[l_c].ogb13) RETURNING l_n22,l_ogb13
         CALL p201_train(12,g_ome[l_c].ogb14) RETURNING l_n23,l_ogb14
         LET l_det= NULL
         LET l_det="T2",l_ogb03,l_n16 SPACES,g_ome[l_c].ogb11,l_n17 SPACES
         LET l_det=l_det,g_ome[l_c].ogb042,l_n18 SPACES,g_ome[l_c].ami04,l_n19 SPACES
         LET l_det=l_det,g_ome[l_c].ogb04,l_n20 SPACES
         LET l_det=l_det,l_n21 SPACES,l_ogb12,g_ome[l_c].ogb05,l_n22 SPACES,l_ogb13,l_n23 SPACES,l_ogb14,40 SPACES
        #TQC-AC0278---modify---end---
         CALL lc_channe1.write(l_det)

         LET l_c = l_c + 1
       END FOREACH
     
       CALL g_ome.deleteElement(l_c)
       CALL lc_channe1.close()
   END FOREACH
  #MOD-B10003---add---start---
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
  #MOD-B10003---add---end---
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
  #MOD-B10003---add---start---
   LET l_cmd = "rm ",l_txt CLIPPED," 2>/dev/null"
   DISPLAY l_cmd
   RUN l_cmd
  #MOD-B10003---add---end---
  #TQC-AC0359---add---end---
END FUNCTION

FUNCTION p201_chk_inv(l_str)
   DEFINE l_str     STRING
   DEFINE l_str2    STRING
   DEFINE l_ni,i    LIKE type_file.num5
   DEFINE l_omechk  LIKE ome_file.ome05 
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

FUNCTION p201_train(l_n,p_str)
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
DEFINE l_length2 LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_sp      LIKE type_File.num5 

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
    RETURN l_sp,l_fillin
END FUNCTION
#TQC-AC0278---add---start---
FUNCTION p201_train2(l_n,p_str)
DEFINE l_n          LIKE type_file.num5
DEFINE p_str        STRING
DEFINE l_length     LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
 
   #LET l_length = p_str.getLength()   #總長度 #TQC-AC0342 mark
    LET l_length = FGL_WIDTH(p_str)   #總長度  #TQC-AC0342
    IF l_n <= l_length THEN
       LET l_sp = 0
    ELSE
       LET l_sp = l_n - l_length
    END IF
    RETURN l_sp
END FUNCTION
#TQC-AC0278---add---start---
#FUN-AC0034
