# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
#Pattern name..:"axri070.4gl"
#Descriptions..: 券種科目維護作業
#Date & Author..:10/06/17 By lutingting   #FUN-A60052
# Modify.........: No.TQC-B10145 11/01/14 By shenyang 修改bug 
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oog           DYNAMIC ARRAY OF RECORD
        oog01       LIKE oog_file.oog01,    #券類型編號
        oog01_desc  LIKE lpx_file.lpx02,    #券類型名稱
        oog02       LIKE oog_file.oog02,    #會計科目
        oog02_desc  LIKE aag_file.aag02,    #會計科目名稱
        oog03       LIKE oog_file.oog03,    #會計科目二
        oog03_desc  LIKE aag_file.aag02     #會計科目二名稱
                    END RECORD,
    g_oog_t         RECORD
        oog01       LIKE oog_file.oog01,    #券類型編號
        oog01_desc  LIKE lpx_file.lpx02,    #券類型名稱
        oog02       LIKE oog_file.oog02,    #會計科目
        oog02_desc  LIKE aag_file.aag02,    #會計科目名稱
        oog03       LIKE oog_file.oog03,    #會計科目二
        oog03_desc  LIKE aag_file.aag02     #會計科目二名稱
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5, 
    l_ac            LIKE type_file.num5  
 
DEFINE g_forupd_sql        STRING   
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5   
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE p_row,p_col         LIKE type_file.num5  
DEFINE l_cmd               LIKE type_file.chr1000
 
MAIN
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT    
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)  
         RETURNING g_time  
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW axri070_w AT p_row,p_col WITH FORM "axr/42f/axri070"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
 
    CALL cl_ui_init()
 
    IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("oog03,oog03_desc",FALSE)
    END IF

    LET g_wc2 = '1=1' CALL i070_b_fill(g_wc2)
    CALL i070_menu()
    CLOSE WINDOW axri070_w     
      CALL  cl_used(g_prog,g_time,2) 
         RETURNING g_time 
END MAIN
 
FUNCTION i070_menu()
 DEFINE l_cmd   LIKE type_file.chr1000   
   WHILE TRUE
      CALL i070_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i070_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i070_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_oog[l_ac].oog01 IS NOT NULL THEN
                  LET g_doc.column1 = "oog01"
                  LET g_doc.value1 = g_oog[l_ac].oog01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oog),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i070_q()
   CALL i070_b_askkey()
END FUNCTION
 
FUNCTION i070_oog02(p_cmd)         
DEFINE    l_oog02_desc  LIKE aag_file.aag02,  
          p_cmd         LIKE type_file.chr1,
          l_aagacti     LIKE aag_file.aagacti
#TQC-B10145--add--begin
DEFINE    l_aag07    LIKE aag_file.aag07 
DEFINE    l_aag03    LIKE aag_file.aag03 
DEFINE    l_aag09    LIKE aag_file.aag09 
#TQC-B10145--add----end 
  LET g_errno = ''     #TQC-B10145
  SELECT aag02,aag07,aag03,aag09,aagacti INTO l_oog02_desc,l_aag07,l_aag03,l_aag09,l_aagacti FROM aag_file # TQC-B10145
   WHERE aag00=g_aza.aza81 AND aag01 = g_oog[l_ac].oog02 
#TQC-B10145--mark--begin 
#  CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-088' 
#                              LET l_oog02_desc = NULL
#       WHEN l_aagacti='N'     LET g_errno='9028'
#       OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#  END CASE
#TQC-B10145--mark--end
#TQC-B10145--add--begin
    CASE WHEN STATUS=100         LET g_errno='agl-001'  
                                 LET l_oog02_desc = NULL
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
         WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE
#TQC-B10145--add----end
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_oog[l_ac].oog02_desc = l_oog02_desc
     DISPLAY BY NAME g_oog[l_ac].oog02_desc
  END IF
 
END FUNCTION
 
FUNCTION i070_oog03(p_cmd)         
DEFINE    l_oog03_desc  LIKE aag_file.aag02,  
          p_cmd         LIKE type_file.chr1,
          l_aagacti     LIKE aag_file.aagacti
