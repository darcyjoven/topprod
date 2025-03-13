# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aglq006.4gl
# Descriptions...: 合并衝銷后科目異動碼(固定)衝賬余額查詢
# Date & Author..: 10/09/09 FUN-A10015 BY chenmoyan 
# Modify.........: No.FUN-A30122 10/09/09 By vealxu 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-BA0111 12/04/17 By Belle  將總帳的異動碼科餘1~4碼也納入合併資料
DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE tm       RECORD
                 wc       STRING                  # Head Where condition
                END RECORD,
       g_aeii1  RECORD
                 aeii00   LIKE aeii_file.aeii00,
                 aeii01   LIKE aeii_file.aeii01,
                 aeii02   LIKE aeii_file.aeii02,
                 aeii021  LIKE aeii_file.aeii021,
                 aeii03   LIKE aeii_file.aeii03,
                 aeii031  LIKE aeii_file.aeii031,
                 aeii04   LIKE aeii_file.aeii04,
                 aeii05   LIKE aeii_file.aeii05,
                 aeii06   LIKE aeii_file.aeii06,
                 aeii07   LIKE aeii_file.aeii07,
                 aeii08   LIKE aeii_file.aeii08,
                 aeii09   LIKE aeii_file.aeii09,
                 aeii18   LIKE aeii_file.aeii18
                ,aeii19   LIKE aeii_file.aeii19   #FUN-BA0111 add
                ,aeii20   LIKE aeii_file.aeii20   #FUN-BA0111 add
                ,aeii21   LIKE aeii_file.aeii21   #FUN-BA0111 add
                ,aeii22   LIKE aeii_file.aeii22   #FUN-BA0111 add
                END RECORD,
       g_aeii   DYNAMIC ARRAY OF RECORD
                 seq      LIKE ze_file.ze03,
                 aeii11   LIKE aeii_file.aeii11,
                 aeii12   LIKE aeii_file.aeii12,     
                 amt      LIKE type_file.num20_6   #FUN-AB0028     
                END RECORD,
       m_cnt              LIKE type_file.num10,
       g_argv1            LIKE aeii_file.aeii00,  #INPUT ARGUMENT - 1
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
DEFINE g_axz03            LIKE axz_file.axz03      
DEFINE g_axz05            LIKE axz_file.axz05     
DEFINE g_dbs_axz03        LIKE type_file.chr21   
DEFINE g_plant_axz03      LIKE type_file.chr21
DEFINE g_axz04            LIKE axz_file.axz04   
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

   ### *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "aeii15.aeii_file.aeii15,aeii01.aeii_file.aeii01,",
               "aeii00.aeii_file.aeii00,aeii04.aeii_file.aeii04,",
               "aeii05.aeii_file.aeii05,aeii06.aeii_file.aeii06,",
               "aeii07.aeii_file.aeii07,aeii08.aeii_file.aeii08,",
               "aeii09.aeii_file.aeii09,aeii18.aeii_file.aeii18,",
               "aeii02.aeii_file.aeii02,aeii021.aeii_file.aeii021,",
               "aeii03.aeii_file.aeii03,aeii031.aeii_file.aeii031,",
               "aeii10.aeii_file.aeii10,aeii11.aeii_file.aeii11,",
               "aeii12.aeii_file.aeii12,l_aag02.aag_file.aag02,"
              ,"aeii19.aeii_file.aeii19,aeii20.aeii_file.aeii20,"    #FUN-BA0111 add
              ,"aeii21.aeii_file.aeii21,aeii22.aeii_file.aeii22"     #FUN-BA0111 add
   LET l_table = cl_prt_temptable('aglq006',g_sql) CLIPPED   # 產生Temp Table                                                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"       #FUN-BA0111 mod
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
   OPEN WINDOW q006_w AT p_row,p_col WITH FORM "agl/42f/aglq006"
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
   CALL g_aeii.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_aeii1.* TO NULL
   # 螢幕上取單頭條件
   CONSTRUCT BY NAME tm.wc ON
      aeii01,aeii02,aeii03,aeii09,aeii00,
      aeii021,aeii031,aeii18,aeii04,aeii05,
      aeii06,aeii07,aeii08
     ,aeii19,aeii20,aeii21,aeii22            #FUN-BA0111 add
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aeii01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aeii"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aeii01
                 NEXT FIELD aeii01
            WHEN INFIELD(aeii04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aeii04
            WHEN INFIELD(aeii18) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aeii1.aeii18
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aeii18
                 NEXT FIELD aeii18
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
       "SELECT UNIQUE aeii00,aeii01,aeii02,aeii021,aeii03,aeii031,aeii04,",
       "              aeii05,aeii06,aeii07,aeii08,aeii09,aeii18",
       "             ,aeii19,aeii20,aeii21,aeii22",               #FUN-BA0111 add
       "  FROM aeii_file ",
       " WHERE ",tm.wc CLIPPED,
       " ORDER BY aeii01,aeii02,aeii021,aeii03,aeii031,aeii04"
   PREPARE q006_prepare FROM g_sql
   DECLARE q006_cs SCROLL CURSOR WITH HOLD FOR q006_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
       "SELECT UNIQUE aeii00,aeii01,aeii02,aeii021,aeii03,aeii031,aeii04,",
       "              aeii05,aeii06,aeii07,aeii08,aeii09,aeii18",
       "             ,aeii19,aeii20,aeii21,aeii22",               #FUN-BA0111 add
       "  FROM aeii_file ",
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aeii),'','')
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
   CALL g_aeii.clear()
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
       WHEN 'N' FETCH NEXT     q006_cs INTO g_aeii1.aeii00,
                                            g_aeii1.aeii01,g_aeii1.aeii02,
                                            g_aeii1.aeii021,g_aeii1.aeii03,
                                            g_aeii1.aeii031,g_aeii1.aeii04,
                                            g_aeii1.aeii05,g_aeii1.aeii06,
                                            g_aeii1.aeii07,g_aeii1.aeii08,
                                            g_aeii1.aeii09,g_aeii1.aeii18
                                           ,g_aeii1.aeii19,g_aeii1.aeii20    #FUN-BA0111
                                           ,g_aeii1.aeii21,g_aeii1.aeii22    #FUN-BA0111
       WHEN 'P' FETCH PREVIOUS q006_cs INTO g_aeii1.aeii00,
                                            g_aeii1.aeii01,g_aeii1.aeii02,
                                            g_aeii1.aeii021,g_aeii1.aeii03,
                                            g_aeii1.aeii031,g_aeii1.aeii04,
                                            g_aeii1.aeii05,g_aeii1.aeii06,
                                            g_aeii1.aeii07,g_aeii1.aeii08,
                                            g_aeii1.aeii09,g_aeii1.aeii18
                                           ,g_aeii1.aeii19,g_aeii1.aeii20    #FUN-BA0111
                                           ,g_aeii1.aeii21,g_aeii1.aeii22    #FUN-BA0111
       WHEN 'F' FETCH FIRST    q006_cs INTO g_aeii1.aeii00,
                                            g_aeii1.aeii01,g_aeii1.aeii02,
                                            g_aeii1.aeii021,g_aeii1.aeii03,
                                            g_aeii1.aeii031,g_aeii1.aeii04,
                                            g_aeii1.aeii05,g_aeii1.aeii06,
                                            g_aeii1.aeii07,g_aeii1.aeii08,
                                            g_aeii1.aeii09,g_aeii1.aeii18
                                           ,g_aeii1.aeii19,g_aeii1.aeii20    #FUN-BA0111
                                           ,g_aeii1.aeii21,g_aeii1.aeii22    #FUN-BA0111
       WHEN 'L' FETCH LAST     q006_cs INTO g_aeii1.aeii00,
                                            g_aeii1.aeii01,g_aeii1.aeii02,
                                            g_aeii1.aeii021,g_aeii1.aeii03,
                                            g_aeii1.aeii031,g_aeii1.aeii04,
                                            g_aeii1.aeii05,g_aeii1.aeii06,
                                            g_aeii1.aeii07,g_aeii1.aeii08,
                                            g_aeii1.aeii09,g_aeii1.aeii18
                                           ,g_aeii1.aeii19,g_aeii1.aeii20    #FUN-BA0111
                                           ,g_aeii1.aeii21,g_aeii1.aeii22    #FUN-BA0111
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
           FETCH ABSOLUTE g_jump q006_cs INTO g_aeii1.aeii00,
                                              g_aeii1.aeii01,g_aeii1.aeii02,
                                              g_aeii1.aeii021,g_aeii1.aeii03,
                                              g_aeii1.aeii031,g_aeii1.aeii04,
                                              g_aeii1.aeii05,g_aeii1.aeii06,
                                              g_aeii1.aeii07,g_aeii1.aeii08,
                                              g_aeii1.aeii09,g_aeii1.aeii18
                                             ,g_aeii1.aeii19,g_aeii1.aeii20    #FUN-BA0111
                                             ,g_aeii1.aeii21,g_aeii1.aeii22    #FUN-BA0111
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aeii1.aeii02,SQLCA.sqlcode,0)
       INITIALIZE g_aeii1.* TO NULL
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
    CALL s_get_bookno(g_aeii1.aeii09)  RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag='1' THEN   #抓不到帳套
       CALL cl_err(g_aeii1.aeii08,'aoo-081',1)
    END IF
    CALL q006_show()
