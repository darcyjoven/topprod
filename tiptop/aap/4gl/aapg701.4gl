# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapg701.4gl
# Descriptions...: 預付購料款申請書列印作業
# Date & Author..: 93/02/02  By  Felicity  Tseng
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-620090 06/03/02 By Smapmin 幣別取位有誤
# Modify.........: No.MOD-640018 06/04/07 By Smapmin 加入alc02<>0的條件
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位類型修改
# Modify.........: No.FUN-6A0055 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/14 By baogui 報表問題修baogui 報表問題修改
# Modify.........: No.TQC-6B0128 06/12/01 By xufeng 修改報表
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.FUN-710086 07/03/01 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-850002 08/05/05 By Smapmin 畫面上的帳款部門應為ala04,不是alc04
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:CHI-AA0015 10/11/05 By Summer alc02原為vachar(1)改為Number(5)
# Modify.........: No:MOD-AC0068 10/12/09 By Dido 報表原 alc24 -> ala38;alc34 -> ala39
# Modify.........: No.FUN-B40092 11/05/04 By xujing  憑證報表轉GRW 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C20051 12/03/01 By yangtt GR調整
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/04/28 By yangtt GR程式優化
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000,  #No.FUN-690028 VARCHAR(600),       # Where condition
              more    LIKE type_file.chr1      #No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
          p_wc  LIKE type_file.chr50,   #No.FUN-690028 VARCHAR(40),
          g_argument  LIKE ala_file.ala01,
          g_aza17 LIKE aza_file.aza17  # 本國幣別
 
DEFINE   g_i      LIKE type_file.num5   #No.FUN-690028  SMALLINT   #count/index for any purpose
DEFINE   g_sma116    LIKE sma_file.sma116      #FUN-710029
DEFINE   g_sma115    LIKE sma_file.sma115      #FUN-710029
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
    alc01 LIKE alc_file.alc01,
    alc02 LIKE alc_file.alc02,
    alc08 LIKE alc_file.alc08,
    alc24 LIKE alc_file.alc24,
    alc32 LIKE alc_file.alc32,
    alc34 LIKE alc_file.alc34,
    alc51 LIKE alc_file.alc51,
    alc52 LIKE alc_file.alc52,
    alc53 LIKE alc_file.alc53,
    alc54 LIKE alc_file.alc54,
    alc55 LIKE alc_file.alc55,
    alc56 LIKE alc_file.alc56,
    alc57 LIKE alc_file.alc57,
    alc60 LIKE alc_file.alc60,
    all02 LIKE all_file.all02,
    all04 LIKE all_file.all04,
    all05 LIKE all_file.all05,
    all06 LIKE all_file.all06,
    all07 LIKE all_file.all07,
    all08 LIKE all_file.all08,
    all11 LIKE all_file.all11,
    pmn041 LIKE pmn_file.pmn041,
    pmn07 LIKE pmn_file.pmn07,
    pmc03 LIKE pmc_file.pmc03,
    pma02 LIKE pma_file.pma02,
    nma02 LIKE nma_file.nma02,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    all80 LIKE all_file.all80,
    all81 LIKE all_file.all81,
    all82 LIKE all_file.all82,
    all83 LIKE all_file.all83,
    all84 LIKE all_file.all84,
    all85 LIKE all_file.all85,
    all86 LIKE all_file.all86,
    all87 LIKE all_file.all87,
    pmn20 LIKE pmn_file.pmn20,
    ala97 LIKE ala_file.ala97,     #FUN-C20051 add
    pmc03_1 LIKE pmc_file.pmc03,
    str2 LIKE type_file.chr50,
    flag LIKE type_file.chr1,
    g_azi04 LIKE azi_file.azi04,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-BB0047  mark 

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
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
 
