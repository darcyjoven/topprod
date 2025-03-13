# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcq315.4gl
# Descriptions...: 廠商績效評比查詢
# Date & Author..: 96/02/29 By Melody
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 料件編號開窗&筆數預設為0
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/13 By kim 報表轉XML功能
# Modify.........: No.MOD-590003 05/09/05 By jackie 修正報表頁尾錯誤
# Modify.........: No.MOD-5A0142 05/10/21 By Nicola 單身更新有問題
# Modify.........: No.TQC-5B0034 05/11/07 By Rosayu 修改單頭料件品名位置
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/11 By pengu 拿掉單身[檢驗量]欄位
# Modify.........: No.FUN-850012 08/05/07 By lilingyu 改成CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc			LIKE type_file.chr1000,     #No.FUN-680104 VARCHAR(600)
	bdate                   LIKE type_file.dat,         #No.FUN-680104 DATE
	edate                   LIKE type_file.dat          #No.FUN-680104 DATE
        END RECORD,
    g_qcs  RECORD
            qcs021              LIKE qcs_file.qcs021,
            ima02               LIKE ima_file.ima02,
            bdate               LIKE type_file.dat,         #No.FUN-680104 DATE
            edate               LIKE type_file.dat          #No.FUN-680104 DATE
        END RECORD,
    g_qcs1 DYNAMIC ARRAY OF RECORD
            qcs03	        LIKE qcs_file.qcs03,
            qty1                LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            qty2                LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            qty3                LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            cr                  LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            ma                  LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            mi                  LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            score               LIKE type_file.num10       #No.FUN-680104 INTEGER
        END RECORD,
    g_argv1          LIKE qcs_file.qcs021,        # INPUT ARGUMENT - 1
    g_query_flag     LIKE type_file.num5,         #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr           LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_sql            LIKE type_file.chr1000,      #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b          LIKE type_file.num5,  	  #單身筆數, #No.FUN-680104 SMALLINT
    m_qcs01          LIKE qcs_file.qcs01,
    m_qcs02          LIKE qcs_file.qcs02,
    m_qcs05          LIKE qcs_file.qcs05,
    m_qty            LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
    m_reqty          LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
    m_rate           LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
    m_rerate         LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
    l_qcs021         LIKE qcs_file.qcs021,
    m_num            LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
    m_qcs22          LIKE qcs_file.qcs22,         #No.TQC-750064 add
    m_no             LIKE type_file.num10         #No.FUN-680104 INTEGER
 
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680104 INTEGER
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000   #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5      #No.FUN-680104 SMALLINT
DEFINE   l_table        STRING                   #NO.FUN-850012  
DEFINE   g_str          STRING                   #NO.FUN-850012  
DEFINE   gg_sql         STRING                   #NO.FUN-850012 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col  LIKE type_file.num5     #No.FUN-680104 SMALLINT   #No.FUN-6A0085 
 
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
         
#NO.FUN-850012  --Begin--
   LET gg_sql ="dat.type_file.dat,",                                                                                             
               "dat1.type_file.dat,",  
               "qcs021.qcs_file.qcs021,",
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,", 
               "m_no.type_file.num10,", 
               "qcs03.qcs_file.qcs03,", 
               "qty1.qcs_file.qcs06,", 
               "qty2.qcs_file.qcs06,", 
               "qty3.qcs_file.qcs06,", 
               "cr.qcs_file.qcs06,",
               "ma.qcs_file.qcs06,",  
               "mi.qcs_file.qcs06,",         
               "score.type_file.num10" 
   LET l_table = cl_prt_temptable('aqcq315',gg_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"    
   PREPARE insert_prep FROM gg_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1)
      EXIT PROGRAM
   END IF                                      
