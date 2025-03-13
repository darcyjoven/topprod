# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aapg220.4gl
# Descriptions...: 退貨折讓証明單
# Input parameter:
# Return code....:
# Date & Author..: 93/11/30 By Fiona
# Modify.........: No.FUN-540057 05/05/09 By wujie 發票號碼調整
# Modify.........: No.FUN-550099 05/05/26 By echo 新增報表備註
# Modify.........: No.TQC-630280 06/03/30 By Smapmin 不需串到rvv_file,rvu_file
# Modify.........: No.FUN-640124 06/04/13 By Smapmin 修改接收的外部參數
# Modify.........: No.MOD-650094 06/05/23 By Smapmin 修改列印條件
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-710086 07/02/07 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: No.TQC-770056 07/07/12 By chenl  增加打印條件
# Modify.........: No.MOD-790018 07/09/11 By Smapmin 發票資料改抓apk_file
# Modify.........: No.MOD-7A0157 07/10/26 By Smapmin 修改SQL語法
# Modify.........: No.MOD-840684 08/05/06 By Smapmin 發票地址不可用中括號來截取字串內容
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
# Modify.........: No.MOD-890212 08/09/23 By Sarah 寫入Temptable的變數有NULL值,造成資料沒寫進去
# Modify.........: No.FUN-940041 09/05/05 By TSD.Wind 在CR報表列印簽核欄(別張單已將此程式過單,要取消此功能)
# Modify.........: No.MOD-960258 09/06/24 By mike 由於aapg220的稅額欄位是在rpt里用{aapg220.APB10}*{aapg220.APA16}/100計算再取位得到,
#                                                 建議改成在4gl里就計算好稅額,將尾差調在最后一筆   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990263 09/10/14 By sabrina 第363行 " apk03, apk172,apk07,",  應調整為" apk04, apk172,apk07,",
#                                                    因此欄位應為統編非發票號。
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡 
# Modify.........: No.CHI-A40017 10/04/23 By liuxqa 修正SQL
# Modify.........: No:CHI-950028 10/06/08 By Summer 將一聯格式改為四聯格式
# Modify.........: No:MOD-A70179 10/07/23 By Dido 增加期初發票條件 
# Modify.........: No:MOD-B10243 11/02/09 By Dido 未稅與稅額改用 apk_file 
# Modify.........: No:MOD-B20146 11/02/25 By Dido 條件增加 apk02 
# Modify.........: No:FUN-B50018 11/06/08 By xumm CR轉GRW
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-B90058 11/09/06 By chenying 程式規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/11 By qirl MOD-BA0100追單
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
            wc      LIKE type_file.chr1000,        # Where condition  #No.FUN-690028 VARCHAR(600)
            choice  LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
            more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)            # Input more condition(Y/N)
          END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   l_table      STRING                      #No.FUN-710086
DEFINE   g_sql        STRING                      #No.FUN-710086
DEFINE   g_str        STRING                      #No.FUN-710086
DEFINE   g_count      LIKE type_file.num5         #No.FUN-710086
DEFINE   g_cnt        LIKE type_file.num5         #No.FUN-710086
DEFINE   i            LIKE type_file.num5         #No.FUN-710086
 
