# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asrr320.4gl
# Descriptions...: 完工入庫單據列印
# Date & Author..: 2006/02/23  By  Joe
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.FUN-7C0034 07/12/11 By mike 報表輸出方式改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5      #No.FUN-680130 SMALLINT 
END GLOBALS
 
DEFINE tm  RECORD                   # Print condition RECORD
           wc        STRING,                      # Where condition #TQC-630166   
           more      LIKE type_file.chr1          # Input more condition(Y/N) #No.FUN-680130 VARCHAR(1)
           END RECORD
DEFINE g_sfu00       LIKE sfu_file.sfu00
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose     #No.FUN-680130 SMALLINT
DEFINE g_sma115      LIKE sma_file.sma115
DEFINE g_sma116      LIKE sma_file.sma116
DEFINE g_sql         STRING                  #No.FUN-7C0034
DEFINE g_str         STRING                  #No.FUN-7C0034
DEFINE l_table       STRING                  #No.FUN-7C0034
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   LET g_prog = ARG_VAL(1)
   LET g_sfu00 = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)            # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   #No.FUN-7C0034 --START--
   LET g_sql = "sfu00.sfu_file.sfu00,",
               "sfu01.sfu_file.sfu01,",
               "sfu02.sfu_file.sfu02,",
               "sfv17.sfv_file.sfv17,",
               "sfu04.sfu_file.sfu04,",
               "gem02.gem_file.gem02,",
               "sfu05.sfu_file.sfu05,",
               "azf03.azf_file.azf03,",
               "sfu06.sfu_file.sfu06,",
               "sfu07.sfu_file.sfu07,",
               "sfv03.sfv_file.sfv03,",
               "sfv11.sfv_file.sfv11,",
               "sfv04.sfv_file.sfv04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "sfv14.sfv_file.sfv14,",
               "sfv15.sfv_file.sfv15,",
               "sfv08.sfv_file.sfv08,",
               "sfv05.sfv_file.sfv05,",
               "sfv06.sfv_file.sfv06,",
               "sfv07.sfv_file.sfv07,",
               "sfv09.sfv_file.sfv09,",
               "sfv13.sfv_file.sfv13,",
               "sfv12.sfv_file.sfv12,",
               "sfv30.sfv_file.sfv30,",
               "sfv31.sfv_file.sfv31,",
               "sfv32.sfv_file.sfv32,",
               "sfv33.sfv_file.sfv33,",
               "sfv34.sfv_file.sfv34,",
               "sfv35.sfv_file.sfv35,",
               "l_str2.type_file.chr1000"
   
   LET l_table = cl_prt_temptable("asrr320",g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0034 --END--
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r320_tm(0,0)              # Input print condition
      ELSE CALL r320()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r320_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r320_w AT p_row,p_col WITH FORM "asr/42f/asrr320"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_set_locale_frm_name("asrr320")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfu01,sfv11,sfu02
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION CONTROLP
       CASE WHEN INFIELD(sfu01)      #入庫單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_sfu1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfu01
                 NEXT FIELD sfu01
            WHEN INFIELD(sfv11)      #生產料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfv11
                 NEXT FIELD sfv11
 
       OTHERWISE EXIT CASE
       END CASE
     ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
     ON ACTION help           #No.TQC-770003                                                                                                     
        CALL cl_show_help()   #No.TQC-770003
 
     ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
     ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01=g_prog
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asrr320','9031',1)   
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
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('asrr320',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r320_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r320()
   ERROR ""
END WHILE
   CLOSE WINDOW r320_w
END FUNCTION
 
FUNCTION r320()
   DEFINE l_name    LIKE type_file.chr20,  # External(Disk) file name     #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,# RDSQL STATEMENT              #No.FUN-680130 VARCHAR(1200)
          l_za05    LIKE za_file.za05,                                    #No.FUN-680130 VARCHAR(20)
          sr        RECORD
                    sfu00   LIKE sfu_file.sfu00,
                    sfu01   LIKE sfu_file.sfu01,
                    sfu02   LIKE sfu_file.sfu02,
                    sfv17   LIKE sfv_file.sfv17,
                    sfu04   LIKE sfu_file.sfu04,
                    gem02   LIKE gem_file.gem02,
                    sfu05   LIKE sfu_file.sfu05,
                    azf03   LIKE azf_file.azf03,
                    sfu06   LIKE sfu_file.sfu06,
                    sfu07   LIKE sfu_file.sfu07,
                    sfv03   LIKE sfv_file.sfv03,
                    sfv11   LIKE sfv_file.sfv11,
                    sfv04   LIKE sfv_file.sfv04,
                    ima02   LIKE ima_file.ima02,
                    ima021  LIKE ima_file.ima021,
                    sfv14   LIKE sfv_file.sfv14,
                    sfv15   LIKE sfv_file.sfv15,
                    sfv08   LIKE sfv_file.sfv08,
                    sfv05   LIKE sfv_file.sfv05,
                    sfv06   LIKE sfv_file.sfv06,
                    sfv07   LIKE sfv_file.sfv07,
                    sfv09   LIKE sfv_file.sfv09,
                    sfv13   LIKE sfv_file.sfv13,
                    sfv12   LIKE sfv_file.sfv12,
                    sfv30   LIKE sfv_file.sfv30,
                    sfv31   LIKE sfv_file.sfv31,
                    sfv32   LIKE sfv_file.sfv32,
                    sfv33   LIKE sfv_file.sfv33,
                    sfv34   LIKE sfv_file.sfv34,
                    sfv35   LIKE sfv_file.sfv35
                    END RECORD
     DEFINE l_prog          STRING
     DEFINE l_i,l_cnt       LIKE type_file.num5      #No.FUN-680130 SMALLINT
     DEFINE l_zaa02         LIKE zaa_file.zaa02
     DEFINE l_str2        LIKE type_file.chr1000,    #No.FUN-7C0034                                                       
            l_sfv35       STRING,                    #No.FUN-7C0034                                                                                
            l_sfv32       STRING                     #No.FUN-7C0034                                                                                
     DEFINE l_ima906      LIKE ima_file.ima906       #No.FUN-7C0034
 
     CALL cl_del_data(l_table)                        #No.FUN-7C0034
     
     # No.FUN-B80063----start mark------------------------------------ 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
     # No.FUN-B80063----end mark--------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfuuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT sfu00,sfu01,sfu02,sfv17,sfu04,'',sfu05,'',",
                 "sfu06,sfu07,sfv03,sfv11,sfv04,'','',sfv14,sfv15,sfv08,",
                 "sfv05,sfv06,sfv07,sfv09,sfv13,sfv12,",
                 "sfv30,sfv31,sfv32,sfv33,sfv34,sfv35 ",
                 " FROM sfu_file, sfv_file ",
                 " WHERE sfu01 = sfv01 ",
                 "   AND sfuconf<>'X' ", #FUN-660137
                 "   AND sfu00='3' AND ",tm.wc clipped
 
     PREPARE r320_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM
     END IF
     DECLARE r320_curs1 CURSOR FOR r320_prepare1
 
     #CALL cl_outnam("asrr320") RETURNING l_name       #No.FUN-7C0034
     
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
 
     #CALL cl_prt_pos_len()                            #No.FUN-7C0034
     #START REPORT r320_rep TO l_name                  #No.FUN-7C0034
     #LET g_pageno = 0                                 #No.FUN-7C0034
 
     FOREACH r320_curs1 INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)   
             EXIT FOREACH
          END IF
          SELECT gem02 INTO sr.gem02
             FROM gem_file
            WHERE gem01 = sr.sfu04
          IF SQLCA.sqlcode THEN
             LET sr.gem02 = ''
          END IF
          SELECT azf03 INTO sr.azf03
             FROM azf_file
            WHERE azf01 = sr.sfu05
              AND azf02 = '2'
          IF SQLCA.sqlcode THEN
             LET sr.azf03 = ''
          END IF
          SELECT ima02,ima021 INTO sr.ima02,sr.ima021
             FROM ima_file
            WHERE ima01 = sr.sfu04
          IF SQLCA.sqlcode THEN
             LET sr.ima02 = ''
             LET sr.ima021 = ''
          END IF
 
          #No.FUN-7C0034 --start--
          #OUTPUT TO REPORT r320_rep(sr.*)            
          SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
           WHERE ima01 = sr.sfv04                                                                                                       
          IF g_sma115 = "Y" THEN                                                                                                        
             IF NOT cl_null(sr.sfv35) AND sr.sfv35 <> 0 THEN                                                                            
                CALL cl_remove_zero(sr.sfv35) RETURNING l_sfv35                                                                         
                LET l_str2 = l_sfv35, sr.sfv33 CLIPPED                                                                                  
             END IF                                                                                                                     
             IF l_ima906 = "2" THEN                                                                                                     
                IF cl_null(sr.sfv35) OR sr.sfv35 = 0 THEN                                                                               
                   CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32                                                                      
                   LET l_str2 = l_sfv32, sr.sfv30 CLIPPED                                                                               
                ELSE                                                                                                                    
                   IF NOT cl_null(sr.sfv32) AND sr.sfv32 <> 0 THEN                                                                      
                      CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32                                                                   
                      LET l_str2 = l_str2 CLIPPED,',',l_sfv32, sr.sfv30 CLIPPED                                                         
                   END IF                                                                                                               
                END IF                                                                                                                  
             END IF                                                                                                                     
          END IF 
          IF NOT cl_null(l_str2) THEN
             LET l_str2 = l_str2
          ELSE 
             LET l_str2 = NULL
          END IF
          EXECUTE insert_prep USING sr.sfu00,sr.sfu01,sr.sfu02,sr.sfv17,sr.sfu04,
                                    sr.gem02,sr.sfu05,sr.azf03,sr.sfu06,sr.sfu07,
                                    sr.sfv03,sr.sfv11,sr.sfv04,sr.ima02,sr.ima021,
                                    sr.sfv14,sr.sfv15,sr.sfv08,sr.sfv05,sr.sfv06,
                                    sr.sfv07,sr.sfv09,sr.sfv13,sr.sfv12,sr.sfv30,
                                    sr.sfv31,sr.sfv32,sr.sfv33,sr.sfv34,sr.sfv35,
                                    l_str2
          #No.FUN-7C0034 --end--
     END FOREACH
     
     #No.FUN-7C0034  --START--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'sfu01,sfv11,sfu02')
        RETURNING tm.wc
     END IF
     LET g_str=''
     LET g_str=tm.wc
     CALL cl_prt_cs3('asrr320','asrr320',g_sql,g_str)
     #FINISH REPORT r320_rep                         
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)    
     #No.FUN-7C0034  --END--
 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7C0034  --START--
