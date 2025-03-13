# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmq320.4gl
# Descriptions...: 銀行存款統計資料查詢作業
# Date & Author..: 93/04/12 By Felicity Tseng
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-520113 05/02/22 By Kitty 金額出現**
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
#
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740058 07/04/13 By Judy 匯出EXCEl多一行空白列
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
       	date_sw LIKE type_file.chr1,        #No.FUN-680107
       	wc  	LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(600) # Head Where condition
        END RECORD,
    g_nma02 LIKE nma_file.nma02,
    g_nma10 LIKE nma_file.nma10,
    g_nmp01 LIKE nmp_file.nmp01,
    g_nmp02 LIKE nmp_file.nmp02,
    g_nmp   RECORD LIKE nmp_file.*,
    g_nm   DYNAMIC ARRAY OF RECORD
            nmp03   LIKE nmp_file.nmp03,
            nmp04   LIKE nmp_file.nmp04,
            nmp05   LIKE nmp_file.nmp05,
            nmp06   LIKE nmp_file.nmp06,
            nmp07   LIKE nmp_file.nmp07,
            nmp08   LIKE nmp_file.nmp08,
            nmp09   LIKE nmp_file.nmp09 
        END RECORD,
    g_argv1         LIKE pmn_file.pmn01,       # INPUT ARGUMENT - 1
    g_wc,g_wc2,g_sql STRING,                   #WHERE CONDITION  #No.FUN-580092 HCN 
    g_rec_b         LIKE type_file.num5        # 單身筆數 #No.FUN-680107 SMALLINT
 
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5        #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0082
DEFINE         l_sl		LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET g_argv1      = ARG_VAL(1)          # 參數值(1) Part#
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q320_w AT p_row,p_col
        WITH FORM "anm/42f/anmq320" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN                 # 立刻執行"查詢"功能
#       CALL q320_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q320_q() END IF
    CALL q320_menu()
    CLOSE WINDOW q320_w
      CALL  cl_used(g_prog,g_time,2)       # 計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION q320_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
 
   INITIALIZE tm.* TO NULL       	   # Default condition
   LET tm.date_sw = '1'
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "nmp01 = '",g_argv1,"'"
   ELSE 
      CLEAR FORM                           # 清除畫面
   CALL g_nm.clear()
      CALL cl_opmsg('q')
   INITIALIZE g_nmp01 TO NULL    #No.FUN-750051
   INITIALIZE g_nmp02 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON nmp01, nmp02
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN
         RETURN
      END IF
      INPUT BY NAME tm.date_sw WITHOUT DEFAULTS
      #TQC-860019-add
      ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
      END INPUT
      #TQC-860019-add
      IF INT_FLAG THEN
         RETURN
      END IF
      
    
#     CALL q320_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
#     IF INT_FLAG THEN RETURN END IF
      MESSAGE ' SEARGHING ' 
   END IF
   LET g_sql = " SELECT UNIQUE nmp01, nmp02 ",
               " FROM  nmp_file ",
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY nmp01"
   PREPARE q320_prepare FROM g_sql
   DECLARE q320_cs                          # SCROLL CURSOR
           SCROLL CURSOR FOR q320_prepare
   DROP TABLE x
   SELECT nmp01,nmp02 FROM nmp_file GROUP BY nmp01,nmp02 INTO TEMP x
   LET g_sql = " SELECT COUNT(*)",
               " FROM x ",
               " WHERE ",tm.wc CLIPPED
   PREPARE q320_pp FROM g_sql
   DECLARE q320_cnt CURSOR FOR q320_pp
END FUNCTION
 
#中文的MENU
 
FUNCTION q320_menu()
 
   WHILE TRUE
      CALL q320_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q320_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nm),'','')
            END IF
#        WHEN KEY(CONTROL-N)
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q320_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL q320_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q320_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q320_cnt
       FETCH q320_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt 
       CALL q320_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q320_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式    #No.FUN-680107 VARCHAR(1)
    l_abso          LIKE type_file.num10      #絕對的筆數  #No.FUN-680107 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q320_cs INTO g_nmp01, g_nmp02
        WHEN 'P' FETCH PREVIOUS q320_cs INTO g_nmp01, g_nmp02
        WHEN 'F' FETCH FIRST    q320_cs INTO g_nmp01, g_nmp02
        WHEN 'L' FETCH LAST     q320_cs INTO g_nmp01, g_nmp02
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
            FETCH ABSOLUTE g_jump q320_cs INTO g_nmp01, g_nmp02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmp01,SQLCA.sqlcode,0)
        INITIALIZE g_nmp.* TO NULL  #TQC-6B0105
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
                      # 將foreach到的g_nmp01及g_nmp02的data select出來
    DECLARE q320_d CURSOR FOR
            SELECT nmp01,nmp02,nma02,nma10
              FROM nmp_file LEFT OUTER JOIN nma_file
               ON nmp01 = nma_file.nma01 WHERE nmp01 = g_nmp01
              AND  nmp02 = g_nmp02
    OPEN q320_d
    FETCH q320_d INTO g_nmp.nmp01, g_nmp.nmp02,g_nma02,g_nma10
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmp01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    CALL q320_show()
END FUNCTION
 
FUNCTION q320_show()
   DISPLAY g_nmp.nmp01, g_nma02, g_nma10, g_nmp.nmp02  TO nmp01,exp,nma10,nmp02
     # 顯示單頭值
   CALL q320_b_fill() #單身
    CALL cl_show_fld_cont()               #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q320_b_fill()                    #BODY FILL UP
   DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
 
    IF tm.date_sw = '2'
      THEN LET l_sql = " SELECT nmp03,nmp14,nmp15,nmp16,nmp17,nmp18,nmp19"
      ELSE LET l_sql = " SELECT nmp03,nmp04,nmp05,nmp06,nmp07,nmp08,nmp09"
    END IF
      LET l_sql = l_sql CLIPPED,
                  " FROM  nmp_file ",
                  " WHERE nmp01 = '",g_nmp01,"'",
                  " AND   nmp02 = ",g_nmp02,
                  " ORDER BY nmp03 "
    PREPARE q320_pb FROM l_sql
    DECLARE q320_bcs                       #BODY CURSOR
        CURSOR FOR q320_pb
    FOR g_cnt = 1 TO g_nm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nm[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q320_bcs INTO g_nm[g_cnt].*
       IF g_cnt=1 THEN
          LET g_rec_b=SQLCA.SQLERRD[3]
       END IF
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
    CALL g_nm.deleteElement(g_cnt)  #TQC-740058
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nm TO s_nmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q320_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q320_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q320_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q320_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q320_fetch('L')
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
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
 
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
