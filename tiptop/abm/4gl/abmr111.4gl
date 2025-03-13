# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abmr111.4gl
# Descriptions...: 工程BOM-多階材料用途清單
# Input parameter:
# Return code....:
# Date & Author..: 94/06/15 By Apple
# Modify.........: No.FUN-510033 05/02/17 By Mandy 報表轉XML
# Modify.........: No.FUN-560030 05/06/14 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加controlp
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.TQC-630271 06/03/30 by Yiting ^P出現應為非主件編號,q_ima5改抓q_bmp1
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-880057 08/05/23 By ve007 報表輸出格式改為CR
# Modify.........: No.FUN-880057 08/08/18 By Cockroach CR_BUG修改 
#                                08/09/22 By Cockroach 21-->31    
# Modify.........: No.TQC-960122 09/06/11 By Carrier 多階時,數量做累加
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
    		wc  	  LIKE type_file.chr1000,# Where condition #No.FUN-680096 VARCHAR(500)
               # Prog. Version..: '5.30.06-13.03.12(04),		# 分群碼  #TQC-610068
       		arrange   LIKE type_file.chr1,  #No.FUN-680096 VARCHAR(1)
   	    	more	  LIKE type_file.chr1   #No.FUN-680096 VARCHAR(1)
          END RECORD,
          g_bmp03_a       LIKE bmp_file.bmp01,
          g_tot           LIKE type_file.num10  #No.FUN-680096 INTEGER
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose     #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING,                           #No.FUN-880057
         g_sql          STRING,                           #No.FUN-880057
         g_str          STRING                            #No.FUN-880057
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
 
#No.FUN-880057 --begin--
   LET g_sql = "bmp01.bmp_file.bmp01,",
               "bmp011.bmp_file.bmp011,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",  
               "bmp02.bmp_file.bmp02,",
               "bmp06.bmp_file.bmp06,",
               "bmp10.bmp_file.bmp10,",
               "bmp04.bmp_file.bmp04,",
               "bmp05.bmp_file.bmp05,",
               "bmp03.bmp_file.bmp03,",
               "bmp28.bmp_file.bmp28,",
               "l_print_31.type_file.chr1000,",  
               "l_ima02.ima_file.ima02,", 
               "l_ima021.ima_file.ima021,",
               "l_ima08.ima_file.ima08,", 
               "l_ima06.ima_file.ima06,",
               "l_ima25.ima_file.ima25,", 
               "l_ima63.ima_file.ima63,",
               "p_level.type_file.num5,",
               "p_i.type_file.num5,",   
               "g_bmp03_a.bmp_file.bmp01"           #880057 by cockroach
   LET l_table = cl_prt_temptable('abmr111',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN             
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF 
#No.FUN-880057 --end--  
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.class  = ARG_VAL(8)  #TQC-610068
   LET tm.arrange  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r111_tm(0,0)			# Input print condition
      ELSE CALL r111()			# Read bmota and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r111_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bmp03       LIKE bmp_file.bmp01,
          l_cmd		LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
          l_item        LIKE bmp_file.bmp03
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
 
   OPEN WINDOW r111_w AT p_row,p_col
        WITH FORM "abm/42f/abmr111"
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
   INITIALIZE tm.* TO NULL	
   LET tm.arrange ='1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmp03 FROM item
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
            IF INFIELD(item) THEN
#NO.TQC-630271 start-
               CALL q_bmp1(TRUE,TRUE,l_item)
               RETURNING l_item
               DISPLAY l_item TO item
               NEXT FIELD item
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima5"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO item
#               NEXT FIELD item
#NO.TQC-630271 end-
            END IF
#No.FUN-570240 --end--
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bmp03),bmp03 ",
" FROM bmp_file Left Outer Join ima_file on bmp03 = ima01 AND ima08 != 'A' ",
                 " WHERE ",
                 tm.wc CLIPPED," GROUP BY bmp03"
       PREPARE r111_precnt FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       DECLARE r111_cnt  CURSOR FOR r111_precnt
       LET g_cnt=0
       FOREACH r111_cnt  INTO g_i  ,l_bmp03   #7926
          IF SQLCA.sqlcode  THEN
               CALL cl_err(g_cnt,STATUS,0)
	       CONTINUE WHILE
          END IF
          LET g_cnt=g_cnt+1
       END FOREACH
       IF g_cnt=1 THEN LET l_one='Y' END IF
   END IF
