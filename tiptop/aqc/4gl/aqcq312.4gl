# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq312.4gl
# Descriptions...: 材料類別進料品質狀態查詢
# Date & Author..: 96/02/29 By Melody
# Modify.........: No.FUN-4B0001 04/11/01 By Smapmin 料件編號開窗&筆數預設為0
# Modify.........: No.MOD-590003 05/09/06 By jackie 修正報表中依舊抓za的錯誤
# Modify.........: No.TQC-5B0034 05/11/07 By Rosayu 修改報表單頭料件品名位置
# Modify.........: No.TQC-5B0034 05/11/07 By Rosayu 修改報表單頭料件品名位置
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-670106 06/08/24 By Jackho voucher型報表轉template1
# Modify.........: No.FUN-680104 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/11 By pengu 拿掉單身[檢驗量]欄位
# Modify.........: No.TQC-790099 07/09/17 By lumxa 制表日期，FROM，頁次等字樣在報表名之上
# Modify.........: No.FUN-850012 08/05/05 By lilingyu 改成CR報表
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
            qcs021              LIKE qcs_file.qcs021,
            ima02               LIKE ima_file.ima02,
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE
            lot                 LIKE type_file.num10,        #No.FUN-680104 INTEGER
            qty                 LIKE qcs_file.qcs22,         #No.TQC-750064 modify
            stkqty              LIKE qcs_file.qcs091,
            actqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
            actrate             LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(9,3)
            rejqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
            rejrate             LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(9,3)
            rjqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
            rjrate              LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(9,3)
            urate               LIKE qcs_file.qcs06,         #No.FUN-680104 DECIMAL(9,3)
            spqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
            sprate              LIKE qcs_file.qcs06          #No.FUN-680104 DECIMAL(9,3)
        END RECORD,
    g_argv1          LIKE ima_file.ima109,        # INPUT ARGUMENT - 1
    g_query_flag     LIKE type_file.num5,         #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr	     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_wc,g_wc2       string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql            string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num5,         #No.FUN-680104 SMALLINT #單身筆數,
    g_dash_1	     LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(132) # Dash line
    m_qcs01          LIKE qcs_file.qcs01,
    m_qcs02          LIKE qcs_file.qcs02,
    m_qcs05          LIKE qcs_file.qcs05,
    l_qcs021         LIKE qcs_file.qcs021,
    m_urate          LIKE qcs_file.qcs06          #No.FUN-680104 DECIMAL(12,3)
 
DEFINE   g_i            LIKE type_file.num5       #No.FUN-680104 SMALLINT #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000    #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5       #No.FUN-680104 SMALLINT
DEFINE   l_table        STRING                    #NO.FUN-850012          
DEFINE   g_str          STRING                    #NO.FUN-850012
DEFINE   gg_sql         STRING                    #NO.FUN-850012   
 
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
 #NO.FUN-850012
     LET gg_sql ="qcs021.qcs_file.qcs021,",
                 "dat.type_file.dat,",
                 "dat1.type_file.dat,",
                 "lot.type_file.num10,",
                 "qty.qcs_file.qcs22,",
                 "stkqty.qcs_file.qcs091,",
                 "actqty.type_file.num10,",
                 "rejqty.type_file.num10,",
                 "rjqty.type_file.num10,",
                 "spqty.type_file.num10,",
                 "sprate.ima_file.ima18,",
                 "ima02.ima_file.ima02,",
                 "actrate.ima_file.ima18,",
                 "rejrate.ima_file.ima18,",
                 "rjrate.ima_file.ima18,",
                 "urate.ima_file.ima18"
    LET l_table = cl_prt_temptable('aqcq312',gg_sql) CLIPPED
    IF  l_table = -1 THEN EXIT PROGRAM END IF
    LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM gg_sql
    IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
 #NO.FUN-850012
 
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW q312_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq312"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q312_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q312_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q312_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q312_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q312_cs()
   DEFINE   l_cnt       LIKE type_file.num5         #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
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
#bugno:6062 modify ..........................
        LET g_qcs.bdate=tm.bdate
        LET g_qcs.edate=tm.edate
