# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: asrx280.4gl
# Descriptions...: 產值月報表
# Date & Author..: 2006/03/31 By Joe
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-7B0103 07/11/22 BY xiaofeizhu報表改為Crystal Report或p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-CB0003 12/11/06 By chenjing CR轉XtraGrid
# Modify.........: No.FUN-D40129 13/05/22 By yangtt WHERE條件錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, 
              bdate   LIKE type_file.dat,        #No.FUN-680130 DATE
              edate   LIKE type_file.dat,        #No.FUN-680130 DATE
              more    LIKE type_file.chr1        #No.FUN-680130 VARCHAR(1)
              END RECORD
   DEFINE  g_i LIKE type_file.num5     #count/index for any purpose        #No.FUN-680130 SMALLINT
   DEFINE  l_table    STRING,                    ### FUN-7B0103 ###                                                                    
           g_str      STRING,                    ### FUN-7B0103 ###                                                                    
           g_sql      STRING                     ### FUN-7B0103 ###
 
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
### *** FUN-7B0103 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "srg03.srg_file.srg03,",                                                                                             
               "srg04.srg_file.srg04,",                                                                                             
               "qty1.sfv_file.sfv09,",
               "qty2.ima_file.ima33,",
               "qty3.ima_file.ima33,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",                                                                              
               "gfe03.gfe_file.gfe03,",
           #FUN-CB0003--str---
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04"
           #FUN-CB0003--end---                                                                                               
    LET l_table = cl_prt_temptable('asrx280',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?,?,?)"     #FUN-CB0003 add 2?                                                                                        
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
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
      CALL x280_tm(0,0)
   ELSE
      CALL x280()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION x280_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW x280_w AT p_row,p_col
        WITH FORM "asr/42f/asrx280"
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
         CONSTRUCT BY NAME tm.wc ON srf03,srg03
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
   
            ON ACTION controlp     
               CASE WHEN INFIELD(srf03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_eci"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO srf03
                       NEXT FIELD srf03
                    WHEN INFIELD(srg03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ima"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO srg03
                       NEXT FIELD srg03
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
            CLOSE WINDOW x280_w
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
         CLOSE WINDOW x280_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrx280'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrx280','9031',1)   
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
            CALL cl_cmdat('asrx280',g_time,l_cmd)
         END IF
         CLOSE WINDOW x280_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL x280()
      ERROR ""
   END WHILE
   CLOSE WINDOW x280_w
END FUNCTION
 
FUNCTION x280()
   DEFINE l_name    LIKE type_file.chr20,  # External(Disk) file name      #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     STRING,                # RDSQL STATEMENT 
          l_za05    LIKE za_file.za05,     #No.FUN-680130 VARCHAR(20)
          sr        RECORD
                    srg03     LIKE srg_file.srg03,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    srg04     LIKE srg_file.srg04,
                    gfe03     LIKE gfe_file.gfe03,
                    qty1      LIKE sfv_file.sfv09,
                    qty2      LIKE ima_file.ima33,
                    qty3      LIKE ima_file.ima33
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
     #         LET tm.wc = tm.wc clipped," AND sfugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT DISTINCT srg03,'','',srg04,'','','','' ",
                 " FROM srf_file,srg_file ",
                 " WHERE ",tm.wc,
                 "   AND srf01 = srg01 ",
                 "   AND srfconf = 'Y' ",
                 "   AND srf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
 
     PREPARE x280_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM
     END IF
     DECLARE x280_curs1 CURSOR FOR x280_prepare1
#    CALL cl_outnam("asrx280") RETURNING l_name            #No.FUN-7B0103
#    START REPORT x280_rep TO l_name                       #No.FUN-7B0103
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-7B0103 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-7B0103 add ###                                              
     #------------------------------ CR (2) ------------------------------#
     LET g_pageno = 0
     FOREACH x280_curs1 INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT ima02,ima021,ima33 INTO sr.ima02,sr.ima021,sr.qty2 FROM ima_file
          WHERE ima01 = sr.srg03
        IF SQLCA.sqlcode THEN
           LET sr.ima02  = ''
           LET sr.ima021 = ''
           LET sr.qty2 = 0          
        END IF
        SELECT gfe03 INTO sr.gfe03 FROM gfe_file WHERE gfe01=sr.srg04
        IF SQLCA.sqlcode OR cl_null(sr.gfe03) THEN
           LET sr.gfe03 = 0
        END IF
        SELECT SUM(sfv09) INTO sr.qty1 FROM sfu_file,sfv_file
          WHERE sfu01 = sfv01
            AND sfupost = 'Y'
            AND sfu02 BETWEEN tm.bdate AND tm.edate
           #AND sfv11 = sr.srg03  #FUN-D40129 mark
            AND sfv04 = sr.srg03  #FUN-D40129 add
        IF SQLCA.sqlcode OR cl_null(sr.qty1) THEN
           LET sr.qty1 = 0
        END IF
        LET sr.qty3 = sr.qty1 * sr.qty2
#       OUTPUT TO REPORT x280_rep(sr.*)                     #No.FUN-7B0103
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7B0103 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.srg03,sr.srg04,sr.qty1,sr.qty2,sr.qty3,sr.ima02,sr.ima021,sr.gfe03                                                            
                   ,g_azi03,g_azi04            #FUN-CB0003 add
          #------------------------------ CR (3) ------------------------------#
     END FOREACH
#No.FUN-7B0103--Begin-Add                                                                                                           
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'srf03,srg03')                                                                                               
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-7B0103 **** ##                                                     
###XtraGrid###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
###XtraGrid###    LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_azi03,";",g_azi04,";",g_azi05                                                                                     
###XtraGrid###    CALL cl_prt_cs3('asrx280','asrx280',l_sql,g_str)                                                                                
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003--add--str---
#   LET g_xgrid.grup_field = 'srg03,srg04'
    LET g_xgrid.order_field = 'srg03,srg04'
    LET g_xgrid.headerinfo1=cl_getmsg('lib-035',g_lang),":",tm.bdate,"-",tm.edate
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
#FUN-CB0003--add--end---
    CALL cl_xg_view()    ###XtraGrid###
    #------------------------------ CR (4) ------------------------------#                                                          
