# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acsi400.4gl
# Descriptions...: 成本中心資料維護作業
# Date & Author..: 92/01/14 By MAY
# Modify.........: No.FUN-5100339 05/01/20 By pengu 報表轉XML
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-C40086 12/04/12 By lujh 狀態”頁簽，“資料建立者”、“資料建立部門”無法下查詢條件
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_smh   RECORD LIKE smh_file.*,
    g_smh_t RECORD LIKE smh_file.*,
    g_smh_o RECORD LIKE smh_file.*,
    g_smh01_t LIKE smh_file.smh01,
    g_wc,g_sql          LIKE type_file.chr1000,#TQC-630166  #No.FUN-680071 VARCHAR(300)
    g_cmd               LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(60)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_head1         STRING
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0064
DEFINE p_row,p_col	LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
    INITIALIZE g_smh.* TO NULL
    INITIALIZE g_smh_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM smh_file WHERE smh01 = ? FOR UPDATE"
    #--LOCK CURSOR
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE acsi400_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW acsi400_w AT p_row,p_col WITH FORM "acs/42f/acsi400"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL acsi400_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW acsi400_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
END MAIN
 
FUNCTION acsi400_cs()
    CLEAR FORM
   INITIALIZE g_smh.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        smh01,smh02,
        smh103,smh203,smh303,
        smh104,smh204,smh304,
        smh105,smh205,smh305,
        smh106,smh206,smh306,
        smh107,smh207,smh307,
        smh108,smh208,smh308,
        smh109,smh209,smh309,
        smhuser,smhgrup,smhoriu,smhorig,smhmodu,smhdate,smhacti     #TQC-C40086  add smhoriu,smhorig
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
         ON ACTION controlp
            CASE
                WHEN INFIELD(smh104)
#                  CALL q_smg(10,2,g_smh.smh104) RETURNING g_smh.smh104
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh104
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh104
                WHEN INFIELD(smh107)
#                  CALL q_smg(10,2,g_smh.smh107) RETURNING g_smh.smh107
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh107
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh107
                WHEN INFIELD(smh109)
#                  CALL q_smg(10,2,g_smh.smh109) RETURNING g_smh.smh109
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh109
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh109
                WHEN INFIELD(smh204)
#                  CALL q_smg(10,2,g_smh.smh204) RETURNING g_smh.smh204
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh204
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh204
                WHEN INFIELD(smh207)
#                  CALL q_smg(10,2,g_smh.smh207) RETURNING g_smh.smh207
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh207
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh207
                WHEN INFIELD(smh209)
#                  CALL q_smg(10,2,g_smh.smh209) RETURNING g_smh.smh209
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh209
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh209
                WHEN INFIELD(smh304)
#                  CALL q_smg(10,2,g_smh.smh304) RETURNING g_smh.smh304
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh304
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh304
                WHEN INFIELD(smh307)
#                  CALL q_smg(10,2,g_smh.smh307) RETURNING g_smh.smh307
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh307
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh307
                WHEN INFIELD(smh309)
