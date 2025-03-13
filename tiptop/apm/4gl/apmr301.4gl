# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 請購單簽核狀況查詢
# Input parameter:
# Date & Author..: 91/10/23 By May
# Modify.........: No.MOD-530472 05/03/26 By Mandy 簽核人員欄位似apmr310 可開窗選擇
# Modify.........: No.FUN-550060  05/05/30 By yoyo單據編號格式放大
# Modify.........: No.FUN-580014  05/08/18 By wujie 雙單位報表修改，轉xml
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.FUN-660129 06/06/20 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.MOD-870161 08/07/14 By Cockroach  pmk07沒有用到，暫時隱藏
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
          #		wc   VARCHAR(1000),	# Where condition
          		wc  	STRING, 	#TQC-630166 # Where condition
                azc03   LIKE azc_file.azc03,
                a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  # 交易統計均為0者是否列印
       		x   	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  # (1)應簽未簽 (2)全部
       		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) 	# Input more condition(Y/N)
              END RECORD,
          g_azm03       LIKE type_file.num5,    #No.FUN-680136 SMALLINT  # 季別
          g_aza17       LIKE aza_file.aza17,    # 本國幣別
          g_total       LIKE oeb_file.oeb14     #No.FUN-680136 DECIMAL(20,6) 
#No.FUN-580014--begin
   #DEFINE   g_dash     LIKE type_file.chr1000  #No.FUN-680136  #Dash line
    DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
   #DEFINE   g_len      LIKE type_file.num5,    #No.FUN-680136 SMALLINT #Report width(79/132/136)
   #DEFINE   g_zz05     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #Print tm.wc ?(Y/N)
    DEFINE   g_sma115   LIKE sma_file.sma115
    DEFINE g_sma116     LIKE sma_file.sma116
#No.FUN-580014--end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
    END IF
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.azc03 = ARG_VAL(8)
   LET tm.a = ARG_VAL(9)
   LET tm.x = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r301tm(0,0)		        # Input print condition
      ELSE CALL r301()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r301tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r301w AT p_row,p_col WITH FORM "apm/42f/apmr301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.a    = 'N'
   LET tm.x    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#   CONSTRUCT BY NAME tm.wc ON pmk01,pmk07,pmkprit,pmksign     #MOD-870161 MARK
   CONSTRUCT BY NAME tm.wc ON pmk01,pmkprit,pmksign            #MOD-870161 ADD
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
      CLOSE WINDOW r301w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.a,tm.x,tm.more 		# Condition
   INPUT BY NAME tm.azc03,tm.a,tm.x,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD azc03
           IF cl_null(tm.azc03) THEN
            CALL cl_err(tm.azc03,'mfg4055',0)
              NEXT FIELD azc03 END IF
           SELECT azc03 FROM azc_file WHERE azc03 = tm.azc03
             IF SQLCA.sqlcode = 100 THEN 
#               CALL cl_err(tm.azc03,'mfg0017',g_lang)   #No.FUN-660129
             CALL cl_err3("sel","azc_file",tm.azc03,"","mfg0017","","",1)  #No.FUN-660129
              NEXT FIELD azc03
           END IF
           IF tm.azc03 IS NULL  OR tm.azc03 = '    ' THEN
                NEXT FIELD azc03
           END IF
      AFTER FIELD x      #輸入其它特殊列印條件
           IF tm.x IS NULL OR tm.x NOT MATCHES '[12]' THEN NEXT FIELD x END IF
      AFTER FIELD more      #輸入其它特殊列印條件
           IF tm.more  IS NULL  OR tm.more  NOT MATCHES '[YN]' THEN
                NEXT FIELD more
           END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER FIELD a
         IF tm.a  NOT MATCHES'[YN]' OR tm.a IS NULL  THEN
            NEXT FIELD a
         END IF
       #MOD-530472
      ON ACTION CONTROLP
         CASE WHEN INFIELD(azc03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_gen2'
              LET g_qryparam.default1 = tm.azc03
              CALL cl_create_qry() RETURNING tm.azc03
              DISPLAY BY NAME tm.azc03
              NEXT FIELD azc03
         END CASE
       #MOD-530472(end)
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
      LET INT_FLAG = 0 CLOSE WINDOW r301w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr301'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr301','9031',1)   #No.FUN-660129
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
                         " '",tm.azc03 CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.x CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr301',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r301w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r301()
   ERROR ""
END WHILE
   CLOSE WINDOW r301w
