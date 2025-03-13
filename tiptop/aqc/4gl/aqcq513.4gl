# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcq513.4gl
# Descriptions...: FQC 品質記錄查詢(BY 料號 )
# Date & Author..: 99/04/18 By Iceman
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/02/01 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-530065 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 單頭料件品名規格調整
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQc-6C0227 07/01/05 By xufeng 結束和接下頁上方應為雙橫線
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850073 08/05/13 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:TQC-C90036 12/09/07 By chenjing 修改特性為3時的顯示問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc		        LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600) 
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            qcm021              LIKE qcm_file.qcm021,   #料件編號
            ima02               LIKE ima_file.ima02,    #料件名稱
            ima021              LIKE ima_file.ima021,   #料件規格
            bdate               LIKE type_file.dat,       #No.FUN-680104 DATE          #檢驗起
            edate               LIKE type_file.dat,       #No.FUN-680104 DATE           #檢驗止
            lot                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3)      #檢驗批號
            rejlot              LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3)      #不合格批號
            rejrate             LIKE bxj_file.bxj16       #No.FUN-680104 DECIMAL(9,3)         #不合格批率
        END RECORD,
    g_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
            qcm02               LIKE qcm_file.qcm02,    #工單編號
            qcm012              LIKE qcm_file.qcm012,   #FUN-A60027   
            qcm05               LIKE qcm_file.qcm05,    #製程序
            ecm04               LIKE ecm_file.ecm04,    #作業編號
           #------------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
            qcm22               LIKE qcm_file.qcm22,    #送驗量
            qcm091              LIKE qcm_file.qcm091,   #檢驗量
            qty                 LIKE qcm_file.qcm22,    #不良率
           #------------------No.TQC-750064 end
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
           #desc                VARCHAR(6),                #判定
            desc                LIKE ze_file.ze03,      #No.TQC-610007
            cr                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)         #CR
            ma                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)         #MA
            mi                  LIKE qcg_file.qcg07     #No.FUN-680104 DEC(15,3)       #MI
        END RECORD,
    s_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
            qcm02               LIKE qcm_file.qcm02,    #工單編號
            qcm012              LIKE qcm_file.qcm012,   #FUN-A60027
            qcm05              LIKE qcm_file.qcm05,     #製程序
            ecm04               LIKE ecm_file.ecm04,    #作業編號
           #------------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
            qcm22               LIKE qcm_file.qcm22,    #送驗量
            qcm091              LIKE qcm_file.qcm091,   #檢驗量
            qty                 LIKE qcm_file.qcm22,    #不良率
           #------------------No.TQC-750064 end
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
           #desc                VARCHAR(6),                #判定
            desc                LIKE ze_file.ze03,      #No.TQC-610007
            cr                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)        #CR
            ma                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)        #MA
            mi                  LIKE qcg_file.qcg07     #No.FUN-680104 DEC(15,3)       #MI
        END RECORD,
 
    g_query_flag     LIKE type_file.num5,         #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr	     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_sql            STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b          LIKE type_file.num5,         #單身筆數,        #No.FUN-680104 SMALLINT
    m_qcm09          LIKE qcm_file.qcm09,
    m_qcm02          LIKE qcm_file.qcm02,
    m_qcm01          LIKE qcm_file.qcm01,
    l_qcm021         LIKE qcm_file.qcm021,
    m_no             LIKE type_file.num10,        #No.FUN-680104 INTEGER
    cr,ma,mi         LIKE qcg_file.qcg07          #No.FUN-680104 DEC(15,3)
 
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #No.FUN-680104 SMALLINT
DEFINE   l_table         STRING                   #No.FUN-850073                                                             
DEFINE   l_sql           STRING                   #No.FUN-850073                                                            
DEFINE   g_str           STRING                   #No.FUN-850073
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col   LIKE type_file.num5  #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
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
 
