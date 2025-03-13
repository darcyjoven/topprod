# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apjq012.4gl
# Descriptions...: 成本查詢作業
# Date & Author..: FUN-790025 2008/02/21 By shiwuying
# Modify.........: No.TQC-850002 2008/05/05 By shiwuying 查不出資料
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930106 09/03/18 By destiny pjs05費用編號字段增加管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pjs1          RECORD
        pjs01       LIKE pjs_file.pjs01,
        pjs02       LIKE pjs_file.pjs02,
        pjs03       LIKE pjs_file.pjs03
                     END RECORD,
    g_pjs1_t        RECORD
        pjs01       LIKE pjs_file.pjs01,
        pjs02       LIKE pjs_file.pjs02,
        pjs03       LIKE pjs_file.pjs03
                     END RECORD,
    g_pjs           DYNAMIC ARRAY OF RECORD
        pjs04       LIKE pjs_file.pjs04,
        pjb03       LIKE pjb_file.pjb03,
        pjs05       LIKE pjs_file.pjs05,
        azf03       LIKE azf_file.azf03,
        pjs10       LIKE pjs_file.pjs10,
        pjs11       LIKE pjs_file.pjs11,
        pjs12       LIKE pjs_file.pjs12,
        sum_pjs11   LIKE pjs_file.pjs11
                     END RECORD,
    g_pjs_t         RECORD
        pjs04       LIKE pjs_file.pjs04,
        pjb03       LIKE pjb_file.pjb03,
        pjs05       LIKE pjs_file.pjs05,
        azf03       LIKE azf_file.azf03,
        pjs10       LIKE pjs_file.pjs10,
        pjs11       LIKE pjs_file.pjs11,
        pjs12       LIKE pjs_file.pjs12,
        sum_pjs11   LIKE pjs_file.pjs11
                     END RECORD,
    g_argv1         LIKE pjs_file.pjs03, 
    g_argv2         LIKE pjs_file.pjs01,
    g_argv3         LIKE pjs_file.pjs02,
    g_wc,g_sql      STRING,
    g_rec_b         LIKE type_file.num5,      #單身筆數
    l_ac            LIKE type_file.num5,
    g_ss            LIKE type_file.chr1,
    p_row,p_col     LIKE type_file.num5,
    g_pjaconf       LIKE pja_file.pjaconf
 
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
   LET g_pjs1.pjs03 = g_argv1
   LET g_pjs1.pjs01 = g_argv2
   LET g_pjs1.pjs02 = g_argv3
 
   LET g_forupd_sql = "SELECT pjs01,pjs02,pjs03 FROM pjs_file",
                      " WHERE pjs01=? AND pjs02=? AND pjs03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q012_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW q012_w AT p_row,p_col      #顯示畫面
        WITH FORM "apj/42f/apjq012"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) OR  NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN
      CALL q012_q()
   END IF
   CALL q012_menu()
   CLOSE WINDOW q012_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION q012_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   
   CLEAR FORM                             #清除畫面
   CALL g_pjs.clear()
   IF NOT cl_null(g_argv1) OR  NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN
      IF NOT cl_null(g_argv1) THEN
         LET g_wc=" pjs03 = '",g_argv1,"' " CLIPPED
      END IF
      IF NOT cl_null(g_argv2) THEN
         LET g_wc=g_wc clipped," AND pjs01= ",g_argv2 CLIPPED
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET g_wc=g_wc clipped," AND pjs02= ",g_argv3 CLIPPED
      END IF
      DISPLAY g_pjs1.pjs01,g_pjs1.pjs02,g_pjs1.pjs02 TO pjs01,pjs02,pjs03
      CALL q012_pjs03('d')
   ELSE
      #螢幕上取單頭條件
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_pjs1.* TO NULL
      
      CONSTRUCT g_wc ON pjs01,pjs02,pjs03,
                        pjs04,pjs05,pjs10,pjs11,pjs12
         FROM pjs01,pjs02,pjs03,
              s_pjs[1].pjs04,s_pjs[1].pjs05,
              s_pjs[1].pjs10,s_pjs[1].pjs11,s_pjs[1].pjs12
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         ON ACTION controlp
            CASE
                WHEN INFIELD(pjs03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pja"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjs03
                   NEXT FIELD pjs03
                   
                   WHEN INFIELD(pjs04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pjb2"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjs04
                   NEXT FIELD pjs04
                   
                   WHEN INFIELD(pjs05)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_azf"           #No.FUN-930106
                   LET g_qryparam.form = "q_azf01a"        #No.FUN-930106
                   LET g_qryparam.state = "c"              #No.FUN-930106 
                  #LET g_qryparam.arg1 = '2'               #No.FUN-930106  
                   LET g_qryparam.arg1 = '7'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjs05
                   NEXT FIELD pjs05
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjsuser', 'pjsgrup') #FUN-980030
   END IF
      IF INT_FLAG THEN
         RETURN
      END IF
 
   LET g_sql = "SELECT UNIQUE pjs01,pjs02,pjs03 ",
               " FROM pjs_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY pjs01,pjs02,pjs03"
   PREPARE q012_prepare FROM g_sql
   DECLARE q012_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR q012_prepare
#No.TQC-850002------start---------
#  LET g_sql="SELECT COUNT(*) FROM pjs_file WHERE ",g_wc CLIPPED
#  PREPARE q012_precount FROM g_sql
   LET g_sql_tmp="SELECT UNIQUE pjs01,pjs02,pjs03 ",                              
                 " FROM pjs_file ",                                               
                 " WHERE ", g_wc CLIPPED,
                 " INTO TEMP x"
   DROP TABLE x                            
   PREPARE q012_precount_x FROM g_sql_tmp  
   EXECUTE q012_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
#No.TQC-850002-----end--------
   PREPARE q012_precount FROM g_sql
   DECLARE q012_count CURSOR FOR q012_precount
END FUNCTION
 
FUNCTION q012_menu()
   WHILE TRUE
      CALL q012_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q012_q()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjs),'','')
            END IF
            
         WHEN "related_document"  
          IF cl_chk_act_auth() THEN
             IF g_pjs1.pjs01 IS NOT NULL THEN
                LET g_doc.column1 = "pjs01"
                LET g_doc.column2 = "pjs02"
                LET g_doc.value1 = g_pjs1.pjs01
                LET g_doc.value2 = g_pjs1.pjs02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION q012_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pjs.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL q012_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pjs1.* TO NULL
      RETURN
   END IF
 
   OPEN q012_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pjs1.* TO NULL
   ELSE
      OPEN q012_count
      FETCH q012_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q012_fetch('F')
   END IF
 END FUNCTION
 
 
