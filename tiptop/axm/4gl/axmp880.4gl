# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp880.4gl
# Descriptions...: 三角貿易銷退應收/應付帳款拋轉作業
# Date & Author..: 96/05/07 By Roger
# Remark ........: 本程式 Copy from axrp310
# Modify.........: 97-04-17 modify by joanne 1.不產生檢查表, 因原方式產生錯誤
#                                            2.call s_g_ar 時加傳一參數
#                                              (配合 s_g_ar 修改)
# Modify.........: 97/08/01 By Sophia 已產生訂金不可重複產生
# Modify.........: 97/09/04 By Sophia 當出貨比率為0時無法產生帳款
# Modify.........: No.8193 03/09/15 ching 1.流程代碼改抓poy_file,poz_file
#                                         2.AR/AP部門改抓流程代碼，而非採購部門
#                                         3.多角序號
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/24 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.FUN-570155 06/03/15 By yiting 批次作業修改
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/09/08 by yiting 1.s_mutislip移到p880_azp()之後，加傳入流程代碼/站別
#                                                   2.依apmi000設定站別抓取資料
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: NO.MOD-680020 06/12/27 By Mandy 當單頭的出貨單沒有輸入時,抓單身任何一筆出貨單
# Modify.........: NO.FUN-710019 07/01/15 BY yiting 三角改善專案
# Modify.........: NO.FUN-710046 07/01/23 BY bnlent 錯誤信息匯整
# Modify.........: NO.TQC-760011 07/06/03 BY yiting 銷售拋ar/ap如為逆拋但無設定中斷點時，應執行axmp880
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980010 09/08/28 By TSD.apple call axmp881 需要poy04 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/21 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B30087 11/03/10 By Smapmin 應參照oay11決定是否產生帳款
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C70066 12/07/16 By minpp 銷退單號增加開窗 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat     #No.FUN-680137 DATE  # 應收立帳日
DEFINE p_date           LIKE type_file.num5    #No.FUN-680137 DATE  # 應收立帳日
#DEFINE g_argv1	 VARCHAR(10)
DEFINE g_argv1		LIKE ima_file.ima01   #No.FUN-680137 VARCHAR(40) #FUN-670007 
 
DEFINE g_oha   RECORD LIKE oha_file.*
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_poz  RECORD LIKE poz_file.*       #流程代碼資料(單頭) No.8187
DEFINE g_poy  RECORD LIKE poy_file.*       #流程代碼資料(單身) No.8187
DEFINE n_poy  RECORD LIKE poy_file.*       #流程代碼資料(單身) No.8187
DEFINE p_poy16  LIKE poy_file.poy16,       #AR類別
       p_poy17  LIKE poy_file.poy17,       #AP類別
       p_poy20  LIKE poy_file.poy20,       #申報方式
       p_poy18  LIKE poy_file.poy18,       #AR部門
       p_poy19  LIKE poy_file.poy19        #AP部門
