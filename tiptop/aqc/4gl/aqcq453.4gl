# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aqcq453.4gl
# Descriptions...: FQC 品質記錄查詢(BY 料號 )
# Date & Author..: 99/04/18 By Iceman
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-580013 05/08/12 By yoyo 憑証類報表原則修改
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤#
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850033 08/05/07 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B50107 11/05/19 By zhangll 修正-201錯誤，wc長度調整
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:TQC-C90119 12/09/28 By chenjing 修改特性為3時的顯示問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       #wc			LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
       	wc			STRING,                      #TQC-B50107 mod
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcf  RECORD
            qcf021              LIKE qcf_file.qcf021,   #料件編號
            ima02               LIKE ima_file.ima02,    #料件名稱
            ima021              LIKE ima_file.ima021,   #料件規格
            bdate               LIKE type_file.dat,        #No.FUN-680104 DATE               #檢驗起
            edate               LIKE type_file.dat,        #No.FUN-680104 DATE            #檢驗止
            lot                 LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)        #檢驗批號
            rejlot              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)        #不合格批號
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)         #不合格批率
        END RECORD,
    g_qcf1 DYNAMIC ARRAY OF RECORD
            qcf04               LIKE qcf_file.qcf04,    #檢驗日期
            sfb22               LIKE sfb_file.sfb22,    #訂單編號
            qcf03               LIKE qcf_file.qcf03,    #工單編號
            qcf02               LIKE qcf_file.qcf02,    #工單編號
           #---------------No.TQC-750064 modify
           #qcf06               LIKE qcf_file.qcf06,    #檢驗量
            qcf22               LIKE qcf_file.qcf22,  #送驗量
            qcf091              LIKE qcf_file.qcf091,   #檢驗量
            qty                 LIKE qcf_file.qcf22,    #不良率
           #---------------No.TQC-750064 end
	    rate		LIKE type_file.num15_3,    #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)         #不良率   #TQC-B90211
            desc                LIKE ze_file.ze03,   #No.TQC-610007
            cr                  LIKE qcg_file.qcg07,      #No.FUN-680104 DEC(12,3)
            ma                  LIKE qcg_file.qcg07,      #No.FUN-680104 DEC(12,3)
            mi                  LIKE qcg_file.qcg07       #No.FUN-680104 DEC(12,3)
        END RECORD,
    s_qcf1 DYNAMIC ARRAY OF RECORD
            qcf04               LIKE qcf_file.qcf04,    #檢驗日期
            sfb22               LIKE sfb_file.sfb22,    #訂單編號
            qcf03               LIKE qcf_file.qcf03,    #工單編號
            qcf02               LIKE qcf_file.qcf02,    #工單編號
           #---------------No.TQC-750064 modify
           #qcf06               LIKE qcf_file.qcf06,    #檢驗量
            qcf22               LIKE qcf_file.qcf22,  #送驗量
            qcf091              LIKE qcf_file.qcf091,   #檢驗量
            qty                 LIKE qcf_file.qcf22,    #不良率
           #---------------No.TQC-750064 end
	    rate		LIKE type_file.num15_3,    #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)         #不良率   #TQC-B90211
            desc                LIKE ze_file.ze03,      #No.TQC-610007
            cr                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(12,3)
            ma                  LIKE qcg_file.qcg07,    #No.FUN-680104 DEC(12,3)
            mi                  LIKE qcg_file.qcg07     #No.FUN-680104 DEC(12,3)
        END RECORD,
 
    g_query_flag     LIKE type_file.num5,         #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr	     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)	
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_sql            STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b          LIKE type_file.num5,  	  #單身筆數,        #No.FUN-680104 SMALLINT
    m_qcf09          LIKE qcf_file.qcf09,
    m_qcf02          LIKE qcf_file.qcf02,
    m_qcf01          LIKE qcf_file.qcf01,
    m_no             LIKE type_file.num10            #No.FUN-680104 INTEGER
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680104 SMALLINT
#No.FUN-850033---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-850033---End             
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col   LIKE type_file.num5   #No.FUN-680104 SMALLINT #No.FUN-6A0085 
 
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
    #No.FUN-850033---Begin 
    LET g_sql = "qcf021.qcf_file.qcf021,",
                "ima02.ima_file.ima02,",
                "qcf04.qcf_file.qcf04,",
                "sfb22.sfb_file.sfb22,",
                "qcf22.qcf_file.qcf22,",
                "qcf091.qcf_file.qcf091,",
                "l_desc.ze_file.ze03,",
                "cr.qcg_file.qcg07,",
                "ma.qcg_file.qcg07,",
                "mi.qcg_file.qcg07,",
                "qcf03.qcf_file.qcf03,",
                "qcf02.qcf_file.qcf02,",
                "lot.qcf_file.qcf06,",
                "rejlot.qcf_file.qcf06,",
                "rejrate.bxj_file.bxj16" 
 
    LET l_table = cl_prt_temptable('aqcq453',g_sql) CLIPPED                     
    IF l_table = -1 THEN EXIT PROGRAM END IF                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"              
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                              
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                        
    END IF                                                                      
    #NO.FUN-850033---End                                                        
                         
 
    LET m_no=1
    LET g_curr = '1'
    LET g_query_flag=1
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW q453_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq453"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q453_q()
#    END IF
    CALL q453_menu()
    CLOSE WINDOW q453_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q453_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcf.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcf021,ima02
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
          WHEN INFIELD(qcf021)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_qcf.qcf021
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcf021
            NEXT FIELD qcf021
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
       LET g_qcf.bdate=tm.bdate
       LET g_qcf.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
     LET g_sql = "SELECT UNIQUE qcf021        ",
                 "  FROM qcf_file",
                 " WHERE qcf04 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
                 "   AND ",tm.wc CLIPPED,
                 "   AND qcf14='Y' AND qcf18='2' "
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcfuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY qcf021"
 
   PREPARE q453_prepare FROM g_sql
   DECLARE q453_cs SCROLL CURSOR WITH HOLD FOR q453_prepare
     LET g_sql = "SELECT COUNT(UNIQUE qcf021) ",
                 "  FROM qcf_file",
                 " WHERE qcf04 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
                 "   AND qcf14='Y' AND qcf18='2' ",
                 "   AND ",tm.wc CLIPPED
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcfuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q453_prepare1 FROM g_sql
   DECLARE q453_count CURSOR FOR q453_prepare1
