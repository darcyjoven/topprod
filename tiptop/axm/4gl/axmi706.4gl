# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axmi706.4gl
# Descriptions...: 潛在客戶等級異動資料維護作業
# Date & Author..: 02/11/25 by Maggie
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-740332 07/04/27 By bnlent  _u()里潛在客戶狀態不為指派,故不可變更等級及業務員
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-BA0107 11/10/19 By destiny oriu,orig不能查询
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofe   RECORD LIKE ofe_file.*,
    g_ofe_t RECORD LIKE ofe_file.*,
    g_ofe_o RECORD LIKE ofe_file.*,
    g_ofe01_t      LIKE ofe_file.ofe01,
    g_ofe02_t      LIKE ofe_file.ofe02,
    g_argv1        LIKE ofe_file.ofe01,
    g_argv2        LIKE ofe_file.ofe05,
    g_argv3        LIKE ofe_file.ofe07,
     g_wc,g_sql         STRING,  #No.FUN-580092 HCN  
    l_cmd               LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE g_cmd        LIKE gbc_file.gbc05         #No.FUN-680137 VARCHAR(100)
DEFINE g_buf        LIKE ima_file.ima01         #No.FUN-680137 VARCHAR(40)
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
DEFINE   g_before_input_done   STRING
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    INITIALIZE g_ofe.* TO NULL
    INITIALIZE g_ofe_t.* TO NULL
    INITIALIZE g_ofe_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ofe_file WHERE ofe01 = ? AND ofe02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i706_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 8
    OPEN WINDOW i706_w AT p_row,p_col
         WITH FORM "axm/42f/axmi706"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN
       CALL i706_q()
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i706_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i706_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i706_cs()
    LET g_wc = ""
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "ofe01 ='",g_argv1,"'"
    ELSE
       CLEAR FORM
   INITIALIZE g_ofe.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                   # 螢幕上取條件
           ofe01,ofe02,ofe03,ofe04,ofe05,ofe08,ofe06,ofe07,
           ofeuser,ofegrup,ofemodu,ofedate,ofeacti
           ,ofeoriu,ofeorig  #TQC-BA0107
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           IF INFIELD(ofe01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_ofd"
              LET g_qryparam.default1 = g_ofe.ofe01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ofe01
              NEXT FIELD ofe01
           END IF
           IF INFIELD(ofe03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ofe.ofe03
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ofe03
              NEXT FIELD ofe03
           END IF
           IF INFIELD(ofe05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_ofc"
              LET g_qryparam.default1 = g_ofe.ofe05
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ofe05
              NEXT FIELD ofe05
           END IF
           IF INFIELD(ofe07) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ofe.ofe07
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ofe07
              NEXT FIELD ofe07
           END IF
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
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ofeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                          #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ofegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ofegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofeuser', 'ofegrup')
    #End:FUN-980030
 
 
    LET g_sql="SELECT ofe01,ofe02 FROM ofe_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY ofe01,ofe02"
    PREPARE i706_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i706_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i706_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ofe_file WHERE ",g_wc CLIPPED
    PREPARE i706_precount FROM g_sql
    DECLARE i706_count CURSOR FOR i706_precount
END FUNCTION
 
FUNCTION i706_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i706_a()
            END IF
 
        ON ACTION query
           LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i706_q()
            END IF
 
        ON ACTION next
           CALL i706_fetch('N')
 
        ON ACTION previous
           CALL i706_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i706_u()
            END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i706_fetch('/')
 
        ON ACTION first
           CALL i706_fetch('F')
 
        ON ACTION last
           CALL i706_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_ofe.ofe01 IS NOT NULL THEN
                  LET g_doc.column1 = "ofe01"
                  LET g_doc.column2 = "ofe02"
                  LET g_doc.value1 = g_ofe.ofe01
                  LET g_doc.value2 = g_ofe.ofe02
              CALL cl_doc()                            
               END IF                                        
            END IF                                           
         #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i706_cs
END FUNCTION
 
 
 
FUNCTION i706_a()
    DEFINE
        l_cmd           LIKE gbc_file.gbc05,        #No.FUN-680137 VARCHAR(100)
        l_ofd02         LIKE ofd_file.ofd02,
        l_ofc02         LIKE ofc_file.ofc02,
        l_gen02         LIKE gen_file.gen02
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                    # 清螢幕欄位內容
    INITIALIZE g_ofe.* LIKE ofe_file.*
    LET g_ofe01_t = NULL
    LET g_ofe02_t = NULL
    LET g_ofe.ofe03 = g_user
    CALL cl_opmsg('a')
    WHILE TRUE
       IF NOT cl_null(g_argv1) THEN
          LET g_ofe.ofe01 = g_argv1
          LET g_ofe.ofe02 = g_today
          LET g_ofe.ofe04 = g_argv2
          LET g_ofe.ofe06 = g_argv3
          SELECT ofd02 INTO l_ofd02 FROM ofd_file WHERE ofd01 = g_ofe.ofe01
          SELECT ofc02 INTO l_ofc02 FROM ofc_file WHERE ofc01 = g_ofe.ofe04
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ofe.ofe06
          DISPLAY BY NAME g_ofe.ofe02,g_ofe.ofe04,g_ofe.ofe06
          DISPLAY l_ofd02 TO FORMONLY.ofd02
          DISPLAY l_ofc02 TO FORMONLY.ofc02
          DISPLAY l_gen02 TO FORMONLY.gen02
       END IF
       LET g_ofe.ofeacti = 'Y'
       LET g_ofe.ofeuser = g_user
       LET g_ofe.ofeoriu = g_user #FUN-980030
       LET g_ofe.ofeorig = g_grup #FUN-980030
       LET g_data_plant = g_plant #FUN-980030
       LET g_ofe.ofegrup = g_grup
       LET g_ofe.ofedate = g_today
       LET g_ofe.ofe02 = g_today
       #FUN-980010 add plant & legal 
       LET g_ofe.ofeplant = g_plant 
       LET g_ofe.ofelegal = g_legal 
       #FUN-980010 end plant & legal 
       LET g_ofe_t.*=g_ofe.*
       CALL i706_i("a")                        # 各欄位輸入
       IF INT_FLAG THEN                        # 若按了DEL鍵
          LET INT_FLAG = 0
          INITIALIZE g_ofe.* TO NULL
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
       IF g_ofe.ofe01 IS NULL THEN                # KEY 不可空白
          CONTINUE WHILE
       END IF
       INSERT INTO ofe_file VALUES(g_ofe.*)       # DISK WRITE
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("ins","ofe_file",g_ofe.ofe01,g_ofe.ofe02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
          CONTINUE WHILE
       ELSE
          SELECT ofe01,ofe02 INTO g_ofe.ofe01,g_ofe.ofe02 FROM ofe_file
           WHERE ofe01 = g_ofe.ofe01 AND ofe02 = g_ofe.ofe02
          IF g_ofe.ofe06 != g_ofe.ofe07 OR g_ofe.ofe06 IS NULL THEN
             UPDATE ofd_file SET ofd10 = g_ofe.ofe05,ofd11 = g_ofe.ofe02,
                                 ofd12 = g_ofe.ofe08,ofd23 = g_ofe.ofe07,
                                 ofd24 = g_ofe.ofe02
              WHERE ofd01 = g_ofe.ofe01
             IF SQLCA.SQLCODE THEN
#               CALL cl_err('update ofd',SQLCA.SQLCODE,0)   #No.FUN-660167
                CALL cl_err3("upd","ofd_file",g_ofe.ofe01,"",SQLCA.SQLCODE,"","update ofd",1)  #No.FUN-660167
             END IF
          ELSE
             UPDATE ofd_file SET ofd10 = g_ofe.ofe05,
                                 ofd11 = g_ofe.ofe02,
                                 ofd12 = g_ofe.ofe08
              WHERE ofd01 = g_ofe.ofe01
             IF SQLCA.SQLCODE THEN
#               CALL cl_err('update ofd',SQLCA.SQLCODE,0)   #No.FUN-660167
                CALL cl_err3("upd","ofd_file",g_ofe.ofe01,"",SQLCA.SQLCODE,"","update ofd",1)  #No.FUN-660167
             END IF
          END IF
       END IF
       EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i706_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_ofd02         LIKE ofd_file.ofd02,
        l_gen02_3       LIKE gen_file.gen02,
        l_gen02         LIKE gen_file.gen02,
        l_gen02_2       LIKE gen_file.gen02,
        l_ofc02_1       LIKE ofc_file.ofc02,
        l_ofd22         LIKE ofd_file.ofd22          
 
    INPUT BY NAME g_ofe.ofeoriu,g_ofe.ofeorig,
        g_ofe.ofe01,g_ofe.ofe02,g_ofe.ofe03,g_ofe.ofe04,
        g_ofe.ofe05,g_ofe.ofe08,g_ofe.ofe06,g_ofe.ofe07,
        g_ofe.ofeuser,g_ofe.ofegrup,g_ofe.ofemodu,g_ofe.ofedate,g_ofe.ofeacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i706_set_entry(p_cmd)
           CALL i706_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD ofe01
           IF NOT cl_null(g_argv1) THEN
              LET g_ofe.ofe01 = g_argv1
              DISPLAY BY NAME g_ofe.ofe01
              SELECT ofd02 INTO l_ofd02 FROM ofd_file
               WHERE ofd01 = g_ofe.ofe01
              DISPLAY l_ofd02 TO FORMONLY.ofd02
              NEXT FIELD ofe02
           END IF
 
        AFTER FIELD ofe01
         IF g_ofe.ofe01 IS NOT NULL THEN
           IF p_cmd='a' OR (p_cmd='u' AND g_ofe_t.ofe01 != g_ofe.ofe01) THEN
              SELECT ofd02,ofd22 INTO l_ofd02,l_ofd22 FROM ofd_file
               WHERE ofd01 = g_ofe.ofe01
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("sel","ofd_file",g_ofe.ofe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 NEXT FIELD ofe01
              END IF
              DISPLAY l_ofd02 TO FORMONLY.ofd02
              IF l_ofd22 != '1' THEN
                 CALL cl_err(g_ofe.ofe01,'axm-464',0) NEXT FIELD ofe01
              END IF
           END IF
         END IF
 
        AFTER FIELD ofe02
         IF g_ofe.ofe02 IS NOT NULL THEN
           IF p_cmd='a' OR (p_cmd='u' AND
              (g_ofe_t.ofe01 != g_ofe.ofe01 OR g_ofe_t.ofe02 != g_ofe.ofe02))
              THEN
              SELECT COUNT(*) INTO l_n FROM ofe_file
               WHERE ofe01 = g_ofe.ofe01 AND ofe02 > g_ofe.ofe02
              IF l_n > 0 THEN
                 CALL cl_err(g_ofe.ofe02,'axm-466',0) NEXT FIELD ofe02
              END IF
              SELECT COUNT(*) INTO l_n FROM ofe_file
               WHERE ofe01 = g_ofe.ofe01 AND ofe02 = g_ofe.ofe02
              IF l_n >0 THEN
                 CALL cl_err(g_ofe.ofe02,-239,0)
                 LET g_ofe.ofe01 = g_ofe_t.ofe01
                 DISPLAY BY NAME g_ofe.ofe01
                 NEXT FIELD ofe01
              END IF
           END IF
         END IF
 
        AFTER FIELD ofe03
         IF g_ofe.ofe03 IS NOT NULL THEN
           IF p_cmd='a' OR (p_cmd='u' AND g_ofe_t.ofe03 != g_ofe.ofe03) THEN
              SELECT gen02 INTO l_gen02_3 FROM gen_file
               WHERE gen01 = g_ofe.ofe03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ofe.ofe03,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("sel","gen_file",g_ofe.ofe03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 NEXT FIELD ofe03
              END IF
              DISPLAY l_gen02_3 TO FORMONLY.gen02_3
           END IF
         END IF
 
        AFTER FIELD ofe05
         IF g_ofe.ofe05 IS NOT NULL THEN
           IF p_cmd='a' OR (p_cmd='u' AND g_ofe_t.ofe05 != g_ofe.ofe05) THEN
              SELECT ofc02 INTO l_ofc02_1 FROM ofc_file
               WHERE ofc01 = g_ofe.ofe05
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ofe.ofe05,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("sel","ofc_file",g_ofe.ofe05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 NEXT FIELD ofe05
              END IF
              DISPLAY l_ofc02_1 TO FORMONLY.ofc02_1
           END IF
         END IF
 
        AFTER FIELD ofe07
           IF NOT cl_null(g_ofe.ofe07) THEN
              SELECT gen02 INTO l_gen02_2 FROM gen_file
               WHERE gen01 = g_ofe.ofe07
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ofe.ofe07,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("sel","gen_file",g_ofe.ofe07,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 NEXT FIELD ofe07
              END IF
              DISPLAY l_gen02_2 TO FORMONLY.gen02_2
           END IF
 
        AFTER INPUT
           LET g_ofe.ofeuser = s_get_data_owner("ofe_file") #FUN-C10039
           LET g_ofe.ofegrup = s_get_data_group("ofe_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           IF INFIELD(ofe01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ofd"
              LET g_qryparam.default1 = g_ofe.ofe01
              CALL cl_create_qry() RETURNING g_ofe.ofe01
#              CALL FGL_DIALOG_SETBUFFER( g_ofe.ofe01 )
              DISPLAY BY NAME g_ofe.ofe01
              NEXT FIELD ofe01
           END IF
           IF INFIELD(ofe03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ofe.ofe03
              CALL cl_create_qry() RETURNING g_ofe.ofe03
#              CALL FGL_DIALOG_SETBUFFER( g_ofe.ofe03 )
              DISPLAY BY NAME g_ofe.ofe03
              NEXT FIELD ofe03
           END IF
           IF INFIELD(ofe05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ofc"
              LET g_qryparam.default1 = g_ofe.ofe05
              CALL cl_create_qry() RETURNING g_ofe.ofe05
#              CALL FGL_DIALOG_SETBUFFER( g_ofe.ofe05 )
              DISPLAY BY NAME g_ofe.ofe05
              NEXT FIELD ofe05
           END IF
           IF INFIELD(ofe07) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ofe.ofe07
              CALL cl_create_qry() RETURNING g_ofe.ofe07
#              CALL FGL_DIALOG_SETBUFFER( g_ofe.ofe07 )
              DISPLAY BY NAME g_ofe.ofe07
              NEXT FIELD ofe07
           END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                       # 欄位說明
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
 
FUNCTION i706_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i706_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i706_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)
        INITIALIZE g_ofe.* TO NULL
    ELSE
        OPEN i706_count
        FETCH i706_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i706_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i706_fetch(p_flofe)
    DEFINE
        p_flofe       LIKE type_file.chr1          #No.FUN-680137  VARCHAR(1)
 
    CASE p_flofe
        WHEN 'N' FETCH NEXT     i706_cs INTO g_ofe.ofe01,
                                             g_ofe.ofe02
        WHEN 'P' FETCH PREVIOUS i706_cs INTO g_ofe.ofe01,
                                             g_ofe.ofe02
        WHEN 'F' FETCH FIRST    i706_cs INTO g_ofe.ofe01,
                                             g_ofe.ofe02
        WHEN 'L' FETCH LAST     i706_cs INTO g_ofe.ofe01,
                                             g_ofe.ofe02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i706_cs INTO g_ofe.ofe01,
                                               g_ofe.ofe02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)
        INITIALIZE g_ofe.* TO NULL              #No.FUN-6A0020
        RETURN
    ELSE
       CASE p_flofe
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofe.* FROM ofe_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ofe01 = g_ofe.ofe01 AND ofe02 = g_ofe.ofe02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ofe_file",g_ofe.ofe01,g_ofe.ofe02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofe.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_ofe.ofeuser      #FUN-4C0057 add
       LET g_data_group = g_ofe.ofegrup      #FUN-4C0057 add
       LET g_data_plant = g_ofe.ofeplant #FUN-980030
       CALL i706_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i706_show()
    DEFINE
        l_ofd02         LIKE ofd_file.ofd02,
        l_ofc02         LIKE ofc_file.ofc02,
        l_ofc02_1       LIKE ofc_file.ofc02,
        l_gen02         LIKE gen_file.gen02,
        l_gen02_2       LIKE gen_file.gen02,
        l_gen02_3       LIKE gen_file.gen02
 
    SELECT ofd02 INTO l_ofd02   FROM ofd_file WHERE ofd01 = g_ofe.ofe01
    SELECT ofc02 INTO l_ofc02   FROM ofc_file WHERE ofc01 = g_ofe.ofe04
    SELECT ofc02 INTO l_ofc02_1 FROM ofc_file WHERE ofc01 = g_ofe.ofe05
    SELECT gen02 INTO l_gen02_3 FROM gen_file WHERE gen01 = g_ofe.ofe03
    SELECT gen02 INTO l_gen02   FROM gen_file WHERE gen01 = g_ofe.ofe06
    SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = g_ofe.ofe07
 
    LET g_ofe_t.* = g_ofe.*
    DISPLAY BY NAME g_ofe.ofeoriu,g_ofe.ofeorig,
        g_ofe.ofe01,g_ofe.ofe02,g_ofe.ofe03,g_ofe.ofe04,
        g_ofe.ofe05,g_ofe.ofe06,g_ofe.ofe07,g_ofe.ofe08,g_ofe.ofeuser,
        g_ofe.ofegrup,g_ofe.ofemodu,g_ofe.ofedate,g_ofe.ofeacti
    DISPLAY l_ofd02   TO FORMONLY.ofd02
    DISPLAY l_ofc02   TO FORMONLY.ofc02
    DISPLAY l_ofc02_1 TO FORMONLY.ofc02_1
    DISPLAY l_gen02_3 TO FORMONLY.gen02_3
    DISPLAY l_gen02   TO FORMONLY.gen02
    DISPLAY l_gen02_2 TO FORMONLY.gen02_2
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i706_u()
DEFINE l_ofd22   LIKE ofd_file.ofd22          #No.TQC-740332
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ofe.ofe01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    #No.TQC-740332  --Begin
    SELECT ofd22 INTO l_ofd22 FROM ofd_file
    WHERE ofd01 = g_ofe.ofe01
    IF l_ofd22 != '1' THEN
       CALL cl_err(g_ofe.ofe01,'axm-464',0)
       CALL cl_set_comp_entry("ofe05,ofe07,ofe08",FALSE)
    END IF
    #No.TQC-740332  --End
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofe01_t = g_ofe.ofe01
    LET g_ofe02_t = g_ofe.ofe02
    LET g_ofe_o.* =g_ofe.*
    BEGIN WORK
 
    OPEN i706_cl USING g_ofe.ofe01,g_ofe.ofe02
    IF STATUS THEN
       CALL cl_err("OPEN i706_cl:", STATUS, 1)
       CLOSE i706_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i706_cl INTO g_ofe.*              # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofe.ofemodu=g_user                     #修改者
    LET g_ofe.ofedate = g_today                  #修改日期
    CALL i706_show()                           # 顯示最新資料
    WHILE TRUE
        LET g_ofe_t.*=g_ofe.*
        CALL i706_i("u")                       # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofe.*=g_ofe_o.*
            CALL i706_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofe_file SET ofe_file.* = g_ofe.*    # 更新DB
            WHERE ofe01 = g_ofe_t.ofe01 AND ofe02 = g_ofe_t.ofe02
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofe.ofe01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofe_file",g_ofe01_t,g_ofe02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        IF g_ofe.ofe06 != g_ofe.ofe07 OR g_ofe.ofe06 IS NULL THEN
           UPDATE ofd_file SET ofd10 = g_ofe.ofe05,ofd11 = g_ofe.ofe02,
                               ofd12 = g_ofe.ofe08,ofd23 = g_ofe.ofe07,
                               ofd24 = g_ofe.ofe02
            WHERE ofd01 = g_ofe.ofe01
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('update ofd',SQLCA.SQLCODE,0)   #No.FUN-660167
              CALL cl_err3("upd","ofd_file",g_ofe.ofe01,"",SQLCA.SQLCODE,"","update ofd",1)  #No.FUN-660167
           END IF
        ELSE
           UPDATE ofd_file SET ofd10 = g_ofe.ofe05,
                               ofd11 = g_ofe.ofe02,
                               ofd12 = g_ofe.ofe08
            WHERE ofd01 = g_ofe.ofe01
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('update ofd',SQLCA.SQLCODE,0)   #No.FUN-660167
              CALL cl_err3("upd","ofd_file",g_ofe.ofe01,"",SQLCA.SQLCODE,"","update ofd",1)  #No.FUN-660167
           END IF
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i706_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i706_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("ofe01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i706_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofe01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

