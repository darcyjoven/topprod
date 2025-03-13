# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: asrg290.4gl
# Descriptions...: 產值月報表
# Date & Author..: 2006/03/31 By Joe
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0061 06/11/27 By kim 提供外部呼叫列印功能
# Modify.........: No.FUN-7C0034 07/12/12 By johnray 報表打印轉CR
# Modify.........: No.FUN-8A0067 09/03/04 By destiny 修改37區打印時報-201的錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-D30025 13/03/13 By yangtt CR轉GRW        
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,
              bdate   LIKE type_file.dat,         #No.FUN-680130 DATE
              edate   LIKE type_file.dat,         #No.FUN-680130 DATE
              more    LIKE type_file.chr1         #No.FUN-680130 VARCHAR(1)
              END RECORD
   DEFINE g_i LIKE type_file.num5     #count/index for any purpose #No.FUN-680130 SMALLINT
#No.FUN-7C0034 -- begin --
   DEFINE g_sql      STRING
   DEFINE l_table    STRING   #MOD-9A0192 mod chr20->STRING
   DEFINE g_str      STRING
#No.FUN-7C0034 -- end --
 
###GENGRE###START
TYPE sr1_t RECORD
    srg03 LIKE srg_file.srg03,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    srf03 LIKE srf_file.srf03,
    eci06 LIKE eci_file.eci06,
    srf02 LIKE srf_file.srf02,
    srg04 LIKE srg_file.srg04,
    srg05 LIKE srg_file.srg05,
    srg06 LIKE srg_file.srg06,
    srg07 LIKE srg_file.srg07,
    gfe03 LIKE gfe_file.gfe03,
    srg10 LIKE srg_file.srg10,
    sra04 LIKE sra_file.sra04,
    srh05 LIKE srh_file.srh05
END RECORD
###GENGRE###END

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
 
#No.FUN-7C0034 -- begin --
   LET g_sql = "srg03.srg_file.srg03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "srf03.srf_file.srf03,",
               "eci06.eci_file.eci06,",
               "srf02.srf_file.srf02,",
               "srg04.srg_file.srg04,",
               "srg05.srg_file.srg05,",
               "srg06.srg_file.srg06,",
               "srg07.srg_file.srg07,",
               "gfe03.gfe_file.gfe03,",
               "srg10.srg_file.srg10,",
               "sra04.sra_file.sra04,",
               "srh05.srh_file.srh05"
   LET l_table = cl_prt_temptable('asrg290',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-7C0034 -- end --
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g290_tm(0,0)
   ELSE
      CALL g290()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION g290_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680130 SMALLINT
          l_cmd          LIKE type_file.chr1000     #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW g290_w AT p_row,p_col
        WITH FORM "asr/42f/asrg290"
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
            CLOSE WINDOW g290_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
            EXIT PROGRAM
         END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
         CALL cl_err('',9046,0)
      END WHILE
      #FUN-6B0061...................begin
      #外部呼叫時要可以列印srfconf='N'的資料,非外部呼叫,則只列印已確認的資料
      LET tm.wc=tm.wc," AND srfconf='Y'"
      #FUN-6B0061...................end
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
         CLOSE WINDOW g290_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrg290'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrg290','9031',1)   
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
            CALL cl_cmdat('asrg290',g_time,l_cmd)
         END IF
         CLOSE WINDOW g290_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g290()
      ERROR ""
   END WHILE
   CLOSE WINDOW g290_w
END FUNCTION
 
FUNCTION g290()
   DEFINE l_name    LIKE type_file.chr20,  # External(Disk) file name     #No.FUN-680130 VARCHAR(20)
#         l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     STRING,                # RDSQL STATEMENT              
          l_za05    LIKE za_file.za05,     #No.FUN-680130 VARCHAR(40)
          sr        RECORD
                    srg03     LIKE srg_file.srg03,
                    srf03     LIKE srf_file.srf03,
                    srf01     LIKE srf_file.srf01,
                    srf02     LIKE srf_file.srf02,
                    srg02     LIKE srg_file.srg02,
                    srg04     LIKE srg_file.srg04,
                    gfe03     LIKE gfe_file.gfe03,  ## 料號計量時小數位數
                    srg05     LIKE srg_file.srg05,
                    srg06     LIKE srg_file.srg06,
                    srg07     LIKE srg_file.srg07,
                    srg10     LIKE srg_file.srg10,
                    srh05     LIKE srh_file.srh05
                    END RECORD
   DEFINE l_prog  STRING
#No.FUN-7C0034 -- begin --
   DEFINE l_ima02      LIKE ima_file.ima02
   DEFINE l_ima021     LIKE ima_file.ima021
   DEFINE l_eci06      LIKE eci_file.eci06
   DEFINE l_sra04      LIKE sra_file.sra04
#No.FUN-7C0034 -- end --
 
   # No.FUN-B80063----start mark------------------------------------
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6B0014
   # No.FUN-B80063----end mark--------------------------------------
 
#No.FUN-7C0034 -- begin --
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             #No.FUN-8A0067   
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
#No.FUN-7C0034 -- end --
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND sfuuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND sfugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND sfugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT DISTINCT srg03,srf03,srf01,srf02,srg02,",
               " srg04,'',srg05,srg06,srg07,srg10,0 ",
               " FROM srf_file,srg_file ",
               " WHERE ",tm.wc,
               "   AND srf01 = srg01 "
              #"   AND srfconf = 'Y' " #FUN-6B0061 #移到tm()段
              #"   AND srf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'" #FUN-6B0061
 
   #FUN-6B0061..................begin
   IF (NOT cl_null(tm.bdate)) AND (tm.bdate>0) THEN
      LET l_sql=l_sql CLIPPED," AND srf02 >='",tm.bdate,"'"
   END IF
   IF (NOT cl_null(tm.edate)) AND (tm.edate>0) THEN
      LET l_sql=l_sql CLIPPED," AND srf02 <='",tm.edate,"'"
   END IF
   #FUN-6B0061..................end
   PREPARE g290_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   DECLARE g290_curs1 CURSOR FOR g290_prepare1
#No.FUN-7C0034 -- begin --
#   CALL cl_outnam("asrg290") RETURNING l_name
#   START REPORT g290_rep TO l_name
#   LET g_pageno = 0
#No.FUN-7C0034 -- end --
   FOREACH g290_curs1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gfe03 INTO sr.gfe03 FROM gfe_file WHERE gfe01=sr.srg04
      IF SQLCA.sqlcode OR cl_null(sr.gfe03) THEN
         LET sr.gfe03 = 0
      END IF
      SELECT SUM(srh05) INTO sr.srh05 FROM srh_file
       WHERE srh01 = sr.srf01 
         AND srh03 = sr.srg02
      IF SQLCA.sqlcode THEN
         LET sr.srh05 = 0
      END IF
#No.FUN-7C0034 -- begin --
#      OUTPUT TO REPORT g290_rep(sr.*)
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.srg03
      IF SQLCA.sqlcode THEN
         LET l_ima02 = ' '
         LET l_ima021 = ' '
      ELSE
         IF cl_null(l_ima02) THEN
            LET l_ima02 = ' '
         END IF
         IF cl_null(l_ima021) THEN
            LET l_ima021 = ' '
         END IF
      END IF
 
      SELECT eci06 INTO l_eci06 FROM eci_file WHERE eci01 = sr.srf03
      IF SQLCA.sqlcode OR cl_null(l_eci06) THEN
         LET l_eci06 = ' '
      END IF
 
      SELECT sra04 INTO l_sra04 FROM sra_file 
       WHERE sra01 = sr.srf03 
         AND sra02 = sr.srg03
         AND sraacti = 'Y'
      IF SQLCA.sqlcode OR cl_null(l_sra04) THEN
         LET l_sra04 = 0
      END IF
 
      EXECUTE insert_prep USING sr.srg03,l_ima02,l_ima021,sr.srf03,l_eci06,sr.srf02,sr.srg04,
                                sr.srg05,sr.srg06,sr.srg07,sr.gfe03,sr.srg10,l_sra04,sr.srh05
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#No.FUN-7C0034 -- end --
   END FOREACH