END FUNCTION

FUNCTION q006_show()
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_axa09    LIKE axa_file.axa09       

   DISPLAY BY NAME g_aeii1.aeii00,g_aeii1.aeii01,g_aeii1.aeii02,
                   g_aeii1.aeii021,g_aeii1.aeii03,g_aeii1.aeii031,
                   g_aeii1.aeii04,g_aeii1.aeii05,g_aeii1.aeii06,
                   g_aeii1.aeii07,g_aeii1.aeii08,g_aeii1.aeii09,
                   g_aeii1.aeii18
                  ,g_aeii1.aeii19,g_aeii1.aeii20    #FUN-BA0111
                  ,g_aeii1.aeii21,g_aeii1.aeii22    #FUN-BA0111
   SELECT axz03,axz04,axz05 INTO g_axz03,g_axz04,g_axz05 FROM axz_file   
    WHERE axz01 = g_aeii1.aeii02  
   
#FUN-A30122 --Begin
#  LET g_plant_new = g_axz03      #營運中心
#  CALL s_getdbs()
#  LET g_dbs_axz03 = g_dbs_new    #所屬DB

#  IF g_axz04 = 'N' THEN  #不使用tiptop
#     LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#  ELSE
#     SELECT axa09 INTO l_axa09 FROM axa_file
#      WHERE axa01 = g_aeii1.aeii01
#        AND axa02 = g_aeii1.aeii02
#     IF l_axa09 = 'Y' THEN
#        SELECT axz03 INTO g_axz03 FROM axz_file WHERE  axz01 = g_aeii1.aeii02
#        LET g_plant_new = g_axz03
#        CALL s_getdbs()
#        LET g_dbs_axz03 = g_dbs_new
#     ELSE
#        LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#     END IF
#  END IF  
#  LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",                                                                      
#              " WHERE aaz00 = '0'"                                                                                               
#  PREPARE q006_pre FROM g_sql                                                                                                    
#  DECLARE q006_cur CURSOR FOR q006_pre                                                                                           
#  OPEN q006_cur                                                                                                                  
#  FETCH q006_cur INTO g_aeii1.aeii00    #合并後帳別
#  IF cl_null(g_aeii1.aeii00) THEN
#      CALL cl_err(g_axz03,'agl-601',1)
#  END IF
   CALL s_aaz641_dbs(g_aeii1.aeii01,g_aeii1.aeii02) RETURNING g_plant_axz03   #FUN-A30122 g_dbs_axz03--> g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aeii1.aeii00                  #FUN-A30122 g_dbs_axz03--> g_plant_axz03
