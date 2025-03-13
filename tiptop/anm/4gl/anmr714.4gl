# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr714.4gl
# Descriptions...: 短期借款各幣別明細表(R&m)列印
# Input parameter:
# Return code....:
# Date & Author..: 99/05/07 By Iceman FOR TIPTOP 4.00
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-590001 05/10/20 By Smapmin 報表內容漏印R&M加權欄位(有表頭.無資料)
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: NO.FUN-7A0036 07/11/02 By zhaijie 將報表改為Crystal Report
# Modify.........: No.TQC-830031 08/03/27 By Carol l_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		                 # Print condition RECORD
              wc    STRING,                      #Where Condiction
   	      nne03_1 LIKE nne_file.nne03,       #No.FUN-680107 DATE
              nne03_2 LIKE nne_file.nne03,       #No.FUN-680107 DATE
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
          l_dash    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(132)
          l_sum     LIKE nne_file.nne12,         #總計銀行目前存款餘額
          l_sw      LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          first_sw  LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
DEFINE   g_i        LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
DEFINE   l_table    STRING                       #NO.FUN-7A0036
DEFINE   g_str      STRING                       #NO.FUN-7A0036
DEFINE   g_sql      STRING                       #NO.FUN-7A0036
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#NO.FUN-7A0036 ---------start-----------
   LET g_sql = "nne16.nne_file.nne16,",
               "nne04.nne_file.nne04,",
               "nne03.nne_file.nne03,",
               "nne01.nne_file.nne01,",
               "nne12.nne_file.nne12,",
               "nne17.nne_file.nne17,",
               "nne19.nne_file.nne19,",
               "nne13.nne_file.nne13,",
               "alg01.alg_file.alg01,",
               "alg02.alg_file.alg02,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07,"
   LET l_table = cl_prt_temptable('anmr714',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql   = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "  VALUES(?,?,?,?,?,?,?,?,?,?,",
                 "         ?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7A0036 -------end-----
# bank sub tot control
   LET l_sw = 'Y'
#
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.nne03_1  = ARG_VAL(8)
   LET tm.nne03_2  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr714_tm()	        	# Input print condition
      ELSE CALL anmr714()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr714_tm()
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd        LIKE type_file.chr1000,#TQC-830031-modify  #No.FUN-680107 VARCHAR(400)
       l_flag       LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW anmr714_w AT p_row,p_col
        WITH FORM "anm/42f/anmr714"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
 # LET tm.nne03_2=g_lastdat
   LET tm.nne03_2=g_today
#   LET tm.detail_sw='1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nne01,nne16,nne04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr714_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.nne03_2,tm.more
   INPUT BY NAME tm.nne03_1,tm.nne03_2,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD nne03_1
	   IF tm.nne03_1 IS NULL OR tm.nne03_1 = ' ' THEN
#		  LET tm.nne03_1 = 0
		  DISPLAY BY NAME tm.nne03_1
		  NEXT FIELD nne03_1
           END IF
           IF NOT cl_null(tm.nne03_2) THEN
           IF tm.nne03_1 > tm.nne03_2 THEN
              NEXT FIELD nne03_1
           END IF
           END IF
      AFTER FIELD nne03_2
	   IF tm.nne03_2 IS NULL OR tm.nne03_2 = ' ' THEN
		  LET tm.nne03_2 = g_lastdat
		  DISPLAY BY NAME tm.nne03_2
		  NEXT FIELD nne03_2
           END IF
           IF tm.nne03_1 > tm.nne03_2 THEN
              NEXT FIELD nne03_1
           END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL OR tm.more = ' '
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.nne03_1 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nne03_1
           NEXT FIELD nne03_1
       END IF
       IF tm.nne03_2 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nne03_2
           NEXT FIELD nne03_2
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD nne03_1
       END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#     ON ACTION CONTROLP CALL anmr714_wc()   # Input detail where condiction
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr714_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr714'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr714','9031',1)
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
                         " '",tm.nne03_1 CLIPPED,"'",
                         " '",tm.nne03_2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr714',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr714_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr714()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr714_w
END FUNCTION
 
