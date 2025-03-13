# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_addview.4gl                                                                                                        
# Descriptions...: 視圖維護作業                                                                                            
# Date & Author..: 06/12/23 shine
# Modify.........: No.TQC-860017 08/06/11 by jerry 補ON IDLE段
# Modify.........: No.TQC-880048 08/08/26 by jerry 將原本變數"宣告成固定長度"的部份修正為"參照至type_file內的欄位"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-A10090 10/01/15 By baofei 10/01/15 By baofei改ROWID 為KEY 值 
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新料號畫面

DATABASE ds     # FUN-770026
 
GLOBALS "../../config/top.global" # FUN-770026
 
DEFINE g_vie       RECORD LIKE vie_file.*,
       g_vie_t     RECORD LIKE vie_file.*,  #備份舊值
       g_vie01_t   LIKE vie_file.vie01,     #Key值備份
       g_vie02_t   LIKE vie_file.vie02,
       g_wc        STRING,                  #儲存 user 的查詢條件  #No.FUN-580092 HCN
       g_sql       STRING                  #組 sql 用
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5       #判斷是否已執行 Before Input指令
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num5
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000 #TQC-880048
DEFINE g_curs_index         LIKE type_file.num5
DEFINE g_row_count          LIKE type_file.num5        #總筆數
DEFINE g_jump               LIKE type_file.num5        #查詢指定的筆數
DEFINE g_no_ask             LIKE type_file.num5       #是否開啟指定筆視窗
DEFINE g_cmd                STRING
DEFINE g_alldbs             STRING
DEFINE g_vie06              LIKE vie_file.vie06
DEFINE g_vie04              LIKE vie_file.vie04
DEFINE g_succeed            LIKE type_file.chr1 #TQC-880048
DEFINE g_db_type            LIKE type_file.chr3 #TQC-880048
DEFINE g_flag               LIKE type_file.chr1 #TQC-880048

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_db_type=cl_db_get_database_type()

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

   INITIALIZE g_vie.* TO NULL
   LET g_forupd_sql = "SELECT * FROM vie_file WHERE vie01 = ?  FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_view_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p_addview_w WITH FORM "azz/42f/p_addview"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""

   CALL p_view_alldbs()
   CALL p_view_check()
   CALL p_view_menu()
 
   CLOSE WINDOW p_view_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p_view_curs()
DEFINE ls STRING
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        vie01,vie02,vie03,vie04,vie05,vie06,vie07,vie08,vie09, # vie04,
        vieuser,viegrup,viemodu,viedate,vieacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('vieuser', 'viegrup')
 
    LET g_sql="SELECT vie01 FROM vie_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY vie01"
    PREPARE p_view_prepare FROM g_sql
    DECLARE p_view_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p_view_prepare

    LET g_sql= "SELECT COUNT(*) FROM vie_file WHERE ",g_wc CLIPPED
    PREPARE p_view_precount FROM g_sql
    DECLARE p_view_count CURSOR FOR p_view_precount
END FUNCTION
 
FUNCTION p_view_menu()

    MENU ""
        BEFORE MENU
          CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL p_view_a()
            END IF
        ON ACTION create_view
              CALL p_view_create()
        ON ACTION drop_view
              CALL p_view_drop()
        ON ACTION qry_db
            CALL p_view_qry()
        ON action put_to_query
            CALL p_view_put()
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL p_view_q()
            END IF
        ON ACTION next
            CALL p_view_fetch('N')
        ON ACTION previous
            CALL p_view_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL p_view_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL p_view_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL p_view_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL p_view_copy()
            END IF

        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL p_view_fetch('/')
        ON ACTION first
            CALL p_view_fetch('F')
        ON ACTION last
            CALL p_view_fetch('L')
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
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT PROGRAM 
           EXIT MENU
 
    END MENU
    CLOSE p_view_cs
END FUNCTION
 
 
FUNCTION p_view_a()
   DEFINE 
   li_cnt          LIKE ze_file.ze03,                                                                                              
   li_bnt          LIKE ze_file.ze03,                                                                                              
   l_i             LIKE type_file.num5
   
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vie.* LIKE vie_file.*
    LET g_vie01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vie.vieuser = g_user
        LET g_vie.vieoriu = g_user #FUN-980030
        LET g_vie.vieorig = g_grup #FUN-980030
        LET g_vie.viegrup = g_grup               #使用者所屬群
        LET g_vie.viedate = g_today
        LET g_vie.vieacti = 'Y'
#        LET g_vie.vie04 ='N'
        LET g_vie.vie07 ='Y'
        LET g_vie.vie08 ='N'
        LET g_vie.vie09 ='N'
        LET g_vie.vie05 ='0'
        LET g_vie.vie06 =g_dbs
