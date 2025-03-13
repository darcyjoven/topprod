# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr716.4gl
# Descriptions...: 短期借款明細表R&M貸款別
# Input parameter:
# Return code....:
# Date & Author..: 99/05/07 By Iceman FOR TIPTOP 4.00
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used 
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-880114 08/08/15 By Sarah 報表增加幣別欄位,並依幣別小計
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		   	    #Print condition RECORD
            wc      STRING,                 #Where Condiction
            nne03_1 LIKE nne_file.nne03,    #No.FUN-680107 DATE    #動用日範圍
            nne03_2 LIKE nne_file.nne03,    #No.FUN-680107 DATE
            more    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1) #是否列印其它條件
           END RECORD,
       g_tot,g_tot1,g_tot2 LIKE nne_file.nne19,  #No.FUN-680107 DECIMAL(8,2)
       g_tot3              LIKE nne_file.nne19,  #MOD-880114 add
       g_ret1,g_ret2       LIKE nne_file.nne19,  #No.FUN-680107 DECIMAL(8,2)
       g_ret3              LIKE nne_file.nne19,  #MOD-880114 add
       g_nne19_1,g_nne19_2 LIKE nne_file.nne19,  #DECIMAL(12,2) #計算加總
       g_nne19_3           LIKE nne_file.nne19,  #DECIMAL(12,2) #計算加總   #MOD-880114 add
       l_dash      LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(132)
       g_opt       LIKE nnn_file.nnn02,          #No.FUN-680107 VARCHAR(40)
       g_i         LIKE type_file.num5,          #count/index for any purpose #No.FUN-680107
       g_head1     STRING
 
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
 
   LET g_pdate    = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.nne03_1 = ARG_VAL(8)
   LET tm.nne03_2 = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr716_tm()	        	# Input print condition
      ELSE CALL anmr716()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117 
END MAIN
 
