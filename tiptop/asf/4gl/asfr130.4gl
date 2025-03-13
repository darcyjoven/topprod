# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfr130.4gl
# Descriptions...: 工單排程表
# Date & Author..: 94/07/01 By DANNY
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.MOD-530750 05/03/28 By Carol 1.工單編號需增加查詢功能。
#                                                  2.工單編號:511-530006，在列印時會出現生產數量負值之不正常情形
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: NO.MOD-6B0097 06/11/20 By Claire MOD-530750調整
# Modify.........: NO.TQC-6C0222 07/01/11 By Ray 報表問題調整
# Modify..........:No.TQC-960161 09/06/15 By lilingyu 增加一個falg:是否包含未審核工單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                # Print condition RECORD
#             wc       VARCHAR(600),      # Where condition   #TQC-630166
              wc       STRING,         # Where condition   #TQC-630166
              s        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Order by sequence
              t        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Eject sw
              u        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Group total sw
              more     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              flag     LIKE type_file.chr1           #TQC-960161              
              END RECORD,
         g_tot_bal     LIKE ccq_file.ccq03         #No.FUN-680121 DECIMAL(13,2)# User defined variable
DEFINE   g_i           LIKE type_file.num5         #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_orderA ARRAY[3] OF LIKE sfb_file.sfb05  #No.FUN-680121 VARCHAR(40)# 篩選排序條件用變數#FUN-5B0105 10->40
DEFINE   g_head1       STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
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
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET tm.flag = ARG_VAL(14)         #TQC-960161   
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asfr130_tm(0,0)        # Input print condition
      ELSE CALL asfr130()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr130_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000          #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW asfr130_w AT p_row,p_col
        WITH FORM "asf/42f/asfr130"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '142'
   LET tm.more = 'N'
   LET tm.flag = 'N'                    #TQC-960161   
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
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfb82,sfb01,sfb25,sfb13,sfb15,sfb05
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(sfb82) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb82
              NEXT FIELD sfb82
           END IF
 #MOD-530750
           IF INFIELD(sfb01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sfb"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb01
              NEXT FIELD sfb01
           END IF
##
           IF INFIELD(sfb05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
 
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.wc = ' 1=1' THEN
        CALL cl_err('','9046',0)
        CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3,
                     tm2.t1,tm2.t2,tm2.t3,
                     tm2.u1,tm2.u2,tm2.u3,
                     tm.flag,                #TQC-960161                     
                     tm.more         # Condition
 
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.flag,                    #TQC-960161                   
                   tm.more  WITHOUT DEFAULTS
 
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
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
        AFTER INPUT
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
           LET tm.t = tm2.t1,tm2.t2,tm2.t3
           LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfr130'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr130','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_lang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.s CLIPPED,"'",
                           " '",tm.t CLIPPED,"'",
                           " '",tm.u CLIPPED,"'",
                           " '",tm.flag CLIPPED,"'",            #TQC-960161                            
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
           CALL cl_cmdat('asfr130',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asfr130_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfr130()
     ERROR ""
   END WHILE
   CLOSE WINDOW asfr130_w
 
END FUNCTION
 
FUNCTION asfr130()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE sfb_file.sfb05,                #No.FUN-680121 VARCHAR(40)#FUN-5B0105 10->40
          sr               RECORD order1 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order2 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order3 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  sfb82 LIKE sfb_file.sfb82,    #
                                  sfb01 LIKE sfb_file.sfb01,
                                  sfb25 LIKE sfb_file.sfb25,
                                  sfb13 LIKE sfb_file.sfb13,
                                  sfb15 LIKE sfb_file.sfb15,
                                  sfb05 LIKE sfb_file.sfb05,
                                  sfb02 LIKE sfb_file.sfb02,
                                  sfb08 LIKE sfb_file.sfb08,
                                  ima02 LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,
                                  ima55 LIKE ima_file.ima55
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
 
 IF tm.flag = 'Y' then                                        #TQC-960161  
     LET l_sql = "SELECT '','','',",
                 "  sfb82, sfb01, sfb25, sfb13, sfb15, sfb05,",
                 "  sfb02, sfb08-(sfb09+sfb10+sfb11+sfb12),",  #MOD-530750 #MOD-6B0097 取消mark
                #"  sfb02, sfb08,",                            #MOD-530750 #MOD-6B0097 mark
                 "  ima02, ima021, ima55 ",
                 "  FROM sfb_file, OUTER ima_file ",
                 " WHERE  sfb_file.sfb05 = ima_file.ima01  AND sfb87!='X' ",        
                 "   AND ",tm.wc CLIPPED
#TQC-960161 --begin--
 ELSE
      LET l_sql = "SELECT '','','',",
                 "  sfb82, sfb01, sfb25, sfb13, sfb15, sfb05,",
                 "  sfb02, sfb08-(sfb09+sfb10+sfb11+sfb12),",  
                 "  ima02, ima021, ima55 ",
                 "  FROM sfb_file, OUTER ima_file ",
                 " WHERE sfb05 = ima01 AND sfb87 ='Y' ",        
                 "   AND ",tm.wc CLIPPED
 END IF               
#TQC-960161 --end--  
 
     PREPARE asfr130_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE asfr130_curs1 CURSOR FOR asfr130_prepare1
 
     CALL cl_outnam('asfr130') RETURNING l_name
     START REPORT asfr130_rep TO l_name
 
     LET g_pageno = 0
     FOREACH asfr130_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1'
                    LET l_order[g_i] = sr.sfb82
                    LET g_orderA[g_i]= g_x[11] CLIPPED
               WHEN tm.s[g_i,g_i] = '2'
                    LET l_order[g_i] = sr.sfb01
                    LET g_orderA[g_i]= g_x[12] CLIPPED
               WHEN tm.s[g_i,g_i] = '3'
                    LET l_order[g_i] = sr.sfb25 USING 'YYYYMMDD'
                    LET g_orderA[g_i]= g_x[13] CLIPPED
               WHEN tm.s[g_i,g_i] = '4'
                    LET l_order[g_i] = sr.sfb13 USING 'YYYYMMDD'
                    LET g_orderA[g_i]= g_x[14] CLIPPED
               WHEN tm.s[g_i,g_i] = '5'
                    LET l_order[g_i] = sr.sfb15 USING 'YYYYMMDD'
                    LET g_orderA[g_i]= g_x[15] CLIPPED
               WHEN tm.s[g_i,g_i] = '6'
                    LET l_order[g_i] = sr.sfb05
                    LET g_orderA[g_i]= g_x[16] CLIPPED
               OTHERWISE
                    LET l_order[g_i] = '-'
                    LET g_orderA[g_i]= ''
          END CASE
 
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT asfr130_rep(sr.*)
     END FOREACH
 
     FINISH REPORT asfr130_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT asfr130_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,                          #No.FUN-680121 VARCHAR(1)
          sr               RECORD order1 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order2 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order3 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  sfb82 LIKE sfb_file.sfb82,
                                  sfb01 LIKE sfb_file.sfb01,
                                  sfb25 LIKE sfb_file.sfb25,
                                  sfb13 LIKE sfb_file.sfb13,
                                  sfb15 LIKE sfb_file.sfb15,
                                  sfb05 LIKE sfb_file.sfb05,
                                  sfb02 LIKE sfb_file.sfb02,
                                  sfb08 LIKE sfb_file.sfb08,
                                  ima02 LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,
                                  ima55 LIKE ima_file.ima55
                        END RECORD,
      l_gem02      LIKE gem_file.gem02,
      l_str        LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.sfb82
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[10] CLIPPED,
                    g_orderA[1] CLIPPED,'-',
                    g_orderA[2] CLIPPED,'-',
                    g_orderA[3] CLIPPED
      PRINT g_head1
 
      PRINT g_dash
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41],
            g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND(PAGENO > 0 OR LINENO > 9) THEN     #No.TQC-6C0222
            SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 0 OR LINENO > 9) THEN     #No.TQC-6C0222
            SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 0 OR LINENO > 9) THEN     #No.TQC-6C0222
           SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      CALL s_wotype(sr.sfb02) RETURNING l_str
      LET l_gem02 = ''
      IF NOT cl_null(sr.sfb82) THEN
         SELECT gem02 INTO l_gem02 FROM gem_file
          WHERE gem01 = sr.sfb82
         IF cl_null(l_gem02) THEN
            SELECT pmc03 INTO l_gem02 FROM pmc_file
             WHERE pmc01 = sr.sfb82
         END IF
      END IF
 
      PRINT COLUMN g_c[31],sr.sfb82,
            COLUMN g_c[32],l_gem02 CLIPPED,
            COLUMN g_c[33],sr.sfb01,
            COLUMN g_c[34],l_str CLIPPED,
            COLUMN g_c[35],sr.sfb25,
            COLUMN g_c[36],sr.sfb13,
            COLUMN g_c[37],sr.sfb15,
            COLUMN g_c[38],sr.sfb05,
            COLUMN g_c[39],sr.ima02,
            COLUMN g_c[40],sr.ima021,
            COLUMN g_c[41],sr.sfb08 USING '-----------&.&&',
            COLUMN g_c[42],sr.ima55
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         PRINT g_dash2
         LET l_str = g_orderA[1] CLIPPED,g_x[09] CLIPPED
         PRINT COLUMN g_c[40],l_str CLIPPED,
               COLUMN g_c[41],GROUP SUM(sr.sfb08) USING '-----------&.&&'
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         PRINT g_dash2
         LET l_str = g_orderA[2] CLIPPED,g_x[09] CLIPPED
         PRINT COLUMN g_c[40],l_str CLIPPED,
               COLUMN g_c[41],GROUP SUM(sr.sfb08) USING '-----------&.&&'
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         PRINT g_dash2
         LET l_str = g_orderA[3] CLIPPED,g_x[09] CLIPPED
         PRINT COLUMN g_c[40],l_str CLIPPED,
               COLUMN g_c[41],GROUP SUM(sr.sfb08) USING '-----------&.&&'
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb82,sfb01,sfb25,sfb13,sfb15,sfb05')
              RETURNING tm.wc
         PRINT g_dash
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#            IF tm.wc[001,120] > ' ' THEN            # for 132
#        PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#            IF tm.wc[121,240] > ' ' THEN
#        PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#           IF tm.wc[241,300] > ' ' THEN
#        PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-6C0222
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-6C0222
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
