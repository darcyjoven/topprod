# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmr100.4gl
# Descriptions...: 單階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 94/06/07 By Apple
# Modify.........: No.FUN-560030 05/06/13 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.TQC-5B0105 05/11/11 By Mandy 報表的單號/料號/品名/規各對齊調整
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.TQC-630271 06/03/29 BY yiting q_ima5 改為q_bmo3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-850044 08/05/12 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單 
# Modify.........: No.FUN-8A0103 08/10/27 By jan 增加取替代資料打印
# Modify.........: No.MOD-920242 09/02/19 By claire bmo06關聯條件錯誤
# Modify.........: No.TQC-920067 09/02/20 By claire bmo06關聯條件錯誤
# Modify.........: No.MOD-930098 09/03/10 By shiwuying 底數如果為1不會顯示在報表
# Modify.........: No.TQC-970042 09/07/03 By sherry 取替代料的QPA沒有進行換算
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:TQC-C20170 12/02/14 By bart tm.wc型態改為STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
       		#wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)  #TQC-C20170 mark
            wc        STRING,    #TQC-C20170
        	# Prog. Version..: '5.30.06-13.03.12(04),               # 分群碼            #TQC-610068
                # Prog. Version..: '5.30.06-13.03.12(02),              # 版本              #TQC-610068
                #engine    VARCHAR(1),               # 是否列印工程資料  #TQC-610068
              # a         LIKE type_file.num10,   #No.FUN-680096 INTEGER #No.MOD-930098
                a         LIKE sfb_file.sfb08,    #No.MOD-930098
                s         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                blow      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                vender    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                b         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                d         LIKE type_file.chr1,    #No.FUN-8A0103
   	      	more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          sr  RECORD
              order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(20)
              bmo01 LIKE bmo_file.bmo01,    #主件料件
              bmo011 LIKE bmo_file.bmo011,  #版本
              bmo06 LIKE bmo_file.bmo06,    #FUN-560030
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp03 LIKE bmp_file.bmp03,    #元件料號
              bmp04 LIKE bmp_file.bmp04,    #有效日期
              bmp05 LIKE bmp_file.bmp05,    #失效日期
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp07 LIKE bmp_file.bmp07,    #底數
              bmp08 LIKE bmp_file.bmp08,    #損耗率%
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp13 LIKE bmp_file.bmp13,    #插件位置
              bmp16 LIKE bmp_file.bmp16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              phatom LIKE ima_file.ima01    #虛擬料件
          END RECORD,
          g_bmo01 LIKE bmo_file.bmo01
 
