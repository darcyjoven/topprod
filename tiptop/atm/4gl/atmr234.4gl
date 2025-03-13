# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: atmr234.4gl
# Descriptions...: 合同清單            
# Date & Author..: 06/03/16 By jackie
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-740129 07/04/24 By sherry  打印結果中"from"跟"頁次"不在同一行，“頁次”格式錯誤。
# Modify.........: NO.FUN-860008 08/06/24 By zhaijie老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)            # Where condition
            a       LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01)             # Print Store Info
            more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)             # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE bnb_file.bnb06,            #No.FUN-680120 VARCHAR(20)  # For TIPTOP 串 EasyFlow
        g_po_no,g_ctn_no1,g_ctn_no2        LIKE bnb_file.bnb06     #No.FUN-680120 VARCHAR(20)     
#NO.FUN-860008---start---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-860008---end---  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#NO.FUN-860008---start---
   LET g_sql = "tqp01.tqp_file.tqp01,",
               "tqp02.tqp_file.tqp02,",
               "tqp03.tqp_file.tqp03,",
               "tqp05.tqp_file.tqp05,",   
               "tqp06.tqp_file.tqp06,",
               "tqp07.tqp_file.tqp07,",
               "tqq02.tqq_file.tqq02,",
               "tqq03.tqq_file.tqq03,",
               "tqq06.tqq_file.tqq06,",
               "tqq04.tqq_file.tqq04,",
               "tqq05.tqq_file.tqq05,",
               "l_tqa02.tqa_file.tqa02,",
               "l_tqa021.tqa_file.tqa02,",
               "l_too02.too_file.too02,",
               "l_top02.top_file.top02,",
               "l_occ02.occ_file.occ02,",
               "l_azp02.azp_file.azp02"
   LET l_table =cl_prt_temptable('atmr234',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-860008---end---
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a    = 'Y'
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
        CALL atmr234_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqp01= '",tm.wc CLIPPED,"'"
        CALL atmr234()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr234_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr234_w AT p_row,p_col WITH FORM "atm/42f/atmr234"
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr234_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr234_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr234'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr234','9031',1)
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
         CALL cl_cmdat('atmr234',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmr234_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr234()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr234_w
END FUNCTION
 
FUNCTION atmr234()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000)
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)	
          sr        RECORD
                    tqp01     LIKE tqp_file.tqp01,
                    tqp02     LIKE tqp_file.tqp02,
                    tqp03     LIKE tqp_file.tqp03,
                    tqp05     LIKE tqp_file.tqp05,   
                    tqp06     LIKE tqp_file.tqp06,
                    tqp07     LIKE tqp_file.tqp07,
                    tqq02     LIKE tqq_file.tqq02,
                    tqq03     LIKE tqq_file.tqq03,
                    tqq06     LIKE tqq_file.tqq06,
                    tqq04     LIKE tqq_file.tqq04,
                    tqq05     LIKE tqq_file.tqq05 
                    END RECORD
#NO.FUN-860008---start--                    
   DEFINE l_tqa02  LIKE tqa_file.tqa02
   DEFINE l_tqa021 LIKE tqa_file.tqa02
   DEFINE l_azp02  LIKE azp_file.azp02
   DEFINE l_azp03  LIKE azp_file.azp03
   DEFINE l_too02  LIKE too_file.too02
   DEFINE l_top02  LIKE top_file.top02
   DEFINE l_occ02  LIKE occ_file.occ02
   DEFINE l_ds     LIKE azp_file.azp03
    CALL  cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmr234'
#NO.FUN-860008---end--
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
               " tqp07,tqq02,tqq03,tqq06,tqq04,tqq05 ", 
               " FROM tqp_file, tqq_file",
               " WHERE ",tm.wc CLIPPED,
               " AND tqq_file.tqq01 = tqp01 ",
               " ORDER BY tqp01 "
     PREPARE atmr234_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmr234_curs1 CURSOR FOR atmr234_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#NO.FUN-860008---start--mark--
#     IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#        THEN
#        LET l_name = g_rpt_name
#     ELSE
#        CALL cl_outnam('atmr234') RETURNING l_name
#     END IF
 
#     IF tm.a='Y' THEN
#        LET g_zaa[39].zaa06='N'
#        LET g_zaa[40].zaa06='N'
#        LET g_zaa[41].zaa06='N'
#        LET g_zaa[42].zaa06='N'
#        LET g_zaa[43].zaa06='N'
#        LET g_zaa[44].zaa06='N'
#        LET g_zaa[45].zaa06='N'
#        LET g_zaa[46].zaa06='N'
#     ELSE
#        LET g_zaa[39].zaa06='Y'
#        LET g_zaa[40].zaa06='Y'
#        LET g_zaa[41].zaa06='Y'
#        LET g_zaa[42].zaa06='Y'
#        LET g_zaa[43].zaa06='Y'
#        LET g_zaa[44].zaa06='Y'
#        LET g_zaa[45].zaa06='Y'
#        LET g_zaa[46].zaa06='Y'
#     END IF
#NO.FUN-860008---end--mark--
     CALL cl_prt_pos_len()
 
