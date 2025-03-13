# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anms107.4gl
# Descriptions...: 外匯會計科目維護作業
# Date & Author..: 98/06/22 By Iceman FOR TIPTOP 4.00 
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting 
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/28 By flowld 兩套帳ANM追加規格部分
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.TQC-690063 06/10/16 By Smapmin 增加是否與總帳會計系統連結的判斷
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-740028 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE  g_gxd           RECORD LIKE gxd_file.* 
DEFINE  g_gxd_t         RECORD LIKE gxd_file.* 
DEFINE  m_aag02         LIKE aag_file.aag02 
DEFINE  g_dbs_gl        LIKE type_file.chr21     #No.FUN-680107 VARCHAR(21)
DEFINE  g_plant_gl      LIKE type_file.chr10     #No.FUN-980025 VARCHAR(10)
DEFINE  p_row           LIKE type_file.num5 
DEFINE  p_col           LIKE type_file.num5      #No.FUN-680107 SMALLINT
  
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
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl = g_nmz.nmz02p  #No.FUN-980025
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
    LET p_row = 3 LET p_col = 2  
    OPEN WINDOW i107_w AT p_row,p_col
         WITH FORM "anm/42f/anms107" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("page02",g_aza.aza63 = 'Y')  # No.FUN-680088
 
 
    SELECT * INTO g_gxd.* FROM gxd_file WHERE gxd00 = '0'
    IF STATUS = 100 THEN INSERT INTO gxd_file(gxd00) VALUES('0') END IF
    CALL i107_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i107_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i107_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION i107_show()
  DISPLAY BY NAME g_gxd.gxd01,g_gxd.gxd02,g_gxd.gxd03,g_gxd.gxd04,g_gxd.gxd09,
                  g_gxd.gxd05,g_gxd.gxd06,g_gxd.gxd07,g_gxd.gxd08,g_gxd.gxd10,
                  g_gxd.gxd11,g_gxd.gxd12,
# No.FUN-680088 --start--
                  g_gxd.gxd011,g_gxd.gxd021,g_gxd.gxd031,g_gxd.gxd041,g_gxd.gxd091,                                                      
                  g_gxd.gxd051,g_gxd.gxd061,g_gxd.gxd071,g_gxd.gxd081,g_gxd.gxd101,                                                      
                  g_gxd.gxd111,g_gxd.gxd121               
# No.FUN-680088 ---end---
                 
  IF g_nmz.nmz02 = 'Y' THEN   #TQC-690063
     CALL s107_gxd01('d',g_gxd.gxd01,'1',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd02,'2',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd03,'3',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd04,'4',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd05,'5',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd06,'6',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd07,'7',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd08,'8',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd09,'9',g_aza.aza81)    #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd10,'10',g_aza.aza81)   #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd11,'11',g_aza.aza81)   #No.FUN-740028
     CALL s107_gxd01('d',g_gxd.gxd12,'12',g_aza.aza81)   #No.FUN-740028
   # No.FUN-680088 --start--
     CALL s107_gxd01('d',g_gxd.gxd011,'a1',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd021,'a2',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd031,'a3',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd041,'a4',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd051,'a5',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd061,'a6',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd071,'a7',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd081,'a8',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd091,'a9',g_aza.aza82)   #No.FUN-740028                                                                                              
     CALL s107_gxd01('d',g_gxd.gxd101,'a10',g_aza.aza82)  #No.FUN-740028                                                                                             
     CALL s107_gxd01('d',g_gxd.gxd111,'a11',g_aza.aza82)  #No.FUN-740028                                                                                             
     CALL s107_gxd01('d',g_gxd.gxd121,'a12',g_aza.aza82)  #No.FUN-740028              
   # No.FUN-680088 ---end---
   END IF   #TQC-690063
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i107_menu()
    MENU ""
    ON ACTION modify
#NO.FUN-5B0134
      LET g_action_choice="modify"
      IF cl_chk_act_auth() THEN
          CALL i107_u()
      END IF
