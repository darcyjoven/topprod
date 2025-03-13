# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apjt122.4gl
# Descriptions...: WBS本階設備維護作業
# Date & Author..: No.FUN-790025 07/10/29  By Cockroach
# Modify.........: No.TQC-840009 08/04/03  By Cockroach 需求金額實現位置修改
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/07/30 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#Module Variables
DEFINE
    g_pjma01         LIKE pjma_file.pjma01,      #
    g_pjma01_t       LIKE pjma_file.pjma01,      #
    g_pjma01_o       LIKE pjma_file.pjma01,
 
    g_pjma           DYNAMIC ARRAY OF RECORD    #(Program Variables)
        pjma02       LIKE pjma_file.pjma02,   #
        pjma03       LIKE pjma_file.pjma03,   #
        pjy02        LIKE pjy_file.pjy02,
        pjma04       LIKE pjma_file.pjma04,   #
        pjy03        LIKE pjy_file.pjy03,
        pjy04        LIKE pjy_file.pjy04,
        pjma05       LIKE pjma_file.pjma05,
        amt          LIKE type_file.num20_6,
        pjmaacti       LIKE pjma_file.pjmaacti
                    END RECORD,
    g_pjma_t         RECORD                   # 
        pjma02       LIKE pjma_file.pjma02,   #
        pjma03       LIKE pjma_file.pjma03,   #
        pjy02        LIKE pjy_file.pjy02,
        pjma04       LIKE pjma_file.pjma04,   #
        pjy03        LIKE pjy_file.pjy03,
        pjy04        LIKE pjy_file.pjy04,
        pjma05       LIKE pjma_file.pjma05,
        amt          LIKE type_file.num20_6,
        pjmaacti       LIKE pjma_file.pjmaacti
                    END RECORD,
    g_pjma_o         RECORD                   #
        pjma02       LIKE pjma_file.pjma02,   #
        pjma03       LIKE pjma_file.pjma03,   #
        pjy02        LIKE pjy_file.pjy02,
        pjma04       LIKE pjma_file.pjma04,   #
        pjy03        LIKE pjy_file.pjy03,
        pjy04        LIKE pjy_file.pjy04,
        pjma05       LIKE pjma_file.pjma05,
        amt          LIKE type_file.num20_6,
        pjmaacti       LIKE pjma_file.pjmaacti
                    END RECORD,
    g_argv1          LIKE pjma_file.pjma01,
    g_wc,g_wc2,g_sql     STRING,              
    g_rec_b              LIKE type_file.num5,              
    g_ss                 LIKE type_file.chr1,
    l_ac                 LIKE type_file.num5,              
    p_row,p_col          LIKE type_file.num5              
 
DEFINE g_forupd_sql         STRING                   #SELECT ... FOR UPDATE SQL 
DEFINE g_sql_tmp            STRING                   #
DEFINE g_before_input_done  LIKE type_file.num5      #
DEFINE g_chr                LIKE type_file.chr1      #
DEFINE g_cnt                LIKE type_file.num10     #
DEFINE g_msg                LIKE type_file.chr1000   #
DEFINE g_row_count          LIKE type_file.num10     #
DEFINE g_curs_index         LIKE type_file.num10     #
DEFINE g_jump               LIKE type_file.num10     #
DEFINE mi_no_ask            LIKE type_file.num5      #
DEFINE g_show               LIKE type_file.chr1
MAIN
DEFINE  p_row,p_col              LIKE type_file.num5      #
 
   OPTIONS                               #
      INPUT NO WRAP
   DEFER INTERRUPT                       #
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #
   INITIALIZE g_pjma01 TO NULL
   
   LET g_argv1 = ARG_VAL(1)
   LET g_pjma01 = g_argv1
   
 
   LET g_forupd_sql = "SELECT pjma01 FROM pjma_file",
                      " WHERE pjma01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t122_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW t122_w AT p_row,p_col      #
     WITH FORM "apj/42f/apjt122"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) THEN
       SELECT count(*) INTO g_cnt FROM pjma_file WHERE pjma01=g_argv1
      IF g_cnt > 0 THEN
 #        LET g_wc2 = '1=1'
         CALL t122_q()
      ELSE
         LET g_pjma01=g_argv1
         CALL t122_show()
