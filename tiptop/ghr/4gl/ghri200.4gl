# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri200
# Descriptions...: 薪酬预算变动管理
# Date & Author..: 13/08/08 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrec          RECORD LIKE hrec_file.*
DEFINE g_hrec_t        RECORD LIKE hrec_file.*
DEFINE g_sql           STRING
DEFINE g_forupd_sql    STRING                       #SELECT ... FOR UPDATE SQL          #No.FUN-680102
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count     LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump          LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5
DEFINE l_name          STRING
DEFINE g_wc            STRING 

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

   LET g_forupd_sql = "SELECT hrec01 FROM hrec_file WHERE hrec01=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200_cl CURSOR FROM g_forupd_sql        # LOCK CURSOR

   OPEN WINDOW i200_w WITH FORM "ghr/42f/ghri200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL cl_set_combo_items("hrec02",NULL,NULL)
   CALL i200_get_items() RETURNING l_name
   CALL cl_set_combo_items("hrec02",l_name,l_name)
   
   CALL i200_menu()
   
   CLOSE WINDOW i200_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i200_get_items()
DEFINE p_name   STRING
DEFINE p_hrac01 LIKE hrac_file.hrac01
DEFINE l_sql    STRING

       LET p_name=''
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  WHERE hrac01 NOT IN( SELECT hrct04 FROM hrct_file WHERE hrct06='Y')",
                 "  ORDER BY hrac01 "
       PREPARE i200_get_items_pre FROM l_sql
       DECLARE i200_get_items CURSOR FOR i200_get_items_pre
       FOREACH i200_get_items INTO p_hrac01
          IF cl_null(p_name) THEN
            LET p_name=p_hrac01
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrac01 CLIPPED
          END IF
       END FOREACH
       
       RETURN p_name
END FUNCTION

FUNCTION i200_cs()

    CLEAR FORM
    INITIALIZE g_hrec.* TO NULL   
    CONSTRUCT BY NAME g_wc ON hrec02,hrec05,hrec08,hrec09,hrecconf

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

    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrecuser', 'hrecgrup')
    LET g_sql="SELECT hrec01 FROM hrec_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY hrec01"
    PREPARE i200_prepare FROM g_sql
    DECLARE i200_cs SCROLL CURSOR WITH HOLD FOR i200_prepare

       
    LET g_sql="SELECT COUNT(*) FROM hrec_file WHERE ",g_wc CLIPPED
    PREPARE i200_precount FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precount
END FUNCTION

FUNCTION i200_menu()
   MENU ""
      BEFORE MENU
        CALL cl_navigator_setting(g_curs_index, g_row_count)

      ON ACTION INSERT
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i200_a()
         END IF

      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
             CALL i200_q()
         END IF 

      ON ACTION MODIFY
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i200_u()
         END IF

      ON ACTION DELETE 
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i200_r()
         END IF

      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i200_x()
         END IF

      ON ACTION confirm
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL i200_confirm()
         END IF 

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         IF cl_chk_act_auth() THEN 
            CALL i200_undo_confirm()
         END IF 
         
      ON ACTION NEXT
         CALL i200_fetch('N')

      ON ACTION PREVIOUS
         CALL i200_fetch('P')

      ON ACTION jump
         CALL i200_fetch('/')

      ON ACTION FIRST
         CALL i200_fetch('F')

      ON ACTION LAST
         CALL i200_fetch('L')
         
      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION EXIT
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

      ON ACTION CLOSE
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU

   END MENU 
   CLOSE i200_cs
END FUNCTION

FUNCTION i200_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrec.* TO NULL
    LET g_wc=NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i200_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    
    OPEN i200_count
    FETCH i200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    
    OPEN i200_cs  
    CALL i200_fetch('F')    
END FUNCTION

FUNCTION i200_next()

    OPEN i200_count
    FETCH i200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    
    OPEN i200_cs    
    CALL i200_fetch('F') 
END FUNCTION

