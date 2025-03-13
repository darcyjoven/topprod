# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abmg901.4gl
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
# Modify.........: No.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No:MOD-A50102 10/05/17 By Sarah CR Temptable增加bms02,將bms欄位獨立成一個Temptable
# Modify.........: No.FUN-A60012 10/06/02 By vealxu 新增列印BOM類別欄位 
# Modify.........: No.TQC-AB0041 10/12/20 By lixh1  修改SQL的BUG
# Modify.........: No.FUN-B40092 11/05/13 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/02/10 By chenying GR修改
# Modify.........: No.FUN-C40036 12/04/11 By xujing   GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50004 12/05/02 By nanbing GR 優化
# Modify.........: No.FUN-C30085 12/06/29 By nanbing GR 修改
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
###GENGRE###START
TYPE sr1_t RECORD
    bmr01 LIKE bmr_file.bmr01,
    bmr02 LIKE bmr_file.bmr02,
    bmr03 LIKE bmr_file.bmr03,
    bmr04 LIKE bmr_file.bmr04,
    bmr05 LIKE bmr_file.bmr05,
    bmr06 LIKE bmr_file.bmr06,
    bmr07 LIKE bmr_file.bmr07,
    bmr08 LIKE bmr_file.bmr08,
    bmr09 LIKE bmr_file.bmr09,
    bmr10 LIKE bmr_file.bmr10,
    bmr11 LIKE bmr_file.bmr11,
    bmr12 LIKE bmr_file.bmr12,
    bmr13 LIKE bmr_file.bmr13,
    bmr14 LIKE bmr_file.bmr14,
    bmr141 LIKE bmr_file.bmr141,
    bmr15 LIKE bmr_file.bmr15,
    bmr151 LIKE bmr_file.bmr151,
    bmr16 LIKE bmr_file.bmr16,
    bmr17 LIKE bmr_file.bmr17,
    bmr18 LIKE bmr_file.bmr18,
    bmr19 LIKE bmr_file.bmr19,
    bmr20 LIKE bmr_file.bmr20,
    bmr21 LIKE bmr_file.bmr21,
    bmr22 LIKE bmr_file.bmr22,
    bmr23 LIKE bmr_file.bmr23,
    bmr24 LIKE bmr_file.bmr24,
    bmr25 LIKE bmr_file.bmr25,
    bmr26 LIKE bmr_file.bmr26,
    bmr27 LIKE bmr_file.bmr27,
    bmr30 LIKE bmr_file.bmr30,
    bmr31 LIKE bmr_file.bmr31,
    bmr32 LIKE bmr_file.bmr32,
    bmr33 LIKE bmr_file.bmr33,
    bmr34 LIKE bmr_file.bmr34,
    bmr35 LIKE bmr_file.bmr35,
    bmr36 LIKE bmr_file.bmr36,
    bmr37 LIKE bmr_file.bmr37,
    bmr38 LIKE bmr_file.bmr38,
    bmr39 LIKE bmr_file.bmr39,
    bmr40 LIKE bmr_file.bmr40,
    bmr41 LIKE bmr_file.bmr41,
    bmr42 LIKE bmr_file.bmr42,
    bmr43 LIKE bmr_file.bmr43,
    bmr44 LIKE bmr_file.bmr44,
    bmr45 LIKE bmr_file.bmr45,
    bmr46 LIKE bmr_file.bmr46,
    bmr47 LIKE bmr_file.bmr47,
    bmr48 LIKE bmr_file.bmr48,
    bmr49 LIKE bmr_file.bmr49,
    bmrsign LIKE bmr_file.bmrsign,
    bmrdays LIKE bmr_file.bmrdays,
    bmrprit LIKE bmr_file.bmrprit,
    bmrsseq LIKE bmr_file.bmrsseq,
    bmrsmax LIKE bmr_file.bmrsmax,
    bmruser LIKE bmr_file.bmruser,
    bmrgrup LIKE bmr_file.bmrgrup,
    bmrmodu LIKE bmr_file.bmrmodu,
    bmrdate LIKE bmr_file.bmrdate,
    bmracti LIKE bmr_file.bmracti,
    bmrplant LIKE bmr_file.bmrplant,
    bmrlegal LIKE bmr_file.bmrlegal,
    bmroriu LIKE bmr_file.bmroriu,
    bmrorig LIKE bmr_file.bmrorig,
    bmrconf LIKE bmr_file.bmrconf,
    bmr50 LIKE bmr_file.bmr50,
    gem02 LIKE gem_file.gem02,
    gen02 LIKE gen_file.gen02,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000    #FUN-C40036 add
    ,l_ima02 LIKE ima_file.ima02        #TQC-BC0033 add
