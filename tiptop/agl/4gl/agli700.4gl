# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli700.4gl
# Descriptions...: 分攤傳票類別資料維護作業
# Date & Author..: 92/03/16   BY jones
#                  By Melody    _out() 加入 OUTER acb_file
# Modify.........:No.MOD-490232 93/09/13 By Yuna 新增時,進入單身前會出現錯誤訊息
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750022 07/05/09 By Lynn 1."FROM:"位置在報表名之上
#                                                 2.打印時,無效資料無特殊標記
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/08/03 By sherry  報表改由Crystal Report輸出                                                     
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   g_aca           RECORD LIKE aca_file.*,       #類別編號 (假單頭)
   g_aca_t         RECORD LIKE aca_file.*,       #類別編號 (舊值)
   g_aca_o         RECORD LIKE aca_file.*,       #類別編號 (舊值)
   g_aca01_t       LIKE aca_file.aca01,   #類別編號 (舊值)
   g_acb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       acb02       LIKE acb_file.acb02,   #行序
       acb03       LIKE acb_file.acb03   #額外說明
                   END RECORD,
   g_acb_t         RECORD    #程式變數(Program Variables)
       acb02       LIKE acb_file.acb02,   #行序
       acb03       LIKE acb_file.acb03   #額外說明
                   END RECORD,
#  g_wc,g_wc2,g_sql    VARCHAR(300),
   g_wc,g_wc2,g_sql    STRING,        #TQC-630166      
   g_rec_b         LIKE type_file.num5,                #單身筆數            #No.FUN-680098  SMALLINT
   l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT #No.FUN-680098  SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680098  SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680098 SMALLINT
DEFINE g_str           STRING                      #No.FUN-760085
MAIN
DEFINE
#       l_time   LIKE type_file.chr8            #No.FUN-6A0073
   p_row,p_col   LIKE type_file.num5           #No.FUN-680098 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET g_forupd_sql = "SELECT * FROM aca_file WHERE aca01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i700_cl CURSOR FROM g_forupd_sql
 
   LET p_row =4  LET p_col = 30
   OPEN WINDOW i700_w AT p_row,p_col
     WITH FORM "agl/42f/agli700"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i700_menu()
   CLOSE WINDOW i700_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i700_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
      CALL g_acb.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029
 
   INITIALIZE g_aca.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
       aca01,aca02,aca03,acauser,acagrup,acamodu,acadate,acaacti
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
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND acauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND acagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND acagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('acauser', 'acagrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON acb02,acb03 FROM s_acb[1].acb02,s_acb[1].acb03
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  aca01 FROM aca_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY aca01"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT  aca01 ",
                  "  FROM aca_file, acb_file ",
                  " WHERE aca01 = acb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY aca01"
   END IF
 
   PREPARE i700_prepare FROM g_sql
   DECLARE i700_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i700_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM aca_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT aca01) FROM aca_file,acb_file WHERE ",
                "acb01=aca01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i700_precount FROM g_sql
   DECLARE i700_count CURSOR FOR i700_precount
END FUNCTION
 
FUNCTION i700_menu()
 
   WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i700_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i700_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i700_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i700_x()
               CALL cl_set_field_pic("","","","","",g_aca.acaacti)
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i700_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i700_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_aca.aca01 IS NOT NULL THEN
                  LET g_doc.column1 = "aca01"
                  LET g_doc.value1 = g_aca.aca01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_acb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i700_a()
   IF s_aglshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
      CALL g_acb.clear()
   INITIALIZE g_aca.* LIKE aca_file.*             #DEFAULT 設定
   LET g_aca01_t = NULL
   #預設值及將數值類變數清成零
   LET g_aca_o.* = g_aca.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_aca.acauser=g_user
      LET g_aca.acaoriu = g_user #FUN-980030
      LET g_aca.acaorig = g_grup #FUN-980030
      LET g_aca.acagrup=g_grup
      LET g_aca.acadate=g_today
      LET g_aca.acaacti='Y'              #資料有效
      CALL i700_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_aca.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_aca.aca01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO aca_file VALUES (g_aca.*)
      IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#        CALL cl_err(g_aca.aca01,SQLCA.sqlcode,1)   #No.FUN-660123
         CALL cl_err3("ins","aca_file",g_aca.aca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      SELECT aca01 INTO g_aca.aca01 FROM aca_file
       WHERE aca01 = g_aca.aca01
      LET g_aca01_t = g_aca.aca01        #保留舊值
      LET g_aca_t.* = g_aca.*
      CALL g_acb.clear()
       LET g_rec_b = 0                 #No.MOD-490232
      CALL i700_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i700_u()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aca.aca01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aca.* FROM aca_file WHERE aca01=g_aca.aca01
   IF g_aca.acaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aca.aca01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aca01_t = g_aca.aca01
   LET g_aca_o.* = g_aca.*
   BEGIN WORK
 
   OPEN i700_cl USING g_aca.aca01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i700_cl INTO g_aca.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i700_cl ROLLBACK WORK RETURN
   END IF
   CALL i700_show()
   WHILE TRUE
      LET g_aca01_t = g_aca.aca01
      LET g_aca.acamodu=g_user
      LET g_aca.acadate=g_today
      CALL i700_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aca.*=g_aca_t.*
         CALL i700_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_aca.aca01 != g_aca01_t THEN            # 更改單號
         UPDATE acb_file SET acb01 = g_aca.aca01
          WHERE acb01 = g_aca01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('acb',SQLCA.sqlcode,0)  #No.FUN-660123
            CALL cl_err3("upd","acb_file",g_aca01_t,"",SQLCA.sqlcode,"","acb",1)  #No.FUN-660123
            CONTINUE WHILE
         END IF
      END IF
      UPDATE aca_file SET aca_file.* = g_aca.*
       WHERE aca01 = g_aca.aca01
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","aca_file",g_aca01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i700_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i700_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入 #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1     #a:輸入 u:更改          #No.FUN-680098 VARCHAR(1)
 
   DISPLAY BY NAME g_aca.acauser,g_aca.acamodu,g_aca.acagrup,g_aca.acadate,g_aca.acaacti
   CALL cl_set_head_visible("","YES")      #No.FUN-6B0029 
 
   INPUT BY NAME g_aca.acaoriu,g_aca.acaorig,g_aca.aca01,g_aca.aca02,g_aca.aca03 WITHOUT DEFAULTS 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i700_set_entry(p_cmd)
         CALL i700_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD aca01                  #類別編號
         IF NOT cl_null(g_aca.aca01) THEN
            IF g_aca.aca01 != g_aca01_t OR g_aca01_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM aca_file
                WHERE aca01 = g_aca.aca01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_aca.aca01,-239,0)
                  LET g_aca.aca01 = g_aca01_t
                  DISPLAY BY NAME g_aca.aca01
                  NEXT FIELD aca01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
     #MOD-650015 --start  
     #ON ACTION CONTROLO                        # 沿用所有欄位
     #   IF INFIELD(aca01) THEN
     #      LET g_aca.* = g_aca_t.*
     #      DISPLAY BY NAME g_aca.*
     #      NEXT FIELD aca01
     #   END IF
     #MOD-650015 --end
 
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
 
 
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i700_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aca.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_acb.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i700_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aca.* TO NULL
   ELSE
      OPEN i700_count
      FETCH i700_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i700_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i700_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098  INTEGER 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i700_cs INTO g_aca.aca01
      WHEN 'P' FETCH PREVIOUS i700_cs INTO g_aca.aca01
      WHEN 'F' FETCH FIRST    i700_cs INTO g_aca.aca01
      WHEN 'L' FETCH LAST     i700_cs INTO g_aca.aca01
      WHEN '/'
          IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
#                    CONTINUE PROMPT
 
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
          FETCH ABSOLUTE g_jump i700_cs INTO g_aca.aca01
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)
      INITIALIZE g_aca.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_aca.* FROM aca_file WHERE aca01 = g_aca.aca01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","aca_file",g_aca.aca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      INITIALIZE g_aca.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_aca.acauser     #No.FUN-4C0048
      LET g_data_group = g_aca.acagrup     #No.FUN-4C0048
      CALL i700_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i700_show()
   LET g_aca_t.* = g_aca.*                #保存單頭舊值
   DISPLAY BY NAME g_aca.acaoriu,g_aca.acaorig,                              # 顯示單頭值
       g_aca.aca01,g_aca.aca02,g_aca.aca03,
       g_aca.acauser,g_aca.acagrup,g_aca.acamodu,
       g_aca.acadate,g_aca.acaacti
   CALL i700_b_fill(g_wc2)                 #單身
   CALL cl_set_field_pic("","","","","",g_aca.acaacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i700_x()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aca.aca01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i700_cl USING g_aca.aca01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i700_cl INTO g_aca.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i700_cl ROLLBACK WORK RETURN
   END IF
   CALL i700_show()
   IF cl_exp(0,0,g_aca.acaacti) THEN                   #確認一下
      LET g_chr=g_aca.acaacti
      IF g_aca.acaacti='Y' THEN
         LET g_aca.acaacti='N'
      ELSE
         LET g_aca.acaacti='Y'
      END IF
      UPDATE aca_file                    #更改有效碼
         SET acaacti=g_aca.acaacti
       WHERE aca01=g_aca.aca01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","aca_file",g_aca.aca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         LET g_aca.acaacti=g_chr
      END IF
      DISPLAY BY NAME g_aca.acaacti
   END IF
   CLOSE i700_cl
   COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i700_r()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aca.aca01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_aca.acaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aca.aca01,9027,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i700_cl USING g_aca.aca01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i700_cl INTO g_aca.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i700_cl ROLLBACK WORK RETURN
   END IF
   CALL i700_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "aca01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_aca.aca01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM aca_file WHERE aca01 = g_aca.aca01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","aca_file",g_aca.aca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      END IF
      DELETE FROM acb_file WHERE acb01 = g_aca.aca01
      CLEAR FORM
      CALL g_acb.clear()
      CALL g_acb.clear()
      OPEN i700_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i700_cs
         CLOSE i700_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i700_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i700_cs
         CLOSE i700_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i700_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i700_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i700_fetch('/')
      END IF
   END IF
   CLOSE i700_cl
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i700_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT         #No.FUN-680098  SMALLINT
   p_key           LIKE type_file.chr1,                #為確定是在新增或更新狀態, #No.FUN-680098  VARCHAR(1)
                                          #以判斷是否可建立第150~200筆的資料
   l_n             LIKE type_file.num5,                #檢查重複用             #No.FUN-680098  SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680098 VARCHAR(1)
   l_direct        LIKE type_file.chr1,                 #Esc結束INPUT ARRAY 否  #No.FUN-680098 VARCHAR(1) 
   l_direct1       LIKE type_file.chr1,                 #Esc結束INPUT ARRAY 否  #No.FUN-680098 VARCHAR(1) 
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680098 SMALLINT
 
   LET g_action_choice = ""
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aca.aca01 IS NULL THEN
      RETURN
   END IF
 
   SELECT * INTO g_aca.* FROM aca_file WHERE aca01=g_aca.aca01
   IF g_aca.acaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aca.aca01,'aom-000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT acb02,acb03 FROM acb_file",
                      " WHERE acb01=? AND acb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_acb WITHOUT DEFAULTS FROM s_acb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
 
         OPEN i700_cl USING g_aca.aca01
         IF STATUS THEN
            CALL cl_err("OPEN i700_cl:", STATUS, 1)
            CLOSE i700_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i700_cl INTO g_aca.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i700_cl ROLLBACK WORK RETURN
         END IF
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_acb_t.* = g_acb[l_ac].*  #BACKUP
            OPEN i700_bcl USING g_aca.aca01,g_acb_t.acb02
            IF STATUS THEN
               CALL cl_err("OPEN i700_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i700_bcl INTO g_acb[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_acb_t.acb02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_acb[l_ac].* TO NULL      #900423
         INITIALIZE g_acb_t.* TO NULL      #900423
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD acb02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO acb_file(acb01,acb02,acb03)
         VALUES(g_aca.aca01,g_acb[l_ac].acb02,g_acb[l_ac].acb03)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_acb[l_ac].acb02,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","acb_file",g_aca.aca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD acb02                        #default 行序
         IF cl_null(g_acb[l_ac].acb02) OR
            g_acb[l_ac].acb02 = 0 THEN
               SELECT max(acb02)+1
                 INTO g_acb[l_ac].acb02
                 FROM acb_file
                WHERE acb01 = g_aca.aca01
               IF g_acb[l_ac].acb02 IS NULL THEN
                  LET g_acb[l_ac].acb02 = 1
               END IF
         END IF
 
      AFTER FIELD acb02                        #check 行序是否重複
         IF NOT cl_null(g_acb[l_ac].acb02) THEN
            IF g_acb[l_ac].acb02 != g_acb_t.acb02 OR g_acb_t.acb02 IS NULL THEN
               SELECT count(*) INTO l_n FROM acb_file
                WHERE acb01 = g_aca.aca01
                  AND acb02 = g_acb[l_ac].acb02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_acb[l_ac].acb02 = g_acb_t.acb02
                  NEXT FIELD acb02
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_acb_t.acb02 > 0 AND g_acb_t.acb02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM acb_file
             WHERE acb01 = g_aca.aca01
               AND acb02 = g_acb_t.acb02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_acb_t.acb02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","acb_file",g_acb_t.acb02,g_aca.aca01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_acb[l_ac].* = g_acb_t.*
            CLOSE i700_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_acb[l_ac].acb02,-263,1)
            LET g_acb[l_ac].* = g_acb_t.*
         ELSE
            UPDATE acb_file SET acb02 = g_acb[l_ac].acb02,
                                acb03 = g_acb[l_ac].acb03
             WHERE acb01=g_aca.aca01 AND acb02=g_acb_t.acb02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_acb[l_ac].acb02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","acb_file",g_aca.aca01,g_acb_t.acb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_acb[l_ac].* = g_acb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_acb[l_ac].* = g_acb_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_acb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i700_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i700_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i700_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(acb02) AND l_ac > 1 THEN
            LET g_acb[l_ac].* = g_acb[l_ac-1].*
            LET g_acb[l_ac].acb02 = NULL   #TQC-620018
            NEXT FIELD acb02
         END IF
 
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end  
 
      END INPUT
      UPDATE aca_file SET acamodu=g_user,acadate=g_today
       WHERE aca01=g_aca.aca01
 
   CLOSE i700_bcl
   COMMIT WORK
   CALL i700_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i700_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM aca_file WHERE aca01 = g_aca.aca01
         INITIALIZE g_aca.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i700_b_askkey()
DEFINE
#  l_wc2         VARCHAR(200)
   l_wc2           STRING        #TQC-630166   
 
   CLEAR FORM                            #清除FORMONLY欄位
   CALL g_acb.clear()
   CONSTRUCT l_wc2 ON acb02,acb03
           FROM s_acb[1].acb02,s_acb[1].acb03
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
   CALL i700_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#  p_wc2          VARCHAR(200)
   p_wc2          STRING        #TQC-630166    
 
   LET g_sql = "SELECT acb02,acb03 ",
               "  FROM acb_file",
               " WHERE acb01 ='",g_aca.aca01,"'"
   #No.FUN-8B0123---Begin
   #           "' AND ", p_wc2 CLIPPED,
   #           " ORDER BY 2"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY 2 " 
   DISPLAY g_sql
   #No.FUN-8B0123---End
 
   PREPARE i700_pb FROM g_sql
   DECLARE acb_curs                       #SCROLL CURSOR
       CURSOR FOR i700_pb
 
   CALL g_acb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH acb_curs INTO g_acb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_acb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_acb TO s_acb.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
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
         CALL cl_set_field_pic("","","","","",g_aca.acaacti)
 
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i700_copy()
DEFINE
    l_aca		RECORD LIKE aca_file.*,
    l_oldno,l_newno	LIKE aca_file.aca01
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aca.aca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i700_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT l_newno FROM aca01
        AFTER FIELD aca01
            IF l_newno IS NULL THEN
                NEXT FIELD aca01
            END IF
            SELECT count(*) INTO g_cnt FROM aca_file
                WHERE aca01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD aca01
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
        DISPLAY BY NAME g_aca.aca01
        RETURN
    END IF
    LET l_aca.* = g_aca.*
    LET l_aca.aca01  =l_newno   #新的鍵值
    LET l_aca.acauser=g_user    #資料所有者
    LET l_aca.acagrup=g_grup    #資料所有者所屬群
    LET l_aca.acamodu=NULL      #資料修改日期
    LET l_aca.acadate=g_today   #資料建立日期
    LET l_aca.acaacti='Y'       #有效資料
    LET l_aca.acaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aca.acaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aca_file VALUES (l_aca.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('aca:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","aca_file",l_aca.aca01,"",SQLCA.sqlcode,"","aca:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM acb_file         #單身複製
        WHERE acb01=g_aca.aca01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_aca.aca01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","x",g_aca.aca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        RETURN
    END IF
    UPDATE x
        SET acb01=l_newno
    INSERT INTO acb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('acb:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","acb_file",l_newno,"",SQLCA.sqlcode,"","acb:",1)  #No.FUN-660123
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_aca.aca01
     SELECT aca_file.* INTO g_aca.* FROM aca_file WHERE aca01 = l_newno
     CALL i700_u()
     CALL i700_b()
     #SELECT aca_file.* INTO g_aca.* FROM aca_file WHERE aca01 = l_oldno  #FUN-C30027
     #CALL i700_show()  #FUN-C30027
END FUNCTION
 
FUNCTION i700_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aca01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i700_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aca01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i700_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
    l_name          LIKE type_file.chr20,         #External(Disk) file name        #No.FUN-680098  VARCHAR(20)
    l_msg           LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(22)  
    l_za05          LIKE za_file.za05,            #No.FUN-680098  VARCHAR(40)
    sr              RECORD
        aca01       LIKE aca_file.aca01,   #類別編號
        aca02       LIKE aca_file.aca02,   #類別名稱
        aca03       LIKE aca_file.aca03,   #產生順序
        l_acb       RECORD LIKE acb_file.*,
        acaacti     LIKE aca_file.acaacti
                    END RECORD
 
    IF g_wc IS NULL THEN
      # CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    #CALL cl_outnam('agli700') RETURNING l_name         #No.FUN-760085
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli700'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql=" SELECT aca01,aca02,aca03,acb_file.*,acaacti",
          " FROM aca_file,acb_file",
          " WHERE  ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED,
          " ORDER BY 1,4 "
    CALL cl_wait()
    #No.FUN-760085---Begin
    #PREPARE i700_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE i700_co CURSOR FOR i700_p1
 
    #START REPORT i700_rep TO l_name
 
    #FOREACH i700_co INTO sr.*
    #   IF SQLCA.sqlcode THEN
    #      CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #      EXIT FOREACH
    #   END IF
    #   IF sr.aca01 IS NULL THEN LET sr.aca01 = ' ' END IF
    #   OUTPUT TO REPORT i700_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT i700_rep
 
    #CLOSE i700_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'aca01,aca02,aca03 ')                                           
            RETURNING g_wc                                                                                                          
       LET g_str = g_wc                                                                                                             
    END IF                                                                                                                          
    LET g_str = g_wc     
    CALL cl_prt_cs1('agli700','agli700',g_sql,g_str)
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i700_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    l_sw            LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    l_line          LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    l_str           LIKE type_file.chr20,         #No.FUN-680098  VARCHAR(10)
    l_acb06         LIKE type_file.chr4,          #No.FUN-680098  VARCHAR(4)
    sr              RECORD
        aca01       LIKE aca_file.aca01,   #類別編號
        aca02       LIKE aca_file.aca02,   #類別名稱
        aca03       LIKE aca_file.aca03,   #產生順序
        l_acb       RECORD LIKE acb_file.*,
        acaacti     LIKE aca_file.acaacti
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.aca01,sr.l_acb.acb02
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED    # No.TQC-750022
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            #PRINT g_x[2] CLIPPED,g_today USING 'yy/mm/dd',' ',TIME, #FUN-570250 mark
            PRINT g_x[2] CLIPPED,g_today,' ',TIME, #FUN-570250 add
                COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED, COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'    # No.TQC-750022
            PRINT g_dash[1,g_len]
            PRINT g_x[11] CLIPPED,COLUMN 13,g_x[12] CLIPPED,
                  COLUMN 47,g_x[13] CLIPPED,COLUMN 59,g_x[14] CLIPPED,COLUMN 75,g_x[20]   # No.TQC-750022
            PRINT '--------    ------------------------------    --------    ',
                  '------------    ------'                                                # No.TQC-750022
            PRINT sr.aca01,COLUMN 13,sr.aca02,COLUMN 47,sr.aca03,COLUMN 75,sr.acaacti     # No.TQC-750022
            PRINT  l_str CLIPPED
            SKIP  1 LINE
            PRINT COLUMN 38,g_x[18] CLIPPED,COLUMN 50,g_x[19] CLIPPED
            PRINT COLUMN 38,"----        ------------------------------"
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.aca01
        IF (PAGENO > 1 OR LINENO > 9)
           THEN SKIP TO TOP OF PAGE
        END IF
 
        ON EVERY ROW
           PRINT COLUMN 36,sr.l_acb.acb02,
                 COLUMN 50,sr.l_acb.acb03 CLIPPED
 
ON LAST ROW
      IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
         THEN PRINT g_dash[1,g_len]
              #TQC-630166
              #IF g_wc[001,070] > ' ' THEN			# for 80
	      #	 PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
              #IF g_wc[071,140] > ' ' THEN
	      #	 PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
              #IF g_wc[141,210] > ' ' THEN
	      #	 PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
              #IF g_wc[211,280] > ' ' THEN
	      #	 PRINT COLUMN 10,     g_wc[211,280] CLIPPED END IF
              CALL cl_prt_pos_wc(g_wc)
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
       LET l_trailer_sw = 'n'
 
PAGE TRAILER
      IF l_trailer_sw = 'y' THEN
          PRINT g_dash[1,g_len]
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-760085---End
#Patch....NO.TQC-610035 <001> #