###GENGRE###START
TYPE sr1_t RECORD
    apa01 LIKE apa_file.apa01,
    apa02_1 LIKE type_file.chr3,
    apa02_2 LIKE type_file.chr2,
    apa02_3 LIKE type_file.chr2,
    apa09 LIKE apa_file.apa09,
    apa16 LIKE apa_file.apa16,
    apa171 LIKE apa_file.apa171,
    apa18 LIKE apa_file.apa18,
    apa172 LIKE apa_file.apa172,
    apa32 LIKE apa_file.apa32,
    apa31 LIKE apa_file.apa31,
    apb08 LIKE apb_file.apb08,
    apb09 LIKE apb_file.apb09,
    apb10 LIKE apb_file.apb10,
    apk07 LIKE apk_file.apk07,
    apb11 LIKE apb_file.apb11,
    apb27 LIKE apb_file.apb27,
    pmc081 LIKE pmc_file.pmc081,
    pmc52_1 LIKE type_file.chr50,
    zo041 LIKE zo_file.zo041,
    zo042 LIKE zo_file.zo041,
    zo02 LIKE zo_file.zo02,
    zo06 LIKE zo_file.zo06,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    apa01_round LIKE apa_file.apa01,            #FUN-B50018  add
    i LIKE type_file.num5,
    round LIKE type_file.num5,
    apa09_2 LIKE apa_file.apa09,
    apa16_2 LIKE apa_file.apa16,
    apa171_2 LIKE apa_file.apa171,
    apa172_2 LIKE apa_file.apa172,
    apb08_2 LIKE apb_file.apb08,
    apb09_2 LIKE apb_file.apb09,
    apb10_2 LIKE apb_file.apb10,
    apk07_2 LIKE apk_file.apk07,
    apb11_2 LIKE apb_file.apb11,
    apb27_2 LIKE apb_file.apb27,
    apa09_3 LIKE apa_file.apa09,
    apa16_3 LIKE apa_file.apa16,
    apa171_3 LIKE apa_file.apa171,
    apa172_3 LIKE apa_file.apa172,
    apb08_3 LIKE apb_file.apb08,
    apb09_3 LIKE apb_file.apb09,
    apb10_3 LIKE apb_file.apb10,
    apk07_3 LIKE apk_file.apk07,
    apb11_3 LIKE apb_file.apb11,
    apb27_3 LIKE apb_file.apb27,
    apa09_4 LIKE apa_file.apa09,
    apa16_4 LIKE apa_file.apa16,
    apa171_4 LIKE apa_file.apa171,
    apa172_4 LIKE apa_file.apa172,
    apb08_4 LIKE apb_file.apb08,
    apb09_4 LIKE apb_file.apb09,
    apb10_4 LIKE apb_file.apb10,
    apk07_4 LIKE apk_file.apk07,
    apb11_4 LIKE apb_file.apb11,
    apb27_4 LIKE apb_file.apb27,
    apa09_5 LIKE apa_file.apa09,
    apa16_5 LIKE apa_file.apa16,
    apa171_5 LIKE apa_file.apa171,
    apa172_5 LIKE apa_file.apa172,
    apb08_5 LIKE apb_file.apb08,
    apb09_5 LIKE apb_file.apb09,
    apb10_5 LIKE apb_file.apb10,
    apk07_5 LIKE apk_file.apk07,
    apb11_5 LIKE apb_file.apb11,
    apb27_5 LIKE apb_file.apb27
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #No.FUN-BB0047 mark
 
   LET g_sql = "apa01.apa_file.apa01,   apa02_1.type_file.chr3,",   #FUN-860063 apa02_1 chr2->chr3
               "apa02_2.type_file.chr2, apa02_3.type_file.chr2,",
              #"apa09_1.type_file.chr3, apa09_2.type_file.chr2,",   #FUN-860063 apa09_1 chr2->chr3 #CHI-950028 mark
              #"apa09_3.type_file.chr2, apa16.apa_file.apa16,",  #CHI-950028 mark
               "apa09.apa_file.apa09, apa16.apa_file.apa16,",    #CHI-950028 add
               "apa171.apa_file.apa171, apa18.apa_file.apa18,",
               "apa172.apa_file.apa172, apa32.apa_file.apa32,",
               "apa31.apa_file.apa31,",  #CHI-950028 add
               "apb08.apb_file.apb08,   apb09.apb_file.apb09,",
               "apb10.apb_file.apb10,   apk07.apk_file.apk07, apb11.apb_file.apb11,", #MOD-B10243 add apk07
               "apb27.apb_file.apb27,   pmc081.pmc_file.pmc081,",  #CHI-950028 mod apb12->apb27
               "pmc52_1.type_file.chr50,",    #pmc52_2.type_file.chr20,",     #MOD-840684
               "zo041.zo_file.zo041,    zo042.zo_file.zo041,",
               "zo02.zo_file.zo02,      zo06.zo_file.zo06,",        #MOD-730146  modify
               "azi03.azi_file.azi03,   azi04.azi_file.azi04,",
              #"azi05.azi_file.azi05,   l_count.apb_file.apb10,", #MOD-960258 add l_count   #CHI-950028 mark
               "azi05.azi_file.azi05,",     #CHI-950028 add  
               "apa01_round.apa_file.apa01,",    #FUN-B50018 add 
              #CHI-950028---add---start---
               "i.type_file.num5,",
               "round.type_file.num5,", 
               "apa09_2.apa_file.apa09,",
               "apa16_2.apa_file.apa16,",
               "apa171_2.apa_file.apa171,",
               "apa172_2.apa_file.apa172,",
               "apb08_2.apb_file.apb08,",
               "apb09_2.apb_file.apb09,",
               "apb10_2.apb_file.apb10,",
               "apk07_2.apk_file.apk07,", #MOD-B10243
               "apb11_2.apb_file.apb11,",
               "apb27_2.apb_file.apb27,", 
               "apa09_3.apa_file.apa09,",
               "apa16_3.apa_file.apa16,",
               "apa171_3.apa_file.apa171,",
               "apa172_3.apa_file.apa172,",
               "apb08_3.apb_file.apb08,",
               "apb09_3.apb_file.apb09,",
               "apb10_3.apb_file.apb10,",
               "apk07_3.apk_file.apk07,", #MOD-B10243
               "apb11_3.apb_file.apb11,",
               "apb27_3.apb_file.apb27,", 
               "apa09_4.apa_file.apa09,",
               "apa16_4.apa_file.apa16,",
               "apa171_4.apa_file.apa171,",
               "apa172_4.apa_file.apa172,",
               "apb08_4.apb_file.apb08,",
               "apb09_4.apb_file.apb09,",
               "apb10_4.apb_file.apb10,",
               "apk07_4.apk_file.apk07,", #MOD-B10243
               "apb11_4.apb_file.apb11,",
               "apb27_4.apb_file.apb27,", 
               "apa09_5.apa_file.apa09,",
               "apa16_5.apa_file.apa16,",
               "apa171_5.apa_file.apa171,",
               "apa172_5.apa_file.apa172,",
               "apb08_5.apb_file.apb08,",
               "apb09_5.apb_file.apb09,",
               "apb10_5.apb_file.apb10,",
               "apk07_5.apk_file.apk07,", #MOD-B10243
               "apb11_5.apb_file.apb11,",
               "apb27_5.apb_file.apb27" 
              #CHI-950028---add---end---
 
   LET l_table = cl_prt_temptable('aapg220',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-BB0047 mark 
      #CALL cl_gre_drop_temptable(l_table)     #FUN-B50018 add#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",       #CHI-950028 add
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",       #CHI-950028 add
               "        ?,?,?,?,?, ?,?,?,?)"                                  #CHI-950028 add  #MOD-B10243 add 5?  #FUN-B50018 add ?
              #"        ?,?,?,?,?, ?,?)"   #MOD-840684 #MOD-960258 add ?    #CHI-950028 mark 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)     #FUN-B50018 add#FUN-C10036 mark
      EXIT PROGRAM
   END IF
  #CHI-950028---add---start---
   DROP TABLE aapg220_tmp
   CREATE TEMP TABLE aapg220_tmp(
    apa171     LIKE apa_file.apa171,
    apa09      LIKE type_file.dat,
    apb11      LIKE apb_file.apb11,
    apb27      LIKE apb_file.apb27,
    apb09      LIKE apb_file.apb09,
    apb08      LIKE apb_file.apb08,
    apb10      LIKE apb_file.apb10,
    apk07      LIKE apk_file.apk07,                 #MOD-B10243
    apa16      LIKE apa_file.apa16,
    apa172     LIKE apa_file.apa172)
  #CHI-950028---add---end---
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.choice = ARG_VAL(8)   #FUN-640124
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078

   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL aapg220_tm(0,0)      # Input print condition
   ELSE 
      CALL aapg220()            # Read data and create out-file
      DROP TABLE aapg220_tmp    #CHI-950028 add
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
   CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
END MAIN
 
FUNCTION aapg220_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW aapg220_w AT p_row,p_col
        WITH FORM "aap/42f/aapg220"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice='1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apa01, apa02, apa06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r630_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)     #FUN-B50018 add
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.choice,tm.more
                   WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD choice
         IF tm.choice NOT MATCHES '[12]' THEN NEXT FIELD choice END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapg220_w 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)     #FUN-B50018 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapg220'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapg220','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",   #FUN-640124
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapg220',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aapg220_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)     #FUN-B50018 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aapg220()
   ERROR ""
END WHILE
   CLOSE WINDOW aapg220_w
END FUNCTION
 
