# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apjr402.4gl
# Descriptions...: 專案費用明細表
# Date & Author..: 00/02/09 By Alex Lin
# Modify.........: No.FUN-4C0099 05/02/02 By kim 報表轉XML功能
# Modify.........: No.MOD-530209 05/03/23 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-630055 06/05/30 By rainy 將專案代號由apb21改成apb31
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-690118 06/10/16 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-830101 08/03/27 By Zhangyajun 報表轉CR
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.TQC-950071 09/06/04 By chenmoyan 1、將sr.pja15改為sr.pja14
#                                                      2、問號個數少一個
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40073 10/05/05 By liuxqa 追单CHI-990027
# Modify.........: No:MOD-A50138 10/05/21 By Sarah apjr402_preparesub的SQL增加apb36條件
# Modify.........: No.TQC-AC0268 10/12/17 By yinhy 增加查詢開窗功能
# Modify.........: No.FUN-B80031 11/08/03 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
              wc   LIKE type_file.chr1000,      #No.#FUN-680103  VARCHAR(500), # Where Condition
              more LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)    # 特殊列印條件 
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680103 SMALLINT
DEFINE   l_table    STRING                       # FUN-830101
DEFINE   l_table1   STRING                       # FUN-830101  
DEFINE   g_str      STRING                       # FUN-830101 
DEFINE   g_sql      STRING                       # FUN-830101
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
   
   #FUN-830101-start-
   LET g_sql =          "  pja01.pja_file.pja01,",
           	        "  pja02.pja_file.pja02,",
           	        "  pja05.pja_file.pja05,",
           	        "  pja08.pja_file.pja08,",
           	        "  pja09.pja_file.pja09,",
                        "  pja14.pja_file.pja14,",
                        "  pja15.pja_file.pja15,",
           	        "  pjb02.pjb_file.pjb02,",
           	        "  pjb03.pjb_file.pjb03,",
                        "  pjd03.pjd_file.pjd03,",
           	        "  pjd04.pjd_file.pjd04,",
           	        "  pjd05.pjd_file.pjd05,",
           	        "  apa01.apa_file.apa01,",
           	        "  apa13.apa_file.apa13,",
           	        "  apa14.apa_file.apa14,",
           	        "  apb02.apb_file.apb02,",
           	        "  apb24.apb_file.apb24,",
           	        "  apb31.apb_file.apb31,",
                        "  gem02.gem_file.gem02,",
                        "  gen02.gen_file.gen02,",
                        "  azf03.azf_file.azf03,",
                        "  azi04.azi_file.azi04,",
                        "  azi04_1.azi_file.azi04,",
                        "  azi05.azi_file.azi05,",
                        "  azi07.azi_file.azi07 "      #No.FUN-870151
 
   LET l_table = cl_prt_temptable('axcr042',g_sql) CLIPPED  
   IF l_table = -1 THEN EXIT PROGRAM END IF               
   LET g_sql =  "  pja01.pja_file.pja01,",
                "  pja14_1.pja_file.pja14,",                                                                                        
                "  amt1.type_file.num20_6,",                                                                                        
                "  amt2.type_file.num20_6," 
   LET l_table1 = cl_prt_temptable('axcr0421',g_sql) CLIPPED                                                                          
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                         
   #FUN-830101-end-
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r402_tm(0,0)		# Input print condition
      ELSE CALL r402()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
END MAIN
 
