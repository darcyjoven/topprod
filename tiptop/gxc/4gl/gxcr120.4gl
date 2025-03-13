# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gxcr120.4gl
# Descriptions...: 采購倉退成本與AP差異表
# Input parameter:
# Return code....:
# Date & Author..: 04/03/02 By Elva
# Modify.........: No.FUN-4C0099 05/01/28 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-630003 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-750093 07/06/27 By jan 報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/20 By jan 打印條件修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80044 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(600)     # Where condition
              yy,mm   LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
              more    LIKE type_file.chr1          #NO.FUN-680145 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD,
          b_date,e_date    LIKE type_file.dat,     #NO.FUN-680145 DATE
       g_tot_bal        LIKE eca_file.eca60     #NO.FUN-680145 DEC(13,2)     # User defined variable
   DEFINE g_argv1          LIKE ima_file.ima01     #NO.FUN-680145 VARCHAR(20)
   DEFINE g_argv2          LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE g_argv3          LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE   g_i               LIKE type_file.num5     #NO.FUN-680145 SMALLINT       #count/index for any purpose
   DEFINE g_str        STRING       #No.FUN-750093
   DEFINE l_table      STRING       #No.FUN-750093
   DEFINE g_sql        STRING       #No.FUN-750093
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXC")) THEN
      EXIT PROGRAM
   END IF
   #TQC-630003-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_trace = 'N'                # default trace off
   #LET g_argv1 = ARG_VAL(1)        # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)        # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)        # Get arguments from command line
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(4)
   #LET g_rep_clas = ARG_VAL(5)
   #LET g_template = ARG_VAL(6)
   ##No.FUN-570264 ---end---
   #IF cl_null(g_argv1)
   # Prog. Version..: '5.30.06-13.03.12(0,0)        # Input print condition
   #   ELSE LET tm.wc=" ima01='",g_argv1,"'"
   #        LET tm.yy=g_argv2
   #        LET tm.mm=g_argv3
   #        CALL gxcr120()            # Read data and create out-file
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
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  # FUN_B80044--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL gxcr120_tm(0,0)          # Input print condition
   ELSE
      CALL gxcr120()                # Read data and create out-file
   END IF
   #TQC-630003-begin
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  # FUN_B80044--add--
END MAIN
 
FUNCTION gxcr120_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680145 VARCHAR(400)
 
IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW gxcr120_w AT p_row,p_col
        WITH FORM "gxc/42f/gxcr120"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL cl_opmsg('p')
   #TQC-630003-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_trace = 'N'                # default trace off
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
      LET INT_FLAG = 0 CLOSE WINDOW gxcr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   # No.FUN-B80044--add-------
      EXIT PROGRAM
   END IF
 
   INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD mm
         IF  tm.mm < 1 OR tm.mm > 13 THEN NEXT FIELD mm END IF
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
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
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
      LET INT_FLAG = 0 CLOSE WINDOW gxcr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   # No.FUN-B80044--add-------
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gxcr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gxcr120','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",                #TQC-630003 
                         " '",tm.mm CLIPPED,"'",                #TQC-630003
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gxcr120',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gxcr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   # No.FUN-B80044--add-------
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gxcr120()
   ERROR ""
END WHILE
   CLOSE WINDOW gxcr120_w
END FUNCTION
 
FUNCTION gxcr120()
   DEFINE l_name    LIKE type_file.chr20,    #NO.FUN-680145 VARCHAR(20)      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0099
          l_sql     LIKE type_file.chr1000,  #NO.FUN-680145 VARCHAR(1200)    # RDSQL STATEMENT
          l_za05    LIKE type_file.chr1000,  #NO.FUN-680145 VARCHAR(40)
          sr        RECORD
                    ima01      LIKE ima_file.ima01,
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021,
                    tlf905     LIKE tlf_file.tlf905,
                    tlf906     LIKE tlf_file.tlf906,
                    apb01      LIKE apb_file.apb01,
                    apb02      LIKE apb_file.apb02,
                    apb09      LIKE apb_file.apb09,
                    tlf21      LIKE tlf_file.tlf21,
                    apb10      LIKE apb_file.apb10
                    END RECORD
 