#No.FUN-7C0034 -- begin --
#   FINISH REPORT g290_rep
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'srf03,srg03') RETURNING tm.wc
###GENGRE###   LET g_str = tm.wc,";",g_zz05
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   CALL cl_prt_cs3('asrg290','asrg290',g_sql,g_str)
    CALL asrg290_grdata()    ###GENGRE###
#No.FUN-7C0034 -- end --
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6B0014
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT g290_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,      #No.FUN-680130 VARCHAR(1)
          l_srg03      LIKE srg_file.srg03,
          l_srf03      LIKE srf_file.srf03,
          l_sra04      LIKE sra_file.sra04,
          l_sra04_t    LIKE sra_file.sra04,
          l_sra04_s    LIKE sra_file.sra04,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_eci06      LIKE eci_file.eci06,
          l_i          LIKE type_file.num10,     #No.FUN-680130 INTEGER
          sr        RECORD
                    srg03     LIKE srg_file.srg03,
                    srf03     LIKE srf_file.srf03,
                    srf01     LIKE srf_file.srf01,
                    srf02     LIKE srf_file.srf02,
                    srg02     LIKE srg_file.srg02,
                    srg04     LIKE srg_file.srg04,
                    gfe03     LIKE gfe_file.gfe03,  ## 料號計量時小數位數
                    srg05     LIKE srg_file.srg05,
                    srg06     LIKE srg_file.srg06,
                    srg07     LIKE srg_file.srg07,
                    srg10     LIKE srg_file.srg10,
                    srh05     LIKE srh_file.srh05
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.srg03,sr.srf03,sr.srg04
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      #FUN-6B0061....................begin
      IF (NOT cl_null(tm.bdate)) AND (tm.bdate>0) AND
         (NOT cl_null(tm.edate)) AND (tm.edate>0) THEN
         PRINT COLUMN g_c[34],g_x[21] CLIPPED,tm.bdate,' - ',tm.edate
      ELSE
         SKIP 1 LINE
      END IF
      #FUN-6B0061....................end
      PRINT g_head CLIPPED, pageno_total
 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET l_srg03 = ''
      LET l_srf03 = ''
      LET l_i = 1
 
   BEFORE GROUP OF sr.srg03
      LET l_sra04_t = 0
      IF cl_null(l_sra04_s) THEN 
         LET l_sra04_s = 0
      END IF
      LET l_i = 1
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = sr.srg03
      IF SQLCA.sqlcode THEN
         LET l_ima02  = ''
         LET l_ima021 = ''
      END IF
 
   BEFORE GROUP OF sr.srf03
      SELECT eci06 INTO l_eci06 FROM eci_file WHERE eci01 = sr.srf03
      IF SQLCA.sqlcode THEN
         LET l_eci06 = ''
      END IF
      LET l_srf03 = ''
 
   ON EVERY ROW
      SELECT sra04 INTO l_sra04 FROM sra_file 
        WHERE sra01 = sr.srf03 
          AND sra02 = sr.srg03
          AND sraacti = 'Y'
      IF SQLCA.sqlcode THEN
         LET l_sra04 = 0
      END IF
      IF sr.srg03 <> l_srg03 OR cl_null(l_srg03) THEN
         PRINT COLUMN g_c[31],sr.srg03;
         LET l_srg03 = sr.srg03
      ELSE
         CASE 
            WHEN l_i = 2
               PRINT COLUMN g_c[31],l_ima02;
            WHEN l_i = 3 
               PRINT COLUMN g_c[31],l_ima021;
            OTHERWISE
         END CASE 
      END IF 
      LET l_i = l_i + 1       
      IF sr.srf03 <> l_srf03 OR cl_null(l_srf03) THEN
         PRINT COLUMN g_c[32],l_eci06;
         LET l_srf03 = sr.srf03
      END IF 
      PRINT COLUMN g_c[33],sr.srf02,
            COLUMN g_c[34],sr.srg04,
            COLUMN g_c[35],cl_numfor(sr.srg05,35,sr.gfe03),
            COLUMN g_c[36],cl_numfor(sr.srg06,36,sr.gfe03),
            COLUMN g_c[37],cl_numfor(sr.srg07,37,sr.gfe03),
            COLUMN g_c[38],cl_numfor(((sr.srg06+sr.srg07)/(sr.srg05+sr.srg06+sr.srg07))*100,38,3),
            COLUMN g_c[39],cl_numfor(sr.srg10,39,3),
            COLUMN g_c[40],cl_numfor((((sr.srg05+sr.srg06+sr.srg07)/sr.srg10)/(l_sra04/60))*100,40,3),
            COLUMN g_c[41],cl_numfor(sr.srh05,41,3);
      IF l_sra04 = 0 THEN 
         PRINT COLUMN g_c[42],'**產能未設'
      ELSE 
         PRINT ' '
      END IF 
 
   AFTER GROUP OF sr.srf03
      LET l_sra04_t = l_sra04_t + l_sra04
      LET l_sra04_s = l_sra04_s + l_sra04
      CASE 
         WHEN l_i = 2
            PRINT COLUMN g_c[31],l_ima02;
         WHEN l_i = 3 
            PRINT COLUMN g_c[31],l_ima021;
         OTHERWISE
      END CASE 
      LET l_i = l_i + 1
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
            COLUMN g_c[33],g_dash2[1,g_w[33]],
            COLUMN g_c[34],g_dash2[1,g_w[34]],
            COLUMN g_c[35],g_dash2[1,g_w[35]],
            COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[41],g_dash2[1,g_w[41]],
            COLUMN g_c[42],g_dash2[1,g_w[42]]
 
   AFTER GROUP OF sr.srg03
      IF l_i = 3 THEN
         PRINT COLUMN g_c[31],l_ima021;
      END IF
      LET l_i = l_i + 1
      PRINT COLUMN g_c[33],g_x[22],
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.srg05),35,sr.gfe03),
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.srg06),36,sr.gfe03),
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.srg07),37,sr.gfe03),
            COLUMN g_c[38],cl_numfor(((GROUP SUM(sr.srg06)+GROUP SUM(sr.srg07))/(GROUP SUM(sr.srg05)+GROUP SUM(sr.srg06)+GROUP SUM(sr.srg07)))*100,38,3),
            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.srg10),39,3),
            COLUMN g_c[40],cl_numfor((((GROUP SUM(sr.srg05)+GROUP SUM(sr.srg06)+GROUP SUM(sr.srg07))/GROUP SUM(sr.srg10))/(l_sra04_t/60))*100,40,3),
            COLUMN g_c[41],cl_numfor(GROUP SUM(sr.srh05),41,3)
      PRINT ''
 
   ON LAST ROW
      PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
            COLUMN g_c[34],g_dash2[1,g_w[34]],
            COLUMN g_c[35],g_dash2[1,g_w[35]],
            COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[41],g_dash2[1,g_w[41]],
            COLUMN g_c[42],g_dash2[1,g_w[42]]
      PRINT COLUMN g_c[33],g_x[23],
            COLUMN g_c[35],cl_numfor(SUM(sr.srg05),35,sr.gfe03),
            COLUMN g_c[36],cl_numfor(SUM(sr.srg06),36,sr.gfe03),
            COLUMN g_c[37],cl_numfor(SUM(sr.srg07),37,sr.gfe03),
            COLUMN g_c[38],cl_numfor(((SUM(sr.srg06)+SUM(sr.srg07))/(SUM(sr.srg05)+SUM(sr.srg06)+SUM(sr.srg07)))*100,38,3),
            COLUMN g_c[39],cl_numfor(SUM(sr.srg10),39,3),
	    COLUMN g_c[40],cl_numfor((((SUM(sr.srg05)+SUM(sr.srg06)+SUM(sr.srg07))/SUM(sr.srg10))/(l_sra04_s/60))*100,40,3),
            COLUMN g_c[41],cl_numfor(SUM(sr.srh05),41,3)
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN 
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF
 
