# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp845.4gl
# Descriptions...: (代採/銷售)三角貿易應收/應付帳款拋轉作業(逆拋)
# Date & Author..: NO.FUN-710019 06/12/27 BY yiting 
# Modify.........: No.FUN-710046 07/01/23 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# Modify.........: NO.TQC-7C0146 07/12/18 by claire 多一個 begin work
# Modify.........: no.TQC-7C0157 07/12/20 by Yiting 單別應依站別抓取
# Modify.........: NO.MOD-830054 08/03/07 by claire 資料不應排除代採出貨單
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: NO.MOD-970155 09/07/17 by Dido 應付單別邏輯調整
# Modify.........: NO.MOD-980035 09/08/05 by Dido 應付單別依據出貨類別抓取
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: NO.MOD-9B0186 09/11/26 by Dido 應付單別應與銷售一致
# Modify.........: No:MOD-A30190 10/03/24 By Smapmin 同FUN-660073針對樣品的處理
# Modify.........: No:FUN-A50102 10/06/11 by lixh1  跨庫統一用cl_get_target_table()實現 
# Modify.........: No:CHI-AC0043 11/01/25 By Smapmin oga27要抓取下一站的資料
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat     #No.FUN-680137 DATE # 應收立帳日
DEFINE p_date           LIKE type_file.dat     #No.FUN-680137 DATE         # 應收立帳日
DEFINE g_argv1		LIKE ima_file.ima01  #No.FUN-680137 VARCHAR(40)     #FUN-710019 
DEFINE g_oga09          LIKE oga_file.oga09 
DEFINE g_oga  RECORD LIKE oga_file.*
DEFINE g_oea  RECORD LIKE oea_file.*
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
DEFINE p_poy45  LIKE poy_file.poy45
DEFINE p_poy46  LIKE poy_file.poy46
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
DEFINE next_dbs      LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)  #下一家 DataBase Name
DEFINE next_plant    LIKE type_file.chr21   #CHI-AC0043
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE p_last LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570155  #No.FUN-680137 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)  #是否有做語言切換 No.FUN-570155
       ls_date         STRING                  #->No.FUN-570155
DEFINE g_yy,g_mm,g_oga_yy,g_oga_mm  LIKE type_file.num5    #No.FUN-680137 SMALLINT   #NO.MOD-640423
DEFINE l_c         LIKE type_file.num5    #No.FUN-680137 SMALLINT             #FUN-710019
 
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
   LET g_oga09   = ARG_VAL(3)
   LET g_date    = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob   = ARG_VAL(4)                
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.CHI-6A0094 
 
#NO.FUN-570155 start--
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CLEAR FORM
         #若有傳參數則不用輸入畫面
         IF NOT cl_null(g_argv1) THEN
            LET g_wc   =" oga01 MATCHES '",g_argv1,"'"
         ELSE
            CALL p845_tm()
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL p845_p()
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
               CLOSE WINDOW p845_w
            ELSE 
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p845_p()
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
 
FUNCTION p845_tm()
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE lc_cmd     LIKE type_file.chr1000 #No.FUN-680137    VARCHAR(500)            #No.FUN-570155
 
   OPEN WINDOW p845_w WITH FORM "axm/42f/axmp845"
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
 
          ON ACTION locale
             LET g_change_lang = TRUE
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
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p845_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
 
       IF g_wc = ' 1=1'
          THEN CALL cl_err('','9046',0) CONTINUE WHILE
       END IF
       LET g_date=NULL
       LET g_bgjob ='N'  #NO.FUN-570155 
       LET g_oga09 = '4' 
       CALL cl_opmsg('a')
       INPUT BY NAME g_oga09,g_date,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570155 
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG 
             CALL cl_cmdask()
          ON ACTION locale
             LET g_change_lang = TRUE
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
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p845_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axmp845"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axmp845','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",g_oga09 CLIPPED ,"'",
                      " '",g_date CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axmp845',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p845_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE 
 END WHILE 
 
#->No.FUN-570155 --end--
END FUNCTION
 
