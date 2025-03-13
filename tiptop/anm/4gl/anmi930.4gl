# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmi930.4gl
# Descriptions...: 集團資金調撥預設科目維護作業
# Date & Author..: #NO.FUN-620051 06/02/22 By Mandy
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/24 By Rayven 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-740049 07/04/12 By lora   會計科目加帳套
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)

DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_nmq           RECORD LIKE nmq_file.*,
        g_nmq_t         RECORD LIKE nmq_file.*,  # 預留參數檔
        g_nmq_o         RECORD LIKE nmq_file.*,  # 預留參數檔
        g_dbs_gl        LIKE type_file.chr21,    #No.FUN-680107 VARCHAR(21)
        g_plant_gl      LIKE type_file.chr10,    #No.FUN-980025 VARCHAR(10)
        g_aag02         LIKE aag_file.aag02
    DEFINE g_forupd_sql STRING
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
    CALL i930(4,12)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
END MAIN  
 
FUNCTION i930(p_row,p_col)
    DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPEN WINDOW i930_w WITH FORM "anm/42f/anmi930" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("page02",FALSE)
    END IF
    #No.FUN-680029 --end--
 
    CALL i930_show()
 
    LET g_action_choice=""
 
    CALL i930_menu()
 
    CLOSE WINDOW i930_w
END FUNCTION
 
FUNCTION i930_show()
  DEFINE      l_aag02_1         LIKE aag_file.aag02,
              l_aag02_2         LIKE aag_file.aag02,
              l_aag02_3         LIKE aag_file.aag02,
              l_aag02_4         LIKE aag_file.aag02
  #No.FUN-680088 --start--
  DEFINE      l_aag02_5         LIKE aag_file.aag02,
              l_aag02_6         LIKE aag_file.aag02,
              l_aag02_7         LIKE aag_file.aag02,
              l_aag02_8         LIKE aag_file.aag02
  #No.FUN-680088 --end--
 
    SELECT * INTO g_nmq.*
      FROM nmq_file 
     WHERE nmq00 = '0'
    IF SQLCA.sqlcode OR g_nmq.nmq21 IS NULL THEN
        IF SQLCA.sqlcode THEN
           INSERT INTO nmq_file(nmq00,nmq21,nmq22,nmq23,nmq24,nmq211,nmq221,nmq231,nmq241)  #No.FUN-680088 add nmq211,nmq221,nmq231,nmq241
                VALUES ('0',g_nmq.nmq21,g_nmq.nmq22,g_nmq.nmq23,g_nmq.nmq24,
                            g_nmq.nmq211,g_nmq.nmq221,g_nmq.nmq231,g_nmq.nmq241)  #No.FUN-680088
        ELSE
           UPDATE nmq_file SET nmq00='0',
                               nmq21 =g_nmq.nmq21,
                               nmq22 =g_nmq.nmq22,
                               nmq23 =g_nmq.nmq23,
                               nmq24 =g_nmq.nmq24,
                               nmq211=g_nmq.nmq211,  #No.FUN-680088
                               nmq221=g_nmq.nmq221,  #No.FUN-680088
                               nmq231=g_nmq.nmq231,  #No.FUN-680088
                               nmq241=g_nmq.nmq241   #No.FUN-680088  
        END IF
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           RETURN
        END IF
    END IF
    DISPLAY BY NAME g_nmq.nmq21,g_nmq.nmq22,g_nmq.nmq23,g_nmq.nmq24, 
                    g_nmq.nmq211,g_nmq.nmq221,g_nmq.nmq231,g_nmq.nmq241  #No.FUN-680088
    SELECT aag02 INTO l_aag02_1 FROM aag_file
     WHERE aag01=g_nmq.nmq21
       AND aag00=g_aza.aza81    # No.FUN-740049
    DISPLAY l_aag02_1 TO FORMONLY.aag02_1
 
    SELECT aag02 INTO l_aag02_2 FROM aag_file
     WHERE aag01=g_nmq.nmq22
       AND aag00=g_aza.aza81    # No.FUN-740049
    DISPLAY l_aag02_2 TO FORMONLY.aag02_2
 
    SELECT aag02 INTO l_aag02_3 FROM aag_file
     WHERE aag01=g_nmq.nmq23
       AND aag00=g_aza.aza81    # No.FUN-740049
    DISPLAY l_aag02_3 TO FORMONLY.aag02_3
 
    SELECT aag02 INTO l_aag02_4 FROM aag_file
     WHERE aag01=g_nmq.nmq24
       AND aag00=g_aza.aza81    # No.FUN-740049
     DISPLAY l_aag02_4 TO FORMONLY.aag02_4
 
    #No.FUN-680029 --start--
    SELECT aag02 INTO l_aag02_5 FROM aag_file
     WHERE aag01=g_nmq.nmq211
       AND aag00=g_aza.aza82    # No.FUN-740049 
    DISPLAY l_aag02_5 TO FORMONLY.aag02_5
 
    SELECT aag02 INTO l_aag02_6 FROM aag_file
     WHERE aag01=g_nmq.nmq221
       AND aag00=g_aza.aza82    # No.FUN-740049 
    DISPLAY l_aag02_6 TO FORMONLY.aag02_6
 
    SELECT aag02 INTO l_aag02_7 FROM aag_file
     WHERE aag01=g_nmq.nmq231
       AND aag00=g_aza.aza82    # No.FUN-740049 
    DISPLAY l_aag02_7 TO FORMONLY.aag02_7
 
    SELECT aag02 INTO l_aag02_8 FROM aag_file
     WHERE aag01=g_nmq.nmq241
       AND aag00=g_aza.aza82    # No.FUN-740049 
    DISPLAY l_aag02_8 TO FORMONLY.aag02_8
    #No.FUN-680029 --end--
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i930_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN
          CALL i930_u()
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
 
        -- for Windows close event trapped
    ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
       LET INT_FLAG=FALSE 		#MOD-570244	mars
       LET g_action_choice = "exit"
       EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION i930_u()
    CALL cl_opmsg('u')
    MESSAGE ""
    LET g_forupd_sql = "SELECT * FROM nmq_file WHERE nmq00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE nmq_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN nmq_curl
    IF STATUS  THEN CALL cl_err('OPEN nmq_curl',STATUS,1) RETURN END IF
    FETCH nmq_curl INTO g_nmq.*
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_nmq_t.* = g_nmq.*
    LET g_nmq_o.* = g_nmq.*
    WHILE TRUE
        CALL i930_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           LET g_nmq.* = g_nmq_t.*
           CALL i930_show()
           EXIT WHILE
        END IF
        UPDATE nmq_file SET
                nmq21=g_nmq.nmq21,
                nmq22=g_nmq.nmq22,
                nmq23=g_nmq.nmq23,
                nmq24=g_nmq.nmq24,
                nmq211=g_nmq.nmq211,  #No.FUN-680088 
                nmq221=g_nmq.nmq221,  #No.FUN-680088
                nmq231=g_nmq.nmq231,  #No.FUN-680088
                nmq241=g_nmq.nmq241   #No.FUN-680088
            WHERE nmq00='0'
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("upd","nmq_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660148
           CONTINUE WHILE
        END IF
        CLOSE nmq_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i930_i()
    DEFINE l_aza LIKE type_file.chr1    #No.FUN-680107 VARCHAR(01)
    DEFINE l_n   LIKE type_file.num5    #No.FUN-680107 SMALLINT
          
    INPUT BY NAME g_nmq.nmq21,g_nmq.nmq22,g_nmq.nmq23,g_nmq.nmq24,
                  g_nmq.nmq211,g_nmq.nmq221,g_nmq.nmq231,g_nmq.nmq241  #No.FUN-680088
          WITHOUT DEFAULTS HELP 1
 
    AFTER FIELD nmq21
        IF NOT i930_actchk(g_nmq.nmq21,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq21,'23',g_aza.aza81) 
                 RETURNING g_nmq.nmq21
           DISPLAY BY NAME g_nmq.nmq21
#FUN-B20073 --end--        
           NEXT FIELD nmq21 
        END IF   #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_1
 
    AFTER FIELD nmq22
        IF NOT i930_actchk(g_nmq.nmq22,g_aza.aza81) THEN 
#FUN-B20073 --begin--
         CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq22,'23',g_aza.aza81) 
                 RETURNING g_nmq.nmq22
         DISPLAY BY NAME g_nmq.nmq22
