# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmt110.4gl
# Descriptions...: 支票作廢維護作業
# Date & Author..: 98/06/29 By Danny
# Modify.........: 99/08/04 By Carol:如由應付票據作廢產生則不可清除
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730081 07/03/21 By Smapmin 按更改出現錯誤訊息無法離開
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nnz       RECORD LIKE nnz_file.*,
    g_nnz_t     RECORD LIKE nnz_file.*,
    g_wc,g_sql  STRING,       #No.FUN-580092 HCN        
    g_buf       LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
 
DEFINE g_forupd_sql STRING    #SELECT ... FOR UPDATE SQL        
DEFINE g_before_input_done   STRING    
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680107 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0082
    DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    INITIALIZE g_nnz.* TO NULL
    INITIALIZE g_nnz_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM nnz_file WHERE nnz01 = ? AND nnz02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 13
    OPEN WINDOW t110_w AT p_row,p_col
        WITH FORM "anm/42f/anmt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t110_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t110_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t110_cs()
    CLEAR FORM
   INITIALIZE g_nnz.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                      nnz01,nnz02,nnz03,nnzuser,nnzgrup,nnzmodu,nnzdate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(nnz01) #銀行
#                 CALL q_nma(0,0,g_nnz.nnz01) RETURNING g_nnz.nnz01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nnz.nnz01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnz01
                  NEXT FIELD nnz01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnzuser', 'nnzgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT nnz01,nnz02 FROM nnz_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED," ORDER BY nnz01,nnz02"
    PREPARE t110_pre FROM g_sql           # RUNTIME 編譯
    DECLARE t110_cs                       # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t110_pre
    LET g_sql="SELECT COUNT(*) FROM nnz_file WHERE ",g_wc CLIPPED
    PREPARE t110_precount FROM g_sql
    DECLARE t110_count CURSOR FOR t110_precount
END FUNCTION
 
FUNCTION t110_menu()
    MESSAGE ''
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
        ON ACTION next  CALL t110_fetch('N')
        ON ACTION previous  CALL t110_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t110_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t110_r()
            END IF
        ON ACTION help  CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL t110_fetch('/')
        ON ACTION first CALL t110_fetch('F')
        ON ACTION last CALL t110_fetch('L')
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0011--------add----------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_nnz.nnz01 IS NOT NULL THEN            
                  LET g_doc.column1 = "nnz01"               
                  LET g_doc.column2 = "nnz02"               
                  LET g_doc.value1 = g_nnz.nnz01            
                  LET g_doc.value2 = g_nnz.nnz02           
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
        #No.FUN-6A0011--------add----------end----
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t110_cs
END FUNCTION
 
 
FUNCTION t110_a()
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_nnz.* LIKE nnz_file.*
    LET g_nnz.nnzuser = g_user
    LET g_nnz.nnzoriu = g_user #FUN-980030
    LET g_nnz.nnzorig = g_grup #FUN-980030
    LET g_nnz.nnzgrup = g_grup
    LET g_nnz.nnzdate = g_today
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t110_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_nnz.nnz01) OR cl_null(g_nnz.nnz02) THEN   # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO nnz_file VALUES(g_nnz.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_nnz.nnz01,SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("ins","nnz_file",g_nnz.nnz01,g_nnz.nnz02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           CONTINUE WHILE
        ELSE
           LET g_nnz_t.* = g_nnz.*                # 保存上筆資料
           SELECT nnz01,nnz02 INTO g_nnz.nnz01,g_nnz.nnz02 FROM nnz_file
            WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t110_i(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
           l_cnt    LIKE type_file.num5,          #No.FUN-680107 SMALLINT
           l_buf    LIKE type_file.chr6,          #No.FUN-680107 VARCHAR(6)
           l_mxno   LIKE cre_file.cre08,          #No.FUN-680107 VARCHAR(4)
           l_nnz01  LIKE nnz_file.nnz01           #No.FUN-680107 VARCHAR(8)
 
    INPUT BY NAME g_nnz.nnz01,g_nnz.nnz02,g_nnz.nnz03,g_nnz.nnzuser, g_nnz.nnzoriu,g_nnz.nnzorig,
                  g_nnz.nnzgrup,g_nnz.nnzmodu,g_nnz.nnzdate
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t110_set_entry(p_cmd)
            CALL t110_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE FIELD nnz01,nnz02
           IF p_cmd = 'u' AND g_chkey = 'Y' THEN
              SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file,nmd_file
               WHERE npl03 = '9'
                 AND npl01 = npm01
                 AND npm03 = nmd01
                 AND nmd02 = g_nnz.nnz02
                 AND nmd03 = g_nnz.nnz01
              IF g_cnt > 0 THEN NEXT FIELD nnz03 END IF
           END IF
 
        AFTER FIELD nnz01
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_chkey = 'Y') THEN    #TQC-730081
              IF NOT cl_null(g_nnz.nnz01) THEN
                 SELECT COUNT(*) INTO l_cnt FROM nmw_file WHERE nmw01 = g_nnz.nnz01
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_nnz.nnz01,'anm-029',1) NEXT FIELD nnz01
                 END IF
                 SELECT nma03 INTO g_buf FROM nma_file WHERE nma01 = g_nnz.nnz01
                 IF STATUS THEN
