# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axcq329.4gl
# Descriptions...: 结存调整查询
# Date & Author..: 12/09/02 By minpp #No.FUN-C90002

 
DATABASE ds

#No.FUN-C90002
GLOBALS "../../config/top.global"
 
DEFINE
   g_ccc DYNAMIC ARRAY OF RECORD          
         ccc01     LIKE ccc_file.ccc01,
         ccc02     LIKE ccc_file.ccc02,
         ccc03     LIKE ccc_file.ccc03,    
         ccc93a    LIKE ccc_file.ccc93a,
         ccc93b    LIKE ccc_file.ccc93b,
         ccc93d    LIKE ccc_file.ccc93d,
         ccc93c    LIKE ccc_file.ccc93c,
         ccc93e    LIKE ccc_file.ccc93e,
         ccc93f    LIKE ccc_file.ccc93f,
         ccc93g    LIKE ccc_file.ccc93g,
         ccc93h    LIKE ccc_file.ccc93h,
         ccc93     LIKE ccc_file.ccc93,
         ccc07     LIKE ccc_file.ccc07,
         ccc08     LIKE ccc_file.ccc08
             END RECORD,
   g_ccc_t       RECORD                  
         ccc01     LIKE ccc_file.ccc01,
         ccc02     LIKE ccc_file.ccc02,
         ccc03     LIKE ccc_file.ccc03,    
         ccc93a    LIKE ccc_file.ccc93a,
         ccc93b    LIKE ccc_file.ccc93b,
         ccc93d    LIKE ccc_file.ccc93d,
         ccc93c    LIKE ccc_file.ccc93c,
         ccc93e    LIKE ccc_file.ccc93e,
         ccc93f    LIKE ccc_file.ccc93f,
         ccc93g    LIKE ccc_file.ccc93g,
         ccc93h    LIKE ccc_file.ccc93h,
         ccc93     LIKE ccc_file.ccc93,
         ccc07     LIKE ccc_file.ccc07,
         ccc08     LIKE ccc_file.ccc08
             END RECORD,
   g_argv1       LIKE ccc_file.ccc01,
   g_argv2       LIKE ccc_file.ccc02,
   g_argv3       LIKE ccc_file.ccc03,
   g_argv4       LIKE ccc_file.ccc07,
   g_argv5       LIKE ccc_file.ccc08,
   g_wc,g_sql,g_wc1    STRING,     
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
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_argv1   = ARG_VAL(1)
   LET g_argv2   = ARG_VAL(2)
   LET g_argv3   = ARG_VAL(3)
   LET g_argv4   = ARG_VAL(4)
   LET g_argv5   = ARG_VAL(5)
   
   OPEN WINDOW q329_w WITH FORM "axc/42f/axcq329"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

  
   IF NOT cl_null(g_argv1) THEN
      CALL q329_q()
   END IF
   CALL q329_menu()
   CLOSE WINDOW q329_w                

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q329_b_askkey()
   CLEAR FORM                            
   CALL g_ccc.clear()
   
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")         
      CONSTRUCT BY NAME g_wc ON ccc01,ccc02,ccc03,ccc93a,ccc93b,ccc93d,ccc93c,
                                ccc93e,ccc93f,ccc93g,ccc93h,ccc93,ccc07,ccc08

      BEFORE CONSTRUCT
       CALL cl_qbe_init()

      ON ACTION controlp              
         CASE                                        
          WHEN INFIELD(ccc01)                                               
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima01"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ccc01                             
           NEXT FIELD ccc01 

           OTHERWISE EXIT CASE
       END CASE 
 
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
    ELSE   
      LET g_wc = " ccc01= '",g_argv1,"' AND ccc02='",g_argv2,"' AND ccc03='",g_argv3,"'
                   AND ccc07= '",g_argv4,"' AND ccc08='",g_argv5,"' "
    END IF
END FUNCTION

 
FUNCTION q329_menu()
   WHILE TRUE
      CALL q329_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q329_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlf),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q329_q()
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q329_b_askkey()                          
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ccc[l_ac].*  TO NULL
      RETURN
   END IF

   CALL q329_show()
  
END FUNCTION

FUNCTION q329_show()
   CALL q329_b_fill(g_wc)

END FUNCTION
 
FUNCTION q329_b_fill(p_wc2)                             
   DEFINE p_wc2   LIKE type_file.chr1000       
 
   LET g_sql = "SELECT ccc01,ccc02,ccc03,ccc93a,ccc93b,ccc93d,ccc93c,", 
               "       ccc93e,ccc93f,ccc93g,ccc93h,ccc93,ccc07,ccc08",    
               "  FROM ccc_file",
               " WHERE ", p_wc2 CLIPPED                     #单身
    
   LET g_sql = g_sql," ORDER BY ccc01,ccc02,ccc03,ccc07,ccc08"


   PREPARE q329_pb FROM g_sql
   DECLARE ccc_curs CURSOR FOR q329_pb
 
   CALL g_ccc.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH ccc_curs INTO g_ccc[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_ccc.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
   
END FUNCTION
 
FUNCTION q329_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ccc TO s_ccc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
