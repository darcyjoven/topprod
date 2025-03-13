# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi314.4gl
# Descriptions...: APS 預測群組沖銷維護
# Date & Author..: NO.FUN-850114 08/01/18 BY yiting
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0082 09/10/26 By wujie 5.2转SQL标准语法
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmt           RECORD LIKE vmt_file.*, #FUN-720043 #FUN-740216
    g_vmt_t         RECORD LIKE vmt_file.*,    #FUN-850114
    g_vmt01         LIKE vmt_file.vmt01,        #主沖銷料號
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   

MAIN
    DEFINE l_time       LIKE type_file.chr8   	#計算被使用時間  
    DEFINE p_row,p_col  LIKE type_file.num5    
 
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
 
    CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
    INITIALIZE g_vmt.* TO NULL
    INITIALIZE g_vmt_t.* TO NULL
 
#   LET g_forupd_sql = "SELECT * FROM vmt_file WHERE rowid = ? FOR UPDATE"
    LET g_forupd_sql = "SELECT * FROM vmt_file WHERE vmt01 = ? AND vmt02 = ? FOR UPDATE"    #No.FUN-9A0082
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i314_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i314_w AT p_row,p_col
      WITH FORM "aps/42f/apsi314"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_vmt.vmt01      = ARG_VAL(1)
    LET g_vmt.vmt02      = ARG_VAL(2)
    IF g_vmt.vmt01 IS NOT NULL AND  g_vmt.vmt01 != ' '
       THEN LET g_flag = 'Y'
            CALL i314_q()
       ELSE LET g_flag = 'N'
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL i314_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i314_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i314_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "     vmt01='",g_vmt.vmt01,"'",
                  " AND vmt02='",g_vmt.vmt02,"'"
    ELSE
   INITIALIZE g_vmt.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vmt01     ,
          vmt02     
 
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
 
    LET g_sql = "SELECT vmt01,vmt02 FROM vmt_file ",   # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY vmt01,vmt02"
    PREPARE i314_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i314_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i314_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vmt_file WHERE ",g_wc CLIPPED
    PREPARE i314_precount FROM g_sql
    DECLARE i314_count CURSOR FOR i314_precount
END FUNCTION
 
FUNCTION i314_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i314_a()
            END IF
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i314_q()
           END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i314_r()
            END IF
        ON ACTION next
           CALL i314_fetch('N')
        ON ACTION previous
           CALL i314_fetch('P')
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
               IF NOT cl_null(g_vmt.vmt01) AND
                  NOT cl_null(g_vmt.vmt02) THEN
                  LET g_doc.column1 = "vmt01"
                  LET g_doc.column2 = "vmt02"
                  LET g_doc.value1 = g_vmt.vmt01
                  LET g_doc.value2 = g_vmt.vmt02
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i314_cs
END FUNCTION
 
 
FUNCTION i314_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vmt.* LIKE vmt_file.*
    LET g_vmt_t.*=g_vmt.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i314_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vmt.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_vmt.vmt01) OR                  # KEY 不可空白
           cl_null(g_vmt.vmt02) THEN
            CONTINUE WHILE
        END IF
        INSERT INTO vmt_file VALUES(g_vmt.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmt_file",g_vmt.vmt01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vmt_t.* = g_vmt.*                # 保存上筆資料
            SELECT vmt01,vmt02 INTO g_vmt.vmt01,g_vmt.vmt02 FROM vmt_file
             WHERE vmt01      = g_vmt.vmt01
               AND vmt02      = g_vmt.vmt02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i314_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_cnt        LIKE type_file.num5
 
    DISPLAY BY NAME 
        g_vmt.vmt01,
        g_vmt.vmt02     
    INPUT BY NAME   
        g_vmt.vmt01,
        g_vmt.vmt02
        WITHOUT DEFAULTS
 
        AFTER FIELD vmt01
           LET l_cnt = 0
           IF NOT cl_null(g_vmt.vmt01) THEN
               SELECT COUNT(*) INTO l_cnt 
                 FROM vmi_file 
                WHERE vmi01 = g_vmt.vmt01
               IF l_cnt = 0 THEN
                   CALL cl_err('','asf-399',0)
                   NEXT FIELD vmt01
               END IF
           END IF
 
        AFTER FIELD vmt02
           LET l_cnt = 0
           IF NOT cl_null(g_vmt.vmt02) THEN
               SELECT COUNT(*) INTO l_cnt 
                 FROM vmi_file 
                WHERE vmi01 = g_vmt.vmt02
               IF l_cnt = 0 THEN
                   CALL cl_err('','asf-399',0)
                   NEXT FIELD vmt02
               END IF
           END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vmt01
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
 
FUNCTION i314_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i314_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vmt.* TO NULL
        RETURN
    END IF
    OPEN i314_count
    FETCH i314_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i314_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmt.vmt01,SQLCA.sqlcode,0)
        INITIALIZE g_vmt.* TO NULL
    ELSE
        CALL i314_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i314_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i314_cs INTO g_vmt.vmt01,g_vmt.vmt02
        WHEN 'P' FETCH PREVIOUS i314_cs INTO g_vmt.vmt01,g_vmt.vmt02
        WHEN 'F' FETCH FIRST    i314_cs INTO g_vmt.vmt01,g_vmt.vmt02
        WHEN 'L' FETCH LAST     i314_cs INTO g_vmt.vmt01,g_vmt.vmt02
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
            FETCH ABSOLUTE l_abso i314_cs INTO g_vmt.vmt01,g_vmt.vmt02
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmt.vmt01 CLIPPED,'+',g_vmt.vmt02 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vmt.* TO NULL          
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
 
