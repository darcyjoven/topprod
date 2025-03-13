# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmp865.4gl
# Descriptions...: 代採買應收/應付帳款拋轉作業 (逆拋)
# Date & Author..: NO.FUN-670007 06/01/05 BY yiting 
# Modify.........: NO.TQC-790117 07/09/21 BY yiting
# Modify.........: NO.MOD-810163 08/01/21 BY claire 條件錯誤oga03應改為oga02
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.sar2436 GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-AC0043 11/01/25 By Smapmin oga27要抓取下一站的資料
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat     #No.FUN-680136 DATE                # 應收立帳日
DEFINE p_date           LIKE type_file.dat     #No.FUN-680136 DATE                # 應收立帳日
DEFINE g_argv1		LIKE oea_file.oea01 #No.FUN-680136 VARCHAR(16)            #No.FUN-550060
DEFINE g_oga    RECORD LIKE oga_file.*
DEFINE g_rva    RECORD LIKE rva_file.*
DEFINE g_oea    RECORD LIKE oea_file.*
DEFINE p_poy16  LIKE poy_file.poy16,     #AR類別
       p_poy17  LIKE poy_file.poy17,     #AP類別
       p_poy20  LIKE poy_file.poy20,     #申報方式
       p_poy18  LIKE poy_file.poy18,     #AR部門
       p_poy19  LIKE poy_file.poy19      #AP部門
DEFINE p_poy04  LIKE poy_file.poy04      #AR之工廠編號
DEFINE p_poy12  LIKE oga_file.oga05      #發票別
DEFINE g_poz    RECORD LIKE poz_file.*   #流程代碼資料(單頭) No.8166
DEFINE g_poy    RECORD LIKE poy_file.*   #流程代碼資料(單身) No.8166
DEFINE s_poy    RECORD LIKE poy_file.*   #流程代碼資料(單身) #NO.FUN-670007
DEFINE p_last_plant  LIKE poy_file.poy04 #最後一家工廠編號
#DEFINE g_flow99     LIKE tqw_file.tqw19 #No.FUN-680136 VARCHAR(15)            #No.8166   #FUN-560043
DEFINE g_flow99      LIKE apa_file.apa99 #No.FUN-680136 VARCHAR(17)            #No.8166   #FUN-560043
DEFINE g_sw          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_t1          LIKE oay_file.oayslip            #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
DEFINE g_rvu01       LIKE rvu_file.rvu01
DEFINE g_oga01       LIKE oga_file.oga01
DEFINE g_pmm01       LIKE pmm_file.pmm01
DEFINE g_oha01       LIKE oha_file.oha01
DEFINE l_dbs_new     LIKE type_file.chr21  #No.FUN-680136  VARCHAR(21)            #New DataBase Name
DEFINE s_dbs_new     LIKE type_file.chr21  #NO.FUN-670007
DEFINE n_dbs_new     LIKE type_file.chr21  #No.FUN-680136  VARCHAR(21)            #FUN-670007
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE s_azp  RECORD LIKE azp_file.*     #FUN-670007
DEFINE p_last        LIKE type_file.num5   #No.FUN-680136  SMALLINT
DEFINE g_cnt         LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_msg         LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570138  #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)               #No.FUN-570138 是否有做語言切換
       ls_date         STRING                  #No.FUN-570138
