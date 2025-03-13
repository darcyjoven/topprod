# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrg303.4gl
# Descriptions...: 退貨折讓証明單
# Input parameter:
# Return code....:
# Date & Author..: 09/04/20 By jan
# Modify.........: No.FUN-910091 09/04/20 By jan
# Modify.........: No.MOD-950249 09/06/03 By baofei 明細的發票日期應該抓原發票的日期，而不是折讓帳款的日期                          
#                                                   明細品名應該抓omb06不是抓料號omb04  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/30 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-B10244 11/02/09 By Smapmin 發票日期抓取順序oma09-->amd05
# Modify.........: No:CHI-B10044 11/02/11 By Summer 將一聯格式改為四聯格式
# Modify.........: No.FUN-B50018 11/06/13 By xumm CR轉GRW
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-B90058 11/09/06 By xumm 程式規範修改
# Modify.........: No.FUN-C10036 12/01/12 By yangtt 追單FUN-BB047
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.MOD-D20100 13/02/20 By apo 修正l_apb11_11取位錯誤問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
            wc      LIKE type_file.chr1000,        # Where condition 
            choice  LIKE type_file.chr1, 
            more    LIKE type_file.chr1 
          END RECORD
 
DEFINE   g_i          LIKE type_file.num5 
DEFINE   l_table      STRING 
DEFINE   g_sql        STRING
DEFINE   g_str        STRING
DEFINE   g_count      LIKE type_file.num5 
DEFINE   g_cnt        LIKE type_file.num5
DEFINE   i            LIKE type_file.num5
DEFINE   g_argv1      LIKE oma_file.oma01
DEFINE   g_argv2      LIKE oma_file.oma02
DEFINE   g_argv3      LIKE oma_file.oma68
DEFINE   g_argv4      LIKE oma_file.oma00
 
###GENGRE###START
TYPE sr1_t RECORD
    oma01 LIKE oma_file.oma01,
    oma02_1 LIKE type_file.chr3,
    oma02_2 LIKE type_file.chr2,
    oma02_3 LIKE type_file.chr2,
    oma09 LIKE oma_file.oma09,
    oma211 LIKE oma_file.oma211,
    oma212 LIKE type_file.chr20,
    oma171 LIKE oma_file.oma171,
    oma042 LIKE oma_file.oma042,
    oma172 LIKE oma_file.oma172,
    oma56x LIKE oma_file.oma56x,
    oma56 LIKE oma_file.oma56,
    omb15 LIKE omb_file.omb15,
    omb12 LIKE omb_file.omb12,
    omb16 LIKE omb_file.omb16,
    omb16_oma211 LIKE omb_file.omb16,
    ohb30 LIKE ohb_file.ohb30,
    omb06 LIKE omb_file.omb06,
    occ02 LIKE occ_file.occ02,
    occ231_1 LIKE type_file.chr50,
    zo041 LIKE zo_file.zo041,
    zo042 LIKE zo_file.zo042,
    zo02 LIKE zo_file.zo02,
    zo06 LIKE zo_file.zo06,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    i LIKE type_file.num5,
    round LIKE type_file.num5,
    oma09_2 LIKE oma_file.oma09,
    oma211_2 LIKE oma_file.oma211,
    oma212_2  LIKE type_file.chr20,
    oma171_2 LIKE oma_file.oma171,
    oma172_2 LIKE oma_file.oma172,
    omb15_2 LIKE omb_file.omb15,
    omb12_2 LIKE omb_file.omb12,
    omb16_2 LIKE omb_file.omb16,
    omb16_oma211_2 LIKE omb_file.omb16,
    ohb30_2 LIKE ohb_file.ohb30,
    omb06_2 LIKE omb_file.omb06,
    oma09_3 LIKE oma_file.oma09,
    oma211_3 LIKE oma_file.oma211,
    oma212_3 LIKE type_file.chr20,
    oma171_3 LIKE oma_file.oma171,
    oma172_3 LIKE oma_file.oma172,
    omb15_3 LIKE omb_file.omb15,
    omb12_3 LIKE omb_file.omb12,
    omb16_3 LIKE omb_file.omb16,
    omb16_oma211_3 LIKE omb_file.omb16,
    ohb30_3 LIKE ohb_file.ohb30,
    omb06_3 LIKE omb_file.omb06,
    oma09_4 LIKE oma_file.oma09,
    oma211_4 LIKE oma_file.oma211,
    oma212_4 LIKE type_file.chr20,
    oma171_4 LIKE oma_file.oma171,
    oma172_4 LIKE oma_file.oma172,
    omb15_4 LIKE omb_file.omb15,
    omb12_4 LIKE omb_file.omb12,
    omb16_4 LIKE omb_file.omb16,
    omb16_oma211_4 LIKE omb_file.omb16,
    ohb30_4 LIKE ohb_file.ohb30,
    omb06_4 LIKE omb_file.omb06,
    oma09_5 LIKE oma_file.oma09,
    oma211_5 LIKE oma_file.oma211,
    oma212_5 LIKE type_file.chr20,
    oma171_5 LIKE oma_file.oma171,
    oma172_5 LIKE oma_file.oma172,
    omb15_5 LIKE omb_file.omb15,
    omb12_5 LIKE omb_file.omb12,
    omb16_5 LIKE omb_file.omb16,
    omb16_oma211_5 LIKE omb_file.omb16,
    ohb30_5 LIKE ohb_file.ohb30,
    omb06_5 LIKE omb_file.omb06
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
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
  
#  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055    #FUN-C10036 mark
 