#NO.FUN-5B0134
 
    ON ACTION help
       CALL cl_show_help()
 
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
 
    ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
 
FUNCTION i107_u()
    CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT * FROM gxd_file WHERE gxd00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE gxd_curl CURSOR FROM g_forupd_sql
     
    BEGIN WORK 
 
    OPEN gxd_curl
    IF STATUS THEN CALL cl_err('OPEN gxd_curl',STATUS,1) RETURN END IF
    FETCH gxd_curl INTO g_gxd.*
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
 
    LET g_gxd_t.* = g_gxd.*
 
    WHILE TRUE
        CALL i107_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLOSE gxd_curl
           ROLLBACK WORK
           LET g_gxd.* = g_gxd_t.*
           CALL i107_show()
           EXIT WHILE
        END IF
        UPDATE gxd_file SET * = g_gxd.* WHERE gxd00='0'
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("upd","gxd_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660148
           CONTINUE WHILE
        END IF
        CLOSE gxd_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i107_i()
  INPUT BY NAME g_gxd.gxd01,g_gxd.gxd02,g_gxd.gxd03,g_gxd.gxd04,
                g_gxd.gxd05,g_gxd.gxd06,g_gxd.gxd07,g_gxd.gxd08,
                g_gxd.gxd09,g_gxd.gxd10,g_gxd.gxd11,g_gxd.gxd12,
# No.FUN-680088 --start--
                g_gxd.gxd011,g_gxd.gxd021,g_gxd.gxd031,g_gxd.gxd041,                                                                    
                g_gxd.gxd051,g_gxd.gxd061,g_gxd.gxd071,g_gxd.gxd081,                                                                    
                g_gxd.gxd091,g_gxd.gxd101,g_gxd.gxd111,g_gxd.gxd121     
# No.FUN-680088 ---end---
                WITHOUT DEFAULTS 
 
     AFTER FIELD gxd01
       IF NOT cl_null(g_gxd.gxd01) THEN 
          IF  g_nmz.nmz02 = 'Y' THEN
              CALL s107_gxd01('a',g_gxd.gxd01,'1',g_aza.aza81)    #No.FUN-740028
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gxd.gxd01,g_errno,0)
#FUN-B20073 --begin--
#                 LET g_gxd.gxd01 = g_gxd_t.gxd01 
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd01,'23',g_aza.aza81)
                     RETURNING g_gxd.gxd01  
                 CALL s107_gxd01('d',g_gxd.gxd01,'1',g_aza.aza81)   
#FUN-B20073 --end--
                 DISPLAY BY NAME g_gxd.gxd01
                 NEXT FIELD gxd01
              END IF
          END IF
       END IF
 
     AFTER FIELD gxd02
       IF NOT cl_null(g_gxd.gxd02) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd02,'2',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd02,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd02 = g_gxd_t.gxd02 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd02,'23',g_aza.aza81) 
                   RETURNING g_gxd.gxd02  
                CALL s107_gxd01('d',g_gxd.gxd02,'2',g_aza.aza81)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd02
                NEXT FIELD gxd02
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd03
       IF NOT cl_null(g_gxd.gxd03) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd03,'3',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd03,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd03 = g_gxd_t.gxd03 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd03,'23',g_aza.aza81) 
                  RETURNING g_gxd.gxd03 
                CALL s107_gxd01('d',g_gxd.gxd03,'3',g_aza.aza81)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd03
                NEXT FIELD gxd03
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd04
       IF NOT cl_null(g_gxd.gxd04) THEN
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd04,'4',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd04,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd04 = g_gxd_t.gxd04 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd04,'23',g_aza.aza81) 
                    RETURNING g_gxd.gxd04  
                CALL s107_gxd01('d',g_gxd.gxd04,'4',g_aza.aza81)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd04
                NEXT FIELD gxd04
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd05
       IF NOT cl_null(g_gxd.gxd05) THEN
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd05,'5',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd05,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd05 = g_gxd_t.gxd05 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd05,'23',g_aza.aza81) 
                   RETURNING g_gxd.gxd05  
                CALL s107_gxd01('d',g_gxd.gxd05,'5',g_aza.aza81)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd05
                NEXT FIELD gxd05
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd06
       IF NOT cl_null(g_gxd.gxd06) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd06,'6',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd06,g_errno,0)
