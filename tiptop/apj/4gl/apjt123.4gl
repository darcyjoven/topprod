# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: apjt123.4gl
# Descriptions...: WBS本階預計費用維護作業
# Modify.........: No.FUN-790025 07/10/26 By dxfwo            
# Modify.........: No.TQC-840009 08/04/07 By dxfwo        取消錄入
# Modify.........: No.FUN-930106 09/03/18 By destiny pjda02 增加管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/07/30 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9A0075 09/10/26 By wujie     5.2转sql标准语法
# Modify.........: No.MOD-AC0342 10/12/27 By vealxu 輸完費用代碼後將科目(azf07)帶出至科目編號(pjda03)
# Modify.........: No.FUN-B10052 11/01/26 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds    #No.FUN-790025---Begin 
 
GLOBALS "../../config/top.global"
 
DEFINE   g_pjda01          LIKE pjda_file.pjda01,   # 類別代號 (假單頭)
         g_pjda02          LIKE pjda_file.pjda02,   # No.FUN-9A0075
         g_pjda01_t        LIKE pjda_file.pjda01,   # 類別代號 (假單頭)
         g_pjdauser        LIKE pjda_file.pjdauser,
         g_pjdagrup        LIKE pjda_file.pjdagrup,
         g_pjdamodu        LIKE pjda_file.pjdamodu,
         g_pjdadate        LIKE pjda_file.pjdadate,
         g_pjdaacti        LIKE pjda_file.pjdaacti,
         g_pjda_lock RECORD LIKE pjda_file.*,      # FOR LOCK CURSOR TOUCH
         g_pjda    DYNAMIC ARRAY of RECORD        # 程式變數
            pjda02          LIKE pjda_file.pjda02,
            azf03           LIKE azf_file.azf03,
            pjda03          LIKE pjda_file.pjda03,
            aag02           LIKE aag_file.aag02,   
            pjda04          LIKE pjda_file.pjda04,
            aag13           LIKE aag_file.aag02,                       
            pjda05          LIKE pjda_file.pjda05 
                      END RECORD,
         g_pjda_t           RECORD                 # 變數舊值
            pjda02          LIKE pjda_file.pjda02,
            azf03           LIKE azf_file.azf03,
            pjda03          LIKE pjda_file.pjda03,
            aag02           LIKE aag_file.aag02,   
            pjda04          LIKE pjda_file.pjda04,
            aag13           LIKE aag_file.aag02,                       
            pjda05          LIKE pjda_file.pjda05 
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  string,  #No.FUN-580092 HCN
         g_sql                 string,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b               LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE pjb_file.pjb01
