# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp840.4gl
# Descriptions...: 三角貿易應收/應付帳款拋轉作業
# Date & Author..: 98/05/07 By Linda
# Modify ........: 99/05/27 By Sophia
# Modify.........: No.8187 03/09/11 Kammy 1.流程代碼改抓poy_file,poz_file
#                                         2.AR/AP部門改抓流程代碼，而非採購部門
#                                         3.多角序號
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/22 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.FUN-570155 06/03/15 By yiting 批次背景執行
# Modify.........: NO.MOD-640423 06/04/12 BY yiting 單據日期不應與立帳日會計期別不同 
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/08/25 BY yiting 1. s_mutislip加傳入流程代碼/站別
#                                                   2.axmp841加傳站別參數
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-710019 07/01/15 BY yiting 三角改善專案
# Modify.........: No.FUN-710046 07/01/23 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-6B0064 07/02/02 By rainy 拋轉無資料時要顯示訊息不能顯示執行成功
# Modify.........: No.FUN-710046 07/02/26 By Carrier 錯誤訊息匯整 
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# Modify.........: NO.TQC-7C0053 07/12/06 by fangyan 崝增加開窗查詢脤戙
# Modify.........: NO.TQC-7C0053 07/12/08 BY FANGYAN 重新寫qry查詢語句
# Modify.........: NO.TQC-7C0157 07/12/20 BY yiting 單別取法應跨站
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.TQC-980164 09/08/21 By sherry "稅種"與"部門編號"欄位用戶需要可以開窗查詢      
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-970075 09/10/21 By Dido 取下站的資料庫調整 
# Modify.........: No:MOD-A30190 10/03/24 By Smapmin 同FUN-660073針對樣品的處理
# Modify.........: No:FUN-A50102 10/06/11 by lixh1  跨庫統一用cl_get_target_table()實現 
# Modify.........: No:MOD-A90029 10/09/13 By Smapmin 應參照oay11決定是否產生帳款
# Modify.........: No:MOD-B20136 11/02/23 By lilingyu TQC-7C0157修改的第0站不會有AP資料,應該是最後一站不會有AP資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C40072 12/05/29 By Sakura 條件多增加oga09='8'簽收單據

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat     #No.FUN-680137 DATE # 應收立帳日
DEFINE p_date           LIKE type_file.dat     #No.FUN-680137 DATE         # 應收立帳日
#DEFINE g_argv1	 VARCHAR(10)
DEFINE g_argv1		LIKE ima_file.ima01  #No.FUN-680137 VARCHAR(40)     #FUN-670007 
 
DEFINE g_oga    RECORD LIKE oga_file.*
DEFINE g_oea    RECORD LIKE oea_file.*
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
DEFINE p_poy07  LIKE poy_file.poy07        #FUN-670007
DEFINE p_poy08  LIKE poy_file.poy08        #FUN-670007
DEFINE p_poy09  LIKE poy_file.poy09        #FUN-670007
DEFINE p_poy06  LIKE poy_file.poy06        #FUN-670007
DEFINE p_last_plant  LIKE poy_file.poy04   #最後一家工廠編號
#DEFINE g_flow99      VARCHAR(15)              #No.8187   #FUN-560043
DEFINE g_flow99      LIKE oga_file.oga99  #No.FUN-680137 VARCHAR(17)  #No.8187   #FUN-560043
DEFINE g_sw          LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1) #No.8187
DEFINE g_t1          LIKE oay_file.oayslip              #No.8187  #No.FUN-680137 VARCHAR(05)
DEFINE g_rvu01       LIKE rvu_file.rvu01   #No.8187
DEFINE g_rva01       LIKE rva_file.rva01   #No.8187
DEFINE g_oga01       LIKE oga_file.oga01   #No.8187
DEFINE l_dbs_new     LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)  #New DataBase Name
DEFINE l_dbs_tra     LIKE type_file.chr21   #FUN-980092 
DEFINE l_plant_new   LIKE type_file.chr21   #No.FUN-980020
DEFINE l_next_plant_new   LIKE type_file.chr21   #CHI-970075
DEFINE next_dbs      LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)  #下一家 DataBase Name
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE p_last LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570155  #No.FUN-680137 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)  #是否有做語言切換 No.FUN-570155
       ls_date         STRING                  #->No.FUN-570155
