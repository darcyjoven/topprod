# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apjt110_b.4gl
# Descriptions...: 更新其他相關信息
# Date & Author..: 08/03/11 By douzh FUN-790025 項目管理新增程式
# Modify.........: No.TQC-840009 08/04/08 By douzh 修改錯誤報錯代碼
# Modify.........: No.FUN-8C0123 09/02/20 By mike MSV BUG
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.TQC-9A0159 09/10/28 By lilingyu t110_b_cs sql寫錯,多加字段pjb02
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pjb       RECORD LIKE pjb_file.*,
       g_pjb_t     RECORD LIKE pjb_file.*,  #備份舊值
       g_pjb01_t   LIKE pjb_file.pjb01,     #Key值備份
       g_pjb02_t   LIKE pjb_file.pjb02,     #
       g_pjb15_t   LIKE pjb_file.pjb15,     #
       g_pjb16_t   LIKE pjb_file.pjb16,     #
       g_wc        STRING,                  #儲存 user 的查詢條件 
       g_sql       STRING                   #組 sql 用    
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL      
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令     
DEFINE g_chr                 LIKE pjb_file.pjbacti      
DEFINE g_cnt                 LIKE type_file.num10      
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose 
DEFINE g_msg                 LIKE type_file.chr1000    
DEFINE g_curs_index          LIKE type_file.num10     
DEFINE g_row_count           LIKE type_file.num10         #總筆數        
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數       
DEFINE g_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗  
DEFINE g_argv1               LIKE pjb_file.pjb01          #串apjt100傳參數
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 = ARG_VAL(1)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_pjb.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM pjb_file WHERE pjb01 = ? AND pjb02 = ? FOR UPDATE "    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_b_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t110_b_w WITH FORM "apj/42f/apjt110_b"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
 
   IF g_argv1 IS NOT NULL THEN
      CALL t110_b_q()
   END IF
   CALL t110_b_menu()
 
   CLOSE WINDOW t110_b_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION t110_b_curs()
 
    CLEAR FORM
    INITIALIZE g_pjb.* TO NULL    
    IF g_argv1 IS NULL THEN
       CONSTRUCT BY NAME g_wc ON pjb15,pjb16
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
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND pjbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND pjbgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND pjbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjbuser', 'pjbgrup')
    #End:FUN-980030
 
    IF g_argv1 IS NOT NULL THEN
        LET g_wc =" pjb01 = '",g_argv1,"'"
    END IF 
   
   #FUN-8C0123------BEGIN
   #LET g_sql="SELECT pjb01,pjb02 FROM pjb_file ", # 組合出 SQL 指令
   #    " WHERE ",g_wc CLIPPED, " ORDER BY pjb01"
   # LET g_sql="SELECT pjb01,pjb02,pjb02 FROM pjb_file ", # 組合出 SQL 指令  #TQC-9A0159
    LET g_sql="SELECT pjb01,pjb02 FROM pjb_file ", # 組合出 SQL 指令   #TQC-9A0159
        " WHERE ",g_wc CLIPPED, " ORDER BY pjb01,pjb02" 
   #FUN-8C0123------END
 
    PREPARE t110_b_prepare FROM g_sql
    DECLARE t110_b_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t110_b_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pjb_file WHERE ",g_wc CLIPPED
    PREPARE t110_b_precount FROM g_sql
    DECLARE t110_b_count CURSOR FOR t110_b_precount
END FUNCTION
 
FUNCTION t110_b_menu()
 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t110_b_q()
            END IF
        ON ACTION next
            CALL t110_b_fetch('N')
        ON ACTION previous
            CALL t110_b_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t110_b_u()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t110_b_fetch('/')
        ON ACTION first
            CALL t110_b_fetch('F')
        ON ACTION last
            CALL t110_b_fetch('L')
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
 
         ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
             #IF g_pjb.pjb01 IS NOT NULL THEN #FUN-8C0123
              IF g_pjb.pjb01 IS NOT NULL AND g_pjb.pjb02 IS NOT NULL THEN #FUN-8C0123
                 LET g_doc.column1 = "pjb01"
                 LET g_doc.column2 = "pjb02"    #FUN-8C0123
                 LET g_doc.value1 = g_pjb.pjb01
                 LET g_doc.value2 = g_pjb.pjb02 #FUN-8C0123
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t110_b_cs
END FUNCTION
 
