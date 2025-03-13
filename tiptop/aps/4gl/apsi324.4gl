# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi324.4gl
# Descriptions...: APS 鎖定使用設備維護  #FUN-850114
# Date & Author..: NO.FUN-840209 08/05/15 BY DUKE 依參數傳遞判斷製令編號,途程編號,加工序號,作業編號是否允許輸入
# Modify.........: NO.FUN-860060 08/06/23 BY DUKE
# Modify.........: NO.FUN-870027 08/07/03 BY DUKE 
# Modify.........: NO.TQC-890030 08/09/05 By Mandy sfb04 = '8',sfb87 = 'X',sfb87 = 'Y'時,不可做修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0129 09/10/26 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    g_sfb           RECORD LIKE sfb_file.*,   #TQC-890030
    g_vng           RECORD LIKE vng_file.*,   #FUN-720043
    g_vng_t         RECORD LIKE vng_file.*, 
    g_vng01         LIKE vng_file.vng01,      #需求訂單編號 
    g_vng02         LIKE vng_file.vng02,      #
    g_vng03         LIKE vng_file.vng03,      #
    g_vng04         LIKE vng_file.vng04,      #
    g_vng11         LIKE vng_file.vng11,
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE  g_jump          LIKE type_file.num10         #查詢指定的筆數
DEFINE  mi_no_ask       LIKE type_file.num5          #是否開啟指定筆視窗
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE   g_before_input_done   STRING
 
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
    INITIALIZE g_vng.* TO NULL
    INITIALIZE g_vng_t.* TO NULL
 
#   LET g_forupd_sql = "SELECT * FROM vng_file WHERE rowid = ? FOR UPDATE"   #TQC-9A0129 Mark
    LET g_forupd_sql = "SELECT * FROM vng_file WHERE vng01 = ? AND vng02 = ? AND vng03 = ? AND vng04 = ? FOR UPDATE"   #TQC-9A0129 Add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i324_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i324_w AT p_row,p_col
      WITH FORM "aps/42f/apsi324"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    LET g_vng.vng01  = ARG_VAL(1)
    LET g_vng.vng02  = ARG_VAL(2)
    LET g_vng.vng03  = ARG_VAL(3)
    LET g_vng.vng04  = ARG_VAL(4)
    LET g_vng.vng11  = ARG_VAL(5)
    LET g_vng01  = ARG_VAL(1)
    LET g_vng02  = ARG_VAL(2)
    LET g_vng03  = ARG_VAL(3)
    LET g_vng04  = ARG_VAL(4)
    LET g_vng11  = ARG_VAL(5)
 
 
    IF NOT (cl_null(g_vng.vng01) AND cl_null(g_vng.vng02) AND cl_null(g_vng.vng03)
       AND cl_null(g_vng.vng04)) 
       THEN LET g_flag = 'Y'
            CALL i324_q()
            # CALL i324_u()  #FUN-870027
       ELSE 
           LET g_flag = 'N'
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL i324_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i324_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i324_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       #FUN-840209----Modify------------- 
       LET g_wc = " vng01='",g_vng.vng01,"'",
                  "  AND vng02 ='",g_vng.vng02,"'",
                  "  AND vng03 ='",g_vng.vng03,"'",
                  "  AND vng04 ='",g_vng.vng04,"'"
    ELSE
   INITIALIZE g_vng.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vng01,
          vng02,
          vng03, 
          vng04,
          vng06,
          #vng07,vng08,   #FUN-860060
          vng10,
          vng11
 
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
 
    LET g_sql = "SELECT vng01,vng02,vng03,vng04 FROM vng_file ",   # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY vng01,vng02,vng03,vng04"
    PREPARE i324_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i324_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i324_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vng_file WHERE ",g_wc CLIPPED
    PREPARE i324_precount FROM g_sql
    DECLARE i324_count CURSOR FOR i324_precount
END FUNCTION
 
FUNCTION i324_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#        ON ACTION insert
#            LET g_action_choice="insert"
#            IF cl_chk_act_auth() THEN
#               CALL i324_a()
#               IF g_flag = 'Y' THEN
#                   CALL i324_q()
#               END IF
#            END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i324_q()
           END IF
        ON ACTION next
           CALL i324_fetch('N')
        ON ACTION previous
           CALL i324_fetch('P')
        ON ACTION modify
           CALL i324_u()
