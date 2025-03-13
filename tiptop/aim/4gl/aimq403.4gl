# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimq403.4gl
# Descriptions...: 料件庫存成本查詢
# Date & Author..: 92/05/19 By Wu
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm           RECORD
                  wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)
                  wc2   LIKE type_file.chr1000 # Body Where condition  #No.FUN-690026 VARCHAR(500)
                 END RECORD,
    g_ima        RECORD
                  ima01  LIKE ima_file.ima01,
                  ima02  LIKE ima_file.ima02,
                  ima021 LIKE ima_file.ima021,
                  ima05  LIKE ima_file.ima05,
                  ima06  LIKE ima_file.ima06,
                  ima07  LIKE ima_file.ima07,
                  ima08  LIKE ima_file.ima08
                 #ima86  LIKE ima_file.ima86  #FUN-560183
                END RECORD,
    g_img       DYNAMIC ARRAY OF RECORD
                  img02   LIKE img_file.img02,
                  img03   LIKE img_file.img03,
                  img04   LIKE img_file.img04,
                  img10   LIKE img_file.img10,
                  img09   LIKE img_file.img09,
                  img34   LIKE img_file.img34,
                  cost    LIKE imb_file.imb118, #MOD-530179
                  img19   LIKE img_file.img19,
                  img36   LIKE img_file.img36
                END RECORD,
    g_argv1     LIKE ima_file.ima01,    # INPUT ARGUMENT - 1
    g_unit      LIKE imb_file.imb118,   # 單位成本 #MOD-530179
    g_u         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_sql       string,                 #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b     LIKE type_file.num5     #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01    #No.FUN-580031  HCN
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5      #No.FUN-690026 SMALLINT
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW aimq403_w AT p_row,p_col
         WITH FORM "aim/42f/aimq403"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q403_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q403_q() END IF
    CALL q403_menu()
    CLOSE WINDOW q403_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q403_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' ' AND g_argv1 IS NOT NULL
      THEN LET tm.wc = "ima01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_img.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           INITIALIZE g_ima.* TO NULL   #FUN-640213  add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
           CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima021 # 螢幕上取單頭條件
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_ima.ima01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         OTHERWISE
            EXIT CASE
       END CASE
    #FUN-530065
 
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
           IF INT_FLAG THEN RETURN END IF
           LET g_u = '1'
           DISPLAY g_u TO FORMONLY.u
           INPUT g_u WITHOUT DEFAULTS FROM u
			 AFTER FIELD u
			 IF g_u IS NULL OR g_u = ' ' OR g_u NOT MATCHES'[123]'
				THEN NEXT FIELD u
			 END IF
		      ON IDLE g_idle_seconds
		         CALL cl_on_idle()
		         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		
		   END INPUT
           CALL q403_b_askkey()             # 螢幕上取單身條件
           IF INT_FLAG THEN RETURN END IF
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
 
   #BugNo:4490
   LET g_sql=" SELECT DISTINCT ima_file.ima01 FROM ima_file,img_file ", #FUN-560183 加 DISTINCT
             " WHERE ",tm.wc  CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND ima01  = img01 ",
             "   AND img10 != 0 "
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q403_prepare FROM g_sql
   DECLARE q403_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q403_prepare
 
   # 取合乎條件筆數
   LET g_sql=" SELECT COUNT(DISTINCT ima01) FROM ima_file,img_file ", #FUN-560183 加 DISTINCT
             " WHERE ",tm.wc  CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND ima01  = img01 ",
             "   AND img10 != 0 "
   PREPARE q403_pp  FROM g_sql
   DECLARE q403_count   CURSOR FOR q403_pp
END FUNCTION
 
FUNCTION q403_b_askkey()
   CONSTRUCT tm.wc2 ON img02 FROM s_img[1].img02
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
 
FUNCTION q403_menu()
 
   WHILE TRUE
      CALL q403_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q403_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q403_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q403_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q403_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q403_count
       FETCH q403_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q403_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q403_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q403_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q403_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q403_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q403_cs INTO g_ima.ima01
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
            FETCH ABSOLUTE g_jump q403_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
	SELECT ima01, ima02, ima021, ima05, ima06, ima07, ima08  #, ima86 #FUN-560183
	  INTO g_ima.*
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q403_show()
END FUNCTION
 
FUNCTION q403_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO FORMONLY.u
   END IF
 
   CALL s_cost(g_u,g_ima.ima08,g_ima.ima01) RETURNING g_unit
   IF g_unit IS NULL OR g_unit = ' ' THEN LET g_unit = 0 END IF
   DISPLAY g_unit TO FORMONLY.unit
   CALL q403_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q403_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   LET l_sql =
        " SELECT img02, img03, img04, img10, img09, img34, 0, img19, img36 ",
        " FROM  img_file",
        " WHERE img01 = '",g_ima.ima01,"' AND ", tm.wc2 CLIPPED,
        "   AND img10 !=0 ",
        " ORDER BY img02, img03 "
    PREPARE q403_pb FROM l_sql
    DECLARE q403_bcs                       #BODY CURSOR
        CURSOR FOR q403_pb
 
    FOR g_cnt = 1 TO g_img.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_img[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q403_bcs INTO g_img[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
		IF g_img[g_cnt].img10 IS NULL THEN
		   LET g_img[g_cnt].img10 = 0
	    END IF
		IF g_img[g_cnt].img34 IS NULL THEN
		   LET g_img[g_cnt].img34 = 0
	    END IF
	#庫存成本
        #FUN-560183................begin
        LET g_img[g_cnt].img34 = 1
        {
        #---98/10/13 modify
        CALL s_umfchk(g_ima.ima01,g_img[g_cnt].img09,g_ima.ima86)
             RETURNING g_i,g_img[g_cnt].img34
        IF g_i = 1 THEN
           CALL cl_err('','mfg3075',0)
           LET g_img[g_cnt].img34 = 1
        END IF
        }
        #--------
        #FUN-560183................end
	LET g_img[g_cnt].cost = g_img[g_cnt].img10 * g_unit *
				g_img[g_cnt].img34
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_img_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
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
         CALL q403_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q403_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q403_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q403_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q403_fetch('L')
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
#      LET l_ac = ARR_CURR()
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