END FUNCTION
 
FUNCTION r301()
   DEFINE l_name	LIKE type_file.chr20, 	 # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,     # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE za_file.za05,       #No.FUN-680136 VARCHAR(40)
          sr              RECORD
                                  pmk01  LIKE pmk_file.pmk01,    #採購單號
                                  pmk02  LIKE pmk_file.pmk02,    #單據性質
                                  pmk09  LIKE pmk_file.pmk09,    #供應廠商
                                  pmksign LIKE pmk_file.pmksign, #簽核等級
                                  pmk22  LIKE pmk_file.pmk22,    #幣別
                                  pmk40  LIKE pmk_file.pmk40,    #總金額
                                  pmk04 LIKE pmk_file.pmk04,    
                                  pmkdays LIKE pmk_file.pmkdays,
                                  pmkprit LIKE pmk_file.pmkprit,
                                  days    LIKE type_file.num5,   #No.FUN-680136 SMALLINT
                                  pmksseq LIKE pmk_file.pmksseq, #已簽
                                  pmksmax LIKE pmk_file.pmksmax, #應簽
                                  pml02  LIKE pml_file.pml02,    #項次
                                  pml04  LIKE pml_file.pml04,    #料件編號
                                  pml041  LIKE pml_file.pml041,  #料件編號  #FUN-4C0095
                                  pml18  LIKE pml_file.pml18,    #MRP需求日
                                  pml44  LIKE pml_file.pml44,    #本幣單位
                                  pml07  LIKE pml_file.pml07,    #採購單位
                                  pml33  LIKE pml_file.pml33,    #交貨日
                                  pml34  LIKE pml_file.pml34,    #No.TQC-640132
                                  pml35  LIKE pml_file.pml35,    #No.TQC-640132
                                  pml20  LIKE pml_file.pml20,    #採購量
                                  pml80  LIKE pml_file.pml80,    #No.FUN-580014
                                  pml82  LIKE pml_file.pml82,    #No.FUN-580014
                                  pml83  LIKE pml_file.pml83,    #No.FUN-580014
                                  pml85  LIKE pml_file.pml85,    #No.FUN-580014
                                  pml86  LIKE pml_file.pml86,    #No.FUN-580014
                                  pml87  LIKE pml_file.pml87,    #No.FUN-580014
                                  azc01  LIKE azc_file.azc01     #簽核等級
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr301'     #No.FUN-580014
#No.CHI-6A0004---------Begin-------------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#       FROM azi_file                 #幣別檔小數位數讀取
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004---------End-------------
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
     #End:FUN-980030
 
	 # 1.狀況碼不等於'9''6''0'取消,結束,
     LET l_sql = " SELECT ",
                 " pmk01,pmk02,pmk09,pmksign,pmk22,pmk40,pmk04,pmkdays,",
                 " pmkprit,0,pmksseq,",
                 "  pmksmax,pml02,pml04,pml041,pml18,pml44,pml07, ", #FUN-4C0095
                 " pml33,pml34,pml35,pml20,pml80,pml82,pml83,",  #No.TQC-640132
                 " pml85,pml86,pml87,azc01 ",          #No.FUN-580014
                 " FROM pmk_file, azc_file,pml_file",
                 "  WHERE pmkmksg = 'Y' AND pmk25 not IN ('6','9') ",
                 "  AND pmk18 != 'X' AND ",tm.wc CLIPPED,
                 "  AND pmk01=pml01 AND azc03='",tm.azc03,"' AND azc01=pmksign"
     IF tm.x = '1' THEN LET l_sql = l_sql CLIPPED,
                 "  AND pmksseq != pmksmax AND azc02 > pmksseq "
     END IF
     PREPARE r301prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r301cs  CURSOR FOR r301prepare
     CALL cl_outnam('apmr301') RETURNING l_name
