# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apjr401.4gl
# Descriptions...: 專案應付成本明細表
# Input parameter:
# Return code....:
# Date & Author..: 00/01/31 By Gina
# Modify.........: No.FUN-4C0099 05/02/02 By kim 報表轉XML功能
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-690118 06/10/16 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
 
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/23 By xumin表尾結束靠右
# Modify.........: No.FUN-830101 08/03/25 By Zhangyajun 報表轉CR
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-990027 10/10/19 By sabrina 現在專案代號變更在請款單單身，而sql抓的是單頭的資料
#                                                    要改sql語法，改抓apb24、apb10
# Modify.........: No.TQC-AC0268 10/12/17 By yinhy 增加查詢開窗功能
# Modify.........: No.TQC-B70216 11/08/01 11/08/01 By lixia 開窗全選報錯
# Modify.........: No:MOD-D10245 13/01/28 By Summer 立帳時同一張入庫單不同項次,金額相同時,只會印出一筆,請調整sql欄位增加apb21,apb22
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
#              wc   LIKE type_file.chr1000,      #No.#FUN-680103 VARCHAR(500), # Where Condition
              wc   STRING,                      #TQC-B70216
              more LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)   #特殊列印條件
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680103 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690118
 
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r401_tm(0,0)		# Input print condition
      ELSE CALL r401()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
END MAIN
 
FUNCTION r401_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680103 SMALLINT
          l_cmd		LIKE type_file.chr1000   #No.FUN-680103 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r401_w AT p_row,p_col
        WITH FORM "apj/42f/apjr401"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
#   CONSTRUCT BY NAME  tm.wc ON pja01,pja02,pja03,pja04         #FUN-830101 mark
    CONSTRUCT BY NAME  tm.wc ON pja01,pjb02,pja05,pja09,pja08   #FUN-830101
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    #No.TQC-AC0268  --Begin
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pja01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pja"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja01
               NEXT FIELD pja01
            WHEN INFIELD(pjb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb02
               NEXT FIELD pjb02
            WHEN INFIELD(pja09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja09
               NEXT FIELD pja09
            WHEN INFIELD(pja08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja08
               NEXT FIELD pja08
            OTHERWISE EXIT CASE
         END CASE
     #No.TQC-AC0268  --End
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
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r401_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM 
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
     INPUT BY NAME tm.more   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
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
      LET INT_FLAG = 0 CLOSE WINDOW r401_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apjr401'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apjr401','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apjr401',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r401()
   ERROR ""
END WHILE
   CLOSE WINDOW r401_w
END FUNCTION
 
FUNCTION r401()
   DEFINE
          l_name     LIKE type_file.chr20,       #No.#FUN-680103 VARCHAR(20),# External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0083
          l_i        LIKE type_file.num5,  	 #No.FUN-680103 SMALLINT
#          l_sql1     LIKE type_file.chr1000,     #No.FUN-680103 VARCHAR(1000)
          l_sql1     STRING,                     #TQC-B70216
          l_za05     LIKE type_file.chr1000,     #No.#FUN-680103 VARCHAR(40)
          l_order    ARRAY[3] of LIKE type_file.chr20,      #No.#FUN-680103 VARCHAR(20)
          l_wc       STRING     #FUN-830101
#FUN-830101--mark-start-
#          sr1        RECORD
#                     pja01     LIKE    pja_file.pja01,   #專案代號
#                     pja02     LIKE    pja_file.pja02,   #日期
#                     pja03     LIKE    pja_file.pja03,   #部門
#                     pja04     LIKE    pja_file.pja04,   #員工代號
#                     pjaconf   LIKE    pja_file.pjaconf, #確認
#                     pjaclose  LIKE    pja_file.pjaclose,#結案
#                     pja051    LIKE    pja_file.pja051,
#                     pja052    LIKE    pja_file.pja052,
#                     pja053    LIKE    pja_file.pja053,
#                     pja054    LIKE    pja_file.pja054,
#                     gem02     LIKE    gem_file.gem02,
#                     gen02     LIKE    gen_file.gen02,
#                     apa00     LIKE    apa_file.apa00,   #帳款性質
#                     apa01     LIKE    apa_file.apa01,   #帳款編號
#                     apa02     LIKE    apa_file.apa02,   #帳款日期
#                     apa06     LIKE    apa_file.apa06,   #廠商編號
#                     apa07     LIKE    apa_file.apa07,   #廠商簡稱
#                     apa13     LIKE    apa_file.apa13,   #幣別
#                     apa34f    LIKE    apa_file.apa34f,  #原幣金額
#                     apa34     LIKE    apa_file.apa34,   #本幣金額
#                     unpay     LIKE    apa_file.apa34    #未付本幣
#                     END RECORD
#FUN-830101-mark-end-
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
     #End:FUN-980030
#FUN-830101--mark-start-
#     LET l_sql1 = " SELECT pja01,pja02,pja03,pja04,pjaconf,pjaclose,",
#                  " pja051,pja052,pja053,pja054,gem02,gen02,",
#                  " apa00,apa01,apa02,apa06,apa07,apa13,apa34f,apa34,",
#                  "(apa34-apa35) ",
#                  " FROM pja_file,apa_file,OUTER gem_file,OUTER gen_file",
#                  " WHERE ",tm.wc CLIPPED,
#                  " AND apa66=pja01 ",
#                  " AND apa42 = 'N' ",
#                  " AND pja03=gem01 AND pja04=gen01 "
#FUN-830101-mark-end
#FUN-830101--start-- 
     LET l_sql1 = " SELECT DISTINCT pja01,pja02,pja05,pja08,pja09,pjb02,pjb03,gem02,gen02,",
                 #" apa00,apa01,apa02,apa06,apa07,apa13,apa34f,apa34,",       #CHI-990027 mark
                  " apa00,apa01,apa02,apa06,apa07,apa13,apb24,apb10,azi04 ",        #CHI-990027 add
                  ",apb21,apb22 ", #MOD-D10245 add
                 #"(apa34-apa35) unpay,azi04 ",                               #CHI-990027 mark
                  " FROM pja_file LEFT OUTER JOIN gem_file ON pja09=gem01 LEFT OUTER JOIN gen_file ON pja08=gen01,pjb_file,apa_file,apb_file,azi_file",
                  " WHERE ",tm.wc CLIPPED,
                  " AND pja01 = pjb01",
                  " AND pjb01 = apb35 AND pjb02 = apb36",
                  " AND apa01 = apb01",
                 #" AND apa66=pja01 ",      #CHI-990027 mark
                  " AND apb35=pja01 ",      #CHI-990027 add
                  " AND apa42 = 'N' ",
                  " AND azi01 = apa13 ",  
                  " "
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pja01,pjb02,pja05,pja09,pja08') RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
    LET l_sql1 = l_sql1 CLIPPED," ORDER BY pja01,pjb02"
    LET l_wc = l_wc CLIPPED,";",g_azi04
    CALL cl_prt_cs1('apjr401','apjr401',l_sql1,l_wc)
    #FUN-830101---end---
#FUN-830101--mark--start--
#     PREPARE r401_p1 FROM l_sql1
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
#        EXIT PROGRAM
           
#     END IF
#     DECLARE r401_c1 CURSOR FOR r401_p1
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('declare1:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
#        EXIT PROGRAM
           
#     END IF
#     CALL cl_outnam('apjr401') RETURNING l_name
 
#     START REPORT r401_rep TO l_name
#     LET g_pageno = 0
#     FOREACH r401_c1 INTO sr1.*
#         IF SQLCA.sqlcode THEN
#             CALL cl_err('foreachi1:',SQLCA.sqlcode,1) EXIT FOREACH
#         END IF
#         IF sr1.apa00 matches '2*' THEN
#            LET sr1.apa34f = sr1.apa34f * -1
#            LET sr1.apa34  = sr1.apa34  * -1
#            LET sr1.unpay  = sr1.unpay  * -1
#         END IF
#         OUTPUT TO REPORT r401_rep(sr1.*)
#     END FOREACH
 
#     FINISH REPORT r401_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-830101--mark--end--
END FUNCTION
 
#FUN-830101-mark-start-
#REPORT r401_rep(sr1)
#   DEFINE
#          l_last_sw      LIKE type_file.chr1,        #No.#FUN-680103 VARCHAR(1)
#          l_sw           LIKE type_file.chr1,        #No.#FUN-680103 VARCHAR(1)
#          l_sr           LIKE type_file.chr1,        #No.#FUN-680103 VARCHAR(1)
#          l_apa35        LIKE apa_file.apa35,
#       #   t_azi03        LIKE azi_file.azi03,        #原幣    #No.CHI-6A0004
#       #   t_azi04        LIKE azi_file.azi04,        #        #No.CHI-6A0004
#       #   t_azi05        LIKE azi_file.azi05,        #        #No.CHI-6A0004
#          sum_apa34  LIKE type_file.num10,           #No.#FUN-680103 INTEGER   
#          sum_unpay  LIKE type_file.num10,           #No.#FUN-680103 INTEGER
#          sr1        RECORD
#                     pja01     LIKE    pja_file.pja01,   #專案代號
#                     pja02     LIKE    pja_file.pja02,   #日期
#                     pja03     LIKE    pja_file.pja03,   #部門
#                     pja04     LIKE    pja_file.pja04,   #員工代號
#                     pjaconf   LIKE    pja_file.pjaconf, #確認
#                     pjaclose  LIKE    pja_file.pjaclose,#結案
#                     pja051    LIKE    pja_file.pja051,
#                     pja052    LIKE    pja_file.pja052,
#                     pja053    LIKE    pja_file.pja053,
#                     pja054    LIKE    pja_file.pja054,
#                     gem02     LIKE    gem_file.gem02,
#                     gen02     LIKE    gen_file.gen02,
#                     apa00     LIKE    apa_file.apa00,   #帳款性質
#                     apa01     LIKE    apa_file.apa01,   #帳款編號
#                     apa02     LIKE    apa_file.apa02,   #帳款日期
#                     apa06     LIKE    apa_file.apa06,   #廠商編號
#                     apa07     LIKE    apa_file.apa07,   #廠商簡稱
#                     apa13     LIKE    apa_file.apa13,   #幣別
#                     apa34f    LIKE    apa_file.apa34f,  #原幣金額
#                     apa34     LIKE    apa_file.apa34,   #本幣金額
#                     unpay     LIKE    apa_file.apa34    #未付本幣
#                     END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr1.pja01,sr1.apa00,sr1.apa01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash[1,g_len]  #TQC-6A0080
#      PRINT COLUMN  1,g_x[8] CLIPPED,' ',sr1.pja01,'   ',
#            COLUMN 24,g_x[9] CLIPPED,' ',sr1.pja03,'   ',sr1.gem02,'      ',
#            COLUMN 57,g_x[10] CLIPPED,'   ',sr1.pjaconf
#      PRINT COLUMN  1,g_x[11] CLIPPED,' ',sr1.pja02,'     ',
#            COLUMN 24,g_x[12] CLIPPED,' ',sr1.pja04,' ',sr1.gen02,'      ',
#            COLUMN 57,g_x[13] CLIPPED,'   ',sr1.pjaclose
#      PRINT g_x[14]
#      PRINT sr1.pja051,COLUMN 41,sr1.pja052
#      PRINT sr1.pja053,COLUMN 41,sr1.pja054
#      PRINT ' '
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr1.pja01
#      SKIP TO TOP OF PAGE             #跳頁
#
#   ON EVERY ROW
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位  #NO.CHI-6A0004
#         FROM azi_file
#        WHERE azi01=sr1.apa13
#      PRINT COLUMN g_c[31],sr1.apa01,
#           COLUMN g_c[32],sr1.apa02,
#            COLUMN g_c[33],sr1.apa06,
#            COLUMN g_c[34],sr1.apa07,
#            COLUMN g_c[35],sr1.apa13,
#            COLUMN g_c[36],cl_numfor(sr1.apa34f,36,t_azi04),   #No.CHI-6A0004
#            COLUMN g_c[37],cl_numfor(sr1.apa34,37,g_azi04),
#            COLUMN g_c[38],cl_numfor(sr1.unpay,38,g_azi04)
#
#  AFTER GROUP OF sr1.pja01
#      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
#            COLUMN g_c[37],g_dash2[1,g_w[37]],
#            COLUMN g_c[38],g_dash2[1,g_w[38]]
#      PRINT COLUMN g_c[36],g_x[15] CLIPPED,
#            COLUMN g_c[37],cl_numfor(GROUP SUM(sr1.apa34),37,g_azi04),
#            COLUMN g_c[38],cl_numfor(GROUP SUM(sr1.unpay),38,g_azi04)
#
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash2
#      END IF
#      PRINT g_dash[1,g_len]  #TQC-6A0080
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]  #TQC-6A0080
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#FUN-830101-mark-end-
