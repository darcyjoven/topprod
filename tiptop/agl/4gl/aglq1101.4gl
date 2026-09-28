# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglq1101.4gl
# Descriptions...: 作業重要異動情況查詢
# Date & Author..: 12/11/26 By zhangweib   FUN-CB0096

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_azu      DYNAMIC ARRAY OF RECORD    #No.FUN-CB0096
          azu00   LIKE azu_file.azu00,
          azu11   LIKE azu_file.azu11,
          gen02   LIKE gen_file.gen02,
          azu03   LIKE azu_file.azu03,
          azu09   LIKE azu_file.azu09,
          gaz03   LIKE gaz_file.gaz03,
          azu12   LIKE azu_file.azu12,
          azu04   LIKE azu_file.azu04,
          azu05   LIKE azu_file.azu05,
          azu10   LIKE azu_file.azu10,
          azu13   LIKE azu_file.azu13,
          azu15   LIKE azu_file.azu15,
          azu14   LIKE azu_file.azu14,
          azu16   LIKE azu_file.azu16
                END RECORD
DEFINE g_cnt         LIKE type_file.num5           
DEFINE l_ac          LIKE type_file.num5  
DEFINE g_rec_b       LIKE type_file.num5  
DEFINE g_row_count   LIKE type_file.num10
DEFINE g_curs_index  LIKE type_file.num10   
DEFINE g_jump        LIKE type_file.num10
DEFINE mi_no_ask     LIKE type_file.num5 
DEFINE g_sql         STRING   
DEFINE g_wc          STRING   
DEFINE g_argv1       LIKE type_file.chr1
DEFINE g_argv2       LIKE azu_file.azu00
DEFINE l_zz011       LIKE zz_file.zz011
DEFINE g_zz011       STRING

MAIN

   OPTIONS                
      INPUT NO WRAP      
      DEFER INTERRUPT
      
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   
   OPEN WINDOW q110 WITH FORM "agl/42f/aglq1101"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
      CALL cl_ui_init()
      CALL cl_set_comp_visible("azu00",FALSE)

  #-----指定combo zz011的值-------------#
   LET g_zz011=""
   DECLARE p_zz011_cur CURSOR FOR
      SELECT gao01 FROM gao_file
       WHERE gao01 NOT IN ('SUB','CSUB','LIB','CLIB','QRY','CQRY')
             ORDER BY gao01
   FOREACH p_zz011_cur INTO l_zz011
      IF cl_null(g_zz011) THEN
         LET g_zz011=l_zz011
      ELSE
         LET g_zz011=g_zz011 CLIPPED,",",l_zz011 CLIPPED
      END IF
   END FOREACH

   CALL cl_set_combo_items("azu03",g_zz011,g_zz011)
   #-------------------------------------#

      IF g_argv1 = 'Y' AND NOT cl_null(g_argv1) THEN
         CALL q110_q()
      END IF
      CALL q110_menu()
      
   CLOSE WINDOW q110
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q110_cs()

   CLEAR FORM 
   INITIALIZE g_azu TO NULL 

   IF g_argv1 = 'N' OR cl_null(g_argv1) THEN
   CONSTRUCT BY NAME g_wc ON azu11,azu03,azu09,azu12,azu04,
                             azu05,azu10,azu13,azu15,azu14,azu16

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azu11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form  = 'q_gen'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azu11
               NEXT FIELD azu11
            WHEN INFIELD(azu09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form  = 'q_gaz1' 
               LET g_qryparam.where = g_lang 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azu09 
               NEXT FIELD azu09
            WHEN INFIELD(azu10)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form  = 'q_aba02'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azu10
               NEXT FIELD azu10
         END CASE 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
         
      ON ACTION help
         CALL cl_show_help()
         
      ON ACTION controlg
         CALL cl_cmdask()
         
      ON ACTION about
         CALL cl_about()
            
   END CONSTRUCT 
   IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " azu00 = '",g_argv2,"'"
   END IF

   LET g_sql = "SELECT azu00,azu11,'',azu03,azu09,'',azu12,azu04,",
               "       azu05,azu10,azu13,azu15,azu14,azu16 ",
               "  FROM azu_file ",  
               " WHERE azu12 != '100' AND ",g_wc CLIPPED
   PREPARE q110_prepare FROM g_sql
   DECLARE q110_cs SCROLL CURSOR WITH HOLD FOR q110_prepare                      
   LET g_sql = "SELECT COUNT(azu00) FROM azu_file ",
               " WHERE azu12 != '100' AND ",g_wc CLIPPED
   PREPARE q110_precount FROM g_sql
   DECLARE q110_count CURSOR FOR q110_precount
END FUNCTION 

FUNCTION q110_menu()
   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q110_q()
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

FUNCTION q110_q()
   LET g_row_count = 0
   LET g_curs_index= 0
   CALL cl_navigator_setting(g_curs_index,g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   LET g_wc = ''
   DISPLAY '' TO FORMONLY.cnt
   CALL q110_cs()
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      INITIALIZE g_azu TO NULL 
      CALL g_azu.clear()
      CLEAR FORM 
      RETURN 
   END IF
   MESSAGE " SEARCHING!"

   OPEN q110_count
   FETCH q110_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cn2

   OPEN q110_cs
   IF SQLCA.sqlcode THEN 
      CALL cl_err("q110_cs",SQLCA.sqlcode,1)
      INITIALIZE g_azu TO NULL 
      CALL g_azu.clear()
   ELSE 
      CALL q110_b_fill()
   END IF 
   MESSAGE ""

END FUNCTION 

FUNCTION q110_b_fill()

   LET l_ac = 1
   FOREACH q110_cs INTO g_azu[l_ac].*
      SELECT gaz03 INTO g_azu[l_ac].gaz03 FROM gaz_file
       WHERE gaz01 = g_azu[l_ac].azu09
         AND gaz02 = g_lang
      SELECT gen02 INTO g_azu[l_ac].gen02 FROM gen_file
       WHERE gen01 = g_azu[l_ac].azu11
      LET l_ac = l_ac + 1
   END FOREACH
   CALL g_azu.deleteElement(l_ac)
   LET g_rec_b = l_ac - 1
   DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION 

FUNCTION q110_bp(p_ud)
DEFINE p_ud   LIKE type_file.chr1
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_azu TO s_azu.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY 
           CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW 
             LET l_ac = ARR_CURR()
      END DISPLAY 
   
      BEFORE DIALOG
         LET l_ac = 1
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
                 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         LET g_action_choice = 'locale'
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
        
      ON ACTION cancel
         LET INT_FLAG=FALSE        
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION exit
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about        
         CALL cl_about()      
     
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
