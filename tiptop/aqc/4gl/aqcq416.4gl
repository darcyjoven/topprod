# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcq416.4gl
# Descriptions...: FQC料件品質履歷明細查詢
# Date & Author..: 01/05/21 By Mandy
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/13 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.MOD-590003 05/09/05 By Nigel 報表格式有問題
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 單頭料件品名規格調整
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850061 08/06/17 By chenmoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-950132 09/06/05 By chenmoyan define temp 時的rate 與sr define 欄位型態不相同
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A30004 10/03/02 By lilingyu RETURNING sr.qcg08處提示訊息有誤
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No:TQC-B50107 11/05/19 By zhangll 修正-201錯誤，wc長度調整
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
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
            qcf021	        LIKE qcf_file.qcf021,
            ima02               LIKE ima_file.ima02,
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE
            edate               LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcg DYNAMIC ARRAY OF RECORD
            qcf01		LIKE qcf_file.qcf01,
            qcf04		LIKE qcf_file.qcf04,
            qcf02 	        LIKE qcf_file.qcf02,
            qcg04		LIKE qcg_file.qcg04,
            azf03		LIKE azf_file.azf03,
            qcg11		LIKE qcg_file.qcg11,
            qcg07		LIKE qcg_file.qcg07,
            rate                LIKE ima_file.ima18,        #No.FUN-680104 DECIMAL(9,3)
            qcg08               LIKE ze_file.ze03           #No.TQC-610007
        END RECORD,
    g_argv1         LIKE qcf_file.qcf02,         # INPUT ARGUMENT - 1
    g_query_flag    LIKE type_file.num5,         #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr	    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    m_cnt           LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_sql           STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b         LIKE type_file.num5,  	 #單身筆數,        #No.FUN-680104 SMALLINT
    m_qcf01         LIKE qcf_file.qcf01,
    m_qcf02         LIKE qcf_file.qcf02,
    m_qcf05         LIKE qcf_file.qcf05
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680104 SMALLINT
#No.FUN-850061 --Begin
DEFINE   #g_sql1          LIKE type_file.chr1000
         g_sql1        STRING       #NO.FUN-910082  
DEFINE   g_str           LIKE type_file.chr1000
DEFINE   l_table         STRING  #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
#No.FUN-850061 --End
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col    LIKE type_file.num5    #No.FUN-680104 SMALLINT  #No.FUN-6A0085 
 
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
#No.FUN-850061 --Begin
    LET g_sql1="qcf021.qcf_file.qcf021,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "qcf01.qcf_file.qcf01,",
               "qcf04.qcf_file.qcf04,",
               "qcf02.qcf_file.qcf02,",
               "qcg04.qcg_file.qcg04,",
               "azf03.azf_file.azf03,",
               "qcg11.qcg_file.qcg11,",
               "qcg07.qcg_file.qcg07,",
               "qcg08.ze_file.ze03,",
#              "rate.ima_file.ima08"    #No.TQC-950132
               "rate.ima_file.ima08"    #No.TQC-950132
    LET l_table=cl_prt_temptable('aqcq416',g_sql1)
    IF l_table=-1 THEN EXIT PROGRAM END IF
#No.FUN-850061 --End
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1     = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4
    LET p_col = 3
    OPEN WINDOW q416_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq416"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q416_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q416_q() END IF
    CALL q416_menu()
    CLOSE WINDOW q416_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q416_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_qcg.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcf.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcf021
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
       LET g_qcf.bdate=tm.bdate
       LET g_qcf.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
 
   LET g_sql=" SELECT UNIQUE qcf021 FROM qcf_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcf14='Y' "
 
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
 
   PREPARE q416_prepare FROM g_sql
   DECLARE q416_cs SCROLL CURSOR WITH HOLD FOR q416_prepare
#   LET g_sql = g_sql CLIPPED," INTO TEMP x"
 
   #DROP TABLE x
 
   LET g_sql=" SELECT COUNT(UNIQUE qcf021) FROM qcf_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcf14='Y' "
 
   PREPARE q416_precount FROM g_sql
   DECLARE q416_count CURSOR FOR q416_precount
