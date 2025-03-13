# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aws_ttcfg
# Descriptions...: ERP 服務與他系統間欄位對應關係維護作業
# Date & Author..: 07/02/09 Echo  
# Modify.........: FUN-720021                
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
#FUN-720021
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wsm                 RECORD LIKE wsm_file.*,  #單頭
         g_wsm_t               RECORD LIKE wsm_file.*,  #單頭(備份)
         g_gat03               LIKE gat_file.gat03,
         g_wsn                 DYNAMIC ARRAY of RECORD        
            wsn03               LIKE wsn_file.wsn03,
            gaq03               LIKE gaq_file.gaq03, 
            wsn04               LIKE wsn_file.wsn04
                               END RECORD, 
         g_wsn_t               RECORD                   # 變數舊值
            wsn03               LIKE wsn_file.wsn03,
            gaq03               LIKE gaq_file.gaq03, 
            wsn04               LIKE wsn_file.wsn04
                               END RECORD
DEFINE   g_wso03               LIKE wso_file.wso03
DEFINE   g_wso03_t             LIKE wso_file.wso03
DEFINE   g_wso_lock            RECORD LIKE wso_file.*,  # FOR LOCK CURSOR TOUCH
         g_wso                 DYNAMIC ARRAY of RECORD        
            wso04               LIKE wso_file.wso04,
            gaq03               LIKE gaq_file.gaq03, 
            wso05               LIKE wso_file.wso05
                               END RECORD, 
         g_wso_t               RECORD   # 變數舊值     
            wso04               LIKE wso_file.wso04,
            gaq03               LIKE gaq_file.gaq03, 
            wso05               LIKE wso_file.wso05
                               END RECORD
DEFINE   g_wsp03               LIKE wsp_file.wsp03
DEFINE   g_wsp03_t             LIKE wsp_file.wsp03
DEFINE   g_wsp_lock            RECORD LIKE wsp_file.*,  # FOR LOCK CURSOR TOUCH
         g_wsp                 DYNAMIC ARRAY of RECORD        
            wsp04               LIKE wsp_file.wsp04,
            gaq03               LIKE gaq_file.gaq03, 
            wsp05               LIKE wsp_file.wsp05
                               END RECORD, 
         g_wsp_t               RECORD   # 變數舊值     
            wsp04               LIKE wsp_file.wsp04,
            gaq03               LIKE gaq_file.gaq03, 
            wsp05               LIKE wsp_file.wsp05
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
 
  # CALL cl_used(g_prog,l_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818     #FUN-B80064   MARK
  # RETURNING l_time                                                                                     #FUN-B80064   MARK
    CALL cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818     #FUN-B80064   ADD
    RETURNING g_time                                                                                     #FUN-B80064   ADD

   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW aws_ttcfg_w AT p_row,p_col WITH FORM "aws/42f/aws_ttcfg"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from wsm_file  WHERE wsm01 = ? AND wsm02 = ? ",
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg_cl CURSOR FROM g_forupd_sql
   
   CALL aws_ttcfg_menu() 
 
   CLOSE WINDOW aws_ttcfg_w                       # 結束畫面
  # CALL cl_used(g_prog,l_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818      #FUN-B80064   MARK
  # RETURNING l_time                                                                                      #FUN-B80064   MARK
    CALL cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818      #FUN-B80064   ADD
    RETURNING g_time                                                                                      #FUN-B80064   ADD

END MAIN
 
FUNCTION aws_ttcfg_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_wsn.clear()
 
   CONSTRUCT g_wc ON wsm01,wsm02,wsmuser,wsmgrup,wsmmodu,wsmdate,wsmacti
        FROM wsm01,wsm02,wsmuser,wsmgrup,wsmmodu,wsmdate,wsmacti
 
      ON ACTION controlp 
         CASE
            WHEN INFIELD(wsm02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state= "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO wsm02
               NEXT FIELD wsm02
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
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('wsmuser', 'wsmgrup') #FUN-980030
    IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
  
   CONSTRUCT g_wc2 ON wsn03,wsn04
        FROM s_wsn[1].wsn03,s_wsn[1].wsn04
 
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
   #       LET g_wc = g_wc clipped," AND wsmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND wsmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   IF g_wc2=' 1=1 ' OR cl_null(g_wc2) THEN
      LET g_sql="SELECT UNIQUE wsm01,wsm02 FROM wsm_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY wsm01,wsm02"
   ELSE
      LET g_sql="SELECT UNIQUE wsm01,wsm02 FROM wsm_file,wsn_file ",
                " WHERE wsm01 = wsn01 AND wsm02 = wsn02 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY wsm01,wsm02"
    END IF
    PREPARE aws_ttcfg_prepare FROM g_sql         # RUNTIME 編譯
    DECLARE aws_ttcfg_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aws_ttcfg_prepare
 
    IF g_wc2=' 1=1' OR cl_null(g_wc2) THEN
       LET g_sql= "SELECT COUNT(*) FROM wsm_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql= "SELECT COUNT(DISTINCT wsm01) FROM wsm_file,wsn_file",
                " WHERE wsm01 = wsn01 AND wsm02 = wsn02 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE aws_ttcfg_precount FROM g_sql
    DECLARE aws_ttcfg_count CURSOR FOR aws_ttcfg_precount
 
END FUNCTION
 
FUNCTION aws_ttcfg_menu()
 
   WHILE TRUE
      CALL aws_ttcfg_bp("G")
      CASE g_action_choice
         WHEN "map_column"                      #欄位對應關係
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_column()
            END IF
         WHEN "ref_column"                      #參數欄位設定
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref()
            END IF
 
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL aws_ttcfg_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_u()
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
 
FUNCTION aws_ttcfg_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_wsn.clear()
   INITIALIZE g_wsm.*   LIKE wsm_file.*
   INITIALIZE g_wsm_t.* LIKE wsm_file.*
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_wsm.wsmacti ='Y'                      #有效的資料
      LET g_wsm.wsmuser = g_user                  
      LET g_wsm.wsmgrup = g_grup                  #使用者所屬群
      LET g_wsm.wsmdate = g_today
 
      CALL aws_ttcfg_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET INT_FLAG = 0
         INITIALIZE g_wsm.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_wsn.clear()
         LET mi_row_count = 0
         LET mi_curs_index = 0
         EXIT WHILE
      END IF
      LET g_wsm.wsmoriu = g_user      #No.FUN-980030 10/01/04
      LET g_wsm.wsmorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO wsm_file VALUES(g_wsm.*)
      IF SQLCA.sqlcode THEN
          CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)     #FUN-B80064   ADD
          ROLLBACK WORK
         # CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)    #FUN-B80064   MARK
          CONTINUE WHILE
      END IF
 
      LET g_rec_b = 0
      #自動產生單身項目
      CALL ttmap_i_col(g_wsm.wsm02)
 
      CALL aws_ttcfg_b_fill(" 1=1")                    # 單身
 
      LET g_b_cmd = 'a'
      CALL aws_ttcfg_b()                          # 輸入單身
      LET mi_row_count = 0
      LET mi_curs_index = 0
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION aws_ttcfg_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wsm.wsm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
   OPEN aws_ttcfg_cl USING g_wsm.wsm01,g_wsm.wsm02
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg_cl INTO g_wsm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsn01 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      LET g_wsm_t.* = g_wsm.*
 
      CALL aws_ttcfg_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_wsm.* = g_wsm_t.*
         CALL aws_ttcfg_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE wsm_file SET wsm.* = g_wsm.*
       WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wsm_t.wsm01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE aws_ttcfg_cl
   COMMIT WORK
   CALL aws_ttcfg_show()
END FUNCTION
 
FUNCTION aws_ttcfg_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1      # a:輸入 u:更改
 
   DISPLAY BY NAME g_wsm.wsmuser,g_wsm.wsmgrup, g_wsm.wsmmodu,
                   g_wsm.wsmdate,g_wsm.wsmacti
 
   INPUT BY NAME g_wsm.wsm01 ,g_wsm.wsm02,g_wsm.wsmuser,g_wsm.wsmgrup,
                 g_wsm.wsmmodu,g_wsm.wsmdate,g_wsm.wsmacti 
                 WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL aws_ttcfg_set_entry(p_cmd)
            CALL aws_ttcfg_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
      AFTER FIELD wsm01                         
         IF NOT cl_null(g_wsm.wsm01) THEN
            IF g_wsm.wsm01 != g_wsm_t.wsm01 OR cl_null(g_wsm_t.wsm01) THEN
               SELECT COUNT(UNIQUE wsm01) INTO g_cnt FROM wsm_file
                WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wsm.wsm01,'-239',1)
                   LET g_wsm.wsm01 = g_wsm_t.wsm01
                   NEXT FIELD wsm01
               END IF
            END IF
         END IF
 
      AFTER FIELD wsm02
         IF NOT cl_null(g_wsm.wsm02) THEN
            IF g_wsm.wsm02 != g_wsm_t.wsm02 OR cl_null(g_wsm_t.wsm02) THEN
               SELECT COUNT(UNIQUE wsm01) INTO g_cnt FROM wsm_file
                WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wsm.wsm02,'-239',1)
                   LET g_wsm.wsm02 = g_wsm_t.wsm02
                   NEXT FIELD wsm02
               END IF
               IF NOT ttmap_tab(g_wsm.wsm02) THEN
                  NEXT FIELD wsm02
               END IF
               SELECT gat03 INTO g_gat03 FROM gat_file 
                WHERE gat01 = g_wsm.wsm02 AND gat02 = g_lang
               DISPLAY g_gat03 TO gat03
            END IF
         END IF
 
      AFTER INPUT
         LET g_wsm.wsmuser = s_get_data_owner("wsm_file") #FUN-C10039
         LET g_wsm.wsmgrup = s_get_data_group("wsm_file") #FUN-C10039
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(wsm02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gat"
              LET g_qryparam.arg1 = g_lang
              LET g_qryparam.default1 = g_wsm.wsm02
              CALL cl_create_qry() RETURNING g_wsm.wsm02
              SELECT gat03 INTO g_gat03 FROM gat_file 
               WHERE gat01 = g_wsm.wsm02 AND gat02 = g_lang
              DISPLAY g_wsm.wsm02 TO wsm02
              DISPLAY g_gat03 TO gat03
              NEXT FIELD wsm02
         END CASE
 
       ON ACTION controlf                                  #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      #TQC-860022
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
  
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #END TQC-860022
 
   END INPUT
END FUNCTION
 
FUNCTION aws_ttcfg_q()                            #Query 查詢
   LET mi_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,mi_row_count)
   MESSAGE ""
   CLEAR FROM
   INITIALIZE g_wsm.* TO NULL
   CALL g_wsn.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL aws_ttcfg_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN aws_ttcfg_count
   FETCH aws_ttcfg_count INTO mi_row_count
   DISPLAY mi_row_count TO FORMONLY.cnt
 
   OPEN aws_ttcfg_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_wsm.* TO NULL
   ELSE
      CALL aws_ttcfg_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1          #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     aws_ttcfg_curs INTO g_wsm.wsm01,g_wsm.wsm02
      WHEN 'P' FETCH PREVIOUS aws_ttcfg_curs INTO g_wsm.wsm01,g_wsm.wsm02
      WHEN 'F' FETCH FIRST    aws_ttcfg_curs INTO g_wsm.wsm01,g_wsm.wsm02
      WHEN 'L' FETCH LAST     aws_ttcfg_curs INTO g_wsm.wsm01,g_wsm.wsm02
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
         FETCH ABSOLUTE mi_jump aws_ttcfg_curs INTO g_wsm.wsm01,g_wsm.wsm02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
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
      SELECT * INTO g_wsm.* FROM wsm_file            # 重讀DB,因TEMP有不被更新特性
       WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
      ELSE
         LET g_data_owner = g_wsm.wsmuser      #FUN-4C0056 add
         LET g_data_group = g_wsm.wsmgrup      #FUN-4C0056 add
 
         CALL aws_ttcfg_show()
      END IF
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg_show()                         # 將資料顯示在畫面上
   LET g_wsm_t.* = g_wsm.*
 
   DISPLAY BY NAME
        g_wsm.wsm01, g_wsm.wsm02,
        g_wsm.wsmuser,g_wsm.wsmgrup,g_wsm.wsmmodu,g_wsm.wsmdate,
        g_wsm.wsmacti
 
   SELECT gat03 INTO g_gat03 FROM gat_file 
    WHERE gat01 = g_wsm.wsm02 AND gat02 = g_lang
   DISPLAY g_gat03 TO gat03
 
   CALL aws_ttcfg_b_fill(g_wc2)                    # 單身
END FUNCTION
 
