# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: axmi410.4gl
# Descriptions...: 企劃產品結構维护作业 
# Date & Author..: FUN-A50011 10/06/21 By yangfeng
#Modify.........: No.FUN-B90105 11/09/28  By linlin 企業會制定產品結構圖,形式類型類似于bom表
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE
  g_odt01           LIKE odt_file.odt01,   
  g_odt01_t         LIKE odt_file.odt01,   
  g_odt02           LIKE odt_file.odt02,
  g_odt02_t         LIKE odt_file.odt02,
  g_odt07           LIKE odt_file.odt07,
  g_odt07_t         LIKE odt_file.odt07,
  g_odt03           LIKE odt_file.odt03,
  g_odt03_t         LIKE odt_file.odt03,
  l_cnt             LIKE type_file.num5,          
  g_odt             DYNAMIC ARRAY OF RECORD   
           odt04      LIKE odt_file.odt04,
           tqa02_b    LIKE tqa_file.tqa02,
           odt05      LIKE odt_file.odt05,
           odt06      LIKE odt_file.odt06
                    END RECORD,
  g_odt_t           RECORD   
           odt04      LIKE odt_file.odt04,
           tqa02_b    LIKE tqa_file.tqa02,
           odt05      LIKE odt_file.odt05,
           odt06      LIKE odt_file.odt06
                    END RECORD,
  g_wc,g_sql        STRING,
  g_delete          LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
  g_rec_b           LIKE type_file.num5,                #No.FUN-A50011 sMALLINT 
  l_ac              LIKE type_file.num5                 #No.FUN-A50011 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-A50011 SMALLINT 
DEFINE g_forupd_sql        STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-A50011  INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose   #No.FUN-A50011 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03            #No.FUN-A50011 CHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-A50011 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-A50011 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-A50011 INTEGER                           
DEFINE g_no_ask            LIKE type_file.num5          #No.FUN-A50011 INTEGER   
DEFINE g_odt05_count       LIKE type_file.num5          #No.FUN-B90105  ADD
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

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    INITIALIZE g_odt TO NULL                                                
    INITIALIZE g_odt_t.* TO NULL                                                

    LET g_forupd_sql = "SELECT * FROM odt_file WHERE odt01 = ? AND odt03 = ? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i410_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR                      

    OPEN WINDOW i410_w WITH FORM "axm/42f/axmi410"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL i410_menu()   
    CLOSE WINDOW i410_w     

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION i410_cs()
    CLEAR FORM
    CALL g_odt.clear()

    CALL cl_set_head_visible("","YES")        
    INITIALIZE g_odt01,g_odt02,g_odt07,g_odt03 TO NULL    
    CONSTRUCT g_wc ON odt01,odt02,odt07,odt03,odt04,odt05,odt06
         FROM odt01,odt02,odt07,odt03,s_odt[1].odt04,s_odt[1].odt05,s_odt[1].odt06
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(odt01)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="p_odt"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO odt01
              NEXT FIELD odt01        
           WHEN INFIELD(odt07)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_tqa03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO odt07
              NEXT FIELD odt07        
           WHEN INFIELD(odt03)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_odt03"   
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO odt03
              NEXT FIELD odt03         
           WHEN INFIELD(odt04)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_tqa3"
              LET g_qryparam.where = "tqa03 = '",g_odt07,"' and tqaacti = 'Y'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO odt04
              NEXT FIELD odt04         
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
  
    LET g_sql=" SELECT DISTINCT odt01,odt07,odt03 FROM odt_file ",
              " WHERE ",g_wc CLIPPED
    PREPARE i410_prepare FROM g_sql
    DECLARE i410_bcs SCROLL CURSOR WITH HOLD FOR i410_prepare
    LET g_sql=" SELECT COUNT(*) ",
              "   FROM (SELECT DISTINCT odt01,odt07,odt03 FROM odt_file WHERE ",g_wc CLIPPED,")"
    PREPARE i410_precount FROM g_sql
    DECLARE i410_count CURSOR FOR i410_precount
  
END FUNCTION