END REPORT
 
 


###GENGRE###START
FUNCTION asrg290_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asrg290")
        IF handler IS NOT NULL THEN
            START REPORT asrg290_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(srg03)"   #FUN-D30025
          
            DECLARE asrg290_datacur1 CURSOR FROM l_sql
            FOREACH asrg290_datacur1 INTO sr1.*
                OUTPUT TO REPORT asrg290_rep(sr1.*)
            END FOREACH
            FINISH REPORT asrg290_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asrg290_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sql    STRING              #FUN-D30025

    
    ORDER EXTERNAL BY sr1.srg03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.srg03

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.srg03
            #FUN-D30025----add--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE srg03 = '",sr1.srg03,"'",
                        "  ORDER BY eci06,srf03,srg04,srf02 "
            START REPORT asrg290_subrep01
            DECLARE asrg290_repcur1 CURSOR FROM l_sql
            FOREACH asrg290_repcur1 INTO sr1.*
                OUTPUT TO REPORT asrg290_subrep01(sr1.*)
            END FOREACH
            FINISH REPORT asrg290_subrep01
            #FUN-D30025----add--end--

        
        ON LAST ROW
            #FUN-D30025----add--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY srg04"
            START REPORT asrg290_subrep02
            DECLARE asrg290_repcur2 CURSOR FROM l_sql
            FOREACH asrg290_repcur2 INTO sr1.*
                OUTPUT TO REPORT asrg290_subrep02(sr1.*)
            END FOREACH
            FINISH REPORT asrg290_subrep02
            #FUN-D30025----add--end--