DEFINE g_yy,g_mm,g_oga_yy,g_oga_mm  LIKE type_file.num5    #No.FUN-680137 SMALLINT   #NO.MOD-640423
 
 
MAIN
   OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
   DEFER INTERRUPT
 
#NO.FUN-570155 start-
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1   = ARG_VAL(1)
   LET g_wc      = ARG_VAL(1)
   LET ls_date   = ARG_VAL(2)                      
   LET g_date    = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob   = ARG_VAL(3)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#NO.FUN-570155 end--

 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
#   LET g_argv1=ARG_VAL(1) #NO.FUN-570155 MARK
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.CHI-6A0094 
 
#NO.FUN-570155 mark-
#   IF NOT cl_null(g_argv1) THEN
#      LET g_wc   =" oga01 MATCHES '",g_argv1,"'"
#      LET g_date =ARG_VAL(2)
#      CALL p840_p()
#   ELSE
#      CALL p840_tm()
#   END IF
#NO.FUN-570155 mark-
 
#NO.FUN-570155 start--
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
#        CLEAR FORM
         #若有傳參數則不用輸入畫面
         IF NOT cl_null(g_argv1) THEN
            LET g_wc   =" oga01 MATCHES '",g_argv1,"'"
         ELSE
            CALL p840_tm()
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL p840_p()
            CALL s_showmsg()        #No.FUN-710046 
            IF g_success = 'Y' AND cl_null(g_argv1) THEN   #表示由畫面輸入資料
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF g_success = 'Y' AND NOT cl_null(g_argv1) THEN   #表示為傳參數
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
               CLOSE WINDOW p840_w
            ELSE 
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
        # CLOSE WINDOW p840_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p840_p()
         CALL s_showmsg()        #No.FUN-710046 
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570155 --end--
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.CHI-6A0094 
END MAIN
 
