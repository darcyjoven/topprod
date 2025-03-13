# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axrp700.4gl
# Descriptions...: 押金轉應收批次產生作業
# Date & Author..: #TQC-AC0127      10/12/21 By wuxj 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_g_ar.global" 
 
DEFINE g_wc,g_sql       LIKE type_file.chr1000   
DEFINE g_wc1            LIKE type_file.chr1000  
DEFINE l_dbs            LIKE type_file.chr21   
DEFINE g_start1         LIKE oma_file.oma01   
DEFINE source           LIKE azp_file.azp01  
DEFINE p_row,p_col      LIKE type_file.num5  
DEFINE g_oma            RECORD LIKE oma_file.*
DEFINE g_rxr            RECORD LIKE rxr_file.*
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE g_change_lang        LIKE type_file.chr1  
DEFINE g_ooa                RECORD  LIKE ooa_file.*         
DEFINE g_flag               LIKE type_file.chr1 
DEFINE g_rxr00              LIKE rxr_file.rxr00
DEFINE g_rxr01              LIKE rxr_file.rxr01 

MAIN
   DEFINE l_oom01   LIKE oom_file.oom01
   DEFINE l_oom02   LIKE oom_file.oom02
   DEFINE l_cnt     LIKE type_file.num5       
   DEFINE ls_date   STRING                   
   DEFINE l_flag    LIKE type_file.chr1     
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   WHILE TRUE
      CALL p700()
      IF cl_sure(18,20) THEN 
         LET g_success = 'Y'
         CALL p700_p()
         IF g_success = 'Y' AND g_flag = 'Y' THEN
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN
            IF NOT cl_null(g_rxr00) AND NOT cl_null(g_rxr01) THEN
               CLOSE WINDOW p700_w
               EXIT WHILE
            ELSE
               CONTINUE WHILE
            END IF 
         ELSE
            CLOSE WINDOW p700_w 
            EXIT WHILE
         END IF
      ELSE
         IF NOT cl_null(g_rxr00) AND NOT cl_null(g_rxr01) THEN 
            CLOSE WINDOW p700_w
            EXIT WHILE
         ELSE  
            CONTINUE WHILE
         END IF   
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p700()
   DEFINE li_result LIKE type_file.num5       
   DEFINE lc_cmd    LIKE type_file.chr1000   
   DEFINE l_azp02   LIKE azp_file.azp02     
   DEFINE l_azp03   LIKE azp_file.azp03    
   DEFINE l_ooyacti LIKE ooy_file.ooyacti
   DEFINE l_n       LIKE type_file.num5 
 
   LET p_row = 2 LET p_col = 8
   OPEN WINDOW p700_w AT p_row,p_col WITH FORM "axr/42f/axrp700"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
 
   CLEAR FORM

   WHILE TRUE

      CALL cl_opmsg('w')
      MESSAGE ""

      LET g_rxr00 = ARG_VAL(1)
      LET g_rxr01 = ARG_VAL(2)
      IF NOT cl_null(g_rxr01) AND NOT cl_null(g_rxr00) THEN 
         LET g_rxr.rxrplant = g_plant
         LET g_rxr.rxr00 = g_rxr00
         LET g_rxr.rxr01 = g_rxr01
         LET g_wc = " rxr01 = '",g_rxr.rxr01,"'" 
         DISPLAY BY NAME g_rxr.rxrplant,g_rxr.rxr00,g_rxr.rxr01
         EXIT WHILE
      END IF 

      INPUT BY NAME g_rxr.rxrplant,g_rxr.rxr00
         BEFORE INPUT 
            LET g_rxr.rxrplant = g_plant
            LET g_rxr.rxr00 = '1'
            DISPLAY BY NAME g_rxr.rxrplant,g_rxr.rxr00
  
         AFTER FIELD rxrplant 
            IF NOT cl_null(g_rxr.rxrplant) THEN 
               SELECT COUNT(*) INTO l_n FROM azw_file,azp_file 
                WHERE azw01 = azp01 AND azw01 = g_rxr.rxrplant AND azw02 = g_legal 
               IF l_n = 0 THEN 
                  CALL cl_err(g_rxr.rxrplant,'axrp701',0)
                  NEXT FIELD rxrplant 
               END IF 
            ELSE
               NEXT FIELD rxrplant 
            END IF

         AFTER FIELD rxr00
           IF cl_null(g_rxr.rxr00) THEN 
              NEXT FIELD rxr00
           END IF

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT  

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT

         ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT INPUT  

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(rxrplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxrplant
                   NEXT FIELD rxrplant 
            END CASE
 
      END INPUT

      CONSTRUCT BY NAME g_wc ON rxr01,rxr05 

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT CONSTRUCT

         ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT CONSTRUCT

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(rxr01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rxr011"
                   LET g_qryparam.arg2 = g_rxr.rxrplant
                   LET g_qryparam.arg1 = g_rxr.rxr00
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxr01
                   NEXT FIELD rxr01
            END CASE
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p700_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p700_p()
 DEFINE l_rxr      RECORD LIKE rxr_file.* 
 DEFINE l_azp01    LIKE azp_file.azp01
   
   DROP TABLE x    #此臨時表是為s_t300_rgl建 
   SELECT * FROM npq_file WHERE 1=2 INTO TEMP x 
   BEGIN WORK
   LET g_success='Y'
   LET g_flag = 'N'
   CALL s_showmsg_init()

   LET g_sql = "SELECT azp01,azp03 FROM azp_file,azw_file ",
               " WHERE azp01 = '",g_rxr.rxrplant,"'",
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"'"

   PREPARE sel_azp03_pre FROM g_sql
   EXECUTE sel_azp03_pre INTO l_azp01,l_dbs
   IF STATUS THEN
      CALL cl_err('p700(ckp#1):',SQLCA.sqlcode,1)
      RETURN
   END IF

   LET g_plant_new = l_azp01
   CALL s_gettrandbs()
   LET l_dbs = g_dbs_tra
   LET source = l_azp01

   IF g_rxr.rxr00 = '1' THEN 
      LET g_sql="SELECT * FROM ",cl_get_target_table(l_azp01,'rxr_file'),
                " WHERE rxr16 IS NULL AND rxrconf='Y' AND rxr00 = '1' ",
                "   AND rxrplant = '",g_rxr.rxrplant,"' AND ",g_wc CLIPPED
   END IF 
   IF g_rxr.rxr00 = '2' THEN 
      LET g_sql="SELECT * FROM ",cl_get_target_table(l_azp01,'rxr_file'),
                " WHERE rxr16 IS NULL AND rxrconf='Y' AND rxr00 = '2' ",
                "   AND rxrplant = '",g_rxr.rxrplant,"' AND ",g_wc CLIPPED
   END IF 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
   PREPARE p700_prepare FROM g_sql
   DECLARE p700_cs CURSOR WITH HOLD FOR p700_prepare
  
   FOREACH p700_cs INTO l_rxr.*
      IF STATUS THEN
         CALL s_errmsg('','','p700(foreach):',STATUS,1) 
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    

      LET g_flag = 'Y'
   
      IF g_rxr.rxr00 = '1' THEN 
         CALL s_costs_ar1(l_rxr.rxr01) RETURNING g_oma.oma01
         IF cl_null(g_oma.oma01) OR g_success = 'N'  THEN
            LET g_success = 'N'
         END IF
   
         IF g_success = 'Y' THEN
            LET l_rxr.rxr16 = g_oma.oma01
            INITIALIZE g_oma.oma01 TO NULL        
            UPDATE rxr_file SET rxr16 = l_rxr.rxr16                                  
             WHERE rxr01 = l_rxr.rxr01
               AND rxr00 = l_rxr.rxr00
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rxr_file",l_rxr.rxr01,"",STATUS,"","",1)
               LET g_success = 'N'
            END IF
         END IF
      END IF 
      IF g_rxr.rxr00 = '2' THEN 
         CALL s_costs_ar2(l_rxr.rxr01) RETURNING g_ooa.ooa01
         IF cl_null(g_ooa.ooa01) OR g_success = 'N'  THEN
            LET g_success = 'N'
         END IF

         IF g_success = 'Y' THEN
            LET l_rxr.rxr16 = g_ooa.ooa01
            INITIALIZE g_ooa.ooa01 TO NULL
            UPDATE rxr_file SET rxr16 = l_rxr.rxr16
             WHERE rxr01 = l_rxr.rxr01
               AND rxr00 = l_rxr.rxr00
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rxr_file",l_rxr.rxr01,"",STATUS,"","",1)
               LET g_success = 'N'
            END IF
         END IF
      END IF

   END FOREACH
   IF g_success = 'Y' AND g_flag = 'Y' THEN
      COMMIT WORK
   ELSE
      IF g_flag = 'N' THEN
         CALL cl_err('','mfg3160',1)
      END IF
      ROLLBACK WORK
      CALL s_showmsg()
   END IF
END FUNCTION

#TQC-AC0127  add 
