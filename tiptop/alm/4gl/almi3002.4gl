# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almi3002.4gl
# Descriptions...: 正式商戶經營信息維護作業
# Date & Author..: NO.FUN-870010 08/07/31 By lilingyu 
# Modify.........: No.FUN-960134 09/07/10 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lng           DYNAMIC ARRAY OF RECORD    
         lng03       LIKE lng_file.lng03,
         lng04       LIKE lng_file.lng04,
         lng05       LIKE lng_file.lng05,
         lng06       LIKE lng_file.lng06,
         lng07       LIKE lng_file.lng07
                    END RECORD,
     g_lng_t        RECORD    
         lng03       LIKE lng_file.lng03,
         lng04       LIKE lng_file.lng04,
         lng05       LIKE lng_file.lng05,
         lng06       LIKE lng_file.lng06,
         lng07       LIKE lng_file.lng07
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lne_file.lne04
DEFINE g_argv2               LIKE lne_file.lne01
 
MAIN
    OPTIONS                              
        INPUT NO WRAP     #No.FUN-9B0136
    #   FIELD ORDER FORM  #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
          
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
     
    OPEN WINDOW i3002_w WITH FORM "alm/42f/almi3002" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()    
 
    IF NOT cl_null(g_argv2) THEN
       LET g_wc2 = " lng01 = '",g_argv2,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL i3002_b_fill(g_wc2)
    
    CALL i3002_menu()
    CLOSE WINDOW i3002_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i3002_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL i3002_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i3002_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i3002_b()
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
               IF g_lng[l_ac].lng03 IS NOT NULL THEN
                  LET g_doc.column1 = "lng03"
                  LET g_doc.value1 = g_lng[l_ac].lng03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lng),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i3002_q()
   CALL i3002_b_askkey()
END FUNCTION
 
