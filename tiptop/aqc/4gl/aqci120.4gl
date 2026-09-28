# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqci120.4gl
# Descriptions...: 料件檢驗項目AQL設定作業
# Date & Author..: 00/02/22 By Melody
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-5A0324 05/10/21 By Sarah 複製時,輸入不存在的料號,只會show錯誤訊息,不會next field料號
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-740144 07/04/24 By hongmei 控管上線值要大于下線值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.TQC-950129 09/06/05 By chenmoyan 單頭新增料號開窗未給default1值
# Modify.........: No.MOD-980187 09/08/21 By Smapmin 修改變數定義型態
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A50118 10/05/31 By liuxqa insert sql 语法错误。
# Modify.........: No.TQC-A60132 10/07/19 By chenmoyan 鎖表語句不標準
# Modify.........: No.FUN-A80063 10/08/13 By wujie     qcd04和qcd05位置互换
#                                                      qcd05增加item选项及控管
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_qcd01         LIKE qcd_file.qcd01,   #類別代號 (假單頭)
    g_qcdacti       LIKE qcd_file.qcdacti, #    96-06-18
    g_qcduser       LIKE qcd_file.qcduser, #
    g_qcdgrup       LIKE qcd_file.qcdgrup, #
    g_qcdmodu       LIKE qcd_file.qcdmodu, #
    g_qcddate       LIKE qcd_file.qcddate, #
    g_qcd01_t       LIKE qcd_file.qcd01,   #類別代號 (舊值)
    g_qcd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                qcd02       LIKE qcd_file.qcd02,
		azf03       LIKE azf_file.azf03,
		qcd08       LIKE qcd_file.qcd08,       #No.FUN-910079
		qcd03       LIKE qcd_file.qcd03,
#No.FUN-A80063 --begin
		qcd05       LIKE qcd_file.qcd05,
		qcd04       LIKE qcd_file.qcd04,
#No.FUN-A80063 --end
		qcd061      LIKE qcd_file.qcd061,
		qcd062      LIKE qcd_file.qcd062,
		qcd07       LIKE qcd_file.qcd07,
		qcdud01     like qcd_file.qcdud01

                    END RECORD,
    g_qcd_t         RECORD                 #程式變數 (舊值)
                qcd02       LIKE qcd_file.qcd02,
		azf03       LIKE azf_file.azf03,
		qcd08       LIKE qcd_file.qcd08,       #No.FUN-910079
		qcd03       LIKE qcd_file.qcd03,
#No.FUN-A80063 --begin
		qcd05       LIKE qcd_file.qcd05,
		qcd04       LIKE qcd_file.qcd04,
#No.FUN-A80063 --end
		qcd061      LIKE qcd_file.qcd061,
		qcd062      LIKE qcd_file.qcd062,
		qcd07       LIKE qcd_file.qcd07,
		qcdud01     like qcd_file.qcdud01
                    END RECORD,
    g_argv1         LIKE qcd_file.qcd01,
    g_wc,g_sql      STRING,        #No.FUN-580092 HCN        #No.FUN-680104   #MOD-980187
    g_ss            LIKE type_file.chr1,           #No.FUN-680104 VARCHAR(01) #決定後續步驟
    g_rec_b         LIKE type_file.num5,           #單身筆數 #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5            #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
DEFINE g_forupd_sql    STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680104 SMALLINT

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    LET g_argv1  = ARG_VAL(1)              #料件編號

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0085

    LET g_qcd01 = NULL                     #清除鍵值
    LET g_qcd01_t = NULL
    LET g_qcd01 = g_argv1

    OPEN WINDOW i120_w WITH FORM "aqc/42f/aqci120"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    call aqci120_act_name() #darcy:2025/01/13 add
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL  i120_q()
    END IF
    CALL i120_menu()

    CLOSE WINDOW i120_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN



FUNCTION i120_curs()
    CLEAR FORM                             #清除畫面
    CALL g_qcd.clear()
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INITIALIZE g_qcd01 TO NULL                   #No.FUN-750051
    CONSTRUCT g_wc ON qcd01 FROM qcd01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcd01)
