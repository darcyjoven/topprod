# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almt2902.4gl
# Descriptions...: 經營信息維護作業
# Date & Author..: NO.FUN-870010 08/07/25 By lilingyu 
# Modify.........: No.FUN-960134 09/07/09 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lnd           DYNAMIC ARRAY OF RECORD    
         lnd02       LIKE lnd_file.lnd02,
         lnd03       LIKE lnd_file.lnd03,
         lnd04       LIKE lnd_file.lnd04,
         lnd05       LIKE lnd_file.lnd05,
         lnd06       LIKE lnd_file.lnd06
                    END RECORD,
     g_lnd_t        RECORD    
         lnd02       LIKE lnd_file.lnd02,
         lnd03       LIKE lnd_file.lnd03,
         lnd04       LIKE lnd_file.lnd04,
         lnd05       LIKE lnd_file.lnd05,
         lnd06       LIKE lnd_file.lnd06
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE g_cnt               LIKE type_file.num10           
DEFINE g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lnd_file.lnd00
DEFINE g_argv2               LIKE lnb_file.lnb01
DEFINE g_lnd01               LIKE lnd_file.lnd01
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
     
    OPEN WINDOW t2902_w WITH FORM "alm/42f/almt2902" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()    
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_lnd01   = NULL
    LET g_lnd01   = g_argv2
     
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       LET g_wc2 = " lnd01 = '",g_argv2,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t2902_b_fill(g_wc2)
    
    CALL t2902_menu()
    CLOSE WINDOW t2902_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t2902_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t2902_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t2902_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t2902_b()
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
               IF g_lnd[l_ac].lnd03 IS NOT NULL THEN
                  LET g_doc.column1 = "lnd03"
                  LET g_doc.value1 = g_lnd[l_ac].lnd03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnd),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t2902_q()
   CALL t2902_b_askkey()
END FUNCTION
 
FUNCTION t2902_b()
DEFINE   l_ac_t          LIKE type_file.num5,           
         l_n             LIKE type_file.num5,    
         l_lock_sw       LIKE type_file.chr1,          
         p_cmd           LIKE type_file.chr1,         
         l_allow_insert  LIKE type_file.chr1,         
         l_allow_delete  LIKE type_file.chr1        
DEFINE   l_lnb33         LIKE lnb_file.lnb33
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT lnb33 INTO l_lnb33 FROM lnb_file
    WHERE lnb01 = g_argv2
   IF (l_lnb33 = 'Y' OR l_lnb33 = 'X') THEN 
       CALL cl_err('','alm-148',0)
       LET g_action_choice = NULL 
       RETURN 
   END IF     
       
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lnd02,lnd03,lnd04,lnd05,lnd06", 
                      "  FROM lnd_file WHERE  ",
                      "  lnd01= '",g_argv2,"' and lnd02 = ? and lnd03 = ? ",
                      "  FOR UPDATE "
                
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t2902_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lnd WITHOUT DEFAULTS FROM s_lnd.*
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
             CALL t2902_set_entry(p_cmd)                                         
             CALL t2902_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lnd_t.* = g_lnd[l_ac].*  
              OPEN t2902_bcl USING g_lnd_t.lnd02,g_lnd_t.lnd03
             IF STATUS THEN
                CALL cl_err("OPEN t2902_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t2902_bcl INTO g_lnd[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lnd_t.lnd03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t2902_set_entry(p_cmd)                                            
          CALL t2902_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lnd[l_ac].* TO NULL    
          LET g_lnd_t.* = g_lnd[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lnd02
 
       AFTER INSERT     
         
          
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t2902_bcl
             CANCEL INSERT
          END IF
         INSERT INTO lnd_file(lnd00,lnd01,lnd02,lnd03,lnd04,lnd05,lnd06)
              VALUES(g_argv1,g_argv2,g_lnd[l_ac].lnd02,g_lnd[l_ac].lnd03,
                     g_lnd[l_ac].lnd04,g_lnd[l_ac].lnd05,g_lnd[l_ac].lnd06)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lnd_file",g_lnd[l_ac].lnd02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       AFTER FIELD lnd02                        
        IF NOT cl_null(g_lnd[l_ac].lnd02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lnd[l_ac].lnd02 != g_lnd_t.lnd02) THEN 
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lnd_file
              WHERE lnd01 = g_argv2
                AND lnd02 = g_lnd[l_ac].lnd02
                AND lnd03 = g_lnd[l_ac].lnd03
                
              IF l_n > 0 THEN 
                 CALL cl_err('','alm-151',0)
                 NEXT FIELD lnd02
              END IF   
            END IF   
          END IF  	    
    
       AFTER FIELD lnd03
          IF NOT cl_null(g_lnd[l_ac].lnd03) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lnd[l_ac].lnd03 != g_lnd_t.lnd03) THEN 
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lnd_file
              WHERE lnd01 = g_argv2
                AND lnd02 = g_lnd[l_ac].lnd02
                AND lnd03 = g_lnd[l_ac].lnd03
                
              IF l_n > 0 THEN 
                 CALL cl_err('','alm-151',0)
                 NEXT FIELD lnd03
              END IF   
            END IF    
          END IF  	    
         
       AFTER FIELD lnd05 
          IF NOT cl_null(g_lnd[l_ac].lnd05) THEN 
             IF cl_null(g_lnd[l_ac].lnd06) THEN 
                CALL cl_err('','alm-153',0)
                NEXT FIELD lnd06
             ELSE
             	  IF g_lnd[l_ac].lnd05 > g_lnd[l_ac].lnd06 THEN 
             	     CALL cl_err('','alm-152',0)
             	     NEXT FIELD lnd05
             	  END IF    
             END IF   
          ELSE
          	 IF NOT cl_null(g_lnd[l_ac].lnd06) THEN 
          	    CALL cl_err('','alm-154',0)
          	    NEXT FIELD lnd05
          	 END IF                  
          END IF    
         
       AFTER FIELD lnd06
           IF NOT cl_null(g_lnd[l_ac].lnd06) THEN 
              IF cl_null(g_lnd[l_ac].lnd05) THEN 
                 CALL cl_err('','alm-154',0)        
                 NEXT FIELD lnd05
              ELSE
            	   IF g_lnd[l_ac].lnd06 < g_lnd[l_ac].lnd05 THEN 
            	      CALL cl_err('','alm-155',0)
            	      NEXT FIELD lnd06
            	   END IF 
              END IF
           ELSE
           	  IF NOT cl_null(g_lnd[l_ac].lnd05) THEN 
           	     CALL cl_err('','alm-153',0)
           	     NEXT FIELD lnd06
           	  END IF        
           END IF  
                     		
       BEFORE DELETE                            #是否取消單身
          IF (g_lnd_t.lnd02 IS NOT NULL) AND (g_lnd_t.lnd03 IS NOT NULL) THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lnd03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lnd[l_ac].lnd03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lnd_file WHERE lnd02 = g_lnd_t.lnd02
                                    AND lnd03 = g_lnd_t.lnd03
                                    AND lnd01 = g_argv2
                                    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lnd_file",g_lnd_t.lnd02,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lnd[l_ac].* = g_lnd_t.*
             CLOSE t2902_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lnd[l_ac].lnd02,-263,0)
             LET g_lnd[l_ac].* = g_lnd_t.*
          ELSE
             UPDATE lnd_file SET lnd00=g_argv1,
                                 lnd02=g_lnd[l_ac].lnd02,
                                 lnd03=g_lnd[l_ac].lnd03,
                                 lnd04=g_lnd[l_ac].lnd04,
                                 lnd05=g_lnd[l_ac].lnd05,
                                 lnd06=g_lnd[l_ac].lnd06
              WHERE lnd02 = g_lnd_t.lnd02
                AND lnd03 = g_lnd_t.lnd03
                AND lnd01 = g_argv2
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lnd_file",g_lnd_t.lnd02,"",SQLCA.sqlcode,"","",1)  
                LET g_lnd[l_ac].* = g_lnd_t.*
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
                LET g_lnd[l_ac].* = g_lnd_t.*
             END IF
             CLOSE t2902_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE t2902_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lnd02) AND l_ac > 1 THEN
             LET g_lnd[l_ac].* = g_lnd[l_ac-1].*
             NEXT FIELD lnd02
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
 
   CLOSE t2902_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t2902_b_askkey()
 
   CLEAR FORM
   CALL g_lnd.clear()
      CONSTRUCT g_wc2 ON lnd02,lnd03,lnd04,lnd05,lnd06   
                 FROM s_lnd[1].lnd02,s_lnd[1].lnd03,s_lnd[1].lnd04,s_lnd[1].lnd05,
                      s_lnd[1].lnd06
 
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
 
   CALL t2902_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t2902_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
    LET g_sql ="SELECT lnd02,lnd03,lnd04,lnd05,lnd06",   
               " FROM lnd_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " and lnd01 = '",g_argv2,"'" ,
               " ORDER BY lnd03"
    PREPARE t2902_pb FROM g_sql
    DECLARE lnd_curs CURSOR FOR t2902_pb
 
    CALL g_lnd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnd_curs INTO g_lnd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_lnd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t2902_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnd TO s_lnd.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t2902_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lnd02,lnd03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t2902_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lnd02,lnd03",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
      
#No.FUN-960134 
