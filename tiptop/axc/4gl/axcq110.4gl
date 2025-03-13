# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axcq110.4gl
# Descriptions...: 
# Date & Author..: 12/09/03 By xujing NO.FUN-C80092

 
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE 
   g_ckk DYNAMIC ARRAY OF RECORD LIKE ckk_file.*,

   g_ckk_t       RECORD  LIKE ckk_file.*,     

   g_argv1       STRING, 
   g_argv2       LIKE cdj_file.cdj02,
   g_argv3       LIKE cdj_file.cdj03,  
   g_argv4       LIKE tlfc_file.tlfctype, 
   g_wc,g_sql    STRING,     
   g_rec_b       LIKE type_file.num5,        
   l_ac          LIKE type_file.num5        
DEFINE   g_forupd_sql    STRING                       
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_msg           LIKE ze_file.ze03           
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10        
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("axc")) THEN
      EXIT PROGRAM
   END IF
 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time     
   LET g_argv1   = ARG_VAL(1)     #類型代碼
   LET g_argv2   = ARG_VAL(2)     #年度
   LET g_argv3   = ARG_VAL(3)     #期別       
   LET g_argv4   = ARG_VAL(4)     #成本計算類型
 
   OPEN WINDOW q110_w WITH FORM "axc/42f/axcq110"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL q110_q()
   END IF
   CALL q110_menu()
   CLOSE WINDOW q110_w                

   CALL cl_used(g_prog,g_time,2) RETURNING g_time      
END MAIN
 
FUNCTION q110_curs()
   CLEAR FORM                            
   CALL g_ckk.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")          
#   INITIALIZE g_pia02 TO NULL 
           
     CONSTRUCT BY NAME g_wc ON ckk00,ckk01,ckk02,ckk03,ckk04,ckk05,ckk06,ckk07,ckk08,ckk09,ckk10,
                               ckk11,ckk12,ckk13,ckk14,ckk15,ckk16,ckk17,ckkuser,ckkdate,ckktime,ckkacti

     BEFORE CONSTRUCT
       DISPLAY 'Y' TO ckkacti
       CALL cl_qbe_init()

     ON ACTION controlp                                                      
        IF INFIELD(ckk01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ckk01"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ckk01                             
           NEXT FIELD ckk01                                                 
        END IF 

        IF INFIELD(ckkuser) THEN
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_gen"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ckkuser                             
           NEXT FIELD ckkuser
        END IF
 
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
      IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_argv1 = cl_replace_str(g_argv1,"\,","\'\,\'")
       LET g_wc = " ckk01 IN ('",g_argv1,"') AND ckk03= '",g_argv2,"' AND ckk04= '",g_argv3,"' "," AND (ckk06 = '",g_argv4,"'",
                  " OR ckk06 = ' ') AND ckkacti='Y' "
   END IF

END FUNCTION
 
FUNCTION q110_menu()
   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q110_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ckk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q110_q()

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q110_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
#      INITIALIZE g_pia02 TO NULL
      RETURN
   END IF
 
   CALL q110_show()               

END FUNCTION
 
FUNCTION q110_show()          
   CALL q110_b_fill(g_wc)                
 
END FUNCTION
 
FUNCTION q110_b_fill(p_wc)               
DEFINE   p_wc        STRING,
         l_sql       STRING      
 
     IF cl_null(p_wc) THEN LET p_wc= ' 1=1' END IF      
     LET l_sql = "SELECT * FROM ckk_file WHERE ",p_wc CLIPPED," ORDER BY ckk00"


     PREPARE q110_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE q110_curs1 CURSOR FOR q110_prepare1

     CALL g_ckk.clear()
     LET g_cnt = 1

     FOREACH q110_curs1 INTO g_ckk[g_cnt].*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF     

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	        EXIT FOREACH
       END IF       
     END FOREACH
     
   CALL g_ckk.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q110_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ckk TO s_ckk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-C80092
