# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: axmt7101.4gl
# Descriptions...: 客訴原因
# Date & Author..: 92/12/05 By Mandy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-BA0010 12/10/19 By Nina  為結案後右邊ACTION不能再修改
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ohf           RECORD LIKE ohf_file.*,
    g_ohf_t         RECORD LIKE ohf_file.*,# (舊值)
    g_ohf01_t       LIKE ohf_file.ohf01,   #客訴單號
    g_ohf02_t       LIKE ohf_file.ohf02,   #類別
    g_ohe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ohe02       LIKE ohe_file.ohe02,   #項次
        ohe03       LIKE ohe_file.ohe03,   #客訴原因代碼
        ock02       LIKE ock_file.ock02
                    END RECORD,
    g_ohe_t         RECORD                 #程式變數 (舊值)
        ohe02       LIKE ohe_file.ohe02,   #項次
        ohe03       LIKE ohe_file.ohe03,   #客訴原因代碼
        ock02       LIKE ock_file.ock02
                    END RECORD,
    g_ohe_o         RECORD                 #程式變數 (舊值)
        ohe02       LIKE ohe_file.ohe02,   #項次
        ohe03       LIKE ohe_file.ohe03,   #客訴原因代碼
        ock02       LIKE ock_file.ock02
                    END RECORD,
    g_argv1         LIKE ohf_file.ohf01,   #客訴單號
    g_argv2         LIKE ohf_file.ohf02,   #類別
     g_wc,g_wc2,g_sql  string, #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql string  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_ohc03        LIKE ohc_file.ohc03          #CHI-BA0010 add
 