FUNCTION anmr714()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE cre_file.cre08,#No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          sr            RECORD
			   nne16    LIKE nne_file.nne16,
			   nne04    LIKE nne_file.nne04,
	                   nne03    LIKE nne_file.nne03,
			   nne01    LIKE nne_file.nne01,
			   nne12    LIKE nne_file.nne12,
			   nne17    LIKE nne_file.nne17,
			   nne19    LIKE nne_file.nne19,
			   nne13    LIKE nne_file.nne13
                        END RECORD
   DEFINE l_pma03                   LIKE pma_file.pma03     #No.FUN-680107 VARCHAR(1)
   DEFINE l_pma08,l_pma09,l_pma10   LIKE pma_file.pma08     #No.FUN-680107 SMALLINT
   DEFINE l_gga03,l_gga04	    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE l_gga05,l_gga051,l_gga07,l_gga071 LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_days		    LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_rate                    LIKE nne_file.nne17     #NO.FUN-7A0036 
   DEFINE l_alg01                   LIKE alg_file.alg01     #NO.FUN-7A0036
   DEFINE l_alg02                   LIKE alg_file.alg02     #NO.FUN-7A0036  
     CALL cl_del_data(l_table)                              #NO.FUN-7A0036
     LET first_sw = 'y'
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.FUN-7A0036----start----mark
#========================================================================
#   CALL cl_outnam('anmr714') RETURNING l_name
#   START REPORT anmr714_rep TO l_name
#   LET g_pageno = 0
#------------------------------------------------------------------------
#NO.FUN-7A0036--------end---
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmr714'  #NO.FUN-7A0036
    
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
     #End:FUN-980030
 
   LET l_sql = "SELECT nne16,nne04,nne03,nne01,nne12,nne17,nne19,",
               "       nne13",
               " FROM nne_file",
               " WHERE nne26 IS NULL",
               "   AND nne03 >= ","'",tm.nne03_1,"'",
               "   AND nne03 <= ","'",tm.nne03_2,"'",
               "   AND nneconf='Y'",
               "   AND ",tm.wc CLIPPED
    PREPARE anmr714_prepare0 FROM l_sql
     DECLARE anmr714_curs0 CURSOR FOR anmr714_prepare0
     FOREACH anmr714_curs0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
#FUN-7A0036 --------start------
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07
        FROM azi_file
        WHERE azi01=sr.nne16
 
      SELECT alg01,alg02 INTO l_alg01,l_alg02
            FROM alg_file WHERE alg01 = sr.nne04
      LET l_rate = s_curr3(sr.nne16,tm.nne03_2,'S')
#FUN-7A0036--------end---------
#       OUTPUT TO REPORT anmr714_rep(sr.*)               #NO.FUN-7A0036 --remark-
      EXECUTE insert_prep USING   
       sr.nne16,sr.nne04,sr.nne03,sr.nne01,sr.nne12,l_rate,
       sr.nne19,sr.nne13,l_alg01,l_alg02,t_azi03,
       t_azi04,t_azi05,t_azi07
    END FOREACH
 