#     START REPORT atmr234_rep TO l_name                    #NO.FUN-860008
 
#     LET g_pageno = 0                                      #NO.FUN-860008
     FOREACH atmr234_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#       OUTPUT TO REPORT atmr234_rep(sr.*)                  #NO.FUN-860008
#NO.FUN-860008---start--
         SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = sr.tqp03 AND tqa03 = '13'
         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01 = sr.tqp05 AND tqa03 = '20'
       
         IF tm.a='Y' THEN
         SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=sr.tqq06
         SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = sr.tqq06
         LET l_ds = FGL_GETENV("MSSQLAREA") CLIPPED,'_', l_azp03 CLIPPED,'.dbo.'
         LET l_sql=" SELECT occ02 FROM ",l_ds CLIPPED,"occ_file ",
                   "  WHERE occ01='",sr.tqq03,"'"
         PREPARE atmr234_prepare5 FROM l_sql
         DECLARE atmr234_curs5 CURSOR FOR atmr234_prepare5
         OPEN atmr234_curs5
         FETCH atmr234_curs5 INTO l_occ02      
       
         LET l_sql=" SELECT too02 FROM ",l_ds CLIPPED,"too_file ",
                   "  WHERE too01='",sr.tqq04,"'"
         PREPARE atmr234_prepare2 FROM l_sql
         DECLARE atmr234_curs2 CURSOR FOR atmr234_prepare2
         OPEN atmr234_curs2
         FETCH atmr234_curs2 INTO l_too02      
 
         LET l_sql=" SELECT top02 FROM ",l_ds CLIPPED,"top_file ",
                   "  WHERE top01='",sr.tqq05,"'"
         PREPARE atmr234_prepare3 FROM l_sql
         DECLARE atmr234_curs3 CURSOR FOR atmr234_prepare3
         OPEN atmr234_curs3
         FETCH atmr234_curs3 INTO l_top02
         END IF
         EXECUTE insert_prep USING
           sr.tqp01,sr.tqp02,sr.tqp03,sr.tqp05,sr.tqp06,sr.tqp07,
           sr.tqq02,sr.tqq03,sr.tqq06,sr.tqq04,sr.tqq05,l_tqa02,
           l_tqa021,l_too02,l_top02,l_occ02,l_azp02   
#NO.FUN-860008--end--
     END FOREACH
 
#     FINISH REPORT atmr234_rep                             #NO.FUN-860008
#NO.FUN-860008--start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'tqp01,tqp06,tqp07,tqp05')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.a
     CALL cl_prt_cs3('atmr234','atmr234',g_sql,g_str) 
