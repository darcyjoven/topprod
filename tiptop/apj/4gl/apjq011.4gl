# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apjq011.4gl
# Descriptions...: 成本查詢作業
# Date & Author..: FUN-790025 2008/02/21 By shiwuying
# Modify.........: No.TQC-850002 2008/05/05 By shiwuying 查不出資料
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pjt01         LIKE pjt_file.pjt01,
    g_pjt02         LIKE pjt_file.pjt02,
    g_pjt03         LIKE pjt_file.pjt03,
    g_pjt01_t       LIKE pjt_file.pjt01,
    g_pjt02_t       LIKE pjt_file.pjt02,
    g_pjt03_t       LIKE pjt_file.pjt03,
    g_pjt           DYNAMIC ARRAY OF RECORD 
        pjt03       LIKE pjt_file.pjt03,
        pja02       LIKE pja_file.pja02,
        pjt10       LIKE pjt_file.pjt10,
        pjt11       LIKE pjt_file.pjt11,
        pjt12       LIKE pjt_file.pjt12,
        pjt13       LIKE pjt_file.pjt13,
        pjt14       LIKE pjt_file.pjt14,
        pjt15       LIKE pjt_file.pjt15,
        pjt16       LIKE pjt_file.pjt16,
        pjt17       LIKE pjt_file.pjt17,
        pjt18       LIKE pjt_file.pjt18,
        pjt19       LIKE pjt_file.pjt19,
        pjt20       LIKE pjt_file.pjt20,
        pjt21       LIKE pjt_file.pjt21
                     END RECORD,
    g_pjt_t         RECORD
        pjt03       LIKE pjt_file.pjt03,
        pja02       LIKE pja_file.pja02,
        pjt10       LIKE pjt_file.pjt10,
        pjt11       LIKE pjt_file.pjt11,
        pjt12       LIKE pjt_file.pjt12,
        pjt13       LIKE pjt_file.pjt13,
        pjt14       LIKE pjt_file.pjt14,
        pjt15       LIKE pjt_file.pjt15,
        pjt16       LIKE pjt_file.pjt16,
        pjt17       LIKE pjt_file.pjt17,
        pjt18       LIKE pjt_file.pjt18,
        pjt19       LIKE pjt_file.pjt19,
        pjt20       LIKE pjt_file.pjt20,
        pjt21       LIKE pjt_file.pjt21
                     END RECORD,
    g_argv1         LIKE pjt_file.pjt03, 
    g_argv2         LIKE pjt_file.pjt01,
    g_argv3         LIKE pjt_file.pjt02,
    g_wc,g_sql      STRING,
    g_rec_b         LIKE type_file.num5,      #單身筆數
    l_ac            LIKE type_file.num5,
    g_ss            LIKE type_file.chr1,
    p_row,p_col     LIKE type_file.num5
    
#主程式開始
DEFINE g_forupd_sql         STRING             #SELECT ... FOR UPDATE SQL        
DEFINE g_sql_tmp            STRING 
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10 
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5 
 
 
MAIN
   DEFINE  p_row,p_col      LIKE type_file.num5
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_argv1 = ARG_VAL(1)               #參數-1(網絡編號)
   LET g_argv2 = ARG_VAL(2)               #參數-2(活動編號)
   LET g_argv3 = ARG_VAL(3)
   LET g_pjt03 = g_argv1
   LET g_pjt01 = g_argv2
   LET g_pjt02 = g_argv3
 
   LET g_forupd_sql = "SELECT pjt01,pjt02 FROM pjt_file",
                      " WHERE pjt01=? AND pjt02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q011_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW q011_w AT p_row,p_col      #顯示畫面
        WITH FORM "apj/42f/apjq011"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) OR  NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN
      CALL q011_q()
   END IF
   CALL q011_menu()
   CLOSE WINDOW q011_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION q011_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   
   CLEAR FORM                             #清除畫面
   CALL g_pjt.clear()
   IF NOT cl_null(g_argv1) OR  NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN
      IF NOT cl_null(g_argv1) THEN
         LET g_wc=" pjt03 = '",g_argv1,"' " CLIPPED
      END IF
      IF NOT cl_null(g_argv2) THEN
         LET g_wc=g_wc clipped," AND pjt01= ",g_argv2 CLIPPED
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET g_wc=g_wc clipped," AND pjt02= ",g_argv3 CLIPPED
      END IF
      DISPLAY g_pjt01,g_pjt02 TO pjt01,pjt02
   ELSE
      #螢幕上取單頭條件
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_pjt01 TO NULL
      INITIALIZE g_pjt02 TO NULL
      INITIALIZE g_pjt03 TO NULL
      
      CONSTRUCT g_wc ON pjt01,pjt02,
                        pjt03,pjt10,pjt11,pjt12,pjt13,pjt14,pjt15,
                        pjt16,pjt17,pjt18,pjt19,pjt20,pjt21
         FROM pjt01,pjt02,
              s_pjt[1].pjt03,s_pjt[1].pjt10,s_pjt[1].pjt11,s_pjt[1].pjt12,
              s_pjt[1].pjt13,s_pjt[1].pjt14,s_pjt[1].pjt15,s_pjt[1].pjt16,
              s_pjt[1].pjt17,s_pjt[1].pjt18,s_pjt[1].pjt19,s_pjt[1].pjt20,
              s_pjt[1].pjt21
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         ON ACTION controlp
            CASE
                WHEN INFIELD(pjt03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pja"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjt03
                   NEXT FIELD pjt03
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
 
         ON ACTION qbe_select
	    CALL cl_qbe_list() RETURNING lc_qbe_sn
	    CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjtuser', 'pjtgrup') #FUN-980030
   END IF
      IF INT_FLAG THEN
         RETURN
      END IF
 
   LET g_sql = "SELECT UNIQUE pjt01,pjt02 ",
               " FROM pjt_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY pjt01,pjt02"
   PREPARE q011_prepare FROM g_sql
   DECLARE q011_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR q011_prepare
#No.TQC-850002------start------
#   LET g_sql="SELECT COUNT(*) FROM pjt_file WHERE ", g_wc CLIPPED 
#   PREPARE q011_precount FROM g_sql
   LET g_sql_tmp="SELECT UNIQUE pjt01,pjt02 ",                                                                                        
                 " FROM pjt_file ",                                                                                                   
                 " WHERE ", g_wc CLIPPED,                                                                                
                 " INTO TEMP x"                                                                                                     
   DROP TABLE x                                                                                                                     
   PREPARE q011_precount_x FROM g_sql_tmp                                                                                           
   EXECUTE q011_precount_x                                                                                                          
                                                                                                                                    
   LET g_sql="SELECT COUNT(*) FROM x " 
#No.TQC-850002-----end------                                                                                             
   PREPARE q011_precount FROM g_sql                                                                                                 
   DECLARE q011_count CURSOR FOR q011_precount
END FUNCTION
 
FUNCTION q011_menu()
   WHILE TRUE
      CALL q011_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q011_q()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjt),'','')
            END IF
            
         WHEN "related_document"  
          IF cl_chk_act_auth() THEN
             IF g_pjt01 IS NOT NULL THEN
                LET g_doc.column1 = "pjt01"
                LET g_doc.column2 = "pjt02"
                LET g_doc.value1 = g_pjt01
                LET g_doc.value2 = g_pjt02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION q011_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pjt.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL q011_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjt01=NULL
      LET g_pjt02=NULL
      LET g_pjt03=NULL
      RETURN
   END IF
 
   OPEN q011_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjt01=NULL
      LET g_pjt02=NULL
      LET g_pjt03=NULL
   ELSE
      OPEN q011_count
      FETCH q011_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q011_fetch('F')
   END IF
 END FUNCTION
 
 
FUNCTION q011_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q011_cs INTO g_pjt01,g_pjt02
      WHEN 'P' FETCH PREVIOUS q011_cs INTO g_pjt01,g_pjt02
      WHEN 'F' FETCH FIRST    q011_cs INTO g_pjt01,g_pjt02
      WHEN 'L' FETCH LAST     q011_cs INTO g_pjt01,g_pjt02
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
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q011_cs INTO g_pjt01,g_pjt02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjt01,SQLCA.sqlcode,0)
      INITIALIZE g_pjt01 TO NULL
      INITIALIZE g_pjt02 TO NULL 
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
   CALL q011_show()
END FUNCTION
 
 
FUNCTION q011_show()
   LET g_pjt01_t = g_pjt01
   LET g_pjt02_t = g_pjt02
   DISPLAY g_pjt01,g_pjt02 TO pjt01,pjt02 
#   CALL q011_pjt03('d')
   CALL q011_b_fill(g_wc)              
   CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION q011_b_fill(p_wc2)
#DEFINE p_wc2          LIKE type_file.chr1000
DEFINE p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql="SELECT pjt03,'',pjt10,pjt11,pjt12,pjt13,pjt14,pjt15,",
             "       pjt16,pjt17,pjt18,pjt19,pjt20,pjt21",
             " FROM pjt_file",
             " WHERE pjt01='",g_pjt01,"' AND pjt02='",g_pjt02,"'"
   #          "   AND pjt03='",g_pjt03,"'",          #No.TQC-850002        
   #          " AND ",p_wc2 CLIPPED,  #單身          #No.TQC-850002
   #          " ORDER BY pjt03"
   IF NOT cl_null(p_wc2) THEN                        #No.TQC-850002
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED  #No.TQC-850002
   END IF                                            #No.TQC-850002
   LET g_sql=g_sql CLIPPED," ORDER BY pjt03 "        #No.TQC-850002
  
   PREPARE q011_pb FROM g_sql
   DECLARE pjt_cs CURSOR FOR q011_pb
   CALL g_pjt.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjt_cs INTO g_pjt[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT pja02 INTO g_pjt[g_cnt].pja02
         FROM pja_file
        WHERE pja01 = g_pjt[g_cnt].pjt03
       IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pja_file",g_pjt[g_cnt].pja02,"",SQLCA.sqlcode,"","",0)
         LET g_pjt[g_cnt].pja02 = NULL
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_pjt.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION q011_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjt TO s_pjt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
        
      ON ACTION first
         CALL q011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY 
           
      ON ACTION previous
         CALL q011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION jump
         CALL q011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION next
         CALL q011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
 
      ON ACTION last
         CALL q011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
      
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
#NO.FUN-790025
