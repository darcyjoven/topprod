# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmr700.4gl
# Descriptions...: 短期綜合授信額度動用明細表列印
# Date & Author..: 99/05/28  By Kammy(因nne06改以變動方式，所以重新改寫)
# Update By Chou. 02/01/28 財務需求新增資金成本、額度期間及保證費率欄位，
#                 未動用比率改為動支比率，並於表尾加加權平均資金成本比率。
# Modify.........: Joan 020624 本幣金額=原幣 * (最近一天)銀行賣出匯率
# Modify.........: No:8780 By Kitty l_amt5取消
# Modify.........: No.FUN-4C0098 05/02/01 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定問題修改義
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980255 09/09/03 By sabrina 已動用金額不正確
# Modify.........: No.TQC-950156 10/03/04 By vealxu r700_file 的長度不夠
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.MOD-BC0298 12/01/02 By Polly l_amt0,l_amt1,l_amt2,l_amt3改抓原幣金額，調整l_amt1抓取條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		                 # Print condition RECORD
              wc    STRING,                      #Where Condiction
          #   bdate LIKE type_file.dat,          #No.FUN-680107 DATE #改為只有截止日期
              edate LIKE type_file.dat,          #No.FUN-680107 DATE
              more  LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
# Joan 020624 -----------------
#         l_dash    VARCHAR(160),
# Joan 020624 end -------------
          l_sw      LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
	  l_amt0    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6) 
	  l_amt1    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_amt2    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_amt3    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_amt4    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_amt5    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_amt6    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_nmd04_tot11    LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
	  l_nmd04_tot12    LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
	  l_nmd04_tot21    LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
	  l_nmd04_tot22    LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
	  l_tot1    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_tot2    LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_amt     LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_sum     LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
	  l_rate    LIKE type_file.num15_3,      #LIKE cqs_file.cqs32,         #No.FUN-680107 DEC(6,1)   #TQC-B90211
	  l_rate1   LIKE nne_file.nne14,         #No.FUN-680107 DEC(5,3)
          l_nne14   LIKE nne_file.nne14,         #No.FUN-680107 DEC(5,3)
          l_nne34   LIKE nne_file.nne14,         #No.FUN-680107 DEC(5,3)
          l_nne111  LIKE nne_file.nne111,        #No.FUN-680107 DATE
          l_nne112  LIKE nne_file.nne112         #No.FUN-680107 DATE
 
DEFINE   g_i        LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			    	 # Supress DEL key function
 
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
   LET tm.edate    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr700_tm()	        	# Input print condition
      ELSE CALL anmr700()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr700_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 5 LET p_col = 12
   OPEN WINDOW anmr700_w AT p_row,p_col
        WITH FORM "anm/42f/anmr700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.edate=g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nno01,nno02
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   #IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.edate,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
#        IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
 
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
       IF tm.edate IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.edate
           NEXT FIELD edate
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr700','9031',1)
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
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr700',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr700()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr700_w
END FUNCTION
 
FUNCTION anmr700()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         # 標題內容 #No.FUN-680107 VARCHAR(40)
          sr            RECORD
			   nno01    LIKE nno_file.nno01,
			   nno02    LIKE nno_file.nno02,
			   nnp03    LIKE nnp_file.nnp03,
			   nnp07    LIKE nnp_file.nnp07,
			   nnp08    LIKE nnp_file.nnp08,
			   nnp09    LIKE nnp_file.nnp09,
	                   amt      LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
	                   sum      LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
	                   rate     LIKE nnp_file.nnp09,     #No.FUN-680107 DEC(6,1)
                           l_nne14  LIKE nne_file.nne14,
                           l_nne111 LIKE nne_file.nne111,
                           l_nne112 LIKE nne_file.nne112,
                           l_nne34  LIKE nne_file.nne34,
                           l_nne19  LIKE nne_file.nne19,     ##modi 020626 sammi
                           l_nne14_19  LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) ##nne14*nne19
                           l_nne34_19  LIKE type_file.num20_6#No.FUN-680107 DEC(20,6) ##nne13*nne19
                        END RECORD
     DEFINE    l_nne14  LIKE nne_file.nne14,
               l_nne34  LIKE nne_file.nne34,
               l_nne19  LIKE nne_file.nne19,
               l_nng01  LIKE nng_file.nng01,
               l_nng22  LIKE nng_file.nng22,
             # Joan 020830 ----------------------*
               l_nng53  LIKE nng_file.nng53,
             # Joan 020830 end-------------------*
               l_nne14_19  LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) ##nne14*nne19
               l_nne34_19  LIKE type_file.num20_6     #No.FUN-680107 DEC(20,6) ##nne13*nne19
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nnouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnouser', 'nnogrup')
     #End:FUN-980030
 
     DROP TABLE r700_file
