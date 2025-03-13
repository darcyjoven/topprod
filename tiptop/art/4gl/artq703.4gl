# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artq703.4gl
# Descriptions...: 代管庫存明細查詢
# Date & Author..: NO.FUN-CC0057 12/12/17 By xumeimei
# Modify.........: No.FUN-CC0082 12/12/28 By baogc 過單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_rtz       RECORD LIKE rtz_file.*
DEFINE g_rtz_t     RECORD LIKE rtz_file.*
DEFINE g_rxg1      DYNAMIC ARRAY OF RECORD
                   rxg17      LIKE rxg_file.rxg17,
                   rxg01      LIKE rxg_file.rxg01,
                   rxg09      LIKE rxg_file.rxg09,
                   rxg10      LIKE rxg_file.rxg10,
                   rxg11      LIKE rxg_file.rxg11,
                   rxg08      LIKE rxg_file.rxg08,
                   rxg07      LIKE rxg_file.rxg07,
                   rtg05      LIKE rtg_file.rtg05,
                   amt        LIKE rxg_file.rxg07
                   END RECORD
DEFINE g_rxg1_t    DYNAMIC ARRAY OF RECORD
                   rxg17      LIKE rxg_file.rxg17,
                   rxg01      LIKE rxg_file.rxg01,
                   rxg09      LIKE rxg_file.rxg09,
                   rxg10      LIKE rxg_file.rxg10,
                   rxg11      LIKE rxg_file.rxg11,
                   rxg08      LIKE rxg_file.rxg08,
                   rxg07      LIKE rxg_file.rxg07,
                   rtg05      LIKE rtg_file.rtg05,
                   amt        LIKE rxg_file.rxg07
                   END RECORD
DEFINE g_rxg2      DYNAMIC ARRAY OF RECORD
                   rxg18      LIKE rxg_file.rxg18,
                   rxg01_1    LIKE rxg_file.rxg01,
                   rxg09_1    LIKE rxg_file.rxg09,
                   rxg10_1    LIKE rxg_file.rxg10,
                   rxg11_1    LIKE rxg_file.rxg11,
                   rxg08_1    LIKE rxg_file.rxg08,
                   rxg07_1    LIKE rxg_file.rxg07,
                   rtg05_1    LIKE rtg_file.rtg05,
                   amt_1      LIKE rxg_file.rxg07
                   END RECORD
DEFINE g_rxg2_t    DYNAMIC ARRAY OF RECORD
                   rxg17      LIKE rxg_file.rxg18,
                   rxg01_1    LIKE rxg_file.rxg01,
                   rxg09_1    LIKE rxg_file.rxg09,
                   rxg10_1    LIKE rxg_file.rxg10,
                   rxg11_1    LIKE rxg_file.rxg11,
                   rxg08_1    LIKE rxg_file.rxg08,
                   rxg07_1    LIKE rxg_file.rxg07,
                   rtg05_1    LIKE rtg_file.rtg05,
                   amt_1      LIKE rxg_file.rxg07
                   END RECORD
