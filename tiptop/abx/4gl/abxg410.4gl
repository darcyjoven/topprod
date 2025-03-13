# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxg410.4gl
# Descriptions...: 放行單列印
# Date & Author..: 97/08/15 By Danny
# Modify.........: 05/02/25 By cate 報表標題標準化
# Modify.........: No.FUN-550033 05/05/19 By wujie 單據編號加大
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/24 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-710080 07/02/08 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-880002 08/08/06 By sherry 報表增加科學園區打印版本
# Modify.........: No.MOD-8C0210 09/02/19 By Pengu 單身資料若有10筆,只會印出7筆
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A80001 10/08/02 By Sarah 將LET tm.wc = "bnb01 ='",tm.wc CLIPPED,"'"這行mark
# Modify.........: No:FUN-B40097 11/06/09 By chenying 憑證類CR轉GR
# Modify.........: No.FUN-B40097 11/08/17 By chenying 程式規範修改
# Modify.........: No:MOD-BC0008 11/12/14 By yangtt GRW套表列印不對齊
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改,MOD-BB0166 追單
# Modify.........: No:MOD-C30336 12/03/10 By chenying 樣式調用修改
# Modify.........: No:FUN-C40026 12/04/10 By xumm GR動態簽核
# Modify.........: No:FUN-C40026 12/07/26 By chenying GR動態簽核還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                               # Print condition RECORD
            wc        LIKE type_file.chr1000,   # Where condition  #No.FUN-680062  VARCHAR(1000)
            type      LIKE type_file.chr1,      #FUN-6A0007
            more      LIKE type_file.chr1       # Input more condition(Y/N)   #No.FUN-680062 VARCHAR(1) 
            ,type1    LIKE type_file.chr1       #No.FUN-880002
           END RECORD,
       g_mount        LIKE type_file.num10,     #No.FUN-680062  INTEGER
       g_chars        LIKE type_file.chr20      #No.FUN-680062  VARCHAR(10)
DEFINE g_i            LIKE type_file.num5       #count/index for any purpose     #No.FUN-680062 smallint
DEFINE i              LIKE type_file.num5                                      #No.FUN-680062 smallint                 
DEFINE l_table        STRING                    #FUN-710080 add
DEFINE g_sql          STRING                    #FUN-710080 add
DEFINE g_str          STRING                    #FUN-710080 add
 
###GENGRE###START
TYPE sr1_t RECORD
    bnb01 LIKE bnb_file.bnb01,
    g_today LIKE type_file.dat,
    bxz101 LIKE bxz_file.bxz101,
    bnb02 LIKE bnb_file.bnb02,
    bnb07 LIKE bnb_file.bnb07,
    bnc021 LIKE bnc_file.bnc02,
    bnc031 LIKE bnc_file.bnc03,
    bnc041 LIKE bnc_file.bnc04,
    bnb141 LIKE bnb_file.bnb14,
    bnc061 LIKE bnc_file.bnc06,
    bnc101 LIKE bnc_file.bnc10,
    ima0211 LIKE ima_file.ima021,
    bnc0111 LIKE bnc_file.bnc011,
    bnc0121 LIKE bnc_file.bnc012,
    bnc022 LIKE bnc_file.bnc02,
    bnc032 LIKE bnc_file.bnc03,
    bnc042 LIKE bnc_file.bnc04,
    bnb142 LIKE bnb_file.bnb14,
    bnc062 LIKE bnc_file.bnc06,
    bnc102 LIKE bnc_file.bnc10,
    ima0212 LIKE ima_file.ima021,
    bnc0112 LIKE bnc_file.bnc011,
    bnc0122 LIKE bnc_file.bnc012,
    bnc023 LIKE bnc_file.bnc02,
    bnc033 LIKE bnc_file.bnc03,
    bnc043 LIKE bnc_file.bnc04,
    bnb143 LIKE bnb_file.bnb14,
    bnc063 LIKE bnc_file.bnc06,
    bnc103 LIKE bnc_file.bnc10,
    ima0213 LIKE ima_file.ima021,
    bnc0113 LIKE bnc_file.bnc011,
    bnc0123 LIKE bnc_file.bnc012,
    bnc024 LIKE bnc_file.bnc02,
    bnc034 LIKE bnc_file.bnc03,
    bnc044 LIKE bnc_file.bnc04,
    bnb144 LIKE bnb_file.bnb14,
    bnc064 LIKE bnc_file.bnc06,
    bnc104 LIKE bnc_file.bnc10,
    ima0214 LIKE ima_file.ima021,
    bnc0114 LIKE bnc_file.bnc011,
    bnc0124 LIKE bnc_file.bnc012,
    bnc025 LIKE bnc_file.bnc02,
    bnc035 LIKE bnc_file.bnc03,
    bnc045 LIKE bnc_file.bnc04,
    bnb145 LIKE bnb_file.bnb14,
    bnc065 LIKE bnc_file.bnc06,
    bnc105 LIKE bnc_file.bnc10,
    ima0215 LIKE ima_file.ima021,
    bnc0115 LIKE bnc_file.bnc011,
    bnc0125 LIKE bnc_file.bnc012,
    bnc026 LIKE bnc_file.bnc02,
    bnc036 LIKE bnc_file.bnc03,
    bnc046 LIKE bnc_file.bnc04,
    bnb146 LIKE bnb_file.bnb14,
    bnc066 LIKE bnc_file.bnc06,
    bnc106 LIKE bnc_file.bnc10,
    ima0216 LIKE ima_file.ima021,
    bnc0116 LIKE bnc_file.bnc011,
    bnc0126 LIKE bnc_file.bnc012,
    bnc027 LIKE bnc_file.bnc02,
    bnc037 LIKE bnc_file.bnc03,
    bnc047 LIKE bnc_file.bnc04,
    bnb147 LIKE bnb_file.bnb14,
    bnc067 LIKE bnc_file.bnc06,
    bnc107 LIKE bnc_file.bnc10,
    ima0217 LIKE ima_file.ima021,
    bnc0117 LIKE bnc_file.bnc011,
    bnc0127 LIKE bnc_file.bnc012,
    ima15 LIKE ima_file.ima15,
    bnb090 LIKE type_file.chr2,
    bnb091 LIKE type_file.chr2,
    bnb092 LIKE type_file.chr2,
    bnb093 LIKE type_file.chr2,
    bnb094 LIKE type_file.chr2,
    bnb095 LIKE type_file.chr2,
    bnb096 LIKE type_file.chr2,
    bnb097 LIKE type_file.chr2,
    bnb098 LIKE type_file.chr2,
    bnb099 LIKE type_file.chr2,
    bnb09a LIKE type_file.chr2,
    bnb09b LIKE type_file.chr2,
    bnb17 LIKE bnb_file.bnb17,
    bnb18 LIKE bnb_file.bnb18         #FUN-C40026 add, #FUN-C40026 del,
