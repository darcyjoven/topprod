# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr212.4gl
# Descriptions...: 客戶信用評等效期明細表
# Date & Author..: 99/05/10 By Iceman FOR TIPTOP 4.00
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: NO.FUN-850009 08/07/02 By zhaijie 老報表修改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			          # Print condition RECORD
              wc    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(500)          #Where Condiction
              n     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)           #列印
              bdate  LIKE type_file.dat,          #No.FUN-680137 DATE               #基準日期
              more  LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)             #特殊條件
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#NO.FUN-850009--start---
DEFINE   g_sql    STRING
DEFINE   g_str    STRING
DEFINE   l_table  STRING
DEFINE   t_azi04  LIKE  azi_file.azi04       
#NO.FUN-850009---end---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#NO.FUN-850009--start---
    LET  g_sql = "occ01.occ_file.occ01,",
                 "occ02.occ_file.occ02,",
                 "occ04.occ_file.occ04,",
                 "gen02.gen_file.gen02,",
                 "occ61.occ_file.occ61,",
                 "occ63.occ_file.occ63,",
                 "occ631.occ_file.occ631,",
                 "occ64.occ_file.occ64,",
                 "occ175.occ_file.occ175,",
                 "t_azi04.azi_file.azi04"
   LET l_table = cl_prt_temptable('axmr212',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                              
#NO.FUN-850009---end---
 
 #--------------No.TQC-610089 modify
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.bdate= ARG_VAL(8)
   LET tm.n    = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL axmr212_tm()	        	# Input print condition
      ELSE CALL axmr212()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr212_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_jmp_flag LIKE type_file.chr1              #No.FUN-680137 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 19
 
   OPEN WINDOW axmr212_w AT p_row,p_col WITH FORM "axm/42f/axmr212"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.n = '1'
   LET tm.bdate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON occ01,occgrup,occ04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.n,tm.bdate,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF cl_null(tm.n) THEN NEXT FIELD n END IF
         IF tm.n NOT MATCHES '[123]' THEN CALL cl_err('','axm-401',0)
            NEXT FIELD n END IF
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN CALL cl_err('','aap-099',0)
            NEXT FIELD bdate END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmr212'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr212','9031',1)
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
                         " '",tm.n CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",              #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr212',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW axmr212_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr212()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr212_w
END FUNCTION
 
FUNCTION axmr212()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0094
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,              #標題內容                    #No.FUN-680137 VARCHAR(40)
          l_rate        LIKE gxc_file.gxc09,
          l_order       ARRAY[3] OF LIKE oea_file.oea01, #No.FUN-680137 VARCHAR(15)
          sr            RECORD
                        occ01   LIKE occ_file.occ01,        #客戶編號
                        occ02   LIKE occ_file.occ02,        #客戶簡稱
                        occ04   LIKE occ_file.occ04,        #業務 NO
                        gen02   LIKE gen_file.gen02,        #業務員
                        occ61   LIKE occ_file.occ61,        #評等
                        occ63   LIKE occ_file.occ63,        #信用額度
                        occ631  LIKE occ_file.occ631,       #幣別
                        occ64   LIKE occ_file.occ64,        #可超出率
                        occ175  LIKE occ_file.occ175        #有效日期
                        END RECORD
     CALL cl_del_data(l_table)                              #NO.FUN-850009
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr212'  #NO.FUN-850009
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DECLARE axmr212_za_cur CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "axmr212" AND za03 = g_rlang
     FOREACH axmr212_za_cur INTO g_i,l_za05 LET g_x[g_i] = l_za05 END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr212'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 75 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT occ01,occ02,occ04,gen02,occ61,occ63,occ631,occ64,occ175",
                 "  FROM occ_file, gen_file ",
                 " WHERE occ04 = gen01 ",
                 "   AND occ62 = 'Y'",
                 "   AND ",tm.wc CLIPPED
     CASE WHEN tm.n = '1'
               LET l_sql = l_sql CLIPPED," AND occ175 < '",tm.bdate,"' "
          WHEN tm.n = '2'
               LET l_sql = l_sql CLIPPED," AND occ175 > '",tm.bdate,"' "
     END CASE
     PREPARE axmr212_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE axmr212_curs1 CURSOR FOR axmr212_prepare1
 
#     CALL cl_outnam('axmr212') RETURNING l_name            #NO.FUN-850009
#     START REPORT axmr212_rep TO l_name                    #NO.FUN-850009
 
     LET g_pageno = 0
     FOREACH axmr212_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#       OUTPUT TO REPORT axmr212_rep(sr.*)                  #NO.FUN-850009
#NO.FUN-850009--start---
        SELECT azi03,azi04,azi05
             INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取
             FROM azi_file
            WHERE azi01=sr.occ631
        EXECUTE insert_prep USING
          sr.occ01,sr.occ02,sr.occ04,sr.gen02,sr.occ61,sr.occ63,sr.occ631,
          sr.occ64,sr.occ175,t_azi04    
#NO.FUN-850009---end---
     END FOREACH
 
#     FINISH REPORT axmr212_rep                             #NO.FUN-850009
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850009
#NO.FUN-850009--start-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'occ01,occgrup,occ04')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.n,";",tm.bdate
     CALL cl_prt_cs3('axmr212','axmr212',g_sql,g_str) 
#NO.FUN-850009----end----
END FUNCTION
#NO.FUN-850009--start--mark----
#REPORT axmr212_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          sr            RECORD
#                        occ01   LIKE occ_file.occ01,        #客戶編號
#                        occ02   LIKE occ_file.occ02,        #客戶簡稱
#                        occ04   LIKE occ_file.occ04,        #業務 NO
#                        gen02   LIKE gen_file.gen02,        #業務員
#                        occ61   LIKE occ_file.occ61,        #評等
#                        occ63   LIKE occ_file.occ63,        #信用額度
#                        occ631  LIKE occ_file.occ631,       #幣別
#                        occ64   LIKE occ_file.occ64,        #可超出率
#                        occ175  LIKE occ_file.occ175        #有效日期
#                        END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#  ORDER BY sr.occ01
#FUN-4C0096 modify
#
#  FORMAT
#  PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#   ON EVERY ROW
#            SELECT azi03,azi04,azi05
#             INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取  #No.CHI-6A0004
#             FROM azi_file
#            WHERE azi01=sr.occ631
 
#           PRINT COLUMN g_c[31],sr.occ01,
#                 COLUMN g_c[32],sr.occ02[1,10] CLIPPED,   #No.TQC-6A0091
#                 COLUMN g_c[33],sr.occ04,
#                 COLUMN g_c[34],sr.gen02,
#                 COLUMN g_c[35],sr.occ61,
#                 COLUMN g_c[36],cl_numfor(sr.occ63,36,t_azi04),   #No.CHI-6A0004
#                 COLUMN g_c[37],sr.occ631,
#                 COLUMN g_c[38],sr.occ64,
#                 COLUMN g_c[39],sr.occ175
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED    #No.TQC-6A0091
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED    #No.TQC-6A0091
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-850009---end---mark----