FUNCTION i200_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr100

    CASE p_flag
        WHEN 'N' FETCH NEXT     i200_cs INTO g_hrec.hrec01
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_hrec.hrec01
        WHEN 'F' FETCH FIRST    i200_cs INTO g_hrec.hrec01
        WHEN 'L' FETCH LAST     i200_cs INTO g_hrec.hrec01
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
            FETCH ABSOLUTE g_jump i200_cs INTO g_hrec.hrec01
            LET mi_no_ask = FALSE 
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrec.hrec01,SQLCA.sqlcode,0)
        INITIALIZE g_hrec.* TO NULL 
        LET g_wc=NULL 
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
       DISPLAY g_curs_index TO FORMONLY.idx 
    END IF

    CALL i200_show() 
END FUNCTION

FUNCTION i200_show()
DEFINE l_hreba03     LIKE hreba_file.hreba03
DEFINE l_hreba03_new LIKE hreba_file.hreba03
DEFINE l_hrag07      LIKE hrag_file.hrag07
DEFINE l_sum1        LIKE hrec_file.hrec08
DEFINE l_sum2        LIKE hrec_file.hrec09

    SELECT * INTO g_hrec.* FROM hrec_file WHERE hrec01=g_hrec.hrec01
    DISPLAY BY NAME g_hrec.hrec02,g_hrec.hrec03,g_hrec.hrec04,g_hrec.hrec05,g_hrec.hrec06,
                    g_hrec.hrec07,g_hrec.hrec08,g_hrec.hrec09,g_hrec.hrecacti,g_hrec.hrecuser,
                    g_hrec.hrecgrup,g_hrec.hrecorig,g_hrec.hrecoriu,g_hrec.hrecmodu,
                    g_hrec.hrecdate,g_hrec.hrecconf

    SELECT hreba03 INTO l_hreba03 FROM hreba_file 
     WHERE hreba00=g_hrec.hrec02 AND hreba01=g_hrec.hrec06 AND hreba02=g_hrec.hrec07
    DISPLAY l_hreba03 TO hreba03

    SELECT SUM(hrec08),SUM(hrec09) INTO l_sum1,l_sum2 FROM hrec_file
     WHERE hrec02=g_hrec.hrec02 AND hrec06=g_hrec.hrec06 AND hrec07=g_hrec.hrec07 AND hrecacti='Y'
    IF cl_null(l_sum1) THEN LET l_sum1=0 END IF 
    IF cl_null(l_sum2) THEN LET l_sum2=0 END IF 
    LET l_hreba03_new=l_hreba03+l_sum1-l_sum2
    DISPLAY l_hreba03_new TO hreba03_new

    SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag06=g_hrec.hrec06 AND hrag01='654'
    DISPLAY l_hrag07 TO hrag07
    
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i200_a()
DEFINE l_sum1   LIKE hrec_file.hrec08
DEFINE l_sum2   LIKE hrec_file.hrec09

    MESSAGE ""
    CLEAR FORM                                     # 清螢墓欄位內容
    INITIALIZE g_hrec.* TO NULL 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i200_i("a")             # 各欄位輸入
        IF INT_FLAG THEN 
            LET INT_FLAG = 0
            INITIALIZE g_hrec.* TO NULL 
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        SELECT MAX(hrec01)+1 INTO g_hrec.hrec01 FROM hrec_file
        IF cl_null(g_hrec.hrec01) THEN LET g_hrec.hrec01=1 END IF 
        LET g_hrec.hrec01=g_hrec.hrec01 USING '&&&&&&&&&&'
        LET g_hrec.hrecuser = g_user
        LET g_hrec.hrecoriu = g_user #FUN-980030
        LET g_hrec.hrecorig = g_grup #FUN-980030
        LET g_hrec.hrecgrup = g_grup #使用者所屬群
        LET g_hrec.hrecmodu = g_user
        LET g_hrec.hrecacti = 'Y'
        LET g_hrec.hrecdate = g_today
        INSERT INTO hrec_file VALUES(g_hrec.*) 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrec_file",g_hrec.hrec01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF 
        SELECT SUM(hrec08),SUM(hrec09) INTO l_sum1,l_sum2 FROM hrec_file 
         WHERE hrec02=g_hrec.hrec02 AND hrecacti='Y'
        IF cl_null(l_sum1) THEN LET l_sum1=0 END IF 
        IF cl_null(l_sum2) THEN LET l_sum2=0 END IF 
        LET g_hrec.hrec04=g_hrec.hrec03+l_sum1-l_sum2
        UPDATE hrec_file SET hrec04=g_hrec.hrec04 WHERE hrec02=g_hrec.hrec02
        EXIT WHILE 
    END WHILE
    CLOSE i200_cl
    COMMIT WORK
    CALL i200_show()