#        LET g_vie.vie10 ='N'
        CALL p_view_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_vie.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vie.vie01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vie_file VALUES(g_vie.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_vie.vie01,SQLCA.sqlcode,0)    #No.FUN-660131
            CALL cl_err3("ins","vie_file",g_vie.vie01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
           # SELECT ROWID INTO g_vie_rowid FROM vie_file   #FUN-A10090
           SELECT vie01  INTO g_vie.vie01 FROM vie_file   #FUN-A10090
                     WHERE vie01 = g_vie.vie01
           CALL cl_getmsg('cre-001',g_lang) RETURNING li_cnt 
           CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt                                                               
           MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
           ON ACTION immediately                                                                                              
              LET l_i = TRUE                                                                                             
              CALL p_view_create()
              EXIT MENU
                                                                                                              
           ON ACTION lateon                                                                                                
              RETURN                                                                                                      
              EXIT MENU                                                                                                   
#TQC-860017 start
  
           ON ACTION about         
              CALL cl_about()      
 
           ON ACTION controlg      
              CALL cl_cmdask()     
 
           ON ACTION help          
              CALL cl_show_help()
  
           ON IDLE g_idle_seconds 
              CALL cl_on_idle() 
             CONTINUE MENU
#TQC-860017 end
          END MENU           
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION p_view_i(p_cmd)
   DEFINE  p_cmd     LIKE type_file.chr1, #TQC-880048
           l_gen02   LIKE gen_file.gen02,
           l_gen03   LIKE gen_file.gen03,
           l_gen04   LIKE gen_file.gen04,
           l_gem02   LIKE gem_file.gem02,
           l_input   LIKE type_file.chr1, #TQC-880048
           l_n       LIKE type_file.num5,
           l_zai01   LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_vie.vie01,g_vie.vie02,g_vie.vie03,g_vie.vie04,g_vie.vie05,g_vie.vie06,g_vie.vie07,
      g_vie.vie08,g_vie.vie09,
      g_vie.vieuser,g_vie.viegrup,g_vie.viemodu,
      g_vie.viedate,g_vie.vieacti
 
   INPUT BY NAME
      g_vie.vie01,g_vie.vie02,g_vie.vie03,g_vie.vie04,g_vie.vie05,g_vie.vie06,g_vie.vie07,
      g_vie.vie08,g_vie.vie09,
      g_vie.vieuser,g_vie.viegrup,g_vie.viemodu,
      g_vie.viedate,g_vie.vieacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          IF p_cmd = 'a' THEN 
             LET g_vie.vie09 = 'N'
          END IF 
          IF p_cmd ='u' AND g_vie.vie08 ='Y' THEN 
             CALL cl_set_comp_entry("vie03,vie04,vie05,vie07",FALSE )
          END IF 
          IF p_cmd ='u' AND g_vie.vie08 ='N' THEN 
             CALL cl_set_comp_entry("vie03,vie04,vie05,vie07",TRUE )
          END IF
          IF g_db_type="IFX" THEN
             CALL cl_set_comp_entry("vie07,vie05",FALSE)
          END IF 
          LET g_before_input_done = FALSE
          CALL p_view_set_entry(p_cmd)
          CALL p_view_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD vie01
         IF g_vie.vie01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_vie.vie01 != g_vie01_t) THEN
               SELECT count(*) INTO l_n FROM vie_file WHERE vie01 = g_vie.vie01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_vie.vie01,-239,1)
                  LET g_vie.vie01 = g_vie01_t
                  DISPLAY BY NAME g_vie.vie01
                  NEXT FIELD vie01
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('vie01:',g_errno,1)
                  LET g_vie.vie01 = g_vie01_t
                  DISPLAY BY NAME g_vie.vie01
                  NEXT FIELD vie01
               END IF
            END IF
         END IF
         
      AFTER FIELD vie02 
         IF g_vie.vie01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_vie.vie02 != g_vie02_t) OR (cl_null(g_vie02_t))  THEN
               SELECT COUNT(*) INTO l_zai01 FROM zai_file WHERE zai01 = g_vie.vie02
               IF l_zai01 > 0 THEN 
                  CALL cl_err(g_vie.vie02,'vie-001',1)
                  NEXT FIELD vie02
               END IF    
             END IF 
          END IF 
          
      ON CHANGE vie05
         IF g_vie.vie05 = '0' THEN 
            LET g_vie.vie06 = g_dbs
            DISPLAY g_vie.vie06 TO vie06
         END IF 
         IF g_vie.vie05 = '1' THEN
            LET g_vie.vie06 = g_alldbs
            DISPLAY g_vie.vie06 TO vie06
         END IF 
 
      AFTER INPUT
         LET g_vie.vieuser = s_get_data_owner("vie_file") #FUN-C10039
         LET g_vie.viegrup = s_get_data_group("vie_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_vie.vie01 IS NULL THEN
               DISPLAY BY NAME g_vie.vie01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD vie01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(vie01) THEN
            LET g_vie.* = g_vie_t.*
            CALL p_view_show()
            NEXT FIELD vie01
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION p_view_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL p_view_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN p_view_count
    FETCH p_view_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN p_view_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vie.vie01,SQLCA.sqlcode,0)
        INITIALIZE g_vie.* TO NULL
    ELSE
        CALL p_view_fetch('F')              # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION p_view_fetch(p_flvie)
    DEFINE p_flvie          LIKE type_file.chr1 #TQC-880048          
 
    CASE p_flvie
        WHEN 'N' FETCH NEXT     p_view_cs INTO g_vie.vie01  #FUN-A10090
        WHEN 'P' FETCH PREVIOUS p_view_cs INTO g_vie.vie01  #FUN-A10090
        WHEN 'F' FETCH FIRST    p_view_cs INTO g_vie.vie01  #FUN-A10090
        WHEN 'L' FETCH LAST     p_view_cs INTO g_vie.vie01  #FUN-A10090

        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump p_view_cs INTO g_vie.vie01     #FUN-A10090
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vie.vie01,SQLCA.sqlcode,0)
        RETURN
    ELSE
      CASE p_flvie
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_vie.* FROM vie_file    # 重讀DB,因TEMP有不被更新特性
       WHERE vie01 = g_vie.vie01    #FUN-A10090
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vie_file",g_vie.vie01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        LET g_data_owner=g_vie.vieuser           #FUN-4C0044權限控管
        LET g_data_group=g_vie.viegrup
        CALL p_view_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION p_view_show()
    LET g_vie_t.* = g_vie.*
    DISPLAY BY NAME g_vie.vie01,g_vie.vie02,g_vie.vie03,g_vie.vie04,g_vie.vie05,g_vie.vie06,g_vie.vie07,
                    g_vie.vie08,g_vie.vie09,g_vie.vieuser,g_vie.viegrup,g_vie.viemodu,g_vie.viedate,
                    g_vie.vieacti,g_vie.vieoriu,g_vie.vieorig 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_view_u()
    IF g_vie.vie01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
        
    SELECT * INTO g_vie.* FROM vie_file WHERE vie01=g_vie.vie01
    IF g_vie.vieacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_vie01_t = g_vie.vie01
    LET g_vie02_t = g_vie.vie02
    BEGIN WORK
 
    OPEN p_view_cl USING g_vie.vie01   #FUN-A10090
    IF STATUS THEN
       CALL cl_err("OPEN p_view_cl:", STATUS, 1)
       CLOSE p_view_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_view_cl INTO g_vie.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vie.vie01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_vie.viemodu=g_user                  #修改者
    LET g_vie.viedate = g_today               #修改日期
    CALL p_view_show()                          # 顯示最新資料
    WHILE TRUE
        CALL p_view_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vie.*=g_vie_t.*
            CALL p_view_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vie_file SET vie_file.* = g_vie.*    # 更新DB
            WHERE vie01 = g_vie01_t     #FUN-A10090
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vie_file",g_vie.vie01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p_view_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_view_x()
    IF g_vie.vie01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_view_cl USING g_vie.vie01   #FUN-A10090
    IF STATUS THEN
       CALL cl_err("OPEN p_view_cl:", STATUS, 1)
       CLOSE p_view_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_view_cl INTO g_vie.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vie.vie01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL p_view_show()
    IF cl_exp(0,0,g_vie.vieacti) THEN
        LET g_chr=g_vie.vieacti
        IF g_vie.vieacti='Y' THEN
            LET g_vie.vieacti='N'
        ELSE
            LET g_vie.vieacti='Y'
        END IF
        UPDATE vie_file
            SET vieacti=g_vie.vieacti
           # WHERE ROWID=g_vie_rowid   #FUN-A10090
            WHERE vie01 = g_vie.vie01    #FUN-A10090
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_vie.vie01,SQLCA.sqlcode,0)
            LET g_vie.vieacti=g_chr
        END IF
        DISPLAY BY NAME g_vie.vieacti
    END IF
    CLOSE p_view_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_view_r()
