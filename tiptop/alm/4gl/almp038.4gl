# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: almp038.4gl
# Descriptions...: 關帳作業
# Date & Author..: FUN-870015 2008/12/16 By shiwuying
# Modify.........: No.FUN-960134 09/07/23 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore 
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ltm       RECORD LIKE ltm_file.*,
       g_ltm_t     RECORD LIKE ltm_file.*,
       g_ltmstore_t   LIKE ltm_file.ltmstore,
       g_wc        STRING,
       g_sql       STRING
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
   INITIALIZE g_ltm.* TO NULL
 
   LET g_forupd_sql="SELECT * FROM ltm_file WHERE ltmstore = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p038_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p038_w WITH FORM "alm/42f/almp038"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL p038_menu()
 
   CLOSE WINDOW p038_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p038_curs()
 DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_ltm.* TO NULL
    CONSTRUCT BY NAME g_wc ON ltmstore,ltmlegal,ltm02
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
         CASE
            WHEN INFIELD(ltmstore)               #門店編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ltmstore"
               LET g_qryparam.where = " ltmstore IN ",g_auth," "#No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ltmstore
               NEXT FIELD ltmstore
            WHEN INFIELD(ltmlegal)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ltmlegal"
               LET g_qryparam.where = " ltmstore IN ",g_auth," "#No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ltmlegal
               NEXT FIELD ltmlegal
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    LET g_sql="SELECT ltmstore FROM ltm_file ",
        " WHERE ",g_wc CLIPPED, 
        "   AND ltmstore IN ",g_auth,  #No.FUN-A10060
        " ORDER BY ltmstore "
    PREPARE p038_prepare FROM g_sql
    DECLARE p038_cs    
        SCROLL CURSOR WITH HOLD FOR p038_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ltm_file ",
        " WHERE ",g_wc CLIPPED,
        "   AND ltmstore IN ",g_auth   #No.FUN-A10060
    PREPARE p038_precount FROM g_sql
    DECLARE p038_count CURSOR FOR p038_precount
END FUNCTION
 
FUNCTION p038_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 
   MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL p038_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL p038_q()
            END IF
        ON ACTION next
            CALL p038_fetch('N')
        ON ACTION previous
            CALL p038_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_ltm.ltmstore,g_plant) THEN
                  CALL p038_u()
            #  END IF
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_ltm.ltmstore,g_plant) THEN
                  CALL p038_r()
            #  END IF
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL p038_fetch('/')
        ON ACTION first
            CALL p038_fetch('F')
        ON ACTION last
            CALL p038_fetch('L')
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
              IF g_ltm.ltmstore IS NOT NULL THEN
                 LET g_doc.column1 = "ltmstore"
                 LET g_doc.value1 = g_ltm.ltmstore
                 CALL cl_doc()
              END IF
           END IF
 
     END MENU
     CLOSE p038_cs
END FUNCTION
 
FUNCTION p038_a()
#DEFINE l_tqa06 LIKE tqa_file.tqa06
 DEFINE l_cnt   LIKE type_file.num5
 
####判斷當前組織機構是否是門店，只能在門店錄資料######
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'         
#     AND tqaacti = 'Y'   
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#                   WHERE tqbacti = 'Y'
#                     AND tqb09 = '2'
#                     AND tqb01 = g_plant)
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
#     CALL cl_err('','alm-600',1)
#     RETURN 
#  END IF  
#          
#  SELECT COUNT(*) INTO l_cnt FROM rtz_file
#   WHERE rtz01 = g_plant
#     AND lma25 = 'Y'
#  IF l_cnt < 1 THEN
#     CALL cl_err('','alm-606',1)
#     RETURN 
#  END IF
######################################################
 
    SELECT ltmstore,ltm02,ltmlegal
      INTO g_ltm.ltmstore,g_ltm.ltm02,g_ltm.ltmlegal
      FROM ltm_file
     WHERE ltmstore = g_plant
    IF NOT cl_null(g_ltm.ltmstore) THEN       #一個門店只能關帳一次
       CALL cl_err(g_ltm.ltmstore,'alm-542',1)
       CALL p038_show()
       RETURN
    END IF 
 
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_ltm.* LIKE ltm_file.*
    LET g_ltmstore_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ltm.ltmstore = g_plant
        LET g_ltm.ltmlegal = g_legal
        CALL p038_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_ltm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ltm.ltmstore IS NULL THEN 
            CONTINUE WHILE
        END IF
        INSERT INTO ltm_file VALUES(g_ltm.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ltm_file",g_ltm.ltmstore,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
           SELECT * INTO g_ltm.*
             FROM ltm_file
            WHERE ltmstore = g_ltm.ltmstore
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION p038_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5,
            l_cnt     LIKE type_file.num5
 
   DISPLAY BY NAME g_ltm.ltmstore, g_ltm.ltm02,g_ltm.ltmlegal
   CALL p038_ltmstore(p_cmd)
 
   INPUT BY NAME g_ltm.ltm02
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_ltm.ltmstore IS NULL THEN
               DISPLAY BY NAME g_ltm.ltmstore
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD ltmstore
            END IF
 
      ON ACTION CONTROLO  
         IF INFIELD(ltmstore) THEN
            LET g_ltm.* = g_ltm_t.*
            CALL p038_show()
            NEXT FIELD ltmstore
         END IF
 
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
 
      ON ACTION help 
         CALL cl_show_help() 
    END INPUT
END FUNCTION
 
FUNCTION p038_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ltm.* TO NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL p038_curs() 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN p038_count
    FETCH p038_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN p038_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ltm.ltmstore,SQLCA.sqlcode,0)
        INITIALIZE g_ltm.* TO NULL
    ELSE
        CALL p038_fetch('F')
    END IF
