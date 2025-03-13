# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr520.4gl
# Descriptions...: 工單用料模擬數量列印
# Date & Author..: 92/12/09 By Keith
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: NO.FUN-510040 05/02/16 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-550067  05/06/01 By yoyo單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.......... NO.MOD-580298 05/09/02 By Rosayu 1.料號,工單編號,數量 未放大
#                                                   2.在create 之前,要先做 drop 的動作
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0061 05/11/02 By Pengu 1.報表缺品名或規格
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-710080 07/03/23 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-7B0186 07/11/21 By Pengu 列印位參考"是否列印欠料料號"欄位
# Modify.........: No.MOD-810143 08/03/23 By Pengu 在外量,未考慮單位換算率
# Modify.........: No.MOD-840103 08/04/16 By Pengu 不應用工單狀態作控管列印條件，應改用數量作控管
# Modify.........: No.MOD-840492 08/04/25 By douzh 字段類型定義錯誤，導致qty*打印靠右
# Modify.........: No.MOD-880184 08/08/22 By claire 需求量扣除委外代買量(sfa065),調整方式同MRP計算
# Modify.........: No.MOD-890270 08/09/26 By claire ttp04-ttp07欄位重新定義
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-940008 09/05/13 By hongmei 發料改善
# Modify.........: No.FUN-940083 09/05/15 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A40023 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60088 10/06/12 By jan 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-A70034 10/07/19 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:MOD-9C0428 10/11/25 By sabrina 工單欄位曾加開窗
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
# Modify.........: No:TQC-CC0087 12/12/17 By qirl 按鈕灰色，ctrl+g調用
# Modify.........: No:TQC-CC0088 12/12/17 By qirl asf-318報錯的調整
# Modify.........: No:TQC-D40098 13/07/17 By yangtt 料表批號和分派優先順序增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	  	       # Print condition RECORD
#             wc       VARCHAR(600),      # 工單,生產料件,批號,分派順序,開工日範圍 #TQC-630166
              wc       STRING,         # 工單,生產料件,批號,分派順序,開工日範圍 #TQC-630166
              a        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否包含未備料之工單
              b        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否僅列印不足之料件
              more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件(Y|N)
           END RECORD,
       g_sql           STRING,  #No.FUN-580092 HCN
       g_utime         LIKE type_file.chr8,     #No.FUN-680121 VARCHAR(8)# user run time
       g_sfb01         LIKE sfb_file.sfb01,     #工單號碼
       g_sfb08         LIKE sfb_file.sfb08,     #工單數量
       g_sfb13         LIKE sfb_file.sfb13      #預計開工日期
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680121 SMALLINT
#str FUN-710080 add
DEFINE l_table     STRING
DEFINE g_str       STRING
#end FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ttp01.sfb_file.sfb05,",
               "ttp02.oea_file.oea01,",
               "ttp03.type_file.dat,",
               "ttp04.sfb_file.sfb08,",
               "ttp05.sfb_file.sfb08,",
               "ttp06.sfb_file.sfb08,",
               "ttp07.sfb_file.sfb08,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
#              "qty4.sfa_file.sfa03,",           #No.MOD-840492
               "qty4.sfa_file.sfa04,",           #No.MOD-840492
#              "ima261.ima_file.ima261,",
#              "ima262.ima_file.ima262,",
               "unavl_stk.type_file.num15_3,",   #NO.FUN-A20044  #NO.FUN-A40023
               "avl_stk.type_file.num15_3,",     #NO.FUN-A20044
#              "qty1.sfa_file.sfa03,",           #No.MOD-840492
#              "qty2.sfa_file.sfa03,",           #No.MOD-840492
#              "qty3.sfa_file.sfa03,",           #No.MOD-840492
               "qty1.sfa_file.sfa04,",           #No.MOD-840492
               "qty2.sfa_file.sfa04,",           #No.MOD-840492
               "qty3.sfa_file.sfa04,",           #No.MOD-840492
               "sfb05.sfb_file.sfb05,",
               "l_sfb04.sfb_file.sfb04,",
               "l_sfb20.sfb_file.sfb20,",
               "l_sfb21.sfb_file.sfb21,",
               "l_sfb14.sfb_file.sfb14,",
               "l_sfb15.sfb_file.sfb15,",
               "l_sfb16.sfb_file.sfb16,",
               "l_sfb05.sfb_file.sfb05,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "l_ima05.ima_file.ima05,",
               "l_ima08.ima_file.ima08,",
               "l_ima55.ima_file.ima55,",
               "l_sfb08.sfb_file.sfb08,",
               "l_min.sfb_file.sfb09"
 
   LET l_table = cl_prt_temptable('asfr520',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-710080 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)  		        #Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)   #TQC-610080 傳值順序順推
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   LET g_utime=TIME
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      CALL r520_tm()                            # Input print condition
   ELSE
      CALL asfr520()                            # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r520_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_flag        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          p_row,p_col   LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r520_w AT p_row,p_col WITH FORM "asf/42f/asfr520"