DEFINE   g_cnt    LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE   g_i      LIKE type_file.num5       #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   l_table1 STRING                    #No.FUN-850044
DEFINE   l_table2 STRING                    #No.FUN-850044 
DEFINE   l_table3 STRING                    #No.FUN-850044 
DEFINE   l_table4 STRING                    #No.FUN-850044 
DEFINE   l_table5 STRING                    #No.FUN-8A0103
DEFINE   g_sql    STRING                    #No.FUN-850044       
DEFINE   g_str    STRING                    #No.FUN-850044       
 
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
 
   #No.FUN-850044  --BEGIN
   LET g_sql = "order1.bmp_file.bmp02,",                                                                  
               "bmo01.bmo_file.bmo01,",    #主件料件                                                                               
               "bmo011.bmo_file.bmo011,",  #版本                                                                                   
               "bmo06.bmo_file.bmo06,",                                                                               
               "bmp02.bmp_file.bmp02,",    #項次                                                                                   
               "bmp03.bmp_file.bmp03,",    #元件料號                                                                               
               "bmp04.bmp_file.bmp04,",    #有效日期                                                                               
               "bmp05.bmp_file.bmp05,",    #失效日期                                                                               
               "bmp06.bmp_file.bmp06,",    #QPA                                                                                    
               "bmp07.bmp_file.bmp07,",    #底數                                                                                   
               "bmp08.bmp_file.bmp08,",    #損耗率%                                                                                
               "bmp10.bmp_file.bmp10,",    #發料單位                                                                               
               "bmp13.bmp_file.bmp13,",    #插件位置                                                                               
               "bmp16.bmp_file.bmp16,",    #替代特性                                                                               
               "ima02.ima_file.ima02,",    #品名規格                                                                               
               "ima021.ima_file.ima021,",                                                                             
               "ima05.ima_file.ima05,",    #版本                                                                                   
               "ima08.ima_file.ima08,",    #來源                                                                                   
               "ima15.ima_file.ima15,",    #來源                                                                                   
               "phatom.ima_file.ima01,",   #虛擬料件   
               "l_ima02.ima_file.ima02,",
               "l_ima05.ima_file.ima05,",
               "l_ima08.ima_file.ima08,",
               "l_ima63.ima_file.ima63,",
               "l_ima55.ima_file.ima55"      
   LET l_table1 = cl_prt_temptable('abmr1001',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "bec01.bec_file.bec01,",
               "bec02.bec_file.bec02,",
               "bec021.bec_file.bec021,",
               "bec011.bec_file.bec011,",
               "bec03.bec_file.bec03,",
               "bec04.bec_file.bec04,",
               "bec05.type_file.chr1000"
   LET l_table2 = cl_prt_temptable('abmr1002',g_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN EXIT PROGRAM END IF   
 
   LET g_sql = "bel01.bel_file.bel01,",
               "bel02.bel_file.bel02,",
               "bel011.bel_file.bel011,",
               "bel03.bel_file.bel03,",
               "bel04.type_file.chr1000"
   LET l_table3 = cl_prt_temptable('abmr1003',g_sql) CLIPPED                                                                        
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "bmu01.bmu_file.bmu01,",
               "bmu02.bmu_file.bmu02,",
               "bmu03.bmu_file.bmu03,",
               "bmu011.bmu_file.bmu011,",
               "bmu06.type_file.chr1000"
   LET l_table4 = cl_prt_temptable('abmr1004',g_sql) CLIPPED
   IF l_table4 =-1 THEN EXIT PROGRAM END IF
   #No.FUN-850044  --END
   #No.FUN-8A0103--BEGIN--
   LET g_sql = "bed01.bed_file.bed01,",
               "bed011.bed_file.bed011,",
               "bed012.bed_file.bed012,",
               "bmp16.bmp_file.bmp16,",
               "bed04.bed_file.bed04,",
               "bed05.bed_file.bed05,",
               "bed06.bed_file.bed06,",
               "bed07.bed_file.bed07,",
               "l_ima02_b.ima_file.ima02,",
               "l_ima021_b.ima_file.ima021"
   LET l_table5 = cl_prt_temptable('abmr1005',g_sql) CLIPPED
   IF l_table5 =-1 THEN EXIT PROGRAM END IF
   #No.FUN-8A0103--END--
                
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
  #LET tm.engine= ARG_VAL(8) #TQC-610068
   LET tm.a     = ARG_VAL(9)
   LET tm.s     = ARG_VAL(10)
   LET tm.blow  = ARG_VAL(11)
   LET tm.vender= ARG_VAL(12)
   LET tm.b     = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r100_tm(0,0)			# Input print condition
      ELSE CALL r100()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r100_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          l_date        LIKE type_file.dat,      #No.FUN-680096 DATE
          l_bmp01       LIKE bmp_file.bmp01,	 #
          l_bmp011      LIKE bmp_file.bmp011,    #
          l_cmd		    LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
          l_sql         STRING     #TQC-C20170
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 11
   END IF
 
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "abm/42f/abmr100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560030................begin
    CALL cl_set_comp_visible("acode",g_sma.sma118='Y')
    #FUN-560030................end
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.engine ='N'           #不列印工程技術資料  #TQC-610068
  #---------No.FUN-670041 modify
  #LET tm.blow = g_sma.sma29
   LET tm.blow = 'Y'
  #---------No.FUN-670041 modify
   LET tm.a    = 1
   LET tm.s    = g_sma.sma65
   LET tm.vender= 'N'
   LET tm.b    = 'Y'
   LET tm.d    = 'Y'   #No.FUN-8A0103
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmp01,bmp03,bmp011,bmp13,bmp28 #FUN-560030
                    FROM item,com_part,ver,balloon,acode #FUN-560030
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
      ON ACTION CONTROLP
            IF INFIELD(item) THEN
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_ima5"
               LET g_qryparam.form = "q_bmo3"   #NO.TQC-630271
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
            END IF
            IF INFIELD(com_part) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO com_part
               NEXT FIELD com_part
            END IF
#No.FUN-570240 --end--
 
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_sql="SELECT bmp01,bmp011 FROM bmp_file",
                 " WHERE ",tm.wc CLIPPED
       PREPARE r100_precnt FROM l_sql
       IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
       END IF
       DECLARE r100_cnt
            CURSOR FOR r100_precnt
       MESSAGE " SEARCHING ! "
       CALL ui.Interface.refresh()
       FOREACH r100_cnt INTO l_bmp01,l_bmp011
         IF SQLCA.sqlcode  THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            LET l_one = 'Y'
            EXIT FOREACH
         END IF
       END FOREACH
       MESSAGE " "
       CALL ui.Interface.refresh()
       IF cl_null(l_bmp01) OR cl_null(l_bmp011) THEN
          CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
          CONTINUE WHILE
       END IF
  END IF
 
#UI
   INPUT BY NAME tm.a,tm.s,tm.blow,tm.vender,tm.b,tm.d,tm.more   #No.FUN-8A0103 add d 
                 WITHOUT DEFAULTS
 
      AFTER FIELD a
		 IF cl_null(tm.a) OR tm.a < 0 THEN
			 LET tm.a = 1
			 DISPLAY BY NAME tm.a
		 END IF
      AFTER FIELD s
         IF cl_null(tm.s) OR tm.s NOT MATCHES '[1-3]' THEN
            NEXT FIELD s
         END IF
      AFTER FIELD blow
         IF cl_null(tm.blow) OR tm.blow NOT MATCHES'[yYnN]'
         THEN NEXT FIELD blow
         END IF
      AFTER FIELD vender
         IF cl_null(tm.vender) OR tm.vender NOT MATCHES'[yYnN]'
         THEN NEXT FIELD vender
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES'[yYnN]'
         THEN NEXT FIELD b
         END IF
      #No.FUN-8A0103--BEGIN--                                                                                                       
      AFTER FIELD d                                                                                                                 
         IF cl_null(tm.d) OR tm.d NOT MATCHES'[yYnN]'                                                                               
         THEN NEXT FIELD d                                                                                                          
         END IF                                                                                                                     
      #No.FUN-8A0103--END-- 
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
         CALL cl_cmdask()                 # Command execution
 
      ON ACTION CONTROLP
         CALL r100_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                        #" '",tm.engine CLIPPED,"'", #TQC-610068
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.blow CLIPPED,"'",
                         " '",tm.vender CLIPPED,"'",
                         " '",tm.b      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr100',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r100_w2 AT 2,2 WITH FORM "abm/42f/abmi600"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi600")
 
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bmo01,bmo04,bmouser,bmogrup,bmomodu,bmodate,bmoacti,
        bmp02,bmp03,bmp04,bmp05,bmp10,bmp13,bmp06,bmp07,bmp08
        FROM
        bmo01,bmo04,bmouser,bmogrup,bmomodu,bmodate,bmoacti,
        s_bmp[1].bmp02,s_bmp[1].bmp03,s_bmp[1].bmp04,s_bmp[1].bmp05,
        s_bmp[1].bmp10,s_bmp[1].bmp13,s_bmp[1].bmp06,s_bmp[1].bmp07,
        s_bmp[1].bmp08
 
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
 
   CLOSE WINDOW r100_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
END FUNCTION
 
FUNCTION r100_cur()
#DEFINE l_sql  LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)  #TQC-C20170
DEFINE l_sql  STRING,   #TQC-C20170
       l_cmd  LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
 
     LET l_sql = "SELECT '',",
                 " bmo01,bmo011,bmo06,", #FUN-560030
                 " bmp02,bmp03,bmp04,bmp05,bmp06,bmp07,",
                 " bmp08,bmp10,bmp13,bmp16,",
                 " ima02,ima021,ima05,ima08,ima15,''", #FUN-510033 add ima021
                 " FROM bmo_file, bmp_file,OUTER ima_file",
                 " WHERE bmo01 = bmp01 AND bmo01 = ? AND bmo011=? ",
                 "   AND bmp_file.bmp03 = ima_file.ima01 AND bmo011=bmp011 ",
                 "   AND bmo06 = ? ",     #FUN-560030
                 "   AND bmo06 = bmp28 "  #FUN-560030  #TQC-920067 modify
 
     PREPARE r100_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r100_cs2 CURSOR WITH HOLD FOR r100_prepare2
 
     #--->產品結構說明資料
     LET l_cmd  = " SELECT bec04,bec05 FROM bec_file ",
                  " WHERE bec01=?  AND bec02= ? AND ",
                  " bec021=? AND bec011 = ? AND ",
                  " (bec03 IS NULL OR bec03 = ' ') ",
                  " ORDER BY 1"
     PREPARE r100_prebec    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r100_bec CURSOR WITH HOLD FOR r100_prebec
 
     #--->讀取元件廠牌資料
     LET l_sql = "SELECT bel03,bel04 ",
                 "  FROM bel_file  ",
                 " WHERE bel01 = ? ",   #元件
                 "   AND bel02 = ? ",   #主件
                 "   AND bel011= ? ",   #ver
                 " ORDER BY bel03"
     PREPARE r100_pbel FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('pre bel:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r100_cbel CURSOR WITH HOLD FOR r100_pbel
END FUNCTION
 
FUNCTION r100_phatom(p_phatom,p_ver,p_acode,p_qpa,p_base) #FUN-560030
   DEFINE p_phatom      LIKE bmp_file.bmp01,
          p_ver         LIKE bmp_file.bmp011,
          p_acode       LIKE bmp_file.bmp29,   #FUN-560030
          p_qpa         LIKE bmp_file.bmp06,
          p_base        LIKE bmp_file.bmp06,
          l_ac,l_i      LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_tot,l_times LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_chr		LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_ute_flag    LIKE type_file.chr2,   #No.FUN-680096 VARCHAR(2)
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(20)
              bmo01 LIKE bmo_file.bmo01,    #主件料件
              bmo011 LIKE bmo_file.bmo011,  #版本
              bmo06 LIKE bmo_file.bmo06,    #FUN-560030
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp03 LIKE bmp_file.bmp03,    #元件料號
              bmp04 LIKE bmp_file.bmp04,    #有效日期
              bmp05 LIKE bmp_file.bmp05,    #失效日期
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp07 LIKE bmp_file.bmp07,    #底數
              bmp08 LIKE bmp_file.bmp08,    #損耗率%
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp13 LIKE bmp_file.bmp13,    #插件位置
              bmp16 LIKE bmp_file.bmp16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #來源
              phatom LIKE ima_file.ima01    #虛擬料件
          END RECORD,
          l_bmo01  LIKE bmo_file.bmo01
    #No.FUN-850044  --BEGIN                                                                                                          
   DEFINE l_bmp06 LIKE bmp_file.bmp06,    #組成用量                                                                                 
          l_ima02 LIKE ima_file.ima02,    #品名規格                                                                                 
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima08 LIKE ima_file.ima08,    #來源                                                                                     
          l_ima63 LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55 LIKE ima_file.ima55,    #生產單位                                                                                 
          l_bmp02 LIKE bmp_file.bmp02,                                                                                              
          l_bec01 LIKE bec_file.bec01,                                                                                              
          l_bec04 LIKE bec_file.bec04,                                                                                              
          l_bec05 ARRAY[200] OF LIKE type_file.chr20,                                                                               
          l_bel04 ARRAY[200] OF LIKE type_file.chr20,                                                                               
          l_bmu06 ARRAY[200] OF LIKE type_file.chr20,                                                                               
          l_bel03 LIKE bel_file.bel03,                                                                                              
          l_becstr     LIKE type_file.chr20,                                                                                        
          l_bmustr     LIKE type_file.chr20,                                                                                        
          l_bec05_s    LIKE bec_file.bec05,                                                                                         
          l_bmu06_s    LIKE bmu_file.bmu06,                                                                                         
          l_max_n      LIKE type_file.num5,                                                                                         
          l_number     LIKE type_file.num5,                                                                                         
          l_now,l_no   LIKE type_file.num5,                                                                                         
          l_seq,l_max  LIKE type_file.num5,                                                                                         
          l_now2       LIKE type_file.num5,                                                                                         
          l_len,l_byte LIKE type_file.num5  
    DEFINE l_ima02_b   LIKE ima_file.ima02    #No.FUN-8A0103
    DEFINE l_ima021_b  LIKE ima_file.ima021   #No.FUN-8A0103
    DEFINE l_bed RECORD LIKE bed_file.*       #No.FUN-8A0103
    DEFINE l_sql        STRING                #No.FUN-8A0103
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                            
                 "        ?,?,?,?,?)"                                                                                               
                                                                                                                                    
     PREPARE insert_prep4 FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep4:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                           
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?)"                                                                                          
                                                                                                                                    
     PREPARE insert_prep5 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep5:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?)"                                                                                               
                                                                                                                                    
     PREPARE insert_prep6 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep6:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF      
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?)"                                                                                               
                                                                                                                                    
     PREPARE insert_prep7 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep7:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                               
    #No.FUN-850044  --END
    #No.FUN-8A0103--BEGIN--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?)"
 
     PREPARE insert_prep8 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep8:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
    #No.FUN-8A0103--END-- 
 
    LET l_ac = 1
    LET arrno = 600
    LET l_ute_flag='US'
    FOREACH r100_cs2
    USING p_phatom,p_ver,p_acode #FUN-560030
    INTO sr[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET sr[l_ac].phatom = p_phatom
      LET sr[l_ac].bmp06  = (sr[l_ac].bmp06 / sr[l_ac].bmp07) * p_qpa
      LET sr[l_ac].bmp07  = sr[l_ac].bmp07 * p_base
      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
	LET l_tot=l_ac-1
    FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
        IF sr[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
           CALL r100_phatom(sr[l_i].bmp03,sr[l_i].bmo011,' ',sr[l_i].bmp06,p_base) #FUN-560030
           CONTINUE FOR
        END IF
        CASE tm.s
          WHEN '1' LET sr[l_i].order1=sr[l_i].bmp02 using'#####'
          WHEN '2' LET sr[l_i].order1=sr[l_i].bmp03
          WHEN '3' LET sr[l_i].order1=sr[l_i].bmp13
          OTHERWISE LET sr[l_i].order1 = ' '
        END CASE
        #改變替代特性的表示方式
        IF sr[l_i].bmp16 MATCHES '[12]' THEN
           LET g_cnt=sr[l_i].bmp16 USING '&'
           LET sr[l_i].bmp16=l_ute_flag[g_cnt,g_cnt]
        ELSE
           LET sr[l_i].bmp16=' '
        END IF
        LET sr[l_i].bmo01= g_bmo01
        #No.FUN-850044  --BEGIN
        #OUTPUT TO REPORT r100_rep(sr[l_i].*)
         SELECT ima02,ima05,ima08,ima63,ima55                                                                                         
         INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55                                                                               
        FROM ima_file                                                                                                               
       WHERE ima01 = sr[l_i].bmo01                                                                                                       
       IF SQLCA.sqlcode THEN                                                                                                        
          SELECT bmq02,bmq05,bmq08,bmq63,bmq55                                                                                      
            INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55                                                                            
           FROM bmq_file                                                                                                            
          WHERE bmq01 = sr[l_i].bmo01                                                                                                    
          IF SQLCA.sqlcode THEN                                                                                                     
             LET l_ima02='' LET l_ima05='' LET l_ima08=''                                                                           
             LET l_ima63='' LET l_ima55=''                                                                                          
          END IF                                                                                                                    
       END IF                                                                                                                       
                                                                                                                                    
      #-->列印多插件位置                                                                                                            
      FOR g_cnt = 1 TO 200                                                                                                          
          LET l_bmu06[g_cnt]=NULL                                                                                                   
      END FOR                                                                                                                       
      LET l_now2 = 1                                                                                                                
      LET l_len  = 20                                                                                                               
      LET l_bmustr =''                                                                                                              
      DECLARE r100_bmu06_1 CURSOR FOR                                                                                                 
       SELECT bmu06 FROM bmu_file     
      WHERE bmu01=sr[l_i].bmo01 AND bmu02=sr[l_i].bmp02                                                                                     
          AND bmu03=sr[l_i].bmp03 AND bmu011=sr[l_i].bmo011                                                                                   
      FOREACH r100_bmu06_1 INTO l_bmu06_s                                                                                             
           IF STATUS THEN                                                                                                           
              CALL cl_err('Foreach:',STATUS,0) EXIT FOREACH                                                                         
           END IF                                                                                                                   
           IF l_now2 > 200 THEN CALL cl_err('','9036',1)                                                                            
              CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                        
              EXIT PROGRAM                                                                                                          
           END IF                                                                                                                   
           LET l_byte = length(l_bmu06_s) + 1                                                                                       
           IF l_len >=l_byte THEN                                                                                                   
              LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                                 
              LET l_len = l_len - l_byte                                                                                            
           ELSE                                                                                                                     
              LET l_bmu06[l_now2] = l_bmustr                                                                                        
              LET l_now2 = l_now2 + 1                                                                                               
              LET l_len = 20                                                                                                        
              LET l_len = l_len - l_byte                                                                                            
              LET l_bmustr = ''                                                                                                     
              LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                                 
           END IF                                                                                                                   
      END FOREACH                                                                                                                   
      IF l_now2 > 0 THEN LET l_bmu06[l_now2]= l_bmustr END IF   
      ##---                                                                                                                         
      #-->虛擬料件列印                                                                                                              
      IF sr[l_i].phatom IS NOT NULL AND sr[l_i].phatom !=' '                                                                                  
      THEN LET l_bec01 = sr[l_i].phatom                                                                                                  
      ELSE LET l_bec01 = sr[l_i].bmo01                                                                                                   
      END IF                                                                                                                        
      #--->處理廠牌的部份                                                                                                           
      IF tm.vender = 'Y' THEN                                                                                                       
         FOR g_cnt=1 TO 200 LET l_bel04[g_cnt]=NULL END FOR                                                                         
         LET l_seq=1                                                                                                                
         FOREACH r100_cbel                                                                                                          
         USING sr[l_i].bmp03,l_bec01,sr[l_i].bmo011                                                                                           
         INTO l_bel03,l_bel04[l_seq]                                                                                                
          IF SQLCA.sqlcode THEN                                                                                                     
             CALL cl_err('For bel:',SQLCA.sqlcode,0) EXIT FOREACH                                                                   
          END IF                                                                                                                    
          IF l_seq > 200 THEN                                                                                                       
              CALL cl_err('','9036',1)                                                                                              
              EXIT FOREACH                                                                                                          
          END IF                                                                                                                    
          LET l_seq = l_seq + 1                                                                                                     
         END FOREACH                                                                                                                
      END IF
      #No.FUN-8A0103--BEGIN--取替代資料打印
      IF tm.d = 'Y' AND sr[l_i].bmp16 MATCHES '[12SU]'THEN
         LET l_sql=" SELECT * FROM bed_file",
                   " WHERE bed01='",sr[l_i].bmo01,"' AND bed011='",sr[l_i].bmo011,"'",
                   "  AND bed012='",sr[l_i].bmp02,"' "
         PREPARE r100_prebed FROM l_sql
         DECLARE r100_bed CURSOR FOR r100_prebed
         FOREACH r100_bed INTO l_bed.*
         SELECT ima02,ima021 INTO l_ima02_b,l_ima021_b
           FROM ima_file
          WHERE ima01 = l_bed.bed04
          LET l_bed.bed07 = l_bed.bed07 * sr[l_ac].bmp06  #TQC-970042
          EXECUTE insert_prep8 USING sr[l_i].bmo01,sr[l_i].bmo011,sr[l_i].bmp02,sr[l_i].bmp16,l_bed.bed04,
                                     l_bed.bed05,l_bed.bed06,l_bed.bed07,l_ima02_b,l_ima021_b
         END FOREACH
       END IF
      #No.FUN-8A0103--end--
      #--->處理說明的部份                                                                                                           
      IF tm.b ='Y' THEN                                                                                                             
         FOR g_cnt=1 TO 200 LET l_bec05[g_cnt]=NULL END FOR                                                                         
         LET l_now=1                                                                                                                
         FOREACH r100_bec                                                                                                           
         USING l_bec01,sr[l_i].bmp02,sr[l_i].bmp03,sr[l_i].bmo011                                                                                  
         INTO l_bec04,l_bec05_s                                                                                                     
             IF SQLCA.sqlcode THEN                                                                                                  
                CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                
             END IF                                                                                                                 
             LET l_becstr = l_becstr clipped,l_bec05_s                                                                              
             LET l_no     = l_now MOD 2                                                                                             
             IF l_no = 0 THEN                                                                                                       
                LET l_number = l_now / 2                                                                                            
                LET l_bec05[l_number] = l_becstr                                                                                    
                LET l_becstr = ' '                                                                                                  
             END IF                                                                                                                 
             IF l_now > 200 THEN                                                                                                    
                 CALL cl_err('','9036',1)                                                                                           
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107                                                      
                 EXIT PROGRAM                                                                                                       
             END IF                                                                                                                 
             LET l_now=l_now+1                 
          END FOREACH                                                                                                                
      END IF                                                                                                                        
      IF l_now > 1 THEN                                                                                                             
         LET l_no = (l_now -1 ) MOD 2                                                                                               
         IF l_no != 0                                                                                                               
         THEN LET l_now = (l_now / 2)                                                                                               
              LET l_bec05[l_now] = l_becstr                                                                                         
              LET l_becstr = ' '                                                                                                    
         ELSE LET l_now = l_now / 2                                                                                                 
         END IF                                                                                                                     
      END IF                                                                                                                        
                                                                                                                                    
      LET l_bmp06 = sr[l_i].bmp06 * tm.a
                                                                                                       
      {#-->資料列印(項次若非以項次排序則只以順序號+1)                                                                                
      IF tm.s != '1' THEN                                                                                                           
         LET l_bmp02 = l_bmp02 + 1                                                                                                  
         LET sr[l_i].bmp02 = l_bmp02                                                                                                     
      END IF}                                                                                                                        
      IF  (sr[l_i].ima02  IS NULL OR sr[l_i].ima02 = ' ') AND                                                                                 
          (sr[l_i].ima05  IS NULL OR sr[l_i].ima05 = ' ') AND                                                                                 
          (sr[l_i].ima08  IS NULL OR sr[l_i].ima08 = ' ') AND                                                                                 
          (sr[l_i].ima15  IS NULL OR sr[l_i].ima15 = ' ')                                                                                     
      THEN                                                                                                                          
          SELECT bmq02,bmq05,bmq08,bmq15   
            INTO sr[l_i].ima02,sr[l_i].ima05,sr[l_i].ima08,sr[l_i].ima15                                                                                
            FROM bmq_file                                                                                                           
           WHERE bmq01 = sr[l_i].bmp03                                                                                                   
      END IF                                                                                                                        
      #-->底數為'1'不列印                                                                                                           
    # IF sr[l_i].bmp07 = 1 THEN LET sr[l_i].bmp07 = ' ' END IF  #No.MOD-930098 mark                                                                              
       LET l_seq = l_seq - 1                                                                                                        
      IF l_seq > l_now THEN LET l_max = l_seq ELSE LET l_max = l_now END IF                                                         
      IF l_max > 0 THEN                                                                                                             
         FOR l_max_n = 1 TO  l_max                                                                                                  
             #--->列印廠牌                                                                                                          
             IF tm.vender='Y' THEN                                                                                                  
                IF l_bel04[l_max_n]='' OR l_bel04[l_max_n] IS NULL THEN                                                             
                   EXIT FOR                                                                                                         
                END IF                                                                                                              
                EXECUTE insert_prep6 USING sr[l_i].bmp03,l_bec01,sr[l_i].bmo011,                                                              
                                           l_bel03,l_bel04[l_max_n]                                                                 
             END IF                                                                                                                 
             #--->列印說明                                                                                                          
             IF tm.b = 'Y' THEN                                                                                                     
                IF l_bec05[l_max_n] IS NULL OR                                                                                      
                   l_bec05[l_max_n] = ' ' THEN                                                                                      
                   EXIT FOR                                                                                                         
                END IF     
                 EXECUTE insert_prep5 USING l_bec01,sr[l_i].bmp02,sr[l_i].bmp03,                                                               
                                           sr[l_i].bmo011,'',l_bec04,l_bec05[l_max_n]                                                       
             END IF                                                                                                                 
         END FOR                                                                                                                    
      END IF                                                                                                                        
      #列印多插件位置                                                                                                               
      IF NOT cl_null(l_bmu06[1]) AND l_now2 >= 1 THEN                                                                               
         FOR l_max_n = 1 TO l_now2                                                                                                  
             IF l_bmu06[l_max_n]='' OR l_bmu06[l_max_n] IS NULL THEN                                                                
                EXIT FOR                                                                                                            
             END IF                                                                                                                 
             EXECUTE insert_prep7 USING sr[l_i].bmo01,sr[l_i].bmp02,sr[l_i].bmp03,sr[l_i].bmo011,                                                        
                                       l_bmu06[l_max_n]                                                                             
         END FOR                                                                                                                    
      END IF                                                                                                                        
      EXECUTE insert_prep4 USING sr[l_i].order1,sr[l_i].bmo01,sr[l_i].bmo011,sr[l_i].bmo06,sr[l_i].bmp02,                                                     
                                sr[l_i].bmp03, sr[l_i].bmp04,sr[l_i].bmp05, sr[l_i].bmp06,sr[l_i].bmp07,                                                     
                                sr[l_i].bmp08, sr[l_i].bmp10,sr[l_i].bmp13, sr[l_i].bmp16,sr[l_i].ima02,                                                     
                                sr[l_i].ima021,sr[l_i].ima05,sr[l_i].ima08, sr[l_i].ima15,sr[l_i].phatom,                                                    
                                l_ima02,  l_ima05, l_ima08,  l_ima63, l_ima55                                                                    
        #No.FUN-850044  --END
    END FOR
END FUNCTION
 
FUNCTION r100()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_ute_flag    LIKE type_file.chr2,     #No.FUN-680096 VARCHAR(2)
          #l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT  #No.FUN-680096 VARCHAR(1000)  #TQC-C20170
          l_sql     STRING,   #TQC-C20170
          l_za05	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)
          l_bmo01       LIKE bmo_file.bmo01
   #No.FUN-850044  --BEGIN
   DEFINE l_bmp06 LIKE bmp_file.bmp06,    #組成用量                                                                      
          l_ima02 LIKE ima_file.ima02,    #品名規格                                                                                 
          l_ima02_b   LIKE ima_file.ima02,   #NO.FUN-8A0103
          l_ima021_b  LIKE ima_file.ima021,  #NO.FUN-8A0103
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima08 LIKE ima_file.ima08,    #來源                                                                                     
          l_ima63 LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55 LIKE ima_file.ima55,    #生產單位                                                                                 
          l_bmp02 LIKE bmp_file.bmp02,                                                                                              
          l_bec01 LIKE bec_file.bec01,                                                                                              
          l_bec04 LIKE bec_file.bec04,                                                                                              
          l_bec05 ARRAY[200] OF LIKE type_file.chr20,                                                     
          l_bel04 ARRAY[200] OF LIKE type_file.chr20,                                             
          l_bmu06 ARRAY[200] OF LIKE type_file.chr20,                                                     
          l_bel03 LIKE bel_file.bel03,                                                                                              
          l_becstr     LIKE type_file.chr20,                                                                
          l_bmustr     LIKE type_file.chr20,                                                              
          l_bec05_s    LIKE bec_file.bec05,                                                                 
          l_bmu06_s    LIKE bmu_file.bmu06,                                                              
          l_max_n      LIKE type_file.num5,                                                                 
          l_number     LIKE type_file.num5,                                                                 
          l_now,l_no   LIKE type_file.num5,                                                                 
          l_seq,l_max  LIKE type_file.num5,                                                             
          l_now2       LIKE type_file.num5,                                                           
          l_len,l_byte LIKE type_file.num5      
   DEFINE l_sql1       STRING                  #No.FUN-8A0103
   DEFINE l_bed RECORD LIKE bed_file.*         #No.FUN-8A0103
 
     CALL cl_del_data(l_table1)                                                                                                     
     CALL cl_del_data(l_table2)                                                                                                     
     CALL cl_del_data(l_table3)                                                                                                     
     CALL cl_del_data(l_table4)
     CALL cl_del_data(l_table5)  #No.FUN-8A0103
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                            
                 "        ?,?,?,?,?)"                                                                           
                                                                                                                                    
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                           
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?)"                                                                                          
                                                                                                                                    
     PREPARE insert_prep1 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?)"
   
     PREPARE insert_prep2 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
         
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?)"                                                                                               
                                                                                                                                    
     PREPARE insert_prep3 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep3:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                                          
     END IF                      
                                                                                                                                             
     #No.FUN-8A0103--BEGIN--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?)"
 
     PREPARE insert_prep9 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep9:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
    #No.FUN-8A0103--END--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                  
   #No.FUN-850044  --END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr100'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmouser', 'bmogrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '',",
                 " bmo01,bmo011,bmo06,", #FUN-560030
                 " bmp02,bmp03,bmp04,bmp05,bmp06,bmp07,",
                 " bmp08,bmp10,bmp13,bmp16,",
                 " ima02,ima021,ima05,ima08,ima15,''", #FUN-510033
                 " FROM bmo_file, bmp_file,OUTER ima_file",
                 " WHERE bmo01 = bmp01",
                 "   AND bmo011= bmp011",
                 "   AND bmp_file.bmp03 = ima_file.ima01",
                 "   AND bmo06 = bmp28 ",  #MOD-920242  #TQC-920067 modify
                #"   AND bmo06 = bmp29 "  #FUN-560030  #MOD-920242 mark
                 "   AND ",tm.wc
 
     PREPARE r100_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r100_c1 CURSOR FOR r100_prepare1
 
     #CALL cl_outnam('abmr100') RETURNING l_name  #No.FUN-850044
     #START REPORT r100_rep TO l_name             #No.FUN-850044 
 
     CALL r100_cur()
     LET l_ute_flag='US'
     FOREACH r100_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.bmp06 = sr.bmp06 /sr.bmp07
       IF sr.ima08 = 'X' AND tm.blow = 'Y' THEN
          LET g_bmo01 = sr.bmo01
          CALL r100_phatom(sr.bmp03,sr.bmo011,sr.bmo06,sr.bmp06,sr.bmp07) #FUN-560030
          CONTINUE FOREACH
       END IF
       CASE tm.s
           WHEN '1' LET sr.order1=sr.bmp02  USING'#####'
           WHEN '2' LET sr.order1=sr.bmp03
           WHEN '3' LET sr.order1=sr.bmp13
           OTHERWISE LET sr.order1 = ' '
       END CASE
 
       #---->改變替代特性的表示方式
       IF sr.bmp16 MATCHES '[12]' THEN
           LET g_cnt=sr.bmp16 USING '&'
           LET sr.bmp16=l_ute_flag[g_cnt,g_cnt]
       ELSE
           LET sr.bmp16=' '
       END IF
       #No.FUN-850044  --BEGIN
       #OUTPUT TO REPORT r100_rep(sr.*)
       SELECT ima02,ima05,ima08,ima63,ima55                                                                                          
         INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55                                                                                
        FROM ima_file                                                                                                               
       WHERE ima01 = sr.bmo01                                                                                                       
       IF SQLCA.sqlcode THEN                                                                                                         
          SELECT bmq02,bmq05,bmq08,bmq63,bmq55                                                                                       
            INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55                                                                             
           FROM bmq_file                                                                                                            
          WHERE bmq01 = sr.bmo01                                                                                                    
          IF SQLCA.sqlcode THEN                                                                                                      
             LET l_ima02='' LET l_ima05='' LET l_ima08=''                                                                            
             LET l_ima63='' LET l_ima55=''                                                                                           
          END IF                                                                                                                     
       END IF
 
      #-->列印多插件位置                                                                            
      FOR g_cnt = 1 TO 200                                                                                                          
          LET l_bmu06[g_cnt]=NULL                                                                                                   
      END FOR                                                                                                                       
      LET l_now2 = 1                                                                                                                
      LET l_len  = 20                                                                                                               
      LET l_bmustr =''                                                                                                              
      DECLARE r100_bmu06 CURSOR FOR                                                                                                 
       SELECT bmu06 FROM bmu_file                                                                                                   
        WHERE bmu01=sr.bmo01 AND bmu02=sr.bmp02                                                                                     
          AND bmu03=sr.bmp03 AND bmu011=sr.bmo011                                                                                   
      FOREACH r100_bmu06 INTO l_bmu06_s                                                                                             
           IF STATUS THEN                                                                                                           
              CALL cl_err('Foreach:',STATUS,0) EXIT FOREACH                                                                         
           END IF                                                                                                                   
           IF l_now2 > 200 THEN CALL cl_err('','9036',1)                                                                            
              CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                          
              EXIT PROGRAM                                                                                                          
           END IF                                                                                                                   
           LET l_byte = length(l_bmu06_s) + 1                                                                                       
           IF l_len >=l_byte THEN                                                                                                   
              LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                                 
              LET l_len = l_len - l_byte                                                                                            
           ELSE                                                                                                                     
              LET l_bmu06[l_now2] = l_bmustr                                                                                        
              LET l_now2 = l_now2 + 1                                                                                               
              LET l_len = 20                                                                                                        
              LET l_len = l_len - l_byte                                                                                            
              LET l_bmustr = ''                                                                                                     
              LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','                                                                 
           END IF                                                                                                                   
      END FOREACH                                                                                                                   
      IF l_now2 > 0 THEN LET l_bmu06[l_now2]= l_bmustr END IF
                                                                                           
      ##---                                                                                                                         
      #-->虛擬料件列印                                                                                                              
      IF sr.phatom IS NOT NULL AND sr.phatom !=' '                                                                                  
      THEN LET l_bec01 = sr.phatom                                                                                                  
      ELSE LET l_bec01 = sr.bmo01                                                                                                   
      END IF                                                                                                                        
      #--->處理廠牌的部份                                                                                                           
      IF tm.vender = 'Y' THEN                                                                                                       
         FOR g_cnt=1 TO 200 LET l_bel04[g_cnt]=NULL END FOR                                                                         
         LET l_seq=1                                                                                                                
         FOREACH r100_cbel                                                                                                          
         USING sr.bmp03,l_bec01,sr.bmo011                                                                                           
         INTO l_bel03,l_bel04[l_seq]                                                                                                
          IF SQLCA.sqlcode THEN                                                                                                     
             CALL cl_err('For bel:',SQLCA.sqlcode,0) EXIT FOREACH
          END IF                                                                                                                    
          IF l_seq > 200 THEN                                                                                                       
              CALL cl_err('','9036',1)                                                                                              
              EXIT FOREACH                                                                                                          
          END IF                                                                                                                    
          LET l_seq = l_seq + 1 
         END FOREACH      
      END IF 
                                                                                                                             
      #No.FUN-8A0103--BEGIN--取替代資料打印
      IF tm.d = 'Y' AND sr.bmp16 MATCHES '[12SU]'THEN
      LET l_sql1=" SELECT * FROM bed_file",
                   " WHERE bed01='",sr.bmo01,"' AND bed011='",sr.bmo011,"'",
                   "  AND bed012='",sr.bmp02,"' "
         PREPARE r100_prebed1 FROM l_sql1
         DECLARE r100_bed1 CURSOR FOR r100_prebed1
         FOREACH r100_bed1 INTO l_bed.* 
         SELECT ima02,ima021 INTO l_ima02_b,l_ima021_b
           FROM ima_file
          WHERE ima01 = l_bed.bed04
          LET l_bed.bed07 = l_bed.bed07 * sr.bmp06  #TQC-970042
          EXECUTE insert_prep9 USING sr.bmo01,sr.bmo011,sr.bmp02,sr.bmp16,l_bed.bed04,
                                     l_bed.bed05,l_bed.bed06,l_bed.bed07,l_ima02_b,l_ima021_b
         END FOREACH
       END IF
      #No.FUN-8A0103--end--
      #--->處理說明的部份                                                                                                           
      IF tm.b ='Y' THEN                                                                                                             
         FOR g_cnt=1 TO 200 LET l_bec05[g_cnt]=NULL END FOR                                                                         
         LET l_now=1                                                                                                                
         FOREACH r100_bec                                                                                                           
         USING l_bec01,sr.bmp02,sr.bmp03,sr.bmo011                                                                                  
         INTO l_bec04,l_bec05_s                                                                                                     
             IF SQLCA.sqlcode THEN                                                                                                  
                CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                
             END IF                                                                                                                 
             LET l_becstr = l_becstr clipped,l_bec05_s                                                                              
             LET l_no     = l_now MOD 2                                                                                             
             IF l_no = 0 THEN                                                                                                       
                LET l_number = l_now / 2                                                                                            
                LET l_bec05[l_number] = l_becstr                                                                                    
                LET l_becstr = ' '
             END IF                                                                                                                 
             IF l_now > 200 THEN                                                                                                    
                 CALL cl_err('','9036',1)                                                                                           
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107                                                      
                 EXIT PROGRAM                                                                                                       
             END IF                                                                                                                 
             LET l_now=l_now+1                                                                                                      
         END FOREACH                                                                                                                
      END IF                                                                                                                        
      IF l_now > 1 THEN                                                                                                             
         LET l_no = (l_now -1 ) MOD 2                                                                                               
         IF l_no != 0                                                                                                               
         THEN LET l_now = (l_now / 2)                                                                                               
              LET l_bec05[l_now] = l_becstr                                                                                         
              LET l_becstr = ' '                                                                                                    
         ELSE LET l_now = l_now / 2                                                                                                 
         END IF                                                                                                                     
      END IF 
                                                                                                                       
      LET l_bmp06 = sr.bmp06 * tm.a                                                                                                 
      {#-->資料列印(項次若非以項次排序則只以順序號+1)                                                                                
      IF tm.s != '1' THEN                                                                                                           
         LET l_bmp02 = l_bmp02 + 1                                                                                                  
         LET sr.bmp02 = l_bmp02                                                                                                     
      END IF}                  
      IF  (sr.ima02  IS NULL OR sr.ima02 = ' ') AND                                                                                 
          (sr.ima05  IS NULL OR sr.ima05 = ' ') AND                                                                                 
          (sr.ima08  IS NULL OR sr.ima08 = ' ') AND                                                                                 
          (sr.ima15  IS NULL OR sr.ima15 = ' ')                                                                                     
      THEN                                                                                                                          
          SELECT bmq02,bmq05,bmq08,bmq15                                                                                            
            INTO sr.ima02,sr.ima05,sr.ima08,sr.ima15                                                                                
            FROM bmq_file                                                                                                           
           WHERE bmq01 = sr.bmp03                                                                                                   
      END IF                  
      #-->底數為'1'不列印                                                                                                           
    # IF sr.bmp07 = 1 THEN LET sr.bmp07 = ' ' END IF  #No.MOD-930098 mark       
       LET l_seq = l_seq - 1                                                                                                         
      IF l_seq > l_now THEN LET l_max = l_seq ELSE LET l_max = l_now END IF                                                         
      IF l_max > 0 THEN                                                                                                             
         FOR l_max_n = 1 TO  l_max
             #--->列印廠牌  
             IF tm.vender='Y' THEN          
                IF l_bel04[l_max_n]='' OR l_bel04[l_max_n] IS NULL THEN
                   EXIT FOR
                END IF 
                EXECUTE insert_prep2 USING sr.bmp03,l_bec01,sr.bmo011,
                                           l_bel03,l_bel04[l_max_n]
             END IF                                                                                             
             #--->列印說明                                                                                                          
             IF tm.b = 'Y' THEN                                                                                                     
                IF l_bec05[l_max_n] IS NULL OR                                                                       
                   l_bec05[l_max_n] = ' ' THEN                                                                                                
                   EXIT FOR                                                                               
                END IF                                                                                                              
                EXECUTE insert_prep1 USING l_bec01,sr.bmp02,sr.bmp03,
                                           sr.bmo011,'',l_bec04,l_bec05[l_max_n]                                                                            
             END IF                                                                                                                 
         END FOR                                                                                                                    
      END IF
      #列印多插件位置                                                                                                               
      IF NOT cl_null(l_bmu06[1]) AND l_now2 >= 1 THEN                                                                               
         FOR l_max_n = 1 TO l_now2                                                                                                  
             IF l_bmu06[l_max_n]='' OR l_bmu06[l_max_n] IS NULL THEN                                                                                                    
                EXIT FOR                                                                                    
             END IF                                                                                                                 
             EXECUTE insert_prep3 USING sr.bmo01,sr.bmp02,sr.bmp03,sr.bmo011,
                                       l_bmu06[l_max_n]                                                                                       
         END FOR                                                                                                                    
      END IF      
      EXECUTE insert_prep USING sr.order1,sr.bmo01,sr.bmo011,sr.bmo06,sr.bmp02,
                                sr.bmp03, sr.bmp04,sr.bmp05, l_bmp06,sr.bmp07,
                                sr.bmp08, sr.bmp10,sr.bmp13, sr.bmp16,sr.ima02,
                                sr.ima021,sr.ima05,sr.ima08, sr.ima15,sr.phatom,
                                l_ima02,  l_ima05, l_ima08,  l_ima63, l_ima55
     #No.FUN-850044  --end
     END FOREACH
 
     #No.FUN-850044  --BEGIN
     #FINISH REPORT r100_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                         
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",                                                         
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED       #No.FUN-8A0103
                                                                                                                                    
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'bmp01,bmp03,bmp011,bmp13,bmp28')                                                                  
        RETURNING  tm.wc                                                                                                            
     END IF                                                                                                                         
     LET g_str = tm.wc,';',tm.a,';',tm.s,';',tm.d     #No.FUN-8A0103                                                                      
     CALL cl_prt_cs3('abmr100','abmr100',g_sql,g_str) 
     #No.FUN-850044  --END 