#No.FUN-850073---Begin 
   LET g_sql = " qcm021.qcm_file.qcm021,",
               " ima02.ima_file.ima02,",   
               " ima021.ima_file.ima021,",
               " qcm04.qcm_file.qcm04,",   
               " qcm02.qcm_file.qcm02,",
               " qcm22.qcm_file.qcm22,",
               " qcm09.qcm_file.qcm09,",
               " qcm091.qcm_file.qcm091,",
               " desc1.ze_file.ze03,",
               " cr.qcg_file.qcg07,",
               " ma.qcg_file.qcg07,",
               " mi.qcg_file.qcg07,",
               " qcm05.qcm_file.qcm05,",
               " ecm04.ecm_file.ecm04 "
   LET l_table = cl_prt_temptable('aqcq513',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF           
#No.FUN-850073---End 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET m_no=1
    LET g_curr = '1'
    LET g_query_flag=1
      LET p_row = 2 LET p_col = 3
    OPEN WINDOW q513_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq513"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("qcm012",g_sma.sma541 = 'Y')   #FUN-A60027  
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q513_q()
#    END IF
    CALL q513_menu()
    CLOSE WINDOW q513_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q513_cs()
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
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
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
                 "   AND qcm14='Y' AND qcm18='1' AND ",tm.wc CLIPPED
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
 
   PREPARE q513_prepare FROM g_sql
   DECLARE q513_cs SCROLL CURSOR WITH HOLD FOR q513_prepare
     LET g_sql = "SELECT UNIQUE qcm021",
                 "  FROM qcm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm14='Y' AND qcm18='1' AND ",tm.wc CLIPPED
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
 
   PREPARE q513_prepare1 FROM g_sql
   DECLARE q513_count CURSOR FOR q513_prepare1
END FUNCTION
 
FUNCTION q513_menu()
   LET g_action_choice=" "
 
   WHILE TRUE
      CALL q513_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q513_q()
            END IF
         WHEN "first"
            CALL q513_fetch('F')
         WHEN "previous"
           CALL q513_fetch('P')
         WHEN "jump"
            CALL q513_fetch('/')
         WHEN "next"
            CALL q513_fetch('N')
         WHEN "last"
            CALL q513_fetch('L')
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q513_out()
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
 
FUNCTION q513_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcm1.clear() #MOD-5A0169 add
    CALL q513_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q513_cs                      # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       LET m_cnt = 0
       FOREACH q513_count INTO l_qcm021
          IF SQLCA.sqlcode THEN EXIT FOREACH END IF
          LET m_cnt=m_cnt+1
       END FOREACH
       LET g_row_count = m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
       CALL q513_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q513_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q513_cs INTO g_qcm.qcm021
        WHEN 'P' FETCH PREVIOUS q513_cs INTO g_qcm.qcm021
        WHEN 'F' FETCH FIRST    q513_cs INTO g_qcm.qcm021
        WHEN 'L' FETCH LAST     q513_cs INTO g_qcm.qcm021
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
          FETCH ABSOLUTE g_jump q513_cs INTO g_qcm.qcm021
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
       AND qcm021 = g_qcm.qcm021 AND qcm14='Y' AND qcm18='1'
    IF SQLCA.sqlcode THEN  LET g_qcm.lot=0 END IF
 
    SELECT COUNT(*) INTO g_qcm.rejlot FROM qcm_file
     WHERE qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate
       AND qcm021 = g_qcm.qcm021 AND qcm14='Y' AND qcm18='1'
       AND qcm09 <> "1"
    IF SQLCA.sqlcode THEN LET g_qcm.rejlot=0 END IF
 
    IF g_qcm.lot=0 OR g_qcm.lot IS NULL THEN
       LET g_qcm.rejrate=0
    ELSE
       LET g_qcm.rejrate=g_qcm.rejlot/g_qcm.lot*100
    END IF
 
    CALL q513_show()
END FUNCTION
 
FUNCTION q513_show()
   DISPLAY BY NAME g_qcm.*
   CALL q513_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q513_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(1000)
          #l_ex      LIKE cqg_file.cqg08,          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
          l_cho	    LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_qcm01   LIKE qcm_file.qcm01
	
    #---------------No.TQC-750064 modify
    #LET l_sql = "SELECT qcm04,qcm02,qcm05,ecm04,qcm06,qcm22,'','',qcm09,0,0,0,",
     LET l_sql = "SELECT qcm04,qcm02,qcm012,qcm05,ecm04,qcm22,qcm091,'','',qcm09,0,0,0,",    #FUN-A60027 add qcm012
    #---------------No.TQC-750064 end
                 "       qcm01",
                 "  FROM qcm_file, OUTER ecm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm02 = ecm_file.ecm01 AND qcm18='1' ",
                #"   AND ecm_file.ecm03 = qcm05 AND qcm14='Y' ",                                       #FUN-A60027 mark
                 "   AND ecm_file.ecm03 = qcm05 AND ecm_file.ecm012 = qcm012 AND qcm14='Y' ",          #FUN-A60027
                 "   AND qcm021 = '", g_qcm.qcm021,"' ",
                 " ORDER BY qcm04"
    PREPARE q513_pb FROM l_sql
    DECLARE q513_bcs CURSOR FOR q513_pb
    CALL g_qcm1.clear()
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q513_bcs INTO g_qcm1[g_cnt].*,l_qcm01
     CASE g_qcm1[g_cnt].desc
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                  g_qcm1[g_cnt].desc
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                  g_qcm1[g_cnt].desc
   #TQC-C90036--add--start--
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                  g_qcm1[g_cnt].desc
   #TQC-C90036--add--end--
     END CASE
 
       #-----------------No.TQC-750064 modify
       #IF g_qcm1[g_cnt].qcm06  IS NULL THEN LET g_qcm1[g_cnt].qcm06=0 END IF
        IF g_qcm1[g_cnt].qcm091  IS NULL THEN LET g_qcm1[g_cnt].qcm091=0 END IF
       #-----------------No.TQC-750064 end
 
        #------- CR
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].cr FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR g_qcm1[g_cnt].cr IS NULL THEN LET g_qcm1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].ma FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR g_qcm1[g_cnt].ma IS NULL THEN LET g_qcm1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].mi FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR g_qcm1[g_cnt].mi IS NULL THEN LET g_qcm1[g_cnt].mi=0 END IF
 
       #---------------------No.TQC-750064 modify
       #LET g_qcm1[g_cnt].qty=g_qcm1[g_cnt].cr*g_qcz.qcz02/g_qcz.qcz021+
       #                      g_qcm1[g_cnt].ma*g_qcz.qcz03/g_qcz.qcz031+
       #                      g_qcm1[g_cnt].mi*g_qcz.qcz04/g_qcz.qcz041
 
        LET g_qcm1[g_cnt].qty=g_qcm1[g_cnt].qcm22 - g_qcm1[g_cnt].qcm091
       #IF g_qcm1[g_cnt].qcm06=0 THEN
        IF g_qcm1[g_cnt].qcm091=0 THEN
           LET g_qcm1[g_cnt].rate=0
        ELSE
          #LET g_qcm1[g_cnt].rate=(g_qcm1[g_cnt].qty/g_qcm1[g_cnt].qcm06)*100
           LET g_qcm1[g_cnt].rate=(g_qcm1[g_cnt].qty/g_qcm1[g_cnt].qcm091)*100
        END IF
       #---------------------No.TQC-750064 end
        LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL g_qcm1.deleteElement(g_cnt)   #No.MOD-5A0169
    LET g_cnt = 0                      #No.MOD-5A0169
 
