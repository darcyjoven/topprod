# Prog. Version..: '5.20.02-10.08.05(00000)'     #
#
# Pattern name...: abai.4gl
# Descriptions...: 条码参数设定
# Date & Author..: 2015-08-25 14:50:56  shenran 
# Modify.........: No.MOD-150930 15/09/30 By caohp 增加完工入库单别
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_tc_codesys           RECORD LIKE tc_codesys_file.*,
        g_tc_codesys_t         RECORD LIKE tc_codesys_file.*,   # 參數檔
        g_tc_codesys_o         RECORD LIKE tc_codesys_file.*    # 參數檔
DEFINE g_forupd_sql        STRING 
DEFINE g_chr1       LIKE  type_file.chr1
DEFINE g_t1         LIKE  rva_file.rva01

MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL abai(0,0)
END MAIN  
 
FUNCTION abai(p_row,p_col)
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
 
    OPEN WINDOW abai_w AT p_row,p_col
      WITH FORM "aba/42f/abai503" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL abai_show()
 
    LET g_action_choice=""
    CALL abai_menu()
 
    CLOSE WINDOW abai_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION abai_show()
 
    SELECT * INTO g_tc_codesys.* FROM tc_codesys_file WHERE tc_codesys00 = '0'
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_codesys_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    DISPLAY BY NAME g_tc_codesys.tc_codesys01,g_tc_codesys.tc_codesys02,g_tc_codesys.tc_codesys03,
                    g_tc_codesys.tc_codesys04,g_tc_codesys.tc_codesys05,g_tc_codesys.tc_codesys06,       #No.MOD-150930 add g_tc_codesys.tc_codesys06 by caohp 150930
                    g_tc_codesys.tc_codesys07,g_tc_codesys.tc_codesys08,g_tc_codesys.tc_codesys09,
                    g_tc_codesys.tc_codesys10,g_tc_codesys.tc_codesys11,g_tc_codesys.tc_codesys12,
                    g_tc_codesys.tc_codesys13
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION abai_menu()
    MENU ""
         ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
              CALL abai_u()
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
 
 
FUNCTION abai_u()
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT *  FROM tc_codesys_file WHERE tc_codesys00 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE tc_srm_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
 
    OPEN tc_srm_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH tc_srm_curl INTO g_tc_codesys.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_tc_codesys_t.* = g_tc_codesys.*
    LET g_tc_codesys_o.* = g_tc_codesys.*
    DISPLAY BY NAME g_tc_codesys.tc_codesys01,g_tc_codesys.tc_codesys02,g_tc_codesys.tc_codesys03,
                    g_tc_codesys.tc_codesys04,g_tc_codesys.tc_codesys05,g_tc_codesys.tc_codesys06,       #No.MOD-150930 add g_tc_codesys.tc_codesys06 by caohp 150930
                    g_tc_codesys.tc_codesys07,g_tc_codesys.tc_codesys08,g_tc_codesys.tc_codesys09,
                    g_tc_codesys.tc_codesys10,g_tc_codesys.tc_codesys11,g_tc_codesys.tc_codesys12,
                    g_tc_codesys.tc_codesys13
                    
    WHILE TRUE
        CALL abai_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        UPDATE tc_codesys_file SET
                tc_codesys01=g_tc_codesys.tc_codesys01,
                tc_codesys02=g_tc_codesys.tc_codesys02,
                tc_codesys03=g_tc_codesys.tc_codesys03,
                tc_codesys04=g_tc_codesys.tc_codesys04,
                tc_codesys05=g_tc_codesys.tc_codesys05,
                tc_codesys06=g_tc_codesys.tc_codesys06,   #No.MOD-150930 add by caohp 150930
                tc_codesys07=g_tc_codesys.tc_codesys07,
                tc_codesys08=g_tc_codesys.tc_codesys08,
                tc_codesys09=g_tc_codesys.tc_codesys09,
                tc_codesys10=g_tc_codesys.tc_codesys10,
                tc_codesys11=g_tc_codesys.tc_codesys11,
                tc_codesys12=g_tc_codesys.tc_codesys12,
                tc_codesys13=g_tc_codesys.tc_codesys13
                WHERE tc_codesys00='0'
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_codesys_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        UNLOCK TABLE tc_codesys_file
        EXIT WHILE
    END WHILE
    CLOSE tc_srm_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION abai_i()
  DEFINE li_result  LIKE  type_file.num5
  DEFINE l_result   BOOLEAN
  
   INPUT BY NAME  g_tc_codesys.tc_codesys01,g_tc_codesys.tc_codesys02,g_tc_codesys.tc_codesys03,
                  g_tc_codesys.tc_codesys04,g_tc_codesys.tc_codesys05,g_tc_codesys.tc_codesys06,
                  g_tc_codesys.tc_codesys07,g_tc_codesys.tc_codesys08,g_tc_codesys.tc_codesys09,
                  g_tc_codesys.tc_codesys10,g_tc_codesys.tc_codesys11,g_tc_codesys.tc_codesys12,
                  g_tc_codesys.tc_codesys13     #No.MOD-150930 add g_tc_codesys.tc_codesys06 by caohp 150930
                 WITHOUT DEFAULTS  
 
      AFTER FIELD tc_codesys01
           CALL s_check_no("apm",g_tc_codesys.tc_codesys01,g_tc_codesys.tc_codesys01,'3',"rva_file","rva01","")
             RETURNING li_result,g_tc_codesys.tc_codesys01
           DISPLAY BY NAME g_tc_codesys.tc_codesys01
           IF (NOT li_result) THEN
             NEXT FIELD tc_codesys01
           END IF
 
      AFTER FIELD tc_codesys02
           CALL s_check_no("apm",g_tc_codesys.tc_codesys02,g_tc_codesys.tc_codesys02,'3',"rva_file","rva01","")
             RETURNING li_result,g_tc_codesys.tc_codesys02
           DISPLAY BY NAME g_tc_codesys.tc_codesys02
           IF (NOT li_result) THEN
             NEXT FIELD tc_codesys02
           END IF
      AFTER FIELD tc_codesys03
           CALL s_check_no("asf",g_tc_codesys.tc_codesys03,g_tc_codesys.tc_codesys03,'3',"sfp_file","sfp01","")
            RETURNING li_result,g_tc_codesys.tc_codesys03
            DISPLAY BY NAME g_tc_codesys.tc_codesys03
            IF (NOT li_result) THEN
               LET g_tc_codesys.tc_codesys03=g_tc_codesys_o.tc_codesys03
               NEXT FIELD tc_codesys03
            END IF
      AFTER FIELD tc_codesys04
           CALL s_check_no("aim",g_tc_codesys.tc_codesys04,g_tc_codesys.tc_codesys04,'2',"ina_file","ina01","")
            RETURNING li_result,g_tc_codesys.tc_codesys04
            DISPLAY BY NAME g_tc_codesys.tc_codesys04
            IF (NOT li_result) THEN
               LET g_tc_codesys.tc_codesys04=g_tc_codesys_o.tc_codesys04
               NEXT FIELD tc_codesys04
            END IF  
      AFTER FIELD tc_codesys05
           CALL s_check_no("aim",g_tc_codesys.tc_codesys05,g_tc_codesys.tc_codesys05,'1',"ina_file","ina01","")
            RETURNING li_result,g_tc_codesys.tc_codesys05
            DISPLAY BY NAME g_tc_codesys.tc_codesys05
            IF (NOT li_result) THEN
               LET g_tc_codesys.tc_codesys05=g_tc_codesys_o.tc_codesys05
               NEXT FIELD tc_codesys05
            END IF
      #No.MOD-150930 str:add by caohp 150930
      AFTER FIELD tc_codesys06
           CALL s_check_no("asf",g_tc_codesys.tc_codesys06,g_tc_codesys.tc_codesys06,"A","sfu_file","sfu01","")
            RETURNING li_result,g_tc_codesys.tc_codesys06
            DISPLAY BY NAME g_tc_codesys.tc_codesys06
            IF (NOT li_result) THEN
               LET g_tc_codesys.tc_codesys06=g_tc_codesys_o.tc_codesys06
               NEXT FIELD tc_codesys06
            END IF
      #No.MOD-150930 end:add by caohp 150930
      #add by shenran 2016-04-05 10:14:53  str
      AFTER FIELD tc_codesys07
           CALL s_check_no("aim",g_tc_codesys.tc_codesys07,g_tc_codesys.tc_codesys07,"4","ima_file","ima01","")
            RETURNING li_result,g_tc_codesys.tc_codesys07
            DISPLAY BY NAME g_tc_codesys.tc_codesys07
            IF (NOT li_result) THEN
               LET g_tc_codesys.tc_codesys07=g_tc_codesys_o.tc_codesys07
               NEXT FIELD tc_codesys07
            END IF
      #add by shenran 2016-04-05 10:15:11 end
      #add by shenran 2016/5/12 9:28:37  str
      AFTER FIELD tc_codesys08
           CALL s_check_no("axm",g_tc_codesys.tc_codesys08,g_tc_codesys.tc_codesys08,"50","oga_file","oga01","")
            RETURNING li_result,g_tc_codesys.tc_codesys08
            DISPLAY BY NAME g_tc_codesys.tc_codesys08
            IF (NOT li_result) THEN
               LET g_tc_codesys.tc_codesys08=g_tc_codesys_o.tc_codesys08
               NEXT FIELD tc_codesys08
            END IF
      #add by shenran 2016/5/12 9:28:43 end      
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
         
       ON ACTION controlp
          CASE
             WHEN INFIELD(tc_codesys01) #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_tc_codesys.tc_codesys01)       #No.FUN-540027
                 CALL q_smy(FALSE,FALSE,g_t1,'APM','3') RETURNING g_t1 
                 LET g_tc_codesys.tc_codesys01=g_t1         #No.FUN-540027
                 DISPLAY BY NAME g_tc_codesys.tc_codesys01
                 NEXT FIELD tc_codesys01
             WHEN INFIELD(tc_codesys02) #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_tc_codesys.tc_codesys02)       #No.FUN-540027
                 CALL q_smy(FALSE,FALSE,g_t1,'APM','3') RETURNING g_t1 
                 LET g_tc_codesys.tc_codesys02=g_t1         #No.FUN-540027
                 DISPLAY BY NAME g_tc_codesys.tc_codesys02
                 NEXT FIELD tc_codesys02 
             WHEN INFIELD(tc_codesys03) # Class
                   LET g_t1=s_get_doc_no(g_tc_codesys.tc_codesys03)     #No.FUN-550052
                   CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
                   LET g_tc_codesys.tc_codesys03 = g_t1                 #No.FUN-550052
                   DISPLAY BY NAME g_tc_codesys.tc_codesys03
                   NEXT FIELD tc_codesys03  
             WHEN INFIELD(tc_codesys04) # Class
                   LET g_t1=s_get_doc_no(g_tc_codesys.tc_codesys04)     #No.FUN-550052
                   CALL q_smy( FALSE, TRUE,g_t1,'AIM','2') RETURNING g_t1  #TQC-670008
                   LET g_tc_codesys.tc_codesys04 = g_t1                 #No.FUN-550052
                   DISPLAY BY NAME g_tc_codesys.tc_codesys04
                   NEXT FIELD tc_codesys04
             WHEN INFIELD(tc_codesys05) # Class
                   LET g_t1=s_get_doc_no(g_tc_codesys.tc_codesys05)     #No.FUN-550052
                   CALL q_smy( FALSE, TRUE,g_t1,'AIM','1') RETURNING g_t1  #TQC-670008
                   LET g_tc_codesys.tc_codesys05 = g_t1                 #No.FUN-550052
                   DISPLAY BY NAME g_tc_codesys.tc_codesys05
                   NEXT FIELD tc_codesys05
             #No.MOD-150930 str:add by caohp 150930
             WHEN INFIELD(tc_codesys06)
                   LET g_t1=s_get_doc_no(g_tc_codesys.tc_codesys06)     #No.FUN-550052
                   CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  #TQC-670008
                   LET g_tc_codesys.tc_codesys06 = g_t1                 #No.FUN-550052
                   DISPLAY BY NAME g_tc_codesys.tc_codesys06
                   NEXT FIELD tc_codesys06
             #No.MOD-150930 end:add by caohp 150930   
             #add by shenran 2016-04-05 10:18:48 str
             WHEN INFIELD(tc_codesys07)
                   LET g_t1=s_get_doc_no(g_tc_codesys.tc_codesys07)     #No.FUN-550052
                   CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1   #TQC-670008
                   LET g_tc_codesys.tc_codesys07 = g_t1                 #No.FUN-550052
                   DISPLAY BY NAME g_tc_codesys.tc_codesys07
                   NEXT FIELD tc_codesys07
             #add by shenran 2016-04-05 10:18:48 end  
             #add by shenran 2016-04-05 10:18:48 str
             WHEN INFIELD(tc_codesys08)
                   LET g_t1=s_get_doc_no(g_tc_codesys.tc_codesys08)     #No.FUN-550052
                   CALL q_oay(FALSE,FALSE,g_t1,'50','AXM') RETURNING g_t1  #TQC-670008 remark
                   LET g_tc_codesys.tc_codesys08 = g_t1                 #No.FUN-550052
                   DISPLAY BY NAME g_tc_codesys.tc_codesys08
                   NEXT FIELD tc_codesys08
             #add by shenran 2016-04-05 10:18:48 end                          
             OTHERWISE EXIT CASE
           END CASE               
          
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

