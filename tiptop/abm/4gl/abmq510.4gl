# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmq510.4gl
# Descriptions...: BOM 單階用途查詢
# Date & Author..: 94/02/06  By  Roger
#	.........: 將組成用量除以底數
# Modify.........: No:9727 04/07/09 1.109行應改成LET g_sql = "SELECT UNIQUE bmb03 FROM bmb_file"
#                                   2.115行應改成 g_sql = " SELECT COUNT(DISTINCT bmb03) FROM bmb_file"
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-510115 05/01/19 By ching per 與 4gl array 需一致
# Modify.........: No.FUN-550093 05/05/26 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-850118 08/05/15 By claire 料號加入開窗
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:MOD-A50120 10/06/16 By Pengu 單身會多一筆空白資料
# Modify.........: No:MOD-A10186 10/08/03 By Pengu 排除主件是無效資料
# Modify.........: No.CHI-CA0002 12/10/12 By Elise 修改MOD-850118開窗,改為q_bma101(改善效能)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500)
        END RECORD,
    g_head_1   RECORD
            bmb03 LIKE bmb_file.bmb03,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima05 LIKE ima_file.ima05,
            ima08 LIKE ima_file.ima08,
            ima63 LIKE ima_file.ima63
            END RECORD,
	g_vdate LIKE type_file.dat,       #No.FUN-680096 DATE 
	g_rec_b LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    g_body DYNAMIC ARRAY OF RECORD
            bmb02   LIKE bmb_file.bmb02,
            bmb01   LIKE bmb_file.bmb01,
             ima02_b LIKE ima_file.ima02,  #MOD-510115
            ima021_b LIKE ima_file.ima021,
            bmb06   LIKE bmb_file.bmb06,
            bmb08   LIKE bmb_file.bmb08,
            bmb13   LIKE bmb_file.bmb13,
            bmb29   LIKE bmb_file.bmb29  #FUN-550093
        END RECORD,
     g_argv1        LIKE bmb_file.bmb03, # INPUT ARGUMENT - 1 #No.MOD-490217
     g_sql string                        #No.FUN-580092 HCN
DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_msg        LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE  lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031  HCN
 
MAIN
     DEFINE #  l_time LIKE type_file.chr8          #No.FUN-6A0060
          l_sl	      LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q510_w AT p_row,p_col WITH FORM "abm/42f/abmq510"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
    #FUN-560021................end
 
    IF NOT cl_null(g_argv1) THEN CALL q510_q() END IF
    CALL q510_menu()
    CLOSE WINDOW q510_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q510_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bmb03 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
      CALL g_body.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_head_1.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON bmb03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      #--No.MOD-850118--------
      ON ACTION CONTROLP
        CASE 
         WHEN INFIELD(bmb03) #主件
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
      	     #LET g_qryparam.form = "q_bmb01"    #CHI-CA0002 mark
              LET g_qryparam.form = "q_bma101"   #CHI-CA0002
              CALL cl_create_qry() RETURNING g_qryparam.multiret
      	      DISPLAY g_qryparam.multiret TO bmb03
      	      NEXT FIELD bmb03
         OTHERWISE 
              EXIT CASE
         END CASE
      #--#MOD-850118-END-------    
 
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
      INPUT BY NAME g_vdate WITHOUT DEFAULTS
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END INPUT                   #TQC-860021
      CALL q510_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING '
   LET g_sql = " SELECT UNIQUE bmb03 FROM bmb_file", #No:9727
               "  WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
               " ORDER BY bmb03"
   PREPARE q510_prepare FROM g_sql
   DECLARE q510_cs SCROLL CURSOR FOR q510_prepare
   LET g_sql= " SELECT COUNT(UNIQUE bmb03) FROM bmb_file", #No:9727
              "  WHERE ",tm.wc CLIPPED,
              " AND ",tm.wc2 CLIPPED
   PREPARE q510_pp FROM g_sql
   DECLARE q510_count CURSOR FOR q510_pp
END FUNCTION
 
 
FUNCTION q510_b_askkey()
   CONSTRUCT tm.wc2 ON bmb02,bmb01,bmb13,bmb29 #FUN-550093
                  FROM s_bmb[1].bmb02,s_bmb[1].bmb01,s_bmb[1].bmb13,s_bmb[1].bmb29 #FUN-550093
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
 