#CHI-B10044 mark --start--
#  LET g_sql = "oma01.oma_file.oma01,   oma02_1.type_file.chr3,",   
#              "oma02_2.type_file.chr2, oma02_3.type_file.chr2,",
#              "oma09_1.type_file.chr3, oma09_2.type_file.chr2,",   
#              "oma09_3.type_file.chr2, oma211.oma_file.oma211,",
#              "oma171.oma_file.oma171, oma042.oma_file.oma042,",
#              "oma172.oma_file.oma172, oma56x.oma_file.oma56x,",
#              "omb15.omb_file.omb15,   omb12.omb_file.omb12,",
#              "omb16.omb_file.omb16,   ohb30.ohb_file.ohb30,",
##              "omb04.omb_file.omb04,   occ02.occ_file.occ02,",  #MOD-950249   
#              "omb06.omb_file.omb06,   occ02.occ_file.occ02,",   #MOD-950249 
#              "occ231_1.type_file.chr50,", 
#              "zo041.zo_file.zo041,    zo042.zo_file.zo042,",
#              "zo02.zo_file.zo02,      zo06.zo_file.zo06,",       
#              "azi03.azi_file.azi03,   azi04.azi_file.azi04,",
#              "azi05.azi_file.azi05"
#CHI-B10044 mark --end--
   #CHI-B10044 add --start--
   LET g_sql = "oma01.oma_file.oma01,      oma02_1.type_file.chr3,", 
               "oma02_2.type_file.chr2,    oma02_3.type_file.chr2,",
               "oma09.oma_file.oma09,      oma211.oma_file.oma211,",
               "oma212.type_file.chr20,",   #FUN-B50018 add
               "oma171.oma_file.oma171,    oma042.oma_file.oma042,",
               "oma172.oma_file.oma172,    oma56x.oma_file.oma56x,",
               "oma56.oma_file.oma56,", 
               "omb15.omb_file.omb15,      omb12.omb_file.omb12,",
               "omb16.omb_file.omb16,      omb16_oma211.omb_file.omb16, ohb30.ohb_file.ohb30,", 
               "omb06.omb_file.omb06,      occ02.occ_file.occ02,", 
               "occ231_1.type_file.chr50,", 
               "zo041.zo_file.zo041,  zo042.zo_file.zo042,",
               "zo02.zo_file.zo02,      zo06.zo_file.zo06,",    
               "azi03.azi_file.azi03,      azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",     
               "i.type_file.num5,",
               "round.type_file.num5,", 
               "oma09_2.oma_file.oma09,",
               "oma211_2.oma_file.oma211,",
               "oma212_2.type_file.chr20,", #FUN-B50018 add
               "oma171_2.oma_file.oma171,",
               "oma172_2.oma_file.oma172,",
               "omb15_2.omb_file.omb15,",
               "omb12_2.omb_file.omb12,",
               "omb16_2.omb_file.omb16,",
               "omb16_oma211_2.omb_file.omb16,", 
               "ohb30_2.ohb_file.ohb30,",
               "omb06_2.omb_file.omb06,", 
               "oma09_3.oma_file.oma09,",
               "oma211_3.oma_file.oma211,",
               "oma212_3.type_file.chr20,",  #FUN-B50018
               "oma171_3.oma_file.oma171,",
               "oma172_3.oma_file.oma172,",
               "omb15_3.omb_file.omb15,",
               "omb12_3.omb_file.omb12,",
               "omb16_3.omb_file.omb16,",
               "omb16_oma211_3.omb_file.omb16,", 
               "ohb30_3.ohb_file.ohb30,",
               "omb06_3.omb_file.omb06,", 
               "oma09_4.oma_file.oma09,",
               "oma211_4.oma_file.oma211,",
               "oma212_4.type_file.chr20,", #FUN-B50018
               "oma171_4.oma_file.oma171,",
               "oma172_4.oma_file.oma172,",
               "omb15_4.omb_file.omb15,",
               "omb12_4.omb_file.omb12,",
               "omb16_4.omb_file.omb16,",
               "omb16_oma211_4.omb_file.omb16,", 
               "ohb30_4.ohb_file.ohb30,",
               "omb06_4.omb_file.omb06,", 
               "oma09_5.oma_file.oma09,",
               "oma211_5.oma_file.oma211,",
               "oma212_5.type_file.chr20,",  #FUN-B50018
               "oma171_5.oma_file.oma171,",
               "oma172_5.oma_file.oma172,",
               "omb15_5.omb_file.omb15,",
               "omb12_5.omb_file.omb12,",
               "omb16_5.omb_file.omb16,",
               "omb16_oma211_5.omb_file.omb16,", 
               "ohb30_5.ohb_file.ohb30,",
               "omb06_5.omb_file.omb06" 
   #CHI-B10044 add --end--
 
   LET l_table = cl_prt_temptable('axrg303',g_sql) CLIPPED
   IF l_table = -1 THEN 
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C10036 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add  #FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              #"        ?,?,?,?,?, ?)" #CHI-B10044 mark
              #CHI-B10044 add --start--
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    #FUN-B50018
              #CHI-B10044 add --end--
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C10036 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add   #FUN-C10036 mark
      EXIT PROGRAM
   END IF

  #CHI-B10044 add --start--
   DROP TABLE axrg303_tmp
   CREATE TEMP TABLE axrg303_tmp(
     oma171     LIKE oma_file.oma171,    
     oma09      LIKE oma_file.oma09,
     ohb30      LIKE ohb_file.ohb30,  
     omb06      LIKE omb_file.omb06,   
     omb12      LIKE omb_file.omb12,
     omb15      LIKE omb_file.omb15,
     omb16      LIKE omb_file.omb16,
     omb16_oma211  LIKE omb_file.omb16,
     oma211     LIKE oma_file.oma211,  
     oma212     LIKE type_file.chr20,  #FUN-B50018
     oma172     LIKE oma_file.oma172) 
  #CHI-B10044 add --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-C10036 add
   LET g_pdate    = g_today
   LET g_rlang    = g_lang 
   LET g_bgjob    = 'N' 
   LET g_copies   = '1'
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
   LET g_argv4=ARG_VAL(4)
   LET g_towhom = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.choice = ARG_VAL(8)  
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  
   IF cl_null(g_argv1) THEN
      CALL axrg303_tm(0,0)
   ELSE
      IF g_argv4='21' THEN
         LET tm.choice = '1'
      ELSE
         LET tm.choice = '2'
      END IF
      LET tm.wc= " oma01='",g_argv1,"' AND oma02='",g_argv2,"' AND oma68='",g_argv3,"'" 
      CALL axrg303()
      DROP TABLE axrg303_tmp    #CHI-B10044 add
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
   CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