#NO.FUN-7A0036------start-------mark------------------------------------
{     FINISH REPORT anmr714_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
#NO.FUN-7A0036 -------end------
 
#MO.FUN-7A0036 -----start---
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED
     IF g_zz05 = 'Y'  THEN 
        CALL cl_wcchp(tm.wc,'nne01,nne16,nne04')
        RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.nne03_1,";",tm.nne03_2,";",g_azi04
     CALL cl_prt_cs3('anmr714','anmr714',g_sql,g_str)
#NO.FUN-7A0036 ------end---
END FUNCTION
#FUN-7A0036 ------------start------begin--
{
REPORT anmr714_rep(sr)
DEFINE         l_last_sw   LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
#              l_wgt       VARCHAR(18),   #TQC-590001
               a,l_amt,l_amt1,l_amt2,l_amt3  LIKE nne_file.nne12,  #(18,2),#No.FUN-680107 DECIMAL(18,2)
               l_s_amt1,l_s_amt2,l_s_amt3 LIKE nne_file.nne12,     #DECIMAL(18,2)
               l_sta       LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(4)
	       l_alg02     LIKE alg_file.alg02,     #No.FUN-680107 VARCHAR(16)
               l_alg01     LIKE alg_file.alg01,     #No.FUN-680107 VARCHAR(8)
	       l_rate      LIKE nne_file.nne17,
	       l_rate1     LIKE nne_file.nne17,
              # I_azi03     LIKE azi_file.azi03,     #NO.CHI-6A0004
              # l_azi04     LIKE azi_file.azi04,     #NO.CHI-6A0004
              # l_azi05     LIKE azi_file.azi05,     #NO.CHI-6A0004
       sr   RECORD
		  nne16    LIKE nne_file.nne16,
	          nne04    LIKE nne_file.nne04,
	          nne03    LIKE nne_file.nne03,
	          nne01    LIKE nne_file.nne01,
		  nne12    LIKE nne_file.nne12,
		  nne17    LIKE nne_file.nne17,
		  nne19    LIKE nne_file.nne19,
		  nne13    LIKE nne_file.nne13
               END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.nne16,sr.nne04,sr.nne03,sr.nne01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[9] CLIPPED,' ',tm.nne03_1,g_x[10] CLIPPED,' ',tm.nne03_2
      #PRINT g_head1                                          #FUN-660060 remark
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1  #FUN-660060
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nne16
      LET l_alg02 = NULL LET l_sum = 0
      LET l_sw = 'Y'
      LET l_amt1 = 0
      LET l_amt2 = 0
      LET l_amt3 = 0
      LET l_s_amt1 = 0
      LET l_s_amt2 = 0
      LET l_s_amt3 = 0
      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
      PRINT COLUMN g_c[31],sr.nne16;
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07  #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nne16
 
      SELECT alg01,alg02 INTO l_alg01,l_alg02
            FROM alg_file WHERE alg01 = sr.nne04
      LET l_rate = s_curr3(sr.nne16,tm.nne03_2,'S')
      LET l_amt = sr.nne12 * l_rate * sr.nne13 / 100 / 1000
      LET l_sum = sr.nne12 * l_rate
#      LET l_wgt=sr.nne13 USING "##.####",1 SPACES,l_amt USING "#####"   #TQC-590001
      PRINT COLUMN g_c[32],l_alg01,
            COLUMN g_c[33],l_alg02 CLIPPED,
            COLUMN g_c[34],sr.nne01,
            COLUMN g_c[35],cl_numfor(sr.nne12,35,t_azi04),  #NO.CHI-6A0004
 
            COLUMN g_c[36],cl_numfor(l_rate,36,t_azi07),              #No:7952
            COLUMN g_c[37],cl_numfor(l_sum,37,g_azi04),  #No:7952
#            COLUMN g_c[38],l_wgt   #TQC-590001
#            COLUMN g_c[38],sr.nne13 USING "##.####",   #TQC-590001
            COLUMN g_c[38],sr.nne13 USING "#####.####", #No.TQC-5C0051
            COLUMN g_c[39],l_amt USING "#####"   #TQC-590001
 
      PRINT g_dash2
# sub tot
      LET l_s_amt1 = l_s_amt1 + sr.nne12
      LET l_s_amt2 = l_s_amt2 + l_sum
      LET l_s_amt3 = l_s_amt3 + l_amt
 
   AFTER GROUP OF sr.nne16
      LET l_rate1 = l_s_amt3 / l_s_amt2
      PRINT g_x[11] CLIPPED,
            COLUMN g_c[35],cl_numfor(l_s_amt1,35,t_azi05)  #NO.CHI-6A0004
      #PRINT l_dash[1,g_len]
      PRINT g_dash2
 
      PRINT g_x[16] CLIPPED,COLUMN g_c[33],l_rate1 USING "####&.&&&&"
      #PRINT l_dash[1,g_len]
      PRINT g_dash2
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT COLUMN g_c[32],g_x[13] CLIPPED,COLUMN g_c[34],g_x[14] CLIPPED,
            COLUMN g_c[37],g_x[15] CLIPPED
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              #TQC-630166
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 		# PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
 	#	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #      IF tm.wc[241,300] > ' ' THEN
 	#	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
                   #END TQC-630166
 
      END IF
      #PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_sum = 0
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#FUN-7A0036 ------end------
