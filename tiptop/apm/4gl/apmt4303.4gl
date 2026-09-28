# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apmt4303.4gl
# Descriptions...:
# Date & Author..: No.FUN-9A0065 09/12/08 By destiny
# Modify.........: No.FUN-A10034 10/01/07 By destiny 修改b2b bug 
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds
#No.FUN-9A0065 
GLOBALS "../../config/top.global"
DEFINE  g_wpbc01      LIKE wpbc_file.wpbc01
DEFINE  g_wpbc02      LIKE wpbc_file.wpbc02
DEFINE g_wpbc_t       RECORD 
                      wpbc03  LIKE wpbc_file.wpbc03,
                      pmc03   LIKE pmc_file.pmc03
                      END RECORD 
DEFINE g_wpbc         DYNAMIC ARRAY OF RECORD 
                      wpbc03  LIKE wpbc_file.wpbc03,
                      pmc03   LIKE pmc_file.pmc03
                      END RECORD,
       g_rec_b        LIKE type_file.num5,                
       l_ac           LIKE type_file.num5,
       l_ac_t         LIKE type_file.num5,
       g_sql          STRING, 
       g_cnt          LIKE type_file.num5  
                    
MAIN 
   DEFINE   lwin_curr   ui.Window

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   LET g_wpbc01=ARG_VAL(1)
   LET g_wpbc02=ARG_VAL(2)
   IF (NOT cl_user()) THEN 
      EXIT PROGRAM 
   END IF 
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("APM")) THEN 
      EXIT PROGRAM 
   END IF 
   
 # CALL cl_used("apmt4303",g_time,1) RETURNING g_time 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   OPEN WINDOW t4303_w1 WITH FORM "apm/42f/apmt4303" 
     ATTRIBUTE (STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
   DISPLAY g_wpbc01,g_wpbc02 TO FORMONLY.wpbc01,FORMONLY.wpbc02
   CALL t4303_b_fill()
   CALL t4303_menu()
   CLOSE WINDOW t4303_w1
 # CALL cl_used("apmt4303",g_time,2) RETURNING g_time 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN 

FUNCTION t4303_menu()
   WHILE TRUE
      CALL t4303_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t4303_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "close"
            EXIT WHILE    
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_wpbc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 

FUNCTION t4303_b_fill()
DEFINE l_cnt        LIKE type_file.num5
    CALL g_wpbc.clear()
    LET g_sql=" SELECT wpbc03,pmc03 FROM wpbc_file,pmc_file ",
              " WHERE wpbc01='",g_wpbc01,"' AND wpbc02='",g_wpbc02,"' AND pmc01=wpbc03 "
    PREPARE t4303_p1 FROM g_sql
    DECLARE t4303_c1 CURSOR FOR t4303_p1
    LET l_cnt=1
    FOREACH t4303_c1 INTO g_wpbc[l_cnt].*
        IF g_cnt > g_max_rec THEN
           CALL cl_err('', 9035, 0 )
           EXIT FOREACH
        END IF
        LET l_cnt=l_cnt+1 
    END FOREACH 
    CALL g_wpbc.deleteElement(l_cnt)
    LET g_rec_b = l_cnt-1
    LET l_cnt = 0
    
END FUNCTION 

FUNCTION t4303_b()
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_lock_sw    LIKE type_file.chr1  
DEFINE l_n          LIKE type_file.num5
    
    LET g_action_choice = ""               
    IF cl_null(g_wpbc01) OR cl_null(g_wpbc01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    LET g_sql=" SELECT wpbc03,'' FROM wpbc_file ",
              " WHERE wpbc01='",g_wpbc01,"' AND wpbc02='",g_wpbc02,"' AND wpbc03=? FOR UPDATE "
    LET g_sql = cl_forupd_sql(g_sql)          
    DECLARE t4303_bc1 CURSOR FROM g_sql 
    INPUT ARRAY g_wpbc FROM s_wpbc.* 
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,DELETE ROW =TRUE,APPEND ROW =TRUE,
                 INSERT ROW =TRUE,WITHOUT DEFAULTS =true)
        
      BEFORE ROW 
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'    
        IF g_rec_b>=l_ac THEN  
           LET p_cmd='u' 
           BEGIN WORK 
           LET g_wpbc_t.*=g_wpbc[l_ac].*
           OPEN t4303_bc1 USING g_wpbc[l_ac].wpbc03
           IF STATUS THEN 
              CALL cl_err("OPEN t4303_bc1:",STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH t4303_bc1 INTO g_wpbc[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_wpbc_t.wpbc03,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
                 CALL t4303_wpbc03(g_wpbc[l_ac].wpbc03)
              END IF              
           END IF 
        END IF     
        
      BEFORE INSERT
         LET p_cmd='a'                                                                                  
         INITIALIZE g_wpbc[l_ac].* TO NULL           
         
      AFTER INSERT      
         INSERT INTO wpbc_file VALUES(g_wpbc01,g_wpbc02,g_wpbc[l_ac].wpbc03)
         IF SQLCA.sqlcode THEN 
            CALL cl_err3('ins','wpbc_file',g_wpbc01,g_wpbc02,SQLCA.sqlerrd,'','',0)
            ROLLBACK WORK 
            CANCEL INSERT
         ELSE
            LET g_rec_b=g_rec_b+1
            COMMIT WORK            
         END IF 
         
      AFTER FIELD wpbc03   
          IF NOT cl_null(g_wpbc[l_ac].wpbc03) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND g_wpbc[l_ac].wpbc03 !=g_wpbc_t.wpbc03) THEN
                SELECT COUNT(*) INTO l_n FROM wpbc_file 
                 WHERE wpbc01=g_wpbc01
                   AND wpbc02=g_wpbc02
                   AND wpbc03=g_wpbc[l_ac].wpbc03
                IF l_n >0 THEN 
                   CALL cl_err('',-239,1)
                   LET g_wpbc[l_ac].wpbc03=g_wpbc_t.wpbc03
                   NEXT FIELD wpbc03
                END IF  
                CALL t4303_wpbc03(g_wpbc[l_ac].wpbc03)
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_wpbc[l_ac].wpbc03=g_wpbc_t.wpbc03
                   NEXT FIELD wpbc03
                END IF 
             END IF 
          END IF  
          
       BEFORE DELETE                         
          IF g_wpbc_t.wpbc03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM wpbc_file 
              WHERE wpbc01=g_wpbc01 
                AND wpbc02=g_wpbc02
                AND wpbc03=g_wpbc_t.wpbc03  
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","wpbc_file",g_wpbc_t.wpbc03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN              
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_wpbc[l_ac].* = g_wpbc_t.*
             CLOSE t4303_bc1
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_wpbc[l_ac].wpbc03,-263,0)
             LET g_wpbc[l_ac].* = g_wpbc_t.*
             UPDATE wpbc_file SET wpbc03=g_wpbc[l_ac].wpbc03
              WHERE wpbc03 = g_wpbc_t.wpbc03 
                AND wpbc01 = g_wpbc01
                AND wpbc01 = g_wpbc01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","wpbc_file",g_wpbc_t.wpbc03,"",SQLCA.sqlcode,"","",1) 
                LET g_wpbc[l_ac].* = g_wpbc_t.*
             ELSE
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()         
          LET l_ac_t = l_ac                
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_wpbc[l_ac].* = g_wpbc_t.*
             END IF
             CLOSE t4303_bc1     
             ROLLBACK WORK          
             EXIT INPUT
          END IF
 
          CLOSE t4303_bc1          
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(wpbc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc01"
                 LET g_qryparam.default1 = g_wpbc[l_ac].wpbc03
                 CALL cl_create_qry() RETURNING g_wpbc[l_ac].wpbc03
                 DISPLAY BY NAME g_wpbc[l_ac].wpbc03
                 NEXT FIELD wpbc03
           END CASE
                 
    END INPUT 
    CLOSE t4303_bc1
    COMMIT WORK
    
END FUNCTION

FUNCTION t4303_wpbc03(p_wpbc03)
DEFINE p_wpbc03     LIKE wpbc_file.wpbc03
DEFINE l_pmc03      LIKE pmc_file.pmc03
DEFINE l_pmcacti    LIKE pmc_file.pmcacti

    LET g_errno=''
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
     WHERE pmc01=p_wpbc03
    CASE  
        WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
        WHEN l_pmcacti='N'     LET g_errno='9028'
      OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '-------'
    END CASE 
    IF cl_null(g_errno) THEN 
       LET g_wpbc[l_ac].pmc03=l_pmc03
       DISPLAY BY NAME g_wpbc[l_ac].pmc03
    END IF 
END FUNCTION 

FUNCTION t4303_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_wpbc TO s_wpbc.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
         
      ON ACTION detail
         LET g_action_choice="detail"
#        LET l_ac = 1                      #No.FUN-A10034
         LET l_ac = ARR_CURR()             #No.FUN-A10034 
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close 
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
#        EXIT MENU                      #No.FUN-A10034 
         EXIT DISPLAY                   #No.FUN-A10034  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()       
  
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
