# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri111.4gl
# Descriptions...: 
# Date & Author..: 13/04/15 By Yougs 
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
 
DEFINE g_hrau01         LIKE hrau_file.hrau01      
DEFINE g_hrau01_t       LIKE hrau_file.hrau01,   
    g_hrau           DYNAMIC ARRAY OF RECORD 
        hrau02       LIKE hrau_file.hrau02,    
        hrau03       LIKE hrau_file.hrau03,
        hrau04       LIKE hrau_file.hrau04,
        hrau05       LIKE hrau_file.hrau05,   
        hrau06       LIKE hrau_file.hrau06,   
        hrau07       LIKE hrau_file.hrau07,   
        hrau08       LIKE hrau_file.hrau08 
                    END RECORD,             
    g_hrau_t         RECORD                  
        hrau02       LIKE hrau_file.hrau02,    
        hrau03       LIKE hrau_file.hrau03,
        hrau04       LIKE hrau_file.hrau04,
        hrau05       LIKE hrau_file.hrau05,   
        hrau06       LIKE hrau_file.hrau06,   
        hrau07       LIKE hrau_file.hrau07,   
        hrau08       LIKE hrau_file.hrau08 
                    END RECORD,             
    g_hrau_o         RECORD                  
        hrau02       LIKE hrau_file.hrau02,    
        hrau03       LIKE hrau_file.hrau03,
        hrau04       LIKE hrau_file.hrau04,
        hrau05       LIKE hrau_file.hrau05,   
        hrau06       LIKE hrau_file.hrau06,   
        hrau07       LIKE hrau_file.hrau07,   
        hrau08       LIKE hrau_file.hrau08    
                    END RECORD,             
    g_argv1         LIKE hrau_file.hrau01,      
    g_rec_b         LIKE type_file.num5,     
    g_wc,g_sql      string,                 
    g_ss            LIKE type_file.chr1,    
    g_s             LIKE type_file.chr1,    
    g_rec           LIKE type_file.num5,    
    l_ac            LIKE type_file.num5     
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
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
   LET g_hrau01 = NULL                  
   LET g_hrau01_t = NULL 

   OPEN WINDOW i111_w WITH FORM "ghr/42f/ghri111"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init() 
 
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL i111_q()
   END IF

   CALL i111_menu()
   CLOSE WINDOW i111_w                 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 