#No.FUN-710086--begin 
   LET g_sql = "ala01.ala_file.ala01,",  
               "ala02.ala_file.ala02,",   
               "ala03.ala_file.ala03,",   
               "ala05.ala_file.ala05,",   
               "ala06.ala_file.ala06,",   
               "ala07.ala_file.ala07,",   
               "ala08.ala_file.ala08,",   
               "ala36.ala_file.ala36,",   
               "ala11.ala_file.ala11,",   
               "ala20.ala_file.ala20,",   
               "ala21.ala_file.ala21,",   
               "ala22.ala_file.ala22,",   
               "ala23.ala_file.ala23,",   
               "ala32.ala_file.ala32,",   
               "ala35.ala_file.ala35,",   
               "ala37.ala_file.ala37,",   
               "ala38.ala_file.ala38,",   
               "ala39.ala_file.ala39,",   
               "ala51.ala_file.ala51,",   
               "ala52.ala_file.ala52,",   
               "ala53.ala_file.ala53,",   
               "ala54.ala_file.ala54,",   
               "ala55.ala_file.ala55,",   
               "ala56.ala_file.ala56,",   
               "ala57.ala_file.ala57,",   
               "alc01.alc_file.alc01,",   
               "alc02.alc_file.alc02,",   
               "alc08.alc_file.alc08,",   
               "alc24.alc_file.alc24,",   
               "alc32.alc_file.alc32,",   
               "alc34.alc_file.alc34,",   
               "alc51.alc_file.alc51,",   
               "alc52.alc_file.alc52,",   
               "alc53.alc_file.alc53,",   
               "alc54.alc_file.alc54,",   
               "alc55.alc_file.alc55,",   
               "alc56.alc_file.alc56,",   
               "alc57.alc_file.alc57,",   
               "alc60.alc_file.alc60,",   
               "all02.all_file.all02,",   
               "all04.all_file.all04,",   
               "all05.all_file.all05,",   
               "all06.all_file.all06,",   
               "all07.all_file.all07,",   
               "all08.all_file.all08,",   
               "all11.all_file.all11,",   
               "pmn041.pmn_file.pmn041,", 
               "pmn07.pmn_file.pmn07,",   
               "pmc03.pmc_file.pmc03,",    
               "pma02.pma_file.pma02,",   
               "nma02.nma_file.nma02,",   
               "azi03.azi_file.azi03,",   
               "azi04.azi_file.azi04,",   
               "azi05.azi_file.azi05,",   
               "all80.all_file.all80,",   
               "all81.all_file.all81,",   
               "all82.all_file.all82,",   
               "all83.all_file.all83,",   
               "all84.all_file.all84,",   
               "all85.all_file.all85,",   
               "all86.all_file.all86,",   
               "all87.all_file.all87,",   
               "pmn20.pmn_file.pmn20,",   
               "ala97.ala_file.ala97,",      #FUN-C20051 add
               "pmc03_1.pmc_file.pmc03,",
               "str2.type_file.chr50,",
               "flag.type_file.chr1,",
               "g_azi04.azi_file.azi04,",
               "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
               "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
               "sign_show.type_file.chr1,",                       #FUN-C40019 add
               "sign_str.type_file.chr1000"                       #FUN-C40019 add
               
   LET l_table = cl_prt_temptable('aapg701',g_sql) CLIPPED 
   IF l_table = -1 THEN
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092  #FUN-BB0047 mark
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"    #FUN-C20051 add 1?    #FUN-C40019 add 4?
   PREPARE insert_prep FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092  #FUN-BB0047 mark
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM    
   END IF                           
#No.FUN-710086--end 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-BB0047  add
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file #FUN-710029
      IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
         THEN CALL g701_tm(0,0)           # Input print condition
         ELSE CALL g701()                 # Read data and create out-file
      END IF
 # END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table) #FUN-B40092
END MAIN
 
FUNCTION g701_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,   #No.FUN-690028  SMALLINT,
          l_cmd         LIKE type_file.chr1000   #No.FUN-690028  VARCHAR(700)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 5
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW g701_w AT p_row,p_col
        WITH FORM "aap/42f/aapg701"
################################################################################
# START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
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
      #CONSTRUCT BY NAME tm.wc ON alc01,alc02,alc08,alc04   #FUN-850002
      CONSTRUCT BY NAME tm.wc ON alc01,alc02,alc08,ala04   #FUN-850002
         ON ACTION locale
            #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
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
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alcuser', 'alcgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CLOSE WINDOW g701_w 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           CALL cl_gre_drop_temptable(l_table)      #FUN-B40092
           EXIT PROGRAM
        END IF
        INPUT BY NAME tm.more WITHOUT DEFAULTS
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
        END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)      #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapg701'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapg701','9031',1)
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
         CALL cl_cmdat('aapg701',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)      #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   END IF
   CALL g701()
   ERROR ""
END WHILE
   CLOSE WINDOW g701_w
END FUNCTION
 
FUNCTION g701()
   DEFINE l_name    LIKE type_file.chr20,  #No.FUN-690028 VARCHAR(20),  # External(Disk) file name
#         l_time          LIKE type_file.chr8        #No.FUN-6A0055
          l_sql     LIKE type_file.chr1000,  #No.FUN-690028 VARCHAR(1200),      # RDSQL STATEMENT
          l_za05    LIKE type_file.chr50,  #No.FUN-690028 VARCHAR(40),
          l_order   ARRAY[5] OF LIKE type_file.chr10,  #No.FUN-690028 VARCHAR(10),
          sr_1             RECORD ala01 LIKE ala_file.ala01, # L/C 開狀單頭檔
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
                                  ala57 LIKE ala_file.ala57
              END RECORD,
   sr         RECORD              alc01 LIKE alc_file.alc01,
                                  alc02 LIKE alc_file.alc02,
                                  alc08 LIKE alc_file.alc08,
                                  alc24 LIKE alc_file.alc24,
                                  alc32 LIKE alc_file.alc32,
                                  alc34 LIKE alc_file.alc34,
                                  alc51 LIKE alc_file.alc51,
                                  alc52 LIKE alc_file.alc52,
                                  alc53 LIKE alc_file.alc53,
                                  alc54 LIKE alc_file.alc54,
                                  alc55 LIKE alc_file.alc55,
                                  alc56 LIKE alc_file.alc56,
                                  alc57 LIKE alc_file.alc57,
                                  alc60 LIKE alc_file.alc60,
                                  all02 LIKE all_file.all02, #
                                  all04 LIKE all_file.all04, # L/C 採購單身檔
                                  all05 LIKE all_file.all05,
                                  all06 LIKE all_file.all06,
                                  all07 LIKE all_file.all07,
                                  all08 LIKE all_file.all08,
                                  all11 LIKE all_file.all11, # 料號
                                  pmn041 LIKE pmn_file.pmn041, # 品名
                                  pmn07 LIKE pmn_file.pmn07,# 採購單位
                                  pmc03 LIKE pmc_file.pmc03, # 廠商名稱
                                  pma02 LIKE pma_file.pma02, # 付款方式
                                  nma02 LIKE nma_file.nma02, # 銀行簡稱
                                  azi03 LIKE azi_file.azi03,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  all80 LIKE all_file.all80,  #FUN-710029
                                  all81 LIKE all_file.all81,  #FUN-710029
                                  all82 LIKE all_file.all82,  #FUN-710029
                                  all83 LIKE all_file.all83,  #FUN-710029
                                  all84 LIKE all_file.all84,  #FUN-710029
                                  all85 LIKE all_file.all85,  #FUN-710029
                                  all86 LIKE all_file.all86,  #FUN-710029
                                  all87 LIKE all_file.all87,  #FUN-710029
                                  pmn20 LIKE pmn_file.pmn20,  #FUN-710029
                                  ala97 LIKE ala_file.ala97   #FUN-A60056
                        END RECORD
#No.FUN-710086--begin
   DEFINE  l_tmp        LIKE all_file.all08,      # 結匯應付
           l_zx02       LIKE zx_file.zx02,
           l_amt_1      LIKE all_file.all08,
           l_amt_2      LIKE all_file.all08,
           l_chr        LIKE type_file.chr1,  
           l_str2       LIKE type_file.chr1000, 
           l_ima021     LIKE ima_file.ima021,   
           l_ima906     LIKE ima_file.ima906,  
           l_pmc03      LIKE pmc_file.pmc03,
           l_all85      LIKE all_file.all85,   
           l_all82      LIKE all_file.all82,   
           l_flag       LIKE type_file.chr1,          #標示打印何種水晶報表的格式
           l_pmn20      LIKE pmn_file.pmn20    
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
 
     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
 
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aapg701'
#No.FUN-710086--end      
 
   #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105 MARK
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO 106 LET g_dash[g_i,g_i] = '=' END FOR  #TQC-6A0081
     LET g_len = 106
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND alcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND alcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     SELECT aza17 INTO g_aza17     # 本國幣別
       FROM aza_file
      WHERE aza01 = '0'
     LET l_sql = "SELECT ",
                 " alc01,alc02,alc08,alc24,alc32,alc34,alc51,alc52,alc53,",
                 " alc54,alc55,alc56,alc57,alc60,",
                 " all02, all04, all05, all06, all07, ",
                #" all08, all11, pmn041, pmn07,'','','','','','',  ",   #FUN-A60056
                 " all08, all11, ''    , ''   ,'','','','','','',  ",   #FUN-A60056
                #" all80, all81, all82, all83, all84, all85, all86, all87, pmn20 ",  #FUN-710029   #FUN-A60056
                 " all80, all81, all82, all83, all84, all85, all86, all87, '' ,ala97 ",  #FUN-A60056
                #" FROM alc_file,OUTER (all_file, OUTER pmn_file),",   #FUN-A60056
                #" FROM alc_file,OUTER all_file, ",                    #FUN-A60056    #FUN-C50003 mark
                #"      ala_file",   #FUN-850002                                      #FUN-C50003 mark 
                 " FROM alc_file LEFT OUTER JOIN all_file ON alc01=all01",    #FUN-C50003 add
                 "  AND alc02=all00, ala_file ",                              #FUN-C50003 add
                #" WHERE alc_file.alc01=all_file.all01 ",                             #FUN-C50003 mark
                #" AND alc_file.alc02=all_file.all00 ",                               #FUN-C50003 mark
                #" AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0             #FUN-C50003 mark
                 " WHERE alc02 <> 0",                                                 #FUN-C50003 add
                #" AND pmn_file.pmn01 = all_file.all04 ",   #FUN-A60056
                #" AND pmn_file.pmn02 = all_file.all05 ",   #FUN-A60056
                 " AND ala01 = alc01 ",   #FUN-850002    
                 " AND alcfirm <> 'X' ",  #CHI-C80041       
                 " AND ", tm.wc CLIPPED
     PREPARE g701_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare :',SQLCA.sqlcode,1)
        display l_sql
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)      #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE g701_curs1 CURSOR FOR g701_prepare1
#No.FUN-710086--begin
#     CALL cl_outnam('aapg701') RETURNING l_name
#FUN-710029 start------#zaa06隱藏否
    IF g_sma116 MATCHES '[13]' THEN
        LET l_flag ='1' 
#        LET g_zaa[45].zaa06 = "N" #計價單位
#        LET g_zaa[46].zaa06 = "N" #計價數量
#        LET g_zaa[48].zaa06 = "Y" #數量
    ELSE
        LET l_flag ='2'
#        LET g_zaa[45].zaa06 = "Y" #計價單位
#        LET g_zaa[46].zaa06 = "Y" #計價數量
#        LET g_zaa[48].zaa06 = "N" #數量
    END IF
    IF g_sma115 = "Y" AND g_sma116 NOT MATCHES '[13]' THEN
       LET l_flag ='3'
    END IF
