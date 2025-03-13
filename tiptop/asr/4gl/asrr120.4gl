# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asrr120.4gl (copy for asrr250.4gl)
# Descriptions...: 期末用料差異表
# Input parameter:
# Return code....:
# Date & Author..: 06/03/23 By kim
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.FUN-7C0034 07/12/13 By destiny 報表改由CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		               # Print condition RECORD
        wc      STRING,                        # Where Condition   
        date    LIKE type_file.dat,            #No.FUN-680130 DATE
      	more	LIKE type_file.chr1   	       # Input more condition(Y/N)   #No.FUN-680130 VARCHAR(1)
           END RECORD,
        g_argv1       LIKE srn_file.srn02
DEFINE  g_cnt         LIKE type_file.num10     #No.FUN-680130 INTEGER
DEFINE  g_i           LIKE type_file.num5      #count/index for any purpose  #No.FUN-680130 SMALLINT
DEFINE   g_str           STRING                  #No.FUN-7C0034                                                                     
DEFINE   l_table         STRING                  #No.FUN-7C0034                                                                     
DEFINE   g_sql           STRING                  #No.FUN-7C0034
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
#No.FUN-7C0034---begin                                                                                                           
   LET g_sql ="srn02.srn_file.srn02,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,", 
              "gfe03.gfe_file.gfe03,",
              "qty0.srn_file.srn08,",
              "qty1.srn_file.srn08,",
              "qty2.srn_file.srn08,",
              "qty3.srn_file.srn08,",
              "qty4.srn_file.srn08,",
              "qty5.srn_file.srn08,",
              "qty6.srn_file.srn08"
   LET l_table = cl_prt_temptable('asrr120',g_sql)CLIPPED                                                                           
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
                                                                                                                                    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,                                                                 
               " values(?,?,?,?,?, ?,?,?,?,?,?) "                                                                        
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                                                                             
   END IF             
