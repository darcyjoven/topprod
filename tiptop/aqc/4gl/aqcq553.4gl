# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcq553.4gl
# Descriptions...: FQC 品質記錄查詢(BY 料號 )
# Date & Author..: 99/04/18 By Iceman
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/02/01 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-530065 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 單頭品名規格調整
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/15 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQc-6C0227 07/01/05 By xufeng 結束和接下頁上方應為雙橫線
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/13 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850050 08/05/09 By lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/07 By lilingyu 平行工藝
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.TQC-C90117 12/09/28 By chenjing 當判定為3時顯示名稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc			LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(300)
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            qcm021              LIKE qcm_file.qcm021,   #料件編號
            ima02               LIKE ima_file.ima02,    #料件名稱
            ima021              LIKE ima_file.ima021,   #料件規格
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE                 #檢驗起
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE         #檢驗止
            lot                 LIKE qcf_file.qcf32,         #No.FUN-680104 DECIMAL(15,3)       #檢驗批號
            rejlot              LIKE qcf_file.qcf32,         #No.FUN-680104 DECIMAL(15,3)      #不合格批號
            rejrate             LIKE ima_file.ima20         #No.FUN-680104 DECIMAL(9,3)      #不合格批率
        END RECORD,
    g_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
            qcm02               LIKE qcm_file.qcm02,    #工單編號
            qcm03               LIKE qcm_file.qcm03,   
            qcm012              LIKE qcm_file.qcm012,   #FUN-A60092 add
            qcm05               LIKE qcm_file.qcm05,   #製程序
            sgm04               LIKE sgm_file.sgm04,     #作業編號
           #---------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
            qcm22               LIKE qcm_file.qcm22,  #送驗量
            qcm091              LIKE qcm_file.qcm091,   #檢驗量
            qty                 LIKE qcm_file.qcm22,    #不良率
           #---------------No.TQC-750064 end
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
           #desc                VARCHAR(6),                #判定
            desc                LIKE ze_file.ze03,      #No.TQC-610007
            cr                  LIKE qcn_file.qcn07,    #No.FUN-680104 DEC(15,3)        #CR
            ma                  LIKE qcn_file.qcn07,    #No.FUN-680104 DEC(15,3)          #MA
            mi                  LIKE qcn_file.qcn07     #No.FUN-680104 DEC(15,3)      #MI
        END RECORD,
    s_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
            qcm02               LIKE qcm_file.qcm02,    #工單編號
            qcm03               LIKE qcm_file.qcm03,    
            qcm012              LIKE qcm_file.qcm012,   #FUN-A60092 add
            qcm05              LIKE qcm_file.qcm05,     #製程序
            sgm04               LIKE sgm_file.sgm04,    #作業編號
           #---------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
            qcm22               LIKE qcm_file.qcm22,  #送驗量
            qcm091              LIKE qcm_file.qcm091,   #檢驗量
            qty                 LIKE qcm_file.qcm22,    #不良率
           #---------------No.TQC-750064 end
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
           #desc                VARCHAR(6),                #判定
            desc                LIKE ze_file.ze03,      #No.TQC-610007
            cr                  LIKE qcn_file.qcn07,      #No.FUN-680104 DEC(15,3)         #CR
            ma                  LIKE qcn_file.qcn07,      #No.FUN-680104 DEC(15,3)         #MA
            mi                  LIKE qcn_file.qcn07       #No.FUN-680104 DEC(15,3)        #MI
        END RECORD,
 
    g_query_flag     LIKE type_file.num5,         #No.FUN-680104 SMALLINT    #第一次進入程式時即進入Query之後進入next
    g_curr 	     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_wc,g_wc2,g_sql STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b          LIKE type_file.num5,         #單身筆數,        #No.FUN-680104 SMALLINT
    m_qcm09          LIKE qcm_file.qcm09,
    m_qcm02          LIKE qcm_file.qcm02,
    m_qcm01          LIKE qcm_file.qcm01,
    l_qcm021         LIKE qcm_file.qcm021,
    m_no             LIKE type_file.num10,        #No.FUN-680104 INTEGER
    cr,ma,mi         LIKE qcn_file.qcn07          #No.FUN-680104 DEC(15,3)
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE   g_str      STRING
DEFINE   l_table    STRING
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col  LIKE type_file.num5  #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
#No.FUN-850050---start---
   LET g_sql="qcm04.qcm_file.qcm04,",
             "qcm02.qcm_file.qcm02,",
             "qcm22.qcm_file.qcm22,",
             "qcm091.qcm_file.qcm091,",
             "judg.ze_file.ze03,",
             "cr.qcn_file.qcn07,",
             "ma.qcn_file.qcn07,",
             "mi.qcn_file.qcn07,",
             "qcm03.qcm_file.qcm03,",
             "qcm05.qcm_file.qcm05,",
             "sgm04.sgm_file.sgm04,",
             "qcm021.qcm_file.qcm021,",
             "qcm09.qcm_file.qcm09"
   LET l_table = cl_prt_temptable('aqcq553',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850050---end---
 
    LET m_no=1
    LET g_curr = '1'
    LET g_query_flag=1
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW q553_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq553"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#FUN-A60092 --begin--
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("qcm012",TRUE)
    ELSE
       CALL cl_set_comp_visible("qcm012",FALSE)
    END IF 	
#FUN-A60092 --end-- 
 
#    IF cl_chk_act_auth() THEN
#       CALL q553_q()
#    END IF
    CALL q553_menu()
    CLOSE WINDOW q553_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q553_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_qcm1.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcm.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcm021,ima02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(qcm021)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_qcm.qcm021
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcm021
            NEXT FIELD qcm021
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
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
   IF INT_FLAG THEN RETURN END IF
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
        DISPLAY BY NAME tm.bdate,tm.edate
	INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
		AFTER FIELD bdate
                   IF cl_null(tm.bdate) THEN CALL cl_err('','aap-099',0)
                      NEXT FIELD bdate
                   END IF
		AFTER FIELD edate
                   IF cl_null(tm.edate) THEN CALL cl_err('','aap-099',0)
                      NEXT FIELD edate
                   END IF
                   IF tm.edate<tm.bdate THEN CALL cl_err('','aap-099',0)
			NEXT FIELD edate
		   END IF
	   ON IDLE g_idle_seconds
	      CALL cl_on_idle()
	      CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
	
	END INPUT
        IF INT_FLAG THEN RETURN END IF
#bugno:6062modify...........................
        LET g_qcm.bdate=tm.bdate
        LET g_qcm.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
     LET g_sql = "SELECT UNIQUE qcm021",
                 "  FROM qcm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm14='Y' AND qcm18='2' AND ",tm.wc CLIPPED
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcmuser', 'qcmgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY qcm021"
 
   PREPARE q553_prepare FROM g_sql
   DECLARE q553_cs SCROLL CURSOR WITH HOLD FOR q553_prepare
     LET g_sql = "SELECT COUNT(UNIQUE qcm021)",
                 "  FROM qcm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm14='Y' AND qcm18='2' AND ",tm.wc CLIPPED
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q553_prepare1 FROM g_sql
   DECLARE q553_count CURSOR FOR q553_prepare1
END FUNCTION
 
 
#中文的MENU
FUNCTION q553_menu()
 
   WHILE TRUE
      CALL q553_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q553_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q553_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcm1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q553_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcm1.clear() #MOD-5A0169 add
    CALL q553_cs()
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    OPEN q553_cs                      # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       LET m_cnt = 0
       FOREACH q553_count INTO l_qcm021
          IF SQLCA.sqlcode THEN
             EXIT FOREACH
          END IF
          LET m_cnt=m_cnt+1
       END FOREACH
       LET  g_row_count = m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
       CALL q553_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION q553_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q553_cs INTO g_qcm.qcm021
        WHEN 'P' FETCH PREVIOUS q553_cs INTO g_qcm.qcm021
        WHEN 'F' FETCH FIRST    q553_cs INTO g_qcm.qcm021
        WHEN 'L' FETCH LAST     q553_cs INTO g_qcm.qcm021
        WHEN '/'
          IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
#                    CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
          END IF
          FETCH ABSOLUTE g_jump q553_cs INTO g_qcm.qcm021
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN CALL cl_err(' ',SQLCA.sqlcode,0)RETURN ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     END IF
    SELECT ima02,ima021 INTO g_qcm.ima02,g_qcm.ima021  FROM ima_file
     WHERE ima01=g_qcm.qcm021
 
    SELECT COUNT(*) INTO g_qcm.lot FROM qcm_file
     WHERE qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate
       AND qcm021 = g_qcm.qcm021 AND qcm14='Y' AND qcm18='2'
    IF SQLCA.sqlcode THEN  LET g_qcm.lot=0 END IF
 
    SELECT COUNT(*) INTO g_qcm.rejlot FROM qcm_file
     WHERE qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate
       AND qcm021 = g_qcm.qcm021 AND qcm14='Y' AND qcm18='2'
       AND qcm09 <> "1"
    IF SQLCA.sqlcode THEN LET g_qcm.rejlot=0 END IF
 
    IF g_qcm.lot=0 OR g_qcm.lot IS NULL THEN
       LET g_qcm.rejrate=0
    ELSE
       LET g_qcm.rejrate=g_qcm.rejlot/g_qcm.lot*100
    END IF
 
    CALL q553_show()
END FUNCTION
 
FUNCTION q553_show()
   DISPLAY BY NAME g_qcm.*
   CALL q553_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q553_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(800)
          #l_ex      LIKE cqg_file.cqg08,         #No.FUN-680104 DECIMAL(8,4)    #TQC-B90211
          l_cho	    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
          l_qcm01   LIKE qcm_file.qcm01
	
    #-------------No.TQC-750064 modify
    #LET l_sql ="SELECT qcm04,qcm02,qcm03,qcm05,sgm04,qcm06,qcm22,",
     LET l_sql ="SELECT qcm04,qcm02,qcm03,qcm012,qcm05,sgm04,qcm22,qcm091,",  #FUN-A60092 add qcm012
    #-------------No.TQC-750064 end
                 "      '','',qcm09,0,0,0,qcm01",
                 "  FROM qcm_file, OUTER sgm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm03 = sgm_file.sgm01 AND qcm18='2' ",
                 "   AND sgm_file.sgm03 = qcm05 AND qcm14='Y' ",
                 "   AND sgm_file.sgm012=qcm012",   #FUN-A60092 add
                 "   AND qcm021 = '", g_qcm.qcm021,"' ",
                 " ORDER BY qcm04"
    PREPARE q553_pb FROM l_sql
    DECLARE q553_bcs CURSOR FOR q553_pb
    FOR g_cnt = 1 TO g_qcm1.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_qcm1[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q553_bcs INTO g_qcm1[g_cnt].*,l_qcm01
     CASE g_qcm1[g_cnt].desc
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                  g_qcm1[g_cnt].desc
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                  g_qcm1[g_cnt].desc
     #TQC-C90117--start--
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                  g_qcm1[g_cnt].desc
     #TQC-C90117--end--
     END CASE
 
       #------------------No.TQC-750064 modify
       #IF g_qcm1[g_cnt].qcm06  IS NULL THEN LET g_qcm1[g_cnt].qcm06=0 END IF
        IF g_qcm1[g_cnt].qcm091  IS NULL THEN LET g_qcm1[g_cnt].qcm091=0 END IF
       #------------------No.TQC-750064 end
 
        #------- CR
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].cr FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
           AND qcm012=g_qcm1[g_cnt].qcm012   #FUN-A60092 add
        IF STATUS OR g_qcm1[g_cnt].cr IS NULL THEN LET g_qcm1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].ma FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
           AND qcm012=g_qcm1[g_cnt].qcm012    #FUN-A60092 add
        IF STATUS OR g_qcm1[g_cnt].ma IS NULL THEN LET g_qcm1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].mi FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
           AND qcm012=g_qcm1[g_cnt].qcm012   #FUN-A60092 add
        IF STATUS OR g_qcm1[g_cnt].mi IS NULL THEN LET g_qcm1[g_cnt].mi=0 END IF
 
       #-------------------No.TQC-750064 modify
       #LET g_qcm1[g_cnt].qty=g_qcm1[g_cnt].cr*g_qcz.qcz02/g_qcz.qcz021+
       #                      g_qcm1[g_cnt].ma*g_qcz.qcz03/g_qcz.qcz031+
       #                      g_qcm1[g_cnt].mi*g_qcz.qcz04/g_qcz.qcz041
        LET g_qcm1[g_cnt].qty=g_qcm1[g_cnt].qcm22 - g_qcm1[g_cnt].qcm091
 
       #IF g_qcm1[g_cnt].qcm06=0 THEN
        IF g_qcm1[g_cnt].qcm22=0 THEN
           LET g_qcm1[g_cnt].rate=0
        ELSE
          #LET g_qcm1[g_cnt].rate=(g_qcm1[g_cnt].qty/g_qcm1[g_cnt].qcm06)*100
           LET g_qcm1[g_cnt].rate=(g_qcm1[g_cnt].qty/g_qcm1[g_cnt].qcm22)*100
        END IF
       #-------------------No.TQC-750064 end
	LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_qcm1.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q553_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_qcm1 TO s_qcm1.* #MOD-5A0169 mark
   DISPLAY ARRAY g_qcm1 TO s_qcm1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-5A0169 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     # BEFORE ROW
     #    LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #    LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q553_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q553_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q553_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q553_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q553_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-530065  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.FUN-530065  --end
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-850050---start--- 
FUNCTION q553_out()
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(800)
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_qcm09         LIKE qcm_file.qcm09,
    sr              RECORD
            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
            qcm02               LIKE qcm_file.qcm02,    #工單編號
            qcm021              LIKE qcm_file.qcm021,   #料件編號
            qcm03              LIKE qcm_file.qcm03,   #製程序
            qcm05              LIKE qcm_file.qcm05,   #製程序
           #--------------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
            qcm091              LIKE qcm_file.qcm091,   #檢驗量
           #--------------------No.TQC-750064 end
            qcm22               LIKE qcm_file.qcm22,  #送驗量
            qcm09               LIKE qcm_file.qcm09,
            qty                 LIKE qcm_file.qcm06,       #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
            desc                LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(6)         #判定
            cr                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)
            ma                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)
            mi                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)
            sgm04               LIKE sgm_file.sgm04,       #作業編號
            lot                 LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)        #檢驗批號
            rejlot              LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)       #不合格批號
            rejrate             LIKE ima_file.ima20,       #No.FUN-680104 DECIMAL(9,3)       #不合格批率
            ima02               LIKE ima_file.ima02,       #料件名稱
            ima021              LIKE ima_file.ima021       #料件規格
           ,qcm012              LIKE qcm_file.qcm012       #FUN-A60092 add 
        END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE cob_file.cob01,                #No.FUN-680104 VARCHAR(40)
    l_qcm01         LIKE qcm_file.qcm01
 
    IF tm.wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#    CALL cl_outnam('aqcq553') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    #-------------------No.TQC-750064 modify
    #LET l_sql="SELECT qcm04,qcm02,qcm021,qcm03,qcm05,qcm06,qcm22,qcm09,'','',",
     LET l_sql="SELECT qcm04,qcm02,qcm021,qcm03,qcm05,qcm091,qcm22,qcm09,'','',",
    #-------------------No.TQC-750064 end
                 "       qcm09,0,0,0,sgm04,'','','','','',qcm012,qcm01",  #FUN-A60092 add qcm012
                 "  FROM qcm_file, OUTER sgm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm03 = sgm_file.sgm01 ",
                 "   AND sgm_file.sgm03 = qcm05",
                 "   AND sgm_file.sgm012=qcm012",   #FUN-A60092 
                 "   AND sgm_file.sgm03_par = qcm021 AND qcm14='Y' AND qcm18='2' ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY qcm021"
 
    PREPARE q553_p1 FROM l_sql                # RUNTIME 編譯
    DECLARE q553_co                         # SCROLL CURSOR
        CURSOR FOR q553_p1
 
