# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: gglq034.4gl
# Descriptions...: 合并衝銷后科目異動碼(固定)衝賬余額查詢
# Date & Author..: 10/09/09 FUN-A10015 BY chenmoyan 
# Modify.........: No.FUN-A30122 10/09/09 By vealxu 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641_asg,s_aaz641_asg
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
#模組變數(Module Variables)         #FUN-BB0036
DEFINE tm       RECORD
                 wc       STRING                  # Head Where condition
                END RECORD,
       g_asll1  RECORD
                 asll00   LIKE asll_file.asll00,
                 asll01   LIKE asll_file.asll01,
                 asll02   LIKE asll_file.asll02,
                 asll021  LIKE asll_file.asll021,
                 asll03   LIKE asll_file.asll03,
                 asll031  LIKE asll_file.asll031,
                 asll04   LIKE asll_file.asll04,
                 asll05   LIKE asll_file.asll05,
                 asll06   LIKE asll_file.asll06,
                 asll07   LIKE asll_file.asll07,
                 asll08   LIKE asll_file.asll08,
                 asll09   LIKE asll_file.asll09,
                 asll18   LIKE asll_file.asll18
                END RECORD,
       g_asll   DYNAMIC ARRAY OF RECORD
                 seq      LIKE ze_file.ze03,
                 asll11   LIKE asll_file.asll11,
                 asll12   LIKE asll_file.asll12,     
                 amt      LIKE type_file.num20_6   #FUN-AB0028     
                END RECORD,
       m_cnt              LIKE type_file.num10,
       g_argv1            LIKE asll_file.asll00,  #INPUT ARGUMENT - 1
       g_bookno           LIKE aaa_file.aaa01,    #帳別
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
DEFINE g_bookno1          LIKE aza_file.aza81   
DEFINE g_bookno2          LIKE aza_file.aza82
DEFINE g_flag             LIKE type_file.chr1
DEFINE l_table            STRING                                                                 
DEFINE g_str              STRING
DEFINE g_asg03            LIKE asg_file.asg03      
DEFINE g_asg05            LIKE asg_file.asg05     
DEFINE g_dbs_asg03        LIKE type_file.chr21   
DEFINE g_plant_asg03      LIKE type_file.chr21
DEFINE g_asg04            LIKE asg_file.asg04   
MAIN
      DEFINE l_sl         LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   ### *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "asll15.asll_file.asll15,asll01.asll_file.asll01,",
               "asll00.asll_file.asll00,asll04.asll_file.asll04,",
               "asll05.asll_file.asll05,asll06.asll_file.asll06,",
               "asll07.asll_file.asll07,asll08.asll_file.asll08,",
               "asll09.asll_file.asll09,asll18.asll_file.asll18,",
               "asll02.asll_file.asll02,asll021.asll_file.asll021,",
               "asll03.asll_file.asll03,asll031.asll_file.asll031,",
               "asll10.asll_file.asll10,asll11.asll_file.asll11,",
               "asll12.asll_file.asll12,l_aag02.aag_file.aag02"
   LET l_table = cl_prt_temptable('gglq034',g_sql) CLIPPED   # 產生Temp Table                                                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
   END IF                                                                                                                          
   #---------------------------- CR (1) ------------------------------#

   LET g_bookno = ARG_VAL(1)
   IF cl_null(g_bookno) THEN LET g_bookno=g_aaz.aaz64 END IF
   CALL s_dsmark(g_bookno)
   IF cl_null(g_bookno) THEN LET g_bookno=g_aaz.aaz64 END IF

   LET p_row = 1 LET p_col = 1
   OPEN WINDOW q006_w AT p_row,p_col WITH FORM "ggl/42f/gglq034"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL q006_menu()
   CLOSE FORM q006_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q006_cs()
   DEFINE l_cnt LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_asll.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_asll1.* TO NULL
   # 螢幕上取單頭條件
   CONSTRUCT BY NAME tm.wc ON
      asll01,asll02,asll03,asll09,asll00,
      asll021,asll031,asll18,asll04,asll05,
      asll06,asll07,asll08
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asll01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asll"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asll01
                 NEXT FIELD asll01
            WHEN INFIELD(asll04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asll04
            WHEN INFIELD(asll18) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_asll1.asll18
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asll18
                 NEXT FIELD asll18
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
       "SELECT UNIQUE asll00,asll01,asll02,asll021,asll03,asll031,asll04,",
       "              asll05,asll06,asll07,asll08,asll09,asll18",
       "  FROM asll_file ",
       " WHERE ",tm.wc CLIPPED,
       " ORDER BY asll01,asll02,asll021,asll03,asll031,asll04"
   PREPARE q006_prepare FROM g_sql
   DECLARE q006_cs SCROLL CURSOR WITH HOLD FOR q006_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE asll00,asll01,asll02,asll021,asll03,asll031,asll04,",
       "              asll05,asll06,asll07,asll08,asll09,asll18",
       "  FROM asll_file ",
       " WHERE ",tm.wc CLIPPED,
       "  INTO TEMP x"
   PREPARE q006_prepare_pre FROM g_sql
   EXECUTE q006_prepare_pre
   DECLARE q006_count CURSOR FOR
   SELECT COUNT(*) FROM x
END FUNCTION

FUNCTION q006_menu()
   WHILE TRUE
      CALL q006_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q006_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q006_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asll),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q006_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asll.clear()
   CALL q006_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q006_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q006_count
      FETCH q006_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q006_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q006_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     q006_cs INTO g_asll1.asll00,
                                            g_asll1.asll01,g_asll1.asll02,
                                            g_asll1.asll021,g_asll1.asll03,
                                            g_asll1.asll031,g_asll1.asll04,
                                            g_asll1.asll05,g_asll1.asll06,
                                            g_asll1.asll07,g_asll1.asll08,
                                            g_asll1.asll09,g_asll1.asll18
       WHEN 'P' FETCH PREVIOUS q006_cs INTO g_asll1.asll00,
                                            g_asll1.asll01,g_asll1.asll02,
                                            g_asll1.asll021,g_asll1.asll03,
                                            g_asll1.asll031,g_asll1.asll04,
                                            g_asll1.asll05,g_asll1.asll06,
                                            g_asll1.asll07,g_asll1.asll08,
                                            g_asll1.asll09,g_asll1.asll18
       WHEN 'F' FETCH FIRST    q006_cs INTO g_asll1.asll00,
                                            g_asll1.asll01,g_asll1.asll02,
                                            g_asll1.asll021,g_asll1.asll03,
                                            g_asll1.asll031,g_asll1.asll04,
                                            g_asll1.asll05,g_asll1.asll06,
                                            g_asll1.asll07,g_asll1.asll08,
                                            g_asll1.asll09,g_asll1.asll18
       WHEN 'L' FETCH LAST     q006_cs INTO g_asll1.asll00,
                                            g_asll1.asll01,g_asll1.asll02,
                                            g_asll1.asll021,g_asll1.asll03,
                                            g_asll1.asll031,g_asll1.asll04,
                                            g_asll1.asll05,g_asll1.asll06,
                                            g_asll1.asll07,g_asll1.asll08,
                                            g_asll1.asll09,g_asll1.asll18
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
           FETCH ABSOLUTE g_jump q006_cs INTO g_asll1.asll00,
                                              g_asll1.asll01,g_asll1.asll02,
                                              g_asll1.asll021,g_asll1.asll03,
                                              g_asll1.asll031,g_asll1.asll04,
                                              g_asll1.asll05,g_asll1.asll06,
                                              g_asll1.asll07,g_asll1.asll08,
                                              g_asll1.asll09,g_asll1.asll18
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_asll1.asll02,SQLCA.sqlcode,0)
       INITIALIZE g_asll1.* TO NULL
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
    CALL s_get_bookno(g_asll1.asll09)  RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag='1' THEN   #抓不到帳套
       CALL cl_err(g_asll1.asll08,'aoo-081',1)
    END IF
    CALL q006_show()
