# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artq800.4gl
# Descriptions...: 折價明細查詢作業
# Date & Author..: No:FUN-A10110 10/11/21 By Cockroach 
# Modify.........: No.FUN-CC0156 By SunLM 需求優化：應增加折價匯總金額的查看


DATABASE ds                  

GLOBALS "../../config/top.global"
 
DEFINE g_rxc00  LIKE rxc_file.rxc00       #單據別
DEFINE g_rxc01  LIKE rxc_file.rxc01       #單號

DEFINE g_rxc00_t  LIKE rxc_file.rxc00
DEFINE g_rxc01_t  LIKE rxc_file.rxc01 

DEFINE g_rxc DYNAMIC ARRAY OF RECORD
       rxc02 LIKE rxc_file.rxc02,         #項次  
       rxc03 LIKE rxc_file.rxc03,         #折價方式
       rxc04 LIKE rxc_file.rxc04, 
       rxc05 LIKE rxc_file.rxc05,
       rxc06 LIKE rxc_file.rxc06, 
       rxc07 LIKE rxc_file.rxc07,
       rxc08 LIKE rxc_file.rxc08,
       rxc09 LIKE rxc_file.rxc09,
       rxc10 LIKE rxc_file.rxc10,
       rxc11 LIKE rxc_file.rxc11,
       rxc12 LIKE rxc_file.rxc12,
       rxc12_desc LIKE azp_file.azp02,
       rxc13 LIKE rxc_file.rxc13,
       rxc13_desc LIKE pmc_file.pmc03,
       rxc14 LIKE rxc_file.rxc14 
       END RECORD
DEFINE g_rxc_t RECORD
       rxc02 LIKE rxc_file.rxc02,
       rxc03 LIKE rxc_file.rxc03, 
       rxc04 LIKE rxc_file.rxc04, 
       rxc05 LIKE rxc_file.rxc05,
       rxc06 LIKE rxc_file.rxc06,
       rxc07 LIKE rxc_file.rxc07,
       rxc08 LIKE rxc_file.rxc08,
       rxc09 LIKE rxc_file.rxc09,
       rxc10 LIKE rxc_file.rxc10,
       rxc11 LIKE rxc_file.rxc11,
       rxc12 LIKE rxc_file.rxc12,
       rxc12_desc LIKE azp_file.azp02,
       rxc13 LIKE rxc_file.rxc13,
       rxc13_desc LIKE pmc_file.pmc03,
       rxc14 LIKE rxc_file.rxc14 
       END RECORD       
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_void  LIKE type_file.chr1,        
        g_rec_b LIKE type_file.num5, 
        g_cmd               LIKE type_file.chr1000, 
        l_ac                LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5 
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE g_count               LIKE type_file.num5  
DEFINE  li_result            LIKE type_file.num5
DEFINE  g_t1                 LIKE oay_file.oayslip
DEFINE  l_allow_insert  LIKE type_file.num5
DEFINE  l_allow_delete  LIKE type_file.num5
DEFINE  g_argv1         LIKE rxc_file.rxc00
DEFINE  g_argv2         LIKE rxc_file.rxc01

 

MAIN
DEFINE
   p_row,p_col              LIKE type_file.num5     

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)  #單據別:01-訂單axmt410;02-出貨單axmt620;03-銷退單axmt700.              
   LET g_argv2 = ARG_VAL(2)  #單號   
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

       LET p_row = 4 LET p_col = 10
       OPEN WINDOW q800_w AT p_row,p_col WITH FORM "art/42f/artq800"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_init()   
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_action_choice="query"
      CALL q800_q()
      CALL cl_set_act_visible("query",FALSE)
   END IF 
        
   CALL q800_menu()
   CLOSE WINDOW q800_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
  
FUNCTION q800_menu()
 
   WHILE TRUE
      CALL q800_bp("G")
      CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q800_q()
            END IF

#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL q800_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
 
    
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL q800_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxc),'','')
             END IF        
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rxc01)AND NOT cl_null(g_rxc00) THEN
                 LET g_doc.column1 = "rxc00"
                 LET g_doc.column2 = "rxc01"
                 LET g_doc.value1 = g_rxc00
                 LET g_doc.value2 = g_rxc01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
    
FUNCTION q800_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN          
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rxc TO s_rxc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q800_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL q800_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL q800_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL q800_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL q800_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#        LET g_action_choice="output"
#         EXIT DISPLAY
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
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
 
