# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglq0002.4gl
# Descriptions...: 合并個體異動碼5~異動碼8會計科目余額查詢作業
# Date & Author..: 10/09/19 FUN-A90028 BY chenmoyan 
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-BA0111 12/04/17 By Belle 將總帳的異動碼科餘1~4碼也納入合併資料

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE tm       RECORD
                 wc       STRING                  # Head Where condition
                END RECORD,
       g_aem1  RECORD
                 aem01   LIKE aem_file.aem01,
                 aem02   LIKE aem_file.aem02,
                 aem09   LIKE aem_file.aem09,
                 aem04   LIKE aem_file.aem04,
                 aem00   LIKE aem_file.aem00,
                 aem03   LIKE aem_file.aem03,
                 aem15   LIKE aem_file.aem15,
                 aem05   LIKE aem_file.aem05,
                 aem06   LIKE aem_file.aem06,
                 aem07   LIKE aem_file.aem07,
                 aem08   LIKE aem_file.aem08
                ,aem16   LIKE aem_file.aem16      #FUN-BA0111 add
                ,aem17   LIKE aem_file.aem17      #FUN-BA0111 add
                ,aem18   LIKE aem_file.aem18      #FUN-BA0111 add
                ,aem19   LIKE aem_file.aem19      #FUN-BA0111 add
                END RECORD,
       g_aem   DYNAMIC ARRAY OF RECORD
                 aem10   LIKE aem_file.aem10,
                 aem11   LIKE aem_file.aem11,
                 aem12   LIKE aem_file.aem12,
                 amt     LIKE type_file.num20_6,    #FUN-AB0028
                 aem13   LIKE aem_file.aem13,
                 aem14   LIKE aem_file.aem14
                END RECORD,
       g_argv1            LIKE aem_file.aem01,
       g_argv2            LIKE aem_file.aem00,
       g_argv3            LIKE aem_file.aem02,
       g_argv4            LIKE aem_file.aem03,
       g_argv5            LIKE aem_file.aem04,
       g_wc,g_sql         STRING,                 #WHERE CONDITION
       p_row,p_col        LIKE type_file.num5,
       g_rec_b            LIKE type_file.num5     #單身筆數
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_msg              LIKE ze_file.ze03
DEFINE g_row_count        LIKE type_file.num10
DEFINE g_curs_index       LIKE type_file.num10
DEFINE g_jump             LIKE type_file.num10
DEFINE mi_no_ask          LIKE type_file.num5
DEFINE g_flag             LIKE type_file.chr1
DEFINE g_dbs_axz03        LIKE type_file.chr21   
MAIN
      DEFINE l_sl         LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)
   LET g_argv5 = ARG_VAL(5)

   LET p_row = 1 LET p_col = 1
   OPEN WINDOW q0002_w AT p_row,p_col WITH FORM "agl/42f/aglq0002"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN CALL  q0002_q() END IF
   CALL q0002_menu()
   CLOSE FORM q0002_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q0002_cs()
   DEFINE l_cnt LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_aem.clear()
   IF cl_null(g_argv1) THEN
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")

      INITIALIZE g_aem1.* TO NULL
      # 螢幕上取單頭條件
      CONSTRUCT BY NAME tm.wc ON
         aem01,aem02,aem09,aem04,aem00,aem03,aem15,aem05,aem06,aem07,aem08
        ,aem16,aem17,aem18,aem19      #FUN-BA0111
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aem01) #族群編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_axa"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aem01
                    NEXT FIELD aem01
               WHEN INFIELD(aem04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_aag"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aem04
               WHEN INFIELD(aem15) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_aem1.aem15
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aem15
                    NEXT FIELD aem15
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
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   ELSE
      LET tm.wc = " aem01 = '",g_argv1,"' AND aem00 = '",g_argv2,"'",
                  " AND aem02 = '",g_argv3,"' AND aem03 = '",g_argv4,"'",
                  " AND aem04 = '",g_argv5,"' "
      IF NOT cl_null(g_argv1) THEN
         INITIALIZE g_argv1 TO NULL
         INITIALIZE g_argv2 TO NULL
         INITIALIZE g_argv3 TO NULL
         INITIALIZE g_argv4 TO NULL
         INITIALIZE g_argv5 TO NULL
      END IF
   END IF

   LET g_sql=
       "SELECT UNIQUE aem01,aem02,aem09,aem04,aem00,aem03,aem15,",
       "              aem05,aem06,aem07,aem08",
       "             ,aem16,aem17,aem18,aem19",        #FUN-BA0111
       "  FROM aem_file ",
       " WHERE ",tm.wc CLIPPED
   PREPARE q0002_prepare FROM g_sql
   DECLARE q0002_cs SCROLL CURSOR WITH HOLD FOR q0002_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE aem01,aem02,aem09,aem04,aem00,aem03,aem15",
       "              aem05,aem06,aem07,aem08",
       "             ,aem16,aem17,aem18,aem19",        #FUN-BA0111
       "  FROM aem_file ",
       " WHERE ",tm.wc CLIPPED,
       "  INTO TEMP x"
   PREPARE q0002_prepare_pre FROM g_sql
   EXECUTE q0002_prepare_pre
   DECLARE q0002_count CURSOR FOR
   SELECT COUNT(*) FROM x
END FUNCTION

FUNCTION q0002_menu()
   WHILE TRUE
      CALL q0002_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q0002_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aem),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q0002_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aem.clear()
   CALL q0002_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q0002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q0002_count
      FETCH q0002_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q0002_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q0002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     q0002_cs INTO g_aem1.aem01,g_aem1.aem02,
                                             g_aem1.aem09,g_aem1.aem04,
                                             g_aem1.aem00,g_aem1.aem03,
                                             g_aem1.aem15,g_aem1.aem05,
                                             g_aem1.aem06,g_aem1.aem07,
                                             g_aem1.aem08
                                            ,g_aem1.aem16,g_aem1.aem17    #FUN-BA0111 add
                                            ,g_aem1.aem18,g_aem1.aem19    #FUN-BA0111 add
       WHEN 'P' FETCH PREVIOUS q0002_cs INTO g_aem1.aem01,g_aem1.aem02,
                                             g_aem1.aem09,g_aem1.aem04,
                                             g_aem1.aem00,g_aem1.aem03,
                                             g_aem1.aem15,g_aem1.aem05,
                                             g_aem1.aem06,g_aem1.aem07,
                                             g_aem1.aem08
                                            ,g_aem1.aem16,g_aem1.aem17    #FUN-BA0111 add
                                            ,g_aem1.aem18,g_aem1.aem19    #FUN-BA0111 add
       WHEN 'F' FETCH FIRST    q0002_cs INTO g_aem1.aem01,g_aem1.aem02,
                                             g_aem1.aem09,g_aem1.aem04,
                                             g_aem1.aem00,g_aem1.aem03,
                                             g_aem1.aem15,g_aem1.aem05,
                                             g_aem1.aem06,g_aem1.aem07,
                                             g_aem1.aem08
                                            ,g_aem1.aem16,g_aem1.aem17    #FUN-BA0111 add
                                            ,g_aem1.aem18,g_aem1.aem19    #FUN-BA0111 add
       WHEN 'L' FETCH LAST     q0002_cs INTO g_aem1.aem01,g_aem1.aem02,
                                             g_aem1.aem09,g_aem1.aem04,
                                             g_aem1.aem00,g_aem1.aem03,
                                             g_aem1.aem15,g_aem1.aem05,
                                             g_aem1.aem06,g_aem1.aem07,
                                             g_aem1.aem08
                                            ,g_aem1.aem16,g_aem1.aem17    #FUN-BA0111 add
                                            ,g_aem1.aem18,g_aem1.aem19    #FUN-BA0111 add
       WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
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
           END IF
           FETCH ABSOLUTE g_jump q0002_cs INTO g_aem1.aem01,g_aem1.aem02,
                                               g_aem1.aem09,g_aem1.aem04,
                                               g_aem1.aem00,g_aem1.aem03,
                                               g_aem1.aem15,g_aem1.aem05,
                                               g_aem1.aem06,g_aem1.aem07,
                                               g_aem1.aem08
                                              ,g_aem1.aem16,g_aem1.aem17    #FUN-BA0111 add
                                              ,g_aem1.aem18,g_aem1.aem19    #FUN-BA0111 add
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aem1.aem02,SQLCA.sqlcode,0)
       INITIALIZE g_aem1.* TO NULL
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       DISPLAY g_curs_index TO FORMONLY.idx
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL q0002_show()
END FUNCTION