FUNCTION anmr716_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01,   #No.FUN-580031
       p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE 
      LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW anmr716_w AT p_row,p_col WITH FORM "anm/42f/anmr716"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.nne03_1 = g_today
   LET tm.nne03_2 = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nne01,nne06,nne04
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr716_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.nne03_1,tm.nne03_2,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD nne03_1
	 IF cl_null(tm.nne03_1) THEN
            DISPLAY BY NAME tm.nne03_1
            NEXT FIELD nne03_1
         END IF
 
      AFTER FIELD nne03_2
	 IF cl_null(tm.nne03_2) THEN
 	    LET tm.nne03_2 = g_lastdat
	    DISPLAY BY NAME tm.nne03_2
	    NEXT FIELD nne03_2
         END IF
         IF tm.nne03_2 < tm.nne03_1 THEN
            NEXT FIELD nne03_2
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr716_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117 
   EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr716'
      IF SQLCA.SQLCODE OR cl_null(l_cmd) THEN
         CALL cl_err('anmr716','9031',1)   
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
         CALL cl_cmdat('anmr716',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr716_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr716()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr716_w
END FUNCTION
 
FUNCTION anmr716()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680107
#         l_time     LIKE type_file.chr8	        #No.FUN-6A0082
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05     LIKE type_file.chr1000,            #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order    ARRAY[2] OF LIKE type_file.chr20,  #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          l_i        LIKE type_file.num5,               #No.FUN-680107 SMALLINT
          sr         RECORD
                      nne    RECORD LIKE nne_file.*,
                      alg01  LIKE alg_file.alg01,       #No.FUN-680107 VARCHAR(10)
		      alg02  LIKE alg_file.alg02        #No.FUN-680107 VARCHAR(10)
                     END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#NO.CHI-6A0004--BEGIN
#  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
#  IF SQLCA.sqlcode THEN 
#     CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#     CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#  END IF
#NO.CHI-6A0004--END
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT nne_file.*,alg01,alg02 ",
               " FROM nne_file,OUTER alg_file ",
               " WHERE ",tm.wc CLIPPED,
	       " AND nne03 BETWEEN '",tm.nne03_1,"' AND '",tm.nne03_2,"'",
	       " AND alg_file.alg01 = nne_file.nne04 ",
	       " AND nneconf='Y'",
	       " ORDER BY nne06,nne16,nne04,nne01 "   #MOD-880114 add nne16
 
   PREPARE anmr716_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117 
      EXIT PROGRAM
   END IF
   DECLARE anmr716_curs1 CURSOR FOR anmr716_prepare1
   CALL cl_outnam('anmr716') RETURNING l_name
   START REPORT anmr716_rep TO l_name
 
   LET g_pageno = 0
   LET g_tot = 0
   LET g_tot1 = 0
   LET g_tot2 = 0
   LET g_tot3 = 0      #MOD-880114 add
   LET g_ret1 = 0
   LET g_ret2 = 0
   LET g_ret3 = 0      #MOD-880114 add
   LET g_nne19_1 = 0
   LET g_nne19_2 = 0
   LET g_nne19_3 = 0   #MOD-880114 add
 
   FOREACH anmr716_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT anmr716_rep(sr.*)
   END FOREACH
 
   FINISH REPORT anmr716_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT anmr716_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
          l_sw04    LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
	  l_date    LIKE type_file.dat,        #No.FUN-680107 DATE
	  l_azk04   LIKE azk_file.azk04,
	  l_sta     LIKE type_file.chr20,      #No.FUN-680107 VARCHAR(4)
          l_nne111  LIKE type_file.chr20,      #No.FUN-680107 VARCHAR(20)
          l_nne13   LIKE type_file.chr20,      #No.FUN-680107 VARCHAR(20)  #加權平均利率
          l_nne16   LIKE type_file.chr20,      #MOD-880114 add          #加權平均利率
          sl RECORD
             nne06  LIKE nne_file.nne06,
             nne19  LIKE nne_file.nne19
             END RECORD,
          sr RECORD
             nne    RECORD LIKE nne_file.*,
             alg01  LIKE alg_file.alg01,       #No.FUN-680107 VARCHAR(10)
             alg02  LIKE alg_file.alg02        #No.FUN-680107 VARCHAR(10)
             END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nne.nne06,sr.nne.nne16,sr.nne.nne04,sr.nne.nne01   #MOD-880114 add nne16
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      SELECT nnn02 INTO g_opt FROM nnn_file WHERE nnn01=sr.nne.nne06
      LET g_head1=g_x[16] CLIPPED,g_opt CLIPPED,'  ',sr.nne.nne06,
          #'         ',g_x[9] CLIPPED,tm.nne03_1,"-",tm.nne03_2                              #FUN-660060 remark
          COLUMN ((g_len-FGL_WIDTH(g_x[9])-18)/2)+1,g_x[9] CLIPPED,tm.nne03_1,"-",tm.nne03_2 #FUN-660060
      PRINT g_head1                                         
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED   #MOD-880114 add g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nne.nne06
      SKIP TO TOP OF PAGE
      LET g_tot1 = 0
      LET g_tot2 = 0
      LET g_tot3 = 0      #MOD-880114 add
      LET g_nne19_1 = 0
      LET g_nne19_2 = 0
      LET g_nne19_3 = 0   #MOD-880114 add
 
  #str MOD-880114 add
   BEFORE GROUP OF sr.nne.nne16   #幣別
      LET g_tot1 = 0
      LET g_tot2 = 0
      LET g_nne19_1 = 0
      LET g_nne19_2 = 0
  #end MOD-880114 add
 
   BEFORE GROUP OF sr.nne.nne04
      LET g_tot = 0
      LET g_tot1 = 0
      LET g_nne19_1 = 0
      LET l_sw04 = 'N'
 
   ON EVERY ROW
      LET g_tot = (sr.nne.nne19 * (sr.nne.nne13 / 100) ) /1000
      IF l_sw04 = 'N' THEN
         PRINT COLUMN g_c[38],sr.nne.nne16;   #MOD-880114 add
         PRINT COLUMN g_c[31],sr.alg01,
               COLUMN g_c[32],sr.alg02;
         LET l_sw04 = 'Y'
      END IF
      LET l_nne111=sr.nne.nne111,'-',sr.nne.nne112
      PRINT COLUMN g_c[33],sr.nne.nne01,
            COLUMN g_c[34],cl_numfor(sr.nne.nne19,34,g_azi04),
            COLUMN g_c[35],sr.nne.nne13 USING "####&.&&&&",  #No.TQC-5C0051
            COLUMN g_c[36],cl_numfor(g_tot,36,0),
            COLUMN g_c[37],l_nne111
      PRINT g_dash2
      LET g_tot1 = g_tot1 + g_tot
      LET g_tot2 = g_tot2 + g_tot
      LET g_tot3 = g_tot3 + g_tot   #MOD-880114 add
 
   AFTER GROUP OF sr.nne.nne04
      LET g_nne19_3 = GROUP SUM(sr.nne.nne19)
      #加權平均利率 = [ 台幣總額 * 借款利率 /100 ] / 台幣總合計
      LET g_ret3 = (g_tot3 *1000 ) / g_nne19_3
      PRINT COLUMN g_c[32],g_x[20] CLIPPED,
            COLUMN g_c[34],cl_numfor(g_nne19_3,34,g_azi05),
            COLUMN g_c[36],cl_numfor(g_tot3,36,0)
      PRINT g_dash2
      PRINT COLUMN g_c[32],g_x[10],COLUMN g_c[35],g_ret3 USING "####&.&&&&"  #No.TQC-5C0051
      PRINT g_dash2
 
  #str MOD-880114 add
   AFTER GROUP OF sr.nne.nne16   #幣別
      LET g_nne19_2 = GROUP SUM(sr.nne.nne19)
      #加權平均利率 = [ 台幣總額 * 借款利率 /100 ] / 台幣總合計
      LET g_ret2 = (g_tot2 *1000 ) / g_nne19_2
      PRINT COLUMN g_c[32],sr.nne.nne16 CLIPPED,g_x[21] CLIPPED,
            COLUMN g_c[34],cl_numfor(g_nne19_2,34,g_azi05),
            COLUMN g_c[36],cl_numfor(g_tot2,36,0)
      PRINT g_dash2
  #end MOD-880114 add
 
   AFTER GROUP OF sr.nne.nne06
      LET g_nne19_1 = GROUP SUM(sr.nne.nne19)
      PRINT COLUMN g_c[32],g_x[11] CLIPPED,
            COLUMN g_c[34],cl_numfor(g_nne19_1,34,g_azi05),
            COLUMN g_c[36],cl_numfor(g_tot1,36,0)
      PRINT " "
      LET g_ret1 = (g_tot1 *1000 ) / g_nne19_1
      #print 各融資種類加權平均利率
      LET l_nne13=g_opt CLIPPED,g_x[10]
      PRINT COLUMN g_c[32],l_nne13,COLUMN g_c[35],g_ret1 USING "####&.&&&&"
      PRINT g_dash2
 
   ON LAST ROW
      PRINT l_dash[1,g_len]
      PRINT g_x[17] CLIPPED,
            COLUMN g_c[33],g_x[18] CLIPPED,
            COLUMN g_c[36],g_x[19] CLIPPED
      IF g_zz05 = 'Y' THEN         # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash[1,g_len]
        #TQC-630166
        #IF tm.wc[001,120] > ' ' THEN			# for 132
 	#   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #IF tm.wc[121,240] > ' ' THEN
       	#   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #IF tm.wc[241,300] > ' ' THEN
        #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF
END REPORT