#No.FUN-7B0103--End-Add
#    FINISH REPORT x280_rep                                                       #No.FUN-7B0103                             
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                  #No.FUN-7B0103
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7B0103
#REPORT x280_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680130 VARCHAR(1)
#         sr        RECORD
#                   srg03     LIKE srg_file.srg03,
#                   ima02     LIKE ima_file.ima02,
#                   ima021    LIKE ima_file.ima021,
#                   srg04     LIKE srg_file.srg04,
#                   gfe03     LIKE gfe_file.gfe03,
#                   qty1      LIKE sfv_file.sfv09,
#                   qty2      LIKE ima_file.ima33,
#                   qty3      LIKE ima_file.ima33
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.srg03,sr.srg04
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT COLUMN g_c[33],g_x[21] CLIPPED,tm.bdate,' - ',tm.edate
#     PRINT g_head CLIPPED, pageno_total
 
#     PRINT g_dash
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#     PRINTX name=H2 g_x[36]
#     PRINTX name=H3 g_x[37]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     PRINTX name=D1 COLUMN g_c[31],sr.srg03,
#                    COLUMN g_c[32],sr.srg04,
#                    COLUMN g_c[33],cl_numfor(sr.qty1,33,sr.gfe03),
#                    COLUMN g_c[34],cl_numfor(sr.qty2,34,g_azi03),  ##單價小數限制
#                    COLUMN g_c[35],cl_numfor(sr.qty3,35,g_azi04)
#     PRINTX name=D2 COLUMN g_c[36],sr.ima02 CLIPPED
#     PRINTX name=D3 COLUMN g_c[37],sr.ima021 CLIPPED
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT ''
#     PRINT ''
#     PRINT COLUMN g_c[34],g_x[8],
#           COLUMN g_c[35],cl_numfor(SUM(sr.qty1*sr.qty2),35,g_azi05)
#     PRINT g_dash
#     PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE 
#        SKIP 2 LINE
#     END IF
#
#END REPORT
#No.FUN-7B0103--End--Mark--
 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
