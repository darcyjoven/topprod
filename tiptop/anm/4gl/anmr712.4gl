# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr712.4gl
# Descriptions...: 購料貸款明細表(R&M)
# Date & Author..: 99/05/07 By Iceman FOR TIPTOP 4.00
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify.........: NO.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
#
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		            # Print condition RECORD
           wc      STRING,                  #Where Condiction
           nne03_1 LIKE nne_file.nne03,     #No.FUN-680107 DATE
           nne03_2 LIKE nne_file.nne03,     #No.FUN-680107 DATE
           more    LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1) #是否列印其它條件
           END RECORD,
       l_dash      LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(132)
       bdate	   LIKE type_file.dat,      #No.FUN-680107 DATE
       l_sw        LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
DEFINE g_i         LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_head1     STRING
 
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
 
 
   LET l_sw = 'Y'
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
   #No.FUN-570264 ---end---
#No.FUN-680107 --start
#  CREATE TEMP TABLE r712_tmp
#  ( nne06   VARCHAR(4),
#    nne19   DEC(20,6),
#    nne13   DEC(20,6) );
 
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE r712_tmp(
     nne06 LIKE nne_file.nne06,
     nne19 LIKE nne_file.nne19,
     nne13 LIKE nne_file.nne13);
#No.FUN-680107 --end
   create unique index r712_tmp_01 on r712_tmp (nne06);
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr712_tm()	        	# Input print condition
      ELSE CALL anmr712()			# Read data and create out-file
   END IF
   DROP TABLE r712_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr712_tm()
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd	    LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
       l_flag       LIKE type_file.chr1,    #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 16
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW anmr712_w AT p_row,p_col
        WITH FORM "anm/42f/anmr712"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.nne03_2=g_lastdat
   LET tm.nne03_2=g_today
   LET bdate=g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nne01,nne04,nne06
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr712_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
  DISPLAY BY NAME tm.nne03_2,tm.more
  INPUT BY NAME tm.nne03_1,tm.nne03_2,tm.more
           WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD nne03_1
	   IF tm.nne03_1 IS NULL OR tm.nne03_1 = ' ' THEN
		  NEXT FIELD nne03_1
           END IF
      AFTER FIELD nne03_2
	   IF tm.nne03_2 IS NULL OR tm.nne03_2 = ' ' THEN
		  NEXT FIELD nne03_2
           END IF
           IF  tm.nne03_2<tm.nne03_1 THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr712_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr712'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr712','9031',1)
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
                         " '",tm.nne03_1 CLIPPED,"'",
                         " '",tm.nne03_2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr712',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr712_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr712()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr712_w
END FUNCTION
 
FUNCTION anmr712()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE type_file.chr20,  #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          sr            RECORD
			   nne04    LIKE nne_file.nne04,
			   nne16    LIKE nne_file.nne16,
			   nne01    LIKE nne_file.nne01,
			   nne112   LIKE nne_file.nne112,
			   nne12    LIKE nne_file.nne12,
			   nne17    LIKE nne_file.nne17,
			   nne13    LIKE nne_file.nne13,
                           nne19    LIKE nne_file.nne19,
                           nne06    LIKE nne_file.nne06
                        END RECORD
 
     DELETE from r712_tmp
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
#========================================================================
   CALL cl_outnam('anmr712') RETURNING l_name
   START REPORT anmr712_rep TO l_name
   LET g_pageno = 0
#------------------------------------------------------------------------
       LET l_sql = "SELECT nne04,nne16,nne01, ",
                   "       nne112,nne12,nne17,nne13,nne19,nne06 ",
                   " FROM nne_file ",
                   "WHERE nne26 IS NULL ",
                   "  AND nne03 >= ","'",tm.nne03_1,"'",
                   "  AND nne03 <= ","'",tm.nne03_2,"'",
                   "  AND nneconf <> 'X' ",
                   "  AND ", tm.wc CLIPPED
    PREPARE anmr712_prepare0 FROM l_sql
     DECLARE anmr712_curs0 CURSOR FOR anmr712_prepare0
     FOREACH anmr712_curs0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
     LET sr.nne17 = s_curr3(sr.nne16,g_pdate,'S')
     LET sr.nne19 = sr.nne12*sr.nne17
     OUTPUT TO REPORT anmr712_rep(sr.*)
     END FOREACH
#------------------------------------------------------------------------
     FINISH REPORT anmr712_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT anmr712_rep(sr)
