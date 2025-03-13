# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abmr621.4gl
# Descriptions...: 多階材料用量成本清單
# Input parameter:
# Return code....:
# Date & Author..: 91/08/09 By Lee
#      Modify    : 92/05/08 By David
#      Modify    : 92/05/27 By David update group code
# 【記事】
# 1991/11/05 (Lee)------------------------------------------------
#  1.料件為 P/V/Z件時, 材料成本使用採購成本, 其餘皆以材料成本為主
#  2.機器成本加至固定製造費用中
#  3.廠外加工製造費用成本: 直接使用廠外加工固定製造費用+ 廠外加工
#    變動製造費用成本 (原使用分攤率方式)
#  4.人工成本改成人工成本*(1+人工製造費用分攤率)
#  5.人工成本改成人工成本+人工製造費用 ,所有成本都用加的,沒有分攤率了 91/12/23
# Modify........: 93/09/14 By Apple
# Modify........: No.MOD-4B0170 04/11/17 By Mandy oracle的寫法有誤
# Modify........: No.FUN-510033 05/02/21 By Mandy 報表轉XML
# Modify........: No.MOD-530217 05/03/23 By kim 頁次分母永遠為1
# Modify........: No.FUN-550095 05/06/03 By Mandy 特性BOM
# Modify........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加開窗查詢
# Modify........: No.FUN-610092 06/05/24 By Joe 報表新增採購單位欄位
# Modify........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify........: No.CHI-680020 06/10/26 By Carol 報表在列印下階時先列印本階資料後再去展階
# Modify........: No.TQC-6C0034 06/12/14 By Joe 將單位改為BOM單位
# Modify........: No.TQC-7A0013 07/10/11 By xiaofeizhu 報表轉Crystal Report格式
# Modify........: No.MOD-830140 08/03/19 By Pengu 排序會異常
# Modify........: No.MOD-890035 08/09/27 By liuxqa 修改sql條件
# Modify........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify........: No.TQC-970026 09/07/02 By sherry  終階組成用量應給l_total
# Modify........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify........: No.TQC-A40116 10/04/26 By liuxqa modify sql
# Modify........: No.FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代處理
# Modify........: No.MOD-B90073 12/02/17 By bart 材料成本也需乘上QPA

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
    	    	wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
      		revision  LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
       	    	effective LIKE type_file.dat,     #No.FUN-680096 DATE
       		arrange   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
       	    	cost      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          	pur       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                loc       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
       		more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_bma01_a     LIKE bma_file.bma01,    #產品結構單頭
          g_bma06_a     LIKE bma_file.bma06,    #FUN-550095
          g_mcst        LIKE imb_file.imb111,   #材料成本
          g_imcstc      LIKE imb_file.imb121,   #下階間接材料成本
          g_labcstc     LIKE imb_file.imb121,   #下階直接人工成本
          g_fixo        LIKE imb_file.imb121,   #下階固定製費
          g_varo        LIKE imb_file.imb121,   #下階變動製費
          g_outc        LIKE imb_file.imb121,   #下階廠外加工成本
          g_outo        LIKE imb_file.imb121    #下階廠外加工費用                  
#         g_str         LIKE type_file.chr50    #No.FUN-680096 VARCHAR(34)             #No.TQC-7A0013
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING                  #No.TQC-7A0013                                                                                  
DEFINE   g_sql          STRING                  #No.TQC-7A0013
DEFINE   g_str          STRING                  #No.TQC-7A0013
DEFINE   g_no           LIKE type_file.num10    #No.MOD-830140 add
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
   #No.TQC-7A0013  --Begin                                                                                                          
   LET g_sql = " p_level.type_file.num5,",                                                                                          
               " p_i.type_file.num5,",   
               " p_total.bmb_file.bmb06,",
         ##    " l_total.bmb_file.bmb06,",
               " l_total_1.bmb_file.bmb06,",
               " bmb15.bmb_file.bmb15,",    
               " bmb16.bmb_file.bmb16,",                                                                                       
               " bmb03.bmb_file.bmb03,",   
               " ima02.ima_file.ima02,",                                                                                            
               " ima021.ima_file.ima021,",
               " ima08.ima_file.ima08,",
               " bmb10.bmb_file.bmb10,",                                                                                         
               " bmb02.bmb_file.bmb02,",                                                                                            
               " bmb06.bmb_file.bmb06,",
               " bmb04.bmb_file.bmb04,",
               " bmb05.bmb_file.bmb05,",                                                                                            
               " bmb14.bmb_file.bmb14,",                                                                                            
               " bmb17.bmb_file.bmb17,",
               " mcsts.imb_file.imb111,",                                                                                           
               " labcsts.imb_file.imb1131,",                                                                                        
               " cstsabs.imb_file.imb114,",                                                                                         
               " cstao2s.imb_file.imb115,",                                                                                         
               " outlabs.imb_file.imb116,",                                                                                         
               " outmbfs.imb_file.imb1171,",
               " l_ima02.ima_file.ima02,",                                                                                          
               " l_ima021.ima_file.ima021,",                                                                                        
               " l_ima05.ima_file.ima05,",                                                                                          
               " l_ima06.ima_file.ima06,",                                                                                          
               " l_ima08.ima_file.ima08,",
               " l_ima37.ima_file.ima37,",                                                                                          
               " l_ima63.ima_file.ima63,",                                                                                        
               " l_ima55.ima_file.ima55,",
               " l_bma02.bma_file.bma02,",                                                                                          
               " l_bma03.bma_file.bma03,",                                                                                        
               " l_bma04.bma_file.bma04,",
               " l_imb211.imb_file.imb211,",                                                                                        
               " l_imb212.imb_file.imb212,",                                                                                        
               " l_imb2131.imb_file.imb2131,",                                                                                      
               " l_imb2132.imb_file.imb2132,",                                                                                      
               " l_imb214.imb_file.imb214,",                                                                                        
               " l_imb219.imb_file.imb219,",
               " l_imb215.imb_file.imb215,",
               " l_imb216.imb_file.imb216,",
               " l_imb2171.imb_file.imb2171,",                                                                                      
               " l_imb2172.imb_file.imb2172,",
               " l_imb221.imb_file.imb221,",
               " l_imb220.imb_file.imb220,",
               " l_imb222.imb_file.imb222,",                                                                                        
               " l_imb2231.imb_file.imb2231,",                                                                                      
               " l_imb2232.imb_file.imb2232,",                                                                                      
               " l_imb224.imb_file.imb224,",                                                                                        
               " l_imb229.imb_file.imb229,",
               " l_imb230.imb_file.imb230,",
               " l_imb225.imb_file.imb225,",                                                                                        
               " l_imb226.imb_file.imb226,",
               " l_imb2271.imb_file.imb2271,",                                                                                      
               " l_imb2272.imb_file.imb2272,",
               " l_imz02.imz_file.imz02,",                                            
               " l_ver.ima_file.ima05,",
               " l_str2.cre_file.cre08,",
               " g_bma01_a.bma_file.bma01,",
               " g_bma06_a.bma_file.bma06,",     #No.MOD-830140 add ,
               " g_no.type_file.num10 "          #No.MOD-830140 add 
   LET l_table = cl_prt_temptable('abmr621',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_no = 1     #No.MOD-830140 add
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                            
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40116                                                                         
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?,?                        ) "          #No.MOD-830140 modify                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #No.TQC-7A0013  --End
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.arrange  = ARG_VAL(10)
   LET tm.cost  = ARG_VAL(11)
   LET tm.pur   = ARG_VAL(12)
  #LET tm.loc   = ARG_VAL(13) #FUN-510033
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r621_tm(0,0)			# Input print condition
      ELSE CALL abmr621()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r621_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,
          l_cmd		LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 7 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 7
   END IF
 
   OPEN WINDOW r621_w AT p_row,p_col
        WITH FORM "abm/42f/abmr621"
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
   LET tm.arrange ='1'              # 按元件料件編號遞增順序排列
   LET tm.cost ='1'                 # 1.現時成本 2.目標 3.標準成本)
   LET tm.pur  ='1'                 # 1.料件成本 2.最近進價 3.市價)
   LET tm.effective = g_today	    # 有效日期
  #LET tm.loc  ='1'  #FUN-510033
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
 
