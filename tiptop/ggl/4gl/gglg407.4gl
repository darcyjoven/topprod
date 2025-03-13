# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: gglg407.4gl
# Descriptions...: 科目餘額套表
# Date & Author..: 06/10/12 by Xufeng
# Modify.........: No.TQC-710102 07/03/19 By xufeng 異動資料有漏打印的情況
# Modify.........: No.FUN-710091 07/02/14 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-860252 09/02/18 By chenl  增加打印時是否打印貨幣性科目或全部科目的選擇。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 10/02/23 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B50018 11/06/03 By xumm CR轉GRW
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			#Print condition RECORD
             # wc       LIKE type_file.chr1000,
              wc       STRING,     #NO.FUN-910082
              yy,m1,m2 LIKE type_file.num5,
              a        LIKE type_file.num5,
              y        LIKE type_file.num5,        #層級
              n        LIKE type_file.chr1,         #print 外幣
              b        LIKE type_file.chr4,         #幣別
              h        LIKE type_file.chr1,         #MOD-860252
              more     LIKE type_file.chr1,         #是輸入其它特殊列印條件
              book_no  LIKE aba_file.aba00 #帳別編號
              END RECORD,
          g_tah4ysum    LIKE tah_file.tah09,
          g_tah5bsum    LIKE tah_file.tah04,
          g_tah7ysum    LIKE tah_file.tah09,
          g_tah8bsum    LIKE tah_file.tah04,
          g_dash1_1     LIKE type_file.chr1000 ,
          g_tah58       LIKE tah_file.tah04,
          g_aah1jsum    LIKE aah_file.aah04,
          g_aah1dsum    LIKE aah_file.aah05,
          g_aah04sum    LIKE aah_file.aah04,
          g_aah05sum    LIKE aah_file.aah05,
          g_aah3jsum    LIKE aah_file.aah04,
          g_aah3dsum    LIKE aah_file.aah05 
          
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_aaa01         LIKE aaa_file.aaa01
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5  #count/index for any purpose
#No.FUN-710091  --begin
DEFINE   l_table1    STRING
DEFINE   l_table2    STRING
DEFINE   l_table3    STRING
DEFINE   g_sql       STRING
DEFINE   g_str       STRING
#No.FUN-710091  --end  
###GENGRE###START
TYPE sr1_t RECORD
    aah01 LIKE aah_file.aah01,
    aag02 LIKE aag_file.aag02,
    aag07 LIKE aag_file.aag07,
    aag24 LIKE aag_file.aag24,
    aah03 LIKE aah_file.aah03,
    aah1j LIKE aah_file.aah04,
    aah1d LIKE aah_file.aah04,
    aah04 LIKE aah_file.aah04,
    aah05 LIKE aah_file.aah05,
    aah3j LIKE aah_file.aah04,
    aah3d LIKE aah_file.aah04
END RECORD

TYPE sr2_t RECORD
    tah01 LIKE tah_file.tah01,
    aag02 LIKE aag_file.aag02,
    aag07 LIKE aag_file.aag07,
    aag24 LIKE aag_file.aag24,
    tah08 LIKE tah_file.tah08,
    tah03 LIKE tah_file.tah03,
    taha LIKE type_file.chr4,
    tah4y LIKE tah_file.tah09,
    tah5b LIKE tah_file.tah04,
    tah09 LIKE tah_file.tah09,
    tah04 LIKE tah_file.tah04,
    tah10 LIKE tah_file.tah10,
    tah05 LIKE tah_file.tah05,
    tahb LIKE type_file.chr4,
    tah7y LIKE tah_file.tah09,
    tah8b LIKE tah_file.tah04
END RECORD

TYPE sr3_t RECORD
    l_i LIKE type_file.num5,
    tah4ysum LIKE tah_file.tah09,
    tah5bsum LIKE tah_file.tah04,
    tah7ysum LIKE tah_file.tah09,
    tah8bsum LIKE tah_file.tah04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-C10036   mark
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   DROP TABLE r305_tmp
   CREATE TEMP TABLE r305_tmp
   (aah01    LIKE type_file.chr30 )
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add    #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
 
   LET tm.book_no=ARG_VAL(1)
   LET g_pdate =ARG_VAL(2)              	# Get arguments from command line
   LET g_towhom=ARG_VAL(3)
   LET g_rlang =ARG_VAL(4)
   LET g_bgjob =ARG_VAL(5)
   LET g_prtway=ARG_VAL(6)
   LET g_copies=ARG_VAL(7)
   LET tm.wc   =ARG_VAL(8)
   LET tm.yy = ARG_VAL(9)
   LET tm.m1 = ARG_VAL(10)
   LET tm.m2 = ARG_VAL(11)
   LET tm.a = ARG_VAL(12)
   LET tm.y = ARG_VAL(13)
   LET tm.n = ARG_VAL(14)
   LET tm.b = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   IF tm.book_no = ' ' OR tm.book_no IS NULL THEN
      LET tm.book_no = g_aaz.aaz64                #帳別若為空白則使用預設帳別
   END IF
   #No.FUN-710091  --begin
   LET g_sql ="aah01.aah_file.aah01,",
              "aag02.aag_file.aag02,",
              "aag07.aag_file.aag07,",
              "aag24.aag_file.aag24,",
              "aah03.aah_file.aah03,",
              "aah1j.aah_file.aah04,",
              "aah1d.aah_file.aah04,",
              "aah04.aah_file.aah04,",
              "aah05.aah_file.aah05,",
              "aah3j.aah_file.aah04,",
              "aah3d.aah_file.aah04"
   LET l_table1 = cl_prt_temptable('gglg407',g_sql) CLIPPED 
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF 
   LET g_sql ="tah01.tah_file.tah01,",
              "aag02.aag_file.aag02,",
              "aag07.aag_file.aag07,",
              "aag24.aag_file.aag24,",
              "tah08.tah_file.tah08,",
              "tah03.tah_file.tah03,",
              "taha.type_file.chr4,",
              "tah4y.tah_file.tah09,",
              "tah5b.tah_file.tah04,",
              "tah09.tah_file.tah09,",
              "tah04.tah_file.tah04,",
              "tah10.tah_file.tah10,",
              "tah05.tah_file.tah05,",
              "tahb.type_file.chr4,",
              "tah7y.tah_file.tah09,",
              "tah8b.tah_file.tah04"
   LET l_table2 = cl_prt_temptable('gglg4071',g_sql) CLIPPED 
   IF  l_table2 = -1 THEN 
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add        #FUN-C10036  mark
       #CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add    #FUN-C10036  mark
       EXIT PROGRAM 
   END IF 
   LET g_sql= "l_i.type_file.num5,",
              "tah4ysum.tah_file.tah09,",
              "tah5bsum.tah_file.tah04,",
              "tah7ysum.tah_file.tah09,",
              "tah8bsum.tah_file.tah04"
   LET l_table3 = cl_prt_temptable('gglg4072',g_sql) CLIPPED 
   IF  l_table3 = -1 THEN
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add               #FUN-C10036  mark
       #CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add   #FUN-C10036  mark
       EXIT PROGRAM
   END IF 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-C10036   add
   #No.FUN-710091  --end  
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aag00
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN CALL cl_err(g_aaa03,SQLCA.sqlcode,0) END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglg407_tm()	        	# Input print condition
      ELSE CALL gglg407()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
END MAIN
 
FUNCTION gglg407_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd         LIKE type_file.chr1000
   DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
 
   CALL s_dsmark(tm.book_no)
   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW gglg407_w AT p_row,p_col
        WITH FORM "ggl/42f/gglg407"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.book_no)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.book_no = g_aaz.aaz64
   LET tm.yy    = YEAR(TODAY)
   LET tm.m1    = 1
   LET tm.m2    = MONTH(TODAY)
   LET tm.a     = '1'
   LET tm.y     = 99
   LET tm.n     = 'N'
   LET tm.b     = '    '
   LET tm.h     = 'Y'     #No.MOD-860252
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
  #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.book_no ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD book_no 
            IF NOT cl_null(tm.book_no) THEN
                   CALL s_check_bookno(tm.book_no,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD book_no
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.book_no
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.book_no,"","agl-043","","",0)
                   NEXT FIELD book_no
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
     
   CONSTRUCT BY NAME tm.wc ON aag01
   
   #FUN-B20054--mark--str--
   #    ON ACTION locale
   #        #CALL cl_dynamic_locale()
   #      LET g_action_choice = "locale"
   #
   #   ON ACTION controlp
   #     CASE 
   #        WHEN INFIELD(aag01)
   #        CALL cl_init_qry_var()
   #        LET g_qryparam.form="q_aag"
   #        LET g_qryparam.state="c"
   #        LET g_qryparam.default1=tm.wc      
   #        CALL cl_create_qry() RETURNING g_qryparam.multiret
   #        DISPLAY g_qryparam.multiret TO aag01
   #        NEXT FIELD aag01
   #
   #     OTHERWISE
   #        EXIT CASE
   #     END CASE
   #
   #   ON IDLE g_idle_seconds
   #     CALL cl_on_idle()
   #     CONTINUE CONSTRUCT
   #
   #   ON ACTION about         
   #      CALL cl_about()      
   #
   #   ON ACTION help          
   #      CALL cl_show_help()  
   #
   #   ON ACTION controlg      
   #      CALL cl_cmdask()     
   #
   #   ON ACTION exit
   #      LET INT_FLAG = 1
   #      EXIT CONSTRUCT
   #FUN-B20054--mark--end--     
   
  END CONSTRUCT
  
  #FUN-B20054--mark--str--
  #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030   #FUN-B20054 TO ANTER END DIALOG 
  #
  #     IF g_action_choice = "locale" THEN
  #        LET g_action_choice = ""
  #        CALL cl_dynamic_locale()
  #        CONTINUE WHILE
  #     END IF
  #
  # IF INT_FLAG THEN
  #    LET INT_FLAG = 0 CLOSE WINDOW gglg407_w EXIT PROGRAM
  # END IF     
  #FUN-B20054--mark--end--
 
   INPUT BY NAME tm.yy, tm.m1, tm.m2,tm.a,tm.y,tm.n, tm.b, tm.h,tm.more  #No.MOD-860252 add tm.h #FUN-B20054 del book_no 
         #WITHOUT DEFAULTS    # FUN-B20054
         ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
   
   #FUN-B20054--mark--str--
   #AFTER FIELD book_no
   #   SELECT count(*) INTO g_aaa01 FROM aaa_file WHERE aaa01 = tm.book_no
   #   IF g_aaa01 = 0 THEN
   #      CALL cl_err('g_aaa01','anm-009',0)
   #   END IF   
   #FUN-B20054--mark--end--
   
   AFTER FIELD yy
      IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
   AFTER FIELD m1
      IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF
      IF tm.m1<1 OR tm.m1>13 THEN NEXT FIELD m1 END IF
      IF tm.m2<tm.m1 THEN NEXT FIELD m1 END IF
   AFTER FIELD m2
      IF cl_null(tm.m2) THEN NEXT FIELD m2 END IF
      IF tm.m2<1 OR tm.m2>13 THEN NEXT FIELD m2 END IF
      IF tm.m2<tm.m1 THEN NEXT FIELD m2 END IF
   AFTER FIELD a
      IF cl_null(tm.a) THEN NEXT FIELD a END IF
      IF tm.a NOT MATCHES "[12]" THEN NEXT FIELD a END IF
   AFTER FIELD y
      IF cl_null(tm.y) THEN LET tm.y = 99 END IF 
   AFTER FIELD n
      IF tm.n NOT MATCHES "[YN]" THEN NEXT FIELD n END IF
      IF tm.n = 'N' THEN
         CALL cl_set_comp_entry("b",FALSE)       
         LET tm.b = ' '
         DISPLAY BY NAME tm.b
      END IF
      IF tm.n='Y' THEN                                                          
         CALL cl_set_comp_entry("b",TRUE)                                       
      END IF                                                                    
   AFTER FIELD b
     IF tm.n='Y' THEN    
      SELECT azi01 FROM azi_file WHERE azi01 = tm.b
        IF SQLCA.sqlcode THEN
           CALL cl_err(tm.b,'agl-109',0) NEXT FIELD b
        END IF
     END IF               
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
 
   #FUN-B20054--mark--str--
   #ON ACTION CONTROLR
   #   CALL cl_show_req_fields()
   #ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
   #
   #   ON IDLE g_idle_seconds
   #      CALL cl_on_idle()
   #      CONTINUE INPUT
   #
   #   ON ACTION about         
   #      CALL cl_about()      
   #
   #   ON ACTION help          
   #      CALL cl_show_help()  
   #
   #   ON ACTION controlp
   #     CASE 
   #        WHEN INFIELD(book_no)
   #        CALL cl_init_qry_var()
   #        LET g_qryparam.form="q_aaa"
   #        LET g_qryparam.default1=tm.book_no  
   #        CALL cl_create_qry() RETURNING tm.book_no
   #        DISPLAY tm.book_no TO book_no 
   #        NEXT FIELD book_no
   #
   #     OTHERWISE
   #        EXIT CASE
   #     END CASE
   #
   #   ON ACTION exit
   #      LET INT_FLAG = 1
   #      EXIT INPUT
   #FUN-B20054--mark--end--
   END INPUT
   
   #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(book_no)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 = tm.book_no
                CALL cl_create_qry() RETURNING tm.book_no
                DISPLAY tm.book_no TO FORMONLY.book_no
                NEXT FIELD book_no
             WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.book_no CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01                                
          END CASE

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG
    END DIALOG
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    #FUN-B20054--add--end--
   IF INT_FLAG THEN
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B50018  mark
      LET INT_FLAG = 0 CLOSE WINDOW gglg407_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
      EXIT PROGRAM
   END IF      
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')  #FUN-B20054
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglg407'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglg407','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",tm.book_no CLIPPED,"'" ,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.yy    CLIPPED,"'",
                         " '",tm.m1    CLIPPED,"'",
                         " '",tm.m2    CLIPPED,"'",
                         " '",tm.a    CLIPPED,"'",
                         " '",tm.y    CLIPPED,"'",
                         " '",tm.n    CLIPPED,"'",
                         " '",tm.b    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",    
                         " '",g_rep_clas CLIPPED,"'",    
                         " '",g_template CLIPPED,"'"     
         CALL cl_cmdat('gglg407',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglg407_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglg407()
   ERROR ""
END WHILE
   CLOSE WINDOW gglg407_w
END FUNCTION
 
FUNCTION gglg407()
   DEFINE l_name	LIKE type_file.chr20,		# External(Disk) file name
          l_time	LIKE type_file.chr8,		# Used time for running the job
          l_sql 	LIKE type_file.chr1000,             # RDSQL STATEMENT
          l_sql1 	LIKE type_file.chr1000,             # RDSQL STATEMENT
          l_chr		LIKE type_file.chr1,
          l_aah45       LIKE aah_file.aah04,
          l_aah451      LIKE aah_file.aah04,
          l_aag06       LIKE aag_file.aag06,
          l_aah         LIKE aah_file.aah04,
          l_tah08       LIKE tah_file.tah08,
          l_tah47       LIKE tah_file.tah09,#SUM(tah09-tah10)
          l_tah09       LIKE tah_file.tah09,
          l_tah04       LIKE tah_file.tah04,
          l_tah10       LIKE tah_file.tah10,
          l_tah05       LIKE tah_file.tah05,
          l_tah58       LIKE tah_file.tah04,#SUM(tah04-tah05)
          l_tah7y       LIKE tah_file.tah09,
          l_tah8b       LIKE tah_file.tah04,
          l_tah         LIKE tah_file.tah04,
          l_cnt         LIKE type_file.num5,          
          l_aag01       LIKE aag_file.aag01,
          l_i           LIKE type_file.num5,
          m             LIKE type_file.num5,
          n             LIKE type_file.num5,
          a             STRING,
          sr            RECORD
                           aah01     LIKE aah_file.aah01,#科目
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag07     LIKE aag_file.aag07,
                           aag24     LIKE aag_file.aag24,
                           aah03     LIKE aah_file.aah03,
                           aah1j     LIKE aah_file.aah04,#注一借-1j
                           aah1d     LIKE aah_file.aah04,#注一貸-1d
                           aah04     LIKE aah_file.aah04,
                           aah05     LIKE aah_file.aah05,
                           aah3j     LIKE aah_file.aah04,#注三借-3j
                           aah3d     LIKE aah_file.aah04 #注三貸-3d
                        END RECORD,
          sr1               RECORD
                           tah01     LIKE tah_file.tah01,
                           aag02     LIKE aag_file.aag02,
                           aag07     LIKE aag_file.aag07,
                           aag24     LIKE aag_file.aag24,
                           tah08     LIKE tah_file.tah08,#幣別
                           tah03     LIKE tah_file.tah03,
                           taha      LIKE type_file.chr4,
                           tah4y     LIKE tah_file.tah09,#注四原幣
                           tah5b     LIKE tah_file.tah04,#注五本幣
                           tah09     LIKE tah_file.tah09,
                           tah04     LIKE tah_file.tah04,
                           tah10     LIKE tah_file.tah10,
                           tah05     LIKE tah_file.tah05,
                           tahb      LIKE type_file.chr4,
                           tah7y     LIKE tah_file.tah09,#注七原幣
                           tah8b     LIKE tah_file.tah04 #注八本幣
                        END RECORD
       
 
       LET g_tah4ysum=0      #用於做纍加，放入小計中
       LET g_tah5bsum=0
       LET g_tah7ysum=0
       LET g_tah8bsum=0
       LET g_aah1jsum=0
       LET g_aah1dsum=0
       LET g_aah04sum=0
       LET g_aah05sum=0
       LET g_aah3jsum=0
       LET g_aah3dsum=0
       LET l_tah=0           #用於在數據庫中無此筆資料時打0.00
       LET l_aah=0           #在數據庫無相應資料時打印0
 
     #No.FUN-B80096--mark--Begin---  
     #CALL cl_used(g_prog,l_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
     #No.FUN-B80096--mark--End-----
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.book_no
  			AND aaf02 = g_rlang
 
     #No.FUN-710091  --begin 
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
     PREPARE insert_prep FROM l_sql
     IF STATUS THEN
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B50018  mark
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
        CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
        EXIT PROGRAM
     END IF
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
     PREPARE insert_prep1 FROM l_sql
     IF STATUS THEN
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  mark
        CALL cl_err("insert_prep1:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
        CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
        EXIT PROGRAM
     END IF
     #No.FUN-710091  --end   
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     LET     l_sql1 = "SELECT aag01  FROM aag_file",
                      " WHERE aag03 = '2' AND ",tm.wc CLIPPED 
     IF tm.n = 'N' THEN                   #不列印外幣
         LET l_sql = "SELECT aah01,aag02,aag07,aag24,aah03,'','',",
                     "       aah04,aah05,'','' ",
                     "  FROM aah_file,aag_file",
                     " WHERE aah01 = ?",
                     "   AND aah01 = aag01",
                     "   AND aah00 = '",tm.book_no,"'",
                     "   AND aah02 = ",tm.yy,
                     "   AND aah03 = ? "
                      
                      
     ELSE                               #print 2 and 3
         LET l_sql = "SELECT tah01,aag02,aag07,aag24,tah08,tah03,'','','',",
                     "       tah09,tah04,tah10,tah05, ",
                     "       '','','' ",
                     "  FROM tah_file,aag_file",
                     " WHERE tah01 = ?",
                     "   AND tah01 = aag01",
                     "   AND tah00 = '",tm.book_no,"'",
                     "   AND tah02 = ",tm.yy,
                     "   AND tah03 = ? ",
                     "   AND tah08 = '",tm.b CLIPPED,"'" 
                        
     END IF
 
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql1 = l_sql1 CLIPPED, " AND aag09 = 'Y' " 
     END IF
     #No.MOD-860252---end---
     IF tm.a ='1' THEN
        LET l_sql1 = l_sql1 CLIPPED," AND (aag07= 1 AND aag24 <=",tm.y,") OR (aag03='2' AND ",tm.wc CLIPPED," AND aag07 = 3)  GROUP BY aag01"
     ELSE 
        LET l_sql1 = l_sql1 CLIPPED," AND (aag07 =2 OR aag07=3)  GROUP BY aag01"
     END IF 
     IF tm.n ='N' THEN 
        LET l_sql  = l_sql  CLIPPED," GROUP BY aah01,aag02,aag07,aag24,aah03,aah04,aah05"
     ELSE 
        LET l_sql  = l_sql  CLIPPED," GROUP BY tah01,aag02,aag07,aag24,tah08,tah03,tah09,tah04,tah10,tah05"
     END IF  
     PREPARE gglg407_prepare FROM l_sql1
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B50018  mark
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
            CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
            EXIT PROGRAM 
         END IF
     DECLARE gglg407_cur CURSOR FOR gglg407_prepare
 
     PREPARE gglg407_prepare1 FROM l_sql
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time       #FUN-B50018  mark
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
           CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)              #FUN-B50018  add
           EXIT PROGRAM 
        END IF
     DECLARE gglg407_curs1 CURSOR FOR gglg407_prepare1
 
 IF tm.n = 'N' THEN                   #不列印外幣
#No.FUN-710091  --begin mark
#   CALL cl_outnam('gglg407') RETURNING l_name
#   START REPORT gglg407_rep TO l_name
#   CALL cl_prt_pos_len()
#No.FUN-710091  --begin mark
 
     FOREACH gglg407_cur INTO l_aag01  
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
 
        LET g_len = 158
 
        LET g_pageno = 0
        LET m = 0
        LET n = 0
        FOR l_i = tm.m1 TO tm.m2 
          LET g_cnt = l_i 
          LET m = m+1
   
          FOREACH gglg407_curs1 USING l_aag01,l_i INTO sr.* 
             IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF
             LET n = m
             # 計算期初余額
             SELECT SUM(aah04-aah05) INTO l_aah45 FROM aah_file
              WHERE aah01 = l_aag01
                AND aah02 = tm.yy
                AND aah03 < g_cnt           
                AND aah00 = tm.book_no
             IF cl_null(l_aah45) THEN
                LET sr.aah1j = 0    
                LET sr.aah1d = 0     
             ELSE
                IF l_aah45>0 THEN
                    LET sr.aah1j = l_aah45
                    LET sr.aah1d = 0   
                END IF
                IF l_aah45=0 THEN
                      LET sr.aah1j = 0   
                      LET sr.aah1d = 0   
                END IF
                IF l_aah45<0 THEN
                   LET sr.aah1j = 0   
                   LET sr.aah1d = l_aah45*(-1)
                END IF
             END IF
             #計算期末余額
             LET l_aah45 = sr.aah1j+sr.aah04-sr.aah1d-sr.aah05
                IF l_aah45 > 0 THEN
                   LET sr.aah3j = l_aah45
                   LET sr.aah3d = 0
                ELSE 
                   LET sr.aah3j = 0
                   LET sr.aah3d = l_aah45*(-1)
                END IF 
 
       #     IF sr.aah1j<>0 OR sr.aah1d <>0 OR sr.aah3j<>0 OR sr.aah3d<>0  THEN   #No.TQC-710102
             IF sr.aah1j<>0 OR sr.aah1d <>0 OR sr.aah3j<>0 OR sr.aah3d<>0 OR sr.aah04<>0 OR sr.aah05 <>0 THEN   #No.TQC-710102
       #         OUTPUT TO REPORT gglg407_rep(sr.*)  #No.FUN-710091 mark
                 EXECUTE insert_prep USING sr.*      #No.FUN-710091
             END IF 
          END FOREACH
          IF m <> n THEN
             SELECT SUM(aah04-aah05) INTO l_aah45 FROM aah_file
               WHERE aah01 = l_aag01 
                 AND aah02 = tm.yy
                 AND aah03 < g_cnt
                 AND aah00 = tm.book_no
               IF cl_null(l_aah45) THEN
                 LET sr.aah1j = 0   
                 LET sr.aah1d = 0   
               END IF
               IF l_aah45>0 THEN
                 LET sr.aah1j = l_aah45
                 LET sr.aah1d = 0   
               END IF
               IF l_aah45=0 THEN
                 LET sr.aah1j = 0   
                 LET sr.aah1d = 0   
               END IF
               IF l_aah45<0 THEN
                 LET sr.aah1j = 0   
                 LET sr.aah1d = l_aah45*(-1)
               END IF
 
               LET sr.aah04 = 0
               LET sr.aah05 = 0
                  
             SELECT SUM(aah04-aah05) INTO l_aah45 FROM aah_file
                WHERE aah01 = l_aag01 
                  AND aah02 = tm.yy
                  AND aah03 <= g_cnt
                  AND aah00 = tm.book_no
             IF cl_null(l_aah45) THEN
                 LET sr.aah3j = 0   
                 LET sr.aah3d = 0   
             END IF
             IF l_aah45>0 THEN
               LET sr.aah3j = l_aah45
               LET sr.aah3d = 0   
             END IF
             IF l_aah45=0 THEN
                 LET sr.aah3j = 0   
                 LET sr.aah3d = 0   
             END IF
             IF l_aah45<0 THEN
               LET sr.aah3j = 0   
               LET sr.aah3d = l_aah45*(-1)
             END IF
             SELECT aag01,aag02,aag07,aag24 INTO sr.aah01,sr.aag02,sr.aag07,sr.aag24
                   FROM aag_file   WHERE aag01 = l_aag01
             LET sr.aah03 = l_i 
 
             IF sr.aah3j <> 0 OR sr.aah3d <> 0 THEN
#               OUTPUT TO REPORT gglg407_rep(sr.*)   #NO.FUN-710091 mark
                EXECUTE insert_prep USING sr.*      #No.FUN-710091 
             END IF 
          END IF
       END FOR
     END FOREACH
#  FINISH REPORT gglg407_rep     #NO.FUN-710091  mark 
  CALL cl_wcchp(tm.wc,'aag01')
       RETURNING tm.wc 
###GENGRE###  LET g_str =tm.wc,";",tm.yy
# LET g_sql ="SELECT * from ", l_table1 CLIPPED   #TQC-730113
# CALL cl_prt_cs3('gglg407',g_sql,g_str)
###GENGRE###  LET g_sql ="SELECT * from ", g_cr_db_str CLIPPED,l_table1 CLIPPED
###GENGRE###  CALL cl_prt_cs3('gglg407','gglg407',g_sql,g_str)
    LET g_template = 'gglg407'   #FUN-B50018 add
    CALL gglg407_grdata()    ###GENGRE###
 ELSE
#No.FUN-710091  --begin
#      CALL cl_outnam('gglg407') RETURNING l_name
#      START REPORT gglg407_rep1 TO l_name
#No.FUN-710091  --end   
       FOREACH gglg407_cur INTO l_aag01  
           IF STATUS THEN 
              CALL cl_err('foreach:',STATUS,1)
              EXIT FOREACH
           END IF 
 
         LET g_len = 173
         LET g_pageno = 0
         LET g_cnt    = 1
         LET m = 0
         LET n = 0
          
         FOR l_i = tm.m1 TO tm.m2
         LET g_cnt = l_i 
         LET m = m+1
         FOREACH gglg407_curs1 USING l_aag01,l_i INTO sr1.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            LET n = m
            SELECT SUM(tah09-tah10),SUM(tah04-tah05)
                INTO l_tah47,l_tah58
                FROM tah_file
                WHERE tah01 = sr1.tah01
                  AND tah02 = tm.yy
                  AND tah03 < g_cnt        
                  AND tah00 = tm.book_no
                  AND tah08 = sr1.tah08
            IF cl_null(l_tah58) THEN
               LET sr1.taha = g_x[28] CLIPPED
               LET sr1.tah4y = 0 
               LET sr1.tah5b = 0 
            ELSE
              IF l_tah58 > 0 THEN
                 LET sr1.taha  = g_x[26] CLIPPED
                 LET sr1.tah4y = l_tah47
                 LET sr1.tah5b = l_tah58
              ELSE
                 IF l_tah58 < 0 THEN
                    LET sr1.taha  = g_x[27] ClIPPED
                    LET sr1.tah4y = l_tah47*(-1)
                    LET sr1.tah5b = l_tah58*(-1)
                 ELSE
                    LET sr1.taha  = g_x[28] CLIPPED
                    LET sr1.tah4y = 0     
                    LET sr1.tah5b = 0    
                 END IF
              END IF
           END IF
           LET g_tah58 = l_tah58
  
           SELECT tah09,tah04,tah10,tah05
             INTO l_tah09,l_tah04,l_tah10,l_tah05
             FROM tah_file
             WHERE tah01 = sr1.tah01
               AND tah02 = tm.yy
               AND tah03 = g_cnt 
               AND tah00 = tm.book_no
               AND tah08 = sr1.tah08
  
           IF cl_null(l_tah09) THEN
              LET sr1.tah09 = l_tah
           ELSE
              LET sr1.tah09 = l_tah09
           END IF
 
           IF cl_null(l_tah04) THEN
              LET sr1.tah04 = l_tah
           ELSE
              LET sr1.tah04 = l_tah04
           END IF
 
           IF cl_null(l_tah10) THEN
              LET sr1.tah10 = l_tah
           ELSE
              LET sr1.tah10 = l_tah10
           END IF
  
           IF cl_null(l_tah05) THEN
              LET sr1.tah05 = l_tah
           ELSE
              LET sr1.tah05 = l_tah05
           END IF
  
 
           SELECT SUM(tah09-tah10),SUM(tah04-tah05)
             INTO l_tah7y,l_tah8b
             FROM tah_file
            WHERE tah01 = sr1.tah01
              AND tah02 = tm.yy
              AND tah03 <= g_cnt 
              AND tah00 = tm.book_no
              AND tah08 = sr1.tah08
           IF cl_null(l_tah8b) THEN
              LET sr1.tahb = g_x[28] CLIPPED
              LET sr1.tah7y = 0    
              LET sr1.tah8b = 0    
           ELSE
              IF l_tah8b > 0 THEN
                 LET sr1.tahb = g_x[26] CLIPPED
                 LET sr1.tah7y = l_tah7y
                 LET sr1.tah8b = l_tah8b
              ELSE
                 IF l_tah8b < 0 THEN
                    LET sr1.tahb = g_x[27] CLIPPED
                    LET sr1.tah7y = l_tah7y*(-1)
                    LET sr1.tah8b = l_tah8b*(-1)
                 ELSE
                    LET sr1.tahb = g_x[28] CLIPPED
                    LET sr1.tah7y = l_tah7y
                    LET sr1.tah8b = l_tah8b
                 END IF
              END IF
           END IF
         SELECT aag02,aag07,aag24 INTO sr1.aag02,sr1.aag07,sr1.aag24
            FROM aag_file
          WHERE aag01=l_aag01 
         LET sr1.tah01 = l_aag01
         LET sr1.tah03 = g_cnt
 
           IF sr1.tah4y<>0 OR sr1.tah5b <>0 OR sr1.tah09<>0 OR sr1.tah04<>0 OR sr1.tah10<>0 OR sr1.tah05<>0 OR sr1.tah7y<>0 OR sr1.tah8b<>0 THEN
#             OUTPUT TO REPORT gglg407_rep1(sr1.*)   #No.FUN-710091  mark
              EXECUTE insert_prep1 USING sr1.*   #No.FUN-710091
           END IF 
        END FOREACH
        IF m <> n THEN
            SELECT SUM(tah09-tah10),SUM(tah04-tah05)
                INTO l_tah47,l_tah58
                FROM tah_file
                WHERE tah01 = l_aag01 
                  AND tah02 = tm.yy
                  AND tah03 < g_cnt           
                  AND tah00 = tm.book_no
                  AND tah08 = tm.b
            IF cl_null(l_tah58) THEN
               LET sr1.taha = g_x[28] CLIPPED
               LET sr1.tah4y = 0    
               LET sr1.tah5b = 0    
            ELSE
              IF l_tah58 > 0 THEN
                 LET sr1.taha  = g_x[26] CLIPPED
                 LET sr1.tah4y = l_tah47
                 LET sr1.tah5b = l_tah58
              ELSE
                 IF l_tah58 < 0 THEN
                    LET sr1.taha  = g_x[27] CLIPPED
                    LET sr1.tah4y = l_tah47*(-1)
                    LET sr1.tah5b = l_tah58*(-1)
                 ELSE
                    LET sr1.taha  = g_x[28] CLIPPED
                    LET sr1.tah4y = 0     
                    LET sr1.tah5b = 0    
                 END IF
              END IF
           END IF
  
           LET sr1.tah04=0
           LET sr1.tah05=0 
           LET sr1.tah09=0 
           LET sr1.tah10=0 
  
 
           SELECT SUM(tah09-tah10),SUM(tah04-tah05)
             INTO l_tah7y,l_tah8b
             FROM tah_file
            WHERE tah01 = l_aag01 
              AND tah02 = tm.yy
              AND tah03 <= g_cnt 
              AND tah00 = tm.book_no
              AND tah08 = tm.b 
           IF cl_null(l_tah8b) THEN
              LET sr1.tahb = g_x[28] CLIPPED
              LET sr1.tah7y = 0    
              LET sr1.tah8b = 0    
           ELSE
              IF l_tah8b > 0 THEN
                 LET sr1.tahb = g_x[26] CLIPPED
                 LET sr1.tah7y = l_tah7y
                 LET sr1.tah8b = l_tah8b
              ELSE
                 IF l_tah8b < 0 THEN
                    LET sr1.tahb = g_x[27] CLIPPED
                    LET sr1.tah7y = l_tah7y*(-1)
                    LET sr1.tah8b = l_tah8b*(-1)
                 ELSE
                    LET sr1.tahb = g_x[28] CLIPPED
                    LET sr1.tah7y = l_tah7y
                    LET sr1.tah8b = l_tah8b
                 END IF
              END IF
           END IF 
         SELECT aag02,aag07,aag24 INTO sr1.aag02,sr1.aag07,sr1.aag24
            FROM aag_file
          WHERE aag01=l_aag01 
         LET sr1.tah01 = l_aag01
         LET sr1.tah03 = g_cnt
         IF sr1.tah5b+sr1.tah04+sr1.tah05+sr1.tah8b <>0 THEN
  #         OUTPUT TO REPORT gglg407_rep1(sr1.*)   #No.FUN-710091
              EXECUTE insert_prep1 USING sr1.*      #No.FUN-710091
         END IF 
        END IF 
     END FOR 
   END FOREACH
            
# FINISH REPORT gglg407_rep1     #No.FUN-710091 mark
  CALL cl_wcchp(tm.wc,'aag01')
       RETURNING tm.wc 
  LET g_str =tm.wc,";",tm.yy
  LET g_sql ="SELECT *", 
           # " FROM ", l_table2 CLIPPED," A"   #TQC-730113
             " FROM ", g_cr_db_str CLIPPED,l_table2 CLIPPED
# CALL cl_prt_cs3('gglg407_1',g_sql,g_str)     #TQC-730013
###GENGRE###  CALL cl_prt_cs3('gglg407','gglg407_1',g_sql,g_str)
    LET g_template = 'gglg407_1'   #FUN-B50018 add
    CALL gglg407_grdata()    ###GENGRE###
 END IF
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710091
    #No.FUN-B80096--mark--Begin--- 
    #CALL cl_used(g_prog,l_time,2) RETURNING g_time 
    #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-710091  --begin
#REPORT gglg407_rep1(sr1)
#   DEFINE l_last_sw     LIKE type_file.chr1,
#          l_rowno       LIKE type_file.num5,
#          l_amt1,l_amt2,l_amt3,l_amt4    LIKE aah_file.aah04,
#          l_amt5,l_amt6,l_amt7,l_amt8    LIKE aah_file.aah04,
#          sr1           RECORD
#                        tah01     LIKE tah_file.tah01,
#                        aag02     LIKE aag_file.aag02,
#                        aag07     LIKE aag_file.aag07,
#                        aag24     LIKE aag_file.aag24,
#                        tah08     LIKE tah_file.tah08,
#                        tah03     LIKE tah_file.tah03,
#                        taha      LIKE type_file.chr4,
#                        tah4y     LIKE tah_file.tah09,
#                        tah5b     LIKE tah_file.tah04,
#                        tah09     LIKE tah_file.tah09,
#                        tah04     LIKE tah_file.tah04,
#                        tah10     LIKE tah_file.tah10,
#                        tah05     LIKE tah_file.tah05,
#                        tahb      LIKE type_file.chr4,
#                        tah7y     LIKE tah_file.tah09,
#                        tah8b     LIKE tah_file.tah04 #注八本幣
#                        END RECORD
#
#   OUTPUT TOP MARGIN 0 LEFT MARGIN 0 BOTTOM MARGIN 0 PAGE LENGTH g_page_line
#   ORDER BY sr1.tah03,sr1.tah01
#   FORMAT
#     PAGE HEADER
#        PRINT '~T28X0L19;';
#        PRINT COLUMN 97,tm.b,g_x[1]
#        PRINT COLUMN 87,tm.yy USING '&&&&','      ',sr1.tah03 USING '&&'
#        PRINT 
#              COLUMN 164,PAGENO   USING '<'
#     BEFORE GROUP OF sr1.tah03
#          SKIP TO TOP OF PAGE
#      
#     PRINT 
#     PRINT
#     
#     ON EVERY ROW
#        SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file
#         WHERE azi01 = sr.tah08
#
#        PRINT 
#              COLUMN  15,sr1.tah01 CLIPPED;
#
#        PRINT COLUMN  44,sr1.taha[1,2] CLIPPED;
#        PRINT COLUMN  47,cl_numfor(sr1.tah4y,14,g_azi04),
#              COLUMN  62,cl_numfor(sr1.tah5b,14,g_azi04),
#              COLUMN  78,cl_numfor(sr1.tah09,14,g_azi04),
#              COLUMN  94,cl_numfor(sr1.tah04,14,g_azi04),
#              COLUMN 109,cl_numfor(sr1.tah10,14,g_azi04),
#              COLUMN 125,cl_numfor(sr1.tah05,14,g_azi04),
#              COLUMN 141,sr1.tahb[1,2] CLIPPED,
#              COLUMN 143,cl_numfor(sr1.tah7y,14,g_azi04),
#              COLUMN 159,cl_numfor(sr1.tah8b,14,g_azi04)
#      IF sr1.aag24 = 1 OR sr1.aag07 = 3 THEN
#         IF sr1.taha = '貸' THEN
#            LET sr1.tah4y = sr1.tah4y*(-1)
#            LET sr1.tah5b = sr1.tah5b*(-1)
#         END IF 
#         LET g_tah4ysum = sr1.tah4y+g_tah4ysum
#         LET g_tah5bsum = sr1.tah5b+g_tah5bsum
#
#         IF sr1.tahb = '貸' THEN
#            LET sr1.tah7y = sr1.tah7y*(-1)
#            LET sr1.tah8b = sr1.tah8b*(-1)
#         END IF 
#         LET g_tah7ysum = sr1.tah7y+g_tah7ysum
#         LET g_tah8bsum = sr1.tah8b+g_tah8bsum
#      END IF 
#      IF sr1.aag07 = 2 THEN
#         IF sr1.taha = '貸' THEN
#            LET sr1.tah4y = sr1.tah4y*(-1)
#            LET sr1.tah5b = sr1.tah5b*(-1)
#         END IF 
#         LET g_tah4ysum = sr1.tah4y+g_tah4ysum
#         LET g_tah5bsum = sr1.tah5b+g_tah5bsum
#
#         IF sr1.tahb = '貸' THEN
#            LET sr1.tah7y = sr1.tah7y*(-1)
#            LET sr1.tah8b = sr1.tah8b*(-1)
#         END IF 
#         LET g_tah7ysum = sr1.tah7y+g_tah7ysum
#         LET g_tah8bsum = sr1.tah8b+g_tah8bsum
#      END IF 
#
#  AFTER GROUP OF sr1.tah03  
#         SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file
#          WHERE azi01 = sr.tah08
#         
# 
#         LET l_amt1    = g_tah4ysum
#         LET l_amt2    = g_tah5bsum             
#         LET l_amt3    = (GROUP SUM(sr1.tah09))
#         LET l_amt4    = (GROUP SUM(sr1.tah04))
#         LET l_amt5    = (GROUP SUM(sr1.tah10))
#         LET l_amt6    = (GROUP SUM(sr1.tah05))
#         LET l_amt7    = g_tah7ysum
#         LET l_amt8    = g_tah8bsum
#         PRINT COLUMN 15,g_x[15] CLIPPED;
#         IF l_amt2>0 THEN
#            PRINT COLUMN 44,g_x[26] CLIPPED;
#            PRINT COLUMN 47,cl_numfor(l_amt1,14,g_azi04),
#                  COLUMN 62,cl_numfor(l_amt2,14,g_azi04);
#         ELSE
#            IF l_amt2<0 THEN
#               PRINT COLUMN 44,g_x[27] CLIPPED;
#               LET l_amt1=l_amt1*(-1)
#               LET l_amt2=l_amt2*(-1)
#               PRINT COLUMN 47,cl_numfor(l_amt1,14,g_azi04),
#                     COLUMN 62,cl_numfor(l_amt2,14,g_azi04);
#            ELSE
#               PRINT COLUMN 44,g_x[28] CLIPPED;
#               PRINT COLUMN 47,cl_numfor(l_amt1,14,g_azi04),
#                     COLUMN 62,cl_numfor(l_amt2,14,g_azi04);
#            END IF
#         END IF
# 
#         PRINT COLUMN  75,cl_numfor(l_amt3,14,g_azi04),
#               COLUMN  94,cl_numfor(l_amt4,14,g_azi04),
#               COLUMN 109,cl_numfor(l_amt5,14,g_azi04),
#               COLUMN 125,cl_numfor(l_amt6,14,g_azi04);
#  
#         IF l_amt8>0 THEN
#            PRINT COLUMN 141,g_x[26] CLIPPED,
#                  COLUMN 143,cl_numfor(l_amt7,14,g_azi04),
#                  COLUMN 159,cl_numfor(l_amt8,14,g_azi04)
#         ELSE
#            IF l_amt8<0 THEN
#               PRINT COLUMN 141,g_x[27] CLIPPED;
#               LET l_amt7=l_amt7*(-1)
#               LET l_amt8=l_amt8*(-1)
#               PRINT COLUMN 143,cl_numfor(l_amt7,14,g_azi04),
#                     COLUMN 159,cl_numfor(l_amt8,14,g_azi04)
#            ELSE
#               PRINT COLUMN 141,g_x[28] CLIPPED;
#               PRINT COLUMN 143,cl_numfor(l_amt7,14,g_azi04),
#                     COLUMN 159,cl_numfor(l_amt8,14,g_azi04)
#            END IF
#         END IF
#         LET g_tah4ysum = 0
#         LET g_tah5bsum = 0
#         LET g_tah7ysum = 0
#         LET g_tah8bsum = 0
#
#END REPORT
#No.FUN-710091  --end 
#No.FUN-710091  --begin
#REPORT gglg407_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,
#          l_rowno       LIKE type_file.num5,
#          l_amt1,l_amt2,l_amt3    LIKE aah_file.aah04,
#          l_amt4,l_amt5,l_amt6    LIKE aah_file.aah04,
#          l_cnt         LIKE type_file.num5, 
#          sr            RECORD
#                           aah01     LIKE aah_file.aah01,#科目
#                           aag02     LIKE aag_file.aag02,#科目名稱
#                           aag07     LIKE aag_file.aag07,
#                           aag24     LIKE aag_file.aag24,
#                           aah03     LIKE aah_file.aah03,
#                           aah1j     LIKE aah_file.aah04,
#                           aah1d     LIKE aah_file.aah04,
#                           aah04     LIKE aah_file.aah04,
#                           aah05     LIKE aah_file.aah05,
#                           aah3j     LIKE aah_file.aah04,
#                           aah3d     LIKE aah_file.aah04  #注三貸-3d
#                        END RECORD
#
#  OUTPUT TOP MARGIN 0 LEFT MARGIN 0 BOTTOM MARGIN 0 PAGE LENGTH g_page_line
#
#  ORDER BY sr.aah03,sr.aah01
#
#  FORMAT
#   PAGE HEADER
#   PRINT '~T28X0L19;';
#       PRINT COLUMN 90 ,g_x[1]
#       PRINT    
#             COLUMN 83,tm.yy USING '&&&&','  ',sr.aah03 USING '&&'
#       PRINT COLUMN 150,PAGENO USING '<<<'
#       PRINT
#       PRINT
#      BEFORE GROUP OF sr.aah03
#            SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
# 
#      PRINT COLUMN 16,sr.aah01 CLIPPED;
#      PRINT COLUMN 43,
#      cl_numfor(sr.aah1j,18,g_azi04),
#            COLUMN 62,
#      cl_numfor(sr.aah1d,18,g_azi04),
#            COLUMN 82, 
#      cl_numfor(sr.aah04,18,g_azi04),
#            COLUMN 102,
#      cl_numfor(sr.aah05,18,g_azi04),
#            COLUMN 121,
#      cl_numfor(sr.aah3j,18,g_azi04),
#            COLUMN 140,
#      cl_numfor(sr.aah3d,18,g_azi04)
#      IF sr.aag24 = 1 OR sr.aag07 =3 THEN
#         LET g_aah1jsum = g_aah1jsum + sr.aah1j
#         LET g_aah1dsum = g_aah1dsum + sr.aah1d
#         LET g_aah04sum = g_aah04sum + sr.aah04
#         LET g_aah05sum = g_aah05sum + sr.aah05
#         LET g_aah3jsum = g_aah3jsum + sr.aah3j
#         LET g_aah3dsum = g_aah3dsum + sr.aah3d
#       END IF    
#      IF sr.aag07 = 2 THEN
#         LET g_aah1jsum = g_aah1jsum + sr.aah1j
#         LET g_aah1dsum = g_aah1dsum + sr.aah1d
#         LET g_aah04sum = g_aah04sum + sr.aah04
#         LET g_aah05sum = g_aah05sum + sr.aah05
#         LET g_aah3jsum = g_aah3jsum + sr.aah3j
#         LET g_aah3dsum = g_aah3dsum + sr.aah3d
#       END IF    
# 
#AFTER GROUP OF sr.aah03 
#       LET l_amt1    = g_aah1jsum
#       LET l_amt2    = g_aah1dsum
#       LET l_amt3    = g_aah04sum
#       LET l_amt4    = g_aah05sum
#       LET l_amt5    = g_aah3jsum
#       LET l_amt6    = g_aah3dsum
#       PRINT COLUMN  16,g_x[15] CLIPPED;
#       PRINT COLUMN  43,
#       cl_numfor(l_amt1,18,g_azi04),
#            COLUMN 62,
#       cl_numfor(l_amt2,18,g_azi04),
#            COLUMN 82,
#       cl_numfor(l_amt3,18,g_azi04),
#            COLUMN 102,
#       cl_numfor(l_amt4,18,g_azi04),
#            COLUMN 121,
#       cl_numfor(l_amt5,18,g_azi04),
#            COLUMN 140,
#       cl_numfor(l_amt6,18,g_azi04)
#
#       LET g_aah1jsum = 0
#       LET g_aah1dsum = 0
#       LET g_aah04sum = 0
#       LET g_aah05sum = 0
#       LET g_aah3jsum = 0
#       LET g_aah3dsum = 0
#  
#   PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]   
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE 
#         SKIP 2 LINE   
#     END IF
#END REPORT
#No.FUN-710091  --end
#Patch....NO.TQC-610037 <001,002,003,004> #

###GENGRE###START
FUNCTION gglg407_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    IF tm.n = 'N' THEN
       LET l_cnt = cl_gre_rowcnt(l_table1)
    ELSE
       LET l_cnt = cl_gre_rowcnt(l_table2)
    END IF
    IF l_cnt <= 0 THEN RETURN END IF   
 
    WHILE TRUE
            CALL cl_gre_init_pageheader()            
            LET handler = cl_gre_outnam("gglg407")
            IF handler IS NOT NULL THEN
            IF tm.n = 'N' THEN
                  START REPORT gglg407_rep1 TO XML HANDLER handler
                  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                             # " ORDER BY aah01,aag02,aag07,aag24,aah03,aah04,aah05"
                              " ORDER BY aah03"          

                  DECLARE gglg407_datacur1 CURSOR FROM l_sql
                  FOREACH gglg407_datacur1 INTO sr1.*
                       OUTPUT TO REPORT gglg407_rep1(sr1.*)
                  END FOREACH
                  FINISH REPORT gglg407_rep1
            ELSE
                  START REPORT gglg407_rep2 TO XML HANDLER handler
                  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                              " ORDER BY tah03"
                  DECLARE gglg407_datacur2 CURSOR FROM l_sql
                  FOREACH gglg407_datacur2 INTO sr2.*
                       OUTPUT TO REPORT gglg407_rep2(sr2.*)
                  END FOREACH
                  FINISH REPORT gglg407_rep2
           END IF

           END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION



#FUN-B50018----add-----str-----------------
REPORT gglg407_rep1(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_aah1j_sum   LIKE aah_file.aah04
    DEFINE l_aah1d_sum   LIKE aah_file.aah04
    DEFINE l_aah04_sum   LIKE aah_file.aah04
    DEFINE l_aah05_sum   LIKE aah_file.aah05
    DEFINE l_aah3j_sum   LIKE aah_file.aah04
    DEFINE l_aah3d_sum   LIKE aah_file.aah04




    ORDER EXTERNAL BY sr1.aah03


    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*

        BEFORE GROUP OF sr1.aah03
            LET l_lineno = 0
      
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno



            PRINTX sr1.*

        AFTER GROUP OF sr1.aah03

            LET l_aah1j_sum = GROUP SUM(sr1.aah1j)
            PRINTX l_aah1j_sum

            LET l_aah1d_sum = GROUP SUM(sr1.aah1d)
            PRINTX l_aah1d_sum

            LET l_aah04_sum = GROUP SUM(sr1.aah04)
            PRINTX l_aah04_sum

            LET l_aah05_sum = GROUP SUM(sr1.aah05)
            PRINTX l_aah05_sum

            LET l_aah3j_sum = GROUP SUM(sr1.aah3j)
            PRINTX l_aah3j_sum

            LET l_aah3d_sum = GROUP SUM(sr1.aah3d)
            PRINTX l_aah3d_sum
     

        ON LAST ROW
END REPORT


REPORT gglg407_rep2(sr2)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_tah4y_sum   LIKE tah_file.tah09
    DEFINE l_tah4y_1_sum LIKE tah_file.tah09
    DEFINE l_tah7y_1_sum LIKE tah_file.tah09
    DEFINE l_tah5b_sum   LIKE tah_file.tah09
    DEFINE l_tah09_sum   LIKE tah_file.tah09
    DEFINE l_tah04_sum   LIKE tah_file.tah04
    DEFINE l_tah10_sum   LIKE tah_file.tah10
    DEFINE l_tah05_sum   LIKE tah_file.tah05
    DEFINE l_tah7y_sum   LIKE tah_file.tah09
    DEFINE l_tah8b_sum   LIKE tah_file.tah09
    DEFINE l_taha_total  LIKE type_file.chr4
    DEFINE l_tahb_total  LIKE type_file.chr4

    

    ORDER EXTERNAL BY sr2.tah03
  

      
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*

        BEFORE GROUP OF sr2.tah03
            LET l_lineno = 0



        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno


            PRINTX sr1.*
            PRINTX sr2.*

        AFTER GROUP OF sr2.tah03
            LET l_tah4y_sum = GROUP SUM(sr2.tah4y)
            PRINTX l_tah4y_sum

            LET l_tah5b_sum = GROUP SUM(sr2.tah5b)
            PRINTX l_tah5b_sum

            LET l_tah09_sum = GROUP SUM(sr2.tah09)
            PRINTX l_tah09_sum

            LET l_tah10_sum = GROUP SUM(sr2.tah10)
            PRINTX l_tah10_sum

            LET l_tah04_sum  = GROUP SUM(sr2.tah04)
            PRINTX l_tah04_sum

            LET l_tah05_sum = GROUP SUM(sr2.tah05)
            PRINTX l_tah05_sum

            LET l_tah7y_sum = GROUP SUM(sr2.tah7y)
            PRINTX l_tah7y_sum
            
            LET l_tah8b_sum = GROUP SUM(sr2.tah8b)
            PRINTX l_tah8b_sum

            IF l_tah4y_sum < 0  THEN
               LET l_tah4y_1_sum = l_tah4y_sum *(-1)
            ELSE
               LET l_tah4y_1_sum = l_tah4y_sum
            END IF
            PRINTX l_tah4y_1_sum

            IF l_tah7y_sum < 0  THEN
               LET l_tah7y_1_sum = l_tah7y_sum *(-1)
            ELSE
               LET l_tah7y_1_sum = l_tah7y_sum
            END IF
            PRINTX l_tah7y_1_sum

            IF l_tah4y_1_sum > 0 THEN
               LET l_taha_total = cl_gr_getmsg("gre-068",g_lang,'1')
            ELSE
               IF l_tah4y_1_sum  < 0 THEN
                  LET l_taha_total = cl_gr_getmsg("gre-068",g_lang,'3')
               ELSE
                  LET l_taha_total = cl_gr_getmsg("gre-068",g_lang,'2')
               END IF
            END IF
            PRINTX l_taha_total

            IF l_tah7y_1_sum > 0 THEN
               LET l_tahb_total = cl_gr_getmsg("gre-068",g_lang,'1')
            ELSE
               IF l_tah7y_1_sum  < 0 THEN
                  LET l_tahb_total = cl_gr_getmsg("gre-068",g_lang,'3')
               ELSE
                  LET l_tahb_total = cl_gr_getmsg("gre-068",g_lang,'2')
               END IF
            END IF
            PRINTX  l_tahb_total

            ON LAST ROW

END REPORT

#FUN-B50018----add-----end-----------------
###GENGRE###END