#                    CALL q_ima(0,0,'') RETURNING g_qcd01
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO qcd01
                     NEXT FIELD qcd01
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcduser', 'qcdgrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc = " qcd01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE qcd01 FROM qcd_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i120_prepare FROM g_sql      #預備一下
    DECLARE i120_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i120_prepare
    LET g_sql="SELECT COUNT(DISTINCT qcd01) FROM qcd_file WHERE ",g_wc CLIPPED
    PREPARE i120_precount FROM g_sql
    DECLARE i120_count CURSOR FOR i120_precount
END FUNCTION

FUNCTION i120_menu()

   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i120_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i120_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcd),'','')
            END IF
         #No.FUN-6A0160-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_qcd01 IS NOT NULL THEN
                 LET g_doc.column1 = "qcd01"
                 LET g_doc.value1 = g_qcd01
                 CALL cl_doc()
               END IF
         END IF
         #darcy:2025/01/13 add s---
         when "upd_aql"
            IF cl_chk_act_auth() THEN
               call aqci120_upd_aql()
            END IF
         #darcy:2025/01/13 add e---
         #No.FUN-6A0160-------add--------end----
      END CASE
   END WHILE
END FUNCTION


#Add  輸入
FUNCTION i120_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_qcd.clear()
    INITIALIZE g_qcd01 LIKE qcd_file.qcd01
    LET g_qcd01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i120_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_qcd.clear()
        ELSE
            CALL i120_b_fill('1=1')         #單身
        END IF
        LET g_rec_b = 0
        CALL i120_b()                      #輸入單身
        LET g_qcd01_t = g_qcd01            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION

#處理INPUT
FUNCTION i120_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1       #a:輸入 u:更改 #No.FUN-680104 VARCHAR(1)

     LET g_ss='Y'
     LET g_qcdacti = 'Y'             # 有效的資料 96-06-18
     LET g_qcduser = g_user          # 使用者
     LET g_qcdgrup = g_grup          # 使用者所屬群
     LET g_qcddate = g_today         # 更改日期

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_qcd01
        WITHOUT DEFAULTS
        FROM qcd01

        AFTER FIELD qcd01                  #類別代號
            IF NOT cl_null(g_qcd01) THEN
#FUN-AA0059 ---------------------start----------------------------
                IF NOT s_chk_item_no(g_qcd01,"") THEN
                   CALL cl_err('',g_errno,1)
                   LET g_qcd01= g_qcd01_t
                    NEXT FIELD qcd01
                END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF g_qcd01 != g_qcd01_t OR     #輸入後更改不同時值
                   g_qcd01_t IS NULL THEN
                    SELECT UNIQUE qcd01 INTO g_chr
                        FROM qcd_file
                        WHERE qcd01=g_qcd01
                    IF SQLCA.sqlcode THEN             #不存在, 新來的
                        IF p_cmd='a' THEN
                            LET g_ss='N'
                        END IF
                    ELSE
                        IF p_cmd='u' THEN
                            CALL cl_err(g_qcd01,-239,0)
                            LET g_qcd01=g_qcd01_t
                            NEXT FIELD qcd01
                        END IF
                    END IF
                END IF
                CALL i120_qcd01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_qcd01,g_errno,0)
                   NEXT FIELD qcd01
                END IF
            END IF

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcd01)
#                    CALL q_ima(0,0,'') RETURNING g_qcd01
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = ''        #No.TQC-950129
#                    LET g_qryparam.default1 = g_qcd01   #No.TQC-950129
#                    CALL cl_create_qry() RETURNING g_qcd01
                     CALL q_sel_ima(FALSE, "q_ima","",g_qcd01,"","","","","",'' )
                         RETURNING   g_qcd01
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY BY NAME g_qcd01
                     NEXT FIELD qcd01
                OTHERWISE EXIT CASE
            END CASE
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #MOD-860081------add-----end---
    END INPUT
END FUNCTION

FUNCTION  i120_qcd01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima103        LIKE ima_file.ima103,
    l_imaacti       LIKE ima_file.imaacti          #資料有效碼

    LET g_errno = ' '
    SELECT ima02, ima021, ima103, imaacti
        INTO l_ima02, l_ima021, l_ima103, l_imaacti
        FROM ima_file
        WHERE ima01 = g_qcd01
    CASE WHEN STATUS=100          LET g_errno = 'mfg0002' #No.7926
              LET l_ima02 = NULL LET l_ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION

#Query 查詢
FUNCTION i120_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qcd01 TO NULL             #No.FUN-6A016             #No.FUN-6A01600
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i120_curs()                       #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_qcd01 TO NULL
        RETURN
    END IF
    OPEN i120_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_qcd01 TO NULL
    ELSE
        CALL i120_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i120_count
        FETCH i120_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i120_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式   #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10      #絕對的筆數 #No.FUN-680104 INTEGER

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i120_b_curs INTO g_qcd01
        WHEN 'P' FETCH PREVIOUS i120_b_curs INTO g_qcd01
        WHEN 'F' FETCH FIRST    i120_b_curs INTO g_qcd01
        WHEN 'L' FETCH LAST     i120_b_curs INTO g_qcd01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i120_b_curs INTO g_qcd01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_qcd01,SQLCA.sqlcode,0)
        INITIALIZE g_qcd01 TO NULL
    ELSE
        CALL i120_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i120_show()
    DISPLAY g_qcd01 TO qcd01               #單頭
    CALL i120_qcd01('d')                   #單身
    CALL i120_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i120_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_qcd01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0160
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qcd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qcd01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM qcd_file WHERE qcd01 = g_qcd01
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("del","qcd_file",g_qcd01,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660115
        ELSE
            CLEAR FORM
            CALL g_qcd.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i120_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i120_b_curs
               CLOSE i120_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            FETCH i120_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i120_b_curs
               CLOSE i120_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i120_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i120_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL i120_fetch('/')
            END IF

        END IF
        LET g_msg=TIME
    END IF
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000, #可新增否    #No.FUN-680104 VARCHAR(80)
    l_allow_insert  LIKE type_file.num5,    #可新增否    #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否    #No.FUN-680104 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qcd01 IS NULL THEN
        RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_qcdmodu=g_user          #修改者96-06-18
    LET g_qcddate=g_today         #修改日期

    LET g_forupd_sql = " SELECT qcd02,'',qcd08,qcd03,qcd05,qcd04,qcd061,qcd062,qcd07,qcdud01 FROM qcd_file ",    #No.FUN-A80063
                       "  WHERE qcd01= ? AND qcd02= ? ", #TQC-A60132
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0

        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_qcd
              WITHOUT DEFAULTS
              FROM s_qcd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_qcd_t.qcd02 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_qcd_t.* = g_qcd[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i120_bcl USING g_qcd01,g_qcd_t.qcd02
                IF STATUS THEN
                    CALL cl_err("OPEN i120_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i120_bcl INTO g_qcd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_qcd_t.qcd02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        LET g_qcd_t.*=g_qcd[l_ac].*
                    END IF
                END IF
                CALL i120_qcd02('d')
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_qcd.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            INSERT INTO qcd_file(qcd01,qcd02,qcd03,qcd04,qcd05,qcd061,qcd062,
#                   qcd07,qcdacti,qcduser,qcdgrup,qcdmodu,qcddate,qcdoriu,qcdorig)
                    qcd07,qcd08,qcdacti,qcduser,qcdgrup,qcdmodu,qcddate,qcdoriu,qcdorig,qcdud01)  #MOD-A50118 add 2      #No.FUN-910079
            VALUES(g_qcd01,g_qcd[l_ac].qcd02,g_qcd[l_ac].qcd03,
                           g_qcd[l_ac].qcd04,g_qcd[l_ac].qcd05,
                           g_qcd[l_ac].qcd061,g_qcd[l_ac].qcd062,
#                           g_qcd[l_ac].qcd07,g_qcdacti,g_qcduser,
                            g_qcd[l_ac].qcd07,g_qcd[l_ac].qcd08,g_qcdacti,g_qcduser,   #No.FUN-910079
                           g_qcdgrup,g_qcdmodu,g_qcddate, g_user, g_grup,g_qcd[l_ac].qcdud01)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_qcd[l_ac].qcd02,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("ins","qcd_file",g_qcd01,g_qcd[l_ac].qcd02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1
                COMMIT WORK
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcd[l_ac].* TO NULL      #900423
            LET g_qcd[l_ac].qcd08 = '9'             #No.FUN-910079
            LET g_qcd[l_ac].qcd07 = 'N'
            LET g_qcd_t.* = g_qcd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qcd02

        AFTER FIELD qcd02                        #check 序號是否重複
            IF NOT cl_null(g_qcd[l_ac].qcd02) THEN
                IF (g_qcd[l_ac].qcd02 != g_qcd_t.qcd02 OR
                    g_qcd_t.qcd02 IS NULL) THEN

                    SELECT count(*)
                        INTO l_n
                        FROM qcd_file
                        WHERE qcd01 = g_qcd01 AND
                              qcd02 = g_qcd[l_ac].qcd02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_qcd[l_ac].qcd02 = g_qcd_t.qcd02
                        NEXT FIELD qcd02
                    ELSE
                        CALL i120_qcd02('a')
                        IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_qcd[l_ac].qcd02,g_errno,0)
                            #no.5185......................................
                            LET g_qcd[l_ac].qcd02 = g_qcd_t.qcd02
                            #bug end......................................
                            NEXT FIELD qcd02
                        END IF
                    END IF
                END IF
            END IF

	AFTER FIELD qcd03
	    IF NOT cl_null(g_qcd[l_ac].qcd03) THEN
               IF g_qcd[l_ac].qcd03 NOT MATCHES'[123]' THEN
                   NEXT FIELD qcd03
               END IF
	    END IF

#No.FUN-A80063 --begin
  BEFORE FIELD qcd05
      CALL cl_set_comp_entry('qcd04,qcd07',TRUE)
#No.FUN-A80063 --end
	AFTER FIELD qcd05
	    IF NOT cl_null(g_qcd[l_ac].qcd05) THEN
	        IF g_qcd[l_ac].qcd05 NOT MATCHES "[1234]" THEN   #No.FUN-A80063
                   NEXT FIELD qcd05
	        END IF
	    END IF
#No.FUN-A80063 --begin
      IF g_qcd[l_ac].qcd05 <> g_qcd_t.qcd05 OR g_qcd_t.qcd05 IS NULL THEN
         IF g_qcd[l_ac].qcd05 MATCHES '[34]' THEN
            LET g_qcd[l_ac].qcd04 =NULL
            CALL cl_set_comp_entry('qcd04',FALSE)
         END IF
         IF g_qcd[l_ac].qcd05 ='4' THEN
            LET g_qcd[l_ac].qcd07 ='Y'
            CALL cl_set_comp_entry('qcd07',FALSE)
         END IF
      END IF
      LET g_qcd_t.qcd05 = g_qcd[l_ac].qcd05
#No.FUN-A80063 --end


        AFTER FIELD qcd07
	    IF g_qcd[l_ac].qcd07 NOT MATCHES "[YN]" THEN
               NEXT FIELD qcd07
	    END IF

#No.TQC-740144 ---Begin
        AFTER FIELD qcd062
            IF g_qcd[l_ac].qcd062<g_qcd[l_ac].qcd061 THEN
               CALL cl_err('','aqc1000',0)
               NEXT FIELD qcd062
            END IF
#No.TQC-740144 ---End
#No.FUN-A80063 --begin
            IF g_qcd[l_ac].qcd05 ='4' AND cl_null(g_qcd[l_ac].qcd061) AND cl_null(g_qcd[l_ac].qcd062) THEN
               NEXT FIELD qcd062
            END IF
#No.FUN-A80063 --end

        BEFORE DELETE                            #是否取消單身
            IF g_qcd_t.qcd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qcd_file
                    WHERE qcd01 = g_qcd01 AND
                          qcd02 = g_qcd_t.qcd02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_qcd_t.qcd02,SQLCA.sqlcode,0)   #No.FUN-660115
                    CALL cl_err3("del","qcd_file",g_qcd01,g_qcd_t.qcd02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b - 1
            END IF
            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcd[l_ac].* = g_qcd_t.*
               CLOSE i120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_qcd[l_ac].qcd02,-263,1)
                LET g_qcd[l_ac].* = g_qcd_t.*
            ELSE
                UPDATE qcd_file SET
                       qcd02=g_qcd[l_ac].qcd02,
                       qcd03=g_qcd[l_ac].qcd03,
                       qcd04=g_qcd[l_ac].qcd04,
                       qcd05=g_qcd[l_ac].qcd05,
                       qcd061=g_qcd[l_ac].qcd061,
                       qcd062=g_qcd[l_ac].qcd062,
                       qcd07=g_qcd[l_ac].qcd07,
                       qcd08=g_qcd[l_ac].qcd08,              #No.FUN-910079
                       qcdmodu=g_qcdmodu,
                       qcddate=g_qcddate,
                       qcdud01=g_qcd[l_ac].qcdud01
                 WHERE qcd01=g_qcd01
                   AND qcd02=g_qcd_t.qcd02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","qcd_file",g_qcd01,g_qcd_t.qcd02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    LET g_qcd[l_ac].* = g_qcd_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcd[l_ac].* = g_qcd_t.*
               END IF
               CLOSE i120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i120_bcl
            COMMIT WORK


        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcd02)     #廠商編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf"
                     LET g_qryparam.default1 = g_qcd[l_ac].qcd02
                     LET g_qryparam.arg1     = '6'
                     CALL cl_create_qry() RETURNING g_qcd[l_ac].qcd02
                     DISPLAY g_qcd[l_ac].qcd02 TO qcd02
                     NEXT FIELD qcd02
                OTHERWISE EXIT CASE
            END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qcd02) AND l_ac > 1 THEN
                LET g_qcd[l_ac].* = g_qcd[l_ac-1].*
                DISPLAY g_qcd[l_ac].* TO s_qcd[l_ac].*
                NEXT FIELD qcd02
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

      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

        END INPUT

    CLOSE i120_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i120_qcd02(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
           l_azf03 LIKE azf_file.azf03

    LET g_errno = ' '
    SELECT azf03
        INTO g_qcd[l_ac].azf03
        FROM azf_file
        WHERE azf01 = g_qcd[l_ac].qcd02
          AND azf02='6'

    CASE WHEN STATUS=100          LET g_errno = 'aqc-041' #No.7926 #No.5185
                                  LET  g_qcd[l_ac].azf03 = NULL
         OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
END FUNCTION

FUNCTION i120_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)

    CONSTRUCT l_wc ON qcd02,qcd03,qcd05,qcd04,qcd061,qcd062,qcd07      #No.FUN-A80063
                 FROM s_qcd[1].qcd02,s_qcd[1].qcd03,s_qcd[1].qcd05,
                      s_qcd[1].qcd04,s_qcd[1].qcd061,s_qcd[1].qcd062,        #No.FUN-A80063
                      s_qcd[1].qcd07
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
    IF INT_FLAG THEN RETURN END IF
    CALL i120_b_fill(l_wc)
END FUNCTION

FUNCTION i120_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            STRING       #No.FUN-680104 VARCHAR(200)   #MOD-980187

    LET g_sql =
#       "SELECT qcd02,azf03,qcd03,qcd04,qcd05,qcd061,qcd062,qcd07 ",
        "SELECT qcd02,azf03,qcd08,qcd03,qcd05,qcd04,qcd061,qcd062,qcd07,qcdud01 ",   #NO.FUN-910079   #No.FUN-A80063
       " FROM qcd_file LEFT OUTER JOIN azf_file ON qcd_file.qcd02 = azf_file.azf01 AND azf_file.azf02='6' ",
       " WHERE qcd01 = '",g_qcd01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i120_prepare2 FROM g_sql      #預備一下
    DECLARE qcd_curs CURSOR FOR i120_prepare2
    CALL g_qcd.clear()
    LET g_cnt = 1
    FOREACH qcd_curs INTO g_qcd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_qcd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION


FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   call aqci120_act_name() #darcy:2025/01/13 add
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcd TO s_qcd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

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
      ON ACTION first
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL i120_fetch('L')
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

      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

      #darcy:2025/01/13 add s---
      on action upd_aql
         let g_action_choice = "upd_aql"
         exit display
      #darcy:2025/01/13 add e---

      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i120_copy()
DEFINE l_newno,l_oldno1  LIKE qcd_file.qcd01,
       l_n           LIKE type_file.num5,          #No.FUN-680104 SMALLINT
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021

    IF s_shut(0) THEN RETURN END IF
    IF g_qcd01 IS NULL
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
#bugno:5994 add....................................................
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       MESSAGE g_msg
    ELSE
       DISPLAY '' AT 1,1
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       DISPLAY g_msg AT 2,1
    END IF
#bugno:5994 end....................................................
    DISPLAY ' ' TO qcd01

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno FROM qcd01
        AFTER FIELD qcd01
            IF NOT cl_null(l_newno) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(l_newno,"") THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD qcd01
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                SELECT count(*)
                   INTO l_n
                   FROM qcd_file
                   WHERE qcd01 = l_newno
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD qcd01
	        END IF
                SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
                 WHERE ima01 = l_newno
                   AND imaacti = 'Y'
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('','mfg0002',0)   #No.FUN-660115
                   CALL cl_err3("sel","ima_file",l_newno,"","mfg0002","","",1)  #No.FUN-660115
                   NEXT FIELD qcd01   #MOD-5A0324
                ELSE
                   DISPLAY l_ima02 TO FORMONLY.ima02
                   DISPLAY l_ima021 TO FORMONLY.ima021
                END IF
            END IF

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcd01)
#                    CALL q_ima(0,0,'') RETURNING l_newno
#                    CALL FGL_DIALOG_SETBUFFER( l_newno )
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = ''        #No.TQC-950129
#                    LET g_qryparam.default1 = l_newno   #No.TQC-950129
#                    CALL cl_create_qry() RETURNING l_newno
                     CALL q_sel_ima(FALSE, "q_ima","",l_newno,"","","","","",'' )
                       RETURNING l_newno
#FUN-AA0059---------mod------------end-----------------
#                     CALL FGL_DIALOG_SETBUFFER( l_newno )
                     DISPLAY l_newno TO qcd01
                     NEXT FIELD qcd01
                OTHERWISE EXIT CASE
            END CASE

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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY  g_qcd01 TO qcd01
            RETURN
    END IF

    DROP TABLE x
    SELECT * FROM qcd_file         #單身複製
        WHERE qcd01 = g_qcd01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_qcd01,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","x",g_qcd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    UPDATE x
        SET qcd01 = l_newno
    INSERT INTO qcd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","qcd_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

     LET l_oldno1= g_qcd01
     LET g_qcd01=l_newno
     CALL i120_b()
     #LET g_qcd01=l_oldno1  #FUN-C80046
     #CALL i120_show()      #FUN-C80046
END FUNCTION

#Patch....NO.TQC-610036 <001> #

#darcy:2025/01/13 add s---
function aqci120_upd_aql()
   define l_qcd04 LIKe qcd_file.qcd04

   select qcd04 into l_qcd04 from qcd_file where qcd04  <> 0 and rownum = 1

   if l_qcd04 = 0.65 then
      let l_qcd04 = 0.4
   else
      let l_qcd04 = 0.65
   end if

   begin work
   update qcd_file set qcd04 = l_qcd04
    where qcd04  <> 0

   if sqlca.sqlcode then
      rollback work
      call cl_err("",sqlca.sqlcode,1)
      return
   end if

   if l_qcd04 == '0.4' then
      if not cl_confirm("cqc-009") then
         rollback work
         MESSAGE "取消更新"
         return
      end if
   else
      if not cl_confirm("cqc-008") then
         rollback work
         MESSAGE "取消更新"
         return
      end if
   end if

   commit work
   MESSAGE "更新成功"

   call aqci120_act_name()
end function

function aqci120_act_name()
   define l_qcd04 like qcd_file.qcd04
   select qcd04 into l_qcd04 from qcd_file where qcd04  <> 0 and rownum = 1
   if l_qcd04 = 0.65 then
      call cl_set_act_title("upd_aql","AQL变0.4")
   else
      call cl_set_act_title("upd_aql","AQL变0.65")
   end if
end function
#darcy:2025/01/13 add e---