DEFINE   g_argv2               LIKE pjda_file.pjda01
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_std_id              LIKE smb_file.smb01     #No.FUN-710055
DEFINE   g_db_type             LIKE type_file.chr3     #No.FUN-760049
DEFINE   l_table               STRING
DEFINE   g_str                 STRING
DEFINE   g_chr1                LIKE type_file.chr1 
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_sql="pjb01.pjb_file.pjb01,",   
             "pja02.pja_file.pja02,",   
             "pjda01.pjda_file.pjda01,",   
             "pjb03.pjb_file.pjb03,",   
             "pjb15.pjb_file.pjb15,",   
             "pjb16.pjb_file.pjb16,",
             "pja14.pja_file.pja14,",   
             "pja15.pja_file.pja15,",   
             "pjda02.pjda_file.pjda02,", 
             "azf03.azf_file.azf03,",
             "pjda03.pjda_file.pjda03,", 
             "aag02.aag_file.aag02,",   
             "pjda04.pjda_file.pjda04,",   
             "aag13.aag_file.aag13,",     
             "pjda05.pjda_file.pjda05"
   LET l_table = cl_prt_temptable('apjt123',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_pjda01_t = NULL
 
   OPEN WINDOW t123_w WITH FORM "apj/42f/apjt123"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
   LET g_wc = '1=1'                                                                                                                
   CALL t123_b_fill(g_wc)                                                                                                          
   LET g_action_choice=""
 
    IF g_aza.aza63 = 'N' THEN 
    CALL cl_set_comp_visible("pjda04,aag13",FALSE)
    END IF   
 
   LET g_db_type=cl_db_get_database_type()   #No.FUN-760049
 
   LET g_forupd_sql = "SELECT * from pjda_file ",
                      "  WHERE pjda01 = ?  ",  #No.FUN-710055
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t123_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
   SELECT count(*) INTO g_chr1 FROM pjda_file WHERE pjda01 = g_argv2 
      IF g_chr1 > 0 THEN                                                                                                              
         CALL t123_q()                                                                                                              
      ELSE                                                                                                                        
         CALL t123_pjda01('a')                                                                                                       
         CALL t123_b()                                                                                                              
      END IF 
   END IF
   LET g_action_choice = ""
   CALL t123_menu() 
 
   CLOSE WINDOW t123_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION t123_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   IF cl_null(g_argv1) AND cl_null(g_argv2) THEN
   CALL g_pjda.clear()
   #資料權限的檢查                                                                                                                  
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料                                                                
   #      LET g_wc = g_wc clipped," AND pjdauser = '",g_user,"'"                                                                        
   #   END IF                                                                                                                           
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料                                                              
   #      LET g_wc = g_wc clipped," AND pjdagrup MATCHES '",g_grup CLIPPED,"*'"                                                         
   #   END IF                                                                                                                           
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限                                                                          
   #      LET g_wc = g_wc clipped," AND pjdagrup IN ",cl_chk_tgrup_list()                                                               
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('jdauser', 'jdagrup')
   #End:FUN-980030
 
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT  g_wc ON pjda01,pjdauser, pjda02,pjda03,pjda04,pjda05,
                         pjdagrup,pjdamodu,pjdadate,pjdaacti                   #螢幕上取單身條件                                                       
                    FROM pjda01,tb4[1].pjda02,tb4[1].pjda03,tb4[1].pjda04,tb4[1].pjda05,
                           pjdauser,pjdagrup,pjdamodu,pjdadate,pjdaacti
 
         BEFORE CONSTRUCT                                                                                                           
            CALL cl_qbe_init() 
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(pjda01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjb02"
                  LET g_qryparam.state = "c"
                 #LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjda01
                  NEXT FIELD pjda01
                  
               WHEN INFIELD(pjda02)
                  CALL cl_init_qry_var()                                                                                           
                 #LET g_qryparam.form ="q_azf"                     #No.FUN-930106
                  LET g_qryparam.form ="q_azf01a"                  #No.FUN-930106
                  LET g_qryparam.state = "c"                                                                                     
                 #LET g_qryparam.arg1='2'                          #No.FUN-930106                                            
                  LET g_qryparam.arg1='7'                          #No.FUN-930106                                            
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                  DISPLAY g_qryparam.multiret TO pjda02            #No.MOD-490371                                                     
                  NEXT FIELD pjda02
   
               WHEN INFIELD(pjda03)                                                                                                    
                  CALL cl_init_qry_var()                                                                                                 
                  LET g_qryparam.form ="q_aag11"                                                                                           
                  LET g_qryparam.state = "c"                                                                         
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
                  DISPLAY g_qryparam.multiret TO pjda03            #No.MOD-490371                                                        
                  NEXT FIELD pjda03
      
               WHEN INFIELD(pjda04)                                                                                                    
                  CALL cl_init_qry_var()                                                                                                 
                  LET g_qryparam.form ="q_aag11"                                                                                           
                  LET g_qryparam.state = "c"                                                                          
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
                  DISPLAY g_qryparam.multiret TO pjda04            #No.MOD-490371                                                        
                  NEXT FIELD pjda04                  
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
      END CONSTRUCT
 
   ELSE
      LET g_wc = "pjda01 = '",g_argv2 CLIPPED,"' "
  END IF
 
      IF INT_FLAG THEN RETURN END IF
 
   #No.FUN-760049 --start--
#     LET g_sql="SELECT  pjda01 FROM pjda_file ",
      LET g_sql="SELECT  pjda01,pjda02 FROM pjda_file ",   #No.FUN-9A0075
                " WHERE ",g_wc CLIPPED
 
   PREPARE t123_prepare FROM g_sql          # 預備一下
   DECLARE t123_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR t123_prepare
 
    LET g_sql="SELECT COUNT(*) FROM pjda_file",                                                                                      
              " WHERE ",g_wc CLIPPED                                                                                                
    PREPARE t123_precount FROM g_sql                                                                                                
    DECLARE t123_count CURSOR FOR t123_precount 
 
END FUNCTION
 
FUNCTION t123_menu()
 
   WHILE TRUE
      CALL t123_bp("G")
 
      CASE g_action_choice
#        WHEN "insert"                          # A.輸入  #No.TQC-840009
#           IF cl_chk_act_auth() THEN                     #No.TQC-840009     
#              CALL t123_a()                              #No.TQC-840009 
#           END IF                                        #No.TQC-840009  
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL t123_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL t123_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL t123_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL t123_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t123_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL t123_out()                                                                                                      
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjda),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t123_a()                            # Add  輸入
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN 
    RETURN
   END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_pjda.clear()  
 
   INITIALIZE g_pjda01 LIKE pjda_file.pjda01         # 預設值及將數值類變數清成零
#  INITIALIZE g_gaz03 LIKE gaz_file.gaz03         # 預設值及將數值類變數清成零
#  INITIALIZE g_pjda11 LIKE pjda_file.pjda11
#  INITIALIZE g_pjda12 LIKE pjda_file.pjda12         #No.FUN-710055
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_pjdauser=g_user                                                                                                      
      LET g_pjdagrup=g_grup                                                                                                      
      LET g_pjdadate=g_today                                                                                                     
      LET g_pjdaacti='Y'              #資料有效 
      CALL t123_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_pjda01=NULL
         LET g_pjda02=NULL    #No.FUN-9A0075
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
#     IF cl_null(g_pjda.pjda01) THEN       # KEY 不可空白                                                                             
#        CONTINUE WHILE                                                                                                             
#     END IF 
 
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_pjda.clear()
      ELSE
         CALL t123_b_fill('1=1')             # 單身
      END IF
 
      CALL t123_b()                          # 輸入單身
      LET g_pjda01_t=g_pjda01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t123_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_ss = 'Y'
 
   DISPLAY g_pjdauser,g_pjdamodu,                                                                                     
       g_pjdagrup,g_pjdadate,g_pjdaacti
   TO pjdauser,pjdamodu,pjdagrup,pjdadate,pjdaacti
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_pjda01 WITHOUT DEFAULTS FROM pjda01
 
      AFTER INPUT
         IF NOT cl_null(g_pjda01) THEN
            IF g_pjda01 != g_pjda01_t OR cl_null(g_pjda01_t) THEN
               SELECT COUNT(UNIQUE pjda01) INTO g_cnt FROM pjda_file
                WHERE pjda01 = g_pjda01 
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     CALL cl_err(g_pjda01,-239,0)                                                                                   
                     LET g_pjda01 = g_pjda01_t                                                                                      
                     NEXT FIELD pjda01 
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_pjda01,-239,0)
                     LET g_pjda01 = g_pjda01_t
                     NEXT FIELD pjda01
                  END IF
               END IF
               CALL t123_pjda01(p_cmd)      
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjda01,g_errno,0)
                  NEXT FIELD pjda01
               END IF
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjda01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjb02"
           #   LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1= g_pjda01
               CALL cl_create_qry() RETURNING g_pjda01
               NEXT FIELD pjda01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