#         CALL t122_pjma01('a')
         CALL t122_b()
      END IF      
   END IF
#    LET g_wc2 = '1=1'
#    CALL t122_b_fill(g_wc2)
#    LET g_action_choice=""
 
   CALL t122_menu()
   CLOSE WINDOW t122_w                 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t122_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
   CLEAR FORM                            
   CALL g_pjma.clear()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" pjma01 = '",g_argv1 CLIPPED,"' " 
   ELSE
      CALL cl_set_head_visible("","YES")    
      INITIALIZE g_pjma01 TO NULL     
      CONSTRUCT BY NAME g_wc ON pjma01    
 
             BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
         ON ACTION controlp
             CASE
                WHEN INFIELD(pjma01)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pjb"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjma01
                   NEXT FIELD pjma01
                OTHERWISE EXIT CASE
             END CASE          
             
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         # 
         CALL cl_about()      # 
 
      ON ACTION help          # 
         CALL cl_show_help()  # 
 
      ON ACTION controlg      # 
         CALL cl_cmdask()     # 
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
	 CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON pjma02,pjma03,pjma04,pjma05,pjmaacti   
              FROM s_pjma[1].pjma02,s_pjma[1].pjma03,s_pjma[1].pjma04,
                   s_pjma[1].pjma05,s_pjma[1].pjmaacti
 
		BEFORE CONSTRUCT
		CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(pjma03)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjy"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjma03
                  NEXT FIELD pjma03
 
              OTHERWISE EXIT CASE
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         # 
         CALL cl_about()      # 
 
      ON ACTION help          # 
         CALL cl_show_help()  # 
 
      ON ACTION controlg      # 
         CALL cl_cmdask()     # 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      END CONSTRUCT
   END IF
      IF INT_FLAG THEN
         RETURN
      END IF
 
 
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           
   #      LET g_wc = g_wc clipped," AND pjbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc clipped," AND pjbgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN     
   #      LET g_wc = g_wc clipped," AND pjbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjbuser', 'pjbgrup')
   #End:FUN-980030
   IF g_wc2 IS NULL THEN LET g_wc2 = " 1=1" END IF
 
   LET g_sql = "SELECT UNIQUE pjma01 ",  
               " FROM pjma_file ",
               " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
               " ORDER BY pjma01 "     
   PREPARE t122_prepare FROM g_sql
   DECLARE t122_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t122_prepare
 
   IF g_wc2 = " 1=1" THEN                  
       LET g_sql_tmp="SELECT UNIQUE pjma01 FROM pjma_file WHERE ",g_wc CLIPPED,
                 " INTO TEMP x"
   ELSE
       LET g_sql_tmp="SELECT UNIQUE pjma01 FROM pjma_file WHERE ",  
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"
   END IF
 
   DROP TABLE x                            
   PREPARE t122_precount_x FROM g_sql_tmp   
   EXECUTE t122_precount_x
 
       LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE t122_precount FROM g_sql
   DECLARE t122_count CURSOR FOR t122_precount
 
END FUNCTION
 
FUNCTION t122_menu()
 
   WHILE TRUE
      CALL t122_bp("G")
      CASE g_action_choice
#        WHEN "insert"
#           IF cl_chk_act_auth() THEN
#              CALL t122_a()
#           END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t122_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t122_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t122_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t122_copy()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
#               CALL t122_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
#               CALL t122_x()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t122_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjma),'','')
            END IF
 
         WHEN "related_document"          
          IF cl_chk_act_auth() THEN
             IF g_pjma01 IS NOT NULL THEN
                LET g_doc.column1 = "pjma01"
                LET g_doc.value1 = g_pjma01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t122_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pjma.clear()
#   INITIALIZE g_pjma.* TO NULL 
   IF s_shut(0) THEN RETURN END IF
   LET g_pjma01= NULL  
   CALL cl_opmsg('a')
   LET g_show='N'
   
   WHILE TRUE
      CALL t122_i("a")                   
 
      IF INT_FLAG THEN                  
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_pjma01) THEN           
         CONTINUE WHILE
      END IF
      IF g_show matches '[YN]' AND g_show='Y' THEN
         CALL t122_b_fill('1=1')
         LET g_rec_b=g_cnt
         CALL t122_b()
      ELSE
         LET g_rec_b = 0  
         CALL t122_b()              
      END IF
      IF g_rec_b = 0 THEN
         CALL cl_err('',9044,0)
      END IF           
      LET g_pjma01_t=g_pjma01      
      EXIT WHILE
   END WHILE
   
