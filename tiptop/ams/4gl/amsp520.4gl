# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amsp520.4gl 
# Descriptions...: MPS 工單產生作業
# Date & Author..: 96/06/10 By Roger
# Modify.........: MOD-480589 04/09/02 By echo 產生的報表無表頭與title
# Modify.........: No.FUN-4A0008 04/10/02 By Yuna 料件編號,計劃員要開窗
# Modify.........: No.FUN-510036 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-550067 05/06/02 By Wujie 單據編號加大
# Modify.........: No.FUN-560118 05/06/19 By Carol 單別輸入後不可馬上直接產生單號
#                                                  顯示在單別上
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0007 05/10/07 By Sarah default sfb99='N',sfb93,sfb94取單別預設資料
# Modify.........: No.FUN-5A0170 05/11/01 By Sarah 執行完後仍會show"電腦正在處理中,請稍候"造成誤解,應清空訊息
# Modify.........: No.MOD-5C0040 05/12/06 By Claire 轉委外工單 default sfb100 為smy57第6碼
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時,特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.FUN-570126 06/03/08 By yiting 批次背景執行
# Modify.........: No.MOD-640252 06/04/11 By kim 新增工單時委外型態須參考asmi300的型態
# Modify.........: No.MOD-640511 06/04/19 By vivien 調整報表格式
# Modify.........: No.MOD-640511 06/05/16 By Pengu 產生第二張工單時，工單單號與第一張重複
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680145 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.MOD-6C0079 06/12/13 By kim 本作業產生工單時,未依前置日期計算預計開工日(並須排除非工作日)!
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.MOD-6C0080 07/04/03 By pengu 由mps產生工單資料時應該依據單據檔設定產生"製程否"與製程編號
# Modify.........: No.MOD-790157 07/10/17 By Pengu 若單身備料皆為消耗性料件, 單頭扣帳方式應為2.領料(事後扣帳)
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-980005 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0015 09/10/05 By Smapmin 計算預計開工日,邏輯需與asfi301.4gl - i300_time()一致
# Modify.........: No.FUN-970027 09/11/12 By jan 拋轉工單時,單別先抓料件主檔的,如果料件主檔沒設單別，才抓畫面上的工單單別 
# Modify.........: No:MOD-A40111 10/04/20 By Sarah sfb44給予預設值g_user
# Modify.........: No:TQC-A40131 10/04/27 By Sarah sfb104給予預設值N
# Modify.........: No:MOD-A70151 10/07/20 By Sarah SQL多串msa_file,WHERE條件增加msa05='Y' AND msa03='N'
# Modify.........: No:TQC-AC0238 10/12/17 By Mengxw 單號單別的欄位檢查及開窗都要排除smy73='Y'的單別
# Modify.........: No:TQC-AC0240 10/12/17 By jan sfb43 給預設值'N'
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:CHI-B80053 11/10/06 By johung 成本中心是null時，帶入輸入料號的ima34
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No:TQC-C20191 12/03/13 By zhangll sfb251賦值
# Modify.........: No:TQC-D40118 13/07/18 By yangtt 1.修改畫面檔,增加欄位開窗 2.修改報表樣式

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   msb	       RECORD LIKE msb_file.*
DEFINE   sfb	       RECORD LIKE sfb_file.*
DEFINE   g_sfb01       LIKE sfb_file.sfb01           #No.MOD-640511 add
DEFINE   g_msa01       LIKE msa_file.msa01
DEFINE   g_wc,g_sql    string                        #No.FUN-580092 HCN
DEFINE   g_t1          LIKE sfb_file.sfb01           #NO.FUN-680101 VARCHAR(5)
DEFINE   bdate,edate   LIKE type_file.dat            #NO.FUN-680101 date
DEFINE   i,j,k	       LIKE type_file.num10          #NO.FUN-680101 INTEGER
DEFINE   g_flag        LIKE type_file.chr1           #NO.FUN-680101 VARCHAR(01)
DEFINE   g_cnt         LIKE type_file.num10          #NO.FUN-680101 INTEGER
DEFINE   g_i           LIKE type_file.num5           #NO.FUN-680101 SMALLINT  #count/index for any purpose
DEFINE   l_flag        LIKE type_file.chr1,          #No.FUN-570126 #NO.FUN-680101 VARCHAR(1)
         p_row,p_col   LIKE type_file.num5,          #NO.FUN-680101 SMALLINT
         g_change_lang LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)  #是否有做語言切換 No.FUN-57012