FUNCTION p845_p()
  DEFINE l_oma58     LIKE oma_file.oma58
  DEFINE l_cnt       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  #DEFINE ar_t1,ap_t1 LIKE type_file.chr3    #No.FUN-680137 VARCHAR(3)  #No.8187   #FUN-560043
  DEFINE ar_t1,ap_t1  LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187   #FUN-560043
  #DEFINE l_x         VARCHAR(3)  #No.8187   #FUN-560043
  DEFINE l_x         LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)  #No.8187   #FUN-560043
  DEFINE l_azp03     LIKE azp_file.azp03
  DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
  DEFINE l_poy02     LIKE poy_file.poy02  #FUN-710019 
  DEFINE l_amt       LIKE type_file.num5
  DEFINE k           LIKE type_file.num5   #no.TQC-7C0157
 
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
            "    AND oga09 = '",g_oga09,"'", 
            "    AND oga909='Y' AND oga905='Y' ", 
            "    AND oga906='Y' " 
            #"    AND oga50>0 "     #MOD-A30190
    PREPARE p845_prepare FROM g_sql
    DECLARE p845_cs CURSOR WITH HOLD FOR p845_prepare
    #BEGIN WORK   #TQC-7C0146 mark
    LET g_success='Y'
    LET l_cnt=0
    CALL s_showmsg_init()   #No.FUN-710046
    FOREACH p845_cs INTO g_oga.*
        IF STATUS THEN 
#          CALL cl_err('p845(foreach):',STATUS,1) 
           CALL s_errmsg('','','p845(foreach):',STATUS,1)   #No.FUN-710046
           LET g_success='N' EXIT FOREACH 
        END IF
#No.FUN-710046--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710046--end
        LET g_flow99 = g_oga.oga99       #No.8187
        #若畫面上之應收日未給則給出貨日
        IF p_date IS NULL THEN LET g_date=g_oga.oga02 END IF
        SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
            WHERE azn01 = g_date
        IF STATUS THEN
#           CALL cl_err3("sel","azn_file",g_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660167
            CALL s_errmsg('azn01',g_date,'',SQLCA.sqlcode,0)          #No.FUN-710046
#          RETURN
           CONTINUE FOREACH    #No.FUN-710046   
        END IF
        SELECT azn02,azn04 
          INTO g_oga_yy,g_oga_mm FROM azn_file
        WHERE azn01 = g_oga.oga02
        IF g_oga_yy IS NOT NULL AND g_oga_mm IS NOT NULL THEN
            IF g_oga_yy != g_yy OR g_oga_mm != g_mm THEN 
#              CALL cl_err(g_oga.oga01,'axr-065',1)                          #No.FUN-710046
               CALL s_errmsg('azn01',g_oga.oga02,g_oga.oga01,'axr-065',1)  #No.FUN-710046
               LET g_success = 'N' #No.FUN-570156
#              RETURN
               CONTINUE FOREACH   #No.FUN-710046 
            END IF
        END IF
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
#NO.FUN-710019 mark--
#        #必須檢查為來源訂單
#        IF g_oea.oea906 != 'Y' THEN
#           CALL cl_err(g_oea.oea01,'apm-021',1) 
#           LET g_success='N' EXIT FOREACH
#        END IF
#NO.FUN-710019 mark---
 
        #讀取三角貿易流程代碼資料
        SELECT * INTO g_poz.*
          FROM poz_file
         WHERE poz01=g_oea.oea904 
        IF SQLCA.sqlcode THEN
#           CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)   #No.FUN-660167  #No.FUN-710046
            CALL s_errmsg('poz01',g_oea.oea904,'',"axm-318",1)     #No.FUN-710046
            LET g_success = 'N'
            EXIT FOREACH
        END IF
        IF g_poz.pozacti = 'N' THEN 
#           CALL cl_err(g_oea.oea904,'tri-009',1)
            CALL s_errmsg('','',g_oea.oea904,'tri-009',1)  #No.FUN-710046      
            LET g_success = 'N'
            EXIT FOREACH
        END IF
        IF g_poz.poz011 = '1' THEN
#          CALL cl_err('','axm-079',1)
           CALL s_errmsg('','','','axm-079',1)     #No.FUN-710046  
           LET g_success = 'N'
#          EXIT FOREACH
           CONTINUE FOREACH    #No.FUN-710046
        END IF
        IF g_poz.poz19 ='Y' THEN 
            SELECT COUNT(*) INTO l_amt
              FROM poy_file 
             WHERE poy01 = g_poz.poz01 
               AND poy04 = g_poz.poz18 
        END IF 
        IF g_poz.poz011 = '2' THEN
           IF g_poz.poz19 = 'N' OR (g_poz.poz19 = 'Y' AND l_amt = 0 ) THEN
#              CALL cl_err('','axm-080',1)
               CALL s_errmsg('','','','axm-080',1)  #No.FUN-710046 
               LET g_success = 'N'
               EXIT FOREACH
               CONTINUE FOREACH   #No.FUN-710046
           END IF
        END IF
 
        CALL s_mtrade_last_plant(g_oea.oea904) 
             RETURNING p_last,p_last_plant
 
        IF p_last_plant != g_plant THEN
#           CALL cl_err('','axm-410',1)
            CALL s_errmsg('','','','axm-410',1)   #No.FUN-710046
            CLOSE WINDOW p845_w
#           EXIT PROGRAM
        END IF
 
        #依流程代碼最多6層
        FOR i = p_last TO 0 STEP -1  
          #LET k = i -1       #NO.TQC-7C0157 add	#MOD-970155 mark
           LET k = i +1       				#MOD-970155 
           #得到廠商/客戶代碼及database
           CALL p845_azp(i)      
           SELECT COUNT(*) INTO l_c     #check poz18設定的中斷營運中心是否存在單身設定營運中心
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           SELECT poy02 INTO l_poy02  #設立中斷點的站別
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           #如有設定中斷點時，  
           IF g_poz.poz19 = 'Y' AND l_c > 0  THEN
               IF i <= l_poy02 THEN    #目前站別小於等於設定中斷點的營運中心時
                   EXIT FOR 
               END IF
           END IF
           CALL p845_chk99()                         #No.8187
           CALL p845_getno(i)                        #No.8187
           LET g_t1 = s_get_doc_no(g_oga.oga01)        #No.FUN-550070
           CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)
                #RETURNING g_sw,l_x,l_x,l_x,ar_t1,ap_t1
                RETURNING g_sw,l_x,l_x,l_x,ar_t1,l_x   #no.TQC-7C0157 modify
           IF g_sw THEN 
               LET g_success = 'N' EXIT FOREACH 
           END IF 
 
           #--no.TQC-7C0157 add---
           IF i <> p_last THEN		#MOD-970155
             #-MOD-9B0186-mark-
             #IF g_oga09 = '4' THEN     #MOD-980035 
                 CALL s_mutislip('1','1',g_t1,g_poz.poz01,k)
                      RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
                 IF g_sw THEN 
                     LET g_success = 'N' EXIT FOREACH 
                 END IF 
             #-MOD-980035-add-
             #ELSE
             #   CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)
             #        RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
             #   IF g_sw THEN 
             #       LET g_success = 'N' EXIT FOREACH 
             #   END IF 
             #END IF 
             #-MOD-9B0186-end-
             #-MOD-980035-end-
           END IF			#MOD-970155 
           #--no.TQC-7C0157 add---
 
           #NO.MOD-780191 start---------
           IF cl_null(ar_t1) THEN
               CALL cl_err('','axm4017',1)
               LET g_success = 'N'
               EXIT FOREACH
           END IF
           IF i <> 0 THEN   #no.TQC-7C0157 add
              #IF cl_null(ap_t1) THEN			#MOD-970155 mark
               IF cl_null(ap_t1) AND i <> p_last THEN	#MOD-970155
                   CALL cl_err('','axm4018',1)
                   LET g_success = 'N'
                   EXIT FOREACH
               END IF
           END IF           #no.TQC-7C0157 add
           #no.MOD-780191 end-------------     
           #讀取該廠別之A/R及A/P立帳
           CALL axmp846(g_oga.oga01,g_date,
                       #p_poy20,p_poy16,p_poy17,l_dbs_new,next_dbs,
                        #p_poy20,p_poy16,p_poy17,l_plant_new,next_dbs, #FUN-980092   #CHI-AC0043
                        p_poy20,p_poy16,p_poy17,l_plant_new,next_plant, #FUN-980092   #CHI-AC0043
                        p_poy12,p_last_plant,p_poy18,p_poy19,
                        g_flow99,ar_t1,ap_t1,g_rvu01,g_oga01,g_rva01,
                        i,g_oga09,p_poy45,p_poy46) 
       END FOR
 
   END FOREACH
#No.FUN-710046--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710046--end  
   #無符合條件時
   IF l_cnt = 0 THEN
#     CALL cl_err('','mfg3160',0) 
      CALL s_errmsg('','','','mfg3160',0)  #No.FUN-710046
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710046--end
      LET g_success = 'N' #NO.FUN-570155 
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p845_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_next  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_azp03 LIKE azp_file.azp03,
         l_sql1  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
         l_poy02 LIKE poy_file.poy02  #FUN-710019
 
     ##-------------取得當站資料庫----------------------
        SELECT * INTO g_poy.* FROM poy_file
         WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
       LET p_poy04  = g_poy.poy04     #工廠編號
       LET p_poy12  = g_poy.poy12     #發票別
       LET p_poy16  = g_poy.poy16     #AR 科目類別
       LET p_poy18  = g_poy.poy18     #AR 部門
       LET p_poy20  = g_poy.poy20     #營業額申報方式
       LET p_poy45  = g_poy.poy45     #訂單成本中心
 
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
     LET p_poy46  = n_poy.poy46     #採購成本中心
 
     SELECT azp03 INTO l_azp03 FROM azp_file 
      WHERE azp01 = n_poy.poy04
     LET next_dbs = l_azp03 CLIPPED,"."
     LET next_plant = n_poy.poy04   #CHI-AC0043
     
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p845_chk99()
DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
     LET g_cnt = 0
#     LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ",     #FUN-A50102
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'apa_file' ),   #FUN-A50102
                 "  WHERE apa99 ='",g_flow99,"'",
                 "  AND apa00 = '11' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
     PREPARE apacnt_pre FROM l_sql
     DECLARE apacnt_cs CURSOR FOR apacnt_pre
     OPEN apacnt_cs 
     FETCH apacnt_cs INTO g_cnt                                #應付款
     IF g_cnt > 0 THEN
#       LET g_msg = l_dbs_new CLIPPED,'apa99 duplicate'
#       CALL cl_err(g_msg CLIPPED,'tri-011',1)
        LET g_showmsg = l_dbs_new CLIPPED,'apa99 duplicate'  #No.FUN-710027 
        CALL s_errmsg('',g_showmsg CLIPPED,'','tri-011',1)   #No.FUN-710027 
        LET g_success = 'N'
     END IF
 
    # LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",  #FUN-A50102
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
#       LET g_msg = l_dbs_new CLIPPED,'oma99 duplicate'
#       CALL cl_err(g_msg CLIPPED,'tri-011',1)
        LET g_showmsg = l_dbs_new CLIPPED,'oma99 duplicate'  #No.FUN-710027
        CALL s_errmsg('',g_showmsg CLIPPED,'','tri-011',1)   #No.FUN-710027
        LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p845_getno(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
     IF i <> p_last THEN  
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ",
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092    #FUN-A50102
         LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table( l_plant_new, 'rvu_file' ),   #FUN-A50102
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
#           CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)          #No.FUN-710046
            LET g_success = 'N'
         END IF
        #LET l_sql = " SELECT rva01 FROM ",l_dbs_new CLIPPED,"rva_file ",
        #LET l_sql = " SELECT rva01 FROM ",l_dbs_tra CLIPPED,"rva_file ",  #FUN-980092   #FUN-A50102
         LET l_sql = " SELECT rva01 FROM ",cl_get_target_table( l_plant_new, 'rva_file' ),   #FUN-A50102
                     "  WHERE rva99 ='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE rva01_pre FROM l_sql
         DECLARE rva01_cs CURSOR FOR rva01_pre
         OPEN rva01_cs 
         FETCH rva01_cs INTO g_rva01                              #收貨單
         IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_tra CLIPPED,'fetch rva01_cs'
#           CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)     #No.FUN-710046
            LET g_success = 'N'
         END IF
     END IF
    #LET l_sql = " SELECT oga01 FROM ",l_dbs_new CLIPPED,"oga_file ",
 #    LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092    #FUN-A50102
     LET l_sql = " SELECT oga01 FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),   #FUN-A50102
                 "  WHERE oga99 ='",g_oga.oga99,"'",
                 "    AND oga09 = '",g_oga09,"'"   #MOD-830054 
                #"    AND oga09 = '4' "            #MOD-830054 mark
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oga01_pre FROM l_sql
     DECLARE oga01_cs CURSOR FOR oga01_pre
     OPEN oga01_cs 
     FETCH oga01_cs INTO g_oga01                              #出貨單
     IF SQLCA.SQLCODE THEN
       LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'
#       CALL cl_err(g_msg,SQLCA.SQLCODE,1)
        CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)           #No.FUN-710046
        LET g_success = 'N'
     END IF
END FUNCTION