END FUNCTION
 
FUNCTION t122_i(p_cmd)
DEFINE
   l_n,l_cnt       LIKE type_file.num5,          # 
   l_msg           LIKE type_file.chr1000,       # 
   p_cmd           LIKE type_file.chr1           # 
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_set_head_visible("","YES") 
 
   DISPLAY g_pjma01 TO pjma01
              
   INPUT g_pjma01 WITHOUT DEFAULTS FROM pjma01    
      BEFORE INPUT   
          LET g_before_input_done = FALSE
          CALL t122_set_entry(p_cmd)
          CALL t122_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE 
           
      AFTER FIELD pjma01
         IF NOT cl_null(g_pjma01) THEN
            IF g_pjma01 != g_pjma01_t OR cl_null(g_pjma01_t) THEN
               SELECT COUNT(*) INTO l_n FROM pjma_file WHERE pjma01 = g_pjma01
               IF l_n > 0  THEN                       #l_n = 0
                  LET g_show='Y'
               END IF
            END IF
           
               CALL t122_pjma01('a') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pjma01:',g_errno,1)
                  LET g_pjma01 = g_pjma01_t
                  DISPLAY  g_pjma01 TO pjma01
                  NEXT FIELD pjma01
               END IF
            END IF    
 
 
      ON ACTION CONTROLF                              
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjma01)                
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjb"
               LET g_qryparam.default1 = g_pjma01
               CALL cl_create_qry() RETURNING g_pjma01
               DISPLAY BY NAME g_pjma01
               CALL t122_pjma01('a')
               NEXT FIELD pjma01
 
            OTHERWISE EXIT CASE
         END CASE
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #
         CALL cl_about()      #
 
      ON ACTION help          #
         CALL cl_show_help()  #
 
      ON ACTION controlg      #
         CALL cl_cmdask()     #
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION t122_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjma01 TO NULL            
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjma.clear()
 
   CALL t122_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjma01=NULL
                                               
      RETURN
   END IF
 
   OPEN t122_cs                          
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjma01=NULL
   ELSE
      OPEN t122_count
      FETCH t122_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t122_fetch('F')                
   END IF
 
END FUNCTION
 
FUNCTION t122_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     
   l_abso          LIKE type_file.num10    
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t122_cs INTO g_pjma01 
      WHEN 'P' FETCH PREVIOUS t122_cs INTO g_pjma01 
      WHEN 'F' FETCH FIRST    t122_cs INTO g_pjma01 
      WHEN 'L' FETCH LAST     t122_cs INTO g_pjma01 
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #
         CALL cl_about()      # 
 
      ON ACTION help          # 
         CALL cl_show_help()  # 
 
      ON ACTION controlg      # 
         CALL cl_cmdask()     # 
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t122_cs INTO g_pjma01  
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjma01,SQLCA.sqlcode,0)
      INITIALIZE g_pjma01 TO NULL  # 
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
   CALL t122_show()
 
END FUNCTION
 
FUNCTION t122_show()
 
   DISPLAY g_pjma01 TO pjma01         
 
   CALL t122_pjma01('d') 
   CALL t122_b_fill(g_wc2) 
#   OPEN t122_count  
#   FETCH t122_count INTO g_row_count 
#   DISPLAY g_row_count TO FORMONLY.cnt                 
   CALL cl_show_fld_cont()                    
END FUNCTION
 
 
FUNCTION t122_r()
  DEFINE l_n,i    LIKE type_file.num5          
        ,l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjma01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjma01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