#                   CALL cl_err('sel nma',STATUS,1)    #No.FUN-660148
                    CALL cl_err3("sel","nma_file",g_nnz.nnz01,"",STATUS,"","sel nma",1)  #No.FUN-660148
                    NEXT FIELD nnz01
                 END IF
                 DISPLAY g_buf TO nma03
              END IF
           END IF   #TQC-730081
 
        AFTER FIELD nnz02
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_chkey = 'Y') THEN    #TQC-730081
              IF NOT cl_null(g_nnz.nnz02) THEN
                 #已開立之支票不可作廢
                 SELECT COUNT(*) INTO l_cnt FROM nmd_file
                  WHERE nmd02 = g_nnz.nnz02 AND nmd30 <> 'X'
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_nnz.nnz02,'anm-150',1) NEXT FIELD nnz02
                 END IF
                 SELECT COUNT(*) INTO l_cnt FROM nmw_file
                  WHERE nmw01 = g_nnz.nnz01
                    AND nmw04 <= g_nnz.nnz02 AND nmw05 >= g_nnz.nnz02
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_nnz.nnz02,'anm-084',1) NEXT FIELD nnz02
                 END IF
                 IF p_cmd = 'a' OR
                   (p_cmd = 'u' AND (g_nnz.nnz01 != g_nnz_t.nnz01 OR
                    g_nnz.nnz02 != g_nnz_t.nnz02 )) THEN
                    SELECT COUNT(*) INTO l_cnt FROM nnz_file
                     WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02
                    IF l_cnt > 0 THEN
                       CALL cl_err(g_nnz.nnz02,'-239',1)
                       LET g_nnz.nnz02 = g_nnz_t.nnz02
                       DISPLAY BY NAME g_nnz.nnz02
                       NEXT FIELD nnz02
                    END IF
                 END IF
              END IF
          END IF   #TQC-730081
 
        AFTER INPUT
           LET g_nnz.nnzuser = s_get_data_owner("nnz_file") #FUN-C10039
           LET g_nnz.nnzgrup = s_get_data_group("nnz_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #   IF INFIELD(nnz01) THEN
        #      LET g_nnz.* = g_nnz_t.*
        #      DISPLAY BY NAME g_nnz.*
        #      NEXT FIELD nnz01
        #   END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nnz01) #銀行
#                 CALL q_nma(0,0,g_nnz.nnz01) RETURNING g_nnz.nnz01
#                 CALL FGL_DIALOG_SETBUFFER( g_nnz.nnz01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.default1 = g_nnz.nnz01
                  CALL cl_create_qry() RETURNING g_nnz.nnz01
#                  CALL FGL_DIALOG_SETBUFFER( g_nnz.nnz01 )
                  DISPLAY BY NAME g_nnz.nnz01
                  NEXT FIELD nnz01
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
END FUNCTION
 
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nnz.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t110_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t110_count
    FETCH t110_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nnz.nnz01,SQLCA.sqlcode,0)
       INITIALIZE g_nnz.* TO NULL
    ELSE
       CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t110_fetch(p_flnnz)
    DEFINE
        p_flnnz         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    CASE p_flnnz
      WHEN 'N' FETCH NEXT     t110_cs INTO g_nnz.nnz01,g_nnz.nnz02
      WHEN 'P' FETCH PREVIOUS t110_cs INTO g_nnz.nnz01,g_nnz.nnz02
      WHEN 'F' FETCH FIRST    t110_cs INTO g_nnz.nnz01,g_nnz.nnz02
      WHEN 'L' FETCH LAST     t110_cs INTO g_nnz.nnz01,g_nnz.nnz02
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
            FETCH ABSOLUTE g_jump t110_cs INTO g_nnz.nnz01,g_nnz.nnz02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnz.nnz01,SQLCA.sqlcode,0)
        INITIALIZE g_nnz.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnnz
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_nnz.* FROM nnz_file            # 重讀DB,因TEMP有不被更新特性
     WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_nnz.nnz01,SQLCA.sqlcode,0)   #No.FUN-660148
       CALL cl_err3("sel","nnz_file",g_nnz.nnz01,g_nnz.nnz02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_nnz.nnzuser     #No.FUN-4C0063
       LET g_data_group = g_nnz.nnzgrup     #No.FUN-4C0063
       CALL t110_show()                           # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t110_show()
    LET g_nnz_t.* = g_nnz.*
    DISPLAY BY NAME g_nnz.nnz01,g_nnz.nnz02,g_nnz.nnz03,g_nnz.nnzuser, g_nnz.nnzoriu,g_nnz.nnzorig,
                    g_nnz.nnzgrup,g_nnz.nnzmodu,g_nnz.nnzdate
    SELECT nma03 INTO g_buf FROM nma_file WHERE nma01 = g_nnz.nnz01
    DISPLAY g_buf TO nma03
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_u()
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_nnz.* FROM nnz_file WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02
    IF cl_null(g_nnz.nnz01) OR cl_null(g_nnz.nnz02) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nnz_t.* =g_nnz.*
    BEGIN WORK
    OPEN t110_cl USING g_nnz.nnz01,g_nnz.nnz02
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_nnz.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_nnz.nnz01,STATUS,0) RETURN END IF
    CALL t110_show()                          # 顯示最新資料
    LET g_nnz.nnzmodu = g_user
    LET g_nnz.nnzdate = g_today
    WHILE TRUE
        CALL t110_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_nnz.*=g_nnz_t.*
           CALL t110_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE nnz_file SET nnz_file.* = g_nnz.*    # 更新DB
         WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err('(t110_u:nnz)',SQLCA.sqlcode,1)   #No.FUN-660148
           CALL cl_err3("upd","nnz_file",g_nnz_t.nnz01,g_nnz_t.nnz02,SQLCA.sqlcode,"","(t110_u:nnz)",1)  #No.FUN-660148
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t110_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t110_r()
  DEFINE l_n   LIKE type_file.num5          #No.FUN-680107 SMALLINT
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_nnz.* FROM nnz_file WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02
    IF cl_null(g_nnz.nnz01) OR cl_null(g_nnz.nnz02) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM nmd_file   #check是否由應付票據轉入
     WHERE nmd03=g_nnz.nnz01 AND nmd02=g_nnz.nnz02 AND nmd30 <> 'X'
    IF l_n > 0 THEN
       CALL cl_err('sel_nmd','anm-070',0)  RETURN END IF
    BEGIN WORK
    OPEN t110_cl USING g_nnz.nnz01,g_nnz.nnz02
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_nnz.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nnz.nnz01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t110_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nnz01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "nnz02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nnz.nnz01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_nnz.nnz02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM nnz_file WHERE nnz01 = g_nnz.nnz01 AND nnz02 = g_nnz.nnz02
       IF SQLCA.sqlcode THEN
#         CALL cl_err('(t110_r:delete nnz)',SQLCA.sqlcode,1)   #No.FUN-660148
          CALL cl_err3("del","nnz_file",g_nnz.nnz01,g_nnz.nnz02,SQLCA.sqlcode,"","(t110_r:delete nnz)",1)  #No.FUN-660148
       END IF
       CLEAR FORM
       OPEN t110_count
       FETCH t110_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t110_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t110_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t110_fetch('/')
       END IF
    END IF
    CLOSE t110_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nnz01,nnz02",TRUE)
   END IF
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nnz01,nnz02",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #

