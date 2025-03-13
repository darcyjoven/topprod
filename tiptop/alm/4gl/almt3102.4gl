# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almt3102.4gl
# Descriptions...: 正式商戶經營信息維護作業
# Date & Author..: NO.FUN-870010 08/07/31 By lilingyu 
# Modify.........: No.FUN-960134 09/07/15 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lug           DYNAMIC ARRAY OF RECORD    
         lug03       LIKE lug_file.lug03,
         lug04       LIKE lug_file.lug04,
         lug05       LIKE lug_file.lug05,
         lug06       LIKE lug_file.lug06,
         lug07       LIKE lug_file.lug07
                    END RECORD,
     g_lug_t        RECORD    
         lug03       LIKE lug_file.lug03,
         lug04       LIKE lug_file.lug04,
         lug05       LIKE lug_file.lug05,
         lug06       LIKE lug_file.lug06,
         lug07       LIKE lug_file.lug07
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lug_file.lug00
DEFINE g_argv2               LIKE lue_file.lue01
DEFINE g_argv3               LIKE lue_file.lue02 
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW t3102_w WITH FORM "alm/42f/almt3102" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()    
          
     IF NOT cl_null(g_argv2) AND NOT cl_null(g_argv3)THEN
       LET g_wc2 = " lug01 = '",g_argv2,"' and lug02 = '",g_argv3,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t3102_b_fill(g_wc2)
    
    CALL t3102_menu()
    CLOSE WINDOW t3102_w 
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t3102_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t3102_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t3102_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t3102_b()
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
               IF g_lug[l_ac].lug03 IS NOT NULL THEN
                  LET g_doc.column1 = "lug03"
                  LET g_doc.value1 = g_lug[l_ac].lug03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lug),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t3102_q()
   CALL t3102_b_askkey()
END FUNCTION
 
