# Prog. Version..: '5.30.03-12.09.18(00000)'     #
# Pattern name...: ghri013.4gl
# Descriptions...: 
# Date & Author..: 13/04/15 By Yougs 
 
DATABASE ds
 
GLOBALS "../../config/top.global" 

DEFINE g_hrag          RECORD LIKE hrag_file.* 
DEFINE g_hrav01         LIKE hrav_file.hrav01      
DEFINE g_hrav01_t       LIKE hrav_file.hrav01  
DEFINE g_hrat01         LIKE hrat_file.hrat01  
DEFINE g_hrat01_t       LIKE hrat_file.hrat01,  
    g_hrav           DYNAMIC ARRAY OF RECORD 
        hrav02       LIKE hrav_file.hrav02,    
        hrav03       LIKE hrav_file.hrav03,
        hrat02       LIKE hrat_file.hrat02,
        hrav04       LIKE hrav_file.hrav04,
        hrav05       LIKE hrav_file.hrav05,
        hrau03       LIKE hrau_file.hrau03,
        hrav06       LIKE hrav_file.hrav06,
        hrav06_n     LIKE type_file.chr200,
        str1         LIKE hrav_file.hrav07,        
        str2         LIKE hrav_file.hrav07,
        str3         LIKE type_file.dat,   
        hrav07       LIKE hrav_file.hrav07,
        hrav07_n     LIKE type_file.chr200,   
        hrav08       LIKE hrav_file.hrav08,   
        hrav09       LIKE hrav_file.hrav09,   
        hrav10      LIKE hrav_file.hrav10 
                    END RECORD, 
   g_hrav_t            RECORD 
        hrav02       LIKE hrav_file.hrav02,    
        hrav03       LIKE hrav_file.hrav03,
        hrat02       LIKE hrat_file.hrat02,
        hrav04       LIKE hrav_file.hrav04,
        hrav05       LIKE hrav_file.hrav05,
        hrau03       LIKE hrau_file.hrau03,
        hrav06       LIKE hrav_file.hrav06,
        hrav06_n     LIKE type_file.chr200,
        str1         LIKE hrav_file.hrav07,        
        str2         LIKE hrav_file.hrav07,
        str3         LIKE type_file.dat,   
        hrav07       LIKE hrav_file.hrav07,
        hrav07_n     LIKE type_file.chr200,   
        hrav08       LIKE hrav_file.hrav08,   
        hrav09       LIKE hrav_file.hrav09,   
        hrav10      LIKE hrav_file.hrav10 
                    END RECORD,               
    g_argv1         LIKE hrav_file.hrav01,      
    g_rec_b         LIKE type_file.num5,      
    g_wc,g_wc2,g_sql      string,                 
    g_ss            LIKE type_file.chr1,    
    g_s             LIKE type_file.chr1,    
    g_rec           LIKE type_file.num5,    
    l_ac            LIKE type_file.num5,
    l_ac_2            LIKE type_file.num5     
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_chr,g_l                 LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5    #FUN-570110  #No.FUN-690026 SMALLINT
DEFINE g_str                 STRING                 #No.FUN-840029 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ghr")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_hrav01 = NULL                  
   LET g_hrav01_t = NULL 

   OPEN WINDOW i013_w WITH FORM "ghr/42f/ghri013"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init() 
 
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL i013_q()
   END IF
   CALL cl_set_comp_visible("str1,str2,str3",FALSE)
   CALL cl_set_comp_visible("hrav07",TRUE)
   LET g_l = 'N'
   CALL i013_menu()
   CLOSE WINDOW i013_w                 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 

FUNCTION i013_curs()
    CLEAR FORM                            
    CALL g_hrav.clear()
    IF g_argv1 IS NULL OR  g_argv1 = ' ' THEN 
       INITIALIZE g_hrav01 TO NULL
       CALL cl_set_head_visible("","YES")  
       CONSTRUCT g_wc ON hrav01,hrav02,hrav03,hrat02,hrav04,hrav05,hrav06,hrav07,hrav08,hrav09,hrav10
            FROM hrav01,s_hrav[1].hrav02,s_hrav[1].hrav03,s_hrav[1].hrat02,s_hrav[1].hrav04,s_hrav[1].hrav05,s_hrav[1].hrav06,
                 s_hrav[1].hrav07,s_hrav[1].hrav08,s_hrav[1].hrav09,s_hrav[1].hrav10
         BEFORE CONSTRUCT
            CALL cl_qbe_init() 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrav01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrav01"
                   LET g_qryparam.state= "c" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret  
                   DISPLAY g_qryparam.multiret TO hrav01
                   NEXT FIELD hrav01
                WHEN INFIELD(hrav03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrat01"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO hrav03
                   NEXT FIELD hrav03
                WHEN INFIELD(hrav04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau01"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO hrav04         
                   NEXT FIELD hrav04   
                WHEN INFIELD(hrav05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau02"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO hrav05         
                   NEXT FIELD hrav05          
                OTHERWISE
                   EXIT CASE
            END CASE
  
            ON ACTION qbe_select
               CALL cl_qbe_select()
            ON ACTION qbe_save
               CALL cl_qbe_save()
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT 
            
            ON ACTION about         
               CALL cl_about()      
            
            ON ACTION help          
               CALL cl_show_help()  
 
            ON ACTION CONTROLG
               CALL cl_cmdask() 
        END CONSTRUCT 
 
        IF INT_FLAG THEN RETURN END IF  
    ELSE  
       LET g_wc = " hrav01 = '",g_argv1,"'"
    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hravuser', 'hravgrup')
    LET g_wc = cl_replace_str(g_wc,"hrav03","hrat01")	
    LET g_sql= "SELECT UNIQUE hrav01 FROM hrav_file,hrat_file ",
               " WHERE hrav03 = hratid AND ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i013_prepare FROM g_sql      
    DECLARE i013_b_curs                  
        SCROLL CURSOR WITH HOLD FOR i013_prepare
    LET g_sql="SELECT COUNT(DISTINCT hrav01)",
              "  FROM hrav_file,hrat_file WHERE hrav03 = hratid AND ",g_wc CLIPPED
    PREPARE i013_precount FROM g_sql
    DECLARE i013_count CURSOR FOR i013_precount
END FUNCTION
 
FUNCTION i013_menu() 
	
   WHILE TRUE
      CALL i013_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
            	 SELECT to_char(MAX(hrav01)+1) INTO g_hrav01 FROM hrav_file WHERE replace(to_char(sysdate,'yyyymmdd'),' ','') = substr(hrav01,1,8)
            	 IF cl_null(g_hrav01) THEN
            	 	  SELECT replace(to_char(sysdate,'yyyymmdd'),' ','')||'001' INTO g_hrav01 FROM DUAL
            	 END IF	  
               CALL i013_2_a()
               LET g_wc = "1=1"
               CALL i013_show()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i013_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
            	 IF NOT cl_null(g_hrav01) THEN
                  CALL ghri013_1('update',g_hrav01)
                  LET g_wc = "1=1"
                  CALL i013_show()
               END IF  
            END IF              	   
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i013_2_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrav),'','')
            END IF 
         WHEN "related_document"                        
            IF cl_chk_act_auth() THEN                 
                IF g_hrav01 IS NOT NULL THEN             
                   LET g_doc.column1 = "hrav01"       
                   LET g_doc.value1 = g_hrav01      
                   CALL cl_doc()                  
                END IF                           
            END IF                              
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i013_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
   CALL cl_set_comp_visible("str1,str2,str3",FALSE)
   CALL cl_set_comp_visible("hrav07",TRUE)
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL g_hrav.clear()                     
    CALL i013_curs()                    
    IF INT_FLAG THEN                       
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i013_b_curs                     
    IF SQLCA.sqlcode AND (g_argv1 IS NULL OR g_argv1=' ') THEN                          
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_hrav01 TO NULL
    ELSE
        OPEN i013_count
        FETCH i013_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i013_fetch('F')             
    END IF
END FUNCTION
  
FUNCTION i013_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                   
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i013_b_curs INTO g_hrav01
        WHEN 'P' FETCH PREVIOUS i013_b_curs INTO g_hrav01
        WHEN 'F' FETCH FIRST    i013_b_curs INTO g_hrav01
        WHEN 'L' FETCH LAST     i013_b_curs INTO g_hrav01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i013_b_curs INTO g_hrav01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_hrav01,SQLCA.sqlcode,0)
        INITIALIZE g_hrav01 TO NULL  
    ELSE
       CALL i013_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF 
END FUNCTION
  
FUNCTION i013_show()
    DISPLAY g_hrav01 TO hrav01                   
    CALL i013_b_fill(g_wc)                    
    CALL cl_show_fld_cont()                  
END FUNCTION
 

