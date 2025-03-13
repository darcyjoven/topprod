# Prog. Version..: '5.30.03-12.09.18(00030)'     #
#
# Pattern name...: ghri030.4gl
# Descriptions...: 考勤项目维护
# Date & Author..: 13/05/07 By lijun
# Modify.........: 13/08/09 By Exia  调整页签显示

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線

GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義

DEFINE g_hrbm                RECORD LIKE hrbm_file.*
DEFINE g_hrbm_t              RECORD LIKE hrbm_file.*     #備份舊值
DEFINE g_hrbm03_t            LIKE hrbm_file.hrbm03       #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680302
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
DEFINE g_hraa12              LIKE hraa_file.hraa12
DEFINE g_count               LIKE type_file.num5
DEFINE g_flag                LIKE type_file.chr1
DEFINE g_bp_flag             LIKE type_file.chr10
DEFINE g_rec_b,l_ac          LIKE type_file.num5
DEFINE  g_hrbm_b  DYNAMIC ARRAY OF RECORD
          hrbm01_b    LIKE   hrbm_file.hrbm01,
          hraa12_b    LIKE   hraa_file.hraa12,
          hrbm02_b    LIKE   hrbm_file.hrbm02,
          hrbm03_b    LIKE   hrbm_file.hrbm03,
          hrbm04_b    LIKE   hrbm_file.hrbm04,
          hrbm05_b    LIKE   hrbm_file.hrbm05,
          hrbm06_b    LIKE   hrbm_file.hrbm06,
          hrbm07_b    LIKE   hrbm_file.hrbm07,
          hrbm08_b    LIKE   hrbm_file.hrbm08,
          hrbm09_b    LIKE   hrbm_file.hrbm09,
          hrbm10_b    LIKE   hrbm_file.hrbm10,
          hrbm11_b    LIKE   hrbm_file.hrbm11,
          hrbm12_b    LIKE   hrbm_file.hrbm12,
          hrbm13_b    LIKE   hrbm_file.hrbm13,
          hrbm14_b    LIKE   hrbm_file.hrbm14,
          hrbm15_b    LIKE   hrbm_file.hrbm15,
          hrbm16_b    LIKE   hrbm_file.hrbm16,
          hrbm17_b    LIKE   hrbm_file.hrbm17,
          hrbm18_b    LIKE   hrbm_file.hrbm18,
          hrbm19_b    LIKE   hrbm_file.hrbm19,
          hrbm20_b    LIKE   hrbm_file.hrbm20,
          hrbm21_b    LIKE   hrbm_file.hrbm21,
          hrbm22_b    LIKE   hrbm_file.hrbm22,
          hrbm23_b    LIKE   hrbm_file.hrbm23,
          hrbm24_b    LIKE   hrbm_file.hrbm24,
          hrbm25_b    LIKE   hrbm_file.hrbm25,
          hrbm26_b    LIKE   hrbm_file.hrbm26,
          hrbm27_b    LIKE   hrbm_file.hrbm27,
          hrbm28_b    LIKE   hrbm_file.hrbm28,
          hrbm29_b    LIKE   hrbm_file.hrbm29,
          hrbm30_b    LIKE   hrbm_file.hrbm30,
          hrbm31_b    LIKE   hrbm_file.hrbm31,
          hrbm32_b    LIKE   hrbm_file.hrbm32,
          hrbm33_b    LIKE   hrbm_file.hrbm33,
          hrbm34_b    LIKE   hrbm_file.hrbm34,
          hrbm35_b    LIKE   hrbm_file.hrbm35,
          hrbm36_b    LIKE   hrbm_file.hrbm36
                  END RECORD

MAIN
    OPTIONS
#       FIELD ORDER FORM,                      #依照FORM上面的順序定義做欄位跳動 (預設為依指令順序)
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔

   IF (NOT cl_setup("GHR")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_hrbm.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrbm_file WHERE hrbm03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i030_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW i030_w WITH FORM "ghr/42f/ghri030"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
   CALL cl_set_label_justify("i030_w","right")

   CALL cl_set_comp_visible("hrbm20,hrbm20_b,hrbm01_b",FALSE)

   LET g_action_choice = ""
   CALL i030_menu()                                         #進入選單 Menu

   CLOSE WINDOW i030_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN



FUNCTION i030_curs()

    CLEAR FORM
    INITIALIZE g_hrbm.* TO NULL
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hrbm01,hrbm02,hrbm03,hrbm04,hrbm05,
        hrbm06,hrbm07,hrbm08,hrbm09,hrbm10,
        hrbm11,hrbm12,hrbm13,hrbm14,hrbm15,
        hrbm16,hrbm17,hrbm18,hrbm19,hrbm20,
        hrbm21,hrbm22,hrbm23,hrbm24,hrbm25,
        hrbm26,hrbm27,hrbm28,hrbm29,hrbm30,
        hrbm31,hrbm32,hrbm33,hrbm34,hrbm35,
        hrbm36,hrbm37,hrbm38,hrbm39,hrbm40,hrbm41, #add by zhzuw 20160123
        hrbmuser,hrbmgrup,hrbmmodu,hrbmdate

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.construct = "N"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbm.hrbm01

                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbm01
                 NEXT FIELD hrbm01
           WHEN INFIELD(hrbm15)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrbm.hrbm15
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm15
              NEXT FIELD hrbm15
           WHEN INFIELD(hrbm16)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrbm.hrbm16
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm16
              NEXT FIELD hrbm16
           WHEN INFIELD(hrbm33)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrck01"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrbm.hrbm33
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm33
              NEXT FIELD hrbm33
          WHEN INFIELD(hrbm35)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = '004'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm35
              NEXT FIELD hrbm35
          WHEN INFIELD(hrbm40)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrck01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm40
              NEXT FIELD hrbm40
          WHEN INFIELD(hrbm38)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = '004'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm38
              NEXT FIELD hrbm38
          WHEN INFIELD(hrbm39)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = '516'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm39
              NEXT FIELD hrbm39
          WHEN INFIELD(hrbm41)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gaq_hrcp"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm41
              NEXT FIELD hrbm41                  
          OTHERWISE
              EXIT CASE
          END CASE

      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()

#      ON ACTION generate_link
#         CALL cl_generate_shortcut()

      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()

      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbmuser', 'hrbmgrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位

    LET g_sql = "SELECT hrbm03 FROM hrbm_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY hrbm01,hrbm03"
    PREPARE i030_prepare FROM g_sql
    DECLARE i030_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i030_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrbm_file WHERE ",g_wc CLIPPED
    PREPARE i030_precount FROM g_sql
    DECLARE i030_count CURSOR FOR i030_precount
END FUNCTION

FUNCTION i030_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i030_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i030_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i030_q()
            END IF

        ON ACTION next
            CALL i030_fetch('N')

        ON ACTION previous
            CALL i030_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i030_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i030_r()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i030_fetch('/')

        ON ACTION first
            CALL i030_fetch('F')

        ON ACTION last
            CALL i030_fetch('L')

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

        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbm_b),'','')
           END IF
        &include "qry_string.4gl"
    END MENU
    CLOSE i030_cs
END FUNCTION

FUNCTION i030_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000

   WHILE TRUE

      CALL i030_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrbm_file.*
           INTO g_hrbm.*
           FROM hrbm_file
          WHERE hrbm01=g_hrbm_b[l_ac].hrbm01_b
            AND hrbm03=g_hrbm_b[l_ac].hrbm03_b
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page8'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i030_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page9", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page9", TRUE)
       END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i030_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i030_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i030_u()
            END IF
            EXIT WHILE

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbm_b),'','')
           END IF

        WHEN "help"
            CALL cl_show_help()

        WHEN "controlg"
            CALL cl_cmdask()

        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        WHEN "exit"
            EXIT WHILE

        WHEN "g_idle_seconds"
            CALL cl_on_idle()

        WHEN "about"
            CALL cl_about()

        OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION i030_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbm_b TO s_hrbm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION main
         LET g_bp_flag = 'Page8'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i030_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page9", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page9", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i030_fetch('/')
         CALL cl_set_comp_visible("Page9", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page9", TRUE)
         EXIT DISPLAY

      ON ACTION first
         CALL i030_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i030_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i030_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i030_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i030_fetch('L')
         CONTINUE DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-8A0193
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"  #MOD-8A0193 add
         EXIT DISPLAY                 #MOD-8A0193 add

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

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end-----------------

      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i030_a()
DEFINE l_hrbmud02  LIKE hrbm_file.hrbmud02


    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrbm.* LIKE hrbm_file.*
    LET g_hrbm03_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbm.hrbmuser = g_user
        LET g_hrbm.hrbmoriu = g_user
        LET g_hrbm.hrbmorig = g_grup
        LET g_hrbm.hrbmgrup = g_grup               #使用者所屬群
        LET g_hrbm.hrbmdate = g_today
        LET g_hrbm.hrbm07 = 'Y'
        LET g_hrbm.hrbm09 = 'N'
        LET g_hrbm.hrbm10 = '3'
        LET g_hrbm.hrbm28 = 'Y'
        LET g_hrbm.hrbm13 = 'Y'
        LET g_hrbm.hrbm14 = 'Y'
        LET g_hrbm.hrbm17 = '00:00'
        LET g_hrbm.hrbm18 = 'Y'
        LET g_hrbm.hrbm19 = 'Y'
        LET g_hrbm.hrbm20 = 'Y'
        LET g_hrbm.hrbm21 = 'Y'
        LET g_hrbm.hrbm22 = '1'
        LET g_hrbm.hrbm23 = 'N'
        LET g_hrbm.hrbm24 = 'Y'
        LET g_hrbm.hrbm25 = '003'
        LET g_hrbm.hrbm26 = '1'
        LET g_hrbm.hrbm27 = '1'
        LET g_hrbm.hrbm15 = ' '
        LET g_hrbm.hrbm16 = ' '
        LET g_hrbm.hrbm30 = 'N'
        LET g_hrbm.hrbm32 = 'N'
        LET g_hrbm.hrbm11 = '0'
        LET g_hrbm.hrbm12 = '0'
        LET g_hrbm.hrbm36 = 'N'
        SELECT to_char(systimestamp, 'hh24:mi:ss') INTO l_hrbmud02  FROM dual
        LET g_hrbm.hrbmud02 = l_hrbmud02

        CALL i030_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrbm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbm.hrbm03 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO hrbm_file VALUES(g_hrbm.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbm_file",g_hrbm.hrbm03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrbm03 INTO g_hrbm.hrbm03 FROM hrbm_file WHERE hrbm03 = g_hrbm.hrbm03
            CALL i030_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION



FUNCTION i030_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_gen02       LIKE gen_file.gen02
   DEFINE l_gen03       LIKE gen_file.gen03
   DEFINE l_gen04       LIKE gen_file.gen04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_h1          LIKE type_file.num5
   DEFINE l_m1          LIKE type_file.num5
   DEFINE l_hrbm41_n    LIKE gaq_file.gaq03
   
   DISPLAY BY NAME
      g_hrbm.hrbm01,g_hrbm.hrbm02,
      g_hrbm.hrbm03,g_hrbm.hrbm04,g_hrbm.hrbm05,
      g_hrbm.hrbm06,g_hrbm.hrbm07,g_hrbm.hrbm08,g_hrbm.hrbm09,g_hrbm.hrbm10,
      g_hrbm.hrbm11,g_hrbm.hrbm12,g_hrbm.hrbm13,g_hrbm.hrbm14,g_hrbm.hrbm15,
      g_hrbm.hrbm16,g_hrbm.hrbm17,g_hrbm.hrbm18,g_hrbm.hrbm19,g_hrbm.hrbm20,
      g_hrbm.hrbm21,g_hrbm.hrbm22,g_hrbm.hrbm23,g_hrbm.hrbm24,g_hrbm.hrbm25,
      g_hrbm.hrbm26,g_hrbm.hrbm27,g_hrbm.hrbm28,g_hrbm.hrbm29,g_hrbm.hrbm30,
      g_hrbm.hrbm31,g_hrbm.hrbm32,g_hrbm.hrbm33,g_hrbm.hrbm34,g_hrbm.hrbm35,
      g_hrbm.hrbm36,g_hrbm.hrbm37,g_hrbm.hrbm38,g_hrbm.hrbm39,g_hrbm.hrbm40,g_hrbm.hrbm41,
      g_hrbm.hrbmuser,g_hrbm.hrbmgrup,g_hrbm.hrbmmodu,g_hrbm.hrbmdate,
      g_hrbm.hrbmorig,g_hrbm.hrbmoriu,g_hrbm.hrbmud02

   INPUT BY NAME
      g_hrbm.hrbm01,g_hrbm.hrbm02,g_hrbm.hrbm03,g_hrbm.hrbm04,g_hrbm.hrbm05,
      g_hrbm.hrbm06,g_hrbm.hrbm07,g_hrbm.hrbm08,g_hrbm.hrbm09,g_hrbm.hrbm10,
      g_hrbm.hrbm11,g_hrbm.hrbm12,g_hrbm.hrbm13,g_hrbm.hrbm14, g_hrbm.hrbm15,
      g_hrbm.hrbm16,g_hrbm.hrbm17,g_hrbm.hrbm18,g_hrbm.hrbm19,g_hrbm.hrbm20,
      g_hrbm.hrbm21,g_hrbm.hrbm22,g_hrbm.hrbm23,g_hrbm.hrbm24,g_hrbm.hrbm25,
      g_hrbm.hrbm26,g_hrbm.hrbm27,g_hrbm.hrbm28,g_hrbm.hrbm29,g_hrbm.hrbm30,
      g_hrbm.hrbm31,g_hrbm.hrbm32,g_hrbm.hrbm33,g_hrbm.hrbm34,g_hrbm.hrbm35,
      g_hrbm.hrbm36,g_hrbm.hrbm37,g_hrbm.hrbm38,g_hrbm.hrbm39,g_hrbm.hrbm40,g_hrbm.hrbm41,
      g_hrbm.hrbmuser,g_hrbm.hrbmgrup,g_hrbm.hrbmmodu,g_hrbm.hrbmdate,
      g_hrbm.hrbmorig,g_hrbm.hrbmoriu,g_hrbm.hrbmud02
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i030_set_entry(p_cmd)
          CALL i030_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd='a' THEN
             LET g_hrbm.hrbm34='N'
             DISPLAY BY NAME g_hrbm.hrbm34
          END IF
 
      AFTER FIELD hrbm01
         IF NOT cl_null(g_hrbm.hrbm01) THEN
         	  SELECT COUNT(*) INTO g_count FROM hraa_file WHERE hraa01= g_hrbm.hrbm01
         	  IF g_count = 0 THEN
         	     CALL cl_err(g_hrbm.hrbm01,'agl-446',0)
         	     NEXT FIELD hrbm01
         	  ELSE
         	    SELECT hraa12 INTO g_hraa12 FROM hraa_file WHERE hraa01=g_hrbm.hrbm01
         	    DISPLAY g_hraa12 TO hraa12
         	  END IF
         END IF

      AFTER FIELD hrbm02
          IF NOT cl_null(g_hrbm.hrbm02) THEN
             CALL i030_set_page(g_hrbm.hrbm02)
          END IF
      BEFORE FIELD hrbm03
         IF p_cmd='a' THEN
         	  IF NOT cl_null(g_hrbm.hrbm01) THEN
              CALL hr_gen_no('hrbm_file','hrbm03','018',g_hrbm.hrbm01,'') RETURNING g_hrbm.hrbm03,g_flag
              DISPLAY BY NAME g_hrbm.hrbm03
            END IF
         END IF

      AFTER FIELD hrbm03
         IF NOT cl_null(g_hrbm.hrbm03) THEN
         	  SELECT COUNT(*) INTO g_count FROM hrbm_file WHERE hrbm03=g_hrbm.hrbm03
         	  IF g_count > 0 THEN
         	  	CALL cl_err(g_hrbm.hrbm03,'ghr-064',0)
         	  	NEXT FIELD hrbm03
         	  END IF
         END IF

#      AFTER FIELD hrbm11
#         IF NOT cl_null(g_hrbm.hrbm11) THEN
#         	  IF g_hrbm.hrbm11 < 0 OR g_hrbm.hrbm11 >60 THEN
#         	  	 CALL cl_err('分钟数超出范围','！',0)
#         	  	 NEXT FIELD hrbm11
#         	  ELSE
#         	    IF NOT cl_null(g_hrbm.hrbm12) THEN
#         	  	  IF g_hrbm.hrbm11=g_hrbm.hrbm12 AND g_hrbm.hrbm11<>0 AND g_hrbm.hrbm12<>0 THEN
#         	  		  CALL cl_err(g_hrbm.hrbm11,'ghr-061',0)
#         	  		  NEXT FIELD hrbm11
#         	      END IF
#         	    ELSE
#         	       CALL cl_err('','ghr-063',0)
#         	       NEXT FIELD g_hrbm.hrbm12
#         	    END IF
#         	  END IF
#         ELSE
#            IF NOT cl_null(g_hrbm.hrbm12) THEN
#            	 CALL cl_err('','ghr-062',0)
#         	     NEXT FIELD g_hrbm.hrbm11
#            END IF
#         END IF
#
#      AFTER FIELD hrbm12
#         IF NOT cl_null(g_hrbm.hrbm12) THEN
#         	  IF g_hrbm.hrbm12 < 0 OR g_hrbm.hrbm12 >60 THEN
#         	  	 CALL cl_err('分钟数超出范围','！',0)
#         	  	 NEXT FIELD hrbm12
#         	  ELSE
#         	    IF NOT cl_null(g_hrbm.hrbm11) THEN
#         	  	  IF g_hrbm.hrbm11=g_hrbm.hrbm12 AND g_hrbm.hrbm11<>0 AND g_hrbm.hrbm12<>0 THEN
#         	  	  	CALL cl_err('','ghr-061',0)
#         	  	  	NEXT FIELD hrbm12
#         	  	  ELSE
#         	  	    IF g_hrbm.hrbm12 < g_hrbm.hrbm11 THEN
#         	  	    	 CALL cl_err('截止分钟数小于起始分钟数','！',0)
#         	  	    	 NEXT FIELD hrbm12
#         	  	    END IF
#         	      END IF
#         	    ELSE
#         	       CALL cl_err('','ghr-062',0)
#         	       NEXT FIELD g_hrbm.hrbm11
#         	    END IF
#         	  END IF
#         ELSE
#            IF NOT cl_null(g_hrbm.hrbm11) THEN
#            	 CALL cl_err('','ghr-063',0)
#         	     NEXT FIELD g_hrbm.hrbm12
#            END IF
#         END IF

      AFTER FIELD hrbm17
         IF NOT cl_null(g_hrbm.hrbm17) THEN
         	  LET l_h1 = g_hrbm.hrbm17[1,2]
         	  LET l_m1 = g_hrbm.hrbm17[4,5]
         	  IF l_h1 < 0 OR l_h1 > 24 OR l_m1 < 0 OR l_m1 > 60 OR cl_null(l_h1) OR cl_null(l_m1) THEN
          	 	  CALL cl_err('时间录入不正确','!',0)
          	 	  NEXT FIELD hrbm17
          	END IF
         END IF

      AFTER FIELD hrbm41
         IF NOT cl_null(g_hrbm.hrbm41) AND g_hrbm.hrbm41!=g_hrbm_t.hrbm41 OR cl_null(g_hrbm_t.hrbm41) THEN  
            LET g_count=0
            SELECT COUNT(*) INTO g_count FROM hrbm_file WHERE hrbm41=g_hrbm.hrbm41
            IF g_count>0 THEN 
               CALL cl_err('对应点名字段重复','!',1)
               NEXT FIELD hrbm14
            ELSE 
               SELECT gaq03 INTO l_hrbm41_n FROM gaq_file WHERE gaq01=g_hrbm.hrbm41 AND gaq02='2' 
               DISPLAY l_hrbm41_n TO hrbm41_n
            END IF 
         ELSE 
            IF cl_null(g_hrbm.hrbm41) THEN 
               CALL cl_err('对应点名字段不可为空','!',0)
               NEXT FIELD hrbm14
            END IF    
         END IF 

      AFTER INPUT
         LET g_hrbm.hrbmuser = s_get_data_owner("hrbm_file") #FUN-C10039
         LET g_hrbm.hrbmgrup = s_get_data_group("hrbm_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_hrbm.hrbm03 IS NULL THEN
               DISPLAY BY NAME g_hrbm.hrbm03
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbm03
            END IF
            IF NOT cl_null(g_hrbm.hrbm11) THEN
         	      IF g_hrbm.hrbm11 < 0  THEN
         	      	 CALL cl_err('分钟数不可小于零','！',0)
         	      	 NEXT FIELD hrbm11
         	      ELSE
         	        IF NOT cl_null(g_hrbm.hrbm12) THEN
         	        	IF  g_hrbm.hrbm12 < 0 THEN
         	      	    CALL cl_err('分钟数不可小于零','！',0)
         	      	    NEXT FIELD hrbm12
         	      	  END IF
         	      	  IF g_hrbm.hrbm11>g_hrbm.hrbm12 THEN
         	      		  CALL cl_err('起始分钟数必须小于结束分钟数','!',0)
         	      		  NEXT FIELD hrbm11
         	          END IF
         	        ELSE
         	           CALL cl_err('','ghr-063',0)
         	           NEXT FIELD hrbm12
         	        END IF
         	      END IF
            ELSE
                IF NOT cl_null(g_hrbm.hrbm12) THEN
            	    CALL cl_err('','ghr-062',0)
         	        NEXT FIELD hrbm11
                END IF
           END IF

      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(hrbm03) THEN
            LET g_hrbm.* = g_hrbm_t.*
            CALL i030_show()
            NEXT FIELD hrbm03
         END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrbm01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrbm.hrbm01
              CALL cl_create_qry() RETURNING g_hrbm.hrbm01
              DISPLAY BY NAME g_hrbm.hrbm01
              NEXT FIELD hrbm01
           WHEN INFIELD(hrbm15)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrbm.hrbm15
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET g_hrbm.hrbm15 = g_qryparam.multiret
              DISPLAY g_hrbm.hrbm15 TO hrbm15
              NEXT FIELD hrbm15
           WHEN INFIELD(hrbm16)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03c"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_hrbm.hrbm16
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET g_hrbm.hrbm16 = g_qryparam.multiret
              DISPLAY g_hrbm.hrbm16 TO hrbm16
              NEXT FIELD hrbm16
           WHEN INFIELD(hrbm33)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrck01"
              LET g_qryparam.default1 = g_hrbm.hrbm33
              CALL cl_create_qry() RETURNING g_hrbm.hrbm33
              DISPLAY BY NAME g_hrbm.hrbm33
              NEXT FIELD hrbm33
           WHEN INFIELD(hrbm35)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03"
              LET g_qryparam.arg1 = '004'
              CALL cl_create_qry() RETURNING g_hrbm.hrbm35
              DISPLAY BY NAME g_hrbm.hrbm35
              NEXT FIELD hrbm35
           WHEN INFIELD(hrbm40)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrck01"
              CALL cl_create_qry() RETURNING g_hrbm.hrbm40
              DISPLAY BY NAME g_hrbm.hrbm40
              NEXT FIELD hrbm40
           WHEN INFIELD(hrbm38)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = '004'
              LET g_qryparam.where = "hrbm02 = '",g_hrbm.hrbm02,"'"
              CALL cl_create_qry() RETURNING g_hrbm.hrbm38
              DISPLAY BY NAME g_hrbm.hrbm38
              NEXT FIELD hrbm38
           WHEN INFIELD(hrbm39)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = '516'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbm39
              NEXT FIELD hrbm39
           WHEN INFIELD(hrbm41)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gaq_hrcp"
              CALL cl_create_qry() RETURNING g_hrbm.hrbm41
              DISPLAY BY NAME g_hrbm.hrbm41
              NEXT FIELD hrbm41
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

#      ON ACTION generate_link
#         CALL cl_generate_shortcut()

      ON ACTION help
         CALL cl_show_help()

   END INPUT
END FUNCTION


FUNCTION i030_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbm.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i030_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i030_count
    FETCH i030_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i030_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbm.hrbm01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbm.* TO NULL
    ELSE
        CALL i030_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i030_b_fill(g_wc)
    END IF
END FUNCTION



FUNCTION i030_fetch(p_flhrbm)
    DEFINE p_flhrbm         LIKE type_file.chr1

    CASE p_flhrbm
        WHEN 'N' FETCH NEXT     i030_cs INTO g_hrbm.hrbm03
        WHEN 'P' FETCH PREVIOUS i030_cs INTO g_hrbm.hrbm03
        WHEN 'F' FETCH FIRST    i030_cs INTO g_hrbm.hrbm03
        WHEN 'L' FETCH LAST     i030_cs INTO g_hrbm.hrbm03
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about
                     CALL cl_about()

                  ON ACTION generate_link
                     CALL cl_generate_shortcut()

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
            FETCH ABSOLUTE g_jump i030_cs INTO g_hrbm.hrbm03
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbm.hrbm03,SQLCA.sqlcode,0)
        INITIALIZE g_hrbm.* TO NULL
        LET g_hrbm.hrbm03 = NULL
        RETURN
    ELSE
      CASE p_flhrbm
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrbm.* FROM hrbm_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hrbm03 = g_hrbm.hrbm03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbm_file",g_hrbm.hrbm03,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_hrbm.hrbmuser           #FUN-4C0304權限控管
        LET g_data_group=g_hrbm.hrbmgrup
        CALL i030_show()                   # 重新顯示
    END IF
END FUNCTION



FUNCTION i030_show()
DEFINE l_hrbm06_desc       LIKE   hrag_file.hrag07
DEFINE l_hrbm41_n    LIKE gaq_file.gaq03
    LET g_hrbm_t.* = g_hrbm.*
    DISPLAY BY NAME g_hrbm.hrbm01,g_hrbm.hrbm02,g_hrbm.hrbm03,g_hrbm.hrbm04,g_hrbm.hrbm05,
                    g_hrbm.hrbm06,g_hrbm.hrbm07,g_hrbm.hrbm08,g_hrbm.hrbm09,g_hrbm.hrbm10,
                    g_hrbm.hrbm11,g_hrbm.hrbm12,g_hrbm.hrbm13,g_hrbm.hrbm14,g_hrbm.hrbm15,
                    g_hrbm.hrbm16,g_hrbm.hrbm17,g_hrbm.hrbm18,g_hrbm.hrbm19,g_hrbm.hrbm20,
                    g_hrbm.hrbm21,g_hrbm.hrbm22,g_hrbm.hrbm23,g_hrbm.hrbm24,g_hrbm.hrbm25,
                    g_hrbm.hrbm26,g_hrbm.hrbm27,g_hrbm.hrbm41,
                    g_hrbm.hrbmuser,g_hrbm.hrbmgrup,g_hrbm.hrbmmodu,
                    g_hrbm.hrbmdate,g_hrbm.hrbmorig,g_hrbm.hrbmoriu,g_hrbm.hrbmud02

    DISPLAY BY NAME g_hrbm.hrbm28,g_hrbm.hrbm29,g_hrbm.hrbm30,g_hrbm.hrbm31,g_hrbm.hrbm32,
                    g_hrbm.hrbm33,g_hrbm.hrbm34,g_hrbm.hrbm35,g_hrbm.hrbm36,g_hrbm.hrbm37,
                    g_hrbm.hrbm38,g_hrbm.hrbm39,g_hrbm.hrbm40
    SELECT hrag07 INTO l_hrbm06_desc FROM hrag_file WHERE hrag01='504' AND hrag06=g_hrbm.hrbm06
    DISPLAY l_hrbm06_desc TO hrbm06_desc
    SELECT hraa12 INTO g_hraa12 FROM hraa_file WHERE hraa01=g_hrbm.hrbm01
    DISPLAY g_hraa12 TO hraa12
    SELECT gaq03 INTO l_hrbm41_n FROM gaq_file WHERE gaq01=g_hrbm.hrbm41 AND gaq02='2' 
    DISPLAY l_hrbm41_n TO hrbm41_n
    CALL i030_set_page(g_hrbm.hrbm02)
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i030_set_page(p_hrbm02)
DEFINE p_hrbm02    LIKE hrbm_file.hrbm02

   CALL cl_set_comp_visible("page3,page4,page5,page6,page7",FALSE)
   CASE p_hrbm02
      WHEN '001' CALL cl_set_comp_visible("page4",TRUE)
      WHEN '002' CALL cl_set_comp_visible("page4",TRUE)
      WHEN '003' CALL cl_set_comp_visible("page4",TRUE)
      WHEN '004'
            CALL cl_set_comp_visible("page5",TRUE)
     WHEN '005' CALL cl_set_comp_visible("page5",TRUE)
      WHEN '006' CALL cl_set_comp_visible("page5",TRUE)
      WHEN '007' CALL cl_set_comp_visible("page6",TRUE)
      WHEN '008' CALL cl_set_comp_visible("page7",TRUE)
      WHEN '009' CALL cl_set_comp_visible("page3",TRUE)

   END CASE

END FUNCTION

FUNCTION i030_u()
    IF g_hrbm.hrbm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrbm.* FROM hrbm_file WHERE hrbm03=g_hrbm.hrbm03
#    IF g_hrbm.hrbmacti = 'N' THEN
#        CALL cl_err('',9027,0)
#        RETURN
#    END IF
    CALL cl_opmsg('u')
    LET g_hrbm03_t = g_hrbm.hrbm03
    BEGIN WORK

    OPEN i030_cl USING g_hrbm.hrbm03
    IF STATUS THEN
       CALL cl_err("OPEN i030_cl:", STATUS, 1)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i030_cl INTO g_hrbm.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbm.hrbm03,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrbm.hrbmmodu = g_user                  #修改者
    LET g_hrbm.hrbmdate = g_today               #修改日期
    CALL i030_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i030_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrbm.*=g_hrbm_t.*
            CALL i030_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        SELECT to_char(systimestamp, 'hh24:mi:ss') INTO g_hrbm.hrbmud02 FROM dual #FUN-160112 wangjya
        UPDATE hrbm_file SET hrbm_file.* = g_hrbm.*    # 更新DB
            WHERE hrbm03 = g_hrbm_t.hrbm03    #MOD-BB0113 add

        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbm_file",g_hrbm.hrbm03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i030_cl
    COMMIT WORK
    CALL i030_show()
    CALL i030_b_fill(g_wc)
END FUNCTION

FUNCTION i030_r()
    IF g_hrbm.hrbm03 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_hrbm.hrbm36 = 'Y' THEN
       CALL cl_err('','ghr-179',0)
       RETURN
    END IF

    BEGIN WORK
    OPEN i030_cl USING g_hrbm.hrbm03
    IF STATUS THEN
       CALL cl_err("OPEN i030_cl:", STATUS, 0)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i030_cl INTO g_hrbm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbm.hrbm03,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i030_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrbm03"
       LET g_doc.value1 = g_hrbm.hrbm03

       CALL cl_del_doc()
       DELETE FROM hrbm_file WHERE hrbm03 = g_hrbm.hrbm03

       CLEAR FORM
       OPEN i030_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i030_cl
          CLOSE i030_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH i030_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i030_cl
          CLOSE i030_count
          COMMIT WORK
          CALL i030_b_fill(g_wc)
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i030_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i030_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i030_fetch('/')
       END IF
    END IF
    CLOSE i030_cl
    COMMIT WORK
    CALL i030_b_fill(g_wc)
END FUNCTION


PRIVATE FUNCTION i030_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbm03,hrbm02",TRUE)
   END IF

END FUNCTION


PRIVATE FUNCTION i030_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

#   IF p_cmd = 'u' AND g_chkey = 'N' THEN
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("hrbm03,hrbm02,",FALSE)
   END IF
END FUNCTION

FUNCTION i030_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5

        CALL g_hrbm_b.clear()

        LET l_sql=" SELECT hrbm01,'',hrbm02,hrbm03,hrbm04,hrbm05,hrbm06,hrbm07, ",
                  "        hrbm08,hrbm09,hrbm10,hrbm11,hrbm12,hrbm13,hrbm14, ",
                  "        hrbm15,hrbm16,hrbm17,hrbm18,hrbm19,hrbm20,hrbm21, ",
                  "        hrbm22,hrbm23,hrbm24,hrbm25,hrbm26,hrbm27,hrbm28, ",
                  "        hrbm29,hrbm30,hrbm31,hrbm32,hrbm33,hrbm34,hrbm35, ",
                  "        hrbm36 ",
                  "   FROM hrbm_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrbm01,hrbm03"

        PREPARE i030_b_pre FROM l_sql
        DECLARE i030_b_cs CURSOR FOR i030_b_pre

        LET l_i=1

        FOREACH i030_b_cs INTO g_hrbm_b[l_i].*

           SELECT hraa12 INTO g_hrbm_b[l_i].hraa12_b FROM hraa_file
            WHERE hraa01=g_hrbm_b[l_i].hrbm01_b

           LET l_i=l_i+1

           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrbm_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrbm_b TO s_hrbm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION



