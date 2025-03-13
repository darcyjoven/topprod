# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp890.4gl
# Descriptions...: 三角貿易銷退應收/應付帳款拋轉還原作業
# Date & Author..: 98/12/18 By Linda
# Modify.........: No:8193 03/09/16 ching 1.流程代碼改抓poy_file,poz_file
#                                         2.多角序號
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.FUN-570155 06/03/15 By yiting 批次作業修改
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: No.MOD-680020 06/12/27 By Mandy 當單頭的出貨單沒有輸入時,抓單身任何一筆出貨單
# Modify.........: No.FUN-710046 07/01/24 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-760152 07/08/08 By claire 更新oha_file 及ohb_file時條件不應取來源廠的單號
# Modify.........: No.TQC-7C0019 07/12/05 BY zhangmin刪除應收/應付單時同時刪除多帳期資料
# Modify.........: No.MOD-8B0085 08/11/07 By Sarah 抓AR_t1的值應使用s_get_doc_no(g_oma01)
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
                                    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A80141 10/08/19 By Carrier azp()时,第0站的l_dbs_new不用置空
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-B40063 11/07/04 By Summer 金額為0不產生分錄,整張帳款金額為0時不做分錄的檢核
# Modify.........: No:MOD-C60027 12/06/20 By Vampire 增加判斷已開立發票不可還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oha   RECORD LIKE oha_file.*
DEFINE g_ohb   RECORD LIKE ohb_file.*
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE tm RECORD
          oha01  LIKE oha_file.oha01
       END RECORD
DEFINE g_poz  RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8187
DEFINE g_poy  RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8187
DEFINE l_dbs_new  LIKE type_file.chr21     #New DataBase Name  #No.FUN-680137 VARCHAR(21)
DEFINE l_dbs_tra  LIKE type_file.chr21     #FUN-980092 
DEFINE l_plant_new  LIKE type_file.chr10   #FUN-980092 
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE g_sw LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1  LIKE oha_file.oha01
DEFINE g_rva01  LIKE rva_file.rva01     #No.8187
DEFINE g_oga01  LIKE oga_file.oga01     #No.8187
DEFINE g_oha01  LIKE oha_file.oha01     #No.8187
DEFINE g_rvu01  LIKE rvu_file.rvu01     #No.8187
DEFINE g_apa01  LIKE apa_file.apa01     #No.8187
DEFINE g_oma01  LIKE oma_file.oma01     #No.8187
DEFINE p_last   LIKE type_file.num5             #No.FUN-680137 SMALLINT 
DEFINE p_last_plant LIKE type_file.chr1         #No.FUN-680137 VARCHAR(1)
DEFINE p_last_flag LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_t1        LIKE oay_file.oayslip        #No.FUN-550070        #No.FUN-680137 VARCHAR(5)
DEFINE p_apy RECORD LIKE apy_file.*
DEFINE p_ooy RECORD LIKE ooy_file.*
DEFINE AR_t1,AP_t1  LIKE aba_file.aba00  #No.8187   #No.FUN-680137 VARCHAR(5)
DEFINE g_change_lang   LIKE type_file.chr1      #FUN-570155  #No.FUN-680137 VARCHAR(1)
DEFINE l_flag          LIKE type_file.num5      #FUN-570155  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(72)
 
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
#FUN-570155 --start--
    INITIALIZE g_bgjob_msgfile TO NULL
    LET tm.oha01 = ARG_VAL(1)
    LET g_bgjob  = ARG_VAL(2)
 
    IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
#NO.FUN-570155 end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
#NO.FUN-570155 mark--
#    #若有傳參數則不用輸入畫面
#    IF cl_null(g_argv1) THEN 
#       CALL p890_p1()
#    ELSE
#       LET tm.oha01 = g_argv1
#       CALL p890_p2()
#    END IF
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start--
    WHILE TRUE
       LET g_success = 'Y'
       LET g_change_lang = FALSE
       IF g_bgjob = 'N' THEN
          CALL p890_p1()
          IF cl_sure(0,0) THEN
             CALL cl_wait() 
             BEGIN WORK 
             CALL p890_p2()
             CALL s_showmsg()              #NO.FUN-710046
             IF g_success = 'Y' THEN
                COMMIT WORK
                CALL cl_end2(1) RETURNING l_flag
             ELSE
                ROLLBACK WORK
                CALL cl_end2(2) RETURNING l_flag
             END IF
             IF l_flag THEN 
                CONTINUE WHILE 
             ELSE 
                CLOSE WINDOW p890_w
                EXIT WHILE 
             END IF
          ELSE
             CONTINUE WHILE
          END IF
          CLOSE WINDOW p890_w
       ELSE
          BEGIN WORK 
          CALL p890_p2()
          CALL s_showmsg()              #NO.FUN-710046
          IF g_success = 'Y' THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
       END IF
    END WHILE
