# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr300.4gl
# Desc/riptions...: 請購單簽核列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/19 By MAY
# Modify.........: No.FUN-4C0095 04/12/30 By Mandy 報表轉XML
# Modify.........: No.FUN-580004 05/08/03 By jackie 雙單位報表修改
# Modify.........: No.MOD-590019 05/09/02 By Kevin 簽核人員開窗改成q_gen2
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 最後一頁頁次錯誤
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.FUN-660129 06/06/20 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.MOD-870161 08/07/14 By Cockroach  pmk07沒有用到，暫時隱藏  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5     #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD				# Print condition RECORD
         	#	wc   VARCHAR(500),      # Where condition
         		wc  	STRING,		# TQC-630166 # Where condition
         		azc03 	LIKE azc_file.azc03,
   				x   	LIKE type_file.chr1,  	#No.FUN-680136 VARCHAR(1)  # (1)應簽未簽 (2)全部
   				more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  # Input more condition(Y/N)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,    # 本國幣別
          g_total        LIKE oeb_file.oeb14     #No.FUN-680136 DECIMAL(20,6)  #FUN-4C0095
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
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
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.azc03= ARG_VAL(8)
   LET tm.x= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL apmr300_tm(0,0)		# Input print condition
      ELSE CALL apmr300()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW apmr300_w AT p_row,p_col WITH FORM "apm/42f/apmr300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.x = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#   CONSTRUCT BY NAME tm.wc ON pmk01,pmk07,pmksign       #MOD-870161 MARK
   CONSTRUCT BY NAME tm.wc ON pmk01,pmksign              #MOD-870161 ADD 
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.azc03,tm.x,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD azc03
           IF tm.azc03 IS NULL OR tm.azc03 = '    ' THEN
                CALL cl_err('','mfg2726',0)
                NEXT FIELD azc03
           END IF
           SELECT azc03  FROM azc_file WHERE azc03 = tm.azc03
           IF SQLCA.sqlcode = 100 THEN
