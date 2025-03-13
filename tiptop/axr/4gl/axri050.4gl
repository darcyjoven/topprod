# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
#Pattern name..:"axri050.4gl"
#Descriptions..: 聯盟卡卡種對應科目維護作業
#Date & Author..:10/01/04 By lutingting   #FUN-9C0168
# Modify.........: No.TQC-B10145 11/01/14 By shenyang 修改bug 
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ood           DYNAMIC ARRAY OF RECORD
        ood01       LIKE ood_file.ood01,
        ood01_desc  LIKE rxw_file.rxw02,
        ood02       LIKE ood_file.ood02,
        ood02_desc  LIKE aag_file.aag02,
        ood03       LIKE ood_file.ood03,
        ood03_desc  LIKE aag_file.aag02
                    END RECORD,
    g_ood_t         RECORD
        ood01       LIKE ood_file.ood01,
        ood01_desc  LIKE rxw_file.rxw02,
        ood02       LIKE ood_file.ood02,
        ood02_desc  LIKE aag_file.aag02,
        ood03       LIKE ood_file.ood03,
        ood03_desc  LIKE aag_file.aag02
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5, 
    l_ac            LIKE type_file.num5  
 
DEFINE g_forupd_sql STRING   
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5   
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE p_row,p_col       LIKE type_file.num5  
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
    OPEN WINDOW axri050_w AT p_row,p_col WITH FORM "axr/42f/axri050"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
 
    CALL cl_ui_init()
 
    IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("ood03,ood03_desc",FALSE)
    END IF

    LET g_wc2 = '1=1' CALL i050_b_fill(g_wc2)
    CALL i050_menu()
    CLOSE WINDOW axri050_w     
      CALL  cl_used(g_prog,g_time,2) 
         RETURNING g_time 
END MAIN
 
FUNCTION i050_menu()
 DEFINE l_cmd   LIKE type_file.chr1000   
   WHILE TRUE
      CALL i050_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i050_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i050_b()
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
               IF g_ood[l_ac].ood01 IS NOT NULL THEN
                  LET g_doc.column1 = "ood01"
                  LET g_doc.value1 = g_ood[l_ac].ood01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ood),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i050_q()
   CALL i050_b_askkey()
END FUNCTION
 
FUNCTION i050_ood02(p_cmd)         
DEFINE    l_ood02_desc  LIKE aag_file.aag02,  
          p_cmd         LIKE type_file.chr1
#TQC-B10145--add--begin
DEFINE    l_aag07    LIKE aag_file.aag07 
DEFINE    l_aag03    LIKE aag_file.aag03 
DEFINE    l_aag09    LIKE aag_file.aag09 
DEFINE    l_aagacti  LIKE aag_file.aagacti
  LET g_errno = ''
#TQC-B10145--add----end 
  SELECT aag02,aag07,aag03,aag09,aagacti INTO l_ood02_desc,l_aag07,l_aag03,l_aag09,l_aagacti  FROM aag_file   #TQC-B10145
   WHERE aag00=g_aza.aza81 AND aag01 = g_ood[l_ac].ood02 AND aagacti='Y'
#TQC-B10145--add--begin
    CASE WHEN STATUS=100         LET g_errno='agl-001'  
                                 LET g_ood[l_ac].ood02_desc = NULL
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
         WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE
#TQC-B10145--add----end 
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_ood[l_ac].ood02_desc = l_ood02_desc
     DISPLAY BY NAME g_ood[l_ac].ood02_desc
  END IF
 
END FUNCTION
 
FUNCTION i050_ood03(p_cmd)         
DEFINE    l_ood03_desc  LIKE aag_file.aag02,  
          p_cmd         LIKE type_file.chr1
#TQC-B10145--add--begin
DEFINE    l_aag07    LIKE aag_file.aag07
DEFINE    l_aag03    LIKE aag_file.aag03
DEFINE    l_aag09    LIKE aag_file.aag09
DEFINE    l_aagacti  LIKE aag_file.aagacti
  LET g_errno = ''