#                  CALL q_smg(10,2,g_smh.smh309) RETURNING g_smh.smh309
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_smh.smh309
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smh309
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND smhuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND smhgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND smhgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('smhuser', 'smhgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT smh01 FROM smh_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY smh01 "
    PREPARE acsi400_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE acsi400_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR acsi400_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM smh_file WHERE ",g_wc CLIPPED
    PREPARE acsi400_precount FROM g_sql
    DECLARE acsi400_count CURSOR FOR acsi400_precount
END FUNCTION
 
FUNCTION acsi400_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL acsi400_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL acsi400_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL acsi400_fetch('N')
        ON ACTION previous
            CALL acsi400_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL acsi400_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL acsi400_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL acsi400_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL acsi400_copy()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL acsi400_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
#       ON ACTION jump
#           CALL acsi400_fetch('/')
#       ON ACTION first
#           CALL acsi400_fetch('F')
#       ON ACTION last
#           CALL acsi400_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_smh.smh01 IS NOT NULL THEN
                  LET g_doc.column1 = "smh01"
                  LET g_doc.value1 = g_smh.smh01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0150-------add--------end----
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE acsi400_cs
END FUNCTION
 
 
FUNCTION acsi400_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_smh.* LIKE smh_file.*
    LET g_smh01_t = NULL
    LET g_smh_t.*=g_smh.*
    LET g_smh_o.*=g_smh.*
    CALL cl_opmsg('a')
    WHILE TRUE
        #NO.590002 START----------
        LET g_smh.smh105 = '1'
        LET g_smh.smh205 = '1'
        LET g_smh.smh305 = '1'
        #NO.590002 END------------
        LET g_smh.smhacti ='Y'                   #有效的資料
        LET g_smh.smhuser = g_user
        LET g_smh.smhoriu = g_user #FUN-980030
        LET g_smh.smhorig = g_grup #FUN-980030
        LET g_smh.smhgrup = g_grup               #使用者所屬群
        LET g_smh.smhdate = g_today
        CALL acsi400_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_smh.smh01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO smh_file VALUES(g_smh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
            CALL cl_err3("ins","smh_file",g_smh.smh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            CONTINUE WHILE
        ELSE
            LET g_smh_t.* = g_smh.*                # 保存上筆資料
            LET g_smh_o.* = g_smh.*                # 保存上筆資料
            SELECT smh01 INTO g_smh.smh01 FROM smh_file
                WHERE smh01 = g_smh.smh01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION acsi400_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    DISPLAY BY NAME g_smh.smhuser,g_smh.smhgrup,
        g_smh.smhmodu,g_smh.smhdate, g_smh.smhacti
    INPUT BY NAME
        g_smh.smh01 ,g_smh.smh02,
        g_smh.smh103,g_smh.smh203,g_smh.smh303,
        g_smh.smh104,g_smh.smh204,g_smh.smh304,
        g_smh.smh105,g_smh.smh205,g_smh.smh305,
        g_smh.smh106,g_smh.smh206,g_smh.smh306,
        g_smh.smh107,g_smh.smh207,g_smh.smh307,
        g_smh.smh108,g_smh.smh208,g_smh.smh308,
        g_smh.smh109,g_smh.smh209,g_smh.smh309
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i400_set_entry(p_cmd)
           CALL i400_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD smh01
          IF g_smh.smh01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (g_smh01_t IS NULL) OR
              (p_cmd = "u" AND g_smh.smh01 != g_smh01_t) THEN
                SELECT count(*) INTO l_n FROM smh_file
                    WHERE smh01 = g_smh.smh01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_smh.smh01,-239,0)
                    LET g_smh.smh01 = g_smh01_t
                    DISPLAY BY NAME g_smh.smh01
                    NEXT FIELD smh01
                END IF
            END IF
          END IF
 
        AFTER FIELD smh104
              IF g_smh.smh104 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh104
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh104,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh104,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh104
                 END IF
               END IF
 
        AFTER FIELD smh105
              IF g_smh.smh105 IS NOT NULL AND
                 g_smh.smh105 NOT MATCHES'[1-4]' THEN
                 NEXT FIELD smh105
              END IF
 
        AFTER FIELD smh107
              IF g_smh.smh107 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh107
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh107,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh107,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh107
                 END IF
               END IF
 
        AFTER FIELD smh109
              IF g_smh.smh109 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh109
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh109,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh109,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh109
                 END IF
               END IF
 
        AFTER FIELD smh204
              IF g_smh.smh204 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh204
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh204,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh204,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh204
                 END IF
               END IF
 
        AFTER FIELD smh205
              IF g_smh.smh205 IS NOT NULL AND
                 g_smh.smh205 NOT MATCHES'[1-4]' THEN
                 NEXT FIELD smh205
              END IF
 
        AFTER FIELD smh207
              IF g_smh.smh207 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh207
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh207,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh207,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh207
                 END IF
               END IF
 
        AFTER FIELD smh209
              IF g_smh.smh209 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh209
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh209,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh209,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh209
                 END IF
               END IF
 
        AFTER FIELD smh304
              IF g_smh.smh304 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh304
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh304,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh304,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh304
                 END IF
               END IF
 
        AFTER FIELD smh305
              IF g_smh.smh305 IS NOT NULL AND
                 g_smh.smh305 NOT MATCHES'[1-4]' THEN
                 NEXT FIELD smh305
              END IF
 
        AFTER FIELD smh307
              IF g_smh.smh307 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh307
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh307,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh307,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh307
                 END IF
               END IF
 
        AFTER FIELD smh309
              IF g_smh.smh309 IS NOT NULL THEN
                 SELECT smg01 FROM smg_file WHERE smg01 = g_smh.smh309
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smh.smh309,'mfg1313',0)   #No.FUN-660089
                    CALL cl_err3("sel","smg_file",g_smh.smh309,"","mfg1313","","",1)  #No.FUN-660089
                    NEXT FIELD smh309
                 END IF
               END IF
 
        #MOD-650015 --start  
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(smh01) THEN
        #        LET g_smh.* = g_smh_t.*
        #        DISPLAY BY NAME g_smh.*
        #        NEXT FIELD smh01
        #    END IF
        #MOD-650015 --end
 
         ON ACTION controlp
            CASE
                WHEN INFIELD(smh104)
#                  CALL q_smg(10,2,g_smh.smh104) RETURNING g_smh.smh104
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh104 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh104
                   CALL cl_create_qry() RETURNING g_smh.smh104
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh104 )
                   DISPLAY BY NAME g_smh.smh104
                WHEN INFIELD(smh107)
