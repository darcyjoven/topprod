# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp855.4gl
# Descriptions...: 三角貿易應收/應付帳款拋轉還原作業(逆拋)
# Date & Author..: FUN-710019 06/12/27 BY yiting
# Modify.........: NO.FUN-710046 07/01/24 BY bnlent 錯誤訊息匯整 
# Modify.........: NO.TQC-740133 07/04/19 BY yiting 需考慮有中斷點設定
# Modify.........: NO.TQC-7C0019 07/12/05 BY zhangmin刪除應收/應付單時同時刪除多帳期資料
# Modify.........: NO.TQC-7C0146 07/12/18 BY claire 需考慮中斷點後已經產生應收/應付
# Modify.........: NO.MOD-830055 08/03/07 BY claire 代採出貨單不應被排除
# Modify.........: NO.CHI-920010 09/04/29 BY ve007 1.產生ap分錄底稿應要判斷單別是否有要拋總帳
                                                  #2.ap分錄底稿產生后，應要判斷底稿的正確性
                                                  #3.多角還原時，應判斷單據是否產生底稿在決定刪除
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.MOD-990104 09/09/14 BY Dido 錯誤時增加整體錯誤變數應一併變更 
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No:FUN-A50102 10/06/12 by lixh1  跨庫統一用cl_get_target_table()實現  
# Modify.........: No:MOD-A90137 10/09/20 By Smapmin 程式段重複
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE tm RECORD
          oga01  LIKE oga_file.oga01
       END RECORD
DEFINE g_poz  RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8187
DEFINE g_poy  RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8187
DEFINE l_dbs_new     LIKE type_file.chr21   #New DataBase Name #No.FUN-680137  VARCHAR(21) 
DEFINE l_dbs_tra     LIKE type_file.chr21   #FUN-980092 
DEFINE l_plant_new   LIKE type_file.chr21   #FUN-980092 
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE g_sw  LIKE type_file.chr1        #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1  LIKE oga_file.oga01
DEFINE g_rva01  LIKE rva_file.rva01     #No.8187
DEFINE g_oga01  LIKE oga_file.oga01     #No.8187
DEFINE g_rvu01  LIKE rvu_file.rvu01     #No.8187
DEFINE g_apa01  LIKE apa_file.apa01     #No.8187
DEFINE g_oma01  LIKE oma_file.oma01     #No.8187
DEFINE p_last   LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE p_last_plant  LIKE poy_file.poy04   #最後一家工廠編號
DEFINE p_last_flag LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_t1        LIKE oay_file.oayslip             #No.FUN-550070        #No.FUN-680137 VARCHAR(5)
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570155        #No.FUN-680137 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    #是否有做語言切換 No.FUN-570155     #No.FUN-680137 VARCHAR(1)
       ls_date         STRING   #->No.FUN-570155  
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE g_oga09     LIKE oga_file.oga09
DEFINE l_c             LIKE type_file.num5    #No.FUN-680137 SMALLINT  #FUN-710019
DEFINE l_poy02         LIKE poy_file.poy02    #FUN-710019
DEFINE p_ooy RECORD LIKE ooy_file.*      #No.CHI-920010
DEFINE p_apy RECORD LIKE apy_file.*      #No.CHI-920010
DEFINE AR_t1,AP_t1  LIKE aba_file.aba00      #No.CHI-920010
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1   = ARG_VAL(1)
   LET tm.oga01  = ARG_VAL(1)
   LET g_bgjob   = ARG_VAL(2)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818       #NO.FUN-6A0094
 
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CLEAR FORM
         #若有傳參數則不用輸入畫面
         IF cl_null(g_argv1) THEN 
            CALL p855_p1()
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL p855_p2()
            CALL s_showmsg()    #NO.FUN-710046
           #IF g_success = 'Y' AND cl_null(g_argv1) THEN   #表示由畫面輸入資料		#MOD-990104 mark
            IF g_totsuccess = 'Y' AND cl_null(g_argv1) THEN   #表示由畫面輸入資料	#MOD-990104
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
           #IF g_success = 'Y' AND NOT cl_null(g_argv1) THEN   #表示為傳參數		#MOD-990104 mark  
            IF g_totsuccess = 'Y' AND NOT cl_null(g_argv1) THEN   #表示為傳參數		#MOD-990104
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p855_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         #CLOSE WINDOW p855_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p855_p2()
         CALL s_showmsg()    #NO.FUN-710046
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
END MAIN
 