FUNCTION r402_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,      #No.FUN-680103 SMALLINT
          l_cmd		LIKE type_file.chr1000    #No.FUN-680103 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r402_w AT p_row,p_col
        WITH FORM "apj/42f/apjr402"
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
   #CONSTRUCT BY NAME  tm.wc ON pja01,pja02,pja03,pja04,pjd03  #FUN-830101 mark
    CONSTRUCT BY NAME  tm.wc ON pja01,pjb02,pja05,pja09,pja08,pjd02  #FUN-830101   
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
            WHEN INFIELD(pjd02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjd02
               NEXT FIELD pjd02
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
 
 
   DISPLAY BY NAME tm.more
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r402_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM 
   END IF
 
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
     INPUT BY NAME tm.more
                 WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW r402_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apjr402'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apjr402','9031',1)
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
         CALL cl_cmdat('apjr402',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r402_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r402()
   ERROR ""
END WHILE
   CLOSE WINDOW r402_w
END FUNCTION
 
FUNCTION r402()
   DEFINE
          l_name     LIKE type_file.chr20,              #No.#FUN-680103 VARCHAR(20),  # External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0083
          l_i        LIKE type_file.num5,  		#No.FUN-680103 SMALLINT
          l_sql      LIKE type_file.chr1000,            #No.FUN-680103 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,            #No.#FUN-680103 VARCHAR(40)
          l_order    ARRAY[3] of LIKE type_file.chr20,  #No.#FUN-680103 VARCHAR(20)
          l_wc       STRING,                            #FUN-830101
#          sr         RECORD                            #FUN-830101 mark
#                     pja      RECORD  LIKE pja_file.*, 
#                     pjd      RECORD  LIKE pjd_file.*
#                     END RECORD
#FUN-830101-start-
           sr         RECORD
           	          pja01   LIKE pja_file.pja01,
           	          pja02   LIKE pja_file.pja02,
           	          pja05   LIKE pja_file.pja05,
           	          pja08   LIKE pja_file.pja08,
           	          pja09   LIKE pja_file.pja09,
                          pja14   LIKE pja_file.pja14,
                          pja15   LIKE pja_file.pja15,
           	          pjb02   LIKE pjb_file.pjb02,
           	          pjb03   LIKE pjb_file.pjb03,
           	          pjd01   LIKE pjd_file.pjd01,
                          pjd02   LIKE pjd_file.pjd02,
           	          pjd03   LIKE pjd_file.pjd03,
           	          pjd04   LIKE pjd_file.pjd04,
           	          pjd05   LIKE pjd_file.pjd05
                        END RECORD,
                sr1     RECORD
                          apa00   LIKE apa_file.apa00,
           	          apa01   LIKE apa_file.apa01,
           	          apa13   LIKE apa_file.apa13,
           	          apa14   LIKE apa_file.apa14,
           	          apb02   LIKE apb_file.apb02,
           	          apb24   LIKE apb_file.apb24,
           	          apb31   LIKE apb_file.apb31
           	        END RECORD,
     l_gen02    LIKE gen_file.gen02,
     l_gem02    LIKE gem_file.gem02,
     l_azf03    LIKE azf_file.azf03,
     l_azi04    LIKE azi_file.azi04,
     l_azi04_1  LIKE azi_file.azi04,
     l_azi05    LIKE azi_file.azi05,
     l_azi07    LIKE azi_file.azi07,        #FUN-870151
     l_pja01    LIKE pja_file.pja01,
     l_pja14    LIKE pja_file.pja14,
     l_amt1     LIKE type_file.num20_6,
     l_amt2     LIKE type_file.num20_6
#FUN-830101-end-     	          
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #FUN-830101
#FUN-830101-mark-start-
#      #No.FUN-680103 begin
#     DROP TABLE r402_tmp
#     CREATE TEMP TABLE r402_tmp
#       (pjd01 LIKE pjd_file.pjd01,
#        pjd04 LIKE pjd_file.pjd04,
#        amt1  LIKE type_file.num20_6,
#        amt2  LIKE type_file.num20_6)
#          #No.FUN-680103 end
#     create unique index r402_01 on r402_tmp(pjd01,pjd04)
#     LET l_sql  = " SELECT pjd01,pjd04,amt1,amt2 ",
#                  " FROM r402_tmp ",
#                  " WHERE pjd01 = ? "
#     PREPARE r402_preamt FROM l_sql
#     DECLARE r402_amtcur CURSOR FOR r402_preamt
#
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apjr402'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 90 END IF
#     FOR  l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
#     LET l_sql  = " SELECT apa00,apa01,apa13,apa14,apb24",
#                  " FROM apa_file,apb_file ",
#                  " WHERE apa01 = apb01 ",
#                  "   AND apa42 = 'N' ",
#                 #"   AND apa66 = ? AND apb21 = ?", #FUN-630055 remark
#                  "   AND apa66 = ? AND apb31 = ?", #FUN-630055
#                  "  ORDER BY 1,2 "
#     PREPARE r402_preapa FROM l_sql
#     DECLARE r402_apacur CURSOR FOR r402_preapa
#FUN-830101-mark-end-
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
     #End:FUN-980030
     #FUN-830101-start-
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     DROP TABLE r402_tmp
     CREATE TEMP TABLE r402_tmp
      ( pja01 LIKE pja_file.pja01,
        pja14 LIKE pja_file.pja14,
        amt1  LIKE type_file.num20_6,
        amt2  LIKE type_file.num20_6)
     CREATE UNIQUE INDEX r402_01 ON r402_tmp(pja01,pja14)
  
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                            
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                            
#               "        ?, ?, ?, ?)"                           #No.TQC-950071                                                                    
                "        ?, ?, ?, ?, ?)"                        #No.TQC-950071                                                                    
    PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                          
       CALL cl_err('insert_prep:',status,1)                                                                            
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B80031--add--
       EXIT PROGRAM
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?) "                                                                                                 
    PREPARE insert_prep1 FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)                                                                          
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B80031--add--
       EXIT PROGRAM
    END IF 
     LET l_sql = "SELECT pja01,pja02,pja05,pja08,pja09,pja14,pja15,pjb02,pjb03,pjd01,pjd02,pjd03,pjd04,COALESCE(pjd05,0)",
                 " FROM pja_file,pjb_file,pjd_file",
                 " WHERE pja01 = pjb01 AND pjb02 = pjd01 ",
                 " AND ",tm.wc CLIPPED
     PREPARE apjr402_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  
       EXIT PROGRAM 
     END IF
     DECLARE apjr402_curs1 CURSOR FOR apjr402_prepare1
     LET l_sql = "SELECT apa00,apa01,apa13,apa14,apb02,COALESCE(apb24,0),apb31",
                 " FROM apa_file,apb_file",
                 " WHERE apa01 = apb01 AND apa42 = 'N'",
                 " AND apb35 = ? AND apb36 = ? AND apb31 = ?" #FUN-A40073 mod  #MOD-A50138 add apb36 
                 #" AND apa66 = ? AND apb31 = ?"    #FUN-A40073 mark
     PREPARE apjr402_preparesub FROM l_sql                                                                                            
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1)                                                                                
       CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                               
       EXIT PROGRAM                                                                                                                 
     END IF                                                                                                                         
     DECLARE apjr402_curssub CURSOR FOR apjr402_preparesub
     FOREACH apjr402_curs1 INTO sr.*
     	 IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           INSERT INTO r402_tmp VALUES(sr.pja01,sr.pja14,sr.pjd05,0)
           IF SQLCA.sqlcode THEN
              UPDATE r402_tmp SET amt1 = amt1 + sr.pjd05
