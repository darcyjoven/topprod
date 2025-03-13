# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: atmi304.4gl
# Descriptions...: vip信息維護作業
# Date & Author..: 08/02/16 By destiny No.FUN-7C0035
# Modify.........: TQC-940020 09/05/07 By mike 無效資料不可以刪除    
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE
    g_vip        RECORD LIKE vip_file.*,
    g_vip_t      RECORD LIKE vip_file.*,
    g_vip01_t    LIKE vip_file.vip01,
    g_buf        LIKE type_file.chr20,   
    g_wc,g_sql   string,  
    g_vim02      LIKE vim_file.vim02,
    g_vimacti    LIKE vim_file.vimacti
 
DEFINE g_forupd_sql          STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_chr             LIKE type_file.chr1
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count     LIKE type_file.num10  
DEFINE   g_curs_index    LIKE type_file.num10   
DEFINE   g_jump          LIKE type_file.num10  
DEFINE   mi_no_ask       LIKE type_file.num5  
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("atm")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    INITIALIZE g_vip.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vip_file WHERE vip01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i304_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 13
    OPEN WINDOW i304_w AT p_row,p_col
         WITH FORM "atm/42f/atmi304"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i304_menu()
    CLOSE WINDOW i304_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i304_cs()
    CLEAR FORM
   INITIALIZE g_vip.* TO NULL    
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        vip01,vip02,vip03,vip04,vip05,vip06,vip07,vip08,vip09,vip10,vip11,vip12,
        vipuser,vipgrup,vipmodu,vipdate,vipacti
        
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION CONTROLP                       # 沿用所有欄位
           CASE
             WHEN INFIELD(vip02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_vim"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = ''
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO vip02
               NEXT FIELD vip02
           END CASE
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND vipuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND vipgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              #群組權限
    #        LET g_wc = g_wc clipped," AND vipgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('vipuser', 'vipgrup')
    #End:FUN-980030
 
 
    LET g_sql="SELECT vip01 FROM vip_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY vip01"
    PREPARE i304_prepare FROM g_sql           # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i304_pre',STATUS,1) RETURN END IF
    DECLARE i304_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i304_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vip_file WHERE ",g_wc CLIPPED
    PREPARE i304_precount FROM g_sql
    DECLARE i304_count CURSOR FOR i304_precount
END FUNCTION
 
FUNCTION i304_menu()
DEFINE l_wc      STRING
DEFINE l_msg     STRING
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i304_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i304_q()
           END IF
        ON ACTION next
           CALL i304_fetch('N')
        ON ACTION previous
           CALL i304_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i304_u()
           END IF
        ON ACTION delete
           IF cl_chk_act_auth() THEN
              CALL i304_r()
           END IF
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
              CALL i304_x()
           END IF
        ON ACTION integral
           IF cl_chk_act_auth() THEN 
              IF NOT cl_null(g_vip.vip01) THEN 
                 LET l_msg="atmq304 '",g_vip.vip01,"'"  
                 CALL cl_cmdrun(l_msg)
              END IF
           END IF  
        ON ACTION consumer
           IF cl_chk_act_auth() THEN 
              IF NOT cl_null(g_vip.vip01) THEN
                 LET l_msg="atmq305 '",g_vip.vip01,"'" 
                 CALL cl_cmdrun(l_msg)                                                                                              
              END IF                                                                                                                
           END IF   
 
        ON ACTION vipkind
           IF cl_chk_act_auth() then                                                                                                
              IF NOT cl_null(g_vip.vip02) then                                                                                      
                 LET l_msg=" atmi303 '",g_vip.vip02 ,"' 'query' "                                                                            
                 CALL cl_cmdrun(l_msg)                                                                                              
              END IF                                                                                                                
           END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                 
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i304_fetch('/')
        ON ACTION first
           CALL i304_fetch('F')
        ON ACTION last
           CALL i304_fetch('L')
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
        ON ACTION opening
           CALL i304_o()
        ON ACTION unopening
           CALL i304_f(1)
        ON ACTION suspended
           CALL i304_f(2)
        ON ACTION out
           CALL i304_n()
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_vip.vip01 IS NOT NULL THEN
                LET g_doc.column1 = "vip01"
                LET g_doc.value1 = g_vip.vip01
                CALL cl_doc()
             END IF
         END IF

        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
    CLOSE i304_cs
END FUNCTION
 
FUNCTION i304_a()
DEFINE l_chr   LIKE type_file.chr6    
 
    MESSAGE ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vip.*  LIKE vip_file.*
    LET g_vip.vip01=null
    LET g_wc=null
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vip.vipuser = g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_vip.vipgrup = g_grup               #使用者所屬群
        LET g_vip.vipdate = g_today
        LET g_vip.vipacti = "Y"                  #有效碼
        LET g_vip.vip03=g_today
        LET g_vip.vip04=g_today
        LET g_vip.vip05="1"                     
        LET g_vip.vip10="F"                     
        LET g_vip.vip13="0"
        LET g_vip.vip14="0"
        LET g_vip.vip15="0"
        CALL i304_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_vip.vip01 IS NULL THEN CONTINUE WHILE END IF
 
        LET g_vip.vipplant = g_plant #FUN-980009
        LET g_vip.viplegal = g_legal #FUN-980009
 
        LET g_vip.viporiu = g_user      #No.FUN-980030 10/01/04
        LET g_vip.viporig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO vip_file VALUES(g_vip.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","vip_file",g_vip.vip01,"",SQLCA.sqlcode,"","Add:",1) 
           ROLLBACK WORK  
           EXIT  WHILE
        ELSE
           COMMIT WORK    
           CALL cl_flow_notify(g_vip.vip01,'I')
        END IF
 
        LET g_vip_t.* = g_vip.*                # 保存上筆資料
        SELECT vip01 INTO g_vip.vip01 FROM vip_file WHERE vip01 = g_vip.vip01
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i304_i(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1,    
           l_n     LIKE type_file.num5    
 
    DISPLAY BY NAME g_vip.vipuser,g_vip.vipmodu,
        g_vip.vipgrup,g_vip.vipdate,g_vip.vipacti
       
    INPUT BY NAME
        g_vip.vip01,g_vip.vip02,g_vip.vip03,g_vip.vip04,g_vip.vip05,
        g_vip.vip06,g_vip.vip07,g_vip.vip08,g_vip.vip09,g_vip.vip10,g_vip.vip11,g_vip.vip12
        WITHOUT DEFAULTS       
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i304_set_entry(p_cmd)
            CALL i304_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
        AFTER FIELD vip01 
            IF NOT cl_null(g_vip.vip01) THEN
               IF g_vip.vip01 != g_vip01_t OR g_vip01_t IS NULL THEN   
                  SELECT count(*) INTO l_n FROM vip_file
                     WHERE vip01 = g_vip.vip01
                 IF l_n > 0 THEN                                      
                    CALL cl_err(g_vip.vip01,-239,0)
                    LET g_vip.vip01 = g_vip01_t
                    DISPLAY BY NAME g_vip.vip01
                    NEXT FIELD vip01
                 END IF
               END IF
            ELSE
              NEXT FIELD vip01
            END IF
        AFTER FIELD vip02
            CALL i304_vip02()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('vip02:',g_errno,1)
               LET g_vip.vip02 = g_vip_t.vip02
               DISPLAY BY NAME g_vip.vip02
               NEXT FIELD vip02
            END IF
             
        AFTER FIELD vip04
           IF NOT cl_null(g_vip.vip04) THEN 
              IF (g_vip.vip04 < g_vip.vip03) THEN
                 CALL cl_err(g_vip.vip04,'mfg3009',0)
                 NEXT FIELD vip04
              END IF
           END IF
 
     ON ACTION CONTROLP                        # 沿用所有欄位
          CASE
             WHEN INFIELD(vip02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_vim"
               LET g_qryparam.default1 = g_vip.vip02
               CALL cl_create_qry() RETURNING g_vip.vip02
               DISPLAY g_qryparam.multiret TO vip02
               NEXT FIELD vip02
          END CASE
 
         ON ACTION CONTROLF     # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
FUNCTION i304_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vip.* TO NULL               
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i304_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i304_count
    FETCH i304_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i304_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)
       INITIALIZE g_vip.* TO NULL
    ELSE
       CALL i304_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i304_fetch(p_flvip)
    DEFINE   p_flvip           LIKE type_file.chr1    
 
    CASE p_flvip
        WHEN 'N' FETCH NEXT     i304_cs INTO g_vip.vip01
        WHEN 'P' FETCH PREVIOUS i304_cs INTO g_vip.vip01
        WHEN 'F' FETCH FIRST    i304_cs INTO g_vip.vip01
        WHEN 'L' FETCH LAST     i304_cs INTO g_vip.vip01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
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
            FETCH ABSOLUTE g_jump i304_cs INTO g_vip.vip01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)
        INITIALIZE g_vip.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flvip
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_vip.* FROM vip_file            # 重讀DB,因TEMP有不被更新特性
       WHERE vip01 = g_vip.vip01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vip_file",g_vip.vip01,"",SQLCA.sqlcode,"","",1) 
        INITIALIZE g_vip.* TO NULL
    END IF
    CALL i304_show()                      # 重新顯示
END FUNCTION
 
FUNCTION i304_vip02()
    LET g_vim02=' '
    SELECT vim02,vimacti INTO g_vim02,g_vimacti FROM vim_file WHERE vim01=g_vip.vip02
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='atm-608'
                                LET g_vim02=NULL
       WHEN g_vimacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    DISPLAY g_vim02 TO vim02
END FUNCTION
 
 
FUNCTION i304_show()
 
    LET g_vip_t.* = g_vip.*
    DISPLAY BY NAME g_vip.vip01,g_vip.vip02,g_vip.vip03,g_vip.vip04,g_vip.vip05,g_vip.vip06,
                    g_vip.vip07,g_vip.vip08,g_vip.vip09,g_vip.vip10,g_vip.vip11,g_vip.vip12,
                    g_vip.vipuser,g_vip.vipgrup,g_vip.vipmodu,g_vip.vipdate,g_vip.vipacti
    CALL i304_vip02()
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i304_u()
    IF g_vip.vip01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_vip.* FROM vip_file WHERE vip01=g_vip.vip01
    IF g_vip.vipacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vip01_t = g_vip.vip01
    BEGIN WORK
 
    OPEN i304_cl USING g_vip.vip01
    IF STATUS THEN
       CALL cl_err("OPEN i304_cl:", STATUS, 1)
       CLOSE i304_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i304_cl INTO g_vip.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vip.vip01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    LET g_vip.vipmodu=g_user                  #修改者
    LET g_vip.vipdate=g_today                 #修改日期
    CALL i304_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i304_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vip.*=g_vip_t.*
            CALL i304_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vip_file SET vip_file.* = g_vip.*
         WHERE vip01 = g_vip01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vip_file",g_vip.vip01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i304_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i304_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_vip.vip01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i304_cl USING g_vip.vip01
   IF STATUS THEN
      CALL cl_err("OPEN i304_cl:", STATUS, 1)
      CLOSE i304_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i304_cl INTO g_vip.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i304_show()
 
   IF cl_exp(0,0,g_vip.vipacti) THEN                   #確認一下
      LET g_chr=g_vip.vipacti
      IF g_vip.vipacti='Y' THEN
         LET g_vip.vipacti='N'
      ELSE
         LET g_vip.vipacti='Y'
      END IF
 
      UPDATE vip_file SET vipacti=g_vip.vipacti,
                          vipmodu=g_user,
                          vipdate=g_today
       WHERE vip01=g_vip.vip01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","vip_file",g_vip.vip01,"",SQLCA.sqlcode,"","",1)  
         LET g_vip.vipacti=g_chr
      END IF
   END IF
 
   CLOSE i304_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_vip.vip01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT vipacti,vipmodu,vipdate
     INTO g_vip.vipacti,g_vip.vipmodu,g_vip.vipdate FROM vip_file
    WHERE vip01=g_vip.vip01
   DISPLAY BY NAME g_vip.vipacti,g_vip.vipmodu,g_vip.vipdate
 
END FUNCTION
 
FUNCTION i304_r()
    IF g_vip.vip01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-940020  ----start                                                                                                              
    IF g_vip.vipacti='N' THEN                                                                                                       
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
#TQC-940020  ----end  
    BEGIN WORK
 
    OPEN i304_cl USING g_vip.vip01
    IF STATUS THEN
       CALL cl_err("OPEN i304_cl:", STATUS, 0)
       CLOSE i304_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i304_cl INTO g_vip.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i304_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vip01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vip.vip01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM vip_file WHERE vip01 = g_vip.vip01
       CLEAR FORM
       OPEN i304_count
       FETCH i304_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i304_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i304_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                
          CALL i304_fetch('/')
       END IF
    END IF
    CLOSE i304_cl
    COMMIT WORK
    CALL cl_flow_notify(g_vip.vip01,'D')
    
END FUNCTION
 
FUNCTION i304_o()
 
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_vip.vip01) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   SELECT * INTO g_vip.* FROM vip_file
    WHERE vip01=g_vip.vip01
    
   IF g_vip.vipacti='N' THEN CALL cl_err('','aec-024',1) RETURN END IF 
   
   CASE g_vip.vip05
       WHEN '1' 
         IF NOT cl_confirm("atm-604") THEN RETURN END IF
         BEGIN WORK
 
         OPEN i304_cl USING g_vip.vip01
         IF STATUS THEN
            CALL cl_err("OPEN i304_cl:", STATUS, 1)
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i304_cl INTO g_vip.*               
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)         
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
         
         LET g_vip.vip05 = '2'
 
         CALL i304_show()
 
         IF INT_FLAG THEN                  
            LET g_vip.vip05 ='1' 
            LET INT_FLAG = 0
            DISPLAY BY NAME g_vip.vip05
            CALL cl_err('',9001,0)
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         UPDATE vip_file
               SET vip05 = g_vip.vip05
               WHERE vip01 = g_vip.vip01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_vip.vip05,SQLCA.sqlcode,0)
            CALL i304_show()
            ROLLBACK WORK
            RETURN
         END IF
         CLOSE i304_cl
         COMMIT WORK
       WHEN '2' 
         CALL cl_err('','atm-601',1)
       WHEN '3'
         CALL cl_err('','atm-603',1)
   END CASE
   DISPLAY g_vip.vip05 TO vip05
