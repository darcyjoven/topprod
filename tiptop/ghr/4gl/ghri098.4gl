# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri098
# Descriptions...: 薪酬总额模版管理
# Date & Author..: 13/08/08 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrea    DYNAMIC ARRAY OF RECORD                  
         hrea01   LIKE hrea_file.hrea01,
         hrag07   LIKE hrag_file.hrag07,
         hrea02   LIKE hrea_file.hrea02,
         hrdk03   LIKE hrdk_file.hrdk03,
         hrea03   LIKE hrea_file.hrea03
                 END RECORD,
       g_hrea_t  RECORD 
         hrea01   LIKE hrea_file.hrea01,
         hrag07   LIKE hrag_file.hrag07,
         hrea02   LIKE hrea_file.hrea02,
         hrdk03   LIKE hrdk_file.hrdk03,
         hrea03   LIKE hrea_file.hrea03
                 END RECORD
DEFINE g_rec_b             LIKE type_file.num5  
DEFINE l_ac                 LIKE type_file.num5 
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
DEFINE g_hrea00             LIKE hrea_file.hrea00
DEFINE g_hrea00_t           LIKE hrea_file.hrea00

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

   LET g_forupd_sql = "SELECT hrea00 FROM hrea_file WHERE hrea00=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i098_cl CURSOR FROM g_forupd_sql        # LOCK CURSOR

   OPEN WINDOW i098_w WITH FORM "ghr/42f/ghri098"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL cl_set_combo_items("hrea00",NULL,NULL)
   CALL i098_get_items() RETURNING l_name
   CALL cl_set_combo_items("hrea00",l_name,l_name)
   
   CALL i098_menu()
   
   CLOSE WINDOW i098_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i098_get_items()
DEFINE p_name   STRING
DEFINE p_hrac01 LIKE hrac_file.hrac01
DEFINE l_sql    STRING

       LET p_name=''
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  WHERE hrac01 NOT IN( SELECT hrct04 FROM hrct_file WHERE hrct06='Y')",
                 "  ORDER BY hrac01 "
       PREPARE i098_get_items_pre FROM l_sql
       DECLARE i098_get_items CURSOR FOR i098_get_items_pre
       FOREACH i098_get_items INTO p_hrac01
          IF cl_null(p_name) THEN
            LET p_name=p_hrac01
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrac01 CLIPPED
          END IF
       END FOREACH
       
       RETURN p_name
END FUNCTION

FUNCTION i098_cs()

    CLEAR FORM
    LET g_hrea00=''
    CALL g_hrea.clear()
    
    INPUT g_hrea00 WITHOUT DEFAULTS FROM hrea00

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
    IF cl_null(g_hrea00) THEN 
       LET g_sql="SELECT DISTINCT hrea00 FROM hrea_file ORDER BY hrea00"
    ELSE
       LET g_sql="SELECT DISTINCT hrea00 FROM hrea_file WHERE hrea00='",g_hrea00,"'"
    END IF 
    PREPARE i098_prepare FROM g_sql
    DECLARE i098_cs SCROLL CURSOR WITH HOLD FOR i098_prepare

    DROP TABLE x 
    IF cl_null(g_hrea00) THEN 
       LET g_sql="SELECT DISTINCT hrea00 FROM hrea_file INTO TEMP x"
    ELSE
       LET g_sql="SELECT DISTINCT hrea00 FROM hrea_file WHERE hrea00='",g_hrea00,"' INTO TEMP x"
    END IF 
    PREPARE ins_p FROM g_sql
    EXECUTE ins_p
       
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE i098_precount FROM g_sql
    DECLARE i098_count CURSOR FOR i098_precount
END FUNCTION

FUNCTION i098_menu()

   WHILE TRUE
      CALL i098_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i098_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i098_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i098_b()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i098_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i098_r()
            END IF
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_hrea00 IS NOT NULL THEN
                  LET g_doc.column1 = "hrea00"
                  LET g_doc.value1 = g_hrea00
                  CALL cl_doc()
               END IF
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

FUNCTION i098_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G"  THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrea TO s_hrea.* ATTRIBUTE(COUNT=g_rec_b)
                 
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
         CALL i098_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i098_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL i098_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i098_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION last
         CALL i098_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

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

FUNCTION i098_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i098_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    
    OPEN i098_count
    FETCH i098_count INTO g_row_count
    
    OPEN i098_cs  
    CALL i098_fetch('F')    
END FUNCTION

FUNCTION i098_next()

    OPEN i098_count
    FETCH i098_count INTO g_row_count
    
    OPEN i098_cs    
    CALL i098_fetch('F') 
END FUNCTION

FUNCTION i098_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr100

    CASE p_flag
        WHEN 'N' FETCH NEXT     i098_cs INTO g_hrea00
        WHEN 'P' FETCH PREVIOUS i098_cs INTO g_hrea00
        WHEN 'F' FETCH FIRST    i098_cs INTO g_hrea00
        WHEN 'L' FETCH LAST     i098_cs INTO g_hrea00
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
            FETCH ABSOLUTE g_jump i098_cs INTO g_hrea00
            LET mi_no_ask = FALSE 
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrea00,SQLCA.sqlcode,0)
        LET g_hrea00=''    #TQC-6B0105
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

    CALL i098_show() 
END FUNCTION

FUNCTION i098_show()
DEFINE l_user     LIKE hrea_file.hreauser
DEFINE l_oriu     LIKE hrea_file.hreaoriu
DEFINE l_orig     LIKE hrea_file.hreaorig
DEFINE l_grup     LIKE hrea_file.hreagrup
DEFINE l_modu     LIKE hrea_file.hreamodu
DEFINE l_acti     LIKE hrea_file.hreaacti
DEFINE l_date     LIKE hrea_file.hreadate

    SELECT DISTINCT hreauser,hreaoriu,hreaorig,hreagrup,hreamodu,hreaacti,hreadate
      INTO l_user,l_oriu,l_orig,l_grup,l_modu,l_acti,l_date
      FROM hrea_file
     WHERE hrea00=g_hrea00

    DISPLAY g_hrea00 TO hrea00
    DISPLAY l_user TO hreauser
    DISPLAY l_oriu TO hreaoriu
    DISPLAY l_orig TO hreaorig
    DISPLAY l_modu TO hreamodu
    DISPLAY l_date TO hreadate
    DISPLAY l_acti TO hreaacti
    DISPLAY l_grup TO hreagrup
    
    CALL i098_b_fill()
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i098_a()

    MESSAGE ""
    CLEAR FORM                                     # 清螢墓欄位內容
    LET g_hrea00='' 
    LET g_rec_b=0
    CALL g_hrea.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i098_i("a")             # 各欄位輸入
        IF INT_FLAG THEN 
            LET INT_FLAG = 0
            LET g_hrea00=''
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        CALL i098_b()
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i098_u()

    IF g_hrea00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    CALL cl_opmsg('u')
    LET g_hrea00_t = g_hrea00
    BEGIN WORK

    OPEN i098_cl USING g_hrea00
    IF STATUS THEN
       CALL cl_err("OPEN i098_cl:", STATUS, 1)
       CLOSE i098_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i098_cl INTO g_hrea00               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrea00,SQLCA.sqlcode,1)
       RETURN
    END IF
    
    WHILE TRUE
        CALL i098_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrea00=g_hrea00_t
            CALL i098_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrea_file SET hrea00 = g_hrea00,  # 更新DB
                             hreamodu=g_user,
                             hreadate=g_today
         WHERE hrea00 = g_hrea00_t            #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrea_file",g_hrea00,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i098_cl
    COMMIT WORK
    CALL i098_show()
END FUNCTION

FUNCTION i098_i(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_cnt    LIKE type_file.num5

   INPUT g_hrea00 WITHOUT DEFAULTS FROM hrea00

      AFTER FIELD hrea00
         IF cl_null(g_hrea00) THEN 
            NEXT FIELD hrea00
         END IF 
         IF p_cmd='a' OR (p_cmd='u' AND g_hrea00!=g_hrea00_t) THEN 
            SELECT count(*) INTO l_cnt FROM hrea_file WHERE hrea00=g_hrea00
            IF l_cnt>0 THEN 
                NEXT FIELD hrea00
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

FUNCTION i098_b_fill()
   LET g_sql = "SELECT hrea01,hrag07,hrea02,hrdk03,hrea03",
               "  FROM hrea_file LEFT OUTER JOIN hrag_file ",
               "    ON hrag06=hrea01 AND hrag01='654'",
               "  LEFT OUTER JOIN hrdk_file ON hrdk01=hrea02",
               " WHERE hrea00 = '",g_hrea00,"'",
               " ORDER BY hrea01"
   PREPARE i098_pb FROM g_sql
   DECLARE i098_pc CURSOR FOR i098_pb
   CALL g_hrea.clear()
   LET g_cnt = 1

   FOREACH i098_pc INTO g_hrea[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrea.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
END FUNCTION

FUNCTION i098_b()
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_allow_insert  LIKE type_file.chr1
DEFINE l_allow_delete  LIKE type_file.chr1
DEFINE l_sum           LIKE hrea_file.hrea03

    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT hrea01,hrag07,hrea02,hrdk03,hrea03",
                       "  FROM hrea_file LEFT OUTER JOIN hrag_file ",
                       "    ON hrag06=hrea01 AND hrag01='654'",
                       "  LEFT OUTER JOIN hrdk_file ON hrdk01=hrea02",
                       " WHERE hrea00=? AND hrea01=? AND hrea02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i098_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrea WITHOUT DEFAULTS FROM s_hrea.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'     
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_hrea_t.* = g_hrea[l_ac].*  #BACKUP
               OPEN i098_bcl USING g_hrea00,g_hrea_t.hrea01,g_hrea_t.hrea02
               IF STATUS THEN
                  CALL cl_err("OPEN i098_bcl_1:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i098_bcl INTO g_hrea[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrea_t.hrea01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        ON ACTION controlp
          CASE WHEN INFIELD(hrea01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrag06"
                LET g_qryparam.arg1 = "654"
                CALL cl_create_qry() RETURNING g_hrea[l_ac].hrea01
                DISPLAY BY NAME g_hrea[l_ac].hrea01
                NEXT FIELD hrea01
               WHEN INFIELD(hrea02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrdk01"
                CALL cl_create_qry() RETURNING g_hrea[l_ac].hrea02
                DISPLAY BY NAME g_hrea[l_ac].hrea02
                NEXT FIELD hrea02
          END CASE

        BEFORE INSERT
           LET p_cmd='a'
           CALL cl_show_fld_cont()

        AFTER FIELD hrea01
           SELECT hrag07 INTO g_hrea[l_ac].hrag07 FROM hrag_file
            WHERE hrag06=g_hrea[l_ac].hrea01 AND hrag01='654'
           DISPLAY BY NAME g_hrea[l_ac].hrag07
           
        AFTER FIELD hrea02
           SELECT hrdk03 INTO g_hrea[l_ac].hrdk03 FROM hrdk_file
            WHERE hrdk01=g_hrea[l_ac].hrea02
           DISPLAY BY NAME g_hrea[l_ac].hrdk03
    
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i098_bcl
              CANCEL INSERT
           END IF
           
        BEGIN WORK
           INSERT INTO hrea_file(hrea00,hrea01,hrea02,hrea03,hreaacti,hreamodu,hreaoriu,hreaorig,hreauser,hreagrup,hreadate)
                VALUES(g_hrea00,g_hrea[l_ac].hrea01,g_hrea[l_ac].hrea02,g_hrea[l_ac].hrea03,
                       'Y',g_user,g_user,g_grup,g_user,g_grup,g_today)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hrea_file",g_hrea00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
           END IF

        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM hrea_file WHERE hrea00 = g_hrea00
                                   AND hrea01 = g_hrea_t.hrea01
                                   AND hrea02 = g_hrea_t.hrea02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrea_file",g_hrea00,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b=g_rec_b-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrea[l_ac].* = g_hrea_t.*
              CLOSE i098_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrea00,-263,0)
               LET g_hrea[l_ac].* = g_hrea_t.*
           ELSE
               UPDATE hrea_file SET hrea01=g_hrea[l_ac].hrea01,
                                    hrea02=g_hrea[l_ac].hrea02,
                                    hrea03=g_hrea[l_ac].hrea03
                               WHERE hrea00 = g_hrea00
                                 AND hrea01 = g_hrea_t.hrea01
                                 AND hrea02 = g_hrea_t.hrea02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrea_file",g_hrea00,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrea[l_ac].* = g_hrea_t.*
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
                 LET g_hrea[l_ac].* = g_hrea_t.*
              END IF
              CLOSE i098_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i098_bcl
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
    
    CLOSE i098_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i098_r()

   IF s_shut(0) THEN RETURN END IF

   IF g_hrea00 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   BEGIN WORK
   OPEN i098_cl USING g_hrea00
   IF STATUS THEN
      CALL cl_err("OPEN i098_cl:", STATUS, 1)
      CLOSE i098_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i098_cl INTO g_hrea00
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrea00,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i098_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_delh(0,0) THEN                    #確認一下
      DELETE FROM hrea_file
       WHERE hrea00 = g_hrea00
      IF SQLCA.sqlcode THEN 
         CLOSE i098_cl
         ROLLBACK WORK
         RETURN
      END IF 

      CLEAR FORM
      LET g_hrea00=''
      CALL g_hrea.clear()
   END IF
   CLOSE i098_cl
   COMMIT WORK
   CALL i098_next()
END FUNCTION
