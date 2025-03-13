# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: gxcr100.4gl
# Descriptions...: 月底結存明細表
# Input parameter:
# Return code....:
# Date & Author..: 03/12/23 By Hawk
# Modify.........: No.FUN-4C0099 05/01/27 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-550025 05/05/17 by day   單據編號加大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-630003 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-830156 08/04/09 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80044 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
                wc      LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(600) 
                yy      LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
                mm      LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
                more    LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
              END RECORD
   DEFINE g_argv1   LIKE cxb_file.cxb01,        #NO.FUN-680145 VARCHAR(20)
          g_argv2   LIKE type_file.num5,        #NO.FUN-680145 SMALLINT
          g_argv3   LIKE type_file.num5         #NO.FUN-680145 SMALLINT
DEFINE   g_i        LIKE type_file.num5         #NO.FUN-680145 SMALLINT   #count/index for any purpose
DEFINE   g_str      STRING     #FUN-830156
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXC")) THEN
      EXIT PROGRAM
   END IF
   #TQC-630003-begin
   #INITIALIZE tm.* TO NULL
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_trace = 'N'
   #LET g_argv1 = ARG_VAL(1)
   #LET g_argv2 = ARG_VAL(2)
   #LET g_argv3 = ARG_VAL(3)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(4)
   #LET g_rep_clas = ARG_VAL(5)
   #LET g_template = ARG_VAL(6)
   ##No.FUN-570264 ---end---
   #IF cl_null(g_argv1)
   #   THEN CALL gxcr100_tm(0,0)
   #   ELSE LET tm.wc=" cxb01='",g_argv1,"'"
   #        LET tm.yy=g_argv2
   #        LET tm.mm=g_argv3
   #        CALL gxcr100()
   #END IF
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)    
   LET tm.yy    = ARG_VAL(8)    
   LET tm.mm    = ARG_VAL(9)       
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  # No.FUN-B80044--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL gxcr100_tm(0,0)          # Input print condition
   ELSE
      CALL gxcr100()                # Read data and create out-file
   END IF
   #TQC-630003-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044--add--
END MAIN
 
FUNCTION gxcr100_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW gxcr100_w AT p_row,p_col
        WITH FORM "gxc/42f/gxcr100"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL cl_opmsg('p')
   #TQC-630003-begin
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_trace = 'N'
   #TQC-630003-end
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   WHILE TRUE
 #MOD-530122
      CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima09,ima11,
                                 ima39,ima06,ima10,ima12
##
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
 
#No.FUN-570240 --start
     ON ACTION controlp
        IF INFIELD(ima01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima01
           NEXT FIELD ima01
        END IF
#No.FUN-570240 --end
 
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
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW gxcr100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044--add--
         EXIT PROGRAM
      END IF
      INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD mm
           IF tm.mm < 1 OR tm.mm >12 THEN NEXT FIELD mm END IF
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
           END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLT
         LET g_trace = 'Y'    # Trace on
 
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
         LET INT_FLAG = 0 CLOSE WINDOW gxcr100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044--add--
         EXIT PROGRAM
      END IF
         IF g_bgjob = 'Y' THEN
            SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='gxcr100'
            IF SQLCA.sqlcode OR l_cmd IS NULL THEN
               CALL cl_err('gxcr100','9031',1)
            ELSE
               LET tm.wc = cl_wcsub(tm.wc)
               LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-630003-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         #TQC-630003-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
               IF g_trace = 'Y' THEN ERROR l_cmd END IF
               CALL cl_cmdat('gxcr100',g_time,l_cmd)
            END IF
            CLOSE WINDOW gxcr100_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80044--add--
            EXIT PROGRAM
         END IF
         CALL cl_wait()
         CALL gxcr100()
         ERROR ""
   END WHILE
   CLOSE WINDOW gxcr100_w
END FUNCTION
#NO.FUN-830156---BEGIN----
FUNCTION gxcr100()
   DEFINE l_name    LIKE type_file.chr20,   #NO.FUN-680145 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0099
          l_sql     LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(40)
          sr        RECORD
                    cxb        RECORD LIKE cxb_file.*,
                    ima02      LIKE ima_file.ima02,
                    ima021      LIKE ima_file.ima021,
                    up         LIKE ccc_file.ccc23
                    END RECORD
 
     # No.FUN-B80044---start mark------------------------------------------------------------------
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     # No.FUN-B80044---end mark--------------------------------------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#    LET l_sql = "SELECT cxb_file.*,ima02,ima021,0 ",
#                 "  FROM cxb_file,ima_file ",
#                 " WHERE ima01 = cxb01 ",
#                 "   AND cxb02 = ",tm.yy,
#                 "   AND cxb03 = ",tm.mm,
#                 "   AND ",tm.wc CLIPPED
     LET l_sql = "SELECT cxb01,ima02,ima021,cxb04,cxb05,",
                 " cxb06,cxb07,cxb08,cxb09/cxb08 up,cxb09 ",                           
                 "  FROM cxb_file,ima_file ",                                   
                 " WHERE ima01 = cxb01 ",                                       
                 "   AND cxb02 = ",tm.yy,                                       
                 "   AND cxb03 = ",tm.mm,                                       
                 "   AND ",tm.wc CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'ima01,ima08,ima09,ima11,ima39,ima06,ima10,ima12')                                                                              
           RETURNING tm.wc            
     ELSE
        LET tm.wc = ""                                                                                                 
     END IF
     LET g_str = tm.wc,";",tm.yy,";",tm.mm,";",g_azi03,";",g_azi05
     CALL cl_prt_cs1('gxcr100','gxcr100',l_sql,g_str)
 
#    IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
#    PREPARE gxcr100_prepare1 FROM l_sql
#    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
#    DECLARE gxcr100_curs1 CURSOR FOR gxcr100_prepare1
 
#    CALL cl_outnam('gxcr100') RETURNING l_name
#    START REPORT gxcr100_rep TO l_name
#    LET g_pageno = 0
#    FOREACH gxcr100_curs1 INTO sr.*
#       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#       LET sr.up = sr.cxb.cxb09/sr.cxb.cxb08
#       IF cl_null(sr.up) THEN LET sr.up = 0 END IF
#       OUTPUT TO REPORT gxcr100_rep(sr.*)
#    END FOREACH
#    FINISH REPORT gxcr100_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
END FUNCTION
 
#REPORT gxcr100_rep(sr)
#  DEFINE qty,u_p,amt  LIKE alb_file.alb06    #NO.FUN-680145 DEC(20,6)
#  DEFINE l_last_sw    LIKE type_file.chr1,   #NO.FUN-680145 VARCHAR(1)
#         sr           RECORD
#                      cxb        RECORD LIKE cxb_file.*,
#                      ima02      LIKE ima_file.ima02,
#                      ima021      LIKE ima_file.ima021,
#                      up         LIKE ccc_file.ccc23
#                      END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.cxb.cxb01,sr.cxb.cxb04,sr.cxb.cxb05
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_x[11] CLIPPED,tm.yy USING '###&',
#           g_x[12] CLIPPED,tm.mm USING '#&'
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#No.FUN-550025-begin
#  BEFORE GROUP OF sr.cxb.cxb01
#     PRINT COLUMN g_c[31],sr.cxb.cxb01,
#           COLUMN g_c[32],sr.ima02,
#           COLUMN g_c[33],sr.ima021;
#No.FUN-550025-end
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[34],sr.cxb.cxb04,
#           COLUMN g_c[35],sr.cxb.cxb05,
#           COLUMN g_c[36],sr.cxb.cxb06,
#           COLUMN g_c[37],sr.cxb.cxb07 USING '###&',
#           COLUMN g_c[38],cl_numfor(sr.cxb.cxb08,38,0),
#           COLUMN g_c[39],cl_numfor(sr.up,39,g_azi03),
#           COLUMN g_c[40],cl_numfor(sr.cxb.cxb09,40,g_azi05)
#
#  AFTER GROUP OF sr.cxb.cxb01
#     PRINT COLUMN g_c[38],g_x[9] CLIPPED,
#           COLUMN g_c[39],cl_numfor(GROUP SUM(sr.cxb.cxb08),39,0),
#           COLUMN g_c[40],cl_numfor(GROUP SUM(sr.cxb.cxb09),40,g_azi05)
#     PRINT ''
 
#  ON LAST ROW
#     PRINT COLUMN g_c[38],g_x[10] CLIPPED,
#           COLUMN g_c[39],SUM(sr.cxb.cxb08) USING '##,###,###,##&',
#           COLUMN g_c[40],cl_numfor(SUM(sr.cxb.cxb09),40,g_azi05)
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-830156---END----
#Patch....NO.TQC-610037 <001> #
#No.FUN-870144
