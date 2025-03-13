# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmi702.4gl
# Descriptions...: 融資暫估利息預設科目設定
# Date & Author..: 03/12/30 By Kitty
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/28 By flowld 兩套帳ANM追加規格部分
# Modify.........: No.FUN-680107 06/09/07 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-740049 07/04/12 By hongmei 會計科目加帳套
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 

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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    CALL i702(4,12)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN  
 
FUNCTION i702(p_row,p_col)

    DEFINE p_row,p_col  LIKE type_file.num5
 
    OPEN WINDOW i702_w WITH FORM "anm/42f/anmi702" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    CALL cl_set_comp_visible("page02",g_aza.aza63 = 'Y')  # No.FUN-680088
    CALL i702_show()
 
    LET g_action_choice=""
 
    CALL i702_menu()
 
    CLOSE WINDOW i702_w
END FUNCTION
 
FUNCTION i702_show()
  DEFINE      l_aag02_1         LIKE aag_file.aag02,
              l_aag02_2         LIKE aag_file.aag02,
              l_aag02_3         LIKE aag_file.aag02,
              l_aag02_4         LIKE aag_file.aag02
# No.FUN-680088 --start--
  DEFINE      l_aag02_a1        LIKE aag_file.aag02,
              l_aag02_a2        LIKE aag_file.aag02,
              l_aag02_a3        LIKE aag_file.aag02,
              l_aag02_a4        LIKE aag_file.aag02                     
# No.FUN-680088 ---end---                
    SELECT * INTO g_nmq.*
      FROM nmq_file 
     WHERE nmq00 = '0'
    IF SQLCA.sqlcode OR g_nmq.nmq01 IS NULL THEN
        IF SQLCA.sqlcode THEN
           INSERT INTO nmq_file(nmq00,nmq01,nmq02,nmq10,nmq11)
                VALUES ('0',g_nmq.nmq01,g_nmq.nmq02,g_nmq.nmq10,g_nmq.nmq11)
        ELSE
           UPDATE nmq_file SET nmq00='0',
                               nmq01 =g_nmq.nmq01,
                               nmq02 =g_nmq.nmq02,
                               nmq10 =g_nmq.nmq10 ,
                               nmq11 =g_nmq.nmq11
        END IF
 
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           RETURN
        END IF
    END IF
# No.FUN-680088 --start--
 
    IF SQLCA.sqlcode OR g_nmq.nmq011 IS NULL THEN
        IF SQLCA.sqlcode THEN
           INSERT INTO nmq_file(nmq00,nmq011,nmq021,nmq101,nmq111)
                VALUES ('0',g_nmq.nmq011,g_nmq.nmq021,g_nmq.nmq101,g_nmq.nmq111)
        ELSE
           UPDATE nmq_file SET nmq00='0',
                               nmq011 =g_nmq.nmq011,
                               nmq021 =g_nmq.nmq021,
                               nmq101 =g_nmq.nmq101 ,
                               nmq111 =g_nmq.nmq111
        END IF
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           RETURN
        END IF
    END IF
 
# No.FUN-680088 ---end---
   DISPLAY BY NAME g_nmq.nmq01,g_nmq.nmq02,g_nmq.nmq10,g_nmq.nmq11,
                   g_nmq.nmq011,g_nmq.nmq021,g_nmq.nmq101,g_nmq.nmq111    # No.FUN-680088
    SELECT aag02 INTO l_aag02_1 FROM aag_file
     WHERE aag01=g_nmq.nmq01
       AND aag00=g_aza.aza81    # No.FUN-740049
    DISPLAY l_aag02_1 TO FORMONLY.aag02_1
 
    SELECT aag02 INTO l_aag02_2 FROM aag_file
     WHERE aag01=g_nmq.nmq02
       AND aag00=g_aza.aza81    # No.FUN-740049
    DISPLAY l_aag02_2 TO FORMONLY.aag02_2
 
    SELECT aag02 INTO l_aag02_3 FROM aag_file
     WHERE aag01=g_nmq.nmq10
       AND aag00=g_aza.aza81    # No.FUN-740049
    DISPLAY l_aag02_3 TO FORMONLY.aag02_3
 
    SELECT aag02 INTO l_aag02_4 FROM aag_file
     WHERE aag01=g_nmq.nmq11
       AND aag00=g_aza.aza81    # No.FUN-740049
     DISPLAY l_aag02_4 TO FORMONLY.aag02_4
 
