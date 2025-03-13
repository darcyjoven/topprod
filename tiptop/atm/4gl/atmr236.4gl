# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr236.4gl
# Descriptions...: 合同費用項目明細表
# Date & Author..: 06/03/16 By Ray
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710043 07/01/13 By Rayven 報表格式調整
# Modify.........: No.FUN-860062 08/06/20 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                               # Print condition RECORD
            wc      LIKE type_file.chr1000,      #No.FUN-680120             # Where condition
            more    LIKE type_file.chr1          #No.FUN-680120             # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE bnb_file.bnb06,         #No.FUN-680120    # For TIPTOP 串 EasyFlow
        g_po_no,g_ctn_no1,g_ctn_no2        LIKE bnb_file.bnb06         #No.FUN-680120
DEFINE  l_table     STRING                       #No.FUN-860062                                                             
DEFINE  l_sql       STRING                       #No.FUN-860062 
DEFINE  g_sql       STRING                       #No.FUN-860062                                                           
DEFINE  g_str       STRING                       #No.FUN-860062        
                    
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
#No.FUN-860062---Begin 
   LET g_sql = " tqp01.tqp_file.tqp01,",
               " tqp02.tqp_file.tqp02,",
               " l_tqa02.tqa_file.tqa02,",
               " l_tqa021.tqa_file.tqa02,",
               " tqp03.tqp_file.tqp03,",
               " tqp05.tqp_file.tqp05,",
               " tqp06.tqp_file.tqp06,",
               " tqp07.tqp_file.tqp07,",
               " tqt02.tqt_file.tqt02,",
               " l_tqa022.tqa_file.tqa02 "
   LET l_table = cl_prt_temptable('atmr236',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-860062---End    
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   IF cl_null(tm.wc) THEN
        CALL atmr236_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqp01= '",tm.wc CLIPPED,"'"
        CALL atmr236()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr236_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr236_w AT p_row,p_col WITH FORM "atm/42f/atmr236"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tqp01,tqp06,tqp07,tqp05 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       ON ACTION controlp
          CASE
             WHEN INFIELD(tqp01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tqp02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqp01
                 NEXT FIELD tqp01
             WHEN INFIELD(tqp05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tqa04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqp05
                 NEXT FIELD tqp05
            
             OTHERWISE EXIT CASE
          END CASE
       
      ON ACTION locale
         CALL cl_show_fld_cont()           
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
  
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr236_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
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
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about  
         CALL cl_about()
      ON ACTION help   
         CALL cl_show_help() 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr236_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr236'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr236','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('atmr236',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmr236_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr236()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr236_w
END FUNCTION
 
FUNCTION atmr236()
   DEFINE l_tqa02  LIKE tqa_file.tqa02
   DEFINE l_tqa021 LIKE tqa_file.tqa02
   DEFINE l_tqa022 LIKE tqa_file.tqa02
   DEFINE l_name    LIKE type_file.chr20,            #No.FUN-680120        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120
          sr        RECORD
                    tqp01     LIKE tqp_file.tqp01,
                    tqp02     LIKE tqp_file.tqp02,
                    tqp03     LIKE tqp_file.tqp03,
                    tqp05     LIKE tqp_file.tqp05,   
                    tqp06     LIKE tqp_file.tqp06,
                    tqp07     LIKE tqp_file.tqp07,
                    tqt02     LIKE tqt_file.tqt02
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tqpuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tqpgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tqpgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqpuser', 'tqpgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT tqp01,tqp02,tqp03,tqp05,tqp06,",  
               " tqp07,tqt02", 
               " FROM tqp_file, OUTER tqt_file",
               " WHERE ",tm.wc CLIPPED,
               " AND tqt_file.tqt01 = tqp_file.tqp01 ",
               " ORDER BY tqp01 "
     PREPARE atmr236_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmr236_curs1 CURSOR FOR atmr236_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱     #No.FUN-860062
#       THEN                                                #No.FUN-860062
#       LET l_name = g_rpt_name                             #No.FUN-860062
#    ELSE                                                   #No.FUN-860062 
#       CALL cl_outnam('atmr236') RETURNING l_name          #No.FUN-860062
#    END IF                                                 #No.FUN-860062 
 
#    START REPORT atmr236_rep TO l_name                     #No.FUN-860062
     CALL cl_del_data(l_table)                              #No.FUN-860062 
    
     LET g_pageno = 0
     FOREACH atmr236_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-860062---Begin
#      OUTPUT TO REPORT atmr236_rep(sr.*)
         SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = sr.tqp03 AND tqa03 = '13'
         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01 = sr.tqp05 AND tqa03 = '20'
         SELECT tqa02 INTO l_tqa022 FROM tqa_file WHERE tqa01 = sr.tqt02 AND tqa03 = '3'
         IF cl_null(sr.tqt02) THEN
            LET l_tqa022 = ' '
         END IF
         EXECUTE insert_prep USING sr.tqp01, sr.tqp02, l_tqa02, l_tqa021, sr.tqp03, sr.tqp05,
                                   sr.tqp06, sr.tqp07, sr.tqt02,l_tqa022
     END FOREACH
 
#    FINISH REPORT atmr236_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'tqp01,tqp06,tqp07,tqp05 ')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc                                                       
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('atmr236','atmr236',l_sql,g_str) 
#No.FUN-860062---End
END FUNCTION
 
#No.FUN-860062---Begin
#REPORT atmr236_rep(sr)
#   DEFINE l_tqa02  LIKE tqa_file.tqa02
#   DEFINE l_tqa021 LIKE tqa_file.tqa02
#   DEFINE l_tqa022 LIKE tqa_file.tqa02
#   DEFINE l_tqp03_tqa  LIKE type_file.chr1000,          #No.FUN-680120
#          l_tqp05_tqa  LIKE type_file.chr1000,          #No.FUN-680120
#          l_tqt02_tqa  LIKE type_file.chr1000           #No.FUN-680120
#   DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120
#          sr        RECORD
#                    tqp01     LIKE tqp_file.tqp01,
#                    tqp02     LIKE tqp_file.tqp02,
#                    tqp03     LIKE tqp_file.tqp03,
#                    tqp05     LIKE tqp_file.tqp05,   
#                    tqp06     LIKE tqp_file.tqp06,
#                    tqp07     LIKE tqp_file.tqp07,
#                    tqt02     LIKE tqt_file.tqt02
#                    END RECORD         
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.tqp01,sr.tqt02
# 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2+1),g_company CLIPPED 
##        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED #No.TQC-710043 mark
#         PRINT #No.TQC-710043
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         #No.TQC-710043 --start--
##        PRINT ' '
##        PRINT g_x[2] CLIPPED,g_today,' ',TIME,
##              COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         #No.TQC-710043 --end--
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'n'
#         PRINTX g_x[11],g_x[12],g_x[13],g_x[14],g_x[15],g_x[16],g_x[17]
#         PRINT g_dash1
#
#      BEFORE GROUP OF sr.tqp01
#         IF LINENO > 60 THEN
#            SKIP TO TOP OF PAGE
#         END IF
#         SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = sr.tqp03 AND tqa03 = '13'
#         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01 = sr.tqp05 AND tqa03 = '20'
#         LET l_tqp03_tqa = sr.tqp03 CLIPPED,' ',l_tqa02 CLIPPED
#         LET l_tqp05_tqa = sr.tqp05 CLIPPED,' ',l_tqa021 CLIPPED
#         PRINT COLUMN g_c[11],sr.tqp01 CLIPPED,
#               COLUMN g_c[12],sr.tqp02 CLIPPED,
#               COLUMN g_c[13],l_tqp03_tqa CLIPPED,
#               COLUMN g_c[14],l_tqp05_tqa CLIPPED,
#               COLUMN g_c[15],sr.tqp06 CLIPPED,
#               COLUMN g_c[16],sr.tqp07 CLIPPED;
#      ON EVERY ROW
#         SELECT tqa02 INTO l_tqa022 FROM tqa_file WHERE tqa01 = sr.tqt02 AND tqa03 = '3'
#         IF cl_null(sr.tqt02) THEN
#            LET l_tqa022 = ' '
#         END IF
#         LET l_tqt02_tqa = sr.tqt02 CLIPPED,' ',l_tqa022 CLIPPED
#         PRINT COLUMN g_c[17],l_tqt02_tqa CLIPPED
##     AFTER GROUP OF sr.tqp01
##        PRINT g_dash1
#
#      #No.TQC-710043 --start--
#      ON LAST ROW
#         PRINT g_dash[1,g_len]
#         PRINT g_x[5] CLIPPED,COLUMN (g_len-9), g_x[7] CLIPPED
#         PRINT
#         PRINT COLUMN 01,g_x[20] CLIPPED
#         LET l_last_sw ='y'
#      #No.TQC-710043 --end--
#
#      PAGE TRAILER
#         IF l_last_sw ='n' THEN   #No.TQC-710043
#            PRINT g_dash[1,g_len]
#            PRINT g_x[5] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-710043
#            PRINT 
#            PRINT COLUMN 01,g_x[20] CLIPPED
#         #No.TQC-710043 --start--
#         ELSE
#            SKIP 4 LINE
#         END IF
#         #No.TQC-710043 --end--
#          
#END REPORT
#No.FUN-860062---End
#No.FUN-870144