FUNCTION t3102_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5,    
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1        
DEFINE l_lue36         LIKE lue_file.lue36
#DEFINE l_lueacti       LIKE lue_file.lueacti
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT lue36 INTO l_lue36 FROM lue_file
    WHERE lue01 = g_argv2
      AND lue02 = g_argv3
   IF (l_lue36 = 'Y' OR l_lue36 = 'X') THEN 
       CALL cl_err('','alm-148',0)
       LET g_action_choice = NULL 
       RETURN 
   END IF     
       
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lug03,lug04,lug05,lug06,lug07", 
                      "  FROM lug_file WHERE  ",
                      "  lug01= '",g_argv2,"' and lug02 = '",g_argv3,"' and lug03 = ? and lug04 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lug WITHOUT DEFAULTS FROM s_lug.*
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
             CALL t3102_set_entry(p_cmd)                                         
             CALL t3102_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lug_t.* = g_lug[l_ac].*  
             OPEN t3102_bcl USING g_lug_t.lug03,g_lug_t.lug04
             IF STATUS THEN
                CALL cl_err("OPEN t3102_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t3102_bcl INTO g_lug[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lug_t.lug03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t3102_set_entry(p_cmd)                                            
          CALL t3102_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lug[l_ac].* TO NULL    
          LET g_lug_t.* = g_lug[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lug03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t3102_bcl
             CANCEL INSERT
          END IF
         INSERT INTO lug_file(lug00,lug01,lug02,lug03,lug04,lug05,lug06,lug07)
              VALUES(g_argv1,g_argv2,g_argv3,g_lug[l_ac].lug03,g_lug[l_ac].lug04,
                     g_lug[l_ac].lug05,g_lug[l_ac].lug06,g_lug[l_ac].lug07)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lug_file",g_lug[l_ac].lug03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       AFTER FIELD lug03                        
          IF cl_null(g_lug[l_ac].lug03) THEN
             CALL cl_err('','alm-062',0)
             NEXT FIELD lug03     
          END IF   
     
       AFTER FIELD lug04
          IF cl_null(g_lug[l_ac].lug04) THEN 
             CALL cl_err('','alm-062',0)
             NEXT FIELD lug04
          ELSE
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lug_file
              WHERE lug01      = g_argv2
                AND lug02      = g_argv3
                AND lug03      = g_lug[l_ac].lug03
                AND lug04      = g_lug[l_ac].lug04
                
              IF l_n > 0 THEN 
                 CALL cl_err('','alm-151',0)
                 DISPLAY g_lug_t.lug03 TO lug03
                 NEXT FIELD lug03
              END IF   
          END IF  	    
          
       AFTER FIELD lug06
          IF NOT cl_null(g_lug[l_ac].lug06) THEN 
             IF cl_null(g_lug[l_ac].lug07) THEN 
                CALL cl_err('','alm-153',0)
                NEXT FIELD lug07
             ELSE
             	  IF g_lug[l_ac].lug06 > g_lug[l_ac].lug07 THEN 
             	     CALL cl_err('','alm-152',0)
             	     NEXT FIELD lug06
             	  END IF    
             END IF   
          ELSE
          	 IF NOT cl_null(g_lug[l_ac].lug07) THEN  
          	    CALL cl_err('','alm-154',0)
          	    NEXT FIELD lug06
          	 END IF               
          END IF    
         
       AFTER FIELD lug07
           IF NOT cl_null(g_lug[l_ac].lug07) THEN 
              IF cl_null(g_lug[l_ac].lug06) THEN 
                 CALL cl_err('','alm-154',0)        
                 NEXT FIELD lug06
              ELSE
            	   IF g_lug[l_ac].lug07 < g_lug[l_ac].lug06 THEN 
            	      CALL cl_err('','alm-155',0)
            	      NEXT FIELD lug07
            	   END IF 
              END IF 
           ELSE
           	IF NOT cl_null(g_lug[l_ac].lug06) THEN 
           	   CALL cl_err('','alm-153',0)
           	   NEXT FIELD lug07   
           	END IF   
           END IF 
       
            		
       BEFORE DELETE                      
          IF (g_lug_t.lug03 IS NOT NULL) AND (g_lug_t.lug04 IS NOT NULL) THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lug03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lug[l_ac].lug03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lug_file WHERE lug03 = g_lug_t.lug03
                                    AND lug04 = g_lug_t.lug04
                                    AND lug01 = g_argv2
                                    AND lug02 = g_argv3
                                    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lug_file",g_lug_t.lug03,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lug[l_ac].* = g_lug_t.*
             CLOSE t3102_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lug[l_ac].lug03,-263,0)
             LET g_lug[l_ac].* = g_lug_t.*
          ELSE
             UPDATE lug_file SET lug00=g_argv1,
                                 lug03=g_lug[l_ac].lug03,
                                 lug04=g_lug[l_ac].lug04,
                                 lug05=g_lug[l_ac].lug05,
                                 lug06=g_lug[l_ac].lug06,
                                 lug07=g_lug[l_ac].lug07
              WHERE lug03 = g_lug_t.lug03
                AND lug04 = g_lug_t.lug04
                AND lug01 = g_argv2
                AND lug02 = g_argv3
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lug_file",g_lug_t.lug03,"",SQLCA.sqlcode,"","",1)  
                LET g_lug[l_ac].* = g_lug_t.*
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
                LET g_lug[l_ac].* = g_lug_t.*
             END IF
             CLOSE t3102_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE t3102_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lug03) AND l_ac > 1 THEN
             LET g_lug[l_ac].* = g_lug[l_ac-1].*
             NEXT FIELD lug03
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
 
   CLOSE t3102_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t3102_b_askkey()
 
   CLEAR FORM
   CALL g_lug.clear()
      CONSTRUCT g_wc2 ON lug03,lug04,lug05,lug06,lug07   
                 FROM s_lug[1].lug03,s_lug[1].lug04,s_lug[1].lug05,s_lug[1].lug06,
                      s_lug[1].lug07
 
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
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN 
   END IF
 
   CALL t3102_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t3102_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 DEFINE   l_n             LIKE type_file.num5 
 
 SELECT COUNT(*) INTO l_n FROM lug_file 
  WHERE lug01 = g_argv2
    AND lug02 = g_argv3
    AND lug03 IS NOT NULL
    AND lug04 IS NOT NULL 
 IF l_n > 0 THEN 
    LET g_sql ="SELECT lug03,lug04,lug05,lug06,lug07",   
               " FROM lug_file ",
               " WHERE ", p_wc2 CLIPPED,        
               " and lug01 = '",g_argv2,"'",
               " and lug02 = '",g_argv3,"'",
               " ORDER BY lug03"
    PREPARE t3102_pb FROM g_sql
    DECLARE lug_curs CURSOR FOR t3102_pb
 
    CALL g_lug.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lug_curs INTO g_lug[g_cnt].*   
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
    CALL g_lug.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
ELSE 
	  LET g_sql ="SELECT lng03,lng04,lng05,lng06,lng07",   
               " FROM lng_file ",
               " WHERE lng01 = '",g_argv2,"'",
               " and lng03 is not null ",
               " and lng04 is not null ",
               " ORDER BY lng03"
    PREPARE t3102_pb_1 FROM g_sql
    DECLARE lug_curs_1 CURSOR FOR t3102_pb_1
 
    CALL g_lug.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lug_curs_1 INTO g_lug[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        ###############################
        INSERT INTO lug_file(lug00,lug01,lug02,lug03,lug04,lug05,lug06,lug07)
            VALUES(g_argv1,g_argv2,g_argv3,g_lug[g_cnt].lug03,g_lug[g_cnt].lug04,
                    g_lug[g_cnt].lug05,g_lug[g_cnt].lug06,g_lug[g_cnt].lug07)
        ##############################
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lug.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
END IF 	
END FUNCTION
 
FUNCTION t3102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lug TO s_lug.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t3102_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lug03,lug04",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t3102_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lug03,lug04",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134      
 
 
 
 