#   LET g_pjma01_t=g_pjma01
  
   BEGIN WORK
 
   CALL t122_show()
 
   IF cl_delh(0,0) THEN    
       INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjma01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjma01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM pjma_file WHERE pjma01=g_pjma01   
      IF SQLCA.sqlcode THEN                       
         CALL cl_err3("del","pjma_file",g_pjma01,"",SQLCA.sqlcode,"","BODY DELETE",1) 
      ELSE
         CLEAR FORM
         DROP TABLE x                 
         PREPARE t122_precount_x2 FROM g_sql_tmp  
         EXECUTE t122_precount_x2                 
         CALL g_pjma.clear()
         LET g_pjma01 = NULL
         
         OPEN t122_count  
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t122_cs
            CLOSE t122_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t122_count INTO g_row_count 
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t122_cs
            CLOSE t122_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t122_cs
         IF g_row_count>0 THEN
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL t122_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL t122_fetch('/')
           END IF
         END IF  
      END IF
      COMMIT WORK
   END IF
 
#   CLOSE t122_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t122_b()
DEFINE
   l_ac_t          LIKE type_file.num5,       # 
   l_n             LIKE type_file.num5,       # 
   l_cnt           LIKE type_file.num5,       # 
   l_flag          LIKE type_file.chr1,       # 
   l_lock_sw       LIKE type_file.chr1,       # 
   p_cmd           LIKE type_file.chr1,       # 
   l_allow_insert  LIKE type_file.num5,       # 
   l_allow_delete  LIKE type_file.num5,        # 
   l_pjma02        LIKE pjma_file.pjma02
  ,l_pjaclose      LIKE pja_file.pjaclose     #No.FUN-960038
   
   LET g_action_choice = ""