FUNCTION q800_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_rxc.clear()
    INITIALIZE g_rxc00,g_rxc01 TO NULL    
 IF cl_null(g_argv1) AND cl_null(g_argv2) THEN  
    CONSTRUCT g_wc ON  rxc00,rxc01,rxc02,rxc03,rxc04,rxc05,
             rxc06,rxc07,rxc08,rxc09,rxc10,rxc11,rxc12,rxc13,rxc14
      FROM rxc00,rxc01,s_rxc[1].rxc02,s_rxc[1].rxc03,s_rxc[1].rxc04,
                       s_rxc[1].rxc05,s_rxc[1].rxc06,s_rxc[1].rxc07,
                       s_rxc[1].rxc08,s_rxc[1].rxc09,s_rxc[1].rxc10,
                       s_rxc[1].rxc11,s_rxc[1].rxc12,s_rxc[1].rxc13,s_rxc[1].rxc14        
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init() 
           
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxc01"
                 LET g_qryparam.arg1=g_rxc00
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxc01
                 NEXT FIELD rxc01
              WHEN INFIELD(rxc12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxc12"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxc12
                 NEXT FIELD rxc12
              WHEN INFIELD(rxc13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxc13"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxc13
                 NEXT FIELD rxc13   

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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)          
		
    END CONSTRUCT
    
    IF INT_FLAG THEN
       RETURN
    END IF
  ELSE 
     LET g_wc="rxc00= '",g_argv1 CLIPPED,"' AND rxc01 = '",g_argv2 CLIPPED,"'"  
  END IF	      
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rwpuser', 'rwpgrup')
       
   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1"
   END IF
   
   LET g_sql = "SELECT UNIQUE rxc00,rxc01 ",
               " FROM rxc_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY rxc00,rxc01"
               
   PREPARE q800_prepare FROM g_sql
   DECLARE q800_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR q800_prepare
 
  LET g_sql="SELECT UNIQUE rxc00,rxc01 FROM rxc_file WHERE ",g_wc CLIPPED,  
                 " INTO TEMP x"
  
   DROP TABLE x                            
   PREPARE q800_precount_x FROM g_sql  
   EXECUTE q800_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE q800_precount FROM g_sql
   DECLARE q800_count CURSOR FOR q800_precount 
   	
 
END FUNCTION
 
FUNCTION q800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_rxc.clear()
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
 
    CALL q800_cs()
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_rxc00 = NULL
        LET g_rxc01 = NULL
        CALL g_rxc.clear()
        RETURN
    END IF
 
    OPEN q800_cs
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_rxc.clear()
    ELSE
       OPEN q800_count
       FETCH q800_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL q800_fetch('F')
       ELSE
          CALL cl_err('',100,0)
       END IF
    END IF
END FUNCTION
 
FUNCTION q800_fetch(p_flrxc)
DEFINE p_flrxc         LIKE type_file.chr1    
       
    CASE p_flrxc
        WHEN 'N' FETCH NEXT     q800_cs INTO  g_rxc00,g_rxc01
        WHEN 'P' FETCH PREVIOUS q800_cs INTO  g_rxc00,g_rxc01
        WHEN 'F' FETCH FIRST    q800_cs INTO  g_rxc00,g_rxc01
        WHEN 'L' FETCH LAST     q800_cs INTO  g_rxc00,g_rxc01
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
                   LET g_jump = g_curs_index
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q800_cs INTO  g_rxc00,g_rxc01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxc01,SQLCA.sqlcode,0)
        INITIALIZE g_rxc00 TO NULL  
        INITIALIZE g_rxc01 TO NULL  
        RETURN
    ELSE
      CASE p_flrxc
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
  
        CALL q800_show()                   
 
END FUNCTION
 
FUNCTION q800_show()

   DISPLAY g_rxc00 TO rxc00
   DISPLAY g_rxc01 TO rxc01

   CALL q800_b_fill(g_wc)   
         
   CALL cl_show_fld_cont()        

     
END FUNCTION
 
FUNCTION q800_b_fill(p_wc)              
DEFINE   p_wc       STRING
DEFINE   l_sum      LIKE rxc_file.rxc06  #FUN-CC0156        
   LET g_sql = "SELECT rxc02,rxc03,rxc04,rxc05,rxc06,rxc07,rxc08,",
               "       rxc09,rxc10,rxc11,rxc12,'',rxc13,'',rxc14",
               "  FROM rxc_file ",
               " WHERE rxc01 = '",g_rxc01,"'",
               "   AND rxc00 = '",g_rxc00,"'"
   IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rxc02 "       
    PREPARE q800_pb FROM g_sql
    DECLARE rxc_cs CURSOR FOR q800_pb
 
    CALL g_rxc.clear()
    LET g_cnt = 1
    LET l_sum = 0 #FUN-CC0156
    MESSAGE "Searching!"
    FOREACH rxc_cs INTO g_rxc[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH
        END IF

        SELECT azp02 INTO g_rxc[g_cnt].rxc12_desc FROM azp_file
         WHERE azp01 = g_rxc[g_cnt].rxc12    
        IF cl_null(g_rxc[g_cnt].rxc12_desc) THEN
        	 LET g_rxc[g_cnt].rxc12_desc = "  "
        END IF	  
            
        SELECT pmc03 INTO g_rxc[g_cnt].rxc13_desc FROM pmc_file
         WHERE pmc01 = g_rxc[g_cnt].rxc13
           AND pmcacti = 'Y'     
        IF cl_null(g_rxc[g_cnt].rxc13_desc) THEN
        	 LET g_rxc[g_cnt].rxc13_desc = "  "
        END IF	                
        LET l_sum = l_sum + g_rxc[g_cnt].rxc06 #FUN-CC0156
        DISPLAY BY NAME g_rxc[g_cnt].rxc12_desc,g_rxc[g_cnt].rxc13_desc                 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rxc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY l_sum TO t_sum  #FUN-CC0156
    LET g_cnt = 0
END FUNCTION
    
#FUN-A10110     
      
    
