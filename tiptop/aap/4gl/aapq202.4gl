# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aapq202.4gl
# Descriptions...: 部門專案編號查詢
# Date & Author..: 96/11/19 By Star
#                  By Melody    select npq04 應加入帳別的判斷
# Modify.........: 97/04/17 By Danny (將npq_file改成npp_file,npq_file)
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0104 06/11/21 By Rayven 匯出EXCEL匯出的值多出一空白行
#                                                   查詢出全部數據，"指定筆"下筆""末一筆"按鈕都無法使用
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690028 VARCHAR(600)
        	wc2  	LIKE type_file.chr1000		# Body Where condition  #No.FUN-690028 VARCHAR(600)
        END RECORD,
    l_gem  RECORD
            gem01   LIKE gem_file.gem01,
            gem02   LIKE gem_file.gem02
        END RECORD,
    g_npq DYNAMIC ARRAY OF RECORD
            npq08   LIKE npq_file.npq08,
            npp03   LIKE npp_file.npp03,
            npq03   LIKE npq_file.npq03,
            nppglno LIKE npp_file.nppglno,
            npq07f  LIKE npq_file.npq07f,
            npq06   LIKE npq_file.npq06,
            npq99   LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
        END RECORD,
    g_argv2     LIKE npq_file.npq05,        # INPUT ARGUMENT - 2
     g_wc,g_wc2,g_sql,g_sql1  string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,  		  #單身筆數  #No.FUN-690028 SMALLINT
    l_bal           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
MAIN
   DEFINE l_time	LIKE type_file.chr8,   		#計算被使用時間  #No.FUN-690028 VARCHAR(8)
          l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
    LET l_bal=0
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q202_srn AT p_row,p_col
        WITH FORM "aap/42f/aapq202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q202_q()
#    END IF
    CALL q202_menu()
    CLOSE WINDOW q202_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
 
#QBE 查詢資料
FUNCTION q202_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    CLEAR FORM #清除畫面
   CALL g_npq.clear()
    CALL cl_opmsg('q')
#    INITIALIZE tm.* TO NULL			# Default condition
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE l_gem.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON gem01,gem02
       ON ACTION CONTROLP
           CASE WHEN INFIELD(gem01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO gem01
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
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND gemuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND gemgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND gemgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gemuser', 'gemgrup')
   #End:FUN-980030
 
   CONSTRUCT tm.wc2 ON npq08,npp03,npq03
     FROM s_npq[1].npq08,s_npq[1].npp03,s_npq[1].npq03
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
   IF tm.wc2 = " 1=1" THEN            # 若單身未輸入條件
      LET g_sql = "SELECT UNIQUE gem01, gem02  FROM gem_file ",
                  " WHERE ", tm.wc CLIPPED,
                  " ORDER BY 2"
   ELSE                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE gem01, gem02",
                  "  FROM gem_file, npp_file, npq_file ",
                  " WHERE npq05 = gem01",
                  "   AND nppsys = 'AP' ",
                  "   AND nppsys= npqsys",
                  "   AND npp01 = npq01 ",
                  "   AND npp00 = npq00 ",
                  "   AND npp011= npq011",
                  "   AND ", tm.wc CLIPPED, " AND ",tm.wc2 CLIPPED,
                  " ORDER BY 2"
   END IF
 
   PREPARE q202_prepare FROM g_sql
   DECLARE q202_cs                         #SCROLL CURSOR
    SCROLL CURSOR WITH HOLD FOR q202_prepare
 
   IF tm.wc2 = " 1=1" THEN            # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM gem_file WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT gem01) FROM gem_file,npq_file WHERE ",
                "npq05=gem01 AND nppsys= 'AP' AND npp01 = npq01 ",
                "   AND nppsys= npqsys",
                "   AND npp00 = npq00 ",
                "   AND npp011= npq011",
                " AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED
   END IF
    IF INT_FLAG THEN RETURN END IF
 
   PREPARE q202_precount FROM g_sql
   DECLARE q202_count CURSOR FOR q202_precount
 
 
 
END FUNCTION
 
FUNCTION q202_b_askkey()
   LET l_bal =0
#  DISPLAY "[        ]" AT 9,1
END FUNCTION
 
#中文的MENU
FUNCTION q202_menu()
 
   WHILE TRUE
      CALL q202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q202_q()
            END IF
#No.TQC-6B0104 --start-- mark
#        WHEN "first"
#           CALL q202_fetch('F')
#        WHEN "previous"
#           CALL q202_fetch('P')
#        WHEN "jump"
#           CALL q202_fetch('/')
#        WHEN "next"
#           CALL q202_fetch('N')
#        WHEN "last"
#           CALL q202_fetch('L')
#No.TQC-6B0104 --end--
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_npq),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q202_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q202_count
        FETCH q202_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q202_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
    LET l_bal=0
    CASE p_flag
       WHEN 'N' FETCH NEXT     q202_cs INTO l_gem.gem01,l_gem.gem02
       WHEN 'P' FETCH PREVIOUS q202_cs INTO l_gem.gem01,l_gem.gem02
       WHEN 'F' FETCH FIRST    q202_cs INTO l_gem.gem01,l_gem.gem02
       WHEN 'L' FETCH LAST     q202_cs INTO l_gem.gem01,l_gem.gem02
       WHEN '/'
             IF NOT mi_no_ask THEN
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
             FETCH ABSOLUTE g_jump q202_cs INTO l_gem.gem01,l_gem.gem02
             LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_gem.gem01,SQLCA.sqlcode,0)
        INITIALIZE l_gem.* TO NULL  #TQC-6B0105
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
 
    CALL q202_show()
