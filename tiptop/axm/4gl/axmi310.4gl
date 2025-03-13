# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi310.4gl
# Descriptions...: 工作中心資料維護
# Date & Author..: 00/03/04 By Melody
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-530337 05/03/31 By Mandy 執行複製時, 無法連續執行複製.
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740269 07/04/25 By bnlent 匯率不可為負
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.TQC-930103 09/03/13 By chenyu 無效的資料不可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0025 10/11/03 By chenying 新增時资料建立者，资料建立部门栏位值未顯示
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B80190 11/08/26 By lixia 查詢欄位
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_oqf   RECORD LIKE oqf_file.*,
    g_oqf_t RECORD LIKE oqf_file.*,
    g_oqf01_t LIKE oqf_file.oqf01,
     g_wc,g_sql        STRING   #No.FUN-580092 HCN  
 
DEFINE   g_forupd_sql  STRING      #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done   STRING
 
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0094
 
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
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_oqf.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM oqf_file WHERE oqf01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 5 LET p_col = 10
 
    OPEN WINDOW i310_w AT p_row,p_col
        WITH FORM "axm/42f/axmi310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i310_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i310_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i310_curs()
    CLEAR FORM
   INITIALIZE g_oqf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        oqf01,oqf02,oqf03,oqfuser,oqfgrup,oqfmodu,oqfdate,oqfacti
        ,oqforiu,oqforig  #TQC-B80190
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(oqf01)
                CALL q_eca(TRUE,TRUE,g_oqf.oqf01) RETURNING g_oqf.oqf01
                DISPLAY BY NAME g_oqf.oqf01
                NEXT FIELD oqf01
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND oqfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND oqfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND oqfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oqfuser', 'oqfgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT oqf01 FROM oqf_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY oqf01"
    PREPARE i310_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i310_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i310_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM oqf_file WHERE ",g_wc CLIPPED
    PREPARE i310_precount FROM g_sql
    DECLARE i310_count CURSOR FOR i310_precount
END FUNCTION
 
FUNCTION i310_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i310_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i310_q()
            END IF
        ON ACTION next
            CALL i310_fetch('N')
        ON ACTION previous
            CALL i310_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i310_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i310_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i310_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i310_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i310_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i310_fetch('/')
        ON ACTION first
            CALL i310_fetch('F')
        ON ACTION last
            CALL i310_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-6A0020-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_oqf.oqf01 IS NOT NULL THEN
               LET g_doc.column1 = "oqf01"
               LET g_doc.value1 = g_oqf.oqf01
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
    CLOSE i310_cs
END FUNCTION
 
 
FUNCTION i310_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_oqf.* LIKE oqf_file.*
    LET g_oqf01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_oqf.oqfuser = g_user
        LET g_oqf.oqforiu = g_user #FUN-980030
        LET g_oqf.oqforig = g_grup #FUN-980030
        LET g_oqf.oqfgrup = g_grup               #使用者所屬群
        LET g_oqf.oqfdate = g_today
        LET g_oqf.oqfacti = 'Y'
        CALL i310_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_oqf.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_oqf.oqf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO oqf_file VALUES(g_oqf.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","oqf_file",g_oqf.oqf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
            SELECT oqf01 INTO g_oqf.oqf01 FROM oqf_file
                     WHERE oqf01 = g_oqf.oqf01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i310_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)
        l_eca02         LIKE eca_file.eca02,
        l_n             LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    DISPLAY BY NAME
        g_oqf.oqf01,g_oqf.oqf02,g_oqf.oqf03,
        g_oqf.oqfuser,g_oqf.oqfgrup,g_oqf.oqfmodu,g_oqf.oqfdate,g_oqf.oqfacti
    INPUT BY NAME
        g_oqf.oqf01,g_oqf.oqf02,g_oqf.oqf03,
        g_oqf.oqfuser,g_oqf.oqfgrup,g_oqf.oqfmodu,g_oqf.oqfdate,g_oqf.oqfacti
        ,g_oqf.oqforiu,g_oqf.oqforig     #TQC-AB0025 add 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i310_set_entry(p_cmd)
           CALL i310_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD oqf01
          IF g_oqf.oqf01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_oqf.oqf01 != g_oqf01_t) THEN
                SELECT count(*) INTO l_n FROM oqf_file
                    WHERE oqf01 = g_oqf.oqf01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_oqf.oqf01,-239,0)
                    LET g_oqf.oqf01 = g_oqf01_t
                    DISPLAY BY NAME g_oqf.oqf01
                    NEXT FIELD oqf01
                END IF
                SELECT eca02 INTO l_eca02
                    FROM eca_file
                    WHERE eca01=g_oqf.oqf01
                IF SQLCA.sqlcode THEN
                    #CALL cl_err(g_oqf.oqf01,'axm-070',3) #No.+045 010410 by plum   
#                  CALL cl_err(g_oqf.oqf01,'aec-802',3)   #No.FUN-660167
                   CALL cl_err3("sel","eca_file",g_oqf.oqf01,"","aec-802","","",1)  #No.FUN-660167
                    LET g_oqf.oqf01 = g_oqf01_t
                    DISPLAY BY NAME g_oqf.oqf01
                    NEXT FIELD oqf01
                END IF
                DISPLAY l_eca02 TO FORMONLY.eca02
            END IF
          END IF
      
        #No.TQC-740269  --Begin
        AFTER FIELD oqf02
          IF NOT cl_null(g_oqf.oqf02) THEN 
             IF g_oqf.oqf02 < 0 THEN 
                CALL cl_err(g_oqf.oqf02,"mfg4012",0)
                NEXT FIELD oqf02
             END IF 
          END IF    
 
        AFTER FIELD oqf03
          IF NOT cl_null(g_oqf.oqf03) THEN 
             IF g_oqf.oqf03 < 0 THEN 
                CALL cl_err(g_oqf.oqf03,"mfg4012",0)
                NEXT FIELD oqf03
             END IF 
          END IF    
       #No.TQC-740269  --End
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(oqf01)
                CALL q_eca(FALSE,FALSE,g_oqf.oqf01) RETURNING g_oqf.oqf01
                DISPLAY BY NAME g_oqf.oqf01
                NEXT FIELD oqf01
              OTHERWISE
                EXIT CASE
            END CASE
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(oqf01) THEN
       #         LET g_oqf.* = g_oqf_t.*
       #         CALL i310_show()
       #         NEXT FIELD oqf01
       #     END IF
       #MOD-650015 --end
 
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
END FUNCTION
 