END REPORT
#FUN-D30025----add--str--
REPORT asrg290_subrep01(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_bad_yeild      LIKE srg_file.srg05
    DEFINE l_pro_effic      LIKE srg_file.srg05
    DEFINE l_tot_bad_yeild  LIKE srg_file.srg05
    DEFINE l_tot_pro_effic  LIKE srg_file.srg05
    DEFINE l_str            STRING             
    DEFINE l_srg05_sum      LIKE srg_file.srg05
    DEFINE l_srg06_sum      LIKE srg_file.srg06
    DEFINE l_srg07_sum      LIKE srg_file.srg07
    DEFINE l_srg10_sum      LIKE srg_file.srg10
    DEFINE l_srh05_sum      LIKE srh_file.srh05 
    DEFINE l_fmt1           STRING
    DEFINE l_eci06          LIKE eci_file.eci06
    DEFINE sr1_o   sr1_t

    ORDER EXTERNAL BY sr1.eci06,sr1.srf03,sr1.srg04

    FORMAT
        BEFORE GROUP OF sr1.eci06
            LET sr1_o.eci06 = NULL

        ON EVERY ROW
            IF NOT cl_null(sr1_o.eci06) THEN
               IF sr1.eci06 = sr1_o.eci06 THEN
                  LET l_eci06 = "  " 
               ELSE
                  LET l_eci06 = sr1.eci06
               END IF
            ELSE
               LET l_eci06 = sr1.eci06
            END IF
            PRINTX l_eci06
            IF sr1.srg05 + sr1.srg06 + sr1.srg07 = 0 THEN
               LET l_bad_yeild = 0
            ELSE
               LET l_bad_yeild = (sr1.srg06 + sr1.srg07) /(sr1.srg05 + sr1.srg06 + sr1.srg07)*100
            END IF
            PRINTX l_bad_yeild

            IF sr1.srg10 = 0 OR sr1.sra04 = 0 THEN
               LET l_pro_effic = 0
            ELSE
               LET l_pro_effic = (sr1.srg05 + sr1.srg06 + sr1.srg07) / sr1.srg10 / (sr1.sra04 / 60) * 100
            END IF
            PRINTX l_pro_effic

            IF sr1.sra04 = 0 THEN
               LET l_str = cl_gr_getmsg("gre-342",g_lang,0)
            ELSE
               LET l_str = " " 
            END IF
            PRINTX l_str
            PRINTX sr1.*
            LET sr1_o.eci06 = sr1.eci06
        
        AFTER GROUP OF sr1.eci06
            LET l_fmt1 = cl_gr_numfmt('gfe_file','gfe03',sr1.gfe03)
            LET l_fmt1 = cl_replace_str(l_fmt1,"&.","#.")
            PRINTX l_fmt1
            LET l_srg05_sum = GROUP SUM(sr1.srg05)
            LET l_srg06_sum = GROUP SUM(sr1.srg06)
            LET l_srg07_sum = GROUP SUM(sr1.srg07)
            LET l_srg10_sum = GROUP SUM(sr1.srg10)
            LET l_srh05_sum = GROUP SUM(sr1.srh05)
            PRINTX l_srg05_sum,l_srg06_sum,l_srg07_sum,l_srg10_sum,l_srh05_sum

            IF GROUP SUM(sr1.srg05) + GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07) = 0 THEN
               LET l_tot_bad_yeild = 0
            ELSE
               LET l_tot_bad_yeild = (GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07)) /(GROUP SUM(sr1.srg05) + GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07))*100
            END IF
            PRINTX l_tot_bad_yeild

            IF GROUP SUM(sr1.srg10) = 0 OR GROUP SUM(sr1.sra04) = 0 THEN
               LET l_tot_pro_effic = 0 
            ELSE
               LET l_tot_pro_effic = (GROUP SUM(sr1.srg05) + GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07)) / GROUP SUM(sr1.srg10) / (GROUP SUM(sr1.sra04 / 60)) * 100
            END IF
            PRINTX l_tot_pro_effic
     

            
END REPORT

REPORT asrg290_subrep02(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_tot_bad_yeild  LIKE srg_file.srg05
    DEFINE l_tot_pro_effic  LIKE srg_file.srg05
    DEFINE l_srg05_sum      LIKE srg_file.srg05
    DEFINE l_srg06_sum      LIKE srg_file.srg06
    DEFINE l_srg07_sum      LIKE srg_file.srg07
    DEFINE l_srg10_max      LIKE srg_file.srg10
    DEFINE l_srh05_sum      LIKE srh_file.srh05 
    DEFINE l_fmt1           STRING

    ORDER EXTERNAL BY sr1.srg04

    FORMAT
        ON EVERY ROW
            PRINTX sr1.*

        AFTER GROUP OF sr1.srg04
            LET l_fmt1 = cl_gr_numfmt('gfe_file','gfe03',sr1.gfe03)
            LET l_fmt1 = cl_replace_str(l_fmt1,"&.","#.")
            PRINTX l_fmt1
            LET l_srg05_sum = GROUP SUM(sr1.srg05)
            LET l_srg06_sum = GROUP SUM(sr1.srg06)
            LET l_srg07_sum = GROUP SUM(sr1.srg07)
            LET l_srg10_max = GROUP MAX(sr1.srg10)
            LET l_srh05_sum = GROUP SUM(sr1.srh05)
            PRINTX l_srg05_sum,l_srg06_sum,l_srg07_sum,l_srg10_max,l_srh05_sum

            IF GROUP SUM(sr1.srg05) + GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07) = 0 THEN
               LET l_tot_bad_yeild = 0
            ELSE
               LET l_tot_bad_yeild = (GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07)) /(GROUP SUM(sr1.srg05) + GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07))*100
            END IF
            PRINTX l_tot_bad_yeild

            IF GROUP SUM(sr1.srg10) = 0 OR GROUP SUM(sr1.sra04) = 0 THEN
               LET l_tot_pro_effic = 0
            ELSE
               LET l_tot_pro_effic = (GROUP SUM(sr1.srg05) + GROUP SUM(sr1.srg06) + GROUP SUM(sr1.srg07)) / GROUP SUM(sr1.srg10) / (GROUP SUM(sr1.sra04 / 60)) * 100
            END IF
            PRINTX l_tot_pro_effic
END REPORT
#FUN-D30025----add--end--
###GENGRE###END