#FUN-A30122 --End   
#  LET g_sql ="SELECT aag02 FROM ",g_dbs_axz03,"aag_file ",   #FUN-A30122
   LET g_sql ="SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),  #FUN-30122 
              " WHERE aag00 = '",g_aeii1.aeii00,"'",
              "   AND aag01 = '",g_aeii1.aeii04,"'",
              "   AND aagacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
   CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql    #FUN-A30122
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
   DEFINE l_total   LIKE aeii_file.aeii12   #FUN-AB0028

   LET l_total = 0    #FUN-AB0028

   LET l_sql =
       #"SELECT '',aeii11, aeii12",
       "SELECT '',aeii11, aeii12,(aeii11-aeii12) ",   #FUN-AB0028
       "  FROM aeii_file",
       " WHERE aeii04 = '",g_aeii1.aeii04,"'",
       "   AND aeii00 = '",g_aeii1.aeii00,"' AND aeii01 = '",g_aeii1.aeii01,"'",
       "   AND aeii02 = '",g_aeii1.aeii02,"' AND aeii021 = '",g_aeii1.aeii021,"'",
       "   AND aeii03 = '",g_aeii1.aeii03,"' AND aeii031= '",g_aeii1.aeii031,"'",
       "   AND aeii05 = '",g_aeii1.aeii05,"' AND aeii06 = '",g_aeii1.aeii06,"'",
       "   AND aeii07 = '",g_aeii1.aeii07,"' AND aeii08 = '",g_aeii1.aeii08,"'",
       "   AND aeii09 = '",g_aeii1.aeii09,"' AND aeii18 = '",g_aeii1.aeii18,"'",
       "   AND aeii10 =?"
      ,"   AND aeii19 = '",g_aeii1.aeii19,"' AND aeii20 = '",g_aeii1.aeii20,"'"     #FUN-BA0111 add
      ,"   AND aeii21 = '",g_aeii1.aeii21,"' AND aeii22 = '",g_aeii1.aeii22,"'"     #FUN-BA0111 add
   PREPARE q006_pb FROM l_sql
   DECLARE q006_bcs CURSOR FOR q006_pb          #BODY CURSOR

   CALL g_aeii.clear()
   LET g_rec_b=0
   LET g_cnt = 0
   FOR g_cnt = 1 TO 14
      LET g_i = g_cnt - 1
      OPEN q006_bcs USING g_i    #由第０期開始抓
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      FETCH q006_bcs INTO g_aeii[g_cnt].*
      IF SQLCA.SQLCODE THEN
         LET g_aeii[g_cnt].aeii11 = 0
         LET g_aeii[g_cnt].aeii12 = 0
      END IF
      IF g_i = 0 THEN
         CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
         LET g_aeii[g_cnt].seq = g_msg CLIPPED
      ELSE 
         LET g_aeii[g_cnt].seq = g_i
      END IF
      IF cl_null(g_aeii[g_cnt].amt) THEN LET g_aeii[g_cnt].amt = 0  END IF  #FUN-AB0028
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
   DISPLAY ARRAY g_aeii TO s_aeii.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
        l_aeii  RECORD
                 aeii15   LIKE aeii_file.aeii15,
                 aeii01   LIKE aeii_file.aeii01,
                 aeii00   LIKE aeii_file.aeii00,
                 aeii04   LIKE aeii_file.aeii04,
                 aeii05   LIKE aeii_file.aeii05,
                 aeii06   LIKE aeii_file.aeii06,
                 aeii07   LIKE aeii_file.aeii07,
                 aeii08   LIKE aeii_file.aeii08,
                 aeii09   LIKE aeii_file.aeii09,
                 aeii18   LIKE aeii_file.aeii18,
                 aeii02   LIKE aeii_file.aeii02,
                 aeii021  LIKE aeii_file.aeii021,
                 aeii03   LIKE aeii_file.aeii03,
                 aeii031  LIKE aeii_file.aeii031,
                 aeii10   LIKE aeii_file.aeii10
                ,aeii19   LIKE aeii_file.aeii19        #FUN-BA0111 add
                ,aeii20   LIKE aeii_file.aeii20        #FUN-BA0111 add
                ,aeii21   LIKE aeii_file.aeii21        #FUN-BA0111 add
                ,aeii22   LIKE aeii_file.aeii22        #FUN-BA0111 add
                END RECORD,
        l_aeii1 DYNAMIC ARRAY OF RECORD
                 aeii11   LIKE aeii_file.aeii10,
                 aeii12   LIKE aeii_file.aeii11,
                 seq     LIKE ze_file.ze03
                END RECORD,
        l_chr   LIKE type_file.chr1,
        l_aag02 LIKE aag_file.aag02
    DEFINE l_axa09        LIKE axa_file.axa09   
    IF tm.wc IS NULL THEN
       CALL cl_err('',-400,0) 
       RETURN
    END IF
    CALL cl_wait()
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
                                                AND aaf02 = g_lang
    # 組合出 SQL 指令
    LET g_sql="SELECT UNIQUE aeii15,aeii01,aeii00,aeii04,aeii05,aeii06,aeii07,aeii08,",
              "              aeii09,aeii18,aeii02,aeii021,aeii03,aeii031,'' ",
              "             ,aeii19,aeii20,aeii21,aeii22 ",                    #FUN-BA0111 add
              "  FROM aeii_file,OUTER aag_file ",
              " WHERE aeii04=aag_file.aag01",
              "   AND aeii00=aag_file.aag00",
              "   AND ",tm.wc CLIPPED
    PREPARE q006_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q006_co CURSOR FOR q006_p1

    LET l_sql1="SELECT aeii11,aeii12,(aeii11-aeii12)",
               "  FROM aeii_file",
               " WHERE aeii15 = ?  AND aeii00 = ? AND aeii01 = ? ",
               "   AND aeii02 = ?  AND aeii021= ? AND aeii03 = ? ",
               "   AND aeii031= ?  AND aeii04 = ? AND aeii05 = ? ",
               "   AND aeii06 = ?  AND aeii07 = ? AND aeii08 = ? ",
               "   AND aeii09 = ?  AND aeii18 = ? "
              ,"   AND aeii19 = ?  AND aeii20 = ? AND aeii21 = ? AND aeii22 = ?"       #FUN-BA0111
    PREPARE q006_p2 FROM l_sql1               # RUNTIME 編譯
    DECLARE q006_c1 CURSOR FOR q006_p2

    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
    CALL cl_del_data(l_table)                                             
    #------------------------------ CR (2) ------------------------------#

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

    LET m_cnt = 0
    FOREACH q006_co INTO l_aeii.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_cnt=1 TO l_aeii1.getLength()
           INITIALIZE l_aeii1[g_cnt].* TO NULL
       END FOR
       FOR g_cnt = 1 TO 14
          LET l_aeii.aeii10 = g_cnt - 1
          OPEN q006_c1 USING l_aeii.aeii15,l_aeii.aeii00,l_aeii.aeii01,
                             l_aeii.aeii02,l_aeii.aeii021,l_aeii.aeii03,
                             l_aeii.aeii031,l_aeii.aeii04,l_aeii.aeii05,
                             l_aeii.aeii06,l_aeii.aeii07,l_aeii.aeii08,
                             l_aeii.aeii09,l_aeii.aeii18
                            ,l_aeii.aeii19,l_aeii.aeii20,l_aeii.aeii21,l_aeii.aeii22   #FUN-BA0111
          CALL s_get_bookno(l_aeii.aeii09) RETURNING g_flag,g_bookno1,g_bookno2
          SELECT axz03,axz04,axz05 INTO g_axz03,g_axz04,g_axz05 FROM axz_file  
           WHERE axz01 = l_aeii.aeii02
          
