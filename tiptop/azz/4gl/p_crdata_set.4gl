# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: p_crdata_set
# Descriptions...: CR 報表預覽設定作業
# Date & Author..: 09/03/31 Echo   #FUN-860089
# Modify.........: No.FUN-950038 09/05/13 By Echo Wizard Field 調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60085 10/06/25 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE
# Modify.........: No.FUN-A90024 10/11/10 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-AC0011 10/03/08 By Jay 將cmdrun時sql參數字串用單引號組合修正成雙引號組合,取得sql語法中table name與別名方式
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70108 11/07/12 By zhangll 離開作業前需調用cl_used...2
# Modify.........: No:TQC-C20125 12/02/13 By LeoChang 增加判斷"4GL報表程式與 p_crdata_set 的SQL 指令相同時，則不需重覆執行p_crdata_set 更新資料"，以減少效能問題.
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新料號畫面

DATABASE ds    
 
GLOBALS "../../config/top.global"
DEFINE   g_gcy                 RECORD LIKE gcy_file.*  #自定義查詢設定主頁
DEFINE   g_gcz                 DYNAMIC ARRAY OF RECORD #定義SQL欄位資料
           gcz05               LIKE gcz_file.gcz05,                             
           gcz06               LIKE gcz_file.gcz06,                             
           gcz07               LIKE gcz_file.gcz07,                             
           gcz08               LIKE gcz_file.gcz08,                             
           gcz11               LIKE gcz_file.gcz11,                          
           gcz10               LIKE gcz_file.gcz10,                          
           gcz12               LIKE gcz_file.gcz12,
           gcz09               LIKE gcz_file.gcz09 
                               END RECORD                            
DEFINE   g_gcy_t               RECORD LIKE gcy_file.*  
DEFINE   g_gda                 RECORD LIKE gda_file.*  #定義查詢的SQL
DEFINE   g_gda_t               RECORD LIKE gda_file.*  #定義查詢的SQL
DEFINE   g_gcz_t               RECORD                   #定義SQL欄位資料-舊值
           gcz05               LIKE gcz_file.gcz05,                             
           gcz06               LIKE gcz_file.gcz06,                             
           gcz07               LIKE gcz_file.gcz07,                             
           gcz08               LIKE gcz_file.gcz08,                             
           gcz11               LIKE gcz_file.gcz11,                             
           gcz10               LIKE gcz_file.gcz10,                            
           gcz12               LIKE gcz_file.gcz12,
           gcz09               LIKE gcz_file.gcz09 
                               END RECORD                            
DEFINE   g_swe01               STRING                  #SQL指令
DEFINE   g_swe01_t             STRING
DEFINE   g_swa01               LIKE type_file.chr1     #選擇sql產生方式
DEFINE   g_swa01_t             LIKE type_file.chr1
DEFINE   g_swa02               LIKE type_file.chr1     #選擇sql指令
DEFINE   g_swa02_t             LIKE type_file.chr1
DEFINE   g_page_choice         STRING                  #目前所選擇的Page
DEFINE   g_wizard_choice       STRING                  #目前所選擇的wizard_page
DEFINE   g_cnt                 LIKE type_file.num10,   
         g_cnt2                LIKE type_file.num10,   
         g_wc                  string,                 
         g_wc2                 string,                 
         g_sql                 string,                 
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟
         g_sql_rec_b           LIKE type_file.num5,    #SQL 單身筆數     
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT 
DEFINE   g_gdb_cnt             LIKE type_file.num10
DEFINE   g_gdc_cnt             LIKE type_file.num10
DEFINE   g_gdct_cnt            LIKE type_file.num10
DEFINE   g_gdd_cnt             LIKE type_file.num10
DEFINE   g_msg                 LIKE type_file.chr1000  
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_row_count           LIKE type_file.num10, 
         mi_curs_index         LIKE type_file.num10    
DEFINE   mi_jump               LIKE type_file.num10,   
         mi_no_ask             LIKE type_file.num5     
DEFINE   g_db_type             LIKE type_file.chr3  
DEFINE   g_gdb                 DYNAMIC ARRAY OF RECORD 
           gdb07               LIKE gdb_file.gdb07,
           gdb05               LIKE gdb_file.gdb05,
           gat03               LIKE gat_file.gat03,
           gdb06               LIKE gdb_file.gdb06
                               END RECORD
DEFINE   g_gdb_t               RECORD 
           gdb07               LIKE gdb_file.gdb07,
           gdb05               LIKE gdb_file.gdb05,
           gat03               LIKE gat_file.gat03,
           gdb06               LIKE gdb_file.gdb06
                               END RECORD
DEFINE   g_gdct                DYNAMIC ARRAY OF RECORD 
           gdc05t              LIKE gdc_file.gdc05,
           gdc06t              LIKE type_file.chr1000 
                               END RECORD
DEFINE   g_gdct_t              RECORD 
           gdc05t              LIKE gdc_file.gdc05,
           gdc06t              LIKE type_file.chr1000 
                               END RECORD
DEFINE   g_gdc                 DYNAMIC ARRAY OF RECORD 
           gdc05               LIKE gdc_file.gdc05,
           gdc06               LIKE gdc_file.gdc06,
           gaq03               LIKE gaq_file.gaq03
                               END RECORD
DEFINE   g_gdc_t               RECORD 
           gdc05               LIKE gdc_file.gdc05,
           gdc06               LIKE gdc_file.gdc06,
           gaq03               LIKE gaq_file.gaq03
                               END RECORD
DEFINE   g_gdd                 DYNAMIC ARRAY OF RECORD 
           gdd05               LIKE  gdd_file.gdd05,
           gdd06               LIKE  gdd_file.gdd06,
           gdd07               LIKE  gdd_file.gdd07,
           gdd08               LIKE  gdd_file.gdd08,
           gdd09               LIKE  gdd_file.gdd09,
           gdd10               LIKE  gdd_file.gdd10,
           gdd11               LIKE  gdd_file.gdd11,
           gdd12               LIKE  gdd_file.gdd12,
           gdd13               LIKE  gdd_file.gdd13
                               END RECORD
DEFINE   g_gdd_t               RECORD 
           gdd05               LIKE  gdd_file.gdd05,
           gdd06               LIKE  gdd_file.gdd06,
           gdd07               LIKE  gdd_file.gdd07,
           gdd08               LIKE  gdd_file.gdd08,
           gdd09               LIKE  gdd_file.gdd09,
           gdd10               LIKE  gdd_file.gdd10,
           gdd11               LIKE  gdd_file.gdd11,
           gdd12               LIKE  gdd_file.gdd12,
           gdd13               LIKE  gdd_file.gdd13
                               END RECORD
DEFINE   g_argv                DYNAMIC ARRAY OF STRING
DEFINE   g_zta01               LIKE zta_file.zta01    
DEFINE   g_zta17               LIKE zta_file.zta17    
DEFINE   g_argv1               LIKE gcy_file.gcy01    
DEFINE   g_argv2               LIKE gcy_file.gcy02   
DEFINE   g_argv3               LIKE gcy_file.gcy03    
DEFINE   g_argv4               LIKE gcy_file.gcy04    
DEFINE   g_argv5               STRING    
DEFINE   g_execmd              STRING            
DEFINE   g_zz_cnt              LIKE type_file.num5     
DEFINE   g_win_curr            ui.Window
DEFINE   g_frm_curr            ui.Form
DEFINE   g_node_item           om.DomNode
DEFINE   g_node_child          om.DomNode
DEFINE   g_err_str             STRING                  
DEFINE   g_gaz03               LIKE gaz_file.gaz03
DEFINE   g_zx02                LIKE zx_file.zx02
DEFINE   g_zw02                LIKE zw_file.zw02
DEFINE   g_n                   LIKE type_file.num10
DEFINE   g_lang_cnt            LIKE type_file.num10
DEFINE   g_gcz05_max           LIKE type_file.num10
 
MAIN
   DEFINE   p_row,p_col        LIKE type_file.num5     
#  DEFINE   l_time             LIKE type_file.chr8     # 計算被使用時間
   DEFINE   l_i                LIKE type_file.num5
   DEFINE   l_module           LIKE gao_file.gao01
   DEFINE   l_cnt              LIKE type_file.num5     #No.FUN-860089
                        
   OPTIONS                                             # 改變一些系統預設值
 
      INPUT NO WRAP
   DEFER INTERRUPT                                     # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * from gcy_file ",
                      " WHERE gcy01=? AND gcy02=? AND gcy03=? AND gcy04=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_crdata_cl CURSOR FROM g_forupd_sql
 
   LET g_forupd_sql = "SELECT * from gda_file ",
                      " WHERE gda01=? AND gda02=? AND gda03=? AND gda04=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE gda_cl CURSOR FROM g_forupd_sql
 
 
   LET g_argv1 = ARG_VAL(1)  #程式代號
   LET g_argv2 = ARG_VAL(2)  #客製碼
   LET g_argv3 = ARG_VAL(3)  #權限類別
   LET g_argv4 = ARG_VAL(4)  #使用者
   LET g_argv5 = ARG_VAL(5)  #SQL 語法
   LET g_gcy.gcy01 = g_argv1
   LET g_gcy.gcy02 = g_argv2
   LET g_gcy.gcy03 = g_argv3
   LET g_gcy.gcy04 = g_argv4
   LET g_gda.gda05 = g_argv5
 
   IF NOT cl_null(g_gcy.gcy01) THEN
      LET g_bgjob = "Y"
      CALL p_crdata_set_bgjob()
   END IF
 
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_crdata_w AT p_row,p_col WITH FORM "azz/42f/p_crdata_set"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("gcz06")
 
   SELECT COUNT(*) INTO g_lang_cnt FROM gay_file WHERE gayacti = 'Y'
 
   LET g_db_type=cl_db_get_database_type()
   LET g_page_choice = "query_sql"          
 
   CALL p_crdata_menu()
 
   CLOSE WINDOW p_crdata_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p_crdata_curs()                         # QBE 查詢資料
 
   CLEAR FORM                                    # 清除畫面
   CALL g_gcz.clear()
 
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   CONSTRUCT g_wc ON gcy01,gcy04,gcy03,gcy02,gcy05,gcyuser,gcygrup,gcymodu,gcydate  #FUN-750084 #FUN-770079 #No.FUN-810021 #FUN-860089
        FROM gcy01,gcy04,gcy03,gcy02,gcy05,gcyuser,gcygrup,gcymodu,gcydate          #FUN-750084 #FUN-770079 #No.FUN-810021 #FUN-860089
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION controlp
            CASE
                WHEN INFIELD(gcy01)                   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gcy"
                  LET g_qryparam.arg1 =  g_lang
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_gcy.gcy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gcy01
                  NEXT FIELD gcy01
             
                WHEN INFIELD(gcy03)                    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zw"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_gcy.gcy03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gcy03
                  NEXT FIELD gcy03
 
                WHEN INFIELD(gcy04)                    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zx"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_gcy.gcy04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gcy04
                  NEXT FIELD gcy04
 
                OTHERWISE
            END CASE
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON gda05,gcz05,gcz06,gcz07,gcz08,gcz11,gcz10,gcz12,gcz09
        FROM gda05,s_gcz[1].gcz05,s_gcz[1].gcz06,s_gcz[1].gcz07,
             s_gcz[1].gcz08,s_gcz[1].gcz11,s_gcz[1].gcz10,s_gcz[1].gcz12,
             s_gcz[1].gcz09
 
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
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND gcyuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND gcygrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND gcygrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gcyuser', 'gcygrup')
   #End:FUN-980030
 
 
   IF g_wc2=' 1=1 ' OR cl_null(g_wc2) THEN
      LET g_sql= "SELECT UNIQUE gcy01,gcy02,gcy03,gcy04 FROM gcy_file ",    #FUN-750084
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY gcy01"
   ELSE
      #FUN-750084
      LET g_sql="SELECT UNIQUE gcy01,gcy02,gcy03,gcy04 FROM gcy_file, OUTER gcz_file,",
                " OUTER gda_file ",
                " WHERE gcy01=gcz_file.gcz01 ",
                " AND gcy01 = gda_file.gda01 ",
                " AND gcy02 = gda_file.gda02 ",
                " AND gcy03 = gda_file.gda03 ",
                " AND gcy04 = gda_file.gda04 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," ORDER BY gcy01"
      #END FUN-750084
   END IF
 
 
   PREPARE p_crdata_prepare FROM g_sql          # 預備一下
   DECLARE p_crdata_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_crdata_prepare
 
   IF g_wc2=' 1=1' OR cl_null(g_wc2) THEN
      LET g_sql= "SELECT COUNT(*) FROM gcy_file WHERE ",g_wc CLIPPED
   ELSE
      #FUN-750084
      LET g_sql="SELECT COUNT(DISTINCT gcy01) FROM gcy_file,",
                " OUTER gcz_file,",
                " OUTER gda_file,",
                " WHERE gcy01 = gcz_file.gcz01 ",
                " AND gcy02 = gcz_file.gcz02 ",  
                " AND gcy03 = gcz_file.gcz03 ",
                " AND gcy04 = gcz_file.gcz04 ",
                " AND gcy01 = gda_file.gda01 ",
                " AND gcy02 = gda_file.gda02 ",
                " AND gcy03 = gda_file.gda03 ",
                " AND gcy04 = gda_file.gda04 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      #END FUN-750084
   END IF
 
   PREPARE query_precount FROM g_sql
 
   DECLARE query_count CURSOR FOR query_precount
 
END FUNCTION
 
FUNCTION p_crdata_menu()
DEFINE  l_cmd         STRING                               #No.FUN-860089
 
   WHILE TRUE
   
      CASE g_page_choice
         WHEN "query_sql"
              CALL p_crdata_sql_b_fill()                    # SQL     單身
              CALL p_crdata_sql_bp("G")
      END CASE
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_crdata_a()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_crdata_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_crdata_q()
            ELSE
               LET mi_curs_index = 0
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_page_choice
                  WHEN "query_sql"
                       CALL p_crdata_sql_b()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_crdata_u()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_crdata_copy()
            END IF
 
        #WHEN "seq_afresh"                      #重排欄位順序
        #   IF cl_chk_act_auth() THEN
        #      CALL p_crdata_set_seq_afresh()
        #   END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "sql_command"                     # 設定 SQL 語法 
            CALL p_crdata_sql_i()
   
         WHEN "exporttoexcel"                   #匯出excel
            IF cl_chk_act_auth() THEN
               LET g_win_curr = ui.Window.getCurrent()
               LET g_frm_curr = g_win_curr.getForm()
               CASE g_page_choice
                 WHEN "query_sql"
                      LET g_node_item = g_frm_curr.findNode("Page","page03")
                      CALL cl_export_to_excel(g_node_item,base.TypeInfo.create(g_gcz),'','')
               END CASE
            END IF
 
         WHEN "genxml"              #CR 報表資料來源產生作業
            #LET l_cmd = "p_genxml '",g_gcy.gcy01 CLIPPED,"' '",g_gda.gda05 CLIPPED,"'"   #FUN-AC0011 mark
            LET l_cmd = 'p_genxml "', g_gcy.gcy01 CLIPPED,'" "',g_gda.gda05 CLIPPED,'"'   #FUN-AC0011
            CALL cl_cmdrun(l_cmd)
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_crdata_a()                            # Add  輸入
DEFINE l_i                    LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_gcz.clear()
   CALL cl_msg("")
 
   INITIALIZE g_gcy.*   LIKE gcy_file.*
   INITIALIZE g_gcy_t.* LIKE gcy_file.*
   INITIALIZE g_gda.*   LIKE gda_file.*
   INITIALIZE g_gda_t.* LIKE gda_file.*
 
   WHILE TRUE
      LET g_gcy.gcyuser = g_user
      LET g_gcy.gcygrup = g_grup                #使用者所屬群
      LET g_gcy.gcydate = g_today
      LET g_gcy.gcy02 = 'N'
      LET g_gcy.gcy03 = 'default'
      LET g_gcy.gcy04 = g_user
      LET g_gcy.gcy05 = 'Y'              
 
      CALL p_crdata_set_zx02(g_gcy.gcy04)
      CALL p_crdata_set_zw02(g_gcy.gcy03)
 
      IF g_bgjob = "Y" THEN
         LET g_gcy.gcy01 = g_argv1
         LET g_gcy.gcy02 = g_argv2
         LET g_gcy.gcy03 = g_argv3
         LET g_gcy.gcy04 = g_argv4
      ELSE
           CALL p_crdata_i("a")                       # 輸入單頭
      END IF
      #NO.FUN-860089  -- end --
 
      IF INT_FLAG THEN                          # 使用者不玩了
         CLEAR FORM                             # 清單頭
         CALL g_gcz.clear()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      BEGIN WORK
 
      LET g_gcy.gcyoriu = g_user      #No.FUN-980030 10/01/04
      LET g_gcy.gcyorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO gcy_file VALUES(g_gcy.*)     #DISK WRITE
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         ROLLBACK WORK 
          CALL cl_err3("ins","gcy_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",1)  #FUN-750084
          CONTINUE WHILE
      ELSE
         COMMIT WORK    
      END IF
 
      CALL g_gcz.clear()
 
      LET g_sql_rec_b     = 0
 
      LET l_ac = 1
      LET g_action_choice = "insert"
      LET g_page_choice = "query_sql"
      CALL p_crdata_sql_i()
      LET g_action_choice = ""
      IF NOT cl_null(g_gda.gda05) THEN 
         CALL p_crdata_sql_b_fill()                # Process 單身
 
         #cl_prt 串 p_crdata_set, 自動產生結束
         IF g_bgjob = "Y" THEN
            EXIT WHILE
         END IF
 
         DISPLAY ARRAY g_gcz TO s_gcz.* ATTRIBUTE(COUNT=g_sql_rec_b,UNBUFFERED)
            BEFORE DISPLAY
               EXIT DISPLAY
         END DISPLAY
 
         LET l_ac = 1
         CALL p_crdata_sql_b()
      END IF
      LET g_gcy_t.* = g_gcy.*
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION p_crdata_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gcy.gcy01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_gcy_t.* = g_gcy.*
 
   BEGIN WORK
   OPEN p_crdata_cl USING g_gcy.gcy01, g_gcy.gcy02, g_gcy.gcy03, g_gcy.gcy04 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_crdata_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_crdata_cl INTO g_gcy.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gcy01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_crdata_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_gcy.gcymodu=g_user                     #修改者
   LET g_gcy.gcydate = g_today                  #修改日期
 
   WHILE TRUE
      CALL p_crdata_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gcy.* = g_gcy_t.*
         CALL p_crdata_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE gcy_file SET gcy_file.* = g_gcy.*  
       WHERE gcy01 = g_gcy_t.gcy01 AND gcy02 = g_gcy_t.gcy02 
         AND gcy03 = g_gcy_t.gcy03 AND gcy04 = g_gcy_t.gcy04 
 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","gcy_file",g_gcy_t.gcy01,g_gcy_t.gcy02,SQLCA.sqlcode,"","",0)    #No.FUN-660081  #FUN-750084
         CONTINUE WHILE
      END IF
 
      OPEN p_crdata_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL p_crdata_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_crdata_i(p_cmd)                       # 處理INPUT
   DEFINE p_cmd      LIKE type_file.chr1    # a:輸入 u:更改 
   DEFINE l_zwacti   LIKE zw_file.zwacti,                   
          l_n        LIKE type_file.num5    # 檢查重複用    
   DEFINE l_str      STRING
   DEFINE l_cnt      LIKE type_file.num5                    
   DEFINE l_prog     STRING                                 
 
   LET g_ss = 'N'
   CALL cl_set_head_visible("","YES")       #
 
   INPUT g_gcy.gcy01,g_gcy.gcy04,g_gcy.gcy03,g_gcy.gcy02,g_gcy.gcy05
   WITHOUT DEFAULTS FROM gcy01,gcy04,gcy03,gcy02,gcy05
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL query_set_entry(p_cmd)
            CALL query_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
            #權限類別及使用者只能擇一設定
            #IF p_cmd = 'u' THEN
            #   IF g_gcy.gcy03 = 'default' THEN
            #      IF g_gcy.gcy04 <> 'default' THEN
            #         CALL cl_set_comp_entry("gcy03",FALSE)
            #         CALL cl_set_comp_entry("gcy04",TRUE)
            #      ELSE
            #         CALL cl_set_comp_entry("gcy03",TRUE)
            #         CALL cl_set_comp_entry("gcy04",TRUE)
            #      END IF
            #   ELSE
            #      IF g_gcy.gcy04 = 'default' THEN
            #         CALL cl_set_comp_entry("gcy03",TRUE)
            #         CALL cl_set_comp_entry("gcy04",FALSE)
            #      END IF
            #   END IF
            #END IF
 
      AFTER FIELD gcy01 
         IF NOT cl_null(g_gcy.gcy01) THEN
            IF g_gcy.gcy01 != g_gcy_t.gcy01 OR g_gcy_t.gcy01 IS NULL  
            THEN
               SELECT COUNT(*) INTO g_zz_cnt FROM zz_file WHERE zz01=g_gcy.gcy01
               IF g_zz_cnt = 0 THEN
                  CALL cl_err(g_gcy.gcy01 CLIPPED,'azz-052',0)
                  NEXT FIELD gcy01
               END IF
            END IF
            
            CALL cl_get_progname(g_gcy.gcy01,g_lang) RETURNING g_gaz03
            DISPLAY g_gaz03 TO FORMONLY.gaz03
         END IF
 
     BEFORE FIELD gcy03      
         CALL query_set_entry(p_cmd)
 
     AFTER FIELD gcy03      
         IF NOT cl_null(g_gcy.gcy03) THEN
            IF g_gcy.gcy03 != g_gcy_t.gcy03 OR cl_null(g_gcy_t.gcy03) THEN
               IF g_gcy_t.gcy04 CLIPPED = "default" and g_gcy_t.gcy03 CLIPPED = "default" THEN #FUN-560079
                  CALL cl_err(g_gcy.gcy03,'azz-086',0)
                  LET g_gcy.gcy03 = g_gcy_t.gcy03
                  NEXT FIELD gcy03
               END IF
            END IF
            IF g_gcy.gcy03 CLIPPED  <> 'default' THEN
               SELECT zwacti INTO l_zwacti FROM zw_file
                WHERE zw01 = g_gcy.gcy03
               IF STATUS THEN
                   CALL cl_err3("sel","zw_file",g_gcy.gcy03,"",STATUS,"","SELECT "|| g_gcy.gcy03,0)    #No.FUN-660081
                   NEXT FIELD gcy03
               ELSE
                  IF l_zwacti != "Y" THEN 
                     CALL cl_err_msg(NULL,"azz-218",g_gcy.gcy03 CLIPPED,10)
                     NEXT FIELD gcy03
                  END IF
               END IF
            END IF
         END IF
         CALL query_set_no_entry(p_cmd)
         IF g_gcy.gcy03 = 'default' THEN
            IF g_gcy.gcy04 <> 'default' THEN
               CALL cl_set_comp_entry("gcy04",TRUE)
               CALL cl_set_comp_entry("gcy03",FALSE)
            ELSE
               CALL cl_set_comp_entry("gcy03",TRUE)
               CALL cl_set_comp_entry("gcy04",TRUE)
            END IF
         ELSE
            IF g_gcy.gcy04 = 'default' THEN
               CALL cl_set_comp_entry("gcy03",TRUE)
               CALL cl_set_comp_entry("gcy04",FALSE)
            END IF
         END IF
         CALL p_crdata_set_zw02(g_gcy.gcy03)
 
     BEFORE FIELD gcy04
        CALL query_set_entry(p_cmd)
 
     AFTER FIELD gcy04
         IF NOT cl_null(g_gcy.gcy04) THEN
            IF g_gcy.gcy04 != g_gcy_t.gcy04 OR cl_null(g_gcy_t.gcy04) THEN
               IF g_gcy_t.gcy04 CLIPPED = "default" and g_gcy_t.gcy03 CLIPPED = "default" THEN
                  CALL cl_err(g_gcy.gcy04,'azz-086',0)
                  LET g_gcy.gcy04 = g_gcy_t.gcy04
                  NEXT FIELD gcy04
               END IF
               IF g_gcy.gcy04 CLIPPED  <> 'default' THEN
                  SELECT COUNT(*) INTO g_cnt FROM zx_file
                   WHERE zx01 = g_gcy.gcy04
                  IF g_cnt = 0 THEN
                      CALL cl_err(g_gcy.gcy04,'mfg1312',0)
                      NEXT FIELD gcy04
                  END IF
               END IF
               IF g_gcy.gcy04 = 'default' THEN
                  IF g_gcy.gcy03 <> 'default' THEN
                     CALL cl_set_comp_entry("gcy03",TRUE)
                     CALL cl_set_comp_entry("gcy04",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("gcy03",TRUE)
                     CALL cl_set_comp_entry("gcy04",TRUE)
                  END IF
               ELSE
                  IF g_gcy.gcy03 = 'default' THEN
                     CALL cl_set_comp_entry("gcy04",TRUE)
                     CALL cl_set_comp_entry("gcy03",FALSE)
                  END IF
               END IF
 
            END IF
         END IF
         CALL p_crdata_set_zx02(g_gcy.gcy04)
         CALL query_set_no_entry(p_cmd)
 
      AFTER INPUT 
         IF INT_FLAG THEN                            # 使用者不玩了
            EXIT INPUT
         END IF
         IF (p_cmd = 'a') THEN
            SELECT COUNT(*) INTO g_cnt FROM gcy_file
             WHERE gcy01 = g_gcy.gcy01 AND gcy04 = "default"
               AND gcy02 = g_gcy.gcy02 AND gcy03 = "default"
            IF g_cnt = 0 THEN
               IF (g_gcy.gcy03 <> "default" AND g_gcy.gcy04='default') THEN
                  CALL cl_err(g_gcy.gcy01,'azz-086',1)
                  NEXT FIELD gcy03
               END IF
               IF (g_gcy.gcy04 <> "default" AND g_gcy.gcy03='default') THEN
                  CALL cl_err(g_gcy.gcy01,'azz-086',1)
                  NEXT FIELD gcy04
               END IF
            END IF
         ELSE
            IF g_gcy_t.gcy04 <> g_gcy.gcy04 OR g_gcy_t.gcy03 <> g_gcy.gcy03 
            THEN
               IF g_gcy_t.gcy04 = "default" AND g_gcy_t.gcy03 = "default" THEN
                  CALL cl_err(g_gcy_t.gcy01,'azz-086',1)
                  LET g_gcy.gcy03 = g_gcy_t.gcy03
                  LET g_gcy.gcy04 = g_gcy_t.gcy04
                  NEXT FIELD gcy04
               END IF
            END IF
          END IF
         IF g_gcy.gcy01 != g_gcy_t.gcy01 OR g_gcy_t.gcy01 IS NULL  
         THEN
            SELECT count(*) INTO l_n FROM gcy_file
              WHERE gcy01 = g_gcy.gcy01 AND gcy02 = g_gcy.gcy02
                AND gcy03 = g_gcy.gcy03 AND gcy04 = g_gcy.gcy04
            IF l_n > 0 THEN
               CALL cl_err('',"-239",0)
               NEXT FIELD gcy01
            END IF
         END IF
 
      ON ACTION controlp
          CASE
             WHEN INFIELD(gcy01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zz"
                LET g_qryparam.arg1 =  g_lang
                LET g_qryparam.default1= g_gcy.gcy01
                CALL cl_create_qry() RETURNING g_gcy.gcy01
                DISPLAY g_gcy.gcy01 TO gcy01
                CALL cl_get_progname(g_gcy.gcy01,g_lang) RETURNING g_gaz03
                DISPLAY g_gaz03 TO FORMONLY.gaz03
                NEXT FIELD gcy01
 
             WHEN INFIELD(gcy03)                    
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1= g_gcy.gcy03
               CALL cl_create_qry() RETURNING g_gcy.gcy03
               DISPLAY g_gcy.gcy03 TO gcy03
               CALL p_crdata_set_zw02(g_gcy.gcy03)
               NEXT FIELD gcy03
 
             WHEN INFIELD(gcy04)                    
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1= g_gcy.gcy04
               CALL cl_create_qry() RETURNING g_gcy.gcy04
               DISPLAY g_gcy.gcy04 TO gcy04
               CALL p_crdata_set_zx02(g_gcy.gcy04)
               NEXT FIELD gcy04
 
             OTHERWISE
                EXIT CASE
          END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
       ON ACTION CONTROLF            
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
   END INPUT
   
END FUNCTION
 
FUNCTION p_crdata_q()                            #Query 查詢
 
   LET g_row_count = 0 
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,g_row_count) 
   MESSAGE ""
 
   CLEAR FORM  
   INITIALIZE g_gcy.*,g_gaz03,g_zx02,g_zw02 TO NULL
   LET g_gda.gda05 = ""
   CALL g_gcz.clear()
 
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_crdata_curs()                        #取得查詢條件
   IF INT_FLAG THEN                            #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_crdata_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                       #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gcy.gcy01 TO NULL
      INITIALIZE g_gcy.gcy02 TO NULL    
      INITIALIZE g_gcy.gcy03 TO NULL    
      INITIALIZE g_gcy.gcy04 TO NULL    
   ELSE
       OPEN  query_count
       FETCH query_count INTO g_row_count
 
       DISPLAY g_row_count TO FORMONLY.cnt 
      CALL p_crdata_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_crdata_fetch(p_flag)             #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1    #處理方式  
 
   MESSAGE ""
   CASE p_flag
       #MOD-530271
      WHEN 'N' FETCH NEXT     p_crdata_b_curs INTO g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04
      WHEN 'P' FETCH PREVIOUS p_crdata_b_curs INTO g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04
      WHEN 'F' FETCH FIRST    p_crdata_b_curs INTO g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04
      WHEN 'L' FETCH LAST     p_crdata_b_curs INTO g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04
       #END MOD-530271
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE mi_jump p_crdata_b_curs INTO g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04 
         LET mi_no_ask = FALSE
   END CASE
   INITIALIZE g_gaz03,g_zx02,g_zw02 TO NULL
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gcy.gcy01,SQLCA.sqlcode,0)
      INITIALIZE g_gcy.* TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
          WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, g_row_count) 
 
      SELECT * INTO g_gcy.* FROM gcy_file 
       WHERE gcy01 = g_gcy.gcy01 AND gcy02 = g_gcy.gcy02 
         AND gcy03 = g_gcy.gcy03 AND gcy04 = g_gcy.gcy04 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","gcy_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",1)  
      ELSE
         CALL p_crdata_show()
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_crdata_show()                           # 將資料顯示在畫面上
 
   LET g_gcy_t.* = g_gcy.* 
 
   DISPLAY BY NAME g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,g_gcy.gcy05, 
                   g_gcy.gcyuser,g_gcy.gcygrup,g_gcy.gcymodu,g_gcy.gcydate
 
 
   CALL cl_get_progname(g_gcy.gcy01,g_lang) RETURNING g_gaz03
   DISPLAY g_gaz03 TO FORMONLY.gaz03
   CALL p_crdata_set_zw02(g_gcy.gcy03)
   CALL p_crdata_set_zx02(g_gcy.gcy04)
 
   LET g_gda.gda05 = ""
   SELECT gda05,gda09 INTO g_gda.gda05,g_gda.gda09 FROM gda_file
    WHERE gda01 = g_gcy.gcy01 AND gda02 = g_gcy.gcy02 
      AND gda03 = g_gcy.gcy03 AND gda04 = g_gcy.gcy04
 
   DISPLAY g_gda.gda05 TO gda05
 
   CALL p_crdata_sql_b_fill()                    # SQL     單身
 
   SELECT MAX(gcz05) INTO g_gcz05_max FROM gcz_file 
    WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02  
      AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
 
   CALL cl_show_fld_cont()          
END FUNCTION
 
FUNCTION p_crdata_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_gcy    RECORD LIKE gcy_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gcy.gcy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN p_crdata_cl USING g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04 
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_crdata_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_crdata_cl INTO g_gcy.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gcy01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_crdata_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_gcy.gcy04 = "default" and g_gcy.gcy03 = "default" THEN 
      SELECT COUNT(*) INTO g_cnt FROM gcy_file
       WHERE gcy01 = g_gcy.gcy01 AND gcy02 = g_gcy.gcy02
         AND ((gcy04 <> "default" and gcy03 = "default") OR
              (gcy04 = "default" and gcy03 <> "default"))
     IF g_cnt > 0 THEN
       CALL cl_err(g_gcy.gcy01,'azz-086',1)
       ROLLBACK WORK
       RETURN
     END IF
   END IF
 
   IF g_gcy.gcy04 = "default" and g_gcy.gcy03 = "default" THEN 
     IF NOT cl_confirm("azz-077") THEN
        ROLLBACK WORK
        RETURN
     END IF
   ELSE
     IF NOT cl_delh(0,0) THEN                
        ROLLBACK WORK
        RETURN
     END IF
   END IF
 
   DELETE FROM gcy_file 
    WHERE gcy01=g_gcy.gcy01 AND gcy02=g_gcy.gcy02 
      AND gcy03=g_gcy.gcy03 AND gcy04=g_gcy.gcy04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","gcy_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      RETURN
   END IF
   DELETE FROM gda_file
    WHERE gda01=g_gcy.gcy01 AND gda02=g_gcy.gcy02
      AND gda03=g_gcy.gcy03 AND gda04=g_gcy.gcy04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","gda_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      RETURN
   END IF
   DELETE FROM gcz_file 
    WHERE gcz01=g_gcy.gcy01 AND gcz02=g_gcy.gcy02
      AND gcz03=g_gcy.gcy03 AND gcz04=g_gcy.gcy04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","gcz_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      RETURN
   END IF
   DELETE FROM gdb_file 
    WHERE gdb01=g_gcy.gcy01 AND gdb02=g_gcy.gcy02
      AND gdb03=g_gcy.gcy03 AND gdb04=g_gcy.gcy04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","gdb_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      RETURN
   END IF
   DELETE FROM gdc_file 
    WHERE gdc01=g_gcy.gcy01 AND gdc02=g_gcy.gcy02
      AND gdc03=g_gcy.gcy03 AND gdc04=g_gcy.gcy04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      RETURN
   END IF
   DELETE FROM gdd_file 
    WHERE gdd01=g_gcy.gcy01 AND gdd02=g_gcy.gcy02
      AND gdd03=g_gcy.gcy03 AND gdd04=g_gcy.gcy04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","gdd_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      RETURN
   END IF
 
   CLEAR FORM  #No.TQC-740075
   INITIALIZE g_gcy.* TO NULL
   LET g_gda.gda05 = ""
   CALL g_gcz.clear()
   CALL g_gdb.clear()
   CALL g_gdct.clear()
   CALL g_gdc.clear()
   CALL g_gdd.clear()
 
   CLEAR FORM
 
   OPEN query_count
   #FUN-B50065-add-start--
   IF STATUS THEN
      CLOSE p_crdata_cl
      CLOSE query_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50065-add-end-- 
   FETCH query_count INTO g_row_count
   #FUN-B50065-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE p_crdata_cl
      CLOSE query_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50065-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN p_crdata_b_curs
   IF mi_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
       LET mi_jump = g_row_count #No.FUN-580092 HCN
      CALL p_crdata_fetch('L')
   ELSE
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL p_crdata_fetch('/')
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_crdata_sql_b()                          # 單身
   DEFINE   l_ac_t          LIKE type_file.num5, # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,   # 檢查重複用        
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        
            p_cmd           LIKE type_file.chr1,   # 處理狀態          
            l_allow_insert  LIKE type_file.num5,  
            l_allow_delete  LIKE type_file.num5   
   DEFINE k,i               LIKE type_file.num10  
   DEFINE l_num             LIKE type_file.num10  
   DEFINE l_index           LIKE type_file.num5  
   DEFINE l_cnt             LIKE type_file.num5  
   DEFINE l_gda05           STRING
   DEFINE l_datatype        STRING                 
   DEFINE l_length          STRING                 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gcy.gcy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF cl_null(g_gda.gda05) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   #LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_insert = FALSE
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gcz05,gcz06,gcz07,gcz08,gcz11,gcz10,gcz12,gcz09 ",
                     "  FROM gcz_file",
                     " WHERE gcz01=? AND gcz05=? AND gcz06=? ",
                     "   AND gcz02=? AND gcz03=? AND gcz04=?  FOR UPDATE "               #FUN-750084
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_crdata_sql_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   INPUT ARRAY g_gcz WITHOUT DEFAULTS FROM s_gcz.*
              ATTRIBUTE(COUNT=g_sql_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_sql_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gcz_t.* = g_gcz[l_ac].*    #BACKUP
 
            OPEN p_crdata_sql_cl USING g_gcy.gcy01,g_gcz_t.gcz05,g_gcz_t.gcz06,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04 
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_crdata_sql_cl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_crdata_sql_cl INTO g_gcz[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gcz_t.gcz05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER FIELD gcz10
         IF NOT cl_null(g_gcz[l_ac].gcz10) THEN
            IF g_gcz[l_ac].gcz10 < 0 THEN
               CALL cl_err('','mfg5034', 0)
               NEXT FIELD gcz10
            END IF
         END IF
 
     #AFTER FIELD gcz13
     #   IF NOT cl_null(g_gcz[l_ac].gcz13) THEN
     #      IF (g_gcz[l_ac].gcz13 <1) THEN #NO.FUN-610033
     #         NEXT FIELD gcz13
     #      END IF
     #      IF g_gcz[l_ac].gcz13 != g_gcz_t.gcz13 OR g_gcz_t.gcz13 IS NULL 
     #      THEN
     #         SELECT COUNT(*) INTO l_n FROM gcz_file
     #          WHERE gcz01 = g_gcy.gcy01 AND gcy04 = g_gcy.gcy02
     #            AND gcz03 = g_gcy.gcy03 AND gcy04 = g_gcy.gcy04
     #            AND gcz13 = g_gcz[l_ac].gcz13
     #         IF l_n > 0 THEN
     #            LET g_n = p_crdata_set_seq(p_cmd)
     #            IF g_n = 0 THEN
     #              LET g_gcz[l_ac].gcz13 = g_gcz_t.gcz13
     #              NEXT FIELD gcz13
     #            END IF
     #         END IF
     #      END IF
     #   ELSE
     #      IF (g_gcz[l_ac].gcz13 IS NULL) THEN 
     #         NEXT FIELD gcz13
     #      END IF
     #   END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_gcz_t.gcz05))  THEN
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            #LET l_gda05 = g_gda.gda05
            LET l_gda05 = cl_replace_str(g_gda.gda05 CLIPPED,"\n"," ") #No.FUN-860089
            LET l_index = l_gda05.getIndexOf(g_gcz[l_ac].gcz07,1)
            IF l_index != 0 THEN
              CALL cl_err('',"azz-126",1)
              CANCEL DELETE
            END IF
 
            IF NOT cl_confirm('azz-272') THEN
               CANCEL DELETE
            END IF
 
            DELETE FROM gcz_file
              WHERE gcz01 = g_gcy.gcy01 AND gcz05 = g_gcz[l_ac].gcz05
                AND gcz06 = g_gcz[l_ac].gcz06 AND gcz02 = g_gcy.gcy02 #FUN-750084
                AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gcz_file",g_gcy.gcy01,g_gcz[l_ac].gcz05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
 
            LET g_sql_rec_b = g_sql_rec_b-1
            DISPLAY g_sql_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gcz[l_ac].* = g_gcz_t.*
            CLOSE p_crdata_sql_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gcz[l_ac].gcz05,-263,1)
            LET g_gcz[l_ac].* = g_gcz_t.*
         ELSE
            UPDATE gcz_file SET gcz05 = g_gcz[l_ac].gcz05,
                                gcz06 = g_gcz[l_ac].gcz06,
                                gcz07 = g_gcz[l_ac].gcz07,
                                gcz08 = g_gcz[l_ac].gcz08,
                                gcz09 = g_gcz[l_ac].gcz09,
                                gcz11 = g_gcz[l_ac].gcz11,     
                                gcz10 = g_gcz[l_ac].gcz10,      
                                gcz12 = g_gcz[l_ac].gcz12
             WHERE gcz01 = g_gcy.gcy01   AND gcz05 = g_gcz_t.gcz05
               AND gcz06 = g_gcz_t.gcz06 AND gcz02 = g_gcy.gcy02  
               AND gcz03 = g_gcy.gcy03   AND gcz04 = g_gcy.gcy04  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gcz_file",g_gcy.gcy01,g_gcz_t.gcz05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_gcz[l_ac].* = g_gcz_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gcz[l_ac].* = g_gcz_t.*
            END IF
            CLOSE p_crdata_sql_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL g_gcz.deleteElement(g_sql_rec_b+1)
         CLOSE p_crdata_sql_cl
         COMMIT WORK
 
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   LET g_gcy.gcymodu = g_user
   LET g_gcy.gcydate = g_today
   UPDATE gcy_file SET gcymodu=g_gcy.gcymodu,gcydate=g_gcy.gcydate
       WHERE gcy01=g_gcy.gcy01 AND gcy02=g_gcy.gcy02
         AND gcy03=g_gcy.gcy03 AND gcy04=g_gcy.gcy04
   DISPLAY BY NAME g_gcy.gcymodu,g_gcy.gcydate
 
   CLOSE p_crdata_sql_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_crdata_sql_b_fill()                 #BODY FILL UP
   DEFINE ls_sql2           STRING
   DEFINE l_datatype        STRING             
   DEFINE l_length          STRING             
 
     LET g_sql = "SELECT gcz05,gcz06,gcz07,gcz08,gcz11,gcz10,gcz12,gcz09",    
                   "  FROM gcz_file ",
                   " WHERE gcz01 = '",g_gcy.gcy01 CLIPPED,"' ",
                   "   AND gcz02 = '",g_gcy.gcy02 CLIPPED,"' ",    
                   "   AND gcz03 = '",g_gcy.gcy03 CLIPPED,"' ",    
                   "   AND gcz04 = '",g_gcy.gcy04 CLIPPED,"' ",    
                   " ORDER BY gcz05,gcz06"
 
    PREPARE gcz_pre FROM g_sql           #預備一下
    DECLARE gcz_curs CURSOR FOR gcz_pre
 
    CALL g_gcz.clear()
 
    LET g_cnt = 1
    LET g_sql_rec_b = 0
 
    FOREACH gcz_curs INTO g_gcz[g_cnt].*
       LET g_sql_rec_b = g_sql_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(g_gcz[g_cnt].gcz10) THEN
          CALL p_crdata_field_type(g_gcz[g_cnt].gcz07) RETURNING l_datatype,l_length
          IF cl_null(l_length) OR l_length = 0 THEN
             LET l_length = 20
          END IF  
          LET g_gcz[g_cnt].gcz10 = l_length
          UPDATE gcz_file SET gcz10 = g_gcz[g_cnt].gcz10
           WHERE gcz01 = g_gcy.gcy01   AND gcz05 = g_gcz[g_cnt].gcz05
             AND gcz06 = g_gcz[g_cnt].gcz06 AND gcz02 = g_gcy.gcy02 
             AND gcz03 = g_gcy.gcy03   AND gcz04 = g_gcy.gcy04
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","gcz_file",g_gcy.gcy01,g_gcz[g_cnt].gcz05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          END IF
       END IF 
 
       IF cl_null(g_gcz[g_cnt].gcz11) THEN
          LET g_gcz[g_cnt].gcz11 = 'G'
          UPDATE gcz_file SET gcz11 = g_gcz[g_cnt].gcz11
           WHERE gcz01 = g_gcy.gcy01   AND gcz05 = g_gcz[g_cnt].gcz05
             AND gcz06 = g_gcz[g_cnt].gcz06 AND gcz02 = g_gcy.gcy02 
             AND gcz03 = g_gcy.gcy03   AND gcz04 = g_gcy.gcy04
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","gcz_file",g_gcy.gcy01,g_gcz[g_cnt].gcz05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          END IF
       END IF
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gcz.deleteElement(g_cnt)
 
    LET g_sql_rec_b = g_cnt - 1
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_crdata_sql_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   SELECT MAX(gcz05) INTO g_gcz05_max FROM gcz_file 
    WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02  
      AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
 
   DISPLAY ARRAY g_gcz TO s_gcz.* ATTRIBUTE(COUNT=g_sql_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index, g_row_count) 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
 
         IF g_gcz05_max > 0 AND l_ac > 0 THEN
            CALL cl_set_action_active("up,down", TRUE)
            IF g_gcz[l_ac].gcz05 = 1 THEN
               CALL cl_set_action_active("up", FALSE)
            END IF
            IF g_gcz[l_ac].gcz05 = g_gcz05_max THEN
               CALL cl_set_action_active("down", FALSE)
            END IF 
         ELSE
            CALL cl_set_action_active("up,down", FALSE)
         END IF      
 
      ON ACTION sql_command                      #SQL語法
         LET g_action_choice = "sql_command"
         EXIT DISPLAY 
 
     #ON ACTION seq_afresh                       #重排欄位順序
     #   LET g_action_choice="seq_afresh"
     #   EXIT DISPLAY
 
      ON ACTION genxml                           #CR 報表資料來源產生作業
         LET g_action_choice="genxml"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 
         CALL cl_set_combo_lang("gcz06")       
         INITIALIZE g_gaz03,g_zx02,g_zw02 TO NULL
         EXIT DISPLAY
 
      ON ACTION up     
         IF g_gcz[l_ac].gcz05 > 1 THEN  
            CALL p_crdata_seq(-1)   #單身序號移動
            IF g_gcz[l_ac].gcz05 = 1 THEN
               CALL cl_set_action_active("up", FALSE)
            END IF
         END IF
 
      ON ACTION down
         IF g_gcz[l_ac].gcz05 < g_gcz05_max THEN  
            CALL p_crdata_seq(1)   #單身序號移動
            IF g_gcz[l_ac].gcz05 = g_gcz05_max THEN
               CALL cl_set_action_active("down", FALSE)
            END IF
         END IF
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_crdata_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   
         IF g_sql_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           
 
      ON ACTION previous                         # P.上筆
         CALL p_crdata_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)  
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY             
 
      ON ACTION jump                             # 指定筆
         CALL p_crdata_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                  
 
      ON ACTION next                             # N.下筆
         CALL p_crdata_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY          
 
      ON ACTION last                             # 最終筆
         CALL p_crdata_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   
         IF g_sql_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
  	 ACCEPT DISPLAY            
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION query_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     
 
   IF (NOT g_before_input_done) OR INFIELD(gcy01) THEN
      CALL cl_set_comp_entry("gcy01",TRUE) 
   END IF
   IF (NOT g_before_input_done) OR INFIELD(gcy02) THEN
      CALL cl_set_comp_entry("gcy02",TRUE) 
   END IF
 
   IF (NOT g_before_input_done) OR INFIELD(gcy04) THEN
      CALL cl_set_comp_entry("gcy04",TRUE)
   END IF
   IF (NOT g_before_input_done) OR INFIELD(gcy03) THEN
      CALL cl_set_comp_entry("gcy03",TRUE)
   END IF
END FUNCTION
 
FUNCTION query_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF (NOT g_before_input_done) OR INFIELD(gcy01) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("gcy01",FALSE)
      END IF 
   END IF
 
   IF (NOT g_before_input_done) OR INFIELD(gcy02) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("gcy02",FALSE) 
      END IF
   END IF
 
   IF (NOT g_before_input_done) OR INFIELD(gcy03) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("gcy03",FALSE) 
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_gcy.gcy03) AND g_gcy.gcy03 <> 'default' THEN
               LET g_gcy.gcy04 = 'default'
               CALL cl_set_comp_entry("gcy04",FALSE)
            END IF
         END IF
      END IF
   END IF
 
   IF (NOT g_before_input_done) OR INFIELD(gcy04) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("gcy04",FALSE) 
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_gcy.gcy04) AND g_gcy.gcy04 <> 'default' THEN
               LET g_gcy.gcy03 = 'default'
               CALL cl_set_comp_entry("gcy03",FALSE)
            END IF
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_crdata_b_display()
 
   DISPLAY ARRAY g_gcz TO s_gcz.* ATTRIBUTE(COUNT=g_sql_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
 
END FUNCTION
 
FUNCTION p_crdata_sql_i()
DEFINE l_cnt       LIKE type_file.num10 
DEFINE p_cmd       LIKE type_file.chr1    # a:輸入 u:更改 
DEFINE l_gda05_o   LIKE gda_file.gda05
DEFINE l_str       STRING
DEFINE l_str2      STRING
DEFINE l_sql       STRING
DEFINE l_tmp       STRING
DEFINE l_execmd    STRING
DEFINE l_start     LIKE type_file.num5      
DEFINE l_end       LIKE type_file.num5      
DEFINE lw_w        ui.window
DEFINE ln_w        om.DomNode
DEFINE ln_page     om.DomNode
DEFINE ls_pages    om.NodeList
DEFINE l_i         LIKE type_file.num5 
 
  
   IF cl_null(g_gcy.gcy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM gda_file 
    WHERE gda01 = g_gcy.gcy01 AND gda02 = g_gcy.gcy02   
      AND gda03 = g_gcy.gcy03 AND gda04 = g_gcy.gcy04
   IF l_cnt > 0 THEN
       BEGIN WORK
       OPEN gda_cl USING g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04 
       IF STATUS THEN
          CALL cl_err("DATA LOCK:",STATUS,1)
          CLOSE gda_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH gda_cl INTO g_gda.*
       IF SQLCA.sqlcode THEN
          CALL cl_err("gda01 LOCK:",SQLCA.sqlcode,1)
          CLOSE gda_cl
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   #g_bgjob = "Y" 為 cl_prt 串 p_crdata_set
   IF NOT (g_bgjob = "Y") OR cl_null(g_bgjob) THEN          
      DISPLAY g_gda.gda05 TO gda05
      LET g_gda_t.gda05 = g_gda.gda05
      LET l_gda05_o = g_gda.gda05
   
      INPUT g_gda.gda05 WITHOUT DEFAULTS FROM gda05
         BEFORE INPUT 
           NEXT FIELD gda05
   
         BEFORE FIELD gda05 
           IF g_gda.gda05 IS NULL AND g_action_choice = 'insert' THEN
              CALL p_crdata_wizard('a')    # SQL 自動精靈
              LET g_action_choice = ''
              DISPLAY g_gda.gda05 TO gda05
              LET g_gda_t.gda05 = g_gda.gda05
           END IF
           IF g_gda.gda09 != 'Y' OR cl_null(g_gda.gda09) THEN
              CALL cl_set_act_visible("sql_wizard", FALSE)
           END IF
   
         AFTER FIELD gda05
           IF cl_null(g_gda.gda05) OR g_gda.gda05 CLIPPED = "" THEN
               CALL cl_err('','mfg2726',0)
               NEXT FIELD gda05
           END IF 
   
           IF NOT p_crdata_gda05_chk() THEN
              CALL cl_err(g_err_str,g_errno,1)
              NEXT FIELD gda05
           END IF 
   
           IF g_gda_t.gda05 != g_gda.gda05 AND g_gda.gda09="Y" THEN
              IF NOT cl_confirm('azz-251') THEN 
                 NEXT FIELD gda05
              ELSE
                 LET g_gda.gda09 = "N"
              END IF
           END IF
   
         ON ACTION sql_wizard
            DISPLAY g_gda.gda05 TO gda05
            CALL p_crdata_wizard('u')               # SQL 自動精靈
            DISPLAY g_gda.gda05 TO gda05
            LET g_gda_t.gda05 = g_gda.gda05
            IF g_gda.gda09 != 'Y' OR cl_null(g_gda.gda09) THEN
               CALL cl_set_act_visible("sql_wizard", FALSE)
            END IF
            
         ON ACTION controlf                  #欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION about
            CALL cl_about()
      END INPUT 
      CALL cl_set_act_visible("sql_wizard", TRUE)
   
      IF INT_FLAG THEN
         LET g_gda.gda05 = l_gda05_o
         DISPLAY g_gda.gda05 TO gda05
         LET INT_FLAG = 0
         RETURN
      END IF
   ELSE
      #TQC-C20125 start
      LET l_execmd = g_gda.gda05

      LET g_argv5 = ARG_VAL(5)  #SQL 指令
      LET l_sql = cl_replace_str(g_argv5 CLIPPED,"\"","'")

      #SQL指令若與設定相同，則不需要更新
      IF l_sql.trim() = l_execmd.trim() THEN
         RETURN
      END IF
      LET g_gda.gda05 = l_sql
      #TQC-C20125 end
      LET g_execmd = g_gda.gda05
      LET l_tmp = g_gda.gda05
   END IF
 
   LET l_execmd = g_execmd.toLowerCase()            
   LET l_start = l_execmd.getIndexOf('select',1)
   LET l_end   = l_execmd.getIndexOf('from',1)
   LET l_str=l_tmp.subString(l_start+7,l_end-2)
   LET g_gda.gda07 = l_str 
   
   LET l_str2 = ""
   LET l_start = l_execmd.getIndexOf('from',1)
   LET l_end   = l_execmd.getIndexOf('where',1)
   IF l_end=0 THEN
      LET l_end   = l_execmd.getIndexOf('group',1)
      IF l_end=0 THEN
         LET l_end   = l_execmd.getIndexOf('order',1)
         IF l_end=0 THEN
            LET l_end=l_execmd.getLength()
            LET l_str  = l_tmp.subString(l_start+5,l_end)
         ELSE
            LET l_str  = l_tmp.subString(l_start+5,l_end-2)
            LET l_str2 = l_tmp.subString(l_end+6,l_execmd.getLength())
         END IF
      ELSE
         LET l_str=l_tmp.subString(l_start+5,l_end-2)
         LET l_str2 = l_tmp.subString(l_end+6,l_execmd.getLength())
      END IF
   ELSE
      LET l_str=l_tmp.subString(l_start+5,l_end-2)
      LET l_str2 = l_tmp.subString(l_end+6,l_execmd.getLength())
   END IF
   LET l_str=l_str.trim()
   LET g_gda.gda06 = l_str
   
   LET l_str2=l_str2.trim()
   LET g_gda.gda08 = l_str2
  
   LET g_execmd = ""       
 
   IF l_cnt = 0 THEN
      INSERT INTO gda_file(gda01,gda02,gda03,gda04,gda05,gda06,gda07,gda08,gda09)
             VALUES(g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                    g_gda.gda05,g_gda.gda06,g_gda.gda07,g_gda.gda08,g_gda.gda09) 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gda_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",0)
         RETURN
      END IF
      LET p_cmd = 'a'
   ELSE
      UPDATE gda_file set gda05 = g_gda.gda05, gda09 = g_gda.gda09
       WHERE gda01 = g_gcy.gcy01  AND gda02 = g_gcy.gcy02  
         AND gda03 = g_gcy.gcy03  AND gda04 = g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gda_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",0) #FUN-750084
         CLOSE gda_cl
         ROLLBACK WORK
         RETURN
      END IF
      LET p_cmd = 'u'
   END IF
   IF g_gda.gda09 = 'N' THEN
      #FUN-750084
      DELETE FROM gdb_file WHERE gdb01=g_gcy.gcy01 AND gdb02=g_gcy.gcy02  
                             AND gdb03=g_gcy.gcy03 AND gdb04=g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdb_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         IF p_cmd = 'u' THEN
            CLOSE gda_cl
            ROLLBACK WORK
         END IF
         RETURN
      END IF
      DELETE FROM gdc_file WHERE gdc01=g_gcy.gcy01 AND gdc02=g_gcy.gcy02
                             AND gdc03=g_gcy.gcy03 AND gdc04=g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         IF p_cmd = 'u' THEN
            CLOSE gda_cl
            ROLLBACK WORK
         END IF
         RETURN
      END IF
      DELETE FROM gdd_file WHERE gdd01=g_gcy.gcy01 AND gdd02=g_gcy.gcy02
                             AND gdd03=g_gcy.gcy03 AND gdd04=g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdd_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         IF p_cmd = 'u' THEN
            CLOSE gda_cl
            ROLLBACK WORK
         END IF
         RETURN
      END IF
      #END FUN-750084
   END IF
 
   #TQC-810053
   LET g_gcy.gcymodu = g_user
   LET g_gcy.gcydate = g_today
   UPDATE gcy_file SET gcymodu=g_gcy.gcymodu,gcydate=g_gcy.gcydate
       WHERE gcy01=g_gcy.gcy01 AND gcy02=g_gcy.gcy02
         AND gcy03=g_gcy.gcy03 AND gcy04=g_gcy.gcy04
   DISPLAY BY NAME g_gcy.gcymodu,g_gcy.gcydate
   #END TQC-810053
 
   COMMIT WORK
 
   CALL p_crdata_parse_sql(p_cmd)
 
   #重新排序順序序號
   CALL p_crdata_set_seq_afresh()
   CALL p_crdata_sql_b_fill()        # SQL     單身
 
   #No.FUN-860089  -- start --
   #cl_prt 串 p_crdata_set, 自動產生結束
   IF g_bgjob = "Y" THEN
      RETURN
   END IF
   #No.FUN-860089  -- end --
 
 
END FUNCTION
 
FUNCTION p_crdata_parse_sql(p_cmd)
    DEFINE p_cmd              LIKE type_file.chr1    # a:輸入 u:更改 
    DEFINE l_text             STRING
    DEFINE l_str              STRING
    DEFINE l_sql              STRING
    DEFINE l_tmp              STRING
    DEFINE l_execmd           STRING
    DEFINE l_tok              base.StringTokenizer 
    DEFINE l_start            LIKE type_file.num5       
    DEFINE l_end              LIKE type_file.num5       
    DEFINE l_feld_tmp         LIKE type_file.chr1000    
    DEFINE l_feld             DYNAMIC ARRAY OF STRING
    DEFINE l_length           DYNAMIC ARRAY OF LIKE type_file.num5  
    DEFINE l_feld_t           DYNAMIC ARRAY OF STRING
    DEFINE l_tab              DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias        DYNAMIC ARRAY OF STRING
    DEFINE l_i                LIKE type_file.num5       
    DEFINE l_j                LIKE type_file.num5       
    DEFINE l_k                LIKE type_file.num5       
    DEFINE l_gaq03            LIKE gcz_file.gcz08
    DEFINE l_lang_arr         DYNAMIC ARRAY OF LIKE type_file.chr1   
    DEFINE l_feld_cnt         LIKE type_file.num5       
    DEFINE l_tab_cnt          LIKE type_file.num5       
    DEFINE l_colname          LIKE gcz_file.gcz07,      
           l_colnamec         LIKE gaq_file.gaq03,      
           l_collen           LIKE type_file.num5,      
           l_coltype          LIKE zta_file.zta03,      
           l_sel              LIKE type_file.chr1       
    DEFINE l_cnt              LIKE type_file.num10 
    DEFINE l_gcz              DYNAMIC ARRAY OF RECORD   #定義SQL欄位資料 
           gcz05                LIKE gcz_file.gcz05,                             
           gcz07                LIKE gcz_file.gcz07,                             
           tag                  LIKE type_file.chr1 
                                END RECORD                            
    DEFINE l_del_tag          LIKE type_file.chr1
    DEFINE l_del_tag2         LIKE type_file.chr1
    DEFINE l_tab_name         STRING             
    DEFINE l_tok_table        base.StringTokenizer,
           l_field_name       STRING,
           l_alias_name       STRING,
           l_datatype         LIKE ztb_file.ztb04
    DEFINE l_p                LIKE type_file.num5,
           l_p2               LIKE type_file.num5,
           l_name             STRING
    DEFINE l_dbname           STRING           
    DEFINE l_feld_id          DYNAMIC ARRAY OF STRING
    DEFINE l_str_length       STRING
    DEFINE l_tag              STRING
    DEFINE l_table_tok        base.StringTokenizer   #FUN-AC0011 
 
--  抓取所有的語言別
    DECLARE lang_arr CURSOR FOR
     SELECT UNIQUE gay01 FROM gay_file ORDER BY gay01
    LET l_i=1
    FOREACH lang_arr INTO l_lang_arr[l_i]
       IF sqlca.sqlcode THEN
          CONTINUE FOREACH
       END IF
       LET l_i=l_i+1
    END FOREACH
    FREE lang_arr
    CALL l_lang_arr.deleteElement(l_i)
 
    LET l_sel='I'
 
    LET l_str= g_gda.gda05 CLIPPED                           #FUN-810062
    LET l_str = l_str.toLowerCase()
    LET l_end = l_str.getIndexOf(';',1)
    IF l_end != 0 THEN
       LET l_str=l_str.subString(1,l_end-1)
    END IF
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
    WHILE l_tok.hasMoreTokens()
          LET l_tmp=l_tok.nextToken()
          IF l_text is null THEN
             LET l_text = l_tmp.trim()
          ELSE
             LET l_text = l_text CLIPPED,' ',l_tmp.trim()
          END IF
    END WHILE
    LET l_tmp=l_text
    LET l_execmd=l_tmp
    LET l_str=l_tmp
    LET l_start = l_tmp.getIndexOf('select',1)
    IF l_start > 0 THEN
       LET l_end   = l_tmp.getIndexOf('from',1)
       LET l_str=l_str.subString(l_start+7,l_end-2)
       LET l_str=l_str.trim()
       LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
       LET l_i=1
       WHILE l_tok.hasMoreTokens()
             LET l_feld[l_i]=l_tok.nextToken()
             LET l_feld[l_i]=l_feld[l_i].trim()
             LET l_i=l_i+1
       END WHILE
       LET l_feld_cnt=l_i-1
       
       LET l_str=l_tmp
       LET l_start = l_str.getIndexOf('from',1)
       LET l_end   = l_str.getIndexOf('where',1)
       IF l_end=0 THEN
          LET l_end   = l_str.getIndexOf('group',1)
          IF l_end=0 THEN
             LET l_end   = l_str.getIndexOf('order',1)
             IF l_end=0 THEN
                LET l_end=l_str.getLength()
                LET l_str=l_str.subString(l_start+5,l_end)
             ELSE
                LET l_str=l_str.subString(l_start+5,l_end-2)
             END IF
          ELSE
             LET l_str=l_str.subString(l_start+5,l_end-2)
          END IF
       ELSE
          LET l_str=l_str.subString(l_start+5,l_end-2)
       END IF
       LET l_str=l_str.trim()
       LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
       LET l_j=1
       WHILE l_tok.hasMoreTokens()
             #---FUN-AC0011---start-----
             #因為sql語法中FROM後面的table有可能會以 JOIN 的形式出現
             #例1:SELECT XXX FROM nni_file nni LEFT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
             #例2:SELECT XXX FROM nni_file nni RIGHT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
             #例3:SELECT XXX FROM nni_file nni OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
             LET l_str = l_tok.nextToken()

             #依照關鍵字去除,取代成逗號,以利分割table
             CALL cl_replace_str(l_str, "left outer join", ",") RETURNING l_str
             CALL cl_replace_str(l_str, "right outer join", ",") RETURNING l_str
             CALL cl_replace_str(l_str, "outer join", ",") RETURNING l_str
             WHILE l_str.getIndexOf("on", 1) > 0
                   #準備將on後面的條件式去除,如:XXXXXX JOIN nma_file nma [ON nma01 = nni06], 
                   LET l_start = l_str.getIndexOf("on", 1) 

                   #從剛才找出on關鍵字地方關始找下一個逗號,應該就是此次所要截取的table名稱和別名
                   #如果後面已找不到逗號位置,代表應該已到字串的最尾端
                   LET l_end = l_str.getIndexOf(",", l_start)  
                   IF l_end = 0 THEN
                      LET l_end = l_str.getLength() + 1   #因為下面會減1,所以這裡先加1
                   END IF
                   LET l_text = l_str.subString(l_start, l_end - 1)
                   CALL cl_replace_str(l_str, l_text, " ") RETURNING l_str
             END WHILE

             #依逗號區隔出各table名稱和別名
             LET l_table_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
             WHILE l_table_tok.hasMoreTokens()
             #---FUN-AC0011---end-------
                   #LET l_tab[l_j]=l_tok.nextToken()          #FUN-AC0011 mark 改成下面取tok方式
                   LET l_tab[l_j] = l_table_tok.nextToken()   #FUN-AC0011
                   LET l_tab[l_j]=l_tab[l_j].trim()
                   IF l_tab[l_j].getIndexOf(' ',1) THEN
                      DISPLAY 'qazgdb:',l_tab[l_j].getIndexOf(' ',1)
                      LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                      LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
                   END IF
                   LET l_j=l_j+1
              END WHILE   #FUN-AC0011
       END WHILE
       LET l_tab_cnt=l_j-1
   
       CALL cl_query_prt_temptable()     #No.FUN-A60085
     
       FOR l_i=1 TO l_feld_cnt
           IF l_feld[l_i]='*' THEN
              LET l_str=l_tmp
              LET l_start = l_str.getIndexOf('from',1)
              LET l_end   = l_str.getIndexOf('where',1)
              IF l_end=0 THEN
                 LET l_end   = l_str.getIndexOf('group',1)
                 IF l_end=0 THEN
                    LET l_end   = l_str.getIndexOf('order',1)
                    IF l_end=0 THEN
                       LET l_end=l_str.getLength()
                       LET l_str=l_str.subString(l_start+5,l_end)
                    ELSE
                       LET l_str=l_str.subString(l_start+5,l_end-2)
                    END IF
                 ELSE
                    LET l_str=l_str.subString(l_start+5,l_end-2)
                 END IF
              ELSE
                 LET l_str=l_str.subString(l_start+5,l_end-2)
              END IF
              LET l_str=l_str.trim()
              LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
              FOR l_j=1 TO l_tab_cnt 
                  CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0') #No.FUN-810062
                  DECLARE p_crdata_insert_d_ifx CURSOR FOR
                          SELECT xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01  #No.FUN-810062
                  FOREACH p_crdata_insert_d_ifx INTO l_feld_tmp,l_length[l_i],l_datatype
                     IF (l_datatype='blob' OR l_datatype='byte') THEN
                         LET l_length[l_i]= 0
                     END IF
                     LET l_feld_id[l_i] = l_feld_tmp
                     LET l_feld[l_i]=l_feld_tmp
                     LET l_i=l_i+1
                  END FOREACH
                  LET l_feld_cnt=l_i-1
              END FOR
              EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
           ELSE
              IF l_feld[l_i].getIndexOf('.',1) THEN
                 IF l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())='*' THEN
                    FOR l_j=1 TO l_tab_cnt
                        IF l_tab_alias[l_j] is null THEN
                           IF l_tab[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                              LET l_k=l_i   #備份l_i的值
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_feld.insertElement(l_i)
                              CALL l_length.insertElement(l_i)
                              CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0') #No.FUN-810062
                              DECLARE p_crdata_insert_d1_ifx CURSOR FOR 
                                      SELECT xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                              FOREACH p_crdata_insert_d1_ifx INTO l_feld_tmp,l_length[l_i],l_datatype
                                 IF (l_datatype='blob' OR l_datatype='byte') THEN
                                     LET l_length[l_i]= 0
                                 END IF
                                 LET l_feld_id[l_i] = l_feld_tmp
                                 LET l_feld[l_i]=l_tab[l_j],'.',l_feld_tmp    #FUN-820043
                                 CALL l_feld.insertElement(l_i)
                                 CALL l_length.insertElement(l_i)
                                 CALL l_feld_id.insertelement(l_i)   #FUN-AC0011
                                 LET l_k=l_k+1
                                 LET l_feld_cnt=l_feld_cnt+1
                              END FOREACH
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_feld_id.deleteElement(l_i)   #FUN-AC0011
                              LET l_feld_cnt=l_feld_cnt-1
                              LET l_i=l_k-1
                           END IF
                        ELSE
                           IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                              LET l_k=l_i   #備份l_i的值
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_feld.insertElement(l_i)
                              CALL l_length.insertElement(l_i)
                              CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0') #No.FUN-810062
                              DECLARE p_crdata_insert_d2_ifx CURSOR FOR 
                                      SELECT xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                              FOREACH p_crdata_insert_d2_ifx INTO l_feld_tmp,l_length[l_i],l_datatype
                                 IF (l_datatype='blob' OR l_datatype='byte') THEN
                                     LET l_length[l_i]= 0
                                 END IF
                                 LET  l_feld_id[l_i] = l_feld_tmp
                                 LET  l_feld[l_i]=l_tab_alias[l_j],".",l_feld_tmp           #FUN-820043
                                 CALL l_feld.insertElement(l_i)
                                 CALL l_length.insertElement(l_i)
                                 CALL l_feld_id.insertelement(l_i)   #FUN-AC0011
                                 LET l_k=l_k+1
                                 LET l_feld_cnt=l_feld_cnt+1
                              END FOREACH
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_feld_id.deleteElement(l_i)   #FUN-AC0011
                              LET l_feld_cnt=l_feld_cnt-1
                              LET l_i=l_k-1
                           END IF
                        END IF 
                    END FOR
                 ELSE
                    LET l_tab_name =l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1)    #FUN-820043
                    LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                    LET l_length[l_i]=''
                    CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0') #No.FUN-810062
                    DECLARE p_crdata_d_ifx CURSOR FOR 
                            SELECT xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC  #No.FUN-810062
                    FOREACH p_crdata_d_ifx INTO l_feld_tmp,l_length[l_i],l_datatype
                        IF (l_datatype='blob' OR l_datatype='byte') THEN
                            LET l_length[l_i]= 0
                        END IF
                        LET l_feld_id[l_i] = l_feld_tmp
                        LET l_feld[l_i] = l_tab_name, ".", l_feld_tmp   #FUN-820043
                    END FOREACH
                 END IF
              ELSE
                 LET l_length[l_i]=''
                 #CALL p_crdata_getlength(l_feld[l_i],l_sel,'s')
                 CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0') #No.FUN-810062
                 DECLARE p_crdata_d1_ifx CURSOR FOR 
                         SELECT xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                 FOREACH p_crdata_d1_ifx INTO l_feld_tmp,l_length[l_i],l_datatype
                    IF (l_datatype='blob' OR l_datatype='byte') THEN
                        LET l_length[l_i]= 0
                    END IF
                    LET l_feld[l_i]=l_feld_tmp
                    LET l_feld_id[l_i] = l_feld_tmp
                 END FOREACH
              END IF
           END IF
       END FOR
    ELSE
       LET l_i=1
       ### Using Function to get data type and length ###
       LET l_tok_table = base.StringTokenizer.create(l_str,",")
       WHILE l_tok_table.hasMoreTokens()
          LET l_name = l_tok_table.nextToken()
          LET l_p = l_name.getIndexOf(".",1)
          LET l_p2 = l_name.getIndexOf(".",l_p+1)
          LET l_alias_name = l_name.subString(1,l_p-1)
          LET l_tab_name = l_name.subString(l_p+1,l_p2-1)
          LET l_field_name = l_name.subString(l_p2+1,l_name.getLength())
          CASE cl_db_get_database_type()
            WHEN "MSV"
               LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
            OTHERWISE
               LET l_dbname = 'ds'
          END CASE
          
          CALL cl_get_column_info(l_dbname,l_tab_name,l_field_name)
              RETURNING l_datatype,l_str_length
          CASE 
             WHEN l_datatype = 'date' 
                 LET l_str_length = 10
             WHEN l_datatype = 'blob' OR l_datatype = 'byte'
                 LET l_str_length = 0
             WHEN l_datatype = 'number' 
                 IF l_str_length.getIndexOf(",",1) > 0 THEN
                    LET l_str_length = l_str_length.subString(1,l_str_length.getIndexOf(",",1)-1)
                 END IF
          END CASE 
          LET l_feld[l_i] = l_alias_name.trim()
          LET l_feld_id[l_i] = l_field_name.trim()
          LET l_length[l_i] = l_str_length
          LET l_i = l_i + 1
       END WHILE
       LET l_feld_cnt=l_i-1
 
    END IF
    IF p_cmd = 'a' THEN
       LET l_j = 1
       LET l_colname=''
       FOR l_i = 1 TO l_feld_cnt
           LET l_colname=l_feld[l_i]
           LET l_feld_tmp = l_feld_id[l_i]
           FOR l_k=1 TO l_lang_arr.getLength()
               SELECT COUNT(*) INTO l_cnt FROM gcz_file 
                 WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02               
                   AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04              
                   AND gcz06 = l_lang_arr[l_k] AND gcz07 = l_colname
               IF l_cnt = 0 THEN
                  LET l_gaq03=''
                  SELECT gaq03 INTO l_gaq03 FROM gaq_file
                   WHERE gaq01 = l_feld_tmp AND gaq02=l_lang_arr[l_k]  
                  INSERT INTO gcz_file(gcz01,gcz02,gcz03,gcz04,gcz05,gcz06,gcz07,gcz08,gcz09,gcz10,gcz11,gcz12)
                  VALUES(g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04, l_j,
                         l_lang_arr[l_k],l_colname,l_gaq03,'',l_length[l_i],'G','N')  
               END IF
           END FOR
           LET l_j=l_j+1
       END FOR
    ELSE
       LET l_colname=''
       FOR l_i = 1 TO l_feld_cnt
           LET l_colname=l_feld[l_i]
           LET l_feld_tmp = l_feld_id[l_i]
           SELECT COUNT(*) INTO l_cnt FROM gcz_file 
             WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02                             
               AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
               AND gcz07 = l_colname
           IF l_cnt = 0 OR l_cnt < l_lang_arr.getLength() THEN
              IF l_cnt = 0 THEN 
                 SELECT MAX(gcz05)+1 INTO l_j FROM gcz_file 
                  WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02  
                    AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
                 IF l_j IS NULL THEN
                    LET l_j = 1
                 END IF
                 FOR l_k=1 TO l_lang_arr.getLength()
                     LET l_gaq03=''
                     SELECT gaq03 INTO l_gaq03 FROM gaq_file
                      WHERE gaq01=l_feld_tmp AND gaq02=l_lang_arr[l_k]  
                     INSERT INTO gcz_file(gcz01,gcz02,gcz03,gcz04,gcz05,gcz06,gcz07,gcz08,gcz09,gcz10,gcz11,gcz12)
                     VALUES(g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,l_j,
                            l_lang_arr[l_k],l_colname,l_gaq03,'',l_length[l_i],'G','N') 
                 END FOR
              ELSE
                 SELECT gcz05 INTO l_j FROM gcz_file 
                  WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02                        
                    AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
                    AND gcz07 = l_colname
                 FOR l_k=1 TO l_lang_arr.getLength()
                     SELECT COUNT(*) INTO l_cnt FROM gcz_file 
                       WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02                   
                         AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
                         AND gcz06 = l_lang_arr[l_k] AND gcz07 = l_colname
                     IF l_cnt = 0 THEN
                        LET l_gaq03=''
                        SELECT gaq03 INTO l_gaq03 FROM gaq_file
                         WHERE gaq01=l_colname AND gaq02=l_lang_arr[l_k]
                        INSERT INTO gcz_file(gcz01,gcz02,gcz05,gcz06,gcz07,gcz08,gcz09,gcz10,gcz11,gcz12)
                        VALUES(g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                               l_j,l_lang_arr[l_k],l_colname,l_gaq03,'',l_length[l_i],'G','N')  
                     END IF
                 END FOR
              END IF
           END IF
       END FOR
 
       #若SQL有刪除的欄位,則詢問是否將相關資訊一併刪除
       LET l_del_tag = 'N'
       LET g_sql = "SELECT gcz05,gcz07,'N' FROM gcz_file ",
                   " WHERE gcz01 = '",g_gcy.gcy01 CLIPPED,"' ",
                   "   AND gcz02 = '",g_gcy.gcy02 CLIPPED,"' ", 
                   "   AND gcz03 = '",g_gcy.gcy03 CLIPPED,"' ", 
                   "   AND gcz04 = '",g_gcy.gcy04 CLIPPED,"' ", 
                   " ORDER BY gcz05"
       PREPARE gcz_tag_pre FROM g_sql           #預備一下
       DECLARE gcz_tag_curs CURSOR FOR gcz_tag_pre
       CALL l_gcz.clear()
       LET l_cnt = 1
       FOREACH gcz_tag_curs INTO l_gcz[l_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_str = l_gcz[l_cnt].gcz07 CLIPPED
          LET l_del_tag2 = "Y"
          FOR l_i = 1 TO l_feld_cnt
              IF l_str = l_feld[l_i] THEN
                 LET l_gcz[l_cnt].tag = 'Y'
                 LET l_del_tag2 = 'N'
                 EXIT FOR
              END IF
          END FOR
          IF l_del_tag = "N" AND l_del_tag2 = "Y" THEN
             LET l_del_tag = 'Y'
          END IF
          LET l_cnt = l_cnt + 1
       END FOREACH
       CLOSE gcz_tag_curs
       IF l_del_tag = 'Y' THEN
          #cl_prt 串 p_crdata_set
          #IF g_bgjob != "Y" OR cl_null(g_bgjob) THEN
          #   IF cl_confirm('azz-273') THEN
          #      LET l_tag = "Y"
          #   END IF
          #ELSE 
          #背景執行時，移除的欄位自動刪掉
          LET l_tag = "Y"
          #END IF
          IF l_tag = "Y" THEN
             BEGIN WORK
 
             FOR l_i = 1 TO l_gcz.getLength()
                 IF l_gcz[l_i].tag = 'N' THEN
                    DELETE FROM gcz_file
                      WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
                        AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
                        AND gcz05 = l_gcz[l_i].gcz05
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","gcz_file",g_gcy.gcy01,l_gcz[l_i].gcz05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                       ROLLBACK WORK
                       EXIT FOR
                    END IF
                 END IF
             END FOR
             COMMIT WORK
          END IF
       END IF
    END IF
    IF INT_FLAG=1 THEN
    END IF
END FUNCTION
 
FUNCTION p_crdata_gcz(p_gcz07)
DEFINE  p_gcz07       LIKE gcz_file.gcz07
DEFINE  l_gcz05       LIKE gcz_file.gcz05
DEFINE  l_gcz08       LIKE gcz_file.gcz08
 
   SELECT gcz05,gcz08 INTO l_gcz05,l_gcz08 FROM gcz_file
    WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
      AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04
      AND gcz06 = g_lang AND gcz07 = p_gcz07
 
   RETURN l_gcz05,l_gcz08
END FUNCTION
 
FUNCTION p_crdata_wizard(p_cmd)               # SQL 自動精靈
DEFINE p_cmd         LIKE type_file.chr1
 
    OPEN WINDOW p_wizard_w WITH FORM "azz/42f/p_sql_wizard2" 
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("p_sql_wizard2")
 
    IF p_cmd = 'a' THEN
         LET g_gda.gda09 = "N"
         CALL p_wizard_select(p_cmd)
         IF g_wizard_choice = "exit" THEN
              CLOSE WINDOW  p_wizard_w
              RETURN
         END IF
    END IF
    CALL cl_set_comp_visible("page03", FALSE)
 
    CALL g_gdb.clear()
    CALL g_gdct.clear()
    CALL g_gdc.clear()
    CALL g_gdd.clear()
    LET g_gdb_cnt = g_gdb.getLength()
    LET g_gdc_cnt = g_gdc.getLength()
    LET g_gdct_cnt = g_gdct.getLength()
    LET g_gdd_cnt = g_gdd.getLength()
    LET g_swe01 = ""
    IF p_cmd = 'u' THEN
       CALL p_wizard_show()
    END IF
 
    CALL p_wizard_menu()
 
    IF g_wizard_choice != "wizard_finish" AND p_cmd = 'a' THEN
 
      LET g_gda.gda09 = 'N' 
       
      DELETE FROM gdb_file WHERE gdb01 = g_gcy.gcy01 AND gdb02 = g_gcy.gcy02
                             AND gdb03 = g_gcy.gcy03 AND gdb04 = g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdb_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM gdc_file WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02
                             AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM gdd_file WHERE gdd01 = g_gcy.gcy01 AND gdd02 = g_gcy.gcy02
                             AND gdd03 = g_gcy.gcy03 AND gdd04 = g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdd_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
    END IF
    CALL cl_set_comp_visible("page03", TRUE)
    CLOSE WINDOW  p_wizard_w
END FUNCTION 
 
FUNCTION p_wizard_menu()
DEFINE l_cnt         LIKE type_file.num5
 
   LET g_wizard_choice = "wizard_table"
 
   WHILE TRUE
       IF g_wizard_choice <> "exit" AND g_wizard_choice <> 'wizard_table'
       THEN
           CALL p_wizard_gdb_b_fill()
       END IF
 
       CALL p_wizard_page_show()
 
       CASE g_wizard_choice
         WHEN "wizard_table"       
              CALL p_wizard_table()
 
         WHEN "wizard_field"       
              CALL p_wizard_field()
 
         WHEN "wizard_field_dis"       
              CALL p_wizard_field_dis()
 
         WHEN "wizard_cond"   
              CALL p_wizard_condition()
 
         WHEN "wizard_summ"     
              CALL p_wizard_summary()
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
            
         WHEN "wizard_finish"                   # 完成
            EXIT WHILE
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
       END CASE
   END WHILE
 
END FUNCTION 
 
FUNCTION p_wizard_show()
 
   CALL p_wizard_gdb_b_fill()
   CALL p_wizard_gdct_b_fill()
   CALL p_wizard_gdc_b_fill()
   CALL p_wizard_gdd_b_fill()
 
END FUNCTION
 
FUNCTION p_wizard_select(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1
 
   IF p_cmd = 'a' THEN
      CALL cl_set_comp_visible("g02", FALSE)
      LET g_swa01 = '1'
      DISPLAY g_swa01 TO swa01
   ELSE
      CALL cl_set_comp_visible("g01", FALSE)
      LET g_swa02 = '1'
      DISPLAY g_swa02 TO swa02
   END IF
   CALL cl_set_comp_visible("page01,page02,page04,page05,page06", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   INPUT g_swa01,g_swa02  WITHOUT DEFAULTS FROM swa01,swa02
   
     AFTER INPUT
        IF g_swa01 ='2' THEN
           LET g_wizard_choice="exit"
        ELSE
           IF g_wizard_choice = "wizard_table"  THEN
              LET g_gda.gda09 = "Y"
           END IF
        END IF
   
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
   
     ON ACTION CONTROLG
         CALL cl_cmdask()
   
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
   
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
   
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
   
     ON ACTION exit                             # Esc.結束
        LET g_wizard_choice="exit"
        ACCEPT INPUT 
   
     ON ACTION cancel2
        LET INT_FLAG=FALSE 		#MOD-570244	mars
        LET g_wizard_choice="exit"
        ACCEPT INPUT 
   
     ON ACTION wnext
        LET g_wizard_choice="wizard_table"
        ACCEPT INPUT
 
   END INPUT 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_comp_visible("g01,g02,page01,page02,page04,page05,page06", TRUE)
  
   IF g_gda.gda09 = 'N' THEN
      DELETE FROM gdb_file WHERE gdb01=g_gcy.gcy01 AND gdb02=g_gcy.gcy02
                             AND gdb03=g_gcy.gcy03 AND gdb04=g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdb_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM gdc_file WHERE gdc01=g_gcy.gcy01 AND gdc02=g_gcy.gcy02
                             AND gdc03=g_gcy.gcy03 AND gdc04=g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
      DELETE FROM gdd_file WHERE gdd01=g_gcy.gcy01 AND gdd02=g_gcy.gcy02
                             AND gdd03=g_gcy.gcy03 AND gdd04=g_gcy.gcy04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdd_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION p_wizard_page_show()
 
   CALL cl_set_comp_visible("page01,page02,page04,page05,page06", FALSE)
   CASE g_wizard_choice
     WHEN "wizard_table"       
          CALL cl_set_comp_visible("page01", TRUE)
 
     WHEN "wizard_field"       
          CALL cl_set_comp_visible("page02", TRUE)
 
     WHEN "wizard_field_dis"       
          CALL cl_set_comp_visible("page06", TRUE)
 
     WHEN "wizard_cond"   
          CALL cl_set_comp_visible("page04", TRUE)
 
     WHEN "wizard_summ"     
          CALL cl_set_comp_visible("page05", TRUE)
   END CASE
END FUNCTION
 
FUNCTION p_wizard_table()
DEFINE  l_allow_insert  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_cnt           LIKE type_file.num10
DEFINE  l_i             LIKE type_file.num10,
        p_cmd           LIKE type_file.chr1    # 處理狀態          #No.FUN-680135 VARCHAR(1)
DEFINE  l_status        LIKE type_file.num5
DEFINE  l_lock_sw       LIKE type_file.chr1    # 單身鎖住否
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql= "SELECT gdb06,gdb05,gdb07  FROM gdb_file ",
                      " WHERE gdb01='",g_gcy.gcy01 CLIPPED,"' ",
                      "   AND gdb02='",g_gcy.gcy02 CLIPPED,"' ", 
                      "   AND gdb03='",g_gcy.gcy03 CLIPPED,"' ", 
                      "   AND gdb04='",g_gcy.gcy04 CLIPPED,"' ", 
                      "   AND gdb05 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE gdb_bcl CURSOR FROM g_forupd_sql     
 
    LET l_ac = 1
    CALL cl_set_act_visible("accept,cancel", FALSE)
    INPUT ARRAY g_gdb WITHOUT DEFAULTS FROM s_gdb.*
              ATTRIBUTE(COUNT= g_gdb_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_gdb_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         IF g_gdb_cnt >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gdb_t.* = g_gdb[l_ac].*    #BACKUP
            OPEN gdb_bcl USING g_gdb[l_ac].gdb05
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN gdb_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH gdb_bcl INTO g_gdb[l_ac].gdb06,g_gdb[l_ac].gdb05,
                                  g_gdb[l_ac].gdb07
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gdb_t.gdb05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
         IF l_ac = 1 THEN
            CALL cl_set_comp_entry("gdb06", FALSE)
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_gdb[l_ac].* TO NULL       #900423
         LET g_gdb[l_ac].gdb06 = 'N'
         LET g_gdb_t.* = g_gdb[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()    
         IF l_ac = 1 THEN
            CALL cl_set_comp_entry("gdb06", FALSE)
         END IF
      
      AFTER FIELD gdb05
         IF g_gdb[l_ac].gdb05 IS NOT NULL THEN
            IF NOT p_crdata_tab(g_gdb[l_ac].gdb05) THEN
               DISPLAY '' TO FORMONLY.gat03
               NEXT FIELD gdb05
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_gdb[l_ac].gdb05 != g_gdb_t.gdb05) THEN
               SELECT COUNT(*) INTO l_cnt FROM gdb_file 
                WHERE gdb05 = g_gdb[l_ac].gdb05 
                  AND gdb01 = g_gcy.gcy01 AND gdb02 = g_gcy.gcy02                           #FUN-750084
                  AND gdb03 = g_gcy.gcy03 AND gdb04 = g_gcy.gcy04                        #FUN-750084
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_gdb[l_ac].gdb05,-239,0)
                  NEXT FIELD gdb05
               END IF
               SELECT gat03 INTO g_gdb[l_ac].gat03 FROM gat_file 
                WHERE gat01=g_gdb[l_ac].gdb05 AND gat02=g_lang
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wizard_choice="exit"
            CANCEL INSERT
            EXIT INPUT
         END IF
         FOR l_i = g_gdb_cnt+1 TO l_ac+1 STEP -1
             IF l_ac <> l_i THEN
                UPDATE gdb_file SET gdb07 = l_i
                 WHERE gdb07 = g_gdb[l_i].gdb07 
                   AND gdb01 = g_gcy.gcy01 AND gdb02 = g_gcy.gcy02 
                   AND gdb03 = g_gcy.gcy03 AND gdb04 = g_gcy.gcy04                        #FUN-750084
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","gdb_file",g_gcy.gcy01,g_gdb[l_i].gdb07,SQLCA.sqlcode,"","",0)
                   CANCEL INSERT
                END IF
                LET g_gdb[l_i].gdb07 = l_i
                DISPLAY g_gdb[l_i].gdb07 TO gdb07
             END IF
         END FOR
         LET g_gdb[l_ac].gdb07 = l_ac
         INSERT INTO gdb_file(gdb01,gdb02,gdb03,gdb04,gdb05,gdb06,gdb07) 
              VALUES (g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                      g_gdb[l_ac].gdb05,g_gdb[l_ac].gdb06,g_gdb[l_ac].gdb07) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gdb_file",g_gcy.gcy01,g_gdb[l_ac].gdb05,SQLCA.sqlcode,"","",0)   
            CANCEL INSERT
         ELSE
            LET g_gdb_cnt = g_gdb_cnt + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_gdb_t.gdb05))  THEN
            SELECT COUNT(*) INTO l_cnt FROM gdc_file 
             WHERE gdc05 = g_gdb_t.gdb05 
               AND gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02     
               AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04     
            IF l_cnt > 0 THEN
               CALL cl_err(g_gdb_t.gdb05 CLIPPED,"azz-244",0)
               LET g_gdb[l_ac].* = g_gdb_t.*
               CANCEL DELETE
               NEXT FIELD gdb05
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gdb_file 
             WHERE gdb01 = g_gcy.gcy01 AND gdb02 = g_gcy.gcy02   
               AND gdb03 = g_gcy.gcy04 AND gdb04 = g_gcy.gcy04     
               AND gdb05 = g_gdb[l_ac].gdb05  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdb_file",g_gcy.gcy01,g_gdb[l_ac].gdb05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_gdb_cnt = g_gdb_cnt-1
            LET p_cmd = 'd'
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gdb[l_ac].* = g_gdb_t.*
            LET g_wizard_choice="exit"
            CLOSE gdb_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gdb[l_ac].gdb05,-263,1)
            LET g_gdb[l_ac].* = g_gdb_t.*
         ELSE
            IF g_gdb_t.gdb05 != g_gdb[l_ac].gdb05 THEN
               SELECT COUNT(*) INTO l_cnt FROM gdc_file
                  WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02                          #FUN-750084
                    AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04     
                    AND gdc05= g_gdb_t.gdb05 
               IF l_cnt > 0 THEN
                  CALL cl_err(g_gdb_t.gdb05 CLIPPED,"azz-244",0)
                  LET g_gdb[l_ac].* = g_gdb_t.*
                  NEXT FIELD gdb05
               END IF
            END IF
            UPDATE gdb_file SET gdb05 = g_gdb[l_ac].gdb05,
                                gdb06 = g_gdb[l_ac].gdb06,
                                gdb07 = g_gdb[l_ac].gdb07
             WHERE gdb01 = g_gcy.gcy01 AND gdb02 = g_gcy.gcy02 
               AND gdb03 = g_gcy.gcy04 AND gdb04 = g_gcy.gcy04     
               AND gdb05 = g_gdb_t.gdb05 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gdb_file",g_gcy.gcy01,g_gdb_t.gdb05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_gdb[l_ac].* = g_gdb_t.*
               ROLLBACK WORK
            END IF
         END IF
         COMMIT WORK
        CLOSE gdb_bcl
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gdb[l_ac].* = g_gdb_t.*
            END IF
            LET g_wizard_choice="exit"
            CLOSE gdb_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF p_cmd = 'd' THEN
            FOR l_i = l_ac TO g_gdb_cnt
                   IF l_i = 1 THEN
                      LET g_gdb[l_i].gdb06 = 'N'
                   END IF
                   UPDATE gdb_file SET gdb07 = l_i,gdb06=g_gdb[l_i].gdb06
                    WHERE gdb01 = g_gcy.gcy01 AND gdb02 = g_gcy.gcy02    
                      AND gdb03 = g_gcy.gcy04 AND gdb04 = g_gcy.gcy04     
                      AND gdb07 = g_gdb[l_i].gdb07 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","gdb_file",g_gcy.gcy01,g_gdb[l_i].gdb07,SQLCA.sqlcode,"","",0)
                   END IF
                   LET g_gdb[l_i].gdb07 = l_i
                   DISPLAY g_gdb[l_i].gdb07 TO gdb07
            END FOR
          END IF
         CALL g_gdb.deleteElement(g_gdb_cnt+1)
         IF l_ac = 1 THEN
            CALL cl_set_comp_entry("gdb06", TRUE)
         END IF
         COMMIT WORK
         CLOSE gdb_bcl
 
      ON ACTION CONTROLP
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CASE
             WHEN INFIELD(gdb05)
               CALL cl_init_qry_var()
               #No.FUN-810062
               LET g_qryparam.form = "q_zta3"
               LET g_qryparam.default1 = g_gdb[l_ac].gdb05
               LET g_qryparam.default2 = NULL
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET g_qryparam.arg2 = 'ds'
 
               CALL cl_create_qry() RETURNING g_gdb[l_ac].gdb05,g_gdb[l_ac].gat03
               DISPLAY g_gdb[l_ac].gdb05 TO gdb05
               DISPLAY g_gdb[l_ac].gat03 TO gat03
               
         END CASE
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_field"
         ACCEPT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_wizard_field()
DEFINE  l_allow_insert  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_cnt           LIKE type_file.num10
DEFINE  l_i             LIKE type_file.num10,
        p_cmd           LIKE type_file.chr1    # 處理狀態          #No.FUN-680135 VARCHAR(1)
DEFINE  l_str           STRING
DEFINE  ls_sql          STRING
DEFINE  l_status        LIKE type_file.num5
DEFINE  l_tok           base.StringTokenizer
DEFINE  l_lock_sw       LIKE type_file.chr1    # 單身鎖住否
DEFINE  l_gdc06         LIKE gdc_file.gdc06
DEFINE  l_gdc07         LIKE gdc_file.gdc07
DEFINE  l_tmp           STRING
DEFINE  l_gdc_cnt       LIKE type_file.num5
DEFINE  l_gdc           DYNAMIC ARRAY OF RECORD 
         gdc06           LIKE gdc_file.gdc06,
         gdc07           LIKE gdc_file.gdc07
                        END RECORD
DEFINE  buf             base.StringBuffer
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac = 1
 
    LET g_forupd_sql= "SELECT gdc05,gdc06  FROM gdc_file ",
                      " WHERE gdc01 = '",g_gcy.gcy01 CLIPPED,"' ",
                      "   AND gdc02 = '",g_gcy.gcy02 CLIPPED,"' ",
                      "   AND gdc03 = '",g_gcy.gcy03 CLIPPED,"' ",
                      "   AND gdc04 = '",g_gcy.gcy04 CLIPPED,"' ",
                      "   AND gdc05 = ? ",
                      " ORDER BY gdc06 " 
    DECLARE gdct_bcl CURSOR FROM g_forupd_sql     
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    INPUT ARRAY g_gdct WITHOUT DEFAULTS FROM s_gdct.*
              ATTRIBUTE(COUNT= g_gdct_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_gdct_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         IF g_gdct_cnt >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gdct_t.* = g_gdct[l_ac].*    #BACKUP
            INITIALIZE g_gdct[l_ac].* TO NULL       #900423
            FOREACH gdct_bcl USING g_gdct_t.gdc05t INTO g_gdct[l_ac].gdc05t,l_gdc06
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gdct_t.gdc05t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               IF cl_null(g_gdct[l_ac].gdc06t) THEN
                   LET g_gdct[l_ac].gdc06t = l_gdc06 CLIPPED
               ELSE
                   LET g_gdct[l_ac].gdc06t = g_gdct[l_ac].gdc06t CLIPPED,
                                               ",",l_gdc06 CLIPPED
               END IF
            END FOREACH
            CALL cl_show_fld_cont()   
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_gdct[l_ac].* TO NULL       #900423
         LET g_gdct_t.* = g_gdct[l_ac].*          #新輸入資料
        #LET g_gdct[l_ac].gdc05t = g_gdb[1].gdb05 CLIPPED      #FUN-950038
         CALL cl_show_fld_cont()  
 
      AFTER FIELD gdc05t
         IF g_gdct[l_ac].gdc05t IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_gdct[l_ac].gdc05t != g_gdct_t.gdc05t) THEN
               SELECT COUNT(*) INTO l_cnt FROM gdc_file 
                WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02    
                  AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04
                  AND gdc05 = g_gdct[l_ac].gdc05t
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_gdct[l_ac].gdc05t,-239,0)
                  NEXT FIELD gdc05t
               END IF
            END IF
            IF g_gdct[l_ac].gdc06t IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_gdct[l_ac].gdc06t CLIPPED,g_gdct[l_ac].gdc05t CLIPPED,'Y')
               IF NOT l_status THEN
                  NEXT FIELD gdc05t
               END IF
            END IF
         END IF
 
      BEFORE FIELD gdc06t
         IF g_gdct[l_ac].gdc05t IS NULL THEN
            CALL cl_err('','aws-067',0)
            NEXT FIELD gdc05t
         END IF
 
      AFTER FIELD gdc06t
         DISPLAY g_gdct[l_ac].gdc06t TO gdct03t
         IF g_gdct[l_ac].gdc06t IS NOT NULL THEN
            IF g_gdct[l_ac].gdc06t != g_gdct_t.gdc06t OR g_gdct_t.gdc06t IS NULL THEN
               LET l_status = p_wizard_check_field(g_gdct[l_ac].gdc06t CLIPPED,g_gdct[l_ac].gdc05t CLIPPED,'Y')
               IF NOT l_status THEN
                  NEXT FIELD gdc06t
               END IF
            END IF 
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wizard_choice="exit"
            EXIT INPUT 
         END IF
         LET l_tmp = g_gdct[l_ac].gdc06t CLIPPED
         IF l_tmp.getIndexOf(',',1) > 0 THEN
            LET l_tok = base.StringTokenizer.createExt(l_tmp,",","",TRUE)
            SELECT MAX(gdc07)+1 INTO l_gdc_cnt FROM gdc_file
             WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02     #FUN-750084
               AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04     #FUN-950038
            IF cl_null(l_gdc_cnt) OR l_gdc_cnt = 0 THEN
               LET l_gdc_cnt = 1
            END IF
            WHILE l_tok.hasMoreTokens()
                LET l_str=l_tok.nextToken()                 #FUN-950038
                LET l_gdc06=l_str.trim()                    #FUN-950038
                INSERT INTO gdc_file (gdc01,gdc02,gdc03,gdc04,gdc05,gdc06,gdc07) 
                        VALUES (g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                                g_gdct[l_ac].gdc05t,l_gdc06,l_gdc_cnt)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","gdc_file",g_gcy.gcy01,g_gdct[l_ac].gdc05t,SQLCA.sqlcode,"","",0)
                   EXIT WHILE
                ELSE
                   LET l_gdc_cnt = l_gdc_cnt + 1
                END IF
            END WHILE
         ELSE 
             INSERT INTO gdc_file (gdc01,gdc02,gdc03,gdc04,gdc05,gdc06,gdc07)   #FUN-950038
                     VALUES (g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                             g_gdct[l_ac].gdc05t,g_gdct[l_ac].gdc06t,l_gdc_cnt)  
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","gdc_file",g_gcy.gcy01,g_gdct[l_ac].gdc05t,SQLCA.sqlcode,"","",0)  
             END IF
         END IF
         LET g_gdct_cnt = g_gdct_cnt + 1
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_gdct_t.gdc05t))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM gdc_file
             WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02  
               AND gdc03 = g_gcy.gcy03 ANd gdc04 = g_gcy.gcy04
               AND gdc05 = g_gdct[l_ac].gdc05t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gdct[l_ac].gdc05t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               CANCEL DELETE
            END IF
            LET g_gdct_cnt = g_gdct_cnt-1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gdct[l_ac].* = g_gdct_t.*
            LET g_wizard_choice="exit"
            CLOSE gdct_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gdb[l_ac].gdb05,-263,1)
            LET g_gdb[l_ac].* = g_gdb_t.*
         ELSE
            LET l_gdc_cnt = 0
            LET l_tmp = g_gdct[l_ac].gdc06t CLIPPED
            IF l_tmp.getIndexOf(',',1) > 0 THEN
               LET l_tok = base.StringTokenizer.createExt(l_tmp,",","",TRUE)
               WHILE l_tok.hasMoreTokens()
                   LET l_tmp=l_tok.nextToken()
                   LET l_gdc_cnt = l_gdc_cnt + 1 
                   LET l_gdc06 = l_tmp.trim()         #FUN-950038 
                   LET l_gdc07 = 0
                   SELECT gdc07 INTO l_gdc07 FROM gdc_file
                    WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02 
                      AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04
                      AND gdc05 = g_gdct_t.gdc05t AND gdc06 = l_gdc06  
                   IF cl_null(l_gdc07) OR l_gdc07 = 0 THEN
                      SELECT MAX(gdc07)+1 INTO l_gdc07 FROM gdc_file
                       WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02                 
                         AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04
                   END IF
                   LET l_gdc[l_gdc_cnt].gdc06 = l_gdc06 CLIPPED
                   LET l_gdc[l_gdc_cnt].gdc07 = l_gdc07
               END WHILE
            ELSE
               LET l_gdc_cnt = l_gdc_cnt + 1 
               LET l_gdc[l_gdc_cnt].gdc06 = l_gdc06 CLIPPED
               LET l_gdc[l_gdc_cnt].gdc07 = l_gdc07
            END IF
            DELETE FROM gdc_file 
             WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02               
               AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04
               AND gdc05=g_gdct[l_ac].gdc05t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gdct[l_ac].gdc05t,SQLCA.sqlcode,"","",0)  
               ROLLBACK WORK
            ELSE
               FOR l_i = 1 TO l_gdc_cnt 
                  INSERT INTO gdc_file (gdc01,gdc02,gdc03,gdc04,gdc05,gdc06,gdc07) 
                          VALUES (g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                                  g_gdct[l_ac].gdc05t,l_gdc[l_i].gdc06,l_gdc[l_i].gdc07)  
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("ins","gdc_file",g_gcy.gcy01,g_gdct[l_ac].gdc05t,SQLCA.sqlcode,"","",0)  
                     ROLLBACK WORK
                     EXIT FOR
                  END IF
               END FOR
            END IF
         END IF
         COMMIT WORK
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gdct[l_ac].* = g_gdct_t.*
            END IF
            LET g_wizard_choice="exit"
            CLOSE gdct_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL g_gdct.deleteElement(g_gdct_cnt+1)
         COMMIT WORK
         CLOSE gdct_bcl
 
      ON ACTION CONTROLP
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CASE
             WHEN INFIELD(gdc06t)
               CALL q_gaq1(TRUE,TRUE,g_gdct[l_ac].gdc06t,g_gdct[l_ac].gdc05t) 
                    RETURNING g_gdct[l_ac].gdc06t
               DISPLAY g_gdct[l_ac].gdc06t TO gdc06t
         END CASE
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_field_dis"
         ACCEPT INPUT
 
      ON ACTION back
         LET g_wizard_choice="wizard_table"
         ACCEPT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CALL cl_set_act_visible("accept,cancel", TRUE)
   #CALL p_wizard_gdct_b_fill()
   CALL p_wizard_gdc_b_fill()
 
END FUNCTION
 
FUNCTION p_wizard_field_dis()
DEFINE  l_i                   LIKE type_file.num5
DEFINE  l_gdc                 RECORD 
           gdc05               LIKE gdc_file.gdc05,
           gdc06               LIKE gdc_file.gdc06,
           gaq03               LIKE gaq_file.gaq03
                              END RECORD
    LET l_ac = 1
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_gdc TO s_gdc.* ATTRIBUTE(COUNT=g_gdc_cnt,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_set_action_active("up,down", TRUE)
         IF l_ac = 1 THEN
            CALL cl_set_action_active("up", FALSE)
         END IF
         IF l_ac = g_gdc_cnt THEN
            CALL cl_set_action_active("down", FALSE)
         END IF
 
         CALL cl_show_fld_cont()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT DISPLAY 
 
      ON ACTION up
         LET l_gdc.* = g_gdc[l_ac-1].*
         LET g_gdc[l_ac-1].* = g_gdc[l_ac].*
         LET g_gdc[l_ac].* = l_gdc.*
         LET l_ac = l_ac - 1
         CALL fgl_set_arr_curr(l_ac)
         IF l_ac = 1 THEN
            CALL cl_set_action_active("up", FALSE)
         END IF
 
      ON ACTION down
         LET l_gdc.* = g_gdc[l_ac+1].*
         LET g_gdc[l_ac+1].* = g_gdc[l_ac].*
         LET g_gdc[l_ac].* = l_gdc.*
         LET l_ac = l_ac + 1
         CALL fgl_set_arr_curr(l_ac)
         IF l_ac = g_gdc_cnt THEN
            CALL cl_set_action_active("down", FALSE)
         END IF
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT DISPLAY
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_cond"
         EXIT DISPLAY
 
      ON ACTION back
         LET g_wizard_choice="wizard_field"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF g_wizard_choice != "exit" THEN
      DELETE FROM gdc_file 
       WHERE gdc01 = g_gcy.gcy01 AND gdc02 = g_gcy.gcy02   
         AND gdc03 = g_gcy.gcy03 AND gdc04 = g_gcy.gcy04   
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdc_file",g_gcy.gcy01,g_gdct[l_ac].gdc05t,SQLCA.sqlcode,"","",0)  
      ELSE
         FOR l_i = 1 TO g_gdc_cnt 
             INSERT INTO gdc_file (gdc01,gdc02,gdc03,gdc04,gdc05,gdc06,gdc07) 
                     VALUES (g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                             g_gdc[l_i].gdc05,g_gdc[l_i].gdc06,l_i)   
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","gdc_file",g_gcy.gcy01,g_gdc[l_i].gdc05,SQLCA.sqlcode,"","",0) 
                EXIT FOR
             END IF
         END FOR
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_wizard_condition()
DEFINE  p_cmd           LIKE type_file.chr1    # 處理狀態
DEFINE  l_allow_insert  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
DEFINE  l_gdd_cnt       LIKE type_file.num10
DEFINE  l_cnt           LIKE type_file.num10
DEFINE  l_i             LIKE type_file.num10
DEFINE  l_str           STRING
DEFINE  l_str2          STRING
DEFINE  l_check         LIKE type_file.chr1
DEFINE  l_gdc06         LIKE type_file.chr1000
DEFINE  l_p             LIKE type_file.num5
DEFINE  l_status        LIKE type_file.num5
DEFINE  l_lock_sw       LIKE type_file.chr1    # 單身鎖住否
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_gdd_cnt = g_gdd.getLength()
    LET l_ac = 1
 
    LET g_forupd_sql= "SELECT gdd05,gdd06,gdd07,gdd08,gdd09,gdd10,gdd11,gdd12,",
                      " gdd13 FROM gdd_file ",
                      " WHERE gdd01='",g_gcy.gcy01 CLIPPED,"' AND gdd05 = ? ",
                      "   AND gdd02='",g_gcy.gcy02 CLIPPED,"' ", 
                      "   AND gdd03='",g_gcy.gcy03 CLIPPED,"' ",
                      "   AND gdd04='",g_gcy.gcy04 CLIPPED,"' " 
    DECLARE gdd_bcl CURSOR FROM g_forupd_sql     
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    INPUT ARRAY g_gdd WITHOUT DEFAULTS FROM s_gdd.*
              ATTRIBUTE(COUNT= l_gdd_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF l_gdd_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         IF g_gdd_cnt >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gdd_t.* = g_gdd[l_ac].*    #BACKUP
            OPEN gdd_bcl USING g_gdd[l_ac].gdd05
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN gdd_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH gdd_bcl INTO g_gdd[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gdd_t.gdd05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()   
         END IF
         IF g_gdd[l_ac].gdd09 = '7'  OR
            g_gdd[l_ac].gdd09 = '8'  OR
            g_gdd[l_ac].gdd09 = '9'  OR 
            g_gdd[l_ac].gdd09 = '10' OR
            g_gdd[l_ac].gdd09 = '11' OR
            g_gdd[l_ac].gdd09 = '12' 
         THEN
             CALL cl_set_comp_entry("gdd10", FALSE)
             IF g_gdd[l_ac].gdd09='11' OR g_gdd[l_ac].gdd09='12' THEN
                  CALL cl_set_comp_entry("gdd11", FALSE)
             ELSE
                  CALL cl_set_comp_entry("gdd11", TRUE)
             END IF
         ELSE
             CALL cl_set_comp_entry("gdd10", TRUE)
             CALL cl_set_comp_entry("gdd11", TRUE)
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_gdd[l_ac].* TO NULL       #900423
 
         LET g_gdd_t.* = g_gdd[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER FIELD gdd07
         IF g_gdd[l_ac].gdd07 IS NOT NULL THEN
            IF g_gdd[l_ac].gdd08 IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_gdd[l_ac].gdd08 CLIPPED,g_gdd[l_ac].gdd07 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD gdd07
               END IF
            END IF
         END IF
 
      BEFORE FIELD gdd08
         IF g_gdd[l_ac].gdd07 IS NULL THEN
            CALL cl_err('','aws-067',0)
            NEXT FIELD gdd07
         END IF
 
      AFTER FIELD gdd08
         IF g_gdd[l_ac].gdd08 IS NOT NULL THEN
            IF g_gdd[l_ac].gdd08 != g_gdd_t.gdd08 OR g_gdd_t.gdd08 IS NULL THEN
               LET l_status = p_wizard_check_field(g_gdd[l_ac].gdd08 CLIPPED,g_gdd[l_ac].gdd07 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD gdd08
               END IF
            END IF
         END IF
 
      ON CHANGE gdd09 
         IF g_gdd[l_ac].gdd09 = '7'  OR
            g_gdd[l_ac].gdd09 = '8'  OR
            g_gdd[l_ac].gdd09 = '9'  OR 
            g_gdd[l_ac].gdd09 = '10' OR
            g_gdd[l_ac].gdd09 = '11' OR
            g_gdd[l_ac].gdd09 = '12' 
         THEN
             CALL cl_set_comp_entry("gdd10", FALSE)
             LET g_gdd[l_ac].gdd10 = ''
             IF g_gdd[l_ac].gdd09='11' OR g_gdd[l_ac].gdd09='12' THEN
                  CALL cl_set_comp_entry("gdd11", FALSE)
                  LET g_gdd[l_ac].gdd11 = ''
             ELSE
                  CALL cl_set_comp_entry("gdd11", TRUE)
             END IF
             DISPLAY BY NAME g_gdd[l_ac].gdd10,g_gdd[l_ac].gdd11
         ELSE
             CALL cl_set_comp_entry("gdd10", TRUE)
             CALL cl_set_comp_entry("gdd11", TRUE)
         END IF
 
      AFTER FIELD gdd10
         IF g_gdd[l_ac].gdd10 IS NOT NULL THEN
            IF g_gdd[l_ac].gdd11 IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_gdd[l_ac].gdd11 CLIPPED,g_gdd[l_ac].gdd10 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD gdd11
               END IF
            END IF
         END IF
 
      BEFORE FIELD gdd11
         IF g_gdd[l_ac].gdd10 IS NOT NULL THEN
             CALL cl_set_action_active("controlp", TRUE)
         ELSE
             CALL cl_set_action_active("controlp", FALSE)
         END IF
 
      AFTER FIELD gdd11
         IF g_gdd[l_ac].gdd11 IS NOT NULL THEN
            IF g_gdd[l_ac].gdd10 IS NOT NULL THEN
               LET l_status = p_wizard_check_field(g_gdd[l_ac].gdd11 CLIPPED,g_gdd[l_ac].gdd10 CLIPPED,'N')
               IF NOT l_status THEN
                  NEXT FIELD gdd11
               END IF
            END IF
         END IF
         CALL cl_set_action_active("controlp", TRUE)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wizard_choice="exit"
            EXIT INPUT
         END IF
         FOR l_i = g_gdd_cnt+1 TO l_ac+1 STEP -1
             IF l_ac <> l_i THEN
                UPDATE gdd_file SET gdd05 = l_i
                 WHERE gdd01 = g_gcy.gcy01 AND gdd02 = g_gcy.gcy02      
                   AND gdd03 = g_gcy.gcy03 AND gdd04 = g_gcy.gcy04      
                   AND gdd05 = g_gdd[l_i].gdd05
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","gdd_file",g_gcy.gcy01,g_gdd[l_i].gdd05,SQLCA.sqlcode,"","",0)
                   CANCEL INSERT
                END IF
                LET g_gdd[l_i].gdd05 = l_i
                DISPLAY g_gdd[l_i].gdd05 TO gdd05
             END IF
         END FOR
         LET g_gdd[l_ac].gdd05 = l_ac
         INSERT INTO gdd_file(gdd01,gdd02,gdd03,gdd04,gdd05,gdd06,gdd07,gdd08,gdd09,gdd10,gdd11,gdd12,gdd13)
         VALUES (g_gcy.gcy01,g_gcy.gcy02,g_gcy.gcy03,g_gcy.gcy04,
                 l_ac,g_gdd[l_ac].gdd06,g_gdd[l_ac].gdd07,
                 g_gdd[l_ac].gdd08,g_gdd[l_ac].gdd09,g_gdd[l_ac].gdd10,
                 g_gdd[l_ac].gdd11,g_gdd[l_ac].gdd12,g_gdd[l_ac].gdd13)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gdd_file",g_gcy.gcy01,g_gdd[l_ac].gdd05,SQLCA.sqlcode,"","",0)
         ELSE
            LET g_gdd_cnt = g_gdd_cnt + 1
         END IF
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gdd[l_ac].* = g_gdd_t.*
            LET g_wizard_choice="exit"
            CLOSE gdd_bcl 
            ROLLBACK WORK
            EXIT INPUT
         END IF
         UPDATE gdd_file 
            SET gdd06 = g_gdd[l_ac].gdd06, gdd07 = g_gdd[l_ac].gdd07,
                gdd08 = g_gdd[l_ac].gdd08, gdd09 = g_gdd[l_ac].gdd09,
                gdd10 = g_gdd[l_ac].gdd10, gdd11 = g_gdd[l_ac].gdd11,
                gdd12 = g_gdd[l_ac].gdd12, gdd13 = g_gdd[l_ac].gdd13
          WHERE gdd01 = g_gcy.gcy01 AND gdd02 = g_gcy.gcy02      
            AND gdd03 = g_gcy.gcy03 AND gdd04 = g_gcy.gcy04      
            AND gdd05 = g_gdd_t.gdd05
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gdd_file",g_gcy.gcy01,g_gdd_t.gdd05,SQLCA.sqlcode,"","",0)
            LET g_gdd[l_ac].* = g_gdd_t.*
            ROLLBACK WORK
         END IF
         COMMIT WORK
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gdd[l_ac].* = g_gdd_t.*
            END IF
            LET g_wizard_choice="exit"
            CLOSE gdd_bcl 
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF p_cmd = 'd' THEN
            FOR l_i = l_ac TO g_gdd_cnt
                   UPDATE gdd_file SET gdd05 = l_i
                    WHERE gdd01 = g_gcy.gcy01 AND gdd02 = g_gcy.gcy02      
                      AND gdd03 = g_gcy.gcy03 AND gdd04 = g_gcy.gcy04      
                      AND gdd05 = g_gdd[l_i].gdd05
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","gdd_file",g_gcy.gcy01,g_gdd[l_i].gdd05,SQLCA.sqlcode,"","",0)
                   END IF
                   LET g_gdd[l_i].gdd05 = l_i
                   DISPLAY g_gdd[l_i].gdd05 TO gdd05
            END FOR
          END IF
          CALL g_gdd.deleteElement(g_gdd_cnt+1)
          CLOSE gdd_bcl 
          COMMIT WORK
          CALL cl_set_comp_entry("gdd10", TRUE)
          CALL cl_set_comp_entry("gdd11", TRUE)
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_gdd_t.gdd05))  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM gdd_file 
             WHERE gdd01 = g_gcy.gcy01 AND gdd02 = g_gcy.gcy02      
               AND gdd03 = g_gcy.gcy03 AND gdd04 = g_gcy.gcy04      
               AND gdd05 = g_gdd[l_ac].gdd05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdd_file",g_gcy.gcy01,g_gdd[l_ac].gdd05,SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET p_cmd = 'd'
            LET g_gdd_cnt = g_gdd_cnt-1
         END IF
         COMMIT WORK
 
      ON ACTION CONTROLP
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CASE
             WHEN INFIELD(gdd08)
               CALL q_gaq1(FALSE,TRUE,g_gdd[l_ac].gdd08,g_gdd[l_ac].gdd07)  RETURNING g_gdd[l_ac].gdd08
               DISPLAY g_gdd[l_ac].gdd08 TO gdd08
             WHEN INFIELD(gdd11)
               CALL q_gaq1(FALSE,TRUE,g_gdd[l_ac].gdd11,g_gdd[l_ac].gdd10)  RETURNING g_gdd[l_ac].gdd11
               DISPLAY g_gdd[l_ac].gdd11 TO gdd11
         END CASE
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_wizard_choice="exit"
         EXIT INPUT
 
      ON ACTION back
         LET g_wizard_choice="wizard_field_dis"
         ACCEPT INPUT
 
      ON ACTION wnext
         LET g_wizard_choice="wizard_summ"
         ACCEPT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL p_wizard_gdd_b_fill()
END FUNCTION
 
FUNCTION p_wizard_summary()
 
    CALL p_wizard_swe01()
 
    LET g_swe01_t = g_swe01
 
    DISPLAY g_swe01 TO swe01
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    INPUT g_swe01  WITHOUT DEFAULTS FROM swe01
 
      AFTER INPUT
         IF g_wizard_choice = "wizard_finish" THEN
            IF g_swe01_t != g_swe01 THEN
               IF NOT cl_confirm('azz-251') THEN 
                  NEXT FIELD swe01
               ELSE
                  LET g_gda.gda09 = "N"
               END IF
            ELSE
               LET g_gda.gda09 = "Y"
            END IF
            IF NOT p_wizard_finish() THEN
               LET g_wizard_choice = "wizard_summ"
               NEXT FIELD swe01
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION exit                             # Esc.結束
         LET g_wizard_choice="exit"
         ACCEPT INPUT 
 
      ON ACTION cancel2
         LET INT_FLAG=FALSE 	
         LET g_wizard_choice="exit"
         ACCEPT INPUT 
 
      ON ACTION finish 
         LET g_wizard_choice="wizard_finish"
         ACCEPT INPUT 
 
      ON ACTION back
         LET g_wizard_choice="wizard_cond"
         ACCEPT INPUT 
 
   END INPUT 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_crdata_tab(p_tabname)
   DEFINE p_tabname    LIKE type_file.chr20,  
          l_cnt        LIKE type_file.num5    
   DEFINE l_sql        STRING                 

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #CASE g_db_type                           
   #  WHEN "ORA"
   #      SELECT COUNT(*) INTO l_cnt FROM ALL_TABLES WHERE  
   #      TABLE_NAME = UPPER(p_tabname) AND OWNER = 'DS'
   #  WHEN "IFX"
   #       SELECT COUNT(*) INTO l_cnt FROM ds:systables
   #        WHERE tabname = p_tabname
   #  WHEN "MSV"
   #      LET l_sql = "SELECT COUNT(*) ",
   #                  "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_ds.sys.objects",
   #                  " WHERE name = '",p_tabname CLIPPED,"'"
   LET l_sql = "SELECT COUNT(*) ",
               "  FROM sch_file ",
               " WHERE sch01 = '",p_tabname CLIPPED,"'"
   #---FUN-A90024---end-------

   PREPARE tab_precount FROM l_sql
   DECLARE tab_count CURSOR FOR tab_precount
   OPEN tab_count
   FETCH tab_count INTO l_cnt
   #END CASE     #FUN-A90024
   #END FUN-5A0136
   
 
   IF l_cnt = 0 THEN
      CALL cl_err(p_tabname,NOTFOUND,0)
      RETURN 0
   ELSE
      RETURN 1
   END IF
END FUNCTION
 
FUNCTION p_wizard_gdb_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_items       STRING
 
   CALL g_gdb.clear()
   LET g_forupd_sql= "SELECT gdb05,gdb06,gdb07  FROM gdb_file ",
                     " WHERE gdb01 = '",g_gcy.gcy01 CLIPPED,"' ",
                     "   AND gdb02 = '",g_gcy.gcy02 CLIPPED,"' ", 
                     "   AND gdb03 = '",g_gcy.gcy03 CLIPPED,"' ", 
                     "   AND gdb04 = '",g_gcy.gcy04 CLIPPED,"' ", 
                     " ORDER BY gdb07"
   DECLARE p_gdb2_cl CURSOR FROM g_forupd_sql     
   LET l_i = 1
   FOREACH p_gdb2_cl INTO g_gdb[l_i].gdb05,g_gdb[l_i].gdb06,g_gdb[l_i].gdb07
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_gdb[l_i].gdb05 IS NOT NULL THEN
          IF l_i = 1 THEN
             LET l_items = g_gdb[l_i].gdb05 CLIPPED
          ELSE
             LET l_items = l_items,",",g_gdb[l_i].gdb05 CLIPPED
          END IF
          SELECT gat03 INTO g_gdb[l_i].gat03 FROM gat_file 
           WHERE gat01=g_gdb[l_i].gdb05 AND gat02=g_lang
          LET l_i = l_i + 1
       ELSE 
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_gdb.deleteElement(l_i)
   LET g_gdb_cnt = l_i - 1
 
   IF g_gdb_cnt = 0 THEN
      CALL cl_err('','azz-243',1)
      LET g_wizard_choice = 'wizard_table'
      RETURN
   END IF
 
   LET l_items = l_items.toLowerCase()
   CALL cl_set_combo_items("gdc05t",l_items,l_items)
   CALL cl_set_combo_items("gdd07",l_items,l_items)
   CALL cl_set_combo_items("gdd10",l_items,l_items)
   
END FUNCTION
 
FUNCTION p_wizard_gdct_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_j           LIKE type_file.num5
DEFINE l_items       STRING
DEFINE l_str         STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_tag         LIKE type_file.num5
DEFINE l_gdc06         LIKE gdc_file.gdc06
 
   CALL g_gdct.clear()
 
   LET g_forupd_sql= "SELECT unique gdc05 FROM gdc_file ",
                     " WHERE gdc01 = '",g_gcy.gcy01 CLIPPED, "' ",
                     "   AND gdc02 = '",g_gcy.gcy02 CLIPPED,"'",  
                     "   AND gdc03 = '",g_gcy.gcy03 CLIPPED,"'",  
                     "   AND gdc04 = '",g_gcy.gcy04 CLIPPED,"'"  
   DECLARE p_gdct_cl CURSOR FROM g_forupd_sql     
   
   LET g_forupd_sql= "SELECT gdc06  FROM gdc_file ",
                     " WHERE gdc01 = '",g_gcy.gcy01 CLIPPED,"' AND gdc05 = ? ",
                     "   AND gdc02 = '",g_gcy.gcy02 CLIPPED,"' ", 
                     "   AND gdc03 = '",g_gcy.gcy03 CLIPPED,"' ", 
                     "   AND gdc04 = '",g_gcy.gcy04 CLIPPED,"' ", 
                     " ORDER BY gdc06 "
   DECLARE p_gdct2_cl CURSOR FROM g_forupd_sql     
   LET l_i   = 1
   FOREACH p_gdct_cl INTO g_gdct[l_i].gdc05t
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_gdct[l_i].gdc05t IS NULL THEN
           EXIT FOREACH
       ELSE
           FOREACH p_gdct2_cl USING g_gdct[l_i].gdc05t INTO l_gdc06
               IF cl_null(g_gdct[l_i].gdc06t) THEN
                  LET g_gdct[l_i].gdc06t = l_gdc06 CLIPPED
                  LET l_j = 1
               ELSE
                  LET g_gdct[l_i].gdc06t = g_gdct[l_i].gdc06t CLIPPED,",",l_gdc06 CLIPPED
               END IF
           END FOREACH
           LET l_i = l_i + 1
        END IF
   END FOREACH
   CALL g_gdct.deleteElement(l_i)
   LET g_gdct_cnt = l_i - 1
 
   IF g_gdct_cnt = 0 AND g_wizard_choice <> "exit" 
      AND g_wizard_choice <> 'wizard_table' 
      AND g_wizard_choice <> 'wizard_field' 
   THEN
      CALL cl_err('','azz-245',1)
      LET g_wizard_choice = 'wizard_field'
   END IF
   
END FUNCTION
 
FUNCTION p_wizard_gdc_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_items       STRING
DEFINE l_str         STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_tag         LIKE type_file.num5
DEFINE l_gdc07       LIKE gdc_file.gdc07
 
   CALL g_gdc.clear()
   LET g_forupd_sql= "SELECT gdc05,gdc06,gaq03,gdc07  FROM gdc_file,gaq_file ",
                     " WHERE gdc01 = '",g_gcy.gcy01 CLIPPED, "' ",
                     "   AND gdc02 = '",g_gcy.gcy02 CLIPPED,"' ", 
                     "   AND gdc03 = '",g_gcy.gcy03 CLIPPED,"' ", 
                     "   AND gdc04 = '",g_gcy.gcy04 CLIPPED,"' ", 
                     "   AND gdc06 = gaq01 ",
                     "   AND gaq02 = '",g_lang,"'",
                     " ORDER BY gdc07"
   DECLARE p_gdc2_cl CURSOR FROM g_forupd_sql     
   LET l_i   = 1
   LET l_tag = 0
   FOREACH p_gdc2_cl INTO g_gdc[l_i].gdc05,g_gdc[l_i].gdc06,g_gdc[l_i].gaq03,l_gdc07
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_gdc[l_i].gdc05 IS NULL THEN
           EXIT FOREACH
       ELSE
           LET l_i = l_i + 1
        END IF
   END FOREACH
   CALL g_gdc.deleteElement(l_i)
   LET g_gdc_cnt = l_i - 1
 
   IF g_gdc_cnt = 0 AND g_wizard_choice <> "exit" 
      AND g_wizard_choice <> 'wizard_table' 
      AND g_wizard_choice <> 'wizard_field' 
   THEN
      CALL cl_err('','azz-245',1)
      LET g_wizard_choice = 'wizard_field'
   END IF
   
END FUNCTION
 
FUNCTION p_wizard_gdd_b_fill()
DEFINE l_i           LIKE type_file.num5
DEFINE l_items       STRING
DEFINE l_str         STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_tag         LIKE type_file.num5
 
   CALL g_gdd.clear()
   LET g_forupd_sql= "SELECT gdd05,gdd06,gdd07,gdd08,gdd09,gdd10,gdd11,gdd12,",
                     " gdd13 FROM gdd_file ",
                     " WHERE gdd01 = '",g_gcy.gcy01 CLIPPED,"' ",
                     "   AND gdd02 = '",g_gcy.gcy02 CLIPPED,"' ", 
                     "   AND gdd03 = '",g_gcy.gcy03 CLIPPED,"' ", 
                     "   AND gdd04 = '",g_gcy.gcy04 CLIPPED,"' ", 
                     " ORDER BY gdd05"
   DECLARE p_gdd2_cl CURSOR FROM g_forupd_sql     
   LET l_i   = 1
   LET l_tag = 0
   FOREACH p_gdd2_cl INTO g_gdd[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_gdd[l_i].gdd05 IS NULL THEN
           EXIT FOREACH
       ELSE
           LET l_i = l_i + 1
       END IF
   END FOREACH
   CALL g_gdd.deleteElement(l_i)
   LET g_gdd_cnt = l_i - 1
 
END FUNCTION
 
FUNCTION p_wizard_check_field(p_field,p_table,p_cmd)
DEFINE p_field   STRING
DEFINE p_table   STRING
DEFINE p_cmd     STRING
DEFINE l_str     STRING
DEFINE ls_sql    STRING
DEFINE l_status  LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_tok     base.StringTokenizer
 
   LET g_zta17 = NULL
   LET g_zta01= p_table CLIPPED
   SELECT zta17 INTO g_zta17 
     FROM zta_file WHERE zta01 = g_zta01 AND zta02 = g_dbs
 
   IF p_field.getIndexOf(',',1) > 0 AND p_cmd = 'Y' THEN
      LET l_tok = base.StringTokenizer.createExt(p_field,",","",TRUE)
      WHILE l_tok.hasMoreTokens()
         LET l_str = l_tok.nextToken()
         LET l_str = l_str.trim()             #FUN-950038

         #---FUN-A90024---start-----
         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構
         ##IF g_db_type = 'IFX' THEN
         #CASE g_db_type                                     
         # WHEN "IFX"                                        
         #   #END FUN-7C0020
         #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
         #      LET ls_sql =
         #          "SELECT COUNT(*)",
         #          " FROM ",g_zta17 CLIPPED,":syscolumns c,",
         #          "      ",g_zta17 CLIPPED,":systables t",
         #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
         #          "   AND c.colname='",l_str,"'"
         #   ELSE
         #      LET ls_sql =
         #          "SELECT COUNT(*)",
         #          " FROM syscolumns c,systables t",
         #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
         #          "   AND c.colname='",l_str,"'"
         #   END IF
         #
         # WHEN "ORA"                                      
         #   #FUN-7C0020
         #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
         #      LET ls_sql =
         #          "SELECT COUNT(*) FROM all_tab_columns",
         #          " WHERE lower(table_name)='",p_table CLIPPED,"'",
         #          "   AND lower(column_name)='",l_str,"'"
         #   ELSE
         #      LET ls_sql =
         #          "SELECT COUNT(*) FROM user_tab_columns",
         #          " WHERE lower(table_name)='",p_table CLIPPED,"'",
         #          "   AND lower(column_name)='",l_str,"'"
         #   END IF
         #
         # WHEN "MSV"                                           
         #   #FUN-810062
         #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
         #      LET ls_sql =
         #          "SELECT COUNT(*) ",
         #          "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
         #          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
         #          " WHERE a.object_id = b.object_id ",
         #          "   AND a.name='",p_table CLIPPED,"'",
         #          "   AND b.name='",l_str,"'"
         #   ELSE
         #      LET ls_sql =
         #          "SELECT COUNT(*) FROM sys.objects a,sys.columns b",
         #          " WHERE a.object_id = b.object_id ",
         #          "   AND a.name='",p_table CLIPPED,"'",
         #          "   AND b.name='",l_str,"'"
         #   END IF
         #   #END FUN-810062
         #END CASE                                                #FUN-750084
         LET ls_sql =
             "SELECT COUNT(*) FROM sch_file ",
             " WHERE sch01 = '",p_table CLIPPED,"'",
             "   AND sch02 = '",l_str,"'"
         #---FUN-A90024---end-------
         
         PREPARE query2_precount FROM ls_sql
         DECLARE query2_count CURSOR FOR query2_precount
         OPEN query2_count
         FETCH query2_count INTO l_cnt
         IF l_cnt = 0 THEN
            LET l_str= p_table,"+",l_str
            CALL cl_err(l_str,NOTFOUND,0)
            RETURN 0
         END IF
      END WHILE
   ELSE
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      ##IF g_db_type = 'IFX' THEN
      #CASE g_db_type                                            
      # WHEN "IFX"                                               
      #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
      #      LET ls_sql =
      #          "SELECT COUNT(*)",
      #          " FROM ",g_zta17 CLIPPED,":syscolumns c,",
      #                   g_zta17 CLIPPED,":systables t",
      #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
      #          "   AND c.colname='",p_field,"'"
      #   ELSE
      #      LET ls_sql =
      #          "SELECT COUNT(*)",
      #          " FROM syscolumns c,systables t",
      #          " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
      #          "   AND c.colname='",p_field,"'"
      #   END IF
      #
      # WHEN "ORA"                                     
      #   #FUN-7C0020
      #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
      #      LET ls_sql =
      #          "SELECT COUNT(*) FROM all_tab_columns",
      #          " WHERE lower(table_name)='",p_table,"'",
      #          "   AND lower(column_name)='",p_field,"'"
      #   ELSE
      #      LET ls_sql =
      #          "SELECT COUNT(*) FROM user_tab_columns",
      #          " WHERE lower(table_name)='",p_table,"'",
      #          "   AND lower(column_name)='",p_field,"'"
      #   END IF
      # 
      # WHEN "MSV"                                         
      #   #FUN-810062
      #   IF NOT cl_null(g_zta17 CLIPPED) THEN 
      #      LET ls_sql =
      #          "SELECT COUNT(*) ",
      #          "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
      #          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
      #          " WHERE a.object_id = b.object_id ",
      #          "   AND a.name='",p_table CLIPPED,"'",
      #          "   AND b.name='",p_field,"'"
      #   ELSE
      #      LET ls_sql =
      #          "SELECT COUNT(*) FROM sys.objects a,sys.columns b",
      #          " WHERE a.object_id = b.object_id ",
      #          "   AND a.name='",p_table CLIPPED,"'",
      #          "   AND b.name='",p_field,"'"
      #   END IF
      #
      #END CASE
      LET ls_sql =
          "SELECT COUNT(*) FROM sch_file ",
          " WHERE sch01 = '",p_table CLIPPED,"'",
          "   AND sch02 = '",p_field CLIPPED,"'"
      #---FUN-A90024---end-------
      
      PREPARE query3_precount FROM ls_sql
      DECLARE query3_count CURSOR FOR query3_precount
      OPEN query3_count
      FETCH query3_count INTO l_cnt
      IF l_cnt = 0 THEN
         IF g_action_choice <> "query_auth_i" THEN
            LET l_str= p_table,"+",p_field
            CALL cl_err(l_str,NOTFOUND,0)
         END IF
         RETURN 0
      END IF
   END IF
   RETURN 1
END FUNCTION
 
FUNCTION p_wizard_swe01()
DEFINE l_i         LIKE type_file.num5
DEFINE l_tag       LIKE type_file.num5
DEFINE l_str       STRING
DEFINE l_tok       base.StringTokenizer 
DEFINE l_gdd09     STRING
DEFINE l_gdd13     STRING
DEFINE buf         base.StringBuffer
 
    LET l_tag = 0
    LET g_swe01 = "SELECT"
   
    #組 SQL 字串: SELECT 欄位
    FOR l_i = 1 TO g_gdc_cnt
      LET l_str = g_gdc[l_i].gdc06 CLIPPED
      IF l_str.getIndexOf(',',1) > 0  THEN
         LET l_tok = base.StringTokenizer.createExt(l_str,",","",TRUE)
         WHILE l_tok.hasMoreTokens()
            LET l_str = l_tok.nextToken()
            IF l_i = 1 AND l_tag = 0 THEN
               LET g_swe01 = g_swe01," ",g_gdc[l_i].gdc05 CLIPPED,".",l_str
               LET l_tag = 1
            ELSE
               LET g_swe01 = g_swe01,",",g_gdc[l_i].gdc05 CLIPPED,".",l_str
            END IF
         END WHILE 
      ELSE
         IF l_i = 1 THEN
            LET g_swe01 = g_swe01," ",g_gdc[l_i].gdc05 CLIPPED,".",l_str
         ELSE
            LET g_swe01 = g_swe01,", ",g_gdc[l_i].gdc05 CLIPPED,".",l_str
         END IF
      END IF
    END FOR
 
    #組 SQL 字串:FROM TABLE
    LET g_swe01 = g_swe01 ,"\n  FROM"
    FOR l_i = 1 TO g_gdb_cnt
        IF l_i = 1 THEN
           LET g_swe01 = g_swe01," ",g_gdb[l_i].gdb05 CLIPPED
        ELSE
           IF g_gdb[l_i].gdb06 = 'Y' THEN
              LET g_swe01 = g_swe01,",OUTER ",g_gdb[l_i].gdb05 CLIPPED
           ELSE
              LET g_swe01 = g_swe01,",",g_gdb[l_i].gdb05 CLIPPED
           END IF
        END IF
    END FOR  
 
    #組 SQL 字串: WHERE 條件
    FOR l_i = 1 TO g_gdd_cnt
        LET l_gdd09 = ""
        LET l_gdd13 = ""
        CASE g_gdd[l_i].gdd09
           WHEN '1'     LET l_gdd09 = "="
           WHEN '2'     LET l_gdd09 = ">"
           WHEN '3'     LET l_gdd09 = "<"
           WHEN '4'     LET l_gdd09 = ">="
           WHEN '5'     LET l_gdd09 = "<="
           WHEN '6'     LET l_gdd09 = "!="
           WHEN '7'     LET l_gdd09 = "BETWEEN"
           WHEN '8'     LET l_gdd09 = "NOT BETWEEN"
           WHEN '9'     LET l_gdd09 = "LIKE "
           WHEN '10'    LET l_gdd09 = "NOT LIKE" 
           WHEN '11'    LET l_gdd09 = "IS NULL" 
           WHEN '12'    LET l_gdd09 = "IS NOT NULL" 
        END CASE
        CASE g_gdd[l_i].gdd13
           WHEN '1'     LET l_gdd13 = "OR"
           WHEN '2'     LET l_gdd13 = "AND"
        END CASE       
 
        IF l_i = 1 THEN
           LET g_swe01 = g_swe01 ,"\n WHERE "
        ELSE
           LET g_swe01 = g_swe01,"       "
        END IF
        LET g_swe01 = g_swe01,
                 g_gdd[l_i].gdd06 CLIPPED," ",g_gdd[l_i].gdd07 CLIPPED,".",
                 g_gdd[l_i].gdd08 CLIPPED," ",l_gdd09 CLIPPED," "
        IF g_gdd[l_i].gdd10 IS NOT NULL THEN
            LET g_swe01 = g_swe01,
                g_gdd[l_i].gdd10 CLIPPED,".", g_gdd[l_i].gdd11 CLIPPED," ",
                g_gdd[l_i].gdd12 CLIPPED," ",l_gdd13 CLIPPED,"\n"
        ELSE
            IF g_gdd[l_i].gdd09 = '7'  OR g_gdd[l_i].gdd09 = '8'  OR
               g_gdd[l_i].gdd09 = '11' OR g_gdd[l_i].gdd09 = '12' 
            THEN
               LET g_swe01 = g_swe01, g_gdd[l_i].gdd11 CLIPPED," ",
                   g_gdd[l_i].gdd12 CLIPPED," ",l_gdd13 CLIPPED,"\n"
            ELSE
               IF g_gdd[l_i].gdd09 = '9'  OR g_gdd[l_i].gdd09 = '10' THEN
                  LET buf = base.StringBuffer.create()
                  CALL buf.append(g_gdd[l_i].gdd11 CLIPPED)
                  CALL buf.replace( "*","%", 0)
                  LET g_gdd[l_i].gdd11  = buf.toString()
               END IF
               LET g_swe01 = g_swe01," '",g_gdd[l_i].gdd11 CLIPPED,"' ",
                   g_gdd[l_i].gdd12 CLIPPED," ",l_gdd13 CLIPPED,"\n"
            END IF
        END IF
    END FOR  
 
END FUNCTION
 
FUNCTION p_wizard_finish()
DEFINE l_field     RECORD
        field001, field002, field003, field004, field005, field006, field007,
        field008, field009, field010, field011, field012, field013, field014,
        field015, field016, field017, field018, field019, field020, field021,
        field022, field023, field024, field025, field026, field027, field028,
        field029, field030, field031, field032, field033, field034, field035,
        field036, field037, field038, field039, field040, field041, field042,
        field043, field044, field045, field046, field047, field048, field049,
        field050, field051, field052, field053, field054, field055, field056,
        field057, field058, field059, field060, field061, field062, field063,
        field064, field065, field066, field067, field068, field069, field070,
        field071, field072, field073, field074, field075, field076, field077,
        field078, field079, field080, field081, field082, field083, field084,
        field085, field086, field087, field088, field089, field090, field091,
        field092, field093, field094, field095, field096, field097, field098,
        field099, field100  LIKE gaq_file.gaq03   
                  END RECORD
 
        PREPARE wizard_pre FROM g_swe01
        IF SQLCA.SQLCODE THEN
           CALL cl_err('','zta-028',1)
           RETURN 0
        END IF
 
        DECLARE wizard_cur CURSOR FOR wizard_pre 
        IF SQLCA.SQLCODE THEN
           CALL cl_err('2->','zta-028',1)
           RETURN 0
        END IF
 
        FOREACH wizard_cur INTO l_field.*
           EXIT FOREACH
        END FOREACH
        IF SQLCA.SQLCODE THEN
           CALL cl_err("wizard_cur:",sqlca.sqlcode,1)
           RETURN 0
        END IF
 
        LET g_gda.gda05 = g_swe01
        
    RETURN 1
END FUNCTION
 
FUNCTION p_crdata_copy()
DEFINE
       l_newno         LIKE gcy_file.gcy01,
       l_newcust       LIKE gcy_file.gcy02,
       l_newgrup       LIKE gcy_file.gcy03,
       l_newuser       LIKE gcy_file.gcy04,
       l_gcy01_t       LIKE gcy_file.gcy01,
       l_gcy02_t       LIKE gcy_file.gcy02,
       l_gcy03_t       LIKE gcy_file.gcy03,
       l_gcy04_t       LIKE gcy_file.gcy04
DEFINE l_str           STRING
DEFINE li_result       LIKE type_file.num5,     
       l_n             LIKE type_file.num5    # 檢查重複用    
DEFINE l_zwacti        LIKE zw_file.zwacti
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gcy.gcy01 IS NULL THEN
        CALL cl_err('',-420,0)
        RETURN
    END IF
 
    LET l_gcy01_t = g_gcy.gcy01
    LET l_gcy02_t = g_gcy.gcy02
    LET l_gcy03_t = g_gcy.gcy03
    LET l_gcy04_t = g_gcy.gcy04
 
    CALL cl_set_head_visible("","YES")         
 
    LET g_before_input_done = FALSE  
    CALL query_set_entry('a')        
    LET g_before_input_done = TRUE   
 
 
    INPUT l_newno,l_newuser,l_newgrup,l_newcust FROM gcy01,gcy04,gcy03,gcy02  
      BEFORE INPUT
         LET l_newcust = "N"
         LET l_newgrup = g_gcy.gcy03
         LET l_newuser = g_gcy.gcy04
         DISPLAY l_newcust TO gcy02
         DISPLAY l_newgrup TO gcy03
         DISPLAY l_newuser TO gcy04
 
         INITIALIZE g_gaz03 TO NULL
         DISPLAY g_gaz03 TO FORMONLY.gaz03
 
         CALL p_crdata_set_zw02(l_newgrup)
         CALL p_crdata_set_zx02(l_newuser)
 
         IF l_newgrup = 'default' THEN
            IF l_newuser <> 'default' THEN
               CALL cl_set_comp_entry("gcy04",TRUE)
               CALL cl_set_comp_entry("gcy03",FALSE)
            ELSE
               CALL cl_set_comp_entry("gcy03",TRUE)
               CALL cl_set_comp_entry("gcy04",TRUE)
            END IF
         ELSE
            IF l_newuser = 'default' THEN
               CALL cl_set_comp_entry("gcy03",TRUE)
               CALL cl_set_comp_entry("gcy04",FALSE)
            END IF
         END IF
 
      AFTER FIELD gcy01
         IF NOT cl_null(l_newno) THEN
            SELECT COUNT(*) INTO g_zz_cnt FROM zz_file WHERE zz01=l_newno
            IF g_zz_cnt = 0 THEN
               CALL cl_err(l_newno CLIPPED,'azz-052',0)
               NEXT FIELD gcy01
            END IF
          END IF
          CALL cl_get_progname(l_newno,g_lang) RETURNING g_gaz03
          DISPLAY g_gaz03 TO FORMONLY.gaz03
 
 
     BEFORE FIELD gcy03      
          IF l_newgrup = 'default' THEN
             CALL cl_set_comp_entry("gcy03",TRUE)
          END IF
 
 
     AFTER FIELD gcy03      
         IF NOT cl_null(l_newgrup) THEN
            IF l_newgrup CLIPPED  <> 'default' THEN
               SELECT zwacti INTO l_zwacti FROM zw_file
                WHERE zw01 = l_newgrup
               IF STATUS THEN
                   CALL cl_err3("sel","zw_file",l_newgrup,"",STATUS,"","SELECT "|| l_newgrup,0)    #No.FUN-660081
                   NEXT FIELD gcy03
               ELSE
                  IF l_zwacti != "Y" THEN 
                     CALL cl_err_msg(NULL,"azz-218",l_newgrup CLIPPED,10)
                     NEXT FIELD gcy03
                  END IF
               END IF
            END IF
         END IF
         IF l_newgrup = 'default' THEN
            IF l_newuser <> 'default' THEN
               CALL cl_set_comp_entry("gcy04",TRUE)
               CALL cl_set_comp_entry("gcy03",FALSE)
            ELSE
               CALL cl_set_comp_entry("gcy03",TRUE)
               CALL cl_set_comp_entry("gcy04",TRUE)
            END IF
         ELSE
            IF l_newuser = 'default' THEN
               CALL cl_set_comp_entry("gcy03",TRUE)
               CALL cl_set_comp_entry("gcy04",FALSE)
            END IF
         END IF
         CALL p_crdata_set_zw02(l_newgrup)
 
     BEFORE FIELD gcy04
         IF l_newuser = 'default' THEN
            CALL cl_set_comp_entry("gcz03",TRUE)
         END IF
 
     AFTER FIELD gcy04
         IF NOT cl_null(l_newuser) THEN
            IF l_newuser CLIPPED  <> 'default' THEN
               SELECT COUNT(*) INTO g_cnt FROM zx_file
                WHERE zx01 = l_newuser
               IF g_cnt = 0 THEN
                   CALL cl_err(l_newuser,'mfg1312',0)
                   NEXT FIELD gcy04
               END IF
            END IF
            IF l_newuser = 'default' THEN
               IF l_newgrup <> 'default' THEN
                  CALL cl_set_comp_entry("gcy03",TRUE)
                  CALL cl_set_comp_entry("gcy04",FALSE)
               ELSE
                  CALL cl_set_comp_entry("gcy03",TRUE)
                  CALL cl_set_comp_entry("gcy04",TRUE)
               END IF
            ELSE
               IF l_newgrup = 'default' THEN
                  CALL cl_set_comp_entry("gcy04",TRUE)
                  CALL cl_set_comp_entry("gcy03",FALSE)
               END IF
            END IF
 
         END IF
         CALL p_crdata_set_zx02(l_newuser)
 
      AFTER INPUT 
         IF INT_FLAG THEN                            # 使用者不玩了
            EXIT INPUT
         END IF
         SELECT count(*) INTO l_n FROM gcy_file
           WHERE gcy01 = l_newno    AND gcy02 = l_newcust
             AND gcy03 = l_newgrup  AND gcy04 = l_newuser
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            NEXT FIELD gcy01
         END IF
 
         SELECT COUNT(*) INTO g_cnt FROM gcy_file
          WHERE gcy01 = l_newno   AND gcy04 = "default"
            AND gcy02 = l_newcust AND gcy03 = "default"
         IF g_cnt = 0 THEN
            IF (l_newgrup <> "default" AND l_newuser='default') THEN
               CALL cl_err(l_newno,'azz-086',1)
               NEXT FIELD gcy03
            END IF
            IF (l_newuser <> "default" AND l_newgrup='default') THEN
               CALL cl_err(l_newno,'azz-086',1)
               NEXT FIELD gcy04
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gcy01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= l_newno
               CALL cl_create_qry() RETURNING l_newno
               DISPLAY l_newno TO gcy01
               CALL cl_get_progname(l_newno,g_lang) RETURNING g_gaz03
               DISPLAY g_gaz03 TO FORMONLY.gaz03
               NEXT FIELD gcy01
 
            WHEN INFIELD(gcy03)                    
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zw"
              LET g_qryparam.default1= l_newgrup
              CALL cl_create_qry() RETURNING l_newgrup
              DISPLAY l_newgrup TO gcy03
              CALL p_crdata_set_zw02(l_newgrup)
              NEXT FIELD gcy03
 
            WHEN INFIELD(gcy04)                    
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zx"
              LET g_qryparam.default1= l_newuser
              CALL cl_create_qry() RETURNING l_newuser
              DISPLAY l_newuser TO gcy04
              CALL p_crdata_set_zx02(l_newuser)
              NEXT FIELD gcy04
 
            OTHERWISE
               EXIT CASE
         END CASE
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
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_gcy.gcy01
        RETURN
    END IF
 
    BEGIN WORK                                  #TQC-790050
 
    DROP TABLE y
    SELECT * FROM gcy_file         #單頭複製
        WHERE gcy01 = l_gcy01_t AND gcy02 = l_gcy02_t
          AND gcy03 = l_gcy03_t AND gcy04 = l_gcy04_t
        INTO TEMP y
    UPDATE y
        SET gcy01=l_newno,    #新的鍵值
            gcy02=l_newcust,  #客製否
            gcy03=l_newgrup,  #權限類別
            gcy04=l_newuser,  #使用者
            gcyuser=g_user,   #資料所有者
            gcygrup=g_grup,   #資料所有者所屬群
            gcymodu=NULL,     #資料修改日期
            gcydate=g_today   #資料建立日期
 
    INSERT INTO gcy_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gcy_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK
        RETURN
    END IF
 
    #複製 gda_file
    DROP TABLE x
    SELECT * FROM gda_file         #單身複製
        WHERE gda01=l_gcy01_t AND gda02=l_gcy02_t
          AND gda03=l_gcy03_t AND gda04=l_gcy04_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gda_file",l_gcy01_t,l_gcy02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET gda01=l_newno,   
            gda02=l_newcust,
            gda03=l_newgrup,
            gda04=l_newuser
    INSERT INTO gda_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gda_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 gcz_file
    DROP TABLE x
    SELECT * FROM gcz_file         #單身複製
        WHERE gcz01=l_gcy01_t AND gcz02=l_gcy02_t
          AND gcz03=l_gcy03_t AND gcz04=l_gcy04_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gcz_file",l_gcy01_t,l_gcy02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET gcz01=l_newno,   
            gcz02=l_newcust,
            gcz03=l_newgrup,
            gcz04=l_newuser
    INSERT INTO gcz_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gcz_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 gdb_file
    DROP TABLE x
    SELECT * FROM gdb_file         #單身複製
        WHERE gdb01=l_gcy01_t AND gdb02=l_gcy02_t
          AND gdb03=l_gcy03_t AND gdb04=l_gcy04_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gdb_file",l_gcy01_t,l_gcy02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET gdb01=l_newno,   
            gdb02=l_newcust,
            gdb03=l_newgrup,
            gdb04=l_newuser
    INSERT INTO gdb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gdb_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 gdc_file
    DROP TABLE x
    SELECT * FROM gdc_file         #單身複製
        WHERE gdc01=l_gcy01_t AND gdc02=l_gcy02_t
          AND gdc03=l_gcy03_t AND gdc04=l_gcy04_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gdc_file",l_gcy01_t,l_gcy02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET gdc01=l_newno,   
            gdc02=l_newcust,
            gdc03=l_newgrup,
            gdc04=l_newuser
    INSERT INTO gdc_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gdc_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    #複製 gdd_file
    DROP TABLE x
    SELECT * FROM gdd_file         #單身複製
        WHERE gdd01=l_gcy01_t AND gdd02=l_gcy02_t
          AND gdd03=l_gcy03_t AND gdd04=l_gcy04_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gdd_file",l_gcy01_t,l_gcy02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
    UPDATE x
        SET gdd01=l_newno,   
            gdd02=l_newcust,
            gdd03=l_newgrup,
            gdd04=l_newuser
    INSERT INTO gdd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gdd_file",l_newno,l_newcust,SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK                                     #TQC-790050
        RETURN
    END IF
 
    COMMIT WORK                               
 
    SELECT * INTO g_gcy.* FROM gcy_file
     WHERE gcy01 = l_newno   AND gcy02 = l_newcust
       AND gcy03 = l_newgrup AND gcy04 = l_newuser
 
    CALL p_crdata_u()
 
    #SELECT * INTO g_gcy.* FROM gcy_file             #FUN-C30027
    # WHERE gcy01 = l_gcy01_t AND gcy02 = l_gcy02_t  #FUN-C30027
    #   AND gcy03 = l_gcy03_t AND gcy04 = l_gcy04_t  #FUN-C30027
 
    CALL p_crdata_show()
 
    DISPLAY BY NAME g_gcy.gcy01
END FUNCTION
 
#[
# Description....: 取得 SQL 指令的欄位型態及長度
# Date & Author..: 2007/07/25 by Echo
# Parameter......: p_colname - CHAR - 欄位名稱
# Return.........: l_datatype - CHAR - 欄位型態
#                : l_length - CHAR - 欄位長度
#]
FUNCTION p_crdata_field_type(p_colname)
DEFINE p_colname        STRING                
DEFINE l_colname        LIKE gcz_file.gcz07   
DEFINE l_tabname        STRING
DEFINE l_cnt            LIKE type_file.num10  
DEFINE l_sql            STRING
DEFINE l_table_name     LIKE gac_file.gac05
DEFINE l_length         STRING
DEFINE l_gda05          STRING
DEFINE l_index          LIKE type_file.num5  
DEFINE l_datatype       LIKE type_file.chr20 
DEFINE l_p              LIKE type_file.num5
DEFINE l_str            STRING               
DEFINE l_dbname         STRING    
 
    LET l_colname = p_colname.subString(p_colname.getIndexOf('.',1)+1,p_colname.getLength())  #FUN-820043
 
    LET l_tabname = ""

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構
    #CASE g_db_type 
    #  WHEN "ORA" 
    #    LET l_sql= "SELECT UNIQUE TABLE_NAME FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = UPPER( ? ) AND OWNER='DS'"
    #  WHEN "IFX" 
    #    SELECT COUNT(*) INTO l_cnt FROM syscolumns WHERE colname = l_colname
    #    IF l_cnt = 0 THEN 
    #       LET l_sql = "SELECT tabname FROM ds:syscolumns col, ds:systables tab WHERE col.colname = ? AND tab.tabid = col.tabid"  #FUN-750084
    #    ELSE
    #       LET l_sql = "SELECT tabname FROM syscolumns col, systables tab WHERE col.colname = ? AND tab.tabid = col.tabid"  #FUN-750084
    #    END IF
    #  WHEN "MSV"    
    #    SELECT COUNT(*) INTO l_cnt FROM sys.columns WHERE name = l_colname 
    #    IF l_cnt = 0 THEN 
    #       LET l_sql =
    #           "SELECT distinct a.name ",
    #           "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
    #           "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
    #           " WHERE a.object_id = b.object_id ",
    #           "   AND b.name='",l_str,"'"
    #    ELSE
    #       LET l_sql = "SELECT distinct a.name ",
    #                   "  FROM sys.objects a, sys.columns b",
    #                   " WHERE b.name = ? ",
    #                   "   AND a.object_id = b.object_id"
    #    END IF
    #END CASE
    #
    #DECLARE table_cur CURSOR FROM l_sql
    #FOREACH table_cur USING l_colname INTO l_table_name
    #   LET l_gda05 = g_gda.gda05
    #
    #   IF g_db_type ="ORA" THEN
    #      LET l_gda05 = l_gda05.toUpperCase()
    #   END IF
    #
    #   LET l_index = l_gda05.getIndexOf(l_table_name CLIPPED,1)
    #   IF l_index != 0 THEN
    #       LET l_tabname = l_table_name
    #       EXIT FOREACH
    #   END IF
    #END FOREACH
    LET l_gda05 = g_gda.gda05
    LET l_table_name = cl_get_table_name(l_colname)
    LET l_index = l_gda05.getIndexOf(l_table_name CLIPPED,1)
    IF l_index != 0 THEN
       LET l_tabname = l_table_name
    END IF
    #---FUN-A90024---end-------

    IF cl_null(l_tabname) THEN
        LET l_str = l_colname CLIPPED
        IF l_str.getIndexOF('|',1) > 0 THEN
           RETURN 'char',''
        ELSE
           RETURN '',''
        END IF
    END IF
 
    CASE g_db_type                        
      WHEN "MSV"
         LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
      OTHERWISE
         LET l_dbname = 'ds'
    END CASE
 
    CALL cl_get_column_info(l_dbname,l_tabname.toLowerCase(),l_colname)
        RETURNING l_datatype,l_length
    IF l_datatype  = 'date' THEN
       LET l_length = '10'
    END IF
    
    IF l_datatype = "number" OR l_datatype = "decimal" THEN
       LET l_p = l_length.getIndexOf(',',1)
       IF l_p > 0 THEN
          LET l_length = l_length.subString(1,l_p-1)
       END IF
    END IF
 
    RETURN l_datatype,l_length
 
END FUNCTION
 
FUNCTION p_crdata_gda05_chk()
DEFINE l_text        STRING
DEFINE l_str         STRING
DEFINE l_tmp         STRING
DEFINE l_execmd      STRING
DEFINE l_tok         base.StringTokenizer 
DEFINE l_start       LIKE type_file.num5   
DEFINE l_end         LIKE type_file.num5   
DEFINE buf           base.StringBuffer
DEFINE l_i           LIKE type_file.num5   
DEFINE l_p           LIKE type_file.num5   
DEFINE l_tok_table   base.StringTokenizer
DEFINE l_cnt_dot     LIKE type_file.num5
DEFINE l_cnt_comma   LIKE type_file.num5
DEFINE l_arg         STRING                
DEFINE l_field       RECORD
        field001, field002, field003, field004, field005, field006, field007,
        field008, field009, field010, field011, field012, field013, field014,
        field015, field016, field017, field018, field019, field020, field021,
        field022, field023, field024, field025, field026, field027, field028,
        field029, field030, field031, field032, field033, field034, field035,
        field036, field037, field038, field039, field040, field041, field042,
        field043, field044, field045, field046, field047, field048, field049,
        field050, field051, field052, field053, field054, field055, field056,
        field057, field058, field059, field060, field061, field062, field063,
        field064, field065, field066, field067, field068, field069, field070,
        field071, field072, field073, field074, field075, field076, field077,
        field078, field079, field080, field081, field082, field083, field084,
        field085, field086, field087, field088, field089, field090, field091,
        field092, field093, field094, field095, field096, field097, field098,
        field099, field100  LIKE gaq_file.gaq03   
                     END RECORD
 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_gda.gda05 CLIPPED)
    CALL buf.replace( "\"","'", 0)
    LET g_gda.gda05  = buf.toString()
 
    LET l_str= g_gda.gda05 CLIPPED             
    LET l_end = l_str.getIndexOf(';',1)
    IF l_end != 0 THEN
       LET l_str=l_str.subString(1,l_end-1)
    END IF
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
    LET l_text = NULL
    WHILE l_tok.hasMoreTokens()
          LET l_tmp=l_tok.nextToken()
          IF l_text is null THEN
             LET l_text = l_tmp.trim()
          ELSE
             LET l_text = l_text CLIPPED,' ',l_tmp.trim()
          END IF
    END WHILE
    LET l_tmp=l_text
    LET l_execmd=l_tmp
 
    LET l_execmd = l_execmd.toLowerCase()
    LET l_start = l_execmd.getIndexOf('select',1)
 
    IF l_start > 0 THEN
        
       PREPARE sql_pre1 FROM l_execmd
       IF SQLCA.SQLCODE THEN
          LET g_err_str = "prepare:"
          LET g_errno = SQLCA.SQLCODE
          RETURN 0
       END IF
   
       DECLARE sql_cur1 CURSOR FOR sql_pre1
       IF SQLCA.SQLCODE THEN
          LET g_err_str = "DECLARE sql_cur1:"
          LET g_errno = SQLCA.SQLCODE
          RETURN 0
       END IF
   
       FOREACH sql_cur1 INTO l_field.*
          EXIT FOREACH
       END FOREACH
       IF SQLCA.SQLCODE THEN
          LET g_err_str = "prepare:"
          LET g_errno = SQLCA.SQLCODE
          RETURN 0
       END IF
       LET g_execmd = l_execmd
    ELSE
       LET l_tok_table = base.StringTokenizer.create(l_execmd,".")
       LET l_cnt_dot = l_tok_table.countTokens()
       LET l_tok_table = base.StringTokenizer.create(l_execmd,",")
       LET l_cnt_comma = l_tok_table.countTokens()
       IF ((l_cnt_dot-1)/2)  <> l_cnt_comma THEN
          LET g_err_str =""
          LET g_errno = 'lib-359'
          RETURN 0
       END IF
   
       IF NOT p_crdata_gda05_parse(l_execmd) THEN #No.FUN-860089 
          RETURN 0
       END IF
 
       LET buf = base.StringBuffer.create()
       CALL buf.append(g_gda.gda05 CLIPPED)
       CALL buf.replace( " ","", 0)
       CALL buf.replace( "	","", 0)
       LET g_gda.gda05  = buf.toString()
    END IF
 
    RETURN 1
END FUNCTION
 
#解析 gda05 字串及檢查是否符於標準寫法，如: ima01.ima_file.ima01
FUNCTION p_crdata_gda05_parse(p_execmd)
DEFINE p_execmd           STRING             
DEFINE l_tok_table        base.StringTokenizer,
       l_table_name       LIKE gac_file.gac05,
       l_field_name       LIKE gac_file.gac06,
       l_alias_name       LIKE gac_file.gac06,
       l_datatype         LIKE ztb_file.ztb04
DEFINE l_p                LIKE type_file.num5,
       l_p2               LIKE type_file.num5,
       l_name             STRING,
       l_length           STRING
DEFINE l_dbname           STRING
 
 
    LET l_tok_table = base.StringTokenizer.create(p_execmd,",")  
    WHILE l_tok_table.hasMoreTokens()
       #DISPLAY l_tok_table.nextToken()
       LET l_name = l_tok_table.nextToken()
       LET l_p = l_name.getIndexOf(".",1)
       LET l_p2 = l_name.getIndexOf(".",l_p+1)
       LET l_alias_name = l_name.subString(1,l_p-1)
       LET l_table_name = l_name.subString(l_p+1,l_p2-1)
       LET l_field_name = l_name.subString(l_p2+1,l_name.getLength())
 
       CASE cl_db_get_database_type()
         WHEN "MSV"
            LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
         OTHERWISE
            LET l_dbname = 'ds'
       END CASE
       CALL cl_get_column_info(l_dbname,l_table_name,l_field_name)
           RETURNING l_datatype,l_length
 
       IF cl_null(l_datatype) THEN
          LET g_err_str = l_table_name CLIPPED,".",l_field_name CLIPPED
          LET g_errno = '-2863'
          RETURN 0
       END IF
       IF l_datatype  = 'date' THEN
          LET l_length = 10
       END IF
 
    END WHILE
    RETURN 1
 
END FUNCTION
 
{
FUNCTION p_crdata_set_seq(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE k         LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_gcz05   LIKE gcz_file.gcz05
DEFINE l_gcz13   LIKE gcz_file.gcz13
        FORM        LINE FIRST + 1,
        MESSAGE     LINE LAST,
        PROMPT      LINE LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
 
             OPEN WINDOW p_zaa_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
                  ATTRIBUTE (STYLE = g_win_style)
             CALL cl_ui_locale("p_zaa_1")
 
             LET g_n = 1                                #FUN-650175
 
             INPUT g_n WITHOUT DEFAULTS FROM a
                  ON ACTION cancel
                     LET g_n = 0
                     EXIT INPUT
 
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE INPUT
 
              END INPUT
              BEGIN WORK
              CASE g_n
                   WHEN 1   #欄位順序調換
                      IF p_cmd = "a" THEN
                          SELECT MAX(gcz13)+1 INTO g_gcz_t.gcz13 FROM gcz_file 
                           WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
                             AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04  
                      END IF
                      FOR k = 1 to g_gcz.getLength()
                          IF (k <> l_ac) AND g_gcz[k].gcz06=g_gcz[l_ac].gcz06 
                            AND g_gcz[k].gcz13 = g_gcz[l_ac].gcz13 
                          THEN
                            LET g_gcz[k].gcz13 = g_gcz_t.gcz13
                            UPDATE gcz_file SET gcz13 = g_gcz_t.gcz13
                             WHERE gcz01 = g_gcy.gcy01 AND gcz06 = g_gcz[k].gcz06
                               AND gcz02 = g_gcy.gcy02 AND gcz03 = g_gcy.gcy03 
                               AND gcz04 = g_gcy.gcy04 AND gcz05 = g_gcz[k].gcz05
                            EXIT FOR
                          END IF
                      END FOR
 
                    IF p_cmd = "u" THEN
                      UPDATE gcz_file SET gcz13 = g_gcz[l_ac].gcz13
                       WHERE gcz01 = g_gcy.gcy01 AND gcz05 = g_gcz_t.gcz05
                         AND gcz02 = g_gcy.gcy02 AND gcz03 = g_gcy.gcy03
                         AND gcz06 = g_gcz_t.gcz06 AND gcz04 = g_gcy.gcy04
                      LET g_gcz_t.gcz13 = g_gcz[l_ac].gcz13
                    END IF
 
                   WHEN 2         #以下欄位順序自動往後遞增一位
                      #FUN-580131
                      FOR k = 1 to g_gcz.getLength()
                          IF (k <> l_ac) AND g_gcz[k].gcz06=g_gcz[l_ac].gcz06
                             AND g_gcz[k].gcz13 >= g_gcz[l_ac].gcz13
                             AND ((g_gcz[k].gcz13 <= g_gcz_t.gcz13) OR
                                  (g_gcz_t.gcz13 <= g_gcz[l_ac].gcz13))
                          THEN
                              LET g_gcz[k].gcz13 = g_gcz[k].gcz13 + 1
                              UPDATE gcz_file SET gcz13 = g_gcz[k].gcz13
                               WHERE gcz01 = g_gcy.gcy01 AND gcz06 = g_gcz[k].gcz06
                                 AND gcz02 = g_gcy.gcy02 AND gcz03 = g_gcy.gcy03
                                 AND gcz04 = g_gcy.gcy04 AND gcz05 = g_gcz[k].gcz05
                          END IF
                      END FOR
                      IF p_cmd = "a" THEN
                         FOR k = 1 to g_gcz.getLength()
                             IF (k <> l_ac) AND g_gcz[k].gcz06=g_gcz[l_ac].gcz06
                                AND g_gcz[k].gcz13 >= g_gcz[l_ac].gcz13
                             THEN
                                 LET g_gcz[k].gcz13 = g_gcz[k].gcz13 + 1
                                 UPDATE gcz_file SET gcz13 = g_gcz[k].gcz13
                                  WHERE gcz01=g_gcy.gcy01 AND gcz06=g_gcz[k].gcz06
                                    AND gcz02=g_gcy.gcy02 AND gcz03=g_gcy.gcy03      
                                    AND gcz04=g_gcy.gcy04 AND gcz05=g_gcz[k].gcz05
                             END IF
                         END FOR
                      END IF
                      IF p_cmd = "u" THEN
                         UPDATE gcz_file SET gcz13 = g_gcz[l_ac].gcz13
                          WHERE gcz01 = g_gcy.gcy01   AND gcz05 = g_gcz_t.gcz05
                            AND gcz02 = g_gcy.gcy02   AND gcz03 = g_gcy.gcy03
                            AND gcz06 = g_gcz_t.gcz06 AND gcz04 = g_gcy.gcy04
                      END IF
                      LET g_gcz_t.gcz13 = g_gcz[l_ac].gcz13
 
              END CASE
              CLOSE WINDOW p_zaa_1
              RETURN g_n
END FUNCTION
}
 
FUNCTION p_crdata_set_seq_afresh()
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE l_gcz05           LIKE gcz_file.gcz05
   DEFINE l_gcz06           LIKE gcz_file.gcz03
   DEFINE l_sql             LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(900)
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gcy.gcy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
    LET g_sql = "SELECT gcz05 FROM gcz_file ",
                  " WHERE gcz01 = '",g_gcy.gcy01 CLIPPED,"' ",
                  "   AND gcz02 = '",g_gcy.gcy02 CLIPPED,"' ",
                  "   AND gcz03 = '",g_gcy.gcy03 CLIPPED,"' ", 
                  "   AND gcz04 = '",g_gcy.gcy04 CLIPPED,"' ",
                  "   AND gcz06 = ? ",
                  " ORDER BY gcz05"
   PREPARE p_gcz_prepare2 FROM g_sql           #預備一下
   DECLARE gcz_curs2 CURSOR FOR p_gcz_prepare2
 
   LET l_sql = "SELECT UNIQUE gcz06 FROM gcz_file ",
                " WHERE gcz01 = '",g_gcy.gcy01 CLIPPED,"' ",
                "   AND gcz02 = '",g_gcy.gcy02 CLIPPED,"' ",
                "   AND gcz03 = '",g_gcy.gcy03 CLIPPED,"' ",
                "   AND gcz04 = '",g_gcy.gcy04 CLIPPED,"' "
   PREPARE p_gcz_prepare4 FROM l_sql           #預備一下
   DECLARE gcz_curs4 CURSOR FOR p_gcz_prepare4
   FOREACH gcz_curs4 INTO l_gcz06       #單身 ARRAY 填充
      LET i = 0
      FOREACH gcz_curs2 USING l_gcz06 INTO l_gcz05
          LET i = i + 1
          UPDATE gcz_file SET gcz05= i
           WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
             AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04 
             AND gcz05 = l_gcz05 AND gcz06 = l_gcz06
      END FOREACH
   END FOREACH
   CALL p_crdata_sql_b_fill()     # SQL 單身
END FUNCTION
 
FUNCTION p_crdata_set_zx02(p_zx01)
DEFINE p_zx01 LIKE zx_file.zx01
 
    IF p_zx01 = 'default' THEN
       LET g_zx02 = "default"
    ELSE
       LET g_zx02 = ""
       SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=p_zx01 
    END IF
    DISPLAY g_zx02 TO FORMONLY.zx02
END FUNCTION
 
FUNCTION p_crdata_set_zw02(p_zw01)
DEFINE p_zw01 LIKE zw_file.zw01
    IF p_zw01 = 'default' THEN
       LET g_zw02 = "default"
    ELSE
       LET g_zw02 = ""
       SELECT zw02 INTO g_zw02 FROM zw_file WHERE zw01=p_zw01 AND zwacti='Y'
    END IF
    DISPLAY g_zw02 TO FORMONLY.zw02
END FUNCTION
 
FUNCTION p_crdata_set_bgjob()
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_gcy     DYNAMIC ARRAY OF RECORD  
           gcy02 LIKE gcy_file.gcy02,
           gcy03 LIKE gcy_file.gcy03,
           gcy04 LIKE gcy_file.gcy04
                 END RECORD
 
    IF NOT cl_null(g_gcy.gcy02) AND NOT cl_null(g_gcy.gcy03) AND 
       NOT cl_null(g_gcy.gcy04) 
    THEN
       SELECT COUNT(*) INTO l_cnt FROM gda_file 
        WHERE gda01 = g_gcy.gcy01 AND gda02 = g_gcy.gcy02 
          AND gda03 = g_gcy.gcy03 AND gda04 = g_gcy.gcy04
    ELSE
       SELECT COUNT(*) INTO l_cnt FROM gda_file 
        WHERE gda01 = g_gcy.gcy01
    END IF
 
    IF l_cnt = 0 THEN
       IF cl_null(g_gcy.gcy02) AND cl_null(g_gcy.gcy03) AND 
          cl_null(g_gcy.gcy04) 
       THEN
          LET g_gcy.gcy02= 'N'
          LET g_gcy.gcy03= 'default'
          LET g_gcy.gcy04= 'default'
       END IF
      
       CALL p_crdata_a()
    ELSE
       LET g_sql = "SELECT gcy02,gcy03,gcy04 FROM gcy_file ",
                     " WHERE gcy01 = '",g_gcy.gcy01 CLIPPED,"' "
       PREPARE p_gcy_prepare FROM g_sql           #預備一下
       DECLARE gcy_curs CURSOR FOR p_gcy_prepare
       LET l_cnt = 1 
       FOREACH gcy_curs INTO l_gcy[l_cnt].gcy02,l_gcy[l_cnt].gcy03,l_gcy[l_cnt].gcy04
            LET l_cnt = l_cnt + 1
       END FOREACH
       LET l_cnt = l_cnt - 1
   
       FOR l_i = 1 TO l_cnt
           LET g_gcy.gcy02 = l_gcy[l_i].gcy02
           LET g_gcy.gcy03 = l_gcy[l_i].gcy03
           LET g_gcy.gcy04 = l_gcy[l_i].gcy04
           CALL p_crdata_sql_i()        #UPDATE SQL指令
           CALL p_crdata_sql_b_fill()   #Process 欄位設定
       END FOR
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #MOD-B70108 add
    EXIT PROGRAM
END FUNCTION
 
FUNCTION p_crdata_seq(p_move)   #單身序號移動
   DEFINE   p_move   LIKE type_file.num10     #往上、往下移動多少列
   DEFINE   l_i      LIKE type_file.num10
    
   
   BEGIN WORK
 
   LET l_i = g_gcz[l_ac].gcz05 + p_move    #new序號
   
   UPDATE gcz_file SET gcz05= -1           #已有資料，暫時先改為序號為-1
    WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
      AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04 
      AND gcz05 = l_i
   IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gcz_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
   END IF
 
   UPDATE gcz_file SET gcz05 = l_i         #移動
    WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
      AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04 
      AND gcz05 = g_gcz[l_ac].gcz05
   IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gcz_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
   END IF
 
   UPDATE gcz_file SET gcz05 = g_gcz[l_ac].gcz05        #調換序號資料
    WHERE gcz01 = g_gcy.gcy01 AND gcz02 = g_gcy.gcy02 
      AND gcz03 = g_gcy.gcy03 AND gcz04 = g_gcy.gcy04 
      AND gcz05 = -1
   IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gcz_file",g_gcy.gcy01,g_gcy.gcy02,SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
   END IF  
   
   COMMIT WORK
   CALL p_crdata_sql_b_fill()        # SQL     單身
  
   IF p_move = 1 THEN
      LET l_i = l_ac + g_lang_cnt
   ELSE
      LET l_i = l_ac - g_lang_cnt
   END IF
  
   CALL fgl_set_arr_curr(l_i)       #指定游標位置
END FUNCTION
