# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apss306.4gl
# Descriptions...: APS伺服器參數設定(APS)
# Date & Author..: 97/08/28 #FUN-880112 By Duke 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50003 11/05/05 By Abby---GP5.25 追版---str----------------------
# Modify.........: NO.FUN-A10142 10/01/28 By Mandy TIPTOP/APS資料庫IP位址異動時,需同步通知APS
# Modify.........: FUN-B50003 11/05/05 By Abby---GP5.25 追版---end----------------------
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-CC0150 13/01/09 By Mandy 傳給APS時增加傳<code9> 此碼傳legal code(法人)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-840079
DEFINE g_vlm       RECORD LIKE vlm_file.*,
       g_vlm_t     RECORD LIKE vlm_file.*,  #備份舊值
       g_vlm01_t   LIKE vlm_file.vlm01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件  
       g_sql       STRING                   #組 sql 用   
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        #No.FUN-680102
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10     
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        #No.FUN-680102 SMALLINT  #No.FUN-6A0066
DEFINE l_cnt                 LIKE type_file.num5
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5       
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_vlm.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM vlm_file WHERE vlm01 = ? FOR UPDATE "       #TQC-780042 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s306_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW s306_w AT p_row,p_col WITH FORM "aps/42f/apss306"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL s306_menu()
 
   CLOSE WINDOW s306_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION s306_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_vlm.* TO NULL   
    CONSTRUCT BY NAME g_wc ON        # 螢幕上取條件
        vlm01,vlm02,vlm03
 
      #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(vlm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_vlm01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_vlm.vlm01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vlm01
                 NEXT FIELD vlm01
 
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION controlg                 
         CALL cl_cmdask()                
 
     #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
     #No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   ##資料權限的檢查
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND vlmuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND vlmgrup MATCHES '",
   #               g_grup CLIPPED,"*'"
   #END IF
 
   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND vlmgrup IN ",cl_chk_tgrup_list()
   #END IF
 
    LET g_sql="SELECT vlm01 FROM vlm_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY vlm01"
    PREPARE s306_prepare FROM g_sql
    DECLARE s306_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s306_prepare
    LET g_sql=
              "SELECT COUNT(*) FROM vlm_file ",
              " WHERE ",g_wc CLIPPED
    PREPARE s306_precount FROM g_sql
    DECLARE s306_count CURSOR FOR s306_precount
END FUNCTION
 
FUNCTION s306_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-780056   
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL s306_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s306_q()
            END IF
        ON ACTION next
            CALL s306_fetch('N')
        ON ACTION previous
            CALL s306_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL s306_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL s306_r()
            END IF
        #FUN-A10142--add---str---
        ON ACTION update_aps
            LET g_action_choice="update_aps"
            IF cl_chk_act_auth() THEN
                 CALL s306_update_aps()
            END IF
        #FUN-A10142--add---end---
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL s306_fetch('/')
        ON ACTION first
            CALL s306_fetch('F')
        ON ACTION last
            CALL s306_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document   
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_vlm.vlm01 IS NOT NULL THEN
                 LET g_doc.column1 = "vlm01"
                 LET g_doc.value1 = g_vlm.vlm01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE s306_cs