#        ON ACTION delete
#            LET g_action_choice="delete"
#            IF cl_chk_act_auth() THEN
#                CALL i324_r()
#            END IF
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
               IF g_vng.vng01 IS NOT NULL 
                  AND g_vng.vng02 IS NOT NULL
                  AND g_vng.vng03 IS NOT NULL
                  AND g_vng.vng04 IS NOT NULL THEN
                  LET g_doc.column1 = "vng01"
                  LET g_doc.value1 = g_vng.vng01
                  LET g_doc.column2 = "vng02"
                  LET g_doc.value2 = g_vng.vng02
                  LET g_doc.column3 = "vng03"
                  LET g_doc.value3 = g_vng.vng03
                  LET g_doc.column4 = "vng04"
                  LET g_doc.value4 = g_vng.vng04
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i324_cs
END FUNCTION
 
FUNCTION i324_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    #FUN-840209---------Modify-------start------
    IF g_flag='N' then
      CLEAR FORM                                   # 清螢墓欄位內容
      INITIALIZE g_vng.* LIKE vng_file.*
      LET g_vng.vng01 = NULL
      LET g_vng.vng02 = NULL
      LET g_vng.vng03 = NULL
      LET g_vng.vng04 = NULL
      LET g_vng.vng06 = NULL
      LET g_vng.vng10 = NULL
      LET g_vng.vng11 = NULL
    ELSE
      LET g_vng.vng01 = g_vng01
      LET g_vng.vng02 = g_vng02
      LET g_vng.vng03 = g_vng03
      LET g_vng.vng04 = g_vng04
      LET g_vng.vng06 = NULL
      LET g_vng.vng10 = NULL
      LET g_vng.vng11 = g_vng11
 
    END IF
    #FUN-840209--------Modify---------end--------
 
    LET g_vng_t.*=g_vng.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i324_i("a")                         #各欄位輸入
        #FUN-840209------Modify-----begin-----
        IF INT_FLAG THEN                         #若按了DEL鍵
            IF g_flag='N' THEN
               INITIALIZE g_vng.* TO NULL
               LET INT_FLAG = 0
               CALL cl_err('',9001,0)
               CLEAR FORM
            ELSE
               LET INT_FLAG = 0
               CALL cl_err('',9001,0)
               LET g_vng.vng06 = NULL 
               LET g_vng.vng10 = NULL
            END IF 
            EXIT WHILE
        END IF
        #FUN-840209--------Modify--------end-----
        IF g_vng.vng01 IS NULL OR
           g_vng.vng02 IS NULL OR
           g_vng.vng03 IS NULL OR
           g_vng.vng04 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vng_file VALUES(g_vng.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vng_file",g_vng.vng01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vng_t.* = g_vng.*                # 保存上筆資料
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i324_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME 
        g_vng.vng01,
        g_vng.vng02,
        g_vng.vng03,
        g_vng.vng04,
        g_vng.vng06,
        g_vng.vng10,
        g_vng.vng11
    INPUT BY NAME   
        g_vng.vng01,
        g_vng.vng02,
        g_vng.vng03,
        g_vng.vng04,
        g_vng.vng06,
        g_vng.vng10,
        g_vng.vng11
        WITHOUT DEFAULTS
 
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i324_set_entry(p_cmd)
        CALL i324_set_no_entry(p_cmd)
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
 
FUNCTION i324_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i324_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vng.* TO NULL
        RETURN
    END IF
    OPEN i324_count
    FETCH i324_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i324_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vng.vng01,SQLCA.sqlcode,0)
        INITIALIZE g_vng.* TO NULL
    ELSE
        CALL i324_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i324_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i324_cs INTO g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
        WHEN 'P' FETCH PREVIOUS i324_cs INTO g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
        WHEN 'F' FETCH FIRST    i324_cs INTO g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
        WHEN 'L' FETCH LAST     i324_cs INTO g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
        WHEN '/'
        #FUN-840209----MARK----BEGIN----
        #    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
        #    LET INT_FLAG = 0  ######add for prompt bug
        #    PROMPT g_msg CLIPPED,': ' FOR l_abso
        #       ON IDLE g_idle_seconds
        #          CALL cl_on_idle()
        #
        #       ON ACTION about         
        #          CALL cl_about()      
        #       
        #       ON ACTION help          
        #          CALL cl_show_help()  
        #       
        #       ON ACTION controlg      
        #          CALL cl_cmdask()     
        #    END PROMPT
        #    IF INT_FLAG THEN
        #        LET INT_FLAG = 0
        #        EXIT CASE
        #    END IF
        #FUN-840209--------MARK----------END--------
 
        #FUN-840209--------ADD-----------BEGIN-----
           IF (NOT mi_no_ask) THEN                   #No.FUN-6A0066
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
        #FUN-840209--------ADD-----------END-------
 
            FETCH ABSOLUTE g_jump i324_cs INTO g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vng.vng01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vng.* TO NULL          
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vng.* FROM vng_file            
WHERE vng01 = g_vng.vng01 AND vng02 = g_vng.vng02 AND vng03 = g_vng.vng03 AND vng04 = g_vng.vng04
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vng.vng01 CLIPPED
         CALL cl_err3("sel","vng_file",g_vng.vng01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vng.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i324_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i324_show()
    LET g_vng_t.* = g_vng.*
    DISPLAY BY NAME 
        g_vng.vng01,
        g_vng.vng02,
        g_vng.vng03,
        g_vng.vng04,
        g_vng.vng06,
        g_vng.vng10,
        g_vng.vng11
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i324_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vng.vng01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #TQC-890030---add---str---
    SELECT * INTO g_sfb.*
      FROM sfb_file
     WHERE sfb01 = g_vng.vng01
    IF g_sfb.sfb04 = '8' THEN CALL cl_err('','aap-730',1) RETURN END IF
    IF g_sfb.sfb87 = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
    IF g_sfb.sfb87 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
    #TQC-890030---add---end---
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vng01 = g_vng.vng01 
    BEGIN WORK
 
    OPEN i324_cl USING g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
    IF STATUS THEN
       CALL cl_err("OPEN i324_cl:", STATUS, 1)
       CLOSE i324_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i324_cl INTO g_vng.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vng.vng01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i324_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i324_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vng.* = g_vng_t.*
            CALL i324_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vng_file SET vng_file.* = g_vng.*    # 更新DB
            WHERE vng01 = g_vng_t.vng01 AND vng02 = g_vng_t.vng02 AND vng03 = g_vng_t.vng03 AND vng04 = g_vng_t.vng04               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vng.vng01 CLIPPED
            CALL cl_err3("upd","vng_file",g_vng01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        ELSE
            LET g_vng_t.* = g_vng.*# 保存上筆資料
            SELECT vng01,vng02,vng03,vng04 INTO g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04 FROM vng_file
             WHERE vng01 = g_vng.vng01
               AND vng02 = g_vng.vng02
               AND vng03 = g_vng.vng03
               AND vng04 = g_vng.vng04
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i324_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i324_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vng.vng01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i324_cl USING g_vng.vng01,g_vng.vng02,g_vng.vng03,g_vng.vng04
    IF STATUS THEN
       CALL cl_err("OPEN i324_cl:", STATUS, 1)
       CLOSE i324_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i324_cl INTO g_vng.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vng.vng01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i324_show()
    #FUN-840209--------begin-----
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vng01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vng.vng01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vng02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vng.vng02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "vng03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_vng.vng03      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "vng04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_vng.vng04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      DELETE FROM vng_file WHERE vng01 = g_vng.vng01  and vng02=g_vng.vng02
                             and vng03=g_vng.vng03 and vng04=g_vng.vng04
      CLEAR FORM
      OPEN i324_count
      FETCH i324_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i324_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i324_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE                 
         CALL i324_fetch('/')
      END IF
    END IF
    #FUN-840209----------------end--------------
    CLOSE i324_cl
   #FUN-840209 MODIFY
   #INITIALIZE g_vng.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION i324_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
#     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
#        CALL cl_set_comp_entry("vng01,vng02,vng03,vng04",TRUE)
#     END IF
 
   #FUN-840209----------Modify--------begin--------
   IF g_flag='N' THEN
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vng01,vng02,vng03,vng04,vng11",TRUE)
      END IF
   ELSE
      CALL cl_set_comp_entry("vng01,vng02,vng03,vng04,vng11",FALSE)
   END IF
   #FUN-840209---------Modify----------end---------
 
END FUNCTION
 
FUNCTION i324_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
  IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("vng01,vng02,vng03,vng04,vng11",FALSE)
  END IF
 
 
END FUNCTION
 
 
