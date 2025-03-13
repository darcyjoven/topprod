# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arts100.4gl
# Descriptions...: 系統參數設定作業-流通零售參數
# Date & Author..: No.FUN-B50007 11/05/06 By huangtao
# Modify.........: No.FUN-B50039 11/07/08 By fengrui 增加自定義欄位
# Modify.........: No.FUN-BA0097 11/12/12 By nanbing 增加券管理頁簽
# Modify.........: No.FUN-BC0079 11/12/21 By yuhuabao 零售參數增加會員管理頁籤，維護會員生日代碼
# Modify.........: No.FUN-C10051 12/02/03 By chenwei 加入“卡管理”頁簽
# Modify.........: No.TQC-C30197 12/03/20 By SunLM 修正錯誤提示,'aoo-403'--->'1307'
# Modify.........: No.FUN-C40018 12/04/16 By pauline 增加rcj07 卡退款理由碼
# Modify.........: No.FUN-C30176 12/06/14 By pauline 增加rcj08 換卡理由碼
# Modify.........: No.FUN-C60032 12/06/28 By Lori 檢查lpc05 = 'Y' 才允許修改會員紀念日資料
# Modify.........: No.FUN-C80072 12/08/24 By nanbing 增加rcj09 配送自動完成否
# Modify.........: No.FUN-CB0116 12/11/24 By huangrh增加rcj10,rcj11
# Modify.........: No.FUN-CB0104 12/12/06 By xumeimei增加rcj12
# Modify.........: No.FUN-D20020 13/02/06 By dongsz 添加POS管理頁簽
# Modify.........: No.FUN-D30093 13/03/27 By dongsz rcj13有異動時，提示是否更新方案資料的有效碼和已傳POS否欄位
# Modify.........: No:FUN-C30180 13/04/08 By Sakura arts100 增加rcj16欄位,使用會員升等/降等否 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  g_rcj       RECORD LIKE rcj_file.*   
DEFINE  g_rcj_t     RECORD LIKE rcj_file.*
DEFINE  g_rcj01_t   LIKE rcj_file.rcj01
DEFINE  g_forupd_sql STRING
DEFINE  g_before_input_done LIKE type_file.num5

        
MAIN
    OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   
    SELECT * INTO g_rcj.* FROM rcj_file WHERE rcj00 = '0'
    IF SQLCA.sqlcode OR g_rcj.rcj00 IS NULL OR g_rcj.rcj00=' 'THEN
        LET g_rcj.rcj00 = "0"    
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW s100_w WITH FORM "art/42f/arts100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

     CALL s100_show()

      LET g_action_choice=""
      CALL s100_menu()

    CLOSE WINDOW s100_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION s100_show()

  SELECT * INTO g_rcj.* FROM rcj_file
     WHERE rcj00='0'
   IF SQLCA.sqlcode OR g_rcj.rcj00 IS NULL THEN

     IF SQLCA.sqlcode=-284 THEN
        CALL cl_err3("sel","rcj_file",g_rcj.rcj00,"",SQLCA.SQLCODE,"","ERROR!",1)  
        DELETE FROM rcj_file
     END IF
     LET g_rcj.rcj00 = '0'
     LET g_rcj.rcj01 = g_today
     LET g_rcj.rcj03 = '2'  #FUN-BA0097 add
     LET g_rcj.rcj04 = ' '  #FUN-BC0079 add
     LET g_rcj.rcj16 = 'N'  #FUN-C30180 add 
     LET g_rcj.rcj09 = 'N'  #FUN-C80072 add
     LET g_rcj.rcj11 = 'Y'  #FUN-CB0116 add
     LET g_rcj.rcj10 = 180  #FUN-CB0116 add
     LET g_rcj.rcj12 = '1'  #FUN-CB0104 add
     LET g_rcj.rcj13 = '1'  #FUN-D20020 add
     LET g_rcj.rcj14 = 1    #FUN-D20020 add
     LET g_rcj.rcj15 = 99   #FUN-D20020 add
     INSERT INTO rcj_file VALUES (g_rcj.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rcj_file",g_rcj.rcj01,"",SQLCA.sqlcode,"","I",0)   #No.FUN-660131
        RETURN
     END IF
   END IF
   CALL s100_rcj04()                        #FUN-BC0079 add
   DISPLAY BY NAME g_rcj.rcj01,
                   g_rcj.rcj02,g_rcj.rcj03, #FUN-BA0097 add 
                   g_rcj.rcj04,             #FUN-BC0079 add
                   g_rcj.rcj16,             #FUN-C30180 add 
                   g_rcj.rcj05,g_rcj.rcj06, #FUN-C10051 add
                   g_rcj.rcj07,             #FUN-C40018 add  
                   g_rcj.rcj08,             #FUN-C30176 add
                   g_rcj.rcj09,             #FUN-C80072 add
                   g_rcj.rcj10,             #FUN-CB0116 add
                   g_rcj.rcj11,             #FUN-CB0116 add
                   g_rcj.rcj12,             #FUN-CB0104 add
                   g_rcj.rcj13,             #FUN-D20020 add
                   g_rcj.rcj14,             #FUN-D20020 add
                   g_rcj.rcj15,             #FUN-D20020 add
                   #FUN-B50039-add-str--
                   g_rcj.rcjud01,g_rcj.rcjud02,g_rcj.rcjud03,g_rcj.rcjud04,g_rcj.rcjud05,
                   g_rcj.rcjud06,g_rcj.rcjud07,g_rcj.rcjud08,g_rcj.rcjud09,g_rcj.rcjud10,
                   g_rcj.rcjud11,g_rcj.rcjud12,g_rcj.rcjud13,g_rcj.rcjud14,g_rcj.rcjud15
                   #FUN-B50039-add-end--
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

       
    ON ACTION close   
       LET INT_FLAG=FALSE 		
       LET g_action_choice = "exit"
       EXIT MENU

    END MENU
END FUNCTION

FUNCTION s100_u()

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rcj01_t=g_rcj.rcj01
    LET g_forupd_sql = "SELECT * FROM rcj_file FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE rcj_cl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN rcj_cl
    IF STATUS  THEN CALL cl_err('OPEN rcj_curl',STATUS,1) RETURN END IF
    FETCH rcj_cl INTO g_rcj.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_rcj_t.*=g_rcj.*
    DISPLAY BY NAME g_rcj.rcj01,
                    g_rcj.rcj02,g_rcj.rcj03, #FUN-BA0097 add 
                    g_rcj.rcj04,             #FUN-BC0079 add
                    g_rcj.rcj16,             #FUN-C30180 add 
                    g_rcj.rcj05,g_rcj.rcj06, #FUN-C10051 add
                    g_rcj.rcj07,             #FUN-C40018 add
                    g_rcj.rcj08,             #FUN-C30176 add
                    g_rcj.rcj09,             #FUN-C80072 add
                    g_rcj.rcj10,             #FUN-CB0116 add
                    g_rcj.rcj11,             #FUN-CB0116 add
                    g_rcj.rcj12,             #FUN-CB0104 add
                    g_rcj.rcj13,             #FUN-D20020 add
                    g_rcj.rcj14,             #FUN-D20020 add
                    g_rcj.rcj15,             #FUN-D20020 add
                    #FUN-B50039-add-str--
                    g_rcj.rcjud01,g_rcj.rcjud02,g_rcj.rcjud03,g_rcj.rcjud04,g_rcj.rcjud05,
                    g_rcj.rcjud06,g_rcj.rcjud07,g_rcj.rcjud08,g_rcj.rcjud09,g_rcj.rcjud10,
                    g_rcj.rcjud11,g_rcj.rcjud12,g_rcj.rcjud13,g_rcj.rcjud14,g_rcj.rcjud15
                    #FUN-B50039-add-end--
     CALL s100_rcj04()                       #FUN-BC0079 add
     WHILE TRUE
        CALL s100_i()
        IF INT_FLAG THEN
            CALL s100_show()
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
         UPDATE rcj_file
           SET rcj_file.*=g_rcj.*
         EXIT WHILE
     END WHILE
    CLOSE rcj_cl
    COMMIT WORK
END FUNCTION

FUNCTION s100_i()
   DEFINE l_lpc05    LIKE lpc_file.lpc05,    #FUN-C60032 add
          l_lpcacti  LIKE lpc_file.lpcacti   #FUN-C60032 add
   DEFINE l_n        LIKE type_file.num5     #FUN-D30093 add

   INPUT BY NAME g_rcj.rcj01,
                 g_rcj.rcj09,              #FUN-C80072 add
                 g_rcj.rcj02,g_rcj.rcj03, #FUN-BA0097 add 
                 g_rcj.rcj04,             #FUN-BC0079 add
                 g_rcj.rcj16,             #FUN-C30180 add 
                 g_rcj.rcj05,g_rcj.rcj06, #FUN-C10051 add
                 g_rcj.rcj07,             #FUN-C40018 add
                 g_rcj.rcj08,             #FUN-C30176 add
                 g_rcj.rcj10,             #FUN-CB0116 add
                 g_rcj.rcj11,             #FUN-CB0116 add
                 g_rcj.rcj12,             #FUN-CB0104 add
                 g_rcj.rcj13,             #FUN-D20020 add
                 g_rcj.rcj14,             #FUN-D20020 add
                 g_rcj.rcj15,             #FUN-D20020 add
                 #FUN-B50039-add-str--
                 g_rcj.rcjud01,g_rcj.rcjud02,g_rcj.rcjud03,g_rcj.rcjud04,g_rcj.rcjud05,
                 g_rcj.rcjud06,g_rcj.rcjud07,g_rcj.rcjud08,g_rcj.rcjud09,g_rcj.rcjud10,
                 g_rcj.rcjud11,g_rcj.rcjud12,g_rcj.rcjud13,g_rcj.rcjud14,g_rcj.rcjud15
                 #FUN-B50039-add-end--
   WITHOUT DEFAULTS
      BEFORE INPUT

#FUN-CB0116 add----begin--
      AFTER FIELD rcj10
         IF NOT cl_null(g_rcj.rcj10) THEN
            IF g_rcj.rcj10 <=0 THEN
               CALL cl_err('','aim-040',0)
               NEXT FIELD rcj10
            END IF
         END IF 
#FUN-CB0116 add----end--

      #FUN-BA0097 add ---
      AFTER FIELD rcj02
         IF NOT cl_null(g_rcj.rcj02) THEN 
            CALL s100_rcj02()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD rcj02
            END IF 
         END IF 
      #FUN-BA0097 end ---   
     # FUN-C10051  add---
      AFTER FIELD rcj05
         IF NOT cl_null(g_rcj.rcj05) THEN
            CALL s100_rcj05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rcj05
            END IF
         END IF
      AFTER FIELD rcj06
         IF NOT cl_null(g_rcj.rcj06) THEN
            CALL s100_rcj06()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rcj06
            END IF
         END IF
     #FUN-C10051   end-----
  
     #FUN-C40018 add START
      AFTER FIELD rcj07
         IF NOT cl_null(g_rcj.rcj07) THEN
            CALL s100_rcj07()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rcj07
            END IF
         END IF
     #FUN-C40018 add END

     #FUN-C30176 add START
      AFTER FIELD rcj08
         IF NOT cl_null(g_rcj.rcj08) THEN
            CALL s100_rcj08()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rcj08
            END IF
         END IF
     #FUN-C30176 add END

      #FUN-BC0079 add ---begin
      AFTER FIELD rcj04
         IF NOT cl_null(g_rcj.rcj04) THEN
            CALL s100_rcj04()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_rcj.rcj04 = g_rcj_t.rcj04
               DISPLAY g_rcj.rcj04 TO rcj04
               NEXT FIELD rcj04
            END IF
         END IF
      #FUN-BC0079 add ---end

     #FUN-D30093--add--str---
      AFTER FIELD rcj13 
         IF g_rcj.rcj13 <> g_rcj_t.rcj13 THEN
            SELECT COUNT(*) INTO l_n FROM rzi_file WHERE rzi09 = g_rcj_t.rcj13 AND rziacti = 'Y'
            IF cl_confirm_parm("art1132",l_n) THEN         #提示：是則更新資料，否則不做操作
               UPDATE rzi_file SET rziacti = 'N' WHERE rzi09 = g_rcj_t.rcj13 AND rziacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzi_file","","",SQLCA.SQLCODE,"","",1)
                  LET g_rcj.rcj13 = g_rcj_t.rcj13
                  DISPLAY g_rcj.rcj13 TO rcj13
                  NEXT FIELD rcj13
               END IF
               UPDATE rzi_file SET rzipos = '2' WHERE rzi09 = g_rcj_t.rcj13 AND rzipos IN ('3','4')
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzi_file","","",SQLCA.SQLCODE,"","",1)
                  LET g_rcj.rcj13 = g_rcj_t.rcj13
                  DISPLAY g_rcj.rcj13 TO rcj13
                  NEXT FIELD rcj13
               END IF
            END IF
         END IF
     #FUN-D30093--add--end---
 
     #FUN-D20020--add--str---
      AFTER FIELD rcj14
         IF NOT cl_null(g_rcj.rcj14) THEN
            IF g_rcj.rcj14 <= 0 THEN
               CALL cl_err('','afa-949',0)
               LET g_rcj.rcj14 = g_rcj_t.rcj14
               DISPLAY g_rcj.rcj14 TO rcj14
               NEXT FIELD rcj14
            END IF
         END IF

      AFTER FIELD rcj15
         IF NOT cl_null(g_rcj.rcj15) THEN
            IF g_rcj.rcj15 <= 0 THEN
               CALL cl_err('','afa-949',0)
               LET g_rcj.rcj15 = g_rcj_t.rcj15
               DISPLAY g_rcj.rcj15 TO rcj15
               NEXT FIELD rcj15
            END IF
            IF g_rcj.rcj15 <= g_rcj.rcj14 THEN
               CALL cl_err('','art1125',0)
               LET g_rcj.rcj15 = g_rcj_t.rcj15
               DISPLAY g_rcj.rcj15 TO rcj15
               NEXT FIELD rcj15
            END IF
         END IF
     #FUN-D20020--add--end---

      #FUN-B50039-add-str--
      AFTER FIELD rcjud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rcjud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
      #FUN-BA0097 add ---
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rcj02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rcj02"
               LET g_qryparam.default1 = g_rcj.rcj02
               CALL cl_create_qry() RETURNING g_rcj.rcj02
               DISPLAY BY NAME g_rcj.rcj02
               CALL s100_rcj02()
           #FUN-C10051----begin
             WHEN INFIELD(rcj05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rcj05"
               LET g_qryparam.default1 = g_rcj.rcj05
               CALL cl_create_qry() RETURNING g_rcj.rcj05
               DISPLAY BY NAME g_rcj.rcj05
               CALL s100_rcj05()

            WHEN INFIELD(rcj06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rcj05"
               LET g_qryparam.default1 = g_rcj.rcj06
               CALL cl_create_qry() RETURNING g_rcj.rcj06
               DISPLAY BY NAME g_rcj.rcj06
               CALL s100_rcj06()
           #FUN-C10051----end

           #FUN-C40018 add START
            WHEN INFIELD(rcj07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rcj05"
               LET g_qryparam.default1 = g_rcj.rcj07
               CALL cl_create_qry() RETURNING g_rcj.rcj07
               DISPLAY BY NAME g_rcj.rcj07
               CALL s100_rcj07()
           #FUN-C40018 add END
   
           #FUN-C30176 add START
            WHEN INFIELD(rcj08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rcj05"
               LET g_qryparam.default1 = g_rcj.rcj08
               CALL cl_create_qry() RETURNING g_rcj.rcj08
               DISPLAY BY NAME g_rcj.rcj08
               CALL s100_rcj08()
           #FUN-C30176 add END

           #FUN-BC0079----begin
            WHEN INFIELD(rcj04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rcj04"
               LET g_qryparam.default1 = g_rcj.rcj04
               CALL cl_create_qry() RETURNING g_rcj.rcj04
               DISPLAY BY NAME g_rcj.rcj04
               CALL s100_rcj04()
           #FUN-BC0079----end

         END CASE 
      #FUN-BA0097 end---      
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
 #FUN-BA0097 add ---
FUNCTION s100_rcj02()
DEFINE   l_azfacti LIKE azf_file.azfacti,
         l_azf02   LIKE azf_file.azf02,
         l_azf09   LIKE azf_file.azf09
   LET g_errno = ''      
   SELECT azfacti ,azf02,azf09 INTO l_azfacti,l_azf02,l_azf09 FROM azf_file
    WHERE azf01 = g_rcj.rcj02
   CASE 
      WHEN SQLCA.sqlcode = 100      LET g_errno = '1306'
      WHEN l_azfacti = 'N'          LET g_errno = 'alm1105'
      WHEN l_azf02 <> '2'           LET g_errno = 'asf-453'
      WHEN l_azf09 <> '4'           LET g_errno = 'aoo-403'
   END CASE    
END FUNCTION 
 #FUN-BA0097 end ---

#FUN-BC0079----begin
FUNCTION s100_rcj04()
DEFINE   l_lpc02     LIKE lpc_file.lpc02,
         l_lpcacti   LIKE lpc_file.lpcacti,
         l_lpc05     LIKE lpc_file.lpc05      #FUN-C60032 add
   
   LET g_errno = ''
   SELECT lpc02,lpcacti,lpc05 INTO l_lpc02,l_lpcacti,l_lpc05 FROM lpc_file    #FUN-C60032 add lpc05
    WHERE lpc00 = '8'
      AND lpc01 = g_rcj.rcj04
   CASE
      WHEN SQLCA.sqlcode = 100
         LET  g_errno = '1306'
      WHEN l_lpcacti = 'N'
         LET  g_errno = 'art1026'
      WHEN l_lpc05 = 'N'            #FUN-C60032 add
         LET g_errno = 'alm1628'    #FUN-C60032 add
   END CASE
   IF cl_null(g_errno) THEN
      DISPLAY l_lpc02 TO lpc02
   END IF
END FUNCTION
#FUN-BC0079----end
#FUN-B50007

#FUN-C10051-----begin
FUNCTION s100_rcj05()
DEFINE l_azf02    LIKE azf_file.azf02,
       l_azf09    LIKE azf_file.azf09, 
       l_azfacti   LIKE azf_file.azfacti
   LET g_errno = ''
   SELECT azf02,azf09,azfacti INTO l_azf02,l_azf09,l_azfacti FROM azf_file
    WHERE  azf01 = g_rcj.rcj05
    CASE
      WHEN SQLCA.sqlcode = 100
        LET g_errno = '1306'
      WHEN l_azfacti = 'N'  
        LET g_errno = 'alm1105'
      WHEN l_azf02 <> '2'           LET g_errno = 'asf-453'
      WHEN l_azf09 <> 'G'           LET g_errno = '1307' #TQC-C30197   'aoo-403'--->'1307'
    END CASE
END FUNCTION
FUNCTION s100_rcj06()
DEFINE l_azf02    LIKE azf_file.azf02,
       l_azf09    LIKE azf_file.azf09,
       l_azfacti   LIKE azf_file.azfacti
   LET g_errno = ''
   SELECT azf02,azf09,azfacti INTO l_azf02,l_azf09,l_azfacti FROM azf_file
    WHERE  azf01 = g_rcj.rcj06
    CASE
      WHEN SQLCA.sqlcode = 100
        LET g_errno = '1306'
      WHEN l_azfacti = 'N'
        LET g_errno = 'alm1105'
      WHEN l_azf02 <> '2'           LET g_errno = 'asf-453'
      WHEN l_azf09 <> 'G'           LET g_errno = '1307'  #TQC-C30197   'aoo-403'--->'1307'
    END CASE
END FUNCTION

#FUN-C10051-----end   
#FUN-C40018 add START
FUNCTION s100_rcj07()
DEFINE l_azf02    LIKE azf_file.azf02,
       l_azf09    LIKE azf_file.azf09,
       l_azfacti   LIKE azf_file.azfacti
   LET g_errno = ''
   SELECT azf02,azf09,azfacti INTO l_azf02,l_azf09,l_azfacti FROM azf_file
    WHERE  azf01 = g_rcj.rcj07
    CASE
      WHEN SQLCA.sqlcode = 100
        LET g_errno = '1306'
      WHEN l_azfacti = 'N'
        LET g_errno = 'alm1105'
      WHEN l_azf02 <> '2'           LET g_errno = 'asf-453'
      WHEN l_azf09 <> 'G'           LET g_errno = '1307'  
    END CASE
END FUNCTION
#FUN-C40018 add END

#FUN-C30176 add START
FUNCTION s100_rcj08()
DEFINE l_azf02    LIKE azf_file.azf02,
       l_azf09    LIKE azf_file.azf09,
       l_azfacti   LIKE azf_file.azfacti
   LET g_errno = ''
   SELECT azf02,azf09,azfacti INTO l_azf02,l_azf09,l_azfacti FROM azf_file
    WHERE  azf01 = g_rcj.rcj08
    CASE
      WHEN SQLCA.sqlcode = 100
        LET g_errno = '1306'
      WHEN l_azfacti = 'N'
        LET g_errno = 'alm1105'
      WHEN l_azf02 <> '2'           LET g_errno = 'asf-453'
      WHEN l_azf09 <> 'G'           LET g_errno = '1307'  
    END CASE
END FUNCTION
#FUN-C30176 add END
