# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimr832.4gl
# Descriptions...: 複盤差異分析表－在製工單
# Input parameter: 
# Return code....: 
# Date & Author..: 93/05/29 By Apple
# Modify.........: No.FUN-510017 05/01/27 By Mandy 報表轉XML
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大& sql中變量個數少選
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: NO.MOD-720046 07/03/15 By TSD.miki 報表改寫由Crystal Report
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-740065 07/07/23 By jamie 程式已轉成用Crystal Report方式出報表，程式裡面不應取zaa的資料(以後zaa將不再用)，應將其修正
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/20 By lilingyu 平行工藝
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
           wc       STRING,                 # Where Condition  #TQC-630166
           diff     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s        LIKE type_file.chr3,    # Order by sequence  #No.FUN-690026 VARCHAR(3)
           t        LIKE type_file.chr3,    # Eject sw  #No.FUN-690026 VARCHAR(3)
           more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_q_point    LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(80)
DEFINE l_orderA     ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088 
#MOD-720046 TSD.miki-----------------------------------------------(S)
DEFINE l_table      STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE g_tot        ARRAY[13] OF LIKE cae_file.cae07
#MOD-720046 TSD.miki-----------------------------------------------(E)
DEFINE g_zaa04_value  LIKE zaa_file.zaa04   #FUN-710080 add
DEFINE g_zaa10_value  LIKE zaa_file.zaa10   #FUN-710080 add
DEFINE g_zaa11_value  LIKE zaa_file.zaa11   #FUN-710080 add
DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
  #MOD-720046 TSD.miki-----------------------------------------------------------(S)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = "order1.ima_file.ima01,",
               "order2.ima_file.ima01,",
               "order3.ima_file.ima01,",
               "pid01.pid_file.pid01,",
               "pid02.pid_file.pid02,",
               "pid03.pid_file.pid03,",
               "pie02.pie_file.pie02,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "pie03.pie_file.pie03,",
               "pie04.pie_file.pie04,",
               "pie05.pie_file.pie05,",
               "pie50.pie_file.pie50,",
               "pie51.pie_file.pie51,",
               "pie54.pie_file.pie54,",
               "pie55.pie_file.pie55,",
               "pie60.pie_file.pie60,",
               "pie61.pie_file.pie61,",
               "pie64.pie_file.pie64,",
               "pie65.pie_file.pie65,",
               "gen02.gen_file.gen02,",
               "gen02_pie51.gen_file.gen02,",
               "gen02_pie61.gen_file.gen02,",
               "ima02_pid03.ima_file.ima02,",
               "ima021_pid03.ima_file.ima021,",
               "l_gen02.gen_file.gen02,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",         #FUN-A60092 add ,
               "pie012.pie_file.pie012,",       #FUN-A60092 add
               "pie013.pie_file.pie013"           #FUN-A60092 add
   LET l_table = cl_prt_temptable('axcr773',g_sql) CLIPPED   # 產生Temp Table
   IF l_table  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?, ?,?)"   #FUN-A60092 add ?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
  #MOD-720046 TSD.miki-----------------------------------------------------------(E)
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.diff  = ARG_VAL(10)     #TQC-610072 順序順推  
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r832_tm(0,0)        # Input print condition
      ELSE CALL r832()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r832_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row =  5 LET p_col = 19 
   ELSE
       LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r832_w AT p_row,p_col
        WITH FORM "aim/42f/aimr832" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'N'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON 
                     pid01, pid02, pid03, pie02,
                     pie05, pie03, pie51, pie61
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
      LET INT_FLAG = 0 CLOSE WINDOW r832_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.diff,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD diff 
         IF tm.diff IS NULL OR tm.diff NOT MATCHES'[YNyn]'
         THEN NEXT FIELD diff
         END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r832_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr832'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr832','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.diff CLIPPED,"'",              #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr832',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r832_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r832()
   ERROR ""
END WHILE
   CLOSE WINDOW r832_w
END FUNCTION
 
