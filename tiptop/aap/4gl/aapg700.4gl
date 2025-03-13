# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapg700.4gl
# Descriptions...: 預付購料款申請書列印作業
# Date & Author..: 93/02/02  By  Felicity  Tseng
# Modify.........: No.9058 04/01/27 Kammy 欄位說明為LC.NO(ala03),
#                                         但是程式碼與per的欄位卻是用ala01
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-590520 05/09/28 By kim 憑證類報表(voucher)  料號動態放大
# Modify.........: No.FUN-590110 05/09/28 By day 報表轉xml
# Modify.........: No.FUN-5A0180 05/10/25 By Claire 報表調整可印FONT 10
# Modify.........: No.MOD-5B0093 05/11/08 By Smapmin 品名的列印位置錯誤
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610092 06/01/20 By Smapmin 若金額為NULL,則印出0
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/13 By baogui 報表問題修改
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.FUN-710086 07/02/09 By wujie 使用水晶報表打印 
# Modidy.........: No.TQC-730088 07/03/22 By Nicole 新增 CR 參數
# Modify.........: No.TQC-750033 07/05/09 By Sarah 列印無資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: NO.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056 問題
# Modify.........: NO.TQC-AB0163 10/11/28 By suncx 臨時表少ala97字段
# Modify.........: No.FUN-B40097 11/05/10 By chenying 憑證類CR報表轉成GR
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/31 By yangtt  程式規範修改    
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/04/28 By yangtt GR程式優化
# Modify.........: No.FUN-C30085 12/06/25 By nanbing 新增付款條件、價格條件欄位說明
# Modify.........: No.FUN-C90130 12/09/28 By yangtt ala02，ala04開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              more    LIKE type_file.chr1          # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          p_wc LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          g_argument  LIKE ala_file.ala01,
          g_aza17 LIKE aza_file.aza17 # 本國幣別
 
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_sma115    LIKE sma_file.sma115      #FUN-710029
DEFINE   g_sma116    LIKE sma_file.sma116      #FUN-710029
DEFINE   l_table     STRING                    #FUN-710086 add 
DEFINE   g_sql       STRING                    #FUN-710086 add
DEFINE   g_str       STRING                    #FUN-710086 add
 
