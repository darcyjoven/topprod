# Prog. Version..: '5.30.07-13.05.16(00002)'     #
#
# Pattern name...: asrx140.4gl
# Descriptions...: 生產指示單
# Date & Author..: 2006/03/13 By Joe
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-7B0103 07/11/23 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-CB0004 12/11/13 By dongsz CR轉XtraGrid
# Modify.........: No.FUN-CB0003 12/12/26 By chenjing 報表顯示增加班別說明欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, 
              bdate   LIKE type_file.dat,        #No.FUN-680130 DATE
              edate   LIKE type_file.dat,        #No.FUN-680130 DATE
              yy      LIKE type_file.num5,       #No.FUN-680130 SMALLINT
              mm      LIKE type_file.num5,       #No.FUN-680130 SMALLINT
              remk    LIKE type_file.chr20,      #No.FUN-680130 VARCHAR(20)
              more    LIKE type_file.chr1        #No.FUN-680130 VARCHAR(1)
              END RECORD
   DEFINE g_i LIKE type_file.num5     #count/index for any purpose   #No.FUN-680130 SMALLINT
   DEFINE g_str STRING                           #No.FUN-7B0103 
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
      CALL x140_tm(0,0)
   ELSE
      CALL x140()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION x140_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW x140_w AT p_row,p_col
        WITH FORM "asr/42f/asrx140"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
 
   WHILE TRUE
      WHILE TRUE
         CONSTRUCT BY NAME tm.wc ON sre03,sre04
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
   
            ON ACTION controlp     
               CASE WHEN INFIELD(sre03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_eci"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sre03
                       NEXT FIELD sre03
                    WHEN INFIELD(sre04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ima"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sre04
                       NEXT FIELD sre04
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
            CLOSE WINDOW x140_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
            EXIT PROGRAM
         END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
         CALL cl_err('',9046,0)
      END WHILE
      INPUT BY NAME tm.bdate,tm.edate,tm.yy,tm.mm,tm.remk,tm.more WITHOUT DEFAULTS
   
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
   
         AFTER FIELD bdate
             IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
   
         AFTER FIELD edate
             IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
             IF tm.edate < tm.bdate THEN NEXT FIELD edate END IF
 
         AFTER FIELD mm
             IF (NOT cl_null(tm.yy)) AND (NOT cl_null(tm.mm)) THEN
               IF MDY(tm.mm,1,tm.yy) IS NULL THEN
                  NEXT FIELD yy
               END IF
             END IF
 
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
         CLOSE WINDOW x140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrx140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrx140','9031',1)  
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
            CALL cl_cmdat('asrx140',g_time,l_cmd)
         END IF
         CLOSE WINDOW x140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL x140()
      ERROR ""
   END WHILE
   CLOSE WINDOW x140_w
END FUNCTION
 
FUNCTION x140()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name    #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT   #No.FUN-680130 VARCHAR(40)
          l_za05    LIKE za_file.za05,             #No.FUN-680130 VARCHAR(20)
          sr        RECORD
                    sre01     LIKE sre_file.sre01,
                    sre02     LIKE sre_file.sre02,
                    sre03     LIKE sre_file.sre03,
                    sre05     LIKE sre_file.sre05,
                    sre06     LIKE sre_file.sre06,
                    sre04     LIKE sre_file.sre04,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    sra03     LIKE sra_file.sra03, 
                    sre07     LIKE sre_file.sre07
                    END RECORD
     DEFINE l_prog  STRING 
    
     # No.FUN-B80063----start mark-----------------------------------
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
     # No.FUN-B80063----end mark-------------------------------------

     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7B0103
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
 
     #No.FUN-7B0103---Begin
     #LET l_sql = "SELECT sre01,sre02,sre03,sre05,sre06,sre04,'','',sra03,sre07",
     #            " FROM sra_file,sre_file ",
     #            " WHERE sra01 = sre03 ",
     #            "   AND sra02 = sre04 ",    
     #            "   AND sre07 <> 0 ",    
     #            "   AND sre01 = ",tm.yy,    
     #            "   AND sre02 = ",tm.mm,    
     #            "   AND sre06 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME)",
     #            "   AND ",tm.wc clipped
 
     LET l_sql = "SELECT sre01,sre02,sre03,sre05,sre06,sre04,ima02,ima021,sra03,sre07,sre01||sre02||sre03,ecg02",  #FUN-CB0003 add ecg02
                 " FROM sra_file,sre_file LEFT OUTER JOIN ecg_file ON sre05 = ecg01,ima_file ",  #FUN-CB0003 ADD LEFT OUTER JOIN ecg_file ON sre01 = ecg01
                 " WHERE sra01 = sre03 ",
                 "   AND sra02 = sre04 ",    
                 "   AND sre07 <> 0 ",    
                 "   AND ima01 = sre04 ",
                 "   AND sre01 = ",tm.yy,    
                 "   AND sre02 = ",tm.mm,    
          #      "   AND sre06 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME)",   #FUN-CB0004 mark
                 #"   AND sre06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",              #FUN-CB0004 add
                 "   AND sre06 BETWEEN CAST('",tm.bdate,"' AS DATE) AND CAST('",tm.edate,"' AS DATE)",
                 "   AND ",tm.wc clipped
     #PREPARE x140_prepare1 FROM l_sql
     #IF SQLCA.sqlcode != 0 THEN
     #   CALL cl_err('prepare:',SQLCA.sqlcode,1)
     #   EXIT PROGRAM
     #END IF
     #DECLARE x140_curs1 CURSOR FOR x140_prepare1
     #CALL cl_outnam("asrx140") RETURNING l_name
     #START REPORT x140_rep TO l_name
     #LET g_pageno = 0
     #FOREACH x140_curs1 INTO sr.*
     #     IF SQLCA.sqlcode THEN
     #        CALL cl_err('foreach:',SQLCA.sqlcode,1)
     #        EXIT FOREACH
     #     END IF
     #     SELECT ima02,ima021 INTO sr.ima02,sr.ima021
     #        FROM ima_file
     #       WHERE ima01 = sr.sre04
     #     IF SQLCA.sqlcode THEN
     #        LET sr.ima02 = ''
     #        LET sr.ima021 = ''
     #     END IF
     #     OUTPUT TO REPORT x140_rep(sr.*)
     #END FOREACH
     #FINISH REPORT x140_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_xgrid.sql = l_sql                #FUN-CB0004 add
     IF g_zz05 = 'Y' THEN                                                        
        CALL cl_wcchp(tm.wc,'sre03,sre04')                           
          RETURNING tm.wc                                                        
     END IF        
    #FUN-CB0004--add--str---
     LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
     LET g_xgrid.headerinfo1 = cl_getmsg('azz1293',g_lang),tm.yy,'/',tm.mm
     LET g_xgrid.footerinfo1 = cl_getmsg('azz1294',g_lang),tm.remk
     LET g_xgrid.skippage_field = 'sre01||sre02||sre03'
     CALL cl_xg_view()
    #FUN-CB0004--add--end---                                                              
    #LET g_str = tm.wc,";",tm.yy,";",tm.mm,";",tm.remk     #FUN-CB0004 mark                           
    #CALL cl_prt_cs1('asrx140','asrx140',l_sql,g_str)      #FUN-CB0004 mark
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7B0103---Begin
#REPORT x140_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,               #No.FUN-680130 VARCHAR(1)
#          sr        RECORD
#                    sre01     LIKE sre_file.sre01,
#                    sre02     LIKE sre_file.sre02,
#                    sre03     LIKE sre_file.sre03,
#                    sre05     LIKE sre_file.sre05,
#                    sre06     LIKE sre_file.sre06,
#                    sre04     LIKE sre_file.sre04,
#                    ima02     LIKE ima_file.ima02,
#                    ima021    LIKE ima_file.ima021,
#                    sra03     LIKE sra_file.sra03, 
#                    sre07     LIKE sre_file.sre07
#                    END RECORD,
#          l_no      LIKE type_file.num5,               #No.FUN-680130 SMALLINT
#          l_str1    STRING, 
#          l_str2    STRING
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.sre01,sr.sre02,sr.sre03,sr.sre06,sr.sre04
 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
 
#      PRINT g_dash
#      CALL cl_prt_pos_dyn()
 
#      LET l_str1 = tm.yy
#      LET l_str2 = tm.mm
#      LET l_str1 = l_str1.trim()
#      LET l_str2 = l_str2.trim()
 
#      PRINT g_x[8],':',l_str1,'/',l_str2 
#      PRINT g_x[9],':',sr.sre03
#      PRINT 
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.sre03
#      LET l_no = 0
#      SKIP TO TOP OF PAGE
 
#   ON EVERY ROW
#      LET l_no = l_no + 1
#      PRINT COLUMN g_c[31],l_no USING '####',
#            COLUMN g_c[32],sr.sre05,
#            COLUMN g_c[33],sr.sre06,
#            COLUMN g_c[34],sr.sre04 CLIPPED,
#            COLUMN g_c[35],sr.ima02 CLIPPED,
#            COLUMN g_c[36],sr.ima021 CLIPPED,
#            COLUMN g_c[37],sr.sra03,
#            COLUMN g_c[38],cl_numfor(sr.sre07,38,3)
 
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash
#      PRINT g_x[4],COLUMN (g_len-9),g_x[7] CLIPPED
#      PRINT ' '
#      PRINT g_x[10],tm.remk
#      PRINT g_x[14]
#      PRINT g_memo
 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE 
#         SKIP 2 LINE
#      END IF
 
#END REPORT
#No.FUN-7B0103---End
 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

