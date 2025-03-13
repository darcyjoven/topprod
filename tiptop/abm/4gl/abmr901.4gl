# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr901.4gl
# Descriptions...: ECR單
# Input parameter:
# Return code....:
# Date & Author..: 92/05/14 BY MAY
# Modify.........: 93/10/13 By Apple
# Modify.........: No.MOD-530217 05/03/23 By kim 頁次分母永遠為1
# Modify.........: No.MOD-530299 05/03/28 By kim 於abmi901直接按列印,不應該再要求輸入QBE條件
# Modify.........: No.FUN-550101 05/05/26 By echo 新增報表備註
# Modify.........: No.TQC-5A0034 05/10/12 By elva 料件編號欄位放大
# Modify.........: No.MOD-5A0403 05/10/25 By Claire 程式未退出造成頁次會累計
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630177 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640246 06/04/10 By kim 修正報表
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/08 By xumin 報表寬度調整
# Modify.........: No.FUN-710089 07/02/02 By Ray Crystal Report修改
# Modify.........: No.TQC-720059 07/03/02 By Ray 特殊打印下，英文狀態無效
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.FUN-940041 09/05/04 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.TQC-970097 09/07/09 By sherry 重新過單到32區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-950045 10/01/05 By jan 增加確認碼欄位列印
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No:MOD-A50102 10/05/17 By Sarah CR Temptable增加bms02,將bms欄位獨立成一個Temptable
# Modify.........: No.FUN-A60012 10/06/02 By vealxu 新增列印BOM類別欄位 
# Modify.........: No.TQC-AB0041 10/12/20 By lixh1  修改SQL的BUG
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10034 12/01/17 By zhuhao 簽核處理
# Modify.........: No:TQC-BC0033 12/02/10 By Elise 料件編號下加入品名l_ima02
# Modify.........: No.TQC-CB0062 12/11/20 By xuxz 添加bmr01 開窗功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		         		# Print condition RECORD
		        wc  	STRING,                 # Where condition No.TQC-630166
   		        a    	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                 	b    	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        type    LIKE type_file.chr1,    #No.FUN-A60012 VARCHAR(1)	
   	        	more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
   DEFINE g_rpt_name  LIKE type_file.chr20   #No.FUN-680096 VARCHAR(20)
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
#No.FUN-710089 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  g_str      STRING
#No.FUN-710089 --end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   INITIALIZE tm.* TO NULL            # Default condition
   #TQC-610068-begin
   #LET tm.wc = ARG_VAL(1)
   #LET tm.a = ARG_VAL(2)
   #LET tm.b  = ARG_VAL(3)
   #LET g_pdate = ARG_VAL(4)
   #LET g_towhom = ARG_VAL(5)
   #LET g_rlang = ARG_VAL(6)
   #LET g_bgjob = ARG_VAL(7)
   #LET g_prtway = ARG_VAL(8)
   #LET g_copies = ARG_VAL(9)
   #LET g_rpt_name = ARG_VAL(10)   # 外部指定報表名稱 (for abmi901)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(11)
   #LET g_rep_clas = ARG_VAL(12)
   #LET g_template = ARG_VAL(13)
   ##No.FUN-570264 ---end---
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc = cl_replace_str(tm.wc, "\\\"", "'")  #FUN-950045
   LET tm.a = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   LET tm.type = ARG_VAL(14)     #No.FUN-A60012 add 
   #TQC-610068-end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