#TQC-B10145--add----end 
  SELECT aag02,aag07,aag03,aag09,aagacti  INTO l_ood03_desc,l_aag07,l_aag03,l_aag09,l_aagacti  FROM aag_file   #TQC-B10145
   WHERE aag00=g_aza.aza82 AND aag01 = g_ood[l_ac].ood03 AND aagacti='Y'
#TQC-B10145--add--begin
    CASE WHEN STATUS=100         LET g_errno='agl-001'
                                 LET g_ood[l_ac].ood03_desc = NULL
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
         WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE
#TQC-B10145--add----end 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_ood[l_ac].ood03_desc = l_ood03_desc
     DISPLAY BY NAME g_ood[l_ac].ood03_desc
  END IF
 
END FUNCTION
 
FUNCTION i050_ood01(p_cmd)
DEFINE l_ood01_desc LIKE rxw_file.rxw02
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_rxwacti    LIKE rxw_file.rxwacti     #TQC-B10145
   LET g_errno = ''
  SELECT rxw02,rxwacti INTO l_ood01_desc,l_rxwacti  FROM rxw_file
   WHERE rxw01 = g_ood[l_ac].ood01 AND rxwacti = 'Y'
#TQC-B10145--add--begin
    CASE WHEN STATUS=100         LET g_errno='agl-001'
                                 LET g_ood[l_ac].ood01_desc = NULL
        WHEN l_rxwacti='N'      LET g_errno='9028'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE
#TQC-B10145--add----end
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_ood[l_ac].ood01_desc = l_ood01_desc
     DISPLAY BY NAME g_ood[l_ac].ood01_desc
  END IF 
END FUNCTION

FUNCTION i050_b()
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
 
   LET g_forupd_sql = "SELECT ood01,'',ood02,'',ood03,'' ",
                      "  FROM ood_file WHERE ood01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i050_bcl CURSOR FROM g_forupd_sql 
 
   INPUT ARRAY g_ood WITHOUT DEFAULTS FROM s_ood.*
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
             LET g_ood_t.* = g_ood[l_ac].*
 
             LET g_before_input_done = FALSE                                                                                      
             CALL i050_set_entry(p_cmd)                                                                                           
             CALL i050_set_no_entry(p_cmd)                                                                                        
             LET g_before_input_done = TRUE
             BEGIN WORK
             OPEN i050_bcl USING g_ood_t.ood01
             IF STATUS THEN
                CALL cl_err("OPEN i050_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i050_bcl INTO g_ood[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ood_t.ood01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL i050_ood02('a')
                CALL i050_ood03('a')
                CALL i050_ood01('a')
             END IF
             CALL cl_show_fld_cont()  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                       
          LET g_before_input_done = FALSE                                                                                         
          CALL i050_set_entry(p_cmd)                                                                                              
          CALL i050_set_no_entry(p_cmd)                                                                                           
          LET g_before_input_done = TRUE
          INITIALIZE g_ood[l_ac].* TO NULL 
          LET g_ood_t.* = g_ood[l_ac].*   
          CALL cl_show_fld_cont()   
          NEXT FIELD ood01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i050_bcl
             CANCEL INSERT
          END IF
          INSERT INTO ood_file(ood01,ood02,ood03)
          VALUES(g_ood[l_ac].ood01,g_ood[l_ac].ood02,g_ood[l_ac].ood03)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ood_file",g_ood[l_ac].ood01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD ood01  
          IF NOT cl_null(g_ood[l_ac].ood01) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ood[l_ac].ood01!=g_ood_t.ood01) THEN
                SELECT COUNT(*) INTO l_n FROM ood_file WHERE ood01 = g_ood[l_ac].ood01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_ood[l_ac].ood01 = g_ood_t.ood01
                   NEXT FIELD ood01
                ELSE
                   SELECT COUNT(*) INTO l_n FROM rxw_file 
                    WHERE rxw01 = g_ood[l_ac].ood01 AND rxwacti = 'Y'
                   IF l_n>0 THEN
                      CALL i050_ood01('a') 
                      #TQC-B10145--add--begin
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)
                         NEXT FIELD ood01
                      END IF
                      #TQC-B10145--add--end 
                   ELSE
                      CALL cl_err('','axr-962',0)
                      LET g_ood[l_ac].ood01=g_ood_t.ood01
                      DISPLAY BY NAME g_ood[l_ac].ood01
                      NEXT FIELD ood01
                   END IF 
                END IF
             END IF
          END IF
 
        AFTER FIELD ood02
           IF NOT cl_null(g_ood[l_ac].ood02) THEN
             #Mark No.FUN-B10048  在i050_ood02()中已有判断
             #SELECT COUNT(*) INTO l_n FROM aag_file
             # WHERE aag00=g_aza.aza81 AND aag01=g_ood[l_ac].ood02 AND aagacti='Y'
             #IF l_n>0 THEN
             #End Mark No.FUN-B10048
                 CALL i050_ood02('a') 
                 #TQC-B10145--add--begin
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #Add No.FUN-B10048
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.construct = 'N'
                    LET g_qryparam.arg1 = g_aza.aza81
                    LET g_qryparam.default1 = g_ood[l_ac].ood02
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '4' AND aag09='Y' AND aag01 LIKE '",g_ood[l_ac].ood02 CLIPPED,"%'"
                    CALL cl_create_qry() RETURNING g_ood[l_ac].ood02
                    DISPLAY BY NAME g_ood[l_ac].ood02
                    #End Add No.FUN-B10048
                    NEXT FIELD ood02
                 END IF
                 #TQC-B10145--add--end 
             #Mark No.FUN-B10048
             #ELSE
             #   CALL cl_err('','afa-025',0)
             #   LET g_ood[l_ac].ood02=g_ood_t.ood02
             #   DISPLAY BY NAME g_ood[l_ac].ood02
             #   NEXT FIELD ood02
             #END IF
             #End Mark No.FUN-B10048
           END IF
 
        AFTER FIELD ood03
           IF NOT cl_null(g_ood[l_ac].ood03) THEN
             #Mark No.FUN-B10048 i050_ood03()中已经判断
             #SELECT COUNT(*) INTO l_n FROM aag_file 
             # WHERE aag00=g_aza.aza82 AND aag01=g_ood[l_ac].ood03 AND aagacti='Y'
             #IF l_n>0 THEN
             #End Mark No.FUN-B10048
                 CALL i050_ood03('a')
                 #TQC-B10145--add--begin
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #Add No.FUN-B10048
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.construct = 'N'
                    LET g_qryparam.arg1 = g_aza.aza82
                    LET g_qryparam.default1 = g_ood[l_ac].ood03
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 != '4' AND aag09='Y' AND aag01 LIKE '",g_ood[l_ac].ood03 CLIPPED,"%'"
                    CALL cl_create_qry() RETURNING g_ood[l_ac].ood03
                    DISPLAY BY NAME g_ood[l_ac].ood03
                    #End Add No.FUN-B10048
                    NEXT FIELD ood03
                 END IF
                 #TQC-B10145--add--end 
             #Mark No.FUN-B10048
             #ELSE
             #   CALL cl_err('','afa-025',0)
             #   LET g_ood[l_ac].ood03=g_ood_t.ood03
             #   DISPLAY BY NAME g_ood[l_ac].ood03
             #   NEXT FIELD ood03
             #END IF
             #End Mark No.FUN-B10048
           END IF
 
       BEFORE DELETE     
          IF g_ood_t.ood01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "ood01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_ood[l_ac].ood01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM ood_file WHERE ood01 = g_ood_t.ood01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ood_file",g_ood_t.ood01,"",SQLCA.sqlcode,"","",1) 
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
             LET g_ood[l_ac].* = g_ood_t.*
             CLOSE i050_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_ood[l_ac].ood01,-263,0)
             LET g_ood[l_ac].* = g_ood_t.*
          ELSE
             UPDATE ood_file SET ood01=g_ood[l_ac].ood01,
                                 ood02=g_ood[l_ac].ood02,
                                 ood03=g_ood[l_ac].ood03
              WHERE ood01 = g_ood_t.ood01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ood_file",g_ood_t.ood01,"",SQLCA.sqlcode,"","",1) 
                LET g_ood[l_ac].* = g_ood_t.*
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
                LET g_ood[l_ac].* = g_ood_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_ood.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t 
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE i050_bcl    
             ROLLBACK WORK   
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032        
 
          CLOSE i050_bcl    
          COMMIT WORK
 

       ON ACTION CONTROLO            
          IF INFIELD(ood01) AND l_ac > 1 THEN
             LET g_ood[l_ac].* = g_ood[l_ac-1].*
             NEXT FIELD ood01
          END IF
 
       ON ACTION controlp
        CASE
           WHEN INFIELD(ood01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rxw"
              LET g_qryparam.default1 = g_ood[l_ac].ood01
              CALL cl_create_qry() RETURNING g_ood[l_ac].ood01
              DISPLAY BY NAME g_ood[l_ac].ood01
              NEXT FIELD ood01
           WHEN INFIELD(ood02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.arg1 = g_aza.aza81
              LET g_qryparam.default1 = g_ood[l_ac].ood02
              CALL cl_create_qry() RETURNING g_ood[l_ac].ood02
              DISPLAY BY NAME g_ood[l_ac].ood02
              NEXT FIELD ood02
           WHEN INFIELD(ood03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.arg1 = g_aza.aza82
              LET g_qryparam.default1 = g_ood[l_ac].ood03
              CALL cl_create_qry() RETURNING g_ood[l_ac].ood03
              DISPLAY BY NAME g_ood[l_ac].ood03
              NEXT FIELD ood03
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
 
   CLOSE i050_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i050_b_askkey()
 
   CLEAR FORM
   CALL g_ood.clear()
   CONSTRUCT g_wc2 ON ood01,ood02,ood03
        FROM s_ood[1].ood01,s_ood[1].ood02,s_ood[1].ood03
 
 
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
           WHEN INFIELD(ood01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ood01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ood01
              NEXT FIELD ood01 
           WHEN INFIELD(ood02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ood02"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_aza.aza81
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ood02
              NEXT FIELD ood02
           WHEN INFIELD(ood03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ood03"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_aza.aza82
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ood03
              NEXT FIELD ood03
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
 
   CALL i050_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i050_b_fill(p_wc2)   
DEFINE
    p_wc2           LIKE type_file.chr1000 
 
    LET g_sql =
        "SELECT ood01,'',ood02,'',ood03,'' ",
        " FROM ood_file ",
        " WHERE ", p_wc2 CLIPPED,      
        " ORDER BY 1"
    PREPARE i050_pb FROM g_sql
    DECLARE ood_curs CURSOR FOR i050_pb
 
    CALL g_ood.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ood_curs INTO g_ood[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT rxw02 INTO g_ood[g_cnt].ood01_desc FROM rxw_file
         WHERE rxw01=g_ood[g_cnt].ood01
        SELECT aag02 INTO g_ood[g_cnt].ood02_desc FROM aag_file
         WHERE aag00=g_aza.aza81 AND aag01 = g_ood[g_cnt].ood02 AND aagacti = 'Y'
        SELECT aag02 INTO g_ood[g_cnt].ood03_desc FROM aag_file 
         WHERE aag00=g_aza.aza81 AND aag01 = g_ood[g_cnt].ood03 AND aagacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ood.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i050_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ood TO s_ood.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i050_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("ood01",TRUE)
        END IF
END FUNCTION
 
FUNCTION i050_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ood01",FALSE)
        END IF
END FUNCTION
#FUN-9C0168 