#    START REPORT q553_rep TO l_name
 
    FOREACH q553_co INTO sr.*,l_qcm01
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
         WHERE ima01 = sr.qcm021
 
        #------- CR
        SELECT SUM(qcn07) INTO sr.cr FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
           AND qcm012 =sr.qcm012   #FUN-A60092 add
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO sr.ma FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
           AND qcm012=sr.qcm012   #FUN-A60092 add
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO sr.mi FROM qcm_file,qcn_file
          WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
            AND qcm012=sr.qcm012   #FUN-A60092 add
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
 
       #--------------No.TQC-750064 modify
       #LET sr.qty=sr.cr*g_qcz.qcz02/g_qcz.qcz021+
       #           sr.ma*g_qcz.qcz03/g_qcz.qcz031+
       #           sr.mi*g_qcz.qcz04/g_qcz.qcz041
 
       #IF sr.qcm06 IS NULL THEN LET sr.qcm06=0 END IF
        IF sr.qcm091 IS NULL THEN LET sr.qcm091=0 END IF
        LET sr.qty=sr.qcm22 - sr.qcm091
       #--------------No.TQC-750064 end
 
        CASE sr.desc
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                    sr.desc
           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                    sr.desc
       #TQC-C90117--add--start--
           WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                    sr.desc
       #TQC-C90117--add--end--
        END CASE
 
