# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: aooi004.4gl
# Descriptions...: 
# Date & Author..: 2016-08-29 9:44:15 shenran

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_tc_auth_h       RECORD
           tc_auth01     LIKE tc_auth_file.tc_auth01,    
           zx02          LIKE zx_file.zx02
           END RECORD,
       g_tc_auth_h_t       RECORD
           tc_auth01     LIKE tc_auth_file.tc_auth01,    
           zx02          LIKE zx_file.zx02
           END RECORD,         
       g_tc_auth         DYNAMIC ARRAY OF RECORD 
           tc_auth02     LIKE tc_auth_file.tc_auth02,    
           tc_auth03     LIKE tc_auth_file.tc_auth03,    
           tc_auth04     LIKE tc_auth_file.tc_auth04    
           END RECORD,
       g_tc_auth_t       RECORD
           tc_auth02     LIKE tc_auth_file.tc_auth02,    
           tc_auth03     LIKE tc_auth_file.tc_auth03,    
           tc_auth04     LIKE tc_auth_file.tc_auth04                     
           END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,                     
       g_wc2         STRING,                    
       g_rec_b       LIKE type_file.num5,      
       l_ac          LIKE type_file.num5
DEFINE g_tc_auth_lock   RECORD LIKE tc_auth_file.*             
DEFINE g_forupd_sql        STRING               
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5  
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING

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
 
   OPEN WINDOW i004_w WITH FORM "aoo/42f/aooi004"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   LET g_forupd_sql =" SELECT * FROM tc_auth_file ",
                      "  WHERE tc_auth01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i004_lock_u CURSOR FROM g_forupd_sql
      
   CALL cl_ui_init() 
   CALL i004_menu()
   CLOSE WINDOW i004_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i004_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
DEFINE l_c         LIKE tc_auth_file.tc_auth02
   CLEAR FORM 
   CALL g_tc_auth.clear()
   CALL cl_set_head_visible("","YES")    
   INITIALIZE g_tc_auth_h.* TO NULL     
   CONSTRUCT BY NAME g_wc ON tc_auth01,zx02
      BEFORE CONSTRUCT
         CALL cl_qbe_init()  
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_auth01)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_zx"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_auth01 
               NEXT FIELD tc_auth01
                  
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
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF

   CONSTRUCT g_wc2 ON tc_auth02,tc_auth03,tc_auth04
           FROM s_tc_auth[1].tc_auth02,s_tc_auth[1].tc_auth03,s_tc_auth[1].tc_auth04
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)  
         
      ON ACTION CONTROLP   #

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION about     
         CALL cl_about() 
      ON ACTION help    
         CALL cl_show_help()
      ON ACTION controlg   
         CALL cl_cmdask() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT DISTINCT tc_auth01,zx02 FROM tc_auth_file,zx_file ",
               " WHERE tc_auth01=zx01",
               "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED, 
               " ORDER BY tc_auth01"
   PREPARE i004_prepare FROM g_sql
   DECLARE i004_cs SCROLL CURSOR WITH HOLD FOR i004_prepare 
   LET g_sql="SELECT COUNT(DISTINCT tc_auth01) FROM tc_auth_file,zx_file",
             " WHERE tc_auth01=zx01",
             "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   PREPARE i004_precount FROM g_sql
   DECLARE i004_count CURSOR FOR i004_precount
END FUNCTION
	
FUNCTION i004_menu()
   WHILE TRUE
      CALL i004_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i004_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i004_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i004_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_auth TO s_tc_auth.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL i004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
      ON ACTION jump
         CALL i004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
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
         LET g_action_choice="detail"
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
      AFTER DISPLAY
         CONTINUE DISPLAY
      #&include "qry_string.4gl" 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i004_a()
DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE ls_doc      STRING
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_auth.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_tc_auth_h.*  TO NULL      
   WHILE TRUE
      CALL i004_i("a")      
      IF INT_FLAG THEN     
         INITIALIZE g_tc_auth_h.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_tc_auth_h.tc_auth01) THEN 
         CONTINUE WHILE
      END IF
      LET g_rec_b = 0
      CALL i004_b_fill(' 1=1') 
      CALL i004_b() 
      EXIT WHILE
   END WHILE
END FUNCTION
	
