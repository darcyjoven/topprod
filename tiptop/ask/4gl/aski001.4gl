# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aski001.4gl
# Descriptions...: 制單主檔維護作業
# Date & Author..: No.FUN-810016 07/07/26 By hongmei
# Modify.........: No.FUN-850068 08/05/15 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-870117 08/09/09 By hongmei 過單
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940106 09/05/08 By mike 無效資料不可刪除 
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980135 09/08/24 By Dido DISPLAY BY NAME 應以指定欄位為主
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BB0183 11/11/21 By lixiang 修改權限群組的設定的BUG
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_skd       RECORD LIKE skd_file.*,
       g_skd_t     RECORD LIKE skd_file.*,  #備份舊值
       g_skd01_t   LIKE skd_file.skd01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件  
       g_sql       STRING                  #組 sql 用    
 
DEFINE g_forupd_sql          STRING                       #SELECT ... FOR UPDATE  SQL        
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令      
DEFINE g_chr                 LIKE skd_file.skdacti        
DEFINE g_cnt                 LIKE type_file.num10        
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        
DEFINE g_msg                 LIKE type_file.chr1000         
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10         #總筆數        
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE g_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #TQC-940168
   INITIALIZE g_skd.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM skd_file WHERE skd01 =? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i001_w WITH FORM "ask/42f/aski001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i001_menu()
 
   CLOSE WINDOW i001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i001_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        skd01,skd02,skd03,skd04,
        skduser,skdgrup,skdmodu,skddate,skdacti,
        #FUN-850068   ---start---
        skdud01,skdud02,skdud03,skdud04,skdud05,
        skdud06,skdud07,skdud08,skdud09,skdud10,
        skdud11,skdud12,skdud13,skdud14,skdud15
        #FUN-850068    ----end----
        
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skduser', 'skdgrup') #FUN-980030
 
#TQC-BB0183--mark--begin--
#   #資料權限的檢查
#   #Begin:FUN-980030
#   #    IF g_priv2='4' THEN                           #只能使用自己的資料
#   #        LET g_wc = g_wc clipped," AND skduser = '",g_user,"'"
#   #    END IF
#   #    IF g_priv3='4' THEN                           #只能使用相同群的資料
#       LET g_wc = g_wc clipped," AND skdgrup LIKE '",
#                  g_grup CLIPPED,"%'"
#       #CHI-8A0001 寫ora
#   #    END IF
#TQC-BB0183--mark--end--

    LET g_sql="SELECT skd01 FROM skd_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY skd01"
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i001_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM skd_file WHERE ",g_wc CLIPPED
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION
 
FUNCTION i001_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000       
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
                CALL i001_a()
           END IF
            
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i001_q()
           END IF
            
        ON ACTION next
           CALL i001_fetch('N')
            
        ON ACTION previous
           CALL i001_fetch('P')
            
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
                CALL i001_u()
           END IF
            
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
                CALL i001_x()
           END IF
            
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i001_r()
           END IF
          
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
                CALL i001_copy()
           END IF
           
#       ON ACTION output
#          LET g_action_choice="output"
#          IF cl_chk_act_auth()
#             THEN CALL i001_out()
#          END IF
            
        ON ACTION help
           CALL cl_show_help()
            
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
            
        ON ACTION jump
           CALL i001_fetch('/')
            
        ON ACTION first
           CALL i001_fetch('F')
            
        ON ACTION last
           CALL i001_fetch('L')
            
        ON ACTION controlg
           CALL cl_cmdask()
            
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
                              
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about         
           CALL cl_about()      
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
         
        ON ACTION Cut_Explain          #裁車說明
           CALL i001_1(g_skd.skd01)
 
        ON ACTION Clean_Explain        #后整說明
           CALL i001_2(g_skd.skd01)
 
        ON ACTION Embroider_Explain    #繡花說明
           CALL i001_3(g_skd.skd01)
 
        ON ACTION Launder_Explain      #洗水說明
           CALL i001_4(g_skd.skd01)
 
        ON ACTION Rest_Explain         #其他說明
           CALL i001_5(g_skd.skd01)
           
        ON ACTION Confirm  #審核
           IF cl_chk_act_auth() THEN
              CALL i001_y()
           END IF
            
        ON ACTION Undo_confirm #取消審核
           IF cl_chk_act_auth() THEN
              CALL i001_z()
           END IF           
                  
        ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_skd.skd01 IS NOT NULL THEN
                 LET g_doc.column1 = "skd01"
                 LET g_doc.value1 = g_skd.skd01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i001_cs