DEFINE p_poy04  LIKE poy_file.poy04        #AR之工廠編號
DEFINE p_poy12  LIKE poy_file.poy12        #發票別
DEFINE p_last_plant  LIKE poy_file.poy04   #最後一家工廠編號
#DEFINE g_flow99      VARCHAR(15)              #No.8187   #FUN-560043
DEFINE g_flow99      LIKE oga_file.oga99  #No.FUN-680137 VARCHAR(17)  #No.8187   #FUN-560043
DEFINE g_sw          LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1) #No.8187
DEFINE g_t1          LIKE oay_file.oayslip              #No.8187  #No.FUN-680137 VARCHAR(05)
DEFINE g_rvu01       LIKE rvu_file.rvu01   #No.8187
DEFINE g_rva01       LIKE rva_file.rva01   #No.8187
DEFINE g_oga01       LIKE oga_file.oga01   #No.8187
DEFINE g_oha01       LIKE oha_file.oha01   #No.8187
DEFINE l_dbs_new     LIKE type_file.chr21  #No.FUN-680137  VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_tra     LIKE type_file.chr21  #FUN-980092 
DEFINE l_plant_new   LIKE type_file.chr21  #FUN-980092 
DEFINE next_dbs      LIKE type_file.chr21  #No.FUN-680137  VARCHAR(21)    #下一家 DataBase Name
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE p_last LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE p_last_flag LIKE type_file.chr1    #最後一家工廠否?  #No.FUN-680137 VARCHAR(1)
DEFINE   g_change_lang  LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)      #FUN-570155
         ls_date        LIKE type_file.chr8,    #No.FUN-680137 VARCHAR(8)      #FUN-570155
         l_flag          LIKE type_file.chr1         #FUN-570155  #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
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
   LET g_bgjob = ARG_VAL(4)
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
#   IF NOT cl_null(g_argv1) THEN
#      LET g_wc   =" oha01 MATCHES '",g_argv1,"'"
#      LET g_date =ARG_VAL(2)
#      CALL p880_p()
#   ELSE
#      CALL p880_tm()
#   END IF
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start--
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' AND cl_null(g_argv1) THEN
         CALL p880_tm()
         IF cl_sure(21,21) THEN
            CALL cl_wait() 
            BEGIN WORK   
            CALL p880_p()
            CALL s_showmsg()             #No.FUN-710046
            IF g_success = 'Y' THEN
               COMMIT WORK               #FUN-670007 
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK             #FUN-670007 
               CALL cl_end2(2) RETURNING l_flag
            END IF
            
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p880_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF 
         CLOSE WINDOW p880_w
      ELSE
         IF NOT cl_null(g_argv1) THEN
            LET g_wc   =" oha01 MATCHES '",g_argv1,"'"
         END IF
         BEGIN WORK
         CALL p880_p()
         CALL s_showmsg()     #No.FUN-710046
         IF g_success = 'Y' THEN 
            COMMIT WORK
         ELSE  
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570155 end--
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p880_tm()
   DEFINE lc_cmd   LIKE type_file.chr1000 #No.FUN-680137  VARCHAR(500)     #FUN-570155
 
   OPEN WINDOW p880_w WITH FORM "axm/42f/axmp880"
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

       #FUN-C70066---ADD---STR
        ON ACTION controlp
           CASE
           WHEN INFIELD(oha01) 
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_oha2"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO oha01
             NEXT FIELD oha01
           END CASE
       #FUN-C70066---ADD--END
 
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
#NO.FUN-570155 start--
#FUN-570155 --start
#       IF g_action_choice = 'locale' THEN
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p880_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
#NO.FUN-570155 end--
 
       IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
       IF g_wc = ' 1=1'
          THEN CALL cl_err('','9046',0) CONTINUE WHILE
       END IF
       LET g_date=NULL
       CALL cl_opmsg('a')
       LET g_bgjob = 'N'           #FUN-570155
#       INPUT BY NAME g_date WITHOUT DEFAULTS 
       INPUT BY NAME g_date,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570155 
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG 
             CALL cl_cmdask()
          ON ACTION locale
#NO.FUN-570155 start--
#             LET g_action_choice='locale'
             LET g_change_lang = TRUE           #FUN-570155
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
       END INPUT
#NO.FUN-570155 start--
#       IF g_action_choice = 'locale' THEN
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
#       IF INT_FLAG THEN RETURN END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p880_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
#NO.FUN-570155 end--
 