#No.FUN-570240  --start-
     ON ACTION controlp
           IF INFIELD(bma01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bma01
              NEXT FIELD bma01
           END IF
#No.FUN-570240 --end--
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r621_w 
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
                 " FROM bma_file,ima_file",
                 " WHERE bma01=ima01 AND ima08!='A' ",
                 "   AND ",tm.wc CLIPPED," GROUP BY bma01"
       PREPARE r621_precnt FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       DECLARE r621_cnt
            CURSOR FOR r621_precnt
       OPEN r621_cnt
       FETCH r621_cnt INTO g_cnt,l_bma01
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
       ELSE
           IF g_cnt=1 THEN
               LET l_one='Y'
           END IF
       END IF
       CLOSE r621_cnt
   END IF
 
   INPUT BY NAME tm.revision,tm.effective,
      tm.arrange,tm.cost,tm.pur,tm.more WITHOUT DEFAULTS  #FUN-510033 刪除tm.loc
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
      AFTER FIELD cost
         IF tm.cost NOT MATCHES '[1-3]' THEN
             NEXT FIELD cost
         END IF
      AFTER FIELD pur
         IF tm.pur  NOT MATCHES '[123]' THEN
             NEXT FIELD pur
         END IF
     #AFTER FIELD loc  #FUN-510033
     #   IF tm.loc IS NULL OR tm.loc  NOT MATCHES '[12]'
     #   THEN NEXT FIELD loc
     #   END IF
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
      ON ACTION CONTROLP CALL r621_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r621_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr621'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr621','9031',1)
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
                         " '",tm.arrange CLIPPED,"'",
                         " '",tm.cost CLIPPED,"'",
                         " '",tm.pur  CLIPPED,"'",     #FUN-510033
                        #" '",tm.loc  CLIPPED,"'",     #FUN-510033
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr621',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r621_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr621()
   ERROR ""
END WHILE
   CLOSE WINDOW r621_w
END FUNCTION
 
FUNCTION r621_wc()
   DEFINE l_wc    LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r621_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi600")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
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
 
   CLOSE WINDOW r621_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# abmr621()      從單頭讀取合乎條件的主件資料
# r621_bom()  處理元件及其相關的展開資料
FUNCTION abmr621()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_use_flag    LIKE type_file.chr2,     #No.FUN-680096 VARCHAR(2)
          l_ute_flag    LIKE type_file.chr3,     #No.FUN-680096 VARCHAR(2)   #FUN-A40058 chr2->chr3
          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)
          l_labcst      LIKE imb_file.imb111,    #人工成本
          l_bma01 LIKE bma_file.bma01,           #主件料件
          l_bma06 LIKE bma_file.bma06            #FUN-550095 add bma06
 
#No.TQC-7A0013  --Begin
   DEFINE l_cmd1        LIKE type_file.chr1000      #No.MOD-830140 add
   DEFINE p_level,p_i   LIKE type_file.num5,
          p_total       LIKE bmb_file.bmb06,
          l_k           LIKE type_file.num5, 
          l_total       LIKE bmb_file.bmb06,
          l_total_1     LIKE bmb_file.bmb06
                                                                          
  DEFINE  l_ima02    LIKE ima_file.ima02,    #品名規格                                                                                 
          l_ima021   LIKE ima_file.ima021,                                                                                
          l_ima05    LIKE ima_file.ima05,    #版本                                                                                     
          l_ima06    LIKE ima_file.ima06,    #版本                                                                                     
          l_ima08    LIKE ima_file.ima08,    #來源                                                                                     
          l_ima37    LIKE ima_file.ima37,    #補貨                                                                                     
          l_ima63    LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55    LIKE ima_file.ima55,    #生產單位                                                                                 
          l_bma02    LIKE bma_file.bma02,    #品名規格                                                                                 
          l_bma03    LIKE bma_file.bma03,    #品名規格                                                                                 
          l_bma04    LIKE bma_file.bma04,    #品名規格                                                                                 
          l_imb211   LIKE imb_file.imb211,                                                                                            
          l_imb212   LIKE imb_file.imb212,                                                                                            
          l_imb2131  LIKE imb_file.imb2131,                                                                                          
          l_imb2132  LIKE imb_file.imb2132,
          l_imb214   LIKE imb_file.imb214,                                                                                            
          l_imb219   LIKE imb_file.imb219,                                                                                            
          l_imb215   LIKE imb_file.imb215,                                                                                            
          l_imb216   LIKE imb_file.imb216,                                                                                            
          l_imb2171  LIKE imb_file.imb2171,                                                                                          
          l_imb2172  LIKE imb_file.imb2172,                                                                                          
          l_imb221   LIKE imb_file.imb221,                                                                                            
          l_imb220   LIKE imb_file.imb220,                                                                                            
          l_imb222   LIKE imb_file.imb222,                                                                                            
          l_imb2231  LIKE imb_file.imb2231,                                                                                          
          l_imb2232  LIKE imb_file.imb2232,                                                                                          
          l_imb224   LIKE imb_file.imb224,                                                                                            
          l_imb229   LIKE imb_file.imb229,                                                                                            
          l_imb230   LIKE imb_file.imb230,                                                                                            
          l_imb225   LIKE imb_file.imb225,                                                                                            
          l_imb226   LIKE imb_file.imb226,                                                                                            
          l_imb2271  LIKE imb_file.imb2271,                                                                                          
          l_imb2272  LIKE imb_file.imb2272,                                                                                          
          l_imz02    LIKE imz_file.imz02,        #說明內容                                                                             
          l_ver      LIKE ima_file.ima05,
          l_str2     LIKE cre_file.cre08
#No.TQC-7A0013  --End
 
     #No.TQC-7A0013  --Begin                                                                                                        
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     #No.TQC-7A0013  --End
 
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
 
     LET l_sql = "SELECT UNIQUE bma01,bma06 ", #FUN-550095 add bma06
                 " FROM bma_file, ima_file",
                 " WHERE ima01 = bma01",
                 " AND ima08!='A' AND ",tm.wc
     PREPARE r621_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r621_curs1 CURSOR FOR r621_prepare1
 
    #-No.TQC-7A0013  --Begin
    # CALL cl_outnam('abmr621') RETURNING l_name
    # START REPORT r621_rep TO l_name
    #-No.TQC-7A0013  --End
 
 
#No.CHI-6A0004----Begin------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#                              FROM azi_file
#                             WHERE azi01 =g_aza.aza17
#No.CHI-6A0004---End---
   # IF tm.loc ='1' THEN  #項次前置
   #     LET g_str = g_x[22][13,16],'       ',g_x[22][1,12]
   # ELSE
   #     LET g_str = g_x[22][1,12],'            ',g_x[22][13,16]
   # END IF
   # LET g_pageno = 0
 
 
     FOREACH r621_curs1 INTO l_bma01,l_bma06 #FUN-550095 add bma06
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01_a=l_bma01
       LET g_bma06_a=l_bma06 #FUN-550095
       LET g_imcstc=0   #間接材料成本
       LET g_labcstc=0  #下階直接人工成本
       LET g_fixo=0     #下階固定製造費用
       LET g_varo=0     #下階變動製造費用
       LET g_outc=0     #下階廠外加工成本
       LET g_outo=0     #下階廠外加工費用
       CALL r621_bom(0,l_bma01,l_bma06,1) RETURNING g_mcst #FUN-550095 add bma06
       #當下階的所有成本資料均列印後, 最後要列印主件的標準成本及
       #計算後成本資料, 表示方式, 以32700為其階層(level)