#FUN-B20073 --begin--                
#                LET g_gxd.gxd06 = g_gxd_t.gxd06 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd06,'23',g_aza.aza81) 
                     RETURNING g_gxd.gxd06 
                CALL s107_gxd01('d',g_gxd.gxd06,'6',g_aza.aza81) 
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd06
                NEXT FIELD gxd06
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd07
       IF NOT cl_null(g_gxd.gxd07) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd07,'7',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd07,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd07 = g_gxd_t.gxd07 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd07,'23',g_aza.aza81) 
                   RETURNING g_gxd.gxd07  
                CALL s107_gxd01('d',g_gxd.gxd07,'7',g_aza.aza81) 
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd07
                NEXT FIELD gxd07
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd08
       IF NOT cl_null(g_gxd.gxd08) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd08,'8',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd08,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd08 = g_gxd_t.gxd08 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd08,'23',g_aza.aza81) 
                   RETURNING g_gxd.gxd08  
                CALL s107_gxd01('d',g_gxd.gxd08,'8',g_aza.aza81)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd08
                NEXT FIELD gxd08
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd09
       IF NOT cl_null(g_gxd.gxd09) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd09,'9',g_aza.aza81)   #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd09,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd09 = g_gxd_t.gxd09
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd09,'23',g_aza.aza81) 
                   RETURNING g_gxd.gxd09  
                CALL s107_gxd01('d',g_gxd.gxd09,'9',g_aza.aza81)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd09
                NEXT FIELD gxd09
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd10
       IF NOT cl_null(g_gxd.gxd10) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd10,'10',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd10,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd10 = g_gxd_t.gxd10
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd10,'23',g_aza.aza81) 
                    RETURNING g_gxd.gxd10 
                CALL s107_gxd01('d',g_gxd.gxd10,'10',g_aza.aza81)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd10
                NEXT FIELD gxd10
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd11
       IF NOT cl_null(g_gxd.gxd11) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd11,'11',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd11,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd11 = g_gxd_t.gxd11
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd11,'23',g_aza.aza81) 
                    RETURNING g_gxd.gxd11  
                CALL s107_gxd01('d',g_gxd.gxd11,'11',g_aza.aza81)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd11
                NEXT FIELD gxd11
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd12
       IF NOT cl_null(g_gxd.gxd12) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd12,'12',g_aza.aza81)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd12,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd12 = g_gxd_t.gxd12
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd12,'23',g_aza.aza81) 
                   RETURNING g_gxd.gxd12
                CALL s107_gxd01('d',g_gxd.gxd12,'12',g_aza.aza81)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd12
                NEXT FIELD gxd12
             END IF
          END IF
       END IF
       
# No.FUN-680088 --start--
 
     AFTER FIELD gxd011
       IF NOT cl_null(g_gxd.gxd011) THEN 
          IF  g_nmz.nmz02 = 'Y' THEN
              CALL s107_gxd01('a',g_gxd.gxd011,'a1',g_aza.aza82)    #No.FUN-740028
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gxd.gxd011,g_errno,0)
#FUN-B20073 --begin--
#                 LET g_gxd.gxd011 = g_gxd_t.gxd011 
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd011,'23',g_aza.aza82)
                      RETURNING g_gxd.gxd011  
                  CALL s107_gxd01('d',g_gxd.gxd011,'a1',g_aza.aza82)   