#                             WHERE pja01 = sr.pja01 AND pja14 = sr.pja15  #No.TQC-950071
                              WHERE pja01 = sr.pja01 AND pja14 = sr.pja14  #No.TQC-950071
           END IF  
   	 SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.pja09
     	 SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.pja08
         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = sr.pjd02 AND azf02='2'
         SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = sr.pjd04
    
         FOREACH apjr402_curssub USING sr.pja01,sr.pjb02,sr.pjd02  INTO sr1.*   #MOD-A50138 add sr.pjb02
     	    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
               IF sr1.apa00 MATCHES '2*' THEN LET sr1.apb24=sr1.apb24*-1 END IF
             
               INSERT INTO r402_tmp VALUES(sr.pja01,sr1.apa13,0,sr1.apb24)
               IF SQLCA.sqlcode THEN
                  UPDATE r402_tmp SET amt2 = amt2 + sr1.apb24
                                   WHERE pja01 = sr.pja01 AND pja14 = sr1.apa13
               END IF 
               SELECT azi04 INTO l_azi04_1 FROM azi_file WHERE azi01 = sr1.apa13
               SELECT azi07 INTO l_azi07 FROM azi_file WHERE azi01 = sr1.apa13
 
         EXECUTE insert_prep USING sr.pja01,sr.pja02,sr.pja05,sr.pja08,sr.pja09,
                                   sr.pja14,sr.pja15,sr.pjb02,sr.pjb03,sr.pjd03,sr.pjd04,sr.pjd05,
                                   sr1.apa01,sr1.apa13,sr1.apa14,sr1.apb02,sr1.apb24,sr1.apb31,
                                   l_gem02,l_gen02,l_azf03,l_azi04,l_azi04_1,l_azi05
                                   ,l_azi07                    #FUN-870151	 
         END FOREACH     
                 
         EXECUTE insert_prep USING sr.pja01,sr.pja02,sr.pja05,sr.pja08,sr.pja09,
                                   sr.pja14,sr.pja15,sr.pjb02,sr.pjb03,sr.pjd03,sr.pjd04,sr.pjd05,
                                   '','','','','','',
                                   l_gem02,l_gen02,l_azf03,l_azi04,l_azi04_1,l_azi05,
                                   l_azi07                    #FUN-870151	 
     END FOREACH
 
     LET l_sql = "SELECT pja01,pja14,SUM(amt1),SUM(amt2) FROM r402_tmp GROUP BY pja01,pja14"
     PREPARE apjr402_sumpre FROM l_sql            
     DECLARE apjr402_sum CURSOR FOR  apjr402_sumpre
     FOREACH apjr402_sum INTO l_pja01,l_pja14,l_amt1,l_amt2
         EXECUTE insert_prep1 USING l_pja01,l_pja14,l_amt1,l_amt2
     END FOREACH
     LET g_sql="SELECT  * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," | ",
               "SELECT  * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     IF g_zz05 = 'Y' THEN
     	  CALL cl_wcchp(tm.wc,"pja01,pjb02,pja05,pja09,pja08") RETURNING l_wc
     ELSE
        LET l_wc = ' '
     END IF
     CALL cl_prt_cs3('apjr402','apjr402',g_sql,l_wc)
     #FUN-830101--end--