FUNCTION i004_u()

   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_tc_auth_h.tc_auth01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_auth_h_t.*=g_tc_auth_h.*
   
   BEGIN WORK
   OPEN i004_lock_u USING g_tc_auth_h.tc_auth01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i004_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i004_lock_u INTO g_tc_auth_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gae01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i004_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i004_i("u")
      IF INT_FLAG THEN
         LET g_tc_auth_h.*=g_tc_auth_h_t.*
         DISPLAY BY NAME g_tc_auth_h.tc_auth01,g_tc_auth_h.zx02
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE tc_auth_file SET tc_auth01 = g_tc_auth_h.tc_auth01
       WHERE tc_auth01 = g_tc_auth_h_t.tc_auth01
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("upd","tc_auth_file",g_tc_auth_h_t.tc_auth01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      SELECT zx02 INTO g_tc_auth_h.zx02 FROM zx_file WHERE zx01=g_tc_auth_h.tc_auth01
      DISPLAY BY NAME g_tc_auth_h.zx02
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION	
 
FUNCTION i004_i(p_cmd)
DEFINE  p_cmd          LIKE type_file.chr1
DEFINE  l_num          LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
   DISPLAY BY NAME g_tc_auth_h.tc_auth01,g_tc_auth_h.zx02     
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_tc_auth_h.tc_auth01,g_tc_auth_h.zx02
      WITHOUT DEFAULTS 
      
      AFTER FIELD tc_auth01
         IF NOT cl_null(g_tc_auth_h.tc_auth01) THEN
         	  IF g_tc_auth_h.tc_auth01 != g_tc_auth_h_t.tc_auth01 OR
         	  	 g_tc_auth_h_t.tc_auth01 IS NULL THEN 
               LET l_num = 0        
               SELECT COUNT(*) INTO l_num FROM tc_auth_file WHERE tc_auth01 = g_tc_auth_h.tc_auth01
               IF l_num>0 THEN
               	  CALL cl_err(g_tc_auth_h.tc_auth01,-239,0)
               	  NEXT FIELD tc_auth01
               END IF
               LET l_num = 0 
               SELECT COUNT(*) INTO l_num FROM zx_file WHERE zx01 = g_tc_auth_h.tc_auth01
               IF l_num<=0 THEN
               	  CALL cl_err('用户不存在于p_zx','!',0)
               	  NEXT FIELD tc_auth01
               END IF
               SELECT zx02 INTO g_tc_auth_h.zx02 FROM zx_file WHERE zx01=g_tc_auth_h.tc_auth01
               DISPLAY BY NAME g_tc_auth_h.zx02
            END IF
         END IF         	
      
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_auth01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"
               LET g_qryparam.default1 = g_tc_auth_h.tc_auth01
               CALL cl_create_qry() RETURNING g_tc_auth_h.tc_auth01 
               DISPLAY BY NAME g_tc_auth_h.tc_auth01
               NEXT FIELD tc_auth01
                
            OTHERWISE EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about   
         CALL cl_about() 
      ON ACTION help    
         CALL cl_show_help()
   END INPUT
END FUNCTION	

FUNCTION i004_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gae   RECORD LIKE gae_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_tc_auth_h.tc_auth01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM tc_auth_file
       WHERE tc_auth01 = g_tc_auth_h.tc_auth01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tc_auth_file",g_tc_auth_h.tc_auth01,'',SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_tc_auth.clear()
         OPEN i004_count
         FETCH i004_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i004_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i004_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL i004_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
	
FUNCTION i004_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_auth.clear()
   CALL i004_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tc_auth_h.* TO NULL
      RETURN
   END IF
   OPEN i004_cs      
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_auth_h.* TO NULL
   ELSE
      OPEN i004_count
      FETCH i004_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i004_fetch('F')             
   END IF
END FUNCTION
 
FUNCTION i004_fetch(p_flag)
DEFINE  p_flag        LIKE type_file.chr1 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i004_cs INTO g_tc_auth_h.tc_auth01
      WHEN 'P' FETCH PREVIOUS i004_cs INTO g_tc_auth_h.tc_auth01 
      WHEN 'F' FETCH FIRST    i004_cs INTO g_tc_auth_h.tc_auth01
      WHEN 'L' FETCH LAST     i004_cs INTO g_tc_auth_h.tc_auth01
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
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
      FETCH ABSOLUTE g_jump i004_cs INTO g_tc_auth_h.tc_auth01
      LET g_no_ask = FALSE 
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_auth_h.tc_auth01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_auth_h.* TO NULL     
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
      DISPLAY g_curs_index TO FORMONLY.idx        
   END IF
   DISPLAY BY NAME g_tc_auth_h.tc_auth01
   SELECT zx02 INTO g_tc_auth_h.zx02 FROM zx_file WHERE zx01 = g_tc_auth_h.tc_auth01 
   DISPLAY BY NAME g_tc_auth_h.zx02
   CALL i004_b_fill(g_wc2)
END FUNCTION
	
FUNCTION i004_b()
DEFINE     l_ac_t          LIKE type_file.num5,     
           l_n             LIKE type_file.num5,    
           l_cnt           LIKE type_file.num5,   
           l_lock_sw       LIKE type_file.chr1,  
           p_cmd           LIKE type_file.chr1, 
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5
DEFINE     l_i             LIKE type_file.num5
DEFINE     l_c             LIKE tc_auth_file.tc_auth02
           
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_tc_auth_h.tc_auth01) THEN
      RETURN
   END IF
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT tc_auth02,tc_auth03,tc_auth04",
                      "  FROM tc_auth_file",
                      "  WHERE tc_auth01 =? AND tc_auth02 = ?  AND tc_auth03 = ?",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i004_bcl CURSOR FROM g_forupd_sql
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_tc_auth WITHOUT DEFAULTS FROM s_tc_auth.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
      BEFORE INPUT
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'     
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_tc_auth_t.* = g_tc_auth[l_ac].*
            OPEN i004_bcl USING g_tc_auth_h.tc_auth01,g_tc_auth_t.tc_auth02,g_tc_auth_t.tc_auth03
            IF STATUS THEN
               CALL cl_err("OPEN i004_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i004_bcl INTO g_tc_auth[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_auth_t.tc_auth02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF 
         END IF
         	
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tc_auth[l_ac].* TO NULL
         LET g_tc_auth_t.* = g_tc_auth[l_ac].*  
         CALL cl_show_fld_cont()        
         NEXT FIELD tc_auth02
         
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tc_auth_file(tc_auth01,tc_auth02,tc_auth03,tc_auth04)
                        VALUES(g_tc_auth_h.tc_auth01,g_tc_auth[l_ac].tc_auth02,
                               g_tc_auth[l_ac].tc_auth03,g_tc_auth[l_ac].tc_auth04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_auth_file",g_tc_auth_h.tc_auth01,g_tc_auth[l_ac].tc_auth02,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         ON CHANGE tc_auth02
             IF NOT cl_null(g_tc_auth[l_ac].tc_auth02) THEN
             	   LET g_tc_auth[l_ac].tc_auth03=''
             	   LET g_tc_auth[l_ac].tc_auth04=''
             	   DISPLAY BY NAME g_tc_auth[l_ac].tc_auth03
             	   DISPLAY BY NAME g_tc_auth[l_ac].tc_auth04
             END IF
         BEFORE FIELD tc_auth03
             IF cl_null(g_tc_auth[l_ac].tc_auth02) THEN
             	  NEXT FIELD tc_auth02
             END IF
         
         AFTER FIELD tc_auth03                 
             IF NOT cl_null(g_tc_auth[l_ac].tc_auth03) THEN
                IF g_tc_auth_t.tc_auth03 IS NULL OR
                 (g_tc_auth_t.tc_auth03 != g_tc_auth[l_ac].tc_auth03 ) THEN
                   LET l_c = g_tc_auth[l_ac].tc_auth02
                    CASE l_c
                           WHEN "1" 
                              CALL i004_tc_authg01(p_cmd)
                           WHEN "2"
                              CALL i004_tc_prog01(p_cmd)
                        OTHERWISE EXIT CASE
                    END CASE
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_tc_auth[l_ac].tc_auth03,g_errno,0)
                       LET g_tc_auth[l_ac].tc_auth03 = g_tc_auth_t.tc_auth03
                       DISPLAY BY NAME g_tc_auth[l_ac].tc_auth03
                       NEXT FIELD tc_auth03
                    END IF
                END IF
              END IF  	 	   
         	     	
          	
      BEFORE DELETE          
         DISPLAY "BEFORE DELETE"
         IF g_tc_auth_t.tc_auth02 IS NOT NULL AND g_tc_auth_t.tc_auth03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM tc_auth_file
             WHERE tc_auth01 = g_tc_auth_h.tc_auth01
               AND tc_auth02 = g_tc_auth_t.tc_auth02
               AND tc_auth03 = g_tc_auth_t.tc_auth03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_auth_file",g_tc_auth_h.tc_auth01,g_tc_auth_t.tc_auth02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tc_auth[l_ac].* = g_tc_auth_t.*
            CLOSE i004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_auth[l_ac].tc_auth02,-263,1)
            LET g_tc_auth[l_ac].* = g_tc_auth_t.*
         ELSE
            UPDATE tc_auth_file SET tc_auth02 = g_tc_auth[l_ac].tc_auth02,
                                    tc_auth03 = g_tc_auth[l_ac].tc_auth03,
                                    tc_auth04 = g_tc_auth[l_ac].tc_auth04
             WHERE tc_auth01=g_tc_auth_h.tc_auth01
               AND tc_auth02=g_tc_auth_t.tc_auth02
               AND tc_auth03=g_tc_auth_t.tc_auth03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","tc_auth_file",g_tc_auth_h.tc_auth01,g_tc_auth_t.tc_auth02,SQLCA.sqlcode,"","",1)
               LET g_tc_auth[l_ac].* = g_tc_auth_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         	
      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_tc_auth[l_ac].* = g_tc_auth_t.*
            END IF
            CLOSE i004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION controlp
           CASE
             WHEN INFIELD(tc_auth03) 
               CALL cl_init_qry_var()
               LET l_c = g_tc_auth[l_ac].tc_auth02
               CASE l_c 
                   WHEN "1" 
                     LET g_qryparam.form ="q_tc_authg01" 
                   WHEN "2"
                     LET g_qryparam.form ="q_tc_prog01" 
                   OTHERWISE EXIT CASE
               END CASE
               LET g_qryparam.default1 = g_tc_auth[l_ac].tc_auth03
               CALL cl_create_qry() RETURNING g_tc_auth[l_ac].tc_auth03
               DISPLAY BY NAME g_tc_auth[l_ac].tc_auth03
               CASE l_c
                   WHEN "1" 
                      CALL i004_tc_authg01(p_cmd)  
                   WHEN "2"
                      CALL i004_tc_prog01(p_cmd)
                   OTHERWISE EXIT CASE
               END CASE
               NEXT FIELD tc_auth03
               OTHERWISE EXIT CASE
           END CASE
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
   CLOSE i004_bcl
   COMMIT WORK
   CALL i004_b_fill(" 1=1 ")
