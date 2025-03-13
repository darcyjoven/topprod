# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aqcr412.4gl
# Descriptions...: FQC不合格明細表(BY產品)
# Date & Author..: 96/04/09 By Iceman
# Modify.........: No.FUN-4C0099 05/01/28 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-850046 08/08/04 By lutingting報表轉為使用CR
# Modify.........: No.TQC-950135 09/06/05 By chenmoyan tm.s,tm.t與畫面欄位名稱不一致
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50053 10/05/25 By liuxqa 追单追单MOD-960174 & 追加修改OUTER
# Modify.........: No:TQC-B50110 11/05/19 By zhangll wc定義為STRING 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
             #wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)      # Where condition
              wc      STRING,                      #TQC-B50110 mod
              bdate   LIKE type_file.dat,          #No.FUN-680104 DATE
              edate   LIKE type_file.dat,          #No.FUN-680104 DATE
              s       LIKE type_file.chr3,         #No.FUN-680104 VARCHAR(3)       # Order by sequence
              t       LIKE type_file.chr3,         #No.FUN-680104 VARCHAR(3)     # Eject sw
              more    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_sql           STRING                 #No.FUN-850046
DEFINE   g_str           STRING                 #No.FUN-850046
DEFINE   l_table         STRING                 #No,FUN-850046
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
 
   #No.FUN-850046---start--
   LET g_sql = "qcf04.qcf_file.qcf04,", 
               "sfb22.sfb_file.sfb22,", 
               "qcf02.qcf_file.qcf02,", 
               "qcf01.qcf_file.qcf01,", 
               "oea04.oea_file.oea04,", 
               "occ02.occ_file.occ02,", 
               "qcf021.qcf_file.qcf021,",
               "ima02.ima_file.ima02"  
   LET l_table= cl_prt_temptable('aqcr412',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1)  EXIT PROGRAM 
   END IF
   #No.FUN-850046--end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------No.TQC-610086 modify
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.s      = ARG_VAL(10)
   LET tm.t      = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
#------------No.TQC-610086 modify
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aqcr412_tm(0,0)        # Input print condition
      ELSE CALL aqcr412()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION aqcr412_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row =4  LET p_col =20
 
   OPEN WINDOW aqcr412_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr412"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '32 '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
   CONSTRUCT BY NAME tm.wc ON qcf01,qcf02,qcf021
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
#No.FUN-570243 --start
     ON ACTION CONTROLP
          IF INFIELD(qcf021) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO qcf021
             NEXT FIELD qcf021
          END IF
#No.FUN-570243 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aqcr412_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
#  DISPLAY BY NAME tm.bdate,tm.edate,tm.s,tm.t,tm.more  #No.TQC-950135
   DISPLAY BY NAME tm.bdate,tm.edate,tm2.s1,tm2.s2,     #No.TQC-950135          
                   tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm.more  #No.TQC-950135
   INPUT BY NAME tm.bdate,tm.edate,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN CALL cl_err('','aap-099',0) NEXT FIELD
            bdate END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN CALL cl_err('','aap-099',0) NEXT FIELD
            edate END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW aqcr412_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aqcr412'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr412','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aqcr412',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aqcr412_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aqcr412()
   ERROR ""
END WHILE
   CLOSE WINDOW aqcr412_w
END FUNCTION
 
FUNCTION aqcr412()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
         #l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1100)
          l_sql     STRING,                     #TQC-B50110 mod
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,        #No.FUN-680104 VARCHAR(40)
          l_order   ARRAY[4] OF LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
          sr               RECORD order1 LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
                                  order2 LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
                                  order3 LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
                                  qcf04  LIKE qcf_file.qcf04,
                                  sfb22  LIKE sfb_file.sfb22,
                                  qcf02  LIKE qcf_file.qcf02,
                                  qcf01  LIKE qcf_file.qcf01,
                                  qcf021 LIKE qcf_file.qcf021,
                                  ima02  LIKE ima_file.ima02,
                                  azf03  LIKE azf_file.azf03,
                                  oea04  LIKE oea_file.oea04,
                                  occ02  LIKE occ_file.occ02,
                                  code   LIKE type_file.chr2         #No.FUN-680104 VARCHAR(02)
                        END RECORD
 
     CALL cl_del_data(l_table)   #No.FUN-850046
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aqcr412'   #No.FUN-850046
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcfuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "       qcf04,sfb22,qcf02,qcf01,qcf021,ima02,",
#FUN-A50053 mod --str
                 #"       '',oea04,occ02,''",
                 #"  FROM qcf_file,sfb_file,occ_file,oea_file,OUTER ima_file",
                 "       '','','',''",
                 "  FROM sfb_file,qcf_file LEFT OUTER JOIN ima_file ON qcf021 = ima01 ",
#FUN-A50053 mod --end            
                 "  WHERE qcf04 BETWEEN '",tm.bdate,"'AND '",tm.edate,"'",
                 "        AND qcf09 = '2' ",
                 #"        AND ima_file.ima01 = qcf_file.qcf021 ",  #FUN-A50053 mark
                 "        AND qcf02 = sfb01 ",
                 #"        AND sfb22 = oea01 ",    #FUN-A50053 mark
                 #"        AND oea04 = occ01 ",    #FUN-A50053 mark
                 "        AND qcf14='Y' AND qcf18='1' ",
                 "        AND ",tm.wc CLIPPED,
                 " ORDER BY qcf021 "
 
     PREPARE aqcr412_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
           
     END IF
     DECLARE aqcr412_curs1 CURSOR FOR aqcr412_prepare1
      #CALL cl_outnam('aqcr412') RETURNING l_name     #No.FUN-850046   
     #START REPORT aqcr412_rep TO l_name            #No.FUN-850046
     LET g_pageno = 0
     FOREACH aqcr412_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.SQLCODE,1)
          EXIT FOREACH
       END IF

       #FUN-A50053 add --str--
       IF NOT cl_null(sr.sfb22) THEN
          SELECT oea04,occ02 INTO sr.oea04,sr.occ02
                 FROM oea_file,occ_file
                  WHERE oea01 = sr.sfb22
                    AND oea04 = occ01
       END IF
       #FUN-A50053 add --end 

       #No.FUN-850046---start--
       #FOR g_i = 1 TO 3
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.qcf01
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.qcf02
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.qcf021
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #LET sr.order3 = l_order[3]
       #OUTPUT TO REPORT aqcr412_rep(sr.*)
       EXECUTE insert_prep USING
           sr.qcf04,sr.sfb22,sr.qcf02,sr.qcf01,sr.oea04,sr.occ02,
           sr.qcf021,sr.ima02
       #No.FUN-850046--end       
     END FOREACH
     
     #No.FUN-850046---start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'qcf01,qcf02,qcf021')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('aqcr412','aqcr412',g_sql,g_str)
     #FINISH REPORT aqcr412_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850046--end         
END FUNCTION
 
#No.FUN-850046---start--
#REPORT aqcr412_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
#          sr               RECORD order1 LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
#                                  order2 LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
#                                  order3 LIKE qcf_file.qcf021,       #No.FUN-680104 VARCHAR(40) #FUN-5B0105 10->40
#                                  qcf04  LIKE qcf_file.qcf04,
#                                  sfb22  LIKE sfb_file.sfb22,
#                                  qcf02  LIKE qcf_file.qcf02,
#                                  qcf01  LIKE qcf_file.qcf01,
#                                  qcf021 LIKE qcf_file.qcf021,
#                                  ima02  LIKE ima_file.ima02,
#                                  azf03  LIKE azf_file.azf03,
#                                  oea04  LIKE oea_file.oea04,
#                                  occ02  LIKE occ_file.occ02,
#                                  code   LIKE type_file.chr2         #No.FUN-680104 VARCHAR(02)
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.qcf021,sr.code,sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[8] CLIPPED, tm.bdate ,'-',tm.edate CLIPPED
#      PRINT g_dash
#      PRINT g_x[11] CLIPPED,sr.qcf021
#      PRINT COLUMN 10, sr.ima02
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
#         SKIP TO TOP OF PAGE
#     END IF
#
#   BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
#        SKIP TO TOP OF PAGE
#     END IF
#
#   BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
#        SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.qcf021
#       SKIP TO TOP OF PAGE
##       PRINT g_x[15] CLIPPED,sr.qcf021
##       PRINT COLUMN 10, sr.ima02
##       PRINT ''
##  BEFORE GROUP OF sr.code
##  	SKIP 1 LINE
##       PRINT COLUMN 10,g_x[11] CLIPPED,2 SPACES  ,
##             g_x[13] CLIPPED
##     PRINT COLUMN 10,"-------- ---------- ---------- ---------- ",
##                     "--------"
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.qcf04,
#            COLUMN g_c[32],sr.sfb22,
#            COLUMN g_c[33],sr.qcf02,
#            COLUMN g_c[34],sr.qcf01,
#            COLUMN g_c[35],sr.oea04,
#            COLUMN g_c[36],sr.occ02
#   AFTER  GROUP OF sr.code
#           SKIP 1 LINE
#   ON LAST ROW
#      	   PRINT g_dash
#           LET l_last_sw = 'y'
#           PRINT g_x[4],COLUMN (g_len-9), g_x[7] CLIPPED
#   PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#           PRINT g_dash
#           PRINT g_x[4], COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#           SKIP 2 LINE
#       END IF
#END REPORT
#No.FUN-850046---end