#No.FUN-550060-begin
#No.FUN-580014--begin
#     LET g_len = 100
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET g_zaa[55].zaa06 = "Y"
        LET g_zaa[43].zaa06 = "Y"
        LET g_zaa[46].zaa06 = "Y"
        LET g_zaa[60].zaa06 = "Y"
        LET g_zaa[54].zaa06 = "N"
        LET g_zaa[42].zaa06 = "N"
        LET g_zaa[45].zaa06 = "N"
        LET g_zaa[57].zaa06 = "N"
     ELSE
        LET g_zaa[55].zaa06 = "N"
        LET g_zaa[43].zaa06 = "N"
        LET g_zaa[46].zaa06 = "N"
        LET g_zaa[60].zaa06 = "N"
        LET g_zaa[54].zaa06 = "Y"
        LET g_zaa[42].zaa06 = "Y"
        LET g_zaa[45].zaa06 = "Y"
        LET g_zaa[57].zaa06 = "Y"
     END IF
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET g_zaa[41].zaa06 = "N"
        LET g_zaa[53].zaa06 = "N"
     ELSE
        LET g_zaa[41].zaa06 = "Y"
        LET g_zaa[53].zaa06 = "Y"
     END IF
     IF tm.a = 'Y'   THEN
            LET g_zaa[39].zaa06 = "N"
            LET g_zaa[40].zaa06 = "N"
            LET g_zaa[44].zaa06 = "N"
            LET g_zaa[47].zaa06 = "N"
            LET g_zaa[52].zaa06 = "N"
            LET g_zaa[56].zaa06 = "N"
            LET g_zaa[58].zaa06 = "N"
      ELSE
            LET g_zaa[39].zaa06 = "Y"
            LET g_zaa[40].zaa06 = "Y"
            LET g_zaa[41].zaa06 = "Y"
            LET g_zaa[42].zaa06 = "Y"
            LET g_zaa[43].zaa06 = "Y"
            LET g_zaa[44].zaa06 = "Y"
            LET g_zaa[45].zaa06 = "Y"
            LET g_zaa[46].zaa06 = "Y"
            LET g_zaa[47].zaa06 = "Y"
            LET g_zaa[52].zaa06 = "Y"
            LET g_zaa[53].zaa06 = "Y"
            LET g_zaa[54].zaa06 = "Y"
            LET g_zaa[55].zaa06 = "Y"
            LET g_zaa[56].zaa06 = "Y"
            LET g_zaa[57].zaa06 = "Y"
            LET g_zaa[58].zaa06 = "Y"
            LET g_zaa[59].zaa06 = "Y"
            LET g_zaa[60].zaa06 = "Y"
      END IF
 
      CALL cl_prt_pos_len()
#No.FUN-580014--end
#No.FUN-550060-end
     START REPORT r301rep TO l_name
     FOREACH r301cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.azc01=sr.pmksign
       IF sr.pmk01 IS NULL THEN LET sr.pmk01 = ' ' END IF
       OUTPUT TO REPORT r301rep(sr.*)
     END FOREACH
 
     FINISH REPORT r301rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r301rep(sr)
   DEFINE l_ima021    LIKE ima_file.ima021      #FUN-4C0095
   DEFINE l_last_sw   LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
          l_pmc03     LIKE pmc_file.pmc03,
          l_azd04     LIKE azd_file.azd04,      #No.FUN-680136 DATE 
          l_gen02     LIKE gen_file.gen02,
          l_sql1      LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(1000)
          l_str       LIKE zaa_file.zaa08,      #No.FUN-680136 VARCHAR(30)
          tmp              RECORD
                                  azc02 LIKE azc_file.azc02,     #順序
                                  azc03 LIKE azc_file.azc03      # 簽核人員
                           END RECORD,
          sr              RECORD
                                  pmk01  LIKE pmk_file.pmk01,    #採購單號
                                  pmk02  LIKE pmk_file.pmk02,    #單據性質
                                  pmk09  LIKE pmk_file.pmk09,    #供應廠商
                                  pmksign LIKE pmk_file.pmksign, #簽核等級
                                  pmk22  LIKE pmk_file.pmk22,    #幣別
                                  pmk40  LIKE pmk_file.pmk40,    #總金額
                                  pmk04 LIKE pmk_file.pmk04,    
                                  pmkdays LIKE pmk_file.pmkdays,
                                  pmkprit LIKE pmk_file.pmkprit,
                                  days    LIKE type_file.num5,   #No.FUN-680136 SMALLINT
                                  pmksseq LIKE pmk_file.pmksseq, #已簽
                                  pmksmax LIKE pmk_file.pmksmax, #應簽
                                  pml02  LIKE pml_file.pml02,    #項次
                                  pml04  LIKE pml_file.pml04,    #料件編號
                                  pml041  LIKE pml_file.pml041,  #料件編號  #FUN-4C0095
                                  pml18  LIKE pml_file.pml18,    #MRP需求日
                                  pml44  LIKE pml_file.pml44,    #本幣單位
                                  pml07  LIKE pml_file.pml07,    #採購單位
                                  pml33  LIKE pml_file.pml33,    #交貨日
                                  pml34  LIKE pml_file.pml34,    #No.TQC-640132
                                  pml35  LIKE pml_file.pml35,    #No.TQC-640132
                                  pml20  LIKE pml_file.pml20,    #採購量
                                  pml80  LIKE pml_file.pml80,    #No.FUN-580014
                                  pml82  LIKE pml_file.pml82,    #No.FUN-580014
                                  pml83  LIKE pml_file.pml83,    #No.FUN-580014
                                  pml85  LIKE pml_file.pml85,    #No.FUN-580014
                                  pml86  LIKE pml_file.pml86,    #No.FUN-580014
                                  pml87  LIKE pml_file.pml87,    #No.FUN-580014
                                  azc01  LIKE azc_file.azc01     #簽核等級
                        END RECORD
#No.FUN-580014--begin
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_str2         LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
  DEFINE l_pml85        STRING
  DEFINE l_pml82        STRING
  DEFINE l_pml20        STRING
  DEFINE g_cnt          LIKE type_file.num5    #No.FUN-680136 SMALLINT
#No.FUN-580014--end
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.days,sr.pmkprit,sr.pmk01
  FORMAT
   PAGE HEADER
#No.FUN-580014--begin
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET l_str = g_x[18] CLIPPED,tm.azc03
#     PRINT g_x[2] CLIPPED,g_today,'  ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                       g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                       g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
                       g_x[46],g_x[47],g_x[61]   #No.TQC-640132
      PRINTX name = H2 g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],
                       g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],
                       g_x[58],g_x[59],g_x[60],g_x[62]   #No.TQC-640132
      PRINT g_dash1
#No.FUN-550060 --start--
#     PRINT COLUMN 01,g_x[11] CLIPPED,
#           COLUMN 18,g_x[19] CLIPPED,
#           COLUMN 59,g_x[12] CLIPPED
#     PRINT COLUMN 71,g_x[13] CLIPPED
#     PRINT '---------------- -------- ---------- -------------------- ---------- ----------- ';
#     PRINT '------------------'
#No.FUN-580014--end
      LET l_last_sw = 'n'
 
BEFORE GROUP  OF sr.pmk01
         LET g_cnt = 1
#是否需顯示請購單料件的詳細資料
         IF tm.a = 'Y' THEN
              SKIP TO TOP OF PAGE
         END IF
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE sr.pmk09 = pmc01
         IF SQLCA.sqlcode THEN LET l_pmc03 = NULL END IF
       #FUN-4C0095
#No.FUN-580014--begin
         PRINTX name = D1
              COLUMN g_c[31],sr.pmk01,
              COLUMN g_c[32],sr.pmk02,
              COLUMN g_c[33],sr.pmk09,
              COLUMN g_c[34],l_pmc03,
              COLUMN g_c[35],sr.pmksign,
              COLUMN g_c[36],sr.pmk22,
              COLUMN g_c[37],cl_numfor(sr.pmk40,37,g_azi04);
       # PRINT sr.pmk01,'  ',sr.pmk02,'  ',sr.pmk09,' ',l_pmc03,'  ',
       #      sr.pmksign,'      ',sr.pmk22,'       ',
       #      cl_numfor(sr.pmk40,13,g_azi04)  CLIPPED
      LET l_last_sw = 'n'
#     IF tm.a = 'Y' THEN
#        PRINT g_dash[1,g_len] CLIPPED
#        PRINT g_x[14] CLIPPED,g_x[15] CLIPPED
#       PRINT COLUMN 27,g_x[16] CLIPPED,g_x[17] CLIPPED
#       PRINT '----- --------------------  ----  --------   ----------------  -----------------'  #FUN-4C0095
#     END IF
#No.FUN-550060 --end--
 
   ON EVERY ROW
