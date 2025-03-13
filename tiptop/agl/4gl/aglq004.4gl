# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq004.4gl
# Descriptions...: 合併後科目異動碼沖帳餘額查詢
# Date & Author..: 09/01/02 BY Sarah
# Modify.........: No:FUN-910002 09/01/02 By Sarah 新增"合併後科目異動碼沖帳餘額查詢"
# Modify.........: No:FUN-930136 09/03/23 By jamie _cs()不join aag_file 
# Modify.........: No:FUN-950111 09/06/08 By lutingting選aag02時還應考慮axa09
# Modify.........: No:FUN-970045 09/07/21 By chenmoyan 取消余額欄位
# Modify.........: No:MOD-9C0382 09/12/23 By Sarah 修改PREPARE q004_pre_1的g_sql,WHERE條件調整aag00=g_axkk1.axkk00
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 合并帐别/合并资料库的抓法改为CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No.FUN-9B0017 10/08/30 By chenmoyan 去掉版本欄位
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.TQC-B90035 11/09/05 By guoch axkk01开窗报错bug修改，p_qry中无q_axkk
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006
DEFINE tm       RECORD
                 wc       STRING                  # Head Where condition
                END RECORD,
       g_axkk1  RECORD
#                axkk15   LIKE axkk_file.axkk15,  #FUN-9B0017
                 axkk01   LIKE axkk_file.axkk01,
                 axkk00   LIKE axkk_file.axkk00,
                 axkk05   LIKE axkk_file.axkk05,
                 axkk06   LIKE axkk_file.axkk06,
                 axkk07   LIKE axkk_file.axkk07,
                 axkk08   LIKE axkk_file.axkk08,
                 axkk14   LIKE axkk_file.axkk14,
                 axkk02   LIKE axkk_file.axkk02,
                 axkk03   LIKE axkk_file.axkk03,
                 axkk04   LIKE axkk_file.axkk04,
                 axkk041  LIKE axkk_file.axkk041
                END RECORD,
       g_axkk   DYNAMIC ARRAY OF RECORD
                 seq      LIKE ze_file.ze03,
                 axkk10   LIKE axkk_file.axkk10,
                 axkk11   LIKE axkk_file.axkk11,     #No.FUN-970045
                 summ     LIKE axkk_file.axkk10     #No.FUN-970045   #FUN-AB0028 mod
                END RECORD,
       m_cnt              LIKE type_file.num10,
       g_argv1            LIKE axkk_file.axkk00,  #INPUT ARGUMENT - 1
       g_bookno           LIKE aaa_file.aaa01,    #帳別
       g_wc,g_sql         STRING,                 #WHERE CONDITION
       l_total            LIKE axkk_file.axkk10,  #No.FUN-970045   #FUN-AB0028 mod
       p_row,p_col        LIKE type_file.num5,
       g_rec_b            LIKE type_file.num5     #單身筆數
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_i                LIKE type_file.num5     #count/index for any purpose
DEFINE g_msg              LIKE ze_file.ze03
DEFINE g_row_count        LIKE type_file.num10
DEFINE g_curs_index       LIKE type_file.num10
DEFINE g_jump             LIKE type_file.num10
DEFINE g_no_ask          LIKE type_file.num5
DEFINE g_bookno1          LIKE aza_file.aza81   
DEFINE g_bookno2          LIKE aza_file.aza82
DEFINE g_flag             LIKE type_file.chr1
DEFINE l_table            STRING                                                                 
DEFINE g_str              STRING
DEFINE g_axz03            LIKE axz_file.axz03       #FUN-930136 add
DEFINE g_axz05            LIKE axz_file.axz05       #FUN-930136 add
DEFINE g_dbs_axz03        LIKE type_file.chr21      #FUN-930136 add
DEFINE g_plant_axz03      LIKE type_file.chr21      #FUN-A30122 add
DEFINE g_axz04            LIKE axz_file.axz04       #FUN-950111 add

MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_bookno = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   ### *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "axkk15.axkk_file.axkk15,axkk01.axkk_file.axkk01,",
               "axkk00.axkk_file.axkk00,axkk05.axkk_file.axkk05,",
               "axkk06.axkk_file.axkk06,axkk07.axkk_file.axkk07,",
               "axkk08.axkk_file.axkk08,axkk14.axkk_file.axkk14,",
               "axkk02.axkk_file.axkk02,axkk03.axkk_file.axkk03,",
               "axkk04.axkk_file.axkk04,axkk041.axkk_file.axkk041,",
               "axkk09.axkk_file.axkk09,axkk10.axkk_file.axkk10,",
#              "axkk11.axkk_file.axkk11,summ.axkk_file.axkk10,",      #No.FUN-970045
               "axkk11.axkk_file.axkk11,",                            #No.FUN-970045
               "l_aag02.aag_file.aag02,m_cnt.type_file.num10"
   LET l_table = cl_prt_temptable('aglq004',g_sql) CLIPPED   # 產生Temp Table                                                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"        #No.FUN-970045
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"      #No.FUN-970045
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
   END IF                                                                                                                          

   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   IF cl_null(g_bookno) THEN LET g_bookno=g_aaz.aaz64 END IF
   CALL s_dsmark(g_bookno)
   IF cl_null(g_bookno) THEN LET g_bookno=g_aaz.aaz64 END IF

   OPEN WINDOW q004_w WITH FORM "agl/42f/aglq004"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   CALL cl_ui_init()

   CALL q004_menu()
   CLOSE FORM q004_w                      #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q004_cs()
   DEFINE l_cnt LIKE type_file.num5

   CLEAR FORM #清除畫面
   CALL g_axkk.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_axkk1.* TO NULL
   # 螢幕上取單頭條件
   CONSTRUCT BY NAME tm.wc ON