END FUNCTION
 
 
FUNCTION q453_menu()
 
   WHILE TRUE
      CALL q453_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q453_q()
            END IF
#            NEXT OPTION "next"
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q453_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcf1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q453_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcf1.clear() #MOD-5A0169 add
    CALL q453_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q453_cs                      # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q453_count
       FETCH q453_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q453_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q453_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q453_cs INTO g_qcf.qcf021
        WHEN 'P' FETCH PREVIOUS q453_cs INTO g_qcf.qcf021
        WHEN 'F' FETCH FIRST    q453_cs INTO g_qcf.qcf021
        WHEN 'L' FETCH LAST     q453_cs INTO g_qcf.qcf021
        WHEN '/'
        IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump q453_cs INTO g_qcf.qcf021
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
 
    SELECT ima02,ima021 INTO g_qcf.ima02,g_qcf.ima021  FROM ima_file
     WHERE ima01=g_qcf.qcf021
 
    SELECT COUNT(*) INTO g_qcf.lot FROM qcf_file
     WHERE qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate AND qcf14='Y'
       AND qcf021=g_qcf.qcf021 AND qcf18='2'
    IF SQLCA.sqlcode THEN  LET g_qcf.lot=0 END IF
 
    SELECT COUNT(*) INTO g_qcf.rejlot FROM qcf_file
     WHERE qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate AND qcf14='Y'
       AND qcf021=g_qcf.qcf021 AND qcf09 <> "1"  AND qcf18='2'
    IF SQLCA.sqlcode THEN LET g_qcf.rejlot=0 END IF
 
    IF g_qcf.lot=0 OR g_qcf.lot IS NULL THEN
       LET g_qcf.rejrate=0
    ELSE
       LET g_qcf.rejrate=g_qcf.rejlot/g_qcf.lot*100
    END IF
 
 
    CALL q453_show()
END FUNCTION
 
FUNCTION q453_show()
   DISPLAY BY NAME g_qcf.*
   CALL q453_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q453_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(1000)
          #l_ex      LIKE cqg_file.cqg08,          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
          l_cho	    LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_qcf01   LIKE qcf_file.qcf01
	
    #-----------------No.TQC-750064 modify
    #LET l_sql = "SELECT qcf04,sfb22,qcf03,qcf02,qcf06,qcf22,0,'',qcf09,0,0,0,qcf01",
     LET l_sql = "SELECT qcf04,sfb22,qcf03,qcf02,qcf22,qcf091,0,'',qcf09,0,0,0,qcf01",
    #-----------------No.TQC-750064 end
                 " FROM qcf_file LEFT OUTER JOIN sfb_file ON qcf02=sfb01 ",
                 " WHERE qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcf021 = '", g_qcf.qcf021,"' ",
                 "   AND qcf14='Y' AND qcf18='2' ",
                 " ORDER BY qcf04"
    PREPARE q453_pb FROM l_sql
    DECLARE q453_bcs CURSOR FOR q453_pb
    FOR g_cnt = 1 TO g_qcf1.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_qcf1[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q453_bcs INTO g_qcf1[g_cnt].*,l_qcf01
     CASE g_qcf1[g_cnt].desc
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                  g_qcf1[g_cnt].desc
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                  g_qcf1[g_cnt].desc
   #TQC-C90119--start--
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                  g_qcf1[g_cnt].desc
   #TQC-C90119--end--
     END CASE
 
       #--------------No.TQC-750064 modify
       #IF g_qcf1[g_cnt].qcf06  IS NULL THEN LET g_qcf1[g_cnt].qcf06=0 END IF
        IF g_qcf1[g_cnt].qcf091  IS NULL THEN LET g_qcf1[g_cnt].qcf091=0 END IF
       #--------------No.TQC-750064 end
 
        #------- CR
        SELECT SUM(qcg07) INTO g_qcf1[g_cnt].cr FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='1'
             AND qcf14='Y' AND qcf18='2'
        IF STATUS OR g_qcf1[g_cnt].cr IS NULL THEN LET g_qcf1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qcg07) INTO g_qcf1[g_cnt].ma FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='2'
             AND qcf14='Y' AND qcf18='2'
        IF STATUS OR g_qcf1[g_cnt].ma IS NULL THEN LET g_qcf1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qcg07) INTO g_qcf1[g_cnt].mi FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='3'
             AND qcf14='Y' AND qcf18='2'
        IF STATUS OR g_qcf1[g_cnt].mi IS NULL THEN LET g_qcf1[g_cnt].mi=0 END IF
 
       #----------------------No.TQC-750064 modify
       #LET g_qcf1[g_cnt].qty=(g_qcf1[g_cnt].cr*g_qcz.qcz02/g_qcz.qcz021)+
       #                      (g_qcf1[g_cnt].ma*g_qcz.qcz03/g_qcz.qcz031)+
       #                      (g_qcf1[g_cnt].mi*g_qcz.qcz04/g_qcz.qcz041)
        LET g_qcf1[g_cnt].qty=g_qcf1[g_cnt].qcf22 - g_qcf1[g_cnt].qcf091
 
       #IF g_qcf1[g_cnt].qcf06=0 THEN
        IF g_qcf1[g_cnt].qcf22=0 THEN
           LET g_qcf1[g_cnt].rate=0
        ELSE
          #LET g_qcf1[g_cnt].rate=(g_qcf1[g_cnt].qty/g_qcf1[g_cnt].qcf06)*100
           LET g_qcf1[g_cnt].rate=(g_qcf1[g_cnt].qty/g_qcf1[g_cnt].qcf22)*100
        END IF
       #----------------------No.TQC-750064 end
    LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcf.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_qcf1.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
 
FUNCTION q453_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcf1  TO s_qcf1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q453_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q453_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q453_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q453_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q453_fetch('L')
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
 
      ON ACTION accept
#         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q453_out()
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(1000)
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    sr              RECORD
            qcf04               LIKE qcf_file.qcf04,
            sfb22               LIKE sfb_file.sfb22,
            qcf22               LIKE qcf_file.qcf22,
            qcf021              LIKE qcf_file.qcf021,
            ima02               LIKE ima_file.ima02,
           #------------No.TQC-750064 modify
           #qcf06               LIKE qcf_file.qcf06,
            qcf091              LIKE qcf_file.qcf091,
           #------------No.TQC-750064 end
            desc                LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(6)
            cr                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(12,3)
            ma                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(12,3)
            mi                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(12,3)
            qcf062              LIKE qcf_file.qcf062,
            qcf072              LIKE qcf_file.qcf072,
            qcf082              LIKE qcf_file.qcf082,
            qcf03               LIKE qcf_file.qcf03,
            qcf02               LIKE qcf_file.qcf02,
	    desc1		LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(16)  # CR原因說明
	    desc2		LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(16) # MA原因說明
	    desc3		LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(16)  # MI原因說明
            qcf09               LIKE qcf_file.qcf09,
            lot                 LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)
            rejlot              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)
            rejrate             LIKE bxj_file.bxj16,       #No.FUN-680104 DECIMAL(9,3)
            qty                 LIKE qcf_file.qcf06
        END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #        #No.FUN-680104 VARCHAR(40)
 
    CALL cl_del_data(l_table) #No.FUN-850033  
    IF tm.wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    #CALL cl_outnam('aqcq453') RETURNING l_name    #No.FUN-850033
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aqcq453' #No.FUN-850033 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#No.FUN-580013--start
#   SELECT zz17,zz05 INTO g_len,g_zz05
#     FROM zz_file WHERE zz01 = 'aqcq453'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580013--end
 
    #-----------------No.TQC-750064 modify
    #LET l_sql = "SELECT qcf01,qcf04,sfb22,qcf22,qcf021,ima02,qcf06,",
     LET l_sql = "SELECT qcf01,qcf04,sfb22,qcf22,qcf021,ima02,qcf091,",
    #-----------------No.TQC-750064 end
                 "       qcf09,0,0,0,qcf062,qcf072,qcf082,",
                 "       qcf03,qcf02,'','','',qcf09,0,0,0,0     ",
                 "  FROM qcf_file LEFT OUTER JOIN sfb_file ON qcf02=sfb01 LEFT OUTER JOIN ima_file ON qcf021=ima01 ",
                 " WHERE qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qcf14 = 'Y' AND qcf18='2' ",
                 " ORDER BY qcf021      "
 
    PREPARE q453_p1 FROM l_sql                # RUNTIME 編譯
    DECLARE q453_co                         # SCROLL CURSOR
        CURSOR FOR q453_p1
 