#FUN-A30122 --Begin
#         LET g_plant_new = g_axz03      #營運中心
#         CALL s_getdbs()
#         LET g_dbs_axz03 = g_dbs_new    #所屬DB

#         IF g_axz04 = 'N' THEN  #不使用tiptop
#            LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#         ELSE
#            SELECT axa09 INTO l_axa09 FROM axa_file
#             WHERE axa01 = l_aeii.aeii01
#               AND axa02 = l_aeii.aeii02
#            IF l_axa09 = 'Y' THEN
#               SELECT axz03 INTO g_axz03 FROM axz_file WHERE  axz01 = l_aeii.aeii02
#               LET g_plant_new = g_axz03
#               CALL s_getdbs()
#               LET g_dbs_axz03 = g_dbs_new
#            ELSE
#               LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#            END IF
#         END IF
#         LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#                     " WHERE aaz00 = '0'"
#         PREPARE q006_pre1 FROM g_sql DECLARE q006_cur1 CURSOR FOR q006_pre1
#         OPEN q006_cur1
#         FETCH q006_cur1 INTO l_aeii.aeii00    #合并後帳別
#         IF cl_null(l_aeii.aeii00) THEN
#            CALL cl_err(g_axz03,'agl-601',1)
#         END IF
          CALL s_aaz641_dbs(l_aeii.aeii01,l_aeii.aeii02) RETURNING g_plant_axz03   #FUN-A30122 g_dbs_axz03--->g_plant_axz03
          CALL s_get_aaz641(g_plant_axz03) RETURNING l_aeii.aeii00                 #FUN-A30122 g_dbs_axz03--->g_plant_axz03  
