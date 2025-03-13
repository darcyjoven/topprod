# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmp885.4gl
# Descriptions...: 三角貿易銷退應收/應付帳款拋轉作業(逆拋)
# Date & Author..: FUN-710019 07/01/05 BY yiting 
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# Modify.........: NO.TQC-7C0157 07/12/21 BY yiting 資料庫抓取錯誤
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.FUN-980010 09/08/28 By TSD.apple call axmp886 需要poy04 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/22 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat     #No.FUN-680137 DATE  # 應收立帳日
DEFINE p_date           LIKE type_file.num5    #No.FUN-680137 DATE  # 應收立帳日
DEFINE g_argv1		LIKE ima_file.ima01   #No.FUN-680137 VARCHAR(40) #FUN-710019 
DEFINE g_oha   RECORD LIKE oha_file.*
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_poz   RECORD LIKE poz_file.*       #流程代碼資料(單頭) No.8187
DEFINE g_poy   RECORD LIKE poy_file.*       #流程代碼資料(單身) No.8187
DEFINE n_poy   RECORD LIKE poy_file.*       #流程代碼資料(單身) No.8187
DEFINE p_poy16  LIKE poy_file.poy16,       #AR類別
       p_poy17  LIKE poy_file.poy17,       #AP類別
       p_poy20  LIKE poy_file.poy20,       #申報方式
       p_poy18  LIKE poy_file.poy18,       #AR部門
       p_poy19  LIKE poy_file.poy19        #AP部門
DEFINE p_poy04  LIKE poy_file.poy04        #AR之工廠編號
DEFINE p_poy12  LIKE poy_file.poy12        #發票別
DEFINE p_last_plant  LIKE poy_file.poy04   #最後一家工廠編號
DEFINE g_flow99      LIKE oga_file.oga99  #No.FUN-680137 VARCHAR(17)  #No.8187   #FUN-560043
DEFINE g_sw          LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1) #No.8187
DEFINE g_t1          LIKE oay_file.oayslip              #No.8187  #No.FUN-680137 VARCHAR(05)
DEFINE g_rvu01       LIKE rvu_file.rvu01   #No.8187
DEFINE g_rva01       LIKE rva_file.rva01   #No.8187
DEFINE g_oga01       LIKE oga_file.oga01   #No.8187
DEFINE g_oha01       LIKE oha_file.oha01   #No.8187
DEFINE g_oha05       LIKE oha_file.oha05   #No.8187
DEFINE l_dbs_new     LIKE type_file.chr21   #No.FUN-680137  VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_tra     LIKE type_file.chr21   #FUN-980092 
DEFINE l_plant_new   LIKE type_file.chr21   #FUN-980092 
DEFINE next_dbs      LIKE type_file.chr21   #No.FUN-680137  VARCHAR(21)    #下一家 DataBase Name
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE p_last LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE p_last_flag LIKE type_file.chr1    #最後一家工廠否?  #No.FUN-680137 VARCHAR(1)
DEFINE g_change_lang LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)      #FUN-570155
       ls_date       LIKE type_file.chr8,    #No.FUN-680137 VARCHAR(8)      #FUN-570155
       l_flag        LIKE type_file.chr1         #FUN-570155  #No.FUN-680137 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_msg         LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE i             LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_c           LIKE type_file.num5    #No.FUN-680137 SMALLINT  #FUN-710019
DEFINE l_poy02       LIKE poy_file.poy02    #FUN-710019
 
 
MAIN
   OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL       #FUN-570155
   LET g_argv1=ARG_VAL(1)
 
#FUN-570155 --start--
   LET g_argv1=ARG_VAL(1)
   LET ls_date = ARG_VAL(2)
   LET g_date  = cl_batch_bg_date_convert(ls_date)
   LET g_wc    = ARG_VAL(3)
   LET g_oha05 = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
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
 
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' AND cl_null(g_argv1) THEN
         CALL p885_tm()
         IF cl_sure(21,21) THEN
            CALL cl_wait() 
            BEGIN WORK   
            CALL p885_p()
            IF g_success = 'Y' THEN
               COMMIT WORK               #FUN-710019 
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK             #FUN-710019 
               CALL cl_end2(2) RETURNING l_flag
            END IF
            
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p885_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF 
         CLOSE WINDOW p885_w
      ELSE
         IF NOT cl_null(g_argv1) THEN
            LET g_wc   =" oha01 MATCHES '",g_argv1,"'"
         END IF
         BEGIN WORK
         CALL p885_p()
         IF g_success = 'Y' THEN 
            COMMIT WORK
         ELSE  
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p885_tm()
   DEFINE lc_cmd   LIKE type_file.chr1000 #No.FUN-680137  VARCHAR(500)     #FUN-570155
 
   OPEN WINDOW p885_w WITH FORM "axm/42f/axmp885"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
 
    CLEAR FORM
    CALL cl_opmsg('w')
    WHILE TRUE
       LET g_action_choice = ''
       CONSTRUCT BY NAME g_wc ON oha01,oha02,oha21,oha15 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
          ON ACTION locale
#NO.FUN-570155 start--
#             LET g_action_choice='locale'
             LET g_change_lang = TRUE          #FUN-570155
