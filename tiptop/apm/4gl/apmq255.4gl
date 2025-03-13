# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: apmq255.4gl
# Descriptions...: 料件分量計價核價資料查詢
# Date & Author..: FUN-A70055 10/07/26 By chenmoyan
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    tm  RECORD
            wc      LIKE type_file.chr1000,
            wc2     LIKE type_file.chr1000 
        END RECORD,
    g_pmj RECORD
            pmj03   LIKE pmj_file.pmj03,
            pmj031  LIKE pmj_file.pmj031,
            pmj032  LIKE pmj_file.pmj032,
            ima44   LIKE ima_file.ima44,
            ima908  LIKE ima_file.ima908,
            pmj12   LIKE pmj_file.pmj12
        END RECORD,
    g_pmi DYNAMIC ARRAY OF RECORD
            pmi01   LIKE pmi_file.pmi01,
            pmi03   LIKE pmi_file.pmi03,
            pmc03   LIKE pmc_file.pmc03,
            pmi02   LIKE pmi_file.pmi02,
            pmi08   LIKE pmi_file.pmi08,
            gec07   LIKE gec_file.gec07,
            pmj04   LIKE pmj_file.pmj04,
            pmj05   LIKE pmj_file.pmj05,
            pmj10   LIKE pmj_file.pmj10,
            pmj06   LIKE pmj_file.pmj06,
            pmj06t  LIKE pmj_file.pmj06t,
            pmj08   LIKE pmj_file.pmj08,
            pmj09   LIKE pmj_file.pmj09,
            pmr03   LIKE pmr_file.pmr03,
            pmr04   LIKE pmr_file.pmr04,
            pmr05   LIKE pmr_file.pmr05,
            pmr05t  LIKE pmr_file.pmr05t
        END RECORD,
    g_argv1         LIKE pmh_file.pmh02,     # INPUT ARGUMENT - 1
    g_sql string,                            #WHERE CONDITION
    g_rec_b LIKE type_file.num5   	     #單身筆數

DEFINE p_row,p_col  LIKE type_file.num5 
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_msg        LIKE ze_file.ze03,  
       l_ac         LIKE type_file.num5 

DEFINE g_row_count  LIKE type_file.num10
DEFINE g_curs_index LIKE type_file.num10
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01 
DEFINE g_cnt_1      LIKE type_file.num10

MAIN
   DEFINE l_time    LIKE type_file.chr8    #計算被使用時間

   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF


 # CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間)
 #       RETURNING l_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   LET p_row = 3 LET p_col = 2

   OPEN WINDOW apmq255_w AT p_row,p_col
        WITH FORM "apm/42f/apmq255"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   LET g_action_choice="query"
   IF cl_chk_act_auth() THEN
      CALL q255_q()
   END IF
   LET g_action_choice=""

   CALL q255_menu()

   CLOSE WINDOW q255_srn               #結束畫面
 # CALL cl_used(g_prog,l_time,2)     #計算使用時間 (退出使間)
 #       RETURNING l_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

FUNCTION q255_cs()
   DEFINE   l_cnt LIKE type_file.num5
   DEFINE
    l_pmh  RECORD
            pmh02   LIKE pmh_file.pmh02,
            pmh22   LIKE pmh_file.pmh22     
           END RECORD

   CLEAR FORM #清除畫面
   CALL g_pmi.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_pmj.* TO NULL    #No.FUN-750051
   LET g_pmj.pmj12='1'
   CONSTRUCT BY NAME tm.wc ON pmj03,pmj12 # 螢幕上取單頭條件
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmj03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_pmj.pmj03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmj03
               NEXT FIELD pmj03
            OTHERWISE
               EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
        CALL cl_qbe_list() RETURNING lc_qbe_sn
        CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF

   #資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET tm.wc = tm.wc clipped," AND pmjuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET tm.wc = tm.wc clipped," AND pmjgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN
      LET tm.wc = tm.wc clipped," AND pmjgrup IN ",cl_chk_tgrup_list()
   END IF

   CALL q255_b_askkey()
   IF INT_FLAG THEN RETURN END IF

   LET g_sql=" SELECT DISTINCT pmj03,pmj031,pmj032,ima44,ima908,pmj12 ",
             " FROM pmi_file,pmr_file,pmj_file,OUTER ima_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND pmj01=pmi01 AND pmj01=pmr01 and pmj02=pmr02 ",
             "   AND ima_file.ima01 = pmj_file.pmj03 "
   PREPARE q255_prepare FROM g_sql
   DECLARE q255_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q255_prepare

   LET g_sql=" SELECT COUNT(DISTINCT '#'||pmj03||'#'||pmj12) ",
             " FROM pmi_file,pmr_file,pmj_file",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND pmj01=pmi01 AND pmj01=pmr01 and pmj02=pmr02 "
   PREPARE q255_count_pre FROM g_sql
   EXECUTE q255_count_pre INTO g_cnt_1
   DISPLAY g_cnt_1 TO FORMONLY.cnt
   