FUNCTION t110_b_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_pjb.* LIKE pjb_file.*
    LET g_pjb15_t = NULL
    LET g_pjb16_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_pjb.pjb16 = g_today
        CALL t110_b_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_pjb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        LET g_pjb.pjboriu = g_user      #No.FUN-980030 10/01/04
        LET g_pjb.pjborig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO pjb_file VALUES(g_pjb.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjb_file",g_pjb.pjb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT pjb01,pjb02 INTO g_pjb.pjb01,g_pjb.pjb02 FROM pjb_file
                     WHERE pjb01 = g_pjb.pjb01
                       AND pjb02 = g_pjb.pjb02
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t110_b_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,  
            l_input   LIKE type_file.chr1,  
            l_n       LIKE type_file.num5  
 
 
   DISPLAY g_argv1 TO FORMONLY.pjb01 
   DISPLAY g_pjb.pjb02 TO FORMONLY.pjb02 
   DISPLAY g_pjb.pjb03 TO FORMONLY.pjb03 
   DISPLAY g_pjb.pjb15 TO FORMONLY.pjb15 
   DISPLAY g_pjb.pjb16 TO FORMONLY.pjb16 
   DISPLAY g_pjb.pjb17 TO FORMONLY.pjb17 
   DISPLAY g_pjb.pjb18 TO FORMONLY.pjb18 
   DISPLAY g_pjb.pjb19 TO FORMONLY.pjb19 
   DISPLAY g_pjb.pjb20 TO FORMONLY.pjb20 
   DISPLAY g_pjb.pjb22 TO FORMONLY.pjb22 
   DISPLAY g_pjb.pjb23 TO FORMONLY.pjb23 
   DISPLAY g_pjb.pjb24 TO FORMONLY.pjb24 
 
    INPUT BY NAME g_pjb.pjb15,g_pjb.pjb16 WITHOUT DEFAULTS 
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t110_b_set_entry(p_cmd)
          CALL t110_b_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD pjb15
         IF g_pjb.pjb15 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_pjb.pjb15 != g_pjb15_t) THEN
               IF g_pjb.pjb16 IS NOT NULL THEN
                  IF g_pjb.pjb15 > g_pjb.pjb16 THEN
                     LET g_pjb.pjb15 = g_today
                     CALL cl_err(g_pjb.pjb15,'apj-076',1)    #No.TQC-840009
                     NEXT FIELD pjb15
                  END IF
                END IF
            END IF
         END IF
 
      AFTER FIELD pjb16
         DISPLAY "AFTER FIELD pjb16"
         IF g_pjb.pjb16 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_pjb.pjb16 != g_pjb16_t) THEN
               IF g_pjb.pjb16 < g_pjb.pjb15 THEN
                  LET g_pjb.pjb16 = g_today
                  CALL cl_err(g_pjb.pjb16,'apj-075',1)      #No.TQC-840009
                  NEXT FIELD pjb16
               END IF
            END IF
         END IF
 
      AFTER INPUT
         LET g_pjb.pjbuser = s_get_data_owner("pjb_file") #FUN-C10039
         LET g_pjb.pjbgrup = s_get_data_group("pjb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_pjb.pjb15 IS NULL THEN
               DISPLAY BY NAME g_pjb.pjb15
               LET l_input='Y'
            END IF
            IF g_pjb.pjb16 IS NULL THEN
               DISPLAY BY NAME g_pjb.pjb16
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD pjb15
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(pjb16) THEN
            LET g_pjb.* = g_pjb_t.*
            CALL t110_b_show()
            NEXT FIELD pjb16
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
 
FUNCTION t110_b_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pjb.* TO NULL           
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t110_b_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t110_b_count
    FETCH t110_b_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t110_b_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjb.pjb01,SQLCA.sqlcode,0)
        INITIALIZE g_pjb.* TO NULL
    ELSE
        CALL t110_b_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t110_b_fetch(p_flpjb)
    DEFINE
        p_flpjb         LIKE type_file.chr1          
 
    CASE p_flpjb
#TQC-9A0159 --還原
       #FUN-8C0123-----begin
       WHEN 'N' FETCH NEXT     t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02
       WHEN 'P' FETCH PREVIOUS t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02
       WHEN 'F' FETCH FIRST    t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02
       WHEN 'L' FETCH LAST     t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02
       # WHEN 'N' FETCH NEXT     t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02,g_pjb.pjb02
       # WHEN 'P' FETCH PREVIOUS t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02,g_pjb.pjb02 
       # WHEN 'F' FETCH FIRST    t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02,g_pjb.pjb02
       # WHEN 'L' FETCH LAST     t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02,g_pjb.pjb02
       #FUN-8C0123------end
#TQC-9A0159 --
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
           FETCH ABSOLUTE g_jump t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02 #FUN-8C0123  #TQC-9A0159
 #         FETCH ABSOLUTE g_jump t110_b_cs INTO g_pjb.pjb01,g_pjb.pjb02,g_pjb.pjb02 #FUN-8C0123   #TQC-9A0159
            LET g_no_ask = FALSE 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjb.pjb01,SQLCA.sqlcode,0)
        INITIALIZE g_pjb.* TO NULL 
        RETURN
    ELSE
      CASE p_flpjb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx            
    END IF
 
    SELECT * INTO g_pjb.* FROM pjb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE pjb01 = g_pjb.pjb01 AND pjb02 = g_pjb.pjb02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pjb_file",g_pjb.pjb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        LET g_data_owner=g_pjb.pjbuser          
        LET g_data_group=g_pjb.pjbgrup
        CALL t110_b_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t110_b_show()
    LET g_pjb_t.* = g_pjb.*
    DISPLAY g_pjb.pjb01 TO FORMONLY.pjb01 
    DISPLAY g_pjb.pjb02 TO FORMONLY.pjb02 
    DISPLAY g_pjb.pjb03 TO FORMONLY.pjb03 
    DISPLAY g_pjb.pjb15 TO FORMONLY.pjb15 
    DISPLAY g_pjb.pjb16 TO FORMONLY.pjb16 
    DISPLAY g_pjb.pjb17 TO FORMONLY.pjb17 
    DISPLAY g_pjb.pjb18 TO FORMONLY.pjb18 
    DISPLAY g_pjb.pjb19 TO FORMONLY.pjb19 
    DISPLAY g_pjb.pjb20 TO FORMONLY.pjb20 
    DISPLAY g_pjb.pjb22 TO FORMONLY.pjb22 
    DISPLAY g_pjb.pjb23 TO FORMONLY.pjb23 
    DISPLAY g_pjb.pjb24 TO FORMONLY.pjb24 
    CALL t110_b_pjb01('d')
    CALL cl_show_fld_cont()             
END FUNCTION
 
FUNCTION t110_b_pjb01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,         
   l_pja02    LIKE pja_file.pja02,
   l_pjaacti  LIKE pja_file.pjaacti 
  ,l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   LET g_errno=''
   SELECT pja02,pjaclose                 #No.FUN-960038 add pjaclose
     INTO l_pja02,l_pjaclose             #No.FUN-960038 add l_pjaclose
     FROM pja_file
    WHERE pja01=g_pjb.pjb01
      AND pjaacti = 'Y'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_pja02=NULL
       WHEN l_pjaacti='N'       LET g_errno='9028'
       WHEN l_pjaclose='Y'      LET g_errno='abg-503' #No.FUN-960038
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pja02 TO FORMONLY.pja02
   END IF
END FUNCTION
 
FUNCTION t110_b_u()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038 
    IF g_pjb.pjb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
   #FUN-8C0123------begin
    IF g_pjb.pjb02 IS NULL THEN                                                                                                     
        CALL cl_err('',-400,0)                                                                                                      
        RETURN                                                                                                                      
    END IF  
   #FUN-8C0123------end
 
    SELECT * INTO g_pjb.* FROM pjb_file WHERE pjb01=g_pjb.pjb01
       AND pjb02 = g_pjb.pjb02
    IF g_pjb.pjbacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
#No.FUN-960038 --Begin
    SELECT pjaclose
      INTO l_pjaclose
      FROM pja_file
     WHERE pja01=g_pjb.pjb01
    IF l_pjaclose = 'Y' THEN
       CALL cl_err('','apj-602',0)
       RETURN
    END IF
#No.FUN-960038 --End
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pjb01_t = g_pjb.pjb01
    LET g_pjb02_t = g_pjb.pjb02
    BEGIN WORK
 
    OPEN t110_b_cl USING g_pjb.pjb01,g_pjb.pjb02
    IF STATUS THEN
       CALL cl_err("OPEN t110_b_cl:", STATUS, 1)
       CLOSE t110_b_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_b_cl INTO g_pjb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjb.pjb01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_pjb.pjbmodu=g_user                  #修改者
    LET g_pjb.pjbdate = g_today               #修改日期
    CALL t110_b_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t110_b_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pjb.*=g_pjb_t.*
            CALL t110_b_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
UPDATE pjb_file SET pjb_file.* = g_pjb.*    # 更新DB
WHERE pjb01 = g_pjb_t.pjb01 AND pjb02 = g_pjb_t.pjb02 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pjb_file",g_pjb.pjb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t110_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t110_b_r()
    IF g_pjb.pjb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
   #FUN-8C0123----begin
    IF g_pjb.pjb02 IS NULL THEN                                                                                                     
        CALL cl_err('',-400,0)                                                                                                      
        RETURN                                                                                                                      
    END IF     
   #FUN-8C0123-----end
 
    BEGIN WORK
 
    OPEN t110_b_cl USING g_pjb.pjb01,g_pjb.pjb02
    IF STATUS THEN
       CALL cl_err("OPEN t110_b_cl:", STATUS, 0)
       CLOSE t110_b_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_b_cl INTO g_pjb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjb.pjb01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t110_b_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pjb01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "pjb02"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pjb.pjb01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_pjb.pjb02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      #DELETE FROM pjb_file WHERE pjb01 = g_pjb.pjb01 #FUN-8C0123
       DELETE FROM pjb_file WHERE pjb01 = g_pjb.pjb01 AND pjb02 = g_pjb.pjb02 #FUN-8C0123     
       CLEAR FORM
       OPEN t110_b_count
       FETCH t110_b_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t110_b_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t110_b_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL t110_b_fetch('/')
       END IF
    END IF
    CLOSE t110_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t110_b_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1        
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("pjb01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t110_b_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("pjb01",FALSE)
    END IF
 
END FUNCTION
#No.FUN-790025

