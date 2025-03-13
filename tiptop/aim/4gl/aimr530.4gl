# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimr530.4gl
# Descriptions...: 借料狀況表
# Return code....:
# Date & Author..: 92/06/10 By Lin
# Modify.........: 92/11/16 By Pin
# Modify.........: No.FUN-4A0048 04/10/12 By Carol 廠商,料件,借料單號,借料人員開窗
# Modify.........: No.MOD-4B0049 04/11/12 By Mandy 是否列印償還資料狀況(Y/N),選'Y'時,印出的資料不正確!
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將報表列印有寫到PRINT ...,g_x[14][1,30],...,g_x[14][31,35]的拆成不同的g_x[14],g_x[15]
# Modify.........: No.FUN-530001 05/03/01 By Mandy 報表單價,金額寬度修正,並加上cl_numfor()
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah
# Modify.........: No.FUN-660080 06/06/14 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710084 07/02/08 By Elva 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加 CR 參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0189 09/10/30 By wujie 5.2SQL转标准语法
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
            wc   STRING,                  # Where Condition  #TQC-630166
            a    LIKE type_file.chr1,     # 是否僅列印尚未償還資料  #No.FUN-690026 VARCHAR(1)
            b    LIKE type_file.chr1,     # 是否列印還料資料  #No.FUN-690026 VARCHAR(1)
            more LIKE type_file.chr1      # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE    l_table     STRING,                       ### FUN-710084 ###
          l_table1    STRING,                       ### FUN-710084 ### 
          l_table2    STRING,                       ### FUN-710084 ### 
          g_sql       STRING                        ### FUN-710084 ###         
DEFINE    g_str       STRING                        ### FUN-710084 ### 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   ### FUN-710084 Start ### 
   LET g_sql =   "imo03.imo_file.imo03,imo04.imo_file.imo04,",
                 "imp01.imp_file.imp01,imp02.imp_file.imp02,",
                 "imp03.imp_file.imp03,imp11.imp_file.imp11,",
                 "imp12.imp_file.imp12,imp13.imp_file.imp13,",
                 "imo02.imo_file.imo02,gen02.gen_file.gen02,",
                 "imp04.imp_file.imp04,imp05.imp_file.imp05,",
                 "imp08.imp_file.imp08,",
                 "imp09.imp_file.imp09,imp06.imp_file.imp06,",
                 "qty.imp_file.imp04,imp07.imp_file.imp07,",
                 "imp14.imp_file.imp14,",
                 "azi03.azi_file.azi03,azi04.azi_file.azi04 " 
 
    LET l_table = cl_prt_temptable('aimr530',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
    LET g_sql =  "imq03.imq_file.imq03,imq04.imq_file.imq04,",
                 "gen02_1.gen_file.gen02,imq01.imq_file.imq01,",
                 "imq02.imq_file.imq02,imr09.imr_file.imr09,",
                 "imq07.imq_file.imq07,imq06.imq_file.imq06,",
                 "imq07f.imq_file.imq07,imq08.imq_file.imq08,",
                 "imq09.imq_file.imq09,imq10.imq_file.imq10"
    LET l_table1 = cl_prt_temptable('aimr5301',g_sql) CLIPPED   # 產生Temp Table
    IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
    LET g_sql =  "imq03.imq_file.imq03,imq04.imq_file.imq04,",
                 "gen02_2.gen_file.gen02,imq01_2.imq_file.imq01,",
                 "imq02_2.imq_file.imq02,imr09_2.imr_file.imr09,",
                 "imq07_2.imq_file.imq07,",
                 "imq11.imq_file.imq11,imq12.imq_file.imq12"  
    LET l_table2 = cl_prt_temptable('aimr5302',g_sql) CLIPPED   # 產生Temp Table
    IF l_table2 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   ### FUN-710084 End ### 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r530_tm()	        	# Input print condition
      ELSE CALL aimr530()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r530_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r530_w AT p_row,p_col
        WITH FORM "aim/42f/aimr530"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imo03,imo04,imp03,imo01,imo02,imo06,
                              imp06
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
 
#FUN-4A0048
      ON ACTION controlp
           CASE WHEN INFIELD(imo03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pmc"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imo03
                     NEXT FIELD imo03
                WHEN INFIELD(imp03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ima"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imp03
                     NEXT FIELD imp03
                WHEN INFIELD(imo01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_imo1"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imo01
                     NEXT FIELD imo01
                WHEN INFIELD(imo06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO imo06
                     NEXT FIELD imo06
           END CASE
##
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.more   # Condition
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES "[YN]"
            THEN NEXT FIELD a
         END IF
 
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES "[YN]"
            THEN NEXT FIELD b
         END IF
 
      AFTER FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW r530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr530'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr530','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr530',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r530_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr530()
   ERROR ""
END WHILE
   CLOSE WINDOW r530_w
END FUNCTION
 
FUNCTION aimr530()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#          l_time	LIKE type_file.chr8,  	# Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
          l_sql         STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr		LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                        imo03 LIKE imo_file.imo03,  #廠商編號
                        imo04 LIKE imo_file.imo04,  #廠商簡稱
                        imo02 LIKE imo_file.imo02,  #借料日期
                        imp01 LIKE imp_file.imp01,  #借料單號  #No.MOD-4B0049
                        imo06 LIKE imo_file.imo06,  #借料人員
                        gen02 LIKE gen_file.gen02,  #借料人員
                        imp02 LIKE imp_file.imp02,  #項次
                        imp03 LIKE imp_file.imp03,  #料件編號
                        imp04 LIKE imp_file.imp04,  #借料數量
                        imp05 LIKE imp_file.imp05,  #借料單位
                        imp06 LIKE imp_file.imp06,  #預計償還日
                        imp07 LIKE imp_file.imp07,  #結案否 #No.MOD-4B0049
                        imp08 LIKE imp_file.imp08,  #已償還數量#No.MOD-4B0049
                        imp09 LIKE imp_file.imp09,  #預計單位成本
                        imp10 LIKE imp_file.imp10,  #金額=imp04*imp09 #No.MOD-4B0049
                        imp11 LIKE imp_file.imp11,  #倉庫代號
                        imp12 LIKE imp_file.imp12,  #存放位置
                        imp13 LIKE imp_file.imp13,  #存放批號
                        imp14 LIKE imp_file.imp14,  #庫存單位
                        d1    LIKE type_file.chr1,  #償還否 #No.MOD-4B0049  #No.FUN-690026 VARCHAR(1)
                        qty   LIKE imp_file.imp04,  #入庫量imp04*imp14_fac
                        imp48 LIKE imp_file.imp04   #未還量imp04-imp08
                        END RECORD,
#FUN-710084  --begin
          l_imq1   RECORD
                     imr09   LIKE imr_file.imr09,
                     gen02   LIKE gen_file.gen02,
                     imq01   LIKE imq_file.imq01,
                     imq02   LIKE imq_file.imq02,
                     imq07f  LIKE imq_file.imq07,#imq07/imq06_fac,
                     imq07   LIKE imq_file.imq07,
                     imq06   LIKE imq_file.imq06,
                     imq08   LIKE imq_file.imq08,
                     imq09   LIKE imq_file.imq09,
                     imq10   LIKE imq_file.imq10
                   END RECORD ,
          l_imq2   RECORD
                     imr09   LIKE imr_file.imr09,
                     gen02   LIKE gen_file.gen02,
                     imq01   LIKE imq_file.imq01,
                     imq02   LIKE imq_file.imq02,
                     imq07   LIKE imq_file.imq07,
                     imq11   LIKE imq_file.imq11,
                     imq12   LIKE imq_file.imq12
                   END RECORD  
#FUN-710084  --end
 
     CALL cl_del_data(l_table)        #FUN-710084
     CALL cl_del_data(l_table1)        #FUN-710084
     CALL cl_del_data(l_table2)        #FUN-710084
 
   ### FUN-710084 Start ### 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
       EXIT PROGRAM
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?)"
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep1:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
       EXIT PROGRAM
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?) " 
    PREPARE insert_prep2 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep2:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
       EXIT PROGRAM
    END IF
   ### FUN-710084 End ### 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr530'
    #FUN-530001
    #小數位----------------------------------------------
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,zai05
#     INTO g_azi03,g_azi04,g_azi05
#     FROM azi_file
#     WHERE azi01=g_azi.azi17
#NO.CHI-6A0004--END 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imouser', 'imogrup')
     #End:FUN-980030
 
  LET l_sql = "SELECT ",
                 " imo03,imo04,imo02,imp01,imo06,gen02, ",
                 " imp02,imp03,imp04,imp05,imp06,imp07,imp08,imp09,",
                 " imp10,imp11,imp12,imp13,imp14,imp07,imp04*imp14_fac, ",
                #" (imp04-imp08) ,imr09 ",
                  " (imp04-imp08)        ", #No.MOD-4B0049
                #"  FROM imo_file,imp_file,OUTER imr_file,OUTER gen_file", #NO:7513
#No.TQC-9A0189 --begin
                 "  FROM imo_file LEFT OUTER JOIN gen_file ON imo06 = gen01 ,imp_file", #NO:7513
                 " WHERE ",tm.wc CLIPPED, " AND imo01=imp01 ",
#                "  FROM imo_file,imp_file,OUTER gen_file", #NO:7513
#                " WHERE ",tm.wc CLIPPED, " AND imo01=imp01 ",
#                #" AND imo01 = imr_file.imr05  ", #No.MOD-4B0049
#                " AND imo_file.imo06=gen_file.gen01 ",
#No.TQC-9A0189 --end
                #" AND imopost !='X' " #mandy
                 " AND imoconf !='X' " #FUN-660080
	 IF tm.a='Y' THEN     #僅印尚未償還資料
    	     LET l_sql = l_sql CLIPPED, " AND imp07 NOT IN ('y','Y') "
         END IF
     LET l_sql = l_sql CLIPPED," ORDER BY imo03,imo02 "
     PREPARE r530_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r530_curs1 CURSOR FOR r530_prepare1
 
     IF tm.b = 'Y' THEN
      # LET  l_sql = "SELECT * FROM imq_file ",
       #             #" WHERE imq01 = ? AND imq02 = ? ", #MOD-4B0049
       #              " WHERE imq03 = ? AND imq04 = ? ", #MOD-4B0049
      #              " ORDER BY imq03 "
      # PREPARE r530_imq  FROM l_sql
      # IF SQLCA.sqlcode != 0 THEN
      #    CALL cl_err('prepare:',SQLCA.sqlcode,1)
      #    EXIT PROGRAM
      # END IF
      # DECLARE r530_curs2 CURSOR FOR r530_imq
       #No.MOD-4B0049 改成下面二段CURSOR
        LET  l_sql = "SELECT imr09,gen02,imq01,imq02,imq07/imq06_fac,imq07,imq06,imq08,imq09,imq10 ",
#No.TQC-9A0189 --begin
                     "  FROM imr_file LEFT OUTER JOIN gen_file ON imr03 = gen01,imq_file",
                     " WHERE imq03 = ? ",
                     "   AND imq04 = ? ",
                     "   AND imr01 = imq01 ",
                     "   AND imr00 = '1' ", #原數償還
#                    "  FROM imr_file,imq_file,OUTER gen_file ",
#                    " WHERE imq03 = ? ",
#                    "   AND imq04 = ? ",
#                    "   AND imr01 = imq01 ",
#                    "   AND imr00 = '1' ", #原數償還
#                    "   AND imr_file.imr03 = gen_file.gen01 ",
#No.TQC-9A0189 --end
                     "   AND imrpost = 'Y' ",
                     " ORDER BY imr09 "
        PREPARE r530_imq1  FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:r530_imq1',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
           EXIT PROGRAM
        END IF
        DECLARE r530_cs_imq1 CURSOR FOR r530_imq1
 
        LET  l_sql = "SELECT imr09,gen02,imq01,imq02,imq07,imq11,imq12 ",
#No.TQC-9A0189 --begin
                     "  FROM imr_file LEFT OUTER JOIN gen_file ON imr03 = gen01,imq_file",
                     " WHERE imq03 = ? ",
                     "   AND imq04 = ? ",
                     "   AND imr01 = imq01 ",
                     "   AND imr00 = '2' ", #原價償還
#                    "  FROM imr_file,imq_file,OUTER gen_file ",
#                    " WHERE imq03 = ? ",
#                    "   AND imq04 = ? ",
#                    "   AND imr01 = imq01 ",
#                    "   AND imr00 = '2' ", #原價償還
#                    "   AND imr_file.imr03 = gen_file.gen01 ",
#No.TQC-9A0189 --end
                     "   AND imrpost = 'Y' ",
                     " ORDER BY imr09 "
        PREPARE r530_imq2  FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:r530_imq2',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
           EXIT PROGRAM
        END IF
        DECLARE r530_cs_imq2 CURSOR FOR r530_imq2
         #No.MOD-4B0049(end)
     END IF
#FUN-710084 --begin
#    CALL cl_outnam('aimr530') RETURNING l_name  
#No.FUN-550029-begin
    #LET g_len = 160    #TQC-5B0019 mark
#    FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550029-end
#    START REPORT r530_rep TO l_name
 
#    LET g_pageno = 0
     FOREACH r530_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
	   IF sr.imo03 IS NULL THEN LET sr.imo03 = ' ' END IF
       #IF sr.imo02 IS NULL THEN LET sr.imo02 = ' ' END IF #No.MOD-4B0049
       #LET sr.d1=sr.imp07 #No.MOD-4B0049
#      OUTPUT TO REPORT r530_rep(sr.*)
       EXECUTE insert_prep USING sr.imo03,sr.imo04,sr.imp01,sr.imp02,sr.imp03,sr.imp11,
                                 sr.imp12,sr.imp13,sr.imo02,sr.gen02,sr.imp04,sr.imp05,sr.imp08,
                                 sr.imp09,sr.imp06,sr.qty,sr.imp07,sr.imp14,g_azi03,g_azi04 
       IF  tm.b MATCHES'[yY]' THEN #列印還料明細
            #原數償還
            FOREACH r530_cs_imq1 USING sr.imp01,sr.imp02 INTO l_imq1.*
             IF SQLCA.sqlcode  THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             EXECUTE insert_prep1 USING sr.imp01,sr.imp02,
                                       l_imq1.gen02,l_imq1.imq01,l_imq1.imq02,
                                       l_imq1.imr09,l_imq1.imq07,l_imq1.imq06,
                                       l_imq1.imq07f,l_imq1.imq08,l_imq1.imq09,
                                       l_imq1.imq10
            END FOREACH
            #原價償還
            FOREACH r530_cs_imq2 USING sr.imp01,sr.imp02 INTO l_imq2.*
             IF SQLCA.sqlcode  THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             EXECUTE insert_prep2 USING sr.imp01,sr.imp02,
                                       l_imq2.gen02,l_imq2.imq01,l_imq2.imq02,
                                       l_imq2.imr09,l_imq2.imq07,
                                       l_imq2.imq11,l_imq2.imq12
            END FOREACH
       END IF
     END FOREACH
 
#    FINISH REPORT r530_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET l_sql = " SELECT A.*,B.gen02_1,B.imq01,B.imq02,B.imr09,B.imq07f,",
               "        B.imq07,B.imq06,B.imq08,B.imq09,B.imq10,",
               "        C.gen02_2,C.imq01_2,C.imq02_2,C.imr09_2,",
               "        C.imq07_2,C.imq11,C.imq12",
#TQC-730088  # "   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",
               "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B  ",
               "     ON A.imp01 = B.imq03 ",
               "    AND A.imp02 = B.imq04 ",
               "   LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C",
               "    ON  A.imp01 = C.imq03 ",
               "    AND A.imp02 = C.imq04 "
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     LET g_str = tm.b
     #是否列印選擇條件                                                            
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'imo03,imo04,imp03,imo01,imo02,imo06,imp06')
             RETURNING tm.wc                                                      
        LET g_str = g_str ,";",tm.wc                                              
     END IF
 # CALL cl_prt_cs3('aimr530',l_sql,g_str)   #TQC-730088
   CALL cl_prt_cs3('aimr530','aimr530',l_sql,g_str)    
#FUN-710084 --end
END FUNCTION
 
#FUN-710084 --begin
#REPORT r530_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr            RECORD
#                        imo03 LIKE imo_file.imo03,  #廠商編號
#                        imo04 LIKE imo_file.imo04,  #廠商簡稱
#                        imo02 LIKE imo_file.imo02,  #借料日期
#                        imp01 LIKE imp_file.imp01,  #借料單號  #No.MOD-4B0049
#                        imo06 LIKE imo_file.imo06,  #借料人員
#                        gen02 LIKE gen_file.gen02,  #借料人員
#                        imp02 LIKE imp_file.imp02,  #項次
#                        imp03 LIKE imp_file.imp03,  #料件編號
#                        imp04 LIKE imp_file.imp04,  #借料數量
#                        imp05 LIKE imp_file.imp05,  #借料單位
#                        imp06 LIKE imp_file.imp06,  #預計償還日
#                        imp07 LIKE imp_file.imp07,  #結案否 #No.MOD-4B0049
#                        imp08 LIKE imp_file.imp08,  #已償還數量#No.MOD-4B0049
#                        imp09 LIKE imp_file.imp09,  #預計單位成本
#                        imp10 LIKE imp_file.imp10,  #金額=imp04*imp09 #No.MOD-4B0049
#                        imp11 LIKE imp_file.imp11,  #倉庫代號
#                        imp12 LIKE imp_file.imp12,  #存放位置
#                        imp13 LIKE imp_file.imp13,  #存放批號
#                        imp14 LIKE imp_file.imp14,  #庫存單位
#                        d1    LIKE type_file.chr1,  #償還否 #No.MOD-4B0049  #No.FUN-690026 VARCHAR(1)
#                        qty   LIKE imp_file.imp04,  #入庫量imp04*imp14_fac
#                        imp48 LIKE imp_file.imp04   #未還量imp04-imp08
#                        END RECORD ,
#         #l_imq    RECORD    LIKE imq_file.*,#No.MOD-4B0049
#         #No.MOD-4B0049
#         l_imq1   RECORD
#                    imr09   LIKE imr_file.imr09,
#                    gen02   LIKE gen_file.gen02,
#                    imq01   LIKE imq_file.imq01,
#                    imq02   LIKE imq_file.imq02,
#                    imq07f  LIKE imq_file.imq07,#imq07/imq06_fac,
#                    imq07   LIKE imq_file.imq07,
#                    imq06   LIKE imq_file.imq06,
#                    imq08   LIKE imq_file.imq08,
#                    imq09   LIKE imq_file.imq09,
#                    imq10   LIKE imq_file.imq10
#                  END RECORD ,
#         l_imq2   RECORD
#                    imr09   LIKE imr_file.imr09,
#                    gen02   LIKE gen_file.gen02,
#                    imq01   LIKE imq_file.imq01,
#                    imq02   LIKE imq_file.imq02,
#                    imq07   LIKE imq_file.imq07,
#                    imq11   LIKE imq_file.imq11,
#                    imq12   LIKE imq_file.imq12
#                  END RECORD ,
#          #No.MOD-4B0049(end)
#         l_cnt    LIKE type_file.num5     #No.FUN-690026 SMALLINT
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#   ORDER BY sr.imo04,sr.imo02,sr.imp01,sr.imp02 #No.MOD-4B0049
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
# #No.MOD-4B0049 add
#      PRINT g_x[11] CLIPPED,sr.imo04," (",sr.imo03,") "
##No.FUN-550029-begin
#	  PRINT g_x[12] ,
#         #start TQC-5B0019
#         #      COLUMN 47,g_x[13] CLIPPED,  #MOD-520129
#         #      COLUMN 72,g_x[25] CLIPPED,  #MOD-520129
#         #      COLUMN 86,g_x[26] CLIPPED,  #MOD-520129
#         #      COLUMN 100,g_x[14],
#         #      COLUMN 155, g_x[15] CLIPPED
# 	 #PRINT COLUMN 72,g_x[16] CLIPPED,  #MOD-520129
#         #      COLUMN 86,g_x[28] CLIPPED,  #MOD-520129
#         #      COLUMN 100,g_x[29] CLIPPED, #MOD-520129
#         #      COLUMN 113,g_x[17] CLIPPED, #MOD-520129
#         #      COLUMN 155,g_x[30] CLIPPED  #MOD-520129
#                COLUMN  43,g_x[13] CLIPPED, #MOD-520129
#                COLUMN  84,g_x[25] CLIPPED, #MOD-520129
#                COLUMN  98,g_x[26] CLIPPED, #MOD-520129
#                COLUMN 112,g_x[14],
#                COLUMN 167, g_x[15] CLIPPED
# 	  PRINT COLUMN  84,g_x[16] CLIPPED, #MOD-520129
#                COLUMN  98,g_x[28] CLIPPED, #MOD-520129
#                COLUMN 112,g_x[29] CLIPPED, #MOD-520129
#                COLUMN 125,g_x[17] CLIPPED, #MOD-520129
#                COLUMN 167,g_x[30] CLIPPED  #MOD-520129
#         #end TQC-5B0019
#      PRINT g_dash[1,g_len]
# #No.MOD-4B0049 add(end)
#
#   BEFORE GROUP OF sr.imo04   #廠商編號
#      IF (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# {#No.MOD-4B0049 此段改到PAGE HEADER做
#      PRINT g_x[11] CLIPPED,sr.imo04," (",sr.imo03,") "
#	  PRINT g_x[12] ,
#                COLUMN 41,g_x[13][1,8],
#                COLUMN 66,g_x[13][10,17],
#                COLUMN 80,g_x[13][19,26],
#                COLUMN 94,g_x[14],
#                COLUMN 149, g_x[15] CLIPPED
#	  PRINT COLUMN 66,g_x[16][1,8],
#                COLUMN 80,g_x[16][10,17],
#                COLUMN 94,g_x[16][19,30],
#                COLUMN 107,g_x[17][1,13],
#                COLUMN 149,g_x[17][16,19]
#      PRINT g_dash[1,g_len]
#}
#
#   BEFORE GROUP OF sr.imo02    #借料日期
#      PRINT sr.imo02;
#
#    BEFORE GROUP OF sr.imp01    #借料單號 #No.MOD-4B0049
#       PRINT COLUMN 10,sr.imp01 CLIPPED,          #No.MOD-4B0049
#            COLUMN 27,sr.gen02 CLIPPED;
#
#   ON EVERY ROW
#      IF sr.d1='Y' THEN   #已償還
#         PRINT COLUMN 36,'*';
#      END IF
#      PRINT COLUMN 37,sr.imp02 USING "###&",
#     #strat TQC-5B0019
#     #      COLUMN 42,sr.imp03 CLIPPED,
#     #      COLUMN 63,sr.imp04 USING "------------&.&&&",'/',sr.imp05,
#     #      COLUMN 86,sr.imp06  CLIPPED,
#     #      COLUMN 95,cl_numfor(sr.imp09,16,g_azi03), #FUN-530001
#     #      COLUMN 115,sr.d1 CLIPPED, #No.MOD-4B0049
#     #      COLUMN 122,sr.imp11 CLIPPED,
#     #      COLUMN 131,sr.imp12 CLIPPED,
#     #      COLUMN 144,sr.qty   USING "------------&.&&&"
#     #PRINT COLUMN 63 ,sr.imp48 USING "------------&.&&&",
#     #      #COLUMN 80,sr.imr09, #No.MOD-4B0049
#     #      COLUMN 122,sr.imp13 CLIPPED,
#     #      COLUMN 156,sr.imp14
#            COLUMN  43,sr.imp03 CLIPPED,
#            COLUMN  75,sr.imp04 USING "------------&.&&&",'/',sr.imp05,
#            COLUMN  98,sr.imp06 CLIPPED,
#            COLUMN 107,cl_numfor(sr.imp09,16,g_azi03), #FUN-530001
#            COLUMN 127,sr.d1 CLIPPED, #No.MOD-4B0049
#            COLUMN 134,sr.imp11 CLIPPED,
#            COLUMN 143,sr.imp12 CLIPPED,
#            COLUMN 156,sr.qty   USING "------------&.&&&"
#      PRINT COLUMN  75,sr.imp48 USING "------------&.&&&",
#            COLUMN 134,sr.imp13 CLIPPED,
#            COLUMN 167,sr.imp14
#     #end TQC-5B0019
#
# #No.MOD-4B0049 MARK掉改成下段程式
##     IF  tm.b MATCHES'[yY]'  #列印還料明細
##       THEN
##        LET l_cnt = 1
##        FOREACH r530_curs2
##        USING sr.imo01,sr.imp02
##        INTO l_imq.*
##         IF SQLCA.sqlcode  THEN
##            CALL cl_err('foreach:',SQLCA.sqlcode,1)
##            EXIT FOREACH
##         END IF
##         IF l_cnt = 1 THEN
##                PRINT COLUMN 74,g_dash[1,26],g_x[18] CLIPPED,g_dash[1,26]
##         END IF
##         CALL s_impsta(l_imq.imq09) RETURNING l_sta    #償還方式說明
##         PRINT COLUMN 36,l_imq.imq12 ,
##               COLUMN 101,l_imq.imq04,' ',l_imq.imq05,' ',
##                         l_imq.imq08 USING "-----&.&&"
##         PRINT COLUMN 73,l_imq.imq10 ,
##               COLUMN 81,l_imq.imq11 USING '------&.&&',' ',l_sta,
##               COLUMN 101,l_imq.imq06,
##               COLUMN 128,sr.imp05
##         LET l_cnt = l_cnt + 1
##        END FOREACH
##     END IF
#      IF  tm.b MATCHES'[yY]' THEN #列印還料明細
#           #原數償還
#           LET l_cnt = 1
#           FOREACH r530_cs_imq1 USING sr.imp01,sr.imp02 INTO l_imq1.*
#            IF SQLCA.sqlcode  THEN
#               CALL cl_err('foreach:',SQLCA.sqlcode,1)
#               EXIT FOREACH
#            END IF
#            IF l_cnt = 1 THEN
#                PRINT COLUMN 32,g_x[19] CLIPPED
#                PRINT COLUMN 32,g_x[21] CLIPPED,
#                      COLUMN 66,g_x[22] CLIPPED,
#                      COLUMN 119,g_x[23] CLIPPED
#                PRINT COLUMN 32,"-------- -------- --------------------- --------- -------------- ---------- ---------- ------------------------"
#            END IF
#            PRINT COLUMN 32,l_imq1.imr09 CLIPPED,
#                  COLUMN 41,l_imq1.gen02 CLIPPED,
#                  COLUMN 50,l_imq1.imq01 CLIPPED,
#                  COLUMN 66,'/',l_imq1.imq02 USING '####',
#                  COLUMN 72,l_imq1.imq07f USING '-----&.##',
#                  COLUMN 81,l_imq1.imq07  USING '-----&.##',
#                  COLUMN 91,'/',l_imq1.imq06 CLIPPED,
#                  COLUMN 97,l_imq1.imq08 CLIPPED,
#                  COLUMN 108,l_imq1.imq09 CLIPPED,
#                  COLUMN 121,l_imq1.imq10
#            LET l_cnt = l_cnt + 1
#           END FOREACH
#           #原價償還
#           LET l_cnt = 1
#           FOREACH r530_cs_imq2 USING sr.imp01,sr.imp02 INTO l_imq2.*
#            IF SQLCA.sqlcode  THEN
#               CALL cl_err('foreach:',SQLCA.sqlcode,1)
#               EXIT FOREACH
#            END IF
#            IF l_cnt = 1 THEN
#                PRINT COLUMN 32,g_x[20] CLIPPED
#                PRINT COLUMN 32,g_x[21] CLIPPED,
#                      COLUMN 66,g_x[24] CLIPPED #FUN-530001
#                PRINT COLUMN 32,"-------- -------- --------------------- --------- ---------------- ------------------" #FUN-530001
#            END IF
#            PRINT COLUMN 32,l_imq2.imr09 CLIPPED,
#                  COLUMN 41,l_imq2.gen02 CLIPPED,
#                  COLUMN 50,l_imq2.imq01 CLIPPED,
#                  COLUMN 66,'/',l_imq2.imq02 USING '####',
#                  COLUMN 72,l_imq2.imq07 USING '-----&.##',
#                  COLUMN 82,cl_numfor(l_imq2.imq11,15,g_azi03), #FUN-530001
#                  COLUMN 98,cl_numfor(l_imq2.imq12,18,g_azi04)  #FUN-530001
#            LET l_cnt = l_cnt + 1
#           END FOREACH
#           PRINT ""
#      END IF
##No.FUN-550029-end
#
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN			# for 132
##		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#FUN-710084 --end
 
#Patch....NO.TQC-610036 <> #