END FUNCTION

FUNCTION q255_b_askkey()
   LET g_pmi[1].gec07 = 'Y'
   CONSTRUCT tm.wc2 ON pmi01,pmi03,pmi02,pmi08,pmj05,pmj10,pmj06,pmj06t,
                       pmj08,pmj09,pmr03,pmr04,pmr05,pmr05t
        FROM s_pmi[1].pmi01,s_pmi[1].pmi03,s_pmi[1].pmi02,
             s_pmi[1].pmi08,s_pmi[1].pmj05,
             s_pmi[1].pmj10,s_pmi[1].pmj06,s_pmi[1].pmj06t,s_pmi[1].pmj08,
             s_pmi[1].pmj09,s_pmi[1].pmr03,s_pmi[1].pmr04,s_pmi[1].pmr05,
             s_pmi[1].pmr05t
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmi01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_pmi[1].pmi01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi01
               NEXT FIELD pmi01
            WHEN INFIELD(pmi03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc1"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_pmi[1].pmi03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi03
               NEXT FIELD pmi03
            WHEN INFIELD(pmi08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_pmi[1].pmi08
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi08
               NEXT FIELD pmi08
            WHEN INFIELD(pmj05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_pmi[1].pmj05
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmj05
               NEXT FIELD pmj05
            OTHERWISE
               EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
      ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION

FUNCTION q255_menu()
   WHILE TRUE
      CALL q255_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q255_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmi),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION q255_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY ' ' TO FORMONLY.cnt
   CALL q255_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q255_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
       LET g_row_count = g_cnt_1
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q255_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q255_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式      #No.FUN-680136 CHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數    #No.FUN-680136 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     q255_cs INTO g_pmj.*
        WHEN 'P' FETCH PREVIOUS q255_cs INTO g_pmj.*
        WHEN 'F' FETCH FIRST    q255_cs INTO g_pmj.*
        WHEN 'L' FETCH LAST     q255_cs INTO g_pmj.*
        WHEN '/'
           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
           LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg CLIPPED,': ' FOR l_abso
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
 
           END PROMPT
           IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
           END IF
           FETCH ABSOLUTE l_abso q255_cs INTO g_pmj.*
    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pmj.pmj03,SQLCA.sqlcode,0)
       INITIALIZE g_pmj.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pmc_file",g_pmj.pmj03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF

    CALL q255_show()
END FUNCTION

FUNCTION q255_show()
   DISPLAY BY NAME g_pmj.*   # 顯示單頭值
   CALL q255_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q255_b_fill()              #BODY FILL UP
   DEFINE l_sql1    LIKE type_file.chr1000,
          l_sql2    LIKE type_file.chr1000

    LET l_sql1 =
        "SELECT DISTINCT pmi01,pmi03,pmc03,pmi02,pmi08,gec07,pmj04,pmj05,pmj10,pmj06,pmj06t,",
        "       pmj08,pmj09,pmr03,pmr04,pmr05,pmr05t ",
        "  FROM pmi_file,pmj_file,pmr_file,OUTER pmc_file,OUTER gec_file",
        " WHERE pmj01=pmi01 AND pmj01=pmr01 and pmj02=pmr02 ",
        "  AND pmj03='",g_pmj.pmj03,"'",
        "  AND pmj12='",g_pmj.pmj12,"'",
        "  AND pmi_file.pmi03=pmc_file.pmc01",
        "  AND pmi_file.pmi08=gec_file.gec01",
        "  AND gec_file.gec011='1'",
        "  AND ",tm.wc2 CLIPPED
    PREPARE q255_pb FROM l_sql1
    DECLARE q255_bcs                       #BODY CURSOR
        CURSOR FOR q255_pb

    CALL g_pmi.clear()

    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q255_bcs INTO g_pmi[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
     #  SELECT pmc03 INTO g_pmi[g_cnt].pmc03
     #    FROM pmc_file WHERE pmc01=g_pmi[g_cnt].pmi03
     #  SELECT gec07 INTO g_pmi[g_cnt].gec07
     #    FROM gec_file WHERE gec01=g_pmi[g_cnt].pmi08
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmi.deleteElement(g_cnt)
    MESSAGE ""

    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION

FUNCTION q255_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmi TO s_pmi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION first
         CALL q255_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 

      ON ACTION previous
         CALL q255_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY
 

      ON ACTION jump
         CALL q255_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL q255_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY
 

      ON ACTION last
         CALL q255_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY

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
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-A70055