#FUN-B20073 --end--        
          NEXT FIELD nmq22 
        END IF   #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_2
 
    AFTER FIELD nmq23
        IF NOT i930_actchk(g_nmq.nmq23,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq23,'23',g_aza.aza81) 
                 RETURNING g_nmq.nmq23
           DISPLAY BY NAME g_nmq.nmq23
#FUN-B20073 --end--        
           NEXT FIELD nmq23 
        END IF    #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_3
 
    AFTER FIELD nmq24
        IF NOT i930_actchk(g_nmq.nmq24,g_aza.aza81) THEN 
#FUN-B20073 --begin--
          CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq24,'23',g_aza.aza81) 
                 RETURNING g_nmq.nmq24
          DISPLAY BY NAME g_nmq.nmq24
#FUN-B20073 --end--        
          NEXT FIELD nmq24 
        END IF    #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_4

    #No.FUN-680029 --start--
    AFTER FIELD nmq211
        IF NOT i930_actchk(g_nmq.nmq211,g_aza.aza82) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq211,'23',g_aza.aza82)
                 RETURNING g_nmq.nmq211
           DISPLAY BY NAME g_nmq.nmq211
#FUN-B20073 --end--        
           NEXT FIELD nmq211 
        END IF   #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_5
 
    AFTER FIELD nmq221
        IF NOT i930_actchk(g_nmq.nmq221,g_aza.aza82) THEN 
#FUN-B20073 --begin--
          CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq221,'23',g_aza.aza82) 
                 RETURNING g_nmq.nmq221
          DISPLAY BY NAME g_nmq.nmq221
#FUN-B20073 --end--        
          NEXT FIELD nmq221 
        END IF   #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_6
 
    AFTER FIELD nmq231
        IF NOT i930_actchk(g_nmq.nmq231,g_aza.aza82) THEN 
#FUN-B20073 --begin--
          CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq231,'23',g_aza.aza82) 
                 RETURNING g_nmq.nmq231
          DISPLAY BY NAME g_nmq.nmq231
#FUN-B20073 --end--        
           NEXT FIELD nmq231 
        END IF   #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_7
 
    AFTER FIELD nmq241
        IF NOT i930_actchk(g_nmq.nmq241,g_aza.aza82) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq241,'23',g_aza.aza82) 
                 RETURNING g_nmq.nmq241
            DISPLAY BY NAME g_nmq.nmq241
#FUN-B20073 --end--        
           NEXT FIELD nmq241 
        END IF   #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_8
    #No.FUN-680029 --end--
 
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION controlp
            CASE
              WHEN INFIELD(nmq21)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq21,'23',g_aza.aza81)   #No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq21,'23',g_aza.aza81) #No.FUN-980025 
                 RETURNING g_nmq.nmq21
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq21 )
                 DISPLAY BY NAME g_nmq.nmq21
                 NEXT FIELD nmq21
              WHEN INFIELD(nmq22)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq22,'23',g_aza.aza81)   #No.FUN-740049  #No.FUN-980025 
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq22,'23',g_aza.aza81) #No.FUN-980025 
                 RETURNING g_nmq.nmq22
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq22 )
                 DISPLAY BY NAME g_nmq.nmq22
                 NEXT FIELD nmq22
              WHEN INFIELD(nmq23)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq23,'23',g_aza.aza81)   #No.FUN-740049
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq23,'23',g_aza.aza81) #No.FUN-980025 
                 RETURNING g_nmq.nmq23
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq23 )
                 DISPLAY BY NAME g_nmq.nmq23
                 NEXT FIELD nmq23
              WHEN INFIELD(nmq24)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq24,'23',g_aza.aza81)   #No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq24,'23',g_aza.aza81) #No.FUN-980025  
                 RETURNING g_nmq.nmq24
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq24 )
                 DISPLAY BY NAME g_nmq.nmq24
                 NEXT FIELD nmq24
              #No.FUN-680029 --start--
              WHEN INFIELD(nmq211)
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq211,'23',g_aza.aza82)  #No.FUN-740049 #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq211,'23',g_aza.aza82)#No.FUN-980025  
                 RETURNING g_nmq.nmq211
                 DISPLAY BY NAME g_nmq.nmq211
                 NEXT FIELD nmq211
              WHEN INFIELD(nmq221)
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq221,'23',g_aza.aza82)   #No.FUN-740049   #No.FUN-980025 
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq221,'23',g_aza.aza82) #No.FUN-980025
                 RETURNING g_nmq.nmq221
                 DISPLAY BY NAME g_nmq.nmq221
                 NEXT FIELD nmq221
              WHEN INFIELD(nmq231)
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq231,'23',g_aza.aza82)   #No.FUN-740049  #No.FUN-980025 
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq231,'23',g_aza.aza82) #No.FUN-980025 
                 RETURNING g_nmq.nmq231
                 DISPLAY BY NAME g_nmq.nmq231
                 NEXT FIELD nmq231
              WHEN INFIELD(nmq241)
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq241,'23',g_aza.aza82)   #No.FUN-740049  #No.FUN-980025 
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq241,'23',g_aza.aza82) #No.FUN-980025
                 RETURNING g_nmq.nmq241
                 DISPLAY BY NAME g_nmq.nmq241
                 NEXT FIELD nmq241
              #No.FUN-680029 --end--
              OTHERWISE EXIT CASE
            END CASE
 
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
  
  END INPUT
 
END FUNCTION
FUNCTION i930_actchk(p_code,bookno)   #No.FUN-740049
  DEFINE p_code     LIKE aag_file.aag01
  DEFINE bookno     LIKE aza_file.aza81 
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag03    LIKE aag_file.aag03
 
     LET g_errno = ' '
     LET g_aag02 = NULL
     IF g_nmz.nmz02 = 'N' OR p_code IS NULL THEN 
         RETURN 1 
     END IF
        SELECT aag02,aag03,aag07,aag09,aagacti
          INTO g_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
          FROM aag_file
         WHERE aag01=p_code
           AND aag00=bookno    #No.FUN-740049 
        CASE WHEN STATUS=100         LET g_errno = 'agl-001'
             WHEN l_aagacti='N'      LET g_errno='9028'
              WHEN l_aag07  = '1'    LET g_errno = 'agl-015'
              WHEN l_aag03  = '4'    LET g_errno = 'agl-177'
              WHEN l_aag09  = 'N'    LET g_errno = 'agl-214'
             OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
        END CASE
        IF cl_null(g_errno) THEN RETURN 1 END IF
        CALL cl_err(p_code,g_errno,0)
        RETURN 0
END FUNCTION
