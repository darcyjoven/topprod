# Prog. Version..: '5.30.03-12.09.18(00008)'     #
#
# Pattern name...: ghrq010.4gl
# Descriptions...: 员工信息明细查询作业
# Date & Author..: 13/04/07 By yangjian 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1   LIKE hrca_file.hrca01,
    ddflag   LIKE type_file.chr1,                 
    g_wc,g_wc2,g_sql    STRING, 
    g_cott          LIKE type_file.num5,          
    g_hrca           DYNAMIC ARRAY OF RECORD 
      hrca02_1       LIKE hrca_file.hrca02,
      hrca14         LIKE hrca_file.hrca14,
      hrca15         LIKE hrca_file.hrca15,
      hrca03         LIKE hrca_file.hrca03,
      hrca04_1       LIKE hrca_file.hrca04,
      hrbo03         LIKE hrbo_file.hrbo03,
      hrca05_1       LIKE hrca_file.hrca05,
      hrbp03         LIKE hrbp_file.hrbp03,
      hrca11         LIKE hrca_file.hrca11,
      hrca12         LIKE hrca_file.hrca12                            
                     END RECORD,
    g_hrca1          RECORD 
      date           LIKE hrca_file.hrca11,
      hrca02         LIKE hrca_file.hrca02,
      hrca04         LIKE hrca_file.hrca04,
      hrca05         LIKE hrca_file.hrca05
                     END RECORD,         
    g_hrag          RECORD LIKE hrag_file.*,                                                                                                      
    g_rec_b         LIKE type_file.num5,  
    g_rec_b1         LIKE type_file.num5,             
    l_ac            LIKE type_file.num5,               
    g_ac            LIKE type_file.num5,
    l_sl,p_row,p_col            LIKE type_file.num5,
    i,j,k           LIKE type_file.num5  

DEFINE g_forupd_sql      STRING                       
DEFINE   g_chr           LIKE type_file.chr1          
DEFINE   g_cnt           LIKE type_file.num10         
DEFINE   g_msg           LIKE type_file.chr1000       
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10         
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   l_tree_ac_t     LIKE type_file.num5
DEFINE   g_id            LIKE type_file.num10
DEFINE   g_level         LIKE type_file.num5
DEFINE g_curr_idx       INTEGER 

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
    
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q010_w AT p_row,p_col WITH FORM "ghr/42f/ghrq011"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL q010_ui_init()
    CALL  q010_menu()
    CLOSE WINDOW q010_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q010_ui_init()

   #CALL cl_set_comp_visible("name",FALSE)

END FUNCTION

FUNCTION q010_menu()
 
   WHILE TRUE
      CALL q010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
              CALL q010_q()
            END IF 
         WHEN "help"
            IF cl_chk_act_auth() THEN        
              CALL cl_show_help()            
            END IF                           
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrca),'','')
            END IF                        
      END CASE
   END WHILE 
END FUNCTION
	
FUNCTION q010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
              
      DISPLAY ARRAY g_hrca TO s_hrca.*  ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
     
      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY                        
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY   
         
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
     #ON ACTION accept
     #   LET INT_FLAG=FALSE 		
     #   LET g_action_choice="exit"
     #   EXIT DISPLAY

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
 
        ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO") 
         
     END DISPLAY                                                                                   

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	

FUNCTION q010_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL g_hrca.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL q010_b_askkey()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
  
   CALL cl_replace_str(g_wc2,"date="," hrca11 >= ") RETURNING g_wc2
   IF NOT cl_null(g_hrca1.date) THEN
   	  LET g_wc2=g_wc2,"AND hrca12 <='",g_hrca1.date,"' "
   END IF  

   CALL q010_b_fill(g_wc2,'')
END FUNCTION   
   	
   	
FUNCTION q010_b_askkey()
    CLEAR FORM
    CALL g_hrca.clear()
    CONSTRUCT g_wc2 ON date,hrca02,hrca04,hrca05
         FROM date,hrca02,hrca04,hrca05

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
         
      AFTER FIELD date
         LET g_hrca1.date = GET_FLDBUF(date)            
               
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrca04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbo02"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrca04
                 NEXT FIELD hrca04
              WHEN INFIELD(hrca05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbp02"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrca05
                 NEXT FIELD hrca05
 
              OTHERWISE
                 EXIT CASE
           END CASE

      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcauser', 'hrcagrup') #FUN-980030
    IF INT_FLAG THEN LET g_wc2 = NULL RETURN END IF

END FUNCTION

      
FUNCTION q010_b_fill(p_wc2,p_start)        
DEFINE p_start    LIKE type_file.num5      
DEFINE p_wc2      LIKE type_file.chr1000  
DEFINE l_color    LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1     LIKE type_file.num5
DEFINE l_hrca    RECORD LIKE hrca_file.*

   CALL g_hrca.clear()
   LET g_cnt = 1
   DISPLAY 'start: '||TIME
   LET g_sql =  " SELECT hrca02,hrca14,hrca15,hrca03,hrca04,'',hrca05,'',hrca11,hrca12 ",
                   "   FROM hrca_file ",
                   "  WHERE ",p_wc2 CLIPPED,
                   " ORDER BY hrca01 "            
       PREPARE q010_pb FROM g_sql
       DECLARE hrca_curs SCROLL CURSOR WITH HOLD FOR q010_pb

       FOREACH hrca_curs  INTO g_hrca[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF NOT cl_null(g_hrca[g_cnt].hrca04_1) THEN
        	 SELECT hrbo03 INTO g_hrca[g_cnt].hrbo03 FROM hrbo_file WHERE hrbo02=g_hrca[g_cnt].hrca04_1
        END IF
        IF NOT cl_null(g_hrca[g_cnt].hrca05_1) THEN
        	 SELECT hrbp03 INTO g_hrca[g_cnt].hrbp03 FROM hrbp_file WHERE hrbp02=g_hrca[g_cnt].hrca05_1
        END IF
        IF g_hrca[g_cnt].hrca03 = '2' THEN
        	 LET g_hrca[g_cnt].hrca04_1 = g_hrca[g_cnt].hrca05_1
        	 LET g_hrca[g_cnt].hrbo03 = g_hrca[g_cnt].hrbp03
        END IF
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN

           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DISPLAY 'end: '||TIME
    CALL g_hrca.deleteElement(g_cnt)
    LET g_rec_b =  g_cnt -1
    DISPLAY g_rec_b TO cnt  

    DISPLAY 'end: '||TIME

END FUNCTION	
 
