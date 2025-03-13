# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimt506.4gl
# Descriptions...: imggg庫存單位維護作業(aimt506)
# Date & Author..: 11/10/19 By Jason
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查;抓ime_file資料添加imeacti='Y'條件
# Modify.........: No.TQC-DB0055 13/11/21 By wangrr 增加'規格'欄位,'倉庫'增加開窗

#FUN-BA0056
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_imgg               RECORD LIKE imgg_file.*,
    g_imgg_t             RECORD LIKE imgg_file.*,
    g_imgg_o             RECORD LIKE imgg_file.*,
    g_imgg01_t           LIKE imgg_file.imgg01,
    g_imgg02_t           LIKE imgg_file.imgg02,
    g_imgg09_t           LIKE imgg_file.imgg09,
    g_wc,g_sql          string                     
DEFINE p_row,p_col          LIKE type_file.num5    
DEFINE g_forupd_sql         STRING                 
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_cnt                LIKE type_file.num10   
DEFINE g_msg                LIKE type_file.chr1000 
DEFINE g_row_count          LIKE type_file.num10   
DEFINE g_curs_index         LIKE type_file.num10   
DEFINE g_jump               LIKE type_file.num10   
DEFINE mi_no_ask            LIKE type_file.num5    
MAIN

 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    INITIALIZE g_imgg.* TO NULL
    INITIALIZE g_imgg_t.* TO NULL
    INITIALIZE g_imgg_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imgg_file WHERE imgg01 = ? AND imgg02 = ? ",
                        "AND imgg03 = ? AND imgg04 = ? AND imgg09 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t506_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW t506_w AT p_row,p_col WITH FORM "aim/42f/aimt506"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
 
 
    WHILE TRUE
      LET g_action_choice=""
    CALL t506_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t506_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t506_cs()
    CLEAR FORM
    INITIALIZE g_imgg.* TO NULL  
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        imgg01,imgg02,imgg03,imgg04,imgg09,imgg10,imgg21
              
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
 
       ON ACTION controlp
          CASE              
               WHEN INFIELD(imgg01)

                    CALL q_sel_ima( TRUE, "q_ima","",g_imgg.imgg01,"","","","","",'')  RETURNING  g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imgg01
                    NEXT FIELD imgg01
               #TQC-DB0055--add--str--
               WHEN INFIELD(imgg02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_img1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imgg02
                    NEXT FIELD imgg02
               #TQC-DB0055--add--end       
               WHEN INFIELD(imgg09) #庫存單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imgg09
                    NEXT FIELD imgg09
               OTHERWISE EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    LET g_sql="SELECT imgg01,imgg02,imgg03,imgg04,imgg09",
              " FROM imgg_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY imgg01"
    PREPARE t506_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t506_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t506_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imgg_file WHERE ",g_wc CLIPPED # 捉出符合QBE條件的
    PREPARE t506_precount FROM g_sql
    DECLARE t506_count CURSOR FOR t506_precount
END FUNCTION
 
FUNCTION t506_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t506_q()
            END IF
        ON ACTION next
            CALL t506_fetch('N')
        ON ACTION previous
            CALL t506_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"  
            IF cl_chk_act_auth() THEN    
                 CALL t506_u()
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
            CALL t506_fetch('/')
            
        ON ACTION first
            CALL t506_fetch('F')
            
        ON ACTION last
            CALL t506_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION controlg      
           CALL cl_cmdask()
 
       ON ACTION gen_w_h_data   #產生庫別資料
          LET g_action_choice="gen_w_h_data"
          IF cl_chk_act_auth() THEN
             CALL t506_ins_imgg()
          END IF
         
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_imgg.imgg01 IS NOT NULL THEN
                 LET g_doc.column1 = "imgg01"
                 LET g_doc.value1 = g_imgg.imgg01
                 CALL cl_doc()
              END IF
           END IF      
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT)   
             LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
      &include "qry_string.4gl"
    END MENU
    CLOSE t506_cs
