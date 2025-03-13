# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsi319.4gl
# Descriptions...: APS 單據追溯維護
# Date & Author..: NO.FUN-850114 08/01/21 BY yiting
# Modify.........: NO.FUN-840209 08/05/13 BY DUKE 需求來源需求數量,預計供給數量,供給最大量不可接受負數
# Modify.........: NO.FUN-890117 08/09/25 BY sabrina 新增後刪除、更改會出現錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0082 09/10/26 By wujie 5.2转SQL标准语法
# Modify.........: No.FUN-B50004 11/05/23 by Abby APS GP5.25追版
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    g_vnb           RECORD LIKE vnb_file.*, #FUN-720043
    g_vnb_t         RECORD LIKE vnb_file.*, 
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   STRING
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   

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

    INITIALIZE g_vnb.* TO NULL
    INITIALIZE g_vnb_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vnb_file WHERE vnb01 = ? AND vnb03 = ? FOR UPDATE"   #No.FUN-9A0082
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i319_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i319_w WITH FORM "aps/42f/apsi319"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_vnb.vnb01) AND NOT cl_null(g_vnb.vnb03) 
       THEN LET g_flag = 'Y'
            CALL i319_q()
       ELSE LET g_flag = 'N'
    END IF
 
      LET g_action_choice=""
      CALL i319_menu()
 
    CLOSE WINDOW i319_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i319_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
    ELSE
   INITIALIZE g_vnb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
              vnb01,
              vnb02,
              vnb03,
              vnb04,
              vnb05,
              vnb06,
              vnb07,
              vnb08,
              vnb09
 
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
 
    LET g_sql = "SELECT vnb01,vnb03 FROM vnb_file ",   # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY vnb01,vnb03"
    PREPARE i319_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i319_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i319_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vnb_file WHERE ",g_wc CLIPPED
    PREPARE i319_precount FROM g_sql
    DECLARE i319_count CURSOR FOR i319_precount
END FUNCTION
 
FUNCTION i319_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i319_a()
            END IF
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i319_q()
           END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i319_r()
            END IF
        ON ACTION next
           CALL i319_fetch('N')
        ON ACTION previous
           CALL i319_fetch('P')
        ON ACTION modify
           CALL i319_u()
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
               IF NOT cl_null(g_vnb.vnb01) AND NOT cl_null(g_vnb.vnb03) THEN
            LET g_doc.column1 = "vnb01"
           LET g_doc.value1 = g_vnb.vnb01
             LET g_doc.column1 = "vnb03"
              LET g_doc.value1 = g_vnb.vnb03
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i319_cs
END FUNCTION
 
 
FUNCTION i319_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vnb.* LIKE vnb_file.*
 
    LET g_vnb_t.*=g_vnb.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vnb.vnb01 = ''
        LET g_vnb.vnb02 = 0
        LET g_vnb.vnb03 = ''
        LET g_vnb.vnb04 = 0
        LET g_vnb.vnb05 = 0
        LET g_vnb.vnb06 = 0
        LET g_vnb.vnb07 = 0
        LET g_vnb.vnb08 = 0
        LET g_vnb.vnb09 = ''
        CALL i319_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vnb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_vnb.vnb01) OR cl_null(g_vnb.vnb03)  THEN       #重要欄位不可空白
            CONTINUE WHILE
        END IF
        LET g_vnb.vnbplant = g_plant  #FUN-B50004 add
        LET g_vnb.vnblegal = g_legal  #FUN-B50004 add
        INSERT INTO vnb_file VALUES(g_vnb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vnb_file",g_vnb.vnb01,g_vnb.vnb03,SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
           #FUN-890117---add---start
            SELECT vnb01,vnb03 INTO g_vnb.vnb01,g_vnb.vnb03  FROM vnb_file                   #新增完後重讀Rowid，則使用者馬上又修改刪除時
                   WHERE vnb01 = g_vnb.vnb01 and vnb03 = g_vnb.vnb03      # 系統才能以rowid抓取所需資料 
           #FUN-890117---add---end
            LET g_vnb_t.* = g_vnb.*                # 保存上筆資料
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i319_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME 
        g_vnb.vnb01,
        g_vnb.vnb02,
        g_vnb.vnb03,
        g_vnb.vnb04,
        g_vnb.vnb05,
        g_vnb.vnb06,
        g_vnb.vnb07,
        g_vnb.vnb08,
        g_vnb.vnb09     
    INPUT BY NAME   
        g_vnb.vnb01,
        g_vnb.vnb02,
        g_vnb.vnb03,
        g_vnb.vnb04,
        g_vnb.vnb05,
        g_vnb.vnb06,
        g_vnb.vnb07,
        g_vnb.vnb08,
        g_vnb.vnb09
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i319_set_entry(p_cmd)
           CALL i319_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        #NO.FUN-840209  by Duke begin
        AFTER FIELD vnb02
           IF  g_vnb.vnb02<0 then
               CALL cl_err('','aps-406',0)
               NEXT FIELD vnb02
           END IF
 
        AFTER FIELD vnb05
           IF  g_vnb.vnb05<0 then
               CALL cl_err('','aps-406',0)
               NEXT FIELD vnb05
           END IF
        AFTER FIELD vnb07
           IF  g_vnb.vnb07<0 then
               CALL cl_err('','aps-406',0)
               NEXT FIELD vnb07
           END IF
 
        #NO.FUN-840209 by Duke end
 
        
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vnb01
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
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
    END INPUT
END FUNCTION
 
FUNCTION i319_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i319_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vnb.* TO NULL
        RETURN
    END IF
    OPEN i319_count
    FETCH i319_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i319_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnb.vnb01,SQLCA.sqlcode,0)
        INITIALIZE g_vnb.* TO NULL
    ELSE
        CALL i319_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i319_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i319_cs INTO g_vnb.vnb01,g_vnb.vnb03
        WHEN 'P' FETCH PREVIOUS i319_cs INTO g_vnb.vnb01,g_vnb.vnb03
        WHEN 'F' FETCH FIRST    i319_cs INTO g_vnb.vnb01,g_vnb.vnb03
        WHEN 'L' FETCH LAST     i319_cs INTO g_vnb.vnb01,g_vnb.vnb03
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
            FETCH ABSOLUTE l_abso i319_cs INTO g_vnb.vnb01,g_vnb.vnb03
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vnb.vnb01
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vnb.* TO NULL          
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
 