#No.FUN-680107 --start
#     CREATE TEMP TABLE r700_file(type VARCHAR(04), curr VARCHAR(05),
#                                 p09 DEC(20,6),amt DEC(20,6),
#                                 tot DEC(20,6),rate DEC(6,1),
#                                 e14_19 DEC(20,6), ##nne14*nne19
#                                 e34_19 DEC(20,6), ##nne34*nne19
#                                 e19 DEC(20,6))   ##nne19
 
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE r700_file(
    type LIKE nnn_file.nnn01,
    curr LIKE azk_file.azk01,
    p09 LIKE type_file.num20_6,
    amt LIKE type_file.num20_6,
    tot LIKE type_file.num20_6,
#    rate LIKE cqs_file.cqs32,            #No.TQC-950156
    rate   LIKE type_file.num20_6,        #No.TQC-950156
    e14_19 LIKE type_file.num20_6,
    e34_19 LIKE type_file.num20_6,
    e19 LIKE type_file.num20_6)
#No.FUN-680107 --end
   CALL cl_outnam('anmr700') RETURNING l_name
   START REPORT anmr700_rep TO l_name
   LET g_pageno = 0
   LET l_sql = "SELECT nno01,nno02,nnp03,nnp07,nnp08,nnp09,0,0,0,0,'','',0,0,0,0",
               " FROM nno_file,nnp_file",
               " WHERE nno01=nnp01",
             # Joan 020830 ---------*
               "   AND nno09 = 'N'",  # 暫停不show
             # Joan 020830 ---------*
               "   AND nnoacti='Y'",
               "   AND ",tm.wc CLIPPED
 
    PREPARE anmr700_prepare0 FROM l_sql
    DECLARE anmr700_curs0 CURSOR FOR anmr700_prepare0
    FOREACH anmr700_curs0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
# Thomas 020828 處理中長期融資
      #SELECT SUM(nng22) INTO l_amt0 FROM nng_file   #MOD-BC0298 mark
       SELECT SUM(nng20) INTO l_amt0 FROM nng_file   #MOD-BC0298 add
        WHERE nng04=sr.nno02 AND nngconf='Y'
          AND nng52=sr.nno01 AND nng24=sr.nnp03
          AND nng03 <= tm.edate
       IF cl_null(l_amt0) THEN LET l_amt0=0 END IF
# End
# Thomas 020903
# Thomas 020905
      #SELECT SUM(nne12*nneex2) INTO l_amt1 FROM nne_file        #MOD-BC0298 mark
       SELECT SUM(nne12) INTO l_amt1 FROM nne_file               #MOD-BC0298 add
        WHERE nne04=sr.nno02 AND nneconf='Y'
          AND nne30=sr.nno01 AND nne06=sr.nnp03
#         AND nne16=sr.nnp07
          # AND nne03 BETWEEN tm.bdate AND tm.edate
          AND nne03 <= tm.edate
         #AND (nne26 IS NULL OR nne26 > tm.edate)      #MOD-BC0298 mark
       IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
