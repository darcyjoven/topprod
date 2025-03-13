# on..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrq074.4gl
# Descriptions...: 待审核计件信息
# Date & Author..: 13/05/24 By lifang
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrdf    DYNAMIC ARRAY OF RECORD
                  hrdf01    LIKE hrdf_file.hrdf01,  
                  hrdf02    LIKE hrdf_file.hrdf02,  
                  hrat02    LIKE hrat_file.hrat02,  
                  hrat03    LIKE hrat_file.hrat03,
                  hraa02    LIKE hraa_file.hraa02,
                  hrat04    LIKE hrat_file.hrat04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrdf03    LIKE hrdf_file.hrdf03,
                  hrdf04    LIKE hrdf_file.hrdf04,
                  hrdf05    LIKE hrdf_file.hrdf05,
                  hrdf06    LIKE hrdf_file.hrdf06,
                  hrdf07    LIKE hrdf_file.hrdf07,
                  hrdfacti  LIKE hrdf_file.hrdfacti                   
               END RECORD,
 
    g_success      LIKE type_file.chr1,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5,
    g_flag          LIKE type_file.chr1
 
DEFINE g_forupd_sql STRING   
DEFINE g_cnt        LIKE type_file.num10  
DEFINE g_cnt2        LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col   LIKE type_file.num5  

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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q074_w AT p_row,p_col WITH FORM "ghr/42f/ghrq074"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    LET g_wc = "hrdf05 = '004'"
    CALL cl_set_comp_visible("hrdf01",FALSE)
    CALL q074_b_fill(g_wc)
    CALL q074_menu()
    CLOSE WINDOW q074_w 
 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION q074_menu()
 
   WHILE TRUE
      CALL q074_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q074_q()
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
	
FUNCTION q074_q()
   CALL q074_b_askkey()
END FUNCTION	
	
FUNCTION q074_b_askkey()
    CLEAR FORM
    CALL g_hrdf.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrdf01,hrdf02,hrat02,hrat03,hrat04,hrdf03,hrdf04,hrdf05,
                       hrdf06,hrdf07,hrdfacti                     
         FROM s_hrdf[1].hrdf01,s_hrdf[1].hrdf02,s_hrdf[1].hrat02,s_hrdf[1].hrat03,s_hrdf[1].hrat04,s_hrdf[1].hrdf03,s_hrdf[1].hrdf04,
              s_hrdf[1].hrdf05,s_hrdf[1].hrdf06,s_hrdf[1].hrdf07,s_hrdf[1].hrdfacti

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
              WHEN INFIELD(hrdf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdf02
                 NEXT FIELD hrdf02
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03                 
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
         OTHERWISE
              EXIT CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrdfuser', 'hrdfgrup') #FUN-980030
    LET g_wc2 = cl_replace_str(g_wc2,"hrdf02","hrat01")
    LET g_wc2 = g_wc2," AND hrdf05 = '004' "
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF 
 
    CALL q074_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION q074_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
                   "hrdf05,hrdf06,hrdf07,hrdfacti",
                   " FROM hrdf_file,hrat_file ",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid = hrdf02 ",
                   " ORDER BY hrdf01,hrat01" 
 
    PREPARE q074_pb FROM g_sql
    DECLARE hrdf_curs CURSOR FOR q074_pb
 
    CALL g_hrdf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdf_curs INTO g_hrdf[g_cnt].*   
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF 

       SELECT hraa02 INTO g_hrdf[g_cnt].hraa02 FROM hraa_file
       WHERE hraa01 = g_hrdf[g_cnt].hrat03
       
       SELECT hrao02 INTO g_hrdf[g_cnt].hrao02 FROM hrao_file
       WHERE hrao01 = g_hrdf[g_cnt].hrat04 
       
       SELECT hrag07 INTO g_hrdf[g_cnt].hrdf05 FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = g_hrdf[g_cnt].hrdf05
        
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrdf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
    LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION q074_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdf TO s_hrdf.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	  