SELECT * INTO g_vnb.* FROM vnb_file            
   WHERE vnb01 = g_vnb.vnb01 AND vnb03 = g_vnb.vnb03
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vnb.vnb01 CLIPPED
         CALL cl_err3("sel","vnb_file",g_vnb.vnb01,g_vnb.vnb03,SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vnb.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i319_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i319_show()
    LET g_vnb_t.* = g_vnb.*
    DISPLAY BY NAME 
        g_vnb.vnb01,
        g_vnb.vnb02,
        g_vnb.vnb03,
        g_vnb.vnb04,
        g_vnb.vnb05,
        g_vnb.vnb06,
        g_vnb.vnb07,
        g_vnb.vnb08,
        g_vnb.vnb09
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i319_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnb.vnb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i319_cl USING g_vnb.vnb01,g_vnb.vnb03
    IF STATUS THEN
       CALL cl_err("OPEN i319_cl:", STATUS, 1)
       CLOSE i319_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i319_cl INTO g_vnb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnb.vnb01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i319_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i319_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vnb.* = g_vnb_t.*
            CALL i319_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vnb_file SET vnb_file.* = g_vnb.*    # 更新DB
            WHERE vnb01 = g_vnb_t.vnb01 AND vnb03 = g_vnb_t.vnb03               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vnb.vnb01 CLIPPED
            CALL cl_err3("upd","vnb_file",g_vnb.vnb01,g_vnb.vnb03,SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vnb_t.* = g_vnb.*# 保存上筆資料
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i319_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i319_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnb.vnb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i319_cl USING g_vnb.vnb01,g_vnb.vnb03
    IF STATUS THEN
       CALL cl_err("OPEN i319_cl:", STATUS, 1)
       CLOSE i319_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i319_cl INTO g_vnb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnb.vnb01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i319_show()
    IF cl_delete() THEN
            DELETE FROM vnb_file WHERE vnb01 = g_vnb.vnb01 AND vnb03 = g_vnb.vnb03
            CLEAR FORM
    END IF
    CLOSE i319_cl
    INITIALIZE g_vnb.* TO NULL
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i319_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vnb01,vnb03",TRUE)
   END IF
END FUNCTION
 
FUNCTION i319_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vnb01,vnb03",FALSE) 
   END IF
END FUNCTION
 