DEFINE 
   li_cnt          LIKE ze_file.ze03,                                                                                              
   li_bnt          LIKE ze_file.ze03,                                                                                              
   l_i             LIKE type_file.num5
   
    IF g_vie.vie01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_view_cl USING g_vie.vie01   #FUN-A10090
    IF STATUS THEN
       CALL cl_err("OPEN p_view_cl:", STATUS, 0)
       CLOSE p_view_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_view_cl INTO g_vie.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vie.vie01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL p_view_show()
    IF cl_delete() THEN
       CALL cl_getmsg('cre-002',g_lang) RETURNING li_cnt                                                               
       CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt   
           MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
           ON ACTION yes                                                                                              
              LET l_i = TRUE   
              DROP VIEW g_vie.vie01                                                                                          
              DELETE FROM vie_file WHERE vie01 = g_vie.vie01
              CLEAR FORM
              OPEN p_view_count
              #FUN-B50065-add-start--
              IF STATUS THEN
                 CLOSE p_view_cl
                 CLOSE p_view_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50065-add-end-- 
              FETCH p_view_count INTO g_row_count
              #FUN-B50065-add-start--
              IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                 CLOSE p_view_cl
                 CLOSE p_view_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50065-add-end-- 
              DISPLAY g_row_count TO FORMONLY.cnt
              OPEN p_view_cs
              EXIT MENU
                                                                                                                                    
           ON ACTION NO                                                                                                
              RETURN                                                                                                      
              EXIT MENU
#TQC-860017 start
 
           ON ACTION about
             CALL cl_about()
 
           ON ACTION controlg
             CALL cl_cmdask()
 
           ON ACTION help
             CALL cl_show_help()
 
           ON IDLE g_idle_seconds
             CALL cl_on_idle()
            CONTINUE MENU
#TQC-860017 end
          END MENU           
       
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL p_view_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL p_view_fetch('/')
       END IF
    END IF
    CLOSE p_view_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_view_copy()
    DEFINE
        l_newno         LIKE vie_file.vie01,
        l_oldno         LIKE vie_file.vie01,
        p_cmd     LIKE type_file.chr1,
        l_input   LIKE type_file.chr1

    IF g_vie.vie01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL p_view_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM vie01
 
        AFTER FIELD vie01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM vie_file
                  WHERE vie01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD vie01
              END IF
           END IF
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_vie.vie01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM vie_file
        WHERE vie01 = g_vie.vie01  #FUN-A10090
        INTO TEMP x
    UPDATE x
        SET vie01=l_newno,    #資料鍵值
            vieacti='Y',      #資料有效碼
            vieuser=g_user,   #資料所有者
            viegrup=g_grup,   #資料所有者所屬群
            viemodu=NULL,     #資料修改日期
            viedate=g_today   #資料建立日期
    INSERT INTO vie_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","vie_file",g_vie.vie01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_vie.vie01
        LET g_vie.vie01 = l_newno
        SELECT vie_file.* INTO g_vie.* FROM vie_file    #FUN-A10090
               WHERE vie01 = l_newno
        CALL p_view_u()
        #SELECT vie_file.* INTO g_vie.* FROM vie_file   #FUN-A10090  #FUN-C30027
        #       WHERE vie01 = l_oldno  #FUN-C30027
    END IF
    #LET g_vie.vie01 = l_oldno  #FUN-C30027
    CALL p_view_show()
