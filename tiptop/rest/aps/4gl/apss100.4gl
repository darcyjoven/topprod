# Prog. Version..: '5.10.05-08.12.18(00005)'     #
# Pattern name...: apss100.4gl
# Descriptions...: APS 參數管理
# Date & Author..: 03/04/02 By Kammy
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting odify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-740087 07/04/20 By JackLai 增加ETL與APS的參數設定
# Modify.........: No.TQC-750072 07/05/15 By Joe APS DB 欄位改拉q_azp_aps視窗
# Modify.........: No.FUN-750086 07/05/24 By JackLai 增加ETL從APS傳回TIPTOP TempDB的工作名稱欄位

DATABASE ds

GLOBALS "../../config/top.global"
     DEFINE
        aps_saz_t         RECORD LIKE aps_saz.*,  # 參數檔
        aps_saz_o         RECORD LIKE aps_saz.*   # 參數檔
    DEFINE g_forupd_sql   STRING

DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
MAIN
    OPTIONS 
          FORM LINE FIRST +2,
          MESSAGE LINE LAST,
          PROMPT LINE  LAST,
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL apss100()
END MAIN  

FUNCTION apss100()
    DEFINE
        p_row,p_col LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_time      LIKE type_file.chr8    #No.FUN-690010 VARCHAR(8)


   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


    LET p_row = 4 LET p_col = 14
    OPEN WINDOW apss100_w AT p_row,p_col       
        WITH FORM "aps/42f/apss100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()



    CALL apss100_show()

    WHILE TRUE
      LET g_action_choice=""
    CALL apss100_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW apss100_w
END FUNCTION

FUNCTION apss100_show()
    SELECT *      
        INTO aps_saz.*
        FROM aps_saz WHERE saz00 = '0'
    IF SQLCA.sqlcode OR aps_saz.saz02 IS NULL THEN
   #    CALL cl_err('sel aps:',STATUS,1) #No.FUN-660095
         CALL cl_err3("sel","aps_saz","","",SQLCA.sqlcode,"","sel aps:",1)  # Fun - 660095
       RETURN
    END IF

    DISPLAY BY NAME aps_saz.saz01,aps_saz.saz02,aps_saz.saz03,
    #No.FUN-740087 --start--
        aps_saz.saz04,aps_saz.saz05,aps_saz.saz06,aps_saz.saz07,
        aps_saz.saz08,aps_saz.saz09,aps_saz.saz17,aps_saz.saz10,aps_saz.saz11, #No.FUN-750086
        aps_saz.saz12,aps_saz.saz13,aps_saz.saz14,aps_saz.saz15,
        aps_saz.saz16
    #No.FUN-740087 --end--
    
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION apss100_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0135 START---
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL apss100_u()
       END IF
#NO.FUN-5B0134

    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#   EXIT MENU
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
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
END FUNCTION


FUNCTION apss100_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql = "SELECT *  FROM aps_saz WHERE saz00 = '0' FOR UPDATE NOWAIT"
    DECLARE aps_saz_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
	LOCK TABLE aps_saz  IN EXCLUSIVE MODE
    OPEN aps_saz_curl
    IF STATUS THEN CALL cl_err('OPEN aps_saz_curl',STATUS,1) RETURN END IF
    FETCH aps_saz_curl INTO aps_saz.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET aps_saz_o.* = aps_saz.*
    LET aps_saz_t.* = aps_saz.*
    DISPLAY BY NAME aps_saz.saz01,aps_saz.saz02,aps_saz.saz03,
    #No.FUN-740087 --start--
        aps_saz.saz04,aps_saz.saz05,aps_saz.saz06,aps_saz.saz07,
        aps_saz.saz08,aps_saz.saz09,aps_saz.saz17,aps_saz.saz10,aps_saz.saz11, #No.FUN-750086
        aps_saz.saz12,aps_saz.saz13,aps_saz.saz14,aps_saz.saz15,
        aps_saz.saz16
    #No.FUN-740087 --end--
         
    WHILE TRUE
        CALL apss100_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_saz SET
            saz01=aps_saz.saz01,
            saz02=aps_saz.saz02,
            saz03=aps_saz.saz03,
            #No.FUN-740087 --start--
            saz04=aps_saz.saz04,
            saz05=aps_saz.saz05,
            saz06=aps_saz.saz06,
            saz07=aps_saz.saz07,
            saz08=aps_saz.saz08,
            saz09=aps_saz.saz09,
            saz10=aps_saz.saz10,
            saz11=aps_saz.saz11,
            saz12=aps_saz.saz12,
            saz13=aps_saz.saz13,
            saz14=aps_saz.saz14,
            saz15=aps_saz.saz15,
            saz16=aps_saz.saz16,
            saz17=aps_saz.saz17
            #No.FUN-740087 --end--
            WHERE saz00='0'
        IF SQLCA.sqlcode THEN
    #        CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
           CALL cl_err3("upd","aps_saz","","",SQLCA.sqlcode,"","",0)  # Fun - 660095
            CONTINUE WHILE
        END IF
        UNLOCK TABLE aps_saz
        EXIT WHILE
    END WHILE
    CLOSE aps_saz_curl
    COMMIT WORK