# 中長期
      #SELECT SUM(nnl14) INTO l_amt2 FROM nnl_file,nng_file,nnk_file    #MOD-BC0298 mark
       SELECT SUM(nnl12) INTO l_amt2 FROM nnl_file,nng_file,nnk_file    #MOD-BC0298 add
        WHERE nnl03='2' AND nnl04=nng01
          AND nng52=sr.nno01 AND nng24=sr.nnp03
          AND nnk01=nnl01 AND nnk02 <= tm.edate AND nnkconf='Y'
       IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
# End
#MOD-980255---add---start---
#   #短期融資
     #SELECT SUM(nnl14) INTO l_amt3 FROM nnl_file,nne_file,nnk_file     #MOD-BC0298 mark
      SELECT SUM(nnl12) INTO l_amt3 FROM nnl_file,nne_file,nnk_file     #MOD-BC0298 add
       WHERE nnl03='1' AND nnl04=nne01
         AND nne30=sr.nno01 AND nne06=sr.nnp03
         AND nnk01=nnl01 AND nnk02 <= tm.edate AND nnkconf='Y'
      IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
#MOD-980255---add---end---
# Thomas 020415
{
       SELECT SUM(gxc08) INTO l_amt3 FROM gxc_file
	WHERE gxc21 = sr.nno01 AND gxc22 = sr.nnp03
       IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
       SELECT sum(gxe08) INTO l_amt4 FROM gxe_file
        WHERE gxe04 <= tm.edate AND gxe01 IN (
         SELECT gxc01 FROM gxc_file
          WHERE gxc21 = sr.nno01 AND gxc22 = sr.nnp03)
       IF cl_null(l_amt4) THEN LET l_amt4=0 END IF
}
# Thomas 020905 處理開票資料ㄚ, 好複雜ㄚ.......
       SELECT SUM(nmd04) INTO l_nmd04_tot11 FROM nmd_file  # 這是短期的
        WHERE nmd05  <= tm.edate AND nmd12 ='8'
          AND nmd10 IN (
              SELECT nne01 FROM nne_file
               WHERE nne30=sr.nno01 AND nne06 = sr.nnp03
                 AND (nne26 IS NULL OR nne26 > tm.edate))
       SELECT SUM(nmd04) INTO l_nmd04_tot21 FROM nmd_file  # 這是長期的
        WHERE nmd05  <= tm.edate AND nmd12 ='8'
          AND nmd10 IN (
              SELECT nng01 FROM nng_file
               WHERE nng52=sr.nno01 AND nng24 = sr.nnp03)
       SELECT SUM(nmd04) INTO l_nmd04_tot12 # 短借的支票不要插花
         FROM nmd_file,nnf_file
           WHERE nmd05  <= tm.edate AND nmd12 ='8'
             AND nnf06 = nmd01 AND nnf08 = '1'
             AND nmd10 IN (
              SELECT nne01 FROM nne_file
               WHERE nne30=sr.nno01 AND nne06 = sr.nnp03
                 AND (nne26 IS NULL OR nne26 > tm.edate))
       SELECT SUM(nmd04) INTO l_nmd04_tot22 # FRCP的支票不要插花
         FROM nmd_file,nnf_file
           WHERE nmd05  <= tm.edate AND nmd12 ='8'
             AND nnf06 = nmd01 AND nnf08 = '1'
             AND nmd10 IN (
              SELECT nng01 FROM nng_file
               WHERE nng52=sr.nno01 AND nng24 = sr.nnp03)
       IF cl_null(l_nmd04_tot11) THEN LET l_nmd04_tot11 = 0 END IF
       IF cl_null(l_nmd04_tot12) THEN LET l_nmd04_tot12 = 0 END IF
       IF cl_null(l_nmd04_tot21) THEN LET l_nmd04_tot21 = 0 END IF
       IF cl_null(l_nmd04_tot22) THEN LET l_nmd04_tot22 = 0 END IF
