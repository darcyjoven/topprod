# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: p_flow.4gl
# Descriptions...: 流程資料維護作業
# Date & Author..: 03/06/05 alex
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-4C0024 04/12/06 By Smapmin 刪除後將單身清空
# Modify.........: No.FUN-4C0040 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.MOD-540140 05/04/20 By alex 修改 controlf 寫法
# Modify.........: No.MOD-540192 05/05/06 By pengu 修改p_flow_gag03()函數
# Modify.........: No.FUN-4A0081 05/07/12 By saki By單別發送信件
# Modify.........: No.MOD-580056 05/08/17 By yiting key值可更改
# Modify.........: No.MOD-560114 05/10/17 By alex 修改 controlp q_zz error
# Modify.........: No.TQC-5A0092 05/07/20 By alex 修改顯示設定為 g_win_style
# Modify.........: No.TQC-5A0126 05/10/31 By saki 設定寄送條件及建議執行功能的預設值
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-730022 07/03/06 By rainy 單頭新增一欄位gaf04是否由流程自動產生
#                                                  新增接收參數
# Modify.........: No.TQC-6B0105 07/03/09 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: NO.MOD-840261 08/04/21 By saki 收件者直接輸入要帶出mail位置
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.FUN-960113 09/06/19 By Dido 取消複製功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
 
DEFINE
    g_gaf           RECORD LIKE gaf_file.*,   #
    g_gaf_t         RECORD LIKE gaf_file.*,   # 舊值
    g_gaf_o         RECORD LIKE gaf_file.*,   # 舊值
    g_gaf01_t       LIKE gaf_file.gaf01,      # 舊值
    g_gag           DYNAMIC ARRAY of RECORD   # 程式變數(Program Variables)
        gag02       LIKE gag_file.gag02,      # 序號
        gag03       LIKE gag_file.gag03,      # 程式代號
        gaz03       LIKE gaz_file.gaz03,      # 程式名稱    #TQC-5A0092
        gag04       LIKE gag_file.gag04,      # 功能類別
        gag14       LIKE gag_file.gag14,      # 寄送mail條件 No.FUN-4A0081
        gag17       LIKE gag_file.gag17,      # 條件內容     No.FUN-4A0081
        gag05       LIKE gag_file.gag05,      # Mail通知
        gag11       LIKE gag_file.gag11,      # 指定處理人員
        gag06       LIKE gag_file.gag06,      # Mail收件者清單
        gag07       LIKE gag_file.gag07,      # Mail副本清單
        gag08       LIKE gag_file.gag08,      # 訊息內容
        gag09       LIKE gag_file.gag09,      # 建議執行程式代號
        gaz03_2     LIKE gaz_file.gaz03,      # 指令名稱     #TQC-5A0092
        gag15       LIKE gag_file.gag15,      # 建議執行功能 No.FUN-4A0081
        gag10       LIKE gag_file.gag10,      # 等級
        gag12       LIKE gag_file.gag12,      # 逾期天數
        gag13       LIKE gag_file.gag13       # 逾期Mail清單
                    END RECORD,
    g_gag_t         RECORD                    # 程式變數 (舊值)
        gag02       LIKE gag_file.gag02,      # 序號
        gag03       LIKE gag_file.gag03,      # 程式代號
        gaz03       LIKE gaz_file.gaz03,      # 程式名稱    #TQC-5A0092
        gag04       LIKE gag_file.gag04,      # 功能類別
        gag14       LIKE gag_file.gag14,      # 寄送mail條件 No.FUN-4A0081
        gag17       LIKE gag_file.gag17,      # 條件內容     No.FUN-4A0081
        gag05       LIKE gag_file.gag05,      # Mail通知
        gag11       LIKE gag_file.gag11,      # 指定處理人員
        gag06       LIKE gag_file.gag06,      # Mail收件者清單
        gag07       LIKE gag_file.gag07,      # Mail副本清單
        gag08       LIKE gag_file.gag08,      # 訊息內容
        gag09       LIKE gag_file.gag09,      # 建議執行程式代號
        gaz03_2     LIKE gaz_file.gaz03,      # 指令名稱     #TQC-5A0092
        gag15       LIKE gag_file.gag15,      # 建議執行功能 No.FUN-4A0081
        gag10       LIKE gag_file.gag10,      # 等級
        gag12       LIKE gag_file.gag12,      # 逾期天數
        gag13       LIKE gag_file.gag13       #,逾期Mail清單
                    END RECORD,
    g_argv1         LIKE gaf_file.gaf01,      #參數1 #TQC-730022
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5,  # 單身筆數  #No.FUN-680135 SMALLINT
    l_ac                LIKE type_file.num5   # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
#   l_sl                SMALLINT              # #TQC-5A0092
DEFINE g_curs_index     LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_row_count      LIKE type_file.num10  #No.FUN-580092 HCN     #No.FUN-680135 INTEGER
DEFINE g_jump           LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE g_chr            LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_msg            LIKE type_file.chr1000#No.FUN-680135 VARCHAR(72)
DEFINE g_forupd_sql     STRING
DEFINE g_before_input_done   LIKE type_file.num5    #NO.MOD-580056   #No.FUN-680135 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0096
 
   OPTIONS                                    # 改變一些系統預設值
 
        INPUT NO WRAP
   DEFER INTERRUPT                           # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 =ARG_VAL(1)             #TQC-730022
   CALL  cl_used(g_prog,g_time,1)           # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW p_flow_w WITH FORM "azz/42f/p_flow"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)    #TQC-5A0092
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = " SELECT * FROM gaf_file  WHERE gaf01 = ? ", #g_gaf.gaf01
                          " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_flow_cl CURSOR FROM g_forupd_sql
 
 #TQC-720033
  IF NOT cl_null(g_argv1) THEN
     CALL p_flow_q()
     CALL p_flow_b()
  END IF
 #TQC-720033--end
   CALL p_flow_menu()
 
   CLOSE WINDOW p_flow_w                     # 結束畫面
   CALL  cl_used(g_prog,g_time,2)           # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_flow_cs()                          # QBE 查詢資料
 
    CLEAR FORM                                # 清除畫面
    CALL g_gag.clear()                        #No.FUN-4A0081
 
  #TQC-730022 add
   IF NOT cl_null(g_argv1) THEN   
      LET g_wc = " gaf01 = '",g_argv1 CLIPPED, "'"
      LET g_wc2 = " 1=1"
   ELSE
  #TQC-730022 end
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT BY NAME g_wc ON                 # 螢幕上取單頭條件
                gaf01,gaf02,gaf04,gaf03   #TQC-730022 add gaf04
#No.TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE CONSTRUCT
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gafuser', 'gafgrup') #FUN-980030
#TQC-860017 end
 
      IF INT_FLAG THEN RETURN END IF
 
      #資料權限的檢查
#     IF g_priv2='4' THEN                       # 只能使用自己的資料
#         LET g_wc = g_wc clipped," AND gafuser = '",g_user,"'"
#     END IF
 
#     IF g_priv3='4' THEN                       # 只能使用相同群的資料
#         LET g_wc = g_wc clipped," AND gafgrup MATCHES '",g_grup CLIPPED,"*'"
#     END IF
 
#     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#         LET g_wc = g_wc clipped," AND gafgrup IN ",cl_chk_tgrup_list()
#     END IF
      CONSTRUCT g_wc2 ON gag03,gag04,gag14,gag17,gag05,gag11,gag06,  # 螢幕上取單身條件
                         gag07,gag08,gag09,gag15,gag10,gag12,gag13         #No.FUN-4A0081
              FROM s_gag[1].gag03,s_gag[1].gag04,s_gag[1].gag14,s_gag[1].gag17,
                   s_gag[1].gag05,s_gag[1].gag11,s_gag[1].gag06,s_gag[1].gag07,
                   s_gag[1].gag08,s_gag[1].gag09,s_gag[1].gag15,s_gag[1].gag10,
                   s_gag[1].gag12,s_gag[1].gag13
 
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(gag03)    #MOD-560114
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.default1 = g_gag[1].gag03
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.state ="c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO g_gag[1].gag03
                   NEXT FIELD gag03
 
                WHEN INFIELD(gag09)    #MOD-560114
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.default1 = g_gag[1].gag09
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.state ="c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO g_gag[1].gag09
                   NEXT FIELD gag09
 
                WHEN INFIELD(gag11)
                   CALL s_usermail(TRUE,TRUE,g_gag[1].gag11,g_gag[1].gag06,TRUE)
                        RETURNING g_gag[1].gag11,g_gag[1].gag06
                   DISPLAY g_gag[1].gag11,g_gag[1].gag06 TO gag11,gag06
                   NEXT FIELD gag11
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
 
      END CONSTRUCT
 
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT  gaf01 FROM gaf_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY 1"
    ELSE					# 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE  gaf01 ",
                    "  FROM gaf_file, gag_file ",
                    " WHERE gaf01 = gag01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY 1"
    END IF
 
    PREPARE p_flow_prepare FROM g_sql
    DECLARE p_flow_cs SCROLL CURSOR WITH HOLD FOR p_flow_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM gaf_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT gaf01) FROM gaf_file,gag_file WHERE ",
                  "gag01=gaf01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE p_flow_precount FROM g_sql
    DECLARE p_flow_count CURSOR FOR p_flow_precount
 
END FUNCTION
 
FUNCTION p_flow_menu()                           # 中文的MENU
 
 
    WHILE TRUE
        CALL p_flow_bp("G")
        CASE g_action_choice
            WHEN "insert"     # A.輸入
                 IF cl_chk_act_auth() THEN
                    CALL p_flow_a()
                 END IF
            WHEN "query"      # Q.查詢
                 IF cl_chk_act_auth() THEN
                    CALL p_flow_q()
                 END IF
            WHEN "modify"     # U.更改
                 IF cl_chk_act_auth() THEN
                    CALL p_flow_u()
                 END IF
            WHEN "invalid"       # X.無效
                 IF cl_chk_act_auth() THEN
                    CALL p_flow_x()
                 END IF
            WHEN "delete"     # R.取消
                 IF cl_chk_act_auth() THEN
                    CALL p_flow_r()
                 END IF
            WHEN "detail" # B.單身
                 IF cl_chk_act_auth() THEN
                    CALL p_flow_b()
                 ELSE
                    LET g_action_choice = NULL
                 END IF
           #-FUN-960113-add-
           #WHEN "reproduce"  # C.複製
           #     IF cl_chk_act_auth() THEN
           #        CALL p_flow_copy()
           #     END IF
           #-FUN-960113-end-
            WHEN "help"       # H.說明
                 CALL cl_show_help()
            WHEN "exit"       # Esc.結束
                 EXIT WHILE
            WHEN "controln"   # KEY(CONTROL-N)
                 CALL p_flow_bp('N')
            WHEN "controlg"   # KEY(CONTROL-G)
                 CALL cl_cmdask()
            WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gag),'','')
            END IF
        END CASE
    END WHILE
END FUNCTION
 
FUNCTION p_flow_a()                                #Add  輸入
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gag.clear()
    #預設值及將數值類變數清成零
    INITIALIZE g_gaf.* LIKE gaf_file.*             #DEFAULT 設定
    LET g_gaf01_t = NULL
    LET g_gaf_o.* = g_gaf.*
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET g_gaf.gafuser=g_user
        LET g_gaf.gaforiu = g_user #FUN-980030
        LET g_gaf.gaforig = g_grup #FUN-980030
        LET g_gaf.gafgrup=g_grup
        LET g_gaf.gafdate=g_today
        LET g_gaf.gafacti='Y'              #資料有效
 
        CALL p_flow_i("a")                 #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_gaf.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        IF g_gaf.gaf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO gaf_file VALUES (g_gaf.*)
        IF SQLCA.SQLCODE THEN   			#置入資料庫不成功
            #CALL cl_err(g_gaf.gaf01,SQLCA.SQLCODE,1)  #No.FUN-660081
            CALL cl_err3("ins","gaf_file",g_gaf.gaf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
            CONTINUE WHILE
        END IF
        SELECT gaf01 INTO g_gaf.gaf01 FROM gaf_file
         WHERE gaf01 = g_gaf.gaf01
        LET g_gaf01_t = g_gaf.gaf01        #保留舊值
        LET g_gaf_t.* = g_gaf.*
        CALL g_gag.clear()
        LET g_rec_b=0
        CALL p_flow_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION p_flow_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_gaf.gaf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_gaf.* FROM gaf_file WHERE gaf01=g_gaf.gaf01
    IF g_gaf.gafacti ='N' THEN                # 檢查資料是否為無效
       CALL cl_err(g_gaf.gaf01,9027,0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gaf01_t = g_gaf.gaf01
    LET g_gaf_o.* = g_gaf.*
 
    BEGIN WORK
    OPEN p_flow_cl USING g_gaf.gaf01
    IF STATUS THEN
       CALL cl_err("OPEN p_flow_cl:", STATUS, 1)
       CLOSE p_flow_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_flow_cl INTO g_gaf.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err("FETCH p_flow_cl:", STATUS, 1)     # 資料被他人LOCK
        CLOSE p_flow_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    CALL p_flow_show()
 
    WHILE TRUE
        LET g_gaf01_t = g_gaf.gaf01
        LET g_gaf.gafmodu=g_user
        LET g_gaf.gafdate=g_today
        CALL p_flow_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gaf.*=g_gaf_t.*
            CALL p_flow_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_gaf.gaf01 != g_gaf01_t THEN            # 更改單號
            UPDATE gag_file SET gag01 = g_gaf.gaf01
                WHERE gag01 = g_gaf01_t
            IF SQLCA.sqlcode THEN
               #No.FUN-660091  --Begin
               #CALL cl_err('gag',SQLCA.sqlcode,0)
               CALL cl_err3("upd","gag_file",g_gaf01_t,"",SQLCA.sqlcode,"","gag",0)   #No.FUN-660081
               CONTINUE WHILE 
               #No.FUN-660091  --End  
            END IF
        END IF
 
        UPDATE gaf_file SET gaf_file.* = g_gaf.*
            WHERE gaf01 = g_gaf.gaf01
        IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gaf.gaf01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","gaf_file",g_gaf01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE p_flow_cl
    COMMIT WORK
END FUNCTION
 
 
 
FUNCTION p_flow_i(p_cmd)                   #處理INPUT
 
DEFINE l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入 #No.FUN-680135 VARCHAR(1)
       p_cmd           LIKE type_file.chr1      #a:輸入 u:更改          #No.FUN-680135 VARCHAR(1)
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
    INPUT BY NAME g_gaf.gaforiu,g_gaf.gaforig,
        g_gaf.gaf01,g_gaf.gaf02,g_gaf.gaf03,g_gaf.gafacti,
        g_gaf.gafuser,g_gaf.gafgrup,g_gaf.gafmodu,g_gaf.gafdate
         WITHOUT DEFAULTS HELP 1            # MOD-4B0109
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_flow_set_entry_i(p_cmd)
         CALL p_flow_set_no_entry_i(p_cmd)
         LET g_before_input_done = TRUE
         LET g_gaf.gaf04 = 'N'      #TQC-730022 add
         DISPLAY BY NAME g_gaf.gaf04
   #--------END
 
        AFTER FIELD gaf01                  #批次執行指令資料
            IF NOT cl_null(g_gaf.gaf01) THEN
               CALL p_flow_gaf01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_gaf.gaf01,g_errno,0)
                   NEXT FIELD gaf01
               END IF
            END IF
 
         ON ACTION CONTROLF             #欄位說明 MOD-540140
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION about
           CALL cl_about()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION p_flow_gaf01(p_cmd)
 
    DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
    LET g_errno = " "
 
    IF g_gaf.gaf01 != g_gaf01_t OR g_gaf01_t IS NULL THEN
        SELECT count(*) INTO g_cnt FROM gaf_file
         WHERE gaf01 = g_gaf.gaf01
        IF g_cnt > 0 THEN          #資料重複
            LET g_errno = "-239"
        END IF
    END IF
 
END FUNCTION
 
FUNCTION p_flow_q()            #Query 查詢
     LET g_row_count = 0 #No.FUN-580092 HCN
    LET g_curs_index = 0
     CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_gag.clear()         #No.FUN-4A0081
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL p_flow_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_gag.clear()
        RETURN
    END IF
    OPEN p_flow_count
     FETCH p_flow_count INTO g_row_count #No.FUN-580092 HCN
     DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA) #No.FUN-580092 HCN
    OPEN p_flow_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gaf.* TO NULL
    ELSE
        CALL p_flow_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION p_flow_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式    #No.FUN-680135 VARCHAR(1)
    l_abso          LIKE type_file.num10      #絕對的筆數  #No.FUN-680135 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_flow_cs INTO g_gaf.gaf01
        WHEN 'P' FETCH PREVIOUS p_flow_cs INTO g_gaf.gaf01
        WHEN 'F' FETCH FIRST    p_flow_cs INTO g_gaf.gaf01
        WHEN 'L' FETCH LAST     p_flow_cs INTO g_gaf.gaf01
        WHEN '/'
          IF (NOT mi_no_ask) THEN         #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION help
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
               ON ACTION about
                  CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
          END IF
          FETCH ABSOLUTE g_jump p_flow_cs INTO g_gaf.gaf01
          LET mi_no_ask = FALSE           #No.FUN-6A0080
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gaf.gaf01,SQLCA.sqlcode,0)
        INITIALIZE g_gaf.* TO NULL   #No.TQC-6B0105
        LET g_gaf.gaf01 = NULL       #No.TQC-6B0105
        RETURN
    ELSE
         CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
             WHEN 'L' LET g_curs_index = g_row_count #No.FUN-580092 HCN
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
    END IF
    SELECT * INTO g_gaf.* FROM gaf_file WHERE gaf01 = g_gaf.gaf01
    IF SQLCA.sqlcode THEN
        #CALL cl_err(g_gaf.gaf01,SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("sel","gaf_file",g_gaf.gaf01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
        INITIALIZE g_gaf.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0040權限控管
       LET g_data_owner=g_gaf.gafuser
       LET g_data_group=g_gaf.gafgrup
       CALL  p_flow_show()
    END IF
 
    CALL p_flow_show()
END FUNCTION
 
FUNCTION p_flow_show()                           # 將資料顯示在畫面上
 
    LET g_gaf_t.* = g_gaf.*                      # 保存單頭舊值
 
    DISPLAY BY NAME g_gaf.gaforiu,g_gaf.gaforig,                              # 顯示單頭值
        g_gaf.gaf01,  g_gaf.gaf02,  g_gaf.gaf03, g_gaf.gaf04,  #TQC-730022 add gaf04
        g_gaf.gafuser,g_gaf.gafgrup,g_gaf.gafmodu,
        g_gaf.gafdate,g_gaf.gafacti
 
    CALL p_flow_b_fill(g_wc2)                    # 單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION p_flow_x()                            # Change to nonactivity
 
#   IF s_shut(0) THEN RETURN END IF
    IF g_gaf.gaf01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN p_flow_cl USING g_gaf.gaf01
    IF STATUS THEN
        CALL cl_err("OPEN p_flow_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_flow_cl
        ROLLBACK WORK
        RETURN
    END IF
    FETCH p_flow_cl INTO g_gaf.*               # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err("FETCH p_flow_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_flow_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL p_flow_show()
    IF cl_exp(0,0,g_gaf.gafacti) THEN                   #確認一下
        LET g_chr=g_gaf.gafacti
        IF g_gaf.gafacti='Y' THEN
            LET g_gaf.gafacti='N'
        ELSE
            LET g_gaf.gafacti='Y'
        END IF
        UPDATE gaf_file                    #更改有效碼
            SET gafacti=g_gaf.gafacti
            WHERE gaf01=g_gaf.gaf01
        IF SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err(g_gaf.gaf01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","gaf_file",g_gaf.gaf01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
            LET g_gaf.gafacti=g_chr
        END IF
        DISPLAY BY NAME g_gaf.gafacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE p_flow_cl
    COMMIT WORK
END FUNCTION
 
# 取消整筆 (所有合乎單頭的資料)
FUNCTION p_flow_r()
 
#   IF s_shut(0) THEN RETURN END IF
    IF g_gaf.gaf01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_gaf.gaf04 = 'Y' THEN
        CALL cl_err('','azz-144',0)
        RETURN
    END IF 
 
    BEGIN WORK
    OPEN p_flow_cl USING g_gaf.gaf01
    IF STATUS THEN
        CALL cl_err("OPEN p_flow_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_flow_cl
        ROLLBACK WORK
        RETURN
    END IF
    FETCH p_flow_cl INTO g_gaf.*               # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err("FETCH p_flow_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_flow_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL p_flow_show()
    IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM gaf_file WHERE gaf01 = g_gaf.gaf01
         DELETE FROM gag_file WHERE gag01 = g_gaf.gaf01
         CLEAR FORM
         CALL g_gag.clear()  #MOD-4C0024
         OPEN p_flow_count
         #FUN-B50065-add-start--
         IF STATUS THEN
            CLOSE p_flow_cl
            CLOSE p_flow_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         FETCH p_flow_count INTO g_row_count #No.FUN-580092 HCN
         #FUN-B50065-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_flow_cl
            CLOSE p_flow_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
         OPEN p_flow_cs
         IF g_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
            LET g_jump = g_row_count #No.FUN-580092 HCN
            CALL p_flow_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE           #No.FUN-6A0080
            CALL p_flow_fetch('/')
         END IF
 
    END IF
    CLOSE p_flow_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION p_flow_b()                        #單身
 
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680135 VARCHAR(1)
    l_length        LIKE type_file.num5,                 #FUN-680135        SMALLINT #長度
    l_allow_insert  LIKE type_file.num5,                 #可新增否          #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #可刪除否          #No.FUN-680135 SMALLINT
 
    LET g_action_choice = " "
    IF s_shut(0) THEN RETURN END IF
    IF g_gaf.gaf01 IS NULL THEN
        RETURN
    END IF
 
    SELECT * INTO g_gaf.* FROM gaf_file WHERE gaf01=g_gaf.gaf01
    IF g_gaf.gafacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_gaf.gaf01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gag02,gag03,'',gag04,gag14,gag17,gag05,gag11,", #No.FUN-4A0081
                             " gag06,gag07,gag08,gag09,'',gag15,gag10,gag12,gag13",
                        " FROM gag_file",
                        "  WHERE gag01 = ? ",
                          " AND gag02 = ? ",
                          " FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_flow_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #TQC-730022 add--start
     IF NOT cl_null(g_argv1) THEN
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
     END IF 
    #TQC-730022 add--end
 
     INPUT ARRAY g_gag WITHOUT DEFAULTS FROM s_gag.*   #MOD-4C0024加上WITHOUT DEFAULTS
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
       #No.TQC-730022 --start
           LET g_before_input_done = FALSE
           CALL p_flow_set_entry_b()
           CALL p_flow_set_no_entry_b()
           LET g_before_input_done = TRUE
       #No.TQC-730022 --end
            BEGIN WORK
            OPEN p_flow_cl USING g_gaf.gaf01
            IF STATUS THEN
               CALL cl_err("OPEN p_flow_cl:", STATUS, 1)
               CLOSE p_flow_cl
               ROLLBACK WORK
               RETURN
            END IF
            #ELSE
               FETCH p_flow_cl INTO g_gaf.*            # 鎖住將被更改或取消的資料
               IF STATUS THEN
                  CALL cl_err("FETCH p_flow_cl:", STATUS, 1)      # 資料被他人LOCK
                  CLOSE p_flow_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            #END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_gag_t.* = g_gag[l_ac].*  #BACKUP
               OPEN p_flow_bcl USING g_gaf.gaf01,g_gag_t.gag02
               IF STATUS THEN
                  CALL cl_err("OPEN p_flow_bcl",STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH p_flow_bcl INTO g_gag[l_ac].*
                  IF STATUS THEN
                     CALL cl_err("FETCH p_flow_bcl",STATUS,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
#              #TQC-5A0092
               CALL cl_get_progname(g_gag[l_ac].gag03,g_lang) RETURNING g_gag[l_ac].gaz03
               CALL cl_get_progname(g_gag[l_ac].gag09,g_lang) RETURNING g_gag[l_ac].gaz03_2
#              SELECT gaz03 INTO g_gag[l_ac].gaz03 FROM gaz_file
#               WHERE gaz01 = g_gag[l_ac].gag03 AND gaz02 = g_lang order by gaz05
#              SELECT gaz03 INTO g_gag[l_ac].gaz03_2 FROM gaz_file
#               WHERE gaz01 = g_gag[l_ac].gag09 AND gaz02 = g_lang order by gaz05
##             #TQC-5A0092
 
               CALL cl_show_fld_cont()     #FUN-550037(smin)
 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gag[l_ac].* TO NULL      #900423
            LET g_gag_t.* = g_gag[l_ac].*         #新輸入資料
            LET g_gag[l_ac].gag14 = "1"           #No.TQC-5A0126
            LET g_gag[l_ac].gag15 = "0"           #No.TQC-5A0126
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD gag02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO gag_file(gag01,gag02,gag03,gag04,gag05,gag06,gag07,
                                gag08,gag09,gag10,gag11,gag12,gag13,gag14,
                                 gag15,gag16,gag17) #No.MOD-470041 #No.FUN-4A0081
                VALUES (g_gaf.gaf01,g_gag[l_ac].gag02,g_gag[l_ac].gag03,
                        g_gag[l_ac].gag04,g_gag[l_ac].gag05,g_gag[l_ac].gag06,
                        g_gag[l_ac].gag07,g_gag[l_ac].gag08,g_gag[l_ac].gag09,
                        g_gag[l_ac].gag10,g_gag[l_ac].gag11,g_gag[l_ac].gag12,
                        g_gag[l_ac].gag13,g_gag[l_ac].gag14,g_gag[l_ac].gag15,
                        '',g_gag[l_ac].gag17)
           IF SQLCA.sqlcode THEN
              #CALL cl_err(g_gag[l_ac].gag02,SQLCA.sqlcode,0)  #No.FUN-660081
              CALL cl_err3("ins","gag_file",g_gaf.gaf01,g_gag[l_ac].gag02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF
 
        BEFORE FIELD gag02                        #default 序號
            IF g_gag[l_ac].gag02 IS NULL OR g_gag[l_ac].gag02 = 0 THEN
               SELECT max(gag02)+1
                 INTO g_gag[l_ac].gag02
                 FROM gag_file
                 WHERE gag01 = g_gaf.gaf01
                IF g_gag[l_ac].gag02 IS NULL THEN
                    LET g_gag[l_ac].gag02 = 1
                END IF
                DISPLAY g_gag[l_ac].gag02 TO gag02       #TQC-5A0092
#               DISPLAY g_gag[l_ac].gag02 TO s_gag[l_sl].gag02
            END IF
 
        AFTER FIELD gag02                        #check 序號是否重複
            IF g_gag[l_ac].gag02 IS NULL THEN
               LET g_gag[l_ac].gag02 = g_gag_t.gag02
               DISPLAY g_gag[l_ac].gag02 TO gag02       #TQC-5A0092
#              DISPLAY g_gag[l_ac].gag02 TO s_gag[l_sl].gag02
                NEXT FIELD gag02
            END IF
 
            IF g_gag[l_ac].gag02 != g_gag_t.gag02 OR
               g_gag_t.gag02 IS NULL THEN
                SELECT count(*) INTO l_n FROM gag_file
                 WHERE gag01 = g_gaf.gaf01 AND
                       gag02 = g_gag[l_ac].gag02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gag[l_ac].gag02 = g_gag_t.gag02
                    NEXT FIELD gag02
                END IF
            END IF
 
        AFTER FIELD gag03
            IF NOT cl_null(g_gag[l_ac].gag03) THEN
 
#               #TQC-5A0092
                CALL cl_get_progname(g_gag[l_ac].gag03,g_lang) RETURNING g_gag[l_ac].gaz03
#               CALL p_flow_gag03(p_cmd,g_gag[l_ac].gag03) RETURNING g_gag[l_ac].gaz03
#               IF NOT cl_null(g_errno) THEN
#                   CALL cl_err(g_gag[l_ac].gag03,g_errno,0)
#                   NEXT FIELD gag03
#               ELSE
#                   DISPLAY g_gag[l_ac].gaz03 TO s_gag[l_sl].gaz03
#               END IF
                DISPLAY g_gag[l_ac].gaz03 TO gaz03
##              #TQC-5A0092
 
                IF g_gag[l_ac].gag03 != g_gag_t.gag03 OR           # MOD-530083
                   g_gag_t.gag03 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM gag_file          #No.FUN-4A0081
                        WHERE gag01 != g_gaf.gaf01 AND gag03 = g_gag[l_ac].gag03
                          AND gag04 = g_gag[l_ac].gag04
                   IF l_n > 0 THEN
                      CALL cl_err(g_gag[l_ac].gag03 || " and " || g_gag[l_ac].gag04,"azz-722",1)
                      NEXT FIELD gag03
                   END IF
                   #No.FUN-4A0081 --start--
                   SELECT COUNT(*) INTO l_n FROM gag_file
                    WHERE gag03 = g_gag[l_ac].gag03 AND gag04 = g_gag[l_ac].gag04
                      AND gag14 = g_gag[l_ac].gag14 AND gag17 = g_gag[l_ac].gag17
                   IF l_n > 0 THEN
                      CALL cl_err("",-239,1)
                      NEXT FIELD gag03
                   END IF
                   #No.FUN-4A0081 ---end---
                END IF
            ELSE
                IF NOT cl_null(g_gag_t.gag03) THEN
                    CALL cl_err('Empty!','aoo-997',0)
                    NEXT FIELD gag03
                END IF
            END IF
 
         AFTER FIELD gag04   #MOD-4C0024 判斷資料庫中的主鍵資料不可重複
            #No.FUN-4A0081 --start--
            IF NOT cl_null(g_gag[l_ac].gag04) THEN
                IF g_gag[l_ac].gag04 != g_gag_t.gag04 OR           # MOD-530083
                  g_gag_t.gag04 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM gag_file          #No.FUN-4A0081
                       WHERE gag01 != g_gaf.gaf01 AND gag03 = g_gag[l_ac].gag03
                         AND gag04 = g_gag[l_ac].gag04
                  IF l_n > 0 THEN
                     CALL cl_err(g_gag[l_ac].gag03 || " and " || g_gag[l_ac].gag04,"azz-722",1)
                     NEXT FIELD gag04
                  END IF
                  SELECT COUNT(*) INTO l_n FROM gag_file
                   WHERE gag03 = g_gag[l_ac].gag03 AND gag04 = g_gag[l_ac].gag04
                     AND gag14 = g_gag[l_ac].gag14 AND gag17 = g_gag[l_ac].gag17
                  IF l_n > 0 THEN
                     CALL cl_err("",-239,1)
                     NEXT FIELD gag04
                  END IF
               END IF
            END IF
            #No.FUN-4A0081 ---end---
        #No.FUN-4A0081 --start--
        BEFORE FIELD gag14
           CALL p_flow_set_entry()
 
        AFTER FIELD gag14
           IF NOT cl_null(g_gag[l_ac].gag14) THEN
              IF g_gag[l_ac].gag14 != g_gag_t.gag14 OR
                 g_gag_t.gag14 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM gag_file
                  WHERE gag03 = g_gag[l_ac].gag03 AND gag04 = g_gag[l_ac].gag04
                    AND gag14 = g_gag[l_ac].gag14 AND gag17 = g_gag[l_ac].gag17
                 IF l_n > 0 THEN
                    CALL cl_err("",-239,1)
                    NEXT FIELD gag04
                 END IF
              END IF
           END IF
           CALL p_flow_set_no_entry()
 
        AFTER FIELD gag17
           IF NOT cl_null(g_gag[l_ac].gag17) THEN
              IF g_gag[l_ac].gag17 != g_gag_t.gag17 OR
                 g_gag_t.gag17 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM gag_file
                  WHERE gag03 = g_gag[l_ac].gag03 AND gag04 = g_gag[l_ac].gag04
                    AND gag14 = g_gag[l_ac].gag14 AND gag17 = g_gag[l_ac].gag17
                 IF l_n > 0 THEN
                    CALL cl_err("",-239,1)
                    NEXT FIELD gag17
                 END IF
              END IF
           END IF
 
        AFTER FIELD gag11     #No.MOD-840261 --unmark--
           IF NOT cl_null(g_gag[l_ac].gag11) AND ((g_gag[l_ac].gag11 != g_gag_t.gag11) OR cl_null(g_gag_t.gag11)) THEN  #No.MOD-840261
              CALL p_flow_gag11(g_gag[l_ac].gag11) RETURNING g_gag[l_ac].gag06
           END IF
        #No.FUN-4A0081 ---end---
 
#        AFTER FIELD gag06
#            IF g_gag[l_ac].gag05 = "Y" AND cl_null(g_gag[l_ac].gag06) THEN
#                NEXT FIELD gag06
#            END IF
 
#        AFTER FIELD gag07
#            IF g_gag[l_ac].gag07 IS NULL THEN LET g_gag[l_ac].gag07 = " " END IF
#
#        AFTER FIELD gag08
#            IF g_gag[l_ac].gag08 IS NULL THEN LET g_gag[l_ac].gag08 = " " END IF
 
        AFTER FIELD gag09
#           #TQC-5A0092
            IF NOT cl_null(g_gag[l_ac].gag09) THEN
                CALL cl_get_progname(g_gag[l_ac].gag09,g_lang) RETURNING g_gag[l_ac].gaz03_2
#               CALL p_flow_gag03(p_cmd,g_gag[l_ac].gag09)
#                    RETURNING g_gag[l_ac].gaz03_2
#               IF NOT cl_null(g_errno) THEN
#                   CALL cl_err(g_gag[l_ac].gag09,g_errno,0)
#                   NEXT FIELD gag09
#               ELSE
#                   DISPLAY g_gag[l_ac].gaz03_2 TO s_gag[l_sl].gaz03_2
#               END IF
                DISPLAY g_gag[l_ac].gaz03_2 TO gaz03_2
            END IF
##          #TQC-5A0092
 
#        AFTER FIELD gag12
#            IF cl_null(g_gag[l_ac].gag12) OR g_gag[l_ac].gag12 < 0 THEN
#                 LET g_gag[l_ac].gag12 = 0
#                 DISPLAY g_gag[l_ac].gag12 TO s_gag[l_sl].gag12
#            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gaf.gaf04 = 'Y' THEN
                CALL cl_err('','azz-144',0)
                CANCEL DELETE
            END IF 
            IF g_gag_t.gag02 > 0 AND g_gag_t.gag02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM gag_file
                    WHERE gag01 = g_gaf.gaf01 AND
                          gag02 = g_gag_t.gag02
                IF SQLCA.sqlcode THEN
                    #CALL cl_err(g_gag_t.gag02,SQLCA.sqlcode,0)  #No.FUN-660081
                    CALL cl_err3("del","gag_file",g_gaf.gaf01,g_gag_t.gag02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                    LET g_rec_b=g_rec_b-1
                    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gag[l_ac].* = g_gag_t.*
               CLOSE p_flow_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gag[l_ac].gag02,-263,1)
               LET g_gag[l_ac].* = g_gag_t.*
            ELSE
               UPDATE gag_file
                  SET gag02 = g_gag[l_ac].gag02,
                      gag03 = g_gag[l_ac].gag03,
                      gag04 = g_gag[l_ac].gag04,
                      gag05 = g_gag[l_ac].gag05,
                      gag06 = g_gag[l_ac].gag06,
                      gag07 = g_gag[l_ac].gag07,
                      gag08 = g_gag[l_ac].gag08,
                      gag09 = g_gag[l_ac].gag09,
                      gag10 = g_gag[l_ac].gag10,
                      gag11 = g_gag[l_ac].gag11,
                      gag12 = g_gag[l_ac].gag12,
                      gag13 = g_gag[l_ac].gag13,
                      gag14 = g_gag[l_ac].gag14,    #No.FUN-4A0081
                      gag15 = g_gag[l_ac].gag15,    #No.FUN-4A0081
                      gag17 = g_gag[l_ac].gag17
                WHERE gag01=g_gaf.gaf01
                  AND gag02=g_gag_t.gag02
               IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_gag[l_ac].gag02,SQLCA.sqlcode,0)  #No.FUN-660081
                   CALL cl_err3("upd","gag_file",g_gaf.gaf01,g_gag_t.gag02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                   LET g_gag[l_ac].* = g_gag_t.*
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
                  LET g_gag[l_ac].* = g_gag_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_gag.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE p_flow_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE p_flow_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gag03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz"   #MOD-560114
                 LET g_qryparam.default1 = g_gag[l_ac].gag03
                 LET g_qryparam.arg1 = g_lang
                 CALL cl_create_qry() RETURNING g_gag[l_ac].gag03
                 DISPLAY BY NAME g_gag[l_ac].gag03
                 NEXT FIELD gag03
 
              WHEN INFIELD(gag09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz"
                 LET g_qryparam.default1 = g_gag[l_ac].gag09
                 LET g_qryparam.arg1 = g_lang
                 CALL cl_create_qry() RETURNING g_gag[l_ac].gag09
                 DISPLAY BY NAME g_gag[l_ac].gag09
                 NEXT FIELD gag09
 
              WHEN INFIELD(gag11)
                 CALL s_usermail(TRUE,TRUE,g_gag[l_ac].gag11,g_gag[l_ac].gag06,TRUE)
                      RETURNING g_gag[l_ac].gag11,g_gag[l_ac].gag06
                 DISPLAY g_gag[l_ac].gag11,g_gag[l_ac].gag06 TO gag11,gag06
                 NEXT FIELD gag11
 
             OTHERWISE
                EXIT CASE
          END CASE
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about
           CALL cl_about()
 
        CONTINUE INPUT
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
        END INPUT
 
    CLOSE p_flow_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION p_flow_set_entry()
 
   IF INFIELD(gag14) THEN
      CALL cl_set_comp_entry("gag17",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_flow_set_no_entry()
 
   IF INFIELD(gag14) THEN
      IF g_gag[l_ac].gag14 = "1" THEN
         CALL cl_set_comp_entry("gag17",FALSE)
         LET g_gag[l_ac].gag17 = " "
      ELSE
         LET g_gag[l_ac].gag17 = g_gag_t.gag17
      END IF
   END IF
END FUNCTION
 
# #TQC-5A0092
#FUNCTION p_flow_gag03(p_cmd,l_zz01)
#
#    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
#           l_zz01    LIKE zz_file.zz01,
#           l_zz03    LIKE gaz_file.gaz03
#    DEFINE l_cnt     LIKE type_file.num10   #FUN-680135
#    LET g_errno = " "
#    LET l_zz03 = " "
#
#  #  SELECT gaz03 INTO l_zz03 FROM gaz_file WHERE gaz01 = l_zz01 AND gaz02 = g_lang
#  #--------------------------------No.MOD-540192-------------------------------
#  {
#    SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
#     WHERE gaz01=l_zz01 AND gaz02=g_lang
#    IF l_cnt > 1 THEN
#        SELECT gaz03 INTO l_zz03 FROM gaz_file
#            WHERE gaz01=l_zz01 AND gaz02=g_lang AND gaz05 = 'Y'
#    ELSE
#        SELECT gaz03 INTO l_zz03 FROM gaz_file
#            WHERE gaz01=l_zz01 AND gaz02=g_lang AND gaz05 = 'N'
#    END IF
#
#    IF SQLCA.SQLCODE THEN
#        CASE
#           WHEN SQLCA.SQLCODE = 100 LET g_errno = "aoo-997"
#           OTHERWISE                LET g_errno = SQLCA.SQLCODE USING "-------"
#        END CASE
#    END IF
#   }
#
#    SELECT gaz03 INTO l_zz03 FROM gaz_file
#            WHERE gaz01=l_zz01 AND gaz02=g_lang AND gaz05 = 'Y'
#    IF cl_null(l_zz03) THEN
#       SELECT gaz03 INTO l_zz03 FROM gaz_file
#            WHERE gaz01=l_zz01 AND gaz02=g_lang AND gaz05 = 'N'
#       IF SQLCA.SQLCODE THEN
#           CASE
#              WHEN SQLCA.SQLCODE = 100 LET g_errno = "aoo-997"
#              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING "-------"
#           END CASE
#       END IF
#    END IF
#   #-----------------------------------No.MOD-540192 END---------------------------------
#    RETURN l_zz03
#
#END FUNCTION
 
#No.FUN-4A0081 --start--
FUNCTION p_flow_gag11(p_str)
   DEFINE   p_str       LIKE gag_file.gag11
   DEFINE   ls_str      STRING
   DEFINE   l_zx01      LIKE zx_file.zx01
   DEFINE   l_zx02      LIKE zx_file.zx02,
            l_zx09      LIKE zx_file.zx09
   DEFINE   l_gag06     LIKE gag_file.gag06
   DEFINE   ls_mail     STRING
   DEFINE   lst_zx01    base.StringTokenizer
 
 
   LET ls_mail = ""
   LET lst_zx01 = base.StringTokenizer.create(p_str,";")
   WHILE lst_zx01.hasMoreTokens()
      LET ls_str = lst_zx01.nextToken()
      LET l_zx01 = ls_str
 
      SELECT zx02,zx09 INTO l_zx02,l_zx09 FROM zx_file WHERE zx01 = l_zx01
      IF SQLCA.SQLCODE OR cl_null(l_zx09) THEN
         LET l_zx02 = ""
         LET l_zx09 = ""
         IF NOT cl_null(ls_mail) THEN
            LET ls_mail = ls_mail
         END IF
      ELSE
         IF NOT cl_null(ls_mail) THEN
            LET ls_mail = ls_mail,";"
         END IF
         IF cl_null(l_zx02) THEN
            LET ls_mail = ls_mail,l_zx09,":",l_zx01
         ELSE
            LET ls_mail = ls_mail,l_zx09,":",l_zx02
         END IF
      END IF
   END WHILE
 
   LET ls_mail = ls_mail.trim()
   LET l_gag06 = ls_mail
 
   RETURN l_gag06
END FUNCTION
#No.FUN-4A0081 ---end---
 
FUNCTION p_flow_gagcopy()
 
DEFINE
    l_batch  LIKE gag_file.gag01,   #FUN-680135 VARCHAR(10)
    l_item   LIKE gag_file.gag02    #FUN-680135 SMALLINT
 
   LET l_batch = ' '
   LET l_item  = ' '
   OPEN WINDOW w_copy AT 16,20 WITH 5 ROWS, 40 COLUMNS
                         ATTRIBUTE (BORDER)
      DISPLAY  'batch:' AT 1,1
      DISPLAY  'item :' AT 3,1
 
   WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT  'batch:' FOR l_batch
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
      END PROMPT
#TQC-860017 end
      IF INT_FLAG THEN EXIT WHILE END IF
      DISPLAY  'batch:',l_batch AT 1,1
           LET INT_FLAG = 0  ######add for prompt bug
 
      PROMPT  'item :' FOR l_item
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
      END PROMPT
#TQC-860017 end
            LET INT_FLAG = 0  ######add for prompt bug
#     PROMPT  'item :' CLIPPED FOR l_item
      DISPLAY  'item :',l_item AT 3,1
      IF INT_FLAG THEN EXIT WHILE END IF
      IF l_batch IS NOT NULL AND l_item != 0 THEN
         EXIT WHILE
      END IF
 
   END WHILE
   CLOSE WINDOW w_copy
   ERROR 'batch :',l_batch,'  item :',l_item
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET g_errno = ''
 
#  #TQC-5A0092
   SELECT gag03,'',gag04,gag14,gag17,gag05,gag11,gag06,gag07,gag08,gag09,gag15,gag10,gag12,gag13
#  SELECT gag03,gaz03,gag04,gag14,gag17,gag05,gag11,gag06,gag07,gag08,gag09,gag15,gag10,gag12,gag13
     INTO g_gag[l_ac].gag03, g_gag[l_ac].gaz03,  g_gag[l_ac].gag04,
          g_gag[l_ac].gag14, g_gag[l_ac].gag17, #No.FUN-4A0081
          g_gag[l_ac].gag05, g_gag[l_ac].gag11, g_gag[l_ac].gag06,
          g_gag[l_ac].gag07, g_gag[l_ac].gag08, g_gag[l_ac].gag09,
          g_gag[l_ac].gag15,                    #No.FUN-4A0081
          g_gag[l_ac].gag10, g_gag[l_ac].gag12, g_gag[l_ac].gag13
     FROM gag_file    #,zz_file #TQC-5A0092
    WHERE gag01 = l_batch AND gag02 = l_item
#     AND gag03 = zz01          #TQC-5A0092
    CASE
        WHEN SQLCA.sqlcode = 100 LET g_errno = 'aoo-997'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    CALL cl_get_progname(g_gag[l_ac].gag03,g_lang) RETURNING g_gag[l_ac].gaz03
    DISPLAY g_gag[l_ac].gag03 TO gag03
    DISPLAY g_gag[l_ac].gaz03 TO gaz03
    DISPLAY g_gag[l_ac].gag04 TO gag04
    DISPLAY g_gag[l_ac].gag05 TO gag05
    DISPLAY g_gag[l_ac].gag11 TO gag11
    DISPLAY g_gag[l_ac].gag06 TO gag06
    DISPLAY g_gag[l_ac].gag07 TO gag07
    DISPLAY g_gag[l_ac].gag08 TO gag08
    DISPLAY g_gag[l_ac].gag09 TO gag09
    DISPLAY g_gag[l_ac].gag10 TO gag10
    DISPLAY g_gag[l_ac].gag12 TO gag12
    DISPLAY g_gag[l_ac].gag13 TO gag13
 
#   IF SQLCA.sqlcode THEN
#      DISPLAY g_gag[l_ac].*
#           TO gag03,gaz03,gag04,gag05,gag11,gag06,gag07,gag08,gag09,gag10,
#              gag12,gag13
#   END IF
 
END FUNCTION
 
 
FUNCTION p_flow_b_askkey()
    DEFINE l_wc2     STRING
 
#   CLEAR gaz03         #TQC-5A0092       #清除FORMONLY欄位
    CLEAR FORM
 
    CONSTRUCT l_wc2 ON gag02,gag03,gag04,gag14,gag17,gag05,gag11,gag06,gag07,
                       gag08,gag09,gag15,gag10,gag12,gag13       #No.FUN-4A0081
            FROM s_gag[1].gag02, s_gag[1].gag03, s_gag[1].gag04,
                 s_gag[1].gag14, s_gag[1].gag17,
                 s_gag[1].gag05, s_gag[1].gag11, s_gag[1].gag06,
                 s_gag[1].gag07, s_gag[1].gag08, s_gag[1].gag09,
                 s_gag[1].gag15,
                 s_gag[1].gag10, s_gag[1].gag12, s_gag[1].gag13
 
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE CONSTRUCT
    END CONSTRUCT
#TQC-860017 end
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL p_flow_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION p_flow_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
 
    LET g_sql = "SELECT gag02,gag03,'',gag04,gag14,gag17,gag05,gag11,gag06,",
                      " gag07,gag08,gag09,'',gag15,gag10,gag12,gag13,''",
                "  FROM gag_file ",     #, zz_file ",  #TQC-5A0092
                " WHERE gag01 ='",g_gaf.gaf01 CLIPPED,"'",
                "   AND ", p_wc2 CLIPPED,
                " ORDER BY 1 "
 
    PREPARE p_flow_pb FROM g_sql
    DECLARE gag_curs                       #SCROLL CURSOR
        CURSOR FOR p_flow_pb
    CALL g_gag.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH gag_curs INTO g_gag[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
#       #TQC-5A0092
#       SELECT gaz03 INTO g_gag[g_cnt].gaz03 FROM gaz_file
#        WHERE gaz01 = g_gag[g_cnt].gag03 AND gaz02 = g_lang order by gaz05
#       # 填入待執行程式說明 gag09
#       SELECT gaz03 INTO g_gag[g_cnt].gaz03_2 FROM gaz_file
#        WHERE gaz01=g_gag[g_cnt].gag09 AND gaz02 = g_lang order by gaz05
        CALL cl_get_progname(g_gag[g_cnt].gag03,g_lang) RETURNING g_gag[g_cnt].gaz03
        CALL cl_get_progname(g_gag[g_cnt].gag09,g_lang) RETURNING g_gag[g_cnt].gaz03_2
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gag.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_flow_bp(p_ud)
 
    DEFINE  p_ud            LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
    DEFINE  li_i            LIKE type_file.num10   #FUN-680135    INTEGER
 
    IF p_ud<>'G' OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    DISPLAY ARRAY g_gag TO s_gag.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION insert
           LET g_action_choice="insert"
           EXIT DISPLAY # A.輸入
        ON ACTION query
           LET g_action_choice="query"
           EXIT DISPLAY # Q.查詢
        ON ACTION next
         CALL p_flow_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
        ON ACTION previous
         CALL p_flow_fetch('P')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
        ON ACTION first
         CALL p_flow_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
        ON ACTION last
         CALL p_flow_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
        ON ACTION jump
         CALL p_flow_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
        ON ACTION modify
           LET g_action_choice="modify"
           EXIT DISPLAY # U.更改
        ON ACTION invalid
           LET g_action_choice="invalid"
           EXIT DISPLAY # X.作廢
        ON ACTION delete
           LET g_action_choice="delete"
           EXIT DISPLAY # R.取消
        ON ACTION detail
           LET g_action_choice="detail"
           EXIT DISPLAY # B.單身
       #-FUN-960113-add-
       #ON ACTION reproduce
       #   LET g_action_choice="reproduce"
       #   EXIT DISPLAY # C.複製
       #-FUN-960113-end-
        ON ACTION help
           LET g_action_choice="help"
           EXIT DISPLAY # H.說明
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        #TQC-5A0092
#        FOR li_i = 1 TO g_gag.getLength()
#            CALL p_flow_gag03('a',g_gag[li_i].gag03) RETURNING g_gag[li_i].gaz03
#            CALL p_flow_gag03('a',g_gag[li_i].gag09) RETURNING g_gag[li_i].gaz03_2
#        END FOR
 
        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DISPLAY # Esc.結束
 
        ON ACTION accept
           LET l_ac = ARR_CURR()
           LET g_action_choice="detail"
           EXIT DISPLAY
 
        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY # Esc.結束
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION exporttoexcel       #FUN-4B0049
           LET g_action_choice = 'exporttoexcel'
           EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_flow_copy()
DEFINE
    l_gaf		RECORD LIKE gaf_file.*,
    l_oldno,l_newno	LIKE gaf_file.gaf01
 
#   IF s_shut(0) THEN RETURN END IF
    IF g_gaf.gaf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
    INPUT l_newno FROM gaf01
        AFTER FIELD gaf01
            IF l_newno IS NULL THEN
                NEXT FIELD gaf01
            END IF
            SELECT count(*) INTO g_cnt FROM gaf_file
                WHERE gaf01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD gaf01
            END IF
    #TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE INPUT
#TQC-860017 end
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_gaf.gaf01 ATTRIBUTE(YELLOW)
        RETURN
    END IF
    LET l_gaf.* = g_gaf.*
    LET l_gaf.gaf01  =l_newno   #新的鍵值
    LET l_gaf.gafuser=g_user    #資料所有者
    LET l_gaf.gafgrup=g_grup    #資料所有者所屬群
    LET l_gaf.gafmodu=NULL      #資料修改日期
    LET l_gaf.gafdate=g_today   #資料建立日期
    LET l_gaf.gafacti='Y'       #有效資料
    LET l_gaf.gaforiu = g_user      #No.FUN-980030 10/01/04
    LET l_gaf.gaforig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO gaf_file VALUES (l_gaf.*)
    IF SQLCA.sqlcode THEN
        #CALL cl_err('gaf:',SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","gaf_file",l_gaf.gaf01,"",SQLCA.sqlcode,"","gaf",0)   #No.FUN-660081
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM gag_file         #單身複製
        WHERE gag01=g_gaf.gaf01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        #CALL cl_err(g_gaf.gaf01,SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","x",g_gaf.gaf01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
        RETURN
    END IF
    UPDATE x
        SET gag01=l_newno
    INSERT INTO gag_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        #CALL cl_err('gag:',SQLCA.sqlcode,0)
        CALL cl_err3("ins","gag_file",l_newno,"",SQLCA.sqlcode,"","gag",0)   #No.FUN-660081
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno = g_gaf.gaf01
     SELECT gaf_file.* INTO g_gaf.*
       FROM gaf_file WHERE gaf01 = l_newno
     CALL p_flow_u()
     CALL p_flow_b()
     #SELECT gaf_file.* INTO g_gaf.*        #FUN-C30027
     #  FROM gaf_file WHERE gaf01 = l_oldno #FUN-C30027
     #CALL p_flow_show()                    #FUN-C30027
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_flow_set_entry_i(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gaf01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_flow_set_no_entry_i(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gaf01",FALSE)
   END IF
 
END FUNCTION
#--end
 
#TQC-730022 begin
FUNCTION p_flow_set_entry_b()
 
  CALL cl_set_comp_entry("gag02,gag03,gag04,gag14,gag17,gag05",TRUE)
END FUNCTION
 
FUNCTION p_flow_set_no_entry_b()
 
   IF g_gaf.gaf04 = 'Y' THEN
     CALL cl_set_comp_entry("gag02,gag03,gag04,gag14,gag17,gag05",FALSE)
   END IF
END FUNCTION
#TQC-730022 end
