# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: axmx420.4gl
# Descriptions...: 訂單預估毛利明細表
# Date & Author..: 95/01/23 By Danny
# Mofiy..........: 01-04-06 BY ANN CHEN 1.不包含換貨訂單與合約訂單
#                                       2.不包含作廢資料
# Modify.........: No:7952 03/09/03 By Wiky 修改匯率
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy DEFINE 匯率時用LIKE的方式
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-720004 07/01/23 BY TSD 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.MOD-970080 09/07/09 By Dido 人員姓名/部門名稱帶錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0006 09/11/02 By lilingyu Sql改成標準寫法
# Modify.........: No.TQC-A50044 10/05/17 By Carrier MOD-9B0180追单
# Modify.........: No.TQC-C20014 12/02/01 By lilingyu 毛利率的數據改為以百分比的形式呈現
# Modify.........: No.TQC-C50101 12/05/11 By zhuhao 變量類型定義修改 
# Modify.........: No.FUN-CB0002 12/11/01 By lujh CR轉XtraGrid
# Modify.........: No.FUN-D30070 13/03/21 By chenying 去除小計
# Modify.........: No.FUN-D40128 13/05/07 By wangrr "幣別""留置碼"增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,   #CHAR(500)
           s       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           t       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
          #u       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)  #FUN-D30070
           a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
           b       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
           more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)
           END RECORD,
           g_orderA ARRAY[3] OF LIKE faj_file.faj02,# No.FUN-680137 VARCHAR(10)
           exT      LIKE type_file.chr1             # No.FUN-680137 VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table         STRING                     ### FUN-720004 add ###
DEFINE   g_sql           STRING                     ### FUN-720004 add ###
DEFINE   g_str           STRING                     ### FUN-720004 add ###
DEFINE   l_str           STRING                #FUN-CB0002  add
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720004 *** ##
   LET g_sql = "oea01.oea_file.oea01,",
               "oea02.oea_file.oea02,",
               "oea03.oea_file.oea03,", 
               "oea032.oea_file.oea032,",
               "oea04.oea_file.oea04,",
               "occ02.occ_file.occ02,",
               "gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",
               "oea23.oea_file.oea23,",
               "oea21.oea_file.oea21,",
               "oea31.oea_file.oea31,",
               "oea32.oea_file.oea32,",
               "oea12.oea_file.oea12,",
               "oeahold.oea_file.oeahold,",
               "oeaconf.oea_file.oeaconf,",
               "oea14.oea_file.oea14,",
               "oea15.oea_file.oea15,",
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
               "oeb092.oeb_file.oeb092,",
               "oeb06.oeb_file.oeb06,",
               "oeb14.oeb_file.oeb14,",
               "oeb12.oeb_file.oeb12,",
               "oef05.oef_file.oef05,",
               "oea08.oea_file.oea08,",
               "ima021.ima_file.ima021,",
               "tot1.oeb_file.oeb14,",  #tot1
               "tot2.apa_file.apa16,",  #tot2
               "percent.type_file.chr20"  #FUN-CB0002 add

   LET l_table = cl_prt_temptable('axmx420',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"   #FUN-CB0002 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
  #LET tm.u  = ARG_VAL(10)  #FUN-D30070
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' OR g_bgjob is NULL
      THEN CALL x420_tm(0,0)
      ELSE CALL x420()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION x420_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW x420_w AT p_row,p_col WITH FORM "axm/42f/axmx420"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
  #LET tm2.u1   = 'N'  #FUN-D30070
  #LET tm2.u2   = 'N'  #FUN-D30070
  #LET tm2.u3   = 'N'  #FUN-D30070 
   LET tm2.t1   = 'N'
   LET tm2.t2   = 'N'
   LET tm2.t3   = 'N'
   LET tm.a     = '3'
   LET tm.b     = '3'
   LET tm.more  = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           #FUN-CB0002--add--str--
           IF INFIELD(oea01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea03"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea01
              NEXT FIELD oea01
           END IF
           #FUN-CB0002--add--str--
           IF INFIELD(oea03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           END IF
           IF INFIELD(oea04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea04
              NEXT FIELD oea04
           END IF
           IF INFIELD(oea14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea14
              NEXT FIELD oea14
           END IF
           IF INFIELD(oea15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea15
              NEXT FIELD oea15
           END IF
           IF INFIELD(oea12) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nnp"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea12
              NEXT FIELD oea12
           END IF
           #FUN-D40128--add--str--
           IF INFIELD(oea23) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azi"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea23
              NEXT FIELD oea23
           END IF
           IF INFIELD(oeahold) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea12_2"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oeahold
              NEXT FIELD oeahold
           END IF
           #FUN-D40128--add--end
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW x420_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3, #FUN-D30070
                 tm.a,tm.b,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' THEN NEXT FIELD b END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070
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
      LET INT_FLAG = 0
      CLOSE WINDOW x420_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmx420'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmx420','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                        #" '",tm.u CLIPPED,"'",  #FUN-D30070
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmx420',g_time,l_cmd)
      END IF
      CLOSE WINDOW x420_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x420()
   ERROR ""
END WHILE
   CLOSE WINDOW x420_w
END FUNCTION
 
FUNCTION x420()
DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0094
      #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)  #TQC-C50101 mark
      #l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)                                      #TQC-C50101 mark
       l_sql     STRING,                       #TQC-C50101 add
       sr        RECORD oea01     LIKE oea_file.oea01,
                        oea02     LIKE oea_file.oea02,
                        oea03     LIKE oea_file.oea03,
                        oea032    LIKE oea_file.oea032,		
                        oea04     LIKE oea_file.oea04,
                        occ02     LIKE occ_file.occ02,	
                        gen02     LIKE gen_file.gen02,
                        gem02     LIKE gem_file.gem02,
                        oea23     LIKE oea_file.oea23,
                        oea21     LIKE oea_file.oea21,
                        oea31     LIKE oea_file.oea31,
                        oea32     LIKE oea_file.oea32,
                        oea12     LIKE oea_file.oea12,
                        oeahold   LIKE oea_file.oeahold,
                        oeaconf   LIKE oea_file.oeaconf,
                        oea14     LIKE oea_file.oea14,    #FUN-4C0096
                        oea15     LIKE oea_file.oea15,    #FUN-4C0096
                        oeb03     LIKE oeb_file.oeb03,
                        oeb04     LIKE oeb_file.oeb04,
                        oeb092    LIKE oeb_file.oeb092,
                        oeb06     LIKE oeb_file.oeb06,
                        oeb14     LIKE oeb_file.oeb14,    #FUN-4C0096
                        oeb12     LIKE oeb_file.oeb12,
                        oef05     LIKE oef_file.oef05,
                        oea08     LIKE oea_file.oea08,
                        ima021    LIKE ima_file.ima021,   #FUN-720004 add
                        tot1      LIKE oeb_file.oeb14,    #FUN-4C0096
                        tot2      LIKE apa_file.apa16,      # No.FUN-680137 DECIMAL(4,2)
                        percent   LIKE type_file.chr20    #FUN-CB0002  add 
                        END RECORD,
             l_curr     LIKE azk_file.azk03 #No:7952 #FUN-4B0050
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720004 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720004 add ###
 
  {  SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
       FROM azi_file
      WHERE azi01=g_aza.aza17
  }      #No.CHI-6A0004
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT",
                #"  oea01,oea02,oea03,oea032,oea04,occ02,oea14,oea15,",	#MOD-970080 mark
                 "  oea01,oea02,oea03,oea032,oea04,occ02,gen02,gem02,",	#MOD-970080
                 "  oea23,oea21,oea31,oea32,oea12,oeahold,oeaconf,oea14,oea15,",
                 "  oeb03,oeb04,oeb092,oeb06,oeb14,(oeb12*ima125),", #FUN-4C0096
                #"  oef05,oea08,0,0",
                #"  oef05,oea08,ima021,0,0", #FUN-720004 modify  #No.TQC-A40055
                 "  0,oea08,ima021,0,0,'%'",     #No.TQC-A50044   #FUN-CB0002  add  %
#" FROM oea_file,oeb_file,ima_file,OUTER oef_file,OUTER occ_file,OUTER gen_file,OUTER gem_file ",  #FUN-9B0006
" FROM oea_file LEFT OUTER JOIN gem_file ON oea15=gem01 LEFT OUTER JOIN gen_file ON oea14=gen01 ", #FUN-9B0006
" LEFT OUTER JOIN occ_file ON oea04=occ01,oeb_file LEFT OUTER JOIN oef_file ON oeb01=oef01 AND oeb03=oef03,ima_file ",   #FUN-9B0006  #No.TQC-A50044
#" LEFT OUTER JOIN occ_file ON oea04=occ01,oeb_file,ima_file ",   #FUN-9B0006  #No.TQC-A50044
                 " WHERE oea01=oeb01 ",
                 "   AND ima01=oeb04 ",
          #       "   AND oeb_file.oeb01 =oef_file.oef01  ",  #FUN-9B0006
          #       "   AND oeb_file.oeb03 =oef_file.oef03  ",  #FUN-9B0006
          #       "   AND oea_file.oea04=occ_file.occ01 ",   #FUN-9B0006
          #       "   AND oea_file.oea14=gen_file.gen01 ",  #FUN-9B0006
          #       "   AND oea_file.oea15=gem_file.gem01 ",  #FUN-9B0006
                 "   AND (oea00<>'0' AND oea00<>'2') ", #No.B317
                 "   AND oeaconf!='X' ",      #No.B317
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY oea01"
     PREPARE x420_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE x420_curs1 CURSOR FOR x420_prepare1
 
     LET g_pageno = 0
     FOREACH x420_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF tm.a = '1' AND sr.oeaconf = 'N' THEN CONTINUE FOREACH END IF
          IF tm.a = '2' AND sr.oeaconf = 'Y' THEN CONTINUE FOREACH END IF
          IF tm.b = '1' AND cl_null(sr.oeahold) THEN CONTINUE FOREACH END IF
	  IF tm.b = '2' AND NOT cl_null(sr.oeahold) THEN CONTINUE FOREACH END IF
          IF sr.oea08='1' THEN
             LET exT=g_oaz.oaz52
          ELSE
             LET exT=g_oaz.oaz70
          END IF
          #-----TQC-A50044---------                                             
          SELECT SUM(oef05) INTO sr.oef05 FROM oef_file                         
            WHERE oef01=sr.oea01 AND oef03=sr.oeb03                             
          IF cl_null(sr.oef05) THEN LET sr.oef05 = 0 END IF                     
          #-----END TQC-A50044----- 
          CALL s_curr3(sr.oea23,sr.oea02,exT) RETURNING l_curr
          LET sr.oeb14=sr.oeb14*l_curr
          IF cl_null(sr.oeb14) THEN LET sr.oeb14=0 END IF
          LET sr.tot1=(sr.oeb14-sr.oeb12-sr.oef05)
          IF cl_null(sr.tot1) THEN LET sr.tot1=0 END IF
          IF sr.tot1 = 0 THEN
#            LET sr.tot2=sr.tot1/1                     #TQC-C20014
             LET sr.tot2=sr.tot1/1*100                 #TQC-C20014
          ELSE
#            LET sr.tot2=(sr.tot1/sr.oeb14)            #TQC-C20014
             LET sr.tot2=(sr.tot1/sr.oeb14)*100        #TQC-C20014
          END IF

          IF cl_null(sr.tot2) THEN LET sr.tot2=0 END IF
          IF cl_null(sr.oef05) THEN LET sr.oef05=0 END IF
 
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720004 *** ##
          EXECUTE insert_prep USING
              sr.oea01, sr.oea02,   sr.oea03,  sr.oea032, sr.oea04, sr.occ02,
             #sr.oea14, sr.oea15,   sr.oea23,  sr.oea21,  sr.oea31, sr.oea32,	#MOD-970080 mark
              sr.gen02, sr.gem02,   sr.oea23,  sr.oea21,  sr.oea31, sr.oea32,	#MOD-970080
              sr.oea12, sr.oeahold, sr.oeaconf,sr.oea14,  sr.oea15, sr.oeb03,
              sr.oeb04, sr.oeb092,  sr.oeb06,  sr.oeb14,  sr.oeb12, sr.oef05,
              sr.oea08, sr.ima021,  sr.tot1,   sr.tot2,   sr.percent            #FUN-CB0002  add  sr.percent
          #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720004 **** ##
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     #FUN-CB0002--mark--str--
     #IF g_zz05 = 'Y' THEN
     #   CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
     #   RETURNING tm.wc
     #   LET g_str = tm.wc
     #END IF
     #FUN-CB0002--mark--end--
     #傳per檔的排序、跳頁、小計、帳款截止日等參數
###XtraGrid###     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
###XtraGrid###                 tm.t,";",tm.u,";",t_azi04,";",t_azi05  #FUN-710080 modify
###XtraGrid###     CALL cl_prt_cs3('axmx420','axmx420',l_sql,g_str)   #FUN-710080 modify
    LET g_xgrid.table = l_table    ###XtraGrid###

    IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold")  #FUN-D30070
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold")
    
   ##FUN-D30070--mark--str--
   #LET l_str = cl_wcchp(g_xgrid.order_field,"oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold")
   #LET l_str = cl_replace_str(l_str,',','-')
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str
   ##FUN-D30070--mark--end---
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    CALL cl_xg_view()    ###XtraGrid###
     #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
