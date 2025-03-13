# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_passpriv.4gl
# Descriptions...: 登入密碼限制設定作業
# Date & Author..: 08/03/19 by alex    #FUN-830011
# Modify.........: No.FUN-830112 08/03/24 By alex 增加異動記錄
# Modify.........: No.FUN-910094 09/01/19 By alex 增加准許 zx10進行編碼功能
# Modify.........: No.TQC-920013 09/02/06 By alex 調整gbt07 default
# Modify.........: No.FUN-930042 09/03/06 By alex 新增密碼可試誤次數及是否可重覆使用同密碼
# Modify.........: No.TQC-940001 09/04/01 By liuxqa 調整gbt06 default
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds   #FUN-830011
 
GLOBALS "../../config/top.global"
 
DEFINE g_gbt           RECORD LIKE gbt_file.*   # 參數檔
DEFINE g_gbt04_time    LIKE gbt_file.gbt04      #FUN-930042
DEFINE g_gbt_t         RECORD LIKE gbt_file.*   # 參數檔
DEFINE g_forupd_sql    STRING 
DEFINE g_before_input_done LIKE type_file.num5
 
MAIN
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW p_passpriv_w WITH FORM "azz/42f/p_passpriv" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   CALL p_passpriv_show()
 
   LET g_action_choice=""
   CALL p_passpriv_menu()
 
   CLOSE WINDOW p_passpriv_w
 
END MAIN
 
FUNCTION p_passpriv_show()
 
   DEFINE  li_i   LIKE type_file.num5
 
   SELECT * INTO g_gbt.* FROM gbt_file WHERE gbt00 = '0'
   IF SQLCA.sqlcode THEN
      SELECT COUNT(*) INTO li_i FROM gbt_file
      IF li_i = 0 THEN
         LET g_gbt.gbt00 = "0"
         LET g_gbt.gbt01 = "0"
         LET g_gbt.gbt02 = "0"
         LET g_gbt.gbt03 = "0"
         LET g_gbt.gbt04 = "0"
         LET g_gbt.gbt05 = "0"