# End
# 100萬外匯----> 4萬保證金
      # LET l_amt5 = (l_amt3-l_amt4)*sr.nnp08   #No:8780
       # LET sr.amt=l_amt1+l_amt2
       # LET sr.amt=l_amt0+l_amt1+l_amt2 #+ l_amt5   #No:8780
      #LET sr.amt=l_amt0+l_amt1-l_amt2 #+ l_amt5     #No:8780  #MOD-980255 mark
       LET sr.amt=l_amt0+l_amt1-l_amt2 - l_amt3                #MOD-980255 add 
                 -l_nmd04_tot11+l_nmd04_tot12
                 -l_nmd04_tot21+l_nmd04_tot22
       LET sr.sum = sr.nnp09 - sr.amt
# Joan 020830 ---------------------------------------------*
{
# Thomas 020830
       SELECT nng01,nng22 INTO l_nng01,l_nng22 FROM nng_file
        WHERE nng04=sr.nno02 AND nngconf='Y'
          AND nng52=sr.nno01 AND nng24=sr.nnp03
       IF NOT cl_null(l_nng01) THEN
          LET sr.amt = l_nng22
          LET sr.sum = 0
       ELSE
       END IF
}
# Joan 020830 end -----------------------------------------*
# End
# Update By Chou. 02/01/28 改為動支比率
#      LET sr.rate= sr.sum / sr.nnp09 * 100
       LET sr.rate= sr.amt / sr.nnp09 * 100
   # Jason 020509
       SELECT nne14 INTO sr.l_nne14
         FROM nne_file
        WHERE nne30=sr.nno01 AND nne06 = sr.nnp03 AND nneconf='Y'
       UPDATE r700_file SET p09 = p09 + sr.nnp09,
                            amt = amt + sr.amt,
                            tot = tot + sr.sum,
                            rate= rate+ sr.rate
                           #e14 = e14+sr.l_nne14 sammi
                  WHERE curr = sr.nnp07 AND type =sr.nnp03 # Jason 020430
       IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
          INSERT INTO r700_file VALUES(sr.nnp03,sr.nnp07,sr.nnp09,sr.amt,sr.sum,sr.rate,'0','0','0')
       END IF
   # ----end
   ## modi 020626 sammi
     LET l_nne19 = 0
     LET l_nne14 = 0
     LET l_nne34 = 0
     DECLARE nne_cur CURSOR FOR
       SELECT nne19,nne14,nne34 FROM nne_file
        WHERE nne30=sr.nno01 AND nne06=sr.nnp03
          AND nneconf='Y'
# Thomas 020905
          AND nne12 > nne27