FUNCTION p840_tm()
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE lc_cmd     LIKE type_file.chr1000 #No.FUN-680137    VARCHAR(500)            #No.FUN-570155
 
   OPEN WINDOW p840_w WITH FORM "axm/42f/axmp840"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
    CLEAR FORM
    CALL cl_opmsg('w')
    WHILE TRUE
       LET g_action_choice = ''
       CONSTRUCT BY NAME g_wc ON oga01,oga02,oga21,oga15 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT       
             CALL cl_qbe_init()   
         #No.FUN-580031 ---end---
 
  #..NO.TQC-7C0053........BEGIN.......
          ON ACTION controlp
             CASE
                WHEN INFIELD (oga01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state='c'
                  #LET g_qryparam.form="q_oga01"  #mak-by TQC-7C0053 
                  LET g_qryparam.form="q_oga012"  #add-by TQC_7C0053 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga01
                   NEXT FIELD oga01
 
                 #TQC-980164---Begin                                                                                                 
                 WHEN INFIELD (oga21)                                                                                               
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state='c'                                                                                          
                  LET g_qryparam.form="q_oga21"                                                                                     
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO oga21                                                                              
                  NEXT FIELD oga21  
 
                 WHEN INFIELD (oga15)                                                                                              
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state='c'                                                                                          
                  LET g_qryparam.form="q_oga015"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO oga15                                                                              
                  NEXT FIELD oga15                                                                                                  
                 OTHERWISE EXIT CASE                                                                                                
                #TQC-980164---End    
             END CASE
 #..NO.TQC-7C0053.....END......
          ON ACTION locale
#NO.FUN-570155 start--
#             LET g_action_choice='locale'
             LET g_change_lang = TRUE
#NO.FUN-570155 end---
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
#NO.FUN-570155 start--
#->No.FUN-570155 ---start---   
#       IF g_action_choice = 'locale' THEN
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p840_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
#       IF INT_FLAG THEN RETURN END IF
#NO.FUN-570155 end--
 
       IF g_wc = ' 1=1'
          THEN CALL cl_err('','9046',0) CONTINUE WHILE
       END IF
       LET g_date=NULL
       LET g_bgjob ='N'  #NO.FUN-570155 
       CALL cl_opmsg('a')
       #INPUT BY NAME g_date WITHOUT DEFAULTS 
       INPUT BY NAME g_date,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570155 
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG 
             CALL cl_cmdask()
          ON ACTION locale
#NO.FUN-570155 start--
#             LET g_action_choice='locale'
             LET g_change_lang = TRUE
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
       END INPUT
#NO.FUN-570155 mark--
#       IF g_action_choice = 'locale' THEN
#          CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()   #FUN-550037(smin)
#          CONTINUE WHILE
#       END IF
#       IF INT_FLAG THEN RETURN END IF
#       IF cl_sure(19,20) THEN 
#          CALL p840_p()
#          IF g_success = 'Y' THEN
#             CALL cl_end2(1) RETURNING l_flag
#          ELSE
#             CALL cl_end2(2) RETURNING l_flag
#          END IF
#          IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#       END IF
#    END WHILE
#    CLOSE WINDOW p840_w
#NO.FUN-570155 mark--
 
 
#NO.FUN-570155 start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p840_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axmp840"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axmp840','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",g_date CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axmp840',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p840_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
      EXIT PROGRAM
   END IF
   EXIT WHILE 
 END WHILE 
 
#->No.FUN-570155 --end--
END FUNCTION
 
FUNCTION p840_p()
  DEFINE l_oma58     LIKE oma_file.oma58
  DEFINE l_cnt       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  #DEFINE ar_t1,ap_t1 LIKE type_file.chr3    #No.FUN-680137 VARCHAR(3)  #No.8187   #FUN-560043
  DEFINE ar_t1,ap_t1  LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187   #FUN-560043
  #DEFINE l_x         VARCHAR(3)  #No.8187   #FUN-560043
  DEFINE l_x         LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187   #FUN-560043
  DEFINE l_azp03     LIKE azp_file.azp03
  DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
  DEFINE l_poy02_1   LIKE poy_file.poy02  #FUN-670007
  DEFINE l_poy02_2   LIKE poy_file.poy02  #FUN-670007 
  DEFINE l_c         LIKE type_file.num5    #No.FUN-680137 SMALLINT             #FUN-670007
  DEFINE l_poy04_first  LIKE poy_file.poy04   #FUN-670007
  DEFINE k           LIKE type_file.num5    #NO.TQC-7C0157
  DEFINE l_oay11     LIKE oay_file.oay11    #MOD-A90029
 
    LET p_date = g_date  #存所給之應收日
#->No.FUN-570155 ---start---   
    IF g_bgjob= 'N' THEN
       CALL cl_wait() 
    END IF 
 
     #讀取符合條件之出貨資料
     LET g_sql=
             "SELECT *",
             "   FROM oga_file",
             "  WHERE oga162>=0 AND ogaconf='Y' ",
             "    AND ",g_wc CLIPPED,
             "    AND (oga10 IS NULL OR oga10 = ' ')",
             "    AND oga09 ='4' ",
             "    AND oga909='Y' AND oga905='Y' "  ###AND oga906='Y' ",
             #"    AND oga50>0 "                    ##若為逆拋這樣判斷就不行了   #MOD-A30190
    PREPARE p840_prepare FROM g_sql
    DECLARE p840_cs CURSOR WITH HOLD FOR p840_prepare
#   BEGIN WORK 
    LET g_success='Y'
    LET l_cnt=0
    CALL s_showmsg_init()   #No.FUN-710046
    FOREACH p840_cs INTO g_oga.*
        IF STATUS THEN 
#          CALL cl_err('p840(foreach):',STATUS,1)           #No.FUN-710046
           CALL s_errmsg('','','p840(foreach):',STATUS,1)   #No.FUN-710046  
           LET g_success='N' 
           EXIT FOREACH 
        END IF
        #No.FUN-710046  --Begin
        IF g_success = 'N' THEN
           LET g_totsuccess = 'N'
           LET g_success = 'Y'
        END IF
        #No.FUN-710046  --End   

        #-----MOD-A90029---------
        LET l_oay11 = NULL
        LET g_t1 = s_get_doc_no(g_oga.oga01)
        SELECT oay11 INTO l_oay11 FROM oay_file
          WHERE oayslip = g_t1 
        IF l_oay11 = 'N' THEN
           CALL s_errmsg("oga01",g_oga.oga01,"","axr-372",1)       
           CONTINUE FOREACH
        END IF
        #-----END MOD-A90029-----

        LET g_flow99 = g_oga.oga99       #No.8187
        #若畫面上之應收日未給則給出貨日
        IF p_date IS NULL THEN LET g_date=g_oga.oga02 END IF
#NO.MOD-640423 start--
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = g_date
   IF STATUS THEN
#      CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660167
       #No.FUN-710046  --Begin
#      CALL cl_err3("sel","azn_file",g_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660167
       CALL s_errmsg("azn01",g_date,"read azn:",SQLCA.sqlcode,0) 
#      RETURN
       CONTINUE FOREACH 
       #No.FUN-710046  --End  
   END IF
#NO.MOD-640423 end--
#NO.MOD-640423 start--
        SELECT azn02,azn04 
          INTO g_oga_yy,g_oga_mm FROM azn_file
        WHERE azn01 = g_oga.oga02
        IF g_oga_yy IS NOT NULL AND g_oga_mm IS NOT NULL THEN
            IF g_oga_yy != g_yy OR g_oga_mm != g_mm THEN 
#              CALL cl_err(g_oga.oga01,'axr-065',1)             #No.FUN-710046        
               CALL s_errmsg("azn01",g_oga.oga02,"","axr-065",1)#No.FUN-710046       
               LET g_success = 'N' #No.FUN-570156
#              RETURN
               CONTINUE FOREACH   #No.FUN-710046
            END IF
        END IF
#NO.MOD-640423 end---
        LET l_cnt = l_cnt + 1
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
        #no.7426
        #必須檢查為來源訂單(目前應收/應付拋轉只採正拋)
        IF g_oea.oea906 != 'Y' THEN
           #No.FUN-710046  --Begin
           #CALL cl_err(g_oea.oea01,'apm-021',1) 
           CALL s_errmsg("oea906","Y","","apm-021",1)
           #No.FUN-710046  --End  
           LET g_success='N'
#          EXIT FOREACH
           CONTINUE FOREACH #No.FUN-710046
        END IF
        #no.7426(end)
 
        #讀取三角貿易流程代碼資料
        SELECT * INTO g_poz.*
          FROM poz_file
         WHERE poz01=g_oea.oea904 AND poz00='1'
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oea.oea904,'axm-318',1)   #No.FUN-660167
            #No.FUN-710046  --Begin