END FUNCTION
 
 
FUNCTION s306_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vlm.* LIKE vlm_file.*
    LET g_vlm01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL s306_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_vlm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vlm.vlm01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vlm_file VALUES(g_vlm.vlm01,g_vlm.vlm02,g_vlm.vlm03)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vlm_file",g_vlm.vlm01,"",SQLCA.sqlcode,"","",0)   #No.FUN-880112
            CONTINUE WHILE
        ELSE
            SELECT vlm01 INTO g_vlm.vlm01 FROM vlm_file
                     WHERE vlm01 = g_vlm.vlm01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION s306_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,                                   
            l_input   LIKE type_file.chr1,                                    
            l_n       LIKE type_file.num5                                  
 
 
   DISPLAY BY NAME
      g_vlm.vlm01,g_vlm.vlm02,g_vlm.vlm03
 
   INPUT BY NAME
      g_vlm.vlm01,g_vlm.vlm02,g_vlm.vlm03
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL s306_set_entry(p_cmd)
          CALL s306_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
 
      AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
        IF g_vlm.vlm01 IS NULL THEN
           DISPLAY BY NAME g_vlm.vlm01
           LET l_input='Y'
        END IF
        IF l_input='Y' THEN
           NEXT FIELD vlm01
        END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(vlm01) THEN
            LET g_vlm.* = g_vlm_t.*
            CALL s306_show()
            NEXT FIELD vlm01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(vlm01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vlm01"
              LET g_qryparam.default1 = g_vlm.vlm01
              #FUN-880112
              IF p_cmd != 'a' THEN 
                 CALL cl_create_qry() RETURNING g_vlm.vlm01
                 DISPLAY g_vlm.vlm01 TO vlm01 
                 NEXT FIELD vlm01
              END IF
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
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
   END INPUT
END FUNCTION
 
 
FUNCTION s306_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_vlm.* TO NULL                          
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s306_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN s306_count
    FETCH s306_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN s306_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlm.vlm01,SQLCA.sqlcode,0)
        INITIALIZE g_vlm.* TO NULL
    ELSE
        CALL s306_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION s306_fetch(p_flvlm)
    DEFINE
        p_flvlm         LIKE type_file.chr1                                      
 
    CASE p_flvlm
        WHEN 'N' FETCH NEXT     s306_cs INTO g_vlm.vlm01
        WHEN 'P' FETCH PREVIOUS s306_cs INTO g_vlm.vlm01
        WHEN 'F' FETCH FIRST    s306_cs INTO g_vlm.vlm01
        WHEN 'L' FETCH LAST     s306_cs INTO g_vlm.vlm01
        WHEN '/'
            IF (NOT mi_no_ask) THEN           
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION controlg                 
         CALL cl_cmdask()                
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump s306_cs INTO g_vlm.vlm01
            LET mi_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlm.vlm01,SQLCA.sqlcode,0)
        INITIALIZE g_vlm.* TO NULL             
        RETURN
    ELSE
      CASE p_flvlm
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_vlm.* FROM vlm_file  # 重讀DB,因TEMP有不被更新特性
       WHERE vlm01 = g_vlm.vlm01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vlm_file",g_vlm.vlm01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        CALL s306_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s306_show()
    LET g_vlm_t.* = g_vlm.*
    DISPLAY BY NAME g_vlm.vlm01,g_vlm.vlm02,g_vlm.vlm03
    CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION s306_u()
    IF g_vlm.vlm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_vlm.* FROM vlm_file WHERE vlm01=g_vlm.vlm01
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vlm01_t = g_vlm.vlm01
    BEGIN WORK
 
    OPEN s306_cl USING g_vlm.vlm01
    IF STATUS THEN
       CALL cl_err("OPEN s306_cl:", STATUS, 1)
       CLOSE s306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s306_cl INTO g_vlm.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vlm.vlm01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL s306_show()                          # 顯示最新資料
    WHILE TRUE
        CALL s306_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vlm.*=g_vlm_t.*
            CALL s306_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vlm_file SET vlm_file.* = g_vlm.*    # 更新DB
            WHERE vlm01 = g_vlm01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vlm_file",g_vlm.vlm01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s306_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s306_x()
    IF g_vlm.vlm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN s306_cl USING g_vlm.vlm01
    IF STATUS THEN
       CALL cl_err("OPEN s306_cl:", STATUS, 1)
       CLOSE s306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s306_cl INTO g_vlm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vlm.vlm01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL s306_show()
    CLOSE s306_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s306_r()
DEFINE l_i LIKE type_file.num5
 
    IF g_vlm.vlm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
   #若APS硬體模式設定已有資料庫設定資料,則不允許刪除
    SELECT COUNT(*) INTO l_i FROM vln_file WHERE vln03=g_vlm.vlm01  
    IF l_i != 0 THEN 
       CALL cl_err(g_vlm.vlm01,'aps-716',1)
       RETURN
    END IF 
    BEGIN WORK 
 
    OPEN s306_cl USING g_vlm.vlm01
    IF STATUS THEN
       CALL cl_err("OPEN s306_cl:", STATUS, 0)
       CLOSE s306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s306_cl INTO g_vlm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vlm.vlm01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL s306_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vlm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vlm.vlm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM vlm_file WHERE vlm01 = g_vlm.vlm01
       CLEAR FORM
       OPEN s306_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE s306_cs
          CLOSE s306_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH s306_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE s306_cs
          CLOSE s306_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN s306_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL s306_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 #No.FUN-6A0066
          CALL s306_fetch('/')
       END IF
    END IF
    CLOSE s306_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION s306_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1     
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vlm01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION s306_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1      
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("vlm01",FALSE)
    END IF
 