END FUNCTION
	
FUNCTION i004_b_fill(p_wc2)
DEFINE p_wc2   STRING
   LET g_sql = "SELECT tc_auth02,tc_auth03,tc_auth04",
               " FROM tc_auth_file",   
               " WHERE tc_auth01 = '",g_tc_auth_h.tc_auth01,"'"   
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED, " ORDER BY tc_auth02,tc_auth03"
   PREPARE i004_pb FROM g_sql
   DECLARE tc_auth_cs CURSOR FOR i004_pb
   CALL g_tc_auth.clear()
   LET g_cnt = 1
   FOREACH tc_auth_cs INTO g_tc_auth[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_auth.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION			

FUNCTION i004_tc_prog01(p_cmd)  
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_prog01    LIKE tc_prog_file.tc_prog01
   DEFINE l_prog02    LIKE tc_prog_file.tc_prog02  
  LET g_errno=''
  SELECT tc_prog02 INTO l_prog02
   FROM tc_prog_file
   WHERE tc_prog01 = g_tc_auth[l_ac].tc_auth03
   LET g_tc_auth[l_ac].tc_auth04 = l_prog02
   IF p_cmd='d' OR cl_null(g_errno) THEN
    DISPLAY l_prog02 TO FORMONLY.tc_auth04
    END IF
END FUNCTION

FUNCTION i004_tc_authg01(p_cmd)  
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_authg01    LIKE tc_authg_file.tc_authg01
   DEFINE l_authg02    LIKE tc_authg_file.tc_authg02  
  LET g_errno=''
  SELECT tc_authg02 INTO l_authg02
   FROM tc_authg_file
   WHERE tc_authg01 = g_tc_auth[l_ac].tc_auth03
   LET g_tc_auth[l_ac].tc_auth04 = l_authg02
   IF p_cmd='d' OR cl_null(g_errno) THEN
    DISPLAY l_authg02 TO FORMONLY.tc_auth04
    END IF
END FUNCTION

