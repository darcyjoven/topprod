# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: asrx100.4gl
# Descriptions...: 生產排程明細表
# Date & Author..: 2006/03/09 By Joe
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-7C0034 07/12/11 By jan 報表格式修改為crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-CB0004 12/11/06 By dongsz CR轉XtraGrid
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, 
              bdate   LIKE type_file.dat,          #No.FUN-680130 DATE 
              edate   LIKE type_file.dat,          #No.FUN-680130 DATE
              diff    LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1) 
              more    LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
              END RECORD
   DEFINE g_i LIKE type_file.num5     #count/index for any purpose    #No.FUN-680130 SMALLINT 
   DEFINE g_sql    STRING             #No.FUN-7C0034
   DEFINE l_table  STRING             #No.FUN-7C0034
   DEFINE g_str    STRING             #No.FUN-7C0034         
 
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
#No.FUN-7C0034--BEGIN--
   LET g_sql="sre03.sre_file.sre03,",                                                                                               
             "eci06.eci_file.eci06,",                                                                                               
             "sre06.sre_file.sre06,",                                                                                               
             "sre04.sre_file.sre04,",                                                                                               
             "ima02.ima_file.ima02,",                                                                                               
             "ima021.ima_file.ima021,",                                                                                               
             "sra03.sra_file.sra03,",
             "sre07.sre_file.sre07,",                                                                                               
             "sre11.sre_file.sre11,",
             "aa1.sre_file.sre11,",        #FUN-CB0004 add
             "aa2.type_file.num10,",         #FUN-CB0004 add       
             "point.type_file.num5"        #FUN-CB0004 add                                                                                      
    LET l_table=cl_prt_temptable("asrx100",g_sql) CLIPPED                                                                           
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?,?,?)"                      #FUN-CB0004 add 3?                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("insert_prep:",status,1)                                                                                         
    END IF
#No.FUN-7C0034--END--
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
      CALL x100_tm(0,0)
   ELSE
      CALL x100()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION x100_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW x100_w AT p_row,p_col
        WITH FORM "asr/42f/asrx100"
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
   LET tm.diff = 'N'
 
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
            CLOSE WINDOW x100_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
            EXIT PROGRAM
         END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
         CALL cl_err('',9046,0)
      END WHILE
      INPUT BY NAME tm.bdate,tm.edate,tm.diff,tm.more WITHOUT DEFAULTS
   
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
         CLOSE WINDOW x100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrx100'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrx100','9031',1)   
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
            CALL cl_cmdat('asrx100',g_time,l_cmd)
         END IF
         CLOSE WINDOW x100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL x100()
      ERROR ""
   END WHILE
   CLOSE WINDOW x100_w
END FUNCTION
 
FUNCTION x100()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name      #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680130 VARCHAR(1000)
          l_za05    LIKE za_file.za05,          #No.FUN-680130 VARCHAR(40)
          sr        RECORD
                    sre03     LIKE sre_file.sre03,
                    eci06     LIKE eci_file.eci06,
                    sre06     LIKE sre_file.sre06,
                    sre04     LIKE sre_file.sre04,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    sra03     LIKE sra_file.sra03,
                    sre07     LIKE sre_file.sre07,
                    sre11     LIKE sre_file.sre11
                    END RECORD
     DEFINE l_prog  STRING
     DEFINE l_aa1   LIKE sre_file.sre11           #FUN-CB0004 add
     DEFINE l_aa2   LIKE type_file.num10          #FUN-CB0004 add
     DEFINE l_pot   LIKE type_file.num5           #FUN-CB0004 add
     
     # No.FUN-B80063----start mark------------------------------------ 
     # CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
     # No.FUN-B80063----end mark--------------------------------------

     CALL cl_del_data(l_table)     #No.FUN-7C0034
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7C0034
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
 
     LET l_sql = "SELECT sre03,'',sre06,sre04,'','',",
                 "sra03,sre07,sre11",
                 " FROM sre_file,sra_file ",
                 " WHERE sra01 = sre03 ",
                 "   AND sra02 = sre04 ",
                 "   AND sre06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND ",tm.wc clipped
 
     IF tm.diff='Y' THEN
        LET l_sql=l_sql," AND sre11-sre07<>0"
     END IF
 
     PREPARE x100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM
     END IF
     DECLARE x100_curs1 CURSOR FOR x100_prepare1