################################################################################
# START genero shell script ADD
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a='N'
   LET tm.b='Y'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb85,sfb40,sfb13
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP    #FUN-4B0043
        #-------------No:MOD-9C0428 add
         IF INFIELD(sfb01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form     = "q_sfb01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb01
            NEXT FIELD sfb01
         END IF
        #-------------No:MOD-9C0428 end
        #No.TQC-D40098 ---add--- str
         IF INFIELD(sfb85) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb85_1"
            LET g_qryparam.state = 'c'
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb85
            NEXT FIELD sfb85
         END IF
         IF INFIELD(sfb40) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb40"
            LET g_qryparam.state = 'c'
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb40
            NEXT FIELD sfb40
         END IF
        #No.TQC-D40098 ---add--- end

         IF INFIELD(sfb05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb05
            NEXT FIELD sfb05
         END IF
 
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 

#---TQC-CC0087--add--star--
      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about
         CALL cl_about()
#---TQC-CC0087--add--end---

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
      CLOSE WINDOW asfr520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.a,tm.b,tm.more   # Condition
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a = ' ' OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b = ' ' OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD more
	 IF tm.more IS NULL OR tm.more = ' ' OR tm.more NOT MATCHES '[YN]' THEN
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
#     ON ACTION CONTROLG 
#        CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 

#---TQC-CC0087--add--star--
      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about
         CALL cl_about()
#---TQC-CC0087--add--end---
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='asfr520'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asfr520','9031',1)   
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
                         " '",tm.wc CLIPPED,"'"  ,              #TQC-610080 
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #TQC-610080
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr520',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr520()
   ERROR ""
END WHILE
   CLOSE WINDOW r520_w
END FUNCTION
 
FUNCTION asfr520()
   DEFINE l_name	LIKE type_file.chr20,           #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0090
#         l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #TQC-630166        #No.FUN-680121 VARCHAR(1100)
          l_sql 	STRING,	                        # RDSQL STATEMENT  #TQC-630166
          l_chr		LIKE type_file.chr1,      #No.FUN-680121 VARCHAR(1)
          l_cnt         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_n           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#         l_sw          LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)# 判斷資料是工單或需求檔而來
          l_sw          LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_qty         LIKE sfb_file.sfb08,
          l_rpc01       LIKE rpc_file.rpc01,  #料件編號
          l_rpc12       LIKE rpc_file.rpc12,  #需求日期
          l_rpc13       LIKE rpc_file.rpc13,  #需求數量
          sr1           RECORD
                           sfb01 LIKE sfb_file.sfb01,  #工單編號
                           sfb02 LIKE sfb_file.sfb02,  #工單型態
                           sfb04 LIKE sfb_file.sfb04,  #工單狀態
                           sfb05 LIKE sfb_file.sfb05,  #料件編號
                           sfb08 LIKE sfb_file.sfb08,  #生產數量
                           sfb09 LIKE sfb_file.sfb09,  #完工數量
                           sfb10 LIKE sfb_file.sfb10,  #再加工數量
                           sfb11 LIKE sfb_file.sfb11,  #F.Q.C數量
                           sfb12 LIKE sfb_file.sfb12,  #報廢數量
                           sfb13 LIKE sfb_file.sfb13,  #開始生產日期
                           sfb23 LIKE sfb_file.sfb23   #備料檔產生否
                        END RECORD ,
          sr            RECORD
                           ttp01 LIKE sfb_file.sfb05,          #No.FUN-680121 VARCHAR(20)#料件編號
#                          ttp02 LIKE sfb_file.sfb01,          #No.FUN-680121 VARCHAR(10)#工單編號
                           ttp02 LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#No.FUN-55006
                           ttp03 LIKE type_file.dat,           #No.FUN-680121 DATE#預計工單日
                           ttp04 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#工單數量
                           ttp05 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#需求數量
                           ttp06 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#未供給需求數量前之可用
                           ttp07 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#預期缺料量
                           ima02 LIKE ima_file.ima02,  #品名規格
                           ima021 LIKE ima_file.ima021,  #規格
                           ima25 LIKE ima_file.ima25,  #庫存單位
                           #ima84 LIKE ima_file.ima84,  #OM備置量
#                          qty4   LIKE sfa_file.sfa03, #訂單備置量      #No.MOD-840492    
                           qty4   LIKE sfa_file.sfa04, #訂單備置量      #No.MOD-840492 
#                          ima261 LIKE ima_file.ima261,  #庫存不可用量
#                          ima262 LIKE ima_file.ima262,  #庫存可用量
                           unavl_stk  LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                           avl_stk    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044 
                         #No.B017 010326 by plum ima76,78,79已無使用
                         # ima76 LIKE ima_file.ima76,  #在外量
                         # ima78 LIKE ima_file.ima78,  #在驗量
                         ##ima79 LIKE ima_file.ima79,  #缺料量  #TQC-650066 mark
#                          qty1  LIKE sfa_file.sfa03,  #在外量          #No.MOD-840492 
#                          qty2  LIKE sfa_file.sfa03,  #在驗量          #No.MOD-840492 
#                          qty3  LIKE sfa_file.sfa03,  #缺料量          #No.MOD-840492 
                           qty1  LIKE sfa_file.sfa04,  #在外量          #No.MOD-840492 
                           qty2  LIKE sfa_file.sfa04,  #在驗量          #No.MOD-840492 
                           qty3  LIKE sfa_file.sfa04,  #缺料量          #No.MOD-840492 
                         #No.B017..end
                           sfb05 LIKE sfb_file.sfb05
                        END RECORD ,
#         l_qty1        LIKE sfa_file.sfa03,       #在外量1             #No.MOD-840492  
#         l_qty2        LIKE sfa_file.sfa03,       #在外量2             #No.MOD-840492 
          l_qty1        LIKE sfa_file.sfa04,       #在外量1             #No.MOD-840492 
          l_qty2        LIKE sfa_file.sfa04,       #在外量2             #No.MOD-840492  
          l_sfb11       LIKE sfb_file.sfb11,       #在驗量1
#         up_qty        LIKE ima_file.ima262,      #上筆可用數量
#         up_need       LIKE ima_file.ima262,      #上筆缺料數量
          up_qty        LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044 
          up_need       LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          l_sfb06       LIKE sfb_file.sfb06,
          l_sfb071      LIKE sfb_file.sfb071,
          l_minopseq    LIKE ecb_file.ecb03,
          l_ima01       LIKE ima_file.ima01        #上筆料件編號
   DEFINE l_ima910      LIKE ima_file.ima910   #FUN-550112
   #str FUN-710080 add
   DEFINE l_sfb05       LIKE sfb_file.sfb05,       #料件編號
          l_sfb04       LIKE sfb_file.sfb04,       #工單狀態
          l_sfb20       LIKE sfb_file.sfb20,       #MRP/MPS需求日期
          l_sfb21       LIKE sfb_file.sfb21,       #MRP/MPS需求日期
          l_sfb14       LIKE sfb_file.sfb14,       #開始生產日期
          l_sfb15       LIKE sfb_file.sfb15,       #結束生產日期
          l_sfb16       LIKE sfb_file.sfb16,       #結束生產日期
          l_sfb08       LIKE sfb_file.sfb08,       #生產數量
          l_ima02       LIKE ima_file.ima02,       #料件編號
          l_ima021      LIKE ima_file.ima021,      #料件編號
          l_ima05       LIKE ima_file.ima05,       #版本
          l_ima08       LIKE ima_file.ima08,       #來源碼
          l_ima55       LIKE ima_file.ima55,       #生產單位
          l_num         LIKE sfb_file.sfb09,
          l_min         LIKE sfb_file.sfb09
   #end FUN-710080 add
   DEFINE lr_sfa RECORD LIKE sfa_file.*            #No.FUN-940008 add
   DEFINE l_short_qty   LIKE sfa_file.sfa07        #No.FUN-940008 add
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044    
   #suncx add begin------------
   DEFINE l_str1       DATETIME YEAR TO SECOND 
   DEFINE l_str2       DATETIME YEAR TO SECOND
   DEFINE l_end1       DATETIME YEAR TO SECOND 
   DEFINE l_end2       DATETIME YEAR TO SECOND
   DEFINE l_sum_time    INTEGER
   DEFINE l_num1        INTEGER
   DEFINE l_num2        INTEGER
   #suncx add end--------------
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-710080 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
   DROP TABLE tmp_file; #MOD-580298 add
   #No.FUN-680121-BEGIN
   CREATE TEMP TABLE tmp_file(
      tmp01     LIKE oea_file.oea01,
      tmp02     LIKE type_file.num5,  
      tmp03     LIKE type_file.chr1000,
#     tmp04     LIKE ima_file.ima26,
#     tmp05     LIKE ima_file.ima26,
#     tmp06     LIKE ima_file.ima26,
#     tmp061    LIKE ima_file.ima26,
#     tmp062    LIKE ima_file.ima26,
#     tmp07     LIKE ima_file.ima26,
      tmp04     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      tmp05     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      tmp06     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      tmp061    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      tmp062    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      tmp07     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      tmp08     LIKE type_file.num5,  
      tmp09     LIKE type_file.num5,  
      tmp10     LIKE aab_file.aab02,
      tmp11     LIKE type_file.chr1,  
      tmp12     LIKE ade_file.ade04,
      tmp13     LIKE ade_file.ade34,
      tmp14     LIKE ade_file.ade04,
      tmp15     LIKE ade_file.ade34,
      tmp16     LIKE csb_file.csb05,
      tmp161    LIKE csb_file.csb05,
      tmp25     LIKE bed_file.bed07);
   CREATE INDEX tmp_01 ON tmp_file (tmp01,tmp03,tmp08,tmp12);
   DELETE FROM tmp_file WHERE 1=1
   #No.FUN-680121-END
 
   DROP TABLE ttp_file; #MOD-580298 add
   #No.FUN-680121-BEGIN 
   CREATE TEMP TABLE ttp_file(
      ttp01 LIKE type_file.chr1000,
      ttp02 LIKE oea_file.oea01,
      ttp03 LIKE type_file.dat,   
      ttp04 LIKE sfb_file.sfb08,
      ttp05 LIKE sfb_file.sfb08,
      ttp06 LIKE sfb_file.sfb08,
      ttp07 LIKE sfb_file.sfb08);  #MOD-890270 modify
     #MOD-890270-begin-mark
      #ttp04 LIKE ade_file.ade04,
      #ttp05 LIKE ade_file.ade04,
      #ttp06 LIKE ade_file.ade04,
      #ttp07 LIKE ade_file.ade04);
     #MOD-890270-end-mark
   CREATE unique index ttp_01 ON ttp_file(ttp02,ttp01);
   DELETE FROM ttp_file WHERE 1=1
   #No.FUN-680121-END   
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #       LET tm.wc= tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #       LET tm.wc= tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc= tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
   IF tm.a = "Y" THEN
      LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,",
                  "       sfb09,sfb10,sfb11,sfb12,sfb13,sfb23 ",
                  "  FROM sfb_file ",
                  " WHERE sfbacti='Y' AND sfb87!='X' "
   ELSE
      LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,",
                  "       sfb09,sfb10,sfb11,sfb12,sfb13,sfb23 ",
                  "  FROM sfb_file ",
                  " WHERE sfbacti='Y' AND sfb23 = 'Y' AND sfb87!='X'"
   END IF
  #-------------No.MOD-840103 mofify
  #LET l_sql=l_sql CLIPPED," AND sfb04 IN ('1','2','3','4','5')",
   LET l_sql=l_sql CLIPPED," AND sfb04 != '8' ",
  #-------------No.MOD-840103 end
                           " AND ",tm.wc CLIPPED
   LET l_sql=l_sql CLIPPED," ORDER BY sfb08 "
   PREPARE r520_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE r520_curs1 CURSOR FOR r520_prepare1
 
   LET g_cnt=0
   FOREACH r520_curs1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_sfb01=sr1.sfb01
      #若為在製工單,則工單數量=生產數量-已完工數量-再加工數量-F.Q.C數量
      #                        -報廢數量
     #-----------------No.MOD-840103 modify
     #IF sr1.sfb04 MATCHES '[45]' THEN
      IF sr1.sfb04 NOT MATCHES '[123]' THEN
     #-----------------No.MOD-840103 end
         LET g_sfb08=sr1.sfb08-sr1.sfb09-sr1.sfb10-sr1.sfb11-sr1.sfb12
      ELSE
         LET g_sfb08=sr1.sfb08
      END IF
      #生產數量<=0時,不考慮
      IF g_sfb08 <=0 THEN CONTINUE FOREACH END IF
      LET g_cnt=1
      LET g_sfb13=sr1.sfb13
      #工單性質為'5'再加工及'11'拆件式工的工單,無須至備料檔或產品結構
      #檔中去找其用料,只需將該工單的品號及其工單數量寫入暫存檔中即可.
      IF sr1.sfb02=5 OR sr1.sfb02=11 THEN
         #需求數量 <=0 時不考慮
         LET l_qty=sr1.sfb08-sr1.sfb09-sr1.sfb10-sr1.sfb11-sr1.sfb12
         IF l_qty > 0 THEN
            #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
            INSERT INTO ttp_file
             VALUES(sr1.sfb05,sr1.sfb01,sr1.sfb13,g_sfb08,l_qty,0,0)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(sr1.sfb01,SQLCA.sqlcode,1)   #No.FUN-660128
               CALL cl_err3("ins","ttp_file",sr1.sfb05,"",SQLCA.sqlcode,"","",1)   #No.FUN-660128
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
      #  END FOREACH
         END IF
         CONTINUE FOREACH
      END IF
      #若已產生備料檔,則去抓取[備料檔]資料,否則從產品結構中取得用料資料
      IF sr1.sfb23='Y' THEN
         CALL r520_sfa(sr1.sfb01)
      ELSE
         #FUN-550112
         LET l_ima910=''
         SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr1.sfb05
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         #--
         IF tm.a = "Y" THEN
            CALL r520_cralc_bom(0,sr1.sfb05,l_ima910,g_sfb08)  #FUN-550112  #No.MOD-7B0186 modify
         END IF
      END IF
   END FOREACH
   #若無合乎條件之工單,則列印 "無合乎條件的工單" 之訊息
   IF g_cnt=0 THEN
      CALL cl_err('','asf-318',3)
#----TQC-CC0088---mark--star--
#     CLOSE WINDOW r520_w
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#     EXIT PROGRAM
#----TQC-CC0088---mark--end--
   END IF
 
   #包含需求資料 -----------------
  #IF tm.a='Y' THEN
  #   LET l_sql="SELECT rpc01,rpc12,(rpc13-rpc131)  ",
  #             " FROM rpc_file ",
  ##            " WHERE rpc11 > 2 AND rpc12 <='",tm.e_date,"' ",
  #             " WHERE rpc11 > 2 ",
  #             " AND rpc13>rpc131  AND rpcacti='Y' "
  #
  #   PREPARE r520_prepare2 FROM l_sql
  #   IF SQLCA.sqlcode != 0 THEN 
  #      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
  #      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
  #      EXIT PROGRAM 
  #   END IF
  #   DECLARE r520_curs2 CURSOR FOR r520_prepare2
  #
  #   FOREACH r520_curs2 INTO l_rpc01,l_rpc12,l_rpc13
  #      IF SQLCA.sqlcode != 0 THEN 
  #         CALL cl_err('foreach:',SQLCA.sqlcode,1)
  #         EXIT FOREACH 
  #      END IF
  #      #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
  #      INSERT INTO ttp_file
  #        VALUES(l_rpc01,' ',l_rpc12,0,l_rpc13,-1,0)
  #      IF SQLCA.sqlcode THEN
# #         CALL cl_err(l_rpc01,SQLCA.sqlcode,1)   #No.FUN-660128
  #         CALL cl_err3("ins","ttp_file",l_rpc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660128
  #         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
  #         EXIT PROGRAM
  #      END IF
  #   END FOREACH
  #END IF
 
   # order by 料件編號+預計開工日+工單編號
   LET l_sql=" SELECT ttp01,ttp02,ttp03,ttp04,ttp05,ttp06,ttp07,",
           # " ima02,ima25,ima84,ima261,ima262,",
#            " ima02,ima021,ima25,0,ima261,ima262, ", #NO.FUN-A20044 
             " ima02,ima021,ima25,0,0,0, ",           #NO.FUN-A20044 
           ##" (ima75+ima76+ima77),ima78,ima79,sfb05 ",  #TQC-650066 mark
             " 0,0,0,sfb05 ",
             " FROM ttp_file,ima_file,sfb_file ",
             " WHERE ttp01=ima01 AND ttp02 = sfb01 AND sfb87!='X' ",
             " ORDER BY ttp01,ttp04,ttp02,ttp03 "
 
   PREPARE r520_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare3:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   DECLARE r520_curs3 CURSOR FOR r520_prepare3
 
   LET g_pageno = 0
   LET up_qty=0        #上筆可用數量
   LET up_need=0       #上筆缺料數量
   LET l_ima01=' '
   LET l_n=1
   LET l_str1 = CURRENT YEAR TO SECOND #suncx add
   LET l_num1 = 0      #suncx add
   LET l_num2 = 0      #suncx add
   LET l_sum_time =0   #suncx add
   FOREACH r520_curs3 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL s_getstock(sr.ttp01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
      LET  sr.unavl_stk = l_n2   #NO.FUN-A20044 
      LET  sr.avl_stk = l_n3     #NO.FUN-A20044 
      #No.B017 010326 by plum 參照aimq102語法
      #sr.qty4:訂單備置量
     #SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO sr.qty4
      SELECT SUM(oeb905*oeb05_fac) INTO sr.qty4       #no.7182
        FROM oeb_file, oea_file, occ_file
       WHERE oeb04 = sr.ttp01
         AND oeb01 = oea01 AND oea00<> '0' AND oeb19 = 'Y'
         AND oeb70 = 'N' AND oeb12 > oeb24 AND oea03=occ01
         AND oeaconf != 'X' #01/08/08 mandy
      IF cl_null(sr.qty4)  THEN LET sr.qty4=0 END IF
 
      #sr.qty1:在外量
      #--->qty1工單在製量
      SELECT SUM(sfb08-sfb09-sfb11) INTO l_qty1 FROM sfb_file
       WHERE sfb05 = sr.ttp01 AND sfb04 < '8'
        #AND sfb02 NOT IN ('7','11')   #plum
         AND sfb02 NOT IN ('11')
         AND sfb08 > (sfb09+sfb11) AND sfb87!='X'
      IF l_qty1 IS NULL THEN LET l_qty1 = 0 END IF
      #--->qty2在外量
     #SELECT SUM(pmn20-pmn50) INTO l_qty2 FROM pmn_file   #plum
      #WHERE pmn04 = sr.ttp01 AND pmn20 > pmn50
     #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO l_qty2 FROM pmn_file  #No.MOD-810143 modify #FUN-940083
      SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_qty2 FROM pmn_file  #FUN-940083      
#      WHERE pmn04 = sr.ttp01 AND pmn20 > (pmn50-pmn55)        #No.FUN-9A0068 mark
       WHERE pmn04 = sr.ttp01 AND pmn20 > (pmn50-pmn55-pmn58)  #No.FUN-9A0068
         AND pmn16 <='2'
         AND pmn011 !='SUB'
      IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
 
      LET sr.qty1=l_qty1+l_qty2
 
      #sr.qty2:在驗量: IQC+FQC
      #------IQC在驗量
      SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO sr.qty2
        FROM rva_file,rvb_file,pmn_file
       WHERE rvb05 = sr.ttp01
         AND rvb01 = rva01
         AND rvaconf !='X'
         AND rvb04 = pmn01
         AND rvb03 = pmn02
         AND rvb07 > (rvb29+rvb30)
      IF sr.qty2 IS NULL THEN LET sr.qty2 = 0 END IF
 
      #------FQC在驗量
      SELECT SUM(sfb11) INTO l_sfb11 FROM sfb_file
       WHERE sfb05 = sr.ttp01
         AND sfb02 <> '7'    #委外工單
         AND sfb04 < '8' AND sfb87!='X'
      IF l_sfb11 IS NULL THEN LET l_sfb11 = 0 END IF
      LET sr.qty2 = sr.qty2 + l_sfb11
 
      #...缺料量
     #plum
     #SELECT SUM(sfa07) INTO sr.qty3 FROM sfa_file,sfb_file
    #No.FUN-940008---Begin  
    # SELECT SUM(sfa07*sfa13) INTO sr.qty3 FROM sfa_file,sfb_file
    #  WHERE sfa03 = sr.ttp01
    #    AND sfb01 = sfa01
    #    AND sfb04 !='8' AND sfa07 > 0 AND sfb87!='X'
      #欠料量計算
      IF cl_null(sr.qty3) THEN LET sr.qty3=0 END IF
      LET l_sql = "SELECT sfa_file.*",
                  "  FROM sfb_file,sfa_file",
                  " WHERE sfa03 = '",sr.ttp01,"'",
                  "   AND sfb01 = sfa01 ",
                  "   AND sfb04 !='8'",
                  "   AND sfb87!='X'"
      PREPARE r520_sum_pre FROM l_sql
      DECLARE r520_sum CURSOR FOR r520_sum_pre
      LET l_str2 = CURRENT YEAR TO SECOND #suncx add
      FOREACH r520_sum INTO lr_sfa.*
         CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                         lr_sfa.sfa12,lr_sfa.sfa27,lr_sfa.sfa012,lr_sfa.sfa013)     #FUN-A60088 add sfa012,sfa013
              RETURNING l_short_qty
         IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
         IF l_short_qty > 0 THEN
            LET sr.qty3 = sr.qty3+(l_short_qty*lr_sfa.sfa13) 
         END IF
         LET l_num2 = l_num2+1     #suncx add
      END FOREACH
      LET l_end2 = CURRENT YEAR TO SECOND #suncx add
      LET l_sum_time = l_sum_time + (l_end2-l_str2) #suncx add
    #FUN-940008---End
      #No.B017 ..end
#     IF sr.ima262 IS NULL THEN LET sr.ima262=0 END IF          #NO.FUN-A20044 
      IF sr.avl_stk IS NULL THEN LET sr.avl_stk = 0 END IF      #NO.FUN-A20044 
      IF sr.unavl_stk IS NULL THEN LET sr.unavl_stk = 0 END IF  #NO.FUN-A20044 
    ##IF sr.ima79  IS NULL THEN LET sr.ima79 =0 END IF   #TQC-650066 mark
      IF sr.ttp05  IS NULL THEN LET sr.ttp05 =0 END IF
      LET l_sw=sr.ttp06     # 判斷資料是工單(0)或需求檔(-1)而來
      IF l_ima01 != sr.ttp01 THEN     #料件編號不同時
         #最初之上筆可用數量=可用庫存量, 最初之上筆缺料量=料件主檔之缺料量
         #第一筆之可用數量=上筆可用數量-上筆缺料量
       # #LET sr.ttp06=sr.ima262-sr.ima79      #TQC-650066 mark
#        LET sr.ttp06=sr.ima262-sr.qty3   #NO.FUN-A20044 
         LET sr.ttp06=sr.avl_stk-sr.qty3  #NO.FUN-A20044 
         IF sr.ttp06 < 0 THEN  #如果庫存可用量-缺料量<0,initial ttp06 = 0
            LET sr.ttp06=0
         END IF
         LET l_ima01=sr.ttp01
      ELSE
         #第二筆之可用數量＝第一筆之可用數量－第一筆需求數量,以此類推
         LET sr.ttp06=up_qty-up_need
         IF sr.ttp06 < 0 THEN LET sr.ttp06=0 END IF
      END IF
      #預期缺料量=需求數量-可用數量 (小於0,以0計)
      LET sr.ttp07=sr.ttp05-sr.ttp06
      IF sr.ttp07 < 0 THEN LET sr.ttp07=0 END IF
      LET up_qty=sr.ttp06
      LET up_need=sr.ttp05
 
      #str FUN-710080 add
      #抓取[工單檔]、[料件主檔] 相關資料
      SELECT sfb04,sfb20,sfb21,sfb14,sfb15,sfb16,sfb05,
             ima02,ima021,ima05,ima08,ima55,sfb08
        INTO l_sfb04,l_sfb20,l_sfb21,l_sfb14,l_sfb15,l_sfb16,
             l_sfb05,l_ima02,l_ima021,l_ima05,l_ima08,l_ima55,l_sfb08
        FROM sfb_file,OUTER ima_file
       WHERE  sfb_file.sfb05=ima_file.ima01  AND sfb01=sr.ttp02 AND sfb87!='X'
 
      #計算可完成套數, 最多可完成套數:Min(可用數量/需求數量)*工單數量
      LET l_num=(sr.ttp06/sr.ttp05)*sr.ttp04
      IF l_n=1 THEN
         LET l_min=l_num
      ELSE
         IF l_min > l_num THEN
            LET l_min=l_num     #最多可完成套數
         END IF
      END IF
      LET l_n=l_n+1
      #end FUN-710080 add
 
      IF l_sw=0 THEN
         #str FUN-710080 add
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         EXECUTE insert_prep USING
            sr.ttp01,sr.ttp02,sr.ttp03,sr.ttp04,sr.ttp05,
            sr.ttp06,sr.ttp07,sr.ima02,sr.ima021,sr.ima25,
#           sr.qty4,sr.ima261,sr.ima262,sr.qty1,sr.qty2,
            sr.qty4,sr.unavl_stk,sr.avl_stk,sr.qty1,sr.qty2, 
            sr.qty3,sr.sfb05,l_sfb04,l_sfb20,l_sfb21,
            l_sfb14,l_sfb15,l_sfb16,l_sfb05,l_ima02,
            l_ima021,l_ima05,l_ima08,l_ima55,l_sfb08,
            l_min
         #------------------------------ CR (3) ------------------------------#
         #end FUN-710080 add
      END IF
      LET l_num1 = l_num1+1     #suncx add
   END FOREACH
   LET l_end1 = CURRENT YEAR TO SECOND        #suncx add
   DISPLAY "r520_curs3 Time:",l_end1-l_str1   #suncx add
   DISPLAY "r520_sum Time:",l_sum_time   #suncx add
   DISPLAY "r520_curs3 Num:",l_num1    #suncx add
   DISPLAY "r520_sum Num:",l_num2      #suncx add 
 
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85,sfb40,sfb13')
           RETURNING tm.wc
     #LET g_str = tm.wc                                    #No.MOD-7B0186 mark
   END IF
   LET g_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.b   #No.MOD-7B0186 add
   
   CALL cl_prt_cs3('asfr520','asfr520',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
#抓取用料檔資料 -----------------------------------------
FUNCTION r520_sfa(p_sfb01)
DEFINE
     p_sfb01   LIKE sfb_file.sfb01,     #工單編號
     l_sfa03   LIKE sfa_file.sfa03,     #料件編號
     l_sfa09   LIKE sfa_file.sfa09,     #前置時間調整天
     l_sfa13   LIKE sfa_file.sfa13,     #發料單位/庫存單位轉換率
     l_sfa05   LIKE sfa_file.sfa05,     #應發數量-已發數量
     l_qty     LIKE sfa_file.sfa05,     #(應發數量-已發數量)*轉換率
     l_cnt     LIKE type_file.num5,         #No.FUN-680121 SMALLINT
     l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
#    LET l_sql = "SELECT  sfa03,(sfa05-sfa06-sfa065),sfa13,sfa09 ",  #MOD-880184 add sfa065   #FUN-A60088 mark
     LET l_sql = "SELECT  sfa03,SUM(sfa05-sfa06-sfa065),sfa13,sfa09 ",   #FUN-A60088
                 "  FROM sfa_file,sfb_file ",
                 " WHERE sfa01='",p_sfb01,"' AND sfa01 = sfb01",
                 "  AND (sfa05-sfa06-sfa065) > 0 AND sfaacti='Y' AND sfb87 !='X'", #MOD-880184 add sfa065
                 " GROUP BY sfa03,sfa13,sfa09"                                     #FUN-A60088  
     LET l_sql=l_sql CLIPPED," ORDER BY sfa03 "
     PREPARE r520_sfap1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_sfap1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r520_sfa1 CURSOR FOR r520_sfap1
     FOREACH r520_sfa1 INTO l_sfa03,l_sfa05,l_sfa13,l_sfa09
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #料件之投料時間(為工單的預計開工日+前置時間調整sfa09)若大於截止
       #日期,則該用料不予考慮。
       IF l_sfa09 IS NULL THEN LET l_sfa09=0 END IF
       MESSAGE p_sfb01 CLIPPED,'-',l_sfa03 CLIPPED
       CALL ui.Interface.refresh()
       #乘以單位換算率
       IF l_sfa13 IS NULL THEN LET l_sfa13=1 END IF
       LET l_qty=l_sfa05*l_sfa13   #需求數量
       #需求數量>0時才考慮
       IF l_qty > 0 THEN
           #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
           #insert 至暫存檔
#######
              INSERT INTO ttp_file
                VALUES(l_sfa03,p_sfb01,g_sfb13,g_sfb08,l_qty,0,0)
       END IF
     END FOREACH
END FUNCTION
 
FUNCTION r520_cralc_bom(p_level,p_key,p_key2,p_total)  #FUN-550112  #No.MOD-7B0186 modify
#No.FUN-A70034  --BEgin
   DEFINE l_total_1    LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA        LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA  LIKE bmb_file.bmb06     #实际QPA
#No.FUN-A70034  --End  
  DEFINE
    p_level      LIKE type_file.num5,          #No.FUN-680121 SMALLINT#level code
    p_total      LIKE csb_file.csb05,          #No.FUN-680121 DECIMAL(13,5)#
    l_total      LIKE csb_file.csb05,          #No.FUN-680121 DECIMAL(13,5)#
    p_key        LIKE bma_file.bma01,          #assembly part number
    p_key2       LIKE ima_file.ima910,         #FUN-550112
    l_ac,l_i     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    arrno        LIKE type_file.num5,          #No.FUN-680121 SMALLINT#BUFFER SIZE
    b_seq        LIKE type_file.num5,          #No.FUN-680121 SMALLINT#restart sequence (line number)
    sr DYNAMIC ARRAY OF RECORD  #array for storage
        bmb02 LIKE bmb_file.bmb02, #line item
        bmb03 LIKE bmb_file.bmb03, #component part number
        bmb10 LIKE bmb_file.bmb10, #Issuing UOM
        bmb10_fac LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
        bmb06 LIKE bmb_file.bmb06, #QPA
        bmb08 LIKE bmb_file.bmb08, #yield
        bmb18 LIKE bmb_file.bmb18, #days offset
        ima02 LIKE ima_file.ima02,  #品名規格
        ima08 LIKE ima_file.ima08, #source code
        ima25 LIKE ima_file.ima25,  #庫存單位
#       ima262 LIKE ima_file.ima262,  #庫存不可用量
        avl_stk  LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
        bma01 LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20)
        #No.FUN-A70034  --Begin
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
        END RECORD,
    l_chr LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sfa07 LIKE sfa_file.sfa07, #quantity owed
    l_sfa11 LIKE sfa_file.sfa11, #consumable flag
#   l_qty LIKE ima_file.ima26, #issuing to stock qty
    l_qty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
    l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_sql LIKE type_file.chr1000            #No.FUN-680121 VARCHAR(400)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
    DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
    DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
    DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044   

 
    LET p_level = p_level + 1
    LET arrno = 520
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF
    IF b_seq IS NULL THEN LET b_seq=0 END IF
    WHILE TRUE
        #有效日期為工單檔預計開工日期為BOM有效日期
        LET l_sql=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,",
            "bmb06/bmb07,bmb08,bmb18,",
            "ima02,ima08,ima25,0,bma01,",      #NO.FUN-A20044 
            "bmb081,bmb082",                   #No.FUN-A70034
            " FROM bmb_file,OUTER ima_file,OUTER bma_file",
            " WHERE bmb01='", p_key,"' ",
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
            "   AND bmb02 >",b_seq,
            "   AND  bmb_file.bmb03 = bma_file.bma01 ",
            "   AND  bmb_file.bmb03 = ima_file.ima01 ",
            "   AND (bmb04 <='",g_sfb13,"' OR bmb04 IS NULL) ",
            "   AND (bmb05 >'",g_sfb13,"' OR bmb05 IS NULL)" ,
            "   AND bmaacti='Y' "
      # IF tm.d='N' THEN      #是否列印大宗料件
      #     LET l_sql=l_sql CLIPPED," AND ima08 NOT IN ('U','V') "
      # END IF
        LET l_sql=l_sql CLIPPED, " ORDER BY 2"
        PREPARE cralc_ppp FROM l_sql
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur CURSOR FOR cralc_ppp
 
        #put BOM data into buffer
        LET l_ac = 1
        FOREACH cralc_cur INTO sr[l_ac].*
            #料件之投料時間(為工單的預計開工日+元件投料時距bmb18)若大於截止
            #日期,則該用料不予考慮。
        #   IF sr[l_ac].bmb18+ g_sfb13 > tm.e_date THEN
        #      CONTINUE FOREACH
        #   END IF
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
            CALL ui.Interface.refresh()
            CALL s_getstock(sr[l_ac].bmb03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
            LET sr[l_ac].avl_stk = l_n3    #NO.FUN-A20044 
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END--
            LET l_ac = l_ac + 1	#check limitation
            IF l_ac >= arrno THEN EXIT FOREACH END IF
        END FOREACH
 
        #insert into allocation file
        FOR l_i = 1 TO l_ac-1
            IF sr[l_i].bmb08 IS NULL THEN LET sr[l_i].bmb08=0 END IF
            #No.FUN-A70034  --Begin
            #LET l_total=sr[l_i].bmb06*p_total*((520+sr[l_i].bmb08))/520
            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,0)
                 RETURNING l_total_1,l_QPA,l_ActualQPA
            LET l_total= l_total_1
            #No.FUN-A70034  --End  
            IF sr[l_i].bmb10_fac IS NULL THEN
               LET sr[l_i].bmb10_fac=1
            END IF
            #乘以單位換算率
            LET l_qty=l_total*sr[l_i].bmb10_fac #convert to stocking qty
 
            #料件為(X,K)虛擬料件時,若Blow through(sma29)='Y' ,則往下展之,
            #否則不往下展,只至該階。
           #-----------No.FUN-670041 modify
           #IF sr[l_i].ima08 MATCHES '[XK]' AND g_sma.sma29='Y' THEN
            IF sr[l_i].ima08 MATCHES '[XK]' THEN
           #-----------No.FUN-670041 end
                IF sr[l_i].bma01 IS NOT NULL THEN
                   #CALL r520_cralc_bom(p_level,sr[l_i].bmb03,' ',p_total*sr[l_i].bmb06)  #FUN-550112  #No.MOD-7B0186 modify#FUN-8B0035
                    #No.FUN-A70034  --Begin
                    #CALL r520_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],p_total*sr[l_i].bmb06)  #FUN-8B0035
                    CALL r520_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total)
                    #No.FUN-A70034  --End  
                END IF
            ELSE
              #需求數量>0時才考慮
              IF l_qty > 0 THEN
                 #insert 可用數量暫時代表資料來源 0:工單檔 -1:獨立需求檔
                 #insert 至暫存檔
                 INSERT INTO ttp_file
                 VALUES(sr[l_i].bmb03,g_sfb01,g_sfb13,g_sfb08,l_qty,0,0)
              END IF
           END IF
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION
 
{
REPORT r520_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,                   #No.FUN-680121 VARCHAR(1)
          sr        RECORD
                           ttp01 LIKE sfb_file.sfb05,          #No.FUN-680121 VARCHAR(20)#料件編號
#                          ttp02 LIKE apm_file.apm08,          #No.FUN-680121 VARCHAR(10)#工單編號
                           ttp02 LIKE sfb_file.sfb01,          #No.FUN-680121 VARCHAR(16)#No.FUN_550067
                           ttp03 LIKE type_file.dat,           #No.FUN-680121 DATE#預計工單日
                           ttp04 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#工單數量
                           ttp05 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#需求數量
                           ttp06 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#未供給需求數量前之可用
                           ttp07 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#預期缺料量
                           ima02 LIKE ima_file.ima02,    #品名規格
                           ima021 LIKE ima_file.ima021,  #規格
                           ima25 LIKE ima_file.ima25,    #庫存單位
                           #ima84 LIKE ima_file.ima84,   #OM備置量
#                          qty4   LIKE sfa_file.sfa03,   #訂單備置量        #No.MOD-840492 
                           qty4   LIKE sfa_file.sfa04,   #訂單備置量        #No.MOD-840492 
                           ima261 LIKE ima_file.ima261,  #庫存不可用量
                           ima262 LIKE ima_file.ima262,  #庫存可用量
                          #No.B017 010326 by plum
                         # ima76 LIKE ima_file.ima76,  #在外量
                         # ima78 LIKE ima_file.ima78,  #在驗量
                         ##ima79 LIKE ima_file.ima79,  #缺料量  #TQC-650066 mark
#                          qty1  LIKE sfa_file.sfa03,  #在外量              #No.MOD-840492 
#                          qty2  LIKE sfa_file.sfa03,  #在驗量              #No.MOD-840492  
#                          qty3  LIKE sfa_file.sfa03,  #缺料量              #No.MOD-840492 
                           qty1  LIKE sfa_file.sfa04,  #在外量              #No.MOD-840492 
                           qty2  LIKE sfa_file.sfa04,  #在驗量              #No.MOD-840492 
                           qty3  LIKE sfa_file.sfa04,  #缺料量              #No.MOD-840492 
                          #No.B017..end
                           sfb05 LIKE sfb_file.sfb05
                    END RECORD ,
          sr1 DYNAMIC ARRAY OF RECORD
                           ttp01 LIKE sfb_file.sfb05,          #No.FUN-680121 VARCHAR(20)#料件編號
#                          ttp02 LIKE apm_file.apm08,          #No.FUN-680121 VARCHAR(10)#工單編號
                           ttp02 LIKE sfb_file.sfb01,          #No.FUN-680121 VARCHAR(16)#No.FUN-550067
                           ttp03 LIKE type_file.dat,           #No.FUN-680121 DATE#預計工單日
                           ttp04 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#工單數量
                           ttp05 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#需求數量
                           ttp06 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#未供給需求數量前之可用
                           ttp07 LIKE sfb_file.sfb08,          #No.FUN-680121 DECIMAL(12,3)#預期缺料量
                           ima02 LIKE ima_file.ima02,    #品名規格
                           ima021 LIKE ima_file.ima021,  #品名規格
                           ima25 LIKE ima_file.ima25,    #庫存單位
                           #ima84 LIKE ima_file.ima84,   #OM備置量
#                          qty4   LIKE sfa_file.sfa03,   #訂單備置量        #No.MOD-840492 
                           qty4   LIKE sfa_file.sfa04,   #訂單備置量        #No.MOD-840492 
                           ima261 LIKE ima_file.ima261,  #庫存不可用量
                           ima262 LIKE ima_file.ima262,  #庫存可用量
                          #No.B017 010326 by plum
                         # ima76 LIKE ima_file.ima76,  #在外量
                         # ima78 LIKE ima_file.ima78,  #在驗量
                         ##ima79 LIKE ima_file.ima79,  #缺料量   #TQC-650066 mark
#                          qty1  LIKE sfa_file.sfa03,  #在外量              #No.MOD-840492 
#                          qty2  LIKE sfa_file.sfa03,  #在驗量              #No.MOD-840492  
#                          qty3  LIKE sfa_file.sfa03,  #缺料量              #No.MOD-840492 
                           qty1  LIKE sfa_file.sfa04,  #在外量              #No.MOD-840492 
                           qty2  LIKE sfa_file.sfa04,  #在驗量              #No.MOD-840492 
                           qty3  LIKE sfa_file.sfa04,  #缺料量              #No.MOD-840492 
                          #No.B017..end
                           sfb05 LIKE sfb_file.sfb05
                    END RECORD ,
         l_sfb05 LIKE sfb_file.sfb05,  #料件編號
         l_sfb04 LIKE sfb_file.sfb04,  #工單狀態
         l_sfb20 LIKE sfb_file.sfb20,  #MRP/MPS需求日期
         l_sfb21 LIKE sfb_file.sfb21,  #MRP/MPS需求日期
         l_sfb14 LIKE sfb_file.sfb14,  #開始生產日期
         l_sfb15 LIKE sfb_file.sfb15,  #結束生產日期
         l_sfb16 LIKE sfb_file.sfb16,  #結束生產日期
         l_sfb08 LIKE sfb_file.sfb08,  #生產數量
         l_ima02 LIKE ima_file.ima02,  #料件編號
         l_ima021 LIKE ima_file.ima021,  #料件編號
         l_ima05 LIKE ima_file.ima05,  #版本
         l_ima08 LIKE ima_file.ima08,  #來源碼
         l_ima55 LIKE ima_file.ima55,  #生產單位
         l_sql   LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(300)
         l_num   LIKE sfb_file.sfb09,           #No.FUN-680121 DECIMAL(12,3)#可完成套數
         l_min   LIKE sfb_file.sfb09,           #No.FUN-680121 DECIMAL(12,3)#最多可完成套數
         l_n,i   LIKE type_file.num5,           #No.FUN-680121 SMALLINT
         l_sw    LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.sfb05,sr.ttp04 ,sr.ttp02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
      #抓取[工單檔]、[料件主檔] 相關資料
      SELECT sfb04,sfb20,sfb21,sfb14,sfb15,sfb16,sfb05,
             ima02,ima021,ima05,ima08,ima55,sfb08
        INTO l_sfb04,l_sfb20,l_sfb21,l_sfb14,l_sfb15,l_sfb16,
             l_sfb05,l_ima02,l_ima021,l_ima05,l_ima08,l_ima55,l_sfb08
        FROM sfb_file,OUTER ima_file
       WHERE  sfb_file.sfb05=ima_file.ima01  AND sfb01=sr.ttp02 AND sfb87!='X'
      PRINT g_x[11] CLIPPED,sr.ttp02,
            COLUMN 52,g_x[12] CLIPPED,sr.ttp03,' ',l_sfb14,
            COLUMN 91,g_x[13] CLIPPED,l_sfb05,' ',l_ima05,' ',l_ima08
      PRINT g_x[14] CLIPPED,l_sfb04,
            COLUMN 52,g_x[15] CLIPPED,l_sfb15,' ',l_sfb16,
            COLUMN 91,g_x[16] CLIPPED,l_ima02
 
    #-------No.FUN-5A0061 modify
      PRINT g_x[17] CLIPPED,l_sfb20,' ',l_sfb21,
            COLUMN 35,g_x[18] CLIPPED,l_ima55,
            COLUMN 52,g_x[19] CLIPPED,l_sfb08,
            COLUMN 91,g_x[22] CLIPPED,l_ima021 CLIPPED
    #-----end
 
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
             g_x[38],g_x[39],g_x[40],g_x[41]
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
             g_x[49]
      PRINT g_dash1
      LET l_sw='N'
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ttp02   #工單編號
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
    # IF l_sw='Y' THEN
    #    #單身表頭
    # 	 PRINT g_x[20] ,g_x[21] ,COLUMN 81,g_x[22],COLUMN 121,g_x[23] CLIPPED
    #        PRINT g_x[24] ,COLUMN 41,g_x[25] ,COLUMN 81,g_x[26] CLIPPED
    #    PRINT '-------------------- ---- ----------- ----------- ',
    #          '----------- ----------- ----------- ----------- ',
    #          '----------- ----------- ------------'
    # END IF
      LET l_sw='N'
      LET l_n=0
      FOR i=1 TO 520
          INITIALIZE sr1[i].* TO NULL
      END FOR
 
   ON EVERY ROW
      LET l_n=l_n+1
      #若有料件之下階超過520個料件時,請將 ARRAY 個數加大
      IF l_n > 520 THEN
         CALL cl_err(sr.ttp01,'asf-319',1)
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      LET sr1[l_n].*=sr.*      #先存在 ARRAY ,並計算其套數
      #計算可完成套數, 最多可完成套數:Min(可用數量/需求數量)*工單數量
      LET l_num=(sr.ttp06/sr.ttp05)*sr.ttp04
      IF l_n=1 THEN
         LET l_min=l_num
      ELSE
         IF l_min > l_num THEN
            LET l_min=l_num     #最多可完成套數
         END IF
      END IF
 
   AFTER GROUP OF sr.ttp02      #工單號碼
      # 若最多可完成套數>工單數量則列印
      #   1.只列印該工單的資料(單頭部份)
      #   2.單身的資料不列印(表頭亦不列印)
      #   3.列印 "最多可完成套數:        ***  工單有充足的可用數量  ***"
      IF l_min > sr.ttp04 THEN
         PRINT COLUMN 1,g_x[20] CLIPPED,l_min USING "-------&.&& ",
               COLUMN 52,g_x[21] CLIPPED
      ELSE
        #否則
        #  1.列印該工單的資料(單頭部份)
        #  2.列印該工單的用料資料(單身部份)
        #  3.列印 "最多可完成套數:           " 字樣
         #單身表頭
     #	 PRINT g_x[20] ,g_x[21] ,COLUMN 81,g_x[22],COLUMN 121,g_x[23] CLIPPED
     #       PRINT g_x[24] ,COLUMN 41,g_x[25] ,COLUMN 81,g_x[26] CLIPPED
     #   PRINT '-------------------- ---- ----------- ----------- ',
     #         '----------- ----------- ----------- ----------- ',
     #         '----------- ----------- ----------'
         FOR i=1 TO l_n
             #是否僅印缺料料件
             IF tm.b='N'  OR (tm.b='Y' AND sr1[i].ttp07 > 0) THEN
                IF LINENO > 50 THEN  #換頁時,必須列印單身表頭
                   LET l_sw='Y'
                   SKIP TO TOP OF PAGE
                END IF
                PRINTX name=D1 COLUMN g_c[31],sr1[i].ttp01,
                      COLUMN g_c[32],sr1[i].ima25,
                      COLUMN g_c[33],sr1[i].ttp05 USING "-------&.&&",
                      COLUMN g_c[34],sr1[i].qty4 USING  "-------&.&&",
                      COLUMN g_c[35],sr1[i].ttp06 USING "-------&.&&",
                      COLUMN g_c[36],sr1[i].ttp07 USING "-------&.&&",
                      COLUMN g_c[37],sr1[i].ima262 USING "-------&.&&",
                      COLUMN g_c[38],sr1[i].ima261 USING "-------&.&&",
                      COLUMN g_c[39],sr1[i].qty1  USING "-------&.&&",
                      COLUMN g_c[40],sr1[i].qty2  USING "-------&.&&",
                      COLUMN g_c[41],sr1[i].qty3  USING "------&.&&"
                PRINTX name=D2 COLUMN g_c[42],sr1[i].ima02,
                      COLUMN g_c[43],sr1[i].ima021
             END IF
         END FOR
         PRINT ' '
         PRINT COLUMN 1,g_x[20] CLIPPED,l_min USING "-------&.&& "
      END IF
 
   ON LAST ROW
     #IF g_zz05 = 'Y' THEN         # (80)-70,140,210,280   /   (132)-120,240,300
     #   PRINT g_dash[1,g_len]
     #   IF tm.wc[001,120] > ' ' THEN			# for 132
     #      PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
     #   IF tm.wc[121,240] > ' ' THEN
     #      PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
     #   IF tm.wc[241,300] > ' ' THEN
     #      PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
     #END IF
     
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