FUNCTION i013_b_fill(p_wc)              
DEFINE
    p_wc            LIKE type_file.chr1000  
    LET g_sql =
       "SELECT hrav02,hrat01,hrat02,hrav04,hrav05,'',hrav06,hrav06_n,'','','',hrav07,hrav07_n,hrav08,hrav09,hrav10 ",
       " FROM hrav_file,hrat_file ",
       " WHERE hrav01 = '",g_hrav01,"' ",
       "   AND hrav03 = hratid ", 
       "   AND ",p_wc CLIPPED ,
       " ORDER BY hrav02 "
    PREPARE i013_prepare2 FROM g_sql       
    DECLARE hrav_curs CURSOR FOR i013_prepare2
    CALL g_hrav.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET  g_l = 'Y'
    FOREACH hrav_curs INTO g_hrav[g_cnt].*    
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT hrau03 INTO g_hrav[g_cnt].hrau03 FROM hrau_file
        WHERE hrau01 = g_hrav[g_cnt].hrav04
          AND hrau02 = g_hrav[g_cnt].hrav05
       IF cl_null(g_hrav[g_cnt].hrav07_n) THEN 
          CALL i013_getName(g_hrav[g_cnt].hrav05,g_hrav[g_cnt].hrav07) RETURNING g_hrav[g_cnt].hrav07_n
       END IF 
       IF cl_null(g_hrav[g_cnt].hrav06_n) THEN 
          CALL i013_getName(g_hrav[g_cnt].hrav05,g_hrav[g_cnt].hrav06) RETURNING g_hrav[g_cnt].hrav06_n
       END IF 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_hrav.deleteElement(g_cnt)
    LET g_rec = g_cnt - 1
    DISPLAY g_rec TO FORMONLY.cn2
    LET g_cnt = 0
    LET g_l = 'N'
END FUNCTION
 
FUNCTION i013_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrav TO s_hrav.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
  
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION detail                          
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION accept                          
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION first
         CALL i013_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY   
 
 
      ON ACTION previous
         CALL i013_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY   
 
 
      ON ACTION jump
         CALL i013_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY   
 
 
      ON ACTION next
         CALL i013_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   
 
 
      ON ACTION last
         CALL i013_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                    
   
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY 
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE    
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION related_document                                            
         LET g_action_choice="related_document"                             
         EXIT DISPLAY                                                       
  
      AFTER DISPLAY
         CONTINUE DISPLAY                                                                                        
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i013_2_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_hrav.clear()
    
    IF s_shut(0) THEN RETURN END IF  
    CALL cl_opmsg('a')
    WHILE TRUE                                        
        IF INT_FLAG THEN                                           
            LET INT_FLAG = 0                                       
            CALL cl_err('',9001,0)                                 
            EXIT WHILE                                             
        END IF                                                     
        LET g_rec_b = 0                                             
        CALL g_hrav.clear()                                                      
        CALL i013_2_b2()             
        EXIT WHILE
    END WHILE 
END FUNCTION   

FUNCTION i013_2_b2()
DEFINE l_hrau04     LIKE hrau_file.hrau04
DEFINE l_hrau05     LIKE hrau_file.hrau05
DEFINE l_hrau07     LIKE hrau_file.hrau07
DEFINE l_sql,l_sql2 STRING
DEFINE l_flag       LIKE type_file.chr1
DEFINE
    l_ac_2_t          LIKE type_file.num5,                                                
    l_n             LIKE type_file.num5,                                                
    l_lock_sw       LIKE type_file.chr1,                                                
    p_cmd           LIKE type_file.chr1,                                                
    l_allow_insert  LIKE type_file.num5,                                                
    l_allow_delete  LIKE type_file.num5
                                              
 
    LET g_action_choice = ""
    LET g_wc2="1=1"
  
    CALL cl_set_comp_visible("hrat01",FALSE)
    CALL cl_set_comp_visible("hrav07",FALSE)
    CALL cl_set_comp_entry("hrav03,hrat02",TRUE)
    CALL cl_set_comp_entry("hrav02,hrav06,hrav07",FALSE)
    DISPLAY g_hrav01 TO hrav01
    CALL cl_opmsg('b')  
    LET g_forupd_sql = " SELECT hrav02,hrav03,'',hrav04,hrav05,'',hrav06,hrav06_n,'','','',hrav07,hrav07_n,hrav08,hrav09,hrav10 ",
                       " FROM hrav_file WHERE hrav01=? AND hrav02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i013_1_b_cur2 CURSOR FROM g_forupd_sql
 
    LET l_ac_2_t = 0  
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_hrav WITHOUT DEFAULTS FROM s_hrav.*  
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac_2)
           END IF
           CALL cl_set_comp_entry("hrat02,hrav07_n,hrau03,hrav06_n",FALSE)
           CALL cl_set_comp_visible("str1,str2,str3",TRUE)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac_2 = ARR_CURR()
            LET l_lock_sw = 'N'             
            LET l_n  = ARR_COUNT()
            CALL cl_set_comp_entry("hrav03,hrav04,hrav05,str1,str2,str3,hrav08",TRUE)
            BEGIN WORK
            IF g_rec_b >= l_ac_2 THEN
                LET p_cmd='u'
                LET g_hrav_t.* = g_hrav[l_ac_2].*   
                OPEN i013_1_b_cur2 USING g_hrav01,g_hrav_t.hrav02
                IF STATUS THEN
                   CALL cl_err("OPEN i013_1_b_cur2:", STATUS, 1)
                   CLOSE i013_1_b_cur2
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i013_1_b_cur2 INTO g_hrav[l_ac_2].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrav_t.hrav04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_hrav_t.*=g_hrav[l_ac_2].*
                   END IF
                END IF
                SELECT hrau03,hrau04 INTO g_hrav[l_ac_2].hrau03,l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrav[l_ac_2].hrav04
                   AND hrau02 = g_hrav[l_ac_2].hrav05 	
                DISPLAY BY NAME g_hrav[l_ac_2].hrau03
              SELECT hrat02 INTO g_hrav[l_ac_2].hrat02 FROM hrat_file
               WHERE hrat01 = g_hrav[l_ac_2].hrav03
             DISPLAY g_hrav[l_ac_2].hrat02 TO hrat02 
                IF l_hrau04 = '1' THEN
                	 CALL cl_set_comp_required("str1",TRUE) 	
                	 CALL cl_set_comp_entry("str1",TRUE)
                   CALL cl_set_comp_required("str2,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str2,str3",FALSE)
                	 LET g_hrav[l_ac_2].str2 = ''
                	 LET g_hrav[l_ac_2].str3 = ''
                END IF
                IF l_hrau04 = '2' THEN
                	 CALL cl_set_comp_required("str2",TRUE) 	
                	 CALL cl_set_comp_entry("str2",TRUE)
                   CALL cl_set_comp_required("str1,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str3",FALSE)
                	 LET g_hrav[l_ac_2].str1 = ''
                	 LET g_hrav[l_ac_2].str3 = ''
                END IF 	
                IF l_hrau04 = '3' THEN
                	 CALL cl_set_comp_required("str3",TRUE) 	
                	 CALL cl_set_comp_entry("str3",TRUE)
                   CALL cl_set_comp_required("str1,str2",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str2",FALSE)
                	 LET g_hrav[l_ac_2].str1 = ''
                	 LET g_hrav[l_ac_2].str2 = ''
                END IF 			 	   	  
                CALL cl_show_fld_cont()      
            END IF
                IF  g_hrav[l_ac_2].hrav10 = 'Y' THEN 
                    CALL cl_set_comp_entry("hrav05,str1,str2,str3,hrav03,hrav04,hrav08",FALSE)
                    CALL cl_set_comp_entry("hrav09",TRUE)
                    CALL cl_err('','!',0)
                END IF 
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET l_flag = 'Y'
           CALL i013_2_ins() RETURNING l_flag
           IF l_flag = 'N' THEN 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrav[l_ac_2].* TO NULL                   
            LET g_hrav[l_ac_2].hrav08 = g_today                      
            LET g_hrav_t.* = g_hrav[l_ac_2].*                                           
            CALL cl_show_fld_cont()     
            NEXT FIELD hrav02
        
        BEFORE FIELD hrav02 
           IF p_cmd <> 'u' THEN
              IF g_hrav[l_ac_2].hrav02 IS NULL OR g_hrav[l_ac_2].hrav02 > 0 THEN
                 SELECT max(hrav02)+1 INTO g_hrav[l_ac_2].hrav02 FROM hrav_file 
                 WHERE hrav01=g_hrav01 
                 IF g_hrav[l_ac_2].hrav02 IS NULL THEN
                  LET g_hrav[l_ac_2].hrav02=1
                 END IF
              END IF 
           END IF
        AFTER FIELD hrav02
             DISPLAY g_hrav[l_ac_2].hrav02 TO hrav02
             NEXT FIELD hrav03
 
        AFTER FIELD hrav04                       
            IF g_hrav[l_ac_2].hrav04 IS NOT NULL THEN 
            	 LET l_n = 0
               SELECT count(*) INTO l_n
                 FROM hrau_file
                WHERE hrau01 = g_hrav[l_ac_2].hrav04
               IF l_n = 0 OR cl_null(l_n) THEN
                  CALL cl_err('',-6001,0)
                  LET g_hrav[l_ac_2].hrav04 = g_hrav_t.hrav04
                  NEXT FIELD hrav04
               END IF 
               IF g_hrav[l_ac_2].hrav05 IS NOT NULL THEN
               	 LET l_n = 0 
                  SELECT count(*) INTO l_n
                    FROM hrau_file
                   WHERE hrau01 = g_hrav[l_ac_2].hrav04
                     AND hrau02 = g_hrav[l_ac_2].hrav05
                  IF l_n = 0 OR cl_null(l_n) THEN
                     CALL cl_err('',-217,0)
                     LET g_hrav[l_ac_2].hrav04 = g_hrav_t.hrav04
                     NEXT FIELD hrav04
                  END IF  
                  SELECT hrau03,hrau04 INTO g_hrav[l_ac_2].hrau03,l_hrau04 FROM hrau_file
                   WHERE hrau01 = g_hrav[l_ac_2].hrav04
                     AND hrau02 = g_hrav[l_ac_2].hrav05 	
                  DISPLAY BY NAME g_hrav[l_ac_2].hrau03
                  IF l_hrau04 = '1' THEN
                   	 CALL cl_set_comp_required("str1",TRUE) 	
                   	 CALL cl_set_comp_entry("str1",TRUE)
                     CALL cl_set_comp_required("str2,str3",FALSE) 	
                   	 CALL cl_set_comp_entry("str2,str3",FALSE)
                   	 LET g_hrav[l_ac_2].str2 = ''
                   	 LET g_hrav[l_ac_2].str3 = ''
                  END IF
                  IF l_hrau04 = '2' THEN
                   	 CALL cl_set_comp_required("str2",TRUE) 	
                   	 CALL cl_set_comp_entry("str2",TRUE)
                     CALL cl_set_comp_required("str1,str3",FALSE) 	
                   	 CALL cl_set_comp_entry("str1,str3",FALSE)
                   	 LET g_hrav[l_ac_2].str1 = ''
                   	 LET g_hrav[l_ac_2].str3 = ''
                  END IF 	
                  IF l_hrau04 = '3' THEN
                   	 CALL cl_set_comp_required("str3",TRUE) 	
                   	 CALL cl_set_comp_entry("str3",TRUE)
                     CALL cl_set_comp_required("str1,str2",FALSE) 	
                   	 CALL cl_set_comp_entry("str1,str2",FALSE)
                   	 LET g_hrav[l_ac_2].str1 = ''
                   	 LET g_hrav[l_ac_2].str2 = ''
                  END IF	   
               END IF     
            END IF
        AFTER FIELD hrav03 
           IF NOT cl_null(g_hrav[l_ac_2].hrav03) THEN 
              SELECT hrat02 INTO g_hrav[l_ac_2].hrat02 FROM hrat_file
               WHERE hrat01 = g_hrav[l_ac_2].hrav03
             DISPLAY g_hrav[l_ac_2].hrat02 TO hrat02 
           END IF 
        AFTER FIELD hrav05                      
            IF g_hrav[l_ac_2].hrav05 IS NOT NULL AND g_hrav[l_ac_2].hrav04 IS NOT NULL THEN
            	 LET l_n = 0 
               SELECT count(*) INTO l_n
                 FROM hrau_file
                WHERE hrau01 = g_hrav[l_ac_2].hrav04
                  AND hrau02 = g_hrav[l_ac_2].hrav05
               IF l_n = 0 OR cl_null(l_n) THEN
                  CALL cl_err('',-217,0)
                  LET g_hrav[l_ac_2].hrav05 = g_hrav_t.hrav05
                  NEXT FIELD hrav05
               END IF  
               SELECT hrau03,hrau04 INTO g_hrav[l_ac_2].hrau03,l_hrau04 FROM hrau_file
                      WHERE hrau01 = g_hrav[l_ac_2].hrav04
                      AND hrau02 = g_hrav[l_ac_2].hrav05 	
                              DISPLAY BY NAME g_hrav[l_ac_2].hrau03
               LET l_sql2 = "SELECT ",g_hrav[l_ac_2].hrav05," FROM hrat_file ",
                            " WHERE hrat01 = '",g_hrav[l_ac_2].hrav03,"'"
               PREPARE hrav05_pre1 FROM l_sql2
               EXECUTE hrav05_pre1 INTO  g_hrav[l_ac_2].hrav06
               CALL i013_getName(g_hrav[l_ac_2].hrav05,g_hrav[l_ac_2].hrav06) RETURNING  g_hrav[l_ac_2].hrav06_n               
               DISPLAY BY NAME g_hrav[l_ac_2].hrav06_n
               
               IF l_hrau04 = '1' THEN
                	 CALL cl_set_comp_required("str1",TRUE) 	
                	 CALL cl_set_comp_entry("str1",TRUE)
                   CALL cl_set_comp_required("str2,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str2,str3",FALSE)
                	 NEXT FIELD str1
                END IF
                IF l_hrau04 = '2' THEN
                	 CALL cl_set_comp_required("str2",TRUE) 	
                	 CALL cl_set_comp_entry("str2",TRUE)
                   CALL cl_set_comp_required("str1,str3",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str3",FALSE)
                	 NEXT FIELD str2
                END IF 	
                IF l_hrau04 = '3' THEN
                	 CALL cl_set_comp_required("str3",TRUE) 	
                	 CALL cl_set_comp_entry("str3",TRUE)
                   CALL cl_set_comp_required("str1,str2",FALSE) 	
                	 CALL cl_set_comp_entry("str1,str2",FALSE)
                	 NEXT FIELD str3
                END IF 		   
            END IF  
        AFTER FIELD str1 
          IF NOT cl_null(g_hrav[l_ac_2].str1) THEN 
             CALL i013_getName(g_hrav[l_ac_2].hrav05,g_hrav[l_ac_2].str1) RETURNING  g_hrav[l_ac_2].hrav07_n
             DISPLAY g_hrav[l_ac_2].hrav07_n TO hrav07_n 
             IF  cl_null(g_hrav[l_ac_2].hrav07_n) THEN 
                 CALL cl_err('','!',0)
                 NEXT FIELD str1
             END IF 
          END IF 
        BEFORE DELETE                            
            IF g_hrav_t.hrav04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
#                LET l_sql = "DELETE FROM hrav_file ",
#                            " WHERE hrav04 = '",g_hrav_t.hrav04,"'", 
#                            "   AND hrav05 = '",g_hrav_t.hrav05,"'",
#                            "   AND hrav01 = '",g_hrav01,"'",
#                            "   AND hrav03 IN (SELECT hratid FROM hrat_file WHERE 1=1 )" 
                 DELETE FROM hrav_file 
                             WHERE hrav02 = g_hrav_t.hrav02 
                               AND hrav01 = g_hrav01
 
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("del","hrav_file",g_hrav01,g_hrav_t.hrav04,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrav[l_ac_2].* = g_hrav_t.*
               CLOSE i013_1_b_cur2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrav[l_ac_2].hrav04,-263,1)
               LET g_hrav[l_ac_2].* = g_hrav_t.*
            ELSE
            	  LET l_hrau04 = ''
            	  SELECT hrau04 INTO l_hrau04 FROM hrau_file
                 WHERE hrau01 = g_hrav[l_ac_2].hrav04
                   AND hrau02 = g_hrav[l_ac_2].hrav05 	
                IF l_hrau04 = '1' THEN
                   LET l_sql = "UPDATE hrav_file SET hrav04 = '",g_hrav[l_ac_2].hrav04,"',",
                                                  " hrav05 = '",g_hrav[l_ac_2].hrav05,"',",
                                                  " hrav07 = '",g_hrav[l_ac_2].str1,"',",
                                                  " hrav08 = to_date('",g_hrav[l_ac_2].hrav08,"','yy/mm/dd'),",
                                                  " hrav09 = '",g_hrav[l_ac_2].hrav09,"',",
                                                  " hravmodu = '",g_user,"',",
                                                  " hravdate = to_date('",g_today,"','yy/mm/dd') ",
                             " WHERE hrav01 = '",g_hrav01,"'",
                             "   AND hrav02 = '",g_hrav_t.hrav02,"'"
                END IF
                IF l_hrau04 = '2' THEN    
                   LET l_sql = "UPDATE hrav_file SET hrav04 = '",g_hrav[l_ac_2].hrav04,"',",
                                                  " hrav05 = '",g_hrav[l_ac_2].hrav05,"',",
                                                  " hrav07 = '",g_hrav[l_ac_2].str2,"',",
                                                  " hrav08 = to_date('",g_hrav[l_ac_2].hrav08,"','yy/mm/dd'),",
                                                  " hrav09 = '",g_hrav[l_ac_2].hrav09,"',",
                                                  " hravmodu = '",g_user,"',",
                                                  " hravdate = to_date('",g_today,"','yy/mm/dd') ",
                             " WHERE hrav01 = '",g_hrav01,"'",
                             "   AND hrav02 = '",g_hrav_t.hrav02,"'"
                END IF
                IF l_hrau04 = '3' THEN    
                   LET l_sql = "UPDATE hrav_file SET hrav04 = '",g_hrav[l_ac_2].hrav04,"',",
                                                  " hrav05 = '",g_hrav[l_ac_2].hrav05,"',",
                                                  " hrav07 = to_date('",g_hrav[l_ac_2].str3,"','yy/mm/dd'),",
                                                  " hrav08 = to_date('",g_hrav[l_ac_2].hrav08,"','yy/mm/dd'),",
                                                  " hrav09 = '",g_hrav[l_ac_2].hrav09,"',",
                                                  " hravmodu = '",g_user,"',",
                                                  " hravdate = to_date('",g_today,"','yy/mm/dd') ",
                             " WHERE hrav01 = '",g_hrav01,"'",
                             "   AND hrav02 = '",g_hrav_t.hrav02,"'"
                END IF		   
                PREPARE hav_upd FROM l_sql
                EXECUTE hav_upd
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("upd","hrav_file",g_hrav01,g_hrav_t.hrav04,SQLCA.sqlcode,"","",1)   
                   LET g_hrav[l_ac_2].* = g_hrav_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac_2 = ARR_CURR()
            LET l_ac_2_t = l_ac_2
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrav[l_ac_2].* = g_hrav_t.*
               END IF
               CLOSE i013_1_b_cur2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i013_1_b_cur2
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrav03) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrat01"
#                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_hrav[l_ac_2].hrav03 
                   DISPLAY g_hrav[l_ac_2].hrav03 TO hrav03
                   SELECT hrat02 INTO g_hrav[l_ac_2].hrat02 FROM hrat_file
                   WHERE hrat01 = g_hrav[l_ac_2].hrav03
                   DISPLAY g_hrav[l_ac_2].hrat02 TO hrat02
                   NEXT FIELD hrav03
                WHEN INFIELD(hrav04) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau01"
                   LET g_qryparam.default1 = g_hrav[l_ac_2].hrav04
                   CALL cl_create_qry() RETURNING g_hrav[l_ac_2].hrav04
                   DISPLAY g_hrav[l_ac_2].hrav04 TO hrav04  
                   NEXT FIELD hrav04
                WHEN INFIELD(hrav05) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau02"
                   LET g_qryparam.default1 = g_hrav[l_ac_2].hrav05
                   IF NOT cl_null(g_hrav[l_ac_2].hrav04) THEN
                   	  LET g_qryparam.where = " hrau01 = '",g_hrav[l_ac_2].hrav04,"' "
                   END IF	  
                   CALL cl_create_qry() RETURNING g_hrav[l_ac_2].hrav05
                   DISPLAY g_hrav[l_ac_2].hrav05 TO hrav05  
                   NEXT FIELD hrav05  
                WHEN INFIELD(str1) 
                   LET l_hrau05 = ''
                   LET l_hrau07 = ''
                   SELECT hrau05,hrau07 INTO l_hrau05,l_hrau07 FROM hrau_file
                    WHERE hrau01 = g_hrav[l_ac_2].hrav04
                      AND hrau02 = g_hrav[l_ac_2].hrav05  
                   CALL cl_init_qry_var() 
                   LET g_qryparam.form =l_hrau05
                   IF l_hrau07 IS NOT NULL THEN
                   	  LET g_qryparam.arg1 = l_hrau07
                   END IF	  
                   LET g_qryparam.default1 = g_hrav[l_ac_2].str1
                 #  LET g_qryparam.default2 = g_hrav[l_ac_2].hrav07_n
                   CALL cl_create_qry() RETURNING g_hrav[l_ac_2].str1 #,g_hrav[l_ac_2].hrav07_n
                   DISPLAY g_hrav[l_ac_2].str1 TO str1 
                   CALL i013_getName(g_hrav[l_ac_2].hrav05,g_hrav[l_ac_2].str1) RETURNING  g_hrav[l_ac_2].hrav07_n
                   DISPLAY g_hrav[l_ac_2].hrav07_n TO hrav07_n 
                   NEXT FIELD str1   
                OTHERWISE
                   EXIT CASE
            END CASE 
 
        ON ACTION CONTROLO                         
            IF INFIELD(hrav04) AND l_ac_2 > 1 THEN
                LET g_hrav[l_ac_2].* = g_hrav[l_ac_2-1].*
                DISPLAY g_hrav[l_ac_2].* TO s_hrau[l_ac_2].*
                NEXT FIELD hrav04
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
                                                                                                                                      
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")    
 
    END INPUT
    
    CLOSE i013_1_b_cur2
    COMMIT WORK
END FUNCTION

FUNCTION i013_2_ins()
DEFINE l_sql       STRING
DEFINE l_hrav      RECORD LIKE hrav_file.*
DEFINE l_hratid    LIKE hrat_file.hratid
DEFINE l_max       LIKE type_file.num5
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_hrau04    LIKE hrau_file.hrau04
DEFINE l_hrau06    LIKE hrau_file.hrau06
DEFINE l_sql2      STRING
    LET l_flag = 'Y'
    LET l_sql = "SELECT DISTINCT hratid FROM hrat_file ",
                " WHERE hrat01 = '",g_hrav[l_ac_2].hrav03,"' "
    DECLARE i013_1_hrat_curs CURSOR FROM l_sql
    FOREACH i013_1_hrat_curs INTO l_hratid
       INITIALIZE l_hrav.* TO NULL
       LET l_hrav.hrav01 = g_hrav01
       LET l_max = 1
       SELECT MAX(hrav02)+1 INTO l_max FROM hrav_file
        WHERE hrav01 = l_hrav.hrav01
       IF cl_null(l_max) THEN
          LET l_max = 1
       END IF
       LET l_hrav.hrav02 = l_max   
       LET l_hrav.hrav03 = l_hratid
       LET l_hratid = ''
       LET l_hrav.hrav04 = g_hrav[l_ac_2].hrav04
       LET l_hrav.hrav05 = g_hrav[l_ac_2].hrav05
       LET l_sql2 = "SELECT ",l_hrav.hrav05," FROM hrat_file ",
                    " WHERE hratid = '",l_hrav.hrav03,"'"
       PREPARE hrav05_pre FROM l_sql2
       EXECUTE hrav05_pre INTO l_hrav.hrav06
       LET g_hrav[l_ac_2].hrav06 = l_hrav.hrav06
       CALL i013_getName(g_hrav[l_ac_2].hrav05,g_hrav[l_ac_2].hrav06) RETURNING  g_hrav[l_ac_2].hrav06_n
       LET l_hrav.hrav06_n = g_hrav[l_ac_2].hrav06_n
       LET l_hrau04 = ''
       SELECT hrau04 INTO l_hrau04 FROM hrau_file
        WHERE hrau01 = g_hrav[l_ac_2].hrav04
          AND hrau02 = g_hrav[l_ac_2].hrav05  
       IF l_hrau04 = '1' THEN 
          LET l_hrav.hrav07 = g_hrav[l_ac_2].str1
          LET l_hrav.hrav07_n = g_hrav[l_ac_2].hrav07_n
       END IF
       IF l_hrau04 = '2' THEN 
          LET l_hrav.hrav07 = g_hrav[l_ac_2].str2
       END IF
       IF l_hrau04 = '3' THEN 
          LET l_hrav.hrav07 = g_hrav[l_ac_2].str3
       END IF   
       CALL i013_getName(g_hrav[l_ac_2].hrav05,l_hrav.hrav07) RETURNING  g_hrav[l_ac_2].hrav07_n
       LET l_hrav.hrav07_n = g_hrav[l_ac_2].hrav07_n
       LET l_hrav.hrav08 = g_hrav[l_ac_2].hrav08
       LET l_hrav.hrav09 = g_hrav[l_ac_2].hrav09
       LET l_hrav.hrav10 = 'N'
       LET l_hrav.hravoriu = g_user
       LET l_hrav.hravorig = g_grup
       LET l_hrav.hravuser = g_user
       LET l_hrav.hravgrup = g_grup
       LET l_hrav.hravdate = g_today
       INSERT INTO hrav_file VALUES(l_hrav.*)
       IF SQLCA.sqlcode THEN 
          CALL cl_err3("ins","hrau_file",l_hrav.hrav01,l_hrav.hrav02,
                            SQLCA.sqlcode,"","",1)   
          LET l_flag = 'N'   
       END IF
    END FOREACH     
    RETURN l_flag             
END FUNCTION  

FUNCTION i013_getName(p_hrav05,p_a)
DEFINE p_a,p_a_n         LIKE type_file.chr1000
DEFINE l_hrat      RECORD LIKE hrat_file.* 
DEFINE p_hrav05    LIKE hrav_file.hrav05
IF g_l = 'Y' THEN 
   SELECT hrat03 INTO l_hrat.hrat03 FROM hrat_file WHERE hrat01=g_hrav[g_cnt].hrav03
ELSE 
   SELECT hrat03 INTO l_hrat.hrat03 FROM hrat_file WHERE hrat01=g_hrav[l_ac_2].hrav03	
END IF 
IF p_hrav05 = 'hrat04' THEN
		LET l_hrat.hrat04 = p_a
		CALL i006_hrat04(l_hrat.*) RETURNING p_a_n
END IF

IF p_hrav05 = 'hrat17' THEN
		CALL s_code('333',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat20' THEN
                CALL s_code('313',p_a) RETURNING g_hrag.*
                LET p_a_n = g_hrag.hrag07
END IF
IF p_hrav05 = 'hrat58' THEN
                CALL s_code('342',p_a) RETURNING g_hrag.*
                LET p_a_n = g_hrag.hrag07
END IF
IF p_hrav05 = 'hrat21' THEN
		CALL s_code('337',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat22' THEN
		CALL s_code('317',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat24' THEN
		CALL s_code('334',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat28' THEN
		CALL s_code('302',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat29' THEN
		CALL s_code('301',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat30' THEN
                CALL s_code('321',p_a) RETURNING g_hrag.*
                LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat34' THEN
		CALL s_code('320',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat43' THEN
		CALL s_code('319',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat68' THEN
		CALL s_code('340',p_a) RETURNING g_hrag.*
		LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat73' THEN
                CALL s_code('341',p_a) RETURNING g_hrag.*
                LET p_a_n = g_hrag.hrag07
END IF

IF p_hrav05 = 'hrat05' THEN
                SELECT hrap06 INTO p_a_n from hrap_file WHERE hrap05= p_a
END IF

   RETURN  p_a_n


END FUNCTION




		