#     axkk15,axkk01,axkk00,axkk02,axkk03,axkk04,axkk041, #FUN-9B0017
      axkk01,axkk00,axkk02,axkk03,axkk04,axkk041,        #FUN-9B0017
      axkk08,axkk14,axkk05,axkk06,axkk07
      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axkk01) #族群編號
                 CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_axkk"  #TQC-B90035 mark
                 LET g_qryparam.form = "q_axh"  #TQC-B90035 add
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axkk01
                 NEXT FIELD axkk01
            WHEN INFIELD(axkk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axkk05
            WHEN INFIELD(axkk14) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_axkk1.axkk14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axkk14
                 NEXT FIELD axkk14
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF

   #====>資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql=
#      "SELECT UNIQUE axkk15,axkk00,axkk01,axkk02,axkk03,axkk04,axkk041,", #FUN-9B0017
       "SELECT UNIQUE axkk00,axkk01,axkk02,axkk03,axkk04,axkk041,",        #FUN-9B0017
       "              axkk05,axkk06,axkk07,axkk08,axkk14",
      #"  FROM axkk_file,aag_file ",  #FUN-930136 mark
       "  FROM axkk_file ",           #FUN-930136 mod
      #" WHERE aag01=axkk05 AND aag00=axkk00 AND ",tm.wc CLIPPED,    #FUN-930136 mark
       " WHERE ",tm.wc CLIPPED,                                      #FUN-930136 mod
#      " ORDER BY axkk15,axkk01,axkk02,axkk03,axkk04,axkk05,axkk06,axkk07,axkk08" #FUN-9B0017
       " ORDER BY axkk01,axkk02,axkk03,axkk04,axkk05,axkk06,axkk07,axkk08"        #FUN-9B0017
   PREPARE q004_prepare FROM g_sql
   DECLARE q004_cs SCROLL CURSOR WITH HOLD FOR q004_prepare    #SCROLL CURSOR

   DROP TABLE x
   LET g_sql=
#      "SELECT UNIQUE axkk15,axkk01,axkk00,axkk02,axkk03,axkk04,axkk041,",#FUN-9B0017
       "SELECT UNIQUE axkk01,axkk00,axkk02,axkk03,axkk04,axkk041,",       #FUN-9B0017
       "              axkk05,axkk06,axkk07,axkk08,axkk14",
      #"  FROM axkk_file,aag_file ",   #FUN-930136 mark
       "  FROM axkk_file ",            #FUN-930136 mod
       " WHERE ",tm.wc CLIPPED,
      #"   AND aag01 = axkk05 AND aag00=axkk00",  #FUN-930136 mark
       "  INTO TEMP x"
   PREPARE q004_prepare_pre FROM g_sql
   EXECUTE q004_prepare_pre
   DECLARE q004_count CURSOR FOR
   SELECT COUNT(*) FROM x
END FUNCTION

FUNCTION q004_menu()
   WHILE TRUE
      CALL q004_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q004_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q004_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axkk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q004_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axkk.clear()
   CALL q004_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q004_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q004_count
      FETCH q004_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q004_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q004_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
#      WHEN 'N' FETCH NEXT     q004_cs INTO g_axkk1.axkk15,g_axkk1.axkk00, #FUN-9B0017
       WHEN 'N' FETCH NEXT     q004_cs INTO g_axkk1.axkk00,                #FUN-9B0017
                                            g_axkk1.axkk01,g_axkk1.axkk02,
                                            g_axkk1.axkk03,g_axkk1.axkk04,
                                            g_axkk1.axkk041,g_axkk1.axkk05,
                                            g_axkk1.axkk06,g_axkk1.axkk07,
                                            g_axkk1.axkk08,g_axkk1.axkk14
#      WHEN 'P' FETCH PREVIOUS q004_cs INTO g_axkk1.axkk15,g_axkk1.axkk00, #FUN-9B0017
       WHEN 'P' FETCH NEXT     q004_cs INTO g_axkk1.axkk00,                #FUN-9B0017
                                            g_axkk1.axkk01,g_axkk1.axkk02,
                                            g_axkk1.axkk03,g_axkk1.axkk04,
                                            g_axkk1.axkk041,g_axkk1.axkk05,
                                            g_axkk1.axkk06,g_axkk1.axkk07,
                                            g_axkk1.axkk08,g_axkk1.axkk14
#      WHEN 'F' FETCH PREVIOUS q004_cs INTO g_axkk1.axkk15,g_axkk1.axkk00, #FUN-9B0017
       WHEN 'F' FETCH NEXT     q004_cs INTO g_axkk1.axkk00,                #FUN-9B0017
                                            g_axkk1.axkk01,g_axkk1.axkk02,
                                            g_axkk1.axkk03,g_axkk1.axkk04,
                                            g_axkk1.axkk041,g_axkk1.axkk05,
                                            g_axkk1.axkk06,g_axkk1.axkk07,
                                            g_axkk1.axkk08,g_axkk1.axkk14
#      WHEN 'L' FETCH PREVIOUS q004_cs INTO g_axkk1.axkk15,g_axkk1.axkk00, #FUN-9B0017
       WHEN 'L' FETCH NEXT     q004_cs INTO g_axkk1.axkk00,                #FUN-9B0017
                                            g_axkk1.axkk01,g_axkk1.axkk02,
                                            g_axkk1.axkk03,g_axkk1.axkk04,
                                            g_axkk1.axkk041,g_axkk1.axkk05,
                                            g_axkk1.axkk06,g_axkk1.axkk07,
                                            g_axkk1.axkk08,g_axkk1.axkk14
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
#          FETCH ABSOLUTE g_jump q004_cs INTO g_axkk1.axkk15,g_axkk1.axkk00, #FUN-9B0017
           FETCH ABSOLUTE g_jump q004_cs INTO g_axkk1.axkk00,                #FUN-9B0017
                                              g_axkk1.axkk01,g_axkk1.axkk02,
                                              g_axkk1.axkk03,g_axkk1.axkk04,
                                              g_axkk1.axkk041,g_axkk1.axkk05,
                                              g_axkk1.axkk06,g_axkk1.axkk07,
                                              g_axkk1.axkk08,g_axkk1.axkk14
           LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_axkk1.axkk02,SQLCA.sqlcode,0)
       INITIALIZE g_axkk1.* TO NULL
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
    CALL s_get_bookno(g_axkk1.axkk08)  RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag='1' THEN   #抓不到帳套
       CALL cl_err(g_axkk1.axkk08,'aoo-081',1)
    END IF
    CALL q004_show()
