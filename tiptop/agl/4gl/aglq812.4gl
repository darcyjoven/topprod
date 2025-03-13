# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq812.4gl
# Descriptions...: 立沖帳餘額查詢
# Date & Author..: 00/05/09 By Sophia
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-5C0015 06/01/03 By kevin 單頭增加欄位abi31~abi36
#                  (abi11~14, abi31~36)共10組依參數aaz88的設定顯示組數。
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By Lynn 會計科目加帳套-財務 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: No:FUN-B50105 11/05/26 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B40026 11/06/14 By zhangweib 除去abi31~31的操作

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
      	wc  	 LIKE type_file.chr1000# Head Where condition   #No.FUN-680098  VARCHAR(600)
        END RECORD,
    g_bi  RECORD
          abi00	        LIKE abi_file.abi00,         #No.FUN-740020
          abi05	        LIKE abi_file.abi05,
          abi01	        LIKE abi_file.abi01,
          abi02	        LIKE abi_file.abi02,
          abi06	        LIKE abi_file.abi06,
          abi07	        LIKE abi_file.abi07,
          abi03	        LIKE abi_file.abi03,
          abi11	        LIKE abi_file.abi11,
          abi12	        LIKE abi_file.abi12,
          abi13	        LIKE abi_file.abi13,
          abi14	        LIKE abi_file.abi14
        END RECORD,
    g_abi DYNAMIC ARRAY OF RECORD
            seq     LIKE type_file.chr1000,  #No.FUN-680098   VARCHAR(4)
            abi08   LIKE abi_file.abi08,
            abi09   LIKE abi_file.abi09
        END RECORD,
    g_abi00     LIKE abi_file.abi00,
    g_argv1     LIKE abi_file.abi00,      # INPUT ARGUMENT - 1
    g_bookno    LIKE aaa_file.aaa01,      #帳別  #No.FUN-670039
    g_wc,g_sql STRING,                    #WHERE CONDITION  #No.FUN-580092 HCN    
    g_rec_b LIKE type_file.num5,          #單身筆數        #No.FUN-680098  smallint
    g_aag02 LIKE aag_file.aag02,
    g_aag06 LIKE aag_file.aag06
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_no_ask       LIKE type_file.num5         #No.FUN-680098 smallint

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW q812_w WITH FORM "agl/42f/aglq812"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL q812_show_field()  # FUN-5C0015 add
 
    CALL s_shwact(0,0,g_bookno)
 
    CALL q812_menu()
    CLOSE WINDOW q812_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION q812_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 smallint
 
   CLEAR FORM #清除畫面
   CALL g_abi.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
   # No.FUN-5C0015 mod (s)
   #CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
   #          abi05,abi01,abi02,abi06,abi07,abi11,abi12,abi13,abi14,abi03
   INITIALIZE g_bi.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             abi00,abi05,abi01,abi02,abi06,abi07,abi11,abi12,abi13,abi14,      #No.FUN-740020
            #abi31,abi32,abi33,abi34,abi35,abi36,     #FUN-B40026  Mark
             abi03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
   # No.FUN-5C0015 mod (e)
   #No.FUN-740020  ---Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(abi00)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aaa"
               CALL cl_create_qry()RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO abi00
               NEXT FIELD abi00
    #No.FUN-B50051--str--
            WHEN INFIELD(abi05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO abi05
                   NEXT FIELD abi05
    #No.FUN-B50051--end--

         OTHERWISE EXIT CASE
      END CASE
   #No.FUN-740020  ---end
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
   LET g_sql=" SELECT UNIQUE abi00,abi05,abi01,abi02,abi06,abi07,",
             " abi03,abi11,abi12,abi13,abi14 ",
            #",abi31,abi32,abi33,abi34,abi35,abi36 ", # No.FUN-5C0015 add  #FUN-B40026   Mark
             " FROM abi_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY abi05,abi01,abi02 "
   PREPARE q812_prepare FROM g_sql
   DECLARE q812_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q812_prepare
   # 取合乎條件筆數
   DROP TABLE x
   LET g_sql=" SELECT UNIQUE abi00,abi05,abi01,abi02,abi06,abi07,",
             " abi03,abi11,abi12,abi13,abi14 ",     #
            #",abi31,abi32,abi33,abi34,abi35,abi36 ", # No.FUN-5C0015 add  #FUN-B40026   Mark
             " FROM abi_file ",
             "  WHERE ",tm.wc CLIPPED,
             "   INTO TEMP x"
   PREPARE q812_prepare_pre FROM g_sql
   EXECUTE q812_prepare_pre
   DECLARE q812_count CURSOR FOR
    SELECT COUNT(*) FROM x
 
END FUNCTION
 
FUNCTION q812_menu()
 
   WHILE TRUE
      CALL q812_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q812_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abi),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q812_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q812_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q812_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
    OPEN q812_count
    FETCH q812_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    CALL q812_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q812_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q812_cs INTO g_bi.abi00,g_bi.abi05,g_bi.abi01,           #No.FUN-740020
                                             g_bi.abi02,g_bi.abi06,
                                             g_bi.abi07,g_bi.abi03,
                                             g_bi.abi11,g_bi.abi12,
                                             g_bi.abi13,g_bi.abi14
