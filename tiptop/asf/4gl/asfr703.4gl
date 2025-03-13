# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfr703.4gl
# Descriptions...: 標準工時總綱
# Date & Author..: 98/12/07 BY ching
# Modify.........: No.FUN-580014 05/08/16 By yoyo 憑証類報表原則修改
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0187 09/10/30 By xiaofeizhu 標準SQL修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                     # Print condition RECORD
                    wc     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
                  more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose        #No.FUN-680121 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
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
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r703_tm(0,0)        # Input print condition
      ELSE CALL asfr703()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r703_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5  LET p_col = 20
   ELSE LET p_row = 6 LET p_col = 14
   END IF
   OPEN WINDOW r703_w AT p_row,p_col
        WITH FORM "asf/42f/asfr703"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
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
   DISPLAY BY NAME tm.more # Condition
   #CONSTRUCT BY NAME tm.wc ON ecu01,ecu02
   CONSTRUCT BY NAME tm.wc ON ima01,ecu02
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr703'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr703','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr703',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r703_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr703()
   ERROR ""
END WHILE
   CLOSE WINDOW r703_w
END FUNCTION
 
FUNCTION asfr703()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_s1      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          i         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          j         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          sr        RECORD
                           ecu01  LIKE ecu_file.ecu01,
                           ima02  LIKE ima_file.ima02,
                           ecu02  LIKE ecu_file.ecu02,
                           ecb03  LIKE ecb_file.ecb03,
                           ecb17  LIKE ecb_file.ecb17,
                           ecb08  LIKE ecb_file.ecb08,
                           ecb19  LIKE ecb_file.ecb19,
                           ecb38  LIKE ecb_file.ecb38,
                           ecb21  LIKE ecb_file.ecb21,
                           sgc05  LIKE sgc_file.sgc05,
                           sga02  LIKE sga_file.sga02,
                           sgc06  LIKE sgc_file.sgc06,
                           sgc08  LIKE sgc_file.sgc08,
                           sgc09  LIKE sgc_file.sgc09,
                           sgc11  LIKE sgc_file.sgc11
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     #No.B575 010522 BY ANN CHEN
     LET l_sql = " SELECT ecu01,ima02,ecu02,      ",
                 "        ecb03,ecb17,ecb08,      ",
                 "        ecb19,ecb38,ecb21,      ",
                 "        sgc05,sga02,            ",
                 "        sgc06,sgc08,sgc09,sgc11 ",
#               "    FROM ecu_file,ima_file,sga_file,ecb_file ",                             #TQC-9A0187 Mark
#               "    LEFT OUTER JOIN sgc_file ",                                             #TQC-9A0187 Mark 
                "    FROM ecu_file,ima_file,ecb_file ",                                      #TQC-9A0187 Add
                "    LEFT OUTER JOIN (sgc_file LEFT OUTER JOIN sga_file ON sga01=sgc05) ",   #TQC-9A0187 Add
                "    ON ecb01 = sgc01 AND ecb02 = sgc02 AND ecb03 = sgc03 ",                 #TQC-9A0187 Mark
                "    WHERE ima571=ecu01 ",
#                "   AND sga_file.sga01=sgc_file.sgc05                                       #TQC-9A0187 Mark           ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE r703_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r703_cs1 CURSOR FOR r703_prepare1
     CALL cl_outnam('asfr703') RETURNING l_name
     START REPORT r703_rep TO l_name
     LET g_pageno = 0
     FOREACH r703_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       OUTPUT TO REPORT r703_rep(sr.*)
     END FOREACH
     FINISH REPORT r703_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r703_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_str         LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          l_sw          LIKE type_file.chr1,          #No.FUN-680121 CAHR(1)
          l_sta         LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(12)
          l_sta1        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(22)
          l_sql1,l_sql2 LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
          l_bmb16       LIKE bmb_file.bmb16,
          l_nedhur      LIKE eca_file.eca09,          #No.FUN-680121 DECIMAL(8,2)
          sr            RECORD
                           ecu01  LIKE ecu_file.ecu01,
                           ima02  LIKE ima_file.ima02,
                           ecu02  LIKE ecu_file.ecu02,
                           ecb03  LIKE ecb_file.ecb03,
                           ecb17  LIKE ecb_file.ecb17,
                           ecb08  LIKE ecb_file.ecb08,
                           ecb19  LIKE ecb_file.ecb19,
                           ecb38  LIKE ecb_file.ecb38,
                           ecb21  LIKE ecb_file.ecb21,
                           sgc05  LIKE sgc_file.sgc05,
                           sga02  LIKE sga_file.sga02,
                           sgc06  LIKE sgc_file.sgc06,
                           sgc08  LIKE sgc_file.sgc08,
                           sgc09  LIKE sgc_file.sgc09,
                           sgc11  LIKE sgc_file.sgc11
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ecu01,sr.ecu02,sr.ecb03,sr.sgc05
  FORMAT
   PAGE HEADER
#No.FUN-580014--start
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF cl_null(g_towhom) THEN
#        PRINT '';
#     ELSE
#        PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT g_x[2] CLIPPED,TIME,COLUMN 73,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_dash[1,g_len]
#No.FUN-580014--end
      LET g_pageno = g_pageno + 1
 
   BEFORE GROUP OF sr.ecu02
      SKIP TO TOP OF PAGE
      PRINT g_x[13] CLIPPED,sr.ecu01
      PRINT g_x[12] CLIPPED,sr.ima02
      PRINT g_x[20] CLIPPED,sr.ecu02
      PRINT ' '
      #PRINT g_dash1[1,g_len]
#No.FUN-580014--start
#     PRINT g_x[15] CLIPPED,COLUMN 40,g_x[16]
#     PRINT g_x[18] CLIPPED,COLUMN 40,g_x[19]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#No.FUN-580014--end
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ecb03
#No.FUN-580014--start
#     PRINT sr.ecb03 USING '####',
#           COLUMN 13,sr.ecb17[1,20],
#           COLUMN 35,sr.ecb08[1,06],
#           COLUMN 42,sr.ecb19 USING '#####.###',
#           COLUMN 57,sr.ecb38 USING '##.###',
#           COLUMN 68,sr.ecb21 USING '#####.###'
      PRINTX name=D1
            COLUMN g_c[31], sr.ecb03 USING '####',
            COLUMN g_c[33],sr.ecb17[1,20],
            COLUMN g_c[34],sr.ecb08[1,06],
            COLUMN g_c[35],sr.ecb19 USING '###########.###',
            COLUMN g_c[36],sr.ecb38 USING '###########.###',
            COLUMN g_c[37],sr.ecb21 USING '###########.###'
#No.FUN-580014--end
 
   ON EVERY ROW
     IF g_sma.sma55 ='Y' THEN
#No.FUN-580014--start
#     PRINT COLUMN 8,
#           sr.sgc05[1,04],
#           COLUMN 13,sr.sga02[1,20],
#           COLUMN 35,sr.sgc06 USING '######',
#           COLUMN 42,sr.sgc08 USING '#####.###',
#           COLUMN 57,sr.sgc09 USING '##.###',
#           COLUMN 68,sr.sgc11 USING '#####.###'
      PRINTX name=D2
            COLUMN g_c[39],sr.sgc05[1,04],
            COLUMN g_c[40],sr.sga02[1,20],
            COLUMN g_c[41],sr.sgc06 USING '######',
            COLUMN g_c[42],sr.sgc08 USING '###########.###',
            COLUMN g_c[43],sr.sgc09 USING '###########.###',
            COLUMN g_c[44],sr.sgc11 USING '###########.###'
#No.FUN-580014--end
     END IF
 
    AFTER GROUP OF sr.ecb03
       PRINT ' '
 
    AFTER GROUP OF sr.ecu02
#No.FUN-580014--start
#     PRINT COLUMN 33,g_x[17] CLIPPED,
#           COLUMN 42,GROUP SUM(sr.ecb19) USING '#####.###',
#           COLUMN 56,GROUP SUM(sr.ecb38) USING '###.###',
#           COLUMN 68,GROUP SUM(sr.ecb21) USING '#####.###'
      PRINTX name=S1
            COLUMN g_c[34],g_x[17] CLIPPED,
            COLUMN g_c[35],GROUP SUM(sr.ecb19) USING '###########.###',
            COLUMN g_c[36],GROUP SUM(sr.ecb38) USING '###########.###',
            COLUMN g_c[37],GROUP SUM(sr.ecb21) USING '###########.###'
#No.FUN-580014--end
      PRINT ''
    ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
     IF l_last_sw = 'n' THEN
        PRINT g_dash[1,g_len]
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
     ELSE
        SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610037 <> #
