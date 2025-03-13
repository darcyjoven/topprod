# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr104.4gl
# Descriptions...: 廠商應付票據明細表
# Input parameter:
# Return code....:
# Date & Author..: 92/05/04 By MAY
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD	                     # Print condition RECORD
              wc    STRING,                  # Where Condiction #TQC-630166
              bdate LIKE type_file.dat,      #No.FUN-680107 DATE
              edate LIKE type_file.dat,      #No.FUN-680107 DATE
              more  LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
         l_dash     LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(132)
 
DEFINE   g_i        LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
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
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr104_tm()	        	# Input print condition
      ELSE CALL anmr104()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr104_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd       LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW anmr104_w AT p_row,p_col
        WITH FORM "anm/42f/anmr104"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bdate=g_today
   LET tm.edate=g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmf07
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr104_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
 
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
       IF cl_null(tm.bdate) THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.bdate
           NEXT FIELD bdate
       END IF
       IF cl_null(tm.edate)  THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.edate
           NEXT FIELD edate
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD bdate
       END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr104_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr104'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr104','9031',1)   
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr104',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr104_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr104()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr104_w
END FUNCTION
 
FUNCTION anmr104()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE type_file.chr20,  #No.FUN-680107 ARRAY[2] OF VARCHAR(10)  #排列順序
          l_i           LIKE type_file.num5,            #No.FUN-680107 SMALLINT
          sr               RECORD
                           nmf      RECORD LIKE nmf_file.*,
                           nmd02    LIKE nmd_file.nmd02,
                           nmd03    LIKE nmd_file.nmd03,
                           nmd04    LIKE nmd_file.nmd04,
                           nmd06    LIKE nmd_file.nmd06,
                           nmd10    LIKE nmd_file.nmd10,
                           nmd21    LIKE nmd_file.nmd21,
                           mark     LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#    SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 #NO.CHI-6A0004
#     IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#        CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #FUN-660148
#     END IF
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
   LET l_sql = "SELECT nmf_file.*,nmd02,nmd03,nmd04,nmd06,nmd10,nmd21,''",
               " FROM nmf_file,nmd_file ",
               " WHERE ",tm.wc CLIPPED,
               " AND nmf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               " AND nmf01 = nmd01 ",
               " AND nmd30 <> 'X' ",
               " ORDER BY nmf07,nmf02,nmf03 "
 
     PREPARE anmr104_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
     END IF
     DECLARE anmr104_curs1 CURSOR FOR anmr104_prepare1
     CALL cl_outnam('anmr104') RETURNING l_name
     START REPORT anmr104_rep TO l_name
 
     LET g_pageno = 0
     FOREACH anmr104_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.nmf.nmf07 IS NULL THEN LET sr.nmf.nmf07 = ' ' END IF
       IF sr.nmf.nmf02 IS NULL THEN LET sr.nmf.nmf02 = ' ' END IF
       IF sr.nmf.nmf03 IS NULL THEN LET sr.nmf.nmf03 = ' ' END IF
       CASE sr.nmf.nmf06
            WHEN 'X' LET sr.mark = '2'   #No.B464 add by linda
            WHEN '1' LET sr.mark = '2'
            WHEN '6' LET sr.mark = '1'
            WHEN '7' LET sr.mark = '1'
            WHEN '8' LET sr.mark = '1'
            WHEN '9' LET sr.mark = '1'
            OTHERWISE LET sr.mark = ' '
       END CASE
       OUTPUT TO REPORT anmr104_rep(sr.*)
     END FOREACH
 
     FINISH REPORT anmr104_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT anmr104_rep(sr)
   DEFINE l_last_sw         LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
		  l_total   LIKE nmd_file.nmd04,
		  l_total1  LIKE nmd_file.nmd04,
		  l_total2  LIKE nmd_file.nmd04,
		  l_first   LIKE nmd_file.nmd04,
		  l_pmc03   LIKE pmc_file.pmc03,
		  l_sta     LIKE ze_file.ze03,       #No.FUN-680107 VARCHAR(4)
                  l_nma02   LIKE nma_file.nma02,     #銀行簡稱
          sr               RECORD
                           nmf      RECORD LIKE nmf_file.*,
                           nmd02    LIKE nmd_file.nmd02,
                           nmd03    LIKE nmd_file.nmd03,
                           nmd04    LIKE nmd_file.nmd04,
                           nmd06    LIKE nmd_file.nmd06,
                           nmd10    LIKE nmd_file.nmd10,
                           nmd21    LIKE nmd_file.nmd21,
                           mark     LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.nmf.nmf07,sr.nmd21,sr.nmf.nmf02,sr.nmf.nmf03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[9] CLIPPED,tm.bdate,'-',tm.edate
      #PRINT g_head1                                        #FUN-660060 remark
      PRINT COLUMN (g_len-FGL_WIDTH(g_head1))/2+1, g_head1  #FUN-660060
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
  #BEFORE GROUP OF sr.nmf.nmf07
   BEFORE GROUP OF sr.nmd21
       LET l_total1 = 0
       LET l_total2 = 0
       SELECT SUM(nmd04) INTO l_total FROM nmd_file
                        WHERE nmd12 NOT IN ('8','9')
                          AND nmd08 = sr.nmf.nmf07 AND nmd13 < tm.bdate
       IF SQLCA.sqlcode THEN LET l_total = 0 END IF
       IF cl_null(l_total) THEN LET l_total = 0 END IF
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.nmf.nmf07
       IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF	
       LET l_first = l_total
       PRINT COLUMN g_c[42],g_x[10] CLIPPED,
             COLUMN g_c[43],cl_numfor(l_total,43,t_azi04) CLIPPED  #NO.CHI-6A0004
       PRINT COLUMN g_c[31],sr.nmf.nmf07,
             COLUMN g_c[32],l_pmc03;
 
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nmd21
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmd03
 
      CALL s_nmdsta(sr.nmf.nmf06) RETURNING l_sta
      PRINT COLUMN g_c[33],sr.nmf.nmf02,
            COLUMN g_c[34],l_sta,
            COLUMN g_c[35],sr.nmd02,
            COLUMN g_c[36],sr.nmd06,
            COLUMN g_c[37],sr.nmd10,
            COLUMN g_c[38],sr.nmd03,
            COLUMN g_c[39],l_nma02,
            COLUMN g_c[40],sr.nmd21;
      CASE sr.mark
       WHEN '1'
                LET l_total = l_total - sr.nmd04
                LET l_total1 = l_total1 + sr.nmd04
                PRINT COLUMN g_c[41],cl_numfor(sr.nmd04,41,t_azi04) CLIPPED; #NO.CHI-6A0004
       WHEN '2'
                LET l_total = l_total + sr.nmd04
                LET l_total2 = l_total2 + sr.nmd04
                PRINT COLUMN g_c[42],cl_numfor(sr.nmd04,42,t_azi04) CLIPPED;  #NO.CHI-6A0004
      END CASE
      PRINT COLUMN g_c[43],cl_numfor(l_total,43,t_azi04) CLIPPED    #NO.CHI-6A0004
 
  #AFTER GROUP OF sr.nmf.nmf07
   AFTER GROUP OF sr.nmd21
        PRINT COLUMN g_c[31],g_x[10] CLIPPED,
          COLUMN g_c[32],cl_numfor(l_first,32,t_azi04) CLIPPED,  #No.CHI-6A0004 
          COLUMN g_c[35],g_x[11] CLIPPED,
          COLUMN g_c[37],cl_numfor(l_total1,37,t_azi04) CLIPPED, #NO.CHI-6A0004
          COLUMN g_c[39],g_x[12] CLIPPED,
          COLUMN g_c[41],cl_numfor(l_total2,41,t_azi04) CLIPPED, #NO.CHI-6A0004
          COLUMN g_c[42],g_x[13] CLIPPED,
          COLUMN g_c[43],cl_numfor(l_total,43,t_azi04) CLIPPED  #NO.CHI-6A0004
        #PRINT l_dash[1,g_len]
        PRINT g_dash1
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              #TQC-630166 Start
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 	      #	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
              #	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
 	      #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
 
              CALL cl_prt_pos_wc(tm.wc)
              #TQC-630166 End
 
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
END REPORT
