# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aws_crosscfg
# Descriptions...: CROSS 整合設定作業
# Date & Author..: No.FUN-B30003 11/03/10 Jay  
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0161 11/12/08 By ka0132 提供更新編碼狀態服務 & CROSS服務流程自動化處理
# Modify.........: No:FUN-B80090 11/12/30 By ka0132 站台設定之產品名稱開窗問題
# Modify.........: No:FUN-C20087 12/03/06 By Abby 1.隱藏ACTION[註冊產品主機],增加ACTION[整合參數維護][維護BI整合設定][維護EasyFlow整合設定] For CROSS自動化
DATABASE ds
 
#FUN-B30003
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wap                 RECORD LIKE wap_file.*,  #單頭
         g_wap_t               RECORD LIKE wap_file.*   #單頭(備份)
DEFINE   g_wsr                 DYNAMIC ARRAY of RECORD  #單身:TIPTOP服務清單
            tp_chk                LIKE type_file.chr1,      
            wsr01                 LIKE wsr_file.wsr01,
            wsr03                 LIKE wsr_file.wsr03 
                               END RECORD
DEFINE   g_wsr_t               DYNAMIC ARRAY of RECORD  # 變數舊值
            tp_chk                LIKE type_file.chr1,      
            wsr01                 LIKE wsr_file.wsr01,
            wsr03                 LIKE wsr_file.wsr03 
                               END RECORD
DEFINE   g_wao                 DYNAMIC ARRAY of RECORD  #單身:EasyFlow服務清單
            ef_chk                LIKE type_file.chr1,      
            wao02                 LIKE wao_file.wao02,
            wao03                 LIKE wao_file.wao03 
                               END RECORD
DEFINE   g_wao_t               DYNAMIC ARRAY of RECORD  # 變數舊值
            ef_chk                LIKE type_file.chr1,      
            wao02                 LIKE wao_file.wao02,
            wao03                 LIKE wao_file.wao03 
                               END RECORD 
DEFINE   g_war                 DYNAMIC ARRAY of RECORD  #單身:產品站台設定清單  
                                  LIKE war_file.*
DEFINE   g_war_t               RECORD LIKE war_file.*   # 變數舊值
DEFINE   g_cnt                 LIKE type_file.num10,  
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,              # TIPTOP單身筆數
         g_rec_b1              LIKE type_file.num5,              # EasyFlow單身筆數
         g_rec_b2              LIKE type_file.num5,              # 已設定整合產品單身筆數
         l_ac                  LIKE type_file.num5               # 目前處理的ARRAY CNT
DEFINE   g_msg                 STRING
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_b_cmd               LIKE type_file.chr1          
DEFINE   g_page_choice         LIKE type_file.chr20              # 目前所在page
DEFINE   g_prod_list           DYNAMIC ARRAY OF RECORD
            name                 LIKE type_file.chr30,       #產品名稱
            ver                  LIKE type_file.chr20,       #產品版本
            ip                   LIKE type_file.chr20,       #IP位置
            id                   LIKE type_file.chr20,       #識別碼
            wsdl                 LIKE wap_file.wap03         #wsdl
                               END RECORD
DEFINE   ma_qry                DYNAMIC ARRAY OF RECORD
           war03                 LIKE war_file.war03, 
           war04                 LIKE war_file.war04,
           war05                 LIKE war_file.war05,
           war06                 LIKE war_file.war06,
           war07                 LIKE war_file.war07
                               END RECORD
DEFINE   ma_qry_tmp            DYNAMIC ARRAY OF RECORD
           war03                 LIKE war_file.war03, 
           war04                 LIKE war_file.war04,
           war05                 LIKE war_file.war05,
           war06                 LIKE war_file.war06,
           war07                 LIKE war_file.war07
                               END RECORD
DEFINE   mi_multi_sel          LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons          LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where         STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count         LIKE type_file.num10    #每頁顯現資料筆數. 
DEFINE   ms_default1           STRING
DEFINE   ms_ret1               STRING 
DEFINE   ms_war03              LIKE war_file.war03
 
MAIN
   DEFINE   p_row,p_col        LIKE type_file.num5
   DEFINE   l_time             LIKE type_file.chr8  # 計算被使用時間
   DEFINE   l_war03_str        STRING
 
   OPTIONS                                          # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                               # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
#   CALL cl_used(g_prog,l_time,1)             # 計算使用時間 (進入時間)     #FUN-B80064   MARK
#   RETURNING l_time     #FUN-B80064   MARK
   CALL cl_used(g_prog,g_time,1)    #FUN-B80064     ADD
   RETURNING  g_time     #FUN-B80064   ADD
 
   OPEN WINDOW aws_crosscfg_w AT p_row,p_col WITH FORM "aws/42f/aws_crosscfg"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from wap_file WHERE wap01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE crosscfg_cl CURSOR FROM g_forupd_sql

   LET g_page_choice = "tp_list"

   #判斷是否為aws_efcfg2 action直接執行產品站台設定
   LET g_action_choice = ARG_VAL(1)
   IF g_action_choice = "prod_detail" THEN
      LET g_page_choice = ""
   END IF
   LET l_war03_str = cl_getmsg("aws-709", g_lang)
   LET l_war03_str = l_war03_str, ",", cl_getmsg("aws-710", g_lang)
   CALL cl_set_combo_items("war01", "S,E", l_war03_str)
   CALL cl_set_act_visible("reg_host", FALSE)     #FUN-C20087 add
   CALL crosscfg_show() 
   CALL crosscfg_menu() 
 
   CLOSE WINDOW aws_crosscfg_w                       # 結束畫面
  # CALL cl_used(g_prog,l_time,2)             # 計算使用時間 (退出時間)      #FUN-B80064     MARK
  # RETURNING l_time        #FUN-B80064     MARK
   CALL cl_used(g_prog,g_time,2)      #FUN-B80064     ADD
   RETURNING g_time         #FUN-B80064     ADD
END MAIN
 
FUNCTION crosscfg_menu()
   DEFINE l_wap08     LIKE wap_file.wap08
   DEFINE l_result    LIKE type_file.chr1
 
   WHILE TRUE
      CASE g_page_choice
         WHEN "tp_list"                          # TIPTOP接口服務清單
            CALL crosscfg_tp_b_fill(g_wc)        # TIPTOP服務單身
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL crosscfg_tp_bp("G")

         WHEN "ef_list"                          # EasyFlow接口服務清單
            CALL crosscfg_ef_b_fill(g_wc)        # EasyFlow服務單身
            DISPLAY g_rec_b1 TO FORMONLY.cn2
            CALL crosscfg_ef_bp("G")

         WHEN "prod_list"                        # 產品站台設定清單
            CALL crosscfg_prod_b_fill(g_wc)      # 已設定整合站台單身
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            CALL crosscfg_prod_bp("G")
         OTHERWISE
            IF ARG_VAL(1) = "prod_detail" THEN
               LET g_page_choice = "prod_list"
               CALL crosscfg_prod_b_fill(g_wc)   # 由於是從別支程式過來進行單身作業,所以補作單身填充
               DISPLAY g_rec_b2 TO FORMONLY.cn2
            END IF
      END CASE
      
      CASE g_action_choice
         WHEN "tp_detail"
            LET g_action_choice = "detail"
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL crosscfg_tp_b()
            END IF
            
         WHEN "ef_detail"
            LET g_action_choice = "detail" 
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL crosscfg_ef_b()
            END IF

         WHEN "prod_detail"
            LET g_action_choice = "detail" 
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL crosscfg_prod_b()
            END IF
            
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL crosscfg_u()
            END IF
            
         WHEN "help"                             # H.求助
            CALL cl_show_help()
            
         WHEN "exit"                             # Esc.結束
            EXIT WHILE
            
         WHEN "controlg"                         # KEY(CONTROL-G)
            CALL cl_cmdask()

         WHEN "tp_list"                          # TIPTOP接口服務清單
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL crosscfg_tp_bp("G")

         WHEN "ef_list"                          # EasyFlow接口服務清單
            DISPLAY g_rec_b1 TO FORMONLY.cn2
            CALL crosscfg_ef_bp("G")
         
         WHEN "reg_host"                         # 註冊產品主機
            DISPLAY "reg_host"
            #表示使用CROSS整合功能選項未被打勾,不提供註冊功能
            IF g_wap.wap02 = "N" AND g_wap.wap08 = "N" THEN
               CALL cl_err("", "aws-717", 1)
            ELSE
               #註冊成功
               LET l_wap08 = "Y" 
               IF crosscfg_update_wap08(l_wap08) THEN
                  IF NOT aws_cross_regProdAP() THEN
                     #若註冊失敗,則再變更wap08為未註冊
                     LET l_wap08 = "N"
                     CALL crosscfg_update_wap08(l_wap08) RETURNING l_result
                  ELSE
                     CALL crosscfg_show()
                  END IF
               END IF
            END IF

         WHEN "unreg_host"                       # 刪除註冊產品主機
            DISPLAY "unreg_host"
            #刪除註冊
            LET l_wap08 = "N" 
            IF crosscfg_update_wap08(l_wap08) THEN
               IF NOT aws_cross_regProdAP() THEN
                  #若刪除註冊失敗,則再變更wap08為已註冊
                  LET l_wap08 = "Y"
                  CALL crosscfg_update_wap08(l_wap08) RETURNING l_result
               ELSE
                  CALL crosscfg_show()
               END IF
            END IF
         
         WHEN "reg_services"                     # 註冊產品服務
            IF g_wap.wap02 = "N" OR g_wap.wap08 = "N" THEN
               CALL cl_err("", "aws-717", 1)
            ELSE
               DISPLAY "reg_services"
               CALL aws_cross_regSrv()
            END IF
         
         WHEN "cross_info"                       # 查看 CROSS 平台資訊
            IF g_wap.wap02 = "N" OR g_wap.wap08 = "N" THEN
               CALL cl_err("", "aws-717", 1)
            ELSE
               DISPLAY "cross_info"
               CALL crosscfg_getProdList()
            END IF
            
         WHEN "tp_services"                      # 維護 TIPTOP 接口服務
            CALL cl_cmdrun("aws_ttcfg2")
         
         WHEN "ef_services"                      # 維護 EasyFlow 整合服務
            CALL cl_cmdrun("aws_efsrv2_list")

        #FUN-C20087 add str----
         WHEN "bi_services"                      # 維護 BI 整合服務
            CALL cl_cmdrun("p_bi")

         WHEN "aws_efcfg2"                       # 維護 EasyFlow 整合設定服務
            CALL cl_cmdrun("aws_efcfg2")

         WHEN "aoos010_services"
            CALL cl_cmdrun("awss010")            # 維護 aoos010
        #FUN-C20087 add end----

         WHEN "related_document"
            IF cl_chk_act_auth() THEN 
               IF g_wap.wap01 IS NOT NULL THEN
                  LET g_doc.column1 = "wap01"
                  LET g_doc.value1 = g_wap.wap01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION crosscfg_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wap.wap01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
   OPEN crosscfg_cl USING g_wap.wap01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE crosscfg_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH crosscfg_cl INTO g_wap.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsr01 LOCK:",SQLCA.sqlcode,1)
      CLOSE crosscfg_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      LET g_wap_t.* = g_wap.*
 
      CALL crosscfg_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_wap.* = g_wap_t.*
         CALL crosscfg_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE wap_file SET wap.* = g_wap.*
        WHERE wap01 = g_wap.wap01 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_wap_t.wap01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE crosscfg_cl
   COMMIT WORK
   CALL crosscfg_show()
END FUNCTION
 
FUNCTION crosscfg_i(p_cmd)                       # 處理INPUT
   DEFINE p_cmd        LIKE type_file.chr1      # a:輸入 u:更改
   DEFINE l_gae04      LIKE gae_file.gae04      #欄位顯示名稱

   LET g_wap.wapgrup = g_grup
   LET g_wap.wapmodu = g_user
   LET g_wap.wapdate = g_today
   
   DISPLAY BY NAME g_wap.wapgrup,g_wap.wapmodu, g_wap.wapdate
 
   INPUT BY NAME g_wap.wap02, g_wap.wap03, g_wap.wap04, 
                 g_wap.wap05, g_wap.wap06, g_wap.wap07,
                 g_wap.wapuser,
                 g_wap.wapgrup,g_wap.wapmodu,g_wap.wapdate
                 WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL crosscfg_set_entry(p_cmd)
         CALL crosscfg_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      ON CHANGE wap02                         
         LET g_before_input_done = FALSE
         CALL crosscfg_set_entry(p_cmd)
         CALL crosscfg_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD wap03
         IF g_wap.wap02 = "Y" AND cl_null(g_wap.wap03) THEN
            SELECT gae04 INTO l_gae04 FROM gae_file 
              WHERE gae01 = 'aws_crosscfg' AND gae02 = 'wap03' AND gae03 = g_lang
            IF SQLCA.sqlcode OR cl_null(l_gae04) THEN
               LET l_gae04 = "wap03"
            END IF
            CALL cl_err_msg("","aws-715",l_gae04 CLIPPED,10)
            NEXT FIELD wap03
         END IF
         
      AFTER FIELD wap04
         IF g_wap.wap02 = "Y" AND cl_null(g_wap.wap04) THEN
            SELECT gae04 INTO l_gae04 FROM gae_file 
              WHERE gae01 = 'aws_crosscfg' AND gae02 = 'wap04' AND gae03 = g_lang
            IF SQLCA.sqlcode OR cl_null(l_gae04) THEN
               LET l_gae04 = "wap04"
            END IF
            CALL cl_err_msg("","aws-715",l_gae04 CLIPPED,10)
            NEXT FIELD wap04
         END IF

      AFTER FIELD wap05
         IF g_wap.wap02 = "Y" AND cl_null(g_wap.wap05) THEN
            SELECT gae04 INTO l_gae04 FROM gae_file 
              WHERE gae01 = 'aws_crosscfg' AND gae02 = 'wap05' AND gae03 = g_lang
            IF SQLCA.sqlcode OR cl_null(l_gae04) THEN
               LET l_gae04 = "wap05"
            END IF
            CALL cl_err_msg("","aws-715",l_gae04 CLIPPED,10)
            NEXT FIELD wap05
         END IF

      AFTER FIELD wap06
         IF g_wap.wap02 = "Y" AND cl_null(g_wap.wap06) THEN
            SELECT gae04 INTO l_gae04 FROM gae_file 
              WHERE gae01 = 'aws_crosscfg' AND gae02 = 'wap06' AND gae03 = g_lang
            IF SQLCA.sqlcode OR cl_null(l_gae04) THEN
               LET l_gae04 = "wap06"
            END IF
            CALL cl_err_msg("","aws-715",l_gae04 CLIPPED,10)
            NEXT FIELD wap06
         END IF

      AFTER FIELD wap07
         IF g_wap.wap02 = "Y" AND cl_null(g_wap.wap07) THEN
            SELECT gae04 INTO l_gae04 FROM gae_file 
              WHERE gae01 = 'aws_crosscfg' AND gae02 = 'wap07' AND gae03 = g_lang
            IF SQLCA.sqlcode OR cl_null(l_gae04) THEN
               LET l_gae04 = "wap07"
            END IF
            CALL cl_err_msg("","aws-715",l_gae04 CLIPPED,10)
            NEXT FIELD wap07
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
            EXIT INPUT
         END IF
         IF g_wap.wap02 = "N" AND g_wap.wap08 = "Y" THEN
            CALL cl_err("", "aws-718", 1)
         END IF 
 
      ON ACTION controlf  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
      
      ON ACTION about      
         CALL cl_about() 
      
      ON ACTION controlg   
         CALL cl_cmdask()  
      
      ON ACTION help    
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION

 
FUNCTION crosscfg_show()                         # 將資料顯示在畫面上
   DEFINE l_wap03   LIKE wap_file.wap03
   DEFINE l_area    STRING
   
   SELECT * INTO g_wap.* FROM wap_file WHERE wap01 = '0'

   IF SQLCA.sqlcode OR g_wap.wap01 IS NULL THEN
      IF SQLCA.sqlcode = -284 THEN
         CALL cl_err3("sel", "wap_file", g_wap.wap01, "" ,SQLCA.SQLCODE, "", "ERROR!",1)
         DELETE FROM wap_file
      END IF

      #TIPTOP WSDL 位置預設值(如:http://10.40.40.78:6384/ws/r/aws_ttsrv2?WSDL)
      LET l_wap03 = "http://", cl_get_tpserver_ip(), ":6384/ws/r/aws_ttsrv2"
      LET l_area = cl_get_env()
      IF l_area.trim() = "topprod" THEN
         LET l_wap03 = l_wap03, "?WSDL"
      ELSE
         LET l_wap03 = l_wap03, "_", l_area.trim(), "?WSDL"
      END IF
       
      LET g_wap.wap01 = "0"       #
      LET g_wap.wap02 = "N"       #是否使用CROSS整合平台
      LET g_wap.wap03 = l_wap03   #TIPTOP WSDL 位置
      LET g_wap.wap04 = ""        #CROSS WSDL 位置
      LET g_wap.wap05 = 3         #服務連線失敗重試次數
      LET g_wap.wap06 = 3         #服務連線失敗重試間隔
      LET g_wap.wap07 = 50        #同時連線人數
      LET g_wap.wap08 = "N"       #產品主機是否已註冊
      LET g_wap.wap09 = "N"       #FUN-BB0161 編碼是否啟動  
      LET g_wap.wapdate = g_today
      LET g_wap.wapuser = g_user
      LET g_wap.wapgrup = g_grup
      LET g_wap.waporiu = g_user 
      LET g_wap.waporig = g_grup 

      INSERT INTO wap_file VALUES (g_wap.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","wap_file",g_wap.wap01,"",SQLCA.sqlcode,"","I",0) 
         RETURN
      END IF
   END IF
 
   DISPLAY BY NAME
        g_wap.wap02, g_wap.wap03, g_wap.wap04, 
        g_wap.wap05, g_wap.wap06, g_wap.wap07, 
        g_wap.wap09,  #FUN-BB0161 編碼狀態是否啟動
        g_wap.wapuser, g_wap.wapgrup, g_wap.waporiu, 
        g_wap.waporig, g_wap.wapmodu,g_wap.wapdate

   LET g_cnt = 1
   DISPLAY g_cnt TO FORMONLY.cnt
END FUNCTION
  
FUNCTION crosscfg_tp_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_i             LIKE type_file.num10
   DEFINE   l_cnt           LIKE type_file.num5
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wap.wap01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = "FALSE"
   LET l_allow_delete = "FALSE"
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wsr WITHOUT DEFAULTS FROM s_wsr.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            LET g_wsr_t.* = g_wsr.*       #BACKUP
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK
            LET p_cmd='u'
            LET l_cnt = 0
            LET l_lock_sw = "Y"
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlf  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON ACTION about      
         CALL cl_about() 
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b
             LET g_wsr[l_i].tp_chk = "Y"
         END FOR
            
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b
             LET g_wsr[l_i].tp_chk = "N"
         END FOR

      ON ACTION ACCEPT
         LET g_action_choice = "accept"  
         CALL crosscfg_tp_b_u()
         IF g_wap.wap02 = "Y" THEN
            IF cl_confirm("aws-705") THEN
               CALL aws_cross_regSrv()
            END IF
         END IF
         EXIT INPUT

      ON ACTION cancel
         LET g_action_choice = "cancel"
         EXIT INPUT 
         
   END INPUT
 
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
   END IF

   COMMIT WORK
END FUNCTION

FUNCTION crosscfg_ef_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_i             LIKE type_file.num10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wap.wap01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = "FALSE"
   LET l_allow_delete = "FALSE"
   LET l_ac_t = 0
 
   INPUT ARRAY g_wao WITHOUT DEFAULTS FROM s_wao.*
              ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            LET g_wao_t.* = g_wao.*       #BACKUP
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK
            LET p_cmd='u'
            LET l_lock_sw = "Y"
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlf  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON ACTION about      
         CALL cl_about() 
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b1
             LET g_wao[l_i].ef_chk = "Y"
         END FOR
            
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b1
             LET g_wao[l_i].ef_chk = "N"
         END FOR

      ON ACTION ACCEPT
         LET g_action_choice = "accept"  
         CALL crosscfg_ef_b_u()
         IF g_wap.wap02 = "Y" THEN
            IF cl_confirm("aws-705") THEN
               CALL aws_cross_regSrv()
            END IF
         END IF
         EXIT INPUT

      ON ACTION cancel
         LET g_action_choice = "cancel"
         EXIT INPUT 
         
   END INPUT
 
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
   END IF

   COMMIT WORK
END FUNCTION

FUNCTION crosscfg_prod_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,           # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,           # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,           # 單身鎖住否
            p_cmd           LIKE type_file.chr1,           # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_i             LIKE type_file.num5
   DEFINE   l_count         LIKE type_file.num5            #總數
   DEFINE   l_result        LIKE type_file.chr1            #記錄比對結果
   DEFINE   l_cnt           LIKE type_file.num5
   #---FUN-B80090---start-----
   DEFINE   l_prod_info     STRING                         #記錄開窗所回傳之產品資訊 
   DEFINE   l_str           STRING
   DEFINE   l_tok           base.StringTokenizer
   #---FUN-B80090---end-------
   DEFINE   l_cnt2          INTEGER                        #FUN-BB0161
   DEFINE   l_idx           INTEGER                        #FUN-BB0161
   
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wap.wap01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET l_ac_t = 0
   LET l_count = 0
   CALL g_prod_list.clear()
 
   LET g_forupd_sql = "SELECT * FROM war_file ",
                      "  WHERE war01 = ? AND war02 = ? AND war03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE crosscfg_prod_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_war WITHOUT DEFAULTS FROM s_war.*
         ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL aws_cross_getProdList(g_prod_list)   #取得Cross平台已註冊產品資訊
         LET l_count = g_prod_list.getLength()     #若大於0,表已從Cross平台取得各產品資訊
 
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET l_prod_info = ""           #FUN-B80090

         IF g_rec_b2 >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            CALL cl_set_comp_entry("war04,war05,war06,war07",FALSE)
            LET g_war_t.* = g_war[l_ac].*  #BACKUP
            OPEN crosscfg_prod_bcl USING g_war_t.war01, g_war_t.war02, g_war_t.war03
            IF STATUS THEN
               CALL cl_err("OPEN crosscfg_prod_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH crosscfg_prod_bcl INTO g_war[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_war_t.war01 || "," || g_war_t.war02 || "," || g_war_t.war03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         CALL cl_set_comp_entry("war04,war05,war06,war07",FALSE)
         INITIALIZE g_war[l_ac].* TO NULL 
         LET g_war_t.* = g_war[l_ac].*         #新輸入資料
         NEXT FIELD war01
 
      AFTER INSERT
         DISPLAY "AFTER INSERT" 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE crosscfg_prod_bcl
            CANCEL INSERT
         END IF

         SELECT COUNT(*) INTO l_n FROM war_file
           WHERE war01 = g_war[l_ac].war01 AND war02 = g_war[l_ac].war02 AND
                 war03 = g_war[l_ac].war03
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            NEXT FIELD war01
         ELSE 
            BEGIN WORK 
            INSERT INTO war_file VALUES(g_war[l_ac].*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","war_file",g_war[l_ac].war01 || "," || g_war[l_ac].war02 || "," || g_war[l_ac].war03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2 = g_rec_b2 + 1
               DISPLAY g_rec_b2 TO FORMONLY.cn2  
               COMMIT WORK 
            END IF
         END IF

      AFTER FIELD war01                      #check 值是否為S或E,並將war02帶入預設值
         IF NOT cl_null(g_war[l_ac].war01) THEN
            LET g_war[l_ac].war01 = g_war[l_ac].war01 CLIPPED
            #判斷站台分類是否為"S"類或"E"類
            IF g_war[l_ac].war01 = "S" OR g_war[l_ac].war01 = "E" THEN
               IF g_war[l_ac].war01 = "S" THEN
                  LET g_war[l_ac].war02 = "*"
                  DISPLAY g_war[l_ac].war02 TO war02 
               ELSE
                  IF g_war[l_ac].war02 = "*" THEN
                     CALL cl_err("", "aws-711", 1)
                     LET g_war[l_ac].war02 = ""
                     DISPLAY g_war[l_ac].war02 TO war02 
                     NEXT FIELD war01
                  END IF
               END IF                  
            ELSE
               CALL cl_err('', "aws-706", 1)
               NEXT FIELD war01
            END IF
            
            IF g_war[l_ac].war01 != g_war_t.war01 OR g_war_t.war01 IS NULL THEN  
               #檢查war_file key值是否重覆
               IF NOT crosscfg_chk_war_key() THEN
                  NEXT FIELD war01
               END IF
            END IF
         END IF
 
      AFTER FIELD war02                      #check 營運中心編號輸入是否錯誤
         IF NOT cl_null(g_war[l_ac].war02) THEN
            LET g_war[l_ac].war02 = g_war[l_ac].war02 CLIPPED
            IF g_war[l_ac].war02 <> "*" THEN
               SELECT COUNT(*) INTO l_cnt FROM azw_file
                 WHERE azw01 = g_war[l_ac].war02
               IF l_cnt = 0 THEN
                  CALL cl_err3("sel","azw_file",g_war[l_ac].war02,"",100,"","sel azw",0)
                  NEXT FIELD war02
               END IF
               IF NOT cl_null(g_war[l_ac].war01) AND g_war[l_ac].war01 <> "E" THEN
                  CALL cl_err("", "aws-712", 1)
                  NEXT FIELD war01
               END IF
            ELSE 
               IF NOT cl_null(g_war[l_ac].war01) AND g_war[l_ac].war01 <> "S" THEN
                  CALL cl_err("", "aws-711", 1)
                  NEXT FIELD war01
               END IF
            END IF
            
            IF g_war[l_ac].war02 != g_war_t.war02 OR g_war_t.war02 IS NULL THEN 
               #檢查war_file key值是否重覆
               IF NOT crosscfg_chk_war_key() THEN
                  NEXT FIELD war02
               END IF
            END IF
         END IF

      AFTER FIELD war03                      #check 產品名稱輸入是否錯誤
         IF NOT cl_null(g_war[l_ac].war03) THEN
            IF g_war[l_ac].war03 != g_war_t.war03 OR g_war_t.war03 IS NULL THEN 
               LET g_war[l_ac].war03 = g_war[l_ac].war03 CLIPPED
               LET l_result = "N"
               #若一開始進入單身從CROSS平台沒有取得產品資訊,則重新再取一次
               IF l_count = 0 THEN
                  CALL aws_cross_getProdList(g_prod_list)
                  LET l_count = g_prod_list.getLength()
               END IF
               IF l_count = 0 THEN
                  CALL cl_err("", "aws-707", 1)
                  NEXT FIELD war03
               ELSE
                  #檢查產品名稱是否已註冊在CROSS平台上
                  IF g_war[l_ac].war03 = "TIPTOP" THEN
                     CALL cl_err("", "aws-713", 1)
                     NEXT FIELD war03
                  END IF
                  #---FUN-B80090---start-----
                  #l_prod_info值判斷,如果有值代表已做過開窗查詢,單純檢查此產品相關資訊是否已在CROSS註冊
                  IF NOT cl_null(l_prod_info) THEN
                     CALL crosscfg_chk_prod_exist(g_war[l_ac].war03, g_war[l_ac].war04, 
                          g_war[l_ac].war05, g_war[l_ac].war06, g_prod_list)
                          RETURNING l_result
                  ELSE
                  #---FUN-B80090---end-------
                  CALL crosscfg_qry_prod_info(g_war[l_ac].war03, g_prod_list)
                       RETURNING l_result, g_war[l_ac].war04, g_war[l_ac].war05,
                                 g_war[l_ac].war06, g_war[l_ac].war07
                  END IF   #FUN-B80090

                  IF l_result = "N" THEN
                     NEXT FIELD war03
                  ELSE
                     #預設畫面上其他產品資訊
                     DISPLAY g_war[l_ac].war04 TO war04
                     DISPLAY g_war[l_ac].war05 TO war05
                     DISPLAY g_war[l_ac].war06 TO war06
                     DISPLAY g_war[l_ac].war07 TO war07
                  END IF
               END IF
               #檢查war_file key值是否重覆
               IF NOT crosscfg_chk_war_key() THEN
                  NEXT FIELD war03
               END IF
            END IF
         END IF 

         #---FUN-B80090---start-----
         #當產品名稱為空,應該把其他相關產品欄位資訊也清空
         IF cl_null(g_war[l_ac].war03) OR l_result = "N" THEN
            LET g_war[l_ac].war04 = ""
            LET g_war[l_ac].war05 = ""
            LET g_war[l_ac].war06 = ""
            LET g_war[l_ac].war07 = ""
            DISPLAY g_war[l_ac].war04 TO war04
            DISPLAY g_war[l_ac].war05 TO war05
            DISPLAY g_war[l_ac].war06 TO war06
            DISPLAY g_war[l_ac].war07 TO war07
         END IF
         LET l_prod_info = ""
         #---FUN-B80090---end-------
 
      BEFORE DELETE                            #是否取消單身
         IF g_war_t.war01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            
            DELETE FROM war_file WHERE war01 = g_war_t.war01 AND 
                                       war02 = g_war_t.war02 AND 
                                       war03 = g_war_t.war03
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","war_file",g_war_t.war01 || "," || g_war_t.war02 || "," || g_war_t.war03,"",SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK 
                CANCEL DELETE
                EXIT INPUT
            END IF
 
            LET g_rec_b2 = g_rec_b2 - 1
            DISPLAY g_rec_b2 TO FORMONLY.cn2  
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_war[l_ac].* = g_war_t.*
           CLOSE crosscfg_prod_bcl
           ROLLBACK WORK
           EXIT INPUT
         END IF
         SELECT COUNT(*) INTO l_n FROM war_file
           WHERE war01 = g_war[l_ac].war01 AND war02 = g_war[l_ac].war02 AND
                 war03 = g_war[l_ac].war03
         #FUN-BB0161 - Start -
         LET l_cnt2 = 0 
         FOR l_idx = 1 TO g_war.getLength()
           IF g_war[l_ac].war01 = g_war[l_idx].war01 AND
              g_war[l_ac].war02 = g_war[l_idx].war02 AND
              g_war[l_ac].war03 = g_war[l_idx].war03 THEN
              LET l_cnt2 = l_cnt2 + 1
           END IF
         END FOR
         #IF l_n > 0 THEN #FUN-BB0161 mark
         IF l_n > 0 AND l_cnt2 > 1 THEN
         #FUN-BB0161 - Start -
            CALL cl_err('',-239,0)
            NEXT FIELD war01
         ELSE 
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_war[l_ac].war01 || "," || g_war[l_ac].war02 || "," || g_war[l_ac].war03,-263,0)
               LET g_war[l_ac].* = g_war_t.*
            ELSE
               UPDATE war_file SET war01 = g_war[l_ac].war01,
                                   war02 = g_war[l_ac].war02,
                                   war03 = g_war[l_ac].war03,
                                   war04 = g_war[l_ac].war04,
                                   war05 = g_war[l_ac].war05,
                                   war06 = g_war[l_ac].war06,
                                   war07 = g_war[l_ac].war07
               WHERE war01 = g_war_t.war01 AND
                     war02 = g_war_t.war02 AND
                     war03 = g_war_t.war03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","war_file",g_war_t.war01 || "," || g_war_t.war02 || "," || g_war_t.war03,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK  
                  LET g_war[l_ac].* = g_war_t.*
               ELSE
                  CALL cl_msg('Update O.K')
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()            # 新增
         LET l_ac_t = l_ac                # 新增
 
         IF INT_FLAG THEN  
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_war[l_ac].* = g_war_t.*
            END IF
            CLOSE crosscfg_prod_bcl       # 新增
            ROLLBACK WORK                 # 新增
            EXIT INPUT
         END IF
         CLOSE crosscfg_prod_bcl          # 新增
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(war01) AND l_ac > 1 THEN
             LET g_war[l_ac].* = g_war[l_ac-1].*
             NEXT FIELD war01
         END IF
 
      ON ACTION controlp
         CASE 
             WHEN INFIELD(war02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azw13"
                LET g_qryparam.default1 = g_war[l_ac].war02
                CALL cl_create_qry() RETURNING g_war[l_ac].war02
                DISPLAY g_war[l_ac].war02 TO war02
             WHEN INFIELD(war03)
                IF l_count = 0 THEN
                   CALL aws_cross_getProdList(g_prod_list)
                   LET l_count = g_prod_list.getLength()
                END IF
                IF l_count = 0 THEN
                   CALL cl_err("", "aws-707", 1)
                ELSE
                   CALL crosscfg_qryProdList(FALSE, FALSE, g_war[l_ac].war03) RETURNING l_prod_info   #FUN-B80090 回傳資訊欄位變多,所以需要將g_war[l_ac].war03改成l_prod_info字串來接
                   #---FUN-B80090---start-----
                   IF NOT cl_null(l_prod_info) THEN
                      LET l_tok = base.StringTokenizer.createExt(l_prod_info, "|", "", TRUE)
                      LET l_i = 3
                      WHILE l_tok.hasMoreTokens()
                         LET l_str = l_tok.nextToken()
                         CASE l_i
                            WHEN 3
                               LET g_war[l_ac].war03 = l_str
                            WHEN 4
                               LET g_war[l_ac].war04 = l_str
                            WHEN 5
                               LET g_war[l_ac].war05 = l_str
                            WHEN 6
                               LET g_war[l_ac].war06 = l_str
                            WHEN 7
                               LET g_war[l_ac].war07 = l_str
                         END CASE
                         LET l_i = l_i + 1
                      END WHILE
                      DISPLAY g_war[l_ac].war03 TO war03
                      DISPLAY g_war[l_ac].war04 TO war04
                      DISPLAY g_war[l_ac].war05 TO war05
                      DISPLAY g_war[l_ac].war06 TO war06
                      DISPLAY g_war[l_ac].war07 TO war07
                   END IF

                   #已改為開窗查詢直接帶回產品所有欄位資訊,因此以下mark
                   #DISPLAY g_war[l_ac].war03 TO war03
                   #IF NOT cl_null(g_war[l_ac].war03) THEN
                   #   #取出此產品其他資訊,並顯示在畫面上
                   #   CALL crosscfg_qry_prod_info(g_war[l_ac].war03, g_prod_list)
                   #       RETURNING l_result, g_war[l_ac].war04, g_war[l_ac].war05,
                   #                 g_war[l_ac].war06, g_war[l_ac].war07
                   #
                   #   IF l_result = "N" THEN
                   #      NEXT FIELD war03
                   #   ELSE
                   #      DISPLAY g_war[l_ac].war04 TO war04
                   #      DISPLAY g_war[l_ac].war05 TO war05
                   #      DISPLAY g_war[l_ac].war06 TO war06
                   #      DISPLAY g_war[l_ac].war07 TO war07
                   #   END IF
                   #END IF
                   #---FUN-B80090---end-------
                END IF
             OTHERWISE
                EXIT CASE
         END CASE
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about() 
 
      ON ACTION HELP     
         CALL cl_show_help() 
 
   END INPUT
 
   CLOSE crosscfg_prod_bcl
   COMMIT WORK

   CALL crosscfg_upd_plt("N") #FUN-C20087 寫入各產品站台設定檔
END FUNCTION
 
FUNCTION crosscfg_tp_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc   STRING 

   #第一段select sql在取出已註冊的TIPTOP服務
   #第一段select sql在取出還沒有註冊的TIPTOP服務
   LET g_sql = "SELECT 'Y' AS tp_chk, wsr01, wsr03 FROM wsr_file, waq_file ",
               "  WHERE wsr01 = waq02 AND waq01 = 'T' AND wsr02 = 'S' ",
               "UNION ",
               "SELECT 'N' AS tp_chk, wsr01, wsr03 FROM wsr_file ", 
               "  WHERE wsr01 NOT IN ",
               "    (SELECT waq02 FROM waq_file WHERE waq01 = 'T') ",
               "    AND wsr02 = 'S' ",
               " ORDER BY tp_chk desc"

    PREPARE crosscfg_tp_prepare FROM g_sql           #預備一下
    DECLARE wsr_tp_curs CURSOR FOR crosscfg_tp_prepare
 
    CALL g_wsr.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH wsr_tp_curs INTO g_wsr[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wsr.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION crosscfg_ef_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc   STRING 

   #第一段select sql在取出已註冊的EasyFlow服務
   #第一段select sql在取出還沒有註冊的EasyFlow服務
   LET g_sql = "SELECT 'Y' AS ef_chk, wao02, wao03 FROM wao_file, waq_file ",
               "  WHERE wao02 = waq02 AND waq01 = 'E' AND wao01 = 'T' ",
               "UNION ",
               "SELECT 'N' AS ef_chk, wao02, wao03 FROM wao_file ", 
               "  WHERE wao02 NOT IN ",
               "    (SELECT waq02 FROM waq_file WHERE waq01 = 'E') ",
               "    AND wao01 = 'T' ",
               " ORDER BY ef_chk desc"

    PREPARE crosscfg_ef_prepare FROM g_sql           #預備一下
    DECLARE wao_ef_curs CURSOR FOR crosscfg_ef_prepare
 
    CALL g_wao.clear()
 
    LET g_cnt = 1
    LET g_rec_b1 = 0

    FOREACH wao_ef_curs INTO g_wao[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b1 = g_rec_b1 + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       #服務說明因多語系的關係,資料存在wan_file
       SELECT wan06 INTO g_wao[g_cnt].wao03 FROM wan_file
         WHERE wan01 = 'wao_file' AND wan02 = 'wao02' AND 
               wan04 = g_wao[g_cnt].wao02 AND wan05 = g_lang
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wao.deleteElement(g_cnt)
 
    LET g_rec_b1 = g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION crosscfg_prod_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc   STRING 

   LET g_sql = "SELECT * FROM war_file ", 
               " ORDER BY war03, war02, war01"

    PREPARE crosscfg_prod_prepare FROM g_sql           #預備一下
    DECLARE war_prod_curs CURSOR FOR crosscfg_prod_prepare
 
    CALL g_war.clear()
 
    LET g_cnt = 1
    LET g_rec_b2 = 0

    FOREACH war_prod_curs INTO g_war[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b2 = g_rec_b2 + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_war.deleteElement(g_cnt)
 
    LET g_rec_b2 = g_cnt - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION crosscfg_tp_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_wao TO s_wao.*
      BEFORE DISPLAY
         EXIT DISPLAY  
   END DISPLAY

   DISPLAY ARRAY g_war TO s_war.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_wsr TO s_wsr.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_set_act_visible("page_tp", TRUE)
         CALL crosscfg_set_act_visible()
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY  
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="tp_detail"
         LET l_ac = 1
         EXIT DISPLAY
            
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
            
      ON ACTION accept
         LET g_action_choice="tp_detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY 
            
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY 
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY 
       
      ON ACTION ef_list                          # EasyFlow接口服務清單
         LET g_page_choice = "ef_list"
         EXIT DISPLAY  

      ON ACTION prod_list                        # 產品站台設定清單
         LET g_page_choice = "prod_list"     
         EXIT DISPLAY
         
      ON ACTION reg_host                         # 註冊產品主機
         LET g_action_choice="reg_host"
         EXIT DISPLAY 

      ON ACTION unreg_host                       # 刪除註冊產品主機
         LET g_action_choice="unreg_host"
         EXIT DISPLAY 
         
      ON ACTION reg_services                     # 註冊產品服務
         LET g_action_choice="reg_services"
         EXIT DISPLAY  
         
      ON ACTION cross_info                       # 查看 CROSS 平台資訊
         LET g_action_choice="cross_info"
         EXIT DISPLAY 
         
      ON ACTION tp_services                      # 維護 TIPTOP 接口服務
         LET g_action_choice="tp_services"
         EXIT DISPLAY 
         
      ON ACTION ef_services                      # 維護 EasyFlow 整合服務
         LET g_action_choice="ef_services"
         EXIT DISPLAY 

     #FUN-C20087 add str----
      ON ACTION bi_services                      # 維護 BI 整合服務
         LET g_action_choice="bi_services"
         EXIT DISPLAY

      ON ACTION aws_efcfg2                       # 維護 EasyFlow 整合設定服務
         LET g_action_choice="aws_efcfg2"
         EXIT DISPLAY

      ON ACTION aoos010_services                 # 維護 aoos010
         LET g_action_choice="aoos010_services"
         EXIT DISPLAY
     #FUN-C20087 add end----

      ON ACTION related_document                 # 相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY 
            
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 

      ON ACTION about      
         CALL cl_about() 
         CONTINUE DISPLAY 
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY  
 
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION crosscfg_ef_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_wsr TO s_wsr.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_war TO s_war.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_wao TO s_wao.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_set_act_visible("page_ef", TRUE)
         CALL crosscfg_set_act_visible()
            
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY  

      ON ACTION detail                           # B.單身
         LET g_action_choice="ef_detail"
         LET l_ac = 1
         EXIT DISPLAY 
            
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY 
            
      ON ACTION accept
         LET g_action_choice="ef_detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY 
            
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY 
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY  

      ON ACTION tp_list                          # TIPTOP接口服務清單
         LET g_page_choice = "tp_list"
         EXIT DISPLAY 
         
      ON ACTION prod_list                        # 產品站台設定清單
         LET g_page_choice = "prod_list"        
         EXIT DISPLAY
         
      ON ACTION reg_host                         # 註冊產品主機
         LET g_action_choice="reg_host"
         EXIT DISPLAY 
 
      ON ACTION unreg_host                       # 刪除註冊產品主機
         LET g_action_choice="unreg_host"
         EXIT DISPLAY 
         
      ON ACTION reg_services                     # 註冊產品服務
         LET g_action_choice="reg_services"
         EXIT DISPLAY 
         
      ON ACTION cross_info                       # 查看 CROSS 平台資訊
         LET g_action_choice="cross_info"
         EXIT DISPLAY 
         
      ON ACTION tp_services                      # 維護 TIPTOP 接口服務
         LET g_action_choice="tp_services"
         EXIT DISPLAY 
         
      ON ACTION ef_services                      # 維護 EasyFlow 整合服務
         LET g_action_choice="ef_services"
         EXIT DISPLAY 

     #FUN-C20087 add str----
      ON ACTION bi_services                      # 維護 BI 整合服務
         LET g_action_choice="bi_services"
         EXIT DISPLAY

      ON ACTION aws_efcfg2                       # 維護 EasyFlow 整合設定服務
         LET g_action_choice="aws_efcfg2"
         EXIT DISPLAY

      ON ACTION aoos010_services                 # 維護 aoos010
         LET g_action_choice="aoos010_services"
         EXIT DISPLAY
     #FUN-C20087 add end----

      ON ACTION related_document                 # 相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY 
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 

      ON ACTION about      
         CALL cl_about() 
         CONTINUE DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION crosscfg_prod_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_wao TO s_wao.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
      
   DISPLAY ARRAY g_wsr TO s_wsr.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_war TO s_war.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_set_act_visible("page_prod", TRUE)
         CALL crosscfg_set_act_visible()
            
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY  

      ON ACTION detail                           # B.單身
         IF g_wap.wap02 = "N" THEN
            CALL cl_err("", "aws-716", 1)
         ELSE
            LET g_action_choice="prod_detail"
            LET l_ac = 1
            EXIT DISPLAY 
         END IF
            
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY 
            
      ON ACTION ACCEPT
         IF g_wap.wap02 = "N" THEN
            CALL cl_err("", "aws-716", 1)
         ELSE
            LET g_action_choice="prod_detail"
            LET l_ac = ARR_CURR()
            EXIT DISPLAY 
         END IF
            
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY 
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY 
           
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY  

      ON ACTION tp_list                          # TIPTOP接口服務清單
         LET g_page_choice = "tp_list"
         EXIT DISPLAY 
         
      ON ACTION ef_list                          # EasyFlow接口服務清單
         LET g_page_choice = "ef_list"
         EXIT DISPLAY  
         
      ON ACTION reg_host                         # 註冊產品主機
         LET g_action_choice="reg_host"
         EXIT DISPLAY 

      ON ACTION unreg_host                       # 刪除註冊產品主機
         LET g_action_choice="unreg_host"
         EXIT DISPLAY 
          
      ON ACTION reg_services                     # 註冊產品服務
         LET g_action_choice="reg_services"
         EXIT DISPLAY 
         
      ON ACTION cross_info                       # 查看 CROSS 平台資訊
         LET g_action_choice="cross_info"
         EXIT DISPLAY 
         
      ON ACTION tp_services                      # 維護 TIPTOP 接口服務
         LET g_action_choice="tp_services"
         EXIT DISPLAY 
         
      ON ACTION ef_services                      # 維護 EasyFlow 整合服務
         LET g_action_choice="ef_services"
         EXIT DISPLAY 

     #FUN-C20087 add str----
      ON ACTION bi_services                      # 維護 BI 整合服務
         LET g_action_choice="bi_services"
         EXIT DISPLAY

      ON ACTION aws_efcfg2                       # 維護 EasyFlow 整合設定服務
         LET g_action_choice="aws_efcfg2"
         EXIT DISPLAY

      ON ACTION aoos010_services                 # 維護 aoos010
         LET g_action_choice="aoos010_services"
         EXIT DISPLAY
     #FUN-C20087 add end----

      ON ACTION related_document                 # 相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY 
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 

      ON ACTION about      
         CALL cl_about() 
         CONTINUE DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION crosscfg_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF (NOT g_before_input_done) OR INFIELD(wap01) THEN
      CALL cl_set_comp_entry("wap03,wap04,wap05,wap06,wap07", TRUE)
   END IF
 
END FUNCTION
 
FUNCTION crosscfg_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
    IF (NOT g_before_input_done) THEN       
       IF p_cmd = 'u' AND g_wap.wap02 matches'[Nn]' THEN
           CALL cl_set_comp_entry("wap03,wap04,wap05,wap06,wap07",FALSE)
       END IF
   END IF
END FUNCTION

FUNCTION crosscfg_tp_b_u()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_cnt   LIKE type_file.num5
   
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
       LET g_wsr.* = g_wsr_t.*
       RETURN
   END IF

   #確認將TIPTOP服務註冊
   IF g_action_choice = "accept" THEN  
      #確認註冊已勾選服務
      #要將已勾選服務代碼新增前,先delete table內所有關於TIPTOP的服務清單,己利重新Insert
      DELETE FROM waq_file WHERE waq01 = 'T'
      IF SQLCA.sqlcode THEN
         CALL cl_err("waq01 = T",SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
            
      LET l_cnt = g_wsr.getLength()
      FOR l_i = 1 TO l_cnt
          IF g_wsr[l_i].tp_chk = "Y" THEN
             INSERT INTO waq_file(waq01, waq02) VALUES ('T', g_wsr[l_i].wsr01)
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_wsr[l_i].wsr01,SQLCA.sqlcode,0)
                ROLLBACK WORK
                RETURN
             END IF
          END IF
      END FOR
      
      UPDATE wap_file SET wapmodu = g_user, wapdate = g_today
        WHERE wap01 = '0'
      LET g_wap.wapmodu = g_user
      LET g_wap.wapdate = g_today
      DISPLAY BY NAME g_wap.wapmodu, g_wap.wapdate

      COMMIT WORK
      MESSAGE 'UPDATE O.K'
   ELSE
      LET g_wsr.* = g_wsr_t.*
   END IF   
END FUNCTION

FUNCTION crosscfg_ef_b_u()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_cnt   LIKE type_file.num5
   
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
        LET g_wao.* = g_wao_t.*
       RETURN
   END IF

   #確認將EasyFlow服務註冊
   IF g_action_choice = "accept" THEN  
      #確認註冊已勾選服務
      #要將已勾選服務代碼新增前,先delete table內所有關於EasyFlow的服務清單,己利重新Insert
      DELETE FROM waq_file WHERE waq01 = 'E'
      IF SQLCA.sqlcode THEN
         CALL cl_err("waq01 = E",SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
            
      LET l_cnt = g_wao.getLength()
      FOR l_i = 1 TO l_cnt
          IF g_wao[l_i].ef_chk = "Y" THEN
             INSERT INTO waq_file(waq01, waq02) VALUES ('E', g_wao[l_i].wao02)
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_wao[l_i].wao02,SQLCA.sqlcode,0)
                ROLLBACK WORK
                RETURN
             END IF
          END IF
      END FOR
      
      UPDATE wap_file SET wapmodu = g_user, wapdate = g_today
        WHERE wap01 = '0'
      LET g_wap.wapmodu = g_user
      LET g_wap.wapdate = g_today
      DISPLAY BY NAME g_wap.wapmodu, g_wap.wapdate

      COMMIT WORK
      MESSAGE 'UPDATE O.K'
   ELSE
      LET g_wsr.* = g_wsr_t.*
   END IF   
END FUNCTION

FUNCTION crosscfg_getProdList()
   DEFINE l_prod_list       DYNAMIC ARRAY OF RECORD
            name              LIKE type_file.chr30,       #產品名稱
            ver               LIKE type_file.chr20,       #產品版本
            ip                LIKE type_file.chr20,       #IP位置
            id                LIKE type_file.chr20,       #識別碼
            wsdl              LIKE wap_file.wap03         #wsdl
                            END RECORD
   DEFINE l_prod_list_t     RECORD
            name              LIKE type_file.chr30,       #產品名稱
            ver               LIKE type_file.chr20,       #產品版本
            ip                LIKE type_file.chr20,       #IP位置
            id                LIKE type_file.chr20,       #識別碼
            wsdl              LIKE wap_file.wap03         #wsdl
                            END RECORD
   DEFINE l_rec_b           LIKE type_file.num5

   CALL aws_cross_getProdList(l_prod_list)   #取得Cross平台已註冊產品資訊
   LET l_rec_b = l_prod_list.getLength()
 
   OPEN WINDOW aws_cross_list_w AT 4, 16
        WITH FORM "aws/42f/aws_cross_list" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("aws_cross_list")
 
   MESSAGE ''

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_prod_list TO s_prod.* ATTRIBUTE(COUNT=l_rec_b) 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         LET l_prod_list_t.* = l_prod_list[l_ac].*
            
      ON ACTION cross_getProdDetail
         CALL crosscfg_getProdDetail(l_prod_list_t.name, l_prod_list_t.ver, l_prod_list_t.ip, l_prod_list_t.id)       

      ON ACTION accept
         CONTINUE DISPLAY 
         
      ON ACTION help                             # H.說明
         CALL cl_show_help()
         CONTINUE DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY 
            
      ON ACTION controlg
         CALL cl_cmdask()
         CONTINUE DISPLAY 

      ON ACTION about      
         CALL cl_about() 
         CONTINUE DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY  
   END DISPLAY
      
   CLOSE WINDOW aws_cross_list_w
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION crosscfg_getProdDetail(p_name, p_ver, p_ip, p_id)
   #需查詢詳細資訊之產品
   DEFINE p_name              LIKE type_file.chr30,     #產品名稱
          p_ver               LIKE type_file.chr20,     #產品版本
          p_ip                LIKE type_file.chr20,     #IP位置
          p_id                LIKE type_file.chr20      #識別碼
   DEFINE l_srv_list        DYNAMIC ARRAY OF RECORD     #web services回傳單身
            name              LIKE type_file.chr50      #服務名稱
                            END RECORD       
   DEFINE l_wsr             DYNAMIC ARRAY OF RECORD     #TIPTOP服務資訊
            wsr01             LIKE wsr_file.wsr01,      #服務名稱
            wsr03             LIKE wsr_file.wsr03       #服務說明
                            END RECORD  
   DEFINE l_rec_b           LIKE type_file.num5
   DEFINE l_i               LIKE type_file.num5 
   DEFINE l_dcnt            LIKE type_file.num5 
   DEFINE l_result          LIKE type_file.chr1

   OPEN WINDOW aws_prod_detail_w AT 4, 16
        WITH FORM "aws/42f/aws_prod_detail" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("aws_prod_detail")
 
   MESSAGE ''
   #單頭資訊
   CALL crosscfg_ProdDetail_show(p_name, p_ver, p_ip, p_id)
   LET l_dcnt = 1
   DISPLAY l_dcnt TO FORMONLY.dcnt
   DISPLAY l_rec_b TO FORMONLY.dcn2
         
   #單身資訊
   CALL aws_cross_getSrv(p_name, p_ver, p_ip, p_id, l_srv_list) RETURNING l_result
    
   LET l_rec_b = l_srv_list.getLength()

   FOR l_i = 1 TO l_rec_b
       #若是產品名稱為TIPTOP時,才找服務名稱和服務說明
       IF p_name = "TIPTOP" THEN
          SELECT wsr01, wsr03 INTO l_wsr[l_i].* FROM wsr_file
            WHERE wsr02 = 'S' AND wsr01 = l_srv_list[l_i].name

          IF cl_null(l_wsr[l_i].wsr01) THEN
             #服務說明資料因多語系關係,存放在wan_file中
             SELECT wao02, wan06 INTO l_wsr[l_i].* 
               FROM wao_file LEFT OUTER JOIN wan_file 
                 ON wan01 = 'wao_file' AND wan02 = 'wao02' AND
                    wan04 = wao02 AND wan05 = g_lang 
               WHERE wao01 = 'T' AND wao02 = l_srv_list[l_i].name
          END IF

          IF cl_null(l_wsr[l_i].wsr01) THEN
             LET l_wsr[l_i].wsr01 = l_srv_list[l_i].NAME
             LET l_wsr[l_i].wsr03 = ""
          END IF
       ELSE
          LET l_wsr[l_i].wsr01 = l_srv_list[l_i].name
          LET l_wsr[l_i].wsr03 = ""
       END IF
   END FOR

   DISPLAY ARRAY l_wsr TO s_srv.* ATTRIBUTE(COUNT=l_rec_b) 
      BEFORE DISPLAY
         IF p_name <> "TIPTOP" THEN
            CALL cl_set_comp_visible("wsr03", FALSE) 
         END IF
   
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  

      ON ACTION accept
         CONTINUE DISPLAY  
                              
      ON ACTION help                             # H.說明
         CALL cl_show_help()
         CONTINUE DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY 
            
      ON ACTION controlg
         CALL cl_cmdask()
         CONTINUE DISPLAY 

      ON ACTION about      
         CALL cl_about() 
         CONTINUE DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY  
   END DISPLAY
      
   CLOSE WINDOW aws_prod_detail_w
END FUNCTION

FUNCTION crosscfg_ProdDetail_show(p_name, p_ver, p_ip, p_id)   # 將資料顯示在畫面上
   #需查詢詳細資訊之產品
   DEFINE p_name            LIKE type_file.chr30,              #產品名稱
          p_ver             LIKE type_file.chr20,              #產品版本
          p_ip              LIKE type_file.chr20,              #IP位置
          p_id              LIKE type_file.chr20               #識別碼
   DEFINE p_prod_list       DYNAMIC ARRAY OF RECORD
            name              LIKE type_file.chr30,            #產品名稱
            ver               LIKE type_file.chr20,            #產品版本
            ip                LIKE type_file.chr20,            #IP位置
            id                LIKE type_file.chr20,            #識別碼
            wsdl              LIKE wap_file.wap03,             #wsdl
            timezone          LIKE azp_file.azp052,            #時區
            retrytimes        LIKE wap_file.wap05,             #服務連線失敗重試次數
            retryinterval     LIKE wap_file.wap06,             #服務連線失敗重次間隔
            concurrence       LIKE wap_file.wap07              #允許同時處理數
                            END RECORD
   DEFINE l_result          LIKE type_file.chr1
          
   #單頭資訊
   CALL aws_cross_getProd(p_name, p_ver, p_ip, p_id, p_prod_list) RETURNING l_result

   IF p_prod_list.getLength() > 0 THEN
      DISPLAY BY NAME p_prod_list[1].*
   END IF
END FUNCTION

FUNCTION crosscfg_qryProdList(pi_multi_sel, pi_need_cons, p_war03)
   DEFINE pi_multi_sel      LIKE type_file.num5,  
          pi_need_cons      LIKE type_file.num5
   DEFINE p_war03           LIKE war_file.war03

   LET ms_default1 = p_war03
   LET ms_war03 = p_war03
   LET ms_ret1 = NULL
 
   OPEN WINDOW qry_w AT 4, 16
        WITH FORM "aws/42f/aws_cross_list" ATTRIBUTE(STYLE = "create_qry")
   CALL cl_ui_locale("aws_cross_list")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("war03", "red")
   END IF
 
   CALL crosscfg_qry_sel()
 
   CLOSE WINDOW qry_w
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION

##################################################
# Description      : 畫面顯現與資料的選擇.
# Parameter       : none
# Return           : void
##################################################
FUNCTION crosscfg_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.    
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10, 
            li_end_index     LIKE type_file.num10 
   DEFINE   li_curr_page     LIKE type_file.num5  
 
 
   LET mi_page_count = 20 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
    
         CALL crosscfg_qry_prep_result_set() 
         #如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
         IF (NOT mi_need_cons) THEN
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
         END IF
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL crosscfg_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL crosscfg_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL crosscfg_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description      : 準備查詢畫面的資料集.
# Parameter       : none
# Return        : void
##################################################
FUNCTION crosscfg_qry_prep_result_set()
   DEFINE l_filter_cond    STRING 
   DEFINE ls_sql           STRING,
          ls_where         STRING
   DEFINE li_i             LIKE type_file.num5,
          l_count          LIKE type_file.num5            #總數
   DEFINE l_war03          STRING
   DEFINE l_ms_war03       STRING
   DEFINE l_n              LIKE type_file.num5


   CALL ma_qry.clear() 
   LET li_i = 1
   LET l_n = 1
   LET l_count = g_prod_list.getLength()
   
   FOR li_i = 1 TO l_count
       LET l_war03 = g_prod_list[li_i].name CLIPPED
       #剔除TIPTOP產品的開窗查詢
       IF l_war03 <> "TIPTOP" THEN
          IF cl_null(ms_war03) THEN
             LET ma_qry[l_n].* = g_prod_list[li_i].*
             LET l_n = l_n + 1
          ELSE
             LET l_war03 = l_war03.toLowerCase()
             LET l_ms_war03 = ms_war03 CLIPPED
             LET l_ms_war03 = cl_replace_str(l_ms_war03, "*", "")
             LET l_ms_war03 = l_ms_war03.toLowerCase()
             IF l_war03.getIndexOf(l_ms_war03, 1) > 0 THEN
                LET ma_qry[l_n].* = g_prod_list[li_i].*
                LET l_n = l_n + 1
             END IF
          END IF
       END IF
   END FOR
END FUNCTION

##################################################
# Description      : 設定查詢畫面的顯現資料.
# Parameter       : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置    #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置    #No.FUN-680131 INTEGER
# Return        : void
##################################################
FUNCTION crosscfg_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,     #INTEGER
            pi_end_index     LIKE type_file.num10     #INTEGER
   DEFINE   li_i             LIKE type_file.num10,     #INTEGER
            li_j             LIKE type_file.num10     #INTEGER
 
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION

##################################################
# Description      : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Parameter       : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置    #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置    #No.FUN-680131 INTEGER
# Return           : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
##################################################
FUNCTION crosscfg_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,     #INTEGER
            pi_end_index     LIKE type_file.num10     #INTEGER
   DEFINE   li_continue      LIKE type_file.num5,      #SMALLINT
            li_reconstruct   LIKE type_file.num5      #SMALLINT
   DEFINE   li_i             LIKE type_file.num5  
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_azp.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
         
      ON ACTION prevpage     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION refresh
         CALL azp1_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION accept
         IF ARR_CURR()>0 THEN  
            CALL crosscfg_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                    
            LET ms_ret1 = NULL 
         END IF   
         LET li_continue = FALSE
         EXIT INPUT
         
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
         LET li_continue = FALSE
         EXIT INPUT
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description      : 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Parameter       : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置    #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置    #No.FUN-680131 INTEGER
# Return           : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
##################################################
FUNCTION crosscfg_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,     #INTEGER
            pi_end_index     LIKE type_file.num10     #INTEGER
   DEFINE   li_continue      LIKE type_file.num5,      #SMALLINT
            li_reconstruct   LIKE type_file.num5      #SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_prod.* 
      BEFORE DISPLAY
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
         
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION accept
         CALL crosscfg_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
         LET li_continue = FALSE
         EXIT DISPLAY
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description      : 選擇並確認資料.
# Parameter       : pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return           : void
##################################################
FUNCTION crosscfg_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10     #INTEGER
   DEFINE   li_i            LIKE type_file.num10      #INTEGER
 
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF NOT (mi_multi_sel) THEN
      LET ms_ret1 = ma_qry[pi_sel_index].war03 CLIPPED
      #---FUN-B80090---start-----
      #將所有產品欄位資訊回傳
      LET ms_ret1 = ms_ret1, "|", ma_qry[pi_sel_index].war04 CLIPPED, 
                             "|", ma_qry[pi_sel_index].war05 CLIPPED, 
                             "|", ma_qry[pi_sel_index].war06 CLIPPED, 
                             "|", ma_qry[pi_sel_index].war07 CLIPPED
      #---FUN-B80090---end-------
   END IF
END FUNCTION

##################################################
# Description      : 檢查war_file key值是否重覆.
# Parameter       : 
# Return           : war_file依pk條件回傳是否有重覆,trun:是; false:否
##################################################
FUNCTION crosscfg_chk_war_key()
   DEFINE l_n        LIKE type_file.num10   #INTEGER

   LET l_n = 0
   IF NOT cl_null(g_war[l_ac].war01) AND 
      NOT cl_null(g_war[l_ac].war02) AND 
      NOT cl_null(g_war[l_ac].war03) THEN
      SELECT COUNT(*) INTO l_n FROM war_file
        WHERE war01 = g_war[l_ac].war01 AND war02 = g_war[l_ac].war02 AND
              war03 = g_war[l_ac].war03
    END IF
    IF l_n > 0 THEN
       CALL cl_err('',-239,0)
       RETURN FALSE
    ELSE
       RETURN TRUE
    END IF    
END FUNCTION

##################################################
# Description      : 回傳CROSS平台上註冊產品資訊.
# Parameter       : p_war03---------產品名稱
#                 p_prod_list-----CROSS平台上所有產品註冊資訊
# Return           : 依p_war03條件回傳成功或失敗和關於此產品的其它註冊資訊
##################################################
FUNCTION crosscfg_qry_prod_info(p_war03, p_prod_list)
   DEFINE   p_war03           LIKE war_file.war03
   DEFINE   p_prod_list       DYNAMIC ARRAY OF RECORD
            name                 LIKE type_file.chr30,       #產品名稱
            ver                  LIKE type_file.chr20,       #產品版本
            ip                   LIKE type_file.chr20,       #IP位置
            id                   LIKE type_file.chr20,       #識別碼
            wsdl                 LIKE wap_file.wap03         #wsdl
                              END RECORD
   DEFINE   l_n               LIKE type_file.num5   
   DEFINE   l_count           LIKE type_file.num5            #總數
   DEFINE   l_i               LIKE type_file.num5   

   LET l_n = 0
   LET l_count = p_prod_list.getLength()
   
   #檢查產品名稱是否已註冊在CROSS平台上
   FOR l_i = 1 TO l_count
       IF p_war03 = p_prod_list[l_i].name THEN
          LET l_n = l_i
          EXIT FOR
        END IF
   END FOR
   IF l_n = 0 THEN
      CALL cl_err_msg("","aws-708",g_war[l_ac].war03 CLIPPED,10)
      RETURN "N", "", "", "", ""
   ELSE
      #產品其他資訊
      RETURN "Y", g_prod_list[l_n].ver, g_prod_list[l_n].ip, 
             g_prod_list[l_n].id, g_prod_list[l_n].wsdl
   END IF
END FUNCTION

#---FUN-B80090---start-----
##################################################
# Description      : 檢查產品資訊是否已在CROSS平台上註冊.
# Parameter       : p_war03---------產品名稱 (必傳欄位)
#                 p_war04---------產品版本 (非必傳欄位,當為null時會略過不檢查)
#                 p_war05---------IP位置  (非必傳欄位,當為null時會略過不檢查)
#                 p_war06---------識別碼   (非必傳欄位,當為null時會略過不檢查) 
#                 p_prod_list-----CROSS平台上所有產品註冊資訊
# Return           : 依p_war03條件回傳成功或失敗和關於此產品的其它註冊資訊
##################################################
FUNCTION crosscfg_chk_prod_exist(p_war03, p_war04, p_war05, p_war06, p_prod_list)
   DEFINE   p_war03           LIKE war_file.war03
   DEFINE   p_war04           LIKE war_file.war04
   DEFINE   p_war05           LIKE war_file.war05
   DEFINE   p_war06           LIKE war_file.war06
   DEFINE   p_prod_list       DYNAMIC ARRAY OF RECORD
            name                 LIKE type_file.chr30,       #產品名稱
            ver                  LIKE type_file.chr20,       #產品版本
            ip                   LIKE type_file.chr20,       #IP位置
            id                   LIKE type_file.chr20,       #識別碼
            wsdl                 LIKE wap_file.wap03         #wsdl
                              END RECORD
   DEFINE   l_count           LIKE type_file.num5            #總數
   DEFINE   l_i               LIKE type_file.num5   
   DEFINE   l_result          LIKE type_file.chr1

   LET l_result = "N"
   LET l_count = p_prod_list.getLength()
   
   #檢查產品名稱是否已註冊在CROSS平台上
   FOR l_i = 1 TO l_count
       LET l_result = "Y"
       IF cl_null(p_war03) OR p_war03 <> p_prod_list[l_i].name THEN
          LET l_result = "N"
          CONTINUE FOR
       END IF
       IF NOT cl_null(p_war04) AND p_war04 <> p_prod_list[l_i].ver THEN
          LET l_result = "N"
          CONTINUE FOR 
       END IF
       IF NOT cl_null(p_war05) AND p_war05 <> p_prod_list[l_i].ip THEN
          LET l_result = "N" 
          CONTINUE FOR 
       END IF
       IF NOT cl_null(p_war06) AND p_war06 <> p_prod_list[l_i].id THEN
          LET l_result = "N" 
          CONTINUE FOR 
       END IF

       IF l_result = "Y" THEN
          EXIT FOR
       END IF
   END FOR
   IF l_result = "N" THEN
      CALL cl_err_msg("","aws-708",g_war[l_ac].war03 CLIPPED,10)
   END IF

   RETURN l_result
END FUNCTION
#---FUN-B80090---end-------

#變更產品主機註冊狀態,Y:已註冊/N:未註冊
FUNCTION crosscfg_update_wap08(p_wap08)
   DEFINE p_wap08   LIKE wap_file.wap08
   
   BEGIN WORK
   OPEN crosscfg_cl USING g_wap.wap01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE crosscfg_cl
      ROLLBACK WORK
      RETURN FALSE
   END IF
   
   FETCH crosscfg_cl INTO g_wap.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("wsr01 LOCK:",SQLCA.sqlcode,1)
      CLOSE crosscfg_cl
      ROLLBACK WORK
      RETURN FALSE
   END IF
 
   UPDATE wap_file SET wap08 = p_wap08
     WHERE wap01 = g_wap.wap01 
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_wap_t.wap01, SQLCA.sqlcode, 0)
      CLOSE crosscfg_cl
      ROLLBACK WORK
      RETURN FALSE
   ELSE
      LET g_wap.wap08 = p_wap08
      LET g_wap_t.* = g_wap.*
   END IF
               
   CLOSE crosscfg_cl
   COMMIT WORK
   RETURN TRUE
END FUNCTION

#變更註冊/刪除註冊action顯示狀態
FUNCTION crosscfg_set_act_visible()
   IF g_wap.wap02 = "N" AND g_wap.wap08 = "Y" THEN
     #CALL cl_set_act_visible("reg_host", FALSE)   #FUN-C20087
      CALL cl_set_act_visible("unreg_host", TRUE)
   ELSE
     #CALL cl_set_act_visible("reg_host", TRUE)    #FUN-C20087
      CALL cl_set_act_visible("unreg_host", FALSE)
   END IF 
END FUNCTION