END FUNCTION
 
 
FUNCTION t123_u()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_pjda01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjda01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602','')
      RETURN
   END IF
#No.FUN-960038 --End
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pjda01_t = g_pjda01
#  LET g_pjda11_t = g_pjda11
#  LET g_pjda12_t = g_pjda12    #No.FUN-710055
 
   BEGIN WORK
   OPEN t123_lock_u USING g_pjda01 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE t123_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t123_lock_u INTO g_pjda_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("pjda01 LOCK:",SQLCA.sqlcode,1)
      CLOSE t123_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
         LET g_pjdamodu=g_user                                                                                                      
         LET g_pjdadate=g_today           
      CALL t123_i("u")
      IF INT_FLAG THEN
         LET g_pjda01 = g_pjda01_t
#        LET g_pjda11 = g_pjda11_t
#        LET g_pjda12 = g_pjda12_t       #No.FUN-710055
 
         DISPLAY g_pjda01 TO pjda01   
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE pjda_file SET pjda01 = g_pjda01 
       WHERE pjda01 = g_pjda01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_pjda01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","pjda_file",g_pjda01_t,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION t123_q()                            #Query 查詢
 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CLEAR FORM  #NO.TQC-740075
   CALL g_pjda.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL t123_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
#     INITIALIZE g_pjda.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t123_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_pjda01 TO NULL
#     INITIALIZE g_gaz03 TO NULL
#     INITIALIZE g_pjda11 TO NULL
#     INITIALIZE g_pjda12 TO NULL                 #No.FUN-710055
#     LET g_gaz03 = ""
   ELSE
      OPEN t123_count
      FETCH t123_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t123_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t123_fetch(p_flag)                      #處理資料的讀取
   DEFINE   p_flag       LIKE type_file.chr1,    #處理方式     #No.FUN-680135 VARCHAR(1) 
            l_abso       LIKE type_file.num10,   #絕對的筆數   #No.FUN-680135 INTEGER
            l_pjdauser   LIKE pjda_file.pjdauser,  #FUN-4C0057  add                                                                        
            l_pjdagrup   LIKE pjda_file.pjdagrup   #FUN-4C0057  add                
 
   MESSAGE ""
   CASE p_flag
#No.FUN-9A0075 --begin
      WHEN 'N' FETCH NEXT     t123_b_curs INTO g_pjda01,g_pjda02   
      WHEN 'P' FETCH PREVIOUS t123_b_curs INTO g_pjda01,g_pjda02   
      WHEN 'F' FETCH FIRST    t123_b_curs INTO g_pjda01,g_pjda02   
      WHEN 'L' FETCH LAST     t123_b_curs INTO g_pjda01,g_pjda02   
#     WHEN 'N' FETCH NEXT     t123_b_curs INTO g_pjda01 
#     WHEN 'P' FETCH PREVIOUS t123_b_curs INTO g_pjda01 
#     WHEN 'F' FETCH FIRST    t123_b_curs INTO g_pjda01 
#     WHEN 'L' FETCH LAST     t123_b_curs INTO g_pjda01 
#No.FUN-9A0075 --end
      WHEN '/' 
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t123_b_curs INTO g_pjda01,g_pjda02  #No.FUN-9A0075 add pjda02
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjda01,SQLCA.sqlcode,0)
      INITIALIZE g_pjda01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump         # --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF 
 
 
    SELECT pjda01,pjdaacti,pjdauser,pjdagrup,pjdamodu,pjdadate
      INTO g_pjda01,g_pjdaacti,g_pjdauser,
           g_pjdagrup,g_pjdamodu,g_pjdadate
      FROM pjda_file
#No.FUN-9A0075 --begin
#    WHERE ROWID = g_pjda_rowid
     WHERE pjda01= g_pjda01
       AND pjda02= g_pjda02
#No.FUN-9A0075 --end
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","pjda_file",g_pjda01,"",SQLCA.sqlcode,"","",1)
       INITIALIZE g_pjda01 TO NULL
       RETURN
    END IF
    LET g_data_owner = l_pjdauser      #FUN-4C0057 add
    LET g_data_group = l_pjdagrup      #FUN-4C0057 add
      CALL t123_show()
