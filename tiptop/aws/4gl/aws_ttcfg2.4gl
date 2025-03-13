# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aws_ttcfg2
# Descriptions...: ERP 服務與他系統間欄位對應關係維護作業
# Date & Author..: 07/02/09 Echo  
# Modify.........: FUN-840004                
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO:FUN-920056 10/04/07 By Jay 更新gaq03、wss05欄位,複製功能修改,construct功能修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wsr                 RECORD LIKE wsr_file.*,  #單頭
         g_wsr_t               RECORD LIKE wsr_file.*   #單頭(備份)
DEFINE   g_wss03               LIKE wss_file.wss03      #他系統別欄位
DEFINE   g_wss03_t             LIKE wss_file.wss03
DEFINE   g_wst03               LIKE wss_file.wss03      #他系統別欄位
DEFINE   g_wst03_t             LIKE wss_file.wss03
DEFINE   g_wss                 DYNAMIC ARRAY of RECORD  #預設值及欄位對應關係單身      
            wss04               LIKE wss_file.wss04,
            gaq03               LIKE gaq_file.gaq03, 
            wss05               LIKE wss_file.wss05,
            wss06               LIKE wss_file.wss06
                               END RECORD, 
         g_wss_t               RECORD                   # 變數舊值
            wss04               LIKE wss_file.wss04,
            gaq03               LIKE gaq_file.gaq03, 
            wss05               LIKE wss_file.wss05,
            wss06               LIKE wss_file.wss06
                               END RECORD
DEFINE   g_wss_lock            RECORD LIKE wss_file.*   # FOR LOCK CURSOR TOUCH
DEFINE   g_wst_lock            RECORD LIKE wst_file.*   # FOR LOCK CURSOR TOUCH
DEFINE   g_wss_o               DYNAMIC ARRAY of RECORD  #他系統預設值及欄位對應關係單身      
            wss04               LIKE wss_file.wss04,
            gaq03               LIKE gaq_file.gaq03, 
            wss05               LIKE wss_file.wss05,
            wss06               LIKE wss_file.wss06
                               END RECORD, 
         g_wss_o_t             RECORD                   # 變數舊值
            wss04               LIKE wss_file.wss04,
            gaq03               LIKE gaq_file.gaq03, 
            wss05               LIKE wss_file.wss05,
            wss06               LIKE wss_file.wss06
                               END RECORD
DEFINE   g_wst                DYNAMIC ARRAY of RECORD  #欄位轉換單身      
            wst04               LIKE wst_file.wst04,
            gaq03               LIKE gaq_file.gaq03, 
            wst05               LIKE wst_file.wst05,
            wst06               LIKE wst_file.wst06
                               END RECORD, 
         g_wst_t              RECORD                   # 變數舊值
            wst04               LIKE wst_file.wst04,
            gaq03               LIKE gaq_file.gaq03, 
            wst05               LIKE wst_file.wst05,
            wst06               LIKE wst_file.wst06
                               END RECORD
 
DEFINE   g_cnt                 LIKE type_file.num10,   
         g_cnt2                LIKE type_file.num10,   
         g_cnt3                LIKE type_file.num10,   
         g_cnt4                LIKE type_file.num10,   
         g_wc                  STRING,
         g_wc2                 STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,              # 單身筆數
         l_ac                  LIKE type_file.num5               # 目前處理的ARRAY CNT
DEFINE   g_msg                 STRING
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   mi_row_count          LIKE type_file.num10,
         mi_curs_index         LIKE type_file.num10
DEFINE   mi_jump               LIKE type_file.num10,
         mi_no_ask             LIKE type_file.num5
DEFINE   g_n                   LIKE type_file.num10
DEFINE   g_b_cmd               LIKE type_file.chr1               
DEFINE   g_argv1               LIKE type_file.chr1
DEFINE   g_edition             LIKE type_file.chr1
 
MAIN
DEFINE   p_row,p_col           LIKE type_file.num5
DEFINE   l_time                LIKE type_file.chr8  # 計算被使用時間
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
  # CALL cl_used(g_prog,l_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818        #FUN-B80064   MARK
  # RETURNING l_time                                                                                        #FUN-B80064   MARK   
    CALL cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818        #FUN-B80064   ADD
    RETURNING g_time                                                                                        #FUN-B80064   ADD

   LET g_argv1 = ARG_VAL(1)
   IF g_argv1 = "C" THEN
      LET g_edition = 'C'
      LET g_prog = 'aws_clicfg'
   ELSE
      LET g_prog = 'aws_ttcfg2'
      LET g_edition = 'S'
   END IF
 
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW aws_ttcfg2_w AT p_row,p_col WITH FORM "aws/42f/aws_ttcfg2"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF g_argv1 = "C" THEN
      CALL cl_set_comp_visible("wsr04",FALSE)
   END IF
 
   LET g_forupd_sql = "SELECT * from wsr_file WHERE wsr01 = ? ",
                      "   AND wsr02 = '",g_edition ,"'",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg2_cl CURSOR FROM g_forupd_sql
   
   CALL aws_ttcfg2_menu() 
 
   CLOSE WINDOW aws_ttcfg2_w                       # 結束畫面
  # CALL cl_used(g_prog,l_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818        #FUN-B80064   MARK
  # RETURNING l_time                                                                                        #FUN-B80064   MARK
    CALL cl_used(g_prog,g_time,2)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818        #FUN-B80064   ADD
    RETURNING g_time                                                                                        #FUN-B80064   ADD
END MAIN
 
FUNCTION aws_ttcfg2_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_wss.clear()
 
   CONSTRUCT g_wc ON wsr01,wsr03,wsr04,wsruser,wsrgrup,wsrmodu,wsrdate,wsracti
        FROM wsr01,wsr03,wsr04,wsruser,wsrgrup,wsrmodu,wsrdate,wsracti
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('wsruser', 'wsrgrup') #FUN-980030
    IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
  
   CONSTRUCT g_wc2 ON wss04,wss05,wss06
        FROM s_wss[1].wss04,s_wss[1].wss05,s_wss[1].wss06
 
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
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND wsruser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND wsrgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   IF g_wc2=' 1=1 ' OR cl_null(g_wc2) THEN
      LET g_sql="SELECT wsr01,wsr02 FROM wsr_file ",
                " WHERE wsr02 = '",g_edition,"'",
                "   AND ",g_wc CLIPPED," ORDER BY wsr01,wsr02"
   ELSE
      LET g_sql="SELECT wsr01,wsr02 FROM wsr_file,wss_file ",
                " WHERE wsr01 = wss01 AND wsr02 = wss02 ",
                "   AND wsr02 = '",g_edition,"' ",
                "   AND wss03 = '*' ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY wsr01,wsr02"
    END IF
    PREPARE aws_ttcfg2_prepare FROM g_sql         # RUNTIME 編譯
    DECLARE aws_ttcfg2_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aws_ttcfg2_prepare
 
    IF g_wc2=' 1=1' OR cl_null(g_wc2) THEN
       LET g_sql= "SELECT COUNT(*) FROM wsr_file ",
                  "WHERE wsr02 = '",g_edition,"' AND ",g_wc CLIPPED
    ELSE
       LET g_sql= "SELECT COUNT(DISTINCT wsr01) FROM wsr_file,wss_file",
                " WHERE wsr01 = wss01 AND wsr02 = wss02 ",
                "   AND wsr02 = '", g_edition, "' AND wss03='*'",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE aws_ttcfg2_precount FROM g_sql
    DECLARE aws_ttcfg2_count CURSOR FOR aws_ttcfg2_precount
 