END FUNCTION
 
FUNCTION i304_f(l_cmd)
DEFINE l_cmd   LIKE type_file.chr10
 
   IF s_shut(0) THEN RETURN END IF
 
   
   IF cl_null(g_vip.vip01) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   SELECT * INTO g_vip.* FROM vip_file
    WHERE vip01=g_vip.vip01
    
   IF g_vip.vipacti='N' THEN CALL cl_err('','aec-024',1) RETURN END IF 
   
   CASE g_vip.vip05
       WHEN '1' 
          CALL cl_err('','atm-602',1)
       WHEN '2' 
         IF l_cmd='1' THEN        
            IF NOT cl_confirm("atm-605") THEN RETURN END IF
         ELSE
            IF NOT cl_confirm("atm-606") THEN RETURN END IF
         END IF 
         BEGIN WORK
         OPEN i304_cl USING g_vip.vip01
         IF STATUS THEN
            CALL cl_err("OPEN i304_cl:", STATUS, 1)
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i304_cl INTO g_vip.*               
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)         
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF l_cmd='1' 
            THEN LET g_vip.vip05 = '1' 
         ELSE
            LET g_vip.vip05 ='3'
         END IF 
         
         CALL i304_show()
 
         IF INT_FLAG THEN                  
            LET g_vip.vip05 ='2' 
            LET INT_FLAG = 0
            DISPLAY BY NAME g_vip.vip05
            CALL cl_err('',9001,0)
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         UPDATE vip_file
               SET vip05 = g_vip.vip05
               WHERE vip01 = g_vip.vip01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_vip.vip05,SQLCA.sqlcode,0)
            CALL i304_show()
            ROLLBACK WORK
            RETURN
         END IF
         CLOSE i304_cl
         COMMIT WORK
       WHEN '3'
         CALL cl_err('','atm-603',1)
   END CASE
   DISPLAY g_vip.vip05 TO vip05
END FUNCTION
 
FUNCTION i304_n()
 
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_vip.vip01) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   SELECT * INTO g_vip.* FROM vip_file
    WHERE vip01=g_vip.vip01
    
   IF g_vip.vipacti='N' THEN CALL cl_err('','aec-024',1) RETURN END IF 
   
   CASE g_vip.vip05
       WHEN '1' 
         CALL cl_err('','atm-602',1)
       WHEN '2'         
         CALL cl_err('','atm-601',1)
       WHEN '3'
         IF NOT cl_confirm("atm-607") THEN RETURN END IF
         BEGIN WORK
         OPEN i304_cl USING g_vip.vip01
         IF STATUS THEN
            CALL cl_err("OPEN i304_cl:", STATUS, 1)
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i304_cl INTO g_vip.*               
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_vip.vip01,SQLCA.sqlcode,0)         
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
         
         LET g_vip.vip05 = '2'
 
         CALL i304_show()
 
         IF INT_FLAG THEN                  
            LET g_vip.vip05 ='3' 
            LET INT_FLAG = 0
            DISPLAY BY NAME g_vip.vip05
            CALL cl_err('',9001,0)
            CLOSE i304_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         UPDATE vip_file
               SET vip05 = g_vip.vip05
               WHERE vip01 = g_vip.vip01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_vip.vip05,SQLCA.sqlcode,0)
            CALL i304_show()
            ROLLBACK WORK
            RETURN
         END IF
         CLOSE i304_cl
         COMMIT WORK
   END CASE
   DISPLAY g_vip.vip05 TO vip05
END FUNCTION
 
FUNCTION i304_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("vip01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i304_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("vip01",FALSE)
    END IF
 
END FUNCTION
 
#No.FUN-7C0035