#    IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[44].zaa06 = "N" #單位註解
#    ELSE
#        LET g_zaa[44].zaa06 = "Y" #單位註解
#    END IF
#    CALL cl_prt_pos_len()
#FUN-710029 end------------
#     START REPORT g701_rep TO l_name
#     LET g_pageno = 0
#No.FUN-710086--end
     FOREACH g701_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #FUN-A60056--add--str--
          LET l_sql = "SELECT pmn041,pmn07,pmn20 ",
                      "  FROM ",cl_get_target_table(sr.ala97,'pmn_file'),
                      " WHERE pmn01 = '",sr.all04,"'",
                      "   AND pmn02 = '",sr.all05,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,sr.ala97) RETURNING l_sql
          PREPARE sel_pmn041 FROM l_sql
          EXECUTE sel_pmn041 INTO sr.pmn041,sr.pmn07,sr.pmn20
          #FUN-A60056--add--end
          IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF   #MOD-620090 取消mark
          IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF   #MOD-620090 取消mark 
          IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF   #MOD-620090 取消mark
#No.FUN-710086--begin
      SELECT ala01,ala02,ala03,ala05,ala06,ala07,ala11,ala21,
             ala36,ala37,ala20,ala38,ala39                         #MOD-AC0068 add ala38,ala39
             INTO sr_1.ala01,sr_1.ala02,sr_1.ala03,sr_1.ala05, 
                  sr_1.ala06,sr_1.ala07,sr_1.ala11,sr_1.ala21,
                 #sr_1.ala36,sr_1.ala37,sr_1.ala20  FROM ala_file  #MOD-AC0068 mark 
                  sr_1.ala36,sr_1.ala37,sr_1.ala20,sr_1.ala38,     #MOD-AC0068 
                  sr_1.ala39                                       #MOD-AC0068 
        FROM ala_file                                              #MOD-AC0068 
       WHERE ala01 = sr.alc01 AND alafirm <> 'X'
 
      SELECT pmc03 INTO sr.pmc03 FROM pmc_file  
             WHERE pmc01 = sr_1.ala05 
 
      SELECT pmc03 INTO l_pmc03 FROM pmc_file
       WHERE pmc01 = sr_1.ala06
 
      SELECT azi03,azi04,azi05 INTO sr.azi03,sr.azi04,sr.azi05 
        FROM azi_file
        WHERE azi01=sr_1.ala20
 
 
      Select pma02 into sr.pma02 from pma_file
       Where pma01 = sr_1.ala02
 
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file 
                         WHERE ima01=sr.all11                  
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.all85) RETURNING l_all85
                LET l_str2 = l_all85 , sr.all83 CLIPPED
                IF cl_null(sr.all85) OR sr.all85 = 0 THEN
                    CALL cl_remove_zero(sr.all82) RETURNING l_all82
                    LET l_str2 = l_all82, sr.all80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.all82) AND sr.all82 > 0 THEN
                      CALL cl_remove_zero(sr.all82) RETURNING l_all82
                      LET l_str2 = l_str2 CLIPPED,',',l_all82, sr.all80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.all85) AND sr.all85 > 0 THEN
                    CALL cl_remove_zero(sr.all85) RETURNING l_all85
                    LET l_str2 = l_all85 , sr.all83 CLIPPED
                END IF
         END CASE
      END IF
      IF g_sma116 MATCHES '[13]' THEN 
            IF sr.pmn07 <> sr.all86 THEN 
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      END IF
 
      EXECUTE insert_prep USING  sr_1.*,sr.*,l_pmc03,l_str2,l_flag,g_azi04,      
                                 "",l_img_blob,"N",""    #FUN-C40019 add
#          OUTPUT TO REPORT g701_rep(sr.*)
#No.FUN-710086--end
     END FOREACH
#No.FUN-710086--begin
#     FINISH REPORT g701_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL cl_wcchp(tm.wc,'alc01,alc02,alc08,alc04')    #FUN-850002
     CALL cl_wcchp(tm.wc,'alc01,alc02,alc08,ala04')    #FUN-850002
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED       
###GENGRE###     LET g_str = tm.wc        
   # CALL cl_prt_cs3('aapg701',g_sql,g_str)  #TQC-730088
###GENGRE###     CALL cl_prt_cs3('aapg701','aapg701',g_sql,g_str)  
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "alc01|alc02"         #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL aapg701_grdata()    ###GENGRE###
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
#No.FUN-710086--end
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105 MARK
END FUNCTION
 
#No.FUN-710086--begin
#REPORT g701_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,  #No.FUN-690028  VARCHAR(1),
#          sr_1             RECORD ala01 LIKE ala_file.ala01, # L/C 開狀單頭檔
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
#                                  ala57 LIKE ala_file.ala57
#                  END RECORD,
#       sr         RECORD          alc01 LIKE alc_file.alc01,
#                                  alc02 LIKE alc_file.alc02,
#                                  alc08 LIKE alc_file.alc08,
#                                  alc24 LIKE alc_file.alc24,
#                                  alc32 LIKE alc_file.alc32,
#                                  alc34 LIKE alc_file.alc34,
#                                  alc51 LIKE alc_file.alc51,
#                                  alc52 LIKE alc_file.alc52,
#                                  alc53 LIKE alc_file.alc53,
#                                  alc54 LIKE alc_file.alc54,
#                                  alc55 LIKE alc_file.alc55,
#                                  alc56 LIKE alc_file.alc56,
#                                  alc57 LIKE alc_file.alc57,
#                                  alc60 LIKE alc_file.alc60,
#                                  all02 LIKE all_file.all02, #
#                                  all04 LIKE all_file.all04, # L/C 採購單身檔
#                                  all05 LIKE all_file.all05,
#                                  all06 LIKE all_file.all06,
#                                  all07 LIKE all_file.all07,
#                                  all08 LIKE all_file.all08,
#                                  all11 LIKE all_file.all11, # 料號
#                                  pmn041 LIKE pmn_file.pmn041, # 品名
#                                  pmn07 LIKE pmn_file.pmn07, # 採購單位
#                                  pmc03 LIKE pmc_file.pmc03, # 廠商名稱
#                                  pma02 LIKE pma_file.pma02, # 付款方式
#                                  nma02 LIKE nma_file.nma02, # 銀行簡稱
#                                  azi03 LIKE azi_file.azi03,
#                                  azi04 LIKE azi_file.azi04,
#                                  azi05 LIKE azi_file.azi05,
#                                  all80 LIKE all_file.all80,  #FUN-710029
#                                  all81 LIKE all_file.all81,  #FUN-710029
#                                  all82 LIKE all_file.all82,  #FUN-710029
#                                  all83 LIKE all_file.all83,  #FUN-710029
#                                  all84 LIKE all_file.all84,  #FUN-710029
#                                  all85 LIKE all_file.all85,  #FUN-710029
#                                  all86 LIKE all_file.all86,  #FUN-710029
#                                  all87 LIKE all_file.all87,  #FUN-710029
#                                  pmn20 LIKE pmn_file.pmn20   #FUN-710029
#                        END RECORD,
#      l_tmp        LIKE all_file.all08,      # 結匯應付
#      l_zx02       LIKE zx_file.zx02,
#      l_amt_1      LIKE all_file.all08,
#      l_amt_2      LIKE all_file.all08,
#      l_chr        LIKE type_file.chr1,  #No.FUN-690028  VARCHAR(1)
#      l_str2       LIKE type_file.chr1000, #FUN-710029
#      l_ima021     LIKE ima_file.ima021,   #FUN-710029 
#      l_ima906     LIKE ima_file.ima906,   #FUN-710029
#      l_all85      LIKE all_file.all85,    #FUN-710029
#      l_all82      LIKE all_file.all82,    #FUN-710029
#      l_pmn20      LIKE pmn_file.pmn20     #FUN-710029
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN 0 BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
##  ORDER BY sr.ala01, sr.all02
#  ORDER BY sr.alc01, sr.alc02
#  FORMAT
#   PAGE HEADER   
#      PRINT (100-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED    #TQC-6A0081
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (106-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED    #TQC-6A0081
#      PRINT (100-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED    #TQC-6A0081 
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 106-7,g_x[3] CLIPPED,PAGENO USING '<<<'  #TQC-6A0081 
#      PRINT g_dash[1,106]    #TQC-6A0081
#      LET l_last_sw = 'n'
#      LET l_chr = 'N'       # 尚未印過"採購單號"
#      LET l_amt_2 = 0
## Wendy 990407---B---
#      SELECT ala01,ala02,ala03,ala05,ala06,ala07,ala11,ala21,
#             #ala36,ala37   #MOD-620090
#             ala36,ala37,ala20   #MOD-620090
#             #INSERT INTO sr_1.ala01,sr_1.ala02,sr_1.ala03,sr_1.ala05,   #MOD-620090
#             INTO sr_1.ala01,sr_1.ala02,sr_1.ala03,sr_1.ala05,   #MOD-620090
#                  sr_1.ala06,sr_1.ala07,sr_1.ala11,sr_1.ala21,
#                  #sr_1.ala36,sr_1.ala37  FROM ala_file   #MOD-620090
#                  sr_1.ala36,sr_1.ala37,sr_1.ala20  FROM ala_file   #MOD-620090
#             WHERE ala01 = sr.alc01 AND alafirm <> 'X'
#      #SELECT pmc03 INSERT INTO sr.pmc03 FROM pmc_file   #MOD-620090
#      SELECT pmc03 INTO sr.pmc03 FROM pmc_file   #MOD-620090
#             WHERE pmc01 = sr_1.ala05 AND alafirm <> 'X'
#      #-----MOD-620090---------
#      SELECT azi03,azi04,azi05 INTO sr.azi03,sr.azi04,sr.azi05 
#        FROM azi_file
#        WHERE azi01=sr_1.ala20
#      #-----END MOD-620090-----
##----E------
#  BEFORE GROUP OF sr.alc02
#      IF l_chr = 'Y' THEN   # 不同之"修改次數"要跳頁
#         SKIP TO TOP OF PAGE
#      END IF
#      LET l_amt_1 = 0
#      LET l_tmp = 0
#      LET l_chr = 'Y'
#      PRINT COLUMN 1,  g_x[11] CLIPPED, ' ', sr.alc01,
#            #COLUMN 26, 'Upd tms:',sr.alc02,   #MOD-620090
#            COLUMN 26, g_x[43],sr.alc02,   #MOD-620090
#            COLUMN 53, g_x[12] CLIPPED, ' ', sr.alc08
#      PRINT COLUMN 1,  g_x[13] CLIPPED, ' ', sr_1.ala05,COLUMN 23, sr.pmc03,
#            COLUMN 53, g_x[37] CLIPPED, ' ', sr_1.ala03 CLIPPED
#      SELECT pmc03 INTO sr.pmc03 FROM pmc_file
#       WHERE pmc01 = sr_1.ala06
#      PRINT COLUMN 1,g_x[39] CLIPPED,' ',sr_1.ala06 ,COLUMN 23,sr.pmc03,
#            COLUMN 53,g_x[38] CLIPPED,' ',sr_1.ala11 CLIPPED
## Wendy 98/12/17
#      Select pma02 into sr.pma02 from pma_file
#       Where pma01 = sr_1.ala02
#      PRINT COLUMN 1,  g_x[14] CLIPPED, ' ', sr_1.ala02,' ',sr.pma02,
#            COLUMN 53, g_x[40] CLIPPED,' ',sr_1.ala37
#      PRINT COLUMN 1,  g_x[15] CLIPPED, ' ', sr_1.ala36 CLIPPED
#      PRINT COLUMN 1,  g_x[16] CLIPPED, ' ', sr_1.ala07, '  ', sr.nma02
#      #PRINT COLUMN 1,  g_x[41] CLIPPED, ' ', sr.alc24,   #MOD-620090 
#      PRINT COLUMN 1,  g_x[41] CLIPPED, ' ', cl_numfor(sr.alc24,18,sr.azi04),   #MOD-620090
#            COLUMN 53, g_x[17] CLIPPED, ' ', sr_1.ala20 clipped,
#                       cl_numfor(sr.alc24,18,sr.azi04)
#      #PRINT COLUMN 1,g_x[42] CLIPPED,' ',sr.alc34   #MOD-620090
#      PRINT COLUMN 1,g_x[42] CLIPPED,' ',cl_numfor(sr.alc34,18,sr.azi04)   #MOD-620090
#      SKIP 1 LINE
##NO.FUN-710029 start---
##      PRINT g_x[19] CLIPPED, COLUMN 44, g_x[20] CLIPPED   #FUN-710029 mark
#      PRINT g_x[19] CLIPPED;
#      IF g_sma116 MATCHES '[13]' THEN
#          PRINT COLUMN 44, g_x[45] CLIPPED,   #計價單位
#                COLUMN 60, g_x[46] CLIPPED,   #計價數量
#                COLUMN 76, g_x[47] CLIPPED,   #單價
#                COLUMN 92, g_x[49] CLIPPED;   #金額
#      ELSE 
#          PRINT COLUMN 44, g_x[47] CLIPPED,
#                COLUMN 60, g_x[48] CLIPPED,   #數量
#                COLUMN 76, g_x[49] CLIPPED;
#      END IF           
#      IF (g_sma115 = "Y" AND g_sma116 MATCHES '[13]') OR  #使用多單位/使用計價單位
#         (g_sma115 = "N" AND g_sma116 MATCHES '[13]') THEN
#          PRINT COLUMN 111,g_x[44] CLIPPED    #單位註解
#      END IF
#      IF g_sma115 = "Y" AND g_sma116 MATCHES '[02]' THEN  #使用多單位/不使用計價單位
#          PRINT COLUMN 97,g_x[44] CLIPPED    #單位註解
#      END IF
#      IF g_sma115 = 'N' THEN
#          PRINT
#      END IF
#      IF g_sma116 MATCHES '[13]' THEN
#          PRINT '---------------- ---- -------------------- --------------- ',     #No.TQC-6B0128 
#                '--------------- --------------- ------------------';
#      ELSE
#          PRINT '---------------- ---- -------------------- --------------- ',     #No.TQC-6B0128 
#                '--------------- ------------------';
#      END IF 
#      IF (g_sma115 = "Y" AND g_sma116 MATCHES '[13]') OR  #使用多單位/使用計價單位
#         (g_sma115 = "N" AND g_sma116 MATCHES '[13]') THEN
#          PRINT COLUMN 111, '--------------------------------------------'
#      END IF
#      IF g_sma115 = "Y" AND g_sma116 MATCHES '[02]' THEN  #使用多單位/不使用計價單位
#          PRINT COLUMN 97, '--------------------------------------------'
#      END IF
#      IF g_sma115 = "N" THEN
#          PRINT
#      END IF
##NO.FUN-710029 end-----
##     PRINT '--------------- -------------------- --------------- ',    #No.TQC-6B0128
##           '--------------- ------------------'
##NO.FUN-710029 mark--
##      PRINT '---------------- ---- -------------------- --------------- ',     #No.TQC-6B0128 
##            '--------------- ------------------'
##NO.FUN-710029 mark--
#
#   ON EVERY ROW
##NO.FUN-710029 start----
#      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                         WHERE ima01=sr.all11
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.all85) RETURNING l_all85
#                LET l_str2 = l_all85 , sr.all83 CLIPPED
#                IF cl_null(sr.all85) OR sr.all85 = 0 THEN
#                    CALL cl_remove_zero(sr.all82) RETURNING l_all82
#                    LET l_str2 = l_all82, sr.all80 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.all82) AND sr.all82 > 0 THEN
#                      CALL cl_remove_zero(sr.all82) RETURNING l_all82
#                      LET l_str2 = l_str2 CLIPPED,',',l_all82, sr.all80 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.all85) AND sr.all85 > 0 THEN
#                    CALL cl_remove_zero(sr.all85) RETURNING l_all85
#                    LET l_str2 = l_all85 , sr.all83 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma116 MATCHES '[13]' THEN 
#            IF sr.pmn07 <> sr.all86 THEN 
#               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
#               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
#            END IF
#      END IF
##NO.FUN-710029 end--------------
#
##TQC-6A0081--begin
#      PRINT COLUMN 1,  sr.all04 CLIPPED,
#            COLUMN 18, sr.all05 CLIPPED USING '####',
##NO.FUN-710029 start---加入多單位/計價單位欄位
#            #COLUMN 23, sr.all11 CLIPPED,   #FUN-710029 mark
#            COLUMN 23, sr.all11 CLIPPED;
#      IF g_sma116 MATCHES '[13]' THEN
#          PRINT COLUMN 44, sr.all86 CLIPPED,
#                COLUMN 60, sr.all87 CLIPPED USING '############.##',
#                COLUMN 75, cl_numfor(sr.all06,15,sr.azi03) CLIPPED,
#                COLUMN 91, cl_numfor(sr.all08,18,sr.azi04) CLIPPED;
#      ELSE
#          PRINT COLUMN 44, cl_numfor(sr.all06,15,sr.azi03) CLIPPED,
#                COLUMN 60, sr.all07 CLIPPED USING '############.##',
#                COLUMN 75, cl_numfor(sr.all08,18,sr.azi04) CLIPPED;
#      END IF
#      IF (g_sma115 = "Y" AND g_sma116 MATCHES '[13]') OR  #使用多單位/使用計價單位
#         (g_sma115 = "N" AND g_sma116 MATCHES '[13]') THEN
#          PRINT COLUMN 111,l_str2 CLIPPED    #單位註解
#      END IF
#      IF g_sma115 = "Y" AND g_sma116 MATCHES '[02]' THEN  #使用多單位/不使用計價單位
#          PRINT COLUMN 97,l_str2 CLIPPED
#      END IF
#      IF g_sma115 = 'N' THEN
#          PRINT
#      END IF
##NO.FUN-710029 end--------------------   
#      PRINT COLUMN 23, sr.pmn041 CLIPPED
##TQC-6A0081--end
#
#   AFTER GROUP OF sr.alc02
#      LET l_amt_1 = GROUP SUM(sr.all08)
#      LET l_tmp = sr.alc52+sr.alc53+sr.alc54+sr.alc56
##NO.FUN-710029 start--
#      IF g_sma116 MATCHES '[13]' THEN
#          PRINT COLUMN 61, g_x[32] CLIPPED,
#                COLUMN 91, cl_numfor(l_amt_1,18,sr.azi04) CLIPPED
#      ELSE 
##NO.FUN-710029 end-----
#          PRINT COLUMN 61, g_x[32] CLIPPED,
#                COLUMN 69, cl_numfor(l_amt_1,18,sr.azi04) CLIPPED
#      END IF    #FUN-710029 
#      SKIP 2 LINE
#
#      #-----MOD-620090---------依本國幣別取位
#      PRINT g_x[22] CLIPPED, sr_1.ala20, cl_numfor(sr.alc24,10,sr.azi04),
#            ' * ', sr_1.ala21 USING '###','% * Ex.RATE ', sr.alc51, ' = ',
#            g_aza17,cl_numfor(sr.alc52,10,g_azi04)
#      PRINT g_x[23] CLIPPED, ' ', cl_numfor(sr.alc53,18,g_azi04)
#      PRINT g_x[25] CLIPPED, ' ', cl_numfor(sr.alc54,18,g_azi04)
#      PRINT g_x[26] CLIPPED, ' ', cl_numfor(sr.alc55,18,g_azi04),
#            COLUMN 53, g_x[27] CLIPPED, ' ',cl_numfor(sr.alc56,18,g_azi04)
#      PRINT g_x[28] CLIPPED, ' ', cl_numfor(sr.alc57,18,g_azi04)
#      #-----END MOD-620090-----
#      SKIP 1 LINE
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
### FUN-550099
#   PAGE TRAILER
#      PRINT g_dash[1,106]   #TQC-6A0081
#      LET l_zx02 = ''
#      SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01 = g_user
##      PRINT g_x[04],g_x[05] CLIPPED,l_zx02
##     PRINT COLUMN 67,'----------'
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4] CLIPPED
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4] CLIPPED
#             PRINT g_memo
#      END IF
### END FUN-550099
#
#
#END REPORT
##Patch....NO.TQC-610035 <001> #
#No.FUN-710086--end