END FUNCTION

FUNCTION q004_show()
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_axa09    LIKE axa_file.axa09         #FUN-950111 add 

#  DISPLAY BY NAME g_axkk1.axkk15,g_axkk1.axkk00,g_axkk1.axkk01,g_axkk1.axkk02, #FUN-9B0017
   DISPLAY BY NAME g_axkk1.axkk00,g_axkk1.axkk01,g_axkk1.axkk02,                #FUN-9B0017
                   g_axkk1.axkk03,g_axkk1.axkk04,g_axkk1.axkk041,g_axkk1.axkk05,
                   g_axkk1.axkk06,g_axkk1.axkk07,g_axkk1.axkk08,g_axkk1.axkk14
  #FUN-930136---mod---str---
   SELECT axz03,axz04,axz05 INTO g_axz03,g_axz04,g_axz05 FROM axz_file   #FUN-950111 add axz04
    WHERE axz01 = g_axkk1.axkk02   
 
   LET g_plant_new = g_axz03      #營運中心
   CALL s_getdbs()
   LET g_dbs_axz03 = g_dbs_new    #所屬DB

#FUN-A30122 -----------------------mark start--------------------------------   
#  #FUN-950111--mod--str--
#  IF g_axz04 = 'N' THEN  #不使用tiptop
#     LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#     LET g_plant_new = g_plant   #FUN-A50102
#  ELSE
#     SELECT axa09 INTO l_axa09 FROM axa_file
#      WHERE axa01 = g_axkk1.axkk01
#        AND axa02 = g_axkk1.axkk02
#     IF l_axa09 = 'Y' THEN
#        SELECT axz03 INTO g_axz03 FROM axz_file WHERE  axz01 = g_axkk1.axkk02
#        LET g_plant_new = g_axz03
#        CALL s_getdbs()
#        LET g_dbs_axz03 = g_dbs_new
#     ELSE
#        LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#        LET g_plant_new = g_plant   #FUN-A50102
#     END IF
#  END IF  
# #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102                                                                    
#  LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
#              " WHERE aaz00 = '0'"                                                                                               
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#  PREPARE q004_pre FROM g_sql                                                                                                    
#  DECLARE q004_cur CURSOR FOR q004_pre                                                                                           
#  OPEN q004_cur                                                                                                                  
#  FETCH q004_cur INTO g_axkk1.axkk00    #合并後帳別                                                                                
#  IF cl_null(g_axkk1.axkk00) THEN                                                                                                  
#      CALL cl_err(g_axz03,'agl-601',1)                                                                                           
#  END IF  
#FUN-A30122 --------------------------------mark end----------------------------------------
   CALL s_aaz641_dbs(g_axkk1.axkk01,g_axkk1.axkk02) RETURNING g_plant_axz03              #FUN-A30122 add
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_axkk1.axkk00                             #FUN-A30122 add
   LET g_plant_new = g_plant_axz03                                                       #FUN-A30122 add    
  #LET g_sql ="SELECT aag02 FROM ",g_dbs_axz03,"aag_file ",   #FUN-A50102
   LET g_sql ="SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
             #" WHERE aag00 = '",g_axz05,"'",         #MOD-9C0382 mark
              " WHERE aag00 = '",g_axkk1.axkk00,"'",  #MOD-9C0382  
              "   AND aag01 = '",g_axkk1.axkk05,"'",  
              "   AND aagacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE q004_pre_1  FROM g_sql
   DECLARE q004_c_1 CURSOR FOR q004_pre_1 

   FOREACH q004_c_1 INTO l_aag02
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

  #SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_axkk1.axkk05
  #                                          AND aag00 = g_axkk1.axkk00
  #                                             AND aagacti = 'Y'
   END FOREACH 
  #FUN-930136---mod---end---
   IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
   DISPLAY l_aag02 TO aag02
   CALL q004_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q004_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_n       LIKE type_file.num5

   LET l_sql =
      "SELECT '',axkk10, axkk11,(axkk10-axkk11)",      #No.FUN-970045    #FUN-AB0028
