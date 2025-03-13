# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri099
# Descriptions...: 薪酬预算制定管理
# Date & Author..: 13/08/07 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hreb    DYNAMIC ARRAY OF RECORD                  
         hreb01   LIKE hreb_file.hreb01,
         hrag07   LIKE hrag_file.hrag07,
         hreb02   LIKE hreb_file.hreb02,
         hreb04   LIKE hreb_file.hreb04
                 END RECORD,
       g_hreb_t  RECORD 
         hreb01   LIKE hreb_file.hreb01,
         hrag07   LIKE hrag_file.hrag07,
         hreb02   LIKE hreb_file.hreb02,
         hreb04   LIKE hreb_file.hreb04
                 END RECORD, 
       g_hreba   DYNAMIC ARRAY OF RECORD                   
         hrag07_a LIKE hrag_file.hrag07,
         hreba02  LIKE hreba_file.hreba02,
         hreba03  LIKE hreba_file.hreba03,
         hreba04  LIKE hreba_file.hreba04,
         hreba05  LIKE hreba_file.hreba05,
         hreba06  LIKE hreba_file.hreba06
                 END RECORD
DEFINE g_rec_b1             LIKE type_file.num5  
DEFINE g_rec_b2             LIKE type_file.num5
DEFINE l_ac                 LIKE type_file.num5 
DEFINE g_flag_b             LIKE type_file.chr1
DEFINE g_sql                STRING
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE SQL          #No.FUN-680102
DEFINE g_before_input_done  LIKE type_file.num5          #判斷是否已執行 Before Input指令       #No.FUN-680102 SMALLINT
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count          LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump               LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE l_name               STRING
DEFINE g_hreb00             LIKE hreb_file.hreb00
DEFINE g_hreb00_t           LIKE hreb_file.hreb00

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                                      #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081

   LET g_forupd_sql = "SELECT hreb00 FROM hreb_file WHERE hreb00=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i099_cl CURSOR FROM g_forupd_sql        # LOCK CURSOR

   OPEN WINDOW i099_w WITH FORM "ghr/42f/ghri099"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL cl_set_combo_items("hreb00",NULL,NULL)
   CALL i099_get_items() RETURNING l_name
   CALL cl_set_combo_items("hreb00",l_name,l_name)
   
   CALL i099_menu()
   
   CLOSE WINDOW i099_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i099_get_items()
DEFINE p_name   STRING
DEFINE p_hrac01 LIKE hrac_file.hrac01
DEFINE l_sql    STRING

       LET p_name=''
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  WHERE hrac01 NOT IN( SELECT hrct04 FROM hrct_file WHERE hrct06='Y')",
                 "  ORDER BY hrac01 "
       PREPARE i099_get_items_pre FROM l_sql
       DECLARE i099_get_items CURSOR FOR i099_get_items_pre
       FOREACH i099_get_items INTO p_hrac01
          IF cl_null(p_name) THEN
            LET p_name=p_hrac01
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrac01 CLIPPED
          END IF
       END FOREACH
       
       RETURN p_name
END FUNCTION

FUNCTION i099_cs()

    CLEAR FORM
    LET g_hreb00=''
    CALL g_hreb.clear()
    CALL g_hreba.clear()
    
    INPUT g_hreb00 WITHOUT DEFAULTS FROM hreb00

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
    END INPUT 

    #資料權限的檢查
    IF cl_null(g_hreb00) THEN 
       LET g_sql="SELECT DISTINCT hreb00 FROM hreb_file ORDER BY hreb00"
    ELSE
       LET g_sql="SELECT DISTINCT hreb00 FROM hreb_file WHERE hreb00='",g_hreb00,"'"
    END IF 
    PREPARE i099_prepare FROM g_sql
    DECLARE i099_cs SCROLL CURSOR WITH HOLD FOR i099_prepare

    DROP TABLE x 
    IF cl_null(g_hreb00) THEN 
       LET g_sql="SELECT DISTINCT hreb00 FROM hreb_file INTO TEMP x"
    ELSE
       LET g_sql="SELECT DISTINCT hreb00 FROM hreb_file WHERE hreb00='",g_hreb00,"' INTO TEMP x"
    END IF 
    PREPARE ins_p FROM g_sql
    EXECUTE ins_p
       
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE i099_precount FROM g_sql
    DECLARE i099_count CURSOR FOR i099_precount