END FUNCTION

FUNCTION q006_show()
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_asa09    LIKE asa_file.asa09       

   DISPLAY BY NAME g_asll1.asll00,g_asll1.asll01,g_asll1.asll02,
                   g_asll1.asll021,g_asll1.asll03,g_asll1.asll031,
                   g_asll1.asll04,g_asll1.asll05,g_asll1.asll06,
                   g_asll1.asll07,g_asll1.asll08,g_asll1.asll09,
                   g_asll1.asll18
   SELECT asg03,asg04,asg05 INTO g_asg03,g_asg04,g_asg05 FROM asg_file   
    WHERE asg01 = g_asll1.asll02  
   
#FUN-A30122 --Beatk
#  LET g_plant_new = g_asg03      #營運中心
#  CALL s_getdbs()
#  LET g_dbs_asg03 = g_dbs_new    #所屬DB

#  IF g_asg04 = 'N' THEN  #不使用tiptop
#     LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#  ELSE
#     SELECT asa09 INTO l_asa09 FROM asa_file
#      WHERE asa01 = g_asll1.asll01
#        AND asa02 = g_asll1.asll02
#     IF l_asa09 = 'Y' THEN
#        SELECT asg03 INTO g_asg03 FROM asg_file WHERE  asg01 = g_asll1.asll02
#        LET g_plant_new = g_asg03
#        CALL s_getdbs()
#        LET g_dbs_asg03 = g_dbs_new
#     ELSE
#        LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#     END IF
#  END IF  
#  LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",                                                                      
#              " WHERE aaz00 = '0'"                                                                                               
#  PREPARE q006_pre FROM g_sql                                                                                                    
#  DECLARE q006_cur CURSOR FOR q006_pre                                                                                           
#  OPEN q006_cur                                                                                                                  
#  FETCH q006_cur INTO g_asll1.asll00    #合并後帳別
#  IF cl_null(g_asll1.asll00) THEN
#      CALL cl_err(g_asg03,'agl-601',1)
#  END IF
   CALL s_aaz641_asg(g_asll1.asll01,g_asll1.asll02) RETURNING g_plant_asg03   #FUN-A30122 g_dbs_asg03--> g_plant_asg03
   CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asll1.asll00                  #FUN-A30122 g_dbs_asg03--> g_plant_asg03
