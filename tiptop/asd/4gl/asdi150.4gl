# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asdi150.4gl
# Descriptions...: 在製工單成本調整作業
# Date & Author..: 99/07/06 By Eric
# Modify.........: NO.FUN-550066 05/05/24 By vivien 單據編號加大
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770001 07/07/02 By sherry 點擊"幫助"按鈕無效
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-960180 09/06/22 By mike 將NEXT OPTION "next"拿掉.
# Modify.........: No.FUN-980008 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_stj   RECORD LIKE stj_file.*,
    g_stj_t RECORD LIKE stj_file.*,
    g_stj01_t LIKE stj_file.stj01,
    g_stj02_t LIKE stj_file.stj02,
    g_stj03_t LIKE stj_file.stj03,
     g_wc,g_sql          string  #No.FUN-580092 HCN
 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
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
    INITIALIZE g_stj.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM stj_file WHERE stj01=? AND stj02=? AND stj03=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_cl CURSOR FROM g_forupd_sql 
    LET p_row = 3 LET p_col = 10
    OPEN WINDOW i150_w AT p_row,p_col
        WITH FORM "asd/42f/asdi150" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i150_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i150_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION i150_curs()
    CLEAR FORM
   INITIALIZE g_stj.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        stj01,stj02,stj03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(stj03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb01"
                LET g_qryparam.state= "c"
                LET g_qryparam.default1 = g_stj.stj03
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO stj03
                NEXT FIELD stj03
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    LET g_sql="SELECT stj01,stj02,stj03 FROM stj_file ", 
              " WHERE ",g_wc CLIPPED, " ORDER BY stj01,stj02,stj03 "
    PREPARE i150_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i150_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i150_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM stj_file WHERE ",g_wc CLIPPED
    PREPARE i150_pre FROM g_sql
    DECLARE i150_count CURSOR FOR i150_pre
END FUNCTION
 
FUNCTION i150_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i150_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i150_q()
            END IF
           #NEXT OPTION "next"  #TQC-960180
        ON ACTION next 
            CALL i150_fetch('N') 
        ON ACTION previous 
            CALL i150_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i150_u()
            END IF
           #NEXT OPTION "next" #TQC-960180
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i150_r()
            END IF
           #NEXT OPTION "next" #TQC-960180
        ON ACTION help                 #No.TQC-770001
            CALL cl_show_help()        #No.TQC-770001  
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i150_fetch('/')
        ON ACTION first
            CALL i150_fetch('F')
        ON ACTION last
            CALL i150_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_stj.stj01 IS NOT NULL THEN
                  LET g_doc.column1 = "stj01"
                  LET g_doc.value1 = g_stj.stj01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0150-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i150_cs
END FUNCTION
 
 
FUNCTION i150_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_stj.* LIKE stj_file.*
    LET g_stj01_t = NULL
    LET g_stj02_t = NULL
    LET g_stj03_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i150_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_stj.stj01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_stj.stj02 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_stj.stj03 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_stj.stj04 IS NULL THEN LET g_stj.stj04=0 END IF
        IF g_stj.stj05 IS NULL THEN LET g_stj.stj05=0 END IF
        IF g_stj.stj06 IS NULL THEN LET g_stj.stj06=0 END IF
        IF g_stj.stj07 IS NULL THEN LET g_stj.stj07=0 END IF
        IF g_stj.stj08 IS NULL THEN LET g_stj.stj08=0 END IF
 
        LET g_stj.stjplant=g_plant #FUN-980008 add
        LET g_stj.stjlegal=g_legal #FUN-980008 add
 
        INSERT INTO stj_file VALUES(g_stj.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("ins","stj_file",g_stj.stj01,g_stj.stj02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        ELSE
            LET g_stj_t.* = g_stj.*                # 保存上筆資料
            SELECT stj01,stj02,stj03 INTO g_stj.stj01,g_stj.stj02,g_stj.stj03 FROM stj_file
                WHERE stj01 = g_stj.stj01 AND stj02 = g_stj.stj02
                  AND stj03 = g_stj.stj03 
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i150_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_sfb05 LIKE sfb_file.sfb05,
        l_sfb82 LIKE sfb_file.sfb82,
        l_ima09 LIKE ima_file.ima09
 
    DISPLAY BY NAME
        g_stj.stj01,g_stj.stj02,g_stj.stj03,g_stj.stj04,g_stj.stj05,
        g_stj.stj06,g_stj.stj07,g_stj.stj08
        
    INPUT BY NAME
        g_stj.stj01,g_stj.stj02,g_stj.stj03,g_stj.stj04,g_stj.stj05,
        g_stj.stj06,g_stj.stj07,g_stj.stj08
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i150_set_entry(p_cmd)
          CALL i150_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
         #No.FUN-550066 --start--
          CALL cl_set_docno_format("stj03")
         #No.FUN-550066 ---end---
 
        AFTER FIELD stj02
            IF g_stj.stj02 < 1 OR g_stj.stj02 > 12 THEN
               NEXT FIELD stj02
            END IF
 
        AFTER FIELD stj03 
            IF g_stj.stj03 IS NOT NULL THEN
               SELECT * FROM sfb_file WHERE sfb01 = g_stj.stj03 AND sfb87!='X'
               IF STATUS <> 0 THEN
#No.MOD-580325-begin                                                           
#                 CALL cl_err('','aem-028',0)                                      #No.FUN-660120
                  CALL cl_err3("sel","sfb_file",g_stj.stj03,"","aem-028","","",1)  #No.FUN-660120
#                 ERROR '無此工單號碼!'                                         
#No.MOD-580325-end             
                  NEXT FIELD stj03
               END IF
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                 (g_stj.stj02 != g_stj02_t OR g_stj.stj01 !=g_stj01_t OR
                  g_stj.stj03 != g_stj03_t )) THEN
                   SELECT count(*) INTO l_n FROM stj_file
                    WHERE stj01 = g_stj.stj01 AND stj02 = g_stj.stj02
                      AND stj03 = g_stj.stj03
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_stj.stj02,-239,0)
                       LET g_stj.stj01 = g_stj01_t
                       LET g_stj.stj02 = g_stj02_t
                       LET g_stj.stj03 = g_stj03_t
                       DISPLAY BY NAME g_stj.stj03 
                       NEXT FIELD stj03
                   END IF
               END IF
            END IF
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(stj03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb01"
                LET g_qryparam.default1 = g_stj.stj03
                CALL cl_create_qry() RETURNING g_stj.stj03
#                CALL FGL_DIALOG_SETBUFFER( g_stj.stj03 )
                DISPLAY BY NAME g_stj.stj03
                NEXT FIELD stj03
               OTHERWISE
                    EXIT CASE
            END CASE
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(stj01) THEN
       #         LET g_stj.* = g_stj_t.*
       #         CALL i150_show()
       #         NEXT FIELD stj01
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
 
FUNCTION i150_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_stj.* TO NULL                #No.FUN-6A0150 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i150_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i150_count
    FETCH i150_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i150_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)
        INITIALIZE g_stj.* TO NULL
    ELSE
        CALL i150_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i150_fetch(p_flstj)
    DEFINE
        p_flstj         LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flstj
        WHEN 'N' FETCH NEXT     i150_cs INTO g_stj.stj01,g_stj.stj02,g_stj.stj03
        WHEN 'P' FETCH PREVIOUS i150_cs INTO g_stj.stj01,g_stj.stj02,g_stj.stj03
        WHEN 'F' FETCH FIRST    i150_cs INTO g_stj.stj01,g_stj.stj02,g_stj.stj03
        WHEN 'L' FETCH LAST     i150_cs INTO g_stj.stj01,g_stj.stj02,g_stj.stj03
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
            FETCH ABSOLUTE g_jump i150_cs INTO g_stj.stj01,g_stj.stj02,g_stj.stj03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)
        INITIALIZE g_stj.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flstj
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump 
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_stj.* FROM stj_file            # 重讀DB,因TEMP有不被更新特性
       WHERE stj01=g_stj.stj01 AND stj02=g_stj.stj02 AND stj03=g_stj.stj03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)   #No.FUN-660120
        CALL cl_err3("sel","stj_file",g_stj.stj01,g_stj.stj02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
    ELSE
        CALL i150_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i150_show()
    LET g_stj_t.* = g_stj.*
#   DISPLAY BY NAME g_stj.*  #FUN-980008 add
    DISPLAY BY NAME          #FUN-980008 add
       g_stj.stj01,g_stj.stj02,g_stj.stj03,g_stj.stj04,g_stj.stj05,
       g_stj.stj06,g_stj.stj07,g_stj.stj08
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i150_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_stj.stj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_stj01_t = g_stj.stj01
    LET g_stj02_t = g_stj.stj02
    LET g_stj03_t = g_stj.stj03
    BEGIN WORK
    OPEN i150_cl USING g_stj.stj01,g_stj.stj02,g_stj.stj03
    IF STATUS THEN
       CALL cl_err("OPEN i150_cl:", STATUS, 1)
       CLOSE i150_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)
        ROLLBACK WORK 
        RETURN
    END IF
    FETCH i150_cl INTO g_stj.*               # 對DB鎖定
    CALL i150_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i150_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_stj.*=g_stj_t.*
            CALL i150_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK 
            EXIT WHILE
        END IF
        UPDATE stj_file SET stj_file.* = g_stj.*    # 更新DB
            WHERE stj01=g_stj.stj01 AND stj02=g_stj.stj02 AND stj03=g_stj.stj03             # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("upd","stj_file",g_stj01_t,g_stj02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i150_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i150_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_stj.stj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i150_cl USING g_stj.stj01,g_stj.stj02,g_stj.stj03
    IF STATUS THEN
       CALL cl_err("OPEN i150_cl:", STATUS, 1)
       CLOSE i150_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_stj.stj01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       CLOSE i150_cl
       RETURN
    END IF
    FETCH i150_cl INTO g_stj.*
    CALL i150_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "stj01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_stj.stj01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM stj_file 
        WHERE stj01=g_stj.stj01 AND stj02=g_stj.stj02
          AND stj03=g_stj.stj03
       IF SQLCA.SQLCODE THEN 
#         CALL cl_err('',SQLCA.SQLCODE,0)   #No.FUN-660120
          CALL cl_err3("del","stj_file",g_stj.stj01,g_stj.stj02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
          ROLLBACK WORK
          CLOSE i150_cl
          RETURN
       ELSE
          CLEAR FORM 
          OPEN i150_count
          FETCH i150_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i150_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i150_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i150_fetch('/')
          END IF
       END IF 
    END IF
    CLOSE i150_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i150_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("stj01,stj02,stj03",TRUE)
  END IF
END FUNCTION
 
FUNCTION i150_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("stj01,stj02,stj03",FALSE)
  END IF
END FUNCTION
 
