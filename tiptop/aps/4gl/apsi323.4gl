# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsi323.4gl
# Date & Author..: NO.FUN-850114 08/01/18 BY yiting
# Modify.........: NO.FUN-840209 08/05/13 BY DUKE DISENABLE INSERT AND DELETE ACTION
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0129 09/10/26 By xiaofeizhu 標準SQL修改 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50004 11/05/05 By Abby---GP5.25 追版---str------------------------------
# Modify.........: NO.FUN-960025 09/06/04 BY DUKE 外包類型vlf03=2時,調整工單凍結碼SFB41為Y,外包類型vlf03=1時調整為N
# Modify.........: FUN-B50004 11/05/05 By Abby---GP5.25 追版---end------------------------------

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    g_vnf           RECORD LIKE vnf_file.*, #FUN-720043 #FUN-740216
    g_vnf_t         RECORD LIKE vnf_file.*, 
    g_vnf01         LIKE vnf_file.vnf01,        #主沖銷料號
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE g_before_input_done   STRING

MAIN
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818

    INITIALIZE g_vnf.* TO NULL
    INITIALIZE g_vnf_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vnf_file WHERE vnf01 = ? FOR UPDATE"   #TQC-9A0129 Add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i323_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i323_w WITH FORM "aps/42f/apsi323"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_vnf.vnf01      = ARG_VAL(1)
    IF g_vnf.vnf01 IS NOT NULL AND  g_vnf.vnf01 != ' '
       THEN LET g_flag = 'Y'
            CALL i323_q()
       ELSE LET g_flag = 'N'
    END IF
 
      LET g_action_choice=""
      CALL i323_menu()
 
    CLOSE WINDOW i323_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i323_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "     vnf01='",g_vnf.vnf01,"'"
    ELSE
   INITIALIZE g_vnf.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vnf01,
          vnf03,     
          vnf07
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION help          
             CALL cl_show_help()  
          
          ON ACTION controlg      
             CALL cl_cmdask()     
 
          ON ACTION qbe_select
             CALL cl_qbe_select()
          ON ACTION qbe_save
             CALL cl_qbe_save()
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql = "SELECT vnf01 FROM vnf_file ",   # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY vnf01"
    PREPARE i323_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i323_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i323_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vnf_file WHERE ",g_wc CLIPPED
    PREPARE i323_precount FROM g_sql
    DECLARE i323_count CURSOR FOR i323_precount
END FUNCTION
 