FUNCTION q0002_show()
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_axa09    LIKE axa_file.axa09       

   DISPLAY BY NAME g_aem1.aem00,g_aem1.aem01,g_aem1.aem02,
                   g_aem1.aem03,g_aem1.aem04,g_aem1.aem05,
                   g_aem1.aem06,g_aem1.aem07,g_aem1.aem08,
                   g_aem1.aem09,g_aem1.aem15
                  ,g_aem1.aem16,g_aem1.aem17,g_aem1.aem18,g_aem1.aem19   #FUN-BA0111 add

   CALL s_aaz641_dbs(g_aem1.aem01,g_aem1.aem02) RETURNING g_dbs_axz03
   LET g_sql ="SELECT aag02 ",
              " FROM ",cl_get_target_table(g_dbs_axz03,'aag_file'), 
              " WHERE aag00 = '",g_aem1.aem00,"'",
              "   AND aag01 = '",g_aem1.aem04,"'",
              "   AND aagacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql   
   PREPARE q0002_pre_1  FROM g_sql
   DECLARE q0002_c_1 SCROLL CURSOR FOR q0002_pre_1
   OPEN q0002_c_1
   FETCH q0002_c_1 INTO l_aag02
   CLOSE q0002_c_1

   DISPLAY l_aag02 TO aag02
   CALL q0002_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q0002_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_total   LIKE aem_file.aem12   #FUN-AB0028

   LET l_total = 0    #FUN-AB0028

   LET l_sql =
       #"SELECT aem10,aem11,aem12,aem13,aem14",
       "SELECT aem10,aem11,aem12,(aem11-aem12),aem13,aem14",   #FUN-AB0028
       "  FROM aem_file",
       " WHERE aem01 = '",g_aem1.aem01,"' AND aem02 = '", g_aem1.aem02,"'",
       "   AND aem04 = '",g_aem1.aem04,"' AND aem09 = ",g_aem1.aem09,
       "   AND aem00 = '",g_aem1.aem00,"' AND aem03 = '",g_aem1.aem03,"'",
       "   AND aem15= '",g_aem1.aem15,"'"
   IF g_aem1.aem05 IS NULL THEN
      LET l_sql = l_sql, " AND aem05 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem05 = '",g_aem1.aem05,"'"
   END IF
   IF g_aem1.aem06 IS NULL THEN
      LET l_sql = l_sql, " AND aem06 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem06 = '",g_aem1.aem06,"'"
   END IF
   IF g_aem1.aem07 IS NULL THEN
      LET l_sql = l_sql, " AND aem07 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem07 = '",g_aem1.aem07,"'"
   END IF
   IF g_aem1.aem08 IS NULL THEN
      LET l_sql = l_sql, " AND aem08 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem08 = '",g_aem1.aem08,"'"
   END IF
  #FUN-BA0111--Begin--
   IF g_aem1.aem16 IS NULL THEN
      LET l_sql = l_sql, " AND aem16 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem16 = '",g_aem1.aem16,"'"
   END IF
   IF g_aem1.aem17 IS NULL THEN
      LET l_sql = l_sql, " AND aem17 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem17 = '",g_aem1.aem17,"'"
   END IF
   IF g_aem1.aem18 IS NULL THEN
      LET l_sql = l_sql, " AND aem18 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem18 = '",g_aem1.aem18,"'"
   END IF
   IF g_aem1.aem19 IS NULL THEN
      LET l_sql = l_sql, " AND aem19 IS NULL "
   ELSE
      LET l_sql = l_sql, " AND aem19 = '",g_aem1.aem19,"'"
   END IF
  #FUN-BA0111---End---

   PREPARE q0002_pb FROM l_sql
   DECLARE q0002_bcs CURSOR FOR q0002_pb          #BODY CURSOR

   CALL g_aem.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q0002_bcs INTO g_aem[g_cnt].*
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
      END IF
      IF cl_null(g_aem[g_cnt].amt) THEN LET g_aem[g_cnt].amt = 0  END IF  #FUN-AB0028
      LET l_total = l_total + g_aem[g_cnt].amt    #FUN-AB0028
      LET g_aem[g_cnt].amt = l_total              #FUN-AB0028
      LET g_cnt = g_cnt+1
   END FOREACH
   CALL g_aem.DeleteElement(g_cnt)
   LET g_rec_b= g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q0002_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aem TO s_aem.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q0002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q0002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q0002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q0002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q0002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

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
#FUN-A90028
