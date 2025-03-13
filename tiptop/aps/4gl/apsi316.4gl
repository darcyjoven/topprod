# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsi316.4gl 
# Descriptions...: APS 製令、工單維護
# Date & Author..: NO.FUN-850114 08/01/18 BY Yiting
# Modify.........: No.FUN-910005 09/01/06 BY DUKE ADD 是否受供給法則限制, 0;否 1:是
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0129 09/10/26 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50004 11/05/05 By Abby---GP5.25 追版---str---
# Modify.........: No:FUN-930127 09/03/25 By Duke ADD MO多餘量需求建立模式
# Modify.........: FUN-B50004 11/05/05 By Abby---GP5.25 追版---end---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmw           RECORD LIKE vmw_file.*, #FUN-720043
    g_vmw_t         RECORD LIKE vmw_file.*,  #FUN-850114
    g_vmw01         LIKE vmw_file.vmw01,      #製令編號
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
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

    INITIALIZE g_vmw.* TO NULL
    INITIALIZE g_vmw_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vmw_file WHERE vmw01 = ? FOR UPDATE"   #TQC-9A0129 Add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i316_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i316_w WITH FORM "aps/42f/apsi316"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_vmw.vmw01  = ARG_VAL(1)
    IF g_vmw.vmw01 IS NOT NULL AND  g_vmw.vmw01 != ' '
       THEN LET g_flag = 'Y'
            CALL i316_q()
       ELSE LET g_flag = 'N'
    END IF
 
      LET g_action_choice=""
      CALL i316_menu()
 
    CLOSE WINDOW i316_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i316_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = " vmw01='",g_vmw.vmw01,"'"
    ELSE
   INITIALIZE g_vmw.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vmw01,
          vmw02,
          vmw25,   #FUN-910005 ADD
          vmw26    #FUN-930127 ADD
 
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
   ##資料權限的檢查
   #IF g_priv2='4' THEN                                 #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND oeauser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                                 #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF
 
   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #END IF
 
    LET g_sql = "SELECT vmw01 FROM vmw_file ",   # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY vmw01"
    PREPARE i316_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i316_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i316_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vmw_file WHERE ",g_wc CLIPPED
    PREPARE i316_precount FROM g_sql
    DECLARE i316_count CURSOR FOR i316_precount
END FUNCTION
 
FUNCTION i316_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i316_q()
           END IF
        ON ACTION first
           CALL i316_fetch('F')
        ON ACTION next
           CALL i316_fetch('N')
        ON ACTION previous
           CALL i316_fetch('P')
        ON ACTION last
           CALL i316_fetch('L')
        ON ACTION jump
           CALL i316_fetch('/')
        ON ACTION modify
           CALL i316_u()
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
               IF g_vmw.vmw01 IS NOT NULL THEN
                  LET g_doc.column1 = "vmw01"
                  LET g_doc.value1 = g_vmw.vmw01
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i316_cs
END FUNCTION
 
 
FUNCTION i316_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vmw.* LIKE vmw_file.*
    LET g_vmw.vmw01= NULL
    LET g_vmw.vmw02= NULL
    LET g_vmw.vmw25= 0 #FUN-910005 ADD
    LET g_vmw.vmw26= 0 #FUN-930127 ADD
 
    LET g_vmw_t.*=g_vmw.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i316_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vmw.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vmw.vmw01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
	LET g_vmw.vmwplant = g_plant  #FUN-B50004 add
	LET g_vmw.vmwlegal = g_legal  #FUN-B50004 add
        INSERT INTO vmw_file VALUES(g_vmw.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmw_file",g_vmw.vmw01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vmw_t.* = g_vmw.*                # 保存上筆資料
            SELECT vmw01 INTO g_vmw.vmw01 FROM vmw_file
                WHERE vmw01 = g_vmw.vmw01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i316_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME 
        g_vmw.vmw01,
        g_vmw.vmw02,
        g_vmw.vmw25,  #FUN-910005 ADD
        g_vmw.vmw26   #FUN-930127 ADD
    INPUT BY NAME   
        g_vmw.vmw01,
        g_vmw.vmw02,
        g_vmw.vmw25,  #FUN-910005 ADD
        g_vmw.vmw26   #FUN-930127 ADD
        WITHOUT DEFAULTS
 
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vmw01
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
 
FUNCTION i316_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i316_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vmw.* TO NULL
        RETURN
    END IF
    OPEN i316_count
    FETCH i316_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i316_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmw.vmw01,SQLCA.sqlcode,0)
        INITIALIZE g_vmw.* TO NULL
    ELSE
        CALL i316_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i316_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i316_cs INTO g_vmw.vmw01
        WHEN 'P' FETCH PREVIOUS i316_cs INTO g_vmw.vmw01
        WHEN 'F' FETCH FIRST    i316_cs INTO g_vmw.vmw01
        WHEN 'L' FETCH LAST     i316_cs INTO g_vmw.vmw01
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
            FETCH ABSOLUTE l_abso i316_cs INTO g_vmw.vmw01
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmw.vmw01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vmw.* TO NULL          
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
 
SELECT * INTO g_vmw.* FROM vmw_file            
WHERE vmw01 = g_vmw.vmw01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmw.vmw01 CLIPPED
         CALL cl_err3("sel","vmw_file",g_vmw.vmw01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vmw.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i316_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i316_show()
    LET g_vmw_t.* = g_vmw.*
    DISPLAY BY NAME 
        g_vmw.vmw01         ,
        g_vmw.vmw02         ,
        g_vmw.vmw25         , #FUN-910005 ADD
        g_vmw.vmw26           #FUN-930127 ADD
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i316_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmw.vmw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmw01 = g_vmw.vmw01
    BEGIN WORK
 
    OPEN i316_cl USING g_vmw.vmw01
    IF STATUS THEN
       CALL cl_err("OPEN i316_cl:", STATUS, 1)
       CLOSE i316_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i316_cl INTO g_vmw.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmw.vmw01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i316_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i316_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmw.* = g_vmw_t.*
            CALL i316_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmw_file SET vmw_file.* = g_vmw.*    # 更新DB
            WHERE vmw01 = g_vmw_t.vmw01               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vmw.vmw01 CLIPPED
            CALL cl_err3("upd","vmw_file",g_vmw01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vmw_t.* = g_vmw.*# 保存上筆資料
            SELECT vmw01 INTO g_vmw.vmw01 FROM vmw_file
             WHERE vmw01 = g_vmw.vmw01
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i316_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i316_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmw.vmw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i316_cl USING g_vmw.vmw01
    IF STATUS THEN
       CALL cl_err("OPEN i316_cl:", STATUS, 1)
       CLOSE i316_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i316_cl INTO g_vmw.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmw.vmw01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i316_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmw01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmw.vmw01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM vmw_file WHERE vmw01 = g_vmw.vmw01
            CLEAR FORM
    END IF
    CLOSE i316_cl
    INITIALIZE g_vmw.* TO NULL
    COMMIT WORK
END FUNCTION
#FUN-B50004
