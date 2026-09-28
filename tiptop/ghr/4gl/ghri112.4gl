# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri112.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrbr             DYNAMIC ARRAY OF RECORD    
        hrbr01          LIKE hrbr_file.hrbr01,   
        hrbr02          LIKE hrbr_file.hrbr02,  
        hrbr03          LIKE hrbr_file.hrbr03,
        hrbr04          LIKE hrbr_file.hrbr04,
        hrbr05          LIKE hrbr_file.hrbr05,
        hrbr06          LIKE hrbr_file.hrbr06, 
        hrbr07          LIKE hrbr_file.hrbr07,
        hrbr08          LIKE hrbr_file.hrbr08,
        hrbr09          LIKE hrbr_file.hrbr09, 
        hrbr10          LIKE hrbr_file.hrbr10,
        hrbr11          LIKE hrbr_file.hrbr11,
        hrbr12          LIKE hrbr_file.hrbr12,
        hrbr13          LIKE hrbr_file.hrbr13,
        hrbr14          LIKE hrbr_file.hrbr14,
        hraa12          LIKE hraa_file.hraa12,
        hrbr15          LIKE hrbr_file.hrbr15,
        hrbracti        LIKE hrbr_file.hrbracti
                    END RECORD,
    g_hrbr_t         RECORD                 
        hrbr01          LIKE hrbr_file.hrbr01,   
        hrbr02          LIKE hrbr_file.hrbr02,  
        hrbr03          LIKE hrbr_file.hrbr03,
        hrbr04          LIKE hrbr_file.hrbr04,
        hrbr05          LIKE hrbr_file.hrbr05,
        hrbr06          LIKE hrbr_file.hrbr06, 
        hrbr07          LIKE hrbr_file.hrbr07,
        hrbr08          LIKE hrbr_file.hrbr08,
        hrbr09          LIKE hrbr_file.hrbr09, 
        hrbr10          LIKE hrbr_file.hrbr10,
        hrbr11          LIKE hrbr_file.hrbr11,
        hrbr12          LIKE hrbr_file.hrbr12,
        hrbr13          LIKE hrbr_file.hrbr13,
        hrbr14          LIKE hrbr_file.hrbr14,
        hraa12          LIKE hraa_file.hraa12,
        hrbr15          LIKE hrbr_file.hrbr15,
        hrbracti        LIKE hrbr_file.hrbracti 
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
    OPEN WINDOW i112_w AT p_row,p_col WITH FORM "ghr/42f/ghri112"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = ' 1=1'
    CALL i112_b_fill(g_wc2)
    CALL i112_menu()
    CLOSE WINDOW i112_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i112_menu()
 
   WHILE TRUE
      CALL i112_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i112_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i112_b()
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
               IF g_hrbr[l_ac].hrbr01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbr01"
                  LET g_doc.value1 = g_hrbr[l_ac].hrbr01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbr),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i112_q()
   CALL i112_b_askkey()
END FUNCTION	
	
