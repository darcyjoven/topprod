# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglq102.4gl
# Descriptions...: 科目每日餘額查詢
# Date & Author..: 92/02/25 By Nora
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-530285 05/03/25 By Smapmin 科目每日餘額只有借貸,沒有期初及本日餘額
# Modify         : No.MOD-530867 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-580243 05/08/24 By Smapmin 期初餘額不正確
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0093 06/11/16 By wujie   匯出excel錯
# Modify.........: No.MOD-6B0143 06/12/05 By Smapmin 修改金額顯示方式,依照科目為借餘或貸餘
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730085 07/03/20 By Smapmin 下日期條件時,期初金額有誤
# Modify.........: No.FUN-740020 07/04/05 By johnray 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc   LIKE type_file.chr1000,# Head Where condition   #No.FUN-680098 VARCHAR(600)
        	wc2  LIKE type_file.chr1000 # Body Where condition   #No.FUN-680098 VARCHAR(600)
        END RECORD,
    g_aag  RECORD
            aag00    LIKE aag_file.aag00,             #No.FUN-740020
            aag01    LIKE aag_file.aag01,
            aag02    LIKE aag_file.aag02
        END RECORD,
    g_aas DYNAMIC ARRAY OF RECORD
            aas02    LIKE aas_file.aas02,
             bamt    LIKE aas_file.aas04,             #MOD-530285
            aas04    LIKE aas_file.aas04,
            aas05    LIKE aas_file.aas05,
             tamt    LIKE aas_file.aas04              #MOD-530285
        END RECORD,
    g_bookno    LIKE aas_file.aas00,                  # INPUT ARGUMENT - 1
    g_wc,g_sql  STRING,                               #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680098
    p_row,p_col LIKE type_file.num5,                  #No.FUN-680098   SMALLINT
    g_rec_b     LIKE type_file.num5   		      #單身筆數        #No.FUN-680098 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680098   VARCHAR(72) 
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098   SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0073
      DEFINE    l_sl	 LIKE type_file.num5            #No.FUN-680098  SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq102_w AT p_row,p_col
         WITH FORM "agl/42f/aglq102"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL s_shwact(0,0,g_bookno)
#    IF cl_chk_act_auth() THEN
#       CALL q102_q()
#    END IF
IF NOT cl_null(g_bookno) THEN CALL q102_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
 
    CALL q102_menu()
    CLOSE WINDOW aglq102_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q102_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 smallint
 
   CLEAR FORM #清除畫面
   CALL g_aas.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
 
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON aag00,aag01,aag02        #No.FUN-740020
        ON ACTION CONTROLP
            CASE
#No.FUN-740020 -- begin --
                WHEN INFIELD(aag00)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aaa"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag00
#No.FUN-740020 -- end --
                WHEN INFIELD(aag01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag01
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
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   CONSTRUCT tm.wc2 ON aas02 FROM s_aas[1].aas02
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET g_sql=" SELECT aag00,aag01,aag02 FROM aag_file ",        #No.FUN-740020
             " WHERE aag03 matches '2' AND ",tm.wc CLIPPED,
             " ORDER BY aag00,aag01"                            #No.FUN-740020
   PREPARE q102_prepare FROM g_sql
   DECLARE q102_cs SCROLL CURSOR FOR q102_prepare
   # 取合乎條件筆數
   LET g_sql=" SELECT COUNT(*) FROM aag_file ",
             " WHERE aag03 matches '2' AND ",tm.wc CLIPPED
   PREPARE q102_prepare_cnt FROM g_sql
   DECLARE q102_count CURSOR FOR q102_prepare_cnt
END FUNCTION
 
FUNCTION q102_menu()
 
   WHILE TRUE
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q102_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aas),'','')     #TQC-6B0093
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q102_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q102_count
       FETCH q102_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q102_cs INTO g_aag.aag00,g_aag.aag01,g_aag.aag02    #No.FUN-740020
        WHEN 'P' FETCH PREVIOUS q102_cs INTO g_aag.aag00,g_aag.aag01,g_aag.aag02    #No.FUN-740020
        WHEN 'F' FETCH FIRST    q102_cs INTO g_aag.aag00,g_aag.aag01,g_aag.aag02    #No.FUN-740020
        WHEN 'L' FETCH LAST     q102_cs INTO g_aag.aag00,g_aag.aag01,g_aag.aag02    #No.FUN-740020
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump q102_cs INTO g_aag.aag00,g_aag.aag01,g_aag.aag02     #No.FUN-740020
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)
        INITIALIZE g_aag.* TO NULL  #TQC-6B0105
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
 
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
   DISPLAY BY NAME g_aag.aag00,g_aag.aag01,g_aag.aag02           #No.FUN-740020
   CALL q102_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
   DEFINE l_sql    LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(400) 
          l_n      LIKE type_file.num5,    #No.FUN-680098 smallint
          l_tot    LIKE aas_file.aas04,
           l_year  LIKE aah_file.aah02,  #MOD-580243
           l_month LIKE aah_file.aah03,  #MOD-580243
           l_bamt1 LIKE aas_file.aas04,  #MOD-580243
           l_bamt2 LIKE aas_file.aas04   #MOD-580243
   DEFINE l_aag06  LIKE aag_file.aag06   #MOD-6B0143
 
 
   LET l_sql =
        "SELECT aas02,'',aas04,aas05,''",
        " FROM  aas_file",