# End
     FOREACH nne_cur INTO l_nne19,l_nne14,l_nne34
       LET l_nne14_19 =l_nne14*l_nne19
       LET l_nne34_19 =l_nne34*l_nne19
       UPDATE r700_file SET e14_19 = e14_19 +l_nne14_19 ,
                            e34_19 = e34_19 +l_nne34_19 ,
                            e19    = e19    + l_nne19
                  WHERE curr = sr.nnp07 AND type =sr.nnp03
       IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
         #INSERT INTO r700_file (e14_19,e34_19,e19) VALUES('0','0','0')
         # Jason 020731
          INSERT INTO r700_file (e14_19,e34_19,e19) VALUES(l_nne14_19,l_nne34_19,l_nne19)
       END IF
     END FOREACH
       SELECT SUM(nne19),SUM(nne14*nne19),SUM(nne34*nne19)
        INTO sr.l_nne19,sr.l_nne14_19,sr.l_nne34_19 FROM nne_file
        WHERE nne04=sr.nno02 AND nneconf='Y'
          AND nne30=sr.nno01 AND nne06=sr.nnp03
          AND nne12 > nne27
   ## end 020626
       OUTPUT TO REPORT anmr700_rep(sr.*)
    END FOREACH
     FINISH REPORT anmr700_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT anmr700_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
	  l_alg		RECORD  LIKE alg_file.*,
          l_nnn02   LIKE nnn_file.nnn02,
          l_azk04   LIKE azk_file.azk04,
          sr            RECORD
			   nno01    LIKE nno_file.nno01,
			   nno02    LIKE nno_file.nno02,
			   nnp03    LIKE nnp_file.nnp03,
			   nnp07    LIKE nnp_file.nnp07,
			   nnp08    LIKE nnp_file.nnp08,
			   nnp09    LIKE nnp_file.nnp09,
	                   amt      LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
	                   sum      LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
	                   rate     LIKE nnp_file.nnp09,   #No.FUN-680107 DEC(6,1)
                           l_nne14  LIKE nne_file.nne14,   ##還款利率
                           l_nne111 LIKE nne_file.nne111,
                           l_nne112 LIKE nne_file.nne112,
                           l_nne34  LIKE nne_file.nne34,   ##保證金率
                           l_nne19  LIKE nne_file.nne19,   ##本幣融資金額
                        l_nne14_19  LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) ##nne14*nne19
                        l_nne34_19  LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6) ##nne13*nne19
                        END RECORD
 DEFINE    l_type  LIKE nnn_file.nnn01,       #No.FUN-680107 VARCHAR(4)
           l_type1 LIKE type_file.chr20,      #No.FUN-680107 VARCHAR(20)
           l_curr  LIKE azk_file.azk01,       #No.FUN-680107 VARCHAR(5)
           l_amt   LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
#           l_azi04 LIKE azi_file.azi04,      #NO.CHI-6A0004
           t_azi04 LIKE azi_file.azi04,
           l_tot   LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
           l_p09   LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
        l_t_rate   LIKE type_file.num15_3,    #LIKE cqs_file.cqs32,       #No.FUN-680107 DEC(6,1)   #TQC-B90211
        l_sum_rate LIKE type_file.num15_3,    #LIKE cqs_file.cqs32,       #No.FUN-680107 DEC(6,1)   #TQC-B90211
          #l_e14   DEC(5,3),
       l_nne14_19  LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) ##nne14*nne19
       l_nne34_19  LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) ##nne13*nne19
       l_nne19     LIKE nne_file.nne19,       ##本幣融資金額
       l_rate2     LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) ##資金成本
       l_rate3     LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) ##保證費率
       l_p09_total LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
       l_amt_total LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
       l_tot_total LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
    l_t_rate_total LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
  l_nne14_19_total LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
     l_nne19_total LIKE type_file.num20_6     #No.FUN-680107 DEC(20,6)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.nno02,sr.nno01,sr.nnp03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[09] CLIPPED,' ',tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED
      PRINT g_dash1
 
   BEFORE GROUP OF sr.nno02
      SELECT * INTO l_alg.* FROM alg_file WHERE alg01=sr.nno02
      PRINT COLUMN g_c[31],sr.nno02,
            COLUMN g_c[32],l_alg.alg021[1,20];
 
   BEFORE GROUP OF sr.nno01
      PRINT COLUMN g_c[33],sr.nno01;
 
      LET  l_rate2    = 0
      LET  l_rate3    = 0
      LET  l_nne14_19 = 0
      LET  l_nne34_19 = 0
 
   ON EVERY ROW
      INITIALIZE l_nne14,l_nne34,l_nne111,l_nne112,l_azk04 TO NULL
      SELECT nnn02 INTO l_nnn02 FROM nnn_file WHERE nnn01=sr.nnp03