END FUNCTION

FUNCTION i099_menu()

   WHILE TRUE
      CASE g_flag_b
         WHEN '2'
           CALL i099_bp2("G")
         OTHERWISE
           CALL i099_bp1("G")
      END CASE 
      
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i099_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i099_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i099_b()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i099_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i099_r()
            END IF
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_hreb00 IS NOT NULL THEN
                  LET g_doc.column1 = "hreb00"
                  LET g_doc.value1 = g_hreb00
                  CALL cl_doc()
               END IF
            END IF 
         WHEN "yusuan"
            IF cl_chk_act_auth() THEN
               CALL i099_yusuan()
            END IF
         WHEN "help"
            CALL cl_show_help()            
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i099_bp1(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G"  THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hreb TO s_hreb.* ATTRIBUTE(COUNT=g_rec_b1)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(g_curs_index,g_row_count )
                 
      BEFORE ROW
         CALL cl_show_fld_cont()
         
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY 
              
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
              
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY 
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY  
                 
      ON ACTION first
         CALL i099_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i099_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i099_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i099_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i099_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
         
      ON ACTION yusuan
         LET g_action_choice="yusuan"
         EXIT DISPLAY
         
      ON ACTION detail
         LET l_ac=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE     
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about       
         CALL cl_about() 

      ON ACTION page04
         LET g_flag_b='2'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    
      
      ON ACTION related_document       
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i099_bp2(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hreba TO s_hreba.* ATTRIBUTE(COUNT=g_rec_b2)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(g_curs_index,g_row_count )
                 
      BEFORE ROW
         CALL cl_show_fld_cont() 
         
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY 
              
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
              
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY 
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY  
                 
      ON ACTION first
         CALL i099_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i099_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i099_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i099_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i099_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION yusuan
         LET g_action_choice="yusuan"
         EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE     
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about       
         CALL cl_about() 

      ON ACTION page03
         LET g_flag_b='1'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    
      
      ON ACTION related_document       
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i099_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i099_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    
    OPEN i099_count
    FETCH i099_count INTO g_row_count
    
    OPEN i099_cs  
    CALL i099_fetch('F')    
END FUNCTION

FUNCTION i099_next()

    OPEN i099_count
    FETCH i099_count INTO g_row_count
    
    OPEN i099_cs    
    CALL i099_fetch('F') 
END FUNCTION

FUNCTION i099_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr100

    CASE p_flag
        WHEN 'N' FETCH NEXT     i099_cs INTO g_hreb00
        WHEN 'P' FETCH PREVIOUS i099_cs INTO g_hreb00
        WHEN 'F' FETCH FIRST    i099_cs INTO g_hreb00
        WHEN 'L' FETCH LAST     i099_cs INTO g_hreb00
        WHEN '/'
            IF (NOT mi_no_ask) THEN       
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,':' FOR g_jump

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
            FETCH ABSOLUTE g_jump i099_cs INTO g_hreb00
            LET mi_no_ask = FALSE 
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hreb00,SQLCA.sqlcode,0)
        LET g_hreb00=''    #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
         OTHERWISE EXIT CASE 
       END CASE
       CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF

    CALL i099_show() 
END FUNCTION

FUNCTION i099_show()
DEFINE l_hreb03   LIKE hreb_file.hreb03
DEFINE l_user     LIKE hreb_file.hrebuser
DEFINE l_oriu     LIKE hreb_file.hreboriu
DEFINE l_orig     LIKE hreb_file.hreborig
DEFINE l_grup     LIKE hreb_file.hrebgrup
DEFINE l_modu     LIKE hreb_file.hrebmodu
DEFINE l_acti     LIKE hreb_file.hrebacti
DEFINE l_date     LIKE hreb_file.hrebdate

    SELECT DISTINCT hreb03,hrebuser,hreboriu,hreborig,hrebgrup,hrebmodu,hrebacti,hrebdate
      INTO l_hreb03,l_user,l_oriu,l_orig,l_grup,l_modu,l_acti,l_date
      FROM hreb_file
     WHERE hreb00=g_hreb00

    DISPLAY g_hreb00 TO hreb00
    DISPLAY l_hreb03 TO hreb03
    DISPLAY l_user TO hrebuser
    DISPLAY l_oriu TO hreboriu
    DISPLAY l_orig TO hreborig
    DISPLAY l_modu TO hrebmodu
    DISPLAY l_date TO hrebdate
    DISPLAY l_acti TO hrebacti
    DISPLAY l_grup TO hrebgrup
    
    CALL i099_b_fill1()
    CALL i099_b_fill2()
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i099_a()

    MESSAGE ""
    CLEAR FORM                                     # 清螢墓欄位內容
    LET g_hreb00='' 
    LET g_rec_b1=0
    CALL g_hreb.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i099_i("a")             # 各欄位輸入
        IF INT_FLAG THEN 
            LET INT_FLAG = 0
            LET g_hreb00=''
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        CALL i099_b()
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i099_u()

    IF g_hreb00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    CALL cl_opmsg('u')
    LET g_hreb00_t = g_hreb00
    BEGIN WORK

    OPEN i099_cl USING g_hreb00
    IF STATUS THEN
       CALL cl_err("OPEN i099_cl:", STATUS, 1)
       CLOSE i099_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i099_cl INTO g_hreb00               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hreb00,SQLCA.sqlcode,1)
       RETURN
    END IF
    
    WHILE TRUE
        CALL i099_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hreb00=g_hreb00_t
            CALL i099_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hreb_file SET hreb00 = g_hreb00,  # 更新DB
                             hrebmodu=g_user,
                             hrebdate=g_today
         WHERE hreb00 = g_hreb00_t            #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hreb_file",g_hreb00,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i099_cl
    COMMIT WORK
    CALL i099_show()
END FUNCTION

FUNCTION i099_i(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_cnt    LIKE type_file.num5

   INPUT g_hreb00 WITHOUT DEFAULTS FROM hreb00

      AFTER FIELD hreb00
         IF cl_null(g_hreb00) THEN 
            NEXT FIELD hreb00
         END IF 
         IF p_cmd='a' OR (p_cmd='u' AND g_hreb00!=g_hreb00_t) THEN 
            SELECT count(*) INTO l_cnt FROM hreb_file WHERE hreb00=g_hreb00
            IF l_cnt>0 THEN 
                NEXT FIELD hreb00
            END IF 
         END IF 
         
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION CONTROLZ
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

FUNCTION i099_b_fill1()
   LET g_sql = "SELECT hreb01,hrag07,hreb02,hreb04",
               "  FROM hreb_file LEFT OUTER JOIN hrag_file ",
               "    ON hrag06=hreb01 AND hrag01='654'",
               " WHERE hreb00 = '",g_hreb00,"'",
               " ORDER BY hreb01"
   PREPARE i099_pb1 FROM g_sql
   DECLARE i099_pc1 CURSOR FOR i099_pb1
   CALL g_hreb.clear()
   LET g_cnt = 1

   FOREACH i099_pc1 INTO g_hreb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hreb.deleteElement(g_cnt)
   LET g_rec_b1=g_cnt-1
END FUNCTION

FUNCTION i099_b_fill2()
   LET g_sql = "SELECT hrag07,hreba02,hreba03,hreba04,hreba05,hreba06",
               "  FROM hreba_file LEFT OUTER JOIN hrag_file",
               "    ON hrag06=hreba01 AND hrag01='654'",
               " WHERE hreba00 = '",g_hreb00,"'",
               " ORDER BY hreba01,hreba02"
   PREPARE i099_pb2 FROM g_sql
   DECLARE i099_pc2 CURSOR FOR i099_pb2
   CALL g_hreba.clear()
   LET g_cnt = 1

   FOREACH i099_pc2 INTO g_hreba[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b2=g_cnt-1
END FUNCTION

FUNCTION i099_b()
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_allow_insert  LIKE type_file.chr1
DEFINE l_allow_delete  LIKE type_file.chr1
DEFINE l_sum           LIKE hreb_file.hreb03

    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT hreb01,hrag07,hreb02,hreb04",
                       "  FROM hreb_file LEFT OUTER JOIN hrag_file ",
                       "    ON hrag06=hreb01 AND hrag01='654'",
                       " WHERE hreb00=? AND hreb01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i099_bcl_1 CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hreb WITHOUT DEFAULTS FROM s_hreb.*
      ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'     
            IF g_rec_b1>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_hreb_t.* = g_hreb[l_ac].*  #BACKUP
               OPEN i099_bcl_1 USING g_hreb00,g_hreb_t.hreb01
               IF STATUS THEN
                  CALL cl_err("OPEN i099_bcl_1:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i099_bcl_1 INTO g_hreb[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hreb_t.hreb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        ON ACTION controlp
          CASE WHEN INFIELD(hreb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrag06"
                LET g_qryparam.arg1 = "654"
                CALL cl_create_qry() RETURNING g_hreb[l_ac].hreb01
                DISPLAY BY NAME g_hreb[l_ac].hreb01
                NEXT FIELD hreb01
          END CASE

        BEFORE INSERT
           LET p_cmd='a'
           CALL cl_show_fld_cont()

        AFTER FIELD hreb01
           SELECT hrag07 INTO g_hreb[l_ac].hrag07 FROM hrag_file
            WHERE hrag06=g_hreb[l_ac].hreb01 AND hrag01='654'
           DISPLAY BY NAME g_hreb[l_ac].hrag07
           
        AFTER FIELD hreb02
           IF g_hreb[l_ac].hreb02<=0 THEN 
              NEXT FIELD hreb02
           END IF 
    
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i099_bcl_1
              CANCEL INSERT
           END IF
           
        BEGIN WORK
           INSERT INTO hreb_file(hreb00,hreb01,hreb02,hreb03,hreb04,hrebacti,hrebmodu,hreboriu,hreborig,hrebuser,hrebgrup,hrebdate)
                VALUES(g_hreb00,g_hreb[l_ac].hreb01,g_hreb[l_ac].hreb02,'',g_hreb[l_ac].hreb04,
                       'Y',g_user,g_user,g_grup,g_user,g_grup,g_today)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hreb_file",g_hreb00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b1=g_rec_b1+1
           END IF

        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM hreb_file WHERE hreb00 = g_hreb00
                                   AND hreb01 = g_hreb_t.hreb01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hreb_file",g_hreb00,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b1=g_rec_b1-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hreb[l_ac].* = g_hreb_t.*
              CLOSE i099_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hreb00,-263,0)
               LET g_hreb[l_ac].* = g_hreb_t.*
           ELSE
               UPDATE hreb_file SET hreb01=g_hreb[l_ac].hreb01,
                                    hreb02=g_hreb[l_ac].hreb02,
                                    hreb04=g_hreb[l_ac].hreb04
                               WHERE hreb00 = g_hreb00
                                 AND hreb01 = g_hreb_t.hreb01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hreb_file",g_hreb00,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hreb[l_ac].* = g_hreb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR() 

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hreb[l_ac].* = g_hreb_t.*
              END IF
              CLOSE i099_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i099_bcl_1
           COMMIT WORK

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
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
    
    CLOSE i099_bcl_1
    COMMIT WORK

    SELECT sum(hreb02) INTO l_sum FROM hreb_file WHERE hreb00=g_hreb00
    IF l_sum<>0 THEN 
       UPDATE hreb_file SET hreb03=l_sum WHERE hreb00=g_hreb00
    END IF 
    DISPLAY l_sum TO hreb03
END FUNCTION

FUNCTION i099_r()

   IF s_shut(0) THEN RETURN END IF

   IF g_hreb00 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   BEGIN WORK
   OPEN i099_cl USING g_hreb00
   IF STATUS THEN
      CALL cl_err("OPEN i099_cl:", STATUS, 1)
      CLOSE i099_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i099_cl INTO g_hreb00
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hreb00,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i099_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_delh(0,0) THEN                    #確認一下
      DELETE FROM hreb_file
       WHERE hreb00 = g_hreb00
      IF SQLCA.sqlcode THEN 
         CLOSE i099_cl
         ROLLBACK WORK
         RETURN
      END IF 
      DELETE FROM hreba_file
       WHERE hreba00 = g_hreb00
      IF SQLCA.sqlcode THEN 
         CLOSE i099_cl
         ROLLBACK WORK
         RETURN
      END IF 
     
      CLEAR FORM
      LET g_hreb00=''
      CALL g_hreb.clear()
      CALL g_hreba.clear()
   END IF
   CLOSE i099_cl
   COMMIT WORK
   CALL i099_next()
END FUNCTION

FUNCTION i099_yusuan()
DEFINE l_hrdz     RECORD LIKE hrdz_file.*
DEFINE l_hreb01   LIKE hreb_file.hreb01
DEFINE l_hreb02   LIKE hreb_file.hreb02
DEFINE l_sql      STRING
DEFINE l_n        LIKE type_file.num5
DEFINE l_hreba    RECORD LIKE hreba_file.*
DEFINE l_hrdz01   LIKE hrdz_file.hrdz01
DEFINE l_cnt      LIKE type_file.num5

   IF cl_null(g_hreb00) THEN RETURN END IF 
   #是否重新生成
   SELECT count(*) INTO l_cnt FROM hreba_file WHERE hreba00=g_hreb00
   IF l_cnt>0 THEN 
      IF NOT cl_confirm('ghr-165') THEN 
         RETURN
      ELSE
         DELETE FROM hreba_file WHERE hreba00=g_hreb00
      END IF 
   END IF 
   
   SELECT * INTO l_hrdz.* FROM hrdz_file WHERE hrdz00=g_hreb00
   IF STATUS=100 THEN 
      CALL cl_err('','ghr-166',1)
      RETURN
   END IF 
   
   LET l_sql="SELECT hreb01,hreb02 FROM hreb_file WHERE hreb00='",g_hreb00,"'"
   PREPARE hreb01_p FROM l_sql
   DECLARE hreb01_c CURSOR FOR hreb01_p
   FOREACH hreb01_c INTO l_hreb01,l_hreb02
      FOR l_n=1 TO 12
          CASE l_n WHEN '1'  LET l_hrdz01=l_hrdz.hrdz01
                   WHEN '2'  LET l_hrdz01=l_hrdz.hrdz02
                   WHEN '3'  LET l_hrdz01=l_hrdz.hrdz03
                   WHEN '4'  LET l_hrdz01=l_hrdz.hrdz04
                   WHEN '5'  LET l_hrdz01=l_hrdz.hrdz05
                   WHEN '6'  LET l_hrdz01=l_hrdz.hrdz06
                   WHEN '7'  LET l_hrdz01=l_hrdz.hrdz07
                   WHEN '8'  LET l_hrdz01=l_hrdz.hrdz08
                   WHEN '9'  LET l_hrdz01=l_hrdz.hrdz09
                   WHEN '10' LET l_hrdz01=l_hrdz.hrdz10
                   WHEN '11' LET l_hrdz01=l_hrdz.hrdz11
                   WHEN '12' LET l_hrdz01=l_hrdz.hrdz12
          END CASE 
          LET l_hreba.hreba00=g_hreb00
          LET l_hreba.hreba01=l_hreb01
          LET l_hreba.hreba02=l_n USING '&&'
          LET l_hreba.hreba03=l_hreb02*l_hrdz01/100
          LET l_hreba.hreba04=0
          LET l_hreba.hreba05=0
          LET l_hreba.hreba06=0
          INSERT INTO hreba_file VALUES (l_hreba.*)
      END FOR
   END FOREACH 
   CALL i099_b_fill2()
END FUNCTION 