# No.FUN-680088 --start--
 
    SELECT aag02 INTO l_aag02_a1 FROM aag_file
     WHERE aag01=g_nmq.nmq011
       AND aag00=g_aza.aza82    # No.FUN-740049
    DISPLAY l_aag02_a1 TO FORMONLY.aag02_a1
 
    SELECT aag02 INTO l_aag02_a2 FROM aag_file
     WHERE aag01=g_nmq.nmq021
       AND aag00=g_aza.aza82    # No.FUN-740049
    DISPLAY l_aag02_a2 TO FORMONLY.aag02_a2
 
    SELECT aag02 INTO l_aag02_a3 FROM aag_file
     WHERE aag01=g_nmq.nmq101
       AND aag00=g_aza.aza82    # No.FUN-740049
    DISPLAY l_aag02_a3 TO FORMONLY.aag02_a3
 
    SELECT aag02 INTO l_aag02_a4 FROM aag_file
     WHERE aag01=g_nmq.nmq111
       AND aag00=g_aza.aza82    # No.FUN-740049
     DISPLAY l_aag02_a4 TO FORMONLY.aag02_a4
 
# No.FUN-680088 ---end---
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i702_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN
          CALL i702_u()
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
 
 
FUNCTION i702_u()
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
        CALL i702_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           LET g_nmq.* = g_nmq_t.*
           CALL i702_show()
           EXIT WHILE
        END IF
        UPDATE nmq_file SET
                nmq01=g_nmq.nmq01,
                nmq02=g_nmq.nmq02,
                nmq10=g_nmq.nmq10,
                nmq11=g_nmq.nmq11,
                nmq011=g_nmq.nmq011,
                nmq021=g_nmq.nmq021,
                nmq101=g_nmq.nmq101,
                nmq111=g_nmq.nmq111 
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
 
FUNCTION i702_i()
    DEFINE l_aza LIKE type_file.chr1    #No.FUN-680107 VARCHAR(01)
    DEFINE l_n   LIKE type_file.num5    #No.FUN-680107 SMALLINT
          
    INPUT BY NAME g_nmq.nmq01,g_nmq.nmq02,g_nmq.nmq10,g_nmq.nmq11,
                  g_nmq.nmq011,g_nmq.nmq021,g_nmq.nmq101,g_nmq.nmq111   # No.FUN-680088 
          WITHOUT DEFAULTS HELP 1
 
    AFTER FIELD nmq01
        IF NOT i702_actchk(g_nmq.nmq01,g_aza.aza81) THEN 
#FUN-B20073 --begin--
          CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq01,'23',g_aza.aza81)
                RETURNING g_nmq.nmq01
          DISPLAY BY NAME g_nmq.nmq01
#FUN-B20073 --end--        
          NEXT FIELD nmq01 
        END IF    #No.FUN-740049
        DISPLAY g_aag02 TO FORMONLY.aag02_1
 
    AFTER FIELD nmq02
        IF NOT i702_actchk(g_nmq.nmq02,g_aza.aza81) THEN 
#FUN-B20073 --begin--
            CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq02,'23',g_aza.aza81)
                 RETURNING g_nmq.nmq02
            DISPLAY BY NAME g_nmq.nmq02
#FUN-B20073 --end--        
           NEXT FIELD nmq02 
        END IF      #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_2
 
    AFTER FIELD nmq10
        IF NOT i702_actchk(g_nmq.nmq10,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq10,'23',g_aza.aza81) 
                 RETURNING g_nmq.nmq10
           DISPLAY BY NAME g_nmq.nmq10
#FUN-B20073 --end--        
           NEXT FIELD nmq10 
        END IF       #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_3
 
    AFTER FIELD nmq11
        IF NOT i702_actchk(g_nmq.nmq11,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq11,'23',g_aza.aza81) 
                 RETURNING g_nmq.nmq11
           DISPLAY BY NAME g_nmq.nmq11
#FUN-B20073 --end--        
           NEXT FIELD nmq11 
        END IF         #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_4

# No.FUN-680088 --start--
   
    AFTER FIELD nmq011
        IF NOT i702_actchk(g_nmq.nmq011,g_aza.aza82) THEN 
#FUN-B20073 --begin--
          CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq011,'23',g_aza.aza82) 
                RETURNING g_nmq.nmq011
          DISPLAY BY NAME g_nmq.nmq011