#FUN-C40026----add---str---
#   sign_type LIKE type_file.chr1,
#   sign_img  LIKE type_file.blob,
#   sign_show LIKE type_file.chr1,
#   sign_str  LIKE type_file.chr1000
#FUN-C40026----add---end---
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108   #FUN-C10036   mark
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "bnb01.bnb_file.bnb01,",
               "g_today.type_file.dat,",
               "bxz101.bxz_file.bxz101,",
               "bnb02.bnb_file.bnb02,",
               "bnb07.bnb_file.bnb07,",
               "bnc021.bnc_file.bnc02,",
               "bnc031.bnc_file.bnc03,",
               "bnc041.bnc_file.bnc04,",
               "bnb141.bnb_file.bnb14,",
               "bnc061.bnc_file.bnc06,",
               "bnc101.bnc_file.bnc10,",
               "ima0211.ima_file.ima021,",
               "bnc0111.bnc_file.bnc011,",
               "bnc0121.bnc_file.bnc012,",
               "bnc022.bnc_file.bnc02,",
               "bnc032.bnc_file.bnc03,",
               "bnc042.bnc_file.bnc04,",
               "bnb142.bnb_file.bnb14,",
               "bnc062.bnc_file.bnc06,",
               "bnc102.bnc_file.bnc10,",
               "ima0212.ima_file.ima021,",
               "bnc0112.bnc_file.bnc011,",
               "bnc0122.bnc_file.bnc012,",
               "bnc023.bnc_file.bnc02,",
               "bnc033.bnc_file.bnc03,",
               "bnc043.bnc_file.bnc04,",
               "bnb143.bnb_file.bnb14,",
               "bnc063.bnc_file.bnc06,",
               "bnc103.bnc_file.bnc10,",
               "ima0213.ima_file.ima021,",
               "bnc0113.bnc_file.bnc011,",
               "bnc0123.bnc_file.bnc012,",
               "bnc024.bnc_file.bnc02,",
               "bnc034.bnc_file.bnc03,",
               "bnc044.bnc_file.bnc04,",
               "bnb144.bnb_file.bnb14,",
               "bnc064.bnc_file.bnc06,",
               "bnc104.bnc_file.bnc10,",
               "ima0214.ima_file.ima021,",
               "bnc0114.bnc_file.bnc011,",
               "bnc0124.bnc_file.bnc012,",
               "bnc025.bnc_file.bnc02,",
               "bnc035.bnc_file.bnc03,",
               "bnc045.bnc_file.bnc04,",
               "bnb145.bnb_file.bnb14,",
               "bnc065.bnc_file.bnc06,",
               "bnc105.bnc_file.bnc10,",
               "ima0215.ima_file.ima021,",
               "bnc0115.bnc_file.bnc011,",
               "bnc0125.bnc_file.bnc012,",
               "bnc026.bnc_file.bnc02,",
               "bnc036.bnc_file.bnc03,",
               "bnc046.bnc_file.bnc04,",
               "bnb146.bnb_file.bnb14,",
               "bnc066.bnc_file.bnc06,",
               "bnc106.bnc_file.bnc10,",
               "ima0216.ima_file.ima021,",
               "bnc0116.bnc_file.bnc011,",
               "bnc0126.bnc_file.bnc012,",
               "bnc027.bnc_file.bnc02,",
               "bnc037.bnc_file.bnc03,",
               "bnc047.bnc_file.bnc04,",
               "bnb147.bnb_file.bnb14,",
               "bnc067.bnc_file.bnc06,",
               "bnc107.bnc_file.bnc10,",
               "ima0217.ima_file.ima021,",
               "bnc0117.bnc_file.bnc011,",
               "bnc0127.bnc_file.bnc012,",
               "ima15.ima_file.ima15,",
               "bnb090.type_file.chr2,",
               "bnb091.type_file.chr2,",
               "bnb092.type_file.chr2,",
               "bnb093.type_file.chr2,",
               "bnb094.type_file.chr2,",
               "bnb095.type_file.chr2,",
               "bnb096.type_file.chr2,",
               "bnb097.type_file.chr2,",
               "bnb098.type_file.chr2,",
               "bnb099.type_file.chr2,",
               "bnb09a.type_file.chr2,",
               "bnb09b.type_file.chr2,",  #No.FUN-880002
               "bnb17.bnb_file.bnb17,",
               "bnb18.bnb_file.bnb18 "    #FUN-C40026 add 2, #FUN-C40026 del 2,
              ##FUN-C40026----add---str----
              #"sign_type.type_file.chr1,",  #簽核方式
              #"sign_img.type_file.blob,",   #簽核圖檔
              #"sign_show.type_file.chr1,",
              #"sign_str.type_file.chr1000"
              ##FUN-C40026----add---end----
 
   LET l_table = cl_prt_temptable('abxg410',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN
     # CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097   #FUN-C10036   mark
     # CALL cl_gre_drop_temptable(l_table)    #FUN-B40097             #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #MOD-A80001 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"    #No.FUN-880002    #FUN-C40026 add 4?  #FUN-C40026 del 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
     # CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097   #FUN-C10036    mark
     # CALL cl_gre_drop_temptable(l_table)    #FUN-B40097             #FUN-C10036    mark
      EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-710080 add
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   INITIALIZE tm.* TO NULL            # Default condition
#--------------No.TQC-610081 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
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
#--------------No.TQC-610081 end
   
   IF cl_null(tm.wc) THEN
      CALL abxg410_tm(4,17)        # Input print condition
   ELSE
     #LET tm.wc = "bnb01 ='",tm.wc CLIPPED,"'"   #MOD-A80001 mark
      CALL abxg410()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION abxg410_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062  SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 7 LET p_col = 18
   ELSE 
      LET p_row = 5 LET p_col = 12
   END IF
 
   OPEN WINDOW abxg410_w AT p_row,p_col WITH FORM "abx/42f/abxg410"
################################################################################
# START genero shell script ADD
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1'
   LET tm.more = 'N'
   LET tm.type1 = '1'   #No.FUN-880002
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bnb01,bnb02,bnb03,ima1916 #FUN-6A0007
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
         #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxg410_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   LET tm.type = 'N' #FUN-6A0007
   INPUT BY NAME tm.type1,tm.type,tm.more WITHOUT DEFAULTS #FUN-6A0007  #No.FUN-880002 add type1
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxg410_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxg410'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxg410','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('abxg410',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxg410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxg410()
   ERROR ""
END WHILE
   CLOSE WINDOW abxg410_w
END FUNCTION
 
FUNCTION abxg410()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name             #No.FUN-680062  VARCHAR(20)
#          l_time    LIKE type_file.chr8           #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680062  VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680062   VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)
          l_cnt     LIKE type_file.num5,          #FUN-710080 add
          l_cnt1    LIKE type_file.num5,          #No.MOD-8C0210 add
          l_i       LIKE type_file.num5,          #No.MOD-8C0210 add
          l_j       LIKE type_file.num5,          #No.MOD-8C0210 add
          l_k       LIKE type_file.num5,          #No.MOD-8C0210 add
          sr        RECORD
                     bnb01  LIKE bnb_file.bnb01,
                     bnb02  LIKE bnb_file.bnb02,
                     bnb06  LIKE bnb_file.bnb06,
                     bnb07  LIKE bnb_file.bnb07,
                     bnb11  LIKE bnb_file.bnb11,
                     bna06  LIKE bna_file.bna06,
                     ima15  LIKE ima_file.ima15,
                     bnb09  LIKE bnb_file.bnb09,
                     bnb17  LIKE bnb_file.bnb17,
                     bnb18  LIKE bnb_file.bnb18
                    END RECORD,
          #str FUN-710080 add
          l_bnc     DYNAMIC ARRAY OF RECORD
                     bnc02  LIKE bnc_file.bnc02,
                     bnc03  LIKE bnc_file.bnc03,
                     bnc04  LIKE bnc_file.bnc04,
                     ima021 LIKE ima_file.ima021,
                     bnb14  LIKE bnb_file.bnb14,
                     bnc06  LIKE bnc_file.bnc06,
                     bnc10  LIKE bnc_file.bnc10,
                     bnc011 LIKE bnc_file.bnc011,
                     bnc012 LIKE bnc_file.bnc012,
                     ima15  LIKE ima_file.ima15
                    END RECORD,
          #l_bnb09   ARRAY[11] OF LIKE type_file.chr2,  #No.FUN-880002
          l_bnb09   ARRAY[12] OF LIKE type_file.chr2,   #No.FUN-880002
          l_zaa02   LIKE type_file.num5,
          l_zaa08   LIKE type_file.chr1000,
         #l_img_blob      LIKE type_file.blob,  #FUN-C40026 add #FUN-C40026 mark
          l_160     STRING
          #end FUN-710080 add
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
#  LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add   #FUN-C40026 mark
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abxg410'
 
   DECLARE zaa_cur CURSOR FOR
      SELECT zaa02,zaa08 FROM zaa_file
       WHERE zaa01 = 'abxg410'
         AND zaa03 = g_rlang 
       ORDER BY zaa02
   FOREACH zaa_cur INTO l_zaa02,l_zaa08
      IF SQLCA.SQLCODE THEN
         CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
         EXIT PROGRAM
      END IF
      LET g_x[l_zaa02] = l_zaa08
   END FOREACH
   LET l_160 = g_x[160]
   LET l_160 = l_160.trim()
   #end FUN-710080 add
 
{
#FUN-6A0007...............begin
#  LET l_sql = "SELECT bnb01,bnb02,bnb06,bnb07,bnb11,bna06,bnc03,",
##             "       bnc04,bnc06,bnc10,bnc11,bnc12",
#              "       bnc04,bnc06,bnc10",
#              "  FROM bnb_file, bnc_file, bna_file ",
#              " WHERE bnb01 = bnc01 ",
##No.FUN-550033--begin
##             "   AND bna01 = bnb01[1,3] ",
#              "   AND bnb01 like rtrim(bna01) ||'-%' ",
##No.FUN-550033--end
#                 "   AND ",tm.wc CLIPPED
   LET l_sql = "SELECT bnb01,bnb02,bnb06,bnb07,bnb11,bna06,bnc03,",
               "       bnc04,bnc06,bnc10,",
               "       bnc02,ima021,bnc011,bnc012,ima15,",
               "       bnb09,bnb14,bnb17,bnb18,",
               "  ima1916, bxe02, bxe03, bxe04 ", #FUN-6A0007
#              "  FROM bnb_file, bnc_file, bna_file, OUTER ima_file ",
               "  FROM bnb_file, bnc_file, bna_file, ima_file,bxe_file ",
               " WHERE bnb01 = bnc01 ",
               "   AND bnb01 like rtrim(bna01) ||'-%' ",
#              "   AND bnc03 = ima_file.ima01 ",
               "   AND bnc03 = ima01 ",
               "   AND ima1916 = bxe01 ",
               "   AND ",tm.wc CLIPPED
#FUN-6A0007...............end
}
   #str FUN-710080 modify
   IF tm.type = 'Y' THEN   #依保稅群組列印
      LET l_sql = "SELECT bnb01,bnb02,bnb06,bnb07,bnb11,bna06,'',",
                  "       bnb09,bnb17,bnb18 ",
                 #"  FROM bnb_file,bna_file ",
                 #------------MOD-8C0210 modify
                 #"  FROM bnb_file,bna_file,bnc_file,ima_file,bxe_file ",
                  "  FROM bnb_file,bna_file ",
                 #------------MOD-8C0210 end
                  " WHERE bnb01 like rtrim(bna01) ||'-%' ",
                 #------------MOD-8C0210 mark
                 #"   AND bnb01 = bnc01 ",
                 #"   AND bnc03 = ima01 ",
                 #"   AND ima1916 = bxe01 ",
                 #------------MOD-8C0210 end
                  "   AND ",tm.wc CLIPPED
   ELSE
      LET l_sql = "SELECT bnb01,bnb02,bnb06,bnb07,bnb11,bna06,'',",
                  "       bnb09,bnb17,bnb18 ",
                 #"  FROM bnb_file,bna_file ",
                 #------------MOD-8C0210 modify
                 #"  FROM bnb_file,bna_file,bnc_file,ima_file ",
                  "  FROM bnb_file,bna_file ",
                 #------------MOD-8C0210 end
                  " WHERE bnb01 like rtrim(bna01) ||'-%' ",
                 #--------------MOD-8C0210 mark
                 #"   AND bnb01 = bnc01 ",
                 #"   AND bnc03 = ima01 ",
                 #--------------MOD-8C0210 end
                  "   AND ",tm.wc CLIPPED
   END IF
   #end FUN-710080 modify
 
   PREPARE abxg410_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE abxg410_curs1 CURSOR FOR abxg410_prepare1
 
   FOREACH abxg410_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #str FUN-710080 add
      IF tm.type = 'Y' THEN   #依保稅群組列印
         LET l_sql = "SELECT '',ima1916,bxe02,bxe03,SUM(bnb14),SUM(bnc06),SUM(bnc10),",
                     "       '','',ima15 ",
                     "  FROM bnb_file,bnc_file,ima_file,bxe_file ",
                     " WHERE bnb01 = bnc01 ",
                     "   AND bnb01 = '",sr.bnb01,"'",
                     "   AND bnc03 = ima01 ",
                     "   AND ima1916 = bxe01 ",
                     " GROUP BY ima1916,bxe02,bxe03,ima15"
      ELSE
         LET l_sql = "SELECT bnc02,bnc03,bnc04,ima021,bnb14,bnc06,bnc10,",
                     "       bnc011,bnc012,ima15 ",
                     "  FROM bnb_file,bnc_file,ima_file ",
                     " WHERE bnb01 = bnc01 ",
                     "   AND bnb01 = '",sr.bnb01,"' ",
                     "   AND bnc03 = ima01"
      END IF
 
      PREPARE abxg410_prepare2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      END IF
      DECLARE abxg410_curs2 CURSOR FOR abxg410_prepare2
 
      LET l_cnt = 1
      CALL l_bnc.clear()
      FOREACH abxg410_curs2 INTO l_bnc[l_cnt].*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_bnc[l_cnt].bnc02) THEN 
            LET l_bnc[l_cnt].bnc02 = l_cnt 
         END IF
         IF cl_null(l_bnc[l_cnt].bnc10) THEN 
            LET l_bnc[l_cnt].bnc10 = 0 
         END IF
         IF NOT cl_null(l_bnc[l_cnt].ima15) THEN 
            LET sr.ima15=l_bnc[l_cnt].ima15 
         END IF
         LET l_cnt = l_cnt + 1 
      END FOREACH
      LET l_cnt = l_cnt - 1   #No.MOD-8C0210 add
 
      IF cl_null(sr.ima15) THEN LET sr.ima15='N' END IF
 
      #貨品出區原因
      CALL l_bnb09.clear()
      CASE
         WHEN sr.bnb09 MATCHES g_x[169] #*視同出口*
              LET l_bnb09[1] = l_160
         WHEN sr.bnb09 MATCHES g_x[170] #*廠外*工*
              LET l_bnb09[2] = l_160
         WHEN sr.bnb09 MATCHES g_x[171] #*修理*
              LET l_bnb09[3] = l_160
         WHEN sr.bnb09 MATCHES g_x[172] #*補稅內銷*
              LET l_bnb09[4] = l_160
         WHEN sr.bnb09 MATCHES g_x[173] #*受託*工*
              LET l_bnb09[5] = l_160
         WHEN sr.bnb09 MATCHES g_x[174] #*展列*
              LET l_bnb09[6] = l_160
         WHEN sr.bnb09 MATCHES g_x[164] #*原料復運出口*
              LET l_bnb09[7] = l_160
         WHEN sr.bnb09 MATCHES g_x[165] #*檢驗*
              LET l_bnb09[8] = l_160
         WHEN sr.bnb09 MATCHES g_x[166] #*下腳廢料*
              LET l_bnb09[9] = l_160
         WHEN sr.bnb09 MATCHES g_x[167] #*測試*
              LET l_bnb09[10]= l_160
         WHEN sr.bnb09 MATCHES g_x[168] #*其他*
              LET l_bnb09[11]= l_160
         #No.FUN-880002---Begin     
         WHEN sr.bnb09 MATCHES g_x[175] #**
              LET l_bnb09[12]= l_160
         #No.FUN-880002---End     
      END CASE
     #---------------No.MOD-8C0210 add
      LET l_j = 1
      IF l_cnt > 7 THEN 
         LET l_cnt1 = l_cnt MOD 7
         IF l_cnt1 != 0 THEN
            LET l_j = (l_cnt - l_cnt1) / 7 + 1
         ELSE
            LET l_j = l_cnt / 7 
         END IF
      END IF
     #---------------No.MOD-8C0210 end
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
   
   FOR l_i = 1 TO l_j            #No.MOD-8C0210 add
       LET l_k = (l_i - 1) * 7   #No.MOD-8C0210 add
       IF tm.type1 = '1' THEN   #No.FUN-880002 
          EXECUTE insert_prep USING
             sr.bnb01,g_today,g_bxz.bxz101,sr.bnb02,sr.bnb07,
            #------------------No.MOD-8C0210 modify
             l_bnc[l_k+1].bnc02 ,l_bnc[l_k+1].bnc03 ,l_bnc[l_k+1].bnc04 ,
             l_bnc[l_k+1].bnb14 ,l_bnc[l_k+1].bnc06 ,l_bnc[l_k+1].bnc10 ,
             l_bnc[l_k+1].ima021,l_bnc[l_k+1].bnc011,l_bnc[l_k+1].bnc012,
             l_bnc[l_k+2].bnc02 ,l_bnc[l_k+2].bnc03 ,l_bnc[l_k+2].bnc04 ,
             l_bnc[l_k+2].bnb14 ,l_bnc[l_k+2].bnc06 ,l_bnc[l_k+2].bnc10 ,
             l_bnc[l_k+2].ima021,l_bnc[l_k+2].bnc011,l_bnc[l_k+2].bnc012,
             l_bnc[l_k+3].bnc02 ,l_bnc[l_k+3].bnc03 ,l_bnc[l_k+3].bnc04 ,
             l_bnc[l_k+3].bnb14 ,l_bnc[l_k+3].bnc06 ,l_bnc[l_k+3].bnc10 ,
             l_bnc[l_k+3].ima021,l_bnc[l_k+3].bnc011,l_bnc[l_k+3].bnc012,
             l_bnc[l_k+4].bnc02 ,l_bnc[l_k+4].bnc03 ,l_bnc[l_k+4].bnc04 ,
             l_bnc[l_k+4].bnb14 ,l_bnc[l_k+4].bnc06 ,l_bnc[l_k+4].bnc10 ,
             l_bnc[l_k+4].ima021,l_bnc[l_k+4].bnc011,l_bnc[l_k+4].bnc012,
             l_bnc[l_k+5].bnc02 ,l_bnc[l_k+5].bnc03 ,l_bnc[l_k+5].bnc04 ,
             l_bnc[l_k+5].bnb14 ,l_bnc[l_k+5].bnc06 ,l_bnc[l_k+5].bnc10 ,
             l_bnc[l_k+5].ima021,l_bnc[l_k+5].bnc011,l_bnc[l_k+5].bnc012,
             l_bnc[l_k+6].bnc02 ,l_bnc[l_k+6].bnc03 ,l_bnc[l_k+6].bnc04 ,
             l_bnc[l_k+6].bnb14 ,l_bnc[l_k+6].bnc06 ,l_bnc[l_k+6].bnc10 ,
             l_bnc[l_k+6].ima021,l_bnc[l_k+6].bnc011,l_bnc[l_k+6].bnc012,
             l_bnc[l_k+7].bnc02 ,l_bnc[l_k+7].bnc03 ,l_bnc[l_k+7].bnc04 ,
             l_bnc[l_k+7].bnb14 ,l_bnc[l_k+7].bnc06 ,l_bnc[l_k+7].bnc10 ,
             l_bnc[l_k+7].ima021,l_bnc[l_k+7].bnc011,l_bnc[l_k+7].bnc012,
            #------------------No.MOD-8C0210 end
             sr.ima15   ,l_bnb09[1] ,l_bnb09[2],l_bnb09[3],l_bnb09[4],
             l_bnb09[5] ,l_bnb09[6] ,l_bnb09[7],l_bnb09[8],l_bnb09[9],
             l_bnb09[10],l_bnb09[11],l_bnb09[12],sr.bnb17  ,sr.bnb18   #No.FUN-880002 add l_bnb09[12]   #FUN-C40026 add ,  #FUN-C40026 del ,
          #  "",l_img_blob,"N",""                        #FUN-C40026 add #FUN-C40026 mark

       #No.FUN-880002---Begin
       ELSE
          LET sr.bnb17 = ''
          LET sr.bnb18 = ''
          LET l_bnb09[7] = ''
          LET l_bnb09[9] = ''
          EXECUTE insert_prep USING
             sr.bnb01,g_today,g_bxz.bxz101,sr.bnb02,sr.bnb07,
            #------------------No.MOD-8C0210 modify
             l_bnc[l_k+1].bnc02 ,l_bnc[l_k+1].bnc03 ,l_bnc[l_k+1].bnc04 ,
             l_bnc[l_k+1].bnb14 ,l_bnc[l_k+1].bnc06 ,l_bnc[l_k+1].bnc10 ,
             l_bnc[l_k+1].ima021,l_bnc[l_k+1].bnc011,l_bnc[l_k+1].bnc012,
             l_bnc[l_k+2].bnc02 ,l_bnc[l_k+2].bnc03 ,l_bnc[l_k+2].bnc04 ,
             l_bnc[l_k+2].bnb14 ,l_bnc[l_k+2].bnc06 ,l_bnc[l_k+2].bnc10 ,
             l_bnc[l_k+2].ima021,l_bnc[l_k+2].bnc011,l_bnc[l_k+2].bnc012,
             l_bnc[l_k+3].bnc02 ,l_bnc[l_k+3].bnc03 ,l_bnc[l_k+3].bnc04 ,
             l_bnc[l_k+3].bnb14 ,l_bnc[l_k+3].bnc06 ,l_bnc[l_k+3].bnc10 ,
             l_bnc[l_k+3].ima021,l_bnc[l_k+3].bnc011,l_bnc[l_k+3].bnc012,
             l_bnc[l_k+4].bnc02 ,l_bnc[l_k+4].bnc03 ,l_bnc[l_k+4].bnc04 ,
             l_bnc[l_k+4].bnb14 ,l_bnc[l_k+4].bnc06 ,l_bnc[l_k+4].bnc10 ,
             l_bnc[l_k+4].ima021,l_bnc[l_k+4].bnc011,l_bnc[l_k+4].bnc012,
             l_bnc[l_k+5].bnc02 ,l_bnc[l_k+5].bnc03 ,l_bnc[l_k+5].bnc04 ,
             l_bnc[l_k+5].bnb14 ,l_bnc[l_k+5].bnc06 ,l_bnc[l_k+5].bnc10 ,
             l_bnc[l_k+5].ima021,l_bnc[l_k+5].bnc011,l_bnc[l_k+5].bnc012,
             l_bnc[l_k+6].bnc02 ,l_bnc[l_k+6].bnc03 ,l_bnc[l_k+6].bnc04 ,
             l_bnc[l_k+6].bnb14 ,l_bnc[l_k+6].bnc06 ,l_bnc[l_k+6].bnc10 ,
             l_bnc[l_k+6].ima021,l_bnc[l_k+6].bnc011,l_bnc[l_k+6].bnc012,
             l_bnc[l_k+7].bnc02 ,l_bnc[l_k+7].bnc03 ,l_bnc[l_k+7].bnc04 ,
             l_bnc[l_k+7].bnb14 ,l_bnc[l_k+7].bnc06 ,l_bnc[l_k+7].bnc10 ,
             l_bnc[l_k+7].ima021,l_bnc[l_k+7].bnc011,l_bnc[l_k+7].bnc012,
            #------------------No.MOD-8C0210 end
             sr.ima15   ,l_bnb09[1] ,l_bnb09[2],l_bnb09[3],l_bnb09[4],
             l_bnb09[5] ,l_bnb09[6] ,l_bnb09[7],l_bnb09[8],l_bnb09[9],
             l_bnb09[10],l_bnb09[11],l_bnb09[12],sr.bnb17  ,sr.bnb18     #FUN-C40026 add , #FUN-C40026 del ,
            #"",l_img_blob,"N",""                        #FUN-C40026 add  #FUN-C40026 mark 
        END IF    
   END FOR        #No.MOD-8C0210 add 
    #No.FUN-880002---End     
    #------------------------------ CR (3) ------------------------------#
    #end FUN-710080 add
   END FOREACH
