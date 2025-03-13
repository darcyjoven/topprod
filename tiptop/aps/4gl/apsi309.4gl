# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apsi309.4gl
# Descriptions...: APS 供應商維護
# Date & Author..: NO.FUN-850114 08/02/29 BY yiting
# Modify.........: No.FUN-840209 08/05/20 BY DUKE CHEKC SOME DATA MUST >=0
# Modify.........: No.FUN-860060 08/06/23 by duke
# Modify.........: NO.TQC-940088 09/05/06 BY destiny _a()函數里的where條件缺少一個KEY
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0129 09/10/26 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50004 11/05/03 By Abby---GP5.25 追版---str------------------------------
# Modify.........: No:FUN-930149 09/03/25 By Duke 加show vmk19 供應商型態
# Modify.........: No.CHI-960033 09/08/03 By chenmoyan 加pmh22為條件者，再加pmh23=' '
# Modify.........: No.FUN-9A0033 09/10/12 By Mandy apmi254維護APS資料維護(apsi309)時,vmk_file資料沒有產生
# Modify.........: FUN-B50004 11/05/03 By Abby---GP5.25 追版---end------------------------------
# Modify.........: No.FUN-B90039 11/09/06 By Abby 增加欄位：最少採購數量；採購單位批量
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmk           RECORD LIKE vmk_file.*, #FUN-720043
    g_vmk_t         RECORD LIKE vmk_file.*,  #FUN-850114
    g_vmk01         LIKE vmk_file.vmk01,        #原物料品號
    g_vmk02         LIKE vmk_file.vmk02,        #FUN-9A0033 add
    g_vmk19         LIKE vmk_file.vmk19,        #FUN-9A0033 add
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

   #FUN-9A0033---mod---str---
    LET g_vmk01        = ARG_VAL(1)
    LET g_vmk02        = ARG_VAL(2)
    LET g_vmk19        = ARG_VAL(3)
   #LET g_vmk.vmk01    = ARG_VAL(1)
   #LET g_vmk.vmk02    = ARG_VAL(2)
   #LET g_vmk.vmk19    = ARG_VAL(3)  #FUN-930149 ADD
   #FUN-9A0033---mod---end---
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
    INITIALIZE g_vmk.* TO NULL
    INITIALIZE g_vmk_t.* TO NULL

    #FUN-9A0033---add---str----
    LET g_vmk.vmk01    = g_vmk01
    LET g_vmk.vmk02    = g_vmk02
    LET g_vmk.vmk19    = g_vmk19
    #FUN-9A0033---add---end----
 
    LET g_forupd_sql = "SELECT * FROM vmk_file WHERE vmk01 = ? AND vmk02 = ? FOR UPDATE"   #TQC-9A0129 Add 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i309_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i309_w WITH FORM "aps/42f/apsi309"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_vmk.vmk01    = ARG_VAL(1)
    LET g_vmk.vmk02 = ARG_VAL(2)
    IF g_vmk.vmk01 IS NOT NULL AND  g_vmk.vmk01 != ' '
       THEN LET g_flag = 'Y'
            CALL i309_q()
       ELSE LET g_flag = 'N'
    END IF
 
      LET g_action_choice=""
      CALL i309_menu()
 
    CLOSE WINDOW i309_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i309_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = " vmk01 ='",g_vmk.vmk01,"'",
                  " AND vmk02='",g_vmk.vmk02,"'",
                  " AND vmk19='",g_vmk.vmk19,"'"  #FUN-930149 ADD
    ELSE
   INITIALIZE g_vmk.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
              vmk01,
              vmk02,
              vmk05,
              vmk20, #FUN-B90039 add
              vmk21, #FUN-B90039 add
              vmk10,
              vmk11,
              vmk12,
              vmk13,
              vmk15,
              vmk16,
              vmk17    
 
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
 
    LET g_sql = "SELECT vmk01,vmk02 FROM vmk_file ",   # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY vmk01,vmk02"
    PREPARE i309_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i309_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i309_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vmk_file WHERE ",g_wc CLIPPED
    PREPARE i309_precount FROM g_sql
    DECLARE i309_count CURSOR FOR i309_precount
