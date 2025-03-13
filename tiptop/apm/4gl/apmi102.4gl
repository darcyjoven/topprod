# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: apmi102.4gl
# Descriptions...: 常用特殊說明維護作業
# Date & Author..: 92/06/11 By tina
# Modify.........: 92/11/13 By Apple
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: NO.MOD-480221 BY wiky copy段寫法不正確
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0095 05/01/24 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 刪除時不清變數
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白
# Modify.........: No.FUN-6A0162 06/11/11 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pms           RECORD LIKE pms_file.*,
    g_pms_t         RECORD  LIKE pms_file.*,
    g_pms_o         RECORD  LIKE pms_file.*,
    g_pms01_t       LIKE pms_file.pms01,          #供應商編號  (舊值)
    g_pmt           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        pmt03       LIKE pmt_file.pmt03,          #行序
        pmt04       LIKE pmt_file.pmt04           #重要備註
                    END RECORD,
    g_pmt_t         RECORD                        #程式變數 (舊值)
        pmt03       LIKE pmt_file.pmt03,          #行序
        pmt04       LIKE pmt_file.pmt04           #重要備註
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000,  #NO.TQC-630166 MARK    #No.FUN-680136 VARCHAR(1000)
    g_wc,g_wc2,g_sql     STRING,                  #NO.TQC-630166
    g_flag          LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,          #單身筆數              #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT   #No.FUN-680136 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680136 SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i                   LIKE type_file.num5          #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg                 LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump                LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   mi_no_ask             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pms.pms01  = ARG_VAL(1)           #主件編號
 
   LET g_forupd_sql = "SELECT * FROM pms_file WHERE pms01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 19
 
   OPEN WINDOW i102_w AT p_row,p_col           #顯示畫面
     WITH FORM "apm/42f/apmi102"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
 
   IF NOT cl_null(g_pms.pms01) THEN
      LET g_flag = 'Y'
      SELECT pms02  INTO g_pms.pms02
        FROM pms_file
       WHERE pms01=g_pms.pms01
      CALL i102_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
   CALL i102_menu()
   CLOSE WINDOW i102_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i102_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_pmt.clear()
 
   IF g_flag = 'N' THEN
 
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pms.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON pms01,pms02
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
   ELSE
      LET g_wc = " pms01 ='",g_pms.pms01,"'"
      LET g_wc2= " pmt01 ='",g_pms.pms01,"'"
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND pmsuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND pmsgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND pmsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmsuser', 'pmsgrup')
   #End:FUN-980030
 
 
   IF g_flag = 'N' THEN
      CONSTRUCT g_wc2 ON pmt03,pmt04 FROM s_pmt[1].pmt03,s_pmt[1].pmt04
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
   ELSE
      LET g_wc2 = " 1=1"
   END IF
 
    IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
       LET g_sql = "SELECT  pms01 FROM pms_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE                              # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE pms_file. pms01 ",
                   "  FROM pms_file, pmt_file ",
                   " WHERE pms01 = pmt01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i102_prepare FROM g_sql
    DECLARE i102_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i102_prepare
 
    IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM pms_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT pms01) FROM pms_file,pmt_file WHERE ",
                 "pms01=pmt01 ",
                 " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i102_precount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_precount
 
END FUNCTION
 
FUNCTION i102_menu()
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i102_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i102_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i102_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i102_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i102_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i102_out()          
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document:"  #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_pms.pms01 IS NOT NULL THEN
                  LET g_doc.column1 = "pms01"
                  LET g_doc.value1  =  g_pms.pms01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmt),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i102_a()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pmt.clear()
   INITIALIZE g_pms.* LIKE pms_file.*             #DEFAULT 設定
   LET g_wc = NULL
   LET g_wc2 = NULL
   LET g_pms01_t = NULL
   LET g_pms_o.* = g_pms.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i102_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_pms.* TO NULL
         EXIT WHILE
      END IF
 
      IF cl_null(g_pms.pms01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO pms_file VALUES (g_pms.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#        CALL cl_err(g_pms.pms01,SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("ins","pms_file",g_pms.pms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
 
      SELECT pms01 INTO g_pms.pms01 FROM pms_file
       WHERE pms01 = g_pms.pms01
      LET g_pms01_t = g_pms.pms01        #保留舊值
      LET g_pms_t.* = g_pms.*
      CALL g_pmt.clear()
      LET g_rec_b = 0
      CALL i102_b()                   #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i102_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pms.pms01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pms01_t = g_pms.pms01
   LET g_pms_o.* = g_pms.*
   BEGIN WORK
 
   OPEN i102_cl USING g_pms.pms01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i102_cl INTO g_pms.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pms.pms01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i102_show()
 
   WHILE TRUE
      LET g_pms01_t = g_pms.pms01
 
      CALL i102_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pms.*=g_pms_t.*
         CALL i102_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_pms.pms01 != g_pms01_t THEN            # 更改單號
         UPDATE pmt_file SET pmt01 = g_pms.pms01
          WHERE pmt01 = g_pms01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('pmt',SQLCA.sqlcode,0) CONTINUE WHILE   #No.FUN-660129
            CALL cl_err3("upd","pmt_file",g_pms01_t,"",SQLCA.sqlcode,"","pmt",1)  CONTINUE WHILE #No.FUN-660129
         END IF
      END IF
 
      UPDATE pms_file SET pms_file.* = g_pms.*
       WHERE pms01 = g_pms.pms01
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_pms.pms01,SQLCA.sqlcode,0)   #No.FUN-660129
         CALL cl_err3("upd","pms_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i102_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i102_i(p_cmd)
  DEFINE
       p_cmd               LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
       l_flag              LIKE type_file.chr1,         #判斷必要欄位是否輸入 #No.FUN-680136 VARCHAR(1)
       l_msg1,l_msg2       LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(70)
       l_n                 LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME g_pms.pms01,g_pms.pms02 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i102_set_entry(p_cmd)
         CALL i102_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pms01   #說明編號
         IF NOT cl_null(g_pms.pms01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_pms.pms01 != g_pms01_t) THEN
               SELECT count(*) INTO l_n FROM pms_file
                WHERE pms01 = g_pms.pms01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_pms.pms01,-239,0)
                  LET g_pms.pms01 = g_pms01_t
                  DISPLAY BY NAME g_pms.pms01
                  NEXT FIELD pms01
               END IF
            END IF
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            #CLEAR FORM  #No.TQC-5B0212 不清畫面
            CALL g_pmt.clear()
            EXIT INPUT
         END IF
         IF g_pms.pms01 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_pms.pms01
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD pms01
         END IF
 
       #MOD-650015 --start
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #    IF INFIELD(pms01) THEN
      #        LET g_pms.* = g_pms_t.*
      #        DISPLAY BY NAME g_pms.*
      #        NEXT FIELD pms01
      #    END IF
       #MOD-650015 --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION i102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pms.* TO NULL             #No.FUN-6A0162
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmt.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i102_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pms.* TO NULL
   ELSE
      OPEN i102_count
      FETCH i102_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i102_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i102_cs INTO g_pms.pms01
      WHEN 'P' FETCH PREVIOUS i102_cs INTO g_pms.pms01
      WHEN 'F' FETCH FIRST    i102_cs INTO g_pms.pms01
      WHEN 'L' FETCH LAST     i102_cs INTO g_pms.pms01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i102_cs INTO g_pms.pms01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pms.pms01,SQLCA.sqlcode,0)
      INITIALIZE g_pms.* TO NULL  #TQC-6B0105
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
   SELECT pms01,pms02
     INTO g_pms.* FROM pms_file WHERE pms01 = g_pms.pms01
   IF SQLCA.sqlcode THEN
      LET g_msg=g_pms.pms01 CLIPPED,'+',g_pms.pms02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("sel","pms_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_pms.* TO NULL
      RETURN
   END IF
 
   CALL i102_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i102_show()
 
   LET g_pms_t.* = g_pms.*                #保存單頭舊值
   DISPLAY BY NAME   g_pms.pms01     # 顯示單頭值
   DISPLAY BY NAME   g_pms.pms02     # 顯示單頭值
 
   CALL i102_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i102_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pms.pms01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i102_cl USING g_pms.pms01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i102_cl INTO g_pms.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pms.pms01,SQLCA.sqlcode,0)          #資料被他人LOCK
      RETURN
   END IF
 
   CALL i102_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pms01"           #No.FUN-9B0098 10/02/24
       LET g_doc.value1  =  g_pms.pms01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pms_file WHERE pms01 = g_pms.pms01
      DELETE FROM pmt_file WHERE pmt01 = g_pms.pms01
      CLEAR FORM
      CALL g_pmt.clear()
      OPEN i102_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i102_cs
         CLOSE i102_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i102_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i102_cs
         CLOSE i102_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i102_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i102_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i102_fetch('/')
      END IF
   END IF
 
   CLOSE i102_cl
   COMMIT WORK
#  INITIALIZE g_pms.* TO NULL #No.TQC-5B0212
 
END FUNCTION
 
