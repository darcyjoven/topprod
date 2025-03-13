# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: acoq530.4gl
# Descriptions...: 成品進出口每日異動統計量查詢
# Date & Author..: 05/04/04 By wujie
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc   LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(500) # Head Where condition-1
                dd   LIKE type_file.dat           #No.FUN-680069 date
        END RECORD,
    g_cod   RECORD
                cod03 LIKE cod_file.cod03,
                cob02 LIKE cob_file.cob02,
                cob09 LIKE cob_file.cob09,
                coc03 LIKE coc_file.coc03,
                coc10 LIKE coc_file.coc10,
                cod05 LIKE cod_file.cod05,
                cod10 LIKE cod_file.cod10,
                cod06 LIKE cod_file.cod06
        END RECORD,
    g_cne DYNAMIC ARRAY OF RECORD
                cne03  LIKE cne_file.cne03,
                cne05  LIKE cne_file.cne05,
                cne06  LIKE cne_file.cne06,
                cne07  LIKE cne_file.cne07,
                cne08  LIKE cne_file.cne08,
                cne09  LIKE cne_file.cne09,
                cne10  LIKE cne_file.cne10,
                cne12  LIKE cne_file.cne12
        END RECORD,
    g_query_flag       LIKE type_file.num5,  g_cod01  LIKE cod_file.cod01, g_cod02  LIKE cod_file.cod02,         #No.FUN-680069 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql              STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b            LIKE type_file.num5   		  #單身筆數        #No.FUN-680069 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0063
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q530_w AT p_row,p_col
         WITH FORM "aco/42f/acoq530"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL q530_menu()
    CLOSE WINDOW q530_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION q530_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   CLEAR FORM
   CALL g_cne.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.wc TO NULL		
   LET tm.dd = g_today
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   INITIALIZE g_cod.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON cod03,cob09,coc03,coc10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   INPUT BY NAME tm.dd WITHOUT DEFAULTS
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
   #End:FUN-980030
 
 
    MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE cod01,cod02,cod03",
             " FROM cod_file,cob_file,coc_file ",
             " WHERE cod03 = cob01 ",
             "   AND cod01 = coc01 ",
             "   AND ",tm.wc CLIPPED
 
   LET g_sql = g_sql clipped," ORDER BY cod03"
    PREPARE q530_prepare FROM g_sql
    DECLARE q530_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q530_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) ",
             " FROM cod_file,cob_file,coc_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND cod03 = cob01 ",
               "   AND cod01 = coc01 ",
               "   AND ",tm.wc CLIPPED
    PREPARE q530_pp  FROM g_sql
    DECLARE q530_count   CURSOR FOR q530_pp
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
         WHEN "exporttoexcel" #FUN-4B0002
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cne),'','')
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN q530_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q530_count
       FETCH q530_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q530_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q530_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q530_cs INTO g_cod01,g_cod02,g_cod.cod03
        WHEN 'P' FETCH PREVIOUS q530_cs INTO g_cod01,g_cod02,g_cod.cod03
        WHEN 'F' FETCH FIRST    q530_cs INTO g_cod01,g_cod02,g_cod.cod03
        WHEN 'L' FETCH LAST     q530_cs INTO g_cod01,g_cod02,g_cod.cod03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q530_cs INTO g_cod01,g_cod02,g_cod.cod03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cod.cod03,SQLCA.sqlcode,0)
        INITIALIZE g_cod.* TO NULL  #TQC-6B0105
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
    SELECT cod03,cob02,cob09,coc03,coc10,cod05,cod10,cod06
      INTO g_cod.cod03,g_cod.cob02,g_cod.cob09,g_cod.coc03,g_cod.coc10,
           g_cod.cod05,g_cod.cod10,g_cod.cod06
      FROM cod_file,cob_file,coc_file
     WHERE cod01 = g_cod01 AND cod02 = g_cod02
       AND cob_file.cob01=cod_file.cod03
       AND coc_file.coc01=cod_file.cod01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cod.cod03,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cod_file,cob_file,coc_file",g_cod.cod03,"",SQLCA.SQLCODE,"","",0) #NO.TQC-660045
       RETURN
    END IF
 
    CALL q530_show()
END FUNCTION
 
FUNCTION q530_show()
   #No.FUN-9A0024--begin  
   DISPLAY BY NAME g_cod.*
   DISPLAY BY NAME g_cod.cod03,g_cod.cob02,g_cod.cob09,g_cod.coc03,g_cod.coc10,g_cod.cod05,                                         
                   g_cod.cod10,g_cod.cod06
   #No.FUN-9A0024--end 
   CALL q530_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q530_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,   #No.FUN-680069 VARCHAR(2000)
          l_nouse   LIKE type_file.chr1       #No.FUN-680069 VARCHAR(01)
 
   LET l_sql=" SELECT cne03,cne05,cne06,cne07,cne08,cne09,",
              "        cne10,cne12",   #No.MOD-530224
             "  FROM cne_file ",
             " WHERE cne01 ='",g_cod.coc03,"'",
             "   AND cne02 ='",g_cod.cod03,"'"
   IF NOT cl_null(tm.dd) THEN
      LET l_sql = l_sql CLIPPED," AND cne03 >='",tm.dd,"'"
   END IF
   LET l_sql = l_sql CLIPPED,"ORDER BY cne03"
   PREPARE q530_pb FROM l_sql
   DECLARE q530_bcs
       CURSOR FOR q530_pb
   FOR g_cnt = 1 TO g_cne.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_cne[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q530_bcs INTO g_cne[g_cnt].*
       IF g_cnt=1 THEN
          LET g_rec_b=SQLCA.SQLERRD[3]
       END IF
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_cne.deleteElement(g_cnt)
   LET g_rec_b = g_cnt- 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q530_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_cne TO s_cne.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480051
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()                    #No.FUN-560228
 
#NO.FUN-6B0033--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0033--END   
 
 
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
         EXIT DISPLAY
 
 
      ON ACTION previous
         CALL q530_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
 
 
      ON ACTION jump
         CALL q530_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
 
 
      ON ACTION next
         CALL q530_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
 
 
      ON ACTION last
         CALL q530_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
#        LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
