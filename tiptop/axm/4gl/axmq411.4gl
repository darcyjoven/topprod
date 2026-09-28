# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: axmq4110.4gl
# Descriptions...: 料件銷售價格明細查詢 
# Date & Author..: FUN-A70146 10/08/01 By lilingyu  
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-A70146

DEFINE
    g_oea   RECORD
            oeb04   LIKE oeb_file.oeb04,
            ima08   LIKE ima_file.ima08,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
            oea01   LIKE oea_file.oea01,
            oea49   LIKE oea_file.oea49,
            oea03   LIKE oea_file.oea03,
            occ02   LIKE occ_file.occ02,
            oeb15   LIKE oeb_file.oeb15,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE oeb_file.oeb12,
            oea23   LIKE oea_file.oea23,
            oea21   LIKE oea_file.oea21,
            oea211  LIKE oea_file.oea211,
            oea213  LIKE oea_file.oea213,
            oeb13   LIKE oeb_file.oeb13,
            oeb916  LIKE oeb_file.oeb916,
            oeb917  LIKE oeb_file.oeb917
        END RECORD,
    g_argv1         LIKE oeb_file.oeb04,
    g_sql           STRING, 
    g_wc            STRING,
    g_rec_b         LIKE type_file.num10   
DEFINE p_row,p_col  LIKE type_file.num5         
DEFINE   g_cnt      LIKE type_file.num10       
DEFINE   g_msg      LIKE type_file.chr1000
DEFINE   l_ac       LIKE type_file.num5       
DEFINE g_row_count  LIKE type_file.num10        
DEFINE g_curs_index LIKE type_file.num10         
DEFINE g_jump       LIKE type_file.num10        
DEFINE mi_no_ask    LIKE type_file.num5        
 
MAIN 
   OPTIONS                          
        INPUT NO WRAP
    DEFER INTERRUPT        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
   
   LET g_argv1  = ARG_VAL(1)         
   
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q411_w AT p_row,p_col WITH FORM "axm/42f/axmq411"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    IF g_sma.sma116 = '0' OR g_sma.sma116 = '1' THEN 
       CALL cl_set_comp_visible("oeb916,oeb917",FALSE)
    ELSE
       CALL cl_set_comp_visible("oeb916,oeb917",TRUE)    	     
    END IF  
    
    IF NOT cl_null(g_argv1) THEN 
       CALL q411_q() 
    END IF
    
    CALL q411_menu()
    
    CLOSE WINDOW q411_w
    CALL  cl_used(g_prog,g_time,2)  RETURNING g_time    
END MAIN
 
FUNCTION q411_cs()
DEFINE   l_cnt LIKE type_file.num5         
 
   IF NOT cl_null(g_argv1) THEN 
      LET g_wc = "oeb04 = '",g_argv1,"'"
   ELSE 
   	 CLEAR FORM 
     CALL g_oeb.clear()
     CALL cl_opmsg('q')
     
     INITIALIZE g_wc TO NULL			
     CALL cl_set_head_visible("","YES")  
     
     INITIALIZE g_oea.* TO NULL   
     CONSTRUCT BY NAME g_wc ON oeb04
     
     BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
        ON ACTION CONTROLP    
          CASE 
             WHEN INFIELD(oeb04) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oeb04"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oeb04
              NEXT FIELD oeb04
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
       
   IF INT_FLAG THEN 
      RETURN 
   END IF
 END IF
 
 IF cl_null(g_wc) THEN
    LET g_wc = " 1=1"
 END IF   
 
   LET g_sql=   " SELECT DISTINCT oeb04 FROM oea_file,oeb_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND oea01 = oeb01",
                "   AND oea49 <> '0'",
                "   AND oeb04 IS NOT NULL"               
 
   PREPARE q411_prepare FROM g_sql
   DECLARE q411_cs SCROLL CURSOR FOR q411_prepare
 
   LET g_sql=" SELECT COUNT(DISTINCT oeb04) FROM oea_file,oeb_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND oea01 = oeb01",                
                "   AND oea49 <> '0'",     
                "   AND oeb04 IS NOT NULL"           
 
   PREPARE q411_pp  FROM g_sql
   DECLARE q411_cnt   CURSOR FOR q411_pp
END FUNCTION
  
FUNCTION q411_menu()
 
   WHILE TRUE
      CALL q411_bp("G")

      CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q411_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q411_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    
    DISPLAY '   ' TO FORMONLY.cnt
    
    CALL q411_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q411_cs                            # 從DB產生合乎條件TEMP(0-30秒)
  
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q411_cnt
        FETCH q411_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q411_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    
	MESSAGE ''
END FUNCTION
 
FUNCTION q411_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1            
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q411_cs INTO g_oea.oeb04
        WHEN 'P' FETCH PREVIOUS q411_cs INTO g_oea.oeb04
        WHEN 'F' FETCH FIRST    q411_cs INTO g_oea.oeb04
        WHEN 'L' FETCH LAST     q411_cs INTO g_oea.oeb04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
      ON ACTION about       
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 END PROMPT
 
    IF INT_FLAG THEN
          LET INT_FLAG = 0
          EXIT CASE
    END IF
   END IF
 
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q411_cs INTO g_oea.oeb04
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oeb04,SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
	SELECT ima01,ima08,ima02,ima021 INTO g_oea.*
	  FROM ima_file
	 WHERE ima01 = g_oea.oeb04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ima_file",g_oea.oeb04,"",SQLCA.sqlcode,"","",0)  
        RETURN
    END IF
 
    CALL q411_show()
END FUNCTION
 
FUNCTION q411_show()
   
   DISPLAY BY NAME g_oea.*
 
   CALL q411_b_fill() 
   CALL cl_show_fld_cont()               
END FUNCTION
 
FUNCTION q411_b_fill()             
   DEFINE l_sql     LIKE type_file.chr1000      
    
   CALL g_oeb.clear()
    
   LET l_sql =" SELECT oea01,oea49,oea03,'',oeb15,oeb05,oeb12,oea23,",
              " oea21,oea211,oea213,oeb13,oeb916,oeb917",											
              " FROM oea_file,oeb_file",											
              " WHERE oea49 <> '0'",				
              "   AND oea01 = oeb01",							
              "   AND oeb04 = '",g_oea.oeb04,"'"
    PREPARE q411_pb FROM l_sql
    DECLARE q411_bcs  CURSOR WITH HOLD FOR q411_pb
    
    LET g_cnt = 1
    
    FOREACH q411_bcs INTO g_oeb[g_cnt].*
        IF STATUS THEN
            CALL cl_err('',STATUS,0)
            EXIT FOREACH
        END IF
        
        SELECT occ02 INTO g_oeb[g_cnt].occ02 FROM occ_file
         WHERE occ01 = g_oeb[g_cnt].oea03
        
        LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF

    END FOREACH
    CALL g_oeb.deleteElement(g_cnt) 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q411_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        CALL cl_show_fld_cont()                  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      
      ON ACTION first
         CALL q411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
      ON ACTION jump
         CALL q411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
  
      ON ACTION next
         CALL q411_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
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
 
   ON ACTION exporttoexcel      
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                                           
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
