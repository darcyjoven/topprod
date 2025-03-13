# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq314.4gl
# Descriptions...: 供應商品質狀態查詢
# Date & Author..: 96/02/29 By Melody
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 廠商編號開窗&筆數預設為0
# Modify.........: No.MOD-590003 05/09/06 By jackie 修正報表中依舊抓za的錯誤
# Modify.........: No.TQC-5B0034 05/11/07 By Rosayu 修改報表格式
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740144 07/04/22 By hongmei 修改報表頁次的值未打印出
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/11 By pengu 拿掉單身[檢驗量]欄位
# Modify.........: No.TQC-790099 07/09/17 By lumxa 報表FROM:xxx,頁次格式有誤
# Modify.........: No.FUN-850012 08/05/06 By lilingyu 改成CR報表
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc			LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcs  RECORD
            qcs03               LIKE qcs_file.qcs03,
            pmc03               LIKE pmc_file.pmc03,
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE
            lot                 LIKE type_file.num10,        #No.FUN-680104 INTEGER
            inqty               LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
            qcs091              LIKE qcs_file.qcs091,
           #qcs06               LIKE qcs_file.qcs06,    #No.TQC-750064 mark
            scqty               LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
            rate                LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            crqty               LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
            maqty               LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3) 
            miqty               LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(12,3)
            actqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
            actrate             LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            rejqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
            rejrate             LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            rjqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
            rjrate              LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            spqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
            sprate              LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            score               LIKE type_file.num10         #No.FUN-680104 INTEGER
        END RECORD,
    g_argv1          LIKE qcs_file.qcs03,      # INPUT ARGUMENT - 1
    g_query_flag     LIKE type_file.num5,      #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr           LIKE type_file.chr1,      #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,      #No.FUN-680104 SMALLINT
    g_wc,g_wc2       STRING,                   #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_sql            STRING,                   #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b          LIKE type_file.num5,      #單身筆數,        #No.FUN-680104 SMALLINT
#   g_x ARRAY[31] OF LIKE cob_file.cob01,      #No.FUN-680104 VARCHAR(40) #No.MOD-590003
    g_dash_1         LIKE type_file.chr1000,   #No.FUN-680104 VARCHAR(132) # Dash line
    m_qcs01          LIKE qcs_file.qcs01,
    m_qcs02          LIKE qcs_file.qcs02,
    l_qcs03          LIKE qcs_file.qcs03,
    m_urate          LIKE qcs_file.qcs06,      #No.FUN-680104 DECIMAL(12,3)
    m_hrate          LIKE qcs_file.qcs06       #No.FUN-680104 DECIMAL(12,3)
 
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680104 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680104 INTEGER
DEFINE   g_jump        LIKE type_file.num10    #No.FUN-680104 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5     #No.FUN-680104 SMALLINT
DEFINE   l_table       STRING                  #NO.FUN-850012
DEFINE   gg_sql        STRING                  #NO.FUN-850012
DEFINE   g_str         STRING                  #NO.FUN-850012
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col	 LIKE type_file.num5    #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
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
   LET gg_sql =  "qcs03.qcs_file.qcs03,", 
                 "pmc03.pmc_file.pmc03,", 
                 "dat.type_file.dat,", 
                 "dat1.type_file.dat,",            
                 "lot.type_file.num10,",                
                 "inqty.qcs_file.qcs06,", 
                 "qcs091.qcs_file.qcs091,", 
                 "scqty.qcs_file.qcs06,", 
                 "rate.qcs_file.qcs06,", 
                 "crqty.qcs_file.qcs06,", 
                 "maqty.qcs_file.qcs06,", 
                 "miqty.qcs_file.qcs06,", 
                 "actqty.type_file.num10,",                  
                 "actrate.ima_file.ima18,", 
                 "rejqty.type_file.num10,", 
                 "rejrate.ima_file.ima18,", 
                 "rjqty.type_file.num10,", 
                 "rjrate.ima_file.ima18,", 
                 "spqty.type_file.num10,", 
                 "sprate.ima_file.ima18,", 
                 "score.type_file.num10" 
  LET l_table = cl_prt_temptable('aqcq314',gg_sql) CLIPPED
  IF  l_table = -1 THEN EXIT PROGRAM END IF
  LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
  PREPARE insert_prep FROM gg_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',STATUS,1)                 
     EXIT PROGRAM
  END IF        
#NO.FUN-850012  --End--
         
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW q314_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq314"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q314_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q314_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q314_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q314_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q314_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   INITIALIZE g_qcs.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcs03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp     #FUN-4B0001
           IF INFIELD(qcs03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs03
              NEXT FIELD qcs03
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
 
   MESSAGE ' WAIT '
#bugno:6062modify...........................
        LET g_qcs.bdate=tm.bdate
        LET g_qcs.edate=tm.edate
#bugno:6062 end..............................
 
   LET g_sql=" SELECT UNIQUE qcs03 FROM qcs_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcs14='Y' ",
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
 
   LET g_sql = g_sql clipped," ORDER BY qcs03"
   PREPARE q314_prepare FROM g_sql
   DECLARE q314_cs SCROLL CURSOR FOR q314_prepare
   LET g_sql=" SELECT UNIQUE qcs03 FROM qcs_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'" ,
             " AND qcs14='Y' ",
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
 
   PREPARE q314_precount FROM g_sql
   DECLARE q314_count SCROLL CURSOR FOR q314_precount
END FUNCTION
 
 
#中文的MENU
FUNCTION q314_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q314_q()
            END IF
            NEXT OPTION "next"
        ON ACTION first
            CALL q314_fetch('F')
        ON ACTION previous
            CALL q314_fetch('P')
        ON ACTION jump
            CALL q314_fetch('/')
        ON ACTION next
            CALL q314_fetch('N')
        ON ACTION last
            CALL q314_fetch('L')
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                CALL q314_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q314_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    LET m_cnt = 0   #FUN-4B0001 筆數預設為0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q314_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q314_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       FOREACH q314_count INTO l_qcs03
          IF SQLCA.sqlcode THEN EXIT FOREACH END IF
          LET m_cnt=m_cnt+1
       END FOREACH
       DISPLAY m_cnt TO FORMONLY.cnt
       LET g_row_count = m_cnt
       CALL q314_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q314_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q314_cs INTO g_qcs.qcs03
        WHEN 'P' FETCH PREVIOUS q314_cs INTO g_qcs.qcs03
        WHEN 'F' FETCH FIRST    q314_cs INTO g_qcs.qcs03
        WHEN 'L' FETCH LAST     q314_cs INTO g_qcs.qcs03
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
          FETCH ABSOLUTE g_jump q314_cs INTO g_qcs.qcs03
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
 
    SELECT pmc03 INTO g_qcs.pmc03 FROM pmc_file WHERE pmc01=g_qcs.qcs03
    IF SQLCA.sqlcode THEN LET g_qcs.pmc03=' ' END IF
 
 
    CALL q314_show()
END FUNCTION
 
FUNCTION q314_show()
   DISPLAY BY NAME g_qcs.*
#----------------------- count_values -------------------------------------#
   SELECT COUNT(*) INTO g_qcs.lot FROM qcs_file
       WHERE qcs03=g_qcs.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.lot=0 END IF
   DISPLAY g_qcs.lot TO FORMONLY.lot
 
 
#--------------No.TQC-750064 modify
  #SELECT SUM(qcs091),SUM(qcs06),SUM(qcs22)
  #    INTO g_qcs.qcs091,g_qcs.qcs06,g_qcs.inqty
   SELECT SUM(qcs091),SUM(qcs22)
       INTO g_qcs.qcs091,g_qcs.inqty
#--------------No.TQC-750064 end
       FROM qcs_file
       WHERE qcs03=g_qcs.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN
     #-----------No.TQC-750064 modify
     #LET g_qcs.qcs091=0 LET g_qcs.qcs06=0 LET g_qcs.inqty=0
      LET g_qcs.qcs091=0 LET g_qcs.inqty=0
     #-----------No.TQC-750064 end
   END IF
 
   #------- CR
   SELECT SUM(qct07) INTO g_qcs.crqty FROM qct_file,qcs_file
      WHERE qct01=qcs01
        AND qct02=qcs02
        AND qct021=qcs05
        AND qcs03=g_qcs.qcs03 AND qcs14='Y'
        AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
        AND qct05='1'
        AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS OR g_qcs.crqty IS NULL THEN LET g_qcs.crqty=0 END IF
   #------- MA
   SELECT SUM(qct07) INTO g_qcs.maqty FROM qct_file,qcs_file
      WHERE qct01=qcs01
        AND qct02=qcs02
        AND qct021=qcs05
        AND qcs03=g_qcs.qcs03 AND qcs14='Y'
        AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
        AND qct05='2'
        AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS OR g_qcs.maqty IS NULL THEN LET g_qcs.maqty=0 END IF
   #------- MI
   SELECT SUM(qct07) INTO g_qcs.miqty FROM qct_file,qcs_file
      WHERE qct01=qcs01
        AND qct02=qcs02
        AND qct021=qcs05
        AND qcs03=g_qcs.qcs03 AND qcs14='Y'
        AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
        AND qct05='3'
        AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS OR g_qcs.miqty IS NULL THEN LET g_qcs.miqty=0 END IF
 
   DISPLAY g_qcs.qcs091 TO FORMONLY.qcs091
  #DISPLAY g_qcs.qcs06 TO FORMONLY.qcs06      #No.TQC-750064 mark
   DISPLAY g_qcs.inqty TO FORMONLY.inqty
   DISPLAY g_qcs.crqty TO FORMONLY.crqty
   DISPLAY g_qcs.maqty TO FORMONLY.maqty
   DISPLAY g_qcs.miqty TO FORMONLY.miqty
 
  #--------------------No.TQC-750064 modify
  #LET g_qcs.scqty=(g_qcs.crqty*g_qcz.qcz02/g_qcz.qcz021+g_qcs.maqty*g_qcz.qcz03/g_qcz.qcz031+g_qcs.miqty*g_qcz.qcz04/g_qcz.qcz041)
  #DISPLAY g_qcs.scqty TO FORMONLY.scqty
 
  #IF g_qcs.qcs06=0 THEN
  #   LET g_qcs.rate=0
  #ELSE
  #   LET g_qcs.rate=g_qcs.scqty/g_qcs.qcs06*100
  #END IF
 
   LET g_qcs.scqty = g_qcs.inqty - g_qcs.qcs091
   DISPLAY g_qcs.scqty TO FORMONLY.scqty
 
   IF g_qcs.inqty=0 THEN
      LET g_qcs.rate=0
   ELSE
      LET g_qcs.rate=g_qcs.scqty/g_qcs.inqty*100
   END IF
  #--------------------No.TQC-750064 end
   DISPLAY g_qcs.rate TO FORMONLY.rate
 
   SELECT COUNT(*) INTO g_qcs.actqty FROM qcs_file
       WHERE qcs03=g_qcs.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09='1'
        AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.actqty=0 END IF
   DISPLAY g_qcs.actqty TO FORMONLY.actqty
 
   SELECT COUNT(*) INTO g_qcs.rejqty FROM qcs_file
       WHERE qcs03=g_qcs.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09<>'1'
        AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.rejqty=0 END IF
   DISPLAY g_qcs.rejqty TO FORMONLY.rejqty
 
   SELECT COUNT(*) INTO g_qcs.rjqty FROM qcs_file
       WHERE qcs03=g_qcs.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09='2'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.rjqty=0 END IF
   DISPLAY g_qcs.rjqty TO FORMONLY.rjqty
 
   SELECT COUNT(*) INTO g_qcs.spqty FROM qcs_file
       WHERE qcs03=g_qcs.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09='3'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.spqty=0 END IF
   DISPLAY g_qcs.spqty TO FORMONLY.spqty
 
   IF g_qcs.lot=0 OR g_qcs.lot IS NULL THEN
      LET g_qcs.actrate=0
      LET g_qcs.rejrate=0
      LET g_qcs.rjrate=0
      LET g_qcs.sprate=0
   ELSE
      LET g_qcs.actrate=g_qcs.actqty/g_qcs.lot*100
      DISPLAY g_qcs.actrate TO FORMONLY.actrate
      LET g_qcs.rejrate=g_qcs.rejqty/g_qcs.lot*100
      DISPLAY g_qcs.rejrate TO FORMONLY.rejrate
      LET g_qcs.rjrate=g_qcs.rjqty/g_qcs.lot*100
      DISPLAY g_qcs.rjrate TO FORMONLY.rjrate
      LET g_qcs.sprate=g_qcs.spqty/g_qcs.lot*100
      DISPLAY g_qcs.sprate TO FORMONLY.sprate
   END IF
 
   LET g_qcs.score=100-(50*(g_qcs.rate/100+g_qcs.rejrate/100)*0.7)
   DISPLAY g_qcs.score TO FORMONLY.score
#--------------------------------------------------------------------------#
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q314_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    sr              RECORD
            qcs03               LIKE qcs_file.qcs03,
            pmc03               LIKE pmc_file.pmc03,
            lot                 LIKE type_file.num10,      #No.FUN-680104 INTEGER
            inqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            qcs091              LIKE qcs_file.qcs091,
           #qcs06               LIKE qcs_file.qcs06,     #No.TQC-750064 mark
            scqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            rate                LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
            crqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            maqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            miqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
            actqty              LIKE type_file.num10,      #No.FUN-680104 INTEGER
            actrate             LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
            rejqty              LIKE type_file.num10,      #No.FUN-680104 INTEGER
            rejrate             LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
            rjqty               LIKE type_file.num10,      #No.FUN-680104 INTEGER
            rjrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
            spqty               LIKE type_file.num10,      #No.FUN-680104 INTEGER
            sprate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
            score               LIKE type_file.num10       #No.FUN-680104 INTEGER
                    END RECORD,
    l_name          LIKE type_file.chr20,                  #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000                 #No.FUN-680104 VARCHAR(40)
DEFINE   l_date     LIKE type_file.dat                     #NO.FUN-850012
DEFINE   l_date1    LIKE type_file.dat                     #NO.FUN-850012
 
    IF tm.wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
#NO.FUN-850012  --Begin--    
   # CALL cl_wait()
   # CALL cl_outnam('aqcq314') RETURNING l_name
     CALL cl_del_data(l_table)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = 'aqcq314'
#NO.FUN-850012  --End--    
 
#No.MOD-590003 --start--
#    DECLARE i200_za_cur CURSOR FOR
#            SELECT za02,za05 FROM za_file
#             WHERE za01 = "aqcq314" AND za03 = g_lang
#    FOREACH i200_za_cur INTO g_i,l_za05
#       LET g_x[g_i] = l_za05
#    END FOREACH
#No.MOD-590003 --end--
 
#NO.FUN-850012  --Begin--
  #  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcq314'
  #  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
  #  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
  #  FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
#NO.FUN-850012  --End--
 
    LET g_sql="SELECT UNIQUE qcs03,pmc03,'','','','','','','','','','','','','','','','','',''",
              " FROM qcs_file LEFT OUTER JOIN pmc_file ON qcs03 = pmc01",
              " WHERE ",tm.wc CLIPPED,
              " AND qcs14='Y' ",
              " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
              " AND qcs00<'5' ",   #No.FUN-5C0078
              " ORDER BY qcs03 "
 
    PREPARE q314_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q314_co                         # SCROLL CURSOR
        CURSOR FOR q314_p1
 
# genero  script marked     LET g_pageno = 0
#    START REPORT q314_rep TO l_name          #NO.FUN-850012
 
    FOREACH q314_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           INITIALIZE g_qcs.* TO NULL  #TQC-6B0105
           EXIT FOREACH
        END IF
 
#----------------------- count_values -------------------------------------#
   SELECT COUNT(*) INTO sr.lot FROM qcs_file
       WHERE qcs03=sr.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate
         AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.lot=0 END IF
 
  #-----------------No.TQC-750064 modify
  #SELECT SUM(qcs091),SUM(qcs06),SUM(qcs22)
  #    INTO sr.qcs091,sr.qcs06,sr.inqty
   SELECT SUM(qcs091),SUM(qcs22)
       INTO sr.qcs091,sr.inqty
  #-----------------No.TQC-750064 end
       FROM qcs_file
       WHERE qcs03=sr.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate
         AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS=100 THEN
      LET sr.qcs091=0
     #LET sr.qcs06=0      #No.TQC-750064 mark
      LET sr.inqty=0
   END IF
 
   #------- CR
   SELECT SUM(qct07) INTO sr.crqty FROM qct_file,qcs_file
      WHERE qct01=qcs01
        AND qct02=qcs02
        AND qct021=qcs05
        AND qcs03=sr.qcs03 AND qcs14='Y'
        AND qcs04 BETWEEN tm.bdate AND tm.edate
        AND qct05='1'
        AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS OR sr.crqty IS NULL THEN LET sr.crqty=0 END IF
   #------- MA
   SELECT SUM(qct07) INTO sr.maqty FROM qct_file,qcs_file
      WHERE qct01=qcs01
        AND qct02=qcs02
        AND qct021=qcs05
        AND qcs03=sr.qcs03 AND qcs14='Y'
        AND qcs04 BETWEEN tm.bdate AND tm.edate
        AND qct05='2'
        AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS OR sr.maqty IS NULL THEN LET sr.maqty=0 END IF
   #------- MI
   SELECT SUM(qct07) INTO sr.miqty FROM qct_file,qcs_file
      WHERE qct01=qcs01
        AND qct02=qcs02
        AND qct021=qcs05
        AND qcs03=sr.qcs03 AND qcs14='Y'
        AND qcs04 BETWEEN tm.bdate AND tm.edate
        AND qct05='3'
        AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS OR sr.miqty IS NULL THEN LET sr.miqty=0 END IF
 
  #--------------------No.TQC-750064 modify
  #LET sr.scqty=(sr.crqty*g_qcz.qcz02/g_qcz.qcz021+sr.maqty*g_qcz.qcz03/g_qcz.qcz031+sr.miqty*g_qcz.qcz04/g_qcz.qcz041)
 
  #IF sr.qcs06=0 THEN
  #   LET sr.rate=0
  #ELSE
  #   LET sr.rate=sr.scqty/sr.qcs06*100
  #END IF
 
   LET sr.scqty = sr.inqty - sr.qcs091
 
   IF sr.inqty=0 THEN
      LET sr.rate=0
   ELSE
      LET sr.rate=sr.scqty/sr.inqty*100
   END IF
  #--------------------No.TQC-750064 end
 
   SELECT COUNT(*) INTO sr.actqty FROM qcs_file
       WHERE qcs03=sr.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09='1'
         AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.actqty=0 END IF
 
   SELECT COUNT(*) INTO sr.rejqty FROM qcs_file
       WHERE qcs03=sr.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09<>'1'
         AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.rejqty=0 END IF
 
   SELECT COUNT(*) INTO sr.rjqty FROM qcs_file
       WHERE qcs03=sr.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09='2'
         AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.rjqty=0 END IF
 
   SELECT COUNT(*) INTO sr.spqty FROM qcs_file
       WHERE qcs03=sr.qcs03 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09='3'
         AND qcs00<'5'    #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.spqty=0 END IF
 
   IF sr.lot=0 OR sr.lot IS NULL THEN
      LET sr.actrate=0
      LET sr.rejrate=0
      LET sr.rjrate=0
      LET sr.sprate=0
   ELSE
      LET sr.actrate=sr.actqty/sr.lot*100
      LET sr.rejrate=sr.rejqty/sr.lot*100
      LET sr.rjrate=sr.rjqty/sr.lot*100
      LET sr.sprate=sr.spqty/sr.lot*100
   END IF
 
   LET sr.score=100-(50*(sr.rate/100+sr.rejrate/100)*0.7)
#--------------------------------------------------------------------------#
 
#NO.FUN-850012  --Begin--
       # OUTPUT TO REPORT q314_rep(sr.*)
    LET l_date = tm.bdate
    LET l_date1= tm.edate 
    EXECUTE insert_prep USING
            sr.qcs03,sr.pmc03,l_date,l_date1,sr.lot,sr.inqty,sr.qcs091,
            sr.scqty,sr.rate,sr.crqty,sr.maqty,sr.miqty,sr.actqty,sr.actrate,
            sr.rejqty,sr.rejrate,sr.rjqty,sr.rjrate,sr.spqty,sr.sprate,sr.score   
#NO.FUN-850012  --End--
    END FOREACH
 
#NO.FUN-850012  --Begin--
    #FINISH REPORT q314_rep
 
    #CLOSE q314_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'qcs03')
       RETURNING tm.wc
    ELSE
    	 LET tm.wc = ""
    END IF  	   
    
    LET g_str = tm.wc
    
    CALL cl_prt_cs3('aqcq314','aqcq314',gg_sql,g_str)
#NO.FUN-850012  --End--    
END FUNCTION
 
#NO.FUN-850012  --Begin--
#REPORT q314_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#    sr              RECORD
#            qcs03               LIKE qcs_file.qcs03,
#            pmc03               LIKE pmc_file.pmc03,
#            lot                 LIKE type_file.num10,      #No.FUN-680104 INTEGER
#            inqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#            qcs091              LIKE qcs_file.qcs091,
#           #qcs06               LIKE qcs_file.qcs06,      #No.TQC-750064 mark
#            scqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#            rate                LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3) #TQC-5B0034
#            crqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#            maqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#            miqty               LIKE qcs_file.qcs06,       #No.FUN-680104 DECIMAL(12,3)
#            actqty              LIKE type_file.num10,      #No.FUN-680104 INTEGER
#            actrate             LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
#            rejqty              LIKE type_file.num10,      #No.FUN-680104 INTEGER
#            rejrate             LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
#            rjqty               LIKE type_file.num10,      #No.FUN-680104 INTEGER
#            rjrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
#            spqty               LIKE type_file.num10,      #No.FUN-680104 INTEGER
#            sprate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)
#            score               LIKE type_file.num10       #No.FUN-680104 INTEGER
#                    END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.qcs03
 
#    FORMAT
#        PAGE HEADER
#            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED #TQC-790099
#            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#            PRINT ' '
## genero  script marked             LET g_pageno = g_pageno + 1
#            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                  COLUMN (g_len-FGL_WIDTH(g_user)-19),'FROM:',g_user CLIPPED, #TQC-790099
#                  COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'       #No.TQC-740144
##           COLUMN g_len-7,g_x[3] CLIPPED    #No.TQC-740144
##           g_pageno USING '<<<'
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
 
#        BEFORE GROUP OF sr.qcs03
## genero  script marked             LET g_pageno = 0
#            SKIP TO TOP OF PAGE
 
#        ON EVERY ROW
#            PRINT COLUMN 04,g_x[11] CLIPPED,sr.qcs03,' ',sr.pmc03,
#                  COLUMN 40,g_x[12] CLIPPED,tm.bdate,'-',tm.edate
#            PRINT ''
#            PRINT COLUMN 04,g_x[13] CLIPPED,sr.lot,
#                  COLUMN 30,g_x[14] CLIPPED,sr.inqty,
#                  COLUMN 56,g_x[15] CLIPPED,sr.qcs091
#            PRINT g_dash_1[1,g_len]
#           #------------------No.TQC-750064 modify
#           #PRINT COLUMN 04,g_x[25] CLIPPED,sr.qcs06,
#           #      COLUMN 30,g_x[26] CLIPPED,sr.scqty,
#           #      COLUMN 56,g_x[27] CLIPPED,sr.rate
#            PRINT COLUMN 04,g_x[26] CLIPPED,sr.scqty,
#                  COLUMN 30,g_x[27] CLIPPED,sr.rate
#           #------------------No.TQC-750064 modify
#            PRINT ''
#            PRINT COLUMN 04,g_x[28] CLIPPED,sr.crqty,
#                  COLUMN 30,g_x[29] CLIPPED,sr.maqty,
#                  COLUMN 55,g_x[30] CLIPPED,sr.miqty  #TQC-5B0034 56->55
#            PRINT g_dash_1[1,g_len]
# 
#            PRINT COLUMN 04,g_x[16] CLIPPED,sr.actqty,
#                  COLUMN 32,g_x[17] CLIPPED,sr.actrate
#            PRINT ''
#            PRINT COLUMN 02,g_x[18] CLIPPED,sr.rejqty,
#                  COLUMN 30,g_x[19] CLIPPED,sr.rejrate
#            PRINT ''
#            PRINT COLUMN 04,g_x[20] CLIPPED,sr.rjqty,
#                  COLUMN 32,g_x[21] CLIPPED,sr.rjrate
#            PRINT ''
#            PRINT COLUMN 04,g_x[23] CLIPPED,sr.spqty,
#                  COLUMN 32,g_x[24] CLIPPED,sr.sprate
#            PRINT g_dash_1[1,g_len]
#            PRINT COLUMN 04,g_x[31] CLIPPED,sr.score
 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#        PAGE TRAILER
#            IF l_trailer_sw = 'n' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-850012  --End--
#Patch....NO.TQC-610036 <001,002,003,004,005> #
