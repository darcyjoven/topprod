# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aqcs101.4gl
# Descriptions...: 參數設定作業
# Date & Author..: 97/12/24 By Melody
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-590044 05/09/21 By Mandy 若IQC檢驗不良時,放入待交換倉設'Y',則待交換倉庫/儲位 不空可白
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-740362 07/04/23 By claire 排除不可用倉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/11 By xianghui 增加自訂欄位
# Modify.........: No.FUN-BC0104 11/12/29 By xujing 增加"QC判定料件否" (qcz14)
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_qcz_t         RECORD LIKE qcz_file.*,  # 預留參數檔
        g_qcz_o         RECORD LIKE qcz_file.*   # 預留參數檔
    DEFINE g_status     STRING   #No.FUN-660115
    DEFINE g_forupd_sql STRING   #No.FUN-680104
    DEFINE g_before_input_done LIKE type_file.num5   #FUN-590044 add        #No.FUN-680104 SMALLINT
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
    CALL s101(0 ,0)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION s101(p_row,p_col)
    DEFINE p_row,p_col LIKE type_file.num5        #No.FUN-680104 SMALLINT
 
    OPEN WINDOW s101_w WITH FORM "aqc/42f/aqcs101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    CALL s101_show()
    LET g_action_choice=""
    CALL s101_menu()
    CLOSE WINDOW s101_w
END FUNCTION
 