DEFINE g_wc                   STRING 
DEFINE g_sql                  STRING                 
DEFINE g_forupd_sql           STRING
DEFINE g_before_input_done    LIKE type_file.num5   
DEFINE g_chr                  LIKE type_file.chr1 
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_wc1                  STRING 
DEFINE g_wc2                  STRING 
DEFINE g_wc3                  STRING
DEFINE g_rec_b                LIKE type_file.num5 
DEFINE g_rec_b1               LIKE type_file.num5         
DEFINE l_ac                   LIKE type_file.num5
DEFINE l_ac1                  LIKE type_file.num5  
DEFINE g_msg                  LIKE type_file.chr1000
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10 
DEFINE g_jump                 LIKE type_file.num10             
DEFINE g_no_ask               LIKE type_file.num5 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT          
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_forupd_sql = "SELECT * FROM rtz_file WHERE rtz01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q703_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW q703_w WITH FORM "art/42f/artq703"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
   LET g_action_choice = ""
   LET g_auth = " ('",g_plant,"')"
   CALL q703_menu()
 
   CLOSE WINDOW q703_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q703_curs()
   CLEAR FORM    
   CALL g_rxg1.clear()
   CALL g_rxg2.clear()
   DIALOG ATTRIBUTES(UNBUFFERED) 
      CONSTRUCT BY NAME g_wc ON rtz01
                        
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
         
           ON ACTION controlp
              CASE
                 WHEN INFIELD(rtz01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtz01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtz01 IN ",g_auth," "
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtz01
                    NEXT FIELD rtz01 
         
                 OTHERWISE
                    EXIT CASE
              END CASE
      END CONSTRUCT
      
      CONSTRUCT g_wc2 ON rxg17,rxg01 FROM s_rxg1[1].rxg17,s_rxg1[1].rxg01
         BEFORE CONSTRUCT
           CALL cl_qbe_init() 

         ON ACTION CONTROLP 
            CASE 
               WHEN INFIELD(rxg17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rxg17"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.where = " rxgplant IN ",g_auth," "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxg17
                  NEXT FIELD rxg17
               
               WHEN INFIELD(rxg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rxg01"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.where = " rxgplant IN ",g_auth," "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxg01
                  NEXT FIELD rxg01
               
                OTHERWISE EXIT CASE
            END CASE
      
      END CONSTRUCT
      CONSTRUCT g_wc3 ON rxg18,rxg01 FROM s_rxg2[1].rxg18,s_rxg2[1].rxg01_1
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
      
         ON ACTION CONTROLP 
            CASE 
               WHEN INFIELD(rxg18)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rxg18"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.where = " rxgplant IN ",g_auth," "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxg18
                  NEXT FIELD rxg18
               
               WHEN INFIELD(rxg01_1)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rxg01"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.where = " rxgplant IN ",g_auth," "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxg01_1
                  NEXT FIELD rxg01_1
               
                OTHERWISE EXIT CASE
            END CASE
      
      END CONSTRUCT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG    
      
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
      
      ON ACTION close
         LET INT_FLAG=1
         EXIT DIALOG 
      
      ON ACTION ACCEPT
         ACCEPT DIALOG
      
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG 
   END DIALOG    
   IF INT_FLAG THEN
      RETURN
   END IF

   IF cl_null(g_wc2) THEN
      LET g_wc2 = " 1=1"
   END IF

   IF cl_null(g_wc3) THEN     
      LET g_wc3 = " 1=1"
   END IF

   LET g_wc1 = cl_replace_str(g_wc2, "rxg", "a.rxg")," AND ",cl_replace_str(g_wc3, "rxg", "b.rxg")

   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql = "SELECT rtz01 FROM rtz_file",
                  " WHERE ",g_wc CLIPPED,
                  "   AND rtz01 IN ",g_auth,
                  " ORDER BY rtz01"
   ELSE
      LET g_sql = "SELECT UNIQUE rtz01 ",
                  "  FROM rtz_file LEFT OUTER JOIN rxg_file a ON (rtz01 = a.rxgplant AND a.rxg18 = rtz01) ",
                  "                LEFT OUTER JOIN rxg_file b ON (rtz01 = b.rxgplant AND b.rxg17 = rtz01) ",
                  " WHERE rtz01 IN ",g_auth,
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc1 CLIPPED,
                  " ORDER BY rtz01"
   END IF
   PREPARE q703_prepare FROM g_sql
   DECLARE q703_cs SCROLL CURSOR WITH HOLD FOR q703_prepare

   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql= "SELECT COUNT(*) FROM rtz_file",
                 " WHERE ",g_wc CLIPPED,
                 "   AND rtz01 IN ",g_auth 
   ELSE
      LET g_sql= "SELECT COUNT(DISTINCT rtz01) ",
                  "  FROM rtz_file LEFT OUTER JOIN rxg_file a ON (rtz01 = a.rxgplant AND a.rxg18 = rtz01) ",
                  "                LEFT OUTER JOIN rxg_file b ON (rtz01 = b.rxgplant AND b.rxg17 = rtz01) ",
                  " WHERE rtz01 IN ",g_auth,
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc1 CLIPPED
   END IF
   PREPARE q703_precount FROM g_sql
   DECLARE q703_count CURSOR FOR q703_precount
END FUNCTION
 
FUNCTION q703_menu()

   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      CALL q703_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q703_q()
            END IF
 
         WHEN "help"
            CALL cl_show_help()

         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxg1),base.TypeInfo.create(g_rxg2),'')
            END IF

         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q703_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_rxg1 TO s_rxg1.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
        CALL cl_set_act_visible("accept,cancel",FALSE )  
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
              
   END DISPLAY
   
   DISPLAY ARRAY g_rxg2 TO s_rxg2.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
   END DISPLAY 
   
   BEFORE DIALOG   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION first
         CALL q703_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL q703_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL q703_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL q703_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL q703_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG


      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION EXIT
         LET g_action_choice="exit"
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
 
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 

   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
 
FUNCTION q703_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_rtz.* TO NULL
    INITIALIZE g_rtz_t.* TO NULL
    
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_rxg1.clear()
    CALL g_rxg2.clear()
    DISPLAY '   ' TO FORMONLY.cnt
   
     
    CALL q703_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_rtz.* TO NULL
       INITIALIZE g_rtz_t.* TO NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN q703_count
    FETCH q703_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q703_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtz.rtz01,SQLCA.sqlcode,0)
       INITIALIZE g_rtz.* TO NULL
       INITIALIZE g_rtz_t.* TO NULL
       LET g_wc = NULL
    ELSE
       CALL q703_fetch('F')
    END IF

END FUNCTION
 
