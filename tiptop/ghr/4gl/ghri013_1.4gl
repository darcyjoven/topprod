# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri013.4gl
# Descriptions...: 
# Date & Author..: 13/04/15 By Yougs 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_hrat01        LIKE hrat_file.hrat01  
DEFINE g_hrat01_t       LIKE hrat_file.hrat01,                                                        
    g_hrau           DYNAMIC ARRAY OF RECORD
        hrav02       LIKE hrav_file.hrav02,
        hrat01_1     LIKE hrat_file.hrat01, 
        hrat02_1     LIKE hrat_file.hrat02,                 
        hrau01       LIKE hrau_file.hrau01,                                                          
        hrau02       LIKE hrau_file.hrau02,                                                       
        hrau03       LIKE hrau_file.hrau03,
        hrav06       LIKE hrav_file.hrav06,
        str1         LIKE hrav_file.hrav07,        
        str2         LIKE hrav_file.hrav07,
        str3         LIKE type_file.dat,
        sdate        LIKE type_file.dat,
        bz           LIKE type_file.chr1000                                                 
                    END RECORD,                                                                 
    g_hrau_t         RECORD        
        hrav02       LIKE hrav_file.hrav02,
        hrat01_1     LIKE hrat_file.hrat01, 
        hrat02_1     LIKE hrat_file.hrat02,                 
        hrau01       LIKE hrau_file.hrau01,                                                          
        hrau02       LIKE hrau_file.hrau02,                                                       
        hrau03       LIKE hrau_file.hrau03,
        hrav06       LIKE hrav_file.hrav06,
        str1         LIKE hrav_file.hrav07,        
        str2         LIKE hrav_file.hrav07,
        str3         LIKE type_file.dat,
        sdate        LIKE type_file.dat,
        bz           LIKE type_file.chr1000                                                          
                    END RECORD,                                                                 
    g_hrau_o         RECORD               
        hrav02       LIKE hrav_file.hrav02,
        hrat01_1     LIKE hrat_file.hrat01, 
        hrat02_1     LIKE hrat_file.hrat02,                 
        hrau01       LIKE hrau_file.hrau01,                                                          
        hrau02       LIKE hrau_file.hrau02,                                                       
        hrau03       LIKE hrau_file.hrau03,
        hrav06       LIKE hrav_file.hrav06,
        str1         LIKE hrav_file.hrav07,        
        str2         LIKE hrav_file.hrav07,
        str3         LIKE type_file.dat,
        sdate        LIKE type_file.dat,
        bz           LIKE type_file.chr1000                                                             
                    END RECORD,                                                                    
    g_rec_b          LIKE type_file.num5,      
    g_rec_b_2        LIKE type_file.num5,                                                      
    g_wc,g_sql       STRING,                                                                        
    l_ac_1,l_ac_2    LIKE type_file.num5                                                         
DEFINE g_forupd_sql          STRING                                                             
DEFINE g_msg                 LIKE type_file.chr1000                                                            
DEFINE g_chr                 LIKE type_file.chr1                                                               
DEFINE g_cnt                 LIKE type_file.num10                                                              
DEFINE g_i                   LIKE type_file.num5                                                               
DEFINE g_row_count           LIKE type_file.num10                                                              
DEFINE g_curs_index          LIKE type_file.num10                                                              
DEFINE g_jump                LIKE type_file.num10                                                              
DEFINE g_no_ask              LIKE type_file.num5                                                                
DEFINE g_before_input_done   LIKE type_file.num5      
DEFINE g_hrav01              LIKE hrav_file.hrav01  
DEFINE g_action              LIKE type_file.chr20                                                          
 
FUNCTION ghri013_1(p_action,p_hrav01)
DEFINE p_action     LIKE type_file.chr20
DEFINE p_hrav01     LIKE hrav_file.hrav01	
    DEFINE p_argv1       LIKE ima_file.ima01

    WHENEVER ERROR CALL cl_err_msg_log                                                                

    OPEN WINDOW i013_1_w WITH FORM "ghr/42f/ghri013_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
    CALL cl_ui_init() 
    LET g_wc = " 1=1 "
    LET g_action = p_action
    LET g_hrav01 = p_hrav01  
    IF g_action = "insert" THEN
    	 CALL i013_1_a()
    END IF
    IF g_action = "update" THEN
    	 CALL i013_1_b_fill("1=1")
    	 CALL i013_1_b()
    END IF 	 	 	 
    CALL i013_1_menu()
    CLOSE WINDOW i013_1_w                                     
END FUNCTION                                                   
                                                               
                                                               
FUNCTION i013_1_curs()                                        
    CLEAR FORM                                                 
    CALL g_hrau.clear()                                      
    CALL cl_set_head_visible("","YES") 
    LET g_wc = " 1=1 "   
    CONSTRUCT g_wc ON hrat01 FROM hrat01 

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrat01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrat01"
                   LET g_qryparam.state= "c"        
                   CALL cl_create_qry() RETURNING g_qryparam.multiret   
                   DISPLAY g_qryparam.multiret TO hrat01 
                   NEXT FIELD hrat01
                OTHERWISE
                   EXIT CASE
            END CASE
  
        ON ACTION qbe_select
           CALL cl_qbe_select()
        ON ACTION qbe_save
           CALL cl_qbe_save() 
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
           CALL cl_cmdask() 
 
    END CONSTRUCT   
    IF INT_FLAG THEN RETURN END IF  
    IF cl_null(g_wc) THEN
    	 LET g_wc = " 1=1 "
    END IF 	 
