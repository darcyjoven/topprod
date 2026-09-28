# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri003.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo


DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hraq           DYNAMIC ARRAY OF RECORD    
        hraq01       LIKE hraq_file.hraq01,     
        hraq02       LIKE hraq_file.hraq02,   
        hraq03       LIKE hraq_file.hraq03,    
        hraqacti     LIKE hraq_file.hraqacti   
                    END RECORD,
    g_hraq_t         RECORD                 
        hraq01       LIKE hraq_file.hraq01,     
        hraq02       LIKE hraq_file.hraq02,   
        hraq03       LIKE hraq_file.hraq03,    
        hraqacti     LIKE hraq_file.hraqacti 
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
    OPEN WINDOW i003_w AT p_row,p_col WITH FORM "ghr/42f/ghri003"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i003_b_fill(g_wc2)
    CALL i003_menu()
    CLOSE WINDOW i003_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i003_menu()
 
   WHILE TRUE
      CALL i003_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i003_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i003_b()
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
               IF g_hraq[l_ac].hraq01 IS NOT NULL THEN
                  LET g_doc.column1 = "hraq01"
                  LET g_doc.value1 = g_hraq[l_ac].hraq01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hraq),'','')
            END IF

         #add by zhangbo130830---begin
         WHEN "ghri003_a"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri0031")
            END IF
         #add by zhangbo130830---end
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i003_q()
   CALL i003_b_askkey()
END FUNCTION
	
FUNCTION i003_b()
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
 
    LET g_forupd_sql = "SELECT hraq01,hraq02,hraq03,hraqacti",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hraq_file WHERE hraq02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hraq WITHOUT DEFAULTS FROM s_hraq.*
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
           LET g_hraq_t.* = g_hraq[l_ac].*  #BACKUP
           OPEN i003_bcl USING g_hraq_t.hraq02
           IF STATUS THEN
              CALL cl_err("OPEN i003_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i003_bcl INTO g_hraq[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hraq_t.hraq02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hraq[l_ac].* TO NULL      #900423  
         LET g_hraq[l_ac].hraqacti = 'Y'       #Body default
         LET g_hraq_t.* = g_hraq[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hraq01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i003_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hraq_file(hraq01,hraq02,hraq03,                          #FUN-A30097
                              hraqacti,hraquser,hraqdate,hraqgrup,hraqoriu,hraqorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hraq[l_ac].hraq01,g_hraq[l_ac].hraq02,g_hraq[l_ac].hraq03,                                       #FUN-A80148--mark--
                      g_hraq[l_ac].hraqacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hraq_file",g_hraq[l_ac].hraq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
    
    BEFORE FIELD hraq01
       IF cl_null(g_hraq[l_ac].hraq01) THEN
       	  SELECT MAX(hraq01)+1 INTO g_hraq[l_ac].hraq01 
       	    FROM hraq_file 
           WHERE 1=1
          IF cl_null(g_hraq[l_ac].hraq01) THEN
          	 LET g_hraq[l_ac].hraq01=1
          END IF
          DISPLAY BY NAME g_hraq[l_ac].hraq01
        END IF  		        	
    AFTER FIELD hraq01                        
       IF NOT cl_null(g_hraq[l_ac].hraq01) THEN       	 	  	                                            
          IF g_hraq[l_ac].hraq01 != g_hraq_t.hraq01 OR
             g_hraq_t.hraq01 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hraq_file
              WHERE hraq01 = g_hraq[l_ac].hraq01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hraq[l_ac].hraq01 = g_hraq_t.hraq01
                NEXT FIELD hraq01
             END IF
          END IF   
          DISPLAY BY NAME g_hraq[l_ac].hraq01                                          	
       END IF
       	
    AFTER FIELD hraq02
       IF NOT cl_null(g_hraq[l_ac].hraq02) THEN
          IF g_hraq[l_ac].hraq02 != g_hraq_t.hraq02 OR
             g_hraq_t.hraq02 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hraq_file
              WHERE hraq02 = g_hraq[l_ac].hraq02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hraq[l_ac].hraq02 = g_hraq_t.hraq02
                NEXT FIELD hraq02
             END IF
          END IF     
       END IF
       	
   
    AFTER FIELD hraqacti
       IF NOT cl_null(g_hraq[l_ac].hraqacti) THEN
          IF g_hraq[l_ac].hraqacti NOT MATCHES '[YN]' THEN 
             LET g_hraq[l_ac].hraqacti = g_hraq_t.hraqacti
             NEXT FIELD hraqacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hraq_t.hraq02 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hraq02"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hraq[l_ac].hraq02      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hraq_file WHERE hraq02 = g_hraq_t.hraq02
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hraq_file",g_hraq_t.hraq02,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
          	  LET g_rec_b=g_rec_b-1
          	  DISPLAY g_rec_b TO cn2    
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hraq[l_ac].* = g_hraq_t.*
         CLOSE i003_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hraq[l_ac].hraq01,-263,0)
          LET g_hraq[l_ac].* = g_hraq_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hraq_file SET hraq01=g_hraq[l_ac].hraq01,
                               hraq02=g_hraq[l_ac].hraq02,
                               hraq03=g_hraq[l_ac].hraq03,    
                               hraqacti=g_hraq[l_ac].hraqacti,
                               hraqmodu=g_user,
                               hraqdate=g_today
          WHERE hraq02 = g_hraq_t.hraq02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hraq_file",g_hraq_t.hraq02,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hraq[l_ac].* = g_hraq_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hraq[l_ac].* = g_hraq_t.*
          END IF
          CLOSE i003_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i003_bcl                
        COMMIT WORK  
 
 
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
 
    CLOSE i003_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i003_b_askkey()
    CLEAR FORM
    CALL g_hraq.clear()
 
    CONSTRUCT g_wc2 ON hraq01,hraq02,hraq03,hraqacti                       
         FROM s_hraq[1].hraq01,s_hraq[1].hraq02,s_hraq[1].hraq03,                                  
              s_hraq[1].hraqacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraquser', 'hraqgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i003_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i003_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
    LET g_sql = "SELECT hraq01,hraq02,hraq03,hraqacti",   #FUN-A30030 ADD POS #FUN-A30097
                "  FROM hraq_file",
                " WHERE ", p_wc2 CLIPPED, 
                " ORDER BY 1" 
 
    PREPARE i003_pb FROM g_sql
    DECLARE hraq_curs CURSOR FOR i003_pb
 
    CALL g_hraq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hraq_curs INTO g_hraq[g_cnt].*  
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
    CALL g_hraq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hraq TO s_hraq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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

      #add by zhangbo130830---begin
      ON ACTION ghri003_a
         LET g_action_choice = 'ghri003_a'
         EXIT DISPLAY
      #add by zhangbo130830---end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION		   	     		