#FUN-C40026--mark--str--------- 
#  LET g_cr_table = l_table                 #FUN-C40026 add
#  LET g_cr_apr_key_f = "bnb01"             #FUN-C40026 add
#FUN-C40026--mark--end--------
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF tm.type1 = '1' THEN  #No.FUN-880002
      LET g_str = g_bxz.bxz100 CLIPPED," ",
                  g_bxz.bxz101 CLIPPED," ",
                  g_bxz.bxz102 CLIPPED,";",
                  tm.type
   #No.FUN-880002---Begin
   ELSE 
     LET g_str = g_company
   END IF
   #No.FUN-880002---End
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'bnb01,bnb02,bnb03,ima1916')
           RETURNING tm.wc
###GENGRE###      LET g_str = g_str,";",tm.wc
   END IF
   #No.FUN-880002---Begin
   IF tm.type1 = '1' THEN
     #LET l_name = 'abxg410'       #MOD-C30336
      LET g_template = 'abxg410'   #MOD-C30336
   ELSE 
     #LET l_name = 'abxg410_1'     #MOD-C30336
      LET g_template = 'abxg410_1' #MOD-C30336
   END IF	  
   #CALL cl_prt_cs3('abxg410','abxg410',l_sql,g_str)
###GENGRE###   CALL cl_prt_cs3('abxg410',l_name,l_sql,g_str)
    CALL abxg410_grdata()    ###GENGRE###
   #No.FUN-880002---End
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
#FUN-6A0007...................................mark begin
#REPORT abxg410_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
#          l_len        LIKE type_file.num5,          #No.FUN-680062  smallint
#          l_n          LIKE type_file.num5,          #No.FUN-680062  smallint
#          l_head       LIKE type_file.chr20,         #No.FUN-680062  VARCHAR(10)
#          l_prt        LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
#          l_part       LIKE type_file.chr20,           #No.FUN-680062  VARCHAR(30)
#          sr           RECORD
#                       bnb01  LIKE bnb_file.bnb01,
#                       bnb02  LIKE bnb_file.bnb02,
#                       bnb06  LIKE bnb_file.bnb06,
#                       bnb07  LIKE bnb_file.bnb07,
#                       bnb11  LIKE bnb_file.bnb11,
#                       bna06  LIKE bna_file.bna06,
#                       bnc03  LIKE bnc_file.bnc03,
#                       bnc04  LIKE bnc_file.bnc04,
#                       bnc06  LIKE bnc_file.bnc06,
#                       bnc10  LIKE bnc_file.bnc10
##                      bnc11  LIKE bnc_file.bnc11,
##                      bnc12  LIKE bnc_file.bnc12
#                       END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.bnb01,sr.bnb02
#  FORMAT
#   PAGE HEADER
#         PRINT COLUMN 20,g_x[11] clipped
#         PRINT COLUMN 20,g_x[12] clipped
#         PRINT COLUMN 20,g_x[13] clipped
#         PRINT COLUMN 17,g_x[14] clipped,
#               COLUMN 62,g_x[15] clipped,sr.bnb01
#         PRINT COLUMN 17,g_x[16] ,
#               COLUMN 62,g_x[17] clipped
#         PRINT COLUMN 17,g_x[18],
#               COLUMN 62,g_x[19] clipped,sr.bnb02
#         PRINT g_x[20],g_x[21]
#         PRINT g_x[22],g_x[23]
#         PRINT g_x[24],g_x[25]
# 
#         LET l_n = 0
#         LET l_prt = 'N'
#
#   BEFORE GROUP OF sr.bnb01
#         CASE
#             WHEN sr.bna06 = '1'
#                  LET l_head = '保稅物品'
#             WHEN sr.bna06 = '2'
#                  LET l_head = '免稅物品'
#             WHEN sr.bna06 = '3'
#                  LET l_head = '非保稅物品'
#             OTHERWISE
#                  LET l_head = ' '
#         END CASE
#
#   ON EVERY ROW
#     IF NOT cl_null(sr.bnc03) THEN
#        LET l_part = sr.bnc03
#     ELSE
#        LET l_part = sr.bnc04
#     END IF
#     PRINT g_x[26] clipped,COLUMN 13,g_x[26] clipped,l_part,COLUMN 45,
#           g_x[26] clipped,COLUMN 53,g_x[26] clipped,
#           sr.bnc06 USING '###,##&.&&',COLUMN 65,g_x[26] clipped,
#           cl_numfor(sr.bnc10,10,t_azi04),COLUMN 79,g_x[26] clipped
#        #  sr.bnc10 USING '###,###,##&',COLUMN 79,'│'
#     LET l_n = l_n + 1
#     IF l_n = 20 THEN
#        PRINT g_x[27],g_x[28]
#        PRINT g_x[29] clipped,l_head,COLUMN 79,g_x[26] clipped
#        PRINT g_x[30],g_x[31]
#        PRINT g_x[32],g_x[33]
#        PRINT g_x[34] CLIPPED,30 SPACE,g_x[35]
#        PRINT g_x[36],g_x[37]
#        PRINT g_x[38],g_x[39]
#        PRINT g_x[40],g_x[41]
#        PRINT g_x[42] clipped,sr.bnb06 CLIPPED,' ',sr.bnb07 CLIPPED,
#              COLUMN 59,g_x[43] clipped
#        PRINT g_x[44],g_x[45]
#        PRINT g_x[46] clipped,YEAR(sr.bnb11),COLUMN 24,g_x[47] clipped,MONTH(sr.bnb11),
#              COLUMN 36,g_x[48] clipped,DAY(sr.bnb11),COLUMN 48,g_x[49] clipped
#        PRINT g_x[50],g_x[51]
#        PRINT g_x[52],g_x[53]
#        PRINT g_x[54],g_x[55]
#        PRINT g_x[56],g_x[57]
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,COLUMN 61,g_x[26] clipped,
#              COLUMN 79,g_x[26] clipped
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[58],g_x[59] clipped,
#              COLUMN 46,g_x[60] clipped
#        PRINT g_x[61],g_x[62]
#        PRINT g_x[63],g_x[64]
#        PRINT g_x[65] CLIPPED,20 SPACE,g_x[66]
#        PRINT g_x[67],g_x[68]
#        PRINT g_x[69],g_x[70]
#        PRINT g_x[71],g_x[72]
#        PRINT g_x[73],g_x[74]
#        PRINT g_x[75] CLIPPED,34 SPACE,g_x[76]
#        PRINT g_x[77],g_x[78]
#        PRINT g_x[79],g_x[80]
#        PRINT g_x[81],g_x[82]
#        PRINT g_x[83],g_x[84]
# 
#        LET l_prt = 'Y'
#     END IF
#
#   AFTER GROUP OF sr.bnb01
#     FOR i = l_n + 1 TO 20
#         IF i = 20 THEN
#            PRINT  g_x[26] clipped,COLUMN 13,g_x[26] clipped,
#                   COLUMN 38,g_x[85] clipped,COLUMN 45,g_x[26] clipped,
#                   COLUMN 47, #GROUP SUM(sr.bnc12) USING '##,##&',
#                   COLUMN 53,g_x[26] clipped,
#                   COLUMN 62,g_x[86] clipped,
#                   COLUMN 65,g_x[26] clipped,
#                   COLUMN 68,GROUP SUM(sr.bnc10) USING '###,###,##&',
#                   COLUMN 79,g_x[26] clipped
#         ELSE
#            PRINT  g_x[26] clipped,COLUMN 13,g_x[26] clipped,COLUMN 45,
#                   g_x[26] clipped,COLUMN 53,g_x[26] clipped,
#                   COLUMN 65,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#         END IF
#     END FOR
#     IF l_prt = 'N' THEN
#        PRINT g_x[27],g_x[28]
# 
#        PRINT g_x[29] clipped,l_head,COLUMN 79,g_x[26] clipped
#        PRINT g_x[30],g_x[31]
#        PRINT g_x[32],g_x[33]
#        PRINT g_x[34] CLIPPED,30 SPACE,g_x[35]
#        PRINT g_x[36],g_x[37]
#        PRINT g_x[38],g_x[39]
#        PRINT g_x[40],g_x[41]
#        PRINT g_x[42] clipped,sr.bnb06 CLIPPED,' ',sr.bnb07 CLIPPED,
#              COLUMN 59,g_x[43] clipped
#        PRINT g_x[44],g_x[45]
#        PRINT g_x[46] clipped,YEAR(sr.bnb11),COLUMN 24,g_x[47] clipped,MONTH(sr.bnb11),
#              COLUMN 36,g_x[48] clipped,DAY(sr.bnb11),COLUMN 48,g_x[49] clipped
#        PRINT g_x[50],g_x[51]
#        PRINT g_x[52],g_x[53]
#        PRINT g_x[54],g_x[55]
#        PRINT g_x[56],g_x[57]
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[26] clipped,COLUMN 21,g_x[26] clipped,COLUMN 41,g_x[26] clipped,
#              COLUMN 61,g_x[26] clipped,COLUMN 79,g_x[26] clipped
#        PRINT g_x[58],g_x[59] clipped,
#              COLUMN 46,g_x[60] clipped
#        PRINT g_x[61],g_x[62]
#        PRINT g_x[63],g_x[64]
#        PRINT g_x[65] CLIPPED,20 SPACE,g_x[66]
#        PRINT g_x[67],g_x[68]
#        PRINT g_x[69],g_x[70]
#        PRINT g_x[71],g_x[72]
#        PRINT g_x[73],g_x[74]
#        PRINT g_x[75] CLIPPED,34 SPACE,g_x[76]
#        PRINT g_x[77],g_x[78]
#        PRINT g_x[79],g_x[80]
#        PRINT g_x[81],g_x[82]
#        PRINT g_x[83],g_x[84]
#     END IF
#END REPORT
#FUN-6A0007...................................mark end
 
