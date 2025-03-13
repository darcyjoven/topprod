# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apji900.4gl
# Descriptions...: 設備類型資料維護作業 
# Date & Author..: No.FUN-790025 08/03/05 By ChenMoyan
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980005 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980111 09/08/22 By Dido fab_file select 問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pjy           DYNAMIC ARRAY OF RECORD
           pjy01       LIKE pjy_file.pjy01,       
           pjy02       LIKE pjy_file.pjy02,
           pjy05       LIKE pjy_file.pjy05,
           fab02       LIKE fab_file.fab02,
           pjy03       LIKE pjy_file.pjy03,
           pjy04       LIKE pjy_file.pjy04,           
           pjyacti     LIKE pjy_file.pjyacti 
                       END RECORD,
       g_pjy_t         RECORD             
           pjy01       LIKE pjy_file.pjy01,       
           pjy02       LIKE pjy_file.pjy02,
           pjy05       LIKE pjy_file.pjy05,
           fab02       LIKE fab_file.fab02,
           pjy03       LIKE pjy_file.pjy03,
           pjy04       LIKE pjy_file.pjy04,           
           pjyacti     LIKE pjy_file.pjyacti     
                       END RECORD,
       g_wc2,g_sql     STRING, 
       g_rec_b         LIKE type_file.num5,               
       l_ac            LIKE type_file.num5                
 
DEFINE g_forupd_sql         STRING                  
DEFINE g_cnt                LIKE type_file.num10    
DEFINE g_msg                LIKE type_file.chr1000 
DEFINE g_before_input_done  LIKE type_file.num5     
DEFINE g_i                  LIKE type_file.num5     
 
MAIN
      
 DEFINE  p_row,p_col	 LIKE type_file.num5        
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                    
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
    END IF
      
    CALL cl_used(g_prog,g_time,1)    
         RETURNING g_time   
 
    LET p_row = 4 LET p_col = 10 
    OPEN WINDOW i900_w AT p_row,p_col WITH FORM "apj/42f/apji900"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    LET g_wc2 = '1=1' CALL i900_b_fill(g_wc2)
    CALL i900_menu()
    CLOSE WINDOW i900_w               
    CALL  cl_used(g_prog,g_time,2)  
         RETURNING g_time   
END MAIN
 
FUNCTION i900_menu()
 
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "apji900" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjy),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i900_q()
   CALL i900_b_askkey()
END FUNCTION
 
FUNCTION i900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    
    l_n             LIKE type_file.num5,
    l_fab02         LIKE fab_file.fab02,
    l_msg           LIKE type_file.chr1000,
    l_cnt           LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,  
    p_cmd           LIKE type_file.chr1,   
    l_allow_insert  LIKE type_file.chr1,   
    l_allow_delete  LIKE type_file.chr1    
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT pjy01,pjy02,pjy05,'',pjy03,pjy04,pjyacti",
                       " FROM pjy_file WHERE pjy01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_pjy WITHOUT DEFAULTS FROM s_pjy.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET  g_before_input_done = FALSE 
               CALL i900_set_entry(p_cmd)
               CALL i900_set_no_entry(p_cmd) 
               LET  g_before_input_done = TRUE 
 
               BEGIN WORK
               LET g_pjy_t.* = g_pjy[l_ac].*  #BACKUP
               OPEN i900_bcl USING g_pjy_t.pjy01
               IF STATUS THEN
                  CALL cl_err("OPEN i900_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i900_bcl INTO g_pjy[l_ac].*
                 #SELECT fab02 INTO g_pjy[l_ac].fab02 FROM fab_file	#TQC-980111 mark                                                                 
                 #      WHERE fab01 = g_pjy[l_ac].pjy05 		#TQC-980111 mark
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pjy_t.pjy01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
      
              #-TQC-980111-add-
               SELECT fab02 INTO g_pjy[l_ac].fab02 FROM fab_file                                                                 
                WHERE fab01 = g_pjy[l_ac].pjy05 
              #-TQC-980111-end-
            END IF
 
         BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_pjy[l_ac].* TO NULL
            LET g_pjy[l_ac].pjyacti = 'Y'       #Body default
            LET g_pjy[l_ac].pjy04 = 0
            LET g_pjy_t.* = g_pjy[l_ac].*
            LET  g_before_input_done = FALSE
            CALL i900_set_entry(p_cmd)
            CALL i900_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            NEXT FIELD pjy01
 
      AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO pjy_file(pjy01,pjy02,pjy03,pjy04,pjy05,pjyacti,pjyuser,pjygrup,pjydate,
                                 pjyplant,pjylegal,pjyoriu,pjyorig) #FUN-980005
                          VALUES(g_pjy[l_ac].pjy01,g_pjy[l_ac].pjy02,
                                 g_pjy[l_ac].pjy03,g_pjy[l_ac].pjy04,
                                 g_pjy[l_ac].pjy05,
                                 g_pjy[l_ac].pjyacti, g_user,g_grup,g_today,
                                 g_plant,g_legal, g_user, g_grup) #FUN-980005      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pjy_file",g_pjy[l_ac].pjy01,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD pjy01
            IF NOT cl_null(g_pjy[l_ac].pjy01) THEN 
               IF g_pjy[l_ac].pjy01 != g_pjy_t.pjy01 OR
                  (g_pjy[l_ac].pjy01 IS NOT NULL AND g_pjy_t.pjy01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM pjy_file
                    WHERE pjy01 = g_pjy[l_ac].pjy01
                  IF l_n > 0 THEN     
                    CALL cl_err('',-239,0)
                    LET g_pjy[l_ac].pjy01 = g_pjy_t.pjy01
                    NEXT FIELD pjy01
                  END IF
               END IF
            END IF
            
        ON ACTION CONTROLP                                                                                                         
           CASE                                                                                                                    
               WHEN INFIELD(pjy05)                                                                                                                                                                   
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_fab"                                                                                                                                                                     
                  CALL cl_create_qry() RETURNING g_pjy[l_ac].pjy05                                                                                                                                                     
                  DISPLAY BY NAME g_pjy[l_ac].pjy05                                                                                          
                  NEXT FIELD pjy05
               WHEN INFIELD(pjy03)                                                                                                                                                                   
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_gfe"                                                                                                                                                                     
                  CALL cl_create_qry() RETURNING g_pjy[l_ac].pjy03                                                                                                                                                     
                  DISPLAY BY NAME g_pjy[l_ac].pjy03                                                                                          
                  NEXT FIELD pjy03                                                                                                  
               OTHERWISE EXIT CASE                                                                                                  
            END CASE   
        
        AFTER FIELD pjy03
            SELECT count(*) INTO l_cnt FROM gfe_file                                                                            
                  WHERE gfe01 = g_pjy[l_ac].pjy03 AND gfeacti='Y'                                                                       
            IF l_cnt = 0 THEN                                                                                                 
                  LET l_msg = g_pjy[l_ac].pjy03 clipped using '###&'                                                                
                  CALL cl_err(l_msg,'aic-033',0)                                                                                 
                  LET g_pjy[l_ac].pjy03 = g_pjy_t.pjy03                                                                          
                  DISPLAY BY NAME g_pjy[l_ac].pjy03                                                                                 
                  NEXT FIELD pjy03                                                                                              
            END IF  
      
       AFTER FIELD pjy05
            SELECT count(*) INTO l_cnt FROM fab_file                                                                            
                  WHERE fab01 = g_pjy[l_ac].pjy05 AND fabacti='Y'                                                                       
            IF l_cnt = 0 THEN                                                                                                 
                  LET l_msg = g_pjy[l_ac].pjy05 clipped using '###&'                                                                
                  CALL cl_err(l_msg,'aic-033',0)                                                                                 
                  LET g_pjy[l_ac].pjy05 = g_pjy_t.pjy05                                                                          
                  DISPLAY BY NAME g_pjy[l_ac].pjy05                                                                                 
                  NEXT FIELD pjy05        
            ELSE 
                  SELECT fab02 INTO g_pjy[l_ac].fab02 FROM fab_file                                                                                 
                   WHERE fab01 = g_pjy[l_ac].pjy05   
            END IF                    
                             
       AFTER FIELD pjy04
            IF g_pjy[l_ac].pjy04 < 0 THEN 
               LET l_msg = g_pjy[l_ac].pjy04 CLIPPED USING '###&'
               CALL cl_err(l_msg,'aec-020',0)
               NEXT FIELD pjy04
            END IF
            
       AFTER FIELD pjyacti
            IF cl_null(g_pjy[l_ac].pjyacti) THEN
               LET g_pjy[l_ac].pjyacti = 'N'
            END IF
        
        BEFORE DELETE 
            IF g_pjy_t.pjy01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
               END IF 
               DELETE FROM pjy_file WHERE pjy01 = g_pjy_t.pjy01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pjy_file",g_pjy_t.pjy01,"",SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK" 
               CLOSE i900_bcl     
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pjy[l_ac].* = g_pjy_t.*
              CLOSE i900_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjy[l_ac].pjy01,-263,1)
              LET g_pjy[l_ac].* = g_pjy_t.*
           ELSE
              UPDATE pjy_file SET pjy01=g_pjy[l_ac].pjy01,
                                  pjy02=g_pjy[l_ac].pjy02,
                                  pjy03=g_pjy[l_ac].pjy03,
                                  pjy04=g_pjy[l_ac].pjy04,
                                  pjy05=g_pjy[l_ac].pjy05,
                                  pjyacti=g_pjy[l_ac].pjyacti,
                                  pjymodu=g_user,
                                  pjydate=g_today
                              WHERE pjy01=g_pjy_t.pjy01 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pjy_file",g_pjy_t.pjy01,"",SQLCA.sqlcode,"","",1) 
                 LET g_pjy[l_ac].* = g_pjy_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i900_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                   LET g_pjy[l_ac].* = g_pjy_t.* 
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pjy.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac 
            CLOSE i900_bcl
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i900_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(pjy01) AND l_ac > 1 THEN
               LET g_pjy[l_ac].* = g_pjy[l_ac-1].*
               LET g_pjy[l_ac].pjy01 = NULL
               NEXT FIELD pjy01
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
 
        ON ACTION help         
            CALL cl_show_help()
         
    END INPUT
    CLOSE i900_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i900_b_askkey()
    CLEAR FORM
    CALL g_pjy.clear()
    CONSTRUCT g_wc2 ON pjy01,pjy02,pjy05,pjy03,pjy04,pjyacti
            FROM s_pjy[1].pjy01,s_pjy[1].pjy02,s_pjy[1].pjy05,s_pjy[1].pjy03,
                 s_pjy[1].pjy04,s_pjy[1].pjyacti
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP                                                                                                          
         CASE                                                                                                                     
             WHEN INFIELD(pjy05)                                                                                                  
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"                                                                                             
                LET g_qryparam.form = "q_fab"                                                                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO pjy05                                                                                 
                NEXT FIELD pjy05                                                                                                  
             WHEN INFIELD(pjy03)                                                                                                  
                CALL cl_init_qry_var()      
                LET g_qryparam.state = "c"                                                                                      
                LET g_qryparam.form = "q_gfe"                                                                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO pjy03                                                                                 
                NEXT FIELD pjy03                                                                                                  
             OTHERWISE EXIT CASE                                                                                                  
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjyuser', 'pjygrup') #FUN-980030
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
    END IF
    CALL i900_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i900_b_fill(p_wc2)
#    DEFINE p_wc2     LIKE type_file.chr1000  
    DEFINE p_wc2  STRING     #NO.FUN-910082
    LET g_sql = "SELECT pjy01,pjy02,pjy05,'',pjy03,pjy04,pjyacti",
                " FROM pjy_file",
                " WHERE ", p_wc2 CLIPPED,
                " ORDER BY pjy01 "
    PREPARE i900_pb FROM g_sql
    DECLARE pjy_curs CURSOR FOR i900_pb
 
    CALL g_pjy.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pjy_curs INTO g_pjy[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT fab02 INTO g_pjy[g_cnt].fab02 FROM fab_file                                                                          
           WHERE fab01 = g_pjy[g_cnt].pjy05 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pjy.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i900_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjy TO s_pjy.* ATTRIBUTE(COUNT=g_rec_b)
   
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         
         CALL cl_about() 
         
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i900_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("pjy01",TRUE)
  END IF
END FUNCTION 
 
FUNCTION i900_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
     CALL cl_set_comp_entry("pjy01",FALSE)
  END IF
END FUNCTION
#No.FUN-790025
