# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amsq600.4gl
# Descriptions...: MPS log 資料查詢(amsq600)
# Date & Author..: 00/12/22 By Mandy
# Modify.........: No.FUN-4B0014 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-670084 06/07/19 By Pengu b_fill() 之sql 應該要加入單身QBE條件(tm.wc2)處理
# Modify.........: No.FUN-680101 06/09/07 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
#
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
        	wc  	LIKE type_file.chr1000, #NO.FUN-680101  VARCHAR(600)  # Head Where condition
                wc2     LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(600)  # Body Where condition
        END RECORD,
    g_mpg01 LIKE mpg_file.mpg01,
    g_mpg_h RECORD 
                mpg01  LIKE mpg_file.mpg01,
                ima02  LIKE ima_file.ima02
            END RECORD,
    g_mpg   DYNAMIC ARRAY OF RECORD
            mpg02   LIKE mpg_file.mpg02,
            mpg03   LIKE mpg_file.mpg03,
            mpg04   LIKE mpg_file.mpg04,
            mpg05   LIKE mpg_file.mpg05,
            mpg06   LIKE mpg_file.mpg06,
            mpg07   LIKE mpg_file.mpg07,
            mpg08   LIKE mpg_file.mpg08,
            mpg09   LIKE mpg_file.mpg09
        END RECORD,
    g_argv1         LIKE pmn_file.pmn01,    # INPUT ARGUMENT - 1
     g_sql          string,                 #WHERE CONDITION      #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5     #NO.FUN-680101  SMALLINT 		  # 單身筆數
 
DEFINE   g_cnt      LIKE type_file.num10    #NO.FUN-680101  INTEGER   
DEFINE   g_msg      LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE   g_jump         LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #NO.FUN-680101  SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0081
DEFINE         l_sl,p_row,p_col	LIKE type_file.num5     #NO.FUN-680101  SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET g_argv1      = ARG_VAL(1)          # 參數值(1) Part#
    LET p_row = 3 LET p_col = 2 
    OPEN WINDOW q600_w AT p_row,p_col
        WITH FORM "ams/42f/amsq600" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN                 # 立刻執行"查詢"功能
#       CALL q600_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q600_q() END IF
    CALL q600_menu()
    CLOSE WINDOW q600_w
      CALL  cl_used(g_prog,g_time,2)       # 計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION q600_cs()                         # QBE 查詢資料
   DEFINE   l_cnt  LIKE type_file.num5     #NO.FUN-680101  SMALLINT 
 
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "mpg01 = '",g_argv1,"'"
      ELSE CLEAR FORM                       # 清除畫面
   CALL g_mpg.clear()
           CALL cl_opmsg('q')
   INITIALIZE g_mpg01 TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON mpg01
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
           IF INT_FLAG THEN RETURN END IF
           CALL q600_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
           IF INT_FLAG THEN RETURN END IF
           MESSAGE ' SEARGHING ' 
    END IF
    IF tm.wc2 = ' 1=1' THEN
        LET g_sql = " SELECT UNIQUE mpg01 ",
                    " FROM  mpg_file ",
                    " WHERE ",tm.wc CLIPPED,
                    " ORDER BY mpg01"
    ELSE
        LET g_sql = " SELECT UNIQUE mpg01 ",
                    " FROM  mpg_file ",
                    " WHERE ",tm.wc  CLIPPED,
                    "   AND ",tm.wc2 CLIPPED,
                    " ORDER BY mpg01"
    END IF  
    PREPARE q600_prepare FROM g_sql
    DECLARE q600_cs                          # SCROLL CURSOR
           SCROLL CURSOR FOR q600_prepare
    #取合乎條件筆數
    IF tm.wc2 = ' 1=1' THEN
         LET g_sql = " SELECT COUNT(UNIQUE mpg01) FROM mpg_file ",
                     "     WHERE ",tm.wc CLIPPED
    ELSE
         LET g_sql = " SELECT COUNT(UNIQUE mpg01) FROM mpg_file ",
                     "     WHERE ",tm.wc CLIPPED, 
                     "       AND ",tm.wc2 CLIPPED
    END IF
    PREPARE q600_pp FROM g_sql
    DECLARE q600_cnt CURSOR FOR q600_pp
END FUNCTION
 
#中文的MENU
 
FUNCTION q600_menu()
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q600_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0014
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mpg),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q600_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q600_cnt
       FETCH q600_cnt INTO g_row_count 
       DISPLAY g_row_count TO cnt  
       CALL q600_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-680101  VARCHAR(1)      #處理方式
    l_abso          LIKE type_file.num10    #NO.FUN-680101  INTEGER      #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q600_cs INTO g_mpg01
        WHEN 'P' FETCH PREVIOUS q600_cs INTO g_mpg01
        WHEN 'F' FETCH FIRST    q600_cs INTO g_mpg01
        WHEN 'L' FETCH LAST     q600_cs INTO g_mpg01
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
            FETCH ABSOLUTE g_jump q600_cs INTO g_mpg01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mpg01,SQLCA.sqlcode,0)
        INITIALIZE g_mpg01 TO NULL  #TQC-6B0105
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
    DECLARE q600_d CURSOR FOR
        SELECT mpg01,ima02
            FROM mpg_file LEFT OUTER JOIN ima_file ON mpg_file.mpg01=ima_file.ima01
              WHERE mpg01 = g_mpg01
    OPEN q600_d
    FETCH q600_d INTO g_mpg_h.mpg01, g_mpg_h.ima02
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mpg01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    CALL q600_show()
END FUNCTION
 
FUNCTION q600_show()
   DISPLAY g_mpg_h.mpg01 TO mpg01 
   DISPLAY g_mpg_h.ima02 TO FORMONLY.ima02 
   CALL q600_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(400)
    LET l_sql = " SELECT mpg02,mpg03,mpg04,mpg05,mpg06,mpg07,mpg08,mpg09 ", 
                "   FROM  mpg_file ",
                "  WHERE mpg01 = '",g_mpg01,"'",
                "  AND ",tm.wc2 CLIPPED,        #No.MOD-670084 add
                " ORDER BY 1,2,3,4 "
    PREPARE q600_pb FROM l_sql
    DECLARE q600_bcs                       #BODY CURSOR
        CURSOR FOR q600_pb
    FOR g_cnt = 1 TO g_mpg.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_mpg[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q600_bcs INTO g_mpg[g_cnt].*
        IF g_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
         
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mpg TO s_mpg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q600_fetch('L')
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
 
 
#FUN-4B0014
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
# 取得單身 construct 條件( tm.wc2 )
FUNCTION q600_b_askkey()
    CONSTRUCT tm.wc2 ON mpg02,mpg03,mpg04,mpg05,mpg06,mpg07,mpg08,mpg09
        FROM s_mpg[1].mpg02,s_mpg[1].mpg03,s_mpg[1].mpg04, 
             s_mpg[1].mpg05,s_mpg[1].mpg06,s_mpg[1].mpg07, 
             s_mpg[1].mpg08,s_mpg[1].mpg09 
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