#FUN-B20073 --end--
                 DISPLAY BY NAME g_gxd.gxd011
                 NEXT FIELD gxd011
              END IF
          END IF
       END IF
 
     AFTER FIELD gxd021
       IF NOT cl_null(g_gxd.gxd021) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd021,'a2',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd021,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd021 = g_gxd_t.gxd021 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd021,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd021  
                CALL s107_gxd01('d',g_gxd.gxd021,'a2',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd021
                NEXT FIELD gxd021
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd031
       IF NOT cl_null(g_gxd.gxd031) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd031,'a3',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd031,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd031 = g_gxd_t.gxd031 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd031,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd031  
                CALL s107_gxd01('d',g_gxd.gxd031,'a3',g_aza.aza82)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd031
                NEXT FIELD gxd031
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd041
       IF NOT cl_null(g_gxd.gxd041) THEN
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd041,'a4',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd041,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd041 = g_gxd_t.gxd041 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd041,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd041 
               CALL s107_gxd01('d',g_gxd.gxd041,'a4',g_aza.aza82)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd041
                NEXT FIELD gxd041
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd051
       IF NOT cl_null(g_gxd.gxd051) THEN
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd051,'a5',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd051,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd051 = g_gxd_t.gxd051 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd051,'23',g_aza.aza82)
                    RETURNING g_gxd.gxd051 
                CALL s107_gxd01('d',g_gxd.gxd051,'a5',g_aza.aza82)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd051
                NEXT FIELD gxd051
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd061
       IF NOT cl_null(g_gxd.gxd061) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd061,'a6',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd061,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd061 = g_gxd_t.gxd061 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd061,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd061  
                CALL s107_gxd01('d',g_gxd.gxd061,'a6',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd061
                NEXT FIELD gxd061
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd071
       IF NOT cl_null(g_gxd.gxd071) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd071,'a7',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd071,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd071 = g_gxd_t.gxd071 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd071,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd071  
                CALL s107_gxd01('d',g_gxd.gxd071,'a7',g_aza.aza82)  
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd071
                NEXT FIELD gxd071
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd081
       IF NOT cl_null(g_gxd.gxd081) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd081,'a8',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd081,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd081 = g_gxd_t.gxd081 
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd081,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd081  
                CALL s107_gxd01('d',g_gxd.gxd081,'a8',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd081
                NEXT FIELD gxd081
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd091
       IF NOT cl_null(g_gxd.gxd091) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd091,'a9',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd091,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd091 = g_gxd_t.gxd091
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd091,'23',g_aza.aza82) 
                    RETURNING g_gxd.gxd091  
                CALL s107_gxd01('d',g_gxd.gxd091,'a9',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd091
                NEXT FIELD gxd091
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd101
       IF NOT cl_null(g_gxd.gxd101) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd101,'a10',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd101,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd101 = g_gxd_t.gxd101
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd101,'23',g_aza.aza82) 
                   RETURNING g_gxd.gxd101 
                CALL s107_gxd01('d',g_gxd.gxd101,'a10',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd101
                NEXT FIELD gxd101
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd111
       IF NOT cl_null(g_gxd.gxd111) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd111,'a11',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd111,g_errno,0)
#FUN-B20073 --begin--
#                LET g_gxd.gxd111 = g_gxd_t.gxd111
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd111,'23',g_aza.aza82)
                   RETURNING g_gxd.gxd111 
                CALL s107_gxd01('d',g_gxd.gxd111,'a11',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd111
                NEXT FIELD gxd111
             END IF
          END IF
       END IF
 
     AFTER FIELD gxd121
       IF NOT cl_null(g_gxd.gxd121) THEN 
          IF g_nmz.nmz02 = 'Y' THEN
             CALL s107_gxd01('a',g_gxd.gxd121,'a12',g_aza.aza82)    #No.FUN-740028
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gxd.gxd121,g_errno,0)
#FUN-B20073 --begin--                
#                LET g_gxd.gxd121 = g_gxd_t.gxd121
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxd.gxd121,'23',g_aza.aza82)
                   RETURNING g_gxd.gxd121  
                CALL s107_gxd01('d',g_gxd.gxd121,'a12',g_aza.aza82)   
#FUN-B20073 --end--
                DISPLAY BY NAME g_gxd.gxd121
                NEXT FIELD gxd121
             END IF
           END IF
          END IF
