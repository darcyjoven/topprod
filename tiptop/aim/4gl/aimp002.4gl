# Prog. Version..: '5.30.06-13.03.28(00005)'     #
#
# Pattern name...: aimp002.4gl
# Descriptions...: 
# Date & Author..: 10/03/20 By dxfwo
# Modify.........: No:FUN-8C0131 10/02/22 by dxfwo  
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-CB0143 12/11/23 By Elise 應一併update img37

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       string                    
DEFINE g_cnt            LIKE type_file.num10   
DEFINE g_change_lang    LIKE type_file.chr1    
       
#No.FUN-8C0131
MAIN
   DEFINE l_flag        LIKE type_file.chr1    

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_tlf.tlf01=ARG_VAL(1)
   LET g_tlf.tlf902=ARG_VAL(2)
   LET g_tlf.tlf903=ARG_VAL(3)
   LET g_tlf.tlf904=ARG_VAL(4)
   LET g_tlf.tlf61=ARG_VAL(5)         
   LET g_bgjob = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF


   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p002_p1()
         IF cl_sure(0,0) THEN
            BEGIN WORK
            CALL p002_p2()
            CALL cl_end(0,0)
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag    
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag   
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p002_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p002_p2()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF

 END WHILE

 CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION p002_p1()
DEFINE lc_cmd        LIKE type_file.chr1000 
DEFINE p_row,p_col   LIKE type_file.num5    

 OPEN WINDOW p002_w AT p_row,p_col
      WITH FORM "aim/42f/aimp002"
      ATTRIBUTE (STYLE = g_win_style)

 CALL cl_ui_init()

 LET g_bgjob = 'N'

 WHILE TRUE
   CALL cl_opmsg('z')
   CONSTRUCT BY NAME g_wc ON tlf01,tlf902,tlf903,tlf904,tlf61
   BEFORE CONSTRUCT 
      CALL cl_qbe_init()
      
      ON ACTION CONTROLP
       CASE 
        WHEN INFIELD(tlf01)
#FUN-AA0059 --Begin--
       #  CALL cl_init_qry_var()
       #  LET g_qryparam.form ="q_ima"
       #  CALL cl_create_qry() RETURNING g_tlf.tlf01
         CALL q_sel_ima(FALSE, "q_ima", "", g_tlf.tlf01, "", "", "", "" ,"",'' )  RETURNING g_tlf.tlf01
#FUN-AA0059 --End--
         DISPLAY BY NAME g_tlf.tlf01
         NEXT FIELD tlf01
        WHEN INFIELD(tlf902)
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_imd01"
         CALL cl_create_qry() RETURNING g_tlf.tlf902
         DISPLAY BY NAME g_tlf.tlf902
         NEXT FIELD tlf902
        WHEN INFIELD(tlf903)
         CALL cl_init_qry_var()
         IF NOT cl_null(g_tlf.tlf902) THEN 
            LET g_qryparam.form ="q_ime001"
            LET g_qryparam.arg1 = g_tlf.tlf902
         ELSE
         	  LET g_qryparam.form ="q_ime4_1" 
         END IF 	  
         CALL cl_create_qry() RETURNING g_tlf.tlf903
         DISPLAY BY NAME g_tlf.tlf903
         NEXT FIELD tlf903         
       END CASE   

      ON ACTION qbe_select
         CALL cl_qbe_select()
            
      ON ACTION locale                     
         LET g_change_lang = TRUE
         EXIT CONSTRUCT

      ON ACTION close             
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT CONSTRUCT  
      
      ON ACTION exit              
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF

             
   INPUT BY NAME g_bgjob WITHOUT DEFAULTS  


   AFTER FIELD g_bgjob
        IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
           NEXT FIELD g_bgjob
        END IF

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

   
     ON ACTION locale
          LET g_change_lang = TRUE
        EXIT INPUT
      
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
      
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF

     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aimp002"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aimp002','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_tlf.tlf01 CLIPPED,"'",
                        " '",g_tlf.tlf902 CLIPPED,"'",
                        " '",g_tlf.tlf903 CLIPPED,"'",
                        " '",g_tlf.tlf904 CLIPPED,"'",
                        " '",g_tlf.tlf61 CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aimp002',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p002_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  
        EXIT PROGRAM
     END IF
     EXIT WHILE

 END WHILE

END FUNCTION

FUNCTION p002_p2()
DEFINE l_ima01     LIKE ima_file.ima01     #MOD-CB0143 add
DEFINE l_ima9021   LIKE ima_file.ima9021   #MOD-CB0143 add

   LET g_success='Y'
   CALL p002_s1()
   IF  g_success='Y' THEN 
      UPDATE ima_file 
         SET ima902=ima9021 
       WHERE ima902 IS NULL 
         AND ima9021 IS NOT NULL

     #MOD-CB0143---add---S
      LET g_sql = " SELECT ima01,ima9021 FROM ima_file WHERE ima9021 IS NOT NULL "

      PREPARE p2_ima FROM g_sql
      DECLARE p2_ima_2 CURSOR FOR p2_ima
      FOREACH p2_ima_2 INTO l_ima01,l_ima9021
       UPDATE img_file
          SET img37 = l_ima9021
        WHERE img01 = l_ima01
          AND img37 IS null
      END FOREACH
     #MOD-CB0143---add---E

    END IF        
END FUNCTION

FUNCTION p002_s1()   
DEFINE p_plant  LIKE type_file.chr21
DEFINE l_slip   LIKE aba_file.aba00
DEFINE l_sql    STRING
DEFINE l_img37  LIKE img_file.img37
DEFINE l_ima902 LIKE ima_file.ima902
DEFINE l_max_tlf06 LIKE tlf_file.tlf06
DEFINE l_oay12  LIKE oay_file.oay12
DEFINE l_smy56  LIKE smy_file.smy56
DEFINE l_azp03  LIKE  azp_file.azp03
DEFINE l_dbs    LIKE  azp_file.azp03

   LET p_plant = ''
   SELECT azp03  INTO l_azp03 FROM azp_file 
    WHERE azp01 = g_plant 
   LET l_dbs = s_dbstring(l_azp03)
   LET p_plant=l_dbs

  #LET g_sql = " SELECT * FROM ",p_plant,"tlf_file ",   #FUN-A50102
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant,'tlf_file'),  #FUN-A50102
               "  WHERE ",g_wc CLIPPED 
   IF STATUS THEN 
       CALL cl_err3("sel","tlf_file",g_tlf.tlf01,"",STATUS,"","sel tlf:",0)   #NO.FUN-640266
       RETURN 
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql  #FUN-A50102
   PREPARE tlf_pre  FROM g_sql
   DECLARE tlf_curs CURSOR FOR tlf_pre
   
   FOREACH tlf_curs INTO g_tlf.*
      #IF NOT s_untlf1(p_plant) THEN 
      IF NOT s_untlf1(g_plant) THEN    #FUN-A50102
         LET g_success='N' RETURN
      END IF 
   END FOREACH 
    
   
END FUNCTION