SELECT * INTO g_vmt.* FROM vmt_file            
WHERE vmt01 = g_vmt.vmt01 AND vmt02 = g_vmt.vmt02
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmt.vmt01 CLIPPED,'+',g_vmt.vmt02 CLIPPED
        CALL cl_err3("sel","vmt_file",g_vmt.vmt01,"",SQLCA.sqlcode,"","",1) # FUN-660095
        INITIALIZE g_vmt.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i314_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i314_show()
    LET g_vmt_t.* = g_vmt.*
    DISPLAY BY NAME 
        g_vmt.vmt01     ,
        g_vmt.vmt02     
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i314_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmt.vmt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmt01 = g_vmt.vmt01
    BEGIN WORK
 
    OPEN i314_cl USING g_vmt.vmt01,g_vmt.vmt02
    IF STATUS THEN
       CALL cl_err("OPEN i314_cl:", STATUS, 1)
       CLOSE i314_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i314_cl INTO g_vmt.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmt.vmt01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i314_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i314_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmt.* = g_vmt_t.*
            CALL i314_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmt_file SET vmt_file.* = g_vmt.*    # 更新DB
            WHERE vmt01 = g_vmt_t.vmt01 AND vmt02 = g_vmt_t.vmt02               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vmt.vmt01 CLIPPED
            CALL cl_err3("upd","vmt_file",g_vmt01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vmt_t.* = g_vmt.*# 保存上筆資料
            SELECT vmt01,vmt02 INTO g_vmt.vmt01,g_vmt.vmt02 FROM vmt_file
             WHERE vmt01      = g_vmt.vmt01
               AND vmt02      = g_vmt.vmt02
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i314_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i314_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmt.vmt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i314_cl USING g_vmt.vmt01,g_vmt.vmt02
    IF STATUS THEN
       CALL cl_err("OPEN i314_cl:", STATUS, 1)
       CLOSE i314_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i314_cl INTO g_vmt.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmt.vmt01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i314_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmt01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vmt02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmt.vmt01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vmt.vmt02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM vmt_file WHERE vmt01 = g_vmt.vmt01 AND vmt02 = g_vmt.vmt02
            CLEAR FORM
    END IF
    CLOSE i314_cl
    INITIALIZE g_vmt.* TO NULL
    COMMIT WORK
END FUNCTION
