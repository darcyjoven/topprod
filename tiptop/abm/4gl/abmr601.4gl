# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr601.4gl
# Descriptions...: 多階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/02 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
#                  92/04/01 By Lin REPORT 格式修改, 並增加料件供應商的列印
#      Modify    : 92/05/27 By David
# Modify.........: 94/08/23 By Danny (改由bmt_file取插件位置)
# Modify.........: 99/09/14 By Carol:數量check生產單位及庫存單位之換算
# Modify.........: No.FUN-4A0004 04/10/04 By Yuna 主件料件開窗
# Modify.........: No.FUN-550095 05/05/25 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-590110 05/08/22 By vivien  憑証類報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.MOD-620071 06/02/23 By Claire 列印工程資料時,漏印插件位置
# Modify.........: No.MOD-640152 06/04/09 By vivien 無資料時，應顯示“無報表資料產生”
# Modify.........: No.TQC-650017 06/05/09 By Tracy 續MOD-640152
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0108 06/11/23 By Ray 抬頭與頁次寫法應與11相同，不能改為template表頭寫法
# Modify.........: No.TQC-6B0142 06/12/05 By claire 確保cl_numfor3傳入值不為 null
# Modify.........: No.MOD-6C0005 06/12/15 By pengu 報表資料顯示異常
# Modify.........: No.TQC-740079 07/04/18 By Ray 報表增加總頁次
# Modify.........: No.MOD-750106 07/05/28 By pengu 沒有按照 BOM 表階次排序 
# Modify.........: No.TQC-750225 07/05/29 By arman 制表者位于公司名和表單名之間
# Modify.........: No.TQC-770089 07/08/01 By Rayven 打印報寬度錯
# Modify.........: No.TQC-760170 07/08/29 By claire 調整列印的語法
# Modify.........: No.TQC-790039 07/09/18 By Judy "損耗%"欄位下面出現"*****"
# Modify.........: No.TQC-7A0013 07/10/10 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-7A0078 07/10/30 By Carrier CR階層方式-排序有問題
# Modify.........: No.MOD-7B0058 07/11/07 By Carrier 加入特性代碼內容
# Modify.........: No.CHI-810006 08/01/21 By zhoufeng 調整插件位置及說明的列印  
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-8C0269 08/07/22 By claire 調整語法與abmr602一致
# Modify.........: No.TQC-8C0063 08/12/30 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.MOD-A40049 10/04/13 By Summer g_bma01變數在程式裡已沒有用到,直接mark
# Modify.........: No.TQC-A40116 10/04/26 By liuxqa modify sql
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代的內容
# Modify.........: No.CHI-B60051 11/06/16 By Vampire 註解 bmb14, bmb15, bmb16, bmbm17 代碼轉換
# Modify.........: No.FUN-B80100 11/08/10 By fengrui 程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui 調整時間函數問題
# Modify.........: No.TQC-C50120 12/05/15 By fengrui 抓BOM資料時，除去無效資料 
# Modify.........: No.TQC-CC0070 12/12/11 By qirl 增加開窗
# Modify.........: No.TQC-CC0073 12/12/12 By qirl修改bmc05的長度
# Modify.........: No:MOD-D10127 13/01/28 By bart "主件料件數量"同sfb08可入小數位數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				    # Print condition RECORD
        		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
           		revision  LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
   	        	effective LIKE type_file.dat,     #No.FUN-680096 DATE
        		#a         LIKE type_file.num10,   #No.FUN-680096 INTEGER #MOD-D10127
                a         LIKE sfb_file.sfb08,    #MOD-D10127
           		engine    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	        	arrange   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        		vender    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        loc       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           		more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_total         LIKE type_file.num10, #No.FUN-680096 INTEGER
          g_bma01         LIKE bma_file.bma01,  #產品結構單頭
          g_bma06         LIKE bma_file.bma06,  #FUN-550095 add
          g_bma01_a       LIKE bma_file.bma01,  #產品結構單頭
          g_bma06_a       LIKE bma_file.bma06,  #FUN-550095 add
          g_azi02,g_azi02_2   LIKE azi_file.azi02,
          g_azi03_2   LIKE azi_file.azi03,
          g_azi04_2   LIKE azi_file.azi04,
          g_azi05_2   LIKE azi_file.azi05
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
DEFINE   l_str9          STRING   #No.FUN-590110
DEFINE   g_flag          LIKE type_file.num5      #No.TQC-740079
DEFINE   totpageno       LIKE type_file.num5      #No.TQC-740079
DEFINE   l_table1        STRING     #No.TQC-7A0013
DEFINE   l_table2        STRING     #No.TQC-7A0013
DEFINE   l_table3        STRING     #No.TQC-7A0013
DEFINE   l_table4        STRING     #No.TQC-7A0013
DEFINE   g_str           STRING     #No.TQC-7A0013
DEFINE   g_sql           STRING     #No.TQC-7A0013
DEFINE   g_no            LIKE type_file.num10     #No.FUN-7A0078
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
   LET g_sql = " g_bma01_a.bma_file.bma01,",
               " g_bma06_a.bma_file.bma06,",
               " p_level.type_file.num5,",
               " p_i.type_file.num5,",
               " p_total.csa_file.csa0301,",
               " bmb15.bmb_file.bmb15,",
               " bmb16.bmb_file.bmb16,",
               " bmb03.bmb_file.bmb03,",
               " bmb01.bmb_file.bmb01,",
               " bmb29.bmb_file.bmb29,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima02,",
               " ima05.ima_file.ima05,",
               " ima06.ima_file.ima06,",
               " ima08.ima_file.ima08,",
               " ima15.ima_file.ima15,",
               " ima37.ima_file.ima37,",
               " ima63.ima_file.ima63,",
               " ima55.ima_file.ima55,",
               " bmb23.bmb_file.bmb23,",
               " bmb02.bmb_file.bmb02,",
               " bmb06.bmb_file.bmb06,",
               " bmb08.bmb_file.bmb08,",
               " bmb10.bmb_file.bmb10,",
               " bmb18.bmb_file.bmb18,",
               " bmb09.bmb_file.bmb09,",
               " bmb04.bmb_file.bmb04,",
               " bmb05.bmb_file.bmb05,",
               " bmb14.bmb_file.bmb14,",
               " bmb17.bmb_file.bmb17,",
               " bmb11.bmb_file.bmb11,",
               " bmb13.bmb_file.bmb13,",
               " bma01.bma_file.bma01,",
               " l_ima02.ima_file.ima02,",
               " l_ima021.ima_file.ima02,",
               " l_ima05.ima_file.ima05,",
               " l_ima06.ima_file.ima06,",
               " l_ima08.ima_file.ima08,",
               " l_ima37.ima_file.ima37,",
               " l_ima63.ima_file.ima63,",
               " l_ima55.ima_file.ima55,",
               " l_bma02.bma_file.bma02,",
               " l_bma03.bma_file.bma03,",
               " l_bma04.bma_file.bma04,",
               " l_imz02.imz_file.imz02,",
               " l_ver.ima_file.ima05,  ",
               " l_bmb06.type_file.chr20, ",
               " l_total.type_file.chr20, ",
               " l_str2.type_file.chr20, ",
               " l_str9.type_file.chr20, ",
               " l_lineno.type_file.num10  "  #No.FUN-7A0078
 
   LET l_table1 = cl_prt_temptable('abmr6011',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " bmt01.bmt_file.bmt01,",
               " bmt02.bmt_file.bmt02,",
               " bmt03.bmt_file.bmt03,",
               " bmt04.bmt_file.bmt04,",
               " bmt08.bmt_file.bmt08,",
               " bmt05.bmt_file.bmt05,",
               " bmt06.type_file.chr1000 "    #No.CHI-810006 
 
   LET l_table2 = cl_prt_temptable('abmr6012',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " bmc01.bmc_file.bmc01,",
               " bmc02 .bmc_file.bmc02 ,",
               " bmc021.bmc_file.bmc021,",
               " bmc03.bmc_file.bmc03,",
               " bmc06.bmc_file.bmc06,",
               " bmc04.bmc_file.bmc04,",
               " bmc05.type_file.chr1000 "    #No.CHI-810006
 
   LET l_table3 = cl_prt_temptable('abmr6013',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " l_pmh01.pmh_file.pmh01,",
               " l_pmh02.pmh_file.pmh02,",
               " l_pmh03.pmh_file.pmh03,",
               " l_pmh04.pmh_file.pmh04,",
               " l_pmh05.pmh_file.pmh05,",
               " l_pmh12.pmh_file.pmh12,",
               " l_pmh13.pmh_file.pmh13,",
               " l_pmc03.pmc_file.pmc03 " 
 
   LET l_table4 = cl_prt_temptable('abmr6014',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
 
 
   DROP TABLE r601_tmp
   CREATE TEMP TABLE r601_tmp(
     flag    LIKE type_file.num5,
     cnt     LIKE type_file.num20_6)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.engine  = ARG_VAL(10)
   LET tm.arrange = ARG_VAL(11)
   LET tm.a = ARG_VAL(12)
   LET tm.vender = ARG_VAL(13)
   LET tm.loc    = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r601_tm(0,0)			# Input print condition
      ELSE CALL abmr601()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r601_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,	#工程變異之生效日期
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 6 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 6
   END IF
 
   OPEN WINDOW r601_w AT p_row,p_col
        WITH FORM "abm/42f/abmr601"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 1
   LET tm.engine ='N'   #不列印工程技術資料
   LET tm.arrange = g_sma.sma65
   LET tm.effective = g_today	#有效日期
   LET tm.vender = 'N'
   LET tm.loc    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,ima06,ima09,ima10,ima11,ima12 #FUN-550095 add bma06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(bma01) #料件編號
           CALL cl_init_qry_var()
 	   LET g_qryparam.state= "c"
 	   LET g_qryparam.form = "q_ima3"
 	   CALL cl_create_qry() RETURNING g_qryparam.multiret
 	   DISPLAY g_qryparam.multiret TO bma01
 	   NEXT FIELD bma01
#---TQC-CC0070--add--star--
            WHEN INFIELD(bma06) #主件料件
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form  = "q_a3"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bma06
              NEXT FIELD bma06
            WHEN INFIELD(ima06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            WHEN INFIELD(ima09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima09_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            WHEN INFIELD(ima10)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima10_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima10
            WHEN INFIELD(ima11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima11_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima11
               NEXT FIELD ima11
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima12_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
#---TQC-CC0070--add-end---
         OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION locale
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 ",
                 "FROM bma_file,ima_file",
                 " WHERE bma01=ima01 AND ima08 !='A' ",
                 "AND ",tm.wc CLIPPED," GROUP BY bma01"
       PREPARE r601_cnt_p FROM l_cmd
       DECLARE r601_cnt CURSOR FOR r601_cnt_p
       IF SQLCA.sqlcode THEN
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       OPEN r601_cnt
       FETCH r601_cnt INTO g_cnt,l_bma01
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
       ELSE
           IF g_cnt=1 THEN
               LET l_one='Y'
           END IF
       END IF
   END IF
 
   INPUT BY NAME tm.revision,tm.effective,tm.a,
      tm.engine,tm.arrange,tm.vender,tm.loc,tm.more
      WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      BEFORE FIELD revision
         IF l_one='N' THEN
             NEXT FIELD effective
         END IF
      AFTER FIELD revision
         IF tm.revision IS NOT NULL ThEN
            CALL s_version(l_bma01,tm.revision)
            RETURNING l_bdate,l_edate,l_flag
            LET tm.effective = l_bdate
            DISPLAY BY NAME tm.effective
         END IF
	  AFTER FIELD a
		 IF tm.a IS NULL OR tm.a < 0 THEN
			LET tm.a = 1
			DISPLAY BY NAME tm.a
		 END IF
      AFTER FIELD engine
         IF tm.engine NOT MATCHES '[YN]' THEN
             NEXT FIELD engine
         END IF
      AFTER FIELD arrange
		 IF tm.arrange NOT MATCHES '[123]' THEN
		     NEXT FIELD arrange
		 END IF
      AFTER FIELD vender
         IF tm.vender NOT MATCHES '[YN]' OR tm.vender IS NULL THEN
             NEXT FIELD vender
         END IF
      AFTER FIELD loc
		 IF tm.loc NOT MATCHES '[12]' THEN
		     NEXT FIELD loc
		 END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr601'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr601','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.revision CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'",
                         " '",tm.engine CLIPPED,"'",
                         " '",tm.arrange CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.vender CLIPPED,"'",
                         " '",tm.loc    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr601',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r601_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr601()
   ERROR ""
END WHILE
   CLOSE WINDOW r601_w
END FUNCTION
 
FUNCTION abmr601()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_ute_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
	  l_cnt,l_cnt2  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_bma01       LIKE bma_file.bma01,    #主件料件
          l_bma06       LIKE bma_file.bma06,    #FUN-550095 add bma06
          l_ima02       LIKE ima_file.ima02,    #品名規格
          l_ima021      LIKE ima_file.ima02,    #品名規格
          l_ima05       LIKE ima_file.ima05,    #版本
          l_ima06       LIKE ima_file.ima06,    #版本
          l_ima08       LIKE ima_file.ima08,    #來源
          l_ima37       LIKE ima_file.ima37,    #補貨
          l_ima63       LIKE ima_file.ima63,    #發料單位
          l_ima55       LIKE ima_file.ima55,    #生產單位
          l_bma02       LIKE bma_file.bma02,    #品名規格
          l_bma03       LIKE bma_file.bma03,    #品名規格
          l_bma04       LIKE bma_file.bma04,    #品名規格
          l_imz02       LIKE imz_file.imz02,    #說明內容
          l_str,l_cmd   STRING,     #No.TQC-740079
          sr  RECORD
              order1  LIKE type_file.chr20, #No.FUN-680096 VARCHAR(20)
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
              bmb23 LIKE bmb_file.bmb23,    #選中率
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01,
              bmb01 LIKE bmb_file.bmb01, #FUN-550095 add bmb01
              bmb29 LIKE bmb_file.bmb29  #FUN-550095 add bmb29
           END RECORD
 
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
 
     LET g_no = 1   #No.FUN-7A0078
     #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,  #No.TQC-A40116 mark
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, #NO.TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?                           ) "  #No.FUN-7A0078
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,  #No.TQC-A40116 mark
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,   #No.TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?  )        "
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table3 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,  #TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?  )        "
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table4 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,  #TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ? )      "
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
 
     LET l_sql = "SELECT UNIQUE bma01,bma06 ", #FUN-550095 add bma06
                 " FROM bma_file, ima_file",
                 " WHERE ima01 = bma01",
                 " AND ima08 !='A' AND ",tm.wc
     PREPARE r601_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r601_cs1 CURSOR FOR r601_prepare1
 

     CALL r601_cur()
     LET g_success ='Y'
     FOREACH r601_cs1 INTO l_bma01,l_bma06 #FUN-550095 add bma06
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01=l_bma01
       LET g_bma01_a=l_bma01
       LET g_bma06_a=l_bma06

       CALL r601_bom(0,l_bma01,l_bma06,tm.a) #FUN-550095 add bma06
       IF g_success = 'N'  THEN EXIT FOREACH END IF
     END FOREACH
 

     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
                 
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bma01,bma06,ima06,ima09,ima10,ima11,ima12')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.effective,";",g_sma.sma118,";",
                 g_sma.sma888[1,1],";",g_azi03,";",
                 tm.loc,";",tm.vender,";",tm.engine
     CALL cl_prt_cs3('abmr601','abmr601',g_sql,g_str)
END FUNCTION
 
FUNCTION r601_cur()
  DEFINE  l_sql1,l_sql2   LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(1000)
 
      LET l_sql1= "SELECT ",
                  " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13,pmc03 ",
                  " FROM pmh_file,pmc_file",
                  " WHERE pmh_file.pmh02=pmc_file.pmc01 AND pmh01 = ? ",
                  "   AND pmh21 = ' ' ",                                           #CHI-860042                                      
                  "   AND pmh23 = ' ' ",                                           #CHI-960033
                  "   AND pmh22 = '1' ",                                           #CHI-860042
                  "   AND pmhacti = 'Y'"                                           #CHI-910021
      PREPARE r601_p2  FROM l_sql1
        IF SQLCA.sqlcode THEN
	    	CALL cl_err('P2:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM
   
        END IF
      DECLARE r601_c2 CURSOR FOR r601_p2
END FUNCTION
 
FUNCTION r601_bom(p_level,p_key,p_key2,p_total)  #FUN-550095 add p_key2
   DEFINE p_level	LIKE type_file.num5,   #階數   #No.FUN-680096 SMALLINT
          p_total       LIKE cae_file.cae07,   #用量   #No.FUN-680096 DEC(15,5)
          p_key		LIKE bma_file.bma01,   #主件料件編號
          p_key2        LIKE bma_file.bma06,   #FUN-550095 add p_key2
          l_ac,i	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_tot,l_times LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_chr,l_cnt   LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301, #No.FUN-680096 DEC(13,5)
          l_bmaacti     LIKE bma_file.bmaacti, #No.TQC-C50120 add
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb01 LIKE bmb_file.bmb01,    #主件     #No.B393 add
              bmb29 LIKE bmb_file.bmb29,    #FUN-550095 add bmb29
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima63 LIKE ima_file.ima63,    #發料單位
              ima55 LIKE ima_file.ima55,    #生產單位
              bmb23 LIKE bmb_file.bmb23,    #選中率
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01         
          END RECORD,
          l_cmd	    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
DEFINE k      LIKE type_file.num5    #No.FUN-590110        #No.FUN-680096 SMALLINT
DEFINE    l_ima02       LIKE ima_file.ima02,    #品名規格
          l_ima021      LIKE ima_file.ima02,    #品名規格
          l_ima05       LIKE ima_file.ima05,    #版本
          l_ima06       LIKE ima_file.ima06,    #版本
          l_ima08       LIKE ima_file.ima08,    #來源
          l_ima37       LIKE ima_file.ima37,    #補貨
          l_ima63       LIKE ima_file.ima63,    #發料單位
          l_ima55       LIKE ima_file.ima55,    #生產單位
          l_bma02       LIKE bma_file.bma02,    #品名規格
          l_bma03       LIKE bma_file.bma03,    #品名規格
          l_bma04       LIKE bma_file.bma04,    #品名規格
          l_imz02       LIKE imz_file.imz02,    #說明內容
          l_use_flag    LIKE type_file.chr2,           
       #  l_ute_flag    LIKE type_file.chr2,      #FUN-A40058      
          l_ute_flag    LIKE type_file.chr3,      #FUN-A40058         
          l_level       LIKE type_file.num5,
          l_pmh01       LIKE pmh_file.pmh01,
          l_pmh02       LIKE pmh_file.pmh02,
          l_pmh03       LIKE pmh_file.pmh03,
          l_pmh04       LIKE pmh_file.pmh04,
          l_pmh05       LIKE pmh_file.pmh05,
          l_pmh12       LIKE pmh_file.pmh12,
          l_pmh13       LIKE pmh_file.pmh13,
          l_pmc03       LIKE pmc_file.pmc03,
          l_ver         LIKE ima_file.ima05,
          l_k           LIKE type_file.num5,          
          l_str2        LIKE type_file.chr20,         
          l_str9        LIKE type_file.chr20,         
          l_bmb06,l_total LIKE type_file.chr20,  
          t_total        LIKE bmb_file.bmb06,
          l_bmt05        LIKE bmt_file.bmt05,
          l_bmc04        LIKE bmc_file.bmc04,
          l_bmt06_s      LIKE bmc_file.bmc06
          DEFINE                                                                
          l_now,l_now2  SMALLINT,                                               
          l_bmt06 ARRAY[200] OF VARCHAR(20),                                       
          l_byte,l_len   SMALLINT,                                              
          l_bmtstr      LIKE bmc_file.bmc06,                                    
#---TQC-CC0073 mod--
          l_bmc05 ARRAY[200] OF VARCHAR(255),                                       
          l_bmc051 ARRAY[200] OF VARCHAR(255)                                       
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.TQC-8C0063 
 
    #TQC-C50120--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file
     WHERE bma01 = p_key
       AND bma06 = p_key2 
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50120--add--end--
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
        CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
        SELECT ima02,ima021,ima05,ima06,ima08,
               ima37,ima63,ima55
          INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
               l_ima37,l_ima63,l_ima55
          FROM ima_file
         WHERE ima01=g_bma01_a
        IF SQLCA.sqlcode THEN
            LET l_ima02='' LET l_ima05=''
            LET l_ima06='' LET l_ima08=''
            LET l_ima37='' LET l_ima63='' LET l_ima55=''
        END IF
       SELECT bma02,bma03,bma04
         INTO l_bma02,l_bma03,l_bma04
         FROM bma_file
        WHERE bma01=g_bma01_a
          AND bma06=g_bma06_a
        IF SQLCA.sqlcode THEN
            LET l_bma02='' LET l_bma03='' LET l_bma04=''
        END IF
        SELECT imz02 INTO l_imz02
            FROM imz_file
            WHERE imz01=l_ima06
        IF SQLCA.sqlcode THEN
            LET l_imz02=''
        END IF
        EXECUTE insert_prep USING g_bma01_a,g_bma06_a,'1','0',tm.a,sr[1].*,
                l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima37,l_ima63,
                l_ima55,l_bma02,l_bma03,l_bma04,l_imz02,l_ver,'','','','',
                g_no           #No.FUN-7A0078
        LET g_no = g_no + 1    #No.FUN-7A0078
    END IF
    LET arrno = 600
	LET l_times=1
    WHILE TRUE
        LET l_cmd=
         "SELECT bmb15,bmb16,bmb03,bmb01,bmb29,ima02,ima021,ima05,ima06,ima08,ima15,", #FUN-550095 add bmb29
            "ima37,ima63,ima55,bmb23,bmb02,bmb06/bmb07,bmb08,bmb10,",
            "bmb18,bmb09,bmb04,bmb05,bmb14,",
            "bmb17,bmb11,bmb13,bma01",
            " FROM bmb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"'",  #AND bmb02 >",b_seq,  #MOD-8C0269 mark
            "   AND bmb29='", p_key2,"'", #FUN-550095 add
	    " AND ima_file.ima08 != 'A' ",    #MOD-8C0269 add
            " AND bmb_file.bmb03 = ima_file.ima01",    #No.MOD-7B0058
            " AND bmb29 = bma_file.bma06",    #No.MOD-7B0058
            " AND bmb_file.bmb03 = bma_file.bma01"     #No.MOD-7B0058
        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
        END IF
 
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY bmb01,bmb29, " #FUN-550095 add bmb01,bmb29
 
    	CASE WHEN tm.arrange = '1'
                  LET l_cmd = l_cmd CLIPPED, ' bmb02'
	         WHEN tm.arrange = '2'
                  LET l_cmd = l_cmd CLIPPED, ' bmb03'
	         WHEN tm.arrange = '3'
                  LET l_cmd = l_cmd CLIPPED, ' bmb13'
        END CASE
        
        PREPARE r601_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
	 	CALL cl_err('P1:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM
   
        END IF
        DECLARE r601_cur CURSOR FOR r601_ppp
 
        LET l_ac = 1
        FOREACH r601_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
  	   LET g_total=g_total+1
           LET l_ac = l_ac + 1			# 但BUFFER不宜太大
           IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH

    	LET l_tot=l_ac-1

        FOR i = 1 TO l_tot		# 讀BUFFER傳給REPORT
             LET l_str9=''
             IF p_level >1 THEN
               FOR k = 2 TO p_level
                   LET l_str9=l_str9,' '
               END FOR
             END IF

            #MOD-A40049 mark --start--
            #SELECT bmb01,bmb29 INTO g_bma01,g_bma06 FROM bmb_file,bma_file #FUN-550095 add bmb29
            # WHERE bmb03=sr[i].bmb03 AND bmb02=sr[i].bmb02
            #   AND bmb01=bma01
            #   AND bmb29=bma06 #FUN-550095 add
            #MOD-A40049 mark --end--

              LET l_fac = 1
              IF sr[i].ima55 !=sr[i].bmb10 THEN
                 CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,sr[i].ima55)
                               RETURNING l_cnt,l_fac    #單位換算
                 IF l_cnt = '1'  THEN #有問題
                    CALL cl_err(sr[i].bmb03,'abm-731',1)
                    LET g_success = 'N'
                    EXIT FOR
                    RETURN
                 END IF
              END IF
            CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
            SELECT ima02,ima021,ima05,ima06,ima08,
                   ima37,ima63,ima55
              INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
                   l_ima37,l_ima63,l_ima55
              FROM ima_file
             WHERE ima01=g_bma01_a
            IF SQLCA.sqlcode THEN
                LET l_ima02='' LET l_ima05=''
                LET l_ima06='' LET l_ima08=''
                LET l_ima37='' LET l_ima63='' LET l_ima55=''
            END IF
            SELECT bma02,bma03,bma04
              INTO l_bma02,l_bma03,l_bma04
              FROM bma_file
            WHERE bma01=g_bma01_a
              AND bma06=g_bma06_a
            IF SQLCA.sqlcode THEN
                LET l_bma02='' LET l_bma03='' LET l_bma04=''
            END IF
            SELECT imz02 INTO l_imz02
              FROM imz_file
             WHERE imz01=l_ima06
            IF SQLCA.sqlcode THEN
                LET l_imz02=''
            END IF
            #CHI-B60051 --- modify --- start ---
            ##---->改變使用特性的表示方式
            #IF sr[i].bmb15 = 'Y' THEN
            #   LET sr[i].bmb15='*'
            #ELSE
            #   LET sr[i].bmb15=' '
            #END IF
            ##---->改變替代特性的表示方式
            #LET l_ute_flag='USZ'                      #FUN-A40058
            #IF sr[i].bmb16 MATCHES '[127]' THEN       #FUN-A40058 add '7'
            #   LET g_cnt=sr[i].bmb16 USING '&'
            #   LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]
            #ELSE
            #   LET sr[i].bmb16=' '
            #END IF
            ###---->元件使用特性
            #IF sr[i].bmb14 ='1' THEN 
            #   LET sr[i].bmb14 ='O'
            #ELSE 
            #   LET sr[i].bmb14 = ''
            #END IF
            ##---->特性旗標
            #IF sr[i].bmb17='Y' THEN 
            #   LET sr[i].bmb17='F'
            #ELSE 
            #   LET sr[i].bmb17=' '
            #END IF
            #---->內縮以'.'表示
            LET l_str2 =''
            IF p_level>10 THEN LET l_level=10 ELSE LET l_level = p_level END IF
            IF l_level > 1 THEN
               FOR l_k = 1 TO l_level  -1
                   LET l_str2 = l_str2 clipped,'.' clipped
               END FOR
            ELSE 
               LET l_str2 =''
            END IF
            #---->為使用量可列印出
            IF cl_null(sr[i].bmb06) THEN LET sr[i].bmb06=0 END IF
            LET t_total = p_total*sr[i].bmb06
            IF cl_null(t_total)  THEN LET t_total =0 END IF
            CALL cl_numfor3(sr[i].bmb06) RETURNING l_bmb06
            CALL cl_numfor3(t_total)  RETURNING l_total
            #---->列印出資料
            LET l_str9=''
            IF p_level >1 THEN
              FOR k = 2 TO p_level
                  LET l_str9=l_str9,'*'
              END FOR
            END IF
            EXECUTE insert_prep USING g_bma01_a,g_bma06_a,p_level,i,
                    t_total,sr[i].*,
                    l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima37,l_ima63,
                    l_ima55,l_bma02,l_bma03,l_bma04,l_imz02,l_ver,
                    l_bmb06,l_total,l_str2,l_str9,g_no   #No.FUN-7A0078
            LET g_no = g_no + 1   #No.FUN-7A0078
            #子報表-插件
            FOR g_cnt=1 TO 200                                                  
                LET l_bmt06[g_cnt]=NULL                                         
            END FOR                                                             
            DECLARE r601_bmt CURSOR FOR
             SELECT bmt05,bmt06 FROM bmt_file
              WHERE bmt01=sr[i].bmb01 AND bmt02=sr[i].bmb02
                AND bmt03=sr[i].bmb03 
                AND (bmt04 IS NULL OR bmt04 >=sr[i].bmb04)
                AND bmt08 = sr[i].bmb29
              ORDER BY bmt05 
            LET l_now2=1                                                        
            LET l_len =20                                                       
            LET l_bmtstr = ''                                                   
            FOREACH r601_bmt INTO l_bmt05,l_bmt06_s
               IF SQLCA.sqlcode THEN
                  CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
               END IF
               IF l_now2 > 200 THEN                                             
                  CALL cl_err('','9036',1)                                      
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time                
                  EXIT PROGRAM                                                  
               END IF                                                           
               LET l_byte = length(l_bmt06_s) + 1                               
               IF l_len >= l_byte THEN                                          
                  LET l_bmtstr = l_bmtstr CLIPPED,l_bmt06_s CLIPPED,','         
                  LET l_len = l_len - l_byte                                    
               ELSE                                                             
                  LET l_bmt06[l_now2] = l_bmtstr                                
                  LET l_now2 = l_now2 + 1                                       
                  LET l_len = 20                                                
                  LET l_len = l_len - l_byte                                    
                  LET l_bmtstr = ''                                             
                  LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','         
               END IF                                                           
            END FOREACH
            LET l_bmt06[l_now2] = l_bmtstr                                      
            FOR g_cnt = 1 TO l_now2                                             
                IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '               
                   THEN                                                         
                       EXIT FOR                                                 
                END IF                                                          
                EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                                           sr[i].bmb29,l_bmt05,l_bmt06[g_cnt]   
            END FOR                                                             
            #子報表-說明
            FOR g_cnt=1 TO 100                                                  
                LET l_bmc05[g_cnt]=NULL                                         
            END FOR                                                             
            LET l_now=1                                                         
            DECLARE r601_bmc CURSOR FOR
             SELECT bmc04,bmc05 FROM bmc_file
              WHERE bmc01=sr[i].bmb01 AND bmc02=sr[i].bmb02
                AND bmc021=sr[i].bmb03
                AND (bmc03 IS NULL OR bmc03 >=sr[i].bmb04)
                AND bmc06 = sr[i].bmb29
              ORDER BY bmc04
            FOREACH r601_bmc INTO l_bmc04,l_bmc05[l_now]    #No.CHI-810006 
              IF SQLCA.sqlcode THEN
                 CALL cl_err('Foreach:',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
              IF l_now > 100 THEN                                               
                 CALL cl_err('','9036',1)                                       
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                 EXIT PROGRAM                                                   
              END IF                                                            
              LET l_now=l_now+1                                                 
            END FOREACH
            LET l_now=l_now-1                                                   
            IF l_now >= 1 THEN                                                  
               FOR g_cnt = 1 TO l_now STEP 2                                    
                   LET l_bmc051[g_cnt] = l_bmc05[g_cnt],' ',l_bmc05[g_cnt+1]    
                   EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04, 
                                               sr[i].bmb29,l_bmc04,l_bmc051[g_cnt]
               END FOR                                                          
            END IF                                                              
            #子報表-供應商
	    #供應廠商資料 (採購料件時才有)------------------------------------
            IF sr[i].ima08 MATCHES '[PVZ]' AND tm.vender MATCHES '[Yy]' THEN
               FOREACH r601_c2 USING sr[i].bmb03
                               INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,
                                    l_pmh05,l_pmh12,l_pmh13,l_pmc03
                 IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                 EXECUTE insert_prep3 USING l_pmh01,l_pmh02,l_pmh03,l_pmh04,
                         l_pmh05,l_pmh12,l_pmh13,l_pmc03
               END FOREACH
            END IF
            IF sr[i].bma01 IS NOT NULL THEN
                LET g_bma01=sr[i].bma01
                CALL r601_bom(p_level,sr[i].bmb03,l_ima910[i],p_total*sr[i].bmb06*l_fac) #FUN-550095 add ' ' #TQC-8C0063
            END IF
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_tot].bmb02
		LET l_times=l_times+1
        END IF
    END WHILE
END FUNCTION
 
#No.FUN-9C0077 程式精簡