# genero  script marked     LET g_pageno = 0
    #START REPORT q453_rep TO l_name        #No.FUN-850033
 
    FOREACH q453_co INTO m_qcf01,sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        SELECT COUNT(*) INTO sr.lot FROM qcf_file
        WHERE qcf04 BETWEEN tm.bdate AND tm.edate AND qcf14='Y' AND qcf18='2'
        IF STATUS=100 THEN LET sr.lot=0 END IF
 
        SELECT COUNT(*) INTO sr.rejlot FROM qcf_file
        WHERE qcf04 BETWEEN tm.bdate AND tm.edate AND qcf14='Y'
          AND qcf09 <> '1' AND qcf18='2'
        IF STATUS=100 THEN LET sr.rejlot=0 END IF
 
        IF sr.lot=0 OR sr.lot IS NULL THEN
           LET sr.rejrate=0
        ELSE
           LET sr.rejrate=(sr.rejlot/sr.lot)*100
        END IF
 
       #---------------No.TQC-750064 modify
       #IF sr.qcf06 IS NULL THEN LET sr.qcf06=0 END IF
        IF sr.qcf091 IS NULL THEN LET sr.qcf091=0 END IF
       #---------------No.TQC-750064 end
 
        #------- CR
        SELECT SUM(qcg07) INTO sr.cr FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=m_qcf01 AND qcg05='1'
             AND qcf14='Y' AND qcf18='2'
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qcg07) INTO sr.ma FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=m_qcf01 AND qcg05='2'
             AND qcf14='Y' AND qcf18='2'
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qcg07) INTO sr.mi FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=m_qcf01 AND qcg05='3'
             AND qcf14='Y' AND qcf18='2'
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
 
        LET sr.qty=(sr.cr*g_qcz.qcz02/g_qcz.qcz021)+(sr.ma*g_qcz.qcz03/g_qcz.qcz031)+(sr.mi*g_qcz.qcz04/g_qcz.qcz041)
 
     CASE sr.desc
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                  sr.desc
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                  sr.desc
    #TQC-C90119--start--
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                 sr.desc
    #TQC-C90119--end--
     END CASE
     
        #No.FUN-850033---Begin
        #OUTPUT TO REPORT q453_rep(m_qcf01,sr.*)
        EXECUTE insert_prep USING sr.qcf021,sr.ima02,sr.qcf04,sr.sfb22,
                                  sr.qcf22,sr.qcf091,sr.desc,sr.cr,sr.ma,sr.mi,
                                  sr.qcf03,sr.qcf02,
                                  sr.lot,sr.rejlot,sr.rejrate 
        #No.FUN-850033---End
    END FOREACH
  
    #No.FUN-850033---Begin
    #FINISH REPORT q453_rep
 
    #CLOSE q453_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    #是否列印選擇條件                                                       
    IF g_zz05 = 'Y' THEN                                                    
       CALL cl_wcchp(tm.wc,'qcf021,ima02')                                         
            RETURNING g_str                                                 
    END IF                                                                  
    LET g_str = g_str,";",tm.bdate,";",tm.edate   
    LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED 
    CALL cl_prt_cs3('aqcq453','aqcq453',g_sql,g_str)  
    #No.FUN-850033---End
END FUNCTION
 
#No.FUN-850033---Begin
#REPORT q453_rep(m_qcf01,sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#   m_qcf01         LIKE qcf_file.qcf01,
#   sr              RECORD
#           qcf04               LIKE qcf_file.qcf04,
#           sfb22               LIKE sfb_file.sfb22,
#           qcf22               LIKE qcf_file.qcf22,
#           qcf021              LIKE qcf_file.qcf021,
#           ima02               LIKE ima_file.ima02,
#          #------------No.TQC-750064 modify
#          #qcf06               LIKE qcf_file.qcf06,
#           qcf091              LIKE qcf_file.qcf091,
#          #------------No.TQC-750064 end
#           desc                LIKE ze_file.ze03,       #No.FUN-680104 VARCHAR(6)
#           cr                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(12,3)
#           ma                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(12,3)
#           mi                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(12,3)
#           qcf062              LIKE qcf_file.qcf062,
#           qcf072              LIKE qcf_file.qcf072,
#           qcf082              LIKE qcf_file.qcf082,
#           qcf03               LIKE qcf_file.qcf03,
#           qcf02               LIKE qcf_file.qcf02,
#           desc1		LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(16)  # CR原因說明
#           desc2		LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(16)  # MA原因說明
#           desc3		LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(16)  # MI原因說明
#           qcf09               LIKE qcf_file.qcf09,
#           lot                 LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)
#           rejlot              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)
#           rejrate             LIKE bxj_file.bxj16,       #No.FUN-680104 DECIMAL(9,3)
#           qty                 LIKE qcf_file.qcf06
#       END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qcf021
 