END RECORD

TYPE sr2_t RECORD
    bms01 LIKE bms_file.bms01,
    bms02 LIKE bms_file.bms02,
    bms03 LIKE bms_file.bms03
END RECORD

TYPE sr3_t RECORD
    azd01 LIKE azd_file.azd01,
    azc02 LIKE azc_file.azc02,
    azc03 LIKE azc_file.azc03,
    gen02_2 LIKE gen_file.gen02,
    azd03 LIKE azd_file.azd03,
    azd04 LIKE azd_file.azd04,
    azc02_2 LIKE azc_file.azc02,
    gen02_3 LIKE gen_file.gen02
END RECORD
###GENGRE###END

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
              "sign_show.type_file.chr1 "    #是否顯示簽核資料(Y/N)  #FUN-940041
             ,",sign_str.type_file.chr1000"  #簽核字串     #FUN-C40036 add
             ,",l_ima02.ima_file.ima02,"        #TQC-BC0033 add
   LET l_table = cl_prt_temptable('abmg901',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="bms01.bms_file.bms01,",
              "bms02.bms_file.bms02,",
              "bms03.bms_file.bms03"
   LET l_table1 = cl_prt_temptable('abmg9011',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="azd01.azd_file.azd01,",
              "azc02.azc_file.azc02,",
              "azc03.azc_file.azc03,",
              "gen02_2.gen_file.gen02,",
              "azd03.azd_file.azd03,",
              "azd04.azd_file.azd04,",
              "azc02_2.azc_file.azc02,",
              "gen02_3.gen_file.gen02"
   LET l_table2 = cl_prt_temptable('abmg9012',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
#No.FUN-710089 --end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
 #MOD-530299
   IF cl_null(g_bgjob) OR g_bgjob='N'
  #IF cl_null(tm.wc)                            #TQC-630177
      THEN CALL g901_tm()	             	# Input print condition
      ELSE #LET tm.wc="bmr01= '",tm.wc CLIPPED,"'"  #TQC-630177
           CALL abmg901()		          	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
END MAIN
 
FUNCTION g901_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW g901_w AT p_row, p_col
        WITH FORM "abm/42f/abmg901"
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
      LET INT_FLAG = 0 CLOSE WINDOW g901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
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
      LET INT_FLAG = 0 CLOSE WINDOW g901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmg901'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmg901','9031',1)
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
         CALL cl_cmdat('abmg901',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW g901_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmg901()
   ERROR ""
END WHILE
   CLOSE WINDOW g901_w
END FUNCTION
 
FUNCTION abmg901()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
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
   DEFINE l_ima02 LIKE ima_file.ima02   #TQC-BC0033 add                         
   ###FUN-940041 START ###
   DEFINE l_sql_2        LIKE type_file.chr1000   # RDSQL STATEMENT   
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_sign_type    LIKE type_file.chr1      #MOD-A50102 add
   DEFINE l_sign_show    LIKE type_file.chr1      #MOD-A50102 add
   DEFINE l_ii           INTEGER
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE bmr_file.bmr01
             END RECORD
   ###FUN-940041 END ###
 
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
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmg901'
#No.FUN-710089 --begin
     #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
                 " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,? ",  #FUN-940041 Add 3? #FUN-950045 add 5?
#                "        ?,?,?)"   #MOD-A50102 add 4?   #FUN-A60012 mark
                 "       ,?,?)"        #FUN-A60012 add     #FUN-C40036 add ? #FUN-C30085 add ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, #TQC-A40116 mod
                 " VALUES(?, ?, ?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
        EXIT PROGRAM
     END IF
     #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED, #TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
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
     PREPARE g901_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0
     THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
          EXIT PROGRAM
     END IF
     DECLARE g901_cs1 CURSOR FOR g901_prepare1
 
#No.FUN-710089 --begin
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#       THEN
#       LET l_name = g_rpt_name
#    ELSE
#       CALL cl_outnam('abmg901') RETURNING l_name
#    END IF
#    START REPORT g901_rep TO l_name
 
#    LET g_pageno = 0  #MOD-530217  #MOD-5A0403 造成頁次累計 取消mark
#No.FUN-710089 --end
 
#   CALL g901_cur()
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
    PREPARE g901_pre2 FROM l_sql
    IF SQLCA.sqlcode != 0
    THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
    CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM
    END IF
    DECLARE max_cl CURSOR FOR g901_pre2
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
    PREPARE g901_pre3 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare3:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
       EXIT PROGRAM
    END IF
    #FUN-C50004 sta
    LET l_sql  = "SELECT bms02,bms03 FROM bms_file ",
                 " WHERE bms01 = ? "
    PREPARE g901_pre4 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare4:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
       EXIT PROGRAM
    END IF
    DECLARE g901_cs2 CURSOR FOR g901_pre4
    #FUN-C50004 end
    DISPLAY l_table
    DISPLAY l_table1
    DISPLAY l_table2
    DECLARE seq_cl CURSOR FOR g901_pre3
    FOREACH g901_cs1 INTO sr.* 
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
          l_sign_type,l_img_blob,l_sign_show  #MOD-A50102
          ,""                                 #FUN-C40036 add 
          ,l_ima02                                 #TQC-BC0033 add l_ima02
      # DECLARE g901_cs2 CURSOR FOR           #FUN-C50004 mark 
      #    SELECT bms02,bms03 FROM bms_file   #FUN-C50004 mark 
      #     WHERE bms01 = sr.bmr.bmr01        #FUN-C50004 mark 
      #FOREACH g901_cs2 INTO l_bms02,l_bms03  #FUN-C50004 mark 
       FOREACH g901_cs2 USING sr.bmr.bmr01 INTO l_bms02,l_bms03 #FUN-C50004 add
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
#      OUTPUT TO REPORT g901_rep(sr.*)
#No.FUN-710089 --end
     END FOREACH
 
#No.FUN-710089 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmr01,bmr02') RETURNING tm.wc
###GENGRE###     LET g_str = tm.a,";",tm.b,";",tm.wc,";",g_zz05,";",tm.type   #FUN-A60012 add tm.type
  #str MOD-A50102 mod
  # LET l_sql = " SELECT A.*,B.*,C.azc02,C.azc03,C.gen02_2,C.azd03,C.azd04,C.azc02_2,C.gen02_3 ",  #MOD-A50102 mod B.*
  ##TQC-730088 #"   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",
  #             "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",
  #             "   LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table1 CLIPPED," B ",
  #             "     ON A.bmr01 = B.bms01 ",
  #             "   LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table2 CLIPPED," C ",
  #             "     ON A.bmr01 = C.azd01"
###GENGRE###    LET l_sql = " SELECT A.*,C.azd01,C.azc02,C.azc03,C.gen02_2,C.azd03,C.azd04,C.azc02_2,C.gen02_3 ",    #FUN-A60012 add azd01
###GENGRE###                "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",
###GENGRE###                "   LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table2 CLIPPED," C ",
###GENGRE###                "     ON A.bmr01 = C.azd01","|",
###GENGRE###                " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
  #end MOD-A50102 mod
   # CALL cl_prt_cs3('abmg901',l_sql,g_str) #TQC-730088
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
###GENGRE###     CALL cl_prt_cs3('abmg901','abmg901',l_sql,g_str) 

    LET g_cr_table = l_table                   #主報表的temp table名稱         #FUN-C40036 add
    LET g_cr_apr_key_f = "bmr01"       #報表主鍵欄位名稱，用"|"隔開  #FUN-C40036 add
    CALL abmg901_grdata()    ###GENGRE###
 
#    FINISH REPORT g901_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710089 --end
END FUNCTION
 
#FUNCTION  g901_cur()
#  DEFINE   l_sql    LIKE type_file.chr1000      #No.FUN-680096 VARCHAR(1000)
#
#    LET l_sql  = "SELECT  azc02,azc03,gen02 ",
#                 " FROM azc_file,OUTER gen_file",
#                 " WHERE azc01 = ?  AND azc_file.azc03 = gen_file.gen01",
#                 " ORDER BY azc02  "
#     PREPARE g901_pre2 FROM l_sql
#     IF SQLCA.sqlcode != 0
#     THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#          EXIT PROGRAM
#     END IF
#     DECLARE max_cl CURSOR FOR g901_pre2
#
#     LET l_sql = "SELECT azd03,azd04,azc02,gen02 ",
#                 "  FROM azd_file,azc_file,OUTER gen_file ",
#                 " WHERE azd01 = ?       AND ",
#                 "       azd02 = ?       AND ",
#                 "       azc01 = ?       AND ",
#                 "       azc03 = azd03  AND azd_file.azd03 = gen_file.gen01",
#                 " ORDER BY azc02,azd04 "
#     PREPARE g901_pre3 FROM l_sql
#     IF SQLCA.sqlcode != 0
#     THEN CALL cl_err('prepare3:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#          EXIT PROGRAM
#     END IF
#     DECLARE seq_cl CURSOR FOR g901_pre3
#END FUNCTION
 
#No.FUN-710089 --begin
#REPORT g901_rep(sr)
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
#    	  DECLARE g901_cs2 CURSOR FOR
#    			  SELECT bms03 FROM bms_file
#                   WHERE bms01 = sr.bmr.bmr01
#          LET l_cnt = 0
#          FOREACH g901_cs2 INTO l_bms03
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
#    	  CALL g901_metod(sr.bmr.bmr16) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr16 CLIPPED,')',g_x[31] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr17 CLIPPED
#    	  CALL g901_metod(sr.bmr.bmr18) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr18 CLIPPED,')',g_x[32] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr19 CLIPPED
#    	  CALL g901_metod(sr.bmr.bmr20) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr20 CLIPPED,')',g_x[33] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr21 CLIPPED
#    	  CALL g901_metod(sr.bmr.bmr22) RETURNING l_sta
#    	  PRINT COLUMN 9,'(',sr.bmr.bmr22 CLIPPED,')',g_x[34] CLIPPED,
#    			':',l_sta CLIPPED,COLUMN 59,sr.bmr.bmr23 CLIPPED
#    	  CALL g901_metod(sr.bmr.bmr24) RETURNING l_sta
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
 
FUNCTION g901_metod(p_cmd)
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

###GENGRE###START
FUNCTION abmg901_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr3      sr3_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40036 add
    CALL cl_gre_init_apr()   #FUN-C40036 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("abmg901")
        IF handler IS NOT NULL THEN
            START REPORT abmg901_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," B",
                        " ON A.bmr01 = B.azd01", 
                        " ORDER BY bmr01"
            DECLARE abmg901_datacur1 CURSOR FROM l_sql
            FOREACH abmg901_datacur1 INTO sr1.*,sr3.*
                OUTPUT TO REPORT abmg901_rep(sr1.*,sr3.*)
            END FOREACH
            FINISH REPORT abmg901_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT abmg901_rep(sr1,sr3)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    #FUN-B40092------add------str
    DEFINE l_bmr05_gem02 STRING
    DEFINE l_bmr06_gen02 STRING
    DEFINE l_bmr08       STRING
    DEFINE l_option      STRING
    DEFINE l_option1     STRING
    DEFINE l_option2     STRING
    DEFINE l_option3     STRING
    DEFINE l_option4     STRING
    DEFINE l_option5     STRING
    DEFINE l_option6     STRING
    DEFINE l_option7     STRING
    DEFINE l_option8     STRING
    DEFINE l_option9     STRING
    DEFINE l_option10    STRING
    DEFINE l_option11    STRING
    DEFINE l_option12    STRING
    DEFINE l_option13    STRING
    DEFINE l_option14    STRING
    DEFINE l_option15    STRING
    DEFINE l_option16    STRING
    DEFINE l_option17    STRING
    DEFINE l_option18    STRING
    DEFINE l_option19    STRING
    DEFINE l_option20    STRING
    DEFINE l_option21    STRING
    DEFINE l_bmr09       STRING
    DEFINE l_bmr10       STRING
    DEFINE l_bmr11       STRING
    DEFINE l_bmr12       STRING
    DEFINE l_bmr13       STRING
    DEFINE l_bmr14       STRING
    DEFINE l_bmr15       STRING
    DEFINE l_bmr16       STRING
    DEFINE l_bmr18       STRING
    DEFINE l_bmr20       STRING
    DEFINE l_bmr22       STRING
    DEFINE l_bmr24       STRING
    DEFINE l_bmr26       STRING
    DEFINE l_bmr27       STRING
    DEFINE l_bmr30       STRING
    DEFINE l_bmr31       STRING
    DEFINE l_bmr32       STRING
    DEFINE l_bmr33       STRING
    DEFINE l_bmr34       STRING
    DEFINE l_bmr36       STRING
    DEFINE l_bmr37       STRING
    DEFINE l_bmr38       STRING
    DEFINE l_bmr39       STRING
    DEFINE l_bmr40       STRING
    DEFINE l_bmr41       STRING
    DEFINE l_bmr42       STRING
    DEFINE l_bmr43       STRING
    DEFINE l_bmr44       STRING
    DEFINE l_bmr45       STRING
    DEFINE l_gen02       STRING
    DEFINE l_str1        STRING
    DEFINE l_str2        STRING
    DEFINE l_str3        STRING
    DEFINE l_str4        STRING
    DEFINE l_str5        STRING
    DEFINE l_str6        STRING
    DEFINE l_totle_sum  LIKE bmr_file.bmr17
    DEFINE l_bmr141  LIKE bmr_file.bmr141
    DEFINE l_bmr151  LIKE bmr_file.bmr151
    DEFINE l_sql         STRING
    DEFINE l_display    LIKE  type_file.chr1
    DEFINE l_display1   LIKE  type_file.chr1
    DEFINE l_display2   LIKE  type_file.chr1
    DEFINE l_display3   LIKE  type_file.chr1
    #FUN-B40092------add------end
    DEFINE l_bmrconf    STRING  #FUN-C30085 add
    DEFINE l_lineno LIKE type_file.num5

    
    ORDER EXTERNAL BY sr1.bmr01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.bmr01
            LET l_lineno = 0
        
        ON EVERY ROW
            #FUN-C30085 add sta
            CASE
               WHEN sr1.bmrconf ='Y'
                  LET l_bmrconf = cl_gr_getmsg("gre-292",g_lang,'Y')
               WHEN sr1.bmrconf ='N'
                  LET l_bmrconf = cl_gr_getmsg("gre-292",g_lang,'N')
               WHEN sr1.bmrconf ='X'
                  LET l_bmrconf = cl_gr_getmsg("gre-292",g_lang,'X')
               OTHERWISE
                  LET l_bmrconf = sr1.bmrconf
            END CASE
            PRINTX l_bmrconf
            #FUN-C30085 add end
            IF sr3.azc02 = 0 THEN        #FUN-C10036 add
               LET sr3.azc02 = NULL      #FUN-C10036 add
            END IF                       #FUN-C10036 add
            #FUN-B40092------add------str
            IF sr1.bmr48 = 'Y' AND tm.b = 'Y' THEN 
              LET l_display3 = 'Y'
            ELSE 
              LET l_display3 = 'N'
            END IF
 
            IF sr1.bmr45 ='Y' OR sr1.bmr45 ='y' THEN
               LET l_display2 = 'Y'
            ELSE
               LET l_display2 = 'N'
            END IF

            IF tm.a ='Y' OR tm.a = 'y' THEN 
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF

            IF sr1.bmr34 = 'Y' OR sr1.bmr34 = 'y' THEN
               LET l_display1 = 'Y'
            ELSE
               LET l_display1 = 'N'
            END IF
            
              
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE bms01 = '",sr1.bmr01 CLIPPED,"'"
            START REPORT abmg901_subrep01
            DECLARE abmg901_repcur1 CURSOR FROM l_sql
            FOREACH abmg901_repcur1 INTO sr2.*
                OUTPUT TO REPORT abmg901_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT abmg901_subrep01

            LET l_totle_sum = sr1.bmr17+sr1.bmr19+sr1.bmr21+sr1.bmr23+sr1.bmr25
            LET l_bmr43 = '(',sr1.bmr43,')',"PCB"
            LET l_bmr42 = '(',sr1.bmr42,')',"BOM"
            LET l_bmr41 = '(',sr1.bmr41,')',"S/W"
            LET l_bmr40 = '(',sr1.bmr40,')',"UL.CSA.FCC.VDE"
            LET l_bmr39 = '(',sr1.bmr39,')',"QVL"
            LET l_bmr38 = '(',sr1.bmr38,')',"PACKING"
            LET l_bmr36 = '(',sr1.bmr36,')',"Fireware" 
            LET l_bmr37 = '(',sr1.bmr37,')',"Sckematic"
            LET l_option21 = cl_gr_getmsg("gre-015",g_lang,7)
            LET l_bmr45 = '(',sr1.bmr45,')',l_option21,':' 
            IF sr1.bmr15 = 'Y' OR sr1.bmr15 = 'y' THEN
               LET l_bmr151 = sr1.bmr151
            END IF
            IF sr1.bmr15 = 'Y' OR sr1.bmr15 = 'y' THEN
               LET l_bmr151 = sr1.bmr151
            END IF
            LET l_option20 = cl_gr_getmsg("gre-015",g_lang,20)
            LET l_bmr44 = '(',sr1.bmr44,')',l_option20
            LET l_option19 = cl_gr_getmsg("gre-015",g_lang,19)
            LET l_bmr34 = '(',sr1.bmr34,')',l_option19
            LET l_option18 = cl_gr_getmsg("gre-015",g_lang,18)
            LET l_bmr33 = '(',sr1.bmr33,')',l_option18
            LET l_option17 = cl_gr_getmsg("gre-015",g_lang,17)
            LET l_bmr32 = '(',sr1.bmr32,')',l_option17
            LET l_option16 = cl_gr_getmsg("gre-015",g_lang,16)
            LET l_bmr31 = '(',sr1.bmr31,')',l_option16
            LET l_option15 = cl_gr_getmsg("gre-015",g_lang,15)
            LET l_bmr30 = '(',sr1.bmr30,')',l_option15
            LET l_option14 = cl_gr_getmsg("gre-015",g_lang,14)
            LET l_bmr27 = '(',sr1.bmr27,')',l_option14
            LET l_option13 = cl_gr_getmsg("gre-015",g_lang,13)
            LET l_bmr26 = '(',sr1.bmr26,')',l_option13
            LET l_option12 = cl_gr_getmsg("gre-015",g_lang,12)
            IF cl_null(sr1.bmr24) THEN
                LET l_bmr24 = "( )",l_option12,':'
            ELSE 
                LET l_bmr24 = '(',sr1.bmr24,')',l_option12,':'
            END IF

            LET l_option11 = cl_gr_getmsg("gre-015",g_lang,11)
            IF cl_null(sr1.bmr22) THEN
               LET l_bmr22 = "( )",l_option11,':'
            ELSE
               LET l_bmr22 = '(',sr1.bmr22,')',l_option11,':'
            END IF

            LET l_option10 = cl_gr_getmsg("gre-015",g_lang,10)
            IF cl_null(sr1.bmr20) THEN
               LET l_bmr20 = "( )",l_option10,':'
            ELSE 
               LET l_bmr20 = '(',sr1.bmr20,')',l_option10,':'
            END IF

            LET l_option9 = cl_gr_getmsg("gre-015",g_lang,9)
            IF cl_null(sr1.bmr18) THEN
               LET l_bmr18 = "( )",l_option9,':'
            ELSE
               LET l_bmr18 = '(',sr1.bmr18,')',l_option9,':'
            END IF
            LET l_option8 = cl_gr_getmsg("gre-015",g_lang,8) 
            IF cl_null(sr1.bmr16) THEN
               LET l_bmr16 = "( )",l_option8,':'
            ELSE
               LET l_bmr16 = '(',sr1.bmr16,')',l_option8,':'
            END IF

            LET l_option7 = cl_gr_getmsg("gre-015",g_lang,7)
            LET l_bmr15 = '(',sr1.bmr15,')',l_option7,':'

            LET l_option6 = cl_gr_getmsg("gre-015",g_lang,6)
            LET l_bmr14 = '(',sr1.bmr14,')',l_option6,':'

            LET l_option5 = cl_gr_getmsg("gre-015",g_lang,5)
            LET l_bmr13 = '(',sr1.bmr13,')',l_option5

            LET l_option4 = cl_gr_getmsg("gre-015",g_lang,4)
            LET l_bmr12 = '(',sr1.bmr12,')',l_option4

            LET l_option3 = cl_gr_getmsg("gre-015",g_lang,3)
            LET l_bmr11 = '(',sr1.bmr11,')',l_option3

            LET l_option2 = cl_gr_getmsg("gre-015",g_lang,2)
            LET l_bmr10 = '(',sr1.bmr10,')',l_option2

            LET l_option1 = cl_gr_getmsg("gre-015",g_lang,1)
            LET l_bmr09 = '(',sr1.bmr09,')',l_option1

            LET l_bmr05_gem02 = sr1.bmr05,' ',sr1.gem02
            LET l_bmr06_gen02 = sr1.bmr06,' ',sr1.gen02
            LET l_option = cl_gr_getmsg("gre-015",g_lang,0)
            LET l_bmr08 = '(',sr1.bmr08,')',l_option
            LET l_gen02 = sr3.gen02_2,' ',sr3.gen02_3
            LET l_str1  = cl_gr_getmsg("gre-016",g_lang,sr1.bmr16)
            LET l_str2  = cl_gr_getmsg("gre-016",g_lang,sr1.bmr18)
            LET l_str3  = cl_gr_getmsg("gre-016",g_lang,sr1.bmr20)
            LET l_str4  = cl_gr_getmsg("gre-016",g_lang,sr1.bmr22)
            LET l_str5  = cl_gr_getmsg("gre-016",g_lang,sr1.bmr24)
            LET l_str6  = cl_gr_getmsg("gre-021",g_lang,tm.type)      

      
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX l_str6
            PRINTX l_gen02
            PRINTX l_str1 
            PRINTX l_str2
            PRINTX l_str3
            PRINTX l_str4
            PRINTX l_str5
            PRINTX l_bmr05_gem02
            PRINTX l_bmr06_gen02
            PRINTX l_bmr08
            PRINTX l_bmr09
            PRINTX l_bmr10
            PRINTX l_bmr11
            PRINTX l_bmr12
            PRINTX l_bmr13
            PRINTX l_bmr14
            PRINTX l_bmr15
            PRINTX l_bmr16
            PRINTX l_bmr18
            PRINTX l_bmr20
            PRINTX l_bmr22
            PRINTX l_bmr24
            PRINTX l_bmr26
            PRINTX l_bmr27
            PRINTX l_bmr36
            PRINTX l_bmr37
            PRINTX l_bmr38
            PRINTX l_bmr39
            PRINTX l_bmr40
            PRINTX l_bmr41
            PRINTX l_bmr42
            PRINTX l_bmr43
            PRINTX l_bmr33
            PRINTX l_bmr30
            PRINTX l_bmr31
            PRINTX l_bmr32
            PRINTX l_bmr34
            PRINTX l_bmr44
            PRINTX l_bmr45
            PRINTX l_bmr141
            PRINTX l_bmr151
            PRINTX l_totle_sum
            PRINTX l_display
            PRINTX l_display1
            PRINTX l_display2
            PRINTX l_display3
            #FUN-B40092------add------end
     
            PRINTX sr1.*
            PRINTX sr3.*
           
        AFTER GROUP OF sr1.bmr01

        
        ON LAST ROW

END REPORT

REPORT abmg901_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE sr2_t sr2_t
    DEFINE l_display LIKE type_file.chr1
    FORMAT
        ON EVERY ROW
            IF sr2_t.bms01 = sr2.bms01 THEN 
               LET l_display = 'N'
            ELSE
               LET l_display = 'Y'
            END IF
            LET sr2_t.* = sr2.*
            PRINTX l_display
            PRINTX sr2_t.*
            PRINTX sr2.*
END REPORT

###GENGRE###END
