# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcq516.4gl
# Descriptions...: PQC料件品質履歷明細查詢
# Date & Author..: 01/05/21 By Mandy
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/13 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-530065 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 報表結束位置,單頭料件品名規格修改
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格格式
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850047 08/05/12 By lilingyu 改成CR報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc			LIKE type_file.chr1000,     #No.FUN-680104 VARCHAR(600)
	bdate                   LIKE type_file.dat,         #No.FUN-680104 DATE
	edate                   LIKE type_file.dat          #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            qcm021	        LIKE qcm_file.qcm021,
            ima02               LIKE ima_file.ima02,
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE
            edate               LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcn DYNAMIC ARRAY OF RECORD
            qcm01		LIKE qcm_file.qcm01,
            qcm04		LIKE qcm_file.qcm04,
            qcm02 	        LIKE qcm_file.qcm02,
            qcm05 	        LIKE qcm_file.qcm05,
            qcn04		LIKE qcn_file.qcn04,
            azf03		LIKE azf_file.azf03,
            qcn11		LIKE qcn_file.qcn11,
            qcn07		LIKE qcn_file.qcn07,
            rate                LIKE bxj_file.bxj16,       #No.FUN-680104 DECIMAL(9,3)
           #qcn08	 VARCHAR(04)
            qcn08               LIKE ze_file.ze03          #No.TQC-610007
        END RECORD,
    g_argv1         LIKE qcm_file.qcm02,      # INPUT ARGUMENT - 1
    g_query_flag    LIKE type_file.num5,      #No.FUN-680104 SMALLINT  #第一次進入程式時即進入Query之後進入next
    g_curr	    LIKE type_file.chr1,      #No.FUN-680104 VARCHAR(1)
    m_cnt           LIKE type_file.num5,      #No.FUN-680104 SMALLINT
    g_sql           STRING,                   #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b         LIKE type_file.num5,      #單身筆數,        #No.FUN-680104 SMALLINT
    m_qcm01         LIKE qcm_file.qcm01,
    m_qcm02         LIKE qcm_file.qcm02,
    m_qcm05         LIKE qcm_file.qcm05
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE   l_table        STRING                       #NO.FUN-850047
DEFINE   gg_sql         STRING                       #NO.FUN-850047
DEFINE   g_str          STRING                       #NO.FUN-850047
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col  LIKE type_file.num5   #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
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
         
#NO.FUN-850047  --Begin--
   LET gg_sql = "dat.type_file.dat,", 
                "dat1.type_file.dat,", 
                "qcm021.qcm_file.qcm021,", 
                "ima02.ima_file.ima02,", 
                "ima021.ima_file.ima021,", 
                "qcm01.qcm_file.qcm01,", 
                "qcm04.qcm_file.qcm04,", 
                "qcm02.qcm_file.qcm02,", 
                "qcm05.qcm_file.qcm05,", 
                "qcn04.qcn_file.qcn04,", 
                "azf03.azf_file.azf03,", 
                "qcn11.qcn_file.qcn11,", 
                "qcn07.qcn_file.qcn07,", 
                "rate.ima_file.ima18,", 
                "qcn08.qcf_file.qcf062" 
  LET l_table = cl_prt_temptable("aqcq516",gg_sql) CLIPPED
  IF  l_table = -1 THEN EXIT PROGRAM END IF
  LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
  PREPARE insert_prep FROM gg_Sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',STATUS,1)
     EXIT PROGRAM
  END IF                                           
#NO.FUN-850047  --End--
         
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW q516_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq516"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
     CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q516_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q516_q() END IF
    CALL q516_menu()
    CLOSE WINDOW q516_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q516_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_qcn.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcm.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcm021
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
   IF INT_FLAG THEN  RETURN END IF
 
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
        LET g_qcm.bdate=tm.bdate
        LET g_qcm.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
 
   LET g_sql=" SELECT UNIQUE qcm021 FROM qcm_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcm14='Y' "
 
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
   PREPARE q516_prepare FROM g_sql
   DECLARE q516_cs SCROLL CURSOR WITH HOLD FOR q516_prepare
 
   LET g_sql=" SELECT COUNT(UNIQUE qcm021) FROM qcm_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcm14='Y' "
 
   PREPARE q516_prepare1 FROM g_sql
   DECLARE q516_count CURSOR FOR q516_prepare1
 
