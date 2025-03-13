# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apjs100.4gl
# Descriptions...: 
# Date & Author..: 08/03/06 By ve007      #No.FUN-810069
# Modify.........: No.FUN-930106 09/03/18 By destiny pju01/pju02,pju03,pju04增加管控
# Modify.........: No.FUN-980005 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_pju       RECORD LIKE pju_file.*,
        g_pju_t     RECORD LIKE pju_file.*,
        g_pju00_t   LIKE pju_file.pju00,
        g_pju01_t   LIKE pju_file.pju01,
        g_pju02_t   LIKE pju_file.pju02,
        g_pju03_t   LIKE pju_file.pju03,
        g_pju04_t   LIKE pju_file.pju04
DEFINE  g_forupd_sql STRING  
 
MAIN
    DEFINE p_row,p_col    LIKE type_file.num5          
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("apj")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   #檢查是否有更改的權限
   LET g_action_choice = 'modify'
   IF NOT cl_chk_act_auth() THEN EXIT PROGRAM END IF   #無更改權限
 
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW s100_w AT p_row,p_col WITH FORM "apj/42f/apjs100" 
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL s100_show()
 
   LET g_action_choice=""
   CALL s100_menu()
 
   CLOSE WINDOW s100_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION s100_show()
 
    SELECT * INTO g_pju.* FROM pju_file
    IF SQLCA.sqlcode OR g_pju.pju00 IS NULL THEN
        IF SQLCA.sqlcode=-284 THEN
            CALL cl_err3("sel","pju_file",g_pju.pju01,"",SQLCA.sqlcode,"","pju_FILE fail,Restart!",1)  
            DELETE FROM pju_file WHERE 1=1
        END IF
        
        LET g_pju.pju00 = '0'
        LET g_pju.pju05 = '0'
        LET g_pju.pju06 = '0'
        LET g_pju.pju07 = '0'
        LET g_pju.pju08 = '0'
        LET g_pju.pju09 = '0'
        LET g_pju.pju10 = '0'
        LET g_pju.pjuplant = g_plant #FUN-980005
        LET g_pju.pjulegal = g_legal #FUN-980005
        
        INSERT INTO pju_file VALUES (g_pju.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","pju_file",g_pju.pju00,"",SQLCA.sqlcode,"","INSERT pju_FILE",1)    
            RETURN
        END IF
    END IF
 
    DISPLAY BY NAME g_pju.pju01,g_pju.pju02,g_pju.pju03,g_pju.pju04
		CALL s100_pju01('d') 
		CALL s100_pju02('d') 
		CALL s100_pju03('d') 
		CALL s100_pju04('d') 
		
    CALL cl_show_fld_cont()                  
    
END FUNCTION
 
FUNCTION s100_menu()
 
  MENU ""
    ON ACTION modify 
 
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL s100_u()
       END IF
 
    ON ACTION help 
       CALL cl_show_help()
       
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
      ON ACTION about      
         CALL cl_about()    
 
      ON ACTION controlg   
         CALL cl_cmdask()    
 
       LET g_action_choice = "exit"
       CONTINUE MENU
 
        -- for Windows close event trapped
        
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 	
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s100_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pju00_t = g_pju.pju00
    LET g_pju01_t = g_pju.pju01
    LET g_pju02_t = g_pju.pju02
    LET g_pju03_t = g_pju.pju03
    LET g_pju04_t = g_pju.pju04
 
    LET g_forupd_sql = "SELECT * FROM pju_file FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE pju_cl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN pju_cl
    IF STATUS  THEN CALL cl_err('OPEN pju_curl',STATUS,1) RETURN END IF
    FETCH pju_cl INTO g_pju.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_pju_t.*=g_pju.*
 
    DISPLAY BY NAME g_pju.pju01,g_pju.pju02,g_pju.pju03,g_pju.pju04
    WHILE TRUE
        CALL s100_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pju.* = g_pju_t.*
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pju_file
           SET pju_file.*=g_pju.*
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pju_file",g_pju.pju01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE pju_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s100_i()
DEFINE l_success  LIKE type_file.chr1
    
   INPUT BY NAME g_pju.pju01,g_pju.pju02,g_pju.pju03,g_pju.pju04 WITHOUT DEFAULTS 
      
      AFTER FIELD pju01
        IF  g_pju.pju01 != g_pju_t.pju01 THEN
            CALL s100_chk(g_pju.pju01) RETURNING l_success
        END IF     
        IF l_success != 'Y' THEN
           LET g_pju.pju01 = g_pju_t.pju01
           NEXT FIELD pju01
        END IF  
        CALL s100_pju01('d')  
      
      AFTER FIELD pju02
        IF  g_pju.pju02 != g_pju_t.pju02 THEN
            CALL s100_chk(g_pju.pju02) RETURNING l_success
        END IF     
        IF l_success != 'Y' THEN
           LET g_pju.pju02 = g_pju_t.pju02
           NEXT FIELD pju02
        END IF 
        CALL s100_pju02('d')
        
      AFTER FIELD pju03
        IF  g_pju.pju03 != g_pju_t.pju03 THEN
            CALL s100_chk(g_pju.pju03) RETURNING l_success
        END IF     
        IF l_success != 'Y' THEN
           LET g_pju.pju03 = g_pju_t.pju03
           NEXT FIELD pju03
        END IF
        CALL s100_pju03('d')         
      
      AFTER FIELD pju04
        IF  g_pju.pju04 != g_pju_t.pju04 THEN
            CALL s100_chk(g_pju.pju04) RETURNING l_success
        END IF     
        IF l_success != 'Y' THEN
           LET g_pju.pju04 = g_pju_t.pju04
           NEXT FIELD pju04
        END IF 
        CALL s100_pju04('d')   
                     
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pju01)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_azf_1a"              #No.FUN-930106
               LET g_qryparam.form = "q_azf01a"              #No.FUN-930106
               LET g_qryparam.arg1 = "7"                     #No.FUN-930106  
               LET g_qryparam.default1 = g_pju.pju01
               CALL cl_create_qry()  RETURNING g_pju.pju01
               DISPLAY g_pju.pju01 TO pju01
               CALL s100_pju01('d')
               NEXT FIELD pju01
               
            WHEN INFIELD(pju02)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_azf_1a"              #No.FUN-930106
               LET g_qryparam.form = "q_azf01a"              #No.FUN-930106
               LET g_qryparam.arg1 = "7"                     #No.FUN-930106  
               LET g_qryparam.default1 = g_pju.pju02
               CALL cl_create_qry()  RETURNING g_pju.pju02
               DISPLAY g_pju.pju02 TO pju02
               CALL s100_pju02('d')
               NEXT FIELD pju02
 
            WHEN INFIELD(pju03)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_azf_1a"              #No.FUN-930106 
               LET g_qryparam.form = "q_azf01a"              #No.FUN-930106
               LET g_qryparam.arg1 = "7"                     #No.FUN-930106  
               LET g_qryparam.default1 = g_pju.pju03
               CALL cl_create_qry()  RETURNING g_pju.pju03
               DISPLAY g_pju.pju03 TO pju03
               CALL s100_pju03('d')
               NEXT FIELD pju03
 
            WHEN INFIELD(pju04)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_azf_1a"              #No.FUN-930106
               LET g_qryparam.form = "q_azf01a"              #No.FUN-930106
               LET g_qryparam.arg1 = "7"                     #No.FUN-930106  
               LET g_qryparam.default1 = g_pju.pju04
               CALL cl_create_qry()  RETURNING g_pju.pju04
               DISPLAY g_pju.pju04 TO pju04
               CALL s100_pju04('d')
               NEXT FIELD pju04
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help        
         CALL cl_show_help()  
 
   
   END INPUT