#             CALL cl_err(tm.azc03,'mfg0017',g_lang)   #No.FUN-660129
              CALL cl_err3("sel","azc_file",tm.azc03,"","mfg0017","","",1)  #No.FUN-660129
              NEXT FIELD azc03
           END IF
      AFTER FIELD x
           IF tm.x IS NULL OR tm.x NOT MATCHES '[12]' THEN NEXT FIELD x END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL  THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
        #FUN-4C0095----
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(azc03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen2" #No.MOD-590019
                     LET g_qryparam.default1 = tm.azc03
                     CALL cl_create_qry() RETURNING tm.azc03
                     DISPLAY BY NAME tm.azc03
                     NEXT FIELD azc03
                OTHERWISE
                    EXIT CASE
            END CASE
        #FUN-4C0095(end)
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr300','9031',1)   #No.FUN-660129
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
                         " '",tm.x CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr300',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr300()
   ERROR ""
END WHILE
   CLOSE WINDOW apmr300_w
END FUNCTION
 
FUNCTION apmr300()
   DEFINE l_name	LIKE type_file.chr20,    # External(Disk) file name      #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	 # Used time for running the job #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	 # RDSQL STATEMENT               #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE za_file.za05,       #No.FUN-680136 VARCHAR(40)
          i             LIKE type_file.num5,     #No.FUN-580004                  #No.FUN-680136 SMALLINT
          sr               RECORD
                                  pmk01 LIKE pmk_file.pmk01,	# 單號
                                  pmk07 LIKE pmk_file.pmk07, 	# 單號類別範圍
                                  pmksign LIKE pmk_file.pmksign,# 簽核等級範圍
                                  pmk02 LIKE pmk_file.pmk02,    # 單據性質
                                  pmk09 LIKE pmk_file.pmk09,    # 供應商編號
                                  pmk22 LIKE pmk_file.pmk22,    # 幣別
                                  pmk40 LIKE pmk_file.pmk40,    # 總金額
                                  pmk04 LIKE pmk_file.pmk04,    #
                                  pmkdays LIKE pmk_file.pmkdays,
                                  pmkprit LIKE pmk_file.pmkprit,
                                  days    LIKE type_file.num5,  # No.FUN-680136 SMALLINT
                                  pmksseq LIKE pmk_file.pmksseq,# 已簽核順序
                                  pmksmax LIKE pmk_file.pmksmax,# 應簽核順序
                                  pml02 LIKE pml_file.pml02,    # 項次
                                  pml04 LIKE pml_file.pml04,    # 料件編號
                                  pml041 LIKE pml_file.pml041,  #品名規格 #FUN-4C0095
                                  pml18 LIKE pml_file.pml18,    # MRP需求日
                                  pml31 LIKE pml_file.pml31,    # MRP需求量
                                  pml44 LIKE pml_file.pml44,    # 本幣單價
                                  pml07 LIKE pml_file.pml07,    # 單位
                                  pml33 LIKE pml_file.pml33,    # 交貨日
                                  pml34 LIKE pml_file.pml34,    #No.TQC-640132
                                  pml35 LIKE pml_file.pml35,    #No.TQC-640132
                                  pml20 LIKE pml_file.pml20,    # 訂購量
                                  azc01 LIKE azc_file.azc01,    # 簽核
#No.FUN-580004 --start--
                                  pml80 LIKE pml_file.pml80,
                                  pml82 LIKE pml_file.pml81,
                                  pml83 LIKE pml_file.pml83,
                                  pml85 LIKE pml_file.pml85,
                                  pml86 LIKE pml_file.pml86,
                                  pml87 LIKE pml_file.pml87
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
#No.FUN-580004 --end--
 
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004---------Begin-------------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--------End------------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT pmk01,pmk07,pmksign,pmk02,pmk09,pmk22,pmk40,",
                 "        pmk04,pmkdays,pmkprit,0,pmksseq,pmksmax,pml02,",
                 "        pml04,pml041,pml18,pml31,pml44,pml07, ", #FUN-4C0095 add pml041
                 "        pml33,pml34,pml35,pml20,azc01,",  #No.TQC-640132
                 "        pml80,pml82,pml83,pml85,pml86,pml87 ",  #No.FUN-580004
                 "  FROM pmk_file,azc_file,pml_file",
                 "  WHERE pmkmksg = 'Y' AND pmk25 NOT IN ('6','9')",
                 "  AND pmk18 != 'X' AND ",tm.wc CLIPPED,
                 "  AND pmk01=pml01 AND azc03='",tm.azc03,"' AND azc01=pmksign"
     IF tm.x = '1' THEN LET l_sql = l_sql CLIPPED,
                 "  AND pmksseq != pmksmax AND azc02 > pmksseq "
     END IF
     LET l_sql = l_sql CLIPPED ," ORDER BY pmk01"
     PREPARE apmr300_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE apmr300_curs1 CURSOR FOR apmr300_prepare1
     CALL cl_outnam('apmr300') RETURNING l_name
 
#No.FUN-580004  --start
     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET g_zaa[51].zaa06 = "Y"
        LET g_zaa[52].zaa06 = "Y"
        LET g_zaa[53].zaa06 = "N"
        LET g_zaa[54].zaa06 = "N"
     ELSE
        LET g_zaa[53].zaa06 = "Y"
        LET g_zaa[54].zaa06 = "Y"
        LET g_zaa[51].zaa06 = "N"
        LET g_zaa[52].zaa06 = "N"
     END IF
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET g_zaa[50].zaa06 = "N"
     ELSE
        LET g_zaa[50].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580004 --end
 
     START REPORT apmr300_rep TO l_name
 
     FOREACH apmr300_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.pmk01 IS NULL THEN LET sr.pmk01 = ' ' END IF
       CALL s_gdays(sr.pmk04+sr.pmkdays) RETURNING sr.days
       OUTPUT TO REPORT apmr300_rep(sr.*)
     END FOREACH
 
     FINISH REPORT apmr300_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT apmr300_rep(sr)
   DEFINE l_ima021    LIKE ima_file.ima021       #FUN-4C0095
   DEFINE l_last_sw   LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
          l_pmc03     LIKE pmc_file.pmc03,
#         l_azd04     LIKE azd_file.azd04,
          l_gen02     LIKE gen_file.gen02,
          l_azd04     LIKE azd_file.azd04,       #No.FUN-680136 VARCHAR(8)
          l_sql1      LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(1000)
          tmp              RECORD                #為SELECT簽核日期
                                  azc02 LIKE azc_file.azc02,    #順序
                                  azc03 LIKE azc_file.azc03     # 簽核人員
                           END RECORD,
          sr               RECORD
                                  pmk01 LIKE pmk_file.pmk01,	# 單號
                                  pmk07 LIKE pmk_file.pmk07, 	# 單號類別範圍
                                  pmksign LIKE pmk_file.pmksign,# 簽核等級範圍
                                  pmk02 LIKE pmk_file.pmk02,    # 單據性質
                                  pmk09 LIKE pmk_file.pmk09,    # 供應商編號
                                  pmk22 LIKE pmk_file.pmk22,    # 幣別
                                  pmk40 LIKE pmk_file.pmk40,    # 總金額
                                  pmk04 LIKE pmk_file.pmk04,
                                  pmkdays LIKE pmk_file.pmkdays,
                                  pmkprit LIKE pmk_file.pmkprit,
                                  days    LIKE type_file.num5,  #No.FUN-680136 smallint
                                  pmksseq LIKE pmk_file.pmksseq,# 已簽核順序
                                  pmksmax LIKE pmk_file.pmksmax,# 應簽核順序
                                  pml02 LIKE pml_file.pml02,    # 項次
                                  pml04 LIKE pml_file.pml04,    # 料件編號
                                  pml041 LIKE pml_file.pml041,  #品名規格 #FUN-4C0095
                                  pml18 LIKE pml_file.pml18,    # MRP需求日
                                  pml31 LIKE pml_file.pml31,    # MRP需求量
                                  pml44 LIKE pml_file.pml44,    # 本幣單價
                                  pml07 LIKE pml_file.pml07,    # 單位
                                  pml33 LIKE pml_file.pml33,    # 交貨日
                                  pml34 LIKE pml_file.pml34,    #No.TQC-640132
                                  pml35 LIKE pml_file.pml35,    #No.TQC-640132
                                  pml20 LIKE pml_file.pml20,    # 訂購量
                                  azc01 LIKE azc_file.azc01,    # 簽核
#No.FUN-580004 --start--
                                  pml80 LIKE pml_file.pml80,
                                  pml82 LIKE pml_file.pml81,
                                  pml83 LIKE pml_file.pml83,
                                  pml85 LIKE pml_file.pml85,
                                  pml86 LIKE pml_file.pml86,
                                  pml87 LIKE pml_file.pml87
                        END RECORD
 
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_str2         LIKE type_file.chr1000        #No.FUN-680136 VARCHAR(100)
  DEFINE l_pml85        STRING
  DEFINE l_pml82        STRING
  DEFINE l_pml20        STRING
#No.FUN-580004 --end--
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.days,sr.pmkprit,sr.pmk01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno" #TQC-5B0037 add
      #LET pageno_total=PAGENO USING '<<<','/pageno' #TQC-5B0037 mark
      #LET g_head=g_head CLIPPED,pageno_total #TQC-5B0037 mark
      PRINT g_head CLIPPED,pageno_total #TQC-5B0037
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59]  #No.FUN-580004  #No.TQC-640132
      PRINT g_dash1
 
