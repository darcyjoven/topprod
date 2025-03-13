# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abmr820.4gl
# Descriptions...: 單階材料用量成本查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/08/20 By Wu
#        Modify  : 92/05/07 By David
#                  增加 選擇採購性料件列印成本
#        Modify  : 92/09/23 By Nora
#                  去掉成本的選擇項
# Modify.........: 93/10/13 By Apple (請勿再亂更等)
# Modify.........: No.FUN-4A0004 04/10/04 By Yuna
# Modify.........: No.FUN-550093 05/06/03 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-590110 05/09/28 By yoyo 報表修改轉XML
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5A0061 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.FUN-610092 06/05/24 By Joe 報表增加發料單位
# Modify.........: No.TQC-6C0034 06/12/14 By Joe 將單位改為BOM單位
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改
# Modify.........: No.CHI-6A0034 07/01/29 By jamie abmq620->abmr820 
# Modify.........: No.FUN-780018 07/07/23 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80100 11/08/11 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
#CHI-6A0034 add
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
    		wc  	  VARCHAR(500),	# Where condition
       		class	  VARCHAR(04),		# 分群碼
       		revision  VARCHAR(02),		# 版本
       		effective DATE,   		# 有效日期
       		arrange   VARCHAR(1),		# 資料排列方式
       		pur       VARCHAR(1),		# 選擇採購性料件列印成本
            tot       VARCHAR(01),     # 是否列印合計資料
       		more	  VARCHAR(1) 		# Input more condition(Y/N)
          END RECORD,
          g_mcst        LIKE imb_file.imb111    #材料成本
#         g_str          VARCHAR(10)             ### FUN-780018 ###
 
DEFINE   g_cnt           INTEGER
DEFINE   g_i             SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING,              ### FUN-780018 ###                                                                    
         g_str           STRING,              ### FUN-780018 ###                                                                    
         g_sql           STRING               ### FUN-780018 ### 
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
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.class= ARG_VAL(8)
   LET tm.revision = ARG_VAL(9)
   LET tm.effective= ARG_VAL(10)
   LET tm.arrange  = ARG_VAL(11)
   LET tm.pur      = ARG_VAL(12)
   LET tm.tot      = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r820_tm(0,0)			# Input print condition
      ELSE CALL abmr820()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r820_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_flag        SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bma01       LIKE bma_file.bma01,
            l_cmd	  VARCHAR(1000)
 
 
   LET p_row = 4
   LET p_col = 8
 
   OPEN WINDOW r820_w AT p_row,p_col WITH FORM "abm/42f/abmr820"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("acode",g_sma.sma118='Y')
    #FUN-560021................end
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.arrange ='1'  #按元件料件編號遞增順序排列
   LET tm.pur  ='1'     #料件成本
   LET tm.tot  ='Y'
   LET tm.effective = g_today	#有效日期
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bma01,ima06,bma06 FROM item,class,acode #FUN-550093
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale
             CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         #--No.FUN-4A0004--------
         ON ACTION CONTROLP
            CASE WHEN INFIELD(item) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO item
         	  NEXT FIELD item
            OTHERWISE EXIT CASE
            END CASE
         #--END---------------
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 FROM bma_file,ima_file",
             " WHERE bma01=ima01 AND ",tm.wc CLIPPED," GROUP BY bma01 "
         PREPARE r820_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P0:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE r820_cnt
         CURSOR FOR r820_precnt
         OPEN r820_cnt
         FETCH r820_cnt INTO g_cnt,l_bma01
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            #LET g_cnt=sqlca.sqlerrd[3]
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF
 
      INPUT BY NAME tm.revision,tm.effective,tm.arrange,tm.pur,tm.tot,tm.more WITHOUT DEFAULTS
 
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
 
         AFTER FIELD arrange
            IF tm.arrange NOT MATCHES '[12]' THEN
               NEXT FIELD arrange
            END IF
 
         AFTER FIELD pur
            IF tm.pur IS NULL OR tm.pur NOT MATCHES '[123]' THEN
               NEXT FIELD pur
            END IF
 
         AFTER FIELD tot
            IF tm.tot IS NULL OR tm.tot NOT MATCHES '[YN]' THEN
               NEXT FIELD tot
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON ACTION CONTROLP
            CALL r820_wc()   # Input detail Where Condition
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr820'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmr820','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.class CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.arrange CLIPPED,"'",
                            " '",tm.pur  CLIPPED,"'",
                            " '",tm.tot  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr820',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abmr820()
      ERROR ""
   END WHILE
   CLOSE WINDOW r820_w