#        OUTPUT TO REPORT q553_rep(sr.*)
 
     EXECUTE insert_prep USING
        sr.qcm04,sr.qcm02,sr.qcm22,sr.qcm091,sr.desc,sr.cr,sr.ma,sr.mi,sr.qcm03,
        sr.qcm05,sr.sgm04,sr.qcm021,sr.qcm09
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'qcm021,ima02')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('aqcq553','aqcq553',g_sql,g_str)
 
#    FINISH REPORT q553_rep
 
#    CLOSE q553_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT q553_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#    m_qcm01         LIKE qcm_file.qcm01,
#    sr              RECORD
#            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
#            qcm02               LIKE qcm_file.qcm02,    #工單編號
#            qcm021              LIKE qcm_file.qcm021,   #料件編號
#            qcm03              LIKE qcm_file.qcm03,   #製程序
#            qcm05              LIKE qcm_file.qcm05,   #製程序
           #---------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
#            qcm091              LIKE qcm_file.qcm091,   #檢驗量
           #---------------No.TQC-750064 end
#            qcm22               LIKE qcm_file.qcm22,  #送驗量
#            qcm09               LIKE qcm_file.qcm09,
#            qty                 LIKE qcm_file.qcm06,    #不良率
#            rate                LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率
#            desc                LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(6)         #判定
#            cr                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)
#            ma                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)
#            mi                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)
#            sgm04               LIKE sgm_file.sgm04,    #作業編號
#            lot                 LIKE qcf_file.qcf32,       #No.FUN-680104 DEC(15,3)      #檢驗批號
#            rejlot              LIKE qcf_file.qcf32,       #No.FUN-680104 DEC(15,3)       #不合格批號
#            rejrate             LIKE ima_file.ima20,       #No.FUN-680104 DEC(9,3)       #不合格批率
#            ima02               LIKE ima_file.ima02,    #料件名稱
#            ima021              LIKE ima_file.ima021    #料件規格
#        END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.qcm021
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[12] CLIPPED,tm.bdate,'-',tm.edate
          #TQC-5B0109&051112
#            PRINT g_x[14] CLIPPED, sr.ima02 CLIPPED
#            PRINT COLUMN 10,sr.ima021 CLIPPED #TQC-5B0034
            #END TQC-5B0109&051112
#            PRINT
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                           g_x[36],g_x[37],g_x[38]
#            PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42]
#            PRINT g_dash1
#            LET l_trailer_sw = 'n'
 
#      BEFORE GROUP OF sr.qcm021
#            SKIP TO TOP OF PAGE
 
#     ON EVERY ROW
#            PRINTX name=D1 COLUMN g_c[31],sr.qcm04,
#                           COLUMN g_c[32],sr.qcm02,
#                           COLUMN g_c[33],cl_numfor(sr.qcm22,33,1),
                          #----------No.TQC-750064 modify
                          # COLUMN g_c[34],cl_numfor(sr.qcm06,34,1),
#                           COLUMN g_c[34],cl_numfor(sr.qcm091,34,1),
                          #----------No.TQC-750064 end
#                           COLUMN g_c[35],sr.desc,
#                           COLUMN g_c[36],cl_numfor(sr.cr,36,0),
#                           COLUMN g_c[37],cl_numfor(sr.ma,37,0),
#                           COLUMN g_c[38],cl_numfor(sr.mi,38,0)
#            PRINTX name=D2 COLUMN g_c[40],sr.qcm03,
#                           COLUMN g_c[41],sr.qcm05 CLIPPED,
#                           COLUMN g_c[42],sr.sgm04 CLIPPED
 