END FUNCTION
 
 
#中文的MENU
FUNCTION q416_menu()
 
   WHILE TRUE
      CALL q416_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q416_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q416_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q416_q()
  DEFINE l_count     LIKE type_file.num10        #No.FUN-680104 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcg.clear() #MOD-5A0169 add
    CALL q416_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
       OPEN q416_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_qcf.* TO NULL
    ELSE
       OPEN q416_count
       FETCH q416_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q416_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q416_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q416_cs INTO g_qcf.qcf021
        WHEN 'P' FETCH PREVIOUS q416_cs INTO g_qcf.qcf021
        WHEN 'F' FETCH FIRST    q416_cs INTO g_qcf.qcf021
        WHEN 'L' FETCH LAST     q416_cs INTO g_qcf.qcf021
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
          FETCH ABSOLUTE g_jump q416_cs INTO g_qcf.qcf021
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
 
    SELECT ima02 INTO g_qcf.ima02 FROM ima_file WHERE ima01=g_qcf.qcf021
    IF SQLCA.sqlcode THEN LET g_qcf.ima02=' ' END IF
 
 
    CALL q416_show()
END FUNCTION
 
FUNCTION q416_show()
   DISPLAY BY NAME g_qcf.*
   CALL q416_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q416_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(1100)
   #DEFINE l_ex      LIKE cqg_file.cqg08          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
   DEFINE l_cho	    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   LET l_sql =
     "SELECT qcf01,qcf04,qcf02,qcg04,azf03,qcg11,qcg07,0,qcg08 ",
     " FROM  qcf_file,qcg_file LEFT OUTER JOIN azf_file ON qcg04=azf01 AND azf02 = '6'",
     " WHERE qcg01 = qcf01 ",
     "   AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcf021 = '",g_qcf.qcf021,"'",
     "   AND qcf14='Y' ",
     " ORDER BY 1,2,3,4,5"
    PREPARE q416_pb FROM l_sql
    DECLARE q416_bcs CURSOR FOR q416_pb
    FOR g_cnt = 1 TO g_qcg.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_qcg[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q416_bcs INTO g_qcg[g_cnt].*,m_qcf01,m_qcf02,m_qcf05
       IF cl_null(g_qcg[g_cnt].qcg11) THEN LET g_qcg[g_cnt].qcg11 = 0 END IF
       IF cl_null(g_qcg[g_cnt].qcg07) THEN LET g_qcg[g_cnt].qcg07 = 0 END IF
       LET g_qcg[g_cnt].rate = (g_qcg[g_cnt].qcg07 / g_qcg[g_cnt].qcg11) * 100
       IF cl_null(g_qcg[g_cnt].rate) THEN LET g_qcg[g_cnt].rate = 0 END IF
 
       CASE g_qcg[g_cnt].qcg08
             WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING g_qcg[g_cnt].qcg08
             WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING g_qcg[g_cnt].qcg08
       END CASE
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
    CALL g_qcg.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q416_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_qcg TO s_qcg.* #MOD-5A0169 mark
   DISPLAY ARRAY g_qcg TO s_qcg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-5A0169 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q416_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q416_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q416_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q416_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q416_fetch('L')
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
 
 
FUNCTION q416_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    sr              RECORD
                        qcf021              LIKE qcf_file.qcf021,
                        ima02               LIKE ima_file.ima02,
                        ima021              LIKE ima_file.ima021,
                        qcf01               LIKE qcf_file.qcf01,
                        qcf04               LIKE qcf_file.qcf04,
                        qcf02               LIKE qcf_file.qcf02,
                        qcg04               LIKE qcg_file.qcg04,
                        azf03               LIKE azf_file.azf03,
                        qcg11               LIKE qcg_file.qcg11,
                        qcg07               LIKE qcg_file.qcg07,
                        qcg08               LIKE qcf_file.qcf062,      #No.FUN-680104 VARCHAR(04)
                        rate                LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3) 
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #        #No.FUN-680104 VARCHAR(40)
 
    IF tm.wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#No.FUN-850061 --Begin
#   CALL cl_outnam('aqcq416') RETURNING l_name
    LET g_sql1="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"
    PREPARE insert_prep FROM g_sql1
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aqcq416'
#No.FUN-850061 --End
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     LET g_sql =
     "SELECT qcf021,ima02,ima021,qcf01,qcf04,qcf02,qcg04,azf03,qcg11,qcg07,qcg08,0 ",
     " FROM  qcf_file LEFT OUTER JOIN ima_file ON qcf_file.qcf021=ima_file.ima01 ,qcg_file LEFT OUTER JOIN azf_file ON qcg_file.qcg04=azf_file.azf01 AND azf02='6' ",
     " WHERE ",tm.wc CLIPPED,
     "   AND qcg01 = qcf01 ",
     "   AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
     "   AND qcf14='Y' ",
     " ORDER BY 1,2,3,4,5,6,7"
 
 
    PREPARE q416_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q416_co                         # SCROLL CURSOR
        CURSOR FOR q416_p1
 