FUNCTION s101_show()
    SELECT * INTO g_qcz.*
             FROM qcz_file WHERE qcz00 = '0'
        IF SQLCA.sqlcode THEN
           INSERT INTO qcz_file(qcz00,qcz02,qcz021,qcz03,qcz031,
                                qcz04,qcz041,qcz13,qcz01,qcz14,qcz12,qcz05,qcz051,qcz052,qcz06,  #FUN-BC0104 add qcz14
                                qcz061,qcz07,qcz08,qcz09,qcz10,qcz11) 
                  VALUES ('0', g_qcz.qcz02,g_qcz.qcz021,g_qcz.qcz03,
                               g_qcz.qcz031,g_qcz.qcz04,g_qcz.qcz041,
                               g_qcz.qcz13,g_qcz.qcz01,g_qcz.qcz14,g_qcz.qcz12, #no.6831 add qcz13  FUN-BC0104 add qcz14
                               g_qcz.qcz05,g_qcz.qcz051,g_qcz.qcz052,
                               g_qcz.qcz06,g_qcz.qcz061,g_qcz.qcz07,
                               g_qcz.qcz08,g_qcz.qcz09,g_qcz.qcz10,
                               g_qcz.qcz11)                
           LET g_status = "ins"
        ELSE
           UPDATE qcz_file SET qcz00='0',
                               qcz02=g_qcz.qcz02,
                               qcz021=g_qcz.qcz021,
                               qcz03=g_qcz.qcz03,
                               qcz031=g_qcz.qcz031,
                               qcz04=g_qcz.qcz04,
                               qcz041=g_qcz.qcz041,
                               qcz13=g_qcz.qcz13,
                               qcz01=g_qcz.qcz01,
                               qcz14=g_qcz.qcz14,   #FUN-BC0104 add qcz14
                               qcz12=g_qcz.qcz12,
                               qcz05=g_qcz.qcz05,
                               qcz051=g_qcz.qcz051,
                               qcz052=g_qcz.qcz052,
                               qcz06=g_qcz.qcz06,
                               qcz061=g_qcz.qcz061,
                               qcz07=g_qcz.qcz07,
                               qcz08=g_qcz.qcz08,
                               qcz09=g_qcz.qcz09,
                               qcz10=g_qcz.qcz10,
                               qcz11=g_qcz.qcz11 
           LET g_status = "upd"
        END IF
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)  #NO.FUN-660115
           CALL cl_err3(g_status,"qcz_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660115
           RETURN
        END IF
    DISPLAY BY NAME g_qcz.qcz05,g_qcz.qcz051,g_qcz.qcz052,
                    g_qcz.qcz02,g_qcz.qcz021,g_qcz.qcz03,
                    g_qcz.qcz031,g_qcz.qcz04,g_qcz.qcz041,
                    g_qcz.qcz13,g_qcz.qcz01,g_qcz.qcz14,g_qcz.qcz12,  #bugno:6831 add qcz13 FUN-BC0104 add qcz14
                    g_qcz.qcz06,g_qcz.qcz061,g_qcz.qcz07,
                    g_qcz.qcz08,g_qcz.qcz09,g_qcz.qcz10,g_qcz.qcz11,
                    g_qcz.qczud01,g_qcz.qczud02,g_qcz.qczud03,g_qcz.qczud04,g_qcz.qczud05,  #FUN-B50039
                    g_qcz.qczud06,g_qcz.qczud07,g_qcz.qczud08,g_qcz.qczud09,g_qcz.qczud10,  #FUN-B50039
                    g_qcz.qczud11,g_qcz.qczud12,g_qcz.qczud13,g_qcz.qczud14,g_qcz.qczud15   #FUN-B50039
                    
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      DISPLAY '!' TO qcz05 
      DISPLAY '!' TO qcz12  
   END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s101_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN 
          CALL s101_u()
       END IF 
 
    ON ACTION help
       CALL cl_show_help()
 
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
       LET g_action_choice = "exit"
       CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s101_u()
    CALL cl_opmsg('u')
    #檢查是否有更改的權限
    MESSAGE ""
    LET g_forupd_sql = "SELECT * FROM qcz_file WHERE qcz00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE qcz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN qcz_curl
    IF STATUS  THEN CALL cl_err('OPEN qcz_curl',STATUS,1) RETURN END IF
    FETCH qcz_curl INTO g_qcz.*
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END If
    LET g_qcz_t.* = g_qcz.*
    LET g_qcz_o.* = g_qcz.*
    DISPLAY BY NAME g_qcz.qcz05,g_qcz.qcz051,g_qcz.qcz052,
                    g_qcz.qcz02,g_qcz.qcz021,g_qcz.qcz03,
                    g_qcz.qcz031,g_qcz.qcz04,g_qcz.qcz041,
                    g_qcz.qcz13,g_qcz.qcz01,g_qcz.qcz14,g_qcz.qcz12,  #bugno:6831 add qcz13 FUN-BC0104 add qcz14
                    g_qcz.qcz06,g_qcz.qcz061,g_qcz.qcz07,
                    g_qcz.qcz08,g_qcz.qcz09,g_qcz.qcz10,g_qcz.qcz11,
                    g_qcz.qczud01,g_qcz.qczud02,g_qcz.qczud03,g_qcz.qczud04,g_qcz.qczud05,  #FUN-B50039
                    g_qcz.qczud06,g_qcz.qczud07,g_qcz.qczud08,g_qcz.qczud09,g_qcz.qczud10,  #FUN-B50039
                    g_qcz.qczud11,g_qcz.qczud12,g_qcz.qczud13,g_qcz.qczud14,g_qcz.qczud15   #FUN-B50039
                     
    WHILE TRUE
        CALL s101_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           LET g_qcz.* = g_qcz_t.*
           CALL s101_show()
           EXIT WHILE
        END IF
        UPDATE qcz_file SET
                qcz05=g_qcz.qcz05,
                qcz051=g_qcz.qcz051,
                qcz052=g_qcz.qcz052,
                qcz02=g_qcz.qcz02,
                qcz021=g_qcz.qcz021,
                qcz03=g_qcz.qcz03,
                qcz031=g_qcz.qcz031,
                qcz04=g_qcz.qcz04,
                qcz041=g_qcz.qcz041,
                qcz13 = g_qcz.qcz13,
                qcz01 = g_qcz.qcz01,
                qcz14 = g_qcz.qcz14, #FUN-BC0104 add qcz14
                qcz12 = g_qcz.qcz12,
                qcz06=g_qcz.qcz06,
                qcz061=g_qcz.qcz061,
                qcz07=g_qcz.qcz07,
                qcz08=g_qcz.qcz08,
                qcz09=g_qcz.qcz09,
                qcz10=g_qcz.qcz10,
                qcz11=g_qcz.qcz11,
                #FUN-B50039-add-str--
                qczud01 = g_qcz.qczud01,
                qczud02 = g_qcz.qczud02,
                qczud03 = g_qcz.qczud03,
                qczud04 = g_qcz.qczud04,
                qczud05 = g_qcz.qczud05,
                qczud06 = g_qcz.qczud06,
                qczud07 = g_qcz.qczud07,
                qczud08 = g_qcz.qczud08,
                qczud09 = g_qcz.qczud09,
                qczud10 = g_qcz.qczud10,
                qczud11 = g_qcz.qczud11,
                qczud12 = g_qcz.qczud12,
                qczud13 = g_qcz.qczud13,
                qczud14 = g_qcz.qczud14,
                qczud15 = g_qcz.qczud15
                #FUN-B50039-add-end--
            WHERE qcz00='0'
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660115
           CALL cl_err3("upd","qcz_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660115
           CONTINUE WHILE
        END IF
        CLOSE qcz_curl
		COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s101_i()
   DEFINE   l_aza   LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
            l_cmd   LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(50)
 
   INPUT BY NAME g_qcz.qcz05,g_qcz.qcz051,g_qcz.qcz052,
                 g_qcz.qcz02,g_qcz.qcz021,g_qcz.qcz03,
                 g_qcz.qcz031,g_qcz.qcz04,g_qcz.qcz041,
                 g_qcz.qcz13,g_qcz.qcz01,g_qcz.qcz14,g_qcz.qcz12, #bugno:6831 add qcz13 FUN-BC0104 add qcz14
                 g_qcz.qcz06,g_qcz.qcz061,g_qcz.qcz07,
                 g_qcz.qcz08,g_qcz.qcz09,g_qcz.qcz10,g_qcz.qcz11,
                 g_qcz.qczud01,g_qcz.qczud02,g_qcz.qczud03,g_qcz.qczud04,g_qcz.qczud05,  #FUN-B50039
                 g_qcz.qczud06,g_qcz.qczud07,g_qcz.qczud08,g_qcz.qczud09,g_qcz.qczud10,  #FUN-B50039
                 g_qcz.qczud11,g_qcz.qczud12,g_qcz.qczud13,g_qcz.qczud14,g_qcz.qczud15   #FUN-B50039
                 WITHOUT DEFAULTS
 
      #FUN-590044 add
      BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL s101_set_entry()
        CALL s101_set_no_entry()
        CALL s101_set_no_required()
        CALL s101_set_required()
        LET g_before_input_done = TRUE
 
      BEFORE FIELD qcz05 
        CALL s101_set_entry()
        CALL s101_set_no_required()
 
      ON CHANGE qcz05
        CALL s101_set_entry()
        CALL s101_set_no_entry() #FUN-590044 add
        CALL s101_set_no_required()
        CALL s101_set_required()
      #FUN-590044(end)
 
      AFTER FIELD qcz05
          IF NOT cl_null(g_qcz.qcz05) THEN  
             IF g_qcz.qcz05 NOT MATCHES '[YN]' THEN
                CALL cl_err(g_qcz.qcz05,'mfg0037',0)
                NEXT FIELD qcz05
             END IF
          END IF
          CALL s101_set_required() #FUN-590044 add
     #FUN-590044 mark
     #BEFORE FIELD qcz051,qcz052
     #   IF g_qcz.qcz05='N' THEN
     #      LET g_qcz.qcz051=' '
     #      LET g_qcz.qcz052=' '
     #      DISPLAY BY NAME g_qcz.qcz051,g_qcz.qcz052
     #   END IF
 
      AFTER FIELD qcz051
         IF cl_null(g_qcz.qcz051) AND g_qcz.qcz05='Y' THEN
            CALL cl_err(g_qcz.qcz05,'mfg0037',0)
            NEXT FIELD qcz051
         END IF
         IF NOT cl_null(g_qcz.qcz051) THEN  
            SELECT * FROM imd_file WHERE imd01=g_qcz.qcz051  
                                      AND imdacti = 'Y' #MOD-4B0169
                                      AND imd11   = 'Y' #MOD-740362
            IF STATUS THEN 
#              CALL cl_err('',STATUS,0)   #No.FUN-660115
               CALL cl_err3("sel","imd_file",g_qcz.qcz051,"",STATUS,"","",0)  #No.FUN-660115
               NEXT FIELD qcz051 
            END IF
         END IF
         #FUN-590044 add
         IF cl_null(g_qcz.qcz052) AND g_qcz.qcz05='Y' THEN
             LET g_qcz.qcz052=' '
             DISPLAY BY NAME g_qcz.qcz051,g_qcz.qcz052
         END IF
         #FUN-590044(end)
      #FUN-D40103 ------Begin------
         IF NOT s_imechk(g_qcz.qcz051,g_qcz.qcz052) THEN
             NEXT FIELD qcz052
         END IF
      #FUN-D40103 ------End-------- 

      AFTER FIELD qcz052
         IF cl_null(g_qcz.qcz052) AND g_qcz.qcz05='Y' THEN
            LET g_qcz.qcz052=' '
         END IF
       #FUN-D40103 mark-------Begin-------
         #IF NOT cl_null(g_qcz.qcz052) THEN  
         #   SELECT * FROM ime_file WHERE ime01=g_qcz.qcz051 AND ime02=g_qcz.qcz052
         #   IF STATUS THEN 
#        #      CALL cl_err('',STATUS,0)   #No.FUN-660115
         #      CALL cl_err3("sel","ime_file",g_qcz.qcz051,g_qcz.qcz052,STATUS,"","",0)  #No.FUN-660115
         #      NEXT FIELD qcz052
         #   END IF
         #END IF
       #FUN-D40103 mark-------end-------
         #FUN-D40103 ------Begin------
         IF NOT s_imechk(g_qcz.qcz051,g_qcz.qcz052) THEN
             NEXT FIELD qcz052
         END IF
         #FUN-D40103 ------End-------- 

      #FUN-B50039-add-str--
      AFTER FIELD qczud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qczud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--

      BEFORE FIELD qcz13
         IF cl_null(g_qcz.qcz13) THEN
            LET g_qcz.qcz13 = 'Y'
            DISPLAY BY NAME g_qcz.qcz13 
         END IF 
     
      AFTER FIELD qcz13
         IF NOT cl_null(g_qcz.qcz13) THEN
            IF g_qcz.qcz13 NOT MATCHES '[YN]' THEN
               NEXT FIELD qcz13
            END IF
         END IF
     
      AFTER FIELD qcz01
         IF NOT cl_null(g_qcz.qcz01) THEN
           IF g_qcz.qcz01 NOT MATCHES '[YN]' THEN
              NEXT FIELD qcz01
           END IF
         END IF
     
      AFTER FIELD qcz12
         IF NOT cl_null(g_qcz.qcz12) THEN
            IF g_qcz.qcz12 NOT MATCHES '[YN]' THEN
               NEXT FIELD qcz12
            END IF
         END IF
     
      AFTER FIELD qcz061
         IF NOT cl_null(g_qcz.qcz061) THEN
            IF g_qcz.qcz061>g_qcz.qcz06 THEN 
               NEXT FIELD qcz06 
            END IF
         END IF
 
    ON ACTION CONTROLP
         CASE  WHEN INFIELD (qcz051) #倉庫別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imd"
                  LET g_qryparam.default1 = g_qcz.qcz051
                  #LET g_qryparam.arg1     = "A" #MOD-4A0213
                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   LET g_qryparam.where = "imd11='Y'"    #MOD-740362
                  CALL cl_create_qry() RETURNING g_qcz.qcz051
#                  CALL FGL_DIALOG_SETBUFFER( g_qcz.qcz051 )
                  DISPLAY BY NAME g_qcz.qcz051 
                  NEXT FIELD qcz051
               WHEN INFIELD (qcz052) #儲位別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ime"
                  LET g_qryparam.default1 = g_qcz.qcz052
                   LET g_qryparam.arg1     = g_qcz.qcz051#倉庫編號 #MOD-4A0063
                   LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
                 #LET g_qryparam.arg2     = "A"
                 #IF g_qryparam.arg2 != 'A' THEN
                 #   LET g_qryparam.where = "ime04='",g_qryparam.arg2,"'"
                 #END IF
                  CALL cl_create_qry() RETURNING g_qcz.qcz052
#                  CALL FGL_DIALOG_SETBUFFER( g_qcz.qcz052 )
                  DISPLAY BY NAME g_qcz.qcz052 
                  NEXT FIELD qcz052
        END CASE
 
      ON ACTION create_warehouse_ioctaion
         CASE
            WHEN INFIELD(qcz051) #建立倉庫別
               LET l_cmd = 'aimi200 ' 
               CALL cl_cmdrun(l_cmd)
               NEXT FIELD qcz051
            WHEN INFIELD(qcz052) #建立儲位別
               LET l_cmd = "aimi201 '",g_qcz.qcz051,"'" #BugNo:6598
               CALL cl_cmdrun(l_cmd)
               NEXT FIELD qcz052
            OTHERWISE 
               EXIT CASE
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
#FUN-590044 add
FUNCTION s101_set_entry()
 
   IF INFIELD(qcz05) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("qcz051,qcz052",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION s101_set_no_entry()
 
   IF INFIELD(qcz05) OR (NOT g_before_input_done) THEN
       IF g_qcz.qcz05='N' THEN
           CALL cl_set_comp_entry("qcz051,qcz052",FALSE)
       END IF
   END IF
END FUNCTION
 
FUNCTION s101_set_required()
 
  IF NOT g_before_input_done OR INFIELD(qcz05) THEN
     IF g_qcz.qcz05 = 'Y' THEN
        CALL cl_set_comp_required("qcz051,qcz052",TRUE)
     END IF
  END IF
END FUNCTION
 
FUNCTION s101_set_no_required()
 
  IF NOT g_before_input_done OR INFIELD(qcz05) THEN
     IF g_qcz.qcz05 = 'N' THEN
        CALL cl_set_comp_required("qcz051,qcz052",FALSE)
        LET g_qcz.qcz051=NULL
        LET g_qcz.qcz052=NULL
        DISPLAY BY NAME g_qcz.qcz051,g_qcz.qcz052
     END IF
  END IF
END FUNCTION
#FUN-590044 (end)