FUNCTION r832()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_gen02   LIKE gen_file.gen02,    #MOD-720046 TSD.miki
          l_order   ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           pid01  LIKE pid_file.pid01,
                           pid02  LIKE pid_file.pid02,
                           pid03  LIKE pid_file.pid03,
                           pie02  LIKE pie_file.pie02,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           pie03  LIKE pie_file.pie03,
                           pie04  LIKE pie_file.pie04,
                           pie05  LIKE pie_file.pie05,
                           pie50  LIKE pie_file.pie50,
                           pie51  LIKE pie_file.pie51,
                           pie54  LIKE pie_file.pie54,
                           pie55  LIKE pie_file.pie55,
                           pie60  LIKE pie_file.pie60,
                           pie61  LIKE pie_file.pie61,
                           pie64  LIKE pie_file.pie64,
                           pie65  LIKE pie_file.pie65,
                           gen02  LIKE gen_file.gen02,
                           gen02_pie51  LIKE gen_file.gen02,
                           gen02_pie61  LIKE gen_file.gen02,
                           ima02_pid03  LIKE ima_file.ima02,
                           ima021_pid03 LIKE ima_file.ima021
                          ,pie012       LIKE pie_file.pie012   #FUN-A60092
                          ,pie013       LIKE pie_file.pie013   #FUN-A60092 
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #MOD-720046 TSD.miki---------------------------------------------------------(S)
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #MOD-720046 TSD.miki---------------------------------------------------------(E)
 
#No.FUN-550029-begin
     LET l_sql = "SELECT '','','',",
                 "pid01, pid02, pid03, ",
                 "pie02, ima02, ima021,pie03, pie04, pie05, pie50, pie51,",
                 "pie54, pie55, pie60, pie61, pie64, pie65, gen02,'','','','',pie012,pie013 ",
                                           #FUN-A60092 add pie012,pie013
                 "  FROM pid_file,pie_file,OUTER ima_file,",
                 "   OUTER gen_file ",
                 " WHERE pid01=pie01 ",
                 "   AND pie_file.pie02 = ima_file.ima01 ",
                 "   AND pie_file.pie54 = gen_file.gen01 ",  
                 "  AND (pid02 IS NOT NULL AND pid02 != ' ') ",
                 "  AND ( (pie50 IS NOT NULL ) ",
                 "        OR (pie60 IS NOT NULL )) ",
                 " AND ", tm.wc