END FUNCTION
 
 
#中文的MENU
FUNCTION q516_menu()
 
   WHILE TRUE
      CALL q516_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q516_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q516_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q516_q()
 
  DEFINE l_count      LIKE type_file.num10        #No.FUN-680104 INTEGER
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcn.clear() #MOD-5A0169 add
    CALL q516_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q516_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q516_count
       FETCH q516_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q516_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q516_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q516_cs INTO g_qcm.qcm021
        WHEN 'P' FETCH PREVIOUS q516_cs INTO g_qcm.qcm021
        WHEN 'F' FETCH FIRST    q516_cs INTO g_qcm.qcm021
        WHEN 'L' FETCH LAST     q516_cs INTO g_qcm.qcm021
        WHEN '/'
          CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,': ' FOR l_abso
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#                CONTINUE PROMPT
 
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
          FETCH ABSOLUTE l_abso q516_cs INTO g_qcm.qcm021
    END CASE
    IF SQLCA.sqlcode THEN CALL cl_err(' ',SQLCA.sqlcode,0)RETURN ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT ima02 INTO g_qcm.ima02 FROM ima_file WHERE ima01=g_qcm.qcm021
    IF SQLCA.sqlcode THEN LET g_qcm.ima02=' ' END IF
 
 
    CALL q516_show()
END FUNCTION
 
FUNCTION q516_show()
   DISPLAY BY NAME g_qcm.*
   CALL q516_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q516_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(1000)
   #DEFINE l_ex      LIKE cqg_file.cqg08          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
   DEFINE l_cho	    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   LET l_sql =
     "SELECT qcm01,qcm04,qcm02,qcm05,qcn04,azf03,qcn11,qcn07,0,qcn08 ",
     " FROM  qcm_file,qcn_file LEFT OUTER JOIN azf_file ON qcn04=azf01 AND azf02 ='6' ",
     " WHERE qcn01 = qcm01 ",
     "   AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcm021 = '",g_qcm.qcm021,"'",
     "   AND qcm14='Y' ",
     " ORDER BY 1,2,3,4,5"
    PREPARE q516_pb FROM l_sql
    DECLARE q516_bcs CURSOR FOR q516_pb
    CALL g_qcn.clear()
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q516_bcs INTO g_qcn[g_cnt].*,m_qcm01,m_qcm02,m_qcm05
       IF cl_null(g_qcn[g_cnt].qcn11) THEN LET g_qcn[g_cnt].qcn11 = 0 END IF
       IF cl_null(g_qcn[g_cnt].qcn07) THEN LET g_qcn[g_cnt].qcn07 = 0 END IF
       LET g_qcn[g_cnt].rate = (g_qcn[g_cnt].qcn07 / g_qcn[g_cnt].qcn11) * 100
       IF cl_null(g_qcn[g_cnt].rate) THEN LET g_qcn[g_cnt].rate = 0 END IF
 
       CASE g_qcn[g_cnt].qcn08
             WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING g_qcn[g_cnt].qcn08
             WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING g_qcn[g_cnt].qcn08
       END CASE
       LET g_cnt = g_cnt +1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_qcn.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    CALL g_qcn.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                     #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q516_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcn TO s_qcn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q516_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q516_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q516_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q516_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q516_fetch('L')
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
 
 
FUNCTION q516_out()
   DEFINE
      l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
      sr              RECORD
                          qcm021              LIKE qcm_file.qcm021,
                          ima02               LIKE ima_file.ima02,
                          ima021              LIKE ima_file.ima021,
                          qcm01               LIKE qcm_file.qcm01,
                          qcm04               LIKE qcm_file.qcm04,
                          qcm02               LIKE qcm_file.qcm02,
                          qcm05               LIKE qcm_file.qcm05,
                          qcn04               LIKE qcn_file.qcn04,
                          azf03               LIKE azf_file.azf03,
                          qcn11               LIKE qcn_file.qcn11,
                          qcn07               LIKE qcn_file.qcn07,
                          qcn08               LIKE qcf_file.qcf062,     #No.FUN-680104 VARCHAR(04)
                          rate                LIKE ima_file.ima18       #No.FUN-680104 DECIMAL(9,3)
                      END RECORD,
      l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
      l_za05          LIKE cob_file.cob01                 #No.FUN-680104 VARCHAR(40)
   DEFINE  l_dat      LIKE type_file.dat                  #NO.FUN-850047
   DEFINE  l_dat1     LIKE type_file.dat                  #NO.FUN-850047
   DEFINE l_azf03     LIKE azf_file.azf03                 #TQC-9C0179
    
    IF tm.wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    
#NO.FUN-850047  --Begin--    
   # CALL cl_outnam('aqcq516') RETURNING l_name
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = 'aqcq516'
     
     LET l_dat  = tm.bdate
     LET l_dat1 = tm.edate
#NO.FUN-850047   --End--     
 
     LET g_sql =
     "SELECT qcm021,ima02,ima021,qcm01,qcm04,qcm02,qcm05,qcn04,azf03,qcn11,qcn07,qcn08,0 ",
     " FROM  qcm_file LEFT OUTER JOIN ima_file ON qcm021 = ima01 ,qcn_file LEFT OUTER JOIN azf_file ON qcn04=azf01 AND azf02 = '6' ",
     " WHERE ",tm.wc CLIPPED,
     "   AND qcn01 = qcm01 ",
     "   AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcm14='Y' ",
     " ORDER BY 1,2,3,4,5,6,7"
 
 
    PREPARE q516_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q516_co                         # SCROLL CURSOR
        CURSOR FOR q516_p1
 
