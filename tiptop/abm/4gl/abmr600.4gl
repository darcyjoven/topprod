# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr600.4gl
# Descriptions...: 單階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/02 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
#                  92/04/01 By Lin REPORT 格式修改, 並增加料件供應商的列印
# Modify.........: 92/05/27 By David
# Modify.........: 92/10/26 By Apple
#                  目的:測試修改
# Modify.........: 93/04/22 虛擬料件是否Blow Through
# Modify.........: 94/08/23 By Danny (改由bmt_file取插件位置)
# Modify.........: No.FUN-4A0004 04/10/02 By Yuna 增加主件料件開窗
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.FUN-550095 05/05/25 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-590110 05/08/22 By vivien  憑証類報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-5B0122 05/11/14 By Echo 格式未對齊,資料內容奇怪
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-620072 06/02/23 By Claire 列印工程資料時,漏印插件位置
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-760170 07/06/26 By claire 調整列印的語法
# Modify.........: No.MOD-790097 07/09/20 By Pengu 程式606行中ima01 = bmb03應修改為ima01 = bma01
# Modify.........: No.FUN-7C0066 07/12/26 By hongmei  報表輸出至Crystal Reports功能
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:MOD-A40152 10/04/26 By Sarah 將l_table與l_table2裡的bmt06欄位放大成chr20
# Modify.........: No:FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代的內容
# Modify.........: No:MOD-B50213 11/07/17 By Summer 主件失效的料不印
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C30308 12/04/13 By SunLM 當sub_flag='Y'時變量定義,l_table與l_table3的l_ima02重複
# Modify.........: No.MOD-C40100 12/04/16 By Elise 勾選列印取替代料資料(sub_flag)與否,CR報表所列印的主件料件編號的品名(ima02)會不一樣
# Modify.........: No.TQC-CC0070 12/12/11 By qirl 增加開窗
# Modify.........: No.TQC-CC0071 12/12/12 By qirl 修改顯示
# Modify.........: No:MOD-D10126 13/01/28 By bart "主件料件數量"同sfb08可入小數位數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
        		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
           		revision  LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
           		effective LIKE type_file.dat,     #No.FUN-680096 DATE
	        	#a         LIKE type_file.num10,   #No.FUN-680096 INTEGER #MOD-D10126
                a         LIKE sfb_file.sfb08,    #MOD-D10126
           		engine    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           		arrange   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        blow      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        		vender    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        		sub_flag  LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           		more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          sr  RECORD
              order1  LIKE type_file.chr20, #No.FUN-680096 VARCHAR(1)
              feature LIKE cre_file.cre08,  #No.FUN-680096 VARCHAR(10)
              ima06 LIKE ima_file.ima06,    #分群碼
              bma01 LIKE bma_file.bma01,    #主件料件
              bma06 LIKE bma_file.bma06,    #FUN-550095 add bma06
              bma02 LIKE bma_file.bma02,    #工程變異單號
              bma03 LIKE bma_file.bma03,    #工程變異日期
              bma04 LIKE bma_file.bma04,    #組合模組參考
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
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
              phatom LIKE ima_file.ima01
          END RECORD,
          g_azi02,g_azi02_2   LIKE azi_file.azi02,
          g_azi03_2   LIKE azi_file.azi03,
          g_azi04_2   LIKE azi_file.azi04,
          g_azi05_2   LIKE azi_file.azi05,
          g_bma01   LIKE bma_file.bma01,
          g_bma06   LIKE bma_file.bma06  #FUN-550095 add
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
#No.FUN-7C0066---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       l_table2       STRING,
       l_table3       STRING,
       l_table4       STRING,
       g_str          STRING,                                                   
       g_sql          STRING,                                                   
       l_sql          STRING                                                    
#No.FUN-7C0066---End 
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
 
#No.FUN-7C0066---Begin                                                          
   LET g_sql = "l_ima02.ima_file.ima02,l_ima021.ima_file.ima021,",
               "l_ima05.ima_file.ima05,l_ima06.ima_file.ima06,",
               "l_ima08.ima_file.ima08,l_ima15.ima_file.ima15,",
               "l_ima37.ima_file.ima37,l_ima55.ima_file.ima55,",
               "l_ima63.ima_file.ima63,l_imz02.imz_file.imz02,",
               "l_ver.ima_file.ima05,l_qpaqty.bmb_file.bmb06,",
               "bma01.bma_file.bma01,bma02.bma_file.bma02,",
               "bma03.bma_file.bma03,bma04.bma_file.bma04,",
               "bma06.bma_file.bma06,phatom.ima_file.ima01,",
               "bmb02.bmb_file.bmb02,bmb03.bmb_file.bmb03,",
               "bmb04.bmb_file.bmb04,bmb05.bmb_file.bmb05,",
               "bmb08.bmb_file.bmb08,bmb09.bmb_file.bmb09,",
               "bmb10.bmb_file.bmb10,bmb11.bmb_file.bmb11,",
               "bmb14.bmb_file.bmb14,bmb15.bmb_file.bmb15,",
               "bmb16.bmb_file.bmb16,bmb17.bmb_file.bmb17,",
               "bmb18.bmb_file.bmb18,bmb23.bmb_file.bmb23,",
               "ima02.ima_file.ima02,ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,ima15.ima_file.ima15,",
               "ima37.ima_file.ima37,l_bmt061.type_file.chr20,",      #MOD-A40152 mod bmt_file.bmt06->type_file.chr20
               "l_bmt062.type_file.chr20,l_bmt063.type_file.chr20,",  #MOD-A40152 mod bmt_file.bmt06->type_file.chr20
               "order1.bmb_file.bmb03"    
   LET l_table = cl_prt_temptable('abmr600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   
   LET g_sql = "l_pmh01.pmh_file.pmh01,l_pmh02.pmh_file.pmh02,",
               "l_pmh03.pmh_file.pmh03,l_pmh04.pmh_file.pmh04,",
               "l_pmh05.pmh_file.pmh05,l_pmh12.pmh_file.pmh12,",
               "l_pmh13.pmh_file.pmh13,"
   LET l_table1 = cl_prt_temptable('abmr6001',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
     
   LET g_sql = "bmt01.bmt_file.bmt01,bmt02.bmt_file.bmt02,",
               "bmt03.bmt_file.bmt03,bmt04.bmt_file.bmt04,",
               "bmt05.bmt_file.bmt05,bmt06.type_file.chr20"  #MOD-A40152 mod bmt_file.bmt06->type_file.chr20
   LET l_table2 = cl_prt_temptable('abmr6002',g_sql) CLIPPED                      
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                                  

   LET g_sql = "bma01.bma_file.bma01,bma06.bma_file.bma06,",
               "l_ima02.ima_file.ima02,bmd01.bmd_file.bmd01,",
               "l_ima021.ima_file.ima02,l_bmd04.bmd_file.bmd04,",
               "l_bmd05.bmd_file.bmd05,l_bmd06.bmd_file.bmd06,",
               "l_bmd07.bmd_file.bmd07"
   LET l_table3 = cl_prt_temptable('abmr6003',g_sql) CLIPPED                      
   IF l_table3 = -1 THEN EXIT PROGRAM END IF 
   
   LET g_sql = "bmc01.bmc_file.bmc01,bmc02.bmc_file.bmc02,",
               "bmc021.bmc_file.bmc021,bmc03.bmc_file.bmc03,",
               "bmc04.bmc_file.bmc04,bmc05.bmc_file.bmc05"
   LET l_table4 = cl_prt_temptable('abmr6004',g_sql) CLIPPED                      
   IF l_table4 = -1 THEN EXIT PROGRAM END IF 
#No.FUN-7C0066---End
 
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
  #TQC-610068-begin
   LET tm.blow = ARG_VAL(14)
   LET tm.sub_flag = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(14)
   #LET g_rep_clas = ARG_VAL(15)
   #LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
  #TQC-610068-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r600_tm(0,0)			# Input print condition
      ELSE CALL abmr600()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r600_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,	
          l_ima06       LIKE ima_file.ima06,	
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 6 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 17
   ELSE
       LET p_row = 3 LET p_col = 8
   END IF
 
   OPEN WINDOW r600_w AT p_row,p_col
        WITH FORM "abm/42f/abmr600"
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
   LET tm.engine ='N'   #不列印工程技術資料
   LET tm.a = 1
   LET tm.arrange = g_sma.sma65
   LET tm.effective = g_today	#有效日期
  #---------No.FUN-670041 modify
  #LET tm.blow = g_sma.sma29
   LET tm.blow = 'Y'
  #---------No.FUN-670041 modify
   LET tm.vender = 'N'
   LET tm.sub_flag = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,ima06,ima09,ima10,ima11,ima12 #FUN-550095 add bma06
 
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
      #--No.FUN-4A0004--------
      ON ACTION CONTROLP
         CASE WHEN INFIELD(bma01) #主件料件
              CALL cl_init_qry_var()
 	      LET g_qryparam.state = "c"
 	      LET g_qryparam.form  = "q_bma2"
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
      #--END---------------
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
 
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(*) FROM bma_file,ima_file",
           " WHERE bma01=ima01 AND ",tm.wc CLIPPED
       PREPARE r600_cnt_p FROM l_cmd
       DECLARE r600_cnt CURSOR FOR r600_cnt_p
       IF SQLCA.sqlcode THEN
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       MESSAGE " SEARCHING ! "
       CALL ui.Interface.refresh()
       OPEN r600_cnt
       FETCH r600_cnt INTO g_cnt,l_bma01
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
       ELSE
           IF g_cnt=1 THEN
               LET l_one='Y'
           END IF
       END IF
       MESSAGE " "
       CALL ui.Interface.refresh()
   END IF
 
      #---->讀取本幣資料
#No.CHI-6A0004----Begin-----
#       SELECT azi02,azi03,azi04,azi05
#        INTO g_azi02,g_azi03,g_azi04,g_azi05
#        FROM azi_file
#       WHERE azi01 = g_aza.aza17
#No.CHI-6A0004----End----------
 
   DISPLAY BY NAME tm.revision,tm.effective,tm.a,
        tm.engine,tm.arrange,tm.sub_flag,tm.more
#UI
   INPUT BY NAME tm.revision,tm.effective,tm.a,tm.arrange,
      tm.engine,tm.blow,tm.vender,tm.sub_flag,tm.more
      WITHOUT DEFAULTS
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
		 IF tm.a IS NULL OR tm.a = ' '  OR tm.a < 0 THEN
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
      AFTER FIELD blow
         IF tm.blow NOT MATCHES '[YN]' OR tm.blow IS NULL THEN
             NEXT FIELD blow
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
 
      ON ACTION CONTROLP
         CALL r600_wc()   # Input detail Where Condition
         IF INT_FLAG THEN EXIT INPUT END IF
 
 
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr600','9031',1)
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
                         " '",tm.blow CLIPPED,"'",        #TQC-610068
                         " '",tm.sub_flag CLIPPED,"'",    #TQC-610068
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr600',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr600()
   ERROR ""
END WHILE
   CLOSE WINDOW r600_w
END FUNCTION
 
FUNCTION r600_wc()
   DEFINE l_wc LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(500)
 
   OPEN WINDOW r600_w2 AT 2,2 WITH FORM "abm/42f/abmi600"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')

   # 螢幕上取條件
   CONSTRUCT l_wc ON bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
                     bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
                FROM bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
                     s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
                     s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,s_bmb[1].bmb10
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
   END CONSTRUCT
 
   CLOSE WINDOW r600_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
FUNCTION r600_cur()
DEFINE l_sql       STRING      #NO.FUN-910082

   LET l_sql = "SELECT '','',",
               " ima06,bma01,bma06,bma02,bma03,bma04,", #FUN-550095 add bma06
               " bmb15,bmb16,bmb03,ima02,ima021,ima05,",
               " ima08,ima15,ima37,bmb23,bmb02,bmb06/bmb07,bmb08,",
               " bmb10,bmb18,bmb09,bmb04,bmb05,",
               " bmb14,bmb17,bmb11,bmb13,''",
               " FROM bma_file, bmb_file,ima_file",
               " WHERE bma01 = bmb01 AND bma01 = ? ",
               " AND ima01 = bmb03"
   #生效日及失效日的判斷
   IF tm.effective IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
                               "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
                               "' OR bmb05 IS NULL)"
   END IF
   PREPARE r600_prepare2 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   DECLARE r600_cs2 CURSOR WITH HOLD FOR r600_prepare2
END FUNCTION
 
FUNCTION abmr600()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#         l_time    LIKE type_file.chr8     #No.FUN-6A0060
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_cmd     LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_bma01   LIKE bma_file.bma01,    #主件料件
          l_bma06   LIKE bma_file.bma06,    #FUN-550095 add bma06
          l_ima02   LIKE ima_file.ima02,    #品名規格
          l_ima02a  LIKE ima_file.ima02,    #品名規格    #TQC-C30308 
          l_ima021  LIKE ima_file.ima02,    #品名規格
          l_ima021a LIKE ima_file.ima02,    #品名規格    #MOD-C40100
          l_ima05   LIKE ima_file.ima05,    #版本
          l_ima06   LIKE ima_file.ima06,    #版本
          l_ima08   LIKE ima_file.ima08,    #來源
          l_ima37   LIKE ima_file.ima37,    #補貨
          l_ima63   LIKE ima_file.ima63,    #發料單位
          l_ima55   LIKE ima_file.ima55,    #生產單位
          l_bma02   LIKE bma_file.bma02,    #品名規格
          l_bma03   LIKE bma_file.bma03,    #品名規格
          l_bma04   LIKE bma_file.bma04,    #品名規格
          l_imz02   LIKE imz_file.imz02,    #說明內容
          l_bmt01   LIKE bmt_file.bmt01,
          l_bmt05   LIKE bmt_file.bmt05,
          l_bmt06   ARRAY[200] OF LIKE type_file.chr20,  #MOD-A40152 mod bmt_file.bmt06->type_file.chr20
          l_bmc01   LIKE bmc_file.bmc01,               #No.FUN-7C0066
          l_bmc05   ARRAY[100] OF LIKE bmc_file.bmc05, #No.FUN-680096 VARCHAR(10)
          l_bmc04   LIKE bmc_file.bmc04,
          l_cnt     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_cnt2    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_sql1    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(1000)
          l_sql2    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(1000)
          l_pmh01   LIKE pmh_file.pmh01,
          l_pmh02   LIKE pmh_file.pmh02,
          l_pmh03   LIKE pmh_file.pmh03,
   	  l_pmh04   LIKE pmh_file.pmh04,
          l_pmh05   LIKE pmh_file.pmh05,
          l_pmh12   LIKE pmh_file.pmh12,
          l_pmh13   LIKE pmh_file.pmh13,
          l_pmc03   LIKE pmc_file.pmc03,
#No.FUN-7C0066---Begin
          l_bmd     RECORD LIKE bmd_file.*,
          l_bon     RECORD LIKE bon_file.*,      #FUN-A40058 
          l_ima01   LIKE ima_file.ima01,         #FUN-A40058 
          l_ver     LIKE ima_file.ima05,
          l_ima15   LIKE ima_File.ima15,
          l_str     LIKE type_file.chr8,         
          l_qpaqty  LIKE bmb_file.bmb06,        
          l_no      LIKE type_file.num5,    
          l_byte    LIKE type_file.num5,    
          l_len     LIKE type_file.num5,    
          l_bmt06_s LIKE bmt_file.bmt06,   
          l_bmtstr  LIKE type_file.chr20,
          l_bmb04   LIKE bmb_file.bmb04,
          order1    LIKE type_file.chr20, 
          l_now     LIKE type_file.num5,
          l_now2    LIKE type_file.num5,
          l_chr1    LIKE type_file.chr1     

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?) " 
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM                         
   END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?) "      
   PREPARE insert_prep1 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM                         
   END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,              
               " VALUES(?,?,?,?,?, ?) "      
   PREPARE insert_prep2 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM                         
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?) "      
   PREPARE insert_prep3 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM                         
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,              
               " VALUES(?,?,?,?,?, ?) "      
   PREPARE insert_prep4 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep4:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM                         
   END IF 

   CALL cl_del_data(l_table)     
   CALL cl_del_data(l_table1)  
   CALL cl_del_data(l_table2)  
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
#No.FUN-7C0066---End
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-7C0066
 
   #Begin:FUN-980030
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #   LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同部門的資料
   #   LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF
   #IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #   LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
   #End:FUN-980030
 
   #FUN-550095 add
   LET l_sql = "SELECT UNIQUE bma01,bma06 ",
               " FROM bma_file, bmb_file,ima_file",
               " WHERE bma01 = bmb01",
               "   AND bma06 = bmb29",
              #"   AND ima01 = bmb03",  #------No.MOD-790097 modify
               "   AND ima01 = bmb01",  #------No.MOD-790097 modify
               "   AND bmaacti = 'Y' ",     #MOD-B50213 add
               "   AND ",tm.wc
   #生效日及失效日的判斷
   IF tm.effective IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
                               "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
                               "' OR bmb05 IS NULL)"
   END IF
   PREPARE r600_pre_bma_key FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   DECLARE r600_cs_bma_key CURSOR FOR r600_pre_bma_key
   #FUN-550095(end)
   #FUN-550095 mark
   #LET l_sql = "SELECT '','',",
   #            " ima06,bma01,bma02,bma03,bma04,",
   #            " bmb15,bmb16,bmb03,ima02,ima021,ima05,",
   #            " ima08,ima15,ima37,bmb23,bmb02,bmb06/bmb07,bmb08,",
   #            " bmb10,bmb18,bmb09,bmb04,bmb05,",
   #            " bmb14,bmb17,bmb11,bmb13,''",
   #            " FROM bma_file, bmb_file,ima_file",
   #            " WHERE bma01 = bmb01",
   #            " AND ima01 = bmb03",
   #            " AND ",tm.wc
   ##生效日及失效日的判斷
   #IF tm.effective IS NOT NULL THEN
   #     LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
   #     "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
   #     "' OR bmb05 IS NULL)"
   #END IF
   #FUN-550095 add
   LET l_sql = "SELECT '','',",
               " ima06,bma01,bma06,bma02,bma03,bma04,", #FUN-550095 add bma06
               " bmb15,bmb16,bmb03,ima02,ima021,ima05,",
               " ima08,ima15,ima37,bmb23,bmb02,bmb06/bmb07,bmb08,",
               " bmb10,bmb18,bmb09,bmb04,bmb05,",
               " bmb14,bmb17,bmb11,bmb13,''",
               " FROM bma_file, bmb_file,ima_file",
               " WHERE bma01 = bmb01",
               " AND ima01 = bmb03",
               " AND bma06 = bmb29",
               " AND bmaacti = 'Y' ",     #MOD-B50213 add
               " AND bma01 = ? ",
               " AND bma06 = ? "
   #生效日及失效日的判斷
   IF tm.effective IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
                               "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
                               "' OR bmb05 IS NULL)"
   END IF
   #FUN-550095(end)
   PREPARE r600_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   DECLARE r600_cs1 CURSOR FOR r600_prepare1
     
#  #No.FUN-7C0066 --start--
#  LET l_sql1= "SELECT ",
#              " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13 ",
#              " FROM pmh_file ",
#              " WHERE pmh01 ='", sr.bmb03,"' "
#  PREPARE r600_p2  FROM l_sql1
#  DECLARE r600_c2 CURSOR FOR r600_p2
#  #No.FUN-7C0066 --end--
# 
#   CALL cl_outnam('abmr600') RETURNING l_name       #No.FUN-7C0066
#No.FUN-590110 --start
   SELECT ima02,ima021,ima06,ima05,ima08,
          ima37,ima55,ima63,imz02
     INTO l_ima02,l_ima021,l_ima06,l_ima05,l_ima08,
          l_ima37,l_ima55,l_ima63,l_imz02
     FROM ima_file, OUTER imz_file
    WHERE ima01=sr.bma01 AND ima_file.ima06 = imz_file.imz01
