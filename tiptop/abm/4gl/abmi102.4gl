# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmi102.4gl
# Descriptions...: E-BOM元件資料維護作業
# Date & Author..: 91/08/10 By Wu
# Modify.........: 92/05/04 By DAVID
# Modify.........: 92/10/30 By Apple
# Modify.........: No:9430 04/04/08 By Melody _u() 中第一個 select * .... from
# Modify.........: No:9432 04/04/09 By Melody (1)per 應該版本輸入後 再輸入 項次
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-560027 05/06/08 By Mandy 1.特性BOM+KEY 值bmo06,bmp28
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION i102_q() 一開始應清空g_bmp.*值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-6B0130 06/12/08 By claire 主件料號取q_bmo, 取消新增功能
# Modify.........: No.TQC-6C0054 06/12/18 By day 刪除資料后抓不到下一筆資料顯示
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750169 07/05/28 By rainy 1 '軟體物件''消耗特性'default 'N'
#                                                  2 輸入完畢後按'確認' 無法正常存檔
#                                                  3 明細單身 倉庫/儲位開窗都無資料
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.TQC-790064 07/09/13 By destiny 修改查詢時狀態欄是灰色問題
# Modify.........: No.TQC-790170 07/19/29 By claire modify #TQC-660046 mark
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-870162 08/07/14 By claire (1)修改發料單位,單位轉換率要即時顯示出來
#                                                   (2)ima86沒有值, 參考abmp100轉正式料號,以bmq25值給予ima86的方式  
# Modify.........: No.MOD-870248 08/07/22 By claire 單位轉換率為空值時要重推
# Modify.........: No.FUN-920042 09/02/04 By jan "工單展開方式"增加 開窗詢問是否展開 選項
# Modify.........: No.FUN-910053 09/02/12 By jan bmp14增加2,3選項
# Modify.........: No.TQC-920054 09/02/20 By destiny 去掉CONSTRUCT段的bmo字段
# Modify.........: No.FUN-980001 09/08/10 By TSD.danny2000 GP5.2架構重整，修改 INSERT INTO 語法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/05 By vealxu 拿掉FUN-AA0059 料號管控，測試料件無需判斷
# Modify.........: No.FUN-AB0025 10/11/05 By lixh1 拿掉FUN-AA0059系統料號的開窗控管
# Modify.........: No.FUN-ABOO25 10/11/11 By lixh1 还原FUN-AA0059 系統開窗管控
# Modify.........: No.TQC-AB0057 10/12/15 By destiny 资料建立部门等栏位未显示          
# Modify.........: No.TQC-AC0183 10/12/15 By liweie bmp081插入前判斷若為空則給預設值0          
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmo   RECORD LIKE bmo_file.*,
    g_bmp   RECORD LIKE bmp_file.*,
    g_bmp_t RECORD LIKE bmp_file.*,
    g_bmp_o RECORD LIKE bmp_file.*,
    g_bmp01_t  LIKE bmp_file.bmp01,
    g_bmp28_t  LIKE bmp_file.bmp28, #FUN-560027 add
    g_bmp011_t LIKE bmp_file.bmp011,
    g_bmp02_t LIKE bmp_file.bmp02,
    g_bmp03_t LIKE bmp_file.bmp03,
    g_ima08_h LIKE ima_file.ima08,
    g_ima37_h LIKE ima_file.ima37,
    g_ima70_h LIKE ima_file.ima70,
    g_ima08_b LIKE ima_file.ima08,
    g_ima37_b LIKE ima_file.ima37,
    g_ima70_b LIKE ima_file.ima70,
    g_ima25_b LIKE ima_file.ima25,
    g_ima63_b LIKE ima_file.ima63,
    g_ima86_b LIKE ima_file.ima86,
    g_ima63_fac LIKE ima_file.ima63_fac,
    g_argv1             LIKE bmo_file.bmo01,          #FUN-560027
    g_argv2             LIKE bmo_file.bmo011,         #FUN-560027
    g_argv3             LIKE bmo_file.bmo06,          #FUN-560027 add
    g_sw                LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    g_wc,g_sql          STRING                        #No.FUN-580092 HCN
DEFINE g_forupd_sql     STRING                        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680096 VARCHAR(72)   
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3) #FUN-560027 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    INITIALIZE g_bmp.* TO NULL
    INITIALIZE g_bmp_t.* TO NULL
    INITIALIZE g_bmp_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bmp_file WHERE bmp01 = ? AND bmp28 = ? AND bmp011 = ? AND bmp02 = ? AND bmp03 = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i102_w WITH FORM "abm/42f/abmi102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmp28",g_sma.sma118='Y')
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i102_q()
    END IF
 
    LET g_action_choice=""
    CALL i102_menu()
 
    CLOSE WINDOW i102_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION i102_curs()
DEFINE  l_cmd      LIKE type_file.chr1000       #No.FUN-680096  VARCHAR(60)
    CLEAR FORM
    DISPLAY BY NAME  g_bmp.bmp01,g_bmp.bmp28,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03 #FUN-560027 add bmp28
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql="SELECT bmp01,bmp28,bmp011,bmp02,bmp03 ", #BugNo:6164 #FUN-560027 add bmp28 #TQC-870018
                      " FROM bmp_file ",                      # 組合出 SQL 指令
                       " WHERE bmp01  ='",g_argv1,"'",
                       "   AND bmp011 ='",g_argv2,"'",
                       "   AND bmp28  ='",g_argv3,"'", #FUN-560027 add
                       "   ORDER BY bmp01,bmp28,bmp011,bmp02" #FUN-560027
       ELSE
   INITIALIZE g_bmp.* TO NULL    #No.FUN-750051
            CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              bmp01,bmp28,bmp011,bmp02,bmp03,bmp10,bmp10_fac, #FUN-560027 add bmp28
              bmp10_fac2, bmp06,bmp07,bmp08,bmp23,bmp11,bmp13,bmp16,
              bmp27,bmp15,bmp09,bmp18,bmp14,bmp19,bmp25,bmp26
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(bmp01) #料件主檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmo2"   #MOD-6B0130 modify
                     LET g_qryparam.default1 = g_bmp.bmp01
                     LET g_qryparam.default2 = g_bmp.bmp011
                     CALL cl_create_qry() RETURNING g_bmp.bmp01,g_bmp.bmp011,g_bmo.bmo06
                     DISPLAY BY NAME g_bmp.bmp01
                     DISPLAY BY NAME g_bmp.bmp011
                     NEXT FIELD bmp01
                  WHEN INFIELD(bmp03) #料件主檔
