# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr303.4gl
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
# Modify.........: No:FUN-B40097 11/06/02 By chenyinf \t特殊字段影響CR轉gr的過程中出錯
# Modify.........: No:MOD-B70139 11/07/14 By Sarah 增加抓取oma212
# Modify.........: No.FUN-B90041 11/09/05 By minpp 程序撰写规范修改 
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.TQC-C10039 12/01/17 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-C20064 12/02/09 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片删除
# Modify.........: No:MOD-C60048 12/06/08 By Elise 明細資料的稅額總和不等於總稅額
# Modify.........: No:TQC-C60088 12/06/11 By lujh “幫助”按鈕顯示為灰色

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
           #wc      LIKE type_file.chr1000,        # Where condition  #MOD-C60048 mark
            wc      STRING,            # MOD-C60048
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
  
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
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
   LET g_sql = "oma01.oma_file.oma01,    oma02_1.type_file.chr3,", 
               "oma02_2.type_file.chr2,  oma02_3.type_file.chr2,",
               "oma09.oma_file.oma09,    oma211.oma_file.oma211,",
               "oma212.type_file.chr20,",   #MOD-B70139 add
               "oma171.oma_file.oma171,  oma042.oma_file.oma042,",
               "oma172.oma_file.oma172,  oma56x.oma_file.oma56x,",
               "oma56.oma_file.oma56,    omb15.omb_file.omb15,",
               "omb12.omb_file.omb12,    omb16.omb_file.omb16,",
               "omb16_oma211.omb_file.omb16, ohb30.ohb_file.ohb30,", 
               "omb06.omb_file.omb06,    occ02.occ_file.occ02,",
               "occ231_1.type_file.chr50,zo041.zo_file.zo041,", 
               "zo042.zo_file.zo042,     zo02.zo_file.zo02,", 
               "zo06.zo_file.zo06,       azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,  azi05.azi_file.azi05,",    
               "i.type_file.num5,        round.type_file.num5,",
               "oma09_2.oma_file.oma09,  oma211_2.oma_file.oma211,",
               "oma212_2.type_file.chr20,",   #MOD-B70139 add
               "oma171_2.oma_file.oma171,oma172_2.oma_file.oma172,",
               "omb15_2.omb_file.omb15,  omb12_2.omb_file.omb12,",
               "omb16_2.omb_file.omb16,  omb16_oma211_2.omb_file.omb16,",
               "ohb30_2.ohb_file.ohb30,  omb06_2.omb_file.omb06,",
               "oma09_3.oma_file.oma09,  oma211_3.oma_file.oma211,",
               "oma212_3.type_file.chr20,",   #MOD-B70139 add
               "oma171_3.oma_file.oma171,oma172_3.oma_file.oma172,",
               "omb15_3.omb_file.omb15,  omb12_3.omb_file.omb12,",
               "omb16_3.omb_file.omb16,  omb16_oma211_3.omb_file.omb16,",
               "ohb30_3.ohb_file.ohb30,  omb06_3.omb_file.omb06,",
               "oma09_4.oma_file.oma09,  oma211_4.oma_file.oma211,",
               "oma212_4.type_file.chr20,",   #MOD-B70139 add
               "oma171_4.oma_file.oma171,oma172_4.oma_file.oma172,",
               "omb15_4.omb_file.omb15,  omb12_4.omb_file.omb12,",
               "omb16_4.omb_file.omb16,  omb16_oma211_4.omb_file.omb16,",
               "ohb30_4.ohb_file.ohb30,  omb06_4.omb_file.omb06,",
               "oma09_5.oma_file.oma09,  oma211_5.oma_file.oma211,",
               "oma212_5.type_file.chr20,",   #MOD-B70139 add
               "oma171_5.oma_file.oma171,oma172_5.oma_file.oma172,",
               "omb15_5.omb_file.omb15,  omb12_5.omb_file.omb12,",
               "omb16_5.omb_file.omb16,  omb16_oma211_5.omb_file.omb16,",
               "ohb30_5.ohb_file.ohb30,  omb06_5.omb_file.omb06"
