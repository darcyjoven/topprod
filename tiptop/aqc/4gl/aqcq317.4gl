# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcq317.4gl
# Descriptions...: 料件品質履歷明細查詢
# Date & Author..: 01/05/16 By Mandy
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 料件編號開窗
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/13 By kim 報表轉XML功能
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: No.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# modify.........: No.TQC-5B0034 05/11/08 By Rosayu 修改單頭料件品名位置
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850013 08/05/06 By jan 報表改CR輸出 
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30001 10/03/31 By Summer 將aqc-005改成apm-244
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc			LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcs  RECORD
            qcs021	        LIKE qcs_file.qcs021,
            ima02               LIKE ima_file.ima02,
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE
            edate               LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qct DYNAMIC ARRAY OF RECORD
            qcs01		LIKE qcs_file.qcs01,
            qcs04		LIKE qcs_file.qcs04,
            qcs03 	        LIKE qcs_file.qcs03 ,
            pmc03 	        LIKE pmc_file.pmc03,
            qct04		LIKE qct_file.qct04,
            azf03		LIKE azf_file.azf03,
            qct11		LIKE qct_file.qct11,
            qct07		LIKE qct_file.qct07,
            rate                LIKE ima_file.ima18,         #No.FUN-680104 DECIMAL(9,3)
            qct08               LIKE ze_file.ze03            #No.TQC-610007
        END RECORD,
    g_argv1          LIKE qcs_file.qcs03,      # INPUT ARGUMENT - 1
    g_query_flag     LIKE type_file.num5,      #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr           LIKE type_file.chr1,      #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,      #No.FUN-680104 SMALLINT
    g_sql            STRING,                   #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b          LIKE type_file.num5,      #單身筆數,   #No.FUN-680104 SMALLINT
    m_qcs01          LIKE qcs_file.qcs01,
    m_qcs02          LIKE qcs_file.qcs02,
    m_qcs05          LIKE qcs_file.qcs05
 
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE g_sql1   STRING                         #No.FUN-850013                                                                                   
DEFINE l_table  STRING                         #No.FUN-850013                                                                                   
DEFINE g_str    STRING                         #No.FUN-850013
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col	  LIKE type_file.num5     #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
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
 
#No.FUN-850013--BEGIN--                                                                                                             
   LET g_sql1="qcs021.qcs_file.qcs021,",                                                                                              
              "ima02.ima_file.ima02,",                                                                                              
              "qcs01.qcs_file.qcs01,",                                                                                              
              "qcs04.qcs_file.qcs04,",                                                                                              
              "qcs03.qcs_file.qcs03,",                                                                                            
              "pmc03.pmc_file.pmc03,",                                                                                              
              "qct04.qct_file.qct04,",                                                                                              
              "azf03.azf_file.azf03,",                                                                                              
              "qct11.qct_file.qct11,",                                                                                              
              "qct07.qct_file.qct07,",
              "rate.ima_file.ima18,",
              "qct08.ze_file.ze03"
   LET l_table=cl_prt_temptable("aqcq317",g_sql1) CLIPPED                                                                          
   IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql1="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,? ) "                                                                                     
   PREPARE insert_prep FROM g_sql1                                                                                                 
   IF STATUS THEN                                                                                                                  
      CALL cl_err("insert_prep:",status,1)                                                                                         
   END IF                                                                                                                          
#No.FUN-850013--END-- 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW q317_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq317"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q317_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q317_q() END IF
    CALL q317_menu()
    CLOSE WINDOW q317_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q317_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_qct.clear()
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
#bugno:6062 end..............................
 
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
 
   LET g_sql = g_sql clipped," ORDER BY qcs021"
 
   PREPARE q317_prepare FROM g_sql
   DECLARE q317_cs SCROLL CURSOR WITH HOLD FOR q317_prepare
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
 
 
   PREPARE q317_precount FROM g_sql
   DECLARE q317_count SCROLL CURSOR FOR q317_precount
END FUNCTION
 
 
 
