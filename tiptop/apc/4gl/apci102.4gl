# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# PAttern name...: apci102.4gl
# Descriptions...: POS公告欄維護作業
# Date & Author..: 10/03/30 FUN-A40024 By huangrh
# Modify.........: NO.FUN-A40024 10/06/07 By Cockroach
# Modify.........: No.TQC-AA0035 10/10/12 By yinhy 作廢功能鈕,使用時應該是update  ryvconf 的值，而不是update ryvacti的值，作廢功能不等同于無效功能
# Modify.........: No.TQC-AA0048 10/10/12 By yinhy 復制一筆已審核的資料，復制後的資料狀態應為N：未審核的資料
# Modify.........: No.FUN-AA0046 10/10/27 By huangtao  修改单据性质
# Modify.........: No.TQC-B40132 11/04/18 By lilingyu 查詢時,"資料建立者 資料創建日 資料建立部門"無法下條件
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C10030 12/01/10 By suncx 更改時將POS相關狀態處理
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」

DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE g_ryv       RECORD LIKE ryv_file.*,
       g_ryv_t     RECORD LIKE ryv_file.*,
       g_ryv01_t   LIKE ryv_file.ryv01, 
       g_wc        STRING,                  #儲存 user 的查詢條件          
       g_sql       STRING                  #組 sql 用    
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        
DEFINE g_argv1               LIKE oea_file.oea01
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_chr                 LIKE ryv_file.ryvacti
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5                  
DEFINE g_msg                 LIKE type_file.chr1000         
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10         #總筆數        
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
   LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
   LET p_row = 4 LET p_col = 2
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_ryv.* TO NULL
   LET g_forupd_sql = "SELECT * FROM ryv_file WHERE ryv01 = ? FOR UPDATE "    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_cl CURSOR FROM g_forupd_sql 
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i102_w AT p_row,p_col WITH FORM "apc/42f/apci102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN 
      CALL i102_q()
   END IF
 
   LET g_action_choice = ""
   CALL i102_menu()
 
   CLOSE WINDOW i102_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i102_curs()
DEFINE   l_azw01  LIKE azw_file.azw01
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_ryv.* TO NULL      
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        ryv01,ryv02,ryv03,ryv05,ryv04,ryvconf,ryvcond,ryvconu,
        ryvuser,ryvgrup,
        ryvoriu,ryvorig,         #TQC-B40132 
        ryvmodu,ryvdate,
        ryvcrat,                 #TQC-B40132
        ryvacti,
        ryvpos #NO.FUN-B40071
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      ON ACTION controlp
         CASE
           WHEN INFIELD(ryv01)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_ryv01"
              LET g_qryparam.state="c"
              LET g_qryparam.default1=g_ryv.ryv01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY  g_qryparam.multiret TO ryv01
              NEXT FIELD ryv01
           WHEN INFIELD(ryv05)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_ryv05"
              LET g_qryparam.state="c"
              LET g_qryparam.default1=g_ryv.ryv05
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY  g_qryparam.multiret TO ryv05
              NEXT FIELD ryv05
           WHEN INFIELD(ryvconu)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_ryvconu"
              LET g_qryparam.state="c"
              LET g_qryparam.default1=g_ryv.ryvconu
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY  g_qryparam.multiret TO ryvconu
              NEXT FIELD ryvconu

         OTHERWISE
            EXIT CASE
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
 
    LET g_wc = g_wc CLIPPED
#    SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw07=g_plant
#    LET g_plant_new = l_azw01
#    CALL s_gettrandbs()
#    LET g_dbs=g_dbs_tra
#    LET g_dbs = s_dbstring(g_dbs)

    LET g_sql="SELECT ryv01 FROM ryv_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED,
        " ORDER BY ryv01"
    PREPARE i102_prepare FROM g_sql
    DECLARE i102_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i102_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ryv_file WHERE ",g_wc CLIPPED
    PREPARE i102_precount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_precount
END FUNCTION
 