END FUNCTION
 
 
FUNCTION t506_i(p_cmd)
    DEFINE
        p_cmd       LIKE type_file.chr1,    
        l_n         LIKE type_file.num5,    
        l_ima25     LIKE ima_file.ima25
    DEFINE l_cnt    LIKE type_file.num5
    
    INPUT BY NAME g_imgg.imgg01,g_imgg.imgg02,
                  g_imgg.imgg03,g_imgg.imgg04,
                  g_imgg.imgg09 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t506_set_entry(p_cmd)
        CALL t506_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
    #--END
 
       AFTER FIELD imgg09
          IF NOT cl_null(g_imgg.imgg09) THEN       
             SELECT COUNT(*) INTO l_cnt FROM gfe_file
              WHERE gfe01 = g_imgg.imgg09
             IF l_cnt = 0 THEN 
                CALL cl_err('','afa-319',0)
                NEXT FIELD imgg09
             ELSE
                SELECT COUNT(*) INTO l_n FROM imgg_file    #check 已存在imgg檔中不可異動
                 WHERE imgg01 =g_imgg.imgg01
                  AND imgg02=g_imgg.imgg02
                  AND imgg03=g_imgg.imgg03
                  AND imgg04=g_imgg.imgg04     
                  AND imgg09 =g_imgg.imgg09         
                IF l_n>0 THEN
                  CALL cl_err(g_imgg.imgg09,'aec-009',0)
                  NEXT FIELD imgg09
                END IF    
                SELECT ima25 INTO l_ima25 FROM ima_file
                 WHERE g_imgg.imgg01 = ima01
                  CALL s_umfchk(g_imgg.imgg01,g_imgg.imgg09,l_ima25)
                         RETURNING g_cnt,g_imgg.imgg21
                IF g_cnt = 1 THEN
                   CALL cl_err('','abm-731',1)
                   NEXT FIELD imgg09
                END IF
                DISPLAY BY NAME g_imgg.imgg21
             END IF   
          END IF
 
       ON ACTION controlp
          CASE
               WHEN INFIELD(imgg09) #庫存單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_imgg.imgg09
                    CALL cl_create_qry() RETURNING g_imgg.imgg09
                    DISPLAY BY NAME g_imgg.imgg09
                    NEXT FIELD imgg09
               OTHERWISE EXIT CASE
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
 