###GENGRE###START
TYPE sr1_t RECORD
    ala01 LIKE ala_file.ala01,
    ala02 LIKE ala_file.ala02,
    ala03 LIKE ala_file.ala03,
    ala05 LIKE ala_file.ala05,
    ala06 LIKE ala_file.ala06,
    ala07 LIKE ala_file.ala07,
    ala08 LIKE ala_file.ala08,
    ala36 LIKE ala_file.ala36,
    ala11 LIKE ala_file.ala11,
    ala20 LIKE ala_file.ala20,
    ala21 LIKE ala_file.ala21,
    ala22 LIKE ala_file.ala22,
    ala23 LIKE ala_file.ala23,
    ala32 LIKE ala_file.ala32,
    ala35 LIKE ala_file.ala35,
    ala37 LIKE ala_file.ala37,
    ala38 LIKE ala_file.ala38,
    ala39 LIKE ala_file.ala39,
    ala51 LIKE ala_file.ala51,
    ala52 LIKE ala_file.ala52,
    ala53 LIKE ala_file.ala53,
    ala54 LIKE ala_file.ala54,
    ala55 LIKE ala_file.ala55,
    ala56 LIKE ala_file.ala56,
    ala57 LIKE ala_file.ala57,
    alb02 LIKE alb_file.alb02,
    alb03 LIKE alb_file.alb03,
    alb04 LIKE alb_file.alb04,
    alb05 LIKE alb_file.alb05,
    alb06 LIKE alb_file.alb06,
    alb07 LIKE alb_file.alb07,
    alb08 LIKE alb_file.alb08,
    alb11 LIKE alb_file.alb11,
    pmn041 LIKE pmn_file.pmn041,
    pmn07 LIKE pmn_file.pmn07,
    pmc03 LIKE pmc_file.pmc03,
    alg02 LIKE alg_file.alg02,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    alb80 LIKE alb_file.alb80,
    alb81 LIKE alb_file.alb81,
    alb82 LIKE alb_file.alb82,
    alb83 LIKE alb_file.alb83,
    alb84 LIKE alb_file.alb84,
    alb85 LIKE alb_file.alb85,
    alb86 LIKE alb_file.alb86,
    alb87 LIKE alb_file.alb87,
    pmn20 LIKE pmn_file.pmn20,
    ala97 LIKE ala_file.ala97,
    pmc03_1 LIKE pmc_file.pmc03,
    str2 LIKE type_file.chr50,
    flag LIKE type_file.chr1,
    t_azi07 LIKE azi_file.azi07,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
    ,l_ala02  LIKE pma_file.pma02,     #FUN-C30085 add
    l_ala36   LIKE pnz_file.pnz02      #FUN-C30085 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-710086--begin 
   LET g_sql = "ala01.ala_file.ala01,ala02.ala_file.ala02,",
               "ala03.ala_file.ala03,ala05.ala_file.ala05,",
               "ala06.ala_file.ala06,ala07.ala_file.ala07,",
               "ala08.ala_file.ala08,ala36.ala_file.ala36,",
               "ala11.ala_file.ala11,ala20.ala_file.ala20,",
               "ala21.ala_file.ala21,ala22.ala_file.ala22,",
               "ala23.ala_file.ala23,ala32.ala_file.ala32,",
               "ala35.ala_file.ala35,ala37.ala_file.ala37,",
               "ala38.ala_file.ala38,ala39.ala_file.ala39,",
               "ala51.ala_file.ala51,ala52.ala_file.ala52,",
               "ala53.ala_file.ala53,ala54.ala_file.ala54,",
               "ala55.ala_file.ala55,ala56.ala_file.ala56,",
               "ala57.ala_file.ala57,alb02.alb_file.alb02,",
               "alb03.alb_file.alb03,alb04.alb_file.alb04,",
               "alb05.alb_file.alb05,alb06.alb_file.alb06,",
               "alb07.alb_file.alb07,alb08.alb_file.alb08,",
               "alb11.alb_file.alb11,pmn041.pmn_file.pmn041,",
               "pmn07.pmn_file.pmn07,pmc03.pmc_file.pmc03,",
               "alg02.alg_file.alg02,azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,azi05.azi_file.azi05,",
               "alb80.alb_file.alb80,alb81.alb_file.alb81,",
               "alb82.alb_file.alb82,alb83.alb_file.alb83,",
               "alb84.alb_file.alb84,alb85.alb_file.alb85,",
               "alb86.alb_file.alb86,alb87.alb_file.alb87,",
               #"pmn20.pmn_file.pmn20,pmc03_1.pmc_file.pmc03,",   #TQC-750033 add pmn20  ##TQC-AB0163 mark
               "pmn20.pmn_file.pmn20,ala97.ala_file.ala97,",      #modify TQC-AB0163
               "pmc03_1.pmc_file.pmc03,",                         #modify TQC-AB0163
               "str2.type_file.chr50,flag.type_file.chr1,",
               "t_azi07.azi_file.azi07,",
               "sign_type.type_file.chr1,   sign_img.type_file.blob,",   #簽核方式, 簽核圖檔  #FUN-C40019 add
               "sign_show.type_file.chr1,  sign_str.type_file.chr1000"                        #FUN-C40019 add 
               ,",l_ala02.pma_file.pma02,l_ala36.pnz_file.pnz02"  #FUN-C30085 add
   LET l_table = cl_prt_temptable('aapg700',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      EXIT PROGRAM 
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? ,?,?)"   #TQC-750033 add ?   #modify TQC-AB0163 add ?  #FUN-C40019 add 4? #FUN-C30085 add 2?
   PREPARE insert_prep FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      EXIT PROGRAM    
   END IF                           
#No.FUN-710086--end 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file #FUN-710029
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g700_tm(0,0)           # Input print condition
      ELSE CALL g700()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)                     #FUN-C10036   add
END MAIN
 
FUNCTION g700_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(700)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW g700_w AT p_row,p_col
     WITH FORM "aap/42f/aapg700"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   IF (p_wc IS NOT NULL) AND (p_wc != ' ') THEN   # 外部參數不為NULL及空白
      LET tm.wc = p_wc
   ELSE
      CONSTRUCT BY NAME tm.wc ON ala03,ala02,ala08,ala04   #No:9058
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT

         #FUN-C90130------add---str---
         ON ACTION CONTROLP
           CASE
             WHEN INFIELD(ala02) # PAY TERM
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_pma01" 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ala02
            WHEN INFIELD(ala04) # Dept CODE
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gem"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ala04
            OTHERWISE EXIT CASE
          END CASE
         #FUN-C90130------add---end---
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-BB0047 mark
         LET INT_FLAG = 0 CLOSE WINDOW g700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40097
         CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-BB0047 mark
         LET INT_FLAG = 0 CLOSE WINDOW g700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40097
         CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
         EXIT PROGRAM
      END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapg700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapg700','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                     #   " '",p_wc CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapg700',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   END IF
   CALL g700()
   ERROR ""
END WHILE
   CLOSE WINDOW g700_w
END FUNCTION
 
FUNCTION g700()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          sr               RECORD ala01   LIKE ala_file.ala01, # L/C 開狀單頭檔
                                  ala02   LIKE ala_file.ala02,
                                  ala03   LIKE ala_file.ala03,
                                  ala05   LIKE ala_file.ala05,
                                  ala06   LIKE ala_file.ala06,
                                  ala07   LIKE ala_file.ala07,
                                  ala08   LIKE ala_file.ala08,
                                  ala36   LIKE ala_file.ala36,
                                  ala11   LIKE ala_file.ala11,
                                  ala20   LIKE ala_file.ala20,
                                  ala21   LIKE ala_file.ala21,
                                  ala22   LIKE ala_file.ala22,
                                  ala23   LIKE ala_file.ala23,
                                  ala32   LIKE ala_file.ala32,
                                  ala35   LIKE ala_file.ala35,
                                  ala37   LIKE ala_file.ala37,
                                  ala38   LIKE ala_file.ala38,
                                  ala39   LIKE ala_file.ala39,
                                  ala51   LIKE ala_file.ala51,
                                  ala52   LIKE ala_file.ala52,
                                  ala53   LIKE ala_file.ala53,
                                  ala54   LIKE ala_file.ala54,
                                  ala55   LIKE ala_file.ala55,
                                  ala56   LIKE ala_file.ala56,
                                  ala57   LIKE ala_file.ala57,
                                  alb02   LIKE alb_file.alb02, #
                                  alb03   LIKE alb_file.alb03, #
                                  alb04   LIKE alb_file.alb04, # L/C 採購單身檔
                                  alb05   LIKE alb_file.alb05,
                                  alb06   LIKE alb_file.alb06,
                                  alb07   LIKE alb_file.alb07,
                                  alb08   LIKE alb_file.alb08,
                                  alb11   LIKE alb_file.alb11, # 料號
                                  pmn041  LIKE pmn_file.pmn041, # 品名
                                  pmn07   LIKE pmn_file.pmn07, # 採購單位
                                  pmc03   LIKE pmc_file.pmc03, # 廠商名稱
                                  alg02   LIKE alg_file.alg02, # 銀行簡稱
                                  azi03   LIKE azi_file.azi03, 
                                  azi04   LIKE azi_file.azi04, 
                                  azi05   LIKE azi_file.azi05, 
                                  alb80   LIKE alb_file.alb80,  #FUN-710029
                                  alb81   LIKE alb_file.alb81,  #FUN-710029
                                  alb82   LIKE alb_file.alb82,  #FUN-710029
                                  alb83   LIKE alb_file.alb83,  #FUN-710029
                                  alb84   LIKE alb_file.alb84,  #FUN-710029
                                  alb85   LIKE alb_file.alb85,  #FUN-710029
                                  alb86   LIKE alb_file.alb86,  #FUN-710029
                                  alb87   LIKE alb_file.alb87,  #FUN-710029
                                  pmn20   LIKE pmn_file.pmn20,  #FUN-710029
                                  ala97   LIKE ala_file.ala97   #FUN-A60056
                        END RECORD
#FUN-C30085 -start-
   DEFINE l_ala02 LIKE pma_file.pma02
   DEFINE l_ala36 LIKE pnz_file.pnz02
#FUN-C30085 -end-                        
#No.FUN-710086--begin
   DEFINE l_str2    LIKE type_file.chr50
   DEFINE l_flag    LIKE type_file.chr1          #標示打印何種水晶報表的格式
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_alb85   LIKE alb_file.alb85
   DEFINE l_alb82   LIKE alb_file.alb82
   DEFINE l_pmn20   LIKE pmn_file.pmn20 
   DEFINE l_pmc03_1 LIKE pmc_file.pmc03          #出貨廠商名稱   #TQC-750033 add
   DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
 
     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aapg700'
#No.FUN-710086--end
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
     #End:FUN-980030
 
     SELECT aza17 INTO g_aza17     # 本國幣別
       FROM aza_file
      WHERE aza01 = '0'
     LET l_sql = "SELECT ",
                 " ala01,ala02,ala03,ala05,ala06,ala07,ala08,ala36,ala11,",
                 " ala20,ala21,ala22, ",
                 " ala23,ala32,ala35,ala37,ala38,ala39,ala51,ala52,ala53,ala54,ala55,",
                 " ala56,ala57,alb02,alb03,alb04,alb05,alb06,alb07, ",
                #" alb08,alb11,pmn041,pmn07,",   #FUN-A60056
                 " alb08,alb11,'','',",                #FUN-A60056
                 " pmc03,alg02,azi03,azi04,azi05,",
                #" alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87,pmn20 ",           #FUN-710029  #FUN-A60056
                 " alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87,'',ala97,azi07 ",  #FUN-A60056  #FUN-C50003 add azi07
                #" FROM ala_file, OUTER (alb_file, OUTER pmn_file),",   #FUN-A60056
                #FUN-C50003---mark--str--
                #" FROM ala_file, OUTER alb_file,",                     #FUN-A60056
                #" OUTER pmc_file, ",
                #" OUTER alg_file, ",
                #" OUTER azi_file  ",  
                #" WHERE ala_file.ala01=alb_file.alb01 ",
                ##" AND pmn_file.pmn01 = alb_file.alb04 ",   #FUN-A60056
                ##" AND pmn_file.pmn02 = alb_file.alb05 ",   #FUN-A60056
                #" AND pmc_file.pmc01=ala_file.ala05 ",
                #" AND alg_file.alg01=ala_file.ala07 ",
                #" AND azi_file.azi01=ala_file.ala20 ",
                #" AND alafirm <> 'X' ",
                #" AND ", tm.wc CLIPPED
                #FUN-C50003---mark--end--
                #FUN-C50003---add---str--
                 " FROM ala_file LEFT OUTER JOIN alb_file ON ala01=alb01",  
                 " LEFT OUTER JOIN pmc_file ON pmc01=ala05",
                 " LEFT OUTER JOIN alg_file ON alg01=ala07",
                 " LEFT OUTER JOIN azi_file ON azi01=ala20",
                 " WHERE alafirm <> 'X' AND ", tm.wc CLIPPED
                #FUN-C50003---add---end--
    #CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A60056    #FUN-A70139
     PREPARE g700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare :',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
        EXIT PROGRAM
     END IF
     DECLARE g700_curs1 CURSOR FOR g700_prepare1