#    START REPORT q516_rep TO l_name         #NO.FUN-850047
 
    FOREACH q516_co INTO sr.*,m_qcm01,m_qcm02,m_qcm05
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr.qcn11) THEN LET sr.qcn11 = 0 END IF
        IF cl_null(sr.qcn07) THEN LET sr.qcn07 = 0 END IF
        LET sr.rate = (sr.qcn07 / sr.qcn11) * 100
        IF cl_null(sr.rate) THEN LET sr.rate = 0 END IF
 
        CASE sr.qcn08
              WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING sr.qcn08
              WHEN '2' CALL cl_getmsg('aqc-0333333',g_lang) RETURNING sr.qcn08
        END CASE
#NO.FUN-850047  --Begin--
     #  OUTPUT TO REPORT q516_rep(sr.*)
     LET l_azf03 = sr.azf03[1,10]   #TQC-9C0179
     EXECUTE insert_prep USING
             l_dat,l_dat1,sr.qcm021,sr.ima02,sr.ima021,sr.qcm01,
             #sr.qcm04,sr.qcm02,sr.qcm05,sr.qcn04,sr.azf03[1,10],sr.qcn11, #TQC-9C0179 mark
             sr.qcm04,sr.qcm02,sr.qcm05,sr.qcn04,l_azf03,sr.qcn11,         #TQC-9C0179
             sr.qcn07,sr.rate,sr.qcn08            
                
#NO.FUN-850047  --End--
    END FOREACH
 
#NO.FUN-850047  --Begin--
  #  FINISH REPORT q516_rep
 
  #  CLOSE q516_co
  #  ERROR ""
  #  CALL cl_prt(l_name,' ','1',g_len)
  
  LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(tm.wc,'qcm021')
     RETURNING tm.wc
  ELSE
  	 LET tm.wc = ""
  END IF
  
  LET g_str = tm.wc
  
  CALL cl_prt_cs3('aqcq516','aqcq516',gg_sql,g_str)  	      
#NO.FUN-850047  --End--
END FUNCTION
 
#NO.FUN-850047  --Begin--
#REPORT q516_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#    sr              RECORD
#                        qcm021              LIKE qcm_file.qcm021,
#                        ima02               LIKE ima_file.ima02,
#                        ima021              LIKE ima_file.ima021,
#                        qcm01               LIKE qcm_file.qcm01,
#                        qcm04               LIKE qcm_file.qcm04,
#                        qcm02               LIKE qcm_file.qcm02,
#                        qcm05               LIKE qcm_file.qcm05,
#                        qcn04               LIKE qcn_file.qcn04,
#                        azf03               LIKE azf_file.azf03,
#                        qcn11               LIKE qcn_file.qcn11,
#                        qcn07               LIKE qcn_file.qcn07,
#                        qcn08               LIKE qcf_file.qcf062,     #No.FUN-680104 VARCHAR(04)
#                        rate                LIKE ima_file.ima18       #No.FUN-680104 DECIMAL(9,3)
#                    END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.qcm021,sr.qcm01,sr.qcm04,sr.qcm02,sr.qcm05,sr.qcn04
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#            PRINT g_dash
#            PRINT g_x[11] CLIPPED,sr.qcm021 CLIPPED # TQC-5B0034
#            #TQC-5B0109&051112
#            PRINT g_x[12] CLIPPED,sr.ima02  CLIPPED
#            PRINT COLUMN 10,sr.ima021 CLIPPED #TQC-5B0034
#            #END TQC-5B0109&051112
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#            PRINT g_dash1
#            LET l_trailer_sw = 'n'
 
#        BEFORE GROUP OF sr.qcm021
#            SKIP TO TOP OF PAGE
 
#        BEFORE GROUP OF sr.qcm01
#            PRINT COLUMN g_c[31],sr.qcm01;
#        BEFORE GROUP OF sr.qcm04
#            PRINT COLUMN g_c[32],sr.qcm04;
#        BEFORE GROUP OF sr.qcm02
#            PRINT COLUMN g_c[33],sr.qcm02,
#                  COLUMN g_c[34],sr.qcm05 USING "####";
 
#        ON EVERY ROW
#            PRINT COLUMN g_c[35],sr.qcn04,
#                  COLUMN g_c[36],sr.azf03[1,10],
#                  COLUMN g_c[37],cl_numfor(sr.qcn11,37,0),
#                  COLUMN g_c[38],cl_numfor(sr.qcn07,38,0),
#                  COLUMN g_c[39],cl_numfor(sr.rate,39,3),
#                  COLUMN g_c[40],sr.qcn08
 
#        ON LAST ROW
#            PRINT g_dash
#            LET l_trailer_sw = 'y'
#            #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED #TQC-5B0034 mark
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0034 add
 
#        PAGE TRAILER
#            IF l_trailer_sw = 'n' THEN
#                PRINT g_dash
#                #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED #TQC-5B0034 mark
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0034 add
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-850047  --End--
 
 
 