# No.FUN-680088 ---end---
 
    AFTER INPUT 
       IF INT_FLAG THEN EXIT INPUT END IF
 
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
    ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
    ON ACTION CONTROLG CALL cl_cmdask()
 
    ON ACTION controlp
       IF g_nmz.nmz02 = 'Y' THEN   #TQC-690063
       CASE
         WHEN INFIELD(gxd01)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd01,'23',g_aza.aza81) RETURNING g_gxd.gxd01    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd01,'23',g_aza.aza81) RETURNING g_gxd.gxd01  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd01 )
           CALL s107_gxd01('d',g_gxd.gxd01,'1',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd01 NEXT FIELD gxd01
         WHEN INFIELD(gxd02)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd02,'23',g_aza.aza81) RETURNING g_gxd.gxd02    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd02,'23',g_aza.aza81) RETURNING g_gxd.gxd02  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd02 )
           CALL s107_gxd01('d',g_gxd.gxd02,'2',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd02 NEXT FIELD gxd02
         WHEN INFIELD(gxd03)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd03,'23',g_aza.aza81) RETURNING g_gxd.gxd03    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd03,'23',g_aza.aza81) RETURNING g_gxd.gxd03  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd03 )
           CALL s107_gxd01('d',g_gxd.gxd03,'3',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd03 NEXT FIELD gxd03
         WHEN INFIELD(gxd04)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd04,'23',g_aza.aza81) RETURNING g_gxd.gxd04    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd04,'23',g_aza.aza81) RETURNING g_gxd.gxd04  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd04 )
           CALL s107_gxd01('d',g_gxd.gxd04,'4',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd04 NEXT FIELD gxd04
         WHEN INFIELD(gxd05)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd05,'23',g_aza.aza81) RETURNING g_gxd.gxd05    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd05,'23',g_aza.aza81) RETURNING g_gxd.gxd05  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd05 )
           CALL s107_gxd01('d',g_gxd.gxd05,'5',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd05 NEXT FIELD gxd05
         WHEN INFIELD(gxd06)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd06,'23',g_aza.aza81) RETURNING g_gxd.gxd06    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd06,'23',g_aza.aza81) RETURNING g_gxd.gxd06  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd06 )
           CALL s107_gxd01('d',g_gxd.gxd06,'6',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd06 NEXT FIELD gxd06
         WHEN INFIELD(gxd07)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd07,'23',g_aza.aza81) RETURNING g_gxd.gxd07    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd07,'23',g_aza.aza81) RETURNING g_gxd.gxd07  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd07 )
           CALL s107_gxd01('d',g_gxd.gxd07,'7',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd07 NEXT FIELD gxd07
         WHEN INFIELD(gxd08)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd08,'23',g_aza.aza81) RETURNING g_gxd.gxd08    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd08,'23',g_aza.aza81) RETURNING g_gxd.gxd08  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd08 )
           CALL s107_gxd01('d',g_gxd.gxd08,'8',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd08 NEXT FIELD gxd08
         WHEN INFIELD(gxd09)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd09,'23',g_aza.aza81) RETURNING g_gxd.gxd09    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd09,'23',g_aza.aza81) RETURNING g_gxd.gxd09  #No.FUN-980025
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd09 )
           CALL s107_gxd01('d',g_gxd.gxd09,'9',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd09 NEXT FIELD gxd09
         WHEN INFIELD(gxd10)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd10,'23',g_aza.aza81) RETURNING g_gxd.gxd10    #No.FUN-740028  #No.FUN-740028
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd10,'23',g_aza.aza81) RETURNING g_gxd.gxd10  #No.FUN-740028
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd10 )
           CALL s107_gxd01('d',g_gxd.gxd10,'10',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd10 NEXT FIELD gxd10
         WHEN INFIELD(gxd11)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd11,'23',g_aza.aza81) RETURNING g_gxd.gxd11    #No.FUN-740028  #No.FUN-740028
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd11,'23',g_aza.aza81) RETURNING g_gxd.gxd11  #No.FUN-740028
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd11 )
           CALL s107_gxd01('d',g_gxd.gxd11,'11',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd11 NEXT FIELD gxd11
         WHEN INFIELD(gxd12)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd12,'23',g_aza.aza81) RETURNING g_gxd.gxd12    #No.FUN-740028  #No.FUN-740028
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd12,'23',g_aza.aza81) RETURNING g_gxd.gxd12  #No.FUN-740028
#           CALL FGL_DIALOG_SETBUFFER( g_gxd.gxd12 )
           CALL s107_gxd01('d',g_gxd.gxd12,'12',g_aza.aza81)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd12 NEXT FIELD gxd12