MAIN
# DEFINE      l_time    LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1 = ARG_VAL(1)               #
    LET g_argv2 = ARG_VAL(2)               #
 
    LET g_forupd_sql = "SELECT * FROM ohf_file WHERE ohf01 = ? AND ohf02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t7101_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 5 LET p_col = 17
 
    OPEN WINDOW t7101_w AT p_row,p_col              #顯示畫面
         WITH FORM "axm/42f/axmt7101"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       CALL t7101_q()
    END IF
 
    CALL t7101_menu()
 
    CLOSE WINDOW t7101_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION t7101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_ohe.clear()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    IF NOT cl_null(g_argv1) THEN
        LET g_wc = " ohf01 = '",g_argv1,"'"," AND ohf02 = '",g_argv2,"'"
        LET g_wc2 = ' 1=1'
    ELSE
   INITIALIZE g_ohf.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           ohf01,ohf02,ohf03,ohf04
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(ohf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ohf03
                   NEXT FIELD ohf03
              WHEN INFIELD(ohf04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ohf04
                   NEXT FIELD ohf04
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
 
        CONSTRUCT g_wc2 ON ohe02,ohe03                 #螢幕上取單身條件
             FROM s_ohe[1].ohe02,s_ohe[1].ohe03
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ohe03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ock"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ohe03
                   NEXT FIELD ohe03
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
        IF INT_FLAG THEN RETURN END IF
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT  ohf01,ohf02 FROM ohf_file ",
                    " WHERE ", g_wc CLIPPED,
                    "   AND ohf02 = '0' " , #客訴原因
                    " ORDER BY 1"
    ELSE					# 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE ohf_file. ohf01,ohf02 ",
                    "  FROM ohf_file, ohe_file ",
                    " WHERE ohf01 = ohe01",
                    "   AND ohf02 = '0' " , #客訴原因
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY 1,2"
    END IF
 
    PREPARE t7101_prepare FROM g_sql
    DECLARE t7101_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t7101_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT UNIQUE ohf01,ohf02 FROM ohf_file ",
                  " WHERE ", g_wc CLIPPED,
                  "   AND ohf02 = '0' " , #客訴原因
                  "  INTO TEMP x "
    ELSE
        LET g_sql="SELECT UNIQUE ohf01,ohf02 FROM ohf_file,ohe_file ",
                  " WHERE ohf01 = ohe01",
                  "   AND ohf02 = '0' " , #客訴原因
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  "  INTO TEMP x "
    END IF
 
    DROP TABLE x
    PREPARE t7101_precount_x FROM g_sql
    EXECUTE t7101_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t7101_precount FROM g_sql
    DECLARE t7101_count CURSOR FOR t7101_precount
 
END FUNCTION
 
FUNCTION t7101_menu()
 
   WHILE TRUE
      CALL t7101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t7101_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t7101_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t7101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ohe),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ohf.ohf01 IS NOT NULL THEN
                LET g_doc.column1 = "ohf01"
                LET g_doc.column2 = "ohf02"
                LET g_doc.value1 = g_ohf.ohf01
                LET g_doc.value2 = g_ohf.ohf02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0020-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t7101_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ohf.ohf01 IS NULL OR g_ohf.ohf02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ohf.* FROM ohf_file
     WHERE ohf01=g_ohf.ohf01
       AND ohf02=g_ohf.ohf02

    #CHI-BA0010 ----- start -----
    SELECT ohc03 INTO g_ohc03 FROM ohc_file WHERE ohc01 = g_ohf.ohf01
    IF g_ohc03 = 2 THEN
       CALL cl_err('','9004',0)
       RETURN
    END IF
    #CHI-BA0010 -----  end  -----

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ohf01_t = g_ohf.ohf01
    LET g_ohf02_t = g_ohf.ohf02
 
    BEGIN WORK
 
    OPEN t7101_cl USING g_ohf.ohf01,g_ohf.ohf02
    IF STATUS THEN
       CALL cl_err("OPEN t7101_cl:", STATUS, 1) 
       CLOSE t7101_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t7101_cl INTO g_ohf.*            # 鎖住將被更改或取消的資料
    DISPLAY "FETCH t7101_cl   ",SQLCA.sqlcode
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ohf.ohf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t7101_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t7101_show()
 
    WHILE TRUE
        LET g_ohf01_t = g_ohf.ohf01
        LET g_ohf02_t = g_ohf.ohf02
        CALL t7101_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ohf.*=g_ohf_t.*
            CALL t7101_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ohf_file SET ohf_file.* = g_ohf.*
            WHERE ohf01 = g_ohf01_t AND ohf02 = g_ohf02_t
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err(g_ohf.ohf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ohf_file",g_ohf.ohf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t7101_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION t7101_i(p_cmd)
DEFINE
    l_n		LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    DISPLAY BY NAME g_ohf.ohf03,g_ohf.ohf04
 
   INPUT BY NAME g_ohf.ohf03,g_ohf.ohf04
        WITHOUT DEFAULTS
 
 
        AFTER FIELD ohf04
            IF NOT cl_null(g_ohf.ohf04) THEN
                CALL t7101_ohf04('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohf.ohf04,g_errno,0)
                    NEXT FIELD ohf04
                END IF
            END IF
        AFTER FIELD ohf03
            IF NOT cl_null(g_ohf.ohf03) THEN
                CALL t7101_ohf03('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohf.ohf03,g_errno,0)
                    NEXT FIELD ohf03
                END IF
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ohf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_ohf.ohf03
                   CALL cl_create_qry() RETURNING g_ohf.ohf03
#                   CALL FGL_DIALOG_SETBUFFER( g_ohf.ohf03 )
                   DISPLAY BY NAME g_ohf.ohf03
                   NEXT FIELD ohf03
              WHEN INFIELD(ohf04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_ohf.ohf04
                   CALL cl_create_qry() RETURNING g_ohf.ohf04
#                   CALL FGL_DIALOG_SETBUFFER( g_ohf.ohf04 )
                   DISPLAY BY NAME g_ohf.ohf04
                   NEXT FIELD ohf04
              OTHERWISE EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t7101_ohe03(p_cmd)  #客訴原因代碼
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_ockacti LIKE ock_file.ockacti
 
    LET g_errno = " "
    SELECT ock02,ockacti
      INTO g_ohe[l_ac].ock02,l_ockacti
      FROM ock_file
     WHERE ock01 = g_ohe[l_ac].ohe03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_ockacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t7101_ohf03(p_cmd)  #主辦
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02_1 LIKE gen_file.gen02
 
    LET g_errno = " "
    SELECT gen02,genacti
      INTO l_gen02_1,l_genacti
      FROM gen_file
     WHERE gen01 = g_ohf.ohf03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gen02_1 TO FORMONLY.gen02_1
    END IF
END FUNCTION
 
FUNCTION t7101_ohf04(p_cmd)  #審核
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02_2 LIKE gen_file.gen02
 
    LET g_errno = " "
    SELECT gen02,genacti
      INTO l_gen02_2,l_genacti
      FROM gen_file
     WHERE gen01 = g_ohf.ohf04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gen02_2 TO FORMONLY.gen02_2
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t7101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ohf.* TO NULL               #No.FUN-6A0020
    MESSAGE ""
    CALL cl_opmsg('q')
 
    CLEAR FORM
    CALL g_ohe.clear()
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t7101_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ohf.* TO NULL
        RETURN
    END IF
 
    OPEN t7101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ohf.* TO NULL
    ELSE
       OPEN t7101_count
       FETCH t7101_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t7101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t7101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t7101_cs INTO g_ohf.ohf01,g_ohf.ohf02
        WHEN 'P' FETCH PREVIOUS t7101_cs INTO g_ohf.ohf01,g_ohf.ohf02
        WHEN 'F' FETCH FIRST    t7101_cs INTO g_ohf.ohf01,g_ohf.ohf02
        WHEN 'L' FETCH LAST     t7101_cs INTO g_ohf.ohf01,g_ohf.ohf02
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t7101_cs INTO g_ohf.ohf01,g_ohf.ohf02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohf.ohf01,SQLCA.sqlcode,0)
        INITIALIZE g_ohf.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ohf.* FROM ohf_file WHERE ohf01 = g_ohf.ohf01 AND ohf02 = g_ohf.ohf02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ohf.ohf01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","ohf_file",g_ohf.ohf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_ohf.* TO NULL
        RETURN
    END IF
 
 
    CALL t7101_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t7101_show()
DEFINE l_ohf02_t LIKE type_file.chr20       # No.FUN-680137 VARCHAR(20)
    LET g_ohf_t.* = g_ohf.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_ohf.ohf01,g_ohf.ohf02, g_ohf.ohf03,g_ohf.ohf04
 
    CALL t7101_ohf03('d')
    CALL t7101_ohf04('d')
 
    CALL t7101_b_fill(g_wc2)               #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
#單身
FUNCTION t7101_b()
DEFINE
    l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n              LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_cnt            LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ohf.ohf01 IS NULL OR g_ohf.ohf02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ohf.* FROM ohf_file
     WHERE ohf01=g_ohf.ohf01
       AND ohf02=g_ohf.ohf02
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ohe02,ohe03,'' FROM ohe_file ",
                       " WHERE ohe01= ? AND ohe02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t7101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ohe WITHOUT DEFAULTS FROM s_ohe.*
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
 
            OPEN t7101_cl USING g_ohf.ohf01,g_ohf.ohf02
            IF STATUS THEN
               CALL cl_err("OPEN t7101_cl:", STATUS, 1)
               CLOSE t7101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t7101_cl INTO g_ohf.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_ohf.ohf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE t7101_cl
                ROLLBACK WORK
                RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ohe_t.* = g_ohe[l_ac].*  #BACKUP
 
                OPEN t7101_bcl USING g_ohf.ohf01, g_ohe_t.ohe02
                IF STATUS THEN
                   CALL cl_err("OPEN t7101_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t7101_bcl INTO g_ohe[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ohe_t.ohe02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT ock02 INTO g_ohe[l_ac].ock02
                        FROM ock_file
                       WHERE ock01 = g_ohe[l_ac].ohe03
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ohe[l_ac].* TO NULL      #900423
            LET g_ohe_t.* = g_ohe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ohe02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO ohe_file(ohe01,ohe02,ohe03)
                          VALUES(g_ohf.ohf01,g_ohe[l_ac].ohe02,g_ohe[l_ac].ohe03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ohe[l_ac].ohe02,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","ohe_file",g_ohf.ohf01,g_ohe[l_ac].ohe02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1
                COMMIT WORK
            END IF
 
        BEFORE FIELD ohe02                        #default 序號
            IF g_ohe[l_ac].ohe02 IS NULL OR
               g_ohe[l_ac].ohe02 = 0 THEN
                SELECT max(ohe02)+1 INTO g_ohe[l_ac].ohe02 FROM ohe_file
                 WHERE ohe01 = g_ohf.ohf01
                IF g_ohe[l_ac].ohe02 IS NULL THEN
                   LET g_ohe[l_ac].ohe02 = 1
                END IF
            END IF
 
        AFTER FIELD ohe02                        #check 序號是否重複
            IF NOT g_ohe[l_ac].ohe02 THEN
               IF g_ohe[l_ac].ohe02 != g_ohe_t.ohe02 OR
                  g_ohe_t.ohe02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM ohe_file
                    WHERE ohe01 = g_ohf.ohf01
                      AND ohe02 = g_ohe[l_ac].ohe02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_ohe[l_ac].ohe02 = g_ohe_t.ohe02
                      NEXT FIELD ohe02
                   END IF
               END IF
            END IF
 
        AFTER FIELD ohe03
            IF NOT cl_null(g_ohe[l_ac].ohe03) THEN
               CALL t7101_ohe03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ohe[l_ac].ohe03,g_errno,0)
                  NEXT FIELD ohe03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ohe_t.ohe02 > 0 AND
               g_ohe_t.ohe02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM ohe_file
                WHERE ohe01 = g_ohf.ohf01
                  AND ohe02 = g_ohe_t.ohe02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ohe_t.ohe02,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("del","ohe_file",g_ohe_t.ohe02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
               LET g_ohe[l_ac].* = g_ohe_t.*
               CLOSE t7101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ohe[l_ac].ohe02,-263,1)
               LET g_ohe[l_ac].* = g_ohe_t.*
            ELSE
               UPDATE ohe_file SET ohe02=g_ohe[l_ac].ohe02,
                                   ohe03=g_ohe[l_ac].ohe03
                WHERE ohe01=g_ohf.ohf01
                  AND ohe02=g_ohe_t.ohe02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err(g_ohe[l_ac].ohe03,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","ohe_file",g_ohf.ohf01,g_ohe_t.ohe02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_ohe[l_ac].* = g_ohe_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ohe[l_ac].* = g_ohe_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_ohe.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t7101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
            CLOSE t7101_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #    CALL t7101_b_askkey()
      #    EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ohe02) AND l_ac > 1 THEN
              LET g_ohe[l_ac].* = g_ohe[l_ac-1].*
              NEXT FIELD ohe02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ohe03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ock"
                   LET g_qryparam.default1 = g_ohe[l_ac].ohe03
                   CALL cl_create_qry() RETURNING g_ohe[l_ac].ohe03
#                   CALL FGL_DIALOG_SETBUFFER( g_ohe[l_ac].ohe03 )
                    DISPLAY BY NAME g_ohe[l_ac].ohe03      #No.MOD-490371
                   NEXT FIELD ohe03
              OTHERWISE
                   EXIT CASE
           END CASE
 
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
 
 
    END INPUT
 
    CLOSE t7101_bcl
 
END FUNCTION
 
FUNCTION t7101_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON ohe02,ohe03
            FROM s_ohe[1].ohe02,s_ohe[1].ohe03
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
    CALL t7101_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t7101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    LET g_sql =
        "SELECT ohe02,ohe03,ock02",
        "  FROM ohe_file, OUTER ock_file" ,
        " WHERE ohe01 ='",g_ohf.ohf01,"'",  #單頭
        "   AND ock_file.ock01 = ohe_file.ohe03 ",
        "   AND ",p_wc2 CLIPPED, #單身
        " ORDER BY 1,2"
    PREPARE t7101_pb FROM g_sql
    DECLARE ohe_cs                       #CURSOR
        CURSOR FOR t7101_pb
 
    CALL g_ohe.clear()
    LET g_cnt = 1
 
    FOREACH ohe_cs INTO g_ohe[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_ohe.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t7101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohe TO s_ohe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t7101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t7101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t7101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t7101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t7101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