#              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039 #MOD-C20064 Mark TQC-C10039
#              "sign_show.type_file.chr1,sign_str.type_file.chr1000"    #是否顯示簽核資料(Y/N)  #TQC-C10039 #MOD-C20064 Mark TQC-C10039
   #CHI-B10044 add --end--
 
   LET l_table = cl_prt_temptable('axrr303',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              #"        ?,?,?,?,?, ?)" #CHI-B10044 mark
              #CHI-B10044 add --start--
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
#               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"   #MOD-B70139 add 5? #TQC-C10039 add 4?  #MOD-C20064 Mark TQC-C10039
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   #MOD-B70139 add 5?  
              #CHI-B10044 add --end--
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

  #CHI-B10044 add --start--
   DROP TABLE axrr303_tmp
   CREATE TEMP TABLE axrr303_tmp(
     oma171     LIKE oma_file.oma171,
     oma09      LIKE oma_file.oma09,
     ohb30      LIKE ohb_file.ohb30,
     omb06      LIKE omb_file.omb06,
     omb12      LIKE omb_file.omb12,
     omb15      LIKE omb_file.omb15,
     omb16      LIKE omb_file.omb16,
     omb16_oma211  LIKE omb_file.omb16,
     oma211     LIKE oma_file.oma211,
     oma212     LIKE type_file.chr20,   #MOD-B70139 add
     oma172     LIKE oma_file.oma172)
  #CHI-B10044 add --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
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
      CALL axrr303_tm(0,0)
   ELSE
      IF g_argv4='21' THEN
         LET tm.choice = '1'
      ELSE
         LET tm.choice = '2'
      END IF
      LET tm.wc= " oma01='",g_argv1,"' AND oma02='",g_argv2,"' AND oma68='",g_argv3,"'" 
      CALL axrr303()
      DROP TABLE axrr303_tmp    #CHI-B10044 add
   END IF
   CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
END MAIN
 
FUNCTION axrr303_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW axrr303_w AT p_row,p_col WITH FORM "axr/42f/axrr303"
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

      ON ACTION help          #TQC-C60088
         CALL cl_show_help()  #TQC-C60088
 
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
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
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

      ON ACTION help          #TQC-C60088
         CALL cl_show_help()  #TQC-C60088
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr303_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr303'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr303','9031',1)
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
         CALL cl_cmdat('axrr303',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr303_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr303()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr303_w
END FUNCTION
 
FUNCTION axrr303()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)  #MOD-C60048 mark
          l_sql     STRING,                       # MOD-C60048
          l_chr     LIKE type_file.chr1,   
          l_za05    LIKE type_file.chr1000, 
          l_order   ARRAY[5] OF LIKE zaa_file.zaa08,     
          sr    RECORD
                 oma01  LIKE oma_file.oma01,    # 帳款日期
                 oma02  LIKE oma_file.oma02,    # 帳款日期
                 oma09  LIKE oma_file.oma09,    # 發票日期
                 oma211 LIKE oma_file.oma211,   # 稅    率
                 oma212 LIKE oma_file.oma212,   # 聯    式   #MOD-B70139 add
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
                oma211     LIKE oma_file.oma211,  
                oma212     LIKE type_file.chr20,    #MOD-B70139 add 
                oma172     LIKE oma_file.oma172  
            END RECORD,
            l_oma212      LIKE type_file.chr20,     #MOD-B70139 add 
            n,i           LIKE type_file.num5,
            l_i           LIKE type_file.num5,   
            l_j           LIKE type_file.num5,   
            l_count       LIKE type_file.num5,   
            l_total       INTEGER,               
            l_axrr303_curs1_count  INTEGER       
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
#   DEFINE l_img_blob     LIKE type_file.blob    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
 
     CALL cl_del_data(l_table)  
