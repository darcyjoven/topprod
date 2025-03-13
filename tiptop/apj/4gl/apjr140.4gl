# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apjr140.4gl
# Descriptions...: 專案預估成本表
# Date & Author..: 08/03/24 By Zhangyajun
# Modify.........: No.FUN-830101 因表結構變更，重寫本程序
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0268 10/12/17 By yinhy 增加查詢開窗功能
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		           # Print condition RECORD             
              wc   STRING,                 
               f    LIKE type_file.chr1,   #No.FUN-680103  VARCHAR(01)
              g     LIKE type_file.chr1,   #No.FUN-680103  VARCHAR(01)
              more   LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01)  # 特殊列印條件
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     
DEFINE   l_table         STRING, 
         g_str           STRING,  
         g_sql           STRING   
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 
   LET g_sql  = "ds01.type_file.chr1,",
                "ds02.pja_file.pja01,",
                "ds03.pja_file.pja02,",
                "ds04.pja_file.pja05,",
                "ds05.pja_file.pja08,",
                "ds06.gen_file.gen02,",
                "ds07.pja_file.pja09,",
                "ds08.gem_file.gem02,",
                "ds09.pja_file.pja14,",
                "ds10.pja_file.pja15,",
                "ds11.pjb_file.pjb02,",
                "ds12.pjb_file.pjb03,",
                "ds13.type_file.chr50,",
                "ds14.type_file.chr1000,",
                "ds15.pjd_file.pjd03,",
                "ds16.aag_file.aag02,",
                "ds17.type_file.num10,",
                "ds18.type_file.chr4,",
                "ds19.type_file.num20_6,",
                "ds20.type_file.num20_6,",
                "ds21.type_file.num20_6,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05,",
                "t_azi04.azi_file.azi04,",
                "azi07.azi_file.azi07"      #No.FUN-870151
   LET l_table = cl_prt_temptable('apjr140',g_sql) CLIPPED          # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                         # Temp Table產生           
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  #FUN-870151 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.f     = ARG_VAL(8)
   LET tm.g     = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
    DROP TABLE apj_temp
    CREATE TEMP TABLE apj_temp
       (ds01 LIKE type_file.chr1,
        ds02 LIKE pja_file.pja01,
        ds03 LIKE pja_file.pja02,
        ds04 LIKE pja_file.pja05,
        ds05 LIKE pja_file.pja08,
        ds06 LIKE gen_file.gen02,
        ds07 LIKE pja_file.pja09,
        ds08 LIKE gem_file.gem02,
        ds09 LIKE pja_file.pja14,
        ds10 LIKE pja_file.pja15,
        ds11 LIKE pjb_file.pjb02,
        ds12 LIKE pjb_file.pjb03,
        ds13 LIKE type_file.chr50,
        ds14 LIKE type_file.chr1000,
        ds15 LIKE pjd_file.pjd03,
        ds16 LIKE aag_file.aag02,
        ds17 LIKE type_file.num10,
        ds18 LIKE type_file.chr4,
        ds19 LIKE type_file.num20_6,
        ds20 LIKE type_file.num20_6,
        ds21 LIKE type_file.num20_6)
    IF STATUS THEN
       CALL cl_err('Create apj_temp: ',STATUS,1)
       RETURN
    END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r140_tm(0,0)	
   ELSE
      CALL r140()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r140_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     
   DEFINE p_row,p_col	LIKE type_file.num5,    
          l_cmd		LIKE type_file.chr1000  
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5
      LET p_col = 18
   ELSE
      LET p_row = 4
      LET p_col = 11
   END IF
   OPEN WINDOW r140_w AT p_row,p_col
        WITH FORM "apj/42f/apjr140"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.f      = '1'
   LET tm.g = '1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME  tm.wc ON pja01,pjb02,pja05,pja09,pja08
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     #No.TQC-AC0268  --Begin
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pja01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pja"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja01
               NEXT FIELD pja01
            WHEN INFIELD(pjb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb02
               NEXT FIELD pjb02
            WHEN INFIELD(pja09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja09
               NEXT FIELD pja09
            WHEN INFIELD(pja08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja08
               NEXT FIELD pja08
            OTHERWISE EXIT CASE
         END CASE
     #No.TQC-AC0268  --End
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.f,tm.g,tm.more  WITHOUT DEFAULTS
        
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         
 
         AFTER FIELD f
            IF tm.f NOT MATCHES'[12]' THEN
               NEXT FIELD f
            END IF
 
         AFTER FIELD g
            IF tm.g NOT MATCHES'[12]' THEN
               NEXT FIELD g
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
         CLOSE WINDOW r140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	
                WHERE zz01='apjr140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apjr140','9031',1)
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
                            " '",tm.f CLIPPED,"'",              
                            " '",tm.g CLIPPED,"'",                     
                            " '",g_rep_user CLIPPED,"'",       
                            " '",g_rep_clas CLIPPED,"'",        
                            " '",g_template CLIPPED,"'"         
            CALL cl_cmdat('apjr140',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r140_d()
      ERROR ""
   END WHILE
   CLOSE WINDOW r140_w
END FUNCTION
 
FUNCTION r140_d()
DEFINE #l_sql LIKE type_file.chr1000, 
       l_sql        STRING,       #NO.FUN-910082           
       re    RECORD
          ds01 LIKE type_file.chr1,
          ds02 LIKE pja_file.pja01,
          ds03 LIKE pja_file.pja02,
          ds04 LIKE pja_file.pja05,
          ds05 LIKE pja_file.pja08,
          ds06 LIKE gen_file.gen02,
          ds07 LIKE pja_file.pja09,
          ds08 LIKE gem_file.gem02,
          ds09 LIKE pja_file.pja14,
          ds10 LIKE pja_file.pja15,
          ds11 LIKE pjb_file.pjb02,
          ds12 LIKE pjb_file.pjb03,
          ds13 LIKE type_file.chr50,
          ds14 LIKE type_file.chr1000,
          ds15 LIKE pjd_file.pjd03,
          ds16 LIKE aag_file.aag02,
          ds17 LIKE type_file.num10,
          ds18 LIKE type_file.chr4,
          ds19 LIKE type_file.num20_6,
          ds20 LIKE type_file.num20_6,
          ds21 LIKE type_file.num20_6   
        END RECORD
 
   DELETE FROM apj_temp
 
   LET l_sql="SELECT '1',pja01,pja02,pja05,pja08,'',pja09,'',pja14,pja15,pjb02,pjb03,",
             "pjf03,pjf04,'','','','','',pjf05,0",
             "  FROM pja_file,pjb_file,pjf_file",
             " WHERE pja01=pjb01 AND pjb02=pjf01 AND ",tm.wc CLIPPED
   PREPARE r140_csp1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('P1',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
   DECLARE r140_cs1 CURSOR FOR r140_csp1
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('D1',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
   LET l_sql="SELECT '2',pja01,pja02,pja05,pja08,'',pja09,'',pja14,pja15,pjb02,pjb03,",
             "pjh02,'','','','','','',pjh03,0",
             "  FROM pja_file,pjb_file,pjh_file",
             " WHERE pja01=pjb01 AND pjb02=pjh01 AND ",tm.wc CLIPPED
   PREPARE r140_csp2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('P2',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
   DECLARE r140_cs2 CURSOR FOR r140_csp2
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('D2',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
   LET l_sql="SELECT '3',pja01,pja02,pja05,pja08,'',pja09,'',pja14,pja15,pjb02,pjb03,",
             "pjm02,'','','',pjm03,'','',pjm04,0",
             "  FROM pja_file,pjb_file,pjm_file",
             " WHERE pja01=pjb01 AND pjb02=pjm01 AND ",tm.wc CLIPPED
   PREPARE r140_csp3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('P3',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
   DECLARE r140_cs3 CURSOR FOR r140_csp3
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('D3',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
   LET l_sql="SELECT '4',pja01,pja02,pja05,pja08,'',pja09,'',pja14,pja15,pjb02,pjb03,",
             "pjd02,'',pjd03,'','','','','',pjd05",
             "  FROM pja_file,pjb_file,pjd_file",
             " WHERE pja01=pjb01 AND pjb02=pjd01 AND ",tm.wc CLIPPED
   PREPARE r140_csp4 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('P4',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
   DECLARE r140_cs4 CURSOR FOR r140_csp4
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('D4',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
   FOREACH r140_cs1 INTO re.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F1:',SQLCA.sqlcode,1)
            RETURN
        END IF
        SELECT gem02 INTO re.ds08 FROM gem_file WHERE gem01=re.ds07
        SELECT gen02 INTO re.ds06 FROM gen_file WHERE gen01=re.ds05
        IF tm.f='1' THEN
           SELECT ima25,ima53 INTO re.ds18,re.ds19
             FROM ima_file WHERE ima01=re.ds13
        ELSE
           SELECT ima25,ima531 INTO re.ds18,re.ds19
             FROM ima_file WHERE ima01=re.ds13
        END IF
        LET re.ds21=re.ds19*re.ds20
 
        INSERT INTO apj_temp VALUES (re.*)      
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","apj_temp",re.ds02,re.ds01,SQLCA.sqlcode,"","INSERT-F1",1) 
            RETURN
        END IF
   END FOREACH
 
   FOREACH r140_cs2 INTO re.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F2:',SQLCA.sqlcode,1)
            RETURN
        END IF
        SELECT gem02 INTO re.ds08 FROM gem_file WHERE gem01=re.ds07
        SELECT gen02 INTO re.ds06 FROM gen_file WHERE gen01=re.ds05
        #SELECT cpi02 INTO re.ds14 FROM cpi_file WHERE cpi01=re.ds13   #TQC-B90211
        SELECT pjx02,pjx03 INTO re.ds18,re.ds19 FROM pjx_file WHERE pjx01=re.ds13
        LET re.ds21=re.ds19*re.ds20 
        INSERT INTO apj_temp VALUES (re.*)      
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","apj_temp",re.ds02,re.ds01,SQLCA.sqlcode,"","INSERT-F2",1) 
            RETURN
        END IF
   END FOREACH
 
   FOREACH r140_cs3 INTO re.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F3:',SQLCA.sqlcode,1)
            RETURN
        END IF
        SELECT gem02 INTO re.ds08 FROM gem_file WHERE gem01=re.ds07
        SELECT gen02 INTO re.ds06 FROM gen_file WHERE gen01=re.ds05
        SELECT pjy02,pjy03,pjy04 INTO re.ds14,re.ds18,re.ds19 FROM pjy_file WHERE pjy01=re.ds13
        
        LET re.ds21=re.ds19*re.ds20
 
        INSERT INTO apj_temp VALUES (re.*)     
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","apj_temp",re.ds02,re.ds01,SQLCA.sqlcode,"","INSERT-F3",1) 
            RETURN
        END IF
       END FOREACH 
        FOREACH r140_cs4 INTO re.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F4:',SQLCA.sqlcode,1)
            RETURN
        END IF
        SELECT gem02 INTO re.ds08 FROM gem_file WHERE gem01=re.ds07
        SELECT gen02 INTO re.ds06 FROM gen_file WHERE gen01=re.ds05
        SELECT pjg02 INTO re.ds14 FROM pjg_file WHERE pjg01=re.ds13
        SELECT UNIQUE aag02 INTO re.ds16 FROM aag_file WHERE aag01=re.ds15
 
        INSERT INTO apj_temp VALUES (re.*)     
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","apj_temp",re.ds02,re.ds01,SQLCA.sqlcode,"","INSERT-F4",1) 
            RETURN
        END IF
        
   END FOREACH
 
   CALL r140()
 
END FUNCTION
 
FUNCTION r140()
   DEFINE
          l_name     LIKE type_file.chr20,       
         # l_sql      LIKE type_file.chr1000,	
          l_sql        STRING,       #NO.FUN-910082
          l_za05     LIKE type_file.chr1000,    
          sr         RECORD
                     ds01 LIKE type_file.chr1,
                     ds02 LIKE pja_file.pja01,
                     ds03 LIKE pja_file.pja02,
                     ds04 LIKE pja_file.pja05,
                     ds05 LIKE pja_file.pja08,
                     ds06 LIKE gen_file.gen02,
                     ds07 LIKE pja_file.pja09,
                     ds08 LIKE gem_file.gem02,
                     ds09 LIKE pja_file.pja14,
                     ds10 LIKE pja_file.pja15,
                     ds11 LIKE pjb_file.pjb02,
                     ds12 LIKE pjb_file.pjb03,
                     ds13 LIKE type_file.chr50,
                     ds14 LIKE type_file.chr1000,
                     ds15 LIKE pjd_file.pjd03,
                     ds16 LIKE aag_file.aag02,
                     ds17 LIKE type_file.num10,
                     ds18 LIKE type_file.chr4,
                     ds19 LIKE type_file.num20_6,
                     ds20 LIKE type_file.num20_6,
                     ds21 LIKE type_file.num20_6
                     END RECORD
 
     CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apjr140'
 
     LET l_sql = " SELECT * FROM apj_temp"
 
 
     PREPARE r140_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r140_c1 CURSOR FOR r140_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     CALL cl_outnam('apjr140') RETURNING l_name
 
 
     LET g_pageno = 0
     FOREACH r140_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
         SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file         #FUN-870151 Add azi07
            WHERE azi01=sr.ds12
         IF SQLCA.sqlcode THEN
            LET t_azi04=3
         END IF
 
         EXECUTE insert_prep USING 
           sr.ds01,sr.ds02,sr.ds03,sr.ds04,sr.ds05,sr.ds06,sr.ds07,sr.ds08,
           sr.ds09,sr.ds10,sr.ds11,sr.ds12,sr.ds13,sr.ds14,sr.ds15,sr.ds16,
           sr.ds17,sr.ds18,sr.ds19,sr.ds20,sr.ds21,
           g_azi04,g_azi05,t_azi04,t_azi07                             #FUN-870151 Add azi07 
 
     END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
     LET l_sql = l_sql CLIPPED," ORDER BY ds02,ds11" 
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pja01,pjb02,pja05,pja09,pja08')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str ,";",tm.f,";",tm.g
     CALL cl_prt_cs3('apjr140','apjr140',l_sql,g_str)  
 
END FUNCTION
#Modify....: No.FUN-830101
