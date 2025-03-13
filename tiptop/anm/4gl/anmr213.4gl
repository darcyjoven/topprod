# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr213.4gl
# Descriptions...: 總帳別應收票據明細表列表作業
# Input parameter:
# Return code....:
# Modify.........: 94/06/02 By Pin 排列順序
#                : 96/06/13 By Lynn   託貼銀行(nmh21)取6碼
# Modify.........: No.FUN-4C0098 04/12/27 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm   RECORD	
		  wc  	STRING,                #TQC-630166
   		s    	LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
   		t    	LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
   		u    	LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
   		dat	  LIKE type_file.dat,    #No.FUN-680107 DATE
		more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
            END RECORD,
  l_orderA  ARRAY[2] OF LIKE zaa_file.zaa08, #No.FUN-680107 ARRAY[2] OF VARCHAR(8)
  g_tot_bal LIKE type_file.num20_6,#No.FUN-680107	DEC(13,2)	
	m_cnt_tot LIKE type_file.num5,   #No.FUN-680107 SMALLINT
  l_dash	  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(180)
 
DEFINE   g_i      LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1  STRING
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
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.dat  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
 
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107-- start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt   DEC(20,6),                   #票面金額
#    order1  VARCHAR(20),
#    order2  VARCHAR(20)
#    );
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE nmh_file.nmh01,
     order2 LIKE nmh_file.nmh01);
#No.FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr213_tm(0,0)		# Input print condition
      ELSE CALL anmr213()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr213_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,     #No.FUN-680107 SMALLINT
          l_cmd       LIKE type_file.chr1000,  #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_jmp_flag  LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
   LET p_row = 5 LET p_col = 14
   OPEN WINDOW anmr213_w AT p_row,p_col
        WITH FORM "anm/42f/anmr213"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.dat  = g_today
   LET tm.s    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh21,nmh11,nmh10,nmh29,nmh01
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr213_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.dat,
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     AFTER FIELD dat
        IF cl_null(tm.dat) THEN NEXT FIELD dat END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#     ON ACTION CONTROLP CALL anmr213_wc()   # Input detail Where Condition
   AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1,tm2.u2
      LET l_jmp_flag = 'N'
      IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr213_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr213'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr213','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.dat CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr213',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr213_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr213()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr213_w
END FUNCTION
 
FUNCTION anmr213()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr		LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE nmh_file.nmh01,            #No.FUN-680107 ARRAY[5] OF VARCHAR(10)
          l_nmi06 LIKE nmi_file.nmi06,
          l_nmi03 LIKE nmi_file.nmi03,
          sr               RECORD order1 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
                                  order2 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
                                  nmh04 LIKE nmh_file.nmh04,	#
                                  nmh05 LIKE nmh_file.nmh05,
                                  nmh08 LIKE nmh_file.nmh08,
                                  nmh09 LIKE nmh_file.nmh09,
                                  nmh01 LIKE nmh_file.nmh01,
                                  nmh10 LIKE nmh_file.nmh10,
                                  nmh03 LIKE nmh_file.nmh03,
                                  nmh02 LIKE nmh_file.nmh02,
                                  nmh17 LIKE nmh_file.nmh17,
                                  nmh21 LIKE nmh_file.nmh21,
                                  nmh11 LIKE nmh_file.nmh11,
                                  nmh30 LIKE nmh_file.nmh30,
                                  nmh12 LIKE nmh_file.nmh12,
                                  nmh24 LIKE nmh_file.nmh24,
                                  nmh25 LIKE nmh_file.nmh25,
                                  nmh31 LIKE nmh_file.nmh31,
                                  nmh29 LIKE nmh_file.nmh29,
                                  nmh19 LIKE nmh_file.nmh19,
                                  nmh20 LIKE nmh_file.nmh20,
                                  nmh33 LIKE nmh_file.nmh33,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  gen02 LIKE gen_file.gen02
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
     #End:FUN-980030
 
 
     #no.5195   (針對幣別加總)
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
               "  WHERE order1=? ",
               "  GROUP BY curr"
     PREPARE tmp1_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
               "  WHERE order1=? ",
               "    AND order2=? ",
               "  GROUP BY curr  "
     PREPARE tmp2_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
               "  GROUP BY curr  "
     PREPARE tmp3_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp3_cs CURSOR FOR tmp3_pre
     #no.5195(end)
 
     LET l_sql = "SELECT '','',",
                 "       nmh04, nmh05, nmh08, nmh09, nmh01, nmh10,",
                 "       nmh03, nmh02, nmh17, nmh21, nmh11, nmh30, nmh12,",
                 "       nmh24, nmh25, nmh31, nmh29, nmh19, nmh20,",
                 "       nmh33, azi04, azi05, gen02",
                 "  FROM nmh_file, OUTER gen_file, azi_file",
                 " WHERE nmh_file.nmh16 = gen_file.gen01",
                 "   AND nmh03 = azi_file.azi01",
                 "   AND nmh38 <> 'X' ",
                 "   AND ",tm.wc CLIPPED,
                 "   AND nmh04 <= '",tm.dat,"'",
                 "   AND (nmh35 IS NULL OR nmh35 > '",tm.dat,"')"
     PREPARE anmr213_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
		CALL cl_err('prepare:',SQLCA.sqlcode,1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
		EXIT PROGRAM
	 END IF
     DECLARE anmr213_curs1 CURSOR FOR anmr213_prepare1
 
#    LET l_name = 'anmr213.out'
     CALL cl_outnam('anmr213') RETURNING l_name
     START REPORT anmr213_rep TO l_name
 
     LET g_pageno = 0
	 LET m_cnt_tot = 0
     FOREACH anmr213_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
	   IF sr.nmh24 MATCHES "[567]" AND sr.nmh25 <= tm.dat THEN
	      CONTINUE FOREACH
	   END IF
	   IF sr.nmh19 MATCHES "[34]" AND sr.nmh20 <= tm.dat THEN
	      CONTINUE FOREACH
	   END IF
           #No.B562 010519 add by linda 讀取截止日目前票況
	   IF sr.nmh24 MATCHES "[678]" THEN
              DECLARE nmi_cus CURSOR FOR
                 SELECT nmi03,nmi06
                   FROM nmi_file
                  WHERE nmi01=sr.nmh01
                    AND nmi02 <= tm.dat
                   ORDER BY nmi03 DESC
              FOREACH nmi_cus INTO l_nmi03,l_nmi06
                  LET sr.nmh24=l_nmi06
                  EXIT FOREACH
              END FOREACH
           END IF
           #No.B562 010519 end---
# 處理排列順序於列印時所需控制
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nmh21
                                        LET l_orderA[g_i] = g_x[20] clipped
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nmh11
                                        LET l_orderA[g_i] = g_x[16] clipped
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.nmh10
                                        LET l_orderA[g_i] = g_x[24] clipped
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nmh29
                                        LET l_orderA[g_i] = g_x[25] clipped
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.nmh01
                                        LET l_orderA[g_i] = g_x[26] clipped
               OTHERWISE LET l_order[g_i] = '-'
                         LET l_orderA[g_i] = ' '
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
       IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
       OUTPUT TO REPORT anmr213_rep(sr.*)
     END FOREACH
 
     FINISH REPORT anmr213_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT anmr213_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,                      #No.FUN-680107 VARCHAR(1)
          l_nmh24   LIKE nmh_file.nmh24,                      #No.FUN-680107 VARCHAR(8)
	  l_cnt1    LIKE type_file.num5,                      #合計票據張數 order1 #No.FUN-680107 SMALLINT
	  l_cnt2    LIKE type_file.num5,                      #合計票據張數 order2 #No.FUN-680107 SMALLINT
          l_nma02   LIKE nma_file.nma02,                      #銀行簡稱
          l_nmh05   LIKE type_file.chr20,                     #No.FUN-680107 VARCHAR(18) #到期日
          sr               RECORD order1 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
                                  order2 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
                                  nmh04 LIKE nmh_file.nmh04,  #
                                  nmh05 LIKE nmh_file.nmh05,
                                  nmh08 LIKE nmh_file.nmh08,  #
                                  nmh09 LIKE nmh_file.nmh09,
                                  nmh01 LIKE nmh_file.nmh01,
                                  nmh10 LIKE nmh_file.nmh10,
                                  nmh03 LIKE nmh_file.nmh03,
                                  nmh02 LIKE nmh_file.nmh02,
                                  nmh17 LIKE nmh_file.nmh17,
                                  nmh21 LIKE nmh_file.nmh21,
                                  nmh11 LIKE nmh_file.nmh11,
                                  nmh30 LIKE nmh_file.nmh30,
                                  nmh12 LIKE nmh_file.nmh12,
                                  nmh24 LIKE nmh_file.nmh24,
                                  nmh25 LIKE nmh_file.nmh25,
                                  nmh31 LIKE nmh_file.nmh31,
                                  nmh29 LIKE nmh_file.nmh29,
                                  nmh19 LIKE nmh_file.nmh19,
                                  nmh20 LIKE nmh_file.nmh20,
                                  nmh33 LIKE nmh_file.nmh33,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  gen02 LIKE gen_file.gen02
                        END RECORD,
          sr1           RECORD
                           curr   LIKE azi_file.azi01,  #No.FUN-680107 VARCHAR(4)
                           amt    LIKE type_file.num20_6#No.FUN-680107 DEC(20,6)
                        END RECORD,
	        l_amt		  LIKE ade_file.ade05,  #No.FUN-680107 DEC(15,3)
                l_chr		  LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.order1,sr.order2,sr.nmh04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_head CLIPPED,pageno_total
{*4}
      LET g_head1=g_x[12] CLIPPED, l_orderA[1] CLIPPED,'-',
            l_orderA[2] CLIPPED
      PRINT g_head1
{}
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
 
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmh21
      LET l_nmh05=sr.nmh05 CLIPPED,'(+',sr.nmh08 USING "&",')'
      CALL s_nmhsta(sr.nmh24) RETURNING l_nmh24
      LET l_nmh24=sr.nmh24,l_nmh24
 
      PRINT COLUMN g_c[31],sr.nmh04,
            COLUMN g_c[32],l_nmh05,
            COLUMN g_c[33],sr.nmh09,
            COLUMN g_c[34],sr.nmh01,
            COLUMN g_c[35],sr.nmh10,
            COLUMN g_c[36],sr.nmh03,
            COLUMN g_c[37],cl_numfor(sr.nmh02,37,sr.azi04) CLIPPED,
            COLUMN g_c[38],sr.gen02,
            COLUMN g_c[39],cl_numfor(sr.nmh17,39,sr.azi04),
            COLUMN g_c[40],sr.nmh11[1,8],
            COLUMN g_c[41],sr.nmh30[1,9],
            COLUMN g_c[42],sr.nmh12,
            COLUMN g_c[43],sr.nmh21[1,6],
            COLUMN g_c[44],l_nma02,
            COLUMN g_c[45],l_nmh24,
            COLUMN g_c[46],sr.nmh31
      LET l_cnt1 = l_cnt1 + 1
      LET l_cnt2 = l_cnt2 + 1
      LET m_cnt_tot = m_cnt_tot + 1
      #no.5195
      INSERT INTO curr_tmp VALUES(sr.nmh03,sr.nmh02,sr.order1,sr.order2)
      #no.5195(end)
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.nmh02)
         PRINT " "
{*}      PRINT COLUMN g_c[31],l_orderA[1],
		COLUMN g_c[32],g_x[10] CLIPPED,COLUMN g_c[33],l_cnt1," ",g_x[9] CLIPPED;
         #no.5195
         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file      #NO.CHI-6A0004
              WHERE azi01 = sr1.curr
             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED #NO.CHI-6A0004
         END FOREACH
         #no.5195(end)
 
         #PRINT l_dash[1,g_len]
         PRINT g_dash2
         LET l_cnt1 = 0
      ELSE IF tm.t[1,1] = 'Y'
              THEN  PRINT g_dash2 #PRINT l_dash[1,g_len]
 
              PRINT COLUMN (g_len-29),l_orderA[1],"  ",
                    sr.order1, g_x[22] CLIPPED
           END IF
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.nmh02)
         SKIP 1 LINE
{*}      PRINT COLUMN g_c[31],l_orderA[2],
		COLUMN g_c[32],g_x[10] CLIPPED,COLUMN g_c[33],l_cnt2," ", g_x[9] CLIPPED;
         #no.5195
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004 
              WHERE azi01 = sr1.curr
             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED  #NO.CHI-6A0004 
         END FOREACH
         #no.5195(end)
         LET l_cnt2 = 0
      ELSE IF tm.t[2,2] = 'Y'
              THEN  PRINT g_dash2  #PRINT l_dash[1,g_len]
              PRINT COLUMN (g_len-29),l_orderA[2],"  ",
                    sr.order2, g_x[22] CLIPPED
           END IF
      END IF
 
   ON LAST ROW
      LET l_amt = SUM(sr.nmh02)
      PRINT
      PRINT COLUMN g_c[32],g_x[11] CLIPPED,
		COLUMN	g_c[33], m_cnt_tot USING '####&',' ',g_x[23] CLIPPED
      #no.5195
      FOREACH tmp3_cs INTO sr1.*
          SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
           WHERE azi01 = sr1.curr
          PRINT COLUMN g_c[36],sr1.curr CLIPPED,
                COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED  #NO.CHI-6A0004 
      END FOREACH
      #no.5195(end)
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'nmh04,nmh05,nmh09,nmh11,nmh01,nmh10,nmh17')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
              #TQC-630166 Start
              #IF tm.wc[001,120] > ' ' THEN			# for 132
              #  PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
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