END FUNCTION
 
FUNCTION aws_ttcfg2_menu()
 
   WHILE TRUE
      CALL aws_ttcfg2_bp("G")
      CASE g_action_choice
         WHEN "map_column"                      #欄位對應關係
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_column()
            END IF
 
         WHEN "change_value"                    #轉換欄位值
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value()
            END IF
 
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL aws_ttcfg2_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_u()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION aws_ttcfg2_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_wss.clear()
   INITIALIZE g_wsr.*   LIKE wsr_file.*
   INITIALIZE g_wsr_t.* LIKE wsr_file.*
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_wsr.wsracti ='Y'                      #有效的資料
      LET g_wsr.wsruser = g_user                  
      LET g_wsr.wsrgrup = g_grup                  #使用者所屬群
      LET g_wsr.wsrdate = g_today
      LET g_wsr.wsr02 = g_edition                 #存取模式 S: Server, C:Client
      IF g_edition = "C" THEN
         LET g_wsr.wsr04 = " "
      END IF
      CALL aws_ttcfg2_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET INT_FLAG = 0
         INITIALIZE g_wsr.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_wss.clear()
         LET mi_row_count = 0
         LET mi_curs_index = 0
         EXIT WHILE
      END IF
      LET g_wsr.wsroriu = g_user      #No.FUN-980030 10/01/04
      LET g_wsr.wsrorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO wsr_file VALUES(g_wsr.*)
      IF SQLCA.sqlcode THEN
          CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)        #FUN-B80064   ADD
          ROLLBACK WORK
         # CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)       #FUN-B80064   MARK  
          CONTINUE WHILE
      END IF
 
      LET g_rec_b = 0
      LET g_b_cmd = 'a'
      CALL aws_ttcfg2_b()                          # 輸入單身
      LET mi_row_count = 0
      LET mi_curs_index = 0
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION aws_ttcfg2_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wsr.wsr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
   OPEN aws_ttcfg2_cl USING g_wsr.wsr01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg2_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg2_cl INTO g_wsr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wss01 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg2_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      LET g_wsr_t.* = g_wsr.*
 
      CALL aws_ttcfg2_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_wsr.* = g_wsr_t.*
         CALL aws_ttcfg2_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE wsr_file SET wsr.* = g_wsr.*
       WHERE wsr01 = g_wsr.wsr01 AND wsr02 = g_wsr.wsr02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wsr_t.wsr01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE aws_ttcfg2_cl
   COMMIT WORK
   CALL aws_ttcfg2_show()
END FUNCTION
 
FUNCTION aws_ttcfg2_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1      # a:輸入 u:更改
 
   DISPLAY BY NAME g_wsr.wsruser,g_wsr.wsrgrup, g_wsr.wsrmodu,
                   g_wsr.wsrdate,g_wsr.wsracti
 
   INPUT BY NAME g_wsr.wsr01,g_wsr.wsr03,g_wsr.wsr04,g_wsr.wsruser,
                 g_wsr.wsrgrup,g_wsr.wsrmodu,g_wsr.wsrdate,g_wsr.wsracti 
                 WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL aws_ttcfg2_set_entry(p_cmd)
            CALL aws_ttcfg2_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
      AFTER FIELD wsr01                         
         IF NOT cl_null(g_wsr.wsr01) THEN
            IF g_wsr.wsr01 != g_wsr_t.wsr01 OR cl_null(g_wsr_t.wsr01) THEN
               SELECT COUNT(UNIQUE wsr01) INTO g_cnt FROM wsr_file
                WHERE wsr01 = g_wsr.wsr01 AND wsr02 = g_wsr.wsr02
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wsr.wsr01,'-239',1)
                   LET g_wsr.wsr01 = g_wsr_t.wsr01
                   NEXT FIELD wsr01
               END IF
            END IF
         END IF
 
      AFTER INPUT
         LET g_wsr.wsruser = s_get_data_owner("wsr_file") #FUN-C10039
         LET g_wsr.wsrgrup = s_get_data_group("wsr_file") #FUN-C10039
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION
 
FUNCTION aws_ttcfg2_q()                            #Query 查詢
   LET mi_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,mi_row_count)
   MESSAGE ""
   CLEAR FROM
   INITIALIZE g_wsr.* TO NULL
   CALL g_wss.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL aws_ttcfg2_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN aws_ttcfg2_count
   FETCH aws_ttcfg2_count INTO mi_row_count
   DISPLAY mi_row_count TO FORMONLY.cnt
 
   OPEN aws_ttcfg2_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_wsr.* TO NULL
   ELSE
      CALL aws_ttcfg2_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1          #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     aws_ttcfg2_curs INTO g_wsr.wsr01,g_wsr.wsr02
      WHEN 'P' FETCH PREVIOUS aws_ttcfg2_curs INTO g_wsr.wsr01,g_wsr.wsr02
      WHEN 'F' FETCH FIRST    aws_ttcfg2_curs INTO g_wsr.wsr01,g_wsr.wsr02
      WHEN 'L' FETCH LAST     aws_ttcfg2_curs INTO g_wsr.wsr01,g_wsr.wsr02
      WHEN '/' 
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt mod
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE mi_jump aws_ttcfg2_curs INTO g_wsr.wsr01,g_wsr.wsr02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = mi_row_count
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, mi_row_count)
      SELECT * INTO g_wsr.* FROM wsr_file            # 重讀DB,因TEMP有不被更新特性
       WHERE wsr01=g_wsr.wsr01 AND wsr02=g_wsr.wsr02
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
      ELSE
         LET g_data_owner = g_wsr.wsruser      #FUN-4C0056 add
         LET g_data_group = g_wsr.wsrgrup      #FUN-4C0056 add
 
         CALL aws_ttcfg2_show()
      END IF
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_show()                         # 將資料顯示在畫面上
   LET g_wsr_t.* = g_wsr.*
 
   DISPLAY BY NAME
        g_wsr.wsr01, g_wsr.wsr03,g_wsr.wsr04,
        g_wsr.wsruser,g_wsr.wsrgrup,g_wsr.wsrmodu,g_wsr.wsrdate,
        g_wsr.wsracti
 
   CALL aws_ttcfg2_b_fill(g_wc2)                    # 單身
END FUNCTION
 
FUNCTION aws_ttcfg2_r()        # 取消整筆 (所有合乎單頭的資料)
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wsr.wsr01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN aws_ttcfg2_cl USING g_wsr.wsr01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg2_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg2_cl INTO g_wsr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsr01 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg2_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM wsr_file WHERE wsr01=g_wsr.wsr01 AND wsr02=g_wsr.wsr02 
         IF SQLCA.sqlcode THEN
            CALL cl_err('wsr_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
 
         DELETE FROM wss_file WHERE wss01=g_wsr.wsr01 AND wss02=g_wsr.wsr02 
         IF SQLCA.sqlcode THEN
            CALL cl_err('wss_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
 
         DELETE FROM wst_file WHERE wst01=g_wsr.wsr01 AND wst02=g_wsr.wsr02  
         IF SQLCA.sqlcode THEN
            CALL cl_err('wst_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
 
         CLEAR FORM
         CALL g_wss.clear()
         INITIALIZE g_wsr.* TO NULL
 
         OPEN aws_ttcfg2_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE aws_ttcfg2_curs
            CLOSE aws_ttcfg2_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
           FETCH aws_ttcfg2_count INTO mi_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(mi_row_count) OR mi_row_count = 0 ) THEN
            CLOSE aws_ttcfg2_curs
            CLOSE aws_ttcfg2_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY mi_row_count TO FORMONLY.cnt
 
         OPEN aws_ttcfg2_curs
         IF mi_curs_index = mi_row_count + 1 THEN
            LET mi_jump = mi_row_count
            CALL aws_ttcfg2_fetch('L')
         ELSE
            LET mi_jump = mi_curs_index
            LET mi_no_ask = TRUE
            CALL aws_ttcfg2_fetch('/')
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_b()                                       # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wsr.wsr01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT wss04,wss05,wss06 FROM wss_file ",
                     " WHERE wss01 = ? AND wss02 = ? AND wss04 = ? ",
                     "   AND wss03 = '*'  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg2_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wss WITHOUT DEFAULTS FROM s_wss.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_wss_t.* = g_wss[l_ac].*    #BACKUP
            OPEN aws_ttcfg2_bcl USING g_wsr.wsr01,g_wsr.wsr02,g_wss[l_ac].wss04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_ttcfg2_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_ttcfg2_bcl INTO g_wss[l_ac].wss04,g_wss[l_ac].wss05,g_wss[l_ac].wss06
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_wss[l_ac].gaq03 FROM gaq_file
                WHERE gaq01 = g_wss[l_ac].wss04 AND gaq02 = g_lang
               DISPLAY g_wss[l_ac].gaq03 TO gaq03
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wss[l_ac].* TO NULL       #900423
         LET g_wss_t.* = g_wss[l_ac].*          #新輸入資料
         NEXT FIELD wss04
 
      AFTER FIELD wss04
         IF NOT cl_null(g_wss[l_ac].wss04) THEN
          IF g_wss[l_ac].wss04 != g_wss_t.wss04 OR g_wss_t.wss04 IS NULL THEN
             SELECT COUNT(*) INTO g_cnt FROM wss_file 
              WHERE wss01=g_wsr.wsr01 AND wss02=g_wsr.wsr02
                AND wss03 = '*'
                AND wss04 = g_wss[l_ac].wss04 
             IF g_cnt > 0 THEN
                CALL cl_err(g_wss[l_ac].wss04,-239,1)
                LET g_wss[l_ac].wss04 = g_wss_t.wss04
                NEXT FIELD wss04
             END IF 
             SELECT gaq03 INTO g_wss[l_ac].gaq03 FROM gaq_file
              WHERE gaq01 = g_wss[l_ac].wss04 AND gaq02 = g_lang
             #----------FUN-920056 modify start----------------------
             SELECT COUNT(*) INTO g_cnt FROM gaq_file
              WHERE gaq01 = g_wss[l_ac].wss04 AND gaq02 = g_lang
             IF  g_cnt > 0 THEN
                DISPLAY g_wss[l_ac].gaq03 TO gaq03
             ELSE 
                LET g_wss[l_ac].gaq03 = ""
             END IF
             #----------FUN-920056 modify end------------------------
          END IF
         END IF
 
      ON ROW CHANGE
        IF INT_FLAG THEN
           #CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
            LET g_wss[l_ac].* = g_wss_t.*
            CLOSE aws_ttcfg2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_wss_t.wss04 != g_wss[l_ac].wss04  
         THEN
            SELECT COUNT(*) INTO g_cnt FROM wss_file 
             WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
               AND wss03 = '*'         AND wss04 = g_wss[l_ac].wss04 
            IF g_cnt > 0 THEN
                 CALL cl_err(g_wsr.wsr01,-239,1)
                 LET g_wss[l_ac].* = g_wss_t.*
                 NEXT FIELD wss04
            END IF 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wss[l_ac].wss04,-263,1)
            LET g_wss[l_ac].* = g_wss_t.*
         ELSE
            UPDATE wss_file
               SET wss04 = g_wss[l_ac].wss04,
                   wss05 = g_wss[l_ac].wss05,
                   wss06 = g_wss[l_ac].wss06
             WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
               AND wss03 = '*'         AND wss04 = g_wss_t.wss04
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wss[l_ac].wss04,SQLCA.sqlcode,0)
               LET g_wss[l_ac].* = g_wss_t.*
               NEXT FIELD wss04
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_wss_t.wss04)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM wss_file 
            WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02 
              AND wss03 = '*'         AND wss04 = g_wss[l_ac].wss04
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_wss[l_ac].wss04,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
          END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
           #CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO wss_file(wss01,wss02,wss03,wss04,wss05,wss06)
             VALUES (g_wsr.wsr01,g_wsr.wsr02,'*',g_wss[l_ac].wss04,g_wss[l_ac].wss05,g_wss[l_ac].wss06)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
           #CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wss[l_ac].* = g_wss_t.*
            END IF
            CLOSE aws_ttcfg2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg2_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
           #CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wss[l_ac].* = g_wss_t.*
            END IF
            CLOSE aws_ttcfg2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg2_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
 
   UPDATE wsr_file SET wsrmodu=g_user,wsrdate=g_today
     WHERE wsr01 = g_wsr.wsr01 AND wsr02 = g_wsr.wsr02
   LET g_wsr.wsrmodu = g_user
   LET g_wsr.wsrdate = g_today
   DISPLAY BY NAME g_wsr.wsrmodu,g_wsr.wsrdate
 
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
   END IF
 
   CLOSE aws_ttcfg2_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_b_fill(p_wc)              #BODY FILL UP
   DEFINE  
       # p_wc   LIKE type_file.chr1000
       p_wc         STRING       #NO.FUN-910082
       
     LET g_sql = "SELECT wss04,wss05,wss06",
                   "  FROM wss_file ",
                   " WHERE wss01 = '",g_wsr.wsr01 CLIPPED,"' ",
                   "   AND wss02 = '",g_wsr.wsr02 CLIPPED,"' ",
                   "   AND wss03 = '*' AND ",p_wc CLIPPED,
                   " ORDER BY wss04"
    PREPARE aws_ttcfg2_prepare3 FROM g_sql           #預備一下
    DECLARE wss_curs3 CURSOR FOR aws_ttcfg2_prepare3
 
    CALL g_wss.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH wss_curs3 INTO g_wss[g_cnt].wss04,g_wss[g_cnt].wss05,g_wss[g_cnt].wss06
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaq03 INTO g_wss[g_cnt].gaq03 FROM gaq_file
        WHERE gaq01 = g_wss[g_cnt].wss04 AND gaq02 = g_lang
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wss.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_ttcfg2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_wss TO s_wss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION map_column                       #欄位對應關係
         LET g_action_choice = "map_column"
         EXIT DISPLAY
 
      ON ACTION change_value                     #轉換欄位值
         LET g_action_choice = "change_value"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
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
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL aws_ttcfg2_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL aws_ttcfg2_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL aws_ttcfg2_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL aws_ttcfg2_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL aws_ttcfg2_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION aws_ttcfg2_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE wsr_file.wsr01,
            l_oldfe    LIKE wsr_file.wsr01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_wsr.wsr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe
     WITHOUT DEFAULTS FROM wsr01
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM wsr_file
          WHERE wsr01 = l_newfe AND wsr02 = g_wsr.wsr02
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD wsr01
         END IF
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wsr.wsr01 TO wsr01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM wsr_file WHERE wsr01 = g_wsr.wsr01 AND wsr02 = g_wsr.wsr02 
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET wsr01 = l_newfe ,                     # 資料鍵值 
          wsruser = g_user,   #資料所有者
          wsrgrup = g_grup,   #資料所有者所屬群
          wsrmodu = NULL,     #資料修改日期
          wsrdate = g_today,  #資料建立日期
          wsracti = 'Y'       #有效資料
                             
   INSERT INTO wsr_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('wss:',SQLCA.SQLCODE,0)
      RETURN
   END IF
 
   #預設值及對應關係單身複製
   DROP TABLE y
   SELECT * FROM wss_file         
       WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
       INTO TEMP y 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
       RETURN
   END IF
 
   UPDATE y SET wss01=l_newfe
 
   INSERT INTO wss_file SELECT * FROM y 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
       RETURN
   END IF
 
   #欄位轉換單身複製
   DROP TABLE y
   SELECT * FROM wst_file         
       WHERE wst01 = g_wsr.wsr01 AND wst02 = g_wsr.wsr02
       INTO TEMP y 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
       RETURN
   END IF
 
   UPDATE y SET wst01=l_newfe
 
   INSERT INTO wst_file SELECT * FROM y 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsr.wsr01,SQLCA.sqlcode,0)
       RETURN
   END IF
 
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe  = g_wsr.wsr01
   LET g_wsr.wsr01 = l_newfe
   LET g_b_cmd = 'a'
   CALL aws_ttcfg2_u()          #FUN-920056
   CALL aws_ttcfg2_b()
   LET g_wsr.wsr01 = l_oldfe
   SELECT * INTO g_wsr.* FROM wsr_file            # 重讀DB,因TEMP有不被更新特性
    WHERE wsr01 = g_wsr.wsr01 AND wsr02 = g_wsr.wsr02
   DISPLAY mi_row_count TO FORMONLY.cnt
   CALL aws_ttcfg2_show()
