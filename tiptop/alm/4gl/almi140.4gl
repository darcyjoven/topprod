# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almi140.4gl
# Descriptions...: 樓層分攤率資料維護作業
# Date & Author..: FUN-870015 2008/07/02 By shiwuying
# Modify.........: No.FUN-960134 09/06/30 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/16 By shiwuying SQL后加SQLCA.SQLCODE判斷
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-A80117 10/11/05 By huangtao mark掉rtzacti相關變量
# Modify.........: NO:TQC-AC0123 10/11/16 By shenyang 打印問題修改 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lme       RECORD LIKE lme_file.*,
       g_lme_t     RECORD LIKE lme_file.*,
       g_lmestore_t   LIKE lme_file.lmestore,
       g_lme02_t   LIKE lme_file.lme02,
       g_lme03_t   LIKE lme_file.lme03,
       g_wc        STRING,
       g_sql       STRING
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_chr                 LIKE lme_file.lmeacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   INITIALIZE g_lme.* TO NULL
 
   LET g_forupd_sql="SELECT * FROM lme_file WHERE lmestore = ? ",
                    "   AND lme02 = ? AND lme03 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i140_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i140_w WITH FORM "alm/42f/almi140"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL i140_menu()
 
   CLOSE WINDOW i140_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i140_curs()
    DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_lme.* TO NULL
    CONSTRUCT BY NAME g_wc ON lmestore,lmelegal,lme02,lme03,lme04,lme05,lme06,
                              lme07,
                              lmeuser,lmegrup,lmeoriu,lmeorig,lmemodu,lmedate,
                              lmeacti,lmecrat
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lmestore)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmestore"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lmestore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmestore
                 NEXT FIELD lmestore
              WHEN INFIELD(lmelegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmelegal"
                 LET g_qryparam.state = "c" 
                 LET g_qryparam.where = " lmestore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmelegal
                 NEXT FIELD lmelegal
              WHEN INFIELD(lme02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lme02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lmestore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lme02
                 NEXT FIELD lme02
              WHEN INFIELD(lme03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lme03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lmestore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lme03
                 NEXT FIELD lme03   
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN 
    #            LET g_wc = g_wc clipped," AND lmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN  
    #        LET g_wc = g_wc clipped," AND lmegrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmeuser', 'lmegrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lmestore,lme02,lme03 FROM lme_file ",
        " WHERE ",g_wc CLIPPED, 
        "   AND lmestore IN ",g_auth,   #No.FUN-A10060
        " ORDER BY lmestore,lme02,lme03"
    PREPARE i140_prepare FROM g_sql
    DECLARE i140_cs    
        SCROLL CURSOR WITH HOLD FOR i140_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lme_file ",
        " WHERE ",g_wc CLIPPED,
        "   AND lmestore IN ",g_auth   #No.FUN-A10060
    PREPARE i140_precount FROM g_sql
    DECLARE i140_count CURSOR FOR i140_precount
END FUNCTION
 
FUNCTION i140_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 
   MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i140_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i140_q()
            END IF
        ON ACTION next
            CALL i140_fetch('N')
        ON ACTION previous
            CALL i140_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lme.lmestore,g_plant) THEN
                  CALL i140_u()
            #  END IF
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lme.lmestore,g_plant) THEN
                  CALL i140_x()
            #  END IF
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lme.lmestore,g_plant) THEN
                  CALL i140_r()
            #  END IF
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lme.lmestore,g_plant) THEN
                  CALL i140_copy()
            #  END IF
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               #THEN CALL i140_out() 
               THEN 
               IF cl_null(g_wc) THEN LET g_wc=' 1=1' END IF 
               LET g_wc = g_wc,"AND lmestore IN ",g_auth  #TQC-AC0123
               LET l_cmd = 'p_query "almi140" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
 
        ON ACTION confirm 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
           #  IF cl_chk_mach_auth(g_lme.lmestore,g_plant) THEN
                 CALL i140_y()
           #  END IF
           END IF 
        ON ACTION undo_confirm      
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lme.lmestore,g_plant) THEN
                  CALL i140_z()
            #  END IF
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i140_fetch('/')
        ON ACTION first
            CALL i140_fetch('F')
        ON ACTION last
            CALL i140_fetch('L')
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
              IF g_lme.lmestore IS NOT NULL THEN
                 LET g_doc.column1 = "lmestore"
                 LET g_doc.value1 = g_lme.lmestore
                 CALL cl_doc()
              END IF
           END IF
 
     END MENU
     CLOSE i140_cs