FUNCTION q317_menu()
 
   WHILE TRUE
      DISPLAY "MENU"
      CALL q317_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q317_q()
            END IF
            #NEXT OPTION "next"
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q317_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qct),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q317_q()
  DEFINE l_qcs03 LIKE qcs_file.qcs03
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qct.clear()   #No.MOD-5A0169 add
    CALL q317_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q317_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       LET m_cnt=0
       FOREACH q317_count INTO l_qcs03
          IF SQLCA.sqlcode THEN EXIT FOREACH END IF
          LET m_cnt=m_cnt+1
       END FOREACH
       DISPLAY m_cnt TO FORMONLY.cnt
       LET g_row_count = m_cnt
       CALL q317_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q317_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q317_cs INTO g_qcs.qcs021
        WHEN 'P' FETCH PREVIOUS q317_cs INTO g_qcs.qcs021
        WHEN 'F' FETCH FIRST    q317_cs INTO g_qcs.qcs021
        WHEN 'L' FETCH LAST     q317_cs INTO g_qcs.qcs021
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
          FETCH ABSOLUTE g_jump q317_cs INTO g_qcs.qcs021
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
 
    SELECT ima02 INTO g_qcs.ima02 FROM ima_file WHERE ima01=g_qcs.qcs021
    IF SQLCA.sqlcode THEN LET g_qcs.ima02=' ' END IF
 
 
    CALL q317_show()
END FUNCTION
 
FUNCTION q317_show()
   DISPLAY BY NAME g_qcs.*
   CALL q317_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q317_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(1100)
   #DEFINE l_ex      LIKE cqg_file.cqg08          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
   DEFINE l_cho	    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   LET l_sql =
     "SELECT qcs01,qcs04,qcs03,pmc03,qct04,azf03,qct11,qct07,0,qct08 ",
     " FROM  qcs_file LEFT OUTER JOIN pmc_file ON pmc01=qcs03,qct_file LEFT OUTER JOIN azf_file ON qct04=azf01 AND azf02 = '6'",
     "   WHERE qct01 = qcs01 ",
     "   AND qct02 = qcs02 ",
     "   AND qct021= qcs05 ",
     "   AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcs021 = '",g_qcs.qcs021,"'",
     "   AND qcs14='Y' ",
     "   AND qcs00<'5' ",  #No.FUN-5C0078
     " ORDER BY qcs01,qcs04,qcs03,pmc03,qct04 "
    PREPARE q317_pb FROM l_sql
    DECLARE q317_bcs CURSOR FOR q317_pb
    FOR g_cnt = 1 TO g_qct.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_qct[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q317_bcs INTO g_qct[g_cnt].*,m_qcs01,m_qcs02,m_qcs05
       IF cl_null(g_qct[g_cnt].qct11) THEN LET g_qct[g_cnt].qct11 = 0 END IF
       IF cl_null(g_qct[g_cnt].qct07) THEN LET g_qct[g_cnt].qct07 = 0 END IF
       LET g_qct[g_cnt].rate = (g_qct[g_cnt].qct07 / g_qct[g_cnt].qct11) * 100
       IF cl_null(g_qct[g_cnt].rate) THEN LET g_qct[g_cnt].rate = 0 END IF
 
       CASE g_qct[g_cnt].qct08
             WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING g_qct[g_cnt].qct08
             WHEN '2' CALL cl_getmsg('apm-244',g_lang) RETURNING g_qct[g_cnt].qct08 #MOD-A30001 aqc-005->apm-244
       END CASE
 
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
#      IF g_cnt > g_qct_arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcs.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_qct.deleteElement(g_cnt)   #No.MOD-5A0169
    LET g_cnt = 0                      #No.MOD-5A0169
 
END FUNCTION
 
 
FUNCTION q317_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qct TO s_qct.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q317_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q317_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q317_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q317_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q317_fetch('L')
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
         DISPLAY "OK"
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
   DISPLAY "g_action_choice=",g_action_choice
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q317_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    sr              RECORD
                        qcs021              LIKE qcs_file.qcs021,
                        ima02               LIKE ima_file.ima02,
                        qcs01               LIKE qcs_file.qcs01,
                        qcs04               LIKE qcs_file.qcs04,
                        qcs03               LIKE qcs_file.qcs03,
                        pmc03               LIKE pmc_file.pmc03,
                        qct04               LIKE qct_file.qct04,
                        azf03               LIKE azf_file.azf03,
                        qct11               LIKE qct_file.qct11,
                        qct07               LIKE qct_file.qct07,
                        qct08               LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(04)
                        rate                LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #No.FUN-680104 VARCHAR(40)
 
    IF tm.wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#No.FUN-850013--BEGIN--                                                                                                             
    CALL cl_del_data(l_table)                                                                                                       
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#   CALL cl_outnam('aqcq317') RETURNING l_name
#No.FUN-850013--END--
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     LET g_sql =
     "SELECT qcs021,ima02,qcs01,qcs04,qcs03,pmc03,qct04,azf03,qct11,qct07,qct08,0 ",
     " FROM  qcs_file LEFT OUTER JOIN ima_file ON ima01=qcs021 LEFT OUTER JOIN pmc_file ON qcs03=pmc01,qct_file LEFT OUTER JOIN azf_file ON qct04=azf01 AND azf02 = '6' ",
     " WHERE ",tm.wc CLIPPED,
     "   AND qct01 = qcs01 ",
     "   AND qct02 = qcs02 ",
     "   AND qct021= qcs05 ",
     "   AND qct04 = azf_file.azf01 ",
     "   AND azf_file.azf02 = '6' ",
     "   AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcs14='Y' ",
     "   AND qcs00<'5' ",  #No.FUN-5C0078
     " ORDER BY 1,2,3,4,5,6,7"
 
 
    PREPARE q317_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q317_co                         # SCROLL CURSOR
        CURSOR FOR q317_p1
 
# genero  script marked     LET g_pageno = 0
#   START REPORT q317_rep TO l_name          #No.FUN-850013
 
    FOREACH q317_co INTO sr.*,m_qcs01,m_qcs02,m_qcs05
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr.qct11) THEN LET sr.qct11 = 0 END IF
        IF cl_null(sr.qct07) THEN LET sr.qct07 = 0 END IF
        LET sr.rate = (sr.qct07 / sr.qct11) * 100
        IF cl_null(sr.rate) THEN LET sr.rate = 0 END IF
 
        CASE sr.qct08
              WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING sr.qct08
              WHEN '2' CALL cl_getmsg('apm-244',g_lang) RETURNING sr.qct08 #MOD-A30001 aqc-005->apm-244
        END CASE
 
