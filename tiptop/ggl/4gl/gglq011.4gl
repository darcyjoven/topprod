# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: gglq011.4gl
# Descriptions...: 合并衝銷后科目異動碼(固定)衝賬余額查詢
# Date & Author..: 10/09/19 FUN-A90028 BY chenmoyan 
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.FUN-C80020 12/08/09 By Carrier 增加key 值字段 asm20/asn20/asnn20 合并年度 asm21/asn21/asnn21 合并期别

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
#模組變數(Module Variables)
DEFINE tm       RECORD                         #FUN-BB0036
                 wc       STRING                  # Head Where condition
                END RECORD,
       g_asm1  RECORD
                 asm01   LIKE asm_file.asm01,
                 asm00   LIKE asm_file.asm00,
                 asm02   LIKE asm_file.asm02,
                 asm03   LIKE asm_file.asm03,
                 #No.FUN-C80020  --Begin
                 asm20   LIKE asm_file.asm20,
                 asm21   LIKE asm_file.asm21,
                 #No.FUN-C80020  --End  
                 asm04   LIKE asm_file.asm04,
                 asm05   LIKE asm_file.asm05,
                 asm11   LIKE asm_file.asm11
                END RECORD,
       g_asm   DYNAMIC ARRAY OF RECORD
                 asm06   LIKE asm_file.asm06,
                 asm07   LIKE asm_file.asm07,
                 asm08   LIKE asm_file.asm08,
                 amt     LIKE type_file.num20_6,    #FUN-AB0028
                 asm09   LIKE asm_file.asm09,
                 asm10   LIKE asm_file.asm10
                END RECORD,
       m_cnt              LIKE type_file.num10,
       g_argv1            LIKE asm_file.asm00,  #INPUT ARGUMENT - 1
       g_wc,g_sql         STRING,                 #WHERE CONDITION
       p_row,p_col        LIKE type_file.num5,
       g_rec_b            LIKE type_file.num5     #單身筆數
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_i                LIKE type_file.num5     #count/index for any purpose
DEFINE g_msg              LIKE ze_file.ze03
DEFINE g_row_count        LIKE type_file.num10
DEFINE g_curs_index       LIKE type_file.num10
DEFINE g_jump             LIKE type_file.num10
DEFINE mi_no_ask          LIKE type_file.num5
DEFINE g_flag             LIKE type_file.chr1
DEFINE g_str              STRING
DEFINE g_dbs_asg03        LIKE type_file.chr21   
MAIN
      DEFINE l_sl         LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 1 LET p_col = 1
   OPEN WINDOW q000_w AT p_row,p_col WITH FORM "ggl/42f/gglq011"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL q000_menu()
   CLOSE FORM q000_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q000_cs()
   DEFINE l_cnt LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_asm.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_asm1.* TO NULL
   # 螢幕上取單頭條件
   CONSTRUCT BY NAME tm.wc ON
      asm01,asm00,asm02,asm03,asm20,asm21,asm04,asm05,asm11   #No.FUN-C80020
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asm01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asm01
                 NEXT FIELD asm01
            WHEN INFIELD(asm04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asm04
            WHEN INFIELD(asm11) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_asm1.asm11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asm11
                 NEXT FIELD asm11
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

   LET g_sql=
       "SELECT UNIQUE asm01,asm00,asm02,asm03,asm20,asm21,asm04,asm05,asm11",   #No.FUN-C80020
       "  FROM asm_file ",
       " WHERE ",tm.wc CLIPPED,
       " ORDER BY asm01,asm00,asm02,asm03,asm20,asm21,asm04,asm05"   #No.FUN-C80020
   PREPARE q000_prepare FROM g_sql
   DECLARE q000_cs SCROLL CURSOR WITH HOLD FOR q000_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE asm01,asm00,asm02,asm03,asm20,asm21,asm04,asm05,asm11",   #No.FUN-C80020
       "  FROM asm_file ",
       " WHERE ",tm.wc CLIPPED,
       "  INTO TEMP x"
   PREPARE q000_prepare_pre FROM g_sql
   EXECUTE q000_prepare_pre
   DECLARE q000_count CURSOR FOR
   SELECT COUNT(*) FROM x
END FUNCTION

FUNCTION q000_menu()
DEFINE   l_cmd        LIKE type_file.chr1000
   WHILE TRUE
      CALL q000_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q000_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asm),'','')
            END IF
#No.FUN-C80020  --Begin
#        WHEN "query1"
#           IF cl_chk_act_auth() THEN
#               LET l_cmd =  "aglq0001 ","'",g_asm1.asm01,"' ",
#                                    "'",g_asm1.asm00,"' '",g_asm1.asm02,"' ",
#                                    "'",g_asm1.asm03,"' '",g_asm1.asm04,"'"
#              CALL cl_cmdrun(l_cmd)
#           END IF
#        WHEN "query2"
#           IF cl_chk_act_auth() THEN
#               LET l_cmd =  "aglq0002 ","'",g_asm1.asm01,"' ",
#                                    "'",g_asm1.asm00,"' '",g_asm1.asm02,"' ",
#                                    "'",g_asm1.asm03,"' '",g_asm1.asm04,"'"
#              CALL cl_cmdrun(l_cmd)
#           END IF
#No.FUN-C80020  --End
      END CASE
   END WHILE
END FUNCTION

FUNCTION q000_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asm.clear()
   CALL q000_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q000_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q000_count
      FETCH q000_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q000_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q000_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     q000_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm20,g_asm1.asm21,   #No.FUN-C80020
                                            g_asm1.asm04,g_asm1.asm05,
                                            g_asm1.asm11
       WHEN 'P' FETCH PREVIOUS q000_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm20,g_asm1.asm21,   #No.FUN-C80020
                                            g_asm1.asm04,g_asm1.asm05,
                                            g_asm1.asm11
       WHEN 'F' FETCH FIRST    q000_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm20,g_asm1.asm21,   #No.FUN-C80020
                                            g_asm1.asm04,g_asm1.asm05,
                                            g_asm1.asm11
       WHEN 'L' FETCH LAST     q000_cs INTO g_asm1.asm01,g_asm1.asm00,
                                            g_asm1.asm02,g_asm1.asm03,
                                            g_asm1.asm20,g_asm1.asm21,   #No.FUN-C80020
                                            g_asm1.asm04,g_asm1.asm05,
                                            g_asm1.asm11
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
           FETCH ABSOLUTE g_jump q000_cs INTO g_asm1.asm01,g_asm1.asm00,
                                              g_asm1.asm02,g_asm1.asm03,
                                              g_asm1.asm20,g_asm1.asm21,   #No.FUN-C80020
                                              g_asm1.asm04,g_asm1.asm05,
                                              g_asm1.asm11
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_asm1.asm02,SQLCA.sqlcode,0)
       INITIALIZE g_asm1.* TO NULL
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
  # CALL s_get_bookno(g_asm1.asm09)  RETURNING g_flag,g_bookno1,g_bookno2
  # IF g_flag='1' THEN   #抓不到帳套
  #    CALL cl_err(g_asm1.asm08,'aoo-081',1)
  # END IF
    CALL q000_show()
END FUNCTION

FUNCTION q000_show()
   DEFINE l_aag02   LIKE aag_file.aag02

   DISPLAY BY NAME g_asm1.asm00,g_asm1.asm01,g_asm1.asm02,
                   g_asm1.asm03,g_asm1.asm04,g_asm1.asm05,
                   g_asm1.asm20,g_asm1.asm21,                      #No.FUN-C80020
                   g_asm1.asm11
   CALL s_aaz641_asg(g_asm1.asm01,g_asm1.asm02) RETURNING g_dbs_asg03
   LET g_sql ="SELECT aag02 ",
              " FROM ",cl_get_target_table(g_dbs_asg03,'aag_file'), 
              " WHERE aag00 = '",g_asm1.asm00,"'",
              "   AND aag01 = '",g_asm1.asm04,"'",
              "   AND aagacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_asg03) RETURNING g_sql   
   PREPARE q000_pre_1  FROM g_sql
   DECLARE q000_c_1 SCROLL CURSOR FOR q000_pre_1
   OPEN q000_c_1
   FETCH q000_c_1 INTO l_aag02
   CLOSE q000_c_1

   DISPLAY l_aag02 TO aag02
   CALL q000_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q000_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_total   LIKE aed_file.aed05   #FUN-AB0028

   LET l_total = 0  #FUN-AB0028
   LET l_sql =
       #"SELECT asm06,asm07,asm08,asm09,asm10",
       "SELECT asm06,asm07,asm08,(asm07-asm08),asm09,asm10",   #FUN-AB0028
       "  FROM asm_file",
       " WHERE asm01 = '",g_asm1.asm01,"'",
       "   AND asm00 = '",g_asm1.asm00,"' AND asm02 = '",g_asm1.asm02,"'",
       "   AND asm03 = '",g_asm1.asm03,"' AND asm04 = '",g_asm1.asm04,"'",
       "   AND asm20 = ", g_asm1.asm20,"  AND asm21 =  ",g_asm1.asm21,                    #No.FUN-C80020
       "   AND asm05 = '",g_asm1.asm05,"' AND asm11= '",g_asm1.asm11,"'"
   PREPARE q000_pb FROM l_sql
   DECLARE q000_bcs CURSOR FOR q000_pb          #BODY CURSOR

   CALL g_asm.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q000_bcs INTO g_asm[g_cnt].*
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
      END IF
      IF cl_null(g_asm[g_cnt].amt) THEN LET g_asm[g_cnt].amt = 0  END IF  #FUN-AB0028
      LET l_total = l_total + g_asm[g_cnt].amt   #FUN-AB0028
      LET g_asm[g_cnt].amt = l_total             #FUN-AB0028
      LET g_cnt = g_cnt+1
   END FOREACH
   CALL g_asm.DeleteElement(g_cnt)
   LET g_rec_b= g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q000_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asm TO s_asm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL q000_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q000_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q000_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q000_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q000_fetch('L')
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

      #No.FUN-C80020  --Begin
      #ON ACTION query1
      #   LET g_action_choice="query1"
      #   EXIT DISPLAY
      #ON ACTION query2
      #   LET g_action_choice="query2"
      #   EXIT DISPLAY
      #No.FUN-C80020  --End  


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-A90028