FUNCTION aws_ttcfg_r()        # 取消整筆 (所有合乎單頭的資料)
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wsm.wsm01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN aws_ttcfg_cl USING g_wsm.wsm01,g_wsm.wsm02
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg_cl INTO g_wsm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsm01 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM wsm_file WHERE wsm01=g_wsm.wsm01 AND wsm02=g_wsm.wsm02 
         IF SQLCA.sqlcode THEN
            CALL cl_err('wsm_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
 
         DELETE FROM wsn_file WHERE wsn01=g_wsm.wsm01 AND wsn02=g_wsm.wsm02 
         IF SQLCA.sqlcode THEN
            CALL cl_err('wsn_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
 
         DELETE FROM wso_file WHERE wso01=g_wsm.wsm01 AND wso02=g_wsm.wsm02  
         IF SQLCA.sqlcode THEN
            CALL cl_err('wso_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
 
         DELETE FROM wsp_file WHERE wsp01=g_wsm.wsm01 AND wsp02=g_wsm.wsm02  
         IF SQLCA.sqlcode THEN
            CALL cl_err('wsp_file DELETE:',SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
         CLEAR FORM
         CALL g_wsn.clear()
         INITIALIZE g_wsm.* TO NULL
 
         OPEN aws_ttcfg_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE aws_ttcfg_curs
            CLOSE aws_ttcfg_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH aws_ttcfg_count INTO mi_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(mi_row_count) OR mi_row_count = 0 ) THEN
            CLOSE aws_ttcfg_curs
            CLOSE aws_ttcfg_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY mi_row_count TO FORMONLY.cnt
 
         OPEN aws_ttcfg_curs
         IF mi_curs_index = mi_row_count + 1 THEN
            LET mi_jump = mi_row_count
            CALL aws_ttcfg_fetch('L')
         ELSE
            LET mi_jump = mi_curs_index
            LET mi_no_ask = TRUE
            CALL aws_ttcfg_fetch('/')
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_b()                                       # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wsm.wsm01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT wsn03,wsn04 FROM wsn_file ",
                     "  WHERE wsn01 = ? AND wsn02 = ? AND wsn03 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wsn WITHOUT DEFAULTS FROM s_wsn.*
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
            LET g_wsn_t.* = g_wsn[l_ac].*    #BACKUP
            OPEN aws_ttcfg_bcl USING g_wsm.wsm01,g_wsm.wsm02,g_wsn[l_ac].wsn03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_ttcfg_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_ttcfg_bcl INTO g_wsn[l_ac].wsn03,g_wsn[l_ac].wsn04
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_wsn[l_ac].gaq03 FROM gaq_file
                WHERE gaq01 = g_wsn[l_ac].wsn03 AND gaq02 = g_lang
               DISPLAY g_wsn[l_ac].gaq03 TO gaq03
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wsn[l_ac].* TO NULL       #900423
         LET g_wsn_t.* = g_wsn[l_ac].*          #新輸入資料
         NEXT FIELD wsn03
 
      AFTER FIELD wsn03
         IF NOT cl_null(g_wsn[l_ac].wsn03) THEN
          IF g_wsn[l_ac].wsn03 != g_wsn_t.wsn03 OR g_wsn_t.wsn03 IS NULL THEN
             SELECT COUNT(*) INTO g_cnt FROM wsn_file 
              WHERE wsn01=g_wsm.wsm01 AND wsn02=g_wsm.wsm02
                AND wsn03 = g_wsn[l_ac].wsn03 
             IF g_cnt > 0 THEN
                CALL cl_err(g_wsn[l_ac].wsn03,-239,1)
                LET g_wsn[l_ac].wsn03 = g_wsn_t.wsn03
                NEXT FIELD wsn03
             END IF 
             IF NOT ttmap_col(g_wsn[l_ac].wsn03,g_wsm.wsm02) THEN
                NEXT FIELD wsn03
             END IF
             SELECT gaq03 INTO g_wsn[l_ac].gaq03 FROM gaq_file
              WHERE gaq01 = g_wsn[l_ac].wsn03 AND gaq02 = g_lang
             DISPLAY g_wsn[l_ac].gaq03 TO gaq03
          END IF
         END IF
 
      ON ROW CHANGE
        IF INT_FLAG THEN
           #CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
            LET g_wsn[l_ac].* = g_wsn_t.*
            CLOSE aws_ttcfg_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_wsn_t.wsn03 != g_wsn[l_ac].wsn03  
         THEN
            SELECT COUNT(*) INTO g_cnt FROM wsn_file 
             WHERE wsn01=g_wsm.wsm01 AND wsn02 = g_wsm.wsm02
               AND wsn03 = g_wsn[l_ac].wsn03 
            IF g_cnt > 0 THEN
                 CALL cl_err(g_wsm.wsm01,-239,1)
                 LET g_wsn[l_ac].* = g_wsn_t.*
                 NEXT FIELD wsn03
            END IF 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wsn[l_ac].wsn03,-263,1)
            LET g_wsn[l_ac].* = g_wsn_t.*
         ELSE
            UPDATE wsn_file
               SET wsn03 = g_wsn[l_ac].wsn03,
                   wsn04 = g_wsn[l_ac].wsn04
             WHERE wsn01 = g_wsm.wsm01 AND wsn02 = g_wsm.wsm02
               AND wsn03 = g_wsn_t.wsn03
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wsn[l_ac].wsn03,SQLCA.sqlcode,0)
               LET g_wsn[l_ac].* = g_wsn_t.*
               NEXT FIELD zaa03
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_wsn_t.wsn03)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM wsn_file WHERE wsn01 = g_wsm.wsm01
              AND wsn02 = g_wsm.wsm02 AND wsn03 = g_wsn[l_ac].wsn03
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_wsn[l_ac].wsn03,SQLCA.sqlcode,0)
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
         INSERT INTO wsn_file(wsn01,wsn02,wsn03,wsn04)
             VALUES (g_wsm.wsm01,g_wsm.wsm02,g_wsn[l_ac].wsn03,g_wsn[l_ac].wsn04)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
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
               LET g_wsn[l_ac].* = g_wsn_t.*
            END IF
            CLOSE aws_ttcfg_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
           #CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wsn[l_ac].* = g_wsn_t.*
            END IF
            CLOSE aws_ttcfg_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg_bcl
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
 
   UPDATE wsm_file SET wsmmodu=g_user,wsmdate=g_today
     WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02
   LET g_wsm.wsmmodu = g_user
   LET g_wsm.wsmdate = g_today
   DISPLAY BY NAME g_wsm.wsmmodu,g_wsm.wsmdate
 
   CALL aws_ttcfg_delall() 
 
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
   END IF
 
   CLOSE aws_ttcfg_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_b_fill(p_wc)              #BODY FILL UP
   DEFINE  
       # p_wc   LIKE type_file.chr1000
       p_wc         STRING       #NO.FUN-910082
 
     LET g_sql = "SELECT wsn03,wsn04",
                   "  FROM wsn_file ",
                   " WHERE wsn01 = '",g_wsm.wsm01 CLIPPED,"' ",
                   "   AND wsn02 = '",g_wsm.wsm02 CLIPPED,"' ",
                   "   AND ",p_wc CLIPPED,
                   " ORDER BY wsn03"
    PREPARE aws_ttcfg_prepare3 FROM g_sql           #預備一下
    DECLARE wsn_curs3 CURSOR FOR aws_ttcfg_prepare3
 
    CALL g_wsn.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH wsn_curs3 INTO g_wsn[g_cnt].wsn03,g_wsn[g_cnt].wsn04
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaq03 INTO g_wsn[g_cnt].gaq03 FROM gaq_file
        WHERE gaq01 = g_wsn[g_cnt].wsn03 AND gaq02 = g_lang
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wsn.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_ttcfg_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_wsn TO s_wsn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION map_column                       #欄位對應關係
         LET g_action_choice = "map_column"
         EXIT DISPLAY
 
      ON ACTION ref_column                       #參考欄位設定
         LET g_action_choice = "ref_column"
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
         CALL aws_ttcfg_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL aws_ttcfg_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL aws_ttcfg_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL aws_ttcfg_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL aws_ttcfg_fetch('L')
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
 
FUNCTION aws_ttcfg_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE wsm_file.wsm01,
            l_oldfe    LIKE wsm_file.wsm01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_wsm.wsm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe
     WITHOUT DEFAULTS FROM wsm01
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM wsm_file
          WHERE wsm01 = l_newfe AND wsm02 = g_wsm.wsm02
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD wsm01
         END IF
 
      #TQC-860022
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
  
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #END TQC-860022
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wsm.wsm01 TO wsm01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM wsm_file WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02 
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET wsm01 = l_newfe ,                     # 資料鍵值 
          wsmuser = g_user,   #資料所有者
          wsmgrup = g_grup,   #資料所有者所屬群
          wsmmodu = NULL,     #資料修改日期
          wsmdate = g_today,  #資料建立日期
          wsmacti = 'Y'       #有效資料
                             
   INSERT INTO wsm_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('wsn:',SQLCA.SQLCODE,0)
      RETURN
   END IF
 
   DROP TABLE y
   SELECT * FROM wsn_file         #單身複製
       WHERE wsn01 = g_wsm.wsm01 AND wsn02 = g_wsm.wsm02
       INTO TEMP y 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
       RETURN
   END IF
 
   UPDATE y SET wsn01=l_newfe
 
   INSERT INTO wsn_file SELECT * FROM y 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
       RETURN
   END IF
 
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe  = g_wsm.wsm01
   LET g_wsm.wsm01 = l_newfe
   LET g_b_cmd = 'a'
   CALL aws_ttcfg_b()
   LET g_wsm.wsm01 = l_oldfe
   SELECT * INTO g_wsm.* FROM wsm_file            # 重讀DB,因TEMP有不被更新特性
    WHERE wsm01 = g_wsm.wsm01 AND wsm02 = g_wsm.wsm02
   DISPLAY mi_row_count TO FORMONLY.cnt
   CALL aws_ttcfg_show()
END FUNCTION
 
FUNCTION ttmap_tab(p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,
           l_cnt        LIKE type_file.num5

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    #CASE cl_db_get_database_type()
    #  WHEN "ORA"
    #      SELECT COUNT(*) INTO l_cnt FROM ALL_TABLES WHERE  #FUN-5A0136
    #      TABLE_NAME = UPPER(p_tabname) AND OWNER = 'DS'
    # 
    #  WHEN "IFX"
    #       SELECT COUNT(*) INTO l_cnt FROM ds:systables
    #        WHERE tabname = p_tabname
    #END CASE
    SELECT COUNT(*) INTO l_cnt FROM sch_file 
      WHERE sch01 = p_tabname
    #---FUN-A90024---end------- 
 
    IF l_cnt = 0 THEN
       CALL cl_err(p_tabname,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION ttmap_i_col(p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,
           l_colname	LIKE type_file.chr20,
           l_cnt	LIKE type_file.num5,
           l_name       STRING

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    #CASE cl_db_get_database_type()
    #WHEN "ORA"
    #   LET g_sql = "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS ",
    #       "WHERE TABLE_NAME = UPPER('",p_tabname CLIPPED,"') ",
    #       "  AND OWNER = 'DS'"
    #
    #WHEN "IFX"
    #   LET g_sql = "SELECT colname FROM ds:syscolumns col, ds:systables tab ",
    #               " WHERE tab.tabname = '", p_tabname CLIPPED ,"'",
    #               "   AND tab.tabid = col.tabid "
    #END CASE
    LET g_sql = "SELECT sch02 FROM sch_file ",
                "  WHERE sch01 = '",p_tabname CLIPPED,"'"
    #---FUN-A90024---end-------
      
    PREPARE wsn_col FROM g_sql           #預備一下
    DECLARE wsn_col_cs CURSOR FOR wsn_col
    FOREACH wsn_col_cs INTO l_colname
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_name = l_colname CLIPPED
       LET l_colname = l_name.toLowerCase()
       INSERT INTO wsn_file(wsn01,wsn02,wsn03,wsn04)
           VALUES (g_wsm.wsm01,g_wsm.wsm02,l_colname,'')
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_wsm.wsm01,SQLCA.sqlcode,0)
          RETURN
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION ttmap_col(p_colname,p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,
           p_colname	LIKE type_file.chr20,
           l_cnt	LIKE type_file.num5,
           l_name       STRING
 
    IF p_tabname IS NULL THEN
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構 
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM ALL_TAB_COLUMNS
      #   WHERE COLUMN_NAME = UPPER(p_colname) AND OWNER = 'DS'
      # 
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM ds:syscolumns WHERE colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch02 = p_colname
      #---FUN-A90024---end-------
    ELSE
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構 
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM ALL_TAB_COLUMNS
      #   WHERE TABLE_NAME = UPPER(p_tabname) AND COLUMN_NAME = UPPER(p_colname)
      #     AND OWNER = 'DS'
      #
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM ds:syscolumns col, ds:systables tab
      #   WHERE tab.tabname =  p_tabname AND tab.tabid = col.tabid
      #   AND colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch01 = p_tabname AND sch02 = p_colname
      #---FUN-A90024---end-------
    END IF
    IF l_cnt = 0 THEN
       LET l_name= p_tabname,"+",p_colname
       CALL cl_err(l_name,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
   IF (NOT g_before_input_done) OR INFIELD(wsm01) THEN
      CALL cl_set_comp_entry("wsm01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION aws_ttcfg_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
 
    IF (NOT g_before_input_done) THEN                    #MOD-560162
       IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
           CALL cl_set_comp_entry("wsm01",FALSE)
       END IF
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg_column()
   DEFINE   p_row,p_col    LIKE type_file.num5
   DEFINE   l_rec_b        LIKE type_file.num5
   DEFINE   l_row_count    LIKE type_file.num10,
            l_curs_index   LIKE type_file.num10
 
   
   IF cl_null(g_wsm.wsm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_rec_b  = g_rec_b
   LET l_row_count  = mi_row_count
   LET l_curs_index = mi_curs_index
 
   LET g_wso03_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW aws_ttcfg1_w AT p_row,p_col WITH FORM "aws/42f/aws_ttcfg1"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_locale("aws_ttcfg1")
 
   LET g_forupd_sql = "SELECT * from wso_file  WHERE wso01='",g_wsm.wsm01 CLIPPED,"'",
                      "   AND wso02 = '",g_wsm.wsm02 CLIPPED ,"'",
                      "   AND wso03 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg_col_cl CURSOR FROM g_forupd_sql
   
   LET g_wc = " 1=1"
   CALL aws_ttcfg_col_q()                            #Query 查詢
 
   CALL aws_ttcfg_col_menu() 
 
   CLOSE WINDOW aws_ttcfg1_w                       # 結束畫面
 
   LET g_rec_b  = l_rec_b
   LET mi_row_count  = l_row_count
   LET mi_curs_index = l_curs_index
END FUNCTION
 
FUNCTION aws_ttcfg_col_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_wso.clear()
 
   IF cl_null(g_wc) THEN
      CONSTRUCT g_wc ON wso03,wso04,wso05
           FROM wso03,s_wso[1].wso04,s_wso[1].wso05
 
         #TQC-860022
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
         #END TQC-860022
 
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE wso03 FROM wso_file ",
              " WHERE wso01 ='",g_wsm.wsm01 CLIPPED,"'",
              "   AND wso02 ='",g_wsm.wsm02 CLIPPED,"'",
              "   AND ", g_wc CLIPPED," ORDER BY wso03"
 
   PREPARE aws_ttcfg_col_prepare FROM g_sql          # 預備一下
   DECLARE aws_ttcfg_col_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR aws_ttcfg_col_prepare
 
END FUNCTION
 
FUNCTION aws_ttcfg_col_count()
 
   LET g_sql= "SELECT UNIQUE wso03 FROM wso_file ",
              " WHERE wso01 ='",g_wsm.wsm01 CLIPPED,"'",
              "   AND wso02 ='",g_wsm.wsm02 CLIPPED,"'",
              "   AND ", g_wc CLIPPED," ORDER BY wso03"
 
   PREPARE aws_ttcfg_col_precount FROM g_sql
   DECLARE aws_ttcfg_col_count CURSOR FOR aws_ttcfg_col_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH aws_ttcfg_col_count
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
 
FUNCTION aws_ttcfg_col_menu()
 
   WHILE TRUE
      CALL aws_ttcfg_col_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_col_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_col_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_col_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_col_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_col_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_col_u()
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
 
FUNCTION aws_ttcfg_col_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_wso.clear()
 
   INITIALIZE g_wso03 LIKE wso_file.wso03         # 預設值及將數值類變數清成零
   LET g_wso03_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL aws_ttcfg_col_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_wso03=NULL
         DISPLAY g_wso03 TO wso03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_wso.clear()
      LET g_rec_b = 0
 
      CALL aws_ttcfg_col_b()                          # 輸入單身
      LET g_wso03_t=g_wso03
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION aws_ttcfg_col_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wso03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_wso03_t = g_wso03
 
   BEGIN WORK
   OPEN aws_ttcfg_col_cl USING g_wso03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg_col_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg_col_cl INTO g_wso_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wso03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg_col_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL aws_ttcfg_col_i("u")
      IF INT_FLAG THEN
         LET g_wso03 = g_wso03_t
         DISPLAY g_wso03 TO wso03 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE wso_file SET wso03 = g_wso03
       WHERE wso01 = g_wsm.wsm01 AND wso02 = g_wsm.wsm02 
         AND wso03 = g_wso03_t 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wso03,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      OPEN aws_ttcfg_col_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL aws_ttcfg_col_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_col_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1          # a:輸入 u:更改
 
   DISPLAY g_wso03 TO wso03
   INPUT g_wso03 WITHOUT DEFAULTS FROM wso03
      
      AFTER FIELD wso03                         
         IF NOT cl_null(g_wso03) THEN
            IF g_wso03 != g_wso03_t OR cl_null(g_wso03_t) THEN
               SELECT COUNT(UNIQUE wso03) INTO g_cnt FROM wso_file
                WHERE wso01 = g_wsm.wsm01 AND wso02 = g_wsm.wsm02
                  AND wso03 = g_wso03
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wso03,'-239',1)
                   LET g_wso03 = g_wso03_t
                   NEXT FIELD wso03
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
 
      #TQC-860022
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #END TQC-860022
 
   END INPUT
END FUNCTION
 
FUNCTION aws_ttcfg_col_q()                            #Query 查詢
   LET mi_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,mi_row_count)
   MESSAGE ""
   CLEAR FROM
   CALL g_wso.clear()
   DISPLAY '    ' TO FORMONLY.cnt3
   IF g_action_choice = "query" THEN
      LET g_wc = NULL
   END IF
   CALL aws_ttcfg_col_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN aws_ttcfg_col_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_wso03 TO NULL
   ELSE
      CALL aws_ttcfg_col_count()
      DISPLAY mi_row_count TO FORMONLY.cnt3   #FUN-6B0097
      CALL aws_ttcfg_col_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg_col_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1              #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     aws_ttcfg_col_b_curs INTO g_wso03
      WHEN 'P' FETCH PREVIOUS aws_ttcfg_col_b_curs INTO g_wso03
      WHEN 'F' FETCH FIRST    aws_ttcfg_col_b_curs INTO g_wso03
      WHEN 'L' FETCH LAST     aws_ttcfg_col_b_curs INTO g_wso03
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
         FETCH ABSOLUTE mi_jump aws_ttcfg_col_b_curs INTO g_wso03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wso03,SQLCA.sqlcode,0)
      LET g_wso03 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = mi_row_count
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, mi_row_count)
      CALL aws_ttcfg_col_show()
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg_col_show()                         # 將資料顯示在畫面上
   LET g_wso03_t = g_wso03
   DISPLAY g_wso03 TO wso03                    # 假單頭
   CALL aws_ttcfg_col_b_fill(g_wc)                    # 單身
END FUNCTION
 
FUNCTION aws_ttcfg_col_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_wso    RECORD LIKE wso_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wso03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN aws_ttcfg_col_cl USING g_wso03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg_col_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg_col_cl INTO g_wso_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wso03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg_col_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM wso_file WHERE wso01 = g_wsm.wsm01
            AND wso02 = g_wsm.wsm02 AND wso03 = g_wso03  
         IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
         ELSE
            CLEAR FORM
            CALL g_wso.clear()
            CALL aws_ttcfg_col_count()
            DISPLAY mi_row_count TO FORMONLY.cnt3
            OPEN aws_ttcfg_col_b_curs
            IF mi_curs_index = mi_row_count + 1 THEN
               LET mi_jump = mi_row_count
               CALL aws_ttcfg_col_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL aws_ttcfg_col_fetch('/')
            END IF
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_col_b()                             # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,       # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,       # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,       # 單身鎖住否
            p_cmd           LIKE type_file.chr1,       # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wso03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT wso04,wso05 FROM wso_file",
                     "  WHERE wso01 = '",g_wsm.wsm01 CLIPPED,"'",
                     "   AND wso02 = '",g_wsm.wsm02 CLIPPED,"'",
                     "   AND wso03 = ? AND wso04 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg_col_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wso WITHOUT DEFAULTS FROM s_wso.*
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
            LET g_wso_t.* = g_wso[l_ac].*    #BACKUP
            OPEN aws_ttcfg_col_bcl USING g_wso03,g_wso[l_ac].wso04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_ttcfg_col_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_ttcfg_col_bcl INTO g_wso[l_ac].wso04,g_wso[l_ac].wso05
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wso03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_wso[l_ac].gaq03 FROM gaq_file
                WHERE gaq01 = g_wso[l_ac].wso04 AND gaq02 = g_lang
               DISPLAY g_wso[l_ac].gaq03 TO gaq03
            END IF
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wso[l_ac].* TO NULL       #900423
         LET g_wso_t.* = g_wso[l_ac].*          #新輸入資料
         NEXT FIELD wso04
 
      AFTER FIELD wso04
         IF NOT cl_null(g_wso[l_ac].wso04) THEN
          IF g_wso[l_ac].wso04 != g_wso_t.wso04 OR g_wso_t.wso04 IS NULL THEN
             IF NOT cl_null(g_wso[l_ac].wso04) THEN
                 SELECT COUNT(*) INTO g_cnt FROM wso_file 
                     where wso01 = g_wsm.wsm01 AND wso02 = g_wsm.wsm02
                       AND wso03 = g_wso03 
                       AND wso04 = g_wso[l_ac].wso04
                 IF g_cnt > 0 THEN
                         CALL cl_err(g_wso[l_ac].wso04,-239,1)
                         LET g_wso[l_ac].wso04 = g_wso_t.wso04
                         NEXT FIELD wso04
                 END IF 
                 IF NOT ttmap_col(g_wso[l_ac].wso04,g_wsm.wsm02) THEN
                    NEXT FIELD wso04
                 END IF
                 SELECT gaq03 INTO g_wso[l_ac].gaq03 FROM gaq_file
                  WHERE gaq01 = g_wso[l_ac].wso04 AND gaq02 = g_lang
                 DISPLAY g_wso[l_ac].gaq03 TO gaq03
             END IF
           END IF
          END IF
 
      ON ROW CHANGE
        IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wso[l_ac].* = g_wso_t.*
            CLOSE aws_ttcfg_col_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wso[l_ac].wso04,-263,1)
            LET g_wso[l_ac].* = g_wso_t.*
         ELSE
            UPDATE wso_file
               SET wso04 = g_wso[l_ac].wso04,
                   wso05 = g_wso[l_ac].wso05
             WHERE wso01 = g_wsm.wsm01 AND wso02 = g_wsm.wsm02
               AND wso03 = g_wso03 AND wso04 = g_wso_t.wso04
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(g_wso[l_ac].wso04,SQLCA.sqlcode,0)
               LET g_wso[l_ac].* = g_wso_t.*
               NEXT FIELD wso04
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_wso_t.wso04)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM wso_file WHERE wso01 = g_wsm.wsm01
              AND wso02 = g_wsm.wsm02 
              AND wso03 = g_wso03 AND wso04 = g_wso[l_ac].wso04
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_wso[l_ac].wso04,SQLCA.sqlcode,0)
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
         INSERT INTO wso_file(wso01,wso02,wso03,wso04,wso05)
             VALUES (g_wsm.wsm01,g_wsm.wsm02,g_wso03,g_wso[l_ac].wso04,g_wso[l_ac].wso05)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wso03,SQLCA.sqlcode,0)
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
               LET g_wso[l_ac].* = g_wso_t.*
            END IF
            CLOSE aws_ttcfg_col_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg_col_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wso[l_ac].* = g_wso_t.*
            END IF
            CLOSE aws_ttcfg_col_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg_col_bcl
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
   CLOSE aws_ttcfg_col_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_col_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   STRING
 
     LET g_sql = "SELECT wso04,wso05 FROM wso_file ",
                 " WHERE wso01 = '",g_wsm.wsm01 CLIPPED,"' ",
                 "   AND wso02 = '",g_wsm.wsm02 CLIPPED,"' ",
                 "   AND wso03 = '",g_wso03 CLIPPED,"' ",
                 "   AND ",p_wc CLIPPED,
                 " ORDER BY wso04"
 
    PREPARE aws_ttcfg_col_prepare3 FROM g_sql           #預備一下
    DECLARE wso_curs3 CURSOR FOR aws_ttcfg_col_prepare3
 
    CALL g_wso.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH wso_curs3 INTO g_wso[g_cnt].wso04,g_wso[g_cnt].wso05
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaq03 INTO g_wso[g_cnt].gaq03 FROM gaq_file
        WHERE gaq01 = g_wso[g_cnt].wso04 AND gaq02 = g_lang
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wso.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt4
    LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_ttcfg_col_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_wso TO s_wso.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL aws_ttcfg_col_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL aws_ttcfg_col_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL aws_ttcfg_col_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL aws_ttcfg_col_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL aws_ttcfg_col_fetch('L')
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
 
