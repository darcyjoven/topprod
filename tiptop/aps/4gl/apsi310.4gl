# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi310.4gl
# Descriptions...: APS 品項分配法則維護
# Date & Author..: NO.FUN-850114 08/01/17 BY yiting
# Modify.........: NO.FUN-840209 08/05/13 BY Duke         
# Modify.........: NO.FUN-880010 08/08/08 By Duke add delete action
# Modify.........: No.FUN-910005 09/01/06 By Duke add 是否視為無供給法則 0:否 1:是
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0129 09/10/26 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vml           RECORD LIKE vml_file.*, #FUN-720043
    g_vml_t         RECORD LIKE vml_file.*, 
    g_vml01         LIKE vml_file.vml01,      #需求訂單編號
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
    INITIALIZE g_vml.* TO NULL
    INITIALIZE g_vml_t.* TO NULL
 
#   LET g_forupd_sql = "SELECT * FROM vml_file WHERE rowid = ? FOR UPDATE"   #TQC-9A0129 Mark
    LET g_forupd_sql = "SELECT * FROM vml_file WHERE vml01 = ? AND vml02 = ? AND vml03 = ? AND vml04 = ? FOR UPDATE"   #TQC-9A0129 Add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i310_w AT p_row,p_col
      WITH FORM "aps/42f/apsi310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_vml.vml01 = ARG_VAL(1)
    LET g_vml.vml02 = ARG_VAL(2)
    LET g_vml.vml03 = ARG_VAL(3)
    LET g_vml.vml04 = ARG_VAL(4)
    IF g_vml.vml01 IS NOT NULL AND  g_vml.vml01 != ' '
       THEN LET g_flag = 'Y'
            CALL i310_q()
       ELSE LET g_flag = 'N'
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL i310_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i310_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i310_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "     vml01='",g_vml.vml01,"'",
                  " AND vml02='",g_vml.vml02,"'",
                  " AND vml03='",g_vml.vml03,"'",
                  " AND vml04='",g_vml.vml04,"'"
    ELSE
   INITIALIZE g_vml.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vml01,
          vml02, 
          vml03,
          vml04,
          vml05  #FUN-910005  ADD
 
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
 
    LET g_sql = "SELECT vml01,vml02,vml03,vml04,vml05 FROM vml_file ",   # 組合出 SQL 指令  #FUN-910005 ADD vml05
        " WHERE ",g_wc CLIPPED, " ORDER BY vml01,vml02,vml03,vml04,vml05"
    PREPARE i310_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i310_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i310_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vml_file WHERE ",g_wc CLIPPED
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
        #FUN-880010
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i310_d()
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
           CALL i310_u()
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
 
        ON ACTION first
            CALL i310_fetch('F')

        ON ACTION last
            CALL i310_fetch('L')
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_vml.vml01) AND
                  NOT cl_null(g_vml.vml02) AND
                  NOT cl_null(g_vml.vml03) AND
                  NOT cl_null(g_vml.vml04) AND 
                  NOT cl_null(g_vml.vml05) THEN  #FUN-910005 ADD
                  LET g_doc.column1 = "vml01"
                  LET g_doc.column2 = "vml02"
                  LET g_doc.column3 = "vml03"
                  LET g_doc.column4 = "vml04"
                  LET g_doc.column5 = "vml05"   #FUN-910005 ADD
                  LET g_doc.value1 = g_vml.vml01
                  LET g_doc.value2 = g_vml.vml02
                  LET g_doc.value3 = g_vml.vml03
                  LET g_doc.value4 = g_vml.vml04
                  LET g_doc.value5 = g_vml.vml05 #FUN-910005 ADD
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i310_cs
END FUNCTION
 
 
FUNCTION i310_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vml.* LIKE vml_file.*
    LET g_vml.vml05 = 0  #FUN-910005 ADD
    LET g_vml_t.*=g_vml.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i310_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vml.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_vml.vml01) OR                  # KEY 不可空白
           cl_null(g_vml.vml02) OR
           cl_null(g_vml.vml03) OR
           cl_null(g_vml.vml04) OR 
           cl_null(g_vml.vml05) THEN    #FUN-910005  ADD
            CONTINUE WHILE
        END IF
        INSERT INTO vml_file VALUES(g_vml.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vml_file",g_vml.vml01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vml_t.* = g_vml.*                # 保存上筆資料
            SELECT vml01 INTO g_vml.vml01 FROM vml_file
             WHERE vml01      = g_vml.vml01
               AND vml02      = g_vml.vml02
               AND vml03    = g_vml.vml03
               AND vml04 = g_vml.vml04
               AND vml05 = g_vml.vml05   #FUN-910005 ADD
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#FUN-880010  add
FUNCTION i310_d()
  IF g_vml.vml01 IS NULL or 
     g_vml.vml02 IS NULL or
     g_vml.vml03 IS NULL or
     g_vml.vml04 IS NULL or 
     g_vml.vml05 IS NULL THEN  #FUN-910005 ADD
     RETURN
  END IF
  IF cl_confirm('lib-001') THEN
     DELETE from vml_file 
       WHERE  vml01=g_vml.vml01
         AND  vml02=g_vml.vml02
         AND  vml03=g_vml.vml03
         AND  vml04=g_vml.vml04
         AND  vml05=g_vml.vml05  #FUN-910005 ADD
     IF SQLCA.sqlcode THEN
         CALL cl_err3("del","vml_file",g_vml.vml01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
    INITIALIZE g_vml.* TO NULL
    INITIALIZE g_vml_t.* TO NULL
    CLEAR  FORM
  END IF      
END FUNCTION
 
FUNCTION i310_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_cnt        LIKE type_file.num5
 
    DISPLAY BY NAME 
        g_vml.vml01     ,
        g_vml.vml02     ,
        g_vml.vml03   ,
        g_vml.vml04   ,
        g_vml.vml05  #FUN-910005 ADD
    INPUT BY NAME   
        g_vml.vml01     ,
        g_vml.vml02     ,
        g_vml.vml03   ,
        g_vml.vml04   ,
        g_vml.vml05   #FUN-910005 ADD
        WITHOUT DEFAULTS
 
    #NO.FUN-840209 modify by duke begin 
        AFTER FIELD vml01
           LET l_cnt = 0 
           IF NOT cl_null(g_vml.vml01) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM ima_file
                WHERE ima01 = g_vml.vml01
                  and imaacti='Y'
               IF l_cnt = 0 THEN
                   CALL cl_err('','asf-399',0)
                   NEXT FIELD vml01
               END IF
           END IF
 
        AFTER FIELD vml03
           LET l_cnt = 0 
           IF NOT cl_null(g_vml.vml03) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM ima_file
                WHERE ima01 = g_vml.vml03
                  and imaacti='Y'
               IF l_cnt = 0 THEN
                   CALL cl_err('','asf-399',0)
                   NEXT FIELD vml03
               END IF
           END IF
     #NO.FUN-840209 modify by duke end 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vml01
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
 
FUNCTION i310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i310_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vml.* TO NULL
        RETURN
    END IF
    OPEN i310_count
    FETCH i310_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vml.vml01,SQLCA.sqlcode,0)
        INITIALIZE g_vml.* TO NULL
    ELSE
        CALL i310_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i310_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i310_cs INTO g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
        WHEN 'P' FETCH PREVIOUS i310_cs INTO g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
        WHEN 'F' FETCH FIRST    i310_cs INTO g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
        WHEN 'L' FETCH LAST     i310_cs INTO g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
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
            FETCH ABSOLUTE l_abso i310_cs INTO g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vml.vml01 CLIPPED,'+',g_vml.vml02 CLIPPED,'+',g_vml.vml03 CLIPPED,'+',g_vml.vml04 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,1)
        INITIALIZE g_vml.* TO NULL          
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
 