#No.FUN-7C0034---end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_argv1  = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add-- 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      IF cl_null(g_argv1) THEN
         CALL r120_tm()
      ELSE
         LET tm.wc=" srn02 = '",g_argv1,"'"
         CALL cl_wait()
         CALL r120_out()
      END IF
   ELSE                                  	# Read data and create out-file
       CALL r120_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r120_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(400)
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680130 SMALLINT 
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW r120_w AT p_row,p_col
        WITH FORM "asr/42f/asrr120"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'   
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON srn02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(srn02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima17"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO srn02
                   NEXT FIELD srf03
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   LET tm.date=g_today
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.date,tm.more WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
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
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
         
      ON ACTION CONTROLP
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
             WHERE zz01='asrr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asrr120','9031',1)   
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
         CALL cl_cmdat('asrr120',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r120_out()
   ERROR ""
 END WHILE
 CLOSE WINDOW r120_w
END FUNCTION
 
FUNCTION r120_out()
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6B0014
      DEFINE   l_name   LIKE type_file.chr20,         #No.FUN-680130 VARCHAR(20) 
          l_sql    STRING, 
          l_bdate  LIKE type_file.dat,           #No.FUN-680130 DATE
          l_edate  LIKE type_file.dat,           #No.FUN-680130 DATE
          l_qty1,l_qty2,l_qty3  LIKE srn_file.srn08,
          l_bmb RECORD
                  bmb01 LIKE bmb_file.bmb01,
                  bmb03 LIKE bmb_file.bmb03,
                  bmb06 LIKE bmb_file.bmb06,
                  bmb07 LIKE bmb_file.bmb07
                END RECORD,
          sr  RECORD
                 srn02	LIKE srn_file.srn02,
                 ima02  LIKE ima_file.ima02,
                 ima021 LIKE ima_file.ima021,
                 ima25	LIKE ima_file.ima25,
                 gfe03  LIKE gfe_file.gfe03,
                 qty0   LIKE srn_file.srn08,
                 qty1   LIKE srn_file.srn08,
                 qty2   LIKE srn_file.srn08,
                 qty3   LIKE srn_file.srn08,
                 qty4   LIKE srn_file.srn08,
                 qty5   LIKE srn_file.srn08,
                 qty6   LIKE srn_file.srn08
              END RECORD
  
     # No.FUN-B80063----start mark----------------------------------------------------------------
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     # No.FUN-B80063----end mark-----------------------------------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                      #No.FUN-7C0034
     CALL cl_del_data(l_table)                                                     #No.FUN-7C0034
     LET l_sql = " SELECT DISTINCT srn02,ima02,ima021,ima25,0,0,0,0,0,0,0,0 ",
                 " FROM srn_file,ima_file",
                 " WHERE ima01=srn02 AND ",tm.wc CLIPPED
    #IF NOT cl_null(tm.date) THEN
    #   LET l_sql=l_sql," AND srn01= CAST('",tm.date,"' AS DATETIME)"
    #END IF
     PREPARE r120_pr1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM END IF
     DECLARE r120_cs1 CURSOR FOR r120_pr1
 
#    CALL cl_outnam('asrr120') RETURNING l_name                                    #No.FUN-7C0034 
 
     LET l_bdate=MDY(MONTH(tm.date),'1',YEAR(tm.date))
     LET l_edate=r120_GETLASTDAY(tm.date)
#No.FUN-7C0034-begin--     
#    LET g_pageno = 0                                                              
#    START REPORT r120_rep TO l_name                                               
 
     FOREACH r120_cs1 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('for srn:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
          EXIT PROGRAM END IF
 
       SELECT gfe03 INTO sr.gfe03 FROM gfe_file WHERE gfe01=sr.ima25
       IF SQLCA.sqlcode OR cl_null(sr.gfe03) THEN
          LET sr.gfe03=0
       END IF
       SELECT SUM(srn17*img21) INTO sr.qty0 FROM srn_file,img_file
                                   WHERE srn02=sr.srn02
                                     AND srn02=img01
                                     AND srn03=img02
                                     AND srn04=img03
                                     AND srn05=img04
       IF SQLCA.sqlcode OR cl_null(sr.qty0) THEN
          LET sr.qty0=0
       END IF
       
       LET sr.qty1=0
       LET sr.qty2=0
       LET sr.qty3=0
       DECLARE r120_bmb_cur CURSOR FOR 
                               SELECT bmb01,bmb03,bmb06,bmb07
                                  FROM bmb_file,ima_file
                                  WHERE bmb03=sr.srn02
                                    AND bmb01=ima01
                                    AND bmb29=ima910
                                    AND (bmb04 <=tm.date OR bmb04 IS NULL )
                                    AND (bmb05 > tm.date OR bmb05 IS NULL )                                    
       FOREACH r120_bmb_cur INTO l_bmb.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
             RETURN
          END IF
          SELECT SUM(srg05*l_bmb.bmb06/l_bmb.bmb07),
                 SUM(srg06*l_bmb.bmb06/l_bmb.bmb07),
                 SUM(srg07*l_bmb.bmb06/l_bmb.bmb07)
           INTO l_qty1, l_qty2, l_qty3
                                  FROM srg_file,srf_file
                                 WHERE srg01=srf01
                                   AND srfconf='Y'
                                   AND srg03=l_bmb.bmb01
                                   AND srf02>=l_bdate
                                   AND srf02<=l_edate
                                   GROUP BY srg03
          IF SQLCA.sqlcode OR cl_null(l_qty1) THEN
             LET l_qty1=0
          END IF
          IF SQLCA.sqlcode OR cl_null(l_qty2) THEN
             LET l_qty2=0
          END IF
          IF SQLCA.sqlcode OR cl_null(l_qty3) THEN
             LET l_qty3=0
          END IF
          LET sr.qty1=sr.qty1+l_qty1
          LET sr.qty2=sr.qty2+l_qty2
          LET sr.qty3=sr.qty3+l_qty3
       END FOREACH
 
       LET sr.qty4=sr.qty1+sr.qty2+sr.qty3
       LET sr.qty5=sr.qty0-sr.qty4
       LET sr.qty6=sr.qty5/sr.qty4*100
#      OUTPUT TO REPORT r120_rep(sr.*)                                
       EXECUTE insert_prep USING sr.srn02,sr.ima02,sr.ima021,sr.gfe03,sr.qty0,sr.qty1,sr.qty2,
                                 sr.qty3,sr.qty4,sr.qty5,sr.qty6
 
     END FOREACH
#    FINISH REPORT r120_rep                                           
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'srn02')                                                                                                
          RETURNING tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str =tm.wc,";",tm.date
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                             
     CALL cl_prt_cs3('asrr120','asrr120',l_sql,g_str)  
#No.FUN-7C0034---end--
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-7C0034--begin--
#REPORT r120_rep(sr)
#   DEFINE l_str      STRING, 
#          l_last_sw  LIKE type_file.chr1,      #No.FUN-680130 VARCHAR(1)
#          sr  RECORD
#                 srn02	LIKE srn_file.srn02,
#                 ima02  LIKE ima_file.ima02,
#                 ima021 LIKE ima_file.ima021,
#                 ima25	LIKE ima_file.ima25,
#                 gfe03  LIKE gfe_file.gfe03,
#                 qty0   LIKE srn_file.srn08,
#                 qty1   LIKE srn_file.srn08,
#                 qty2   LIKE srn_file.srn08,
#                 qty3   LIKE srn_file.srn08,
#                 qty4   LIKE srn_file.srn08,
#                 qty5   LIKE srn_file.srn08,
#                 qty6   LIKE srn_file.srn08
#              END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.srn02
#
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<'
#        PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#        LET l_str=g_x[10] CLIPPED ,' ',tm.date
#        PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str;
#        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#        PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#        PRINT g_dash
#        PRINTX name=H1 g_x[31],g_x[34],g_x[35],g_x[36],g_x[37],
#                       g_x[38],g_x[39],g_x[40]
#        PRINTX name=H2 g_x[32]
#        PRINTX name=H3 g_x[33]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#
#     ON EVERY ROW
#        PRINTX name=D1 COLUMN g_c[31],sr.srn02,
#                       COLUMN g_c[34],cl_numfor(sr.qty0,34,sr.gfe03),
#                       COLUMN g_c[35],cl_numfor(sr.qty1,35,sr.gfe03),
#                       COLUMN g_c[36],cl_numfor(sr.qty2,36,sr.gfe03),
#                       COLUMN g_c[37],cl_numfor(sr.qty3,37,sr.gfe03),
#                       COLUMN g_c[38],cl_numfor(sr.qty4,38,sr.gfe03),
#                       COLUMN g_c[39],cl_numfor(sr.qty5,39,sr.gfe03),
#                       COLUMN g_c[40],cl_numfor(sr.qty6,40,sr.gfe03)
#        PRINTX name=D2 COLUMN g_c[32],sr.ima02
#        PRINTX name=D3 COLUMN g_c[33],sr.ima021
#     ON LAST ROW
#        LET l_last_sw = 'y'
#
#     PAGE TRAILER
#        PRINT g_dash
#        IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE 
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        END IF
#END REPORT
#No.FUN-7C0034--end--
 
FUNCTION r120_GETLASTDAY(p_date)
DEFINE p_date  LIKE type_file.dat            #No.FUN-680130 DATE
  IF p_date IS NULL OR p_date=0 THEN
     RETURN 0
  END IF
  IF MONTH(p_date)=12 THEN
     RETURN MDY(1,1,YEAR(p_date)+1)-1
  ELSE
     RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
  END IF
END FUNCTION