#bugno:6062 end .............................
 
   MESSAGE ' WAIT '
 
   LET g_sql=" SELECT UNIQUE qcs021 FROM qcs_file ",
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
 
   LET g_sql = g_sql clipped," ORDER BY 1"
   PREPARE q312_prepare FROM g_sql
   DECLARE q312_cs SCROLL CURSOR FOR q312_prepare
 
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
 
   PREPARE q312_precount FROM g_sql
   DECLARE q312_count SCROLL CURSOR FOR q312_precount
END FUNCTION
 
 
#中文的MENU
FUNCTION q312_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q312_q()
            END IF
            NEXT OPTION "next"
        ON ACTION first
            CALL q312_fetch('F')
        ON ACTION previous
            CALL q312_fetch('P')
        ON ACTION jump
            CALL q312_fetch('/')
        ON ACTION next
            CALL q312_fetch('N')
        ON ACTION last
            CALL q312_fetch('L')
        ON ACTION output
            IF cl_chk_act_auth() THEN
                CALL q312_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q312_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    LET m_cnt = 0  #FUN-4B0001
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q312_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q312_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
           FOREACH q312_count INTO l_qcs021
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
              LET m_cnt=m_cnt+1
           END FOREACH
           DISPLAY m_cnt TO FORMONLY.cnt
           LET g_row_count = m_cnt
        CALL q312_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q312_fetch(p_flag)
DEFINE
    p_flag      LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1) #處理方式
    l_abso      LIKE type_file.num10         #No.FUN-680104 INTEGER #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q312_cs INTO g_qcs.qcs021
        WHEN 'P' FETCH PREVIOUS q312_cs INTO g_qcs.qcs021
        WHEN 'F' FETCH FIRST    q312_cs INTO g_qcs.qcs021
        WHEN 'L' FETCH LAST     q312_cs INTO g_qcs.qcs021
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
          FETCH ABSOLUTE g_jump q312_cs INTO g_qcs.qcs021
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
 
    CALL q312_show()
END FUNCTION
 
FUNCTION q312_show()
   SELECT ima02 INTO g_qcs.ima02 FROM ima_file WHERE ima01=g_qcs.qcs021
   DISPLAY BY NAME g_qcs.*
#----------------------- count_values -------------------------------------#
   SELECT COUNT(*) INTO g_qcs.lot FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.lot=0 END IF
   DISPLAY g_qcs.lot TO FORMONLY.lot
 
  #----------No.TQC-750064 modify
  #SELECT SUM(qcs06) INTO g_qcs.qty FROM qcs_file
   SELECT SUM(qcs22) INTO g_qcs.qty FROM qcs_file
  #----------No.TQC-750064 end
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.qty=0 END IF
   DISPLAY g_qcs.qty TO FORMONLY.qty
 
   SELECT SUM(qcs091) INTO g_qcs.stkqty FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.stkqty=0 END IF
   DISPLAY g_qcs.stkqty TO FORMONLY.stkqty
 
   SELECT COUNT(*) INTO g_qcs.actqty FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09='1'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.actqty=0 END IF
   DISPLAY g_qcs.actqty TO FORMONLY.actqty
 
   SELECT COUNT(*) INTO g_qcs.rejqty FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09<>'1'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.rejqty=0 END IF
   DISPLAY g_qcs.rejqty TO FORMONLY.rejqty
 
   SELECT COUNT(*) INTO g_qcs.rjqty FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09='2'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.rjqty=0 END IF
   DISPLAY g_qcs.rjqty TO FORMONLY.rjqty
 
   SELECT COUNT(*) INTO g_qcs.spqty FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs09='3'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET g_qcs.spqty=0 END IF
   DISPLAY g_qcs.spqty TO FORMONLY.spqty
 
   SELECT COUNT(*) INTO m_urate FROM qcs_file
       WHERE qcs021=g_qcs.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN g_qcs.bdate AND g_qcs.edate AND qcs16='Y'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET m_urate=0 END IF
 
   IF g_qcs.lot=0 OR g_qcs.lot IS NULL THEN
      LET g_qcs.actrate=0
      LET g_qcs.rejrate=0
      LET g_qcs.rjrate=0
      LET g_qcs.sprate=0
      LET g_qcs.urate=0
   ELSE
      LET g_qcs.actrate=g_qcs.actqty/g_qcs.lot*100
      DISPLAY g_qcs.actrate TO FORMONLY.actrate
      LET g_qcs.rejrate=g_qcs.rejqty/g_qcs.lot*100
      DISPLAY g_qcs.rejrate TO FORMONLY.rejrate
      LET g_qcs.rjrate=g_qcs.rjqty/g_qcs.lot*100
      DISPLAY g_qcs.rjrate TO FORMONLY.rjrate
      LET g_qcs.sprate=g_qcs.spqty/g_qcs.lot*100
      DISPLAY g_qcs.sprate TO FORMONLY.sprate
      LET g_qcs.urate=m_urate/g_qcs.lot*100
      DISPLAY g_qcs.urate TO FORMONLY.urate
   END IF
 
   # Add by Raymon for Test
   CALL drawAll()
   ##