#NO-FUN-570155 mark--
#       IF cl_sure(19,20) THEN
#          CALL p880_p()
#          IF g_success = 'Y' THEN
#             CALL cl_end2(1) RETURNING l_flag
#          ELSE
#             CALL cl_end2(2) RETURNING l_flag
#          END IF
#          IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#       END IF
#    END WHILE
#   CLOSE WINDOW p880_w
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start--
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axmp880'
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axmp880','9031',1)   
          ELSE
             LET g_wc = cl_replace_str(g_wc,"'","\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " ''",
                          " '",g_date CLIPPED,"'",
                          " '",g_wc CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('axmp880',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p880_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       EXIT WHILE
    END WHILE
#NO.FUN-570155 end---
END FUNCTION
 
FUNCTION p880_p()
  DEFINE l_oma58     LIKE oma_file.oma58
  DEFINE l_cnt LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE ar_t1,ap_t1 LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187
  DEFINE l_x         LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187
  DEFINE l_azp03     LIKE azp_file.azp03
  DEFINE l_c         LIKE type_file.num5    #No.FUN-680137 SMALLINT  #FUN-670007
  DEFINE l_omb930    LIKE omb_file.omb930   #FUN-670007
  DEFINE l_apa930    LIKE apa_file.apa930   #FUN-670007
  DEFINE l_poy02     LIKE poy_file.poy02    #FUN-670007
  DEFINE k           LIKE type_file.num5    #FUN-670007
  DEFINE l_oay11     LIKE oay_file.oay11    #MOD-B30087
 
    LET p_date = g_date  #存所給之應收日
#    CALL cl_wait()   #NO.FUN-570155 
    #讀取符合條件之銷退資料
    LET g_sql=
             "SELECT *",
             "   FROM oha_file",
             "  WHERE oha53>0 AND ohaconf='Y' ",
             "    AND ",g_wc CLIPPED,
             "    AND (oha10 IS NULL OR oha10 = ' ')",
             "    AND oha41 ='Y' ",
             "    AND oha44='Y' ",   ####AND oha43='Y' 逆拋可拋轉AP,AR No.9422
             "    AND oha50>0 "
    PREPARE p880_prepare FROM g_sql
    DECLARE p880_cs CURSOR WITH HOLD FOR p880_prepare
#    BEGIN WORK         #NO.FUN-570155 mark
#    LET g_success='Y'  #NO.FUN-570155 mark
    LET l_cnt=0
    CALL s_showmsg_init()    #NO.FUN-710046
    FOREACH p880_cs INTO g_oha.*
       IF STATUS THEN 
       #NO.FUN-710046--Begin--
       #  CALL cl_err('p880(foreach):',STATUS,1) 
          CALL s_errmsg('','','p880(foreach):',STATUS,1) 
       #No.FUN-710046--End--
          LET g_success='N' EXIT FOREACH 
       END IF
       #No.FUN-710046--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       #No.FUN-710046--End-

       #-----MOD-B30087---------
       LET l_oay11 = NULL
       LET g_t1 = s_get_doc_no(g_oha.oha01)
       SELECT oay11 INTO l_oay11 FROM oay_file
         WHERE oayslip = g_t1 
       IF l_oay11 = 'N' THEN
          CALL s_errmsg("oha01",g_oha.oha01,"","axr-372",1)       
          CONTINUE FOREACH
       END IF
       #-----END MOD-B30087-----
 
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
#         CALL cl_err('sel oga',STATUS,1)   #No.FUN-660167
       #No.FUN-710046--Begin--
       #  CALL cl_err3("sel","oga_file",g_oha.oha16,"",STATUS,"","sel oga",1)   #No.FUN-660167
          CALL s_errmsg('oga01',g_oha.oha16,'sel oga',STATUS,1)   
          LET g_success='N'
       #  RETURN
          CONTINUE FOREACH
       #No.FUN-710046--End--
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
       #NO.FUN-710046--Begin--
       #  CALL cl_err('sel oea',STATUS,1)
          CALL s_errmsg('','','sel oea',STATUS,1)
          LET g_success='N'
       #  EXIT FOREACH
          CONTINUE FOREACH
       #No.FUN-710046--End---
       END IF
       #no.7426
       #必須檢查為來源訂單(目前應收/應付拋轉只採正拋)
       IF g_oea.oea906 != 'Y' THEN
       #NO.FUN-710046--Begin--
       #  CALL cl_err(g_oea.oea01,'apm-021',1) 
       #  LET g_success='N' EXIT FOREACH
          CALL s_errmsg('','',g_oea.oea01,'apm-021',1) 
          LET g_success='N' CONTINUE FOREACH
       #No.FUN-710046--End--
       END IF
       #no.7426(end)
       #讀取三角貿易流程代碼資料
       SELECT * INTO g_poz.*
         FROM poz_file
        WHERE poz01=g_oea.oea904 AND poz00='1'
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_oea.oea904,'axm-318',1)   #No.FUN-660167
       #No.FUN-710046--Begin--
       #   CALL cl_err3("sel","poz_file",g_oea.oea904,"",'axm-318',"","",1)   #No.FUN-660167
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'axm-318',1)
           LET g_success = 'N'
       #   EXIT FOREACH
           CONTINUE FOREACH
       #No.FUN-710046--End--
       END IF
       IF g_poz.pozacti = 'N' THEN
       #No.FUN-710046--Begin--
       #   CALL cl_err(g_oea.oea904,'tri-009',1)
           CALL s_errmsg('','',g_oea.oea904,'tri-009',1)
           LET g_success = 'N'
       #   EXIT FOREACH
           CONTINUE FOREACH
       #No.FUN-710046--End--
       END IF