FUNCTION i111_curs()
    CLEAR FORM                            
    CALL g_hrau.clear()
    IF g_argv1 IS NULL OR  g_argv1 = ' ' THEN 
       INITIALIZE g_hrau01 TO NULL
       CALL cl_set_head_visible("","YES")  
       CONSTRUCT g_wc ON hrau01,hrau02,hrau03,hrau04,hrau05,hrau06,hrau07,hrau08    
            FROM hrau01,s_hrau[1].hrau02,s_hrau[1].hrau03,s_hrau[1].hrau04,s_hrau[1].hrau05,s_hrau[1].hrau06,
                 s_hrau[1].hrau07,s_hrau[1].hrau08
         BEFORE CONSTRUCT
            CALL cl_qbe_init() 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrau01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau01"
                   LET g_qryparam.state= "c" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret  
                   DISPLAY g_qryparam.multiret TO hrau01
                   NEXT FIELD hrau01
                WHEN INFIELD(hrau02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau02"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO hrau02
                   NEXT FIELD hrau02
                WHEN INFIELD(hrau05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrau05"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO hrau05         
                   NEXT FIELD hrau05          
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
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrauuser', 'hraugrup')
 
        IF INT_FLAG THEN RETURN END IF  
    ELSE  
       LET g_wc = " hrau01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE hrau01 FROM hrau_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i111_prepare FROM g_sql      
    DECLARE i111_b_curs                  
        SCROLL CURSOR WITH HOLD FOR i111_prepare
    LET g_sql="SELECT COUNT(DISTINCT hrau01)",
              "  FROM hrau_file WHERE ",g_wc CLIPPED
    PREPARE i111_precount FROM g_sql
    DECLARE i111_count CURSOR FOR i111_precount
END FUNCTION
 
FUNCTION i111_menu()
 
   WHILE TRUE
      CALL i111_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i111_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i111_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i111_u()
            END IF 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i111_b() 
            END IF
            LET g_action_choice = "" 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i111_r()
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrau),'','')
            END IF 
         WHEN "related_document"                        
            IF cl_chk_act_auth() THEN                 
                IF g_hrau01 IS NOT NULL THEN             
                   LET g_doc.column1 = "hrau01"       
                   LET g_doc.value1 = g_hrau01      
                   CALL cl_doc()                  
                END IF                           
            END IF                              
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i111_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_hrau.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_hrau01 LIKE hrau_file.hrau01
    LET g_hrau01_t = NULL 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i111_i("a")                
        IF INT_FLAG THEN                   
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0                    
        IF g_ss='N' THEN
           CALL g_hrau.clear() 
        ELSE
           CALL i111_b_fill('1=1')          
        END IF
        CALL i111_b()                    
        LET g_hrau01_t = g_hrau01              
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i111_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_hrau01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_chkey matches'[Nn]' THEN  RETURN END IF     
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_hrau01_t = g_hrau01
    BEGIN WORK      
    WHILE TRUE
        CALL i111_i("u")                     
        IF INT_FLAG THEN
            LET g_hrau01=g_hrau01_t
            DISPLAY g_hrau01 TO hrau01               
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_hrau01 != g_hrau01_t THEN              
            UPDATE hrau_file SET hrau01 = g_hrau01   
                WHERE hrau01 = g_hrau01_t         
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("upd","hrau_file",g_hrau01_t,"",SQLCA.sqlcode,"","",1)   
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i111_i(p_cmd)
DEFINE l_count      LIKE type_file.num5
DEFINE p_cmd           LIKE type_file.chr1   
DEFINE l_fname      LIKE gat_file.gat03               
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")
    INPUT g_hrau01 WITHOUT DEFAULTS FROM hrau01 
        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL i111_set_entry(p_cmd)
             CALL i111_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE 
        BEFORE FIELD hrau01
            IF p_cmd = 'a' AND g_argv1 IS NOT NULL AND g_argv1 != ' '
               THEN  LET g_hrau01 = g_argv1 
                     DISPLAY BY NAME g_hrau01
            END IF
          
        AFTER FIELD hrau01                  
            IF NOT cl_null(g_hrau01) THEN
            	 LET l_count = 0
            	 SELECT count(zta01) into l_count from zta_file WHERE zta01 = g_hrau01
            	 IF l_count = 0 OR cl_null(l_count) THEN
            	 	  CALL cl_err(g_hrau01,-6001,0)
            	 	  NEXT FIELD hrau01
            	 END IF	  
               IF g_hrau01 != g_hrau01_t OR g_hrau01_t IS NULL THEN
                   SELECT UNIQUE hrau01 INTO g_chr
                       FROM hrau_file
                       WHERE hrau01=g_hrau01
                   IF SQLCA.sqlcode THEN            
                       IF p_cmd='a' THEN
                           LET g_ss='N'
                       END IF
                   ELSE
                       IF p_cmd='u' THEN
                           CALL cl_err(g_hrau01,-239,0)
                           LET g_hrau01=g_hrau01_t
                           NEXT FIELD hrau01
                       END IF
                   END IF
               END IF
               SELECT gat03 INTO l_fname FROM gat_file WHERE gat01=g_hrau01 AND gat02='2'    #add by zhangbo130830
               DISPLAY l_fname TO fname       #add by zhangbo130830 
            END IF
 
        ON ACTION CONTROLF                   
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrau01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_zta01" 
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1 = g_hrau01
                   LET g_qryparam.where = " zta01 LIKE 'hrat%' "      #add by zhangbo130830
                   CALL cl_create_qry() RETURNING g_hrau01   
                   DISPLAY g_hrau01 TO hrau01
                   NEXT FIELD hrau01
                OTHERWISE
                   EXIT CASE
            END CASE 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
           CALL cl_cmdask() 
    END INPUT
END FUNCTION
 
FUNCTION i111_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL g_hrau.clear()                     
    CALL i111_curs()                    
    IF INT_FLAG THEN                       
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i111_b_curs                     
    IF SQLCA.sqlcode AND (g_argv1 IS NULL OR g_argv1=' ') THEN                          
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_hrau01 TO NULL
    ELSE
        OPEN i111_count
        FETCH i111_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i111_fetch('F')             
    END IF
END FUNCTION
  
FUNCTION i111_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                   
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i111_b_curs INTO g_hrau01
        WHEN 'P' FETCH PREVIOUS i111_b_curs INTO g_hrau01
        WHEN 'F' FETCH FIRST    i111_b_curs INTO g_hrau01
        WHEN 'L' FETCH LAST     i111_b_curs INTO g_hrau01
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
            FETCH ABSOLUTE g_jump i111_b_curs INTO g_hrau01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_hrau01,SQLCA.sqlcode,0)
        INITIALIZE g_hrau01 TO NULL  
    ELSE
       CALL i111_show()
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
  
FUNCTION i111_show()
DEFINE l_fname   LIKE   gat_file.gat03     #add by zhangbo130830
    SELECT gat03 INTO l_fname FROM gat_file WHERE gat01=g_hrau01 AND gat02='2'   #add by zhangbo130830
    DISPLAY g_hrau01 TO hrau01                   
    DISPLAY l_fname TO fname     #add by zhangbo130830
    CALL i111_b_fill(g_wc)                    
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i111_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_hrau01 IS NULL THEN
        RETURN
    END IF
    IF cl_delh(0,0) THEN                    
        INITIALIZE g_doc.* TO NULL                                    
        LET g_doc.column1 = "hrau01"                                  
        LET g_doc.value1 = g_hrau01                                   
        CALL cl_del_doc()                                             
        BEGIN WORK
        DELETE FROM hrau_file WHERE hrau01 = g_hrau01
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("del","hrau_file",g_hrau01,"",SQLCA.sqlcode,"","BODY DELETE:",1)    
        ELSE
            COMMIT WORK
            CLEAR FORM
            CALL g_hrau.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i111_count 
            IF STATUS THEN
               CLOSE i111_b_curs
               CLOSE i111_count
               COMMIT WORK
               RETURN
            END IF 
            FETCH i111_count INTO g_row_count 
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i111_b_curs
               CLOSE i111_count
               COMMIT WORK
               RETURN
            END IF 
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i111_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i111_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL i111_fetch('/')
            END IF
        END IF
    END IF
END FUNCTION
 
FUNCTION i111_b()
DEFINE   li_inx     LIKE type_file.num5                                                 
DEFINE   ls_str     STRING                                                              
DEFINE
    l_ac_t          LIKE type_file.num5,                                                      
    l_n             LIKE type_file.num5,                                                      
    l_lock_sw       LIKE type_file.chr1,                                                      
    p_cmd           LIKE type_file.chr1,                                                      
    l_allow_insert  LIKE type_file.num5,                                                      
    l_allow_delete  LIKE type_file.num5                                                       
 
    LET g_action_choice = ""
 
    IF g_hrau01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT hrau02,hrau03,hrau04,hrau05,hrau06,hrau07,hrau08 FROM hrau_file WHERE hrau01 = ? AND hrau02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i111_b_curl CURSOR FROM g_forupd_sql       
 
    LET l_ac_t = 0  
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_hrau WITHOUT DEFAULTS FROM s_hrau.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'             
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_hrau_t.* = g_hrau[l_ac].*   
                OPEN i111_b_curl USING g_hrau01,g_hrau_t.hrau02
                IF STATUS THEN
                   CALL cl_err("OPEN i111_b_curl:", STATUS, 1)
                   CLOSE i111_b_curl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i111_b_curl INTO g_hrau[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrau_t.hrau02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_hrau_t.*=g_hrau[l_ac].*
                       LET g_hrau_o.*=g_hrau[l_ac].*
                   END IF
                END IF
                IF NOT cl_null(g_hrau[l_ac].hrau04) THEN
                  IF g_hrau[l_ac].hrau04 = '1' THEN
                     CALL cl_set_comp_entry("hrau05",TRUE)  
                     CALL cl_set_comp_required("hrau05",TRUE) 
                     LET l_n = 0
                     SELECT instr(gab02,'arg1') INTO l_n FROM gab_file
                      WHERE gab01 = g_hrau[l_ac].hrau05  
                     IF l_n > 0 THEN
                        CALL cl_set_comp_entry("hrau06,hrau07",TRUE)  
                        CALL cl_set_comp_required("hrau06,hrau07",TRUE)
                     ELSE
                         CALL cl_set_comp_entry("hrau06,hrau07",FALSE)    
                        CALL cl_set_comp_required("hrau06,hrau07",FALSE)
                     END IF       
                  ELSE
                     CALL cl_set_comp_entry("hrau05,hrau06,hrau07",FALSE)   
                     CALL cl_set_comp_required("hrau05,hrau06,hrau07",FALSE)
                     LET g_hrau[l_ac].hrau05 = ''
                     LET g_hrau[l_ac].hrau06 = ''
                     LET g_hrau[l_ac].hrau07 = ''
                  END IF
                END IF      
                CALL cl_show_fld_cont()    
            END IF 
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO hrau_file(hrau01,hrau02,hrau03,hrau04,hrau05,hrau06,hrau07,hrau08,hrauuser,hraugrup,hrauoriu,hrauorig,hraudate)
                VALUES(g_hrau01,g_hrau[l_ac].hrau02,g_hrau[l_ac].hrau03,g_hrau[l_ac].hrau04,g_hrau[l_ac].hrau05,g_hrau[l_ac].hrau06,
                       g_hrau[l_ac].hrau07,g_hrau[l_ac].hrau08,g_user,g_grup,g_user,g_grup,g_today)
           IF SQLCA.sqlcode THEN 
              CALL cl_err3("ins","hrau_file",g_hrau01,g_hrau[l_ac].hrau02,
                            SQLCA.sqlcode,"","",1)   
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
              DISPLAY g_rec TO FORMONLY.cn2
           END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrau[l_ac].* TO NULL      
            LET g_hrau_t.* = g_hrau[l_ac].*         
            LET g_hrau_o.* = g_hrau[l_ac].*         
            LET g_hrau[l_ac].hrau04 = '1' 
            LET g_hrau[l_ac].hrau06 = 'N' 
            CALL cl_set_comp_required("hrau05",TRUE)
            CALL cl_set_comp_entry("hrau05",TRUE)
            CALL cl_set_comp_entry("hrau07",FALSE)
            CALL cl_set_comp_entry("hrau07",FALSE)
            CALL cl_show_fld_cont()    
            NEXT FIELD hrau02
 
        AFTER FIELD hrau02                        
            IF g_hrau[l_ac].hrau02 IS NOT NULL THEN
               IF (g_hrau[l_ac].hrau02 != g_hrau_t.hrau02 OR g_hrau_t.hrau02 IS NULL) THEN
                 LET l_n = 0
                  SELECT count(*) INTO l_n
                    FROM hrau_file
                   WHERE hrau01 = g_hrau01
                     AND hrau02 = g_hrau[l_ac].hrau02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_hrau[l_ac].hrau02 = g_hrau_t.hrau02
                     NEXT FIELD hrau02
                  END IF
                  SELECT gaq03 INTO g_hrau[l_ac].hrau03 FROM gaq_file
                   WHERE gaq01 = g_hrau[l_ac].hrau02
                     AND gaq02 = g_lang
                  DISPLAY  BY NAME g_hrau[l_ac].hrau03  
               END IF
            END IF
        AFTER FIELD hrau04
            IF NOT cl_null(g_hrau[l_ac].hrau04) THEN
              IF g_hrau[l_ac].hrau04 = '1' THEN
                 CALL cl_set_comp_entry("hrau05",TRUE)  
                 CALL cl_set_comp_required("hrau05",TRUE) 
                 IF NOT cl_null(g_hrau[l_ac].hrau05) THEN 
                    LET l_n = 0
                    SELECT instr(gab02,'arg1') INTO l_n FROM gab_file
                     WHERE gab01 = g_hrau[l_ac].hrau05  
                    IF l_n > 0 THEN
                       LET g_hrau[l_ac].hrau06 = 'Y'  
                       CALL cl_set_comp_required("hrau07",TRUE)
                       CALL cl_set_comp_entry("hrau07",TRUE) 
                    ELSE
                       LET g_hrau[l_ac].hrau06 = 'N'
                       CALL cl_set_comp_required("hrau07",FALSE)
                       CALL cl_set_comp_entry("hrau07",FALSE)   
                    END IF        
                    DISPLAY BY NAME g_hrau[l_ac].hrau06,g_hrau[l_ac].hrau07 
                  END IF
              ELSE
                 CALL cl_set_comp_required("hrau05,hrau07",FALSE)
                 CALL cl_set_comp_entry("hrau05,hrau07",FALSE)   
                 LET g_hrau[l_ac].hrau05 = ''
                 LET g_hrau[l_ac].hrau06 = ''
                 LET g_hrau[l_ac].hrau07 = ''
              END IF
            END IF           
  
        BEFORE FIELD hrau05
             IF NOT cl_null(g_hrau[l_ac].hrau04) THEN
              IF g_hrau[l_ac].hrau04 = '1' THEN
                 CALL cl_set_comp_required("hrau05",TRUE) 
                 CALL cl_set_comp_entry("hrau05",TRUE)  
              ELSE
                 CALL cl_set_comp_required("hrau05,hrau07",FALSE) 
                 CALL cl_set_comp_entry("hrau05,hrau07",FALSE)  
                 LET g_hrau[l_ac].hrau05 = ''
                 LET g_hrau[l_ac].hrau06 = ''
                 LET g_hrau[l_ac].hrau07 = ''
              END IF
            END IF  
                    
        AFTER FIELD hrau05
            IF NOT cl_null(g_hrau[l_ac].hrau05) AND g_hrau[l_ac].hrau04 = '1' THEN
              LET l_n = 0
              SELECT count(*) INTO l_n FROM gab_file,gac_file
               WHERE gab01 = g_hrau[l_ac].hrau05 
                 AND gab01 = gac01
              IF l_n = 0 OR cl_null(l_n) THEN
                 CALL cl_err(g_hrau[l_ac].hrau05,'ask-016',0)
                 NEXT FIELD hrau05 
              END IF
              LET l_n = 0
              SELECT instr(gab02,'arg1') INTO l_n FROM gab_file
               WHERE gab01 = g_hrau[l_ac].hrau05  
              IF l_n > 0 THEN
                 LET g_hrau[l_ac].hrau06 = 'Y'  
                 CALL cl_set_comp_required("hrau07",TRUE)
                 CALL cl_set_comp_entry("hrau07",TRUE) 
              ELSE
                 LET g_hrau[l_ac].hrau06 = 'N'
                 CALL cl_set_comp_required("hrau07",FALSE)
                 CALL cl_set_comp_entry("hrau07",FALSE)   
              END IF        
              DISPLAY BY NAME g_hrau[l_ac].hrau06,g_hrau[l_ac].hrau07 
            END IF
              
        BEFORE DELETE                             
            IF g_hrau_t.hrau02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM hrau_file
                 WHERE hrau01 = g_hrau01 
                   AND hrau02 = g_hrau_t.hrau02
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("del","hrau_file",g_hrau01,g_hrau_t.hrau02,
                                 SQLCA.sqlcode,"","",1)  
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec=g_rec-1
                DISPLAY g_rec TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrau[l_ac].* = g_hrau_t.*
               CLOSE i111_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrau[l_ac].hrau02,-263,1)
               LET g_hrau[l_ac].* = g_hrau_t.*
            ELSE
                UPDATE hrau_file SET hrau02=g_hrau[l_ac].hrau02,
                                     hrau03=g_hrau[l_ac].hrau03,
                                     hrau04=g_hrau[l_ac].hrau04,
                                     hrau05=g_hrau[l_ac].hrau05,
                                     hrau06=g_hrau[l_ac].hrau06,
                                     hrau07=g_hrau[l_ac].hrau07,
                                     hrau08=g_hrau[l_ac].hrau08,
                                     hraumodu = g_user,
                                     hraudate = g_today
                WHERE hrau01 = g_hrau01 AND hrau02=g_hrau_t.hrau02
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("upd","hrau_file",g_hrau01,g_hrau_t.hrau02,SQLCA.sqlcode,"","",1)
                   LET g_hrau[l_ac].* = g_hrau_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrau[l_ac].* = g_hrau_t.*
               END IF
               CLOSE i111_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i111_b_curl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrau02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gaq" 
                   LET ls_str = g_hrau01
                   LET li_inx = ls_str.getIndexOf("_file",1)
                   IF li_inx >= 1 THEN
                      LET ls_str = ls_str.subString(1,li_inx - 1)
                   ELSE
                      LET ls_str = ""
                   END IF
                   LET g_qryparam.arg2 = ls_str              
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1 = g_hrau[l_ac].hrau02
                   CALL cl_create_qry() RETURNING g_hrau[l_ac].hrau02
                   DISPLAY BY NAME g_hrau[l_ac].hrau02
                   SELECT gaq03 INTO g_hrau[l_ac].hrau03 FROM gaq_file WHERE gaq02 = g_lang and gaq01 = g_hrau[l_ac].hrau02
                   DISPLAY BY NAME g_hrau[l_ac].hrau03
                   NEXT FIELD hrau02
                WHEN INFIELD(hrau05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gab"
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.where = " gab01 LIKE '%hr%' "     #add by zhangbo130830
                   LET g_qryparam.default1 = g_hrau[l_ac].hrau05
                   CALL cl_create_qry() RETURNING g_hrau[l_ac].hrau05
                   DISPLAY g_hrau[l_ac].hrau05 TO hrau05
                   NEXT FIELD hrau05                   
                OTHERWISE
                   EXIT CASE
            END CASE 
             
        ON ACTION CONTROLO                        
            IF INFIELD(hrau02) AND l_ac > 1 THEN
                LET g_hrau[l_ac].* = g_hrau[l_ac-1].*
                DISPLAY g_hrau[l_ac].* TO s_hrau[l_ac].*
                NEXT FIELD hrau02
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
 
    CLOSE i111_b_curl
    COMMIT WORK
END FUNCTION
  
FUNCTION i111_b_fill(p_wc)              
DEFINE
    p_wc            LIKE type_file.chr1000  
 
    LET g_sql =
       "SELECT hrau02,hrau03,hrau04,hrau05,hrau06,hrau07,hrau08 ",
       " FROM hrau_file ",
       " WHERE hrau01 = '",g_hrau01,"' ",
         " AND ",p_wc CLIPPED ,
       " ORDER BY hrau02 "
    PREPARE i111_prepare2 FROM g_sql       
    DECLARE hrau_curs CURSOR FOR i111_prepare2
    CALL g_hrau.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH hrau_curs INTO g_hrau[g_cnt].*    
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1

       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_hrau.deleteElement(g_cnt)
    LET g_rec = g_cnt - 1
    DISPLAY g_rec TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrau TO s_hrau.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i111_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY   
 
 
      ON ACTION previous
         CALL i111_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY   
 
 
      ON ACTION jump
         CALL i111_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY   
 
 
      ON ACTION next
         CALL i111_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   
 
 
      ON ACTION last
         CALL i111_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                    
  
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY 
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
FUNCTION i111_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("hrau01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i111_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("hrau01",FALSE)
   END IF
END FUNCTION 