END FUNCTION
 
 
FUNCTION i001_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_skd.* LIKE skd_file.*
    LET g_skd01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_skd.skduser = g_user
        LET g_skd.skdgrup = g_grup               #使用者所屬群
        LET g_skd.skddate = g_today
        LET g_skd.skdacti = 'Y'
        LET g_skd.skd04 = 'N'
        LET g_skd.skdplant = g_plant #FUN-980008 add
        LET g_skd.skdlegal = g_legal #FUN-980008 add
        CALL i001_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_skd.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_skd.skd01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_skd.skdoriu = g_user      #No.FUN-980030 10/01/04
        LET g_skd.skdorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO skd_file VALUES(g_skd.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","skd_file",g_skd.skd01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT skd01 INTO g_skd.skd01 FROM skd_file
                     WHERE skd01 = g_skd.skd01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i001_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5           
 
 
   DISPLAY BY NAME
      g_skd.skd01,g_skd.skd02,g_skd.skd03,g_skd.skd04,
      g_skd.skduser,g_skd.skdgrup,g_skd.skdmodu,
      g_skd.skddate,g_skd.skdacti
 
   INPUT BY NAME
      g_skd.skd01,g_skd.skd02,g_skd.skd03,g_skd.skd04,
      g_skd.skduser,g_skd.skdgrup,g_skd.skdmodu,
      g_skd.skddate,g_skd.skdacti,
      #FUN-850068     ---start---
      g_skd.skdud01,g_skd.skdud02,g_skd.skdud03,g_skd.skdud04,
      g_skd.skdud05,g_skd.skdud06,g_skd.skdud07,g_skd.skdud08,
      g_skd.skdud09,g_skd.skdud10,g_skd.skdud11,g_skd.skdud12,
      g_skd.skdud13,g_skd.skdud14,g_skd.skdud15 
      #FUN-850068     ----end----
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i001_set_entry(p_cmd)
          CALL i001_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD skd01
         DISPLAY "AFTER FIELD skd01"
         IF g_skd.skd01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_skd.skd01 != g_skd01_t) THEN
               SELECT count(*) INTO l_n FROM skd_file WHERE skd01 = g_skd.skd01
               IF l_n > 0 THEN                   # Duplicated
                  CALL cl_err(g_skd.skd01,-239,1)
                  LET g_skd.skd01 = g_skd01_t
                  DISPLAY BY NAME g_skd.skd01
                  NEXT FIELD skd01
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('skd01:',g_errno,1)
                  LET g_skd.skd01 = g_skd01_t
                  DISPLAY BY NAME g_skd.skd01
                  NEXT FIELD skd01
               END IF
            END IF
         END IF
       
      AFTER FIELD skd02
        IF g_skd.skd02 <0 THEN 
           CALL cl_err (g_skd.skd02,'ask-001',0)
           NEXT FIELD skd02
        END IF        
 
      #FUN-850068     ---start---
      AFTER FIELD skdud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD skdud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-850068     ----end----
 
      AFTER INPUT
         LET g_skd.skduser = s_get_data_owner("skd_file") #FUN-C10039
         LET g_skd.skdgrup = s_get_data_group("skd_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_skd.skd01 IS NULL THEN
               DISPLAY BY NAME g_skd.skd01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD skd01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(skd01) THEN
            LET g_skd.* = g_skd_t.*
            CALL i001_show()
            NEXT FIELD skd01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 
 
FUNCTION i001_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_skd.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i001_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i001_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_skd.skd01,SQLCA.sqlcode,0)
        INITIALIZE g_skd.* TO NULL
    ELSE
        CALL i001_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i001_fetch(p_flskd)
    DEFINE
        p_flskd         LIKE type_file.chr1           
 
    CASE p_flskd
        WHEN 'N' FETCH NEXT     i001_cs INTO g_skd.skd01
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_skd.skd01
        WHEN 'F' FETCH FIRST    i001_cs INTO g_skd.skd01
        WHEN 'L' FETCH LAST     i001_cs INTO g_skd.skd01
        WHEN '/'
            IF (NOT g_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_skd.skd01
            LET g_no_ask = FALSE         
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_skd.skd01,SQLCA.sqlcode,0)
        INITIALIZE g_skd.* TO NULL  
        RETURN
    ELSE
      CASE p_flskd
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_skd.* FROM skd_file    # 重讀DB,因TEMP有不被更新特性
       WHERE skd01 = g_skd.skd01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","skd_file",g_skd.skd01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_skd.skduser     #權限控管
        LET g_data_group=g_skd.skdgrup
        CALL i001_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i001_show()
    LET g_skd_t.* = g_skd.*
   #-TQC-980135-add-
   #DISPLAY BY NAME g_skd.*
    DISPLAY BY NAME
       g_skd.skd01,g_skd.skd02,g_skd.skd03,g_skd.skd04,
       g_skd.skduser,g_skd.skdgrup,g_skd.skdmodu,
       g_skd.skddate,g_skd.skdacti,
       g_skd.skdud01,g_skd.skdud02,g_skd.skdud03,g_skd.skdud04,
       g_skd.skdud05,g_skd.skdud06,g_skd.skdud07,g_skd.skdud08,
       g_skd.skdud09,g_skd.skdud10,g_skd.skdud11,g_skd.skdud12,
       g_skd.skdud13,g_skd.skdud14,g_skd.skdud15 
   #-TQC-980135-add-
    CALL cl_show_fld_cont()                