#       "SELECT '',axkk10, axkk11",                      #No.FUN-970045
       "  FROM axkk_file",
       " WHERE axkk05 = '",g_axkk1.axkk05,"'",
       "   AND axkk00 = '",g_axkk1.axkk00,"' AND axkk01 = '",g_axkk1.axkk01,"'",
       "   AND axkk02 = '",g_axkk1.axkk02,"' AND axkk03 = '",g_axkk1.axkk03,"'",
       "   AND axkk04 = '",g_axkk1.axkk04,"' AND axkk041= '",g_axkk1.axkk041,"'",
       "   AND axkk05 = '",g_axkk1.axkk05,"' AND axkk06 = '",g_axkk1.axkk06,"'",
       "   AND axkk07 = '",g_axkk1.axkk07,"' AND axkk08 = '",g_axkk1.axkk08,"'",
       "   AND axkk14 = '",g_axkk1.axkk14,"'",
#      "   AND axkk15 = '",g_axkk1.axkk15,"'",          #FUN-9B0017
       "   AND axkk09 =?"
   PREPARE q004_pb FROM l_sql
   DECLARE q004_bcs CURSOR FOR q004_pb          #BODY CURSOR

   CALL g_axkk.clear()
   LET g_rec_b=0
   LET g_cnt = 0
   LET l_total = 0                              #No.FUN-970045  #FUN-AB0028 mod
   FOR g_cnt = 1 TO 14
      LET g_i = g_cnt - 1
      OPEN q004_bcs USING g_i    #由第０期開始抓
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      FETCH q004_bcs INTO g_axkk[g_cnt].*
      IF SQLCA.SQLCODE THEN
         LET g_axkk[g_cnt].axkk10 = 0
         LET g_axkk[g_cnt].axkk11 = 0
         LET g_axkk[g_cnt].summ  = 0            #No.FUN-970045  #FUN-AB0028 mod
      END IF
      IF g_i = 0 THEN
         CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
         LET g_axkk[g_cnt].seq = g_msg CLIPPED
      ELSE 
         LET g_axkk[g_cnt].seq = g_i
      END IF
#     LET l_total = l_total + g_axkk[g_cnt].summ#No.FUN-970045
#     LET g_axkk[g_cnt].summ = l_total          #No.FUN-970045
      CLOSE q004_bcs
   END FOR
   LET g_rec_b=g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q004_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axkk TO s_axkk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL q004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL q004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL q004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
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

FUNCTION q004_out()
    DEFINE
        l_i     LIKE type_file.num5,
        l_sql1  STRING,
        l_name  LIKE type_file.chr20,    # External(Disk) file name
        l_axkk  RECORD
                 axkk15   LIKE axkk_file.axkk15,
                 axkk01   LIKE axkk_file.axkk01,
                 axkk00   LIKE axkk_file.axkk00,
                 axkk05   LIKE axkk_file.axkk05,
                 axkk06   LIKE axkk_file.axkk06,
                 axkk07   LIKE axkk_file.axkk07,
                 axkk08   LIKE axkk_file.axkk08,
                 axkk14   LIKE axkk_file.axkk14,
                 axkk02   LIKE axkk_file.axkk02,
                 axkk03   LIKE axkk_file.axkk03,
                 axkk04   LIKE axkk_file.axkk04,
                 axkk041  LIKE axkk_file.axkk041,
                 axkk09   LIKE axkk_file.axkk09
                END RECORD,
        l_axkk1 DYNAMIC ARRAY OF RECORD
                 axkk10   LIKE axkk_file.axkk10,
                 axkk11   LIKE axkk_file.axkk11,