END FUNCTION

#FUN-A10142---add---str---
FUNCTION s306_update_aps()
DEFINE l_ze03   LIKE ze_file.ze03
DEFINE l_vzv03  DATETIME YEAR TO SECOND
DEFINE l_vzt    RECORD LIKE vzt_file.*
DEFINE l_dbs    STRING
DEFINE l_legal  LIKE azw_file.azw02  #FUN-CC0150 add

    IF g_vlm.vlm01 IS NULL THEN
        CALL cl_err('',-400,1)
        RETURN
    END IF
    CALL cl_getmsg('aps-041',g_lang) RETURNING l_ze03 #IP位址調整
    IF cl_confirm('aps-040') THEN #確定將異動後資料更新至APS?
        BEGIN WORK
        LET g_success = 'Y'
        UPDATE vzy_file
           SET vzy08 = g_vlm.vlm02,
               vzy09 = g_vlm.vlm03
         WHERE vzy13 IN (
                         SELECT UNIQUE vln01
                           FROM vln_file
                          WHERE vln03 = g_vlm.vlm01
                        )
           AND vzy10 NOT IN ('D','J')
        IF SQLCA.sqlcode THEN
            CALL cl_err('UPD vzy_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
        END IF
        IF g_success = 'N' THEN
            ROLLBACK WORK
        ELSE
            COMMIT WORK
            LET g_sql = "SELECT * ",
                        "  FROM vzt_file",
                        " WHERE vzt01 IN ( ",
                        "   SELECT UNIQUE vzy06 FROM vzy_file )"
            PREPARE s306_pre FROM g_sql
            DECLARE s306_curs CURSOR FOR s306_pre

            INITIALIZE l_vzt.* TO NULL

            FOREACH s306_curs INTO l_vzt.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET g_plant_new=l_vzt.vzt01
               CALL s_getdbs()
               LET l_dbs = g_dbs_new
               LET l_vzv03 = CURRENT YEAR TO SECOND
               LET g_sql = "INSERT INTO ",l_dbs CLIPPED,"vzv_file",
                           "(vzv00,vzv01,vzv02,vzv03,vzv04,",
                           " vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal)",
                           "VALUES(?,?,?,?,?,",
                           "       ?,?,?,?,?,?) "
               PREPARE s306_ins_vzv_p FROM g_sql
               EXECUTE s306_ins_vzv_p USING l_vzt.vzt01,'sync','0',l_vzv03,'00',
                                            l_ze03,'R','Y',g_user,g_plant,g_legal
               IF STATUS THEN
                   CALL cl_err3("ins","vzv_file",l_vzt.vzt01,'sync',STATUS,"","",1)
                   EXIT FOREACH
               END IF
               #FUN-CC0150--add----str--
               #(抓出該營運中心所屬法人)
               LET l_legal=''
               SELECT azw02 INTO l_legal 
                 FROM azw_file
                WHERE azw01 = l_vzt.vzt01 
               #FUN-CC0150--add----end--
               LET g_msg = "apsp600 'erp_sync' ",
                            "'",l_vzt.vzt01 CLIPPED,"' ",
                                                   "'' ",
                            "'",l_vzt.vzt02 CLIPPED,"' ",
                            "'",l_vzt.vzt02 CLIPPED,"' ",
                            "'",l_vzt.vzt03 CLIPPED,"' ",
                            "'",l_vzt.vzt04 CLIPPED,"' ",
                                            "'ssissync'",
                            " '' ",          #FUN-CC0150 add
                            "'",l_legal,"'"  #FUN-CC0150 add
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END FOREACH
        END IF
    END IF
END FUNCTION
#FUN-A10142---add---end---
#FUN-B50003