#--------------------------------------------------------------------------#
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q312_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    sr              RECORD
            qcs021              LIKE qcs_file.qcs021,
            ima02               LIKE ima_file.ima02,
            lot                 LIKE type_file.num10,        #No.FUN-680104 INTEGER
            qty                 LIKE qcs_file.qcs22,      #No.TQC-750064 modify
            stkqty              LIKE qcs_file.qcs091,
            actqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
            actrate             LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            rejqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
            rejrate             LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            rjqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
            rjrate              LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            urate               LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3) 
            spqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
            sprate              LIKE ima_file.ima18          #No.FUN-680104 DECIMAL(9,3)
                    END RECORD,
    l_name          LIKE type_file.chr20,        #No.FUN-680104 VARCHAR(20) #External(Disk) file name
    l_za05          LIKE za_file.za05            #No.FUN-680104 VARCHAR(40)
 DEFINE l_date      LIKE type_file.dat           #NO.FUN-850012   
 DEFINE l_date1     LIKE type_file.dat           #NO.FUN-850012   
 
    IF tm.wc IS NULL THEN
#       CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        INITIALIZE g_qcs.* TO NULL  #TQC-6B0105
        RETURN
    END IF
 
#NO.FUN-850012  --Begin--
    CALL cl_del_data(l_table) 
  # CALL cl_wait()
  # CALL cl_outnam('aqcq312') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = 'aqcq312' 
#NO.FUN-850012  --End--
 
#No.MOD-590003 --start--
#    DECLARE i200_za_cur CURSOR FOR
#            SELECT za02,za05 FROM za_file
#             WHERE za01 = "aqcq312" AND za03 = g_lang
#    FOREACH i200_za_cur INTO g_i,l_za05
#       LET g_x[g_i] = l_za05
#    END FOREACH
#No.MOD-590003 --end--
#No.FUN-670106--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcq312'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
#No.FUN-670106--end
 
    LET g_sql="SELECT UNIQUE qcs021,ima02,'','','','','','','','','','','',''",
              " FROM qcs_file LEFT OUTER JOIN ima_file ON ima01=qcs021",
              " WHERE qcs14='Y' AND ",tm.wc CLIPPED,
              " AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
              " AND qcs00<'5' ",   #No.FUN-5C0078
              " ORDER BY qcs021 "
 
    PREPARE q312_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q312_co                         # SCROLL CURSOR
        CURSOR FOR q312_p1
 
#   START REPORT q312_rep TO l_name        #NO.FUN-850012
 
    FOREACH q312_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
#----------------------- count_values -------------------------------------#
   SELECT COUNT(*) INTO sr.lot FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.lot=0 END IF
 
  #--------------No.TQC-750064 modify
  #SELECT SUM(qcs06) INTO sr.qty FROM qcs_file
   SELECT SUM(qcs22) INTO sr.qty FROM qcs_file
  #--------------No.TQC-750064 end
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.qty=0 END IF
 
   SELECT SUM(qcs091) INTO sr.stkqty FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.stkqty=0 END IF
 
   SELECT COUNT(*) INTO sr.actqty FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09='1'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.actqty=0 END IF
 
   SELECT COUNT(*) INTO sr.rejqty FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09<>'1'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.rejqty=0 END IF
 
   SELECT COUNT(*) INTO sr.rjqty FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09='2'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.rjqty=0 END IF
 
   SELECT COUNT(*) INTO sr.spqty FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs09='3'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET sr.spqty=0 END IF
 
   SELECT COUNT(*) INTO m_urate FROM qcs_file
       WHERE qcs021=sr.qcs021 AND qcs14='Y'
         AND qcs04 BETWEEN tm.bdate AND tm.edate AND qcs16='Y'
         AND qcs00<'5'   #No.FUN-5C0078
   IF STATUS=100 THEN LET m_urate=0 END IF
 
   IF sr.lot=0 OR sr.lot IS NULL THEN
      LET sr.actrate=0
      LET sr.rejrate=0
      LET sr.rjrate=0
      LET sr.sprate=0
      LET sr.urate=0
   ELSE
      LET sr.actrate=sr.actqty/sr.lot*100
      LET sr.rejrate=sr.rejqty/sr.lot*100
      LET sr.rjrate=sr.rjqty/sr.lot*100
      LET sr.sprate=sr.spqty/sr.lot*100
      LET sr.urate=m_urate/sr.lot*100
   END IF
#--------------------------------------------------------------------------#
 
#        OUTPUT TO REPORT q312_rep(sr.*)
      LET l_date  = tm.bdate
      LET l_date1 = tm.edate
      EXECUTE insert_prep USING
              sr.qcs021,l_date,l_date1,sr.lot,sr.qty,sr.stkqty,sr.actqty,
              sr.rejqty,sr.rjqty,sr.spqty,sr.sprate,sr.ima02,sr.actrate,
              sr.rejrate,sr.rjrate,sr.urate
           
    END FOREACH
#NO.FUN-850012  --Begin--
#    FINISH REPORT q312_rep
 
#    CLOSE q312_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
     LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
    IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'qcs021')
        RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF  
     LET g_str = tm.wc
     CALL cl_prt_cs3('aqcq312','aqcq312',gg_sql,g_str) 
#NO.FUN-850012  --End--
END FUNCTION
 
#NO.FUN-850012  --Begin--
#REPORT q312_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#    sr              RECORD
#            qcs021              LIKE qcs_file.qcs021,
#            ima02               LIKE ima_file.ima02,
#            lot                 LIKE type_file.num10,        #No.FUN-680104 INTEGER
#            qty                 LIKE qcs_file.qcs22,     #No.TQC-750064 modify
#            stkqty              LIKE qcs_file.qcs091,
#            actqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER 
#            actrate             LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
#            rejqty              LIKE type_file.num10,        #No.FUN-680104 INTEGER
#            rejrate             LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
#            rjqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
#            rjrate              LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
#            urate               LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
#            spqty               LIKE type_file.num10,        #No.FUN-680104 INTEGER
#            sprate              LIKE ima_file.ima18          #No.FUN-680104 DECIMAL(9,3)
#                    END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.qcs021
 
#    FORMAT
#        PAGE HEADER
##No.FUN-670106--begin
##            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##            PRINT ' '
##            LET g_pageno = g_pageno + 1
##            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
##                  COLUMN g_len-7,g_x[3] CLIPPED,
##                  g_pageno USING '<<<'
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] #TQC-790099
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
##           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] #TQC-790099
##No.FUN-670106--end
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
 
#        BEFORE GROUP OF sr.qcs021
##            LET g_pageno = 0                            #No.FUN-670106
#            SKIP TO TOP OF PAGE
 