END FUNCTION
 
FUNCTION q202_show()
   DISPLAY BY NAME l_gem.gem01,l_gem.gem02
   CALL q202_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q202_b_fill()              #BODY FILL UP
   DEFINE
         l_sql     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
 
   LET l_sql =
        "SELECT npq08,npp03,npq03,nppglno,npq07f,npq06,0",
        "  FROM npp_file,npq_file ",
        " WHERE npq05  = '",l_gem.gem01,"' ",
        "   AND npp01 = npq01 ",
        "   AND nppsys= npqsys",
        "   AND npp00 = npq00 ",
        "   AND npp011= npq011",
        "   AND nppsys= 'AP' ",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY 1 "
 
    PREPARE q202_pb FROM l_sql
    DECLARE q202_bcs                       #BODY CURSOR
        CURSOR FOR q202_pb
 
    FOR g_cnt = 1 TO g_npq.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_npq[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    LET l_bal = 0
    FOREACH q202_bcs INTO g_npq[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_npq[g_cnt].npq06 = '1' THEN
           LET l_bal = l_bal + g_npq[g_cnt].npq07f
        ELSE
           LET l_bal = l_bal - g_npq[g_cnt].npq07f
        END IF
        LET g_npq[g_cnt].npq99 = l_bal
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_npq.deleteElement(g_cnt)  #No.TQC-6B0104
 
    LET g_rec_b = g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTES(COUNT=g_npq.getLength(),UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()              #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
#        LET g_action_choice="first"   #No.TQC-6B0104 mark 
         CALL q202_fetch('F')          #No.TQC-6B0104
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#        EXIT DISPLAY                    #No.TQC-6B0104 mark
      ON ACTION previous
#        LET g_action_choice="previous"  #No.TQC-6B0104 mark
         CALL q202_fetch('P')            #No.TQC-6B0104
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#        EXIT DISPLAY                    #No.TQC-6B0104 mark
      ON ACTION jump
#        LET g_action_choice="jump"      #No.TQC-6B0104 mark
         CALL q202_fetch('/')            #No.TQC-6B0104
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#        EXIT DISPLAY                    #No.TQC-6B0104 mark
      ON ACTION next
#        LET g_action_choice="next"      #No.TQC-6B0104 mark
         CALL q202_fetch('N')            #No.TQC-6B0104
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#        EXIT DISPLAY                    #No.TQC-6B0104 mark
      ON ACTION last
#        LET g_action_choice="last"      #No.TQC-6B0104 mark 
         CALL q202_fetch('L')            #No.TQC-6B0104
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#        EXIT DISPLAY                    #No.TQC-6B0104 mark
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
 
 
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
        #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.MOD-530853  --end
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