{
#FUN-6A0007----------------------------------------------------------(S)
REPORT abxg410_rep1(sr1)
   DEFINE l_last_sw    LIKE type_file.chr1,
          l_msg        LIKE type_file.chr1000,
          l_i          LIKE type_file.num5,
          l_cnt        LIKE type_file.num10,
          l_prt1       LIKE type_file.chr1,
          sr1          RECORD
                       bnb01  LIKE bnb_file.bnb01,
                       bnb02  LIKE bnb_file.bnb02,
                       bnb06  LIKE bnb_file.bnb06,
                       bnb07  LIKE bnb_file.bnb07,
                       bnb11  LIKE bnb_file.bnb11,
                       bna06  LIKE bna_file.bna06,
                       bnc03  LIKE bnc_file.bnc03,
                       bnc04  LIKE bnc_file.bnc04,
                       bnc06  LIKE bnc_file.bnc06,
                       bnc10  LIKE bnc_file.bnc10,
                       bnc02  LIKE bnc_file.bnc02,
                       ima021 LIKE ima_file.ima021,
                       bnc011  LIKE bnc_file.bnc011,
                       bnc012  LIKE bnc_file.bnc012,
                       ima15  LIKE ima_file.ima15,
                       bnb09  LIKE bnb_file.bnb09,
                       bnb14  LIKE bnb_file.bnb14,
                       bnb17  LIKE bnb_file.bnb17,
                       bnb18  LIKE bnb_file.bnb18,
                       ima1916  LIKE ima_file.ima1916,
                       bxe02  LIKE bxe_file.bxe02,  #群組品名 
                       bxe03  LIKE bxe_file.bxe03,  #群組規格 
                       bxe04  LIKE bxe_file.bxe04   #群組單位 
                       END RECORD,
          l_str    STRING 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr1.bnb01,sr1.bnb02,sr1.bnc02
  FORMAT
   PAGE HEADER
      LET l_msg = g_bxz.bxz100 CLIPPED," ",
                  g_bxz.bxz101 CLIPPED," ",
                  g_bxz.bxz102 CLIPPED
      PRINT COLUMN (g_len-FGL_WIDTH(l_msg))/2 ,l_msg CLIPPED,
            COLUMN  99, g_x[111] CLIPPED
      PRINT COLUMN  01, g_x[112] CLIPPED
      PRINT COLUMN  01, g_x[113] CLIPPED
      PRINT COLUMN  01, g_x[114] CLIPPED
      PRINT COLUMN  99, g_x[115] CLIPPED, g_bxz.bxz101,
            COLUMN 111, g_x[115] CLIPPED
      PRINT COLUMN  01, g_x[116] CLIPPED
      PRINT ''
      PRINT COLUMN  90, g_x[117] CLIPPED, g_today USING 'yyyy/mm/dd'
      PRINT COLUMN  90, g_x[118] CLIPPED, sr1.bnb01
      PRINT COLUMN  01, g_x[119] CLIPPED
      PRINTX name=H1 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95],g_x[96]
      PRINTX name=H2 g_x[97],g_x[98],g_x[99],g_x[100],g_x[101],g_x[102]
      PRINT g_dash1
      LET l_i = 0
      LET l_prt1 = 'N'
 
   BEFORE GROUP OF sr1.bnb01
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM bnc_file
       WHERE bnc01 = sr1.bnb01
      IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      LET l_msg = g_x[120] CLIPPED, "  ", sr1.bnc02 USING '<<<<'
      PRINTX name=D1
             COLUMN g_c[91], l_msg CLIPPED,
             COLUMN g_c[92], sr1.bnc03,
             COLUMN g_c[93], sr1.bnc04,
             COLUMN g_c[94], sr1.bnb14 USING '####&.&&&',      #FUN-6A0007->請勿改成cl_numfor,避免超出報表寬度
             COLUMN g_c[95], sr1.bnc06 USING '#########&.&&&', #FUN-6A0007->請勿改成cl_numfor,避免超出報表寬度
             COLUMN g_c[96], sr1.bnc10 USING '#########&.&&',  #FUN-6A0007->請勿改成cl_numfor,避免超出報表寬度
                             g_x[162] CLIPPED
      LET l_msg = ''
      IF NOT cl_null(sr1.bnc011) THEN
         LET l_msg = sr1.bnc011
         IF NOT cl_null(sr1.bnc012) THEN
            LET l_str=sr1.bnc012
            LET l_str=l_str.trim()
            LET l_msg = l_msg CLIPPED, "_", l_str
         END IF
      END IF
      PRINTX name=D2
             COLUMN g_c[97], g_x[120] CLIPPED,
             COLUMN g_c[98], sr1.ima021 CLIPPED,
             COLUMN g_c[99], '',
             COLUMN g_c[100],'',
             COLUMN g_c[101],l_msg CLIPPED,
             COLUMN g_c[102],g_x[163] CLIPPED
      LET l_i = l_i + 1
      IF l_i = 11 THEN
         CALL abxg410_data(sr1.*)
         IF l_cnt > l_i THEN
            LET l_prt1 = 'N'
            SKIP TO TOP OF PAGE
         ELSE
            LET l_prt1 = 'Y'
         END IF
      END IF
 
   AFTER GROUP OF sr1.bnb01
      FOR i = l_i + 1 TO 11
         PRINTX name=S1
                COLUMN g_c[91], g_x[120] CLIPPED,
                COLUMN g_c[92], '',
                COLUMN g_c[93], '',
                COLUMN g_c[94], '',
                COLUMN g_c[95], '',
                COLUMN g_c[96], g_x[163] CLIPPED
         PRINTX name=D2
                COLUMN g_c[97], g_x[120] CLIPPED,
                COLUMN g_c[98], '',
                COLUMN g_c[99], '',
                COLUMN g_c[100],'',
                COLUMN g_c[101],'',
                COLUMN g_c[102],g_x[163] CLIPPED
      END FOR
      IF l_prt1 = 'N' THEN
         CALL abxg410_data(sr1.*)
      END IF
 