#FUN-A30122 --End          
      #   LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",   #FUN-A30122
          LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),    #FUN-A30122 
                      " WHERE aag01 = '",l_aeii.aeii04,"'",
                      "   AND aagacti = 'Y' ",
                      "   AND aag00 = '",l_aeii.aeii00,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
          CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql          #FUN-A30122 
          PREPARE q006_pre_2  FROM g_sql
          DECLARE q006_c_2 CURSOR FOR q006_pre_2
          OPEN q006_c_2
          FETCH q006_c_2 INTO l_aag02

          IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF
          FETCH q006_c1 INTO l_aeii1[g_cnt].*
          IF SQLCA.sqlcode THEN
             LET l_aeii1[g_cnt].aeii11 = 0
             LET l_aeii1[g_cnt].aeii12 = 0
          END IF

          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
          EXECUTE insert_prep USING
             l_aeii.aeii15,l_aeii.aeii01,l_aeii.aeii00,l_aeii.aeii04,
             l_aeii.aeii05,l_aeii.aeii06,l_aeii.aeii07,l_aeii.aeii08,
             l_aeii.aeii09,l_aeii.aeii18,l_aeii.aeii02,l_aeii.aeii021,
             l_aeii.aeii03,l_aeii.aeii031,l_aeii.aeii10,
             l_aeii1[g_cnt].aeii11,l_aeii1[g_cnt].aeii12,l_aag02
            ,l_aeii.aeii19,l_aeii.aeii20,l_aeii.aeii21,l_aeii.aeii22		  #FUN-BA0111
          #-------------------------- CR (3) --------------------------#

          LET m_cnt = m_cnt + 1
          INITIALIZE l_aeii.* TO NULL
          CLOSE q006_bcs
       END FOR
    END FOREACH
    CLOSE q006_co
    ERROR ""
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'aeii01,aeii00,aeii02,aeii021,aeii03,aeii031,aeii09,aeii18,aeii04,aeii05,aeii06,aeii07,aeii08,aeii19,aeii20,aeii21,aeii22')   #FUN-BA0111 mod
            RETURNING tm.wc
    END IF
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    LET g_str = tm.wc,";",g_azi04
    CALL cl_prt_cs3('aglq006','aglq006',g_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
#FUN-A10015