#NO.FUN-860008---end--- 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-860008
END FUNCTION
#NO.FUN-860008--start---mark---
#REPORT atmr234_rep(sr)
#   DEFINE l_tqa02  LIKE tqa_file.tqa02
#   DEFINE l_tqa021 LIKE tqa_file.tqa02
#   DEFINE l_azp02  LIKE azp_file.azp02
#   DEFINE l_azp03  LIKE azp_file.azp03
#   DEFINE l_too02  LIKE too_file.too02
#   DEFINE l_top02  LIKE top_file.top02
#   DEFINE l_occ02  LIKE occ_file.occ02
#   DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
#   DEFINE l_ds     LIKE azp_file.azp03          #No.FUN-680120 VARCHAR(50)
#   DEFINE l_tqp03_tqa  LIKE gbc_file.gbc05,     #No.FUN-680120 VARCHAR(100)
#          l_tqp05_tqa  LIKE gbc_file.gbc05,     #No.FUN-680120 VARCHAR(100)
#          l_tqt02_tqa  LIKE gbc_file.gbc05      #No.FUN-680120 VARCHAR(100) 
#   DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680120 VARCHAR(1)
#          sr        RECORD
#                    tqp01     LIKE tqp_file.tqp01,
#                    tqp02     LIKE tqp_file.tqp02,
#                    tqp03     LIKE tqp_file.tqp03,
#                    tqp05     LIKE tqp_file.tqp05,   
#                    tqp06     LIKE tqp_file.tqp06,
#                    tqp07     LIKE tqp_file.tqp07,
#                    tqq02     LIKE tqq_file.tqq02,
#                    tqq03     LIKE tqq_file.tqq03,
#                    tqq06     LIKE tqq_file.tqq06,
#                    tqq04     LIKE tqq_file.tqq04,
#                    tqq05     LIKE tqq_file.tqq05 
#                    END RECORD         
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.tqp01,sr.tqq02
# 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2+1),g_company CLIPPED 
#   #     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED    #No.TQC-740129
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         PRINT ' '
#         #No.TQC-740129---begin                                                                                                      
#    #    PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#    #          COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#         LET g_pageno = g_pageno + 1                                                                                             
#         LET pageno_total = PAGENO USING '<<<','/pageno'                                                                         
#         PRINT g_head CLIPPED, pageno_total                                                                                      
#         PRINT ' '                                                                                                               
#        #No.TQC-740129---end    
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#               g_x[45],g_x[46]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
#
#      BEFORE GROUP OF sr.tqp01
#         IF LINENO > 60 THEN
#            SKIP TO TOP OF PAGE
#         END IF
#         SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = sr.tqp03 AND tqa03 = '13'
#         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01 = sr.tqp05 AND tqa03 = '20'
#
#         IF tm.a='Y' THEN
#         PRINT COLUMN g_c[31],sr.tqp01 CLIPPED,
#               COLUMN g_c[32],sr.tqp02 CLIPPED,
#               COLUMN g_c[33],sr.tqp03 CLIPPED,
#               COLUMN g_c[34],l_tqa02 CLIPPED,
#               COLUMN g_c[35],sr.tqp05 CLIPPED,
#               COLUMN g_c[36],l_tqa021 CLIPPED,
#               COLUMN g_c[37],sr.tqp06 CLIPPED,
#               COLUMN g_c[38],sr.tqp07 CLIPPED; 
#         ELSE
#         PRINT COLUMN g_c[31],sr.tqp01 CLIPPED,
#               COLUMN g_c[32],sr.tqp02 CLIPPED,
#               COLUMN g_c[33],sr.tqp03 CLIPPED,
#               COLUMN g_c[34],l_tqa02 CLIPPED,
#               COLUMN g_c[35],sr.tqp05 CLIPPED,
#               COLUMN g_c[36],l_tqa021 CLIPPED,
#               COLUMN g_c[37],sr.tqp06 CLIPPED,
#               COLUMN g_c[38],sr.tqp07 CLIPPED 
#         END IF
#
#      ON EVERY ROW
#         IF tm.a='Y' THEN
#         SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=sr.tqq06
#         SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = sr.tqq06
#         LET l_ds = FGL_GETENV("MSSQLAREA") CLIPPED,'_', l_azp03 CLIPPED,'.dbo.'
#         LET l_sql=" SELECT occ02 FROM ",l_ds CLIPPED,"occ_file ",
#                   "  WHERE occ01='",sr.tqq03,"'"
#         PREPARE atmr234_prepare5 FROM l_sql
#         DECLARE atmr234_curs5 CURSOR FOR atmr234_prepare5
#         OPEN atmr234_curs5
#         FETCH atmr234_curs5 INTO l_occ02      
#       
#         LET l_sql=" SELECT too02 FROM ",l_ds CLIPPED,"too_file ",
#                   "  WHERE too01='",sr.tqq04,"'"
#         PREPARE atmr234_prepare2 FROM l_sql
#         DECLARE atmr234_curs2 CURSOR FOR atmr234_prepare2
#         OPEN atmr234_curs2
#         FETCH atmr234_curs2 INTO l_too02      
#
#         LET l_sql=" SELECT top02 FROM ",l_ds CLIPPED,"top_file ",
#                   "  WHERE top01='",sr.tqq05,"'"
#         PREPARE atmr234_prepare3 FROM l_sql
#         DECLARE atmr234_curs3 CURSOR FOR atmr234_prepare3
#         OPEN atmr234_curs3
#         FETCH atmr234_curs3 INTO l_top02      
#
#         PRINT COLUMN g_c[39],sr.tqq03 CLIPPED,
#               COLUMN g_c[40],l_occ02 CLIPPED,
#               COLUMN g_c[41],sr.tqq06 CLIPPED,
#               COLUMN g_c[42],l_azp02 CLIPPED,
#               COLUMN g_c[43],sr.tqq04 CLIPPED,
#               COLUMN g_c[44],l_too02 CLIPPED,
#               COLUMN g_c[45],sr.tqq05 CLIPPED,
#               COLUMN g_c[46],l_top02 CLIPPED
#         END IF
# 
#      PAGE TRAILER
#         IF l_last_sw ='Y' THEN
#            PRINT g_dash[1,g_len]
#         ELSE
#            PRINT g_dash[1,g_len]
#         END IF
#         IF l_last_sw = 'N' THEN
#            IF g_memo_pagetrailer THEN
#               PRINT g_x[4]
#               PRINT g_memo
#            ELSE
#               PRINT
#               PRINT
#            END IF
#         ELSE
#            PRINT g_x[4]
#            PRINT g_memo
#         END IF
# 
#END REPORT
#NO.FUN-860008--end--mark--
#No.FUN-870144
