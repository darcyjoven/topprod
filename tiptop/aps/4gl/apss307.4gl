# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apss307.4gl
# Descriptions...: APS硬體模式維護(APS)
# Date & Author..: 97/08/278 #FUN-880112 By duke 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-840079
DEFINE g_vln       RECORD LIKE vln_file.*,
       g_vln_t     RECORD LIKE vln_file.*,  #備份舊值
       g_vln01_t   LIKE vln_file.vln01,     #Key值備份
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
DEFINE l_vzt02               LIKE vzt_file.vzt02
DEFINE l_vlm02               LIKE vlm_file.vlm02
DEFINE l_vlm03               LIKE vlm_file.vlm03
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
   INITIALIZE g_vln.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM vln_file WHERE vln01=? FOR UPDATE "       #TQC-780042 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s307_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW s307_w AT p_row,p_col WITH FORM "aps/42f/apss307"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL s307_menu()
 
   CLOSE WINDOW s307_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-880112  DUKE
END MAIN
 
FUNCTION s307_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_vln.* TO NULL   
    CONSTRUCT BY NAME g_wc ON        # 螢幕上取條件
        vln01,vln02,vln03
 
      #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(vln01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_vln01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vln01
                 NEXT FIELD vln01
             WHEN INFIELD(vln02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_vzt"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO vln02
                NEXT FIELD vln02
             WHEN INFIELD(vln03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_vlm01"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO vln03
                NEXT FIELD vln03
 
 
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
   #    LET g_wc = g_wc clipped," AND vlnuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND vlngrup MATCHES '",
   #               g_grup CLIPPED,"*'"
   #END IF
 
   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND vlngrup IN ",cl_chk_tgrup_list()
   #END IF
 
    LET g_sql="SELECT vln01 FROM vln_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY vln01"
    PREPARE s307_prepare FROM g_sql
    DECLARE s307_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s307_prepare
    LET g_sql=
              "SELECT COUNT(*) FROM vln_file ",
              " WHERE ",g_wc CLIPPED
    PREPARE s307_precount FROM g_sql
    DECLARE s307_count CURSOR FOR s307_precount
END FUNCTION
 
FUNCTION s307_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-780056   
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL s307_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s307_q()
            END IF
        ON ACTION next
            CALL s307_fetch('N')
        ON ACTION previous
            CALL s307_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL s307_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL s307_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL s307_fetch('/')
        ON ACTION first
            CALL s307_fetch('F')
        ON ACTION last
            CALL s307_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
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
              IF g_vln.vln01 IS NOT NULL THEN
                 LET g_doc.column1 = "vln01"
                 LET g_doc.value1 = g_vln.vln01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE s307_cs
END FUNCTION
 
 
FUNCTION s307_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vln.* LIKE vln_file.*
    LET g_vln01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL s307_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_vln.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vln.vln01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vln_file VALUES(g_vln.vln01,g_vln.vln02,g_vln.vln03)   # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vln_file",g_vln.vln01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT vln01 INTO g_vln.vln01 FROM vln_file
                     WHERE vln01 = g_vln.vln01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION s307_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,                                   
            l_input   LIKE type_file.chr1,                                    
            l_n       LIKE type_file.num5                                  
 
 
   DISPLAY BY NAME
      g_vln.vln01,g_vln.vln02,g_vln.vln03
 
   INPUT BY NAME
      g_vln.vln01,g_vln.vln02,g_vln.vln03
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL s307_set_entry(p_cmd)
          CALL s307_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      #AFTER FIELD vln01
      #   DISPLAY "AFTER FIELD vln01"
      #   IF g_vln.vln01 IS NOT NULL THEN
      #      IF p_cmd = "a" THEN                   # 若輸入或更改且改KEY
      #         SELECT count(*) INTO l_n 
      #           FROM vln_file 
      #          WHERE vln01 = g_vln.vln01
      #         IF l_n <> 1 THEN                  # Duplicated
      #            CALL cl_err(g_vln.vln01,'aap-025',1)
      #            LET g_vln.vln01 = g_vln01_t
      #            DISPLAY BY NAME g_vln.vln01
      #            NEXT FIELD vln01
      #         END IF
      #      END IF
      #   END IF
 
      AFTER FIELD vln02
        IF g_vln.vln02 IS NOT NULL THEN
           LET l_vzt02 = NULL
           DISPLAY l_vzt02 to vzt02
           SELECT vzt02 into l_vzt02
             FROM vzt_file
              WHERE vzt01=g_vln.vln02
           IF l_vzt02 IS NULL  THEN
              call cl_err('','aps-717',0)
              NEXT FIELD vln02
           END IF
           DISPLAY l_vzt02 to  vzt02
        END IF
 
      AFTER FIELD vln03
        IF g_vln.vln03 IS NOT NULL THEN
           LET l_vlm02 = NULL
           LET l_vlm03 = NULL
           DISPLAY l_vlm02 to vlm02
           DISPLAY l_vlm03 to vlm03
           SELECT vlm02,vlm03 into l_vlm02,l_vlm03
             FROM vlm_file
                WHERE vlm01=g_vln.vln03
           IF l_vlm02 IS NULL THEN
              CALL cl_err('','aps-718',0)
              NEXT FIELD vln03
           END IF
           DISPLAY l_vlm02 to vlm02
           DISPLAY l_vlm03 to vlm03
        END IF
 
 
 
      AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
        IF g_vln.vln01 IS NULL THEN
           DISPLAY BY NAME g_vln.vln01
           LET l_input='Y'
        END IF
        IF l_input='Y' THEN
           NEXT FIELD vln01
        END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(vln01) THEN
            LET g_vln.* = g_vln_t.*
            CALL s307_show()
            NEXT FIELD vln01
         END IF
 
     ON ACTION controlp
        CASE
          WHEN INFIELD(vln01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_vln01"
             IF p_cmd != 'a' THEN
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO vln01
                NEXT FIELD vln01
             END IF
           WHEN INFIELD(vln02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vzt01"
              LET g_qryparam.default1 = g_vln.vln02
              LET l_vzt02=''
              CALL cl_create_qry() RETURNING g_vln.vln02,l_vzt02
              DISPLAY g_vln.vln02,l_vzt02 TO vln02,vzt02 
              NEXT FIELD vln02
           WHEN INFIELD(vln03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vlm01"
              LET g_qryparam.default1 = g_vln.vln03
              CALL cl_create_qry() RETURNING g_vln.vln03,l_vlm02,l_vlm03
              DISPLAY g_vln.vln03,l_vlm02,l_vlm03 TO vln03,vlm02,vlm03
              NEXT FIELD vln03
 
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
 
 
FUNCTION s307_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_vln.* TO NULL                          
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s307_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN s307_count
    FETCH s307_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN s307_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vln.vln01,SQLCA.sqlcode,0)
        INITIALIZE g_vln.* TO NULL
    ELSE
        CALL s307_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION s307_fetch(p_flvln)
    DEFINE
        p_flvln         LIKE type_file.chr1                                      
 
    CASE p_flvln
        WHEN 'N' FETCH NEXT     s307_cs INTO g_vln.vln01
        WHEN 'P' FETCH PREVIOUS s307_cs INTO g_vln.vln01
        WHEN 'F' FETCH FIRST    s307_cs INTO g_vln.vln01
        WHEN 'L' FETCH LAST     s307_cs INTO g_vln.vln01
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
            FETCH ABSOLUTE g_jump s307_cs INTO g_vln.vln01
            LET mi_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vln.vln01,SQLCA.sqlcode,0)
        INITIALIZE g_vln.* TO NULL             
        RETURN
    ELSE
      CASE p_flvln
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_vln.* FROM vln_file  # 重讀DB,因TEMP有不被更新特性
       WHERE vln01=g_vln.vln01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vln_file",g_vln.vln01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        CALL s307_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s307_show()
    LET g_vln_t.* = g_vln.*
    DISPLAY BY NAME g_vln.vln01,g_vln.vln02,g_vln.vln03
    CALL s307_vln02('d')
    CALL s307_vln03('d')
    CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION s307_vln02(p_cmd)
DEFINE
  p_cmd      LIKE type_file.chr1
 
  LET g_errno = ''
  SELECT vzt02 into l_vzt02
      FROM vzt_file 
        WHERE vzt01 = g_vln.vln02
  #IF p_cmd='d' OR cl_null(g_errno)THEN
    DISPLAY l_vzt02 to vzt02
  #END IF
END FUNCTION
 
FUNCTION s307_vln03(p_cmd)
DEFINE
 p_cmd      LIKE type_file.chr1,
 l_vlm02    LIKE vlm_file.vlm02,
 l_vlm03    LIKE vlm_file.vlm03
 
    LET g_errno = ''
    SELECT vlm02,vlm03 into l_vlm02,l_vlm03
      FROM vlm_file 
        WHERE vlm01=g_vln.vln03
    #IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY l_vlm02 to vlm02
       DISPLAY l_vlm03 to vlm03
    #END IF
END FUNCTION
 
 
 
FUNCTION s307_u()
    IF g_vln.vln01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_vln.* FROM vln_file WHERE vln01=g_vln.vln01
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vln01_t = g_vln.vln01
    BEGIN WORK
 
    OPEN s307_cl USING g_vln.vln01
    IF STATUS THEN
       CALL cl_err("OPEN s307_cl:", STATUS, 1)
       CLOSE s307_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s307_cl INTO g_vln.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vln.vln01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL s307_show()                          # 顯示最新資料
    WHILE TRUE
        CALL s307_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vln.*=g_vln_t.*
            CALL s307_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vln_file SET vln_file.* = g_vln.*    # 更新DB
            WHERE vln01 = g_vln01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vln_file",g_vln.vln01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s307_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s307_x()
    IF g_vln.vln01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN s307_cl USING g_vln.vln01
    IF STATUS THEN
       CALL cl_err("OPEN s307_cl:", STATUS, 1)
       CLOSE s307_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s307_cl INTO g_vln.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vln.vln01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL s307_show()
    CLOSE s307_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s307_r()
DEFINE l_i LIKE type_file.num5
 
    IF g_vln.vln01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
   #若多廠區設定已有資料庫設定資料,則不允許刪除
    SELECT COUNT(*) INTO l_i FROM vzy_file WHERE vzy13=g_vln.vln01  
    IF l_i != 0 THEN 
       CALL cl_err(g_vln.vln01,'aps-010',1)
       RETURN
    END IF 
    BEGIN WORK 
 
    OPEN s307_cl USING g_vln.vln01
    IF STATUS THEN
       CALL cl_err("OPEN s307_cl:", STATUS, 0)
       CLOSE s307_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s307_cl INTO g_vln.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vln.vln01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL s307_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vln01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vln.vln01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM vln_file WHERE vln01 = g_vln.vln01
       CLEAR FORM
       OPEN s307_count
       FETCH s307_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN s307_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL s307_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 #No.FUN-6A0066
          CALL s307_fetch('/')
       END IF
    END IF
    CLOSE s307_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION s307_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1     
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vln01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION s307_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1      
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("vln01",FALSE)
    END IF
 
END FUNCTION