#    CALL cl_outnam('aapg700') RETURNING l_name    #No.FUN-710086
#FUN-710029 start------#zaa06隱藏否
    IF g_sma116 MATCHES '[13]' THEN
#No.FUN-710086--begin
       LET l_flag ='1'  
#        LET g_zaa[55].zaa06 = "N" #計價單位
#        LET g_zaa[56].zaa06 = "N" #計價數量
#        LET g_zaa[47].zaa06 = "Y" #數量
    ELSE
       LET l_flag ='2'
#        LET g_zaa[55].zaa06 = "Y" #計價單位
#        LET g_zaa[56].zaa06 = "Y" #計價數量
#        LET g_zaa[47].zaa06 = "N" #數量
    END IF
    IF g_sma115 = "Y" AND g_sma116 NOT MATCHES '[13]' THEN
       LET l_flag ='3'
    END IF
#    IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[54].zaa06 = "N" #單位註解
#    ELSE
#        LET g_zaa[54].zaa06 = "Y" #單位註解
#    END IF
#    CALL cl_prt_pos_len()
#FUN-710029 end------------
 
#     START REPORT g700_rep TO l_name
#     LET g_pageno = 0
#No.FUN-710086--end
     FOREACH g700_curs1 INTO sr.*,t_azi07
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #FUN-A60056--add--str--
          LET l_sql = "SELECT pmn041,pmn07,pmn20 ",
                      "  FROM ",cl_get_target_table(sr.ala97,'pmn_file'),
                      " WHERE pmn01 = '",sr.alb04,"'",
                      "   AND pmn02 = '",sr.alb05,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,sr.ala97) RETURNING l_sql
          PREPARE sel_pmn041 FROM l_sql
          EXECUTE sel_pmn041 INTO sr.pmn041,sr.pmn07,sr.pmn20
          #FUN-A60056--add--end
#No.FUN-710086--begin
#          IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
#          IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
#          IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
#         SELECT azi07 INTO t_azi07 FROM azi_file where azi01=sr.ala20     #FUN-C50003 mark
          LET l_str2 = ""
          IF g_sma115 = "Y" THEN
             CASE l_ima906
                WHEN "2"
                    CALL cl_remove_zero(sr.alb85) RETURNING l_alb85
                    LET l_str2 = l_alb85 , sr.alb83 CLIPPED
                    IF cl_null(sr.alb85) OR sr.alb85 = 0 THEN
                        CALL cl_remove_zero(sr.alb82) RETURNING l_alb82
                        LET l_str2 = l_alb82, sr.alb80 CLIPPED
                    ELSE
                       IF NOT cl_null(sr.alb82) AND sr.alb82 > 0 THEN
                          CALL cl_remove_zero(sr.alb82) RETURNING l_alb82
                          LET l_str2 = l_str2 CLIPPED,',',l_alb82, sr.alb80 CLIPPED
                       END IF
                    END IF
                WHEN "3"
                    IF NOT cl_null(sr.alb85) AND sr.alb85 > 0 THEN
                        CALL cl_remove_zero(sr.alb85) RETURNING l_alb85
                        LET l_str2 = l_alb85 , sr.alb83 CLIPPED
                    END IF
             END CASE
          ELSE
          END IF
          IF g_sma116 MATCHES '[13]' THEN 
                IF sr.pmn07 <> sr.alb86 THEN 
                   CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
                   LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
                END IF
          END IF
          #str TQC-750033 add
          SELECT pmc03 INTO l_pmc03_1 FROM pmc_file WHERE pmc01=sr.ala06
          IF cl_null(l_pmc03_1) THEN LET l_pmc03_1 = ' ' END IF
          #end TQC-750033 add

          #FUN-C30085 ------------------------------
          LET l_ala02=''
          SELECT pma02 INTO l_ala02 FROM pma_file
           WHERE pma01=sr.ala02

          LET l_ala36=''
          SELECT pnz02 INTO l_ala36 FROM pnz_file
           WHERE pnz01=sr.ala36
          #FUN-C30085 -----------------------------
          
          EXECUTE insert_prep USING sr.*,l_pmc03_1,l_str2,l_flag,t_azi07,   #TQC-750033 add l_pmc03_1
                                    "",l_img_blob,"N",""    #FUN-C40019 add
                                    ,l_ala02,l_ala36  #FUN-C30085  add
#         OUTPUT TO REPORT g700_rep(sr.*)
#No.FUN-710086--end
     END FOREACH
#No.FUN-710086--begin
#     FINISH REPORT g700_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_wcchp(tm.wc,'ala03,ala02,ala08,ala04') 
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED          # TQC-730088
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED       
###GENGRE###     LET g_str = tm.wc         
   # CALL cl_prt_cs3('aapg700',g_sql,g_str)                # TQC-730088 
###GENGRE###     CALL cl_prt_cs3('aapg700','aapg700',g_sql,g_str)  
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "ala01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL aapg700_grdata()    ###GENGRE###
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
#No.FUN-710086--end
END FUNCTION
 
#No.FUN-710086--begin
#REPORT g700_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          sr               RECORD ala01 LIKE ala_file.ala01, # L/C 開狀單頭檔
#                                  ala02 LIKE ala_file.ala02,
#                                  ala03 LIKE ala_file.ala03,
#                                  ala05 LIKE ala_file.ala05,
#                                  ala06 LIKE ala_file.ala06,
#                                  ala07 LIKE ala_file.ala07,
#                                  ala08 LIKE ala_file.ala08,
#                                  ala36 LIKE ala_file.ala36,
#                                  ala11 LIKE ala_file.ala11,
#                                  ala20 LIKE ala_file.ala20,
#                                  ala21 LIKE ala_file.ala21,
#                                  ala22 LIKE ala_file.ala22,
#                                  ala23 LIKE ala_file.ala23,
#                                  ala32 LIKE ala_file.ala32,
#                                  ala35 LIKE ala_file.ala35,
#                                  ala37 LIKE ala_file.ala37,
#                                  ala38 LIKE ala_file.ala38,
#                                  ala39 LIKE ala_file.ala39,
#                                  ala51 LIKE ala_file.ala51,
#                                  ala52 LIKE ala_file.ala52,
#                                  ala53 LIKE ala_file.ala53,
#                                  ala54 LIKE ala_file.ala54,
#                                  ala55 LIKE ala_file.ala55,
#                                  ala56 LIKE ala_file.ala56,
#                                  ala57 LIKE ala_file.ala57,
#                                  alb02 LIKE alb_file.alb02, #
#                                  alb03 LIKE alb_file.alb03, #
#                                  alb04 LIKE alb_file.alb04, # L/C 採購單身檔
#                                  alb05 LIKE alb_file.alb05,
#                                  alb06 LIKE alb_file.alb06,
#                                  alb07 LIKE alb_file.alb07,
#                                  alb08 LIKE alb_file.alb08,
#                                  alb11 LIKE alb_file.alb11, # 料號
#                                  pmn041 LIKE pmn_file.pmn041, # 品名
#                                  pmn07 LIKE pmn_file.pmn07, # 採購單位
#                                  pmc03 LIKE pmc_file.pmc03, # 廠商名稱
#                                  alg02 LIKE alg_file.alg02, # 銀行簡稱
#                                  azi03 LIKE azi_file.azi03,
#                                  azi04 LIKE azi_file.azi04,
#                                  azi05 LIKE azi_file.azi05,
#                                  alb80 LIKE alb_file.alb80,  #FUN-710029
#                                  alb81 LIKE alb_file.alb81,  #FUN-710029
#                                  alb82 LIKE alb_file.alb82,  #FUN-710029
#                                  alb83 LIKE alb_file.alb83,  #FUN-710029
#                                  alb84 LIKE alb_file.alb84,  #FUN-710029
#                                  alb85 LIKE alb_file.alb85,  #FUN-710029
#                                  alb86 LIKE alb_file.alb86,  #FUN-710029
#                                  alb87 LIKE alb_file.alb87,  #FUN-710029
#                                  pmn20 LIKE pmn_file.pmn20   #FUN-710029
#                        END RECORD,
#      l_tmp        LIKE ala_file.ala52,      # 結匯應付
#      l_amt_1      LIKE alb_file.alb08,      #No:8507
#      l_chr        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#      l_str2       LIKE type_file.chr1000, #FUN-710029
#      l_ima021     LIKE ima_file.ima021,   #FUN-710029 
#      l_ima906     LIKE ima_file.ima906,   #FUN-710029
#      l_alb85      LIKE alb_file.alb85,    #FUN-710029
#      l_alb82      LIKE alb_file.alb82,    #FUN-710029
#      l_pmn20      LIKE pmn_file.pmn20     #FUN-710029
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ala01, sr.alb02
##No.FUN-590110-begin
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
# 
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#      LET l_chr = 'N'       # 尚未印過"採購單號"
#
#  BEFORE GROUP OF sr.ala01
#      IF l_chr = 'Y' THEN   # 不同之"採購單號"要跳頁
#         SKIP TO TOP OF PAGE
#      END IF
#      LET l_amt_1 = 0
#      LET l_tmp = 0
#      LET l_chr = 'Y'
#      PRINT COLUMN 1,  g_x[11] CLIPPED, ' ', sr.ala01,
#            COLUMN 53, g_x[12] CLIPPED, ' ', sr.ala08
#      PRINT COLUMN 1,  g_x[13] CLIPPED, ' ', sr.ala05,COLUMN 23,sr.pmc03,
#            COLUMN 53, g_x[37] CLIPPED, ' ', sr.ala03 CLIPPED
#      SELECT pmc03 INTO sr.pmc03 FROM pmc_file
#       WHERE pmc01 = sr.ala06
#      PRINT COLUMN 1,g_x[39] CLIPPED,' ',sr.ala06 ,COLUMN 23,sr.pmc03,
#            COLUMN 53,g_x[38] CLIPPED,' ',sr.ala11 CLIPPED
#      PRINT COLUMN 1,  g_x[14] CLIPPED, ' ', sr.ala02,
#            COLUMN 53, g_x[40] CLIPPED,' ',sr.ala37
#      PRINT COLUMN 1,  g_x[15] CLIPPED, ' ', sr.ala36 CLIPPED
#      PRINT COLUMN 1,  g_x[16] CLIPPED, ' ', sr.ala07, COLUMN 21,sr.alg02
#            #COLUMN 53, g_x[40] CLIPPED, ' ', sr.ala37
#      PRINT COLUMN 1,  g_x[41] CLIPPED, ' ', sr.ala38,
#            COLUMN 53, g_x[17] CLIPPED, ' ', sr.ala20 clipped,
#                       cl_numfor(sr.ala23,18,sr.azi04)
#      PRINT COLUMN 1,g_x[42] CLIPPED,' ',sr.ala39
#      PRINT g_dash2[1,g_len]
#      #FUN-5A0180-begin
#      #PRINTX name=H1 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]
#      PRINTX name=H1 g_x[43],g_x[44],g_x[45]
#      PRINTX name=H2 g_x[49],g_x[50],g_x[53]
#      #PRINTX name=H3 g_x[51],g_x[52],g_x[46],g_x[47],g_x[48]
#      PRINTX name=H3 g_x[51],g_x[52],g_x[46],
#                     g_x[55],g_x[56],         #FUN-710029 
#                     g_x[47],g_x[48],g_x[54]  #FUN-710029 add g_x[54]
#      #FUN-5A0180-end
#      PRINT g_dash1
#
#   ON EVERY ROW
##NO.FUN-710029 start----
#      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                         WHERE ima01=sr.alb11
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.alb85) RETURNING l_alb85
#                LET l_str2 = l_alb85 , sr.alb83 CLIPPED
#                IF cl_null(sr.alb85) OR sr.alb85 = 0 THEN
#                    CALL cl_remove_zero(sr.alb82) RETURNING l_alb82
#                    LET l_str2 = l_alb82, sr.alb80 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.alb82) AND sr.alb82 > 0 THEN
#                      CALL cl_remove_zero(sr.alb82) RETURNING l_alb82
#                      LET l_str2 = l_str2 CLIPPED,',',l_alb82, sr.alb80 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.alb85) AND sr.alb85 > 0 THEN
#                    CALL cl_remove_zero(sr.alb85) RETURNING l_alb85
#                    LET l_str2 = l_alb85 , sr.alb83 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma116 MATCHES '[13]' THEN 
#            IF sr.pmn07 <> sr.alb86 THEN 
#               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
#               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
#            END IF
#      END IF
##NO.FUN-710029 end--------------
#      #FUN-5A0180-begin
#      #PRINTX name=D1 COLUMN g_c[43], sr.alb04 CLIPPED,
#      #      COLUMN g_c[44], sr.alb05 USING '#####',
#      #      COLUMN g_c[45], sr.alb11 CLIPPED,
#      #      COLUMN g_c[46], cl_numfor(sr.alb06,46,sr.azi03) CLIPPED,
#      #      COLUMN g_c[47], cl_numfor(sr.alb07,47,3),
#      #      COLUMN g_c[48], cl_numfor(sr.alb08,48,sr.azi04) CLIPPED
#      #PRINT COLUMN g_c[45], sr.pmn041 CLIPPED
#      PRINTX name=D1
#             COLUMN g_c[43], sr.alb04 CLIPPED,
#             COLUMN g_c[44], sr.alb05 USING '###&', #FUN-590118
#             COLUMN g_c[45], sr.alb11 CLIPPED
#      PRINTX name=D2
##             COLUMN g_c[45],sr.pmn041 CLIPPED    #MOD-5B0093
#             COLUMN g_c[53],sr.pmn041 CLIPPED    #MOD-5B0093
#      PRINTX name=D3
#             COLUMN g_c[46], cl_numfor(sr.alb06,46,sr.azi03) CLIPPED,
#             COLUMN g_c[55], sr.alb86 CLIPPED,          #FUN-710029
#             COLUMN g_c[56], cl_numfor(sr.alb87,56,3),  #FUN-710029
#             COLUMN g_c[47], cl_numfor(sr.alb07,47,3),
#             COLUMN g_c[48], cl_numfor(sr.alb08,48,sr.azi04) CLIPPED,
#             COLUMN g_c[54], l_str2 CLIPPED
#      #FUN-5A0180-end
#
#   AFTER GROUP OF sr.ala01
#      LET l_amt_1 = GROUP SUM(sr.alb08)
#      LET l_tmp = sr.ala52+sr.ala53+sr.ala54+sr.ala55+sr.ala57
#      PRINTX name=D3 COLUMN g_c[47], g_x[32] CLIPPED,  #FUN-5A0180 add D3
#            COLUMN g_c[48], cl_numfor(l_amt_1,48,sr.azi05) CLIPPED
#      SKIP 2 LINE
#     #-----TQC-610092---------
#     IF cl_null(sr.ala20) THEN LET sr.ala20 = 0 END IF
#     IF cl_null(sr.ala23) THEN LET sr.ala23 = 0 END IF
#     IF cl_null(sr.ala21) THEN LET sr.ala21 = 0 END IF
#     IF cl_null(sr.ala51) THEN LET sr.ala51 = 0 END IF
#     IF cl_null(sr.ala52) THEN LET sr.ala52 = 0 END IF
#     IF cl_null(sr.ala53) THEN LET sr.ala53 = 0 END IF
#     IF cl_null(sr.ala54) THEN LET sr.ala54 = 0 END IF
#     IF cl_null(sr.ala55) THEN LET sr.ala55 = 0 END IF
#     IF cl_null(sr.ala56) THEN LET sr.ala56 = 0 END IF
#     IF cl_null(sr.ala57) THEN LET sr.ala57 = 0 END IF
#     SELECT azi07 INTO t_azi07 FROM azi_file where azi01=sr.ala20
#     PRINT COLUMN 1,g_x[22] CLIPPED,
#           COLUMN 10,sr.ala20 CLIPPED,
#           COLUMN 13,cl_numfor(sr.ala23,18,sr.azi04) CLIPPED,
#           COLUMN 31,' * ',sr.ala21 USING '##&','% * Ex.RATE ',
#           COLUMN 49,cl_numfor(sr.ala51,10,t_azi07),
#           COLUMN 59,' = ',
#           COLUMN 67,g_aza17 CLIPPED,cl_numfor(sr.ala52,18,g_azi04) CLIPPED  #TQC-6A0081
#     PRINT COLUMN 1,g_x[23] CLIPPED,
#           COLUMN 13,cl_numfor(sr.ala53,18,sr.azi04) CLIPPED,  #TQC-6A0081
#           COLUMN 42, g_x[24] CLIPPED,
#           COLUMN 70,cl_numfor(l_tmp,18,sr.azi04) CLIPPED    #TQC-6A0081
#     PRINT COLUMN 1,g_x[25] CLIPPED,
#           COLUMN 13,cl_numfor(sr.ala54,18,sr.azi04) CLIPPED  #TQC-6A0081
#     PRINT COLUMN 1,g_x[26] CLIPPED,
#           COLUMN 13,cl_numfor(sr.ala55,18,sr.azi04) CLIPPED,  #TQC-6A0081
#           COLUMN 42,g_x[27] CLIPPED,
#           COLUMN 70,cl_numfor(sr.ala56,18,sr.azi04) CLIPPED  #TQC-6A0081
#     PRINT COLUMN 1,g_x[28] CLIPPED, 
#           COLUMN 13,cl_numfor(sr.ala57,18,sr.azi04) CLIPPED  #TQC-6A0081
#     #-----END TQC-610092-----
#      SKIP 1 LINE
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
##No.FUN-590110-end
#
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
### FUN-550099
#    # PRINT g_x[04],g_x[05]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4]
#             PRINT g_memo
#      END IF
### END FUN-550099
#
#END REPORT
#No.FUN-710086--end
#Patch....NO.TQC-610035 <> #