FUNCTION i112_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid    
      
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbr01,hrbr02,hrbr03,hrbr04,hrbr05,hrbr06,",
                       "       hrbr07,hrbr08,hrbr09,hrbr10,hrbr11,hrbr12,",
                       "       hrbr13,hrbr14,'',hrbr15,hrbracti",
                       "  FROM hrbr_file WHERE hrbr01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i112_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrbr WITHOUT DEFAULTS FROM s_hrbr.*
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
           LET g_hrbr_t.* = g_hrbr[l_ac].*  #BACKUP
           OPEN i112_bcl USING g_hrbr_t.hrbr01
           IF STATUS THEN
              CALL cl_err("OPEN i112_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i112_bcl INTO g_hrbr[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrbr_t.hrbr01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           
           SELECT hraa12 INTO g_hrbr[l_ac].hraa12 FROM hraa_file
            WHERE hraa01=g_hrbr[l_ac].hrbr14
            
           LET l_n=0
           SELECT COUNT(*) INTO l_n FROM hrbs_file WHERE hrbs03=g_hrbr[l_ac].hrbr01
           IF l_n>0 THEN
           	  CALL cl_set_comp_entry("hrbr01",FALSE)
           ELSE
           	  CALL cl_set_comp_entry("hrbr01",TRUE)
           END IF	  	    
            
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'

         CALL cl_set_comp_entry("hrbr01",TRUE)
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end  
         INITIALIZE g_hrbr[l_ac].* TO NULL      #900423
         
         LET g_hrbr[l_ac].hrbracti='Y'
       
         LET g_hrbr_t.* = g_hrbr[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbr01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i112_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        INSERT INTO hrbr_file(hrbr01,hrbr02,hrbr03,hrbr04,hrbr05,                          #FUN-A30097
                    hrbr06,hrbr07,hrbr08,hrbr09,hrbr10,hrbr11,hrbr12,
                    hrbr13,hrbr14,hrbr15,hrbracti,
                    hrbruser,hrbrdate,hrbrgrup,hrbroriu,hrbrorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrbr[l_ac].hrbr01,g_hrbr[l_ac].hrbr02,
                      g_hrbr[l_ac].hrbr03,g_hrbr[l_ac].hrbr04,                                                              #FUN-A80148--mark--
                      g_hrbr[l_ac].hrbr05,g_hrbr[l_ac].hrbr06,
                      g_hrbr[l_ac].hrbr07,g_hrbr[l_ac].hrbr08,
                      g_hrbr[l_ac].hrbr09,g_hrbr[l_ac].hrbr10,
                      g_hrbr[l_ac].hrbr11,g_hrbr[l_ac].hrbr12,
                      g_hrbr[l_ac].hrbr13,g_hrbr[l_ac].hrbr14,
                      g_hrbr[l_ac].hrbr15,g_hrbr[l_ac].hrbracti,
                      g_user,g_today,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrbr_file",g_hrbr[l_ac].hrbr01,g_hrbr[l_ac].hrbr02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
       	
    AFTER FIELD hrbr01
       IF NOT cl_null(g_hrbr[l_ac].hrbr01) THEN
       	  IF g_hrbr_t.hrbr01 != g_hrbr[l_ac].hrbr01 
       	  	OR g_hrbr_t.hrbr01 IS NULL THEN
       	  	LET l_n=0
       	  	SELECT COUNT(*) INTO l_n FROM hrbr_file WHERE hrbr01=g_hrbr[l_ac].hrbr01
       	  	IF l_n>0 THEN
       	  		 CALL cl_err(g_hrbr[l_ac].hrbr01,-239,0)
       	  		 NEXT FIELD hrbr01
       	  	END IF
       	  END IF			 	  	                                                                                        	
       END IF 
       	   	           	
    AFTER FIELD hrbr14                        
       IF NOT cl_null(g_hrbr[l_ac].hrbr14) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hraa_file
       	   WHERE hraa01=g_hrbr[l_ac].hrbr14
       	     AND hraaacti='Y'
       	  IF l_n=0 THEN
       	  	 CALL cl_err("无此公司编号","!",0)
       	  	 NEXT FIELD hrbr14
       	  END IF
       	  
       	  SELECT hraa12 INTO g_hrbr[l_ac].hraa12 FROM hraa_file
       	   WHERE hraa01=g_hrbr[l_ac].hrbr14
       	     AND hraaacti='Y'
       	  DISPLAY BY NAME g_hrbr[l_ac].hraa12   		            	     	 	  	                                                                                         	
       END IF
       	       	
    BEFORE DELETE                            
       IF g_hrbr_t.hrbr01 IS NOT NULL THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrbs_file 
       	   WHERE hrbs03=g_hrbr_t.hrbr01
       	  IF l_n>0 THEN
       	  	 ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          	 
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrbr01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrbr[l_ac].hrbr01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrbr_file WHERE hrbr01 = g_hrbr_t.hrbr01
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrbr_file",g_hrbr_t.hrbr01,g_hrbr_t.hrbr02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrbr[l_ac].* = g_hrbr_t.*
         CLOSE i112_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrbr[l_ac].hrbr01,-263,0)
          LET g_hrbr[l_ac].* = g_hrbr_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrbr_file SET hrbr01=g_hrbr[l_ac].hrbr01,
                               hrbr02=g_hrbr[l_ac].hrbr02,
                               hrbr03=g_hrbr[l_ac].hrbr03,
                               hrbr04=g_hrbr[l_ac].hrbr04,
                               hrbr05=g_hrbr[l_ac].hrbr05,
                               hrbr06=g_hrbr[l_ac].hrbr06,
                               hrbr07=g_hrbr[l_ac].hrbr07,
                               hrbr08=g_hrbr[l_ac].hrbr08,
                               hrbr09=g_hrbr[l_ac].hrbr09,
                               hrbr10=g_hrbr[l_ac].hrbr10,
                               hrbr11=g_hrbr[l_ac].hrbr11,
                               hrbr12=g_hrbr[l_ac].hrbr12,
                               hrbr13=g_hrbr[l_ac].hrbr13,
                               hrbr14=g_hrbr[l_ac].hrbr14,
                               hrbr15=g_hrbr[l_ac].hrbr15,    
                               hrbrmodu=g_user,
                               hrbrdate=g_today
                WHERE hrbr01 = g_hrbr_t.hrbr01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrbr_file",g_hrbr_t.hrbr01,g_hrbr_t.hrbr02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrbr[l_ac].* = g_hrbr_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrbr[l_ac].* = g_hrbr_t.*
          END IF
          CLOSE i112_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i112_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrbr14)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hraa01"
             LET g_qryparam.default1 = g_hrbr[l_ac].hrbr14
             CALL cl_create_qry() RETURNING g_hrbr[l_ac].hrbr14
             DISPLAY BY NAME g_hrbr[l_ac].hrbr14
             NEXT FIELD hrbr14
             
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
 
    CLOSE i112_bcl
    COMMIT WORK
END FUNCTION      	     		
	
FUNCTION i112_b_askkey()
    CLEAR FORM
    CALL g_hrbr.clear()
 
    CONSTRUCT g_wc2 ON hrbr01,hrbr02,hrbr03,hrbr04,hrbr05,hrbr06,hrbr07,
                       hrbr08,hrbr09,hrbr10,hrbr11,hrbr12,hrbr13,hrbr14,
                       hrbr15                       
         FROM s_hrbr[1].hrbr01,s_hrbr[1].hrbr02,s_hrbr[1].hrbr03,                                  
              s_hrbr[1].hrbr04,s_hrbr[1].hrbr05,s_hrbr[1].hrbr06,
              s_hrbr[1].hrbr07,s_hrbr[1].hrbr08,s_hrbr[1].hrbr09,
              s_hrbr[1].hrbr10,s_hrbr[1].hrbr11,s_hrbr[1].hrbr12,
              s_hrbr[1].hrbr13,s_hrbr[1].hrbr14,s_hrbr[1].hrbr15
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbr14)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbr[1].hrbr14
               NEXT FIELD hrbr14
               
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbruser', 'hrbrgrup') #FUN-980030 
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
    END IF
#No.TQC-710076 -- end --
 
    CALL i112_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i112_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrbr01,hrbr02,hrbr03,hrbr04,hrbr05,hrbr06,",
                   "       hrbr07,hrbr08,hrbr09,hrbr10,hrbr11,",
                   "       hrbr12,hrbr13,hrbr14,'',hrbr15,hrbracti",
                   " FROM hrbr_file",
                   " WHERE ", p_wc2 CLIPPED,
                   " ORDER BY 1" 
 
    PREPARE i112_pb FROM g_sql
    DECLARE hrbr_curs CURSOR FOR i112_pb
 
    CALL g_hrbr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbr_curs INTO g_hrbr[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hrbr[g_cnt].hraa12 FROM hraa_file
         WHERE hraa01=g_hrbr[g_cnt].hrbr14
           AND hraaacti='Y'     
                       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbr.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i112_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbr TO s_hrbr.* ATTRIBUTE(COUNT=g_rec_b)
 
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
	
	     	
	     		  	
	     	   