#           CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)
            LET g_showmsg=g_oea.oea904,"/",'1'
            CALL s_errmsg('poz01,poz00',g_showmsg ,'','axm-318',1)
            LET g_success = 'N'
#           EXIT FOREACH
            CONTINUE FOREACH
            #No.FUN-710046  --End  
        END IF
        IF g_poz.pozacti = 'N' THEN 
#           CALL cl_err(g_oea.oea904,'tri-009',1)         #No.FUN-710046
            CALL s_errmsg('pozacti','N','','tri-009',1)   #No.FUN-710046
            LET g_success = 'N'
#           EXIT FOREACH
            CONTINUE FOREACH   #No.FUN-710046     
        END IF
 #NO.FUN-FUN-710019  start--(有設立中斷點時，拋AR/AP己有增加逆拋程式axmp845)
        IF g_poz.poz19 = 'Y' AND g_poz.poz011 = '2' THEN
           #No.FUN-710046  --Begin
#          CALL cl_err('','axm-078',1)
           LET g_showmsg=g_poz.poz19,"/2"
           CALL s_errmsg("poz19,poz011",g_showmsg,"","axm-078",1)
           LET g_success = 'N'
#          EXIT FOREACH
           CONTINUE FOREACH   
           #No.FUN-710046  --End  
        END IF
 #NO.FUN-FUN-710019  end----
 