FUNCTION aapg220()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_chr        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE zaa_file.zaa08,     # No.FUN-690028 VARCHAR(10),
          sr    RECORD
              apa01  LIKE apa_file.apa01,    # 帳款日期
              apa02  LIKE apa_file.apa02,    # 帳款日期
              apa09  LIKE apa_file.apa09,    # 發票日期
              apa16  LIKE apa_file.apa16,    # 稅    率
              apa171 LIKE apa_file.apa171,   # 扣抵區分
              apa18  LIKE apa_file.apa18,    # 廠商統一編號
              apa172 LIKE apa_file.apa172,   # 課 稅 別
              apa32  LIKE apa_file.apa32,    # 稅額
              apa31  LIKE apa_file.apa31,    # 未稅金額   #CHI-950028 add
              apb02  LIKE apb_file.apb02,    # 項    次   #MOD-B20146
              apb08  LIKE apb_file.apb08,    # 單    價
              apb09  LIKE apb_file.apb09,    # 數    量
              apb10  LIKE apb_file.apb10,    # 金    額
              apk07  LIKE apk_file.apk07,    # 稅    額   #MOD-B10243
              apb11  LIKE apb_file.apb11,    # 原發票號碼
              apb27  LIKE apb_file.apb27,    # 品    名  #CHI-950028 mod apb12->apb27
              pmc081 LIKE pmc_file.pmc081,   # 全名(第一行)
              pmc52  LIKE pmc_file.pmc52 ,   # 地址(第一行)
              zo041  LIKE zo_file.zo041,     # 地址
              zo042  LIKE zo_file.zo042,     # 地址
              zo02   LIKE zo_file.zo02,      # 公司全名  #MOD-730146 modify
              zo06   LIKE zo_file.zo06,      # 統一編號
              azi03  LIKE azi_file.azi03,    #
              azi04  LIKE azi_file.azi04 ,   #
              azi05  LIKE azi_file.azi05 ,   # #MOD-960258 add ,      
              apa01_round LIKE apa_file.apa01, #FUN-B50018 add
              apa15   LIKE apa_file.apa15     #稅別    #CHI-950028 add
             #l_count LIKE apb_file.apb10                #MOD-960258   #CHI-950028 mark
          END RECORD,
         #CHI-950028---add---start---
          sr2   DYNAMIC ARRAY OF RECORD
                apa171    LIKE apa_file.apa171,
                apa09     LIKE apa_file.apa09,
                apb11     LIKE apb_file.apb11,
                apb27     LIKE apb_file.apb27, 
                apb09     LIKE apb_file.apb09,
                apb08     LIKE apb_file.apb08,
                apb10     LIKE apb_file.apb10,
                apk07     LIKE apk_file.apk07,   #MOD-B10243
                apa16     LIKE apa_file.apa16,
                apa172    LIKE apa_file.apa172
            END RECORD,
            l_check       LIKE type_file.num10,  #檢查碼
            l_code1       LIKE type_file.num5,
            l_code        LIKE type_file.num5,
            n,i           LIKE type_file.num5,
            l_i           LIKE type_file.num5,   
            l_j           LIKE type_file.num5,   
            l_count       LIKE type_file.num5,   
            l_total       INTEGER,               
            l_aapg220_curs1_count  INTEGER       
           #CHI-950028---add---end---
 
   DEFINE o_apa09    LIKE apa_file.apa09
   DEFINE o_apa171   LIKE apa_file.apa171
   DEFINE l_apa02_1  LIKE type_file.chr3       #FUN-860063-modify->chr2->chr3
   DEFINE l_apa02_2  LIKE type_file.chr2
   DEFINE l_apa02_3  LIKE type_file.chr2
   DEFINE l_apa09    LIKE apa_file.apa09    #CHI-950028 add 
  #DEFINE l_apa09_1  LIKE type_file.chr3    #FUN-860063-modify->chr2->chr3 #CHI-950028 mark
  #DEFINE l_apa09_2  LIKE type_file.chr2    #CHI-950028 mark 
  #DEFINE l_apa09_3  LIKE type_file.chr2    #CHI-950028 mark  
   DEFINE l_pmc52_1  LIKE type_file.chr50   #MOD-840684
   DEFINE l_apa171   LIKE type_file.chr1
   DEFINE l_apa01    LIKE apa_file.apa01
   DEFINE l_apa02_11 LIKE type_file.chr3      #FUN-860063-modify->chr2->chr3
   DEFINE l_apa02_21 LIKE type_file.chr2
   DEFINE l_apa02_31 LIKE type_file.chr2
   DEFINE l_apa18    LIKE apa_file.apa18
   DEFINE l_apa32    LIKE apa_file.apa32
   DEFINE l_pmc081   LIKE pmc_file.pmc081
   DEFINE l_pmc52_11 LIKE type_file.chr50   #MOD-840684
   DEFINE l_zo041    LIKE zo_file.zo041
   DEFINE l_zo042    LIKE zo_file.zo042
   DEFINE l_zo02     LIKE zo_file.zo02       #MOD-730146 modify
   DEFINE l_zo06     LIKE zo_file.zo06 
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_round    LIKE type_file.num5   #CHI-950028 add 一round有四聯，四聯為一round
   DEFINE l_apk05    LIKE apk_file.apk05,   #MOD-790018
          l_apk172   LIKE apk_file.apk172,  #MOD-790018
          l_gec05    LIKE gec_file.gec05   #MOD-790018
   DEFINE l_sql_2        LIKE type_file.chr1000  # RDSQL STATEMENT 
   #DEFINE l_img_blob     LIKE type_file.blob    #FUN-940041 mark
   #DEFINE l_sign_type    LIKE type_file.chr1    #CHI-A40017 add #FUN-940041 mark
   #DEFINE l_sign_show    LIKE type_file.chr1    #CHI-A40017 add #FUN-940041 mark
   DEFINE l_ii           INTEGER
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE apa_file.apa01
             END RECORD
  #DEFINE l_count_sum LIKE apb_file.apb10  #MOD-960258      #CHI-950028 mark 
  
     CALL cl_del_data(l_table)     #No.FUN-710086
     DELETE FROM aapg220_tmp   #CHI-950028 add  
     LET l_round = 0           #CHI-950028 add   
     #LET l_sign_type = ''          #CHI-A40017 add  #FUN-940041 mark
     #LET l_sign_show = 'N'         #CHI-A40017 add  #FUN-940041 mark
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapg220'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
 
     IF tm.choice = '1' THEN
      #-------------------------------------------------#FUN-C10036---------------------------------------------
        IF g_aza.aza26 = '2' THEN
           LET l_sql = "SELECT ",
                       " apa01, apa02, apa09, apa16, apa171, ",
                       " apa18, apa172,apa32,apa31, apb02, ",
                       " apb08, apb09, apb10, 0,apb11, apb27, ",
                       " pmc081,pmc52, ",
                       " zo041, zo042, zo02, zo06, ",
                       " azi03, azi04, azi05,'',apa15",                #FUN-C10036 add ''
                       " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ",
                       " , apb_file, pmc_file, zo_file ",
                       " WHERE pmc01 = apa06",
                       "   AND (apa00 = '21' OR apa00 = '22' OR apa00 = '26') ",
                       "   AND apa01 = apb01 ",
                       "   AND apa42 = 'N' ",
                       "   AND ",tm.wc CLIPPED,
                       "   AND zo01 = '",g_lang,"'",
                       " ORDER BY apa01 "
        ELSE
      #-------------------------------------------------#FUN-C10036-------------------------------------------
        LET l_sql = "SELECT ",
                    " apa01, apa02, apa09, apa16, apa171, ",
                    " apa18, apa172,apa32,apa31, apb02, ",   #CHI-950028 add apa31 #MOD-B20146 add apb02
                   #" apb08, apb09, apb10, apb11, apb27, ",  #CHI-950028 mod apb12->apb27   #MOD-B10243 mark 
                    " apb08, apb09, apb10, 0,apb11, apb27, ",  #CHI-950028 mod apb12->apb27 #MOD-B10243
                    " pmc081,pmc52, ",
                    " zo041, zo042, zo02, zo06, ",    #MOD-730146 modify
                   #" azi03, azi04, azi05,''", #MOD-960258 add ,''     #CHI-950028 mark
                    " azi03, azi04, azi05,'',apa15", #MOD-960258 add ,''  #CHI-950028    #FUN-B50018 add ''
                    #" FROM apa_file, apb_file, pmc_file, zo_file,",
                    " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ",  #No.CHI-A40017 mod
                    " , apb_file, pmc_file, zo_file ",
                    #"  OUTER azi_file   ",  #CHI-A40017 mark
                    " WHERE pmc01 = apa06",
                      #"   AND (apa00 = '21' OR apa00 = '22' OR apa00='26') ",   #MOD-650094 #No.TQC-770056 add 26 #FUN-C10036 mark
                       "   AND (apa00 = '21' OR apa00 = '22') ",   #FUN-C10036 add
                       "   AND apa01 = apb01 ",
                      #"   AND apa_file.apa13 = azi_file.azi01 ", #CHI-A40017 mark
                       "   AND apa42 = 'N' ",
                       "   AND ",tm.wc CLIPPED,
                       "   AND zo01 = '",g_lang,"'",
                       " ORDER BY apa01 "  #No.FUN-710086
        END IF                                                    #FUN-C10036 add
     ELSE
        LET l_sql = "SELECT ",
                    " apk01, apa02, apk05, apa16, apk171, ",
                    " apk04, apk172,apk07,apk08,apb02, ",   #MOD-990263 add #CHI-950028 add apk08 #MOD-B20146 add apb02
                   #" apb08, apb09, apk08, apb11, apb27, ",   #TQC-630280  #CHI-950028 mod apb12->apb27    #MOD-B10243 mark
                    " apb08, apb09, apk08, 0, apb11, apb27, ",   #TQC-630280  #CHI-950028 mod apb12->apb27 #MOD-B10243
                    " pmc081,pmc52, ",
                    " zo041, zo042, zo02, zo06, ",    #MOD-730146 modify
                   #" azi03, azi04, azi05,''", #MOD-960258 add ,'' #CHI-950028 mark    
                    " azi03, azi04, azi05,'',apa15 ", #MOD-960258 add ,'' #CHI-950028    #FUN-B50018 add ''
                    " FROM apa_file, apb_file,apk_file,",   #TQC-630280
                    " FROM apa_file  LEFT OUTER JOIN azi_file ON azi01 = apa13 ",
                    ",apb_file,apk_file,",   #TQC-630280
                    "      pmc_file, zo_file ",
                    #"  OUTER azi_file   ",  #CHI-A40017 mark
                    " WHERE pmc01 = apa06",
                    "   AND apk01 = apa01",
                    "   AND apk171 = '23' ",
                    "   AND apa01 = apb01 ",
                    #"   AND apa_file.apa13 = azi_file.azi01 ",  #CHI-A40017 mark
                    "   AND apa42 = 'N'   ",
                    "   AND apk02 = apb02 ",     #CHI-950028 add
                    "   AND ",tm.wc CLIPPED,
                    "   AND zo01 = '",g_lang,"'",
                    " ORDER BY apa01 "  #No.FUN-710086   
     END IF
     PREPARE aapg220_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)     #FUN-B50018 add
        EXIT PROGRAM
     END IF
     DECLARE aapg220_curs1 CURSOR FOR aapg220_prepare1
 
    #CHI-950028---mark---start---
    # IF tm.choice = '1' THEN
    #    LET l_sql = "SELECT COUNT(*)",
    #                #" FROM apa_file, apb_file, pmc_file, zo_file,",  #CHI-A40017 mark
    #                " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ",#CHI-A40017 
    #                " , apb_file, pmc_file, zo_file",
    #                #"  OUTER azi_file   ",  #CHI-A40017 mark
    #                " WHERE pmc01 = apa06",
    #                "   AND (apa00 = '21' OR apa00 = '22') ",
    #                "   AND apa01 = apb01 ",
    #                #"   AND apa_file.apa13 = azi_file.azi01 ",  #CHI-A40017 mark
    #                "   AND apa42 = 'N' ",
    #                "   AND ",tm.wc CLIPPED,
    #                "   AND zo01 = '",g_lang,"'"
    # ELSE
    #    LET l_sql = "SELECT COUNT(*)",
    #                #" FROM apa_file, apb_file,apk_file,",
    #                " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ",#No.CHI-A40017 mod
    #                " , apb_file,apk_file,", 
    #                "      pmc_file, zo_file ",
    #                #"  OUTER azi_file   ",  #CHI-A40017 mark
    #                " WHERE pmc01 = apa06",
    #                "   AND apk01 = apa01",
    #                "   AND apk171 = '23' ",
    #                "   AND apa01 = apb01 ",
    #                #"   AND apa_file.apa13 = azi_file.azi01 ", #CHI-A40017 mark
    #                "   AND apa42 = 'N'   ",
    #                "   AND ",tm.wc CLIPPED,
    #                "   AND zo01 = '",g_lang,"'"
    # END IF
    # PREPARE aapg220_prepare2 FROM l_sql
    # DECLARE aapg220_curs2 CURSOR FOR aapg220_prepare2
    # OPEN aapg220_curs2
    # FETCH aapg220_curs2 INTO l_n
    # LET g_count = 0 
    # LET g_cnt = 0 
    # LET l_count_sum=0 #MOD-960258        
    #CHI-950028---mark---end---
     LET l_i = 0        #CHI-950028 add   
     LET l_count = 0    #CHI-950028 add 
     FOREACH aapg220_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #CHI-950028---add---start---
       IF tm.choice = '1' THEN
      #--------------------------------------#FUN-C10036---------------------------start
          IF g_aza.aza26 = '2' THEN
             LET l_sql = "SELECT COUNT(*)",
                         " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ",
                         " , apb_file, pmc_file, zo_file",
                         " WHERE pmc01 = apa06",
                         "   AND (apa00 = '21' OR apa00 = '22' OR apa00 = '26') ",
                         "   AND apa01 = apb01 ",
                         "   AND apa13 = azi01 ",
                         "   AND apa42 = 'N' ",
                         "   AND apa01 = '",sr.apa01,"'",
                         "   AND ",tm.wc CLIPPED,
                         "   AND zo01 = '",g_lang,"'"
          ELSE
      #--------------------------------------#FUN-C10036------------------------------end
          LET l_sql = "SELECT COUNT(*)",
                      " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ", 
                      " , apb_file, pmc_file, zo_file",
                      " WHERE pmc01 = apa06",
                      "   AND (apa00 = '21' OR apa00 = '22') ",  
                      "   AND apa01 = apb01 ",
                      "   AND apa13 = azi01 ",
                      "   AND apa42 = 'N' ",
                      "   AND apa01 = '",sr.apa01,"'",    
                      "   AND ",tm.wc CLIPPED,
                      "   AND zo01 = '",g_lang,"'"
          END IF                                                      #No.FUN-C10036 add
       ELSE
          LET l_sql = "SELECT COUNT(*)",
                      " FROM apa_file LEFT OUTER JOIN azi_file ON apa13=azi01 ",
                      " , apb_file,apk_file,", 
                      "      pmc_file, zo_file,",
                      " WHERE pmc01 = apa06",
                      "   AND apk01 = apa01",
                      "   AND apk171 = '23' ",
                      "   AND apa01 = apb01 ",
                      "   AND apa13 = azi01 ",
                      "   AND apa42 = 'N'   ",
                      "   AND apa01 = '",sr.apa01,"'",
                      "   AND apk02 = apb02 ", 
                      "   AND ",tm.wc CLIPPED,
                      "   AND zo01 = '",g_lang,"'"
       END IF
       PREPARE aapg220_prepare2 FROM l_sql
       DECLARE aapg220_curs2 CURSOR FOR aapg220_prepare2
       OPEN aapg220_curs2
       FETCH aapg220_curs2 INTO l_total
       
       LET l_aapg220_curs1_count = l_aapg220_curs1_count + 1
       LET l_count = l_count + 1
       IF l_count > 5 THEN
          LET l_count = 1
       END IF
      #CHI-950028---add---end---
 
       IF cl_null(l_apa01) THEN
          LET l_apa01 = sr.apa01
       END IF
      #CHI-950028---mark---start---
      # IF l_apa01 <> sr.apa01 THEN
      #    IF g_count < 5 THEN
      #       FOR i = g_count+1 to 5
      #          #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,  #CHI-A40017 mark
      #          LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,  #CHI-A40017 mod
      #                      " VALUES('",l_apa01,"','",l_apa02_11,"','",l_apa02_21,
      #                      "','",l_apa02_31,"','','','','','','",l_apa18,"',' ',",
      #                      l_apa32,",'','','','','','",l_pmc081,"','",l_pmc52_11,
      #                      "','",l_zo041,"','",l_zo042,"','",l_zo02,  #MOD-730146 modify   #MOD-840684
      #                      "','",l_zo06,"',",sr.azi03,",",sr.azi04,",",sr.azi05,",'')" #MOD-960258 add ''  #CHI-A40017 add 3 #FUN-940041 拿掉l_img_blob
      #          PREPARE insert_prep1 FROM g_sql
      #          IF STATUS THEN
      #             CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
      #          END IF
      #          EXECUTE insert_prep1
      #       END FOR
      #       LET g_count = 0
      #    END IF
      # END IF
      # LET l_apa01 = sr.apa01
      #CHI-950028---mark---end---
 

       DECLARE g220_sel_apk2 CURSOR FOR
        SELECT apk05,apk172,gec05 FROM apa_file,apk_file,gec_file   #MOD-7A0157
         WHERE apa01 = apk01 
           AND apk03 = sr.apb11
           AND apa00 MATCHES '1*'
           AND gec01 = apk11 AND gec011 = '1'
       LET l_apk05=''
       LET l_apa09 = ' '     #CHI-950028 add
       LET l_apk172=''
       LET l_gec05=''
       OPEN g220_sel_apk2
       FETCH g220_sel_apk2 INTO l_apk05,l_apk172,l_gec05
       LET l_apa02_1 = (YEAR(sr.apa02)-1911) USING '###' CLIPPED
       LET l_apa02_2 = MONTH(sr.apa02) USING '&&' CLIPPED
       LET l_apa02_3 = DAY(sr.apa02)  USING '&&' CLIPPED
      #LET l_apa09_1 = (YEAR(l_apk05)-1911) USING '###' CLIPPED    #CHI-950028 mark  
       LET l_apa09 = l_apk05 #CHI-950028 add
      #LET l_apa09_2 = MONTH(l_apk05) USING '&&' CLIPPED           #CHI-950028 mark 
      #LET l_apa09_3 = DAY(l_apk05) USING '&&' CLIPPED             #CHI-950028 mark     
       LET l_pmc52_1 = sr.pmc52   #MOD-840684
      #LET sr.apb12 = sr.apb12[1,16]  #CHI-950028 mark
       LET sr.apb27 = sr.apb27[1,15]  #CHI-950028
       LET sr.apb09 = sr.apb09 USING '#####&.&'
       IF cl_null(sr.apa18) THEN LET sr.apa18=' ' END IF   #MOD-890212 add