END FUNCTION
 
FUNCTION i001_u()
    IF g_skd.skd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_skd.skd04 = "Y" THEN
       CALL cl_err('','ask-002',0) RETURN
    END IF
    SELECT * INTO g_skd.* FROM skd_file WHERE skd01=g_skd.skd01
    IF g_skd.skdacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_skd01_t = g_skd.skd01
    BEGIN WORK
 
    OPEN i001_cl USING g_skd.skd01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_skd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_skd.skd01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_skd.skdmodu=g_user                 #修改者
    LET g_skd.skddate = g_today              #修改日期
    CALL i001_show()                         # 顯示最新資料
    WHILE TRUE
        CALL i001_i("u")                     # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_skd.*=g_skd_t.*
            CALL i001_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE skd_file SET skd_file.* = g_skd.*    # 更新DB
            WHERE skd01 = g_skd_t.skd01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","skd_file",g_skd.skd01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_x()
    IF g_skd.skd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_skd.skd04 = "Y" THEN
       CALL cl_err('','ask-002',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN i001_cl USING g_skd.skd01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_skd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_skd.skd01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i001_show()
    IF cl_exp(0,0,g_skd.skdacti) THEN
        LET g_chr=g_skd.skdacti
        IF g_skd.skdacti='Y' THEN
            LET g_skd.skdacti='N'
        ELSE
            LET g_skd.skdacti='Y'
        END IF
        UPDATE skd_file
            SET skdacti=g_skd.skdacti
            WHERE skd01=g_skd.skd01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","skd_file",g_skd.skd01,"",SQLCA.sqlcode,"","",0) 
            LET g_skd.skdacti=g_chr
        END IF
        DISPLAY BY NAME g_skd.skdacti
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_r()
    IF g_skd.skd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_skd.skd04 = 'Y' THEN
       CALL cl_err('','ask-002',0)
       RETURN
    END IF
#TQC-940106  --start                                                                                                                
    IF g_skd.skdacti='N' THEN                                                                                                       
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
#TQC-940106  --end    
 
    BEGIN WORK
    
    OPEN i001_cl USING g_skd.skd01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 0)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_skd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_skd.skd01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "skd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_skd.skd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM skd_file WHERE skd01 = g_skd.skd01
       DELETE FROM ske_file WHERE ske01 = g_skd.skd01
                                                     
       CLEAR FORM
       OPEN i001_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i001_cs
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i001_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cs
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                
          CALL i001_fetch('/')
       END IF
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_copy()
    DEFINE
        l_newno   LIKE skd_file.skd01,
        l_oldno   LIKE skd_file.skd01,
        p_cmd     LIKE type_file.chr1,          
        l_input   LIKE type_file.chr1           
 
    IF g_skd.skd01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
    
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i001_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM skd01
 
        AFTER FIELD skd01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM skd_file
                  WHERE skd01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD skd01
              END IF
           END IF
           
       BEGIN WORK
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controlg      
          CALL cl_cmdask()     
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_skd.skd01
        RETURN
    END IF
    
    DROP TABLE y
    SELECT * FROM skd_file
        WHERE skd01 = g_skd.skd01
        INTO TEMP y
    UPDATE y
        SET skd01=l_newno,    #資料鍵值
            skd04='N',
            skdacti='Y',      #資料有效碼
            skduser=g_user,   #資料所有者
            skdgrup=g_grup,   #資料所有者所屬群
            skdmodu=NULL,     #資料修改日期
            skddate=g_today   #資料建立日期
            
    INSERT INTO skd_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","skd_file",g_skd.skd01,"",SQLCA.sqlcode,"","",0)
        ROLLBACK WORK 
        RETURN   
    ELSE
    	  COMMIT WORK 
    END IF
    
    DROP TABLE x
    
    SELECT * FROM ske_file
       WHERE ske01 = g_skd.skd01
       INTO TEMP x
    IF SQLCA.sqlcode THEN 
       CALL cl_err3("ins","ske_file","","",SQLCA.sqlcode,"","",0) 
       RETURN 
    END IF 
    
    UPDATE x SET ske01 = l_newno	  
    
    INSERT INTO ske_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ske_file","","",SQLCA.sqlcode,"","",0)
        ROLLBACK WORK 
        RETURN   
    ELSE
    	  COMMIT WORK
    END IF 
    LET g_cnt=SQLCA.sqlerrd[3]
    MESSAGE'(',g_cnt USING '##&',')ROW of(',l_newno,') O.K'
    
    LET l_oldno = g_skd.skd01
    SELECT skd_file.* INTO g_skd.* FROM skd_file
           WHERE skd01 = l_newno
    CALL i001_u()
    #SELECT skd_file.* INTO g_skd.* FROM skd_file #FUN-C80046
    #       WHERE skd01 = l_oldno       	      #FUN-C80046           
    CALL i001_show()