# Update By Chou. 2002/01/28 新增挑選欄位
      #SELECT nne14,nne34,nne111,nne112
       SELECT nne14,nne34
              INTO l_nne14,l_nne34
              FROM nne_file
        WHERE nne30=sr.nno01 AND nne06 = sr.nnp03 AND nneconf='Y'
    # Jason 020509
       SELECT nno04,nno05 INTO l_nne111,l_nne112 FROM nno_file
       WHERE nno01= sr.nno01
    #--end
      IF NOT SQLCA.sqlcode THEN
         LET l_tot1 = l_tot1 + (sr.nnp09 * l_nne14)
         LET l_tot2 = l_tot2 + sr.nnp09
      END IF
# Update End.
   ## modi 02062
# Joan 020624 select 本幣金額=原幣 * (最近一天)銀行賣出匯率----------------
{
   # Jason 020621
      SELECT azk04 INTO l_azk04 FROM azk_file
      WHERE azk01= sr.nnp07 AND azk02 = g_today
   #-----end
}
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= sr.nnp07
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= sr.nnp07)
# Joan 020624 end---------------------------------------------------------
   ##modi 020626 sammi
     # SELECT e14_19,e34_19,e19
     #    INTO l_nne14_19,l_nne34_19,l_nne19  FROM r700_file
     #  WHERE curr = sr.nnp07 AND type =sr.nnp03
     #{
     # IF cl_null(sr.l_nne14) THEN LET sr.l_nne14= 0 END IF
     # IF cl_null(sr.l_nne34) THEN LET sr.l_nne34= 0 END IF
     # IF cl_null(sr.l_nne19) THEN LET sr.l_nne19= 0 END IF
     #}
      LET  l_rate2 = sr.l_nne14_19 / sr.l_nne19
      LET  l_rate3 = sr.l_nne34_19 / sr.l_nne19
      IF cl_null(l_rate2) THEN LET l_rate2= 0 END IF
      IF cl_null(l_rate3) THEN LET l_rate3= 0 END IF
   ## end 020626
    # Jason 020731
      IF sr.nnp07 = g_aza.aza17 THEN LET  l_azk04 = 1  END IF
{---榮成寫死...
      IF sr.nnp03[1]='L' OR sr.nnp03 ='C2' THEN
         LET sr.rate =100
    # Joan 020830 ------------*
         LET sr.sum = 0
         SELECT nng53 INTO l_rate2
             FROM nng_file
             WHERE nng52=sr.nno01
             AND nng24= sr.nnp03
    # Joan 020830 end---------*
      END IF
------}
    # Joan 020830 ------------*
      IF sr.amt = 0 THEN   # 當動支=0 ,資金成本率 = 0
         LET l_rate2 = 0
      END IF
    # Joan 020830 end---------*
    #---end