#No.FUN-7C0066---Begin
#  IF l_ima08 MATCHES '[CDA]' THEN
#     LET g_zaa[60].zaa06 = "N"
#     LET g_zaa[76].zaa06 = "N"
#  ELSE
#     LET g_zaa[60].zaa06 = "Y"
#     LET g_zaa[76].zaa06 = "Y"
#  END IF
# 
#  IF g_sma.sma888[1,1] = 'Y' THEN
#     LET g_zaa[62].zaa06 = "N"
#     LET g_zaa[78].zaa06 = "N"
#  ELSE
#     LET g_zaa[62].zaa06 = "Y"
#     LET g_zaa[78].zaa06 = "Y"
#  END IF
#
#  #供應廠商資料 (採購料件時才有)------------------------------------
#  IF tm.vender MATCHES '[Yy]' THEN
#     LET l_cnt = 0
#     LET l_cnt2 = 0
#     IF l_cnt = 0 THEN
#        LET g_zaa[65].zaa06 = "N"
#        LET g_zaa[66].zaa06 = "N"
#        LET g_zaa[67].zaa06 = "N"
#        LET g_zaa[68].zaa06 = "N"
#        LET g_zaa[69].zaa06 = "N"
#        LET g_zaa[70].zaa06 = "N"              #TQC-5B0122
#     ELSE
#        LET g_zaa[65].zaa06 = "Y"
#        LET g_zaa[66].zaa06 = "Y"
#        LET g_zaa[67].zaa06 = "Y"
#        LET g_zaa[68].zaa06 = "Y"
#        LET g_zaa[69].zaa06 = "Y"
#        LET g_zaa[70].zaa06 = "Y"              #TQC-5B0122
#     END IF
#  ELSE
#     LET g_zaa[65].zaa06 = "Y"
#     LET g_zaa[66].zaa06 = "Y"
#     LET g_zaa[67].zaa06 = "Y"
#     LET g_zaa[68].zaa06 = "Y"
#     LET g_zaa[69].zaa06 = "Y"
#     LET g_zaa[70].zaa06 = "Y"                 #TQC-5B0122
#  END IF
#  LET l_cnt = l_cnt + 1
#  CALL cl_prt_pos_len()
#  START REPORT r600_rep TO l_name        #No.FUN-7C0066
#No.FUN-590110 --end
   IF tm.vender MATCHES '[Yy]' THEN
      LET l_name='abmr600'
   ELSE
      LET l_name='abmr600_1'
   END IF
   LET l_chr1 = l_ima08
#No.FUN-7C0066---End
 
#---->產品結構插件位置
   CALL r600_cur()

#  LET g_pageno = 0                       #No.FUN-7C0066

#---->產品結構插件位置
   LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                " WHERE bmt01=?  AND bmt02= ? AND ",
                " bmt03=? AND ",
                " (bmt04 IS NULL OR bmt04 >= ?) ",
                " AND bmt08 = ? ", #FUN-550095 add bmt08
                " ORDER BY 1"
   PREPARE r600_prebmt     FROM l_cmd
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   DECLARE r600_bmt  CURSOR FOR r600_prebmt

   #產品結構說明資料
   LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                " WHERE bmc01=?  AND bmc02= ? AND ",
                " bmc021=? AND ",
                " (bmc03 IS NULL OR bmc03 >= ?) ",
                " AND bmc06 = ? ", #FUN-550095 add bmc06
                " ORDER BY 1"
   PREPARE r600_prebmc    FROM l_cmd
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   DECLARE r600_bmc CURSOR FOR r600_prebmc

#FUN-550095 add
   FOREACH r600_cs_bma_key INTO l_bma01,l_bma06
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      FOREACH r600_cs1
        USING l_bma01,l_bma06
         INTO sr.*
#FUN-550095(end)
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
         IF sr.ima08 = 'X' AND tm.blow = 'Y' THEN
            LET g_bma01 = sr.bma01
            CALL r600_phatom(sr.bmb03,sr.bmb06)
            CONTINUE FOREACH
         END IF
	 CASE
            WHEN tm.arrange = '1'
                 LET sr.order1=sr.bmb02 using'#####'
	    WHEN tm.arrange = '2'
                 LET sr.order1=sr.bmb03
	    WHEN tm.arrange = '3'
                 LET sr.order1=sr.bmb13
            OTHERWISE LET sr.order1 = ' '
         END CASE
   #---TQC-CC0071---mark---
#        #改變消耗特性的表示方式
#        LET sr.feature=''
#        IF sr.bmb15 MATCHES '[Yy]' THEN
#           LET sr.bmb15='*'  LET sr.feature='*'
#        ELSE
#           LET sr.bmb15=' '
#        END IF
#        IF sr.bmb16 = '1' THEN
#           LET sr.bmb16 = 'U' LET sr.feature=sr.feature CLIPPED ,'U'
#        ELSE
#           IF sr.bmb16 = '2' THEN
#              LET sr.bmb16 = 'S' LET sr.feature=sr.feature CLIPPED,'S'
#           ELSE
#FUN-A40058 --begin--
#              IF sr.bmb16 = '7' THEN
#                 LET sr.bmb16 = 'Z' LET sr.feature=sr.feature CLIPPED,'Z'                  
#              ELSE
#FUN-A40058 --end--            
#                LET sr.bmb16 = ' '
#              END IF             #FUN-A40058 
#           END IF
#        END IF
#        IF sr.bmb14 = '1' THEN
#           LET sr.bmb14 = 'O'   LET sr.feature=sr.feature CLIPPED,'O'
#        ELSE
#           LET sr.bmb14 = ''
#        END IF
#        IF sr.bmb17='Y' THEN
#           LET sr.bmb17='F'     LET sr.feature=sr.feature CLIPPED,'F'
#        ELSE
#           LET sr.bmb17=' '
#        END IF
   #---TQC-CC0071---mark--end-

#No.FUN-7C0066---Begin
         CALL s_effver(sr.bma01,tm.effective) RETURNING l_ver
         SELECT ima02,ima021,ima06,ima05,ima08,
                ima37,ima55,ima63,imz02
           INTO l_ima02,l_ima021,l_ima06,l_ima05,l_ima08,
                l_ima37,l_ima55,l_ima63,l_imz02
           FROM ima_file, OUTER imz_file
          WHERE ima01=sr.bma01 AND ima_file.ima06 = imz_file.imz01
         IF SQLCA.sqlcode THEN
            LET l_ima02= ' '  LET l_ima06 = ' ' LET l_ima05 = ' '
            LET l_ima08= ' '  LET l_ima37 = ' ' LET l_ima55 = ' '
            LET l_ima63= ' '  LET l_imz02 = ' '
         END IF
         FOR g_cnt=1 TO 200
            LET l_bmt06[g_cnt]=NULL
         END FOR
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         IF sr.phatom IS NOT NULL AND sr.phatom != ' ' THEN
            LET l_bmt01 = sr.phatom
         ELSE
            LET l_bmt01 = sr.bma01
         END IF
         FOREACH r600_bmt
           USING l_bmt01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 
            INTO l_bmt05,l_bmt06_s
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
         END FOREACH
         LET l_bmt06[l_now2] = l_bmtstr
     
         FOR g_cnt=1 TO 100
            LET l_bmc05[g_cnt]=NULL
         END FOR
         LET l_now=1
         IF sr.phatom IS NOT NULL AND sr.phatom != ' ' THEN
            LET l_bmc01 = sr.phatom
         ELSE
            LET l_bmc01 = sr.bma01
         END IF
         FOREACH r600_bmc
           USING l_bmc01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 
            INTO l_bmc04,l_bmc05[l_now]
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF l_now > 100 THEN
               CALL cl_err('','9036',1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
               EXIT PROGRAM
            END IF
            LET l_now=l_now+1
         END FOREACH
         LET l_now=l_now-1
	 LET l_qpaqty = sr.bmb06 * tm.a
 
	 IF tm.vender MATCHES '[Yy]' THEN
            LET l_cnt  = 0
            LET l_cnt2 = 0
            LET l_sql1= "SELECT ",                                           
                        " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13 ",            
                        " FROM pmh_file ",                                         
                        " WHERE pmh01 ='", sr.bmb03,"' ",
                        "   AND pmh21 = ' ' ",                                           #CHI-860042                                   
                        "   AND pmh22 = '1' ",                                           #CHI-860042
                        "   AND pmh23 = ' ' ",                                           #No.CHI-960033 
                        "   AND pmhacti = 'Y'"                                           #CHI-910021                           
            PREPARE r600_p2  FROM l_sql1                                          
            DECLARE r600_c2 CURSOR FOR r600_p2 
 
            FOREACH r600_c2 INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
                                 l_pmh12,l_pmh13
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               EXECUTE insert_prep1 USING
                  sr.bmb03,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
                  l_pmh12,l_pmh13
            END FOREACH
         END IF
         FOR g_cnt = 3 TO l_now2   #MOD-A40152 mod 4->3
            IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' ' THEN
               EXIT FOR
            END IF
            EXECUTE insert_prep2 USING
               sr.bma01,sr.bmb02,sr.bmb03,sr.bmb04,l_bmt05,
               l_bmt06[g_cnt]   #MOD-A40152 mod  #l_bmt06_s
         END FOR
         IF tm.sub_flag ='Y' AND sr.bmb16 MATCHES '[12SU]' THEN
            LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
                      " WHERE bmd01='",sr.bmb03,"' AND bmd04=ima01",
                      "  AND (bmd08='",sr.bma01,"' OR bmd08='ALL')",
                      "  AND bmdacti = 'Y'"                                           #CHI-910021
            IF tm.effective IS NOT NULL THEN
               LET l_sql=l_sql CLIPPED,
                   " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
                   " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
            END IF
            PREPARE r600_sub_p FROM l_sql
            DECLARE r600_sub_c CURSOR FOR r600_sub_p
           #FOREACH r600_sub_c INTO l_bmd.*, l_ima02a, l_ima021   #TQC-C30308 l_ima02-->l_ima02a  #MOD-C40100 mark
            FOREACH r600_sub_c INTO l_bmd.*, l_ima02a, l_ima021a  #MOD-C40100 l_ima021-->l_ima021a
               EXECUTE insert_prep3 USING
                 #sr.bma01,sr.bma06,l_ima02a,sr.bmb03,l_ima021,   #TQC-C30308 l_ima02-->l_ima02a  #MOD-C40100 mark
                  sr.bma01,sr.bma06,l_ima02a,sr.bmb03,l_ima021a,   #MOD-C40100 l_ima021-->l_ima021a
                  l_bmd.bmd04,l_bmd.bmd05,l_bmd.bmd06,l_bmd.bmd07
            END FOREACH
         END IF
#FUN-A40058 --begin--
        IF tm.sub_flag ='Y' AND sr.bmb16 MATCHES '[7Z]' THEN                                  
            LET l_sql="SELECT bon_file.*, ima01,ima02,ima021 FROM bon_file,bmb_file,ima_file",                
                      " WHERE imaacti = 'Y'",
                      "   AND bmb03 = '",sr.bmb03,"' AND bmb03 = bon01",
                      "   AND bmb01 = '",sr.bma01,"' AND (bmb01 = bon02 or bon02 = '*')",
                      "   AND bmb16 = '7' AND bonacti = 'Y'",
                      "   AND ima251 = bon06  AND ima109 = bon07",
                      "   AND ima54  = bon08  AND ima022 BETWEEN bon04 AND bon05",
                      "   AND ima01 != bon01",
                      "   ORDER BY ima01"              
            IF tm.effective IS NOT NULL THEN
               LET l_sql=l_sql CLIPPED,
                   " AND (bon09 <='",tm.effective CLIPPED,"' OR bon09 IS NULL)",
                   " AND (bon10 > '",tm.effective CLIPPED,"' OR bon10 IS NULL)"
            END IF
            PREPARE r600_bon FROM l_sql
            DECLARE r600_bon_c CURSOR FOR r600_bon
           #FOREACH r600_bon_c INTO l_bon.*,l_ima01,l_ima02a,l_ima021  #TQC-C30308 l_ima02-->l_ima02a  #MOD-C40100 mark
            FOREACH r600_bon_c INTO l_bon.*,l_ima01,l_ima02a,l_ima021a  #MOD-C40100 l_ima021-->l_ima021a
               EXECUTE insert_prep3 USING
                 #sr.bma01,sr.bma06,l_ima02a,sr.bmb03,l_ima021,        #TQC-C30308 l_ima02-->l_ima02a  #MOD-C40100 mark
                  sr.bma01,sr.bma06,l_ima02a,sr.bmb03,l_ima021a,        #MOD-C40100 l_ima021-->l_ima021a
                  l_ima01,l_bon.bon09,l_bon.bon10,l_bon.bon11
            END FOREACH
         END IF
#FUN-A40058 --end--         
 
         IF l_now >= 1 THEN
            FOR g_cnt = 1 TO l_now STEP 2
               EXECUTE insert_prep4 USING
                  sr.bma01,sr.bmb02,sr.bmb03,sr.bmb04,l_bmc05[g_cnt],
                  l_bmc05[g_cnt+1] 
            END FOR
         END IF
         EXECUTE insert_prep USING
            l_ima02, l_ima021,l_ima05,   l_ima06,   l_ima08,
            l_ima15, l_ima37, l_ima55,   l_ima63,   l_imz02,
            l_ver,   l_qpaqty,sr.bma01,  sr.bma02,  sr.bma03,
            sr.bma04,sr.bma06,sr.phatom, sr.bmb02,  sr.bmb03,
            sr.bmb04,sr.bmb05,sr.bmb08,  sr.bmb09,  sr.bmb10,
            sr.bmb11,sr.bmb14,sr.bmb15,  sr.bmb16,  sr.bmb17,
            sr.bmb18,sr.bmb23,sr.ima02,  sr.ima021, sr.ima08,
            sr.ima15,sr.ima37,l_bmt06[1],l_bmt06[2],l_bmt06[3],
            sr.order1
#        OUTPUT TO REPORT r600_rep(sr.*)
#No.FUN-7C0066---End
      END FOREACH
   END FOREACH #FUN-550095 add
#No.FUN-7C0066---Begin
  #DISPLAY "" AT 2,1
  #FINISH REPORT r600_rep
   IF g_zz05 = 'Y' THEN                                                      
      CALL cl_wcchp(tm.wc,'bma01,bma06,ima06,ima09,ima10,ima11,ima12')                         
           RETURNING tm.wc                                                   
   END IF                                                                    
   #p1~p9
   LET g_str=tm.wc ,";",tm.effective,";",tm.a,";",tm.engine,";",
             g_sma.sma118[1,1],";",tm.sub_flag,";",g_azi03,";",
             l_chr1,";",tm.vender
                                                                       
   IF tm.vender MATCHES '[Yy]' THEN
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table  CLIPPED, "|",
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED, "|",
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED, "|",  
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table3 CLIPPED, "|", 
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table4 CLIPPED       
   ELSE 
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table  CLIPPED, "|", 
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED, "|", 
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table3 CLIPPED, "|", 
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table4 CLIPPED 
   END IF
   CALL cl_prt_cs3('abmr600',l_name,l_sql,g_str)
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0066---End
END FUNCTION
 
FUNCTION r600_phatom(p_phatom,p_qpa)
   DEFINE p_phatom    LIKE bmb_file.bmb01,
          p_qpa       LIKE bmb_file.bmb06,
          l_ac,l_i    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_tot       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_times     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno	      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq	      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_chr	      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          sr DYNAMIC ARRAY OF RECORD          #每階存放資料
              order1  LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              feature LIKE cre_file.cre08,    #No.FUN-680096 VARCHAR(10)
              ima06   LIKE ima_file.ima06,    #分群碼
              bma01   LIKE bma_file.bma01,    #主件料件
              bma06   LIKE bma_file.bma06,    #FUN-550095 add bma06
              bma02   LIKE bma_file.bma02,    #工程變異單號
              bma03   LIKE bma_file.bma03,    #工程變異日期
              bma04   LIKE bma_file.bma04,    #組合模組參考
              bmb15   LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16   LIKE bmb_file.bmb16,    #替代特性
              bmb03   LIKE bmb_file.bmb03,    #元件料號
              ima02   LIKE ima_file.ima02,    #品名規格
              ima021  LIKE ima_file.ima02,    #品名規格
              ima05   LIKE ima_file.ima05,    #版本
              ima08   LIKE ima_file.ima08,    #來源
              ima15   LIKE ima_file.ima15,    #保稅否
              ima37   LIKE ima_file.ima37,    #補貨
              bmb23   LIKE bmb_file.bmb23,    #選中率
              bmb02   LIKE bmb_file.bmb02,    #項次
              bmb06   LIKE bmb_file.bmb06,    #QPA
              bmb08   LIKE bmb_file.bmb08,    #損耗率%
              bmb10   LIKE bmb_file.bmb10,    #發料單位
              bmb18   LIKE bmb_file.bmb18,    #投料時距
              bmb09   LIKE bmb_file.bmb09,    #製程序號
              bmb04   LIKE bmb_file.bmb04,    #有效日期
              bmb05   LIKE bmb_file.bmb05,    #失效日期
              bmb14   LIKE bmb_file.bmb14,    #元件使用特性
              bmb17   LIKE bmb_file.bmb17,    #Feature
              bmb11   LIKE bmb_file.bmb11,    #工程圖號
              bmb13   LIKE bmb_file.bmb13,    #插件位置
              phatom  LIKE ima_file.ima01     #虛擬料件
          END RECORD,
          l_bma01     LIKE bma_file.bma01,
#No.FUN-7C0066---Begin
          l_sql	      LIKE type_file.chr1000,  
          l_bmd       RECORD LIKE bmd_file.*,
          l_bon       RECORD LIKE bon_file.*,    #FUN-A40058 
          l_ima01     LIKE ima_file.ima01,       #FUN-A40058
          l_ima02     LIKE ima_file.ima02,    #品名規格
          l_ima02a    LIKE ima_file.ima02,    #品名規格    #MOD-C40100
          l_ima021    LIKE ima_file.ima02,    #品名規格
          l_ima021a   LIKE ima_file.ima02,    #品名規格    #MOD-C40100
          l_ima05     LIKE ima_file.ima05,    #版本
          l_ima06     LIKE ima_file.ima06,    #分群碼
          l_ima08     LIKE ima_file.ima08,    #來源
          l_ima37     LIKE ima_file.ima37,    #補貨
          l_ima63     LIKE ima_file.ima63,    #發料單位
          l_ima55     LIKE ima_file.ima55,    #生產單位
          l_imz02     LIKE imz_file.imz02,    #說明內容
          l_bmt01     LIKE bmt_file.bmt01,
          l_bmt05     LIKE bmt_file.bmt05,
          l_bmt06     ARRAY[200] OF LIKE type_file.chr20,  #MOD-A40152 mod bmt_file.bmt06->type_file.chr20
          l_bmc01     LIKE bmc_file.bmc01,
          l_bmc04     LIKE bmc_file.bmc04,
          l_bmc05     ARRAY[100] OF LIKE bmc_file.bmc05,  
          l_cnt       LIKE type_file.num5,      
          l_cnt2      LIKE type_file.num5,      
          l_sql1      LIKE type_file.chr1000,       
          l_sql2      LIKE type_file.chr1000,       
          l_pmh01     LIKE pmh_file.pmh01,
	  l_pmh02     LIKE pmh_file.pmh02,
	  l_pmh03     LIKE pmh_file.pmh03,
	  l_pmh04     LIKE pmh_file.pmh04,
	  l_pmh05     LIKE pmh_file.pmh05,
	  l_pmh12     LIKE pmh_file.pmh12,
	  l_pmh13     LIKE pmh_file.pmh13,
          l_ver       LIKE ima_file.ima05,
          l_str       LIKE type_file.chr8,         
          l_qpaqty    LIKE bmb_file.bmb06,        
          l_no        LIKE type_file.num5,    
          l_byte      LIKE type_file.num5,    
          l_len       LIKE type_file.num5,    
          l_bmt06_s   LIKE bmt_file.bmt06,   
          l_bmtstr    LIKE type_file.chr20, 
          l_now       LIKE type_file.num5,
          l_now2      LIKE type_file.num5,
          l_bmb04     LIKE bmb_file.bmb04,
          l_ima15     LIKE ima_file.ima15             
#No.FUN-7C0066---End

   LET l_ac = 1
   LET arrno = 600
   FOREACH r600_cs2
     USING p_phatom
      INTO sr[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET sr[l_ac].phatom = p_phatom
      LET sr[l_ac].bmb06= sr[l_ac].bmb06 * p_qpa
      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
   END FOREACH
 
   LET l_tot=l_ac-1
   FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
      IF sr[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
         CALL r600_phatom(sr[l_i].bmb03,sr[l_i].bmb06)
         CONTINUE FOR
      END IF
      CASE
         WHEN tm.arrange = '1' LET sr[l_i].order1=sr[l_i].bmb02 using '#####'
         WHEN tm.arrange = '2' LET sr[l_i].order1=sr[l_i].bmb03  #料號
         WHEN tm.arrange = '3' LET sr[l_i].order1=sr[l_i].bmb13  #插件位置
         OTHERWISE             LET sr[l_i].order1 = ' '
      END CASE
      #改變消耗特性的表示方式
      LET sr[l_i].feature = ''
      IF sr[l_i].bmb15 MATCHES '[Yy]' THEN
         LET sr[l_i].bmb15='*'  LET sr[l_i].feature='*'
      ELSE
         LET sr[l_i].bmb15=' '
      END IF
      IF sr[l_i].bmb16 = '1' THEN
         LET sr[l_i].bmb16 = 'U'
         LET sr[l_i].feature=sr[l_i].feature CLIPPED,'U'
      ELSE
         IF sr[l_i].bmb16 = '2' THEN
            LET sr[l_i].bmb16 = 'S'
            LET sr[l_i].feature=sr[l_i].feature CLIPPED,'S'            
         ELSE
#FUN-A40058 --begin--
            IF sr[l_i].bmb16 = '7' THEN
               LET sr[l_i].bmb16 = 'Z'
               LET sr[l_i].feature=sr[l_i].feature CLIPPED,'Z'
            ELSE                     
#FUN-A40058 --end--         
               LET sr[l_i].bmb16 = ' '
            END IF        #FUN-A40058  
         END IF
      END IF
      IF sr[l_i].bmb14='0' THEN
         LET sr[l_i].bmb14=' '
      ELSE
         LET sr[l_i].bmb14='O'
         LET sr[l_i].feature=sr[l_i].feature CLIPPED,'O'
      END IF
      IF sr[l_i].bmb17='Y' THEN
         LET sr[l_i].bmb17='F'
      ELSE
         LET sr[l_i].bmb17=' '
      END IF
      LET sr[l_i].bma01= g_bma01
#No.FUN-7C0066---Begin
      CALL s_effver(sr[l_i].bma01,tm.effective) RETURNING l_ver
      SELECT ima02,ima021,ima06,ima05,ima08,
             ima37,ima55,ima63,imz02
        INTO l_ima02,l_ima021,l_ima06,l_ima05,l_ima08,
             l_ima37,l_ima55,l_ima63,l_imz02
        FROM ima_file, OUTER imz_file
       WHERE ima01=sr[l_i].bma01 AND ima06 = imz01
      IF SQLCA.sqlcode THEN
         LET l_ima02= ' '  LET l_ima06 = ' ' LET l_ima05 = ' '
         LET l_ima08= ' '  LET l_ima37 = ' ' LET l_ima55 = ' '
         LET l_ima63= ' '  LET l_imz02 = ' '
      END IF
      FOR g_cnt=1 TO 200
          LET l_bmt06[g_cnt]=NULL
      END FOR
      LET l_now2=1
      LET l_len =20
      LET l_bmtstr = ''
      IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom != ' ' THEN
         LET l_bmt01 = sr[l_i].phatom
      ELSE
         LET l_bmt01 = sr[l_i].bma01
      END IF
      FOREACH r600_bmt
        USING l_bmt01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06 
         INTO l_bmt05,l_bmt06_s
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
      END FOREACH
      LET l_bmt06[l_now2] = l_bmtstr
     
      FOR g_cnt=1 TO 100
         LET l_bmc05[g_cnt]=NULL
      END FOR
      LET l_now=1
      IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom != ' ' THEN
         LET l_bmc01 = sr[l_i].phatom
      ELSE
         LET l_bmc01 = sr[l_i].bma01
      END IF
      FOREACH r600_bmc
        USING l_bmc01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06 
         INTO l_bmc04,l_bmc05[l_now]
         IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
         END IF
         IF l_now > 100 THEN
            CALL cl_err('','9036',1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
         END IF
         LET l_now=l_now+1
      END FOREACH
      LET l_now=l_now-1
      LET l_qpaqty = sr[l_i].bmb06 * tm.a
 
      IF tm.vender MATCHES '[Yy]' THEN
         LET l_cnt  = 0
         LET l_cnt2 = 0
         LET l_sql1= "SELECT ",                                           
                     " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13 ",            
                     " FROM pmh_file ",                                         
                     " WHERE pmh01 ='", sr[l_i].bmb03,"' ",
                     "   AND pmh21 = ' ' ",                                           #CHI-860042                                   
                     "   AND pmh22 = '1' ",                                           #CHI-860042
                     "   AND pmh23 = ' ' ",                                           #No.CHI-960033 
                     "   AND pmhacti = 'Y'"                                           #CHI-910021                           
         PREPARE r600_p21  FROM l_sql1                                          
         DECLARE r600_c21 CURSOR FOR r600_p21 
 
         FOREACH r600_c21 INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
                               l_pmh12,l_pmh13    
            IF SQLCA.sqlcode THEN
               EXIT FOREACH
            END IF
            EXECUTE insert_prep1 USING
               sr[l_i].bmb03,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
               l_pmh12,l_pmh13
         END FOREACH
      END IF
      FOR g_cnt = 3 TO l_now2   #MOD-A40152 mod 4->3
         IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' ' THEN
            EXIT FOR
         END IF
         EXECUTE insert_prep2 USING
            sr[l_i].bma01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,l_bmt05,
            l_bmt06[g_cnt]
      END FOR
      IF tm.sub_flag ='Y' AND sr[l_i].bmb16 MATCHES '[12SU]' THEN
         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
                   " WHERE bmd01='",sr[l_i].bmb03,"' AND bmd04=ima01",
                   "  AND (bmd08='",sr[l_i].bma01,"' OR bmd08='ALL')",
                   "  AND bmdacti = 'Y'"                                           #CHI-910021
         IF tm.effective IS NOT NULL THEN
            LET l_sql=l_sql CLIPPED,
                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
         END IF
         PREPARE r600_sub_p1 FROM l_sql
         DECLARE r600_sub_c1 CURSOR FOR r600_sub_p1
        #FOREACH r600_sub_c1 INTO l_bmd.*, l_ima02, l_ima021  #MOD-C40100 mark
         FOREACH r600_sub_c1 INTO l_bmd.*, l_ima02a,l_ima021a #MOD-C40100
            EXECUTE insert_prep3 USING
              #sr[l_i].bma01,sr[l_i].bma06,l_ima02,sr[l_i].bmb03,l_ima021, #MOD-C40100 mark
               sr[l_i].bma01,sr[l_i].bma06,l_ima02a,sr[l_i].bmb03,l_ima021a, #MOD-C40100
               l_bmd.bmd04,l_bmd.bmd05,l_bmd.bmd06,l_bmd.bmd07
         END FOREACH
      END IF
#FUN-A40058 --begin--
        IF tm.sub_flag ='Y' AND sr[l_i].bmb16 MATCHES '[7Z]' THEN                                  
            LET l_sql="SELECT bon_file.*, ima01,ima02,ima021 FROM bon_file,bmb_file,ima_file",                
                      " WHERE imaacti = 'Y'",
                      "   AND bmb03 = '",sr[l_i].bmb03,"' AND bmb03 = bon01",
                      "   AND bmb01 = '",sr[l_i].bma01,"' AND (bmb01 = bon02 or bon02 = '*')",
                      "   AND bmb16 = '7' AND bonacti = 'Y'",
                      "   AND ima251 = bon06  AND ima109 = bon07",
                      "   AND ima54  = bon08  AND ima022 BETWEEN bon04 AND bon05",
                      "   AND ima01 != bon01",
                      "   ORDER BY ima01"              
            IF tm.effective IS NOT NULL THEN
               LET l_sql=l_sql CLIPPED,
                   " AND (bon09 <='",tm.effective CLIPPED,"' OR bon09 IS NULL)",
                   " AND (bon10 > '",tm.effective CLIPPED,"' OR bon10 IS NULL)"
            END IF
            PREPARE r600_bon_1 FROM l_sql
            DECLARE r600_bon_c_1 CURSOR FOR r600_bon_1
           #FOREACH r600_bon_c_1 INTO l_bon.*,l_ima01,l_ima02,l_ima021   #MOD-C40100 mark
            FOREACH r600_bon_c_1 INTO l_bon.*,l_ima01,l_ima02a,l_ima021a #MOD-C40100
               EXECUTE insert_prep3 USING
                 #sr[l_i].bma01,sr[l_i].bma06,l_ima02,sr[l_i].bmb03,l_ima021,   #MOD-C40100 mark
                  sr[l_i].bma01,sr[l_i].bma06,l_ima02a,sr[l_i].bmb03,l_ima021a, #MOD-C40100
                  l_ima01,l_bon.bon09,l_bon.bon10,l_bon.bon11
            END FOREACH
         END IF
#FUN-A40058 --end--               
 
      IF l_now >= 1 THEN
         FOR g_cnt = 1 TO l_now STEP 2
            EXECUTE insert_prep4 USING
               sr[l_i].bma01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,l_bmc05[g_cnt],
               l_bmc05[g_cnt+1] 
         END FOR
      END IF
 
      EXECUTE insert_prep USING
         l_ima02,      l_ima021,     l_ima05,       l_ima06,       l_ima08,
         l_ima15,      l_ima37,      l_ima55,       l_ima63,       l_imz02,
         l_ver,        l_qpaqty,     sr[l_i].bma01, sr[l_i].bma02, sr[l_i].bma03,
         sr[l_i].bma04,sr[l_i].bma06,sr[l_i].phatom,sr[l_i].bmb02, sr[l_i].bmb03,
         sr[l_i].bmb04,sr[l_i].bmb05,sr[l_i].bmb08, sr[l_i].bmb09, sr[l_i].bmb10,
         sr[l_i].bmb11,sr[l_i].bmb14,sr[l_i].bmb15, sr[l_i].bmb16, sr[l_i].bmb17,
         sr[l_i].bmb18,sr[l_i].bmb23,sr[l_i].ima02, sr[l_i].ima021,sr[l_i].ima08,
         sr[l_i].ima15,sr[l_i].ima37,l_bmt06[1],    l_bmt06[2],    l_bmt06[3],
         sr[l_i].order1
#     OUTPUT TO REPORT r600_rep(sr[l_i].*)
#No.FUN-7C0066---End
   END FOR
END FUNCTION
 
#No.FUN-7C0066 ---Begin 
#FUNCTION r600_phatom(p_phatom,p_qpa)
#   DEFINE p_phatom  LIKE bmb_file.bmb01,
#          p_qpa     LIKE bmb_file.bmb06,
#          l_ac,l_i  LIKE type_file.num5,         #No.FUN-680096 SMALLINT
#          l_tot,l_times LIKE type_file.num5,     #No.FUN-680096 SMALLINT
#          arrno		LIKE type_file.num5,     #No.FUN-680096 SMALLINT
#          b_seq		LIKE type_file.num5,     #No.FUN-680096 SMALLINT
#          l_chr		LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
#          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
#              order1  LIKE bmb_file.bmb03,  #No.FUN-680096 VARCHAR(20)
#              feature LIKE cre_file.cre08,  #No.FUN-680096 VARCHAR(10)
#              ima06 LIKE ima_file.ima06,    #分群碼
#              bma01 LIKE bma_file.bma01,    #主件料件
#              bma06 LIKE bma_file.bma06,    #FUN-550095 add bma06
#              bma02 LIKE bma_file.bma02,    #工程變異單號
#              bma03 LIKE bma_file.bma03,    #工程變異日期
#              bma04 LIKE bma_file.bma04,    #組合模組參考
#              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
#              bmb16 LIKE bmb_file.bmb16,    #替代特性
#              bmb03 LIKE bmb_file.bmb03,    #元件料號
#              ima02 LIKE ima_file.ima02,    #品名規格
#              ima021 LIKE ima_file.ima02,    #品名規格
#              ima05 LIKE ima_file.ima05,    #版本
#              ima08 LIKE ima_file.ima08,    #來源
#              ima15 LIKE ima_file.ima15,    #保稅否
#              ima37 LIKE ima_file.ima37,    #補貨
#              bmb23 LIKE bmb_file.bmb23,    #選中率
#              bmb02 LIKE bmb_file.bmb02,    #項次
#              bmb06 LIKE bmb_file.bmb06,    #QPA
#              bmb08 LIKE bmb_file.bmb08,    #損耗率%
#              bmb10 LIKE bmb_file.bmb10,    #發料單位
#              bmb18 LIKE bmb_file.bmb18,    #投料時距
#              bmb09 LIKE bmb_file.bmb09,    #製程序號
#              bmb04 LIKE bmb_file.bmb04,    #有效日期
#              bmb05 LIKE bmb_file.bmb05,    #失效日期
#              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
#              bmb17 LIKE bmb_file.bmb17,    #Feature
#              bmb11 LIKE bmb_file.bmb11,    #工程圖號
#              bmb13 LIKE bmb_file.bmb13,    #插件位置
#              phatom LIKE ima_file.ima01    #虛擬料件
#          END RECORD,
#          l_bma01  LIKE bma_file.bma01,
##No.FUN-7C0066---Begin
#          l_sql	  LIKE type_file.chr1000,  
#          l_bmd   RECORD LIKE bmd_file.*,
#          l_ima02 LIKE ima_file.ima02,    #品名規格
#          l_ima021 LIKE ima_file.ima02,    #品名規格
#          l_ima05 LIKE ima_file.ima05,    #版本
#          l_ima06 LIKE ima_file.ima06,    #分群碼
#          l_ima08 LIKE ima_file.ima08,    #來源
#          l_ima37 LIKE ima_file.ima37,    #補貨
#          l_ima63 LIKE ima_file.ima63,    #發料單位
#          l_ima55 LIKE ima_file.ima55,    #生產單位
#          l_imz02 LIKE imz_file.imz02,    #說明內容
#          l_bmt01 LIKE bmt_file.bmt01,
#          l_bmt05 LIKE bmt_file.bmt05,
#          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  
#          l_bmc01 LIKE bmc_file.bmc01,
#          l_bmc04 LIKE bmc_file.bmc04,
#          l_bmc05 ARRAY[100] OF LIKE bmc_file.bmc05,  
#		      l_cnt,l_cnt2 LIKE type_file.num5,      
#		      l_sql1   LIKE type_file.chr1000,       
#		      l_sql2   LIKE type_file.chr1000,       
#		      l_pmh01  LIKE pmh_file.pmh01,
#	    	  l_pmh02  LIKE pmh_file.pmh02,
#	    	  l_pmh03  LIKE pmh_file.pmh03,
#	    	  l_pmh04  LIKE pmh_file.pmh04,
#	    	  l_pmh05  LIKE pmh_file.pmh05,
#	    	  l_pmh12  LIKE pmh_file.pmh12,
#		      l_pmh13  LIKE pmh_file.pmh13,
#             l_ver    LIKE ima_file.ima05,
#             l_str    LIKE type_file.chr8,         
#             l_qpaqty   LIKE bmb_file.bmb06,        
#             l_no           LIKE type_file.num5,    
#             l_byte,l_len   LIKE type_file.num5,    
#             l_bmt06_s      LIKE bmt_file.bmt06,   
#             l_bmtstr       LIKE type_file.chr20, 
#             l_now,l_now2   LIKE type_file.num5             
##No.FUN-7C0066---End
#    LET l_ac = 1
#    LET arrno = 600
#    FOREACH r600_cs2
#    USING p_phatom
#    INTO sr[l_ac].*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#      END IF
#      LET sr[l_ac].phatom = p_phatom
#      LET sr[l_ac].bmb06= sr[l_ac].bmb06 * p_qpa
#      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
#      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
#    END FOREACH
#
#	LET l_tot=l_ac-1
#    FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
#        IF sr[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
#           CALL r600_phatom(sr[l_i].bmb03,sr[l_i].bmb06)
#           CONTINUE FOR
#        END IF
#        CASE
#         WHEN tm.arrange = '1' LET sr[l_i].order1=sr[l_i].bmb02 using '#####'
#         WHEN tm.arrange = '2' LET sr[l_i].order1=sr[l_i].bmb03  #料號
#         WHEN tm.arrange = '3' LET sr[l_i].order1=sr[l_i].bmb13  #插件位置
#         OTHERWISE LET sr[l_i].order1 = ' '
#        END CASE
#        #改變消耗特性的表示方式
#         LET sr[l_i].feature = ''
#         IF sr[l_i].bmb15 MATCHES '[Yy]'
#         THEN LET sr[l_i].bmb15='*'  LET sr[l_i].feature='*'
#         ELSE LET sr[l_i].bmb15=' '
#         END IF
#         IF sr[l_i].bmb16 = '1' THEN
#              LET sr[l_i].bmb16 = 'U'
#              LET sr[l_i].feature=sr[l_i].feature CLIPPED,'U'
#         ELSE IF sr[l_i].bmb16 = '2' THEN
#                 LET sr[l_i].bmb16 = 'S'
#                 LET sr[l_i].feature=sr[l_i].feature CLIPPED,'S'
#              ELSE LET sr[l_i].bmb16 = ' '
#              END IF
#         END IF
#         IF sr[l_i].bmb14='0' THEN
#              LET sr[l_i].bmb14=' '
#         ELSE LET sr[l_i].bmb14='O'
#              LET sr[l_i].feature=sr[l_i].feature CLIPPED,'O'
#         END IF
#         IF sr[l_i].bmb17='Y' THEN
#              LET sr[l_i].bmb17='F'
#         ELSE LET sr[l_i].bmb17=' '
#         END IF
#         LET sr[l_i].bma01= g_bma01
##No.FUN-7C0066---Begin
#      CALL s_effver(sr[l_i].bma01,tm.effective) RETURNING l_ver
#      SELECT ima02,ima021,ima06,ima05,ima08,
#             ima37,ima55,ima63,imz02
#        INTO l_ima02,l_ima021,l_ima06,l_ima05,l_ima08,
#             l_ima37,l_ima55,l_ima63,l_imz02
#        FROM ima_file, OUTER imz_file
#       WHERE ima01=sr[l_i].bma01 AND ima06 = imz01
#      IF SQLCA.sqlcode THEN
#         LET l_ima02= ' '  LET l_ima06 = ' ' LET l_ima05 = ' '
#         LET l_ima08= ' '  LET l_ima37 = ' ' LET l_ima55 = ' '
#         LET l_ima63= ' '  LET l_imz02 = ' '
#      END IF
#         FOR g_cnt=1 TO 200
#             LET l_bmt06[g_cnt]=NULL
#         END FOR
#         LET l_now2=1
#         LET l_len =20
#         LET l_bmtstr = ''
#         IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom != ' '
#         THEN LET l_bmt01 = sr[l_i].phatom
#         ELSE LET l_bmt01 = sr[l_i].bma01
#         END IF
#         FOREACH r600_bmt
#         USING l_bmt01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06 
#         INTO l_bmt05,l_bmt06_s
#            IF SQLCA.sqlcode THEN
#               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#            END IF
#            IF l_now2 > 200 THEN
#               CALL cl_err('','9036',1)
#               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#               EXIT PROGRAM
#            END IF
#            LET l_byte = length(l_bmt06_s) + 1
#            IF l_len >= l_byte THEN
#               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#               LET l_len = l_len - l_byte
#            ELSE
#               LET l_bmt06[l_now2] = l_bmtstr
#               LET l_now2 = l_now2 + 1
#               LET l_len = 20
#               LET l_len = l_len - l_byte
#               LET l_bmtstr = ''
#               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#            END IF
#         END FOREACH
#         LET l_bmt06[l_now2] = l_bmtstr
#     
#      FOR g_cnt=1 TO 100
#          LET l_bmc05[g_cnt]=NULL
#      END FOR
#      LET l_now=1
#      IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom != ' '
#      THEN LET l_bmc01 = sr[l_i].phatom
#      ELSE LET l_bmc01 = sr[l_i].bma01
#      END IF
#      FOREACH r600_bmc
#      USING l_bmc01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bma06 
#      INTO l_bmc04,l_bmc05[l_now]
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#          END IF
#          IF l_now > 100 THEN
#              CALL cl_err('','9036',1)
#              CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#              EXIT PROGRAM
#          END IF
#          LET l_now=l_now+1
#      END FOREACH
#      LET l_now=l_now-1
#	    LET l_qpaqty = sr[l_i].bmb06 * tm.a
#
#	    IF tm.vender MATCHES '[Yy]' THEN
#         LET l_cnt  = 0
#          LET l_cnt2 = 0
#          LET l_sql1= "SELECT ",
#                      " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13 ",
#                     " FROM pmh_file ",
#                     " WHERE pmh01 ='", sr[l_i].bmb03,"' "
#          PREPARE r600_p2  FROM l_sql1
#          DECLARE r600_c2 CURSOR FOR r600_p2
# 
#          FOREACH r600_c2 INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
#                                             l_pmh12,l_pmh13    IF SQLCA.sqlcode THEN
#                   EXIT FOREACH
#              END IF
#              EXECUTE insert_prep1 USING sr[l_i].bma01,sr[l_i].bma06,l_pmh02,l_pmh04,l_pmh12,l_pmh13
#          END FOREACH
#      END IF
#      FOR g_cnt = 4 TO l_now2   
#          IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
#            THEN EXIT FOR
#          END IF
#            EXECUTE insert_prep2 USING sr[l_i].bma01,sr[l_i].bma06,l_bmt06[g_cnt]
#      END FOR
#      IF tm.sub_flag ='Y' AND sr[l_i].bmb16 MATCHES '[12SU]' THEN
#         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
#                   " WHERE bmd01='",sr[l_i].bmb03,"' AND bmd04=ima01",
#                   "  AND (bmd08='",sr[l_i].bma01,"' OR bmd08='ALL')"
#         IF tm.effective IS NOT NULL THEN
#            LET l_sql=l_sql CLIPPED,
#                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
#                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
#         END IF
#         PREPARE r600_sub_p FROM l_sql
#         DECLARE r600_sub_c CURSOR FOR r600_sub_p
#         FOREACH r600_sub_c INTO l_bmd.*, l_ima02, l_ima021
#         EXECUTE insert_prep3 USING sr[l_i].bma01,sr[l_i].bma06,l_ima02,l_ima021,l_bmd.bmb04,l_bmd.bmd05,
#            	                      l_bmd.bmd06,l_bmd.bmd07
#         END FOREACH
#      END IF
#
#      IF l_now >= 1 THEN
#            FOR g_cnt = 1 TO l_now STEP 2
#             EXECUTE insert_prep4 USING  sr[l_i].bma01,sr[l_i].bma06,l_bmc05[g_cnt],l_bmc05[g_cnt+1] 
#            END FOR
#      END IF
# 
#     EXECUTE insert_prep USING  l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima15,l_ima37,
#	     	                        l_ima55,l_ima63,l_imz02,
#	                              l_ver,l_qpaqty,sr[l_i].bma01,sr[l_i].bma02,sr[l_i].bma03,sr[l_i].bma04,sr[l_i].bma06,
#	                              sr[l_i].phatom,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bmb05,sr[l_i].bmb08,
#	                              sr[l_i].bmb09,sr[l_i].bmb10,sr[l_i].bmb11,sr[l_i].bmb14,sr[l_i].bmb15,sr[l_i].bmb16,
#                                      sr[l_i].bmb17,
#	                              sr[l_i].bmb18,sr[l_i].bmb23,sr[l_i].ima02,sr[l_i].ima021,sr[l_i].ima08,sr[l_i].ima15,
#	                              sr[l_i].ima37,l_bmt06[1],l_bmt06[2],l_bmt06[3],order1
#
##         OUTPUT TO REPORT r600_rep(sr[l_i].*)
##No.FUN-7C0066---End
#    END FOR
#END FUNCTION
##No.FUN-7C0066---End
#
#No.FUN-7C0066---End
#REPORT r600_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
#          sr  RECORD
#              order1  LIKE bmb_file.bmb03,  #No.FUN-680096 VARCHAR(20)
#              feature LIKE cre_file.cre08,  #No.FUN-680096 VARCHAR((10)
#              ima06 LIKE ima_file.ima06,    #分群碼
#              bma01 LIKE bma_file.bma01,    #主件料件
#              bma06 LIKE bma_file.bma06,    #FUN-550095 add
#              bma02 LIKE bma_file.bma02,    #工程變異單號
#              bma03 LIKE bma_file.bma03,    #工程變異日期
#              bma04 LIKE bma_file.bma04,    #組合模組參考
#              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
#              bmb16 LIKE bmb_file.bmb16,    #替代特性
#              bmb03 LIKE bmb_file.bmb03,    #元件料號
#              ima02 LIKE ima_file.ima02,    #品名規格
#              ima021 LIKE ima_file.ima02,    #品名規格
#              ima05 LIKE ima_file.ima05,    #版本
#              ima08 LIKE ima_file.ima08,    #來源
#              ima15 LIKE ima_file.ima15,    #保稅否
#              ima37 LIKE ima_file.ima37,    #補貨
#              bmb23 LIKE bmb_file.bmb23,    #選中率
#              bmb02 LIKE bmb_file.bmb02,    #項次
#              bmb06 LIKE bmb_file.bmb06,    #QPA
#              bmb08 LIKE bmb_file.bmb08,    #損耗率%
#              bmb10 LIKE bmb_file.bmb10,    #發料單位
#              bmb18 LIKE bmb_file.bmb18,    #投料時距
#              bmb09 LIKE bmb_file.bmb09,    #製程序號
#              bmb04 LIKE bmb_file.bmb04,    #有效日期
#              bmb05 LIKE bmb_file.bmb05,    #失效日期
#              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
#              bmb17 LIKE bmb_file.bmb17,    #Feature
#              bmb11 LIKE bmb_file.bmb11,    #工程圖號
#              bmb13 LIKE bmb_file.bmb13,    #插件位置
#              phatom LIKE ima_file.ima01
#          END RECORD,
#          l_sql	  LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
#          l_bmd   RECORD LIKE bmd_file.*,
#          l_ima02 LIKE ima_file.ima02,    #品名規格
#          l_ima021 LIKE ima_file.ima02,    #品名規格
#          l_ima05 LIKE ima_file.ima05,    #版本
#          l_ima06 LIKE ima_file.ima06,    #分群碼
#          l_ima08 LIKE ima_file.ima08,    #來源
#          l_ima37 LIKE ima_file.ima37,    #補貨
#          l_ima63 LIKE ima_file.ima63,    #發料單位
#          l_ima55 LIKE ima_file.ima55,    #生產單位
#          l_imz02 LIKE imz_file.imz02,    #說明內容
#          l_bmt01 LIKE bmt_file.bmt01,
#          l_bmt05 LIKE bmt_file.bmt05,
#          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  #No.FUN-680096 VARCHAR(20)
#          l_bmc01 LIKE bmc_file.bmc01,
#          l_bmc04 LIKE bmc_file.bmc04,
#          l_bmc05 ARRAY[100] OF LIKE bmc_file.bmc05,  #No.FUN-680096 VARCHAR(10)
#		  l_cnt,l_cnt2 LIKE type_file.num5,      #No.FUN-680096 SMALLINT
#		  l_sql1   LIKE type_file.chr1000,       #No.FUN-680096 VARCHAR(1000)
#		  l_sql2   LIKE type_file.chr1000,       #No.FUN-680096 VARCHAR(1000)
#		  l_pmh01  LIKE pmh_file.pmh01,
#		  l_pmh02  LIKE pmh_file.pmh02,
#		  l_pmh03  LIKE pmh_file.pmh03,
#		  l_pmh04  LIKE pmh_file.pmh04,
#		  l_pmh05  LIKE pmh_file.pmh05,
#		  l_pmh12  LIKE pmh_file.pmh12,
#		  l_pmh13  LIKE pmh_file.pmh13,
#          l_ver    LIKE ima_file.ima05,
#	  l_str    LIKE type_file.chr8,          #No.FUN-680096 VARCHAR(8)
#          l_qpaqty   LIKE bmb_file.bmb06,        #FUN-560227
#          l_no           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_byte,l_len   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_bmt06_s      LIKE bmt_file.bmt06,    #No.FUN-680096 VARCHAR(20)
#     
#          l_bmtstr       LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#          l_now,l_now2   LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.bma01,sr.bma06,sr.order1 #FUN-550095 bma06
#  FORMAT
#   PAGE HEADER
#No.FUN-590110 --start
#      #公司名稱
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      CALL s_effver(sr.bma01,tm.effective) RETURNING l_ver
#      PRINT g_x[19] CLIPPED,tm.effective,'  ',
#            g_x[46] CLIPPED,l_ver
 
#      SELECT ima02,ima021,ima06,ima05,ima08,
#             ima37,ima55,ima63,imz02
#        INTO l_ima02,l_ima021,l_ima06,l_ima05,l_ima08,
#             l_ima37,l_ima55,l_ima63,l_imz02
#        FROM ima_file, OUTER imz_file
#       WHERE ima01=sr.bma01 AND ima_file.ima06 = imz_file.imz01
#      IF SQLCA.sqlcode THEN
#         LET l_ima02= ' '  LET l_ima06 = ' ' LET l_ima05 = ' '
#         LET l_ima08= ' '  LET l_ima37 = ' ' LET l_ima55 = ' '
#         LET l_ima63= ' '  LET l_imz02 = ' '
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[20] CLIPPED, l_ima06,' ',l_imz02
#      #TQC-5B0122
#      PRINT COLUMN   1,g_x[32] CLIPPED,tm.a USING '<<<<<',
#            COLUMN  31,g_x[22] CLIPPED, l_ima05,
#            COLUMN  46,g_x[23] CLIPPED, l_ima08,
#            COLUMN  56,g_x[24] CLIPPED, l_ima37,
#    	    COLUMN  66,g_x[30] CLIPPED, l_ima63,
#	    COLUMN  81,g_x[31] CLIPPED, l_ima55
#------No.TQC-5B0030 modify
#      #TQC-5B0109&051112
#      PRINT COLUMN   1,g_x[21] CLIPPED, sr.bma01,' ',l_ima02
#      #END TQC-5B0109&051112
#      #END TQC-5B0122
#--------end
 
      #FUN-550095 add
#       IF g_sma.sma118 = 'Y' THEN
#          PRINT COLUMN 1,g_x[40] CLIPPED,COLUMN 13,':',sr.bma06
#       ELSE
#          PRINT ''
#       END IF
#      #FUN-550095(end)
#      PRINT g_x[25] CLIPPED, sr.bma04,COLUMN 35,l_ima021
#     #PRINT g_x[11] CLIPPED, sr.bma02
#     #PRINT g_x[12] CLIPPED, sr.bma03
#	  #Assembly 為 Configure,Feature,Family 時,才需show選中率
#      PRINTX name=H1
#            g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],
#            g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],
#            g_x[61],g_x[62],g_x[63],g_x[64],g_x[70],  #TQC-5B0122
#            g_x[65],g_x[66],g_x[67],g_x[68],g_x[69]
#      PRINTX name=H2
#            g_x[71],g_x[72],g_x[73],g_x[74],g_x[75],
#            g_x[76],g_x[77],g_x[78],g_x[79],g_x[80]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#No.FUN-590110 --end
 
#  #BEFORE GROUP OF sr.bma01  #FUN-550095
#   BEFORE GROUP OF sr.bma06  #FUN-550095
#      IF (PAGENO > 1 OR LINENO > 15)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   ON EVERY ROW
#      #-->列印插件位置
#         FOR g_cnt=1 TO 200
#             LET l_bmt06[g_cnt]=NULL
#         END FOR
#         LET l_now2=1
#         LET l_len =20
#         LET l_bmtstr = ''
#         IF sr.phatom IS NOT NULL AND sr.phatom != ' '
#         THEN LET l_bmt01 = sr.phatom
#         ELSE LET l_bmt01 = sr.bma01
#         END IF
#         FOREACH r600_bmt
#         USING l_bmt01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 #FUN-550095 add bma06
#         INTO l_bmt05,l_bmt06_s
#            IF SQLCA.sqlcode THEN
#               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#            END IF
#            IF l_now2 > 200 THEN
#               CALL cl_err('','9036',1)
#               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#               EXIT PROGRAM
#            END IF
#            LET l_byte = length(l_bmt06_s) + 1
#            IF l_len >= l_byte THEN
#               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#               LET l_len = l_len - l_byte
#            ELSE
#               LET l_bmt06[l_now2] = l_bmtstr
#               LET l_now2 = l_now2 + 1
#               LET l_len = 20
#               LET l_len = l_len - l_byte
#               LET l_bmtstr = ''
#               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#            END IF
#         END FOREACH
#         LET l_bmt06[l_now2] = l_bmtstr
      #處理說明的部份, 本程式在此假設其最大的內容不會超過100筆
#      FOR g_cnt=1 TO 100
#          LET l_bmc05[g_cnt]=NULL
#      END FOR
#      LET l_now=1
#      IF sr.phatom IS NOT NULL AND sr.phatom != ' '
#      THEN LET l_bmc01 = sr.phatom
#      ELSE LET l_bmc01 = sr.bma01
#      END IF
#      FOREACH r600_bmc
#      USING l_bmc01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 #FUN-550095 add bma06
#      INTO l_bmc04,l_bmc05[l_now]
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#          END IF
#          IF l_now > 100 THEN
#              CALL cl_err('','9036',1)
#              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#              EXIT PROGRAM
#          END IF
#          LET l_now=l_now+1
#      END FOREACH
#      LET l_now=l_now-1
#	  LET l_qpaqty = sr.bmb06 * tm.a
#No.FUN-590110 --start
#TQC-5B0122
##         #供應廠商資料 -----------------------------------------------
##         IF tm.vender MATCHES '[Yy]' THEN
##            LET l_cnt  = 0
##            LET l_cnt2 = 0
##        LET l_sql1= "SELECT ",
##                    " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13 ",
##                   " FROM pmh_file ",
##                   " WHERE pmh01 ='", sr.bmb03,"' "
##        PREPARE r600_p2  FROM l_sql1
##        DECLARE r600_c2 CURSOR FOR r600_p2
##
##        FOREACH r600_c2 INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
##                                         l_pmh12,l_pmh13
##          IF SQLCA.sqlcode THEN EXIT FOREACH END IF
##          IF l_pmh03 MATCHES '[Yy]' THEN PRINT COLUMN g_c[65],'*';  END IF
##          LET l_cnt = l_cnt + 1
##        END FOREACH
##     END IF
#      PRINTX name=D1
#            COLUMN  g_c[51],sr.bmb02 using'---&',
#            #COLUMN  g_c[52],sr.bmb03[1,20],#FUN-5B0013 mark
#            COLUMN  g_c[52],sr.bmb03 CLIPPED, #FUN-5B0013 add
#            COLUMN  g_c[53],sr.ima02 CLIPPED, #FUN-5B0013 add CLIPPED
#            COLUMN  g_c[54],sr.ima08,
#            COLUMN  g_c[55],sr.ima37,
#            COLUMN  g_c[56],sr.bmb10,
#            COLUMN  g_c[57],l_qpaqty USING '--------&.&&&&&',
#            COLUMN  g_c[58],sr.bmb04,
#            COLUMN  g_c[59],sr.bmb08 USING '--&.&&',
#            COLUMN  g_c[60],sr.bmb23 USING '-&.&&', #選中率
#            COLUMN  g_c[61],sr.bmb09 USING '###&', #FUN-590118
#            COLUMN  g_c[62],sr.ima15 CLIPPED,
#            COLUMN  g_c[63],l_bmt06[1] CLIPPED,
#            COLUMN g_c[64],sr.bmb14,'/',sr.bmb15
 
#     IF NOT cl_null(sr.phatom) THEN
#           PRINTX name=D2 COLUMN g_c[53],g_x[43] CLIPPED,sr.phatom;
#     END IF
#     PRINTX name=D2
#           COLUMN  g_c[72],sr.ima021 CLIPPED, #FUN-5B0013 add CLIPPED
#           COLUMN  g_c[74],sr.bmb05,
#           COLUMN  g_c[75],sr.bmb18 USING '------',
#           COLUMN  g_c[79],l_bmt06[2],
#           COLUMN  g_c[80],sr.bmb16,'/',sr.bmb17
 
          #供應廠商資料 -----------------------------------------------
#      IF tm.vender MATCHES '[Yy]' THEN
#            LET l_cnt  = 0
#            LET l_cnt2 = 0
#            LET l_sql1= "SELECT ",
#                     " pmh01,pmh02,pmh03,pmh04,pmh05,pmh12,pmh13 ",
#                    " FROM pmh_file ",
#                    " WHERE pmh01 ='", sr.bmb03,"' "
#            PREPARE r600_p2  FROM l_sql1
#            DECLARE r600_c2 CURSOR FOR r600_p2
# 
#            FOREACH r600_c2 INTO l_pmh01,l_pmh02,l_pmh03,l_pmh04,l_pmh05,
#                                             l_pmh12,l_pmh13
#              IF SQLCA.sqlcode THEN
#                   EXIT FOREACH
#              END IF
#              IF l_pmh03 MATCHES '[Yy]' THEN
#                    display "l_pmh03-y",PAGENO
#                    PRINTX name=D1 COLUMN g_c[70],'*';
#              END IF
#	                   PRINTX name=D1 COLUMN  g_c[65],l_pmh02,
#                             COLUMN  g_c[66],l_pmh04;
#               CASE l_pmh05
#	              WHEN '0'  LET l_str=g_x[37] CLIPPED
#               WHEN '1'  LET l_str=g_x[38] CLIPPED
#	              WHEN '2'  LET l_str=g_x[39] CLIPPED
#               END CASE
#               PRINTX name=D1
#                     COLUMN g_c[67],l_str,
#                     COLUMN g_c[68],l_pmh13,
#                     COLUMN g_c[69],cl_numfor(l_pmh12,15,g_azi03)
#                    LET l_cnt = l_cnt + 1
#          END FOREACH
#      END IF
 
#END TQC-5B0122
 
#      IF tm.engine='Y' THEN
#          #---->工程圖號
#          IF sr.bmb11 IS NOT NULL AND sr.bmb11 != ' '
#          THEN PRINTX name=D1  COLUMN g_c[52],g_x[45] CLIPPED,sr.bmb11 CLIPPED,   #TQC-760170 modify
#                     COLUMN g_c[63],l_bmt06[3]
#          ELSE PRINTX name=D1                    #MOD-620072 ' '  #TQC-760170 modify
#                     COLUMN g_c[63],l_bmt06[3]  #MOD-620072
#          END IF
#      ELSE
#          IF l_bmt06[3] IS NOT NULL THEN
#              PRINT COLUMN g_c[63],l_bmt06[3]
#          END IF
#      END IF
 
#    #FOR g_cnt = 3 TO l_now2   #TQC-760170 mark
#     FOR g_cnt = 4 TO l_now2   #TQC-760170 modify
#         IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
#            THEN EXIT FOR
#         END IF
#         PRINTX name=D1 COLUMN g_c[63],l_bmt06[g_cnt]   #TQC-760170 modify
#     END FOR
#         IF l_now2 = 0 THEN PRINT ' ' END IF
#      #-->列印取替代料
#      IF tm.sub_flag ='Y' AND sr.bmb16 MATCHES '[12SU]' THEN
#         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
#                   " WHERE bmd01='",sr.bmb03,"' AND bmd04=ima01",
#                   "  AND (bmd08='",sr.bma01,"' OR bmd08='ALL')"
#         IF tm.effective IS NOT NULL THEN
#            LET l_sql=l_sql CLIPPED,
#                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
#                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
#         END IF
#         PREPARE r600_sub_p FROM l_sql
#         DECLARE r600_sub_c CURSOR FOR r600_sub_p
#         FOREACH r600_sub_c INTO l_bmd.*, l_ima02, l_ima021
#            PRINTX name=D1
#                 COLUMN g_c[52], '(',l_bmd.bmd04,')',
#                 COLUMN g_c[53],l_ima02 CLIPPED, #FUN-5B0013 add CLIPPED
#                 #COLUMN g_c[57],l_bmd.bmd07 USING '####&.&&&&&',
#                 COLUMN g_c[57],l_bmd.bmd07 USING '--------&.&&&&&',  #TQC-5B0122
#                 COLUMN g_c[58],l_bmd.bmd05
#            PRINTX name=D2                         #TQC-5B0122
#                 COLUMN g_c[72],l_ima021 CLIPPED, #FUN-5B0013 add CLIPPED
#                 COLUMN g_c[74],l_bmd.bmd06
#         END FOREACH
#      END IF
#     IF l_now2 = 0 THEN PRINT ' ' END IF
#      #列印剩下說明
#          IF l_now >= 1 THEN
#             FOR g_cnt = 1 TO l_now STEP 2
#                 IF g_cnt =1 THEN
#                    PRINT COLUMN 37,g_x[27] clipped; END IF                  #No.TQC-5B0030 modify
#                    PRINT COLUMN 37,l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED  #No.TQC-5B0030 modify
#             END FOR
#      END IF
#           LET l_cnt = l_cnt + 1
#	  SKIP 1 LINE
 
#  #AFTER GROUP OF sr.bma01
#  #   LET g_pageno=0
 
#   ON LAST ROW
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      PRINT ' '
#      PRINT g_x[41] CLIPPED,'  ',g_x[42] CLIPPED
#      PRINT g_dash[1,g_len] CLIPPED
#      IF g_pageno = 0 OR l_last_sw = 'y'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#END REPORT
#Patch....NO.TQC-610035 <001> #
#No.FUN-7C0066---End