FUNCTION i310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oqf.* TO NULL                #No.FUN-6A0020
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i310_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i310_count
    FETCH i310_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)
        INITIALIZE g_oqf.* TO NULL
    ELSE
        CALL i310_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i310_fetch(p_floqf)
    DEFINE
        p_floqf        LIKE type_file.chr1        #No.FUN-680137 VARCHAR(1) 
 
    CASE p_floqf
        WHEN 'N' FETCH NEXT     i310_cs INTO g_oqf.oqf01
        WHEN 'P' FETCH PREVIOUS i310_cs INTO g_oqf.oqf01
        WHEN 'F' FETCH FIRST    i310_cs INTO g_oqf.oqf01
        WHEN 'L' FETCH LAST     i310_cs INTO g_oqf.oqf01
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
            FETCH ABSOLUTE g_jump i310_cs INTO g_oqf.oqf01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)
        INITIALIZE g_oqf.* TO NULL  #TQC-6B0105
        LET g_oqf.oqf01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_floqf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_oqf.* FROM oqf_file            # 重讀DB,因TEMP有不被更新特性
     WHERE oqf01 = g_oqf.oqf01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","oqf_file",g_oqf.oqf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_oqf.* TO NULL            #FUN-4C0057 add
    ELSE
        LET g_data_owner = g_oqf.oqfuser      #FUN-4C0057 add
        LET g_data_group = g_oqf.oqfgrup      #FUN-4C0057 add
        CALL i310_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i310_show()
    DEFINE l_eca02        LIKE eca_file.eca02
 
    LET g_oqf_t.* = g_oqf.*
    #No.FUN-9A0024--begin     
    #DISPLAY BY NAME g_oqf.*                
    DISPLAY BY NAME  g_oqf.oqf01,g_oqf.oqf02,g_oqf.oqf03,g_oqf.oqfuser,g_oqf.oqfgrup,g_oqf.oqfmodu,
                     g_oqf.oqfdate,g_oqf.oqfacti,g_oqf.oqforiu,g_oqf.oqforig              
    #No.FUN-9A0024--end      
    SELECT eca02 INTO l_eca02
           FROM eca_file
           WHERE eca01=g_oqf.oqf01
    DISPLAY l_eca02 TO FORMONLY.eca02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i310_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_oqf.oqf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_oqf.* FROM oqf_file WHERE oqf01=g_oqf.oqf01
    IF g_oqf.oqfacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_oqf01_t = g_oqf.oqf01
    BEGIN WORK
 
    OPEN i310_cl USING g_oqf.oqf01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_oqf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_oqf.oqfmodu=g_user                     #修改者
    LET g_oqf.oqfdate = g_today                  #修改日期
    CALL i310_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i310_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oqf.*=g_oqf_t.*
            CALL i310_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE oqf_file SET oqf_file.* = g_oqf.*    # 更新DB
            WHERE oqf01 = g_oqf.oqf01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","oqf_file",g_oqf01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i310_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i310_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_oqf.oqf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i310_cl USING g_oqf.oqf01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_oqf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i310_show()
    IF cl_exp(0,0,g_oqf.oqfacti) THEN
        LET g_chr=g_oqf.oqfacti
        IF g_oqf.oqfacti='Y' THEN
            LET g_oqf.oqfacti='N'
        ELSE
            LET g_oqf.oqfacti='Y'
        END IF
        UPDATE oqf_file
            SET oqfacti=g_oqf.oqfacti
            WHERE oqf01=g_oqf.oqf01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","oqf_file",g_oqf.oqf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_oqf.oqfacti=g_chr
        END IF
        DISPLAY BY NAME g_oqf.oqfacti
    END IF
    CLOSE i310_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i310_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_oqf.oqf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i310_cl USING g_oqf.oqf01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_oqf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)
       RETURN
    END IF
    #No.TQC-930103 add --begin
    IF g_oqf.oqfacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
    #No.TQC-930103 add --end
    CALL i310_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oqf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oqf.oqf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM oqf_file WHERE oqf01 = g_oqf.oqf01
       CLEAR FORM
       INITIALIZE g_oqf.* TO NULL
       OPEN i310_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i310_cs
          CLOSE i310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i310_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i310_cs
          CLOSE i310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i310_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i310_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i310_fetch('/')
       END IF
    END IF
    CLOSE i310_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i310_copy()
    DEFINE
        l_newno         LIKE oqf_file.oqf01,
        l_oldno         LIKE oqf_file.oqf01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_oqf.oqf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
     CALL cl_set_comp_entry("oqf01",TRUE) #MOD-530337
    INPUT l_newno FROM oqf01
        #BEFORE INPUT #MOD-530337
         # LET g_before_input_done = FALSE
         # CALL i310_set_entry("a")
         # CALL i310_set_no_entry("a")
         # LET g_before_input_done = TRUE
         # CALL cl_set_comp_entry("oqf01",TRUE)
 
        AFTER FIELD oqf01
          IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM oqf_file
                WHERE oqf01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD oqf01
            END IF
                SELECT eca01
                    FROM eca_file
                    WHERE eca01= l_newno
                IF SQLCA.sqlcode THEN
                    DISPLAY BY NAME g_oqf.oqf01
                    LET l_newno = NULL
                    NEXT FIELD oqf01
                END IF
          END IF
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(oqf01)
                CALL q_eca(FALSE,FALSE,l_newno) RETURNING l_newno
                DISPLAY l_newno TO oqf01
                NEXT FIELD oqf01
               OTHERWISE
                    EXIT CASE
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_oqf.oqf01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM oqf_file
        WHERE oqf01=g_oqf.oqf01
        INTO TEMP x
    UPDATE x
        SET oqf01=l_newno,    #資料鍵值
            oqfacti='Y',      #資料有效碼
            oqfuser=g_user,   #資料所有者
            oqfgrup=g_grup,   #資料所有者所屬群
            oqfmodu=NULL,     #資料修改日期
            oqfdate=g_today   #資料建立日期
    INSERT INTO oqf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_oqf.oqf01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("ins","oqf_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_oqf.oqf01
        LET g_oqf.oqf01 = l_newno
        SELECT oqf_file.* INTO g_oqf.* FROM oqf_file
               WHERE oqf01 = l_newno
        CALL i310_u()
        #SELECT oqf_file.* INTO g_oqf.* FROM oqf_file  #FUN-C80046
        #       WHERE oqf01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_oqf.oqf01 = l_oldno                         #FUN-C80046
    CALL i310_show()
END FUNCTION
#No.FUN-7C0043--start-- 
FUNCTION i310_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_oqf           RECORD LIKE oqf_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_name          LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680137 VARCHAR(20)
        sr RECORD
        			oqf01 LIKE oqf_file.oqf01,
        			oqf02 LIKE oqf_file.oqf02,
        			oqf03 LIKE oqf_file.oqf03,
        			eca02 LIKE eca_file.eca02
           END RECORD,
           l_za05          LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(40)
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
    IF cl_null(g_wc) AND NOT cl_null(g_oqf.oqf01) THEN                                                                              
       LET g_wc=" oqf01='",g_oqf.oqf01,"' "                                                                                         
    END IF                                                                                                                          
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                     
    LET l_cmd = 'p_query "axmi310" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN 
#   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT oqf01,oqf02,oqf03,eca02 ",
#             "  FROM oqf_file LEFT OUTER JOIN eca_file ON oqf_file.oqf01=eca_file.eca01 ",
#             " WHERE  ",g_wc CLIPPED
#   PREPARE i310_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i310_curo                         # CURSOR
#       CURSOR FOR i310_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi310') RETURNING l_name         #FUN-4C0096 add
#   START REPORT i310_rep TO l_name
 
#   FOREACH i310_curo INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i310_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i310_rep
 
#   CLOSE i310_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i310_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,        #No.FUN-680137 VARCHAR(1)
#       sr RECORD
#       			oqf01 LIKE oqf_file.oqf01,
#       			oqf02 LIKE oqf_file.oqf02,
#       			oqf03 LIKE oqf_file.oqf03,
#       			eca02 LIKE eca_file.eca02
#          END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oqf01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''    #No.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31],
#                 g_x[32],
#                 g_x[33],
#                 g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.oqf01,
#                 COLUMN g_c[32],sr.eca02,
#                 COLUMN g_c[33],sr.oqf02 USING '##########&.&&',
#                 COLUMN g_c[34],sr.oqf03 USING '##########&.&&'
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-6A0091
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-6A0091
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
 
FUNCTION i310_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oqf01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i310_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oqf01",FALSE)
  END IF
END FUNCTION
 
 