#No.FUN-710089 --begin
   LET g_sql ="bmr01.bmr_file.bmr01,",
              "bmr02.bmr_file.bmr02,",
              "bmr03.bmr_file.bmr03,",
              "bmr04.bmr_file.bmr04,",
              "bmr05.bmr_file.bmr05,",
              "bmr06.bmr_file.bmr06,",
              "bmr07.bmr_file.bmr07,",
              "bmr08.bmr_file.bmr08,",
              "bmr09.bmr_file.bmr09,",
              "bmr10.bmr_file.bmr10,",
              "bmr11.bmr_file.bmr11,",
              "bmr12.bmr_file.bmr12,",
              "bmr13.bmr_file.bmr13,",
              "bmr14.bmr_file.bmr14,",
              "bmr141.bmr_file.bmr141,",
              "bmr15.bmr_file.bmr15,",
              "bmr151.bmr_file.bmr151,",
              "bmr16.bmr_file.bmr16,",
              "bmr17.bmr_file.bmr17,",
              "bmr18.bmr_file.bmr18,",
              "bmr19.bmr_file.bmr19,",
              "bmr20.bmr_file.bmr20,",
              "bmr21.bmr_file.bmr21,",
              "bmr22.bmr_file.bmr22,",
              "bmr23.bmr_file.bmr23,",
              "bmr24.bmr_file.bmr24,",
              "bmr25.bmr_file.bmr25,",
              "bmr26.bmr_file.bmr26,",
              "bmr27.bmr_file.bmr27,",
              "bmr30.bmr_file.bmr30,",
              "bmr31.bmr_file.bmr31,",
              "bmr32.bmr_file.bmr32,",
              "bmr33.bmr_file.bmr33,",
              "bmr34.bmr_file.bmr34,",
              "bmr35.bmr_file.bmr35,",
              "bmr36.bmr_file.bmr36,",
              "bmr37.bmr_file.bmr37,",
              "bmr38.bmr_file.bmr38,",
              "bmr39.bmr_file.bmr39,",
              "bmr40.bmr_file.bmr40,",
              "bmr41.bmr_file.bmr41,",
              "bmr42.bmr_file.bmr42,",
              "bmr43.bmr_file.bmr43,",
              "bmr44.bmr_file.bmr44,",
              "bmr45.bmr_file.bmr45,",
              "bmr46.bmr_file.bmr46,",
              "bmr47.bmr_file.bmr47,",
              "bmr48.bmr_file.bmr48,",
              "bmr49.bmr_file.bmr49,",
              "bmrsign.bmr_file.bmrsign,",
              "bmrdays.bmr_file.bmrdays,",
              "bmrprit.bmr_file.bmrprit,",
              "bmrsseq.bmr_file.bmrsseq,",
              "bmrsmax.bmr_file.bmrsmax,",
              "bmruser.bmr_file.bmruser,",
              "bmrgrup.bmr_file.bmrgrup,",
              "bmrmodu.bmr_file.bmrmodu,",
              "bmrdate.bmr_file.bmrdate,",
              "bmracti.bmr_file.bmracti,",
              "bmrplant.bmr_file.bmrplant,", #FUN-950045
              "bmrlegal.bmr_file.bmrlegal,", #FUN-950045
              "bmroriu.bmr_file.bmroriu,",   #FUN-950045
              "bmrorig.bmr_file.bmrorig,",   #FUN-950045
              "bmrconf.bmr_file.bmrconf,",   #FUN-950045
#             "bmr011.bmr_file.bmr011,",     #MOD-A50102 add   #FUN-A60012 mark
#             "bmr012.bmr_file.bmr012,",     #MOD-A50102 add   #FUN-A60012 mark
#             "bmr013.bmr_file.bmr013,",     #MOD-A50102 add   #FUN-A60012 mark
              "bmr50.bmr_file.bmr50,",       #MOD-A50102 add
              "gem02.gem_file.gem02,",
              "gen02.gen_file.gen02,",
              "sign_type.type_file.chr1,",   #簽核方式     #FUN-940041
              "sign_img.type_file.blob,",    #簽核圖檔     #FUN-940041
              "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)  #FUN-940041
              "sign_str.type_file.chr1000,",   #TQC-C10034 add
              "l_ima02.ima_file.ima02,"        #TQC-BC0033 add
   LET l_table = cl_prt_temptable('abmr901',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="bms01.bms_file.bms01,",
              "bms02.bms_file.bms02,",
              "bms03.bms_file.bms03"
   LET l_table1 = cl_prt_temptable('abmr9011',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="azd01.azd_file.azd01,",
              "azc02.azc_file.azc02,",
              "azc03.azc_file.azc03,",
              "gen02_2.gen_file.gen02,",
              "azd03.azd_file.azd03,",
              "azd04.azd_file.azd04,",
              "azc02_2.azc_file.azc02,",
              "gen02_3.gen_file.gen02"
   LET l_table2 = cl_prt_temptable('abmr9012',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
#No.FUN-710089 --end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
 #MOD-530299
   IF cl_null(g_bgjob) OR g_bgjob='N'
  #IF cl_null(tm.wc)                            #TQC-630177
      THEN CALL r901_tm()	             	# Input print condition
      ELSE #LET tm.wc="bmr01= '",tm.wc CLIPPED,"'"  #TQC-630177
           CALL abmr901()		          	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r901_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r901_w AT p_row, p_col
        WITH FORM "abm/42f/abmr901"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL cl_set_comp_visible("type",g_sma.sma542 = 'Y')    #No.FUN-A60012
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.type = '1'          #No.FUN-A60012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmr01,bmr02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      #TQC-CB0062-add--str
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bmr01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bmr"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bmr01
               NEXT FIELD bmr01
         END CASE
      #TQC-CB0062--add--end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.b,tm.type,tm.more WITHOUT DEFAULTS    #No.FUN-A60012 add tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
		 IF tm.a IS NULL OR tm.a NOT MATCHES '[YyNn]'
			THEN
			  NEXT FIELD a
         END IF
      AFTER FIELD b
		 IF tm.b IS NULL OR tm.b NOT MATCHES '[YyNn]'
			THEN NEXT FIELD b
         END IF
 
      AFTER FIELD more
		 IF tm.more IS NULL OR tm.more = ' ' OR
            tm.more NOT MATCHES '[YyNn]'
         THEN NEXT FIELD tm.more
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
      LET INT_FLAG = 0 CLOSE WINDOW r901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr901'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr901','9031',1)
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
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'"               #No.FUN-A60012 add tm.type 
         CALL cl_cmdat('abmr901',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r901_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr901()
   ERROR ""
END WHILE
   CLOSE WINDOW r901_w
END FUNCTION
 
FUNCTION abmr901()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
         #l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)#TQC-CB0062 mark
          l_sql         STRING,#TQC-CB0062 add
          l_za05	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)
#No.FUN-710089 --begin
          l_bms03   LIKE bms_file.bms03,
          l_bms02   LIKE bms_file.bms02,
 	  l_sta     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(33)
           p_type    LIKE type_file.num5,     #No.FUN-680096 SMALLINT
           l_k       LIKE type_file.num10,    #No.FUN-680096 INTEGER 
           l_cnt     LIKE type_file.num5,     #No.FUN-680096 SMALLINT
           l_a       DYNAMIC ARRAY OF RECORD
                           azc02   LIKE azc_file.azc02,
                           azc03   LIKE azc_file.azc03,
                           gen02   LIKE gen_file.gen02
                            END RECORD,
           l_b       DYNAMIC ARRAY OF RECORD
#                          seq     LIKE type_file.num5,    #No.FUN-680096 SMALLINT      #FUN-A60012 
                           azd03   LIKE azd_file.azd03,    #No.FUN-A60012  
                           azd04   LIKE azd_file.azd04,
                           azc02   LIKE azc_file.azc02,
                           gen02   LIKE gen_file.gen02
                            END RECORD,
#No.FUN-710089 --end
          sr               RECORD
                                   bmr   RECORD LIKE bmr_file.*,
				   gem02 LIKE gem_file.gem02,
				   gen02 LIKE gen_file.gen02
                           END RECORD
   ###FUN-940041 START ###
  #DEFINE l_sql_2        LIKE type_file.chr1000   # RDSQL STATEMENT   #TQC-C10034 mark
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_sign_type    LIKE type_file.chr1      #MOD-A50102 add
   DEFINE l_sign_show    LIKE type_file.chr1      #MOD-A50102 add
#TQC-C10034--mark--begin
  #DEFINE l_ii           INTEGER
  #DEFINE l_key          RECORD                  #主鍵
  #          v1          LIKE bmr_file.bmr01
  #          END RECORD
#TQC-C10034--mark--end
   ###FUN-940041 END ###
   DEFINE l_ima02 LIKE ima_file.ima02   #TQC-BC0033 add 

     LET g_pdate = g_today
#No.TQC-720059 --begin
#    LET g_rlang = g_lang
     IF cl_null(g_rlang) THEN
        LET g_rlang = g_lang
     END IF
#No.TQC-720059 --end
     LET g_copies = '1'
 
     CALL cl_del_data(l_table)     #No.FUN-710089
     CALL cl_del_data(l_table1)    #No.FUN-710089
     CALL cl_del_data(l_table2)    #No.FUN-710089
     LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr901'
#No.FUN-710089 --begin
     #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
                 " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,?,",  #FUN-940041 Add 3? #FUN-950045 add 5?  #TQC-C10034 add 1?
#                "        ?,?,?)"   #MOD-A50102 add 4?   #FUN-A60012 mark
                 "        ?)"       #FUN-A60012 add      #TQC-BC0033 add ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, #TQC-A40116 mod
                 " VALUES(?, ?, ?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED, #TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-710089 --end
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmruser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bmrgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmrgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmruser', 'bmrgrup')
     #End:FUN-980030
 
    #str MOD-A50102 mod
    #LET l_sql = "SELECT bmr_file.*,gem02,gen02 ",
    #            "  FROM bmr_file,OUTER gem_file,OUTER gen_file", 
    #            " WHERE ",tm.wc,
    #            "   AND gem_file.gem01 = bmr_file.bmr05 ", 
    #            "   AND gen_file.gen01 = bmr_file.bmr06 ",
    #            " ORDER BY 1"
     LET l_sql = "SELECT bmr_file.*,gem02,gen02 ",
                 "  FROM bmr_file",
                 "  LEFT OUTER JOIN gem_file ON bmr05=gem01 ",
                 "  LEFT OUTER JOIN gen_file ON bmr06=gen01 ",
                 " WHERE ",tm.wc 
    #            ," ORDER BY 1"               #FUN-A60012 mark 
    #end MOD-A50102 mod
    #No.FUN-A60012 ----------------start---------------------
     CASE 
        WHEN tm.type = '1'
           LET l_sql = l_sql," AND bmr50 = '1' ORDER BY 1"
        WHEN tm.type = '2'
           LET l_sql = l_sql," AND bmr50 = '2' ORDER BY 1"
        WHEN tm.type = '3'
           LET l_sql = l_sql," ORDER BY 1" CLIPPED
    END CASE
   #No.FUN-A60012 -----------------end------------------------	 
     PREPARE r901_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0
     THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
     END IF
     DECLARE r901_cs1 CURSOR FOR r901_prepare1
 
#No.FUN-710089 --begin
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#       THEN
#       LET l_name = g_rpt_name
#    ELSE
#       CALL cl_outnam('abmr901') RETURNING l_name
#    END IF
#    START REPORT r901_rep TO l_name
 
#    LET g_pageno = 0  #MOD-530217  #MOD-5A0403 造成頁次累計 取消mark
#No.FUN-710089 --end
 
#   CALL r901_cur()
   #str MOD-A50102 mod
   #LET l_sql  = "SELECT  azc02,azc03,gen02 ",
   #             " FROM azc_file,OUTER gen_file",
   #             " WHERE azc01 = ?  AND azc_file.azc03 = gen_file.gen01",
   #             " ORDER BY azc02  "
    LET l_sql  = "SELECT  azc02,azc03,gen02 ",
                 "  FROM azc_file",
                 "  LEFT OUTER JOIN gen_file ON azc03=gen01 ",
                 " WHERE azc01 = ? ",
                 " ORDER BY azc02  "
   #end MOD-A50102 mod
    PREPARE r901_pre2 FROM l_sql
    IF SQLCA.sqlcode != 0
    THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
         EXIT PROGRAM
    END IF
    DECLARE max_cl CURSOR FOR r901_pre2
   #str MOD-A50102 mod
   #LET l_sql = "SELECT azd03,azd04,azc02,gen02 ",
   #            "  FROM azd_file,azc_file,OUTER gen_file ",
   #            " WHERE azd01 = ? ",
   #            "   AND azd02 = ? ",
   #            "   AND azc01 = ? ",
   #            "   AND azc03 = azd03  AND azd_file.azd03 = gen_file.gen01",
   #            " ORDER BY azc02,azd04 "
    LET l_sql = "SELECT azd03,azd04,azc02,gen02 ",
               #"  FROM azd_file,azc_file ",            #TQC-AB0041
                "  FROM azc_file,azd_file ",            #TQC-AB0041
                "  LEFT OUTER JOIN gen_file ON azd03=gen01 ",
                " WHERE azd01 = ? ",
                "   AND azd02 = ? ",
                "   AND azc01 = ? ",
                "   AND azc03 = azd03",
                " ORDER BY azc02,azd04 "
   #end MOD-A50102 mod
    PREPARE r901_pre3 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare3:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
    END IF
    DISPLAY l_table
    DISPLAY l_table1
    DISPLAY l_table2
    DECLARE seq_cl CURSOR FOR r901_pre3
    FOREACH r901_cs1 INTO sr.* 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-710089 --begin
       LET l_sign_type =''           #MOD-A50102 add
       LET l_sign_show ='N'          #MOD-A50102 add      
       #TQC-BC0033---add---str---
       LET l_ima02 =''
       SELECT ima02 INTO l_ima02 FROM ima_file
        WHERE ima01 = sr.bmr.bmr07
       #TQC-BC0033---add---end---
       EXECUTE insert_prep USING
          sr.*,
         #"",l_img_blob,"N"    #FUN-940041    #MOD-A50102 mark
          l_sign_type,l_img_blob,l_sign_show,"",  #MOD-A50102 #TQC-C10034 add ""
          l_ima02                                 #TQC-BC0033 add l_ima02

       DECLARE r901_cs2 CURSOR FOR
          SELECT bms02,bms03 FROM bms_file
           WHERE bms01 = sr.bmr.bmr01
       FOREACH r901_cs2 INTO l_bms02,l_bms03
          IF SQLCA.sqlcode THEN EXIT FOREACH END IF
          EXECUTE insert_prep1 USING sr.bmr.bmr01,l_bms02,l_bms03
       END FOREACH
       LET l_k = 1
       FOREACH max_cl USING sr.bmr.bmrsign INTO l_a[l_k].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('max_cl error',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET l_k = l_k + 1
       END FOREACH
       LET p_type = 10
       LET l_k =  1
       FOREACH seq_cl USING sr.bmr.bmr01,p_type,sr.bmr.bmrsign INTO l_b[l_k].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('seq_cl error',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET l_k = l_k + 1
       END FOREACH
       FOR l_k =1 TO 15
           IF l_a[l_k].azc02 IS NULL AND l_b[l_k].azc02 IS NULL AND l_k <> 15
           THEN EXIT FOR
           END IF
           EXECUTE insert_prep2 USING sr.bmr.bmr01,l_a[l_k].*,l_b[l_k].*
       END FOR
#      OUTPUT TO REPORT r901_rep(sr.*)
#No.FUN-710089 --end
     END FOREACH
 
#No.FUN-710089 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmr01,bmr02') RETURNING tm.wc
     LET g_str = tm.a,";",tm.b,";",tm.wc,";",g_zz05,";",tm.type   #FUN-A60012 add tm.type
  #str MOD-A50102 mod
  # LET l_sql = " SELECT A.*,B.*,C.azc02,C.azc03,C.gen02_2,C.azd03,C.azd04,C.azc02_2,C.gen02_3 ",  #MOD-A50102 mod B.*
  ##TQC-730088 #"   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",
  #             "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",
  #             "   LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table1 CLIPPED," B ",
  #             "     ON A.bmr01 = B.bms01 ",
  #             "   LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table2 CLIPPED," C ",
  #             "     ON A.bmr01 = C.azd01"
    LET l_sql = " SELECT A.*,C.azd01,C.azc02,C.azc03,C.gen02_2,C.azd03,C.azd04,C.azc02_2,C.gen02_3 ",    #FUN-A60012 add azd01
                "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",
                "   LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table2 CLIPPED," C ",
                "     ON A.bmr01 = C.azd01","|",
                " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
  #end MOD-A50102 mod
   # CALL cl_prt_cs3('abmr901',l_sql,g_str) #TQC-730088
  ####FUN-940041 START ###
  #LET g_cr_table = l_table                 #主報表的temp table名稱
  #LET g_cr_gcx01 = "asmi300"               #單別維護程式
  #LET g_cr_apr_key_f = "bmr01"             #報表主鍵欄位名稱，用"|"隔開 
  #LET l_sql_2 = "SELECT DISTINCT bmr01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #PREPARE key_pr FROM l_sql_2
  #DECLARE key_cs CURSOR FOR key_pr
  #LET l_ii = 1
  ##報表主鍵值
  #CALL g_cr_apr_key.clear()                #清空
  #FOREACH key_cs INTO l_key.*            
  #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
  #   LET l_ii = l_ii + 1
  #END FOREACH
  ####FUN-940041 END ###
#TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "bmr01" 
#TQC-C10034--add--end
     CALL cl_prt_cs3('abmr901','abmr901',l_sql,g_str) 
 
#    FINISH REPORT r901_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710089 --end
END FUNCTION
 
#FUNCTION  r901_cur()
#  DEFINE   l_sql    LIKE type_file.chr1000      #No.FUN-680096 VARCHAR(1000)
#
#    LET l_sql  = "SELECT  azc02,azc03,gen02 ",
#                 " FROM azc_file,OUTER gen_file",
#                 " WHERE azc01 = ?  AND azc_file.azc03 = gen_file.gen01",
#                 " ORDER BY azc02  "
#     PREPARE r901_pre2 FROM l_sql
#     IF SQLCA.sqlcode != 0
#     THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#          EXIT PROGRAM
#     END IF
#     DECLARE max_cl CURSOR FOR r901_pre2
#
#     LET l_sql = "SELECT azd03,azd04,azc02,gen02 ",
#                 "  FROM azd_file,azc_file,OUTER gen_file ",
#                 " WHERE azd01 = ?       AND ",
#                 "       azd02 = ?       AND ",
#                 "       azc01 = ?       AND ",
#                 "       azc03 = azd03  AND azd_file.azd03 = gen_file.gen01",
#                 " ORDER BY azc02,azd04 "
#     PREPARE r901_pre3 FROM l_sql
#     IF SQLCA.sqlcode != 0
#     THEN CALL cl_err('prepare3:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#          EXIT PROGRAM
#     END IF
#     DECLARE seq_cl CURSOR FOR r901_pre3
#END FUNCTION
 
#No.FUN-710089 --begin
#REPORT r901_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
#          l_bms03   LIKE bms_file.bms03,
#	  l_sta     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(33)
#          p_type    LIKE type_file.num5,     #No.FUN-680096 SMALLINT
#          a         STRING,   #MOD-5A0403
#          l_k       LIKE type_file.num10,    #No.FUN-680096 INTEGER 
#          l_cnt     LIKE type_file.num5,     #No.FUN-680096 SMALLINT
#          l_a       DYNAMIC ARRAY OF RECORD
#                          azc02   LIKE azc_file.azc02,
#                          azc03   LIKE azc_file.azc03,
#                          gen02   LIKE gen_file.gen02
#                           END RECORD,
#          l_b       DYNAMIC ARRAY OF RECORD
#                          seq     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#                          azd04   LIKE azd_file.azd04,
#                          azc02   LIKE azc_file.azc02,
#                          gen02   LIKE gen_file.gen02
#                           END RECORD,
#          sr               RECORD
#                       bmr   RECORD LIKE bmr_file.*,
#	    			   gem02 LIKE gem_file.gem02,
#					   gen02 LIKE gen_file.gen02
#                       END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
# ORDER BY  sr.bmr.bmr01
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
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT g_dash[1,g_len]
##TQC-6A0083--add CLIPPED--begin
#      PRINT g_x[11] CLIPPED,sr.bmr.bmr01 CLIPPED,
#            COLUMN 51,g_x[12] CLIPPED,sr.bmr.bmr02
#      PRINT g_x[13] CLIPPED,sr.bmr.bmr07 CLIPPED #TQC-5A0034
#      PRINT g_x[14] CLIPPED,sr.bmr.bmr03 CLIPPED #TQC-5A0034
#      PRINT g_x[15] CLIPPED,sr.bmr.bmr05 CLIPPED,' ',sr.gem02 CLIPPED,
#			COLUMN 51,g_x[16] CLIPPED,sr.bmr.bmr06 CLIPPED,' ',sr.gen02 CLIPPED
#      LET l_last_sw = 'n'
##TQC-6A0083--add CLIPPED--end
#   BEFORE GROUP OF sr.bmr.bmr01 #異動單號
#	  IF PAGENO >0 OR LINENO > 9 THEN
# #        LET g_pageno = 0   #MOD-530217
#
#		 SKIP TO TOP OF PAGE
#      END IF
#      FOR l_k = 1 TO 15
#           LET l_a[l_k].azc02 = NULL
#           LET l_a[l_k].azc03 = NULL
#           LET l_a[l_k].gen02 = NULL
#           LET l_b[l_k].azd04 = NULL
#           LET l_b[l_k].azc02 = NULL
#           LET l_b[l_k].gen02 = NULL
#           LET l_b[l_k].seq   = NULL
#      END FOR
#
#   ON EVERY ROW
#      PRINT g_x[18] CLIPPED
#	  PRINT COLUMN 9,'(',sr.bmr.bmr08,')',g_x[19] CLIPPED,
#			COLUMN 24,'(',sr.bmr.bmr09,')',g_x[20] CLIPPED,
#			COLUMN 40,'(',sr.bmr.bmr10,')',g_x[21] CLIPPED
#	  PRINT COLUMN 09,'(',sr.bmr.bmr11,')',g_x[22] CLIPPED,
#	        COLUMN 24,'(',sr.bmr.bmr12,')',g_x[23] CLIPPED,
#			COLUMN 40,'(',sr.bmr.bmr13,')',g_x[24] CLIPPED
#	  PRINT COLUMN 09,'(',sr.bmr.bmr14,')',g_x[41] CLIPPED;
#      IF sr.bmr.bmr14 MATCHES '[Yy]' THEN
#				  PRINT sr.bmr.bmr141;
#      END IF
#	  PRINT ' '
#      PRINT COLUMN 09,'(',sr.bmr.bmr15,')',g_x[42] CLIPPED;
#      IF sr.bmr.bmr15 MATCHES '[Yy]' THEN
#				  PRINT sr.bmr.bmr151
#      END IF
#	  PRINT ' '
#	  IF tm.a MATCHES '[Yy]' THEN
#    	  PRINT g_x[27] CLIPPED
#    	  DECLARE r901_cs2 CURSOR FOR
#    			  SELECT bms03 FROM bms_file
#                   WHERE bms01 = sr.bmr.bmr01
#          LET l_cnt = 0
#          FOREACH r901_cs2 INTO l_bms03
#        	  IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#              PRINT COLUMN 9,l_bms03 CLIPPED
#              LET l_cnt = l_cnt + 1
#          END FOREACH
#          IF l_cnt = 0 THEN PRINT column 9,g_x[55] clipped  END IF
#  	  END IF
#    	  PRINT g_x[28] CLIPPED
##TQC-6A0083--add CLIPPED--BEGIN
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr26 CLIPPED,')',g_x[29] CLIPPED
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr27 CLIPPED,')',g_x[57] CLIPPED #MOD-640246
#    	  PRINT g_x[30] CLIPPED
#    	  CALL r901_metod(sr.bmr.bmr16) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr16 CLIPPED,')',g_x[31] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr17 CLIPPED
#    	  CALL r901_metod(sr.bmr.bmr18) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr18 CLIPPED,')',g_x[32] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr19 CLIPPED
#    	  CALL r901_metod(sr.bmr.bmr20) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr20 CLIPPED,')',g_x[33] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr21 CLIPPED
#    	  CALL r901_metod(sr.bmr.bmr22) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr22 CLIPPED,')',g_x[34] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr23 CLIPPED
#    	  CALL r901_metod(sr.bmr.bmr24) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr24 CLIPPED,')',g_x[35] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr25 CLIPPED
#          PRINT COLUMN 50,g_x[48] CLIPPED,COLUMN 56,
#	    		(sr.bmr.bmr17 CLIPPED+sr.bmr.bmr19 CLIPPED+sr.bmr.bmr21 CLIPPED+
#                 sr.bmr.bmr23 CLIPPED+sr.bmr.bmr25 CLIPPED)
#                        USING '###########&.&&&'
#    	  PRINT g_x[39] CLIPPED,COLUMN 40,g_x[36] CLIPPED
#    	  PRINT COLUMN 16,'(',sr.bmr.bmr30 CLIPPED,')',g_x[49] CLIPPED,
#    			COLUMN 55,'(',sr.bmr.bmr36 CLIPPED,')','Fireware'
#    	  PRINT COLUMN 16,'(',sr.bmr.bmr31 CLIPPED,')',g_x[50] CLIPPED,
#    			COLUMN 55,'(',sr.bmr.bmr37 CLIPPED,')','Sckematic'
#    	  PRINT COLUMN 16,'(',sr.bmr.bmr32 CLIPPED,')',g_x[37] CLIPPED,
#    			COLUMN 55,'(',sr.bmr.bmr38 CLIPPED,')','PACKING'
#    	  PRINT COLUMN 16,'(',sr.bmr.bmr33 CLIPPED,')',g_x[38] CLIPPED,
#     	        COLUMN 55,'(',sr.bmr.bmr39 CLIPPED,')','QVL'
# 	      PRINT COLUMN 16,'(',sr.bmr.bmr34 CLIPPED,')',g_x[42] CLIPPED;
#          IF sr.bmr.bmr34 MATCHES '[yY]' THEN
#          #MOD-5A0403-begin 備註長,獨立一行列印
#     	    # PRINT COLUMN 19,sr.bmr.bmr35;
#             LET a=sr.bmr.bmr35 CLIPPED
#             IF a.getLength() < 30 THEN
#     	        PRINT COLUMN 19,sr.bmr.bmr35 CLIPPED;
#             ELSE
#     	        PRINT COLUMN 19,sr.bmr.bmr35 CLIPPED
#             END IF
#          END IF
#          #MOD-5A0403-end
#     	  PRINT COLUMN 55,'(',sr.bmr.bmr40 CLIPPED,')','UL.CSA.FCC.VDE'
#     	  PRINT COLUMN 55,'(',sr.bmr.bmr41 CLIPPED,')','S/W'
#     	  PRINT COLUMN 55,'(',sr.bmr.bmr42 CLIPPED,')','BOM'
#     	  PRINT COLUMN 55,'(',sr.bmr.bmr43 CLIPPED,')','PCB'
#     	  PRINT COLUMN 55,'(',sr.bmr.bmr44 CLIPPED,')',g_x[40] CLIPPED
#    	  IF sr.bmr.bmr45 MATCHES '[yY]' THEN
#           #MOD-5A0403-begin 備註長,獨立一行列印
#     	   #  PRINT COLUMN 55,'(',sr.bmr.bmr45 CLIPPED,')',
#             PRINT g_x[36] CLIPPED
#     	     PRINT COLUMN 09,'(',sr.bmr.bmr45 CLIPPED,')',
#                   g_x[42] CLIPPED,sr.bmr.bmr46 CLIPPED
#           #MOD-5A0403-end
#          END IF
#          #簽核狀況
#          IF sr.bmr.bmr48 ='Y' AND tm.b ='Y' THEN
#             PRINT g_x[52] clipped,sr.bmr.bmrdays CLIPPED
#             PRINT g_x[53] clipped,sr.bmr.bmrprit CLIPPED
#             PRINT g_x[54] clipped
#             PRINT column 16,'---- ---------- ----------'
##TQC-6A0083--add CLIPPED--END
#             #讀取應簽人員
#             LET l_k = 1
#            FOREACH max_cl
#            USING sr.bmr.bmrsign
#            INTO l_a[l_k].*
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err('max_cl error',SQLCA.sqlcode,0)
#                 EXIT FOREACH
#              END IF
#              LET l_k = l_k + 1
#            END FOREACH
#            LET p_type = 10
#            LET l_k =  1
#
#            #讀取已簽人員
#            FOREACH seq_cl
#            USING sr.bmr.bmr01,p_type,sr.bmr.bmrsign
#            INTO l_b[l_k].*
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err('seq_cl error',SQLCA.sqlcode,0)
#                 EXIT FOREACH
#              END IF
#              LET l_k = l_k + 1
#           END FOREACH
#           FOR l_k =1 TO 15
#               IF l_a[l_k].azc02 IS NULL AND l_b[l_k].azc02 IS NULL
#               THEN EXIT FOR
#               END IF
#               PRINT column 16,l_a[l_k].azc02 CLIPPED using'###&',' ',
#                     l_a[l_k].gen02 CLIPPED,'   ',l_b[l_k].gen02 CLIPPED  #TQC-6A0083 add CLIPPED
#           END FOR
#        END IF
#
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
#              #No.TQC-630166 --start--
##             IF tm.wc[001,070] > ' ' THEN			# for 80
##       	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##        	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##        	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##        	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#              #No.TQC-630166 ---end---
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
### FUN-550101
#PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[56]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[56]
#             PRINT g_memo
#      END IF
### END FUN-550101
#
#END REPORT
#No.FUN-710089 --end
 
FUNCTION r901_metod(p_cmd)
DEFINE  p_cmd     LIKE bmr_file.bmr16,
        l_sta     LIKE type_file.chr50   #No.FUN-680096 VARCHAR(33)
		CASE p_cmd
		   WHEN 'A' LET l_sta = g_x[43]
		   WHEN 'B' LET l_sta = g_x[44]
		   WHEN 'C' LET l_sta = g_x[45]
		   WHEN 'D' LET l_sta = g_x[46]
		   WHEN 'E' LET l_sta = g_x[47]
		   OTHERWISE LET l_sta = ' '
        END CASE
        RETURN l_sta
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#TQC-970097 