#No.FUN-550029-end  
 
     #複盤資料輸入員(一)與資料輸入員(二)
     IF tm.diff ='N' THEN 
        LET l_sql = l_sql clipped," AND (pie50 != pie60 OR ",
                              " pie50 IS NULL  OR",
                              " pie60 IS NULL ) "  ## OR pie60 = ' ' )"
     END IF
     PREPARE r832_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r832_curs1 CURSOR FOR r832_prepare1
 
     #LET l_name = 'aimr832.out'  #MOD-550120
    #CALL cl_outnam('aimr832') RETURNING l_name    #FUN-710080 mark
    #CALL r832_getzaa()                            #TQC-740065 mark#FUN-710080 add
    #START REPORT r832_rep TO l_name  #MOD-720046 TSD.miki mark
     FOR g_i = 1 TO 80 LET g_q_point[g_i,g_i] = '?' END FOR   
 
     LET g_pageno = 0
     FOREACH r832_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid01
                                       #LET l_orderA[g_i] =g_x[61]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid02
                                       #LET l_orderA[g_i] =g_x[62]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pid03
                                       #LET l_orderA[g_i] =g_x[63]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pie02
                                       #LET l_orderA[g_i] =g_x[64]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pie05
                                       #LET l_orderA[g_i] =g_x[65]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pie03
                                       #LET l_orderA[g_i] =g_x[66]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.pie51
                                       #LET l_orderA[g_i] =g_x[67]    #TQC-740065 mark #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.pie61
                                       #LET l_orderA[g_i] =g_x[68]    #TQC-740065 mark #TQC-6A0088
               OTHERWISE LET l_order[g_i] = '-'
                                       #LET l_orderA[g_i] =''    #TQC-740065 mark #TQC-6A0088
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       SELECT gen02 INTO sr.gen02_pie51 FROM gen_file
        WHERE gen01 = sr.pie51
       SELECT gen02 INTO sr.gen02_pie61 FROM gen_file
        WHERE gen01 = sr.pie61
       SELECT ima02,ima021 INTO sr.ima02_pid03,sr.ima021_pid03
         FROM ima_file
        WHERE ima01 = sr.pid03
      #MOD-720046 TSD.miki-------------------------------------------------------(S)
      #OUTPUT TO REPORT r832_rep(sr.*)
       IF sr.pie60 IS NOT NULL THEN
          SELECT gen02 INTO l_gen02 FROM gen_file
           WHERE gen01 = sr.pie64
       ELSE 
          LET l_gen02 =' '  LET sr.pie65 = ' '
       END IF
       EXECUTE insert_prep USING
               sr.order1,sr.order2,sr.order3,sr.pid01,sr.pid02,
               sr.pid03,sr.pie02,sr.ima02,sr.ima021,sr.pie03,
               sr.pie04,sr.pie05,sr.pie50,sr.pie51,sr.pie54,
               sr.pie55,sr.pie60,sr.pie61,sr.pie64,sr.pie65,
               sr.gen02,sr.gen02_pie51,sr.gen02_pie61,
               sr.ima02_pid03,sr.ima021_pid03,l_gen02,
               g_azi03,g_azi04,g_azi05
              ,sr.pie012,sr.pie013   #FUN-A60092 add 
      #MOD-720046 TSD.miki-------------------------------------------------------(E)
     END FOREACH
 
    #MOD-720046 TSD.miki---------------------------------------------------------(S)
    #FINISH REPORT r832_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = NULL
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pid01,pid02,pid03,pie02,pie05,pie03,pie51,pie61')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.s,  ";",tm.t
                      #";",l_orderA[1] CLIPPED,";",l_orderA[2] CLIPPED,  #TQC-740065 mark
                      #";",l_orderA[3] CLIPPED                           #TQC-740065 mark
  IF g_sma.sma541 = 'N' THEN   #FUN-A60092 
     CALL cl_prt_cs3('aimr832','aimr832',l_sql,g_str)   #FUN-710080 modify
  ELSE                                                           #FUN-A60092 
     CALL cl_prt_cs3('aimr832','aimr832_1',l_sql,g_str)     	   #FUN-A60092
  END IF 	                                                       #FUN-A60092
    #MOD-720046 TSD.miki---------------------------------------------------------(E)
END FUNCTION
 
#TQC-740065---mark---str---
##str FUN-710080 add
#FUNCTION r832_getzaa()
#   DEFINE l_zaa02           LIKE type_file.num5,
#          l_zaa08           LIKE type_file.chr1000,
#          l_zaa08_s         STRING,
#          l_zaa14           LIKE zaa_file.zaa14,
#          l_zaa16           LIKE zaa_file.zaa16,
#          l_name            LIKE type_file.chr20,
#          l_n               LIKE type_file.num5,
#          l_n2              LIKE type_file.num5,
#          l_buf             LIKE type_file.chr6,
#          l_sw              LIKE type_file.chr1,
#          l_waitsec         LIKE type_file.num5
#
#   SELECT unique zaa04,zaa11,zaa17
#     INTO g_zaa04_value,g_zaa11_value,g_zaa17_value
#     FROM zaa_file
#    WHERE zaa01 = g_prog
#      AND zaa03 = g_rlang
#      AND zaa10 = 'N'
#      AND ((zaa04='default' AND zaa17='default') OR
#           zaa04 =g_user OR zaa17= g_clas)
#   DECLARE zaa_cur CURSOR FOR
#      SELECT zaa02,zaa08,zaa14,zaa16 FROM zaa_file
#       WHERE zaa01 = g_prog           #程式代號
#         AND zaa03 = g_rlang          #語言別
#         AND zaa04 = g_zaa04_value    #使用者
#         AND zaa11 = g_zaa11_value    #報表列印的樣板
#         AND zaa10 = 'N'              #客製否
#         AND zaa17 = g_zaa17_value    #權限類別
#       ORDER BY zaa02
#   FOREACH zaa_cur INTO l_zaa02,l_zaa08,l_zaa14,l_zaa16
#      #FUN-560048
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
#         EXIT PROGRAM
#      END IF
#      #END FUN-560048
#      LET l_zaa08 = cl_outnam_zab(l_zaa08,l_zaa14,l_zaa16)         #MOD-530271
#      LET l_zaa08_s = l_zaa08 CLIPPED
#      LET g_x[l_zaa02] = l_zaa08_s
#   END FOREACH
#
#END FUNCTION
##end FUN-710080 add
#TQC-740065---mark---end---
 
#TQC-740065---mark---str---
#REPORT r832_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
#          sr           RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                              order2 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                              order3 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                              pid01  LIKE pid_file.pid01,
#                              pid02  LIKE pid_file.pid02,
#                              pid03  LIKE pid_file.pid03,
#                              pie02  LIKE pie_file.pie02,
#                              ima02  LIKE ima_file.ima02,
#                              ima021 LIKE ima_file.ima021,
#                              pie03  LIKE pie_file.pie03,
#                              pie04  LIKE pie_file.pie04,
#                              pie05  LIKE pie_file.pie05,
#                              pie50  LIKE pie_file.pie50,
#                              pie51  LIKE pie_file.pie51,
#                              pie54  LIKE pie_file.pie54,
#                              pie55  LIKE pie_file.pie55,
#                              pie60  LIKE pie_file.pie60,
#                              pie61  LIKE pie_file.pie61,
#                              pie64  LIKE pie_file.pie64,
#                              pie65  LIKE pie_file.pie65,
#                              gen02  LIKE gen_file.gen02,
#                              gen02_pie51  LIKE gen_file.gen02,
#                              gen02_pie61  LIKE gen_file.gen02,
#                              ima02_pid03  LIKE ima_file.ima02,
#                              ima021_pid03 LIKE ima_file.ima021
#                       END RECORD,
#          l_gen02      LIKE gen_file.gen02,
#          l_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.pid01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
# #    PRINT           #TQC-6A0088
#      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
#      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]
#      PRINTX name=H3 g_x[53],g_x[54],g_x[55]
#      PRINT g_dash1 
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      PRINTX name=D1 COLUMN g_c[31],sr.pid01,
#                     COLUMN g_c[32],sr.pid02,
#                     COLUMN g_c[33],sr.pid03,
#                     COLUMN g_c[34],sr.pie05,
#                     COLUMN g_c[35],sr.pie02,
#                     COLUMN g_c[36],sr.pie04,
#                     COLUMN g_c[37],sr.pie51,
#                     COLUMN g_c[38],sr.gen02_pie51;
#            IF sr.pie50 IS NOT NULL THEN 
#                PRINTX name=D1 COLUMN g_c[39],cl_numfor(sr.pie50,39,3);
#            ELSE 
#                PRINTX name=D1 COLUMN g_c[39],g_q_point[1,g_w[39]];
#            END IF
#      PRINTX name=D1 COLUMN g_c[40],sr.pie54,
#                     COLUMN g_c[41],sr.gen02,
#                     COLUMN g_c[42],sr.pie55
#
#      PRINTX name=D2 COLUMN g_c[43],' ',
#                     COLUMN g_c[44],sr.ima02_pid03,
#                     COLUMN g_c[45],sr.pie03,
#                     COLUMN g_c[46],sr.ima02,
#                     COLUMN g_c[47],sr.pie61,
#                     COLUMN g_c[48],sr.gen02_pie61;
#            IF sr.pie60 IS NOT NULL THEN
#                PRINTX name=D2 COLUMN g_c[49],cl_numfor(sr.pie60,49,3); 
#                 select gen02 INTO l_gen02 FROM gen_file
#                     WHERE gen01 = sr.pie64
#            ELSE 
#                PRINTX name=D2 COLUMN g_c[49],g_q_point[1,g_w[49]];
#                LET l_gen02 =' '  LET sr.pie65 = ' '
#            END IF
#      PRINTX name=D2 COLUMN g_c[50],sr.pie64,
#                     COLUMN g_c[51],l_gen02, 
#                     COLUMN g_c[52],sr.pie65
#
#      PRINTX name=D3 COLUMN g_c[53],' ',
#                     COLUMN g_c[54],sr.ima021_pid03,
#                     COLUMN g_c[55],sr.ima021
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pid01,pid02,pie02,pie05,pie51,pie61')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#TQC-740065---mark---end---