#NO.FUN-670007 mark--移到p840_azp()之後處理
#        #No.8187 取得 AR/AP單別
##        LET g_t1 = g_oga.oga01[1,3]
#        LET g_t1 = s_get_doc_no(g_oga.oga01)        #No.FUN-550070
#        CALL s_mutislip('1','1',g_t1)
#                RETURNING g_sw,l_x,l_x,l_x,ar_t1,ap_t1
#        IF g_sw THEN 
#           LET g_success = 'N' EXIT FOREACH 
#        END IF 
#        #No.8187(end)
#NO.FUN-670007 mark---
        CALL s_mtrade_last_plant(g_oea.oea904) 
             RETURNING p_last,p_last_plant
 
        #依流程代碼最多6層
        FOR i = 0 TO p_last
           LET k = i + 1                             #no.TQC-7C0157
           #得到廠商/客戶代碼及database
           CALL p840_azp(i)      
           CALL p840_chk99()                         #No.8187
           CALL p840_getno(i)                        #No.8187
#NO.FUN-670007 start---
           LET g_t1 = s_get_doc_no(g_oga.oga01)        #No.FUN-550070
           CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)
                #RETURNING g_sw,l_x,l_x,l_x,ar_t1,ap_t1
                RETURNING g_sw,l_x,l_x,l_x,ar_t1,l_x     #NO.TQC-7C0157 modify
           IF g_sw THEN 
               LET g_success = 'N' 
               #No.FUN-710046  --Begin
#              EXIT FOREACH 
               CONTINUE FOREACH  
               #No.FUN-710046  --End  
           END IF 
           #--no.TQC-7C0157 add AP單別應抓下一站---
           IF i <> p_last THEN
               CALL s_mutislip('1','1',g_t1,g_poz.poz01,k)
                    RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
               IF g_sw THEN 
                   LET g_success = 'N' 
                   CONTINUE FOREACH  
               END IF 
           END IF
           #---no.TQC-7C0157 add ------------------
 
           #NO.MOD-780191 start---------
           IF cl_null(ar_t1) THEN
               CALL cl_err('','axm4017',1)
               LET g_success = 'N'
               EXIT FOREACH
           END IF
#          IF i <> 0 THEN                    #no.TQC-7C0157 add 第0站不會有AP資料   #MOD-B20136 
           IF i <> p_last THEN                                                      #MOD-B20136 
               IF cl_null(ap_t1) THEN
                   CALL cl_err('','axm4018',1)
                   LET g_success = 'N'
                   EXIT FOREACH
               END IF
           END IF                            #no.TQC-7C0157 add
           #no.MOD-780191 end-------------     
          
           #讀取該廠別之A/R及A/P立帳
           CALL axmp841(g_oga.oga01,g_date,
                       #p_poy20,p_poy16,p_poy17,l_plant_new,next_dbs,   	#FUN-980020	#CHI-970075 mark
                        p_poy20,p_poy16,p_poy17,l_plant_new,l_next_plant_new,   #FUN-980020	#CHI-970075
#                       p_poy20,p_poy16,p_poy17,l_dbs_new,next_dbs,     #FUN-980020 mark
                        p_poy12,p_last_plant,p_poy18,p_poy19,
#                       g_flow99,ar_t1,ap_t1,g_rvu01,g_oga01,g_rva01) #No.8187
                        g_flow99,ar_t1,ap_t1,g_rvu01,g_oga01,g_rva01,i)   #No.8187  #FUN-670007 
       END FOR
 
   END FOREACH
