# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asdq102.4gl
# Descriptions...: 每月工單投入入工/製費查詢
# Date & Author..: 00/07/31 By Mandy
# Modify.........: No.FUN-4B0016 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
 # Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
 # Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
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
	sth03   LIKE sth_file.sth03,
	sfb05   LIKE sfb_file.sfb05,
	ima02   LIKE ima_file.ima02
        END RECORD,
    g_sth DYNAMIC ARRAY OF RECORD
	sth01	LIKE sth_file.sth01,
	sth02	LIKE sth_file.sth02,
	sth04	LIKE sth_file.sth04,
	sth05	LIKE sth_file.sth05,
	sth06	LIKE sth_file.sth06,
	sth07	LIKE sth_file.sth07
        END RECORD,
     g_wc,g_wc2,g_sql string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num10         #No.FUN-690010INT 		  #單身筆數
 
 
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
    OPEN WINDOW q102_w AT p_row,p_col
        WITH FORM "asd/42f/asdq102" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q102_q()
#    END IF
    CALL q102_menu()
    CLOSE WINDOW q102_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
END MAIN
 
#QBE 查詢資料
FUNCTION q102_cs()
    DEFINE   l_cnt LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
    CLEAR FORM #清除畫面
   CALL g_sth.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL			# Default condition
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON sth03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      #MOD-530850                                                                
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(sfb05)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_ima"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_sfb.sfb05                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO sfb05                                
            NEXT FIELD sfb05                                                    
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
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    CALL q102_b_askkey()
    MESSAGE ' WAIT ' 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql=" SELECT UNIQUE sth03 FROM sth_file ",
                  " WHERE ",tm.wc CLIPPED
    ELSE					# 若單身有輸入條件
        LET g_sql=" SELECT UNIQUE sth03 FROM sth_file ",
                  " WHERE ",tm.wc CLIPPED,
                  " AND ",tm.wc2 CLIPPED
    END IF
    PREPARE q102_prepare FROM g_sql
    DECLARE q102_cs                         #SCROLL CURSOR
        SCROLL CURSOR FOR q102_prepare
    LET g_sql= "SELECT COUNT(DISTINCT sth03) FROM sth_file ",
               " WHERE ",tm.wc CLIPPED,
               " AND ",tm.wc2 CLIPPED 
    PREPARE q102_precount FROM g_sql
    DECLARE q102_count CURSOR FOR q102_precount
END FUNCTION
 
FUNCTION q102_b_askkey()
    CONSTRUCT tm.wc2 ON sth01,sth02,sth04,sth05,sth06,sth07
        FROM s_sth[1].sth01,s_sth[1].sth02,s_sth[1].sth04,
             s_sth[1].sth05,s_sth[1].sth06,s_sth[1].sth07
      #ON IDLE g_idle_seconds    #No.TQC-660038 mark
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds   #No.TQC-660038 add
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
#FUN-4B0016
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sth),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q102_q()
    DEFINE l_sth03   LIKE sth_file.sth03,
           l_cnt     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    CALL q102_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       LET l_cnt = 0
       OPEN q102_count
       FETCH q102_count INTO g_row_count
       LET l_cnt = SQLCA.sqlerrd[3]
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q102_cs INTO g_sfb.sth03
        WHEN 'P' FETCH PREVIOUS q102_cs INTO g_sfb.sth03
        WHEN 'F' FETCH FIRST    q102_cs INTO g_sfb.sth03
        WHEN 'L' FETCH LAST     q102_cs INTO g_sfb.sth03
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
            FETCH ABSOLUTE g_jump q102_cs INTO g_sfb.sth03
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sth03,SQLCA.sqlcode,0)
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
	LET g_sfb.ima02 = ' '
        LET g_sfb.sfb05 = ' '
	SELECT sfb05 INTO g_sfb.sfb05  FROM sfb_file WHERE sfb01 = g_sfb.sth03
	SELECT ima02 INTO g_sfb.ima02  FROM ima_file WHERE ima01 = g_sfb.sfb05
 
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
    DISPLAY BY NAME g_sfb.* 
    CALL q102_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-690010 VARCHAR(400)
 
    IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
    LET l_sql =
               "SELECT sth01,sth02,sth04,sth05,sth06,sth07 ",
               "  FROM sth_file ",
               " WHERE sth03 = '", g_sfb.sth03,"'",
               "   AND ",tm.wc2 CLIPPED,
               " ORDER BY sth01,sth02 "
    PREPARE q102_pb FROM l_sql
    DECLARE q102_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q102_pb
    CALL g_sth.clear()
    LET g_cnt = 1
    FOREACH q102_bcs INTO g_sth[g_cnt].*
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
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sth TO s_sth.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0016
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
##
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
