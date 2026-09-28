# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri106.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrai           DYNAMIC ARRAY OF RECORD    
        hrai01       LIKE hrai_file.hrai01,     
        hrai02       LIKE hrai_file.hrai02,   
        hrai03       LIKE hrai_file.hrai03,  
        hrai04       LIKE hrai_file.hrai04, 
        hrai05       LIKE hrai_file.hrai05,  
        hraiacti     LIKE hrai_file.hraiacti   
                    END RECORD,
    g_hrai_t         RECORD                 
        hrai01       LIKE hrai_file.hrai01,     
        hrai02       LIKE hrai_file.hrai02,   
        hrai03       LIKE hrai_file.hrai03,  
        hrai04       LIKE hrai_file.hrai04, 
        hrai05       LIKE hrai_file.hrai05,  
        hraiacti     LIKE hrai_file.hraiacti 
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
    OPEN WINDOW i106_w AT p_row,p_col WITH FORM "ghr/42f/ghri106"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i106_b_fill(g_wc2)
    CALL i106_menu()
    CLOSE WINDOW i106_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i106_menu()
 
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
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrai[l_ac].hrai01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrai01"
                  LET g_doc.value1 = g_hrai[l_ac].hrai01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrai),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i106_q()
   CALL i106_b_askkey()
END FUNCTION
	
FUNCTION i106_b()
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
 
    LET g_forupd_sql = "SELECT hrai01,hrai02,hrai03,hrai04,hrai05,hraiacti",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hrai_file WHERE hrai03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i106_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrai WITHOUT DEFAULTS FROM s_hrai.*
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
           LET g_hrai_t.* = g_hrai[l_ac].*  #BACKUP
           OPEN i106_bcl USING g_hrai_t.hrai03
           IF STATUS THEN
              CALL cl_err("OPEN i106_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i106_bcl INTO g_hrai[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrai_t.hrai01,SQLCA.sqlcode,1)
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
         INITIALIZE g_hrai[l_ac].* TO NULL      #900423  
         LET g_hrai[l_ac].hraiacti = 'Y'       #Body default
         LET g_hrai_t.* = g_hrai[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrai01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i106_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hrai_file(hrai01,hrai02,hrai03,hrai04,hrai05,                          #FUN-A30097
                              hraiacti,hraiuser,hraidate,hraigrup,hraioriu,hraiorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrai[l_ac].hrai01,g_hrai[l_ac].hrai02,
               g_hrai[l_ac].hrai03,g_hrai[l_ac].hrai04,                      #FUN-A30097                                        #FUN-A80148--mark--
               g_hrai[l_ac].hrai05,                      #FUN-A80148--mod-- 
               g_hrai[l_ac].hraiacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrai_file",g_hrai[l_ac].hrai01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hrai01                        
       IF NOT cl_null(g_hrai[l_ac].hrai01) THEN       	 	  	                                            
          LET l_n=0 
          SELECT COUNT(*) INTO l_n FROM hral_file WHERE hral01=g_hrai[l_ac].hrai01
                                                    AND hralacti='Y'
          IF l_n=0 THEN
          	 CALL cl_err('无此营运中心','!',0)
          	 NEXT FIELD hrai01
          END IF
          	
          SELECT hral02 INTO g_hrai[l_ac].hrai02 FROM hral_file WHERE hral01=g_hrai[l_ac].hrai01
                                                                  AND hralacti='Y'
          DISPLAY BY NAME g_hrai[l_ac].hrai02                                                         		                                                                        	
       END IF
       	
    AFTER FIELD hrai03
       IF NOT cl_null(g_hrai[l_ac].hrai03) THEN
          IF g_hrai[l_ac].hrai03 != g_hrai_t.hrai03 OR
             g_hrai_t.hrai03 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrai_file
              WHERE hrai03 = g_hrai[l_ac].hrai03
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrai[l_ac].hrai03 = g_hrai_t.hrai03
                NEXT FIELD hrai03
             END IF
          END IF     
       END IF
       	
#    AFTER FIELD hrai04
#       IF NOT cl_null(g_hrai[l_ac].hrai04) THEN
#          IF g_hrai[l_ac].hrai04 != g_hrai_t.hrai04 OR
#             g_hrai_t.hrai04 IS NULL THEN
#             LET l_n=0
#             SELECT COUNT(*) INTO l_n FROM hrai_file
#              WHERE hrai04 = g_hrai[l_ac].hrai04
#             IF l_n > 0 THEN
#                CALL cl_err('',-239,0)
#                LET g_hrai[l_ac].hrai04 = g_hrai_t.hrai04
#                NEXT FIELD hrai04
#             END IF
#          END IF     
#       END IF  	
       	
   
    AFTER FIELD hraiacti
       IF NOT cl_null(g_hrai[l_ac].hraiacti) THEN
          IF g_hrai[l_ac].hraiacti NOT MATCHES '[YN]' THEN 
             LET g_hrai[l_ac].hraiacti = g_hrai_t.hraiacti
             NEXT FIELD hraiacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hrai_t.hrai03 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrai03"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrai[l_ac].hrai03      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrai_file WHERE hrai03 = g_hrai_t.hrai03
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrai_file",g_hrai_t.hrai03,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrai[l_ac].* = g_hrai_t.*
         CLOSE i106_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrai[l_ac].hrai01,-263,0)
          LET g_hrai[l_ac].* = g_hrai_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrai_file SET hrai01=g_hrai[l_ac].hrai01,
                               hrai02=g_hrai[l_ac].hrai02,
                               hrai03=g_hrai[l_ac].hrai03,
                               hrai04=g_hrai[l_ac].hrai04,
                               hrai05=g_hrai[l_ac].hrai05,    
                               hraiacti=g_hrai[l_ac].hraiacti,
                               hraimodu=g_user,
                               hraidate=g_today
          WHERE hrai03 = g_hrai_t.hrai03
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrai_file",g_hrai_t.hrai03,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrai[l_ac].* = g_hrai_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrai[l_ac].* = g_hrai_t.*
          END IF
          CLOSE i106_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i106_bcl                
        COMMIT WORK  
        
     ON ACTION controlp
        CASE 
        	 WHEN INFIELD(hrai01)
        	    CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hral01"
               LET g_qryparam.default1 = g_hrai[l_ac].hrai01
               CALL cl_create_qry() RETURNING g_hrai[l_ac].hrai01
               DISPLAY BY NAME g_hrai[l_ac].hrai01
               NEXT FIELD hrai01
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
 
    CLOSE i106_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i106_b_askkey()
    CLEAR FORM
    CALL g_hrai.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrai01,hrai02,hrai03,hrai04,hrai05,hraiacti                       
         FROM s_hrai[1].hrai01,s_hrai[1].hrai02,s_hrai[1].hrai03,                                  
              s_hrai[1].hrai04,s_hrai[1].hrai05,s_hrai[1].hraiacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrai01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hral01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrai[1].hrai01
               NEXT FIELD hrai01
            
            WHEN INFIELD(hrai03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrai03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrai[1].hrai03
               NEXT FIELD hrai03   
             
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraiuser', 'hraigrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i106_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i106_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrai01,hrai02,hrai03,hrai04,hrai05,hraiacti",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hrai_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i106_pb FROM g_sql
    DECLARE hrai_curs CURSOR FOR i106_pb
 
    CALL g_hrai.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrai_curs INTO g_hrai[g_cnt].*  
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
    CALL g_hrai.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i106_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrai TO s_hrai.* ATTRIBUTE(COUNT=g_rec_b)
 
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