FUNCTION i102_menu()
   DEFINE l_cmd  LIKE type_file.chr1000         
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i102_a()
            END IF

         ON ACTION organization #生效機構
            IF cl_null(g_ryv.ryv01) THEN
               CALL cl_err('',-400,0)
               CONTINUE MENU
            END IF
            IF g_ryv.ryvconf='X' THEN
               CALL cl_err('',9024,0)
               CONTINUE MENU
            END IF
            LET g_action_choice="organization"
            IF cl_chk_act_auth() THEN
               CALl i102_1(g_ryv.ryv01)
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i102_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i102_x()
            END IF
 
       ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i102_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i102_copy()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL i102_q()
            END IF
        ON ACTION confirm  #審核
           LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i102_confirm()
            END IF

        ON ACTION void     #作廢
           LET g_action_choice="void"
           IF cl_chk_act_auth() THEN
           #    CALL i102_x()   #No.TQC-AA0035 mark      
                CALL i102_v(1)   #No.TQC-AA0035 mod
           END IF
        #FUN-D20039 ---------sta
        ON ACTION undo_void     
           LET g_action_choice="undo_void"
           IF cl_chk_act_auth() THEN
                CALL i102_v(2)   
           END IF
        #FUN-D20039 ---------end
            
        ON ACTION next
            CALL i102_fetch('N') 
        ON ACTION previous
            CALL i102_fetch('P')
        ON ACTION jump
            CALL i102_fetch('/')
        ON ACTION first
            CALL i102_fetch('F')
        ON ACTION last
            CALL i102_fetch('L') 
            
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
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
 
        ON ACTION close    
            LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU

    END MENU
    CLOSE i102_cs
    CLOSE i102_count
END FUNCTION

FUNCTION i102_a()
DEFINE li_result          LIKE type_file.num5
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ryv.* LIKE ryv_file.*
    LET g_ryv01_t = NULL
    LET g_wc = NULL
    LET g_ryv_t.* = g_ryv.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ryv.ryvuser = g_user
        LET g_ryv.ryvoriu = g_user 
        LET g_ryv.ryvorig = g_grup 
        LET g_ryv.ryvgrup = g_grup               #使用者所屬群
       #LET g_ryv.ryvdate = g_today
        LET g_ryv.ryvcrat = g_today
        LET g_ryv.ryvacti = 'Y'
        LET g_ryv.ryvconf = 'N'
        LET g_ryv.ryv05= g_plant
        LET g_ryv.ryv03= g_today            #ADD BY COCKROACH
        LET g_ryv.ryv02= '2'
        LET g_ryv.ryvpos='1' #NO.FUN-B40071
        CALL i102_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_ryv.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ryv.ryv01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
    #    CALL s_auto_assign_no("art",g_ryv.ryv01,g_today,"T","ryv_file","ryv01","","","")     #FUN-AA0046 mark
         CALL s_auto_assign_no("art",g_ryv.ryv01,g_today,"F3","ryv_file","ryv01","","","")     #FUN-AA0046
           RETURNING li_result,g_ryv.ryv01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_ryv.ryv01
        INSERT INTO ryv_file VALUES(g_ryv.*)    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ryv_file",g_ryv.ryv01,"",SQLCA.sqlcode,"","",0)  
            ROLLBACK WORK
            CONTINUE WHILE
        ELSE
            COMMIT WORK
            SELECT ryv01 INTO g_ryv.ryv01 FROM ryv_file
                     WHERE ryv01 = g_ryv.ryv01
        END IF
        LET g_ryv_t.* = g_ryv.*
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i102_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,         
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,         
            l_n       LIKE type_file.num5        
   DEFINE   li_result     LIKE type_file.num5 


   DISPLAY BY NAME g_ryv.*

   INPUT BY NAME
      g_ryv.ryv01,g_ryv.ryv03,g_ryv.ryv04
     ,g_ryv.ryvuser,g_ryv.ryvgrup,g_ryv.ryvmodu,
      g_ryv.ryvdate,g_ryv.ryvacti

      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i102_set_entry(p_cmd)
          CALL i102_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ryv01")

      AFTER FIELD ryv01
         IF g_ryv.ryv01 IS NOT NULL THEN