#                summ    LIKE axkk_file.axkk10,  #No.FUN-970045
                 seq     LIKE ze_file.ze03
                END RECORD,
        l_chr   LIKE type_file.chr1,
        l_aag02 LIKE aag_file.aag02
    DEFINE l_axa09        LIKE axa_file.axa09    #FUN-950111
    IF tm.wc IS NULL THEN
       CALL cl_err('',-400,0) 
       RETURN
    END IF
    CALL cl_wait()
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
                                                AND aaf02 = g_lang
    # 組合出 SQL 指令
    LET g_sql="SELECT UNIQUE axkk15,axkk01,axkk00,axkk05,axkk06,axkk07,axkk08,",
              "              axkk14,axkk02,axkk03,axkk04,axkk041,'' ",
              "  FROM axkk_file,OUTER aag_file ",
              " WHERE axkk05=aag_file.aag01",
              "   AND axkk00=aag_file.aag00",
              "   AND ",tm.wc CLIPPED
    PREPARE q004_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q004_co CURSOR FOR q004_p1

    LET l_sql1="SELECT axkk10,axkk11,(axkk10-axkk11)",
               "  FROM axkk_file",
               " WHERE axkk15 = ?  AND axkk00 = ? AND axkk01 = ? ",
               "   AND axkk02 = ?  AND axkk03 = ? AND axkk04 = ? ",
               "   AND axkk041= ?  AND axkk05 = ? AND axkk06 = ? ",
               "   AND axkk07 = ?  AND axkk08 = ? AND axkk09 = ? ",
               "   AND axkk14 = ? "
    PREPARE q004_p2 FROM l_sql1               # RUNTIME 編譯
    DECLARE q004_c1 CURSOR FOR q004_p2

    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
    CALL cl_del_data(l_table)                                             
    #------------------------------ CR (2) ------------------------------#

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

#   LET l_total = 0         #No.FUN-970045
    LET m_cnt = 0
    FOREACH q004_co INTO l_axkk.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#      LET l_total=0        #No.FUN-970045
       FOR g_cnt=1 TO l_axkk1.getLength()
           INITIALIZE l_axkk1[g_cnt].* TO NULL
       END FOR
       FOR g_cnt = 1 TO 14
          LET l_axkk.axkk09 = g_cnt - 1
          OPEN q004_c1 USING l_axkk.axkk15,l_axkk.axkk00,l_axkk.axkk01,
                             l_axkk.axkk02,l_axkk.axkk03,l_axkk.axkk04,
                             l_axkk.axkk041,l_axkk.axkk05,l_axkk.axkk06,
                             l_axkk.axkk07,l_axkk.axkk08,l_axkk.axkk09,
                             l_axkk.axkk14
          CALL s_get_bookno(l_axkk.axkk08) RETURNING g_flag,g_bookno1,g_bookno2
          #FUN-950111--mod--str--                                                                                                        
          SELECT axz03,axz04,axz05 INTO g_axz03,g_axz04,g_axz05 FROM axz_file  
           WHERE axz01 = l_axkk.axkk02    
          LET g_plant_new = g_axz03      #營運中心                                                                                         
          CALL s_getdbs()                                                                                                                  
          LET g_dbs_axz03 = g_dbs_new    #所屬DB                                                                                           
                                                                                                                                    
