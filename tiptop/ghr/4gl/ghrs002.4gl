# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrs002.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hran           DYNAMIC ARRAY OF RECORD    
        hran01       LIKE hran_file.hran01,   
        hran01_1     LIKE hraa_file.hraa02,  
        hran02       LIKE hran_file.hran02,   
        hran03       LIKE hran_file.hran03,  
        hran04       LIKE hran_file.hran04, 
        hran05       LIKE hran_file.hran05,  
        hran06       LIKE hran_file.hran06, 
        hranacti     LIKE hran_file.hranacti   
                    END RECORD,
    g_hran_t         RECORD                 
        hran01       LIKE hran_file.hran01,   
        hran01_1     LIKE hraa_file.hraa02,  
        hran02       LIKE hran_file.hran02,   
        hran03       LIKE hran_file.hran03,  
        hran04       LIKE hran_file.hran04, 
        hran05       LIKE hran_file.hran05,  
        hran06       LIKE hran_file.hran06, 
        hranacti     LIKE hran_file.hranacti 
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING                        


MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW s002_w AT p_row,p_col WITH FORM "ghr/42f/ghrs002"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL s002_b_fill(g_wc2)
    CALL s002_menu()
    CLOSE WINDOW s002_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION s002_menu()
 
   WHILE TRUE
      CALL s002_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL s002_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL s002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hran[l_ac].hran01 IS NOT NULL THEN
                  LET g_doc.column1 = "hran01"
                  LET g_doc.value1 = g_hran[l_ac].hran01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hran),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION s002_q()
   CALL s002_b_askkey()
END FUNCTION
	
FUNCTION s002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
DEFINE l_msg        LIKE type_file.chr1000
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hran01,'',hran02,hran03,hran04,hran05,hran06,hranacti",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hran_file WHERE hran01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hran WITHOUT DEFAULTS FROM s_hran.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_hran_t.* = g_hran[l_ac].*  #BACKUP
           OPEN s002_bcl USING g_hran_t.hran01
           IF STATUS THEN
              CALL cl_err("OPEN s002_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH s002_bcl INTO g_hran[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hran_t.hran01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT hraa12  INTO g_hran[l_ac].hran01_1 FROM hraa_file
            WHERE hraa01 = g_hran[l_ac].hran01
              AND hraaacti = 'Y'
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hran[l_ac].* TO NULL      #900423  
         LET g_hran[l_ac].hranacti = 'Y'       #Body default
         LET g_hran_t.* = g_hran[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hran01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE s002_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hran_file(hran01,hran02,hran03,hran04,hran05,                          #FUN-A30097
                     hran06,hranacti,hranuser,hrandate,hrangrup,hranoriu,hranorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hran[l_ac].hran01,g_hran[l_ac].hran02,
               g_hran[l_ac].hran03,g_hran[l_ac].hran04,                      #FUN-A30097                                        #FUN-A80148--mark--
               g_hran[l_ac].hran05,g_hran[l_ac].hran06,                      #FUN-A80148--mod-- 
               g_hran[l_ac].hranacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hran_file",g_hran[l_ac].hran01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hran01                        
       IF NOT cl_null(g_hran[l_ac].hran01) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hran[l_ac].hran01
       	                                            AND hraaacti='Y'
       	  IF l_n=0 THEN
                  LET l_msg=g_hran[l_ac].hran01,"公司ID不存在,请检查"
       	 	  CALL cl_err(l_msg,'!',0)
       	 	  NEXT FIELD hran01
       	  END IF
       	 	  	                                            
          IF g_hran[l_ac].hran01 != g_hran_t.hran01 OR
             g_hran_t.hran01 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hran_file
              WHERE hran01 = g_hran[l_ac].hran01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hran[l_ac].hran01 = g_hran_t.hran01
                NEXT FIELD hran01
             END IF
          END IF
          
          SELECT hraa12 INTO g_hran[l_ac].hran01_1 FROM hraa_file 
           WHERE hraa01=g_hran[l_ac].hran01
             AND hraaacti='Y'
          DISPLAY BY NAME g_hran[l_ac].hran01_1                                              	
       END IF
       	
    AFTER FIELD hran02
       IF NOT cl_null(g_hran[l_ac].hran02) THEN
          IF g_hran[l_ac].hran02 NOT MATCHES '[YN]' THEN 
             LET g_hran[l_ac].hran02 = g_hran_t.hran02
             NEXT FIELD hran02
          END IF
       END IF
       	
    AFTER FIELD hran03                        
       IF NOT cl_null(g_hran[l_ac].hran03) THEN
        	LET l_n=0
        	SELECT COUNT(*) INTO l_n FROM hrac_file WHERE hrac01=g_hran[l_ac].hran03
       	 IF l_n=0 THEN
                  LET l_msg=g_hran[l_ac].hran03,"该财年未维护,请至ghri100维护"
       	 	  CALL cl_err(l_msg,'!',0)
       	 	  NEXT FIELD hran03
       	 END IF
        	 	  	                                                                                         	
       END IF
   
    AFTER FIELD hranacti
       IF NOT cl_null(g_hran[l_ac].hranacti) THEN
          IF g_hran[l_ac].hranacti NOT MATCHES '[YN]' THEN 
             LET g_hran[l_ac].hranacti = g_hran_t.hranacti
             NEXT FIELD hranacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hran_t.hran01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hran01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hran[l_ac].hran01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hran_file WHERE hran01 = g_hran_t.hran01
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hran_file",g_hran_t.hran01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hran[l_ac].* = g_hran_t.*
         CLOSE s002_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hran[l_ac].hran01,-263,0)
          LET g_hran[l_ac].* = g_hran_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hran_file SET hran01=g_hran[l_ac].hran01,
                               hran02=g_hran[l_ac].hran02,
                               hran03=g_hran[l_ac].hran03,
                               hran04=g_hran[l_ac].hran04,
                               hran05=g_hran[l_ac].hran05,
                               hran06=g_hran[l_ac].hran06,    
                               hranacti=g_hran[l_ac].hranacti,
                               hranmodu=g_user,
                               hrandate=g_today
          WHERE hran01 = g_hran_t.hran01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hran_file",g_hran_t.hran01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hran[l_ac].* = g_hran_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hran[l_ac].* = g_hran_t.*
          END IF
          CLOSE s002_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE s002_bcl                
        COMMIT WORK  
        
    ON ACTION CONTROLO                  
         IF INFIELD(hran01) AND l_ac > 1 THEN
             LET g_hran[l_ac].* = g_hran[l_ac-1].*
             NEXT FIELD hran01
         END IF
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hran01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hraa10"
             LET g_qryparam.default1 = g_hran[l_ac].hran01
             CALL cl_create_qry() RETURNING g_hran[l_ac].hran01
             DISPLAY g_hran[l_ac].hran01 TO hran01
             NEXT FIELD hran01
             
           WHEN INFIELD(hran03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrac01"
             LET g_qryparam.default1 = g_hran[l_ac].hran03
             CALL cl_create_qry() RETURNING g_hran[l_ac].hran03
             DISPLAY BY NAME g_hran[l_ac].hran03
             NEXT FIELD hran03
         OTHERWISE
           EXIT CASE
         END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE s002_bcl
    COMMIT WORK
END FUNCTION      	     		
	
FUNCTION s002_b_askkey()
    CLEAR FORM
    CALL g_hran.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hran01,hran02,hran03,hran04,hran05,hran06,hranacti                       
         FROM s_hran[1].hran01,s_hran[1].hran02,s_hran[1].hran03,                                  
              s_hran[1].hran04,s_hran[1].hran05,s_hran[1].hran06,s_hran[1].hranacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hran01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa10"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hran[1].hran01
               NEXT FIELD hran01
               
            WHEN INFIELD(hran03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrac01"
               LET g_qryparam.state = "c"   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hran03
               NEXT FIELD hran03
         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hranuser', 'hrangrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL s002_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION s002_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hran01,'',hran02,hran03,hran04,hran05,hran06,hranacti",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hran_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE s002_pb FROM g_sql
    DECLARE hran_curs CURSOR FOR s002_pb
 
    CALL g_hran.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hran_curs INTO g_hran[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hran[g_cnt].hran01_1 FROM hraa_file 
         WHERE hraa01=g_hran[g_cnt].hran01
           AND hraaacti='Y'
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hran.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION s002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hran TO s_hran.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
   
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
	
