# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr600.4gl
# Desc/riptions...: 採購單簽核列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/22 By MAY
# Modify.........: No.FUN-4C0095 04/12/27 By Mandy 報表轉XML
# Modify.........: No.FUN-580004 05/08/08 By wujie 雙單位報表格式修改
# Modify.........: No.MOD-590019 05/09/02 By Kevin 簽核人員開窗改成q_gen2
# Modify.........: No.TQC-5B0212 05/12/27 By kevin 採購項次調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-660133 06/06/30 By Ray 增加新欄位pmm40t(含稅總金額)
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改   
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
   DEFINE g_zaa04_value  LIKE zaa_file.zaa04
   DEFINE g_zaa10_value  LIKE zaa_file.zaa10
   DEFINE g_zaa11_value  LIKE zaa_file.zaa11
   DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
 
   DEFINE tm  RECORD	
   	       #wc   VARCHAR(500),                   #TQC-630166 mark		
		wc  	STRING,                      #TQC-630166		
   		azc03 	LIKE azc_file.azc03,
                x       LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)   1)應簽未簽 (2)全部
   		more    LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,        # 本國幣別
          i              LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          l_idx          LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          g_total        LIKE type_file.num20_6      #No.FUN-680136 DECIMAL(20,6)
   DEFINE   g_i          LIKE type_file.num5         #count/index for any purpose  #No.FUN-680136 SMALLINT
#FUN-580004--begin
   DEFINE g_sma115       LIKE sma_file.sma115
   DEFINE g_sma116       LIKE sma_file.sma116
#  DEFINE l_sql          LIKE type_file.chr1000     #TQC-630166 mark     #No.FUN-680136 VARCHAR(1000) 
   DEFINE l_sql          STRING                     #TQC-630166
   DEFINE l_zaa02        LIKE zaa_file.zaa02