#CHI-950028---modify---start---
#       IF g_cnt = l_n THEN                                                                                                          
#          LET sr.l_count=(sr.apb10*sr.apa16)/100                                                                                    
#          LET sr.l_count=cl_digcut(sr.l_count,sr.azi04)                                                                             
#          LET l_count_sum=l_count_sum+sr.l_count                                                                                    
#          LET l_count_sum=cl_digcut(l_count_sum,sr.azi05)                                                                           
#          LET sr.apa32=cl_digcut(sr.apa32,sr.azi05)                                                                                 
#          LET sr.l_count=sr.l_count+(sr.apa32-l_count_sum)                                                                          
#          LET sr.l_count=cl_digcut(sr.l_count,sr.azi04)                                                                             
#       ELSE                                                                                                                         
#          LET sr.l_count=(sr.apb10*sr.apa16 )/100                                                                                   
#          LET sr.l_count=cl_digcut(sr.l_count,sr.azi04)                                                                             
#          LET l_count_sum=l_count_sum+sr.l_count                                                                                    
#       END IF                          

#CHI-A40017 str--add    暂时mark                                                                                         
#       LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,  #CHI-A40017 mod
#                   " VALUES('",sr.apa01,"','",l_apa02_1,"','",l_apa02_2,
#                   "','",l_apa02_3,"','",l_apa09_1,"','",l_apa09_2,"','",l_apa09_3,
#                   "',",sr.apa16,",'",l_gec05,"','",sr.apa18,"','",l_apk172,"',",
#                   sr.apa32,",",sr.apb08,",",sr.apb09,",",sr.apb10,",'",sr.apb11,"'
#                   ,'",sr.apb12,"','",sr.pmc081,"','",l_pmc52_11,"'
#                   ,'",sr.zo041,"','",sr.zo042,"','",sr.zo02,"' 
#                   ,'",sr.zo06,"',",sr.azi03,",",sr.azi04,",",sr.azi05,",",sr.l_count,"
#                   ,'','",l_img_blob,"','N')" #MOD-960258 add ''  #CHI-A40017 add 3
#       PREPARE insert_prep FROM g_sql
#       IF STATUS THEN
#          CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#       END IF
#       EXECUTE insert_prep
#CHI-A40017 end--mark
       IF tm.choice = '1' THEN
         #SELECT apk05 INTO sr.apa09 FROM apk_file WHERE apk03 = sr.apb11 #MOD-B10243 mark
         #-MOD-B10243-add-
          SELECT apk05,apk08,apk07 INTO sr.apa09,sr.apb10,sr.apk07 
            FROM apk_file 
           WHERE apk03 = sr.apb11
             AND apk01 = sr.apa01  
             AND apk02 = sr.apb02   #MOD-B20146 
         #-MOD-B10243-end-
       END IF
       IF cl_null(l_apa09) THEN    #090423 by Iris modify 
         #SELECT amd05 INTO sr.apa09 FROM amd_file WHERE amd03=sr.apb11 AND amd021='5'              #MOD-A70179 mark
          SELECT amd05 INTO sr.apa09 FROM amd_file WHERE amd03=sr.apb11 AND amd021 IN ('4','5')     #MOD-A70179
       END IF
  
       SELECT gec05 INTO sr.apa171 FROM gec_file WHERE gec01 = sr.apa15
     
       INSERT INTO aapg220_tmp VALUES(sr.apa171,sr.apa09,sr.apb11,sr.apb27,sr.apb09,sr.apb08,sr.apb10,sr.apk07,sr.apa16,sr.apa172) #MOD-B10243 add apk07
       IF tm.choice != '1' THEN
          SELECT sum(apk08) INTO sr.apa31 FROM apk_file WHERE apk01 = sr.apa01
       END IF 
       IF l_count = 5 THEN   
          LET l_j = 1
          DECLARE aapg220_curs CURSOR FOR SELECT * FROM aapg220_tmp
          FOREACH aapg220_curs INTO sr2[l_j].*
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               LET l_j = l_j + 1
          END FOREACH

          LET l_round = l_round + 1  
          IF l_total <> l_aapg220_curs1_count THEN  #MOD-B10243 
             LET sr.apa31 = '' 
###GENGRE###             LET sr.apa32 = '' 
          END IF                                    #MOD-B10243

          LET sr.apa01_round = sr.apa01,l_round      #FUN-B50018 add
          FOR l_i = 1 TO 4
                EXECUTE insert_prep  USING
                        sr.apa01,      l_apa02_1,     l_apa02_2,    l_apa02_3,     sr2[1].apa09,
                        sr2[1].apa16,  sr.apa171,     sr.apa18,     sr.apa172,     sr.apa32,       
                       #sr.apa31,      sr2[1].apb08,  sr2[1].apb09, sr2[1].apb10,  sr2[1].apb11,  #MOD-B10243 mark 
                        sr.apa31,      sr2[1].apb08,  sr2[1].apb09, sr2[1].apb10,  sr2[1].apk07,  #MOD-B10243
                        sr2[1].apb11,                                                             #MOD-B10243
                        sr2[1].apb27,  sr.pmc081,     l_pmc52_1,                                   
                        sr.zo041,      sr.zo042,      sr.zo02,      sr.zo06,       sr.azi03,
                        sr.azi04,      sr.azi05,      sr.apa01_round,l_i,          l_round,       #FUN-B50018 add apa01_round
                        sr2[2].apa09 , sr2[2].apa16,  sr2[2].apa171,sr2[2].apa172, sr2[2].apb08,
                        sr2[2].apb09 , sr2[2].apb10,  sr2[2].apk07, sr2[2].apb11, sr2[2].apb27,   #MOD-B10243 add apk07
                        sr2[3].apa09 , sr2[3].apa16,  sr2[3].apa171,sr2[3].apa172, sr2[3].apb08,
                        sr2[3].apb09 , sr2[3].apb10,  sr2[3].apk07, sr2[3].apb11, sr2[3].apb27,   #MOD-B10243 add apk07
                        sr2[4].apa09 , sr2[4].apa16,  sr2[4].apa171,sr2[4].apa172, sr2[4].apb08,
                        sr2[4].apb09 , sr2[4].apb10,  sr2[4].apk07, sr2[4].apb11, sr2[4].apb27,   #MOD-B10243 add apk07` 
                        sr2[5].apa09 , sr2[5].apa16,  sr2[5].apa171,sr2[5].apa172, sr2[5].apb08,
                        sr2[5].apb09 , sr2[5].apb10,  sr2[5].apk07, sr2[5].apb11, sr2[5].apb27    #MOD-B10243 add apk07 
          END FOR
          FOR i = 1 TO 5
              INITIALIZE sr2[i].* TO NULL
          END FOR
          IF l_total = l_aapg220_curs1_count THEN   
             LET l_aapg220_curs1_count = 0  
          END IF                                   
          LET l_count = 0
          DELETE FROM aapg220_tmp
       ELSE
          IF l_total = l_aapg220_curs1_count  THEN
             WHILE l_count > 0 
                LET l_j = 1
                DECLARE aapg220_curs3 CURSOR FOR SELECT * FROM aapg220_tmp
                FOREACH aapg220_curs3 INTO sr2[l_j].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_j = l_j + 1
                END FOREACH
 
                LET l_round = l_round + 1
                LET sr.apa01_round = sr.apa01,l_round      #FUN-B50018 add
                FOR l_i = 1 TO 4
                   EXECUTE insert_prep  USING
                           sr.apa01,      l_apa02_1,     l_apa02_2,    l_apa02_3,     sr2[1].apa09,
                           sr2[1].apa16,  sr.apa171,     sr.apa18,     sr.apa172,     sr.apa32,        
                          #sr.apa31,      sr2[1].apb08,  sr2[1].apb09, sr2[1].apb10,  sr2[1].apb11,  #MOD-B10243 mark 
                           sr.apa31,      sr2[1].apb08,  sr2[1].apb09, sr2[1].apb10,  sr2[1].apk07,  #MOD-B10243
                           sr2[1].apb11,                                                             #MOD-B10243
                           sr2[1].apb27,  sr.pmc081,     l_pmc52_1,                                
                           sr.zo041,      sr.zo042,      sr.zo02,      sr.zo06,       sr.azi03,
                           sr.azi04,      sr.azi05,      sr.apa01_round,l_i, l_round,                #FUN-B50018 add apa01_round
                           sr2[2].apa09 , sr2[2].apa16,  sr2[2].apa171,sr2[2].apa172,sr2[2].apb08,
                           sr2[2].apb09 , sr2[2].apb10,  sr2[2].apk07, sr2[2].apb11, sr2[2].apb27,   #MOD-B10243 add apk07
                           sr2[3].apa09 , sr2[3].apa16,  sr2[3].apa171,sr2[3].apa172,sr2[3].apb08,
                           sr2[3].apb09 , sr2[3].apb10,  sr2[3].apk07, sr2[3].apb11, sr2[3].apb27,   #MOD-B10243 add apk07
                           sr2[4].apa09 , sr2[4].apa16,  sr2[4].apa171,sr2[4].apa172,sr2[4].apb08,
                           sr2[4].apb09 , sr2[4].apb10,  sr2[4].apk07, sr2[4].apb11, sr2[4].apb27,   #MOD-B10243 add apk07` 
                           sr2[5].apa09 , sr2[5].apa16,  sr2[5].apa171,sr2[5].apa172,sr2[5].apb08,
                           sr2[5].apb09 , sr2[5].apb10,  sr2[5].apk07, sr2[5].apb11, sr2[5].apb27    #MOD-B10243 add apk07 
                END FOR
                FOR i = 1 TO 5
                    INITIALIZE sr2[i].* TO NULL
                END FOR
                LET l_aapg220_curs1_count = l_aapg220_curs1_count - 5   
               LET l_aapg220_curs1_count = 0
               LET l_count = 0
               DELETE FROM aapg220_tmp
             END WHILE 
          END IF
       END IF
       LET l_apa01 =sr.apa01

       #EXECUTE insert_prep USING
       #   sr.apa01, l_apa02_1,l_apa02_2,l_apa02_3,l_apa09_1,
       #   l_apa09_2,l_apa09_3,sr.apa16, l_gec05,  sr.apa18,   #MOD-790018
       #   l_apk172, sr.apa32, sr.apb08, sr.apb09, sr.apb10,   #MOD-790018
       #   sr.apb11, sr.apb12, sr.pmc081,l_pmc52_1,            #MOD-840684
       #   sr.zo041, sr.zo042, sr.zo02,  sr.zo06,  sr.azi03,
       #   sr.azi04, sr.azi05, sr.l_count   #MOD-730146 modify #MOD-960258  add sr.l_count
       #   #l_sign_type,l_img_blob,l_sign_show     #CHI-A40017 mod #FUN-940041 mark
       #   #"",l_img_blob,"N"        #CHI-A40017 mark
       #LET g_count = g_count+1
       #LET g_cnt = g_cnt+1
       #LET l_apa02_11 = l_apa02_1
       #LET l_apa02_21 = l_apa02_2
       #LET l_apa02_31 = l_apa02_3
       #LET l_apa18 = sr.apa18
       #LET l_apa32 = sr.apa32
       #LET l_pmc081 = sr.pmc081
       #LET l_pmc52_11 = l_pmc52_1
       #LET l_zo041 = sr.zo041
       #LET l_zo042 = sr.zo042
       #LET l_zo02 = sr.zo02             #MOD-730146 modify
       #LET l_zo06 = sr.zo06
 
       #IF g_cnt = l_n THEN
       #   IF g_count < 5 THEN
       #      FOR i = g_count+1 to 5
       #         #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED, #CHI-A40017 mark
       #         LET g_sql = "INSERT INTO" , g_cr_db_str CLIPPED,l_table CLIPPED,  #CHI-A40017 mod 
       #                     " VALUES('",l_apa01,"','",l_apa02_11,"','",l_apa02_21,
       #                     "','",l_apa02_31,"','','','','','','",l_apa18,"',' ',",
       #                     l_apa32,",'','','','','','",l_pmc081,"','",l_pmc52_11,
       #                     "','",l_zo041,"','",l_zo042,"','",l_zo02,      #MOD-730146 modify   #MOD-840684
       #                     "','",l_zo06,"',",sr.azi03,",",sr.azi04,",",sr.azi05,",'')" #MOD-960258 add ,''  #CHI-A40017 add 3 #FUN-940041 拿掉 l_img_blob
       #         PREPARE insert_prep2 FROM g_sql
       #         IF STATUS THEN
       #            CALL cl_err('insert_prep2:',status,1) EXIT PROGRAM
       #         END IF
       #         EXECUTE insert_prep2
       #      END FOR
       #      LET g_count = 0
       #   END IF
       #END IF
 