#            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#               (p_cmd = "u" AND g_ryv.ryv01 != g_ryv01_t) THEN 
            IF p_cmd = "a" OR                                  #No.TQC-AA0035 去掉mark
               (p_cmd = "u" AND g_ryv.ryv01 != g_ryv01_t) THEN #No.TQC-AA0035 去掉mark            
         #       CALL s_check_no("art",g_ryv.ryv01,g_ryv_t.ryv01,"T","ryv_file","ryv01","")       #FUN-AA0046   mark
                 CALL s_check_no("art",g_ryv.ryv01,g_ryv_t.ryv01,"F3","ryv_file","ryv01","")       #FUN-AA0046
                    RETURNING li_result,g_ryv.ryv01
                IF (NOT li_result) THEN
                    LET g_ryv.ryv01=g_ryv_t.ryv01
                    NEXT FIELD ryv01
                END IF
#            END IF 
            END IF  #No.TQC-AA0035 去掉mark
         END IF

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_ryv.ryv01 IS NULL THEN
               DISPLAY BY NAME g_ryv.ryv01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD ryv01
            END IF

      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(ryv01) THEN
            LET g_ryv.* = g_ryv_t.*
            CALL i102_show()
            NEXT FIELD ryv01
         END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(ryv01)
              LET g_ryv.ryv01=s_get_doc_no(g_ryv.ryv01)
      #        CALL q_smy(FALSE,FALSE,g_ryv.ryv01,'art','T') RETURNING g_ryv.ryv01       #FUN-AA0046 mark
               CALL q_oay(FALSE,FALSE,g_ryv.ryv01,'F3','art') RETURNING g_ryv.ryv01      #FUN-AA0046
              DISPLAY BY NAME g_ryv.ryv01
              NEXT FIELD ryv01

           OTHERWISE
              EXIT CASE
           END CASE

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

FUNCTION i102_u()
    DEFINE l_ryvpos_o LIKE ryv_file.ryvpos    #TQC-C10030
    IF g_ryv.ryv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ryv.ryvconf<>'N'  THEN
        CALL cl_err('',9022,0)
        RETURN
    END IF
    SELECT * INTO g_ryv.* FROM ryv_file WHERE ryv01=g_ryv.ryv01
    IF g_ryv.ryvacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ryv01_t = g_ryv.ryv01
#TQC-C10030 add begin-----------------
    IF g_aza.aza88 = 'Y' THEN
       LET l_ryvpos_o = g_ryv.ryvpos
       UPDATE ryv_file SET ryvpos='4'
        WHERE ryv01 = g_ryv.ryv01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ryv_file",g_ryv_t.ryv01,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       DISPLAY '4' TO ryvpos
    END IF
#TQC-C10030 add -end------------------
    BEGIN WORK

    OPEN i102_cl USING g_ryv.ryv01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_ryv.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,1)
        RETURN
    END IF

    CALL i102_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ryv_t.* = g_ryv.*
        CALL i102_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ryv.*=g_ryv_t.*
            #TQC-C10030 add begin-----------------
            IF g_aza.aza88 = 'Y' THEN
               UPDATE ryv_file SET ryvpos=l_ryvpos_o
                WHERE ryv01 = g_ryv.ryv01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ryv_file",g_ryv_t.ryv01,"",SQLCA.sqlcode,"","",1)
                  CONTINUE WHILE
               END IF
               LET g_ryv.ryvpos = l_ryvpos_o
            END IF
            #TQC-C10030 add -end------------------
            CALL i102_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_ryv.ryvmodu=g_user                  #修改者
        LET g_ryv.ryvdate = g_today               #修改日期
        IF g_aza.aza88='Y' THEN
          #FUN-B40071 --START--
           #LET g_ryv.ryvpos='N'
           #IF g_ryv.ryvpos <> '1' THEN #TQC-C10030 mark
           IF l_ryvpos_o <> '1' THEN    #TQC-C10030
              LET g_ryv.ryvpos='2'
           ELSE                          #TQC-C10030 ADD
              LET g_ryv.ryvpos='1'       #TQC-C10030 ADD
           END IF 
           DISPLAY BY NAME g_ryv.ryvpos
          #FUN-B40071 --END--
        END IF

        UPDATE ryv_file SET ryv_file.* = g_ryv.*    # 更新DB
            WHERE ryv01 = g_ryv.ryv01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ryv_file",g_ryv.ryv01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION

 
