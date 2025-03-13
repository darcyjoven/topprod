# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asdq100.4gl
# Descriptions...: 標準成本工單領退查詢
# Date & Author..: 00/07/31 By Sophia
# Modify.........: No.FUN-4B0016 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
 # Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.TQC-660038 06/06/09 By Pengu 按"查詢"出現閒置時間Warning
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
       	wc  	LIKE type_file.chr1000,      #No.FUN-690010CHAR(600),		# Head Where condition
       	wc2  	LIKE type_file.chr1000       #No.FUN-690010CHAR(600) 		# Body Where condition
        END RECORD,
    g_sfb   RECORD
	stf01	LIKE stf_file.stf01,
	stf04	LIKE stf_file.stf04,
	sfb05	LIKE sfb_file.sfb05,
	ima02a	LIKE ima_file.ima02,
        stf02   LIKE stf_file.stf02,
        stf03   LIKE stf_file.stf03
        END RECORD,
    g_stf DYNAMIC ARRAY OF RECORD
            stf05   LIKE stf_file.stf05,
            stf06   LIKE stf_file.stf06,
            stf07   LIKE stf_file.stf07,
            ima02   LIKE ima_file.ima02, 
            stf11   LIKE stf_file.stf11,
            stf08   LIKE stf_file.stf08,
            stf09   LIKE stf_file.stf09,
            stf10   LIKE stf_file.stf10
        END RECORD,
     g_wc,g_wc2,g_sql string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num10         #No.FUN-690010INT #單身筆數
 
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0089
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q100_w AT p_row,p_col
      WITH FORM "asd/42f/asdq100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q100_q()
#    END IF
    CALL q100_menu()
    CLOSE WINDOW q100_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
END MAIN
 
#QBE 查詢資料
FUNCTION q100_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
    CLEAR FORM #清除畫面
   CALL g_stf.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL			# Default condition
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON stf01,stf04,stf02,stf03
      #ON IDLE g_idle_seconds     #No.TQC-660038 mark
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds     #No.TQC-660038 add
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
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    CALL q100_b_askkey()
   MESSAGE ' WAIT ' 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql=" SELECT UNIQUE stf04,stf02,stf03 FROM stf_file ",
                 " WHERE ",tm.wc CLIPPED
     ELSE					# 若單身有輸入條件
       LET g_sql=" SELECT UNIQUE stf04,stf02,stf03 FROM stf_file ",
                 " WHERE ",tm.wc CLIPPED,
                 " AND ",tm.wc2 CLIPPED
    END IF
   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q100_prepare
 
   LET g_sql= "SELECT COUNT(DISTINCT stf04) FROM stf_file ",
              " WHERE ",tm.wc CLIPPED 
   PREPARE q100_precount FROM g_sql
   DECLARE q100_count CURSOR FOR q100_precount
 
 
END FUNCTION
 
FUNCTION q100_b_askkey()
 
    CONSTRUCT tm.wc2 ON stf05,stf06,stf07,stf08,stf09,stf10,stf11
                  FROM s_stf[1].stf05,s_stf[1].stf06,s_stf[1].stf07,
                       s_stf[1].stf08,s_stf[1].stf09,s_stf[1].stf10,
		       s_stf[1].stf11
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
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
END FUNCTION
 
#中文的MENU
FUNCTION q100_menu()
 
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0016
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_stf),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
  DEFINE l_stf04   LIKE stf_file.stf04,
         l_stf03   LIKE stf_file.stf03,
         l_stf02   LIKE stf_file.stf02,
         l_cnt     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    CALL q100_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       LET l_cnt = 0
       OPEN q100_count
       FETCH q100_count INTO g_row_count
       LET l_cnt = SQLCA.sqlerrd[3]
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs INTO g_sfb.stf04,g_sfb.stf02,g_sfb.stf03
        WHEN 'P' FETCH PREVIOUS q100_cs INTO g_sfb.stf04,g_sfb.stf02,g_sfb.stf03
        WHEN 'F' FETCH FIRST    q100_cs INTO g_sfb.stf04,g_sfb.stf02,g_sfb.stf03
        WHEN 'L' FETCH LAST     q100_cs INTO g_sfb.stf04,g_sfb.stf02,g_sfb.stf03
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
            FETCH ABSOLUTE g_jump q100_cs INTO g_sfb.stf04,g_sfb.stf02,g_sfb.stf03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.stf04,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  #TQC-6B0105
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
    LET g_sfb.ima02a= ' '
    LET g_sfb.sfb05 = ' '
    SELECT sfb05 INTO g_sfb.sfb05  FROM sfb_file WHERE sfb01 = g_sfb.stf04
    SELECT ima02 INTO g_sfb.ima02a FROM ima_file WHERE ima01 = g_sfb.sfb05
    SELECT UNIQUE stf01 INTO g_sfb.stf01  FROM stf_file
     WHERE stf02=g_sfb.stf02
       AND stf03=g_sfb.stf03
       AND stf04=g_sfb.stf04
 
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
   DISPLAY BY NAME g_sfb.*   # 顯示單頭值
   CALL q100_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q100_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-690010 VARCHAR(400)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT stf05,stf06,stf07,ima02,stf11,stf08,stf09,stf10",
        "  FROM stf_file LEFT OUTER JOIN ima_file ON stf_file.stf07=ima_file.ima01  ",
        " WHERE stf04 = '", g_sfb.stf04,"'",
	"   AND stf02 = '", g_sfb.stf02,"'",
        "   AND stf03 = '",g_sfb.stf03,"'",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY stf05 "
    PREPARE q100_pb FROM l_sql
    DECLARE q100_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q100_pb
 
    CALL g_stf.clear()
    LET g_cnt = 1
    FOREACH q100_bcs INTO g_stf[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_stf TO s_stf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q100_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
#FUN-4B0016
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
       #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end           
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