#FUN-B40026   ---start   Mark
#                                            # No.FUN-5C0015 add (s)
#                                           ,g_bi.abi31,g_bi.abi32,
#                                            g_bi.abi33,g_bi.abi34,
#                                            g_bi.abi35,g_bi.abi36
#                                            # No.FUN-5C0015 add (e)
#FUN-B40026   ---end     Mark
        WHEN 'P' FETCH PREVIOUS q812_cs INTO g_bi.abi00,g_bi.abi05,g_bi.abi01,         #No.FUN-740020
                                             g_bi.abi02,g_bi.abi06,
                                             g_bi.abi07,g_bi.abi03,
                                             g_bi.abi11,g_bi.abi12,
                                             g_bi.abi13,g_bi.abi14
#FUN-B40026   ---start   Mark
#                                            # No.FUN-5C0015 add (s)
#                                           ,g_bi.abi31,g_bi.abi32,
#                                            g_bi.abi33,g_bi.abi34,
#                                            g_bi.abi35,g_bi.abi36
#                                            # No.FUN-5C0015 add (e)
#FUN-B40026   ---end     Mark
        WHEN 'F' FETCH FIRST    q812_cs INTO g_bi.abi00,g_bi.abi05,g_bi.abi01,       #No.FUN-740020
                                             g_bi.abi02,g_bi.abi06,
                                             g_bi.abi07,g_bi.abi03,
                                             g_bi.abi11,g_bi.abi12,
                                             g_bi.abi13,g_bi.abi14
#FUN-B40026   ---start   Mark
#                                            # No.FUN-5C0015 add (s)
#                                           ,g_bi.abi31,g_bi.abi32,
#                                            g_bi.abi33,g_bi.abi34,
#                                            g_bi.abi35,g_bi.abi36
#                                            # No.FUN-5C0015 add (e)
#FUN-B40026   ---end     Mark
        WHEN 'L' FETCH LAST     q812_cs INTO g_bi.abi00,g_bi.abi05,g_bi.abi01,                  #No.FUN-740020
                                             g_bi.abi02,g_bi.abi06,
                                             g_bi.abi07,g_bi.abi03,
                                             g_bi.abi11,g_bi.abi12,
                                             g_bi.abi13,g_bi.abi14
#FUN-B40026   ---start   Mark
#                                            # No.FUN-5C0015 add (s)
#                                           ,g_bi.abi31,g_bi.abi32,
#                                            g_bi.abi33,g_bi.abi34,
#                                            g_bi.abi35,g_bi.abi36
#                                            # No.FUN-5C0015 add (e)
#FUN-B40026   ---end     Mark
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q812_cs INTO g_bi.abi00,g_bi.abi05,g_bi.abi01,       #No.FUN-740020
                                                g_bi.abi02,g_bi.abi06,
                                                g_bi.abi07,g_bi.abi03,
                                                g_bi.abi11,g_bi.abi12,
                                                g_bi.abi13,g_bi.abi14
#FUN-B40026   ---start   Mark
#                                               # No.FUN-5C0015 add (s)
#                                              ,g_bi.abi31,g_bi.abi32,
#                                               g_bi.abi33,g_bi.abi34,
#                                               g_bi.abi35,g_bi.abi36
#                                               # No.FUN-5C0015 add (e)
#FUN-B40026   ---end     Mark
 
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bi.abi01,SQLCA.sqlcode,0)
        INITIALIZE g_bi.* TO NULL  #TQC-6B0105
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
 
    CALL q812_show()
END FUNCTION
 
FUNCTION q812_show()
   DISPLAY BY NAME g_bi.abi00,g_bi.abi05,g_bi.abi01,g_bi.abi02,g_bi.abi06,
                   g_bi.abi07,g_bi.abi11,g_bi.abi12,g_bi.abi13,
                   g_bi.abi14,g_bi.abi03
#FUN-B40026   ---start   Mark
#                  # No.FUN-5C0015 add (s)
#                 ,g_bi.abi31,g_bi.abi32,g_bi.abi33,g_bi.abi34,
#                  g_bi.abi35,g_bi.abi36
#                  # No.FUN-5C0015 add (e)
#FUN_B40026   ---start   Mark
   CALL q812_abi07('d')
   CALL q812_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q812_abi07(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1) 
           l_gem02 LIKE gem_file.gem02
 
    LET g_errno = ' '
    IF g_bi.abi07 IS NULL THEN
        LET l_gem02=NULL
    ELSE
        SELECT gem02 INTO l_gem02
           FROM gem_file WHERE gem01 = g_bi.abi07  AND gemacti='Y'
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_gem02 = NULL
        END IF
    END IF
    SELECT aag02,aag06
      INTO g_aag02,g_aag06
      FROM aag_file WHERE aag01 = g_bi.abi05 AND aagacti = 'Y'
                                             AND aag00 = g_bi.abi00                     #No.FUN-740020
    IF SQLCA.sqlcode THEN
       LET g_errno = 'agl-001'
       LET g_aag02 = NULL
       LET g_aag06 = NULL
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_gem02 TO  gem02
       DISPLAY g_aag02 TO  aag02
    END IF
END FUNCTION
 
FUNCTION q812_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,     #No.FUN-680098  VARCHAR(1000) 
          l_n       LIKE type_file.num5,        #No.FUN-680098  smallint
          l_tot     LIKE type_file.num10        #No.FUN-680098  integer
 
   LET l_sql =
        "SELECT '',abi08, abi09",
        " FROM  abi_file",
        " WHERE abi00 = '",g_bi.abi00,"'" ,
        " AND abi01 = '",g_bi.abi01,"'" ,
        " AND abi02 = '",g_bi.abi02,"'",
        " AND abi03 = ",g_bi.abi03,"",
        " AND abi04 =?"
    PREPARE q812_pb FROM l_sql
    DECLARE q812_bcs                       #BODY CURSOR
        CURSOR FOR q812_pb
 
    FOR g_cnt = 1 TO g_abi.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_abi[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 0
    LET l_tot = 0
    IF g_aag06 = '1' THEN
       LET l_n = 1
    ELSE
       LET l_n = -1
    END IF
 
    FOR g_cnt = 0 TO 13
        LET g_abi[g_cnt+1].seq = g_cnt
	LET g_i = g_cnt - 1
	OPEN q812_bcs USING g_cnt
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
	FETCH q812_bcs INTO g_abi[g_cnt+1].*
	  IF SQLCA.sqlcode = 100 THEN
	     LET g_abi[g_cnt+1].abi08 = 0
	     LET g_abi[g_cnt+1].abi09 = 0
	     CONTINUE FOR
	  END IF
        LET g_abi[g_cnt+1].seq = g_cnt
    END FOR
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q812_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abi TO s_abi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q812_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q812_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q812_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q812_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q812_fetch('L')
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
 
#FUN-5C0015 BY kevin (s)
FUNCTION  q812_show_field()
#依參數決定異動碼的多寡
 
 DEFINE l_field  STRING
 
#FUN-B50105   ---start   Mark
#IF g_aaz.aaz88 = 10 THEN
#RETURN
#END IF
#
#IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "abi11,abi12,abi13,abi14,abi31,abi32,abi33,abi34,",
#                   "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "abi12,abi13,abi14,abi31,abi32,abi33,abi34,",
#                   "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "abi13,abi14,abi31,abi32,abi33,abi34,",
#                   "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "abi14,abi31,abi32,abi33,abi34,",
#                   "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "abi31,abi32,abi33,abi34,",
#                   "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "abi32,abi33,abi34,",
#                   "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "abi33,abi34,abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "abi34,abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "abi35,abi36"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "abi36"
# END IF
#FUN-B50105   ---end     Mark

#FUN-B50105   ---start   Add
  IF g_aaz.aaz88 = 0 THEN
     LET l_field = "abi11,abi12,abi13,abi14"
  END IF
  IF g_aaz.aaz88 = 1 THEN
     LET l_field = "abi12,abi13,abi14"
  END IF
  IF g_aaz.aaz88 = 2 THEN
     LET l_field = "abi13,abi14"
  END IF
  IF g_aaz.aaz88 = 3 THEN
     LET l_field = "abi14"
  END IF
  IF g_aaz.aaz88 = 4 THEN
     LET l_field = ""
  END IF
#FUN-B40026   --start   Mark
# IF NOT cl_null(l_field) THEN
#    LET l_field = l_field,","
# END IF
# IF g_aaz.aaz125 = 5 THEN
#    LET l_field = l_field,"abi32,abi33,abi34,abi35,abi36"
# END IF
# IF g_aaz.aaz125 = 6 THEN
#    LET l_field = l_field,"abi33,abi34,abi35,abi36"
# END IF
# IF g_aaz.aaz125 = 7 THEN
#    LET l_field = l_field,"abi34,abi35,abi36"
# END IF
# IF g_aaz.aaz125 = 8 THEN
#    LET l_field = l_field,"abi35,abi36"
# END IF
#FUN-B40026   ---end      Mark
#FUN-B50105   ---end     Add
 
  CALL cl_set_comp_visible(l_field,FALSE)
 
END FUNCTION
 
#FUN-5C0015 BY kevin (e)
 
 
#Patch....NO.TQC-610035 <> #