END FUNCTION
 
FUNCTION r820_wc()
#   DEFINE l_wc VARCHAR(500)
   DEFINE l_wc  STRING           #NO.FUN-910082 
 
   OPEN WINDOW r820_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi600")
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
        s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,s_bmb[1].bmb10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   CLOSE WINDOW r820_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/20(Wu)-
FUNCTION abmr820()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Usima time for running the job
          l_sql   VARCHAR(3000),		# RDSQL STATEMENT
          l_za05 VARCHAR(40),
          sr  RECORD                                #每階存放資料
              order1     SMALLINT,                  #排列順序
              bmb01 LIKE bmb_file.bmb01,            #主件料號
              bmb03 LIKE bmb_file.bmb03,            #元件料號
              bmb02 LIKE bmb_file.bmb02,            #項次
              bmb06 LIKE bmb_file.bmb06,            #QPA
              ima02 LIKE ima_file.ima02,            #品名規格
              ima08 LIKE ima_file.ima08,            #來源碼
              ima53 LIKE ima_file.ima53,
              ima531 LIKE ima_file.ima531,
              ima44 LIKE ima_file.ima44,
              ima44_fac LIKE ima_file.ima44_fac,
              bmb10 LIKE bmb_file.bmb10,
              bmb10_fac  LIKE bmb_file.bmb10_fac,
              bmb29 LIKE bmb_file.bmb29,         #FUN-550093
			  #現時成本
              c_purcost     LIKE imb_file.imb118,   #採購成本
              c_mcsts       LIKE imb_file.imb111,   #材料成本
              c_labcsts     LIKE imb_file.imb114,   #人工成本
              c_cstsabs     LIKE imb_file.imb114,   #固定製造費用 + 機器成本
              c_cstao2s     LIKE imb_file.imb115,   #變動製造費用
              c_cstop       LIKE imb_file.imb121,   #廠外加工成本
              c_cstlop      LIKE imb_file.imb121,   #廠外加工費用
              c_cstmcsts    LIKE imb_file.imb121,   #廠外加工材料
			  #預設成本
              p_purcost     LIKE imb_file.imb118,    #採購成本
              p_mcsts       LIKE imb_file.imb111,    #材料成本
              p_labcsts     LIKE imb_file.imb114,    #人工成本
              p_cstsabs     LIKE imb_file.imb114,    #固定製造費用 + 機器成本
              p_cstao2s     LIKE imb_file.imb115,    #變動製造費用
              p_cstop       LIKE imb_file.imb121,    #廠外加工成本
              p_cstlop      LIKE imb_file.imb121,    #廠外加工費用
              p_cstmcsts    LIKE imb_file.imb121,    #廠外加工材料
			  #標準成本
              s_purcost     LIKE imb_file.imb118,    #採購成本
              s_mcsts       LIKE imb_file.imb111,    #材料成本
              s_labcsts     LIKE imb_file.imb114,    #人工成本
              s_cstsabs     LIKE imb_file.imb114,    #固定製造費用 + 機器成本
              s_cstao2s     LIKE imb_file.imb115,    #變動製造費用
              s_cstop       LIKE imb_file.imb121,    #廠外加工成本
              s_cstlop      LIKE imb_file.imb121,    #廠外加工費用
              s_cstmcsts    LIKE imb_file.imb121     #廠外加工材料
          END RECORD,
          l_price       LIKE ima_file.ima53,
          l_unit_fac    LIKE bmb_file.bmb10_fac,
          g_sw          SMALLINT,
          l_cmd	 VARCHAR(1000)
   DEFINE l_ver   LIKE ima_file.ima05,                                                                                              
          l_ima02 LIKE ima_file.ima02,    #品名規格                                                                                 
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima06 LIKE ima_file.ima06,    #分群碼                                                                                   
          l_ima08 LIKE ima_file.ima08     #來源     
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
    #No.FUN-780018 -str
    LET g_sql = "bmb01.bmb_file.bmb01,",
                "ima05.ima_file.ima05,",
                "ima08.ima_file.ima08,",    
                "ima06.ima_file.ima06,",       
                "bmb29.bmb_file.bmb29,",
                "ima02.ima_file.ima02,",
                "bmb02.bmb_file.bmb02,",
                "bmb03.bmb_file.bmb03,",
                "ima08a.ima_file.ima08,",
                "bmb10.bmb_file.bmb10,",
                "bmb06.bmb_file.bmb06,",
                "ima02s.ima_file.ima02,",
                "imb118.imb_file.imb118,",
                "imb111.imb_file.imb111,",
                "imb114.imb_file.imb114,",
                "imb114p.imb_file.imb114,",
                "imb115.imb_file.imb115,",
                "imb121.imb_file.imb121,",
                "imb121p.imb_file.imb121,",
                "imb118c.imb_file.imb118,",
                "imb111c.imb_file.imb111,",
                "imb114c.imb_file.imb114,",
                "imb121c.imb_file.imb121,",
                "imb114cc.imb_file.imb114,",
                "imb115c.imb_file.imb115,",
                "imb121ca.imb_file.imb121,",
                "imb121cc.imb_file.imb121,",
                "imb118s.imb_file.imb118,",
                "imb111s.imb_file.imb111,",
                "imb114s.imb_file.imb114,",
                "imb121s.imb_file.imb121,",
                "imb114ss.imb_file.imb114,",
                "imb115s.imb_file.imb115,",
                "imb121sa.imb_file.imb121,",
                "imb121ss.imb_file.imb121,",
                "l_ver.ima_file.ima05"
 
    LET l_table = cl_prt_temptable('abmr816',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
     END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                          
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
    PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM                                                                            
    END IF                                                                                                                          
    #No.FUN-780018 -END
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
 
    LET l_sql="SELECT '',bmb01,bmb03,bmb02,(bmb06/bmb07),",
              "ima02,ima08,ima53,ima531,ima44,ima44_fac,bmb10,bmb10_fac,",
              "bmb29,",  #FUN-550093
		#現時成本
              " (imb218 * (bmb06/bmb07) * bmb10_fac),",
              " ((imb211 + imb212 + imb221 + imb222) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb2131 + imb2132 + imb2231 + imb2232 ) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb214 + imb219 + imb224 + imb229 ) * (bmb06/bmb07) ",
              " * bmb10_fac), ",
              " ((imb215 + imb225 ) * (bmb06/bmb07) * bmb10_fac), ",
              " ((imb216 + imb226 ) * (bmb06/bmb07) * bmb10_fac), ",
              " ((imb2171 + imb2172 + imb2271 + imb2272 ) * (bmb06/bmb07) ",
              " * bmb10_fac), ",
              " ((imb2151 + imb2251) * (bmb06/bmb07) * bmb10_fac),",
		#預設成本
              " (imb318 * (bmb06/bmb07) * bmb10_fac),",
              " ((imb311 + imb312 + imb321 + imb322) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb3131 + imb3132 + imb3231 + imb3232 ) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb314 + imb319 + imb324 + imb329 ) * (bmb06/bmb07) ",
              " * bmb10_fac), ",
              " ((imb315 + imb325 ) * (bmb06/bmb07) * bmb10_fac), ",
              " ((imb316 + imb326 ) * (bmb06/bmb07) * bmb10_fac), ",
              " ((imb3171 + imb3172 + imb3271 + imb3272 ) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb3151 + imb3251) * (bmb06/bmb07) * bmb10_fac),",
		#標準成本
              " (imb118 * (bmb06/bmb07) * bmb10_fac),",
              " ((imb111 + imb112 + imb121 + imb122) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb1131 + imb1132 + imb1231 + imb1232 ) * (bmb06/bmb07) ",
              " * bmb10_fac),",
              " ((imb114 + imb119 + imb124 + imb129 ) * (bmb06/bmb07) ",
              " * bmb10_fac), ",
              " ((imb115 + imb125 ) * (bmb06/bmb07) * bmb10_fac), ",
              " ((imb116 + imb126 ) * (bmb06/bmb07) * bmb10_fac), ",
              " ((imb1171 + imb1172 + imb1271 + imb1272 ) * (bmb06/bmb07) ",
              " * bmb10_fac), ",
              " ((imb1151 + imb1251) * (bmb06/bmb07) * bmb10_fac) ",
              " FROM bma_file ,ima_file,bmb_file LEFT OUTER JOIN imb_file ON imb01 = bmb03 ",
          	  " WHERE bma01= bmb01",
              " AND bmb03 = ima01",
              " AND bmb29 = bma06", #FUN-550093
              " AND ",tm.wc
 
     #---->生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
         "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
         "' OR bmb05 IS NULL)"
     END IF
     #---->排列方式
     LET l_sql=l_sql CLIPPED, " ORDER BY"
     IF tm.arrange='1' THEN
          LET l_sql=l_sql CLIPPED," bmb03"
     ELSE
            LET l_sql=l_sql CLIPPED," bmb02"
     END IF
 
     PREPARE r820_prepare FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r820_cs CURSOR FOR r820_prepare
 
#    CALL cl_outnam('abmr820') RETURNING l_name                             #FUN-780018
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-780018 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-780018 add ###                                              
     #------------------------------ CR (2) ------------------------------#    
#    START REPORT r820_rep TO l_name                                        #FUN-780018
     #No.FUN-780018 -STR
     {
       CASE tm.pur
         WHEN '1' LET g_str = g_x[25] clipped
         WHEN '2' LET g_str = g_x[26] clipped
         WHEN '3' LET g_str = g_x[27] clipped
       END CASE
      }
     #No.FUN-780018 -END
       #讀取本幣小數位數的限制
        SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
                           FROM azi_file
                          WHERE azi01 =g_aza.aza17
       FOREACH r820_cs INTO sr.*
#No.FUN-780018--begin            
       CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver
       SELECT ima02,ima05,ima06,ima08                                                                                                
          INTO l_ima02,l_ima05,l_ima06,l_ima08                                                                                      
          FROM ima_file                                                                                                             
          WHERE ima01=sr.bmb01                                                                                                      
       IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02='' LET l_ima05=''                                                                                             
          LET l_ima06='' LET l_ima08=''                                                                                             
       END IF
#No.FUN-780018--end
         #判斷來源碼是否為'P','V','Z'
         IF sr.ima08 MATCHES '[PVZ]' THEN
            CASE tm.pur
              WHEN '2'   #最近進價
                  #發料單位與採購單位不同時 必須 bmb10_fac 與 ima44_fac換算
                  LET l_unit_fac = sr.bmb10_fac / sr.ima44_fac
                  LET l_price = sr.ima53 * l_unit_fac
                  LET sr.p_purcost = l_price
                  LET sr.s_purcost = l_price
                  LET sr.c_purcost = l_price
              WHEN '3'   #市價
                  LET sr.p_purcost = sr.ima531 / sr.ima44_fac
                  LET sr.s_purcost = sr.ima531 / sr.ima44_fac
                  LET sr.c_purcost = sr.ima531 / sr.ima44_fac
               OTHERWISE EXIT CASE
              END CASE
         END IF
#        OUTPUT TO REPORT r820_rep(sr.*)                          #FUN-780018
           #No.FUN-780018 -STR
           EXECUTE insert_prep USING                                                                                                
                   sr.bmb01,l_ima05,l_ima08,l_ima06,sr.bmb29,l_ima02,sr.bmb02,sr.bmb03,
                   sr.ima08,sr.bmb10,sr.bmb06,sr.ima02,sr.c_purcost,sr.c_mcsts,sr.c_labcsts,
                   sr.c_cstsabs,sr.c_cstao2s,sr.c_cstop,sr.c_cstlop,sr.p_purcost,sr.p_mcsts,
                   sr.p_labcsts,sr.p_cstmcsts,sr.p_cstsabs,sr.p_cstao2s,sr.p_cstop,sr.p_cstlop,
                   sr.s_purcost,sr.s_mcsts,sr.s_labcsts,sr.s_cstmcsts,sr.s_cstsabs,sr.s_cstao2s,
                   sr.s_cstop,sr.s_cstlop,l_ver
          #No.FUN-780018 -END
       END FOREACH
 
    #DISPLAY "" AT 2,1
#    FINISH REPORT r820_rep                                        #FUN-780018
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                   #FUN-780018
#No.FUN-780018--begin
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'bma01,ima06,bma06')                                                                                   
              RETURNING tm.wc                                                                                                       