#   INITIALIZE l_ac_t,l_n,l_cnt TO NULL
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjma01) THEN RETURN END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjma01
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
   LET g_pjma01_t=g_pjma01
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT pjma02,pjma03,'',pjma04,'','',pjma05,'',pjmaacti", 
                      " FROM pjma_file",
                      " WHERE pjma01=? AND pjma02=? FOR UPDATE"  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t122_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjma WITHOUT DEFAULTS FROM s_pjma.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pjma01_t = g_pjma01  #BACKUP
            LET g_pjma01_o = g_pjma01  #BACKUP
            LET g_pjma_t.* = g_pjma[l_ac].*          
            LET g_pjma_o.* = g_pjma[l_ac].*  
 
            LET p_cmd='u'
 
            OPEN t122_bcl USING g_pjma01,g_pjma_t.pjma02   
            IF STATUS THEN
               CALL cl_err("OPEN t122_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t122_bcl INTO g_pjma[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjma_t.pjma02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT pjy02,pjy03,pjy04 
                 INTO g_pjma[l_ac].pjy02,g_pjma[l_ac].pjy03,g_pjma[l_ac].pjy04
                 FROM pjy_file
                 WHERE pjy01=g_pjma[l_ac].pjma03
               LET g_pjma[l_ac].amt=g_pjma[l_ac].pjma05*g_pjma[l_ac].pjy04
            END IF
            CALL cl_show_fld_cont()    
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjma[l_ac].* TO NULL 
         LET g_pjma[l_ac].pjma04=1 
         LET g_pjma[l_ac].pjma05=0 
         LET g_pjma[l_ac].pjmaacti='Y'     
         LET g_pjma_t.* = g_pjma[l_ac].*          
         LET g_pjma_o.* = g_pjma[l_ac].*          
         CALL cl_show_fld_cont()      
         NEXT FIELD pjma02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjma_file(pjma01,pjma02,pjma03,pjma04,pjma05,
                              pjmaacti,pjmauser,pjmagrup,
                              pjmamodu,pjmadate,pjmaoriu,pjmaorig)
             VALUES(g_pjma01,g_pjma[l_ac].pjma02,g_pjma[l_ac].pjma03,
                    g_pjma[l_ac].pjma04,g_pjma[l_ac].pjma05,
                    g_pjma[l_ac].pjmaacti,g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN                            
            CALL cl_err3("ins","pjma_file",g_pjma[l_ac].pjma02,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD pjma02                        #default 序 
         IF cl_null(g_pjma[l_ac].pjma02) THEN
            SELECT max(pjma02)+1 INTO g_pjma[l_ac].pjma02
              FROM pjma_file
             WHERE pjma01 = g_pjma01   
            IF cl_null(g_pjma[l_ac].pjma02) THEN
               LET g_pjma[l_ac].pjma02 = 1
            END IF
         END IF
 
      AFTER FIELD pjma02                        #check  
         IF NOT cl_null(g_pjma[l_ac].pjma02) THEN
            IF g_pjma[l_ac].pjma02 != g_pjma_t.pjma02 OR g_pjma_t.pjma02 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjma_file
                WHERE pjma01 = g_pjma01 
                  AND pjma02 = g_pjma[l_ac].pjma02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjma[l_ac].pjma02 = g_pjma_t.pjma02
                  NEXT FIELD pjma02
               END IF
            END IF
            IF g_pjma[l_ac].pjma02<=0 THEN
               CALL cl_err('pjma02','aec-994',0)
               NEXT FIELD pjma02
            END IF
          ELSE
             CALL cl_err('pjma02','apm-915',0)
             NEXT FIELD pjma02
         END IF
 
      AFTER FIELD pjma03  
         IF NOT cl_null(g_pjma[l_ac].pjma03) THEN                
            IF (g_pjma[l_ac].pjma03 != g_pjma_o.pjma03) OR g_pjma_o.pjma03 IS NULL THEN
               CALL t122_pjma03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjma[l_ac].pjma03,g_errno,0)
                  LET g_pjma[l_ac].pjma03 = g_pjma_o.pjma03
                  DISPLAY BY NAME g_pjma[l_ac].pjma03
                  NEXT FIELD pjma03
               END IF
            END IF
         END IF
 
      AFTER FIELD pjma04
       IF NOT cl_null(g_pjma[l_ac].pjma04) THEN
          IF g_pjma[l_ac].pjma04 <= 0 THEN
             CALL cl_err('pjma04','afa-037',0)
             NEXT FIELD pjma04
          END IF  
       END IF        
         
      AFTER FIELD pjma05
         IF NOT cl_null(g_pjma[l_ac].pjma05) THEN
            IF g_pjma[l_ac].pjma05 < 0 THEN
               CALL cl_err('pjma05','afa-040',0)
               NEXT FIELD pjma05
            END IF 
#TQC-840009 --ADD--需求金額改為AFTER FIELD pjma05  之后帶出    
            LET g_pjma[l_ac].amt=g_pjma[l_ac].pjma05*g_pjma[l_ac].pjy04 
            DISPLAY BY NAME g_pjma[l_ac].amt
#TQC-840009 --END--
         END IF
      AFTER FIELD pjmaacti
        IF cl_null(g_pjma[l_ac].pjmaacti) THEN
           LET g_pjma[l_ac].pjmaacti='N'
        END IF
           
      BEFORE DELETE                            
         IF g_pjma_t.pjma02 > 0 AND g_pjma_t.pjma02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjma_file
             WHERE pjma01 = g_pjma01
               AND pjma02= g_pjma_t.pjma02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pjma_file",g_pjma_t.pjma02,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
               IF g_rec_b = 0 THEN                                                 
                  CALL cl_err('',9044,1)                                           
                  CLEAR FORM
                  CALL g_pjMa.clear()
                  SELECT COUNT(UNIQUE pjha01) INTO g_row_count FROM pjMa_file
                  OPEN t122_cs
                  IF g_row_count>0 THEN
                     DISPLAY g_row_count TO cnt
                     IF g_curs_index = g_row_count + 1 THEN
                        LET g_jump = g_row_count
                        CALL t122_fetch('L')
                     ELSE
                        LET g_jump = g_curs_index
                        LET mi_no_ask = TRUE
                        CALL t122_fetch('/')
                     END IF
                  END IF         
                  EXIT INPUT                                          
               END IF
            END IF  
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pjma[l_ac].* = g_pjma_t.*
            CLOSE t122_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjma[l_ac].pjma02,-263,1)
            LET g_pjma[l_ac].* = g_pjma_t.*
         ELSE
            UPDATE pjma_file SET pjma02 = g_pjma[l_ac].pjma02,
                                 pjma03 = g_pjma[l_ac].pjma03,
                                 pjma04 = g_pjma[l_ac].pjma04,
                                 pjma05 = g_pjma[l_ac].pjma05,
                                 pjmaacti = g_pjma[l_ac].pjmaacti,
                                 pjmagrup = g_grup,
                                 pjmadate = g_today
             WHERE pjma01 = g_pjma01
               AND pjma02 = g_pjma[l_ac].pjma02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjma_file",g_pjma01,g_pjma_t.pjma02,SQLCA.sqlcode,"","",1) 
               LET g_pjma[l_ac].* = g_pjma_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
#         LET g_pjma[l_ac].amt=g_pjma[l_ac].pjma05*g_pjma[l_ac].pjy04  #TQC-840009
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjma[l_ac].* = g_pjma_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjma.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t122_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t122_bcl
         COMMIT WORK
#         CALL t122_show()
 
      ON ACTION CONTROLO                         
         IF INFIELD(pjma02) AND l_ac > 1 THEN
            LET g_pjma[l_ac].* = g_pjma[l_ac-1].*
            NEXT FIELD pjma02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjma03)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjy"
               LET g_qryparam.default1 = g_pjma[l_ac].pjma03
               CALL cl_create_qry() RETURNING g_pjma[l_ac].pjma03
               DISPLAY BY NAME g_pjma[l_ac].pjma03        
               CALL  t122_pjma03('d')           
               NEXT FIELD pjma03
               
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
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
 
   CLOSE t122_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t122_pjma03(p_cmd)   
    DEFINE l_pjy02    LIKE pjy_file.pjy02,
           l_pjy03    LIKE pjy_file.pjy03, 
           l_pjy04    LIKE pjy_file.pjy04, 
           l_pjyacti  LIKE pjy_file.pjyacti,
           p_cmd      LIKE type_file.chr1       
 
   LET g_errno = ' '
   SELECT pjy02,pjy03,pjy04,pjyacti
     INTO l_pjy02,l_pjy03,l_pjy04,l_pjyacti
     FROM pjy_file WHERE pjy01 = g_pjma[l_ac].pjma03 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aem-047'   #'mfg3006'
                                  LET l_pjy02 = NULL
                                  LET l_pjy03 = NULL
                                  LET l_pjy04 = NULL
        WHEN l_pjyacti='N'        LET g_errno = '9028'
 
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
 
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pjma[l_ac].pjy02  = l_pjy02
      LET g_pjma[l_ac].pjy03  = l_pjy03
      LET g_pjma[l_ac].pjy04  = l_pjy04
      DISPLAY BY NAME g_pjma[l_ac].pjy02
      DISPLAY BY NAME g_pjma[l_ac].pjy03
      DISPLAY BY NAME g_pjma[l_ac].pjy04
   END IF
 