END FUNCTION
 
 
FUNCTION i140_a()
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
#     AND rtz28 = 'Y'
#  IF l_cnt < 1 THEN
#     CALL cl_err('','alm-606',1)
#     RETURN 
#  END IF
######################################################
 
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_lme.* LIKE lme_file.*
    LET g_lmestore_t = NULL
    LET g_lme02_t = NULL
    LET g_lme03_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lme.lmestore = g_plant
        LET g_lme.lmelegal = g_legal
        LET g_lme.lme05 = 'N'
        LET g_lme.lmeuser = g_user
        LET g_lme.lmeoriu = g_user #FUN-980030
        LET g_lme.lmeorig = g_grup #FUN-980030
        LET g_lme.lmegrup = g_grup 
        LET g_lme.lmeacti = 'Y'
        LET g_lme.lmecrat = g_today
        CALL i140_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lme.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lme.lmestore IS NULL THEN 
            CONTINUE WHILE
        END IF
        INSERT INTO lme_file VALUES(g_lme.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lme_file",g_lme.lmestore,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
           SELECT * INTO g_lme.* FROM lme_file
            WHERE lmestore = g_lme.lmestore
              AND lme02 = g_lme.lme02
              AND lme03 = g_lme.lme03
           LET g_lmestore_t = g_lme.lmestore
           LET g_lme02_t = g_lme.lme02
           LET g_lme03_t = g_lme.lme03
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i140_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_rtz13   LIKE rtz_file.rtz13,  #FUN-A80148 add
            l_lmb03   LIKE lmb_file.lmb03,
            l_lmc04   LIKE lmc_file.lmc04,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5,
            l_cnt     LIKE type_file.num5
 
   DISPLAY BY NAME
      g_lme.lmestore,g_lme.lme02,g_lme.lme03,g_lme.lme04,g_lme.lme05,g_lme.lme06,
      g_lme.lme07,g_lme.lmeuser,g_lme.lmemodu,g_lme.lmeacti,g_lme.lmegrup,
      g_lme.lmedate,g_lme.lmecrat,g_lme.lmelegal
   CALL i140_lmestore('d') #No.FUN-9B0136  add
 
   INPUT BY NAME g_lme.lmeoriu,g_lme.lmeorig,
      g_lme.lmestore,g_lme.lme02,g_lme.lme03,g_lme.lme04
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i140_set_entry(p_cmd)
          CALL i140_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD lmestore
         IF g_lme.lmestore IS NOT NULL THEN
            CALL i140_lmestore(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lme.lmestore,g_errno,1)
               LET g_lme.lmestore = g_lmestore_t
               LET INT_FLAG = 1
               EXIT INPUT
            END IF
         END IF
 
      AFTER FIELD lme02
         IF g_lme.lme02 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lme.lme02 != g_lme02_t)THEN
               CALL i140_lme02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lme.lme02,g_errno,1)
                  LET g_lme.lme02 = g_lme02_t
                  NEXT FIELD lme02
               END IF
               IF NOT cl_null(g_lme.lme03) THEN
                  SELECT COUNT(*) INTO l_cnt FROM lme_file
                   WHERE lmestore = g_lme.lmestore
                     AND lme02 = g_lme.lme02
                     AND lme03 = g_lme.lme03
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_lme.lme02,'-239',0)
                     NEXT FIELD lme02
                  END IF
               END IF
               SELECT count(*) INTO l_cnt
                 FROM lmc_file
                WHERE lmcstore = g_lme.lmestore
                  AND lmc02 = g_lme.lme02
                  AND lmc07 = 'Y'
                  AND lmc03 NOT IN (
               SELECT lme03 FROM lme_file
                WHERE lmestore = g_lme.lmestore
                  AND lme02 = g_lme.lme02)
               IF l_cnt = 0 THEN
                  CALL cl_err(g_lme.lme02,'alm-540',0)
                  NEXT FIELD lme02
               END IF
            END IF
         ELSE
            DISPLAY '' TO lmb03
         END IF
 
      BEFORE FIELD lme03
         IF cl_null(g_lme.lme02) THEN
            CALL cl_err('','alm-390',0)
            NEXT FIELD lme02
         END IF
 
      AFTER FIELD lme03
         IF g_lme.lme03 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lme.lme03 != g_lme03_t)THEN
               CALL i140_lme03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lme.lme03,g_errno,1)
                  LET g_lme.lme03 = g_lme03_t
                  NEXT FIELD lme03
               END IF
               IF NOT cl_null(g_lme.lme02) THEN
                  SELECT COUNT(*) INTO l_cnt FROM lme_file
                   WHERE lmestore = g_lme.lmestore
                     AND lme02 = g_lme.lme02
                     AND lme03 = g_lme.lme03
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_lme.lme02,'-239',0)
                     NEXT FIELD lme03
                  END IF
               END IF
            END IF
         ELSE 
            DISPLAY '' TO lmc04
         END IF
 
      AFTER FIELD lme04
         IF g_lme.lme04 IS NOT NULL THEN
            IF g_lme.lme04 < 0 OR g_lme.lme04 >100 THEN
               CALL cl_err('lme04:','alm-010',0)
               NEXT FIELD lme04
            END IF
         END IF
      
      AFTER INPUT
         LET g_lme.lmeuser = s_get_data_owner("lme_file") #FUN-C10039
         LET g_lme.lmegrup = s_get_data_group("lme_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lme.lmestore IS NULL THEN
               DISPLAY BY NAME g_lme.lmestore
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lmestore
            END IF
 
      ON ACTION CONTROLO  
         IF INFIELD(lmestore) THEN
            LET g_lme.* = g_lme_t.*
            CALL i140_show()
            NEXT FIELD lmestore
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lme02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc1"
               LET g_qryparam.default1 = g_lme.lme02
               LET g_qryparam.default2 = g_lme.lme03
               LET g_qryparam.default3 = l_lmc04
               CALL cl_create_qry() 
                  RETURNING g_lme.lme02,g_lme.lme03,l_lmc04
               DISPLAY BY NAME g_lme.lme02,g_lme.lme03
               DISPLAY l_lmc04 TO lmc04
               NEXT FIELD lme02
            WHEN INFIELD(lme03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc1"
               LET g_qryparam.default1 = g_lme.lme02
               LET g_qryparam.default2 = g_lme.lme03
               LET g_qryparam.default3 = l_lmc04
               CALL cl_create_qry() 
                  RETURNING g_lme.lme02,g_lme.lme03,l_lmc04
               DISPLAY BY NAME g_lme.lme02,g_lme.lme03
               DISPLAY l_lmc04 TO lmc04
               NEXT FIELD lme03
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
 
FUNCTION i140_lmestore(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_rtz01    LIKE rtz_file.rtz01,   #FUN-A80148 add
   l_rtz13    LIKE rtz_file.rtz13,   #FUN-A80148 add
   l_rtz28    LIKE rtz_file.rtz28,   #FUN-A80148 add
#  l_rtzacti  LIKE rtz_file.rtzacti  #FUN-A80148 add      #FUN-A80117  mark
   l_azwacti  LIKE azw_file.azwacti  #FUN-A80148 add by vealxu  
DEFINE l_azt02 LIKE azt_file.azt02
 
   LET g_errno=''
   SELECT rtz01,rtz13,rtz28,azwacti                         #FUN-A80148 rtzacti->azwacti by vealxu
     INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti                 #FUN-A80148 l_rtzacti->l_azwacti by vealxu
     FROM rtz_file INNER JOIN azw_file                      #FUN-A80148 add azw_file by vealxu
       ON rtz01 = azw01                                     #FUN-A80148 add by vealxu 
    WHERE rtz01=g_lme.lmestore
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-001'
                                LET l_rtz13=NULL
    #  WHEN l_rtzacti='N'       LET g_errno='9028'           #FUN-A80148 mark by vealxu
       WHEN l_azwacti = 'N'     LET g_errno='9028'           #FUN-A80148 add  by vealxu  
       WHEN l_rtz28='N'         LET g_errno='alm-002'
       WHEN l_rtz01 <> g_plant  LET g_errno='alm-376'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lme.lmelegal
 
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION
 
FUNCTION i140_lme02(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_cnt      LIKE type_file.num5,
   l_lmb03    LIKE lmb_file.lmb03,
   l_lmb06    LIKE lmb_file.lmb06
 
   LET g_errno=''
   SELECT lmb03,lmb06
     INTO l_lmb03,l_lmb06
     FROM lmb_file
    WHERE lmb02=g_lme.lme02
      AND lmbstore=g_lme.lmestore
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-904'
                                LET l_lmb03=NULL
       WHEN l_lmb06='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_lme.lme03) AND p_cmd <> 'c' THEN
      SELECT COUNT(*) INTO l_cnt FROM lmc_file
       WHERE lmcstore = g_lme.lmestore
         AND lmc02 = g_lme.lme02
         AND lmc03 = g_lme.lme03
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-907'
      END IF
   END IF
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lmb03 TO FORMONLY.lmb03
   END IF
END FUNCTION
 
FUNCTION i140_lme03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_cnt      LIKE type_file.num5,
   l_lmc04    LIKE lmc_file.lmc04,
   l_lmc07    LIKE lmc_file.lmc07
 
   LET g_errno=''
   SELECT lmc04,lmc07
     INTO l_lmc04,l_lmc07
     FROM lmc_file
    WHERE lmc03=g_lme.lme03 
      AND lmcstore=g_lme.lmestore
      AND lmc02=g_lme.lme02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-977'
                                LET l_lmc04=NULL
       WHEN l_lmc07='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_lme.lme02) AND p_cmd <> 'c' THEN
      SELECT COUNT(*) INTO l_cnt FROM lmc_file
       WHERE lmcstore = g_lme.lmestore
         AND lmc02 = g_lme.lme02
         AND lmc03 = g_lme.lme03
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-907'
      END IF
   END IF
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION
 
FUNCTION i140_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lme.* TO NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i140_curs() 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i140_count
    FETCH i140_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i140_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,0)
        INITIALIZE g_lme.* TO NULL
    ELSE
        CALL i140_fetch('F')
    END IF
END FUNCTION
 
FUNCTION i140_fetch(p_fllme)
    DEFINE
        p_fllme         LIKE type_file.chr1
 
    CASE p_fllme
       WHEN 'N' FETCH NEXT     i140_cs INTO g_lme.lmestore,g_lme.lme02,g_lme.lme03
       WHEN 'P' FETCH PREVIOUS i140_cs INTO g_lme.lmestore,g_lme.lme02,g_lme.lme03
       WHEN 'F' FETCH FIRST    i140_cs INTO g_lme.lmestore,g_lme.lme02,g_lme.lme03
       WHEN 'L' FETCH LAST     i140_cs INTO g_lme.lmestore,g_lme.lme02,g_lme.lme03
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
           FETCH ABSOLUTE g_jump i140_cs INTO g_lme.lmestore,g_lme.lme02,g_lme.lme03
           LET g_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,0)
        INITIALIZE g_lme.* TO NULL
        RETURN
    ELSE
      CASE p_fllme
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lme.* FROM lme_file 
     WHERE lmestore = g_lme.lmestore
       AND lme02 = g_lme.lme02
       AND lme03 = g_lme.lme03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lme_file",g_lme.lmestore,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_lme.lmeuser
        LET g_data_group=g_lme.lmegrup
        CALL i140_show()
    END IF
END FUNCTION
 
FUNCTION i140_show()
    LET g_lme_t.* = g_lme.*
    DISPLAY BY NAME g_lme.lmestore,g_lme.lme02,g_lme.lme03,g_lme.lme04, g_lme.lmeoriu,g_lme.lmeorig,
                    g_lme.lme05,g_lme.lme06,g_lme.lme07,g_lme.lmeuser,
                    g_lme.lmemodu,g_lme.lmegrup,g_lme.lmedate,g_lme.lmeacti,
                    g_lme.lmecrat,g_lme.lmelegal
    CALL i140_lmestore('d')
    CALL i140_lme02('d')
    CALL i140_lme03('d')
    CALL cl_set_field_pic(g_lme.lme05,"","","","",g_lme.lmeacti)
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i140_u()
    IF g_lme.lmestore IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lme.* FROM lme_file WHERE lmestore=g_lme.lmestore
                                          AND lme02=g_lme.lme02
                                          AND lme03=g_lme.lme03
    IF g_lme.lmeacti = 'N' THEN
       CALL cl_err('',9027,0) 
       RETURN
    END IF
    IF g_lme.lme05 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lmestore_t = g_lme.lmestore
    LET g_lme02_t = g_lme.lme02
    LET g_lme03_t = g_lme.lme03
    BEGIN WORK
 
    OPEN i140_cl USING g_lme.lmestore,g_lme.lme02,g_lme.lme03
    IF STATUS THEN
       CALL cl_err("OPEN i140_cl:", STATUS, 1)
       CLOSE i140_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i140_cl INTO g_lme.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_lme.lmemodu=g_user 
    LET g_lme.lmedate = g_today
    CALL i140_show()
    WHILE TRUE
        CALL i140_i("u") 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lme.*=g_lme_t.*
            CALL i140_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lme_file SET lme_file.* = g_lme.* 
         WHERE lmestore = g_lmestore_t
           AND lme02 = g_lme02_t
           AND lme03 = g_lme03_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lme_file",g_lme.lmestore,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i140_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i140_x()
    IF g_lme.lmestore IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lme.lme05 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i140_cl USING g_lme.lmestore,g_lme.lme02,g_lme.lme03
    IF STATUS THEN
       CALL cl_err("OPEN i140_cl:", STATUS, 1)
       CLOSE i140_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i140_cl INTO g_lme.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i140_show()
    IF cl_exp(0,0,g_lme.lmeacti) THEN
        LET g_chr=g_lme.lmeacti
        IF g_lme.lmeacti='Y' THEN
            LET g_lme.lmeacti='N'
        ELSE
            LET g_lme.lmeacti='Y'
        END IF
        UPDATE lme_file
           SET lmeacti=g_lme.lmeacti,
               lmemodu=g_user,
               lmedate=g_today
         WHERE lmestore = g_lme.lmestore
           AND lme02 = g_lme.lme02
           AND lme03 = g_lme.lme03
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,0)
           LET g_lme.lmeacti=g_chr
        ELSE
           LET g_lme.lmemodu=g_user
           LET g_lme.lmedate=g_today
           DISPLAY BY NAME g_lme.lmeacti,g_lme.lmemodu,g_lme.lmedate
           CALL cl_set_field_pic("","","","","",g_lme.lmeacti)
        END IF
    END IF
    CLOSE i140_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i140_r()
    IF g_lme.lmestore IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lme.lmeacti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
    IF g_lme.lme05 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i140_cl USING g_lme.lmestore,g_lme.lme02,g_lme.lme03
    IF STATUS THEN
       CALL cl_err("OPEN i140_cl:", STATUS, 0)
       CLOSE i140_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i140_cl INTO g_lme.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i140_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lmestore"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lme.lmestore      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM lme_file WHERE lmestore = g_lme.lmestore
                              AND lme02 = g_lme.lme02
                              AND lme03 = g_lme.lme03
       CLEAR FORM
       OPEN i140_count
       FETCH i140_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i140_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i140_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i140_fetch('/')
       END IF
    END IF
    CLOSE i140_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i140_copy()
    DEFINE
        l_newno1   LIKE lme_file.lmestore,
        l_newno2   LIKE lme_file.lme02,
        l_newno3   LIKE lme_file.lme03,
        l_oldno1   LIKE lme_file.lmestore,
        l_oldno2   LIKE lme_file.lme02,
        l_oldno3   LIKE lme_file.lme03,
        l_rtz13    LIKE rtz_file.rtz13,
        l_lmb03    LIKE lmb_file.lmb03,
        l_lmc04    LIKE lmc_file.lmc04,
        l_cnt      LIKE type_file.num5,
        p_cmd      LIKE type_file.chr1,
        l_input    LIKE type_file.chr1 
 
    IF g_lme.lmestore IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_oldno1 = g_lme.lmestore
    LET l_oldno2 = g_lme.lme02
    LET l_oldno3 = g_lme.lme03
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i140_set_entry('a')
    CALL cl_set_comp_entry("lmestore",FALSE)
    LET g_before_input_done = TRUE
    CALL i140_lmestore('d')
    LET l_newno1 = g_lme.lmestore
    
    INPUT l_newno2,l_newno3 FROM lme02,lme03
 
        AFTER FIELD lme02
           IF l_newno2 IS NOT NULL THEN
              LET g_lme.lmestore = l_newno1
              LET g_lme.lme02 = l_newno2
              CALL i140_lme02('c')
              LET g_lme.lmestore = l_oldno1
              LET g_lme.lme02 = l_oldno2
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('lme02:',g_errno,1)
                 NEXT FIELD lme02
              END IF
              IF NOT cl_null(l_newno3) THEN
                  SELECT COUNT(*) INTO l_cnt FROM lme_file
                   WHERE lmestore = l_newno1
                     AND lme02 = l_newno2
                     AND lme03 = l_newno3
                  IF l_cnt > 0 THEN
                     CALL cl_err(l_newno2,'-239',0)
                     NEXT FIELD lme02
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM lmc_file
                   WHERE lmcstore = l_newno1
                     AND lmc02 = l_newno2
                     AND lmc03 = l_newno3
                  IF l_cnt = 0 THEN
                     CALL cl_err(l_newno3,'alm-907',0)
                     NEXT FIELD lme03
                  END IF
               END IF
           END IF
 
        BEFORE FIELD lme03
           IF cl_null(l_newno2) THEN
              CALL cl_err('','alm-390',0)
              NEXT FIELD lme02
           END IF
  
        AFTER FIELD lme03
           IF l_newno3 IS NOT NULL THEN
              LET g_lme.lmestore = l_newno1
              LET g_lme.lme02 = l_newno2
              LET g_lme.lme03 = l_newno3
              CALL i140_lme03('c')
              LET g_lme.lmestore = l_oldno1
              LET g_lme.lme02 = l_oldno2
              LET g_lme.lme03 = l_oldno3
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('lme03:',g_errno,1)
                 NEXT FIELD lme03
              END IF
              IF NOT cl_null(l_newno2) THEN
                  SELECT COUNT(*) INTO l_cnt FROM lme_file
                   WHERE lmestore = l_newno1
                     AND lme02 = l_newno2
                     AND lme03 = l_newno3
                  IF l_cnt > 0 THEN
                     CALL cl_err(l_newno3,'-239',0)
                     NEXT FIELD lme03
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM lmc_file
                   WHERE lmcstore = l_newno1
                     AND lmc02 = l_newno2
                     AND lmc03 = l_newno3
                  IF l_cnt = 0 THEN
                     CALL cl_err(l_newno3,'alm-907',0)
                     NEXT FIELD lme03
                  END IF
               END IF
            END IF
        
        ON ACTION controlp 
           CASE
            WHEN INFIELD(lme02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc1"
               LET g_qryparam.default1 = l_newno2
               LET g_qryparam.default2 = l_newno3
               LET g_qryparam.default3 = l_lmc04
               CALL cl_create_qry() RETURNING l_newno2,l_newno3,l_lmc04
               DISPLAY l_newno2,l_newno3,l_lmc04 TO lme02,lme03,lmc04
               NEXT FIELD lme02
            WHEN INFIELD(lme03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc1"
               LET g_qryparam.default1 = l_newno2
               LET g_qryparam.default2 = l_newno3
               LET g_qryparam.default3 = l_lmc04
               CALL cl_create_qry() RETURNING l_newno2,l_newno3,l_lmc04
               DISPLAY l_newno2,l_newno3,l_lmc04 TO lme02,lme03,lmc04
               NEXT FIELD lme03
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
        DISPLAY BY NAME g_lme.lmestore,g_lme.lme02,g_lme.lme03
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM lme_file
        WHERE lmestore = g_lme.lmestore
          AND lme02 = g_lme.lme02
          AND lme03 = g_lme.lme03
        INTO TEMP x
    UPDATE x
        SET lmestore=l_newno1,
            lme02=l_newno2,
            lme03=l_newno3,
            lme05='N',
            lme06='',
            lme07='',
            lmeacti='Y', 
            lmeuser=g_user,
            lmegrup=g_grup, 
            lmemodu=NULL,  
            lmedate=NULL, 
            lmecrat=g_today
 
    INSERT INTO lme_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lme_file",g_lme.lmestore,"",SQLCA.sqlcode,"","",0)
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_lme.lmestore
        LET l_oldno2 = g_lme.lme02
        LET l_oldno3 = g_lme.lme03
        LET g_lme.lmestore = l_newno1
        LET g_lme.lme02 = l_newno2
        LET g_lme.lme03 = l_newno3
        SELECT lme_file.* INTO g_lme.* FROM lme_file
               WHERE lmestore = l_newno1
                 AND lme02 = l_newno2
                 AND lme03 = l_newno3
        CALL i140_u()
        UPDATE lme_file set lmedate=NULL,lmemodu=NULL 
                        WHERE lmestore=l_newno1
                          AND lme02=l_newno2
                          AND lme03=l_newno3
       #TQC-A30075 -BEGIN-----
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","lme_file",g_lme.lmestore,"",SQLCA.sqlcode,"","",0)
        END IF
       #No.TQC-A30075 -END-------
        SELECT lme_file.* INTO g_lme.* FROM lme_file
               WHERE lmestore = l_oldno1
                 AND lme02 = l_oldno2
                 AND lme03 = l_oldno3
    END IF
    LET g_lme.lmestore = l_oldno1
    LET g_lme.lme02 = l_oldno2
    LET g_lme.lme03 = l_oldno3
    CALL i140_show()
END FUNCTION
 
FUNCTION i140_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lmestore,lme02,lme03",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i140_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lmestore,lme02,lme03",FALSE)
   END IF
   CALL cl_set_comp_entry("lmestore",FALSE)
END FUNCTION
 
FUNCTION i140_y()
   IF cl_null(g_lme.lmestore) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
   IF g_lme.lmeacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lme.lme05='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   IF NOT cl_confirm('alm-006') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i140_cl USING g_lme.lmestore,g_lme.lme02,g_lme.lme03
   IF STATUS THEN
      CALL cl_err("OPEN i140_cl:", STATUS, 1)
      CLOSE i140_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i140_cl INTO g_lme.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,0)      
      CLOSE i140_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lme_file SET lme05 = 'Y',lme06 = g_user,lme07 = g_today
    WHERE lmestore = g_lme.lmestore
      AND lme02 = g_lme.lme02
      AND lme03 = g_lme.lme03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lme_file",g_lme.lmestore,g_lme.lme02,STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lme.lme05 = 'Y'
      LET g_lme.lme06 = g_user
      LET g_lme.lme07 = g_today
      DISPLAY BY NAME g_lme.lme05,g_lme.lme06,g_lme.lme07
      CALL cl_set_field_pic(g_lme.lme05,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i140_z()
   DEFINE l_cnt LIKE type_file.num5
   IF cl_null(g_lme.lmestore) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   IF g_lme.lmeacti='N' THEN
      CALL cl_err('','alm-049',0)
      RETURN
   END IF
   
   IF g_lme.lme05='N' THEN 
      CALL cl_err('','9025',0)
      RETURN
   END IF
  
   SELECT count(*) INTO l_cnt FROM lmd_file WHERE lmdstore=g_lme.lmestore
                                              AND lmd03=g_lme.lme02
                                              AND lmd04=g_lme.lme03
   IF l_cnt > 0 THEN
      CALL cl_err('','alm-083',0) #判斷是否已有該門店該樓棟該樓層的場地資料
      RETURN
   END IF
 
   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i140_cl USING g_lme.lmestore,g_lme.lme02,g_lme.lme03
   IF STATUS THEN
      CALL cl_err("OPEN i140_cl:", STATUS, 1)
      CLOSE i140_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i140_cl INTO g_lme.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lme.lmestore,SQLCA.sqlcode,0)      
      CLOSE i140_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lme_file SET lme05 = 'N',lme06 = '',lme07 = '',
                       lmemodu=g_user,lmedate=g_today
    WHERE lmestore = g_lme.lmestore
      AND lme02 = g_lme.lme02
      AND lme03 = g_lme.lme03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lme_file",g_lme.lmestore,g_lme.lme02,STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lme.lme05 = 'N'
      LET g_lme.lme06 = ''
      LET g_lme.lme07 = ''
      LET g_lme.lmemodu=g_user
      LET g_lme.lmedate=g_today
      DISPLAY BY NAME g_lme.lme05,g_lme.lme06,g_lme.lme07,
                      g_lme.lmemodu,g_lme.lmedate
      CALL cl_set_field_pic(g_lme.lme05,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore

