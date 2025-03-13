# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmq621.4gl
# Descriptions...: 
# Date & Author..: 10/01/26 By huangrh
# Modify.........: 
# Modify.........: No:TQC-A50134 10/06/29 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A70138 10/07/29 By jan 补过单
 
#FUN-9B0160
DATABASE ds 
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
               wc         STRING       
           END RECORD
DEFINE g_xsi DYNAMIC ARRAY OF RECORD
            xsh99   LIKE xsh_file.xsh99,
            azp02      LIKE azp_file.azp02,
            xsi03      LIKE xsi_file.xsi03,
            ima02      LIKE ima_file.ima02,
            xsi04      LIKE xsi_file.xsi04,             
            xsi05      LIKE xsi_file.xsi05,
            xsi06      LIKE xsi_file.xsi06
           END RECORD
DEFINE g_argv1         LIKE oea_file.oea01
DEFINE g_rec_b         LIKE type_file.num10
DEFINE p_row,p_col     LIKE type_file.num5 
DEFINE g_cnt           LIKE type_file.num10
DEFINE l_ac            LIKE type_file.num5
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
 
MAIN   
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time
 
   LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q621_w AT p_row,p_col
     WITH FORM "axm/42f/axmq621"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN 
      CALL q621_q()
   END IF

   CALL q621_menu()
 
   CLOSE WINDOW q621_w
 
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION q621_cs()
   DEFINE l_cnt   LIKE type_file.num5
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "oea01 = '",g_argv1,"'"
   ELSE
      CLEAR FORM 
      CALL g_xsi.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                  
      CALL cl_set_head_visible("","YES")  
 
       CONSTRUCT tm.wc ON xsh99,xsi03,xsh02,xsh03 FROM FORMONLY.xsh99_1,FORMONLY.xsi03_1,
                        FORMONLY.xsh02_1,FORMONLY.xsh03_1
          ON ACTION controlp  
             CASE
                WHEN INFIELD(xsh99_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_xsh99"
                   LET g_qryparam.arg1 = g_plant
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO xsh99_1
                   NEXT FIELD xsh99_1   
                   
                WHEN INFIELD(xsi03_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_xsi03"
                   LET g_qryparam.arg1 = g_plant  
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO xsi03_1
                   NEXT FIELD xsi03_1                                 
             END CASE                    
                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
 
      IF INT_FLAG THEN RETURN END IF
 
   END IF

END FUNCTION
 
FUNCTION q621_menu()
 
   WHILE TRUE
      CALL q621_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q621_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#         WHEN "exporttoexcel"     
#            IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xsi),'','')
#            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q621_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL q621_cs()
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL q621_b_fill() #單身
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION q621_b_fill() 
   DEFINE l_sql     STRING
 
   LET l_sql = "SELECT xsh99,'',xsi03,'',xsi04,xsi05,xsi06 ", 
               " FROM xsi_file,xsh_file", 
               " WHERE xsh01=xsi01 ",
               " AND xsh05='1' ",
               " AND xsh04='",g_plant,"'",
               " AND ",tm.wc,
               " ORDER BY xsh99"         
      
    PREPARE q621_pb FROM l_sql
    DECLARE q621_bcs CURSOR WITH HOLD FOR q621_pb
 
    CALL g_xsi.clear()
    LET g_cnt = 1
 
    FOREACH q621_bcs INTO g_xsi[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       SELECT azp02 INTO g_xsi[g_cnt].azp02 FROM azp_file
        WHERE azp01=g_xsi[g_cnt].xsh99
       SELECT ima02 INTO g_xsi[g_cnt].ima02 FROM ima_file
        WHERE ima01=g_xsi[g_cnt].xsi03 
 
       LET g_cnt = g_cnt + 1
 
    END FOREACH
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
 
END FUNCTION
 
FUNCTION q621_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xsi TO s_xsi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont() 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
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
 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#FUN-9B0160-------------------------end----------
#TQC-A50134 10/06/29 By chenls 非T/S類table中的xxxplant替換成xxxstore
#FUN-A70138
