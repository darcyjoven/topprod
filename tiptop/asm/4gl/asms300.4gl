# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: asms300.4gl
# Descriptions...: 多工廠環境控制參數設定
# Modify.........: No.FUN-790025 07/10/24 By dxfwo 
# Modify.........: No.FUN-930164 09/04/15 By jamie update pjz01~pjz05成功時，寫入azo_file
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-790025---Begin
DEFINE g_pjz        RECORD LIKE pjz_file.*,
       g_pjz_t      RECORD LIKE pjz_file.*,
       g_pjz01_t    LIKE pjz_file.pjz01,
       g_pjz02_t    LIKE pjz_file.pjz02,
       g_pjz03_t    LIKE pjz_file.pjz03,
       g_pjz04_t    LIKE pjz_file.pjz04,
       g_pjz05_t    LIKE pjz_file.pjz05    #MOD-580121
      #g_pjz_rowid  LIKE type_file.chr18    #FUN_930164 mark
 
DEFINE g_forupd_sql STRING                  #MOD-580121   
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680102 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #FUN-930164 add
DEFINE g_flag_01           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_02           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_03           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_04           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_05           LIKE type_file.chr1    #FUN-930164 add
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0081
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
   LET p_row = 5 LET p_col = 25
   OPEN WINDOW s300_w AT p_row,p_col WITH FORM "asm/42f/asms300"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
#   IF  g_aza.aza08 <> 'Y' THEN EXIT PROGRAM END IF 
 
   CALL cl_ui_init()
   INITIALIZE g_pjz.* TO NULL
 
   CALL s300_show()
 
   LET g_action_choice=""
   CALL s300_menu()
 
   CLOSE WINDOW s300_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043 
END MAIN
 
FUNCTION s300_show()
#   MESSAGE ""                                                                                                                      
#   CLEAR FORM                                   # 清螢墓欄位內容                                                                   
#   LET g_pjz01_t = NULL                                                                                                            
#   LET g_pjz02_t = NULL                                                                                                            
#   LET g_pjz03_t = NULL                                                                                                            
#   LET g_pjz04_t = NULL                                                                                                            
#   LET g_pjz05_t = NULL                                       
   SELECT * INTO g_pjz.* FROM pjz_file   #WHERE pjz01='0'
 
#  IF SQLCA.sqlcode OR cl_null(g_pjz.pjz01) THEN
#     IF SQLCA.sqlcode=-284 THEN
#        CALL cl_err("ERROR!!",SQLCA.SQLCODE,1)   
#        DELETE FROM pjz_file
#     END IF
 #    LET g_pjz.pjz01 = "0" 
 #    LET g_pjz.pjz02 = "Y"          
 #    LET g_pjz.pjz03 = "DEMO-1" 
 #    LET g_pjz.pjz04 = "ds"
 #     LET g_pjz.pjz05 = "N"           #MOD-580121
#
#     INSERT INTO pjz_file VALUES (g_pjz.*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","pjz_file",g_pjz.pjz01,"",SQLCA.sqlcode,"","I",0)    #No.FUN-660131
#        RETURN
#     END IF
#  END IF
 
#   DISPLAY BY NAME g_pjz.pjz01,g_pjz.pjz02,g_pjz.pjz03,g_pjz.pjz04,  #MOD-430075
#                   g_pjz.pjz05                           #MOD-580121 
    LET g_pjz_t.* = g_pjz.*                
    #No.FUN-9A0024--begin     
    #DISPLAY BY NAME g_pjz.*                
    DISPLAY BY NAME g_pjz.pjz01,g_pjz.pjz02,g_pjz.pjz03,g_pjz.pjz04,g_pjz.pjz05                
    #No.FUN-9A0024--end                                                                                                                
    CALL cl_show_fld_cont() 
 
END FUNCTION
 
FUNCTION s300_menu()
 
    MENU ""
       ON ACTION modify 
#NO.FUN-5B0134 START--
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
              CALL s300_u()
          END IF
#NO.FUN-5B0134 END---
       ON ACTION help 
          CALL cl_show_help()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
 
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
 
FUNCTION s300_a()                                                                                                                   
    MESSAGE ""                                                                                                                      
    CLEAR FORM                                   # 清螢墓欄位內容                                                                   
    INITIALIZE g_pjz.* LIKE pjz_file.*                                                                                              
    LET g_pjz01_t = NULL                                                                                                            
    LET g_pjz02_t = NULL                                                                                                            
    LET g_pjz03_t = NULL                                                                                                            
    LET g_pjz04_t = NULL                                                                                                            
    LET g_pjz05_t = NULL                                                                                                            
#   LET g_wc = NULL                                                                                                                 
    CALL cl_opmsg('a')                                                                                                              
 
    WHILE TRUE                                                                                                                      
        CALL s300_i()                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵                                                                      
            INITIALIZE g_pjz.* TO NULL                                                                                              
            LET INT_FLAG = 0                                                                                                        
            CALL cl_err('',9001,0)                                                                                                  
            CLEAR FORM                                                                                                              
            EXIT WHILE                                                                                                              
        END IF                                                                                                                      
        IF g_pjz.pjz01 IS NULL THEN              # KEY 不可空白                                                                     
            CONTINUE WHILE                                                                                                          
        END IF                                                                                                                      
        INSERT INTO pjz_file VALUES(g_pjz.*)     # DISK WRITE                                                                       
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err3("ins","pjz_file",g_pjz.pjz01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131                                    
            CONTINUE WHILE                                                                                                          
        ELSE                                                                                                                        
#           SELECT rowid INTO g_pjz_rowid FROM pjz_file                                                                             
#                    WHERE pjz01 = g_pjz.pjz01                                                                                      
        END IF                                 
        EXIT WHILE                                                                                                                  
    END WHILE                                                                                                                       
#   LET g_wc=' '                                                                                                                    
END FUNCTION    
 
FUNCTION s300_u()
   DEFINE   l_n1  LIKE type_file.num5          
 
   SELECT COUNT(*) INTO l_n1 FROM pjz_file     
     IF l_n1 = 0 THEN 
        CALL s300_a()  
      ELSE 
     END IF
     IF l_n1 = 1 THEN 
   MESSAGE ""
   LET g_pjz_t.*=g_pjz.*
   LET g_pjz01_t=g_pjz.pjz01
   LET g_pjz02_t=g_pjz.pjz02
   LET g_pjz03_t=g_pjz.pjz03
   LET g_pjz04_t=g_pjz.pjz04
   LET g_pjz05_t=g_pjz.pjz05  #MOD-580121
 
 
   LET g_forupd_sql = "SELECT * FROM pjz_file  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE pjz_cl CURSOR FROM g_forupd_sql
  
   BEGIN WORK
   OPEN pjz_cl
   IF STATUS THEN
      CALL cl_err('OPEN pjz_curl',STATUS,1)
      RETURN
   END IF
   FETCH pjz_cl INTO g_pjz.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FETCH pjz_curl',SQLCA.sqlcode,1)
      RETURN
   END IF
   #No.FUN-9A0024--begin     
   #DISPLAY BY NAME g_pjz.*                
   DISPLAY BY NAME g_pjz.pjz01,g_pjz.pjz02,g_pjz.pjz03,g_pjz.pjz04,g_pjz.pjz05                
   #No.FUN-9A0024--end    
   
   WHILE TRUE
      CALL s300_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pjz.*=g_pjz_t.* 
         CALL s300_show()
         EXIT WHILE
      END IF
      UPDATE pjz_file SET pjz_file.*=g_pjz.* 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","pjz_file",g_pjz.pjz01,"",SQLCA.sqlcode,"","UPD pjz",1)    #No.FUN-660131
         CONTINUE WHILE
     #FUN-930164---add---str---
      ELSE 
         IF g_flag_01='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_pjz_t.pjz01,' new:',g_pjz.pjz01
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
               VALUES ('asms300',g_user,g_today,g_errno,'pjz01',g_msg,g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","asms300","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
         IF g_flag_02='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_pjz_t.pjz02,' new:',g_pjz.pjz02
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
               VALUES ('asms300',g_user,g_today,g_errno,'pjz02',g_msg,g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","asms300","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
         IF g_flag_03='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_pjz_t.pjz03,' new:',g_pjz.pjz03
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
               VALUES ('asms300',g_user,g_today,g_errno,'pjz03',g_msg,g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","asms300","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
         IF g_flag_04='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_pjz_t.pjz04,' new:',g_pjz.pjz04
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
               VALUES ('asms300',g_user,g_today,g_errno,'pjz04',g_msg,g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","asms300","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
         IF g_flag_05='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_pjz_t.pjz05,' new:',g_pjz.pjz05
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
               VALUES ('asms300',g_user,g_today,g_errno,'pjz05',g_msg,g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","asms300","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
     #FUN-930164---add---end---
      END IF
      EXIT WHILE
   END WHILE
   CLOSE pjz_cl
   COMMIT WORK
END IF
END FUNCTION
 
FUNCTION s300_i()
    DEFINE   l_n  LIKE type_file.num5          
 
    INPUT BY NAME g_pjz.pjz01,g_pjz.pjz02,g_pjz.pjz03,g_pjz.pjz04,  #MOD-430075
                 g_pjz.pjz05
       WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s300_set_entry()
         CALL s300_set_no_entry()
         CALL s300_set_required()
         CALL s300_set_no_required()
         LET g_before_input_done = TRUE
         LET g_flag_01='N'     #FUN-930164 add
         LET g_flag_02='N'     #FUN-930164 add
         LET g_flag_03='N'     #FUN-930164 add
         LET g_flag_04='N'     #FUN-930164 add
         LET g_flag_05='N'     #FUN-930164 add
 
      AFTER FIELD pjz01          #MOD-490330                                                                                        
#     LET l_n = length(g_pjz.pjz01 CLIPPED )                                                                                         
       IF g_pjz.pjz01 > 6 OR g_pjz.pjz01 < = 0 THEN                                                                                                             
        CALL cl_err('','asm-111',1)                                                                                                   
          NEXT FIELD pjz01                                                                                                          
        ELSE  
        END IF
      #FUN-930164---add---str---
       IF g_pjz.pjz01 <> g_pjz_t.pjz01 THEN 
          LET g_flag_01='Y'
       END IF
      #FUN-930164---add---end---
 
      AFTER FIELD pjz02
#     LET l_n = length(g_pjz.pjz02 CLIPPED )
       IF g_pjz.pjz02 > 4 OR g_pjz.pjz02 < = 0 THEN 
        CALL cl_err('','asm-222',1)       
          NEXT FIELD pjz02
        ELSE  
       END IF
      #FUN-930164---add---str---
       IF g_pjz.pjz02 <> g_pjz_t.pjz02 THEN 
          LET g_flag_02='Y'
       END IF
      #FUN-930164---add---end---
 
      AFTER FIELD pjz03          #MOD-490330
#     LET l_n = length(g_pjz.pjz03 CLIPPED )                                                                                         
       IF g_pjz.pjz03 > 10 OR g_pjz.pjz03 < = 0 THEN                                                                                                              
        CALL cl_err('','asm-112',1)                                                                                                   
          NEXT FIELD pjz03
        ELSE  
        END IF
      #FUN-930164---add---str---
       IF g_pjz.pjz03 <> g_pjz_t.pjz03 THEN 
          LET g_flag_03='Y'
       END IF
      #FUN-930164---add---end---
 
      AFTER FIELD pjz04          #MOD-490330                                                                                        
#     LET l_n = length(g_pjz.pjz04 CLIPPED )                                                                                         
       IF g_pjz.pjz04 > 10 OR g_pjz.pjz04 < = 0 THEN                                                                                                              
        CALL cl_err('','asm-112',1)                                                                                                   
          NEXT FIELD pjz04                                                                                                          
        ELSE  
        END IF
      #FUN-930164---add---str---
       IF g_pjz.pjz04 <> g_pjz_t.pjz04 THEN 
          LET g_flag_04='Y'
       END IF
      #FUN-930164---add---end---
 
      AFTER FIELD pjz05          #MOD-490330                                                                                        
#     LET l_n = length(g_pjz.pjz05  CLIPPED )                                                                                         
       IF g_pjz.pjz05 > 4 OR g_pjz.pjz05 < = 0 THEN                                                                                                             
        CALL cl_err('','asm-222',1)                                                                                                   
          NEXT FIELD pjz05                                                                                                          
        ELSE   
        END IF
      #FUN-930164---add---str---
       IF g_pjz.pjz05 <> g_pjz_t.pjz05 THEN 
          LET g_flag_05='Y'
       END IF
      #FUN-930164---add---end---
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION
 
 
FUNCTION s300_set_entry()
 
END FUNCTION
 
FUNCTION s300_set_no_entry()
END FUNCTION
 
 
FUNCTION s300_set_required()
 
END FUNCTION
 
FUNCTION s300_set_no_required()
 
END FUNCTION
#No.FUN-790025---End