END FUNCTION

FUNCTION i200_u()
DEFINE l_sum1   LIKE hrec_file.hrec08
DEFINE l_sum2   LIKE hrec_file.hrec09

    IF g_hrec.hrec01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_hrec.hrecconf='Y' THEN 
       CALL cl_err('',1208,1)
       RETURN 
    END IF 
    
    CALL cl_opmsg('u')
    LET g_hrec_t.* = g_hrec.*
    BEGIN WORK

    OPEN i200_cl USING g_hrec.hrec01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_hrec.hrec01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrec.hrec01,SQLCA.sqlcode,1)
       RETURN
    END IF
    
    WHILE TRUE
        CALL i200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrec.*=g_hrec_t.*
            CALL i200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrec_file SET hrec02 = g_hrec.hrec02,
                             hrec05 = g_hrec.hrec05,
                             hrec06 = g_hrec.hrec06,
                             hrec07 = g_hrec.hrec07,
                             hrec08 = g_hrec.hrec08,
                             hrec09 = g_hrec.hrec09,
                             hrecmodu=g_user,
                             hrecdate=g_today
         WHERE hrec01 = g_hrec.hrec01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrec_file",g_hrec.hrec01,"",SQLCA.sqlcode,"","",0)
	    CONTINUE WHILE
        END IF
	
        SELECT SUM(hrec08),SUM(hrec09) INTO l_sum1,l_sum2 FROM hrec_file 
         WHERE hrec02=g_hrec.hrec02 AND hrecacti='Y'
        IF cl_null(l_sum1) THEN LET l_sum1=0 END IF 
        IF cl_null(l_sum2) THEN LET l_sum2=0 END IF 
        LET g_hrec.hrec04=g_hrec.hrec03+l_sum1-l_sum2
        UPDATE hrec_file SET hrec04=g_hrec.hrec04 WHERE hrec02=g_hrec.hrec02
        EXIT WHILE
    END WHILE
    CLOSE i200_cl
    COMMIT WORK
    CALL i200_show()
END FUNCTION