#CHI-950028---modify---end---        
     END FOREACH
 
 
 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
     
     ###FUN-940041 mark START ###
     LET g_cr_table = l_table                 #主報表的temp table名稱
     LET g_cr_gcx01 = "aapi103"               #單別維護程式
     LET g_cr_apr_key_f = "apa01"             #報表主鍵欄位名稱，用"|"隔開 
###GENGRE###     LET l_sql_2 = "SELECT DISTINCT apa01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE key_pr FROM l_sql_2
     DECLARE key_cs CURSOR FOR key_pr
     LET l_ii = 1
     #報表主鍵值
     #CALL g_cr_apr_key.clear()                #清空
     #FOREACH key_cs INTO l_key.*            
     #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #   LET l_ii = l_ii + 1
     #END FOREACH
     ###FUN-940041 mark END ###
###GENGRE###     CALL cl_prt_cs3('aapg220','aapg220',l_sql,'')
    CALL aapg220_grdata()    ###GENGRE###
 
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105 MARK
    #  CALL cl_gre_drop_temptable(l_table)   #FUN-B90058
END FUNCTION
 #No.FUN-9C0077 程式精簡

###GENGRE###START
FUNCTION aapg220_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aapg220")
        IF handler IS NOT NULL THEN
            START REPORT aapg220_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY apa01,i"
          
            DECLARE aapg220_datacur1 CURSOR FROM l_sql
            FOREACH aapg220_datacur1 INTO sr1.*
                OUTPUT TO REPORT aapg220_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg220_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aapg220_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018--------add-------str----------------
    DEFINE l_apa01_round    STRING
    DEFINE l_round          STRING
    DEFINE l_apa31_sum      LIKE apb_file.apb10
    DEFINE l_apb11_1        STRING
    DEFINE l_i              LIKE type_file.num5
    DEFINE l_apb11          STRING
    DEFINE l_apb11_11       STRING
    DEFINE l_apb11_02       STRING
    DEFINE l_apb11_2        STRING
    DEFINE l_apb11_22       STRING
    DEFINE l_apb11_03       STRING
    DEFINE l_apb11_3        STRING
    DEFINE l_apb11_33       STRING
    DEFINE l_apb11_04       STRING
    DEFINE l_apb11_4        STRING
    DEFINE l_apb11_44       STRING
    DEFINE l_apb11_05       STRING
    DEFINE l_apb11_5        STRING
    DEFINE l_apb11_55       STRING
    DEFINE l_year           LIKE type_file.chr3
    DEFINE l_month          LIKE type_file.chr2
    DEFINE l_day            LIKE type_file.chr2
    DEFINE l_year_2         LIKE type_file.chr3
    DEFINE l_month_2        LIKE type_file.chr2
    DEFINE l_day_2          LIKE type_file.chr2
    DEFINE l_year_3         LIKE type_file.chr3
    DEFINE l_month_3        LIKE type_file.chr2
    DEFINE l_day_3          LIKE type_file.chr2
    DEFINE l_year_4         LIKE type_file.chr3
    DEFINE l_month_4        LIKE type_file.chr2
    DEFINE l_day_4          LIKE type_file.chr2
    DEFINE l_year_5         LIKE type_file.chr3
    DEFINE l_month_5        LIKE type_file.chr2
    DEFINE l_day_5          LIKE type_file.chr2
    DEFINE l_display        STRING
    DEFINE l_display1       STRING
    DEFINE l_display2       STRING
    DEFINE l_display3       STRING
    DEFINE l_display4       STRING
    DEFINE l_apb08_fmt      STRING
    DEFINE l_apb09_fmt      STRING
    DEFINE l_apb10_fmt      STRING
    DEFINE l_apk07_fmt      STRING
    DEFINE l_apa31_fmt      STRING
    DEFINE l_apa32_fmt      STRING
    #FUN-B50018--------add-------end----------------


    
     ORDER EXTERNAL BY sr1.apa01,sr1.round 
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
         BEFORE GROUP OF sr1.apa01   
             LET l_lineno = 0             

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
                 
            #FUN-B50018--------add-------str----------------
            LET l_apb08_fmt = cl_gr_numfmt('apb_file','apb08',sr1.azi03)
            PRINTX l_apb08_fmt
            LET l_apb10_fmt = cl_gr_numfmt('apb_file','apb10',sr1.azi04)
            PRINTX l_apb10_fmt
            LET l_apb09_fmt = cl_gr_numfmt('apb_file','apb09',sr1.azi03)
            PRINTX l_apb09_fmt
            LET l_apk07_fmt = cl_gr_numfmt('apk_file','apk07',sr1.azi04)
            PRINTX l_apk07_fmt
            LET l_apa31_fmt = cl_gr_numfmt('apa_file','apa31',sr1.azi04)
            PRINTX l_apa31_fmt
            LET l_apa32_fmt = cl_gr_numfmt('apa_file','apa32',sr1.azi04)
            PRINTX l_apa32_fmt
  

            IF cl_null(sr1.apa172) THEN
               LET l_display = "N"
            ELSE 
               LET l_display = "Y"
            END IF
            PRINTX l_display

            IF cl_null(sr1.apa172_2) THEN
               LET l_display1 = "N"
            ELSE 
               LET l_display1 = "Y"
            END IF
            PRINTX l_display1
 
            IF cl_null(sr1.apa172_3) THEN
               LET l_display2 = "N"
            ELSE 
               LET l_display2 = "Y"
            END IF
            PRINTX l_display2
          
            IF cl_null(sr1.apa172_4) THEN
               LET l_display3 = "N"
            ELSE 
               LET l_display3 = "Y"
            END IF
            PRINTX l_display3

            IF cl_null(sr1.apa172_5) THEN
               LET l_display4 = "N"
            ELSE 
               LET l_display4 = "Y"
            END IF
            PRINTX l_display4


            LET l_year = (YEAR(sr1.apa09)-1911) USING '###' CLIPPED
            LET l_month = MONTH(sr1.apa09) USING '&&' CLIPPED
            LET l_day = DAY(sr1.apa09) USING '&&' CLIPPED
            PRINTX l_year
            PRINTX l_month
            PRINTX l_day


            LET l_year_2 = (YEAR(sr1.apa09_2)-1911) USING '###' CLIPPED
            LET l_month_2 = MONTH(sr1.apa09_2) USING '&&' CLIPPED
            LET l_day_2 = DAY(sr1.apa09_2) USING '&&' CLIPPED
            PRINTX l_year_2
            PRINTX l_month_2
            PRINTX l_day_2

            LET l_year_3 = (YEAR(sr1.apa09_3)-1911) USING '###' CLIPPED
            LET l_month_3 = MONTH(sr1.apa09_3) USING '&&' CLIPPED
            LET l_day_3 = DAY(sr1.apa09_3) USING '&&' CLIPPED
            PRINTX l_year_3
            PRINTX l_month_3
            PRINTX l_day_3
 

            LET l_year_4 = (YEAR(sr1.apa09_4)-1911) USING '###' CLIPPED
            LET l_month_4 = MONTH(sr1.apa09_4) USING '&&' CLIPPED
            LET l_day_4 = DAY(sr1.apa09_4) USING '&&' CLIPPED
            PRINTX l_year_4
            PRINTX l_month_4
            PRINTX l_day_4


            LET l_year_5 = (YEAR(sr1.apa09_5)-1911) USING '###' CLIPPED
            LET l_month_5 = MONTH(sr1.apa09_5) USING '&&' CLIPPED
            LET l_day_5 = DAY(sr1.apa09_5) USING '&&' CLIPPED
            PRINTX l_year_5
            PRINTX l_month_5
            PRINTX l_day_5

            LET l_apa31_sum = sr1.apb10 + sr1.apb10_2 + sr1.apb10_3 + sr1.apb10_4 + sr1.apb10_5
            PRINTX l_apa31_sum

            LET l_apb11_1 = ' '
            IF NOT cl_null(sr1.apb11) THEN
               LET l_apb11_1 = sr1.apb11[1,2] 
            END IF
            PRINTX l_apb11_1
   
            LET l_apb11_11 = ' '
            IF NOT cl_null(sr1.apb11) THEN
               LET l_apb11 = sr1.apb11
               LET l_i = l_apb11.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_11 = sr1.apb11[l_i-8,l_i]
               END IF 
            END IF
            PRINTX l_apb11_11

            LET l_apb11_2 = ' '
            IF NOT cl_null(sr1.apb11_2) THEN
               LET l_apb11_2 = sr1.apb11_2[1,2]
            END IF
            PRINTX l_apb11_2

            LET l_apb11_22 = ' '
            IF NOT cl_null(sr1.apb11_2) THEN
               LET l_apb11_02 = sr1.apb11_2
               LET l_i = l_apb11_2.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_22 = sr1.apb11_2[l_i-8,l_i]
               END IF  
            END IF
            PRINTX l_apb11_22

            LET l_apb11_3 = ' '
            IF NOT cl_null(sr1.apb11_3) THEN
               LET l_apb11_3 = sr1.apb11_3[1,2]
            END IF
            PRINTX l_apb11_3

            LET l_apb11_33 = ' '
            IF NOT cl_null(sr1.apb11_3) THEN
               LET l_apb11_03 = sr1.apb11_3
               LET l_i = l_apb11_3.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_33 = sr1.apb11_3[l_i-8,l_i]
               END IF
            END IF
            PRINTX l_apb11_33

            LET l_apb11_4 = ' '
            IF NOT cl_null(sr1.apb11_4) THEN
               LET l_apb11_4 = sr1.apb11_4[1,2]
            END IF
            PRINTX l_apb11_4

            LET l_apb11_44 = ' '
            IF NOT cl_null(sr1.apb11_4) THEN
               LET l_apb11_04 = sr1.apb11_4
               LET l_i = l_apb11_4.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_44 = sr1.apb11_4[l_i-8,l_i]
               END IF
            END IF
            PRINTX l_apb11_44

            LET l_apb11_5 = ' '
            IF NOT cl_null(sr1.apb11_5) THEN
               LET l_apb11_5 = sr1.apb11_5[1,2]
            END IF
            PRINTX l_apb11_5

            LET l_apb11_55 = ' '
            IF NOT cl_null(sr1.apb11_5) THEN
               LET l_apb11_05 = sr1.apb11_5
               LET l_i = l_apb11_5.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_55 = sr1.apb11_5[l_i-8,l_i]
               END IF
            END IF
            PRINTX l_apb11_55
            #FUN-B50018--------add-------end----------------

            PRINTX sr1.*


        
        ON LAST ROW

END REPORT
###GENGRE###END
