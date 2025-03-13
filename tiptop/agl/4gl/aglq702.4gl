# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglq702.4gl
# Descriptions...: 專案別異動明細查詢
# Date & Author..: 01/09/28 By Wiky
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By arman   會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By bnlent   會計科目加帳套BUG修改，帳套開窗有誤，畫面輸入順序有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
       	wc  	LIKE type_file.chr1000 # Head Where condition   #No.FUN-680098  VARCHAR(600)
        END RECORD,
    l_aeg  RECORD
            aeg00   LIKE aeg_file.aeg00,    #No.TQC-740093
            aeg05   LIKE aeg_file.aeg05
        END RECORD,
    g_aeg DYNAMIC ARRAY OF RECORD
            aeg02   LIKE aeg_file.aeg02,
            aeg01   LIKE aeg_file.aeg01,
            aeg03   LIKE aeg_file.aeg03,
            abb07_1 LIKE abb_file.abb07,#借
            abb07_2 LIKE abb_file.abb07,#貸
            abb99   LIKE type_file.num20_6      #餘額   #No.FUN-4C0009  #No.FUN-680098 decimal(20,6)
        END RECORD,
    g_bookno        LIKE aeg_file.aeg00,          # INPUT ARGUMENT - 1
    g_aeg01         LIKE type_file.chr20,         #No.FUN-680098  VARCHAR(20) 
    g_wc,g_wc2,g_sql,g_sql1 STRING, #WHERE CONDITION  #No.FUN-580092 HCN      
    g_rec_b LIKE type_file.num5,  		  #單身筆數        #No.FUN-680098 smallint
    l_bal   LIKE type_file.num20_6   #No.FUN-4C0009     #No.FUN-680098  decimal(20,6)
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg           LIKE ze_file.ze03           #No.FUN-680098 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE  g_sql_tmp       STRING                       #No.TQC-740093
MAIN
#     DEFINE   l_time LIKE type_file.chr8         	    #No.FUN-6A0073
      DEFINE    l_sl,p_row,p_col	LIKE type_file.num5          #No.FUN-680098  smallint
 
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
 
 
#    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#    #NO.FUN-740020
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq702_w AT p_row,p_col
         WITH FORM "agl/42f/aglq702"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)              #NO.FUN-740020
#    IF cl_chk_act_auth() THEN
#       CALL q702_q()
#    END IF
#IF NOT cl_null(g_bookno) THEN CALL q702_q() END IF     #NO.FUN-740020
#    IF cl_null(g_bookno)  THEN LET g_bookno = g_aaz.aaz64 END IF     #NO.FUN-740020
 
    CALL q702_menu()
    CLOSE WINDOW aglq702_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q702_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 smallint
 
    CLEAR FORM #清除畫面
   CALL g_aeg.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL			# Default condition
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY ''
    ELSE
       DISPLAY "[        ]" AT 8,1
    END IF
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE l_aeg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
              aeg00,aeg05,aeg02                #NO.FUN-740020    #No.TQC-740093
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(aeg05)    #查詢專案編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gja"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aeg05
                WHEN INFIELD(aeg00)    
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aaa"       #No.TQC-740093
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aeg00
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    DISPLAY "" AT  8,1
    IF INT_FLAG THEN RETURN END IF
 
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
    #End:FUN-980030
 
 
    LET g_sql=" SELECT UNIQUE aeg00,aeg05  FROM aeg_file,aag_file ",    #No.TQC-740093
              " WHERE ",tm.wc CLIPPED,
              #" AND aeg00 = '",g_bookno,"'",      #NO.FUN-740020   
              " AND aeg00 = aag00 ",               #NO.FUN-740020
              " AND aeg01 = aag01 ",
              " ORDER BY aeg00,aeg05 "             #No.TQC-740093
    PREPARE q702_prepare FROM g_sql
    DECLARE q702_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q702_prepare
 
   LET g_sql=" SELECT UNIQUE aeg00,aeg05 FROM aeg_file,aag_file ",  #No.TQC-740093
             " WHERE ",tm.wc CLIPPED,
             #" AND aeg00 = '",g_bookno,"'",       #NO.FUN-740020   
             " AND aeg00 = aag00 ",                #NO.FUN-740020
             " AND aeg01 = aag01 "
    #No.TQC-740093  -Begin
    LET g_sql_tmp = g_sql CLIPPED,"  INTO TEMP x"
    DROP TABLE x
    PREPARE q702_pre_x FROM g_sql_tmp
    EXECUTE q702_pre_x
    LET g_sql = "SELECT COUNT(*) FROM x"
    #No.TQC-740093  -End
   PREPARE q702_prepare_cnt FROM g_sql
   DECLARE q702_count CURSOR FOR q702_prepare_cnt
 
