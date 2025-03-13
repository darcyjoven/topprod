# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr722.4gl
# Descriptions...: 長期借款明細表列印
# Date & Author..: 99/05/07 By Iceman FOR TIPTOP 4.00
# 2002/10/18 Update By Chou. 新增合約額度總額欄位,擷取nno_file 信貸銀行 +
#                            nnp_file 融資種類之單身授信額度
# Modify.........: No.MOD-490329 Kammy 將計算利率的變數小數位數放大
# Modify.........: No.MOD-490454 04/09/29 By Yuna 報表的原幣金額及利率顯示長度太少,會出現**
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.TQC-5B0047 05/11/08 By Niocla 報表修改
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: NO.FUN-7A0036 07/11/06 By zhaijie 改報表為Crystal Report    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		      		 # Print condition RECORD
         #    wc    VARCHAR(600),                   #Where Condiction
              wc    STRING,                      #Where Condiction   #TQC-630166
	      nng03_1 LIKE nng_file.nng03,       #No.FUN-680107 DATE    #動用日範圍
	      nng03_2 LIKE nng_file.nng03,       #No.FUN-680107 DATE
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
   g_tot,g_tot1,g_tot2,g_tot3     LIKE nng_file.nng22,   #No.MOD-490329   #No.FUN-680107 DEC(8,2)
   g_ret1,g_ret2                  LIKE nng_file.nng22,   #No.FUN-680107   #No.MOD-490329 DEC(8,4)
   g_nng20_1,g_nng20_2,g_nng20_3  LIKE nng_file.nng20,   #DECIMAL(12,2)   #計算加總原幣
   g_nng22_1,g_nng22_2,g_nng22_3  LIKE nng_file.nng22,   #DECIMAL(12,2)   #計算加總本幣
   l_nnn02   LIKE nnn_file.nnn02,                        #No.FUN-680107   VARCHAR(20) #add by kitty
   l_nnp09   LIKE nnp_file.nnp09                         #DECIMAL(15,2)   #add by kitty
 