FUNCTION t506_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t506_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t506_count
    FETCH t506_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t506_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0)
        INITIALIZE g_imgg.* TO NULL
    ELSE
        CALL t506_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t506_fetch(p_flimgg)
    DEFINE
        p_flimgg          LIKE type_file.chr1    
 
    CASE p_flimgg
        WHEN 'N' FETCH NEXT     t506_cs INTO g_imgg.imgg01
             ,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09 
        WHEN 'P' FETCH PREVIOUS t506_cs INTO g_imgg.imgg01
             ,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09
        WHEN 'F' FETCH FIRST    t506_cs INTO g_imgg.imgg01
             ,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09
        WHEN 'L' FETCH LAST     t506_cs INTO g_imgg.imgg01
             ,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t506_cs INTO g_imgg.imgg01
             ,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0)
        INITIALIZE g_imgg.* TO NULL  
        RETURN
    ELSE
       CASE p_flimgg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imgg.* FROM imgg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imgg01 = g_imgg.imgg01 AND imgg02 = g_imgg.imgg02 
       AND imgg03 = g_imgg.imgg03 AND imgg04 = g_imgg.imgg04 AND imgg09 = g_imgg.imgg09 
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode = 100 THEN          
          CALL cl_err3("sel","imgg_file",g_imgg.imgg01,"",'aim-166',"","",1)
       ELSE  
          CALL cl_err3("sel","imgg_file",g_imgg.imgg01,"",SQLCA.sqlcode,"","",1)
       END IF      
    ELSE
        CALL t506_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t506_show()
    DEFINE
      d_ima02   LIKE ima_file.ima02,
      d_ima05   LIKE ima_file.ima05,
      d_ima08   LIKE ima_file.ima08,
      d_ima25   LIKE ima_file.ima25
   DEFINE l_ima021   LIKE ima_file.ima021 #TQC-DB0055
 
     LET g_imgg_t.* = g_imgg.*
     DISPLAY BY NAME g_imgg.imgg01
             ,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09,
              g_imgg.imgg10,g_imgg.imgg21
    SELECT ima02,ima021,ima05,ima08,ima25           #TQC-DB0055 add ima021
      INTO d_ima02,l_ima021,d_ima05,d_ima08,d_ima25 #TQC-DB0055 add l_ima021
      FROM ima_file
     WHERE g_imgg.imgg01 = ima01
    DISPLAY d_ima02,l_ima021,d_ima05,d_ima08,d_ima25 #TQC-DB0055 add l_ima021 
         TO ima02,ima021,ima05,ima08,ima25           #TQC-DB0055 add ima021
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t506_u()
DEFINE       l_n    LIKE type_file.num5    
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imgg.imgg01 IS NULL THEN     #未先查詢即選UPDATE
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM tlff_file    #check 存在tlff檔中不可異動
     WHERE tlff01 =g_imgg.imgg01
       AND tlff902=g_imgg.imgg02
       AND tlff903=g_imgg.imgg03
       AND tlff904=g_imgg.imgg04     
       AND tlff11 =g_imgg.imgg09         
    IF l_n>0 THEN
      CALL cl_err(g_imgg.imgg01,'aim-804',0)
      RETURN
    END IF
    
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imgg09_t = g_imgg.imgg09
    LET g_imgg_o.*=g_imgg.*  #保留舊值
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t506_cl USING g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09
    FETCH t506_cl INTO g_imgg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t506_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t506_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imgg.*=g_imgg_t.*
            CALL t506_show()
            CALL cl_err('',9001,0)
            RETURN
        END IF
        UPDATE imgg_file SET imgg09 = g_imgg.imgg09,
                            imgg21 = g_imgg.imgg21,
                            imgg20 = 1             # 更新DB
            WHERE imgg01 = g_imgg_o.imgg01 AND imgg02 = g_imgg_o.imgg02 
             AND imgg03 = g_imgg_o.imgg03 AND imgg04 = g_imgg_o.imgg04  
             AND imgg09 = g_imgg_o.imgg09
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","imgg_file",g_imgg_t.imgg01,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
        LET g_errno = TIME
        LET g_msg = 'Chg No:',g_imgg.imgg01
        INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
           VALUES ('aimt506',g_user,g_today,g_errno,g_imgg.imgg01,g_msg,g_plant,g_legal) 
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("ins","azo_file",g_user,g_today,SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t506_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
  
FUNCTION t506_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("imgg01,imgg02,imgg03,imgg04",TRUE)
   END IF
END FUNCTION
 
FUNCTION t506_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("imgg01,imgg02,imgg03,imgg04",FALSE)
   END IF
END FUNCTION

FUNCTION t506_ins_imgg()   
   DEFINE l_wc      LIKE type_file.chr1000  
   DEFINE g_defstk  LIKE type_file.chr1
   DEFINE g_stk     LIKE imf_file.imf02    
   DEFINE g_loc     LIKE imf_file.imf03
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_ima     RECORD LIKE ima_file.*    
   DEFINE l_imgg    RECORD LIKE imgg_file.*
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_showmsg     STRING
   DEFINE l_imgg21  LIKE imgg_file.imgg21

   LET INT_FLAG = 0
   LET p_row = 6 LET p_col = 18
   OPEN WINDOW t506_w1 AT p_row,p_col        #顯示畫面
        WITH FORM "aim/42f/aimt5061"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("aimt5061")

   CONSTRUCT l_wc ON ima01,ima06,ima09,ima10,ima11,ima12
                FROM ima01,ima06,ima09,ima10,ima11,ima12              
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW t506_w1 RETURN
   END IF

   LET g_defstk = 'Y'
   LET g_stk = ' '
   LET g_loc = ' '   
   
   INPUT BY NAME g_defstk,g_stk,g_loc WITHOUT DEFAULTS
     BEFORE INPUT 
        CALL cl_set_comp_entry("g_stk,g_loc",g_defstk = 'N')
     AFTER FIELD g_stk
        IF g_stk IS NOT NULL AND g_stk !=' ' THEN
           SELECT COUNT(*) INTO l_cnt FROM imd_file
            WHERE imd01=g_stk  AND imdacti = 'Y'        
           IF l_cnt=0 THEN
              CALL cl_err(g_stk,'mfg1100',0)
              NEXT FIELD g_stk
           END IF
	IF NOT s_imechk(g_stk,g_loc) THEN NEXT FIELD g_loc END IF  #FUN-D40103 add
        END IF  
     AFTER FIELD g_loc
	 #FUN-D40103--mark--str--
         #   IF g_loc IS NOT NULL AND g_loc !=' ' THEN
         #  SELECT COUNT(*) INTO l_cnt FROM ime_file
         #     WHERE ime01=g_stk AND ime02=g_loc
         #  IF l_cnt=0 THEN
         #     CALL cl_err(g_loc,'mfg1101',0)
         #     NEXT FIELD g_loc
         #  END IF
         # END IF
	 #FUN-D40103--mark--end--

        IF g_loc IS NULL THEN LET g_loc=' ' END IF
	IF NOT s_imechk(g_stk,g_loc) THEN NEXT FIELD g_loc END IF  #FUN-D40103 add

     ON CHANGE g_defstk        
           CALL cl_set_comp_entry("g_stk,g_loc",g_defstk = 'N')
           
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(g_stk)
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_imd"
              LET g_qryparam.default1 = g_stk
              LET g_qryparam.arg1     = 'SW'        #倉庫類別 
              CALL cl_create_qry() RETURNING g_stk
              DISPLAY BY NAME g_stk
              NEXT FIELD g_stk
           WHEN INFIELD(g_loc)              
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ime"
              LET g_qryparam.default1 = g_loc
              LET g_qryparam.arg1     = g_stk             #倉庫編號 
              LET g_qryparam.arg2     = 'SW'              #倉庫類別 
              CALL cl_create_qry() RETURNING g_loc
              DISPLAY BY NAME g_loc
              NEXT FIELD g_loc
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t506_w1
       RETURN         
   END IF

   CALL cl_wait()
   BEGIN WORK
   LET g_success='Y'  
   CALL s_showmsg_init()
   #ins img_file
   IF NOT  t505s_ins_img(l_wc,g_stk,g_loc,g_defstk) THEN
      LET g_success = 'N' 
   END IF

   #ins imgg_file
   LET l_sql = "SELECT * FROM ima_file WHERE 1=1 AND ",l_wc CLIPPED
   PREPARE t506_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare ima',SQLCA.SQLCODE,1)
      CLOSE WINDOW t506_w1 RETURN
   END IF
   DECLARE t506_c1 CURSOR FOR t506_p1   
   FOREACH t506_c1 INTO l_ima.*
      IF NOT s_chk_item_no(l_ima.ima01,"") THEN
         CONTINUE FOREACH
      END IF
      CASE l_ima.ima906
         WHEN '2'
            LET l_imgg.imgg00 = '1'
         WHEN '3'
            LET l_imgg.imgg00 = '2'
         OTHERWISE
            CONTINUE FOREACH 
      END CASE 
      LET l_imgg.imgg01 = l_ima.ima01
      LET l_imgg.imgg02 = g_stk
      LET l_imgg.imgg03 = g_loc     
      LET l_imgg.imgg04 = ' '      
     
      #以料件主檔主要倉庫/儲位新增
      IF g_defstk = 'Y' THEN
         LET l_imgg.imgg02 = l_ima.ima35
         LET l_imgg.imgg03 = l_ima.ima36
      END IF
      
      LET l_imgg.imgg08 = 0
      LET l_imgg.imgg09 = l_ima.ima907 
      LET l_imgg.imgg10 = 0
      LET l_imgg.imgg13 = null    
      LET l_imgg.imgg14 = g_today
      LET l_imgg.imgg15 = g_today
      LET l_imgg.imgg16 = g_today
      LET l_imgg.imgg17 = g_today       
      #LET l_imgg.imgg18 = g_today + l_ima.ima71   #儲存有效天數
      LET l_imgg.imgg18 = null
      LET l_imgg.imgg20 = 1                       #轉換率
      LET l_imgg.imgg21 = 1                       #轉換率 

      LET l_showmsg = l_imgg.imgg01, '/', l_imgg.imgg02, '/', l_imgg.imgg03, '/', l_imgg.imgg09
      
      CALL s_umfchk(l_imgg.imgg01,l_imgg.imgg09,l_ima.ima25)
                         RETURNING g_cnt,l_imgg21
      IF g_cnt = 1 AND l_imgg.imgg01 = '1' THEN
         CALL s_errmsg('imgg01,imgg02,imgg03,imgg09',l_showmsg,'ins imgg',"abm-731",1)
         LET g_success = 'N'
         CONTINUE FOREACH
      ELSE 
         LET l_imgg.imgg21 = l_imgg21
      END IF

      LET l_imgg.imgg211 = l_imgg.imgg21
      
      SELECT ime04,ime05,ime06,ime07,ime09
        INTO l_imgg.imgg22,l_imgg.imgg23,l_imgg.imgg24,l_imgg.imgg25,l_imgg.imgg26
        FROM ime_file
       WHERE ime01 = l_imgg.imgg02 AND ime02 = l_imgg.imgg03
		AND imeacti='Y'  #FUN-D40103 add
      IF STATUS = 100 THEN
         LET l_imgg.imgg22='S'                    #倉儲類別
         LET l_imgg.imgg23='Y'                    #是否為可用倉儲
         LET l_imgg.imgg24='N'                    #是否為MRP可用倉儲
         LET l_imgg.imgg25='N'                    #保稅與否
      END IF      
      LET l_imgg.imgg37 = g_today             
      LET l_imgg.imggplant = g_plant
      LET l_imgg.imgglegal = g_legal

      CALL t506_insert_imgg(l_imgg.*) 

      IF l_imgg.imgg00 = '1' THEN
         LET l_imgg.imgg09 = l_ima.ima25
         LET l_imgg.imgg21 = 1
         LET l_imgg.imgg211 = 1
         CALL t506_insert_imgg(l_imgg.*) 
      END IF 
      
   END FOREACH  

   CALL s_showmsg()   
   IF g_success='Y' THEN
      MESSAGE 'Insert Ok!'
      COMMIT WORK CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK CALL cl_rbmsg(1)
   END IF   
   CLOSE WINDOW t506_w1
END FUNCTION

FUNCTION t506_insert_imgg(l_imgg)
DEFINE l_imgg    RECORD LIKE imgg_file.*
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_showmsg     STRING

   IF l_imgg.imgg02 IS NULL THEN LET l_imgg.imgg02 = ' ' END IF
   IF l_imgg.imgg03 IS NULL THEN LET l_imgg.imgg03 = ' ' END IF
   IF l_imgg.imgg04 IS NULL THEN LET l_imgg.imgg04 = ' ' END IF

   LET l_showmsg = l_imgg.imgg01, '/', l_imgg.imgg02, '/', l_imgg.imgg03, '/', l_imgg.imgg09

   #檢查重覆
   LET l_cnt = 0     
   SELECT COUNT(*) INTO l_cnt FROM imgg_file  
    WHERE imgg01 = l_imgg.imgg01 AND imgg02 = l_imgg.imgg02
      AND imgg03 = l_imgg.imgg03 AND imgg04 = l_imgg.imgg04
      AND imgg09 = l_imgg.imgg09 
   IF l_cnt > 0 THEN
      CALL s_errmsg('imgg01,imgg02,imgg03,imgg09',l_showmsg,'ins imgg',"agl-185",1) 
      RETURN
   END IF 
   IF s_internal_item( l_imgg.imgg01,g_plant ) AND NOT s_joint_venture( l_imgg.imgg01 ,g_plant) THEN  
      INSERT INTO imgg_file VALUES (l_imgg.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN            
         CALL s_errmsg('imgg01,imgg02,imgg03,imgg09',l_showmsg,'ins imgg',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN 
      ELSE           
         MESSAGE 'Insert imgg:',l_imgg.imgg01 CLIPPED, '/',l_imgg.imgg02 CLIPPED,
                            '/',l_imgg.imgg03 CLIPPED, '/',l_imgg.imgg09 CLIPPED
      END IF
   END IF
END FUNCTION 
#FUN-BA0056 