#No.FUN-750093--Begin
     LET g_sql = " ima01.ima_file.ima01,",
                 " ima02.ima_file.ima02,",
                 " ima021.ima_file.ima021,",
                 " tlf905.tlf_file.tlf905,",
                 " tlf906.tlf_file.tlf906,",
                 " apb01.apb_file.apb01,",
                 " apb02.apb_file.apb02,",
                 " apb09.apb_file.apb09,",
                 " apb10.apb_file.apb10,",
                 " tlf21.tlf_file.tlf21"
 
     LET l_table = cl_prt_temptable('gxcr120',g_sql) CLIPPED
     IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   # No.FUN-B80044--add-------
        EXIT PROGRAM 
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   # No.FUN-B80044--add-------
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-750093--End
     # No.FUN-B80044--------mark------------------------------------------------------------------
     # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     # No.FUN-B80044--------mark------------------------------------------------------------------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL s_azn01(tm.yy,tm.mm) RETURNING b_date,e_date
 
     LET l_sql = "SELECT ima01,ima02,ima021,tlf905,tlf906,apb01,apb02,apb09,tlf21,apb10 ",
                 "  FROM ima_file,tlf_file,apb_file ",
                 " WHERE ima01 = tlf01 ",
                 "   AND apb21 = tlf905 ",
                 "   AND apb22 = tlf906 ",
                 "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
                 "   AND tlf02 = 50 AND (tlf03 >= 30 AND tlf03 <= 32) ",
                 "   AND ",tm.wc CLIPPED
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE gxcr120_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   # No.FUN-B80044---add-----
        EXIT PROGRAM 
     END IF
     DECLARE gxcr120_curs1 CURSOR FOR gxcr120_prepare1
 
#    CALL cl_outnam('gxcr120') RETURNING l_name     #No.FUN-750093
#    START REPORT gxcr120_rep TO l_name             #No.FUN-750093
     LET g_pageno = 0
     FOREACH gxcr120_curs1 INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-750093--Begin
#       OUTPUT TO REPORT gxcr120_rep(sr.*)
        EXECUTE insert_prep USING
                sr.ima01,sr.ima02,sr.ima021,sr.tlf905,sr.tlf906,sr.apb01,sr.apb02,
                sr.apb09,sr.apb10,sr.tlf21
     END FOREACH
 
#    FINISH REPORT gxcr120_rep
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
#No.FUN-760086--Begin                                                           
    IF g_zz05 = 'Y' THEN                                                         
         CALL cl_wcchp(tm.wc,'ima01,ima08,ima09,ima11,ima39,ima06,ima10,ima12')                        
               RETURNING g_str
    END IF
     LET g_str = tm.yy,";",tm.mm,";",g_azi04,";",g_str
#No.FUN-760086--End
     CALL cl_prt_cs3('gxcr120','gxcr120',l_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)          
#No.FUN-750093--End                      
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0099
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT gxcr120_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,     #NO.FUN-680145 VARCHAR(1)  #TQC-840066
          sr           RECORD
                       ima01      LIKE ima_file.ima01,
                       ima02      LIKE ima_file.ima02,
                       ima021     LIKE ima_file.ima021,
                       tlf905     LIKE tlf_file.tlf905,
                       tlf906     LIKE tlf_file.tlf906,
                       apb01      LIKE apb_file.apb01,
                       apb02      LIKE apb_file.apb02,
                       apb09      LIKE apb_file.apb09,
                       tlf21      LIKE tlf_file.tlf21,
                       apb10      LIKE apb_file.apb10
                       END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ima01,sr.tlf905,sr.tlf906
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[11] CLIPPED,tm.yy USING '###&',
            g_x[12] CLIPPED,tm.mm USING '#&'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ima01
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021;
 
   ON EVERY ROW
      PRINT COLUMN g_c[34],sr.tlf905,
            COLUMN g_c[35],sr.tlf906 USING '###&',
            COLUMN g_c[36],sr.apb01,
            COLUMN g_c[37],sr.apb02 USING '###&',
            COLUMN g_c[38],cl_numfor(sr.apb09,38,0),
            COLUMN g_c[39],cl_numfor(sr.apb10,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.tlf21,40,g_azi04),
            COLUMN g_c[41],cl_numfor(sr.apb10-sr.tlf21,41,g_azi04)
 
   AFTER GROUP OF sr.ima01
      PRINT COLUMN g_c[36],g_x[9] CLIPPED,
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.apb09),38,0),
            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.apb10),39,g_azi04),
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.tlf21),40,g_azi04),
            COLUMN g_c[41],cl_numfor(GROUP SUM(sr.apb10-sr.tlf21),41,g_azi04)
      PRINT ''
 
   ON LAST ROW
      PRINT COLUMN g_c[36],g_x[10] CLIPPED,
            COLUMN g_c[38],cl_numfor(SUM(sr.apb09),38,0),
            COLUMN g_c[39],cl_numfor(SUM(sr.apb10),39,g_azi04),
            COLUMN g_c[40],cl_numfor(SUM(sr.tlf21),40,g_azi04),
            COLUMN g_c[41],cl_numfor(SUM(sr.apb10-sr.tlf21),41,g_azi04)
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093--End
#Patch....NO.TQC-610037 <001> #