#FUN-580004--end
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
      THEN CALL r600_tm(0,0)		# Input print condition
      ELSE CALL apmr600()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r600_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	 LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd	 	 LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW r600_w AT p_row,p_col WITH FORM "apm/42f/apmr600"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.x = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME  tm.more  # Condition
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm07,pmmsign
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
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
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
      AFTER FIELD x
           IF tm.x IS NULL OR tm.x NOT MATCHES '[12]' THEN NEXT FIELD x END IF
      AFTER FIELD more
           IF tm.more NOT MATCHES "[YN]"  OR tm.more IS NULL THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr600','9031',1)
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
         CALL cl_cmdat('apmr600',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr600()
   ERROR ""
END WHILE
   CLOSE WINDOW r600_w
END FUNCTION
 
FUNCTION apmr600()
   DEFINE l_name	LIKE type_file.chr20, 	   # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	   # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,	   # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,		           # RDSQL STATEMENT   #TQC-630166
          l_za05	LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(40)
          sr               RECORD
                                  pmm01   LIKE pmm_file.pmm01,	  # 單號
                                  pmm07   LIKE pmm_file.pmm07,    # 單號類別範圍
                                  pmmsign LIKE pmm_file.pmmsign,  # 簽核等級範圍
                                  pmm02   LIKE pmm_file.pmm02,    # 單據性質
                                  pmm09   LIKE pmm_file.pmm09,    # 供應商編號
                                  pmm22   LIKE pmm_file.pmm22,    # 幣別
                                  pmm40   LIKE pmm_file.pmm40,    # 總金額
                                  pmm40t  LIKE pmm_file.pmm40t,   # 含稅總金額                #MOD-660133
                                  pmm04   LIKE pmm_file.pmm04,    # 日期
                                  pmmdays LIKE pmm_file.pmmdays,  # 簽核天數
                                  pmmprit LIKE pmm_file.pmmprit,  # 簽核優先等級
                                  days    LIKE type_file.num5,    # No.FUN-680136 SMALLINT     #剩餘天數
                                  pmmsseq LIKE pmm_file.pmmsseq,  # 已簽核順序
                                  pmmsmax LIKE pmm_file.pmmsmax,  # 應簽核順序
                                  pmn02 LIKE pmn_file.pmn02,      # 項次
                                  pmn04 LIKE pmn_file.pmn04,      # 料件編號
                                  pmn041 LIKE pmn_file.pmn041,    # FUN-4C0095
                                  pmn31 LIKE pmn_file.pmn31,      # 單價
                                  pmn44 LIKE pmn_file.pmn44,      # 本幣單價
                                  pmn07 LIKE pmn_file.pmn07,      # 單位
                                  pmn33 LIKE pmn_file.pmn33,      # 交貨日
                                  pmn20 LIKE pmn_file.pmn20,      # 請購金額
                                  pmn80 LIKE pmn_file.pmn80,      # No.FUN-580004
                                  pmn82 LIKE pmn_file.pmn82,      # No.FUN-580004
                                  pmn83 LIKE pmn_file.pmn83,      # No.FUN-580004
                                  pmn85 LIKE pmn_file.pmn85,      # No.FUN-580004
                                  pmn86 LIKE pmn_file.pmn86,      # No.FUN-580004
                                  pmn87 LIKE pmn_file.pmn87,      # No.FUN-580004
                                  azc01 LIKE azc_file.azc01       # 簽核
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004---------Begin-----------------------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004---------End-----------------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
#當選擇為未簽核時
     LET l_sql = " SELECT  ",
                 "   pmm01,  pmm07,  pmmsign,  pmm02,  pmm09 ,pmm22, pmm40, pmm40t,",       #MOD-660133
                 "   pmm04,pmmdays,pmmprit,0,",
                 "   pmmsseq,pmmsmax,  pmn02,  pmn04,pmn041, ", #FUN-4C0095
                 "   pmn31, pmn44,    pmn07,  pmn33,  pmn20,pmn80,pmn82,pmn83,pmn85,pmn86,pmn87,azc01",       #No.FUN-580004
                 "  FROM pmm_file,azc_file,pmn_file",
                 "  WHERE pmmmksg = 'Y' AND pmm25 ='0'",
                 "  AND pmm01=pmn01 ",
                 "  AND azc03 = '",tm.azc03,"' AND azc01 = pmmsign",
                 "  AND ",tm.wc CLIPPED
     display l_sql
     IF tm.x = '1' THEN LET l_sql = l_sql CLIPPED,
                 "  AND pmmsseq != pmmsmax AND azc02 > pmmsseq "
     END IF
     LET l_sql = l_sql CLIPPED ," ORDER BY pmm01"
     PREPARE r600_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r600_cs1 CURSOR FOR r600_prepare1
     LET l_name = 'apmr600.out'
     CALL cl_outnam('apmr600') RETURNING l_name
 
#FUN-580004--begin
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            LET g_zaa[50].zaa06 = "Y"
            LET g_zaa[52].zaa06 = "Y"
            LET g_zaa[55].zaa06 = "N"
            LET g_zaa[56].zaa06 = "N"
     ELSE
            LET g_zaa[50].zaa06 = "N"
            LET g_zaa[52].zaa06 = "N"
            LET g_zaa[55].zaa06 = "Y"
            LET g_zaa[56].zaa06 = "Y"
     END IF
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            LET g_zaa[54].zaa06 = "N"
     ELSE
            LET g_zaa[54].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580004--end
     START REPORT r600_rep TO l_name
 
     FOREACH r600_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET sr.azc01 = sr.pmmsign
       CALL s_gdays(sr.pmm04+sr.pmmdays) RETURNING sr.days
       IF sr.pmm01 IS NULL THEN LET sr.pmm01 = ' ' END IF
       OUTPUT TO REPORT r600_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r600_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r600_rep(sr)
   DEFINE l_ima021      LIKE ima_file.ima021                    #FUN-4C0095
   DEFINE l_last_sw	 LIKE type_file.chr1,                   #No.FUN-680136 VARCHAR(1)
          l_pmc03       LIKE pmc_file.pmc03,
          l_azd04       LIKE azd_file.azd04,
          l_gen02       LIKE gen_file.gen02,
         #l_sql1        LIKE type_file.chr1000,                 #TQC-630166 mark    #No.FUN-680136 VARCHAR(1000)
          l_sql1        STRING,       #TQC-630166 
          tmp              RECORD  #為SELECT簽核日期
                                  azc02 LIKE azc_file.azc02,    # 順序
                                  azc03 LIKE azc_file.azc03     # 簽核人員
                           END RECORD,
          sr               RECORD
                                  pmm01 LIKE pmm_file.pmm01,	# 單號
                                  pmm07 LIKE pmm_file.pmm07, 	# 單號類別範圍
                                  pmmsign LIKE pmm_file.pmmsign,# 簽核等級範圍
                                  pmm02 LIKE pmm_file.pmm02,    # 單據性質
                                  pmm09 LIKE pmm_file.pmm09,    # 供應商編號
                                  pmm22 LIKE pmm_file.pmm22,    # 幣別
                                  pmm40 LIKE pmm_file.pmm40,    # 總金額
                                  pmm40t LIKE pmm_file.pmm40t,  # 含稅總金額       #MOD-660133
                                  pmm04 LIKE pmm_file.pmm04,    # 日期
                                  pmmdays LIKE pmm_file.pmmdays,#簽核天數
                                  pmmprit LIKE pmm_file.pmmprit,#簽核優先等級
                                  days    LIKe type_file.num5,  #No.FUN-680136 smallint  #剩餘天數
                                  pmmsseq LIKE pmm_file.pmmsseq,# 已簽核順序
                                  pmmsmax LIKE pmm_file.pmmsmax,# 應簽核順序
                                  pmn02 LIKE pmn_file.pmn02,    # 項次
                                  pmn04 LIKE pmn_file.pmn04,    # 料件編號
                                  pmn041 LIKE pmn_file.pmn041,  # #FUN-4C0095
                                  pmn31 LIKE pmn_file.pmn31,    # 單價
                                  pmn44 LIKE pmn_file.pmn44,    # 本幣單價
                                  pmn07 LIKE pmn_file.pmn07,    # 單位
                                  pmn33 LIKE pmn_file.pmn33,    # 交貨日
                                  pmn20 LIKE pmn_file.pmn20,    # 請購金額
                                  pmn80 LIKE pmn_file.pmn80,    #No.FUN-580004
                                  pmn82 LIKE pmn_file.pmn82,    #No.FUN-580004
                                  pmn83 LIKE pmn_file.pmn83,    #No.FUN-580004
                                  pmn85 LIKE pmn_file.pmn85,    #No.FUN-580004
                                  pmn86 LIKE pmn_file.pmn86,    #No.FUN-580004
                                  pmn87 LIKE pmn_file.pmn87,    #No.FUN-580004
                                  azc01 LIKE azc_file.azc01     # 簽核
                        END RECORD
#No.FUN-580004--begin
DEFINE  l_pmn85      STRING,
        l_pmn82      STRING,
        l_pmn20      STRING,
        l_ima906     LIKE  ima_file.ima906,
        l_str2       STRING
#No.FUN-580004--end
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.days,sr.pmmprit,sr.pmm01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[57],g_x[37],g_x[38],g_x[39],g_x[40],     #MOD-660133
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56]           #No.FUN-580004
      PRINT g_dash1
 
