# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr109.4gl
# Desc/riptions...: 料件基本資料列印表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/20 By Jones
#      Modify ...: 92/05/25 By David
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 料件編號開窗
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.MOD-560209 05/06/30 By kim 背景執行時接受參數與傳入參數不 match
# Modify.........: No.FUN-5A0045 05/10/17 By Sarah 品名規格(ima02)放大到60碼
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 調整報表出表欄位的位置,對齊
# Modify.........: No.TQC-5B0113 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.TQC-5C0067 05/12/13 By kim 報表料號放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.MOD-640200 06/04/14 BY yiting 取消g_x[119],g_x[121]
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-740305 07/04/28 By Lynn 報表頁次欄位出現“***”字樣
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-770006 07/08/03 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.MOD-860068 08/06/09 By claire 加印規格(ima021)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.TQC-A60046 10/06/28 By chenmoyan 修改外連的CURSOR為標準寫法
# Modify.........: No:MOD-A20060 10/08/03 By Pengu 調整背景執行傳參數的字串
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CHI-710051
 
DEFINE   tm  RECORD				# Print condition RECORD
	      wc  	STRING,   		# Where condition   #TQC-630166
   	      a    	LIKE type_file.chr1,  	# Print or not for B.O.M.  #No.FUN-690026 VARCHAR(1)
   	      b    	LIKE type_file.chr1,  	# Print or not for Iventory File.  #No.FUN-690026 VARCHAR(1)
   	      f    	LIKE type_file.chr1,  	# Print or not for 銷售資料  #No.FUN-690026 VARCHAR(1)
   	      c    	LIKE type_file.chr1,  	# Print or not for apm 資料  #No.FUN-690026 VARCHAR(1)
   	      d    	LIKE type_file.chr1,  	# Print or not for asf 資料  #No.FUN-690026 VARCHAR(1)
   	      e    	LIKE type_file.chr1,  	# Print or not for acs 資料  #No.FUN-690026 VARCHAR(1)
   	      s    	LIKE type_file.chr3,  	# Order by sequence  #No.FUN-690026 VARCHAR(3)
   	      y    	LIKE type_file.chr1,  	# group code choice  #No.FUN-690026 VARCHAR(1)
   	      more	LIKE type_file.chr1   	# Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
             END RECORD,
         g_aza17        LIKE aza_file.aza17     # 本國幣別
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_sql          STRING                  #No.FUN-770006
DEFINE   g_str          STRING                  #No.FUN-770006
DEFINE   l_table        STRING                  #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-770006 --start--
   LET g_sql="ima01.ima_file.ima01,ima06.ima_file.ima06,ima05.ima_file.ima05,",
             "ima08.ima_file.ima08,ima02.ima_file.ima02,ima03.ima_file.ima03,",
             "ima13.ima_file.ima13,ima09.ima_file.ima09,ima04.ima_file.ima04,",
             "ima10.ima_file.ima10,ima14.ima_file.ima14,ima11.ima_file.ima11,",
             "ima70.ima_file.ima70,ima12.ima_file.ima12,ima15.ima_file.ima15,",
             "ima24.ima_file.ima24,ima25.ima_file.ima25,ima07.ima_file.ima07,",
             "ima16.ima_file.ima16,ima37.ima_file.ima37,ima51.ima_file.ima51,",
             "ima52.ima_file.ima52,ima73.ima_file.ima73,ima74.ima_file.ima74,",
             "ima29.ima_file.ima29,ima30.ima_file.ima30,ima71.ima_file.ima71,",
