# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: asks001.4gl
# Descriptions...: 尺寸表參數維護作業
# Date & Author..: No.FUN-870117 by ve007  
# Modify.........: No.FUN-8A0121 By hongmei欄位類型修改
# Modify.........: No.TQC-8C0056 08/12/23 By alex 調整setup參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
  
DEFINE g_sla       RECORD LIKE sla_file.*
DEFINE g_sla_t     RECORD LIKE sla_file.*
DEFINE g_sla_o     RECORD LIKE sla_file.*       
DEFINE g_forupd_sql STRING  
 
MAIN
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASK")) THEN   #TQC-8C0056
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   OPEN WINDOW asks001_w WITH FORM "ask/42f/asks001" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()	
 
   CALL asks001_show()
 
   LET g_action_choice=""
   CALL asks001_menu()
 
   CLOSE WINDOW asks001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION asks001_show()
 
   SELECT * INTO g_sla.* FROM sla_file WHERE sla00 = '0'
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   DISPLAY BY NAME g_sla.sla01,g_sla.sla011,
                   g_sla.sla02,g_sla.sla021,
                   g_sla.sla03,g_sla.sla031,
                   g_sla.sla04,g_sla.sla041 
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asks001_menu()
    MENU ""
       ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL asks001_u()
          END IF
       ON ACTION help 
          CALL cl_show_help()
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION asks001_u()
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT * FROM sla_file WHERE sla00 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sla_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN sla_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN          
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN  
    END IF
    FETCH sla_curl INTO g_sla.*
    IF SQLCA.sqlcode != 0 THEN
       IF SQLCA.sqlcode = 100 THEN 
          INSERT INTO sla_file  VALUES ('0','','','','','','','','')
       ELSE 
          CALL cl_err('',SQLCA.sqlcode,0)
          RETURN
       END IF  
    END IF
    LET g_sla_o.* = g_sla.*
    LET g_sla_t.* = g_sla.*
    DISPLAY BY NAME g_sla.sla01,g_sla.sla011,
                    g_sla.sla02,g_sla.sla021,
                    g_sla.sla03,g_sla.sla031, 
                    g_sla.sla04,g_sla.sla041
    WHILE TRUE
        CALL asks001_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sla_file SET
              sla01  = g_sla.sla01,
              sla011 = g_sla.sla011,
              sla02  = g_sla.sla02,
              sla021 = g_sla.sla021,
              sla03  = g_sla.sla03,
              sla031 = g_sla.sla031,
              sla04  = g_sla.sla04,
              sla041 = g_sla.sla041
            WHERE sla00 = '0'
        IF SQLCA.sqlcode THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        UNLOCK TABLE sla_file
        EXIT WHILE
    END WHILE
    CLOSE sla_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asks001_i()
 
    DEFINE l_n     LIKE type_file.num5    #SMALLINT
 
      INPUT BY NAME g_sla.sla01,g_sla.sla011,
                    g_sla.sla02,g_sla.sla021,
                    g_sla.sla03,g_sla.sla031,
                    g_sla.sla04,g_sla.sla041
                    WITHOUT DEFAULTS
 
      AFTER FIELD sla01
         IF NOT cl_null(g_sla.sla01) THEN
            LET l_n = '0'
            SELECT COUNT(*) INTO l_n FROM agc_file
             WHERE agc01 = g_sla.sla01
            IF l_n = '0' THEN 
               CALL cl_err('','ask-391',0)
               NEXT FIELD sla01
            END IF
            IF (g_sla.sla01 = g_sla.sla02) OR 
               (g_sla.sla01 = g_sla.sla03) OR
               (g_sla.sla01 = g_sla.sla04)
            THEN
               CALL cl_err('','ask-390',0)
               NEXT FIELD sla01
            END IF
          IF (g_sla.sla02 = g_sla.sla01) OR (g_sla.sla03 = g_sla.sla01)OR (g_sla.sla04 = g_sla.sla01) THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla01
           END IF  
         END IF
 
      AFTER FIELD sla02
         IF NOT cl_null(g_sla.sla02) THEN
            LET l_n = '0'
            SELECT COUNT(*) INTO l_n FROM agc_file
             WHERE agc01 = g_sla.sla02
            IF l_n = '0' THEN
               CALL cl_err('','ask-391',0)
               NEXT FIELD sla02
            END IF
            IF (g_sla.sla02 = g_sla.sla01) OR
               (g_sla.sla02 = g_sla.sla03) OR
               (g_sla.sla02 = g_sla.sla04)
            THEN
               CALL cl_err('','ask-390',0)
               NEXT FIELD sla02
            END IF
            IF (g_sla.sla01 = g_sla.sla02) OR (g_sla.sla03 = g_sla.sla02)OR (g_sla.sla04 = g_sla.sla02)THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla02
           END IF
         END IF
 
      AFTER FIELD sla03
         IF NOT cl_null(g_sla.sla03) THEN
            LET l_n = '0'
            SELECT COUNT(*) INTO l_n FROM agc_file
             WHERE agc01 = g_sla.sla03
            IF l_n = '0' THEN
               CALL cl_err('','ask-391',0)
               NEXT FIELD sla03
            IF (g_sla.sla03 = g_sla.sla01) OR
               (g_sla.sla03 = g_sla.sla02) OR
               (g_sla.sla03 = g_sla.sla04)
            THEN
               CALL cl_err('','ask-390',0)
               NEXT FIELD sla03
            END IF
 
            END IF
          IF (g_sla.sla01 = g_sla.sla03) OR (g_sla.sla02 = g_sla.sla03)OR (g_sla.sla04 = g_sla.sla03)THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla03
           END IF
         END IF
 
      AFTER FIELD sla04
         IF NOT cl_null(g_sla.sla04) THEN
            LET l_n = '0'
            SELECT COUNT(*) INTO l_n
              FROM agc_file
             WHERE agc01 = g_sla.sla04
            IF l_n = '0' THEN
               CALL cl_err('','ask-391',0)
               NEXT FIELD sla04
            IF (g_sla.sla04 = g_sla.sla01) OR
               (g_sla.sla04 = g_sla.sla02) OR
               (g_sla.sla04 = g_sla.sla03)
            THEN
               CALL cl_err('','ask-390',0)
               NEXT FIELD sla04
            END IF
 
            END IF
          IF (g_sla.sla01 = g_sla.sla04) OR (g_sla.sla02 = g_sla.sla04)OR (g_sla.sla03 = g_sla.sla04)THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla04
            END IF
         END IF
     
     AFTER FIELD sla011
       IF NOT cl_null(g_sla.sla011) THEN 
           IF  g_sla.sla011 != '1' AND g_sla.sla011 != '2'
              AND  g_sla.sla011 != '3' AND  g_sla.sla011 ! = '4' THEN 
               CALL cl_err ('','ask-120',0)
               NEXT FIELD sla011
           END IF 
           SELECT COUNT(*)  INTO l_n  FROM  sla_file WHERE sla021 = g_sla.sla011 OR
               sla031 = g_sla.sla011 OR sla041 = g_sla.sla011 
           IF l_n >0 THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla011
           END IF  
       END IF  
       
      AFTER FIELD sla021
       IF NOT cl_null(g_sla.sla021) THEN 
          IF  g_sla.sla021 != '1' AND g_sla.sla021 != '2'
              AND g_sla.sla021 != '3' AND g_sla.sla021 ! = '4' THEN 
              CALL cl_err ('','ask-120',0)
              NEXT FIELD sla021
           END IF 
           SELECT COUNT(*) INTO l_n FROM sla_file
            WHERE sla011 = g_sla.sla021
               OR sla041 = g_sla.sla021 OR sla031 = g_sla.sla021 
           IF l_n >0 THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla021
           END IF       
       END IF 
       
       AFTER FIELD sla031
       IF NOT cl_null(g_sla.sla031) THEN 
          IF g_sla.sla031 != '1' AND g_sla.sla031 != '2' AND
             g_sla.sla031 != '3' AND g_sla.sla031 ! = '4' THEN 
              CALL cl_err ('','ask-120',0)
              NEXT FIELD sla031
           END IF 
           SELECT COUNT(*)  INTO l_n  FROM  sla_file WHERE sla011 = g_sla.sla031 OR
               sla021 = g_sla.sla031 OR sla041 = g_sla.sla031 
           IF l_n >0 THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla031
           END IF  
       END IF 
       
       AFTER FIELD sla041
       IF NOT cl_null(g_sla.sla041) THEN 
          IF  g_sla.sla041 != '1' AND g_sla.sla041 != '2'
              AND g_sla.sla041 != '3' AND g_sla.sla041 ! = '4'THEN 
              CALL cl_err ('','ask-120',0)
              NEXT FIELD sla041
           END IF 
           SELECT COUNT(*)  INTO l_n  FROM  sla_file WHERE sla011 = g_sla.sla041 OR
               sla021 = g_sla.sla041 OR sla031 = g_sla.sla041 
           IF l_n >0 THEN 
             CALL cl_err('','-239',0)
             NEXT FIELD sla041
           END IF  
       END IF        
      ON ACTION CONTROLP
            CASE
              WHEN INFIELD(sla01)    
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_agc'
                 LET g_qryparam.default1 = g_sla.sla01
                 CALL cl_create_qry() RETURNING g_sla.sla01
                 DISPLAY BY NAME g_sla.sla01
                 NEXT FIELD sla01
              WHEN INFIELD(sla02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_agc'
                 LET g_qryparam.default1 = g_sla.sla02
                 CALL cl_create_qry() RETURNING g_sla.sla02
                 DISPLAY BY NAME g_sla.sla02
                 NEXT FIELD sla02
              WHEN INFIELD(sla03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_agc'
                 LET g_qryparam.default1 = g_sla.sla03
                 CALL cl_create_qry() RETURNING g_sla.sla03
                 DISPLAY BY NAME g_sla.sla03
                 NEXT FIELD sla03
              WHEN INFIELD(sla04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_agc'
                 LET g_qryparam.default1 = g_sla.sla04
                 CALL cl_create_qry() RETURNING g_sla.sla04
                 DISPLAY BY NAME g_sla.sla04
                 NEXT FIELD sla04
            END CASE
 
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   
   END INPUT
END FUNCTION
 
