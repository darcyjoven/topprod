# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi403.4gl
# Descriptions...: 編碼獨立段資料維護作業
# Date & Author..: 03/06/25 By Carrier
# Modi...........: No.A086 03/11/26 By ching append
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510027 05/01/14 By pengu 報表轉XML
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/15 By Lynn 打印無效資料，報表中未體現出
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/12 By mike 報表格式修改為p_query
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-930127 09/03/18 By Sunyanchun 點擊“查詢”功能鈕，單頭“獨立段編號”欄位需要開窗查詢
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_gej           RECORD LIKE gej_file.*,
    g_gej_t         RECORD LIKE gej_file.*,
    g_gej_o         RECORD LIKE gej_file.*,
    g_gej01_t       LIKE gej_file.gej01,
    g_gek           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gek02       LIKE gek_file.gek02,
        gek03       LIKE gek_file.gek03,
        gek04       LIKE gek_file.gek04
                    END RECORD,
    g_gek_t         RECORD                     #程式變數 (舊值)
        gek02       LIKE gek_file.gek02,
        gek03       LIKE gek_file.gek03,
        gek04       LIKE gek_file.gek04
                    END RECORD,
    g_wc,g_wc2,g_sql  STRING,#TQC-630166    
    #l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE   g_before_input_done   LIKE type_file.num5      #No.FUN-680102 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE   g_chr           LIKE gej_file.gejacti        #No.FUN-680102 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680102CHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10,        #No.FUN-680102 INTEGER
         mi_no_ask      LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
MAIN
#DEFINE                                           #No.FUN-6A0081
#       l_time    LIKE type_file.chr8             #No.FUN-6A0081
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680102 SMALLINT
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
   LET p_row = 3 LET p_col = 4
   OPEN WINDOW i403_w AT p_row,p_col              #顯示畫面
     WITH FORM "aoo/42f/aooi403"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   LET g_forupd_sql = "SELECT * FROM gej_file WHERE gej01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i403_cl CURSOR FROM g_forupd_sql
 
   #CALL g_x.clear()
 
   CALL i403_menu()
 
   CLOSE WINDOW i403_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
END MAIN
 
FUNCTION i403_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_gek.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_gej.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON gej01,gej02,gej03,gejuser,gejgrup,gejmodu,gejdate,gejacti
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      #NO.TQC-930127----begin----------------
      ON ACTION controlp
         IF INFIELD(gej01) THEN
            CALL cl_init_qry_var() 
            LET g_qryparam.state = 'c'
            LET g_qryparam.form ="q_gej"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO gej01
            NEXT FIELD gej01
         END IF
      #NO.TQC-930127----end-----------
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
 
   IF INT_FLAG THEN RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND gejuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND gejgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND gejgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gejuser', 'gejgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON gek02,gek03,gek04        # 螢幕上取單身條件
            FROM s_gek[1].gek02,s_gek[1].gek03,s_gek[1].gek04
 
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
      LET g_sql = "SELECT  gej01 FROM gej_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE gej_file. gej01 ",
                  "  FROM gej_file, gek_file ",
                  " WHERE gej01 = gek01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE i403_prepare FROM g_sql
   DECLARE i403_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i403_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM gej_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT gej01) FROM gej_file,gek_file WHERE ",
                 "gek01=gej01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i403_precount FROM g_sql
   DECLARE i403_count CURSOR FOR i403_precount
   # 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN i403_count
   FETCH i403_count INTO g_row_count
   CLOSE i403_count
 
END FUNCTION
 
FUNCTION i403_menu()
 DEFINE l_cmd   LIKE type_file.chr1000               #No.FUN-780056 
   WHILE TRUE
      CALL i403_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i403_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i403_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i403_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i403_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i403_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i403_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i403_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN #CALL i403_out()                                  #No.FUN-780056
                    IF cl_null(g_wc) THEN LET g_wc='1=1' END IF       #No.FUN-780056
                    LET l_cmd='p_query "aooi403" "',g_wc CLIPPED,'"'  #No.FUN-780056
                    CALL cl_cmdrun(l_cmd)                             #No.FUN-780056
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gej.gej01 IS NOT NULL THEN
                  LET g_doc.column1 = "gej01"
                  LET g_doc.value1 = g_gej.gej01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gek),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i403_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gek.clear()
    INITIALIZE g_gej.* LIKE gej_file.*             #DEFAULT 設定
    LET g_gej01_t = NULL
    #預設值及將數值類變數清成零
    LET g_gej_o.* = g_gej.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gej.gejuser=g_user
        LET g_gej.gejoriu = g_user #FUN-980030
        LET g_gej.gejorig = g_grup #FUN-980030
        LET g_gej.gejgrup=g_grup
        LET g_gej.gejdate=g_today
        LET g_gej.gejacti='Y'              #資料有效
        CALL i403_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_gej.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gej.gej01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO gej_file VALUES (g_gej.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_gej.gej01,SQLCA.sqlcode,1)   #No.FUN-660131
            CALL cl_err3("ins","gej_file",g_gej.gej01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT gej01 INTO g_gej.gej01 FROM gej_file
         WHERE gej01 = g_gej.gej01
        LET g_gej01_t = g_gej.gej01        #保留舊值
        LET g_gej_t.* = g_gej.*
 
        CALL g_gek.clear()
        LET g_rec_b = 0
        CALL i403_b()                   #輸入單身
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i403_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_gej.gej01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_gej.* FROM gej_file WHERE gej01=g_gej.gej01
    IF g_gej.gejacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_gej.gej01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gej01_t = g_gej.gej01
    LET g_gej_o.* = g_gej.*
    BEGIN WORK
 
    OPEN i403_cl USING g_gej.gej01
    IF STATUS THEN
       CALL cl_err("OPEN i403_cl:", STATUS, 1)
       CLOSE i403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i403_cl INTO g_gej.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gej.gej01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE i403_cl ROLLBACK WORK RETURN
    END IF
    CALL i403_show()
    WHILE TRUE
        LET g_gej01_t = g_gej.gej01
        LET g_gej.gejmodu=g_user
        LET g_gej.gejdate=g_today
        CALL i403_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gej.*=g_gej_t.*
            CALL i403_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_gej.gej01 != g_gej01_t THEN            # 更改單號
            UPDATE gek_file SET gek01 = g_gej.gej01
             WHERE gek01 = g_gej01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('gek',SQLCA.sqlcode,0)    #No.FUN-660131
                CALL cl_err3("upd","gek_file",g_gej01_t,"",SQLCA.sqlcode,"","gek",1)  #No.FUN-660131
                CONTINUE WHILE 
           END IF
        END IF
        UPDATE gej_file SET gej_file.* = g_gej.*
         WHERE gej01 = g_gej.gej01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","gej_file",g_gej.gej01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i403_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i403_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5                  #No.FUN-680102 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   INPUT BY NAME g_gej.gej01,g_gej.gej02,g_gej.gej03,g_gej.gejuser, g_gej.gejoriu,g_gej.gejorig,
                 g_gej.gejgrup,g_gej.gejmodu,g_gej.gejdate,g_gej.gejacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i403_set_entry(p_cmd)
         CALL i403_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gej01                  #獨立段編號
         IF NOT cl_null(g_gej.gej01) THEN
            IF g_gej.gej01 != g_gej01_t OR cl_null(g_gej01_t) THEN
               SELECT COUNT(*) INTO g_cnt FROM gej_file
                WHERE gej01 = g_gej.gej01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_gej.gej01,-239,0)
                  LET g_gej.gej01 = g_gej01_t
                  DISPLAY BY NAME g_gej.gej01
                  NEXT FIELD gej01
               END IF
            END IF
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_gej.gejuser = s_get_data_owner("gej_file") #FUN-C10039
         LET g_gej.gejgrup = s_get_data_group("gej_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
 
FUNCTION i403_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("gej01",TRUE)
      END IF
 
END FUNCTION
 
FUNCTION i403_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("gej01",FALSE)
      END IF
 
END FUNCTION
 
FUNCTION i403_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_gej.* TO NULL              #No.FUN-6A0015
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_gek.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i403_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i403_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gej.* TO NULL
    ELSE
        OPEN i403_count
        FETCH i403_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i403_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i403_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    ls_jump         LIKE ze_file.ze03
 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i403_cs INTO g_gej.gej01
        WHEN 'P' FETCH PREVIOUS i403_cs INTO g_gej.gej01
        WHEN 'F' FETCH FIRST    i403_cs INTO g_gej.gej01
        WHEN 'L' FETCH LAST     i403_cs INTO g_gej.gej01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED || ': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i403_cs INTO g_gej.gej01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)
        INITIALIZE g_gej.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_gej.* FROM gej_file WHERE gej01 = g_gej.gej01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("sel","gej_file",g_gej.gej01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        INITIALIZE g_gej.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0044權限控管
       LET g_data_owner=g_gej.gejuser
       LET g_data_group=g_gej.gejgrup
    END IF
 
    CALL i403_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i403_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
    LET g_gej_t.* = g_gej.*                      #保存單頭舊值
    DISPLAY BY NAME g_gej.gej01,g_gej.gej02,g_gej.gej03,g_gej.gejuser, g_gej.gejoriu,g_gej.gejorig,
                    g_gej.gejgrup,g_gej.gejmodu,g_gej.gejdate,g_gej.gejacti
 
    CALL i403_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i403_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_gej.gej01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i403_cl USING g_gej.gej01
    IF STATUS THEN
       CALL cl_err("OPEN i403_cl:", STATUS, 1)
       CLOSE i403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i403_cl INTO g_gej.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i403_cl ROLLBACK WORK RETURN
    END IF
    CALL i403_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gej01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gej.gej01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM gej_file WHERE gej01 = g_gej.gej01
         DELETE FROM gek_file WHERE gek01 = g_gej.gej01
         INITIALIZE g_gej.* TO NULL
         CLEAR FORM
         CALL g_gek.clear()
         OPEN i403_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i403_cs
            CLOSE i403_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
           FETCH i403_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i403_cs
            CLOSE i403_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i403_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i403_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i403_fetch('/')
         END IF
    END IF
    CLOSE i403_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i403_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_gej.gej01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i403_cl USING g_gej.gej01
    IF STATUS THEN
       CALL cl_err("OPEN i403_cl:", STATUS, 1)
       CLOSE i403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i403_cl INTO g_gej.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i403_cl ROLLBACK WORK RETURN
    END IF
    CALL i403_show()
    IF cl_exp(0,0,g_gej.gejacti) THEN                   #確認一下
        LET g_chr=g_gej.gejacti
        IF g_gej.gejacti='Y' THEN
            LET g_gej.gejacti='N'
        ELSE
            LET g_gej.gejacti='Y'
        END IF
        UPDATE gej_file                    #更改有效碼
            SET gejacti=g_gej.gejacti
            WHERE gej01=g_gej.gej01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","gej_file",g_gej.gej01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_gej.gejacti=g_chr
        END IF
        DISPLAY BY NAME g_gej.gejacti
    END IF
    CLOSE i403_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i403_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    l_i,l_cnt       LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_gej03         LIKE gej_file.gej03,
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102    VARCHAR(1)           #可新增否
    l_allow_delete  LIKE type_file.chr1            #No.FUN-680102    VARCHAR(1)           #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_gej.gej01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT * INTO g_gej.* FROM gej_file WHERE gej01=g_gej.gej01
    IF g_gej.gejacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_gej.gej01,'aom-000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gek02,gek03,gek04 FROM gek_file",
                       " WHERE gek01=? AND gek02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i403_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gek WITHOUT DEFAULTS FROM s_gek.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           BEGIN WORK
           OPEN i403_cl USING g_gej.gej01
           IF STATUS THEN
              CALL cl_err("OPEN i403_cl:", STATUS, 1)
              CLOSE i403_cl
              ROLLBACK WORK
              RETURN
           ELSE
              FETCH i403_cl INTO g_gej.*            # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                 CLOSE i403_cl
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_gek_t.* = g_gek[l_ac].*  #BACKUP
              OPEN i403_bcl USING g_gej.gej01,g_gek_t.gek02
              IF STATUS THEN
                 CALL cl_err("OPEN i403_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i403_bcl INTO g_gek[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_gek_t.gek02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_gek[l_ac].* TO NULL      #900423
           LET g_gek_t.* = g_gek[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD gek02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO gek_file(gek01,gek02,gek03,gek04)
                VALUES (g_gej.gej01,g_gek[l_ac].gek02,g_gek[l_ac].gek03,
                        g_gek[l_ac].gek04)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_gek[l_ac].gek02,SQLCA.sqlcode,1)   #No.FUN-660131
              CALL cl_err3("ins","gek_file",g_gek[l_ac].gek02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD gek02                        #default 序號
           IF cl_null(g_gek[l_ac].gek02) OR g_gek[l_ac].gek02 = 0 THEN
              SELECT max(gek02)+1
                INTO g_gek[l_ac].gek02
                FROM gek_file
               WHERE gek01 = g_gej.gej01
              IF cl_null(g_gek[l_ac].gek02) THEN
                  LET g_gek[l_ac].gek02 = 1
              END IF
           END IF
 
        AFTER FIELD gek02                        #check 序號是否重複
           IF NOT cl_null(g_gek[l_ac].gek02) THEN
              IF g_gek[l_ac].gek02 != g_gek_t.gek02 OR cl_null(g_gek_t.gek02) THEN
                 SELECT COUNT(*) INTO l_n FROM gek_file
                  WHERE gek01 = g_gej.gej01
                    AND gek02 = g_gek[l_ac].gek02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gek[l_ac].gek02 = g_gek_t.gek02
                    NEXT FIELD gek02
                 END IF
              END IF
           END IF
 
        AFTER FIELD gek03
           IF NOT cl_null(g_gek[l_ac].gek03) THEN   # 重要欄位不可空白
              IF length(g_gek[l_ac].gek03) <> g_gej.gej03 THEN
                 CALL cl_err(g_gek[l_ac].gek03,'aoo-121',0)
                 NEXT FIELD gek03
              END IF
              IF g_gek[l_ac].gek03 MATCHES '*[*%_? ]*' THEN
                 CALL cl_err('','aoo-124',0)
                 NEXT FIELD gek03
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_gek_t.gek02 > 0 AND g_gek_t.gek02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM gek_file
               WHERE gek01 = g_gej.gej01
                 AND gek02 = g_gek_t.gek02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_gek_t.gek02,SQLCA.sqlcode,0)   #No.FUN-660131
                 CALL cl_err3("del","gek_file",g_gek_t.gek02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete Ok"
              CLOSE i403_bcl
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gek[l_ac].* = g_gek_t.*
              CLOSE i403_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gek[l_ac].gek02,-263,1)
              LET g_gek[l_ac].* = g_gek_t.*
           ELSE
              UPDATE gek_file SET gek02 = g_gek[l_ac].gek02,
                                  gek03 = g_gek[l_ac].gek03,
                                  gek04 = g_gek[l_ac].gek04
               WHERE gek01=g_gej.gej01
                 AND gek02=g_gek_t.gek02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_gek[l_ac].gek02,SQLCA.sqlcode,1)   #No.FUN-660131
                 CALL cl_err3("upd","gek_file",g_gej.gej01,g_gek_t.gek02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET g_gek[l_ac].* = g_gek_t.*
                 CLOSE i403_bcl
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i403_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D40030
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_gek[l_ac].* = g_gek_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_gek.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i403_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D40030
           CLOSE i403_bcl
           COMMIT WORK
 
## UnMark By Raymon
        ON ACTION CONTROLN
           CALL i403_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gek02) AND l_ac > 1 THEN
               LET g_gek[l_ac].* = g_gek[l_ac-1].*
               NEXT FIELD gek02
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
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
    END INPUT
 
   #start FUN-5B0136
    LET g_gej.gejmodu = g_user
    LET g_gej.gejdate = g_today
    UPDATE gej_file SET gejmodu = g_gej.gejmodu,gejdate = g_gej.gejdate
     WHERE gej01 = g_gej.gej01
    DISPLAY BY NAME g_gej.gejmodu,g_gej.gejdate
   #end FUN-5B0136
 
    CLOSE i403_bcl
    CLOSE i403_cl
    COMMIT WORK
    CALL i403_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i403_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM gej_file WHERE gej01 = g_gej.gej01
         INITIALIZE g_gej.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i403_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
 
    CONSTRUCT l_wc2 ON gek02,gek03,gek04
            FROM s_gek[1].gek02,s_gek[1].gek03,s_gek[1].gek04
 
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
 
    CALL i403_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i403_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
 
    LET g_sql = "SELECT gek02,gek03,gek04 ",
                "  FROM gek_file",
                " WHERE gek01 ='",g_gej.gej01,"'"  #單頭
    #No.FUN-8B0123---Begin
    #           "   AND ",p_wc2 CLIPPED,           #單身
    #           " ORDER BY gek02"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY gek02 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i403_pb FROM g_sql
    DECLARE gek_curs                       #SCROLL CURSOR
        CURSOR FOR i403_pb
 
     CALL g_gek.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH gek_curs INTO g_gek[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gek.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gek TO s_gek.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i403_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i403_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i403_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i403_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
display "i403_bp_refresh()"
      ON ACTION last
         CALL i403_fetch('L')
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
#     ON ACTION close
#        LET g_action_choice="exit"
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i403_copy()
DEFINE
    l_gej		RECORD LIKE gej_file.*,
    l_oldno,l_newno	LIKE gej_file.gej01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gej.gej01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i403_set_entry('a')
    CALL i403_set_no_entry('a')
    LET g_before_input_done = TRUE
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM gej01
 
        AFTER FIELD gej01
           IF NOT cl_null(l_newno) THEN
              SELECT count(*) INTO g_cnt FROM gej_file
               WHERE gej01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD gej01
              END IF
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
       DISPLAY BY NAME g_gej.gej01
       RETURN
    END IF
 
    LET l_gej.* = g_gej.*
    LET l_gej.gej01  =l_newno   #新的鍵值
    LET l_gej.gejuser=g_user    #資料所有者
    LET l_gej.gejgrup=g_grup    #資料所有者所屬群
    LET l_gej.gejmodu=NULL      #資料修改日期
    LET l_gej.gejdate=g_today   #資料建立日期
    LET l_gej.gejacti='Y'       #有效資料
    BEGIN WORK
    LET l_gej.gejoriu = g_user      #No.FUN-980030 10/01/04
    LET l_gej.gejorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO gej_file VALUES (l_gej.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('gej:',SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","gej_file",l_gej.gej01,"",SQLCA.sqlcode,"","gej:",1)  #No.FUN-660131
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM gek_file         #單身複製
        WHERE gek01=g_gej.gej01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gej.gej01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","x",g_gej.gej01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        RETURN
    END IF
    UPDATE x
        SET   gek01=l_newno
    INSERT INTO gek_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('gek:',SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","gek_file","","",SQLCA.sqlcode,"","gek:",1)  #No.FUN-660131
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_gej.gej01
     SELECT gej_file.* INTO g_gej.* FROM gej_file WHERE gej01 = l_newno
     CALL i403_u()
     CALL i403_b()
     #SELECT gej_file.* INTO g_gej.* FROM gej_file WHERE gej01 = l_oldno  #FUN-C80046
     #CALL i403_show()  #FUN-C80046
END FUNCTION
 
#No.FUN-780056 --str
#FUNCTION i403_out()
#DEFINE
#    l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
#    sr              RECORD
#        gej01       LIKE gej_file.gej01,   #獨立段編號
#        gej02       LIKE gej_file.gej02,   #名稱
#        gej03       LIKE gej_file.gej03,   #長度
#        gejacti     LIKE gej_file.gejacti, # No.TQC-750041
#        gek02       LIKE gek_file.gek02,   #項次
#        gek03       LIKE gek_file.gek03,   #編碼編號
#        gek04       LIKE gek_file.gek04    #編碼名稱
#                    END RECORD,
#        l_name      LIKE type_file.chr20                #External(Disk) file name        #No.FUN-680102 VARCHAR(20)
#
#    IF cl_null(g_wc) THEN
#       LET g_wc=" gej01='",g_gej.gej01,"'"
#       LET g_wc2=" gek01='",g_gej.gej01,"'"
#    END IF
#
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT gej01,gej02,gej03,gejacti,gek02,gek03,gek04 ",      # No.TQC-750041
#              "  FROM gej_file,gek_file",
#              " WHERE gej01 = gek01 AND ",g_wc CLIPPED,
#              "   AND ",g_wc2 CLIPPED,
#              " ORDER BY gej01,gek02 "
#    PREPARE i403_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i403_co                         # SCROLL CURSOR
#         CURSOR FOR i403_p1
#
#    CALL cl_outnam('aooi403') RETURNING l_name
#    START REPORT i403_rep TO l_name
#
#    FOREACH i403_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#           EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i403_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i403_rep
#
#    CLOSE i403_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i403_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
#    l_sw            LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
#    l_i             LIKE type_file.num5,           #No.FUN-680102 SMALLINT
#    sr              RECORD
#        gej01       LIKE gej_file.gej01,   #獨立段編號
#        gej02       LIKE gej_file.gej02,   #名稱
#        gej03       LIKE gej_file.gej03,   #長度
#        gejacti     LIKE gej_file.gejacti, # No.TQC-750041
#        gek02       LIKE gek_file.gek02,   #項次
#        gek03       LIKE gek_file.gek03,   #編碼編號
#        gek04       LIKE gek_file.gek04    #編碼名稱
#                    END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.gej01,sr.gek02
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED       # No.TQC-750041
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.gej01
#            PRINT COLUMN g_c[31],sr.gej01 CLIPPED,
#                  COLUMN g_c[32],sr.gej02 CLIPPED,
#                  COLUMN g_c[33],sr.gej03 USING "##";
# 
#        ON EVERY ROW
#           PRINT COLUMN g_c[34],sr.gek03 CLIPPED,
#                 COLUMN g_c[35],sr.gek04 CLIPPED,
#                 COLUMN g_c[36],sr.gejacti CLIPPED      # No.TQC-750041
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc,'gej01,gej02,gej03')
#                    RETURNING g_sql
#            #TQC-630166
#             {
#               IF g_sql[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               IF g_sql[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               IF g_sql[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#             }
#              CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#               PRINT g_dash[1,g_len]
#            END IF
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-780056 -end
 
 

