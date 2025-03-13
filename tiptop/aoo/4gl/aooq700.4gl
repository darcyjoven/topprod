# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axcq700.4gl
# Descriptions...: 
# Date & Author..: 12/09/03 By xujing NO.FUN-C80092

 
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE 
   g_cka DYNAMIC ARRAY OF RECORD LIKE cka_file.*,

   g_cka_t       RECORD  LIKE cka_file.*,     

   g_argv1       LIKE pia_file.pia02,
   g_argv2       LIKE cdj_file.cdj02,
   g_argv3       LIKE cdj_file.cdj03,   
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
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time     
   LET g_argv1   = ARG_VAL(1)
   LET g_argv2   = ARG_VAL(2)
   LET g_argv3   = ARG_VAL(3)            
   
   OPEN WINDOW q700_w WITH FORM "aoo/42f/aooq700"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_visible("ckaud01,ckaud02,ckaud03,ckaud04,ckaud05,ckaud06,ckaud07,
            ckaud08,ckaud09,ckaud10,ckaud11,ckaud12,ckaud13,ckaud14,ckaud15",FALSE)
   IF NOT cl_null(g_argv1) THEN
      CALL q700_q()
   END IF
   CALL q700_menu()
   CLOSE WINDOW q700_w                

   CALL cl_used(g_prog,g_time,2) RETURNING g_time      
END MAIN
 
FUNCTION q700_curs()
   CLEAR FORM                            
   CALL g_cka.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           
           
     CONSTRUCT BY NAME g_wc ON cka11,cka00,cka01,cka02,cka03,cka04,cka05,cka06,cka07,
                               cka08,cka09,cka10,ckauser
                               
     BEFORE CONSTRUCT
       CALL cl_qbe_init()

     ON ACTION controlp                                                      
        IF INFIELD(ckauser) THEN
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_gen"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ckauser                             
           NEXT FIELD ckauser
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
#   ELSE
#      LET g_wc = " pia02 = '",g_argv1,"' AND ccc02= '",g_argv2,"' AND ccc03= '",g_argv3,"' "
   END IF

END FUNCTION
 
FUNCTION q700_menu()
   WHILE TRUE
      CALL q700_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q700_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cka),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q700_q()

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q700_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
#      INITIALIZE g_pia02 TO NULL
      RETURN
   END IF
 
   CALL q700_show()               

END FUNCTION
 
FUNCTION q700_show()          
   CALL q700_b_fill(g_wc)                
 
END FUNCTION
 
FUNCTION q700_b_fill(p_wc)               
DEFINE   p_wc        STRING,
         l_sql       STRING      

     IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF  
     LET l_sql = "SELECT * FROM cka_file WHERE ",p_wc CLIPPED,
                 " AND cka10<>'Z' ORDER BY cka00"

     PREPARE q700_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE q700_curs1 CURSOR FOR q700_prepare1

     CALL g_cka.clear()
     LET g_cnt = 1

     FOREACH q700_curs1 INTO g_cka[g_cnt].*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF     

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	        EXIT FOREACH
       END IF       
     END FOREACH
     
   CALL g_cka.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q700_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cka TO s_cka.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