END FUNCTION
 
FUNCTION t122_pjma01(p_cmd) 
   DEFINE l_pjb01       LIKE pjb_file.pjb01,
          l_pjb03       LIKE pjb_file.pjb03,
          l_pjb15       LIKE pjb_file.pjb15,
          l_pjb16       LIKE pjb_file.pjb16,
          l_pjbacti     LIKE pjb_file.pjbacti,
          l_pja02       LIKE pja_file.pja02,
          l_pjaacti     LIKE pja_file.pjaacti,
          l_pjaclose    LIKE pja_file.pjaclose,  #No.FUN-960038
          p_cmd         LIKE type_file.chr1
 
   LET g_errno = " "
   SELECT pjb01,pjb03,pjb15,pjb16,pjbacti
          INTO l_pjb01,l_pjb03,l_pjb15,l_pjb16,l_pjbacti
          FROM pjb_file
          WHERE pjb02=g_pjma01
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-051'
                           LET l_pjb01 = NULL
                           LET l_pjb03 = NULL
                           LET l_pjb15 = NULL
                           LET l_pjb16 = NULL                       
        WHEN l_pjbacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   SELECT pja02,pjaacti,pjaclose INTO l_pja02,l_pjaacti,l_pjaclose #No.FUN-960038 add pjaclose
          FROM pja_file
          WHERE pja01=l_pjb01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-005'            
                           LET l_pja02=NULL
        WHEN l_pjaacti='N' LET g_errno = '9028'
        WHEN l_pjaclose='Y' LET g_errno = 'abg-503'                #No.FUN-960038 
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pjb01 TO pjb01
      DISPLAY l_pjb03 TO pjb03
      DISPLAY l_pjb15 TO pjb15
      DISPLAY l_pjb16 TO pjb16
      DISPLAY l_pja02 TO pja02
   END IF
   