#FUN-B20073 --end--        
          NEXT FIELD nmq011 
        END IF           #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_a1
 
    AFTER FIELD nmq021
        IF NOT i702_actchk(g_nmq.nmq021,g_aza.aza82) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq021,'23',g_aza.aza82) 
                 RETURNING g_nmq.nmq021
           DISPLAY BY NAME g_nmq.nmq021
#FUN-B20073 --end--        
           NEXT FIELD nmq021 
        END IF            #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_a2
 
    AFTER FIELD nmq101
        IF NOT i702_actchk(g_nmq.nmq101,g_aza.aza82) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq101,'23',g_aza.aza82) 
                 RETURNING g_nmq.nmq101
           DISPLAY BY NAME g_nmq.nmq101
#FUN-B20073 --end--        
           NEXT FIELD nmq101 
        END IF           #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_a3
 
    AFTER FIELD nmq111
        IF NOT i702_actchk(g_nmq.nmq111,g_aza.aza82) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmq.nmq111,'23',g_aza.aza82) 
                 RETURNING g_nmq.nmq111
           DISPLAY BY NAME g_nmq.nmq111
#FUN-B20073 --end--        
           NEXT FIELD nmq111 
        END IF            #No.FUN-740049 
        DISPLAY g_aag02 TO FORMONLY.aag02_a4
 
# No.FUN-680088 ---end---
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION controlp
            CASE
              WHEN INFIELD(nmq01)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq01,'23',g_aza.aza81)  # No.FUN-740049 #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq01,'23',g_aza.aza81)#No.FUN-980025
                 RETURNING g_nmq.nmq01
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq01 )
                 DISPLAY BY NAME g_nmq.nmq01
                 NEXT FIELD nmq01
              WHEN INFIELD(nmq02)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq02,'23',g_aza.aza81)  # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq02,'23',g_aza.aza81)#No.FUN-980025 
                 RETURNING g_nmq.nmq02
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq02 )
                 DISPLAY BY NAME g_nmq.nmq02
                 NEXT FIELD nmq02
              WHEN INFIELD(nmq10)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq10,'23',g_aza.aza81)   # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq10,'23',g_aza.aza81) #No.FUN-980025
                 RETURNING g_nmq.nmq10
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq10 )
                 DISPLAY BY NAME g_nmq.nmq10
                 NEXT FIELD nmq10
              WHEN INFIELD(nmq11)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq11,'23',g_aza.aza81)   # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq11,'23',g_aza.aza81) #No.FUN-980025 
                 RETURNING g_nmq.nmq11
#                 CALL FGL_DIALOG_SETBUFFER( g_nmq.nmq11 )
                 DISPLAY BY NAME g_nmq.nmq11
                 NEXT FIELD nmq11
# No.FUN-680088 --start--
 
              WHEN INFIELD(nmq011)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq011,'23',g_aza.aza82)   # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq011,'23',g_aza.aza82) #No.FUN-980025
                 RETURNING g_nmq.nmq011
                 DISPLAY BY NAME g_nmq.nmq011
                 NEXT FIELD nmq011
              WHEN INFIELD(nmq021)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq021,'23',g_aza.aza82)   # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq021,'23',g_aza.aza82) #No.FUN-980025
                 RETURNING g_nmq.nmq021
                 DISPLAY BY NAME g_nmq.nmq021
                 NEXT FIELD nmq021
              WHEN INFIELD(nmq101)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq101,'23',g_aza.aza82)   # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq101,'23',g_aza.aza82) #No.FUN-980025 
                 RETURNING g_nmq.nmq101
                 DISPLAY BY NAME g_nmq.nmq101
                 NEXT FIELD nmq101
              WHEN INFIELD(nmq111)         # 會計科目查詢
#                CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmq.nmq111,'23',g_aza.aza82)   # No.FUN-740049  #No.FUN-980025
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmq.nmq111,'23',g_aza.aza82) #No.FUN-980025 
                 RETURNING g_nmq.nmq111
                 DISPLAY BY NAME g_nmq.nmq111
                 NEXT FIELD nmq111
# No.FUN-680088 ---end---
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
FUNCTION i702_actchk(p_code,bookno)   #No.FUN-740049
  DEFINE bookno     LIKE aza_file.aza81  #No.FUN-740049
  DEFINE p_code     LIKE aag_file.aag01
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
           AND aag00=bookno   #No.FUN-740049
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
