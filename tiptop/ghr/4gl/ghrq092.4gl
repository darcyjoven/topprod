# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrq092.4gl
# Descriptions...: 
# Date & Author..: 08/05/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_sql         STRING,
       g_wc          STRING
DEFINE g_hrdxa   DYNAMIC ARRAY OF RECORD
         hrdxa01 LIKE   hrdxa_file.hrdxa01,
         hrdxa02 LIKE   hrat_file.hrat01,
         hrdxa03 LIKE   hrdxa_file.hrdxa03,
         hrdxa04 LIKE   hrao_file.hrao02,
         hrdxa05 LIKE   hras_file.hras04,
         hrdxa06 LIKE   hraa_file.hraa12,
         hrdxa07 LIKE   hrdxa_file.hrdxa07,
         hrdxa08 LIKE   hrdxa_file.hrdxa08,
         hrdxa09 LIKE   hrdxa_file.hrdxa09,
         hrdxa10 LIKE   hrdxa_file.hrdxa10,
         hrdxa11 LIKE   hrdxa_file.hrdxa11,
         hrdxa12 LIKE   hrdxa_file.hrdxa12,
         hrdxa13 LIKE   hrdxa_file.hrdxa13,
         hrdxa14 LIKE   hrdxa_file.hrdxa14,
         hrdxa15 LIKE   hrdxa_file.hrdxa15,
         hrdxa16 LIKE   hrdxa_file.hrdxa16,
         hrdxa17 LIKE   hrdxa_file.hrdxa17, 
         hrdxa18 LIKE   hrdxa_file.hrdxa18,
         hrdxa19 LIKE   hrdxa_file.hrdxa19,
         hrdxa20 LIKE   hrdxa_file.hrdxa20
                 END RECORD,
       g_rec_b   LIKE   type_file.num5,
       l_ac      LIKE   type_file.num5                 
DEFINE g_cnt         LIKE type_file.num10      
DEFINE g_i           LIKE type_file.num5 
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5


MAIN

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
 
   OPEN WINDOW q092_w WITH FORM "ghr/42f/ghrq092"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
          
   CALL cl_ui_init()
   
   #LET g_wc=" 1=1"
   
   #CALL q092_b_fill()
      
   CALL q092_menu()
   CLOSE WINDOW q092_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q092_menu()
DEFINE l_n      LIKE  type_file.num5
DEFINE l_hratid LIKE hrat_file.hratid
DEFINE l_msg    LIKE type_file.chr1000
DEFINE l_hrdxa22 LIKE hrdxa_file.hrdxa22
DEFINE l_ac1     LIKE   type_file.num5 
 
   WHILE TRUE
      CALL q092_bp("G")    
                          
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
            	 CALL q092_q()    
            END IF  		    	   	
            	                                                                                                                                                                                                                          
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "MX"
            LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_hrdxa[l_ac1].hrdxa02) THEN
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdxa[l_ac1].hrdxa02
            SELECT hrdxa22 INTO l_hrdxa22 FROM hrdxa_file WHERE hrdxa02=l_hratid AND hrdxa01=g_hrdxa[l_ac1].hrdxa01
            LET l_msg="ghri0921 '",l_hratid,"' '",g_hrdxa[l_ac1].hrdxa01,"' '",l_hrdxa22,"'"
            CALL cl_cmdrun_wait(l_msg)
         END IF
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN  
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdxa),'','')                     
            END IF
      END CASE
   END WHILE
 
END FUNCTION 
	
FUNCTION q092_q()
   CALL q092_b_askkey()
END FUNCTION
	
FUNCTION q092_b_askkey()
	
    CLEAR FORM
    CALL g_hrdxa.clear()
 
    CONSTRUCT g_wc ON hrdxa01,hrdxa02,hrdxa04,hrdxa05,hrdxa06                      
         FROM s_hrdxa[1].hrdxa01,s_hrdxa[1].hrdxa02,s_hrdxa[1].hrdxa04,                                  
              s_hrdxa[1].hrdxa05,s_hrdxa[1].hrdxa06
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrdxa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdxa[1].hrdxa01
               NEXT FIELD hrdxa01
            WHEN INFIELD(hrdxa02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdxa[1].hrdxa02
               NEXT FIELD hrdxa02
            WHEN INFIELD(hrdxa04)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdxa[1].hrdxa04
               NEXT FIELD hrdxa04
            WHEN INFIELD(hrdxa05)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hras01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdxa[1].hrdxa05
               NEXT FIELD hrdxa05   
            WHEN INFIELD(hrdxa06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdxa[1].hrdxa06
               NEXT FIELD hrdxa06         
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdxauser', 'hrdxagrup')
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --

    CALL cl_replace_str(g_wc,'hrdxa02','hrat01') RETURNING g_wc
    
    CALL q092_b_fill()
 
END FUNCTION
	
FUNCTION q092_b_fill()

	  LET g_sql=" SELECT hrdxa01,hrdxa02,hrdxa03,hrdxa04,hrdxa05,hrdxa06,hrdxa07,hrdxa08,hrdxa09,hrdxa10,",
	            "        hrdxa11,hrdxa12,hrdxa13,hrdxa14,hrdxa15,hrdxa16,hrdxa17,hrdxa18,hrdxa19,hrdxa20 ",
	            "   FROM hrdxa_file,hrat_file ",
	            "  WHERE hrdxa02=hratid ",
	            "    AND ",g_wc CLIPPED,
	            "  ORDER BY hrdxa01,hrdxa02"
	  PREPARE q092_pb FROM g_sql
    DECLARE hrdxa_curs CURSOR FOR q092_pb
 
    CALL g_hrdxa.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdxa_curs INTO g_hrdxa[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hrat01 INTO g_hrdxa[g_cnt].hrdxa02 FROM hrat_file 
         WHERE hratid=g_hrdxa[g_cnt].hrdxa02
         	
        SELECT hraa12 INTO g_hrdxa[g_cnt].hrdxa06 FROM hraa_file 
         WHERE hraa01=g_hrdxa[g_cnt].hrdxa06
        
        SELECT hrao02 INTO g_hrdxa[g_cnt].hrdxa04 FROM hrao_file
         WHERE hrao01=g_hrdxa[g_cnt].hrdxa04
         
        SELECT hras04 INTO g_hrdxa[g_cnt].hrdxa05 FROM hras_file
         WHERE hras01=g_hrdxa[g_cnt].hrdxa05        	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdxa.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0          
    	                 	
END FUNCTION
	
FUNCTION q092_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdxa TO s_hrdxa.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
                                       
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                                              
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
      ON ACTION MX
         LET g_action_choice="MX"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION		
			      
       