END FUNCTION
#No.FUN-870144
 
#No.FUN-850044  --begin
#{
#REPORT r100_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
#         sr  RECORD
#             order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(20)
#             bmo01 LIKE bmo_file.bmo01,    #主件料件
#             bmo011 LIKE bmo_file.bmo011,  #版本
#             bmo06 LIKE bmo_file.bmo06,    #FUN-560030
#             bmp02 LIKE bmp_file.bmp02,    #項次
#             bmp03 LIKE bmp_file.bmp03,    #元件料號
#             bmp04 LIKE bmp_file.bmp04,    #有效日期
#             bmp05 LIKE bmp_file.bmp05,    #失效日期
#             bmp06 LIKE bmp_file.bmp06,    #QPA
#             bmp07 LIKE bmp_file.bmp07,    #底數
#             bmp08 LIKE bmp_file.bmp08,    #損耗率%
#             bmp10 LIKE bmp_file.bmp10,    #發料單位
#             bmp13 LIKE bmp_file.bmp13,    #插件位置
#             bmp16 LIKE bmp_file.bmp16,    #替代特性
#             ima02 LIKE ima_file.ima02,    #品名規格
#             ima021 LIKE ima_file.ima021,  #FUN-510033
#             ima05 LIKE ima_file.ima05,    #版本
#             ima08 LIKE ima_file.ima08,    #來源
#             ima15 LIKE ima_file.ima15,    #來源
#             phatom LIKE ima_file.ima01    #虛擬料件
#         END RECORD,
#         l_bmp06 LIKE bmp_file.bmp06,    #組成用量 #FUN-560231
#         l_ima02 LIKE ima_file.ima02,    #品名規格
#         l_ima05 LIKE ima_file.ima05,    #版本
#         l_ima08 LIKE ima_file.ima08,    #來源
#         l_ima63 LIKE ima_file.ima63,    #發料單位
#         l_ima55 LIKE ima_file.ima55,    #生產單位
#         l_bmp02 LIKE bmp_file.bmp02,    
#         l_bec01 LIKE bec_file.bec01,
#         l_bec04 LIKE bec_file.bec04,
#         l_bec05 ARRAY[200] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#         l_bel04 ARRAY[200] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#         l_bmu06 ARRAY[200] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#         l_bel03 LIKE bel_file.bel03,
#         l_becstr     LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#         l_bmustr     LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#         l_bec05_s    LIKE bec_file.bec05,    #No.FUN-680096 VARCHAR(10)
#         l_bmu06_s    LIKE bmu_file.bmu06,    #No.FUN-680096 VARCHAR(20)
#         l_max_n      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#         l_number     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#         l_now,l_no   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#         l_seq,l_max  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#         l_now2       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#         l_len,l_byte LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.bmo01,sr.bmo011,sr.bmo06,sr.order1 #FUN-560030
# FORMAT
#  PAGE HEADER
#     SELECT ima02,ima05,ima08,ima63,ima55
#       INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55
#       FROM ima_file
#      WHERE ima01 = sr.bmo01
#     IF SQLCA.sqlcode THEN
#        SELECT bmq02,bmq05,bmq08,bmq63,bmq55
#          INTO l_ima02,l_ima05,l_ima08,l_ima63,l_ima55
#          FROM bmq_file
#         WHERE bmq01 = sr.bmo01
#        IF SQLCA.sqlcode THEN
#           LET l_ima02='' LET l_ima05='' LET l_ima08=''
#           LET l_ima63='' LET l_ima55=''
#        END IF
#     END IF
 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash
#     #----
#     PRINT COLUMN  1,g_x[15] CLIPPED,sr.bmo01 #TQC-5B0105 &051112
#          #TQC-5B0105 &051112 mark
#          #COLUMN 31,g_x[21] CLIPPED,l_ima05,
#          #COLUMN 43,g_x[22] CLIPPED,l_ima08,
#          #COLUMN 50,g_x[16] CLIPPED,l_ima63,
#          #COLUMN 64,g_x[18] CLIPPED,l_ima55
#     PRINT COLUMN  1,g_x[17] CLIPPED,l_ima02  #TQC-5B0105 &051112
#          #TQC-5B0105 &051112 mark
#          #COLUMN 50,g_x[30] CLIPPED,sr.bmo011,
#          #COLUMN 64,g_x[20] CLIPPED,tm.a USING '<<<<<'
#     PRINT COLUMN  1,g_x[14] CLIPPED,sr.bmo06 #FUN-560030
 
#     #TQC-5B0105 &051112 add
#     PRINT COLUMN  1,g_x[21] CLIPPED,l_ima05,
#           COLUMN 13,g_x[22] CLIPPED,l_ima08,
#           COLUMN 20,g_x[16] CLIPPED,l_ima63,
#           COLUMN 34,g_x[18] CLIPPED,l_ima55
#     PRINT COLUMN  1,g_x[30] CLIPPED,sr.bmo011,
#           COLUMN 34,g_x[20] CLIPPED,tm.a USING '<<<<<'
#     #TQC-5B0105 &051112 end
#     PRINT ' '
#     #----
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
#     PRINTX name=H2 g_x[40],g_x[41],g_x[42]
#     PRINTX name=H3 g_x[43],g_x[44]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  #FUN-560030................begin
# #BEFORE GROUP OF sr.bmo011
# #   IF (PAGENO > 1 OR LINENO > 13)
# #      THEN SKIP TO TOP OF PAGE
# #   END IF
#  BEFORE GROUP OF sr.bmo06
#     SKIP TO TOP OF PAGE
#  #FUN-560030................end
#     LET l_bmp02 = 0
 
