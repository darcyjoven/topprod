# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglq0001.4gl
# Descriptions...: 合并個體關系人異動碼會計科目余額查詢作業
# Date & Author..: 10/09/19 FUN-A90028 BY chenmoyan 
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
#模組變數(Module Variables)
DEFINE tm       RECORD
                 wc       STRING                  # Head Where condition
                END RECORD,
       g_aek1  RECORD
                 aek01   LIKE aek_file.aek01,
                 aek02   LIKE aek_file.aek02,
                 aek06   LIKE aek_file.aek06,
                 aek00   LIKE aek_file.aek00,
                 aek03   LIKE aek_file.aek03,
                 aek12   LIKE aek_file.aek12,
                 aek04   LIKE aek_file.aek04,
                 aek05   LIKE aek_file.aek05
                END RECORD,
       g_aek   DYNAMIC ARRAY OF RECORD
                 aek07   LIKE aek_file.aek07,
                 aek08   LIKE aek_file.aek08,
                 aek09   LIKE aek_file.aek09,
                 amt     LIKE type_file.num20_6,    #FUN-AB0028
                 aek10   LIKE aek_file.aek10,
                 aek11   LIKE aek_file.aek11
                END RECORD,
       g_argv1            LIKE aek_file.aek01,
       g_argv2            LIKE aek_file.aek00,
       g_argv3            LIKE aek_file.aek02,
       g_argv4            LIKE aek_file.aek03,
       g_argv5            LIKE aek_file.aek04,
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
   OPEN WINDOW q0001_w AT p_row,p_col WITH FORM "agl/42f/aglq0001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL q0001_q() 
   END IF
   CALL q0001_menu()
   CLOSE FORM q0001_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q0001_cs()
   DEFINE l_cnt LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_aek.clear()
   CALL cl_opmsg('q')
   IF cl_null(g_argv1) THEN
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")

      INITIALIZE g_aek1.* TO NULL
      # 螢幕上取單頭條件
      CONSTRUCT BY NAME tm.wc ON
         aek01,aek02,aek06,aek00,aek03,aek12,aek04,aek05
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aek01) #族群編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_axa"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aek01
                    NEXT FIELD aek01
               WHEN INFIELD(aek04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_aag"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aek04
               WHEN INFIELD(aek12) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_aek1.aek12
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aek12
                    NEXT FIELD aek12
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
      LET tm.wc = " aek01 = '",g_argv1,"' AND aek00 = '",g_argv2,"'",
                  " AND aek02 = '",g_argv3,"' AND aek03 = '",g_argv4,"'",
                  " AND aek04 = '",g_argv5,"' "
      IF NOT cl_null(g_argv1) THEN
         INITIALIZE g_argv1 TO NULL
         INITIALIZE g_argv2 TO NULL
         INITIALIZE g_argv3 TO NULL
         INITIALIZE g_argv4 TO NULL
         INITIALIZE g_argv5 TO NULL
      END IF
   END IF

   #====>資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
   IF g_priv3 MATCHES "[5678]" THEN              #群組權限
      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql=
       "SELECT UNIQUE aek01,aek02,aek06,aek00,aek03,aek12,aek04,aek05",
       "  FROM aek_file ",
       " WHERE ",tm.wc CLIPPED,
       " ORDER BY aek01,aek00,aek02,aek03,aek04,aek05"
   PREPARE q0001_prepare FROM g_sql
   DECLARE q0001_cs SCROLL CURSOR WITH HOLD FOR q0001_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE aek01,aek02,aek06,aek00,aek03,aek12,aek04,aek05",
       "  FROM aek_file ",
       " WHERE ",tm.wc CLIPPED,
       "  INTO TEMP x"
   PREPARE q0001_prepare_pre FROM g_sql
   EXECUTE q0001_prepare_pre
   DECLARE q0001_count CURSOR FOR
   SELECT COUNT(*) FROM x
END FUNCTION

FUNCTION q0001_menu()
   WHILE TRUE
      CALL q0001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q0001_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aek),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q0001_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aek.clear()
   CALL q0001_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q0001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q0001_count
      FETCH q0001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q0001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q0001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     q0001_cs INTO g_aek1.aek01,g_aek1.aek02,
                                             g_aek1.aek06,g_aek1.aek00,
                                             g_aek1.aek03,g_aek1.aek12,
                                             g_aek1.aek04,g_aek1.aek05
       WHEN 'P' FETCH PREVIOUS q0001_cs INTO g_aek1.aek01,g_aek1.aek02,
                                             g_aek1.aek06,g_aek1.aek00,
                                             g_aek1.aek03,g_aek1.aek12,
                                             g_aek1.aek04,g_aek1.aek05
       WHEN 'F' FETCH FIRST    q0001_cs INTO g_aek1.aek01,g_aek1.aek02,
                                             g_aek1.aek06,g_aek1.aek00,
                                             g_aek1.aek03,g_aek1.aek12,
                                             g_aek1.aek04,g_aek1.aek05
       WHEN 'L' FETCH LAST     q0001_cs INTO g_aek1.aek01,g_aek1.aek02,
                                             g_aek1.aek06,g_aek1.aek00,
                                             g_aek1.aek03,g_aek1.aek12,
                                             g_aek1.aek04,g_aek1.aek05
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
           FETCH ABSOLUTE g_jump q0001_cs INTO g_aek1.aek01,g_aek1.aek02,
                                               g_aek1.aek06,g_aek1.aek00,
                                               g_aek1.aek03,g_aek1.aek12,
                                               g_aek1.aek04,g_aek1.aek05
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aek1.aek02,SQLCA.sqlcode,0)
       INITIALIZE g_aek1.* TO NULL
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
    CALL q0001_show()
END FUNCTION

FUNCTION q0001_show()
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_axa09    LIKE axa_file.axa09       

   DISPLAY BY NAME g_aek1.aek00,g_aek1.aek01,g_aek1.aek02,
                   g_aek1.aek03,g_aek1.aek04,g_aek1.aek05,
                   g_aek1.aek06,g_aek1.aek12

   CALL s_aaz641_dbs(g_aek1.aek01,g_aek1.aek02) RETURNING g_dbs_axz03
   LET g_sql ="SELECT aag02 ",
              " FROM ",cl_get_target_table(g_dbs_axz03,'aag_file'), 
              " WHERE aag00 = '",g_aek1.aek00,"'",
              "   AND aag01 = '",g_aek1.aek04,"'",
              "   AND aagacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql   
   PREPARE q0001_pre_1  FROM g_sql
   DECLARE q0001_c_1 SCROLL CURSOR FOR q0001_pre_1
   OPEN q0001_c_1
   FETCH q0001_c_1 INTO l_aag02
   CLOSE q0001_c_1

   DISPLAY l_aag02 TO aag02
   CALL q0001_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q0001_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_total   LIKE aed_file.aed05   #FUN-AB0028

   LET l_total = 0    #FUN-AB0028

   LET l_sql =
       #"SELECT aek07,aek08,aek09,aek10,aek11",
       "SELECT aek07,aek08,aek09,(aek08-aek09),aek10,aek11",    #FUN-AB0028
       "  FROM aek_file",
       " WHERE aek01 = '",g_aek1.aek01,"' AND aek06 = ", g_aek1.aek06,
       "   AND aek00 = '",g_aek1.aek00,"' AND aek02 = '",g_aek1.aek02,"'",
       "   AND aek03 = '",g_aek1.aek03,"' AND aek04 = '",g_aek1.aek04,"'",
       "   AND aek05 = '",g_aek1.aek05,"' AND aek12= '",g_aek1.aek12,"'"
   PREPARE q0001_pb FROM l_sql
   DECLARE q0001_bcs CURSOR FOR q0001_pb          #BODY CURSOR

   CALL g_aek.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q0001_bcs INTO g_aek[g_cnt].*
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
      END IF
      IF cl_null(g_aek[g_cnt].amt) THEN LET g_aek[g_cnt].amt = 0  END IF  #FUN-AB0028
      LET l_total = l_total + g_aek[g_cnt].amt    #FUN-AB0028
      LET g_aek[g_cnt].amt = l_total              #FUN-AB0028

      LET g_cnt = g_cnt+1
   END FOREACH
   CALL g_aek.DeleteElement(g_cnt)
   LET g_rec_b= g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q0001_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aek TO s_aek.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL q0001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q0001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q0001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q0001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q0001_fetch('L')
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
