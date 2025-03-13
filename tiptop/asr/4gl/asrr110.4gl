# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asrr110.4gl
# Descriptions...: 機台維修預計明細表
# Date & Author..: 2006/03/10 By Joe
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-7C0034 07/12/11 By Arman 報表改為CR
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, 
              bdate   LIKE type_file.dat,                #No.FUN-680130 DATE 
              edate   LIKE type_file.dat,                #No.FUN-680130 DATE
              more    LIKE type_file.chr1                #No.FUN-680130 VARCHAR(01)
              END RECORD
   DEFINE g_i LIKE type_file.num5     #count/index for any purpose        #No.FUN-680130 SMALLINT
   DEFINE g_str STRING                #No.FUN-7C0034
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r110_tm(0,0)
   ELSE
      CALL r110()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT 
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r110_w AT p_row,p_col
        WITH FORM "asr/42f/asrr110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
 
   WHILE TRUE
      WHILE TRUE
         CONSTRUCT BY NAME tm.wc ON srb02,srb06
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
   
            ON ACTION controlp     
               CASE WHEN INFIELD(srb02)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_eci"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO srb02
                       NEXT FIELD srb02
                    WHEN INFIELD(srb06)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gen"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO srb06
                       NEXT FIELD srb06
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
            LET INT_FLAG = 0
            CLOSE WINDOW r110_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
            EXIT PROGRAM
         END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
         CALL cl_err('',9046,0)
      END WHILE
      INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
   
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
   
         AFTER FIELD bdate
             IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
   
         AFTER FIELD edate
             IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
             IF tm.edate < tm.bdate THEN NEXT FIELD edate END IF
   
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
   
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
   
         ON ACTION CONTROLG CALL cl_cmdask()
   
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
         LET INT_FLAG = 0
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrr110'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrr110','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('asrr110',g_time,l_cmd)
         END IF
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r110()
      ERROR ""
   END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION r110()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name   #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680130 VARCHAR(1100)
          l_za05    LIKE type_file.chr20,       #No.FUN-680130 VARCHAR(20)
          sr        RECORD
                    srb01     LIKE srb_file.srb01,
                    srb02     LIKE srb_file.srb02,
                    eci06     LIKE eci_file.eci06,
                    srb03     LIKE srb_file.srb03,
                    srb04     LIKE srb_file.srb04,
                    srb05     LIKE srb_file.srb05,
                    srb06     LIKE srb_file.srb06,
                    gen02     LIKE gen_file.gen02
                    END RECORD
     DEFINE l_prog  STRING 
 
     # No.FUN-B80063----start mark------------------------------------
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
     # No.FUN-B80063----end mark--------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfuuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfugrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
     #End:FUN-980030
 
#    LET l_sql = "SELECT srb01,srb02,'',srb03,srb04,srb05,srb06,'' ",
     LET l_sql = "SELECT srb01,srb02,eci06,srb03,srb04,srb05,srb06,gen02 ",   #No.FUN-7C0034
#                " FROM srb_file ",
                 " FROM srb_file,eci_file,gen_file ",                         #No.FUN-7C0034
                 " WHERE srbacti = 'Y' ",
                 "   AND srb02 = eci01 AND srb06 = gen01 ",                   #No.FUN-7C0034
                 "   AND srb01 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME)",
                 "   AND ",tm.wc clipped
 
#No.FUN-7C0034 ------begin ------
#    PREPARE r110_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1)
#       EXIT PROGRAM
#    END IF
#    DECLARE r110_curs1 CURSOR FOR r110_prepare1
#    CALL cl_outnam("asrr110") RETURNING l_name
#    START REPORT r110_rep TO l_name             
#    LET g_pageno = 0
#    FOREACH r110_curs1 INTO sr.*
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         SELECT eci06 INTO sr.eci06
#            FROM eci_file
#           WHERE eci01 = sr.srb02
#         IF SQLCA.sqlcode THEN
#            LET sr.eci06 = ''
#         END IF
#         SELECT gen02 INTO sr.gen02
#            FROM gen_file
#           WHERE gen01 = sr.srb06
#         IF SQLCA.sqlcode THEN
#            LET sr.gen02  = ''
#         END IF
#         OUTPUT TO REPORT r110_rep(sr.*)         
#    END FOREACH
#    FINISH REPORT r110_rep                      
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'srb03,srb04')                                                                                          
          RETURNING tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str = tm.wc                                                                            
     CALL cl_prt_cs1('asrr110','asrr110',l_sql,g_str)    
#No.FUN-7C0034  -----end ----
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
{
REPORT r110_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,            #No.FUN-680130 VARCHAR(1)
          sr        RECORD
                    srb01     LIKE srb_file.srb01,
                    srb02     LIKE srb_file.srb02,
                    eci06     LIKE eci_file.eci06,
                    srb03     LIKE srb_file.srb03,
                    srb04     LIKE srb_file.srb04,
                    srb05     LIKE srb_file.srb05,
                    srb06     LIKE srb_file.srb06,
                    gen02     LIKE gen_file.gen02
                    END RECORD,
          l_str     LIKE type_file.chr20               #No.FUN-680130 VARCHAR(13) 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.srb01,sr.srb02,sr.srb06
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      PRINT g_dash
      CALL cl_prt_pos_dyn()
 
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      LET l_str = sr.srb03,' - ',sr.srb04
      PRINT COLUMN g_c[31],sr.srb01,
            COLUMN g_c[32],sr.srb02,
            COLUMN g_c[33],sr.eci06 CLIPPED,
            COLUMN g_c[34],l_str CLIPPED,
            COLUMN g_c[35],cl_numfor(sr.srb05,35,3),
            COLUMN g_c[36],sr.srb06,
            COLUMN g_c[37],sr.gen02
      PRINT ' '
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4],COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
} 