BEFORE GROUP  OF sr.pmm01
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE sr.pmm09 = pmc01
         IF SQLCA.sqlcode THEN LET l_pmc03 = NULL END IF
         PRINT COLUMN g_c[31],sr.pmm01,
               COLUMN g_c[32],sr.pmm02,
               COLUMN g_c[33],sr.pmm09,
               COLUMN g_c[34],l_pmc03,
               COLUMN g_c[35],sr.pmm22,
               COLUMN g_c[36],cl_numfor(sr.pmm40,36,g_azi04) CLIPPED,
               COLUMN g_c[57],cl_numfor(sr.pmm40t,57,g_azi04) CLIPPED,       #MOD-660133
               COLUMN g_c[37],sr.pmmsign,
               COLUMN g_c[38],sr.pmmsseq USING '---------&', #No.TQC-5B0212
               COLUMN g_c[39],sr.pmmsmax USING "---------&"; #No.TQC-5B0212
         LET l_sql1 =" SELECT azc02,azc03 FROM azc_file",
                     "  WHERE '",sr.azc01,"' = azc01",
                     " ORDER BY azc02"
# 找出此張單據應簽已簽的所有簽核人員
         LET i = 1
         LET l_idx = 0
         PREPARE apmr310_pre1 FROM l_sql1
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
                 EXIT PROGRAM END IF
         DECLARE apmr310_curs2 CURSOR FOR apmr310_pre1
         FOREACH apmr310_curs2 INTO tmp.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_idx = l_idx + 1
           #找出此張單據已簽簽核人員的簽核日期
            SELECT azd04
              INTO l_azd04
              FROM azd_file
              WHERE sr.pmm01 = azd01
              AND azd02 = 7
              AND tmp.azc03 = azd03
                IF SQLCA.sqlcode THEN
                   LET l_azd04 = NULL
                END IF
            SELECT gen02
              INTO l_gen02
              FROM gen_file
              WHERE tmp.azc03 = gen01
                IF SQLCA.sqlcode THEN
                   LET l_gen02 = NULL
                END IF
            IF sr.pmmsseq > tmp.azc02 OR sr.pmmsseq = tmp.azc02  THEN
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
               LET l_idx = l_idx + 1
            END IF
         END FOREACH
         SKIP 1 LINE
      LET l_last_sw = 'n'
 
 
ON EVERY ROW
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      LET g_total = sr.pmn20 * sr.pmn44
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 ##原幣
       FROM azi_file WHERE azi01=sr.pmm22
 
#FUN-580004--begin
 
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pmn04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
           #IF sr.pmn80 <> sr.pmn86 THEN     #NO.TQC-6B0137  mark
            IF sr.pmn07 <> sr.pmn86 THEN     #NO.TQC-6B0137  mod
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      END IF
#FUN-580004--end
      PRINT COLUMN g_c[44],sr.pmn02 USING '########',  #No.TQC-5B0212
            COLUMN g_c[45],sr.pmn04,
            COLUMN g_c[54],l_str2 CLIPPED,         #No.FUN-580004
            COLUMN g_c[46],sr.pmn041,
            COLUMN g_c[47],l_ima021,
            COLUMN g_c[48],cl_numfor(sr.pmn31,48,t_azi03) CLIPPED,
            COLUMN g_c[49],cl_numfor(sr.pmn44,49,g_azi03) CLIPPED,
            COLUMN g_c[55],sr.pmn86,           #No.FUN-580004
            COLUMN g_c[56],cl_numfor(sr.pmn87,56,3),     #MOD-660133
            COLUMN g_c[50],sr.pmn07,
            COLUMN g_c[51],sr.pmn33,
            COLUMN g_c[52],cl_numfor(sr.pmn20,52,2) CLIPPED,
            COLUMN g_c[53],cl_numfor(g_total,53,g_azi04) CLIPPED
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash
             #TQC-630166
             #IF tm.wc[001,070] > ' ' THEN			# for 80
 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
             #IF tm.wc[071,140] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
             #IF tm.wc[141,210] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
             #IF tm.wc[211,280] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
#             IF tm.wc[001,120] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