DEFINE   g_sfb01_a     LIKE sfb_file.sfb01           #FUN-970027
 
MAIN
   DEFINE   l_name     LIKE type_file.chr20,         #NO.FUN-680101 VARCHAR(20)  # External(Disk) file name
#           l_time     LIKE type_file.chr8           #No.FUN-6A0081
            l_sql      LIKE type_file.chr1000,       #NO.FUN-680101 VARCHAR(600) # RDSQL STATEMENT
            l_chr      LIKE type_file.chr1           #NO.FUN-680101 VARCHAR(1)
   DEFINE   ls_date    STRING                        #No.FUN-570126
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT				 
 
#->No.FUN-570126 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc = ARG_VAL(1)
   LET g_msa01 = ARG_VAL(2)
   LET ls_date = ARG_VAL(3)
   LET bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(4)
   LET edate = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(5)
   LET sfb.sfb81 = cl_batch_bg_date_convert(ls_date)
   LET sfb.sfb01 = ARG_VAL(6)
   LET sfb.sfb82 = ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570126 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#NO.FUN-570126 MARK---
#   LET p_row = 5 LET p_col = 17 
 
#   OPEN WINDOW p520_w AT p_row,p_col WITH FORM "ams/42f/amsp520" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   CALL cl_ui_init()
#   INITIALIZE sfb.* TO NULL
#   SELECT MAX(smyslip) INTO sfb.sfb01 FROM smy_file
#    WHERE smysys='asf' AND smykind='1'
#   INITIALIZE sfb.* TO NULL
#   LET bdate     = TODAY
#   LET edate     = TODAY
#   LET sfb.sfb81 = TODAY
#   SELECT gen03 INTO sfb.sfb82 FROM gen_file WHERE gen01=g_user
#   WHILE TRUE 
#      LET g_flag = 'Y' 
#      CALL p520_ask()
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF cl_sure(20,20) THEN
#         BEGIN WORK 
#         LET g_success='Y'
#         CALL cl_wait()
#         CALL p520()
#         IF INT_FLAG THEN 
#            LET INT_FLAG = 0 
#            LET g_success='N' 
#         END IF
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#            ERROR ''
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE
#   CLOSE WINDOW p520_w
#NO.FUN-570126 MARK--
 
#NO.FUN-570126 start---
   WHILE TRUE
       IF g_bgjob = "N" THEN
          CALL p520_ask()
          IF cl_sure(18,20) THEN
             LET g_success = 'Y'
             BEGIN WORK
             CALL p520()
             IF g_success = 'Y' THEN
                COMMIT WORK
                CALL cl_end2(1) RETURNING g_flag
             ELSE
                ROLLBACK WORK
                CALL cl_end2(2) RETURNING g_flag
             END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p520_w
               EXIT WHILE
            END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p520()
         IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