#NO.FUN-570155 end---
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p890_p1()
    DEFINE lc_cmd LIKE type_file.chr1000   #FUN-570155  #No.FUN-680137 VARCHAR(500)
 
    OPEN WINDOW p890_w WITH FORM "axm/42f/axmp890" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oha01
 WHILE TRUE
    LET g_action_choice = ''
    LET g_bgjob = 'N'   #NO.FUN-570155 
    #INPUT BY NAME tm.oha01  WITHOUT DEFAULTS  
    INPUT BY NAME tm.oha01,g_bgjob   WITHOUT DEFAULTS   #NO.FUN-570155 
         AFTER FIELD oha01
            IF cl_null(tm.oha01) THEN
               NEXT FIELD oha01
            END IF
            SELECT * INTO g_oha.*
               FROM oha_file
              WHERE oha01=tm.oha01
                AND ohaconf = 'Y' #01/08/17 mandy
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('sel oha',STATUS,0)   #No.FUN-660167
               CALL cl_err3("sel","oha_file",tm.oha01,"",STATUS,"","sel oha",0)   #No.FUN-660167
               NEXT FIELD oha01 
            END IF
            IF g_oha.oha10 IS NULL THEN    #帳單編號
               CALL cl_err(g_oha.oha10,'axm-309',0)
               NEXT FIELD oha01 
            END IF
            IF g_oha.oha41='N' OR g_oha.oha41 IS NULL THEN  #非三角貿易
               CALL cl_err(g_oha.oha41,'tri-014',0)
               NEXT FIELD oha01 
            END IF
            IF g_oha.oha44='N' THEN   #未拋轉
               CALL cl_err(g_oha.oha44,'tri-012',0)
               NEXT FIELD oha01 
            END IF
           #No.9422
           #IF g_oha.oha43 <>'Y' THEN  #非來源工廠
           #   CALL cl_err(g_oha.oha43,'apm-015',0)
           #   NEXT FIELD oha01 
           #END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG call cl_cmdask()
      ON ACTION locale
#NO.FUN-570155 start--
#         LET g_action_choice='locale'
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE                  #FUN-570155
#NO.FUN-570155 end---
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570155 start--
#FUN-570155 --start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p890_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axmp890'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axmp890','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.oha01 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axmp890',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p890_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
 END WHILE
#NO.FUN-570155 end---
 
#NO.FUN-570155 mark--
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
#   IF cl_sure(0,0) THEN
#      CALL p890_p2()
#      IF g_success = 'Y' THEN
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
# END WHILE
#  CLOSE WINDOW p890_w
#NO.FUN-570155 mark--
END FUNCTION
 
FUNCTION p890_p2()
  DEFINE l_sql  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5        #No.FUN-680137 SMALLINT
  DEFINE l_oma RECORD LIKE oma_file.*
  DEFINE l_apa RECORD LIKE apa_file.*
  DEFINE l_npp RECORD LIKE npp_file.*
  DEFINE l_j    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_msg  LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(60)
 
     #讀取出貨單資料
     SELECT * INTO g_oha.*
       FROM oha_file
      WHERE oha01=tm.oha01  
         AND oha41='Y'
        #AND oha43='Y'  #No.9422
         AND oha44='Y'
         AND oha10 IS NOT NULL 
         AND ohaconf='Y'
     IF SQLCA.SQLCODE<>0  THEN
#       CALL cl_err('sel oha',STATUS,1)    #No.FUN-660167
        CALL cl_err3("sel","oha_file",tm.oha01,"",STATUS,"","sel oha",1)   #No.FUN-660167
        RETURN
     END IF
#NO.FUN-570155 mark-
#     CALL cl_wait() 
#     BEGIN WORK 
#     LET g_success='Y'
#NO.FUN-570155 mark--
 
     #MOD-680020----------add---
     IF cl_null(g_oha.oha16) THEN 
         #抓單身任何一筆出貨單號
         SELECT MAX(ohb31) INTO g_oha.oha16 FROM ohb_file
          WHERE ohb01 = g_oha.oha01
     END IF
     #MOD-680020----------end---
 
     #讀取該銷退單之出貨單資料
     SELECT * INTO g_oga.*
       FROM oga_file
      WHERE oga01 = g_oha.oha16
     IF SQLCA.SQLCODE <> 0 THEN
#          CALL cl_err('sel oga',STATUS,1)   #No.FUN-660167
           CALL cl_err3("sel","oga_file",g_oha.oha16,"",STATUS,"","sel oga",1)   #No.FUN-660167
           LET g_success='N'
           RETURN
     END IF
     #讀取該出貨單之訂單
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by Kammy
       #只讀取第一筆訂單之資料
       LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                   "  WHERE oea01 = ogb31 ",
                   "    AND ogb01 = '",g_oga.oga01,"'",
                   "    AND oeaconf = 'Y' " #01/08/16 mandy
       PREPARE oea_pre FROM l_sql1
       DECLARE oea_f CURSOR FOR oea_pre
       OPEN oea_f
       FETCH oea_f INTO g_oea.*
     ELSE
       #讀取該出貨單之訂單
       SELECT * INTO g_oea.*
         FROM oea_file
        WHERE oea01 = g_oga.oga16
          AND oeaconf = 'Y'  #01/08/16 mandy
     END IF
     IF SQLCA.SQLCODE <> 0 THEN
           CALL cl_err('sel oea',STATUS,1)
           LET g_success='N'
           RETURN
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 AND poz00='1'
     IF SQLCA.sqlcode THEN
#        CALL cl_err(g_oea.oea904,'axm-318',1)   #No.FUN-660167
         CALL cl_err3("sel","poz_file",g_oea.oea904,"",'axm-318',"","",1)   #No.FUN-660167
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN
         CALL cl_err(g_oea.oea904,'tri-009',1)
         LET g_success = 'N'
         RETURN
     END IF
     CALL s_mtrade_last_plant(g_oea.oea904)
         RETURNING p_last,p_last_plant       #記錄最後一家
 
     #依流程代碼最多6層 
     LET p_last_flag='N'
     CALL s_showmsg_init()              #NO.FUN-710046  
     FOR i = 0 TO p_last
#NO.FUN-710046--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710046--END 
           #得到廠商/客戶代碼及database
           CALL p890_azp(i)
           CALL p890_getno(i)                 #No.8187
           #***************判斷已沖帳或已拋傳票否*************#
 
           #讀取AR,AP單別檔資料
           LET l_sql = "SELECT * ",
                       #" FROM ",l_dbs_new CLIPPED,"ooy_file ",
                       " FROM ",cl_get_target_table(l_plant_new,'ooy_file'),  #FUN-A50102
                       " WHERE ooyslip = '",AR_t1,"' "     
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-A50102
           PREPARE ooy_p1 FROM l_sql 
#          IF STATUS THEN CALL cl_err('ooy_p1',STATUS,1) END IF #NO.FUN-710046
           IF STATUS THEN CALL s_errmsg('ooyslip',AR_t1,'ooy_p1',STATUS,1) END IF #NO.FUN-710046    
           DECLARE ooy_c1 CURSOR FOR ooy_p1
           OPEN ooy_c1
           FETCH ooy_c1 INTO p_ooy.* 
           CLOSE ooy_c1
         IF i != p_last THEN   ##最後一家工廠不必拋AP
           LET l_sql = "SELECT * ",
                       #" FROM ",l_dbs_new CLIPPED,"apy_file ",
                       " FROM ",cl_get_target_table(l_plant_new,'apy_file'),  #FUN-A50102
                       " WHERE apyslip = '",AP_t1,"' "      
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE apy_p1 FROM l_sql 
#          IF STATUS THEN CALL cl_err('apy_p1',STATUS,1) END IF  #NO.FUN-710046
           IF STATUS THEN CALL s_errmsg('apyslip',AP_t1,'apy_p1',STATUS,1) END IF #NO.FUN-710046    
           DECLARE apy_c1 CURSOR FOR apy_p1
           OPEN apy_c1
           FETCH apy_c1 INTO p_apy.* 
           CLOSE apy_c1
         END IF
           #判斷應收帳款是否已拋轉至總帳
           #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," oma_file",
           LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'oma_file'),  #FUN-A50102
                       " WHERE oma01 = '",g_oma01,"'"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE oma_pre FROM l_sql
           DECLARE oma_cs CURSOR FOR oma_pre
           OPEN oma_cs 
           FETCH oma_cs INTO l_oma.*
           IF l_oma.oma33 IS NOT NULL THEN
#           CALL cl_err('oma33:','axm-898',1) #NO.FUN-710046
            CALL s_errmsg('oma01',g_oma01,'oma33:','axm-898',1) #NO.FUN-710046
#           LET g_success='N' EXIT FOR                            #NO.FUN-710046
            LET g_success='N' CONTINUE FOR                        #NO.FUN0710046
           END IF
           IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN #已沖帳
#             CALL cl_err('oma55:','agl-905',1)                    #NO.FUN-710046
              CALL s_errmsg('oma01',g_oma01,'oma33:','axm-898',1)#NO.FUN-710046
#             LET g_success='N' EXIT FOR                           #NO.FUN-710046
              LET g_success='N' CONTINUE FOR                       #NO.FUN0710046
           END IF
           #MOD-C60027 add start -----
           IF NOT cl_null(l_oma.oma10) THEN
              CALL s_errmsg('','','oma10:','arm-015',1)
              LET g_success='N'
              CONTINUE FOR
           END IF
           #MOD-C60027 add start -----
        
           IF i != p_last THEN   ##最後一家工廠不必拋AP
              #判斷應付帳款是否已拋轉至總帳
              #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," apa_file",
              LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'apa_file'),  #FUN-A50102
                          " WHERE apa01 = '",g_apa01,"'"
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
              PREPARE apa_pre FROM l_sql
              DECLARE apa_cs CURSOR FOR apa_pre
              OPEN apa_cs 
              FETCH apa_cs INTO l_apa.*
              IF l_apa.apa44 IS NOT NULL THEN
 #             CALL cl_err('apa44:','axm-898',1)  #NO.FUN-710046
               CALL s_errmsg('apa01',g_apa01,'apa44:','axm-898',1)  #NO.FUN-710046
#              LET g_success='N' EXIT FOR         #NO.FUN-710046
               LET g_success='N' CONTINUE FOR     #NO.FUN-710046           
              END IF
              IF l_apa.apa35>0 OR l_apa.apa35f>0    #已沖帳
               OR l_apa.apa65>0 OR l_apa.apa65f>0 THEN
#              CALL cl_err('oma35:','aap-255',1)                      #NO.FUN-710046
               CALL s_errmsg('apa01',g_apa01,'apa44:','axm-898',1)  #NO.FUN-710046
#              LET g_success='N' EXIT FOR         #NO.FUN-710046
               LET g_success='N' CONTINUE FOR     #NO.FUN-710046           
              END IF
           END IF
           #判斷分錄底稿是否已拋轉至總帳
        IF p_ooy.ooydmy1 = 'Y' THEN
           #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," npp_file ",
           LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'npp_file'),  #FUN-A50102
                       " WHERE nppsys='AR' AND npp00='2' ",
                       "   AND npp01 = '",g_oma01,"'",
                       "   AND npp011=1 "
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE npp_p1 FROM l_sql
           DECLARE npp_c1 CURSOR FOR npp_p1
           OPEN npp_c1 
           FETCH npp_c1 INTO l_npp.*
           IF l_npp.nppglno IS NOT NULL THEN
#             CALL cl_err('nppglno(AR):','axm-898',1) #NO.FUN-710046
              LET g_showmsg=2,"/",g_oma01      #NO.FUN-710046
              CALL s_errmsg('npp00,npp01',g_showmsg,'nppglno(AR):','axm-898',1) #NO.FUN-710046
#             LET g_success='N' EXIT FOR                                               #NO.FUN-710046
              LET g_success='N' CONTINUE FOR                                           #NO.FUN-710046    
           END IF
        END IF
           IF i != p_last THEN    ##最後一家工廠不必拋AP
             IF p_apy.apydmy3 = 'Y' THEN
              #判斷分錄底稿是否已拋轉至總帳
              #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," npp_file ",
              LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'npp_file'),  #FUN-A50102
                          " WHERE nppsys='AP' AND npp00='1' ",
                          "   AND npp01 = '",g_apa01,"'",
                          "   AND npp011=1 "
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
              PREPARE npp_p2 FROM l_sql
              DECLARE npp_c2 CURSOR FOR npp_p2
              OPEN npp_c2 
              FETCH npp_c2 INTO l_npp.*
              IF l_npp.nppglno IS NOT NULL THEN