#--No.TQC-7A0013  --Begin
#      OUTPUT TO REPORT r621_rep(32700,0,0,0,0,l_bma01,0,0,0,0,'', #FUN-510033 add 0
#           0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0)
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver                                                                         
                                                                                                                                    
      SELECT ima02,ima021,ima05,ima06,ima08,                                                                                        
             ima37,ima55,ima63                                                                                                      
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,                                                                              
             l_ima37,l_ima55,l_ima63                                                                                                
        FROM ima_file                                                                                                               
       WHERE ima01=g_bma01_a                                                                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02=''                                                                                                            
          LET l_ima021=''                                                                                                           
          LET l_ima05=''                                                                                                            
          LET l_ima06=''                                                                                                            
          LET l_ima08=''                                                                                                            
          LET l_ima37=''                                                                                                            
      END IF                                                                                                                        
      SELECT bma02,bma03,bma04                                                                                                      
          INTO l_bma02,l_bma03,l_bma04                                                                                              
          FROM bma_file                                                                                                             
          WHERE bma01=g_bma01_a                                                                                                     
            AND bma06=g_bma06_a                                                                                                     
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_bma02=''
          LET l_bma03=''                                                                                                            
          LET l_bma04=''                                                                                                            
      END IF                                                                                                                        
      SELECT imz02 INTO l_imz02                                                                                                     
          FROM imz_file                                                                                                             
          WHERE imz01=l_ima06                                                                                                       
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_imz02=''                                                                                                            
      END IF
          CASE tm.cost                                                                                                              
          WHEN '1'        #現時成本                                                                                                 
              SELECT imb211, imb212, imb2131,imb2132,                                                                               
                     imb214, imb219, imb220, imb215,                                                                                
                     imb216, imb2171,imb2172,imb221,                                                                                
                     imb222, imb2231,imb2232,imb224,                                                                                
                     imb229, imb225, imb226, imb2271,                                                                               
                     imb2272,imb230                                                                                                 
                INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,                                                                     
                     l_imb214, l_imb219,  l_imb220,  l_imb215,                                                                      
                     l_imb216, l_imb2171, l_imb2172, l_imb221,                                                                      
                     l_imb222, l_imb2231, l_imb2232, l_imb224,                                                                      
                     l_imb229, l_imb225,  l_imb226,  l_imb2271,                                                                     
                     l_imb2272,l_imb230                                                                                             
                FROM imb_file                                                                                                       
               # WHERE imb01=sr.bmb03      #No.MOD-890035 mark by liuxqa
                 WHERE imb01=l_bma01       #No.MOD-890035 modify by liuxqa                                                                                                     
          WHEN '2'        #目標成本                                                                                                 
              SELECT imb311, imb312, imb3131, imb3132,                                                                              
                     imb314, imb319, imb320,  imb315,                                                                               
                     imb316, imb3171,imb3172, imb321,                                                                               
                     imb322, imb3231,imb3232, imb324,                                                                               
                     imb329, imb325, imb326,  imb3271,
                     imb3272,imb330                                                                                                 
                INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,                                                                     
                     l_imb214, l_imb219,  l_imb220,  l_imb215,                                                                      
                     l_imb216, l_imb2171, l_imb2172, l_imb221,                                                                      
                     l_imb222, l_imb2231, l_imb2232, l_imb224,                                                                      
                     l_imb229, l_imb225,  l_imb226,  l_imb2271,                                                                     
                     l_imb2272,l_imb230                                                                                             
                FROM imb_file                                                                                                       
               # WHERE imb01=sr.bmb03   #No.MOD-890035 mark by liuxqa
                 WHERE imb01=l_bma01    #No.MOD-890035 modify by liuxqa                                                                                               
          WHEN '3'       #標准成本                                                                                                  
              SELECT imb111, imb112, imb1131,imb1132,                                                                               
                     imb114, imb119, imb120, imb115,                                                                                
                     imb116, imb1171,imb1172,imb121,                                                                                
                     imb122, imb1231,imb1232,imb124,                                                                                
                     imb129, imb125, imb126, imb1271,                                                                               
                     imb1272,imb130                                                                                                 
                INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,                                                                     
                     l_imb214, l_imb219,  l_imb220,  l_imb215,                                                                      
                     l_imb216, l_imb2171, l_imb2172, l_imb221,                                                                      
                     l_imb222, l_imb2231, l_imb2232, l_imb224,                                                                      
                     l_imb229, l_imb225,  l_imb226,  l_imb2271,
                     l_imb2272,l_imb230                                                                                             
                FROM imb_file                                                                                                       
              #  WHERE imb01=sr.bmb03      #No.MOD-890035 mark by liuxqa
                 WHERE imb01=l_bma01       #No.MOD-890035 modify by liuxqa                                                                                               
          END CASE                                                                                                                  
          IF l_imb211 IS NULL THEN LET l_imb211=0 END IF                                                                            
          IF l_imb212 IS NULL THEN LET l_imb212=0 END IF                                                                            
          IF l_imb2131 IS NULL THEN LET l_imb2131=0 END IF                                                                          
          IF l_imb2132 IS NULL THEN LET l_imb2132=0 END IF                                                                          
          IF l_imb214 IS NULL THEN LET l_imb214=0 END IF                                                                            
          IF l_imb219 IS NULL THEN LET l_imb219=0 END IF                                                                            
          IF l_imb220 IS NULL THEN LET l_imb220=0 END IF                                                                            
          IF l_imb215 IS NULL THEN LET l_imb215=0 END IF                                                                            
          IF l_imb216 IS NULL THEN LET l_imb216=0 END IF                                                                            
          IF l_imb2171 IS NULL THEN LET l_imb2171=0 END IF                                                                          
          IF l_imb2172 IS NULL THEN LET l_imb2172=0 END IF                                                                          
          IF l_imb221 IS NULL THEN LET l_imb221=0 END IF                                                                            
          IF l_imb222 IS NULL THEN LET l_imb222=0 END IF                                                                            
          IF l_imb2231 IS NULL THEN LET l_imb2231=0 END IF                                                                          
          IF l_imb2232 IS NULL THEN LET l_imb2232=0 END IF                                                                          
          IF l_imb224 IS NULL THEN LET l_imb224=0 END IF                                                                            
          IF l_imb229 IS NULL THEN LET l_imb229=0 END IF                                                                            
          IF l_imb225 IS NULL THEN LET l_imb225=0 END IF
          IF l_imb226 IS NULL THEN LET l_imb226=0 END IF                                                                            
          IF l_imb2271 IS NULL THEN LET l_imb2271=0 END IF                                                                          
          IF l_imb2272 IS NULL THEN LET l_imb2272=0 END IF                                                                          
          IF l_imb230 IS NULL THEN LET l_imb230=0 END IF
 
          LET l_total_1=g_mcst+l_imb211+  l_imb212+  l_imb2131+                                                                       
                             l_imb214+  l_imb215+  l_imb216 +                                                                       
                             l_imb219+  l_imb2171+ l_imb2172+                                                                       
                             l_imb2132+ l_imb220+                                                                                   
                      g_imcstc+g_labcstc+g_fixo+ g_varo+g_outc+g_outo
 
       EXECUTE insert_prep USING '32700','0','0',l_total_1,'','',l_bma01,'',
                                 '','','',
                                 '0','0','','','','','0','0',
                                 '0','0','0','0',
                                 l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima37,l_ima63,l_ima55,l_bma02,l_bma03,
                                 l_bma04,l_imb211,l_imb212,l_imb2131,l_imb2132,l_imb214,l_imb219,l_imb215,l_imb216,
                                 l_imb2171,l_imb2172,l_imb221,l_imb220,l_imb222,l_imb2231,l_imb2232,l_imb224,
                                 l_imb229,l_imb230,l_imb225,l_imb226,l_imb2271,l_imb2272,l_imz02,l_ver,' ',
                                 l_bma01,l_bma06,g_no      #No.MOD-830140 add g_no                                                        
#--No.TQC-7A0013  --End
              LET g_no = g_no + 1     #No.MOD-830140 add
	  END FOREACH
 
    #DISPLAY "" AT 2,1
#    FINISH REPORT r621_rep                                #TQC-7A0013
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #TQC-7A0013  
#--No.TQC-7A0013  --Begin
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'bma01,bma06,ima06,ima09,ima10,ima11,ima12')                                                                                    
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET l_cmd1=l_cmd1 CLIPPED, " ORDER BY g_no"   #MOD-830140 add
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,l_cmd1 CLIPPED   #No.MOD-830140 modify                                                            
     LET g_str = g_str,";",tm.effective,";",tm.cost,";",tm.pur,";",g_azi03,";",g_azi05
     CALL cl_prt_cs3('abmr621','abmr621',g_sql,g_str)
END FUNCTION
 
FUNCTION r621_bom(p_level,p_key,p_key2,p_total) #FUN-550095 add p_key2
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
         #p_total       DECIMAL(13,5),
         #l_total       DECIMAL(13,5),
          p_total       LIKE bmb_file.bmb06,    #FUN-560227
          l_total       LIKE bmb_file.bmb06,    #FUN-560227
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_key2        LIKE bma_file.bma06,    #FUN-550095
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb15     LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16     LIKE bmb_file.bmb16,    #替代特性
              bmb03     LIKE bmb_file.bmb03,    #元件料號
              ima02     LIKE ima_file.ima02,    #品名規格
              ima021    LIKE ima_file.ima021,   #FUN-510033
              ima05     LIKE ima_file.ima05,    #版本
              ima08     LIKE ima_file.ima08,    #來源  #No.FUN-680096 VARCHAR(1)
            ##ima44     LIKE ima_file.ima44,    #採購單位  #No.FUN-610092 #NO.TQC-6C0034
              bmb10     LIKE bmb_file.bmb10,    #發料單位  #No.FUN-610092 #NO.TQC-6C0034
              bmb02     LIKE bmb_file.bmb02,    #項次
              bmb06     LIKE bmb_file.bmb06,    #QPA
              bmb10_fac LIKE bmb_file.bmb10_fac,    #發料單位
              bmb04     LIKE bmb_file.bmb04,        #有效日期
              bmb05     LIKE bmb_file.bmb05,        #失效日期
              bmb14     LIKE bmb_file.bmb14,        #元件使用特性
              bmb17     LIKE bmb_file.bmb17,        #Feature
              bma01     LIKE bma_file.bma01,   #No.FUN-680096 VARCHAR(20)
              mcsts     LIKE imb_file.imb111,  #直接材料成本
              cstmbfs   LIKE imb_file.imb112,  #間接材料分攤比率
              labcsts   LIKE imb_file.imb1131,  #直接人工成本
              cstsabs   LIKE imb_file.imb114,  #固定製造費用
              cstao2s   LIKE imb_file.imb115,  #變動製造費用
              outlabs   LIKE imb_file.imb116,  #廠外加工成本
              outmbfs   LIKE imb_file.imb116,  #廠外加工分攤比率
              purcost   LIKE imb_file.imb118   #本階採購成本
          END RECORD,
          l_material    LIKE imb_file.imb111,  #材料成本
          l_material_t  LIKE imb_file.imb111,  #材料成本
          l_unit        LIKE bmb_file.bmb10,
          l_unit_fac    LIKE bmb_file.bmb10_fac,
          l_ima44_fac   LIKE ima_file.ima44_fac,
          l_cmd		LIKE type_file.chr1000,#No.FUN-680096  VARCHAR(1000)
          g_sw          LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
#No.TQC-7A0013  --Begin                                                                                                             
   DEFINE p_i        LIKE type_file.num5,
          l_total_1  LIKE bmb_file.bmb06,
          l_ima02    LIKE ima_file.ima02,    #品名規格                                                                              
          l_ima021   LIKE ima_file.ima021,                                                                                          
          l_ima05    LIKE ima_file.ima05,    #版本                                                                                  
          l_ima06    LIKE ima_file.ima06,    #版本                                                                                  
          l_ima08    LIKE ima_file.ima08,    #來源                                                                                  
          l_ima37    LIKE ima_file.ima37,    #補貨                                                                                  
          l_ima63    LIKE ima_file.ima63,    #發料單位                                                                              
          l_ima55    LIKE ima_file.ima55,    #生產單位                                                                              
          l_bma02    LIKE bma_file.bma02,    #品名規格                                                                              
          l_bma03    LIKE bma_file.bma03,    #品名規格                                                                              
          l_bma04    LIKE bma_file.bma04,    #品名規格                                                                              
          l_imb211   LIKE imb_file.imb211,                                                                                          
          l_imb212   LIKE imb_file.imb212,                                                                                          
          l_imb2131  LIKE imb_file.imb2131,                                                                                         
          l_imb2132  LIKE imb_file.imb2132,                                                                                         
          l_imb214   LIKE imb_file.imb214,                                                                                          
          l_imb219   LIKE imb_file.imb219,                                                                                          
          l_imb215   LIKE imb_file.imb215,                                                                                          
          l_imb216   LIKE imb_file.imb216,                                                                                          
          l_imb2171  LIKE imb_file.imb2171,                                                                                         
          l_imb2172  LIKE imb_file.imb2172,
          l_imb221   LIKE imb_file.imb221,                                                                                          
          l_imb220   LIKE imb_file.imb220,                                                                                          
          l_imb222   LIKE imb_file.imb222,                                                                                          
          l_imb2231  LIKE imb_file.imb2231,                                                                                         
          l_imb2232  LIKE imb_file.imb2232,                                                                                         
          l_imb224   LIKE imb_file.imb224,                                                                                          
          l_imb229   LIKE imb_file.imb229,                                                                                          
          l_imb230   LIKE imb_file.imb230,                                                                                          
          l_imb225   LIKE imb_file.imb225,                                                                                          
          l_imb226   LIKE imb_file.imb226,                                                                                          
          l_imb2271  LIKE imb_file.imb2271,                                                                                         
          l_imb2272  LIKE imb_file.imb2272,                                                                                         
          l_imz02    LIKE imz_file.imz02,        #說明內容                                                                          
          l_ver      LIKE ima_file.ima05,                    
          l_k        LIKE type_file.num5,
          l_ute_flag LIKE type_file.chr3,  #FUN-A40058 chr2->chr3                                                                      
          l_str2     LIKE cre_file.cre08                                                                                            
#No.TQC-7A0013  --End
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
    LET p_level = p_level + 1
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',2)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
    END IF
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
 #       LET g_pageno = 0  #MOD-530217
        LET sr[1].bmb03 = p_key
#       OUTPUT TO REPORT r621_rep(1,0,1,sr[1].*)	#第0階主件資料     #TQC-7A0013
    END IF
#--No.TQC-7A0013  --Begin
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver                                                                         
                                                                                                                                    
      SELECT ima02,ima021,ima05,ima06,ima08,                                                                                        
             ima37,ima55,ima63                                                                                                      
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,                                                                              
             l_ima37,l_ima55,l_ima63                                                                                                
        FROM ima_file                                                                                                               
       WHERE ima01=g_bma01_a                                                                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02=''                                                                                                            
          LET l_ima021=''                                                                                                           
          LET l_ima05=''                                                                                                            
          LET l_ima06=''                                                                                                            
          LET l_ima08=''                                                                                                            
          LET l_ima37=''                                                                                                            
      END IF                                                                                                                        
      SELECT bma02,bma03,bma04                                                                                                      
          INTO l_bma02,l_bma03,l_bma04                                                                                              
          FROM bma_file                                                                                                             
          WHERE bma01=g_bma01_a                                                                                                     
            AND bma06=g_bma06_a
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_bma02=''                                                                                                            
          LET l_bma03=''                                                                                                            
          LET l_bma04=''                                                                                                            
      END IF                                                                                                                        
      SELECT imz02 INTO l_imz02                                                                                                     
          FROM imz_file                                                                                                             
          WHERE imz01=l_ima06                                                                                                       
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_imz02=''                                                                                                            
      END IF
                                                                                                                                    
          LET l_total_1=g_mcst+l_imb211+  l_imb212+  l_imb2131+                                                                     
                             l_imb214+  l_imb215+  l_imb216 +                                                                       
                             l_imb219+  l_imb2171+ l_imb2172+                                                                       
                             l_imb2132+ l_imb220+                                                                                   
                      g_imcstc+g_labcstc+g_fixo+ g_varo+g_outc+g_outo                                                               
                                                                                                                                    
              #--->改變替代特性的表示方式                                                                                           
              IF sr[1].bmb16 MATCHES '[127]' THEN        #FUN-A40058 add '7'                                                                                
                  LET l_ute_flag='USZ'                   #FUN-A40058 add 'Z'                                                                                               
                  LET g_cnt=sr[1].bmb16 USING '&'                                                                                      
                  LET sr[1].bmb16=l_ute_flag[g_cnt,g_cnt]                                                                              
              ELSE                                                                                                                  
                  LET sr[1].bmb16=' '                                                                                                  
              END IF                                                                                                                
              LET l_str2 = ' '                                                                                                      
              IF p_level>10 THEN LET p_level=10 END IF                                                                              
              IF p_level > 1 THEN 
                 FOR l_k = 1 TO p_level - 1                                                                                         
                   LET l_str2 = l_str2 clipped,'.' clipped                                                                          
                  END FOR                                                                                                           
              ELSE                                                                                                                  
                  LET l_str2 =''                                                                                                    
              END IF       
       EXECUTE insert_prep USING '1','0','1',l_total_1,sr[1].bmb15,sr[1].bmb16,sr[1].bmb03,sr[1].ima02,                          
                                 sr[1].ima021,sr[1].ima08,sr[1].bmb10,                                                                       
                                 sr[1].bmb02,sr[1].bmb06,sr[1].bmb04,sr[1].bmb05,sr[1].bmb14,sr[1].bmb17,sr[1].mcsts,sr[1].labcsts,                         
                                 sr[1].cstsabs,sr[1].cstao2s,sr[1].outlabs,sr[1].outmbfs,                                                       
                                 l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima37,l_ima63,l_ima55,l_bma02,l_bma03,                  
                                 l_bma04,'0','0','0','0','0','0','0','0',                 
                                 '0','0','0','0','0','0','0','0',                       
                                 '0','0','0','0','0','0',l_imz02,l_ver,l_str2,                      
                                 g_bma01_a,g_bma06_a,g_no     #No.MOD-830140 add g_no                                                                                                         
#--No.TQC-7A0013  --End
    LET g_no = g_no + 1    #MOD-830140 add
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
         ## "SELECT bmb15,bmb16,bmb03,ima02,ima021,ima05,ima08,bmb02,",  #FUN-510033 add ima021
         ## "SELECT bmb15,bmb16,bmb03,ima02,ima021,ima05,ima08,ima44,bmb02,",  #FUN-610092 #NO.TQC-6C0034
            "SELECT bmb15,bmb16,bmb03,ima02,ima021,ima05,ima08,bmb10,bmb02,",  #FUN-610092 #NO.TQC-6C0034
            "(bmb06/bmb07),bmb10_fac,bmb04,bmb05,bmb14,bmb17,bma01,"
        #皆以本階為主
        CASE tm.cost
           WHEN '1'
            LET l_cmd=l_cmd CLIPPED,
                "(imb211*bmb10_fac2),(imb212*bmb10_fac2),",
                "(imb2131+imb2132)*bmb10_fac2,",
                "(imb214+imb219)*bmb10_fac2,imb215*bmb10_fac2,",
                "imb216*bmb10_fac2,",
                "(imb2171+imb2172)*bmb10_fac2,imb218*bmb10_fac2"
           WHEN '2'
            LET l_cmd=l_cmd CLIPPED,
                "imb311*bmb10_fac2,imb312*bmb10_fac2,",
                "(imb3131+imb3132)*bmb10_fac2,",
                "(imb314+imb319)*bmb10_fac2,imb315*bmb10_fac2,",
                "imb316*bmb10_fac2,",
                "(imb3171+imb2172)*bmb10_fac2,imb318*bmb10_fac2"
           WHEN '3'
            LET l_cmd=l_cmd CLIPPED,
                "imb111*bmb10_fac2,imb112*bmb10_fac2,",
                "(imb1131+imb1132)*bmb10_fac2,",
                "(imb114+imb119)*bmb10_fac2,imb115*bmb10_fac2,",
                "imb116*bmb10_fac2,",
                "(imb1171+imb1172)*bmb10_fac2,imb118*bmb10_fac2"
        END CASE
        LET l_cmd=l_cmd CLIPPED,
            " FROM bmb_file,OUTER imb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
            " AND bmb29='",p_key2,"'", #FUN-550095 add
             " AND imb_file.imb01 = bmb_file.bmb03", #MOD-4B0170
            " AND bmb_file.bmb03 = ima_file.ima01",
            " AND bmb_file.bmb03 = bma_file.bma01",
            " AND ima_file.ima08 != 'A' "