FUNCTION i410_menu()
    WHILE TRUE
      CALL i410_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i410_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i410_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i410_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i410_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i410_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_odt),'','')
            END IF 
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_odt01 IS NOT NULL THEN
                    LET g_doc.column1 = "odt01"
                    LET g_doc.value1 = g_odt01
                    CALL cl_doc()
                 END IF
              END IF
      END CASE
    END WHILE
END FUNCTION 

FUNCTION i410_a() 
    IF s_shut(0) THEN
       RETURN
    END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_odt.clear()
    INITIALIZE g_odt01,g_odt02,g_odt07,g_odt03 LIKE odt_file.odt01,odt_file.odt02,odt_file.odt07,odt_file.odt03
    LET g_odt01_t = NULL
    LET g_odt02_t = NULL 
    LET g_odt07_t = NULL
    LET g_odt03_t = NULL 
    CALL cl_opmsg('a')
  
    WHILE TRUE
        CALL i410_i("a")     
        IF INT_FLAG THEN     
           LET g_odt01 = NULL
	   LET g_odt02 = NULL
           LET g_odt07 = NULL 
	   LET g_odt03 = NULL 
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i410_b()                    
        LET g_odt01_t = g_odt01         
	LET g_odt02_t = g_odt02
        LET g_odt07_t = g_odt07
	LET g_odt03_t = g_odt03
        EXIT WHILE
    END WHILE        
END FUNCTION

FUNCTION i410_u()
    IF g_odt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_odt01_t = g_odt01
    LET g_odt02_t = g_odt02
    LET g_odt07_t = g_odt07
    LET g_odt03_t = g_odt03
    WHILE TRUE
        CALL i410_i("u")                    
        IF INT_FLAG THEN
            LET g_odt01 = g_odt01_t
	    LET g_odt02 = g_odt02_t
            LET g_odt07 = g_odt07_t
	    LET g_odt03 = g_odt03_t
            DISPLAY g_odt01,g_odt02,g_odt07,g_odt03 TO odt01,odt02,odt07,odt03        
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_odt01 != g_odt01_t OR g_odt02 != g_odt02_t OR g_odt07 != g_odt07_t OR g_odt03 != g_odt03_t THEN          
            UPDATE odt_file SET odt01 = g_odt01,odt02 = g_odt02,odt07 = g_odt07,odt03 = g_odt03
             WHERE odt01 = g_odt01_t       
	       AND odt03 = g_odt03_t
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","odt_file",g_odt01,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
             END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION 

FUNCTION i410_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-A50011 CHAR(1)
         l_n             LIKE type_file.num5,             #No.FUN-A50011 SMALLINT
         l_n2            LIKE type_file.num5,
         l_tqa02         LIKE tqa_file.tqa02
   INPUT g_odt01,g_odt02,g_odt07,g_odt03 WITHOUT DEFAULTS FROM odt01,odt02,odt07,odt03
        BEFORE INPUT
	   LET g_before_input_done = "FALSE"
	   CALL i410_set_entry(p_cmd)
	   CALL i410_set_no_entry(p_cmd)
	   LET g_before_input_done = "TRUE"
	   CALL cl_set_comp_entry("odt02",TRUE)
           LET g_odt03 = " "
        BEFORE FIELD odt01 
           CALL cl_set_comp_entry("odt01",TRUE)
        AFTER FIELD odt01
           IF g_odt01 IS NOT NULL THEN                                     
              IF p_cmd = "a" OR                                                     
                  (p_cmd = "u" AND g_odt01 != g_odt01_t) THEN  
		  SELECT count(odt01) INTO l_n FROM odt_file WHERE odt01 = g_odt01
		  IF(l_n > 0) THEN
		     CALL cl_set_comp_entry("odt02",FALSE)
		     CALL i410_odt01('d')
		     IF NOT cl_null(g_errno) THEN
		        CALL cl_err('odt01:',g_errno,1)
		        LET g_odt01 = g_odt01_t
		        DISPLAY BY NAME g_odt01
		        NEXT FIELD odt01
		     END IF
                  ELSE
                     CALL cl_set_comp_entry("odt02",TRUE)
		  END IF
	      END IF
           END IF
        AFTER FIELD odt07
           IF g_odt07 IS NOT NULL THEN
              SELECT count(tqa03) INTO l_n2 FROM tqa_file WHERE tqa03 = g_odt07
              IF l_n2 = 0 THEN 
                 CALL cl_err('','aec-016',1)
                 LET g_odt07 = NULL 
                 NEXT FIELD odt07
              END IF
        #      SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa03 = g_odt07
        #      DISPLAY l_tqa02 TO tqa02_c
           END IF
        AFTER FIELD odt03
           IF g_odt03 IS NOT NULL AND g_odt03 != " " THEN                                     
              IF p_cmd = "a" OR                                                     
                  (p_cmd = "u" AND g_odt03 != g_odt03_t) THEN  
		     CALL i410_odt03('d')
		     IF NOT cl_null(g_errno) THEN
		        CALL cl_err('odt03:',g_errno,1)
		        LET g_odt03 = g_odt03_t
		        DISPLAY BY NAME g_odt03
		        NEXT FIELD odt03
		     END IF
	      END IF
           END IF
        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(odt01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="p_odt"
                   LET g_qryparam.default1 = g_odt01
                   CALL cl_create_qry() RETURNING g_odt01 
                   DISPLAY g_odt01 TO odt01
                   NEXT FIELD odt01        
                WHEN INFIELD(odt07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_tqa03"
                   LET g_qryparam.default1 = g_odt07
                   CALL cl_create_qry() RETURNING g_odt07 
                   DISPLAY g_odt07 TO odt07
                   NEXT FIELD odt07        
                WHEN INFIELD(odt03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_odt03"
                   LET g_qryparam.default1 = g_odt03
                   LET g_qryparam.where = "odt01 = '",g_odt01,"'"
                   CALL cl_create_qry() RETURNING g_odt03 
                   DISPLAY g_odt03 TO odt03
                   NEXT FIELD odt03        
            END CASE
   
          
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


FUNCTION i410_q()
    DEFINE  l_cnt    LIKE type_file.num10               #No.FUN-A50011 INTEGER

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_odt.clear()

    CALL i410_cs()                  
    IF INT_FLAG THEN                 
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i410_bcs                   
    IF SQLCA.sqlcode THEN           
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_odt01 TO NULL
    ELSE
       OPEN i410_count                                                     
       FETCH i410_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i410_fetch('F')       
    END IF
END FUNCTION


FUNCTION i410_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1           #No.FUN-A50011 CHAR(1)

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i410_bcs INTO g_odt01,g_odt07,g_odt03
        WHEN 'P' FETCH PREVIOUS i410_bcs INTO g_odt01,g_odt07,g_odt03
        WHEN 'F' FETCH FIRST    i410_bcs INTO g_odt01,g_odt07,g_odt03
        WHEN 'L' FETCH LAST     i410_bcs INTO g_odt01,g_odt07,g_odt03
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
         FETCH ABSOLUTE g_jump i410_bcs INTO g_odt01,g_odt07,g_odt03
         LET g_no_ask = FALSE            
    END CASE

    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_odt01,SQLCA.sqlcode,0)
        INITIALIZE g_odt01,g_odt02,g_odt07,g_odt03 TO NULL 
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
    OPEN i410_count
    FETCH i410_count INTO g_row_count
    DISPLAY g_curs_index TO FORMONLY.idx
    SELECT odt02 INTO g_odt02 FROM odt_file WHERE odt01 = g_odt01 AND odt03 = g_odt03 AND odt07 = g_odt07
    {IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_odt01 = NULL 
       LET g_odt02 = NULL 
       LET g_odt07 = NULL 
       LET g_odt03 = NULL 
       RETURN
    END IF} 
    CALL i410_show()
END FUNCTION

FUNCTION i410_show()
    LET g_odt01_t = g_odt01
    LET g_odt02_t = g_odt02
    LET g_odt07_t = g_odt07
    LET g_odt03_t = g_odt03

    DISPLAY g_odt01 TO odt01 
    DISPLAY g_odt02 TO odt02
    DISPLAY g_odt07 TO odt07
    DISPLAY g_odt03 TO odt03
   
    CALL i410_odt01('d') 
    CALL i410_odt03('d') 
    CALL i410_b_fill(g_wc)                 
    CALL cl_show_fld_cont()                 
END FUNCTION

FUNCTION i410_r()
    IF s_shut(0) THEN RETURN END IF                
    IF g_odt01 IS NULL THEN 
       CALL cl_err("",-400,0)               
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   
      IF NOT cl_null(g_odt03) THEN
        DELETE FROM odt_file WHERE odt01 = g_odt01 AND odt03 = g_odt03 
      ELSE
        DELETE FROM odt_file WHERE odt01 = g_odt01
      END IF 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","odt_file",g_odt01,"",SQLCA.sqlcode,"", "BODY DELETE",1) 
        ELSE
            CLEAR FORM
            CALL g_odt.clear()
            LET g_delete='Y'
            LET g_odt01 = NULL
	    LET g_odt02 = NULL
            LET g_odt07 = NULL 
	    LET g_odt03 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i410_count                                                     
            FETCH i410_count INTO g_row_count                 
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i410_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i410_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE                       
               CALL i410_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION

FUNCTION i410_b()
    DEFINE
       l_ac_t          LIKE type_file.num5,               
       l_n             LIKE type_file.num5,             
       l_n1            LIKE type_file.num5,
       l_n2            LIKE type_file.num5,
       l_n3            LIKE type_file.num5,
       l_ac_o          LIKE type_file.num5,           
       l_rows          LIKE type_file.num5,                #No.FUN-A50011 SMALLINT
       l_success       LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
       l_str           LIKE type_file.chr20,               #No.FUN-A50011 CHAR(20)
       l_lock_sw       LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
       p_cmd           LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
       l_allow_insert  LIKE type_file.num5,                #No.FUN-A50011 SMALLINT
       l_allow_delete  LIKE type_file.num5                

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF             
    IF cl_null(g_odt01) THEN RETURN END IF


    CALL cl_opmsg('b')
    LET  g_forupd_sql = " SELECT odt04,'',odt05,odt06 ",
                        "   FROM odt_file  ",
                        "  WHERE odt01=?   ",
                        "    AND odt03=?   ",
		        "    AND odt04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i410_bcl CURSOR FROM g_forupd_sql 

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_odt WITHOUT DEFAULTS FROM s_odt.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_odt_t.* = g_odt[l_ac].*    
                OPEN i410_bcl USING g_odt01,g_odt03,g_odt_t.odt04
                IF STATUS THEN
                   CALL cl_err("OPEN i410_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i410_bcl INTO g_odt[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_odt[l_ac].odt04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                SELECT tqa02 INTO g_odt[l_ac].tqa02_b FROM tqa_file WHERE tqa01 = g_odt[l_ac].odt04 AND tqaacti='Y' AND tqa03=g_odt07   
                END IF
                CALL cl_show_fld_cont()
            END IF

    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_odt[l_ac].* TO NULL 
            LET g_odt_t.* = g_odt[l_ac].*   
            CALL cl_show_fld_cont()   
            NEXT FIELD odt04
   AFTER  FIELD odt04
      IF g_odt[l_ac].odt04 IS NOT NULL THEN 
          IF p_cmd = "a" OR
             (p_cmd = "u" AND g_odt[l_ac].odt04 != g_odt_t.odt04) THEN
                 CALL i410_odt04('d')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('g_odt[l_ac].odt04:',g_errno,1)
                    LET g_odt[l_ac].odt04 = g_odt_t.odt04
                    DISPLAY BY NAME g_odt[l_ac].odt04
                    NEXT FIELD odt04
                 END IF
          END IF
      END IF
     
      BEFORE FIELD odt05
        LET l_n2 = 100 - l_n1
     #FUN-B90105 MAK------begin----- 
     # AFTER FIELD odt05
     #   IF g_odt[l_ac].odt05 > l_n2 THEN
     #      CALL cl_err('','axm-986',1)
     #     LET g_odt[l_ac].odt05 = 0
     #     NEXT FIELD odt05
     #  END IF
     #  IF g_odt[l_ac].odt05 < 0 THEN
     #    CALL cl_err('','axm-986',1)
     #    LET g_odt[l_ac].odt05 = 0
     #    NEXT FIELD odt05
     # ELSE 
     #    LET l_n1 = l_n1 + g_odt[l_ac].odt05
     # END IF
#FUN-B90105 MAK---------end---------   
#FUN-B90105 add------begin-----
        AFTER FIELD odt05
           IF NOT cl_null(g_odt[l_ac].odt05) THEN
              IF g_odt[l_ac].odt05 < 0 THEN    
                 CALL cl_err('','axm-986',1)
                 LET g_odt[l_ac].odt05 = 0
              ELSE
                 LET g_odt05_count = 0            
                 CALL i410_odt05_count()
                 IF g_odt05_count + g_odt[l_ac].odt05 > 100 THEN   
                    CALL cl_err('','axm1102',1)
                    LET g_odt[l_ac].odt05 = 0
                    NEXT FIELD odt05
                 END IF                  
              END IF 
           END IF
#FUN-B90105 add---------end---------
   AFTER FIELD odt06
      IF g_odt[l_ac].odt06 < 0 THEN
         CALL cl_err('','aec-020',1)
         LET g_odt[l_ac].odt06 = 0
         NEXT FIELD odt06
      END IF

    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT count(*) INTO l_n3 FROM odt_file WHERE odt01 = g_odt01 AND odt03 = g_odt03 AND odt04 = g_odt[l_ac].odt04
            IF l_n3 = 0 THEN
               INSERT INTO odt_file(odt01,odt02,odt07,odt03,odt04,odt05,odt06,
                                    odtacti,odtuser,odtgrup,odtmodu,odtdate,odtorig,odtoriu)  #FUN-B90105 ADD odtmodu
                             VALUES(g_odt01,g_odt02,g_odt07,g_odt03,g_odt[l_ac].odt04,g_odt[l_ac].odt05,
                                    g_odt[l_ac].odt06,
                                    'Y',g_user,g_grup,g_user,g_today,g_grup,g_user)  #FUN-B90105 ADD g_user
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","odt_file",g_odt01,g_odt[l_ac].odt04,
                                SQLCA.sqlcode,"","",1)  
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK 
                  LET g_rec_b=g_rec_b+1
               END IF
            ELSE
               CALL cl_err("ins",-239,1)
            END IF 

        BEFORE DELETE             
            IF g_odt_t.odt04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM odt_file
                 WHERE odt01 = g_odt01 
		   AND odt03 = g_odt03
                   AND odt04 = g_odt_t.odt04 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","odt_file",g_odt_t.odt04,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK

    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_odt[l_ac].* = g_odt_t.*
               CLOSE i410_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_odt[l_ac].odt04,-263,1)
               LET g_odt[l_ac].* = g_odt_t.*
            ELSE
               UPDATE odt_file SET 
                                   odt04 = g_odt[l_ac].odt04,
                                   odt05 = g_odt[l_ac].odt05,
                                   odt06 = g_odt[l_ac].odt06,
                                   odtmodu = g_user,
				   odtdate = g_today
                WHERE odt01 = g_odt01 
		  AND odt03 = g_odt03
                  AND odt04 = g_odt_t.odt04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","odt_file",g_odt[l_ac].odt04,"",
                               SQLCA.sqlcode,"","",1)
                 LET g_odt[l_ac].* = g_odt_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF

    AFTER ROW
            LET l_ac = ARR_CURR()   #FUN-D30034 add
           #LET l_ac_t = l_ac       #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_odt[l_ac].* = g_odt_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_odt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i410_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D30034 add
            CLOSE i410_bcl
            COMMIT WORK

    ON ACTION CONTROLP
        CASE
           WHEN INFIELD(odt04)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_tqa3"
                LET g_qryparam.default1 = g_odt[l_ac].odt04
                LET g_qryparam.where = "tqa03 = '",g_odt07,"' and tqaacti = 'Y'"
                CALL cl_create_qry() RETURNING g_odt[l_ac].odt04
		DISPLAY g_odt[l_ac].odt04 TO odt04 
                NEXT FIELD odt04
        END CASE

    ON ACTION CONTROLR
        CALL cl_show_req_fields()
   
    ON ACTION CONTROLG
        CALL cl_cmdask()

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
    CLOSE i410_bcl
    COMMIT WORK
 
