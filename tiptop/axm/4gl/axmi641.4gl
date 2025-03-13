# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmi641.4gl
# Descriptions...: 佣金客戶資料維護作業
# Date & Author..: 02/11/19 By Maggie
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"`
# Modify.........: No.TQC-710115 07/03/28 By Judy 比率，基准無控管，可錄入負值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80246 11/09/05 By Carrier CONSTRUCT时加入oriu/orig
# Modify.........: No.TQC-BB0073 11/11/14 By destiny 客户编号无管控                 
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofu        RECORD LIKE ofu_file.*,
    g_ofu_t      RECORD LIKE ofu_file.*,
    g_ofu_o      RECORD LIKE ofu_file.*,
    g_ofu01_t           LIKE ofu_file.ofu01,
    g_ofu02_t           LIKE ofu_file.ofu02,
    g_argv1             LIKE ofu_file.ofu01,
     g_wc,g_sql         STRING,  #No.FUN-580092 HCN 
    l_cmd               LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE g_cmd            LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE g_buf            LIKE ima_file.ima01     #No.FUN-680137 VARCHAR(40)
 
DEFINE   g_forupd_sql  STRING #SELECT ... FOR UPDATE SQL 
DEFINE   g_before_input_done    STRING  
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0094
 
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
    INITIALIZE g_ofu.* TO NULL
    INITIALIZE g_ofu_t.* TO NULL
    INITIALIZE g_ofu_o.* TO NULL
 
 
    LET g_forupd_sql = " SELECT * FROM ofu_file WHERE ofu01 = ? AND ofu02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i641_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 4 LET p_col = 10
 
    OPEN WINDOW i641_w AT p_row,p_col
        WITH FORM "axm/42f/axmi641"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i641_q()
    END IF
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i641_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i641_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i641_cs()
    LET g_wc = ""
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "ofu01 ='",g_argv1,"'"
    ELSE
       CLEAR FORM
   INITIALIZE g_ofu.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                      # 螢幕上取條件
           ofu01,ofu02,ofu03,ofu04,
           ofu05,ofu06,ofu07,ofu08,ofu09,
           ofu10,ofu11,ofu12,ofu13,ofu14,
           ofuuser,ofugrup,ofuoriu,ofuorig,ofumodu, ofudate   #No.TQC-B80246
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ofs"
                 LET g_qryparam.default1 = g_ofu.ofu01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofu01
                 NEXT FIELD ofu01
              WHEN INFIELD(ofu02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_ofu.ofu02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofu02
                 NEXT FIELD ofu02
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
    #        LET g_wc = g_wc clipped," AND ofuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ofugrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ofugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofuuser', 'ofugrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ofu01,ofu02 FROM ofu_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY ofu01,ofu02"
    PREPARE i641_prepare FROM g_sql          # RUNTIME 編譯
    DECLARE i641_cs                          # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i641_prepare
    LET g_sql=
           "SELECT COUNT(*) FROM ofu_file WHERE ",g_wc CLIPPED
    PREPARE i641_precount FROM g_sql
    DECLARE i641_count CURSOR FOR i641_precount
END FUNCTION
 
FUNCTION i641_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i641_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i641_q()
            END IF
            NEXT OPTION "next"
 
        ON ACTION next
           CALL i641_fetch('N')
 
        ON ACTION previous
           CALL i641_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i641_u()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i641_r()
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
           CALL i641_fetch('/')
 
        ON ACTION first
           CALL i641_fetch('F')
 
        ON ACTION last
           CALL i641_fetch('L')
 
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
               IF g_ofu.ofu01 IS NOT NULL THEN
                  LET g_doc.column1 = "ofu01"
                  LET g_doc.column2 = "ofu02"
                  LET g_doc.value1 = g_ofu.ofu01
                  LET g_doc.value2 = g_ofu.ofu02
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
    CLOSE i641_cs
END FUNCTION
 
FUNCTION i641_a()
    DEFINE l_cmd     LIKE gbc_file.gbc05        #No.FUN-680137  VARCHAR(100)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                    # 清螢幕欄位內容
    INITIALIZE g_ofu.* LIKE ofu_file.*
    LET g_ofu01_t = NULL
    LET g_ofu02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ofu.ofu03 = '1'
        LET g_ofu.ofu04 = 0
        LET g_ofu.ofu05 = 0
        LET g_ofu.ofu06 = 0
        LET g_ofu.ofu07 = 0
        LET g_ofu.ofu08 = 0
        LET g_ofu.ofu09 = 0
        LET g_ofu.ofu10 = 0
        LET g_ofu.ofu11 = 0
        LET g_ofu.ofu12 = 0
        LET g_ofu.ofu13 = 0
        LET g_ofu.ofu14 = 0
        LET g_ofu.ofuuser = g_user
        LET g_ofu.ofuoriu = g_user #FUN-980030
        LET g_ofu.ofuorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ofu.ofugrup = g_grup
        LET g_ofu.ofudate = g_today
        #FUN-980010 add plant & legal 
        LET g_ofu.ofuplant = g_plant 
        LET g_ofu.ofulegal = g_legal 
        #FUN-980010 end plant & legal 
        LET g_ofu_t.*=g_ofu.*
        CALL i641_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ofu.ofu01 IS NULL THEN               # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ofu_file VALUES(g_ofu.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","ofu_file",g_ofu.ofu01,g_ofu.ofu02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
           SELECT ofu01,ofu02 INTO g_ofu.ofu01,g_ofu.ofu02 FROM ofu_file
            WHERE ofu01 = g_ofu.ofu01 AND ofu02 = g_ofu.ofu02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i641_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
	l_chr		LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_ofs02         LIKE ofs_file.ofs02,
        l_occ02         LIKE occ_file.occ02
 
   INPUT BY NAME g_ofu.ofuoriu,g_ofu.ofuorig,
        g_ofu.ofu01,g_ofu.ofu02,g_ofu.ofu03,g_ofu.ofu04,
        g_ofu.ofu05,g_ofu.ofu06,g_ofu.ofu07,g_ofu.ofu08,g_ofu.ofu09,
        g_ofu.ofu10,g_ofu.ofu11,g_ofu.ofu12,g_ofu.ofu13,g_ofu.ofu14,
        g_ofu.ofuuser,g_ofu.ofugrup,g_ofu.ofumodu, g_ofu.ofudate
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i641_set_entry(p_cmd)
           CALL i641_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD ofu01
            IF NOT cl_null(g_argv1) THEN
               LET g_ofu.ofu01 = g_argv1
               DISPLAY BY NAME g_ofu.ofu01
               SELECT ofs02 INTO l_ofs02 FROM ofs_file WHERE ofs01 = g_ofu.ofu01
               DISPLAY l_ofs02 TO FORMONLY.ofs02
               NEXT FIELD ofu02
            END IF
 
        AFTER FIELD ofu01
          IF g_ofu.ofu01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ofu.ofu01 != g_ofu_t.ofu01) THEN
               SELECT ofs02 INTO l_ofs02 FROM ofs_file
                WHERE ofs01 = g_ofu.ofu01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ofu.ofu01,'axm-641',0)    #無此佣金代號   #No.FUN-660167
                  CALL cl_err3("sel","ofs_file",g_ofu.ofu01,"","axm-641","","",1)  #No.FUN-660167
                  NEXT FIELD ofu01
               END IF
               DISPLAY l_ofs02 TO FORMONLY.ofs02
            END IF
          END IF
 
        AFTER FIELD ofu02
        IF g_ofu.ofu02 IS NOT NULL THEN
          IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
           #(p_cmd = "u" AND g_ofu.ofu01 != g_ofu_t.ofu01) THEN  #TQC-BB0073
            (p_cmd = "u" AND g_ofu.ofu02 != g_ofu_t.ofu02) THEN  #TQC-BB0073
             SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_ofu.ofu02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ofu.ofu02,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("sel","occ_file",g_ofu.ofu02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                NEXT FIELD ofu02
             END IF
             DISPLAY l_occ02 TO FORMONLY.occ02
             SELECT COUNT(*) INTO l_n FROM ofu_file
              WHERE ofu01 = g_ofu.ofu01 AND ofu02 = g_ofu.ofu02
             IF l_n > 0 THEN                  # Duplicated
                CALL cl_err(g_ofu.ofu01,-239,0)
                LET g_ofu.ofu01 = g_ofu_t.ofu01
                DISPLAY BY NAME g_ofu.ofu01
                NEXT FIELD ofu01
             END IF
          END IF
        END IF
 
        AFTER FIELD ofu03
	  IF g_ofu.ofu03 NOT MATCHES '[1234]' THEN
             NEXT FIELD ofu03
          END IF
#TQC-710115.....begin                                                           
        AFTER FIELD ofu04                                                       
          IF g_ofu.ofu04 < 0 OR g_ofu.ofu04 > 100 THEN   
             CALL cl_err(g_ofu.ofu04,'axm-986',0)                               
             NEXT FIELD ofu04                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu05                                                       
          IF g_ofu.ofu05 < 0 THEN   
             CALL cl_err(g_ofu.ofu05,'mfg5034',0)                               
             NEXT FIELD ofu05                                                   
          END IF
                                                                                
        AFTER FIELD ofu06                                                       
          IF g_ofu.ofu06 < 0 OR g_ofu.ofu06 > 100 THEN   
             CALL cl_err(g_ofu.ofu06,'axm-986',0)                               
             NEXT FIELD ofu06                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu07                                                       
          IF g_ofu.ofu07 < 0 THEN   
             CALL cl_err(g_ofu.ofu07,'mfg5034',0)                               
             NEXT FIELD ofu07                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu08                                                       
          IF g_ofu.ofu08 < 0 OR g_ofu.ofu08 > 100 THEN   
             CALL cl_err(g_ofu.ofu08,'axm-986',0)                               
             NEXT FIELD ofu08                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu09
          IF g_ofu.ofu09 < 0 THEN   
             CALL cl_err(g_ofu.ofu09,'mfg5034',0)                               
             NEXT FIELD ofu09                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu10                                                       
          IF g_ofu.ofu10 < 0 OR g_ofu.ofu10 > 100 THEN   
             CALL cl_err(g_ofu.ofu10,'axm-986',0)                               
             NEXT FIELD ofu10                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu11                                                       
          IF g_ofu.ofu11 < 0 THEN   
             CALL cl_err(g_ofu.ofu11,'mfg5034',0)                               
             NEXT FIELD ofu11                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu12                                                       
          IF g_ofu.ofu12 < 0 OR g_ofu.ofu12 > 100 THEN   
             CALL cl_err(g_ofu.ofu12,'axm-986',0)                               
             NEXT FIELD ofu12                                                   
          END IF
                                                                                
        AFTER FIELD ofu13                                                       
          IF g_ofu.ofu13 < 0 THEN   
             CALL cl_err(g_ofu.ofu13,'mfg5034',0)                               
             NEXT FIELD ofu13                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofu14                                                       
          IF g_ofu.ofu14 < 0 OR g_ofu.ofu14 > 100 THEN   
             CALL cl_err(g_ofu.ofu14,'axm-986',0)                               
             NEXT FIELD ofu14                                                   
          END IF                                                                
#TQC-710115.....end
 
        AFTER INPUT
           LET g_ofu.ofuuser = s_get_data_owner("ofu_file") #FUN-C10039
           LET g_ofu.ofugrup = s_get_data_group("ofu_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ofs"
                 LET g_qryparam.default1 = g_ofu.ofu01
                 CALL cl_create_qry() RETURNING g_ofu.ofu01
#                 CALL FGL_DIALOG_SETBUFFER( g_ofu.ofu01 )
                 DISPLAY BY NAME g_ofu.ofu01
                 NEXT FIELD ofu01
              WHEN INFIELD(ofu02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_ofu.ofu02
                 CALL cl_create_qry() RETURNING g_ofu.ofu02
#                 CALL FGL_DIALOG_SETBUFFER( g_ofu.ofu02 )
                 DISPLAY BY NAME g_ofu.ofu02
                 NEXT FIELD ofu02
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
# END IF
END FUNCTION
 
FUNCTION i641_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i641_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i641_count
    FETCH i641_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i641_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)
        INITIALIZE g_ofu.* TO NULL
    ELSE
        CALL i641_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i641_fetch(p_flofu)
    DEFINE
        p_flofu         LIKE type_file.chr1          #No.FUN-680137  VARCHAR(1)
 
    CASE p_flofu
        WHEN 'N' FETCH NEXT     i641_cs INTO g_ofu.ofu01,g_ofu.ofu02
        WHEN 'P' FETCH PREVIOUS i641_cs INTO g_ofu.ofu01,g_ofu.ofu02
        WHEN 'F' FETCH FIRST    i641_cs INTO g_ofu.ofu01,g_ofu.ofu02
        WHEN 'L' FETCH LAST     i641_cs INTO g_ofu.ofu01,g_ofu.ofu02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i641_cs
                  INTO g_ofu.ofu01,g_ofu.ofu02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)
        INITIALIZE g_ofu.* TO NULL              #No.FUN-6A0020
        RETURN
    ELSE
       CASE p_flofu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofu.* FROM ofu_file             # 重讀DB,因TEMP有不被更新特性
       WHERE ofu01 = g_ofu.ofu01 AND ofu02=g_ofu.ofu02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ofu_file",g_ofu.ofu01,g_ofu.ofu02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofu.* TO NULL             #FUN-4C0057 add
    ELSE
        LET g_data_owner = g_ofu.ofuuser      #FUN-4C0057
        LET g_data_group = g_ofu.ofugrup      #FUN-4C0057
        LET g_data_plant = g_ofu.ofuplant #FUN-980030
        CALL i641_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i641_show()
    DEFINE l_ofs02         LIKE ofs_file.ofs02,
           l_occ02         LIKE occ_file.occ02
 
    LET g_ofu_t.* = g_ofu.*
    DISPLAY BY NAME g_ofu.ofuoriu,g_ofu.ofuorig,
        g_ofu.ofu01,g_ofu.ofu02,g_ofu.ofu03,g_ofu.ofu04,g_ofu.ofu05,
        g_ofu.ofu06,g_ofu.ofu07,g_ofu.ofu08,g_ofu.ofu09,g_ofu.ofu10,
        g_ofu.ofu11,g_ofu.ofu12,g_ofu.ofu13,g_ofu.ofu14,
        g_ofu.ofuuser,g_ofu.ofugrup,g_ofu.ofumodu,g_ofu.ofudate
    SELECT ofs02 INTO l_ofs02 FROM ofs_file WHERE ofs01 = g_ofu.ofu01
    DISPLAY l_ofs02 TO FORMONLY.ofs02
    SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_ofu.ofu02
    DISPLAY l_occ02 TO FORMONLY.occ02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i641_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ofu.ofu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ofu.* FROM ofu_file
     WHERE ofu01=g_ofu.ofu01 AND ofu02=g_ofu02
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofu01_t = g_ofu.ofu01
    LET g_ofu02_t = g_ofu.ofu02
    LET g_ofu_o.*=g_ofu.*
    BEGIN WORK
 
    OPEN i641_cl USING g_ofu.ofu01,g_ofu.ofu02
    IF STATUS THEN
       CALL cl_err("OPEN i641_cl:", STATUS, 1)  
       CLOSE i641_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i641_cl INTO g_ofu.*                # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofu.ofumodu=g_user                     #修改者
    LET g_ofu.ofudate = g_today                  #修改日期
    CALL i641_show()                             # 顯示最新資料
    WHILE TRUE
        LET g_ofu_t.*=g_ofu.*
        CALL i641_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofu.*=g_ofu_t.*
            CALL i641_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofu_file SET ofu_file.* = g_ofu.*    # 更新DB
            WHERE ofu01 = g_ofu_t.ofu01 AND ofu02=g_ofu_t.ofu02               # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofu_file",g_ofu01_t,g_ofu02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i641_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i641_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofu.ofu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i641_cl USING g_ofu.ofu01,g_ofu.ofu02
    IF STATUS THEN
       CALL cl_err("OPEN i641_cl:", STATUS, 1)
       CLOSE i641_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i641_cl INTO g_ofu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i641_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ofu02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofu.ofu01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ofu.ofu02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ofu_file WHERE ofu01 = g_ofu.ofu01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_ofu.ofu01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","ofu_file",g_ofu.ofu01,g_ofu.ofu02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       ELSE
          CLEAR FORM
          INITIALIZE g_ofu.* TO NULL
          OPEN i641_count
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE i641_cs
             CLOSE i641_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH i641_count INTO g_row_count
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i641_cs
             CLOSE i641_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i641_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i641_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i641_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i641_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i641_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofu01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i641_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofu01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

