# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apci101.4gl
# Descriptions...: POS授權碼維護作業 
# Date & Author..: NO.FUN-A30108 10/03/29 By Cockroach 
# Modify.........: No.FUN-A30108 10/03/29 By Cockroach  PASS NO.
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70075 11/10/25 By nanbing 更新已傳POS否的狀態 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryw       RECORD LIKE ryw_file.*,
       g_ryw_t     RECORD LIKE ryw_file.*,
       g_ryw01_t   LIKE ryw_file.ryw01,
       g_wc        STRING,
       g_sql       STRING
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_chr                 LIKE ryw_file.rywacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE mi_no_ask             LIKE type_file.num5
DEFINE g_t1                  LIKE oay_file.oayslip
#EFINE g_sort                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品類中的商品
#EFINE g_sign                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品牌中的商品
#EFINE g_factory             DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放廠商中的商品
#EFINE g_no                  DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品編號中的商品
#EFINE g_result              DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品交集
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT 
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_ryw.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM ryw_file WHERE ryw01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i101_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i101_w AT p_row,p_col WITH FORM "apc/42f/apci101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_set_comp_visible("rywpos",g_aza.aza88='Y')   
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i101_menu()
 
   CLOSE WINDOW i101_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i101_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_ryw.* TO NULL
    CONSTRUCT BY NAME g_wc ON
        ryw01,ryw02,rywpos,
        rywuser,rywgrup,rywmodu,rywdate,rywacti,rywcrat,
        ryworiu,ryworig                    

    BEFORE CONSTRUCT
       CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ryw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryw01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ryw.ryw01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryw01
                 NEXT FIELD ryw01
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
 
    END CONSTRUCT
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rywuser', 'rywgrup')
 
    LET g_sql="SELECT ryw01 FROM ryw_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY ryw01"
    PREPARE i101_prepare FROM g_sql
    DECLARE i101_cs
        SCROLL CURSOR WITH HOLD FOR i101_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ryw_file WHERE ",g_wc CLIPPED
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
END FUNCTION

FUNCTION i101_menu()
   DEFINE l_cmd  LIKE type_file.chr1000  
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i101_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i101_q()
            END IF
        ON ACTION next
            CALL i101_fetch('N')
        ON ACTION previous
            CALL i101_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                  CALL i101_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                  CALL i101_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                  CALL i101_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                  CALL i101_copy()
            END IF
 #     ON ACTION output
 #          LET g_action_choice="output"
 #          IF cl_chk_act_auth() THEN                             
 #             IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
 #          END IF
          
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i101_fetch('/')
        ON ACTION first
            CALL i101_fetch('F')
        ON ACTION last
            CALL i101_fetch('L')
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
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_ryw.ryw01 IS NOT NULL THEN
                 LET g_doc.column1 = "ryw01"
                 LET g_doc.value1 = g_ryw.ryw01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i101_cs
END FUNCTION

 
FUNCTION i101_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ryw.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i101_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ryw.ryw01,SQLCA.sqlcode,0)
        INITIALIZE g_ryw.* TO NULL
    ELSE
        CALL i101_fetch('F')
    END IF
END FUNCTION
 
FUNCTION i101_fetch(p_flryw)
    DEFINE
        p_flryw         LIKE type_file.chr1             
 
    CASE p_flryw
        WHEN 'N' FETCH NEXT     i101_cs INTO g_ryw.ryw01
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_ryw.ryw01
        WHEN 'F' FETCH FIRST    i101_cs INTO g_ryw.ryw01               
        WHEN 'L' FETCH LAST     i101_cs INTO g_ryw.ryw01               
        WHEN '/'
            IF (NOT mi_no_ask) THEN                                 
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i101_cs INTO g_ryw.ryw01               
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ryw.ryw01,SQLCA.sqlcode,0)
        INITIALIZE g_ryw.* TO NULL
        RETURN
    ELSE
      CASE p_flryw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_ryw.* FROM ryw_file
       WHERE ryw01 = g_ryw.ryw01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ryw_file",g_ryw.ryw01,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_ryw.rywuser
        LET g_data_group=g_ryw.rywgrup
        CALL i101_show()
    END IF
END FUNCTION
 
FUNCTION i101_show()
DEFINE  l_azw08  LIKE azw_File.azw08
 
    LET g_ryw_t.* = g_ryw.*
    DISPLAY BY NAME g_ryw.ryw01,g_ryw.ryw02,g_ryw.ryworiu,g_ryw.ryworig,
                    g_ryw.rywpos,g_ryw.rywuser,g_ryw.rywgrup,
                    g_ryw.rywcrat,g_ryw.rywmodu,g_ryw.rywdate,g_ryw.rywacti
    SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ryw.ryw01
    DISPLAY l_azw08 TO FORMONLY.ryw01_desc

    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i101_a()
#EFINE l_azw08     LIKE azw_file.azw08
 
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_ryw.* LIKE ryw_file.*
    LET g_ryw01_t = NULL
    LET g_wc = NULL
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('a')
    WHILE TRUE 
        LET g_ryw_t.* = g_ryw.*
        LET g_ryw.rywuser = g_user
        LET g_ryw.ryworiu = g_user 
        LET g_ryw.ryworig = g_grup 
        LET g_data_plant  =g_plant 
        LET g_ryw.rywgrup = g_grup
        LET g_ryw.rywcrat = g_today
        LET g_ryw.rywacti = 'Y'
        LET g_ryw.rywpos = '1'   #'Y' #NO.FUN-B40071

        CALL i101_i("a")

        IF INT_FLAG THEN 
            INITIALIZE g_ryw.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ryw.ryw01 IS NULL THEN
            CONTINUE WHILE
        END IF

        BEGIN WORK
        DISPLAY BY NAME g_ryw.ryw01
        INSERT INTO ryw_file VALUES(g_ryw.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ryw_file",g_ryw.ryw01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
       	   COMMIT WORK 
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i101_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5,
            l_flag      LIKE type_file.num5
 
   DISPLAY BY NAME
      g_ryw.ryw01,g_ryw.ryw02,g_ryw.rywpos,
      g_ryw.rywuser,g_ryw.rywgrup,g_ryw.rywmodu,
      g_ryw.rywdate,g_ryw.rywacti,g_ryw.rywcrat,
      g_ryw.ryworiu,g_ryw.ryworig                           

  #SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ryw.rywplant                                                
   
   INPUT BY NAME 
      g_ryw.ryw01,g_ryw.ryw02,g_ryw.rywpos
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i101_set_entry(p_cmd)
          CALL i101_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD ryw01
         DISPLAY "AFTER FIELD ryw01"
         IF g_ryw.ryw01 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_ryw.ryw01 != g_ryw01_t) THEN
               SELECT COUNT(*) INTO l_n FROM ryw_file
                WHERE ryw01=g_ryw.ryw01
               IF l_n>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ryw.ryw01=g_ryw01_t
                  DISPLAY BY NAME g_ryw.ryw01
                  NEXT FIELD ryw01
               ELSE
                  CALL i101_ryw01(g_ryw.ryw01,'a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                    #LET g_ryw.ryw01=g_ryw_t.ryw01
                     LET g_ryw.ryw01=g_ryw01_t
                     DISPLAY BY NAME g_ryw.ryw01
                     NEXT FIELD ryw01
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD ryw02
         IF g_ryw.ryw02 IS NULL THEN
            LET g_ryw.ryw02=g_ryw_t.ryw02
            DISPLAY BY NAME g_ryw.ryw02
            NEXT FIELD ryw02
         END IF
 
     #AFTER FIELD rywpos
    
    
            
      AFTER INPUT
         LET g_ryw.rywuser = s_get_data_owner("ryw_file") #FUN-C10039
         LET g_ryw.rywgrup = s_get_data_group("ryw_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_ryw.ryw01 IS NULL THEN
               DISPLAY BY NAME g_ryw.ryw01
               LET l_input='Y'
            END IF
 
            IF l_input='Y' THEN
               NEXT FIELD ryw01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(ryw01) THEN
            LET g_ryw.* = g_ryw_t.*
            CALL i101_show()
            NEXT FIELD ryw01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(ryw01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_ryw.ryw01
              CALL cl_create_qry() RETURNING g_ryw.ryw01
              DISPLAY BY NAME g_ryw.ryw01
              NEXT FIELD ryw01
              
           OTHERWISE
              EXIT CASE
           END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
END FUNCTION

FUNCTION i101_ryw01(l_azp01,p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,
   l_azp01         LIKE azp_file.azp01,
   l_azp02         LIKE azp_file.azp02

   LET g_errno=' '
   SELECT azp02 INTO l_azp02 FROM azp_file
    WHERE azp01 = l_azp01
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'art-044'
                                 LET l_azp02 = NULL
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.ryw01_desc
   END IF
END FUNCTION
 
FUNCTION i101_u()
DEFINE l_rywpos   LIKE ryw_file.rywpos    #FUN-B70075
    IF g_ryw.ryw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ryw.* FROM ryw_file 
       WHERE ryw01=g_ryw.ryw01
    IF g_ryw.rywacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF

    MESSAGE ""

    CALL cl_opmsg('u')
    LET g_ryw01_t = g_ryw.ryw01
   #FUN-B70075  Begin--------------
    IF g_aza.aza88 = 'Y' THEN
       LET g_ryw_t.* = g_ryw.*
       LET l_rywpos = g_ryw.rywpos
       UPDATE ryw_file SET rywpos = '4'
        WHERE ryw01 = g_ryw_t.ryw01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ryw_file",g_ryw.rywpos,"",SQLCA.sqlcode,"","",1)
          RETURN
       END IF
       LET g_ryw.rywpos = '4'
       DISPLAY BY NAME g_ryw.rywpos
    END IF
   #FUN-B70075  End ---------------
    BEGIN WORK
 
    OPEN i101_cl USING g_ryw.ryw01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_ryw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryw.ryw01,SQLCA.sqlcode,1)
        RETURN
    END IF

    LET g_ryw_t.* = g_ryw.*
    CALL i101_show()
    WHILE TRUE
       LET g_ryw.rywmodu=g_user
       LET g_ryw.rywdate = g_today
      #FUN-B70075  Begin Mark-------
      # IF g_aza.aza88 = 'Y' THEN
      #   #FUN-B40071 --START--
      #    #LET g_ryw.rywpos='N'
      #    IF g_ryw.rywpos <> '1' THEN
      #       LET g_ryw.rywpos='2'
      #    END IF
      #   #FUN-B40071 --END--
      # END IF
      #FUN-B70075 End Mark ----------

       CALL i101_i("u")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ryw.*=g_ryw_t.*
          #FUN-B70075  Begin ---------
           LET g_ryw.rywpos = l_rywpos
           UPDATE ryw_file SET rywpos = g_ryw.rywpos
            WHERE ryw01 = g_ryw_t.ryw01
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","ryw_file",g_ryw.rywpos,"",SQLCA.sqlcode,"","",1)
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_ryw.rywpos
          #FUN-B70075 End ------------           
           CALL i101_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
      #FUN-B70075 Begin ---------
       IF g_aza.aza88 = 'Y' THEN
          IF l_rywpos <> '1' THEN
             LET g_ryw.rywpos='2'
          ELSE 
             LET g_ryw.rywpos='1'
          END IF
          DISPLAY BY NAME g_ryw.rywpos
       END IF           
      #FUN-B70075 End -----------        
       UPDATE ryw_file SET ryw_file.* = g_ryw.*
           WHERE ryw01 = g_ryw.ryw01
       IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ryw_file",g_ryw.ryw01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_x()
    IF g_ryw.ryw01 IS NULL  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    BEGIN WORK
 
    OPEN i101_cl USING g_ryw.ryw01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_ryw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryw.ryw01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i101_show()
    IF cl_exp(0,0,g_ryw.rywacti) THEN
        LET g_chr=g_ryw.rywacti
        IF g_ryw.rywacti='Y' THEN
            LET g_ryw.rywacti='N'
        ELSE
            LET g_ryw.rywacti='Y'
        END IF
        UPDATE ryw_file
            SET rywacti=g_ryw.rywacti,
                rywmodu=g_user,
                rywdate=g_today
            WHERE ryw01 = g_ryw.ryw01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_ryw.ryw01,SQLCA.sqlcode,0)
            LET g_ryw.rywacti=g_chr
        END IF
        DISPLAY BY NAME g_ryw.rywacti
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_r()
 
    IF g_ryw.ryw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    IF g_aza.aza88='Y' THEN  
      #FUN-B40071 --START-- 
       #IF NOT (g_ryw.rywacti='N' AND g_ryw.rywpos='Y') THEN
       #   CALL cl_err("", 'art-648', 1)
       #   RETURN
       #END IF
       IF NOT ((g_ryw.rywpos='3' AND g_ryw.rywacti='N') 
                  OR (g_ryw.rywpos='1'))  THEN                  
          CALL cl_err('','apc-139',0)            
          RETURN
       END IF    
      #FUN-B40071 --END--
    END IF
    
    SELECT * INTO g_ryw.* FROM ryw_file
       WHERE ryw01=g_ryw.ryw01 
 
    IF g_ryw.rywacti ='N' THEN 
       CALL cl_err('','mfg1000',0)
       RETURN     
    END IF

    BEGIN WORK
 
    OPEN i101_cl USING g_ryw.ryw01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 0)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_ryw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryw.ryw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i101_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL                                 
        LET g_doc.column1 = "ryw01"                                
        LET g_doc.value1 = g_ryw.ryw01                             
        CALL cl_del_doc()                                                                
       DELETE FROM ryw_file 
          WHERE ryw01 = g_ryw.ryw01 
       CLEAR FORM
       OPEN i101_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i101_cs
          CLOSE i101_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i101_count INTO  g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i101_cs
          CLOSE i101_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO  FORMONLY.cnt
       OPEN i101_cs           
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i101_fetch('L' )
       ELSE                   
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i101_fetch('/')
       END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_copy()
    DEFINE
        l_newno         LIKE ryw_file.ryw01,
        l_oldno         LIKE ryw_file.ryw01,
        p_cmd           LIKE type_file.chr1,
        l_input         LIKE type_file.chr1,  
        l_n             LIKE type_file.num5  
  
    IF g_ryw.ryw01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET l_input='N'
    LET l_oldno = g_ryw.ryw01
    DISPLAY ' ' TO FORMONLY.ryw01_desc
    LET g_before_input_done = FALSE
    CALL i101_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM ryw01
 
        AFTER FIELD ryw01
           IF l_newno IS NOT NULL THEN
              SELECT COUNT(*) INTO l_n FROM ryw_file
               WHERE ryw01=l_newno
              IF l_n>0 THEN 
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD ryw01
              END IF
              CALL i101_ryw01(l_newno,'a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ryw01
              END IF
           END IF
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(ryw01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = l_newno
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO ryw01
              NEXT FIELD ryw01
              
           OTHERWISE
              EXIT CASE
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
        DISPLAY BY NAME g_ryw.ryw01
        CALL i101_ryw01(g_ryw.ryw01,'d')
        RETURN
    END IF

    BEGIN WORK 
    DROP TABLE x
    SELECT * FROM ryw_file
        WHERE ryw01 = g_ryw.ryw01
        INTO TEMP x
    UPDATE x
        SET ryw01=l_newno,
            rywacti='Y',
            rywuser=g_user,
            rywgrup=g_grup,
            ryworiu=g_user,    
            ryworig=g_grup,    
            rywmodu=NULL,
            rywdate=NULL,
            rywcrat = g_today,
            rywpos = '1' #NO.FUN-B40071 
    INSERT INTO ryw_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ryw_file",g_ryw.ryw01,"",SQLCA.sqlcode,"","",0)
        ROLLBACK WORK
        RETURN 
    ELSE
        COMMIT WORK
        MESSAGE 'ROW(',l_newno,') O.K'
    END IF
    LET g_ryw.ryw01 = l_newno
    SELECT ryw_file.* INTO g_ryw.* FROM ryw_file
           WHERE ryw01 = l_newno 
    CALL i101_u()
    SELECT ryw_file.* INTO g_ryw.* FROM ryw_file
           WHERE ryw01 = l_oldno 
    LET g_ryw.ryw01 = l_oldno
    CALL i101_show()
END FUNCTION
 
 
FUNCTION i101_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("ryw01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("ryw01",FALSE)
    END IF
 
END FUNCTION
#FUN-A30108 ADD