#NO.TQC-760011 MARK---------
##NO.FUN-FUN-710019 start--
#       IF g_poz.poz011 = '2' THEN
#       #No.FUN-710046--Begin--
#       #  CALL cl_err('','axm-413',1)
#          CALL s_errmsg('','','','axm-413',1)
#          LET g_success = 'N'
#       #  EXIT FOREACH
#          CONTINUE FOREACH
#       #No.FUN-710046--End--
#       END IF
##NO.FUN-FUN-710019 end---
#NO.TQC-760011 mark----------------
 
       #No.8187 取得 AR/AP單別
#       LET g_t1 = g_oha.oha01[1,3]
#NO.FUN-670007 mark--------
#       LET g_t1 = s_get_doc_no(g_oha.oha01)     #No.FUN-550070
#       CALL s_mutislip('2','1',g_t1)
#       RETURNING g_sw,l_x,l_x,ar_t1,ap_t1,l_x
#       IF g_sw THEN
#          LET g_success = 'N' EXIT FOREACH
#       END IF
#NO.FUN-670007 mark--------
       #No.8187(end)
       CALL s_mtrade_last_plant(g_oea.oea904)
       RETURNING p_last,p_last_plant
 
        #依流程代碼最多6層
        FOR i = 0 TO p_last
           LET k = i + 1                        #FUN-670007
          #IF i = p_last THEN EXIT FOR END IF   #最後一家不立帳
           #得到廠商/客戶代碼及database
           CALL p880_azp(i)
           CALL p880_chk99()                         #No.8187
           CALL p880_getno(i)
#NO.FUN-670007 start-------
           LET g_t1 = s_get_doc_no(g_oha.oha01)     #No.FUN-550070
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
 
           SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設定營運中心
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
 
           ##讀取該廠別之A/R及A/P立帳
           CALL axmp881(g_oha.oha01,g_date,
                        p_poy20,p_poy16,p_poy17,l_plant_new,next_dbs,     #FUN-980092
                        p_poy12,p_last_plant,p_poy18,p_poy19,
                        #g_flow99,ar_t1,ap_t1,g_rvu01,g_oha01,l_x,i,p_poy04,g_poz.poz01) #No.8187      #FUN-670007 
                         g_flow99,ar_t1,ap_t1,g_rvu01,g_oha01,l_x,l_apa930,l_omb930) #No.8187    #FUN-670007 
           IF g_success='N' THEN EXIT FOR END IF
       END FOR
   END FOREACH
   #No.FUN-710046--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
  #No.FUN-710046--End--
 
   #無符合條件時
   IF l_cnt = 0 THEN
   #No.FUN-710046--Begin--
   #  CALL cl_err('','mfg3160',1) 
      CALL s_errmsg('','','','mfg3160',1)
   #No.FUN-710046--End--
#     ROLLBACK WORK  #NO.FUN-570155 MARK
      RETURN
   END IF
#NO.FUN-570155 mark--
#   IF g_success = 'Y'
#      THEN COMMIT WORK
#      ELSE ROLLBACK WORK
#   END IF
#NO.FUN-570155 mark--
END FUNCTION
 
