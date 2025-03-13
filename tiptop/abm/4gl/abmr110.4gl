# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abmr110.4gl
# Descriptions...: 工程BOM-單階產品結構用途查詢
# Input parameter:
# Return code....:
# Date & Author..: 94/06/15 By Apple
# Modify.........: No.FUN-510033 05/01/17 By Mandy 報表轉XML
# Modify.........: No.FUN-560030 05/06/14 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加controlp
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-620143 06/02/27 By Claire 主件編號QBE改為元件編號
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-850058 08/05/22 BY ve007 報表輸出方式 改為CR
# Modify.........: No.FUN-870144 08/07/29 BY zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				  # Print condition RECORD
       		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
                # Prog. Version..: '5.30.06-13.03.12(04),	          #  分群碼   #TQC-610068
       		arrange   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                blow      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
       		more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_bmp03  LIKE bmp_file.bmp03,
          g_bmp011 LIKE bmp_file.bmp011,
          g_ima02 LIKE ima_file.ima02,    #品名規格
          g_ima05 LIKE ima_file.ima05,    #版本
          g_ima06 LIKE ima_file.ima06,    #分群碼
          g_ima08 LIKE ima_file.ima08,    #來源
          g_ima15 LIKE ima_file.ima15,    #保稅否
          g_ima37 LIKE ima_file.ima37,    #補貨
          g_ima25 LIKE ima_file.ima25,
          g_ima63 LIKE ima_file.ima63
 
