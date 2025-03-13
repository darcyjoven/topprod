# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr161.4gl
# Descriptions...: 集團銷售預測與目標比較表
# Date & Author..: 06/03/06 By Sarah
# Modify.........: No.FUN-620032 06/03/06 By Sarah 新增"集團銷售預測與目標比較表"
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0217 06/12/31 By Rayven 打印層級2層以上就會錯位 
# Modify.........: No.TQC-770104 07/07/23 By Rayven 打印總頁次有誤
# Modify.........: No.FUN-860012 08/06/04 By lala    CR
# Modify.........: No.TQC-940090 09/04/16 By mike tm.wc2的賦值不正確
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm    RECORD			        # Print condition RECORD
              wc	STRING,	                # Where condition
              wc2       STRING,	                # Where condition
              b 	LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)               # 金額單位
              c	        LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)               # 列印層級
              more	LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)               # IF more condition
 	     END RECORD,
       l_flag 	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       l_n	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_end	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_level_end      ARRAY[5] OF LIKE type_file.num5,     #No.FUN-680120 SMALLINT
       g_unit           LIKE type_file.num10,                #No.FUN-680120 INTEGER               #金額單位基數
       g_odb09          LIKE odb_file.odb09     #幣別
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_str      STRING      #No.FUN-860012 
DEFINE   g_sql      STRING      #No.FUN-860012 
DEFINE   l_table    STRING      #No.FUN-860012
DEFINE   l_str      STRING      #No.FUN-860012 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   LET g_pdate 	  = ARG_VAL(1)	# Get arguments from command line
   LET g_towhom	  = ARG_VAL(2)
   LET g_rlang 	  = ARG_VAL(3)
   LET g_bgjob 	  = ARG_VAL(4)
   LET g_prtway	  = ARG_VAL(5)
   LET g_copies	  = ARG_VAL(6)
   LET tm.wc 	  = ARG_VAL(7)
   LET tm.b       = ARG_VAL(8)
   LET tm.c       = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   