#FUN-A30122 --End   
#  LET g_sql ="SELECT aag02 FROM ",g_dbs_asg03,"aag_file ",   #FUN-A30122
   LET g_sql ="SELECT aag02 FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),  #FUN-30122 
              " WHERE aag00 = '",g_asll1.asll00,"'",
              "   AND aag01 = '",g_asll1.asll04,"'",
              "   AND aagacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
   CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql    #FUN-A30122
   PREPARE q006_pre_1  FROM g_sql
   DECLARE q006_c_1 CURSOR FOR q006_pre_1

   FOREACH q006_c_1 INTO l_aag02
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

   END FOREACH
   IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
   DISPLAY l_aag02 TO aag02
   CALL q006_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q006_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_total   LIKE asll_file.asll12   #FUN-AB0028

   LET l_total = 0    #FUN-AB0028

   LET l_sql =
       #"SELECT '',asll11, asll12",
       "SELECT '',asll11, asll12,(asll11-asll12) ",   #FUN-AB0028
       "  FROM asll_file",
       " WHERE asll04 = '",g_asll1.asll04,"'",
       "   AND asll00 = '",g_asll1.asll00,"' AND asll01 = '",g_asll1.asll01,"'",
       "   AND asll02 = '",g_asll1.asll02,"' AND asll021 = '",g_asll1.asll021,"'",
       "   AND asll03 = '",g_asll1.asll03,"' AND asll031= '",g_asll1.asll031,"'",
       "   AND asll05 = '",g_asll1.asll05,"' AND asll06 = '",g_asll1.asll06,"'",
       "   AND asll07 = '",g_asll1.asll07,"' AND asll08 = '",g_asll1.asll08,"'",
       "   AND asll09 = '",g_asll1.asll09,"' AND asll18 = '",g_asll1.asll18,"'",
       "   AND asll10 =?"
   PREPARE q006_pb FROM l_sql
   DECLARE q006_bcs CURSOR FOR q006_pb          #BODY CURSOR

   CALL g_asll.clear()
   LET g_rec_b=0
   LET g_cnt = 0
   FOR g_cnt = 1 TO 14
      LET g_i = g_cnt - 1
      OPEN q006_bcs USING g_i    #由第０期開始抓
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      FETCH q006_bcs INTO g_asll[g_cnt].*
      IF SQLCA.SQLCODE THEN
         LET g_asll[g_cnt].asll11 = 0
         LET g_asll[g_cnt].asll12 = 0
      END IF
      IF g_i = 0 THEN
         CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
         LET g_asll[g_cnt].seq = g_msg CLIPPED
      ELSE 
         LET g_asll[g_cnt].seq = g_i
      END IF
      IF cl_null(g_asll[g_cnt].amt) THEN LET g_asll[g_cnt].amt = 0  END IF  #FUN-AB0028
      CLOSE q006_bcs
   END FOR
   LET g_rec_b=g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q006_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asll TO s_asll.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL q006_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q006_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q006_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q006_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q006_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

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