###GENGRE###START
FUNCTION aapg700_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aapg700")
        IF handler IS NOT NULL THEN
            START REPORT aapg700_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ala01,alb05"
            DECLARE aapg700_datacur1 CURSOR FROM l_sql
            FOREACH aapg700_datacur1 INTO sr1.*
                OUTPUT TO REPORT aapg700_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg700_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aapg700_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40097---add---str-------------
    DEFINE l_ala05_pmc03   STRING
    DEFINE l_ala06_pmc03_1 STRING
    DEFINE l_ala07_alg02   STRING
    DEFINE l_ala20_ala23   STRING
    DEFINE l_ala23         STRING
    DEFINE l_sum    LIKE   ala_file.ala52
    DEFINE l_ala21         STRING 
    DEFINE l_ala51         STRING
    DEFINE l_ala52         STRING
    DEFINE l_alb08_sum     LIKE alb_file.alb08
    DEFINE l_alb06_fmt     STRING
    DEFINE l_alb08_fmt     STRING
    DEFINE l_alb08_sum_fmt STRING
    DEFINE l_ala23_fmt     STRING
    DEFINE l_ala53_fmt     STRING
    DEFINE l_ala52_fmt     STRING
    DEFINE l_ala51_fmt     STRING
    DEFINE l_ala54_fmt     STRING
    DEFINE l_ala55_fmt     STRING
    DEFINE l_ala57_fmt     STRING
    DEFINE l_sum_fmt       STRING
    DEFINE l_ala56_fmt     STRING
    #FUN-B40097---add---end-------------
    
    ORDER EXTERNAL BY sr1.ala01,sr1.alb02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ala01
            LET l_lineno = 0
            #FUN-B40097---add---str-------------
            LET l_alb06_fmt = cl_gr_numfmt('alb_file','alb06',sr1.azi03)
            PRINTX l_alb06_fmt
            LET l_alb08_fmt = cl_gr_numfmt('alb_file','alb08',sr1.azi04)
            PRINTX l_alb08_fmt
            LET l_alb08_sum_fmt = cl_gr_numfmt('alb_file','alb08',sr1.azi04)
            PRINTX l_alb08_sum_fmt
            LET l_ala23_fmt = cl_gr_numfmt('ala_file','ala23',sr1.azi04)
            PRINTX l_ala23_fmt
            LET l_ala51_fmt = cl_gr_numfmt('ala_file','ala51',sr1.t_azi07)
            PRINTX l_ala51_fmt
            LET l_ala52_fmt = cl_gr_numfmt('ala_file','ala52',g_azi04)
            PRINTX l_ala52_fmt
            LET l_ala53_fmt = cl_gr_numfmt('ala_file','ala53',sr1.azi04)
            PRINTX l_ala53_fmt
            LET l_ala54_fmt = cl_gr_numfmt('ala_file','ala54',sr1.azi04)
            PRINTX l_ala54_fmt
            LET l_ala55_fmt = cl_gr_numfmt('ala_file','ala55',sr1.azi04)
            PRINTX l_ala55_fmt
            LET l_ala57_fmt = cl_gr_numfmt('ala_file','ala57',sr1.azi04)
            PRINTX l_ala57_fmt
            LET l_ala05_pmc03 = sr1.ala05,' ',sr1.pmc03
            LET l_ala06_pmc03_1 = sr1.ala06,' ',sr1.pmc03
            LET l_ala07_alg02 = sr1.ala07,' ',sr1.alg02

            LET l_ala23 = sr1.ala23 USING '--,---,---,---,---,--&.&&'
            LET l_ala20_ala23 = sr1.ala20,' ',l_ala23 
            PRINTX l_ala05_pmc03
            PRINTX l_ala06_pmc03_1
            PRINTX l_ala07_alg02
            PRINTX l_ala20_ala23 
            #FUN-B40097---add---end-------------  

        BEFORE GROUP OF sr1.alb02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.ala01
            #FUN-B40097---add---str-------------
            LET l_alb08_sum = GROUP SUM(sr1.alb08)
            PRINTX l_alb08_sum
  
            LET l_sum = sr1.ala52 + sr1.ala53 + sr1.ala54 + sr1.ala55 + sr1.ala57
            LET l_sum_fmt = cl_gr_numfmt('ala_file','ala52',sr1.azi04)
            PRINTX l_sum
            PRINTX l_sum_fmt

            LET l_ala21 = sr1.ala21 USING '--,---,---,---,---,--&.&&'
        #   LET l_ala51 = sr1.ala51 USING '--,---,---,---,---,--&.&&'      #MOD-BC0151 mark
            #LET l_ala51 = cl_numfor(sr1.ala51,20,t_azi07)                  #MOD-BC0151 add #FUN-C30085 mark
            LET l_ala51 = cl_numfor(sr1.ala51,20,sr1.t_azi07)  #FUN-C30085 add
            LET l_ala52 = sr1.ala52 USING '--,---,---,---,---,--&.&&'
            LET l_ala20_ala23 = sr1.ala20,' ',l_ala23,'*',l_ala21,"% * Ex.RATE",' ',l_ala51,' ','=',l_ala52
            PRINTX l_ala20_ala23

            LET l_ala56_fmt = cl_gr_numfmt('ala_file','ala56',sr1.azi04)
            PRINTX l_ala56_fmt
            #FUN-B40097---add---end-------------
        AFTER GROUP OF sr1.alb02

        
        ON LAST ROW

END REPORT
###GENGRE###END