#  ON EVERY ROW
#     #-->列印多插件位置      (add in 99/04/07 NO:3078)
#     FOR g_cnt = 1 TO 200
#         LET l_bmu06[g_cnt]=NULL
#     END FOR
#     LET l_now2 = 1
#     LET l_len  = 20
#     LET l_bmustr =''
#     DECLARE r100_bmu06 CURSOR FOR
#      SELECT bmu06 FROM bmu_file
#       WHERE bmu01=sr.bmo01 AND bmu02=sr.bmp02
#         AND bmu03=sr.bmp03 AND bmu011=sr.bmo011
#     FOREACH r100_bmu06 INTO l_bmu06_s
#          IF STATUS THEN
#             CALL cl_err('Foreach:',STATUS,0) EXIT FOREACH
#          END IF
#          IF l_now2 > 200 THEN CALL cl_err('','9036',1) 
#             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#             EXIT PROGRAM 
#          END IF
#          LET l_byte = length(l_bmu06_s) + 1
#          IF l_len >=l_byte THEN
#             LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','
#             LET l_len = l_len - l_byte
#          ELSE
#             LET l_bmu06[l_now2] = l_bmustr
#             LET l_now2 = l_now2 + 1
#             LET l_len = 20
#             LET l_len = l_len - l_byte
#             LET l_bmustr = ''
#             LET l_bmustr = l_bmustr clipped,l_bmu06_s clipped,','
#          END IF
#     END FOREACH
#     LET l_bmu06[l_now2]= l_bmustr
#     ##---
#     #-->虛擬料件列印
#     IF sr.phatom IS NOT NULL AND sr.phatom !=' '
#     THEN LET l_bec01 = sr.phatom
#     ELSE LET l_bec01 = sr.bmo01
#     END IF
#     #--->處理廠牌的部份
#     IF tm.vender = 'Y' THEN
#        FOR g_cnt=1 TO 200 LET l_bel04[g_cnt]=NULL END FOR
#        LET l_seq=1
#        FOREACH r100_cbel
#        USING sr.bmp03,l_bec01,sr.bmo011
#        INTO l_bel03,l_bel04[l_seq]
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('For bel:',SQLCA.sqlcode,0) EXIT FOREACH
#         END IF
#         IF l_seq > 200 THEN
#             CALL cl_err('','9036',1)
#             EXIT FOREACH
#         END IF
#         LET l_seq = l_seq + 1
#        END FOREACH
#     END IF
#     #--->處理說明的部份
#     IF tm.b ='Y' THEN
#        FOR g_cnt=1 TO 200 LET l_bec05[g_cnt]=NULL END FOR
#        LET l_now=1
#        FOREACH r100_bec
#        USING l_bec01,sr.bmp02,sr.bmp03,sr.bmo011
#        INTO l_bec04,l_bec05_s
#            IF SQLCA.sqlcode THEN
#               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#            END IF
#            LET l_becstr = l_becstr clipped,l_bec05_s
#            LET l_no     = l_now MOD 2
#            IF l_no = 0 THEN
#               LET l_number = l_now / 2
#               LET l_bec05[l_number] = l_becstr
#               LET l_becstr = ' '
#            END IF
#            IF l_now > 200 THEN
#                CALL cl_err('','9036',1)
#                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#                EXIT PROGRAM
#            END IF
#            LET l_now=l_now+1
#        END FOREACH
#     END IF
#     IF l_now > 1 THEN
#        LET l_no = (l_now -1 ) MOD 2
#        IF l_no != 0
#        THEN LET l_now = (l_now / 2)
#             LET l_bec05[l_now] = l_becstr
#             LET l_becstr = ' '
#        ELSE LET l_now = l_now / 2
#        END IF
#     END IF
#     LET l_bmp06 = sr.bmp06 * tm.a
#     #-->資料列印(項次若非以項次排序則只以順序號+1)
#     IF tm.s != '1' THEN
#        LET l_bmp02 = l_bmp02 + 1
#        LET sr.bmp02 = l_bmp02
#     END IF
#     IF  (sr.ima02  IS NULL OR sr.ima02 = ' ') AND
#         (sr.ima05  IS NULL OR sr.ima05 = ' ') AND
#         (sr.ima08  IS NULL OR sr.ima08 = ' ') AND
#         (sr.ima15  IS NULL OR sr.ima15 = ' ')
#     THEN
#         SELECT bmq02,bmq05,bmq08,bmq15
#           INTO sr.ima02,sr.ima05,sr.ima08,sr.ima15
#           FROM bmq_file
#          WHERE bmq01 = sr.bmp03
#     END IF
#     PRINTX name=D1 COLUMN g_c[31],sr.bmp02 USING '###&',
#                    COLUMN g_c[32],sr.bmp03,
#                    COLUMN g_c[33],sr.ima08,
#                    COLUMN g_c[34],sr.bmp10,
#                    COLUMN g_c[35],sr.ima15,
#                    COLUMN g_c[36],cl_numfor(l_bmp06,36,4),
#                    COLUMN g_c[37],sr.bmp04,
#                    COLUMN g_c[38],sr.bmp08 USING '###&.&&&',
#                    COLUMN g_c[39],sr.bmp16
 
#     #-->底數為'1'不列印
#     IF sr.bmp07 = 1 THEN LET sr.bmp07 = ' ' END IF
#     PRINTX name=D2 COLUMN g_c[40],' ',
#                    COLUMN g_c[41],sr.ima02,
#                    COLUMN g_c[42],cl_numfor(sr.bmp07,42,4)
#     PRINTX name=D3 COLUMN g_c[43],' ',
#                    COLUMN g_c[44],sr.ima021
 
#     IF sr.phatom IS NOT NULL AND sr.phatom != ' ' THEN
#        PRINT COLUMN 4,g_x[23] clipped,sr.phatom;
#     END IF
#     LET l_seq = l_seq - 1
#     IF l_seq > l_now THEN LET l_max = l_seq ELSE LET l_max = l_now END IF
#     IF l_max > 0 THEN
#        FOR l_max_n = 1 TO  l_max
#            #--->列印廠牌
#            IF tm.vender = 'Y' THEN
#               IF l_max_n = 1 AND l_bel04[1] IS NOT NULL AND
#                  l_bel04[1] != ' '
#               THEN PRINT COLUMN 25,g_x[28] clipped;
#               END IF
#               PRINT COLUMN 30,l_bel04[l_max_n] clipped;
#            END IF
#            #--->列印說明
#            IF tm.b = 'Y' THEN
#               IF l_max_n = 1 AND l_bec05[1] IS NOT NULL AND
#                  l_bec05[1] != ' '
#               THEN PRINT COLUMN 52,g_x[27] clipped;
#               END IF
#               PRINT COLUMN 57,l_bec05[l_max_n] clipped
#          # ELSE PRINT ' '
#            END IF
#        END FOR
#  #  ELSE PRINT ' '
#     END IF
#     #列印多插件位置
#     IF NOT cl_null(l_bmu06[1]) AND l_now2 >= 1 THEN
#        FOR l_max_n = 1 TO l_now2
#            IF l_max_n = 1 THEN
#               PRINT COLUMN 48,g_x[29] clipped;
#            END IF
#            PRINT COLUMN 57,l_bmu06[l_max_n]
#        END FOR
#     ELSE
#        PRINT
#     END IF
 
#  AFTER GROUP OF sr.bmo011
#   # LET g_pageno = 0
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     1RINT ' '
#     PRINT g_x[24] CLIPPED
#     PRINT g_dash[1,g_len]
#     IF g_pageno = 0 OR l_last_sw = 'y'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     END IF
#END REPORT
#}
#No.FUN-850044  --end