#            "ima26.ima_file.ima26,ima271.ima_file.ima271,",                    #FUN-A20044
#            "ima262.ima_file.ima262,ima27.ima_file.ima27,",                    #FUN-A20044
#            "ima28.ima_file.ima28,ima261.ima_file.ima261,",                    #FUN-A20044
             "ima271.ima_file.ima271,",                      #FUN-A20044
             "ima27.ima_file.ima27,",                        #FUN-A20044
             "ima28.ima_file.ima28,",                        #FUN-A20044  
             "ima23.ima_file.ima23,ima35.ima_file.ima35,ima36.ima_file.ima36,",
             "ima63.ima_file.ima63,ima64.ima_file.ima64,",
             "ima63_fac.ima_file.ima63_fac,ima641.ima_file.ima641,",
             "ima31.ima_file.ima31,ima32.ima_file.ima32,",
             "ima31_fac.ima_file.ima31_fac,ima33.ima_file.ima33,",
             "ima19.ima_file.ima19,ima21.ima_file.ima21,ima18.ima_file.ima18,",
             "ima20.ima_file.ima20,ima22.ima_file.ima22,ima54.ima_file.ima54,",
             "ima43.ima_file.ima43,ima44.ima_file.ima44,ima53.ima_file.ima53,",
             "ima44_fac.ima_file.ima44_fac,ima91.ima_file.ima91,",
             "ima38.ima_file.ima38,ima50.ima_file.ima50,ima88.ima_file.ima88,",
             "ima48.ima_file.ima48,ima89.ima_file.ima89,ima90.ima_file.ima90,",
             "ima49.ima_file.ima49,ima881.ima_file.ima881,",
             "ima491.ima_file.ima491,ima45.ima_file.ima45,",
             "ima46.ima_file.ima46,ima47.ima_file.ima47,ima67.ima_file.ima67,",
             "ima68.ima_file.ima68,ima55.ima_file.ima55,ima69.ima_file.ima69,",
             "ima55_fac.ima_file.ima55_fac,ima56.ima_file.ima56,",
             "ima561.ima_file.ima561,ima562.ima_file.ima562,",
             "ima59.ima_file.ima59,ima60.ima_file.ima60,",
             "ima571.ima_file.ima571,ima61.ima_file.ima61,",
             "ima62.ima_file.ima62,ima34.ima_file.ima34,ima39.ima_file.ima39,",
             "ima87.ima_file.ima87,ima871.ima_file.ima871,",
             "ima872.ima_file.ima872,ima873.ima_file.ima873,",
             "ima874.ima_file.ima874,pmc03.pmc_file.pmc03,",
             "ima021.ima_file.ima021,",                        #MOD-860068 add
             "avl_stk_mpsmrp.type_file.num15_3,",              #FUN-A20044 add
             "unavl_stk.type_file.num15_3,",                   #FUN-A20044 add
             "avl_stk.type_file.num15_3,",                     #FUN-A20044 add 
             "smh02.smh_file.smh02,",
             "gen02.gen_file.gen02,",
             "gen02_1.gen_file.gen02,gen02_2.gen_file.gen02,",
             "smg02.smg_file.smg02,smg02_1.smg_file.smg02,",
             "smg02_2.smg_file.smg02"
   LET l_table = cl_prt_temptable('aimr109',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,    #TQC-A60046
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,    #TQC-A60046
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #MOD-860068 add  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770006 --end--
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.f  = ARG_VAL(10)
   LET tm.c  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET tm.e  = ARG_VAL(13)
   LET tm.s  = ARG_VAL(14)
   LET tm.y  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r109_tm(0,0)		# Input print condition
      ELSE CALL aimr109()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r109_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd	      LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 18
   ELSE
       LET p_row = 2 LET p_col = 14
   END IF
 
   OPEN WINDOW r109_w AT p_row,p_col
        WITH FORM "aim/42f/aimr109"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.f    = 'Y'
   LET tm.c    = 'Y'
   LET tm.d    = 'Y'
   LET tm.e    = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
WHILE TRUE
   DISPLAY BY NAME tm.a,tm.b,tm.f,tm.c,tm.d,tm.e,tm.s,
				   tm.y,tm.more
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,ima09,
							  ima10,ima11,ima12,ima08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP    #FUN-4B0001
         CASE WHEN INFIELD(ima01)
              CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
         END CASE
 
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
      CLOSE WINDOW r109_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.f,tm.c,tm.d,tm.e,tm.s,
				   tm.y,tm.more
#UI
   INPUT BY NAME tm.a,tm.b,tm.f,tm.c,tm.d,tm.e,tm2.s1,tm2.s2,tm2.s3,tm.y,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR tm.a IS NULL
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
            THEN NEXT FIELD b
         END IF
      AFTER FIELD f
         IF tm.f NOT MATCHES "[YN]" OR tm.f IS NULL
            THEN NEXT FIELD f
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]" OR tm.c IS NULL
            THEN NEXT FIELD c
         END IF
      AFTER FIELD d
         IF tm.d NOT MATCHES "[YN]" OR tm.d IS NULL
            THEN NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e NOT MATCHES "[YN]" OR tm.e IS NULL
            THEN NEXT FIELD e
         END IF
      AFTER FIELD y
         IF tm.y NOT MATCHES "[0-4]" OR tm.y IS NULL
            THEN NEXT FIELD y
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW r109_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr109'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr109','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",  #MOD-560209  #No:MOD-A20060 modify
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr109',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r109_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr109()
   ERROR ""
END WHILE
   CLOSE WINDOW r109_w
END FUNCTION
 
FUNCTION aimr109()
   DEFINE l_name     LIKE type_file.chr20,           # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#          l_time     LIKE type_file.chr8,            # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
          l_sql      STRING,                         # RDSQL STATEMENT  #TQC-630166
          l_za05     LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
          l_sta      LIKE type_file.chr20,           #No.FUN-690026 VARCHAR(20)
          l_order    ARRAY[3] OF LIKE ima_file.ima01,#FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr         RECORD order1 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                            order2 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                            order3 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                            l_sta  LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(20)
                            l_ima  RECORD LIKE ima_file.* ,
                            avl_stk_mpsmrp LIKE type_file.num15_3,    #FUN-A20044
                            unavl_stk      LIKE type_file.num15_3,    #FUN-A20044
                            avl_stk        LIKE type_file.num15_3,    #FUN-A20044      
                            gen02  LIKE gen_file.gen02,
                            gen02_1 LIKE gen_file.gen02,
                            gen02_2 LIKE gen_file.gen02,
                            pmc03   LIKE pmc_file.pmc03,
                            smh02   LIKE smh_file.smh02,
                            smg02_1 LIKE smg_file.smg02,
                            smg02_2 LIKE smg_file.smg02,
                            smg02_3 LIKE smg_file.smg02
                     END RECORD
   DEFINE l_chr LIKE type_file.chr1000                    #No.FUN-770006
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,        #No.FUN-A20044
          l_unavl_stk      LIKE type_File.num15_3,        #No.FUN-A20044
          l_avl_stk        LIKE type_file.num15_3         #No.FUN-A20044  
 
     CALL cl_del_data(l_table)                            #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr109'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
      LET l_sql = "SELECT  ' ',' ',' ',' ',",
                 " ima_file.* ,' ',' ',' ',",                        #FUN-A20044 add 3 ' '
                 " gen02,'','',pmc03,smh02,'','','' ",