END FUNCTION
 
FUNCTION aws_ttcfg2_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
   IF (NOT g_before_input_done) OR INFIELD(wsr01) THEN
      CALL cl_set_comp_entry("wsr01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION aws_ttcfg2_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
 
    IF (NOT g_before_input_done) THEN                    #MOD-560162
       IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
           CALL cl_set_comp_entry("wsr01",FALSE)
       END IF
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_column()
   DEFINE   p_row,p_col    LIKE type_file.num5
   DEFINE   l_rec_b        LIKE type_file.num5
   DEFINE   l_row_count    LIKE type_file.num10,
            l_curs_index   LIKE type_file.num10
 
   
   IF cl_null(g_wsr.wsr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_rec_b  = g_rec_b
   LET l_row_count  = mi_row_count
   LET l_curs_index = mi_curs_index
 
   LET g_wss03_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW aws_ttcfg2_col_w AT p_row,p_col WITH FORM "aws/42f/aws_ttcfg2_col"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_locale("aws_ttcfg2_col")
 
   LET g_forupd_sql = "SELECT * from wss_file WHERE wss01='",g_wsr.wsr01 CLIPPED,"'",
                      "   AND wss02 = '",g_wsr.wsr02 CLIPPED ,"'",
                      "   AND wss03 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg2_col_cl CURSOR FROM g_forupd_sql
   
   LET g_wc = " 1=1"
   CALL aws_ttcfg2_col_q()                            #Query 查詢
 
   CALL aws_ttcfg2_col_menu() 
 
   CLOSE WINDOW aws_ttcfg2_col_w                       # 結束畫面
 
   LET g_rec_b  = l_rec_b
   LET mi_row_count  = l_row_count
   LET mi_curs_index = l_curs_index
END FUNCTION
 
FUNCTION aws_ttcfg2_col_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_wss_o.clear()
 
   IF cl_null(g_wc) THEN
      CONSTRUCT g_wc ON wss03,wss04,wss05,wss06
           FROM wss03,s_wsss[1].wss04,s_wsss[1].wss05,s_wsss[1].wss06
 
          ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
          
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
          
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
          
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
      END CONSTRUCT
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE wss03 FROM wss_file ",
              " WHERE wss01 ='",g_wsr.wsr01 CLIPPED,"'",
              "   AND wss02 ='",g_wsr.wsr02 CLIPPED,"'",
              "   AND wss03 != '*' AND ", g_wc CLIPPED,
              " ORDER BY wss03"
 
   PREPARE aws_ttcfg2_col_prepare FROM g_sql          # 預備一下
   DECLARE aws_ttcfg2_col_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR aws_ttcfg2_col_prepare
 
END FUNCTION
 
FUNCTION aws_ttcfg2_col_count()
 
   LET g_sql= "SELECT UNIQUE wss03 FROM wss_file ",
              " WHERE wss01 ='",g_wsr.wsr01 CLIPPED,"'",
              "   AND wss02 ='",g_wsr.wsr02 CLIPPED,"'",
              "   AND wss03 !='*' AND ", g_wc CLIPPED," ORDER BY wss03"
 
   PREPARE aws_ttcfg2_col_precount FROM g_sql
   DECLARE aws_ttcfg2_col_count CURSOR FOR aws_ttcfg2_col_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH aws_ttcfg2_col_count
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET g_rec_b = g_rec_b - 1
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
    LET mi_row_count=g_rec_b
END FUNCTION
 
FUNCTION aws_ttcfg2_col_menu()
 
   WHILE TRUE
      CALL aws_ttcfg2_col_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_col_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_col_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_col_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_col_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_col_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_col_u()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION aws_ttcfg2_col_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_wss_o.clear()
 
   INITIALIZE g_wss03 LIKE wss_file.wss03         # 預設值及將數值類變數清成零
   LET g_wss03_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL aws_ttcfg2_col_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_wss03=NULL
         DISPLAY g_wss03 TO wss03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_wss_o.clear()
      LET g_rec_b = 0
 
      CALL aws_ttcfg2_col_b()                          # 輸入單身
      LET g_wss03_t=g_wss03
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION aws_ttcfg2_col_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wss03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_wss03_t = g_wss03
 
   BEGIN WORK
   OPEN aws_ttcfg2_col_cl USING g_wss03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg2_col_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg2_col_cl INTO g_wss_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wss03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg2_col_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL aws_ttcfg2_col_i("u")
      IF INT_FLAG THEN
         LET g_wss03 = g_wss03_t
         DISPLAY g_wss03 TO wss03 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE wss_file SET wss03 = g_wss03
       WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02 
         AND wss03 = g_wss03_t 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wss03,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      OPEN aws_ttcfg2_col_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL aws_ttcfg2_col_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_col_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1          # a:輸入 u:更改
 
   DISPLAY g_wss03 TO wss03
   INPUT g_wss03 WITHOUT DEFAULTS FROM wss03
      
      AFTER FIELD wss03                         
         IF NOT cl_null(g_wss03) THEN
            IF g_wss03 != g_wss03_t OR cl_null(g_wss03_t) THEN
               SELECT COUNT(UNIQUE wss03) INTO g_cnt FROM wss_file
                WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
                  AND wss03 = g_wss03
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wss03,'-239',1)
                   LET g_wss03 = g_wss03_t
                   NEXT FIELD wss03
               END IF
            END IF
         END IF
 
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION aws_ttcfg2_col_q()                            #Query 查詢
   LET mi_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,mi_row_count)
   MESSAGE ""
   CLEAR FROM
   CALL g_wss_o.clear()
   DISPLAY '    ' TO FORMONLY.cnt3
   IF g_action_choice = "query" THEN
      LET g_wc = NULL
   END IF
   CALL aws_ttcfg2_col_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN aws_ttcfg2_col_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_wss03 TO NULL
   ELSE
      CALL aws_ttcfg2_col_count()
      DISPLAY mi_row_count TO FORMONLY.cnt3   #FUN-6B0097
      CALL aws_ttcfg2_col_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_col_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1              #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     aws_ttcfg2_col_b_curs INTO g_wss03
      WHEN 'P' FETCH PREVIOUS aws_ttcfg2_col_b_curs INTO g_wss03
      WHEN 'F' FETCH FIRST    aws_ttcfg2_col_b_curs INTO g_wss03
      WHEN 'L' FETCH LAST     aws_ttcfg2_col_b_curs INTO g_wss03
      WHEN '/' 
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt mod
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE mi_jump aws_ttcfg2_col_b_curs INTO g_wss03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wss03,SQLCA.sqlcode,0)
      LET g_wss03 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = mi_row_count
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, mi_row_count)
      CALL aws_ttcfg2_col_show()
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_col_show()                         # 將資料顯示在畫面上
   LET g_wss03_t = g_wss03
   DISPLAY g_wss03 TO wss03                    # 假單頭
   CALL aws_ttcfg2_col_b_fill(g_wc)                    # 單身
END FUNCTION
 
FUNCTION aws_ttcfg2_col_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_wss    RECORD LIKE wss_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wss03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN aws_ttcfg2_col_cl USING g_wss03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg2_col_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg2_col_cl INTO g_wss_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wss03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg2_col_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM wss_file WHERE wss01 = g_wsr.wsr01
            AND wss02 = g_wsr.wsr02 AND wss03 = g_wss03  
         IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
         ELSE
            CLEAR FORM
            CALL g_wss_o.clear()
            CALL aws_ttcfg2_col_count()
            DISPLAY mi_row_count TO FORMONLY.cnt3
            OPEN aws_ttcfg2_col_b_curs
            IF mi_curs_index = mi_row_count + 1 THEN
               LET mi_jump = mi_row_count
               CALL aws_ttcfg2_col_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL aws_ttcfg2_col_fetch('/')
            END IF
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_col_b()                             # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,       # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,       # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,       # 單身鎖住否
            p_cmd           LIKE type_file.chr1,       # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wss03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT wss04,wss05,wss06 FROM wss_file",
                     " WHERE wss01 = '",g_wsr.wsr01 CLIPPED,"'",
                     "   AND wss02 = '",g_wsr.wsr02 CLIPPED,"'",
                     "   AND wss03 = ? AND wss04 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg2_col_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wss_o WITHOUT DEFAULTS FROM s_wsss.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_wss_o_t.* = g_wss_o[l_ac].*    #BACKUP
            OPEN aws_ttcfg2_col_bcl USING g_wss03,g_wss_o[l_ac].wss04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_ttcfg2_col_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_ttcfg2_col_bcl INTO g_wss_o[l_ac].wss04,g_wss_o[l_ac].wss05,g_wss_o[l_ac].wss06
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wss03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_wss_o[l_ac].gaq03 FROM gaq_file
                WHERE gaq01 = g_wss_o[l_ac].wss04 AND gaq02 = g_lang
               DISPLAY g_wss_o[l_ac].gaq03 TO gaq03_s
            END IF
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wss_o[l_ac].* TO NULL       #900423
         LET g_wss_o_t.* = g_wss_o[l_ac].*          #新輸入資料
         NEXT FIELD wss04
 
      AFTER FIELD wss04
         IF NOT cl_null(g_wss_o[l_ac].wss04) THEN
          IF g_wss_o[l_ac].wss04 != g_wss_o_t.wss04 OR g_wss_o_t.wss04 IS NULL THEN
             IF NOT cl_null(g_wss_o[l_ac].wss04) THEN
                 SELECT COUNT(*) INTO g_cnt FROM wss_file 
                     where wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
                       AND wss03 = g_wss03 
                       AND wss04 = g_wss_o[l_ac].wss04
                 IF g_cnt > 0 THEN
                         CALL cl_err(g_wss_o[l_ac].wss04,-239,1)
                         LET g_wss_o[l_ac].wss04 = g_wss_o_t.wss04
                         NEXT FIELD wss04
                 END IF 
                 SELECT gaq03 INTO g_wss_o[l_ac].gaq03 FROM gaq_file
                  WHERE gaq01 = g_wss_o[l_ac].wss04 AND gaq02 = g_lang
                  #----------FUN-920056 modify start----------------------
                 SELECT COUNT(*) INTO g_cnt FROM gaq_file
                  WHERE gaq01 = g_wss_o[l_ac].wss04 AND gaq02 = g_lang
                 IF g_cnt > 0 THEN
                     DISPLAY g_wss_o[l_ac].gaq03 TO gaq03
                 ELSE 
                     LET g_wss_o[l_ac].gaq03 = ""
                 END IF
                 #----------FUN-920056 modify end------------------------
             END IF
           END IF
          END IF
 
      ON ROW CHANGE
        IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wss_o[l_ac].* = g_wss_o_t.*
            CLOSE aws_ttcfg2_col_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wss_o[l_ac].wss04,-263,1)
            LET g_wss_o[l_ac].* = g_wss_o_t.*
         ELSE
            UPDATE wss_file
               SET wss04 = g_wss_o[l_ac].wss04,     #FUN-920056  Update 原本已有Update wss05,未Update wss04資料
                   wss05 = g_wss_o[l_ac].wss05,
                   wss06 = g_wss_o[l_ac].wss06
             WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
               AND wss03 = g_wss03 AND wss04 = g_wss_o_t.wss04
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(g_wss_o[l_ac].wss04,SQLCA.sqlcode,0)
               LET g_wss_o[l_ac].* = g_wss_o_t.*
               NEXT FIELD wss04
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_wss_o_t.wss04)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM wss_file WHERE wss01 = g_wsr.wsr01
              AND wss02 = g_wsr.wsr02 
              AND wss03 = g_wss03 AND wss04 = g_wss_o[l_ac].wss04
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_wss_o[l_ac].wss04,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO cnt4
            COMMIT WORK
          END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO wss_file(wss01,wss02,wss03,wss04,wss05,wss06)
             VALUES (g_wsr.wsr01,g_wsr.wsr02,g_wss03,g_wss_o[l_ac].wss04,g_wss_o[l_ac].wss05,g_wss_o[l_ac].wss06)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wss03,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cnt4
         END IF
 
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wss_o[l_ac].* = g_wss_o_t.*
            END IF
            CLOSE aws_ttcfg2_col_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg2_col_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wss_o[l_ac].* = g_wss_o_t.*
            END IF
            CLOSE aws_ttcfg2_col_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg2_col_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CLOSE aws_ttcfg2_col_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_col_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   STRING
 
     LET g_sql = "SELECT wss04,wss05,wss06 FROM wss_file ",
                 " WHERE wss01 = '",g_wsr.wsr01 CLIPPED,"' ",
                 "   AND wss02 = '",g_wsr.wsr02 CLIPPED,"' ",
                 "   AND wss03 = '",g_wss03 CLIPPED,"' ",
                 "   AND ",p_wc CLIPPED,
                 " ORDER BY wss04"
 
    PREPARE aws_ttcfg2_col_prepare3 FROM g_sql           #預備一下
    DECLARE wss_curs_col CURSOR FOR aws_ttcfg2_col_prepare3
 
    CALL g_wss_o.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH wss_curs_col INTO g_wss_o[g_cnt].wss04,g_wss_o[g_cnt].wss05,g_wss_o[g_cnt].wss06
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaq03 INTO g_wss_o[g_cnt].gaq03 FROM gaq_file
        WHERE gaq01 = g_wss_o[g_cnt].wss04 AND gaq02 = g_lang
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wss_o.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt4
    LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_ttcfg2_col_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_wss_o TO s_wsss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
     #ON ACTION modify                           # Q.修改
     #   LET g_action_choice='modify'
     #   EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL aws_ttcfg2_col_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL aws_ttcfg2_col_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL aws_ttcfg2_col_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL aws_ttcfg2_col_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL aws_ttcfg2_col_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION aws_ttcfg2_col_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE wss_file.wss03,
            l_oldfe    LIKE wss_file.wss03
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_wss03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe
     WITHOUT DEFAULTS FROM wss03
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM wss_file
          WHERE wss01 = g_wsr.wsr01 AND wss02 = g_wsr.wsr02
            AND wss03 = l_newfe
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD wss03
         END IF
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wss03 TO wss03
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM wss_file WHERE wss01 = g_wsr.wsr01 
      AND wss02 = g_wsr.wsr02 AND wss03 = g_wss03  
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wss03,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET wss03 = l_newfe                      # 資料鍵值 
   INSERT INTO wss_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('wss:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_wss03
   LET g_wss03 = l_newfe
   CALL aws_ttcfg2_col_b()
   LET g_wss03 = l_oldfe
   CALL aws_ttcfg2_col_show()
END FUNCTION
 
FUNCTION aws_ttcfg2_value()
   DEFINE   p_row,p_col    LIKE type_file.num5
   DEFINE   l_rec_b        LIKE type_file.num5
   DEFINE   l_row_count    LIKE type_file.num10,
            l_curs_index   LIKE type_file.num10
 
   
   IF cl_null(g_wsr.wsr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_rec_b  = g_rec_b
   LET l_row_count  = mi_row_count
   LET l_curs_index = mi_curs_index
 
   LET g_wst03_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW aws_ttcfg2_value_w AT p_row,p_col WITH FORM "aws/42f/aws_ttcfg2_value"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_locale("aws_ttcfg2_value")
 
   LET g_forupd_sql = "SELECT * from wst_file WHERE wst01='",g_wsr.wsr01 CLIPPED,"'",
                      "   AND wst02 = '",g_wsr.wsr02 CLIPPED ,"'",
                      "   AND wst03 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg2_value_cl CURSOR FROM g_forupd_sql
   
   LET g_wc = " 1=1"
   CALL aws_ttcfg2_value_q()                            #Query 查詢
 
   CALL aws_ttcfg2_value_menu() 
 
   CLOSE WINDOW aws_ttcfg2_value_w                       # 結束畫面
 
   LET g_rec_b  = l_rec_b
   LET mi_row_count  = l_row_count
   LET mi_curs_index = l_curs_index
END FUNCTION
 
FUNCTION aws_ttcfg2_value_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_wst.clear()
 
   IF cl_null(g_wc) THEN
      CONSTRUCT g_wc ON wst03,wst04,wst05,wst06
           FROM wst03,s_wst[1].wst04,s_wst[1].wst05,s_wst[1].wst06     #FUN-920056  增加wst05欄位查詢
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END CONSTRUCT
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE wst03 FROM wst_file ",
              " WHERE wst01 ='",g_wsr.wsr01 CLIPPED,"'",
              "   AND wst02 ='",g_wsr.wsr02 CLIPPED,"'",
              "   AND ", g_wc CLIPPED," ORDER BY wst03"
 
   PREPARE aws_ttcfg2_value_prepare FROM g_sql          # 預備一下
   DECLARE aws_ttcfg2_value_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR aws_ttcfg2_value_prepare
 
END FUNCTION
 
FUNCTION aws_ttcfg2_value_count()
 
   LET g_sql= "SELECT UNIQUE wst03 FROM wst_file ",
              " WHERE wst01 ='",g_wsr.wsr01 CLIPPED,"'",
              "   AND wst02 ='",g_wsr.wsr02 CLIPPED,"'",
              "   AND ", g_wc CLIPPED," ORDER BY wst03"
 
   PREPARE aws_ttcfg2_value_precount FROM g_sql
   DECLARE aws_ttcfg2_value_count CURSOR FOR aws_ttcfg2_value_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH aws_ttcfg2_value_count
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET g_rec_b = g_rec_b - 1
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
    LET mi_row_count=g_rec_b
END FUNCTION
 
FUNCTION aws_ttcfg2_value_menu()
 
   WHILE TRUE
      CALL aws_ttcfg2_value_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg2_value_u()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION aws_ttcfg2_value_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_wst.clear()
 
   INITIALIZE g_wst03 LIKE wst_file.wst03         # 預設值及將數值類變數清成零
   LET g_wst03_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL aws_ttcfg2_value_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_wst03=NULL
         DISPLAY g_wst03 TO wst03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_wst.clear()
      LET g_rec_b = 0
 
      CALL aws_ttcfg2_value_b()                          # 輸入單身
      LET g_wst03_t=g_wst03
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION aws_ttcfg2_value_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wst03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_wst03_t = g_wst03
 
   BEGIN WORK
   OPEN aws_ttcfg2_value_cl USING g_wst03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg2_value_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg2_value_cl INTO g_wst_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wst03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg2_value_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL aws_ttcfg2_value_i("u")
      IF INT_FLAG THEN
         LET g_wst03 = g_wst03_t
         DISPLAY g_wst03 TO wst03 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE wst_file SET wst03 = g_wst03
       WHERE wst01 = g_wsr.wsr01 AND wst02 = g_wsr.wsr02 
         AND wst03 = g_wst03_t 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wst03,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      OPEN aws_ttcfg2_value_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL aws_ttcfg2_value_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_value_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1          # a:輸入 u:更改
 
   DISPLAY g_wst03 TO wst03
   INPUT g_wst03 WITHOUT DEFAULTS FROM wst03
      
      AFTER FIELD wst03                         
         IF NOT cl_null(g_wst03) THEN
            IF g_wst03 != g_wst03_t OR cl_null(g_wst03_t) THEN
               SELECT COUNT(UNIQUE wst03) INTO g_cnt FROM wst_file
                WHERE wst01 = g_wsr.wsr01 AND wst02 = g_wsr.wsr02
                  AND wst03 = g_wst03
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wst03,'-239',1)
                   LET g_wst03 = g_wst03_t
                   NEXT FIELD wst03
               END IF
            END IF
         END IF
 
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
  
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION
 
FUNCTION aws_ttcfg2_value_q()                            #Query 查詢
   LET mi_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,mi_row_count)
   MESSAGE ""
   CLEAR FROM
   CALL g_wst.clear()
   DISPLAY '    ' TO FORMONLY.cnt3
   IF g_action_choice = "query" THEN
      LET g_wc = NULL
   END IF
   CALL aws_ttcfg2_value_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN aws_ttcfg2_value_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_wst03 TO NULL
   ELSE
      CALL aws_ttcfg2_value_count()
      DISPLAY mi_row_count TO FORMONLY.cnt3   #FUN-6B0097
      CALL aws_ttcfg2_value_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_value_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1              #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     aws_ttcfg2_value_b_curs INTO g_wst03
      WHEN 'P' FETCH PREVIOUS aws_ttcfg2_value_b_curs INTO g_wst03
      WHEN 'F' FETCH FIRST    aws_ttcfg2_value_b_curs INTO g_wst03
      WHEN 'L' FETCH LAST     aws_ttcfg2_value_b_curs INTO g_wst03
      WHEN '/' 
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt mod
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE mi_jump aws_ttcfg2_value_b_curs INTO g_wst03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wst03,SQLCA.sqlcode,0)
      LET g_wst03 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = mi_row_count
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, mi_row_count)
      CALL aws_ttcfg2_value_show()
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg2_value_show()                         # 將資料顯示在畫面上
   LET g_wst03_t = g_wst03
   DISPLAY g_wst03 TO wst03                    # 假單頭
   CALL aws_ttcfg2_value_b_fill(g_wc)                    # 單身