#        LET g_gbt.gbt06 = "Y"        #No.TQC-940001 mark
         LET g_gbt.gbt06 = "N"        #No.TQC-940001 mod
         LET g_gbt.gbt07 = "N"         #FUN-910094 #TQC-920013
         LET g_gbt.gbt08 = "Y"         #FUN-930042
         LET g_gbt.gbt10 = 0           #FUN-930042
         LET g_gbt.gbtgrup = g_grup    #FUN-830112
         LET g_gbt.gbtdate = g_today   #FUN-830112
         LET g_gbt.gbtmodu = g_user    #FUN-830112
 
         INSERT INTO gbt_file VALUES (g_gbt.*)
      ELSE
         CALL cl_err3("sel","gbt_file","","",SQLCA.sqlcode,"","",0)
         RETURN
      END IF
   ELSE    
      IF g_gbt.gbt07 IS NULL OR g_gbt.gbt07 <> "Y" THEN   #FUN-910094
         LET g_gbt.gbt07 = "N"
      END IF
 
      IF g_gbt.gbt08 IS NULL OR g_gbt.gbt08 <> "N" THEN   #FUN-930042
         LET g_gbt.gbt08 = "Y"
      END IF
 
      IF g_gbt.gbt10 IS NULL THEN   #FUN-930042
         LET g_gbt.gbt10 = 0
      END IF
   END IF
 
   IF g_gbt.gbt01 = 2 THEN
      LET g_gbt04_time = g_gbt.gbt04 
      LET g_gbt.gbt04  = 0
   ELSE
      LET g_gbt04_time = 0
   END IF
   DISPLAY g_gbt04_time TO FORMONLY.gbt04_time
 
   DISPLAY BY NAME g_gbt.gbt01,g_gbt.gbt02,g_gbt.gbt03,g_gbt.gbt04,g_gbt.gbt05,
                   g_gbt.gbt06,g_gbt.gbt07,                    #FUN-910094
                   g_gbt.gbt08,g_gbt.gbt10,                    #FUN-930042
                   g_gbt.gbtgrup,g_gbt.gbtdate,g_gbt.gbtmodu   #FUN-830112
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION p_passpriv_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL p_passpriv_u()
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
      
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION p_passpriv_u()
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_forupd_sql = "SELECT * FROM gbt_file WHERE gbt00 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE gbt_curl CURSOR FROM  g_forupd_sql
 
   BEGIN WORK
 
   OPEN gbt_curl USING '0'
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('open cursor',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FETCH gbt_curl INTO g_gbt.*
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_gbt_t.* = g_gbt.*
 
   IF g_gbt.gbt07 IS NULL OR g_gbt.gbt07 <> "Y" THEN   #FUN-910094
      LET g_gbt.gbt07 = "N"
   END IF
 
   IF g_gbt.gbt08 IS NULL OR g_gbt.gbt08 <> "N" THEN   #FUN-930042
      LET g_gbt.gbt08 = "Y"
   END IF
 
   IF g_gbt.gbt10 IS NULL THEN   #FUN-930042
      LET g_gbt.gbt10 = 0
   END IF
   IF g_gbt.gbt01 = 2 THEN
      LET g_gbt04_time = g_gbt.gbt04 
      LET g_gbt.gbt04  = 0
   ELSE
      LET g_gbt04_time = 0
   END IF
   DISPLAY g_gbt04_time TO FORMONLY.gbt04_time
 
   DISPLAY BY NAME g_gbt.gbt01, g_gbt.gbt02, g_gbt.gbt03, g_gbt.gbt04,  
                   g_gbt.gbt05, g_gbt.gbt06, g_gbt.gbt07,        #FUN-910094
                   g_gbt.gbt08, g_gbt.gbt10,                     #FUN-930042
                   g_gbt.gbtmodu, g_gbt.gbtgrup, g_gbt.gbtdate   #FUN-830112
   WHILE TRUE
      CALL p_passpriv_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_gbt.gbt01=2 THEN LET g_gbt.gbt04 = g_gbt04_time END IF
 
      UPDATE gbt_file SET gbt01 = g_gbt.gbt01, gbt02 = g_gbt.gbt02,
                          gbt03 = g_gbt.gbt03, gbt04 = g_gbt.gbt04,
                          gbt05 = g_gbt.gbt05, gbt06 = g_gbt.gbt06,
                          gbt07 = g_gbt.gbt07,                      #FUN-910094
                          gbt08 = g_gbt.gbt08, gbt10 = g_gbt.gbt10, #FUN-930042
                          gbtgrup = g_grup, gbtmodu = g_user, gbtdate = g_today #FUN-830112
       WHERE gbt00 = '0'
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gbt_file","","",SQLCA.sqlcode,"","",0) 
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE gbt_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_passpriv_i()
 
   #Web密碼更新功能 (gbt07)不放入INPUT中，因為需要靠小工具來變更 FUN-910094
    
   INPUT g_gbt.gbt01, g_gbt.gbt02, g_gbt.gbt03, g_gbt.gbt04, g_gbt.gbt05,
         g_gbt04_time,
         g_gbt.gbt06, g_gbt.gbt08, g_gbt.gbt10
         WITHOUT DEFAULTS 
    FROM gbt01,gbt02,gbt03,gbt04,gbt05,gbt04_time,gbt06,gbt08,gbt10
        
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_passpriv_set_entry()
         CALL p_passpriv_set_no_entry()
         LET g_before_input_done = TRUE
 
      BEFORE FIELD gbt01
         CALL p_passpriv_set_no_entry()
 
      AFTER FIELD gbt01
         CALL p_passpriv_set_entry()
 
      AFTER FIELD gbt10
         IF g_gbt.gbt10 < 0 THEN
            CALL cl_err("Value Need To Be Equal OR Large Than Zero","!",1)
            NEXT FIELD gbt10
         END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
   END INPUT
 
END FUNCTION
 
 
FUNCTION p_passpriv_set_entry()
 
   IF INFIELD(gbt01) OR NOT g_before_input_done THEN
      CASE g_gbt.gbt01 
         WHEN "1" 
            CALL cl_set_comp_entry("gbt03,gbt04_time",FALSE)
            CALL cl_set_comp_required("gbt03,gbt04_time",FALSE)
         WHEN "2" 
            CALL cl_set_comp_entry("gbt02,gbt04",FALSE)
            CALL cl_set_comp_required("gbt02,gbt04",FALSE)
         OTHERWISE
            CALL cl_set_comp_entry("gbt02,gbt03,gbt04,gbt04_time",FALSE)
            CALL cl_set_comp_required("gbt02,gbt03,gbt04,gbt04_time",FALSE)
      END CASE
   END IF
 
END FUNCTION
 
FUNCTION p_passpriv_set_no_entry()
 
   IF INFIELD(gbt01) OR NOT g_before_input_done THEN
      CALL cl_set_comp_entry("gbt02,gbt03,gbt04,gbt04_time",TRUE)
      CALL cl_set_comp_required("gbt02,gbt03,gbt04,gbt04_time",TRUE)
   END IF
 
END FUNCTION
 