SELECT * INTO g_vml.* FROM vml_file            
WHERE vml01 = g_vml.vml01 AND vml02 = g_vml.vml02 AND vml03 = g_vml.vml03 AND vml04 = g_vml.vml04
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vml.vml01 CLIPPED
         CALL cl_err3("sel","vml_file",g_vml.vml01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vml.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i310_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i310_show()
    LET g_vml_t.* = g_vml.*
    DISPLAY BY NAME 
        g_vml.vml01     ,
        g_vml.vml02     ,
        g_vml.vml03   ,
        g_vml.vml04,
        g_vml.vml05    #FUN-910005 ADD
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i310_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vml.vml01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vml01 = g_vml.vml01
    BEGIN WORK
 
    OPEN i310_cl USING g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_vml.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vml.vml01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i310_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i310_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vml.* = g_vml_t.*
            CALL i310_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vml_file SET vml_file.* = g_vml.*    # 更新DB
            WHERE vml01 = g_vml_t.vml01 AND vml02 = g_vml_t.vml02 AND vml03 = g_vml_t.vml03 AND vml04 = g_vml_t.vml04               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vml.vml01 CLIPPED
            CALL cl_err3("upd","vml_file",g_vml01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vml_t.* = g_vml.*# 保存上筆資料
            SELECT vml01 INTO g_vml.vml01 FROM vml_file
             WHERE vml01      = g_vml.vml01
               AND vml02      = g_vml.vml02
               AND vml03    = g_vml.vml03
               AND vml04 = g_vml.vml04
               AND vml05 = g_vml.vml05  #FUN-910005 ADD
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i310_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i310_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vml.vml01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i310_cl USING g_vml.vml01,g_vml.vml02,g_vml.vml03,g_vml.vml04
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_vml.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vml.vml01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i310_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vml01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vml02"          #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "vml03"          #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "vml04"          #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "vml05"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vml.vml01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vml.vml02       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_vml.vml03       #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_vml.vml04       #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_vml.vml05       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            DELETE FROM vml_file WHERE vml01 = g_vml.vml01 AND vml02 = g_vml.vml02 AND vml03 = g_vml.vml03 AND vml04 = g_vml.vml04
            CLEAR FORM
    END IF
    CLOSE i310_cl
    INITIALIZE g_vml.* TO NULL
    COMMIT WORK
END FUNCTION