# No.FUN-680088 --start--
 
         WHEN INFIELD(gxd011)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd011,'23',g_aza.aza82) RETURNING g_gxd.gxd011    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd011,'23',g_aza.aza82) RETURNING g_gxd.gxd011  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd011,'a1',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd011 NEXT FIELD gxd011
         WHEN INFIELD(gxd021)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd021,'23',g_aza.aza82) RETURNING g_gxd.gxd021    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd021,'23',g_aza.aza82) RETURNING g_gxd.gxd021  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd021,'a2',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd021 NEXT FIELD gxd021
         WHEN INFIELD(gxd031)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd031,'23',g_aza.aza82) RETURNING g_gxd.gxd031    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd031,'23',g_aza.aza82) RETURNING g_gxd.gxd031  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd031,'a3',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd031 NEXT FIELD gxd031
         WHEN INFIELD(gxd041)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd041,'23',g_aza.aza82) RETURNING g_gxd.gxd041    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd041,'23',g_aza.aza82) RETURNING g_gxd.gxd041  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd041,'a4',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd041 NEXT FIELD gxd041
         WHEN INFIELD(gxd051)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd051,'23',g_aza.aza82) RETURNING g_gxd.gxd051    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd051,'23',g_aza.aza82) RETURNING g_gxd.gxd051  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd051,'a5',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd051 NEXT FIELD gxd051
         WHEN INFIELD(gxd061)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd061,'23',g_aza.aza82) RETURNING g_gxd.gxd061    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd061,'23',g_aza.aza82) RETURNING g_gxd.gxd061  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd061,'a6',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd061 NEXT FIELD gxd061
         WHEN INFIELD(gxd071)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd071,'23',g_aza.aza82) RETURNING g_gxd.gxd071    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd071,'23',g_aza.aza82) RETURNING g_gxd.gxd071  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd071,'a7',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd071 NEXT FIELD gxd071
         WHEN INFIELD(gxd081)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd081,'23',g_aza.aza82) RETURNING g_gxd.gxd081    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd081,'23',g_aza.aza82) RETURNING g_gxd.gxd081  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd081,'a8',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd081 NEXT FIELD gxd081
         WHEN INFIELD(gxd091)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd091,'23',g_aza.aza82) RETURNING g_gxd.gxd091    #No.FUN-740028  #No.FUN-980025 
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd091,'23',g_aza.aza82) RETURNING g_gxd.gxd091  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd091,'a9',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd091 NEXT FIELD gxd091
         WHEN INFIELD(gxd101)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd101,'23',g_aza.aza82) RETURNING g_gxd.gxd101    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd101,'23',g_aza.aza82) RETURNING g_gxd.gxd101  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd101,'a10',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd101 NEXT FIELD gxd101
         WHEN INFIELD(gxd111)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd111,'23',g_aza.aza82) RETURNING g_gxd.gxd111    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd111,'23',g_aza.aza82) RETURNING g_gxd.gxd111  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd111,'a11',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd111 NEXT FIELD gxd111
         WHEN INFIELD(gxd121)