#UI
   INPUT BY NAME tm.arrange,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD arrange
         IF tm.arrange NOT MATCHES '[12]' THEN
            NEXT FIELD arrange
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
         CALL r111_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr111','9031',1)
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
                        #" '",tm.class CLIPPED,"'", #TQC-610068
                         " '",tm.arrange CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr111',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111_wc()
   DEFINE l_wc   LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r111_w2 AT 2,2 WITH FORM "abm/42f/abmi600"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi600")
 
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bmo01,bmo04,bmp02,bmp03,bmp04,bmp05,bmp10,bmp06,bmp07,bmp08,
        bmouser,bmogrup,bmomodu,bmodate
      FROM
        bmo01,bmo04,
        s_bmp[1].bmp02,s_bmp[1].bmp03,s_bmp[1].bmp04,s_bmp[1].bmp05,
        s_bmp[1].bmp10,s_bmp[1].bmp06,s_bmp[1].bmp07,s_bmp[1].bmp08,
        bmouser,bmogrup,bmomodu,bmodate
 
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
 
   CLOSE WINDOW r111_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# r111()      從單身讀取合乎條件的元件資料
# r111_bom()  處理主件及其相關的展開資料
#-----------------------------------------------------------------
FUNCTION r111()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_bmp03 LIKE bmp_file.bmp03           #元件料件
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)                                    #No.FUN-880057
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-880057
     
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
 
     LET l_sql = "SELECT UNIQUE bmp03",
                 " FROM bmp_file Left Outer Join ima_file on bmp03 = ima01 AND ima08 != 'A' ",
                 
                 " WHERE ",tm.wc
     PREPARE r111_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
		 CALL cl_err('prepare:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM 
   END IF
     DECLARE r111_c1 CURSOR FOR r111_prepare1
 
#     CALL cl_outnam('abmr111') RETURNING l_name               #No.FUN-880057--MARK--
#    START REPORT r111_rep TO l_name                           #No.FUN-880057--MARK--
 
     LET g_pageno = 0
	LET g_tot=0
     FOREACH r111_c1 INTO l_bmp03
       IF SQLCA.sqlcode THEN
		 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       LET g_bmp03_a=l_bmp03
       CALL r111_bom(0,l_bmp03,1)  #No.TQC-960122
     END FOREACH
 
    #DISPLAY "" AT 2,1
    #No.FUN-880057 --begin--
#    FINISH REPORT r111_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN 
          CALL cl_wcchp(tm.wc,'bmp03')
             RETURNING tm.wc 
     END IF
     LET g_str=tm.wc,";",g_sma.sma888[1,1]       #,";",g_bmp03_a No.FUN-880057 by cockroach
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('abmr111','abmr111',l_sql,g_str)
    #No.FUN-880057 --end-- 
END FUNCTION
 
FUNCTION r111_bom(p_level,p_key,p_qty)  #No.TQC-960122
   DEFINE p_qty         LIKE bmp_file.bmp06     #No.TQC-960122
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_level1      LIKE type_file.num5,
          p_key		LIKE bmo_file.bmo01,    #元件料件編號
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE bmp_file.bmp02,    #滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_ima06       LIKE ima_file.ima06,    #分群碼
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmp01 LIKE bmp_file.bmp01,    #主件料號
              bmp011 LIKE bmp_file.bmp011,  #版本
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp04 LIKE bmp_file.bmp04,    #有效日期
              bmp05 LIKE bmp_file.bmp05,    #失效日期
              bmp03 LIKE bmp_file.bmp03,    #元件料件
              bmp28 LIKE bmp_file.bmp28     #FUN-560030
          END RECORD,
          l_cmd	    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
          #No.FUN-880057 --begin--
DEFINE    l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima021,  #FUN-510033
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima061 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima15 LIKE ima_file.ima15,    #保稅否
          l_ima25 LIKE ima_file.ima25,    #庫存單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_point  LIKE cre_file.cre08,  
          l_print_31  LIKE type_file.chr1000,
          l_p      LIKE type_file.num5,  
          l_str2   LIKE type_file.chr20,  
          l_k      LIKE type_file.num5   
          #No.FUn-880057 --end--
          
    IF p_level > 25 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
          
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
       #LET g_pageno = 0 #FUN-560030
        LET sr[1].bmp03 = p_key
        #No.FUN-880057  --begin--
#       OUTPUT TO REPORT r111_rep(1,0,sr[1].*)	#第0階主件資料 #FUN-560030
        LET p_level1=1
        SELECT ima02,ima021,ima05,ima06,
             ima08,ima15,ima25,ima55,ima63
        INTO l_ima02,l_ima021,l_ima05,l_ima061,
             l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
        FROM ima_file
          WHERE ima01=g_bmp03_a
        IF SQLCA.sqlcode THEN
           LET l_ima02='' LET l_ima05='' LET l_ima021=''
           LET l_ima061='' LET l_ima08=''
           LET l_ima55='' LET l_ima63=''
        END IF
        IF  (l_ima02 IS NULL OR l_ima02 = ' ') AND
            (l_ima05 IS NULL OR l_ima05 = ' ') AND
            (l_ima08 IS NULL OR l_ima08 = ' ')
        THEN SELECT bmq02,bmq021,bmq05,bmq06,
                    bmq08,bmq15,bmq25,bmq25,bmq25
               INTO l_ima02,l_ima021,l_ima05,l_ima061,
                    l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
               FROM bmq_file
              WHERE bmq01 = g_bmp03_a
              IF SQLCA.sqlcode THEN
                 LET l_ima02 = ' ' LET l_ima05= ' '  LET l_ima061=' ' LET l_ima021=' '
                 LET l_ima08 = ' ' LET l_ima15= ' '  LET l_ima25=' '
                 LET l_ima55 = ' ' LET l_ima63= ' '
              END IF
        END IF 
        IF p_level1> 10 THEN LET p_level1=10 END IF
        LET l_point = NULL
        IF p_level1 > 1 THEN
           FOR l_p = 1 TO p_level1 - 1
               LET l_point = l_point clipped,'.'
          END FOR
        END IF
        IF  (sr[1].ima02 IS NULL OR sr[1].ima02 = ' ') AND
            (sr[1].ima05 IS NULL OR sr[1].ima05 = ' ') AND
            (sr[1].ima08 IS NULL OR sr[1].ima08 = ' ')
        THEN SELECT bmq02,bmq021,bmq05,bmq08  #FUN-510033
             INTO sr[1].ima02,sr[1].ima021,sr[1].ima05,sr[1].ima08
             FROM bmq_file
            WHERE bmq01 = sr[1].bmp01
            IF SQLCA.sqlcode THEN
               LET sr[1].ima02 = ' '   LET sr[1].ima05 = ' '
               LET sr[1].ima021 = ' '
               LET sr[1].ima08  = ' '
            END IF
        END IF
        LET l_print_31=NULL
        LET l_print_31=l_point CLIPPED,sr[1].bmp01 CLIPPED 
        LET i =0  
        LET sr[1].bmp06 = sr[1].bmp06 * p_qty    #No.TQC-960122
        EXECUTE insert_prep USING sr[1].bmp01,sr[1].bmp011,sr[1].ima02,sr[1].ima021,sr[1].ima05,sr[1].ima08,
                                  sr[1].bmp02,sr[1].bmp06,sr[1].bmp10,sr[1].bmp04,sr[1].bmp05,sr[1].bmp03,
                                  sr[1].bmp28,l_print_31,l_ima02,l_ima021,l_ima08,l_ima061,l_ima25,
                                  l_ima63,p_level,i,g_bmp03_a               #No.FUN-880057 by cockroach
        #No.FUN-880057 --end--
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmp01,bmp011,ima02,ima021,ima05,ima08,", #FUN-510033 add ima021
            "bmp02,(bmp06/bmp07),bmp10,bmp04,bmp05,bmp03,bmp28", #FUN-560030
            " FROM bmp_file left OUTER join ima_file on bmp01 = ima01 and ima08 != 'A'",
            " WHERE bmp03='", p_key,"' AND bmp02 >",b_seq
            
 
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY"
        IF tm.arrange='1' THEN
            LET l_cmd=l_cmd CLIPPED," bmp01"
        ELSE
            LET l_cmd=l_cmd CLIPPED," bmp02"
        END IF
        PREPARE r111_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
			 CALL cl_err('P1:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM 
   END IF
        DECLARE r111_cur CURSOR for r111_ppp
 
        LET l_ac = 1
        FOREACH r111_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
			LET g_tot=g_tot+1
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
         #No.FUN-880057 --begin--
#           OUTPUT TO REPORT r111_rep(p_level,i,sr[i].*) 
         LET p_level1=p_level
       SELECT ima02,ima021,ima05,ima06,
             ima08,ima15,ima25,ima55,ima63
        INTO l_ima02,l_ima021,l_ima05,l_ima061,
             l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
        FROM ima_file
          WHERE ima01=g_bmp03_a
        IF SQLCA.sqlcode THEN
           LET l_ima02='' LET l_ima05='' LET l_ima021=''
           LET l_ima061='' LET l_ima08=''
           LET l_ima55='' LET l_ima63=''
        END IF
        IF  (l_ima02 IS NULL OR l_ima02 = ' ') AND
            (l_ima05 IS NULL OR l_ima05 = ' ') AND
            (l_ima08 IS NULL OR l_ima08 = ' ')
        THEN SELECT bmq02,bmq021,bmq05,bmq06,
                    bmq08,bmq15,bmq25,bmq25,bmq25
               INTO l_ima02,l_ima021,l_ima05,l_ima061,
                    l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
               FROM bmq_file
              WHERE bmq01 = g_bmp03_a
              IF SQLCA.sqlcode THEN
                 LET l_ima02 = ' ' LET l_ima05= ' '  LET l_ima061=' ' LET l_ima021=' '
                 LET l_ima08 = ' ' LET l_ima15= ' '  LET l_ima25=' '
                 LET l_ima55 = ' ' LET l_ima63= ' '
              END IF
        END IF 
        IF p_level1> 10 THEN LET p_level1=10 END IF
        LET l_point = NULL
        IF p_level1 > 1 THEN
           FOR l_p = 1 TO p_level1 - 1
               LET l_point = l_point clipped,'.'
          END FOR
        END IF
        IF  (sr[i].ima02 IS NULL OR sr[i].ima02 = ' ') AND
            (sr[i].ima05 IS NULL OR sr[i].ima05 = ' ') AND
            (sr[i].ima08 IS NULL OR sr[i].ima08 = ' ')
        THEN SELECT bmq02,bmq021,bmq05,bmq08  #FUN-510033
             INTO sr[i].ima02,sr[i].ima021,sr[i].ima05,sr[i].ima08
             FROM bmq_file
            WHERE bmq01 = sr[i].bmp01
            IF SQLCA.sqlcode THEN
               LET sr[i].ima02 = ' '   LET sr[i].ima05 = ' '
               LET sr[i].ima021 = ' '
               LET sr[i].ima08  = ' '
            END IF
        END IF
        LET l_print_31=NULL
        LET l_print_31=l_point CLIPPED,sr[i].bmp01 CLIPPED  
        LET sr[i].bmp06 = sr[i].bmp06 * p_qty    #No.TQC-960122
        EXECUTE insert_prep USING sr[i].bmp01,sr[i].bmp011,sr[i].ima02,sr[i].ima021,sr[i].ima05,sr[i].ima08,
                                  sr[i].bmp02,sr[i].bmp06,sr[i].bmp10,sr[i].bmp04,sr[i].bmp05,sr[i].bmp03,
                                  sr[i].bmp28,l_print_31,l_ima02,l_ima021,l_ima08,l_ima061,l_ima25,
                                  l_ima63,p_level,i,g_bmp03_a          #No.FUN-880057 by cockroach      
        #No.FUN-880057 --end--     
            CALL r111_bom(p_level,sr[i].bmp01,sr[i].bmp06)  #No.TQC-960122
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmp03
        END IF
    END WHILE
END FUNCTION
 
REPORT r111_rep(p_level,p_i,sr)
   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          sr  RECORD
              bmp01 LIKE bmp_file.bmp01,    #元件料號
              bmp011 LIKE bmp_file.bmp011,  #版本
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp04 LIKE bmp_file.bmp04,    #有效日期
              bmp05 LIKE bmp_file.bmp05,    #失效日期
              bmp03 LIKE bmp_file.bmp03,
              bmp28 LIKE bmp_file.bmp28     #FUN-560030
          END RECORD,
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima021,  #FUN-510033
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima15 LIKE ima_file.ima15,    #保稅否
          l_ima25 LIKE ima_file.ima25,    #庫存單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_point  LIKE cre_file.cre08,   #No.FUN-680096 VARCHAR(10)
          l_print_31  LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(100)
          l_p      LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_str2   LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(10)
          l_k      LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      SELECT ima02,ima021,ima05,ima06,
             ima08,ima15,ima25,ima55,ima63
       INTO l_ima02,l_ima021,l_ima05,l_ima06,
            l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
       FROM ima_file
      WHERE ima01=g_bmp03_a
      IF SQLCA.sqlcode THEN
          LET l_ima02='' LET l_ima05='' LET l_ima021=''
          LET l_ima06='' LET l_ima08=''
          LET l_ima55='' LET l_ima63=''
      END IF
      IF  (l_ima02 IS NULL OR l_ima02 = ' ') AND
          (l_ima05 IS NULL OR l_ima05 = ' ') AND
          (l_ima08 IS NULL OR l_ima08 = ' ')
      THEN SELECT bmq02,bmq021,bmq05,bmq06,
                  bmq08,bmq15,bmq25,bmq25,bmq25
             INTO l_ima02,l_ima021,l_ima05,l_ima06,
                  l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
             FROM bmq_file
            WHERE bmq01 = g_bmp03_a
              IF SQLCA.sqlcode THEN
                 LET l_ima02 = ' ' LET l_ima05= ' '  LET l_ima06=' ' LET l_ima021=' '
                 LET l_ima08 = ' ' LET l_ima15= ' '  LET l_ima25=' '
                 LET l_ima55 = ' ' LET l_ima63= ' '
              END IF
      END IF
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT ' '
      PRINT g_dash
 
   #----No.TQC-5B0030 modify
      #TQC-5B0109&051112
      #PRINT COLUMN  1,g_x[11] CLIPPED, g_bmp03_a,
      #      COLUMN 45,g_x[20] clipped,l_ima08,           #來源
      #      COLUMN 53,g_x[21] clipped,l_ima06,           #分群碼
      #      COLUMN 75,g_x[14] CLIPPED,l_ima25 CLIPPED    #庫存單位
      #PRINT COLUMN  1,g_x[12] CLIPPED,l_ima02,
      #      COLUMN 75,g_x[13] CLIPPED,l_ima63 CLIPPED    #發料單位
      PRINT COLUMN  1,g_x[11] CLIPPED, g_bmp03_a
      PRINT COLUMN  1,g_x[12] CLIPPED,l_ima02
      PRINT COLUMN  1,g_x[12] CLIPPED,l_ima021
      PRINT COLUMN  1,g_x[20] clipped,l_ima08,           #來源
            COLUMN  9,g_x[21] clipped,l_ima06,           #分群碼
            COLUMN 31,g_x[14] CLIPPED,l_ima25 CLIPPED,   #庫存單位
            COLUMN 56,g_x[13] CLIPPED,l_ima63 CLIPPED    #發料單位
      #END TQC-5B0109&051112
   #----end
 
      IF g_sma.sma888[1,1] = 'Y' THEN
          PRINT g_x[22] clipped,l_ima15
      ELSE
          PRINT ''
      END IF
      PRINT ' '
      #----
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINTX name=H2 g_x[38],g_x[39],g_x[40] #FUN-560030
      PRINT g_dash1
 
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      IF p_level = 1 AND p_i = 0 THEN
           #FUN-560030................begin
          #IF (PAGENO > 1 OR LINENO > 13) THEN
          #     LET g_pageno = 0
          #     SKIP TO TOP OF PAGE
          #     LET g_pageno = 1
          #END IF
           SKIP TO TOP OF PAGE
           #FUN-560030................end
      ELSE
          IF p_level> 10 THEN LET p_level=10 END IF
          LET l_point = NULL
          IF p_level > 1 THEN
             FOR l_p = 1 TO p_level - 1
                 LET l_point = l_point clipped,'.'
             END FOR
          END IF
          IF  (sr.ima02 IS NULL OR sr.ima02 = ' ') AND
              (sr.ima05 IS NULL OR sr.ima05 = ' ') AND
              (sr.ima08 IS NULL OR sr.ima08 = ' ')
          THEN SELECT bmq02,bmq021,bmq05,bmq08  #FUN-510033
                 INTO sr.ima02,sr.ima021,sr.ima05,sr.ima08 #FUN-510033
                 FROM bmq_file
                WHERE bmq01 = sr.bmp01
                  IF SQLCA.sqlcode THEN
                     LET sr.ima02 = ' '   LET sr.ima05 = ' '
                     LET sr.ima021 = ' '
                     LET sr.ima08  = ' '
                  END IF
          END IF
          LET l_print_31=NULL
          LET l_print_31=l_point CLIPPED,sr.bmp01 CLIPPED
          PRINTX name=D1 COLUMN g_c[31],l_print_31,
                         COLUMN g_c[32],sr.ima02,
                         COLUMN g_c[33],sr.ima05,
                         COLUMN g_c[34],sr.ima08,
                         COLUMN g_c[35],cl_numfor(sr.bmp06,36,4),
                         COLUMN g_c[36],sr.bmp011,
                         COLUMN g_c[37],sr.bmp10
          PRINTX name=D2 COLUMN g_c[38],' ',
                         COLUMN g_c[39],sr.ima021,
                         COLUMN g_c[40],sr.bmp28  #FUN-560030
      END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      #FUN-560030................begin
     #IF g_pageno = 0 OR l_last_sw = 'y'
      IF l_last_sw = 'y'
      #FUN-560030................end
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
