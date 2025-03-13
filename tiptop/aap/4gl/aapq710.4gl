# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapq710.4gl
# Descriptions...: 預購到貨記錄查詢
# Date & Author..: 96/01/12 By Roger
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0104 06/11/21 By Rayven 匯出EXCEL匯出的值多出一空白行,筆數欄位數據有誤
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9A0024 09/10/09 By destiny display xxx.*改為display對應欄位
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690028 VARCHAR(600)
        	wc2  	LIKE type_file.chr1000		# Body Where condition  #No.FUN-690028 VARCHAR(600)
        END RECORD,
    g_hhh   RECORD
		ala01	LIKE ala_file.ala01,
		alb02	LIKE alb_file.alb02,
		alb04	LIKE alb_file.alb04,
		alb05	LIKE alb_file.alb05,
		ala05	LIKE ala_file.ala05,
		alb11	LIKE alb_file.alb11,
		alb06	LIKE alb_file.alb06,
		alb07	LIKE alb_file.alb07,
		alb08	LIKE alb_file.alb08,
		alt06_t	LIKE alt_file.alt06,  #FUN-4B0079
		alt07_t	LIKE alt_file.alt07,  #FUN-4B0079
		ale06_t	LIKE ale_file.ale06,  #FUN-4B0079
		ale07_t	LIKE ale_file.ale07   #FUN-4B0079
        END RECORD,
    g_als DYNAMIC ARRAY OF RECORD
		als01	LIKE als_file.als01,
		alt02	LIKE alt_file.alt02,
		als02	LIKE als_file.als02,
#NO.FUN-710029 start---
                alt83   LIKE alt_file.alt83, 
                alt84   LIKE alt_file.alt84,
                alt85   LIKE alt_file.alt85,
                alt80   LIKE alt_file.alt80,
                alt81   LIKE alt_file.alt81,
                alt82   LIKE alt_file.alt82,
                alt86   LIKE alt_file.alt86,
                alt87   LIKE alt_file.alt87,
#NO.FUN-710029 end---
		alt05	LIKE alt_file.alt05,
		alt06	LIKE alt_file.alt06,
		alt07	LIKE alt_file.alt07,
		ale02	LIKE ale_file.ale02,
		alk02	LIKE alk_file.alk02,
#NO.FUN-710029 start---
                ale83   LIKE ale_file.ale83, 
                ale84   LIKE ale_file.ale84,
                ale85   LIKE ale_file.ale85,
                ale80   LIKE ale_file.ale80,
                ale81   LIKE ale_file.ale81,
                ale82   LIKE ale_file.ale82,
                ale86   LIKE ale_file.ale86,
                ale87   LIKE ale_file.ale87,
#NO.FUN-710029 end---
		ale05	LIKE ale_file.ale05,
		ale06	LIKE ale_file.ale06,
		ale07	LIKE ale_file.ale07,
		ale16	LIKE ale_file.ale16,
		ale17	LIKE ale_file.ale17
        END RECORD,
    g_argv1         LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(20),	# LC No
    g_argv2         LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),	# 序
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-690028 SMALLINT
     g_wc,g_wc2,g_sql   string, #WHERE CONDITION  #No.FUN-580092 HCN
#   g_rec_b INTEGER 		  #單身筆數     #No.TQC-6B0104 mark
    g_rec_b         LIKE type_file.num10        #No.TQC-6B0104
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
MAIN
   DEFINE l_time	LIKE type_file.chr8,   		#計算被使用時間  #No.FUN-690028 VARCHAR(8)
          l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(2) Part#
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q710_w AT p_row,p_col
        WITH FORM "aap/42f/aapq710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #NO.FUN-710029 start--
    CALL q710_def_form()
    #NO.FUN-710029 end----
 
#    IF cl_chk_act_auth() THEN
#       CALL q710_q()
#    END IF
    CALL q710_menu()
    CLOSE WINDOW q710_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
 
#QBE 查詢資料
FUNCTION q710_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "ala01='",g_argv1,"' AND alb02='",g_argv2,"'"
	   LET tm.wc2=" 1=1 "
   ELSE CLEAR FORM #清除畫面
   CALL g_als.clear()
        CALL cl_opmsg('q')
        INITIALIZE tm.* TO NULL		       # Default condition
        CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_hhh.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME tm.wc ON
            ala01,ala05,alb11,alb02,alb04,alb05,alb06,alb08
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
           ON ACTION controlp
              CASE
                 WHEN INFIELD(ala01) # APO
                      CALL q_ala(TRUE,TRUE,g_hhh.ala01)
                           RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ala01
                 WHEN INFIELD(alb04) # 採購單
                     #CALL q_m_pmm5(TRUE,TRUE,g_hhh.alb04,g_dbs_new,'')
                      CALL q_m_pmm5(TRUE,TRUE,g_hhh.alb04,g_plant,'')  #FUN-980094
                           RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO alb04
                 WHEN INFIELD(ala05) #PAY TO VENDOR
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_pmc"
                      LET g_qryparam.default1 = g_hhh.ala05
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ala05
              END CASE
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
     #End:FUN-980030
 
           CALL q710_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT ala01,alb02,alb04,alb05,ala05,alb11,alb06,alb07,alb08",
             "   FROM ala_file, alb_file",
             " WHERE ala01=alb01 AND alafirm <> 'X' AND ",tm.wc CLIPPED,
             " ORDER BY 1,2"
   PREPARE q710_prepare FROM g_sql
   DECLARE q710_cs SCROLL CURSOR FOR q710_prepare
 
   #No.TQC-6B0104 --start--