# Thomas 020903
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = sr.nnp07
            IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
      LET l_type1=sr.nnp03,' ',l_nnn02
      PRINT COLUMN g_c[34],l_type1,
            COLUMN g_c[35],sr.nnp07,
            COLUMN g_c[36],cl_numfor(sr.nnp09,36,t_azi04),
            COLUMN g_c[37],cl_numfor(sr.nnp09*l_azk04,37,g_azi04),
            COLUMN g_c[38],cl_numfor(sr.amt,38,t_azi04),
            COLUMN g_c[39],cl_numfor(sr.amt*l_azk04,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.sum,40,g_azi04),
            COLUMN g_c[41],cl_numfor(sr.sum*l_azk04,41,g_azi04),
            COLUMN g_c[42], sr.rate ,
            COLUMN g_c[43],l_rate2 USING '##&.##&',
            COLUMN g_c[44],l_nne111,
            COLUMN g_c[45],l_nne112
 
   AFTER GROUP OF sr.nno02
      PRINT
 
   ON LAST ROW
{---榮成個案....先都不要印好了 by kitty
      LET l_sum_rate = SUM(sr.rate)
      LET l_rate1 = l_tot1 / l_tot2
     #PRINT ''
     #PRINT COLUMN 105,g_x[19] CLIPPED, l_rate1 , '%'
      DECLARE r700_cur CURSOR FOR
      SELECT type,curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      GROUP BY type,curr  ORDER BY type
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
      FOREACH r700_cur
             INTO l_type,l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
      SELECT nnn02 INTO l_nnn02 FROM nnn_file WHERE nnn01=l_type
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
# Thomas 020912 搞錯了吧
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET  l_rate2 = l_nne14_19 / l_nne19
      LET  l_rate3 = l_nne34_19 / l_nne19
      IF cl_null(l_rate2) THEN LET l_rate2 = 0 END IF
      IF cl_null(l_rate3) THEN LET l_rate3 = 0 END IF
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_curr
         LET l_type1=l_type,'   ',l_nnn02
         PRINT COLUMN g_c[34],l_type1
               COLUMN g_c[35],l_curr,
               COLUMN g_c[36],cl_numfor(l_p09,36,t_azi04),
               COLUMN g_c[37],cl_numfor(l_p09*l_azk04,37,g_azi04),
               COLUMN g_c[38],cl_numfor(l_amt,38,t_azi04),
               COLUMN g_c[39],cl_numfor(l_amt*l_azk04,39,g_azi04),
               COLUMN g_c[40],cl_numfor(l_tot,40,t_azi04),
               COLUMN g_c[41],cl_numfor(l_tot*l_azk04,41,g_azi04),
               COLUMN g_c[42],l_t_rate/l_sum_rate*100 USING '####&.&&',
               COLUMN g_c[43],l_rate2 USING '##&.##&',
             # COLUMN 213,l_rate3 USING '##&.##&','%'
      END FOREACH
      PRINT
      DECLARE r700_cur1 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      WHERE type ='C1' OR type ='S2'
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur1
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
# Thomas 020912 搞錯了吧
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      #---- 02/11/20 因個案寫死'NTD',故幣別取位也按'NTD'
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01='NTD'  #NO.CHI-6A0004
      PRINT COLUMN ,'短借合計(C1+S2):',
            COLUMN ,'NTD',
            COLUMN ,cl_numfor(l_p09_total,,t_azi04),  #NO.CHI-6A0004
            COLUMN ,cl_numfor(l_amt_total,,t_azi04),  #NO.CHI-6A0004
            COLUMN ,cl_numfor(l_tot_total,,t_azi04),  #NO.CHI-6A0004
            COLUMN ,l_t_rate_total/l_sum_rate*100 USING '####&.&&',
            COLUMN ,l_nne14_19_total/l_nne19_total USING '##&.##&',
      DECLARE r700_cur2 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      WHERE type ='C2' OR type ='L1' OR type ='L2'
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur2
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
# Thomas 020912 搞錯了吧
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      PRINT COLUMN 33,'長借合計(C2+L1+L2):',
            COLUMN 60,'NTD',
            COLUMN  87,cl_numfor(l_p09_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 129,cl_numfor(l_amt_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 171,cl_numfor(l_tot_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 192,l_t_rate_total/l_sum_rate*100 USING '####&.&&','%',
            COLUMN 203,l_nne14_19_total/l_nne19_total USING '##&.##&','%'
 
      DECLARE r700_cur3 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      WHERE type ='U1'
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur3
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
# Thomas 020912 搞錯了吧
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      PRINT COLUMN 33,'USANCE L/C(U1):',
            COLUMN 60,'NTD',
            COLUMN  87,cl_numfor(l_p09_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 129,cl_numfor(l_amt_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 171,cl_numfor(l_tot_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 192,l_t_rate_total/l_sum_rate*100 USING '####&.&&','%',
            COLUMN 203,l_nne14_19_total/l_nne19_total USING '##&.##&','%'
 
      DECLARE r700_cur4 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      WHERE type ='S8'
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur4
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
# Thomas 020912 搞錯了吧
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      PRINT COLUMN 33,'出口押匯(S8):',
            COLUMN 60,'NTD',
            COLUMN  87,cl_numfor(l_p09_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 129,cl_numfor(l_amt_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 171,cl_numfor(l_tot_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 192,l_t_rate_total/l_sum_rate*100 USING '####&.&&','%',
            COLUMN 203,l_nne14_19_total/l_nne19_total USING '##&.##&','%'
      DECLARE r700_cur5 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      WHERE type ='S6'
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur5
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      PRINT COLUMN 33,'遠期外匯(S6):',
            COLUMN 60,'NTD',
            COLUMN  87,cl_numfor(l_p09_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 129,cl_numfor(l_amt_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 171,cl_numfor(l_tot_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 192,l_t_rate_total/l_sum_rate*100 USING '####&.&&','%',
            COLUMN 203,l_nne14_19_total/l_nne19_total USING '##&.##&','%'
      DECLARE r700_cur6 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      WHERE type ='S1' OR type ='L3'
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur6
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      PRINT COLUMN 33,'履約保證(S1+L3):',
            COLUMN 60,'NTD',
            COLUMN  87,cl_numfor(l_p09_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 129,cl_numfor(l_amt_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 171,cl_numfor(l_tot_total,17,t_azi04), #NO.CHI-6A0004
            COLUMN 192,l_t_rate_total/l_sum_rate*100 USING '####&.&&','%',
            COLUMN 203,l_nne14_19_total/l_nne19_total USING '##&.##&','%'
      DECLARE r700_cur7 CURSOR FOR
      SELECT curr,SUM(amt),SUM(tot),SUM(p09),SUM(rate),
             SUM(e14_19),SUM(e34_19),SUM(e19) ##modi 020626 sammi
      FROM r700_file
      GROUP BY curr
      LET l_amt=0
      LET l_sum=0
      LET l_p09=0
      LET l_rate2 = 0 ##modi 020626 sammi
      LET l_rate3 = 0 ##modi 020626 sammi
# Thomas 020913
      LET l_p09_total = 0
      LET l_amt_total = 0
      LET l_tot_total = 0
      LET l_t_rate_total = 0
      LET l_nne14_19_total = 0
      LET l_nne19_total = 0
      FOREACH r700_cur7
             INTO l_curr,l_amt,l_tot,l_p09,l_t_rate,
                  l_nne14_19,l_nne34_19,l_nne19  ##modi 020626 sammi
    # Jason 020731
      SELECT azk04 INTO l_azk04
          FROM azk_file
          WHERE azk01= l_curr
          AND azk02 = ( SELECT MAX(azk02) FROM azk_file WHERE azk01= l_curr)
# Thomas 020912 搞錯了吧
      IF STATUS THEN LET l_azk04 = 1 END IF
      LET l_p09_total = l_p09_total + l_p09 *l_azk04
      LET l_amt_total = l_amt_total + l_amt *l_azk04
      LET l_tot_total = l_tot_total + l_tot *l_azk04
      LET l_t_rate_total    = l_t_rate_total + l_t_rate
      LET l_nne14_19_total = l_nne14_19_total + l_nne14_19
      LET l_nne19_total = l_nne19_total + l_nne19
      END FOREACH
      PRINT COLUMN 33,g_x[18] CLIPPED,
            COLUMN 87,cl_numfor(SUM(l_p09),17,t_azi04),   #NO.CHI-6A0004
            COLUMN 129,cl_numfor(SUM(l_amt),17,t_azi04),  #NO.CHI-6A0004
            COLUMN 171,cl_numfor(SUM(l_tot),17,t_azi04),  #NO.CHI-6A0004
            COLUMN 192,SUM(l_t_rate)/SUM(l_sum_rate)*100 USING '####&.&&','%',
            COLUMN 203,SUM(l_nne14_19)/SUM(l_nne19) USING '##&.##&','%'
  }
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              #TQC-630166
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 		# PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
 		# PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
 		# PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
                #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
    # LET l_sum = 0
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
