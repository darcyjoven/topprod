# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: giss010.4gl
# Descriptions...: GIS系統參數
# Date & Author..: 05/09/05 By Carrier
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/06 By fengrui 增加自定義欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_isf_t         RECORD LIKE isf_file.*,  # 預留參數檔
        g_isf_o         RECORD LIKE isf_file.*   # 預留參數檔
    DEFINE g_status     STRING   #No.FUN-660146
 
DEFINE p_row,p_col      LIKE type_file.num5      #NO FUN-690009  SMALLINT                                                
DEFINE g_forupd_sql     STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_msg            LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(300)
 
MAIN
   DEFINE
      p_row,p_col LIKE type_file.num5    #NO FUN-690009 SMALLINT
#       l_time      LIKE type_file.chr8          #No.FUN-6A0098
 
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   LET p_row = 4 LET p_col = 8
   OPEN WINDOW s010_w AT p_row,p_col
        WITH FORM "gis/42f/giss010" ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
   CALL s010_show()
 
   LET g_action_choice=""
   CALL s010_menu()
 
   CLOSE WINDOW s010_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
 
END MAIN    
 
FUNCTION s010_show()
 
   SELECT * INTO g_isf.* FROM isf_file WHERE isf00 = '0'
 
   IF SQLCA.sqlcode THEN
      INSERT INTO isf_file(isf00,isf01,isf02,
                           isfud01,isfud02,isfud03,   #FUN-B50039-add-str--
                           isfud04,isfud05,isfud06,   #FUN-B50039-add-str--
                           isfud07,isfud08,isfud09,   #FUN-B50039-add-str--
                           isfud10,isfud11,isfud12,   #FUN-B50039-add-str--
                           isfud13,isfud14,isfud15)   #FUN-B50039-add-str--
                             
           VALUES ('0', g_isf.isf01,g_isf.isf02,
                   g_isf.isfud01,g_isf.isfud02,g_isf.isfud03,   #FUN-B50039-add-str--
                   g_isf.isfud04,g_isf.isfud05,g_isf.isfud06,   #FUN-B50039-add-str--
                   g_isf.isfud07,g_isf.isfud08,g_isf.isfud09,   #FUN-B50039-add-str--
                   g_isf.isfud01,g_isf.isfud11,g_isf.isfud12,   #FUN-B50039-add-str--
                   g_isf.isfud13,g_isf.isfud14,g_isf.isfud15)   #FUN-B50039-add-str--
      LET g_status = "ins"
   ELSE
      UPDATE isf_file SET isf01 = g_isf.isf01,
                          isf02 = g_isf.isf02,
                          #FUN-B50039-add-str--
                          isfud01 = g_isf.isfud01,
                          isfud02 = g_isf.isfud02,
                          isfud03 = g_isf.isfud03,
                          isfud04 = g_isf.isfud04,
                          isfud05 = g_isf.isfud05,
                          isfud06 = g_isf.isfud06,
                          isfud07 = g_isf.isfud07,
                          isfud08 = g_isf.isfud08,
                          isfud09 = g_isf.isfud09,
                          isfud10 = g_isf.isfud10,
                          isfud11 = g_isf.isfud11,
                          isfud12 = g_isf.isfud12,
                          isfud13 = g_isf.isfud13,
                          isfud14 = g_isf.isfud14,
                          isfud15 = g_isf.isfud15
                          #FUN-B50039-add-end--
       WHERE isf00 = '0'
      LET g_status = "upd"
   END IF
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660146
      CALL cl_err3(g_status,"isf_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660146
      RETURN
   END IF
 
   DISPLAY BY NAME g_isf.isf01,g_isf.isf02,
                   #FUN-B50039-add-str--
                   g_isf.isfud01,g_isf.isfud02,g_isf.isfud03,
                   g_isf.isfud04,g_isf.isfud05,g_isf.isfud06,
                   g_isf.isfud07,g_isf.isfud08,g_isf.isfud09,
                   g_isf.isfud01,g_isf.isfud11,g_isf.isfud12,
                   g_isf.isfud13,g_isf.isfud14,g_isf.isfud15
                   #FUN-B50039-add-end--
 
   CALL cl_show_fld_cont()
                   
END FUNCTION
 
FUNCTION s010_menu()
 
   MENU ""
   ON ACTION modify 
      LET g_action_choice = "modify"
      IF cl_chk_act_auth() THEN
         CALL s010_u()
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
 
   ON ACTION about         #MOD-4C0121
      CALL cl_about()      #MOD-4C0121
 
   ON ACTION controlg      #MOD-4C0121
      CALL cl_cmdask()     #MOD-4C0121
 
   -- for Windows close event trapped
   ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
       LET INT_FLAG=FALSE 		#MOD-570244	mars
       LET g_action_choice = "exit"
       EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION s010_u()
 
   CALL cl_opmsg('u')
   MESSAGE ""
 
   LET g_forupd_sql = "SELECT * FROM isf_file WHERE isf00 = '0' FOR UPDATE"    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE isf_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN isf_curl 
   IF STATUS THEN
      CALL cl_err('OPEN isf_curl',STATUS,1)
      RETURN
   END IF         
 
   FETCH isf_curl INTO g_isf.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   LET g_isf_t.* = g_isf.*
   LET g_isf_o.* = g_isf.*
 
   DISPLAY BY NAME g_isf.isf01,g_isf.isf02,
                   #FUN-B50039-add-str--
                   g_isf.isfud01,g_isf.isfud02,g_isf.isfud03,
                   g_isf.isfud04,g_isf.isfud05,g_isf.isfud06,
                   g_isf.isfud07,g_isf.isfud08,g_isf.isfud09,
                   g_isf.isfud10,g_isf.isfud11,g_isf.isfud12,
                   g_isf.isfud13,g_isf.isfud14,g_isf.isfud15
                   #FUN-B50039-add-end--
                   
   WHILE TRUE
      CALL s010_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_isf.* = g_isf_t.*
         CALL s010_show()
         EXIT WHILE
      END IF
 
      UPDATE isf_file SET isf01 = g_isf.isf01,
                          isf02 = g_isf.isf02,
                          #FUN-B50039-add-str--
                          isfud01 = g_isf.isfud01,
                          isfud02 = g_isf.isfud02,
                          isfud03 = g_isf.isfud03,
                          isfud04 = g_isf.isfud04,
                          isfud05 = g_isf.isfud05,
                          isfud06 = g_isf.isfud06,
                          isfud07 = g_isf.isfud07,
                          isfud08 = g_isf.isfud08,
                          isfud09 = g_isf.isfud09,
                          isfud10 = g_isf.isfud10,
                          isfud11 = g_isf.isfud11,
                          isfud12 = g_isf.isfud12,
                          isfud13 = g_isf.isfud13,
                          isfud14 = g_isf.isfud14,
                          isfud15 = g_isf.isfud15
                          #FUN-B50039-add-end--
       WHERE isf00='0'
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660146
         CALL cl_err3("upd","isf_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660146
         CONTINUE WHILE
      END IF
 
      CLOSE isf_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION s010_i()
   DEFINE l_aza LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
          l_cmd LIKE type_file.chr50     #NO FUN-690009 VARCHAR(50)
 
   INPUT BY NAME g_isf.isf01,g_isf.isf02,
                 #FUN-B50039-add-str--
                 g_isf.isfud01,g_isf.isfud02,g_isf.isfud03,
                 g_isf.isfud04,g_isf.isfud05,g_isf.isfud06,
                 g_isf.isfud07,g_isf.isfud08,g_isf.isfud09,
                 g_isf.isfud10,g_isf.isfud11,g_isf.isfud12,
                 g_isf.isfud13,g_isf.isfud14,g_isf.isfud15
                 #FUN-B50039-add-end--
      WITHOUT DEFAULTS 
 
      AFTER FIELD isf01
         IF NOT cl_null(g_isf.isf01) THEN 
            IF g_isf.isf01 NOT MATCHES '[YN]' THEN
               LET g_isf.isf01=g_isf_o.isf01
               DISPLAY BY NAME g_isf.isf01
               NEXT FIELD isf01
            END IF
            LET g_isf_o.isf01=g_isf.isf01
         END IF
      #FUN-B50039-add-str--
      AFTER FIELD isfud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD isfud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
 
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
 
