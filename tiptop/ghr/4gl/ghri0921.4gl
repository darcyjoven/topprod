# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri0921.4gl
# Descriptions...: 
# Date & Author..: 08/01/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrdxa  RECORD
         hrdxa02    LIKE   hrat_file.hrat02,
         hrdxa22    LIKE   hrdxa_file.hrdxa22,
         hrdxa08    LIKE   hrdxa_file.hrdxa08,
         hrdxa09    LIKE   hrdxa_file.hrdxa09,
         hrdxa13    LIKE   hrdxa_file.hrdxa13,
         hrdxa14    LIKE   hrdxa_file.hrdxa14,
         hrdxa19    LIKE   hrdxa_file.hrdxa19,
         hrdxa18    LIKE   hrdxa_file.hrdxa18,
         hrdxa12    LIKE   hrdxa_file.hrdxa12,
         hrdxa15    LIKE   hrdxa_file.hrdxa15
                END RECORD
DEFINE g_hrdxb  DYNAMIC ARRAY OF RECORD
         hrdxb03    LIKE   hrdxb_file.hrdxb03,
         hrdxb04    LIKE   hrdxb_file.hrdxb04,
         hrdxb05    LIKE   hrdxb_file.hrdxb05,
         hrdxb06    LIKE   hrdxb_file.hrdxb06,
         hrdxb07    LIKE   hrdxb_file.hrdxb07,
         hrdxb08    LIKE   hrdxb_file.hrdxb08,
         hrdxb09    LIKE   hrdxb_file.hrdxb09,
         hrdxb10    LIKE   hrdxb_file.hrdxb10
                END RECORD,
         g_rec_b    LIKE   type_file.num5,
         l_ac       LIKE   type_file.num5
DEFINE g_hrdxc  DYNAMIC ARRAY OF RECORD
         hrdxc03    LIKE   hrdxc_file.hrdxc03,
         hrdxc04    LIKE   hrdxc_file.hrdxc04,
         hrdxc05    LIKE   hrdxc_file.hrdxc05,
         hrdxc06    LIKE   hrdxc_file.hrdxc06,
         hrdxc07    LIKE   hrdxc_file.hrdxc07
                END RECORD,
         g_rec_b1   LIKE   type_file.num5,
         l_ac1      LIKE   type_file.num5 
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5  
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_argv1             LIKE hrdxa_file.hrdxa02
DEFINE g_argv2             LIKE hrdx_file.hrdx01
DEFINE g_argv3             LIKE hrdx_file.hrdx04

MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING
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
   	
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
   
   IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
   	  RETURN
   END IF
   		  
   CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time
         
   OPEN WINDOW i0921_w WITH FORM "ghr/42f/ghri0921"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_set_combo_items("hrdxb09",NULL,NULL)
   CALL i0921_get_items('604') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdxb09",l_name,l_items)
  
   CALL cl_ui_init()
   
   CALL i0921_q() 
   
   CALL i0921_menu()
   CLOSE WINDOW i0921_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i0921_get_items(p_hrag01)
DEFINE p_hrag01 LIKE  hrag_file.hrag01	
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"' ",
                 "  ORDER BY hrag06"
       PREPARE i0921_get_items_pre FROM l_sql
       DECLARE i0921_get_items CURSOR FOR i0921_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i0921_get_items INTO l_hrag06,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION
	
