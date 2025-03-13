# Prog. Version..: '5.20.02-10.08.05(00000)'     #
#
# Pattern name...: abai504.4gl
# Descriptions...: 条码参数设定
# Date & Author..: 2015-08-25 14:50:56  shenran 
# Modify.........: No.MOD-150930 15/09/30 By caohp 增加完工入库单别
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_tc_ver           RECORD LIKE tc_ver_file.*,
        g_tc_ver_t         RECORD LIKE tc_ver_file.*,   # 參數檔
        g_tc_ver_o         RECORD LIKE tc_ver_file.*    # 參數檔
DEFINE g_forupd_sql        STRING 
DEFINE g_chr1       LIKE  type_file.chr1
DEFINE g_t1         LIKE  rva_file.rva01

MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL abai504(0,0)
END MAIN  
 
FUNCTION abai504(p_row,p_col)
    DEFINE
        p_row,p_col LIKE type_file.num5     #No.FUN-690010 tc_srmLLINT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ABA")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
    LET p_row = 4 LET p_col = 31
 
    OPEN WINDOW abai504_w AT p_row,p_col
      WITH FORM "aba/42f/abai504" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL abai504_show()
 
    LET g_action_choice=""
    CALL abai504_menu()
 
    CLOSE WINDOW abai504_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION abai504_show()
 
    SELECT * INTO g_tc_ver.* FROM tc_ver_file WHERE tc_ver00 = '0'
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_ver_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    DISPLAY BY NAME g_tc_ver.tc_ver01,g_tc_ver.tc_ver02,g_tc_ver.tc_ver03,
                    g_tc_ver.tc_ver04,g_tc_ver.tc_ver05,g_tc_ver.tc_ver06,       #No.MOD-150930 add g_tc_ver.tc_ver06 by caohp 150930
                    g_tc_ver.tc_ver07
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION abai504_menu()
    MENU ""
         ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
              CALL abai504_u()
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
    
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION abai504_u()
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT *  FROM tc_ver_file WHERE tc_ver00 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE tc_srm_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
 
    OPEN tc_srm_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH tc_srm_curl INTO g_tc_ver.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_tc_ver_t.* = g_tc_ver.*
    LET g_tc_ver_o.* = g_tc_ver.*
    DISPLAY BY NAME g_tc_ver.tc_ver01,g_tc_ver.tc_ver02,g_tc_ver.tc_ver03,
                    g_tc_ver.tc_ver04,g_tc_ver.tc_ver05,g_tc_ver.tc_ver06,       #No.MOD-150930 add g_tc_ver.tc_ver06 by caohp 150930
                    g_tc_ver.tc_ver07
                    
    WHILE TRUE
        CALL abai504_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        UPDATE tc_ver_file SET
                tc_ver01=g_tc_ver.tc_ver01,
                tc_ver02=g_tc_ver.tc_ver02,
                tc_ver03=g_tc_ver.tc_ver03,
                tc_ver04=g_tc_ver.tc_ver04,
                tc_ver05=g_tc_ver.tc_ver05,
                tc_ver06=g_tc_ver.tc_ver06,   #No.MOD-150930 add by caohp 150930
                tc_ver07=g_tc_ver.tc_ver07
                WHERE tc_ver00='0'
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_ver_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        UNLOCK TABLE tc_ver_file
        EXIT WHILE
    END WHILE
    CLOSE tc_srm_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION abai504_i()
  DEFINE li_result  LIKE  type_file.num5
  DEFINE l_result   BOOLEAN
  
   INPUT BY NAME  g_tc_ver.tc_ver01,g_tc_ver.tc_ver02,g_tc_ver.tc_ver03,
                  g_tc_ver.tc_ver04,g_tc_ver.tc_ver05,g_tc_ver.tc_ver06,
                  g_tc_ver.tc_ver07     #No.MOD-150930 add g_tc_ver.tc_ver06 by caohp 150930
                 WITHOUT DEFAULTS  
 
      AFTER FIELD tc_ver01

 
      AFTER FIELD tc_ver02

      AFTER FIELD tc_ver03

      AFTER FIELD tc_ver04

      AFTER FIELD tc_ver05

      AFTER FIELD tc_ver06

      AFTER FIELD tc_ver07