#FUN-AB0025 --Begin-- remark 
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   LET g_qryparam.default1 = g_bmp.bmp03
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","",g_bmp.bmp03,"","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
                     DISPLAY g_qryparam.multiret TO bmp03
                     NEXT FIELD bmp03
                  WHEN INFIELD(bmp09) #作業主檔
                     CALL q_ecd(TRUE,TRUE,g_bmp.bmp09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmp09
                     NEXT FIELD bmp09
                  WHEN INFIELD(bmp10) #單位檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_bmp.bmp10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmp10
                     NEXT FIELD bmp10
                  WHEN INFIELD(bmp25) #倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfd"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_bmp.bmp25
                     LET g_qryparam.where = " imf01='",g_bmp.bmp03,"'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmp25
                     NEXT FIELD bmp25
                  WHEN INFIELD(bmp26) #儲位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_bmp.bmp26
                     LET g_qryparam.where = " ime01='",g_bmp.bmp25,"'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmp26
                     NEXT FIELD bmp26
                  WHEN  INFIELD(bmp05)
                     IF g_bmp_t.bmp02 IS NOT NULL
                        THEN LET l_cmd = "abmi103 '",g_bmp.bmp01,"' '",
                                          g_bmp.bmp02,"' '",
                                          g_bmp.bmp03,"' '",
                                          g_bmp.bmp011,"' ",
                                          "'",g_bmp.bmp28,"'"               #FUN-560027 add
                             CALL cl_cmdrun(l_cmd)
                     END IF
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
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
            ON ACTION qbe_save
               CALL cl_qbe_save()
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
        LET g_sql="SELECT bmp01,bmp28,bmp011,bmp02,bmp03 ", #FUN-560027 add bmp28 #TQC-870018
                  " FROM bmp_file ",                      # 組合出 SQL 指令
                  " WHERE ",g_wc CLIPPED,
                  "   ORDER BY bmp01,bmp28,bmp011,bmp02 " #FUN-560027
    END IF
 
    PREPARE i102_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i102_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i102_prepare
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql =
                "SELECT COUNT(*) FROM bmp_file WHERE bmp01  ='",g_argv1,"'",
                                              "  AND bmp011 ='",g_argv2,"'",
                                              "  AND bmp28  ='",g_argv3,"'" #FUN-560027 add
       ELSE LET g_sql=
                "SELECT COUNT(*) FROM bmp_file WHERE ",g_wc CLIPPED
    END IF
    PREPARE i102_precount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_precount
END FUNCTION
 
FUNCTION i102_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL i102_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i102_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i102_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i102_copy()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_bmo.bmoacti)
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION first
           CALL i102_fetch('F')
 
        ON ACTION previous
           CALL i102_fetch('P')
 
        ON ACTION jump
           CALL i102_fetch('/')
 
        ON ACTION next
           CALL i102_fetch('N')
 
        ON ACTION last
           CALL i102_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document                   #MOD-470051
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_bmp.bmp01 IS NOT NULL THEN
                 LET g_doc.column1 = "bmp01"
                 LET g_doc.value1  = g_bmp.bmp01
                 LET g_doc.column2 = "bmp011"
                 LET g_doc.value2  = g_bmp.bmp011
                 LET g_doc.column3 = "bmp02"
                 LET g_doc.value3  = g_bmp.bmp02
                 LET g_doc.column4 = "bmp03"
                 LET g_doc.value4  = g_bmp.bmp03
                 LET g_doc.column5 = "bmp28"         #FUN-560027 add
                 LET g_doc.value5  = g_bmp.bmp28     #FUN-560027 add
                 CALL cl_doc()
              END IF
           END IF
 
      &include "qry_string.4gl"
    END MENU
    CLOSE i102_curs