BEFORE GROUP  OF sr.pmk01
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE sr.pmk09 = pmc01
         IF SQLCA.sqlcode THEN LET l_pmc03 = NULL END IF
         PRINT COLUMN g_c[31],sr.pmk01,
               COLUMN g_c[32],sr.pmk02,
               COLUMN g_c[33],sr.pmk09,
               COLUMN g_c[34],l_pmc03,
               COLUMN g_c[35],sr.pmk22,
               COLUMN g_c[36],cl_numfor(sr.pmk40,17,g_azi04) CLIPPED,
               COLUMN g_c[37],sr.pmksign,
               COLUMN g_c[38],sr.pmksseq USING '-&',
               COLUMN g_c[39],sr.pmksmax USING "-&";
 
         LET l_sql1 =" SELECT azc02,azc03 FROM azc_file",
                     "  WHERE '",sr.azc01,"' = azc01",
                     " ORDER BY azc02"
# 找出此張單據應簽已簽的所有簽核人員
         PREPARE apmr300_pre1 FROM l_sql1
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
                 EXIT PROGRAM END IF
         DECLARE apmr300_curs2 CURSOR FOR apmr300_pre1
         FOREACH apmr300_curs2 INTO tmp.*
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH END IF
#找出此張單據已簽簽核人員的簽核日期
            SELECT azd04 INTO l_azd04 FROM azd_file WHERE sr.pmk01 = azd01 AND
                   azd02 = 6 AND tmp.azc03 = azd03
            IF SQLCA.sqlcode THEN LET l_azd04 = NULL END IF
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE tmp.azc03 = gen01
            IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
 
            IF sr.pmksseq > tmp.azc02 OR sr.pmksseq = tmp.azc02  THEN
               #已簽核的列印一'*'，和簽核日期
               PRINT COLUMN g_c[40],'*',
                     COLUMN g_c[41],l_azd04,
                     COLUMN g_c[42],tmp.azc03,
                     COLUMN g_c[43],l_gen02 CLIPPED
            ELSE
            #未簽核的只列印出員工名稱
               LET l_azd04 = NULL
               PRINT COLUMN g_c[40],' ',
                     COLUMN g_c[41],l_azd04,
                     COLUMN g_c[42],tmp.azc03,
                     COLUMN g_c[43],l_gen02 CLIPPED
            END IF
         END FOREACH
      LET l_last_sw = 'n'
 
 
ON EVERY ROW
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pml04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      LET g_total = sr.pml20 * sr.pml44
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 ##原幣
       FROM azi_file WHERE azi01=sr.pmk22
 
#No.FUN-580004 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pml04
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
        #IF sr.pml80 <> sr.pml86 THEN        #NO.TQC-6B0137 mark
         IF sr.pml07 <> sr.pml86 THEN        #NO.TQC-6B0137 mod
            CALL cl_remove_zero(sr.pml20) RETURNING l_pml20
            LET l_str2 = l_str2 CLIPPED,"(",l_pml20,sr.pml07 CLIPPED,")"
         END IF
      END IF
 
      PRINT COLUMN g_c[44],sr.pml02 USING '####',
            COLUMN g_c[45],sr.pml04 CLIPPED,  #FUN-5B0014 [1,20],  #No.FUN-580004
            COLUMN g_c[46],sr.pml041,
            COLUMN g_c[47],l_ima021,
            COLUMN g_c[48],cl_numfor(sr.pml31,48,t_azi03) CLIPPED,
            COLUMN g_c[49],cl_numfor(sr.pml44,49,g_azi03) CLIPPED,
            COLUMN g_c[50],l_str2 CLIPPED,   #No.FUN-580004
            COLUMN g_c[51],sr.pml07,
            COLUMN g_c[52],cl_numfor(sr.pml20,52,2) CLIPPED,
            COLUMN g_c[53],sr.pml86,  #No.FUN-580004
            COLUMN g_c[54],cl_numfor(sr.pml87,54,2),  #No.FUN-580004
            COLUMN g_c[55],sr.pml33,
            COLUMN g_c[57],sr.pml34,   #No.TQC-640132
            COLUMN g_c[58],sr.pml35,   #No.TQC-640132
            COLUMN g_c[59],sr.pml18,   #No.TQC-640132
            COLUMN g_c[56],cl_numfor(g_total,56,g_azi04) CLIPPED
#No.FUN-580004 --end--
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
	#TQC-630166
		CALL cl_prt_pos_wc(tm.wc)
      END IF
       PRINT g_dash
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610036 <001> #