#No.FUN-850013--BEGIN--
#       OUTPUT TO REPORT q317_rep(sr.*)
        EXECUTE insert_prep USING sr.qcs021,sr.ima02,sr.qcs01,sr.qcs04,sr.qcs03,
                                  sr.pmc03,sr.qct04,sr.azf03,sr.qct11,sr.qct07,
                                  sr.rate,sr.qct08
 
    END FOREACH
 
#   FINISH REPORT q317_rep
    LET g_sql1="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
    LET g_str = ''                                                                                                                  
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(tm.wc,'qcs021')                                                                                                 
             RETURNING g_str                                                                                                        
    END IF                                                                                                                          
    LET g_str = g_str,";",tm.bdate,";",tm.edate
    CALL cl_prt_cs3('aqcq317','aqcq317',g_sql1,g_str)
 
    CLOSE q317_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-850013--END--
END FUNCTION
 
#No.FUN-850013--BEGIN MARK
#REPORT q317_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#   sr              RECORD
#                       qcs021              LIKE qcs_file.qcs021,
#                       ima02               LIKE ima_file.ima02,
#                       qcs01               LIKE qcs_file.qcs01,
#                       qcs04               LIKE qcs_file.qcs04,
#                       qcs03               LIKE qcs_file.qcs03,
#                       pmc03               LIKE pmc_file.pmc03,
#                       qct04               LIKE qct_file.qct04,
#                       azf03               LIKE azf_file.azf03,
#                       qct11               LIKE qct_file.qct11,
#                       qct07               LIKE qct_file.qct07,
#                       qct08               LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(04)
#                       rate                LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)
#                   END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qcs021,sr.qcs01,sr.qcs04,sr.qcs03,sr.qct04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT g_dash
#           #PRINT g_x[12] CLIPPED,sr.qcs021,' ',sr.ima02 #TQC-5B0034 mark
#           PRINT g_x[11] CLIPPED,sr.qcs021 #TQC-5B0034 add
#           PRINT COLUMN 10,sr.ima02 CLIPPED #TQC-5B0034 add
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#           PRINT g_dash1
#           LET l_trailer_sw = 'n'
 
#       BEFORE GROUP OF sr.qcs021
#           SKIP TO TOP OF PAGE
#
#       BEFORE GROUP OF sr.qcs01
#           PRINT COLUMN g_c[31],sr.qcs01;
#       BEFORE GROUP OF sr.qcs04
#           PRINT COLUMN g_c[32],sr.qcs04;
#       BEFORE GROUP OF sr.qcs03
#           PRINT COLUMN g_c[33],sr.qcs03,
#                 COLUMN g_c[34],sr.pmc03;      #No.FUN-550063
#       ON EVERY ROW
#           PRINT COLUMN g_c[35],sr.qct04,
#                 COLUMN g_c[36],sr.azf03,
#                 COLUMN g_c[37],cl_numfor(sr.qct11,37,0),
#                 COLUMN g_c[38],cl_numfor(sr.qct07,38,0),
#                 COLUMN g_c[39],cl_numfor(sr.rate,39,3),                                                                           
#                 COLUMN g_c[40],sr.qct08
 
#       ON LAST ROW
#           PRINT g_dash
#           LET l_trailer_sw = 'y'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'n' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-850013--END--
#No.FUN-870144