#REPORT r320_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680130 VARCHAR(1)
#          sr        RECORD
#                    sfu00   LIKE sfu_file.sfu00,
#                    sfu01   LIKE sfu_file.sfu01,
#                    sfu02   LIKE sfu_file.sfu02,
#                    sfv17   LIKE sfv_file.sfv17,
#                    sfu04   LIKE sfu_file.sfu04,
#                    gem02   LIKE gem_file.gem02,
#                    sfu05   LIKE sfu_file.sfu05,
#                    azf03   LIKE azf_file.azf03,
#                    sfu06   LIKE sfu_file.sfu06,
#                    sfu07   LIKE sfu_file.sfu07,
#                    sfv03   LIKE sfv_file.sfv03,
#                    sfv11   LIKE sfv_file.sfv11,
#                    sfv04   LIKE sfv_file.sfv04,
#                    ima02   LIKE ima_file.ima02,
#                    ima021  LIKE ima_file.ima021,
#                    sfv14   LIKE sfv_file.sfv14,
#                    sfv15   LIKE sfv_file.sfv15,
#                    sfv08   LIKE sfv_file.sfv08,
#                    sfv05   LIKE sfv_file.sfv05,
#                    sfv06   LIKE sfv_file.sfv06,
#                    sfv07   LIKE sfv_file.sfv07,
#                    sfv09   LIKE sfv_file.sfv09,
#                    sfv13   LIKE sfv_file.sfv13,
#                    sfv12   LIKE sfv_file.sfv12,
#                    sfv30   LIKE sfv_file.sfv30,
#                    sfv31   LIKE sfv_file.sfv31,
#                    sfv32   LIKE sfv_file.sfv32,
#                    sfv33   LIKE sfv_file.sfv33,
#                    sfv34   LIKE sfv_file.sfv34,
#                    sfv35   LIKE sfv_file.sfv35
#                    END RECORD,
#          l_str         LIKE type_file.chr20,        #No.FUN-680130 VARCHAR(20)
#          l_cnt         LIKE type_file.num5          #No.FUN-680130 SMALLINT
#   DEFINE l_str2        LIKE type_file.chr1000,      #No.FUN-680130 VARCHAR(100)
#          l_sfv35       STRING,
#          l_sfv32       STRING
#   DEFINE l_ima906      LIKE ima_file.ima906
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.sfu01, sr.sfv03
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
#      PRINT g_x[09] CLIPPED,sr.sfu01,
#            COLUMN 41,g_x[13] CLIPPED,sr.sfu05,'  ',sr.azf03
#      PRINT g_x[10] CLIPPED,sr.sfu02,COLUMN 41,g_x[14] CLIPPED,sr.sfu06
#      PRINT g_x[12] CLIPPED,sr.sfu04,'  ',sr.gem02,COLUMN 41,g_x[15] CLIPPED,sr.sfu07
#
#      PRINT g_dash
#      CALL cl_prt_pos_dyn()
#
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#      PRINTX name=H2 g_x[37],g_x[38],g_x[40],g_x[41]
#      PRINTX name=H3 g_x[42],g_x[43],g_x[45]
#      PRINTX name=H4 g_x[47],g_x[48],g_x[50]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.sfu01   #單號
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#      SELECT ima906 INTO l_ima906 FROM ima_file
#       WHERE ima01 = sr.sfv04
#      IF g_sma115 = "Y" THEN
#         IF NOT cl_null(sr.sfv35) AND sr.sfv35 <> 0 THEN
#            CALL cl_remove_zero(sr.sfv35) RETURNING l_sfv35
#            LET l_str2 = l_sfv35, sr.sfv33 CLIPPED
#         END IF
#         IF l_ima906 = "2" THEN
#            IF cl_null(sr.sfv35) OR sr.sfv35 = 0 THEN
#               CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
#               LET l_str2 = l_sfv32, sr.sfv30 CLIPPED
#            ELSE
#               IF NOT cl_null(sr.sfv32) AND sr.sfv32 <> 0 THEN
#                  CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
#                  LET l_str2 = l_str2 CLIPPED,',',l_sfv32, sr.sfv30 CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
#
#       PRINTX name=D1 COLUMN g_c[31],sr.sfv03 USING '###&',
#                      COLUMN g_c[32],sr.sfv11,
#                      COLUMN g_c[33],sr.sfv08 CLIPPED,
#                      COLUMN g_c[34],cl_numfor(sr.sfv09,34,3),
#                      COLUMN g_c[35],sr.sfv17,
#                      COLUMN g_c[36],sr.sfv14 USING '#####&'
#       PRINTX name=D2 COLUMN g_c[38],sr.sfv04,
#                      COLUMN g_c[40],sr.sfv05 CLIPPED,
#                      COLUMN g_c[41],sr.sfv06 CLIPPED
#       PRINTX name=D3 COLUMN g_c[43],sr.ima02 CLIPPED,
#                      COLUMN g_c[45],sr.sfv07
#       PRINTX name=D4 COLUMN g_c[48],sr.ima021 CLIPPED,
#                      COLUMN g_c[50],sr.sfv12 CLIPPED
#       IF NOT cl_null(l_str2) THEN
#       PRINTX name=D4 COLUMN g_c[48],g_x[22] CLIPPED,l_str2
#       END IF
#       PRINT ' '
#
#   ON LAST ROW
#   AFTER GROUP OF sr.sfu01   #單號
#      LET l_last_sw = 'y'
# 
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         PRINT g_dash
#        #TQC-630166 Start 
#       # IF tm.wc.subString(1,120) > ' ' THEN            # for 132
#       #   PRINT g_x[8] CLIPPED,tm.wc.subString(1,120) CLIPPED END IF
#       # IF tm.wc.subString(121,240) > ' ' THEN
#       #   PRINT COLUMN 10,tm.wc.subString(121,240) CLIPPED END IF
#       # IF tm.wc.subString(241,300) > ' ' THEN
#       #   PRINT COLUMN 10,tm.wc.subString(241,300) CLIPPED END IF
#     
#          CALL cl_prt_pos_wc(tm.wc)
#       #TQC-630166 End
#      END IF
#     PRINT g_dash
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#
#END REPORT
#No.FUN-7C0034  --END--
 