FUNCTION i200_i(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_hrag07  LIKE hrag_file.hrag07
DEFINE l_hreba03 LIKE hreba_file.hreba03
DEFINE l_cnt     LIKE type_file.num5

   INPUT BY NAME g_hrec.hrec02,g_hrec.hrec05,g_hrec.hrec06,g_hrec.hrec07,g_hrec.hrec08,g_hrec.hrec09 WITHOUT DEFAULTS

      BEFORE INPUT 
         IF p_cmd='a' THEN 
            LET g_hrec.hrec05=g_today
            LET g_hrec.hrec08=0
            LET g_hrec.hrec09=0
            LET g_hrec.hrecconf='N'
            DISPLAY BY NAME g_hrec.hrec05,g_hrec.hrec08,g_hrec.hrec09,g_hrec.hrecconf
         END IF 

      ON ACTION controlp
         CASE WHEN INFIELD(hrec06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.arg1 = '654'
              LET g_qryparam.where = "hrag06 IN (SELECT hreb01 FROM hreb_file WHERE hreb00='",g_hrec.hrec02,"')"
              CALL cl_create_qry() RETURNING g_hrec.hrec06
              DISPLAY BY NAME g_hrec.hrec06
              NEXT FIELD hrec06
         END CASE 

      AFTER FIELD hrec02
         IF cl_null(g_hrec.hrec02) THEN NEXT FIELD hrec02 END IF 
         SELECT DISTINCT hreb03 INTO g_hrec.hrec03 FROM hreb_file WHERE hreb00=g_hrec.hrec02
         DISPLAY BY NAME g_hrec.hrec03
         
      AFTER FIELD hrec06 
         SELECT count(*) INTO l_cnt FROM hreb_file WHERE hreb00=g_hrec.hrec02 AND hreb01=g_hrec.hrec06
         IF l_cnt=0 THEN 
            CALL cl_err('','ghr-177',0)
            NEXT FIELD hrec06
         END IF 
         SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag06=g_hrec.hrec06 AND hrag01='654'
         DISPLAY l_hrag07 TO hrag07
         

      AFTER FIELD hrec07
         IF cl_null(g_hrec.hrec06) THEN NEXT FIELD hrec06 END IF 
         IF cl_null(g_hrec.hrec07) THEN NEXT FIELD hrec07 END IF 
         SELECT hreba03 INTO l_hreba03 FROM hreba_file 
          WHERE hreba00=g_hrec.hrec02 AND hreba01=g_hrec.hrec06 AND hreba02=g_hrec.hrec07
         DISPLAY l_hreba03 TO hreba03

      AFTER FIELD hrec08
         IF g_hrec.hrec08<0 THEN NEXT FIELD hrec08 END IF 

      AFTER FIELD hrec09 
         IF g_hrec.hrec09<0 THEN NEXT FIELD hrec09 END IF 
         
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

FUNCTION i200_x()
DEFINE l_sum1   LIKE hrec_file.hrec08
DEFINE l_sum2   LIKE hrec_file.hrec09

   IF g_hrec.hrec01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_hrec.hrecconf='Y' THEN 
      CALL cl_err('','abm-887',1)
      RETURN 
   END IF 

   BEGIN WORK 
   OPEN i200_cl USING g_hrec.hrec01
   IF STATUS THEN
      CALL cl_err("OPEN g_hrec.hrec01:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i200_cl INTO g_hrec.hrec01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrec.hrec01,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrec_file SET hrecacti='N',
                        hrecmodu=g_user,
                        hrecdate=g_today
    WHERE hrec01=g_hrec.hrec01
   IF SQLCA.sqlcode THEN 
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF 
   
   SELECT SUM(hrec08),SUM(hrec09) INTO l_sum1,l_sum2 FROM hrec_file
    WHERE hrec02=g_hrec.hrec02 AND hrecacti='Y'
   IF cl_null(l_sum1) THEN LET l_sum1=0 END IF 
   IF cl_null(l_sum2) THEN LET l_sum2=0 END IF 
   LET g_hrec.hrec04=g_hrec.hrec03+l_sum1-l_sum2
   UPDATE hrec_file SET hrec04=g_hrec.hrec04 WHERE hrec02=g_hrec.hrec02
   IF SQLCA.sqlcode THEN 
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF 
   
   CLOSE i200_cl
   COMMIT WORK 
   CALL i200_show()
   
END FUNCTION 


FUNCTION i200_r()
DEFINE l_sum1 LIKE hrec_file.hrec08
DEFINE l_sum2 LIKE hrec_file.hrec09

   IF s_shut(0) THEN RETURN END IF

   IF g_hrec.hrec01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_hrec.hrecconf='Y' THEN 
      CALL cl_err('',1208,1)
      RETURN 
   END IF 
   
   BEGIN WORK
   OPEN i200_cl USING g_hrec.hrec01
   IF STATUS THEN
      CALL cl_err("OPEN g_hrec.hrec01:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i200_cl INTO g_hrec.hrec01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrec.hrec01,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_delete() THEN                    #確認一下
      DELETE FROM hrec_file
       WHERE hrec01 = g_hrec.hrec01
      IF SQLCA.sqlcode THEN 
         CLOSE i200_cl
         ROLLBACK WORK
         RETURN
      END IF 
      
      SELECT SUM(hrec08),SUM(hrec09) INTO l_sum1,l_sum2 FROM hrec_file
       WHERE hrec02=g_hrec.hrec02 AND hrecacti='Y'
      IF cl_null(l_sum1) THEN LET l_sum1=0 END IF 
      IF cl_null(l_sum2) THEN LET l_sum2=0 END IF 
      LET g_hrec.hrec04=g_hrec.hrec03+l_sum1-l_sum2
      UPDATE hrec_file SET hrec04=g_hrec.hrec04 WHERE hrec02=g_hrec.hrec02
      IF SQLCA.sqlcode THEN 
         CLOSE i200_cl
         ROLLBACK WORK
         RETURN
      END IF 
      
      CLEAR FORM
      INITIALIZE g_hrec.* TO NULL
   END IF
   CLOSE i200_cl
   COMMIT WORK
   
   CALL i200_next()
END FUNCTION

FUNCTION i200_confirm()
DEFINE l_hreba04  LIKE hreba_file.hreba04
DEFINE l_hreba05  LIKE hreba_file.hreba05

   IF g_hrec.hrec01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_hrec.hrecconf='Y' THEN 
      CALL cl_err('',1208,1)
      RETURN 
   END IF 

   IF g_hrec.hrecacti='N' THEN 
      CALL cl_err('','abm-889',1)
      RETURN 
   END IF 
   
   BEGIN WORK
   OPEN i200_cl USING g_hrec.hrec01
   IF STATUS THEN
      CALL cl_err("OPEN g_hrec.hrec01:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i200_cl INTO g_hrec.hrec01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrec.hrec01,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrec_file SET hrecconf='Y',
                        hrecmodu=g_user,
                        hrecdate=g_today
    WHERE hrec01=g_hrec.hrec01
    IF SQLCA.sqlcode THEN 
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF 
   
   SELECT hreba04,hreba05 INTO l_hreba04,l_hreba05 FROM hreba_file
    WHERE hreba00=g_hrec.hrec02 AND hreba01=g_hrec.hrec06 AND hreba02=g_hrec.hrec07
   LET l_hreba04=l_hreba04+g_hrec.hrec08
   LET l_hreba05=l_hreba05+g_hrec.hrec09
   UPDATE hreba_file SET hreba04=l_hreba04,
                         hreba05=l_hreba05
    WHERE hreba00=g_hrec.hrec02
      AND hreba01=g_hrec.hrec06
      AND hreba02=g_hrec.hrec07
   IF SQLCA.sqlcode THEN 
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF 

   CLOSE i200_cl
   COMMIT WORK
   CALL i200_show()
END FUNCTION 

FUNCTION i200_undo_confirm()
DEFINE l_hreba04  LIKE hreba_file.hreba04
DEFINE l_hreba05  LIKE hreba_file.hreba05

   IF g_hrec.hrec01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_hrec.hrecconf='N' THEN 
      RETURN 
   END IF 

   BEGIN WORK
   OPEN i200_cl USING g_hrec.hrec01
   IF STATUS THEN
      CALL cl_err("OPEN g_hrec.hrec01:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i200_cl INTO g_hrec.hrec01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrec.hrec01,SQLCA.sqlcode,0) # 資料被他人LOCK
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE hrec_file SET hrecconf='N',
                        hrecmodu=g_user,
                        hrecdate=g_today
    WHERE hrec01=g_hrec.hrec01
    IF SQLCA.sqlcode THEN 
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF 
   
   SELECT hreba04,hreba05 INTO l_hreba04,l_hreba05 FROM hreba_file
    WHERE hreba00=g_hrec.hrec02 AND hreba01=g_hrec.hrec06 AND hreba02=g_hrec.hrec07
   LET l_hreba04=l_hreba04-g_hrec.hrec08
   LET l_hreba05=l_hreba05-g_hrec.hrec09
   UPDATE hreba_file SET hreba04=l_hreba04,
                         hreba05=l_hreba05
    WHERE hreba00=g_hrec.hrec02
      AND hreba01=g_hrec.hrec06
      AND hreba02=g_hrec.hrec07
   IF SQLCA.sqlcode THEN 
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF 

   CLOSE i200_cl
   COMMIT WORK
   CALL i200_show()
END FUNCTION 
