# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr501.4gl
# Descriptions...: 保稅機器設備明細表
# Date & Author..: 2006/10/14 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-850089 08/05/27 By TSD.Ken 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/24 By dxfwo  CR 追單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc STRING,
              y  LIKE type_file.chr1                  # 是否列印稅捐記帳金額
              END RECORD
   DEFINE   l_table              STRING,    #FUN-850089 add
            g_sql                STRING,    #FUN-850089 add
            g_str                STRING     #FUN-850089 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bza01.bza_file.bza01,",
              "bza02.bza_file.bza02,",
              "bza03.bza_file.bza03,",
              "bza04.bza_file.bza04,",
              "bza05.bza_file.bza05,",
              "bza06.bza_file.bza06,",
              "bza08.bza_file.bza08,",
              "bza09.bza_file.bza09,",
              "bza07.bza_file.bza07,",
              "bza11.bza_file.bza11,",
              "bza10.bza_file.bza10,",
              "bza12.bza_file.bza12,",
              "bza13.bza_file.bza13,",
              "bzb02.bzb_file.bzb02,",
              "bzb03.bzb_file.bzb03,",
              "bzb04.bzb_file.bzb04,",
              "bzb05.bzb_file.bzb05,",
              "bzb06.bzb_file.bzb06,",
              "bzb14.bzb_file.bzb14,",
              "gem02.gem_file.gem02,",
              "gen02.gen_file.gen02"
 
  LET l_table = cl_prt_temptable('abxr501',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?)" #21 items
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   LET g_pdate  = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(tm.wc) THEN
      CALL r501_tm(0,0)
   ELSE
      LET tm.wc="bza01= '",tm.wc CLIPPED,"'"
      CALL r501()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
 
END MAIN
 
FUNCTION r501_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 5
   LET p_col = 5
   OPEN WINDOW r501_w AT p_row,p_col WITH FORM "abx/42f/abxr501"
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   WHILE TRUE
      INITIALIZE tm.* TO NULL                      # Default condition
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      LET tm.y    = "Y"
 
      CONSTRUCT BY NAME tm.wc ON bza01
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bza01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_bza1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bza01
                  NEXT FIELD bza01
               OTHERWISE EXIT CASE
            END CASE
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzauser', 'bzagrup') #FUN-980030
    
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r501_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
    
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.y                 # Condition
    
      INPUT BY NAME tm.y WITHOUT DEFAULTS
    
         AFTER FIELD y
            IF tm.y NOT MATCHES "[YyNn]" THEN
               NEXT FIELD y 
            END IF 
    
         ON ACTION locale
            CALL cl_dynamic_locale()
   
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
      END INPUT 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r501_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r501()
      ERROR ""
   END WHILE
   CLOSE WINDOW r501_w
END FUNCTION
 
FUNCTION r501()
   DEFINE l_name  LIKE type_file.chr20,        # External(Disk) file name
#         l_time  LIKE type_file.chr8          #No.FUN-6A0062
          l_sql   STRING,
          sr    RECORD 
                bza01 LIKE bza_file.bza01,
                bza02 LIKE bza_file.bza02,
                bza03 LIKE bza_file.bza03,
                bza04 LIKE bza_file.bza04,
                bza05 LIKE bza_file.bza05,
                bza06 LIKE bza_file.bza06,
                bza08 LIKE bza_file.bza08,
                bza09 LIKE bza_file.bza09,
                bza07 LIKE bza_file.bza07,
                bza11 LIKE bza_file.bza11,
                bza10 LIKE bza_file.bza10,
                bza12 LIKE bza_file.bza12,
                bza13 LIKE bza_file.bza13,
                bzb02 LIKE bzb_file.bzb02, 
                bzb03 LIKE bzb_file.bzb03, 
                bzb04 LIKE bzb_file.bzb04, 
                bzb05 LIKE bzb_file.bzb05, 
                bzb06 LIKE bzb_file.bzb06,
                bzb14 LIKE bzb_file.bzb14, 
                gem02    LIKE gem_file.gem02, 
                gen02    LIKE gen_file.gen02 
                END RECORD
 
