# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: acor510
# Descriptions...: 進出口報關貨物申報單
# Date & Author..: 00/09/13 BY Amy
# Modify.........: NO.MOD-490398 04/11/22 BY DAY  add cno20,Customs No.
# Modify.........: NO.MOD-490398 04/12/24 BY Carrier 修改cno10之后的影響
# Modify.........: No.MOD-580212 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global" #CKP
DEFINE   g_i          LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE   g_cnt        LIKE type_file.num5         #No.FUN-680069 SMALLINT #CKP
 
   DEFINE tm  RECORD                                                    # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              more    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # Input 1 or 2 為出/進口
              b       LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # input 1/2/3  為轉廠/結轉/退港
              END RECORD
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   #CKP
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   LET g_trace = 'N'                   # default trace off
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#-----------------No.TQC-610082 modify
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
#-----------------No.TQC-610082 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r510_tm(0,0)           # Input print condition
      ELSE CALL r510()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION r510_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
IF p_row = 0 THEN LET p_row = 5 LET p_col = 13 END IF
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW r510_w AT p_row,p_col
      #CKP
      WITH FORM "aco/42f/acor510"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a = '1'
   LET tm.b = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON cno01,cno02,cno10,cno06
    #CKP
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
   IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
   LET INT_FLAG = 0 CLOSE WINDOW r510_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
   EXIT PROGRAM
      
   END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS HELP 1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
           IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]'THEN NEXT FIELD a
           END IF
      AFTER FIELD b
           IF cl_null(tm.b) OR tm.b NOT MATCHES '[123]'THEN NEXT FIELD b
           END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #CKP
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r510_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor510','9031',0)
      ELSE
         LET tm.wc = cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",          #No.TQC-610082 add
                         " '",tm.b CLIPPED,"'",          #No.TQC-610082 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('acor510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r510()
   ERROR ""
END WHILE
   CLOSE WINDOW r510_w
END FUNCTION
 