#生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
        END IF
#排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY"
        IF tm.arrange='1' THEN
            LET l_cmd=l_cmd CLIPPED," bmb03"
        ELSE
            LET l_cmd=l_cmd CLIPPED," bmb02"
        END IF
#組完之後的句子, 將之準備成可以用的查詢命令
        PREPARE r621_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
           EXIT PROGRAM
              
        END IF
        DECLARE r621_cur CURSOR FOR r621_ppp
 
        LET l_material_t=0
#   WHILE TRUE
        LET l_ac = 1
        FOREACH r621_cur INTO sr[l_ac].*
            IF sr[l_ac].ima08 MATCHES '[PVZ]' THEN #採購件, 使用採購成本
            CASE tm.pur
                 WHEN '1'
                      LET sr[l_ac].mcsts=sr[l_ac].purcost
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                 WHEN '2'
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                      SELECT ima53,ima44,ima44_fac
                        INTO sr[l_ac].mcsts,l_unit,l_ima44_fac
                        FROM ima_file WHERE ima01=sr[l_ac].bmb03
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                   ##當發料單位與採購單位不同，直接由ima44_fac 與 bmb10_fac換算
                    # CALL s_umfchk(sr[l_ac].bmb03,l_unit,sr[l_ac].bmb10)
                    #      RETURNING g_sw,l_unit_fac
                    # IF g_sw THEN LET l_unit_fac = 1 END IF
                      LET l_unit_fac = sr[l_ac].bmb10_fac / l_ima44_fac
                      LET sr[l_ac].mcsts = sr[l_ac].mcsts * l_unit_fac
                 WHEN '3'
                      LET sr[l_ac].mcsts=sr[l_ac].purcost
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                      SELECT ima531,ima44,ima44_fac
                        INTO sr[l_ac].mcsts,l_unit,l_ima44_fac
                        FROM ima_file WHERE ima01=sr[l_ac].bmb03
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                   ##當發料單位與採購單位不同，直接由ima44_fac 與 bmb10_fac換算
                    # CALL s_umfchk(sr[l_ac].bmb03,l_unit,sr[l_ac].bmb10)
                    #      RETURNING g_sw,l_unit_fac
                    # IF g_sw THEN LET l_unit_fac = 1 END IF
                      LET l_unit_fac = sr[l_ac].bmb10_fac / l_ima44_fac
                      LET sr[l_ac].mcsts = sr[l_ac].mcsts * l_unit_fac
               END CASE
            END IF
            IF sr[l_ac].mcsts   IS NULL THEN LET sr[l_ac].mcsts=0   END IF
            IF sr[l_ac].cstmbfs IS NULL THEN LET sr[l_ac].cstmbfs=0 END IF
            IF sr[l_ac].labcsts IS NULL THEN LET sr[l_ac].labcsts=0 END IF
            IF sr[l_ac].cstsabs IS NULL THEN LET sr[l_ac].cstsabs=0 END IF
            IF sr[l_ac].cstao2s IS NULL THEN LET sr[l_ac].cstao2s=0 END IF
            IF sr[l_ac].outlabs IS NULL THEN LET sr[l_ac].outlabs=0 END IF
            IF sr[l_ac].outmbfs IS NULL THEN LET sr[l_ac].outmbfs=0 END IF
            #FUN-8B0015--BEGIN--                                                                                                     
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
 
         FOR i = 1 TO l_ac-1
            LET l_total=p_total*sr[i].bmb06               #元件之終階QPA
            LET sr[i].mcsts=sr[i].mcsts*l_total           #元件之本階直接材料成本     #MOD-B90073 add
            LET sr[i].labcsts=sr[i].labcsts*l_total       #元件之本階直人成本
            LET sr[i].cstsabs=sr[i].cstsabs*l_total       #元件之本階固定製費
            LET sr[i].cstao2s=sr[i].cstao2s*l_total       #元件之本階變動製費
            LET sr[i].outlabs=sr[i].outlabs*l_total       #元件之本階加工成本
            LET sr[i].outmbfs=sr[i].outmbfs*l_total       #本階託外費用
            LET g_fixo=g_fixo+sr[i].cstsabs               #主件之下階固定成本
            LET g_varo=g_varo+sr[i].cstao2s               #主件之下階變動成本
            LET g_labcstc=g_labcstc+sr[i].labcsts         #主件之下階直人成本
            LET g_outc=g_outc+sr[i].outlabs               #主件之下階加工成本
            LET g_outo=g_outo+sr[i].outmbfs               #主件之下階加工費用
            #材料成本之算法和其他的幾個成本的計算方式不同
            IF sr[i].bma01 IS NOT NULL AND
                sr[i].ima08 != 'P'  AND
                sr[i].ima08 != 'V'  AND
                sr[i].ima08 != 'Z'
            THEN
#CHI-680020---begin
#               OUTPUT TO REPORT r621_rep(p_level,i,l_total, sr[i].*)     #TQC-7A0013
#CHI-680020---end
#--No.TQC-7A0013  --Begin                                                                                                           
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver                                                                         
                                                                                                                                    
      SELECT ima02,ima021,ima05,ima06,ima08,                                                                                        
             ima37,ima55,ima63                                                                                                      
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,                                                                              
             l_ima37,l_ima55,l_ima63                                                                                                
        FROM ima_file                                                                                                               
       WHERE ima01=g_bma01_a                                                                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02=''                                                                                                            
          LET l_ima021=''                                                                                                           
          LET l_ima05=''                                                                                                            
          LET l_ima06=''                                                                                                            
          LET l_ima08=''                                                                                                            
          LET l_ima37=''                                                                                                            
      END IF                                                                                                                        
      SELECT bma02,bma03,bma04                                                                                                      
          INTO l_bma02,l_bma03,l_bma04                                                                                              
          FROM bma_file                                                                                                             
          WHERE bma01=g_bma01_a                                                                                                     
            AND bma06=g_bma06_a                                                                                                     
      IF SQLCA.sqlcode THEN
          LET l_bma02=''                                                                                                            
          LET l_bma03=''                                                                                                            
          LET l_bma04=''                                                                                                            
      END IF                                                                                                                        
      SELECT imz02 INTO l_imz02                                                                                                     
          FROM imz_file                                                                                                             
          WHERE imz01=l_ima06                                                                                                       
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_imz02=''                                                                                                            
      END IF                                                                                                                        
                                                                                                                                    
          LET l_total_1=g_mcst+l_imb211+  l_imb212+  l_imb2131+                                                                     
                             l_imb214+  l_imb215+  l_imb216 +                                                                       
                             l_imb219+  l_imb2171+ l_imb2172+                                                                       
                             l_imb2132+ l_imb220+                                                                                   
                      g_imcstc+g_labcstc+g_fixo+ g_varo+g_outc+g_outo
              #--->改變替代特性的表示方式                                                                                           
              IF sr[i].bmb16 MATCHES '[127]' THEN       #FUN-A40058 ADD '7'                                                                                 
                  LET l_ute_flag='USZ'                  #FUN-A40058 ADD 'Z'                                                                                    
                  LET g_cnt=sr[i].bmb16 USING '&'                                                                                      
                  LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]                                                                              
              ELSE                                                                                                                  
                  LET sr[i].bmb16=' '                                                                                                  
              END IF                                                                                                                
              LET l_str2 = ' '                                                                                                      
              IF p_level>10 THEN LET p_level=10 END IF                                                                              
              IF p_level > 1 THEN                                                                                                   
                 FOR l_k = 1 TO p_level - 1                                                                                         
                   LET l_str2 = l_str2 clipped,'.' clipped                                                                          
                  END FOR                                                                                                           
              ELSE                                                                                                                  
                  LET l_str2 =''                                                                                                    
              END IF  
       #EXECUTE insert_prep USING p_level,i,p_total,l_total_1,sr[i].bmb15,sr[i].bmb16,sr[i].bmb03,sr[i].ima02,  #TQC-970026
        EXECUTE insert_prep USING p_level,i,l_total,l_total_1,sr[i].bmb15,sr[i].bmb16,sr[i].bmb03,sr[i].ima02,  #TQC-970026                       
                                 sr[i].ima021,sr[i].ima08,sr[i].bmb10,                                                                       
                                 sr[i].bmb02,sr[i].bmb06,sr[i].bmb04,sr[i].bmb05,sr[i].bmb14,sr[i].bmb17,sr[i].mcsts,sr[i].labcsts,                         
                                 sr[i].cstsabs,sr[i].cstao2s,sr[i].outlabs,sr[i].outmbfs,                                                       
                                 l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima37,l_ima63,l_ima55,l_bma02,l_bma03,                  
                                 l_bma04,'0','0','0','0','0','0','0','0',                 
                                 '0','0','0','0','0','0','0','0',                       
                                 '0','0','0','0','0','0',l_imz02,l_ver,l_str2,                      
                                 g_bma01_a,g_bma06_a,g_no    #No.MOD-830140 add g_no                                                                                                              