FUNCTION i102_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ryv.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i102_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i102_count
    FETCH i102_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i102_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,0)
        INITIALIZE g_ryv.* TO NULL
    ELSE
        CALL i102_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i102_fetch(p_flryv)
    DEFINE
        p_flryv         LIKE type_file.chr1             
 
    CASE p_flryv
        WHEN 'N' FETCH NEXT     i102_cs INTO g_ryv.ryv01
        WHEN 'P' FETCH PREVIOUS i102_cs INTO g_ryv.ryv01
        WHEN 'F' FETCH FIRST    i102_cs INTO g_ryv.ryv01
        WHEN 'L' FETCH LAST     i102_cs INTO g_ryv.ryv01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
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
            FETCH ABSOLUTE g_jump i102_cs INTO g_ryv.ryv01
            LET mi_no_ask = FALSE         
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,0)
        INITIALIZE g_ryv.* TO NULL  
        LET g_ryv.ryv01 = NULL      
        RETURN
    ELSE
      CASE p_flryv
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
     
    LET g_sql=" SELECT * FROM ryv_file WHERE ryv01='",g_ryv.ryv01,"' "
    PREPARE i102_p1 FROM g_sql
    EXECUTE i102_p1 INTO g_ryv.*

    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ryv_file",g_ryv.ryv01,"",SQLCA.sqlcode,"","",0)  
    END IF
    CALL i102_show()                   # 重新顯示
END FUNCTION

FUNCTION i102_show()
  DEFINE l_gen02   LIKE gen_file.gen02   #add by cockroach 
    LET g_ryv_t.* = g_ryv.*
    DISPLAY BY NAME g_ryv.*
    #--add by cockroach---#
    IF NOT cl_null(g_ryv.ryvconu) THEN
       LET g_sql="SELECT gen02 FROM gen_file WHERE gen01 = '",g_ryv.ryvconu,"'"
       PREPARE i102_conu FROM g_sql
       EXECUTE i102_conu INTO l_gen02

       DISPLAY l_gen02 TO ryvconu_desc
    ELSE
       DISPLAY " "  TO ryvconu_desc
    END IF
    #--add by cockroach---#
                    
    CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION i102_copy()
 DEFINE
        l_newno         LIKE ryv_file.ryv01,
        l_oldno         LIKE ryv_file.ryv01,
        p_cmd     LIKE type_file.chr1,    
        l_input   LIKE type_file.chr1    
 DEFINE li_result   LIKE type_file.num5


    IF g_ryv.ryv01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF

    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i102_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM ryv01

        AFTER FIELD ryv01
           IF l_newno IS NOT NULL THEN
      #       CALL s_check_no("art",l_newno,g_ryv_t.ryv01,"T","ryv_file","ryv01","")        #FUN-AA0046   mark
              CALL s_check_no("art",l_newno,g_ryv_t.ryv01,"F3","ryv_file","ryv01","")        #FUN-AA0046            
                  RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                 NEXT FIELD ryv01
             END IF
           END IF

        ON ACTION controlp                        # 沿用所有欄位
           CASE
              WHEN INFIELD(ryv01)
                LET l_newno = s_get_doc_no(l_newno)
       #         CALL q_smy(FALSE,FALSE,l_newno,'art','T') RETURNING l_newno                #FUN-AA0046   mark
                 CALL q_oay(FALSE,FALSE,l_newno,'F3','art') RETURNING l_newno                #FUN-AA0046
                DISPLAY l_newno TO ryv01
              OTHERWISE EXIT CASE
           END CASE

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
    BEGIN WORK
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_ryv.ryv01
       ROLLBACK WORK
       RETURN
    END IF

#   CALL s_auto_assign_no("art",l_newno,g_today,"T","ryv_file","ryv01","","","")       #FUN-AA0046   mark
    CALL s_auto_assign_no("art",l_newno,g_today,"F3","ryv_file","ryv01","","","")       #FUN-AA0046 
        RETURNING li_result,l_newno
   IF (NOT li_result) THEN
      CALL cl_err('','sub-145',0)
      RETURN
   END IF
   DISPLAY l_newno TO ryv01


    DROP TABLE x
    SELECT * FROM ryv_file
        WHERE ryv01=g_ryv.ryv01
        INTO TEMP x

    UPDATE x
        SET ryv01=l_newno,    #資料鍵值
            ryvacti='Y',      #資料有效碼
            ryvconf='N',      #資料確認碼       #No.TQC-AA0048 add
            ryvuser=g_user,   #資料所有者
            ryvgrup=g_grup,   #資料所有者所屬群
            ryvmodu=NULL,     #資料修改日期
            ryvdate=g_today,  #資料建立日期
            ryvoriu = g_user,
            ryvorig = g_grup 
    INSERT INTO ryv_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ryv_file",l_newno,"",SQLCA.sqlcode,"","",0) 
        ROLLBACK WORK
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ryv.ryv01
        LET g_ryv.ryv01 = l_newno
        SELECT ryv_file.* INTO g_ryv.* FROM ryv_file
               WHERE ryv01 = l_newno
        COMMIT WORK
        CALL i102_u()
        #SELECT ryv_file.* INTO g_ryv.* FROM ryv_file  #FUN-C80046
        #       WHERE ryv01 = l_oldno  #FUN-C80046
    END IF
    #LET g_ryv.ryv01 = l_oldno  #FUN-C80046
    CALL i102_show()
END FUNCTION

FUNCTION i102_r()
    IF g_ryv.ryv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ryv.ryv01 IS NULL THEN
        CALL cl_err('','apc-138',0)
        RETURN
    END IF

    BEGIN WORK

    OPEN i102_cl USING g_ryv.ryv01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 0)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_ryv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i102_show()
    IF cl_delete() THEN
#       LET g_doc.column1 = "ryv01"  
#       LET g_doc.value1 = g_ryv.ryv01
#       CALL cl_del_doc() 
       IF g_aza.aza88='Y' THEN
         #FUN-B40071 --START--
          #IF g_ryv.ryvacti<>'N' OR g_ryv.ryvpos<>'Y' THEN             
          #    CALL cl_err('','apc-139', 1)
          #    ROLLBACK WORK
          #    RETURN
          #END IF
          IF NOT ((g_ryv.ryvpos='3' AND g_ryv.ryvacti='N') 
                     OR (g_ryv.ryvpos='1'))  THEN                  
             CALL cl_err('','apc-139',0)
             ROLLBACK WORK
             RETURN
          END IF      
         #FUN-B40071 --END--
       END IF            
       DELETE FROM ryv_file WHERE ryv01 = g_ryv.ryv01
       CLEAR FORM
       OPEN i102_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i102_cs
          CLOSE i102_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i102_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i102_cs
          CLOSE i102_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i102_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i102_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE  
          CALL i102_fetch('/')
       END IF
    END IF
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION

FUNCTION i102_x()
    IF g_ryv.ryv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ryv.ryvconf<>'N'  THEN
        CALL cl_err('',8889,0)
        RETURN
    END IF

    BEGIN WORK


    OPEN i102_cl USING g_ryv.ryv01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_ryv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i102_show()
    IF cl_exp(0,0,g_ryv.ryvacti) THEN
        LET g_chr=g_ryv.ryvacti
        IF g_ryv.ryvacti='Y' THEN
            LET g_ryv.ryvacti='N'
        ELSE
            LET g_ryv.ryvacti='Y'
        END IF
        UPDATE ryv_file
            SET ryvacti=g_ryv.ryvacti
            WHERE ryv01=g_ryv.ryv01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,0)
            LET g_ryv.ryvacti=g_chr
        END IF
        DISPLAY BY NAME g_ryv.ryvacti
    END IF
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION

#No.TQC-AA0035  -start--
FUNCTION i102_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
 
   IF cl_null(g_ryv.ryv01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
 
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ryv.ryvconf='X' THEN RETURN END IF
    ELSE
       IF g_ryv.ryvconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_ryv.ryvacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_ryv.ryvconf='Y' THEN
#        CALL cl_err('','apy-705',0)   #CHI-B40058
        CALL cl_err('','apc-122',0)    #CHI-B40058
        RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'

    OPEN i102_cl USING g_ryv.ryv01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_ryv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF    
    LET g_ryv_t.* = g_ryv.* 
    IF cl_void(0,0,g_ryv.ryvconf) THEN
      IF g_ryv.ryvconf='X' THEN
         LET g_ryv.ryvconf = 'N'
         LET g_ryv.ryvconu = ''
         LET g_ryv.ryvcond = ''
         LET g_ryv.ryvcont = ''
      ELSE
      	 LET g_ryv.ryvconf = 'X'
      	 LET g_ryv.ryvconu = g_user
         LET g_ryv.ryvcond = g_today
         LET g_ryv.ryvcont = TIME
      END IF
    
      UPDATE ryv_file SET ryvconf = g_ryv.ryvconf,
                          ryvconu = g_ryv.ryvconu,
                          ryvcond = g_ryv.ryvcond,
                          ryvcont = g_ryv.ryvcont,
                          ryvmodu = g_ryv.ryvconu,
                          ryvdate = g_ryv.ryvdate
       WHERE ryv01=g_ryv.ryv01
       IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ryv_file",g_ryv.ryv01,"",STATUS,"","",1)
         LET g_ryv.ryvconf=g_ryv_t.ryvconf
         LET g_ryv.ryvconu=g_ryv_t.ryvconu
         LET g_ryv.ryvcond=g_ryv_t.ryvcond
         LET g_ryv.ryvcont=g_ryv_t.ryvcont
         LET g_success = 'N'
       ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","ryv_file",g_ryv.ryv01,"","9050","","",1)
            LET g_ryv.ryvconf=g_ryv_t.ryvconf
            LET g_ryv.ryvconu=g_ryv_t.ryvconu
            LET g_ryv.ryvcond=g_ryv_t.ryvcond
            LET g_ryv.ryvcont=g_ryv_t.ryvcont
            LET g_success = 'N'
         END IF
      END IF
   END IF
   CLOSE i102_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
       DISPLAY BY NAME g_ryv.ryvconf,g_ryv.ryvconu,g_ryv.ryvcond,
                      g_ryv.ryvcont,g_ryv.ryvuser,g_ryv.ryvdate
      CALL i102_show()
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION
#No.TQC-AA0035  -end--

FUNCTION i102_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    

     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("ryv01",TRUE)
     END IF

END FUNCTION

FUNCTION i102_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1   

    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("ryv01",FALSE)
    END IF

END FUNCTION

FUNCTION i102_confirm()

    IF cl_null(g_ryv.ryv01) THEN
       CALL cl_err('',-400,0)
    END IF
    IF g_ryv.ryvconf<>'N' THEN
       CALL cl_err('',8888,0)
       RETURN
    END IF
    
    IF NOT cl_confirm('art-026') THEN RETURN END IF   #add by cockroach

    BEGIN WORK
    
    LET g_time=TIME    #ADD by cockroach
    OPEN i102_cl USING g_ryv.ryv01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_ryv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryv.ryv01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i102_show()

    UPDATE ryv_file set ryvconu=g_user,ryvcond=g_today,ryvcont=g_time,ryvconf='Y'
      WHERE ryv01=g_ryv.ryv01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ryv_file",g_ryv.ryv01,"",SQLCA.sqlcode,"","",0)
    END IF
    SELECT ryv_file.* INTO g_ryv.* FROM ryv_file
      WHERE ryv01 = g_ryv.ryv01
    CALL i102_show()
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
#FUN-A40024