END FUNCTION
 
#FUNCTION i001_out()
#   DEFINE
#       l_i             LIKE type_file.num5,          
#       l_skd           RECORD LIKE skd_file.*,
#       l_name          LIKE type_file.chr20,       # External(Disk) file name       
#       sr RECORD
#          skd01 LIKE skd_file.skd01,
#          skd02 LIKE skd_file.skd02,
#          skd03 LIKE skd_file.skd03,
#          skd04 LIKE skd_file.skd04
#          END RECORD,
#       l_za05          LIKE za_file.za05        
#
#   IF g_wc IS NULL THEN LET g_wc=" skd01='",g_skd.skd01,"'" END IF
#   #改成印當下的那一筆資料內容
#
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT skd01,skd02,skd03,skd04 ",
#             " FROM skd_file ",
#             "  AND ",g_wc CLIPPED
#
#   PREPARE i001_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i001_curo                         # SCROLL CURSOR
#        CURSOR FOR i001_p1
 
#   CALL cl_outnam('aski001') RETURNING l_name
#   START REPORT i001_rep TO l_name
 
#   FOREACH i001_curo INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i001_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i001_rep
 
#   CLOSE i001_curo
#   ERROR ""
#   CALL cl_prt_cs1('amdr300','amdr300',g_sql,g_str)
#END FUNCTION
 