#                  CALL q_smg(10,2,g_smh.smh107) RETURNING g_smh.smh107
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh107 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh107
                   CALL cl_create_qry() RETURNING g_smh.smh107
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh107 )
                   DISPLAY BY NAME g_smh.smh107
                WHEN INFIELD(smh109)
#                  CALL q_smg(10,2,g_smh.smh109) RETURNING g_smh.smh109
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh109 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh109
                   CALL cl_create_qry() RETURNING g_smh.smh109
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh109 )
                   DISPLAY BY NAME g_smh.smh109
                WHEN INFIELD(smh204)
#                  CALL q_smg(10,2,g_smh.smh204) RETURNING g_smh.smh204
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh204 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh204
                   CALL cl_create_qry() RETURNING g_smh.smh204
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh204 )
                   DISPLAY BY NAME g_smh.smh204
                WHEN INFIELD(smh207)
#                  CALL q_smg(10,2,g_smh.smh207) RETURNING g_smh.smh207
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh207 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh207
                   CALL cl_create_qry() RETURNING g_smh.smh207
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh207 )
                   DISPLAY BY NAME g_smh.smh207
                WHEN INFIELD(smh209)
#                  CALL q_smg(10,2,g_smh.smh209) RETURNING g_smh.smh209
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh209 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh209
                   CALL cl_create_qry() RETURNING g_smh.smh209
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh209 )
                   DISPLAY BY NAME g_smh.smh209
                WHEN INFIELD(smh304)
#                  CALL q_smg(10,2,g_smh.smh304) RETURNING g_smh.smh304
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh304 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh304
                   CALL cl_create_qry() RETURNING g_smh.smh304
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh304 )
                   DISPLAY BY NAME g_smh.smh304
                WHEN INFIELD(smh307)
#                  CALL q_smg(10,2,g_smh.smh307) RETURNING g_smh.smh307
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh307 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh307
                   CALL cl_create_qry() RETURNING g_smh.smh307
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh307 )
                   DISPLAY BY NAME g_smh.smh307
                WHEN INFIELD(smh309)
#                  CALL q_smg(10,2,g_smh.smh309) RETURNING g_smh.smh309
#                  CALL FGL_DIALOG_SETBUFFER( g_smh.smh309 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_smg"
                   LET g_qryparam.default1 = g_smh.smh309
                   CALL cl_create_qry() RETURNING g_smh.smh309
#                   CALL FGL_DIALOG_SETBUFFER( g_smh.smh309 )
                   DISPLAY BY NAME g_smh.smh309
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLF                         # 欄位說明
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
 