END FUNCTION
 
FUNCTION s100_pju01(p_cmd)
DEFINE l_azf03  LIKE azf_file.azf03,
       p_cmd    LIKE type_file.chr1
 
  LET g_errno = ''
  SELECT azf03 INTO l_azf03 FROM azf_file                  
      WHERE azf01 = g_pju.pju01
        AND azf02 = '2'
        
  CASE WHEN SQLCA. sqlcode =100 LET g_errno = 'mfg3008'
                      LET l_azf03 = NULL
           OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
  END CASE
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_azf03 TO FORMONLY.azf03_1
  END IF
END FUNCTION  
 
FUNCTION s100_pju02(p_cmd)
DEFINE l_azf03  LIKE azf_file.azf03,
       p_cmd    LIKE type_file.chr1
 
  LET g_errno = ''
  SELECT azf03 INTO l_azf03 FROM azf_file                         
      WHERE azf01 = g_pju.pju02
        AND azf02 = '2'
        
  CASE WHEN SQLCA. sqlcode =100 LET g_errno = 'mfg3008'
                      LET l_azf03 = NULL
           OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
  END CASE
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_azf03 TO FORMONLY.azf03_2
  END IF
END FUNCTION  
 
FUNCTION s100_pju03(p_cmd)
DEFINE l_azf03  LIKE azf_file.azf03,
       p_cmd    LIKE type_file.chr1
 
  LET g_errno = ''
  SELECT azf03 INTO l_azf03 FROM azf_file                 
      WHERE azf01 = g_pju.pju03
        AND azf02 = '2'
        
  CASE WHEN SQLCA. sqlcode =100 LET g_errno = 'mfg3008'
                      LET l_azf03 = NULL
           OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
  END CASE
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_azf03 TO FORMONLY.azf03_3
  END IF
END FUNCTION                              
 
FUNCTION s100_pju04(p_cmd)
DEFINE l_azf03  LIKE azf_file.azf03,
       p_cmd    LIKE type_file.chr1
 
  LET g_errno = ''
  SELECT azf03 INTO l_azf03 FROM azf_file     
      WHERE azf01 = g_pju.pju04
        AND azf02 = '2'
        
  CASE WHEN SQLCA. sqlcode =100 LET g_errno = 'mfg3008'
                      LET l_azf03 = NULL
           OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
  END CASE
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_azf03 TO FORMONLY.azf03_4
  END IF
END FUNCTION           
  
FUNCTION s100_chk(p_pju01)
DEFINE p_pju01    LIKE azf_file.azf01,
       l_n        LIKE type_file.num10,
       l_success  LIKE type_file.chr1
DEFINE l_azf09    LIKE azf_file.azf09        #No.FUN-930106
      
       LET l_success = 'Y'
       
       SELECT COUNT(*) INTO l_n FROM azf_file 
         WHERE azf01 = p_pju01
           AND azf02 = '2'
       IF l_n =0 THEN
          CALL cl_err('','ask-008',0)
          LET l_success = 'N'
       END IF
       #No.FUN-930106--begin
       SELECT azf09 INTO l_azf09 FROM azf_file
         WHERE azf01 =p_pju01
           AND azf02 ='2'
       IF l_azf09 !='7' THEN 
          CALL cl_err('','aoo-406',0)
          LET l_success = 'N'
       END IF 
       #No.FUN-930106--end
       RETURN l_success
END FUNCTION            
#No.FUN-810069       