#FUN-710019
FUNCTION p855_p1()
 DEFINE l_ac       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 DEFINE l_i,l_flag LIKE type_file.num5          #No.FUN-680137 SMALLINT 
 DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 DEFINE lc_cmd     LIKE type_file.chr1000     #No.FUN-570155   #No.FUN-680137 VARCHAR(500)
 
    OPEN WINDOW p855_w WITH FORM "axm/42f/axmp855" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oga01
 WHILE TRUE
    LET g_action_choice = ''
    LET g_bgjob = 'N'    # FUN-570155
    LET g_oga09 = '4'
    INPUT BY NAME tm.oga01,g_oga09,g_bgjob  WITHOUT DEFAULTS    #NO.FUN-570155
         AFTER FIELD oga01
            IF cl_null(tm.oga01) THEN
               NEXT FIELD oga01
            END IF
            SELECT * INTO g_oga.*
               FROM oga_file
              WHERE oga01=tm.oga01
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('sel oga',STATUS,0)   #No.FUN-660167
               CALL cl_err3("sel","oga_file",tm.oga01,"",STATUS,"","sel oga",0)   #No.FUN-660167
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga10 IS NULL THEN    #帳單編號
               CALL cl_err(g_oga.oga10,'axm-994',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN  #非三角貿易
               CALL cl_err(g_oga.oga901,'axm-406',0)
               NEXT FIELD oga01 
            END IF
            IF (g_oga.oga09<>'4' AND  g_oga.oga09 <> '6') THEN  #非三角貿易
               CALL cl_err(g_oga.oga905,'axm-406',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga905='N' THEN   #未拋轉
               CALL cl_err(g_oga.oga905,'axm-991',0)
               NEXT FIELD oga01 
            END IF
           #IF g_oga.oga906 <>'Y' THEN  #非來源工廠
           #   CALL cl_err(g_oga.oga906,'axm-306',0)
           #   NEXT FIELD oga01 
           #END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()
      ON ACTION locale
#NO.FUN-570155 start-
#         LET g_action_choice='locale'
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
#NO.FUN-570155 end--
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
#NO.FUN-570155 mark--
#   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#   IF cl_sure(0,0) THEN
#      CALL p855_p2()
#      IF g_success = 'Y' THEN
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
# END WHILE
#  CLOSE WINDOW p855_w
#NO.FUN-570155 mark-
 
#NO.FUN-570155 start-
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p855_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axmp855"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axmp855','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.oga01 CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axmp855',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p855_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE 
 END WHILE 
 
#->No.FUN-570155 --end--
END FUNCTION
 
FUNCTION p855_p2()
  DEFINE l_sql  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5        #No.FUN-680137 SMALLINT
  DEFINE l_oma RECORD LIKE oma_file.*
  DEFINE l_apa RECORD LIKE apa_file.*
  DEFINE l_npp RECORD LIKE npp_file.*
  DEFINE l_j    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
         l_msg  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(60)
  DEFINE l_amt  LIKE type_file.num5
 
     #讀取出貨單資料
     SELECT * INTO g_oga.*
       FROM oga_file
      WHERE oga01=tm.oga01  
         AND (oga09='4' OR oga09 = '6')  
         AND oga909='Y'
         AND oga905='Y'
         AND oga906='Y'
         AND oga10 IS NOT NULL 
         AND ogaconf='Y'
     IF SQLCA.SQLCODE<>0  THEN
        CALL cl_err3("sel","oga_file",tm.oga01,"",STATUS,"","sel oga",1)   #No.FUN-660167
        RETURN
     END IF
#NO.FUN-570155 start--
   IF g_bgjob = 'N' THEN
       CALL cl_wait() 
   END IF 
#NO.FUN-570155 end--
   LET g_success='Y'
{
  #保留此段, 若條件改成construct多筆時只要把mark拿掉
  #讀取符合條件之三角貿易訂單資料
  LET l_sql="SELECT * FROM oga_file ",
            " WHERE oga01 ='",tm.oga01,"' ",
             " AND oga09='4' ",
             " AND oga909='Y' ",
             " AND oga905='Y' ",
             " AND oga906='Y' ",
             " AND oga10 IS NOT NULL ",
             " AND ogaconf='Y' "      #已確認之訂單才可轉
  PREPARE p855_p1 FROM l_sql 
  IF STATUS THEN CALL cl_err('pre1',STATUS,1) END IF
  LET g_success='Y' 
  DECLARE p855_curs1 CURSOR FOR p855_p1
  FOREACH p855_curs1 INTO g_oga.*
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err('sel oga',STATUS,1) 
        EXIT FOREACH
     END IF
}
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
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)   #No.FUN-660167
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN 
         CALL cl_err(g_oea.oea904,'tri-009',1)
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.poz011 = '1' THEN
        CALL cl_err('','axm-079',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF g_poz.poz19 ='Y' THEN 
         SELECT COUNT(*) INTO l_amt
           FROM poy_file 
          WHERE poy01 = g_poz.poz01 
            AND poy04 = g_poz.poz18 
     END IF 
     IF g_poz.poz011 = '2' THEN
        IF g_poz.poz19 = 'N' OR (g_poz.poz19 = 'Y' AND l_amt = 0 ) THEN
            CALL cl_err('','axm-080',1)
            LET g_success = 'N'
            RETURN
        END IF
     END IF
     CALL s_mtrade_last_plant(g_oea.oea904) 
          RETURNING p_last,p_last_plant       #記錄最後一家
 
     IF p_last_plant != g_plant THEN
         CALL cl_err('','axm-410',1)
         CLOSE WINDOW p845_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
     #TQC-7C0146-begin-add
     ELSE 
     IF g_poz.poz19 ='Y' THEN 
        LET l_c = 0 
        SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poz.poz18
       #LET l_dbs_new = l_azp.azp03 CLIPPED,"."  #TQC-950032 MARK                                                                   
        LET l_dbs_new = s_dbstring(l_azp.azp03)  #TQC-950032 ADD  
     #   LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",   #FUN-50102
        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( g_poz.poz18, 'oma_file' ),   #FUN-A50102
                    "  WHERE oma99 ='",g_oga.oga99,"'",
                    "    AND oma00 = '12' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_poz.poz18 ) RETURNING l_sql   #FUN-A50102
        PREPARE oma01_pre1 FROM l_sql
        DECLARE oma01_cs1 CURSOR FOR oma01_pre1
        OPEN oma01_cs1 
        FETCH oma01_cs1 INTO l_c                              #A/R
        IF l_c = 0 THEN
       # LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ", #FUN-A50102
        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( g_poz.poz18, 'apa_file' ),   #FUN-A50102
                    "  WHERE apa99 ='",g_oga.oga99,"'",
                    "    AND apa00 = '11' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_poz.poz18 ) RETURNING l_sql   #FUN-A50102
        PREPARE apa01_pre1 FROM l_sql
        DECLARE apa01_cs1 CURSOR FOR apa01_pre1
        OPEN apa01_cs1 
        FETCH apa01_cs1 INTO l_c                             #A/P
        END IF 
        IF l_c > 0 THEN 
           CALL cl_err('','axm-932',1)
           LET g_success = 'N'
           RETURN
        END IF
        LET l_c = 0 
     END IF
     #TQC-7C0146-end-add
     END IF
     CALL s_showmsg_init()    #No.FUN-710046
     FOR i = p_last TO 0 STEP -1  
     #No.FUN-710046--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
     #No.FUN-710046--End-
           #得到廠商/客戶代碼及database
           CALL p855_azp(i)      
#NO.TQC-740133 start---
           SELECT poy02 INTO l_poy02
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設定營運中心
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           IF (g_poz.poz19 = 'Y' AND l_c > 0) THEN    #己設立中斷點
               IF (g_poy.poy02 <= l_poy02) THEN    
                   EXIT FOR   
               END IF
           END IF
           CALL p855_getno(i)                 #No.8187
           #No.CHI-920010 --begin--
          #讀取AR,AP單別檔資料
          LET l_sql = "SELECT * ",
              #        " FROM ",l_dbs_new CLIPPED,"ooy_file ",#FUN-A50102
                      " FROM ",cl_get_target_table( g_plant_new, 'ooy_file' ),   #FUN-A50102
                      " WHERE ooyslip = '",AR_t1,"' "     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
          PREPARE ooy_p1 FROM l_sql 
          IF STATUS THEN CALL s_errmsg('ooyslip',AR_t1,'ooy_p1',STATUS,1) END IF 
          DECLARE ooy_c1 CURSOR FOR ooy_p1
          OPEN ooy_c1
          FETCH ooy_c1 INTO p_ooy.* 
          CLOSE ooy_c1
          IF i != p_last THEN   ##最後一家工廠不必拋AP
             LET l_sql = "SELECT * ",
                     #    " FROM ",l_dbs_new CLIPPED,"apy_file ",    #FUN-A50102
                         " FROM ",cl_get_target_table( g_plant_new, 'apy_file' ),   #FUN-A50102
                         " WHERE apyslip = '",AP_t1,"' "      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
             PREPARE apy_p1 FROM l_sql 
             IF STATUS THEN CALL s_errmsg('apyslip',AP_t1,'apy_p1',STATUS,1) END IF  
             DECLARE apy_c1 CURSOR FOR apy_p1
             OPEN apy_c1
             FETCH apy_c1 INTO p_apy.* 
             CLOSE apy_c1
          END IF
          #No.CHI-920010 --end--
           CALL p855_p3(i)
     END FOR 
END FUNCTION
#NO.TQC-740133 end--------------
 
FUNCTION p855_p3(i)
  DEFINE l_sql  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5        #No.FUN-680137 SMALLINT
  DEFINE l_oma RECORD LIKE oma_file.*
  DEFINE l_apa RECORD LIKE apa_file.*
  DEFINE l_npp RECORD LIKE npp_file.*
  DEFINE l_j    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
         l_msg  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(60)
  DEFINE l_amt  LIKE type_file.num5
 
           #***************判斷已沖帳或已拋傳票否*************#
           #判斷應收帳款是否已拋轉至總帳
          # LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," oma_file",   #FUN-A50102
           LET l_sql = "SELECT * FROM ",cl_get_target_table( g_plant_new, 'oma_file' ),   #FUN-A50102
                       " WHERE oma01 = '",g_oma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
           PREPARE oma_pre FROM l_sql
           DECLARE oma_cs CURSOR FOR oma_pre
           OPEN oma_cs 
           FETCH oma_cs INTO l_oma.*
           IF l_oma.oma33 IS NOT NULL THEN
           #No.FUN-710046--Begin--
           #  CALL cl_err('oma33:','axm-898',1)
           #  LET g_success='N' EXIT FOR
              CALL s_errmsg('','','oma33:','axm-898',1)
              #LET g_success='N' CONTINUE FOR
              LET g_success='N' #NO.TQC-740133 
           #No.FUN-710046--End--
           END IF
           #-----MOD-A90137---------
           #IF l_oma.oma33 IS NOT NULL THEN
           ##No.FUN-710046--Begin--
           ##  CALL cl_err('oma33:','axm-898',1)
           ##  LET g_success='N' EXIT FOR
           #   CALL s_errmsg('','','oma33:','axm-898',1)
           #   #LET g_success='N' CONTINUE FOR
           #   LET g_success='N' #NO.TQC-740133
           ##No.FUN-710046--End--
           #END IF
           #-----END MOD-A90137-----
           IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN #已沖帳
           #No.FUN-710046--Begin--
           #  CALL cl_err('oma55:','agl-905',1)
           #  LET g_success='N' EXIT FOR
              CALL s_errmsg('','','oma55:','agl-905',1)
              #LET g_success='N' CONTINUE FOR
              LET g_success='N' #NO.TQC-740133
           #No.FUN-710046--End--
           END IF
            #MOD-530498
           IF NOT cl_null(l_oma.oma10) THEN
           #No.FUN-710046--Begin--
           #  CALL cl_err('oma10:','arm-015',1)
           #  LET g_success='N' EXIT FOR
              CALL s_errmsg('','','oma10:','arm-015',1)
              #LET g_success='N' CONTINUE FOR
              LET g_success='N' #NO.TQC-740133
           #No.FUN-710046--End--
           END IF
           #--
        
           IF i != p_last THEN   ##最後一家工廠不必拋AP
              #判斷應付帳款是否已拋轉至總帳
             # LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," apa_file",   #FUN-A50102
              LET l_sql = "SELECT * FROM ",cl_get_target_table( g_plant_new, 'apa_file' ),   #FUN-A50102
                          " WHERE apa01 = '",g_apa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
              PREPARE apa_pre FROM l_sql
              DECLARE apa_cs CURSOR FOR apa_pre
              OPEN apa_cs 
              FETCH apa_cs INTO l_apa.*
              IF l_apa.apa44 IS NOT NULL THEN
              #No.FUN-710046--Begin--
              #  CALL cl_err('apa44:','axm-898',0)
              #  LET g_success='N' EXIT FOR
                 CALL s_errmsg('','','apa44:','axm-898',1)
                 #LET g_success = 'N' CONTINUE FOR
                 LET g_success = 'N'  #NO.TQC-740133
              #No.FUN-710046--End--
              END IF
              IF l_apa.apa35>0 OR l_apa.apa35f>0    #已沖帳
                 OR l_apa.apa65>0 OR l_apa.apa65f>0 THEN
              #No.FUN-710046--Begin--
              #  CALL cl_err('oma35:','aap-255',0)
              #  LET g_success='N' EXIT FOR
                 CALL s_errmsg('','','oma35:','aap-255',1)
                 #LET g_success='N' CONTINUE FOR
                 LET g_success='N' #NO.TQC-740133
              #No.FUN-710046--End--
              END IF
           END IF
           #判斷分錄底稿是否已拋轉至總帳
         #  LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," npp_file ",   #FUN-A50102
           LET l_sql = "SELECT * FROM ",cl_get_target_table( g_plant_new, 'npp_file' ),   #FUN-A50102
                       " WHERE nppsys='AR' AND npp00='2' ",
                       "   AND npp01 = '",g_oma01,"'",
                       "   AND npp011=1 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
           PREPARE npp_p1 FROM l_sql
           DECLARE npp_c1 CURSOR FOR npp_p1
           OPEN npp_c1 
           FETCH npp_c1 INTO l_npp.*
           IF l_npp.nppglno IS NOT NULL THEN
           #No.FUN-710046--Begin--
           #  CALL cl_err('nppglno(AR):','axm-898',0)
           #  LET g_success='N' EXIT FOR
              CALL s_errmsg('','','nppglno(AR):','axm-898',1)
              #LET g_success='N' CONTINUE FOR
              LET g_success='N' #NO.TQC-740133
           #No.FUN-710046--End--
           END IF
           IF i != p_last THEN    ##最後一家工廠不必拋AP
              #判斷分錄底稿是否已拋轉至總帳
            #  LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," npp_file ",   #FUN-A50102
              LET l_sql = "SELECT * FROM ", cl_get_target_table( g_plant_new, 'npp_file' ),   #FUN-A50102
                          " WHERE nppsys='AP' AND npp00='1' ",
                          "   AND npp01 = '",g_apa01,"'",
                          "   AND npp011=1 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
              PREPARE npp_p2 FROM l_sql
              DECLARE npp_c2 CURSOR FOR npp_p2
              OPEN npp_c2 
              FETCH npp_c2 INTO l_npp.*
              IF l_npp.nppglno IS NOT NULL THEN
              #No.FUN-710046--Begin--
              #  CALL cl_err('nppglno(AP):','axm-898',0)
              #  LET g_success='N' EXIT FOR
                 CALL s_errmsg('','','nppglno(AP):','axm-898',1)
                 #LET g_success='N' CONTINUE FOR
                 LET g_success='N' #NO.TQC-740133
              #No.FUN-710046--End--
              END IF
           END IF
           #****************************************************#
           #還原各廠之應收/應付資料
           #CALL p855_pro(l_dbs_new,i)    #FUN-A50102
           CALL p855_pro(g_plant_new,i)   #FUN-A50102           
     #END FOR    #NO.TQC-740133 mark
     #No.FUN-710046--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
    #No.FUN-710046--End--
 
 
END FUNCTION
 
FUNCTION p855_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,         #No.FUN-680137 SMALLINT
         l_sql1  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
     ##-------------取得當站資料庫----------------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
    #LET l_dbs_new = l_azp.azp03 CLIPPED,"."   #TQC-950032 MARK                                                                     
     LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950032 ADD   
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET l_plant_new = g_poy.poy04
     LET g_plant_new = l_azp.azp01
#     CALL s_gettrandbs()
#     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
END FUNCTION
 
#FUNCTION p855_pro(p_dbs,i)     #FUN-A50102
FUNCTION p855_pro(p_plant,i)    #FUN-A50102
# DEFINE p_dbs  LIKE type_file.chr21         #No.FUN-680137 VARCHAR(21)    #FUN-A50102
 DEFINE p_plant  LIKE azp_file.azp01        #FUN-A50102
 DEFINE i      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 DEFINE l_sql  LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(600)
     #刪除應收帳款單頭(oma_file)
    # LET l_sql="DELETE FROM ",p_dbs CLIPPED,"oma_file",    #FUN-A50102
     LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'oma_file' ),   #FUN-A50102
              " WHERE oma01= ? ",
              "   AND oma33 IS NULL "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
     PREPARE del_oma FROM l_sql
     EXECUTE del_oma USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     #No.FUN-710046--Begin--
     #  CALL cl_err('del oma:',SQLCA.SQLCODE,1)
        CALL s_errmsg('','','del oma:',SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success='N' 
     END IF
     #刪除應收帳款單頭(omb_file)
   #  LET l_sql="DELETE FROM ",p_dbs CLIPPED,"omb_file",    #FUN-A50102
     LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'omb_file' ),   #FUN-A50102
              " WHERE omb01= ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
     PREPARE del_omb FROM l_sql
     EXECUTE del_omb USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     #No.FUN-710046--Begin--
     #  CALL cl_err('del omb:',SQLCA.SQLCODE,1)
        CALL s_errmsg('','','del omb:',SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success='N' 
     END IF
 
     #NO.TQC-7C0019 ---begin---
     #刪除應收多帳期資料(omc_file)
    # LET l_sql="DELETE FROM ",p_dbs CLIPPED,"omc_file",    #FUN-A50102
     LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'omc_file' ),   #FUN-A50102
              " WHERE omc01= ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
     PREPARE del_omc FROM l_sql
     EXECUTE del_omc USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('','','del omc:',SQLCA.SQLCODE,1)
        LET g_success='N' 
     END IF
     #NO.TQC-7C0019 ---end---
      
     #更新出貨單單頭檔之帳單編號
    #LET l_sql="UPDATE ",p_dbs CLIPPED,"oga_file",
    # LET l_sql="UPDATE ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092   #FUN-A50102
      LET l_sql="UPDATE ",cl_get_target_table( p_plant, 'oga_file' ),   #FUN-A50102
                " SET oga10 = NULL ",
                " WHERE oga01 = ?  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       #  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102    
     PREPARE upd_oga2 FROM l_sql
     EXECUTE upd_oga2 USING g_oga01
     IF SQLCA.sqlcode<>0 THEN
     #No.FUN-710046--Begin--
     #  CALL cl_err('upd oga10:',SQLCA.sqlcode,1)
        CALL s_errmsg('','','upd oga10:',SQLCA.sqlcode,1)
     #No.FUN-710046--End--
        LET g_success = 'N'
     END IF
     IF p_ooy.ooydmy1 = 'Y' THEN              #No.CHI-920010
     #刪除分錄底稿單頭檔(npp_file)--AR
   #  LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npp_file",   #FUN-A50102
     LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'npp_file' ),   #FUN-A50102
              " WHERE nppsys='AR' AND npp00='2' ",
              "   AND npp01=? ",
              "   AND npp011=1 ",
              "   AND nppglno IS NULL "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
     PREPARE del_npp_ar FROM l_sql
     EXECUTE del_npp_ar USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     #No.FUN-710046--Begin--
     #  CALL cl_err('del npp(AR):',SQLCA.SQLCODE,1)
        CALL s_errmsg('','','del npp(AR):',SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success='N' 
     END IF
     #刪除分錄底稿單身檔(npq_file)--AR
    # LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",    #FUN-A50102
     LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'npq_file' ),   #FUN-A50102
              " WHERE npqsys='AR' AND npq00='2' ",
              "   AND npq01=? ",
              "   AND npq011=1 " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
     PREPARE del_npq_ar FROM l_sql
     EXECUTE del_npq_ar USING g_oma01
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     #No.FUN-710046--Begin--
     #  CALL cl_err('del npq(AR):',SQLCA.SQLCODE,1)
        CALL s_errmsg('','','del npq(AR):',SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success='N' 
     END IF

     #FUN-B40056--add--str--
     #刪除現金流量表
     LET l_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
               " WHERE tic04 = '",g_oma01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     PREPARE del_tic_ar FROM l_sql
     EXECUTE del_tic_ar
     IF SQLCA.SQLCODE THEN
        CALL s_errmsg('','','del tic(AR):',SQLCA.SQLCODE,1)
        LET g_success='N'
     END IF
     #FUN-B40056--add--end--
     END IF                  #No.CHI-920010
     IF i <> p_last  THEN        #最後一家工廠不必拋 AP
        #刪除應付帳款單頭(apa_file)
       # LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apa_file",  #FUN-A50102
        LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'apa_file' ),   #FUN-A50102 
                  " WHERE apa01= ? ",
                  "   AND apa44 IS NULL "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
        PREPARE del_apa FROM l_sql
        EXECUTE del_apa USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        #No.FUN-710046--Begin--
        #  CALL cl_err('del apa:',SQLCA.SQLCODE,1)
           CALL s_errmsg('','','del apa:',SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success='N' 
        END IF
        #刪除應付帳款單身(apb_file)
       # LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apb_file",  #FUN-A50102
        LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'apb_file' ),   #FUN-A50102
                  " WHERE apb01= ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
        PREPARE del_apb FROM l_sql
        EXECUTE del_apb USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        #No.FUN-710046--Begin--
        #  CALL cl_err('del apb:',SQLCA.SQLCODE,1)
           CALL s_errmsg('','','del apb:',SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success='N' 
        END IF
 
        #NO.TQC-7C0019 ---begin---
        #刪除應付多帳期資料(apc_file)
       # LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apc_file",   #FUN-A50102
        LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'apc_file' ),   #FUN-A50102
                  " WHERE apc01= ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
        PREPARE del_apc FROM l_sql
        EXECUTE del_apc USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
           CALL s_errmsg('','','del apc:',SQLCA.SQLCODE,1)
           LET g_success='N' 
        END IF
        #NO.TQC-7C0019 ---end---
 
        #---------------- no:3497 01/09/07 ---------------------
        #更新rvb06(驗收單之已請款量)
       #LET l_sql = " UPDATE ",p_dbs," rvb_file SET rvb06 = 0 ",
       # LET l_sql = " UPDATE ",l_dbs_tra," rvb_file SET rvb06 = 0 ", #FUN-980092    #FUN-A50102
        LET l_sql = " UPDATE ",cl_get_target_table( p_plant, 'rvb_file' ), " SET rvb06 = 0 ",  #FUN-A50102
                    "  WHERE rvb01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-A50102         
        PREPARE upd_rvb06 FROM l_sql
        EXECUTE upd_rvb06 USING g_rva01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        #No.FUN-710046--Begin--
        #  CALL cl_err('upd rvb06:',STATUS,1) LET g_success='N'
           CALL s_errmsg('','','upd rvb06:',STATUS,1) LET g_success='N'
        #No.FUN-710046--End--
        END IF
 
        #更新rvv23(入庫單之已請款匹配量)
       #LET l_sql = " UPDATE ",p_dbs," rvv_file SET rvv23 = 0 ",
        #LET l_sql = " UPDATE ",l_dbs_tra," rvv_file SET rvv23 = 0 ", #FUN-980092   #FUN-A50102
        LET l_sql = " UPDATE ",cl_get_target_table( p_plant, 'rvv_file' ), " SET rvv23 = 0 ",  #FUN-A50102
                    "  WHERE rvv01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        # CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102        
        PREPARE upd_rvv23 FROM l_sql
        EXECUTE upd_rvv23 USING g_rvu01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        #No.FUN-710046--Begin--
        #  CALL cl_err('upd rvv23:',STATUS,1) LET g_success='N'
           CALL s_errmsg('','','upd rvv23:',STATUS,1) LET g_success='N'
        #No.FUN-710046--End--
        END IF
        IF p_apy.apydmy3 = 'Y' THEN              #NO.CHI-920010
        #---------------------------------------------------------
        #刪除分錄底稿單頭檔(npp_file)--AP
    #    LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npp_file",   #FUN-A50102
        LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'npp_file' ),   #FUN-A50102
                  " WHERE nppsys='AP' AND npp00='1' ",
                  "   AND npp01=? ",
                  "   AND npp011=1 ",
                  "   AND nppglno IS NULL "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
        PREPARE del_npp_ap FROM l_sql
        EXECUTE del_npp_ap USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        #No.FUN-710046--Begin--
        #  CALL cl_err('del npp(AP):',SQLCA.SQLCODE,1)
           CALL s_errmsg('','','del npp(AP):',SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success='N' 
        END IF
        #刪除分錄底稿單身檔(npq_file)--AP
      #  LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",   #FUN-A50102
        LET l_sql="DELETE FROM ",cl_get_target_table( p_plant, 'npq_file' ),   #FUN-A50102
                  " WHERE npqsys='AP' AND npq00='1' ",
                  "   AND npq01=? ",
                  "   AND npq011=1 " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
        PREPARE del_npq_ap FROM l_sql
        EXECUTE del_npq_ap USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        #No.FUN-710046--Begin--
        #  CALL cl_err('del npq(AP):',SQLCA.SQLCODE,1)
           CALL s_errmsg('','','del npq(AP):',SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success='N' 
        END IF

        #FUN-B40056--add--str--
        #刪除現金流量表
        LET l_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
                  " WHERE tic04 = '",g_apa01,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
        PREPARE del_tic_ap FROM l_sql
        EXECUTE del_tic_ap
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg('','','del tic(AP):',SQLCA.SQLCODE,1)
           LET g_success='N'
        END IF
        #FUN-B40056--add--end--
       END IF         #No.CHI-920010 
     END IF
END FUNCTION
 
FUNCTION p855_getno(i) 
  DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(500)
  DEFINE i     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
     IF i <> p_last THEN
       #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ",
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092  #FUN-A50102
        LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table( g_plant_new, 'rvu_file' ),   #FUN-A50102
                    "  WHERE rvu99 ='",g_oga.oga99,"'",
                    "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       #  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102       
        PREPARE rvu01_pre FROM l_sql
        DECLARE rvu01_cs CURSOR FOR rvu01_pre
        OPEN rvu01_cs 
        FETCH rvu01_cs INTO g_rvu01                              #入庫單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
        #No.FUN-710046--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success = 'N'
        END IF
 
       #LET l_sql = " SELECT rva01 FROM ",l_dbs_new CLIPPED,"rva_file ",
       # LET l_sql = " SELECT rva01 FROM ",l_dbs_tra CLIPPED,"rva_file ", #FN-980092   #FUN-A50102
        LET l_sql = " SELECT rva01 FROM ",cl_get_target_table( g_plant_new, 'rva_file' ),   #FUN-A50102
                    "  WHERE rva99 ='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rva01_pre FROM l_sql
        DECLARE rva01_cs CURSOR FOR rva01_pre
        OPEN rva01_cs 
        FETCH rva01_cs INTO g_rva01                              #入庫單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rva01_cs'
        #NO.FUN-710046--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success = 'N'
        END IF
        #LET l_sql = " SELECT apa01 FROM ",l_dbs_new CLIPPED,"apa_file ",   #FUN-A50102
        LET l_sql = " SELECT apa01 FROM ",cl_get_target_table( g_plant_new, 'apa_file' ),   #FUN-A50102
                    "  WHERE apa99 ='",g_oga.oga99,"'",
                    "    AND apa00 = '11' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
        PREPARE apa01_pre FROM l_sql
        DECLARE apa01_cs CURSOR FOR apa01_pre
        OPEN apa01_cs 
        FETCH apa01_cs INTO g_apa01                              #A/P
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch apa01_cs'
        #No.FUN-710046--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success = 'N'
        END IF
        LET AP_t1=s_get_doc_no(g_apa01)               #No.CHI-920010
     END IF
 
    #LET l_sql = " SELECT oga01 FROM ",l_dbs_new CLIPPED,"oga_file ",
    # LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092   #FUN-A50102
     LET l_sql = " SELECT oga01 FROM ",cl_get_target_table( g_plant_new, 'oga_file' ),   #FUN-A50102
                 "  WHERE oga99 ='",g_oga.oga99,"'",
                 "    AND oga09 = '",g_oga09,"'"   #MOD-830055
                #"    AND oga09 = '4' "            #MOD-830055
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        # CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102        
     PREPARE oga01_pre FROM l_sql
     DECLARE oga01_cs CURSOR FOR oga01_pre
     OPEN oga01_cs 
     FETCH oga01_cs INTO g_oga01                              #出貨單
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'
     #No.FUN-710046--Begin--
     #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success = 'N'
     END IF
     
    # LET l_sql = " SELECT oma01 FROM ",l_dbs_new CLIPPED,"oma_file ",    #FUN-A50102
     LET l_sql = " SELECT oma01 FROM ",cl_get_target_table( g_plant_new, 'oma_file' ),   #FUN-A50102
                 "  WHERE oma99 ='",g_oga.oga99,"'",
                 "    AND oma00 = '12' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, g_plant_new ) RETURNING l_sql   #FUN-A50102
     PREPARE oma01_pre FROM l_sql
     DECLARE oma01_cs CURSOR FOR oma01_pre
     OPEN oma01_cs 
     FETCH oma01_cs INTO g_oma01                              #A/R
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_new CLIPPED,'fetch oma01_cs'
     #No.FUN-710046--Begin--
     #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success = 'N'
     END IF
     LET AR_t1=s_get_doc_no(g_oma01)           #No.CHI-920010
END FUNCTION