FUNCTION q006_out()
    DEFINE
        l_i     LIKE type_file.num5,
        l_sql1  STRING,
        l_name  LIKE type_file.chr20,    # External(Disk) file name
        l_asll  RECORD
                 asll15   LIKE asll_file.asll15,
                 asll01   LIKE asll_file.asll01,
                 asll00   LIKE asll_file.asll00,
                 asll04   LIKE asll_file.asll04,
                 asll05   LIKE asll_file.asll05,
                 asll06   LIKE asll_file.asll06,
                 asll07   LIKE asll_file.asll07,
                 asll08   LIKE asll_file.asll08,
                 asll09   LIKE asll_file.asll09,
                 asll18   LIKE asll_file.asll18,
                 asll02   LIKE asll_file.asll02,
                 asll021  LIKE asll_file.asll021,
                 asll03   LIKE asll_file.asll03,
                 asll031  LIKE asll_file.asll031,
                 asll10   LIKE asll_file.asll10
                END RECORD,
        l_asll1 DYNAMIC ARRAY OF RECORD
                 asll11   LIKE asll_file.asll10,
                 asll12   LIKE asll_file.asll11,
                 seq     LIKE ze_file.ze03
                END RECORD,
        l_chr   LIKE type_file.chr1,
        l_aag02 LIKE aag_file.aag02
    DEFINE l_asa09        LIKE asa_file.asa09   
    IF tm.wc IS NULL THEN
       CALL cl_err('',-400,0) 
       RETURN
    END IF
    CALL cl_wait()
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
                                                AND aaf02 = g_lang
    # 組合出 SQL 指令
    LET g_sql="SELECT UNIQUE asll15,asll01,asll00,asll04,asll05,asll06,asll07,asll08,",
              "              asll09,asll18,asll02,asll021,asll03,asll031,'' ",
              "  FROM asll_file,OUTER aag_file ",
              " WHERE asll04=aag_file.aag01",
              "   AND asll00=aag_file.aag00",
              "   AND ",tm.wc CLIPPED
    PREPARE q006_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q006_co CURSOR FOR q006_p1

    LET l_sql1="SELECT asll11,asll12,(asll11-asll12)",
               "  FROM asll_file",
               " WHERE asll15 = ?  AND asll00 = ? AND asll01 = ? ",
               "   AND asll02 = ?  AND asll021= ? AND asll03 = ? ",
               "   AND asll031= ?  AND asll04 = ? AND asll05 = ? ",
               "   AND asll06 = ?  AND asll07 = ? AND asll08 = ? ",
               "   AND asll09 = ?  AND asll18 = ? "
    PREPARE q006_p2 FROM l_sql1               # RUNTIME 編譯
    DECLARE q006_c1 CURSOR FOR q006_p2

    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
    CALL cl_del_data(l_table)                                             
    #------------------------------ CR (2) ------------------------------#

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

    LET m_cnt = 0
    FOREACH q006_co INTO l_asll.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_cnt=1 TO l_asll1.getLength()
           INITIALIZE l_asll1[g_cnt].* TO NULL
       END FOR
       FOR g_cnt = 1 TO 14
          LET l_asll.asll10 = g_cnt - 1
          OPEN q006_c1 USING l_asll.asll15,l_asll.asll00,l_asll.asll01,
                             l_asll.asll02,l_asll.asll021,l_asll.asll03,
                             l_asll.asll031,l_asll.asll04,l_asll.asll05,
                             l_asll.asll06,l_asll.asll07,l_asll.asll08,
                             l_asll.asll09,l_asll.asll18
          CALL s_get_bookno(l_asll.asll09) RETURNING g_flag,g_bookno1,g_bookno2
          SELECT asg03,asg04,asg05 INTO g_asg03,g_asg04,g_asg05 FROM asg_file  
           WHERE asg01 = l_asll.asll02
          
