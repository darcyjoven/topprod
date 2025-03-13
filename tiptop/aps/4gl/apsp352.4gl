# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsp352.4gl
# Descriptions...: MDS沖銷-客戶優先序設定自動產生作業
# Date & Author..: No:FUN-AB0090 2010/11/30 By Mandy
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_vlp            RECORD LIKE vlp_file.*
DEFINE g_wc             STRING  
DEFINE g_sql            STRING  
DEFINE g_a              LIKE type_file.chr1
DEFINE g_b              LIKE type_file.chr1
DEFINE g_c              LIKE type_file.chr1
DEFINE g_str            LIKE vlp_file.vlp02
DEFINE g_end            LIKE vlp_file.vlp02
DEFINE g_msg            LIKE ze_file.ze03

MAIN
   DEFINE   p_row,p_col LIKE type_file.num5     

   OPTIONS
      #FORM LINE     FIRST + 2, #FUN-B50022 mark
      #MESSAGE LINE  LAST-1,    #FUN-B50022 mark
      #PROMPT LINE   LAST,      #FUN-B50022 mark
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 2 LET p_col = 23
   OPEN WINDOW p352_w AT p_row,p_col
        WITH FORM "aps/42f/apsp352"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   WHILE TRUE
      CALL p352_qbe() #輸入執行apsp352 QBE條件
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      CALL p352_ask() #輸入執行apsp352 INPUT條件
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p352() 
      ERROR ''
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_null(g_end) THEN
          LET g_msg = g_str," TO ",g_end
          CALL cl_err(g_msg,'aps-103',1)
      ELSE
          CALL cl_err('','axc-034',1)
      END IF
      EXIT WHILE
   END WHILE
   CLOSE WINDOW p352_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p352()
   CALL p352_curs()
   LET g_success = 'Y'
   BEGIN WORK
     CALL p352_ins_vlp()
   IF g_success = 'Y' THEN
       COMMIT WORK
   ELSE
       ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION p352_qbe()
  DEFINE l_dd  LIKE type_file.num5     #FUN-890055 add

  CONSTRUCT BY NAME g_wc ON occ01,occ34

     ON ACTION locale
        LET g_action_choice = "locale"
        CALL cl_show_fld_cont()                   
        EXIT CONSTRUCT
 
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(occ01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_occ"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ01
             NEXT FIELD occ01
 
           WHEN INFIELD(occ34)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_occ34"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ34 
             NEXT FIELD occ34
 
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
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
  END CONSTRUCT
  IF INT_FLAG THEN RETURN END IF
END FUNCTION

FUNCTION p352_ask()

  LET g_a = '1'
  LET g_b = '2'
  LET g_c = '2'
  DISPLAY g_a,g_b,g_c TO FORMONLY.a,FORMONLY.b,FORMONLY.c

  INPUT g_a,g_b,g_c WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.b,FORMONLY.c

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
  IF INT_FLAG THEN RETURN END IF
END FUNCTION
FUNCTION p352_curs()
DEFINE l_order1         STRING  
DEFINE l_order2         STRING  

      IF g_a = '1' THEN 
          LET l_order1 = 'occ01'
      ELSE
          LET l_order1 = 'occ34'
      END IF
      IF g_b = '1' THEN 
          LET l_order2 = 'occ01'
      ELSE
          LET l_order2 = 'occ34'
      END IF

      IF g_c = '1' THEN
          LET g_sql = "SELECT occ01,occ34 FROM occ_file",
                      " WHERE ",g_wc CLIPPED,
                      "   AND occacti = 'Y' "
      ELSE
          LET g_sql = "SELECT occ01,occ34 FROM occ_file",
                      " WHERE ",g_wc CLIPPED,
                      "   AND occacti = 'Y' ",
                      "   AND occ01 NOT IN (SELECT vlp03 FROM vlp_file ",
                      "                      WHERE vlp01 = '2') "
      END IF
      LET g_sql = g_sql CLIPPED,
                  " ORDER BY ",l_order1 CLIPPED,",",l_order2 CLIPPED
      PREPARE p352_p1 FROM g_sql
      DECLARE p352_c1 CURSOR FOR p352_p1
END FUNCTION

FUNCTION p352_ins_vlp()
  DEFINE l_occ34    LIKE occ_file.occ34

      INITIALIZE g_vlp.* TO NULL
      LET g_str = NULL
      LET g_end = NULL
      LET g_vlp.vlp01 = '2' #客戶
      LET g_vlp.vlpacti = 'Y'
      LET g_vlp.vlpuser = g_user
      LET g_vlp.vlpdate = g_today
      IF g_c = '1' THEN
          DELETE FROM vlp_file
           WHERE vlp01 = '2' #客戶
          IF SQLCA.sqlcode THEN
              CALL cl_err('Delete vlp err',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
          END IF
          LET g_vlp.vlp02 = 10
      ELSE
          SELECT max(vlp02)+10
            INTO g_vlp.vlp02
            FROM vlp_file
           WHERE vlp01 = '2' #客戶
          IF cl_null(g_vlp.vlp02) THEN
              LET g_vlp.vlp02 = 10
          END IF
      END IF
      LET g_str = g_vlp.vlp02
      FOREACH p352_c1 INTO g_vlp.vlp03,l_occ34
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach p352_c1:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         INSERT INTO vlp_file VALUES(g_vlp.*)
         IF STATUS THEN CALL cl_err('ins vlp_file:',STATUS,1) 
             LET g_success = 'N'
             EXIT FOREACH
         ELSE
             LET g_end = g_vlp.vlp02
         END IF
         LET g_vlp.vlp02 = g_vlp.vlp02 + 10
      END FOREACH
END FUNCTION
#FUN-AB0090
