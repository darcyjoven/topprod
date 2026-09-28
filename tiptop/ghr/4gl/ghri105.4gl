# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri105.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hram           DYNAMIC ARRAY OF RECORD    
        hram02       LIKE hram_file.hram02,   
        hraa02       LIKE hraa_file.hraa02,  
        hram01       LIKE hram_file.hram01,   
        hrag07       LIKE hrag_file.hrag07,  
        hram03       LIKE hram_file.hram03, 
        hram04       LIKE hram_file.hram04,  
        hram15       LIKE hram_file.hram15,
        hram05       LIKE hram_file.hram05,
        hram06       LIKE hram_file.hram06,
        hram07       LIKE hram_file.hram07,
        hram08       LIKE hram_file.hram08, 
        hram09       LIKE hram_file.hram09,
        hram10       LIKE hram_file.hram10,
        hram14       LIKE hram_file.hram14,
        hram11       LIKE hram_file.hram11, 
        hram12       LIKE hram_file.hram12,
        hram13       LIKE hram_file.hram13  
                    END RECORD,
    g_hram_t         RECORD                 
        hram02       LIKE hram_file.hram02,   
        hraa02       LIKE hraa_file.hraa02,  
        hram01       LIKE hram_file.hram01,   
        hrag07       LIKE hrag_file.hrag07,  
        hram03       LIKE hram_file.hram03, 
        hram04       LIKE hram_file.hram04,  
        hram15       LIKE hram_file.hram15,
        hram05       LIKE hram_file.hram05,
        hram06       LIKE hram_file.hram06,
        hram07       LIKE hram_file.hram07,
        hram08       LIKE hram_file.hram08, 
        hram09       LIKE hram_file.hram09,
        hram10       LIKE hram_file.hram10,
        hram14       LIKE hram_file.hram14,
        hram11       LIKE hram_file.hram11, 
        hram12       LIKE hram_file.hram12,
        hram13       LIKE hram_file.hram13 
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
    OPEN WINDOW i105_w AT p_row,p_col WITH FORM "ghr/42f/ghri105"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i105_b_fill(g_wc2)
    CALL i105_menu()
    CLOSE WINDOW i105_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i105_menu()
 
   WHILE TRUE
      CALL i105_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i105_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i105_b()
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
               IF g_hram[l_ac].hram01 IS NOT NULL THEN
                  LET g_doc.column1 = "hram01"
                  LET g_doc.value1 = g_hram[l_ac].hram01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hram),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i105_q()
   CALL i105_b_askkey()
END FUNCTION	
	
FUNCTION i105_b()
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
 
    LET g_forupd_sql = "SELECT hram02,'',hram01,'',hram03,hram04,hram15,hram05,hram06,",
                       "       hram07,hram08,hram09,hram10,hram14,hram11,hram12,hram13",
                       "  FROM hram_file WHERE hram01=?  AND hram02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i105_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hram WITHOUT DEFAULTS FROM s_hram.*
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
           LET g_hram_t.* = g_hram[l_ac].*  #BACKUP
           OPEN i105_bcl USING g_hram_t.hram01,g_hram_t.hram02
           IF STATUS THEN
              CALL cl_err("OPEN i105_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i105_bcl INTO g_hram[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hram_t.hram01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT hraa12 INTO g_hram[l_ac].hraa02 FROM hraa_file
            WHERE hraa01 = g_hram[l_ac].hram02
              AND hraaacti='Y'
           SELECT hrag07 INTO g_hram[l_ac].hrag07 FROM hrag_file
            WHERE hrag06 = g_hram[l_ac].hram01 
               AND hrag01='101' 
              AND hragacti = 'Y'
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hram[l_ac].* TO NULL      #900423  
         LET g_hram[l_ac].hram05 = 'N'
         LET g_hram[l_ac].hram07 = 'N'
         LET g_hram[l_ac].hram08 = 'N'
         LET g_hram[l_ac].hram09 = 'N'
         LET g_hram[l_ac].hram11 = 'Y'
         LET g_hram[l_ac].hram12 = 'Y'               
         LET g_hram_t.* = g_hram[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hram02 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i105_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        INSERT INTO hram_file(hram01,hram02,hram03,hram04,hram05,                          #FUN-A30097
                    hram06,hram07,hram08,hram09,hram10,hram11,hram12,
                    hram13,hram14,hram15,
                    hramacti,hramuser,hramdate,hramgrup,hramoriu,hramorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hram[l_ac].hram01,g_hram[l_ac].hram02,
                      g_hram[l_ac].hram03,g_hram[l_ac].hram04,                                                              #FUN-A80148--mark--
                      g_hram[l_ac].hram05,g_hram[l_ac].hram06,
                      g_hram[l_ac].hram07,g_hram[l_ac].hram08,
                      g_hram[l_ac].hram09,g_hram[l_ac].hram10,
                      g_hram[l_ac].hram11,g_hram[l_ac].hram12,
                      g_hram[l_ac].hram13,g_hram[l_ac].hram14,g_hram[l_ac].hram15,
                      'Y',g_user,g_today,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hram_file",g_hram[l_ac].hram01,g_hram[l_ac].hram02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hram01                        
       IF NOT cl_null(g_hram[l_ac].hram01) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag06=g_hram[l_ac].hram01
       	                                            AND hragacti='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此编码项ID','!',0)
       	  	  NEXT FIELD hram01
       	  END IF
       	 	  	                                            
          IF g_hram[l_ac].hram01 != g_hram_t.hram01 OR
             g_hram_t.hram01 IS NULL THEN
             IF NOT cl_null(g_hram[l_ac].hram02) THEN
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hram_file
                 WHERE hram01 = g_hram[l_ac].hram01
                   AND hram02 = g_hram[l_ac].hram02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                  LET g_hram[l_ac].hram01 = g_hram_t.hram01
                  NEXT FIELD hram01
                END IF
             END IF
          END IF
          	
          SELECT hrag07 INTO g_hram[l_ac].hrag07 FROM hrag_file 
           WHERE hrag06=g_hram[l_ac].hram01
             AND hrag01='101'
             AND hragacti='Y'
          DISPLAY BY NAME g_hram[l_ac].hrag07                                              	
       END IF
       	
    AFTER FIELD hram02
       IF NOT cl_null(g_hram[l_ac].hram02) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hram[l_ac].hram02
       	                                            AND hraaacti='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此公司编号','!',0)
       	  	  NEXT FIELD hram02
       	  END IF
       	 	  	                                            
          IF g_hram[l_ac].hram02 != g_hram_t.hram02 OR
             g_hram_t.hram02 IS NULL THEN
             IF NOT cl_null(g_hram[l_ac].hram01) THEN
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hram_file
                 WHERE hram01 = g_hram[l_ac].hram01
                   AND hram02 = g_hram[l_ac].hram02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                  LET g_hram[l_ac].hram02 = g_hram_t.hram02
                  NEXT FIELD hram02
                END IF
             END IF
          END IF
          	
          SELECT hraa12 INTO g_hram[l_ac].hraa02 FROM hraa_file 
           WHERE hraa01=g_hram[l_ac].hram02
             AND hraaacti='Y'
          DISPLAY BY NAME g_hram[l_ac].hraa02                                             	
       END IF 
       	   	           	
    AFTER FIELD hram04                        
       IF NOT cl_null(g_hram[l_ac].hram04) THEN
        	IF g_hram[l_ac].hram04<0 THEN
        		 NEXT FIELD hram04
        	ELSE 
        		 CALL i105_hram04()
        		 CALL i105_get_hram14()
        	END IF	         	 	  	                                                                                         	
       END IF
   
    AFTER FIELD hram05
       IF NOT cl_null(g_hram[l_ac].hram05) THEN
          IF g_hram[l_ac].hram05 NOT MATCHES '[YN]' THEN 
             LET g_hram[l_ac].hram05 = g_hram_t.hram05
             NEXT FIELD hram05
          END IF
          	
          IF g_hram[l_ac].hram05='Y' THEN
          	 CALL cl_set_comp_entry("hram06",TRUE)
          	 CALL cl_set_comp_required("hram06",TRUE)
          	 CALL i105_get_hram14()
          ELSE
          	 CALL cl_set_comp_entry("hram06",FALSE)
          	 CALL cl_set_comp_required("hram06",FALSE)
          	 LET g_hram[l_ac].hram06=NULL
                 CALL i105_get_hram14()
          	 DISPLAY BY NAME g_hram[l_ac].hram06	  	
          END IF 
       END IF
       	
    AFTER FIELD hram06
       IF NOT cl_null(g_hram[l_ac].hram06) THEN
       	  CALL i105_get_hram14()
       END IF	     	
       	
    AFTER FIELD hram07
       IF NOT cl_null(g_hram[l_ac].hram07) THEN
          IF g_hram[l_ac].hram07 NOT MATCHES '[YN]' THEN 
             LET g_hram[l_ac].hram07 = g_hram_t.hram07
             NEXT FIELD hram07
          END IF
          CALL i105_get_hram14()		  	
       END IF
    
    AFTER FIELD hram08
       IF NOT cl_null(g_hram[l_ac].hram08) THEN
          IF g_hram[l_ac].hram08 NOT MATCHES '[YN]' THEN 
             LET g_hram[l_ac].hram08 = g_hram_t.hram08
             NEXT FIELD hram08
          END IF	  	
          CALL i105_get_hram14()	
       END IF 
       	
    AFTER FIELD hram09
       IF NOT cl_null(g_hram[l_ac].hram09) THEN
          IF g_hram[l_ac].hram09 NOT MATCHES '[YN]' THEN 
             LET g_hram[l_ac].hram09 = g_hram_t.hram09
             NEXT FIELD hram09
          END IF
          	
          IF g_hram[l_ac].hram09='Y' THEN
          	 CALL cl_set_comp_entry("hram10",TRUE)
          	 CALL cl_set_comp_required("hram10",TRUE)
          	 CALL i105_get_hram14()
          ELSE
          	 CALL cl_set_comp_entry("hram10",FALSE)
          	 CALL cl_set_comp_required("hram10",FALSE)
          	 LET g_hram[l_ac].hram10=NULL
                 CALL i105_get_hram14()
          	 DISPLAY BY NAME g_hram[l_ac].hram10	  	
          END IF
       END IF
    
    AFTER FIELD hram10
       IF NOT cl_null(g_hram[l_ac].hram10) THEN
       	  CALL i105_get_hram14()
       END IF	     	
       	
    AFTER FIELD hram11
       IF NOT cl_null(g_hram[l_ac].hram11) THEN
          IF g_hram[l_ac].hram11 NOT MATCHES '[YN]' THEN 
             LET g_hram[l_ac].hram11 = g_hram_t.hram11
             NEXT FIELD hram11
          END IF	  	
       END IF  	  
       	
    AFTER FIELD hram12
       IF NOT cl_null(g_hram[l_ac].hram12) THEN
          IF g_hram[l_ac].hram12 NOT MATCHES '[YN]' THEN 
             LET g_hram[l_ac].hram12 = g_hram_t.hram12
             NEXT FIELD hram12
          END IF	  	
       END IF   	 	  	    	
       	
    BEFORE DELETE                            
       IF g_hram_t.hram01 IS NOT NULL AND g_hram_t.hram02 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hram01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hram[l_ac].hram01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hram_file WHERE hram01 = g_hram_t.hram01
                                  AND hram02 = g_hram_t.hram02
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hram_file",g_hram_t.hram01,g_hram_t.hram02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hram[l_ac].* = g_hram_t.*
         CLOSE i105_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hram[l_ac].hram01,-263,0)
          LET g_hram[l_ac].* = g_hram_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hram_file SET hram01=g_hram[l_ac].hram01,
                               hram02=g_hram[l_ac].hram02,
                               hram03=g_hram[l_ac].hram03,
                               hram04=g_hram[l_ac].hram04,
                               hram05=g_hram[l_ac].hram05,
                               hram06=g_hram[l_ac].hram06,
                               hram07=g_hram[l_ac].hram07,
                               hram08=g_hram[l_ac].hram08,
                               hram09=g_hram[l_ac].hram09,
                               hram10=g_hram[l_ac].hram10,
                               hram11=g_hram[l_ac].hram11,
                               hram12=g_hram[l_ac].hram12,
                               hram13=g_hram[l_ac].hram13,
                               hram14=g_hram[l_ac].hram14,
                               hram15=g_hram[l_ac].hram15,    
                               hrammodu=g_user,
                               hramdate=g_today
                WHERE hram01 = g_hram_t.hram01
                  AND hram02 = g_hram_t.hram02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hram_file",g_hram_t.hram01,g_hram_t.hram02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hram[l_ac].* = g_hram_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hram[l_ac].* = g_hram_t.*
          END IF
          CLOSE i105_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i105_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hram02)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hraa10"
             LET g_qryparam.default1 = g_hram[l_ac].hram02
             CALL cl_create_qry() RETURNING g_hram[l_ac].hram02
             DISPLAY g_hram[l_ac].hram01 TO hram02
             NEXT FIELD hram02
             
           WHEN INFIELD(hram01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hram[l_ac].hram01
             LET g_qryparam.arg1='101'
             CALL cl_create_qry() RETURNING g_hram[l_ac].hram01
             DISPLAY BY NAME g_hram[l_ac].hram01
             NEXT FIELD hram01
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
 
    CLOSE i105_bcl
    COMMIT WORK
END FUNCTION      	     		
	
FUNCTION i105_b_askkey()
    CLEAR FORM
    CALL g_hram.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hram01,hram02,hram03,hram04,hram05,hram06,hram07,
                       hram08,hram09,hram10,hram11,hram12,hram13,hram14                       
         FROM s_hram[1].hram01,s_hram[1].hram02,s_hram[1].hram03,                                  
              s_hram[1].hram04,s_hram[1].hram05,s_hram[1].hram06,
              s_hram[1].hram07,s_hram[1].hram08,s_hram[1].hram09,
              s_hram[1].hram10,s_hram[1].hram11,s_hram[1].hram12,
              s_hram[1].hram13,s_hram[1].hram14
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hram02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa10"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hram[1].hram02
               NEXT FIELD hram02
               
            WHEN INFIELD(hram01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c" 
               LET g_qryparam.arg1='101'  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hram01
               NEXT FIELD hram01
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hramuser', 'hramgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i105_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i105_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hram02,'',hram01,'',hram03,hram04,hram15,hram05,hram06,",
                   "       hram07,hram08,hram09,hram10,hram14,hram11,hram12,hram13 ",
                   " FROM hram_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i105_pb FROM g_sql
    DECLARE hram_curs CURSOR FOR i105_pb
 
    CALL g_hram.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hram_curs INTO g_hram[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hram[g_cnt].hraa02 FROM hraa_file 
         WHERE hraa01=g_hram[g_cnt].hram02
           AND hraaacti='Y'
        SELECT hrag07 INTO g_hram[g_cnt].hrag07 FROM hrag_file
         WHERE hrag06=g_hram[g_cnt].hram01
            AND hrag01='101'
           AND hragacti='Y'   
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hram.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i105_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hram TO s_hram.* ATTRIBUTE(COUNT=g_rec_b)
 
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
	
FUNCTION i105_hram04()
DEFINE l_n        LIKE type_file.num5
DEFINE l_str      STRING
    
    LET l_str=''
    FOR l_n = 1 TO g_hram[l_ac].hram04
       IF l_n=g_hram[l_ac].hram04 THEN
       	  LET l_str=l_str.trim()
       	  LET l_str=l_str CLIPPED,'1'
       ELSE
       	  LET l_str=l_str.trim()
       	  LET l_str=l_str CLIPPED,'0'
       END IF
    END FOR
       	
    LET l_str=l_str.trim()
    LET g_hram[l_ac].hram15=l_str
    DISPLAY BY NAME g_hram[l_ac].hram15	 
	
END FUNCTION			            
	
FUNCTION i105_get_hram14()
DEFINE l_str     STRING	
DEFINE l_str2    STRING
		   
	   LET l_str=''
	   CASE g_hram[l_ac].hram09
	   	 WHEN 'N'    LET l_str2=''
	   	 WHEN 'Y'    IF g_hram[l_ac].hram10='1' THEN LET l_str2=' ' END IF
	   	 	           IF g_hram[l_ac].hram10='2' THEN LET l_str2='_' END IF 		
	   END CASE
	   		 	           	     
	     IF NOT cl_null(g_hram[l_ac].hram03) THEN
	     	  LET l_str=l_str.trim()
	     	  LET l_str=l_str CLIPPED,g_hram[l_ac].hram03
	     END IF
	     	
	     IF g_hram[l_ac].hram05='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,g_hram[l_ac].hram06
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,g_hram[l_ac].hram06
	     	  END IF	     
	     END IF
	     	
	     IF g_hram[l_ac].hram07='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,'MM'
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,'MM'
	     	  END IF	     
	     END IF
	     	
	     IF g_hram[l_ac].hram08='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,'DD'
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,'DD'
	     	  END IF	     
	     END IF
	     	
	     IF NOT cl_null(g_hram[l_ac].hram15) THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,g_hram[l_ac].hram15
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,g_hram[l_ac].hram15
	     	  END IF	     
	     END IF
	     	
	     LET l_str=l_str.trim()
	     LET g_hram[l_ac].hram14=l_str	
	     
END FUNCTION	     			
	     	
	     		  	
	     	   