DEFINE g_i            LIKE type_file.num5                #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_head1        STRING
DEFINE l_table        STRING                             #NO.FUN-7A0036
DEFINE g_str          STRING                             #NO.FUN-7A0036
DEFINE g_sql          STRING                             #NO.FUN-7A0036
 
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
#NO.FUN-7A0036 --------start -----
   LET g_sql = "nng04.nng_file.nng04,",
               "alg02.alg_file.alg02,",
               "nng18.nng_file.nng18,",
               "nng01.nng_file.nng01,",
               "nng06.nng_file.nng06,",
               "nnn02.nnn_file.nnn02,",
               "nnp09.nnp_file.nnp09,",
               "l_date.type_file.chr20,",
               "nng20.nng_file.nng20,",
               "nng19.nng_file.nng19,",
               "nng22.nng_file.nng22,",
               "nng09.nng_file.nng09,",
               "nng22_0.nng_file.nng22,",
               "nng07.nng_file.nng07,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07"
   LET l_table = cl_prt_temptable('anmr722',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql   = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?,",
                 "        ?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
#NO.FUN-7A0036 --------end----
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.nng03_1= ARG_VAL(8)
   LET tm.nng03_2= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr722_tm()	        	# Input print condition
      ELSE CALL anmr722()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr722_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW anmr722_w AT p_row,p_col
        WITH FORM "anm/42f/anmr722"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.nng03_2 = g_lastdat
   LET tm.nng03_2 = g_today
   LET tm.nng03_1 = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nng01,nng04
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr722_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.nng03_1,tm.nng03_2,tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
	  AFTER FIELD nng03_1
	   IF cl_null(tm.nng03_1) THEN
		  LET tm.nng03_1 = "96/01/01"
		  DISPLAY BY NAME tm.nng03_1
		  NEXT FIELD nng03_1
           END IF
 
	  AFTER FIELD nng03_2
	   IF cl_null(tm.nng03_2) THEN
		  LET tm.nng03_2 = g_lastdat
		  DISPLAY BY NAME tm.nng03_2
		  NEXT FIELD nng03_2
           END IF
           IF tm.nng03_2 < tm.nng03_1 THEN
              NEXT FIELD nng03_2
           END IF
 
       AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.nng03_1 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nng03_1
           NEXT FIELD nng03_1
       END IF
       IF tm.nng03_2 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nng03_2
           NEXT FIELD nng03_2
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD nng03_1
       END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#     ON ACTION CONTROLP CALL anmr722_wc()   # Input a where condiction
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr722_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr722'
      IF SQLCA.SQLCODE OR cl_null(l_cmd) THEN
          CALL cl_err('anmr722','9031',1)   
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
                         " '",tm.nng03_1 CLIPPED,"'",
                         " '",tm.nng03_2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr722',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr722_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr722()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr722_w
END FUNCTION
 
FUNCTION anmr722()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容  #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE type_file.chr20,  #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          l_i           LIKE type_file.num5,            #No.FUN-680107 SMALLINT
          sr   RECORD
               nng      RECORD LIKE nng_file.*,
	       alg02    LIKE alg_file.alg02             #No.FUN-680107 VARCHAR(10)
               END RECORD
   DEFINE l_azk04       LIKE azk_file.azk04             #NO.FUN-7A0036
   DEFINE t_azi04       LIKE azi_file.azi04             #NO.FUN-7A0036
   DEFINE t_azi03       LIKE azi_file.azi03             #NO.FUN-7A0036
   DEFINE t_azi05       LIKE azi_file.azi05             #NO.FUN-7A0036
   DEFINE t_azi07       LIKE azi_file.azi07             #NO.FUN-7A0036
   DEFINE l_date        LIKE type_file.chr20            #NO.FUN-7A0036
     CALL cl_del_data(l_table)                          #NO.FUN-7A0036 
     
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01='anmr722'    #NO.FUN-7A0036
 
#NO.CHI-6A0004--BEGIN
#   SELECT azi04 INTO g_azi04
#		FROM azi_file WHERE azi01 = g_aza.aza17
#
#   IF SQLCA.sqlcode THEN 
#     CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#      CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#   END IF
#NO.CHI-6A00004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nnguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnguser', 'nnggrup')
     #End:FUN-980030
 
   LET l_sql = "SELECT nng_file.*,alg02 ",
               " FROM nng_file,OUTER alg_file ",
               " WHERE ",tm.wc CLIPPED,
	       " AND nng03 BETWEEN '",tm.nng03_1,"' AND '",tm.nng03_2,"'",
	       " AND alg_file.alg01 = nng_file.nng04 ",
               " AND nngconf <> 'X' ",
	       " ORDER BY nng04,nng18,nng01 "
 
     PREPARE anmr722_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr722_curs1 CURSOR FOR anmr722_prepare1
#     CALL cl_outnam('anmr722') RETURNING l_name       #NO.FUN-7A0036
#     START REPORT anmr722_rep TO l_name               #NO.FUN-7A0036     
 
     LET g_pageno = 0
     LET g_tot = 0
     LET g_tot1 = 0
     LET g_tot2 = 0
     LET g_tot3 = 0
     LET g_ret1 = 0
     LET g_ret2 = 0
     LET g_nng20_1 = 0
     LET g_nng20_2 = 0
     LET g_nng20_3 = 0
     LET g_nng22_1 = 0
     LET g_nng22_2 = 0
     LET g_nng22_3 = 0
 
     FOREACH anmr722_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#       OUTPUT TO REPORT anmr722_rep(sr.*)                #NO.FUN-7A0036--mark--
#NO.FUN-7A0036 --------start-----------     
      LET l_azk04 = s_curr3(sr.nng.nng18,tm.nng03_2,'S')
 
      LET sr.nng.nng22 = sr.nng.nng20 * l_azk04
      LET g_tot = (sr.nng.nng22 * (sr.nng.nng09 / 100) ) /1000
      
      LET l_nnn02 = null
      LET l_nnp09 = 0
      IF  NOT cl_null(sr.nng.nng24) THEN
          SELECT nnn02 INTO l_nnn02 FROM nnn_file
          WHERE nnn01 = sr.nng.nng24
      END IF
      IF  NOT cl_null(sr.nng.nng01) THEN
          SELECT nnp09 INTO l_nnp09 FROM nnp_file,nno_file
          WHERE nno02 = sr.nng.nng04 AND nnp01 = nno01 AND
                nnp03 = sr.nng.nng24
      END IF
      LET l_date=sr.nng.nng101,"-",sr.nng.nng102
      
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07  
        FROM azi_file
       WHERE azi01=sr.nng.nng18
 
      EXECUTE insert_prep USING
         sr.nng.nng04,sr.alg02,sr.nng.nng18,sr.nng.nng01,sr.nng.nng06,
         l_nnn02,l_nnp09,l_date,sr.nng.nng20,sr.nng.nng19,sr.nng.nng22,
         sr.nng.nng09,g_tot,sr.nng.nng07,t_azi03,t_azi04,t_azi05,t_azi07
 
#NO.FUN-7A0036 -----end----
      END FOREACH
 
#NO.FUN-7A0036 -----start----
      LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
      IF g_zz05 ='Y' THEN
         CALL cl_wcchp(tm.wc,'nng01,nng04')
              RETURNING tm.wc
      END IF 
      LET g_str = tm.wc,";",tm.nng03_1,";",tm.nng03_2,";",g_azi04
              
      CALL cl_prt_cs3('anmr722','anmr722',g_sql,g_str)
 
#NO.FUN-7A0036 -----end----
#     FINISH REPORT anmr722_rep                           #NO.FUN-7A0036
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)         #NO.FUN-7A0036
 