END REPORT
 
#-->依群組列印 #FUN-6A0007
REPORT abxg410_rep2(sr1)
   DEFINE l_last_sw    LIKE type_file.chr1,
          l_msg        LIKE type_file.chr1000,
          l_i          LIKE type_file.num5,
          l_cnt        LIKE type_file.num10,
          l_prt1       LIKE type_file.chr1,
          l_seq        LIKE bnc_file.bnc02,  
          l_bnb14      LIKE bnb_file.bnb14,  
          l_bnc06      LIKE bnc_file.bnc06,
          l_bnc10      LIKE bnc_file.bnc10,
          sr1          RECORD
                       bnb01  LIKE bnb_file.bnb01,
                       bnb02  LIKE bnb_file.bnb02,
                       bnb06  LIKE bnb_file.bnb06,
                       bnb07  LIKE bnb_file.bnb07,
                       bnb11  LIKE bnb_file.bnb11,
                       bna06  LIKE bna_file.bna06,
                       bnc03  LIKE bnc_file.bnc03,
                       bnc04  LIKE bnc_file.bnc04,
                       bnc06  LIKE bnc_file.bnc06,
                       bnc10  LIKE bnc_file.bnc10,
                       bnc02  LIKE bnc_file.bnc02,
                       ima021 LIKE ima_file.ima021,
                       bnc011  LIKE bnc_file.bnc011,
                       bnc012  LIKE bnc_file.bnc012,
                       ima15  LIKE ima_file.ima15,
                       bnb09  LIKE bnb_file.bnb09,
                       bnb14  LIKE bnb_file.bnb14,
                       bnb17  LIKE bnb_file.bnb17,
                       bnb18  LIKE bnb_file.bnb18,
                       ima1916  LIKE ima_file.ima1916,
                       bxe02  LIKE bxe_file.bxe02,  #群組品名 
                       bxe03  LIKE bxe_file.bxe03,  #群組規格 
                       bxe04  LIKE bxe_file.bxe04   #群組單位 
                       END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