#     LOCATE l_img_blob IN MEMORY    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
     DELETE FROM axrr303_tmp   #CHI-B10044 add  
     LET l_round = 0           #CHI-B10044 add   
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrr303'
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
                    " oma01, oma02, '', oma211, oma212, oma171, ",   #MOD-950249   #MOD-B70139 add oma212
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
     PREPARE axrr303_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
        EXIT PROGRAM
     END IF
     DECLARE axrr303_curs1 CURSOR FOR axrr303_prepare1
 
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
    #PREPARE axrr303_prepare2 FROM l_sql
    #DECLARE axrr303_curs2 CURSOR FOR axrr303_prepare2
    #OPEN axrr303_curs2
    #FETCH axrr303_curs2 INTO l_n
    #LET g_count = 0 
    #LET g_cnt = 0 
    #CHI-B10044 mark --end--
     LET l_i = 0        #CHI-B10044 add   
     LET l_count = 0    #CHI-B10044 add 
    #FOREACH axrr303_curs1 INTO sr.*,l_omb31,l_omb32,l_oma21,l_omb44    #FUN-A60056 add omb44 #CHI-B10044 mark
     FOREACH axrr303_curs1 INTO sr.*,l_omb31,l_omb32,l_omb44    #CHI-B10044
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

       PREPARE axrr303_prepare2 FROM l_sql
       DECLARE axrr303_curs2 CURSOR FOR axrr303_prepare2
       OPEN axrr303_curs2
       FETCH axrr303_curs2 INTO l_total
       
       LET l_axrr303_curs1_count = l_axrr303_curs1_count + 1
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
 
        
       DECLARE r303_sel_apk2 CURSOR FOR
        SELECT gec05 FROM oma_file,gec_file   
        #WHERE gec01 = l_oma21  #CHI-B10044 mark
         WHERE gec01 = sr.oma21 #CHI-B10044
           AND gec011 = '2'
       LET l_gec05=''
       LET l_oma09 = ' '     #CHI-B10044 add
       OPEN r303_sel_apk2
       FETCH r303_sel_apk2 INTO l_gec05
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
      #MOD-C60048---S---
       IF l_total = 1 AND l_total = l_axrr303_curs1_count THEN
          LET sr.omb16_oma211 = sr.oma56x
       ELSE
          LET sr.omb16_oma211 = sr.omb16 * sr.oma211 / 100
       END IF
      #MOD-C60048---E---
     
      #str MOD-B70139 add
       CASE sr.oma212
          WHEN '2'  #二
             LET l_oma212=cl_getmsg('axr-835',g_lang)
          WHEN '3'  #三
             LET l_oma212=cl_getmsg('axr-836',g_lang)
          OTHERWISE
             LET l_oma212=sr.oma212
       END CASE
      #end MOD-B70139 add

       INSERT INTO axrr303_tmp VALUES(sr.oma171,sr.oma09,sr.ohb30,sr.omb06,sr.omb12,sr.omb15,
                                      sr.omb16,sr.omb16_oma211,sr.oma211,l_oma212,sr.oma172)  #MOD-B70139 add l_oma212

       IF l_count = 5 THEN   
          LET l_j = 1
          DECLARE axrr303_curs CURSOR FOR SELECT * FROM axrr303_tmp
          FOREACH axrr303_curs INTO sr2[l_j].*
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               LET l_j = l_j + 1
          END FOREACH

          LET l_round = l_round + 1  
          IF l_total <> l_axrr303_curs1_count THEN 
             LET sr.oma56 = ''        
             LET sr.oma56x = ''      
          END IF    
          FOR l_i = 1 TO 4
             EXECUTE insert_prep  USING
                sr.oma01,      l_oma02_1,     l_oma02_2,    l_oma02_3,
                sr2[1].oma09,  sr2[1].oma211, sr2[1].oma212,sr.oma171,                                          #MOD-B70139 add oma212
                sr.oma042,     sr.oma172,     sr.oma56x,    sr.oma56,  sr2[1].omb15,
                sr2[1].omb12,  sr2[1].omb16,  sr2[1].omb16_oma211, sr2[1].ohb30,  sr2[1].omb06, 
                sr.occ02,      l_occ231_1,    sr.zo041,     sr.zo042,  sr.zo02,   sr.zo06,
                sr.azi03,      sr.azi04,      sr.azi05,     l_i,       l_round,
                sr2[2].oma09 , sr2[2].oma211, sr2[2].oma212,       sr2[2].oma171, sr2[2].oma172, sr2[2].omb15,  #MOD-B70139 add oma212
                sr2[2].omb12 , sr2[2].omb16,  sr2[2].omb16_oma211, sr2[2].ohb30,  sr2[2].omb06, 
                sr2[3].oma09 , sr2[3].oma211, sr2[3].oma212,       sr2[3].oma171, sr2[3].oma172, sr2[3].omb15,  #MOD-B70139 add oma212
                sr2[3].omb12 , sr2[3].omb16,  sr2[3].omb16_oma211, sr2[3].ohb30,  sr2[3].omb06, 
                sr2[4].oma09 , sr2[4].oma211, sr2[4].oma212,       sr2[4].oma171, sr2[4].oma172, sr2[4].omb15,  #MOD-B70139 add oma212
                sr2[4].omb12 , sr2[4].omb16,  sr2[4].omb16_oma211, sr2[4].ohb30,  sr2[4].omb06,  
                sr2[5].oma09 , sr2[5].oma211, sr2[5].oma212,       sr2[5].oma171, sr2[5].oma172, sr2[5].omb15,  #MOD-B70139 add oma212
                sr2[5].omb12 , sr2[5].omb16,  sr2[5].omb16_oma211, sr2[5].ohb30,  sr2[5].omb06    
          END FOR
          FOR i = 1 TO 5
              INITIALIZE sr2[i].* TO NULL
          END FOR
          IF l_total = l_axrr303_curs1_count THEN   
             LET l_axrr303_curs1_count = 0  
          END IF                                   
          LET l_count = 0
          DELETE FROM axrr303_tmp
       ELSE
          IF l_total = l_axrr303_curs1_count  THEN
             WHILE l_count > 0 
                LET l_j = 1
                DECLARE axrr303_curs3 CURSOR FOR SELECT * FROM axrr303_tmp
                FOREACH axrr303_curs3 INTO sr2[l_j].*
                   IF SQLCA.sqlcode THEN
                      EXIT FOREACH
                   END IF
                   LET l_j = l_j + 1
                END FOREACH
 
                LET l_round = l_round + 1
                FOR l_i = 1 TO 4
                   EXECUTE insert_prep  USING
                      sr.oma01,      l_oma02_1,     l_oma02_2,    l_oma02_3,
                      sr2[1].oma09,  sr2[1].oma211, sr2[1].oma212,sr.oma171,                                          #MOD-B70139 add oma212
                      sr.oma042,     sr.oma172,     sr.oma56x,    sr.oma56,  sr2[1].omb15,
                      sr2[1].omb12,  sr2[1].omb16,  sr2[1].omb16_oma211, sr2[1].ohb30,  sr2[1].omb06, 
                      sr.occ02,      l_occ231_1,    sr.zo041,     sr.zo042,  sr.zo02,   sr.zo06,
                      sr.azi03,      sr.azi04,      sr.azi05,     l_i,       l_round,
                      sr2[2].oma09 , sr2[2].oma211, sr2[2].oma212,       sr2[2].oma171, sr2[2].oma172, sr2[2].omb15,  #MOD-B70139 add oma212
                      sr2[2].omb12 , sr2[2].omb16,  sr2[2].omb16_oma211, sr2[2].ohb30,  sr2[2].omb06, 
                      sr2[3].oma09 , sr2[3].oma211, sr2[3].oma212,       sr2[3].oma171, sr2[3].oma172, sr2[3].omb15,  #MOD-B70139 add oma212
                      sr2[3].omb12 , sr2[3].omb16,  sr2[3].omb16_oma211, sr2[3].ohb30,  sr2[3].omb06, 
                      sr2[4].oma09 , sr2[4].oma211, sr2[4].oma212,       sr2[4].oma171, sr2[4].oma172, sr2[4].omb15,  #MOD-B70139 add oma212
                      sr2[4].omb12 , sr2[4].omb16,  sr2[4].omb16_oma211, sr2[4].ohb30,  sr2[4].omb06,  
                      sr2[5].oma09 , sr2[5].oma211, sr2[5].oma212,       sr2[5].oma171, sr2[5].oma172, sr2[5].omb15,  #MOD-B70139 add oma212
                      sr2[5].omb12 , sr2[5].omb16,  sr2[5].omb16_oma211, sr2[5].ohb30,  sr2[5].omb06
#                      "",l_img_blob,"N",""    #TQC-C10039 add "",l_img_blob,"N",""    #MOD-C20064 Mark TQC-C10039
                END FOR
                FOR i = 1 TO 5
                    INITIALIZE sr2[i].* TO NULL
                END FOR
                LET l_axrr303_curs1_count = l_axrr303_curs1_count - 5   
               LET l_axrr303_curs1_count = 0
               LET l_count = 0
               DELETE FROM axrr303_tmp
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
 
 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
#     LET g_cr_table = l_table                 #主報表的temp table名稱   #TQC-C100399  #MOD-C20064 Mark TQC-C10039
#     LET g_cr_apr_key_f = "oma01"             #報表主鍵欄位名稱  #TQC-C10039  #MOD-C20064 Mark TQC-C10039
     CALL cl_prt_cs3('axrr303','axrr303',l_sql,'')
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#FUN-910091
#FUN-B40097