END FUNCTION
 
FUNCTION q702_b_askkey()
   LET l_bal =0
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY ''
    ELSE
       DISPLAY "[        ]" AT 8,1
    END IF
END FUNCTION
 
FUNCTION q702_menu()
   WHILE TRUE
      CALL q702_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q702_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aeg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q702_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q702_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q702_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q702_count
       FETCH q702_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
        CALL q702_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q702_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q702_cs INTO l_aeg.aeg00,l_aeg.aeg05     #No.TQC-740093
        WHEN 'P' FETCH PREVIOUS q702_cs INTO l_aeg.aeg00,l_aeg.aeg05     #No.TQC-740093
        WHEN 'F' FETCH FIRST    q702_cs INTO l_aeg.aeg00,l_aeg.aeg05     #No.TQC-740093
        WHEN 'L' FETCH LAST     q702_cs INTO l_aeg.aeg00,l_aeg.aeg05     #No.TQC-740093
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
            FETCH ABSOLUTE g_jump q702_cs INTO l_aeg.aeg00,l_aeg.aeg05    #No.TQC-740093
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_aeg.aeg05,SQLCA.sqlcode,0)
        INITIALIZE l_aeg.* TO NULL  #TQC-6B0105
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
 
    CALL q702_show()
END FUNCTION
 
FUNCTION q702_show()
   DISPLAY l_aeg.aeg00 TO aeg00   # 顯示單頭值   #No.TQC-740093
   DISPLAY l_aeg.aeg05 TO aeg05   # 顯示單頭值
   CALL q702_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q702_b_fill()              #BODY FILL UP
   DEFINE
   l_sql     LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(400) 
   l_bal     LIKE type_file.num20_6,   #No.FUN-4C0009    #No.FUN-680098  decimal(20,6)
   l_abb06   LIKE abb_file.abb06,
   l_abb07   LIKE abb_file.abb07
 
   LET l_sql =
        "SELECT aeg02, aeg01, aeg03, 0,0,0,abb06,abb07 ",
        " FROM  aeg_file , abb_file ",
        " WHERE aeg00 = '",l_aeg.aeg00,"'",       #NO.FUN-740020  #No.TQC-740093
	" AND aeg05 = '",l_aeg.aeg05,"'",
	" AND abb00 = aeg00 AND abb01 = aeg03 AND abb02 = aeg04 ",
	" AND ",tm.wc CLIPPED,
        " ORDER BY 1 "
    PREPARE q702_pb FROM l_sql
    DECLARE q702_bcs                       #BODY CURSOR
        CURSOR FOR q702_pb
    CALL g_aeg.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET l_bal = 0
    LET l_abb06 = NULL
    LET l_abb07 = NULL
    FOREACH q702_bcs INTO g_aeg[g_cnt].*,l_abb06,l_abb07
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        IF l_abb06 = '1' THEN
            LET g_aeg[g_cnt].abb07_1 = l_abb07  #借
            LET g_aeg[g_cnt].abb07_2 = NULL
            LET l_bal = l_bal + l_abb07
        ELSE
            LET g_aeg[g_cnt].abb07_1 = NULL
            LET g_aeg[g_cnt].abb07_2 = l_abb07  #貸
            LET l_bal = l_bal - l_abb07
        END IF
        LET g_aeg[g_cnt].abb99 = l_bal
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aeg.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q702_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aeg TO s_aeg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q702_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q702_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q702_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q702_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q702_fetch('L')
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
END FUNCTION
 
