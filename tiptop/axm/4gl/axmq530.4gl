# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq530.4gl
# Descriptions...: 訂單修改記錄查詢
# Date & Author..: 95/01/11 By Danny
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790071 07/09/11 By lumxa 匯出Excel多一空白行
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
                wc      LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(500)                                             
                wc2     LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(500)
        END RECORD,
    g_oga   RECORD
            oga01   LIKE oga_file.oga01,
            oga02   LIKE oga_file.oga02,
            oga03   LIKE oga_file.oga03,
            oga04   LIKE oga_file.oga04,
            oga06   LIKE oga_file.oga06,
            oga032  LIKE oga_file.oga032,
            occ02   LIKE occ_file.occ02,
            oga14   LIKE oga_file.oga14,
            oga15   LIKE oga_file.oga15,
            ogaconf LIKE oga_file.ogaconf
        END RECORD,
    g_oem DYNAMIC ARRAY OF RECORD
            oem03   LIKE oem_file.oem03,
            oem08   LIKE oem_file.oem08,
            oem04   LIKE oem_file.oem04,
            oem06   LIKE oem_file.oem06,
            oem07   LIKE oem_file.oem07,
            oem10n  LIKE oem_file.oem10n,
            oem11n  LIKE oem_file.oem11n,
            oem12n  LIKE oem_file.oem12n
        END RECORD,
    g_argv1         LIKE oga_file.oga01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_sql           STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10   #單身筆數        #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
      DEFINE  l_sl    LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag=1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q530_w AT p_row,p_col
        WITH FORM "axm/42f/axmq530"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q530_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q530_q() END IF
    CALL q530_menu()
    CLOSE WINDOW q530_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q530_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oga01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_oem.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_oga.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga06,oga03,oga032,oga04,
                                      oga14,oga15,ogaconf
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(oga03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga03
              NEXT FIELD oga03
           END IF
           IF INFIELD(oga04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga04
              NEXT FIELD oga04
           END IF
           IF INFIELD(oga14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga14
              NEXT FIELD oga14
           END IF
           IF INFIELD(oga15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga15
              NEXT FIELD oga15
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
           IF INT_FLAG THEN RETURN END IF
           CALL q530_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   IF tm.wc2 = " 1=1" OR cl_null(tm.wc2) THEN
      LET g_sql=" SELECT oga01 FROM oga_file ",
                " WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql=" SELECT UNIQUE oga01 FROM oga_file,oem_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND oem01=oga01",
                "   AND ",tm.wc2 CLIPPED
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND ogauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY oga01"
 
   PREPARE q530_prepare FROM g_sql
   DECLARE q530_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q530_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2 = " 1=1" OR cl_null(tm.wc2) THEN
      LET g_sql=" SELECT COUNT(*) FROM oga_file ",
                " WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT oga01) FROM oga_file,oem_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND oem01=oga01",
                "   AND ",tm.wc2 CLIPPED
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND ogauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q530_pp  FROM g_sql
   DECLARE q530_cnt   CURSOR FOR q530_pp
END FUNCTION
 
FUNCTION q530_b_askkey()
   CONSTRUCT tm.wc2 ON oem03,oem08,oem04,oem06,oem07,
                       oem10n,oem11n,oem12n
                  FROM s_oem[1].oem03,s_oem[1].oem08,s_oem[1].oem04,
                       s_oem[1].oem06,s_oem[1].oem07,
                       s_oem[1].oem10n,s_oem[1].oem11n,s_oem[1].oem12n
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q530_menu()
 
   WHILE TRUE
      CALL q530_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q530_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oem),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q530_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q530_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q530_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q530_cnt
        FETCH q530_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q530_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q530_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q530_cs INTO g_oga.oga01
        WHEN 'P' FETCH PREVIOUS q530_cs INTO g_oga.oga01
        WHEN 'F' FETCH FIRST    q530_cs INTO g_oga.oga01
        WHEN 'L' FETCH LAST     q530_cs INTO g_oga.oga01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q530_cs INTO g_oga.oga01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
        INITIALIZE g_oga.* TO NULL  #TQC-6B0105
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
	SELECT oga01,oga02,oga03,oga04,oga06,oga032,'',oga14,oga15,ogaconf
	  INTO g_oga.*
	  FROM oga_file
	 WHERE oga01 = g_oga.oga01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)  #No.FUN-660167
        CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
 
    CALL q530_show()
END FUNCTION
 
FUNCTION q530_show()
   SELECT occ02 INTO g_oga.occ02 FROM occ_file WHERE occ01=g_oga.oga04
   IF SQLCA.SQLCODE THEN LET g_oga.occ02=' ' END IF
   DISPLAY BY NAME g_oga.*
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO ogaconf
   END IF
 
   CALL q530_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q530_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc2 = tm.wc2 CLIPPED," AND oem08 = '",g_oga.oga06,"'"
   END IF
   LET l_sql =
        "SELECT oem03,oem08,oem04,oem06,oem07,",
        "       oem10n,oem11n,oem12n",
        "  FROM oem_file ",
        " WHERE oem01 = '",g_oga.oga01,"'"," AND ", tm.wc2 CLIPPED,
        " ORDER BY oem03,oem08,oem04"
    PREPARE q530_pb FROM l_sql
    DECLARE q530_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q530_pb
 
    FOR g_cnt = 1 TO g_oem.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_oem[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q530_bcs INTO g_oem[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#       IF g_oem[g_cnt].oem12n IS NULL THEN LET g_oem[g_cnt].oem12n = 0 END IF
#       IF g_oem[g_cnt].oem13n IS NULL THEN LET g_oem[g_cnt].oem13n = 0 END IF
#       IF NOT cl_chk_act_auth() THEN LET g_oem[g_cnt].oem13n = NULL END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_oem.deleteElement(g_cnt)   #TQC-790071
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
        DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q530_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oem TO s_oem.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q530_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q530_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q530_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q530_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q530_fetch('L')
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
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