FUNCTION aws_ttcfg_col_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE wso_file.wso03,
            l_oldfe    LIKE wso_file.wso03
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_wso03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe
     WITHOUT DEFAULTS FROM wso03
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM wso_file
          WHERE wso01 = g_wsm.wsm01 AND wso02 = g_wsm.wsm02
            AND wso03 = l_newfe
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD wso03
         END IF
 
      #TQC-860022
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #END TQC-860022
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wso03 TO wso03
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM wso_file WHERE wso01 = g_wsm.wsm01 
      AND wso02 = g_wsm.wsm02 AND wso03 = g_wso03  
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wso03,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET wso03 = l_newfe                      # 資料鍵值 
   INSERT INTO wso_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('wso:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_wso03
   LET g_wso03 = l_newfe
   CALL aws_ttcfg_col_b()
   LET g_wso03 = l_oldfe
   CALL aws_ttcfg_col_show()
END FUNCTION
 
FUNCTION aws_ttcfg_delall() 
DEFINE l_tag          LIKE type_file.chr1
 
   LET l_tag = "N"
   IF INT_FLAG AND g_b_cmd="a" THEN
       DELETE FROM wsm_file WHERE wsm01=g_wsm.wsm01 AND wsm02=g_wsm.wsm02 
       IF SQLCA.sqlcode THEN
          CALL cl_err('wsm_file DELETE:',SQLCA.sqlcode,0)
          RETURN
       END IF
 
       DELETE FROM wsn_file WHERE wsn01=g_wsm.wsm01 AND wsn02=g_wsm.wsm02 
       IF SQLCA.sqlcode THEN
          CALL cl_err('wsn_file DELETE:',SQLCA.sqlcode,0)
          RETURN
       END IF
 
       DELETE FROM wso_file WHERE wso01=g_wsm.wsm01 AND wso02=g_wsm.wsm02  
       IF SQLCA.sqlcode THEN
          CALL cl_err('wso_file DELETE:',SQLCA.sqlcode,0)
          RETURN
       END IF
       LET l_tag = "Y"
   ELSE
 
       SELECT COUNT(*) INTO g_cnt FROM wsn_file 
         WHERE wsn01=g_wsm.wsm01 AND wsn02=g_wsm.wsm02
       IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
       
           CALL cl_getmsg('9044',g_lang) RETURNING g_msg
           ERROR g_msg CLIPPED
       
           DELETE FROM wsm_file WHERE wsm01=g_wsm.wsm01 AND wsm02=g_wsm.wsm02 
           IF SQLCA.sqlcode THEN
              CALL cl_err('wsm_file DELETE:',SQLCA.sqlcode,0)
              RETURN
           END IF
           DELETE FROM wso_file WHERE wso01=g_wsm.wsm01 AND wso02=g_wsm.wsm02  
           IF SQLCA.sqlcode THEN
              CALL cl_err('wso_file DELETE:',SQLCA.sqlcode,0)
              RETURN
           END IF
           LET l_tag = "Y"
       END IF
   END IF
   IF l_tag = "Y" THEN
      CLEAR FORM
      INITIALIZE g_wsm.*   LIKE wsm_file.*
      CALL g_wsn.clear()
      IF g_b_cmd <> 'a' THEN 
         OPEN aws_ttcfg_count
         FETCH aws_ttcfg_count INTO mi_row_count
         DISPLAY mi_row_count TO FORMONLY.cnt
         
         OPEN aws_ttcfg_curs
         IF mi_curs_index = mi_row_count + 1 THEN
            LET mi_jump = mi_row_count
            CALL aws_ttcfg_fetch('L')
         ELSE
            LET mi_jump = mi_curs_index
            LET mi_no_ask = TRUE
            CALL aws_ttcfg_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg_ref()
   DEFINE   p_row,p_col    LIKE type_file.num5
   DEFINE   l_rec_b        LIKE type_file.num5
   DEFINE   l_row_count    LIKE type_file.num10,
            l_curs_index   LIKE type_file.num10
 
   
   IF cl_null(g_wsm.wsm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_rec_b  = g_rec_b
   LET l_row_count  = mi_row_count
   LET l_curs_index = mi_curs_index
 
   LET g_wsp03_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW aws_ttcfg_ref_w AT p_row,p_col WITH FORM "aws/42f/aws_ttcfg_ref"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_locale("aws_ttcfg_ref")
 
   LET g_forupd_sql = "SELECT * from wsp_file  WHERE wsp01='",g_wsm.wsm01 CLIPPED,"'",
                      "   AND wsp02 = '",g_wsm.wsm02 CLIPPED ,"'",
                      "   AND wsp03 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg_ref_cl CURSOR FROM g_forupd_sql
   
   LET g_wc = " 1=1"
   CALL aws_ttcfg_ref_q()                            #Query 查詢
 
   CALL aws_ttcfg_ref_menu() 
 
   CLOSE WINDOW aws_ttcfg_ref_w                       # 結束畫面
 
   LET g_rec_b  = l_rec_b
   LET mi_row_count  = l_row_count
   LET mi_curs_index = l_curs_index
END FUNCTION
 
FUNCTION aws_ttcfg_ref_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_wsp.clear()
 
   IF cl_null(g_wc) THEN
      CONSTRUCT g_wc ON wsp03,wsp04,wsp05
           FROM wsp03,s_wsp[1].wsp04,s_wsp[1].wsp05
 
         #TQC-860022
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
        
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
        
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
        
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         #END TQC-860022
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE wsp03 FROM wsp_file ",
              " WHERE wsp01 ='",g_wsm.wsm01 CLIPPED,"'",
              "   AND wsp02 ='",g_wsm.wsm02 CLIPPED,"'",
              "   AND ", g_wc CLIPPED," ORDER BY wsp03"
 
   PREPARE aws_ttcfg_ref_prepare FROM g_sql          # 預備一下
   DECLARE aws_ttcfg_ref_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR aws_ttcfg_ref_prepare
 
END FUNCTION
 
FUNCTION aws_ttcfg_ref_count()
 
   LET g_sql= "SELECT UNIQUE wsp03 FROM wsp_file ",
              " WHERE wsp01 ='",g_wsm.wsm01 CLIPPED,"'",
              "   AND wsp02 ='",g_wsm.wsm02 CLIPPED,"'",
              "   AND ", g_wc CLIPPED," ORDER BY wsp03"
 
   PREPARE aws_ttcfg_ref_precount FROM g_sql
   DECLARE aws_ttcfg_ref_count CURSOR FOR aws_ttcfg_ref_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH aws_ttcfg_ref_count
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
 
FUNCTION aws_ttcfg_ref_menu()
 
   WHILE TRUE
      CALL aws_ttcfg_ref_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL aws_ttcfg_ref_u()
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
 
FUNCTION aws_ttcfg_ref_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_wsp.clear()
 
   INITIALIZE g_wsp03 LIKE wsp_file.wsp03         # 預設值及將數值類變數清成零
   LET g_wsp03_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL aws_ttcfg_ref_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_wsp03=NULL
         DISPLAY g_wsp03 TO wsp03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_wsp.clear()
      LET g_rec_b = 0
 
      CALL aws_ttcfg_ref_b()                          # 輸入單身
      LET g_wsp03_t=g_wsp03
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION aws_ttcfg_ref_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wsp03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_wsp03_t = g_wsp03
 
   BEGIN WORK
   OPEN aws_ttcfg_ref_cl USING g_wsp03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg_ref_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg_ref_cl INTO g_wsp_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsp03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg_ref_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL aws_ttcfg_ref_i("u")
      IF INT_FLAG THEN
         LET g_wsp03 = g_wsp03_t
         DISPLAY g_wsp03 TO wsp03 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE wsp_file SET wsp03 = g_wsp03
       WHERE wsp01 = g_wsm.wsm01 AND wsp02 = g_wsm.wsm02 
         AND wsp03 = g_wsp03_t 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wsp03,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      OPEN aws_ttcfg_ref_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL aws_ttcfg_ref_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_ref_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1          # a:輸入 u:更改
 
   DISPLAY g_wsp03 TO wsp03
   INPUT g_wsp03 WITHOUT DEFAULTS FROM wsp03
      
      AFTER FIELD wsp03                         
         IF NOT cl_null(g_wsp03) THEN
            IF g_wsp03 != g_wsp03_t OR cl_null(g_wsp03_t) THEN
               SELECT COUNT(UNIQUE wsp03) INTO g_cnt FROM wsp_file
                WHERE wsp01 = g_wsm.wsm01 AND wsp02 = g_wsm.wsm02
                  AND wsp03 = g_wsp03
               IF g_cnt > 0  THEN
                   CALL cl_err(g_wsp03,'-239',1)
                   LET g_wsp03 = g_wsp03_t
                   NEXT FIELD wsp03
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
 
      #TQC-860022
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
     
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #END TQC-860022
 
   END INPUT
END FUNCTION
 
FUNCTION aws_ttcfg_ref_q()                            #Query 查詢
   LET mi_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,mi_row_count)
   MESSAGE ""
   CLEAR FROM
   CALL g_wsp.clear()
   DISPLAY '    ' TO FORMONLY.cnt3
   IF g_action_choice = "query" THEN
      LET g_wc = NULL
   END IF
   CALL aws_ttcfg_ref_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN aws_ttcfg_ref_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_wsp03 TO NULL
   ELSE
      CALL aws_ttcfg_ref_count()
      DISPLAY mi_row_count TO FORMONLY.cnt3   #FUN-6B0097
      CALL aws_ttcfg_ref_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aws_ttcfg_ref_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1              #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     aws_ttcfg_ref_b_curs INTO g_wsp03
      WHEN 'P' FETCH PREVIOUS aws_ttcfg_ref_b_curs INTO g_wsp03
      WHEN 'F' FETCH FIRST    aws_ttcfg_ref_b_curs INTO g_wsp03
      WHEN 'L' FETCH LAST     aws_ttcfg_ref_b_curs INTO g_wsp03
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
         FETCH ABSOLUTE mi_jump aws_ttcfg_ref_b_curs INTO g_wsp03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wsp03,SQLCA.sqlcode,0)
      LET g_wsp03 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = mi_row_count
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, mi_row_count)
      CALL aws_ttcfg_ref_show()
   END IF
END FUNCTION
 
FUNCTION aws_ttcfg_ref_show()                         # 將資料顯示在畫面上
   LET g_wsp03_t = g_wsp03
   DISPLAY g_wsp03 TO wsp03                    # 假單頭
   CALL aws_ttcfg_ref_b_fill(g_wc)                    # 單身
END FUNCTION
 
FUNCTION aws_ttcfg_ref_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_wsp    RECORD LIKE wsp_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wsp03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN aws_ttcfg_ref_cl USING g_wsp03
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE aws_ttcfg_ref_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aws_ttcfg_ref_cl INTO g_wsp_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsp03 LOCK:",SQLCA.sqlcode,1)
      CLOSE aws_ttcfg_ref_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM wsp_file WHERE wsp01 = g_wsm.wsm01
            AND wsp02 = g_wsm.wsm02 AND wsp03 = g_wsp03  
         IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
         ELSE
            CLEAR FORM
            CALL g_wsp.clear()
            CALL aws_ttcfg_ref_count()
            DISPLAY mi_row_count TO FORMONLY.cnt3
            OPEN aws_ttcfg_ref_b_curs
            IF mi_curs_index = mi_row_count + 1 THEN
               LET mi_jump = mi_row_count
               CALL aws_ttcfg_ref_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL aws_ttcfg_ref_fetch('/')
            END IF
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_ref_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,      # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,      # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,      # 單身鎖住否
            p_cmd           LIKE type_file.chr1,      # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wsp03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT wsp04,wsp05 FROM wsp_file",
                     "  WHERE wsp01 = '",g_wsm.wsm01 CLIPPED,"'",
                     "   AND wsp02 = '",g_wsm.wsm02 CLIPPED,"'",
                     "   AND wsp03 = ? AND wsp04 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_ttcfg_ref_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wsp WITHOUT DEFAULTS FROM s_wsp.*
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
            LET g_wsp_t.* = g_wsp[l_ac].*    #BACKUP
            OPEN aws_ttcfg_ref_bcl USING g_wsp03,g_wsp[l_ac].wsp04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_ttcfg_ref_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_ttcfg_ref_bcl INTO g_wsp[l_ac].wsp04,g_wsp[l_ac].wsp05
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wsp03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_wsp[l_ac].gaq03 FROM gaq_file
                WHERE gaq01 = g_wsp[l_ac].wsp04 AND gaq02 = g_lang
               DISPLAY g_wsp[l_ac].gaq03 TO gaq03
            END IF
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wsp[l_ac].* TO NULL       #900423
         LET g_wsp_t.* = g_wsp[l_ac].*          #新輸入資料
         NEXT FIELD wsp04
 
      AFTER FIELD wsp04
         IF NOT cl_null(g_wsp[l_ac].wsp04) THEN
          IF g_wsp[l_ac].wsp04 != g_wsp_t.wsp04 OR g_wsp_t.wsp04 IS NULL THEN
             IF NOT cl_null(g_wsp[l_ac].wsp04) THEN
                 SELECT COUNT(*) INTO g_cnt FROM wsp_file 
                     where wsp01 = g_wsm.wsm01 AND wsp02 = g_wsm.wsm02
                       AND wsp03 = g_wsp03 
                       AND wsp04 = g_wsp[l_ac].wsp04
                 IF g_cnt > 0 THEN
                         CALL cl_err(g_wsp[l_ac].wsp04,-239,1)
                         LET g_wsp[l_ac].wsp04 = g_wsp_t.wsp04
                         NEXT FIELD wsp04
                 END IF 
                 IF NOT ttmap_col(g_wsp[l_ac].wsp04,g_wsm.wsm02) THEN
                    NEXT FIELD wsp04
                 END IF
                 SELECT gaq03 INTO g_wsp[l_ac].gaq03 FROM gaq_file
                  WHERE gaq01 = g_wsp[l_ac].wsp04 AND gaq02 = g_lang
                 DISPLAY g_wsp[l_ac].gaq03 TO gaq03
             END IF
           END IF
          END IF
 
      BEFORE FIELD wsp05
         CALL aws_textedit(g_wsp[l_ac].wsp05) RETURNING g_wsp[l_ac].wsp05
         DISPLAY g_wsp[l_ac].wsp05 TO wsp05
 
      ON ROW CHANGE
        IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wsp[l_ac].* = g_wsp_t.*
            CLOSE aws_ttcfg_ref_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wsp[l_ac].wsp04,-263,1)
            LET g_wsp[l_ac].* = g_wsp_t.*
         ELSE
            UPDATE wsp_file
               SET wsp04 = g_wsp[l_ac].wsp04,
                   wsp05 = g_wsp[l_ac].wsp05
             WHERE wsp01 = g_wsm.wsm01 AND wsp02 = g_wsm.wsm02
               AND wsp03 = g_wsp03 AND wsp04 = g_wsp_t.wsp04
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(g_wsp[l_ac].wsp04,SQLCA.sqlcode,0)
               LET g_wsp[l_ac].* = g_wsp_t.*
               NEXT FIELD wsp04
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_wsp_t.wsp04)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM wsp_file WHERE wsp01 = g_wsm.wsm01
              AND wsp02 = g_wsm.wsm02 
              AND wsp03 = g_wsp03 AND wsp04 = g_wsp[l_ac].wsp04
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_wsp[l_ac].wsp04,SQLCA.sqlcode,0)
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
         INSERT INTO wsp_file(wsp01,wsp02,wsp03,wsp04,wsp05)
             VALUES (g_wsm.wsm01,g_wsm.wsm02,g_wsp03,g_wsp[l_ac].wsp04,g_wsp[l_ac].wsp05)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wsp03,SQLCA.sqlcode,0)
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
               LET g_wsp[l_ac].* = g_wsp_t.*
            END IF
            CLOSE aws_ttcfg_ref_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg_ref_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_wsp[l_ac].* = g_wsp_t.*
            END IF
            CLOSE aws_ttcfg_ref_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE aws_ttcfg_ref_bcl
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
   CLOSE aws_ttcfg_ref_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_ttcfg_ref_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   STRING
 
     LET g_sql = "SELECT wsp04,wsp05 FROM wsp_file ",
                 " WHERE wsp01 = '",g_wsm.wsm01 CLIPPED,"' ",
                 "   AND wsp02 = '",g_wsm.wsm02 CLIPPED,"' ",
                 "   AND wsp03 = '",g_wsp03 CLIPPED,"' ",
                 "   AND ",p_wc CLIPPED,
                 " ORDER BY wsp04"
 
    PREPARE aws_ttcfg_ref_prepare3 FROM g_sql           #預備一下
    DECLARE wsp_curs3 CURSOR FOR aws_ttcfg_ref_prepare3
 
    CALL g_wsp.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH wsp_curs3 INTO g_wsp[g_cnt].wsp04,g_wsp[g_cnt].wsp05
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaq03 INTO g_wsp[g_cnt].gaq03 FROM gaq_file
        WHERE gaq01 = g_wsp[g_cnt].wsp04 AND gaq02 = g_lang
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wsp.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt4
    LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_ttcfg_ref_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_wsp TO s_wsp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL aws_ttcfg_ref_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL aws_ttcfg_ref_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL aws_ttcfg_ref_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL aws_ttcfg_ref_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, mi_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL aws_ttcfg_ref_fetch('L')
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
 
FUNCTION aws_ttcfg_ref_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE wsp_file.wsp03,
            l_oldfe    LIKE wsp_file.wsp03
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_wsp03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe
     WITHOUT DEFAULTS FROM wsp03
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM wsp_file
          WHERE wsp01 = g_wsm.wsm01 AND wsp02 = g_wsm.wsm02
            AND wsp03 = l_newfe
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD wsp03
         END IF
 
      #TQC-860022
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
     
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      #END TQC-860022
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wsp03 TO wsp03
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM wsp_file WHERE wsp01 = g_wsm.wsm01 
      AND wsp02 = g_wsm.wsm02 AND wsp03 = g_wsp03  
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wsp03,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET wsp03 = l_newfe                      # 資料鍵值 
   INSERT INTO wsp_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('wsp:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_wsp03
   LET g_wsp03 = l_newfe
   CALL aws_ttcfg_ref_b()
   #LET g_wsp03 = l_oldfe     #FUN-C80046
   #CALL aws_ttcfg_ref_show() #FUN-C80046
END FUNCTION
 
FUNCTION aws_textedit(p_txtedit)
DEFINE p_txtedit      STRING
DEFINE l_txtedit      STRING
DEFINE l_txtedit_t    STRING
DEFINE l_i            LIKE type_file.num5
DEFINE l_p1           LIKE type_file.num5
DEFINE l_p2           LIKE type_file.num5
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET l_txtedit   = p_txtedit
  LET l_txtedit_t = p_txtedit
 
  OPEN WINDOW aws_textedit_w WITH FORM "aws/42f/aws_ttcfg_textedit"
  ATTRIBUTE(STYLE=g_win_style)
 
  CALL cl_ui_locale("aws_ttcfg_textedit")
 
  DISPLAY l_txtedit TO txtedit
  INPUT l_txtedit WITHOUT DEFAULTS FROM txtedit
 
      AFTER FIELD txtedit
         LET l_i = 1
         LET l_p1 = l_txtedit.getIndexOf('${',1)
         IF l_p1 > 0 THEN
            WHILE l_i <= l_txtedit.getLength()
                LET l_p1 = l_txtedit.getIndexOf('${',l_i)
                IF l_p1 = 0 THEN
                   EXIT WHILE
                END IF
                LET l_p2 = l_txtedit.getIndexOf('}',l_i+2)
                IF l_p2 = 0 THEN
                   CALL cl_err('','aws-103',0)
                   NEXT FIELD txtedit
                END IF
                IF NOT ttmap_col(l_txtedit.subString(l_p1+2,l_p2-1),g_wsm.wsm02) THEN
                   NEXT FIELD txtedit
                END IF
                LET l_i = l_p2 + 1
            END WHILE
         END IF
      
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
  END INPUT
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CALL cl_err('',9001,0)
     CLEAR FORM
     LET l_txtedit =  l_txtedit_t
  END IF
 
  CLOSE WINDOW aws_textedit_w
  RETURN l_txtedit
 
END FUNCTION
 