#No.FUN-710046--begin 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
#No.FUN-710046--end
   #無符合條件時
   IF l_cnt = 0 THEN
      #CALL cl_err('','mfg3160',0)   #FUN-6B0064
      #No.FUN-710046  --Begin
      #CALL cl_err('','mfg3160',1)    #FUN-6B0064
      CALL s_errmsg("","","","mfg3160",1)
      #No.FUN-710046  --End  
#      ROLLBACK WORK      #NO.FUN-570155
      LET g_success = 'N' #NO.FUN-570155 
      RETURN
   END IF
#NO.FUN-570155 mark--
#   IF g_success = 'Y'
#      THEN COMMIT WORK
#      ELSE ROLLBACK WORK
#   END IF
#NO.FUN-570155 mark-
 
END FUNCTION
 
FUNCTION p840_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_next  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_azp01 LIKE azp_file.azp01,	 #CHI-970075
         l_azp03 LIKE azp_file.azp03,
         l_sql1  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
         l_poy02 LIKE poy_file.poy02  #FUN-670007
 
     ##-------------取得當站資料庫----------------------
#NO.FUN-670007 mark-
#     IF l_i = 0 THEN                 #來源
#        LET p_poy04 = g_poz.poz05
#        LET p_poy16 = g_poz.poz06
#        LET p_poy18 = g_poz.poz07
#        LET p_poy20 = g_poz.poz03
#     ELSE
#NO.FUN-670007 mark--
        SELECT * INTO g_poy.* FROM poy_file
         WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
       LET p_poy08  = g_poy.poy08     #SO稅別          #FUN-670007
       LET p_poy07  = g_poy.poy07     #收款條件        #FUN-670007
       LET p_poy04  = g_poy.poy04     #工廠編號
       LET p_poy12  = g_poy.poy12     #發票別
       LET p_poy16  = g_poy.poy16     #AR 科目類別
       LET p_poy18  = g_poy.poy18     #AR 部門
       LET p_poy20  = g_poy.poy20     #營業額申報方式
#     END IF   #FUN-670007 mark
 
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = p_poy04
     LET l_plant_new = l_azp.azp01                     #FUN-980020
     LET l_dbs_new = l_azp.azp03 CLIPPED,"."
     LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)   #FUN-920166
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
    
     ##-------------取得下站資料庫----------------------
     LET l_next = l_i + 1
     SELECT * INTO n_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_next
 
     LET p_poy09  = n_poy.poy09     #PO稅別       #FUN-670007
     LET p_poy06  = n_poy.poy06     #付款條件     #FUN-670007
     LET p_poy17  = n_poy.poy17     #AP 科目類別
     LET p_poy19  = n_poy.poy19     #AP 部門
 
    #SELECT azp03 INTO l_azp03 FROM azp_file 			#CHI-970075 mark
     SELECT azp01,azp03 INTO l_azp01,l_azp03 FROM azp_file 	#CHI-970075
      WHERE azp01 = n_poy.poy04
     LET next_dbs = l_azp03 CLIPPED,"."
     LET l_next_plant_new = l_azp01       			#CHI-970075 
     
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p840_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
     LET g_cnt = 0
 
    # LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ",   #FUN-A50102
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'apa_file' ),  #FUN-A50102
                 "  WHERE apa99 ='",g_flow99,"'",
                 "  AND apa00 = '11' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
     PREPARE apacnt_pre FROM l_sql
     DECLARE apacnt_cs CURSOR FOR apacnt_pre
     OPEN apacnt_cs 
     FETCH apacnt_cs INTO g_cnt                                #應付款
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'apa99 duplicate'
        #No.FUN-710046  --Begin
#       CALL cl_err(g_msg CLIPPED,'tri-011',1)
        CALL s_errmsg('','',g_msg CLIPPED,'tri-011',1)
        #No.FUN-710046  --End  
        LET g_success = 'N'
     END IF
 
  #   LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",    #FUN-A50102
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'oma_file' ),   #FUN-A50102
                 "  WHERE oma99 ='",g_flow99,"'",
                 "    AND oma00 = '12' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
     PREPARE omacnt_pre FROM l_sql
     DECLARE omacnt_cs CURSOR FOR omacnt_pre
     OPEN omacnt_cs 
     FETCH omacnt_cs INTO g_cnt                                #應收款
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'oma99 duplicate'       
#       CALL cl_err(g_msg CLIPPED,'tri-011',1)                #No.FUN-710046
        CALL s_errmsg('','',g_msg CLIPPED,'tri-011',1)        #No.FUN-710046
        LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p840_getno(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
     IF i <> p_last THEN  
       #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ",
    #    LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092   #FUN-A50102
        LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table( l_plant_new, 'rvu_file' ),  #FUN-A50102
                    "  WHERE rvu99 ='",g_oga.oga99,"'",
                    "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rvu01_pre FROM l_sql
        DECLARE rvu01_cs CURSOR FOR rvu01_pre
        OPEN rvu01_cs 
        FETCH rvu01_cs INTO g_rvu01                              #入庫單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs'     
           #No.FUN-710046  --Begin
#          CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           LET g_showmsg=g_oga.oga99,"/1"
           CALL s_errmsg("rvu99,rvu00",g_showmsg,g_msg CLIPPED,SQLCA.SQLCODE,1)
           #No.FUN-710046  --End  
           LET g_success = 'N'
        END IF
       #LET l_sql = " SELECT rva01 FROM ",l_dbs_new CLIPPED,"rva_file ",
       # LET l_sql = " SELECT rva01 FROM ",l_dbs_tra CLIPPED,"rva_file ", #FUN-980092   #FUN-A50102
        LET l_sql = " SELECT rva01 FROM ",cl_get_target_table( l_plant_new, 'rva_file' ),  #FUN-A50102
                    "  WHERE rva99 ='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rva01_pre FROM l_sql
        DECLARE rva01_cs CURSOR FOR rva01_pre
        OPEN rva01_cs 
        FETCH rva01_cs INTO g_rva01                              #入庫單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rva01_cs'   
           #No.FUN-710046  --Begin
#          CALL cl_err(g_msg,SQLCA.SQLCODE,1)     
           CALL s_errmsg("rva99",g_oga.oga99,g_msg CLIPPED,SQLCA.sqlcode,1)
           #No.FUN-710046  --End  
           LET g_success = 'N'
        END IF
     END IF
 
    #LET l_sql = " SELECT oga01 FROM ",l_dbs_new CLIPPED,"oga_file ",
    #LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092   #FUN-A50102
     LET l_sql = " SELECT oga01 FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),  #FUN-A50102
                 "  WHERE oga99 ='",g_oga.oga99,"'",
                #"    AND oga09 = '4' "         #FUN-C40072 mark
                 "    AND oga09 IN ( '4','8') " #FUN-C40072 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oga01_pre FROM l_sql
     DECLARE oga01_cs CURSOR FOR oga01_pre
     OPEN oga01_cs 
     FETCH oga01_cs INTO g_oga01                              #出貨單
     IF SQLCA.SQLCODE THEN
        LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'
        #No.FUN-710046  --Begin
#       CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        LET g_showmsg=g_oga.oga99,"/4"
        CALL s_errmsg("oga99,oga09",g_showmsg,g_msg CLIPPED,SQLCA.sqlcode,1)   
        #No.FUN-710046  --End  
        LET g_success = 'N'
     END IF
 
END FUNCTION