#NO.FUN-570155 end--
             EXIT CONSTRUCT
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT CONSTRUCT
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup') #FUN-980030
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p885_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
 
       IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
       IF g_wc = ' 1=1'
          THEN CALL cl_err('','9046',0) CONTINUE WHILE
       END IF
       LET g_date=NULL
       CALL cl_opmsg('a')
       LET g_bgjob = 'N'           #FUN-570155
       LET g_oha05 = '2'
 
       INPUT BY NAME g_oha05,g_date,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570155 
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG 
             CALL cl_cmdask()
          ON ACTION locale
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
       END INPUT
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p885_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axmp885'
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
              CALL cl_err('axmp885','9031',1)   
          ELSE
             LET g_wc = cl_replace_str(g_wc,"'","\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " ''",
                          " '",g_date CLIPPED,"'",
                          " '",g_wc CLIPPED,"'",
                          " '",g_oha05 CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('axmp885',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p885_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION p885_p()
  DEFINE l_oma58     LIKE oma_file.oma58
  DEFINE l_cnt LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE ar_t1,ap_t1 LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187
  DEFINE l_x         LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187
  DEFINE l_azp03     LIKE azp_file.azp03
  DEFINE l_omb930    LIKE omb_file.omb930   #FUN-710019
  DEFINE l_apa930    LIKE apa_file.apa930   #FUN-710019
  DEFINE k,l_amt     LIKE type_file.num5    #FUN-710019
 
    LET p_date = g_date  #存所給之應收日
    #讀取符合條件之銷退資料
    LET g_sql=
             "SELECT *",
             "   FROM oha_file",
             "  WHERE oha53>0 AND ohaconf='Y' ",
             "    AND ",g_wc CLIPPED,
             "    AND (oha10 IS NULL OR oha10 = ' ')",
             "    AND oha41 ='Y' ",
             "    AND oha44='Y' ",   
             "    AND oha43='Y' ", #逆拋可拋轉AP,AR No.9422
             "    AND oha50>0 "
    PREPARE p885_prepare FROM g_sql
    DECLARE p885_cs CURSOR WITH HOLD FOR p885_prepare
    LET l_cnt=0
    FOREACH p885_cs INTO g_oha.*
       IF STATUS THEN 
          CALL cl_err('p885(foreach):',STATUS,1) 
          LET g_success='N' EXIT FOREACH 
       END IF
       LET g_flow99 = g_oha.oha99       #No.8187
       #若畫面上之應收日未給則給出貨日
       IF p_date IS NULL THEN LET g_date=g_oha.oha02 END IF
       LET l_cnt = l_cnt +1
 
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
          CALL cl_err3("sel","oga_file",g_oha.oha16,"",STATUS,"","sel oga",1)   #No.FUN-660167
          LET g_success='N'
          RETURN
       END IF
       #讀取該出貨單之訂單
       IF cl_null(g_oga.oga16) THEN
          DECLARE oea_cs CURSOR FOR
           SELECT * FROM oea_file,ogb_file
            WHERE ogb31 = oea01
              AND ogb01 = g_oha.oha16
              AND oeaconf = 'Y' #01/08/16 mandy
          FOREACH oea_cs INTO g_oea.*
            IF SQLCA.sqlcode <> 0 THEN EXIT FOREACH END IF
            EXIT FOREACH
          END FOREACH
       ELSE
          SELECT * INTO g_oea.*
           FROM oea_file
          WHERE oea01 = g_oga.oga16
            AND oeaconf = 'Y' #01/08/16 mandy
       END IF
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('sel oea',STATUS,1)
          LET g_success='N'
          EXIT FOREACH
       END IF
       #no.7426
       #必須檢查為最終訂單
       IF g_oea.oea902 != 'Y' THEN
          CALL cl_err(g_oea.oea01,'axm-410',1) 
          LET g_success='N' EXIT FOREACH
       END IF
       #no.7426(end)
       #讀取三角貿易流程代碼資料
       SELECT * INTO g_poz.*
         FROM poz_file
        WHERE poz01=g_oea.oea904 
       IF SQLCA.sqlcode THEN
           CALL cl_err3("sel","poz_file",g_oea.oea904,"",'axm-318',"","",1)   #No.FUN-660167
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       IF g_poz.pozacti = 'N' THEN
           CALL cl_err(g_oea.oea904,'tri-009',1)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       IF g_poz.poz011 = '1' THEN
          CALL cl_err('','axm-414',1)
          LET g_success = 'N'
          EXIT FOREACH
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
              EXIT FOREACH
          END IF
       END IF
 
       CALL s_mtrade_last_plant(g_oea.oea904)
       RETURNING p_last,p_last_plant
 
       IF p_last_plant != g_plant THEN
          CALL cl_err('','axm-410',1)
          CLOSE WINDOW p885_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
 
        #依流程代碼最多6層
        FOR i = p_last TO 0 STEP -1
           LET k = i + 1                        #FUN-710019
           #得到廠商/客戶代碼及database
           CALL p885_azp(i)
           CALL p885_chk99()                         #No.8187
           SELECT poy02 INTO l_poy02
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設定營運中心
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
 
           IF g_poz.poz19 = 'Y' AND l_c > 0  THEN
               IF i < =l_poy02 THEN    #目前站別小於設定中斷點的營運中心時
                   EXIT FOR 
               END IF
           END IF
           CALL p885_getno(i)
           LET g_t1 = s_get_doc_no(g_oha.oha01)     #No.FUN-550070
           IF g_oha05 ='2' OR (g_oha05 = '3' AND i <> 0 ) THEN
               CALL s_mutislip('2','1',g_t1,g_poz.poz01,i)
                   RETURNING g_sw,l_x,l_x,ar_t1,l_x,l_x
               IF g_sw THEN
                  LET g_success = 'N' EXIT FOREACH
               END IF
               #NO.MOD-780191 start---------
               IF cl_null(ar_t1) THEN
                   CALL cl_err('','axm4017',1)
                   LET g_success = 'N'
                   EXIT FOREACH
               END IF
               #no.MOD-780191 end-------------     
           END IF
           IF i <> p_last THEN
               CALL s_mutislip('2','1',g_t1,g_poz.poz01,k)
                   RETURNING g_sw,l_x,l_x,l_x,ap_t1,l_x
               IF g_sw THEN
                  LET g_success = 'N' EXIT FOREACH
               END IF
               #NO.MOD-780191 start---------
               IF cl_null(ap_t1) THEN
                   CALL cl_err('','axm4018',1)
                   LET g_success = 'N'
                   EXIT FOREACH
               END IF
               #no.MOD-780191 end-------------     
           END IF
 
#NO.FUN-670047 start--抓各站設定的訂單成本中心--
           SELECT poy45 INTO l_omb930
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy02 = i
           SELECT poy46 INTO l_apa930
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy02 = i 
           CALL axmp886(g_oha.oha01,g_date,
                        p_poy20,p_poy16,p_poy17,l_plant_new,next_dbs,    #FUN-980010
                        p_poy12,p_last_plant,p_poy18,p_poy19,
                        g_flow99,ar_t1,ap_t1,g_rvu01,g_oha01,l_x,
                        l_apa930,l_omb930,g_oha05,i)  
           IF g_success='N' THEN EXIT FOR END IF
       END FOR
   END FOREACH
   #無符合條件時
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg3160',1) 
      RETURN
   END IF
END FUNCTION
 
FUNCTION p885_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_next  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_azp03 LIKE azp_file.azp03,
         l_sql1  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
         l_poy02 LIKE poy_file.poy02     #FUN-710019 
 
     ##-------------取得當站資料庫----------------------
      SELECT * INTO g_poy.* FROM poy_file
       WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     LET p_poy04  = g_poy.poy04     #工廠編號
     LET p_poy12  = g_poy.poy12     #發票別
     LET p_poy16  = g_poy.poy16     #AR 科目類別
     LET p_poy18  = g_poy.poy18     #AR 部門
     LET p_poy20  = g_poy.poy20     #營業額申報方式
 
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = p_poy04
 
#    LET l_dbs_new = l_azp.azp03 CLIPPED,"."
     LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)    #FUN-920166
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET l_plant_new = p_poy04
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
     ##-------------取得上站資料庫----------------------
     #LET l_next = l_i + 1
     LET l_next = l_i - 1
     SELECT * INTO n_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_next
 
     LET p_poy17  = n_poy.poy17     #AP 科目類別
     LET p_poy19  = n_poy.poy19     #AP 部門
 
     SELECT azp03 INTO l_azp03 FROM azp_file 
      WHERE azp01 = n_poy.poy04
    #LET next_dbs = l_azp03 CLIPPED,"."  #TQC-950032 MARK                                                                           
     LET next_dbs = s_dbstring(l_azp03)  #TQC-950032 ADD 
     
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p885_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
     LET g_cnt = 0
     IF i <> p_last THEN
         #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ",
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'apa_file'),  #FUN-A50102
                     "  WHERE apa99 ='",g_flow99,"'",
                     "  AND apa00 = '22' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE apacnt_pre FROM l_sql
         DECLARE apacnt_cs CURSOR FOR apacnt_pre
         OPEN apacnt_cs 
         FETCH apacnt_cs INTO g_cnt                                #應付款
         IF g_cnt > 0 THEN
            LET g_msg = l_dbs_new CLIPPED,'apa99 duplicate'
            CALL cl_err(g_msg CLIPPED,'tri-011',1)
            LET g_success = 'N'
         END IF
     END IF
   
     IF g_oha05 = '2' OR (g_oha05 = '3' AND i <> 0) THEN
         #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oma_file'),  #FUN-A50102
                     "  WHERE oma99 ='",g_flow99,"'",
                     "    AND oma00 = '21' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE omacnt_pre FROM l_sql
         DECLARE omacnt_cs CURSOR FOR omacnt_pre
         OPEN omacnt_cs 
         FETCH omacnt_cs INTO g_cnt                                #應收款
         IF g_cnt > 0 THEN
            LET g_msg = l_dbs_new CLIPPED,'oma99 duplicate'
            CALL cl_err(g_msg CLIPPED,'tri-011',1)
            LET g_success = 'N'
         END IF
     END IF
END FUNCTION
 
FUNCTION p885_getno(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
     LET g_rvu01=''
     LET g_oha01=''
     IF i <> p_last THEN 
       #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ",
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092
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
           #LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
           LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'   #NO.TQC-7C0157
           CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           LET g_success = 'N'
        END IF
     END IF              
 
 
    #LET l_sql = " SELECT oha01 FROM ",l_dbs_new CLIPPED,"oha_file ",
     #LET l_sql = " SELECT oha01 FROM ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092
     LET l_sql = " SELECT oha01 FROM ",cl_get_target_table(l_plant_new,'oha_file'),  #FUN-A50102
                     "  WHERE oha99 ='",g_oha.oha99,"'",
                     "    AND oha05 = '",g_oha05,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oha01_pre FROM l_sql
     DECLARE oha01_cs CURSOR FOR oha01_pre
     OPEN oha01_cs 
     FETCH oha01_cs INTO g_oha01                              #銷退單
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'
        CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        LET g_success = 'N'
     END IF
END FUNCTION