END FUNCTION
 
 
FUNCTION i102_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bmp.* LIKE bmp_file.*
    LET g_bmp01_t = NULL LET g_bmp011_t = NULL
    LET g_bmp28_t = NULL  #FUN-560027 add
    LET g_bmp02_t = NULL LET g_bmp03_t = NULL
    LET g_bmp_t.*=g_bmp.*
    LET g_bmp_o.*=g_bmp.*
    LET g_bmp.bmp01 = ARG_VAL(1)
    LET g_bmp.bmp011= ARG_VAL(2) #FUN-560027 add
    LET g_bmp.bmp28 = ARG_VAL(3) #FUN-560027 add
    LET g_bmp.bmp06 = 1
    LET g_bmp.bmp07 = 1
    LET g_bmp.bmp08 = 0
    LET g_bmp.bmp09 = ''
    LET g_bmp.bmp10_fac = 1
    LET g_bmp.bmp10_fac2 = 1
    LET g_bmp.bmp14 = '0'
    LET g_bmp.bmp15 = 'N'
    LET g_bmp.bmp17 = 'N'
    LET g_bmp.bmp16 = '0'
    LET g_bmp.bmp18 =  0
    LET g_bmp.bmp19 = '1'
    LET g_bmp.bmp23 = 0
    LET g_bmp.bmp25 =  NULL
    LET g_bmp.bmp26 =  NULL
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i102_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_bmp.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_bmp.bmp01) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_bmp.bmp011)  THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_bmp.bmp28 IS NULL THEN                # KEY 不可空白
            LET g_bmp.bmp28 = ' '
        END IF
        IF cl_null(g_bmp.bmp04) THEN
           LET g_bmp.bmp04=0
        END IF
        
      #TQC-AC0183---begin----
        IF cl_null(g_bmp.bmp081) THEN
           LET g_bmp.bmp081=0 
        END IF
      #TQC-AC0183---end-----
     
        INSERT INTO bmp_file VALUES(g_bmp.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
                      CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
             CALL cl_err3("ins","bmp_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
            CONTINUE WHILE
        ELSE
            LET g_bmp_t.* = g_bmp.*                # 保存上筆資料
            LET g_bmp_o.* = g_bmp.*
            SELECT bmp01,bmp28,bmp011,bmp02,bmp03 INTO g_bmp.bmp01,g_bmp.bmp28,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03 FROM bmp_file
                WHERE bmp01 = g_bmp.bmp01 AND bmp011 = g_bmp.bmp011
                  AND bmp02 = g_bmp.bmp02 AND bmp03 = g_bmp.bmp03
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i102_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000,       #No.FUN-680096 VARCHAR(60)
        l_n             LIKE type_file.num5,          #No.FUN-680096 SMALLINT
        l_ima08         LIKE ima_file.ima08,
        l_bmp01         LIKE bmp_file.bmp01,
        l_ime09         LIKE ime_file.ime09,
        l_qpa           LIKE bmp_file.bmp06,
        l_code          LIKE type_file.num5,          #No.FUN-680096 SMALLINT
        l_flag          LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
        l_cnt           LIKE type_file.num5           #No.FUN-680096 SMALLINT
 
    INPUT BY NAME
      g_bmp.bmp01,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03,
      g_bmp.bmp10,g_bmp.bmp10_fac,g_bmp.bmp10_fac2,
      g_bmp.bmp06,g_bmp.bmp07,g_bmp.bmp08,g_bmp.bmp23,
      g_bmp.bmp11,g_bmp.bmp13,g_bmp.bmp16,g_bmp.bmp27,
      g_bmp.bmp15,g_bmp.bmp09,g_bmp.bmp18,
      g_bmp.bmp14,g_bmp.bmp19,g_bmp.bmp25,g_bmp.bmp26
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i102_set_entry(p_cmd)
            CALL i102_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD bmp01                  #主件料號
            IF NOT cl_null(g_bmp.bmp01) THEN
#FUN-AB0025 -----------------mark start-----------
#              #FUN-AA0059 ---------------------------add start--------------------------
#              IF NOT s_chk_item_no(g_bmp.bmp01,'') THEN
#                 CALL cl_err('',g_errno,1) 
#                 LET g_bmp.bmp01 = g_bmp01_t
#                 DISPLAY BY NAME g_bmp.bmp01
#                 NEXT FIELD bmp01
#              END IF 
#              #FUN-AA0059 ---------------------------add end-----------------------------  
#FUN-AB0025 -----------------mark end----------------------
               IF g_bmp.bmp01 != g_bmp01_t OR g_bmp01_t IS NULL THEN
                  #-->check 是否存在正式的 BOM 中
                  SELECT count(*) INTO g_cnt FROM bma_file
                   WHERE bma01 = g_bmp.bmp01
                  IF g_cnt > 0 THEN
                     CALL cl_err(g_bmp.bmp01,'mfg2758',0)
                     LET g_bmp.bmp01 = g_bmp01_t
                     DISPLAY BY NAME g_bmp.bmp01
                     NEXT FIELD bmp01
                  END IF
               END IF
               CALL i102_bmp01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bmp.bmp01,g_errno,0) 
                  LET g_bmp.bmp01 = g_bmp_o.bmp01
                  DISPLAY BY NAME g_bmp.bmp01
                  NEXT FIELD bmp01
               END IF
            END IF
 
        BEFORE FIELD bmp02                        #default 項次
            IF cl_null(g_bmp.bmp02) OR g_bmp.bmp02 = 0
            THEN SELECT max(bmp02)+1 INTO g_bmp.bmp02 FROM bmp_file
                   WHERE bmp01  = g_bmp.bmp01
                     AND bmp011 = g_bmp.bmp011 #No:9432
                IF cl_null(g_bmp.bmp02)
                   THEN LET g_bmp.bmp02 = 1
                END IF
                DISPLAY BY NAME g_bmp.bmp02
            END IF
 
        BEFORE FIELD bmp03
           IF g_sma.sma60 = 'Y'		# 若須分段輸入
           THEN CALL s_inp5(10,15,g_bmp.bmp03) RETURNING g_bmp.bmp03
                DISPLAY BY NAME g_bmp.bmp03
           END IF
           LET g_bmp03_t = g_bmp.bmp03
 
        AFTER FIELD bmp03                  #元件料號
            IF NOT cl_null(g_bmp.bmp03) THEN
#FUN-AB0025 -----------mark start--------------
#              #FUN-AA0059 --------------------------------add start-------------------
#              IF NOT s_chk_item_no(g_bmp.bmp03,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_bmp.bmp03 = g_bmp03_t
#                 DISPLAY BY NAME g_bmp.bmp03
#                 NEXT FIELD bmp03
#              END IF 
#              #FUN-AA0059 -----------------------------add end-------------------------   
#FUN-AB0025 -----------mark end----------------
               CALL i102_bmp03(p_cmd)   #必需讀取料件主檔
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bmp.bmp03,g_errno,0) 
                  LET g_bmp.bmp03=g_bmp_t.bmp03
                  DISPLAY BY NAME g_bmp.bmp03
                  NEXT FIELD bmp03
               END IF
               IF g_bmp.bmp01 != g_bmp01_t OR g_bmp01_t IS NULL
                  OR g_bmp.bmp011 != g_bmp011_t OR g_bmp011_t IS NULL
                  OR g_bmp.bmp02 != g_bmp02_t OR g_bmp02_t IS NULL
                  OR g_bmp.bmp03 != g_bmp03_t OR g_bmp03_t IS NULL THEN
                   SELECT count(*) INTO g_cnt FROM bmp_file
                       WHERE bmp01 = g_bmp.bmp01 AND bmp011= g_bmp.bmp011
                         AND bmp02 = g_bmp.bmp02 AND bmp03 = g_bmp.bmp03
                   IF g_cnt > 0 THEN   #資料重複
                       LET g_msg = g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp02
                                   CLIPPED,'+',g_bmp.bmp03 CLIPPED,'+',
                                   g_bmp.bmp04
                       CALL cl_err(g_msg,-239,0)
                       LET g_bmp.bmp02 = g_bmp02_t
                       LET g_bmp.bmp011 = g_bmp011_t
                       LET g_bmp.bmp03 = g_bmp03_t
                       DISPLAY BY NAME g_bmp.bmp01
                       DISPLAY BY NAME g_bmp.bmp011
                       DISPLAY BY NAME g_bmp.bmp02
                       DISPLAY BY NAME g_bmp.bmp03
                       NEXT FIELD bmp01
                   END IF
               END IF
            END IF
 
        AFTER FIELD bmp06    #組成用量不可小於零
           IF g_bmp.bmp06 <= 0
              THEN CALL cl_err(g_bmp.bmp06,'mfg2614',0)
                   LET g_bmp.bmp06 = g_bmp_o.bmp06
                   DISPLAY BY NAME g_bmp.bmp06
                   NEXT FIELD bmp06
           END IF
           LET g_bmp_o.bmp06 = g_bmp.bmp06
 
        AFTER FIELD bmp07    #底數不可小於等於零
           IF g_bmp.bmp07 <= 0 THEN
              CALL cl_err(g_bmp.bmp07,'mfg2615',0)
              LET g_bmp.bmp07 = g_bmp_o.bmp07
              DISPLAY BY NAME g_bmp.bmp07
              NEXT FIELD bmp07
           END IF
           LET g_bmp_o.bmp07 = g_bmp.bmp07
 
        AFTER FIELD bmp08    #損耗率
           IF g_bmp.bmp08 < 0 OR g_bmp.bmp08 > 100
              THEN CALL cl_err(g_bmp.bmp08,'mfg0013',0)
                   LET g_bmp.bmp08 = g_bmp_o.bmp08
                   DISPLAY BY NAME g_bmp.bmp08
                   NEXT FIELD bmp08
           END IF
           LET g_bmp_o.bmp08 = g_bmp.bmp08
 
        AFTER FIELD bmp10   #發料單位
           IF NOT cl_null(g_bmp.bmp10) THEN
              IF (g_bmp_o.bmp10 IS NULL) OR (g_bmp.bmp10 != g_bmp_o.bmp10)
                 OR (cl_null(g_bmp.bmp10)) OR (cl_null(g_bmp.bmp10_fac2))  #MOD-870248 add
                 THEN SELECT gfe01 FROM gfe_file
                       WHERE gfe01 = g_bmp.bmp10 AND
                             gfeacti IN ('Y','y')
                       IF SQLCA.sqlcode != 0 THEN
                          CALL cl_err3("sel","gfe_file",g_bmp.bmp10,"","mfg2605","","",1)   #No.TQC-660046
                          LET g_bmp.bmp10 = g_bmp_o.bmp10
                          DISPLAY BY NAME g_bmp.bmp10
                          NEXT FIELD bmp10
                       ELSE IF g_bmp.bmp10 != g_ima25_b OR (cl_null(g_bmp.bmp10_fac))  #MOD-870248 modify (cl_null(g_bmp.bmp10_fac))
                            THEN CALL s_umfchk(g_bmp.bmp03,g_bmp.bmp10,
                                               g_ima25_b)
                                 RETURNING g_sw,g_bmp.bmp10_fac #發料/庫存單位
                                 IF g_sw = '1' THEN
                                    CALL cl_err(g_bmp.bmp10,'mfg2721',0)
                                    LET g_bmp.bmp10 = g_bmp_o.bmp10
                                    DISPLAY BY NAME g_bmp.bmp10
                                    LET g_bmp.bmp10_fac = g_bmp_o.bmp10_fac
                                    DISPLAY BY NAME g_bmp.bmp10_fac
                                    NEXT FIELD bmp10
                                 END IF
                            ELSE LET g_bmp.bmp10_fac  = 1
                            END IF
                            IF g_bmp.bmp10 != g_ima86_b  OR (cl_null(g_bmp.bmp10_fac2)) #發料/成本單位  #MOD-870248 modify (cl_null(g_bmp.bmp10_fac2))
                               THEN CALL s_umfchk(g_bmp.bmp03,g_bmp.bmp10,
                                                  g_ima86_b)
                                    RETURNING g_sw,g_bmp.bmp10_fac2
                                    IF g_sw = '1' THEN
                                       CALL cl_err(g_bmp.bmp03,'mfg2722',0)
                                       LET g_bmp.bmp10 = g_bmp_o.bmp10
                                       DISPLAY BY NAME g_bmp.bmp10
                                       LET g_bmp.bmp10_fac2 = g_bmp_o.bmp10_fac2
                                       DISPLAY BY NAME g_bmp.bmp10_fac2
                                       NEXT FIELD bmp10
                                    END IF
                               ELSE LET g_bmp.bmp10_fac2 = 1
                            END IF
                       END IF
              END IF
              LET g_bmp_o.bmp10 = g_bmp.bmp10
              LET g_bmp_o.bmp10_fac = g_bmp.bmp10_fac
              LET g_bmp_o.bmp10_fac2 = g_bmp.bmp10_fac2
              DISPLAY BY NAME g_bmp.bmp10_fac     #MOD-870162 add
              DISPLAY BY NAME g_bmp.bmp10_fac2    #MOD-870162 add
           END IF
        AFTER FIELD bmp10_fac   #發料/料件庫存轉換率
           IF g_bmp.bmp10_fac <= 0
              THEN CALL cl_err(g_bmp.bmp10_fac,'mfg1322',0)
                   LET g_bmp.bmp10_fac = g_bmp_o.bmp10_fac
                   DISPLAY BY NAME g_bmp.bmp10_fac
                   NEXT FIELD bmp10_fac
           END IF
           LET g_bmp_o.bmp10_fac = g_bmp.bmp10_fac
 
        AFTER FIELD bmp10_fac2   #發料/料件成本轉換率
            IF g_bmp.bmp10_fac2 <= 0
               THEN CALL cl_err(g_bmp.bmp10_fac2,'mfg1322',0)
                    LET g_bmp.bmp10_fac2 = g_bmp_o.bmp10_fac2
                    DISPLAY BY NAME g_bmp.bmp10_fac2
                    NEXT FIELD bmp10_fac2
            END IF
            LET g_bmp_o.bmp10_fac2 = g_bmp.bmp10_fac2
 
        AFTER FIELD bmp09    #作業編號
             IF NOT cl_null(g_bmp.bmp09) THEN
                SELECT COUNT(*) INTO g_cnt FROM ecd_file
                 WHERE ecd01=g_bmp.bmp09
                IF g_cnt=0 THEN
                   CALL cl_err('sel ecd_file',100,0)
                   NEXT FIELD bmp09
                END IF
             END IF
 
        AFTER FIELD bmp14     #使用特性
            IF g_bmp.bmp14 NOT MATCHES'[0123]'  #FUN-910053 add 23
               THEN NEXT FIELD bmp14
            END IF
 
        AFTER FIELD bmp27  #軟體物件
            LET g_bmp_o.bmp27 = g_bmp.bmp27
 
        AFTER FIELD bmp15  #消耗料件
            LET g_bmp_o.bmp15 = g_bmp.bmp15
 
          AFTER FIELD bmp16  #替代特性
             IF g_bmp.bmp16 NOT MATCHES '[012]'
               THEN NEXT FIELD bmp16
                    LET g_bmp.bmp16 = g_bmp_o.bmp16
                    DISPLAY BY NAME g_bmp.bmp16
                    NEXT FIELD bmp16
             END IF
             IF g_bmp.bmp16 != '0' AND (g_bmp.bmp16 != g_bmp_o.bmp16)
                THEN CALL i102_prompt()   #詢問是否輸入取代或替代料件
             END IF
             LET g_bmp_o.bmp16 = g_bmp.bmp16
 
          AFTER FIELD bmp18     #投料時距
             IF cl_null(g_bmp.bmp18)
             THEN LET g_bmp.bmp18 = 0
                  DISPLAY BY NAME g_bmp.bmp18
             END IF
 
 
        AFTER FIELD bmp23    #選中率
            IF g_bmp.bmp23 < 0 OR g_bmp.bmp23 > 100
               THEN CALL cl_err(g_bmp.bmp23,'mfg0013',0)
                    LET g_bmp.bmp23 = g_bmp_o.bmp23
                    DISPLAY BY NAME g_bmp.bmp23
                    NEXT FIELD bmp23
            END IF
            LET g_bmp_o.bmp23 = g_bmp.bmp23
 
       AFTER FIELD bmp19
            IF g_bmp.bmp19 not matches '[1234]'   #FUN-920042 add 4
            THEN  LET g_bmp.bmp19 = g_bmp_o.bmp19
                  DISPLAY BY NAME g_bmp.bmp19
                  NEXT FIELD bmp19
            END IF
            LET g_bmp_o.bmp19 = g_bmp.bmp19
 
          AFTER FIELD bmp25     # Warehouse
            IF NOT cl_null(g_bmp.bmp25) THEN
                 CALL i102_bmp25('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bmp.bmp25,g_errno,0)
                    LET g_bmp.bmp25 = g_bmp_o.bmp25
                    DISPLAY BY NAME g_bmp.bmp25
                    NEXT FIELD bmp25
                 END IF
 #------>check-1
                 IF NOT s_imfchk1(g_bmp.bmp03,g_bmp.bmp25)
                    THEN CALL cl_err(g_bmp.bmp25,'mfg9036',0)
                         NEXT FIELD bmp25
                 END IF
 #------>check-2
                 CALL s_stkchk(g_bmp.bmp25,'A') RETURNING l_code
                 IF NOT l_code THEN
                     CALL cl_err(g_bmp.bmp25,'mfg1100',0)
                     NEXT FIELD bmp25
                 END IF
            END IF
 
 
          AFTER FIELD bmp26     # Location
            IF NOT cl_null(g_bmp.bmp26) THEN
               IF NOT s_imfchk(g_bmp.bmp03,g_bmp.bmp25,g_bmp.bmp26)
                 THEN CALL cl_err(g_bmp.bmp26,'mfg6095',0)
                      NEXT FIELD bmp26
               END IF
            END IF
            IF g_bmp.bmp26 IS NULL THEN LET g_bmp.bmp26 = ' ' END IF
 
        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF cl_null(g_bmp.bmp05)
               THEN IF g_bmp.bmp05 < g_bmp.bmp04
                       THEN CALL cl_err(g_bmp.bmp05,'mfg2604',0)
                            LET l_flag = 'Y'
                    END IF
            END IF
            IF cl_null(g_bmp.bmp10_fac) THEN
               CALL cl_err('','abm-731',0)  #TQC-750169
               DISPLAY BY NAME g_bmp.bmp10_fac
               NEXT FIELD bmp10             #TQC-750169
            END IF
            IF cl_null(g_bmp.bmp10_fac2) THEN
               CALL cl_err('','abm-731',0)  #TQC-750169
               DISPLAY BY NAME g_bmp.bmp10_fac2
               NEXT FIELD bmp10             #TQC-750169
            END IF
          
            IF cl_null(g_bmp.bmp14) OR g_bmp.bmp14 NOT MATCHES'[0123]' THEN  #FUN-910053 add 23
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmp.bmp14
            END IF
            IF cl_null(g_bmp.bmp15) OR g_bmp.bmp15 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmp.bmp15
            END IF
            IF cl_null(g_bmp.bmp27) OR g_bmp.bmp27 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmp.bmp27
            END IF
            IF cl_null(g_bmp.bmp16) OR g_bmp.bmp16 NOT MATCHES'[012]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmp.bmp16
            END IF
            IF cl_null(g_bmp.bmp18) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmp.bmp18
            END IF
            IF cl_null(g_bmp.bmp23) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_bmp.bmp23
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD  bmp01
            END IF
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(bmp01) #料件主檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmq"
                  LET g_qryparam.default1 = g_bmp.bmp01
                  CALL cl_create_qry() RETURNING g_bmp.bmp01
                  DISPLAY BY NAME g_bmp.bmp01
                  NEXT FIELD bmp01
               WHEN INFIELD(bmp03) #料件主檔
#FUN-AB0025 --Begin--  REMARK
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima"
               #   LET g_qryparam.default1 = g_bmp.bmp03
               #   CALL cl_create_qry() RETURNING g_bmp.bmp03
                  CALL q_sel_ima(FALSE, "q_ima", "",g_bmp.bmp03 , "", "", "", "" ,"",'' )  RETURNING g_bmp.bmp03
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
                  DISPLAY BY NAME g_bmp.bmp03
                  NEXT FIELD bmp03
               WHEN INFIELD(bmp09) #作業主檔
                  CALL q_ecd(FALSE,TRUE,g_bmp.bmp09)
                       RETURNING g_bmp.bmp09
                  DISPLAY BY NAME g_bmp.bmp09
                  NEXT FIELD bmp09
               WHEN INFIELD(bmp10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmp.bmp10
                  CALL cl_create_qry() RETURNING g_bmp.bmp10
                  DISPLAY BY NAME g_bmp.bmp10
                  NEXT FIELD bmp10
               WHEN INFIELD(bmp25) #倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfd"
                  LET g_qryparam.default1 = g_bmp.bmp25
                  CALL cl_create_qry() RETURNING g_bmp.bmp25
                  DISPLAY BY NAME g_bmp.bmp25
                  NEXT FIELD bmp25
               WHEN INFIELD(bmp26) #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfe"
                  LET g_qryparam.default1 = g_bmp.bmp26
                  #LET g_qryparam.where = " ime01='",g_bmp.bmp25,"'"
                  LET g_qryparam.arg1 = g_bmp.bmp25
                  CALL cl_create_qry() RETURNING g_bmp.bmp26
                  DISPLAY BY NAME g_bmp.bmp26
                  NEXT FIELD bmp26
               WHEN  INFIELD(bmp05)
                  IF g_bmp_t.bmp02 IS NOT NULL
                     THEN LET l_cmd = "abmi103 '",g_bmp.bmp01,"' '",
                                       g_bmp.bmp02,"' '",
                                       g_bmp.bmp03,"' '",
                                       g_bmp.bmp011,"'"
                          CALL cl_cmdrun(l_cmd)
                  END IF
            END CASE
 
       ON ACTION qry_test_item
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmq"
                  LET g_qryparam.default1 = g_bmp.bmp03
                  CALL cl_create_qry() RETURNING g_bmp.bmp03
                  DISPLAY BY NAME g_bmp.bmp03
                  NEXT FIELD bmp03
 
        ON ACTION mntn_item_brand
              LET l_cmd="abmi150 '",g_bmp.bmp03,"' '",g_bmp.bmp01,"'",
                        "'",g_bmp.bmp011,"'"
			  CALL cl_cmdrun(l_cmd)
              NEXT FIELD bmp03
 
        ON ACTION mntn_unit_conv            #建立單位換算資料
                 CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_insert_loc           #建立插件位置
                 IF g_bmp_t.bmp03 IS NOT NULL AND g_bmp_t.bmp03 != ' '
                 THEN LET l_qpa = g_bmp.bmp06/g_bmp.bmp07
                      CALL i300(g_bmp.bmp01,g_bmp.bmp02,
                                g_bmp.bmp03,'','u',l_qpa,g_bmp.bmp011,g_bmp.bmp28) #FUN-560027 add bmp28
                      CALL i102_up_bmp13() RETURNING g_bmp.bmp13 #FUN-560027 add
                      DISPLAY g_bmp.bmp13 TO bmp13 #FUN-560027 add
                 END IF
 
        ON ACTION CONTROLF                    # 欄位說明
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
 
FUNCTION i102_prompt()
    DEFINE l_cmd     LIKE type_file.chr50        #No.FUN-680096  VARCHAR(40)
 
  IF g_bmp.bmp16 = '1' THEN
     CALL cl_getmsg('mfg2629',g_lang) RETURNING g_msg
  ELSE
     CALL cl_getmsg('mfg2716',g_lang) RETURNING g_msg
  END IF
  WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
    PROMPT g_msg CLIPPED FOR g_chr
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
    END PROMPT
    IF g_chr  MATCHES'[YyNn]' THEN EXIT WHILE END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 END IF
  END WHILE
  IF g_chr MATCHES '[Yy]'
     THEN  IF g_bmp.bmp16 MATCHES '[12]' THEN
                   LET l_cmd = "abmi104 '",g_bmp.bmp01,"' ",
                                       "'",g_bmp.bmp02,"' ",
                                       "'",g_bmp.bmp16,"' ",
                                       "'",g_bmp.bmp011,"' "
                   CALL cl_cmdrun(l_cmd)
           END IF
  END IF
END FUNCTION
 
FUNCTION i102_bmp01(p_cmd)  #主件料件
    DEFINE  l_ima02   LIKE ima_file.ima02,
            l_ima021  LIKE ima_file.ima021,
            l_imaacti LIKE ima_file.imaacti,
            l_bmq011  LIKE bmq_file.bmq011,
            p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima37,ima08,ima70,imaacti
      INTO l_ima02,l_ima021,g_ima37_h,g_ima08_h,g_ima70_h,l_imaacti
       FROM ima_file WHERE ima01 = g_bmp.bmp01
 
    CASE WHEN SQLCA.SQLCODE
              SELECT  bmq011,bmq02,bmq021,bmq08,bmqacti
              INTO l_bmq011,l_ima02,l_ima021,g_ima08_h,l_imaacti
                 FROM bmq_file
                WHERE bmq01 = g_bmp.bmp01
                  IF SQLCA.sqlcode THEN
                      LET g_errno = 'mfg2602'
                      LET l_ima02 = NULL LET l_ima021 = NULL
                      LET g_ima08_h = NULL
                      LET l_imaacti = NULL
                  END IF
              IF l_bmq011 IS NOT NULL AND l_bmq011 != ' ' THEN
                 LET g_errno = 'mfg2764'
              END IF
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h1
       DISPLAY l_ima021 TO FORMONLY.ima021_h1
       DISPLAY g_ima08_h TO FORMONLY.ima08_1
    END IF
END FUNCTION
 
FUNCTION i102_bmp03(p_cmd)  #元件料件
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima04   LIKE ima_file.ima04,
           l_ima105  LIKE ima_file.ima105,
           l_ima110  LIKE ima_file.ima110,
           l_imaacti LIKE ima_file.imaacti,
           l_bmq011  LIKE bmq_file.bmq011
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima04,ima25,ima63,ima37,ima08,ima70,ima105,
           ima110,imaacti,ima86                                       #MOD-870162 add ima86
      INTO l_ima02,l_ima021,l_ima04,g_ima25_b,g_ima63_b,g_ima37_b,
           g_ima08_b,g_ima70_b,l_ima105,l_ima110,l_imaacti,g_ima86_b  #MOD-870162 add g_ima86_b
      FROM ima_file WHERE ima01 = g_bmp.bmp03
 
    CASE WHEN SQLCA.SQLCODE = 100
              SELECT bmq011,bmq02,bmq021,bmq25,bmq63,bmq37,bmq08,bmq105,
                     bmqacti,bmq25                                   #MOD-870162 add bmq25,因沒有成本單位,依abmq100拋ima86的方式
                INTO l_bmq011,l_ima02,l_ima021,g_ima25_b,g_ima63_b,g_ima37_b,
                     g_ima08_b,l_ima105,l_imaacti,g_ima86_b          #MOD-870162 add g_ima86_b  
               FROM bmq_file
               WHERE bmq01 = g_bmp.bmp03
            IF SQLCA.sqlcode THEN
                LET g_errno = 'mfg2772'
                LET l_ima02 = NULL LET l_ima021= NULL
                LET l_ima105= NULL
                LET l_imaacti = NULL
            END IF
            IF l_bmq011 IS NOT NULL AND l_bmq011 != ' '
            THEN LET g_errno = 'mfg2764'
            END IF
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima08_b = 'D' THEN LET g_bmp.bmp17 = 'Y'      #元件為feature flag
                       ELSE LET g_bmp.bmp17 = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
    IF p_cmd = 'a' THEN
      LET g_bmp.bmp10 = g_ima63_b
      LET g_bmp.bmp15 = g_ima70_b
      IF cl_null(g_bmp.bmp15) THEN LET g_bmp.bmp15 = 'N' END IF
      LET g_bmp.bmp27 = l_ima105
      LET g_bmp.bmp19 = l_ima110
      IF cl_null(g_bmp.bmp19) THEN LET g_bmp.bmp19 = '1' END IF
      LET g_bmp.bmp11 = l_ima04
      DISPLAY BY NAME g_bmp.bmp10
      DISPLAY BY NAME g_bmp.bmp19
      DISPLAY BY NAME g_bmp.bmp15
      DISPLAY BY NAME g_bmp.bmp27
      DISPLAY BY NAME g_bmp.bmp11
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h2
       DISPLAY l_ima021 TO FORMONLY.ima021_h2
       DISPLAY g_ima08_b TO FORMONLY.ima08_2
    END IF
END FUNCTION
 
 
FUNCTION i102_bmp25(p_cmd)  # Warehouse
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_imd02   LIKE imd_file.imd02,
           l_imdacti LIKE imd_file.imdacti
 
    LET g_errno = ' '
    SELECT  imd02,imdacti INTO l_imd02,l_imdacti FROM imd_file
            WHERE imd01 = g_bmp.bmp25
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
                            LET l_imd02 = NULL
                            LET l_imdacti= NULL
         WHEN l_imdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmp.* TO NULL                #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i102_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmp.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i102_count
    FETCH i102_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i102_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
                  CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmp.* TO NULL
    ELSE
        CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i102_fetch(p_flbmp)
    DEFINE
        p_flbmp          LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    CASE p_flbmp
        WHEN 'N' FETCH NEXT     i102_curs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                                           g_bmp.bmp011,
                                                           g_bmp.bmp02,
                                                           g_bmp.bmp03 #TQC-870018
        WHEN 'P' FETCH PREVIOUS i102_curs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                                           g_bmp.bmp011,
                                                           g_bmp.bmp02,
                                                           g_bmp.bmp03 #TQC-870018
        WHEN 'F' FETCH FIRST    i102_curs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                                           g_bmp.bmp011,
                                                           g_bmp.bmp02,
                                                           g_bmp.bmp03 #TQC-870018
        WHEN 'L' FETCH LAST     i102_curs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                                           g_bmp.bmp011,
                                                           g_bmp.bmp02,
                                                           g_bmp.bmp03 #TQC-870018
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i102_curs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                                  g_bmp.bmp011,
                                                  g_bmp.bmp02,
                                                  g_bmp.bmp03 #TQC-870018
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp28  CLIPPED,'+',g_bmp.bmp011 CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmp.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbmp
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bmp.* FROM bmp_file         # 重讀DB,因TEMP有不被更新特性
       WHERE bmp01=g_bmp.bmp01 AND bmp28 =g_bmp.bmp28 AND bmp011 = g_bmp.bmp011 AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03
    IF SQLCA.sqlcode THEN
       LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
                 CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
       CALL cl_err3("sel","bmp_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
    ELSE
        CALL i102_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION i102_show()
  DEFINE  l_bmouser LIKE bmo_file.bmouser,
          l_bmogrup LIKE bmo_file.bmogrup,
          l_bmomodu LIKE bmo_file.bmomodu,
          l_bmodate LIKE bmo_file.bmodate,
          l_bmoacti LIKE bmo_file.bmoacti,
          l_bmoorig LIKE bmo_file.bmoorig,
          l_bmooriu LIKE bmo_file.bmooriu
 
    LET g_bmp_t.* = g_bmp.*
    LET g_bmp_o.* = g_bmp.*
    SELECT bmouser, bmogrup, bmomodu, bmodate, bmoacti,bmoorig,bmooriu                 #TQC-AB0057
      INTO l_bmouser, l_bmogrup, l_bmomodu, l_bmodate, l_bmoacti,l_bmoorig,l_bmooriu   #TQC-AB0057
       FROM bmo_file
      WHERE bmo01 = g_bmp.bmp01 AND bmo011 = g_bmp.bmp011
    IF SQLCA.sqlcode THEN
       LET l_bmouser = ' '  LET l_bmogrup = ' '
       LET l_bmomodu = ' '  LET l_bmodate = ' ' LET l_bmoacti = ' '
    END IF
    DISPLAY l_bmouser TO bmouser
    DISPLAY l_bmogrup TO bmogrup
    DISPLAY l_bmomodu TO bmomodu
    DISPLAY l_bmoacti TO bmoacti
    DISPLAY l_bmoorig TO bmoorig  #TQC-AB0057
    DISPLAY l_bmooriu TO bmooriu  #TQC-AB0057
    DISPLAY l_bmodate TO bmodate  #TQC-AB0057
    CALL cl_set_field_pic("","","","","",g_bmo.bmoacti)
  
    IF cl_null(g_bmp.bmp27) THEN LET g_bmp.bmp27 = 'N' END IF
    IF cl_null(g_bmp.bmp15) THEN LET g_bmp.bmp15 = 'N' END IF
 
    DISPLAY BY NAME
      g_bmp.bmp01,g_bmp.bmp28,g_bmp.bmp02,g_bmp.bmp011,g_bmp.bmp03, #FUN-560027 add bmp28
      g_bmp.bmp10,g_bmp.bmp10_fac,g_bmp.bmp10_fac2,
      g_bmp.bmp06,g_bmp.bmp07,g_bmp.bmp08,g_bmp.bmp23,
      g_bmp.bmp11,g_bmp.bmp13,g_bmp.bmp16,g_bmp.bmp27,
      g_bmp.bmp15,g_bmp.bmp09,g_bmp.bmp18,
      g_bmp.bmp14,g_bmp.bmp19,g_bmp.bmp25,g_bmp.bmp26
 
    CALL i102_bmp01('d')
    CALL i102_bmp03('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i102_u()
    SELECT * INTO g_bmo.* FROM bmo_file WHERE bmo01 =g_bmp.bmp01
                                          AND bmo011=g_bmp.bmp011 #No:9430
    DISPLAY g_bmo.bmo05,g_bmp.bmp011
    IF g_bmp.bmp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #-->已轉成正式BOM 無法修改
    IF NOT cl_null(g_bmo.bmo05)
    THEN CALL cl_err(g_bmo.bmo01,'mfg2761',0)
         RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmp01_t = g_bmp.bmp01
    LET g_bmp011_t = g_bmp.bmp011
    LET g_bmp02_t = g_bmp.bmp02
    LET g_bmp03_t = g_bmp.bmp03
    LET g_bmp_o.* = g_bmp.*
	BEGIN WORK
 
    OPEN i102_curl USING g_bmp.bmp01,g_bmp.bmp28,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03
 
    IF STATUS THEN
       CALL cl_err("OPEN i102_curl:", STATUS, 1)
       CLOSE i102_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_curl INTO g_bmp.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
                  CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i102_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i102_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmp.*=g_bmp_t.*
            CALL i102_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
  UPDATE bmp_file SET bmp_file.* = g_bmp.*    # 更新DB 
   where bmp01=g_bmp_o.bmp01 AND bmp28 =g_bmp_o.bmp28 AND bmp011 = g_bmp_o.bmp011 
         AND bmp02=g_bmp_o.bmp02 AND bmp03=g_bmp_o.bmp03     # COLAUTH?
        IF SQLCA.SQLERRD[3] = 0 THEN
            LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
                  CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
            CALL cl_err3("upd","bmp_file",g_msg,"",SQLCA.sqlcode,"","",1) # NO.TQC-660046
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i102_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i102_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    IF g_bmp.bmp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i102_curl USING g_bmp.bmp01,g_bmp.bmp28,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03
 
    IF STATUS THEN
       CALL cl_err("OPEN i102_curl:", STATUS, 1)
       CLOSE i102_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_curl INTO g_bmp.*
    IF SQLCA.sqlcode THEN
       LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp01
                 CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i102_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmp01"               #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bmp.bmp01           #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bmp011"              #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_bmp.bmp011          #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bmp02"               #No.FUN-9B0098 10/02/24
        LET g_doc.value3  = g_bmp.bmp02           #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bmp03"               #No.FUN-9B0098 10/02/24
        LET g_doc.value4  = g_bmp.bmp03           #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "bmp28"               #No.FUN-9B0098 10/02/24
        LET g_doc.value5  = g_bmp.bmp28           #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                               #No.FUN-9B0098 10/02/24
       DELETE FROM bmp_file WHERE bmp01=g_bmp.bmp01 AND bmp011=g_bmp.bmp011
                              AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03
       DELETE FROM bec_file WHERE bec01=g_bmp.bmp01 AND bec011=g_bmp.bmp011
                              AND bec02=g_bmp.bmp02 AND bec021=g_bmp.bmp03
       DELETE FROM bel_file WHERE bel01=g_bmp.bmp01 AND bel011=g_bmp.bmp011
                              AND bel02=g_bmp.bmp02 AND bel03 =g_bmp.bmp03
       DELETE FROM bmu_file WHERE bmu01=g_bmp.bmp01 AND bmu011=g_bmp.bmp011
                              AND bmu02=g_bmp.bmp02 AND bmu03 =g_bmp.bmp03
       LET g_bmp.bmp01 = NULL LET g_bmp.bmp011 = NULL
       LET g_bmp.bmp02 = NULL LET g_bmp.bmp03 = NULL
       CLEAR FORM
       INITIALIZE g_bmp.* TO NULL
       OPEN i102_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i102_curs
          CLOSE i102_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i102_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i102_curs
          CLOSE i102_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i102_curs   #No.TQC-6C0054
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i102_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i102_fetch('/')
       END IF
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)              #FUN-980001 add plant & legal 
                    VALUES ('abmi102',g_user,g_today,g_msg,g_bmp.bmp01,'delete',g_plant,g_legal) #FUN-980001 add g_plant & g_legal
    END IF
    CLOSE i102_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_copy()
    DEFINE
        l_n                 LIKE type_file.num5,       #No.FUN-680096 SMALLINT
        l_newno1,l_oldno1   LIKE bmp_file.bmp01,
        l_newno11,l_oldno11 LIKE bmp_file.bmp011,
        l_newno2,l_oldno2   LIKE bmp_file.bmp02,
        l_newno3,l_oldno3   LIKE bmp_file.bmp03,
        l_newno4,l_oldno4   LIKE bmp_file.bmp04,
        l_ima02_h1,l_ima02_h2   LIKE ima_file.ima02,
        l_ima021_h1,l_ima021_h2 LIKE ima_file.ima021,
        l_ima08_1,l_ima08_2     LIKE ima_file.ima08
 
    IF g_bmp.bmp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_newno1  = NULL  LET l_newno11 = NULL
    LET l_newno2  = NULL  LET l_newno3 = NULL
 
    LET g_before_input_done = FALSE
    CALL i102_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno11,l_newno2,l_newno3 WITHOUT DEFAULTS
       FROM bmp01,bmp011,bmp02,bmp03
 
        BEFORE FIELD bmp01
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(7,15,l_newno1) RETURNING l_newno1
	            DISPLAY l_newno1 TO bmp01
	    END IF
 
        AFTER FIELD bmp01
            IF NOT cl_null(l_newno1) THEN
#FUN-AB0025 ----------------mark start---------------
#               #FUN-AA0059 -----------------------------add start----------------------------
#               IF NOT s_chk_item_no(l_newno1,'') THEN
#                  CALL cl_err('',g_errno,1)
#                  NEXT FIELD bmp01
#               END IF 
#               #FUN-AA0059 ----------------------------add end-------------------------  
#FUN-AB0025 --------------mark end-----------------
                #-->check 是否存在E-BOM的單頭檔中
                SELECT count(*) INTO g_cnt FROM bmo_file
                    WHERE bmo01 = l_newno1
                 IF g_cnt = 0 THEN
                    CALL cl_err(g_bmp.bmp01,'mfg2771',0)
                    NEXT FIELD bmp01
                 END IF
                SELECT ima02,ima021,ima08
                   INTO l_ima02_h1,l_ima021_h1,l_ima08_1
                   FROM ima_file
                   WHERE ima01 = l_newno1 AND imaacti = 'Y'
                 IF SQLCA.sqlcode THEN
                    SELECT  bmq02,bmq021,bmq08,bmqacti
                     INTO l_ima02_h1,l_ima021_h1,l_ima08_1
                     FROM bmq_file
                    WHERE bmq01 = l_newno1 AND bmqacti = 'Y'
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("sel","bmq_file",l_newno1,"","mfg2717","","",1)  #No.TQC-660046
                        NEXT FIELD bmp01
                    END IF
                    DISPLAY l_ima02_h1  TO FORMONLY.ima02_h1
                    DISPLAY l_ima021_h1 TO FORMONLY.ima021_h1
                    DISPLAY l_ima08_1   TO FORMONLY.ima08_1
                 END IF
            END IF
 
        AFTER FIELD bmp011
            IF NOT cl_null(l_newno11) THEN
                #-->check 是否存在E-BOM的單頭檔中
                SELECT count(*) INTO g_cnt FROM bmo_file
                    WHERE bmo01 = l_newno1 AND bmo011 = l_newno11
                 IF g_cnt = 0 THEN
                    CALL cl_err(g_bmp.bmp011,'mfg2771',0)
                    NEXT FIELD bmp01
                 END IF
            END IF
 
        BEFORE FIELD bmp03
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(10,15,l_newno3) RETURNING l_newno3
	                DISPLAY l_newno3 TO bmp03
	        END IF
 
        AFTER FIELD bmp03
            IF NOT cl_null(l_newno3) THEN
#FUN-AB0025 ------------mark start-------------------
#               #FUN-AA0059 --------------------------add start-----------------
#               IF NOT s_chk_item_no(l_newno3,'') THEN
#                  CALL cl_err('',g_errno,1) 
#                  NEXT FIELD bmp03
#               END IF 
#               #FUN-AA0059 ---------------------------add end------------------- 
#FUN-AB0025 -----------mark end----------------------
                SELECT ima02,ima021,ima08
                   INTO l_ima02_h2,l_ima021_h2,l_ima08_2
                   FROM ima_file
                   WHERE ima01 = l_newno3 AND imaacti = 'Y'
                 IF SQLCA.sqlcode THEN
                    SELECT  bmq02,bmq021,bmq08,bmqacti
                     INTO l_ima02_h2,l_ima021_h2,l_ima08_2
                     FROM bmq_file
                    WHERE bmq01 = l_newno3 AND bmqacti = 'Y'
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("sel","bmq_file",l_newno3,"","mfg2717","","",1)   #No.TQC-660046
                        NEXT FIELD bmp03
                    END IF
                    DISPLAY l_ima02_h2  TO FORMONLY.ima02_h2
                    DISPLAY l_ima021_h2 TO FORMONLY.ima021_h2
                    DISPLAY l_ima08_2   TO FORMONLY.ima08_2
                 END IF
            END IF
            SELECT count(*) INTO g_cnt FROM bmp_file
                WHERE bmp01 = l_newno1 AND bmp011 = l_newno11
                  AND bmp02 = l_newno2 AND bmp03 = l_newno3
            IF g_cnt > 0 THEN
                LET g_msg=l_newno1 CLIPPED,'+',l_newno11 CLIPPED,'+',
                          l_newno2 CLIPPED,'+',l_newno3
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD bmp01
            END IF
 
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_bmp.bmp01
        DISPLAY BY NAME g_bmp.bmp011
        DISPLAY BY NAME g_bmp.bmp02
        DISPLAY BY NAME g_bmp.bmp03
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM bmp_file
        WHERE bmp01=g_bmp.bmp01 AND bmp28 =g_bmp.bmp28 AND bmp011 = g_bmp.bmp011 AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03
        INTO TEMP x
    UPDATE x
        SET bmp01=l_newno1,   #資料鍵值-1
            bmp011=l_newno11, #資料鍵值-11
            bmp02=l_newno2,   #資料鍵值-2
            bmp03=l_newno3    #資料鍵值-3
    INSERT INTO bmp_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
              CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
         CALL cl_err3("ins","bmp_file",g_msg,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
    ELSE
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp011
              CLIPPED,'+',g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno1  = g_bmp.bmp01
        LET l_oldno11 = g_bmp.bmp011
        LET l_oldno2  = g_bmp.bmp02
        LET l_oldno3  = g_bmp.bmp03
        SELECT bmp_file.* INTO g_bmp.* FROM bmp_file
         WHERE bmp01 = l_newno1 AND bmp011=l_newno11
           AND bmp02=l_newno2  AND bmp03=l_newno3
        CALL i102_u()
        #FUN-C30027---begin
        #SELECT bmp_file.* INTO g_bmp.* FROM bmp_file
        # WHERE bmp01=l_oldno1 AND bmp011 = l_oldno11
        #   AND bmp02=l_oldno2 AND bmp03  = l_oldno3
        #CALL i102_show()
        #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_bmp.bmp01
    DISPLAY BY NAME g_bmp.bmp011
    DISPLAY BY NAME g_bmp.bmp02
    DISPLAY BY NAME g_bmp.bmp03
END FUNCTION
 
FUNCTION i102_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmp01,bmp02,bmp011,bmp03",TRUE)
   END IF
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmp01,bmp02,bmp011,bmp03",FALSE)
   END IF
   IF NOT cl_null(g_argv1) AND (NOT g_before_input_done)THEN
      CALL cl_set_comp_entry("bmp01",FALSE)
   END IF
   IF g_sma.sma12 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmp26",FALSE)
   END IF
END FUNCTION
 
FUNCTION i102_up_bmp13()
 DEFINE l_bmu06   LIKE bmu_file.bmu06,
        l_bmu05   LIKE bmu_file.bmu05, #FUN-560027 add
        l_bmp13   LIKE bmp_file.bmp13,
        l_i       LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    LET l_bmp13=' '
    DECLARE up_bmp13_cs CURSOR FOR
     SELECT bmu06,bmu05 FROM bmu_file
      WHERE bmu01 =g_bmp.bmp01
        AND bmu011=g_bmp.bmp011
        AND bmu02 =g_bmp.bmp02
        AND bmu03 =g_bmp.bmp03
        AND bmu08 =g_bmp.bmp28
       ORDER BY bmu05
    LET l_bmp13=' '
    LET l_i = 1
    FOREACH up_bmp13_cs INTO l_bmu06,l_bmu05 #FUN-560027 add bmu05
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_i = 1 THEN
            LET l_bmp13=l_bmu06
        ELSE
            LET l_bmp13= l_bmp13 CLIPPED , ',', l_bmu06
        END IF
        LET l_i = l_i + 1
    END FOREACH
    RETURN l_bmp13
END FUNCTION
#No:FUN-9C0077
