# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt832.4gl
# Descriptions...: 初盤維護作業－在製工單(維護方式不包含工作站/作業序號)
# Date & Author..: 93/06/14 By Apple
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: NO.MOD-420449 05/08/05 BY yiting key 可更改
# Modify.........: NO.FUN-5B0137 05/11/30 BY kim 單身盤點數量重新DISPLAY
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-8C0300 08/12/31 By sherry 初盤數量欄位維護好后重新查詢又變為空
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-910088 11/12/13 By chenjing 增加數量欄位小數取位  
# Modify.........: No.MOD-C50120 12/05/16 By ck2yuan 盤點數量輸入為負時,回復舊值
# Modify.........: No.MOD-C70051 12/07/06 By Sakura 畫面顯示過帳碼(pie16)以checkbox呈現，可qbe不可維護;另增加如saimt832訊息mfg0132的控管
# Modify.........: No.FUN-CB0087 12/12/13 By qiull 庫存單據理由碼改善
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pid           RECORD LIKE pid_file.*,
    g_pid_t         RECORD LIKE pid_file.*,
    g_pid_o         RECORD LIKE pid_file.*,
    g_pid01_t       LIKE pid_file.pid01,
    g_pie           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        pie07       LIKE pie_file.pie07,   #項次
        pie02       LIKE pie_file.pie02,   #盤點料件
        ima02       LIKE ima_file.ima02,   #品名規格
        ima021      LIKE ima_file.ima021,  #規格
        pie16       LIKE pie_file.pie16,   #過帳碼 #MOD-C70051 add
        pie04       LIKE pie_file.pie04,   #發料單位
        qty         LIKE pie_file.pie30,   #初盤數量
        pie70       LIKE pie_file.pie70,   #FUN-CB0087
        azf03       LIKE azf_file.azf03    #FUN-CB0087
                    END RECORD,
    g_pie_t         RECORD                 #程式變數 (舊值)
        pie07       LIKE pie_file.pie07,   #項次
        pie02       LIKE pie_file.pie02,   #盤點料件
        ima02       LIKE ima_file.ima02,   #品名規格
        ima021      LIKE ima_file.ima021,  #規格
        pie16       LIKE pie_file.pie16,   #過帳碼 #MOD-C70051 add
        pie04       LIKE pie_file.pie04,   #發料單位
        qty         LIKE pie_file.pie30,   #初盤數量
        pie70       LIKE pie_file.pie70,   #FUN-CB0087
        azf03       LIKE azf_file.azf03    #FUN-CB0087
                    END RECORD,
    g_peo               LIKE pie_file.pie34,
    g_peo2              LIKE pie_file.pie34,
    g_tagdate           LIKE type_file.dat,     #No.FUN-690026 DATE
    g_tagdate2          LIKE type_file.dat,     #No.FUN-690026 DATE
    g_date1             LIKE type_file.dat,     #No.FUN-690026 DATE
    g_argv1             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_sl                LIKE type_file.num5     #目前處理的SCREEN LINE  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done   LIKE type_file.num5    #FUN-570110  #No.FUN-690026 SMALLINT
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
 
FUNCTION aimt832(p_argv1)
    DEFINE       p_argv1         LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)

    WHENEVER ERROR CONTINUE 
 
    LET g_forupd_sql = " SELECT * FROM pid_file WHERE pid01 = ? FOR UPDATE "
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE t832_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = p_argv1
 
    IF g_argv1 = '1' THEN
        LET g_prog='aimt840'
    ELSE
        LET g_prog='aimt841'
    END IF
 
    OPEN WINDOW t832_w WITH FORM "aim/42f/aimt832"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_set_comp_required("pie70",g_aza.aza115='Y')        #FUN-CB0087
    CALL t832_menu()
    CLOSE WINDOW t832_w                    #結束畫面
END FUNCTION
 