FUNCTION acsi400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_smh.* TO NULL                 #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL acsi400_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN acsi400_count
    FETCH acsi400_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN acsi400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)
        INITIALIZE g_smh.* TO NULL
    ELSE
        CALL acsi400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION acsi400_fetch(p_flsmh)
    DEFINE
        p_flsmh         LIKE type_file.chr1,   #No.FUN-680071 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680071 INTEGER
 
    CASE p_flsmh
        WHEN 'N' FETCH NEXT     acsi400_cs INTO g_smh.smh01
        WHEN 'P' FETCH PREVIOUS acsi400_cs INTO g_smh.smh01
        WHEN 'F' FETCH FIRST    acsi400_cs INTO g_smh.smh01
        WHEN 'L' FETCH LAST     acsi400_cs INTO g_smh.smh01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso acsi400_cs INTO g_smh.smh01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)
        INITIALIZE g_smh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsmh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_smh.* FROM smh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE smh01 = g_smh.smh01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("sel","smh_file",g_smh.smh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
    ELSE
#       LET g_data_owner = g_smh.smhuser
#       LET g_data_group = g_smh.smhgrup
        CALL acsi400_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION acsi400_show()
    LET g_smh_t.* = g_smh.*
    LET g_smh_o.* = g_smh.*
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_smh.*
    DISPLAY BY NAME g_smh.smh01,g_smh.smh02,g_smh.smh103,g_smh.smh203,g_smh.smh303,
                    g_smh.smh104,g_smh.smh204,g_smh.smh304,g_smh.smh105,g_smh.smh205,
                    g_smh.smh305,g_smh.smh106,g_smh.smh206,g_smh.smh306,g_smh.smh107,
                    g_smh.smh207,g_smh.smh307,g_smh.smh108,g_smh.smh208,g_smh.smh308,
                    g_smh.smh109,g_smh.smh209,g_smh.smh309, g_smh.smhuser,g_smh.smhgrup,
                    g_smh.smhmodu,g_smh.smhdate, g_smh.smhacti,g_smh.smhoriu,g_smh.smhorig
    #No.FUN-9A0024--end 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION acsi400_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_smh.smh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_smh.* FROM smh_file
     WHERE smh01=g_smh.smh01
    IF g_smh.smhacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_smh.smh01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_smh01_t = g_smh.smh01
    BEGIN WORK
 
    OPEN acsi400_cl USING g_smh.smh01
    IF STATUS THEN
       CALL cl_err("OPEN acsi400_cl:", STATUS, 1)
       CLOSE acsi400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH acsi400_cl INTO g_smh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_smh.smhmodu=g_user                     #修改者
    LET g_smh.smhdate = g_today                  #修改日期
    CALL acsi400_show()                          # 顯示最新資料
    WHILE TRUE
        CALL acsi400_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_smh.*=g_smh_t.*
            CALL acsi400_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE smh_file SET smh_file.* = g_smh.*    # 更新DB
            WHERE smh01 = g_smh.smh01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
            CALL cl_err3("upd","smh_file",g_smh.smh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE acsi400_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION acsi400_x()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smh.smh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN acsi400_cl USING g_smh.smh01
    IF STATUS THEN
       CALL cl_err("OPEN acsi400_cl:", STATUS, 1)
       CLOSE acsi400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH acsi400_cl INTO g_smh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL acsi400_show()
    IF cl_exp(20,20,g_smh.smhacti) THEN
        LET g_chr=g_smh.smhacti
        IF g_smh.smhacti='Y' THEN
            LET g_smh.smhacti='N'
        ELSE
            LET g_smh.smhacti='Y'
        END IF
        UPDATE smh_file
            SET smhacti=g_smh.smhacti,
               smhmodu=g_user, smhdate=g_today
            WHERE smh01 = g_smh.smh01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
            CALL cl_err3("upd","smh_file",g_smh.smh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            LET g_smh.smhacti=g_chr
        END IF
        DISPLAY BY NAME g_smh.smhacti
    END IF
    CLOSE acsi400_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION acsi400_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smh.smh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN acsi400_cl USING g_smh.smh01
    IF STATUS THEN
       CALL cl_err("OPEN acsi400_cl:", STATUS, 1)
       CLOSE acsi400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH acsi400_cl INTO g_smh.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0) RETURN END IF
    CALL acsi400_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "smh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_smh.smh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM smh_file WHERE smh01 = g_smh.smh01
        IF SQLCA.SQLERRD[3]=0
#            THEN
#                  CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
             THEN
#                  CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
                   CALL cl_err3("del","smh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660089
              
             ELSE CLEAR FORM
        END IF
    END IF
    CLOSE acsi400_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION acsi400_copy()
    DEFINE
        l_smh       RECORD  LIKE smh_file.*,
        l_n             LIKE type_file.num5,    #No.FUN-680071 SMALLINT
        l_oldno         LIKE smh_file.smh01,
        l_newno         LIKE smh_file.smh01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smh.smh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
 
    LET g_before_input_done = FALSE
    CALL i400_set_entry('a')
    CALL i400_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM smh01
        AFTER FIELD smh01
            IF l_newno IS NULL THEN
                NEXT FIELD smh01
            END IF
            SELECT count(*) INTO g_cnt FROM smh_file
                WHERE smh01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD smh01
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
        DISPLAY BY NAME g_smh.smh01
        RETURN
    END IF
{
    DROP TABLE x
    SELECT * FROM smh_file
        WHERE smh01 = g_smh.smh01
        INTO TEMP x
    UPDATE x
}
    LET l_smh.*= g_smh.*        #資料所有者
    LET l_smh.smh01=l_newno     #資料鍵值
    LET l_smh.smhuser=g_user    #資料所有者
    LET l_smh.smhgrup=g_grup    #資料所有者所屬群
    LET l_smh.smhmodu=NULL      #資料修改日期
    LET l_smh.smhdate=g_today   #資料建立日期
    LET l_smh.smhacti='Y'       #有效資料
    LET l_smh.smhoriu = g_user      #No.FUN-980030 10/01/04
    LET l_smh.smhorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO smh_file VALUES(l_smh.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_smh.smh01,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("ins","smh_file",g_smh.smh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_smh.smh01
        LET g_smh.smh01 = l_newno
        SELECT smh_file.* INTO g_smh.*
               FROM smh_file WHERE smh01 = l_newno
        CALL acsi400_u()
        #FUN-C30027---begin
        #SELECT smh_file.* INTO g_smh.* FROM smh_file
        #    WHERE smh01 = l_oldno
        #CALL acsi400_show()
        #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_smh.smh01
END FUNCTION
 
FUNCTION acsi400_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-680071 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680071 VARCHAR(20)
        l_smh   RECORD LIKE smh_file.*,
        l_za05          LIKE type_file.chr1000,               #  #No.FUN-680071 VARCHAR(40)
        l_chr           LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" smh01='",g_smh.smh01,"'"
    END IF
 
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('acsi400') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM smh_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE acsi400_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE acsi400_co CURSOR FOR acsi400_p1
 
    START REPORT acsi400_rep TO l_name
 
    FOREACH acsi400_co INTO l_smh.*
        IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)   #No.FUN-660089
            CALL cl_err3("sel","g_company","","",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT acsi400_rep(l_smh.*)
    END FOREACH
 
    FINISH REPORT acsi400_rep
 
    CLOSE acsi400_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT acsi400_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
        sr RECORD LIKE smh_file.*,
        l_chr           LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.smh01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            LET g_head1=g_x[11] CLIPPED
            PRINT g_head1
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.smh01
           PRINT COLUMN g_c[31],g_x[14] CLIPPED,
                 COLUMN g_c[32],sr.smh01,
                 COLUMN g_c[33],sr.smh02
 
        ON EVERY ROW
	   PRINT COLUMN g_c[31],sr.smh103 USING '#######&.#####',
                 COLUMN g_c[32],sr.smh104,
                 COLUMN g_c[33],sr.smh106 USING '#######&.#####',
                 COLUMN g_c[34],sr.smh107,
                 COLUMN g_c[35],sr.smh108 USING '#######&.#####',
                 COLUMN g_c[36],sr.smh109,
                 COLUMN g_c[37],sr.smh105
           PRINT COLUMN g_c[31],sr.smh203 USING '#######&.#####',
                 COLUMN g_c[32],sr.smh204,
                 COLUMN g_c[33],sr.smh206 USING '#######&.#####',
                 COLUMN g_c[34],sr.smh207,
                 COLUMN g_c[35],sr.smh208 USING '#######&.#####',
                 COLUMN g_c[36],sr.smh209,
                 COLUMN g_c[37],sr.smh205
           PRINT COLUMN g_c[31],sr.smh303 USING '#######&.#####',
                 COLUMN g_c[32],sr.smh304,
                 COLUMN g_c[33],sr.smh306 USING '#######&.#####',
                 COLUMN g_c[34],sr.smh307,
                 COLUMN g_c[35],sr.smh308 USING '#######&.#####',
                 COLUMN g_c[36],sr.smh309,
                 COLUMN g_c[37],sr.smh305
           PRINT
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
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
END REPORT
 
FUNCTION i400_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("smh01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i400_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("smh01",FALSE)
 END IF
END FUNCTION
 