END FUNCTION
 
FUNCTION i309_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i309_q()
           END IF
        ON ACTION first
           CALL i309_fetch('F')
        ON ACTION next
           CALL i309_fetch('N')
        ON ACTION previous
           CALL i309_fetch('P')
        ON ACTION last
           CALL i309_fetch('L')
        ON ACTION jump
           CALL i309_fetch('/')
        ON ACTION modify
           CALL i309_u()
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
               IF g_vmk.vmk01 IS NOT NULL AND 
                  g_vmk.vmk02 IS NOT NULL THEN
                  LET g_doc.column1 = "vmk01"
                  LET g_doc.column2 = "vmk02"
                  LET g_doc.value1 = g_vmk.vmk01
                  LET g_doc.value2 = g_vmk.vmk02
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i309_cs
END FUNCTION
 
 
FUNCTION i309_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vmk.* LIKE vmk_file.*
 
    LET g_vmk_t.*=g_vmk.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vmk.vmk01 = NULL
        LET g_vmk.vmk02 = NULL
        LET g_vmk.vmk05 = 999999
        LET g_vmk.vmk10 = 0
        LET g_vmk.vmk11 = 1
        LET g_vmk.vmk12 = 0
        LET g_vmk.vmk13 = 1
        LET g_vmk.vmk15 = 0
        LET g_vmk.vmk16 = 0
        LET g_vmk.vmk17 = 0
        CALL i309_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vmk.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vmk.vmk01 IS NULL OR
           g_vmk.vmk02 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vmk_file VALUES(g_vmk.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmk_file",g_vmk.vmk01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            update ima_file set imadate=g_today where ima01=g_vmk.vmk01   #FUN-860060 
            LET g_vmk_t.* = g_vmk.*                # 保存上筆資料
            SELECT vmk01.vmk02 INTO g_vmk.vmk01,g_vmk.vmk02 FROM vmk_file
                WHERE vmk01 = g_vmk.vmk01
                  AND vmk02 = g_vmk.vmk02                                  #No.TQC-940088  
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i309_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME 
        g_vmk.vmk01,
        g_vmk.vmk02,
        g_vmk.vmk05,
        g_vmk.vmk20, #FUN-B90039 add
        g_vmk.vmk21, #FUN-B90039 add
        g_vmk.vmk10,
        g_vmk.vmk11,
        g_vmk.vmk12,
        g_vmk.vmk13,
        g_vmk.vmk15,
        g_vmk.vmk16,
        g_vmk.vmk17  
    INPUT BY NAME   
        g_vmk.vmk01,
        g_vmk.vmk02,
        g_vmk.vmk05,
        g_vmk.vmk20, #FUN-B90039 add
        g_vmk.vmk21, #FUN-B90039 add
        g_vmk.vmk10,
        g_vmk.vmk11,
        g_vmk.vmk12,
        g_vmk.vmk13,
        g_vmk.vmk15,
        g_vmk.vmk16,
        g_vmk.vmk17  
        WITHOUT DEFAULTS
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vmk01
           END IF
 
        AFTER FIELD vmk05
           IF NOT cl_null(g_vmk.vmk05) and g_vmk.vmk05<0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmk05
           END IF
        AFTER FIELD vmk10
           IF NOT cl_null(g_vmk.vmk10) and g_vmk.vmk10 < 0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmk10
           END IF
        AFTER FIELD vmk11
           IF NOT cl_null(g_vmk.vmk11) and g_vmk.vmk11 < 0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmk11
           END IF
        AFTER FIELD vmk13
           IF NOT cl_null(g_vmk.vmk13) and g_vmk.vmk13 < 0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmk13
           END IF
        AFTER FIELD vmk16
           IF NOT cl_null(g_vmk.vmk16) and g_vmk.vmk16 < 0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmk16
           END IF
        AFTER FIELD vmk17
           IF NOT cl_null(g_vmk.vmk17) and g_vmk.vmk17 < 0 THEN
              CALL cl_err('','aps-406',0)
              NEXT FIELD vmk17
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
 
FUNCTION i309_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i309_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vmk.* TO NULL
        RETURN
    END IF
    OPEN i309_count
    FETCH i309_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i309_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmk.vmk01,SQLCA.sqlcode,0)
        INITIALIZE g_vmk.* TO NULL
    ELSE
        CALL i309_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i309_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i309_cs INTO g_vmk.vmk01,g_vmk.vmk02
        WHEN 'P' FETCH PREVIOUS i309_cs INTO g_vmk.vmk01,g_vmk.vmk02
        WHEN 'F' FETCH FIRST    i309_cs INTO g_vmk.vmk01,g_vmk.vmk02
        WHEN 'L' FETCH LAST     i309_cs INTO g_vmk.vmk01,g_vmk.vmk02
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
            FETCH ABSOLUTE l_abso i309_cs INTO g_vmk.vmk01,g_vmk.vmk02
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmk.vmk01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vmk.* TO NULL          
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
 
SELECT * INTO g_vmk.* FROM vmk_file            
WHERE vmk01 = g_vmk.vmk01 AND vmk02 = g_vmk.vmk02
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmk.vmk01 CLIPPED
         CALL cl_err3("sel","vmk_file",g_vmk.vmk01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vmk.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i309_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i309_show()
    LET g_vmk_t.* = g_vmk.*
    DISPLAY BY NAME 
        g_vmk.vmk01,
        g_vmk.vmk02,
        g_vmk.vmk05,
        g_vmk.vmk20, #FUN-B90039 add
        g_vmk.vmk21, #FUN-B90039 add
        g_vmk.vmk10,
        g_vmk.vmk11,
        g_vmk.vmk12,
        g_vmk.vmk13,
        g_vmk.vmk15,
        g_vmk.vmk16,
        g_vmk.vmk17,  
        g_vmk.vmk19  #FUN-930149 ADD 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i309_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmk.vmk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmk01 = g_vmk.vmk01
    BEGIN WORK
 
    OPEN i309_cl USING g_vmk.vmk01,g_vmk.vmk02
    IF STATUS THEN
       CALL cl_err("OPEN i309_cl:", STATUS, 1)
       CLOSE i309_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i309_cl INTO g_vmk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmk.vmk01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i309_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i309_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmk.* = g_vmk_t.*
            CALL i309_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmk_file SET vmk_file.* = g_vmk.*    # 更新DB
            WHERE vmk01 = g_vmk_t.vmk01 AND vmk02 = g_vmk_t.vmk02               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vmk.vmk01 CLIPPED
            CALL cl_err3("upd","vmk_file",g_vmk01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            #FUN-930149  ADD  --STR--------------------------
             UPDATE pmh_file SET pmhdate = SYSDATE
              WHERE pmh01 = g_vmk.vmk01
                AND pmh02 = g_vmk.vmk02
                AND pmh22 = g_vmk.vmk19
                AND pmh23 = ' '                                            #No.CHI-960033
            #FUN-930149  ADD  --END--------------------------
            UPDATE ima_file set imadate=g_today  where ima01=g_vmk.vmk01  #FUN-860060
            LET g_vmk_t.* = g_vmk.*# 保存上筆資料
            SELECT vmk01.vmk02 INTO g_vmk.vmk01,g_vmk.vmk02 FROM vmk_file
             WHERE vmk01    = g_vmk.vmk01
               AND vmk02 = g_vmk.vmk02
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i309_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i309_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmk.vmk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i309_cl USING g_vmk.vmk01,g_vmk.vmk02
    IF STATUS THEN
       CALL cl_err("OPEN i309_cl:", STATUS, 1)
       CLOSE i309_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i309_cl INTO g_vmk.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmk.vmk01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i309_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vmk02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmk.vmk01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vmk.vmk02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM vmk_file WHERE vmk01 = g_vmk.vmk01 AND vmk02 = g_vmk.vmk02
            UPDATE ima_file set imadate=g_today  where ima01=g_vmk.vmk01  #FUN-860060
            CLEAR FORM
    END IF
    CLOSE i309_cl
    INITIALIZE g_vmk.* TO NULL
    COMMIT WORK
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#FUN-B50004