END FUNCTION
 
FUNCTION q513_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_qcm1 TO s_qcm1.* ATTRIBUTE(COUNT=g_rec_b)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
#        BEFORE ROW
#            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            LET l_sl = SCR_LINE()
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
         LET g_action_choice="previous"
         EXIT DISPLAY
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DISPLAY
      ON ACTION next
         LET g_action_choice="next"
         EXIT DISPLAY
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#     ON ACTION <F3>下頁
#        LET g_action_choice="<F3>下頁"
#     ON ACTION <F4>上頁
#        LET g_action_choice="<F4>上頁"
 
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
 
 
 
FUNCTION q513_out()
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(1000)
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_qcm09         LIKE qcm_file.qcm09,
    sr              RECORD
            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
            qcm02               LIKE qcm_file.qcm02,    #工單編號
            qcm021              LIKE qcm_file.qcm021,   #料件編號
            qcm05              LIKE qcm_file.qcm05,     #製程序
           #-----------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
            qcm091              LIKE qcm_file.qcm091,   #檢驗量
           #-----------------No.TQC-750064 end
            qcm22               LIKE qcm_file.qcm22,    #送驗量
            qcm09               LIKE qcm_file.qcm09,
            qty                 LIKE qcm_file.qcm06,    #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
        #   desc                LIKE qcf_file.qcf062,   #No.FUN-680104 VARCHAR(6)            #判定 #TQC-C90036
            desc                LIKE ze_file.ze03,      #TQC-C90036
            cr                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)
            ma                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)
            mi                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)
            ecm04               LIKE ecm_file.ecm04,    #作業編號
            lot                 LIKE qcf_file.qcf32,    #No.FUN-680104 DEC(15,3)        #檢驗批號
            rejlot              LIKE qcf_file.qcf32,    #No.FUN-680104 DEC(15,3)          #不合格批號
            rejrate             LIKE bxj_file.bxj16,    #No.FUN-680104 DEC(9,3)        #不合格批率
            ima02               LIKE ima_file.ima02,    #料件名稱
            ima021              LIKE ima_file.ima021    #料件規格
        END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000,             #        #No.FUN-680104 VARCHAR(40)
    l_qcm01         LIKE qcm_file.qcm01
 
    IF tm.wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('aqcq513') RETURNING l_name    #No.FUN-850073  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    #----------------No.TQC-750064 modify
    #LET l_sql = "SELECT qcm04,qcm02,qcm021,qcm05,qcm06,qcm22,qcm09,'','',",
     LET l_sql = "SELECT qcm04,qcm02,qcm021,qcm05,qcm091,qcm22,qcm09,'','',",
    #----------------No.TQC-750064 end
                 "       qcm09,0,0,0,ecm04,'','','','','',qcm01",
                 "  FROM qcm_file, OUTER ecm_file",
                 " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcm02 = ecm_file.ecm01 ",
                 "   AND ecm_file.ecm03 = qcm05",
                 "   AND ecm_file.ecm012 = qcm012",        #FUN-A60027
                 "   AND ecm_file.ecm03_par = qcm021 AND qcm14='Y' AND qcm18='1' ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY qcm021"
 
    PREPARE q513_p1 FROM l_sql                   # RUNTIME 編譯
    DECLARE q513_co                              # SCROLL CURSOR
        CURSOR FOR q513_p1
 