END FUNCTION
 
 
FUNCTION t123_show()                         # 將資料顯示在畫面上
   LET g_pjda01_t = g_pjda01                 #保存單頭舊值                                                                            
 
   DISPLAY g_pjda01 TO pjda01
   DISPLAY g_pjdaacti TO pjdaacti
   DISPLAY g_pjdauser TO pjdauser
   DISPLAY g_pjdagrup TO pjdagrup
   DISPLAY g_pjdamodu TO pjdamodu
   DISPLAY g_pjdadate TO pjdadate
  
   CALL t123_pjda01('d')
   CALL t123_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION
 
FUNCTION t123_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_pjda   RECORD LIKE pjda_file.*
           ,l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_pjda01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjda01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602','')
      RETURN
   END IF
#No.FUN-960038 --End
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM pjda_file
       WHERE pjda01 = g_pjda01 
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","pjda_file",g_pjda01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_pjda.clear()
         OPEN t123_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t123_b_curs
            CLOSE t123_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t123_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t123_b_curs
            CLOSE t123_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t123_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t123_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No:FUN-6A0080
            CALL t123_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION t123_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 CHAR(1)
            l_azf03         LIKE azf_file.azf03,
            l_aag02         LIKE aag_file.aag02,
            l_aag13         LIKE aag_file.aag02,
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 CHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
   DEFINE   l_count         LIKE type_file.num5                #FUN-680135    SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   l_azf09         LIKE azf_file.azf09                #No.FUN-930106
   DEFINE   l_pjaclose      LIKE pja_file.pjaclose             #No.FUN-960038
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_pjda01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
    IF g_pjdaacti ='N' THEN    #檢查資料是否為無效                                                                               
       CALL cl_err(g_pjda01,'aim-502',0)                                                                                         
       RETURN                                                                                                                       
    END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjda01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602','')
      RETURN
   END IF