FUNCTION i3002_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5,    
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1        
DEFINE l_lne36         LIKE lne_file.lne36
#DEFINE l_lneacti       LIKE lne_file.lneacti
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT lne36 INTO l_lne36 FROM lne_file
     WHERE lne01      = g_argv2
   IF (l_lne36 = 'Y' OR l_lne36 = 'X') THEN 
       CALL cl_err('','alm-148',0)
       LET g_action_choice = NULL 
       RETURN 
   END IF     
       
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lng03,lng04,lng05,lng06,lng07", 
                      "  FROM lng_file WHERE  ",
                      "  lng01= '",g_argv2,"' and lng03 = ? and lng04 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i3002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lng WITHOUT DEFAULTS FROM s_lng.*
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
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL i3002_set_entry(p_cmd)                                         
             CALL i3002_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lng_t.* = g_lng[l_ac].*  
             OPEN i3002_bcl USING g_lng_t.lng03,g_lng_t.lng04
             IF STATUS THEN
                CALL cl_err("OPEN i3002_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i3002_bcl INTO g_lng[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lng_t.lng03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL i3002_set_entry(p_cmd)                                            
          CALL i3002_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lng[l_ac].* TO NULL    
          LET g_lng_t.* = g_lng[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lng03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i3002_bcl
             CANCEL INSERT
          END IF
         INSERT INTO lng_file(lng00,lng01,lng02,lng03,lng04,lng05,lng06,lng07)
              VALUES(g_argv1,g_argv2,'0',g_lng[l_ac].lng03,g_lng[l_ac].lng04,
                     g_lng[l_ac].lng05,g_lng[l_ac].lng06,g_lng[l_ac].lng07)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lng_file",g_lng[l_ac].lng03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       AFTER FIELD lng03                        
          IF cl_null(g_lng[l_ac].lng03) THEN
             CALL cl_err('','alm-062',0)
             NEXT FIELD lng03     
          END IF   
     
       AFTER FIELD lng04
          IF cl_null(g_lng[l_ac].lng04) THEN 
             CALL cl_err('','alm-062',0)
             NEXT FIELD lng04
          ELSE
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lng_file
              WHERE lng01      = g_argv2
                AND lng03      = g_lng[l_ac].lng03
                AND lng04      = g_lng[l_ac].lng04
                
              IF l_n > 0 THEN 
                 CALL cl_err('','alm-151',0)
                 DISPLAY g_lng_t.lng03 TO lng03
                 NEXT FIELD lng03
              END IF   
          END IF  	    
          
       AFTER FIELD lng06
          IF NOT cl_null(g_lng[l_ac].lng06) THEN 
             IF cl_null(g_lng[l_ac].lng07) THEN 
                CALL cl_err('','alm-153',0)
                NEXT FIELD lng07
             ELSE
             	  IF g_lng[l_ac].lng06 > g_lng[l_ac].lng07 THEN 
             	     CALL cl_err('','alm-152',0)
             	     NEXT FIELD lng06
             	  END IF    
             END IF   
          ELSE
          	 IF NOT cl_null(g_lng[l_ac].lng07) THEN  
          	    CALL cl_err('','alm-154',0)
          	    NEXT FIELD lng06
          	 END IF               
          END IF    
         
       AFTER FIELD lng07
           IF NOT cl_null(g_lng[l_ac].lng07) THEN 
              IF cl_null(g_lng[l_ac].lng06) THEN 
                 CALL cl_err('','alm-154',0)        
                 NEXT FIELD lng06
              ELSE
            	   IF g_lng[l_ac].lng07 < g_lng[l_ac].lng06 THEN 
            	      CALL cl_err('','alm-155',0)
            	      NEXT FIELD lng07
            	   END IF 
              END IF 
           ELSE
           	IF NOT cl_null(g_lng[l_ac].lng06) THEN 
           	   CALL cl_err('','alm-153',0)
           	   NEXT FIELD lng07   
           	END IF   
           END IF 
       
            		
       BEFORE DELETE                      
          IF (g_lng_t.lng03 IS NOT NULL) AND (g_lng_t.lng04 IS NOT NULL) THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lng03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lng[l_ac].lng03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lng_file WHERE lng03 = g_lng_t.lng03
                                    AND lng04 = g_lng_t.lng04
                                    AND lng01 = g_argv2
                                    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lng_file",g_lng_t.lng03,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lng[l_ac].* = g_lng_t.*
             CLOSE i3002_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lng[l_ac].lng03,-263,0)
             LET g_lng[l_ac].* = g_lng_t.*
          ELSE
             UPDATE lng_file SET lng00 = g_argv1,
                                 lng03=g_lng[l_ac].lng03,
                                 lng04=g_lng[l_ac].lng04,
                                 lng05=g_lng[l_ac].lng05,
                                 lng06=g_lng[l_ac].lng06,
                                 lng07=g_lng[l_ac].lng07
              WHERE lng03 = g_lng_t.lng03
                AND lng04 = g_lng_t.lng04
                AND lng01 = g_argv2
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lng_file",g_lng_t.lng03,"",SQLCA.sqlcode,"","",1)  
                LET g_lng[l_ac].* = g_lng_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lng[l_ac].* = g_lng_t.*
             END IF
             CLOSE i3002_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE i3002_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lng03) AND l_ac > 1 THEN
             LET g_lng[l_ac].* = g_lng[l_ac-1].*
             NEXT FIELD lng03
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
 
   CLOSE i3002_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i3002_b_askkey()
 
   CLEAR FORM
   CALL g_lng.clear()
      CONSTRUCT g_wc2 ON lng03,lng04,lng05,lng06,lng07   
                 FROM s_lng[1].lng03,s_lng[1].lng04,s_lng[1].lng05,s_lng[1].lng06,
                      s_lng[1].lng07
 
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
               
	    ON ACTION qbe_select
    	   CALL cl_qbe_select() 
  
      ON ACTION qbe_save
	  	   CALL cl_qbe_save()
		
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0
      LET g_wc2 = NULL
      RETURN 
   END IF
 
   CALL i3002_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i3002_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
    LET g_sql ="SELECT lng03,lng04,lng05,lng06,lng07",   
               " FROM lng_file ",
               " WHERE ", p_wc2 CLIPPED, 
               " and lng01 = '",g_argv2,"'",       
               " ORDER BY lng03"
    PREPARE i3002_pb FROM g_sql
    DECLARE lng_curs CURSOR FOR i3002_pb
 
    CALL g_lng.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lng_curs INTO g_lng[g_cnt].*   
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
    CALL g_lng.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i3002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lng TO s_lng.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION i3002_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lng03,lng04",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i3002_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lng03,lng04",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134      