#   START REPORT q513_rep TO l_name              #No.FUN-850073 
    CALL cl_del_data(l_table)                    #No.FUN-850073
 
    FOREACH q513_co INTO sr.*,l_qcm01
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
         WHERE ima01 = sr.qcm021
 
        #------- CR
        SELECT SUM(qcn07) INTO sr.cr FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO sr.ma FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO sr.mi FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
 
        LET sr.qty=sr.cr*g_qcz.qcz02/g_qcz.qcz021+
                   sr.ma*g_qcz.qcz03/g_qcz.qcz031+
                   sr.mi*g_qcz.qcz04/g_qcz.qcz041
 
       #-----------No.TQC-750064 modify
       #IF sr.qcm06 IS NULL THEN LET sr.qcm06=0 END IF
        IF sr.qcm091 IS NULL THEN LET sr.qcm091=0 END IF
       #-----------No.TQC-750064 end
 
        CASE sr.desc
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                    sr.desc
           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                    sr.desc
   #TQC-C90036--add--start--
           WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                    sr.desc
   #TQC-C90036--add--end--
        END CASE
 
#       OUTPUT TO REPORT q513_rep(sr.*)
        EXECUTE insert_prep USING sr.qcm021, sr.ima02, sr.ima021, sr.qcm04,  sr.qcm02,  sr.qcm22, 
                                  sr.qcm09,  sr.qcm091,sr.desc,   sr.cr,     sr.ma,     sr.mi,    
                                  sr.qcm05,  sr.ecm04    
    END FOREACH
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'qcm021,ima02')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate                                                         
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('aqcq513','aqcq513',l_sql,g_str) 
#   FINISH REPORT q513_rep
 
#   CLOSE q513_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-850073---End 
END FUNCTION
 
#REPORT q513_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#    m_qcm01         LIKE qcm_file.qcm01,
#    sr              RECORD
#            qcm04               LIKE qcm_file.qcm04,    #檢驗日期
#            qcm02               LIKE qcm_file.qcm02,    #工單編號
#            qcm021              LIKE qcm_file.qcm021,   #料件編號
#            qcm05               LIKE qcm_file.qcm05,    #製程序
#           #---------------No.TQC-750064 modify
#           #qcm06               LIKE qcm_file.qcm06,    #檢驗量
#            qcm091              LIKE qcm_file.qcm091,   #檢驗量
#           #---------------No.TQC-750064 end
#            qcm22               LIKE qcm_file.qcm22,    #送驗量
#            qcm09               LIKE qcm_file.qcm09,
#            qty                 LIKE qcm_file.qcm06,    #不良率
#	    rate		LIKE cqu_file.cqu03,    #No.FUN-680104 DECIMAL(6,2)        #不良率
#            desc                LIKE qcf_file.qcf062,   #No.FUN-680104 VARCHAR(6)         #判定
#            cr                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)
#            ma                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)
#            mi                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(15,3)
#            ecm04               LIKE ecm_file.ecm04,    #作業編號
#            lot                 LIKE qcf_file.qcf32,    #No.FUN-680104 DEC(15,3)         #檢驗批號
#            rejlot              LIKE qcf_file.qcf32,    #No.FUN-680104 DEC(15,3)      #不合格批號
#            rejrate             LIKE ima_file.ima18,    #No.FUN-680104 DEC(9,3)       #不合格批率
#            ima02               LIKE ima_file.ima02,    #料件名稱
#            ima021              LIKE ima_file.ima021    #料件規格
#        END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.qcm021
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_x[12] CLIPPED,tm.bdate,'-',tm.edate
#            PRINT g_dash
#            PRINT g_x[13] CLIPPED, sr.qcm021 CLIPPED #TQC-5B0034
#            #TQC-5B0109&051112
#            PRINT g_x[14] CLIPPED,sr.ima02 CLIPPED
#            PRINT COLUMN 10,sr.ima021 CLIPPED #TQC-5B0034
#            #END TQC-5B0109&051112
#            PRINT
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#            PRINTX name=H2 g_x[39],g_x[40],g_x[42]    #No.FUN-550063
#            PRINT g_dash1
#            LET l_trailer_sw = 'n'
#
#      BEFORE GROUP OF sr.qcm021
#            SKIP TO TOP OF PAGE
#
#     ON EVERY ROW
#            PRINTX name=D1 COLUMN g_c[31],sr.qcm04,
#                           COLUMN g_c[32],sr.qcm02,
#                           COLUMN g_c[33],cl_numfor(sr.qcm22,33,2),
#                          #------------No.TQC-750064 modify
#                          #COLUMN g_c[34],cl_numfor(sr.qcm06,34,2),
#                           COLUMN g_c[34],cl_numfor(sr.qcm091,34,2),
#                          #------------No.TQC-750064 end
#                           COLUMN g_c[35],sr.desc,
#                           COLUMN g_c[36],cl_numfor(sr.cr,36,0),
#                           COLUMN g_c[37],cl_numfor(sr.ma,37,0),
#                           COLUMN g_c[38],cl_numfor(sr.mi,38,0)
#            PRINTX name=D2 COLUMN g_c[40],sr.qcm05,
#                           COLUMN g_c[42],sr.ecm04
#
#     AFTER GROUP OF sr.qcm021
#          LET sr.lot=GROUP COUNT(*)
#          LET sr.rejlot=GROUP COUNT(*) WHERE sr.qcm09!='1'
#          IF sr.lot=0 OR sr.lot IS NULL THEN
#             LET sr.rejrate=0
#          ELSE
#             LET sr.rejrate=(sr.rejlot/sr.lot)*100
#          END IF
# 
#          PRINT g_dash
#          PRINT g_x[9] CLIPPED,GROUP COUNT(*) USING '##########', 4 SPACES,
#                g_x[10] CLIPPED,GROUP COUNT(*) WHERE sr.qcm09!='1'
#                                USING '##########',4 SPACES,
#                g_x[11] CLIPPED,sr.rejrate,' %'
#
#        ON LAST ROW
#            SKIP 1 LINE
#            LET m_no=1
#           #PRINT g_dash2    #No.TQC-6C0227
#            PRINT g_dash     #No.TQC-6C0227
#            LET l_trailer_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'n' THEN
#               #PRINT g_dash2    #No.TQC-6C0227
#                PRINT g_dash     #No.TQC-6C0227
#                PRINT g_x[4],g_x[5] CLIPPED,
#               COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-870144
