# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri100.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrac           DYNAMIC ARRAY OF RECORD    
        hrac02       LIKE hrac_file.hrac02,
        hrac03       LIKE hrac_file.hrac03,
        hrac04       LIKE hrac_file.hrac04  
                    END RECORD,
    g_hrac_t         RECORD                 
        hrac02       LIKE hrac_file.hrac02,
        hrac03       LIKE hrac_file.hrac03,
        hrac04       LIKE hrac_file.hrac04
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 

DEFINE g_hrac01     LIKE hrac_file.hrac01
DEFINE g_hrac01_t   LIKE hrac_file.hrac01
DEFINE g_bdate      LIKE hrac_file.hrac03
DEFINE g_bdate_t    LIKE hrac_file.hrac03
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5      
DEFINE g_str        STRING 
DEFINE g_msg        LIKE type_file.chr1000

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
    OPEN WINDOW i100_w AT p_row,p_col WITH FORM "ghr/42f/ghri100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    LET g_forupd_sql =" SELECT hrac01 FROM hrac_file ",
                      "  WHERE hrac01 = ? ",  #No.FUN-710055
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_lock_u CURSOR FROM g_forupd_sql

    CALL i100_menu()

    CLOSE WINDOW i100_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
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
               IF g_hrac01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrac01"
                  LET g_doc.value1 = g_hrac01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrac),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i100_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL g_hrac.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i100_b_askkey()
   IF INT_FLAG THEN                            
      LET INT_FLAG = 0
      RETURN
   END IF

   LET g_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
              "  WHERE ",g_wc2 CLIPPED,
              "  ORDER BY hrac01"
    PREPARE i100_prepare FROM g_sql
    DECLARE i100_curs
      SCROLL CURSOR WITH HOLD FOR i100_prepare

    LET g_sql=" SELECT COUNT(DISTINCT hrac01) FROM hrac_file ",
              "  WHERE ",g_wc2 CLIPPED
    PREPARE i100_count_prepare FROM g_sql
    DECLARE i100_count CURSOR FOR i100_count_prepare

    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt	
    OPEN i100_curs
    IF SQLCA.SQLCODE THEN                         
       CALL cl_err('',SQLCA.SQLCODE,0)
       INITIALIZE g_hrac01 TO NULL                 
    ELSE
       CALL i100_fetch('F')                 
    END IF
   	
END FUNCTION
	
FUNCTION i100_fetch(p_flag)                  
DEFINE   p_flag   LIKE type_file.chr1,         
         l_abso   LIKE type_file.num10         

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i100_curs INTO g_hrac01
      WHEN 'P' FETCH PREVIOUS i100_curs INTO g_hrac01
      WHEN 'F' FETCH FIRST    i100_curs INTO g_hrac01
      WHEN 'L' FETCH LAST     i100_curs INTO g_hrac01
      WHEN '/'
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i100_curs INTO g_hrac01
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrac01,SQLCA.sqlcode,0)
      INITIALIZE g_hrac01 TO NULL  #TQC-6B0i100
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i100_show()
   END IF
END FUNCTION	
	
FUNCTION i100_b_askkey()
    CLEAR FORM
    CALL g_hrac.clear()
 
    CONSTRUCT g_wc2 ON hrac01,hrac02,hrac03,hrac04                      
         FROM hrac01,                                 
              s_hrac[1].hrac02,s_hrac[1].hrac03,s_hrac[1].hrac04
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
               WHEN INFIELD(hrac01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrac01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrac01
               NEXT FIELD hrac01
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hracuser', 'hracgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
{    	
    LET g_sql=" SELECT DISTINCT hrac01,hrac02,hrac03,hrac04 FROM hrac_file ",
              "  WHERE ",g_wc2 CLIPPED,
              "  ORDER BY hrac01,hrac02,hrac03,hrac04"
    PREPARE i100_prepare FROM g_sql          
    DECLARE i100_curs                    
      SCROLL CURSOR WITH HOLD FOR i100_prepare 
    
    LET g_sql=" SELECT COUNT(DISTINCT hrac01) FROM hrac_file ",
              "  WHERE ",g_wc2 CLIPPED
    PREPARE i100_count_prepare FROM g_sql          
    DECLARE i100_count CURSOR FOR i100_count_prepare         
}               	 
END FUNCTION	

FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrac02,hrac03,hrac04",
                   " FROM hrac_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hrac01='",g_hrac01,"'", 
                   " ORDER BY hrac03" 
 
    PREPARE i100_pb FROM g_sql
    DECLARE hrac_curs CURSOR FOR i100_pb
 
    CALL g_hrac.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrac_curs INTO g_hrac[g_cnt].*   
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
    CALL g_hrac.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION


FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrac TO s_hrac.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
     
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY    
      
      ON ACTION delete
         LET g_action_choice="delete"
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION first                            
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous                         
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump                             
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next                             
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last                             
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST   
 
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
	
FUNCTION i100_show()                         
   DISPLAY g_hrac01 TO hrac01
   SELECT hrac03 INTO g_bdate FROM hrac_file WHERE hrac01=g_hrac01 AND hrac02='1'  
   DISPLAY g_bdate TO bdate
   CALL i100_b_fill(g_wc2)                    
   CALL cl_show_fld_cont()                   
END FUNCTION
	
FUNCTION i100_a()                            
   MESSAGE ""
   CLEAR FORM
   CALL g_hrac.clear()
   INITIALIZE g_hrac01 TO NULL
   INITIALIZE g_bdate TO null

   CALL cl_opmsg('a')

   WHILE TRUE                     
      CALL i100_i("a")                       

      IF INT_FLAG THEN                            
         LET g_hrac01=NULL
         LET g_bdate=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      ELSE
      	 BEGIN WORK 
      	 CALL g_hrac.clear()     
         CALL i100_g_b('a')   	
      END IF
      	                    
      LET g_hrac01_t=g_hrac01
      LET g_bdate_t=g_bdate
      EXIT WHILE
   END WHILE
   
   IF g_success='Y' THEN
   	  COMMIT WORK
   ELSE
   	  ROLLBACK WORK
   END IF
   		  	  	
END FUNCTION	
	
FUNCTION i100_i(p_cmd)                       

   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_count      LIKE type_file.num5  
   DEFINE   l_str        STRING 
   DEFINE   l_n,l_i      LIKE type_file.num5
   DEFINE   l_check      STRING
   DEFINE   l_date       LIKE type_file.chr10 
   #DEFINE   l_n          LIKE type_file.num5
   DEFINE   l_hrac01     LIKE hrac_file.hrac01
   DEFINE   l_bdate      LIKE hrac_file.hrac04

   DISPLAY g_hrac01,g_bdate TO hrac01,bdate   
   CALL cl_set_head_visible("","YES")   
   INPUT g_hrac01,g_bdate WITHOUT DEFAULTS FROM hrac01,bdate 

   BEFORE INPUT
      IF p_cmd='u' THEN
      	 CALL cl_set_comp_entry("hrac01",FALSE)
      ELSE
      	 #CALL cl_set_comp_entry("hrac01",TRUE)
         LET l_n=0
         SELECT COUNT(DISTINCT hrac01) INTO l_n FROM hrac_file
         IF l_n>0 THEN
            CALL cl_set_comp_entry("hrac01",FALSE)
            SELECT MAX(DISTINCT hrac01)+1 INTO g_hrac01 FROM hrac_file
            LET g_hrac01=g_hrac01 USING "&&&&"
            LET l_hrac01=g_hrac01-1 USING "&&&&"
            SELECT hrac04+1 INTO g_bdate FROM hrac_file WHERE hrac01=l_hrac01
                                                          AND hrac02='12'
            DISPLAY g_hrac01 TO hrac01
            DISPLAY g_bdate TO bdate
         ELSE  
            CALL cl_set_comp_entry("hrac01",TRUE)
         END IF
      END IF
	 	   
   AFTER FIELD hrac01
      IF NOT cl_null(g_hrac01) THEN
         IF g_hrac01 != g_hrac01_t OR g_hrac01_t IS NULL THEN
            LET l_count=0
      	    SELECT COUNT(DISTINCT hrac01) INTO l_count FROM hrac_file WHERE hrac01=g_hrac01
      	    IF l_count>0 THEN
      	 	  CALL cl_err(g_hrac01,-239,1)
      	 	  LET g_hrac01=g_hrac01_t
      	 	  NEXT FIELD hrac01
      	    END IF
         END IF
      	 		  
      	 LET l_str=g_hrac01
      	 LET l_str=l_str.trim()
      	 LET l_n=l_str.getLength()
      	 IF l_n != 4 THEN
      	 	  CALL cl_err(g_hrac01,'',1)
      	 	  NEXT FIELD hrac01
      	 END IF
      	 	
      	 FOR l_i = 1 TO l_n
      	    LET l_check=l_str.getCharAt(l_i)
      	    IF l_check NOT MATCHES "[0-9]" THEN
               NEXT FIELD hrac01
               EXIT FOR
            END IF
         END FOR
         
         IF cl_null(g_bdate) THEN
         	  LET l_str=''
         	  LET l_str=l_str.trim()
         	  LET l_str=l_str CLIPPED,g_hrac01
         	  LET l_str=l_str CLIPPED,'0101'
         	  LET l_str=l_str.trim()
         	  LET l_date=l_str
         	  SELECT to_date(l_date,'yyyymmdd') INTO g_bdate FROM DUAL 
         	  DISPLAY g_bdate TO b_date
         END IF	     	       	        	  	
      END IF

      AFTER FIELD bdate
         IF NOT cl_null(g_bdate) THEN
            IF NOT cl_null(g_hrac01) THEN
               LET l_hrac01=g_hrac01-1 USING "&&&&"
               SELECT hrac04+1 INTO l_bdate FROM hrac_file WHERE hrac01=l_hrac01
                                                             AND hrac02='12'
               IF NOT cl_null(l_bdate) THEN
                  IF g_bdate != l_bdate THEN
                     IF NOT cl_confirm("与前一财年日期不连续,是否继续?") THEN
                        LET g_bdate=l_bdate
                     END IF
                  END IF
               END IF
            END IF
         END IF    
               
      	
      AFTER INPUT 
         IF INT_FLAG THEN
            RETURN
         END IF
         IF g_hrac01 IS NULL THEN
         	  NEXT FIELD hrac01
         END IF
         	
         IF g_bdate IS NULL THEN
         	  NEXT FIELD bdate
         END IF	  		  	
      		 		  
      ON ACTION controlf                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


   END INPUT
END FUNCTION	
	
FUNCTION i100_u()

   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrac01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrac01_t = g_hrac01
   LET g_bdate_t = g_bdate

   BEGIN WORK
   OPEN i100_lock_u USING g_hrac01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i100_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i100_lock_u INTO g_hrac01
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrac01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i100_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i100_i("u")
      IF INT_FLAG THEN
         LET g_hrac01 = g_hrac01_t
         LET g_bdate = g_bdate_t
         DISPLAY g_hrac01,g_bdate TO hrac01,g_bdate
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      ELSE
      	 CALL g_hrac.clear()     
         CALL i100_g_b('u')   	
      END IF
      EXIT WHILE
   END WHILE
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
   	  ROLLBACK WORK
   END IF	     
END FUNCTION	

FUNCTION i100_r()        
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_hrac   RECORD LIKE hrac_file.*
   DEFINE   l_hrac01 LIKE hrac_file.hrac01

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrac01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET l_cnt=0 
   LET l_hrac01=g_hrac01+1 USING "&&&&"
   SELECT COUNT(DISTINCT hrac01) INTO l_cnt FROM hrac_file WHERE hrac01=l_hrac01
   IF l_cnt>0 THEN
      CALL cl_err("已维护下一财年的资料,不可删除本财年","!",0)
      RETURN
   END IF
   
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM hran_file WHERE hran03=g_hrac01
   IF l_cnt>0 THEN
   	  CALL cl_err(g_hrac01,'',0)
   	  RETURN
   END IF	  	
   BEGIN WORK
   IF cl_delh(0,0) THEN                   
      DELETE FROM hrac_file
       WHERE hrac01 = g_hrac01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hrac_file",g_hrac01,'',SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM        
         CALL g_hrac.clear()
         OPEN i100_count
         FETCH i100_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i100_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i100_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL i100_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
	
FUNCTION i100_g_b(p_cmd)
DEFINE   p_cmd     LIKE    type_file.chr1
DEFINE   l_i       LIKE    type_file.num5
DEFINE   l_hrac02  LIKE    hrac_file.hrac02
DEFINE   l_hrac03  LIKE    hrac_file.hrac03
DEFINE   l_hrac04  LIKE    hrac_file.hrac04
         
         IF NOT cl_null(g_bdate) THEN
         	  LET g_success='Y'
         	  FOR l_i = 1 TO 12
         	     LET l_hrac02=l_i
         	     IF l_i=1 THEN
         	     	  LET l_hrac03=g_bdate
         	     	  SELECT add_months(l_hrac03,1)-1 INTO l_hrac04 FROM DUAL 
         	     ELSE
         	     	  LET l_hrac03=l_hrac04+1
         	     	  SELECT add_months(l_hrac03,1)-1 INTO l_hrac04 FROM DUAL
         	     END IF
         	     	
         	     IF p_cmd='a' THEN
         	     	  INSERT INTO hrac_file(hrac01,hrac02,hrac03,hrac04,hracuser,hracgrup,
         	     	                        hracoriu,hracorig)
         	     	     VALUES(g_hrac01,l_hrac02,l_hrac03,l_hrac04,g_user,g_grup,g_user,g_grup)                     	 	    	
	             END IF
	             	
	             IF p_cmd='u' THEN
	             	  UPDATE hrac_file SET hrac03=l_hrac03,hrac04=l_hrac04,
	             	                       hracmodu=g_user,hracdate=g_today
	             	   WHERE hrac01=g_hrac01
	             	     AND hrac02=l_hrac02
	             END IF
	             	
	             IF SQLCA.sqlcode THEN
	             	  LET g_success='N'
	             	  EXIT FOR
	             END IF
	             	
	          END FOR
	       ELSE
	       	  LET g_success='N'   
	       END IF 
	       
               LET g_wc2="hrac01='",g_hrac01,"'"
	       CALL i100_show()	     		  		                         	
	
END FUNCTION	
