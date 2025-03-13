# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: acos010.4gl
# Descriptions...: 海關合同參數設置作業 
# Date & Author..: 04/11/11 BY DAY 
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50039 11/07/06 By xianghui 增加自訂欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_coz_t         RECORD LIKE coz_file.*,  # 預留參數檔
        g_coz_o         RECORD LIKE coz_file.*   # 預留參數檔
DEFINE  g_forupd_sql    STRING                         #No.FUN-680069
DEFINE  g_before_input_done   LIKE type_file.num5      #No.FUN-680069 SMALLINT
DEFINE  p_cmd           LIKE type_file.chr1            #No.FUN-680069 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10           #No.FUN-680069 INTEGER
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0063
      DEFINE    p_row,p_col        LIKE type_file.num5             #No.FUN-680069 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   SELECT * INTO g_coz.* FROM coz_file WHERE coz00 = '0'
   IF STATUS = 100 THEN
      LET g_coz.coz00='0' INSERT INTO coz_file VALUES(g_coz.*)
   END IF
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   OPEN WINDOW s010_w AT p_row,p_col 
     WITH FORM "aco/42f/acos010"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL s010_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
   CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
   CLOSE WINDOW s010_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION s010_show()
 
   LET g_coz_t.* = g_coz.*
   LET g_coz_o.* = g_coz.*
   DISPLAY BY NAME g_coz.coz01,g_coz.coz03,g_coz.coz02,
                   g_coz.cozud01,g_coz.cozud02,g_coz.cozud03,g_coz.cozud04,g_coz.cozud05,   #FUN-B50039
                   g_coz.cozud06,g_coz.cozud07,g_coz.cozud08,g_coz.cozud09,g_coz.cozud10,   #FUN-B50039
                   g_coz.cozud11,g_coz.cozud12,g_coz.cozud13,g_coz.cozud14,g_coz.cozud15    #FUN-B50039
                   
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN 
            CALL s010_u()
         END IF
      ON ACTION reopen
         LET g_action_choice="reopen"
         IF cl_chk_act_auth() THEN
            CALL s010_y()
         END IF
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #EXIT MENU
      ON ACTION exit
           LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
         CONTINUE MENU
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION s010_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_forupd_sql = "SELECT * FROM coz_file      ",
                     " WHERE coz00 = '0' FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE coz_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN coz_curl 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   FETCH coz_curl INTO g_coz.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   WHILE TRUE
      CALL s010_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_coz.* = g_coz_t.*
         CALL s010_show()
         EXIT WHILE
      END IF
 
      UPDATE coz_file SET * = g_coz.* WHERE coz00='0'
      IF STATUS THEN
         CALL cl_err('',STATUS,0)
         CONTINUE WHILE
      END IF
 
      CLOSE coz_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION s010_i()
   DEFINE l_aza     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(01)
   DEFINE   l_n     LIKE type_file.num5          #No.FUN-680069 SMALLINT
   
   INPUT BY NAME g_coz.coz01,g_coz.coz03,g_coz.coz02,
                 g_coz.cozud01,g_coz.cozud02,g_coz.cozud03,g_coz.cozud04,g_coz.cozud05,   #FUN-B50039
                 g_coz.cozud06,g_coz.cozud07,g_coz.cozud08,g_coz.cozud09,g_coz.cozud10,   #FUN-B50039
                 g_coz.cozud11,g_coz.cozud12,g_coz.cozud13,g_coz.cozud14,g_coz.cozud15    #FUN-B50039
       WITHOUT DEFAULTS 
 
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL s010_set_entry(p_cmd)
          CALL s010_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD coz01
         IF NOT cl_null(g_coz.coz01) THEN
            IF g_coz.coz01 NOT MATCHES '[YN]' THEN
               LET g_coz.coz01=g_coz_o.coz01
               DISPLAY BY NAME g_coz.coz01
               NEXT FIELD coz01
            END IF
         END IF
         LET g_coz_o.coz01=g_coz.coz01
 
      AFTER FIELD coz03
         IF NOT cl_null(g_coz.coz03) THEN
            IF g_coz.coz03 NOT MATCHES '[YN]' THEN
               LET g_coz.coz03=g_coz_o.coz03
               DISPLAY BY NAME g_coz.coz03
               NEXT FIELD coz03
            END IF
         END IF
         LET g_coz_o.coz03=g_coz.coz03
         IF g_coz.coz03 = 'N' THEN
            CALL s010_set_no_entry(p_cmd)
         ELSE
            CALL s010_set_entry(p_cmd)
         END IF
 
      AFTER FIELD coz02
         IF NOT cl_null(g_coz.coz02) THEN
            SELECT COUNT(*) INTO g_cnt FROM cna_file
             WHERE cna01 = g_coz.coz02 
            IF g_cnt = 0 THEN
               CALL cl_err('',100,0)
               LET g_coz.coz02 =g_coz_o.coz02 
               DISPLAY BY NAME g_coz.coz02 
               NEXT FIELD coz02 
            END IF
         END IF
         LET g_coz_o.coz02 =g_coz.coz02  
 
      #FUN-B50039-add-str--
      AFTER FIELD cozud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cozud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(coz02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_cna' 
               LET g_qryparam.default1 =g_coz.coz02  
               CALL cl_create_qry() RETURNING g_coz.coz02 
               DISPLAY BY NAME g_coz.coz02
               NEXT FIELD coz02
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
 
FUNCTION s010_y()
 DEFINE   l_coz01    LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
     SELECT coz01 INTO l_coz01 FROM coz_file WHERE coz00='0'
     IF l_coz01 = 'Y' THEN RETURN END IF
     UPDATE coz_file SET coz01='Y' WHERE coz00='0'
     IF STATUS THEN
        LET g_coz.coz01='N'
        CALL cl_err('upd coz01:',STATUS,0)
     ELSE
        LET g_coz.coz01='Y'
     END IF
     DISPLAY BY NAME g_coz.coz01 
END FUNCTION
 
FUNCTION s010_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF INFIELD(coz03) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("coz02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION s010_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF INFIELD(coz03) OR (NOT g_before_input_done) THEN
         IF g_coz.coz03 = 'N'  THEN
              LET g_coz.coz02 = NULL
              DISPLAY BY NAME g_coz.coz02
              CALL cl_set_comp_entry("coz02",FALSE)
         END IF
   END IF
END FUNCTION
 