#        CALL cl_prt_pos_wc(tm.wc)                                 #FUN-780018                                                                 
      END IF       
#No.FUN-780018--end           
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-780018 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.effective,";",g_azi03,";",tm.wc,";",tm.pur,";",g_azi05,";",tm.arrange,';',tm.tot                                                                               
    CALL cl_prt_cs3('abmr820','abmr820',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#  
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
END FUNCTION
 
#No.FUN-780018 -STR
{
REPORT r820_rep(sr)                                                   
   DEFINE l_last_sw VARCHAR(1),
          sr  RECORD        #每階存放資料
              order1     SMALLINT,          #排列順序
              bmb01 LIKE bmb_file.bmb01,    #主件料號
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              ima02 LIKE ima_file.ima02,    #品名規格
              ima08 LIKE ima_file.ima08,    #來源碼
              ima53 LIKE ima_file.ima53,
              ima531 LIKE ima_file.ima531,
              ima44 LIKE ima_file.ima44,
              ima44_fac LIKE ima_file.ima44_fac,
              bmb10 LIKE bmb_file.bmb10,
              bmb10_fac  LIKE bmb_file.bmb10_fac,
              bmb29 LIKE bmb_file.bmb29, #FUN-550093
			  #現時成本
              c_purcost     LIKE imb_file.imb118,    #採購成本
              c_mcsts       LIKE imb_file.imb111,    #材料成本
              c_labcsts     LIKE imb_file.imb114,    #人工成本
              c_cstsabs     LIKE imb_file.imb114,    #固定製造費用 + 機器成本
              c_cstao2s     LIKE imb_file.imb115,    #變動製造費用
              c_cstop       LIKE imb_file.imb121,    #廠外加工成本
              c_cstlop      LIKE imb_file.imb121,    #廠外加工費用
              c_cstmcsts    LIKE imb_file.imb121,   #廠外加工材料
			  #預設成本
              p_purcost     LIKE imb_file.imb118,    #採購成本
              p_mcsts       LIKE imb_file.imb111,    #材料成本
              p_labcsts     LIKE imb_file.imb114,    #人工成本
              p_cstsabs     LIKE imb_file.imb114,    #固定製造費用 + 機器成本
              p_cstao2s     LIKE imb_file.imb115,    #變動製造費用
              p_cstop       LIKE imb_file.imb121,    #廠外加工成本
              p_cstlop      LIKE imb_file.imb121,    #廠外加工費用
              p_cstmcsts    LIKE imb_file.imb121,   #廠外加工材料
			  #標準成本
              s_purcost     LIKE imb_file.imb118,    #採購成本
              s_mcsts       LIKE imb_file.imb111,    #材料成本
              s_labcsts     LIKE imb_file.imb114,    #人工成本
              s_cstsabs     LIKE imb_file.imb114,    #固定製造費用 + 機器成本
              s_cstao2s     LIKE imb_file.imb115,    #變動製造費用
              s_cstop       LIKE imb_file.imb121,    #廠外加工成本
              s_cstlop      LIKE imb_file.imb121,    #廠外加工費用
              s_cstmcsts    LIKE imb_file.imb121     #廠外加工材料
          END RECORD,
          l_totp_purcost, l_totp_mcsts    LIKE imb_file.imb121,
          l_totp_labcsts, l_totp_cstmcsts LIKE imb_file.imb121,
          l_totp_cstsabs, l_totp_cstao2s  LIKE imb_file.imb121,
          l_totp_cstop  , l_totp_cstlop   LIKE imb_file.imb121,
          l_tots_purcost, l_tots_mcsts    LIKE imb_file.imb121,
          l_tots_labcsts, l_tots_cstmcsts LIKE imb_file.imb121,
          l_tots_cstsabs, l_tots_cstao2s  LIKE imb_file.imb121,
          l_tots_cstop  , l_tots_cstlop   LIKE imb_file.imb121,
          l_totc_purcost, l_totc_mcsts    LIKE imb_file.imb121,
          l_totc_labcsts, l_totc_cstmcsts LIKE imb_file.imb121,
          l_totc_cstsabs, l_totc_cstao2s  LIKE imb_file.imb121,
          l_totc_cstop  , l_totc_cstlop   LIKE imb_file.imb121,
          l_ver   LIKE ima_file.ima05,
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #分群碼
          l_ima08 LIKE ima_file.ima08     #來源
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bmb01,sr.bmb29,sr.order1 #FUN-550093
  FORMAT
   PAGE HEADER
#No.FUN-590110--start
# genero  script marked       LET g_pageno = g_pageno + 1
      CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT                                        #No.FUN-6C0014
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
      PRINT g_x[24] clipped,g_str clipped,           #No.FUN-6C0014 
            COLUMN (g_len-FGL_WIDTH(g_x[30])-6)/2,   #No.FUN-6C0014 
            g_x[10] CLIPPED,tm.effective,'  ',
            g_x[32] CLIPPED,l_ver
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
#No.FUN-590110--end
      SELECT ima02,ima05,ima06,ima08
          INTO l_ima02,l_ima05,l_ima06,l_ima08
          FROM ima_file
          WHERE ima01=sr.bmb01
      IF SQLCA.sqlcode THEN
          LET l_ima02='' LET l_ima05=''
          LET l_ima06='' LET l_ima08=''
      END IF
 
#-------No.TQC-5B0107 modify  #&051112
  #------No.FUN-5A0061 modify
      PRINT COLUMN  1,g_x[11] CLIPPED, sr.bmb01 CLIPPED, #FUN-5B0013 add CLIPPED
            COLUMN 60,g_x[12] CLIPPED, l_ima05,
            COLUMN 72,g_x[13] CLIPPED, l_ima08,
            COLUMN 79,g_x[14] CLIPPED, l_ima06,
            COLUMN 89,g_x[33] CLIPPED, sr.bmb29   #FUN-550093
  #------end
#------ No.TQC-5B0107 end
 
      PRINT COLUMN  1,g_x[15] CLIPPED, l_ima02 CLIPPED #FUN-5B0013 add CLIPPED
      PRINT ' '
#No.FUN-590110--start
    ##PRINTX name=H1 g_x[34],g_x[35],g_x[36],g_x[37],         #No.FUN-610092
      PRINTX name=H1 g_x[34],g_x[35],g_x[36],g_x[52],g_x[37], #No.FUN-610092
                     g_x[39],g_x[40],g_x[41],g_x[42]
    ##PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],         #No.FUN-610092
      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[53],g_x[46], #No.FUN-610092
                     g_x[48],g_x[49],g_x[50],g_x[51]
      PRINT g_dash1
#No.FUN-590110--end
      LET l_last_sw = 'n'
   #FUN-550093................begin
  #BEFORE GROUP OF sr.bmb01
  #   IF (PAGENO > 1 OR LINENO > 13)
  #      THEN SKIP TO TOP OF PAGE
  #   END IF
   BEFORE GROUP OF sr.bmb29
      SKIP TO TOP OF PAGE
   #FUN-550093................end
      LET l_totp_purcost = 0 LET l_totp_mcsts     = 0
      LET l_totp_labcsts = 0 LET l_totp_cstmcsts  = 0
      LET l_totp_cstsabs = 0 LET l_totp_cstao2s   = 0
      LET l_totp_cstop   = 0 LET l_totp_cstlop    = 0
      LET l_tots_purcost = 0 LET l_tots_mcsts     = 0
      LET l_tots_labcsts = 0 LET l_tots_cstmcsts  = 0
      LET l_tots_cstsabs = 0 LET l_tots_cstao2s   = 0
      LET l_tots_cstop   = 0 LET l_tots_cstlop    = 0
      LET l_totc_purcost = 0 LET l_totc_mcsts     = 0
      LET l_totc_labcsts = 0 LET l_totc_cstmcsts  = 0
      LET l_totc_cstsabs = 0 LET l_totc_cstao2s   = 0
      LET l_totc_cstop   = 0 LET l_totc_cstlop    = 0
 
   ON EVERY ROW
 
       #---->元件編號
#No.FUN-590110--start
  	   PRINTX name=D1
                  COLUMN g_c[34],sr.bmb02 using '####',
                  #COLUMN g_c[35],sr.bmb03[1,30], #FUN-5B0013 mark
                  COLUMN g_c[35],sr.bmb03 CLIPPED, #FUN-5B0013 add
                  COLUMN g_c[36],sr.ima08,
                  COLUMN g_c[52],sr.bmb10,    #No.FUN-610092  #NO.TQC-6C0034
                  COLUMN g_c[37],sr.bmb06  using '###&.&&&&&'
       PRINTX name=D2 COLUMN g_c[44],sr.ima02 CLIPPED #FUN-5B0013 add CLIPPED
       PRINT ' '
 
	   #---->現時成本
 	   PRINTX name=D1
                 COLUMN g_c[35],g_x[21] CLIPPED,
                 COLUMN g_c[39],cl_numfor(sr.c_purcost,39,g_azi03), #採購成本
                 COLUMN g_c[40],cl_numfor(sr.c_mcsts  ,40,g_azi03), #材料成本
                 COLUMN g_c[41],cl_numfor(sr.c_labcsts,41,g_azi03)  #人工成本
           PRINTX name=D2
                 COLUMN g_c[48],cl_numfor(sr.c_cstsabs,48,g_azi03), #固定費用
                 COLUMN g_c[49],cl_numfor(sr.c_cstao2s,49,g_azi03), #變動費用
                 COLUMN g_c[50],cl_numfor(sr.c_cstop  ,50,g_azi03), #廠外成本
                 COLUMN g_c[51],cl_numfor(sr.c_cstlop ,51,g_azi03)  #廠外費用
 
	   #---->預設成本
 	   PRINTX name=D1
                 COLUMN g_c[35],g_x[22] CLIPPED,
                 COLUMN g_c[39],cl_numfor(sr.p_purcost ,39,g_azi03),#採購成本
                 COLUMN g_c[40],cl_numfor(sr.p_mcsts   ,40,g_azi03),#材料成本
                 COLUMN g_c[41],cl_numfor(sr.p_labcsts ,41,g_azi03),#人工成本
                 COLUMN g_c[42],cl_numfor(sr.p_cstmcsts,42,g_azi03) #廠外材料
           PRINTX name=D2
                 COLUMN g_c[48],cl_numfor(sr.p_cstsabs,48,g_azi03), #固定費用
                 COLUMN g_c[49],cl_numfor(sr.p_cstao2s,49,g_azi03), #變動費用
                 COLUMN g_c[50],cl_numfor(sr.p_cstop  ,50,g_azi03), #廠外成本
                 COLUMN g_c[51],cl_numfor(sr.p_cstlop ,51,g_azi03)  #廠外費用
 
	   #---->標準成本
 	   PRINTX name=D1
                 COLUMN g_c[35],g_x[23] CLIPPED,
                 COLUMN g_c[39],cl_numfor(sr.s_purcost ,39,g_azi03),#採購成本
                 COLUMN g_c[40],cl_numfor(sr.s_mcsts   ,40,g_azi03),#材料成本
                 COLUMN g_c[41],cl_numfor(sr.s_labcsts ,41,g_azi03),#人工成本
                 COLUMN g_c[42],cl_numfor(sr.s_cstmcsts,42,g_azi03) #廠外材料
           PRINTX name=D2
                 COLUMN g_c[48],cl_numfor(sr.s_cstsabs,48,g_azi03), #固定費用
                 COLUMN g_c[49],cl_numfor(sr.s_cstao2s,49,g_azi03), #變動費用
                 COLUMN g_c[50],cl_numfor(sr.s_cstop  ,50,g_azi03), #廠外成本
                 COLUMN g_c[51],cl_numfor(sr.s_cstlop ,51,g_azi03)  #廠外費用
#No.FUN-590110--end
 
   AFTER GROUP OF sr.bmb01
# genero  script marked       LET g_pageno = 0
      IF tm.tot ='Y' THEN
       #---->標準成本合計
       LET l_tots_purcost  = GROUP SUM(sr.s_purcost)   #採購成本
       LET l_tots_mcsts    = GROUP SUM(sr.s_mcsts)     #材料成本
       LET l_tots_labcsts  = GROUP SUM(sr.s_labcsts)   #人工成本
       LET l_tots_cstmcsts = GROUP SUM(sr.s_cstmcsts)  #廠外材料
 
       LET l_tots_cstsabs  = GROUP SUM(sr.s_cstsabs)   #固定費用
       LET l_tots_cstao2s  = GROUP SUM(sr.s_cstao2s)   #變動費用
       LET l_tots_cstop    = GROUP SUM(sr.s_cstop)     #廠外成本
       LET l_tots_cstlop   = GROUP SUM(sr.s_cstlop)    #廠外費用
 
       #---->現時成本合計
       LET l_totp_purcost  = GROUP SUM(sr.p_purcost)   #採購成本
       LET l_totp_mcsts    = GROUP SUM(sr.p_mcsts)     #材料成本
       LET l_totp_labcsts  = GROUP SUM(sr.p_labcsts)   #人工成本
       LET l_totp_cstmcsts = GROUP SUM(sr.p_cstmcsts)  #廠外材料
 
       LET l_totp_cstsabs  = GROUP SUM(sr.p_cstsabs)   #固定費用
       LET l_totp_cstao2s  = GROUP SUM(sr.p_cstao2s)   #變動費用
       LET l_totp_cstop    = GROUP SUM(sr.p_cstop)     #廠外成本
       LET l_totp_cstlop   = GROUP SUM(sr.p_cstlop)    #廠外費用
 
       #---->預設成本合計
       LET l_totc_purcost  = GROUP SUM(sr.c_purcost)   #採購成本
       LET l_totc_mcsts    = GROUP SUM(sr.c_mcsts)     #材料成本
       LET l_totc_labcsts  = GROUP SUM(sr.c_labcsts)   #人工成本
       LET l_totc_cstmcsts = GROUP SUM(sr.c_cstmcsts)  #廠外材料
 
       LET l_totc_cstsabs  = GROUP SUM(sr.c_cstsabs)   #固定費用
       LET l_totc_cstao2s  = GROUP SUM(sr.c_cstao2s)   #變動費用
       LET l_totc_cstop    = GROUP SUM(sr.c_cstop)     #廠外成本
       LET l_totc_cstlop   = GROUP SUM(sr.c_cstlop)    #廠外費用
 
       PRINTX name=D1
             COLUMN g_c[35],g_x[29] clipped,
             COLUMN g_c[39],cl_numfor(l_totc_purcost ,39,g_azi05),
             COLUMN g_c[40],cl_numfor(l_totc_mcsts   ,40,g_azi05),
             COLUMN g_c[41],cl_numfor(l_totc_labcsts ,41,g_azi05),
             COLUMN g_c[42],cl_numfor(l_totc_cstmcsts,42,g_azi05)
       PRINTX name=D2
             COLUMN g_c[48],cl_numfor(l_totc_cstsabs,48,g_azi05),
             COLUMN g_c[49],cl_numfor(l_totc_cstao2s,49,g_azi05),
             COLUMN g_c[50],cl_numfor(l_totc_cstop  ,50,g_azi05),
             COLUMN g_c[51],cl_numfor(l_totc_cstlop ,51,g_azi05)
 
       PRINTX name=D1
             COLUMN g_c[35],g_x[30] clipped,
             COLUMN g_c[39],cl_numfor(l_totp_purcost ,39,g_azi05),
             COLUMN g_c[40],cl_numfor(l_totp_mcsts   ,40,g_azi05),
             COLUMN g_c[41],cl_numfor(l_totp_labcsts ,41,g_azi05),
             COLUMN g_c[42],cl_numfor(l_totp_cstmcsts,42,g_azi05)
       PRINTX name=D2
             COLUMN g_c[48],cl_numfor(l_totp_cstsabs,48,g_azi05),
             COLUMN g_c[49],cl_numfor(l_totp_cstao2s,49,g_azi05),
             COLUMN g_c[50],cl_numfor(l_totp_cstop  ,50,g_azi05),
             COLUMN g_c[51],cl_numfor(l_totp_cstlop ,51,g_azi05)
       PRINTX name=D1
             COLUMN g_c[35],g_x[31] clipped,
             COLUMN g_c[39],cl_numfor(l_tots_purcost ,39,g_azi05),
             COLUMN g_c[40],cl_numfor(l_tots_mcsts   ,40,g_azi05),
             COLUMN g_c[41],cl_numfor(l_tots_labcsts ,41,g_azi05),
             COLUMN g_c[42],cl_numfor(l_tots_cstmcsts,42,g_azi05)
       PRINTX name=D2
             COLUMN g_c[48],cl_numfor(l_tots_cstsabs ,48,g_azi05),
             COLUMN g_c[49],cl_numfor(l_tots_cstao2s ,49,g_azi05),
             COLUMN g_c[50],cl_numfor(l_tots_cstop   ,50,g_azi05),
             COLUMN g_c[51],cl_numfor(l_tots_cstlop  ,51,g_azi05)
#No.FUN-590110--end
    END IF
 
   ON LAST ROW
#No.FUN-6C0014--begin
      NEED 4 LINES
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bma01,ima06,bma06')                   
              RETURNING tm.wc                                                   
         PRINT g_dash[1,g_len]
         CALL cl_prt_pos_wc(tm.wc)
      END IF                                                                    
      PRINT g_dash[1,g_len]                                                     
#No.FUN-6C0014--end
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
#No.FUN-6C0014--begin
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
#No.FUN-6C0014--end
END REPORT
}
#No.FUN-780018 -end
#Patch....NO.TQC-610035 <> #