DEFINE g_yy,g_mm,g_oga_yy,g_oga_mm  LIKE type_file.num5   #No.FUN-680136  SMALLINT   #NO.MOD-640433 
DEFINE l_poy02_2       LIKE poy_file.poy02  #FUN-670007 
DEFINE l_c             LIKE type_file.num5    #No.FUN-680136 SMALLINT             #FUN-670007
DEFINE g_pmm50         LIKE pmm_file.pmm50  
DEFINE l_dbs_tra       LIKE type_file.chr21       #FUN-980092
DEFINE l_plant_new     LIKE azw_file.azw01        #FUN-980092
DEFINE s_plant_new     LIKE azw_file.azw01  #CHI-AC0043
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1  = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob  = ARG_VAL(3)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
#NO.FUN-570138 start--
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob= "N" THEN
         IF cl_null(g_argv1) THEN
            CALL p865_tm()
         ELSE
            LET g_wc   =" oga01 MATCHES '",g_argv1,"'"
         END IF
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL p865_p()
            #若無傳入值時
            IF g_success = 'Y' AND cl_null(g_argv1) THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            #若有傳入值時
            IF g_success = 'Y' AND NOT cl_null(g_argv1) THEN
               CALL cl_cmmsg(1) COMMIT WORK
            ELSE
               CALL cl_rbmsg(1) ROLLBACK WORK
            END IF
            CLOSE WINDOW win
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p865_w
               EXIT WHILE
            END IF
         ELSE
            CLOSE WINDOW win
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p865_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p865_p()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570138 ---end---
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION p865_tm()
DEFINE lc_cmd       LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(500)            #No.FUN-570138
 
   OPEN WINDOW p865_w WITH FORM "apm/42f/apmp865"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
                              
   CLEAR FORM
   CALL cl_opmsg('w')
 
   WHILE TRUE
       ERROR ''
       CONSTRUCT BY NAME g_wc ON oga01,oga02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE          #NO.FUN-570138
            EXIT CONSTRUCT
        
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
   
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p865_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#NO.FUN-570138 end----
 
       IF g_wc = ' 1=1' THEN 
          CALL cl_err('','9046',0) 
          CONTINUE WHILE
       END IF
 
       LET g_date=NULL
       LET g_bgjob = 'N' #NO.FUN-570138 
       CALL cl_opmsg('a')
       INPUT BY NAME g_date,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570138
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG call cl_cmdask()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
          ON ACTION exit  #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT
       
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE  
            EXIT INPUT 
 
       END INPUT
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p865_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
     END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp865"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp865','9031',1)   #No.FUN-660129
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_wc CLIPPED ,"'",
                        " '",g_date CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp865',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p865_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
 
   END WHILE
 
 
END FUNCTION
 
FUNCTION p865_p()
  DEFINE l_oma58     LIKE oma_file.oma58
  DEFINE l_cnt,i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE ar_t1,ap_t1 LIKE poy_file.poy38    #No.FUN-680136 VARCHAR(5)   #No.FUN-550060
  DEFINE l_x         LIKE aba_file.aba00  #No.FUN-680136 VARCHAR(5)   #No.FUN-550060
  DEFINE l_azp03     LIKE azp_file.azp03
  DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
  DEFINE k           LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
    IF g_bgjob = 'N' THEN  #NO.FUN-570138 
        CALL cl_wait() 
    END IF
 
 
    BEGIN WORK
    LET g_success='Y'
 
    LET p_date = g_date  #存所給之應付日
    #讀取符合條件之出貨資料
    LET g_sql="SELECT oga_file.*",
              "   FROM oga_file ",
              " WHERE ogaconf = 'Y' ",        
              "   AND oga09 = '6' ",          #代採買性質
              "   AND oga905 = 'Y'  ",        #出貨單必需為己拋轉
              "   AND ",g_wc CLIPPED
    PREPARE p865_prepare FROM g_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('prepare:',STATUS,1) 
       LET g_success='N' 
       RETURN
    END IF
    DECLARE p865_cs CURSOR WITH HOLD FOR p865_prepare
    IF SQLCA.sqlcode THEN 
       CALL cl_err('declare:',STATUS,1) 
       LET g_success='N' 
       RETURN
    END IF
    LET l_cnt=0
    FOREACH p865_cs INTO g_oga.*
        IF STATUS THEN 
           CALL cl_err('p865(foreach):',STATUS,1) 
           LET g_success='N'
           EXIT FOREACH 
        END IF
