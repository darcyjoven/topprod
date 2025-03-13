# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr602.4gl
# Descriptions...: 尾階材料用量明細表
# Date & Author..: 91/08/05 By Lee
#------------------------------MODIFICATIONS-------------------------------
# 92/03/27(Nora): Add 主件料號數量
# 92/04/01(Lin): REPORT 格式修改, 並增加料件供應商的列印
# 92/05/27(David):
# 92/09/29(Lee): 大幅修正, 將報表的output改成三份, 以處理三個不同的排列順序.
#     將資料的讀取, order by項次, 以避開不正確的restart
# 92/10/28(Appple):為了維護麻煩
# 94/08/22(Danny):改由bmt_file取插件位置
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE rowi_NO INTEGER  應該轉為char(18)
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.FUN-550095 05/05/25 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-580110 05/08/22 By vivien  憑証類報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0108 06/11/23 By Ray 抬頭與頁次寫法應與11相同，不能改為template表頭寫法
# Modify.........: No.TQC-740079 07/04/18 By Ray 報表增加總頁次
# Modify.........: No.TQC-750225 07/05/29 By arman 制表者位于公司名和表單名之間，格式不統一，多數表是制表者和頁次同行
# Modify.........: No.TQC-7A0013 07/10/14 By Carrier 報表轉Crystal Report格式
# Modify.........: No.CHI-810006 08/01/22 By zhoufeng 調整插件位置及說明的列印  
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowi定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.           09/10/19 By lilingyu r.c2編譯錯誤
# Modify.........: No.TQC-A40116 10/04/26 By liuxqa modify sql 
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代的內容
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-BA0010 11/10/05 By johung sql加上bmaacti='Y'
# Modify.........: No:TQC-BB0041 11/11/04 By destiny bmb16 取值方式有问题,为7时应单独处理
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:MOD-D10125 13/01/28 By bart "主件料件數量"同sfb08可入小數位數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				    # Print condition RECORD
        		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
           		revision  LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
           		effective LIKE type_file.dat,     #No.FUN-680096 DATE
	        	#a         LIKE type_file.num10,   #No.FUN-680096 INTEGER #MOD-D10125
                a         LIKE sfb_file.sfb08,    #MOD-D10125
           		engine    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	        	arrange   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        		vender    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	        	more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_tot           LIKE type_file.chr1000, #No.FUN-680096 INTEGER,
          g_bma01_a       LIKE bma_file.bma01,
          g_bma06_a       LIKE bma_file.bma06,    #FUN-550095 add
          g_azi02,g_azi02_2   LIKE azi_file.azi02,
          g_azi03_2   LIKE azi_file.azi03,
          g_azi04_2   LIKE azi_file.azi04,
          g_azi05_2   LIKE azi_file.azi05
 
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose     #No.FUN-680096 SMALLINT
DEFINE   g_flag       LIKE bma_file.bma01     #No.TQC-740079
DEFINE   totpageno    LIKE type_file.num5     #No.TQC-740079
DEFINE   l_table1     STRING     #No.TQC-7A0013
DEFINE   l_table2     STRING     #No.TQC-7A0013
DEFINE   l_table3     STRING     #No.TQC-7A0013
DEFINE   l_table4     STRING     #No.TQC-7A0013
DEFINE   g_str        STRING     #No.TQC-7A0013
DEFINE   g_sql        STRING     #No.TQC-7A0013
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	        			# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
   #No.TQC-7A0013  --Begin
   LET g_sql = " g_bma01_a.bma_file.bma01,",
               " g_bma06_a.bma_file.bma06,",
               " p_level.type_file.num5,",
               " p_i.type_file.num5,",
               " p_total.csa_file.csa0301,",
               " order1.bmb_file.bmb03,",
               " bmb15.bmb_file.bmb15,",
               " bmb16.bmb_file.bmb16,",
               " bmb03.bmb_file.bmb03,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima02,",
               " ima05.ima_file.ima05,",
               " ima06.ima_file.ima06,",
               " ima08.ima_file.ima08,",
               " ima15.ima_file.ima15,",
               " ima37.ima_file.ima37,",
               " ima55.ima_file.ima55,",
               " ima63.ima_file.ima63,",
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
               " bmb01.bmb_file.bmb01,",
               " bmb29.bmb_file.bmb29,",
               " no_rowi.type_file.chr18,",
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
               " l_ver.ima_file.ima05   " 
 
   LET l_table1 = cl_prt_temptable('abmr6021',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " bmt01.bmt_file.bmt01,",
               " bmt02.bmt_file.bmt02,",
               " bmt03.bmt_file.bmt03,",
               " bmt04.bmt_file.bmt04,",
               " bmt08.bmt_file.bmt08,",
               " bmt05.bmt_file.bmt05,",
#               " bmt06.bmt_file.bmt06 "            #No.CHI-810006
               " bmt06.type_file.chr1000 "          #No.CHI-810006 
 
   LET l_table2 = cl_prt_temptable('abmr6022',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " bmc01.bmc_file.bmc01,",
               " bmc02 .bmc_file.bmc02 ,",
               " bmc021.bmc_file.bmc021,",
               " bmc03.bmc_file.bmc03,",
               " bmc06.bmc_file.bmc06,",
               " bmc04.bmc_file.bmc04,",
#               " bmc05.bmc_file.bmc05 "            #No.CHI-810006
               " bmc05.type_file.chr1000 "          #No.CHI-810006 
 
   LET l_table3 = cl_prt_temptable('abmr6023',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " l_pmh01.pmh_file.pmh01,",
               " l_pmh02.pmh_file.pmh02,",
               " l_pmh03.pmh_file.pmh03,",
               " l_pmh04.pmh_file.pmh04,",
               " l_pmh05.pmh_file.pmh05,",
               " l_pmh12.pmh_file.pmh12,",
               " l_pmh13.pmh_file.pmh13,",
               " l_pmc03.pmc_file.pmc03 " 
 
   LET l_table4 = cl_prt_temptable('abmr6024',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
   #No.TQC-7A0013  --End
 
   #No.TQC-740079 --begin
   DROP TABLE r602_tmp
   CREATE TEMP TABLE r602_tmp(
     flag    LIKE bma_file.bma01,
     cnt     LIKE type_file.num20_6)
   #No.TQC-740079 --end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)	        	# Get arguments from command line
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r602_tm(0,0)			# Input print condition
      ELSE CALL abmr602()			    # Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r602_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,     #資料筆數 #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,     #工程變異之生效日期
          l_cmd		LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 6 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 6
   END IF
 
   OPEN WINDOW r602_w AT p_row,p_col
        WITH FORM "abm/42f/abmr602"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 1
   LET tm.engine ='N'   #不列印工程技術資料
   LET tm.arrange = g_sma.sma65
   LET tm.effective = g_today	#有效日期
   LET tm.vender = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,ima06,ima09,ima10,ima11,ima12 #FUN-550095 add bma06
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      #--No.FUN-4B0022-------
      ON ACTION CONTROLP
        CASE WHEN INFIELD(bma01)      #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ima3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bma01
                  NEXT FIELD bma01
        OTHERWISE EXIT CASE
        END CASE
      #--END---------------
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01",
                 " FROM bma_file,ima_file",
                 " WHERE bma01=ima01 AND ima08 != 'A' ",
                 " AND ",tm.wc CLIPPED,
                 " GROUP BY bma01"
       PREPARE r602_cnt_p FROM l_cmd
       DECLARE r602_cnt CURSOR FOR r602_cnt_p
       IF SQLCA.sqlcode THEN
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       OPEN r602_cnt
       FETCH r602_cnt INTO g_cnt,l_bma01
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
       ELSE
           IF g_cnt=1 THEN
               LET l_one='Y'
           END IF
       END IF
   END IF
 
#UI
   INPUT BY NAME tm.revision,tm.effective,tm.a,
      tm.arrange,tm.engine,tm.vender,tm.more
      WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      BEFORE FIELD revision
         IF l_one='N' THEN
             NEXT FIELD effective
         END IF
      AFTER FIELD revision
         IF tm.revision IS NOT NULL THEN
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr602'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr602','9031',1)
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
                         " '",tm.revision CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'",
                         " '",tm.engine CLIPPED,"'",
                         " '",tm.arrange CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.vender CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr602',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r602_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr602()
   ERROR ""
END WHILE
   CLOSE WINDOW r602_w
END FUNCTION
 
FUNCTION abmr602()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
        # l_ute_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)  #FUN-A40058 MARK
          l_ute_flag    LIKE type_file.chr3,    #FUN-A40058                       
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          l_str,l_cmd   STRING,     #No.TQC-740079
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima02,    #品名規格
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima37 LIKE ima_file.ima37,    #補貨
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_bma02 LIKE bma_file.bma02,    #品名規格
          l_bma03 LIKE bma_file.bma03,    #品名規格
          l_bma04 LIKE bma_file.bma04,    #品名規格
          l_imz02 LIKE imz_file.imz02,    #說明內容
          l_bmt05 LIKE bmt_file.bmt05,
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06, #No.FUN-680096 VARCHAR(20)
          l_bmc05 ARRAY[100] OF LIKE bmc_file.bmc05, #No.FUN-680096 VARCHAR(10)
          l_bmc04 LIKE bmc_file.bmc04,
		  l_cnt,l_cnt2 LIKE type_file.num5,  #No.FUN-680096 SMALLINT
		  l_sql1   LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
		  l_sql2   LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
		  l_pmh01  LIKE pmh_file.pmh01,
		  l_pmh02  LIKE pmh_file.pmh02,
		  l_pmh03  LIKE pmh_file.pmh03,
		  l_pmh04  LIKE pmh_file.pmh04,
		  l_pmh05  LIKE pmh_file.pmh05,
		  l_pmh12  LIKE pmh_file.pmh12,
		  l_pmh13  LIKE pmh_file.pmh13,
		  l_pmc03  LIKE pmc_file.pmc03,
          sr  RECORD
              order1  LIKE bmb_file.bmb03,  #No.FUN-680096 VARCHAR(20)
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
           END RECORD,
          l_za05  LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(40)
          l_bma01 LIKE bma_file.bma01,   #主件料件
          l_bma06 LIKE bma_file.bma06    #FUN-550095 add bma06
 
     #No.TQC-7A0013  --Begin
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
 
     #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-A40116 mod
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?      ) "
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-A40116 mod
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
     #No.TQC-7A0013  --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
      #---->讀取本幣資料
#No.CHI-6A0004-----Begin----
#      SELECT azi02,azi03,azi04,azi05
#        INTO g_azi02,g_azi03,g_azi04,g_azi05
#        FROM azi_file
#       WHERE azi01 = g_aza.aza17
#No.CHI-6A0004------End------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT UNIQUE bma01,bma06 ", #FUN-550095 add bma06
                 " FROM bma_file, ima_file",
                 " WHERE ima01 = bma01",
                 " AND bmaacti = 'Y' AND bmadate>=to_date('161101','yymmdd') ",               #MOD-BA0010 add
                 " AND ima08 != 'A' AND ",tm.wc,
                 " ORDER BY 1,2 " #FUN-550095 add 2
     PREPARE r602_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r602_cs1 CURSOR FOR r602_prepare1
 
     #No.TQC-7A0013  --Begin
     #CALL cl_outnam('abmr602') RETURNING l_name
     #No.FUN-580110 --start
     #SELECT ima02,ima021,ima05,ima06,ima08,
     #       ima37,ima55,ima63,imz02
     #  INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
     #       l_ima37,l_ima55,l_ima63,l_imz02
     #  FROM ima_file, OUTER imz_file
     # WHERE ima01=p_bma01_a AND ima06 = imz_file.imz01
     # IF l_ima08 MATCHES '[CDA]' THEN
     #    LET g_zaa[60].zaa06 = "N"
     #    LET g_zaa[76].zaa06 = "N"
     # ELSE
     #    LET g_zaa[60].zaa06 = "Y"
     #    LET g_zaa[76].zaa06 = "Y"
     # END IF
 
     #IF g_sma.sma888[1,1] = 'Y' THEN
     #   LET g_zaa[62].zaa06 = "N"
     #   LET g_zaa[78].zaa06 = "N"
     #ELSE
     #   LET g_zaa[62].zaa06 = "Y"
     #   LET g_zaa[78].zaa06 = "Y"
     #END IF
 
     # LET l_cnt = 0
     #   LET l_cnt2 = 0
     #     #供應廠商資料 (採購料件時才有)------------------------------------
     #   IF sr.ima08 MATCHES '[PVZ]' AND tm.vender MATCHES '[Yy]' THEN
     #  	   LET l_cnt = l_cnt + 1
     #       IF l_cnt = 1 THEN
     #          SKIP 1 LINE
     #          NEED 3 LINES
     #          LET g_zaa[65].zaa06 = "N"
     #          LET g_zaa[66].zaa06 = "N"
     #          LET g_zaa[67].zaa06 = "N"
     #          LET g_zaa[68].zaa06 = "N"
     #          LET g_zaa[69].zaa06 = "N"
     #          LET g_zaa[70].zaa06 = "N"
     #       ELSE
     #          LET g_zaa[65].zaa06 = "Y"
     #          LET g_zaa[66].zaa06 = "Y"
     #          LET g_zaa[67].zaa06 = "Y"
     #          LET g_zaa[68].zaa06 = "Y"
     #          LET g_zaa[69].zaa06 = "Y"
     #          LET g_zaa[70].zaa06 = "Y"
     #       END IF
     #    ELSE
     #       LET g_zaa[65].zaa06 = "Y"
     #       LET g_zaa[66].zaa06 = "Y"
     #       LET g_zaa[67].zaa06 = "Y"
     #       LET g_zaa[68].zaa06 = "Y"
     #       LET g_zaa[69].zaa06 = "Y"
     #       LET g_zaa[70].zaa06 = "Y"
     #    END IF
     # CALL cl_prt_pos_len()
     ##No.FUN-580110 --end
     #START REPORT r602_rep TO l_name
     #No.TQC-7A0013  --Begin
     CALL r602_cur()
#---->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  "   AND bmt08 = ? ", #FUN-550095 add
                  " ORDER BY 1"
     PREPARE r602_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
     END IF
     DECLARE r602_bmt  CURSOR FOR r602_prebmt
     #產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  "   AND bmc06 = ? ", #FUN-550095 add
                  " ORDER BY 1"
     PREPARE r602_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
     END IF
     DECLARE r602_bmc CURSOR FOR r602_prebmc
 
     LET g_tot=0
     LET g_pageno = 0
     FOREACH r602_cs1 INTO l_bma01,l_bma06  #FUN-550095 add bma06
       IF SQLCA.sqlcode THEN
			CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
		END IF
       LET g_bma01_a=l_bma01
       LET g_bma06_a=l_bma06
       CALL r602_bom(0,l_bma01,l_bma06,tm.a) #FUN-550095 add bma06
     END FOREACH
 
     #DISPLAY "" AT 2,1
     #No.TQC-7A0013  --Begin
     #FINISH REPORT r602_rep
     ##No.TQC-740079 --begin
     #DECLARE abmr602_curs3 CURSOR FOR SELECT flag FROM r602_tmp
     #FOREACH abmr602_curs3 INTO g_flag
     #   SELECT cnt INTO totpageno FROM r602_tmp WHERE flag = g_flag
     #   LET l_str = l_name CLIPPED,".xml.bak"
     #   LET l_cmd = "awk ' { sub(/<Skip\\\/>/, \"<Print/>\"); sub(/",g_flag,"totpageno/, \"",totpageno USING '<<<<<',"\") ; print $0  } ' $TEMPDIR/",
     #                l_name CLIPPED,".xml"," > ",l_str CLIPPED
     #   RUN l_cmd
     #   LET l_cmd = "cp $TEMPDIR/",l_str CLIPPED," $TEMPDIR/",l_name CLIPPED,".xml"
     #   RUN l_cmd
     #   LET l_cmd = "chmod 777 ",l_name CLIPPED,".xml"," 2>/dev/null" 
     #   RUN l_cmd
     #   LET l_cmd = 'rm -f ',l_str CLIPPED
     #   RUN l_cmd
     #END FOREACH
     ##No.TQC-740079 --end
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
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
                 "",";",tm.vender,";",tm.engine
     CALL cl_prt_cs3('abmr602','abmr602',g_sql,g_str)
     #No.TQC-7A0013  --End  
END FUNCTION
 
#No.TQC-7A0013  --Begin
FUNCTION r602_cur()
  DEFINE l_sql1,l_sql2   LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
         LET l_sql1= "SELECT ",
                     " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13,pmc03 ",
#                    " FROM pmh_file,OUTER pmc_file ",      #091020
                     " FROM pmh_file LEFT OUTER JOIN pmc_file",  #091020
                     " ON pmh02 = pmc01",  #091020  
#                    " WHERE pmh_file.pmh02=pmc_file.pmc01 AND pmh01 = ? ",  #091020
                     " WHERE pmh01 = ?",                     #091020
                     "   AND pmh21 = ' ' ",                                            #CHI-860042                                  
                     "   AND pmh22 = '1' ",                                            #CHI-860042
                     "   AND pmh23 = ' ' ",                                            #CHI-960033
                     "   AND pmhacti = 'Y'"                                            #CHI-910021
         PREPARE r602_p2  FROM l_sql1
          IF SQLCA.sqlcode THEN
             CALL cl_err('P2:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
             EXIT PROGRAM
                
          END IF
         DECLARE r602_c2 CURSOR FOR r602_p2
END FUNCTION
#No.TQC-7A0013  --End  
 
FUNCTION r602_bom(p_level,p_key,p_key2,p_total) #FUN-550095 add p_key2
   DEFINE p_level	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          p_total       LIKE csa_file.csa0301, #No.FUN-680096 DEC(13,5)
          l_total       LIKE csa_file.csa0301, #No.FUN-680096 DEC(13,5)
          p_key		LIKE bma_file.bma01,   #主件料件編號
          p_key2	LIKE bma_file.bma06,   #FUN-550095 add p_key2
          l_ac,i	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,   #No.FUN-680096 SMALLINT
           b_seq          LIKE type_file.chr18,  #No.FUN-680096 INTEGER  #No.TQC-950134
          l_chr,l_cnt   LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301, #No.FUN-680096 DEC(13,5)
          sr,sr1 DYNAMIC ARRAY OF RECORD           #每階存放資料  #No.TQC-7A0013
              order1  LIKE bmb_file.bmb03,  #No.FUN-680096 VARCHAR(20)
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #版本
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
              bmb01 LIKE bmb_file.bmb01,    #FUN-550095 add bmb01
              bmb29 LIKE bmb_file.bmb29,    #FUN-550095 add bmb29
           no_rowi LIKE type_file.num10    #091019  add
          END RECORD,
          l_tot,l_times LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(1000)
#No.TQC-7A0013  --Begin
  DEFINE  l_ima02     LIKE ima_file.ima02,    #品名規格
          l_ima021    LIKE ima_file.ima02,    #品名規格
          l_ima05     LIKE ima_file.ima05,    #版本
          l_ima06     LIKE ima_file.ima06,    #版本
          l_ima08     LIKE ima_file.ima08,    #來源
          l_ima37     LIKE ima_file.ima37,    #補貨
          l_ima63     LIKE ima_file.ima63,    #發料單位
          l_ima55     LIKE ima_file.ima55,    #生產單位
          l_bma02     LIKE bma_file.bma02,    #品名規格
          l_bma03     LIKE bma_file.bma03,    #品名規格
          l_bma04     LIKE bma_file.bma04,    #品名規格
          l_imz02     LIKE imz_file.imz02,    #說明內容
        # l_ute_flag  LIKE type_file.chr2,         #No.FUN-680096 VARCHAR(2)      #FUN-A40058 MARK
          l_ute_flag  LIKE type_file.chr3,                                        #FUN-A40058  
          l_bmt06_s   LIKE bmt_file.bmt06,     #No.FUN-680096 VARCHAR(20)
          l_bmt05     LIKE bmt_file.bmt05,
#          l_bmc05     LIKE bmc_file.bmc05, #No.FUN-680096 VARCHAR(10) #No.CHI-810006
          l_bmc04     LIKE bmc_file.bmc04,
          l_pmh01     LIKE pmh_file.pmh01,
          l_pmh02     LIKE pmh_file.pmh02,
          l_pmh03     LIKE pmh_file.pmh03,
          l_pmh04     LIKE pmh_file.pmh04,
          l_pmh05     LIKE pmh_file.pmh05,
          l_pmh12     LIKE pmh_file.pmh12,
          l_pmh13     LIKE pmh_file.pmh13,
          l_pmc03     LIKE pmc_file.pmc03,
          l_ver       LIKE ima_file.ima05
#No.TQC-7A0013  --End  
          #No.CHI-810006 --start--                                              
          DEFINE                                                                
          l_now,l_now2  SMALLINT,                                               
          l_bmt06 ARRAY[200] OF VARCHAR(20),                                       
          l_byte,l_len   SMALLINT,                                              
          l_bmtstr      LIKE bmc_file.bmc06,                                    
          l_bmc05 ARRAY[200] OF VARCHAR(10),                                       
          l_bmc051 ARRAY[200] OF VARCHAR(30)                                       
          #No.CHI-810006 --end-- 
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET g_pageno = 0
        LET sr[1].bmb03 = p_key
    END IF
 
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
         "SELECT ' ',bmb15,bmb16,bmb03,ima02,ima021,ima05,ima06,ima08,ima15,",
            " ima37,ima55,ima63,bmb23,bmb02,(bmb06/bmb07),bmb08,bmb10,",
            " bmb18,bmb09,bmb04,bmb05,bmb14,",
            " bmb17,bmb11,bmb13,bma01,bmb01,bmb29", #FUN-550095 add bmb01,bmb29
#           " FROM bmb_file, OUTER ima_file, OUTER bma_file",    #091020
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01",    #091020
           #" LEFT OUTER JOIN bma_file ON bmb03 = bma01",  #091020            #MOD-BA0010 mark
            " LEFT OUTER JOIN bma_file ON bmb03 = bma01 AND bmaacti = 'Y'",   #MOD-BA0010
            " WHERE bmb01='", p_key,"'",     
#           " AND bmb_file.bmb03 = ima_file.ima01",   #091020
#           " AND bmb_file.bmb03 = bma_file.bma01",   #091020
            " AND bmb29='", p_key2,"'", #FUN-550095 add
	          " AND ima_file.ima08 != 'A' "
 
        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
        END IF
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY bmb02"
 
        PREPARE r602_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
           EXIT PROGRAM
        END IF
        DECLARE r602_cur CURSOR FOR r602_ppp
 
        LET l_ac = 1
        FOREACH r602_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
           #FUN-8B0015--BEGIN--                                                                                                     
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #FUN-8B0015--END-- 
            message sr[l_ac].bmb02,' ',sr[l_ac].bmb03
            CALL ui.Interface.refresh()
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
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
           #與多階展開不同之處理在此:
           #尾階在展開時, 其展開之
            IF sr[i].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
               #CALL r602_bom(p_level,sr[i].bmb03,' ',p_total*sr[i].bmb06*l_fac) #FUN-550095 add ' '#FUN-8B0015
                CALL r602_bom(p_level,sr[i].bmb03,l_ima910[i],p_total*sr[i].bmb06*l_fac) #FUN-8B0015
            ELSE
                LET l_total=p_total*sr[i].bmb06
                CASE tm.arrange
                  WHEN '1'  LET sr[i].order1 = sr[i].bmb02  using'#####'
                  WHEN '2'  LET sr[i].order1 = sr[i].bmb03
                  WHEN '3'  LET sr[i].order1 = sr[i].bmb13
                  OTHERWISE  LET sr[i].order1 = sr[i].bmb03
                END CASE
                #No.TQC-7A0013  --Begin
                #OUTPUT TO REPORT r602_rep(l_total,sr[i].*,g_bma01_a,g_bma06_a) #FUN-550095 add bma06
                CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver                                                                         
                SELECT ima02,ima021,ima05,ima06,ima08,
                       ima37,ima55,ima63,imz02
                  INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
                       l_ima37,l_ima55,l_ima63,l_imz02
#                 FROM ima_file, OUTER imz_file   #091020
                 FROM ima_file LEFT OUTER JOIN imz_file ON ima06 = imz01  #091020
#                WHERE ima01=g_bma01_a AND ima_file.ima06 = imz_file.imz01  #091020
                 WHERE ima01 = g_bma01_a        #091020
                IF SQLCA.sqlcode THEN
                   LET l_ima02='' LET l_ima05=''
                   LET l_ima06='' LET l_ima08=''
                   LET l_ima37='' LET l_ima55=''
                   LET l_ima63='' LET l_ima021=''
                   LET l_imz02=''
                END IF
                SELECT bma02,bma03,bma04
                  INTO l_bma02,l_bma03,l_bma04
                  FROM bma_file
                 WHERE bma01=g_bma01_a
                   AND bma06=g_bma06_a #FUN-550095 add
                IF SQLCA.sqlcode THEN
                   LET l_bma02=''
                   LET l_bma03=''
                   LET l_bma04=''
                END IF
                LET l_ute_flag='USZ'        #FUN-A40058 add 'Z'
                #---->改變使用特性的表示方式
                IF sr[i].bmb15 = 'Y' THEN
                   LET sr[i].bmb15 = '*'
                ELSE
                   LET sr[i].bmb15=' '
                END IF
                #---->改變替代特性的表示方式
               #IF sr[i].bmb16 MATCHES '[127]' THEN          #FUN-A40058 add '7' #TQC-BB0041
                IF sr[i].bmb16 MATCHES '[12]' THEN          #FUN-A40058 add '7' #TQC-BB0041
                   LET g_cnt=sr[i].bmb16 USING '&'
                   LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]
                ELSE
                   LET sr[i].bmb16=' '
                END IF
                #TQC-BB0041--begin
                IF sr[i].bmb16='7' THEN
                   LET sr[i].bmb16='Z'
                END IF
                #TQC-BB0041--end
                IF sr[i].bmb14 ='1'
                THEN LET sr[i].bmb14 ='O'
                ELSE LET sr[i].bmb14 =' '
                END IF
                IF sr[i].bmb17='Y' THEN
                   LET sr[i].bmb17='F'
                ELSE
                   LET sr[i].bmb17=' '
                END IF
                #OUTPUT TO REPORT r602_rep(l_total,sr[i].*,g_bma01_a,g_bma06_a) #FUN-550095 add bma06
                LET sr1[i].*=sr[i].*
                LET sr1[i].no_rowi=0
                EXECUTE insert_prep USING g_bma01_a,g_bma06_a,p_level,i,
                        l_total,sr1[i].*,l_ima02,l_ima021,l_ima05,
                        l_ima06,l_ima08,l_ima37,l_ima63,l_ima55,
                        l_bma02,l_bma03,l_bma04,l_imz02,l_ver
                #子報表-插件
                #No.CHI-810006 --addd--                                         
                FOR g_cnt=1 TO 200                                              
                    LET l_bmt06[g_cnt]=NULL                                     
                END FOR                                                         
                LET l_now2=1                                                    
                LET l_len =20                                                   
                LET l_bmtstr = ''                                               
               #No.CHI-810006 --end-- 
                FOREACH r602_bmt
                USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,
                      sr[i].bmb04,sr[i].bmb29
                INTO l_bmt05,l_bmt06_s
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
                   END IF
                   #No.CHI-810006  --add--                                      
                   IF l_now2 > 200 THEN                                         
                      CALL cl_err('','9036',1)                                  
                      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                      EXIT PROGRAM                                              
                   END IF                                                       
                   LET l_byte = length(l_bmt06_s) + 1                           
                   IF l_len >= l_byte THEN                                      
                      LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','     
                      LET l_len = l_len - l_byte                                
                   ELSE                                                         
                      LET l_bmt06[l_now2] = l_bmtstr                            
                      LET l_now2 = l_now2 + 1                                   
                      LET l_len = 20                                            
                      LET l_len = l_len - l_byte                                
                      LET l_bmtstr = ''                                         
                      LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','     
                   END IF                                                       
                   #No.CHI-810006 --end-- 
#                   EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,   #No.CHI-810006
#                           sr[i].bmb03,sr[i].bmb04,sr[i].bmb29,          #No.CHI-810006
#                           l_bmt05,l_bmt06_s                             #No.CHI-810006
                END FOREACH
                #No.CHI-810006 --start--                                        
                LET l_bmt06[l_now2] = l_bmtstr                                  
                FOR g_cnt = 1 TO l_now2                                         
                    IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '           
                     THEN                                                       
                         EXIT FOR                                               
                    END IF                                                      
                    EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,         
                            sr[i].bmb03,sr[i].bmb04,sr[i].bmb29,                
                            l_bmt05,l_bmt06[g_cnt]                              
                END FOR                                                         
                #No.CHI-810006 --end-- 
                #子報表-說明
                #No.CHI-810006 --add--                                          
                FOR g_cnt=1 TO 100                                              
                    LET l_bmc05[g_cnt]=NULL                                     
                END FOR                                                         
                LET l_now = 1                                                   
                #No.CHI-810006 --end-- 
                FOREACH r602_bmc
                USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,
                      sr[i].bmb04,sr[i].bmb29
#                INTO l_bmc04,l_bmc05                          #No.CHI-810006
                INTO l_bmc04,l_bmc05[l_now]                    #No.CHI-810006
                    IF SQLCA.sqlcode THEN
                       CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
                    END IF
                    #No.CHI-810006 --add--                                      
                    IF l_now > 100 THEN                                         
                       CALL cl_err('','9036',1)                                 
                       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                       EXIT PROGRAM                                             
                    END IF                                                      
                    LET l_now=l_now+1 
#                    EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,
#                            sr[i].bmb03,sr[i].bmb04,sr[i].bmb29,
#                            l_bmc04,l_bmc05
                    #No.CHI-810006 --end--
                END FOREACH
                #No.CHI-810006 --add--                                          
                LET l_now=l_now-1                                               
                IF l_now >= 1 THEN                                              
                   FOR g_cnt = 1 TO l_now STEP 2                                
                       LET l_bmc051[g_cnt] = l_bmc05[g_cnt],' ',l_bmc05[g_cnt+1]
                       EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                                                  sr[i].bmb29,l_bmc04,l_bmc051[g_cnt]
                   END FOR                                                      
                END IF                                                          
                #No.CHI-810006 --end-- 
                #子報表-供應商
                #供應廠商資料 (採購料件時才有)------------------------------------
                IF sr[i].ima08 MATCHES '[PVZ]' AND tm.vender MATCHES '[Yy]' THEN
                   FOREACH r602_c2 USING sr[i].bmb03
                                   INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,
                                        l_pmh05,l_pmh12,l_pmh13,l_pmc03
                     IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                     EXECUTE insert_prep3 USING l_pmh01,l_pmh02,l_pmh03,
                             l_pmh04,l_pmh05,l_pmh12,l_pmh13,l_pmc03
                   END FOREACH
                END IF
                #No.TQC-7A0013  --End  
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno-1].no_rowi
        END IF
    END WHILE
END FUNCTION
 