END FUNCTION
 
FUNCTION t122_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2          LIKE type_file.chr1000
DEFINE p_wc2          STRING     #NO.FUN-910082         
DEFINE l_amt          LIKE type_file.num20_6
   LET g_sql="SELECT pjma02,pjma03,'',pjma04,'','',pjma05,'',pjmaacti",
             " FROM pjma_file",
             " WHERE pjma01= '",g_pjma01,"'",
             " AND ",p_wc2 CLIPPED,   
             " ORDER BY pjma02"
 
   PREPARE t122_pb FROM g_sql
   DECLARE pjma_cs CURSOR FOR t122_pb
   CALL g_pjma.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjma_cs INTO g_pjma[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT pjy02,pjy03,pjy04 INTO g_pjma[g_cnt].pjy02,g_pjma[g_cnt].pjy03,g_pjma[g_cnt].pjy04
                               FROM pjy_file
                              WHERE pjy01=g_pjma[g_cnt].pjma03
      LET l_amt=g_pjma[g_cnt].pjma05*g_pjma[g_cnt].pjy04 
      LET g_pjma[g_cnt].amt=l_amt    
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjma.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION t122_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1           
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjma TO s_pjma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                          
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY         
      ON ACTION first
         CALL t122_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY  
                             
      ON ACTION previous
         CALL t122_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)   
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL t122_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION next
         CALL t122_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                    
 
 
      ON ACTION last
         CALL t122_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)   
           END IF
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
 
FUNCTION t122_copy()
DEFINE l_newno     LIKE pjma_file.pjma01,
       l_oldno     LIKE pjma_file.pjma01,
       l_cnt       LIKE type_file.num5 
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjma01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t122_set_entry('a')
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM pjma01
 
       AFTER FIELD pjma01
          IF l_newno IS NOT NULL THEN                                          
              SELECT count(*) INTO l_cnt FROM pjma_file                        
                  WHERE pjma01 = l_newno                                       
              IF l_cnt > 0 THEN                                                
                 CALL cl_err(l_newno,-239,0)                                   
                  NEXT FIELD pjma01                                            
              END IF                                                           
              SELECT * FROM pjb_file,pja_file
                    WHERE pjb01=pja01 AND pjb02=l_newno
                      AND pjaclose = 'N'         #FUN-960038 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(l_newno,'apj-051',0)
                 NEXT FIELD pjma01
              END IF                                              
           END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(pjma01)                        
                CALL cl_init_qry_var()                                        
                LET g_qryparam.form = "q_pjb"                                 
                LET g_qryparam.default1 = g_pjma01                           
                CALL cl_create_qry() RETURNING l_newno                         
                DISPLAY l_newno TO pjma01 
                LET g_pjma01=l_newno                                                          
                CALL t122_pjma01('a')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pjma01:',g_errno,1)
                  LET g_pjma01 = g_pjma01_t
                  DISPLAY BY NAME g_pjma01  
                END IF                          
                NEXT FIELD pjma01
              OTHERWISE EXIT CASE
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
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_pjma01
   
      ROLLBACK WORK
  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM pjma_file         
       WHERE pjma01=g_pjma01
       INTO TEMP y
 
   UPDATE y
       SET pjma01=l_newno,      
           pjmagrup=g_grup,       
           pjmadate=g_today      
 
   INSERT INTO pjma_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pjma_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE 
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pjma01_t
   SELECT pjma01 INTO g_pjma01 
     FROM pjma_file WHERE pjma01 = l_newno
#   CALL t122_u()
   CALL t122_b()
   #SELECT pjma01 INTO g_pjma01           #FUN-C80046
   #FROM pjma_file WHERE pjma01 = l_oldno #FUN-C80046
   #CALL t122_show()                      #FUN-C80046
  
END FUNCTION
 
FUNCTION t122_bp_refresh()
  DISPLAY ARRAY g_pjma TO s_pjma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL t122_show()