#TQC-B10145--add--begin
DEFINE    l_aag07    LIKE aag_file.aag07
DEFINE    l_aag03    LIKE aag_file.aag03
DEFINE    l_aag09    LIKE aag_file.aag09
#TQC-B10145--add----end
  LET g_errno = ''     #TQC-B10145
  SELECT aag02,aag07,aag03,aag09,aagacti INTO l_oog03_desc,l_aag07,l_aag03,l_aag09,l_aagacti FROM aag_file  # TQC-B10145
   WHERE aag00=g_aza.aza82 AND aag01 = g_oog[l_ac].oog03 
#TQC-B10145--mark--begin 
#  CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-088'
#                              LET l_oog03_desc = NULL
#       WHEN l_aagacti='N'     LET g_errno='9028'
#       OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#  END CASE
#TQC-B10145--mark--END
#TQC-B10145--add--begin
    CASE WHEN STATUS=100         LET g_errno='agl-001'
                                 LET l_oog03_desc = NULL
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
         WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE
#TQC-B10145--add----end
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_oog[l_ac].oog03_desc = l_oog03_desc
     DISPLAY BY NAME g_oog[l_ac].oog03_desc
  END IF
 
END FUNCTION
 
FUNCTION i070_oog01(p_cmd)
DEFINE l_oog01_desc LIKE lpx_file.lpx02
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_lpxacti      LIKE lpx_file.lpxacti #TQC-B10145
  LET g_errno = ''     #TQC-B10145
  SELECT lpx02,lpxacti  INTO l_oog01_desc,l_lpxacti  FROM lpx_file    #TQC-B10145
   WHERE lpx01 = g_oog[l_ac].oog01 AND lpxacti = 'Y'
     AND lpx15 = 'Y'
#TQC-B10145--add--begin
    CASE WHEN STATUS=100         LET g_errno='agl-001'
                                 LET l_oog01_desc = NULL
        WHEN l_lpxacti='N'      LET g_errno='9028'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE
#TQC-B10145--add----end
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_oog[l_ac].oog01_desc = l_oog01_desc
     DISPLAY BY NAME g_oog[l_ac].oog01_desc
  END IF 
END FUNCTION

