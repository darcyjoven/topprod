# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abmr605.4gl
# Descriptions...: 檢查BOM表中"計算方式"為款式的元件是否已經錄入屬性對應關系
# Input parameter:
# Return code....:
# Date & Author..: 08/06/21 BY chenyu
# Modify ........: 08/10/10 FUN-870124 By arman 報表格式調整
# Modify ........: 08/11/03 FUN-8A0151 By arman 報表排序 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm  RECORD
	        wc  	STRING,
   	        a    	LIKE type_file.chr1,
               	b    	LIKE type_file.chr1,
           	more	LIKE type_file.chr1
           END RECORD
DEFINE  g_rpt_name  LIKE type_file.chr20
 
DEFINE  g_i        LIKE type_file.num5     #count/index for any purpose
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  g_str      STRING
DEFINE  g_bma01    LIKE bma_file.bma01    #No.FUN-870124
DEFINE  g_bma06    LIKE bma_file.bma06    #No.FUN-870124
DEFINE  g_flag     LIKE type_file.num5    #No.FUN-8A0151
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE tm.* TO NULL            # Default condition
   
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("slk") THEN
      CALL cl_err('','aec-113',1)
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark
 
   LET g_sql ="bma01.bma_file.bma01,",
              "bma06.bma_file.bma06,",    #No.FUN-870124
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "bmb02.bmb_file.bmb02,",
              "bmb03.bmb_file.bmb03,",
              "bmb05.bmb_file.bmb05,",   #No.FUN-870124
              "ima02_1.ima_file.ima02,",
              "ima021_1.ima_file.ima021,",
              "bmb30.bmb_file.bmb30,",
              "agb03_1.agb_file.agb03,",
              "y1.type_file.chr1,",
              "agb03_2.agb_file.agb03,",
              "y2.type_file.chr1,",
              "agb03_3.agb_file.agb03,",
              "y3.type_file.chr1,",
              "acti.type_file.chr1,",   #No.FUN-870124
              "p_level.type_file.num5,",     #No.FUN-870124
              "g_bma01.bma_file.bma01,",     #No.FUN-870124
              "g_bma06.bma_file.bma06,",     #No.FUN-870124
              "g_flag.type_file.num5 "       #No.FUN-8A0151
   LET l_table = cl_prt_temptable('abmr605',g_sql) CLIPPED
   IF l_table = -1 THEN 
      EXIT PROGRAM 
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN 
      CALL r605_tm()	             	# Input print condition
   ELSE
      CALL abmr605()	          	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r605_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
DEFINE l_cmd	     LIKE type_file.chr1000,
       p_row,p_col   LIKE type_file.num5
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r605_w AT p_row, p_col
        WITH FORM "abm/42f/abmr605"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bma01,bma06
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
 
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(bma01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma103"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bma01
                  NEXT FIELD bma01
          END CASE
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r605_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#  IF tm.wc = " 1=1" THEN
#     CALL cl_err('','9046',0)
#     CONTINUE WHILE
#  END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr605'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr605','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'" 
         CALL cl_cmdat('abmr605',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r605_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr605()
   ERROR ""
END WHILE
   CLOSE WINDOW r605_w
END FUNCTION
 
FUNCTION abmr605()
   DEFINE l_name	LIKE type_file.chr20,
#          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT
          l_sql       STRING ,     #NO.FUN-910082
          l_za05	LIKE type_file.chr1000,
          l_bms03   LIKE bms_file.bms03,
          l_bms02   LIKE bms_file.bms02,
 	  l_sta     LIKE type_file.chr1000,
          p_type    LIKE type_file.num5,
          l_k       LIKE type_file.num10,
          l_cnt     LIKE type_file.num5,
          l_m       LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_i       LIKE type_file.num5,
          l_agb03   ARRAY[4] OF LIKE agb_file.agb03,
          l_y       ARRAY[4] OF LIKE type_file.chr1,
          sr        RECORD
                      bma01    LIKE bma_file.bma01,
                      bma06    LIKE bma_file.bma06,  #No.FUN-870124
                      ima02    LIKE ima_file.ima02,
                      ima021   LIKE ima_file.ima021,
                      bmb02    LIKE bmb_file.bmb02,
                      bmb03    LIKE bmb_file.bmb03,
                      bmb05    LIKE bmb_file.bmb05,   #No.FUN-870124
                      ima02_1  LIKE ima_file.ima02,
                      ima021_1 LIKE ima_file.ima021,
                      bmb30    LIKE bmb_file.bmb30,
                      agb03_1  LIKE agb_file.agb03,
                      y1       LIKE type_file.chr1,
                      agb03_2  LIKE agb_file.agb03,
                      y2       LIKE type_file.chr1,
                      agb03_3  LIKE agb_file.agb03,
                      y3       LIKE type_file.chr1,
                      acti     LIKE type_file.chr1   #No.FUN-870124
                    END RECORD
#    DEFINE l_bma06  LIKE bma_file.bma06     #No.FUN-870124
 
     LET g_pdate = g_today
 
     IF cl_null(g_rlang) THEN
        LET g_rlang = g_lang
     END IF
 
     LET g_copies = '1'
     LET g_flag = 1      #No.FUN-8A0151
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr605'
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"  #No.FUN-870124  #No.FUN-8A0151
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmruser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bmrgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmrgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmruser', 'bmrgrup')
     #End:FUN-980030
 
#    LET l_sql = "SELECT bma01,bma06,'','',bmb02,bmb03,bmb05,'','',bmb30,'','','','','','',''",#No.FUN-870124 add'',bma06
     LET l_sql = "SELECT UNIQUE bma01,bma06 ",#No.FUN-870124 
                 "  FROM bma_file,bmb_file,ima_file",
                 " WHERE ",tm.wc,
		 "   AND bma01 = bmb01 ",
                 "   AND bma06 = bmb29 ",   #No.FUN-870124
                 "   AND ima01 = bma01",
                 "   AND bmb05 IS NULL ",   #No.FUN-870124
                 "   AND ima151 = 'Y'" 
#        	 " ORDER BY bmb02"          #No.FUN-870124  
     PREPARE r605_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r605_cs1 CURSOR FOR r605_prepare1
 
     FOREACH r605_cs1 INTO sr.*    #No.FUN-870124
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-870124  ---begin
#      IF NOT cl_null(sr.bmb05) AND 
#         sr.bmb05 <= g_today THEN
#         LET sr.acti = 'N'
#      ELSE
#         LET sr.acti = 'Y'
#      END IF
#      SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
#       WHERE ima01 = sr.bma01
#      SELECT ima02,ima021 INTO sr.ima02_1,sr.ima021_1 FROM ima_file
#       WHERE ima01 = sr.bmb03
 
#      IF sr.bmb30 = '4' THEN
#         LET l_sql = "SELECT agb03 FROM agb_file,ima_file",
#                     " WHERE agb01 = imaag",
#                     "   AND ima01 = '",sr.bmb03,"'"
#         PREPARE r605_pre FROM l_sql
#         DECLARE r605_cur CURSOR FOR r605_pre
#           LET l_i = 1
#         FOREACH r605_cur INTO l_agb03[l_i]
#            IF SQLCA.sqlcode != 0 THEN 
#               CALL cl_err('foreach:',SQLCA.sqlcode,1)
#               EXIT FOREACH
#            END IF
 
#            SELECT COUNT(*) INTO l_m FROM boc_file
#             WHERE boc01 = sr.bma01
#               AND boc02 = sr.bmb03
#               AND boc04 = l_agb03[l_i]
#            SELECT COUNT(*) INTO l_n FROM bmv_file
#             WHERE bmv01 = sr.bma01
#               AND bmv02 = sr.bmb03
#               AND bmv03 = sr.bma06       #No.FUN-870124
#               AND bmv04 = l_agb03[l_i]  #No.FUN-870124
#            IF l_n = 0 AND l_m = 0 THEN
#               LET l_y[l_i] = 'N'
#            ELSE
#               LET l_y[l_i] = 'Y'
#            END IF
#            LET l_i = l_i + 1 
#         END FOREACH 
#         LET sr.agb03_1 = l_agb03[1]
#         LET sr.y1 = l_y[1]
#         LET l_agb03[1] = " "   #No.FUN-870124
#         LET l_y[1] = " "       #No.FUN-870124
#         LET sr.agb03_2 = l_agb03[2]
#         LET sr.y2 = l_y[2]
#         LET l_agb03[2] = " "   #No.FUN-870124
#         LET l_y[2] = " "       #No.FUN-870124
#         LET sr.agb03_3 = l_agb03[3]
#         LET sr.y3 = l_y[3]
#         LET l_agb03[3] = " "   #No.FUN-870124
#         LET l_y[3] = " "       #No.FUN-870124
#      END IF
       LET g_bma01 = sr.bma01
       LET g_bma06 = sr.bma06
#No.FUN-870124  ----end
       CALL r605_bom(0,sr.bma01,sr.bma06)       #No.FUN-870124
#      EXECUTE insert_prep USING sr.*           #No.FUN-870124
#      OUTPUT TO REPORT r605_rep(sr.*)
     END FOREACH
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bma01,bma06')
          RETURNING tm.wc
     LET g_str = tm.wc CLIPPED,";",g_prog CLIPPED
     LET l_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('abmr605','abmr605',l_sql,g_str) 
 
#    FINISH REPORT r605_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.FUN-870124 ----begin
FUNCTION r605_bom(p_level,p_key1,p_key2)
DEFINE    p_level   LIKE type_file.num5,
          p_key1    LIKE bma_file.bma01,
          p_key2    LIKE bma_file.bma06,
         # l_sql     LIKE type_file.chr1000,
         # l_sql1    LIKE type_file.chr1000,
          l_sql,l_sql1       STRING,      #NO.FUN-910082
          l_n       LIKE type_file.num5,
          l_i       LIKE type_file.num5,
          l_m       LIKE type_file.num5,
          i         LIKE type_file.num5,
          l_count   LIKE type_file.num5,
          l_agb03   ARRAY[4] OF LIKE agb_file.agb03,
          l_y       ARRAY[4] OF LIKE type_file.chr1
DEFINE
          sr        DYNAMIC ARRAY OF RECORD
                      bma01    LIKE bma_file.bma01,
                      bma06    LIKE bma_file.bma06,  #No.FUN-870124
                      ima02    LIKE ima_file.ima02,
                      ima021   LIKE ima_file.ima021,
                      bmb02    LIKE bmb_file.bmb02,
                      bmb03    LIKE bmb_file.bmb03,
                      bmb05    LIKE bmb_file.bmb05,   #No.FUN-870124
                      ima02_1  LIKE ima_file.ima02,
                      ima021_1 LIKE ima_file.ima021,
                      bmb30    LIKE bmb_file.bmb30,
                      agb03_1  LIKE agb_file.agb03,
                      y1       LIKE type_file.chr1,
                      agb03_2  LIKE agb_file.agb03,
                      y2       LIKE type_file.chr1,
                      agb03_3  LIKE agb_file.agb03,
                      y3       LIKE type_file.chr1,
                      acti     LIKE type_file.chr1   #No.FUN-870124
                    END RECORD
 
     LET l_sql = "SELECT bma01,bma06,'','',bmb02,bmb03,bmb05,'','',bmb30,'','','','','','',''",#No.FUN-870124 add'',bma06
                 "  FROM bma_file,bmb_file,ima_file",
                 " WHERE bma01 = '",p_key1,"' ",
                 "   AND bma06 = '",p_key2,"' ",
		 "   AND bma01 = bmb01 ",
                 "   AND bma06 = bmb29 ",   #No.FUN-870124
                 "   AND ima01 = bma01 ",
                 "   AND bmb05 IS NULL ",   #No.FUN-870124
                 "   AND ima151 = 'Y'",
		 " ORDER BY bmb02"
     PREPARE r605_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r605_cs2 CURSOR FOR r605_prepare2
 
     LET p_level = p_level + 1
     IF p_level >20 THEN RETURN END IF
     LET l_count = 1
     FOREACH r605_cs2 INTO sr[l_count].*    #No.FUN-870124
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF NOT cl_null(sr[l_count].bmb05) AND 
          sr[l_count].bmb05 <= g_today THEN
          LET sr[l_count].acti = 'N'
       ELSE
          LET sr[l_count].acti = 'Y'
       END IF
       SELECT ima02,ima021 INTO sr[l_count].ima02,sr[l_count].ima021 FROM ima_file
        WHERE ima01 = sr[l_count].bma01
       SELECT ima02,ima021 INTO sr[l_count].ima02_1,sr[l_count].ima021_1 FROM ima_file
        WHERE ima01 = sr[l_count].bmb03
 
       IF sr[l_count].bmb30 = '4' THEN
          LET l_sql1 = "SELECT agb03 FROM agb_file,ima_file",
                      " WHERE agb01 = imaag",
                      "   AND ima01 = '",sr[l_count].bmb03,"'"
          PREPARE r605_pre FROM l_sql1
          DECLARE r605_cur CURSOR FOR r605_pre
            LET l_i = 1
          FOREACH r605_cur INTO l_agb03[l_i]
             IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
 
             SELECT COUNT(*) INTO l_m FROM boc_file
              WHERE boc01 = sr[l_count].bma01
                AND boc02 = sr[l_count].bmb03
                AND boc04 = l_agb03[l_i]
             SELECT COUNT(*) INTO l_n FROM bmv_file
              WHERE bmv01 = sr[l_count].bma01
                AND bmv02 = sr[l_count].bmb03
                AND bmv03 = sr[l_count].bma06       #No.FUN-870124
                AND bmv04 = l_agb03[l_i]  #No.FUN-870124
             IF l_n = 0 AND l_m = 0 THEN
                LET l_y[l_i] = 'N'
             ELSE
                LET l_y[l_i] = 'Y'
             END IF
             LET l_i = l_i + 1 
          END FOREACH 
          LET sr[l_count].agb03_1 = l_agb03[1]
          LET sr[l_count].y1 = l_y[1]
          LET l_agb03[1] = " "   #No.FUN-870124
          LET l_y[1] = " "       #No.FUN-870124
          LET sr[l_count].agb03_2 = l_agb03[2]
          LET sr[l_count].y2 = l_y[2]
          LET l_agb03[2] = " "   #No.FUN-870124
          LET l_y[2] = " "       #No.FUN-870124
          LET sr[l_count].agb03_3 = l_agb03[3]
          LET sr[l_count].y3 = l_y[3]
          LET l_agb03[3] = " "   #No.FUN-870124
          LET l_y[3] = " "       #No.FUN-870124
       END IF
       LET l_count = l_count + 1
     END FOREACH
     LET l_count = l_count - 1
     FOR i=1 TO l_count
     LET g_flag = g_flag +1   #NO.FUN-8A0151
     EXECUTE insert_prep USING sr[i].*,p_level,g_bma01,g_bma06,g_flag
     SELECT COUNT(*) INTO  l_n FROM bma_file WHERE bma01 = sr[i].bmb03
                                               AND bma06 = sr[i].bma06
      IF l_n >0 THEN
         CALL r605_bom(p_level,sr[i].bmb03,sr[i].bma06)
      END IF
     END FOR
#    OUTPUT TO REPORT r605_rep(sr.*)
END FUNCTION
#No.FUN-870124 ----end
