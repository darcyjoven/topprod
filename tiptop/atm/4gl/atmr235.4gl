# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: atmr235.4gl
# Descriptions...: 合同費用項目明細表
# Date & Author..: 06/03/16 By Ray
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-740129 07/04/24 By sherry 打印結果中"from"跟"頁次"不在同一行，“頁次”格式錯誤。
# Modify.........: No.FUN-850152 08/06/20 By chenmoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-8A0067 09/02/05 By dxfwo CR bug
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,          #No.FUN-680120             # Where condition
            more    LIKE type_file.chr1              #No.FUN-680120               # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE bnb_file.bnb06,             #No.FUN-680120  # For TIPTOP 串 EasyFlow
        g_po_no,g_ctn_no1,g_ctn_no2       LIKE bnb_file.bnb06        #No.FUN-680120   
#No.FUN-850152 --Begin
 DEFINE l_table     STRING  #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
 DEFINE #g_sql       LIKE type_file.chr1000
        g_sql    STRING     #NO.FUN-910082
 DEFINE g_str       LIKE type_file.chr1000
#No.FUN-850152 --End
  
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
#No.FUN-850152 --Begin
   LET g_sql="tqp01.tqp_file.tqp01,",
             "tqp02.tqp_file.tqp02,",
             "tqp03.type_file.chr1000,",
             "tqp05.type_file.chr1000,",
             "tqp06.tqp_file.tqp06,",
             "tqp07.tqp_file.tqp07,",
             "tqs03.type_file.chr1000,",
             "tqs04.tqs_file.tqs04,",
             "tqs09.tqs_file.tqs09,",
             "tqs07.tqs_file.tqs07,",
             "tqs08.tqs_file.tqs08,",
             "tqs05.tqs_file.tqs05,",
             "tqs02.tqs_file.tqs02"
   LET l_table=cl_prt_temptable('atmr235',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
#No.FUN-850152 --End
             
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
        CALL atmr235_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqp01= '",tm.wc CLIPPED,"'"
        CALL atmr235()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr235_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr235_w AT p_row,p_col WITH FORM "atm/42f/atmr235"
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr235_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr235_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='atmr235'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr235','9031',1)
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
         CALL cl_cmdat('atmr235',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmr235_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr235()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr235_w
END FUNCTION
 
FUNCTION atmr235()
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
                    tqs02     LIKE tqs_file.tqs02,
                    tqs03     LIKE tqs_file.tqs03,
                    tqs04     LIKE tqs_file.tqs04,
                    tqs09     LIKE tqs_file.tqs09,
                    tqs07     LIKE tqs_file.tqs07,
                    tqs08     LIKE tqs_file.tqs08,
                    tqs05     LIKE tqs_file.tqs05
                    END RECORD
 
#No.FUN-850152 --Begin
   DEFINE l_tqa02  LIKE tqa_file.tqa02                                                                                              
   DEFINE l_tqa021 LIKE tqa_file.tqa02                                                                                              
   DEFINE l_tqa022 LIKE tqa_file.tqa02
   DEFINE l_tqp01_tqp  LIKE type_file.chr1000,                                                                
          l_tqp03_tqa  LIKE type_file.chr1000,                                                                
          l_tqp05_tqa  LIKE type_file.chr1000,                                                                      
          l_tqs03_tqa  LIKE type_file.chr1000 
 
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
     END IF
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='atmr235'
#No.FUN-850152 --End
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
 
     LET l_sql="SELECT tqp01,tqp02,tqp03,tqp05,tqp06,tqp07,",  
               " tqs02,tqs03,tqs04,tqs09,tqs07,tqs08,tqs05", 
               " FROM tqp_file, OUTER tqs_file",
               " WHERE ",tm.wc CLIPPED,
               " AND tqs_file.tqs01 = tqp_file.tqp01 ",
               " ORDER BY tqp01 "
     PREPARE atmr235_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmr235_curs1 CURSOR FOR atmr235_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#No.FUN-850152 --Begin
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#       THEN
#       LET l_name = g_rpt_name
#    ELSE
#       CALL cl_outnam('atmr235') RETURNING l_name
#    END IF
#No.FUN-850152 --End
 
#No.FUN-850152 --Begin
#    START REPORT atmr235_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-850152 --End
     FOREACH atmr235_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = sr.tqp03 AND tqa03 = '13'                                           
         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01 = sr.tqp05 AND tqa03 = '20'                                           
         LET l_tqp01_tqp = sr.tqp01 CLIPPED,' ',sr.tqp02 CLIPPED                                                                    
         LET l_tqp03_tqa = sr.tqp03 CLIPPED,' ',l_tqa02 CLIPPED                                                                     
         LET l_tqp05_tqa = sr.tqp05 CLIPPED,' ',l_tqa021 CLIPPED                                                                    
         IF cl_null(sr.tqp03) THEN                                                                                                  
            LET l_tqa02 = ' '                                                                                                       
         END IF                                                                                                                     
         IF cl_null(sr.tqp05) THEN                                                                                                  
            LET l_tqa021 = ' '                                                                                                      
         END IF                                           
      SELECT oaj02 INTO l_tqa022 FROM oaj_file WHERE oaj01 = sr.tqs03                                                            
         IF cl_null(sr.tqs03) THEN                                                                                                  
            LET l_tqa022 = ' '                                                                                                      
         END IF                                                                                                                     
         LET l_tqs03_tqa = sr.tqs03 CLIPPED,' ',l_tqa022 CLIPPED
#No.FUN-850152 -Begin
#      OUTPUT TO REPORT atmr235_rep(sr.*)
       EXECUTE insert_prep USING sr.tqp01,sr.tqp02,l_tqp03_tqa,l_tqp05_tqa,sr.tqp06,
               sr.tqp07,l_tqs03_tqa,sr.tqs04,sr.tqs09,sr.tqs07,
               sr.tqs08,sr.tqs05,sr.tqs02 
#No.FUN-850152 --End
     END FOREACH
 
#No.FUN-850152 --Begin
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tqp01,tqp06,tqp07,tqp05')
                  RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     LET g_str = tm.wc   #FUN-8A0067 
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('atmr235','atmr235',g_sql,g_str)
#    FINISH REPORT atmr235_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-850152 --End
END FUNCTION
 
REPORT atmr235_rep(sr)
   DEFINE l_tqa02  LIKE tqa_file.tqa02
   DEFINE l_tqa021 LIKE tqa_file.tqa02
   DEFINE l_tqa022 LIKE tqa_file.tqa02
   DEFINE sr        RECORD
                    tqp01     LIKE tqp_file.tqp01,
                    tqp02     LIKE tqp_file.tqp02,
                    tqp03     LIKE tqp_file.tqp03,
                    tqp05     LIKE tqp_file.tqp05,   
                    tqp06     LIKE tqp_file.tqp06,
                    tqp07     LIKE tqp_file.tqp07,
                    tqs02     LIKE tqs_file.tqs02,
                    tqs03     LIKE tqs_file.tqs03,
                    tqs04     LIKE tqs_file.tqs04,
                    tqs09     LIKE tqs_file.tqs09,
                    tqs07     LIKE tqs_file.tqs07,
                    tqs08     LIKE tqs_file.tqs08,
                    tqs05     LIKE tqs_file.tqs05
                    END RECORD
   DEFINE l_last_sw    LIKE type_file.chr1              #No.FUN-680120 
   DEFINE l_n          LIKE type_file.num10             #No.FUN-680120 INTEGER
   DEFINE l_tqp01_tqp  LIKE type_file.chr1000,          #No.FUN-680120
          l_tqp03_tqa  LIKE type_file.chr1000,          #No.FUN-680120
          l_tqp05_tqa  LIKE type_file.chr1000,          #No.FUN-680120
          l_tqs03_tqa  LIKE type_file.chr1000           #No.FUN-680120
 
   
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.tqp01,sr.tqs02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2+1),g_company CLIPPED 
   #     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED       #No.TQC-740129
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         PRINT ' '
       #No.TQC-740129---begin
       # PRINT g_x[2] CLIPPED,g_today,' ',TIME,
       #       COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
         LET g_pageno = g_pageno + 1                                                                                             
         LET pageno_total = PAGENO USING '<<<','/pageno'                                                                         
         PRINT g_head CLIPPED, pageno_total                                                                                      
         PRINT ' '           
       #No.TQC-740129---end
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'n'
         PRINTX g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
         PRINT g_dash1
 
      BEFORE GROUP OF sr.tqp01
         IF LINENO > 60 THEN
            SKIP TO TOP OF PAGE
         END IF
         SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = sr.tqp03 AND tqa03 = '13'
         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01 = sr.tqp05 AND tqa03 = '20'
         LET l_tqp01_tqp = sr.tqp01 CLIPPED,' ',sr.tqp02 CLIPPED
         LET l_tqp03_tqa = sr.tqp03 CLIPPED,' ',l_tqa02 CLIPPED
         LET l_tqp05_tqa = sr.tqp05 CLIPPED,' ',l_tqa021 CLIPPED
         IF cl_null(sr.tqp03) THEN
            LET l_tqa02 = ' '
         END IF
         IF cl_null(sr.tqp05) THEN
            LET l_tqa021 = ' '
         END IF
         PRINTX name=D1 COLUMN g_c[31],l_tqp01_tqp,
                        COLUMN g_c[32],l_tqp03_tqa,
                        COLUMN g_c[33],l_tqp05_tqa,
                        COLUMN g_c[34],sr.tqp06 CLIPPED,
                        COLUMN g_c[35],sr.tqp07 CLIPPED;
         LET l_n = 0
      ON EVERY ROW
         SELECT oaj02 INTO l_tqa022 FROM oaj_file WHERE oaj01 = sr.tqs03
         IF cl_null(sr.tqs03) THEN
            LET l_tqa022 = ' '
         END IF
         LET l_tqs03_tqa = sr.tqs03 CLIPPED,' ',l_tqa022 CLIPPED
         PRINTX name=H1 COLUMN g_c[36],l_tqs03_tqa;
         IF sr.tqs04 = '1' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[9] CLIPPED;
         END IF
         IF sr.tqs04 = '2' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[10] CLIPPED;
         END IF
         IF sr.tqs04 = '3' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[11] CLIPPED;
         END IF
         IF sr.tqs04 = '4' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[12] CLIPPED;
         END IF
         IF sr.tqs04 = '5' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[13] CLIPPED;
         END IF
         IF sr.tqs04 = '6' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[14] CLIPPED;
         END IF
         IF sr.tqs04 = '7' THEN
            PRINTX name=H1 COLUMN g_c[37],g_x[15] CLIPPED;
         END IF
         PRINTX name=H1 COLUMN g_c[38],sr.tqs09 CLIPPED,
                        COLUMN g_c[39],sr.tqs07 CLIPPED,
                        COLUMN g_c[40],cl_numfor(sr.tqs08,18,t_azi04) CLIPPED,
                        COLUMN g_c[41],sr.tqs05 CLIPPED
 
#     AFTER GROUP OF sr.tqp01
#        PRINT g_dash1
 
      PAGE TRAILER
            PRINT g_dash[1,g_len]
            PRINT 
            PRINT COLUMN 01,g_x[30] CLIPPED
          
END REPORT
 
#No.FUN-870144