#No.FUN-960038 --End
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT pjda02,'',pjda03,'',pjda04,'',pjda05 ",
                     "  FROM pjda_file",
                     " WHERE pjda01 = ? AND pjda02 = ?  ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t123_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_pjda WITHOUT DEFAULTS FROM tb4.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_pjda_t.* = g_pjda[l_ac].*    #BACKUP
            OPEN t123_bcl USING g_pjda01,g_pjda_t.pjda02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN t123_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH t123_bcl INTO g_pjda[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH t123_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
             SELECT azf03 INTO g_pjda[l_ac].azf03 FROM azf_file WHERE azf01 = g_pjda[l_ac].pjda02 
                AND azf02='2'                                         #No.FUN-930106                                             
             SELECT aag02 INTO g_pjda[l_ac].aag02 FROM aag_file 
              WHERE aag01 = g_pjda[l_ac].pjda03 AND aag00 = g_aza.aza81                                             
             SELECT aag13 INTO g_pjda[l_ac].aag13 FROM aag_file 
              WHERE aag01 = g_pjda[l_ac].pjda04 AND aag00 = g_aza.aza81                                             
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjda[l_ac].* TO NULL       #900423
         LET g_pjda[l_ac].pjda05 = '0'                                                                                                      
         LET g_pjda_t.* = g_pjda[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD pjda02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO pjda_file(pjda01,pjda02,pjda03,pjda04,pjda05,pjdauser,pjdagrup,
                               pjdamodu,pjdadate,pjdaacti,pjdaoriu,pjdaorig)                        #No:FUN-710055
                      VALUES (g_pjda01,g_pjda[l_ac].pjda02,g_pjda[l_ac].pjda03,
                              g_pjda[l_ac].pjda04,g_pjda[l_ac].pjda05,g_pjdauser,
                              g_pjdagrup,g_pjdamodu,g_pjdadate,g_pjdaacti, g_user, g_grup)        #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_pjda01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","pjda_file",g_pjda01,g_pjda[l_ac].pjda02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cnt2
         END IF
 
      AFTER FIELD pjda02
       IF NOT cl_null(g_pjda[l_ac].pjda02) THEN                                                                                   
          IF g_pjda[l_ac].pjda02 != g_pjda_t.pjda02                                                                                 
             OR g_pjda_t.pjda02 IS NULL THEN                                                                                      
             SELECT count(*) INTO l_n FROM azf_file 
               WHERE azf01 = g_pjda[l_ac].pjda02             
                 AND azf02 ='2'                        #No.FUN-930106                                                                                           
              IF l_n = 0 THEN
                 CALL cl_err('','apj-007',0)
                 NEXT FIELD pjda02
              END IF  
             #No.FUN-930106--begin
             SELECT azf09 INTO l_azf09 FROM azf_file 
               WHERE azf01=g_pjda[l_ac].pjda02
                 AND azf02='2'
             IF l_azf09 !='7' THEN 
                CALL cl_err('','aoo-406',0)                                                                                        
                LET g_pjda[l_ac].pjda02 = g_pjda_t.pjda02                                                                           
                NEXT FIELD pjda02
             END IF 
             #No.FUN-930106--end
             SELECT count(*)                                                                                                    
               INTO l_n                                                                                                         
               FROM pjda_file                                                                                                    
              WHERE pjda01 = g_pjda01                                                                                             
                AND pjda02 = g_pjda[l_ac].pjda02                                                                                  
             IF l_n > 0 THEN                                                                                                    
                CALL cl_err('',-239,0)                                                                                          
                LET g_pjda[l_ac].pjda02 = g_pjda_t.pjda02                                                                           
                NEXT FIELD pjda02                                                                                                
             ELSE    
               #MOD-AC0342 ----------mod start------------------------- 
               #SELECT azf03 INTO g_pjda[l_ac].azf03 FROM azf_file   
               # WHERE azf01 = g_pjda[l_ac].pjda02         
               #   AND azf02='2'                             #No.FUN-930106                                
               #DISPLAY g_pjda[l_ac].azf03 TO azf03
                SELECT azf03,azf07,aag02 INTO g_pjda[l_ac].azf03,g_pjda[l_ac].pjda03,g_pjda[l_ac].aag02
                  FROM azf_file LEFT OUTER JOIN aag_file ON azf07 = aag01 AND aag00 = g_aza.aza81
                 WHERE azf01 = g_pjda[l_ac].pjda02
                   AND azf02='2'  
                DISPLAY BY NAME g_pjda[l_ac].azf03,g_pjda[l_ac].pjda03,g_pjda[l_ac].aag02
               #MOD-AC0342 ----------mod end-----------------------------
             END IF
           END IF
       END IF  
 
      AFTER FIELD pjda03                                                                                                            
       IF NOT cl_null(g_pjda[l_ac].pjda03) THEN                                                                                     
          IF g_pjda[l_ac].pjda03 != g_pjda_t.pjda03                                                                                 
             OR g_pjda_t.pjda03 IS NULL THEN                                                                                        
             SELECT count(*) INTO l_n FROM aag_file 
               WHERE aag01 = g_pjda[l_ac].pjda03                                                                                                        
              IF l_n = 0 THEN
                 CALL cl_err('','agl-916',0)
#FUN-B10052 --begin--                                                                                                 
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form ="q_aag11"     
             LET g_qryparam.default1 = g_pjda[l_ac].pjda03  
             LET g_qryparam.construct = 'N'
             LET g_qryparam.where = " aag01 LIKE '",g_pjda[l_ac].pjda03 CLIPPED,"%'"
             CALL cl_create_qry() RETURNING g_pjda[l_ac].pjda03 
             DISPLAY g_pjda[l_ac].pjda03 TO pjda03 
#FUN-B10052 --end--                 
                 NEXT FIELD pjda03
              END IF  
             SELECT count(*)                                                                                                        
               INTO l_n                                                                                                             
               FROM pjda_file                                                                                                       
              WHERE pjda01 = g_pjda01                                                                                               
                AND pjda03 = g_pjda[l_ac].pjda03                                                                                    
             IF l_n > 0 THEN                                                                                                        
                CALL cl_err('',-239,0)                                                                                              
                LET g_pjda[l_ac].pjda03 = g_pjda_t.pjda03                                                                           
                NEXT FIELD pjda03                                                                                                   
             ELSE                                                                                                                   
             SELECT aag02 INTO g_pjda[l_ac].aag02 FROM aag_file
              WHERE aag01 = g_pjda[l_ac].pjda03  AND aag00 = g_aza.aza81                                             
             DISPLAY BY NAME g_pjda[l_ac].aag02                                                                                        
             END IF                                                                                                                 
           END IF                                                                                                                   
       END IF

      AFTER FIELD pjda04                                                                                                            
       IF NOT cl_null(g_pjda[l_ac].pjda04) THEN                                                                                     
          IF g_pjda[l_ac].pjda04 != g_pjda_t.pjda04                                                                                
             OR g_pjda_t.pjda04 IS NULL THEN                                                                                        
             SELECT count(*) INTO l_n FROM aag_file 
               WHERE aag01 = g_pjda[l_ac].pjda04                                                                                                        
              IF l_n = 0 THEN
                 CALL cl_err('','agl-916',0)
#FUN-B10052 --begin--
             CALL cl_init_qry_var()                                
             LET g_qryparam.form ="q_aag11"                                   
             LET g_qryparam.default1 = g_pjda[l_ac].pjda04  
             LET g_qryparam.construct = 'N'
             LET g_qryparam.where = " aag01 LIKE '",g_pjda[l_ac].pjda04 CLIPPED,"%'"
             CALL cl_create_qry() RETURNING g_pjda[l_ac].pjda04   
             DISPLAY g_pjda[l_ac].pjda04 TO pjda04 
#FUN-B10052 --end--        
                 NEXT FIELD pjda04
              END IF  
             SELECT count(*)                                                                                                        
               INTO l_n                                                                                                             
               FROM pjda_file                                                                                                       
              WHERE pjda01 = g_pjda01                                                                                               
                AND pjda04 = g_pjda[l_ac].pjda04                                                                                    
             IF l_n > 0 THEN                                                                                                        
                CALL cl_err('',-239,0)                                                                                              
                LET g_pjda[l_ac].pjda04 = g_pjda_t.pjda04                                                                           
                NEXT FIELD pjda04                                                                                                   
             ELSE                                                                                                                   
             SELECT aag13 INTO g_pjda[l_ac].aag13 FROM aag_file 
              WHERE aag01 = g_pjda[l_ac].pjda04 AND aag00 = g_aza.aza81                                             
             DISPLAY BY NAME g_pjda[l_ac].aag13                                                                                        
             END IF                                                                                                                 
           END IF                                                                                                                   
       END IF
 
      AFTER FIELD pjda05                                                                                                            
       IF NOT cl_null(g_pjda[l_ac].pjda05) THEN                                                                                     
          IF g_pjda[l_ac].pjda05 != g_pjda_t.pjda05                                                                                 
             OR g_pjda_t.pjda04 IS NULL THEN
               IF g_pjda[l_ac].pjda05 < 0 THEN
                CALL cl_err('','axc-207',0)
                 NEXT FIELD pjda05  
               END IF
          END IF
       END IF  
             
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_pjda_t.pjda02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM pjda_file WHERE pjda01 = g_pjda01
                                    AND pjda02 = g_pjda_t.pjda02    
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_pjda_t.pjda02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","pjda_file",g_pjda01,g_pjda_t.pjda02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cnt2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pjda[l_ac].* = g_pjda_t.*
            CLOSE t123_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
#        IF l_gau01 > 0 THEN
#           CALL cl_err("g_pjda[l_ac].pjda02","azz-083",1)
#        END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjda[l_ac].pjda02,-263,1)
            LET g_pjda[l_ac].* = g_pjda_t.*
         ELSE
            UPDATE pjda_file
               SET pjda02 = g_pjda[l_ac].pjda02,
                   pjda03 = g_pjda[l_ac].pjda03,
                   pjda04 = g_pjda[l_ac].pjda04,
                   pjda05 = g_pjda[l_ac].pjda05 
             WHERE pjda01 = g_pjda01
               AND pjda02 = g_pjda_t.pjda02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_pjda[l_ac].pjda02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","pjda_file",g_pjda01,g_pjda_t.pjda02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_pjda[l_ac].* = g_pjda_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_pjda[l_ac].* = g_pjda_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjda.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t123_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t123_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(pjda02) AND l_ac > 1 THEN
            LET g_pjda[l_ac].* = g_pjda[l_ac-1].*
            NEXT FIELD pjda02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pjda02)
             CALL cl_init_qry_var()                                                                                           
            #LET g_qryparam.form ="q_azf"                     #No.FUN-930106                                                                                    
             LET g_qryparam.form ="q_azf01a"                  #No.FUN-930106                                                                    
            #LET g_qryparam.arg1='2'                          #No.FUN-930106
             LET g_qryparam.arg1='7'                          #No.FUN-930106
             LET g_qryparam.default1 = g_pjda[l_ac].pjda02                                                                      
             CALL cl_create_qry() RETURNING g_pjda[l_ac].pjda02                                                                 
             DISPLAY g_pjda[l_ac].pjda02 TO pjda02            #No:MOD-490371                                                     
             NEXT FIELD pjda02
 
            WHEN INFIELD(pjda03)                                                                                                    
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form ="q_aag11"                                                                                           
             LET g_qryparam.default1 = g_pjda[l_ac].pjda03                                                                         
             CALL cl_create_qry() RETURNING g_pjda[l_ac].pjda03                                                                     
             DISPLAY g_pjda[l_ac].pjda03 TO pjda03            #No:MOD-490371                                                        
             NEXT FIELD pjda03
 
            WHEN INFIELD(pjda04)                                                                                                    
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form ="q_aag11"                                                                                           
             LET g_qryparam.default1 = g_pjda[l_ac].pjda04                                                                          
             CALL cl_create_qry() RETURNING g_pjda[l_ac].pjda04                                                                     
             DISPLAY g_pjda[l_ac].pjda04 TO pjda04            #No:MOD-490371                                                        
             NEXT FIELD pjda04
 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------     
 
   END INPUT
 
   CLOSE t123_bcl
   COMMIT WORK
END FUNCTION
 
 
#FUNCTION t123_chk_gau(p_lang)
#  DEFINE p_lang LIKE type_file.chr1    #FUN-680135 CHAR(1)
#  DEFINE p_ac   LIKE type_file.num5    #FUN-680135 SMALLINT
#  CASE p_lang
#     WHEN "0" SELECT COUNT(*) INTO p_ac FROM gau_file
#               WHERE gau01=g_pjda[l_ac].pjda03
#                 AND gau03=g_pjda[l_ac].pjda04
#  END CASE
#  IF p_ac > 0 THEN  #有就是一樣
#     RETURN TRUE
#  ELSE
#     RETURN FALSE
#  END IF
#END FUNCTION
 
FUNCTION t123_b_fill(p_wc)               #BODY FILL UP
   DEFINE p_wc         LIKE type_file.chr1000 #No.FUN-680135 CHAR(300)
   DEFINE p_ac         LIKE type_file.num5    #FUN-680135    SMALLINT
 
    LET g_sql = "SELECT pjda02,'',pjda03,'',pjda04,'',pjda05 ",
                 " FROM pjda_file ",
                " WHERE pjda01 = '",g_pjda01 CLIPPED,"' ",
                 " AND ",p_wc CLIPPED,
                " ORDER BY pjda02"
 
    PREPARE t123_prepare2 FROM g_sql           #預備一下
    DECLARE pjda_curs CURSOR FOR t123_prepare2
 
    CALL g_pjda.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH pjda_curs INTO g_pjda[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        
      SELECT azf03 INTO g_pjda[g_cnt].azf03 FROM azf_file 
       WHERE azf01 = g_pjda[g_cnt].pjda02
         AND azf02 = '2'                                     #No.FUN-930106
       IF SQLCA.sqlcode THEN                                                                                                        
         CALL cl_err3("sel","azf_file",g_pjda[g_cnt].azf03,"",SQLCA.sqlcode,"","",0)                                                 
         LET g_pjda[g_cnt].azf03 = NULL                                                                                              
       END IF 
 
      SELECT aag02 INTO g_pjda[g_cnt].aag02 FROM aag_file
       WHERE aag01 = g_pjda[g_cnt].pjda03
#      IF SQLCA.sqlcode THEN                                                                                                        
#        CALL cl_err3("sel","aag_file",g_pjda[g_cnt].aag02,"",SQLCA.sqlcode,"","",0)                                                
#        LET g_pjda[g_cnt].aag02 = NULL                                                                                             
#      END IF        
 
      SELECT aag13 INTO g_pjda[g_cnt].aag13 FROM aag_file                                                                           
       WHERE aag01 = g_pjda[g_cnt].pjda04                                                                                           
#      IF SQLCA.sqlcode THEN                                                                                                        
#        CALL cl_err3("sel","aag_file",g_pjda[g_cnt].aag13,"",SQLCA.sqlcode,"","",0)                                                
#        LET g_pjda[g_cnt].aag13 = NULL                                                                                             
#      END IF    
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pjda.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t123_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 CHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_pjda TO tb4.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
#     ON ACTION insert                           # A.輸入  #No.TQC-840009
#        LET g_action_choice='insert'                      #No.TQC-840009   
#        EXIT DISPLAY                                      #No.TQC-840009                   
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice='delete'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION output                                                                                                              
         LET g_action_choice="output"                                                                                               
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
#        LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL t123_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL t123_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL t123_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL t123_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL t123_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
#        CALL t123_set_combobox()              #No:FUN-760049
#        CALL cl_set_combo_industry("pjda12")        #No:FUN-750068
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
#        # 2004/03/24 新增語言別選項
#        CALL cl_set_combo_lang("pjda03")
#        EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#      ON ACTION showlog             #MOD-440464
#        LET g_action_choice = "showlog"
#        EXIT DISPLAY
 
      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t123_copy()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE pjda_file.pjda01,
#           l_new11   LIKE pjda_file.pjda11,
#           l_new12   LIKE pjda_file.pjda12,          #No:FUN-710055
            l_old01   LIKE pjda_file.pjda01 
#           l_old11   LIKE pjda_file.pjda11,
#           l_old12   LIKE pjda_file.pjda12           #No:FUN-710055
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_pjda01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01 WITHOUT DEFAULTS FROM pjda01   #No:FUN-710055
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(l_new01) THEN
            NEXT FIELD pjda01
         END IF
          SELECT COUNT(*) INTO g_cnt FROM pjda_file
           WHERE pjda01 = l_new01 # AND pjda11 = l_new11 AND pjda12 = l_new12   #No:FUN-710055
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"azz-110",l_new01,10)
          END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
#     DISPLAY g_pjda01,g_pjda11,g_gaz03,g_pjda12 TO pjda01,pjda11,gaz03,pjda12   #No:FUN-710055
      DISPLAY g_pjda01 TO pjda01 #No:FUN-710055
      RETURN
   END IF
 
   DROP TABLE x
#FUN-4C0020
   SELECT * FROM pjda_file 
     WHERE pjda01=g_pjda01 and (pjda02 NOT IN   #No:FUN-710055
     (SELECT pjda02 FROM pjda_file WHERE pjda01=l_new01)    #No:FUN-710055
     or( pjda02 IN (SELECT pjda02 FROM pjda_file WHERE pjda01=l_new01)))  #No:FUN-710055
   INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_pjda01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_pjda01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET pjda01 = l_new01                         # 資料鍵值
 
   INSERT INTO pjda_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('pjda:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","pjda_file",l_new01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_pjda01
#  LET l_old11 = g_pjda11
#  LET l_old12 = g_pjda12   #No:FUN-710055
   LET g_pjda01 = l_new01
#  LET g_pjda11 = l_new11
#  LET g_pjda12 = l_new12   #No:FUN-710055
   CALL t123_b()
   #LET g_pjda01 = l_old01  #FUN-C80046
#  LET g_pjda11 = l_old11
#  LET g_pjda12 = l_old12   #No:FUN-710055
   #CALL t123_show()        #FUN-C80046
END FUNCTION
 
#No:FUN-760049 --start--
#FUNCTION t123_set_combobox()
#  DEFINE   lc_smb01    LIKE smb_file.smb01
#  DEFINE   lc_smb03    LIKE smb_file.smb03
#  DEFINE   ls_value    STRING
#  DEFINE   ls_desc     STRING
 
#  LET g_sql = "SELECT UNIQUE smb01,smb03 FROM smb_file WHERE smb02='",g_lang CLIPPED,"'"
#  PREPARE smb_pre FROM g_sql
#  DECLARE smb_curs CURSOR FOR smb_pre
#  FOREACH smb_curs INTO lc_smb01,lc_smb03
#     IF lc_smb01 = "std" THEN
#        LET ls_value = lc_smb01,",",ls_value
#        LET ls_desc = lc_smb01,":",lc_smb03,",",ls_desc
#     ELSE
#        LET ls_value = ls_value,lc_smb01,","
#        LET ls_desc = ls_desc,lc_smb01,":",lc_smb03,","
#     END IF
#  END FOREACH
#  CALL cl_set_combo_items("pjda12",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
#END FUNCTION
#No:FUN-760049 ---end--
FUNCTION t123_pjda01(p_cmd)  #幣別                                                                                                   
   DEFINE l_pjb01   LIKE pjb_file.pjb01,                                                                                            
          l_pjb03   LIKE pjb_file.pjb03,                                                                                            
          l_pja02   LIKE pja_file.pja02,                                                                                            
          l_pjb15   LIKE pjb_file.pjb15,                                                                                            
          l_pjb16   LIKE pjb_file.pjb16,                                                                                            
          l_pja14   LIKE pja_file.pja14,                                                                                            
          l_pja15   LIKE pja_file.pja15,                                                                                            
          l_pjda01  LIKE pjda_file.pjda01,                                                                                          
          p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)                                                                
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN                                                                              
   SELECT pjb03,pjb15,pjb16,pja02,pja14,pja15                                                                                 
     INTO l_pjb03,l_pjb15,l_pjb16,l_pja02,l_pja14,l_pja15                                                                   
     FROM pjb_file,pja_file WHERE pja01=pjb01 AND pjb01 = g_argv1  AND pjb02 =g_argv2
      AND pjaclose = 'N'               #No.FUN-960038
   ELSE
   SELECT pjb01,pjb03,pjb15,pjb16,pja02,pja14,pja15                                                                                 
     INTO l_pjb01,l_pjb03,l_pjb15,l_pjb16,l_pja02,l_pja14,l_pja15                                                                 
     FROM pjb_file,pja_file WHERE pja01 =pjb01 AND pjb02 =g_pjda01                                                                                       
      AND pjaclose = 'N'               #No.FUN-960038
   END IF 
                                                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'                                                                           
        WHEN g_pjdaacti='N'  LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN
         LET l_pjb01 = g_argv1                                                                                                      
         LET g_pjda01 = g_argv2                                                                                                      
         DISPLAY g_pjda01 TO pjda01                                                                                                   
      END IF 
      DISPLAY l_pjb01 TO FORMONLY.pjb01 
      DISPLAY l_pjb03 TO FORMONLY.pjb03 
      DISPLAY l_pjb15 TO FORMONLY.pjb15 
      DISPLAY l_pjb16 TO FORMONLY.pjb16 
      DISPLAY l_pja02 TO FORMONLY.pja02 
      DISPLAY l_pja14 TO FORMONLY.pja14 
      DISPLAY l_pja15 TO FORMONLY.pja15 
   END IF                                                                                                                           
 
END FUNCTION
 
FUNCTION t123_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    sr              RECORD
            pjb01           LIKE pjb_file.pjb01,
            pja02           LIKE pja_file.pja02,
            pjda01          LIKE pjda_file.pjda01,
            pjb03           LIKE pjb_file.pjb03, 
            pjb15           LIKE pjb_file.pjb15,
            pjb16           LIKE pjb_file.pjb16,
            pja14           LIKE pja_file.pja14,
            pja15           LIKE pja_file.pja15,
            pjda02          LIKE pjda_file.pjda02,
            azf03           LIKE azf_file.azf03,
            pjda03          LIKE pjda_file.pjda03,
            aag02           LIKE aag_file.aag02,   
            pjda04          LIKE pjda_file.pjda04,
            aag13           LIKE aag_file.aag13,                       
            pjda05          LIKE pjda_file.pjda05
       END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680136 VARCHAR(20)
    l_za05          LIKE za_file.za05,     #No.FUN-680136 VARCHAR(40)
    l_azi03         LIKE azi_file.azi03,   #No.FUN-710091
    l_wc            STRING                 #TQC-760033 add
 
    IF cl_null(g_pjda01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" pjda01='",g_pjda01,"'"       #TQC-760033 modify
    END IF
 
    CALL cl_wait()
    CALL cl_del_data(l_table)
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    LET g_sql="SELECT pjb01,pja02,pjda01,pjb03,pjb15,pjb16,",   
          " pja14,pja15,pjda02,azf03,pjda03,a.aag02,pjda04,b.aag13,pjda05",
#No.FUN-9A0075 --begin
          " FROM pjda_file LEFT OUTER JOIN azf_file ON pjda02 = azf01", 
          " LEFT OUTER JOIN aag_file a ON ojda03 = a.aag01 LEFT OUTER JOIN aag_file b ON pjda04 = b.aag02,",
          " pjb_file,pja_file",
          " WHERE pja01 = pjb01 ",
          "   AND ",g_wc CLIPPED
#         " FROM pjda_file,pjb_file,pja_file,OUTER azf_file,OUTER aag_file a,OUTER aag_file b",
#         " WHERE pja01 = pjb01 AND pjda02=azf_file.azf01 AND pjda01 = pjb02 ",
#         "   AND pjda03 = a.aag01 AND  pjda04 = b.aag01 AND ",g_wc CLIPPED
#No.FUN-9A0075 --end
    LET g_sql = g_sql CLIPPED," ORDER BY pjda01"  
    PREPARE t123_p1 FROM g_sql                
    IF STATUS THEN CALL cl_err('t123_p1',STATUS,0) END IF
 
    DECLARE t123_co CURSOR FOR t123_p1
    FOREACH t123_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        EXECUTE insert_prep USING sr.* 
    END FOREACH
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp( g_wc,'pjda01,pjda02,pjda03,pjda04,pjda05 ')                 
            RETURNING g_wc
    END IF
    LET g_str = g_wc,";",g_aza.aza63               #TQC-760033
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('apjt123','apjt123',g_sql,g_str)
    CLOSE t123_co
    ERROR ""
END FUNCTION
#No:FUN-790025---End 