#FUN-A30122 -------------------mark start-------------------------------------
#         IF g_axz04 = 'N' THEN  #不使用tiptop                                                                                             
#            LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)                                                                                      
#            LET g_plant_new = g_plant   #FUN-A50102
#         ELSE                                                                                                                             
#            SELECT axa09 INTO l_axa09 FROM axa_file                                                                                       
#             WHERE axa01 = l_axkk.axkk01                                                                                                 
#               AND axa02 = l_axkk.axkk02                                                                                                 
#            IF l_axa09 = 'Y' THEN                                                                                                         
#               SELECT axz03 INTO g_axz03 FROM axz_file WHERE  axz01 = l_axkk.axkk02                                                      
#               LET g_plant_new = g_axz03                                                                                                  
#               CALL s_getdbs()                                                                                                            
#               LET g_dbs_axz03 = g_dbs_new                                                                                                   
#            ELSE                                                                                                                          
#               LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)                                                                                   
#               LET g_plant_new = g_plant   #FUN-A50102
#            END IF                                                                                                                        
#         END IF                                                                                                                           
#        #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
#         LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102                                                                        
#                     " WHERE aaz00 = '0'"                                                                                                 
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#         PREPARE q004_pre1 FROM g_sql
#         DECLARE q004_cur1 CURSOR FOR q004_pre1                                                                                            
#         OPEN q004_cur1                                                                                                                    
#         FETCH q004_cur1 INTO l_axkk.axkk00    #合并後帳別                                                                                
#         IF cl_null(l_axkk.axkk00) THEN                                                                                                  
#            CALL cl_err(g_axz03,'agl-601',1)                                                                                             
#         END IF                                                                                                                           
#FUN-A30122 -----------------------------------mark end------------------------------------------
          CALL s_aaz641_dbs(l_axkk.axkk01,l_axkk.axkk02) RETURNING g_plant_axz03               #FUN-A30122 add
          CALL s_get_aaz641(g_plant_axz03) RETURNING l_axkk.axkk00                             #FUN-A30122 add
          LET g_plant_new = g_plant_axz03                                                      #FUN-A30122 add 
         #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",   #FUN-A50102                                                                         
          LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                      " WHERE aag01 = '",l_axkk.axkk05,"'",                                                                               
                      "   AND aagacti = 'Y' ",                                                                                             
                      "   AND aag00 = '",l_axkk.axkk00,"'"                                                                                
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
          PREPARE q004_pre_2  FROM g_sql                                                                                                     
          DECLARE q004_c_2 CURSOR FOR q004_pre_2
          OPEN q004_c_2
          FETCH q004_c_2 INTO l_aag02                                                                                               
                                                                                                                                    
          #SELECT aag02 INTO l_aag02 FROM aag_file
          # WHERE aag01=l_axkk.axkk05 AND aagacti='Y' AND aag00=g_bookno1
          #FUN-950111--mod--end
          IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF                             
          FETCH q004_c1 INTO l_axkk1[g_cnt].*
          IF SQLCA.sqlcode THEN
             LET l_axkk1[g_cnt].axkk10 = 0
             LET l_axkk1[g_cnt].axkk11 = 0
#            LET l_axkk1[g_cnt].summ = 0         #No.FUN-970045
          END IF
#         LET l_total=l_total+l_axkk1[g_cnt].summ#No.FUN-970045
#         LET l_axkk1[g_cnt].summ = l_total      #No.FUN-970045

          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##                                                      
          EXECUTE insert_prep USING                                                                                                  
             l_axkk.axkk15,l_axkk.axkk01,l_axkk.axkk00,l_axkk.axkk05,
             l_axkk.axkk06,l_axkk.axkk07,l_axkk.axkk08,l_axkk.axkk14,
             l_axkk.axkk02,l_axkk.axkk03,l_axkk.axkk04,l_axkk.axkk041,
             l_axkk.axkk09,l_axkk1[g_cnt].axkk10,l_axkk1[g_cnt].axkk11,
             l_aag02,m_cnt   #No.FUN-970045
#            l_axkk1[g_cnt].summ,l_aag02,m_cnt   #No.FUN-970045
          #-------------------------- CR (3) --------------------------#

          LET m_cnt = m_cnt + 1
          CLOSE q004_bcs
       END FOR
    END FOREACH
    CLOSE q004_co
    ERROR ""
    IF g_zz05 = 'Y' THEN                                                                                                          
       CALL cl_wcchp(tm.wc,'axkk15,axkk01,axkk00,axkk02,axkk03,axkk04,axkk041,axkk08,axkk14,axkk05,axkk06,axkk07')                                        
            RETURNING tm.wc                                                                                                       
    END IF                                                                                                                        
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_azi04                                                                                                   
    CALL cl_prt_cs3('aglq004','aglq004',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
#FUN-910002
#Patch....NO:TQC-610035 <001> #