FUNCTION q012_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q012_cs INTO g_pjs1.*
      WHEN 'P' FETCH PREVIOUS q012_cs INTO g_pjs1.*
      WHEN 'F' FETCH FIRST    q012_cs INTO g_pjs1.*
      WHEN 'L' FETCH LAST     q012_cs INTO g_pjs1.*
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
         FETCH ABSOLUTE g_jump q012_cs INTO g_pjs1.*
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjs1.pjs01,SQLCA.sqlcode,0)
      INITIALIZE g_pjs1.* TO NULL
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
   CALL q012_show()
END FUNCTION
 
 
FUNCTION q012_show()
   LET g_pjs1_t.* = g_pjs1.*
   DISPLAY BY NAME g_pjs1.*
   CALL q012_pjs03('d')
   CALL q012_b_fill(g_wc)              
   CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION q012_pjs03(p_cmd)
    DEFINE l_pja02     LIKE pja_file.pja02,
           l_pjaacti   LIKE pja_file.pjaacti,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pja02,pjaacti
     INTO l_pja02,l_pjaacti
     FROM pja_file WHERE pja01=g_pjs1.pjs03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-048'
                                  LET l_pja02   = NULL
                                  LET l_pjaacti = NULL
        WHEN l_pjaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno)  OR p_cmd='d' THEN
      DISPLAY l_pja02 TO pja02
   END IF
 
END FUNCTION
 
 
FUNCTION q012_b_fill(p_wc2)
#   DEFINE p_wc2   LIKE type_file.chr1000
   DEFINE p_wc2  STRING     #NO.FUN-910082
   DEFINE l_sum   LIKE type_file.num5
 
   LET g_sql="SELECT pjs04,'',pjs05,'',pjs10,pjs11,pjs12,'' ",
             " FROM pjs_file",
             " WHERE pjs01='",g_pjs1.pjs01,"' AND pjs02='",g_pjs1.pjs02,"'",
             "   AND pjs03='",g_pjs1.pjs03,"'"       #No.TQC-850002 
   #          " AND ",p_wc2 CLIPPED,  #單身          #No.TQC-850002
   #          " ORDER BY pjs04"                      #No.TQC-850002 
   IF NOT cl_null(p_wc2) THEN                        #No.TQC-850002
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED  #No.TQC-850002
   END IF                                            #No.TQC-850002  
   LET g_sql=g_sql CLIPPED," ORDER BY pjs04 "        #No.TQC-850002
 
   PREPARE q012_pb FROM g_sql
   DECLARE pjs_cs CURSOR FOR q012_pb
   CALL g_pjs.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   LET l_sum = 0
   FOREACH pjs_cs INTO g_pjs[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT pjb03 INTO g_pjs[g_cnt].pjb03
         FROM pjb_file
        WHERE pjb01=g_pjs1.pjs03 AND pjb02 = g_pjs[g_cnt].pjs04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pjb_file",g_pjs[g_cnt].pjb03,"",SQLCA.sqlcode,"","",0)
         LET g_pjs[g_cnt].pjb03 = NULL
      END IF
      SELECT azf03 INTO g_pjs[g_cnt].azf03
        FROM azf_file
        WHERE azf01 = g_pjs[g_cnt].pjs05
          AND azf02 = '2'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","azf_file",g_pjs[g_cnt].azf03,"",SQLCA.sqlcode,"","",0)
         LET g_pjs[g_cnt].azf03 = NULL
      END IF
      LET l_sum = l_sum + g_pjs[g_cnt].pjs11
      LET g_pjs[g_cnt].sum_pjs11 = l_sum
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjs.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION q012_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjs TO s_pjs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
        
      ON ACTION first
         CALL q012_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY 
           
      ON ACTION previous
         CALL q012_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION jump
         CALL q012_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION next
         CALL q012_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
 
      ON ACTION last
         CALL q012_fetch('L')
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