END FUNCTION
 
#NO.FUN-7A0036 -----------start-----mark----
{REPORT anmr722_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
	  l_date        LIKE type_file.chr20,        #No.FUN-680107 VARCHAR(20)
	  l_azk04       LIKE azk_file.azk04,
	  t_azi04       LIKE azi_file.azi04,         #add by kitty
	  l_sw18        LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
	  l_sw04        LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
	  l_sta         LIKE type_file.chr20,        #No.FUN-680107 VARCHAR(4)
          t_azi03       LIKE azi_file.azi03,         #NO.CHI-6A0004
       #  l_azi04       LIKE azi_file.azi04,         #NO.CHI-6A0004
          t_azi05       LIKE azi_file.azi05,         #NO.CHI-6A0004
          t_azi07       LIKE azi_file.azi07,         #NO.CHI-6A0004
          sr            RECORD
                        nng   RECORD LIKE nng_file.*,
		        alg02 LIKE alg_file.alg02    #No.FUN-680107 VARCHAR(10)
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nng.nng04,sr.nng.nng18,sr.nng.nng01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      LET g_head1=g_x[11] CLIPPED,tm.nng03_1,"~",tm.nng03_2
      #PRINT g_head1                                           #FUN-660060 remark
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1   #FUN-660060
 
      PRINT g_dash[1,g_len]
# ---mark---modi by kitty
#      PRINT g_x[12] CLIPPED, g_x[13] CLIPPED,g_x[14] CLIPPED,g_x[15] CLIPPED,
#            g_x[16] CLIPPED
--end-#
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 
   ON EVERY ROW
 
   #---------- 找出最近賣出匯率 計算借款金額 --------------------#
      LET l_azk04 = s_curr3(sr.nng.nng18,tm.nng03_2,'S')
      #--add by kitty
      SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01=sr.nng.nng18
 
      LET sr.nng.nng22 = sr.nng.nng20 * l_azk04
      LET g_tot = (sr.nng.nng22 * (sr.nng.nng09 / 100) ) /1000
      IF l_sw04 = 'N' THEN
         LET l_sw04 = 'Y'
         PRINT COLUMN g_c[31],sr.nng.nng04,
               COLUMN g_c[32],sr.alg02;
      END IF
      IF l_sw18 = 'N' THEN
         LET l_sw18 = 'Y'
         PRINT COLUMN g_c[33],sr.nng.nng18;
      END IF
   # Update By Chou. 2002/01/18 加融資種類及額度總額並調整欄位
      LET l_nnn02 = null
      LET l_nnp09 = 0
      IF  NOT cl_null(sr.nng.nng24) THEN
          SELECT nnn02 INTO l_nnn02 FROM nnn_file
          WHERE nnn01 = sr.nng.nng24
      END IF
      IF  NOT cl_null(sr.nng.nng01) THEN
          SELECT nnp09 INTO l_nnp09 FROM nnp_file,nno_file
          WHERE nno02 = sr.nng.nng04 AND nnp01 = nno01 AND
                nnp03 = sr.nng.nng24
      END IF
#---modi by kitty
      PRINT COLUMN 19,sr.nng.nng01,
            COLUMN 31,sr.nng.nng06 CLIPPED,
            COLUMN 50,sr.nng.nng101,"-",sr.nng.nng102,
            COLUMN 68,cl_numfor(sr.nng.nng20,15,t_azi04),  #NO.CHI-6A0004
            COLUMN 85,cl_numfor(sr.nng.nng19,11,4),
            COLUMN 98,cl_numfor(sr.nng.nng22,15,g_azi04),
            COLUMN 115,cl_numfor(sr.nng.nng09,6,3),
            COLUMN 124,cl_numfor(g_tot,6,1),
            COLUMN 133,sr.nng.nng07
      PRINT COLUMN 20,l_dash[1,144]
------------------- #
      LET l_date=sr.nng.nng101,"-",sr.nng.nng102
      PRINT COLUMN g_c[34],sr.nng.nng01,
            COLUMN g_c[35],sr.nng.nng06 CLIPPED,
            COLUMN g_c[36],l_nnn02      CLIPPED,
            COLUMN g_c[37],cl_numfor(l_nnp09,37,t_azi04),
            COLUMN g_c[38],l_date,
             #--No.MOD-490454
            COLUMN g_c[39],cl_numfor(sr.nng.nng20,39,t_azi04),
            COLUMN g_c[40],cl_numfor(sr.nng.nng19,40,t_azi07),
            COLUMN g_c[41],cl_numfor(sr.nng.nng22,41,g_azi04),
            COLUMN g_c[42],cl_numfor(sr.nng.nng09,42,3),
            COLUMN g_c[43],cl_numfor(g_tot,43,1),
            #--END
            COLUMN g_c[44],sr.nng.nng07
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+1],
            COLUMN g_c[33],g_dash2[1,g_w[33]+1],
            COLUMN g_c[34],g_dash2[1,g_w[34]+1],
            COLUMN g_c[35],g_dash2[1,g_w[35]+1],
            COLUMN g_c[36],g_dash2[1,g_w[36]+1],
            COLUMN g_c[37],g_dash2[1,g_w[37]+1],
            COLUMN g_c[38],g_dash2[1,g_w[38]+1],
            COLUMN g_c[39],g_dash2[1,g_w[39]+1],
            COLUMN g_c[40],g_dash2[1,g_w[40]+1],
            COLUMN g_c[41],g_dash2[1,g_w[41]+1],
            COLUMN g_c[42],g_dash2[1,g_w[42]+1],
            COLUMN g_c[43],g_dash2[1,g_w[43]+1],
            COLUMN g_c[44],g_dash2[1,g_w[44]]   #No.TQC-5B0047
   #  LET g_nng19_1 = g_nng19_1 + sr.nng.nng19
   #  LET g_nng19_2 = g_nng19_2 + sr.nng.nng19
      LET g_tot1 = g_tot1 + g_tot
      LET g_tot2 = g_tot2 + g_tot
      LET g_tot3 = g_tot3 + g_tot
 
   BEFORE GROUP OF sr.nng.nng18
 
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07    #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nng.nng18
 
      LET g_tot1 = 0
      LET g_nng20_1 = 0
      LET g_nng22_1 = 0
      LET l_sw18 = 'N'
 
   BEFORE GROUP OF sr.nng.nng04
      LET g_tot2 = 0
      LET g_nng20_2 = 0
      LET g_nng22_2 = 0
      LET l_sw04 = 'N'
 
   AFTER GROUP OF sr.nng.nng18
      LET g_nng20_1 = GROUP SUM(sr.nng.nng20)
      LET g_nng22_1 = GROUP SUM(sr.nng.nng22)
  #   LET g_ret1 = g_tot1 / g_nng22_1
      LET g_ret1 = g_tot1 * 1000 / g_nng22_1
#---modi by kitty
      PRINT COLUMN 9,g_x[17],COLUMN 68,cl_numfor(g_nng20_1,15,t_azi05),  #NO.CHI-6A0004
            COLUMN 98,cl_numfor(g_nng22_1,15,g_azi05),
            COLUMN 124,cl_numfor(g_tot1,6,1)
      PRINT COLUMN 20,l_dash[1,144]
      PRINT COLUMN 2,g_x[21],COLUMN 24,cl_numfor(g_ret1,8,4)
      PRINT COLUMN 20,l_dash[1,144]
------#
      PRINT COLUMN g_c[32],g_x[17],
            COLUMN g_c[39],cl_numfor(g_nng20_1,39,t_azi04),
             COLUMN g_c[41],cl_numfor(g_nng22_1,41,g_azi04),    #--No.MOD-490454
            COLUMN g_c[43],cl_numfor(g_tot1,43,1)
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+1],
            COLUMN g_c[33],g_dash2[1,g_w[33]+1],
            COLUMN g_c[34],g_dash2[1,g_w[34]+1],
            COLUMN g_c[35],g_dash2[1,g_w[35]+1],
            COLUMN g_c[36],g_dash2[1,g_w[36]+1],
            COLUMN g_c[37],g_dash2[1,g_w[37]+1],
            COLUMN g_c[38],g_dash2[1,g_w[38]+1],
            COLUMN g_c[39],g_dash2[1,g_w[39]+1],
            COLUMN g_c[40],g_dash2[1,g_w[40]+1],
            COLUMN g_c[41],g_dash2[1,g_w[41]+1],
            COLUMN g_c[42],g_dash2[1,g_w[42]+1],
            COLUMN g_c[43],g_dash2[1,g_w[43]]   #No.TQC-5B0047
      PRINT COLUMN g_c[32],g_x[21],
            COLUMN g_c[35],cl_numfor(g_ret1,35,4)
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+1],
            COLUMN g_c[33],g_dash2[1,g_w[33]+1],
            COLUMN g_c[34],g_dash2[1,g_w[34]+1],
            COLUMN g_c[35],g_dash2[1,g_w[35]+1],
            COLUMN g_c[36],g_dash2[1,g_w[36]+1],
            COLUMN g_c[37],g_dash2[1,g_w[37]+1],
            COLUMN g_c[38],g_dash2[1,g_w[38]+1],
            COLUMN g_c[39],g_dash2[1,g_w[39]+1],
            COLUMN g_c[40],g_dash2[1,g_w[40]+1],
            COLUMN g_c[41],g_dash2[1,g_w[41]+1],
            COLUMN g_c[42],g_dash2[1,g_w[42]+1],
            COLUMN g_c[43],g_dash2[1,g_w[43]]   #No.TQC-5B0047
 
   AFTER GROUP OF sr.nng.nng04
      LET g_nng20_2 = GROUP SUM(sr.nng.nng20)
      LET g_nng22_2 = GROUP SUM(sr.nng.nng22)
  #   LET g_ret2 = g_tot2 / g.nng22_2
      PRINT COLUMN g_c[32],g_x[18],
            COLUMN g_c[39],cl_numfor(g_nng20_2,39,t_azi04),
             COLUMN g_c[41],cl_numfor(g_nng22_2,41,g_azi04),    #--No.MOD-490454
            COLUMN g_c[43],cl_numfor(g_tot2,43,1)
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+1],
            COLUMN g_c[33],g_dash2[1,g_w[33]+1],
            COLUMN g_c[34],g_dash2[1,g_w[34]+1],
            COLUMN g_c[35],g_dash2[1,g_w[35]+1],
            COLUMN g_c[36],g_dash2[1,g_w[36]+1],
            COLUMN g_c[37],g_dash2[1,g_w[37]+1],
            COLUMN g_c[38],g_dash2[1,g_w[38]+1],
            COLUMN g_c[39],g_dash2[1,g_w[39]+1],
            COLUMN g_c[40],g_dash2[1,g_w[40]+1],
            COLUMN g_c[41],g_dash2[1,g_w[41]+1],
            COLUMN g_c[42],g_dash2[1,g_w[42]+1],
            COLUMN g_c[43],g_dash2[1,g_w[43]]   #No.TQC-5B0047
 
   ON LAST ROW
      LET g_nng20_3 = SUM(sr.nng.nng20)
      LET g_nng22_3 = SUM(sr.nng.nng22)
   #  LET g_ret2 = g_tot3 / g_nng22_3
      LET g_ret2 = g_tot3 * 1000 / g_nng22_3
      PRINT COLUMN g_c[32],g_x[20],
            COLUMN g_c[39],cl_numfor(g_nng20_3,39,t_azi04),
            COLUMN g_c[41],cl_numfor(g_nng22_3,41,g_azi04),
            COLUMN g_c[43],cl_numfor(g_tot3,43,1)
      PRINT " "
      PRINT COLUMN g_c[32],g_x[22],
            COLUMN g_c[35],cl_numfor(g_ret2,35,4)
      PRINT g_dash2[1,g_len]
 #    PRINT g_x[22],COLUMN 30,g_x[23],COLUMN 50,g_x[24]
 
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
           #  IF tm.wc[001,120] > ' ' THEN			# for 132
 	   #     PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
           #  IF tm.wc[121,240] > ' ' THEN
 	   #     PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
           #  IF tm.wc[241,300] > ' ' THEN
 		# PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
           #TQC-630166
           CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#NO.FUN-7A0036 ------end-----
