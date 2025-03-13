# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# PROG. VERSION..: '5.30.01-11.07.23(00000)'     #
#
# PATTERN NAME...: aqci106.4gl
# DESCRIPTIONS...: QC結果判定關聯設定作業
# DATE & AUTHOR..: NO.FUN-BC0104 11/12/30 By xujing 
# Modify.........: No:FUN-C20047 11/12/30
# Modify.........: No:TQC-C20143 12/02/23 By xujing 修改p_query查詢單ID
# Modify.........: No:MOD-C30094 12/03/09 By xujing 處理倉庫欄位控管
# Modify.........: No:FUN-CC0013 13/01/11 By Lori pcl05移除3.驗退/重工項目
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
        g_qcl      DYNAMIC ARRAY OF RECORD
           qcl01     LIKE qcl_file.qcl01,
           qcl02     LIKE qcl_file.qcl02,
           qcl05     LIKE qcl_file.qcl05,
           qcl03     LIKE qcl_file.qcl03,
           qcl04     LIKE qcl_file.qcl04,
           qcl06     LIKE qcl_file.qcl06,
           qcl07     LIKE qcl_file.qcl07
                      END RECORD,
        g_qcl_t                     RECORD
           qcl01     LIKE qcl_file.qcl01,
           qcl02     LIKE qcl_file.qcl02,
           qcl05     LIKE qcl_file.qcl05,
           qcl03     LIKE qcl_file.qcl03,
           qcl04     LIKE qcl_file.qcl04,
           qcl06     LIKE qcl_file.qcl06,
           qcl07     LIKE qcl_file.qcl07
                      END RECORD,
        g_wc2,g_sql       LIKE type_file.chr1000,
        g_rec_b             LIKE type_file.num5,                    
        l_ac                LIKE type_file.num5                           
DEFINE  g_forupd_sql        STRING         
DEFINE  g_cnt               LIKE type_file.num10    
DEFINE  g_i                 LIKE type_file.num5             
DEFINE  g_before_input_done LIKE type_file.num5 
DEFINE  g_qcz14             LIKE qcz_file.qcz14

MAIN
    OPTIONS                               
        INPUT NO WRAP    
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF

   SELECT qcz14 INTO g_qcz14 FROM qcz_file
      WHERE qcz00 = '0' 
   IF g_qcz14 = 'N' THEN 
      CALL cl_err('','aqc-065',1)
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
    
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
   OPEN WINDOW i106_w WITH FORM "aqc/42f/aqci106"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
    LET g_wc2 = ' 1=1' 
    CALL i106_b_fill(g_wc2)
    CALL i106_menu()
    CLOSE WINDOW i106_w                  
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN

FUNCTION i106_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i106_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i106_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i106_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN                                                
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' 
               END IF          
               LET l_cmd = 'p_query "aqci106" "',g_wc2 CLIPPED,'"'  #TQC-C20143 
               CALL cl_cmdrun(l_cmd)                                
            END IF

         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_qcl[l_ac].qcl01 IS NOT NULL THEN
                  LET g_doc.column1 = "qcl01"
                  LET g_doc.value1 = g_qcl[l_ac].qcl01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create
(g_qcl),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i106_q()
   CALL i106_b_askkey()
END FUNCTION

#單身
FUNCTION i106_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                      
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                   
   p_cmd           LIKE type_file.chr1,                     
   l_allow_insert  LIKE type_file.chr1,               
   l_allow_delete  LIKE type_file.chr1,                
   l_n             LIKE type_file.num5, 
   l_flag          LIKE type_file.chr1
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   MESSAGE " "
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT qcl01,qcl02,qcl05,qcl03,qcl04,",
                      "  qcl06,qcl07",  
                      "  FROM qcl_file WHERE qcl01= ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i106_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_qcl WITHOUT DEFAULTS FROM s_qcl.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert) 
 
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
             BEGIN WORK
             LET p_cmd='u'                                                                                                       
             LET g_qcl_t.* = g_qcl[l_ac].*  
             OPEN i106_bcl USING g_qcl[l_ac].qcl01

             IF STATUS THEN
                CALL cl_err("OPEN i106_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i106_bcl INTO g_qcl[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_qcl_t.qcl01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()
             CALL i106_set_entry_qcl06()   
            #CALL i106_set_noentry_qcl06()    #FUN-CC0013 mark
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i106_set_entry(p_cmd)                                            
          CALL i106_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_qcl[l_ac].* TO NULL   
          LET g_qcl_t.* = g_qcl[l_ac].*         
          CALL cl_show_fld_cont()  
          LET g_qcl[l_ac].qcl03 = 'Y'  
          LET g_qcl[l_ac].qcl04 = 'Y'
          LET g_qcl[l_ac].qcl05 = '0'
          NEXT FIELD qcl01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i106_bcl
             CANCEL INSERT
          END IF
          IF cl_null(g_qcl[l_ac].qcl07) THEN
              LET g_qcl[l_ac].qcl07 = " "
          END IF
          #FUN-CC0013 mark begin---
          #IF g_qcl[l_ac].qcl05 = '3' THEN
          #   IF cl_null(g_qcl[l_ac].qcl06) THEN
          #       LET g_qcl[l_ac].qcl06 = " "
          #   END IF
          #END IF
          #FUN-CC0013 mark end-----
 
          INSERT INTO qcl_file(qcl01,qcl02,qcl03,
                                   qcl04,qcl05,qcl06,qcl07)   
          VALUES(g_qcl[l_ac].qcl01,
                 g_qcl[l_ac].qcl02,g_qcl[l_ac].qcl03,
                 g_qcl[l_ac].qcl04,g_qcl[l_ac].qcl05,
                 g_qcl[l_ac].qcl06,g_qcl[l_ac].qcl07)  
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","qcl_file",g_qcl
[l_ac].qcl01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       AFTER FIELD  qcl01      
           LET l_n1 = 0
           IF NOT cl_null(g_qcl[l_ac].qcl01) THEN
                 IF g_qcl_t.qcl01 IS NULL 
                    OR g_qcl[l_ac].qcl01!=g_qcl_t.qcl01 THEN 
                       IF NOT i106_qcl01_check() THEN
                          NEXT FIELD qcl01
                       END IF 
                 END IF 
           END IF      
 
        BEFORE FIELD qcl05
           CALL i106_set_entry_qcl06() 

        AFTER FIELD qcl05
           LET l_n2 = 0
           IF NOT cl_null(g_qcl[l_ac].qcl05) AND g_qcl[l_ac].qcl05 = '1' THEN
              IF g_sma.sma116 = '0' THEN
                 CALL cl_err('','aqc-121',1)
              END IF
           END IF
           IF NOT cl_null(g_qcl[l_ac].qcl06) THEN
              IF g_qcl[l_ac].qcl05 = '0' OR g_qcl[l_ac].qcl05 = '1' THEN
                 CALL i106_qcl06_check() RETURNING l_n2
                 IF l_n2 > 0 THEN 
                    CALL cl_err('','aqc-067',0)
                    NEXT FIELD qcl06
                 END IF
              END IF
              IF g_qcl[l_ac].qcl05 = '2' THEN 
                 CALL i106_qcl06_check() RETURNING l_n2
                 IF l_n2 = 0 THEN
                    CALL cl_err('','aqc-068',0)
                    NEXT FIELD qcl06
                 END IF
              END IF  
           END IF
          #CALL i106_set_noentry_qcl06()    #FUN-CC0013 mark

        #MOD-C30094---add---str---
       AFTER FIELD qcl03
          LET l_n1=0
          IF NOT cl_null(g_qcl[l_ac].qcl06) THEN
             CALL i106_qcl06_imd_chk() RETURNING l_n1
             IF l_n1 = 0 THEN
                CALL cl_err('','aqc-524',0)
                NEXT FIELD qcl03
             END IF
          END IF
        
       AFTER FIELD qcl04
          LET l_n1=0
          IF NOT cl_null(g_qcl[l_ac].qcl06) THEN
             CALL i106_qcl06_imd_chk() RETURNING l_n1
             IF l_n1 = 0 THEN
                CALL cl_err('','aqc-524',0)
                NEXT FIELD qcl04
             END IF
          END IF
        #MOD-C30094---add---end---
         
        AFTER FIELD qcl06
           LET l_n1 = 0
           LET l_n2 = 0
           IF NOT cl_null(g_qcl[l_ac].qcl06) THEN
             #MOD-C30094---mark---str---
             #SELECT COUNT(*) INTO l_n1 FROM imd_file 
             #   WHERE imd01=g_qcl[l_ac].qcl06 AND imdacti='Y'
             #     AND imd11=g_qcl[l_ac].qcl03 AND imd12=g_qcl[l_ac].qcl04  
             #MOD-C30094---mark---end---
              CALL i106_qcl06_imd_chk() RETURNING l_n1       #MOD-C30094 
              IF l_n1 = 0 THEN 
                 CALL cl_err('','aqc-524',0)
                 NEXT FIELD qcl06
              END IF
              CALL s_chk_ware(g_qcl[l_ac].qcl06) RETURNING l_flag 
              IF l_flag = 0 THEN
                 CALL cl_err('','aqc-066',0)
                 NEXT FIELD qcl06
              END IF
              IF g_qcl[l_ac].qcl05 = '0' OR g_qcl[l_ac].qcl05 = '1' THEN
                 CALL i106_qcl06_check() RETURNING l_n2
                 IF l_n2 > 0 THEN 
                    CALL cl_err('','aqc-067',0)
                    NEXT FIELD qcl06
                 END IF
              END IF
              IF g_qcl[l_ac].qcl05 = '2' THEN 
                 CALL i106_qcl06_check() RETURNING l_n2
                 IF l_n2 = 0 THEN
                    CALL cl_err('','aqc-068',0)
                    NEXT FIELD qcl06
                 END IF
              END IF    
           END IF
        AFTER FIELD qcl07 
           IF cl_null(g_qcl[l_ac].qcl07) THEN
              LET g_qcl[l_ac].qcl07 = " "
           END IF 

        ON CHANGE qcl05
           #FUN-CC0013 mark begin---
           #IF NOT cl_null(g_qcl[l_ac].qcl05) AND g_qcl[l_ac].qcl05 = '3' THEN
           #   CALL cl_set_comp_entry("qcl06,qcl07",FALSE)
           #   LET g_qcl[l_ac].qcl06 = ' '
           #   LET g_qcl[l_ac].qcl07 = ' '
           #   LET g_qcl[l_ac].qcl03 = 'N'
           #   LET g_qcl[l_ac].qcl04 = 'N'
           #ELSE
           #FUN-CC0013 mark end-----
              CALL cl_set_comp_entry("qcl03,qcl04,qcl06,qcl07",TRUE) 
              LET g_qcl[l_ac].qcl06 = g_qcl_t.qcl06
              LET g_qcl[l_ac].qcl07 = g_qcl_t.qcl07
           #END IF     #FUN-CC0013 mark 

       BEFORE DELETE                           
          IF g_qcl_t.qcl01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL               
             LET g_doc.column1 = "qcl01"              
             LET g_doc.value1 = g_qcl[l_ac].qcl01     
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 

             DELETE FROM qcl_file 
             WHERE qcl01 = g_qcl_t.qcl01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","qcl_file",g_qcl_t.qcl01,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_qcl[l_ac].* = g_qcl_t.*
             CLOSE i106_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_qcl[l_ac].qcl01,-263,0)
             LET g_qcl[l_ac].* = g_qcl_t.*
          ELSE
             UPDATE qcl_file SET    qcl01=g_qcl[l_ac].qcl01,
                                    qcl02=g_qcl[l_ac].qcl02,
                                    qcl03=g_qcl[l_ac].qcl03,
                                    qcl04=g_qcl[l_ac].qcl04,
                                    qcl05=g_qcl[l_ac].qcl05,
                                    qcl06=g_qcl[l_ac].qcl06,
                                    qcl07=g_qcl[l_ac].qcl07
              WHERE qcl01 = g_qcl_t.qcl01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","qcl_file",g_qcl_t.qcl01,"",SQLCA.sqlcode,"","",1)
                LET g_qcl[l_ac].* = g_qcl_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            
       #  LET l_ac_t = l_ac   #FUN-D30034            
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'a' THEN 
                CALL g_qcl.deleteElement(l_ac)
           #FUN-D30034--add--str--
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30034--add--end--
             END IF 
             IF p_cmd='u' THEN
                LET g_qcl[l_ac].* = g_qcl_t.*
             END IF
             CLOSE i106_bcl           
             ROLLBACK WORK             
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30034 
          CLOSE i106_bcl               
          COMMIT WORK
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(qcl06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_imd"
                    LET g_qryparam.arg1 = 'SW'
                    IF g_qcl[l_ac].qcl05 = '0' OR g_qcl[l_ac].qcl05 = '1' THEN
                       LET g_qryparam.where = "imd11='",g_qcl[l_ac].qcl03,"' AND imd12='",g_qcl[l_ac].qcl04,
                                              "' AND imd01 NOT IN (SELECT jce02 FROM jce_file)"
                    END IF
                    IF g_qcl[l_ac].qcl05 = '2' THEN
                       LET g_qryparam.where = "imd11='",g_qcl[l_ac].qcl03,"' AND imd12='",g_qcl[l_ac].qcl04, 
                                              "' AND imd01 IN (SELECT jce02 FROM jce_file)"
                    END IF
                    CALL cl_create_qry() RETURNING g_qcl[l_ac].qcl06
                    DISPLAY BY NAME g_qcl[l_ac].qcl06
                    NEXT FIELD qcl06                 
           END CASE
                      
       ON ACTION CONTROLO                       
          IF INFIELD(qcl01) AND l_ac > 1 THEN
              LET g_qcl[l_ac].* = g_qcl[l_ac-1].*
              NEXT FIELD qcl01
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
         RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION HELP         
         CALL cl_show_help()  
 
       
   END INPUT
 
   CLOSE i106_bcl
   COMMIT WORK
 
END FUNCTION

FUNCTION i106_b_askkey()
 
   CLEAR FORM
   CALL g_qcl.clear()
   LET l_ac =1
   CONSTRUCT g_wc2 ON qcl01,qcl02,qcl05,
                      qcl03,qcl04,qcl06,
                      qcl07
        FROM s_qcl[1].qcl01,
             s_qcl[1].qcl02,s_qcl[1].qcl05,
             s_qcl[1].qcl03,
             s_qcl[1].qcl04,
             s_qcl[1].qcl06,s_qcl[1].qcl07
             
 
    BEFORE CONSTRUCT
      CALL cl_qbe_init()
                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION HELP          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask() 
         
      ON ACTION CONTROLP
          CASE         
            WHEN INFIELD(qcl06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd"
                 LET g_qryparam.state='c'
                 LET g_qryparam.arg1 ='SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qcl06
                 NEXT FIELD qcl06     
          END CASE
          
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(NULL, NULL) 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i106_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i106_b_fill(p_wc2)             
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT qcl01,qcl02,qcl05,qcl03,qcl04,",
        " qcl06,qcl07",
        " FROM qcl_file ",
        " WHERE ", g_wc2 CLIPPED,       
        " ORDER BY qcl01"
    PREPARE i106_pb FROM g_sql
    DECLARE qcl_curs CURSOR FOR i106_pb
 
    CALL g_qcl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH qcl_curs INTO g_qcl[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_qcl.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i106_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcl TO s_qcl.* ATTRIBUTE(COUNT=g_rec_b)
 
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

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION CANCEL
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
 
 
FUNCTION i106_qcl01_check()
    DEFINE   l_n       LIKE type_file.num5
    LET l_n = 0

       SELECT COUNT(*) INTO l_n FROM qcl_file
       WHERE qcl01 = g_qcl[l_ac].qcl01
       IF l_n>0 THEN      
         CALL cl_err('','aqc-064',0)               
        RETURN FALSE
       END IF 
 RETURN TRUE     
END FUNCTION

FUNCTION i106_set_entry_qcl06()
    CALL cl_set_comp_entry("qcl03,qcl04,qcl06,qcl07",TRUE)
END FUNCTION

#FUN-CC0013 mark begin---
#FUNCTION i106_set_noentry_qcl06()
#   IF l_ac > 0 THEN
#      IF NOT cl_null(g_qcl[l_ac].qcl05) AND g_qcl[l_ac].qcl05 = '3' THEN
#         CALL cl_set_comp_entry("qcl03,qcl04,qcl06,qcl07",FALSE)
#         LET g_qcl[l_ac].qcl03 = 'N'
#         LET g_qcl[l_ac].qcl04 = 'N'
#      END IF
#   END IF
#END FUNCTION
#FUN-CC0013 mark end-----

FUNCTION i106_qcl06_check()
  DEFINE l_n LIKE type_file.num5
     SELECT COUNT(*) INTO l_n FROM jce_file
                    WHERE jce02 = g_qcl[l_ac].qcl06
     RETURN l_n
END FUNCTION 
                                                
FUNCTION i106_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                   
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("qcl01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i106_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("qcl01",FALSE)                                      
   END IF
                                                                          
END FUNCTION                                                          
#FUN-C20047
#MOD-C30094---add---str---
FUNCTION i106_qcl06_imd_chk()
DEFINE l_n LIKE type_file.num5

  LET l_n=0
  SELECT COUNT(*) INTO l_n FROM imd_file
     WHERE imd01=g_qcl[l_ac].qcl06 AND imdacti='Y'
       AND imd11=g_qcl[l_ac].qcl03 AND imd12=g_qcl[l_ac].qcl04
  RETURN l_n
END FUNCTION
#MOD-C30094---add---end---