#--No.TQC-7A0013  --End
                LET g_no = g_no + 1   #No.MOD-830140 add
               #CALL r621_bom(p_level,sr[i].bmb03,' ',l_total) #FUN-550095 add ' '#FUN-8B0015
                CALL r621_bom(p_level,sr[i].bmb03,l_ima910[i],l_total) #FUN-8B0015
                     RETURNING l_material
 
                #由下階所得之本階材料成本
                LET l_material_t=l_material_t+l_material
 
                #由下階累計之本階間接成本
                LET g_imcstc=g_imcstc+(sr[i].cstmbfs*l_total)
 
                #本階材料成本
                LET sr[i].mcsts=l_material+(sr[i].cstmbfs * l_total)
 
            ELSE #無下階之元件
                #由下階累計之下階間接成本
                LET g_imcstc=g_imcstc+(sr[i].cstmbfs*l_total)
 
                #由下階所得之本階材料成本
                LET l_material_t=l_material_t+(sr[i].mcsts * l_total)
 
                #本階材料成本
                LET sr[i].mcsts=sr[i].mcsts+(sr[i].cstmbfs*l_total)
#CHI-680020---begin
#           OUTPUT TO REPORT r621_rep(p_level,i,l_total, sr[i].*)              #TQC-7A0013
#--No.TQC-7A0013  --Begin                                                                                                           
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver                                                                         
                                                                                                                                    
      SELECT ima02,ima021,ima05,ima06,ima08,                                                                                        
             ima37,ima55,ima63                                                                                                      
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,                                                                              
             l_ima37,l_ima55,l_ima63                                                                                                
        FROM ima_file                                                                                                               
       WHERE ima01=g_bma01_a                                                                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02=''                                                                                                            
          LET l_ima021=''                                                                                                           
          LET l_ima05=''                                                                                                            
          LET l_ima06=''                                                                                                            
          LET l_ima08=''                                                                                                            
          LET l_ima37=''                                                                                                            
      END IF                                                                                                                        
      SELECT bma02,bma03,bma04                                                                                                      
          INTO l_bma02,l_bma03,l_bma04                                                                                              
          FROM bma_file                                                                                                             
          WHERE bma01=g_bma01_a                                                                                                     
            AND bma06=g_bma06_a
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_bma02=''                                                                                                            
          LET l_bma03=''                                                                                                            
          LET l_bma04=''                                                                                                            
      END IF                                                                                                                        
      SELECT imz02 INTO l_imz02                                                                                                     
          FROM imz_file                                                                                                             
          WHERE imz01=l_ima06                                                                                                       
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_imz02=''                                                                                                            
      END IF                                                                                                                        
                                                                                                                                    
          LET l_total_1=g_mcst+l_imb211+  l_imb212+  l_imb2131+                                                                     
                             l_imb214+  l_imb215+  l_imb216 +                                                                       
                             l_imb219+  l_imb2171+ l_imb2172+                                                                       
                             l_imb2132+ l_imb220+
                      g_imcstc+g_labcstc+g_fixo+ g_varo+g_outc+g_outo                                                               
                                                                                                                                    
              #--->改變替代特性的表示方式                                                                                           
              IF sr[i].bmb16 MATCHES '[127]' THEN        #FUN-A40058 ADD '7'                                                                                 
                  LET l_ute_flag='USZ'                   #FUN-A40058 ADD 'Z'                                                                                               
                  LET g_cnt=sr[i].bmb16 USING '&'                                                                                      
                  LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]                                                                              
              ELSE                                                                                                                  
                  LET sr[i].bmb16=' '                                                                                                  
              END IF                                                                                                                
              LET l_str2 = ' '                                                                                                      
              IF p_level>10 THEN LET p_level=10 END IF                                                                              
              IF p_level > 1 THEN                                                                                                   
                 FOR l_k = 1 TO p_level - 1                                                                                         
                   LET l_str2 = l_str2 clipped,'.' clipped                                                                          
                  END FOR                                                                                                           
              ELSE                                                                                                                  
                  LET l_str2 =''                                                                                                    
              END IF        
       #EXECUTE insert_prep USING p_level,i,p_total,l_total_1,sr[i].bmb15,sr[i].bmb16,sr[i].bmb03,sr[i].ima02,   #TQC-970026
       EXECUTE insert_prep USING p_level,i,l_total,l_total_1,sr[i].bmb15,sr[i].bmb16,sr[i].bmb03,sr[i].ima02,   #TQC-970026                       
                                 sr[i].ima021,sr[i].ima08,sr[i].bmb10,                                                                       
                                 sr[i].bmb02,sr[i].bmb06,sr[i].bmb04,sr[i].bmb05,sr[i].bmb14,sr[i].bmb17,sr[i].mcsts,sr[i].labcsts,                         
                                 sr[i].cstsabs,sr[i].cstao2s,sr[i].outlabs,sr[i].outmbfs,                                                       
                                 l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima37,l_ima63,l_ima55,l_bma02,l_bma03,                  
                                 l_bma04,'0','0','0','0','0','0','0','0',                 
                                 '0','0','0','0','0','0','0','0',                       
                                 '0','0','0','0','0','0',l_imz02,l_ver,l_str2,                      
                                 g_bma01_a,g_bma06_a,g_no     #No.MOD-830140 add g_no                                                                                                        
#--No.TQC-7A0013  --End
            LET g_no = g_no + 1  #No.MOD-830140 add
            END IF
#CHI-680020---mark
#           OUTPUT TO REPORT r621_rep(p_level,i,l_total, sr[i].*)
#CHI-680020---end
{
            IF sr[l_ac].ima08 MATCHES '[PVZ]' THEN
			   Exit FOR
            END IF
}
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
    RETURN l_material_t
END FUNCTION
 
#--TQC-7A0013--Mark--Begin
{# REPORT r621_rep(p_level,p_i,p_total,sr)
 # DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
 #        p_level,p_i,ptcode,ptcode1,ptcode2	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
 #       #p_total       DECIMAL(13,5),
 #       #l_total       DECIMAL(14,5),
 #        p_total       LIKE bmb_file.bmb06, #FUN-560227
 #        l_total       LIKE bmb_file.bmb06, #FUN-560227
 #        sr  RECORD
 #            bmb15       LIKE bmb_file.bmb15,    #元件耗用特性
 #            bmb16       LIKE bmb_file.bmb16,    #替代特性
 #            bmb03       LIKE bmb_file.bmb03,    #元件料號
 #            ima02       LIKE ima_file.ima02,    #品名規格
 #            ima021      LIKE ima_file.ima021,  #FUN-510033
 #            ima05       LIKE ima_file.ima05,    #版本
 #            ima08       LIKE ima_file.ima08,    #來源
 #          ##ima44       LIKE ima_file.ima44,    #採購單位  #No.FUN-610092 #NO.TQC-6C0034
 #            bmb10       LIKE bmb_file.bmb10,    #發料單位  #No.FUN-610092 #NO.TQC-6C0034
 #            bmb02       LIKE bmb_file.bmb02,    #項次
 #            bmb06       LIKE bmb_file.bmb06,    #QPA
 #            bmb10_fac   LIKE bmb_file.bmb10_fac,#發料單位
 #            bmb04       LIKE bmb_file.bmb04,    #有效日期
 #            bmb05       LIKE bmb_file.bmb05,    #失效日期
 #            bmb14       LIKE bmb_file.bmb14,    #元件使用特性
 #            bmb17       LIKE bmb_file.bmb17,    #Feature
 #            bma01       LIKE bma_file.bma01,    #No.FUN-680096 VARCHAR(20)
 #            mcsts       LIKE imb_file.imb111,  #直接材料成本
 #            cstmbfs     LIKE imb_file.imb112,  #間接材料分攤比率
 #            labcsts     LIKE imb_file.imb1131,  #直接人工成本
 #            cstsabs     LIKE imb_file.imb114,  #固定製造費用
 #            cstao2s     LIKE imb_file.imb115,  #變動製造費用
 #            outlabs     LIKE imb_file.imb116,  #廠外加工成本
 #            outmbfs     LIKE imb_file.imb1171,  #廠外加工費用
 #            purcost     LIKE imb_file.imb118  #本階採購成本
 #        END RECORD,
 #        l_ima02 LIKE ima_file.ima02,    #品名規格
 #        l_ima021 LIKE ima_file.ima021,  #FUN-510033
 #        l_ima05 LIKE ima_file.ima05,    #版本
 #        l_ima06 LIKE ima_file.ima06,    #版本
 #        l_ima08 LIKE ima_file.ima08,    #來源
 #        l_ima37 LIKE ima_file.ima37,    #補貨
 #        l_ima63 LIKE ima_file.ima63,    #發料單位
 #        l_ima55 LIKE ima_file.ima55,    #生產單位
 #        l_bma02 LIKE bma_file.bma02,    #品名規格
 #        l_bma03 LIKE bma_file.bma03,    #品名規格
 #        l_bma04 LIKE bma_file.bma04,    #品名規格
 #        l_imb211 LIKE imb_file.imb211,
 #        l_imb212 LIKE imb_file.imb212,
 #        l_imb2131 LIKE imb_file.imb2131,
 #        l_imb2132 LIKE imb_file.imb2132,
 #        l_imb214 LIKE imb_file.imb214,
 #        l_imb219 LIKE imb_file.imb219,
 #        l_imb215 LIKE imb_file.imb215,
 #        l_imb216 LIKE imb_file.imb216,
 #        l_imb2171 LIKE imb_file.imb2171,
 #        l_imb2172 LIKE imb_file.imb2172,
 #        l_imb221 LIKE imb_file.imb221,
 #        l_imb220 LIKE imb_file.imb220,
 #        l_imb222 LIKE imb_file.imb222,
 #        l_imb2231 LIKE imb_file.imb2231,
 #        l_imb2232 LIKE imb_file.imb2232,
 #        l_imb224 LIKE imb_file.imb224,
 #        l_imb229 LIKE imb_file.imb229,
 #        l_imb230 LIKE imb_file.imb230,
 #        l_imb225 LIKE imb_file.imb225,
 #        l_imb226 LIKE imb_file.imb226,
 #        l_imb2271 LIKE imb_file.imb2271,
 #        l_imb2272 LIKE imb_file.imb2272,
 #        l_imz02 LIKE imz_file.imz02,        #說明內容
 #        l_ver     LIKE ima_file.ima05, 
 #        l_use_flag    LIKE type_file.chr2,   #No.FUN-680096 VARCHAR(2)  
 #        l_ute_flag    LIKE type_file.chr2,   #No.FUN-680096 VARCHAR(2)
 #        l_str2        LIKE cre_file.cre08,   #No.FUN-680096 VARCHAR(10)
 #        l_now,l_k    LIKE type_file.num5     #No.FUN-680096 SMALLINT
 #OUTPUT TOP MARGIN g_top_margin
 #       LEFT MARGIN g_left_margin
 #       BOTTOM MARGIN g_bottom_margin
 #       PAGE LENGTH g_page_line
 #FORMAT
 # PAGE HEADER
 #    CASE tm.cost
 #		  WHEN '1' LET ptcode1 = 57
 #		  WHEN '2' LET ptcode1 = 58
 #		  WHEN '3' LET ptcode1 = 59
 #    END CASE
 #    CASE tm.pur
 #       	  WHEN '1' LET ptcode2= 60
 #		  WHEN '2' LET ptcode2= 61
 #		  WHEN '3' LET ptcode2= 62
 #    END CASE
 #    PRINT
 #    #有效日期
 #    CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
 
 #    SELECT ima02,ima021,ima05,ima06,ima08,
 #           ima37,ima55,ima63
 #      INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
 #           l_ima37,l_ima55,l_ima63
 #      FROM ima_file
 #     WHERE ima01=g_bma01_a
 #    IF SQLCA.sqlcode THEN
 #        LET l_ima02=''
 #        LET l_ima021=''
 #        LET l_ima05=''
 #        LET l_ima06=''
 #        LET l_ima08=''
 #        LET l_ima37=''
 #    END IF
 #    SELECT bma02,bma03,bma04
 #        INTO l_bma02,l_bma03,l_bma04
 #        FROM bma_file
 #        WHERE bma01=g_bma01_a
 #          AND bma06=g_bma06_a #FUN-550095 add
 #    IF SQLCA.sqlcode THEN
 #        LET l_bma02=''
 #        LET l_bma03=''
 #        LET l_bma04=''
 #    END IF
 #    SELECT imz02 INTO l_imz02
 #        FROM imz_file
 #        WHERE imz01=l_ima06
 #    IF SQLCA.sqlcode THEN
 #        LET l_imz02=''
 #    END IF
 
 #    PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
 #    PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 #    LET g_pageno = g_pageno + 1
 #    LET pageno_total = PAGENO USING '<<<',"/pageno"
 #    PRINT g_head CLIPPED,pageno_total
 #    PRINT COLUMN 01,g_x[30] CLIPPED,tm.effective,
 #          COLUMN 21,g_x[67] CLIPPED,l_ver,
 #          COLUMN 41,g_x[63] CLIPPED,g_x[ptcode1] CLIPPED,
 #          COLUMN 71,g_x[64] CLIPPED,g_x[ptcode2] CLIPPED
 #    PRINT g_dash
 #    #----
 #    PRINT g_x[11] CLIPPED, l_ima06,' ',l_imz02
 #    PRINT g_x[12] CLIPPED, g_bma01_a CLIPPED,' ',g_bma06_a CLIPPED, #FUN-550095 add bma06
 #          COLUMN 71, g_x[13] CLIPPED, l_ima05,
 #          COLUMN 81, g_x[14] CLIPPED, l_ima08,
 #          COLUMN 91, g_x[15] CLIPPED, l_ima37,
 #          COLUMN 101,g_x[53] CLIPPED, l_ima63,
 #          COLUMN 116,g_x[54] CLIPPED, l_ima55
 #    PRINT g_x[19] CLIPPED,l_ima02
 #    PRINT g_x[20] CLIPPED,l_ima021
 #    PRINT g_x[16] CLIPPED, l_bma02         #工程變異單
 #    PRINT g_x[17] CLIPPED, l_bma04         #參考單號
 #    PRINT g_x[18] CLIPPED, l_bma03         #工程變異日期
 #    PRINT ' '
 #    #----
 #    PRINTX name=H1 g_x[71],g_x[72],g_x[73],g_x[74],g_x[75],g_x[76],g_x[77],g_x[78],g_x[79]
 #    PRINTX name=H2 g_x[80],g_x[81],g_x[82],g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88]
 #    PRINT g_dash1
 #    LET l_last_sw = 'n'
 
 #  ON EVERY ROW
 #    IF p_level=32700 THEN  #處理主件的累計資料
 #        SKIP 1 LINES
 #        CASE tm.cost
 #        WHEN '1'        #現時成本
 #            SELECT imb211, imb212, imb2131,imb2132,
 #                   imb214, imb219, imb220, imb215,
 #		     imb216, imb2171,imb2172,imb221,
 #                   imb222, imb2231,imb2232,imb224,
 #                   imb229, imb225, imb226, imb2271,
 #                   imb2272,imb230
 #              INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
 #                   l_imb214, l_imb219,  l_imb220,  l_imb215,
 #                   l_imb216, l_imb2171, l_imb2172, l_imb221,
 #                   l_imb222, l_imb2231, l_imb2232, l_imb224,
 #                   l_imb229, l_imb225,  l_imb226,  l_imb2271,
 #                   l_imb2272,l_imb230
 #              FROM imb_file
 #              WHERE imb01=sr.bmb03
 #        WHEN '2'        #目標成本
 #            SELECT imb311, imb312, imb3131, imb3132,
 #                   imb314, imb319, imb320,  imb315,
 #                   imb316, imb3171,imb3172, imb321,
 #                   imb322, imb3231,imb3232, imb324,
 #                   imb329, imb325, imb326,  imb3271,
 #                   imb3272,imb330
 #              INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
 #                   l_imb214, l_imb219,  l_imb220,  l_imb215,
 #                   l_imb216, l_imb2171, l_imb2172, l_imb221,
 #                   l_imb222, l_imb2231, l_imb2232, l_imb224,
 #                   l_imb229, l_imb225,  l_imb226,  l_imb2271,
 #                   l_imb2272,l_imb230
 #              FROM imb_file
 #              WHERE imb01=sr.bmb03
 #        WHEN '3'       #標準成本
 #            SELECT imb111, imb112, imb1131,imb1132,
 #                   imb114, imb119, imb120, imb115,
 #		     imb116, imb1171,imb1172,imb121,
 #                   imb122, imb1231,imb1232,imb124,
 #                   imb129, imb125, imb126, imb1271,
 #                   imb1272,imb130
 #              INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
 #                   l_imb214, l_imb219,  l_imb220,  l_imb215,
 #                   l_imb216, l_imb2171, l_imb2172, l_imb221,
 #                   l_imb222, l_imb2231, l_imb2232, l_imb224,
 #                   l_imb229, l_imb225,  l_imb226,  l_imb2271,
 #                   l_imb2272,l_imb230
 #              FROM imb_file
 #              WHERE imb01=sr.bmb03
 #        END CASE
 #        IF l_imb211 IS NULL THEN LET l_imb211=0 END IF
 #        IF l_imb212 IS NULL THEN LET l_imb212=0 END IF
 #        IF l_imb2131 IS NULL THEN LET l_imb2131=0 END IF
 #        IF l_imb2132 IS NULL THEN LET l_imb2132=0 END IF
 #        IF l_imb214 IS NULL THEN LET l_imb214=0 END IF
 #        IF l_imb219 IS NULL THEN LET l_imb219=0 END IF
 #        IF l_imb220 IS NULL THEN LET l_imb220=0 END IF
 #        IF l_imb215 IS NULL THEN LET l_imb215=0 END IF
 #        IF l_imb216 IS NULL THEN LET l_imb216=0 END IF
 #        IF l_imb2171 IS NULL THEN LET l_imb2171=0 END IF
 #        IF l_imb2172 IS NULL THEN LET l_imb2172=0 END IF
 #        IF l_imb221 IS NULL THEN LET l_imb221=0 END IF
 #        IF l_imb222 IS NULL THEN LET l_imb222=0 END IF
 #        IF l_imb2231 IS NULL THEN LET l_imb2231=0 END IF
 #        IF l_imb2232 IS NULL THEN LET l_imb2232=0 END IF
 #        IF l_imb224 IS NULL THEN LET l_imb224=0 END IF
 #        IF l_imb229 IS NULL THEN LET l_imb229=0 END IF
 #        IF l_imb225 IS NULL THEN LET l_imb225=0 END IF
 #        IF l_imb226 IS NULL THEN LET l_imb226=0 END IF
 #        IF l_imb2271 IS NULL THEN LET l_imb2271=0 END IF
 #        IF l_imb2272 IS NULL THEN LET l_imb2272=0 END IF
 #        IF l_imb230 IS NULL THEN LET l_imb230=0 END IF
 
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[31]),
 #              g_x[31] CLIPPED,cl_numfor(l_imb211 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[32]),
 #              g_x[32] CLIPPED,cl_numfor(l_imb212 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[33]),
 #              g_x[33] CLIPPED,cl_numfor(l_imb2131,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[65]),
 #              g_x[65] CLIPPED,cl_numfor(l_imb2132,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[34]),
 #              g_x[34] CLIPPED,cl_numfor(l_imb219 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[35]),
 #              g_x[35] CLIPPED,cl_numfor(l_imb214 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[36]),
 #              g_x[36] CLIPPED,cl_numfor(l_imb215 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[37]),
 #              g_x[37] CLIPPED,cl_numfor(l_imb216 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[38]),
 #              g_x[38] CLIPPED,cl_numfor(l_imb2171,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[39]),
 #              g_x[39] CLIPPED,cl_numfor(l_imb2172,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[66]),
 #              g_x[66] CLIPPED,cl_numfor(l_imb220 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[40]),
 #              g_x[40] CLIPPED,cl_numfor(l_imb221 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[41]),
 #              g_x[41] CLIPPED,cl_numfor(l_imb222 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[42]),
 #              g_x[42] CLIPPED,cl_numfor(l_imb2231,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[65]),
 #              g_x[65] CLIPPED,cl_numfor(l_imb2232,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[43]),
 #              g_x[43] CLIPPED,cl_numfor(l_imb229 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[44]),
 #              g_x[44] CLIPPED,cl_numfor(l_imb224 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[45]),
 #              g_x[45] CLIPPED,cl_numfor(l_imb225 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[46]),
 #              g_x[46] CLIPPED,cl_numfor(l_imb226 ,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[47]),
 #              g_x[47] CLIPPED,cl_numfor(l_imb2271,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[48]),
 #              g_x[48] CLIPPED,cl_numfor(l_imb2272,16,g_azi05)
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[66]),
 #              g_x[66] CLIPPED,cl_numfor(l_imb230 ,16,g_azi05)
 #        PRINT COLUMN 112, '-----------------'
 #        #(標準/現時/預設)成本
 #        LET l_total= l_imb211+  l_imb212 + l_imb2131 + l_imb2132 +
 #                     l_imb214+  l_imb219 + l_imb220  + l_imb215 +
 #                     l_imb216+  l_imb2171+ l_imb2172 + l_imb221 +
 #                     l_imb222+  l_imb2231+ l_imb2232 + l_imb224 +
 #                     l_imb229+  l_imb225 + l_imb226  + l_imb2271 +
 #                     l_imb2272+ l_imb230
 #       CASE tm.cost
 #			WHEN '1'
 #       		   LET ptcode=49
 #			WHEN '2'
 #			   LET ptcode=55
 #			WHEN '3'
 #			   LET ptcode=56
 #        END CASE
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[ptcode]),
 #              g_x[ptcode] CLIPPED,
 #              cl_numfor(l_total,16,g_azi05)
 #        LET l_total=g_mcst+l_imb211+  l_imb212+  l_imb2131+
 #                           l_imb214+  l_imb215+  l_imb216 +
 #                           l_imb219+  l_imb2171+ l_imb2172+
 #                           l_imb2132+ l_imb220+
 #                    g_imcstc+g_labcstc+g_fixo+ g_varo+g_outc+g_outo
 #       CASE tm.cost
 #			WHEN '1'
 #       		   LET ptcode=50
 #			WHEN '2'
 #			   LET ptcode=51
 #			WHEN '3'
 #			   LET ptcode=52
 #        END CASE
 #        PRINT COLUMN 113-FGL_WIDTH(g_x[ptcode]),g_x[ptcode] CLIPPED;
 #        PRINT cl_numfor(l_total,16,g_azi05)
 #    ELSE
 #        IF p_level = 1 AND p_i = 0 THEN
 #             IF (PAGENO > 1 OR LINENO > 16) THEN
 #                   LET g_pageno = 0  #MOD-530217
 #                  SKIP TO TOP OF PAGE
 #             END IF
 #        ELSE
 #            #--->消耗性料件
 #            IF sr.bmb15 ='Y' THEN
 #               LET sr.bmb15='*'
 #            ELSE
 #                LET sr.bmb15=' '
 #            END IF
 #            #--->改變替代特性的表示方式
 #            IF sr.bmb16 MATCHES '[12]' THEN
 #                LET l_ute_flag='US'
 #                LET g_cnt=sr.bmb16 USING '&'
 #                LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
 #            ELSE
 #                LET sr.bmb16=' '
 #            END IF
 #            #--->使用特性的表示方式
 #            IF sr.bmb14 ='1'
 #            THEN LET sr.bmb14 ='O'
 #            ELSE LET sr.bmb14 = ' '
 #            END IF
 #            #--->特性料件
 #            IF sr.bmb17='Y' THEN
 #                LET sr.bmb17='F'
 #            ELSE
 #                LET sr.bmb17=' '
 #            END IF
 #            LET l_str2 = ' '
 #            IF p_level>10 THEN LET p_level=10 END IF
 #           #No.+155 010528 by plum
 #           #IF p_level !=0 THEN
 #           #   FOR l_k = 1 TO p_level
 #            IF p_level > 1 THEN
 #               FOR l_k = 1 TO p_level - 1
 #           #No.+155..end
 #                 LET l_str2 = l_str2 clipped,'.' clipped
 #                END FOR
 #            ELSE
 #                LET l_str2 =''
 #            END IF
 
 #           #IF tm.loc ='1' THEN    #項次前置
 #           #   PRINT column p_level+4,sr.bmb02 using'<<<',
 #           #         column 17,sr.bmb03;
 #           #ELSE                 #元件前置
 #           #   PRINT column 5,l_str2 clipped,sr.bmb03 clipped,
 #           #         column 36,sr.bmb02 using'###';
 #           #END IF
 #           PRINTX name=D1 COLUMN g_c[71],sr.bmb14,'/',sr.bmb15,
 #                          COLUMN g_c[72],l_str2 clipped,sr.bmb03 clipped,
 #                          COLUMN g_c[73],sr.bmb02 using '####',
 #                          COLUMN g_c[74],sr.ima02,
 #                          COLUMN g_c[75],sr.ima08,
 #                          COLUMN g_c[76],sr.bmb04,
 #                          COLUMN g_c[77],cl_numfor(sr.bmb06,77,3),
 #                          COLUMN g_c[78],cl_numfor(sr.mcsts,78,g_azi03) clipped,
 #                          COLUMN g_c[79],cl_numfor(sr.labcsts,79,g_azi03) clipped
 #           PRINTX name=D2 COLUMN g_c[80],sr.bmb16,'/',sr.bmb17,
 #                          COLUMN g_c[81],' ',
 #                          COLUMN g_c[82],' ',
 #                          COLUMN g_c[83],sr.ima021,
 #                       ## COLUMN g_c[84],sr.ima44,    #No.FUN-610092 #NO.TQC-6C0034
 #                          COLUMN g_c[84],sr.bmb10,    #No.FUN-610092 #NO.TQC-6C0034
 #                          COLUMN g_c[85],sr.bmb05,
 #                          COLUMN g_c[86],cl_numfor(p_total,86,3),
 #                          COLUMN g_c[87],cl_numfor(sr.cstsabs+sr.cstao2s,87,g_azi03) clipped,
 #                          COLUMN g_c[88],cl_numfor(sr.outlabs+sr.outmbfs,88,g_azi03) clipped
 #        END IF
 #    END IF
 
 # ON LAST ROW
 #    LET l_last_sw = 'y'
 
 # PAGE TRAILER
 #    PRINT ' '
 #    PRINT g_dash
 #    IF l_last_sw = 'y'
 #       THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 #       ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
 #    END IF
#END REPORT}
#--TQC-7A0013-Mark-End
#Patch....NO.TQC-610035 <001> #
