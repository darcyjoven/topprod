# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: awsi002.4gl
# Descriptions...: 
# Date & Author..: 06/08/01 By yoyo
# Modify.........: 新建立 FUN-8A0122
# Modify.........: 08/10/20 By binbin for generate aws_ttsrv2_case.4gl 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940023 09/04/07 By Vicky 調整 FUNCTION i002_case() 缺行，並改為不寫死版號
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950058 09/05/11 By Vicky 調整 FUNCTION i002_case() 改為不加 "Prog. Version
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 環境變數改為以FGL_GETENV取得
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cmd           LIKE type_file.chr200,
    g_waa           RECORD LIKE waa_file.*,
    g_waa_t         RECORD LIKE waa_file.*,
    g_waa_o         RECORD LIKE waa_file.*,
    g_waa01_t       LIKE waa_file.waa01,
    g_t1            LIKE type_file.chr5,
    g_wab           DYNAMIC ARRAY OF RECORD
        wab09       LIKE wab_file.wab09,
        wab02       LIKE wab_file.wab02,
        wab03       LIKE wab_file.wab03,
        wab04       LIKE wab_file.wab04,
        wab05       LIKE wab_file.wab05,
#       wab06       LIKE wab_file.wab06,
        wab07       LIKE wab_file.wab07,
        wab08       LIKE wab_file.wab08 
                    END RECORD,
    g_wab_t         RECORD       #程式變數(Program Variables)
        wab09       LIKE wab_file.wab09,
        wab02       LIKE wab_file.wab02,
        wab03       LIKE wab_file.wab03,
        wab04       LIKE wab_file.wab04,
        wab05       LIKE wab_file.wab05,
#       wab06       LIKE wab_file.wab06,
        wab07       LIKE wab_file.wab07,
        wab08       LIKE wab_file.wab08 
                    END RECORD,
    g_wab_o         RECORD       #程式變數(Program Variables)
        wab09       LIKE wab_file.wab09,
        wab02       LIKE wab_file.wab02,
        wab03       LIKE wab_file.wab03,
        wab04       LIKE wab_file.wab04,
        wab05       LIKE wab_file.wab05,
#       wab06       LIKE wab_file.wab06,
        wab07       LIKE wab_file.wab07,
        wab08       LIKE wab_file.wab08 
                    END RECORD,
    g_wam           DYNAMIC ARRAY OF RECORD
        wam01       LIKE wam_file.wam01,
        wam02       LIKE wam_file.wam02,
        wam03       LIKE wam_file.wam03 
                    END RECORD,
    g_wam_t         RECORD       #程式變數(Program Variables)
        wam01       LIKE wam_file.wam01,
        wam02       LIKE wam_file.wam02,
        wam03       LIKE wam_file.wam03 
                    END RECORD,
    g_wam_o         RECORD       #程式變數(Program Variables)
        wam01       LIKE wam_file.wam01,
        wam02       LIKE wam_file.wam02,
        wam03       LIKE wam_file.wam03 
                    END RECORD,
    g_wc,g_wc1,g_wc2,g_sql  STRING,
    g_rec_b         LIKE type_file.num5,
    g_rec_b2        LIKE type_file.num5,
    l_ac            LIKE type_file.num5                      #目前處理的ARRAY CNT
DEFINE   g_forupd_sql STRING 
DEFINE   g_forupd_sql1 STRING                 #SELECT ... FOR UPDATE  SQL
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_cnt          LIKE type_file.num20
DEFINE   g_i            LIKE type_file.num5             #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr100
DEFINE   g_curs_index   LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num5               #總筆數
DEFINE   g_jump         LIKE type_file.num20              #查詢指定的筆數
DEFINE   g_no_ask       LIKE type_file.num5            #是否開啟指定筆視窗
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = " SELECT * FROM waa_file WHERE waa01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i002_w WITH FORM "aws/42f/awsi002"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL i002_menu()
   CLOSE WINDOW i002_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i002_cs()
#DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_wab.clear()
   CALL g_wam.clear()
#   CONSTRUCT BY NAME g_wc ON waa01,waa02,waa03,
#                             waa04,waa05,waa06,waa07
   CONSTRUCT BY NAME g_wc ON waa01,waa02,waa03,
                             waa04,waa05,waa06
 
      #No.FUN-580031 --start--     HCN
#     BEFORE CONSTRUCT
#        CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(waa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_waa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 IF NOT cl_null(g_qryparam.multiret) THEN
                 DISPLAY g_qryparam.multiret TO waa01
                 END IF
                 NEXT FIELD waa01
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      #No.FUN-580031 --start--     HCN
#     ON ACTION qbe_select
#         CALL cl_qbe_list() RETURNING lc_qbe_sn
#         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
#   CONSTRUCT g_wc2 ON wab02,wab03,wab04,wab05,wab06,wab07,wab08
#           FROM s_wab[1].wab02,s_wab[1].wab03,s_wab[1].wab04,
#                s_wab[1].wab05,s_wab[1].wab06,s_wab[1].wab07,
#                s_wab[1].wab08
   CONSTRUCT g_wc2 ON wab09,wab02,wab03,wab04,wab05,wab07,wab08
           FROM s_wab[1].wab09,s_wab[1].wab02,s_wab[1].wab03,s_wab[1].wab04,
                s_wab[1].wab05,s_wab[1].wab07,
                s_wab[1].wab08
 
     #No.FUN-580031 --start--     HCN