END MAIN
 
FUNCTION axrg303_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW axrg303_w AT p_row,p_col WITH FORM "axr/42f/axrg303"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL           
   LET tm.choice='1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma01, oma02, oma68
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
      LET INT_FLAG = 0 CLOSE WINDOW r630_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.choice,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD choice
         IF tm.choice NOT MATCHES '[12]' THEN NEXT FIELD choice END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrg303_w 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrg303'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrg303','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",   
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",  
                         " '",g_template CLIPPED,"'", 
                         " '",g_rpt_name CLIPPED,"'" 
         CALL cl_cmdat('axrg303',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrg303_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrg303()
   ERROR ""
END WHILE
   CLOSE WINDOW axrg303_w
END FUNCTION
 
FUNCTION axrg303()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_chr        LIKE type_file.chr1,   
          l_za05    LIKE type_file.chr1000, 
          l_order    ARRAY[5] OF LIKE zaa_file.zaa08,     
          sr    RECORD
                 oma01  LIKE oma_file.oma01,    # 帳款日期
                 oma02  LIKE oma_file.oma02,    # 帳款日期
                 oma09  LIKE oma_file.oma09,    # 發票日期
                 oma211 LIKE oma_file.oma211,   # 稅    率
                 oma212 LIKE oma_file.oma212,   # 聯    式   #FUN-B50018
                 oma171 LIKE oma_file.oma171,   # 扣抵區分
                 oma042 LIKE oma_file.oma042,   # 廠商統一編號
                 oma172 LIKE oma_file.oma172,   # 課 稅 別
                 oma56x LIKE oma_file.oma56x,   # 稅額
                 oma56  LIKE oma_file.oma56,    #未稅金額 #CHI-B10044 add
                 omb15  LIKE omb_file.omb15,    # 單    價
                 omb12  LIKE omb_file.omb12,    # 數    量
                 omb16  LIKE omb_file.omb16,    # 金    額
                 omb16_oma211 LIKE omb_file.omb16, # 稅    額 #CHI-B10044 add
                 ohb30  LIKE ohb_file.ohb30,    # 原發票號碼
#                 omb04  LIKE omb_file.omb04,    # 品    名    #MOD-950249 
                 omb06  LIKE omb_file.omb06,    # 品    名   #MOD-950249  
                 occ02  LIKE occ_file.occ02,    # 全名(第一行)
                 occ231 LIKE occ_file.occ231,   # 地址(第一行)
                 zo041  LIKE zo_file.zo041,     # 地址
                 zo042  LIKE zo_file.zo042,     # 地址
                 zo02   LIKE zo_file.zo02,      # 公司全名  #MOD-730146 modify
                 zo06   LIKE zo_file.zo06,      # 統一編號
                 azi03  LIKE azi_file.azi03,    #
                 azi04  LIKE azi_file.azi04,    #
                 azi05  LIKE azi_file.azi05,    #     #CHI-B10044 add ,
                 oma21  LIKE oma_file.oma21     #稅別 #CHI-B10044 add
                END RECORD,                           #CHI-B10044 add ,
         #CHI-B10044 add --start--
          sr2   DYNAMIC ARRAY OF RECORD
                oma171     LIKE oma_file.oma171,    
                oma09      LIKE oma_file.oma09,
                ohb30      LIKE ohb_file.ohb30,  
                omb06      LIKE omb_file.omb06,   
                omb12      LIKE omb_file.omb12,
                omb15      LIKE omb_file.omb15,
                omb16      LIKE omb_file.omb16,
                omb16_oma211  LIKE omb_file.omb16,
                oma211      LIKE oma_file.oma211,  
                oma212     LIKE type_file.chr20,  #FUN-B50018
                oma172     LIKE oma_file.oma172  
            END RECORD,
            l_oma212      LIKE type_file.chr20,   #FUN-B50018
            n,i           LIKE type_file.num5,
            l_i           LIKE type_file.num5,   
            l_j           LIKE type_file.num5,   
            l_count       LIKE type_file.num5,   
            l_total       INTEGER,               
            l_axrg303_curs1_count  INTEGER       
           #CHI-B10044 add --end--
   DEFINE l_oma02_1  LIKE type_file.chr3       
   DEFINE l_oma02_2  LIKE type_file.chr2
   DEFINE l_oma02_3  LIKE type_file.chr2
   DEFINE l_oma09    LIKE oma_file.oma09    #CHI-B10044 add 
  #CHI-B10044 mark --start--
  #DEFINE l_oma09_1  LIKE type_file.chr3       
  #DEFINE l_oma09_2  LIKE type_file.chr2
  #DEFINE l_oma09_3  LIKE type_file.chr2
  #CHI-B10044 mark --end--
   DEFINE l_occ231_1 LIKE type_file.chr50   
   DEFINE l_oma171   LIKE type_file.chr1
   DEFINE l_oma01    LIKE oma_file.oma01
   DEFINE l_oma02_11 LIKE type_file.chr3      
   DEFINE l_oma02_21 LIKE type_file.chr2
   DEFINE l_oma02_31 LIKE type_file.chr2
   DEFINE l_oma042   LIKE oma_file.oma042
   DEFINE l_oma56x   LIKE oma_file.oma56x
   DEFINE l_occ02    LIKE occ_file.occ02
   DEFINE l_occ231_11 LIKE type_file.chr50   
   DEFINE l_zo041    LIKE zo_file.zo041
   DEFINE l_zo042    LIKE zo_file.zo042
   DEFINE l_zo02     LIKE zo_file.zo02       
   DEFINE l_zo06     LIKE zo_file.zo06 
   DEFINE l_n        LIKE type_file.num5,
          l_gec05    LIKE gec_file.gec05,
          l_oma21    LIKE oma_file.oma21,
          l_omb31    LIKE omb_file.omb31,
          l_omb32    LIKE omb_file.omb32,
          l_omb44    LIKE omb_file.omb44    #FUN-A60056    
   DEFINE l_round    LIKE type_file.num5   #CHI-B10044 add 一round有四聯，四聯為一round
 
     CALL cl_del_data(l_table)  
     DELETE FROM axrg303_tmp   #CHI-B10044 add  
     LET l_round = 0           #CHI-B10044 add   
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrg303'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
#    IF tm.choice = '1' THEN
        LET l_sql = "SELECT ",
#                    " oma01, oma02, oma09, oma211, oma171, ", #MOD-950249 
                    " oma01, oma02, '', oma211, oma212, oma171, ",   #MOD-950249  #FUN-B50018 add oma212
                    " oma042, oma172,oma56x,oma56,", #CHI-B10044 add oma56
#                    " omb15, omb12, omb16,'',omb04, ", #MOD-950249
                    " omb15, omb12, omb16,0,'',omb06, ",  #MOD-950249 #CHI-B10044 add 0
                    " occ02,occ231, ",
                    " zo041, zo042, zo02, zo06, ",    
                   #" azi03, azi04, azi05,omb31,omb32,oma21,omb44",    #FUN-A60056 add omb44 #CHI-B10044 mark
                    " azi03, azi04, azi05,oma21,omb31,omb32,omb44",    #CHI-B10044
                    " FROM omb_file, occ_file, zo_file,oma_file ",
                    " LEFT OUTER JOIN azi_file ON oma23=azi01  ",
                    " WHERE occ01 = oma68",
                   #"   AND oma00 = '21' ",   
                    "   AND oma01 = omb01 ",
                    "   AND omavoid = 'N' ",
                    "   AND ",tm.wc CLIPPED,
                    "   AND zo01 = '",g_lang,"'"
                   #" ORDER BY oma01 "   
     IF tm.choice = '1' THEN
        LET l_sql = l_sql CLIPPED," AND oma00 = '21' "
     ELSE
        LET l_sql = l_sql CLIPPED," AND oma00 = '22' "
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY oma01 "
     PREPARE axrg303_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM
     END IF
     DECLARE axrg303_curs1 CURSOR FOR axrg303_prepare1
 
    #CHI-B10044 mark --start--
    #   LET l_sql = "SELECT COUNT(*)",
    #               " FROM oma_file, omb_file,occ_file, zo_file,",
    #               " LEFT OUTER JOIN azi_file ON oma23=azi01  ",
    #               " WHERE occ01 = oma68",
    #              #"   AND oma00 = '21' ",
    #               "   AND oma01 = omb01 ",
    #               "   AND omavoid = 'N' ",
    #               "   AND ",tm.wc CLIPPED,
    #               "   AND zo01 = '",g_lang,"'"
    #IF tm.choice = '1' THEN
    #   LET l_sql = l_sql CLIPPED," AND oma00 = '21' "
    #ELSE
    #   LET l_sql = l_sql CLIPPED," AND oma00 = '22' "
    #END IF
    #PREPARE axrg303_prepare2 FROM l_sql
    #DECLARE axrg303_curs2 CURSOR FOR axrg303_prepare2
    #OPEN axrg303_curs2
    #FETCH axrg303_curs2 INTO l_n
    #LET g_count = 0 
    #LET g_cnt = 0 
    #CHI-B10044 mark --end--
     LET l_i = 0        #CHI-B10044 add   
     LET l_count = 0    #CHI-B10044 add 
    #FOREACH axrg303_curs1 INTO sr.*,l_omb31,l_omb32,l_oma21,l_omb44    #FUN-A60056 add omb44 #CHI-B10044 mark
     FOREACH axrg303_curs1 INTO sr.*,l_omb31,l_omb32,l_omb44    #CHI-B10044
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       #CHI-B10044 add --start--
       LET l_sql = "SELECT COUNT(*)",
                   " FROM oma_file",
                   " LEFT OUTER JOIN azi_file ON azi01=oma23  ",
                   " ,omb_file,occ_file, zo_file",
                   " WHERE occ01 = oma68",
                   "   AND oma01 = omb01 ",
                   "   AND omavoid = 'N' ",
                   "   AND oma01 = '",sr.oma01,"'",
                   "   AND ",tm.wc CLIPPED,
                   "   AND zo01 = '",g_lang,"'"
       IF tm.choice = '1' THEN
          LET l_sql = l_sql CLIPPED," AND oma00 = '21' "
       ELSE
          LET l_sql = l_sql CLIPPED," AND oma00 = '22' "
       END IF

       PREPARE axrg303_prepare2 FROM l_sql
       DECLARE axrg303_curs2 CURSOR FOR axrg303_prepare2
       OPEN axrg303_curs2
       FETCH axrg303_curs2 INTO l_total
       
       LET l_axrg303_curs1_count = l_axrg303_curs1_count + 1
       LET l_count = l_count + 1
       IF l_count > 5 THEN
          LET l_count = 1
       END IF
       #CHI-B10044 add --end--

      #FUN-A60056--mod--str--
      #SELECT ohb30 INTO sr.ohb30 FROM ohb_file
      # WHERE ohb01 = l_omb31
      #   AND ohb03 = l_omb32
       LET g_sql = "SELECT ohb30 FROM ",cl_get_target_table(l_omb44,'ohb_file'),
                   " WHERE ohb01 = '",l_omb31,"'",
                   "   AND ohb03 = '",l_omb32,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql
       PREPARE sel_ohb30 FROM g_sql
       EXECUTE sel_ohb30 INTO sr.ohb30
      #FUN-A60056--mod--end
       SELECT oma09 INTO sr.oma09 FROM oma_file WHERE oma10=sr.ohb30 AND oma00 MATCHES '1*' #MOD-950249                             
       #-----MOD-B10244---------
       IF cl_null(sr.oma09) THEN
          DECLARE amd05_cur SCROLL CURSOR FOR
            SELECT amd05 FROM amd_file
              WHERE amd03 = sr.ohb30
               ORDER BY amd05 DESC
          OPEN amd05_cur
          FETCH LAST amd05_cur INTO sr.oma09
       END IF 
       #-----END MOD-B10244-----
       IF sr.ohb30 IS NULL THEN 
          LET sr.oma09='' 
          LET sr.oma171=NULL
       END IF
       
 
       IF cl_null(l_oma01) THEN
          LET l_oma01 = sr.oma01
       END IF
      #CHI-B10044 mark --start--
      #IF l_oma01 <> sr.oma01 THEN
      #   IF g_count < 5 THEN
      #      FOR i = g_count+1 to 5
      #         LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
      #                     " VALUES('",l_oma01,"','",l_oma02_11,"','",l_oma02_21,
      #                     "','",l_oma02_31,"','','','','','','",l_oma042,"',' ',",
      #                     l_oma56x,",'','','','','','",l_occ02,"','",l_occ231_11,
      #                     "','",l_zo041,"','",l_zo042,"','",l_zo02,  
      #                     "','",l_zo06,"',",sr.azi03,",",sr.azi04,",",sr.azi05,")"
      #         PREPARE insert_prep1 FROM g_sql
      #         IF STATUS THEN
      #            CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
      #         END IF
      #         EXECUTE insert_prep1
      #      END FOR
      #      LET g_count = 0
      #   END IF
      #END IF
      #LET l_oma01 = sr.oma01
      #CHI-B10044 mark --end--
 
        
       DECLARE g303_sel_apk2 CURSOR FOR
        SELECT gec05 FROM oma_file,gec_file   
        #WHERE gec01 = l_oma21  #CHI-B10044 mark
         WHERE gec01 = sr.oma21 #CHI-B10044
           AND gec011 = '2'
       LET l_gec05=''
       LET l_oma09 = ' '     #CHI-B10044 add
       OPEN g303_sel_apk2
       FETCH g303_sel_apk2 INTO l_gec05
       IF sr.ohb30 IS NULL THEN LET l_gec05='' END IF
       LET l_oma02_1 = (YEAR(sr.oma02)-1911) USING '###' CLIPPED
       LET l_oma02_2 = MONTH(sr.oma02) USING '&&' CLIPPED
       LET l_oma02_3 = DAY(sr.oma02)  USING '&&' CLIPPED
       LET l_oma09 = sr.oma09 #CHI-B10044 add
      #CHI-B10044 mark --start--
      #LET l_oma09_1 = (YEAR(sr.oma09)-1911) USING '###' CLIPPED
      #LET l_oma09_2 = MONTH(sr.oma09) USING '&&' CLIPPED
      #LET l_oma09_3 = DAY(sr.oma09) USING '&&' CLIPPED
      #CHI-B10044 mark --end--
       LET l_occ231_1 = sr.occ231   
#       LET sr.omb04 = sr.omb04[1,16]      #MOD-950249 
       LET sr.omb06 = sr.omb06[1,16]   #MOD-950249  
       LET sr.omb12 = sr.omb12 USING '#####&.&'
       IF cl_null(sr.oma042) THEN LET sr.oma042=' ' END IF   

#CHI-B10044 add --start--
       LET sr.omb16_oma211 = sr.omb16 * sr.oma211 / 100
     
       #str FUN-B50018 add
       CASE sr.oma212
          WHEN '2'  #二
             LET l_oma212=cl_getmsg('axr-835',g_lang)
          WHEN '3'  #三
             LET l_oma212=cl_getmsg('axr-836',g_lang)
          OTHERWISE
             LET l_oma212=sr.oma212
       END CASE
      #end FUN-B50018 add

       INSERT INTO axrg303_tmp VALUES(sr.oma171,sr.oma09,sr.ohb30,sr.omb06,sr.omb12,sr.omb15,
                                      sr.omb16,sr.omb16_oma211,sr.oma211,l_oma212,sr.oma172)    #FUN-B50018

       IF l_count = 5 THEN   
          LET l_j = 1
          DECLARE axrg303_curs CURSOR FOR SELECT * FROM axrg303_tmp
          FOREACH axrg303_curs INTO sr2[l_j].*
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               LET l_j = l_j + 1
          END FOREACH

          LET l_round = l_round + 1  
          IF l_total <> l_axrg303_curs1_count THEN 
             LET sr.oma56 = ''        
###GENGRE###             LET sr.oma56x = ''      
          END IF    
          FOR l_i = 1 TO 4
                EXECUTE insert_prep  USING
                        sr.oma01,      l_oma02_1,     l_oma02_2,    l_oma02_3,     sr2[1].oma09,
                        sr2[1].oma211, sr2[1].oma212, sr.oma171,     sr.oma042,    sr.oma172,     sr.oma56x,      #FUN-B50018 add oma212 
                        sr.oma56,      sr2[1].omb15,  sr2[1].omb12, sr2[1].omb16,  sr2[1].omb16_oma211,  
                        sr2[1].ohb30,     
                        sr2[1].omb06,  sr.occ02,      l_occ231_1,      
                        sr.zo041,      sr.zo042,      sr.zo02,      sr.zo06,       sr.azi03,
                        sr.azi04,      sr.azi05,      l_i,          l_round,   
                        sr2[2].oma09 , sr2[2].oma211, sr2[2].oma212, sr2[2].oma171,       sr2[2].oma172, sr2[2].omb15,  #FUN-B50018 add oma212
                        sr2[2].omb12 , sr2[2].omb16,  sr2[2].omb16_oma211, sr2[2].ohb30,  sr2[2].omb06, 
                        sr2[3].oma09 , sr2[3].oma211, sr2[3].oma212, sr2[3].oma171,       sr2[3].oma172, sr2[3].omb15,  #FUN-B50018 add oma212
                        sr2[3].omb12 , sr2[3].omb16,  sr2[3].omb16_oma211, sr2[3].ohb30,  sr2[3].omb06, 
                        sr2[4].oma09 , sr2[4].oma211, sr2[4].oma212, sr2[4].oma171,       sr2[4].oma172, sr2[4].omb15,  #FUN-B50018 add oma212
                        sr2[4].omb12 , sr2[4].omb16,  sr2[4].omb16_oma211, sr2[4].ohb30,  sr2[4].omb06,  
                        sr2[5].oma09 , sr2[5].oma211, sr2[5].oma212, sr2[5].oma171,       sr2[5].oma172, sr2[5].omb15,  #FUN-B50018 add oma212
                        sr2[5].omb12 , sr2[5].omb16,  sr2[5].omb16_oma211, sr2[5].ohb30,  sr2[5].omb06    
          END FOR
          FOR i = 1 TO 5
              INITIALIZE sr2[i].* TO NULL
          END FOR
          IF l_total = l_axrg303_curs1_count THEN   
             LET l_axrg303_curs1_count = 0  
          END IF                                   
          LET l_count = 0
          DELETE FROM axrg303_tmp
       ELSE
          IF l_total = l_axrg303_curs1_count  THEN
             WHILE l_count > 0 
                LET l_j = 1
                DECLARE axrg303_curs3 CURSOR FOR SELECT * FROM axrg303_tmp
                FOREACH axrg303_curs3 INTO sr2[l_j].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_j = l_j + 1
                END FOREACH
 
                LET l_round = l_round + 1
                FOR l_i = 1 TO 4
                   EXECUTE insert_prep  USING
                           sr.oma01,      l_oma02_1,     l_oma02_2,    l_oma02_3,     sr2[1].oma09,
                           sr2[1].oma211, sr2[1].oma212,  sr.oma171,     sr.oma042,    sr.oma172,     sr.oma56x,       
                           sr.oma56,      sr2[1].omb15,  sr2[1].omb12, sr2[1].omb16,  sr2[1].omb16_oma211,  
                           sr2[1].ohb30,     
                           sr2[1].omb06,  sr.occ02,      l_occ231_1,      
                           sr.zo041,      sr.zo042,      sr.zo02,      sr.zo06,       sr.azi03,
                           sr.azi04,      sr.azi05,      l_i,          l_round,   
                           sr2[2].oma09 , sr2[2].oma211, sr2[2].oma212, sr2[2].oma171,       sr2[2].oma172, sr2[2].omb15,
                           sr2[2].omb12 , sr2[2].omb16,  sr2[2].omb16_oma211, sr2[2].ohb30,  sr2[2].omb06, 
                           sr2[3].oma09 , sr2[3].oma211,  sr2[3].oma212, sr2[3].oma171,       sr2[3].oma172, sr2[3].omb15,
                           sr2[3].omb12 , sr2[3].omb16,  sr2[3].omb16_oma211, sr2[3].ohb30,  sr2[3].omb06, 
                           sr2[4].oma09 , sr2[4].oma211,  sr2[4].oma212, sr2[4].oma171,       sr2[4].oma172, sr2[4].omb15,
                           sr2[4].omb12 , sr2[4].omb16,  sr2[4].omb16_oma211, sr2[4].ohb30,  sr2[4].omb06,  
                           sr2[5].oma09 , sr2[5].oma211,  sr2[5].oma212, sr2[5].oma171,       sr2[5].oma172, sr2[5].omb15,
                           sr2[5].omb12 , sr2[5].omb16,  sr2[5].omb16_oma211, sr2[5].ohb30,  sr2[5].omb06    
                END FOR
                FOR i = 1 TO 5
                    INITIALIZE sr2[i].* TO NULL
                END FOR
                LET l_axrg303_curs1_count = l_axrg303_curs1_count - 5   
               LET l_axrg303_curs1_count = 0
               LET l_count = 0
               DELETE FROM axrg303_tmp
             END WHILE 
          END IF
       END IF
       LET l_oma01 =sr.oma01
#CHI-B10044 add --end--
 
#CHI-B10044 mark --start--
#      EXECUTE insert_prep USING
#         sr.oma01, l_oma02_1,l_oma02_2,l_oma02_3,l_oma09_1,
#         l_oma09_2,l_oma09_3,sr.oma211, l_gec05,  sr.oma042,  
#         sr.oma172, sr.oma56x, sr.omb15, sr.omb12, sr.omb16,   
#        #sr.ohb30, sr.omb04, sr.occ02,l_occ231_1,         # MOD-950249 
#         sr.ohb30, sr.omb06, sr.occ02,l_occ231_1,        # MOD-950249      
#         sr.zo041, sr.zo042, sr.zo02,  sr.zo06,  sr.azi03,
#         sr.azi04, sr.azi05    
#
#      LET g_count = g_count+1
#      LET g_cnt = g_cnt+1
#      LET l_oma02_11 = l_oma02_1
#      LET l_oma02_21 = l_oma02_2
#      LET l_oma02_31 = l_oma02_3
#      LET l_oma042 = sr.oma042
#      LET l_oma56x = sr.oma56x
#      LET l_occ02 = sr.occ02
#      LET l_occ231_11 = l_occ231_1
#      LET l_zo041 = sr.zo041
#      LET l_zo042 = sr.zo042
#      LET l_zo02 = sr.zo02             
#      LET l_zo06 = sr.zo06
#
#      IF g_cnt = l_n THEN
#         IF g_count < 5 THEN
#            FOR i = g_count+1 to 5
#               LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
#                           " VALUES('",l_oma01,"','",l_oma02_11,"','",l_oma02_21,
#                           "','",l_oma02_31,"','','','','','','",l_oma042,"',' ',",
#                           l_oma56x,",'','','','','','",l_occ02,"','",l_occ231_11,
#                           "','",l_zo041,"','",l_zo042,"','",l_zo02,      
#                           "','",l_zo06,"',",sr.azi03,",",sr.azi04,",",sr.azi05,")"
#               PREPARE insert_prep2 FROM g_sql
#               IF STATUS THEN
#                  CALL cl_err('insert_prep2:',status,1) EXIT PROGRAM
#               END IF
#               EXECUTE insert_prep2
#            END FOR
#            LET g_count = 0
#         END IF
#      END IF
#CHI-B10044 mark --end--
 
     END FOREACH
 
 
###GENGRE###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('axrg303','axrg303',l_sql,'')
    CALL axrg303_grdata()    ###GENGRE###
 
#       CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B90058 mark
#       CALL cl_gre_drop_temptable(l_table)                #FUN-B90058 mark
END FUNCTION
#FUN-910091

###GENGRE###START
FUNCTION axrg303_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axrg303")
        IF handler IS NOT NULL THEN
            START REPORT axrg303_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oma01,i"           #FUN-B50018
          
            DECLARE axrg303_datacur1 CURSOR FROM l_sql
            FOREACH axrg303_datacur1 INTO sr1.*
                OUTPUT TO REPORT axrg303_rep(sr1.*)
            END FOREACH
            FINISH REPORT axrg303_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axrg303_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018--------add-------str----------------
    DEFINE l_oma01_round    STRING
    DEFINE l_round          STRING
    DEFINE l_i              LIKE type_file.num5
    DEFINE l_apb11_1        STRING
    DEFINE l_apb11_11       STRING
    DEFINE l_ohb30          STRING
    DEFINE l_apb11_2        STRING
    DEFINE l_apb11_22       STRING
    DEFINE l_ohb30_2        STRING
    DEFINE l_apb11_3        STRING
    DEFINE l_apb11_33       STRING
    DEFINE l_ohb30_3        STRING
    DEFINE l_apb11_4        STRING
    DEFINE l_apb11_44       STRING
    DEFINE l_ohb30_4        STRING
    DEFINE l_apb11_5        STRING
    DEFINE l_apb11_55       STRING
    DEFINE l_ohb30_5        STRING
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
    DEFINE l_omb12_fmt      STRING
    DEFINE l_omb15_fmt      STRING
    DEFINE l_omb16_fmt      STRING
    DEFINE l_oma56_fmt      STRING
    DEFINE l_oma56x_fmt     STRING
    #FUN-B50018--------add-------end----------------

    
    ORDER EXTERNAL BY sr1.oma01,sr1.round
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oma01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.round

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B50018--------add-------str----------------
            LET l_omb15_fmt = cl_gr_numfmt('omb_file','omb15',sr1.azi03)
            PRINTX l_omb15_fmt
            LET l_omb16_fmt = cl_gr_numfmt('omb_file','omb16',sr1.azi04)
            PRINTX l_omb16_fmt
            LET l_oma56_fmt = cl_gr_numfmt('oma_file','oma56',sr1.azi04)
            PRINTX l_oma56_fmt
            LET l_oma56x_fmt = cl_gr_numfmt('oma_file','oma56x',sr1.azi04)
            PRINTX l_oma56x_fmt
            IF cl_null(sr1.oma172) THEN 
               LET l_display = "N"
            ELSE
               LET l_display = "Y"
            END IF
            PRINTX l_display
            IF cl_null(sr1.oma172_2) THEN
               LET l_display1 = "N"
            ELSE
               LET l_display1 = "Y"
            END IF
            PRINTX l_display1
            IF cl_null(sr1.oma172_3) THEN
               LET l_display2 = "N"
            ELSE
               LET l_display2 = "Y"
            END IF
            PRINTX l_display2
            IF cl_null(sr1.oma172_4) THEN
               LET l_display3 = "N"
            ELSE
               LET l_display3 = "Y"
            END IF
            PRINTX l_display3
            IF cl_null(sr1.oma172_5) THEN
               LET l_display4 = "N"
            ELSE
               LET l_display4 = "Y"
            END IF
            PRINTX l_display4
            LET l_year = (YEAR(sr1.oma09)-1911) USING '###' CLIPPED
            LET l_month = MONTH(sr1.oma09) USING '&&' CLIPPED
            LET l_day = DAY(sr1.oma09) USING '&&' CLIPPED
            PRINTX l_year
            PRINTX l_month
            PRINTX l_day

            LET l_year_2 = (YEAR(sr1.oma09_2)-1911) USING '###' CLIPPED
            LET l_month_2 = MONTH(sr1.oma09_2) USING '&&' CLIPPED
            LET l_day_2 = DAY(sr1.oma09_2) USING '&&' CLIPPED
            PRINTX l_year_2
            PRINTX l_month_2
            PRINTX l_day_2

            LET l_year_3 = (YEAR(sr1.oma09_3)-1911) USING '###' CLIPPED
            LET l_month_3 = MONTH(sr1.oma09_3) USING '&&' CLIPPED
            LET l_day_3 = DAY(sr1.oma09_3) USING '&&' CLIPPED
            PRINTX l_year_3
            PRINTX l_month_3
            PRINTX l_day_3
 

            LET l_year_4 = (YEAR(sr1.oma09_4)-1911) USING '###' CLIPPED
            LET l_month_4 = MONTH(sr1.oma09_4) USING '&&' CLIPPED
            LET l_day_4 = DAY(sr1.oma09_4) USING '&&' CLIPPED
            PRINTX l_year_4
            PRINTX l_month_4
            PRINTX l_day_4

            LET l_year_5 = (YEAR(sr1.oma09_5)-1911) USING '###' CLIPPED
            LET l_month_5 = MONTH(sr1.oma09_5) USING '&&' CLIPPED
            LET l_day_5 = DAY(sr1.oma09_5) USING '&&' CLIPPED
            PRINTX l_year_5
            PRINTX l_month_5
            PRINTX l_day_5

            LET l_round = sr1.round
            LET l_oma01_round = sr1.oma01,l_round
            PRINTX l_oma01_round

            LET l_apb11_1 = ' '
            IF NOT cl_null(sr1.ohb30) THEN
               LET l_apb11_1 = sr1.ohb30[1,2] 
            END IF
            PRINTX l_apb11_1
   
            LET l_apb11_11 = ' '
            IF NOT cl_null(sr1.ohb30) THEN
               LET l_ohb30 = sr1.ohb30
               LET l_i = l_ohb30.getlength()
               IF l_i > 8 THEN   
                 #LET l_apb11_11 = sr1.ohb30[l_i-8,l_i]   #MOD-D20100 mark
                  LET l_apb11_11 = sr1.ohb30[l_i-7,l_i]   #MOD-D20100
               END IF 
            END IF
            PRINTX l_apb11_11

            LET l_apb11_2 = ' '
            IF NOT cl_null(sr1.ohb30_2) THEN
               LET l_apb11_2 = sr1.ohb30_2[1,2]
            END IF
            PRINTX l_apb11_2

            LET l_apb11_22 = ' '
            IF NOT cl_null(sr1.ohb30_2) THEN
               LET l_ohb30_2 = sr1.ohb30_2
               LET l_i = l_ohb30_2.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_22 = sr1.ohb30_2[l_i-8,l_i]
               END IF  
            END IF
            PRINTX l_apb11_22

            LET l_apb11_3 = ' '
            IF NOT cl_null(sr1.ohb30_3) THEN
               LET l_apb11_3 = sr1.ohb30_3[1,2]
            END IF
            PRINTX l_apb11_3

            LET l_apb11_33 = ' '
            IF NOT cl_null(sr1.ohb30_3) THEN
               LET l_ohb30_3 = sr1.ohb30_3
               LET l_i = l_ohb30_3.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_33 = sr1.ohb30_3[l_i-8,l_i]
               END IF
            END IF
            PRINTX l_apb11_33

            LET l_apb11_4 = ' '
            IF NOT cl_null(sr1.ohb30_4) THEN
               LET l_apb11_4 = sr1.ohb30_4[1,2]
            END IF
            PRINTX l_apb11_4

            LET l_apb11_44 = ' '
            IF NOT cl_null(sr1.ohb30_4) THEN
               LET l_ohb30_4 = sr1.ohb30_4
               LET l_i = l_ohb30_4.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_44 = sr1.ohb30_4[l_i-8,l_i]
               END IF
            END IF
            PRINTX l_apb11_44

            LET l_apb11_5 = ' '
            IF NOT cl_null(sr1.ohb30_5) THEN
               LET l_apb11_5 = sr1.ohb30_5[1,2]
            END IF
            PRINTX l_apb11_5

            LET l_apb11_55 = ' '
            IF NOT cl_null(sr1.ohb30_5) THEN
               LET l_ohb30_5 = sr1.ohb30_5
               LET l_i = l_ohb30_5.getlength()
               IF l_i > 8 THEN   
                  LET l_apb11_55 = sr1.ohb30_5[l_i-8,l_i]
               END IF
            END IF
            PRINTX l_apb11_55
            #FUN-B50018--------add-------end----------------


            PRINTX sr1.*

        AFTER GROUP OF sr1.oma01
        AFTER GROUP OF sr1.round

        
        ON LAST ROW

END REPORT
###GENGRE###END