#REPORT i001_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          
#        sr RECORD
#           skd01 LIKE skd_file.skd01,
#           skd02 LIKE skd_file.skd02,
#           skd03 LIKE skd_file.skd03,
#           skd04 LIKE skd_file.skd04
#           END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   
#
#    ORDER BY sr.skd01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.skd01,
#                  COLUMN g_c[32],sr.skd02,
#                  COLUMN g_c[33],sr.skd03,
#                  COLUMN g_c[34],sr.skd04
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                  g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                      g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
 
FUNCTION i001_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("skd01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i001_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("skd01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i001_y()   #確認
   DEFINE l_n    LIKE type_file.num5,
          l_n1   LIKE type_file.num5
 
    IF cl_null(g_skd.skd01)  THEN      
       CALL cl_err('',-400,0)                                            
       RETURN                                                             
    END IF                                                                
    IF g_skd.skd04="Y" THEN                                              
       CALL cl_err("",9023,1)                                             
       RETURN                                                             
    END IF
    IF g_skd.skdacti="N" THEN                                              
       CALL cl_err("",'ask-033',1) 
       RETURN                                                              
    END IF 
 
    IF cl_confirm('ask-034') THEN                                                                     
       BEGIN WORK 
                                                              
       UPDATE skd_file                                                    
          SET skd04="Y"                                                   
        WHERE skd01=g_skd.skd01
 
        IF SQLCA.sqlcode THEN                                             
            CALL cl_err3("upd","skd_file",g_skd.skd01,g_skd.skd02,SQLCA.sqlcode,"","skd04",1)                                            
            ROLLBACK WORK                                                 
        ELSE                                                             
            COMMIT WORK                                                 
            LET g_skd.skd04="Y"                                          
            DISPLAY BY NAME g_skd.skd04
        END IF
    END IF
END FUNCTION
 
FUNCTION i001_z()
 
   DEFINE l_n    LIKE type_file.num5
   
    IF cl_null(g_skd.skd01) THEN             
       CALL cl_err('',-400,0)                                            
       RETURN                                                              
    END IF
    IF g_skd.skd04="N" OR g_skd.skdacti="N" THEN                          
        CALL cl_err("",'ask-035',1) 
        RETURN
    END IF
    
    SELECT COUNT(*) INTO l_n
      FROM pmli_file
     WHERE pmlislk01 = g_skd.skd01
     IF l_n > 0 THEN 
        CALL cl_err('','ask-046',0)
        RETURN
     END IF   
    SELECT COUNT(*) INTO l_n
      FROM pmni_file
     WHERE pmnislk01 = g_skd.skd01
     IF l_n > 0 THEN 
        CALL cl_err('','ask-047',0)
        RETURN
     END IF
    SELECT COUNT(*) INTO l_n
      FROM oebi_file
     WHERE oebislk01 = g_skd.skd01
     IF l_n > 0 THEN 
        CALL cl_err('','ask-048',0)
        RETURN
     END IF   
    SELECT COUNT(*) INTO l_n
      FROM sfci_file
     WHERE sfcislk01 = g_skd.skd01
     IF l_n > 0 THEN 
        CALL cl_err('','ask-049',0)
        RETURN
     END IF
      
    IF cl_confirm('ask-036') THEN  
                                       
       BEGIN WORK                                                         
       UPDATE skd_file                                                    
          SET skd04="N"                                                 
        WHERE skd01=g_skd.skd01
 
        IF SQLCA.sqlcode THEN                                
          CALL cl_err3("upd","skd_file",g_skd.skd01,g_skd.skd02,SQLCA.sqlcode,"","skd04",1)                                               
          ROLLBACK WORK
        ELSE                                                 
          COMMIT WORK                                       
          LET g_skd.skd04="N"                           
          DISPLAY BY NAME g_skd.skd04
        END IF
    END IF
END FUNCTION
#No.FUN-810016 FUN-870117