#  LET g_sql=" SELECT COUNT(*) FROM ala_file",
#            " WHERE ",tm.wc CLIPPED
   LET g_sql=" SELECT COUNT(*) FROM ala_file,alb_file",
             " WHERE ala01=alb01 AND alafirm <> 'X' AND ",tm.wc CLIPPED
   #No.TQC-6B0104 --end--
   PREPARE q710_pre_count FROM g_sql
   DECLARE q710_count CURSOR FOR q710_pre_count
END FUNCTION
 
FUNCTION q710_b_askkey()
   CONSTRUCT tm.wc2 ON als01,als02
                  FROM s_als[1].als01,s_als[1].als02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION q710_menu()
 
   WHILE TRUE
      CALL q710_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q710_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_als),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q710_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q710_count
    FETCH q710_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q710_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q710_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q710_cs INTO g_hhh.*
       WHEN 'P' FETCH PREVIOUS q710_cs INTO g_hhh.*
       WHEN 'F' FETCH FIRST    q710_cs INTO g_hhh.*
       WHEN 'L' FETCH LAST     q710_cs INTO g_hhh.*
       WHEN '/'
             IF NOT mi_no_ask THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
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
             FETCH ABSOLUTE g_jump q710_cs INTO g_hhh.*
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hhh.ala01,SQLCA.sqlcode,0)
        INITIALIZE g_hhh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     END IF
 
    CALL q710_show()
END FUNCTION
 
FUNCTION q710_show()
   #No.FUN-9A0024--begin 
  # DISPLAY BY NAME g_hhh.*
   DISPLAY BY NAME g_hhh.ala01,g_hhh.alb02,g_hhh.alb04,g_hhh.alb05,g_hhh.ala05,
                   g_hhh.alb11,g_hhh.alb06,g_hhh.alb07,g_hhh.alb08   
   #No.FUN-9A0024--end 
   CALL q710_b_fill()
   DISPLAY BY NAME g_hhh.alt06_t,g_hhh.alt07_t,g_hhh.ale06_t,g_hhh.ale07_t
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q710_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
#NO.FUN-710029 start---
        #"SELECT als01, alt02, als02, alt05, alt06, alt07,",
        #"              ale02, alk02, ale05, ale06, ale07, ale16, ale17,",
        "SELECT als01, alt02, als02, alt83, alt84, alt85, alt80, alt81, alt82,",
        "       alt86, alt87, alt05, alt06, alt07,",
        "       ale02, alk02, ale83, ale84, ale85, ale80, ale81,",
        "       ale82, ale86, ale87, ale05, ale06, ale07, ale16, ale17",
#NO.FUN-710029 end-----
        "  FROM alt_file, als_file LEFT OUTER JOIN alk_file LEFT OUTER JOIN ale_file ON alk_file.alk01 = ale_file.ale01 ON als_file.als01 = alk_file.alk01 ",
        " WHERE als03='",g_hhh.ala01,"' AND als01=alt01 ",
        "   AND alt14='",g_hhh.alb04,"'",
        "   AND alt15='",g_hhh.alb05,"'",
        "   AND alk03='",g_hhh.ala01,"' ",
        "   AND ale14='",g_hhh.alb04,"'",
        "   AND ale15='",g_hhh.alb05,"'",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY 1,2"
    PREPARE q710_pb FROM l_sql
    DECLARE q710_bcs CURSOR WITH HOLD FOR q710_pb
 
    FOR g_cnt = 1 TO g_als.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_als[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_hhh.alt06_t=0 LET g_hhh.alt07_t=0
    LET g_hhh.ale06_t=0 LET g_hhh.ale07_t=0
    FOREACH q710_bcs INTO g_als[g_cnt].*
        IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_als[g_cnt].alt06 IS NULL THEN LET g_als[g_cnt].alt06=0 END IF
        IF g_als[g_cnt].alt07 IS NULL THEN LET g_als[g_cnt].alt07=0 END IF
        IF g_als[g_cnt].ale06 IS NULL THEN LET g_als[g_cnt].ale06=0 END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_als.deleteElement(g_cnt)  #No.TQC-6B0104
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_als TO s_als.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#NO.FUN-710029 start-------------------
FUNCTION q710_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("alt83,alt85,alt80,alt82",FALSE)
      CALL cl_set_comp_visible("ale83,ale85,ale80,ale82",FALSE)
      CALL cl_set_comp_visible("alt06,ale06",TRUE)
   ELSE
      CALL cl_set_comp_visible("alt83,alt84,alt85,alt80,alt81,alt82",TRUE)
      CALL cl_set_comp_visible("ale83,ale84,ale85,ale80,ale81,ale82",TRUE)
      CALL cl_set_comp_visible("alt06,ale06",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("alt86,alt87",FALSE)
      CALL cl_set_comp_visible("ale86,ale87",FALSE)
   END IF
 
   CALL cl_set_comp_visible("alt84,alt81",FALSE)
   CALL cl_set_comp_visible("ale84,ale81",FALSE)
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt82",g_msg CLIPPED)
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt82",g_msg CLIPPED)
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale82",g_msg CLIPPED)
   END IF
END FUNCTION
#NO.FUN-710029 end----------------------
 