#     AFTER GROUP OF sr.qcm021
#          LET sr.lot=GROUP COUNT(*)
#          LET sr.rejlot=GROUP COUNT(*) WHERE sr.qcm09!='1'
#          IF sr.lot=0 OR sr.lot IS NULL THEN
#             LET sr.rejrate=0
#          ELSE
#             LET sr.rejrate=(sr.rejlot/sr.lot)*100
#          END IF
 
#          PRINT
#          PRINT g_dash
#          PRINT g_x[9] CLIPPED,GROUP COUNT(*) USING '##########', 4 SPACES,
#                g_x[10] CLIPPED,GROUP COUNT(*) WHERE sr.qcm09!='1'
#                                USING '##########', 4 SPACES,
#                g_x[11] CLIPPED,sr.rejrate,' %'
 
#        ON LAST ROW
#            SKIP 1 LINE
#            LET m_no=1
           #PRINT g_dash2   #No.TQC-6C0227
#            PRINT g_dash    #No.TQC-6C0227
#            LET l_trailer_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#        PAGE TRAILER
#            IF l_trailer_sw = 'n' THEN
               #PRINT g_dash2   #No.TQC-6C0227
#                PRINT g_dash    #No.TQC-6C0227
#                PRINT g_x[4],g_x[5] CLIPPED,
#               COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-850050---end---