#FUN-A30122 --Beatk
#         LET g_plant_new = g_asg03      #營運中心
#         CALL s_getdbs()
#         LET g_dbs_asg03 = g_dbs_new    #所屬DB

#         IF g_asg04 = 'N' THEN  #不使用tiptop
#            LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#         ELSE
#            SELECT asa09 INTO l_asa09 FROM asa_file
#             WHERE asa01 = l_asll.asll01
#               AND asa02 = l_asll.asll02
#            IF l_asa09 = 'Y' THEN
#               SELECT asg03 INTO g_asg03 FROM asg_file WHERE  asg01 = l_asll.asll02
#               LET g_plant_new = g_asg03
#               CALL s_getdbs()
#               LET g_dbs_asg03 = g_dbs_new
#            ELSE
#               LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#            END IF
#         END IF
#         LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",
#                     " WHERE aaz00 = '0'"
#         PREPARE q006_pre1 FROM g_sql DECLARE q006_cur1 CURSOR FOR q006_pre1
#         OPEN q006_cur1
#         FETCH q006_cur1 INTO l_asll.asll00    #合并後帳別
#         IF cl_null(l_asll.asll00) THEN
#            CALL cl_err(g_asg03,'agl-601',1)
#         END IF
          CALL s_aaz641_asg(l_asll.asll01,l_asll.asll02) RETURNING g_plant_asg03   #FUN-A30122 g_dbs_asg03--->g_plant_asg03
          CALL s_get_aaz641_asg(g_plant_asg03) RETURNING l_asll.asll00                 #FUN-A30122 g_dbs_asg03--->g_plant_asg03  
#FUN-A30122 --End          
      #   LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file",   #FUN-A30122
          LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),    #FUN-A30122 
                      " WHERE aag01 = '",l_asll.asll04,"'",
                      "   AND aagacti = 'Y' ",
                      "   AND aag00 = '",l_asll.asll00,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
          CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql          #FUN-A30122 
          PREPARE q006_pre_2  FROM g_sql
          DECLARE q006_c_2 CURSOR FOR q006_pre_2
          OPEN q006_c_2
          FETCH q006_c_2 INTO l_aag02

          IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF
          FETCH q006_c1 INTO l_asll1[g_cnt].*
          IF SQLCA.sqlcode THEN
             LET l_asll1[g_cnt].asll11 = 0
             LET l_asll1[g_cnt].asll12 = 0
          END IF

          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
          EXECUTE insert_prep USING
             l_asll.asll15,l_asll.asll01,l_asll.asll00,l_asll.asll04,
             l_asll.asll05,l_asll.asll06,l_asll.asll07,l_asll.asll08,
             l_asll.asll09,l_asll.asll18,l_asll.asll02,l_asll.asll021,
             l_asll.asll03,l_asll.asll031,l_asll.asll10,
             l_asll1[g_cnt].asll11,l_asll1[g_cnt].asll12,l_aag02
          #-------------------------- CR (3) --------------------------#

          LET m_cnt = m_cnt + 1
          INITIALIZE l_asll.* TO NULL
          CLOSE q006_bcs
       END FOR
    END FOREACH
    CLOSE q006_co
    ERROR ""
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'asll01,asll00,asll02,asll021,asll03,asll031,asll09,asll18,asll04,asll05,asll06,asll07,asll08')
            RETURNING tm.wc
    END IF
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    LET g_str = tm.wc,";",g_azi04
    CALL cl_prt_cs3('gglq034','gglq034',g_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
#FUN-A10015