#FUN-850089 add---START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr501',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#   CALL cl_outnam('abxr501') RETURNING l_name        #No.FUN-890101    
#   START REPORT r501_rep TO l_name                   #No.FUN-890101 
   LET l_sql = " SELECT bza01,bza02,bza03,bza04,",
               "        bza05,bza06,bza08,bza09,",
               "        bza07,bza11,bza10,bza12,",
               "        bza13,bzb02,bzb03,bzb04,",
               "        bzb05,bzb06,bzb14",
               " FROM bza_file,bzb_file ",
               " WHERE bza01=bzb01 AND ",tm.wc CLIPPED
 
   PREPARE r501_pb FROM l_sql
   DECLARE r501_curs1 CURSOR FOR r501_pb
 
   FOREACH r501_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH 
      END IF
      IF cl_null(sr.bza09) THEN LET sr.bza09 =0  END IF
      IF cl_null(sr.bza10) THEN LET sr.bza10 =0  END IF
      IF cl_null(sr.bzb05) THEN LET sr.bzb05 =0  END IF
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.bzb03
      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01=sr.bzb04
      #FUN-850089  ---start---
      EXECUTE insert_prep USING sr.*
      #FUN-850089  ---end---
#      OUTPUT TO REPORT r501_rep(sr.*)
   END FOREACH
 
#   FINISH REPORT r501_rep                       #No.FUN-890101 
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-890101 
   #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bza01')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
 
    LET g_str = g_str,";",tm.y
 
    CALL cl_prt_cs3('abxr501','abxr501',l_sql,g_str)
   #---FUN-850089 add---END

   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr501',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
 