END FUNCTION
 
FUNCTION t122_out()                                                     
   DEFINE   l_sw          LIKE type_file.chr1,                            
            l_i           LIKE type_file.num5,                            
            l_name        LIKE type_file.chr20, 
            l_amt         LIKE type_file.num20_6,                            
            sr            RECORD                                          
            pjb01         LIKE pjb_file.pjb01,
            pja02         LIKE pja_file.pja02,
            pjma01        LIKE pjma_file.pjma01,
            pjb03         LIKE pjb_file.pjb03,
            pjb15         LIKE pjb_file.pjb15,
            pjb16         LIKE pjb_file.pjb16,
            pjma02        LIKE pjma_file.pjma02,
            pjma03        LIKE pjma_file.pjma03,
            pjy02         LIKE pjy_file.pjy02,
            pjma04        LIKE pjma_file.pjma04,
            pjy03         LIKE pjy_file.pjy03,
            pjy04         LIKE pjy_file.pjy04,
            pjma05        LIKE pjma_file.pjma05
#            amt           LIKE type_file.num20_6                   
                          END RECORD                                      
#   IF cl_null(g_pjma01) THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF   
#   IF cl_null(g_wc) AND NOT cl_null(g_pjma01)THEN 
#       LET g_wc ="pjma01='",g_pjma01,"'"
#   END IF
#   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF 
#   IF g_wc2 IS NULL THEN  LET g_wc2 =" 1=1" END IF 
 
    IF cl_null(g_wc) AND cl_null(g_wc2) AND NOT cl_null(g_pjma01)  THEN                                                     
        LET g_wc=" pjma01= '",g_pjma01,"' "                                                                               
    ELSE
      IF NOT cl_null(g_wc) THEN
         IF g_wc = " 1=1" THEN
            IF NOT cl_null(g_wc2) THEN
               LET g_wc = g_wc2   
            END IF
         ELSE 
           IF NOT cl_null(g_wc2) THEN    
              IF g_wc2 = " 1=1" THEN 
                 LET g_wc = g_wc 
              ELSE      
                 LET g_wc = g_wc," AND ",g_wc2
              END IF
           ELSE
              LET g_wc = g_wc            
           END IF 
        END IF 
      ELSE 
        LET g_wc = g_wc2         
      END IF                                            
    END IF                                                                                                                           
   IF cl_null(g_wc)  THEN  CALL cl_err('','9057',0) RETURN END IF 
                                                                                               
   CALL cl_wait()                                                       
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang          
   SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = g_prog
   LET g_sql="SELECT pjb01,pja02,pjma01,pjb03,pjb15,pjb16,pjma02,pjma03,pjy02,pjma04,pjy03,pjy04,pjma05,pjmaacti",
#             " FROM pjma_file,pja_file,pjb_file,pjy_file",               
#             " WHERE pjb_file.pjb01=pja_file.pja01 AND pjb_file.pjb02=pjma_file.pjma01", 
#             " AND pjy_file.pjy01 = pjma03 AND ",g_wc CLIPPED   #," AND ",g_wc2 CLIPPED                                       
              " FROM pjma_file LEFT OUTER JOIN ",
              "    ( pjb_file LEFT OUTER JOIN pja_file ON pjb_file.pjb01 = pja_file.pja01 )  ",
              "                                        ON pjb_file.pjb02 = pjma_file.pjma01  ",
              "               LEFT OUTER JOIN pjy_file ON pjy_file.pjy01 = pjma_file.pjma03  ",
              " WHERE ",g_wc CLIPPED 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'pjma01,pjma02,pjma03,pjma04,pjma05,pjmaacti') RETURNING g_wc
   ELSE 
      LET g_wc = ' '
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY pjma01,pjma02" 
   CALL cl_prt_cs1('apjt122','apjt122',g_sql,g_wc)      
                    
 END FUNCTION                                                            
                    
 
 
FUNCTION t122_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           
   IF p_cmd='a' THEN   
      CALL cl_set_comp_entry("pjma01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t122_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           
      IF p_cmd='u' THEN
         CALL cl_set_comp_entry("pjma01",FALSE)
      END IF
END FUNCTION
#No.FUN-790025