###GENGRE###START
FUNCTION aapg701_grdata()
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
        LET handler = cl_gre_outnam("aapg701")
        IF handler IS NOT NULL THEN
            START REPORT aapg701_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY alc01,alc02"
            DECLARE aapg701_datacur1 CURSOR FROM l_sql
            FOREACH aapg701_datacur1 INTO sr1.*
               OUTPUT TO REPORT aapg701_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg701_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aapg701_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092---------add-------str
    DEFINE l_ala02_pma02    STRING                     
    DEFINE l_ala05_pmc03    STRING                    
    DEFINE l_ala06_pmc03_1  STRING                 
    DEFINE l_ala07_nma02    STRING                  
    DEFINE l_ala20_alc24    STRING                    
    DEFINE l_ala20_alc52    STRING 
    DEFINE l_all08_sum      LIKE   all_file.all08      
    DEFINE l_alc24          STRING 
    DEFINE l_alc52          STRING
    DEFINE l_ala21          STRING
    DEFINE l_alc51          STRING
    DEFINE l_alc24_fmt      STRING
    DEFINE l_alc34_fmt      STRING
    DEFINE l_all06_fmt      STRING
    DEFINE l_all08_fmt      STRING
    DEFINE l_all08_sum_fmt  STRING
    DEFINE l_alc52_fmt      STRING
    DEFINE l_alc53_fmt      STRING
    DEFINE l_alc54_fmt      STRING
    DEFINE l_alc55_fmt      STRING
    DEFINE l_alc56_fmt      STRING
    DEFINE l_alc57_fmt      STRING
    #FUN-B40092---------add-------end
    ORDER EXTERNAL BY sr1.alc01,sr1.alc02    #,sr1.all02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.alc01
            LET l_lineno = 0
            #FUN-B40092---------add-------str
            LET l_alc24_fmt = cl_gr_numfmt('alc_file','alc24',sr1.azi04)
            PRINTX l_alc24_fmt
            LET l_alc34_fmt = cl_gr_numfmt('alc_file','alc34',sr1.azi04)
            PRINTX l_alc34_fmt
            LET l_all06_fmt = cl_gr_numfmt('all_file','all06',sr1.azi03)
            PRINTX l_all06_fmt
            LET l_all08_fmt = cl_gr_numfmt('all_file','all08',sr1.azi04)
            PRINTX l_all08_fmt
            LET l_ala02_pma02 = sr1.ala02,' ',sr1.pma02 
            LET l_ala05_pmc03 = sr1.ala05,' ',sr1.pmc03
            LET l_ala06_pmc03_1 = sr1.ala06,' ',sr1.pmc03_1
            LET l_ala07_nma02 = sr1.ala07,' ',sr1.nma02
            LET l_alc24 = sr1.alc24 USING '--,---,---,---,---,--&.&&' 
            LET l_ala20_alc24 = sr1.ala20,' ',l_alc24
            PRINTX l_ala05_pmc03
            PRINTX l_ala02_pma02
            PRINTX l_ala06_pmc03_1
            PRINTX l_ala07_nma02
            PRINTX l_ala20_alc24
            #FUN-B40092---------add-------end
        BEFORE GROUP OF sr1.alc02