FUNCTION i070_b()
DEFINE
   l_ac_t          LIKE type_file.num5, 
   l_n             LIKE type_file.num5, 
   l_lock_sw       LIKE type_file.chr1, 
   p_cmd           LIKE type_file.chr1, 
   l_allow_insert  LIKE type_file.chr1, 
   l_allow_delete  LIKE type_file.chr1   
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT oog01,'',oog02,'',oog03,'' ",
                      "  FROM oog_file WHERE oog01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i070_bcl CURSOR FROM g_forupd_sql 
 
   INPUT ARRAY g_oog WITHOUT DEFAULTS FROM s_oog.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'     
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             LET p_cmd='u'
             LET g_oog_t.* = g_oog[l_ac].*
 
             LET g_before_input_done = FALSE                                                                                      
             CALL i070_set_entry(p_cmd)                                                                                           
             CALL i070_set_no_entry(p_cmd)                                                                                        
             LET g_before_input_done = TRUE
             BEGIN WORK
             OPEN i070_bcl USING g_oog_t.oog01
             IF STATUS THEN
                CALL cl_err("OPEN i070_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i070_bcl INTO g_oog[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_oog_t.oog01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL i070_oog02('a')
                CALL i070_oog03('a')
                CALL i070_oog01('a')
             END IF
             CALL cl_show_fld_cont()  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                       
          LET g_before_input_done = FALSE                                                                                         
          CALL i070_set_entry(p_cmd)                                                                                              
          CALL i070_set_no_entry(p_cmd)                                                                                           
          LET g_before_input_done = TRUE
          INITIALIZE g_oog[l_ac].* TO NULL 
          LET g_oog_t.* = g_oog[l_ac].*   
          CALL cl_show_fld_cont()   
          NEXT FIELD oog01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i070_bcl
             CANCEL INSERT
          END IF
          INSERT INTO oog_file(oog01,oog02,oog03)
          VALUES(g_oog[l_ac].oog01,g_oog[l_ac].oog02,g_oog[l_ac].oog03)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","oog_file",g_oog[l_ac].oog01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD oog01  
          IF NOT cl_null(g_oog[l_ac].oog01) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_oog[l_ac].oog01!=g_oog_t.oog01) THEN
                SELECT COUNT(*) INTO l_n FROM oog_file WHERE oog01 = g_oog[l_ac].oog01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_oog[l_ac].oog01 = g_oog_t.oog01
                   NEXT FIELD oog01
                ELSE
                   SELECT COUNT(*) INTO l_n FROM lpx_file 
                    WHERE lpx01 = g_oog[l_ac].oog01 AND lpxacti = 'Y'
                      AND lpx15 = 'Y'
                   IF l_n>0 THEN
                      CALL i070_oog01('a')
                      #TQC-B10145--add--begin
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)   
                         NEXT FIELD oog01 
                      END IF
                      #TQC-B10145--add--end
                   ELSE
                      CALL cl_err('','axr-963',0)
                      LET g_oog[l_ac].oog01=g_oog_t.oog01
                      DISPLAY BY NAME g_oog[l_ac].oog01
                      NEXT FIELD oog01
                   END IF 
                END IF
             END IF
          END IF
 
        AFTER FIELD oog02
           IF NOT cl_null(g_oog[l_ac].oog02) THEN
             #Mark No.FUN-B10048 在i070_oog02()中已经判断
             #SELECT COUNT(*) INTO l_n FROM aag_file
             # WHERE aag00=g_aza.aza81 AND aag01=g_oog[l_ac].oog02 AND aagacti='Y'
             #IF l_n>0 THEN
             #End Mark No.FUN-B10048
                 CALL i070_oog02('a')
                 #TQC-B10145--add--begin
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)   
                    #Add No.FUN-B10048
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.construct = 'N'
                    LET g_qryparam.arg1 = g_aza.aza81
                    LET g_qryparam.default1 = g_oog[l_ac].oog02
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '4' AND aag09='Y' AND aag01 LIKE '",g_oog[l_ac].oog02 CLIPPED,"%'"
                    CALL cl_create_qry() RETURNING g_oog[l_ac].oog02
                    DISPLAY BY NAME g_oog[l_ac].oog02
                    #End Add No.FUN-B10048
                    NEXT FIELD oog02 
                 END IF
                #TQC-B10145--add--end 
             #Mark No.FUN-B10048
             #ELSE
             #   CALL cl_err('','afa-025',0)
             #   LET g_oog[l_ac].oog02=g_oog_t.oog02
             #   DISPLAY BY NAME g_oog[l_ac].oog02
             #   NEXT FIELD oog02
             #END IF
             #End Mark No.FUN-B10048
           END IF
 
        AFTER FIELD oog03
           IF NOT cl_null(g_oog[l_ac].oog03) THEN
             #Mark No.FUN-B10048 在i070_oog03()中已经判断
             #SELECT COUNT(*) INTO l_n FROM aag_file 
             # WHERE aag00=g_aza.aza82 AND aag01=g_oog[l_ac].oog03 AND aagacti='Y'
             #IF l_n>0 THEN
             #End Mark No.FUN-B10048
                 CALL i070_oog03('a')
                 #TQC-B10145--add--begin
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #Add No.FUN-B10048
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.construct = 'N'
                    LET g_qryparam.arg1 = g_aza.aza82
                    LET g_qryparam.default1 = g_oog[l_ac].oog03
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '4' AND aag09='Y' AND aag01 LIKE '",g_oog[l_ac].oog03 CLIPPED,"%'"
                    CALL cl_create_qry() RETURNING g_oog[l_ac].oog03
                    DISPLAY BY NAME g_oog[l_ac].oog03
                    #End Add No.FUN-B10048
                    NEXT FIELD oog03
                 END IF
                 #TQC-B10145--add--end 
             #Mark No.FUN-B10048
             #ELSE
             #   CALL cl_err('','afa-025',0)
             #   LET g_oog[l_ac].oog03=g_oog_t.oog03
             #   DISPLAY BY NAME g_oog[l_ac].oog03
             #   NEXT FIELD oog03
             #END IF
             #End Mark No.FUN-B10048
           END IF
 
       BEFORE DELETE     
          IF g_oog_t.oog01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "oog01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_oog[l_ac].oog01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM oog_file WHERE oog01 = g_oog_t.oog01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","oog_file",g_oog_t.oog01,"",SQLCA.sqlcode,"","",1) 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN     
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_oog[l_ac].* = g_oog_t.*
             CLOSE i070_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_oog[l_ac].oog01,-263,0)
             LET g_oog[l_ac].* = g_oog_t.*
          ELSE
             UPDATE oog_file SET oog01=g_oog[l_ac].oog01,
                                 oog02=g_oog[l_ac].oog02,
                                 oog03=g_oog[l_ac].oog03
              WHERE oog01 = g_oog_t.oog01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","oog_file",g_oog_t.oog01,"",SQLCA.sqlcode,"","",1) 
                LET g_oog[l_ac].* = g_oog_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()      
          #LET l_ac_t = l_ac  #FUN-D30032       
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_oog[l_ac].* = g_oog_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_oog.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE i070_bcl    
             ROLLBACK WORK   
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032       
 
          CLOSE i070_bcl    
          COMMIT WORK
 

       ON ACTION CONTROLO            
          IF INFIELD(oog01) AND l_ac > 1 THEN
             LET g_oog[l_ac].* = g_oog[l_ac-1].*
             NEXT FIELD oog01
          END IF
 
       ON ACTION controlp
        CASE
           WHEN INFIELD(oog01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpx01_1"
              LET g_qryparam.default1 = g_oog[l_ac].oog01
              CALL cl_create_qry() RETURNING g_oog[l_ac].oog01
              DISPLAY BY NAME g_oog[l_ac].oog01
              NEXT FIELD oog01
           WHEN INFIELD(oog02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.arg1 = g_aza.aza81
              LET g_qryparam.default1 = g_oog[l_ac].oog02
              CALL cl_create_qry() RETURNING g_oog[l_ac].oog02
              DISPLAY BY NAME g_oog[l_ac].oog02
              NEXT FIELD oog02
           WHEN INFIELD(oog03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.arg1 = g_aza.aza82
              LET g_qryparam.default1 = g_oog[l_ac].oog03
              CALL cl_create_qry() RETURNING g_oog[l_ac].oog03
              DISPLAY BY NAME g_oog[l_ac].oog03
              NEXT FIELD oog03
           OTHERWISE
              EXIT CASE
        END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about    
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help() 
 
       
   END INPUT
 
   CLOSE i070_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i070_b_askkey()
 
   CLEAR FORM
   CALL g_oog.clear()
   CONSTRUCT g_wc2 ON oog01,oog02,oog03
        FROM s_oog[1].oog01,s_oog[1].oog02,s_oog[1].oog03
 
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about      
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(oog01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oog01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oog01
              NEXT FIELD oog01 
           WHEN INFIELD(oog02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oog02"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_aza.aza81
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oog02
              NEXT FIELD oog02
           WHEN INFIELD(oog03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oog03"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_aza.aza82
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oog03
              NEXT FIELD oog03
           OTHERWISE
              EXIT CASE
        END CASE
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i070_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i070_b_fill(p_wc2)   
DEFINE
    p_wc2           LIKE type_file.chr1000 
 
    LET g_sql =
        "SELECT oog01,'',oog02,'',oog03,'' ",
        " FROM oog_file ",
        " WHERE ", p_wc2 CLIPPED,      
        " ORDER BY 1"
    PREPARE i070_pb FROM g_sql
    DECLARE oog_curs CURSOR FOR i070_pb
 
    CALL g_oog.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH oog_curs INTO g_oog[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT lpx02 INTO g_oog[g_cnt].oog01_desc FROM lpx_file
         WHERE lpx01=g_oog[g_cnt].oog01
        SELECT aag02 INTO g_oog[g_cnt].oog02_desc FROM aag_file
         WHERE aag00=g_aza.aza81 AND aag01 = g_oog[g_cnt].oog02 AND aagacti = 'Y'
        SELECT aag02 INTO g_oog[g_cnt].oog03_desc FROM aag_file 
         WHERE aag00=g_aza.aza81 AND aag01 = g_oog[g_cnt].oog03 AND aagacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oog.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i070_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oog TO s_oog.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about       
         CALL cl_about()  
 
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i070_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("oog01",TRUE)
        END IF
END FUNCTION
 
FUNCTION i070_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("oog01",FALSE)
        END IF
END FUNCTION
#FUN-A60052