#   START REPORT q416_rep TO l_name           #No.FUN-850061
 
    FOREACH q416_co INTO sr.*,m_qcf01,m_qcf02,m_qcf05
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr.qcg11) THEN LET sr.qcg11 = 0 END IF
        IF cl_null(sr.qcg07) THEN LET sr.qcg07 = 0 END IF
        LET sr.rate = (sr.qcg07 / sr.qcg11) * 100
        IF cl_null(sr.rate) THEN LET sr.rate = 0 END IF
 
        CASE sr.qcg08
              WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING sr.qcg08
             #WHEN '2' CALL cl_getmsg('aqc-0333333',g_lang) RETURNING sr.qcg08   #TQC-A30004  
              WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING sr.qcg08       #TQC-A30004
        END CASE
#No.FUN-850061 --Begin
#       OUTPUT TO REPORT q416_rep(sr.*)
        EXECUTE insert_prep USING sr.*
#No.FUN-850061 --End
    END FOREACH
#No.FUN-850061 --Begin
#   FINISH REPORT q416_rep
    IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'qcf021')
                RETURNING tm.wc
    ELSE
        LET tm.wc=""
    END IF
    LET g_str=tm.wc,';',tm.bdate,';',tm.edate
    LET g_sql1="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aqcq416','aqcq416',g_sql1,g_str)
#No.FUN-850061 --End
    CLOSE q416_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)            #No.FUN-850061
END FUNCTION
#No.FUN-850061 --Begin
#REPORT q416_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
#   sr              RECORD
#                       qcf021              LIKE qcf_file.qcf021,
#                       ima02               LIKE ima_file.ima02,
#                       ima021              LIKE ima_file.ima021,
#                       qcf01               LIKE qcf_file.qcf01,
#                       qcf04               LIKE qcf_file.qcf04,
#                       qcf02               LIKE qcf_file.qcf02,
#                       qcg04               LIKE qcg_file.qcg04,
#                       azf03               LIKE azf_file.azf03,
#                       qcg11               LIKE qcg_file.qcg11,
#                       qcg07               LIKE qcg_file.qcg07,
#                       qcg08               LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(04)
#                       rate                LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)
#                   END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qcf021,sr.qcf01,sr.qcf04,sr.qcf02,sr.qcg04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT g_dash
#           #TQC-5B0034 mark
#           {PRINT g_x[11] CLIPPED,sr.qcf021,' ',
#                                 sr.ima02 CLIPPED,' ',
#                                 sr.ima021 CLIPPED}
#           #TQC-5B0034 add
#           PRINT g_x[11] CLIPPED,sr.qcf021 CLIPPED
#           PRINT COLUMN 10, sr.ima02 CLIPPED,' ',sr.ima021 CLIPPED
#           #TQC-5B0034 end
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39]
#           PRINT g_dash1
#           LET l_trailer_sw = 'n'
 
#       BEFORE GROUP OF sr.qcf021
#           SKIP TO TOP OF PAGE
#
#       BEFORE GROUP OF sr.qcf01
#           PRINT COLUMN g_c[31],sr.qcf01;
#       BEFORE GROUP OF sr.qcf04
#           PRINT COLUMN g_c[32],sr.qcf04;
#       BEFORE GROUP OF sr.qcf02
#           PRINT COLUMN g_c[33],sr.qcf02;
#
#       ON EVERY ROW
#           PRINT COLUMN g_c[34],sr.qcg04,
#                 COLUMN g_c[35],sr.azf03,
#                 COLUMN g_c[36],cl_numfor(sr.qcg11,36,0),
#                 COLUMN g_c[37],cl_numfor(sr.qcg07,37,0),
#                 COLUMN g_c[38],cl_numfor(sr.rate,38,3),
#                 COLUMN g_c[39],sr.qcg08
 
#       ON LAST ROW
#           PRINT g_dash
#           LET l_trailer_sw = 'y'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN(g_len-9), g_x[7] CLIPPED      #No.MOD-590003
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'n' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-850061 --End
#No.FUN-870144
