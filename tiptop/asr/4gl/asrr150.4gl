# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asrr150.4gl (copy for asrr120.4gl)
# Descriptions...: 銷售預測計劃明細表
# Input parameter:
# Return code....:
# Date & Author..: 06/03/27 By kim
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0142 06/12/28 By ray 表頭調整
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.FUN-7B0103 07/11/21 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.TQC-940102 09/05/08 By mike 單位小數位數應該是gfe03       
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		               # Print condition RECORD
        wc      STRING,                        # Where Condition  
        bdate   LIKE type_file.dat,            #No.FUN-680130 DATE
        edate   LIKE type_file.dat,            #No.FUN-680130 DATE
        opc06   LIKE opc_file.opc06,
        opc10   LIKE opc_file.opc10,
      	more	LIKE type_file.chr1   	      # Input more condition(Y/N)     #No.FUN-680130 VARCHAR(1)
           END RECORD
DEFINE   g_cnt  LIKE type_file.num10         #No.FUN-680130 INTEGER
DEFINE   g_i    LIKE type_file.num5          #count/index for any purpose     #No.FUN-680130 SMALLINT
#No.FUN-7B0103---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_sql           STRING                                                 
DEFINE   g_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-7B0103---End  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-7B0103---Begin                                                       
   LET g_sql ="opc04.opc_file.opc04,",                                          
              "gen02.gen_file.gen02,",                                          
              "opc05.opc_file.opc05,",                                          
              "gem02.gem_file.gem02,",                                          
              "opc02.opc_file.opc02,",                                          
              "occ02.occ_file.occ02,",                                          
              "opd06.opd_file.opd06,",                                          
              "opc01.opc_file.opc01,",                                          
              "ima31.ima_file.ima31,",                                          
              "opd08.opd_file.opd08,",                                          
              "gfe03.gfe_file.gfe03,",                                          
              "ima02.ima_file.ima02,",                                          
              "ima021.ima_file.ima021 "                                         
   LET l_table = cl_prt_temptable('asrr150',g_sql)CLIPPED                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
                                                                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,             
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                          
   PREPARE insert_prep FROM g_sql                                               
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                         
   END IF                
   #No.FUN-7B0103---End
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      CALL r150_tm()
   ELSE
      CALL r150_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r150_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd	      LIKE type_file.chr1000#No.FUN-680130 VARCHAR(400)
   DEFINE p_row,p_col LIKE type_file.num5   #No.FUN-680130 SMALLINT
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW r150_w AT p_row,p_col
        WITH FORM "asr/42f/asrr150"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'   
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON opc01,opc02,opc04,opc05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(opc01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima17"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO opc01
                   NEXT FIELD opc01
                 WHEN INFIELD(opc02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO opc02
                   NEXT FIELD opc02
                 WHEN INFIELD(opc04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO opc04
                   NEXT FIELD opc04
                 WHEN INFIELD(opc05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO opc05
                   NEXT FIELD opc05
              END CASE
           ON ACTION locale
               LET g_action_choice = "locale"
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT CONSTRUCT
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
              
           ON ACTION CONTROLG 
              CALL cl_cmdask()
            
           ON ACTION help           #No.TQC-770003                                                                                                     
              CALL cl_show_help()   #No.TQC-770003 
 
           ON ACTION exit
              LET INT_FLAG = 1
              EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('opcuser', 'opcgrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   LET tm.bdate=MDY(MONTH(g_today),1,YEAR(g_today))
   LET tm.edate=r150_GETLASTDAY(tm.bdate)
   LET tm.opc06='2'
   DISPLAY BY NAME tm.bdate,tm.edate,tm.opc06,tm.opc10,tm.more # Condition
   
   INPUT BY NAME tm.bdate,tm.edate,tm.opc06,tm.opc10,tm.more WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD opc06
         CALL cl_set_comp_required("opc10",tm.opc06='1')
 
      AFTER FIELD more
    	   IF tm.more NOT MATCHES '[YN]' THEN
    	      NEXT FIELD more
    	   END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(opc10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rpg"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO opc10
              NEXT FIELD opc10
         END CASE
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='asrr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asrr150','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asrr150',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r150_out()
   ERROR ""
 END WHILE
 CLOSE WINDOW r150_w
END FUNCTION
 
FUNCTION r150_out()
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6B0014
DEFINE    l_name   LIKE type_file.chr20,         #No.FUN-680130 VARCHAR(20)
          l_sql    STRING, 
          l_bdate  LIKE type_file.dat,           #No.FUN-680130 DATE
          l_edate  LIKE type_file.dat,           #NO.FUN-680130 DATE
          sr  RECORD
                 opc04	LIKE opc_file.opc04,
                 gen02	LIKE gen_file.gen02,
                 opc05	LIKE opc_file.opc05,
                 gem02	LIKE gem_file.gem02,
                 opc02	LIKE opc_file.opc02,
                 occ02	LIKE occ_file.occ02,
                 opd06	LIKE opd_file.opd06,
                 opc01	LIKE opc_file.opc01,
                 ima02  LIKE ima_file.ima02,
                 ima021 LIKE ima_file.ima021,
                 ima31	LIKE ima_file.ima31,
                 gfe03  LIKE gfe_file.gfe03,
                 opd08	LIKE opd_file.opd08
              END RECORD
#No.FUN-7B0103---Begin
DEFINE l_rpg01   LIKE rpg_file.rpg01
DEFINE l_rpg02   LIKE rpg_file.rpg02
#No.FUN-7B0103---End
  
     # No.FUN-B80063----start mark----------------------------------------------------------------
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     # No.FUN-B80063----end mark------------------------------------------------------------------

     CALL cl_del_data(l_table)    #No.FUN-7B0103
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7B0103
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT opc04,'',opc05,'',opc02,'',opd06,opc01,",
                 "'','','',0,SUM(opd08)",
                 " FROM opc_file,opd_file",
                 " WHERE opc01=opd01",
                 "   AND opc02=opd02",
                 "   AND opc03=opd03",
                 "   AND opc04=opd04",
                 "   AND ",tm.wc CLIPPED
     IF NOT cl_null(tm.bdate) THEN
        LET l_sql=l_sql," AND opd06>='",tm.bdate,"'"
     END IF
     IF NOT cl_null(tm.edate) THEN
        LET l_sql=l_sql," AND opd06<='",tm.edate,"'"
     END IF
     IF (NOT cl_null(tm.opc06)) AND (NOT cl_null(tm.opc10)) THEN
        LET l_sql=l_sql," AND ((opc06='",tm.opc06,"' AND opc06<>'1')",
                        "  OR  (opc06='1' AND opc10='",tm.opc10,"'))"
     END IF
     LET l_sql=l_sql," GROUP BY opc02,opc04,opc05,opd06,opc01",
                     " ORDER BY opc02,opc04,opc05,opd06,opc01"
     PREPARE r150_pr1 FROM l_sql

     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM 
     END IF

     DECLARE r150_cs1 CURSOR FOR r150_pr1
 
     #No.FUN-7B0103---Begin
     #CALL cl_outnam('asrr150') RETURNING l_name
 
     #LET g_pageno = 0
     #START REPORT r150_rep TO l_name
     #No.FUN-7B0103---End
 
     FOREACH r150_cs1 INTO sr.*
        IF STATUS THEN 
           CALL cl_err('for srn:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
           EXIT PROGRAM 
        END IF
        
        SELECT gem02 INTO sr.gem02 FROM gem_file #部門
            WHERE gem01=sr.opc05
        IF SQLCA.sqlcode THEN
            LET sr.gem02 = NULL
        END IF
        
        SELECT gen02 INTO sr.gen02 FROM gen_file #業務員
            WHERE gen01=sr.opc04
        IF SQLCA.sqlcode THEN
            LET sr.gen02 = NULL
        END IF
        
        SELECT occ02 INTO sr.occ02 FROM occ_file #客戶
            WHERE occ01=sr.opc02
        IF SQLCA.sqlcode THEN
            LET sr.occ02 = NULL
        END IF
        
        SELECT ima02,ima021,ima31 INTO sr.ima02,sr.ima021,sr.ima31 #料號
             FROM ima_file WHERE ima01=sr.opc01
        IF SQLCA.sqlcode THEN
            LET sr.ima02 = NULL
            LET sr.ima021 = NULL
            LET sr.ima31 =NULL
        END IF
        
       #SELECT gef03 INTO sr.gfe03 FROM gfe_file WHERE gfe01=sr.ima31 #單位小數位數 #TQC-940102 
        SELECT gfe03 INTO sr.gfe03 FROM gfe_file WHERE gfe01=sr.ima31 #單位小數位數 #TQC-940102  
        IF cl_null(sr.gfe03) THEN
           LET sr.gfe03=0
        END IF
 
        #No.FUN-7B0103---Begin 
        SELECT rpg01,rpg02 INTO l_rpg01,l_rpg02 FROM rpg_file
          WHERE rpg01 = tm.opc10
        #OUTPUT TO REPORT r150_rep(sr.*)
        EXECUTE insert_prep USING sr.opc04,sr.gen02,sr.opc05,sr.gem02,
                                  sr.opc02,sr.occ02,sr.opd06,sr.opc01,
                                  sr.ima31,sr.opd08,sr.gfe03,sr.ima02,
                                  sr.ima021
        #No.FUN-7B0103---End         
     END FOREACH
     #No.FUN-7B0103---Begin
     #FINISH REPORT r150_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'opc01,opc02,opc04,opc05')                                      
          RETURNING tm.wc                                                       
     END IF                                                                     
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",tm.opc06,";",
                 tm.opc10,";",l_rpg02  
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
     CALL cl_prt_cs3('asrr150','asrr150',l_sql,g_str)
     #No.FUN-7B0103---End 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7B0103---Begin
#REPORT r150_rep(sr)
#   DEFINE l_str     STRING, 
#          l_last_sw LIKE type_file.chr1,     #No.FUN-680130 VARCHAR(1)
#          sr  RECORD
#                 opc04	LIKE opc_file.opc04,
#                 gen02	LIKE gen_file.gen02,
#                 opc05	LIKE opc_file.opc05,
#                 gem02	LIKE gem_file.gem02,
#                 opc02	LIKE opc_file.opc02,
#                 occ02	LIKE occ_file.occ02,
#                 opd06	LIKE opd_file.opd06,
#                 opc01	LIKE opc_file.opc01,
#                 ima02  LIKE ima_file.ima02,
#                 ima021 LIKE ima_file.ima021,
#                 ima31	LIKE ima_file.ima31,
#                 gfe03  LIKE gfe_file.gfe03,
#                 opd08	LIKE opd_file.opd08
#              END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY sr.opc02,sr.opc04,sr.opc05,sr.opd06,sr.opc01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#No.TQC-6C0142 --begin
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<'
#        PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#        PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET l_str=g_x[10] CLIPPED ,' ',tm.bdate," ~ ",tm.edate
#        PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str 
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<'
#       PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#       LET l_str=g_x[10] CLIPPED ,' ',tm.bdate," ~ ",tm.edate
#       PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str;
#       PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#       PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#No.TQC-6C0142 --end
#        PRINT g_dash
#        PRINT g_x[21],sr.opc04,' ',sr.gen02
#        PRINT g_x[22],sr.opc05,' ',sr.gem02
#        PRINT g_x[23],sr.opc02,' ',sr.occ02
#        PRINT
#        PRINTX name=H1 g_x[31],g_x[32],g_x[35],g_x[36]
#        PRINTX name=H2 g_x[37],g_x[33]
#        PRINTX name=H3 g_x[38],g_x[34]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
     
#     BEFORE GROUP OF sr.opc02
#        SKIP TO TOP OF PAGE   
 
#     ON EVERY ROW
#        PRINTX name=D1 COLUMN g_c[31],sr.opd06,
#                       COLUMN g_c[32],sr.opc01,
#                       COLUMN g_c[35],sr.ima31,
#                       COLUMN g_c[36],cl_numfor(sr.opd08,36,sr.gfe03)
#        PRINTX name=D2 COLUMN g_c[33],sr.ima02
#        PRINTX name=D3 COLUMN g_c[34],sr.ima021
 
#     ON LAST ROW
#        LET l_last_sw = 'y'
 
#     PAGE TRAILER
#        PRINT g_dash
#        IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE 
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        END IF
#END REPORT
#No.FUN-7B0103---End
 
FUNCTION r150_GETLASTDAY(p_date)
DEFINE p_date LIKE type_file.dat                 #No.FUN-680130 DATE
  IF p_date IS NULL OR p_date=0 THEN
     RETURN 0
  END IF
  IF MONTH(p_date)=12 THEN
     RETURN MDY(1,1,YEAR(p_date)+1)-1
  ELSE
     RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
  END IF
END FUNCTION