FUNCTION q703_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     q703_cs INTO g_rtz.rtz01
        WHEN 'P' FETCH PREVIOUS q703_cs INTO g_rtz.rtz01
        WHEN 'F' FETCH FIRST    q703_cs INTO g_rtz.rtz01
        WHEN 'L' FETCH LAST     q703_cs INTO g_rtz.rtz01
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
            FETCH ABSOLUTE g_jump q703_cs INTO g_rtz.rtz01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtz.rtz01,SQLCA.sqlcode,0)
       INITIALIZE g_rtz.* TO NULL
       INITIALIZE g_rtz_t.* TO NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_rtz.* FROM rtz_file  
     WHERE rtz01 = g_rtz.rtz01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtz.rtz01,SQLCA.sqlcode,0)
    ELSE
       CALL q703_show() 
    END IF
END FUNCTION
 
FUNCTION q703_show()
    DISPLAY BY NAME g_rtz.rtz01,g_rtz.rtz12,g_rtz.rtz13,g_rtz.rtz03
    CALL cl_show_fld_cont() 
    CALL q703_b_fill(g_wc2)   
    CALL q703_b1_fill(g_wc3)   
END FUNCTION


FUNCTION q703_b_fill(p_wc2)
 
    DEFINE p_wc2       STRING
 
    LET g_sql = "SELECT rxg17,rxg01,rxg09,rxg10,rxg11,rxg08,SUM(rxg07),'',''",
                "  FROM ",cl_get_target_table(g_rtz.rtz01,'rxg_file'),   
                " WHERE rxgplant = '",g_rtz.rtz01,"'",
                "   AND rxg18 = '",g_rtz.rtz01,"'"
 
    IF NOT cl_null(p_wc2) THEN                                                   
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
    END IF                                                                       
    LET g_sql=g_sql CLIPPED," HAVING SUM(rxg07) <> 0",
                            " GROUP BY rxg17,rxg01,rxg09,rxg10,rxg11,rxg08",
                            " ORDER BY rxg17,rxg01,rxg09,rxg10,rxg11,rxg08"            
    PREPARE q703_pb FROM g_sql
    DECLARE rxg_cs CURSOR FOR q703_pb
 
    CALL g_rxg1.clear()
    LET g_rec_b=0    
    LET g_cnt = 1
 
    FOREACH rxg_cs INTO g_rxg1[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      SELECT rtg05 INTO g_rxg1[g_cnt].rtg05 
        FROM rtg_file,rtz_file
       WHERE rtg01 = rtz05
         AND rtz01 = g_rtz.rtz01
         AND rtg03 = g_rxg1[g_cnt].rxg01
         AND rtg04 = g_rxg1[g_cnt].rxg08
      LET g_rxg1[g_cnt].amt = g_rxg1[g_cnt].rtg05 * g_rxg1[g_cnt].rxg07
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
      END IF
    END FOREACH
    CALL g_rxg1.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    LET g_cnt = 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL q703_bp_refresh()
 
END FUNCTION

FUNCTION q703_bp_refresh()
  DISPLAY ARRAY g_rxg1 TO s_rxg1.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION q703_b1_fill(p_wc3)             
    DEFINE p_wc3           STRING 
 
    LET g_sql = "SELECT rxg18,rxg01,rxg09,rxg10,rxg11,rxg08,SUM(rxg07),'',''",
                "  FROM ",cl_get_target_table(g_rtz.rtz01,'rxg_file'), 
                " WHERE rxgplant = '",g_rtz.rtz01,"'",
                "   AND rxg17  = '",g_rtz.rtz01,"'"

    IF NOT cl_null(p_wc3) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," HAVING SUM(rxg07) <> 0",
                            " GROUP BY rxg18,rxg01,rxg09,rxg10,rxg11,rxg08",
                            " ORDER BY rxg18,rxg01,rxg09,rxg10,rxg11,rxg08"
    PREPARE q703_pd FROM g_sql
    DECLARE rxg1_curs CURSOR FOR q703_pd

    CALL g_rxg2.clear()
    LET g_rec_b1=0
    LET g_cnt = 1

    FOREACH rxg1_curs INTO g_rxg2[g_cnt].*   
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH 
       END IF
       
       SELECT rtg05 INTO g_rxg2[g_cnt].rtg05_1 
         FROM rtg_file,rtz_file
        WHERE rtg01 = rtz05
          AND rtz01 = g_rtz.rtz01
          AND rtg03 = g_rxg2[g_cnt].rxg01_1
          AND rtg04 = g_rxg2[g_cnt].rxg08_1
       LET g_rxg2[g_cnt].amt_1 = g_rxg2[g_cnt].rtg05_1 * g_rxg2[g_cnt].rxg07_1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH

    CALL g_rxg2.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn3
    CALL q703_bp1_refresh()

END FUNCTION

FUNCTION q703_bp1_refresh()
  DISPLAY ARRAY g_rxg2 TO s_rxg2.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

#FUN-CC0082
#FUN-CC00057
