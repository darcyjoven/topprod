# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr720.4gl
# Descriptions...: 長期貸款還款明細表
# Input parameter:
# Return code....:
# Date & Author..: 99/05/07 By Iceman FOR TIPTOP 4.00
# Modify ........: Joan 020702
#                       加權平均利率=sum(借款餘額本幣 * 利率)/sum(借款餘額本幣)
# Modify ........: Joan 020828
#                       加(1)已結案 (2)未結案 (3)全部
# Modify.........: No.7860 03/08/25 By Wiky anmr720 run時沒法產生資料(oracle OUTER問題)
#                : oracle程式l_sql 增select 部份
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-620054 06/02/20 By Smapmin Oracle 不能使用雙 OUTER
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-830150 08/04/15 By johnray 報表使用CR打印
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0007 10/01/06 By chenmoyan 合计改成子报表列印
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING 
# Modify.........: No.TQC-A40115 10/05/10 By Carrier 32区出现lib-508的错误,即CHI-A10003过单即可
# Modify.........: No.MOD-A70120 10/07/15 By sabrina 合計金額有誤
# Modify.........: No.TQC-A70079 10/07/16 By Dido 增加排序 nng01 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-CA0011 12/10/08 By lujh 把在RPT模板写的显示与否的公式拿到代码中判断

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		      	     # Print condition RECORD
        #     wc    VARCHAR(600),               #Where Condiction
              wc    STRING,                  #Where Condiction      #TQC-630166
	      nng03_1 LIKE nng_file.nng03,   #No.FUN-680107 DATE    #動用日範圍
	      nng03_2 LIKE nng_file.nng03,   #No.FUN-680107 DATE
	      edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              a       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1) #'1'列印明細,'2'列印彙總
            # Joan 020828 -------------------------------------*
              b       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1) #(1)已結案  (2)未結案 (3)全部
            # Joan 020828 end----------------------------------*
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD
   DEFINE g_nng20_tot LIKE nng_file.nng20
   DEFINE g_nng22_tot LIKE nng_file.nng22
 
   DEFINE g_i         LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
   DEFINE g_head1     STRING
#No.FUN-830150 -- begin --
   DEFINE g_sql      STRING
   DEFINE l_table    STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING  #No.TQC-A40115
   DEFINE l_table1   STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING  #No.TQC-A40115
   DEFINE l_table2   STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING  #No.TQC-A40115
   DEFINE g_str      STRING
#No.FUN-830150 -- end --
 
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
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.nng03_1= ARG_VAL(8)
   LET tm.nng03_2= ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)   #TQC-610058
   LET tm.a= ARG_VAL(11)
   LET tm.b= ARG_VAL(12)     #add by kitty
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
 
#No.FUN-830150 -- begin --
   LET g_sql = "nng01.nng_file.nng01,",
               "nng04.nng_file.nng04,",
               "nng06.nng_file.nng06,",
               "nng18.nng_file.nng18,",
               "nng20.nng_file.nng20,",
               "nng22.nng_file.nng22,",
               "nng53.nng_file.nng53,",
               "nnl14.nnl_file.nnl14,",
               "nnk02.nnk_file.nnk02,",
               "nnkconf.nnk_file.nnkconf,",
               "alg02.alg_file.alg02,",
               "l_nmd26_tot.nmd_file.nmd26,",
               "l_nmd26_tot1.nmd_file.nmd26,",
               "t_azi04.azi_file.azi04,",
               "l_date.type_file.chr20"
   LET l_table = cl_prt_temptable('anmr720',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "nmd02.nmd_file.nmd02,",
               "nmd05.nmd_file.nmd05,",
               "nmd10.nmd_file.nmd10,",
               "nmd26.nmd_file.nmd26"
   LET l_table1 = cl_prt_temptable('anmr7201',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "nnl01.nnl_file.nnl01,",
               "nnl04.nnl_file.nnl04,",
               "nnl14.nnl_file.nnl14"
   LET l_table2 = cl_prt_temptable('anmr7202',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
#No.FUN-830150 -- end --
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr720_tm()	        	# Input print condition
      ELSE CALL anmr720()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr720_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW anmr720_w AT p_row,p_col
        WITH FORM "anm/42f/anmr720"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.nng03_1 = g_today
  #LET tm.nng03_2 = g_lastdat
   LET tm.nng03_2 = g_today
   LET tm.edate = g_today
   LET tm.a = '2'
  #Joan 020828 ---------------*
   LET tm.b = '2'
  #Joan 020828 end------------*
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nng01,nng04,nng102
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr720_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#  Joan 020828 ---------------------------------------------------*
#   INPUT BY NAME tm.nng03_1,tm.nng03_2,tm.edate,tm.a,tm.more
   INPUT BY NAME tm.nng03_1,tm.nng03_2,tm.edate,tm.a,tm.b,tm.more
#  Joan 020828 end -----------------------------------------------*
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
	  AFTER FIELD nng03_1
	   IF cl_null(tm.nng03_1) THEN
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
 
	  AFTER FIELD edate
	   IF cl_null(tm.edate) THEN
		  LET tm.edate = g_today
		  DISPLAY BY NAME tm.edate
		  NEXT FIELD edate
           END IF
 
         AFTER FIELD a
           IF tm.a NOT MATCHES "[12]" OR cl_null(tm.a) THEN
              NEXT FIELD a
           END IF
       # Joan 020828 --------------------------------------*
         AFTER FIELD b
           IF tm.b NOT MATCHES "[123]" OR cl_null(tm.b) THEN
              NEXT FIELD b
           END IF
       # Joan 020828 end ----------------------------------*
 
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
       IF tm.a  IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.a
           NEXT FIELD a
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr720_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr720'
      IF SQLCA.SQLCODE OR cl_null(l_cmd) THEN
          CALL cl_err('anmr720','9031',1)   
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
                         " '",tm.nng03_1 CLIPPED,"'",
                         " '",tm.nng03_2 CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                      #  Joan 020828 ------------------*
                         " '",tm.b CLIPPED,"'",
                      #  Joan 020828 end --------------*
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr720',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr720()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr720_w
END FUNCTION
 
FUNCTION anmr720()
   DEFINE l_name	LIKE type_file.chr20,              # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#         l_time    LIKE type_file.chr8                #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,            # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,            #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE type_file.chr20,  #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          l_i       LIKE type_file.num5,               #No.FUN-680107 SMALLINT
          sr        RECORD
                       nng      RECORD LIKE nng_file.*,
                       nnk02    LIKE nnk_file.nnk02,
                       nnl14    LIKE nnl_file.nnl14,
                       nnl12    LIKE nnl_file.nnl12,
                       alg02    LIKE alg_file.alg02,   #No.FUN-680107 VARCHAR(12)
                       nnkconf  LIKE nnk_file.nnkconf,
                       nnl01    LIKE nnl_file.nnl01    #MOD-620054
                    END RECORD
#No.FUN-830150 -- begin --
   DEFINE l_nmd04       LIKE nmd_file.nmd04
   DEFINE l_nmd05       LIKE nmd_file.nmd05
   DEFINE l_nnf01       LIKE nnf_file.nnf01
   DEFINE l_nmd01       LIKE nmd_file.nmd01
   DEFINE l_nmd02       LIKE nmd_file.nmd02
   DEFINE l_nmd26       LIKE nmd_file.nmd26
   DEFINE l_nnl01       LIKE nnl_file.nnl01
   DEFINE l_nnl14       LIKE nnl_file.nnl14
   DEFINE l_nmd26_tot   LIKE nmd_file.nmd26
   DEFINE l_nmd26_tot1  LIKE nmd_file.nmd26
   DEFINE l_date        LIKE type_file.chr20
#No.FUN-830150 -- end --
   DEFINE l_nng01_t     LIKE nng_file.nng01    #MOD-A70120 add
   DEFINE l_nnl14_tot   LIKE nnl_file.nnl14    #MOD-A70120 add
   DEFINE l_nnl14_bal   LIKE nnl_file.nnl14    #TQC-CA0011 add
 
#No.FUN-830150 -- begin --
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
#No.FUN-830150 -- end --
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004-BEGIN
#   SELECT azi04 INTO g_azi04
#		FROM azi_file WHERE azi01 = g_aza.aza17
#
#   IF SQLCA.sqlcode THEN 
#     CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#      CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#   END IF
#NO.CHI-6A0004--END
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND nnguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND nnggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND nnggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnguser', 'nnggrup')
   #End:FUN-980030
 
#   LET l_sql = "SELECT nng_file.*,nnh03,nnh04f,alg02 ",
 
   #-----MOD-620054---------
   #LET l_sql = "SELECT nng_file.*,nnk02,nnl14,nnl12,alg02,nnkconf ",
   #             " FROM nng_file, OUTER (nnl_file,nnk_file),OUTER alg_file ",
   LET l_sql = "SELECT nng_file.*,'',nnl14,nnl12,alg02,'',nnl01 ",
                " FROM nng_file, OUTER nnl_file,OUTER alg_file ",
   #-----END MOD-620054-----
                " WHERE ",tm.wc CLIPPED,
                " AND nng03 BETWEEN '",tm.nng03_1,"' AND '",tm.nng03_2,"'",
                " AND nng_file.nng01 = nnl_file.nnl04 ",
               #" AND nnl01 = nnk_file.nnk01 ",   #MOD-620054
                " AND alg_file.alg01 = nng_file.nng04 ",                        #TQC-A70079
               #" AND nnk02 <= '",tm.edate,"'",   #MOD-620054
	       #" AND nnkconf = 'Y' "   #add by evechu 020824   #MOD-620054
                " ORDER BY nng01 "                                              #TQC-A70079
 
   PREPARE anmr720_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   DECLARE anmr720_curs1 CURSOR FOR anmr720_prepare1
#No.FUN-830150 -- begin --
#   CALL cl_outnam('anmr720') RETURNING l_name
#   START REPORT anmr720_rep TO l_name
#No.FUN-830150 -- end --
 
   LET g_pageno = 0
   LET g_nng20_tot = 0
   LET g_nng22_tot = 0     #add by kitty
 
   LET l_nng01_t = NULL      #MOD-A70120   add
   FOREACH anmr720_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #-----MOD-620054---------
      SELECT nnk02,nnkconf INTO sr.nnk02,sr.nnkconf FROM nnk_file
       WHERE nnk01 = sr.nnl01 AND nnk02 <= tm.edate AND nnkconf = 'Y'
      #-----END MOD-620054-----
      IF cl_null(sr.nnl14) THEN LET sr.nnl14 = 0 END IF
#No.FUN-830150 -- begin --
#       OUTPUT TO REPORT anmr720_rep(sr.*)
      IF cl_null(l_nng01_t) OR (l_nng01_t <> sr.nng.nng01) THEN        #MOD-A70120 add   #當合約編號不等於上一筆時才寫入報表
         SELECT SUM(nmd26) INTO l_nmd26_tot FROM nmd_file
          WHERE nmd10 = sr.nng.nng01 AND nmd05  <= tm.edate AND nmd12 ='8'
         SELECT SUM(nmd26) INTO l_nmd26_tot1  # 支票不可當作已還啦
           FROM nmd_file,nnf_file
          WHERE nmd10 = sr.nng.nng01 AND nmd05  <= tm.edate
            AND nmd12 ='8' AND nnf06 = nmd01 AND nnf08 = '1'
         IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
         IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
#         LET l_nnl14_tot = l_nnl14_tot1 + l_nmd26_tot - l_nmd26_tot1
#         LET l_bal = sr.nng.nng22 -l_nnl14_tot
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nng.nng18
         LET l_date=sr.nng.nng081,"-",sr.nng.nng082
 
         DECLARE r720_nmd_cur CURSOR FOR
          SELECT nmd01,nmd02,nmd05,nmd26 FROM nmd_file
           WHERE nmd10 = sr.nng.nng01 AND nmd05  <= tm.edate
         FOREACH r720_nmd_cur INTO l_nmd01,l_nmd02,l_nmd05,l_nmd26
            IF STATUS THEN
               CALL cl_err("foreach r720_nmd_cur:",STATUS,1)
               EXIT FOREACH
            END IF
            LET l_nnf01 = NULL
            SELECT nnf01 INTO l_nnf01 FROM nnf_file
             WHERE nnf06 = l_nmd01 AND nnf08 = '1'
            IF cl_null(l_nnf01) THEN
               EXECUTE insert_prep1 USING l_nmd02,l_nmd05,sr.nng.nng01,l_nmd26
               IF STATUS THEN
                  CALL cl_err("execute insert_prep1:",STATUS,1)
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH
 
         DECLARE r720_nnl_cur CURSOR FOR
          SELECT nnl01,nnl14 FROM nnl_file,nnk_file
           WHERE nnl01 = nnk01 AND nnl04 = sr.nng.nng01
             AND nnk02  <= tm.edate AND nnkconf = 'Y'
         LET l_nnl14_tot = 0     #MOD-A70120 add     
         FOREACH r720_nnl_cur INTO l_nnl01,l_nnl14
            IF STATUS THEN
               CALL cl_err("foreach r720_nnl_cur:",STATUS,1)
               EXIT FOREACH
            END IF
            LET l_nnl14_tot = l_nnl14_tot + l_nnl14     #MOD-A70120 add      #計算總還本金額
            EXECUTE insert_prep2 USING l_nnl01,sr.nng.nng01,l_nnl14
            IF STATUS THEN
               CALL cl_err("execute insert_prep2:",STATUS,1)
               EXIT FOREACH
            END IF
         END FOREACH
         #TQC-CA0011--add--str--
         IF cl_null(l_nnl14_tot) THEN
            LET l_nnl14_bal =  l_nmd26_tot - l_nmd26_tot1
         ELSE
            LET l_nnl14_bal =  l_nnl14_tot + l_nmd26_tot - l_nmd26_tot1
         END IF
         IF tm.b = '1' THEN
            IF sr.nng.nng22 - l_nnl14_bal = 0 THEN
               EXECUTE insert_prep USING sr.nng.nng01,sr.nng.nng04,sr.nng.nng06,sr.nng.nng18,sr.nng.nng20,
                                   sr.nng.nng22,sr.nng.nng53,l_nnl14_tot,sr.nnk02,sr.nnkconf,sr.alg02,
                                   l_nmd26_tot,l_nmd26_tot1,t_azi04,l_date
               LET l_nng01_t = sr.nng.nng01
               IF STATUS THEN
                  CALL cl_err("execute insert_prep:",STATUS,1)
                  EXIT FOREACH
               END IF
            END IF
         END IF
         IF tm.b = '2' THEN
            IF sr.nng.nng22 - l_nnl14_bal <> 0 THEN
               EXECUTE insert_prep USING sr.nng.nng01,sr.nng.nng04,sr.nng.nng06,sr.nng.nng18,sr.nng.nng20,
                                   sr.nng.nng22,sr.nng.nng53,l_nnl14_tot,sr.nnk02,sr.nnkconf,sr.alg02,
                                   l_nmd26_tot,l_nmd26_tot1,t_azi04,l_date
               LET l_nng01_t = sr.nng.nng01
               IF STATUS THEN
                  CALL cl_err("execute insert_prep:",STATUS,1)
                  EXIT FOREACH
               END IF
            END IF
         END IF
         IF tm.b = '3' THEN
            EXECUTE insert_prep USING sr.nng.nng01,sr.nng.nng04,sr.nng.nng06,sr.nng.nng18,sr.nng.nng20,
                                   sr.nng.nng22,sr.nng.nng53,l_nnl14_tot,sr.nnk02,sr.nnkconf,sr.alg02,
                                   l_nmd26_tot,l_nmd26_tot1,t_azi04,l_date
            LET l_nng01_t = sr.nng.nng01
            IF STATUS THEN
               CALL cl_err("execute insert_prep:",STATUS,1)
               EXIT FOREACH
            END IF
         END IF
         #TQC-CA0011--add--end--
         #TQC-CA0011--mark--str--
         #EXECUTE insert_prep USING sr.nng.nng01,sr.nng.nng04,sr.nng.nng06,sr.nng.nng18,sr.nng.nng20,
         #                         #sr.nng.nng22,sr.nng.nng53,sr.nnl14,sr.nnk02,sr.nnkconf,sr.alg02,       #MOD-A70120 mark
         #                          sr.nng.nng22,sr.nng.nng53,l_nnl14_tot,sr.nnk02,sr.nnkconf,sr.alg02,    #MOD-A70120 add
         #                          l_nmd26_tot,l_nmd26_tot1,t_azi04,l_date
         #LET l_nng01_t = sr.nng.nng01           #MOD-A70120 add
         #IF STATUS THEN
         #   CALL cl_err("execute insert_prep:",STATUS,1)
         #   EXIT FOREACH
         #END IF
         #TQC-CA0011--mark--end--
      END IF           #MOD-A70120 add
#No.FUN-830150 -- end --
   END FOREACH
 
#No.FUN-830150 -- begin --
#     FINISH REPORT anmr720_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 ='Y' THEN
      CALL cl_wcchp(tm.wc,'nng01,nng04,nng102')
           RETURNING tm.wc
   ELSE 
      LET tm.wc = ''
   END IF
   LET g_str = tm.wc,";",tm.nng03_1,";",tm.nng03_2,";",
               tm.a,";",tm.b,";",g_azi04
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
          ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.CHI-9C0007
   CALL cl_prt_cs3('anmr720','anmr720',g_sql,g_str)
#No.FUN-830150 -- end --
END FUNCTION
 
#No.FUN-830150 -- begin --
#REPORT anmr720_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
#	  l_nmd04   LIKE nmd_file.nmd04,
#	  l_nmd05   LIKE nmd_file.nmd05,
#	  l_nnl     RECORD LIKE nnl_file.*,
#	  l_sta     LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(4)
#	  t_azi04   LIKE azi_file.azi04,
#	  tot,bal   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
#          sr            RECORD
#                        nng      RECORD LIKE nng_file.*,
#                        nnk02    LIKE nnk_file.nnk02,
#                        nnl14    LIKE nnl_file.nnl14,
#                        nnl12    LIKE nnl_file.nnl12,
#		        alg02    LIKE alg_file.alg02,  #No.FUN-680107 VARCHAR(12)
#                        nnkconf  LIKE nnk_file.nnkconf,
#                        nnl01    LIKE nnl_file.nnl01   #MOD-620054
#                        END RECORD
#     DEFINE l_nnl14_tot  LIKE nnl_file.nnl14
#     DEFINE l_nnl14_tot1 LIKE nnl_file.nnl14
#     DEFINE l_princ      LIKE nnl_file.nnl14
## Joan 020702 ----------------------------------
##    DEFINE l_rate_avg    LIKE nng_file.nng22
#     DEFINE l_rate_avg    LIKE nng_file.nng20
## Joan 020702 end-------------------------------
#     DEFINE l_nng20_tot   LIKE nng_file.nng20
#     DEFINE l_nng22_tot   LIKE nng_file.nng22
#     DEFINE l_bal         LIKE nng_file.nng20
#     DEFINE l_bal_tot     LIKE nng_file.nng20
#     DEFINE l_nnf01       LIKE nnf_file.nnf01
#     DEFINE l_nmd01       LIKE nmd_file.nmd01
#     DEFINE l_nmd02       LIKE nmd_file.nmd02
#     DEFINE l_nmd26       LIKE nmd_file.nmd26
#     DEFINE l_nnl01       LIKE nnl_file.nnl01
#     DEFINE l_nnl14       LIKE nnl_file.nnl14
#     DEFINE l_nmd26_tot   LIKE nmd_file.nmd26
#     DEFINE l_nmd26_tot1  LIKE nmd_file.nmd26
#     DEFINE l_date        LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
# #ORDER BY sr.nng.nng18,sr.nng.nng01,sr.nnh03
#  ORDER BY sr.nng.nng18,sr.nng.nng01,sr.nnk02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#      LET g_head1=g_x[11] CLIPPED,tm.nng03_1,"-",tm.nng03_2
#      #PRINT g_head1                                     #FUN-660060 remark
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#  # Jason 020614
#   BEFORE GROUP OF sr.nng.nng18
#      LET l_bal_tot = 0
#      LET l_princ = 0
#      LET l_nng20_tot = 0
#      LET l_nng22_tot = 0
## Joan 020702-----------
#      LET l_rate_avg = 0
## Joan 020702 end-------
#  #-----end
#
#   BEFORE GROUP OF sr.nng.nng01
#      LET g_nng20_tot = g_nng20_tot + sr.nng.nng20
#      LET g_nng22_tot = g_nng22_tot + sr.nng.nng22
#{---modi by kitty
#      SELECT azi03,azi04,azi05
#        INTO l_azi03,l_azi04,l_azi05
#        FROM azi_file
#       WHERE azi01=sr.nng.nng18
#
#      PRINT sr.alg02,COLUMN 14,sr.nng.nng18,COLUMN 19,sr.nng.nng01,
#            COLUMN 31,sr.nng.nng06,COLUMN 52,sr.nng.nng081,"-",sr.nng.nng082,
#            COLUMN 70,cl_numfor(sr.nng.nng20,16,l_azi04) CLIPPED #原幣貸款金額
#      LET g_nng20_tot = g_nng20_tot + sr.nng.nng20
#-----}
#
#   ON EVERY ROW
#{--modi by kitty
#      IF tm.a = '1' THEN
#          PRINT COLUMN 88,sr.nnh03,#到期日
#                COLUMN 96,cl_numfor(sr.nnh04f,15,l_azi04) #原幣票面金額
#      END IF
#---}
# 
#   AFTER GROUP OF sr.nng.nng01
#{---modi by kitty
#         LET l_nnh04f_tot = GROUP SUM(sr.nnh04f)
#         LET l_bal = sr.nng.nng20 - l_nnh04f_tot
#         PRINT COLUMN 90,g_x[21] CLIPPED,
#               COLUMN 96,cl_numfor(l_nnh04f_tot,15,l_azi05) CLIPPED,
#               g_x[20] CLIPPED,cl_numfor(l_bal,13,2) CLIPPED
#      PRINT l_dash[1,g_len]
#--------------}
#         LET l_nnl14_tot1= GROUP SUM(sr.nnl14) WHERE sr.nnkconf ='Y'
#         LET l_nnl14_tot = 0 # Jason 020612
#         SELECT SUM(nmd26) INTO l_nmd26_tot FROM nmd_file
#             WHERE nmd10 = sr.nng.nng01 AND nmd05  <= tm.edate AND nmd12 ='8'
## Thomas 020903
#       SELECT SUM(nmd26) INTO l_nmd26_tot1  # 支票不可當作已還啦
#         FROM nmd_file,nnf_file
#           WHERE nmd10 = sr.nng.nng01 AND nmd05  <= tm.edate AND nmd12 ='8'
#             AND nnf06 = nmd01 AND nnf08 = '1'
#         DECLARE r720_nmd_cur CURSOR FOR
#         SELECT nmd01,nmd02,nmd05,nmd26 FROM nmd_file
#         WHERE nmd10 = sr.nng.nng01 AND nmd05  <= tm.edate
#         IF cl_null(l_nnl14_tot1) THEN LET l_nnl14_tot1 = 0 END IF
#         IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
#         IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
#         LET l_nnl14_tot = l_nnl14_tot1 + l_nmd26_tot - l_nmd26_tot1
#         LET l_bal = sr.nng.nng22 -l_nnl14_tot
#      ######
## Thomas 020923
#         # LET l_bal_tot = l_bal_tot + l_bal
#         # LET l_princ = l_princ + l_nnl14_tot
#         # LET l_rate_avg  = l_rate_avg + (l_bal * sr.nng.nng53)
## End
#
## Thomas 020923
#         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nng.nng18
#         CASE
#             WHEN tm.a = '1' AND ((tm.b = '1' AND l_bal  = 0)
#                              OR (tm.b = '2' AND l_bal != 0)
#                              OR tm.b = '3')
#                  LET l_date=sr.nng.nng081,"-",sr.nng.nng082
#                  PRINT COLUMN g_c[31],sr.nng.nng04,
#                        COLUMN g_c[32],sr.alg02,
#                        COLUMN g_c[33],sr.nng.nng18,
#                        COLUMN g_c[34],sr.nng.nng01,
#                        COLUMN g_c[35],sr.nng.nng06,
#                        COLUMN g_c[36],l_date,
#                        COLUMN g_c[37],cl_numfor(sr.nng.nng20,37,t_azi04) CLIPPED,
#                        COLUMN g_c[38],cl_numfor(sr.nng.nng22,38,g_azi04) CLIPPED,
#                        COLUMN g_c[39],sr.nng.nng53 USING '##&.&&'
#                  DECLARE r720_nnl_cur CURSOR FOR
#                   SELECT nnl01,nnl14 FROM nnl_file,nnk_file
#                    WHERE nnl01 = nnk01 AND nnl04 = sr.nng.nng01
#                      AND nnk02  <= tm.edate
#                      AND nnkconf = 'Y'
#                  FOREACH r720_nmd_cur INTO l_nmd01,l_nmd02,l_nmd05,l_nmd26
#                          IF STATUS THEN EXIT FOREACH END IF
#                      LET l_nnf01 = NULL
#                      SELECT nnf01 INTO l_nnf01 FROM nnf_file
#                       WHERE nnf06 = l_nmd01
#                         AND nnf08 = '1'
#                      IF cl_null(l_nnf01) THEN
#                         PRINT COLUMN g_c[33],g_x[23] CLIPPED,
#                               COLUMN g_c[34],l_nmd02,
#                               COLUMN g_c[35],g_x[24] CLIPPED,
#                               COLUMN g_c[36],l_nmd05,
#                               COLUMN g_c[38],g_x[25] CLIPPED,
#                               COLUMN g_c[40],cl_numfor(l_nmd26,40,g_azi04) CLIPPED
#                       END IF
#                  END FOREACH
#                  FOREACH r720_nnl_cur INTO l_nnl01,l_nnl14
#                          IF STATUS THEN EXIT FOREACH END IF
#                      PRINT COLUMN g_c[35],g_x[21] CLIPPED,
#                            COLUMN g_c[36],l_nnl01,
#                            COLUMN g_c[38],g_x[22] CLIPPED,
#                            COLUMN g_c[40],cl_numfor(l_nnl14,40,g_azi04) CLIPPED
#                  END FOREACH
#                  PRINT COLUMN g_c[38],g_x[20] CLIPPED,
#                        COLUMN g_c[40],cl_numfor(l_nnl14_tot,40,g_azi04) CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_bal,41,g_azi04) CLIPPED
#                  PRINT g_dash2[1,g_len]
#                  LET l_bal_tot = l_bal_tot + l_bal
#                  LET l_princ = l_princ + l_nnl14_tot
#                  LET l_rate_avg  = l_rate_avg + (l_bal * sr.nng.nng53)
#                  LET l_nng20_tot = l_nng20_tot + sr.nng.nng20
#                  LET l_nng22_tot = l_nng22_tot + sr.nng.nng22
#             WHEN tm.a = '2' AND ((tm.b = '1' AND l_bal  = 0)
#                              OR (tm.b = '2' AND l_bal != 0)
#                              OR tm.b = '3')
#                  LET l_date=sr.nng.nng081,"-",sr.nng.nng082
#                  PRINT COLUMN g_c[31],sr.nng.nng04,
#                        COLUMN g_c[32],sr.alg02,
#                        COLUMN g_c[33],sr.nng.nng18,
#                        COLUMN g_c[34],sr.nng.nng01,
#                        COLUMN g_c[35],sr.nng.nng06,
#                        COLUMN g_c[36],l_date,
#                        COLUMN g_c[37],cl_numfor(sr.nng.nng20,37,t_azi04) CLIPPED,
#                        COLUMN g_c[38],cl_numfor(sr.nng.nng22,38,g_azi04) CLIPPED,
#                        COLUMN g_c[39],sr.nng.nng53 USING '##&.&&'
#                  PRINT COLUMN g_c[38],g_x[20] CLIPPED;
#                  PRINT COLUMN g_c[40],cl_numfor(l_nnl14_tot,40,g_azi04) CLIPPED,' ',
#                        COLUMN g_c[41],cl_numfor(l_bal,41,g_azi04) CLIPPED
#                  PRINT g_dash2[1,g_len]
#                  LET l_bal_tot = l_bal_tot + l_bal
#                  LET l_princ = l_princ + l_nnl14_tot
#                  LET l_rate_avg  = l_rate_avg + (l_bal * sr.nng.nng53)
#                  LET l_nng20_tot = l_nng20_tot + sr.nng.nng20
#                  LET l_nng22_tot = l_nng22_tot + sr.nng.nng22
#         END CASE
## End
## Joan 020503 end--------------------------------------------------
#
#   AFTER GROUP OF sr.nng.nng18
#{---modi by kitty
#         LET l_nnh04f_tot = GROUP SUM(sr.nnh04f)
#         LET l_bal = g_nng20_tot - l_nnh04f_tot
#         PRINT COLUMN 86,g_x[19] CLIPPED,
#               COLUMN 96,cl_numfor(l_nnh04f_tot,15,l_azi05) CLIPPED,
#               g_x[20] CLIPPED,cl_numfor(l_bal,13,2) CLIPPED
#      PRINT g_dash2[1,g_len]
#---}
#         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nng.nng18
#         LET l_nnl14_tot = GROUP SUM(sr.nnl14)
#         LET l_bal = g_nng22_tot - l_nnl14_tot
#         # LET l_nng20_tot = GROUP SUM(sr.nng.nng20)
#         #LET l_nng22_tot = GROUP SUM(sr.nng.nng22)
#         PRINT COLUMN g_c[34],g_x[19] CLIPPED,
#               COLUMN g_c[37],cl_numfor(l_nng20_tot,37,t_azi04) CLIPPED,#原幣貸款金額
#               COLUMN g_c[38],cl_numfor(l_nng22_tot,38,g_azi04) CLIPPED,#本幣貸款金額
#               COLUMN g_c[39],l_rate_avg/l_bal_tot USING '##&.&&&',
#               COLUMN g_c[40],cl_numfor(l_princ,40,g_azi04) CLIPPED,' ',
#               COLUMN g_c[41],cl_numfor(l_bal_tot,41,g_azi04) CLIPPED
## Joan 020503 end----------------------------------------------------------
#      PRINT g_dash2[1,g_len]
#
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
#           #   IF tm.wc[001,120] > ' ' THEN			# for 132
# 	   #	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#           #   IF tm.wc[121,240] > ' ' THEN
#           #		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#           #   IF tm.wc[241,300] > ' ' THEN
# 	   #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#          #TQC-630166
#          CALL cl_prt_pos_wc(tm.wc)  
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
##No.FUN-830150 -- end --
#FUN-870144