#No.FUN-860012---start---
   LET g_sql="odc02.odc_file.odc02,",
             "odc18.odc_file.odc18,",
             "odc19.odc_file.odc19,",
             "odc192.odc_file.odc192,",
             "odc21.odc_file.odc21,",
             "odc11.odc_file.odc11,",
             "diff.odc_file.odc11"
 
   LET l_table = cl_prt_temptable('atmr161',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-860012---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r161_tm(0,0)	        	# Input print condition
      ELSE CALL atmr161()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r161_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	 LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_flag	 LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_one		 LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_bdate	 LIKE type_file.dat,              #No.FUN-680120 DATE
          l_edate	 LIKE type_file.dat,              #No.FUN-680120 DATE
          l_bma01	 LIKE bma_file.bma01,
          l_cmd		 LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col =14 END IF			
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r161_w AT p_row,p_col
        WITH FORM "atm/42f/atmr161"
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		# Default condition
   LET tm.b    = '1'
   LET tm.c    = '5'
   LET tm.more = "N"	
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON odb01 FROM a
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            IF INFIELD(a) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_odb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.a
               NEXT FIELD a
            END IF
 
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r161_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      CALL r161_trans(tm.wc,'odb01','odc01') RETURNING tm.wc2
 
      INPUT BY NAME tm.b,tm.c,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD b
            IF tm.b NOT MATCHES '[1-3]' THEN
               CALL cl_err('','-1152',0)
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF tm.c NOT MATCHES '[1-5]' THEN
               CALL cl_err('','-1152',0)
               NEXT FIELD c
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
	    IF INT_FLAG THEN EXIT INPUT END IF
 
         AFTER INPUT
            IF tm.b = '1' THEN LET g_unit = 1       END IF
            IF tm.b = '2' THEN LET g_unit = 1000    END IF
            IF tm.b = '3' THEN LET g_unit = 1000000 END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG  
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r161_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='atmr161'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('atmr161','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('atmr161',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r161_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL atmr161()
      ERROR ""
   END WHILE
   CLOSE WINDOW r161_w
END FUNCTION
 
FUNCTION atmr161()
   DEFINE l_name	LIKE type_file.chr20,           #No.FUN-680120 VARCHAR(20)		# External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6B0014
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680120
          l_za05	LIKE za_file.za05,            #No.FUN-680120 VARCHAR(40)
	  p_level	LIKE type_file.num5            #No.FUN-680120 SMALLINT
DEFINE  l_str      STRING,
          sr            RECORD
			 odc01          LIKE odc_file.odc01,
			 odc02          LIKE odc_file.odc02,
			 tqb02          LIKE tqb_file.tqb02,
			 odc18          LIKE odc_file.odc18,
			 odc19          LIKE odc_file.odc19,
			 odc192         LIKE odc_file.odc192,
			 odc21          LIKE odc_file.odc21,
			 odc11          LIKE odc_file.odc11,
			 diff           LIKE odc_file.odc11
	                END RECORD,
          sr_null       RECORD
			 odc01          LIKE odc_file.odc01,
			 odc02          LIKE odc_file.odc02,
			 tqb02          LIKE tqb_file.tqb02,
			 odc18          LIKE odc_file.odc18,
			 odc19          LIKE odc_file.odc19,
			 odc192         LIKE odc_file.odc192,
			 odc21          LIKE odc_file.odc21,
			 odc11          LIKE odc_file.odc11,
			 diff           LIKE odc_file.odc11
	                END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'atmr161'
   IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 75 END IF
   FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND odcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND odcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND odcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('odcuser', 'odcgrup')
   #End:FUN-980030
 
   #抓最上層組織
   LET l_sql = "SELECT odb01,odb07,tqb02,SUM(ode11),SUM(ode12),SUM(ode13),",
              #"       SUM(ode14),odc11,odc11-SUM(ode14) ",
               "       SUM(ode14),odc11,SUM(ode14)-odc11 ",
               "  FROM odb_file,tqb_file,odc_file,ode_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND odb07 = tqb01 ",
               "   AND odb07 = odc02 ",
               "   AND odb01 = ode01 AND odb07 = ode02 ",
               " GROUP BY odb01,odb07,tqb02,odc11 ",
               " ORDER BY odb07"
   PREPARE r161_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   DECLARE r161_curs1 CURSOR FOR r161_prepare1
 
   INITIALIZE sr_null.* TO NULL
#No.FUN-860012---start---
#   CALL cl_outnam('atmr161') RETURNING l_name
#   START REPORT r161_rep TO l_name
  #LET g_pageno = 1  #No.TQC-770104 mark
   LET p_level = 0
   FOREACH r161_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      ##換算金額單位
      LET sr.odc18 = sr.odc18 / g_unit
      LET sr.odc19 = sr.odc19 / g_unit
      LET sr.odc192= sr.odc192 / g_unit
      LET sr.odc21 = sr.odc21 / g_unit
      LET sr.odc11 = sr.odc11 / g_unit
      LET sr.diff  = sr.diff / g_unit
 
      SELECT odb09 INTO g_odb09 FROM odb_file WHERE odb01=sr.odc01
      IF STATUS THEN LET g_odb09 = ' ' END IF
     #LET g_pageno = 0   #No.TQC-770104 mark
#      OUTPUT TO REPORT r161_rep(p_level,sr.*)
     #OUTPUT TO REPORT r161_rep(p_level+1,sr_null.*)
 
#      LET g_end = 0
#      CALL r161_level(0,sr.odc01,sr.odc02)
#      LET g_end = 1	
   EXECUTE insert_prep USING
        sr.odc02,sr.odc18,sr.odc19,sr.odc192,sr.odc21,sr.odc11,sr.diff
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'odb01')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.b,";",tm.c
     CALL cl_prt_cs3('atmr161','atmr161',g_sql,g_str)	
#   FINISH REPORT r161_rep
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
#No.FUN-860012---end---
#FUNCTION r161_level(p_level,p_odc01,p_tqd01)
#  DEFINE  p_level     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#          p_odc01     LIKE odc_file.odc01,
#          p_tqd01     LIKE tqd_file.tqd01,
#          l_sql       STRING,
#          l_count     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#          i           LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#          sr          DYNAMIC ARRAY OF RECORD
#       		odc01        LIKE odc_file.odc01,
#       		odc02        LIKE odc_file.odc02,
#       		tqb02        LIKE tqb_file.tqb02,
#       		odc18        LIKE odc_file.odc18,
#       		odc19        LIKE odc_file.odc19,
#       		odc192       LIKE odc_file.odc192,
#       		odc21        LIKE odc_file.odc21,
#       		odc11        LIKE odc_file.odc11,
#       		diff         LIKE odc_file.odc11
#                      END RECORD
 
#  INITIALIZE sr[600].* TO NULL
 
#  LET l_sql = "SELECT odc01,tqd03,tqb02,SUM(ode11),SUM(ode12),SUM(ode13),",
#             #"       SUM(ode14),odc11,odc11-SUM(ode14) ",
#              "       SUM(ode14),odc11,SUM(ode14)-odc11 ",
#              "  FROM tqd_file,tqb_file,odc_file,ode_file ",
#              " WHERE odc01 = '",p_odc01,"' ",
#              "   AND tqd01 = '",p_tqd01,"' ",
#              "   AND tqd03 = tqb01 ",
#              "   AND tqd03 = odc02 ",
#              "   AND odc01 = ode01 AND tqd03 = ode02 ",
#              " GROUP BY odc01,tqd03,tqb02,odc11 ",
#              " ORDER BY tqd03"
#  PREPARE level_prepare FROM l_sql
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('Prepare:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#     EXIT PROGRAM
#  END IF
#  DECLARE level_cs CURSOR FOR level_prepare
 
#  LET p_level = p_level + 1
#  IF p_level > tm.c-1 THEN RETURN END IF   #超過報表預定出的列印層級就不印了
 
#  LET l_count = 1
#  FOREACH level_cs INTO sr[l_count].*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('level_cs',SQLCA.sqlcode,0)
#        EXIT FOREACH
#     END IF
 
#     #換算金額單位
#     LET sr[l_count].odc18 = sr[l_count].odc18 / g_unit
#     LET sr[l_count].odc19 = sr[l_count].odc19 / g_unit
#     LET sr[l_count].odc192= sr[l_count].odc192 / g_unit
#     LET sr[l_count].odc21 = sr[l_count].odc21 / g_unit
#     LET sr[l_count].odc11 = sr[l_count].odc11 / g_unit
#     LET sr[l_count].diff  = sr[l_count].diff / g_unit
#     LET l_count = l_count + 1
#  END FOREACH			
#  LET l_count = l_count - 1
 
#  LET g_level_end[p_level] = 0
#  FOR i = 1 TO l_count
#     IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
#      OUTPUT TO REPORT r161_rep(p_level,sr[i].*)
 
#     #檢查是否已是最下層組織
#     SELECT tqd01 FROM tqd_file WHERE tqd01 = sr[i].odc02 
#     IF STATUS != NOTFOUND AND p_level < tm.c THEN
#        SELECT odc02 FROM odc_file 
#         WHERE odc01 = sr[i].odc01 
#           AND odc02 IN (SELECT tqd03 FROM tqd_file WHERE tqd01 = sr[i].odc02)
#        IF STATUS != NOTFOUND THEN
#            OUTPUT TO REPORT r161_rep(p_level+1,sr[600].*)
#           CALL r161_level(p_level,sr[i].odc01,sr[i].odc02)
#        END IF
#     END IF
#  END FOR
#END FUNCTION
#No.FUN-860012---start---			
#REPORT r161_rep(sr)
#DEFINE l_last_sw   LIKE type_file.chr1,               #No.FUN-680120 VARCHAR(1)
#      sr          RECORD
#       	    p_level   LIKE type_file.num5,    #No.FUN-680120 SMALLINT
#        	    odc01     LIKE odc_file.odc01,
#                   odc02     LIKE odc_file.odc02,
#       	    tqb02     LIKE tqb_file.tqb02,
#                   odc18     LIKE odc_file.odc18,
#                   odc19     LIKE odc_file.odc19,
#                   odc192    LIKE odc_file.odc192,
#                   odc21     LIKE odc_file.odc21,
#                   odc11     LIKE odc_file.odc11,
#                   diff      LIKE odc_file.odc11
#                  END RECORD ,
#       l_unit     LIKE aab_file.aab02,         #No.FUN-680120 VARCHAR(6)
#	i          LIKE type_file.num5          #No.FUN-680120 SMALLINT
#DEFINE  l_str      STRING     #No.TQC-6C0217
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     #No.TQC-6C0217 --start--
#     PRINT
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
##    IF cl_null(g_towhom) OR g_towhom = ' ' THEN
##       PRINT '';
##    ELSE 
##       PRINT 'TO:',g_towhom;
##    END IF
##    PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##    PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##    SKIP 1 LINES
#     #No.TQC-6C0217 --end--
#     LET g_pageno =g_pageno + 1
#     #No.TQC-6C0217 --start--
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash[1,g_len]
#     #No.TQC-6C0217 --end--
#     #單位之列印
#     CASE tm.b
#          WHEN '1'  LET l_unit = g_x[17]
#          WHEN '2'  LET l_unit = g_x[18]
#          WHEN '3'  LET l_unit = g_x[19]
#          OTHERWISE LET l_unit = ' '
#     END CASE
#     #No.TQC-6C0217 --start--
##    PRINT COLUMN g_c[31],g_x[2]  CLIPPED,g_pdate,' ',TIME,' ',
##          COLUMN g_c[32],g_x[9]  CLIPPED,sr.odc01,'  ',
##          COLUMN g_c[34],g_x[10] CLIPPED,g_odb09,'  ',
##          COLUMN g_c[35],g_x[11] CLIPPED,l_unit,'  ',
##          COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##    SKIP 1 LINES
#     PRINT COLUMN 1,g_x[9]  CLIPPED,sr.odc01,'  ',
#           COLUMN 40,g_x[10] CLIPPED,g_odb09,'  ',
#           COLUMN 60,g_x[11] CLIPPED,l_unit,'  '
#     PRINT g_dash2
#     #No.TQC-6C0217 --end--
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#     PRINT COLUMN g_c[31],sr.odc02 CLIPPED,'(',sr.tqb02 CLIPPED,')',
#           COLUMN g_c[32],cl_numfor(sr.odc18,32,g_azi04),
#           COLUMN g_c[33],cl_numfor(sr.odc19,33,g_azi04),
#           COLUMN g_c[34],cl_numfor(sr.odc192,34,g_azi04),
#           COLUMN g_c[35],cl_numfor(sr.odc21,35,g_azi04),
#           COLUMN g_c[36],cl_numfor(sr.odc11,36,g_azi04),
#           COLUMN g_c[37],cl_numfor(sr.diff,37,g_azi04)
#       
#  ON EVERY ROW
#     IF sr.p_level = 0 THEN
#        SKIP TO TOP OF PAGE
#     ELSE
#        LET l_str = NULL   #No.TQC-6C0217
#        FOR i = 1 to (sr.p_level - 1)
#           IF g_level_end[i] THEN
##              PRINT COLUMN g_c[31],(i * 4) SPACES;        #No.TQC-6C0217 mark
#              LET l_str = (i * 4) SPACES                  #No.TQC-6C0217
#           ELSE
##              PRINT COLUMN g_c[31],(i * 4) SPACES,g_x[13] CLIPPED;  #No.TQC-6C0217 mark
#              LET l_str = (i * 4) SPACES,g_x[13] CLIPPED            #No.TQC-6C0217
#           END IF
#        END FOR
#        LET i = sr.p_level
#        IF cl_null(sr.odc02) THEN
##           PRINT COLUMN g_c[31],(sr.p_level*4) SPACES,g_x[13] CLIPPED   #No.TQC-6C0217 mark
#           LET l_str = l_str,(sr.p_level*4) SPACES,g_x[13] CLIPPED      #No.TQC-6C0217
#           PRINT COLUMN g_c[31],l_str                                   #No.TQC-6C0217
#        ELSE 
#           IF g_level_end[i]  THEN
##              PRINT COLUMN g_c[31],(sr.p_level*4) SPACES,g_x[14] CLIPPED;   #No.TQC-6C0217 mark
#              LET l_str = l_str,(sr.p_level*4) SPACES,g_x[14] CLIPPED       #No.TQC-6C0217
#           ELSE
##              PRINT COLUMN g_c[31],(sr.p_level*4) SPACES,g_x[15] CLIPPED;   #No.TQC-6C0217 mark
#              LET l_str = l_str,(sr.p_level*4) SPACES,g_x[15] CLIPPED       #No.TQC-6C0217
#           END IF
##           PRINT sr.odc02 CLIPPED,'(',sr.tqb02 CLIPPED,')',                 #No.TQC-6C0217 mark
#           LET l_str = l_str,sr.odc02 CLIPPED,'(',sr.tqb02 CLIPPED,')'      #No.TQC-6C0217
#           PRINT COLUMN g_c[31],l_str,                                      #No.TQC-6C0217
#                 COLUMN g_c[32],cl_numfor(sr.odc18,32,g_azi04),
#                 COLUMN g_c[33],cl_numfor(sr.odc19,33,g_azi04),
#                 COLUMN g_c[34],cl_numfor(sr.odc192,34,g_azi04),
#                 COLUMN g_c[35],cl_numfor(sr.odc21,35,g_azi04),
#                 COLUMN g_c[36],cl_numfor(sr.odc11,36,g_azi04),
#                 COLUMN g_c[37],cl_numfor(sr.diff,37,g_azi04)
#           IF g_level_end[i]  THEN
#              FOR i = 1 to (sr.p_level - 1)
#                 IF g_level_end[i] THEN
##                    PRINT COLUMN g_c[31],(i * 4) SPACES CLIPPED;            #No.TQC-6C0217 mark
#                    LET l_str = (i * 4) SPACES CLIPPED                      #No.TQC-6C0217
#                    PRINT COLUMN g_c[31],l_str                              #No.TQC-6C0217
#                 ELSE
##                    PRINT COLUMN g_c[31],(i * 4) SPACES,g_x[13] CLIPPED;    #No.TQC-6C0217 mark
#                    LET l_str = (i * 4) SPACES,g_x[13] CLIPPED              #No.TQC-6C0217
#                    PRINT COLUMN g_c[31],l_str                              #No.TQC-6C0217
#                 END IF
#              END FOR
##              PRINT       #No.TQC-6C0217 mark
#           END IF
#        END IF
#     END IF
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]       #No.TQC-6C0217
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-6C0217
 
#  PAGE TRAILER
##     IF g_end = 0 AND l_last_sw = 'n' THEN  #No.TQC-6C0217 mark
#      IF  l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]               #No.TQC-6C0217
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
##        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-6C0217
#         SKIP 2 LINE  #No.TQC-6C0217
#      END IF
#END REPORT
#No.FUN-860012---end---
FUNCTION r161_trans(str1,str2,str3)
DEFINE str1      LIKE type_file.chr1000,
       str2,str3 LIKE type_file.chr5,
       l_n       LIKE type_file.num5
 
  #FOR l_n=1 TO 496              #TQC-940090 
   FOR l_n=1 TO length(str1)-4   #TQC-940090 
    IF str1[l_n,l_n+4]=str2 THEN  LET str1[l_n,l_n+4]=str3 END IF
   END FOR
   RETURN str1
END FUNCTION
 