#FUN-830101-mark-start-
#     LET l_sql  = " SELECT pja_file.*,pjd_file.*",
#                  " FROM pja_file,pjd_file ",
#                  " WHERE  pja01 = pjd01 ",
#                  " AND ",tm.wc CLIPPED
# 
#
#     PREPARE r402_p1 FROM l_sql
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
#           EXIT PROGRAM
#              
#        END IF
#     DECLARE r402_c1 CURSOR FOR r402_p1
#
#     CALL cl_outnam('apjr402') RETURNING l_name
#     START REPORT r402_rep TO l_name
#     LET g_pageno = 0
#     FOREACH r402_c1 INTO sr.*
#         IF SQLCA.sqlcode != 0 THEN
#             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#         END IF
#         INSERT INTO r402_tmp VALUES (sr.pjd.pjd01,
#                                      sr.pjd.pjd04,
#                                      sr.pjd.pjd05,0)
#         IF SQLCA.sqlcode THEN
#            UPDATE r402_tmp SET amt1 = amt1 + sr.pjd.pjd05
#                          WHERE pjd01 = sr.pjd.pjd01
#                            AND pjd04 = sr.pjd.pjd04
#         END IF
#         OUTPUT TO REPORT r402_rep(sr.*)
#     END FOREACH
#     FINISH REPORT r402_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-830101-mark-end-
END FUNCTION
 
#FUN-830101-mark-start-
#REPORT r402_rep(sr)
#   DEFINE
#          l_last_sw      LIKE type_file.chr1,        #No.#FUN-680103 VARCHAR(1)
#          l_sw           LIKE type_file.chr1,        #No.#FUN-680103 VARCHAR(1) 
#          l_cnt,l_cnt2   LIKE type_file.num5,        #No.FUN-680103 SMALLINT
#          sr         RECORD
#                     pja      RECORD  LIKE pja_file.*,
#                     pjd      RECORD  LIKE pjd_file.*
#                     END RECORD,
#          l_apa00    LIKE apa_file.apa00,
#          l_apa01    LIKE apa_file.apa01,
#          l_apa13    LIKE apa_file.apa13,
#          l_apa14    LIKE apa_file.apa14,
#          l_apb24    LIKE apb_file.apb24,
#          l_pjd01    LIKE pjd_file.pjd01,
#          l_pjd04    LIKE pjd_file.pjd04,
#          l_gen02    LIKE gen_file.gen02,
#          l_gem02    LIKE gem_file.gem02,
# #         t_azi03         LIKE azi_file.azi03,     #原幣 #No.CHI-6A0004
# #         t_azi04         LIKE azi_file.azi04,     #     #No.CHI-6A0004
# #         t_azi05         LIKE azi_file.azi05,     #     #No.CHI-6A0004
#           l_sumpjd05      LIKE pjd_file.pjd05,     #預估原幣金額 #MOD-530209
#          #l_amt1,l_amt2   DEC(20,6)                #MOD-530209
#           l_amt1,l_amt2   LIKE type_file.num20_6   #No.#FUN-680103 DEC(20,6) 
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pja.pja01,sr.pjd.pjd03,sr.pjd.pjd04
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.pja.pja04
#      IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.pja.pja03
#      IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
#      PRINT COLUMN  1,g_x[8] CLIPPED,sr.pja.pja01,
#            COLUMN 36,g_x[9]  CLIPPED,sr.pja.pja03,'   ',l_gem02,
#            COLUMN 78,g_x[10] CLIPPED,sr.pja.pjaconf
#      PRINT COLUMN  1,g_x[11] CLIPPED,sr.pja.pja02,
#            COLUMN 36,g_x[12] CLIPPED ,sr.pja.pja04,' ',l_gen02,
#            COLUMN 78,g_x[13] CLIPPED ,sr.pja.pjaclose
#      PRINT g_x[14] CLIPPED
#      PRINT sr.pja.pja051,COLUMN 41,sr.pja.pja052
#      PRINT sr.pja.pja053,COLUMN 41,sr.pja.pja054
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.pja.pja01
#      SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF sr.pjd.pjd03
#      LET l_sw = 'N'
#
#   AFTER GROUP OF sr.pjd.pjd04
#       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位   #No.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.pjd.pjd04
#       LET l_sumpjd05 = GROUP SUM(sr.pjd.pjd05)
#       IF l_sw = 'Y' THEN PRINT ' ' END IF
#       PRINT column g_c[31],sr.pjd.pjd03,
#             column g_c[32],sr.pjd.pjd04,
#             column g_c[33],cl_numfor(sr.pjd.pjd041,33,2),
#             column g_c[34],cl_numfor(l_sumpjd05,34,t_azi04);  #No.CHI-6A0004
#       LET l_sw = 'Y'
#
#   AFTER GROUP OF sr.pjd.pjd03
#       LET l_cnt = 0
#       FOREACH r402_apacur
#       USING sr.pjd.pjd01,sr.pjd.pjd03
#       INTO l_apa00,l_apa01,l_apa13,l_apa14,l_apb24
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('r402_apacur',SQLCA.sqlcode,0)
#            EXIT FOREACH
#         END IF
#         IF l_apa00 matches '2*' THEN LET l_apb24 = l_apb24 * -1 END IF
#         INSERT INTO r402_tmp VALUES (sr.pjd.pjd01,
#                                      l_apa13,0,l_apb24)
#         IF SQLCA.sqlcode THEN
#            UPDATE r402_tmp SET amt2 = amt2 + l_apb24
#                          WHERE pjd01 = sr.pjd.pjd01
#                            AND pjd04 = l_apa13         #NO:6871sr.pjd.pjd04
#         END IF
#         IF l_cnt = 1 THEN PRINT sr.pjd.pjd031 END IF
#         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位   #No.CHI-6A0004
#           FROM azi_file
#          WHERE azi01=l_apa13
#          PRINT COLUMN g_c[35],l_apa13,
#                COLUMN g_c[36],cl_numfor(l_apa14,36,2),
#                COLUMN g_c[37],cl_numfor(l_apb24,37,t_azi04),  #No.CHI-6A0004
#                COLUMN g_c[38],l_apa01
#         LET l_cnt = l_cnt + 1
#       END FOREACH
#       IF l_cnt = 1 THEN PRINT sr.pjd.pjd031 END IF
#       IF l_cnt = 0 THEN
#          PRINT ' '
#          PRINT sr.pjd.pjd031
#       END IF
#
#   AFTER GROUP OF sr.pja.pja01
#       #-->依幣別列印小計
#       LET l_cnt2 = 0
#       FOREACH r402_amtcur
#       USING sr.pja.pja01
#       INTO l_pjd01,l_pjd04,l_amt1,l_amt2
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('r402_apacur',SQLCA.sqlcode,0)
#            EXIT FOREACH
#         END IF
#         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位  #No.CHI-6A0004
#           FROM azi_file
#          WHERE azi01=l_pjd04
#         IF l_cnt2 = 0 THEN PRINT COLUMN g_c[31],g_x[15] clipped; END IF
#         PRINT COLUMN g_c[32],l_pjd04,
#               COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi05),   #No.CHI-6A0004
#               COLUMN g_c[37],cl_numfor(l_amt2,37,t_azi05)    #No.CHI-6A0004
#         LET l_cnt2 = l_cnt2 + 1
#       END FOREACH
#
#   ON LAST ROW
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#FUN-830101-mark-end-