END FUNCTION


FUNCTION i410_b_fill(p_wc)              #BODY FILL UP
    DEFINE
        p_wc            LIKE type_file.chr1000       #No.FUN-A50011 CHAR(200)

    LET g_sql = "SELECT odt04,tqa02,odt05,odt06 ",
                "  FROM odt_file LEFT OUTER JOIN tqa_file ON odt04 = tqa_file.tqa01 AND odt07 = tqa_file.tqa03",
                " WHERE odt01 = '",g_odt01,"'",
		"   AND odt03 = '",g_odt03,"'",
                "   AND odt07 = '",g_odt07,"'",
                "   AND ",p_wc CLIPPED    
    PREPARE i410_prepare2 FROM g_sql     
   
    DECLARE odt_cs CURSOR FOR i410_prepare2
    CALL g_odt.clear()
    LET g_cnt = 1
    LET g_rec_b=0

    FOREACH odt_cs INTO g_odt[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_odt.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1     
    LET g_cnt = 0
END FUNCTION

FUNCTION i410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-A50011 CHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odt TO s_odt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i410_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            

      ON ACTION previous
         CALL i410_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY            

      ON ACTION jump 
         CALL i410_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY              

      ON ACTION next
         CALL i410_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 

      ON ACTION last 
         CALL i410_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

   {   ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
   }
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

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY

      ON ACTION related_document      
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")   

      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i410_set_entry(p_cmd)                                                  
   DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-A50011 CHAR(1)
                                                                                
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("odt01",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i410_set_no_entry(p_cmd)                                               
   DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-A50011 CHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("odt01",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION

    
FUNCTION i410_odt01(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_odt02  LIKE odt_file.odt02
   LET g_errno = ''
   SELECT DISTINCT odt02 INTO l_odt02 FROM odt_file WHERE odt01 = g_odt01 
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "axm-070"
         LET l_odt02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_odt02 = l_odt02
      DISPLAY l_odt02 TO odt02
   END IF
END FUNCTION
   
FUNCTION i410_odt03(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_tqa02  LIKE tqa_file.tqa02
   LET g_errno = ''
   SELECT tqa02 INTO l_tqa02 FROM (SELECT tqa02 FROM tqa_file WHERE tqa01 =g_odt03 AND tqaacti = 'Y') WHERE rownum=1
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "axm-070"
         LET l_tqa02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY l_tqa02  TO tqa02 
   END IF
END FUNCTION
FUNCTION i410_odt04(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   LET g_errno = ''
   SELECT tqa02 INTO g_odt[l_ac].tqa02_b FROM tqa_file WHERE tqa01 = g_odt[l_ac].odt04 AND tqaacti = 'Y' AND tqa03 = g_odt07
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "axmi-41"
         LET g_odt[l_ac].tqa02_b = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY g_odt[l_ac].tqa02_b  TO tqa02_b 
   END IF
END FUNCTION
#FUN-B90105 add------begin-----
FUNCTION i410_odt05_count()
 DEFINE l_odt05_count  LIKE odt_file.odt05 
    LET g_sql = "SELECT odt05 FROM odt_file ",
                " WHERE odt01 = '",g_odt01,"'",
                "   AND odt03 = '",g_odt03,"'",
                "   AND odt07 = '",g_odt07,"'",
                "   AND odt04 <> '",g_odt[l_ac].odt04,"'"
                            
    PREPARE i410_odt05_count_pre FROM g_sql
    DECLARE i410_odt05_count_cs CURSOR FOR i410_odt05_count_pre
    FOREACH i410_odt05_count_cs INTO l_odt05_count
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_odt05_count = g_odt05_count + l_odt05_count
    END FOREACH 
END FUNCTION
#FUN-B90105 add------end-----
#FUN-A50011