FUNCTION i102_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT      #No.FUN-680136 SMALLINT SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用             #No.FUN-680136 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否             #No.FUN-680136 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態               #No.FUN-680136 VARCHAR(1)
   l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入 #No.FUN-680136 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否               #No.FUN-680136 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否               #No.FUN-680136 SMALLINT
 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pms.pms01) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pmt03,pmt04 FROM pmt_file ",
                      " WHERE pmt01=?  AND pmt03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pmt WITHOUT DEFAULTS FROM s_pmt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN i102_cl USING g_pms.pms01
         IF STATUS THEN
            CALL cl_err("OPEN i102_cl:", STATUS, 1)
            CLOSE i102_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i102_cl INTO g_pms.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_pms.pms01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i102_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pmt_t.* = g_pmt[l_ac].*  #BACKUP
            OPEN i102_bcl USING g_pms.pms01,g_pmt_t.pmt03
            IF STATUS THEN
               CALL cl_err("OPEN i102_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i102_bcl INTO g_pmt[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('fetch i102_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pmt[l_ac].* TO NULL      #900423
         LET g_pmt_t.* = g_pmt[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD pmt03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pmt_file(pmt01,pmt03,pmt04)
         VALUES(g_pms.pms01,g_pmt[l_ac].pmt03,g_pmt[l_ac].pmt04)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmt[l_ac].pmt03,SQLCA.sqlcode,1)   #No.FUN-660129
            CALL cl_err3("ins","pmt_file",g_pms.pms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD pmt03                        #default 序號
         IF g_pmt[l_ac].pmt03 IS NULL OR g_pmt[l_ac].pmt03 = 0 THEN
            SELECT max(pmt03)+1
              INTO g_pmt[l_ac].pmt03
              FROM pmt_file
             WHERE pmt01 = g_pms.pms01
            IF g_pmt[l_ac].pmt03 IS NULL THEN
               LET g_pmt[l_ac].pmt03 = 1
            END IF
         END IF
 
      AFTER FIELD pmt03                        #check 序號是否重複
         IF NOT cl_null(g_pmt[l_ac].pmt03) THEN
            IF g_pmt[l_ac].pmt03 != g_pmt_t.pmt03 OR cl_null(g_pmt_t.pmt03) THEN
               SELECT count(*)
                 INTO l_n
                 FROM pmt_file
                WHERE pmt01 = g_pms.pms01
                  AND pmt03 = g_pmt[l_ac].pmt03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pmt[l_ac].pmt03 = g_pmt_t.pmt03
                  NEXT FIELD pmt03
               END IF
            END IF
            LET g_cnt = g_cnt + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pmt_t.pmt03 > 0 AND g_pmt_t.pmt03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pmt_file
             WHERE pmt01 = g_pms.pms01 AND pmt03 = g_pmt_t.pmt03
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_pmt_t.pmt03,SQLCA.sqlcode,0)   #No.FUN-660129
                CALL cl_err3("del","pmt_file",g_pms.pms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pmt[l_ac].* = g_pmt_t.*
            CLOSE i102_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pmt[l_ac].pmt03,-263,1)
            LET g_pmt[l_ac].* = g_pmt_t.*
         ELSE
            UPDATE pmt_file SET pmt03=g_pmt[l_ac].pmt03,
                                pmt04=g_pmt[l_ac].pmt04
             WHERE pmt01=g_pms.pms01
               AND pmt03=g_pmt_t.pmt03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pmt[l_ac].pmt03,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("upd","pmt_file",g_pms.pms01,g_pmt_t.pmt03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_pmt[l_ac].* = g_pmt_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac              #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pmt[l_ac].* = g_pmt_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pmt.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i102_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac              #FUN-D30034 add
         CLOSE i102_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i102_b_askkey()
#        EXIT INPUT
 
#     ON ACTION CONTROLO                        #沿用所有欄位
#        IF INFIELD(pmt03) AND l_ac > 1 THEN
#           LET g_pmt[l_ac].* = g_pmt[l_ac-1].*
#           NEXT FIELD pmt03
#        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END INPUT
 
   CLOSE i102_bcl
   COMMIT WORK
   CALL i102_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i102_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM pms_file WHERE pms01 = g_pms.pms01
         INITIALIZE g_pms.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i102_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON pmt03,pmt04
        FROM s_pmt[1].pmt03,s_pmt[1].pmt04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL i102_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(200)
   l_flag          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   LET g_sql = "SELECT pmt03,pmt04 ",
               " FROM pmt_file",
               " WHERE pmt01 ='",g_pms.pms01,"' AND ",  #單頭-1
               p_wc2 CLIPPED,                     #單身
               " ORDER BY pmt03"
   PREPARE i102_pb FROM g_sql
   DECLARE pmt_cs                       #SCROLL CURSOR
       CURSOR FOR i102_pb
 
   CALL g_pmt.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH pmt_cs INTO g_pmt[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_pmt.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmt TO s_pmt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
 
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i102_copy()
DEFINE
   l_pms RECORD LIKE pms_file.*,
   l_newno,l_oldno LIKE pms_file.pms01 #己存在,欲copy單身的廠商編號
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pms.pms01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
    LET g_before_input_done = FALSE  #No.MOD-480221
    CALL i102_set_entry('a')       #No.MOD-480221
    LET g_before_input_done = TRUE   #No.MOD-480221
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno FROM pms01
 
      AFTER FIELD pms01
         IF l_newno IS NULL THEN
            NEXT FIELD pms01
         END IF
         SELECT count(*) INTO g_cnt
           FROM pms_file #檢查廠商編號是否存在
          WHERE pms01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD pms01
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_pms.pms01
      RETURN
   END IF
 
   LET l_pms.* = g_pms.*
   LET l_pms.pms01 = l_newno
 
   BEGIN WORK
 
   INSERT INTO pms_file VALUES(l_pms.*)
   IF SQLCA.sqlcode THEN
#     CALL cl_err('pms:',SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("ins","pms_file",l_pms.pms01,"",SQLCA.sqlcode,"","pms:",1)  #No.FUN-660129
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pmt_file         #單身複製
    WHERE pmt01=g_pms.pms01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_pms.pms01,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("sel","pmt_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET pmt01=l_newno
 
   INSERT INTO pmt_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err('pmt:',SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("ins","pmt_file","","",SQLCA.sqlcode,"","pmt:",1)  #No.FUN-660129
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pms.pms01
 
   SELECT pms_file.* INTO g_pms.* FROM pms_file
    WHERE pms01 = l_newno
 
   CALL i102_u()
 
   CALL i102_b()
 
   #SELECT pms_file.* INTO g_pms.* FROM pms_file  #FUN-C80046
   # WHERE pms01 = l_oldno                        #FUN-C80046
 
   #CALL i102_show()                              #FUN-C80046
 
END FUNCTION
 
FUNCTION i102_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pms01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pms01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i102_out()
DEFINE
   l_i             LIKE type_file.num5,      #No.FUN-680136 SMALLINT
   sr              RECORD
       pms01       LIKE pms_file.pms01,      #特殊常用說明編號
       pms02       LIKE pms_file.pms02,      #備註
       pmt03       LIKE pmt_file.pmt03,      #行序號
       pmt04       LIKE pmt_file.pmt04       #備註
                   END RECORD,
   l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE type_file.chr1000              #No.FUN-680136 VARCHAR(40)
#No.FUN-820002--start-- 
DEFINE l_cmd           LIKE type_file.chr1000          
 
   IF cl_null(g_wc) AND NOT cl_null(g_pms.pms01) THEN                                                                               
      LET g_wc = " pms01 = '",g_pms.pms01,"'"                                                                                       
   END IF                                                                                                                           
   IF cl_null(g_wc2) THEN                                                                                                           
       LET g_wc2 = " 1=1"                                                                                                           
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "apmi102" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'                                                         
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN   
 
#   IF cl_null(g_wc) THEN
#       LET g_wc=" pms01 '",g_pms.pms01,"'"
#       LET g_wc2=" 1=1"
#   END IF
 
#   CALL cl_wait()
#   CALL cl_outnam('apmi102') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pms01,pms02,pmt03,pmt04",
#             " FROM pms_file,pmt_file ",
#             " WHERE pms01=pmt01 ",
#             " AND ",g_wc CLIPPED,
#             " AND ",g_wc2 CLIPPED
#   PREPARE i102_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i102_co                         # CURSOR
#       CURSOR FOR i102_p1
 
#   START REPORT i102_rep TO l_name
 
#   FOREACH i102_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i102_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i102_rep
 
#   CLOSE i102_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i102_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
#   l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
#   sr              RECORD
#       pms01       LIKE pms_file.pms01,   #常用特殊說明
#       pms02       LIKE pms_file.pms02,   #備註
#       pmt03       LIKE pmt_file.pmt03,   #行序
#       pmt04       LIKE pmt_file.pmt04    #說明
#                   END RECORD
 
#OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#ORDER BY sr.pms01,sr.pmt03
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#  #        PRINT                #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.pms01
#           PRINT COLUMN g_c[31],sr.pms01,
#                 COLUMN g_c[32],sr.pms02;
 
#       ON EVERY ROW
#          PRINT COLUMN g_c[33],sr.pmt03 USING "###&",
#                COLUMN g_c[34],sr.pmt04 CLIPPED
 
#       AFTER GROUP OF sr.pms01
#          SKIP 1 LINES
 
#       ON LAST ROW
#           PRINT g_dash
#           IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,201
##NO.TQC-630166 start--
##               THEN IF g_wc[001,080] > ' ' THEN
##              PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
##                    IF g_wc[071,140] > ' ' THEN
##              PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
##                    IF g_wc[141,210] > ' ' THEN
##              PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#               CALL cl_prt_pos_wc(g_wc)
##NO.TQC-630166 end-- 
#                   PRINT g_dash
#           END IF
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
 
#Patch....NO.MOD-5A0095 <> #