FUNCTION i323_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   #FUN-840209 BY DUKE MARK ----BEGIN-----
   #     ON ACTION insert
   #         LET g_action_choice="insert"
   #         IF cl_chk_act_auth() THEN
   #              CALL i323_a()
   #         END IF
   #FUN-840209 BY DUKE MARK ---END-----
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i323_q()
           END IF
 
   #FUN-840209 BY DUKE MARK ----BEGIN---
   #     ON ACTION delete
   #         LET g_action_choice="delete"
   #         IF cl_chk_act_auth() THEN
   #             CALL i323_r()
   #         END IF
   #FUN-840209 BY DUKE MARK ---END-----
 
        ON ACTION next
           CALL i323_fetch('N')
        ON ACTION previous
           CALL i323_fetch('P')
        ON ACTION modify
           CALL i323_u()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_vnf.vnf01) THEN
                  LET g_doc.column1 = "vnf01"
                  LET g_doc.value1 = g_vnf.vnf01
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i323_cs
END FUNCTION
 
 
FUNCTION i323_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vnf.* LIKE vnf_file.*
    LET g_vnf_t.*=g_vnf.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i323_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vnf.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_vnf.vnf01) THEN                  # KEY 不可空白
            CONTINUE WHILE
        END IF
	LET g_vnf.vnfplant = g_plant  #FUN-B50004 add
	LET g_vnf.vnflegal = g_legal  #FUN-B50004 add
        INSERT INTO vnf_file VALUES(g_vnf.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vnf_file",g_vnf.vnf01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
           #FUN-960025 ADD --STR-------------------------
            IF g_vnf.vnf03 = '2'THEN
               UPDATE sfb_file SET sfb41 = 'Y'
                WHERE sfb01 = g_vnf.vnf01
            ELSE
               IF g_vnf.vnf03 = '1' THEN
                  UPDATE sfb_file SET sfb41 = 'N'
                   WHERE sfb01 = g_vnf.vnf01
               END IF
            END IF
           #FUN-960025 ADD --END-------------------------
            LET g_vnf_t.* = g_vnf.*                # 保存上筆資料
            SELECT vnf01 INTO g_vnf.vnf01 FROM vnf_file
             WHERE vnf01      = g_vnf.vnf01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i323_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME 
        g_vnf.vnf01,
        g_vnf.vnf03,
        g_vnf.vnf07
    INPUT BY NAME   
        g_vnf.vnf01,
        g_vnf.vnf03,
        g_vnf.vnf07
        WITHOUT DEFAULTS
 
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i323_set_entry(p_cmd)
        CALL i323_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
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
 
FUNCTION i323_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i323_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vnf.* TO NULL
        RETURN
    END IF
    OPEN i323_count
    FETCH i323_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i323_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnf.vnf01,SQLCA.sqlcode,0)
        INITIALIZE g_vnf.* TO NULL
    ELSE
        CALL i323_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i323_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i323_cs INTO g_vnf.vnf01
        WHEN 'P' FETCH PREVIOUS i323_cs INTO g_vnf.vnf01
        WHEN 'F' FETCH FIRST    i323_cs INTO g_vnf.vnf01
        WHEN 'L' FETCH LAST     i323_cs INTO g_vnf.vnf01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso i323_cs INTO g_vnf.vnf01
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vnf.vnf01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vnf.* TO NULL          
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vnf.* FROM vnf_file            
WHERE vnf01 = g_vnf.vnf01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vnf.vnf01 CLIPPED CLIPPED
        CALL cl_err3("sel","vnf_file",g_vnf.vnf01,"",SQLCA.sqlcode,"","",1) # FUN-660095
        INITIALIZE g_vnf.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i323_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i323_show()
    LET g_vnf_t.* = g_vnf.*
    DISPLAY BY NAME 
        g_vnf.vnf01,
        g_vnf.vnf03,
        g_vnf.vnf07     
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i323_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnf.vnf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vnf01 = g_vnf.vnf01
    BEGIN WORK
 
    OPEN i323_cl USING g_vnf.vnf01
    IF STATUS THEN
       CALL cl_err("OPEN i323_cl:", STATUS, 1)
       CLOSE i323_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i323_cl INTO g_vnf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnf.vnf01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i323_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i323_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vnf.* = g_vnf_t.*
            CALL i323_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vnf_file SET vnf_file.* = g_vnf.*    # 更新DB
            WHERE vnf01 = g_vnf01               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vnf.vnf01 CLIPPED
            CALL cl_err3("upd","vnf_file",g_vnf01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
           #FUN-960025 ADD --STR-------------------------
            IF g_vnf.vnf03 = '2' THEN
               UPDATE sfb_file SET sfb41 = 'Y'
                WHERE sfb01 = g_vnf.vnf01
            ELSE
               IF g_vnf.vnf03 = '1' THEN
                  UPDATE sfb_file SET sfb41 = 'N'
                   WHERE sfb01 = g_vnf.vnf01
               END IF
            END IF
           #FUN-960025 ADD --END-------------------------
            LET g_vnf_t.* = g_vnf.*# 保存上筆資料
            SELECT vnf01 INTO g_vnf.vnf01 FROM vnf_file
             WHERE vnf01      = g_vnf.vnf01
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i323_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i323_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnf.vnf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i323_cl USING g_vnf.vnf01
    IF STATUS THEN
       CALL cl_err("OPEN i323_cl:", STATUS, 1)
       CLOSE i323_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i323_cl INTO g_vnf.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnf.vnf01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i323_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vnf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vnf.vnf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM vnf_file WHERE vnf01 = g_vnf.vnf01
            CLEAR FORM
    END IF
    CLOSE i323_cl
    INITIALIZE g_vnf.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION i323_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vnf01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i323_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vnf01",FALSE) 
   END IF
END FUNCTION
 
#FUN-B50004 