END FUNCTION

FUNCTION apss100_i()
    #No.FUN-740087 --start--
    DEFINE l_interval INTERVAL HOUR TO FRACTION(5)
    
    LET l_interval = "00:00:01.00000"
    #No.FUN-740087 --end--
    
    INPUT BY NAME
       aps_saz.saz01,aps_saz.saz02,aps_saz.saz03,
       #No.FUN-740087 --start--
       aps_saz.saz04,aps_saz.saz05,aps_saz.saz06,aps_saz.saz07,aps_saz.saz08,
       aps_saz.saz09,aps_saz.saz17,aps_saz.saz10,aps_saz.saz11,aps_saz.saz12,aps_saz.saz13, #No.FUN-750086
       aps_saz.saz14,aps_saz.saz15,aps_saz.saz16
       #No.FUN-740087 --end--
       WITHOUT DEFAULTS
    
 
    AFTER FIELD saz01
       IF NOT cl_null(aps_saz.saz01) THEN
          SELECT COUNT(*) INTO g_cnt  FROM azp_file 
           WHERE azp01 = aps_saz.saz01
         #   AND azp053= 'N' #no.7431 非 ERP database
          IF g_cnt =0 THEN
             CALL cl_err('sel azp:',STATUS,0)
             LET aps_saz.saz01=aps_saz_o.saz01
             DISPLAY BY NAME aps_saz.saz01
             NEXT FIELD saz01
          END IF
       END IF
       LET aps_saz_o.saz01=aps_saz.saz01
 
    AFTER FIELD saz02
       IF NOT cl_null(aps_saz.saz02) THEN
          IF aps_saz.saz02 NOT MATCHES '[YN]' THEN
             LET aps_saz.saz02=aps_saz_o.saz02
             DISPLAY BY NAME aps_saz.saz02
             NEXT FIELD saz02
          END IF
       END IF
       LET aps_saz_o.saz02=aps_saz.saz02
    AFTER FIELD saz03
       IF NOT cl_null(aps_saz.saz03) THEN
          IF aps_saz.saz03 NOT MATCHES '[12]' THEN
                LET aps_saz.saz03=aps_saz_o.saz03
                DISPLAY BY NAME aps_saz.saz03
                NEXT FIELD saz03
          END IF
       END IF
       LET aps_saz_o.saz03=aps_saz.saz03
       
    #No.FUN-740087 --start--
    #檢查輪詢間隔時間是否在1到60秒範圍內
    AFTER FIELD saz04
        IF NOT cl_null(aps_saz.saz04) THEN
            IF aps_saz.saz04 > 60 AND aps_saz.saz04 <= 0 THEN
                MESSAGE "The Value must > 0 and <= 60!!"
                DISPLAY BY NAME aps_saz.saz04
                NEXT FIELD saz04
            END IF
        END IF
    
    #檢查逾時時間是否大於1秒
    AFTER FIELD saz05
        IF NOT cl_null(aps_saz.saz05) THEN
            IF aps_saz.saz05 < l_interval THEN
                MESSAGE "The Value must >= 00:00:01.00000!!"
                DISPLAY BY NAME aps_saz.saz05
                NEXT FIELD saz05
            END IF
        END IF        
    #No.FUN-740087 --end--
    
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(saz01) #查詢APS DB資料檔
                CALL cl_init_qry_var()
              ##LET g_qryparam.form = "q_azp"       #TQC-750072
                LET g_qryparam.form = "q_azp_aps"   #TQC-750072
                LET g_qryparam.default1 = aps_saz.saz01
                CALL cl_create_qry() RETURNING aps_saz.saz01
#                CALL FGL_DIALOG_SETBUFFER( aps_saz.saz01 )
                DISPLAY BY NAME aps_saz.saz01 
                NEXT FIELD saz01
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT

END FUNCTION