#->No.FUN-570126 ---end---
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 #No.TQC-AC0238--start 
 FUNCTION i520_sfb01()
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    
 
   LET g_errno = ' '
   IF cl_null(sfb.sfb01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(sfb.sfb01)
 
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-875'
   END IF
 
END FUNCTION
#No.TQC-AC0238--end 
FUNCTION p520_ask()
#No.FUN-550067--begin
   DEFINE li_result       LIKE type_file.num5     #NO.FUN-680101 SMALLINT
   DEFINE lc_cmd          LIKE type_file.chr1000  #No.FUN-570126 #NO.FUN-680101 VARCHAR(500)
   DEFINE p_cmd           LIKE type_file.chr1     #NO.TQC-AC0238       
#No.FUN-550067--end   
 
#->No.FUN-570126 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p520_w AT p_row,p_col WITH FORM "ams/42f/amsp520"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   LET g_bgjob   = "N"
 
   INITIALIZE sfb.* TO NULL
   SELECT MAX(smyslip) INTO sfb.sfb01 FROM smy_file
    WHERE smysys='asf' AND smykind='1'
   INITIALIZE sfb.* TO NULL
   LET bdate     = TODAY
   LET edate     = TODAY
   LET sfb.sfb81 = TODAY
   SELECT gen03 INTO sfb.sfb82 FROM gen_file WHERE gen01=g_user
  WHILE TRUE
#->No.FUN-570126 ---end---
 
   CONSTRUCT BY NAME g_wc ON msb03, ima08, ima67 
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
         #LET g_action_choice = "locale"
         # CALL cl_show_fld_cont()        #No.FUN-550037 hmf
         LET g_change_lang = TRUE         #NO.FUN-570126 
         EXIT CONSTRUCT
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      #--No.FUN-4A0008
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(msb03)  #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form = "q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO msb03
               NEXT FIELD msb03
            WHEN INFIELD(ima67)  #計畫員
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima67
               NEXT FIELD ima67

           #No.TQC-D40118 ---Add--- start
            WHEN INFIELD(ima08)  #計畫員
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ima7"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima08
               NEXT FIELD ima08
           #No.TQC-D40118 ---Add--- end

            OTHERWISE EXIT CASE
         END CASE
       #--END--------------     
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#->No.FUN-570126 --start--
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
#       EXIT WHILE
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
#   IF INT_FLAG THEN RETURN END IF
#NO.FUN-570126 end---------------------
 
   #INPUT g_msa01,bdate,edate,sfb.sfb81,sfb.sfb01,sfb.sfb82 WITHOUT DEFAULTS
   # FROM msa01,bdate,edate,sfb81,sfb01,sfb82 
   INPUT g_msa01,bdate,edate,sfb.sfb81,sfb.sfb01,sfb.sfb82,g_bgjob WITHOUT DEFAULTS
    FROM msa01,bdate,edate,sfb81,sfb01,sfb82,g_bgjob    #NO.FUN-570126  
 
      AFTER FIELD msa01
         IF g_msa01 IS NOT NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM msb_file
             WHERE msb01 = g_msa01
            IF g_cnt = 0  THEN
               CALL cl_err('','ams-124',0)
               NEXT FIELD msa01
            END IF
         END IF
 
      AFTER FIELD edate
         IF NOT (cl_null(edate) AND cl_null(bdate)) THEN
            IF edate < bdate THEN NEXT FIELD bdate END IF
         END IF
 
      AFTER FIELD sfb01
         IF sfb.sfb01 IS NOT NULL THEN
## No:2525 modify 1998/12/13 --------------------------
#No.FUN-550067--begin
#           LET g_t1=sfb.sfb01[1,3]
            LET g_t1=sfb.sfb01[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","1","","","")
            RETURNING li_result,sfb.sfb01
            LET sfb.sfb01 = s_get_doc_no(sfb.sfb01)
            IF (NOT li_result) THEN
               NEXT FIELD sfb01
            END IF
            #NO.TQC-AC0238--start
            CALL i520_sfb01()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(sfb.sfb01,g_errno,0)
               LET  sfb.sfb01 = NULL
               DISPLAY BY NAME sfb.sfb01
               NEXT FIELD sfb01
            END IF
            #NO.TQC-AC0238--end    
#No.FUN-550067--end
            DISPLAY BY NAME sfb.sfb01
            LET g_sfb01 = sfb.sfb01         #No.MOD-640511 add
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfb01) #order nubmer
#No.FUN-550067--begin
#              LET g_t1=sfb.sfb01[1,3]
               LET g_t1=sfb.sfb01[1,g_doc_len]
               LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"     #TQC-AC0238
               CALL smy_qry_set_par_where(g_sql)                  #TQC-AC0238
               CALL q_smy(FALSE,FALSE,g_t1,'ASF','1') RETURNING g_t1 #TQC-670008
#               LET sfb.sfb01[1,3]=g_t1
               LET sfb.sfb01=g_t1
#No.FUN-550067--end
               DISPLAY BY NAME sfb.sfb01 
               NEXT FIELD sfb01
            WHEN INFIELD(sfb82) #製造部門
#              CALL q_gem(10,2,sfb.sfb82) RETURNING sfb.sfb82
#              CALL FGL_DIALOG_SETBUFFER( sfb.sfb82 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = sfb.sfb82
               CALL cl_create_qry() RETURNING sfb.sfb82
#               CALL FGL_DIALOG_SETBUFFER( sfb.sfb82 )
               DISPLAY BY NAME sfb.sfb82
               NEXT FIELD sfb82

           #No.TQC-D40118 ---Add--- Start
            WHEN INFIELD(msa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_msa"
               LET g_qryparam.default1 = g_msa01
               CALL cl_create_qry() RETURNING g_msa01
               DISPLAY g_msa01 TO msa01
           #No.TQC-D40118 ---Add--- End
 
         END CASE
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #->No.FUN-570126 --start--
          #LET g_action_choice='locale'
          LET g_change_lang = TRUE 
          EXIT INPUT
          #->No.FUN-570126 ---end---
 
      #TQC-860019-add
      ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
      #TQC-860019-add
 
   END INPUT
 
#NO.FUN-570126 start---
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
#       EXIT WHILE
   END IF
#   IF INT_FLAG THEN RETURN END IF
   LET g_sfb01_a = sfb.sfb01[1,g_doc_len]    #FUN-970027
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()          
      CONTINUE WHILE
   END IF
 
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "amsp520"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('amsp520','9031',1)
       ELSE
          LET g_wc=cl_replace_str(g_wc, "'", "\"")
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_wc CLIPPED ,"'",
                       " '",g_msa01 CLIPPED ,"'",
                       " '",bdate CLIPPED,"'",
                       " '",edate CLIPPED,"'",
                       " '",sfb.sfb81 CLIPPED,"'",
                       " '",sfb.sfb01 CLIPPED ,"'",
                       " '",sfb.sfb82 CLIPPED ,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('amsp520',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p520_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
   EXIT WHILE
#->No.FUN-570126 ---end---
 END WHILE
END FUNCTION
 
FUNCTION p520()
   DEFINE   l_name    LIKE type_file.chr20    #NO.FUN-680101 VARCHAR(20) 
   DEFINE   l_nopen   LIKE msb_file.msb05
   DEFINE   l_sfb08   LIKE sfb_file.sfb08
   DEFINE   l_sfb09   LIKE sfb_file.sfb09
   DEFINE   l_ima111  LIKE ima_file.ima111   #FUN-970027
 
    ###  MOD-480589 ####
 
 
   CALL cl_outnam('amsp520') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    #### END MOD-480589 ####
 
   LET g_sql=" SELECT msb_file.*,ima111 ",  #FUN-970027 add ima111
             "  FROM msb_file,ima_file,msa_file",  #MOD-A70151 add msa_file
             " WHERE msb03=ima01 ",
             "   AND msb01=msa01 ",                #MOD-A70151 add
             "   AND msa05='Y' AND msa03='N'",     #MOD-A70151 add
             "   AND msb04 BETWEEN '",bdate,"' AND '",edate,"'",
             "   AND ima08<>'P'",   #採購料件 (Purchase)
             "   AND msb01='",g_msa01,"'",
             "   AND ",g_wc CLIPPED
   PREPARE p520_p FROM g_sql
   DECLARE p520_c CURSOR FOR p520_p
  # LET l_name='amsp520.out'                           #MOD-480589
 
   START REPORT p520_rep TO l_name
   LET g_pageno = 0
 
   FOREACH p520_c INTO msb.*,l_ima111  #FUN-970027 add l_ima111
      #FUN-970027--begin--add--
      IF NOT cl_null(l_ima111) THEN
         LET g_sfb01 = l_ima111
      ELSE
         LET g_sfb01 = g_sfb01_a
      END IF
      #FUN-970027--end--add--
      #-------- 檢查必須未開工單量必須 > 0 ------------
      SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
       WHERE sfb22 = g_msa01 AND sfb221 = msb.msb02
         AND sfb04 != '8' AND sfb87!='X'    #未結案者，以開工量為準
      IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
      SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
       WHERE sfb22 = g_msa01 AND sfb221 = msb.msb02
         AND sfb04 = '8' AND sfb87!='X'     #已結案者，以完工量為準
      IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
      LET l_nopen = msb.msb05 - (l_sfb08+l_sfb09) # 計算未開單量
      IF l_nopen <= 0 THEN CONTINUE FOREACH END IF
      OUTPUT TO REPORT p520_rep(msb.*,l_nopen,g_sfb01)  #FUN-970027
   END FOREACH
   FINISH REPORT p520_rep
   MESSAGE ''   #FUN-5A0170
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT p520_rep(msb,l_nopen,l_sfb01)#FUN-970027
   DEFINE   msb         RECORD LIKE msb_file.*
   DEFINE   l_nopen     LIKE msb_file.msb05
   DEFINE   l_ima02     LIKE ima_file.ima02
   DEFINE   l_smy57     LIKE smy_file.smy57  #MOD-5C0040
   DEFINE   l_smy57_6   LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
   DEFINE   l_ima08     LIKE ima_file.ima08,
            l_last_sw   LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
   DEFINE   l_t1        LIKE smy_file.smyslip        #NO.FUN-680101 VARCHAR(5)
#No.FUN-550067--begin
   DEFINE li_result     LIKE type_file.num5          #NO.FUN-680101 SMALLINT
#No.FUN-550067--end   
   DEFINE l_cnt1     LIKE type_file.num5          #No.MOD-790157 add
   DEFINE l_cnt2     LIKE type_file.num5          #No.MOD-790157 add
   DEFINE l_sfbi     RECORD LIKE sfbi_file.*      #No.FUN-7B0018
   DEFINE l_sfb01    LIKE sfb_file.sfb01          #FUN-970027
   DEFINE l_ima021   LIKE ima_file.ima021         #No.TQC-D40118   Add
 
   OUTPUT TOP MARGIN g_top_margin 
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line   #No.MOD-580242
 
   ORDER BY msb.msb03
   FORMAT
      PAGE HEADER
         LET l_last_sw = 'n'
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         LET pageno_total=PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
 
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
               g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
               g_x[39] CLIPPED,g_x[40] CLIPPED  #No.TQC-D40118   add  g_x[40] CLIPPED
         PRINT g_dash1
      ON EVERY ROW
#No.FUN-550067--begin
       #------------------No.MOD-640511 modify
        #CALL s_auto_assign_no("asf",sfb.sfb01,sfb.sfb81,"1","","","","","")
         CALL s_auto_assign_no("asf",l_sfb01,sfb.sfb81,"1","","","","","") #FUN-970027 
       #------------------No.MOD-640511 end 
         RETURNING li_result,sfb.sfb01
         IF (NOT li_result) THEN
            LET g_success='N'
            RETURN
         END IF
#        IF cl_null(sfb.sfb01[5,10]) THEN
#           CALL s_smyauno(sfb.sfb01,sfb.sfb81) RETURNING i,sfb.sfb01
#           IF i THEN LET g_success='N' RETURN END IF
#        END IF
#No.FUN-550067--end   
         SELECT ima02,ima08,ima021 INTO l_ima02,l_ima08,l_ima021 FROM ima_file WHERE ima01=msb.msb03  #No.TQC-D40118 Add ima021 l_ima021
         IF STATUS THEN LET l_ima08='M' END IF
         IF l_ima08='M' OR l_ima08='T' THEN LET sfb.sfb02='1' END IF
         IF l_ima08='S' THEN LET sfb.sfb02='7' END IF
 
         LET sfb.sfb04  ='1'
         LET sfb.sfb05  = msb.msb03
         LET sfb.sfb071 = msb.msb07
         LET sfb.sfb08  = l_nopen
         LET sfb.sfb081 = 0
         LET sfb.sfb09  = 0
         LET sfb.sfb10  = 0
         LET sfb.sfb11  = 0
         LET sfb.sfb111 = 0
         LET sfb.sfb12  = 0
         LET sfb.sfb13  = sfb.sfb81
         LET sfb.sfb15  = msb.msb04
         LET sfb.sfb20  = msb.msb04
         LET sfb.sfb22  = g_msa01
         LET sfb.sfb221 = msb.msb02
         LET sfb.sfb23  = 'N'
         LET sfb.sfb24  = 'N'
         LET sfb.sfb251 = sfb.sfb13  #No:TQC-C20191 add
         LET sfb.sfb29  = 'Y'
         LET sfb.sfb32  = 0
         LET sfb.sfb34  = 1
         LET sfb.sfb35  = 'N'
         LET sfb.sfb39  = '1'
         LET sfb.sfb41  = 'N'
         LET sfb.sfb42  = 0
         LET sfb.sfb44  = g_user   #MOD-A40111 add
         LET sfb.sfb87  = 'N'
         LET sfb.sfb87  = 'N'
        #start FUN-5A0007
         LET sfb.sfb93  = g_smy.smy57[1,1]
         IF cl_null(sfb.sfb93) THEN LET sfb.sfb93='N' END IF
        #-------------No.MOD-6C0080 add
         LET sfb.sfb06 =NULL 
         IF sfb.sfb93 = 'Y' THEN 
            SELECT ima94 INTO sfb.sfb06 FROM ima_file WHERE ima01=sfb.sfb05
         END IF
        #-------------No.MOD-6C0080 end
         LET sfb.sfb94  = g_smy.smy57[2,2]
         IF cl_null(sfb.sfb94) THEN LET sfb.sfb94='N' END IF
         #-----No.TQC-610003-----
         SELECT ima910 INTO sfb.sfb95
           FROM ima_file
          WHERE ima01 = sfb.sfb05
         IF cl_null(sfb.sfb95) THEN
            LET sfb.sfb95 = ' '
         END IF
         #-----No.TQC-610003-----
        #end FUN-5A0007
         LET sfb.sfb98  = ' '
         #MOD-640252...............begin
         LET l_t1 = s_get_doc_no(sfb.sfb01)
         #MOD-640252...............end
        #MOD-5C0040-begin
         SELECT smy57 INTO l_smy57 FROM smy_file
         #WHERE smysys='asf' AND smykind='1' #MOD-640252
          WHERE smyslip=l_t1                 #MOD-640252
           LET l_smy57_6 = l_smy57[6,6]
           LET sfb.sfb100 = l_smy57_6
        #MOD-5C0040-end
         LET sfb.sfb99  = 'N'                #FUN-5A0007 
         LET sfb.sfbacti= 'Y'
         LET sfb.sfbuser= g_user
         LET sfb.sfbgrup= g_grup
         LET sfb.sfbdate= g_today   #FUN-970027
         LET sfb.sfb1002='N' #保稅核銷否  #FUN-6B0044
         LET sfb.sfb104 ='N' #備置否(Y/N) #TQC-A40131 add
#CHI-B80053 -- begin --
         IF cl_null(sfb.sfb98) THEN
            SELECT ima34 INTO sfb.sfb98 FROM ima_file
             WHERE ima01 = sfb.sfb05
         END IF
#CHI-B80053 -- end --
         LET sfb.sfbplant = g_plant #FUN-980005
         LET sfb.sfblegal = g_legal #FUN-980005
         CALL p520_time()#MOD-6C0079
         PRINT COLUMN g_c[31],sfb.sfb01,
               COLUMN g_c[32],sfb.sfb05,
               COLUMN g_c[33],l_ima02,
               COLUMN g_c[40],l_ima021,   #No.TQC-D40118 add
               COLUMN g_c[34],cl_numfor(sfb.sfb08,34,0),
               COLUMN g_c[35],sfb.sfb13,
               COLUMN g_c[36],sfb.sfb15,
               COLUMN g_c[37],sfb.sfb22,
               COLUMN g_c[38],'-',
               COLUMN g_c[39],sfb.sfb221 USING '###&' #FUN-590118
         LET sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
         LET sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
         LET sfb.sfb43='0'  #TQC-AC0240
         INSERT INTO sfb_file VALUES(sfb.*)
         IF STATUS THEN 
   #     CALL cl_err('ins sfb:',STATUS,1) #No.FUN-660108
         CALL cl_err3("ins","sfb_file",g_sfb01,"",STATUS,"","ins sfb:",1)       #No.FUN-660108      
             CALL cl_batch_bg_javamail("N") #NO.FUN-570126 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
             EXIT PROGRAM 
         END IF
         #NO.FUN-7B0018 08/02/26 add --begin
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfbi.* TO NULL
            LET l_sfbi.sfbi01 = sfb.sfb01
            IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
               CALL cl_batch_bg_javamail("N")
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
            END IF
         END IF
         #NO.FUN-7B0018 08/02/26 add --end
## No:2367 modify 1998/07/14 -------------------------------------------
      IF g_sma.sma27='1' THEN   #
        #-----------No.FUN-670041 modify
        #CALL s_cralc(sfb.sfb01,sfb.sfb02,sfb.sfb05,g_sma.sma29,
         CALL s_cralc(sfb.sfb01,sfb.sfb02,sfb.sfb05,'Y',
        #-----------No.FUN-670041 end
                     #sfb.sfb08,sfb.sfb071,'Y',g_sma.sma71,0,sfb.sfb95)  #No.TQC-610003
                      sfb.sfb08,sfb.sfb071,'Y',g_sma.sma71,0,'',sfb.sfb95)  #No.TQC-610003 #FUN-BC0008 mod
                     RETURNING g_cnt
      END IF
     #-----------No.MOD-790157 add
       #單身總筆數
       SELECT COUNT(*) INTO l_cnt1 FROM sfa_file WHERE sfa01 = sfb.sfb01 
       
       #單身sfa11='E'筆數
       SELECT COUNT(*) INTO l_cnt2 FROM sfa_file WHERE sfa01 = sfb.sfb01 
                                                   AND sfa11 = 'E'
 
       IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
       IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
       IF l_cnt2 >= l_cnt1 AND l_cnt1 > 0 THEN
          UPDATE sfb_file SET sfb39 = '2'
                          WHERE sfb01 = sfb.sfb01
       END IF
     #-----------No.MOD-790157 end
 
######### -------------------------------------------------------------
#No.FUN-550067--begin
#     LET sfb.sfb01[8,10]=(sfb.sfb01[8,10]+1) USING '&&&'
#No.FUN-550067--end  
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash CLIPPED
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
#MOD-6C0079................begin
#計算預計開工完工日,參考自asfi301.4gl - i300_time()
FUNCTION p520_time()
DEFINE l_ima59    LIKE ima_file.ima59
DEFINE l_ima60    LIKE ima_file.ima60
DEFINE l_ima601   LIKE ima_file.ima601  #No.FUN-840194  
DEFINE l_ima61    LIKE ima_file.ima61
DEFINE l_time     LIKE sfb_file.sfb13
DEFINE li_result  LIKE type_file.num5   #CHI-690066 add
DEFINE l_day      LIKE type_file.num5   #MOD-9A0015
#DEFINE l_ima56    LIKE ima_file.ima56  #CHI-810015 mark #FUN-710073 add
 
   IF cl_null(sfb.sfb05) OR cl_null(sfb.sfb08)
      OR cl_null(sfb.sfb13) THEN 
      RETURN
   END IF
 
  #SELECT ima56,ima59,ima60,ima61 INTO l_ima56,l_ima59,l_ima60,l_ima61  #CHI-810015 mark#FUN-710073 add ima56,l_ima56
  #SELECT ima59,ima60,ima61 INTO l_ima59,l_ima60,l_ima61                #No.FUN-840194 #CHI-810015 mod #FUN-710073 add ima56,l_ima56
   SELECT ima59,ima60,ima601,ima61 INTO l_ima59,l_ima60,l_ima601,l_ima61 ##No.FUN-840194 add ima601 #CHI-810015 mod #FUN-710073 add ima56,l_ima56
      FROM ima_file WHERE ima01=sfb.sfb05
 
   #推算預計開工日
   LET l_time = sfb.sfb15
  #FUN-710073---mod---str---
  #LET l_time = sfb.sfb15-(l_ima59+l_ima60*sfb.sfb08+l_ima61) #No.FUN-840194 #CHI-810015 mark還原    
  #LET l_time = sfb.sfb15-(l_ima59+l_ima60/l_ima601*sfb.sfb08+l_ima61) #No.FUN-840194 #CHI-810015 mark還原       #MOD-9A0015
  #LET l_time = sfb.sfb15-((l_ima59/l_ima56)+                 #CHI-810015 mark
  #                        (l_ima60/l_ima56)*sfb.sfb08+       #CHI-810015 mark
  #                        (l_ima61/l_ima56))                 #CHI-810015 mark
  #FUN-710073---mod---end---
   LET l_day = (l_ima59+l_ima60/l_ima601*sfb.sfb08+l_ima61)   #MOD-9A0015
   WHILE TRUE
     #CHI-690066--begin
      #IF NOT s_daywk(l_time) THEN      #非工作日
      #   LET l_time = l_time - 1
      #   CONTINUE WHILE 
      #ELSE
      #   EXIT WHILE
      #END IF
      LET li_result = 0
      CALL s_daywk(l_time) RETURNING li_result
      CASE
        WHEN  li_result = 0      #非工作日
          LET l_time = l_time + 1   #MOD-9A0015 -變+
          CONTINUE WHILE 
        WHEN  li_result = 1      #工作日
          EXIT WHILE
        WHEN  li_result = 2      #無資料 
          CALL cl_err(l_time,'mfg3153',0)
          EXIT WHILE
        OTHERWISE
          EXIT WHILE
      END CASE
     #CHI-690066--end
   END WHILE
   LET sfb.sfb13 = l_time
   CALL s_aday(sfb.sfb13,-1,l_day) RETURNING sfb.sfb13   #MOD-9A0015
END FUNCTION
#MOD-6C0079................end
