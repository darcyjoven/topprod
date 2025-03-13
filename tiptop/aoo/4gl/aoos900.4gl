# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aoos900.4gl
# Descriptions...: 多工廠環境控制參數設定
# Date & Author..: 92/08/28 By Roger
# Modify.........: No.MOD-490075 04/09/16 By Yuna azz01畫面顯示欄位拿掉
# Modify.........: No.MOD-490330 04/10/04 By Nicola 預設工廠開窗並檢查資料
# Modify.........: No.MOD-580121 05/08/18 By alex 增加時區設定作業 azz05
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-910114 09/01/22 By alex dbuser passwd encode
# Modify.........: No.FUN-920134 09/02/18 By alex 移除FUN-910114
# Modify.........: No.FUN-930093 09/03/13 By alex 加回FUN-910114
# Modify.........: No.FUN-930096 09/03/13 By alex 限制只能在2.02.14/2.11.13以上使用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
# Modify.........: No.FUN-B80114 11/08/12 By jrg542 開放GP5.25以後的版本使用DVM 2.3以上版本 
# Modify.........: No.FUN-BB0068 11/11/15 By jrg542  
#                  1.原有aoos010設定執行程式紀錄移入 aoos900 (全系統共用，與aoos010每營運中心設定的方式不同)
#                  2.原有cl_used調整依循 aoos900 設定 (記，不記) 來進行系統執行的 log 紀錄 (default 為記錄)
#                  3.aoos900另開欄位 A.系統使用 unload 指令時是否進行通知 B.若上項為是，則請指定 mail-address
# Modify.........: No:MOD-BC0080 11/12/08 by jrg542 調整dbconnect.ini至DS4GL
# Modify.........: No:MOD-C30897 12/03/29 by yuge77 調整dbconnect.ini至$FGLDIR/etc,並更名為dbconnect.prod/test/std
# Modify.........: No:FUN-C40086 12/05/02 by kevin 加入啟動 web service 傳送資安欄位選項
# Modify.........: No:FUN-C40105 12/05/08 by madey 加入啟用外部日誌(log機)
# Modify.........: No:FUN-CA0016 12/07/27 By joyce 調整啟用unload指令時輸入系統管理者e-mail部分

IMPORT os 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_azz        RECORD LIKE azz_file.*,
       g_azz_t      RECORD LIKE azz_file.*,
       g_azz02_t    LIKE azz_file.azz02,
       g_azz03_t    LIKE azz_file.azz03,
       g_azz04_t    LIKE azz_file.azz04,
       g_azz05_t    LIKE azz_file.azz05,   #MOD-580121
       g_azz06_t    LIKE azz_file.azz06,   #FUN-910114
       g_azz11_t    LIKE azz_file.azz11,   #No.FUN-BB0068 啟用程式執行紀錄
       g_azz12_t    LIKE azz_file.azz12,   #No.FUN-BB0068 Uload Inform 設定(Unload指令 通知系統管理者 )
       g_azz13_t    LIKE azz_file.azz13,   #No.FUN-BB0068 E-mail
       g_azz14_t    LIKE azz_file.azz14,   #No.FUN-BB0068 Action Log   設定(Action 紀錄與否 ) 
       g_azz15_t    LIKE azz_file.azz15,   #No.FUN-BB0068 附件異動紀錄
       g_azz16_t    LIKE azz_file.azz16,   #No.FUN-BB0068 外寄信件是否加警語
       g_azz17_t    LIKE azz_file.azz17    #No.FUN-BB0068 是否UI遮罩

DEFINE g_forupd_sql STRING                 #MOD-580121   
DEFINE g_before_input_done  LIKE type_file.num5 

DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-BB0068 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   OPEN WINDOW s900_w WITH FORM "aoo/42f/aoos900"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL s900_show()
   LET g_action_choice=""
   CALL s900_menu()
   CLOSE WINDOW s900_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION s900_show()
 
   SELECT * INTO g_azz.* FROM azz_file WHERE azz01='0'
 
   IF SQLCA.sqlcode OR cl_null(g_azz.azz01) THEN
      IF SQLCA.sqlcode=-284 THEN
         CALL cl_err("ERROR!!",SQLCA.SQLCODE,1)   
         DELETE FROM azz_file
      END IF
      LET g_azz.azz01 = "0" 
      LET g_azz.azz02 = "Y"          
      LET g_azz.azz03 = "DEMO-1" 
      LET g_azz.azz04 = "ds"
      LET g_azz.azz05 = "N"           #MOD-580121
      LET g_azz.azz06 = "N"           #FUN-910114
       
      LET g_azz.azz11 = "3"           #FUN-BB0068
      LET g_azz.azz12 = "N"           #FUN-BB0068
      LET g_azz.azz13 = ""            #FUN-BB0068
      LET g_azz.azz14 = "2"           #FUN-BB0068
      LET g_azz.azz15 = "2"           #FUN-BB0068
      LET g_azz.azz16 = "N"           #FUN-BB0068
      LET g_azz.azz17 = "N"           #FUN-BB0068
      LET g_azz.azz18 = "N"           #FUN-C40086
      LET g_azz.azz19 = "N"           #FUN-C40105

      INSERT INTO azz_file VALUES (g_azz.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err('I',SQLCA.sqlcode,0)   #No.FUN-660131
         CALL cl_err3("ins","azz_file",g_azz.azz01,"",SQLCA.sqlcode,"","I",0)    #No.FUN-660131
         RETURN
      END IF
   ELSE
      IF g_azz.azz06 IS NULL OR g_azz.azz06 <> "Y" THEN   #FUN-910114
         LET g_azz.azz06 = "N" 
      END IF
   END IF

   #azz11 log設定(Program Running Log)
   #azz12 Uload Inform 設定(啟用系統 Unload 指令，通知系統管理者 )
   #azz13 E-mial
   #azz14 Action Log   設定(Action 紀錄與否 ) 
   #azz15 附件異動紀錄
   #azz16 外寄信件是否加警語
   #azz17 是否UI遮罩 
   #azz19 啟用外部日誌(log機)
   DISPLAY BY NAME g_azz.azz02,g_azz.azz03,g_azz.azz04,  #MOD-490075
                   g_azz.azz05,g_azz.azz06,g_azz.azz11,g_azz.azz12,g_azz.azz13,g_azz.azz14,g_azz.azz15,
                   g_azz.azz16,g_azz.azz17,g_azz.azz18,g_azz.azz19 #FUN-C40105 #FUN-C40086  #MOD-580121 FUN-910114 #FUN-BB0068 

   IF g_azz.azz16 = 'Y'  THEN
      CALL cl_getmsg('lib-287',g_lang) RETURNING g_msg  #
      DISPLAY g_msg TO msg
   ELSE
      LET g_msg = ""
      DISPLAY g_msg TO msg
   END IF
                                              
END FUNCTION
 
FUNCTION s900_menu()
 
    MENU ""
       ON ACTION modify 
#NO.FUN-5B0134 START--
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
              CALL s900_u()
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
          LET INT_FLAG=FALSE    #MOD-570244
          LET g_action_choice = "exit"
          EXIT MENU
 
    END MENU
 
END FUNCTION
 
FUNCTION s900_u()
 
   MESSAGE ""
   LET g_azz_t.*=g_azz.*
   LET g_azz02_t=g_azz.azz02
   LET g_azz03_t=g_azz.azz03
   LET g_azz04_t=g_azz.azz04
   LET g_azz05_t=g_azz.azz05  #MOD-580121
   LET g_azz06_t=g_azz.azz06  #FUN-910114
   LET g_azz11_t=g_azz.azz11  #No.FUN-BB0068 log設定(Program Running Log) 
   LET g_azz12_t=g_azz.azz12  #No.FUN-BB0068 
   LET g_azz13_t=g_azz.azz13  #No.FUN-BB0068 
   LET g_azz14_t=g_azz.azz14  #No.FUN-BB0068
   LET g_azz15_t=g_azz.azz15  #No.FUN-BB0068
   LET g_azz16_t=g_azz.azz16  #No.FUN-BB0068
   LET g_azz17_t=g_azz.azz17  #No.FUN-BB0068

 
   LET g_forupd_sql = "SELECT * FROM azz_file WHERE azz01='0' FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE azz_cl CURSOR FROM g_forupd_sql
  
   BEGIN WORK
   OPEN azz_cl
   IF STATUS THEN
      CALL cl_err('OPEN azz_curl',STATUS,1)
      RETURN
   END IF
   FETCH azz_cl INTO g_azz.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FETCH azz_curl',SQLCA.sqlcode,1)
      RETURN
   ELSE
      IF g_azz.azz06 IS NULL OR g_azz.azz06 <> "Y" THEN   #FUN-910114
         LET g_azz.azz06 = "N" 
      END IF
   END IF
   #No.FUN-9A0024--begin 
   #DISPLAY BY NAME g_azz.*
   DISPLAY BY NAME g_azz.azz02,g_azz.azz03,g_azz.azz04,                                                                  
                   g_azz.azz05,g_azz.azz06 #No.FUN-9A0024--end     
                   ,g_azz.azz11,g_azz.azz12,g_azz.azz13,g_azz.azz14,g_azz.azz15,
                   g_azz.azz16,g_azz.azz17,g_azz.azz18,g_azz.azz19 #FUN-C40105  #FUN-C40086   #No.FUN-BB0068
                     
   WHILE TRUE
      CALL s900_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      UPDATE azz_file SET azz_file.*=g_azz.* 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('UPD azz',SQLCA.sqlcode,1)   #No.FUN-660131
         CALL cl_err3("upd","azz_file",g_azz.azz01,"",SQLCA.sqlcode,"","UPD azz",1)    #No.FUN-660131
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE azz_cl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION s900_i()
 
    DEFINE ls_temp   STRING
    DEFINE li_temp   LIKE type_file.num5
    DEFINE ld_temp   DECIMAL(5,2) #FUN-B80114
    DEFINE ls_temp2  STRING       #FUN-B80114 

    DEFINE ls_str STRING        #No.FUN-BB0068 

    INPUT BY NAME g_azz.azz02,g_azz.azz06,g_azz.azz03,                          #MOD-490075
                  g_azz.azz04,g_azz.azz05               #FUN-910114
                  ,g_azz.azz11,g_azz.azz12,g_azz.azz13,g_azz.azz14,g_azz.azz15,
                   g_azz.azz16,g_azz.azz17,g_azz.azz18,g_azz.azz19 #FUN-C40105 #FUN-C40086  #No.FUN-BB0068  
       WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s900_set_entry()
         CALL s900_set_no_entry()
         CALL s900_set_required()
         CALL s900_set_no_required()
         LET g_before_input_done = TRUE

         CALL cl_set_comp_entry("azz13",FALSE)        #No.FUN-BB0068
#     AFTER FIELD azz02
#        IF NOT cl_null(g_azz.azz02) THEN
#           LET g_azz02_t=g_azz.azz02
#           IF g_azz.azz02 = 'Y' THEN                  #MOD-580121
#              LET g_azz.azz03 = ''
#              LET g_azz.azz04 = ''
#              DISPLAY BY NAME g_azz.azz03,g_azz.azz04
#           END IF
#        END IF
 
      ON CHANGE azz02
         IF g_azz.azz02 = "Y" THEN
            CALL s900_set_no_required()
            CALL s900_set_no_entry()
         ELSE
            CALL s900_set_entry()
            CALL s900_set_required()
         END IF
 
      AFTER FIELD azz03          #MOD-490330
        IF NOT cl_null(g_azz.azz03) THEN
           SELECT azp03 INTO g_azz.azz04 FROM azp_file
            WHERE azp01 = g_azz.azz03
           IF STATUS THEN
              NEXT FIELD azz03
           ELSE
              LET g_azz03_t=g_azz.azz03
              LET g_azz04_t=g_azz.azz04                     #MOD-580121
              DISPLAY g_azz.azz04 TO azz04
           END IF
        END IF
 
       AFTER FIELD azz06     #FUN-910114
          IF g_azz.azz06 = "Y" THEN
             #查資料庫形態, INFORMIX不需設定
             IF cl_db_get_database_type() = "IFX" THEN
                CALL cl_err("","azz-880",1)    #FUN-930093
                LET g_azz.azz06 = "N"
                DISPLAY BY NAME g_azz.azz06
                NEXT FIELD azz06
             END IF
 
             #查DVM版本是否已達 2.02.14 / 2.11.13
             LET ls_temp = cl_get_dvm_version()    #ex 2.32.03 
             LET ls_temp = ls_temp.trim()
             LET ls_temp2 = ls_temp.subString(1,4) #FUN-B80114 
             LET ld_temp = ls_temp2                #FUN-B80114  
               
             #FUN-B80114 --start 
             CASE 
                WHEN ld_temp > 2.11                  #do nothing,it's ok
                WHEN ld_temp = 2.11
                   LET li_temp = ls_temp.subString(ls_temp.getIndexOf("2.11.",1)+5,ls_temp.getLength())
                   IF li_temp < 13 THEN
                      CALL cl_err("","azz-876",1)    #FUN-930096
                      LET g_azz.azz06 = "N"
                      DISPLAY BY NAME g_azz.azz06
                      NEXT FIELD azz06
                   END IF
                WHEN ld_temp = 2.02  
                   LET li_temp = ls_temp.subString(ls_temp.getIndexOf("2.02.",1)+5,ls_temp.getLength())
                   IF li_temp < 14 THEN
                      CALL cl_err("","azz-876",1)    #FUN-930096
                      LET g_azz.azz06 = "N"
                      DISPLAY BY NAME g_azz.azz06
                      NEXT FIELD azz06
                   END IF
                OTHERWISE          
                   CALL cl_err("","azz-876",1)       #FUN-930096
                   LET g_azz.azz06 = "N"
                   DISPLAY BY NAME g_azz.azz06
                   NEXT FIELD azz06
             END CASE
             
             # 
             #CASE ls_temp
             #   WHEN ls_temp.getIndexOf("2.2",1)   #do nothing,it's ok
             #   WHEN ls_temp.getIndexOf("2.2",1)   #do nothing,it's ok
             #   WHEN ls_temp.getIndexOf("2.11.",1)
             #      LET li_temp = ls_temp.subString(ls_temp.getIndexOf("2.11.",1)+5,ls_temp.getLength())
             #      IF li_temp < 13 THEN
             #         CALL cl_err("","azz-876",1)    #FUN-930096
             #         LET g_azz.azz06 = "N"
             #         DISPLAY BY NAME g_azz.azz06
             #         NEXT FIELD azz06
             #      END IF
             #   WHEN ls_temp.getIndexOf("2.02.",1)
             #      LET li_temp = ls_temp.subString(ls_temp.getIndexOf("2.02.",1)+5,ls_temp.getLength())
             #      IF li_temp < 14 THEN
             #         CALL cl_err("","azz-876",1)    #FUN-930096
             #         LET g_azz.azz06 = "N"
             #         DISPLAY BY NAME g_azz.azz06
             #         NEXT FIELD azz06
             #      END IF
             #   OTHERWISE
             #      CALL cl_err("","azz-876",1)    #FUN-930096
             #      LET g_azz.azz06 = "N"
             #      DISPLAY BY NAME g_azz.azz06
             #      NEXT FIELD azz06
             #END CASE
             #FUN-B80114 --END

             #要求 FGLPROFILE 要先調整好再來設定
             LET ls_temp = FGL_getResource("dbi.default.userauth.callback")
             #IF ls_temp IS NULL OR ls_temp <> "azz_p_callback.p_callback" THEN #No:MOD-BC0080 
             IF ls_temp IS NULL OR ls_temp <> "lib_cl_callback.cl_callback" THEN
                CALL cl_err("","azz-879",1)
                LET g_azz.azz06 = "N"
                DISPLAY BY NAME g_azz.azz06
                NEXT FIELD azz06
             END IF
          END IF
          #若需還原
          IF g_azz06_t = "Y" AND g_azz.azz06 = "N" THEN
             LET ls_temp = FGL_getResource("dbi.default.userauth.callback")
             IF ls_temp.trim() IS NOT NULL THEN
                CALL cl_err("","azz-878",1)
                LET g_azz.azz06 = "Y"
                DISPLAY BY NAME g_azz.azz06
                NEXT FIELD azz06
             ELSE
                #檢視該編碼檔案是否已移除
                IF NOT s900_azz06_remove() THEN
                   LET g_azz.azz06 = "Y"
                   DISPLAY BY NAME g_azz.azz06
                   NEXT FIELD azz06
                END IF
             END IF
          END IF
      
      #No.FUN-BB0068 start 
      AFTER FIELD azz12    #啟用Unload指令
         IF g_azz.azz12 = 'Y'  THEN
            CALL cl_set_comp_entry("azz13",TRUE)
            NEXT FIELD azz13
         ELSE
            CALL cl_set_comp_entry("azz13",FALSE) 
            LET g_azz.azz13 = ""
            DISPLAY BY NAME g_azz.azz13
         END IF

      AFTER FIELD azz13   #e-mail address
         IF cl_null(g_azz.azz13) THEN 
            CALL cl_err("","anm-124",1)   # No:FUN-CA0016
            NEXT FIELD azz12
         END IF 
         
         LET ls_str = g_azz.azz13
      #  IF NOT ls_str MATCHES "[@]" THEN
         IF ls_str.getIndexOf('@',1) < 1  THEN   # No:FUN-CA0016
            CALL cl_err("","azz1158",1)
            NEXT FIELD azz13
         END IF 
                
       AFTER FIELD azz16    #外寄信件加警語
         IF g_azz.azz16 = 'Y'  THEN
            CALL cl_getmsg('lib-287',g_lang) RETURNING g_msg
            DISPLAY g_msg TO msg
         ELSE
            LET g_msg = "" 
            DISPLAY g_msg TO msg   
         END IF

      # No:FUN-CA0016 ---start---
      ON CHANGE azz12    #啟用Unload指令
         IF g_azz.azz12 = 'Y'  THEN
            CALL cl_set_comp_entry("azz13",TRUE)
         ELSE
            CALL cl_set_comp_entry("azz13",FALSE) 
            LET g_azz.azz13 = ""
            DISPLAY BY NAME g_azz.azz13
         END IF
         NEXT FIELD azz12
      # No:FUN-CA0016 --- end ---

      #No.FUN-BB0068 end ---
      ON ACTION CONTROLP    #MOD-490330
         CASE
            WHEN INFIELD(azz03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_azz.azz03
               CALL cl_create_qry() RETURNING g_azz.azz03
               SELECT azp03 INTO g_azz.azz04 FROM azp_file
                WHERE azp01 = g_azz.azz03
               DISPLAY BY NAME g_azz.azz03,g_azz.azz04
               NEXT FIELD azz03
         END CASE
 
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
 
#檢視該編碼檔案是否已移除
FUNCTION s900_azz06_remove() 
 
   DEFINE ls_cbakpath  STRING
 
   #組出密碼檔位置
   #LET ls_cbakpath = os.Path.join(FGL_GETENV("TOP"),"bin") # MOD-C30897 mark
   #LET ls_cbakpath = os.Path.join(ls_cbakpath.trim(),"dbconnect.ini") # MOD-C30897 mark
   LET ls_cbakpath = FGL_GETENV("CALLBACKFILE") # MOD-C30897
   LET ls_cbakpath = ls_cbakpath.trim()         # MOD-C30897
 
   IF os.Path.exists(ls_cbakpath) THEN
      CALL cl_err("","azz-877",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
 
END FUNCTION
 
 
 
FUNCTION s900_set_entry()
 
   IF INFIELD(azz02) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("azz03",TRUE)
   END IF

   
END FUNCTION
 
FUNCTION s900_set_no_entry()
 
   IF INFIELD(azz02) OR (NOT g_before_input_done) THEN
      IF g_azz.azz02 = "Y" THEN
         CALL cl_set_comp_entry("azz03",FALSE)
      END IF
   END IF

   
END FUNCTION
 
 
FUNCTION s900_set_required()
 
   IF INFIELD(azz02) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_required("azz03",TRUE)
   END IF
   
END FUNCTION
 
FUNCTION s900_set_no_required()
   
   IF INFIELD(azz02) OR (NOT g_before_input_done) THEN
      IF g_azz.azz02 = "Y" THEN
         CALL cl_set_comp_required("azz03",FALSE)
      END IF
   END IF
   
END FUNCTION    #FUN-920134