DEFINE   g_i      LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING,                           #No.FUN-850058
         g_sql          STRING,                           #No.FUN-850058
         g_str          STRING                            #No.FUN-850058
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				        # Supress DEL key function 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
   #No.FUN-850058 --begin--
   LET g_sql = "bmp01.bmp_file.bmp01,",
               "bmp011.bmp_file.bmp011,",
               "bmp02.bmp_file.bmp02,",
               "bmp03.bmp_file.bmp03,",
               "bmp06.bmp_file.bmp06,",
               "bmp10.bmp_file.bmp10,",
               "bmp28.bmp_file.bmp28,",
               "phatom.bmp_file.bmp01,",
               "ima02.ima_file.ima02,",
               "ima05.ima_file.ima05,",
               "ima06.ima_file.ima06,",
               "ima08.ima_file.ima08,",
               "ima15.ima_file.ima15,",
               "ima37.ima_file.ima37,",
               "ima25.ima_file.ima25,",
               "ima63.ima_file.ima63,",
               "ima02b.ima_file.ima02,",
               "ima05b.ima_file.ima05,", 
               "ima021.ima_file.ima021,",
               "ima021b.ima_file.ima021,",
               "ima08b.ima_file.ima08,",
               "ima15b.ima_file.ima15"       
   LET l_table = cl_prt_temptable('abmr110',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN             
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF 
   #No.FUN-850058 --end--  
 
   LET g_pdate = ARG_VAL(1)	        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.class  = ARG_VAL(8)  #TQC-610068
   LET tm.arrange  = ARG_VAL(9)
   LET tm.blow     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r110_tm(0,0)			# Input print condition
      ELSE CALL abmr110()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bmp01       LIKE bmp_file.bmp01,
          l_bmp011      LIKE bmp_file.bmp011,
          l_bmp03       LIKE bmp_file.bmp03,
          l_ima06       LIKE ima_file.ima06,
          l_cmd		LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
 
   OPEN WINDOW r110_w AT p_row,p_col
        WITH FORM "abm/42f/abmr110"
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
   LET tm.arrange ='1'              #按元件料件編號遞增順序排列
  #---------No.FUN-670041 modify
  #LET tm.blow = g_sma.sma29
   LET tm.blow = 'Y'
  #---------No.FUN-670041 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmp03,bmp28 FROM item,acode #FUN-560030
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
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_ima5"  #TQC-620143
               LET g_qryparam.form = "q_bmp03"   #TQC-620143
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
            END IF
#No.FUN-570240 --end--
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT bmp01,bmp011 FROM bmp_file",
                 " WHERE  ",tm.wc CLIPPED
       PREPARE r110_precnt FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
       END IF
       DECLARE r110_cnt
            CURSOR FOR r110_precnt
       MESSAGE " SEARCHING ! "
       CALL ui.Interface.refresh()
       FOREACH r110_cnt INTO l_bmp01,l_bmp011
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
   INPUT BY NAME tm.arrange,tm.blow,tm.more WITHOUT DEFAULTS
      AFTER FIELD arrange
         IF tm.arrange NOT MATCHES '[12]' THEN
             NEXT FIELD arrange
         END IF
      AFTER FIELD blow
         IF tm.blow IS NULL OR tm.blow NOT MATCHES '[YNyn]' THEN
             NEXT FIELD blow
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
         CALL r110_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr110','9031',1)
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
                        #" '",tm.class CLIPPED,"'",  #TQC-610068
                         " '",tm.arrange CLIPPED,"'",
                         " '",tm.blow    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr110',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr110()
   ERROR ""
END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION r110_wc()
   DEFINE l_wc LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r110_w2 AT 2,2
        WITH FORM "abm/42f/abmi610"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi610")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bmo01,bmo04,bmo02,bmo03,
        bmp02,bmp03,bmp06,bmp08,bmp14,bmp15,bmp16,bmp17,bmp07,bmp09
        FROM
        bmo01,bmo04,bmo02,bmo03,
        s_bmp[1].bmp02,s_bmp[1].bmp03,s_bmp[1].bmp06,s_bmp[1].bmp08,
        s_bmp[1].bmp14,s_bmp[1].bmp15,s_bmp[1].bmp16,s_bmp[1].bmp17,
        s_bmp[1].bmp07,s_bmp[1].bmp09
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
 
   CLOSE WINDOW r110_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
END FUNCTION
 
FUNCTION r110_cur()
DEFINE l_sql  LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(1000)
 
     LET l_sql = "SELECT '',",
                 " bmo01, bmp011,bmp02, bmp03, bmp06/bmp07,bmp10,bmp28,'',", #FUN-560030
                 " A.ima02, A.ima05, A.ima06, A.ima08, A.ima15,",
                 " A.ima37, A.ima25, A.ima63,",
                 " B.ima02, B.ima05, B.ima08 ",
                 " FROM bmp_file, OUTER ima_file A,",
                 "      bmo_file, OUTER ima_file B ",
                 " WHERE bmo01=bmp01",
                 "   AND bmo011=bmp011",
                 "   AND bmp_file.bmp03 = A.ima01 AND bmo_file.bmo01 = B.ima01 ",
                 "   AND bmp03 = ? ",
                 "   AND bmp28 = bmo06 ", #FUN-560030
                 "   AND ((bmp28 = ' ') OR (bmp28='') OR (bmp28 IS NULL))" #FUN-560030
 
     PREPARE r110_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r110_cs2 CURSOR WITH HOLD FOR r110_prepare2
END FUNCTION
 
FUNCTION r110_phatom(p_phatom,p_ver,p_qpa)
   DEFINE p_phatom  LIKE bmp_file.bmp01,
          p_ver     LIKE bmp_file.bmp011,
          p_qpa     LIKE bmp_file.bmp06,
          l_ac,l_i  LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_tot,l_times LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_chr		LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          l_ute_flag    LIKE type_file.chr2,      #No.FUN-680096 VARCHAR(2)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(20)
              bmp01 LIKE bmp_file.bmp01,    #主件料件
              bmp011 LIKE bmp_file.bmp011,  #版本
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp03 LIKE bmp_file.bmp03,    #元件料號
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp28 LIKE bmp_file.bmp28,    #FUN-560030
              phatom LIKE bmp_file.bmp01,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima25 LIKE ima_file.ima25,    #庫存單位
              ima63 LIKE ima_file.ima63     #發料單位
          END RECORD,
          sr2 DYNAMIC ARRAY OF RECORD       #每階存放資料
              ima02  LIKE ima_file.ima02,
              ima05  LIKE ima_file.ima05,
              ima08  LIKE ima_file.ima08,
              ima15  LIKE ima_file.ima15
          END RECORD,
          l_bmp01  LIKE bmp_file.bmp01
 
    LET l_ac = 1
    LET arrno = 600
    LET l_ute_flag='US'
    FOREACH r110_cs2
    USING p_phatom
    INTO sr[l_ac].*,sr2[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET sr[l_ac].phatom = p_phatom
      LET sr[l_ac].bmp06= sr[l_ac].bmp06 * p_qpa
      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
	LET l_tot=l_ac-1
    FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
        IF sr2[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
           CALL r110_phatom(sr[l_i].bmp01,sr[l_i].bmp011,sr[l_i].bmp06)
           CONTINUE FOR
        END IF
        IF tm.arrange='1' THEN
            LET sr[l_i].order1=sr[l_i].bmp01
        ELSE
            LET sr[l_i].order1=sr[l_i].bmp02
        END IF
        LET sr[l_i].bmp03= g_bmp03
        LET sr[l_i].bmp011= g_bmp011
        LET sr[l_i].ima02= g_ima02
        LET sr[l_i].ima05= g_ima05
        LET sr[l_i].ima06= g_ima06
        LET sr[l_i].ima08= g_ima08
        LET sr[l_i].ima15= g_ima15
        LET sr[l_i].ima37= g_ima37
        LET sr[l_i].ima25= g_ima25
        LET sr[l_i].ima37= g_ima37
        LET sr[l_i].ima25= g_ima25
        LET sr[l_i].ima63= g_ima63
        OUTPUT TO REPORT r110_rep(sr[l_i].*,sr2[l_i].*)
    END FOR
END FUNCTION
 
FUNCTION abmr110()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          sr  RECORD
              order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(20)
              bmp01 LIKE bmp_file.bmp01,    #主件料件
              bmp011 LIKE bmp_file.bmp011,  #版本
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp03 LIKE bmp_file.bmp03,    #元件料號
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp28 LIKE bmp_file.bmp28,    #FUN-560030
              phatom LIKE bmp_file.bmp01,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima25 LIKE ima_file.ima25,    #生產單位
              ima63 LIKE ima_file.ima63     #發料單位
          END RECORD,
          sr2 RECORD
              ima02  LIKE ima_file.ima02,
              ima05  LIKE ima_file.ima05,
              ima08  LIKE ima_file.ima08,
              ima15  LIKE ima_file.ima15
          END RECORD
     DEFINE l_ima021_h  LIKE ima_file.ima021  #FUN-850058
     DEFINE l_ima021_b  LIKE ima_file.ima021  #FUN-850058
      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)                                    #No.FUN-850058
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-850058
     
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
                 " bmo01,bmp011, bmp02, bmp03, bmp06/bmp07,bmp10,bmp28,'',", #FUN-560030
                 " A.ima02, A.ima05, A.ima06, A.ima08, A.ima15,",
                 " A.ima37, A.ima25, A.ima63,",
                 " B.ima02, B.ima05, B.ima08 ",
                 " FROM bmp_file, OUTER ima_file A,",
                 "      bmo_file, OUTER ima_file B ",
                 " WHERE bmo01=bmp01 AND ",
                 "       bmo011=bmp011 AND ",
                 " bmp_file.bmp03 = A.ima01 AND bmo_file.bmo01 = B.ima01 ",
                 " AND bmo06=bmp28 ", #FUN-560030
                 " AND ",tm.wc
 
     PREPARE r110_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r110_curs1 CURSOR FOR r110_prepare1
 
#     CALL cl_outnam('abmr110') RETURNING l_name      #No.FUN-850058
#     START REPORT r110_rep TO l_name                 #No.FUN-850058
     CALL r110_cur()
     FOREACH r110_curs1 INTO sr.*,sr2.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr2.ima08 = 'X' AND tm.blow = 'Y' THEN
          LET g_bmp03 = sr.bmp03
          LET g_bmp011 = sr.bmp011
          LET g_ima02 = sr.ima02
          LET g_ima05 = sr.ima05
          LET g_ima06 = sr.ima06
          LET g_ima08 = sr.ima08
          LET g_ima15 = sr.ima15
          LET g_ima37 = sr.ima37
          LET g_ima25 = sr.ima25
          LET g_ima63 = sr.ima63
          CALL r110_phatom(sr.bmp01,sr.bmp011,sr.bmp06)
          CONTINUE FOREACH
       END IF
       IF tm.arrange='1' THEN
           LET sr.order1=sr.bmp01
       ELSE
           LET sr.order1=sr.bmp02
       END IF
       #No.FUN-850058 --begin--
#      OUTPUT TO REPORT r110_rep(sr.*,sr2.*)
       LET l_ima021_h = NULL
       SELECT ima021 INTO  l_ima021_h
         FROM ima_file
         WHERE ima01 = sr.bmp03
       IF  (sr.ima02 IS NULL OR sr.ima02 = ' ') AND
           (sr.ima05 IS NULL OR sr.ima05 = ' ') AND
           (sr.ima08 IS NULL OR sr.ima08 = ' ')
         THEN SELECT bmq02,bmq021,bmq05,bmq08,bmq25,bmq25 #FUN-510033
               INTO sr.ima02,l_ima021_h,sr.ima05,sr.ima08,sr.ima25,sr.ima63
               FROM bmq_file
             WHERE bmq01 = sr.bmp03
               IF SQLCA.sqlcode THEN
                  LET sr.ima02 = ' '   LET sr.ima05 = ' '
                  LET l_ima021_h = ' '
                  LET sr.ima08  = ' '
               END IF
       END IF
       LET l_ima021_b = NULL
       SELECT ima021 INTO  l_ima021_b
         FROM ima_file
        WHERE ima01 = sr.bmp01
       IF  (sr2.ima02 IS NULL OR sr2.ima02 = ' ') AND
           (sr2.ima05 IS NULL OR sr2.ima05 = ' ') AND
           (sr2.ima08 IS NULL OR sr2.ima08 = ' ')
       THEN SELECT bmq02,bmq021,bmq05,bmq08          #FUN-510033
             INTO sr2.ima02,l_ima021_b,sr2.ima05,sr2.ima08
             FROM bmq_file
            WHERE bmq01 = sr.bmp01
              IF SQLCA.sqlcode THEN
                 LET sr2.ima02 = ' '   LET sr2.ima05 = ' '
                 LET l_ima021_b = ' '
                 LET sr2.ima08  = ' '
              END IF
       END IF
    
       EXECUTE insert_prep USING  sr.bmp01,sr.bmp011,sr.bmp02,sr.bmp03,sr.bmp06,sr.bmp10,
                                  sr.bmp28,sr.phatom,sr.ima02,sr.ima05,sr.ima06,sr.ima08,sr.ima15,
                                  sr.ima37,sr.ima25,sr.ima63,sr2.ima02,sr2.ima05,
                                  l_ima021_h,l_ima021_b,sr2.ima08,sr2.ima15     
       #No.FUN-850058 --end--
     END FOREACH
 
     DISPLAY "" AT 2,1
     #NO.FUN-850058--begin--
#    FINISH REPORT r110_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN 
          CALL cl_wcchp(tm.wc,'bmp03,bmp28')
             RETURNING tm.wc 
     END IF
     LET g_str=tm.wc ,";",g_sma.sma888[1,1]
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('abmr110','abmr110',l_sql,g_str)
     #No.FUN-850058 --end--
END FUNCTION
#No.FUN-870144
 
REPORT r110_rep(sr,sr2)
   DEFINE l_ima021_h  LIKE ima_file.ima021  #FUN-510033
   DEFINE l_ima021_b  LIKE ima_file.ima021  #FUN-510033
   DEFINE l_last_sw   LIKE type_file.chr1,  #No.FUN-680096 VARCHAR(1)
          sr  RECORD
              order1  LIKE bmp_file.bmp02,  #No.FUN-680096 VARCHAR(20)
              bmp01 LIKE bmp_file.bmp01,    #主件料件
              bmp011 LIKE bmp_file.bmp011,  #版本
              bmp02 LIKE bmp_file.bmp02,    #項次
              bmp03 LIKE bmp_file.bmp03,    #元件料號
              bmp06 LIKE bmp_file.bmp06,    #QPA
              bmp10 LIKE bmp_file.bmp10,    #發料單位
              bmp28 LIKE bmp_file.bmp28,    #FUN-560030
              phatom LIKE bmp_file.bmp01,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima25 LIKE ima_file.ima25,    #庫存單位
              ima63 LIKE ima_file.ima63     #發料單位
          END RECORD,
          sr2 RECORD
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15     #保稅否
          END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bmp03,sr.bmp01,sr.bmp011,sr.order1
  FORMAT
   PAGE HEADER
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
#----
      LET l_ima021_h = NULL
      SELECT ima021 INTO  l_ima021_h
        FROM ima_file
       WHERE ima01 = sr.bmp03
      IF  (sr.ima02 IS NULL OR sr.ima02 = ' ') AND
          (sr.ima05 IS NULL OR sr.ima05 = ' ') AND
          (sr.ima08 IS NULL OR sr.ima08 = ' ')
      THEN SELECT bmq02,bmq021,bmq05,bmq08,bmq25,bmq25 #FUN-510033
             INTO sr.ima02,l_ima021_h,sr.ima05,sr.ima08,sr.ima25,sr.ima63
             FROM bmq_file
            WHERE bmq01 = sr.bmp03
              IF SQLCA.sqlcode THEN
                 LET sr.ima02 = ' '   LET sr.ima05 = ' '
                 LET l_ima021_h = ' '
                 LET sr.ima08  = ' '
              END IF
      END IF
      
      #TQC-5B0109&051112
      #PRINT COLUMN  1,g_x[15] CLIPPED,sr.bmp03,
      #      COLUMN 31,g_x[20] clipped,sr.ima08,   #來源
      #      COLUMN 38,g_x[21] clipped,sr.ima06,   #分群碼
      #      COLUMN 64,g_x[17] CLIPPED,sr.ima25
      #PRINT COLUMN  1,g_x[14] CLIPPED,sr.ima02,
      #      COLUMN 64,g_x[18] CLIPPED,sr.ima63
      #PRINT COLUMN  1,g_x[16] CLIPPED,l_ima021_h,
      #      COLUMN 64,g_x[24] CLIPPED,sr.bmp28    #FUN-560030
      PRINT COLUMN  1,g_x[15] CLIPPED,sr.bmp03
      PRINT COLUMN  1,g_x[14] CLIPPED,sr.ima02
      PRINT COLUMN  1,g_x[16] CLIPPED,l_ima021_h
 
      PRINT COLUMN 1,g_x[20] clipped,sr.ima08,   #來源
            COLUMN 9,g_x[21] clipped,sr.ima06,   #分群碼
            COLUMN 35,g_x[17] CLIPPED,sr.ima25
 
      PRINT COLUMN 1,g_x[18] CLIPPED,sr.ima63 ,
            COLUMN 35,g_x[24] CLIPPED,sr.bmp28    #FUN-560030
 
      #END TQC-5B0109&051112
 
      IF g_sma.sma888[1,1] ='Y' THEN
         PRINT g_x[23] clipped,sr.ima15
      ELSE
          PRINT ' '
      END IF
#----
      PRINT
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.bmp03
     #FUN-560030................begin
     #IF (PAGENO > 1 OR LINENO > 13)
     #   THEN SKIP TO TOP OF PAGE
     #END IF
     SKIP TO TOP OF PAGE
     #FUN-560030................end
 
   ON EVERY ROW
      LET l_ima021_b = NULL
      SELECT ima021 INTO  l_ima021_b
        FROM ima_file
       WHERE ima01 = sr.bmp01
      IF  (sr2.ima02 IS NULL OR sr2.ima02 = ' ') AND
          (sr2.ima05 IS NULL OR sr2.ima05 = ' ') AND
          (sr2.ima08 IS NULL OR sr2.ima08 = ' ')
      THEN SELECT bmq02,bmq021,bmq05,bmq08          #FUN-510033
             INTO sr2.ima02,l_ima021_b,sr2.ima05,sr2.ima08
             FROM bmq_file
            WHERE bmq01 = sr.bmp01
              IF SQLCA.sqlcode THEN
                 LET sr2.ima02 = ' '   LET sr2.ima05 = ' '
                 LET l_ima021_b = ' '
                 LET sr2.ima08  = ' '
              END IF
      END IF
      PRINT COLUMN g_c[31],sr.bmp01,
            COLUMN g_c[32],sr2.ima02,
            COLUMN g_c[33],l_ima021_b,
            COLUMN g_c[34],sr2.ima05,
            COLUMN g_c[35],sr2.ima08,
            COLUMN g_c[36],cl_numfor(sr.bmp06,36,3),
            COLUMN g_c[37],sr.bmp011,
            COLUMN g_c[38],sr.bmp10
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'y'  #TQC-5B0109
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED
      END IF
END REPORT