#        ON EVERY ROW
#            #PRINT COLUMN 04,g_x[11] CLIPPED,sr.qcs021 CLIPPED,sr.ima02 CLIPPED, #TQC-5B0034 mark
##No.FUN-670106--begin
##            PRINT COLUMN 04,g_x[11] CLIPPED,sr.qcs021 CLIPPED, #TQC-5B0034 add
##                  COLUMN 53,g_x[12] CLIPPED,tm.bdate,'-',tm.edate
##            PRINT COLUMN 13,sr.ima02 CLIPPED #TQC-5B0034 add
##            PRINT ''
##            PRINT COLUMN 04,g_x[13] CLIPPED,sr.lot,
##                  COLUMN 30,g_x[14] CLIPPED,sr.qty,
##                  COLUMN 56,g_x[15] CLIPPED,sr.stkqty
##            PRINT g_dash_1[1,g_len]
##            PRINT COLUMN 04,g_x[16] CLIPPED,sr.actqty,
##                  COLUMN 32,g_x[17] CLIPPED,sr.actrate
##            PRINT ''
##            PRINT COLUMN 02,g_x[18] CLIPPED,sr.rejqty,
##                  COLUMN 30,g_x[19] CLIPPED,sr.rejrate
##            PRINT ''
##            PRINT COLUMN 04,g_x[20] CLIPPED,sr.rjqty,
##                  COLUMN 32,g_x[21] CLIPPED,sr.rjrate,
##                  COLUMN 56,g_x[22] CLIPPED,sr.urate
##            PRINT ''
##            PRINT COLUMN 04,g_x[23] CLIPPED,sr.spqty,
##                  COLUMN 32,g_x[24] CLIPPED,sr.sprate
##            PRINT ''
#            PRINTX  name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[38],
#                            g_x[40],g_x[43],g_x[42]
#            PRINTX  name=H2 g_x[45],g_x[47],g_x[37],g_x[39],g_x[41],g_x[44]    
#            PRINT g_dash1                                                                                                
           
#            PRINTX name=D1 COLUMN g_c[31],sr.qcs021 CLIPPED,                                                
#                           COLUMN g_c[32],tm.bdate,'-',tm.edate CLIPPED,                                                                  
#                           COLUMN g_c[33],sr.lot    USING "#########&",                                                                                
#                           COLUMN g_c[34],sr.qty    USING "###########&",                                                                                
#                           COLUMN g_c[35],sr.stkqty USING "##############&",                                                                              
#                           COLUMN g_c[36],sr.actqty USING "#####&.&&&",                                                                             
#                           COLUMN g_c[38],sr.rejqty USING "#####&.&&&",   
#                           COLUMN g_x[40],sr.rjqty  USING "#####&.&&&",    
#                           COLUMN g_x[42],sr.spqty  USING "#####&.&&&",                                                                       
#                           COLUMN g_x[44],sr.sprate USING "#####&.&&&"                                                                             
#            PRINTX name=D2 COLUMN g_c[45],sr.ima02 CLIPPED,
#                           COLUMN g_c[47],' ',                                                                      
#                           COLUMN g_c[37],sr.actrate USING "#####&.&&&",                                                                             
#                           COLUMN g_c[39],sr.rejrate USING "#####&.&&&",                                                                             
#                           COLUMN g_c[41],sr.rjrate  USING "#####&.&&&",                                                                             
#                           COLUMN g_c[43],sr.urate   USING "#####&.&&&"                                                                             
##No.FUN-670106--end
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'n' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-850012  --End--
 
FUNCTION drawAll()
  DEFINE id      LIKE type_file.num10        #No.FUN-680104 INT
  DEFINE l_i     LIKE type_file.num10        #No.FUN-680104 INTEGER
 
  CALL drawselect("c1")
  CALL drawClear()
 
  LET l_i = g_qcs.actrate*10
  CALL DrawFillColor("cyan")
  LET id=drawRectangle(0,50,l_i,100)
  CALL drawSetComment(id,"Pass:" || g_qcs.actrate || "%")
  CALL drawButtonRight(id,"F5")
 
  LET l_i = g_qcs.rejrate*10
  CALL DrawFillColor("yellow")
  LET id=drawRectangle(0,250,l_i,100)
  CALL drawSetComment(id,"Rejected%")
 
  LET l_i = g_qcs.rjrate *10
  CALL DrawFillColor("red")
  LET id=drawRectangle(0,450,l_i,100)
  CALL drawSetComment(id,"Return %")
 
  LET l_i = g_qcs.sprate *10
  CALL DrawFillColor("green")
  LET id=drawRectangle(0,650,l_i,100)
  CALL drawSetComment(id,"Special Purchase %")
 
  LET l_i = g_qcs.urate  *10
  CALL DrawFillColor("blue")
  LET id=drawRectangle(0,850,l_i,100)
  CALL drawSetComment(id,"Urgent Item Ratio %")
 
END FUNCTION
 