FUNCTION p880_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_next  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_azp03 LIKE azp_file.azp03,
         l_sql1  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
         l_poy02 LIKE poy_file.poy02     #FUN-670007 
 
     ##-------------取得當站資料庫----------------------
#NO.FUN-670007 mark-----
#     IF l_i = 0 THEN                 #來源
#        LET p_poy04 = g_poz.poz05
#        LET p_poy16 = g_poz.poz06
#        LET p_poy18 = g_poz.poz07
#        LET p_poy20 = g_poz.poz03
#     ELSE
#NO.FUN-670007 mark------
        SELECT * INTO g_poy.* FROM poy_file
         WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
       LET p_poy04  = g_poy.poy04     #工廠編號
       LET p_poy12  = g_poy.poy12     #發票別
       LET p_poy16  = g_poy.poy16     #AR 科目類別
       LET p_poy18  = g_poy.poy18     #AR 部門
       LET p_poy20  = g_poy.poy20     #營業額申報方式
#     END IF                          #FUN-670007 mark
 
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = p_poy04
#    LET l_dbs_new = l_azp.azp03 CLIPPED,"."
     LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)    #FUN-920166
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET l_plant_new = p_poy04  
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
     ##-------------取得下站資料庫----------------------
     LET l_next = l_i + 1
     SELECT * INTO n_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_next
 
     LET p_poy17  = n_poy.poy17     #AP 科目類別
     LET p_poy19  = n_poy.poy19     #AP 部門
 
     SELECT azp03 INTO l_azp03 FROM azp_file 
      WHERE azp01 = n_poy.poy04
   # LET next_dbs = l_azp03 CLIPPED,"."   #TQC-950032 MARK                                                                          
     LET next_dbs = s_dbstring(l_azp03)   #TQC-950032 ADD      
     
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p880_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
     LET g_cnt = 0
     IF i <> p_last THEN
         #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ",
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new ,'apa_file'),  #FUN-A50102
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
         #No.FUN-710046--Begin--
         #  CALL cl_err(g_msg CLIPPED,'tri-011',1)
            CALL s_errmsg('','',g_msg CLIPPED,'tri-011',1)
         #No.FUN-710046--End--
            LET g_success = 'N'
         END IF
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new ,'oma_file'),  #FUN-A50102
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
     #No.FUN-710046--Begin--
     #  CALL cl_err(g_msg CLIPPED,'tri-011',1)
        CALL s_errmsg('','',g_msg CLIPPED,'tri-011',1)
     #No.FUN-710046--End--
        LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p880_getno(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
     LET g_rvu01=''
     LET g_oha01=''
     IF i <> p_last THEN    
       #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ",
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092
        LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new ,'rvu_file'),  #FUN-A50102
                    "  WHERE rvu99 ='",g_oha.oha99,"'",
                    "    AND rvu00 = '3' "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rvu01_pre FROM l_sql
        DECLARE rvu01_cs CURSOR FOR rvu01_pre
        OPEN rvu01_cs 
        FETCH rvu01_cs INTO g_rvu01                              #倉退單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'
        #No.FUN-710046--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710046--End--
           LET g_success = 'N'
        END IF
     END IF      
 
 
    #LET l_sql = " SELECT oha01 FROM ",l_dbs_new CLIPPED,"oha_file ",
     #LET l_sql = " SELECT oha01 FROM ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092
     LET l_sql = " SELECT oha01 FROM ",cl_get_target_table(l_plant_new ,'oha_file'),  #FUN-A50102
                     "  WHERE oha99 ='",g_oha.oha99,"'",
                     "    AND oha05 = '2' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oha01_pre FROM l_sql
     DECLARE oha01_cs CURSOR FOR oha01_pre
     OPEN oha01_cs 
     FETCH oha01_cs INTO g_oha01                              #銷退單
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch oha01_cs'
     #No.FUN-710046--Begin--
     #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
     #No.FUN-710046--End--
        LET g_success = 'N'
     END IF
END FUNCTION
