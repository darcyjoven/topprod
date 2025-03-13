# Prog. Version..: '5.30.07-13.06.07(00004)'     #
#
# Pattern name...: abas010.4gl
# Descriptions...: 條碼管理系統參數作業
# Date & Author..: No:DEV-CB0008 2012/11/12 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.DEV-D30038 2013/03/21 By TSD.JIE 預設報表類型(ibd07 )： 1：一般條碼 2：包裝單條碼 3：純條碼
# Modify.........: No.DEV-D40012 2013/04/12 By Nina 新增欄位：條碼掃描對應來源項次的排序方式(ibd08)、自動產生出貨單(ibd09)、自動產生入庫單(ibd10)    
# Modify.........: No.FUN-D40103 2013/05/07 By fengrui 添加庫位有效性檢查 

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線

GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義

DEFINE g_ibd                 RECORD LIKE ibd_file.*      #備份舊值
DEFINE g_ibd_t               RECORD LIKE ibd_file.*      #備份舊值
DEFINE g_ibd01_t              LIKE ibd_file.ibd01      #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗

MAIN

    OPTIONS
#       FIELD ORDER FORM,                      #依照FORM上面的順序定義做欄位跳動 (預設為依指令順序)
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔

   IF (NOT cl_setup("ABA")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF


   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_ibd.* TO NULL

   LET g_forupd_sql = "SELECT * FROM ibd_file ",
                      " WHERE ibd01 = '0' FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE s010_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW s010_w WITH FORM "aba/42f/abas010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   CALL s010_show()

   LET g_action_choice = ""
   CALL s010_menu()                                         #進入選單 Menu

   CLOSE WINDOW s010_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN




FUNCTION s010_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL s010_u()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about
           CALL cl_about()

        ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU

        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_ibd.ibd01 IS NOT NULL THEN
                 LET g_doc.column1 = "ibd01"
                 LET g_doc.value1 = '0'
                 CALL cl_doc()
              END IF
           END IF
    END MENU
END FUNCTION


FUNCTION s010_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_cnt         LIKE type_file.num5

   INPUT BY NAME
      g_ibd.ibd02,g_ibd.ibd03,
      g_ibd.ibd04,g_ibd.ibd05,g_ibd.ibd06
     ,g_ibd.ibd07 #DEV-D30038
     ,g_ibd.ibd08,g_ibd.ibd09,g_ibd.ibd10 #DEV-D40004 add
      WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s010_set_entry(p_cmd)
         CALL s010_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
        #DEV-D40012 add str-----
         IF cl_null(g_ibd.ibd08) THEN LET g_ibd.ibd08 = '1' END IF
         IF cl_null(g_ibd.ibd09) THEN LET g_ibd.ibd09 = 'N' END IF
         IF cl_null(g_ibd.ibd10) THEN LET g_ibd.ibd10 = 'N' END IF
        #DEV-D40012 add end-----

      AFTER FIELD ibd03
         IF NOT cl_null(g_ibd.ibd03) THEN
            IF g_ibd.ibd03 != ' ' THEN
               CALL s010_ibd03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('ibd03:',g_errno,1)
                  NEXT FIELD CURRENT
               END IF
            END IF

            LET l_cnt = 0
            SELECT count(*) INTO l_cnt  FROM jce_file
             WHERE jce02 = g_ibd.ibd03
            IF l_cnt > 0 THEN
               LET g_ibd.ibd03 = ''
               DISPLAY BY NAME g_ibd.ibd03
               CALL cl_err('','axm-065',0)
               NEXT FIELD CURRENT
            END IF
         END IF
         IF cl_null(g_ibd.ibd03) THEN LET g_ibd.ibd03 = ' ' END IF
         IF NOT s_imechk(g_ibd.ibd03,g_ibd.ibd04) THEN NEXT FIELD ibd04 END IF  #FUN-D40103 add 

      AFTER FIELD ibd04
         #FUN-D40103--mark--str--
         #IF NOT cl_null(g_ibd.ibd04) THEN
         #   SELECT * FROM ime_file 
         #    WHERE ime01=g_ibd.ibd03
         #      AND ime02=g_ibd.ibd04
         #   IF SQLCA.SQLCODE THEN
         #      CALL cl_err3("sel","ime_file",g_ibd.ibd04,"",'mfg1101',"","",0)
         #      NEXT FIELD ibd04
         #   END IF
         #END IF
         #FUN-D40103--mark--end--
         IF cl_null(g_ibd.ibd04) THEN LET g_ibd.ibd04 = ' ' END IF
         IF NOT s_imechk(g_ibd.ibd03,g_ibd.ibd04) THEN NEXT FIELD ibd04 END IF  #FUN-D40103 add 

      AFTER FIELD ibd06
         IF NOT cl_null(g_ibd.ibd06) THEN
            CALL s010_ibd06()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('ibd06:',g_errno,1)
               NEXT FIELD CURRENT
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(ibd03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imd"
              LET g_qryparam.arg1 = 'SW'        #倉庫類別
              LET g_qryparam.default1 = g_ibd.ibd03
              CALL cl_create_qry() RETURNING g_ibd.ibd03
              DISPLAY BY NAME g_ibd.ibd03
              NEXT FIELD ibd03
           WHEN INFIELD(ibd04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ime"
              LET g_qryparam.arg1 = g_ibd.ibd03
              LET g_qryparam.arg2 = 'SW'
              LET g_qryparam.default1 = g_ibd.ibd04
              CALL cl_create_qry() RETURNING g_ibd.ibd04
              DISPLAY BY NAME g_ibd.ibd04
              NEXT FIELD ibd04
           WHEN INFIELD(ibd06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ibe"
              LET g_qryparam.arg1 = '2'
              LET g_qryparam.default1 = g_ibd.ibd06
              CALL cl_create_qry() RETURNING g_ibd.ibd06
              DISPLAY BY NAME g_ibd.ibd06
              NEXT FIELD ibd06

           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT
END FUNCTION


FUNCTION s010_ibd03()
   DEFINE l_imd                 RECORD LIKE imd_file.*
   SELECT * INTO l_imd.*
     FROM imd_file
    WHERE imd01 = g_ibd.ibd03
   CASE
       WHEN SQLCA.sqlcode=100                 LET g_errno='mfg1100'
                                              INITIALIZE l_imd.* TO NULL
       WHEN l_imd.imdacti != 'Y'              LET g_errno='9028'
       WHEN NOT (l_imd.imd11 MATCHES '[Yy]')  LET g_errno='axm-993'
       WHEN NOT (l_imd.imd10 MATCHES '[Ww]')  LET g_errno='axm-666'
       WHEN NOT (l_imd.imd12 MATCHES '[Nn]')  LET g_errno='axm-067'
       OTHERWISE                              LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

END FUNCTION

FUNCTION s010_ibd06()
   DEFINE l_ibe                 RECORD LIKE ibe_file.*
   SELECT * INTO l_ibe.*
     FROM ibe_file
    WHERE ibeslip = g_ibd.ibd06
   CASE
       WHEN SQLCA.sqlcode=100         LET g_errno='afa-094'
                                      INITIALIZE l_ibe.* TO NULL
       WHEN l_ibe.ibetype != '2'      LET g_errno='aba-099'
       OTHERWISE                      LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

END FUNCTION



FUNCTION s010_show()
    SELECT * INTO g_ibd.* FROM ibd_file
       WHERE ibd01 = '0'
    IF SQLCA.sqlcode THEN
       LET g_ibd.ibd01 = '0'
       LET g_ibd.ibd02 = 'N'
       LET g_ibd.ibd03 = ' '
       LET g_ibd.ibd04 = ' '
       LET g_ibd.ibd05 = 'N'
       LET g_ibd.ibd07 = '3' #DEV-D30037
      #DEV-D40004 add str--------
       LET g_ibd.ibd08 = '1' 
       LET g_ibd.ibd09 = 'N' 
       LET g_ibd.ibd10 = 'N' 
      #DEV-D40004 add end--------
       INSERT INTO ibd_file VALUES(g_ibd.*)
       IF SQLCA.sqlcode THEN
           CALL cl_err3("isn","ibd_file",g_ibd.ibd01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
       END IF
    END IF

    LET g_ibd_t.* = g_ibd.*

    DISPLAY BY NAME g_ibd.ibd02,g_ibd.ibd03,g_ibd.ibd04,
                    g_ibd.ibd05,g_ibd.ibd06
                   ,g_ibd.ibd07 #DEV-D30038
                   ,g_ibd.ibd08,g_ibd.ibd09,g_ibd.ibd10 #DEV-D40004 add
    CALL cl_show_fld_cont()
END FUNCTION



FUNCTION s010_u()
    SELECT * INTO g_ibd.* FROM ibd_file
     WHERE ibd01='0'

    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN s010_cl
    IF STATUS THEN
       CALL cl_err("OPEN s010_cl:", STATUS, 1)
       CLOSE s010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s010_cl INTO g_ibd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ibd.ibd01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL s010_show()                          # 顯示最新資料
    WHILE TRUE
        CALL s010_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ibd.*=g_ibd_t.*
            CALL s010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_ibd.ibd03) THEN LET g_ibd.ibd03 = ' ' END IF
        IF cl_null(g_ibd.ibd04) THEN LET g_ibd.ibd04 = ' ' END IF
        UPDATE ibd_file SET ibd_file.* = g_ibd.*    # 更新DB
         WHERE ibd01 = '0'
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ibd_file",g_ibd.ibd01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s010_cl
    COMMIT WORK
END FUNCTION


FUNCTION s010_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

END FUNCTION


FUNCTION s010_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

END FUNCTION
#DEV-CB0008--add
#DEV-D30025--add