#    BEFORE CONSTRUCT
#        CALL cl_qbe_display_condition(lc_qbe_sn)
     #No.FUN-580031 --end--       HCN
 
     ON ACTION controlp
         CASE
           WHEN INFIELD(wab02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_gat1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 IF NOT cl_null(g_qryparam.multiret) THEN
                 DISPLAY g_qryparam.multiret TO wab02
                 END IF
                 NEXT FIELD wab02
           WHEN INFIELD(wab04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_gat1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 IF NOT cl_null(g_qryparam.multiret) THEN
                 DISPLAY g_qryparam.multiret TO wab04
                 END IF
                 NEXT FIELD wab04
           WHEN INFIELD(wab05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_gat1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 IF NOT cl_null(g_qryparam.multiret) THEN
                 DISPLAY g_qryparam.multiret TO wab05
                 END IF
                 NEXT FIELD wab05
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      #No.FUN-580031 --start--     HCN
#     ON ACTION qbe_save
#         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  waa01 FROM waa_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY waa01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE waa01 ",
                  "  FROM waa_file, wab_file ",
                  " WHERE waa01 = wab01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY waa01"
   END IF
 
   PREPARE i002_prepare FROM g_sql
   DECLARE i002_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i002_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT count(*) FROM waa_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT count(DISTINCT waa01) FROM waa_file,wab_file WHERE ",
                "waa01=wab01 AND",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i002_precount FROM g_sql
   DECLARE i002_count CURSOR FOR i002_precount
 
 
END FUNCTION
 
FUNCTION i002_menu()
 
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i002_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i002_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i002_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i002_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "Second_Body"
            IF cl_chk_act_auth() THEN
               CALL i002_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
           IF cl_chk_act_auth()  THEN
              IF g_waa.waa01 IS NOT NULL THEN
                 LET g_doc.column1 = "waa01"
                 LET g_doc.value1 = g_waa.waa01
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_wab),'','')
            END IF
         WHEN "fieldhold"
            LET g_cmd="awsi003 '",g_waa.waa01 clipped,"'"
            CALL cl_cmdrun(g_cmd)
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i002_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num20
 
   MESSAGE ""
   CLEAR FORM
   CALL g_wab.clear()
   CALL g_wam.clear()
    LET g_wc = NULL
    LET g_wc2= NULL
    LET g_wc1= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_waa.* LIKE waa_file.*             #DEFAULT 設定
   LET g_waa01_t = NULL
 
 
   #預設值及將數值類變數清成零
   LET g_waa_t.* = g_waa.*
   LET g_waa_o.* = g_waa.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
         LET g_waa.waa04="Y"
         LET g_waa.waa05="Y"
         LET g_waa.waa06="Y"
         LET g_waa.waa07="N"
 
      CALL i002_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_waa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_waa.waa01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
 
      BEGIN WORK
 
      INSERT INTO waa_file 
       VALUES (g_waa.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err(g_waa.waa01,SQLCA.sqlcode,1)    #FUN-B80064    ADD
         ROLLBACK WORK
        # CALL cl_err(g_waa.waa01,SQLCA.sqlcode,1)   #FUN-B80064    MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_waa.waa01,'I')
      END IF
 
      SELECT waa01 INTO g_waa.waa01 FROM waa_file
       WHERE waa01 = g_waa.waa01
      LET g_waa01_t = g_waa.waa01        #保留舊值
      LET g_waa_t.* = g_waa.*
      LET g_waa_o.* = g_waa.*
      CALL g_wab.clear()
 
      LET g_rec_b = 0
      CALL i002_b()                   #輸入單身
      CALL g_wam.clear()
      LET g_rec_b2 = 0
      CALL i002_b2()                   #輸入第二單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i002_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_waa.waa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_waa.* FROM waa_file
    WHERE waa01=g_waa.waa01
 
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_waa01_t = g_waa.waa01
   BEGIN WORK
 
   OPEN i002_cl USING g_waa.waa01
   IF STATUS THEN
      CALL cl_err("OPEN i002_cl:", STATUS, 1)
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i002_cl INTO g_waa.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i002_show()
 
   WHILE TRUE
      LET g_waa01_t = g_waa.waa01
      LET g_waa_o.* = g_waa.*
 
      CALL i002_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_waa.*=g_waa_t.*
         CALL i002_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_waa.waa01 != g_waa01_t THEN
         UPDATE wab_file SET wab01 = g_waa.waa01
          WHERE wab01 = g_waa01_t 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('wab',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE waa_file SET waa_file.* = g_waa.*
       WHERE waa01 = g_waa.waa01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i002_cl
   COMMIT WORK
   CALL cl_flow_notify(g_waa.waa01,'U')
 
END FUNCTION
 
FUNCTION i002_i(p_cmd)
DEFINE
   l_n            LIKE type_file.num5,
   p_cmd           LIKE type_file.chr1                #a:輸入 u:更改
   DEFINE   li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
#   INPUT BY NAME g_waa.waa01,g_waa.waa02,g_waa.waa03,g_waa.waa04,
#                 g_waa.waa05,g_waa.waa06,g_waa.waa07
   INPUT BY NAME g_waa.waa01,g_waa.waa02,g_waa.waa03,g_waa.waa04,
                 g_waa.waa05,g_waa.waa06
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_waa.waa04="Y"
         LET g_waa.waa05="Y"
         LET g_waa.waa06="Y"
#         LET g_waa.waa07="Y"
         LET g_before_input_done = FALSE
         CALL i002_set_entry(p_cmd)
         CALL i002_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD waa01
         IF NOT cl_null(g_waa.waa01)  THEN
            IF g_waa_o.waa01 IS NULL OR
               (g_waa.waa01 != g_waa_o.waa01) THEN
               SELECT count(*) INTO l_n FROM waa_file
                WHERE waa01 = g_waa.waa01
               IF l_n > 0 THEN   #重復
                  CALL cl_err(g_waa.waa01,-239,0)
                  LET g_waa.waa01 = g_waa01_t
                  DISPLAY BY NAME g_waa.waa01
                  NEXT FIELD waa01
               END IF
            END IF
         END IF
         
        
      ON ACTION controlp
         CASE
          WHEN INFIELD(waa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_wac"
               LET g_qryparam.default1 = g_waa.waa01
               CALL cl_create_qry() RETURNING g_waa.waa01
               IF NOT cl_null(g_waa.waa01) THEN
               DISPLAY BY NAME g_waa.waa01
               END IF
               NEXT FIELD waa01
         END CASE 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
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
 
FUNCTION i002_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_wab.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i002_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_waa.* TO NULL
      RETURN
   END IF
 
   OPEN i002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_waa.* TO NULL
   ELSE
      OPEN i002_count
      FETCH i002_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i002_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
FUNCTION i002_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i002_cs INTO g_waa.waa01
      WHEN 'P' FETCH PREVIOUS i002_cs INTO g_waa.waa01
      WHEN 'F' FETCH FIRST    i002_cs INTO g_waa.waa01
      WHEN 'L' FETCH LAST     i002_cs INTO g_waa.waa01
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i002_cs INTO g_waa.waa01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
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
      DISPLAY g_curs_index TO FORMONLY.cn2
   END IF
 
   SELECT * INTO g_waa.* FROM waa_file WHERE waa01 = g_waa.waa01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)
      INITIALIZE g_waa.* TO NULL
      RETURN
   END IF
 
 
   CALL i002_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i002_show()
   LET g_waa_t.* = g_waa.*                #保存單頭舊值
   LET g_waa_o.* = g_waa.*                #保存單頭舊值
   DISPLAY BY NAME g_waa.waa01,g_waa.waa02,g_waa.waa03,
                   g_waa.waa04,g_waa.waa05,g_waa.waa06
#                   g_waa.waa07
 
   CALL i002_b_fill(g_wc2)                 #單身
   CALL i002_b2_fill(g_wc1)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i002_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_waa.waa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_waa.* FROM waa_file
    WHERE waa01=g_waa.waa01
   BEGIN WORK
 
   OPEN i002_cl USING g_waa.waa01
   IF STATUS THEN
      CALL cl_err("OPEN i002_cl:", STATUS, 1)
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i002_cl INTO g_waa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i002_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "waa01"         #No.FUN-9B0098 10/02/24
      DELETE FROM waa_file WHERE waa01 = g_waa.waa01 
      DELETE FROM wab_file WHERE wab01 = g_waa.waa01 
      DELETE FROM wam_file WHERE wam01 = g_waa.waa01 
      CLEAR FORM
      CALL g_wab.clear()
      OPEN i002_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i002_cs
         CLOSE i002_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i002_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i002_cs
         CLOSE i002_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i002_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i002_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i002_fetch('/')
      END IF
   END IF
 
   CLOSE i002_cl
   COMMIT WORK
   CALL cl_flow_notify(g_waa.waa01,'D')
END FUNCTION
 
#單身
FUNCTION i002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重復用
    l_ns            LIKE type_file.num5,              #檢查重復用
    l_cnt           LIKE type_file.num5,              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
    p_cmd           LIKE type_file.chr1,               #處理狀態
    l_misc          LIKE type_file.chr4,              #
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5,               #可刪除否
    l_num           LIKE type_file.num5,
    l_gat03         LIKE gat_file.gat03,
    l_sql           STRING
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_waa.waa01 IS NULL  THEN
       RETURN
    END IF
 
    SELECT * INTO g_waa.* FROM waa_file
     WHERE waa01=g_waa.waa01
 
    CALL cl_opmsg('b')
 
#    LET g_forupd_sql = "SELECT wab02,wab03,wab04,wab05,wab06,wab07,wab08",
#                       "  FROM wab_file",
#                       " WHERE wab01=? AND wab02=? AND wab05=?  FOR UPDATE"
    LET g_forupd_sql = "SELECT wab09,wab02,wab03,wab04,wab05,wab07,wab08",
                       "  FROM wab_file",
                       " WHERE wab01=? AND wab09=? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET g_forupd_sql1 = " SELECT wab09,wab02,wab03,wab04,wab05,wab07,wab08",
                        " FROM wab_file",
                        " WHERE wab01 =? AND wab02 = ? AND wab09=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bc2 CURSOR FROM g_forupd_sql1 
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_wab WITHOUT DEFAULTS FROM s_wab.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           #DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           CALL cl_set_comp_entry("wab03",FALSE)
 
        BEFORE ROW
           #DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i002_cl USING g_waa.waa01
           IF STATUS THEN
              CALL cl_err("OPEN i002_cl:", STATUS, 1)
              CLOSE i002_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i002_cl INTO g_waa.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i002_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_wab_t.* = g_wab[l_ac].*  #BACKUP
              LET g_wab_o.* = g_wab[l_ac].*  #BACKUP
              IF cl_null(g_wab[l_ac].wab05) THEN
                 OPEN i002_bcl USING g_waa.waa01,g_wab_t.wab09 
                 IF STATUS THEN
                    CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i002_bcl INTO g_wab[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_wab_t.wab02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
              ELSE
                 OPEN i002_bc2 USING g_waa.waa01,g_wab_t.wab02,g_wab_t.wab09 
                 IF STATUS THEN
                    CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i002_bc2 INTO g_wab[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_wab_t.wab02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
              END IF   
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           #DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_wab[l_ac].* TO NULL
           LET g_wab_t.* = g_wab[l_ac].*         #新輸入資料
           LET g_wab_o.* = g_wab[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD wab02
 
        AFTER INSERT
           #DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_wab[l_ac].wab02) AND NOT cl_null(g_wab[l_ac].wab04) 
              AND NOT cl_null(g_wab[l_ac].wab07) AND NOT cl_null(g_wab[l_ac].wab08) THEN
              LET l_ns=0
              SELECT count(*) INTO l_ns FROM wab_file 
               WHERE wab01 = g_waa.waa01
                 AND wab02 = g_wab[l_ac].wab02
                 AND wab04 = g_wab[l_ac].wab04
                 AND wab05 = g_wab[l_ac].wab05
                 AND wab07 = g_wab[l_ac].wab07
                 AND wab08 = g_wab[l_ac].wab08
           END IF
           IF l_ns > 0 THEN
              CALL cl_err('',-239,0)
              CANCEL INSERT
           END IF
           LET l_ns=0
           SELECT count(*) INTO l_ns FROM wab_file 
            WHERE wab01 = g_waa.waa01
              AND wab09 = g_wab[l_ac].wab09
           IF l_ns > 0 THEN
              CALL cl_err('',-239,0)
              CANCEL INSERT
           END IF
           INSERT INTO wab_file(wab01,wab02,wab03,wab04,wab05,wab06,
                                wab07,wab08,wab09)
           VALUES(g_waa.waa01,g_wab[l_ac].wab02,
                  g_wab[l_ac].wab03,g_wab[l_ac].wab04,
                  g_wab[l_ac].wab05,'N',
                  g_wab[l_ac].wab07,g_wab[l_ac].wab08,g_wab[l_ac].wab09)
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_wab[l_ac].wab02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD wab02      
           IF cl_null(g_wab[l_ac].wab02) OR g_wab[l_ac].wab02=0 THEN
              SELECT COUNT(*) INTO l_n FROM wab_file WHERE wab01=g_waa.waa01
              IF l_n = 0 THEN
                 LET g_wab[l_ac].wab09 = 1 
              ELSE
                 SELECT max(wab09)+1 INTO g_wab[l_ac].wab09
                   FROM wab_file WHERE wab01=g_waa.waa01
              END IF
           END IF
 
        AFTER FIELD wab02                        #check 序號是否重復
           IF NOT cl_null(g_wab[l_ac].wab02) THEN
              IF g_wab[l_ac].wab02 != g_wab_t.wab02
                 OR g_wab_t.wab02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM zta_file
                  WHERE zta01 = g_wab[l_ac].wab02
#-- BEGINE  --
#                 SELECT COUNT(*)
#                    INTO l_n
#                    FROM wac_file
#                   WHERE wac02 = g_wab[l_ac].wab02  
#-- END     --
                 IF l_n = 0 THEN
                    CALL cl_err('','mfg9329',0)
                    LET g_wab[l_ac].wab02 = g_wab_t.wab02
                    NEXT FIELD wab02
                 ELSE
                    IF p_cmd='a' THEN
                       SELECT gat03 INTO g_wab[l_ac].wab03
                         FROM gat_file
                        WHERE gat01 = g_wab[l_ac].wab02 AND gat02=g_lang
                       IF cl_null(g_wab[l_ac].wab03) THEN
                          CALL cl_set_comp_entry("wab03",TRUE)
                       END IF
                       DISPLAY BY NAME g_wab[l_ac].wab02
                       DISPLAY BY NAME g_wab[l_ac].wab03
                       LET l_ns = 0 
                       SELECT COUNT(*) INTO l_ns FROM wab_file
                        WHERE wab01=g_waa.waa01 AND wab09=g_wab[l_ac].wab09
                       IF l_ns > 0 THEN
                          CALL cl_err('',-239,0)
                          NEXT FIELD wab09
                       END IF
                    ELSE
                       IF g_wab[l_ac].wab02 != g_wab_t.wab02 THEN
                          SELECT gat03 INTO g_wab[l_ac].wab03
                            FROM gat_file
                           WHERE gat01 = g_wab[l_ac].wab02 AND gat02=g_lang
                          IF cl_null(g_wab[l_ac].wab03) THEN
                             CALL cl_set_comp_entry("wab03",TRUE)
                          END IF
                          DISPLAY BY NAME g_wab[l_ac].wab02
                          DISPLAY BY NAME g_wab[l_ac].wab03
                       END IF
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD wab04
           IF NOT cl_null(g_wab[l_ac].wab04) THEN
              IF g_wab_o.wab04 IS NULL OR
                (g_wab[l_ac].wab04 != g_wab_o.wab04 ) THEN
                  SELECT count(*)
                    INTO l_n
                    FROM zta_file
                   WHERE zta01 = g_wab[l_ac].wab04
#-- BEGIN   --
#                SELECT COUNT(*) 
#                   INTO l_n
#                   FROM wac_file
#                  WHERE wac02 = g_wab[l_ac].wab02 
#-- END     -- 
                 IF l_n = 0 THEN
                    CALL cl_err('','mfg9329',0)
                    LET g_wab[l_ac].wab04 = g_wab_t.wab04
                    NEXT FIELD wab04
                 END IF
                 IF g_wab[l_ac].wab04 = g_wab[l_ac].wab02 THEN
                    LET g_wab[l_ac].wab04 = g_wab_t.wab04
                    CALL cl_err('','aws-152',0)
                    NEXT FIELD wab04
                 END IF
              END IF
           END IF
 
        AFTER FIELD wab05
           IF NOT cl_null(g_wab[l_ac].wab05) THEN
              IF g_wab_o.wab05 IS NULL OR
                (g_wab[l_ac].wab05 != g_wab_o.wab05 ) THEN
                  SELECT count(*)
                    INTO l_n
                    FROM zta_file
                   WHERE zta01 = g_wab[l_ac].wab05
# -- BEGIN  --
#                SELECT COUNT(*) 
#                   INTO l_n
#                   FROM wac_file
#                  WHERE wac02 = g_wab[l_ac].wab02 
# -- END    -- 
                 IF l_n = 0 THEN
                    CALL cl_err('','mfg9329',0)
                    LET g_wab[l_ac].wab05 = g_wab_t.wab05
                    NEXT FIELD wab05
                 END IF
                 IF g_wab[l_ac].wab05 = g_wab[l_ac].wab02 THEN
                    LET g_wab[l_ac].wab05 = g_wab_t.wab05
                    CALL cl_err('','aws-153',0)
                    NEXT FIELD wab05
                 ELSE  
                    NEXT FIELD wab07
                 END IF
              END IF
           END IF
 
        AFTER FIELD wab07
           IF NOT cl_null(g_wab[l_ac].wab05) AND cl_null(g_wab[l_ac].wab07) THEN
              CALL cl_err("",'aws-109',1)
              NEXT FIELD wab07
           END IF
 
        AFTER FIELD wab08
           IF NOT cl_null(g_wab[l_ac].wab02) AND NOT cl_null(g_wab[l_ac].wab04) 
              AND NOT cl_null(g_wab[l_ac].wab07) AND NOT cl_null(g_wab[l_ac].wab08) THEN
              LET l_ns=0
              SELECT count(*) INTO l_ns FROM wab_file 
               WHERE wab01 = g_waa.waa01
                 AND wab02 = g_wab[l_ac].wab02
                 AND wab04 = g_wab[l_ac].wab04
                 AND wab05 = g_wab[l_ac].wab05
                 AND wab07 = g_wab[l_ac].wab07
                 AND wab08 = g_wab[l_ac].wab08
              IF l_ns > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD wab02
              END IF
           END IF
 
        AFTER FIELD wab09
           IF NOT cl_null(g_wab[l_ac].wab02) AND NOT cl_null(g_wab[l_ac].wab04) 
              AND NOT cl_null(g_wab[l_ac].wab07) AND NOT cl_null(g_wab[l_ac].wab08) THEN
              LET l_ns=0
              SELECT count(*) INTO l_ns FROM wab_file 
               WHERE wab01 = g_waa.waa01
                 AND wab02 = g_wab[l_ac].wab02
                 AND wab04 = g_wab[l_ac].wab04
                 AND wab05 = g_wab[l_ac].wab05
                 AND wab07 = g_wab[l_ac].wab07
                 AND wab08 = g_wab[l_ac].wab08
              IF l_ns > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD wab02
              END IF
           END IF
 
        BEFORE DELETE                      #是否取消單身
           #DISPLAY "BEFORE DELETE"
           IF g_wab_t.wab02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM wab_file
               WHERE wab01 = g_waa.waa01
                 AND wab09 = g_wab_t.wab09
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_wab_t.wab02,SQLCA.sqlcode,0)
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
              LET g_wab[l_ac].* = g_wab_t.*
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF NOT cl_null(g_wab[l_ac].wab02) AND NOT cl_null(g_wab[l_ac].wab04) 
              AND NOT cl_null(g_wab[l_ac].wab07) AND NOT cl_null(g_wab[l_ac].wab08) THEN
              LET l_ns=0
              SELECT count(*) INTO l_ns FROM wab_file 
               WHERE wab01 = g_waa.waa01
                 AND wab02 = g_wab[l_ac].wab02
                 AND wab04 = g_wab[l_ac].wab04
                 AND wab05 = g_wab[l_ac].wab05
                 AND wab07 = g_wab[l_ac].wab07
                 AND wab08 = g_wab[l_ac].wab08
           END IF
           IF l_ns > 0 THEN
              CALL cl_err('',-239,0)
              NEXT FIELD wab02
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_wab[l_ac].wab02,-263,1)
              LET g_wab[l_ac].* = g_wab_t.*
           ELSE
              IF NOT cl_null(g_wab[l_ac].wab02) THEN 
                 SELECT gat03 INTO g_wab[l_ac].wab03
                   FROM gat_file
                  WHERE gat01 = g_wab[l_ac].wab02 AND gat02=g_lang
                 IF cl_null(g_wab[l_ac].wab03) THEN
                    CALL cl_set_comp_entry("wab03",TRUE)
                 END IF
                 DISPLAY BY NAME g_wab[l_ac].wab02
                 DISPLAY BY NAME g_wab[l_ac].wab03
              END IF
              UPDATE wab_file SET wab02=g_wab[l_ac].wab02,
                                  wab03=g_wab[l_ac].wab03,
                                  wab04=g_wab[l_ac].wab04,
                                  wab05=g_wab[l_ac].wab05,
#                                  wab06=g_wab[l_ac].wab06,
                                  wab07=g_wab[l_ac].wab07,
                                  wab08=g_wab[l_ac].wab08
               WHERE wab01=g_waa.waa01
                 AND wab09=g_wab_t.wab09
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_wab[l_ac].wab03,SQLCA.sqlcode,0)
                 LET g_wab[l_ac].* = g_wab_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
## BEGIN ADD ##
           IF g_wab[l_ac].wab02 = g_wab[l_ac].wab04 OR
              g_wab[l_ac].wab02 = g_wab[l_ac].wab05 OR
              g_wab[l_ac].wab04 = g_wab[l_ac].wab05 THEN
              CALL cl_err("",'aws-108',1)
              NEXT FIELD wab02
           END IF 
           IF NOT cl_null(g_wab[l_ac].wab04) AND cl_null(g_wab[l_ac].wab05) THEN
              LET g_wab[l_ac].wab07 =""
           END IF
           IF NOT cl_null(g_wab[l_ac].wab05) THEN
              IF cl_null(g_wab[l_ac].wab07) THEN
                 CALL cl_err("",'aws-109',1)
                 NEXT FIELD wab07
              END IF 
           END IF 
## END  ADD  ##
           #DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_wab[l_ac].* = g_wab_t.*
              END IF
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i002_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(wab03) AND l_ac > 1 THEN
              LET g_wab[l_ac].* = g_wab[l_ac-1].*
              LET g_wab[l_ac].wab02 = g_rec_b + 1
              NEXT FIELD wab02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(wab02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_lang CLIPPED
                 LET g_qryparam.form ="q_gat"
                 LET g_qryparam.default1 = g_wab[l_ac].wab02
                 CALL cl_create_qry() RETURNING g_wab[l_ac].wab02
                 IF NOT cl_null(g_wab[l_ac].wab02) THEN
                 DISPLAY BY NAME g_wab[l_ac].wab02
                 END IF
                 NEXT FIELD wab02
              WHEN INFIELD(wab05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_lang CLIPPED
                 LET g_qryparam.form ="q_gat"
                 LET g_qryparam.default1 = g_wab[l_ac].wab05
                 CALL cl_create_qry() RETURNING g_wab[l_ac].wab05
                 IF NOT cl_null(g_wab[l_ac].wab05) THEN
                 DISPLAY BY NAME g_wab[l_ac].wab05
                 END IF
                 NEXT FIELD wab05
              WHEN INFIELD(wab04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_lang CLIPPED
                 LET g_qryparam.form ="q_gat"
                 LET g_qryparam.default1 = g_wab[l_ac].wab04
                 CALL cl_create_qry() RETURNING g_wab[l_ac].wab04
                 IF NOT cl_null(g_wab[l_ac].wab04) THEN
                 DISPLAY BY NAME g_wab[l_ac].wab04
                 END IF
                 NEXT FIELD wab04
            END CASE
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                                RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
         CALL cl_about()
 
       ON ACTION help
         CALL cl_show_help()
 
 
    END INPUT
 
    CLOSE i002_bcl
    COMMIT WORK
    CALL i002_delall()
 
END FUNCTION
 
FUNCTION i002_b2()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
    p_cmd           LIKE type_file.chr1,               #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5                #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_waa.waa01 IS NULL  THEN
       RETURN
    END IF
 
    SELECT * INTO g_waa.* FROM waa_file
     WHERE waa01=g_waa.waa01
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT wam01,wam02,wam03",
                       "  FROM wam_file",
                       " WHERE wam01=? AND wam02=? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_wam WITHOUT DEFAULTS FROM s_wam.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           #DISPLAY "BEFORE INPUT!"
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           #DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i002_cl USING g_waa.waa01
           IF STATUS THEN
              CALL cl_err("OPEN i002_cl:", STATUS, 1)
              CLOSE i002_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i002_cl INTO g_waa.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i002_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_wam_t.* = g_wam[l_ac].*  #BACKUP
              LET g_wam_o.* = g_wam[l_ac].*  #BACKUP
                 OPEN i002_b2cl USING g_waa.waa01,g_wam_t.wam02 
                 IF STATUS THEN
                    CALL cl_err("OPEN i002_b2cl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i002_b2cl INTO g_wam[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_wam_t.wam02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           #DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_wam[l_ac].* TO NULL
           LET g_wam_t.* = g_wam[l_ac].*         #新輸入資料
           LET g_wam_o.* = g_wam[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD wam02
 
        AFTER INSERT
           #DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO wam_file(wam01,wam02,wam03)
           VALUES(g_waa.waa01,g_wam[l_ac].wam02,g_wam[l_ac].wam03)
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_wam[l_ac].wam02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD wam02 
           LET g_wam[l_ac].wam01=g_waa.waa01
           DISPLAY BY NAME g_wam[l_ac].wam01
 
        AFTER FIELD wam02                        #check 是否重復
           IF NOT cl_null(g_wam[l_ac].wam02) THEN
              IF g_wam[l_ac].wam02 != g_wam_t.wam02
                 OR g_wam_t.wam02 IS NULL THEN
                 LET l_n=0
                 SELECT count(*)
                   INTO l_n
                   FROM wam_file
                  WHERE wam01=g_waa.waa01 AND wam02 = g_wam[l_ac].wam02
                 IF l_n > 0 THEN
                    CALL cl_err('','aws-154',0)
                    LET g_wam[l_ac].wam02 = g_wam_t.wam02
                    NEXT FIELD wam02
                 END IF
              END IF
           END IF
 
        AFTER FIELD wam03 
           IF cl_null(g_wam[l_ac].wam03) THEN
              CALL cl_err('','aws-155',0)
              NEXT FIELD wam03
           END IF
 
        BEFORE DELETE                      #是否取消單身
           #DISPLAY "BEFORE DELETE"
           IF g_wam_t.wam02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM wam_file
               WHERE wam01 = g_waa.waa01
                 AND wam02 = g_wam_t.wam02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_wam_t.wam02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_wam[l_ac].* = g_wam_t.*
              CLOSE i002_b2cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_wam[l_ac].wam02,-263,1)
              LET g_wam[l_ac].* = g_wam_t.*
           ELSE
              UPDATE wam_file SET wam02=g_wam[l_ac].wam02,
                                  wam03=g_wam[l_ac].wam03 
               WHERE wam01=g_waa.waa01
                 AND wam02=g_wam_t.wam02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_wam[l_ac].wam03,SQLCA.sqlcode,0)
                 LET g_wam[l_ac].* = g_wam_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           #DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_wam[l_ac].* = g_wam_t.*
              END IF
              CLOSE i002_b2cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i002_b2cl
           COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                                RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
         CALL cl_about()
 
       ON ACTION help
         CALL cl_show_help()
 
 
    END INPUT
 
    CLOSE i002_b2cl
    COMMIT WORK
 
    CALL i002_case()
 
END FUNCTION
 
###mark by binbin
FUNCTION i002_case()
DEFINE          l_head          STRING 
DEFINE          l_tail          STRING 
DEFINE          l_body          STRING 
DEFINE          g_m             LIKE type_file.num5
DEFINE          l_wam        DYNAMIC ARRAY OF RECORD
                    wam01       LIKE wam_file.wam01,
                    wam02       LIKE wam_file.wam02,
                    wam03       LIKE wam_file.wam03 
                             END RECORD 
 
  #Modified by David Lee 2008/12/02
  LET l_head="# Pattern name...: aws_ttsrv2_case.4gl"    #TQC-950058
            ,"\n","# Descriptions...: delivery operate according as different Object and Operate"
            ,"\n","# Date & Author..: 08/10/20 shengbb generate by awsi002 automatically"
            ,"\n","# Modify.........: 新建 FUN-8A0122"
            ,"\n","# Modify.........: ",g_today," By ",g_user," awsi002 automatically"
            ,"\n","# Memo...........: 本程序是由awsi002作業自動產生，如需更改，請維護awsi002作業的第二單身。"
            ,"\n"
            ,"\n","DATABASE ds"
            ,"\n"
            ,"\n","FUNCTION aws_ttsrv2_case(l_ObjectID,l_Operate)"
            ,"\n","DEFINE"
            ,"\n","  l_ObjectID  LIKE wam_file.wam01,"
            ,"\n","  l_Operate  LIKE wam_file.wam02,"
            ,"\n","  l_errCode STRING,"
            ,"\n","  l_errDesc STRING"
            ,"\n"
            ,"\n","  CASE"
            
  LET l_body=''
  LET l_tail="\n","    WHEN TRUE"
            ,"\n","      LET l_errCode='aws-333'"
            ,"\n","      LET l_errDesc='Cannot_Found'"
            ,"\n","    OTHERWISE"
            ,"\n","  END CASE"
            ,"\n","      RETURN l_errCode,l_errDesc"
            ,"\n","END FUNCTION"
            ,"\n","#No.FUN-8A0122"
  LET g_sql="SELECT wam01,wam02,wam03 FROM wam_file WHERE 1=1"
  PREPARE wam_m FROM g_sql
  DECLARE wam_m_curs                       #SCROLL CURSOR
        CURSOR FOR wam_m
  CALL l_wam.clear()
  LET g_m = 1
 
  FOREACH wam_m_curs INTO l_wam[g_m].wam01,l_wam[g_m].wam02,l_wam[g_m].wam03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach: wam_file',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET l_body=l_body
                       ,"\n","    WHEN (l_ObjectID= '",l_wam[g_m].wam01,"' AND l_Operate= '",l_wam[g_m].wam02,"')"
                       ,"\n","      CALL ",l_wam[g_m].wam03,"() RETURNING l_errCode,l_errDesc"
       LET g_m = g_m + 1
  END FOREACH
  RUN "echo \""||l_head||"\" > "||FGL_GETENV("AWS")||"/4gl/aws_ttsrv2_case.4gl"   #FUN-9B0113
  RUN "echo \""||l_body||"\" >> "||FGL_GETENV("AWS")||"/4gl/aws_ttsrv2_case.4gl"
  RUN "echo \""||l_tail||"\" >> "||FGL_GETENV("AWS")||"/4gl/aws_ttsrv2_case.4gl"
  RUN "cd aws/4gl;r.c2 aws_ttsrv2_case"
 
END FUNCTION
 
 
FUNCTION i002_delall()
 
    SELECT COUNT(*) INTO g_cnt FROM wab_file
     WHERE wab01 = g_waa.waa01
           
 
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM waa_file
        WHERE waa01 = g_waa.waa01
       DELETE FROM wac_file
        WHERE wac01 = g_waa.waa01
    END IF
 
END FUNCTION
 
FUNCTION i002_b_askkey()
DEFINE
    #l_wc2           LIKE type_file.chr200
     l_wc2         STRING       #NO.FUN-910082
 
#    CONSTRUCT l_wc2 ON wab02,wab03,wab04,wab05,
#                       wab06,wab07,wab08
    CONSTRUCT l_wc2 ON wab09,wab02,wab03,wab04,wab05,
                       wab07,wab08
#            FROM s_wab[1].wab02,s_wab[1].wab03,
#                 s_wab[1].wab04,s_wab[1].wab05,
#                 s_wab[1].wab06,s_wab[1].wab07,
#                 s_wab[1].wab08
            FROM s_wab[1].wab09,s_wab[1].wab02,s_wab[1].wab03,
                 s_wab[1].wab04,s_wab[1].wab05,
                 s_wab[1].wab07,
                 s_wab[1].wab08
 
      #No.FUN-580031 --start--     HCN
#     BEFORE CONSTRUCT
#        CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      #No.FUN-580031 --start--     HCN
#     ON ACTION qbe_select
#         CALL cl_qbe_select()
#     ON ACTION qbe_save
#         CALL cl_qbe_save()
#     #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i002_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i002_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    #p_wc2           LIKE type_file.chr200
     p_wc2         STRING       #NO.FUN-910082
 
 
#    LET g_sql = "SELECT wab02,wab03,wab04,",
#                " wab05,wab06,wab07,wab08  FROM wab_file",
#                " WHERE wab01 ='",g_waa.waa01,"' "   #單頭
    LET g_sql = "SELECT wab09,wab02,wab03,wab04,",
                " wab05,wab07,wab08  FROM wab_file",
                " WHERE wab01 ='",g_waa.waa01,"' "   #單頭
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY wab02 "
    #DISPLAY g_sql
 
    PREPARE i002_pb FROM g_sql
    DECLARE wab_cs
        CURSOR FOR i002_pb
 
    CALL g_wab.clear()
    LET g_cnt = 1
 
    FOREACH wab_cs INTO g_wab[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_wab.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i002_b2_fill(p_wc1)              #BODY FILL UP
DEFINE
#    p_wc1           LIKE type_file.chr200
    p_wc1         STRING       #NO.FUN-910082
 
    LET g_sql = "SELECT wam01,wam02,wam03",
                "  FROM wam_file",
                " WHERE wam01 ='",g_waa.waa01,"' "   #單頭
 
    IF NOT cl_null(p_wc1) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY wam02 "
    #DISPLAY g_sql
 
    PREPARE i002_pb2 FROM g_sql
    DECLARE wam_cs
        CURSOR FOR i002_pb2
 
    CALL g_wam.clear()
    LET g_cnt = 1
 
    FOREACH wam_cs INTO g_wam[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_wam.deleteElement(g_cnt)
 
    LET g_rec_b2=g_cnt-1
    LET g_cnt = 0
 
   DISPLAY ARRAY g_wam TO s_wam.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY
 
END FUNCTION
 
FUNCTION i002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_wab TO s_wab.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index,g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      #CALL cl_show_fld_cont()
 
      ##################################################################
      # Standard 4ad ACTION
      ##################################################################
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
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION Second_Body
         LET g_action_choice="Second_Body"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION fieldhold
         LET g_action_choice="fieldhold"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i002_copy()
DEFINE
    l_newno         LIKE waa_file.waa01,
    l_oldno         LIKE waa_file.waa01
   DEFINE   li_result   LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    IF g_waa.waa01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i002_set_entry('a')
 
    INPUT l_newno FROM waa01
 
        AFTER FIELD waa01
            IF cl_null(l_newno) THEN NEXT FIELD waa01 END IF
            SELECT count(*) INTO g_cnt FROM waa_file
             WHERE waa01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD waa01
            END IF
 
        BEGIN WORK
 
 
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
       DISPLAY BY NAME g_waa.waa01
       ROLLBACK WORK
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM waa_file         #單頭復制
        WHERE waa01=g_waa.waa01
        INTO TEMP y
 
    UPDATE y
        SET waa01=l_newno    #新的鍵值
 
    INSERT INTO waa_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
 
    SELECT * FROM wab_file         #單身復制
        WHERE wab01=g_waa.waa01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    UPDATE x
        SET wab01=l_newno
 
    INSERT INTO wab_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)        #FUN-B80064    ADD
        ROLLBACK WORK #No:7857
       # CALL cl_err(g_waa.waa01,SQLCA.sqlcode,0)       #FUN-B80064    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_waa.waa01
     SELECT waa_file.* INTO g_waa.* FROM waa_file
      WHERE waa01 = l_newno
     CALL i002_u()
     CALL i002_b()
     #SELECT * INTO g_waa.* FROM waa_file  #FUN-C80046
     # WHERE waa01 = l_oldno               #FUN-C80046
     #CALL i002_show()                     #FUN-C80046
 
END FUNCTION
 
FUNCTION i002_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("waa01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i002_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("waa01",FALSE)
    END IF
 
END FUNCTION
 
#No.FUN-8A0122