#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
         
#      ON ACTION controlp
#          CASE
#             WHEN INFIELD(tc_ver01) #查詢單據性質
#                 LET g_t1 = s_get_doc_no(g_tc_ver.tc_ver01)       #No.FUN-540027
#                 CALL q_smy(FALSE,FALSE,g_t1,'APM','3') RETURNING g_t1 
#                 LET g_tc_ver.tc_ver01=g_t1         #No.FUN-540027
#                 DISPLAY BY NAME g_tc_ver.tc_ver01
#                 NEXT FIELD tc_ver01
#             WHEN INFIELD(tc_ver02) #查詢單據性質
#                 LET g_t1 = s_get_doc_no(g_tc_ver.tc_ver02)       #No.FUN-540027
#                 CALL q_smy(FALSE,FALSE,g_t1,'APM','3') RETURNING g_t1 
#                 LET g_tc_ver.tc_ver02=g_t1         #No.FUN-540027
#                 DISPLAY BY NAME g_tc_ver.tc_ver02
#                 NEXT FIELD tc_ver02 
#             WHEN INFIELD(tc_ver03) # Class
#                   LET g_t1=s_get_doc_no(g_tc_ver.tc_ver03)     #No.FUN-550052
#                   CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
#                   LET g_tc_ver.tc_ver03 = g_t1                 #No.FUN-550052
#                   DISPLAY BY NAME g_tc_ver.tc_ver03
#                   NEXT FIELD tc_ver03  
#             WHEN INFIELD(tc_ver04) # Class
#                   LET g_t1=s_get_doc_no(g_tc_ver.tc_ver04)     #No.FUN-550052
#                   CALL q_smy( FALSE, TRUE,g_t1,'AIM','2') RETURNING g_t1  #TQC-670008
#                   LET g_tc_ver.tc_ver04 = g_t1                 #No.FUN-550052
#                   DISPLAY BY NAME g_tc_ver.tc_ver04
#                   NEXT FIELD tc_ver04
#             WHEN INFIELD(tc_ver05) # Class
#                   LET g_t1=s_get_doc_no(g_tc_ver.tc_ver05)     #No.FUN-550052
#                   CALL q_smy( FALSE, TRUE,g_t1,'AIM','1') RETURNING g_t1  #TQC-670008
#                   LET g_tc_ver.tc_ver05 = g_t1                 #No.FUN-550052
#                   DISPLAY BY NAME g_tc_ver.tc_ver05
#                   NEXT FIELD tc_ver05
#             #No.MOD-150930 str:add by caohp 150930
#             WHEN INFIELD(tc_ver06)
#                   LET g_t1=s_get_doc_no(g_tc_ver.tc_ver06)     #No.FUN-550052
#                   CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  #TQC-670008
#                   LET g_tc_ver.tc_ver06 = g_t1                 #No.FUN-550052
#                   DISPLAY BY NAME g_tc_ver.tc_ver06
#                   NEXT FIELD tc_ver06
#             #No.MOD-150930 end:add by caohp 150930   
#             #add by shenran 2016-04-05 10:18:48 str
#             WHEN INFIELD(tc_ver07)
#                   LET g_t1=s_get_doc_no(g_tc_ver.tc_ver07)     #No.FUN-550052
#                   CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1   #TQC-670008
#                   LET g_tc_ver.tc_ver07 = g_t1                 #No.FUN-550052
#                   DISPLAY BY NAME g_tc_ver.tc_ver07
#                   NEXT FIELD tc_ver07
#             #add by shenran 2016-04-05 10:18:48 end               
#             OTHERWISE EXIT CASE
#           END CASE               
          
      ON ACTION CONTROLZ
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