#        " WHERE aas00 = '",g_bookno,"'",       #No.FUN-740020
        " WHERE aas00 = '",g_aag.aag00,"'",     #No.FUN-740020
        " AND aas01 = '",g_aag.aag01,"'",
        " AND ",tm.wc2,
         " ORDER BY aas02 "   #MOD-580243
    PREPARE q102_pb FROM l_sql
    DECLARE q102_bcs CURSOR FOR q102_pb
 
    FOR g_cnt = 1 TO g_aas.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_aas[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q102_bcs INTO g_aas[g_cnt].*
       IF STATUS THEN CALL cl_err('',SQLCA.sqlcode,1) EXIT FOREACH END IF
 #MOD-530285
 #MOD-580243
       IF g_cnt = 1 THEN
          LET l_year =  YEAR(g_aas[g_cnt].aas02)
          LET l_month = MONTH(g_aas[g_cnt].aas02)
 
          SELECT SUM(aah04)-SUM(aah05) INTO l_bamt1
            FROM aah_file WHERE aah01=g_aag.aag01
            AND aah00 = g_aag.aag00             #No.FUN-740020
            AND (aah02 < l_year
            OR (aah02 = l_year AND aah03 < l_month))
            AND aah03 <> 0    #MOD-730085
          IF l_bamt1 IS NULL THEN LET l_bamt1 = 0 END IF
 
          SELECT SUM(aas04)-SUM(aas05) INTO l_bamt2
            FROM aas_file WHERE aas01=g_aag.aag01
            AND aas00 = g_aag.aag00             #No.FUN-740020
            AND aas02 >= MDY(l_month,01,l_year)
            AND aas02 < g_aas[g_cnt].aas02
          IF l_bamt2 IS NULL THEN LET l_bamt2 = 0 END IF
 
          LET g_aas[g_cnt].bamt = l_bamt1 + l_bamt2
          IF g_aas[g_cnt].bamt IS NULL THEN LET g_aas[g_cnt].bamt = 0 END IF
 #END MOD-580243
       ELSE
          LET g_aas[g_cnt].bamt = g_aas[g_cnt-1].tamt
       END IF
 
       #-----MOD-6B0143---------
       #LET g_aas[g_cnt].tamt = g_aas[g_cnt].bamt + g_aas[g_cnt].aas04 -
       #                        g_aas[g_cnt].aas05
       LET l_aag06 = ''
       SELECT aag06 INTO l_aag06 FROM aag_file
         WHERE aag01=g_aag.aag01
         AND aag00 = g_aag.aag00             #No.FUN-740020
       IF l_aag06 = '2' THEN
          IF g_cnt = 1 THEN
             LET g_aas[g_cnt].bamt = g_aas[g_cnt].bamt * -1
          END IF
          LET g_aas[g_cnt].tamt = g_aas[g_cnt].bamt + g_aas[g_cnt].aas05 -
                                  g_aas[g_cnt].aas04
       ELSE
          LET g_aas[g_cnt].tamt = g_aas[g_cnt].bamt + g_aas[g_cnt].aas04 -
                                  g_aas[g_cnt].aas05
       END IF
       #-----END MOD-6B0143-----
 
 #END MOD-530285
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_aas.deleteElement(g_cnt)    #TQC-6B0093 
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aas TO s_aas.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q102_fetch('L')
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