#是否需顯示請購單料件的詳細資料
      #FUN-4C0095
      IF tm.a = 'Y' THEN
         SELECT ima021,ima906
           INTO l_ima021,l_ima906
           FROM ima_file
          WHERE ima01=sr.pml04
         IF SQLCA.sqlcode THEN
             LET l_ima021 = NULL
         END IF
         LET g_total = sr.pml20 * sr.pml44
 
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                LET l_str2 = l_pml85 , sr.pml83 CLIPPED
                IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
                    CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                    LET l_str2 = l_pml82, sr.pml80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
                      CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                      LET l_str2 = l_str2 CLIPPED,',',l_pml82, sr.pml80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
                    CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                    LET l_str2 = l_pml85 , sr.pml83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            IF sr.pml80 <> sr.pml86 THEN
               CALL cl_remove_zero(sr.pml20) RETURNING l_pml20
               LET l_str2 = l_str2 CLIPPED,"(",l_pml20,sr.pml07 CLIPPED,")"
            END IF
      END IF
         PRINTX name = D1
               COLUMN g_c[39],sr.pml02 USING '####',
               COLUMN g_c[40],sr.pml04 CLIPPED, #FUN-5B0014 [1,20],
               COLUMN g_c[41],l_str2 CLIPPED,
               COLUMN g_c[61],sr.pml34,  #No.TQC-640132
               COLUMN g_c[44],sr.pml18,
               COLUMN g_c[45],cl_numfor(sr.pml87,45,3),
               COLUMN g_c[46],cl_numfor(sr.pml20,46,3),
               COLUMN g_c[47],cl_numfor(sr.pml44,47,g_azi03)
      IF g_cnt = 1 THEN
         LET g_cnt = g_cnt + 1
        PRINTX name = D2
              COLUMN g_c[49],sr.pmksseq USING '-&' ,'/',sr.pmksmax USING "-&";
# 找出此張單據應簽已簽的所有簽核人員
         LET l_sql1 =" SELECT azc02,azc03 FROM azc_file",
                     "  WHERE '",sr.azc01,"' = azc01",
                     " ORDER BY azc02"
         PREPARE apmr310_pre1 FROM l_sql1
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
                 EXIT PROGRAM END IF
         DECLARE apmr310_cs2 CURSOR FOR apmr310_pre1
         FOREACH apmr310_cs2 INTO tmp.*
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH END IF
#找出此張單據已簽簽核人員的簽核日期
            SELECT azd04 INTO l_azd04 FROM azd_file
                    WHERE sr.pmk01 = azd01 AND
                          azd02 = 2 AND tmp.azc03 = azd03
            IF SQLCA.sqlcode THEN LET  l_azd04 = NULL END IF
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE tmp.azc03 = gen01
            IF SQLCA.sqlcode THEN LET  l_gen02 = NULL END IF
#已簽核的列印一'*'，和簽核日期
            IF sr.pmksseq < tmp.azc02 THEN
              PRINTX name = D2
                    COLUMN g_c[51],l_gen02
            END IF
#未簽核的只列印出員工名稱
            IF sr.pmksseq > tmp.azc02 OR sr.pmksseq = tmp.azc02  THEN
              PRINTX name = D2
                    COLUMN g_c[50],l_azd04,
                    COLUMN g_c[51],'*',l_gen02
            END IF
         END FOREACH
      END IF
         PRINTX name = D2
               COLUMN g_c[52],sr.pml041
         PRINTX name = D2
               COLUMN g_c[52],l_ima021
 
         PRINTX name = D2
               COLUMN g_c[54],sr.pml86,
               COLUMN g_c[55],sr.pml07,
               COLUMN g_c[56],sr.pml33,
               COLUMN g_c[62],sr.pml35,  #No.TQC-640132
               COLUMN g_c[58],cl_numfor(g_total,58,g_azi03)
#No.FUN-580014--end
      #FUN-4C0095(end)
        #PRINT sr.pml02 USING '#####',' ',sr.pml04,'  ',
        #       '       ',sr.pml18,
        #      '  ',sr.pml20 USING '---------&.&&&','  ',
        #      COLUMN 66,cl_numfor(sr.pml44,13,g_azi03) CLIPPED
        #PRINT COLUMN 29,sr.pml07,'   ',sr.pml33,'   ';
#                        sr.pml20 USING "--------&.&&&"  CLIPPED;
        #PRINT COLUMN 66,cl_numfor(g_total,13,g_azi04) CLIPPED
      END IF
         LET l_last_sw = 'n'
 ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-201,240,300
         THEN PRINT g_dash[1,g_len]
          #   IF tm.wc[001,70] > ' ' THEN			# for 80
          #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
          #   IF tm.wc[071,140] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
          #   IF tm.wc[141,210] > ' ' THEN
  	  #     PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
          #   IF tm.wc[211,280] > ' ' THEN
  	  #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
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
END REPORT
#Patch....NO.TQC-610036 <> #