#QBE 查詢資料
FUNCTION t832_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_pie.clear()
 
    INITIALIZE g_pid.* TO NULL  #FUN-640213 add
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        pid01,pid02,pid03
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pid02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_sfb'
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pid02
                  NEXT FIELD pid02
               OTHERWISE EXIT CASE
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON pie07,pie02,pie16,pie04,pie70 #MOD-C70051 add pie16      #FUN-CB0087 add>pie70
            FROM s_pie[1].pie07,s_pie[1].pie02,s_pie[1].pie16,s_pie[1].pie04,s_pie[1].pie70 #MOD-C70051 add pie16  #FUN-CB0087 add>pie70
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pie02)
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form = "q_ima"
                 #    LET g_qryparam.state = 'c'
                 #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO pie02
                     NEXT FIELD pie02
                WHEN INFIELD(pie04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pie04
                     NEXT FIELD pie04
                #FUN-CB0087---add---str---
                WHEN INFIELD(pie70)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf41"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pie70
                     NEXT FIELD pie70
                #FUN-CB0087---add---end---
                OTHERWISE
                    EXIT CASE
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
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  pid01 FROM pid_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY pid01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE pid_file. pid01 ",
                   "  FROM pid_file, pie_file ",
                   " WHERE pid01 = pie01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY pid01"
    END IF
 
    PREPARE t832_prepare FROM g_sql
    DECLARE t832_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t832_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM pid_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT pid01) FROM pid_file,pie_file WHERE ",
                  "pie01=pid01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t832_precount FROM g_sql
    DECLARE t832_count CURSOR FOR t832_precount
END FUNCTION
 
FUNCTION t832_menu()
 
   WHILE TRUE
      CALL t832_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t832_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t832_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t832_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "快速輸入"
       # WHEN "quick_input"
       #    IF cl_chk_act_auth() THEN
       #       CALL t832_a()
       #    END IF
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pie),'','')
            END IF
          #No.FUN-680046-------add--------str----
          WHEN "related_document"           #相關文件
           IF cl_chk_act_auth() THEN
              IF g_pid.pid01 IS NOT NULL THEN
                 LET g_doc.column1 = "pid01"
                 LET g_doc.value1 = g_pid.pid01
                 CALL cl_doc()
              END IF 
            END IF
          #No.FUN-680046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION t832_a()
 DEFINE  l_msg1,l_msg2   LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(70)
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_pie.clear()
    INITIALIZE g_pid.* LIKE pid_file.*             #DEFAULT 設定
    LET g_pid01_t = NULL
    LET g_pid_t.pid01 = NULL
    LET g_pid_o.* = g_pid.*
 
   #LET l_msg1 = 'Del:登錄結束,<^F>:欄位說明'
   #LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
   #DISPLAY l_msg1 AT 1,1
   #DISPLAY l_msg2 AT 2,1
    WHILE TRUE
   #No.FUN-550029 --start--
       LET g_pid.pid01 = g_pid_t.pid01[1,g_doc_len],'-',
                         g_pid_t.pid01[g_no_sp,g_no_ep] + 1 using'&&&&&&'
   #   LET g_pid.pid01 = g_pid_t.pid01[1,3],'-',
   #                     g_pid_t.pid01[5,10] + 1 using'&&&&&&'
   #No.FUN-550029 --end--
        CALL t832_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_pid.* TO NULL
            CLEAR FORM
   CALL g_pie.clear()
            EXIT WHILE
        END IF
        IF g_pid.pid01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_pid.pid06 = 'Y' THEN
           UPDATE pid_file SET pid02 = g_pid.pid02,
                               pid03 = g_pid.pid03,
                               pid07 = 'Y'
                        WHERE pid01 = g_pid.pid01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("upd","pid_file",g_pid_t.pid01,"",SQLCA.sqlcode,"",
                            "",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
        END IF
        SELECT pid01 INTO g_pid.pid01 FROM pid_file
            WHERE pid01 = g_pid.pid01
        LET g_pid01_t = g_pid.pid01        #保留舊值
        LET g_pid_t.* = g_pid.*
        CALL g_pie.clear()
        LET g_rec_b = 0                    #No.FUN-680064
        CALL t832_b_fill('1=1')                 #單身
        CALL t832_b()                   #輸入單身
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            INITIALIZE g_pid.* TO NULL
            CALL g_pie.clear()
            CLEAR FORM
   CALL g_pie.clear()
            EXIT WHILE
        END IF
        INITIALIZE g_pid.* TO NULL
        CALL g_pie.clear()
        CLEAR FORM
   CALL g_pie.clear()
        CONTINUE WHILE
    END WHILE
END FUNCTION
 
FUNCTION t832_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pid.pid01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_pid.pid06 ='N' THEN
        CALL cl_err(g_pid.pid01,'mfg0130',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pid01_t = g_pid.pid01
    LET g_pid_o.* = g_pid.*
    BEGIN WORK
 
    OPEN t832_cl USING g_pid.pid01
    IF STATUS THEN
       CALL cl_err("OPEN t832_cl:", STATUS, 1)
       CLOSE t832_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t832_cl INTO g_pid.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t832_cl ROLLBACK WORK RETURN
    END IF
    CALL t832_show()
    WHILE TRUE
        LET g_pid01_t = g_pid.pid01
        CALL t832_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pid.*=g_pid_t.*
            CALL t832_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_pid.pid01 != g_pid01_t THEN            # 更改單號
            UPDATE pie_file SET pie01 = g_pid.pid01
                WHERE pie01 = g_pid01_t
            IF SQLCA.sqlcode THEN
#              CALL cl_err('pie',SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("upd","pie_file",g_pid01_t,"",SQLCA.sqlcode,"",
                            "",1)  #No.FUN-660156
               CONTINUE WHILE 
            END IF
        END IF
 UPDATE pid_file SET pid_file.* = g_pid.*
  WHERE pid01=g_pid01_t 
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","pid_file",g_pid_t.pid01,"",SQLCA.sqlcode,"",
                        "",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t832_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t832_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
    l_cnt           LIKE type_file.num10,   #No.FUN-690026 INTEGER
    l_str           LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(70)
    p_cmd           LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_pid.pid01,g_pid.pid02,g_pid.pid03
          WITHOUT DEFAULTS
      FROM pid01,pid02,pid03
 
 
#No.FUN-570110  --start
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t832_set_entry(p_cmd)
          CALL t832_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
#No.FUN-570110  --end
        AFTER FIELD pid01
           IF NOT cl_null(g_pid.pid01) THEN
               CALL t832_pid01('d')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_pid.pid01,'mfg0114',0)
                  NEXT FIELD pid01
               END IF
               LET g_pid_o.pid02 = g_pid.pid02
           END IF
           IF g_pid.pid06 = 'N' THEN EXIT INPUT END IF
 
        BEFORE FIELD pid02
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(7,23,g_pid.pid02) RETURNING g_pid.pid02
	               DISPLAY BY NAME g_pid.pid02
                   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      	    END IF
 
        AFTER FIELD pid02      #工單編號
            IF NOT cl_null(g_pid.pid02) THEN
                CALL t832_pid02('d')
                IF NOT cl_null(g_errno)  THEN
                   CALL cl_err(g_pid.pid02,g_errno,0)
                   LET g_pid.pid02 = g_pid_o.pid02
                   DISPLAY BY NAME g_pid.pid02
                   NEXT FIELD pid02
                END IF
                SELECT COUNT(*) INTO l_cnt FROM pid_file
                               WHERE pid02 = g_pid.pid02
                IF l_cnt > 0 THEN
                   CALL cl_getmsg('mfg0129',g_lang) RETURNING l_str
                   IF NOT cl_prompt(0,0,l_str) THEN
                      NEXT FIELD pid02
                   END IF
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pid02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_sfb'
                  LET g_qryparam.default1 = g_pid.pid02
                  CALL cl_create_qry() RETURNING g_pid.pid02
                  DISPLAY BY NAME g_pid.pid02
		  CALL t832_pid02('a')
                  NEXT FIELD pid02
               OTHERWISE EXIT CASE
            END CASE
 
        AFTER INPUT
          LET l_flag='N'
          IF INT_FLAG THEN EXIT INPUT  END IF
          IF g_pid.pid02 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_pid.pid02
          END IF
          IF g_pid.pid03 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_pid.pid03
          END IF
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD pid02
          END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
 
    END INPUT
END FUNCTION
 
FUNCTION t832_pid01(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT pid_file.*, ima02,ima021,imaacti
      INTO g_pid.*, l_ima02,l_ima021,l_imaacti
      FROM pid_file, OUTER ima_file
      WHERE pid01 = g_pid.pid01 AND pid_file.pid03 = ima_file.ima01
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
               LET g_pid.pid02  = NULL
              LET g_pid.pid03 = NULL
              LET l_ima02     = NULL LET l_ima021    = NULL
              LET l_imaacti   = NULL
    	WHEN l_imaacti='N' LET g_errno = '9028'
      #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
 	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
 
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pid.pid02,g_pid.pid03
       DISPLAY l_ima02  TO FORMONLY.ima02_d
       DISPLAY l_ima021 TO FORMONLY.ima021_d
    END IF
END FUNCTION
 
FUNCTION t832_pid02(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_sfb04      LIKE sfb_file.sfb04,
           l_sfbacti    LIKE sfb_file.sfbacti
 
    LET g_errno = ' '
    SELECT sfb04,sfb05,ima02,ima021 INTO l_sfb04,g_pid.pid03,l_ima02,l_ima021
                       FROM sfb_file,OUTER ima_file
                      WHERE sfb01 = g_pid.pid02
                        AND sfb_file.sfb05 = ima_file.ima01 AND sfb87!='X'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3370'
		        			   	  LET l_sfb04 = NULL
    	WHEN l_sfbacti='N' LET g_errno = '9028'
    	WHEN l_sfb04 not matches'[2-6]'  LET g_errno = 'mfg0128'
		OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pid.pid03
       DISPLAY l_ima02  TO FORMONLY.ima02_d
       DISPLAY l_ima021 TO FORMONLY.ima021_d
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t832_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_pie.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t832_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t832_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_pid.* TO NULL
    ELSE
       OPEN t832_count
       FETCH t832_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t832_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t832_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t832_cs INTO g_pid.pid01
        WHEN 'P' FETCH PREVIOUS t832_cs INTO g_pid.pid01
        WHEN 'F' FETCH FIRST    t832_cs INTO g_pid.pid01
        WHEN 'L' FETCH LAST     t832_cs INTO g_pid.pid01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t832_cs INTO g_pid.pid01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0)
        INITIALIZE g_pid.* TO NULL  #TQC-6B0105
              #TQC-6B0105
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
    SELECT * INTO g_pid.* FROM pid_file WHERE pid01 = g_pid.pid01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","pid_file",g_pid.pid01,"",SQLCA.sqlcode,"",
                    "",1)  #No.FUN-660156
        INITIALIZE g_pid.* TO NULL
        RETURN
    END IF
 
 
 
    CALL t832_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t832_show()
    LET g_pid_t.* = g_pid.*                      #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_pid.pid01,g_pid.pid02,g_pid.pid03
 
    CALL t832_pid01('d')
    CALL t832_b_fill(g_wc2)                 #單身
# genero  script marked     LET g_pie_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t832_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_time          LIKE pie_file.pie33,    #No.FUN-690026 VARCHAR(10)
    l_cnt           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_pie30         LIKE pie_file.pie30,
    l_pie34         LIKE pie_file.pie34,
    l_pie35         LIKE pie_file.pie35,
    l_pie40         LIKE pie_file.pie40,
    l_pie44         LIKE pie_file.pie44,
    l_pie45         LIKE pie_file.pie45,
    l_sw            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-690026 SMALLINT
DEFINE  l_flag      LIKE type_file.chr1     #FUN-CB0087
DEFINE  l_sql       STRING                  #FUN-CB0087
DEFINE  l_where     STRING                  #FUN-CB0087
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_pid.pid01 IS NULL THEN
        RETURN
    END IF
    IF g_pid.pid02 IS NULL OR g_pid.pid02 = ' '
    THEN CALL cl_err(g_pid.pid01,'mfg2647',0)
         RETURN
    END IF
    SELECT count(*) INTO l_cnt FROM pie_file
                           WHERE (pie16 IN ('n','N') OR pie16 IS NULL)
                             AND pie02 IS NOT NULL AND pie02 != ' '
                             AND pie01 = g_pid.pid01
    IF l_cnt = 0
    THEN CALL cl_err(g_pid.pid01,'mfg0132',0)
         RETURN
    END IF
    IF g_pid.pid07 = 'N'
    THEN LET g_tagdate = g_today
         CALL t832_input()
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "SELECT pie07,pie02,'','',pie16,pie04,0,pie70,'',pie30,pie40,", #MOD-C70051 add pie16   #FUN-CB0087 add>pie70,''
     "         pie34,pie35,pie44,pie45 ",
     "  FROM pie_file ",
     "  WHERE pie01= ? ",
     "    AND pie07= ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t832_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_pie WITHOUT DEFAULTS FROM s_pie.*
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
            BEGIN WORK
#MOD-C70051---add---START
            IF g_pie[l_ac].pie16 ='Y' THEN #已過帳，不可更改
               CALL cl_err(g_pie[l_ac].pie16,'mfg0132',1)
               EXIT INPUT
            END IF 
#MOD-C70051---add-----END
            OPEN t832_cl USING g_pid.pid01
            IF STATUS THEN
               CALL cl_err("OPEN t832_cl:", STATUS, 1)
               CLOSE t832_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t832_cl INTO g_pid.*            # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                  CLOSE t832_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_pie_t.* = g_pie[l_ac].*  #BACKUP
 
                OPEN t832_bcl USING g_pid.pid01,g_pie_t.pie07
                IF STATUS THEN
                    CALL cl_err("OPEN t832_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t832_bcl INTO g_pie[l_ac].*,l_pie30,l_pie40,
                                        l_pie34,l_pie35,l_pie44,l_pie45
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pie_t.pie02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    IF g_argv1 ='1' THEN
                       LET g_pie[l_ac].qty = l_pie30
                       LET g_peo = l_pie34
                       LET g_tagdate = l_pie35
                    ELSE
                       LET g_pie[l_ac].qty = l_pie40
                       LET g_peo = l_pie44
                       LET g_tagdate = l_pie45
                    END IF
                END IF
                CALL t832_pie02(' ')           #for referenced field
                CALL t832_pie70()           #FUN-CB0087
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_argv1 = '1' THEN
               INSERT INTO pie_file(pie01,pie02,pie03,pie04,
                                    pie06,pie07,pie16,pie30,pie70,         #FUN-CB0087 add>pie70
                                    pie31,pie32,pie33,pie34,
                                    pie35,pieplant,pielegal,pie012,pie013) #FUN-980004 add pieplant,pielegal
                                                 #FUN-A70125 add pie012,pie013
                    VALUES(g_pid.pid01,g_pie[l_ac].pie02,
                           0,g_pie[l_ac].pie04,'N',
                           g_pie[l_ac].pie07,'N',
                           g_pie[l_ac].qty,g_pie[l_ac].pie70,g_user,g_today,     #FUN-CB0087 add>pie70
                           g_time,g_peo,g_tagdate,g_plant,g_legal,' ',0) #FUN-980004 add g_plant,g_legal
                                               #FUN-A70125 add ' ',0
            ELSE
               INSERT INTO pie_file(pie01,pie02,pie03,pie04,
                                    pie06,pie07,pie16,pie30,pie70,         #FUN-CB0087 add>pie70
                                    pie41,pie42,pie43,pie44,
                                    pie45,pieplant,pielegal,pie012,pie013) #FUN-980004 add pieplant,pielegal
                                              #FUN-A70125 add pie012,pie013
                    VALUES(g_pid.pid01,g_pie[l_ac].pie02,
                           0,g_pie[l_ac].pie04,'N',
                           g_pie[l_ac].pie07,'N',
                           g_pie[l_ac].qty,g_pie[l_ac].pie70,g_user,g_today,     #FUN-CB0087 add>pie70
                           g_time,g_peo,g_tagdate,g_plant,g_legal,' ',0) #FUN-980004 add g_plant,g_legal
                                             #FUN-A70125 add ' ',0
            END IF
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pie[l_ac].pie02,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("ins","pie_file",g_pid.pid01,g_pie[l_ac].pie02,SQLCA.sqlcode,"",
                            "",1)  #No.FUN-660156
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pie[l_ac].* TO NULL
            IF l_ac > 1 THEN
               LET g_pie[l_ac].qty = g_pie[l_ac-1].qty  #Body default
            END IF
            LET g_pie_t.* = g_pie[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pie07
 
        BEFORE FIELD pie07                        #default 序號
            IF g_pie[l_ac].pie07 IS NULL OR
               g_pie[l_ac].pie07 = 0 THEN
                SELECT max(pie07)+1
                   INTO g_pie[l_ac].pie07
                   FROM pie_file
                   WHERE pie01 = g_pid.pid01
                IF g_pie[l_ac].pie07 IS NULL THEN
                    LET g_pie[l_ac].pie07 = 1
                END IF
                DISPLAY g_pie[l_ac].pie07 TO s_pie[l_sl].pie07
            END IF
 
        AFTER FIELD pie07                        #check 序號是否重複
            IF g_pie[l_ac].pie07 IS NULL THEN
               LET g_pie[l_ac].pie07 = g_pie_t.pie07
            END IF
            IF g_pie[l_ac].pie07 != g_pie_t.pie07 OR
               g_pie_t.pie07 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM pie_file
                    WHERE pie01 = g_pid.pid01 AND
                          pie07 = g_pie[l_ac].pie07
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pie[l_ac].pie07 = g_pie_t.pie07
                    NEXT FIELD pie07
                END IF
            END IF
        #FUN-CB0087---add---str---
        AFTER FIELD pie02
           IF NOT t832_pie70_chk() THEN
              NEXT FIELD pie70
           END IF 
        #FUN-CB0087---add---end---
 
        BEFORE FIELD pie04		# 檢查料件編號是否輸入
           #IF p_cmd = 'u' THEN NEXT FIELD pie07 END IF #genero
            IF NOT cl_null(g_pie[l_ac].pie02) THEN
                CALL t832_pie02('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_pie[l_ac].pie02=g_pie_t.pie02
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_pie[l_ac].pie02
                    #------MOD-5A0095 END------------
                    NEXT FIELD pie02
                END IF
            END IF
 
        AFTER FIELD pie04  	
            IF NOT cl_null(g_pie[l_ac].pie04) THEN
               LET g_pie[l_ac].qty = s_digqty(g_pie[l_ac].qty,g_pie[l_ac].pie04)   #FUN-910088--add--
               DISPLAY BY NAME g_pie[l_ac].qty                                     #FUN-910088--add--
                CALL t832_pie04('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_pie[l_ac].pie04=g_pie_t.pie04
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_pie[l_ac].pie04
                    #------MOD-5A0095 END------------
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_pie[l_ac].qty
                #------MOD-5A0095 END------------
                    NEXT FIELD pie04
                END IF
            END IF
 
        BEFORE FIELD qty   	
            IF (g_pie[l_ac].qty IS NULL OR g_pie[l_ac].qty = ' ')
               AND l_ac > 1 THEN
                LET g_pie[l_ac].qty = g_pie[l_ac-1].qty
                DISPLAY g_pie[l_ac].qty TO qty #FUN-5B0137
            END IF
 
        AFTER FIELD qty                        #MOD-8C0300 add                                                                      
          #MOD-C50120 str add-----
           IF g_pie[l_ac].qty < 0 THEN
              LET g_pie[l_ac].qty = g_pie_t.qty
              NEXT FIELD qty
           END IF
          #MOD-C50120 end add-----
           LET g_pie[l_ac].qty = s_digqty(g_pie[l_ac].qty,g_pie[l_ac].pie04)   #FUN-910088--add--
           DISPLAY BY NAME g_pie[l_ac].qty     #MOD-8C0300 add
        #FUN-CB0087---add---str---
        BEFORE FIELD pie70
           IF g_aza.aza115 = 'Y' AND cl_null(g_pie[l_ac].pie70) THEN
              CALL s_reason_code(g_pid.pid01,g_pid.pid02,'',g_pie[l_ac].pie02,'','','') RETURNING g_pie[l_ac].pie70
              CALL t832_pie70()
              DISPLAY BY NAME g_pie[l_ac].pie70
           END IF
 
        AFTER FIELD pie70
           IF NOT t832_pie70_chk() THEN
              NEXT FIELD pie70
           ELSE      
              CALL t832_pie70()
           END IF
        #FUN-CB0087---add---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_pie_t.pie07 > 0 AND
               g_pie_t.pie07 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM pie_file
                    WHERE pie01 = g_pid.pid01
                      AND pie07 = g_pie_t.pie07
                IF SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_pie_t.pie07,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("del","pie_file",g_pid.pid01,g_pie_t.pie07,SQLCA.sqlcode,"",
                                "",1)  #No.FUN-660156
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pie[l_ac].* = g_pie_t.*
               CLOSE t832_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_pie[l_ac].pie07,-263,1)
                LET g_pie[l_ac].* = g_pie_t.*
            ELSE
                IF g_argv1 = '1' THEN
                    UPDATE pie_file SET
                             pie30 = g_pie[l_ac].qty,
                             pie70 = g_pie[l_ac].pie70,    #FUN-CB0087 add
                             pie31 = g_user,
                             pie32 = g_today,
                             pie33 = l_time,
                             pie34 = g_peo,
                             pie35 = g_tagdate,
                             pie44 = g_peo,
                             pie45 = g_tagdate
                     WHERE pie01= g_pid.pid01
                       AND pie07= g_pie_t.pie07
                ELSE
                    UPDATE pie_file SET
                             pie40 = g_pie[l_ac].qty,
                             pie70 = g_pie[l_ac].pie70,    #FUN-CB0087 add
                             pie41 = g_user,
                             pie42 = g_today,
                             pie43 = l_time,
                             pie34 = g_peo,
                             pie35 = g_tagdate,
                             pie44 = g_peo,
                             pie45 = g_tagdate
                     WHERE pie01= g_pid.pid01
                       AND pie07= g_pie_t.pie07
                END IF
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pie[l_ac].pie07,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("upd","pie_file",g_pid.pid01,g_pie_t.pie07,SQLCA.sqlcode,"",
                                "",1)  #No.FUN-660156
                    LET g_pie[l_ac].* = g_pie_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    UPDATE pid_file SET pid07 ='Y'
                     WHERE pid01 = g_pid.pid01
                    IF SQLCA.sqlcode THEN
                        ROLLBACK WORK
                    ELSE
                        COMMIT WORK
                    END IF
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_pie[l_ac].* = g_pie_t.*
                #FUN-D40030--add--str--
                ELSE
                   CALL g_pie.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D40030--add--end--
                END IF
                CLOSE t832_bcl
                ROLLBACK WORK
                EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t832_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pie02)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.default1 = g_pie[l_ac].pie02
                  #   CALL cl_create_qry() RETURNING g_pie[l_ac].pie02
                      CALL q_sel_ima(FALSE, "q_ima", "", g_pie[l_ac].pie02, "", "", "", "" ,"",'' )  RETURNING g_pie[l_ac].pie02
#FUN-AA0059 --End--
#                     CALL FGL_DIALOG_SETBUFFER( g_pie[l_ac].pie02 )
                     DISPLAY BY NAME g_pie[l_ac].pie02
                     CALL t832_pie02('a')
                WHEN INFIELD(pie04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.default1 = g_pie[l_ac].pie04
                     CALL cl_create_qry() RETURNING g_pie[l_ac].pie04
#                     CALL FGL_DIALOG_SETBUFFER( g_pie[l_ac].pie04 )
                     DISPLAY BY NAME g_pie[l_ac].pie04
                     CALL t832_pie04('a')
                WHEN INFIELD(qty)
                    CALL t832_input()
                    IF g_peo2 IS NOT NULL AND g_peo2 != ' '
                    THEN LET g_peo = g_peo2
                    END IF
                    IF g_tagdate2 IS NOT NULL AND g_tagdate2 != ' '
                    THEN LET g_tagdate = g_tagdate2
                    END IF
                #FUN-CB0087---add---str---
                WHEN INFIELD(pie70)
                    CALL s_get_where(g_pid.pid01,g_pid.pid02,'',g_pie[l_ac].pie02,'','','') RETURNING l_flag,l_where
                    IF g_aza.aza115='Y' AND l_flag THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_ggc08"
                       LET g_qryparam.where = l_where
                       LET g_qryparam.default1 = g_pie[l_ac].pie70
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_azf41"
                       LET g_qryparam.default1 = g_pie[l_ac].pie70
                    END IF
                    CALL cl_create_qry() RETURNING g_pie[l_ac].pie70
                    DISPLAY BY NAME g_pie[l_ac].pie70
                    CALL t832_pie70()
                    NEXT FIELD pie70
                #FUN-CB0087---add---end---
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION mntn_unit
                    CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
                    CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
                    CALL cl_cmdrun("aooi103 ")
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pie07) AND l_ac > 1 THEN
                LET g_pie[l_ac].* = g_pie[l_ac-1].*
                DISPLAY g_pie[l_ac].* TO s_pie[l_sl].*
                NEXT FIELD pie07
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
 
    CLOSE t832_bcl
    COMMIT WORK
END FUNCTION
 
#檢查料件編號
FUNCTION  t832_pie02(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ima63         LIKE ima_file.ima63,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima63,imaacti
        INTO g_pie[l_ac].ima02,g_pie[l_ac].ima021,l_ima63,l_imaacti
        FROM ima_file
        WHERE ima01 = g_pie[l_ac].pie02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET g_pie[l_ac].pie02 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
       #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       #FUN-690022------mod-------         
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_pie[l_ac].pie04 IS NULL OR g_pie[l_ac].pie04 = ' '
    THEN LET g_pie[l_ac].pie04 = l_ima63
       LET g_pie[l_ac].qty = s_digqty(g_pie[l_ac].qty,g_pie[l_ac].pie04)   #FUN-910088--add--
       DISPLAY BY NAME g_pie[l_ac].qty                                     #FUN-910088--add--
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY g_pie[l_ac].ima02  TO s_pie[l_sl].ima02
       DISPLAY g_pie[l_ac].ima021 TO s_pie[l_sl].ima021
       DISPLAY g_pie[l_ac].pie04  TO s_pie[l_sl].pie04
    END IF
END FUNCTION
 
#檢查單位
FUNCTION t832_pie04(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gfe02      LIKE gfe_file.gfe02,
           l_gfeacti    LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = g_pie[l_ac].pie04
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t832_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CLEAR ima02,ima021                           #清除FORMONLY欄位
    CONSTRUCT g_wc2 ON pie07,pie02,pie04
            FROM s_pie[1].pie07,s_pie[1].pie02,s_pie[1].pie04
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
    CALL t832_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t832_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(200)
    l_pie30         LIKE pie_file.pie30,
    l_pie40         LIKE pie_file.pie40
 
    LET g_sql =
        "SELECT pie07,pie02,ima02,ima021,pie16,pie04,0,pie70,azf03,", #MOD-C70051 add pie16     #FUN-CB0087 add>pie70,azf03
        "pie30,pie40",                           
        #" FROM pie_file,OUTER ima_file ",                              #FUN-CB0087 mark
        " FROM pie_file LEFT OUTER JOIN ima_file ON pie02 =ima01 ",     #FUN-CB0087 add
        "               LEFT OUTER JOIN azf_file ON pie70 =azf01 AND azf02='2' ",     #FUN-CB0087 add
        " WHERE pie01 ='",g_pid.pid01,"' AND ",  #單頭
        #" pie_file.pie02 = ima_file.ima01 AND ",                       #FUN-CB0087 mark
        p_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE t832_pb FROM g_sql
    DECLARE pie_curs                       #CURSOR
        CURSOR FOR t832_pb
 
    CALL g_pie.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH pie_curs INTO g_pie[g_cnt].*,l_pie30,l_pie40  #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_argv1 = '1' THEN
           LET g_pie[g_cnt].qty = l_pie30
        ELSE
           LET g_pie[g_cnt].qty = l_pie40
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_pie.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t832_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pie TO s_pie.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t832_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t832_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t832_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t832_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t832_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 快速輸入
    # ON ACTION quick_input
    #    LET g_action_choice="quick_input"
    #    EXIT DISPLAY
 
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
      
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY            
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t832_input()
 
    LET p_row = 2 LET p_col = 46
    OPEN WINDOW t830_w AT p_row,p_col
      WITH FORM "aim/42f/aimt830"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt830")
 
    LET g_tagdate2 = g_tagdate
    LET g_peo2     = g_peo
    CALL t832_peo('a')
    INPUT g_peo2,g_tagdate2 WITHOUT DEFAULTS
     FROM peo,tagdate
       AFTER FIELD peo
            IF g_peo2 IS NOT NULL AND g_peo2 !=' ' THEN
               CALL t832_peo('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_peo2,g_errno,0)
                  NEXT FIELD peo
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(peo)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_peo2
                  CALL cl_create_qry() RETURNING g_peo2
                  DISPLAY g_peo2 TO FORMONLY.peo
    	          CALL t832_peo('d')
                  NEXT FIELD peo
               OTHERWISE EXIT CASE
            END CASE
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        #-----END TQC-860018-----
 
    END INPUT
    CLOSE WINDOW t830_w
END FUNCTION
 
FUNCTION t832_peo(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gen02      LIKE gen_file.gen02,
           l_genacti    LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_peo2
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION t832_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("pid01,pid02,pid03,pid022,pid023",TRUE)
   END IF
   DISPLAY "set_entry"
END FUNCTION
 
FUNCTION t832_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF NOT g_before_input_done and g_chkey = 'N' THEN  #MOD-420449
      IF (p_cmd='u' and NOT cl_null(g_pid.pid02) AND g_pid.pid06='N') THEN
          CALL cl_set_comp_entry("pid01,pid02,pid03,pid022,pid023",FALSE)
          DISPLAY "set_no_entry(1)"
      END IF
      IF p_cmd='u'AND g_pid.pid06='Y' THEN
          CALL cl_set_comp_entry("pid01",FALSE)
          DISPLAY "set_no_entry(2)"
      END IF
   END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <003,004,001> #
#FUN-CB0087---add---str---
FUNCTION t832_pie70()
IF NOT cl_null(g_pie[l_ac].pie70) THEN       #TQC-D20042
   SELECT azf03 INTO g_pie[l_ac].azf03
     FROM azf_file
    WHERE azf01 = g_pie[l_ac].pie70
      AND azf02 = '2'
ELSE                                         #TQC-D20042
   LET g_pie[l_ac].azf03 = ' '               #TQC-D20042
END IF                                       #TQC-D20042
   DISPLAY BY NAME g_pie[l_ac].azf03
END FUNCTION

FUNCTION t832_pie70_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING
   IF g_pie[l_ac].pie70 IS NOT NULL THEN
      LET l_n = 0
      LET l_flag= FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(g_pid.pid01,g_pid.pid02,'',g_pie[l_ac].pie02,'','','') RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pie[l_ac].pie70,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_pie[l_ac].pie70,'aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_pie[l_ac].pie70 AND azf02='2'
         IF l_n < 1 THEN
            CALL cl_err(g_pie[l_ac].pie70,'aim-425',0)
            RETURN FALSE
         END IF
      END IF
   ELSE                                         #TQC-D20042
      LET g_pie[l_ac].azf03 = ' '               #TQC-D20042
      DISPLAY BY NAME g_pie[l_ac].azf03         #TQC-D20042
   END IF
   RETURN TRUE  
END FUNCTION
#FUN-CB0087---add---end---