# ORDER BY sr1.bnb01,sr1.bnb02,sr1.bnc02
  ORDER BY sr1.bnb01,sr1.ima1916      #FUN-6A0007
  FORMAT
   PAGE HEADER
      LET l_msg = g_bxz.bxz100 CLIPPED," ",
                  g_bxz.bxz101 CLIPPED," ",
                  g_bxz.bxz102 CLIPPED
      PRINT COLUMN (g_len-FGL_WIDTH(l_msg))/2 ,l_msg CLIPPED,
            COLUMN  99, g_x[111] CLIPPED
      PRINT COLUMN  01, g_x[112] CLIPPED
      PRINT COLUMN  01, g_x[113] CLIPPED
      PRINT COLUMN  01, g_x[114] CLIPPED
      PRINT COLUMN  99, g_x[115] CLIPPED, g_bxz.bxz101,
            COLUMN 111, g_x[115] CLIPPED
      PRINT COLUMN  01, g_x[116] CLIPPED
      PRINT ''
      PRINT COLUMN  90, g_x[117] CLIPPED, g_today USING 'yyyy/mm/dd'
      PRINT COLUMN  90, g_x[118] CLIPPED, sr1.bnb01
      PRINT COLUMN  01, g_x[119] CLIPPED
      PRINTX name=H1 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95],g_x[96]
      PRINTX name=H2 g_x[97],g_x[98],g_x[99],g_x[100],g_x[101],g_x[102]
      PRINT g_dash1
      LET l_i = 0
      LET l_prt1 = 'N'
 
   BEFORE GROUP OF sr1.bnb01   #單號
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM bnc_file
       WHERE bnc01 = sr1.bnb01
      IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
      LET l_seq = 0   #FUN-6A0007
      SKIP TO TOP OF PAGE
 
#  ON EVERY ROW   #FUN-6A0007
   AFTER GROUP OF sr1.ima1916
 
      #-->做替換動作 #FUN-6A0007
        LET l_seq = l_seq + 1
        LET sr1.bnc02 = l_seq                  #重新給行序
        LET sr1.bnc03 = sr1.ima1916          #料號   
        LET sr1.bnc04 = sr1.bxe02          #品名
        LET sr1.ima021= sr1.bxe03          #規格
        LET l_bnb14   = GROUP SUM(sr1.bnb14)   #件數
        LET l_bnc06   = GROUP SUM(sr1.bnc06)   #數量
        LET l_bnc10   = GROUP SUM(sr1.bnc10)   #金額
 
      #FUN-6A0007
 
      LET l_msg = g_x[120] CLIPPED, "  ", sr1.bnc02 USING '<<<<'
      PRINTX name=D1
             COLUMN g_c[91], l_msg CLIPPED,
             COLUMN g_c[92], sr1.bnc03,  #料號 
             COLUMN g_c[93], sr1.bnc04,  #品名
          #  COLUMN g_c[94], sr1.bnb14 USING '####&.&&&',
          #  COLUMN g_c[95], sr1.bnc06 USING '#########&.&&&',
          #  COLUMN g_c[96], sr1.bnc10 USING '#########&.&&',
             COLUMN g_c[94], l_bnb14 USING '####&.&&&',         #FUN-6A0007->不使用cl_numfor,避免超出報表寬度
             COLUMN g_c[95], l_bnc06 USING '#########&.&&&',    #FUN-6A0007->不使用cl_numfor,避免超出報表寬度
             COLUMN g_c[96], l_bnc10 USING '#########&.&&',     #FUN-6A0007->不使用cl_numfor,避免超出報表寬度
                             g_x[162] CLIPPED
 
#FUN-6A0007 規格確定不用印單號資料
#     LET l_msg = ''
#     IF NOT cl_null(sr1.bnc011) THEN  
#        LET l_msg = sr1.bnc011
#        IF NOT cl_null(sr1.bnc012) THEN
#           LET l_msg = l_msg CLIPPED, "_", sr1.bnc012
#        END IF
#     END IF
      PRINTX name=D2
             COLUMN g_c[97], g_x[120] CLIPPED,
             COLUMN g_c[98], sr1.ima021,
             COLUMN g_c[99], '',
             COLUMN g_c[100],'',
#            COLUMN g_c[101],l_msg CLIPPED,
             COLUMN g_c[102],g_x[163] CLIPPED
      LET l_i = l_i + 1
      IF l_i = 11 THEN
         CALL abxg410_data(sr1.*)
         IF l_cnt > l_i THEN
            LET l_prt1 = 'N'
            SKIP TO TOP OF PAGE
         ELSE
            LET l_prt1 = 'Y'
         END IF
      END IF
 
   AFTER GROUP OF sr1.bnb01
      FOR i = l_i + 1 TO 11
         PRINTX name=S1
                COLUMN g_c[91], g_x[120] CLIPPED,
                COLUMN g_c[92], '',
                COLUMN g_c[93], '',
                COLUMN g_c[94], '',
                COLUMN g_c[95], '',
                COLUMN g_c[96], g_x[163] CLIPPED
         PRINTX name=D2
                COLUMN g_c[97], g_x[120] CLIPPED,
                COLUMN g_c[98], '',
                COLUMN g_c[99], '',
                COLUMN g_c[100],'',
                COLUMN g_c[101],'',
                COLUMN g_c[102],g_x[163] CLIPPED
      END FOR
      IF l_prt1 = 'N' THEN
         CALL abxg410_data(sr1.*)
      END IF
 
END REPORT
 
FUNCTION abxg410_data(sr2)
   DEFINE 
          l_msg        LIKE type_file.chr1000,
          sr2          RECORD
                       bnb01  LIKE bnb_file.bnb01,
                       bnb02  LIKE bnb_file.bnb02,
                       bnb06  LIKE bnb_file.bnb06,
                       bnb07  LIKE bnb_file.bnb07,
                       bnb11  LIKE bnb_file.bnb11,
                       bna06  LIKE bna_file.bna06,
                       bnc03  LIKE bnc_file.bnc03,
                       bnc04  LIKE bnc_file.bnc04,
                       bnc06  LIKE bnc_file.bnc06,
                       bnc10  LIKE bnc_file.bnc10,
                       bnc02  LIKE bnc_file.bnc02,
                       ima021 LIKE ima_file.ima021,
                       bnc011  LIKE bnc_file.bnc011,
                       bnc012  LIKE bnc_file.bnc012,
                       ima15  LIKE ima_file.ima15,
                       bnb09  LIKE bnb_file.bnb09,
                       bnb14  LIKE bnb_file.bnb14,
                       bnb17  LIKE bnb_file.bnb17,
                       bnb18  LIKE bnb_file.bnb18,
                   ima1916  LIKE ima_file.ima1916,
                   bxe02  LIKE bxe_file.bxe02,  #群組品名 
                   bxe03  LIKE bxe_file.bxe03,  #群組規格 
                   bxe04  LIKE bxe_file.bxe04   #群組單位 
                       END RECORD
 
      PRINT COLUMN  01, g_x[119] CLIPPED
      PRINT COLUMN  01, g_x[121] CLIPPED
      PRINT COLUMN  01, g_x[122] CLIPPED
      PRINT COLUMN  01, g_x[123] CLIPPED
      PRINT COLUMN  01, g_x[124] CLIPPED
      PRINT COLUMN  01, g_x[125] CLIPPED
      IF sr2.ima15 = 'Y' THEN  #Y:保稅 N:非保稅
         LET l_msg = g_x[126] CLIPPED, g_x[128] CLIPPED, g_x[129] CLIPPED,
                     "               ",g_x[127] CLIPPED, g_x[130] CLIPPED
      ELSE
         LET l_msg = g_x[126] CLIPPED, g_x[127] CLIPPED, g_x[129] CLIPPED,
                     "               ",g_x[128] CLIPPED, g_x[130] CLIPPED
      END IF
      PRINT COLUMN  01, l_msg CLIPPED,
            COLUMN 124, g_x[120] CLIPPED
      PRINT COLUMN  01, g_x[119] CLIPPED
      CASE
         WHEN sr2.bnb09 MATCHES g_x[169] #*視同出口*
              PRINT COLUMN  01, g_x[131] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  20, g_x[132] CLIPPED,
                    COLUMN  44, g_x[133] CLIPPED,
                    COLUMN  62, g_x[134] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[170] #*廠外*工*
              PRINT COLUMN  01, g_x[131] CLIPPED,
                    COLUMN  20, g_x[132] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  44, g_x[133] CLIPPED,
                    COLUMN  62, g_x[134] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[171] #*修理*
              PRINT COLUMN  01, g_x[131] CLIPPED,
                    COLUMN  20, g_x[132] CLIPPED,
                    COLUMN  44, g_x[133] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  62, g_x[134] CLIPPED
         OTHERWISE
              PRINT COLUMN  01, g_x[131] CLIPPED,
                    COLUMN  20, g_x[132] CLIPPED,
                    COLUMN  44, g_x[133] CLIPPED,
                    COLUMN  62, g_x[134] CLIPPED
      END CASE
      PRINT COLUMN  01, g_x[135] CLIPPED
      CASE
         WHEN sr2.bnb09 MATCHES g_x[172] #*補稅內銷*
              PRINT COLUMN  01, g_x[136] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  20, g_x[137] CLIPPED,
                    COLUMN  44, g_x[138] CLIPPED,
                    COLUMN  62, g_x[139] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[173] #*受託*工*
              PRINT COLUMN  01, g_x[136] CLIPPED,
                    COLUMN  20, g_x[137] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  44, g_x[138] CLIPPED,
                    COLUMN  62, g_x[139] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[174] #*展列*
              PRINT COLUMN  01, g_x[136] CLIPPED,
                    COLUMN  20, g_x[137] CLIPPED,
                    COLUMN  44, g_x[138] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  62, g_x[139] CLIPPED
         OTHERWISE
              PRINT COLUMN  01, g_x[136] CLIPPED,
                    COLUMN  20, g_x[137] CLIPPED,
                    COLUMN  44, g_x[138] CLIPPED,
                    COLUMN  62, g_x[139] CLIPPED
      END CASE
      PRINT COLUMN  01, g_x[135] CLIPPED
      CASE
         WHEN sr2.bnb09 MATCHES g_x[164] #*原料復運出口*
              PRINT COLUMN  01, g_x[136] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  20, g_x[140] CLIPPED,
                    COLUMN  44, g_x[141] CLIPPED,
                    COLUMN  62, g_x[142] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[165] #*檢驗*
              PRINT COLUMN  01, g_x[136] CLIPPED,
                    COLUMN  20, g_x[140] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  44, g_x[141] CLIPPED,
                    COLUMN  62, g_x[142] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[166] #*下腳廢料*
              PRINT COLUMN  01, g_x[136] CLIPPED,
                    COLUMN  20, g_x[140] CLIPPED,
                    COLUMN  44, g_x[141] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  62, g_x[142] CLIPPED
         OTHERWISE
              PRINT COLUMN  01, g_x[136] CLIPPED,
                    COLUMN  20, g_x[140] CLIPPED,
                    COLUMN  44, g_x[141] CLIPPED,
                    COLUMN  62, g_x[142] CLIPPED
      END CASE
      PRINT COLUMN  01, g_x[135] CLIPPED
      CASE
         WHEN sr2.bnb09 MATCHES g_x[167] #*測試*
              PRINT COLUMN  01, g_x[161] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  20, g_x[143] CLIPPED,
                    COLUMN  44, g_x[144] CLIPPED
         WHEN sr2.bnb09 MATCHES g_x[168] #*其他*
              PRINT COLUMN  01, g_x[161] CLIPPED,
                    COLUMN  20, g_x[143] CLIPPED, g_x[160] CLIPPED,
                    COLUMN  44, g_x[144] CLIPPED
         OTHERWISE
              PRINT COLUMN  01, g_x[161] CLIPPED,
                    COLUMN  20, g_x[143] CLIPPED,
                    COLUMN  44, g_x[144] CLIPPED
      END CASE
      PRINT COLUMN  01, g_x[119] CLIPPED
      PRINT COLUMN  01, g_x[145] CLIPPED, sr2.bnb18 CLIPPED,
            COLUMN  59, g_x[146] CLIPPED, sr2.bnb07 CLIPPED,
            COLUMN 124, g_x[120] CLIPPED
      PRINT COLUMN  01, g_x[149] CLIPPED
      PRINT COLUMN  01, g_x[147] CLIPPED,
            COLUMN  59, g_x[148] CLIPPED, sr2.bnb17 CLIPPED,
            COLUMN 124, g_x[120] CLIPPED
      PRINT COLUMN  01, g_x[149] CLIPPED
      PRINT COLUMN  01, g_x[150] CLIPPED, YEAR(sr2.bnb02)-1911 USING '<<<<',
                        g_x[151] CLIPPED, MONTH(sr2.bnb02) USING '<<',
                        g_x[152] CLIPPED, DAY(sr2.bnb02) USING '<<',
                        g_x[153] CLIPPED,
            COLUMN 124, g_x[120] CLIPPED
      PRINT COLUMN  01, g_x[119] CLIPPED
      PRINT COLUMN  01, g_x[154] CLIPPED
      PRINT COLUMN  01, g_x[155] CLIPPED
      PRINT COLUMN  01, g_x[156] CLIPPED
      PRINT COLUMN  01, g_x[157] CLIPPED
      PRINT COLUMN  01, g_x[158] CLIPPED
      PRINT COLUMN  01, g_x[159] CLIPPED
END FUNCTION
#FUN-6A0007----------------------------------------------------------(E)
#Patch....NO.TQC-610035 <001,002> #
}

###GENGRE###START
FUNCTION abxg410_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

#FUN-C40026---mark--str---   
#   LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
#   CALL cl_gre_init_apr()           #FUN-C40026 add
#FUN-C40026---mark--end---   
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("abxg410")
        IF handler IS NOT NULL THEN
            START REPORT abxg410_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY bnb01" 
            DECLARE abxg410_datacur1 CURSOR FROM l_sql
            FOREACH abxg410_datacur1 INTO sr1.*
                OUTPUT TO REPORT abxg410_rep(sr1.*)
            END FOREACH
            FINISH REPORT abxg410_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT abxg410_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40097-----add-----str-------
    DEFINE l_dd  STRING     
    DEFINE l_mm  STRING     
    DEFINE l_yy  STRING     
    DEFINE l_bnc0121  STRING 
    DEFINE l_bnc0122  STRING 
    DEFINE l_bnc0123  STRING 
    DEFINE l_bnc0124  STRING 
    DEFINE l_bnc0125  STRING 
    DEFINE l_bnc0126  STRING 
    DEFINE l_bnc0127  STRING
    DEFINE l_bnc0111_0121  STRING 
    DEFINE l_bnc0112_0122  STRING 
    DEFINE l_bnc0113_0123  STRING 
    DEFINE l_bnc0114_0124  STRING 
    DEFINE l_bnc0115_0125  STRING 
    DEFINE l_bnc0116_0126  STRING 
    DEFINE l_bnc0117_0127  STRING 
    #FUN-B40097-----add-----end-------
    #MOD-BC0008-----add-----str-------
    DEFINE l_bnc101  LIKE bnc_file.bnc10
    DEFINE l_bnc102  LIKE bnc_file.bnc10
    DEFINE l_bnc103  LIKE bnc_file.bnc10
    DEFINE l_bnc104  LIKE bnc_file.bnc10
    DEFINE l_bnc105  LIKE bnc_file.bnc10
    DEFINE l_bnc106  LIKE bnc_file.bnc10
    DEFINE l_bnc107  LIKE bnc_file.bnc10
    DEFINE l_sum     LIKE bnc_file.bnc10
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_cnt_bnb01    LIKE type_file.num5
    DEFINE l_end     LIKE type_file.chr1
    DEFINE l_sql     STRING
    #MOD-BC0008-----add-----end-------
    
    ORDER EXTERNAL BY sr1.bnb01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            LET l_cnt_bnb01 = 0  #MOD-BC0008
              
        BEFORE GROUP OF sr1.bnb01
            LET l_lineno = 0
            #MOD-BC0008---add---str--------
            LET l_cnt_bnb01 = l_cnt_bnb01 + 1
            LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE bnb01 = '",sr1.bnb01,"'"
            DECLARE abxg410_cur1 CURSOR FROM l_sql
            FOREACH abxg410_cur1 INTO l_cnt END FOREACH
            IF l_cnt_bnb01 = l_cnt THEN
               LET l_end = 'Y'
               LET l_cnt_bnb01 = 0
            ELSE
               LET l_end = 'N'
            END IF
            PRINTX l_end
            #MOD-BC0008---add---end--------

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #MOD-BC0008------add--str----
            IF cl_null(sr1.bnc101) THEN
               LET l_bnc101 = 0
            ELSE
               LET l_bnc101 = sr1.bnc101
            END IF
            PRINTX l_bnc101

            IF cl_null(sr1.bnc102) THEN
               LET l_bnc102 = 0
            ELSE
               LET l_bnc102 = sr1.bnc102
            END IF
            PRINTX l_bnc102

            IF cl_null(sr1.bnc103) THEN
               LET l_bnc103 = 0
            ELSE
               LET l_bnc103 = sr1.bnc103
            END IF
            PRINTX l_bnc103

            IF cl_null(sr1.bnc104) THEN
               LET l_bnc104 = 0
            ELSE
               LET l_bnc104 = sr1.bnc104
            END IF
            PRINTX l_bnc104

            IF cl_null(sr1.bnc105) THEN
               LET l_bnc105 = 0
            ELSE
               LET l_bnc105 = sr1.bnc105
            END IF
            PRINTX l_bnc105

            IF cl_null(sr1.bnc106) THEN
               LET l_bnc106 = 0
            ELSE
               LET l_bnc106 = sr1.bnc106
            END IF
            PRINTX l_bnc106

            IF cl_null(sr1.bnc107) THEN
               LET l_bnc107 = 0
            ELSE
               LET l_bnc107 = sr1.bnc107
            END IF
            PRINTX l_bnc107

            LET l_sum = l_bnc101 + l_bnc102 + l_bnc103 + l_bnc104 + l_bnc105 + l_bnc106 + l_bnc107
            PRINTX l_sum
            #MOD-BC0008------add--end----

            #FUN-B40097---add----str-----------------------
            LET l_bnc0121 = sr1.bnc0121 USING '---,--&' 
            LET l_bnc0122 = sr1.bnc0122 USING '---,--&' 
            LET l_bnc0123 = sr1.bnc0123 USING '---,--&' 
            LET l_bnc0124 = sr1.bnc0124 USING '---,--&' 
            LET l_bnc0125 = sr1.bnc0125 USING '---,--&' 
            LET l_bnc0126 = sr1.bnc0126 USING '---,--&' 
            LET l_bnc0127 = sr1.bnc0127 USING '---,--&' 
            PRINTX l_bnc0121   
            PRINTX l_bnc0122   
            PRINTX l_bnc0123   
            PRINTX l_bnc0124   
            PRINTX l_bnc0125   
            PRINTX l_bnc0126   
            PRINTX l_bnc0127   

            IF NOT cl_null(sr1.bnc0111) AND NOT cl_null(l_bnc0121) THEN 
               LET l_bnc0111_0121 = sr1.bnc0111,'-',l_bnc0121
            ELSE
               IF NOT cl_null(sr1.bnc0111) AND cl_null(l_bnc0121) THEN
                  LET l_bnc0111_0121 = sr1.bnc0111
               END IF
               IF cl_null(sr1.bnc0111) AND NOT cl_null(l_bnc0121) THEN 
                  LET l_bnc0111_0121 = l_bnc0121
               END IF
            END IF    
           
            IF NOT cl_null(sr1.bnc0112) AND NOT cl_null(l_bnc0122) THEN 
               LET l_bnc0112_0122 = sr1.bnc0112,'-',l_bnc0122
            ELSE
               IF NOT cl_null(sr1.bnc0112) AND cl_null(l_bnc0122) THEN
                  LET l_bnc0112_0122 = sr1.bnc0112
               END IF
               IF cl_null(sr1.bnc0112) AND NOT cl_null(l_bnc0122) THEN 
                  LET l_bnc0112_0122 = l_bnc0122
               END IF
            END IF    

            IF NOT cl_null(sr1.bnc0113) AND NOT cl_null(l_bnc0123) THEN 
               LET l_bnc0113_0123 = sr1.bnc0113,'-',l_bnc0123
            ELSE
               IF NOT cl_null(sr1.bnc0113) AND cl_null(l_bnc0123) THEN
                  LET l_bnc0113_0123 = sr1.bnc0113
               END IF
               IF cl_null(sr1.bnc0113) AND NOT cl_null(l_bnc0123) THEN 
                  LET l_bnc0113_0123 = l_bnc0123
               END IF
            END IF    

            IF NOT cl_null(sr1.bnc0114) AND NOT cl_null(l_bnc0124) THEN 
               LET l_bnc0114_0124 = sr1.bnc0114,'-',l_bnc0124
            ELSE
               IF NOT cl_null(sr1.bnc0114) AND cl_null(l_bnc0124) THEN
                  LET l_bnc0114_0124 = sr1.bnc0114
               END IF
               IF cl_null(sr1.bnc0114) AND NOT cl_null(l_bnc0124) THEN 
                  LET l_bnc0114_0124 = l_bnc0124
               END IF
            END IF  
  
            IF NOT cl_null(sr1.bnc0117) AND NOT cl_null(l_bnc0127) THEN 
               LET l_bnc0117_0127 = sr1.bnc0117,'-',l_bnc0127
            ELSE
               IF NOT cl_null(sr1.bnc0117) AND cl_null(l_bnc0127) THEN
                  LET l_bnc0117_0127 = sr1.bnc0117
               END IF
               IF cl_null(sr1.bnc0117) AND NOT cl_null(l_bnc0127) THEN 
                  LET l_bnc0117_0127 = l_bnc0127 
               END IF
            END IF    

            IF NOT cl_null(sr1.bnc0115) AND NOT cl_null(l_bnc0125) THEN 
               LET l_bnc0115_0125 = sr1.bnc0115,'-',l_bnc0125
            ELSE
               IF NOT cl_null(sr1.bnc0115) AND cl_null(l_bnc0125) THEN
                  LET l_bnc0115_0125 = sr1.bnc0115
               END IF
               IF cl_null(sr1.bnc0115) AND NOT cl_null(l_bnc0125) THEN 
                  LET l_bnc0115_0125 = l_bnc0125
               END IF
            END IF   
 
            IF NOT cl_null(sr1.bnc0116) AND NOT cl_null(l_bnc0126) THEN 
               LET l_bnc0116_0126 = sr1.bnc0116,'-',l_bnc0126
            ELSE
               IF NOT cl_null(sr1.bnc0116) AND cl_null(l_bnc0126) THEN
                  LET l_bnc0116_0126 = sr1.bnc0116
               END IF
               IF cl_null(sr1.bnc0116) AND NOT cl_null(l_bnc0126) THEN 
                  LET l_bnc0116_0126 = l_bnc0126
               END IF
            END IF    

            PRINTX l_bnc0111_0121
            PRINTX l_bnc0112_0122
            PRINTX l_bnc0113_0123
            PRINTX l_bnc0114_0124
            PRINTX l_bnc0115_0125
            PRINTX l_bnc0116_0126
            PRINTX l_bnc0117_0127

            LET l_dd = DAY(sr1.bnb02) USING '&&'
            LET l_mm = MONTH(sr1.bnb02) USING '&&'
            LET l_yy  = YEAR(sr1.bnb02)-1911 USING '###' 
            PRINTX l_dd 
            PRINTX l_mm 
            PRINTX l_yy 
            #FUN-B40097-----add-------end----------- 
            PRINTX sr1.*
            PRINTX sr1.g_today USING 'yy/mm/dd'    #FUN-C10036 add 追單(MOD-BB0166)

        AFTER GROUP OF sr1.bnb01

        
        ON LAST ROW

END REPORT
###GENGRE###END