END FUNCTION
 
 
FUNCTION p_view_set_entry(p_cmd)
   DEFINE  p_cmd     LIKE type_file.chr1 #TQC-880048 
         # p_cmd     VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vie01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION p_view_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 #TQC-880048  
        # p_cmd     VARCHAR(1)
 
    IF p_cmd = 'u'  THEN
       CALL cl_set_comp_entry("vie01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION p_view_create()
   DEFINE    l_sql           STRING,
             l_n             LIKE type_file.num5,
             l_name          LIKE type_file.num5,
#            l_vie02         LIKE vie_file.vie02,
             l_vie03         LIKE vie_file.vie03,
             l_vie04         LIKE type_file.chr10, #TQC-880048
          #  l_vie04         VARCHAR(10),
             l_vie05         LIKE type_file.chr10, #TQC-880048 
          #  l_vie05         VARCHAR(10),
             l_vie01         STRING,
             l_vname         LIKE vie_file.vie01,
             l_db            LIKE azp_file.azp03,
             l_tok           base.StringTokenizer,
             l_vie06         LIKE vie_file.vie06
#             l_msg           STRING,
#             l_smsg          STRING
                            
   IF cl_null(g_vie.vie01) THEN 
      CALL cl_err("",-400,1)
      RETURN
   END IF
   
#   LET l_vie01 = g_vie.vie01 
#   LET l_vie01 = l_vie01.toUpperCase() 
#   LET l_vname = l_vie01
#   
#   IF g_vie.vie07 = "N" THEN 
#      SELECT COUNT(*) INTO l_n FROM user_views WHERE VIEW_NAME = l_vname
#      IF l_n > 0 THEN 
#         CALL cl_err(g_vie.vie01,'azz-263',1)
#         RETURN
#      END IF 
#   ELSE 
#      LET g_vie06 = "or replace" 
#   END IF  
 
#   IF NOT cl_null(g_vie.vie04) THEN 
#      LET g_vie04 = "(",g_vie.vie04,")"
#   END IF 
 
   IF g_vie.vie05 = '0' THEN 
      LET l_db = g_dbs
      CALL p_create(g_vie.vie01,l_db) 
      IF g_succeed = 'Y' THEN 
         IF cl_null(l_vie06) THEN 
            LET l_vie06 = l_db
         ELSE 
            LET l_vie06 = l_vie06,",",l_db
         END IF 
      END IF 
   ELSE 
      LET l_tok = base.StringTokenizer.Create(g_alldbs,",")
      WHILE l_tok.hasMoreTokens()
         LET l_db = l_tok.nextToken()
         CALL p_create(g_vie.vie01,l_db)
         IF g_succeed ='Y' THEN  
            IF cl_null(l_vie06) THEN 
               LET l_vie06 = l_db
            ELSE 
               LET l_vie06 = l_vie06,",",l_db
            END IF 
        END IF 
      END WHILE  
   END IF 
      
   IF cl_null(l_vie06) THEN 
      LET g_vie.vie08 ='N'
      DISPLAY g_vie.vie08 TO vie08
   ELSE 
      LET g_vie.vie08 ='Y'
      DISPLAY g_vie.vie08 TO vie08
      DISPLAY l_vie06 TO vie06
      UPDATE vie_file SET vie08='Y' WHERE vie01 = g_vie.vie01
      UPDATE vie_file SET vie06 = l_vie06 WHERE vie01 = g_vie.vie01
#      CALL cl_err(g_vie.vie01,"azz-265",1)
   END IF 
#   CALL cl_navigator_setting(g_curs_index, g_row_count)
END FUNCTION 
 
FUNCTION p_view_drop()
   DEFINE           l_sql        STRING,
                    l_name       LIKE type_file.num5,
                    l_db         LIKE azp_file.azp03,
                    l_tok        base.StringTokenizer
   
   IF cl_null(g_vie.vie01) THEN 
      CALL cl_err("",-400,1)
      RETURN
   END IF
   
   IF g_vie.vie08 ="N" THEN 
      CALL cl_err("","azz-264",1)
      RETURN 
   ELSE 
      IF g_vie.vie05 = '0' THEN 
         LET l_db = g_dbs
         CALL p_drop(g_vie.vie01,l_db)
      ELSE 
         LET l_tok = base.StringTokenizer.Create(g_vie06,",")
         WHILE l_tok.hasMoreTokens()
            LET l_db = l_tok.nextToken()
            CALL p_drop(g_vie.vie01,l_db)
         END WHILE     
      END IF 
   END IF 
   
   UPDATE vie_file SET vie08='N' WHERE vie01 = g_vie.vie01
   LET g_vie.vie08 = 'N'
   DISPLAY g_vie.vie08 TO vie08
#   CALL cl_err(g_vie.vie01,'azz-266',1)
   CALL cl_navigator_setting(g_curs_index, g_row_count)
END FUNCTION 
 
FUNCTION p_view_qry()
   DEFINE l_str       STRING
    
    IF cl_null(g_vie.vie03) THEN 
       CALL cl_err('',-400,1)
       return
    END IF 
    
    CALL cl_query_dbqry(g_vie.vie01,"N",g_vie.vie03)
    
    CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION 
 
FUNCTION p_view_put()
   DEFINE     l_n                LIKE type_file.num5 
   DEFINE     l_str              LIKE zak_file.zak02
   DEFINE     l_sql              STRING
   DEFINE 
   li_cnt          LIKE ze_file.ze03,                                                                                              
   li_cnt1         LIKE ze_file.ze03,
   li_bnt          LIKE ze_file.ze03,                                                                                              
   l_i             LIKE type_file.num5,
   l_a             LIKE zai_file.zai02,
   l_b             LIKE zai_file.zai03,
   l_c             LIKE zai_file.zai05,
   l_d             LIKE zai_file.zai04,
   l_flag          LIKE type_file.chr1,#TQC-880048                
 # l_flag          VARCHAR(1),
   l_zai05         LIKE zai_file.zai05,
   l_count         LIKE type_file.num5 
   
   IF cl_null(g_vie.vie01) THEN 
      CALL cl_err('',-400,1)
      RETURN 
   END IF 
   
   IF cl_null(g_vie.vie02) THEN 
      CALL cl_err("","azz-267",1)
      RETURN 
   END IF 
   
   IF g_vie.vie08 = 'N' THEN 
      CALL cl_err("","azz-269",1)
      RETURN 
   END IF 
   
   LET l_str = "select * from ",g_vie.vie01 
   SELECT COUNT(*) INTO l_n FROM zai_file WHERE zai01 = g_vie.vie02
   IF l_n>0 THEN 
#      CALL cl_err("","azz-268",0)
#      RETURN 
#   END IF 
#   BEGIN WORK 
#       
#   INSERT INTO zap_file VALUES (g_vie.vie07,'66','0','0','5','6600','N')
#   
#   INSERT INTO zak_file(zak01,zak02,zak03,zak04,zak05,zak06,zak07) VALUES (g_vie.vie07,l_str,g_vie.vie01,'*','','',g_vie.vie09)
   
#   IF SQLCA.sqlcode THEN 
#      IF SQLCA.sqlcode = '-239' THEN 
         CALL cl_getmsg('cre-003',g_lang) RETURNING li_cnt  
         CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt 
#           LET li_cnt1 = g_vie.vie07,li_cnt                                                             
           MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
           ON ACTION renovate                                                                                             
              LET l_i = TRUE           
              OPEN WINDOW p_forqry  WITH FORM "azz/42f/p_forqry"
              ATTRIBUTE(STYLE ='sm1')
    
              CALL cl_ui_locale("p_forqry")
        
              INPUT l_a,l_b,l_c,l_d WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.b,FORMONLY.c,FORMONLY.d  
                 ON ACTION cancel                    
                    LET l_flag = 'Y'
                    EXIT INPUT 
                    CLOSE WINDOW p_forqry
                    RETURN 
                  
#                  ON ACTION accept  
                  AFTER INPUT 
                     BEGIN WORK
                     SELECT zai05  INTO l_zai05 FROM zai_file WHERE zai01 =g_vie.vie02
                     SELECT count(*)  INTO l_count FROM zai_file WHERE zai01 =g_vie.vie02
                     IF l_zai05=l_d or l_count <>1 THEN  
                        UPDATE zai_file SET zai02 = l_a,
                                  zai03 = l_b,                                  
                                  zaimodu = g_user,
                                  zaidate = g_today,
                                  zai04 = l_c,
                                  zai05 = l_d
                            WHERE zai01 = g_vie.vie02
                               AND zai05 = l_d
                        UPDATE zak_file SET zak02 = l_str,
                                  zak03 = g_vie.vie01,
                                  zak04 ='*',
                                  zak05 ='',
                                  zak06 ='',
                                  zak07 = l_d
                            WHERE zak01 = g_vie.vie02   
                               AND zak07 =l_d
                     ELSE 
                        LET l_sql = " INSERT INTO zai_file(zai01,zai02,zai03,zaiuser,zaigrup,zai04,zai05,zaioriu,zaiorig)",  #FUN-A10036
                                    " VALUES ('",g_vie.vie02,"','",l_a,"','",l_b,"','",g_user,"','",g_grup,"','",l_c,"','",l_d,"','",g_user,"','",g_grup,"')"    #FUN-A10036
                        PREPARE l_int1 FROM l_sql
                        EXECUTE l_int1            
                        INSERT INTO zap_file VALUES (g_vie.vie02,'66','0','0','5','6600','N')
                        INSERT INTO zak_file(zak01,zak02,zak03,zak04,zak05,zak06,zak07) VALUES (g_vie.vie02,l_str,g_vie.vie01,'*','','',l_d)
                    END IF              
             IF SQLCA.sqlcode THEN 
                 CALL cl_err('',SQLCA.sqlcode,1)
                 ROLLBACK WORK 
                 LET g_flag='N' 
                 EXIT INPUT
              ELSE 
 #            	 UPDATE vie_file SET vie04 ='Y' WHERE vie01 = g_vie.vie01
 #             	 DISPLAY "Y" TO vie04
              	 COMMIT WORK               	 
              END IF  
              EXIT INPUT 
              
              BEFORE INPUT 
                 SELECT zai02,zai03,zai04,zai05 INTO l_a,l_b,l_c,l_d FROM zai_file WHERE zai01 = g_vie.vie02 AND zai05='Y'
                 IF cl_null(l_a) THEN 
                    SELECT zai02,zai03,zai04,zai05 INTO l_a,l_b,l_c,l_d FROM zai_file WHERE zai01 = g_vie.vie02 AND zai05='N'
                 END IF
                 DISPLAY l_a,l_b,l_c,l_d TO FORMONLY.a,FORMONLY.b,FORMONLY.c,FORMONLY.d                 
#TQC-860017 start
 
                 ON ACTION about
                    CALL cl_about()
 
                 ON ACTION controlg
                    CALL cl_cmdask()
 
                 ON ACTION help
                    CALL cl_show_help()
 
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
                   CONTINUE INPUT
#TQC-860017 end
              END INPUT 
              
              CLOSE WINDOW p_forqry 
              IF g_flag ='N' THEN
                 RETURN
              END IF 
                                                                                     
                
              EXIT MENU
                                                                                                                                    
           ON ACTION wait   
#             ROLLBACK WORK                                                                                               
             RETURN                                                                                                      
             EXIT MENU 
#TQC-860017 start
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
            CONTINUE MENU
#TQC-860017 end
 
 
                                                                                                  
          END MENU 
#      ELSE         
#       CALL cl_err('',SQLCA.sqlcode,1)
#       ROLLBACK WORK 
#       RETURN 
#      END IF 
   ELSE 
      OPEN WINDOW p_forqry  WITH FORM "azz/42f/p_forqry"
      ATTRIBUTE(STYLE ='sm1')
    
      CALL cl_ui_locale("p_forqry")
      INPUT l_a,l_b,l_c,l_d WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.b,FORMONLY.c,FORMONLY.d
      ON ACTION cancel         
#         CLOSE WINDOW p_forqry
         LET l_flag = 'Y'
         EXIT INPUT 
         
      AFTER INPUT 
         BEGIN WORK 
         LET l_sql = " INSERT INTO zai_file(zai01,zai02,zai03,zaiuser,zaigrup,zai04,zai05,zaioriu,zaiorig)",  #FUN-A10036
                     " VALUES ('",g_vie.vie02,"','",l_a,"','",l_b,"','",g_user,"','",g_grup,"','",l_c,"','",l_d,"','",g_user,"','",g_grup,"')"
         PREPARE l_int FROM l_sql
         EXECUTE l_int            
         INSERT INTO zap_file VALUES (g_vie.vie02,'66','0','0','5','6600','N')
         INSERT INTO zak_file(zak01,zak02,zak03,zak04,zak05,zak06,zak07) VALUES (g_vie.vie02,l_str,g_vie.vie01,'*','','',l_d)
         IF SQLCA.sqlcode THEN 
            CALL cl_err('',SQLCA.sqlcode,1)
            ROLLBACK WORK 
            CLOSE WINDOW p_forqry    
            RETURN
         ELSE 
            COMMIT WORK 
            UPDATE vie_file SET vie09 ='Y' WHERE vie01 = g_vie.vie01
            EXIT INPUT 
         END IF 
         
      BEFORE INPUT 
         LET l_c ='N'
         LET l_d ='N'
         DISPLAY l_c,l_d TO FORMONLY.c,FORMONLY.d    
#TQC-860017 start
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
            CONTINUE INPUT 
#TQC-860017 end         
 
 
      END INPUT    
      CLOSE WINDOW p_forqry
      DISPLAY 'Y' TO vie09
 
   END IF
   
   IF l_flag = 'Y' THEN 
      RETURN 
   END IF 
   
   LET g_cmd = "p_query  '",g_vie.vie02,"' 'p_addview' '",l_d,"'"                              
   CALL cl_cmdrun(g_cmd) 
   CALL cl_navigator_setting(g_curs_index, g_row_count)
END FUNCTION 
 
 
FUNCTION p_view_alldbs()
   DEFINE   l_azp03   LIKE azp_file.azp03
 
   DECLARE l_select CURSOR FOR SELECT azp03 FROM azp_file
   FOREACH l_select INTO l_azp03
      IF cl_null(g_alldbs) THEN 
         LET g_alldbs = l_azp03
      ELSE
         LET g_alldbs = g_alldbs,",",l_azp03
      END IF 
   END FOREACH
END FUNCTION  
 
FUNCTION p_create(p_name,p_db)
   DEFINE p_db           LIKE azp_file.azp03
   DEFINE l_sql          STRING
   DEFINE l_msg          STRING
   DEFINE p_name         LIKE vie_file.vie01
   DEFINE l_vie01        STRING
   DEFINE l_vname        LIKE vie_file.vie01
   DEFINE l_n            LIKE type_file.num5
   DEFINE l_vie03        LIKE vie_file.vie03
   DEFINE l_vie04        LIKE vie_file.vie04
   DEFINE l_vie07        LIKE vie_file.vie07
   DEFINE l_vie06        STRING
   DEFINE l_smsg         STRING
   
   LET l_vie01 = l_vie01.toUpperCase() 
   LET l_vname = l_vie01
   SELECT vie03,vie04,vie07 INTO l_vie03,l_vie04,l_vie07 FROM vie_file WHERE vie01 = p_name
   IF l_vie07 = "N" THEN                                             
      SELECT COUNT(*) INTO l_n FROM user_views WHERE VIEW_NAME = l_vname 
      IF l_n > 0 THEN                                                    
         CALL cl_err(p_name,'azz-263',1)                            
         RETURN                                                          
      END IF                                                             
   ELSE                                                                  
     LET l_vie06 = "or replace"                                         
   END IF                                                                
                                                                      
   IF NOT cl_null(l_vie04) THEN                                      
      LET l_vie04 = "(",l_vie04,")"                                  
   END IF                                                                
   
   LET l_smsg = "ON ",p_db CLIPPED," ",p_name
   IF g_db_type="ORA" THEN  
      LET l_sql = " CREATE ",l_vie06 CLIPPED," "," VIEW ",p_db CLIPPED,".",p_name CLIPPED,
                 l_vie04 CLIPPED,
               " AS ",l_vie03 CLIPPED
   ELSE
      LET l_sql = " CREATE VIEW "," ",p_name CLIPPED,
                 l_vie04 CLIPPED,
               " AS ",l_vie03 CLIPPED
   END IF 
   PREPARE l_create FROM l_sql
   EXECUTE l_create
     
   IF SQLCA.sqlcode THEN 
      DISPLAY SQLERRMESSAGE
      LET l_msg ="error on ",p_db,":" 
      LET l_msg =l_msg,SQLERRMESSAGE
      CALL cl_err(l_msg,'azz-262',1)
      LET g_succeed = 'N'
   ELSE 
      LET g_succeed = 'Y'
      CALL cl_err(l_smsg,"azz-265",1)
   END IF               
   
END FUNCTION 
   
FUNCTION p_drop(p_name,p_db)
   DEFINE p_db           LIKE azp_file.azp03
   DEFINE l_sql          STRING
   DEFINE p_name         LIKE vie_file.vie01
   DEFINE l_msg          STRING
   
   
   IF g_db_type ="ORA" THEN   
      LET l_sql = "drop view ",p_db CLIPPED,".",g_vie.vie01 CLIPPED
   ELSE
      LET l_sql = "drop view ",g_vie.vie01 CLIPPED
   END IF
   PREPARE l_drop FROM l_sql
   EXECUTE l_drop
   
   
   
   LET l_msg = 'view ',p_name,' on ',p_db
   CALL cl_err(l_msg,'azz-266',1)
   
   
   
END FUNCTION 
   
FUNCTION p_view_check()
   DEFINE l_maxvie06           LIKE vie_file.vie06 
   DEFINE l_vie06              LIKE vie_file.vie06
   DEFINE l_vie01              LIKE vie_file.vie01
   DEFINE l_tok                base.StringTokenizer
   DEFINE l_tok_vie01          base.StringTokenizer
   DEFINE l_tok_vie06          base.StringTokenizer
   DEFINE l_db                 LIKE azp_file.azp03
   DEFINE l_index              LIKE type_file.num5
   DEFINE l_dbs                STRING           
   DEFINE li_cnt               LIKE ze_file.ze03                                                                                              
   DEFINE li_bnt               LIKE ze_file.ze03 
   DEFINE l_allvie01           STRING
   DEFINE l_allvie06           STRING   
   DEFINE l,i                  LIKE type_file.num5     
   
   SELECT DISTINCT vie06 INTO l_vie06 FROM vie_file WHERE LENGTH(vie06)=(SELECT MAX(LENGTH(vie06))FROM vie_file) 
                                                       AND vie05 = '1'
   IF cl_null(l_vie06) THEN 
      RETURN 
   END IF   
   
   LET l = LENGTH(l_vie06)
   LET i = LENGTH(g_alldbs)
   IF LENGTH(l_vie06) < LENGTH(g_alldbs) THEN 
      CALL cl_getmsg('cre-004',g_lang) RETURNING li_cnt  
      CALL cl_getmsg('lib-042',g_lang) RETURNING li_bnt                                                
         MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
           ON ACTION accept                                                                                              
              DECLARE l_different CURSOR FOR SELECT vie01,vie06 FROM vie_file WHERE vie05 ='1' AND vie08 ='Y'
              FOREACH l_different INTO l_vie01,l_vie06
                 IF cl_null(l_allvie01) THEN 
                    LET l_allvie01 = l_vie01
                    LET l_allvie06 = l_vie06
                 ELSE 
                    LET l_allvie01 = l_allvie01,"|",l_vie01
                    LET l_allvie06 = l_allvie06,"|",l_vie06
                 END IF 
              END FOREACH 
              LET l_vie06 = l_allvie06
              LET l_tok_vie01 =base.StringTokenizer.Create(l_allvie01,"|")
              LET l_tok_vie06 =base.StringTokenizer.Create(l_allvie06,"|")
              WHILE l_tok_vie01.hasMoreTokens()
                 LET l_vie01 = l_tok_vie01.nextToken()
                 LET l_dbs = l_tok_vie06.nextToken()
                 LET l_tok = base.StringTokenizer.Create(g_alldbs,",")
                 WHILE l_tok.hasMoreTokens()
                    LET l_db = l_tok.nextToken()
                    LET l_index = l_dbs.getIndexOf(l_db,1)
                    IF l_index ='0' THEN 
                       CALL p_create(l_vie01,l_db)
                       IF g_succeed = 'Y' THEN 
                          LET l_vie06 = l_vie06,",",l_db
                       END IF 
                    END IF        
                 END WHILE 
                 UPDATE vie_file SET vie06 = l_vie06 WHERE vie01 =l_vie01
              END WHILE 
              EXIT MENU
                                                                                                                                    
           ON ACTION cancel                                                                  
             RETURN                                                                                                      
             EXIT MENU 
#TQC-860017 start
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
            CONTINUE MENU
#TQC-860017 end                                                                                                  
          END MENU 
   END IF 
       
   
END FUNCTION 