#TQC-A60046 --Begin
#                " FROM ima_file ,OUTER gen_file,OUTER pmc_file, ",
#                " OUTER smg_file,OUTER smh_file ",
#                " WHERE ", tm.wc CLIPPED   ,
#                " AND gen_file.gen01 = ima_file.ima23 ",
#                " AND pmc_file.pmc01 = ima_file.ima54 ",
#                " AND smg_file.smg01 = ima_file.ima87 ",
#                " AND smh_file.smh01 = ima_file.ima34 ",
                 " FROM ima_file LEFT OUTER JOIN gen_file ON ima23=gen01 ",
                 "               LEFT OUTER JOIN pmc_file ON ima54=pmc01 ",
                 "               LEFT OUTER JOIN smg_file ON ima87=smg01 ",
                 "               LEFT OUTER JOIN smh_file ON ima34=smh01 ",
                 " WHERE ", tm.wc CLIPPED   ,
#TQC-A60046 --End
                 " ORDER BY ima01 "
 
     PREPARE r109_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r109_cs1 CURSOR FOR r109_prepare1
#    CALL cl_outnam('aimr109') RETURNING l_name        #No.FUN-770006
#    START REPORT r109_rep TO l_name                   #No.FUN-770006
 
#    LET g_pageno = 0                                  #No.FUN-770006
     FOREACH r109_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF

        #No.FUN-A20044 ---start----
        CALL s_getstock(sr.l_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
        LET sr.avl_stk_mpsmrp = l_avl_stk_mpsmrp
        LET sr.unavl_stk = l_unavl_stk
        LET sr.avl_stk = l_avl_stk
        #No.FUN-A20044 ---end---
    
	   CALL s_opc(sr.l_ima.ima37) RETURNING l_sta
	   SELECT gen02 INTO sr.gen02_1 FROM gen_file
                       WHERE sr.l_ima.ima67 = gen01
           IF SQLCA.sqlcode != 0 THEN LET sr.gen02_1 = NULL END IF
	   SELECT gen02 INTO sr.gen02_2 FROM gen_file
                       WHERE sr.l_ima.ima43 = gen01
           IF SQLCA.sqlcode != 0 THEN LET sr.gen02_2 = NULL END IF
	   SELECT smg02 INTO sr.smg02_1 FROM smg_file
                       WHERE sr.l_ima.ima87 = smg01
           IF SQLCA.sqlcode != 0 THEN LET sr.smg02_1 = NULL END IF
	   SELECT smg02 INTO sr.smg02_2 FROM smg_file
                       WHERE sr.l_ima.ima872= smg01
           IF SQLCA.sqlcode != 0 THEN LET sr.smg02_2 = NULL END IF
	   SELECT smg02 INTO sr.smg02_3 FROM smg_file
                       WHERE sr.l_ima.ima874= smg01
           IF SQLCA.sqlcode != 0 THEN LET sr.smg02_3 = NULL END IF
       IF sr.l_ima.ima01 IS NULL THEN LET sr.l_ima.ima01 = ' ' END IF
       IF sr.l_ima.ima05 IS NULL THEN LET sr.l_ima.ima05 = ' ' END IF
       IF sr.l_ima.ima06 IS NULL THEN LET sr.l_ima.ima06 = ' ' END IF
       IF sr.l_ima.ima08 IS NULL THEN LET sr.l_ima.ima08 = ' ' END IF
       #No.FUN-770006 --start-- mark
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.l_ima.ima01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.l_ima.ima05
#               WHEN tm.s[g_i,g_i] = '3'
#               CASE
#               WHEN tm.y = '0' LET l_order[g_i] = sr.l_ima.ima06
#               WHEN tm.y = '1' LET l_order[g_i] = sr.l_ima.ima09
#               WHEN tm.y = '2' LET l_order[g_i] = sr.l_ima.ima10
#               WHEN tm.y = '3' LET l_order[g_i] = sr.l_ima.ima11
#               WHEN tm.y = '4' LET l_order[g_i] = sr.l_ima.ima12
#               END CASE
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.l_ima.ima08
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       LET sr.l_sta  = l_sta
#       OUTPUT TO REPORT r109_rep(sr.*)
       #No.FUN-770006 --end--
       #No.FUN-770006 --start--
       EXECUTE insert_prep USING sr.l_ima.ima01,sr.l_ima.ima06,sr.l_ima.ima05,
                                 sr.l_ima.ima08,sr.l_ima.ima02,sr.l_ima.ima03,
                                 sr.l_ima.ima13,sr.l_ima.ima09,sr.l_ima.ima04,
                                 sr.l_ima.ima10,sr.l_ima.ima14,sr.l_ima.ima11,
                                 sr.l_ima.ima70,sr.l_ima.ima12,sr.l_ima.ima15,
                                 sr.l_ima.ima24,sr.l_ima.ima25,sr.l_ima.ima07,
                                 sr.l_ima.ima16,sr.l_ima.ima37,sr.l_ima.ima51,
                                 sr.l_ima.ima52,sr.l_ima.ima73,sr.l_ima.ima74,
                                 sr.l_ima.ima29,sr.l_ima.ima30,sr.l_ima.ima71,
#                                sr.l_ima.ima26,sr.l_ima.ima271,sr.l_ima.ima262,      #FUN-A20044
#                                sr.l_ima.ima27,sr.l_ima.ima28,sr.l_ima.ima261,       #FUN-A20044
                                 sr.l_ima.ima271,                                     #FUN-A20044
                                 sr.l_ima.ima27,sr.l_ima.ima28,                       #FUN-A20044  
                                 sr.l_ima.ima23,sr.l_ima.ima35,sr.l_ima.ima36,
                                 sr.l_ima.ima63,sr.l_ima.ima64,
                                 sr.l_ima.ima63_fac,sr.l_ima.ima641,
                                 sr.l_ima.ima31,sr.l_ima.ima32,
                                 sr.l_ima.ima31_fac,sr.l_ima.ima33,
                                 sr.l_ima.ima19,sr.l_ima.ima21,sr.l_ima.ima18,
                                 sr.l_ima.ima20,sr.l_ima.ima22,sr.l_ima.ima54,
                                 sr.l_ima.ima43,sr.l_ima.ima44,sr.l_ima.ima53,
                                 sr.l_ima.ima44_fac,sr.l_ima.ima91,
                                 sr.l_ima.ima38,sr.l_ima.ima50,sr.l_ima.ima88,
                                 sr.l_ima.ima48,sr.l_ima.ima89,sr.l_ima.ima90,
                                 sr.l_ima.ima49,sr.l_ima.ima881,sr.l_ima.ima491,
                                 sr.l_ima.ima45,sr.l_ima.ima46,sr.l_ima.ima47,
                                 sr.l_ima.ima67,sr.l_ima.ima68,sr.l_ima.ima55,
                                 sr.l_ima.ima69,sr.l_ima.ima55_fac,
                                 sr.l_ima.ima56,sr.l_ima.ima561,sr.l_ima.ima562,
                                 sr.l_ima.ima59,sr.l_ima.ima60,sr.l_ima.ima571,
                                 sr.l_ima.ima61,sr.l_ima.ima62,sr.l_ima.ima34,
                                 sr.l_ima.ima39,sr.l_ima.ima87,sr.l_ima.ima871,
                                 sr.l_ima.ima872,sr.l_ima.ima873,
                                 sr.l_ima.ima874,
#                                sr.pmc03,sr.l_ima.ima021,sr.smh02,sr.gen02,  #MOD-860068 add ima021 #FUN-A20044
                                 sr.pmc03,sr.l_ima.ima021,sr.avl_stk_mpsmrp,    #FUN-A20044
                                 sr.unavl_stk,sr.avl_stk,sr.smh02,sr.gen02,     #FUN-A20044 
                                 sr.gen02_1,sr.gen02_2,sr.smg02_1,sr.smg02_2,
                                 sr.smg02_3
   #No.FUN-770006 --end--
     END FOREACH
 
#     FINISH REPORT r109_rep                        #No.FUN-770006        
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-770006
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
       CALL cl_wcchp(tm.wc,'ima01,ima05,ima06,ima09,ima10,ima11,ima12,ima08')
            RETURNING tm.wc                                                   
       LET g_str = tm.wc                                                      
    END IF                                                                    
    IF g_towhom IS NULL OR g_towhom = ' ' THEN                                
       LET l_chr = ' '                                                        
    ELSE LET l_chr = 'TO:',g_towhom                                           
    END IF                                                                    
    LET g_str = g_str,";",l_chr,";",tm.s[1,1],";",tm.s[2,2],";",              
                tm.s[3,3],";",tm.y,";",g_azi03,";",tm.a,";",
                tm.b,";",tm.f,";",tm.c,";",tm.d,";",tm.e
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('aimr109','aimr109',l_sql,g_str)
    #No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT r109_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	  l_amt         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr            RECORD
                         order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         l_sta  LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(20)
                         l_ima  RECORD LIKE ima_file.* ,
			 gen02   LIKE gen_file.gen02,
			 gen02_1 LIKE gen_file.gen02,
			 gen02_2 LIKE gen_file.gen02,
			 pmc03   LIKE pmc_file.pmc03,
                         smh02   LIKE smh_file.smh02,
                         smg02_1 LIKE smg_file.smg02,
                         smg02_2 LIKE smg_file.smg02,
                         smg02_3 LIKE smg_file.smg02
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.l_ima.ima01,sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
            COLUMN g_len-9,g_x[3] CLIPPED,PAGENO USING '<<<<<'    # No.TQC-740305
 
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.l_ima.ima01
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
   IF tm.a = 'Y' THEN
      PRINT ' '
      PRINT COLUMN 33 ,g_x[137] CLIPPED
      PRINT g_dash[1,g_len]
 
#-----No.TQC-5B0113 modify
      PRINT COLUMN  1,g_x[11] CLIPPED,sr.l_ima.ima01 CLIPPED,
            COLUMN 55,g_x[12] CLIPPED,sr.l_ima.ima06 CLIPPED,
	    COLUMN 69,g_x[13] CLIPPED,sr.l_ima.ima05 CLIPPED,
	    COLUMN 83,g_x[14] CLIPPED,sr.l_ima.ima08 CLIPPED
      PRINT COLUMN  1,g_x[15] CLIPPED,sr.l_ima.ima02 CLIPPED,
           #COLUMN 51,g_x[16] CLIPPED,sr.l_ima.ima03   #FUN-5A0045 mark
            COLUMN 69,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045
     #PRINT '---------------------------------------------------------------',   #FUN-5A0045 mark
     #      '-----------------------------'                                      #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                     #FUN-5A0045
 
#--------No.TQC-5B0113 modify
      PRINT COLUMN  2,g_x[17] CLIPPED,sr.l_ima.ima13 CLIPPED,
            COLUMN 55,g_x[41] CLIPPED,sr.l_ima.ima09 CLIPPED
      PRINT COLUMN  2,g_x[18] CLIPPED,sr.l_ima.ima04 CLIPPED,     
	    COLUMN 65,g_x[42] CLIPPED,sr.l_ima.ima10 CLIPPED
      PRINT COLUMN  2,g_x[19] CLIPPED,sr.l_ima.ima14 CLIPPED,
            COLUMN 65,g_x[43] CLIPPED,sr.l_ima.ima11 CLIPPED
      PRINT COLUMN  2,g_x[21] CLIPPED,sr.l_ima.ima70 CLIPPED,
            COLUMN 65,g_x[44] CLIPPED,sr.l_ima.ima12 CLIPPED
      PRINT COLUMN  2,g_x[25] CLIPPED,sr.l_ima.ima15 CLIPPED,
            COLUMN 49,g_x[52] CLIPPED
      PRINT COLUMN  4,g_x[20] CLIPPED,sr.l_ima.ima24 CLIPPED,
            COLUMN 59,g_x[45] CLIPPED,sr.l_ima.ima25 CLIPPED
      PRINT COLUMN  4,g_x[135] CLIPPED,sr.l_ima.ima07 CLIPPED
      PRINT COLUMN  4,g_x[29] CLIPPED,sr.l_ima.ima16 CLIPPED
      PRINT COLUMN  2,g_x[31] CLIPPED,sr.l_ima.ima37 CLIPPED,
            COLUMN 15,sr.l_sta CLIPPED,
	    COLUMN 50,g_x[52] CLIPPED
      PRINT COLUMN  2,g_x[34] CLIPPED,sr.l_ima.ima51 CLIPPED
      PRINT COLUMN  2,g_x[36] CLIPPED,sr.l_ima.ima52 CLIPPED
#----------No.TQC-5B0113 end
 
     #PRINT '---------------------------------------------------------------',   #FUN-5A0045 mark
     #      '-----------------'                                                  #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                     #FUN-5A0045
      PRINT COLUMN  2,g_x[48] CLIPPED,sr.l_ima.ima73 CLIPPED,
            COLUMN 23,g_x[49] CLIPPED,sr.l_ima.ima74 CLIPPED,
	    COLUMN 40,g_x[50] CLIPPED,sr.l_ima.ima29 CLIPPED,
	    COLUMN 61,g_x[51] CLIPPED,sr.l_ima.ima30 CLIPPED
      PRINT g_dash[1,g_len]
   END IF
 
   IF tm.b = 'Y' THEN
      PRINT ' '
	  PRINT COLUMN 33 ,g_x[138] CLIPPED
      PRINT g_dash[1,g_len]
 
#---------No.TQC-5B0113 modify
      PRINT COLUMN  2,g_x[11] CLIPPED,sr.l_ima.ima01 CLIPPED,
            COLUMN 55,g_x[13] CLIPPED,sr.l_ima.ima05 CLIPPED,
	    COLUMN 74,g_x[14] CLIPPED,sr.l_ima.ima08 CLIPPED
      PRINT COLUMN  2,g_x[15] CLIPPED,sr.l_ima.ima02 CLIPPED,
           #COLUMN 45,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045 mark
            COLUMN 72,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045
#---------No.TQC-5B0113 end
     #PRINT '----------------------------------------------------------',   #FUN-5A0045 mark
     #      '------------------'                                            #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                #FUN-5A0045
      PRINT COLUMN  2,g_x[27] CLIPPED,sr.l_ima.ima07 CLIPPED,
            COLUMN 24,g_x[25] CLIPPED,sr.l_ima.ima15 CLIPPED,
            COLUMN 45,g_x[21] CLIPPED,sr.l_ima.ima70 CLIPPED
     #PRINT '----------------------------------------------------------',   #FUN-5A0045 mark
     #	    '------------------'                                            #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                #FUN-5A0045
     #start TQC-5B0059
     #PRINT COLUMN  2,g_x[45] CLIPPED,sr.l_ima.ima25 CLIPPED,
     #      COLUMN 41,g_x[60] CLIPPED,sr.l_ima.ima71 CLIPPED
     #PRINT COLUMN  2,g_x[53] CLIPPED,sr.l_ima.ima26 CLIPPED,
     #      COLUMN 41,g_x[61] CLIPPED,sr.l_ima.ima271 CLIPPED
     #PRINT COLUMN  2,g_x[54] CLIPPED,sr.l_ima.ima262 CLIPPED,
     #      COLUMN 41,g_x[62] CLIPPED,sr.l_ima.ima27 CLIPPED
     #PRINT COLUMN  2,g_x[55] CLIPPED,l_amt CLIPPED,
     #      COLUMN 41,g_x[63] CLIPPED,sr.l_ima.ima28 CLIPPED
     #PRINT COLUMN  2,g_x[56] CLIPPED,sr.l_ima.ima261 CLIPPED,
     #      COLUMN 41,g_x[65] CLIPPED,sr.l_ima.ima29 CLIPPED
     #PRINT COLUMN  2,g_x[57] CLIPPED,sr.l_ima.ima23 CLIPPED,
     #      COLUMN 23,sr.gen02 CLIPPED,
     #      COLUMN 41,g_x[64] CLIPPED,sr.l_ima.ima30 CLIPPED
     #PRINT COLUMN  2,g_x[58] CLIPPED,sr.l_ima.ima35 CLIPPED,
     #      COLUMN 41,g_x[66] CLIPPED,sr.l_ima.ima73  CLIPPED
     #PRINT COLUMN  2,g_x[59] CLIPPED,sr.l_ima.ima36 CLIPPED,
     #      COLUMN 41,g_x[67] CLIPPED,sr.l_ima.ima74 CLIPPED
      PRINT COLUMN  2,g_x[45] CLIPPED,COLUMN 15,sr.l_ima.ima25 CLIPPED,
            COLUMN 41,g_x[60] CLIPPED,COLUMN 65,sr.l_ima.ima71 CLIPPED
#     PRINT COLUMN  2,g_x[53] CLIPPED,COLUMN 21,sr.l_ima.ima26 CLIPPED,     #FUN-A20044
      PRINT COLUMN  2,g_x[53] CLIPPED,COLUMN 21,sr.avl_stk_mpsmrp CLIPPED,  #FUN-A20044
            COLUMN 41,g_x[61] CLIPPED,COLUMN 54,sr.l_ima.ima271 CLIPPED
#     PRINT COLUMN  2,g_x[54] CLIPPED,COLUMN 22,sr.l_ima.ima262 CLIPPED,    #FUN-A20044
      PRINT COLUMN  2,g_x[54] CLIPPED,COLUMN 22,sr.avl_stk CLIPPED,         #FUN-A20044    
            COLUMN 41,g_x[62] CLIPPED,COLUMN 54,sr.l_ima.ima27 CLIPPED
      PRINT COLUMN  2,g_x[55] CLIPPED,COLUMN 33,l_amt CLIPPED,
	    COLUMN 41,g_x[63] CLIPPED,COLUMN 54,sr.l_ima.ima28 CLIPPED
#     PRINT COLUMN  2,g_x[56] CLIPPED,COLUMN 22,sr.l_ima.ima261 CLIPPED,    #FUN-A20044
      PRINT COLUMN  2,g_x[56] CLIPPED,COLUMN 22,sr.unavl_stk CLIPPED,       #FUN-A20044 
            COLUMN 41,g_x[65] CLIPPED,COLUMN 54,sr.l_ima.ima29 CLIPPED
      PRINT COLUMN  2,g_x[57] CLIPPED,COLUMN 15,sr.l_ima.ima23 CLIPPED,
            COLUMN 33,sr.gen02 CLIPPED,
	    COLUMN 41,g_x[64] CLIPPED,COLUMN 63,sr.l_ima.ima30 CLIPPED
      PRINT COLUMN  2,g_x[58] CLIPPED,COLUMN 15,sr.l_ima.ima35 CLIPPED,
            COLUMN 41,g_x[66] CLIPPED,COLUMN 63,sr.l_ima.ima73  CLIPPED
      PRINT COLUMN  2,g_x[59] CLIPPED,COLUMN 22,sr.l_ima.ima36 CLIPPED,
            COLUMN 41,g_x[67] CLIPPED,COLUMN 54,sr.l_ima.ima74 CLIPPED
     #end TQC-5B0059
     #PRINT '----------------------------------------------------------',   #FUN-5A0045 mark
     #	    '------------------'                                            #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                #FUN-5A0045
      PRINT COLUMN  2,g_x[68] CLIPPED,sr.l_ima.ima63 CLIPPED,
            COLUMN 41,g_x[69] CLIPPED,sr.l_ima.ima64 CLIPPED
      PRINT COLUMN  2,g_x[70] CLIPPED,cl_facfor(sr.l_ima.ima63_fac) CLIPPED,
            COLUMN 41,g_x[71] CLIPPED,sr.l_ima.ima641 CLIPPED
      PRINT g_dash[1,g_len]
   END IF
 
   IF tm.f ='Y' THEN
      PRINT COLUMN  2,g_x[94] CLIPPED,g_x[95] CLIPPED,g_x[96] CLIPPED
      PRINT
      PRINT COLUMN  2,g_x[87] CLIPPED,sr.l_ima.ima31 CLIPPED,
	    COLUMN 42,g_x[88] CLIPPED,cl_numfor(sr.l_ima.ima32,15,g_azi03) CLIPPED
      PRINT COLUMN  2,g_x[89] CLIPPED,cl_facfor(sr.l_ima.ima31_fac) CLIPPED,
            COLUMN 42,g_x[90] CLIPPED,cl_numfor(sr.l_ima.ima33,15,g_azi03) CLIPPED
      PRINT
     #PRINT '----------------------------------------------------------',   #FUN-5A0045 mark
     #      '-----------'                                                   #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                #FUN-5A0045
      PRINT COLUMN  2,g_x[26] CLIPPED,sr.l_ima.ima19 CLIPPED,
            COLUMN 25,g_x[30] CLIPPED,sr.l_ima.ima21 CLIPPED
      PRINT COLUMN  2,g_x[24] CLIPPED,sr.l_ima.ima18 CLIPPED,
            COLUMN 25,g_x[28] CLIPPED,sr.l_ima.ima20 CLIPPED,
	    COLUMN 49,g_x[32] CLIPPED,sr.l_ima.ima22 CLIPPED
      PRINT
      PRINT g_dash[1,g_len]
   END IF
 
   IF tm.c = 'Y' THEN
      PRINT ' '
      PRINT COLUMN 33 ,g_x[139] CLIPPED
      PRINT g_dash[1,g_len]
      PRINT COLUMN  2,g_x[11] CLIPPED,sr.l_ima.ima01 CLIPPED,
            COLUMN 52,g_x[13] CLIPPED,sr.l_ima.ima05 CLIPPED, #TQC-5C0067 35->52
	    COLUMN 63,g_x[14] CLIPPED,sr.l_ima.ima08 CLIPPED, #TQC-5C0067 46->63
       	    COLUMN 79,g_x[45] CLIPPED,sr.l_ima.ima25 CLIPPED  #TQC-5C0067 60->79
      PRINT COLUMN  2,g_x[15] CLIPPED,sr.l_ima.ima02 CLIPPED,
           #COLUMN 44,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045 mark
            COLUMN 63,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045 #TQC-5C0067 62->63
      PRINT g_dash2[1,g_len]
      PRINT COLUMN  2,g_x[31] CLIPPED,sr.l_ima.ima37 CLIPPED,
            COLUMN 25,g_x[72] CLIPPED,sr.l_ima.ima54 CLIPPED,
	    COLUMN 55,g_x[73] CLIPPED,sr.l_ima.ima43 CLIPPED
      PRINT COLUMN 11,sr.l_sta CLIPPED,
            COLUMN 38,sr.pmc03 CLIPPED,
	    COLUMN 62,sr.gen02_2 CLIPPED
      PRINT g_dash2[1,g_len]
      PRINT COLUMN  2,g_x[74] CLIPPED,sr.l_ima.ima44 CLIPPED,
            COLUMN 47,g_x[75] CLIPPED,cl_numfor(sr.l_ima.ima53,15,g_azi03) CLIPPED
      PRINT COLUMN  2,g_x[70] CLIPPED,cl_facfor(sr.l_ima.ima44_fac) CLIPPED,
	    COLUMN 47,g_x[76] CLIPPED,cl_numfor(sr.l_ima.ima91,15,g_azi03) CLIPPED
      PRINT g_dash2[1,g_len]
      PRINT COLUMN  2,g_x[33] CLIPPED,sr.l_ima.ima38 CLIPPED,
            COLUMN 45,g_x[80] CLIPPED,sr.l_ima.ima50 CLIPPED
      PRINT COLUMN  2,g_x[77] CLIPPED,sr.l_ima.ima88 CLIPPED,
            COLUMN 45,g_x[81] CLIPPED,sr.l_ima.ima48 CLIPPED
      PRINT COLUMN  2,g_x[78] CLIPPED,sr.l_ima.ima89 CLIPPED,
	    COLUMN 18,g_x[92] CLIPPED,sr.l_ima.ima90 CLIPPED,g_x[93] CLIPPED,
            COLUMN 45,g_x[82] CLIPPED,sr.l_ima.ima49 CLIPPED
      PRINT COLUMN  2,g_x[79] CLIPPED,sr.l_ima.ima881 CLIPPED,
	    COLUMN 45,g_x[83] CLIPPED,sr.l_ima.ima491 CLIPPED
      PRINT COLUMN 45,g_x[84] CLIPPED,sr.l_ima.ima45 CLIPPED
      PRINT COLUMN  2,g_x[34] CLIPPED,sr.l_ima.ima51 CLIPPED,
            COLUMN 45,g_x[85] CLIPPED,sr.l_ima.ima46 CLIPPED
      PRINT COLUMN  2,g_x[36] CLIPPED,sr.l_ima.ima52 CLIPPED,
            COLUMN 45,g_x[86] CLIPPED,sr.l_ima.ima47 CLIPPED,g_x[97] CLIPPED
   END IF
 
   IF tm.d = 'Y' THEN
      PRINT ' '
      PRINT COLUMN 33,g_x[140] CLIPPED
      PRINT g_dash[1,g_len]
      PRINT ' ',g_x[11] CLIPPED,sr.l_ima.ima01 CLIPPED,
            COLUMN 52,g_x[13] CLIPPED,sr.l_ima.ima05 CLIPPED; #TQC-5C0067 33->52
      PRINT COLUMN 64,g_x[14] CLIPPED,sr.l_ima.ima08 CLIPPED, #TQC-5C0067 45->64
            COLUMN 79,g_x[45] CLIPPED; #TQC-5C0067 67->79
      PRINT sr.l_ima.ima25 CLIPPED
      PRINT ' ',g_x[15] CLIPPED,sr.l_ima.ima02 CLIPPED,
           #COLUMN 43,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045 mark
            COLUMN 64,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045 #TQC-5C0067 67->64
     #PRINT '------------------------------------------------------------',   #FUN-5A0045 mark
     #	    '--------------'                                                  #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                  #FUN-5A0045
      PRINT ' ',g_x[136] CLIPPED,sr.l_ima.ima70 CLIPPED,
            COLUMN 39,g_x[98] CLIPPED
      PRINT COLUMN 42,g_x[100] CLIPPED,sr.l_ima.ima67 CLIPPED,
            '  ',sr.gen02_1 CLIPPED
      PRINT ' ',g_x[101] CLIPPED,
            COLUMN 42,g_x[102] CLIPPED,sr.l_ima.ima68 CLIPPED
      PRINT ' ',g_x[103] CLIPPED,sr.l_ima.ima55 CLIPPED,
            COLUMN 42,g_x[104] CLIPPED,sr.l_ima.ima69 CLIPPED
      PRINT ' ',g_x[105] CLIPPED,cl_facfor(sr.l_ima.ima55_fac) CLIPPED,
            COLUMN 39,g_x[106] CLIPPED
      PRINT ' ',g_x[107] CLIPPED,sr.l_ima.ima56 CLIPPED,
	    COLUMN 42,g_x[108] CLIPPED,sr.l_ima.ima63 CLIPPED
      PRINT ' ',g_x[109] CLIPPED,sr.l_ima.ima561 CLIPPED,
            COLUMN 42,g_x[110] CLIPPED,cl_facfor(sr.l_ima.ima63_fac) CLIPPED
      PRINT ' ',g_x[111] CLIPPED,sr.l_ima.ima562,'%' CLIPPED,
            COLUMN 42,g_x[112] CLIPPED,sr.l_ima.ima64 CLIPPED
      PRINT ' ',g_x[113] CLIPPED,sr.l_ima.ima59 CLIPPED,
            COLUMN 42,g_x[114] CLIPPED,sr.l_ima.ima641 CLIPPED
      PRINT ' ',g_x[115] CLIPPED,sr.l_ima.ima60 CLIPPED,
            COLUMN 42,g_x[116] CLIPPED,sr.l_ima.ima571 CLIPPED
      PRINT ' ',g_x[117] CLIPPED,sr.l_ima.ima61 CLIPPED
      PRINT ' ',g_x[118] CLIPPED,sr.l_ima.ima62 CLIPPED
#NO.MOD-640200 MARK
#            COLUMN 42,g_x[119] CLIPPED,sr.l_ima.ima65 CLIPPED
#      PRINT ' ',g_x[120] CLIPPED,sr.l_ima.ima58 CLIPPED,
#            COLUMN 42,g_x[121] CLIPPED,sr.l_ima.ima66 CLIPPED
#NO.MOD-640200 MARK
      PRINT g_dash[1,g_len]
   END IF
 
   IF tm.e = 'Y' THEN
      PRINT ' '
      PRINT COLUMN 33 ,g_x[141] CLIPPED
      PRINT g_dash[1,g_len]
      PRINT ' ',g_x[11] CLIPPED,sr.l_ima.ima01 CLIPPED,
	    COLUMN 33,g_x[13] CLIPPED,sr.l_ima.ima05 CLIPPED;
      PRINT COLUMN 45,g_x[14] CLIPPED,sr.l_ima.ima08 CLIPPED,
            COLUMN 67,g_x[45] CLIPPED;
      PRINT sr.l_ima.ima25 CLIPPED
      PRINT ' ',g_x[15] CLIPPED,sr.l_ima.ima02 CLIPPED,
	   #COLUMN 43,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045 mark
	    COLUMN 67,g_x[16] CLIPPED,sr.l_ima.ima03 CLIPPED   #FUN-5A0045
     #PRINT '----------------------------------------------------------',   #FUN-5A0045 mark
     #	    '--------------'                                                #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                #FUN-5A0045
     #PRINT ' ',g_x[124] CLIPPED,sr.l_ima.ima86,COLUMN 44,g_x[125] CLIPPED, #FUN-560183
     #	            cl_facfor(sr.l_ima.ima86_fac) #FUN-560183
      PRINT ' ',g_x[126] CLIPPED,sr.l_ima.ima34 CLIPPED
      PRINT '          ',sr.smh02 CLIPPED
      PRINT ' ',g_x[127] CLIPPED,sr.l_ima.ima39 CLIPPED
     #PRINT '----------------------------------------------------------',   #FUN-5A0045 mark
     #	    '--------------'                                                #FUN-5A0045 mark
      PRINT g_dash2[1,g_len]                                                #FUN-5A0045
      PRINT ' ',g_x[128] CLIPPED,sr.l_ima.ima87,' ',sr.smg02_1 CLIPPED
      PRINT ' ',g_x[129] CLIPPED,sr.l_ima.ima871 CLIPPED
      PRINT ' ',g_x[130] CLIPPED,sr.l_ima.ima872,' ',sr.smg02_2 CLIPPED
      PRINT ' ',g_x[131] CLIPPED,sr.l_ima.ima873 CLIPPED
      PRINT ' ',g_x[132] CLIPPED,sr.l_ima.ima874,' ',sr.smg02_3 CLIPPED
   END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
        #TQC-630166
        #      IF tm.wc[001,070] > ' ' THEN			# for 80
 	#         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #      IF tm.wc[071,140] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #      IF tm.wc[141,210] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #      IF tm.wc[211,280] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#       #      IF tm.wc[001,120] > ' ' THEN			# for 132
#	#	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#       #      IF tm.wc[121,240] > ' ' THEN
#	#	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#       #      IF tm.wc[241,300] > ' ' THEN
#	#	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#No.FUN-770006 --end--
#Patch....NO.TQC-610036 <> #