#NO.FUN-850012  --End--
         
    LET m_no=1
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW q315_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq315"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q315_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q315_q() END IF
    CALL q315_menu()
    CLOSE WINDOW q315_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q315_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcs.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcs021
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp     #FUN-4B0001
           IF INFIELD(qcs021) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs021
              NEXT FIELD qcs021
           END IF
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET tm.bdate=g_today LET tm.edate=g_today
	DISPLAY BY NAME tm.bdate,tm.edate
	INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
		AFTER FIELD bdate
                   IF cl_null(tm.bdate) THEN
                      NEXT FIELD bdate
                   END IF
		AFTER FIELD edate
                   IF cl_null(tm.edate) THEN
                      NEXT FIELD edate
                   END IF
                   IF tm.edate<tm.bdate THEN
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
        LET g_qcs.bdate=tm.bdate
        LET g_qcs.edate=tm.edate
 
   MESSAGE ' WAIT '
 
   LET g_sql=" SELECT UNIQUE qcs021 FROM qcs_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcs14='Y' ",
             " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcs00<'5' "  #No.FUN-5C0078
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcsuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY qcs021"
   PREPARE q315_prepare FROM g_sql
   DECLARE q315_cs SCROLL CURSOR FOR q315_prepare
   LET g_sql=" SELECT UNIQUE qcs021 FROM qcs_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcs14='Y' ",
             " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcs00<'5' "  #No.FUN-5C0078
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcsuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q315_precount FROM g_sql
   DECLARE q315_count SCROLL CURSOR FOR q315_precount
END FUNCTION
 
FUNCTION q315_menu()
 
   WHILE TRUE
      CALL q315_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q315_q()
            END IF
            #NEXT OPTION "next"
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q315_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcs1),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q315_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   LET m_cnt = 0   #FUN-4B0001
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL g_qcs1.clear()   #No.MOD-5A0142
 
   CALL q315_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN q315_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      FOREACH q315_count INTO l_qcs021
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET m_cnt = m_cnt+1
      END FOREACH
      DISPLAY m_cnt TO FORMONLY.cnt
      LET g_row_count = m_cnt
 
      CALL q315_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ''
 
END FUNCTION
 
 
FUNCTION q315_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q315_cs INTO g_qcs.qcs021
        WHEN 'P' FETCH PREVIOUS q315_cs INTO g_qcs.qcs021
        WHEN 'F' FETCH FIRST    q315_cs INTO g_qcs.qcs021
        WHEN 'L' FETCH LAST     q315_cs INTO g_qcs.qcs021
        WHEN '/'
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
          FETCH ABSOLUTE g_jump q315_cs INTO g_qcs.qcs021
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
 
 
    CALL q315_show()
END FUNCTION
 
FUNCTION q315_show()
   SELECT ima02 INTO g_qcs.ima02 FROM ima_file WHERE ima01=g_qcs.qcs021
   DISPLAY BY NAME g_qcs.*
   CALL q315_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q315_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(1000)
   #DEFINE l_ex      LIKE cqg_file.cqg08          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
   DEFINE l_cho     LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   LET l_sql =
        "SELECT unique qcs03,'','','','','','',''",
        " FROM  qcs_file",
        " WHERE qcs14='Y' ",
        "   AND qcs021='",g_qcs.qcs021,"' ",
        "   AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
        "   AND qcs00<'5' ",  #No.FUN-5C0078
        " ORDER BY 1"
    PREPARE q315_pb FROM l_sql
    DECLARE q315_bcs CURSOR FOR q315_pb
    CALL g_qcs1.clear()
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q315_bcs INTO g_qcs1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:q315_bcs',STATUS,1) EXIT FOREACH
         INITIALIZE g_qcs.* TO NULL  #TQC-6B0105
      END IF
      LET g_rec_b = g_rec_b + 1   #No.MOD-5A0142
      #----------------------------------------------------
       #-->送驗批數
        SELECT COUNT(*) INTO g_qcs1[g_cnt].qty1 FROM qcs_file
           WHERE qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03
             AND qcs14='Y' AND qcs22>0
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS=100 THEN LET g_qcs1[g_cnt].qty1=0 END IF
 
       #-->檢驗批數
        SELECT COUNT(*) INTO g_qcs1[g_cnt].qty2 FROM qcs_file
           WHERE qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03
             AND qcs14='Y' #AND qcs06>0        #No.TQC-750064 mark qcs06 >0
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS=100 THEN LET g_qcs1[g_cnt].qty2=0 END IF
 
       #-->退貨批數
        SELECT COUNT(*) INTO g_qcs1[g_cnt].qty3 FROM qcs_file
           WHERE qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03
             AND qcs09='2' AND qcs14='Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS=100 THEN LET g_qcs1[g_cnt].qty3=0 END IF
 
       #-->不良數
        #------- CR
        SELECT SUM(qct07) INTO g_qcs1[g_cnt].cr FROM qct_file,qcs_file
           WHERE qct01=qcs01
             AND qct02=qcs02
             AND qct021=qcs05
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03
             AND qct05='1' AND qcs14='Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS OR g_qcs1[g_cnt].cr IS NULL THEN LET g_qcs1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qct07) INTO g_qcs1[g_cnt].ma FROM qct_file,qcs_file
           WHERE qct01=qcs01
             AND qct02=qcs02
             AND qct021=qcs05
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03
             AND qct05='2' AND qcs14='Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS OR g_qcs1[g_cnt].ma IS NULL THEN LET g_qcs1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qct07) INTO g_qcs1[g_cnt].mi FROM qct_file,qcs_file
           WHERE qct01=qcs01
             AND qct02=qcs02
             AND qct021=qcs05
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03
             AND qct05='3' AND qcs14 = 'Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS OR g_qcs1[g_cnt].mi IS NULL THEN LET g_qcs1[g_cnt].mi=0 END IF
 
       #-->檢驗數
       #---------------No.TQC-750064 modify
       #SELECT SUM(qcs06) INTO m_num FROM qcs_file
        SELECT SUM(qcs091) INTO m_num FROM qcs_file
       #---------------No.TQC-750064 end
           WHERE qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03 AND qcs14='Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS=100 THEN LET m_num=0 END IF
 
       #---------------No.TQC-750064 modify
        SELECT SUM(qcs22) INTO m_qcs22 FROM qcs_file
           WHERE qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
             AND qcs021=g_qcs.qcs021
             AND qcs03=g_qcs1[g_cnt].qcs03 AND qcs14='Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS=100 THEN LET m_qcs22=0 END IF
       #LET m_qty=(g_qcs1[g_cnt].cr*g_qcz.qcz02/g_qcz.qcz021)+
       #          (g_qcs1[g_cnt].ma*g_qcz.qcz03/g_qcz.qcz031)+
       #          (g_qcs1[g_cnt].mi*g_qcz.qcz04/g_qcz.qcz041)
        
        LET m_qty = m_qcs22 - m_num
        IF m_qcs22=0 THEN
           LET m_rate=0
        ELSE
           LET m_rate=(m_qty/m_qcs22)*100
        END IF
       #---------------No.TQC-750064 end
 
        SELECT COUNT(*) INTO m_reqty FROM qcs_file
           WHERE qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
             AND qcs021=g_qcs.qcs021 AND qcs09<>'1'
             AND qcs03=g_qcs1[g_cnt].qcs03 AND qcs14='Y'
             AND qcs00<'5'  #No.FUN-5C0078
        IF STATUS=100 THEN LET m_reqty=0 END IF
 
        IF g_qcs1[g_cnt].qty1=0 THEN
	   LET m_rerate = 0
	ELSE
           LET m_rerate=m_reqty/g_qcs1[g_cnt].qty1*100
        END IF
 
        LET g_qcs1[g_cnt].score=100-(50*(m_rate/100+m_rerate/100)*0.7)
 
        SELECT pmc03 INTO g_qcs1[g_cnt].qcs03 FROM pmc_file
           WHERE pmc01=g_qcs1[g_cnt].qcs03
        IF STATUS=100 THEN LET g_qcs1[g_cnt].qcs03=' ' END IF
 
  #      IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
	LET g_cnt = g_cnt + 1
#       IF g_cnt > g_qcs1_arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
#   LET g_rec_b = (g_cnt-1)
#   CALL SET_COUNT(g_rec_b)
    CALL g_qcs1.deleteElement(g_cnt)   #No.MOD-5A0142
    LET g_cnt = 0                      #No.MOD-5A0142
 
END FUNCTION
 
 
FUNCTION q315_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_qcs1 TO s_qcs1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #No.MOD-5A0142
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q315_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q315_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q315_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q315_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q315_fetch('L')
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
 
 
FUNCTION q315_out()
DEFINE
    l_i             LIKE type_file.num5,       #No.FUN-680104 SMALLINT
    sr              RECORD
        qcs021      LIKE qcs_file.qcs021,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        qcs03       LIKE qcs_file.qcs03,
        qty1        LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
        qty2        LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
        qty3        LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
        cr          LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
        ma          LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
        mi          LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
        score       LIKE type_file.num10       #No.FUN-680104 INTEGER
                    END RECORD,
    l_name          LIKE type_file.chr20,      #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000     #No.FUN-680104 VARCHAR(40)
 
    IF tm.wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
  
#NO.FUN-850012  --Begin--
#    CALL cl_wait()
#    CALL cl_outnam('aqcq315') RETURNING l_name
     CALL cl_del_data(l_table)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = 'aqcq315'
#NO.FUN-850012  --End--
    LET g_sql="SELECT UNIQUE qcs021,ima02,ima021,qcs03,'','','','','','','' ",
              "FROM qcs_file LEFT OUTER JOIN ima_file ON ima01=qcs021",
              " WHERE ",tm.wc CLIPPED,
              " AND qcs14='Y' ",
              " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
              " AND qcs00<'5' ",  #No.FUN-5C0078
              " ORDER BY qcs03 "
 
    PREPARE q315_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q315_co                         # SCROLL CURSOR
        CURSOR FOR q315_p1
 
#    START REPORT q315_rep TO l_name           #NO.FUN-850012
 
    FOREACH q315_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        SELECT COUNT(*) INTO sr.qty1 FROM qcs_file
           WHERE qcs04 BETWEEN tm.bdate AND tm.edate
             AND qcs021=sr.qcs021 AND qcs22>0
             AND qcs03=sr.qcs03 AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS=100 THEN LET sr.qty1=0 END IF
 
        SELECT COUNT(*) INTO sr.qty2 FROM qcs_file
           WHERE qcs04 BETWEEN tm.bdate AND tm.edate
             AND qcs021=sr.qcs021 #AND qcs06>0       #No.TQC-750064 mark qcs06>0
             AND qcs03=sr.qcs03 AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS=100 THEN LET sr.qty2=0 END IF
 
        SELECT COUNT(*) INTO sr.qty3 FROM qcs_file
           WHERE qcs04 BETWEEN tm.bdate AND tm.edate
             AND qcs021=sr.qcs021
             AND qcs03=sr.qcs03 AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS=100 THEN LET sr.qty3=0 END IF
 
        #------- CR
        SELECT SUM(qct07) INTO sr.cr FROM qct_file,qcs_file
           WHERE qct01=qcs01
             AND qct02=qcs02
             AND qct021=qcs05
             AND qcs021=sr.qcs021
             AND qcs03=sr.qcs03
             AND qct05='1' AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qct07) INTO sr.ma FROM qct_file,qcs_file
           WHERE qct01=qcs01
             AND qct02=qcs02
             AND qct021=qcs05
             AND qcs021=sr.qcs021
             AND qcs03=sr.qcs03
             AND qct05='2' AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qct07) INTO sr.mi FROM qct_file,qcs_file
           WHERE qct01=qcs01
             AND qct02=qcs02
             AND qct021=qcs05
             AND qcs021=sr.qcs021
             AND qcs03=sr.qcs03
             AND qct05='3' AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
 
       #------------No.TQC-750064 modify
       #SELECT SUM(qcs06) INTO m_num FROM qcs_file
        SELECT SUM(qcs091) INTO m_num FROM qcs_file
       #------------No.TQC-750064 end
           WHERE qcs04 BETWEEN tm.bdate AND tm.edate
             AND qcs021=sr.qcs021
             AND qcs03=sr.qcs03 AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS=100 THEN LET m_num=0 END IF
 
       #-------------No.TQC-750064 modify
        SELECT SUM(qcs22) INTO m_qcs22 FROM qcs_file
           WHERE qcs04 BETWEEN tm.bdate AND tm.edate
             AND qcs021=sr.qcs021
             AND qcs03=sr.qcs03 AND qcs14='Y'
             AND qcs00<'5'   
        IF STATUS=100 THEN LET m_qty=0 END IF
 
       #LET m_qty=(sr.cr*g_qcz.qcz02/g_qcz.qcz021)+
       #          (sr.ma*g_qcz.qcz03/g_qcz.qcz031)+
       #          (sr.mi*g_qcz.qcz04/g_qcz.qcz041)
        LET m_qty=m_qcs22 - m_num
        IF m_qcs22=0 THEN
           LET m_rate=0
        ELSE
          #LET m_rate=(m_qty/m_num)*100
           LET m_rate=(m_qty/m_qcs22)*100
        END IF
       #-------------No.TQC-750064 end
 
        SELECT COUNT(*) INTO m_reqty FROM qcs_file
           WHERE qcs04 BETWEEN tm.bdate AND tm.edate
             AND qcs021=sr.qcs021 AND qcs09<>'1'
             AND qcs03=sr.qcs03 AND qcs14='Y'
             AND qcs00<'5'   #No.FUN-5C0078
        IF STATUS=100 THEN LET m_reqty=0 END IF
 
        IF sr.qty1=0 THEN
           LET m_rerate=0
        ELSE
           LET m_rerate=m_reqty/sr.qty1*100
        END IF
 
        LET sr.score=100-(50*(m_rate/100+m_rerate/100)*0.7)
 
        SELECT pmc03 INTO sr.qcs03 FROM pmc_file WHERE pmc01=sr.qcs03
        IF STATUS=100 THEN LET sr.qcs03=' ' END IF
#NO.FUN-850012  --Begin--
     #   OUTPUT TO REPORT q315_rep(sr.*)
 
         EXECUTE insert_prep USING
                 tm.bdate,tm.edate,sr.qcs021,sr.ima02,sr.ima021,m_no,sr.qcs03,               
                 sr.qty1,sr.qty2,sr.qty3,sr.cr,sr.ma,
                 sr.mi,sr.score
         LET m_no = m_no + 1       
                               
#NO.FUN-850012  --End--
    END FOREACH
 
#NO.FUN-850012  --Begin--
   # FINISH REPORT q315_rep
 
   # CLOSE q315_co
   # ERROR ""
   # CALL cl_prt(l_name,' ','1',g_len)
   LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'qcs021')
      RETURNING tm.wc
   ELSE
   	  LET tm.wc = ""
   END IF
   
   LET g_str = tm.wc
   
   CALL cl_prt_cs3('aqcq315','aqcq315',gg_sql,g_str)
#NO.FUN-850012  --End--    
END FUNCTION
 
#NO.FUN-850012 --Begin--
#REPORT q315_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#    sr              RECORD
#        qcs021      LIKE qcs_file.qcs021,
#        ima02       LIKE ima_file.ima02,
#        ima021      LIKE ima_file.ima021,
#        qcs03       LIKE qcs_file.qcs03,
#        qty1        LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#        qty2        LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#        qty3        LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#        cr          LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#        ma          LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#        mi          LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#        score       LIKE type_file.num10       #No.FUN-680104 INTEGER
#                    END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.qcs021,sr.score DESC,sr.qcs03
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_x[9] CLIPPED,sr.qcs021 CLIPPED,' '
#                  #sr.ima02 CLIPPED,' ',sr.ima021 CLIPPED #TQC-5B0034 mark
#            PRINT COLUMN 10,sr.ima02 CLIPPED #TQC-5B0034 add
#            PRINT COLUMN 10,sr.ima021 CLIPPED #TQC-5B0034 add
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37],g_x[38],g_x[39]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
 
#        BEFORE GROUP OF sr.qcs021
#            SKIP TO TOP OF PAGE
#            LET m_no=1
 
#        AFTER GROUP OF sr.qcs03
#            PRINT COLUMN g_c[31],m_no USING '---&',
#                  COLUMN g_c[32],sr.qcs03,
#                  COLUMN g_c[33],cl_numfor(GROUP SUM(sr.qty1),33,0),
#                  COLUMN g_c[34],cl_numfor(GROUP SUM(sr.qty2),34,0),
#                  COLUMN g_c[35],cl_numfor(GROUP SUM(sr.qty3),35,0),
#                  COLUMN g_c[36],cl_numfor(GROUP SUM(sr.cr),36,0),
#                  COLUMN g_c[37],cl_numfor(GROUP SUM(sr.ma),37,0),
#                  COLUMN g_c[38],cl_numfor(GROUP SUM(sr.mi),38,0),
#                  COLUMN g_c[39],cl_numfor(sr.score,39,0)
#            LET m_no=m_no+1
 
#        ON LAST ROW
#            PRINT g_dash
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.MOD-590003
 
 #       PAGE TRAILER
 #           IF l_trailer_sw = 'y' THEN
 #               PRINT g_dash
 #               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.MOD-590003
 #           ELSE
 #               SKIP 2 LINE
 #           END IF
#END REPORT
#NO.FUN-850012  --End--