END FUNCTION
 
FUNCTION aws_ttcfg2_value_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_wst    RECORD LIKE wst_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wst03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN aws_ttcfg2_value_cl USING g_wst03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg2_value_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg2_value_cl INTO g_wst_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wst03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg2_value_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM wst_file WHERE wst01 = g_wsr.wsr01
            AND wst02 = g_wsr.wsr02 AND wst03 = g_wst03  
         IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
         ELSE
            CLEAR FORM
            CALL g_wst.clear()
            CALL aws_ttcfg2_value_count()
            DISPLAY mi_row_count TO FORMONLY.cnt3
            OPEN aws_ttcfg2_value_b_curs
            IF mi_curs_index = mi_row_count + 1 THEN
               LET mi_jump = mi_row_count
               CALL aws_ttcfg2_value_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL aws_ttcfg2_value_fetch('/')
            END IF
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_value_b()                             # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,       # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,       # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,       # 單身鎖住否
            p_cmd           LIKE type_file.chr1,       # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wst03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT wst04,wst05,wst06 FROM wst_file",
                     " WHERE wst01 = '",g_wsr.wsr01 CLIPPED,"'",
                     "   AND wst02 = '",g_wsr.wsr02 CLIPPED,"'",
                     "   AND wst03 = ? AND wst04 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg2_value_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wst WITHOUT DEFAULTS FROM s_wst.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_wst_t.* = g_wst[l_ac].*    #BACKUP
            OPEN aws_ttcfg2_value_bcl USING g_wst03,g_wst[l_ac].wst04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_ttcfg2_value_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_ttcfg2_value_bcl INTO g_wst[l_ac].wst04,g_wst[l_ac].wst05,g_wst[l_ac].wst06
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wst03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_wst[l_ac].gaq03 FROM gaq_file
                WHERE gaq01 = g_wst[l_ac].wst04 AND gaq02 = g_lang
               DISPLAY g_wst[l_ac].gaq03 TO gaq03
            END IF
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wst[l_ac].* TO NULL       #900423
         LET g_wst_t.* = g_wst[l_ac].*          #新輸入資料
         NEXT FIELD wst04
 
      AFTER FIELD wst04
         IF NOT cl_null(g_wst[l_ac].wst04) THEN
          IF g_wst[l_ac].wst04 != g_wst_t.wst04 OR g_wst_t.wst04 IS NULL THEN
             IF NOT cl_null(g_wst[l_ac].wst04) THEN
                 SELECT COUNT(*) INTO g_cnt FROM wst_file 
                     where wst01 = g_wsr.wsr01 AND wst02 = g_wsr.wsr02
                       AND wst03 = g_wst03 
                       AND wst04 = g_wst[l_ac].wst04
                 IF g_cnt > 0 THEN
                         CALL cl_err(g_wst[l_ac].wst04,-239,1)
                         LET g_wst[l_ac].wst04 = g_wst_t.wst04
                         NEXT FIELD wst04
                 END IF 
                 SELECT gaq03 INTO g_wst[l_ac].gaq03 FROM gaq_file
                  WHERE gaq01 = g_wst[l_ac].wst04 AND gaq02 = g_lang
                  #----------FUN-920056 modify start----------------------
                 SELECT COUNT(*) INTO g_cnt FROM gaq_file
                  WHERE gaq01 = g_wst[l_ac].wst04 AND gaq02 = g_lang
                 IF  g_cnt > 0 THEN
                     DISPLAY g_wst[l_ac].gaq03 TO gaq03
                 ELSE 
                     LET g_wst[l_ac].gaq03 = ""
                 END IF
                 #----------FUN-920056 modify end------------------------
             END IF
           END IF
          END IF
 
      ON ROW CHANGE
        IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wst[l_ac].* = g_wst_t.*
            CLOSE aws_ttcfg2_value_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wst[l_ac].wst04,-263,1)
            LET g_wst[l_ac].* = g_wst_t.*
         ELSE
            UPDATE wst_file
               SET wst04 = g_wst[l_ac].wst04,
                   wst05 = g_wst[l_ac].wst05,
                   wst06 = g_wst[l_ac].wst06
             WHERE wst01 = g_wsr.wsr01 AND wst02 = g_wsr.wsr02
               AND wst03 = g_wst03 AND wst04 = g_wst_t.wst04
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(g_wst[l_ac].wst04,SQLCA.sqlcode,0)
               LET g_wst[l_ac].* = g_wst_t.*
               NEXT FIELD wst04
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_wst_t.wst04)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM wst_file WHERE wst01 = g_wsr.wsr01
              AND wst02 = g_wsr.wsr02 
              AND wst03 = g_wst03 AND wst04 = g_wst[l_ac].wst04
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_wst[l_ac].wst04,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO cnt4
            COMMIT WORK
          END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO wst_file(wst01,wst02,wst03,wst04,wst05,wst06)
             VALUES (g_wsr.wsr01,g_wsr.wsr02,g_wst03,g_wst[l_ac].wst04,g_wst[l_ac].wst05,g_wst[l_ac].wst06)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wst03,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cnt4
         END IF
 
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wst[l_ac].* = g_wst_t.*
            END IF
            CLOSE aws_ttcfg2_value_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg2_value_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wst[l_ac].* = g_wst_t.*
            END IF
            CLOSE aws_ttcfg2_value_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg2_value_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CLOSE aws_ttcfg2_value_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg2_value_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   STRING
 
     LET g_sql = "SELECT wst04,wst05,wst06 FROM wst_file ",
                 " WHERE wst01 = '",g_wsr.wsr01 CLIPPED,"' ",
                 "   AND wst02 = '",g_wsr.wsr02 CLIPPED,"' ",
                 "   AND wst03 = '",g_wst03 CLIPPED,"' ",
                 "   AND ",p_wc CLIPPED,
                 " ORDER BY wst04"
 
    PREPARE aws_ttcfg2_value_prepare3 FROM g_sql           #預備一下
    DECLARE wst_curs3 CURSOR FOR aws_ttcfg2_value_prepare3
 
    CALL g_wst.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH wst_curs3 INTO g_wst[g_cnt].wst04,g_wst[g_cnt].wst05,g_wst[g_cnt].wst06
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaq03 INTO g_wst[g_cnt].gaq03 FROM gaq_file
        WHERE gaq01 = g_wst[g_cnt].wst04 AND gaq02 = g_lang
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wst.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt4
    LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_ttcfg2_value_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_wst TO s_wst.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
     #ON ACTION modify                           # Q.修改
     #   LET g_action_choice='modify'
     #   EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL aws_ttcfg2_value_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL aws_ttcfg2_value_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL aws_ttcfg2_value_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL aws_ttcfg2_value_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL aws_ttcfg2_value_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION aws_ttcfg2_value_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE wst_file.wst03,
            l_oldfe    LIKE wst_file.wst03
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_wst03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe
     WITHOUT DEFAULTS FROM wst03
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM wst_file
          WHERE wst01 = g_wsr.wsr01 AND wst02 = g_wsr.wsr02
            AND wst03 = l_newfe
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD wst03
         END IF
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
  
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wst03 TO wst03
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM wst_file WHERE wst01 = g_wsr.wsr01 
      AND wst02 = g_wsr.wsr02 AND wst03 = g_wst03  
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wst03,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET wst03 = l_newfe                      # 資料鍵值 
   INSERT INTO wst_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('wst:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_wst03
   LET g_wst03 = l_newfe
   CALL aws_ttcfg2_value_b()
   #LET g_wst03 = l_oldfe        #FUN-C80046
   #CALL aws_ttcfg2_value_show() #FUN-C80046
END FUNCTION