FUNCTION i0921_menu()
   WHILE TRUE
      CALL i0921_bp("G")
      
      CASE g_action_choice   

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i0921_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1    

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
   
   DISPLAY ARRAY g_hrdxb TO s_hrdxb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DIALOG
      #&include "qry_string.4gl" 
   END DISPLAY
   
   DISPLAY ARRAY g_hrdxc TO s_hrdxc.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DIALOG
      #&include "qry_string.4gl" 
   END DISPLAY
   
   END DIALOG
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i0921_q()
DEFINE l_hrat02     LIKE    hrat_file.hrat02     #add by zhangbo130910
	
	 INITIALIZE g_hrdxa.* TO NULL
	 
	 SELECT hrdxa02,hrdxa22,hrdxa08,hrdxa09,hrdxa13,
	        hrdxa14,hrdxa19,hrdxa18,hrdxa12,hrdxa15
	   INTO g_hrdxa.hrdxa02,g_hrdxa.hrdxa22,g_hrdxa.hrdxa08,
	        g_hrdxa.hrdxa09,g_hrdxa.hrdxa13,g_hrdxa.hrdxa14,
	        g_hrdxa.hrdxa19,g_hrdxa.hrdxa18,g_hrdxa.hrdxa12,g_hrdxa.hrdxa15
	   FROM hrdxa_file
	  WHERE hrdxa02=g_argv1
	    AND hrdxa01=g_argv2
	    AND hrdxa22=g_argv3
         
         #SELECT hrat02 INTO g_hrdxa.hrdxa02 FROM hrat_file WHERE hratid=g_hrdxa.hrdxa02   #mark by zhangbo130910
         SELECT hrat01,hrat02 INTO g_hrdxa.hrdxa02,l_hrat02 FROM hrat_file WHERE hratid=g_hrdxa.hrdxa02  #add by zhangbo130921
 
	 DISPLAY l_hrat02 TO hrat02     #add by zhangbo130910
	 DISPLAY g_hrdxa.hrdxa02 TO hrdxa02
	 DISPLAY g_hrdxa.hrdxa22 TO hrdxa22
	 DISPLAY g_hrdxa.hrdxa08 TO hrdxa08
	 DISPLAY g_hrdxa.hrdxa09 TO hrdxa09
	 DISPLAY g_hrdxa.hrdxa13 TO hrdxa13
	 DISPLAY g_hrdxa.hrdxa14 TO hrdxa14
	 DISPLAY g_hrdxa.hrdxa19 TO hrdxa19
	 DISPLAY g_hrdxa.hrdxa18 TO hrdxa18
	 DISPLAY g_hrdxa.hrdxa12 TO hrdxa12
	 DISPLAY g_hrdxa.hrdxa15 TO hrdxa15
	 
	 CALL i0921_b_fill()
	                   
END FUNCTION
	
FUNCTION i0921_b_fill()
DEFINE l_sql STRING
      
       CALL g_hrdxb.clear()
       
       LET g_rec_b=0
       
       
       LET l_sql=" SELECT hrdxb03,hrdxb04,hrdxb05,hrdxb06,hrdxb07,hrdxb08,hrdxb09,hrdxb10 ",
                 "   FROM hrdxb_file ",
                 "  WHERE hrdxb02='",g_argv1,"' ",
                 "    AND hrdxb01='",g_argv2,"' ",
                 "    AND hrdxb11='",g_argv3,"' ",
                 "   ORDER BY hrdxb03 "
                 
      PREPARE i0921_hrdxb_pre FROM l_sql
      DECLARE i0921_hrdxb_cs CURSOR FOR i0921_hrdxb_pre
      
      LET g_cnt=1
      
      FOREACH i0921_hrdxb_cs INTO g_hrdxb[g_cnt].* 
                            
           LET g_cnt=g_cnt+1
           
      END FOREACH
      CALL g_hrdxb.deleteElement(g_cnt)
      LET g_rec_b = g_cnt - 1
      
      LET g_cnt=0
      
      CALL g_hrdxc.clear()
      
      LET g_rec_b1=0
      
       LET l_sql=" SELECT hrdxc03,hrdxc04,hrdxc05,hrdxc06,hrdxc07 ",
                 "   FROM hrdxc_file ",
                 "  WHERE hrdxc02='",g_argv1,"' ",
                 "    AND hrdxc01='",g_argv2,"' ",
                 "    AND hrdxc09='",g_argv3,"' ",
                 "   ORDER BY hrdxc03 "
                 
      PREPARE i0921_hrdxc_pre FROM l_sql
      DECLARE i0921_hrdxc_cs CURSOR FOR i0921_hrdxc_pre
      
      LET g_cnt=1
      
      FOREACH i0921_hrdxc_cs INTO g_hrdxc[g_cnt].* 
                            
           LET g_cnt=g_cnt+1
           
      END FOREACH
      CALL g_hrdxc.deleteElement(g_cnt)
      LET g_rec_b1 = g_cnt - 1
      
      LET g_cnt=0           
                 	
END FUNCTION				
		
                                               