#   FORMAT
#       PAGE HEADER
##No.FUN-580013--start
##           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
##               COLUMN 40,g_x[20] CLIPPED,tm.bdate,'-',tm.edate
##           PRINT g_dash[1,g_len]
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           PRINT COLUMN 40,g_x[20] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT g_dash[1,g_len]
##No.FUN-580013--end
##No.FUN-550063-begin
#     BEFORE GROUP OF sr.qcf021
#           SKIP 1 LINE
##No.FUN-580013--start
##           PRINT g_x[21] CLIPPED, sr.qcf021,' ',sr.ima02
#           PRINT g_x[21] CLIPPED, sr.qcf021
#           PRINT g_x[22] CLIPPED, sr.ima02
#           SKIP 1 LINE
##           PRINT g_x[11] CLIPPED,
##                 COLUMN 31,g_x[12] CLIPPED,
##                 COLUMN 54,g_x[13] CLIPPED
##           PRINT 9 SPACES,g_x[14] CLIPPED, 26 SPACES,
##                 g_x[15] CLIPPED,
##                 g_x[16] CLIPPED
##           PRINT "-------- -------------------- ----------- ",
##                 "---------- ","---------- ----------------",
##                 "  ----------------  ---------------- "
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#           PRINTX name=H2 g_x[39],g_x[40],g_x[41]
#           PRINT g_dash1
##No.FUN-580013--end
#           LET l_trailer_sw = 'n'
 
#       ON EVERY ROW
##No.FUN-580013--start
##           PRINT COLUMN 01,sr.qcf04,
##                 COLUMN 10,sr.sfb22,
##                 COLUMN 31,sr.qcf22 USING '#####&.&',
##                 COLUMN 43,sr.qcf06 USING '#######&.&',
##                 COLUMN 54,sr.desc,
##                 COLUMN 65,sr.cr USING '#########&',
##                 COLUMN 83,sr.ma USING '#########&',
##                 COLUMN 101,sr.mi USING '#########&'
##           PRINT COLUMN 10, sr.qcf03,
##                 COLUMN 31, sr.qcf02
#           PRINTX name=D1
#                 COLUMN g_c[31],sr.qcf04 CLIPPED,
#                 COLUMN g_c[32],sr.sfb22 CLIPPED,
#                 COLUMN g_c[33],sr.qcf22 USING '##############&.&',
#                #--------------No.TQC-750064 modify
#                #COLUMN g_c[34],sr.qcf06 USING '#########&.&',
#                 COLUMN g_c[34],sr.qcf091 USING '#########&.&',
#                #--------------No.TQC-750064 end
#                 COLUMN g_c[35],sr.desc CLIPPED,
#                 COLUMN g_c[36],sr.cr USING '###########&',
#                 COLUMN g_c[37],sr.ma USING '###########&',
#                 COLUMN g_c[38],sr.mi USING '###########&'
#           PRINTX name=D2
#                 COLUMN g_c[40], sr.qcf03,
#                 COLUMN g_c[41], sr.qcf02
##No.FUN-580013--end
##No.FUN-550063-end
 
#       ON LAST ROW
#           SKIP 1 LINE
#           PRINT g_x[17] CLIPPED,sr.lot USING '#########&', 4 SPACES,
#                 g_x[18] CLIPPED,sr.rejlot USING '#########&',
#                 4 SPACES,g_x[19] CLIPPED,sr.rejrate,' %'
#           LET m_no=1
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'n' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED,
#              COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-850033---End
#Patch....NO.TQC-610036 <> #
#No.FUN-870144