END FUNCTION
 
FUNCTION p038_fetch(p_flltm)
    DEFINE
        p_flltm         LIKE type_file.chr1
 
    CASE p_flltm
       WHEN 'N' FETCH NEXT     p038_cs INTO g_ltm.ltmstore
       WHEN 'P' FETCH PREVIOUS p038_cs INTO g_ltm.ltmstore
       WHEN 'F' FETCH FIRST    p038_cs INTO g_ltm.ltmstore
       WHEN 'L' FETCH LAST     p038_cs INTO g_ltm.ltmstore
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
           FETCH ABSOLUTE g_jump p038_cs INTO g_ltm.ltmstore
           LET g_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ltm.ltmstore,SQLCA.sqlcode,0)
        INITIALIZE g_ltm.* TO NULL
        RETURN
    ELSE
      CASE p_flltm
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_ltm.* FROM ltm_file 
     WHERE ltmstore = g_ltm.ltmstore
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ltm_file",g_ltm.ltmstore,"",SQLCA.sqlcode,"","",0) 
    ELSE
        CALL p038_show()
    END IF
END FUNCTION
 
FUNCTION p038_show()
    LET g_ltm_t.* = g_ltm.*
    DISPLAY BY NAME g_ltm.ltmstore,g_ltm.ltm02,g_ltm.ltmlegal
    CALL p038_ltmstore('d')
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION p038_ltmstore(p_cmd)
 DEFINE p_cmd    LIKE type_file.chr1
 DEFINE l_rtz13  LIKE rtz_file.rtz13 #FUN-A80148 add
 DEFINE l_azt02  LIKE azt_file.azt02
 
   IF p_cmd <> 'u' THEN
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = g_ltm.ltmstore
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_ltm.ltmlegal
      DISPLAY l_rtz13,l_azt02 TO rtz13,azt02
   END IF
 
END FUNCTION
 
FUNCTION p038_u()
    IF g_ltm.ltmstore IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ltm.* 
      FROM ltm_file 
     WHERE ltmstore=g_ltm.ltmstore
     
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ltmstore_t = g_ltm.ltmstore
    BEGIN WORK
 
    OPEN p038_cl USING g_ltm.ltmstore
    IF STATUS THEN
       CALL cl_err("OPEN p038_cl:", STATUS, 1)
       CLOSE p038_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p038_cl INTO g_ltm.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ltm.ltmstore,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL p038_show()
    WHILE TRUE
        CALL p038_i("u") 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ltm.*=g_ltm_t.*
            CALL p038_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ltm_file SET ltm_file.* = g_ltm.* 
         WHERE ltmstore = g_ltmstore_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ltm_file",g_ltm.ltmstore,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p038_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION p038_r()
    IF g_ltm.ltmstore IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    BEGIN WORK
 
    OPEN p038_cl USING g_ltm.ltmstore
    IF STATUS THEN
       CALL cl_err("OPEN p038_cl:", STATUS, 0)
       CLOSE p038_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p038_cl INTO g_ltm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ltm.ltmstore,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL p038_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ltmstore"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ltm.ltmstore      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM ltm_file 
        WHERE ltmstore = g_ltm.ltmstore
        
       CLEAR FORM
       OPEN p038_count
       FETCH p038_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN p038_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL p038_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL p038_fetch('/')
       END IF
    END IF
    CLOSE p038_cl
    COMMIT WORK
END FUNCTION
#No.FUN-960134
#FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore
