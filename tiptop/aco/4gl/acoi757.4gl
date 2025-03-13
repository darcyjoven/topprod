# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: acoi757.4gl
# Descriptions...: 料件歸併後資料維護
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ceh           DYNAMIC ARRAY OF RECORD   
        ceh00       LIKE ceh_file.ceh00,   
        ceh01       LIKE ceh_file.ceh01,   
        ceh04       LIKE ceh_file.ceh04,   
        ceh02       LIKE ceh_file.ceh02,  
        ceh03       LIKE ceh_file.ceh03, 
        ceh05       LIKE ceh_file.ceh05,   
        ceh06       LIKE ceh_file.ceh06,  
        ceh07       LIKE ceh_file.ceh07,   
        ceh08       LIKE ceh_file.ceh08,   
        ceh09       LIKE ceh_file.ceh09,   
        ceh10       LIKE ceh_file.ceh10,   
        ceh11       LIKE ceh_file.ceh11,   
        ceh12       LIKE ceh_file.ceh12,    
        cehacti     LIKE ceh_file.cehacti
                    END RECORD,
    g_ceh_t         RECORD                 
        ceh00       LIKE ceh_file.ceh00,   #
        ceh01       LIKE ceh_file.ceh01,   
        ceh04       LIKE ceh_file.ceh04,   
        ceh02       LIKE ceh_file.ceh02,   
        ceh03       LIKE ceh_file.ceh03,   
        ceh05       LIKE ceh_file.ceh05,   
        ceh06       LIKE ceh_file.ceh06,   
        ceh07       LIKE ceh_file.ceh07,   
        ceh08       LIKE ceh_file.ceh08,   
        ceh09       LIKE ceh_file.ceh09,   
        ceh10       LIKE ceh_file.ceh10,   
        ceh11       LIKE ceh_file.ceh11,   
        ceh12       LIKE ceh_file.ceh12,
        cehacti     LIKE ceh_file.cehacti   
                    END RECORD,
    g_wc,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,            
    l_ac            LIKE type_file.num5            
DEFINE   g_before_input_done  LIKE type_file.num5 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5   
DEFINE   g_msg           LIKE ze_file.ze03    
 
 
MAIN
    OPTIONS                                
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)  RETURNING  g_time
 
   OPEN WINDOW i757_w WITH FORM "aco/42f/acoi757"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_set_comp_visible("ceh06", FALSE)  
   CALL cl_ui_init()
 
   LET g_wc = '1=1' 
   CALL i757_b_fill(g_wc)   
   CALL i757_menu()
 
   CLOSE WINDOW i757_w 

   CALL cl_used(g_prog,g_time,2)   RETURNING g_time
END MAIN
 
 
FUNCTION i757_menu()
 
   WHILE TRUE
      CALL i757_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i757_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i757_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ceh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i757_q()
   CALL i757_b_askkey()
END FUNCTION
 
 
FUNCTION i757_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       
    l_n             LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,    
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,    
    l_acti          LIKE ceg_file.cegacti
DEFINE l_cnt        LIKE type_file.num10               
DEFINE l_retrunno   LIKE type_file.chr1               
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ceh00,ceh01,ceh04,",
                       "       ceh02,ceh03,ceh05,ceh06,",
                       "       ceh07,ceh08,ceh09,ceh10,",
                       "       ceh11,ceh12,cehacti ",
                       "  FROM ceh_file",
                       " WHERE ceh00 = ? AND ceh01=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i757_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ceh WITHOUT DEFAULTS FROM s_ceh.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
       
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           CALL i757_set_required()    
           
       BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         DISPLAY l_ac TO FORMONLY.cnt  
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_ceh_t.* = g_ceh[l_ac].*  #BACKUP
            LET  g_before_input_done = FALSE                                                                                     
            CALL i757_set_entry(p_cmd)                                                                                           
            CALL i757_set_no_entry(p_cmd)                                                                                        
            LET  g_before_input_done = TRUE                                                                                      
 
            BEGIN WORK
            OPEN i757_bcl USING g_ceh_t.ceh00,g_ceh_t.ceh01
            IF STATUS THEN
               CALL cl_err("OPEN i757_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i757_bcl INTO g_ceh[l_ac].* 
               IF STATUS THEN
                  CALL cl_err(g_ceh_t.ceh01,STATUS,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           IF cl_null(g_ceh[l_ac].ceh01) OR 
              cl_null(g_ceh[l_ac].ceh00) THEN
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_ceh[l_ac].ceh07) AND
              g_ceh[l_ac].ceh08 <= 0 THEN
              CALL cl_err('','mfg9243',0)
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_ceh[l_ac].ceh09) AND
              g_ceh[l_ac].ceh10 <= 0 THEN
              CALL cl_err('','mfg9243',0)
              CANCEL INSERT
           END IF
           
 
           INSERT INTO ceh_file(ceh00,ceh01,ceh02,ceh03,
                                ceh04,ceh05,ceh06,ceh07,
                                ceh08,ceh09,ceh10,ceh11,
                                ceh12,
                                cehacti,cehuser,cehgrup,cehdate,cehoriu,cehorig)  
           VALUES(g_ceh[l_ac].ceh00,g_ceh[l_ac].ceh01,
                  g_ceh[l_ac].ceh02,g_ceh[l_ac].ceh03,
                  g_ceh[l_ac].ceh04,g_ceh[l_ac].ceh05,
                  g_ceh[l_ac].ceh06,g_ceh[l_ac].ceh07,
                  g_ceh[l_ac].ceh08,g_ceh[l_ac].ceh09,
                  g_ceh[l_ac].ceh10,g_ceh[l_ac].ceh11,
                  g_ceh[l_ac].ceh12,g_ceh[l_ac].cehacti,
                  g_user,g_grup,g_today, g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
 
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ceh_file",g_ceh[l_ac].ceh01,"", SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cnt  
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET  g_before_input_done = FALSE                                                                                        
           CALL i757_set_entry(p_cmd)                                                                                              
           CALL i757_set_no_entry(p_cmd)                                                                                           
           LET  g_before_input_done = TRUE                                                                                         
           INITIALIZE g_ceh[l_ac].* TO NULL    
           LET g_ceh[l_ac].ceh05 = 0         
           LET g_ceh[l_ac].ceh08 = 1         
           LET g_ceh[l_ac].ceh10 = 1         
           LET g_ceh[l_ac].cehacti = 'Y'
           LET g_ceh_t.* = g_ceh[l_ac].*       
           CALL cl_show_fld_cont()  
           NEXT FIELD ceh00
 
       AFTER FIELD ceh00 
          IF NOT cl_null(g_ceh[l_ac].ceh00) THEN
             IF g_ceh[l_ac].ceh00 NOT MATCHES '[123]' THEN
                NEXT FIELD ceh00
             END IF
             IF (g_ceh[l_ac].ceh00 != g_ceh_t.ceh00) OR cl_null(g_ceh_t.ceh00) THEN
                LET g_ceh[l_ac].ceh04 = NULL
                DISPLAY BY NAME g_ceh[l_ac].ceh04,
                                g_ceh[l_ac].ceh06, 
                                g_ceh[l_ac].ceh07, 
                                g_ceh[l_ac].ceh09 
             END IF
          END IF
 
       AFTER FIELD ceh01             
         IF cl_null(g_ceh[l_ac].ceh01) THEN 
            NEXT FIELD ceh01
         END IF 
         IF NOT cl_null(g_ceh[l_ac].ceh01) THEN
            IF NOT cl_null(g_ceh[l_ac].ceh00) AND
                   (g_ceh[l_ac].ceh01 != g_ceh_t.ceh01 
                    OR p_cmd = 'a') THEN
               CALL i757_chkkey()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ceh[l_ac].ceh01 = g_ceh_t.ceh01
                  NEXT FIELD ceh01
               END IF
              END IF
           END IF
 
 
       AFTER FIELD ceh04 
         IF NOT cl_null(g_ceh[l_ac].ceh04) THEN
            LET l_acti = NULL
 
            SELECT cegacti,ceg08,ceg11,ceg13  
              INTO l_acti,g_ceh[l_ac].ceh06,g_ceh[l_ac].ceh07,g_ceh[l_ac].ceh09 
              FROM ceg_file
             WHERE ceg01 = g_ceh[l_ac].ceh04
               AND ceg00 = g_ceh[l_ac].ceh00 
            IF SQLCA.sqlcode = 100 THEN
               CALL cl_err('','aco-702',1)  #無此海關商品編號，請重新輸入!!
               LET g_ceh[l_ac].ceh04 = g_ceh_t.ceh04
               NEXT FIELD ceh04
            END IF
            IF l_acti = 'N' THEN
               CALL cl_err('','9028',1)
               LET g_ceh[l_ac].ceh04 = g_ceh_t.ceh04
               NEXT FIELD ceh04
            END IF
         END IF
 
       AFTER FIELD ceh05  
         IF NOT cl_null(g_ceh[l_ac].ceh05) THEN
            IF g_ceh[l_ac].ceh05 < 0 THEN
               CALL cl_err('','afa-040',0) 
               LET g_ceh[l_ac].ceh05 = g_ceh_t.ceh05
               NEXT FIELD ceh05
            END IF
         END IF
 
       AFTER FIELD ceh06  
         IF NOT cl_null(g_ceh[l_ac].ceh06) THEN
            CALL i757_unit(g_ceh[l_ac].ceh06)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ceh[l_ac].ceh06 = g_ceh_t.ceh06
               NEXT FIELD ceh06
            END IF  
         END IF
 
       AFTER FIELD ceh07  
          IF NOT cl_null(g_ceh[l_ac].ceh07) THEN
             CALL i757_unit(g_ceh[l_ac].ceh07)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_ceh[l_ac].ceh07 = g_ceh_t.ceh07
                NEXT FIELD ceh07
             END IF  
          END IF
 
       AFTER FIELD ceh08  
          IF NOT cl_null(g_ceh[l_ac].ceh08) THEN
             IF g_ceh[l_ac].ceh08 < 0 THEN
                CALL cl_err('','mfg9243',0)
                LET g_ceh[l_ac].ceh08 = g_ceh_t.ceh08
                NEXT FIELD ceh08
             END IF 
          END IF 
 
       AFTER FIELD ceh09  
          IF NOT cl_null(g_ceh[l_ac].ceh09) THEN
             CALL i757_unit(g_ceh[l_ac].ceh09)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_ceh[l_ac].ceh09 = g_ceh_t.ceh09
                NEXT FIELD ceh09
             END IF  
          END IF
 
       AFTER FIELD ceh10  
          IF NOT cl_null(g_ceh[l_ac].ceh10) THEN
             IF g_ceh[l_ac].ceh10 < 0 THEN
                CALL cl_err('','mfg9243',0)
                LET g_ceh[l_ac].ceh10 = g_ceh_t.ceh10
                NEXT FIELD ceh10
             END IF 
          END IF 
          
       AFTER FIELD ceh12 
          IF NOT cl_null(g_ceh[l_ac].ceh12) THEN
             SELECT COUNT(*) INTO l_n FROM azi_file
              WHERE azi01 = g_ceh[l_ac].ceh12
             IF l_n = 0 THEN
                CALL cl_err('','aap-002',1)
                NEXT FIELD ceh12
             END IF
          END IF
 
       BEFORE DELETE                        
         IF g_ceh_t.ceh01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM ceh_file WHERE ceh00 = g_ceh_t.ceh00
                                   AND ceh01 = g_ceh_t.ceh01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ceh_file",g_ceh_t.ceh00,g_ceh_t.ceh01,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE 
             END IF
             LET g_rec_b = g_rec_b - 1
             DISPLAY g_rec_b TO FORMONLY.cnt 
             MESSAGE "Delete OK"
             CLOSE i757_bcl
             COMMIT WORK
         END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_ceh[l_ac].* = g_ceh_t.*
             CLOSE i757_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
           
          LET l_cnt=0      
          SELECT COUNT(*) INTO l_cnt FROM cei_file 
           WHERE cei11=g_ceh[l_ac].ceh01 
             AND cei01 = g_ceh[l_ac].ceh00
          IF l_cnt>0 THEN
             CALL i757_comp_change(g_ceh[l_ac].ceh02,g_ceh_t.ceh02) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0) #歸併關系表已經引用，不能修改!
                NEXT FIELD ceh02
             END IF
             
             CALL i757_comp_change(g_ceh[l_ac].ceh03,g_ceh_t.ceh03) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh03
             END IF
             
             CALL i757_comp_change(g_ceh[l_ac].ceh04,g_ceh_t.ceh04) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh04
             END IF
 
             CALL i757_comp_change(g_ceh[l_ac].ceh05,g_ceh_t.ceh05) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh05
             END IF
 
             CALL i757_comp_change(g_ceh[l_ac].ceh06,g_ceh_t.ceh06) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh06
             END IF
 
             CALL i757_comp_change(g_ceh[l_ac].ceh07,g_ceh_t.ceh07) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh07
             END IF
 
             CALL i757_comp_change(g_ceh[l_ac].ceh08,g_ceh_t.ceh08) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh08
             END IF
       
             CALL i757_comp_change(g_ceh[l_ac].ceh09,g_ceh_t.ceh09) RETURNING l_retrunno       
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh09
             END IF
 
             CALL i757_comp_change(g_ceh[l_ac].ceh10,g_ceh_t.ceh10) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh10
             END IF
             
             CALL i757_comp_change(g_ceh[l_ac].ceh11,g_ceh_t.ceh11) RETURNING l_retrunno
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh11
             END IF
             
             CALL i757_comp_change(g_ceh[l_ac].ceh12,g_ceh_t.ceh12) RETURNING l_retrunno  
             IF l_retrunno=1 THEN
                CALL cl_err('','aco-703',0)
                NEXT FIELD ceh12
             END IF
          END IF
 
          IF NOT cl_null(g_ceh[l_ac].ceh07) AND g_ceh[l_ac].ceh08 <= 0 THEN
             CALL cl_err('','mfg9243',0)
             NEXT FIELD ceh08
          END IF
          IF NOT cl_null(g_ceh[l_ac].ceh09) AND g_ceh[l_ac].ceh10 <= 0 THEN
             CALL cl_err('','mfg9243',0)
             NEXT FIELD ceh10
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_ceh[l_ac].ceh01,-263,1)
             LET g_ceh[l_ac].* = g_ceh_t.*
          ELSE
             IF g_ceh[l_ac].ceh00 != g_ceh_t.ceh00 OR
               (g_ceh[l_ac].ceh01 != g_ceh_t.ceh01) THEN
                CALL i757_chkkey()
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_ceh[l_ac].* = g_ceh_t.*
                END IF
             END IF
             UPDATE ceh_file 
                SET ceh00=g_ceh[l_ac].ceh00,
                    ceh01=g_ceh[l_ac].ceh01,
                    ceh02=g_ceh[l_ac].ceh02,
                    ceh03=g_ceh[l_ac].ceh03,
                    ceh04=g_ceh[l_ac].ceh04,
                    ceh05=g_ceh[l_ac].ceh05,
                    ceh06=g_ceh[l_ac].ceh06,
                    ceh07=g_ceh[l_ac].ceh07,
                    ceh08=g_ceh[l_ac].ceh08,
                    ceh09=g_ceh[l_ac].ceh09,
                    ceh10=g_ceh[l_ac].ceh10,
                    ceh11=g_ceh[l_ac].ceh11,
                    ceh12=g_ceh[l_ac].ceh12,
                    cehacti=g_ceh[l_ac].cehacti,
                    cehmodu=g_user,
                    cehdate=g_today 
              WHERE ceh00 = g_ceh_t.ceh00
                AND ceh01 = g_ceh_t.ceh01
 
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ceh_file",g_ceh[l_ac].ceh00,g_ceh[l_ac].ceh01,SQLCA.sqlcode,"","",1)  
                 LET g_ceh[l_ac].* = g_ceh_t.*
             ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i757_bcl
                 COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_ceh[l_ac].* = g_ceh_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_ceh.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF 
            CLOSE i757_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30034 Add
         CLOSE i757_bcl
         COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(ceh04) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ceg01"
                   LET g_qryparam.arg1 = g_ceh[l_ac].ceh00
                   LET g_qryparam.default1 = g_ceh[l_ac].ceh04
                   CALL cl_create_qry() RETURNING g_ceh[l_ac].ceh04
                   DISPLAY BY NAME g_ceh[l_ac].ceh04
                   NEXT FIELD ceh04
              
              WHEN INFIELD(ceh06) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ceh[l_ac].ceh06
                   CALL cl_create_qry() RETURNING g_ceh[l_ac].ceh06
                   DISPLAY BY NAME g_ceh[l_ac].ceh06
                   NEXT FIELD ceh06
              
              WHEN INFIELD(ceh07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ceh[l_ac].ceh07
                   CALL cl_create_qry() RETURNING g_ceh[l_ac].ceh07
                   DISPLAY BY NAME g_ceh[l_ac].ceh07
                   NEXT FIELD ceh07
              
              WHEN INFIELD(ceh09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ceh[l_ac].ceh09
                   CALL cl_create_qry() RETURNING g_ceh[l_ac].ceh09
                   DISPLAY BY NAME g_ceh[l_ac].ceh09
                   NEXT FIELD ceh09
 
             WHEN INFIELD(ceh12) 
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_azi"                                   
                  LET g_qryparam.default1 = g_ceh[l_ac].ceh12                    
                  CALL cl_create_qry() RETURNING g_ceh[l_ac].ceh12               
                  DISPLAY BY NAME g_ceh[l_ac].ceh12 
                  NEXT FIELD ceh12   
       END CASE
 
       ON ACTION CONTROLN
           CALL i757_b_askkey()
           EXIT INPUT
 
       ON ACTION CONTROLO                       
           IF INFIELD(ceh00) AND l_ac > 1 THEN
               LET g_ceh[l_ac].* = g_ceh[l_ac-1].*
               NEXT FIELD ceh00
           END IF
 
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
 
    CLOSE i757_bcl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i757_b_askkey()
    CLEAR FORM
    CALL g_ceh.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON ceh00,ceh01,ceh04,ceh02,ceh03,
                      ceh05,ceh06,ceh07,ceh08,ceh09,
                      ceh10,ceh11,ceh12,cehacti 
            FROM s_ceh[1].ceh00,s_ceh[1].ceh01,
                 s_ceh[1].ceh04,
                 s_ceh[1].ceh02,s_ceh[1].ceh03,
                 s_ceh[1].ceh05,
                 s_ceh[1].ceh06,s_ceh[1].ceh07,
                 s_ceh[1].ceh08,s_ceh[1].ceh09,
                 s_ceh[1].ceh10,s_ceh[1].ceh11,
                 s_ceh[1].ceh12,s_ceh[1].cehacti
 
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
      ON ACTION CONTROLP
           CASE
               WHEN INFIELD(ceh04) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ceg01"
                    LET g_qryparam.arg1 = g_ceh[1].ceh00
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceh04
                    NEXT FIELD ceh04
               
               WHEN INFIELD(ceh06) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceh06
                    NEXT FIELD ceh06
               
               WHEN INFIELD(ceh07) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceh07
                    NEXT FIELD ceh07
               
               WHEN INFIELD(ceh09) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceh09
                    NEXT FIELD ceh09
                    
              WHEN INFIELD(ceh12) 
                   CALL cl_init_qry_var()                                         
                   LET g_qryparam.form ="q_azi"                                   
                   LET g_qryparam.default1 = g_ceh[l_ac].ceh12                    
                   CALL cl_create_qry() RETURNING g_ceh[l_ac].ceh12               
                   DISPLAY BY NAME g_ceh[l_ac].ceh12 
                   NEXT FIELD ceh12   
                    
        END CASE
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION about   
         CALL cl_about()
      ON ACTION help   
         CALL cl_show_help()
      ON ACTION controlg   
         CALL cl_cmdask() 
    
      ON ACTION qbe_select
        CALL cl_qbe_select() 
      ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cehuser', 'cehgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
   CALL i757_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION i757_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          STRING 
 
    LET g_sql =
        "SELECT ceh00,ceh01,ceh04,ceh02,ceh03,ceh05,",
        "       ceh06,ceh07,ceh08,ceh09,ceh10,ceh11,ceh12,cehacti ",
        " FROM ceh_file ",
        " WHERE ", p_wc2 CLIPPED, 
        " ORDER BY ceh00,ceh01"
    PREPARE i757_pb FROM g_sql
    DECLARE ceh_curs CURSOR FOR i757_pb
 
    CALL g_ceh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ceh_curs INTO g_ceh[g_cnt].*   
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ceh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i757_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ceh TO s_ceh.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()    
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i757_chkkey()
   DEFINE l_n     INTEGER
   DEFINE l_n2    INTEGER   
  
   LET g_errno = NULL
 
   SELECT count(*) INTO l_n FROM ceh_file
    WHERE ceh01 = g_ceh[l_ac].ceh01
      AND ceh00 = g_ceh[l_ac].ceh00
   IF l_n > 0 THEN
      LET g_errno = '-239' 
   END IF
   
  #05/19移除"委外半成品"性質
   #LET l_n2 = '0'
   #IF g_ceh[l_ac].ceh00 = '1' THEN 
   #   SELECT count(*) INTO l_n2 FROM ceh_file
   #    WHERE ceh01 = g_ceh[l_ac].ceh01
   #      AND ceh00 = '3'
   #   IF l_n2 > 0 THEN
   #      LET g_errno = 'aco-701'   #成品/委外半成品的歸併後序號不允許重複 
   #   END IF
   #END IF
   #IF g_ceh[l_ac].ceh00 = '3' THEN 
   #   SELECT count(*) INTO l_n2 FROM ceh_file
   #    WHERE ceh01 = g_ceh[l_ac].ceh01
   #      AND ceh00 = '1'
   #   IF l_n2 > 0 THEN
   #      LET g_errno = 'aco-701'   #成品/委外半成品的歸併後序號不允許重複
   #   END IF
   #END IF
END FUNCTION
 
 
FUNCTION i757_unit(p_data)
   DEFINE p_data  LIKE ceh_file.ceh06,
          l_gfeacti    LIKE gfe_file.gfe01
 
   LET g_errno = NULL
   LET l_gfeacti = NULL
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = p_data
 
   CASE WHEN SQLCA.SQLCODE = 100
             LET g_errno = 'mfg0019'
        WHEN l_gfeacti = 'N'
             LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
 
END FUNCTION
 
 
FUNCTION i757_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1 
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ceh00,ceh01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
 
                                                                                                                                    
FUNCTION i757_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1 
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("ceh00,ceh01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
 
FUNCTION i757_set_required()
   CALL cl_set_comp_required("ceh00,ceh01,ceh02,ceh03,ceh04,ceh05,ceh12",TRUE) 
END FUNCTION
 
FUNCTION i757_comp_change(i_tc1,i_tc2)
   DEFINE i_tc1,i_tc2   LIKE type_file.chr1000 
   DEFINE i_tcno        LIKE type_file.chr1   
    
   LET i_tcno=NULL   
  
   IF (cl_null(i_tc1) AND NOT cl_null(i_tc2)) OR (NOT cl_null(i_tc1) AND cl_null(i_tc2)) THEN
       LET i_tcno=1
   ELSE
       IF cl_null(i_tc1) AND cl_null(i_tc2) THEN
          LET i_tcno=0
       ELSE
          IF i_tc1!=i_tc2 THEN
             LET i_tcno=1 
          ELSE
             LET i_tcno=0  
          END IF
       END IF
   END IF
   
   RETURN i_tcno
END FUNCTION
#FUN-930151 
#FUN-B80045