FUNCTION r510()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,           #MOD-490398
          sr        RECORD
                    cno20   LIKE cno_file.cno20, #MOD-490398
                    cno10   LIKE cno_file.cno10,
                    cno08   LIKE cno_file.cno08,
                    cno09   LIKE cno_file.cno09,
                    cno11   LIKE cno_file.cno11,
                    cno12   LIKE cno_file.cno12,
                    cno13   LIKE cno_file.cno13,
                    cnp012  LIKE cnp_file.cnp012,
                    cnp02   LIKE cnp_file.cnp02,
                    cob01   LIKE cob_file.cob01,
                    cob02   LIKE cob_file.cob02,
                    cob021  LIKE cob_file.cob021,
                    cnp11   LIKE cnp_file.cnp11,
                    cnp05   LIKE cnp_file.cnp05,
                    cnp06   LIKE cnp_file.cnp06,
                    coc02   LIKE coc_file.coc02,
                    cnp08   LIKE cnp_file.cnp08,
                    cno15   LIKE cno_file.cno15,
                    cno16   LIKE cno_file.cno16,
                    cno17   LIKE cno_file.cno17,
                    cno01   LIKE cno_file.cno01,
                    cno02   LIKE cno_file.cno02,
                    cno06   LIKE cno_file.cno06,
                    cno031  LIKE cno_file.cno031,
                    cno04   LIKE cno_file.cno04
                    END RECORD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
     #End:FUN-980030
 
   LET l_sql = "SELECT cno20,cno10,cno08,cno09,cno11,cno12,cno13,cnp012,cnp02,",  #MOD-490398
                 "cob01,cob02,cob021,cnp11,cnp05,cnp06,coc02,cnp08,cno15,cno16,cno17,",
                 "cno01,cno02,cno06,cno031,cno04",
                 " FROM cno_file,cnp_file,coc_file,OUTER cob_file",
                 " WHERE cno01 = cnp01 AND cob_file.cob01 = cnp_file.cnp03 ",  #MOD-490398
                 "  AND cnoacti = 'Y' ",
                 "  AND cocacti != 'N' ", #010806增
                 "  AND cnoconf <> 'X' ",  #CHI-C80041
                 #" AND coc04 = cno10 "," AND cno031=",tm.a, #No.MOD-490398
                 " AND coc03 = cno10 "," AND cno031=",tm.a, #No.MOD-490398
                 " AND cno04=",tm.b," AND ",tm.wc CLIPPED
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r510_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
     END IF
     DECLARE r510_curs1 CURSOR FOR r510_prepare1
     CALL cl_outnam('acor510') RETURNING l_name
     START REPORT r510_rep TO l_name
          LET g_pageno = 0
              FOREACH r510_curs1 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,0)
                   EXIT FOREACH
                 END IF
              IF g_trace='Y' THEN
                   DISPLAY sr.cno10
                 END IF
                OUTPUT TO REPORT r510_rep(sr.*)
              END FOREACH
     FINISH REPORT r510_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r510_rep(sr)
   DEFINE l_trailer_sw LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_str        LIKE type_file.chr10,        #LIKE cqa_file.cqa03,         #No.FUN-680069 VARCHAR(8)   #TQC-B90211
          l_cna02      LIKE cna_file.cna02,
          sr        RECORD
                    cno20   LIKE cno_file.cno20,  #MOD-490398
                    cno10   LIKE cno_file.cno10,
                    cno08   LIKE cno_file.cno08,
                    cno09   LIKE cno_file.cno09,
                    cno11   LIKE cno_file.cno11,
                    cno12   LIKE cno_file.cno12,
                    cno13   LIKE cno_file.cno13,
                    cnp012  LIKE cnp_file.cnp012,
                    cnp02   LIKE cnp_file.cnp02,
                    cob01   LIKE cob_file.cob01,
                    cob02   LIKE cob_file.cob02,
                    cob021  LIKE cob_file.cob021,
                    cnp11   LIKE cnp_file.cnp11,
                    cnp05   LIKE cnp_file.cnp05,
                    cnp06   LIKE cnp_file.cnp06,
                    coc02   LIKE coc_file.coc02,
                    cnp08   LIKE cnp_file.cnp08,
                    cno15   LIKE cno_file.cno15,
                    cno16   LIKE cno_file.cno16,
                    cno17   LIKE cno_file.cno17,
                    cno01   LIKE cno_file.cno01,
                    cno02   LIKE cno_file.cno02,
                    cno06   LIKE cno_file.cno06,
                    cno031  LIKE cno_file.cno031,
                    cno04   LIKE cno_file.cno04
                    END RECORD,
             l_hh          LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(40)
             l_cnt         LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.cno10,sr.cno11
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      IF tm.a = '1' THEN
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[20]))/2)+1,g_x[20] CLIPPED
      ELSE
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[21]))/2)+1,g_x[21] CLIPPED
      END IF
      PRINT
 #MOD-490398(BRGIN)
      SELECT cna02 INTO l_cna02 FROM cna_file
      WHERE cna01=sr.cno20
      IF SQLCA.sqlcode THEN
         LET l_cna02 = ' '
      END IF
      PRINT COLUMN 01,g_x[9] CLIPPED,sr.cno20 CLIPPED,' ',l_cna02 CLIPPED,
            COLUMN 55,g_x[10] CLIPPED,sr.cno10
      PRINT g_dash[1,g_len]
      LET l_trailer_sw = 'y'
 #MOD-490398(END)
      PRINT g_x[11] CLIPPED,sr.cno08,
            COLUMN 41,g_x[12] CLIPPED,sr.cno09
      PRINT g_x[13] CLIPPED,sr.cno11,5 SPACES,g_x[14] CLIPPED,sr.cno12,
            6 SPACES,g_x[15] CLIPPED,sr.cno13
      PRINT
      PRINT g_x[17] CLIPPED,sr.cno15 USING '<<<<<<<&' CLIPPED,'      ',
            g_x[18] CLIPPED,
            sr.cno16 USING '<<<<<<<<<<&' CLIPPED,g_x[16] CLIPPED,
            COLUMN 41,g_x[19] CLIPPED,sr.cno17
      PRINT
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
 
   BEFORE GROUP OF sr.cno11   #單據編號
      SKIP TO TOP OF PAGE
 #MOD-490398(BEGIN)
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.cnp012 USING '###&',#FUN-590118
            COLUMN g_c[32],sr.cnp02 USING '&&&&&',
            COLUMN g_c[33],sr.cob01 ,
            COLUMN g_c[34],sr.cob02 ,
            COLUMN g_c[35],sr.cob021,
            COLUMN g_c[36],sr.cnp11 ,
            COLUMN g_c[37],sr.cnp05 USING '##########&.&&&',
            COLUMN g_c[38],sr.cnp06,
            COLUMN g_c[39],sr.coc02,
            COLUMN g_c[40],cl_numfor(sr.cnp08,40,g_azi04)  #MOD-580212
 #MOD-490398(END)
   ON LAST ROW
      PRINT
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_trailer_sw = 'n'
 
   PAGE TRAILER
      IF l_trailer_sw = 'y' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
END REPORT