#        BEFORE GROUP OF sr1.all02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.alc01
        AFTER GROUP OF sr1.alc02
            #FUN-B40092---------add-------str
            LET l_alc52_fmt = cl_gr_numfmt('alc_file','alc52',sr1.g_azi04)
            PRINTX l_alc52_fmt
            LET l_alc53_fmt = cl_gr_numfmt('alc_file','alc53',sr1.g_azi04)
            PRINTX l_alc53_fmt
            LET l_alc54_fmt = cl_gr_numfmt('alc_file','alc54',sr1.g_azi04)
            PRINTX l_alc54_fmt
            LET l_alc55_fmt = cl_gr_numfmt('alc_file','alc55',sr1.g_azi04)
            PRINTX l_alc55_fmt
            LET l_alc56_fmt = cl_gr_numfmt('alc_file','alc56',sr1.g_azi04)
            PRINTX l_alc56_fmt
            LET l_alc57_fmt = cl_gr_numfmt('alc_file','alc57',sr1.g_azi04)
            PRINTX l_alc57_fmt
            LET l_alc51 = sr1.alc51 USING '--,---,---,---,---,--&.&&'
            LET l_ala21 = sr1.ala21 USING '--,---,---,---,---,--&.&&'
            LET l_alc52 = sr1.alc52 USING '--,---,---,---,---,--&.&&'
            LET l_ala20_alc52 = sr1.ala20,' ',l_alc24,'*',l_ala21,"% * Ex.RATE " ,' ',l_alc51,' ','=',l_alc52

            LET l_all08_sum =  GROUP SUM(sr1.all08)
            LET l_all08_sum_fmt = cl_gr_numfmt('all_file','all08',sr1.azi04)
            PRINTX l_all08_sum_fmt
            PRINTX l_ala20_alc52
            PRINTX l_all08_sum
            #FUN-B40092---------add-------end
#        AFTER GROUP OF sr1.all02
        ON LAST ROW

END REPORT
###GENGRE###END