END FUNCTION
 
FUNCTION i013_1_menu()
 
   WHILE TRUE
      CALL i013_1_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i013_1_a()
            END IF  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i013_1_b2() 
            END IF
            LET g_action_choice = "" 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrau),'','')
            END IF                       
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i013_1_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_hrau.clear()
    
    IF s_shut(0) THEN RETURN END IF  
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i013_1_curs()                                        
        IF INT_FLAG THEN                                           
            LET INT_FLAG = 0                                       
            CALL cl_err('',9001,0)                                 
            EXIT WHILE                                             
        END IF                                                     
        LET g_rec_b_2 = 0                                             
        CALL g_hrau.clear()                                                      
        CALL i013_1_b2()             
        EXIT WHILE
    END WHILE
END FUNCTION          
  
FUNCTION i013_1_b()
DEFINE l_hrau04     LIKE hrau_file.hrau04
DEFINE l_hrau05     LIKE hrau_file.hrau05
DEFINE l_hrau07     LIKE hrau_file.hrau07
DEFINE
    l_ac_1_t          LIKE type_file.num5,                                                
    l_n             LIKE type_file.num5,                                                
    l_lock_sw       LIKE type_file.chr1,                                                
    p_cmd           LIKE type_file.chr1,                                                
    l_allow_insert  LIKE type_file.num5,                                                
    l_allow_delete  LIKE type_file.num5                                                 
 
    LET g_action_choice = ""
  
    CALL cl_set_comp_visible("hrav02,hrat01_1,hrat02_1,hrav06",TRUE)
    CALL cl_set_comp_entry("hrav02,hrat01_1,hrat02_1,hrav06",FALSE)
    CALL cl_opmsg('b') 
    LET g_forupd_sql = " SELECT hrav02,hrat01,hrat02,hrav04,hrav05,'',hrav06,'','','',hrav08,hrav09 FROM hrav_file,hrat_file WHERE hrav01=? AND hrav02=? AND hratid = hrav03 FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i013_1_b_curl CURSOR FROM g_forupd_sql
 
    LET l_ac_1_t = 0  
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_hrau WITHOUT DEFAULTS FROM s_hrau.*  
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=l_allow_delete,APPEND ROW=FALSE)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac_1)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac_1 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b >= l_ac_1 THEN
                LET p_cmd='u'
                LET g_hrau_t.* = g_hrau[l_ac_1].*  #BACKUP
                OPEN i013_1_b_curl USING g_hrav01,g_hrau_t.hrav02
                IF STATUS THEN
                   CALL cl_err("OPEN i013_1_b_curl:", STATUS, 1)
                   CLOSE i013_1_b_curl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i013_1_b_curl INTO g_hrau[l_ac_1].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrau_t.hrau01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_hrau_t.*=g_hrau[l_ac_1].*
                       LET g_hrau_o.*=g_hrau[l_ac_1].*
                   END IF
                END IF
                SELECT hrau03,hrau04 INTO g_hrau[l_ac_1].hrau03,l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrau[l_ac_1].hrau01
                   AND hrau02 = g_hrau[l_ac_1].hrau02 	
                DISPLAY BY NAME g_hrau[l_ac_1].hrau03
                IF l_hrau04 = '1' THEN
                	 CALL cl_set_comp_required("str1",TRUE) 	
                	 CALL cl_set_comp_entry("str1",TRUE)
                   CALL cl_set_comp_required("str2,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str2,str3",FALSE)
                	 LET g_hrau[l_ac_1].str2 = ''
                	 LET g_hrau[l_ac_1].str3 = ''
                END IF
                IF l_hrau04 = '2' THEN
                	 CALL cl_set_comp_required("str2",TRUE) 	
                	 CALL cl_set_comp_entry("str2",TRUE)
                   CALL cl_set_comp_required("str1,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str3",FALSE)
                	 LET g_hrau[l_ac_1].str1 = ''
                	 LET g_hrau[l_ac_1].str3 = ''
                END IF 	
                IF l_hrau04 = '3' THEN
                	 CALL cl_set_comp_required("str3",TRUE) 	
                	 CALL cl_set_comp_entry("str3",TRUE)
                   CALL cl_set_comp_required("str1,str2",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str2",FALSE)
                	 LET g_hrau[l_ac_1].str1 = ''
                	 LET g_hrau[l_ac_1].str2 = ''
                END IF 			 	   	  
                CALL cl_show_fld_cont()      
            END IF  
        AFTER FIELD hrau01                       
            IF g_hrau[l_ac_1].hrau01 IS NOT NULL THEN 
            	 LET l_n = 0
               SELECT count(*) INTO l_n
                 FROM hrau_file
                WHERE hrau01 = g_hrau[l_ac_1].hrau01
               IF l_n = 0 OR cl_null(l_n) THEN
                  CALL cl_err('',-6001,0)
                  LET g_hrau[l_ac_1].hrau01 = g_hrau_t.hrau01
                  NEXT FIELD hrau01
               END IF 
               IF g_hrau[l_ac_1].hrau02 IS NOT NULL THEN
               	 LET l_n = 0 
                  SELECT count(*) INTO l_n
                    FROM hrau_file
                   WHERE hrau01 = g_hrau[l_ac_1].hrau01
                     AND hrau02 = g_hrau[l_ac_1].hrau02
                  IF l_n = 0 OR cl_null(l_n) THEN
                     CALL cl_err('',-217,0)
                     LET g_hrau[l_ac_1].hrau01 = g_hrau_t.hrau01
                     NEXT FIELD hrau01
                  END IF  
                  SELECT hrau03,hrau04 INTO g_hrau[l_ac_1].hrau03,l_hrau04 FROM hrau_file
                   WHERE hrau01 = g_hrau[l_ac_1].hrau01
                     AND hrau02 = g_hrau[l_ac_1].hrau02 	
                  DISPLAY BY NAME g_hrau[l_ac_1].hrau03
                  IF l_hrau04 = '1' THEN
                   	 CALL cl_set_comp_required("str1",TRUE) 	
                   	 CALL cl_set_comp_entry("str1",TRUE)
                     CALL cl_set_comp_required("str2,str3",FALSE) 	
                   	 CALL cl_set_comp_entry("str2,str3",FALSE)
                   	 LET g_hrau[l_ac_1].str2 = ''
                   	 LET g_hrau[l_ac_1].str3 = ''
                  END IF
                  IF l_hrau04 = '2' THEN
                   	 CALL cl_set_comp_required("str2",TRUE) 	
                   	 CALL cl_set_comp_entry("str2",TRUE)
                     CALL cl_set_comp_required("str1,str3",FALSE) 	
                   	 CALL cl_set_comp_entry("str1,str3",FALSE)
                   	 LET g_hrau[l_ac_1].str1 = ''
                   	 LET g_hrau[l_ac_1].str3 = ''
                  END IF 	
                  IF l_hrau04 = '3' THEN
                   	 CALL cl_set_comp_required("str3",TRUE) 	
                   	 CALL cl_set_comp_entry("str3",TRUE)
                     CALL cl_set_comp_required("str1,str2",FALSE) 	
                   	 CALL cl_set_comp_entry("str1,str2",FALSE)
                   	 LET g_hrau[l_ac_1].str1 = ''
                   	 LET g_hrau[l_ac_1].str2 = ''
                  END IF	   
               END IF     
            END IF
        AFTER FIELD hrau02                      
            IF g_hrau[l_ac_1].hrau02 IS NOT NULL AND g_hrau[l_ac_1].hrau01 IS NOT NULL THEN
            	 LET l_n = 0 
               SELECT count(*) INTO l_n
                 FROM hrau_file
                WHERE hrau01 = g_hrau[l_ac_1].hrau01
                  AND hrau02 = g_hrau[l_ac_1].hrau02
               IF l_n = 0 OR cl_null(l_n) THEN
                  CALL cl_err('',-217,0)
                  LET g_hrau[l_ac_1].hrau02 = g_hrau_t.hrau02
                  NEXT FIELD hrau02
               END IF  
               SELECT hrau03,hrau04 INTO g_hrau[l_ac_1].hrau03,l_hrau04 FROM hrau_file
                WHERE hrau01 = g_hrau[l_ac_1].hrau01
                  AND hrau02 = g_hrau[l_ac_1].hrau02 	
               DISPLAY BY NAME g_hrau[l_ac_1].hrau03
               IF l_hrau04 = '1' THEN
                	 CALL cl_set_comp_required("str1",TRUE) 	
                	 CALL cl_set_comp_entry("str1",TRUE)
                   CALL cl_set_comp_required("str2,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str2,str3",FALSE)
                	 NEXT FIELD str1
                END IF
                IF l_hrau04 = '2' THEN
                	 CALL cl_set_comp_required("str2",TRUE) 	
                	 CALL cl_set_comp_entry("str2",TRUE)
                   CALL cl_set_comp_required("str1,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str3",FALSE)
                	 NEXT FIELD str2
                END IF 	
                IF l_hrau04 = '3' THEN
                	 CALL cl_set_comp_required("str3",TRUE) 	
                	 CALL cl_set_comp_entry("str3",TRUE)
                   CALL cl_set_comp_required("str1,str2",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str2",FALSE)
                	 NEXT FIELD str3
                END IF 		   
            END IF  
 
        BEFORE DELETE                            
            IF g_hrau_t.hrau01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM hrav_file
                 WHERE hrav01 = g_hrav01 
                   AND hrav02 = g_hrau_t.hrav02
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("del","hrau_file",g_hrav01,g_hrau_t.hrav02,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrau[l_ac_1].* = g_hrau_t.*
               CLOSE i013_1_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrau[l_ac_1].hrau01,-263,1)
               LET g_hrau[l_ac_1].* = g_hrau_t.*
            ELSE
            	  LET l_hrau04 = ''
            	  SELECT hrau04 INTO l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrau[l_ac_1].hrau01
                   AND hrau02 = g_hrau[l_ac_1].hrau02 	
                IF l_hrau04 = '1' THEN    
                   UPDATE hrav_file SET hrav04 = g_hrau[l_ac_1].hrau01,
                                        hrav05 = g_hrau[l_ac_1].hrau02,
                                        hrav07 = g_hrau[l_ac_1].str1,
                                        hrav08 = g_hrau[l_ac_1].sdate,
                                        hrav09 = g_hrau[l_ac_1].bz,
                                        hravmodu = g_user,
                                        hravdate = g_today
                   WHERE hrav01 = g_hrav01 AND hrav02=g_hrau_t.hrav02  
                END IF
                IF l_hrau04 = '2' THEN    
                   UPDATE hrav_file SET hrav04 = g_hrau[l_ac_1].hrau01,
                                        hrav05 = g_hrau[l_ac_1].hrau02,
                                        hrav07 = g_hrau[l_ac_1].str2,
                                        hrav08 = g_hrau[l_ac_1].sdate,
                                        hrav09 = g_hrau[l_ac_1].bz,
                                        hravmodu = g_user,
                                        hravdate = g_today
                   WHERE hrav01 = g_hrav01 AND hrav02=g_hrau_t.hrav02  
                END IF
                IF l_hrau04 = '3' THEN    
                   UPDATE hrav_file SET hrav04 = g_hrau[l_ac_1].hrau01,
                                        hrav05 = g_hrau[l_ac_1].hrau02,
                                        hrav07 = g_hrau[l_ac_1].str3,
                                        hrav08 = g_hrau[l_ac_1].sdate,
                                        hrav09 = g_hrau[l_ac_1].bz,
                                        hravmodu = g_user,
                                        hravdate = g_today
                   WHERE hrav01 = g_hrav01 AND hrav02=g_hrau_t.hrav02  
                END IF		   
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("upd","hrau_file",g_hrav01,g_hrau_t.hrav02,SQLCA.sqlcode,"","",1)   
                    LET g_hrau[l_ac_1].* = g_hrau_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac_1 = ARR_CURR()
            LET l_ac_1_t = l_ac_1
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrau[l_ac_1].* = g_hrau_t.*
               END IF
               CLOSE i013_1_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i013_1_b_curl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrau01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau01"
                   LET g_qryparam.default1 = g_hrau[l_ac_1].hrau01
                   CALL cl_create_qry() RETURNING g_hrau[l_ac_1].hrau01
                   DISPLAY g_hrau[l_ac_1].hrau01 TO hrau01  
                   NEXT FIELD hrau01
                WHEN INFIELD(hrau02) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau02"
                   LET g_qryparam.default1 = g_hrau[l_ac_1].hrau02
                   IF NOT cl_null(g_hrau[l_ac_1].hrau01) THEN
                   	  LET g_qryparam.where = " hrau01 = '",g_hrau[l_ac_1].hrau01,"' "
                   END IF	  
                   CALL cl_create_qry() RETURNING g_hrau[l_ac_1].hrau02
                   DISPLAY g_hrau[l_ac_1].hrau01 TO hrau02  
                   NEXT FIELD hrau02  
                WHEN INFIELD(str1) 
                   LET l_hrau05 = ''
                   LET l_hrau07 = ''
                   SELECT hrau05,hrau07 INTO l_hrau05,l_hrau07 FROM hrau_file
                    WHERE hrau01 = g_hrau[l_ac_1].hrau01
                      AND hrau02 = g_hrau[l_ac_1].hrau02  
                   CALL cl_init_qry_var() 
                   LET g_qryparam.form =l_hrau05
                   IF l_hrau07 IS NOT NULL THEN
                   	  LET g_qryparam.arg1 = l_hrau07
                   END IF	  
                   LET g_qryparam.default1 = g_hrau[l_ac_1].str1
                   CALL cl_create_qry() RETURNING g_hrau[l_ac_1].str1
                   DISPLAY g_hrau[l_ac_1].str1 TO str1 
                   NEXT FIELD str1   
                OTHERWISE
                   EXIT CASE
            END CASE 
 
        ON ACTION CONTROLO                         
            IF INFIELD(hrau01) AND l_ac_1 > 1 THEN
                LET g_hrau[l_ac_1].* = g_hrau[l_ac_1-1].*
                DISPLAY g_hrau[l_ac_1].* TO s_hrau[l_ac_1].*
                NEXT FIELD hrau01
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
                                                                                                                                      
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")    
 
    END INPUT
    
    CLOSE i013_1_b_curl
    COMMIT WORK
END FUNCTION
   
 
FUNCTION i013_1_b_fill(p_wc)               
DEFINE  p_wc            LIKE type_file.chr1000  
DEFINE l_hrau04         LIKE hrau_file.hrau04
    
    IF g_action = "update" THEN
       LET g_sql = "SELECT hrav02,hrat01,hrat02,hrav04,hrav05,'',hrav06,'','','',hrav08,hrav09 FROM hrav_file,hrat_file WHERE hrav01='",g_hrav01,"' AND hratid = hrav03 "
    ELSE
       LET g_sql = " SELECT DISTINCT '','','',hrav04,hrav05,'','','','','',hrav08,hrav09 FROM hrav_file,hrat_file WHERE hrav01='",g_hrav01,"' hratid = hrav03 AND ",g_wc
    END IF	 
    PREPARE i013_1_prepare2 FROM g_sql       
    DECLARE hrau_curs CURSOR FOR i013_1_prepare2
    CALL g_hrau.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH hrau_curs INTO g_hrau[g_cnt].* 
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT hrau03,hrau04 INTO g_hrau[g_cnt].hrau03,l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrau[g_cnt].hrau01
                   AND hrau02 = g_hrau[g_cnt].hrau02 	
       IF l_hrau04 = '1' THEN
       	  SELECT hrav07 INTO g_hrau[g_cnt].str1 FROM hrav_file
       	   WHERE hrav01 = g_hrav01 
       	     AND hrav04 = g_hrau[g_cnt].hrau01
       	     AND hrav02 = g_hrau[g_cnt].hrau02
       	     AND rownum = 1
       END IF	
       IF l_hrau04 = '2' THEN
       	  SELECT hrav07 INTO g_hrau[g_cnt].str2 FROM hrav_file
       	   WHERE hrav01 = g_hrav01 
       	     AND hrav04 = g_hrau[g_cnt].hrau01
       	     AND hrav02 = g_hrau[g_cnt].hrau02
       	     AND rownum = 1
       END IF	
       IF l_hrau04 = '3' THEN
       	  SELECT to_date(hrav07,'yy/mm/dd') INTO g_hrau[g_cnt].str3 FROM hrav_file
       	   WHERE hrav01 = g_hrav01 
       	     AND hrav04 = g_hrau[g_cnt].hrau01
       	     AND hrav02 = g_hrau[g_cnt].hrau02
       	     AND rownum = 1
       END IF			                    
       LET g_cnt = g_cnt + 1 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_hrau.deleteElement(g_cnt)
    IF g_action = "update" THEN
       LET g_rec_b = g_cnt - 1
       DISPLAY g_rec_b TO FORMONLY.cn2
    ELSE
    	 LET g_rec_b_2 = g_cnt - 1
       DISPLAY g_rec_b_2 TO FORMONLY.cn2
    END IF	   
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i013_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrau TO s_hrau.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac_2 = ARR_CURR()
         CALL cl_show_fld_cont()                    
      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY       
  
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_2 = 1
         EXIT DISPLAY 
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
  
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
  
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac_2 = ARR_CURR()
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
 
      ON ACTION related_document                                           
         LET g_action_choice="related_document"                            
         EXIT DISPLAY                                                      
  
      AFTER DISPLAY
         CONTINUE DISPLAY 
                                                                                                     
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
	
FUNCTION i013_1_b2()
DEFINE l_hrau04     LIKE hrau_file.hrau04
DEFINE l_hrau05     LIKE hrau_file.hrau05
DEFINE l_hrau07     LIKE hrau_file.hrau07
DEFINE l_sql,l_sql2 STRING
DEFINE l_flag       LIKE type_file.chr1
DEFINE
    l_ac_2_t          LIKE type_file.num5,                                                
    l_n             LIKE type_file.num5,                                                
    l_lock_sw       LIKE type_file.chr1,                                                
    p_cmd           LIKE type_file.chr1,                                                
    l_allow_insert  LIKE type_file.num5,                                                
    l_allow_delete  LIKE type_file.num5                                                 
 
    LET g_action_choice = ""
  
    CALL cl_set_comp_visible("hrav02,hrat01_1,hrat02_1,hrav06",FALSE)
    CALL cl_set_comp_entry("hrav02,hrat01_1,hrat02_1,hrav06",FALSE)
    CALL cl_opmsg('b')  
    LET g_forupd_sql = " SELECT DISTINCT '','','',hrav04,hrav05,'','','','','',hrav08,hrav09 FROM hrav_file WHERE hrav01=? AND hrav04=? AND hrav05 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i013_1_b_cur2 CURSOR FROM g_forupd_sql
 
    LET l_ac_2_t = 0  
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_hrau WITHOUT DEFAULTS FROM s_hrau.*  
          ATTRIBUTE(COUNT=g_rec_b_2,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b_2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac_2)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac_2 = ARR_CURR()
            LET l_lock_sw = 'N'             
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b_2 >= l_ac_2 THEN
                LET p_cmd='u'
                LET g_hrau_t.* = g_hrau[l_ac_2].*   
                OPEN i013_1_b_cur2 USING g_hrav01,g_hrau_t.hrau01,g_hrau_t.hrau02
                IF STATUS THEN
                   CALL cl_err("OPEN i013_1_b_cur2:", STATUS, 1)
                   CLOSE i013_1_b_cur2
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i013_1_b_cur2 INTO g_hrau[l_ac_2].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrau_t.hrau01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_hrau_t.*=g_hrau[l_ac_2].*
                       LET g_hrau_o.*=g_hrau[l_ac_2].*
                   END IF
                END IF
                SELECT hrau03,hrau04 INTO g_hrau[l_ac_2].hrau03,l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrau[l_ac_2].hrau01
                   AND hrau02 = g_hrau[l_ac_2].hrau02 	
                DISPLAY BY NAME g_hrau[l_ac_2].hrau03
                IF l_hrau04 = '1' THEN
                	 CALL cl_set_comp_required("str1",TRUE) 	
                	 CALL cl_set_comp_entry("str1",TRUE)
                   CALL cl_set_comp_required("str2,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str2,str3",FALSE)
                	 LET g_hrau[l_ac_2].str2 = ''
                	 LET g_hrau[l_ac_2].str3 = ''
                END IF
                IF l_hrau04 = '2' THEN
                	 CALL cl_set_comp_required("str2",TRUE) 	
                	 CALL cl_set_comp_entry("str2",TRUE)
                   CALL cl_set_comp_required("str1,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str3",FALSE)
                	 LET g_hrau[l_ac_2].str1 = ''
                	 LET g_hrau[l_ac_2].str3 = ''
                END IF 	
                IF l_hrau04 = '3' THEN
                	 CALL cl_set_comp_required("str3",TRUE) 	
                	 CALL cl_set_comp_entry("str3",TRUE)
                   CALL cl_set_comp_required("str1,str2",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str2",FALSE)
                	 LET g_hrau[l_ac_2].str1 = ''
                	 LET g_hrau[l_ac_2].str2 = ''
                END IF 			 	   	  
                CALL cl_show_fld_cont()      
            END IF 
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET l_flag = 'Y'
           CALL i013_1_ins() RETURNING l_flag
           IF l_flag = 'N' THEN 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b_2=g_rec_b_2+1
              COMMIT WORK
              DISPLAY g_rec_b_2 TO FORMONLY.cn2  
           END IF 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrau[l_ac_2].* TO NULL                   
            LET g_hrau[l_ac_2].sdate = g_today                      
            LET g_hrau_t.* = g_hrau[l_ac_2].*                      
            LET g_hrau_o.* = g_hrau[l_ac_2].*                      
            CALL cl_show_fld_cont()     
            NEXT FIELD hrau01
 
        AFTER FIELD hrau01                       
            IF g_hrau[l_ac_2].hrau01 IS NOT NULL THEN 
            	 LET l_n = 0
               SELECT count(*) INTO l_n
                 FROM hrau_file
                WHERE hrau01 = g_hrau[l_ac_2].hrau01
               IF l_n = 0 OR cl_null(l_n) THEN
                  CALL cl_err('',-6001,0)
                  LET g_hrau[l_ac_2].hrau01 = g_hrau_t.hrau01
                  NEXT FIELD hrau01
               END IF 
               IF g_hrau[l_ac_2].hrau02 IS NOT NULL THEN
               	 LET l_n = 0 
                  SELECT count(*) INTO l_n
                    FROM hrau_file
                   WHERE hrau01 = g_hrau[l_ac_2].hrau01
                     AND hrau02 = g_hrau[l_ac_2].hrau02
                  IF l_n = 0 OR cl_null(l_n) THEN
                     CALL cl_err('',-217,0)
                     LET g_hrau[l_ac_2].hrau01 = g_hrau_t.hrau01
                     NEXT FIELD hrau01
                  END IF  
                  SELECT hrau03,hrau04 INTO g_hrau[l_ac_2].hrau03,l_hrau04 FROM hrau_file
                   WHERE hrau01 = g_hrau[l_ac_2].hrau01
                     AND hrau02 = g_hrau[l_ac_2].hrau02 	
                  DISPLAY BY NAME g_hrau[l_ac_2].hrau03
                  IF l_hrau04 = '1' THEN
                   	 CALL cl_set_comp_required("str1",TRUE) 	
                   	 CALL cl_set_comp_entry("str1",TRUE)
                     CALL cl_set_comp_required("str2,str3",FALSE) 	
                   	 CALL cl_set_comp_entry("str2,str3",FALSE)
                   	 LET g_hrau[l_ac_2].str2 = ''
                   	 LET g_hrau[l_ac_2].str3 = ''
                  END IF
                  IF l_hrau04 = '2' THEN
                   	 CALL cl_set_comp_required("str2",TRUE) 	
                   	 CALL cl_set_comp_entry("str2",TRUE)
                     CALL cl_set_comp_required("str1,str3",FALSE) 	
                   	 CALL cl_set_comp_entry("str1,str3",FALSE)
                   	 LET g_hrau[l_ac_2].str1 = ''
                   	 LET g_hrau[l_ac_2].str3 = ''
                  END IF 	
                  IF l_hrau04 = '3' THEN
                   	 CALL cl_set_comp_required("str3",TRUE) 	
                   	 CALL cl_set_comp_entry("str3",TRUE)
                     CALL cl_set_comp_required("str1,str2",FALSE) 	
                   	 CALL cl_set_comp_entry("str1,str2",FALSE)
                   	 LET g_hrau[l_ac_2].str1 = ''
                   	 LET g_hrau[l_ac_2].str2 = ''
                  END IF	   
               END IF     
            END IF
        AFTER FIELD hrau02                      
            IF g_hrau[l_ac_2].hrau02 IS NOT NULL AND g_hrau[l_ac_2].hrau01 IS NOT NULL THEN
            	 LET l_n = 0 
               SELECT count(*) INTO l_n
                 FROM hrau_file
                WHERE hrau01 = g_hrau[l_ac_2].hrau01
                  AND hrau02 = g_hrau[l_ac_2].hrau02
               IF l_n = 0 OR cl_null(l_n) THEN
                  CALL cl_err('',-217,0)
                  LET g_hrau[l_ac_2].hrau02 = g_hrau_t.hrau02
                  NEXT FIELD hrau02
               END IF  
               SELECT hrau03,hrau04 INTO g_hrau[l_ac_2].hrau03,l_hrau04 FROM hrau_file
                WHERE hrau01 = g_hrau[l_ac_2].hrau01
                  AND hrau02 = g_hrau[l_ac_2].hrau02 	
               DISPLAY BY NAME g_hrau[l_ac_2].hrau03
               IF l_hrau04 = '1' THEN
                	 CALL cl_set_comp_required("str1",TRUE) 	
                	 CALL cl_set_comp_entry("str1",TRUE)
                   CALL cl_set_comp_required("str2,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str2,str3",FALSE)
                	 NEXT FIELD str1
                END IF
                IF l_hrau04 = '2' THEN
                	 CALL cl_set_comp_required("str2",TRUE) 	
                	 CALL cl_set_comp_entry("str2",TRUE)
                   CALL cl_set_comp_required("str1,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str3",FALSE)
                	 NEXT FIELD str2
                END IF 	
                IF l_hrau04 = '3' THEN
                	 CALL cl_set_comp_required("str3",TRUE) 	
                	 CALL cl_set_comp_entry("str3",TRUE)
                   CALL cl_set_comp_required("str1,str2",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str2",FALSE)
                	 NEXT FIELD str3
                END IF 		   
            END IF  
 
        BEFORE DELETE                            
            IF g_hrau_t.hrau01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                LET l_sql = "DELETE FROM hrav_file ",
                            " WHERE hrav04 = '",g_hrau_t.hrau01,"'", 
                            "   AND hrav05 = '",g_hrau_t.hrau02,"'",
                            "   AND hrav01 = '",g_hrav01,"'",
                            "   AND hrav03 IN (SELECT hratid FROM hrat_file WHERE ",g_wc," )" 
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("del","hrau_file",g_hrav01,g_hrau_t.hrau01,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b_2=g_rec_b_2-1
                DISPLAY g_rec_b_2 TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrau[l_ac_2].* = g_hrau_t.*
               CLOSE i013_1_b_cur2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrau[l_ac_2].hrau01,-263,1)
               LET g_hrau[l_ac_2].* = g_hrau_t.*
            ELSE
            	  LET l_hrau04 = ''
            	  SELECT hrau04 INTO l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrau[l_ac_2].hrau01
                   AND hrau02 = g_hrau[l_ac_2].hrau02 	
                IF l_hrau04 = '1' THEN
                   LET l_sql = "UPDATE hrav_file SET hrav04 = '",g_hrau[l_ac_2].hrau01,"',",
                                                  " hrav05 = '",g_hrau[l_ac_2].hrau02,"',",
                                                  " hrav07 = '",g_hrau[l_ac_2].str1,"',",
                                                  " hrav08 = to_date('",g_hrau[l_ac_2].sdate,"','yy/mm/dd'),",
                                                  " hrav09 = '",g_hrau[l_ac_2].bz,"',",
                                                  " hravmodu = '",g_user,"',",
                                                  " hravdate = to_date('",g_today,"','yy/mm/dd') ",
                             " WHERE hrav01 = '",g_hrav01,"'",
                             "   AND hrav04 = '",g_hrau_t.hrau01,"'",
                             "   AND hrav05 = '",g_hrau_t.hrau02,"'",  
                             "   AND hrav03 IN (SELECT hratid FROM hrat_file WHERE ",g_wc," )"  
                END IF
                IF l_hrau04 = '2' THEN    
                   LET l_sql = "UPDATE hrav_file SET hrav04 = '",g_hrau[l_ac_2].hrau01,"',",
                                                  " hrav05 = '",g_hrau[l_ac_2].hrau02,"',",
                                                  " hrav07 = '",g_hrau[l_ac_2].str2,"',",
                                                  " hrav08 = to_date('",g_hrau[l_ac_2].sdate,"','yy/mm/dd'),",
                                                  " hrav09 = '",g_hrau[l_ac_2].bz,"',",
                                                  " hravmodu = '",g_user,"',",
                                                  " hravdate = to_date('",g_today,"','yy/mm/dd') ",
                             " WHERE hrav01 = '",g_hrav01,"'",
                             "   AND hrav04 = '",g_hrau_t.hrau01,"'",
                             "   AND hrav05 = '",g_hrau_t.hrau02,"'",  
                             "   AND hrav03 IN (SELECT hratid FROM hrat_file WHERE ",g_wc," )"  
                END IF
                IF l_hrau04 = '3' THEN    
                   LET l_sql = "UPDATE hrav_file SET hrav04 = '",g_hrau[l_ac_2].hrau01,"',",
                                                  " hrav05 = '",g_hrau[l_ac_2].hrau02,"',",
                                                  " hrav07 = to_date('",g_hrau[l_ac_2].str3,"','yy/mm/dd'),",
                                                  " hrav08 = to_date('",g_hrau[l_ac_2].sdate,"','yy/mm/dd'),",
                                                  " hrav09 = '",g_hrau[l_ac_2].bz,"',",
                                                  " hravmodu = '",g_user,"',",
                                                  " hravdate = to_date('",g_today,"','yy/mm/dd') ",
                             " WHERE hrav01 = '",g_hrav01,"'",
                             "   AND hrav04 = '",g_hrau_t.hrau01,"'",
                             "   AND hrav05 = '",g_hrau_t.hrau02,"'",  
                             "   AND hrav03 IN (SELECT hratid FROM hrat_file WHERE ",g_wc," )"  
                END IF		   
                PREPARE hav_upd FROM l_sql
                EXECUTE hav_upd
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("upd","hrau_file",g_hrav01,g_hrau_t.hrau01,SQLCA.sqlcode,"","",1)   
                   LET g_hrau[l_ac_2].* = g_hrau_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac_2 = ARR_CURR()
            LET l_ac_2_t = l_ac_2
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrau[l_ac_2].* = g_hrau_t.*
               END IF
               CLOSE i013_1_b_cur2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i013_1_b_cur2
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrau01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau01"
                   LET g_qryparam.default1 = g_hrau[l_ac_2].hrau01
                   CALL cl_create_qry() RETURNING g_hrau[l_ac_2].hrau01
                   DISPLAY g_hrau[l_ac_2].hrau01 TO hrau01  
                   NEXT FIELD hrau01
                WHEN INFIELD(hrau02) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau02"
                   LET g_qryparam.default1 = g_hrau[l_ac_2].hrau02
                   IF NOT cl_null(g_hrau[l_ac_2].hrau01) THEN
                   	  LET g_qryparam.where = " hrau01 = '",g_hrau[l_ac_2].hrau01,"' "
                   END IF	  
                   CALL cl_create_qry() RETURNING g_hrau[l_ac_2].hrau02
                   DISPLAY g_hrau[l_ac_2].hrau01 TO hrau02  
                   NEXT FIELD hrau02  
                WHEN INFIELD(str1) 
                   LET l_hrau05 = ''
                   LET l_hrau07 = ''
                   SELECT hrau05,hrau07 INTO l_hrau05,l_hrau07 FROM hrau_file
                    WHERE hrau01 = g_hrau[l_ac_2].hrau01
                      AND hrau02 = g_hrau[l_ac_2].hrau02  
                   CALL cl_init_qry_var() 
                   LET g_qryparam.form =l_hrau05
                   IF l_hrau07 IS NOT NULL THEN
                   	  LET g_qryparam.arg1 = l_hrau07
                   END IF	  
                   LET g_qryparam.default1 = g_hrau[l_ac_2].str1
                   CALL cl_create_qry() RETURNING g_hrau[l_ac_2].str1
                   DISPLAY g_hrau[l_ac_2].str1 TO str1 
                   NEXT FIELD str1   
                OTHERWISE
                   EXIT CASE
            END CASE 
 
        ON ACTION CONTROLO                         
            IF INFIELD(hrau01) AND l_ac_2 > 1 THEN
                LET g_hrau[l_ac_2].* = g_hrau[l_ac_2-1].*
                DISPLAY g_hrau[l_ac_2].* TO s_hrau[l_ac_2].*
                NEXT FIELD hrau01
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
                                                                                                                                      
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")    
 
    END INPUT
    
    CLOSE i013_1_b_cur2
    COMMIT WORK
END FUNCTION
   
FUNCTION i013_1_ins()
DEFINE l_sql       STRING
DEFINE l_hrav      RECORD LIKE hrav_file.*
DEFINE l_hratid    LIKE hrat_file.hratid
DEFINE l_max       LIKE type_file.num5
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_hrau04    LIKE hrau_file.hrau04
DEFINE l_hrau06    LIKE hrau_file.hrau06
DEFINE l_sql2      STRING
    LET l_flag = 'Y'
    LET l_sql = "SELECT DISTINCT hratid FROM hrat_file ",
                " WHERE ",g_wc
    DECLARE i013_1_hrat_curs CURSOR FROM l_sql
    FOREACH i013_1_hrat_curs INTO l_hratid
       INITIALIZE l_hrav.* TO NULL
       LET l_hrav.hrav01 = g_hrav01
       LET l_max = 1
       SELECT MAX(hrav02)+1 INTO l_max FROM hrav_file
        WHERE hrav01 = l_hrav.hrav01
       IF cl_null(l_max) THEN
          LET l_max = 1
       END IF
       LET l_hrav.hrav02 = l_max   
       LET l_hrav.hrav03 = l_hratid
       LET l_hratid = ''
       LET l_hrav.hrav04 = g_hrau[l_ac_2].hrau01
       LET l_hrav.hrav05 = g_hrau[l_ac_2].hrau02
       LET l_sql2 = "SELECT ",l_hrav.hrav05," FROM hrat_file ",
                    " WHERE hratid = '",l_hrav.hrav03,"'"
       PREPARE hrav05_pre FROM l_sql2
       EXECUTE hrav05_pre INTO l_hrav.hrav06
       
       LET l_hrau04 = ''
       SELECT hrau04 INTO l_hrau04 FROM hrau_file
        WHERE hrau01 = g_hrau[l_ac_2].hrau01
          AND hrau02 = g_hrau[l_ac_2].hrau02  
       IF l_hrau04 = '1' THEN 
          LET l_hrav.hrav07 = g_hrau[l_ac_2].str1
       END IF
       IF l_hrau04 = '2' THEN 
          LET l_hrav.hrav07 = g_hrau[l_ac_2].str2
       END IF
       IF l_hrau04 = '3' THEN 
          LET l_hrav.hrav07 = g_hrau[l_ac_2].str3
       END IF   
       LET l_hrav.hrav08 = g_hrau[l_ac_2].sdate
       LET l_hrav.hrav09 = g_hrau[l_ac_2].bz
       LET l_hrav.hrav10 = 'N'
       LET l_hrav.hravoriu = g_user
       LET l_hrav.hravorig = g_grup
       LET l_hrav.hravuser = g_user
       LET l_hrav.hravgrup = g_grup
       LET l_hrav.hravdate = g_today
       INSERT INTO hrav_file VALUES(l_hrav.*)
       IF SQLCA.sqlcode THEN 
          CALL cl_err3("ins","hrau_file",l_hrav.hrav01,l_hrav.hrav02,
                            SQLCA.sqlcode,"","",1)   
          LET l_flag = 'N'   
       END IF
    END FOREACH     
    RETURN l_flag             
END FUNCTION	   