#          CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_gxd.gxd121,'23',g_aza.aza82) RETURNING g_gxd.gxd121    #No.FUN-740028  #No.FUN-980025
           CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxd.gxd121,'23',g_aza.aza82) RETURNING g_gxd.gxd121  #No.FUN-980025
           CALL s107_gxd01('d',g_gxd.gxd121,'a12',g_aza.aza82)   #TQC-690063   #No.FUN-740028
           DISPLAY BY NAME g_gxd.gxd121 NEXT FIELD gxd121
# No.FUN-680088 ---end---
         OTHERWISE EXIT CASE
       END CASE
       END IF   #TQC-690063
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
  
  END INPUT
END FUNCTION
 
FUNCTION s107_gxd01(p_cmd,p_code,p_type,p_bookno)      #No.FUN-740028
  DEFINE p_cmd      LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
  DEFINE p_code     LIKE aag_file.aag01  
  DEFINE p_type     LIKE type_file.chr4     #No.FUN-680107 VARCHAR(04)
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07  
  DEFINE l_aag09    LIKE aag_file.aag09  
  DEFINE l_aag03    LIKE aag_file.aag03  
  DEFINE p_bookno   LIKE aag_file.aag00     #No.FUN-740028 
 
  LET g_errno = ' '
   SELECT aag02,aag03,aag07,aag09,aagacti
     INTO m_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
     FROM aag_file
    WHERE aag01=p_code      
      AND aag00=p_bookno     #No.FUN-740028
   CASE WHEN STATUS=100          LET g_errno='agl-001' 
                                 LET m_aag02 = ' '
        WHEN l_aagacti='N'       LET g_errno='9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
        WHEN l_aag03  = '4'      LET g_errno = 'agl-177' 
        WHEN l_aag09  = 'N'      LET g_errno = 'agl-214' 
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   IF g_errno = ' ' OR p_cmd = 'd' 
   THEN  CASE
          WHEN p_type = '1'   DISPLAY m_aag02 TO aag02_1 
          WHEN p_type = '2'   DISPLAY m_aag02 TO aag02_2 
          WHEN p_type = '3'   DISPLAY m_aag02 TO aag02_3 
          WHEN p_type = '4'   DISPLAY m_aag02 TO aag02_4 
          WHEN p_type = '5'   DISPLAY m_aag02 TO aag02_5 
          WHEN p_type = '6'   DISPLAY m_aag02 TO aag02_6 
          WHEN p_type = '7'   DISPLAY m_aag02 TO aag02_7 
          WHEN p_type = '8'   DISPLAY m_aag02 TO aag02_8 
          WHEN p_type = '9'   DISPLAY m_aag02 TO aag02_9 
          WHEN p_type = '10'  DISPLAY m_aag02 TO aag02_10
          WHEN p_type = '11'  DISPLAY m_aag02 TO aag02_11
          WHEN p_type = '12'  DISPLAY m_aag02 TO aag02_12
# No.FUN-680088 --start--
 
          WHEN p_type = 'a1'   DISPLAY m_aag02 TO aag02_a1 
          WHEN p_type = 'a2'   DISPLAY m_aag02 TO aag02_a2 
          WHEN p_type = 'a3'   DISPLAY m_aag02 TO aag02_a3 
          WHEN p_type = 'a4'   DISPLAY m_aag02 TO aag02_a4 
          WHEN p_type = 'a5'   DISPLAY m_aag02 TO aag02_a5 
          WHEN p_type = 'a6'   DISPLAY m_aag02 TO aag02_a6 
          WHEN p_type = 'a7'   DISPLAY m_aag02 TO aag02_a7 
          WHEN p_type = 'a8'   DISPLAY m_aag02 TO aag02_a8 
          WHEN p_type = 'a9'   DISPLAY m_aag02 TO aag02_a9 
          WHEN p_type = 'a10'  DISPLAY m_aag02 TO aag02_a10
          WHEN p_type = 'a11'  DISPLAY m_aag02 TO aag02_a11
          WHEN p_type = 'a12'  DISPLAY m_aag02 TO aag02_a12
# No.FUN-680088 ---end---
          OTHERWISE EXIT CASE
         END CASE
   END IF
END FUNCTION
