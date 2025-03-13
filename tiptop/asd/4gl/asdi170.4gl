# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdi170.4gl
# Descriptions...: 差異分攤維護作業
# Date & Author..: 99/10/10
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-960343 09/06/23 By hongmei mark NEXT OPTION "next"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_stw   RECORD LIKE stw_file.*,
    g_gem   RECORD LIKE gem_file.*,
    g_stw_t RECORD LIKE stw_file.*,
    g_stw01_t LIKE stw_file.stw01,
    g_stw02_t LIKE stw_file.stw02,
     g_wc,g_sql          string #No.FUN-580092 HCN
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5     #No.FUN-690010 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0089
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
    INITIALIZE g_stw.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM stw_file WHERE stw01=? AND stw02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i170_cl CURSOR FROM g_forupd_sql          # LOCK CURSOR
    LET p_row = 3 LET p_col = 12
    OPEN WINDOW i170_w AT p_row,p_col
        WITH FORM "asd/42f/asdi170"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i170_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i170_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION i170_curs()
    CLEAR FORM
   INITIALIZE g_stw.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        stw01,stw02,stw03
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    LET g_sql="SELECT stw01,stw02 FROM stw_file ",
              " WHERE ",g_wc CLIPPED, " ORDER BY stw01,stw02 "
    PREPARE i170_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i170_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i170_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM stw_file WHERE ",g_wc CLIPPED
    PREPARE i170_cnt FROM g_sql
    DECLARE i170_count                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i170_cnt
 
END FUNCTION
 
FUNCTION i170_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i170_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i170_q()
            END IF
        #   NEXT OPTION "next"   #TQC-960343 mark
        ON ACTION next
            CALL i170_fetch('N')
        ON ACTION previous
            CALL i170_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i170_u()
            END IF
        #   NEXT OPTION "next"   #TQC-960343 mark
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i170_r()
            END IF
        #   NEXT OPTION "next"   #TQC-960343 mark
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i170_fetch('/')
        ON ACTION first
            CALL i170_fetch('F')
        ON ACTION last
            CALL i170_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_stw.stw01 IS NOT NULL THEN
                  LET g_doc.column1 = "stw01"
                  LET g_doc.value1 = g_stw.stw01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0150-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i170_cs
END FUNCTION
 
 
FUNCTION i170_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_stw.* LIKE stw_file.*
    LET g_stw01_t = NULL
    LET g_stw02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i170_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_stw.stw02 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO stw_file VALUES(g_stw.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_stw.stw02,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("ins","stw_file",g_stw.stw01,g_stw.stw02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        ELSE
            LET g_stw_t.* = g_stw.*                # 保存上筆資料
            SELECT stw01,stw02 INTO g_stw.stw01,g_stw.stw02 FROM stw_file
                WHERE stw02 = g_stw.stw02 AND stw01 = g_stw.stw01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i170_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_sfb05 LIKE sfb_file.sfb05,
        l_sfb82 LIKE sfb_file.sfb82,
        l_ima09 LIKE ima_file.ima09
 
    DISPLAY BY NAME
        g_stw.stw01,g_stw.stw02, g_stw.stw03
    INPUT BY NAME
        g_stw.stw01,g_stw.stw02, g_stw.stw03
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i170_set_entry(p_cmd)
          CALL i170_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD stw02
            IF g_stw.stw02 IS NOT NULL THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_stw.stw02 != g_stw02_t ) THEN
                   SELECT count(*) INTO l_n FROM stw_file
                    WHERE stw02 = g_stw.stw02 AND stw01=g_stw.stw01
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_stw.stw02,-239,0)
                       NEXT FIELD stw02
                   END IF
               END IF
            END IF
 
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
 
FUNCTION i170_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_stw.* TO NULL                #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i170_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i170_count
    FETCH i170_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i170_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stw.stw01,SQLCA.sqlcode,0)
        INITIALIZE g_stw.* TO NULL
    ELSE
        CALL i170_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i170_fetch(p_flstw)
    DEFINE
        p_flstw         LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flstw
        WHEN 'N' FETCH NEXT     i170_cs INTO g_stw.stw01,g_stw.stw02
        WHEN 'P' FETCH PREVIOUS i170_cs INTO g_stw.stw01,g_stw.stw02
        WHEN 'F' FETCH FIRST    i170_cs INTO g_stw.stw01,g_stw.stw02
        WHEN 'L' FETCH LAST     i170_cs INTO g_stw.stw01,g_stw.stw02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i170_cs INTO g_stw.stw01,g_stw.stw02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stw.stw01,SQLCA.sqlcode,0)
        INITIALIZE g_stw.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flstw
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_stw.* FROM stw_file            # 重讀DB,因TEMP有不被更新特性
       WHERE stw01=g_stw.stw01 AND stw02=g_stw.stw02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_stw.stw01,SQLCA.sqlcode,0)   #No.FUN-660120
        CALL cl_err3("sel","stw_file",g_stw.stw01,g_stw.stw02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
    ELSE
        CALL i170_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION i170_show()
    LET g_stw_t.* = g_stw.*
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_stw.*
    DISPLAY BY NAME g_stw.stw01,g_stw.stw02,g_stw.stw03
    #No.FUN-9A0024--end 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i170_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_stw.stw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_stw01_t = g_stw.stw01
    LET g_stw02_t = g_stw.stw02
    BEGIN WORK
    OPEN i170_cl USING g_stw.stw01,g_stw.stw02
    IF STATUS THEN
       CALL cl_err("OPEN i170_cl:", STATUS, 1)
       CLOSE i170_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i170_cl INTO g_stw.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stw.stw01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i170_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i170_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_stw.*=g_stw_t.*
            CALL i170_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE stw_file SET stw_file.* = g_stw.*    # 更新DB
            WHERE stw01=g_stw.stw01 AND stw02=g_stw.stw02             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_stw.stw01,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("upd","stw_file",g_stw01_t,g_stw02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i170_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i170_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_stw.stw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i170_cl USING g_stw.stw01,g_stw.stw02
    IF STATUS THEN
       CALL cl_err("OPEN i170_cl:", STATUS, 1)
       CLOSE i170_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i170_cl INTO g_stw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_stw.stw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i170_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "stw01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_stw.stw01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM stw_file WHERE stw02=g_stw.stw02 AND stw01=g_stw.stw01
       CLEAR FORM
       OPEN i170_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i170_cs
          CLOSE i170_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i170_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i170_cs
          CLOSE i170_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i170_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i170_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i170_fetch('/')
       END IF
    END IF
    CLOSE i170_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i170_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("stw01,stw02",TRUE)
  END IF
END FUNCTION
 
FUNCTION i170_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("stw01,stw02",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