DEFINE   l_sw1,l_last_sw   LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
         l_nnn02           LIKE nnn_file.nnn02,
         l_nnn02_1         LIKE type_file.chr50,    #No.FUN-680107 VARCHAR(30)
	 l_alg02           LIKE alg_file.alg02,     #No.FUN-680107 VARCHAR(30)
         l_alg01           LIKE alg_file.alg01,     #No.FUN-680107 VARCHAR(8)
	 l_cnt             LIKE type_file.num5,     #No.FUN-680107 SMALLINT
         ret               LIKE nne_file.nne19,     #No.FUN-680107 DEC(7,4)
         l_azi03           LIKE azi_file.azi03,    
         l_azi04           LIKE azi_file.azi04,    
         l_azi05           LIKE azi_file.azi05,    
        sl   RECORD
	          nne06    LIKE nne_file.nne06,
	          nne19    LIKE nne_file.nne19,
                  nne13    LIKE nne_file.nne13
               END RECORD,
        sr   RECORD
	          nne04    LIKE nne_file.nne04,
	          nne16    LIKE nne_file.nne16,
                  nne01    LIKE nne_file.nne01,
		  nne112   LIKE nne_file.nne112,
		  nne12    LIKE nne_file.nne12,
		  nne17    LIKE nne_file.nne17,
		  nne13    LIKE nne_file.nne13,
                  nne19    LIKE nne_file.nne19,
                  nne06    LIKE nne_file.nne06
               END RECORD
  OUTPUT
         TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         RIGHT MARGIN 132
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nne04,sr.nne16,sr.nne01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[9] CLIPPED,' ',tm.nne03_1,g_x[10] CLIPPED,' ',tm.nne03_2
      #PRINT g_head1                                        #FUN-660060 remark
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1 #FUN-660060
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
      PRINT g_dash1
      LET l_last_sw ='n'
   BEFORE GROUP OF sr.nne04
      LET l_sw = 'Y'
      SELECT alg01,alg02 INTO l_alg01,l_alg02
            FROM alg_file WHERE alg01 = sr.nne04
   BEFORE GROUP OF sr.nne16
      LET l_sw1 ='Y'
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05
        INTO l_azi03,l_azi04,l_azi05  
        FROM azi_file
       WHERE azi01=sr.nne16
 
      IF l_sw = 'N' THEN
          LET l_alg02 = '            '
         ELSE
          LET l_sw = 'N'
      END IF
      IF l_sw1 = 'N' THEN
          LET sr.nne16 = '       '
         ELSE
          LET l_sw1  = 'N'
      END  IF
       SELECT count(*) INTO l_cnt FROM r712_tmp
        WHERE r712_tmp.nne06 = sr.nne06
 
       IF l_cnt > 0 THEN
          UPDATE r712_tmp SET  nne19 = nne19 + sr.nne19,
                               nne13 = nne13 + sr.nne13
           WHERE r712_tmp.nne06 = sr.nne06
       ELSE
          INSERT INTO r712_tmp VALUES(sr.nne06,sr.nne19,sr.nne13)
       END IF
       SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07 FROM azi_file WHERE azi01=sr.nne16    #NO.CHI-6A0004
       SELECT nnn02 INTO l_nnn02 FROM nnn_file WHERE nnn01=sr.nne06
       PRINT COLUMN g_c[31],l_alg01,
             COLUMN g_c[32],l_alg02 CLIPPED,
             COLUMN g_c[33],sr.nne16,
#No.FUN-550057 --start--
   #          COLUMN g_c[34],sr.nne01[1,10],
             COLUMN g_c[34],sr.nne01,
#No.FUN-550057 ---end--
             COLUMN g_c[35],l_nnn02[1,10],    #融資種類名稱
             COLUMN g_c[37],sr.nne112 CLIPPED,
             COLUMN g_c[38],cl_numfor(sr.nne12,38,l_azi04), 
             COLUMN g_c[39],cl_numfor(sr.nne17,39,t_azi07),  #NO.CHI-6A0004
             COLUMN g_c[40],cl_numfor(sr.nne19,40,t_azi04), #NO.CHI-6A0004
             COLUMN g_c[41],sr.nne13 CLIPPED USING "#######.##" #No.TQC-5C0051
       PRINT g_dash2
#-----------------------幣別小計---------------------------------
   AFTER GROUP OF sr.nne16
      PRINT g_x[11] CLIPPED,
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.nne12),38,l_azi05), 
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.nne19),40,t_azi05) ,COLUMN g_c[42], #NO.CHI-6A0004
         GROUP SUM(sr.nne19*sr.nne13/100/1000)/1000 CLIPPED USING "######&.####"
      #PRINT l_dash[1,g_len]
      PRINT g_dash2
        LET ret = GROUP SUM(sr.nne19*sr.nne13/100/1000) / GROUP SUM(sr.nne19)
      PRINT g_x[12] CLIPPED,COLUMN g_c[35],ret using "######&.####"
      #PRINT l_dash[1,g_len]
      PRINT g_dash2
#----------------------銀行小計--------------------------------
    AFTER GROUP OF sr.nne04
      PRINT g_x[13] CLIPPED,
         COLUMN g_c[40],cl_numfor(GROUP SUM(sr.nne19),40,t_azi05), #NO.CHI-6A0004
         COLUMN g_c[42],GROUP SUM(sr.nne19*sr.nne13/100/1000)/1000 CLIPPED USING "######&.####"
      #PRINT l_dash[1,g_len]
      PRINT g_dash2
   ON LAST ROW
      PRINT g_x[14] CLIPPED,
            COLUMN g_c[40],cl_numfor(SUM(sr.nne19),40,t_azi05),COLUMN g_c[42],   #NO.CHI-6A0004
            SUM(sr.nne19*sr.nne13/100/1000)/1000 CLIPPED USING "######&.####"
     DECLARE anmr712_p0 CURSOR FOR
        SELECT * FROM r712_tmp
     FOREACH anmr712_p0 INTO sl.*
      SELECT nnn02 INTO l_nnn02 FROM nnn_file WHERE nnn01=sl.nne06
      LET ret= (sl.nne19*sl.nne13/100/1000)/(sl.nne19)
      LET l_nnn02_1=l_nnn02 CLIPPED,g_x[15]
      PRINT COLUMN g_c[32],l_nnn02_1 CLIPPED,
            COLUMN g_c[34],ret CLIPPED USING "####&.####"
     END FOREACH
 
    {  PRINT l_dash[1,g_len]
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              IF tm.wc[001,120] > ' ' THEN			# for 132
 		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              IF tm.wc[121,240] > ' ' THEN
 		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              IF tm.wc[241,300] > ' ' THEN
 		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_sum = 0
        }
#No.TQC-5C0051 start
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#No.TQC-5C0051 end
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