#NO.MOD-640433 start-
   #若畫面上之應付日未給則給入庫日(出貨日)
   IF p_date IS NULL THEN LET g_date=g_oga.oga02 END IF
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = g_date
   IF STATUS THEN
       CALL cl_err3("sel","azn_file","","",SQLCA.sqlcode,"","read azn:",0)  #No.FUN-660129
       RETURN
   END IF
 
        SELECT azn02,azn04
          INTO g_oga_yy,g_oga_mm FROM azn_file
        WHERE azn01 = g_oga.oga02    #MOD-810163 modify oga03->oga02
        IF g_oga_yy IS NOT NULL AND g_oga_mm IS NOT NULL THEN
            IF g_oga_yy != g_yy OR g_oga_mm != g_mm THEN
               CALL cl_err(g_oga.oga01,'axr-065',1)
               LET g_success = 'N' 
               RETURN
            END IF
        END IF
        LET g_flow99 = g_oga.oga99
        #若單據已立帳，則不產生 
        IF g_oga.oga10 IS NOT NULL THEN CONTINUE FOREACH END IF
        LET l_cnt = l_cnt +1
 
        #讀取該出貨單之訂單
        SELECT * INTO g_oea.*
          FROM oea_file
         WHERE oea01 = g_oga.oga16
        #check是否有最終供應商
        SELECT pmm50 INTO g_pmm50  
          FROM pmm_file
         WHERE pmm99 = g_oea.oea99
        #必須檢查為來源訂單(逆拋)
        IF g_oea.oea906 != 'Y' THEN
           CALL cl_err(g_oea.oea01,'axm-409',1) 
           LET g_success='N' EXIT FOREACH
        END IF
 
        #讀取三角貿易流程代碼資料
        SELECT * INTO g_poz.*
          FROM poz_file
         WHERE poz01=g_oea.oea904 AND poz00='2'
        IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","poz_file","","","axm-318","","",1)  #No.FUN-660129
            LET g_success = 'N'
            EXIT FOREACH
        END IF
        IF g_poz.pozacti = 'N' THEN 
            CALL cl_err(g_oea.oea904,'tri-009',1)
            LET g_success = 'N'
            EXIT FOREACH
        END IF
        CALL s_mtrade_last_plant(g_oea.oea904) 
             RETURNING p_last,p_last_plant       #記錄最後一家
 
        #依流程代碼最多6層
        FOR i = 1 TO p_last
           LET k = i + 1          #FUN-670007
           #得到廠商/客戶代碼及database
           CALL p865_azp(i)
           CALL p865_chk99()                         #No.8166
           #No.8166取得AR/AP單別 
           LET g_t1 = s_get_doc_no(g_oga.oga01) 
                IF i <> 0 THEN
                    CALL s_mutislip('1','2',g_t1,g_poz.poz01,i)
                        RETURNING g_sw,l_x,l_x,l_x,ar_t1,l_x
                    #no.TQC-790117 start---------
                    IF cl_null(ar_t1) THEN
                        CALL cl_err('','axm4017',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                    #no.TQC-790117 end-------------     
                END IF 
                IF i <> p_last THEN
                    CALL s_mutislip('1','2',g_t1,g_poz.poz01,k)
                       RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
                    #NO.TQC-790117 start---------
                    IF cl_null(ap_t1) THEN
                        CALL cl_err('','axm4018',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                    #no.TQC-790117 end-------------     
                #no.TQC-790117 start---
                ELSE
                    CALL s_mutislip('1','2',g_t1,g_poz.poz01,i)
                       RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
                    IF cl_null(ap_t1) THEN
                        CALL cl_err('','axm4018',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                #NO.TQC-790117 end----
                END IF
           IF g_sw THEN
               LET g_success = 'N' EXIT FOREACH
           END IF
           SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設定營運中心
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           SELECT poy02 INTO l_poy02_2    #中斷營運中心的站別
             FROM poy_file
            WHERE poy01 = g_poz.poz01 
              AND poy04 = g_poz.poz18
            IF g_poz.poz19 = 'Y' AND l_c > 0  THEN
                IF l_poy02_2 = 0 THEN EXIT FOR END IF  #中斷站設第0站不拋轉AR/AP
                IF i > l_poy02_2 THEN EXIT FOR END IF  #目前站別大於設定中斷點的營運中心時
            END IF
            #讀取該廠別之A/R及A/P立帳
            CALL p865_getno1(i)                    #No.8166
                  CALL apmp866(g_oga.oga01,g_date,p_poy20,p_poy16,p_poy17,
                              #l_dbs_new,p_poy12,p_last_plant,  #FUN-980092 mark
                              l_plant_new,p_poy12,p_last_plant,   #FUN-980092 add
                              p_poy18,p_poy19,g_poz.poz011,g_oea.oea01,  
                              g_flow99,ar_t1,ap_t1,g_rvu01,g_oga01,g_pmm01,s_plant_new)      #No.8166   #CHI-AC0043 add s_plant_new
           #no.7176
       END FOR
       #來源廠之AP立帳(必須給來源廠之AP分類)
       SELECT azp03 INTO l_azp03 FROM azp_file
        WHERE azp01=g_plant
 
#      LET l_dbs_new = l_azp03 CLIPPED,":"
       LET l_dbs_new = s_dbstring(l_azp03 CLIPPED)    #FUN-920166
 
       CALL p865_azp(0) 
       CALL s_mutislip('1','2',g_t1,g_poz.poz01,1)
              RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
       IF g_sw THEN
           LET g_success = 'N' EXIT FOREACH
       END IF
       #讀取該廠別之A/R及A/P立帳
       CALL p865_getno1(0)                    #No.8166
       CALL apmp866(g_oga.oga01,g_date,p_poy20,p_poy16,p_poy17,
                   #l_dbs_new,p_poy12,p_last_plant, #FUN-980092 mark
                   l_plant_new,p_poy12,p_last_plant,    #FUN-980092 add
                   p_poy18,p_poy19,g_poz.poz011,g_oea.oea01,
                   g_flow99,ar_t1,ap_t1,g_rvu01,g_oga01,g_pmm01,s_plant_new)      #No.8166   #CHI-AC0043 add s_plant_new
   END FOREACH
   #無符合條件時
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg3160',1) 
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION p865_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_sql1  LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
         l_next  LIKE type_file.num5    #FUN-670007
 
     ##-------------取得當站資料庫----------------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
#     LET l_dbs_new = l_azp.azp03 CLIPPED,":"  #TQC-950010 MARK                                                                     
     LET l_dbs_new = s_dbstring(l_azp.azp03)    #TQC-950010 ADD   
    #FUN-980092 add 改抓Transaction DB --(S)
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new 
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
    #FUN-980092 add 改抓Transaction DB --(E)
     LET p_poy04  = g_poy.poy04     #工廠編號
     LET p_poy12  = g_poy.poy12     #發票別        
     LET p_poy16  = g_poy.poy16     #AR 科目類別   
     LET p_poy18  = g_poy.poy18     #AR 部門
     LET p_poy20  = g_poy.poy20     #營業額申報方式
 
     IF cl_null(p_poy20) THEN LET p_poy20 = g_poz.poz03 END IF 
 
     LET l_next = l_i + 1  
     ##-------------取下一站資料庫----------------------
     SELECT * INTO s_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_next      
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
#     LET s_dbs_new = s_azp.azp03 CLIPPED,":"  #TQC-950010 MARK                                                                     
     LET s_dbs_new = s_dbstring(s_azp.azp03)   #TQC-950010 ADD    
     LET s_plant_new = s_azp.azp01   #CHI-AC0043
     LET p_poy17  = s_poy.poy17     #AR 科目類別    
     LET p_poy19  = s_poy.poy19     #AP 部門        
 
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p865_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
 
     LET g_cnt = 0
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'apa_file'), #FUN-A50102
                 "  WHERE apa99 ='",g_flow99,"'"
     LET l_sql = l_sql CLIPPED," AND apa00 = '11' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
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
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oma_file'), #FUN-A50102
                 "  WHERE oma99 ='",g_flow99,"'"
     LET l_sql = l_sql CLIPPED," AND oma00 = '12' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
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
END FUNCTION
 
FUNCTION p865_getno1(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
     IF cl_null(g_poz.poz18) OR ( i > l_poy02_2 AND NOT cl_null(g_poz.poz18)) THEN  
         IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50) AND g_poz.poz011 = '2' ) THEN           
             #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ", #FUN-980092 mark
             #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092 add
             LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                         "  WHERE rvu99 ='",g_oga.oga99,"'",
                         "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
             PREPARE rvu01_pre FROM l_sql
             DECLARE rvu01_cs CURSOR FOR rvu01_pre
             OPEN rvu01_cs 
             FETCH rvu01_cs INTO g_rvu01                              #入庫單
             IF SQLCA.SQLCODE THEN
                LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs'
                CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                LET g_success = 'N'
             END IF
             #LET l_sql = " SELECT pmm01 FROM ",l_dbs_new CLIPPED,"pmm_file ", #FUN-980092 mark
             #LET l_sql = " SELECT pmm01 FROM ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980092 add
             LET l_sql = " SELECT pmm01 FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                         "  WHERE pmm99 ='",g_oea.oea99,"'",
                         "    AND pmm02 = 'TAP'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
             PREPARE pmm01_pre FROM l_sql
             DECLARE pmm01_cs CURSOR FOR pmm01_pre
             OPEN pmm01_cs 
             FETCH pmm01_cs INTO g_pmm01                              #採購單
             IF SQLCA.SQLCODE THEN
                LET g_msg = l_dbs_new CLIPPED,'fetch pmm01_cs'
                CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                LET g_success = 'N'
             END IF
         END IF
     END IF
 
     IF i <> 0 THEN 
         #LET l_sql = " SELECT oga01 FROM ",l_dbs_new CLIPPED,"oga_file ", #FUN-980092 mark
         #LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092 add
         LET l_sql = " SELECT oga01 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                     "  WHERE oga99 ='",g_oga.oga99,"'",
                     "    AND oga09 = '6' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE oga01_pre FROM l_sql
         DECLARE oga01_cs CURSOR FOR oga01_pre
         OPEN oga01_cs 
         FETCH oga01_cs INTO g_oga01                              #出貨單
         IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_new CLIPPED,'fetch oga01_cs'
            CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
     END IF    
END FUNCTION