#    CALL cl_outnam("asrx100") RETURNING l_name   #No.FUN-7C0034
#    START REPORT x100_rep TO l_name              #No.FUN-7C0034
     LET g_pageno = 0
     FOREACH x100_curs1 INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          SELECT eci06 INTO sr.eci06
             FROM eci_file
            WHERE eci01 = sr.sre03
          IF SQLCA.sqlcode THEN
             LET sr.eci06 = ''
          END IF
          SELECT ima02,ima021 INTO sr.ima02,sr.ima021
             FROM ima_file
            WHERE ima01 = sr.sre04
          IF SQLCA.sqlcode THEN
             LET sr.ima02  = ''
             LET sr.ima021 = ''
          END IF
         #FUN-CB0004--add--str---
          LET l_pot = 3
          LET l_aa1 = sr.sre11 - sr.sre07
          IF sr.sre07 = 0  THEN
             LET l_aa2 = 0
          ELSE 
             LET l_aa2 = ((sr.sre11-sr.sre07)/sr.sre07)*100
          END IF
         #FUN-CB0004--add--end--- 
#No.FUN-7C0034--BEGIN--
#         OUTPUT TO REPORT x100_rep(sr.*)
           EXECUTE insert_prep USING sr.sre03,sr.eci06,sr.sre06,sr.sre04,sr.ima02,
                                     sr.ima021,sr.sra03,sr.sre07,sr.sre11,l_aa1,l_aa2,l_pot     #FUN-CB0004 add l_aa1,l_aa2,l_pot
     END FOREACH
#    FINISH REPORT x100_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###XtraGrid###     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                  
    LET g_xgrid.table = l_table    ###XtraGrid###
     IF g_zz05='Y' THEN                                                                                                              
        CALL cl_wcchp(tm.wc,'sre03,sre04')                                                           
        RETURNING tm.wc                                                                                                              
     END IF                                                                                                                          
###XtraGrid###     LET g_str=tm.wc                                                                                                                 
###XtraGrid###     CALL cl_prt_cs3('asrx100','asrx100',g_sql,g_str)
   #FUN-CB0004--add--str---
    LET g_xgrid.order_field = "sre03,sre06,sre04"
   #LET g_xgrid.grup_field = "sre03,sre06,sre04"
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-7C0034--END--
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7C0034--BEGIN--
{
REPORT x100_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
          sr        RECORD
                    sre03     LIKE sre_file.sre03,
                    eci06     LIKE eci_file.eci06,
                    sre06     LIKE sre_file.sre06,
                    sre04     LIKE sre_file.sre04,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    sra03     LIKE sra_file.sra03,
                    sre07     LIKE sre_file.sre07,
                    sre11     LIKE sre_file.sre11
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.sre03,sr.sre06,sr.sre04
 
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
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.sre03,
            COLUMN g_c[32],sr.eci06 CLIPPED,
            COLUMN g_c[33],sr.sre06,
            COLUMN g_c[34],sr.sre04,
            COLUMN g_c[35],sr.ima02 CLIPPED,
            COLUMN g_c[36],sr.ima021 CLIPPED,
            COLUMN g_c[37],sr.sra03,
            COLUMN g_c[38],cl_numfor(sr.sre07,38,3),
            COLUMN g_c[39],cl_numfor(sr.sre11,39,3),
            COLUMN g_c[40],cl_numfor(sr.sre11-sr.sre07,40,3),
            COLUMN g_c[41],cl_numfor(((sr.sre11-sr.sre07)/sr.sre07)*100,9,2),'%'
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
 
END REPORT}
#No.FUN-7C0034--END
 
 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