#             CALL cl_err('nppglno(AP):','axm-898',1) #NO.FUN-710046
              LET g_showmsg=1,"/",g_apa01      #NO.FUN-710046
              CALL s_errmsg('npp00,npp01',g_showmsg,'nppglno(AR):','axm-898',1) #NO.FUN-710046
#             LET g_success='N' EXIT FOR              #NO.FUN-710046                          
              LET g_success='N' CONTINUE FOR          #NO.FUN-710046   
              END IF
             END IF
           END IF
           #****************************************************#
           #還原各廠之應收/應付資料
           #MOD-760152-begin-add
           #LET l_sql = " SELECT oha01 FROM ",l_dbs_new CLIPPED,"oha_file ",
            #LET l_sql = " SELECT oha01 FROM ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092
            LET l_sql = " SELECT oha01 FROM ",cl_get_target_table(l_plant_new,'oha_file'),  #FUN-A50102
                        "  WHERE oha99 ='",g_oha.oha99,"'",
                        "    AND oha05 = '2' "
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE oha01_pre FROM l_sql
            DECLARE oha01_cs CURSOR FOR oha01_pre
            OPEN oha01_cs 
            FETCH oha01_cs INTO g_oha.oha01      #以流程序號重取各區單號 
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'
               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
           #MOD-760152-end-add
           #CALL p890_pro(l_dbs_new,i)
           CALL p890_pro(l_plant_new,i)   #FUN-A50102
     END FOR 
#NO.FUN-710046--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710046--END
 
#NO.FUN-570155 mark--
#     IF g_success = 'Y'
#        THEN COMMIT WORK
#        ELSE ROLLBACK WORK
#     END IF
#NO.FUN-570155 mark-
END FUNCTION
 
FUNCTION p890_azp(l_i)
    DEFINE l_i LIKE type_file.num5,          #No.FUN-680137 SMALLINT
           l_sql1 LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(800)
 
    ##-------------取得當站資料庫----------------------
    SELECT * INTO g_poy.* FROM poy_file
     WHERE poy01 = g_poz.poz01 AND poy02 = l_i
    SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
   #LET l_dbs_new = l_azp.azp03 CLIPPED,"."    #TQC-950032 MARK                                                                     
    LET l_dbs_new = s_dbstring(l_azp.azp03)    #TQC-950032 ADD  
    #No.MOD-A80141  --Begin
    #IF l_i = 0 THEN LET l_dbs_new = ' ' END IF     
    #No.MOD-A80141  --End  
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET l_plant_new = g_poy.poy04
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
END FUNCTION
 
#FUNCTION p890_pro(p_dbs,i)
FUNCTION p890_pro(l_plant,i)   #FUN-A50102
 #DEFINE p_dbs  LIKE type_file.chr21         #No.FUN-680137 VARCHAR(21)
 DEFINE l_plant  LIKE type_file.chr10   #FUN-A50102
 DEFINE i        LIKE type_file.num5          #No.FUN-680137 SMALLINT
 DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(600)
 DEFINE l_cnt  LIKE type_file.num5     #CHI-B40063 add

     #刪除應收帳款單頭(oma_file)
     #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"oma_file",
     LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'oma_file'),  #FUN-A50102
              " WHERE oma01= ? ",
              "   AND oma33 IS NULL "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE del_oma FROM l_sql
     EXECUTE del_oma USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err('del oma:',SQLCA.SQLCODE,1)     #NO.FUN-710046
        CALL s_errmsg('oma01',g_oma01,'del oma:',SQLCA.SQLCODE,1) #NO.FUN-710046
        LET g_success='N' 
     END IF
     #刪除應收帳款單身(omb_file)
     #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"omb_file",
     LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'omb_file'),  #FUN-A50102
              " WHERE omb01= ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE del_omb FROM l_sql
     EXECUTE del_omb USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err('del omb:',SQLCA.SQLCODE,1)   #NO.FUN-710046
        CALL s_errmsg('omb01',g_oma01,'del omb:',SQLCA.SQLCODE,1) #NO.FUN-710046
        LET g_success='N' 
     END IF
 
     #No.TQC-7C0019 -----begin-----
     #刪除應收多帳期資料(omc_file)
     #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"omc_file",
     LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'omc_file'),  #FUN-A50102
              " WHERE omc01= ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE del_omc FROM l_sql
     EXECUTE del_omc USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err('del omc:',SQLCA.SQLCODE,1)   #NO.FUN-710046
        CALL s_errmsg('omc01',g_oma01,'del omc:',SQLCA.SQLCODE,1) #NO.FUN-710046
        LET g_success='N' 
     END IF
     #No.TQC-7C0019 -----end-----
 
     #更新出貨單單頭檔之帳單編號
    #LET l_sql="UPDATE ",p_dbs CLIPPED,"oha_file",
     #LET l_sql="UPDATE ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092
     LET l_sql="UPDATE ",cl_get_target_table(l_plant,'oha_file'),  #FUN-A50102
                " SET oha10 = NULL, ",
                "     oha54 = 0 ",
                " WHERE oha01 = ?  " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
     PREPARE upd_oha2 FROM l_sql
     EXECUTE upd_oha2 USING g_oha.oha01
     IF SQLCA.sqlcode<>0 THEN