#REPORT r501_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,
#          sr    RECORD
#                bza01 LIKE bza_file.bza01,
#                bza02 LIKE bza_file.bza02,
#                bza03 LIKE bza_file.bza03,
#                bza04 LIKE bza_file.bza04,
#                bza05 LIKE bza_file.bza05,
#                bza06 LIKE bza_file.bza06,
#                bza08 LIKE bza_file.bza08,
#                bza09 LIKE bza_file.bza09,
#                bza07 LIKE bza_file.bza07,
#                bza11 LIKE bza_file.bza11,
#                bza10 LIKE bza_file.bza10,
#                bza12 LIKE bza_file.bza12,
#                bza13 LIKE bza_file.bza13,
#                bzb02 LIKE bzb_file.bzb02, 
#                bzb03 LIKE bzb_file.bzb03, 
#                bzb04 LIKE bzb_file.bzb04, 
#                bzb05 LIKE bzb_file.bzb05, 
#                bzb06 LIKE bzb_file.bzb06,
#                bzb14 LIKE bzb_file.bzb14, 
#                gem02    LIKE gem_file.gem02, 
#                gen02    LIKE gen_file.gen02 
#                END RECORD
#   DEFINE l_cnt LIKE type_file.num5   #判斷是否為單頭的資料
#
#   OUTPUT TOP MARGIN g_top_margin
#          LEFT MARGIN    g_left_margin
#          BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH    g_page_line
#   ORDER BY sr.bza01,sr.bzb02
#  
#   FORMAT
#   PAGE HEADER 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash
#      PRINTX name = H1 g_x[31] CLIPPED,g_x[32] CLIPPED,
#                       g_x[33] CLIPPED,g_x[34] CLIPPED,
#                       g_x[35] CLIPPED,g_x[36] CLIPPED,
#                       g_x[37] CLIPPED,g_x[38] CLIPPED,
#                       g_x[39] CLIPPED,g_x[40] CLIPPED,
#                       g_x[41] CLIPPED,g_x[42] CLIPPED
#
#      PRINTX name = H2 g_x[43] CLIPPED,g_x[44] CLIPPED,
#                       g_x[45] CLIPPED,g_x[46] CLIPPED,
#                       g_x[47] CLIPPED,g_x[48] CLIPPED,
#                       g_x[49] CLIPPED,g_x[50] CLIPPED,
#                       g_x[51] CLIPPED,g_x[52] CLIPPED,
#                       g_x[53] CLIPPED,g_x[54] CLIPPED
#
# 
#      PRINT g_dash1
#      LET l_last_sw = "n"
#
#   BEFORE GROUP OF sr.bza01  #印單頭的資料和第一筆單身的資料
#      LET l_cnt = 1
#      PRINTX name = D1 COLUMN g_c[31],sr.bza01 CLIPPED, 
#                       COLUMN g_c[32],sr.bza02 CLIPPED,
#                       COLUMN g_c[33],sr.bza04 CLIPPED;
#
#         CASE WHEN sr.bza05 ='1' 
#                 PRINTX name = D1 COLUMN g_c[34],g_x[11] CLIPPED;
#              WHEN sr.bza05 ='2'
#                 PRINTX name = D1 COLUMN g_c[34],g_x[12] CLIPPED;
#              OTHERWISE
#                 PRINTX name = D1 '    ';
#         END CASE
#
#      PRINTX name = D1 COLUMN g_c[35],sr.bza08 CLIPPED,
#                       COLUMN g_c[36],sr.bza07 CLIPPED;
#      IF tm.y ='Y' THEN
#         PRINTX name = D1 COLUMN g_c[37],cl_numfor(sr.bza10,37,3);
#      ELSE 
#         PRINTX name = D1 COLUMN g_c[37],' ';
#      END IF
#      PRINTX name = D1 COLUMN g_c[38],sr.bza12 CLIPPED,
#                       COLUMN g_c[39],sr.bzb03 CLIPPED,
#                       COLUMN g_c[40],sr.gem02 CLIPPED,
#                       COLUMN g_c[41],cl_numfor(sr.bzb05,41,3),
#                       COLUMN g_c[42],sr.bzb06 CLIPPED
#
#      #第一筆單身的資料
#      PRINTX name = D2 COLUMN g_c[43],' ',
#                       COLUMN g_c[44],sr.bza03 CLIPPED, 
#                       COLUMN g_c[45],' ',
#                       COLUMN g_c[46],sr.bza06 CLIPPED,
#                       COLUMN g_c[47],cl_numfor(sr.bza09,47,0),
#                       COLUMN g_c[48],sr.bza11 CLIPPED,
#                       COLUMN g_c[49],' ',
#                       COLUMN g_c[50],sr.bza13 CLIPPED,
#                       COLUMN g_c[51],sr.bzb04 CLIPPED, 
#                       COLUMN g_c[52],sr.gen02 CLIPPED,
#                       COLUMN g_c[53],' ',
#                       COLUMN g_c[54],sr.bzb14 CLIPPED
#
#   ON EVERY ROW      #印第二筆以後的單身資料
#      IF l_cnt > 1 THEN
#         PRINTX name = D1 COLUMN g_c[39],sr.bzb03 CLIPPED,
#                          COLUMN g_c[40],sr.gem02 CLIPPED,
#                          COLUMN g_c[41],cl_numfor(sr.bzb05,41,3),
#                          COLUMN g_c[42],sr.bzb06 CLIPPED
#               
#         PRINTX name = D2 COLUMN g_c[51],sr.bzb04 CLIPPED,
#                          COLUMN g_c[52],sr.gen02 CLIPPED,
#                          COLUMN g_c[53],' ',
#                          COLUMN g_c[54],sr.bzb14 CLIPPED
#      END IF
#      LET l_cnt = l_cnt + 1
#
#   ON LAST ROW
#      LET l_last_sw ='y'
#      PRINT g_dash
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw ='n' THEN
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[5] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#        
#END REPORT
#No.FUN-890101 