FUNCTION q510_menu()
 
   WHILE TRUE
      CALL q510_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q510_q()
         WHEN "jump"
            CALL q510_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q510_fetch('N')
         WHEN "previous"
            CALL q510_fetch('P')
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_body),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q510_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q510_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q510_count
       FETCH q510_count INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q510_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q510_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1          #處理方式        #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q510_cs INTO g_head_1.bmb03 #No:9727
        WHEN 'P' FETCH PREVIOUS q510_cs INTO g_head_1.bmb03 #No:9727
        WHEN 'F' FETCH FIRST    q510_cs INTO g_head_1.bmb03 #No:9727
        WHEN 'L' FETCH LAST     q510_cs INTO g_head_1.bmb03 #No:9727
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
            FETCH ABSOLUTE g_jump q510_cs INTO g_head_1.bmb03 #No:9727
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_head_1.bmb03,SQLCA.sqlcode,0)
       INITIALIZE g_head_1.* TO NULL  #TQC-6B0105
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
    SELECT ima02,ima021,ima05,ima08,ima63
      INTO g_head_1.ima02,g_head_1.ima021,g_head_1.ima05,g_head_1.ima08,g_head_1.ima63
      FROM ima_file
     WHERE ima01 = g_head_1.bmb03
    IF SQLCA.sqlcode THEN
       LET g_head_1.ima02 = NULL
        LET g_head_1.ima021 = NULL
    END IF
    CALL q510_show()
END FUNCTION
 
FUNCTION q510_show()
   DISPLAY BY NAME g_head_1.*
   #No.FUN-9A0024--begin                                                                                                            
   #DISPLAY BY NAME g_head_1.*
   DISPLAY BY NAME g_head_1.bmb03,g_head_1.ima02,g_head_1.ima021,g_head_1.ima05,g_head_1.ima08,g_head_1.ima63                                        
   #No.FUN-9A0024--end   
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO FORMONLY.g_s
   END IF
   CALL q510_b_fill() #單身
END FUNCTION
 
FUNCTION q510_b_fill()              #BODY FILL UP
   DEFINE l_sql    LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(1000)
   DEFINE i        LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
    LET l_sql =			#95/12/21 Modify By Lynn
        "SELECT bmb02,bmb01,ima02,ima021, ",
        "       (bmb06/bmb07),bmb08,bmb13,bmb29 ",
        " FROM  bmb_file, bma_file, OUTER ima_file",   #No:MOD-A10186 modify
        " WHERE ",tm.wc2 CLIPPED,
        "   AND bmb03 = '",g_head_1.bmb03,"'",
        "   AND bmb01 = bma01 ",     #No:MOD-A10186 add
        "   AND bmaacti = 'Y' ",     #No:MOD-A10186 add
        "   AND bmb_file.bmb01 = ima_file.ima01"
    IF g_vdate IS NOT NULL THEN
       LET l_sql=l_sql CLIPPED,
        " AND (bmb04 <='",g_vdate CLIPPED,"' OR bmb04 IS NULL)",
        " AND (bmb05 > '",g_vdate CLIPPED,"' OR bmb05 IS NULL)"
    END IF
    CASE
      WHEN g_sma.sma65 = '1' LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
      WHEN g_sma.sma65 = '2' LET l_sql=l_sql CLIPPED," ORDER BY bmb01"
      WHEN g_sma.sma65 = '3' LET l_sql=l_sql CLIPPED," ORDER BY bmb13"
      OTHERWISE
                             LET l_sql=l_sql CLIPPED," ORDER BY bmb01"
    END CASE
    PREPARE q510_pb FROM l_sql
    DECLARE q510_bcs CURSOR FOR q510_pb
    FOR g_cnt = 1 TO g_body.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_body[g_cnt].* TO NULL
    END FOR
    CALL g_body.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q510_bcs INTO g_body[g_cnt].*
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_body.deleteElement(g_cnt)  #No:MOD-A50120 add
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_body TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
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
         CALL q510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q510_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q510_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
 
   ON ACTION accept
     #LET l_ac = ARR_CURR()
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
 
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#Patch....NO.TQC-610035 <001,002,003,004,005,006,007> #