#       CALL cl_err('upd oha10:',SQLCA.sqlcode,1) #NO.FUN-710046
        CALL s_errmsg('oha01',g_oha.oha01,'upd oha10:',SQLCA.sqlcode,1) #NO.FUN-710046 
        LET g_success = 'N'
     END IF
     #更新出貨單單身檔之已開折讓數量
    #LET l_sql="UPDATE ",p_dbs CLIPPED,"ohb_file",
     #LET l_sql="UPDATE ",l_dbs_tra CLIPPED,"ohb_file",  #FUN-980092
     LET l_sql="UPDATE ",cl_get_target_table(l_plant,'ohb_file'),  #FUN-A50102
                " SET ohb60 = 0  ",
                " WHERE ohb01 = ?  " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
     PREPARE upd_ohb2 FROM l_sql
     EXECUTE upd_ohb2 USING g_oha.oha01
     IF SQLCA.sqlcode<>0 THEN
#       CALL cl_err('upd ohb60:',SQLCA.sqlcode,1)   #NO.FUN-710046
        CALL s_errmsg('ohb01',g_oha.oha01,'upd ohb60:',SQLCA.sqlcode,1) #NO.FUN-710046 
        LET g_success = 'N'
     END IF
   IF p_ooy.ooydmy1 = 'Y' THEN
    #刪除分錄底稿單頭檔(npp_file)--AR
    #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npp_file",
    LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npp_file'),  #FUN-A50102
             " WHERE nppsys='AR' AND npp00='2' ",
             "   AND npp01=? ",
             "   AND npp011=1 ",
             "   AND nppglno IS NULL "
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
    PREPARE del_npp_ar FROM l_sql
    EXECUTE del_npp_ar USING g_oma01
    IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('del npp(AR):',SQLCA.SQLCODE,1)     #NO.FUN-710046
       LET g_showmsg=2,"/",g_oma01              #NO.FUN-710046 
       CALL s_errmsg('npp00,npp01',g_showmsg,'del npp(AR):',SQLCA.SQLCODE,1) #NO.FUN-710046 
       LET g_success='N'
    END IF
    #CHI-B40063 add --start--
    LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'npq_file'),
             " WHERE npqsys='AR' AND npq00='2' ",
             "   AND npq01=? ",
             "   AND npq011=1 " 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
    PREPARE sel_npq_ar FROM l_sql
    LET l_cnt = 0 
    EXECUTE sel_npq_ar USING g_oma01 INTO l_cnt
    IF l_cnt > 0 THEN 
    #CHI-B40063 add --end--
       #刪除分錄底稿單身檔(npq_file)--AR
       #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",
       LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npq_file'),  #FUN-A50102
                " WHERE npqsys='AR' AND npq00='2' ",
                "   AND npq01=? ",
                "   AND npq011=1 "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
       PREPARE del_npq_ar FROM l_sql
       EXECUTE del_npq_ar USING g_oma01
       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('del npq(AR):',SQLCA.SQLCODE,1)     #NO.FUN-710046
          LET g_showmsg=2,"/",g_oma01              #NO.FUN-710046 
          CALL s_errmsg('npq00,npq01',g_showmsg,'del npq(AR):',SQLCA.SQLCODE,1) #NO.FUN-710046 
          LET g_success='N'
       END IF
    END IF   #CHI-B40063 add

    #FUN-B40056--add--str--
    #刪除現金流量表
    LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'tic_file'),
              " WHERE tic04 = '",g_oma01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
    PREPARE del_tic_ar FROM l_sql
    EXECUTE del_tic_ar
    IF SQLCA.SQLCODE THEN
        LET g_showmsg=2,"/",g_oma01              
        CALL s_errmsg('npq00,npq01',g_showmsg,'del tic(AR):',SQLCA.SQLCODE,1) 
        LET g_success='N'
    END IF
    #FUN-B40056--add--end--
   END IF
   IF i <> p_last THEN
        #刪除應付帳款單頭(apa_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apa_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'apa_file'),  #FUN-A50102
                  " WHERE apa01= ? ",
                  "   AND apa44 IS NULL "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
        PREPARE del_apa FROM l_sql
        EXECUTE del_apa USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del apa:',SQLCA.SQLCODE,1)       #NO.FUN-710046
         CALL s_errmsg('apa01',g_apa01,'del apa:',SQLCA.SQLCODE,1) #NO.FUN-710046 
           LET g_success='N' 
        END IF
        #刪除應付帳款單頭(apb_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apb_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'apb_file'),  #FUN-A50102
                  " WHERE apb01= ? " 
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
        PREPARE del_apb FROM l_sql
        EXECUTE del_apb USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del apb:',SQLCA.SQLCODE,1)          #NO.FUN-710046
         CALL s_errmsg('apb01',g_apa01,'del apb:',SQLCA.SQLCODE,1) #NO.FUN-710046 
         LET g_success='N' 
        END IF
 
        #No.TQC-7C0019 -----begin-----
        #刪除應付多帳期資料(apc_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apc_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'apc_file'),  #FUN-A50102
                  " WHERE apc01= ? " 
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
        PREPARE del_apc FROM l_sql
        EXECUTE del_apc USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del apc:',SQLCA.SQLCODE,1)          #NO.FUN-710046
         CALL s_errmsg('apc01',g_apa01,'del apc:',SQLCA.SQLCODE,1) #NO.FUN-710046 
         LET g_success='N' 
        END IF
        #No.TQC-7C0019 -----end-----
 
       #---------------- no:3497 01/09/07 ---------------------
       #更新rvv23(入庫單之已請款匹配量)
      #LET l_sql = " UPDATE ",p_dbs," rvv_file SET rvv23 = 0 ",
       #LET l_sql = " UPDATE ",l_dbs_tra," rvv_file SET rvv23 = 0 ", #FUN-980092
       LET l_sql = " UPDATE ",cl_get_target_table(l_plant,'rvv_file'),  #FUN-A50102
                     "  SET rvv23 = 0 ",
                   "  WHERE rvv01 = ? "
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
       PREPARE upd_rvv23 FROM l_sql
       EXECUTE upd_rvv23 USING g_rvu01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd rvv23:',STATUS,1) LET g_success='N' 
         CALL s_errmsg('rvv01',g_rvu01,'upd rvv23:',STATUS,1) LET g_success='N' #NO.FUN-710046 
       END IF
       #---------------------------------------------------------
      IF p_apy.apydmy3 = 'Y' THEN
       #刪除分錄底稿單頭檔(npp_file)--AP
       #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npp_file",
       LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npp_file'),  #FUN-A50102
                 " WHERE nppsys='AP' AND npp00='1' ",
                 "   AND npp01=? ",
                 "   AND npp011=1 ",
                 "   AND nppglno IS NULL "
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
       PREPARE del_npp_ap FROM l_sql
       EXECUTE del_npp_ap USING g_apa01
       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del npp(AP):',SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF
       #CHI-B40063 add --start--
       LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'npq_file'),
                 " WHERE npqsys='AP' AND npq00='1' ",
                 "   AND npq01=? ",
                 "   AND npq011=1 " 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
       PREPARE sel_npq_ap FROM l_sql
       LET l_cnt = 0
       EXECUTE sel_npq_ap USING g_apa01 INTO l_cnt
       IF l_cnt > 0 THEN 
       #CHI-B40063 add --end--
          #刪除分錄底稿單身檔(npq_file)--AP
          #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",
          LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npq_file'),  #FUN-A50102
                    " WHERE npqsys='AP' AND npq00='1' ",
                    "   AND npq01=? ",
                    "   AND npq011=1 "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102 
          PREPARE del_npq_ap FROM l_sql
          EXECUTE del_npq_ap USING g_apa01
          IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('del npq(AP):',SQLCA.SQLCODE,1)  #NO.FUN-710046
          LET g_showmsg=1,"/",g_apa01              #NO.FUN-710046 
          CALL s_errmsg('npq00,npq01',g_showmsg,'del npq(AR):',SQLCA.SQLCODE,1) #NO.FUN-710046 
             LET g_success='N'
          END IF
       END IF   #CHI-B40063 add

       #FUN-B40056--add--str--
       #刪除現金流量表
       LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'tic_file'),
                 " WHERE tic04 = '",g_apa01,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE del_tic_ap FROM l_sql
       EXECUTE del_tic_ap
       IF SQLCA.SQLCODE THEN
          LET g_showmsg=1,"/",g_apa01             
          CALL s_errmsg('npq00,npq01',g_showmsg,'del tic(AR):',SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF
       #FUN-B40056--add--end--
      END IF
   END IF
END FUNCTION
 
FUNCTION p890_getno(i) 
  DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(500)
  DEFINE i     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
     IF i <> p_last THEN
       #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ",
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092
        LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'),  #FUN-A50102
                    "  WHERE rvu99 ='",g_oha.oha99,"'",
                    "    AND rvu00 = '3' "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rvu01_pre FROM l_sql
        DECLARE rvu01_cs CURSOR FOR rvu01_pre
        OPEN rvu01_cs 
        FETCH rvu01_cs INTO g_rvu01                              #倉退單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
#          CALL cl_err(g_msg,SQLCA.SQLCODE,1) #NO.FUN-710046
           LET g_showmsg=g_oha.oha99,"/",'3'  #NO.FUN-710046          
           CALL s_errmsg('rvu99,rvu00',g_showmsg,g_msg,SQLCA.SQLCODE,1) #NO.FUN-710046  
           LET g_success = 'N'
        END IF
 
 
        #LET l_sql = " SELECT apa01 FROM ",l_dbs_new CLIPPED,"apa_file ",
        LET l_sql = " SELECT apa01 FROM ",cl_get_target_table(l_plant_new,'apa_file'),  #FUN-A50102
                    "  WHERE apa99 ='",g_oha.oha99,"'",
                    "    AND apa00 = '21' "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE apa01_pre FROM l_sql
        DECLARE apa01_cs CURSOR FOR apa01_pre
        OPEN apa01_cs 
        FETCH apa01_cs INTO g_apa01                              #付款單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch apa01_cs'
#          CALL cl_err(g_msg,SQLCA.SQLCODE,1)    #NO.FUN-710046
           LET g_showmsg=g_oha.oha99,"/",'3'     #NO.FUN-710046          
           CALL s_errmsg('apa99,apa00',g_showmsg,g_msg,SQLCA.SQLCODE,1) #NO.FUN-710046  
           LET g_success = 'N'
        END IF
#       LET AP_t1=g_apa01[1,3]
        LET AP_t1=s_get_doc_no(g_apa01)     #No.FUN-550070
     END IF
 
     #LET l_sql = " SELECT oma01 FROM ",l_dbs_new CLIPPED,"oma_file ",
     LET l_sql = " SELECT oma01 FROM ",cl_get_target_table(l_plant_new,'oma_file'),  #FUN-A50102
                 "  WHERE oma99 ='",g_oha.oha99,"'",
                 "    AND oma00 = '21' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE oma01_pre FROM l_sql
     DECLARE oma01_cs CURSOR FOR oma01_pre
     OPEN oma01_cs 
     FETCH oma01_cs INTO g_oma01                              #折讓單
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_new CLIPPED,'fetch oma01_cs'
#       CALL cl_err(g_msg,SQLCA.SQLCODE,1) #NO.FUN-710046
        LET g_showmsg=g_oha.oha99,"/",'21'  #NO.FUN-710046          
        CALL s_errmsg('oma99,oma00',g_showmsg,g_msg,SQLCA.SQLCODE,1) #NO.FUN-710046  
        LET g_success = 'N'
     END IF
#    LET AR_t1=g_oma01[1,3]
     LET AR_t1=g_oma01        #No.FUN-550070   #MOD-8B0085 mark
     LET AR_t1=s_get_doc_no(g_oma01)           #MOD-8B0085
END FUNCTION
